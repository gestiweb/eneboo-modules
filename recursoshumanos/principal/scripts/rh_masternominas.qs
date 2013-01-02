/***************************************************************************
                 rh_masternominas.qs  -  description
                             -------------------
    begin                : lun sep 17 2007
    copyright            : (C) 2007 by InfoSiAL S.L.
    email                : mail@infosial.com
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/

/** @file */

/** @class_declaration interna */
////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
class interna {
	var ctx:Object;
	function interna( context ) { this.ctx = context; }
	function init() { this.ctx.interna_init(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var tdbRecords:Object;
	var pbnGenerarNominas:Object;
	var curNomina:FLSqlCursor;
	var mensajeErrorFIniFin:String;
	var mensajeErrorFDesde:String;
    function oficial( context ) { interna( context ); }
	function generarNominas_clicked() {
		return this.ctx.oficial_generarNominas_clicked();
	}
	function generarNomina(curEmpleado:FLSqlCursor, xmlNomina:FLDomNode):String {
		return this.ctx.oficial_generarNomina(curEmpleado, xmlNomina);
	}
	function datosNomina(curEmpleados:FLSqlCursor, xmlNomina:FLDomNode):Boolean {
		return this.ctx.oficial_datosNomina(curEmpleados, xmlNomina);
	}
	function whereAgrupacion(curAgrupar:FLSqlCursor):String {
		return this.ctx.oficial_whereAgrupacion(curAgrupar);
	}
	function asociarDietasNomina(xmlNomina:FLDomNode):Boolean {
		return this.ctx.oficial_asociarDietasNomina(xmlNomina);
	}
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends oficial {
    function head( context ) { oficial ( context ); }
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration ifaceCtx */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends head {
    function ifaceCtx( context ) { head( context ); }
	function pub_whereAgrupacion(curAgrupar:FLSqlCursor):String {
		return this.whereAgrupacion(curAgrupar);
	}
}

const iface = new ifaceCtx( this );
//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition interna */
////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
/** \C
Este es el formulario maestro de nóminas de empleados.
\end */
function interna_init()
{
	this.iface.tdbRecords = this.child("tableDBRecords");
	this.iface.mensajeErrorFIniFin = "";
	this.iface.mensajeErrorFDesde = "";
	this.iface.pbnGenerarNominas = this.child("pbnGenerarNominas");

	connect(this.iface.pbnGenerarNominas, "clicked()", this, "iface.generarNominas_clicked");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \C
Al pulsar el botón de generar nóminas se abre la ventana correspondiente
\end */
function oficial_generarNominas_clicked()
{
	var util:FLUtil = new FLUtil;
	var f:Object = new FLFormSearchDB("rh_generarnominas");
	var cursor:FLSqlCursor = f.cursor();
	var where:String;
	var codEjercicio:String;
	var fecha:Date;
	this.iface.mensajeErrorFIniFin = "";
	this.iface.mensajeErrorFDesde = "";
	cursor.setActivatedCheckIntegrity(false);
	cursor.select();
	if (!cursor.first())
			cursor.setModeAccess(cursor.Insert);
	else
			cursor.setModeAccess(cursor.Edit);

	f.setMainWidget();
	cursor.refreshBuffer();
	var acpt:String = f.exec("id");
	var idGN:Number = cursor.valueBuffer("id");

	if (acpt) {
		cursor.commitBuffer();
		var curGenerarNominas:FLSqlCursor = new FLSqlCursor("rh_generarnominas");
		curGenerarNominas.select("id = " + idGN);

		if (curGenerarNominas.first()) {
			var fechaNomina:Date = curGenerarNominas.valueBuffer("fechanomina");
			var fechaEmision:Date = curGenerarNominas.valueBuffer("fecha");
			where = this.iface.whereAgrupacion(curGenerarNominas);
			var lista:String = curGenerarNominas.valueBuffer("lista");
			var xmlLista:FLDomDocument = new FLDomDocument;
			if (!xmlLista.setContent(lista))
				return false;

			var xmlNominas:FLDomNodeList = xmlLista.elementsByTagName("FLNomina");
			if (!xmlNominas)
				return false;

			var totalNominas:Number = xmlNominas.length()
			util.createProgressDialog(util.translate("scripts", "Generando nóminas"), totalNominas);
			util.setProgress(0);
	
			var curEmpleados :FLSqlCursor= new FLSqlCursor("rh_empleados");
			var whereNomina:String;
			var xmlNomina:FLDomNode;
			for (var i:Number = 0; i < totalNominas; i++) {
				xmlNomina= xmlNominas.item(i);
				xmlNomina.toElement().setAttribute("CodEjercicio", xmlLista.firstChild().toElement().attribute("CodEjercicio"));
				xmlNomina.toElement().setAttribute("Fecha", xmlLista.firstChild().toElement().attribute("Fecha"));
				xmlNomina.toElement().setAttribute("FechaNomina", xmlLista.firstChild().toElement().attribute("FechaNomina"));
				whereNomina = "codempleado = '" + xmlNomina.toElement().attribute("CodEmpleado") + "'";

				curEmpleados.transaction(false);
				curEmpleados.select(whereNomina);
				if (!curEmpleados.first()) {
					curEmpleados.rollback();
					util.destroyProgressDialog();
					return;
				}
				try {
					var fechaInicio:Date = curEmpleados.valueBuffer("finicio");
					var fechaFin:Date = curEmpleados.valueBuffer("ffin");
					var fechaDesde:Date = curEmpleados.valueBuffer("fechadesde");
	
					if (fechaDesde)
						fechaDesde.setDate(1);
					var codNomina:String = "";
	
					if (!fechaDesde || util.daysTo(fechaDesde, fechaNomina) > 0) {
						codNomina = this.iface.generarNomina(curEmpleados, xmlNomina);
	
						if (codNomina && codNomina != "") {
							var fechaFinNomina:Date = curGenerarNominas.valueBuffer("fecha");
							var fechaFinNomina = fechaFinNomina.setMonth(fechaFinNomina.getMonth() + 1);
							var fechaFinNomina = fechaFinNomina.setDate(1);
	
							if (util.daysTo(fechaNomina,fechaInicio) > 0 || (util.daysTo(fechaFin,fechaFinNomina) > 0 && fechaFin)) {
								this.iface.mensajeErrorFIniFin += util.translate("scripts", "    Nómina %1 - %2 %3").arg(codNomina).arg(curEmpleados.valueBuffer("nombre")).arg(curEmpleados.valueBuffer("apellidos")) + "\n";
							}
							curEmpleados.commit();
						} else {
							curEmpleados.rollback();
							util.destroyProgressDialog();
							return;
						}
	
					} else {
						this.iface.mensajeErrorFDesde += "    " + curEmpleados.valueBuffer("codempleado") + " - " + curEmpleados.valueBuffer("nombre") + " " + curEmpleados.valueBuffer("apellidos") + "\n";
					}
	
					if (!codNomina || codNomina == "")
						curEmpleados.rollback();
				} catch (e) {
					curEmpleados.rollback();
					MessageBox.critical(util.translate("scripts", "Error al generar la nómina de %1 %2 (%3):").arg(curEmpleados.valueBuffer("nombre")).arg(curEmpleados.valueBuffer("apellidos")).arg(curEmpleados.valueBuffer("codempleado")) + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
				}

				util.setProgress(i);
			}

			util.setProgress(totalNominas);
			util.destroyProgressDialog();

			if (this.iface.mensajeErrorFDesde && this.iface.mensajeErrorFDesde != "") {
				MessageBox.information(util.translate("scripts", "No se ha podido generar una nómina para los siguientes empleados ya que sus condiciones salariales no son correctas \n\n%1").arg(this.iface.mensajeErrorFDesde), MessageBox.Ok, MessageBox.NoButton);
			}
			if (this.iface.mensajeErrorFIniFin && this.iface.mensajeErrorFIniFin != "") {
				MessageBox.information(util.translate("scripts", "Los datos salariales de las siguientes nóminas pueden no ser correctos debedo a las fechas de inicio y fin de contrato\n\n%1").arg(this.iface.mensajeErrorFIniFin), MessageBox.Ok, MessageBox.NoButton);
			}
		}
		f.close();
	}
	this.iface.tdbRecords.refresh();
}

/** \D
Construye la sentencia WHERE de la consulta que buscará los empleados para los que se generarán las nóminas
@param curGenerarNominas: Cursor de la tabla rh_generarnominas que contiene los valores de los criterios de búsqueda
@return Sentencia where
\end */
function oficial_whereAgrupacion(curGenerarNominas:FLSqlCursor):String
{
	var fecha:Date = curGenerarNominas.valueBuffer("fechanomina");
	var fFin:Date = curGenerarNominas.valueBuffer("fechanomina");
	var mes:Number = fFin.getMonth() + 1;
	fFin = fFin.setMonth(mes);
	fFin = fFin.setDate(1);

	var empleadosConNomina:String;
	
	var qryEmpleadosNomina = new FLSqlQuery;
	qryEmpleadosNomina.setTablesList("rh_nominas");
	qryEmpleadosNomina.setSelect("codempleado");
	qryEmpleadosNomina.setFrom("rh_nominas");
	qryEmpleadosNomina.setWhere("fechanomina = '" + fecha + "'");
	if (!qryEmpleadosNomina.exec())
			return;

	if(qryEmpleadosNomina.first()) {
		
		do {
			if (empleadosConNomina != "")
				empleadosConNomina += ", ";
			empleadosConNomina += "'" + qryEmpleadosNomina.value("codempleado") + "'";
		} while (qryEmpleadosNomina.next());
	}

	var where:String = "finicio <= '" + fecha + "' AND (ffin IS NULL OR (ffin > '" + fFin + "') OR (ffin > '" + fecha + "' AND ffin < '" + fFin + "'))";
	if (empleadosConNomina != "")
		where += " AND codempleado NOT IN (" + empleadosConNomina + ")";
	
	return where;
}

/** \D 
Genera la nomina de un empleado
@param codEjercicio: Código del ejercicio de la nómina
@param fecha: Fecha de la nómina
@param curEmpleado: Cursor con los datos principales que se copiarán del empleado a la nómina
@return Identificador de la nómina generada. FALSE si hay error
\end */
function oficial_generarNomina(curEmpleado:FLSqlCursor, xmlNomina:FLDomNode):String
{
	var util:FLUtil = new FLUtil();
	
	if (!this.iface.curNomina)
		this.iface.curNomina = new FLSqlCursor("rh_nominas");

	var hoy:Date = new Date();
	var codEjercicio = xmlNomina.toElement().attribute("CodEjercicio");
	var fechaEmision:Date = new Date(Date.parse(xmlNomina.toElement().attribute("Fecha")));
	var fechaNomina:Date = new Date(Date.parse(xmlNomina.toElement().attribute("FechaNomina")));
	fechaNomina = fechaNomina.setDate(1);
	var descripcion:String = util.dateAMDtoDMA(fechaNomina).right(7) + " - " + curEmpleado.valueBuffer("nombre") + " " + curEmpleado.valueBuffer("apellidos");
	codNomina = util.nextCounter("codnomina", this.iface.curNomina);

	this.iface.curNomina.setModeAccess(this.iface.curNomina.Insert);
	this.iface.curNomina.refreshBuffer();

	this.iface.curNomina.setValueBuffer("codnomina", codNomina);
	this.iface.curNomina.setValueBuffer("codempleado", curEmpleado.valueBuffer("codempleado"));
	this.iface.curNomina.setValueBuffer("fechanomina", fechaNomina);
	this.iface.curNomina.setValueBuffer("fecha", fechaEmision);
	this.iface.curNomina.setValueBuffer("codejercicio", codEjercicio);
	this.iface.curNomina.setValueBuffer("descripcion", formRecordrh_nominas.iface.pub_commonCalculateField("descripcion", this.iface.curNomina));
	this.iface.curNomina.setValueBuffer("estadonomina", formRecordrh_nominas.iface.pub_commonCalculateField("estadonomina", this.iface.curNomina));
	if (!this.iface.curNomina.commitBuffer())
		return false;

	this.iface.curNomina.select("codnomina = '" + codNomina + "'");
	if (!this.iface.curNomina.first())
		return false;

	this.iface.curNomina.setModeAccess(this.iface.curNomina.Edit);
	this.iface.curNomina.refreshBuffer();
	if (!this.iface.datosNomina(curEmpleado, xmlNomina))
		return false;

	if (!this.iface.curNomina.commitBuffer())
		return false;

	return codNomina;
}

/** \D Informa los datos de una nómina a partir de los de un empleado
@param	curEmpleado: Cursor que contiene los datos a incluir en la nomina
@param	xmlNomina: Nodo XML con datos asociados a la nómina a generar
@return	True si el cálculo se realiza correctamente, false en caso contrario
\end */
function oficial_datosNomina(curEmpleado:FLSqlCursor, xmlNomina:FLDomNode):Boolean
{
	if (!this.iface.asociarDietasNomina(xmlNomina))
		return false;

	with (this.iface.curNomina) {
		setValueBuffer("sueldobruto", formRecordrh_nominas.iface.pub_commonCalculateField("sueldobruto", this));
		setValueBuffer("segsocial", formRecordrh_nominas.iface.pub_commonCalculateField("segsocial", this));
		setValueBuffer("irpf", formRecordrh_nominas.iface.pub_commonCalculateField("irpf", this));
		setValueBuffer("dietas", formRecordrh_nominas.iface.pub_commonCalculateField("dietas", this));
		setValueBuffer("sueldoneto", formRecordrh_nominas.iface.pub_commonCalculateField("sueldoneto", this));
	}
	
	return true;
}

/** \D Asocia a un registro de nómina las dietas pendientes del empleado
@param	xmlNomina: Nodo XML con datos asociados a la nómina a generar
@return	True si el cálculo se realiza correctamente, false en caso contrario
\end */
function oficial_asociarDietasNomina(xmlNomina:FLDomNode):Boolean
{
	var util:FLUtil = new FLUtil;

	var codNomina:String = this.iface.curNomina.valueBuffer("codnomina");
	var xmlDietas:FLDomNodeList = xmlNomina.toElement().elementsByTagName("FLDieta");
	if (xmlDietas) {
		var idDieta:String;
		for (var i:Number = 0; i < xmlDietas.length(); i++) {
			idDieta = xmlDietas.item(i).toElement().attribute("IdDieta");
			if (!util.sqlUpdate("rh_dietas", "codnomina", codNomina, "iddieta = " + idDieta))
				return false;
		}
	}
	return true;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
