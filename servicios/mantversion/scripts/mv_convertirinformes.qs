/***************************************************************************
                 mv_convertirinformes.qs  -  description
                             -------------------
    begin                : jue oct 18 2007
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
////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

/** @class_declaration interna */
//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
class interna {
    var ctx:Object;
    function interna( context ) { this.ctx = context; }
    function init() { this.ctx.interna_init(); }
	function calculateField(fN:String):String {
		return this.ctx.interna_calculateField(fN); 
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna 
{
    function oficial( context ) { interna( context ); } 
	function cambiarOrigen() {
		this.ctx.oficial_cambiarOrigen();
	}
	function cambiarDestino() {
		this.ctx.oficial_cambiarDestino();
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

function interna_init()
{
	connect(this.child("pbnCambiarOrigen"), "clicked()", this, "iface.cambiarOrigen()");
	connect(this.child("pbnCambiarDestino"), "clicked()", this, "iface.cambiarDestino()");

	if (this.cursor().modeAccess() == this.cursor().Insert)
		this.child("fdbCodUsuario").setValue(this.iface.calculateField("codusuario"));
}

function interna_calculateField(fN:String):String
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var valor:String;

	switch (fN) {
		case "codusuario": {
			valor = util.readSettingEntry("scripts/flservppal/codusuario");
			if (!valor) {
				MessageBox.information( util.translate( "scripts", "No se ha definido usuario actual"), MessageBox.Ok, MessageBox.NoButton);
				return;
			}
			break;
		}
	}
	return valor;
}

function oficial_cambiarOrigen()
{
	var nomFichero = FileDialog.getOpenFileName("*.ar");
	if (!nomFichero) return;
	
	this.child("fdbOrigen").setValue(nomFichero);	
}

function oficial_cambiarDestino()
{
	var nomFichero = FileDialog.getSaveFileName("*.kut");
	if (!nomFichero) return;
	
	this.child("fdbDestino").setValue(nomFichero);	
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
