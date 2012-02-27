/***************************************************************************
                 tpv_arqueos.qs  -  description
                             -------------------
    begin                : mar nov 15 2005
    copyright            : Por ahora (C) 2005 by InfoSiAL S.L.
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
	function calculateField(fN:String):String { return this.ctx.interna_calculateField(fN); }
	function validateForm():Boolean {return this.ctx.interna_validateForm(); }
	function calculateCounter():String { return this.ctx.interna_calculateCounter(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var tdbMovimientos:Object;
    function oficial( context ) { interna( context ); }
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.oficial_commonCalculateField(fN, cursor);
	}
	function calcularValores() {
		return this.ctx.oficial_calcularValores();
	}
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function desconectar(){
		return this.ctx.oficial_desconectar();
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
	function pub_commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.commonCalculateField(fN, cursor);
	}
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
La pestaña de movimientos muestra las entradas y salidas de caja que no se deben a ventas 
normales (cuando se mete cambio, cuando se transfiere dinero de una caja a 
otra, etc).<br/>
La pestaña de ventas muestra todos los pagos asociados al arqueo y suma los totales de las los pagos en efectivo, en vale y con tarjeta.
El total de efectivo 'En Caja' es el importe que hay realmente en caja 
contando dinero en efectivo. El formulario ofrece una serie de campos asociados con las distintas monedas y billetes para facilitar el cálculo de este dato.<br/>
El total de tarjeta 'En Caja' es la suma de los importes de los tiques de 
pagos con tarjeta. <br/>
El total de efectivo 'Calculado' es el total que se obtiene sumando los importes de las comandas con forma de pago 'CONT' mas el importe total de los movimientos realizados.<br/>
El total de tarjeta 'Calculado' es el total que se obtiene sumando los importes de las comandas con forma de pago 'TARJ'.
El total de vales 'Calculado' es el total que se obtiene sumando los importes de las comandas con forma de pago 'VALE'.
Las diferencias de efectivo y tarjeta son la resta del total 'En Caja' menos el total 'Calculado'.
*/
function interna_init()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	this.iface.tdbMovimientos = this.child("tdbMovimientos");
	connect(this.iface.tdbMovimientos.cursor(), "bufferCommited()", this, "iface.calcularValores()");
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this, "closed()", this, "iface.desconectar()");
	this.child("tdbComandas").setReadOnly(false);
	
	if (!sys.isLoadedModule("flcontppal")) {
		this.child("tbwArqueo").setTabEnabled("contabilidad", false);
	}

	if (cursor.modeAccess() == cursor.Insert) {
		var codTerminal:String = util.readSettingEntry("scripts/fltpv_ppal/codTerminal");
		cursor.setValueBuffer("ptoventa",codTerminal);
		cursor.setValueBuffer("totalmov", 0);
		var fecha:Date = util.sqlSelect("tpv_arqueos", "MAX(diahasta)", "idtpv_arqueo <> '" + cursor.valueBuffer("idtpv_arqueo") + "'");
		if (fecha)
			cursor.setValueBuffer("diadesde",util.addDays(fecha,1));
	} else {
		this.child("fdbPuntoVenta").setDisabled(true);
		this.child("fdbCantInicial").setDisabled(true);
		this.child("fdbDiaDesde").setDisabled(true);
		this.iface.calcularValores();
	}
	if (cursor.valueBuffer("abierta")) {
		this.child("fdbDiaHasta").setValue("");
	}
}

function interna_calculateField(fN:String):String
{
	var cursor:FLSqlCursor = this.cursor();
	var valor:String;
	switch (fN) {
		case "inicio": {
			var inicio:Number = 0;
			var qryarqueos:FLSqlQuery = new FLSqlQuery();
			qryarqueos.setTablesList("tpv_arqueos");
			qryarqueos.setSelect("diahasta, totalcaja, totalmov, sacadodecaja");
			qryarqueos.setFrom("tpv_arqueos");
			qryarqueos.setWhere("idtpv_arqueo <> '" + cursor.valueBuffer("idtpv_arqueo") + "' AND ptoventa = '" + cursor.valueBuffer("ptoventa") + "' ORDER BY diahasta DESC");
			if (!qryarqueos.exec())
				return;
			if (qryarqueos.first())
				inicio = qryarqueos.value("totalcaja") - qryarqueos.value("sacadodecaja");
			valor = inicio;
			break;
		}
		default: {
			valor = this.iface.commonCalculateField(fN, this.cursor());
		}
	}
	return valor;
}
/** \C
No se puede crear más de un arqueo para un mismo punto de venta con un mismo intervalo
Si al aceptar el formulario de arqueos existe una cantidad para el movimiento de cierre nos preguntará si deseamos cerrar el arqueo
*/
function interna_validateForm():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var diaDesde:String = this.child("fdbDiaDesde").value();
	var ptoVenta:String = this.child("fdbPuntoVenta").value();
	var idArqueo:Number = this.cursor().valueBuffer("idtpv_arqueo");
	
	if (cursor.modeAccess() == cursor.Insert) {
		if(util.sqlSelect("tpv_arqueos","diadesde","idtpv_arqueo <> '" + idArqueo + "' AND ptoventa = '" + ptoVenta + "' AND (diadesde >= '" + diaDesde + "' OR diahasta >= '" + diaDesde + "')")){
			MessageBox.warning(util.translate("scripts", "Ya existe un arqueo para ese punto de venta que coincide con ese intervalo de fechas"),MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			return false;
		}
	}

	return true;
}

