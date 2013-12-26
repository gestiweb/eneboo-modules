/***************************************************************************
                 gf_mastercoloresdefecto.qs  -  description
                             -------------------
    begin                : mar jun 15 2010
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var tableDBRecords:Object;
	function oficial( context ) { interna( context ); }
// 	function tbnCrearColorSec_clicked() {
// 		return this.ctx.oficial_tbnCrearColorSec_clicked();
// 	}
// 	function tbnCambiarColorSec_clicked() {
// 		return this.ctx.oficial_tbnCambiarColorSec_clicked();
// 	}
// 	function tbnBorrarColorSec_clicked() {
// 		return this.ctx.oficial_tbnBorrarColorSec_clicked();
// 	}
	function tbnSubirColorSec_clicked() {
		return this.ctx.oficial_tbnSubirColorSec_clicked();
	}
	function tbnBajarColorSec_clicked() {
		return this.ctx.oficial_tbnBajarColorSec_clicked();
	}
	function dameColorFila(fN, fV, cursor, fT, sel) {
		return this.ctx.oficial_dameColorFila(fN, fV, cursor, fT, sel);
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
	this.iface.tableDBRecords = this.child("tableDBRecords");
	
// 	connect(this.child("tbnCrearColorSec"), "clicked()", this, "iface.tbnCrearColorSec_clicked");
// 	connect(this.child("tbnBorrarColorSec"), "clicked()", this, "iface.tbnBorrarColorSec_clicked");
// 	connect(this.child("tbnCambiarColorSec"), "clicked()", this, "iface.tbnCambiarColorSec_clicked");
	connect(this.child("tbnSubirColorSec"), "clicked()", this, "iface.tbnSubirColorSec_clicked");
	connect(this.child("tbnBajarColorSec"), "clicked()", this, "iface.tbnBajarColorSec_clicked");
	
	var ordenColumnas:Array = new Array("orden","hex","nombre","rgb","r","g","b");
	this.iface.tableDBRecords.setOrderCols(ordenColumnas);
	this.iface.tableDBRecords.refresh();
	
	this.iface.tableDBRecords.setFunctionGetColor("formgf_coloresdefecto.dameColorFila");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_dameColorFila(fN, fV, cursor, fT, sel)
{
	if(fN == "hex") {
		var a:Array = [fV, fV, "SolidPattern", "SolidPattern"];
		return a;
	}
}

function oficial_tbnSubirColorSec_clicked()
{
	var util:FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var orden:Number = parseInt(cursor.valueBuffer("orden"));
	if (!orden || orden == 1)
		return false;
	
	var ordenAnt:Number = orden-1;
	
	var color:Number = util.sqlSelect("gf_colores","idcolor","orden = " + orden);
	util.sqlUpdate("gf_colores","orden",orden,"orden = " + ordenAnt);
	util.sqlUpdate("gf_colores","orden",ordenAnt,"idcolor = " + color);
	
	cursor.prev();
	this.iface.tableDBRecords.refresh();
}

function oficial_tbnBajarColorSec_clicked()
{
	var util:FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var orden:Number = parseInt(cursor.valueBuffer("orden"));
	if (!orden || orden == cursor.size())
		return false;
	
	var ordenSig:Number = orden+1;
	
	var color:Number = util.sqlSelect("gf_colores","idcolor","orden = " + orden);
	util.sqlUpdate("gf_colores","orden",orden,"orden = " + ordenSig);
	util.sqlUpdate("gf_colores","orden",ordenSig,"idcolor = " + color);
	
	cursor.next();
	this.iface.tableDBRecords.refresh();
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

