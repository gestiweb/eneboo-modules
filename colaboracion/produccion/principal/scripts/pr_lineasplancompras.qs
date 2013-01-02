/***************************************************************************
                 pr_lineasplancompras.qs  -  description
                             -------------------
    begin                : vie mar 12 2010
    copyright            : (C) 2010 by InfoSiAL S.L.
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	function oficial( context ) { interna( context ); }
	function cargarDatosCompra() {
		return this.ctx.oficial_cargarDatosCompra();
	}
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
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
	function pub_datosCompra():Array {
		return this.datosCompra();
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
function interna_init()
{
	var cursor:FLSqlCursor = this.cursor();
	
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");

	switch (cursor.modeAccess()) {
		case cursor.Insert: {
			connect(this, "formReady()", this, "iface.cargarDatosCompra()");
			break;
		}
	}
}

function interna_calculateField(fN:String):String
{
	var cursor:FLSqlCursor = this.cursor();
	var valor:String;
	switch (fN) {
		case "incremento": {
			valor = parseFloat(cursor.valueBuffer("cantidad")) - parseFloat(cursor.valueBuffer("canprevia"));
			break;
		}
	}
	return valor;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_cargarDatosCompra()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var aDatos:Array = formRecordpr_plancompras.iface.pub_datosCompra();
	if (!aDatos) {
		MessageBox.warning(util.translate("scripts", "Error al cargar los datos de compra"), MessageBox.Ok, MessageBox.NoButton);
		this.close();
	}
	this.child("fdbReferencia").setValue(aDatos["referencia"]);
	this.child("fdbCodProveedor").setValue(aDatos["codproveedor"]);
	this.child("fdbFecha").setValue(aDatos["fecha"]);
	if (aDatos["canprevia"]) {
		this.child("fdbCanPrevia").setValue(aDatos["canprevia"]);
	}
	if (aDatos["fechaprevia"]) {
		this.child("fdbFechaPrevia").setValue(aDatos["fechaprevia"]);
	}
	if (aDatos["idlineapedido"]) {
		cursor.setValueBuffer("idlineapedido", aDatos["idlineapedido"]);
		var idPedido:String = util.sqlSelect("lineaspedidosprov", "idpedido", "idlinea = " + aDatos["idlineapedido"]);
		if (!idPedido) {
			MessageBox.warning(util.translate("scripts", "Error al cargar los datos del pedido de compra"), MessageBox.Ok, MessageBox.NoButton);
			this.close();
		}
		cursor.setValueBuffer("idpedido", idPedido);
	}
}

function oficial_bufferChanged(fN:String)
{
	var cursor:FLSqlCursor = this.cursor();
	switch (fN) {
		case "cantidad":
		case "canprevia": {
			this.child("fdbIncremento").setValue(this.iface.calculateField("incremento"));
			break;
		}
	}
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
