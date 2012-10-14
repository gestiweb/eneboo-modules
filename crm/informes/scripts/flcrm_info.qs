/***************************************************************************
                 flcrm_info.qs  -  description
                             -------------------
    begin                : mar may 15 2007
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
		function crearInforme(nombreInforme:String) {
		return this.ctx.oficial_crearInforme(nombreInforme);
	}
	function lanzarInforme(cursor:FLSqlCursor, nombreInforme:String, orderBy:String, groupBy:String, etiquetas:Boolean, impDirecta:Boolean, whereFijo:String, nombreReport:String, numCopias:Number, impresora:String) {
		return this.ctx.oficial_lanzarInforme(cursor, nombreInforme, orderBy, groupBy, etiquetas, impDirecta, whereFijo, nombreReport, numCopias, impresora);
	}
	function logo(nodo:FLDomNode, campo:String):String {
		return this.ctx.oficial_logo(nodo, campo);
	}
	function establecerConsulta(cursor:FLSqlCursor, nombreConsulta:String, orderBy:String, groupBy:String, whereFijo:String):FLSqlQuery {
		return this.ctx.oficial_establecerConsulta(cursor, nombreConsulta, orderBy, groupBy, whereFijo);
	}
	function obtenerSigno(s:String):String {
		return this.ctx.oficial_obtenerSigno(s);
	}
	function fieldName(s:String):String {
		return this.ctx.oficial_fieldName(s);
	}
	function mostrarClienteProveedorIncidencia(nodo:FLDomNode, campo:String):String {
		return this.ctx.oficial_mostrarClienteProveedorIncidencia(nodo, campo);
	}
	function mostrarTituloIncidencias(nodo:FLDomNode, campo:String):String {
		return this.ctx.oficial_mostrarTituloIncidencias(nodo, campo);
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
	function pub_logo(nodo:FLDomNode, campo:String):String {
		return this.logo(nodo, campo);
	}
	function pub_mostrarClienteProveedorIncidencia(nodo:FLDomNode, campo:String):String {
		return this.mostrarClienteProveedorIncidencia(nodo, campo);
	}
	function pub_mostrarTituloIncidencias(nodo:FLDomNode, campo:String):String {
		return this.mostrarTituloIncidencias(nodo, campo);
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
function interna_init() {
	var util:FLUtil = new FLUtil;
	util.writeSettingEntry("kugar/banner", "\0");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Establece la fila y columna de la primera etiqueta a imprimir para los informes de etiquetas
\end */
// function oficial_seleccionEtiquetaInicial():Array
// {
// 	var etiquetaInicial:Array = [];
// 	etiquetaInicial["fila"] = 0;
// 	etiquetaInicial["col"] = 0;
// 	var util:FLUtil = new FLUtil;
// 	var dialog:Object = new Dialog;
// 	dialog.caption = util.translate("scripts","Elegir fila y columna a imprimir");
// 	dialog.okButtonText = util.translate("scripts","Aceptar");
// 	dialog.cancelButtonText = util.translate("scripts","Cancelar");
// 
// 	var text:Object = new Label;
// 	text.text = util.translate("scripts","Ha seleccionado un informe de etiquetas,\nelija la fila y la columna a imprimir:");
// 	dialog.add(text);
// 
// 	var spbNumColum:Object= new SpinBox;
// 	spbNumColum.label = util.translate("scripts","Columnas");
// 	spbNumColum.minimum = 1;
// 	spbNumColum.maximum = 30;
// 	dialog.add(spbNumColum);
// 
// 	var spbNumFila:Object = new SpinBox;
// 	spbNumFila.label = util.translate("scripts","Filas");
// 	spbNumFila.minimum = 1;
// 	spbNumFila.maximum = 30;
// 	dialog.add(spbNumFila);
// 
// 	if (dialog.exec()){
// 		etiquetaInicial["fila"] = spbNumFila.value;
// 		etiquetaInicial["col"] = spbNumColum.value;
// 	}
// 	return etiquetaInicial;
// }

/** \D
Lanza un informe
@param	cursor: Cursor con los criterios de búsqueda para la consulta base del informe
@param	nombreinforme: Nombre del informe
@param	orderBy: Cláusula ORDER BY de la consulta base
@param	groupBy: Cláusula GROUP BY de la consulta base
@param	etiquetas: Indicador de si se trata de un informe de etiquetas
@param	impDirecta: Indicador para imprimir directaemnte el informe, sin previsualización
@param	whereFijo: Sentencia where que debe preceder a la sentencia where calculada por la función
\end */
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
	
	if (q.exec() == false) {
		debug("*********** CONSULTA ************" + q.sql());
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

/** \D
Obtiene el nombre del campo de la cadena s desde su segunda posición. Sustituye '_' por '.', dos '_" seguidos indica que realmente es '_"
@param	s: Nombre del campo que contiene un criterio de búsqueda
@return	Nombre procesado
\end */
function oficial_fieldName(s:String):String
{
		var fN:String = "";
		var c:String;
		for (var i:Number = 2; (s.toString().charAt(i)); i++) {
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

/** \D
Obtiene el operador lógico a aplicar en la cláusula where de la consulta a partir de los primeros caracteres del parámetro
@param	s: Nombre del campo que contiene un criterio de búsqueda
@return	Operador lógico a aplicar
\end */
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

/** \D
Obtiene el xpm del logo de la empresa
@return xpm del logo
*/
function oficial_logo(nodo:FLDomNode, campo:String):String
{
	var util:FLUtil = new FLUtil;
	return util.sqlSelect("empresa", "logo", "1 = 1");
}

function oficial_mostrarClienteProveedorIncidencia(nodo:FLDomNode, campo:String):String
{
	var valor:String;

	var codCliente:String = nodo.attributeValue("crm_incidencias.codcliente");

	if(codCliente && codCliente != "")
		valor = "C: " + codCliente + " - " + nodo.attributeValue("clientes.nombre");
	else {
		var codProveedor:String = nodo.attributeValue("crm_incidencias.codproveedor");
		if(codProveedor && codProveedor != "")
			valor = "P: " + codProveedor + " - " + nodo.attributeValue("proveedores.nombre");
	}

	return valor;
}

function oficial_mostrarTituloIncidencias(nodo:FLDomNode, campo:String):String
{
	return "Informe de incidencias";
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
