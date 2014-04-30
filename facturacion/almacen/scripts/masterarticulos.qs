/***************************************************************************
                 masterarticulos.qs  -  description
                             -------------------
    begin                : jue jun 28 2007
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
	var curArticulo:FLSqlCursor;
	var curTarifa:FLSqlCursor;
	var curArticuloProv:FLSqlCursor;
	var curArticuloAgen:FLSqlCursor;
	var tdbRecords:FLTableDB;
	var toolButtonCopy:Object;
	function oficial( context ) { interna( context ); }
	function copiarArticulo_clicked() {
		return this.ctx.oficial_copiarArticulo_clicked();
	}
	function copiarArticulo(refOriginal:String):String {
		return this.ctx.oficial_copiarArticulo(refOriginal);
	}
	function copiarAnexosArticulo(refOriginal:String, refNueva:String):Boolean {
		return this.ctx.oficial_copiarAnexosArticulo(refOriginal, refNueva);
	}
	function copiarTablaTarifas(refOriginal:String, refNueva:String):Boolean {
		return this.ctx.oficial_copiarTablaTarifas(refOriginal, refNueva);
	}
	function copiarTablaArticulosProv(refOriginal:String, refNueva:String):Boolean {
		return this.ctx.oficial_copiarTablaArticulosProv(refOriginal, refNueva);
	}
	function copiarTablaArticulosAgen(refOrigen:String, refNueva:String):Boolean {
		return this.ctx.oficial_copiarTablaArticulosAgen(refOrigen, refNueva);
	}
	function datosArticuloAgen(cursor:FLSqlCursor, campo:String):Boolean {
		return this.ctx.oficial_datosArticuloAgen(cursor, campo);
	}
	function datosArticulo(cursor:FLSqlCursor, campo:String):Boolean {
		return this.ctx.oficial_datosArticulo(cursor, campo);
	}
	function datosTarifa(cursor:FLSqlCursor, campo:String):Boolean {
		return this.ctx.oficial_datosTarifa(cursor, campo);
	}
	function datosArticuloProv(cursor:FLSqlCursor, campo:String):Boolean {
		return this.ctx.oficial_datosArticuloProv(cursor, campo);
	}
	function copiarAnexosArticuloProv(idArtProvOrigen:String, idArtProvNuevo:String):Boolean {
		return this.ctx.oficial_copiarAnexosArticuloProv(idArtProvOrigen, idArtProvNuevo);
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
/** \C El Al copiar un artículo se copian también sus tarifas y sus precios por proveedor.
\end */
function interna_init()
{
	this.iface.tdbRecords = this.child("tableDBRecords");
	this.iface.toolButtonCopy = this.child("toolButtonCopy");
	connect(this.iface.toolButtonCopy, "clicked()", this, "iface.copiarArticulo_clicked()");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_copiarArticulo_clicked()
{
	var util:FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	if (!cursor.isValid()) {
		return;
	}
// 	var referencia:String = this.iface.curArticulo.valueBuffer("referencia");
	var referencia:String = cursor.valueBuffer("referencia");
	var curTransaccion:FLSqlCursor = new FLSqlCursor("empresa");
	curTransaccion.transaction(false);

	if (!referencia) {
		MessageBox.information(util.translate("scripts", "No hay ningún registro seleccionado"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}

	try {
		if (this.iface.copiarArticulo(referencia)) {
			curTransaccion.commit();
		} else {
			curTransaccion.rollback();
			MessageBox.warning(util.translate("scripts", "Hubo un error al copiar el artículo %1").arg(referencia), MessageBox.Ok, MessageBox.NoButton);
		}
	}
	catch (e) {
		curTransaccion.rollback();
		MessageBox.critical(util.translate("scripts", "Hubo un error al copiar el artículo %1").arg(referencia) + ":\n" + e, MessageBox.Ok, MessageBox.NoButton);
	}
	
	this.iface.tdbRecords.refresh();

	return true;
}

function oficial_copiarArticulo(refOriginal:String):String
{
	var util:FLUtil;

    var nuevaReferencia = Input.getText(util.translate("scripts", "Introduzca la nueva referencia:"), "", util.translate("scripts", "Copiar artículo"));
    if (!nuevaReferencia || nuevaReferencia == "") {
		MessageBox.warning(util.translate("scripts", "Debe introducir una referencia para crear el nuevo artículo."), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	if (util.sqlSelect("articulos","referencia","referencia = '" + nuevaReferencia + "'")) {
		MessageBox.warning(util.translate("scripts", "Ya existe un artículo con esa referencia"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var curArticuloOrigen:FLSqlCursor = new FLSqlCursor("articulos");
	curArticuloOrigen.select("referencia = '" + refOriginal + "'");
	if (!curArticuloOrigen.first()) {
		return false;
	}
	curArticuloOrigen.setModeAccess(curArticuloOrigen.Browse);
	curArticuloOrigen.refreshBuffer();
	
	if (!this.iface.curArticulo) {
		this.iface.curArticulo = new FLSqlCursor("articulos");
	}
	this.iface.curArticulo.setModeAccess(this.iface.curArticulo.Insert);
	this.iface.curArticulo.refreshBuffer();
	this.iface.curArticulo.setValueBuffer("referencia", nuevaReferencia);

	var campos:Array = util.nombreCampos("articulos");
	var totalCampos:Number = campos[0];
	for (var i:Number = 1; i <= totalCampos; i++) {
		if (!this.iface.datosArticulo(curArticuloOrigen, campos[i])) {
			return false;
		}
	}

	if (!this.iface.curArticulo.commitBuffer()) {
		return false;
	}

	if (!this.iface.copiarAnexosArticulo(refOriginal, nuevaReferencia)) {
		return false;
	}
	
	return nuevaReferencia;
}

function oficial_datosArticulo(cursor:FLSqlCursor, campo:String):Boolean 
{
	if (!campo || campo == "") {
		return false;
	}
	switch (campo) {
		case "referencia": {
			return true;
			break;
		}
		case "stockfis": {
			this.iface.curArticulo.setValueBuffer(campo, 0);
			break;
		}
		case "codbarras": {
			this.iface.curArticulo.setValueBuffer(campo, "");
			break;
		}
		default: {
			if (cursor.isNull(campo)) {
				this.iface.curArticulo.setNull(campo);
			} else {
				this.iface.curArticulo.setValueBuffer(campo, cursor.valueBuffer(campo));
			}
		}
	}
	return true;
}

function oficial_copiarAnexosArticulo(refOriginal:String, refNueva:String):Boolean
{
	if (!this.iface.copiarTablaTarifas(refOriginal, refNueva)) {
		return false;
	}
	if (!this.iface.copiarTablaArticulosProv(refOriginal, refNueva)) {
		return false;
	}
	if (!this.iface.copiarTablaArticulosAgen(refOriginal, refNueva)) {
		return false;
	}
	return true;
}

function oficial_copiarTablaTarifas(refOriginal:String, nuevaReferencia:String):Boolean
{
	var util:FLUtil;

	if (!this.iface.curTarifa) {
		this.iface.curTarifa = new FLSqlCursor("articulostarifas");
	}
	
	var campos:Array = util.nombreCampos("articulostarifas");
	var totalCampos:Number = campos[0];

	var curTarifaOrigen:FLSqlCursor = new FLSqlCursor("articulostarifas");
	curTarifaOrigen.select("referencia = '" + refOriginal + "'");
	while (this.iface.curTarifa.next()) {
		this.iface.curTarifa.setModeAccess(this.iface.curTarifa.Insert);
		this.iface.curTarifa.refreshBuffer();
		this.iface.curTarifa.setValueBuffer("referencia", nuevaReferencia);
	
		for (var i:Number = 1; i <= totalCampos; i++) {
			if (!this.iface.datosTarifa(curTarifaOrigen, campos[i])) {
				return false;
			}
		}

		if (!this.iface.curTarifa.commitBuffer()) {
			return false;
		}
	}

	return true;
}

function oficial_copiarTablaArticulosProv(refOriginal:String, nuevaReferencia:String):Boolean
{
	var util:FLUtil;

	if (!this.iface.curArticuloProv) {
 		this.iface.curArticuloProv = new FLSqlCursor("articulosprov");
	}
	
	var campos:Array = util.nombreCampos("articulosprov");
	var totalCampos:Number = campos[0];

	var idArtProvNuevo:String, idArtProvOrigen:String;
	var curArticuloProvOrigen:FLSqlCursor = new FLSqlCursor("articulosprov");
	curArticuloProvOrigen.select("referencia = '" + refOriginal + "'");
	while (curArticuloProvOrigen.next()) {
		this.iface.curArticuloProv.setModeAccess(this.iface.curArticuloProv.Insert);
		this.iface.curArticuloProv.refreshBuffer();
		this.iface.curArticuloProv.setValueBuffer("referencia", nuevaReferencia);
	
		for (var i:Number = 1; i <= totalCampos; i++) {
			if (!this.iface.datosArticuloProv(curArticuloProvOrigen, campos[i])) {
				return false;
			}
		}

		if (!this.iface.curArticuloProv.commitBuffer()) {
			return false;
		}
		idArtProvOrigen = curArticuloProvOrigen.valueBuffer("id");
		idArtProvNuevo = this.iface.curArticuloProv.valueBuffer("id");
		if (!this.iface.copiarAnexosArticuloProv(idArtProvOrigen, idArtProvNuevo)) {
			return false;
		}
	}

	return true;
}

function oficial_copiarAnexosArticuloProv(idArtProvOrigen:String, idArtProvNuevo:String):Boolean
{
	return true;
}

function oficial_copiarTablaArticulosAgen(refOrigen:String, nuevaReferencia:String):Boolean
{
	var util:FLUtil;

	if (!this.iface.curArticuloAgen) {
		this.iface.curArticuloAgen = new FLSqlCursor("articulosagen");
	}
	
	var campos:Array = util.nombreCampos("articulosagen");
	var totalCampos:Number = campos[0];

	var curArticuloAgenOrigen:FLSqlCursor = new FLSqlCursor("articulosagen");
	curArticuloAgenOrigen.select("referencia = '" + refOrigen + "'");
	while (curArticuloAgenOrigen.next()) {
		this.iface.curArticuloAgen.setModeAccess(this.iface.curArticuloAgen.Insert);
		this.iface.curArticuloAgen.refreshBuffer();
		this.iface.curArticuloAgen.setValueBuffer("referencia", nuevaReferencia);
	
		for (var i:Number = 1; i <= totalCampos; i++) {
			if (!this.iface.datosArticuloAgen(curArticuloAgenOrigen, campos[i])) {
				return false;
			}
		}

		if (!this.iface.curArticuloAgen.commitBuffer()) {
			return false;
		}
	}

	return true;
}

function oficial_datosTarifa(cursorOrigen:FLSqlCursor, campo:String):Boolean
{
	if (!campo || campo == "") {
		return false;
	}
	switch (campo) {
		case "id":
		case "referencia": {
			return true;
			break;
		}
		default: {
			if (cursorOrigen.isNull(campo)) {
				this.iface.curTarifa.setNull(campo);
			} else {
				this.iface.curTarifa.setValueBuffer(campo, cursorOrigen.valueBuffer(campo));
			}
		}
	}
	return true;
}

function oficial_datosArticuloAgen(cursorOrigen:FLSqlCursor,campo:String):Boolean
{
	if (!campo || campo == "") {
		return false;
	}
	switch (campo) {
		case "id":
		case "referencia": {
			return true;
			break;
		}
		default: {
			if (cursorOrigen.isNull(campo)) {
				this.iface.curArticuloAgen.setNull(campo);
			} else {
				this.iface.curArticuloAgen.setValueBuffer(campo, cursorOrigen.valueBuffer(campo));
			}
		}
	}
	return true;
}

function oficial_datosArticuloProv(cursorOrigen:FLSqlCursor,campo:String):Boolean
{
	if (!campo || campo == "") {
		return false;
	}
	switch (campo) {
		case "id":
		case "referencia": {
			return true;
			break;
		}
		default: {
			if (cursorOrigen.isNull(campo)) {
				this.iface.curArticuloProv.setNull(campo);
			} else {
				this.iface.curArticuloProv.setValueBuffer(campo, cursorOrigen.valueBuffer(campo));
			}
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
