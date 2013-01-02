/***************************************************************************
                 co_i_balancesis.qs  -  description
                             -------------------
    begin                : lun abr 26 2004
    copyright            : (C) 2004 by InfoSiAL S.L.
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
	function validateForm():Boolean { return this.ctx.interna_validateForm(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var ejercicioActual:String;
	var ejercicioAnterior:String;
	var longSubcuenta:Number;
	var bloqueoSubcuenta:Boolean;
	var cuentaHastaInformada:Boolean
    function oficial( context ) { interna( context ); } 
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function deshabilitarSubcuentas(valor_disabled:Boolean) {
		return this.ctx.oficial_deshabilitarSubcuentas(valor_disabled);
	}
	function todasSubcuentas() {
		return this.ctx.oficial_todasSubcuentas();
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
Si no existe otro ejercicio más antiguo que el actual, los campos de ejercicio anterior aparecerán deshabilitados. Si existe algún ejercicio previo al actual, aparecerá como ejercicio anterior en el formulario aquel ejercicio más reciente de entre los pasados.

En modo inserción aparece seleccionada la opcion --todassubcuentas--, y aparece como subcuenta inicial la de menor código y como subcuenta final la de mayor código
\end */
function interna_init()
{
	this.iface.cuentaHastaInformada = false;
	
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	if (cursor.modeAccess() == cursor.Insert)
		this.iface.todasSubcuentas();

	this.iface.longSubcuenta = util.sqlSelect("ejercicios", "longsubcuenta", "codejercicio = '" + this.iface.ejercicioActual + "'");

	if (cursor.modeAccess() == cursor.Edit) {
		if (this.child("fdbTodasSubcuentas").value())
			this.iface.todasSubcuentas();
	}

	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	this.child("fdbDescripcion").setFocus();
}

