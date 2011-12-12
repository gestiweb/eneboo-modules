/***************************************************************************
                 masterbuscapedcli.qs  -  description
                             -------------------
    begin                : mie may 14 2008
    copyright            : (C) 2008 by InfoSiAL S.L.
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

	var tbnBuscarIntervalo:Object;
	var lineIntervalo:Object;
	var lineDescIntervalo:Object;
	var dateDesde:Object;
	var dateHasta:Object;
	var tbnActualizar:Object;

    function oficial( context ) { interna( context ); }
	function buscarIntervalo() {
		return this.ctx.oficial_buscarIntervalo();
	}
	function cambiarIntervalo(cadena:String) {
		return this.ctx.oficial_cambiarIntervalo(cadena);
	}
	function actualizarPedidos() {
		return this.ctx.oficial_actualizarPedidos();
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
	this.iface.tbnBuscarIntervalo = this.child("tbnBuscarIntervalo");
	this.iface.lineIntervalo = this.child("lineIntervalo");
	this.iface.lineDescIntervalo = this.child("lineDescIntervalo");
	this.iface.dateDesde = this.child("dateDesde");
	this.iface.dateHasta = this.child("dateHasta");
	this.iface.tbnActualizar = this.child("tbnActualizar");

	connect(this.iface.tbnBuscarIntervalo, "clicked()", this, "iface.buscarIntervalo()");
	connect(this.iface.lineIntervalo, "textChanged(QString)", this, "iface.cambiarIntervalo()");
	connect(this.iface.tbnActualizar, "clicked()", this, "iface.actualizarPedidos()");
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition oficial */
/////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_buscarIntervalo()
{
	var f:Object = new FLFormSearchDB("intervalos");
	var curIntervalo:FLSqlCursor = f.cursor();
	
	curIntervalo.setMainFilter("1 = 1");
	f.setMainWidget();
	var codIntervalo:String = f.exec("codigo");
	if (codIntervalo)
		this.iface.lineIntervalo.text = codIntervalo;
}

function oficial_cambiarIntervalo(cadena:String)
{
	var util:FLUtil;

	this.iface.lineDescIntervalo.text = util.sqlSelect("intervalos","intervalo","codigo = '" + cadena + "'");;

	var intervalo:Array = [];
	intervalo = flfactppal.iface.pub_calcularIntervalo(cadena);
	this.iface.dateDesde.date = intervalo.desde;
	this.iface.dateHasta.date = intervalo.hasta;
}

function oficial_actualizarPedidos()
{
	var filtro:String = "pedido IN ('No', 'Parcial') AND servido IN ('No', 'Parcial')";

	if (this.iface.dateDesde.date) {
		filtro += " AND fecha >= '" + this.iface.dateDesde.date + "'";
	}
	if (this.iface.dateHasta.date) {
		filtro += " AND fecha <= '" + this.iface.dateHasta.date + "'";
	}
debug("filtro es " + filtro);
	this.cursor().setMainFilter(filtro);
debug("filtro " + this.cursor().mainFilter());
	this.child("tableDBRecords").refresh();
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

	