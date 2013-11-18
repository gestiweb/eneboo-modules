/***************************************************************************
                 in_agregadas.qs  -  description
                             -------------------
    begin                : mar dic 15 2009
    copyright            : (C) 2009 by InfoSiAL S.L.
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
	function init() {
		return this.ctx.interna_init();
	}
	function calculateField(fN:String):String {
		return this.ctx.interna_calculateField(fN);
	}
	function validateForm():Boolean {
		return this.ctx.interna_validateForm();
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var C_DIM:Number = 0;
	var C_SEL:Number = 1;
	var C_NOMBRE:Number = 2;
	var colorDimSel_:Color;
	var colorDimNoSel_:Color;
	
	var xmlTabla_:FLDomDocument;
	function oficial( context ) { interna( context );}
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function configurarTabla() {
		return this.ctx.oficial_configurarTabla();
	}
	function cargarTabla() {
		return this.ctx.oficial_cargarTabla();
	}
	function campoEnLista(campo:String):Boolean {
		return this.ctx.oficial_campoEnLista(campo);
	}
	function cambiarColorFilaTabla(tabla:Object, iFila:Number, colorFila:Color) {
		return this.ctx.oficial_cambiarColorFilaTabla(tabla, iFila, colorFila);
	}
	function tblDimensiones_clicked(fil:Number, col:Number) {
		return this.ctx.oficial_tblDimensiones_clicked(fil, col);
	}
	function colores() {
		return this.ctx.oficial_colores();
	}
	function ponerEnLista(campo:String) {
		return this.ctx.oficial_ponerEnLista(campo);
	}
	function quitarDeLista(campo:String) {
		return this.ctx.oficial_quitarDeLista(campo);
	}
	function colorearFila(iFila:Number) {
		return this.ctx.oficial_colorearFila(iFila);
	}
	function ordenarLista(e1:String, e2:String):Number {
		return this.ctx.oficial_ordenarLista(e1, e2);
	}
	function obtenerXMLAgregada():FLDomDocument {
		return this.ctx.oficial_obtenerXMLAgregada();
	}
	function comprobarTablaAgregada():Boolean {
		return this.ctx.oficial_comprobarTablaAgregada();
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
\end */
function interna_init()
{
	var tblDimensiones:FLTable = this.child("tblDimensiones");
	var cursor:FLSqlCursor = this.cursor();
	connect (cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect (tblDimensiones, "clicked(int, int)", this, "iface.tblDimensiones_clicked");

	this.iface.configurarTabla();
	this.iface.colores();

	switch (cursor.modeAccess()) {
		case cursor.Edit: {
			this.child("fdbNombre").setDisabled(true);
			this.child("fdbFichero").setDisabled(true);
			this.child("fdbCubo").setDisabled(true);
			break;
		}
	}
	this.iface.cargarTabla();
}

function interna_calculateField(fN:String):String
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var valor:String;

	switch (fN) {
		case "cubo": {
			break;
		}
		case "fichero": {
			valor = "in_ag_" + cursor.valueBuffer("nombre");
		}
	}
	return valor;
}

