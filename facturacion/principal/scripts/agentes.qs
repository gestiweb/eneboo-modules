/***************************************************************************
                 agentes.qs  -  description
                             -------------------
    begin                : mar abr 10 2007
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
	var bloqueoProvincia:Boolean;
    function oficial( context ) { interna( context ); }
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function construirNombre() {
		return this.ctx.oficial_construirNombre();
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
/** \C Si en la tabla de direcciones de clientes no hay todavía ninguna dirección asociada al cliente, la primera dirección introducida se tomará como dirección de facturación y dirección de envío
\end */
function interna_init()
{
	var cursor:FLSqlCursor = this.cursor();
	this.iface.bloqueoProvincia = false;
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	switch (cursor.modeAccess()) {
		case cursor.Edit: {
			connect(this, "formReady()", this, "iface.construirNombre");
			break;
		}
	}
}

function interna_calculateField(fN:String):String
{
	var cursor:FLSqlCursor = this.cursor();
	var valor:String = "";
	switch (fN) {
		case "nombreap": {
			var apellidos:String = cursor.valueBuffer("apellidos");
			var nombre:String = cursor.valueBuffer("nombre");
			if (apellidos) {
				valor += apellidos;
			}
			if (nombre) {
				if (valor) {
					valor += " ";
				}
				valor += nombre;
			}
		}
	}
	return valor;
}

function interna_validateForm():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	if (!flfactppal.iface.pub_validarProvincia(cursor)) {
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
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	switch (fN) {
		case "provincia": {
			if (!this.iface.bloqueoProvincia) {
				this.iface.bloqueoProvincia = true;
				flfactppal.iface.pub_obtenerProvincia(this);
				this.iface.bloqueoProvincia = false;
			}
			break;
		}
		case "idprovincia": {
			if (cursor.valueBuffer("idprovincia") == 0) {
				cursor.setNull("idprovincia");
			}
			break;
		}
		case "nombre": 
		case "apellidos": {
			this.child("fdbNombreAp").setValue(this.iface.calculateField("nombreap"));
			break;
		}
	}
}

function oficial_construirNombre()
{
	var cursor:FLSqlCursor = this.cursor();
	var nombreAp:String = cursor.valueBuffer("nombreap");
	if (!nombreAp || nombreAp == "") {
		this.child("fdbNombreAp").setValue(this.iface.calculateField("nombreap"));
	}
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
