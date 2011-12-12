/***************************************************************************
                 tpv_pagarcomanda.qs  -  description
                             -------------------
    begin                : mie nov 15 2006
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
	function oficial( context ) { interna( context ); }
	function calcularCambio() {
		return this.ctx.oficial_calcularCambio();
	}
	function modificarCantidad(numero:Number) {
		return this.ctx.oficial_modificarCantidad(numero);
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
	this.iface.total = this.cursor().valueBuffer("importe");
	this.child("lblImporteTotal"). setText(this.iface.total);

	this.iface.botones = this.child("botones");
	connect(this.iface.botones, "clicked(int)", this, "iface.modificarCantidad");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
// function oficial_aceptarPago()
// {
// 	this.child("pushButtonAccept").animateClick();
// }

function oficial_calcularCambio()
{
	var cambio = this.iface.total - this.cursor().valueBuffer("importe");
	this.child("lblImporteCambio").setText(cambio);
}

function oficial_modificarCantidad(numero:Number)
{
	var util:FLUtil;
	debug("numero " + numero);
	var cursor:FLSqlCursor = this.cursor();
	if(numero == 11) {
		cursor.setValueBuffer("importe",0);
		return;
	}

	var valor:Number = parseFloat(cursor.valueBuffer("importe"));
	valor = util.roundFieldValue(valor, "tpv_comandas","total");
	debug("valor antes " + valor);
	var cantidad:String = "";
	if(valor && valor > 0) {
		valor = parseInt(valor*100);
		cantidad = valor.toString();
		while(cantidad.startsWith("0"))
			cantidad = cantidad.right(cantidad.length-1);
	}
		debug("cantidad antes " + cantidad);
	if(numero == 10)
		cantidad = cantidad + "00";
	else
		cantidad = cantidad + numero.toString();
	debug("cantidad despues " + cantidad);
	valor = parseInt(cantidad) / 100;
	debug("valor despues " + valor);
	
	valor = util.roundFieldValue(valor, "tpv_comandas","total");
	cursor.setValueBuffer("importe",valor);

	this.iface.calcularCambio();
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