function interna_validateForm():Boolean
{
	if (!this.iface.comprobarTablaAgregada()) {
		return false;
	}
	return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_configurarTabla()
{
	var util:FLUtil = new FLUtil;
	var tblDimensiones:FLTable = this.child("tblDimensiones");
	tblDimensiones.setNumCols(3);
	tblDimensiones.hideColumn(this.iface.C_DIM);
	tblDimensiones.hideColumn(this.iface.C_SEL);
	tblDimensiones.setColumnWidth(this.iface.C_NOMBRE, 200);
	tblDimensiones.setColumnLabels("*", "Dim*Sel*" + util.translate("scripts", "Dimensión"));
}

function oficial_cargarTabla()
{
	var util:FLUtil = new FLUtil;

	var tblDimensiones:FLTable = this.child("tblDimensiones");
	tblDimensiones.setNumRows(0);

	var cursor:FLSqlCursor = this.cursor();
	var tabla:String = cursor.valueBuffer("cubo");
	if (!tabla || tabla == "") {
		return false;
	}

	var contenido:String = util.sqlSelect("flfiles", "contenido", "nombre = '" + tabla + ".mtd'");
	if (!contenido) {
debug("!contenido");
		return false;
	}
debug("contenido = " + contenido);
	if (this.iface.xmlTabla_) {
		delete this.iface.xmlTabla_;
	}
	this.iface.xmlTabla_ = new FLDomDocument;
	this.iface.xmlTabla_.setContent(contenido);
	
	var nombreCampo:String;
	var nodoName:FLDomNode;
	var iFila:Number = 0;
	for (var nodoField:FLDomNode = this.iface.xmlTabla_.namedItem("TMD").firstChild(); nodoField; nodoField = nodoField.nextSibling()) {
		if (nodoField.nodeName() != "field") {
			continue;
		}
		nodoName = nodoField.namedItem("name");
		if (!nodoName) {
			return;
		}
		nombreCampo = nodoName.firstChild().nodeValue();
debug("nombreCampo");
		if (!nombreCampo.startsWith("d_")) {
			continue;
		}
		alias = nodoField.namedItem("alias").firstChild().nodeValue();
		tblDimensiones.insertRows(iFila);
		tblDimensiones.setText(iFila, this.iface.C_DIM, nombreCampo);
		tblDimensiones.setText(iFila, this.iface.C_SEL, (this.iface.campoEnLista(nombreCampo) ? "S" : "N"));
		tblDimensiones.setText(iFila, this.iface.C_NOMBRE, fldireinne.iface.pub_obtenerTraduccionAlias(alias));
		this.iface.colorearFila(iFila);
		iFila++;
	}
	tblDimensiones.repaintContents();
}

function oficial_colorearFila(iFila:Number)
{
	var tblDimensiones:FLTable = this.child("tblDimensiones");
	var colorFila:Color;
	var sel:Boolean = (tblDimensiones.text(iFila, this.iface.C_SEL) == "S");
	if (sel) {
		colorFila = this.iface.colorDimSel_;
	} else {
		colorFila = this.iface.colorDimNoSel_;
	}
	this.iface.cambiarColorFilaTabla(tblDimensiones, iFila, colorFila);
}

function oficial_campoEnLista(campo:String):Boolean
{
	var cursor:FLSqlCursor = this.cursor();
	var lista:String = cursor.valueBuffer("lista");
	if (!lista) {
		return false;
	}
	var esta:Boolean = (lista.find(campo) >= 0);
	return esta;
}

function oficial_bufferChanged(fN:String)
{
	var cursor:FLSqlCursor = this.cursor();
	switch (fN) {
		case "cubo": {
			this.iface.cargarTabla();
			break;
		}
		case "nombre": {
			this.child("fdbFichero").setValue(this.iface.calculateField("fichero"));
			break;
		}
	}
}

function oficial_tblDimensiones_clicked(fil:Number, col:Number)
{
debug("fil " + fil);
debug("col " + col);
	var tblDimensiones:FLTable = this.child("tblDimensiones");
	
	var campo:String = tblDimensiones.text(fil, this.iface.C_DIM);
	var sel:Boolean = (tblDimensiones.text(fil, this.iface.C_SEL) == "S");
	sel = !sel;
	if (sel) {
		this.iface.ponerEnLista(campo);
	} else {
		this.iface.quitarDeLista(campo);
	}
	tblDimensiones.setText(fil, this.iface.C_SEL, (sel ? "S" : "N"));
	this.iface.colorearFila(fil);
	tblDimensiones.repaintContents();
}

function oficial_ponerEnLista(campo:String)
{
	var cursor:FLSqlCursor = this.cursor();
	var lista:String = cursor.valueBuffer("lista");
	var aLista:Array;
	if (lista && lista != "") {
		aLista = lista.split(",");
	} else {
		aLista = [];
	}
	aLista.push(campo);
	aLista.sort(this.iface.ordenarLista);
	lista = aLista.join(",");
	cursor.setValueBuffer("lista", lista);
}

function oficial_quitarDeLista(campo:String)
{
	var cursor:FLSqlCursor = this.cursor();
	var lista:String = cursor.valueBuffer("lista");
	var aLista:Array = lista.split(",");
	var aLista2:Array = [];
	var i2:Number = 0;
	for (var i:Number = 0; i < aLista.length; i++) {
		if (aLista[i] == campo) {
			continue;
		}
		aLista2[i2++] = aLista[i];
	}
	aLista2.sort(this.iface.ordenarLista);
	lista = aLista2.join(",");
	cursor.setValueBuffer("lista", lista);
}

function oficial_ordenarLista(e1:String, e2:String):Number
{
	if (e1 > e2) {
		return 1;
	} else if (e2 > e1) {
		return -1;
	} else {
		return 0;
	}
}

function oficial_cambiarColorFilaTabla(tabla:Object, iFila:Number, colorFila:Color)
{
	var numCol:Number = tabla.numCols();
	for (var iCol:Number = 0; iCol < numCol; iCol++) {
		tabla.setCellBackgroundColor(iFila, iCol, colorFila);
	}
}

function oficial_colores()
{
	this.iface.colorDimSel_ = new Color(255, 200, 200);
	this.iface.colorDimNoSel_ = new Color(255, 255, 255);
}

/** \D Si los metadatos de la tabla agregada han cambiado los actualiza en la tabla flfiles
\end */
function oficial_comprobarTablaAgregada():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var xmlAgregada:FLDomDocument = this.iface.obtenerXMLAgregada();
	var contenido:String = xmlAgregada.toString(4);
	var fichero:String = cursor.valueBuffer("fichero");
	var shaActual:String = util.sha1(contenido);
	var shaAnterior:String = util.sqlSelect("flfiles", "sha", "nombre = '" + fichero + ".mtd'");
	
	if (shaActual != shaAnterior) {
		var res:Number = MessageBox.warning(util.translate("scripts", "Los metadatos de la tabla agregada han cambiado. La tabla se regenerará."), MessageBox.Ok, MessageBox.NoButton);
		var curFiles:FLSqlCursor = new FLSqlCursor("flfiles");
		if (!shaAnterior) {
			curFiles.setModeAccess(curFiles.Insert);
			curFiles.refreshBuffer();
			curFiles.setValueBuffer("nombre", fichero);
			curFiles.setValueBuffer("idmodulo", "fldireinne");
		} else {
			curFiles.select("nombre = '" + fichero + ".mtd'");
			if (!curFiles.first()) {
				return false;
			}
			curFiles.setModeAccess(curFiles.Edit);
			curFiles.refreshBuffer();
		}
		curFiles.setValueBuffer("contenido", contenido);
		curFiles.setValueBuffer("sha", shaActual);
		if (!curFiles.commitBuffer()) {
			return false;
		}
	}
	return true;
}