/** \D
Calcula el siguiente código para el arqueo
*/
function interna_calculateCounter()
{
	var util:FLUtil = new FLUtil();
	return util.nextCounter("idtpv_arqueo", this.cursor());
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_commonCalculateField(fN:String, cursor:FLSqlCursor):String
{
	var valor:String;
	var util:FLUtil = new FLUtil();
	switch (fN) {
		/** \C
		El campo --totalcaja-- se calcula como la suma de los campos --b500-- --b200-- --b100-- --b50-- --b20-- --b10-- --b5-- --m2-- --m1-- --m050-- --m020-- --m010-- --m005-- --m002-- --m001--
		*/
		case "totalcaja": {
			var b500:Number = parseFloat(cursor.valueBuffer("b500")) * 500;
			var b200:Number = parseFloat(cursor.valueBuffer("b200")) * 200;
			var b100:Number = parseFloat(cursor.valueBuffer("b100")) * 100;
			var b50:Number = parseFloat(cursor.valueBuffer("b50")) * 50;
			var b20:Number = parseFloat(cursor.valueBuffer("b20")) * 20;
			var b10:Number = parseFloat(cursor.valueBuffer("b10")) * 10;
			var b5:Number = parseFloat(cursor.valueBuffer("b5")) * 5;
			var m2:Number = parseFloat(cursor.valueBuffer("m2")) * 2;
			var m1:Number = parseFloat(cursor.valueBuffer("m1"));
			var m050:Number = parseFloat(cursor.valueBuffer("m050")) * 0.5;
			var m020:Number = parseFloat(cursor.valueBuffer("m020")) * 0.2;
			var m010:Number = parseFloat(cursor.valueBuffer("m010")) * 0.1;
			var m005:Number = parseFloat(cursor.valueBuffer("m005")) * 0.05;
			var m002:Number = parseFloat(cursor.valueBuffer("m002")) * 0.02;
			var m001:Number = parseFloat(cursor.valueBuffer("m001")) * 0.01;
			valor = b500 + b200 + b100 + b50 + b20 + b10 + b5 + m2 + m1 + m050 + m020 + m010 + m005 + m002 + m001;
			break;
		}
		/** \C
		El total de ventas en efectivo es la suma de los totales de las comandas con forma de pago 'CONT' 
		*/
		case "ventasEfectivo": {
			var codPago:String = util.sqlSelect("tpv_datosgenerales", "pagoefectivo", "1 = 1");
			valor = util.sqlSelect("tpv_pagoscomanda", "SUM(importe)", "idtpv_arqueo = '" + cursor.valueBuffer("idtpv_arqueo") + "' AND codpago = '" + codPago + "'");
			if (!valor || isNaN(valor))
				valor = 0;
			valor = util.roundFieldValue(valor, "tpv_arqueos", "totalcaja");
			break;
		}
		/** \C
		El total de ventas con tarjeta es la suma de los totales de las comandas con forma de pago 'TARJ' 
		*/
		case "ventasTarjeta": {
			var codPago:String = util.sqlSelect("tpv_datosgenerales", "pagotarjeta", "1 = 1");
			valor = util.sqlSelect("tpv_pagoscomanda", "SUM(importe)", "idtpv_arqueo = '" + cursor.valueBuffer("idtpv_arqueo") + "' AND codpago = '" + codPago + "'");
			if (!valor || isNaN(valor))
				valor = 0;
			valor = util.roundFieldValue(valor, "tpv_arqueos", "totalcaja");
			break;
		}
		/** \C
		El total de ventas con tarjeta es la suma de los totales de las comandas con forma de pago 'TARJ' 
		*/
		case "ventasVale": {
			var codPago:String = util.sqlSelect("tpv_datosgenerales", "pagovale", "1 = 1");
			valor = util.sqlSelect("tpv_pagoscomanda", "SUM(importe)", "idtpv_arqueo = '" + cursor.valueBuffer("idtpv_arqueo") + "' AND codpago = '" + codPago + "'");
			if (!valor || isNaN(valor))
				valor = 0;
			valor = util.roundFieldValue(valor, "tpv_arqueos", "totalcaja");
			break;
		}
		/** \C
		La diferencia de efectivo es el --totalcaja-- menos la suma de las ventas 'CONT'
		*/
		case "diferenciaEfectivo": {
			valor = parseFloat(this.iface.commonCalculateField("totalcaja", cursor)) - parseFloat(this.iface.commonCalculateField("calculadoEfectivo", cursor));
			valor = util.roundFieldValue(valor, "tpv_arqueos", "totalcaja");
			break;
		}
		/** \C
		La diferencia de tarjeta es el --totaltarjeta-- menos la suma de las ventas 'TARJ'
		*/
		case "diferenciaTarjeta": {
			valor = parseFloat(cursor.valueBuffer("totaltarjeta")) - parseFloat(this.iface.commonCalculateField("calculadoTarjeta", cursor));
			valor = util.roundFieldValue(valor, "tpv_arqueos", "totalcaja");
			break;
		}
		/** \C
		La diferencia de vales es el --totalvale-- menos la suma de las ventas 'VALE'
		*/
		case "diferenciaVale": {
			valor = parseFloat(cursor.valueBuffer("totalvale")) - parseFloat(this.iface.commonCalculateField("calculadoVale", cursor)); 
			valor = util.roundFieldValue(valor, "tpv_arqueos", "totalvale");
			break;
		}
		/** \C
		El total de ventas en efectivo es la suma de los pagos en efectivo más los movimientos de caja
		*/
		case "calculadoEfectivo": {
			valor = parseFloat(this.iface.commonCalculateField("totalmov", cursor)) + parseFloat(cursor.valueBuffer("inicio")) + parseFloat(this.iface.commonCalculateField("ventasEfectivo", cursor));
			valor = util.roundFieldValue(valor, "tpv_arqueos", "totalcaja");
			break;
		}
		/** \C
		El total de ventas con tarjeta es la suma de los totales de las comandas con forma de pago 'TARJ' 
		*/
		case "calculadoTarjeta": {
			valor = parseFloat(this.iface.commonCalculateField("ventasTarjeta", cursor));
			valor = util.roundFieldValue(valor, "tpv_arqueos", "totalcaja");
			break;
		}
		/** \C
		El total de ventas con vales es la suma de los totales de las comandas con forma de pago 'VALE' 
		*/
		case "calculadoVale": {
			valor = parseFloat(this.iface.commonCalculateField("ventasVale", cursor));
			valor = util.roundFieldValue(valor, "tpv_arqueos", "totalcaja");
			break;
		}
		/** \C
		El total --totalmov-- es la suma de las cantidades de todos los movimientos del arqueo
		*/
		case "totalmov": {
			valor = util.sqlSelect("tpv_movimientos","SUM(cantidad)","idtpv_arqueo = '" + cursor.valueBuffer("idtpv_arqueo") + "'");
			if (!valor || isNaN(valor))
				valor = 0;
			break;
		}
	}
	return valor;

}

/** \D
Calcula los totales
*/
function oficial_calcularValores()
{
	var util:FLUtil = new FLUtil;
	var total:Number;
	this.cursor().setValueBuffer("totalmov",this.iface.calculateField("totalmov"));
	
	var ventas1:String = this.iface.calculateField("ventasEfectivo");
	this.child("lblVentasEfectivo").setText(ventas1);
	
	var ventas2:String = this.iface.calculateField("ventasTarjeta");
	this.child("lblVentasTarjeta").setText(ventas2);

	var ventas3:String = this.iface.calculateField("ventasVale");
	this.child("lblVentasVale").setText(ventas3);

	var totalVentas:String = parseFloat(ventas1) + parseFloat(ventas2) + parseFloat(ventas3);
	totalVentas = util.roundFieldValue(totalVentas, "tpv_arqueos", "totalcaja");
	this.child("lblTotalVentas").setText(totalVentas);
	
	this.cursor().setValueBuffer("totalcaja", this.iface.calculateField("totalcaja"));
	
	total = this.iface.calculateField("calculadoEfectivo");
	this.child("lblCalculadoEfectivo").setText(total);
	
	total = this.iface.calculateField("calculadoTarjeta");
	this.child("lblCalculadoTarjeta").setText(total);

	total = this.iface.calculateField("calculadoVale");
	this.child("lblCalculadoVale").setText(total);
	
	total = this.iface.calculateField("diferenciaEfectivo");
	this.child("lblDiferenciaEfectivo").setText(total);
	
	total = this.iface.calculateField("diferenciaTarjeta");
	this.child("lblDiferenciaTarjeta").setText(total);

	total = this.iface.calculateField("diferenciaVale");
	this.child("lblDiferenciaVale").setText(total);
}

function oficial_bufferChanged(fN:String)
{
	var cursor:FLSqlCursor = this.cursor();

	switch (fN) {
		/** \C
		Cuando cambia el total por tarjeta, el total por vales o alguno de los campos --b500--, --b200--, --b100-- ... se recalculan los totales
		*/
		case "inicio":
		case "totalvale":
		case "totaltarjeta":
		case "b500":
		case "b200":
		case "b100":
		case "b50":
		case "b20":
		case "b10":
		case "b5":
		case "m2":
		case "m1":
		case "m050":
		case "m020":
		case "m010":
		case "m005":
		case "m002":
		case "m001": {
			this.iface.calcularValores();
			break;
		}
		case "ptoventa": {
			if (cursor.modeAccess() == cursor.Insert) {
				this.child("fdbCantInicial").setValue(this.iface.calculateField("inicio"));
			}
		}
	}
}
/** \D
Desconecta las funciones conectadas en el init
*/
function oficial_desconectar()
{
	disconnect(this.iface.tdbMovimientos.cursor(), "bufferCommited()", this, "iface.calcularValores()");
	disconnect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged");
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