/** \C 
La fecha de inicio del período de un ejercicio no puede ser posterior que la fecha de fin

Las fechas deben estar comprendidas dentro del período de cada ejercicio

Para poder realizar el balance sobre más de un ejercicio es necesario que ambos tengan igual número de dígitos en las subcuentas
\end */
function interna_validateForm():Boolean
{
	var fechaDesde:String;
	var fechaHasta:String;
	var fechaInicio:String;
	var fechaFin:String;

	var fechaInicioAct:String;
	var fechaFinAnt:String;

	var util:FLUtil = new FLUtil();
	var q:FLSqlQuery = new FLSqlQuery();

	var ejercicioAct:String = this.child("fdbEjercicioAct").value();
	fechaDesde = this.child("fdbFechaDesdeAct").value();
	fechaHasta = this.child("fdbFechaHastaAct").value();

	if (util.daysTo(fechaDesde, fechaHasta) < 0) {
		MessageBox.critical(util.translate("scripts", "La fecha de inicio del ejercicio actual debe ser menor que la de fin"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	q.setTablesList("ejercicios");
	q.setSelect("fechainicio, fechafin");
	q.setFrom("ejercicios");
	q.setWhere("codejercicio = '" + ejercicioAct + "';");

	q.exec();

	if (q.next()) {
		fechaInicio = q.value(0);
		fechaFin = q.value(1);
		fechaFinAnt = fechaFin;
	}

	if ((util.daysTo(fechaHasta, fechaFin) < 0) || (util.daysTo(fechaDesde, fechaInicio) > 0)) {
		MessageBox.critical(util.translate("scripts", "Las fechas de inicio y fin del ejercicio actual deben estar dentro del propio intervalo del ejercicio"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	if (!this.child("fdbEjercicioAnterior").value())
			return true;


	var ejercicioAnt:String = this.child("fdbEjercicioAnt").value();

	if (!flcontinfo.iface.pub_comprobarConsolidacion(ejercicioAct, ejercicioAnt)) {
		MessageBox.critical(util.translate("scripts", "Las subcuentas de los ejercicios deben tener la misma longitud"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	fechaDesde = this.child("fdbFechaDesdeAnt").value();
	fechaHasta = this.child("fdbFechaHastaAnt").value();

	if (util.daysTo(fechaDesde, fechaHasta) < 0) {
		MessageBox.critical(util.translate("scripts", "La fecha de inicio del ejercicio anterior debe ser menor que la de fin"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	q.setTablesList("ejercicios");
	q.setSelect("fechainicio, fechafin");
	q.setFrom("ejercicios");
	q.setWhere("codejercicio = '" + ejercicioAnt + "';");
	q.exec();

	if (q.next()) {
		fechaInicio = q.value(0);
		fechaInicio = fechaInicio.toString();
		fechaFin = q.value(1);
		fechaFin = fechaFin.toString();
		fechaFinAnt = fechaFin;
	}

	if ((util.daysTo(fechaHasta, fechaFin) < 0) || (util.daysTo(fechaDesde, fechaInicio) > 0)) {
		MessageBox.critical(util.translate("scripts", "Las fechas de inicio y fin del ejercicio anterior deben estar dentro del propio intervalo del ejercicio"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_bufferChanged(fN:String)
{
	var codSubcuenta:String;

	switch (fN) {

	/**	\C
	Al introducir --d_co__subcuentas_codsubcuenta--, si el usuario pulsa la tecla "punto" (.), la subcuenta se informa automaticamente con el código de cuenta más tantos ceros como sea necesario para completar la longitud de subcuenta asociada al ejercicio actual.
			\end \end */
	case "d_co__subcuentas_codsubcuenta":

		if (!this.iface.bloqueoSubcuenta
				&& this.child("fdbCodSubcuentaDesde").value().endsWith(".")) {

				codSubcuenta =
						this.child("fdbCodSubcuentaDesde").value().toString();
				codSubcuenta = codSubcuenta.substring(0, codSubcuenta.length - 1);
				var numCeros:Number = this.iface.longSubcuenta - codSubcuenta.length;

				for (var i:Number = 0; i < numCeros; i++)
						codSubcuenta += "0";

				this.iface.bloqueoSubcuenta = true;

				this.child("fdbCodSubcuentaDesde").setValue(codSubcuenta);

				if (!this.iface.cuentaHastaInformada) {
						this.child("fdbCodSubcuentaHasta").setValue(codSubcuenta);
				}

				this.iface.bloqueoSubcuenta = false;
		}

		if (!this.iface.bloqueoSubcuenta
				&& this.child("fdbCodSubcuentaDesde").value().length ==
				this.iface.longSubcuenta) {
				if (!this.iface.cuentaHastaInformada) {
						this.child("fdbCodSubcuentaHasta").setValue(codSubcuenta);
				}
		}
		break;

	/** \C
	Al introducir --h_co__subcuentas_codsubcuenta--, si el usuario pulsa la tecla "punto" (.), la subcuenta se informa automaticamente con el código de cuenta más tantos ceros como sea necesario para completar la longitud de subcuenta asociada al ejercicio actual.
	\end */
	case "h_co__subcuentas_codsubcuenta":

		this.iface.cuentaHastaInformada = true;
		if (!this.iface.bloqueoSubcuenta
				&& this.child("fdbCodSubcuentaHasta").value().endsWith(".")) {

				codSubcuenta =
						this.child("fdbCodSubcuentaHasta").value().toString();
				codSubcuenta = codSubcuenta.substring(0, codSubcuenta.length - 1);
				var numCeros:Number = this.iface.longSubcuenta - codSubcuenta.length;

				for (var i:Number = 0; i < numCeros; i++)
						codSubcuenta += "0";

				this.iface.bloqueoSubcuenta = true;
				this.child("fdbCodSubcuentaHasta").setValue(codSubcuenta);
				this.iface.bloqueoSubcuenta = false;
		}

		if (!this.iface.bloqueoSubcuenta
				&& this.child("fdbCodSubcuentaHasta").value().length ==
				this.iface.longSubcuenta) {
		}
	
	break;



	/** \C
	Al pulsar sobre --todassubcuentas-- aparece como subcuenta inicial la de menor código y como subcuenta final la de mayor código
	\end */
	case "todassubcuentas":

		if (this.child("fdbTodasSubcuentas").value())
			this.iface.todasSubcuentas();
		else {
			this.iface.bloqueoSubcuenta = true;
			this.child("fdbCodSubcuentaDesde").setValue("");
			this.child("fdbCodSubcuentaHasta").setValue("");
			this.iface.bloqueoSubcuenta = false;
			this.iface.cuentaHastaInformada = false;
			this.iface.deshabilitarSubcuentas(false);
		}

	break;
	
	}
}

/** \D Se deshabilitan o habilitan los campos de subcuenta
@param valor_disabled Valor booleano que indica si se deshabilita o habilita
\end */
function oficial_deshabilitarSubcuentas(valor_disabled:Boolean)
{
	this.child("fdbCodSubcuentaDesde").setDisabled(valor_disabled);
	this.child("fdbIdSubcuentaDesde").setDisabled(valor_disabled);
	this.child("fdbCodSubcuentaHasta").setDisabled(valor_disabled);
	this.child("fdbIdSubcuentaHasta").setDisabled(valor_disabled);
}

/** \D Se buscan los códigos de subcuenta mayor y menor dentro de la tabla de subcuentas. Se llama cuando se pulsa --todassubcuentas--
\end */
function oficial_todasSubcuentas()
{
	var codEjercicioAct:String = this.child("fdbEjercicioAct").value();
	var codEjercicioAnt:String = this.child("fdbEjercicioAnt").value();

	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList("co_subcuentas");
	q.setSelect("MIN(codsubcuenta), MAX(codsubcuenta)");
	q.setFrom("co_subcuentas");
	q.setWhere("codejercicio = '" + codEjercicioAct +
							"' OR codejercicio = '" + codEjercicioAnt + "'");
	q.exec();

	if (q.first()) {

		var subcuentaInicio:String = q.value(0);
		var subcuentaFin:String = q.value(1);

		this.iface.bloqueoSubcuenta = true;

		this.child("fdbCodSubcuentaDesde").setValue(subcuentaInicio);
		this.child("fdbCodSubcuentaHasta").setValue(subcuentaFin);

		this.iface.deshabilitarSubcuentas(true);

		this.iface.bloqueoSubcuenta = false;
	}
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
