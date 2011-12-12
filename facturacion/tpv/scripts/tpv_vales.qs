/***************************************************************************
                 tpv_vales.qs  -  description
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
	function calculateField(fN:String):String {
		return this.ctx.interna_calculateField(fN);
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var tdbPagosComanda:Object;
	var tdbLineasVale:Object;
	function oficial( context ) { interna( context ); } 
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function calcularTotales() {
		return this.ctx.oficial_calcularTotales();
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
*/
function interna_init()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	this.iface.tdbPagosComanda = this.child("tdbPagosComanda");
	this.iface.tdbPagosComanda.setReadOnly(true);
	this.iface.tdbLineasVale = this.child("tdbLineasVale");
	

	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this.iface.tdbLineasVale.cursor(), "bufferCommited()", this, "iface.calcularTotales()");
	
	switch (cursor.modeAccess()) {
		case cursor.Insert: {
			this.child("fdbReferencia").setValue(this.iface.calculateField("referencia"));
			this.iface.bufferChanged("fechaemision"); 
			break;
		}
		case cursor.Edit: {
			break;
		}
	}
}

function interna_calculateField(fN:String):String
{
	var util:FLUtil = new FLUtil();
	var valor:String;
	var cursor:FLSqlCursor = this.cursor();

	switch (fN) {
		/** \C
		La --fechacaducidad-- es la fecha de emisión más el período de validez del vale establecido en el formulario de datos generales
		*/
		case "fechacaducidad": {
			var diasValidez:String = util.sqlSelect("tpv_datosgenerales", "diasvalidezvale", "1 = 1");
			if (!diasValidez) {
				MessageBox.warning(util.translate("scripts", "No tiene establecido el parámetro Días de validez de los vales en el formulario de datos generales.\nDebe establecer este valor para poder calcular la fecha de caducidad en función de la de emisión"), MessageBox.Ok, MessageBox.NoButton);
				break;
			}
			valor = util.addDays(cursor.valueBuffer("fechaemision"), diasValidez);
			break;
		}
		case "saldo": {
			valor = cursor.valueBuffer("importe");
			break;
		}
		/** \C La --referencia-- del vale se construye como el código de la vena asociada más un secuencial
		\end */
		case "referencia": {
			var idComanda:String = cursor.valueBuffer("idtpv_comanda");
			if (!idComanda)
				break;
			var numRefs:Number = util.sqlSelect("tpv_vales", "COUNT(referencia)", "idtpv_comanda = " + idComanda);
			if (!numRefs)
				numRefs = 0;
			numRefs++;
			valor = util.sqlSelect("tpv_comandas", "codigo", "idtpv_comanda = " + idComanda) + "-" + flfacturac.iface.cerosIzquierda(numRefs, 3);
			break;
		}
	}
	return valor;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_bufferChanged(fN:String)
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	switch (fN) {
		/** \C
		Al cambiar la --fechaemision-- se calcula la --fechacaducidad-- 
		*/
		case "fechaemision": {
			this.child("fdbFechaCaducidad").setValue(this.iface.calculateField("fechacaducidad"));
			break;
		}
		/** \C
		El --saldo-- por defecto es igual al --importe-- 
		*/
		case "importe": {
			this.child("fdbSaldo").setValue(this.iface.calculateField("saldo"));
			break;
		}
		case "idtpv_comanda": {
			this.child("fdbReferencia").setValue(this.iface.calculateField("referencia"));
			break;
		}
	}
}

function oficial_calcularTotales()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var totalVale:Number = util.sqlSelect("tpv_lineasvale", "SUM(pvptotal)", "refvale = '" + cursor.valueBuffer("referencia") + "'");
	if (!totalVale || isNaN(totalVale))
		totalVale = 0;
	totalVale = util.roundFieldValue(totalVale, "tpv_vales", "importe");

	this.child("fdbImporte").setValue(totalVale);
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
