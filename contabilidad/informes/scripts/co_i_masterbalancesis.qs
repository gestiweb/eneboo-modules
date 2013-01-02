/***************************************************************************
                 i_masterbalancesis.qs  -  description
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    function oficial( context ) { interna( context ); } 
	function lanzar() {
		return this.ctx.oficial_lanzar();
	}
	function cargarQryReport(cursor:FLSqlCursor, idImpresion:String):Array {
		return this.ctx.oficial_cargarQryReport(cursor, idImpresion);
	}
	function rellenarDatos(idImpresion:String, cursor:FLSqlCursor) {
		return this.ctx.oficial_rellenarDatos(idImpresion, cursor);
	}
	function quitarAsientos(codEjercicio:String):String {
		return this.ctx.oficial_quitarAsientos(codEjercicio);
	}
// 	function crearNodoRow():FLDomNode {
// 		return this.ctx.oficial_crearNodoRow();
// 	}
// 	function dameNodoXML(nodoPadre:FLDomNode, ruta:String, debeExistir:Boolean):FLDomNode {
// 		return this.ctx.oficial_dameNodoXML(nodoPadre, ruta, debeExistir);
// 	}
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
	function pub_cargarQryReport(cursor:FLSqlCursor, idImpresion:String):Array {
		return this.cargarQryReport(cursor, idImpresion);
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

/** \C El botón de impresión lanza el informe
\end */
function interna_init()
{ 
		connect(this.child("toolButtonPrint"), "clicked()", this, "iface.lanzar()");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Lanza el informe 

Se hacen algunas modificacione sobre la consulta del informe:

Se añade un GROUP BY para calcular la suma de saldos de las subcuentas agrupadas por cuenta. Si se marca la opción de consolidar ejercicio, se añaden al WHERE de la consulta los datos del ejercicio anterior para que también sean sumados en el informe resultante.
\end */
function oficial_lanzar()
{
	var util:FLUtil = new FLUtil;

	var cursor:FLSqlCursor = this.cursor()
	if (!cursor.isValid())
		return;
	flcontinfo.iface.numPag = 0;

	var ahora:Date = new Date;
	var idImpresion:String = ahora.getTime().toString();
	idImpresion += sys.nameUser();

	var datos:Array = this.iface.cargarQryReport(cursor, idImpresion);
	if (!datos) {
		return false;
	}
	var q:FLSqlQuery = datos["query"];
	var nombreReport:String = datos["report"];

	var rptViewer:FLReportViewer = new FLReportViewer();
	rptViewer.setReportTemplate(nombreReport);
		rptViewer.setReportData(q);
	rptViewer.renderReport();
	rptViewer.exec();

	if (!util.sqlDelete("co_i_balancesis_buffer", "idimpresion = '" + idImpresion + "'")) {
		return;
	}
}

function oficial_cargarQryReport(cursor:FLSqlCursor, idImpresion:String):Array
{
	var util:FLUtil = new FLUtil();
	var nombreInforme:String = cursor.table();
	var nombreReport:String = nombreInforme;
	var datos:Array;
	if (cursor.valueBuffer("resumido"))
		nombreReport = "co_i_balancesis_res";
	if (cursor.valueBuffer("nivel") == "Subcuenta")
		nombreReport = "co_i_balancesis_scta";
	
	flcontinfo.iface.pub_establecerInformeActual(cursor.valueBuffer("id"), nombreInforme);
	
	this.iface.rellenarDatos(idImpresion, cursor);

	var q:FLSqlQuery = new FLSqlQuery(nombreInforme);
	q.setWhere("idimpresion = '" + idImpresion + "'");

	if (!q.exec()) {
		MessageBox.critical(util.translate("scripts", "Falló la consulta"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return;
	}

	if (!q.size()) {
		MessageBox.warning(util.translate("scripts","No hay registros que cumplan los criterios de búsqueda establecidos"), MessageBox.NoButton);
		return;
	}

	datos["query"] = q;
	datos["report"] = nombreReport;
	return datos;
}

function oficial_rellenarDatos(idImpresion:String, cursor:FLSqlCursor):FLDomDocument
{
	var util:FLUtil = new FLUtil;

	var groupBy:String = "co_cuentas.codcuenta, co_cuentas.descripcion, co_subcuentas.codsubcuenta, co_subcuentas.descripcion";
	var orderBy:String = "co_cuentas.codcuenta, co_cuentas.descripcion, co_subcuentas.codsubcuenta, co_subcuentas.descripcion";

	var ejAct:String = cursor.valueBuffer("i_co__subcuentas_codejercicio");
	var desdeAct:String = cursor.valueBuffer("d_co__asientos_fecha");
	var hastaAct:String = cursor.valueBuffer("h_co__asientos_fecha");
	var desdeScta:String = cursor.valueBuffer("d_co__subcuentas_codsubcuenta");
	var hastaScta:String = cursor.valueBuffer("h_co__subcuentas_codsubcuenta");
	
	var nivel:Number
	
	// Subcuenta por compatibilidad hacia atras
	if (cursor.valueBuffer("nivel") == "Cuenta" || cursor.valueBuffer("nivel") == "Subcuenta")
		nivel = 0;
	else
		nivel = parseFloat(cursor.valueBuffer("nivel"));
		
	var where:String = "(co_asientos.codejercicio = '" + ejAct + "'" +
		" AND co_asientos.fecha >= '" + desdeAct + "'" +
		" AND co_asientos.fecha <= '" + hastaAct + "'";
		 
	if (desdeScta)
		where += " AND co_partidas.codsubcuenta >= '" + desdeScta + "'";
		
	if (hastaScta)
		where += " AND co_partidas.codsubcuenta <= '" + hastaScta + "'";
	
	var listaAsientos:String = this.iface.quitarAsientos(ejAct);
	if (listaAsientos && listaAsientos != "") {
		where += " AND co_asientos.idasiento NOT IN (" + listaAsientos + ")";
	}

	where += ")";


	var consolidar:Boolean = false;
	if (cursor.valueBuffer("ejercicioanterior") == 1)
			consolidar = true;

	if (consolidar) {
		var ejAnt:String = cursor.valueBuffer("codejercicioant");
		var desdeAnt:String = cursor.valueBuffer("fechaant_d");
		var hastaAnt:String = cursor.valueBuffer("fechaant_h");
		desdeScta = cursor.valueBuffer("d_co__subcuentas_codsubcuenta");
		hastaScta = cursor.valueBuffer("h_co__subcuentas_codsubcuenta");
			
		where +=  " OR (co_asientos.codejercicio = '" + ejAnt + "'" +
			" AND co_asientos.fecha >= '" + desdeAnt + "'" +
			" AND co_asientos.fecha <= '" + hastaAnt + "'" +
			" AND co_partidas.codsubcuenta >= '" + desdeScta + "'" +
			" AND co_partidas.codsubcuenta <= '" + hastaScta + "'";
		
		var listaAsientosAnt:String = this.iface.quitarAsientos(ejAnt);
		if (listaAsientosAnt && listaAsientosAnt != "") {
			where += " AND co_asientos.idasiento NOT IN (" + listaAsientos + ")";
		}

		where += ")";
	}
	
	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList("co_cuentas,co_subcuentas,co_partidas,co_asientos");
	q.setFrom("co_cuentas INNER JOIN co_subcuentas ON co_cuentas.idcuenta = co_subcuentas.idcuenta INNER JOIN co_partidas ON co_subcuentas.idsubcuenta = co_partidas.idsubcuenta INNER JOIN co_asientos ON co_partidas.idasiento = co_asientos.idasiento");
	q.setSelect("co_cuentas.codcuenta, co_cuentas.descripcion, co_subcuentas.codsubcuenta, co_subcuentas.descripcion, SUM(co_partidas.debe), SUM(co_partidas.haber), SUM(co_partidas.debe)-SUM(co_partidas.haber)");
	q.setWhere(where + " group by " + groupBy + " ORDER BY " + orderBy);
	
	if (!q.exec()) {
		MessageBox.critical(util.translate("scripts", "Falló la consulta"),
				MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return;
	}

 	util.createProgressDialog( util.translate( "scripts", "Recabando datos..." ), q.size() );
	var codCuenta:String;
	
	var curTab:FLSqlCursor = new FLSqlCursor("co_i_balancesis_buffer");
 	var paso:Number = 0;	
	
// 	var xmlKD:FLDomDocument = new FLDomDocument;
// 	xmlKD.setContent("<!DOCTYPE KUGAR_DATA><KugarData/>");
// 	var nodoRow:FLDomNode;
// 	var eRow:FLDomElement;
	var debe:Number, haber:Number, saldo:Number;
	var codCuentaAnt:String = "";
	while(q.next()) {
		
		util.setProgress(paso++);
		
		debe = util.roundFieldValue(q.value(4), "co_subcuentas", "debe");
		haber = util.roundFieldValue(q.value(5), "co_subcuentas", "haber")
		saldo = util.roundFieldValue(q.value(6), "co_subcuentas", "saldo")

		codSubcuenta = q.value(2);
		if (nivel == 0) {
			codCuenta = q.value(0);
		} else {
			codCuenta = codSubcuenta.left(nivel);
		}
		
		switch(nivel) {
			case 0:
				descCuenta = util.sqlSelect("co_cuentas", "descripcion", "codcuenta = '" + codCuenta + "' AND codejercicio = '" + ejAct + "'");
			break;				
			case 2:
				descCuenta = util.sqlSelect("co_epigrafes", "descripcion", "codepigrafe = '" + codCuenta + "' AND codejercicio = '" + ejAct + "'");
			break;				
			case 3:
				descCuenta = util.sqlSelect("co_cuentas", "descripcion", "codcuenta LIKE '" + codCuenta + "%' AND codejercicio = '" + ejAct + "'");
			break;				
			case 4:
			case 5:
				descCuenta = util.sqlSelect("co_cuentas", "descripcion", "codcuenta = '" + codCuenta + "' AND codejercicio = '" + ejAct + "'");
				if (!descCuenta)
					descCuenta = util.sqlSelect("co_cuentas", "descripcion", "codcuenta LIKE '" + codCuenta.left(3) + "%' AND codejercicio = '" + ejAct + "'");
			break;				
		}
		
		if (!descCuenta)
			descCuenta = q.value(3); 
		
		curTab.select("idimpresion = '" + idImpresion + "' AND codsubcuenta = '" + codSubcuenta + "'");
// 		nodoRow = this.iface.dameNodoXML(xmlKD.firstChild(), "Row[@co_i_balancesis_buffer.codsubcuenta=" + codSubcuenta + "]");
			
		if (curTab.first()/* && nodoRow*/) {
			/// Con tabla
			curTab.setModeAccess(curTab.Edit);
			curTab.refreshBuffer();
			curTab.setValueBuffer("debe", parseFloat(curTab.valueBuffer("debe")) + parseFloat(debe));
			curTab.setValueBuffer("haber", parseFloat(curTab.valueBuffer("haber")) + parseFloat(haber));
			curTab.setValueBuffer("saldo", parseFloat(curTab.valueBuffer("saldo")) + parseFloat(saldo));
			/// Con XML
// 			eRow = nodoRow.toElement();
// 			eRow.setAttribute("co_i_balancesis_buffer.debe", parseFloat(eRow.attribute("co_i_balancesis_buffer.debe")) + parseFloat(debe));
// 			eRow.setAttribute("co_i_balancesis_buffer.haber", parseFloat(eRow.attribute("co_i_balancesis_buffer.haber")) + parseFloat(haber));
// 			eRow.setAttribute("co_i_balancesis_buffer.saldo", parseFloat(eRow.attribute("co_i_balancesis_buffer.saldo")) + parseFloat(saldo));
		} else {
			/// Con tabla
			curTab.setModeAccess(curTab.Insert);
			curTab.refreshBuffer();
			curTab.setValueBuffer("idimpresion", idImpresion);
			curTab.setValueBuffer("codsubcuenta", codSubcuenta);
			curTab.setValueBuffer("codcuenta", codCuenta);
			curTab.setValueBuffer("descripcion", q.value(3));
			curTab.setValueBuffer("descripcioncuenta", descCuenta);
			curTab.setValueBuffer("debe", debe);
			curTab.setValueBuffer("haber", haber);
			curTab.setValueBuffer("saldo", saldo);
			/// Con XML
// 			if (codCuenta != codCuentaAnt) {
// 				level = 0;
// 			} else {
// 				level = 1;
// 				codCuenta = codCuentaAnt;
// 			}
// 			nodoRow = this.iface.crearNodoRow();
// 			xmlKD.firstChild().appendChild(nodoRow);
// 			eRow = nodoRow.toElement();
// 			eRow.setAttribute("empresa.nombre", flfactppal.iface.valorDefectoEmpresa("nombre"));
// 			eRow.setAttribute("co_i_balancesis_buffer.codcuenta", codCuenta);
// 			eRow.setAttribute("co_i_balancesis_buffer.codsubcuenta", codSubcuenta);
// 			eRow.setAttribute("co_i_balancesis_buffer.descripcion", q.value(3));
// 			eRow.setAttribute("co_i_balancesis_buffer.descripcioncuenta", descCuenta);
// 			eRow.setAttribute("co_i_balancesis_buffer.debe", debe);
// 			eRow.setAttribute("co_i_balancesis_buffer.haber", haber);
// 			eRow.setAttribute("co_i_balancesis_buffer.saldo", saldo);
// 			eRow.setAttribute("level", level);
// 			if (level == 0) {
// 				var nodoL1:FLDomNode = nodoRow.cloneNode();
// 				nodoL1.toElement().setAttribute("level", 1);
// 				xmlKD.firstChild().appendChild(nodoL1);
// 			}
		}
		
		curTab.commitBuffer();
	}
	
	util.destroyProgressDialog();
// 	return xmlKD;
}

// function oficial_crearNodoRow():FLDomNode
// {
// 	var xmlRow:FLDomDocument = new FLDomDocument;
// 	xmlRow.setContent("<Row/>");
// 	return xmlRow.firstChild();
// }

function oficial_quitarAsientos(codEjercicio:String):String
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var listaAsientos:String = "";
	var asientoPyG:String;
	var asientoCierre:String;
	
	if (cursor.valueBuffer("ignorarcierre")) {
		asientoPyG = util.sqlSelect("ejercicios", "idasientopyg", "codejercicio = '" + codEjercicio + "'");
		if (!asientoPyG) {
			asientoPyG = -1;
		}
		asientoCierre = util.sqlSelect("ejercicios", "idasientocierre", "codejercicio = '" + cursor.valueBuffer("i_co__subcuentas_codejercicio") + "'");
		if (!asientoCierre) {
			asientoCierre = -1;
		}
	
		listaAsientos += asientoPyG + ", "	+ asientoCierre;
	}
	return listaAsientos;
}


/** \C Busca un nodo en un nodo y sus nodos hijos
@param	nodoPadre: Nodo que contiene el nodo a buscar (o los nodos hijos que lo contienen)
@param	ruta: Cadena que especifica la ruta a seguir para encontrar el atributo. Su formato es NodoPadre/NodoHijo/NodoNieto/.../Nodo. Puede ser tan larga como sea necesario. Siempre se toma el primer nodo Hijo que tiene el nombre indicado.
@param	debeExistir: Si vale true la función devuelve false si no encuentra el atributo
@return	Nodo buscado o false si hay error o no se encuentra el nodo
\end */
// function oficial_dameNodoXML(nodoPadre:FLDomNode, ruta:String, debeExistir:Boolean):FLDomNode
// {
// 	var util:FLUtil = new FLUtil;
// 
// 	var valor:String;
// 	var nombreNodo:Array = ruta.split("/");
// 	var nodoXML:FLDomNode = nodoPadre;
// 	var i:Number;
// 	var nombreActual:String;
// 	var iInicioCorchete:Number
// 	for (i = 0; i < nombreNodo.length; i++) {
// 		nombreActual = nombreNodo[i];
// 		iInicioCorchete = nombreActual.find("[");
// 		if (iInicioCorchete > -1) {
// 			iFinCorchete = nombreActual.find("]");
// 			var condicion:String = nombreActual.substring(iInicioCorchete + 1, iFinCorchete);
// 			var paramCond:Array = condicion.split("=");
// 			if (!paramCond[0].startsWith("@")) {
// 				MessageBox.warning(util.translate("scripts", "Error al procesar la ruta XML %1 en %2").arg(ruta).arg(nombreActual), MessageBox.Ok, MessageBox.NoButton);
// 				return false;
// 			}
// 			nombreActual = nombreActual.left(iInicioCorchete);
// 			var atributo:String = paramCond[0].right(paramCond[0].length - 1);
// 			var nodoHijo:FLDomNode;
// 			for (nodoHijo = nodoXML.firstChild(); nodoHijo; nodoHijo = nodoHijo.nextSibling()) {
// 				if (nodoHijo.nodeName() == nombreActual && nodoHijo.toElement().attribute(atributo) == paramCond[1]) {
// 					break;
// 				}
// 			}
// 			if (nodoHijo) {
// 				nodoXML = nodoHijo;
// 			} else {
// 				if (debeExistir) {
// 					MessageBox.warning(util.translate("scripts", "No se encontró el nodo en la ruta ruta %1").arg(ruta), MessageBox.Ok, MessageBox.NoButton);
// 				}
// 				return false;
// 			}
// 		} else {
// 			nodoXML = nodoXML.namedItem(nombreActual)
// 			if (!nodoXML) {
// 				if (debeExistir) {
// 					MessageBox.warning(util.translate("scripts", "No se pudo leer el nodo de la ruta:\n%1.\nNo se encuentra el nodo <%2>").arg(ruta).arg(nombreNodo[i]), MessageBox.Ok, MessageBox.NoButton);
// 				}
// 				return false;
// 			}
// 		}
// 	}
// 	return nodoXML;
// }

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
