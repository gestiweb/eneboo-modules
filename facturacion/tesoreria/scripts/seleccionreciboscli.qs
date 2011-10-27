/**************************************************************************
                 seleccionreciboscli.qs  -  description
                             -------------------
    begin                : mar feb 21 2006
    copyright            : (C) 2006 by InfoSiAL S.L.
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
	var tdbRecibos:Object;
	var tdbRecibosSel:Object;
	
    function oficial( context ) { interna( context ); } 
	function seleccionar() {
		return this.ctx.oficial_seleccionar();
	}
	function quitar() {
		return this.ctx.oficial_quitar();
	}
	function refrescarTablas() {
		return this.ctx.oficial_refrescarTablas();
	}
	function calcularTotal() {
		return this.ctx.oficial_calcularTotal();
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
/** \C
Este formulario muestra una lista de recibos de cliente que cumplen un determinado filtro, y permite al usuario seleccionar uno o más recibos de la lista
\end */
function interna_init()
{
	this.iface.tdbRecibos = this.child("tdbRecibos");
	this.iface.tdbRecibosSel = this.child("tdbRecibosSel");
	
	this.iface.tdbRecibos.setReadOnly(true);
	this.iface.tdbRecibosSel.setReadOnly(true);
	
	var filtro:String = this.cursor().valueBuffer("filtro");
	if (filtro && filtro != "") {
		this.iface.tdbRecibos.cursor().setMainFilter(filtro);
		this.iface.tdbRecibosSel.cursor().setMainFilter(filtro);
	}
	this.iface.refrescarTablas();
	this.iface.calcularTotal();

	connect(this.iface.tdbRecibos.cursor(), "recordChoosed()", this, "iface.seleccionar()");
	connect(this.iface.tdbRecibosSel.cursor(), "recordChoosed()", this, "iface.quitar()");
	connect(this.child("pbnSeleccionar"), "clicked()", this, "iface.seleccionar()");
	connect(this.child("pbnQuitar"), "clicked()", this, "iface.quitar()");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Refresca las tablas, en función del filtro y de los datos seleccionados hasta el momento
*/
function oficial_refrescarTablas()
{
	var datos:String = this.cursor().valueBuffer("datos");
	var filtro:String = this.cursor().valueBuffer("filtro");
	if (filtro && filtro != "")
		filtro += " AND ";

	if (!datos || datos == "") {
		this.iface.tdbRecibos.cursor().setMainFilter(filtro + "1 = 1");
		this.iface.tdbRecibosSel.cursor().setMainFilter(filtro + "1 = 2");
	} else {
		this.iface.tdbRecibos.cursor().setMainFilter(filtro + "idrecibo NOT IN (" + datos + ")");
		this.iface.tdbRecibosSel.cursor().setMainFilter(filtro + "idrecibo IN (" + datos + ")");
	}
	this.iface.tdbRecibos.refresh();
	this.iface.tdbRecibosSel.refresh();
}

/** \D Incluye un recibo en la lista de datos
*/
function oficial_seleccionar()
{
	var cursor:FLSqlCursor = this.cursor();
	var datos:String = cursor.valueBuffer("datos");
	var idRecibo:String = this.iface.tdbRecibos.cursor().valueBuffer("idRecibo");
	if (!idRecibo)
		return;
	if (!datos || datos == "")
		datos = idRecibo;
	else
		datos += "," + idRecibo;
		
	cursor.setValueBuffer("datos", datos);
	
	this.iface.refrescarTablas();
	this.iface.calcularTotal();
}

/** \D Quira un recibo de la lista de datos
*/
function oficial_quitar()
{
	var cursor:FLSqlCursor = this.cursor();
	var datos:String = new String( cursor.valueBuffer("datos") );
	var idRecibo:String = this.iface.tdbRecibosSel.cursor().valueBuffer("idRecibo");
	if (!idRecibo)
		return;
	
	if (!datos || datos == "")
		return;
	var recibos:Array = datos.split(",");
	var datosNuevos:String = "";
	for (var i:Number = 0; i < recibos.length; i++) {
		if (recibos[i] != idRecibo) {
			if (datosNuevos == "") 
				datosNuevos = recibos[i];
			else
				datosNuevos += "," + recibos[i];
		}
	}
	cursor.setValueBuffer("datos", datosNuevos);
	this.iface.refrescarTablas();
	this.iface.calcularTotal();
}

function oficial_calcularTotal()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var datos:String = cursor.valueBuffer("datos");
	var total:Number = 0;
	if (datos || datos != "") {
		total = parseFloat(util.sqlSelect("reciboscli", "SUM(importe)", "idrecibo IN (" + datos + ")"));
		if (!total || isNaN(total))
			total = 0;
	}
	this.child("lblImporte").text = util.translate("scripts", "Total seleccionado: %1").arg(util.roundFieldValue(total, "reciboscli", "importe"));
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
