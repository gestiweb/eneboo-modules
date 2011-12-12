/***************************************************************************
                 tpv_pagolibre.qs  -  description
                             -------------------
    begin                : jue jun 10 2010
    copyright            : Por ahora (C) 2006 by InfoSiAL S.L.
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
		this.ctx.interna_init();
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var total:Number;
	var botones:Object;
	var pbnIvaGen:Object;
	var pbnIvaRed:Object;
	var pbnIvaSRed:Object;
	function oficial( context ) { interna( context ); }
	function calcularCambio() {
		return this.ctx.oficial_calcularCambio();
	}
	function modificarCantidad(numero:Number) {
		return this.ctx.oficial_modificarCantidad(numero);
	}
	function ivaGen_clicked() {
		return this.ctx.oficial_ivaGen_clicked();
	}
	function ivaRed_clicked() {
		return this.ctx.oficial_ivaRed_clicked();
	}
	function ivaSRed_clicked() {
		return this.ctx.oficial_ivaSRed_clicked();
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
/** \C Se muestra el importe pendiente de pago seleccionado. Al pulsar Intro o Return el formulario se cerrará con el importe que el usuario haya establecido.
*/
function interna_init()
{
// 	this.iface.total = this.cursor().valueBuffer("importe");
// 	this.child("lblImporteTotal"). setText(this.iface.total);

	this.iface.botones = this.child("botones");
	this.iface.pbnIvaGen =this.child("pbnIvaGen");
	this.iface.pbnIvaRed =this.child("pbnIvaRed");
	this.iface.pbnIvaSRed =this.child("pbnIvaSRed");
	connect(this.iface.botones, "clicked(int)", this, "iface.modificarCantidad");
	connect(this.iface.pbnIvaGen, "clicked()", this, "iface.ivaGen_clicked()");
	connect(this.iface.pbnIvaRed, "clicked()", this, "iface.ivaRed_clicked()");
	connect(this.iface.pbnIvaSRed, "clicked()", this, "iface.ivaSRed_clicked()");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_modificarCantidad(numero:Number)
{
	var util:FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	if(numero == 11) {
		cursor.setValueBuffer("importe",0);
		return;
	}

	var valor:Number = parseFloat(cursor.valueBuffer("importe"));
	valor = util.roundFieldValue(valor, "tpv_comandas","total");
	var cantidad:String = "";
	if(valor && valor > 0) {
		valor = parseInt(valor*100);
		cantidad = valor.toString();
		while(cantidad.startsWith("0"))
			cantidad = cantidad.right(cantidad.length-1);
	}

	if(numero == 10)
		cantidad = cantidad + "00";
	else
		cantidad = cantidad + numero.toString();

	valor = parseInt(cantidad) / 100;

	
	valor = util.roundFieldValue(valor, "tpv_comandas","total");
	cursor.setValueBuffer("importe",valor);
}

function oficial_ivaGen_clicked()
{
	var util:FLUtil;
	if(this.iface.pbnIvaGen.on) {
		this.iface.pbnIvaRed.on = false;
		this.iface.pbnIvaSRed.on = false;
		this.cursor().setValueBuffer("codimpuesto",util.sqlSelect("tpv_datosgenerales","codimpuestogen","1=1"));
	}
	else {
		this.cursor().setNull("codimpuesto");
	}
}

function oficial_ivaRed_clicked()
{
	var util:FLUtil;
	if(this.iface.pbnIvaRed.on) {
		this.iface.pbnIvaGen.on = false;
		this.iface.pbnIvaSRed.on = false;
		this.cursor().setValueBuffer("codimpuesto",util.sqlSelect("tpv_datosgenerales","codimpuestored","1=1"));
	}
	else {
		this.cursor().setNull("codimpuesto");
	}
}

function oficial_ivaSRed_clicked()
{
	var util:FLUtil;
	if(this.iface.pbnIvaSRed.on) {
		this.iface.pbnIvaRed.on = false;
		this.iface.pbnIvaGen.on = false;
		this.cursor().setValueBuffer("codimpuesto",util.sqlSelect("tpv_datosgenerales","codimpuestosred","1=1"));
	}
	else {
		this.cursor().setNull("codimpuesto");
	}
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
