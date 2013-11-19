/***************************************************************************
                 in_masterseleccion.qs  -  description
                             -------------------
    begin                : mar sep 29 2009
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
	function init() { this.ctx.interna_init(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	function oficial( context ) { interna( context );}
	function aceptar() {
		this.ctx.oficial_aceptar();
	}
	function tbnDelFiltro_clicked() {
		this.ctx.oficial_tbnDelFiltro_clicked();
	}
	function tbnTodas_clicked() {
		this.ctx.oficial_tbnTodas_clicked();
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
	var util:FLUtil = new FLUtil;

	var valores:String = formin_navegador.iface.pub_dameSeleccionValores();
	var tdbSeleccion:FLTable = this.child("tdbSeleccion");
	if (valores && valores != "") {
debug("primaries = " + valores);
		var seleccion:String = valores.split(", ");
		for (var s:Number = 0; s < seleccion.length; s++) {
			tdbSeleccion.setPrimaryKeyChecked(seleccion[s], true);
		}
	}

	disconnect(this.child("pushButtonAccept"), "clicked()", this, "accept()");
	connect(this.child("pushButtonAccept"), "clicked()", this, "iface.aceptar()");
	connect(this.child("tbnDelFiltro"), "clicked()", this, "iface.tbnDelFiltro_clicked()");
	connect(this.child("tbnTodas"), "clicked()", this, "iface.tbnTodas_clicked()");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_aceptar()
{
	var tdbSeleccion:FLTableDB = this.child("tdbSeleccion");
	var arrayValores:Array = tdbSeleccion.primarysKeysChecked();
	var valores:String;
	if (arrayValores && arrayValores.length > 0) {
		valores = arrayValores.join(", ");
	} else {
		valores = "";
	}
	
	formin_navegador.iface.pub_ponSeleccionValores(valores);

	this.accept();
}

function oficial_tbnDelFiltro_clicked()
{
	var tdbSeleccion:FLTableDB = this.child("tdbSeleccion");
	tdbSeleccion.clearChecked();
	tdbSeleccion.refresh();
}

function oficial_tbnTodas_clicked()
{
	var tdbSeleccion:FLTableDB = this.child("tdbSeleccion");
	var cursor:FLSqlCursor = this.cursor();
	var tabla:String = cursor.table();
	cursor.select();
	while (cursor.next()) {
		tdbSeleccion.setPrimaryKeyChecked(cursor.valueBuffer(cursor.primaryKey()), true);
	}
	tdbSeleccion.refresh();
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
