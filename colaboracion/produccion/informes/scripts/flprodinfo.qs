/***************************************************************************
                 flprodinfo.qs  -  description
                             -------------------
    begin                : vie ago 10 2007
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
    function oficial( context ) { interna( context ); }
	function crearInforme(nombreInforme:String) {
		this.ctx.oficial_crearInforme(nombreInforme);
	} 
	function lanzarInforme(cursor:FLSqlCursor, nombreInforme:String, orderBy:String, groupBy:String, etiquetas:Boolean, impDirecta:Boolean, whereFijo:String, nombreReport:String, numCopias:Number, impresora:String) {
		return this.ctx.oficial_lanzarInforme(cursor, nombreInforme, orderBy, groupBy, etiquetas, impDirecta, whereFijo, nombreReport, numCopias, impresora);
	}
	function obtenerSigno(s:String):String {
		return this.ctx.oficial_obtenerSigno(s);
	}
	function fieldName(s:String):String {
		return this.ctx.oficial_fieldName(s);
	}
	function construirWhere(cursor:FLSqlCursor):String {
		return this.ctx.oficial_construirWhere(cursor);
	}
	function establecerConsulta(cursor:FLSqlCursor, nombreConsulta:String, orderBy:String, groupBy:String, whereFijo:String):FLSqlQuery {
		return this.ctx.oficial_establecerConsulta(cursor, nombreConsulta, orderBy, groupBy, whereFijo);
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
	function pub_lanzarInforme(cursor:FLSqlCursor, nombreInforme:String, orderBy:String, groupBy:String, etiquetas:Boolean, impDirecta:Boolean, whereFijo:String, nombreReport:String, numCopias:Number, impresora:String) {
	return this.lanzarInforme(cursor, nombreInforme, orderBy, groupBy, etiquetas, impDirecta, whereFijo, nombreReport, numCopias, impresora);
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

function init() {
    this.iface.init();
}

function interna_init() {

}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_crearInforme(nombreInforme:String)
{
		if (this.iface.establecerCriteriosBusqueda(nombreInforme) == true);
			this.iface.lanzarInforme(nombreInforme);
}

function oficial_lanzarInforme(cursor:FLSqlCursor, nombreInforme:String, orderBy:String, groupBy:String, etiquetas:Boolean, impDirecta:Boolean, whereFijo:String, nombreReport:String, numCopias:Number, impresora:String)
{
	var util:FLUtil = new FLUtil();
	var etiquetaInicial:Array = [];
	if (etiquetas == true) {
		etiquetaInicial = this.iface.seleccionEtiquetaInicial();
	} else {
		etiquetaInicial["fila"] = 0;
		etiquetaInicial["col"] = 0;
	}

	var q:FLSqlQuery = this.iface.establecerConsulta(cursor, nombreInforme, orderBy, groupBy, whereFijo);
debug("------ CONSULTA -------" + q.sql());
	if (q.exec() == false) {
		MessageBox.critical(util.translate("scripts", "Falló la consulta"), MessageBox.Ok, MessageBox.NoButton);
		return;
	} else {
		if (q.first() == false) {
			MessageBox.warning(util.translate("scripts", "No hay registros que cumplan los criterios de búsqueda establecidos"), MessageBox.Ok, MessageBox.NoButton);
			return;
		}
	}

	if (!nombreReport) 
		nombreReport = nombreInforme;
			
	var rptViewer:FLReportViewer = new FLReportViewer();
	rptViewer.setReportTemplate(nombreReport);
	rptViewer.setReportData(q);
	rptViewer.renderReport(etiquetaInicial.fila, etiquetaInicial.col);
	if (numCopias)
		rptViewer.setNumCopies(numCopias);
	if (impresora) {
		try {
			rptViewer.setPrinterName(impresora);
		}
		catch (e) {}
	}
		
	if (impDirecta)
		rptViewer.printReport();
	else
		rptViewer.exec();
}


function oficial_obtenerSigno(s:String):String
{
		if (s.toString().charAt(1) == "_") {
				switch(s.toString().charAt(0)) {
						case "d": {
								return ">=";
						}
						case "h": {
								return "<=";
						}
						case "i": {
								return "=";
						}
				}
		}
		return  "";
}

// Obtiene el nombre del campo de la cadena s desde su segunda posici?n.
// sustituye '_' por '.', dos '_" seguidos indica que realmente es '_"
function oficial_fieldName(s:String):String
{
		var fN:String = "";
		var c:String;
		for (var i = 2; (s.toString().charAt(i)); i++) {
				c = s.toString().charAt(i);
				if (c == "_")
						if (s.toString().charAt(i + 1) == "_") {
								fN += "_";
								i++;
						} else
								fN += "."
				else
						fN += s.toString().charAt(i);
		}
		return fN;
}

function oficial_construirWhere(cursor:FLSqlCursor):String {
		var util:FLUtil = new FLUtil();
		var fieldList:Array = util.nombreCampos(cursor.table());
		var cuenta:Number = parseFloat(fieldList[0]);

		var signo:String;
		var fN:String;
		var valor:Number;
		var primerCriterio:Boolean = false;
		var where:String = "";
		for (var i:Number = 1; i <= cuenta; i++) {
				signo = this.iface.obtenerSigno(fieldList[i]);
				if (signo != "") {
						fN = this.iface.fieldName(fieldList[i]);
						valor = cursor.valueBuffer(fieldList[i]);
						if (valor == util.translate("scripts", "Sí"))
								valor = 1;
						if (valor == util.translate("scripts", "No"))
								valor = 0;
						if (valor == util.translate("scripts", "Todos"))
								valor = "";
						if (!valor.toString().isEmpty()) {
								if (primerCriterio == true)
											where += "AND ";
								where += fN + " " + signo + " '" + valor + "' ";
								primerCriterio = true;
						}
				}
		}
		return where;
}

/** \D Establece la consulta del informe, creando el where a partir de los campos del cursor
@param	cursor: Cursor posicionado en un registro de criterios de búsqueda
@param	nombreConsulta: Nombre del fichero con la descripción de la consulta
@param	orderBy: Cláusula Order By
@param	groupBy: Cláusula Group By
@param	whereFijo: Cláusula Where que se añade al construido a partir de los campos del cursor
@return	consulta o false si hay error
\end */
function oficial_establecerConsulta(cursor:FLSqlCursor, nombreConsulta:String, orderBy:String, groupBy:String, whereFijo:String):FLSqlQuery
{
	var util:FLUtil = new FLUtil();
	var q:FLSqlQuery = new FLSqlQuery(nombreConsulta);
	var fieldList:String = util.nombreCampos(cursor.table());
	var cuenta:Number = parseFloat(fieldList[0]);

	var signo:String;
	var fN:String;
	var valor:String;
	var primerCriterio:Boolean = false;
	var where:String = "";
	for (var i:Number = 1; i <= cuenta; i++) {
		if (cursor.isNull(fieldList[i]))
			continue;
		signo = this.iface.obtenerSigno(fieldList[i]);
		if (signo != "") {
			fN = this.iface.fieldName(fieldList[i]);
			valor = cursor.valueBuffer(fieldList[i]);
			if (valor == "Sí")
				valor = 1;
			if (valor == "No")
				valor = 0;
			if (valor == "Todos")
				valor = "";
			if (!valor.toString().isEmpty()) {
				if (primerCriterio == true)
					where += "AND ";
				where += fN + " " + signo + " '" + valor + "' ";
				primerCriterio = true;
			}
		}
	}
	if (whereFijo && whereFijo != "") {
		if (where == "")
			where = whereFijo;
		else
			where = whereFijo + " AND (" + where + ")";
	}
		
	if (groupBy && groupBy != "") {
		if (where == "")
			where = "1 = 1";
		where += " GROUP BY " + groupBy;
	}
	q.setWhere(where);
	
	if (orderBy)
		q.setOrderBy(orderBy);
	
	return q;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


