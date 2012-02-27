/***************************************************************************
                 tpv_pagoscomanda.qs  -  description
                             -------------------
    begin                : mar feb 07 2006
    copyright            : Por ahora (C) 2006 by InfoSiAL S.L.
    email                : lveb@telefonica.net
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
	function validateForm():Boolean {
		return this.ctx.interna_validateForm();
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
    var lblPtoVenta:Object;
	var codPagoVales:String;
    function oficial( context ) { interna( context ); }
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
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
El estado por defecto de los nuevos pagos es Pagado
*/
function interna_init()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	this.iface.codPagoVales = util.sqlSelect("tpv_datosgenerales", "pagovale", "1 = 1");

	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");

	switch (cursor.modeAccess()) {
		case cursor.Insert: {
			this.child("fdbEstado").setValue(util.translate("scripts", "Pagado"));
			this.child("fdbCodPago").setValue(cursor.cursorRelation().valueBuffer("codpago"));
			this.child("fdbCodPago").setValue(cursor.cursorRelation().valueBuffer("codpago"));
			var codTerminal:String = util.readSettingEntry("scripts/fltpv_ppal/codTerminal");
			if (codTerminal) {
				this.child("fdbCodTpvPuntoventa").setValue(codTerminal);
				this.child("fdbAgente").setValue(util.sqlSelect("tpv_puntosventa","codtpv_agente","codtpv_puntoventa ='" + codTerminal + "'"));
			}
			break;
		}
		case cursor.Edit: {
			this.child("fdbCodTpvPuntoventa").setDisabled(true);
			break;
		}
	}
}

function interna_validateForm():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	/** \C
	El pago debe producir un total inferior o igual al total de la comanda
	*/
	var totalComanda:Number = parseFloat(cursor.cursorRelation().valueBuffer("total"));
	var totalPagos = parseFloat(util.sqlSelect("tpv_pagoscomanda", "SUM(importe)", "idtpv_comanda = " + cursor.valueBuffer("idtpv_comanda") + " AND idpago <> " + cursor.valueBuffer("idpago") + " AND estado = '" + util.translate("scripts", "Pagado") + "'"));
	if ((totalComanda - totalPagos) < parseFloat(cursor.valueBuffer("importe"))) {
		MessageBox.warning(util.translate("scripts", "El importe del pago hace que la suma de pagos sea superior al importe de la comanda"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	/** \C Si se ha pagado con un vale se comprueba que el importe sea igual o inferior al saldo del vale
	\end */
	var refVale:String = cursor.valueBuffer("refvale");
	if (refVale && refVale != "") {
		var importeVale:String = util.sqlSelect("tpv_vales", "importe", "referencia = '" + refVale + "'");
		var gastado:String = util.sqlSelect("tpv_pagoscomanda", "SUM(importe)", "refvale= '" + refVale + "' AND idpago <> " + cursor.valueBuffer("idpago"));
		if (!gastado)
			gastado = 0;
		var saldoVale:Number = parseFloat(importeVale) - parseFloat(gastado);
		if (parseFloat(cursor.valueBuffer("importe")) > saldoVale) {
			MessageBox.warning(util.translate("scripts", "El importe indicado (%1) es superior al saldo del vale (%2)").arg(util.roundFieldValue(cursor.valueBuffer("importe"), "tpv_pagoscomanda", "importe")).arg(util.roundFieldValue(saldoVale, "tpv_pagoscomanda", "importe")), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}
	return true;
}

function interna_calculateField(fN:String):String
{
	var util:FLUtil = new FLUtil();
	var valor:String;
	var cursor:FLSqlCursor = this.cursor();

	switch (fN) {
		/** \C
		El --importe--, cuando se ha establecido una referencia de vale, será el menor entre el pendiente por pagar y el saldo del vale
		*/
		case "importe": {
			var pendiente:String = parseFloat(cursor.cursorRelation().valueBuffer("pendiente"));
			var refVale:String = cursor.valueBuffer("refvale");
			if (refVale && refVale != "") {
				var saldoVale:Number = util.sqlSelect("tpv_vales", "saldo", "referencia = '" + refVale + "'");
				if (saldoVale && parseFloat(saldoVale) < parseFloat(pendiente))
					pendiente = saldoVale;
			}
			valor = pendiente;
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
		Si la forma de pago es la de vales se habilita el campo para incluir la referencia del vale 
		*/
		case "codpago": {
			var codPago:String = cursor.valueBuffer("codpago");
			if (codPago != "" && codPago == this.iface.codPagoVales)
				this.child("fdbRefVale").setDisabled(false);
			else {
				this.child("fdbRefVale").setValue("");
				this.child("fdbRefVale").setDisabled(true);
			}
			break;
		}
		/** \C
		Cuando se establece la referencia del vale se avisa si éste ha caducado y se calcula el máximo importe que se puede obtener del vale
		*/
		case "refvale": {
			var hoy:Date = new Date;
			var fechaCad:Date = util.sqlSelect("tpv_vales", "fechacaducidad", "referencia = '" + cursor.valueBuffer("refvale") + "'");
			if (fechaCad && util.daysTo(fechaCad, hoy) > 0) {
				MessageBox.warning(util.translate("scripts", "AVISO: El vale seleccionado, con fecha de caducidad %1, ha caducado").arg(util.dateAMDtoDMA(fechaCad)), MessageBox.Ok, MessageBox.NoButton);
			}
			this.child("fdbImporte").setValue(this.iface.calculateField("importe"));
			break;
		}
	}
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
