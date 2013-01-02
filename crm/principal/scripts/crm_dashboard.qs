/***************************************************************************
                 crm_masterdashboard.qs  -  description
                             -------------------
    begin                : vie feb 12 2010
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
    function oficial( context ) { interna( context ); }
	function mostrarOportunidades() {
		return this.ctx.oficial_mostrarOportunidades();
	}
	function mostrarTarjetas() {
		return this.ctx.oficial_mostrarTarjetas();
	}
	function mostrarTareas() {
		return this.ctx.oficial_mostrarTareas();
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
	var util:FLUtil = new FLUtil();
	
	this.iface.mostrarOportunidades();
	this.iface.mostrarTarjetas();
	this.iface.mostrarTareas();
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_mostrarOportunidades()
{
	var tdbOportunidades:FLTableDB = this.child("tdbOportunidades");
	var campos:Array = ["descripcion", "totalventa"];
	tdbOportunidades.setOrderCols(campos);
	tdbOportunidades.refresh();
}

function oficial_mostrarTarjetas()
{
	var tdbTarjetas:FLTableDB = this.child("tdbTarjetas");
	var campos:Array = ["nombre", "telefono1"];
	tdbTarjetas.setOrderCols(campos);
	tdbTarjetas.refresh();
}

function oficial_mostrarTareas()
{
	var datosS:Array;
	datosS["tipoObjeto"] = "todos";
	datosS["idObjeto"] = "0";
	flcolaproc.iface.pub_seguimientoOn(this, datosS);
	
	this.child("tbnLanzarTareaS").close();
	this.child("tbnDeleteTareaS").close();

	var tdbTareasS:FLTableDB = this.child("tdbTareasS");
	var campos:Array = ["fechainicioprev", "descripcion"];
	tdbTareasS.setOrderCols(campos);
	tdbTareasS.refresh();
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