/** \D Obtiene un documento de metadatos para la tabla agregada eliminando los campos de dimensión que no están en la lista seleccionada por el usuario
@return Documento XML correspondiente a la tabla agregada.
\end */
function oficial_obtenerXMLAgregada():FLDomDocument
{
	var cursor:FLSqlCursor = this.cursor();
	var xmlAgregada:FLDomDocument = new FLDomDocument;
	xmlAgregada.setContent(this.iface.xmlTabla_.toString(4));
	
	var nombreCampo:String;
	var nodoName:FLDomNode;
	var iABorrar:Number = 0;
	var nodosABorrar:Array = [];
	var nombreAgregada:String = cursor.valueBuffer("fichero")
	nombreAgregada = nombreAgregada.left(nombreAgregada.length - 4);
	
	for (var nodoField:FLDomNode = xmlAgregada.namedItem("TMD").firstChild(); nodoField; nodoField = nodoField.nextSibling()) {
		switch (nodoField.nodeName()) {
			case "name": {
				nodoField.firstChild().setNodeValue(nombreAgregada);
				continue;
			}
			case "field": {
				nodoName = nodoField.namedItem("name");
				if (!nodoName) {
					return;
				}
				nombreCampo = nodoName.firstChild().nodeValue();
				if (!nombreCampo.startsWith("d_")) {
					continue;
				}
				if (this.iface.campoEnLista(nombreCampo)) {
					continue;
				}
				nodosABorrar[iABorrar++] = nodoField;
				break;
			}
			case "Schema": {
				nodosABorrar[iABorrar++] = nodoField;
				break;
			}
		}
	}
	for (var i:Number = 0; i < iABorrar; i++) {
		xmlAgregada.namedItem("TMD").removeChild(nodosABorrar[i]);
	}
	return xmlAgregada;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
