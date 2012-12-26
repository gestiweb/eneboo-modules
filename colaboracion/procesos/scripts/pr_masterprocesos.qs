/***************************************************************************
                      pr_masterprocesos.qs  -  description
                             -------------------
    begin                : lun jun 19 2004
    copyright            : (C) 2005 by InfoSiAL S.L.
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
	var tbnReanudar:Object;
	var tbnDetener:Object;
	var tbnCancelar:Object;
	var tdbRecords:FLTableDB;
	
	function oficial( context ) { interna( context ); } 
	function tbnReanudar_clicked() {
		return this.ctx.oficial_tbnReanudar_clicked(); 
	}
	function tbnDetener_clicked() {
		return this.ctx.oficial_tbnDetener_clicked(); 
	}
	function tbnCancelar_clicked() {
		return this.ctx.oficial_tbnCancelar_clicked(); 
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
	this.iface.tdbRecords = this.child("tableDBRecords");
	//this.iface.tdbRecords.setReadOnly(true);
	
	this.iface.tbnReanudar = this.child("tbnReanudar");
	this.iface.tbnDetener = this.child("tbnDetener");
	this.iface.tbnCancelar = this.child("tbnCancelar");
	
	connect(this.iface.tbnReanudar, "clicked()", this, "iface.tbnReanudar_clicked");
	connect(this.iface.tbnDetener, "clicked()", this, "iface.tbnDetener_clicked");
	connect(this.iface.tbnCancelar, "clicked()", this, "iface.tbnCancelar_clicked");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_tbnReanudar_clicked()
{
	var util:FLUtil = new FLUtil;
	var idProceso:Number = this.cursor().valueBuffer("idproceso");
	if (!idProceso) {
		MessageBox.warning(util.translate("scripts", "No hay ningún proceso seleccionado"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	flcolaproc.iface.pub_reanudarProceso(idProceso);
	this.iface.tdbRecords.refresh();
}

function oficial_tbnDetener_clicked()
{
	var util:FLUtil = new FLUtil;
	var idProceso:Number = this.cursor().valueBuffer("idproceso");
	if (!idProceso) {
		MessageBox.warning(util.translate("scripts", "No hay ningún proceso seleccionado"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	flcolaproc.iface.pub_detenerProceso(idProceso);
	this.iface.tdbRecords.refresh();
}

function oficial_tbnCancelar_clicked()
{
	var util:FLUtil = new FLUtil;
	var idProceso:Number = this.cursor().valueBuffer("idproceso");
	if (!idProceso) {
		MessageBox.warning(util.translate("scripts", "No hay ningún proceso seleccionado"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	flcolaproc.iface.pub_cancelarProceso(idProceso);
	this.iface.tdbRecords.refresh();
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
