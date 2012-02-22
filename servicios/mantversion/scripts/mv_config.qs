/***************************************************************************
                 mv_config.qs  -  description
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
////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

/** @class_declaration interna */
//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
class interna {
	var ctx:Object;
	function interna( context ) { this.ctx = context; }
	function main() { this.ctx.interna_main(); }
	function init() { this.ctx.interna_init(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    function oficial( context ) { interna( context ); }
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends oficial {
	var pathLocal:String;
	var versionOficial:String;
	var pathPeso:String;
	function head( context ) { oficial ( context ); }
	function main() { return this.ctx.head_main(); }
	function init() { return this.ctx.head_init(); }
	function validateForm():Boolean { return this.ctx.head_validateForm(); }
	function cambiarDirLocal_clicked() { return this.ctx.head_cambiarDirLocal_clicked(); }
	function cambiarVersion_clicked() { return this.ctx.head_cambiarVersion_clicked(); }
	function cambiarDirPeso_clicked() { return this.ctx.head_cambiarDirPeso_clicked(); }
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

////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

/** @class_definition interna */
//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////

function main() {
    this.iface.main();
}

function init() {
    this.iface.init();
}

function validateForm():Boolean {
    return this.iface.validateForm();
}

function interna_main() {

}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
function head_init()
{
	this.iface.pathLocal = flmaveppal.iface.pub_obtenerPathLocal();
	this.iface.versionOficial = flmaveppal.iface.pub_obtenerVersionOficial();
	this.iface.pathPeso = flmaveppal.iface.pub_obtenerPathPeso();
	
	this.child("lblValorDirLocal").text = this.iface.pathLocal;
	this.child("lblValorVersion").text = this.iface.versionOficial;
	this.child("lblValorDirPeso").text = this.iface.pathPeso;
	
	connect(this.child("pbnCambiarDirLocal"), "clicked()", this, "iface.cambiarDirLocal_clicked()");
	connect(this.child("pbnCambiarVersion"), "clicked()", this, "iface.cambiarVersion_clicked()");
	connect(this.child("pbnCambiarDirPeso"), "clicked()", this, "iface.cambiarDirPeso_clicked()");
}

function head_cambiarDirLocal_clicked()
{
	flmaveppal.iface.pub_cambiarPathLocal(this.iface.pathLocal);
	this.iface.pathLocal = flmaveppal.iface.pub_obtenerPathLocal();
	this.child("lblValorDirLocal").text = this.iface.pathLocal;
}

function head_cambiarVersion_clicked()
{
	flmaveppal.iface.pub_cambiarVersionOficial(this.iface.versionOficial);
	this.iface.versionOficial = flmaveppal.iface.pub_obtenerVersionOficial();
	this.child("lblValorVersion").text = this.iface.versionOficial;
}

function head_cambiarDirPeso_clicked()
{
	flmaveppal.iface.pub_cambiarPathPeso(this.iface.pathPeso);
	this.iface.pathPeso = flmaveppal.iface.pub_obtenerPathPeso();
	this.child("lblValorDirPeso").text = this.iface.pathPeso;
}
function head_validateForm():Boolean
{
	return true;
}

function head_main()
{
	var f:Object = new FLFormSearchDB("mv_config");
	var cursor:FLSqlCursor = f.cursor();

	cursor.select();
	if (!cursor.first())
		cursor.setModeAccess(cursor.Insert);
	else
		cursor.setModeAccess(cursor.Edit);
	f.setMainWidget();
	if (cursor.modeAccess() == cursor.Insert)
		f.child("pushButtonCancel").setDisabled(true);
	cursor.refreshBuffer();
	var commitOk:Boolean = false;
	var acpt:Boolean;
	cursor.transaction(false);
	while (!commitOk) {
		acpt = false;
		f.exec("urlrepositoriomod");
		acpt = f.accepted();
		if (!acpt) {
			if (cursor.rollback())
				commitOk = true;
		} else {
			if (cursor.commitBuffer()) {
				cursor.commit();
				commitOk = true;
			}
		}
		f.close();
	}
}

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////