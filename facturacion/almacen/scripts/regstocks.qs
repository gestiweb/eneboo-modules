/***************************************************************************
                 regstocks.qs  -  description
                             -------------------
    begin                : lun abr 26 2004
    copyright            : (C) 2004 by InfoSiAL S.L.
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
    function oficial( context ) { interna( context ); }
	function calcularCantidad() {
		return this.ctx.oficial_calcularCantidad();
	}
	function calcularValoresUltReg() {
		return this.ctx.oficial_calcularValoresUltReg();
	}
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.oficial_commonCalculateField(fN, cursor);
	}
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	//function cambiarCantidad(cantidadNueva:Number) { return this.ctx.oficial_cambiarCantidad(cantidadNueva); }
	//function deshabilitarCantidad() { return this.ctx.oficial_deshabilitarCantidad(); }
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration scab */
/////////////////////////////////////////////////////////////////
//// STOCKS CABECERA ////////////////////////////////////////////
class scab extends oficial {
	var COL_FECHA:Number;
	var COL_HORA:Number;
	var COL_CANTIDAD:Number;
	var COL_ACUMULADO:Number;
	var COL_ORIGEN:Number;
	var COL_DESORIGEN:Number;
	var COL_DOCUMENTO:Number;
	var COL_IDDOCUMENTO:Number;
	var listaMovimientos_:Array;
	var tblMovimientos:Object;
	var filaMovActual_:Number;
    function scab( context ) { oficial ( context ); }
	function init() {
		return this.ctx.scab_init();
	}
	function tbwStock_currentChanged(pestana:String) {
		return this.ctx.scab_tbwStock_currentChanged(pestana);
	}
	function calcularCantidad() {
		return this.ctx.scab_calcularCantidad();
	}
	function commonCalculateField(fN:String, cursor:FLSqlCursor, idPedido:String):String {
		return this.ctx.scab_commonCalculateField(fN, cursor, idPedido);
	}
	function dameWhereStock(cursor:FLSqlCursor, campoAlmacen:String):String {
		return this.ctx.scab_dameWhereStock(cursor, campoAlmacen);
	}
	function calcularMovimientos() {
		return this.ctx.scab_calcularMovimientos();
	}
	function cargarListaMovimientos():Boolean {
		return this.ctx.scab_cargarListaMovimientos();
	}
	function crearMovimiento(qryMovimientos:FLSqlQuery, factor:Number, origen:String):Array {
		return this.ctx.scab_crearMovimiento(qryMovimientos, factor, origen);
	}
	function cargarAlbaranesCli():Boolean {
		return this.ctx.scab_cargarAlbaranesCli();
	}
	function cargarFacturasCli():Boolean {
		return this.ctx.scab_cargarFacturasCli();
	}
	function cargarAlbaranesProv():Boolean {
		return this.ctx.scab_cargarAlbaranesProv();
	}
	function cargarFacturasProv():Boolean {
		return this.ctx.scab_cargarFacturasProv();
	}
	function cargarTransStock():Boolean {
		return this.ctx.scab_cargarTransStock();
	}
	function cargarVentasTPV():Boolean {
		return this.ctx.scab_cargarVentasTPV();
	}
	function cargarUltReg():Boolean {
		return this.ctx.scab_cargarUltReg();
	}
	function mostrarListaMovimientos():Boolean {
		return this.ctx.scab_mostrarListaMovimientos();
	}
	function compararMovimientos(mov1:Array, mov2:Array):Number {
		return this.ctx.scab_compararMovimientos(mov1, mov2);
	}
	function insertarLineaTabla(indice:Number):Boolean {
		return this.ctx.scab_insertarLineaTabla(indice);
	}
	function generarTabla() {
		return this.ctx.scab_generarTabla();
	}
	function descripcionOrigen(origen:String):Boolean {
		return this.ctx.scab_descripcionOrigen(origen);
	}
	function tblMovimientos_currentChanged(row:Number, col:Number) {
		return this.ctx.scab_tblMovimientos_currentChanged(row, col);
	}
	function tbnVerDocumento_clicked() {
		return this.ctx.scab_tbnVerDocumento_clicked();
	}
	function mostrarDocumento(fila:Number, col:Number) {
		return this.ctx.scab_mostrarDocumento(fila, col);
	}
	function dameIdDocumento(origen:String, qryMovimientos:FLSqlQuery):Boolean {
		return this.ctx.scab_dameIdDocumento(origen, qryMovimientos);
	}
}
//// STOCKS CABECERA ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends scab {
    function head( context ) { scab ( context ); }
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration ifaceCtx */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends head {
    function ifaceCtx( context ) { head( context ); }
	function pub_cambiarCantidad(cantidad:Number) { return this.cambiarCantidad(cantidad); }
	function pub_commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.commonCalculateField(fN, cursor);
	}
}

const iface = new pubScab( this );
//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubScab */
/////////////////////////////////////////////////////////////////
//// PUB STOCKS CABECERA ////////////////////////////////////////
class pubScab extends ifaceCtx {
    function pubScab( context ) { ifaceCtx( context ); }
	function pub_commonCalculateField(fN:String, cursor:FLSqlCursor, idPedido:String):String {
		return this.commonCalculateField(fN, cursor, idPedido);
	}
}
//// PUB STOCKS CABECERA ////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition interna */
////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
/** \C La cantidad está deshabilitada

El valor del stock de un artículo se modificará de forma automática cuando haya modificación de:

- Lineas de albarán de proveedor (incrementan el stock)

- Lineas de factura de proveedor no automáticas (incrementan el stock)

- Lineas de pedido de cliente (decrementan el stock)

- Lineas de albarán de cliente no provenientes de un pedido (decrementan el stock)

- Lineas de factura de cliente no automáticas (decrementan el stock)

El valor del stock de un artículo se puede modificar de forma manual desde la ventana de regularizaciones de stock

\end */
function interna_init()
{
	var cursor:FLSqlCursor = this.cursor();
	//this.iface.deshabilitarCantidad();
	//connect(this.child("tdbLineasRegStocks").cursor(), "newBuffer()", this, "iface.deshabilitarCantidad");
	connect(this.child("tdbLineasRegStocks").cursor(), "bufferCommited()", this, "iface.calcularCantidad");
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	switch (cursor.modeAccess()) {
		case cursor.Edit: {
			this.child("pushButtonAcceptContinue").close();
			this.child("fdbReferencia").setDisabled(true);
			this.child("fdbCodAlmacen").setDisabled(true);
			break;
		}
	}
}

function interna_calculateField(fN:String):String
{
	var cursor:FLSqlCursor = this.cursor();
	return this.iface.commonCalculateField(fN, cursor);
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/*
function oficial_cambiarCantidad(cantidadNueva:Number)
{
		this.child("fdbCantidad").setValue(cantidadNueva);
		this.iface.deshabilitarCantidad();
}

function oficial_deshabilitarCantidad()
{
		this.child("fdbCantidad").setDisabled(true);
}
*/
function oficial_bufferChanged(fN:String)
{
	var cursor:FLSqlCursor = this.cursor();
	switch (fN) {
		case "cantidad":
		case "reservada": {
			cursor.setValueBuffer("disponible", this.iface.calculateField("disponible"));
			break;
		}
	}
}

function oficial_commonCalculateField(fN:String, cursor:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil;
	var valor:String;
	switch (fN) {
		case "disponible": {
			var cantidad:Number = parseFloat(cursor.valueBuffer("cantidad"));
			var reservada:Number = parseFloat(cursor.valueBuffer("reservada"));
			valor = cantidad - reservada;
			break;
		}
		case "cantidadultreg": {
			valor = util.sqlSelect("lineasregstocks", "cantidadfin", "idstock = " + cursor.valueBuffer("idstock") + " ORDER BY fecha DESC, hora DESC");
			if (isNaN(valor)) {
				valor = 0;
			}
			break;
		}
		case "fechaultreg": {
			valor = util.sqlSelect("lineasregstocks", "fecha", "idstock = " + cursor.valueBuffer("idstock") + " ORDER BY fecha DESC, hora DESC");
			break;
		}
		case "horaultreg": {
			valor = util.sqlSelect("lineasregstocks", "hora", "idstock = " + cursor.valueBuffer("idstock") + " ORDER BY fecha DESC, hora DESC");
			break;
		}
	}
	return valor;
}

function oficial_calcularCantidad()
{
	var cursor:FLSqlCursor = this.cursor();
	
	this.iface.calcularValoresUltReg();
	
	this.child("fdbCantidad").setValue(cursor.valueBuffer("cantidadultreg"));
}

function oficial_calcularValoresUltReg()
{
	var cursor:FLSqlCursor = this.cursor();
	var fechaUltReg:String = this.iface.calculateField("fechaultreg");
	if (fechaUltReg) {
		this.child("fdbFechaUltReg").setValue(fechaUltReg);
		this.child("fdbHoraUltReg").setValue(this.iface.calculateField("horaultreg"));
		this.child("fdbCantidadUltReg").setValue(this.iface.calculateField("cantidadultreg"));
	} else {
		cursor.setNull("fechaultreg");
		cursor.setNull("horaultreg");
		this.child("fdbCantidadUltReg").setValue(0);
	}
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition scab */
/////////////////////////////////////////////////////////////////
//// STOCKS CABECERA ////////////////////////////////////////////
function scab_init()
{
	this.iface.__init();

	this.iface.tblMovimientos = this.child("tblMovimientos");

	connect(this.child("tbwStock"), "currentChanged(QString)", this, "iface.tbwStock_currentChanged");
	connect(this.child("tbnVerDocumento"), "clicked()", this, "iface.tbnVerDocumento_clicked");
	connect(this.iface.tblMovimientos, "doubleClicked(int, int)", this, "iface.mostrarDocumento");
	connect(this.iface.tblMovimientos, "currentChanged(int, int)", this, "iface.tblMovimientos_currentChanged");
	

	this.iface.generarTabla();
}

function scab_tbwStock_currentChanged(pestana:String)
{
	if (pestana == "movimientos") {
		this.iface.calcularMovimientos();
	}
}

function scab_commonCalculateField(fN:String, cursor:FLSqlCursor, idPedido:String):String
{
debug("Calculando " + fN);
	var util:FLUtil = new FLUtil;
	var valor:String;
	switch (fN) {
		case "cantidadac": {
			var whereStock:String = this.iface.dameWhereStock(cursor, "d.codalmacen");
			valor = util.sqlSelect("lineasalbaranescli ld INNER JOIN albaranescli d ON ld.idalbaran = d.idalbaran", "SUM(ld.cantidad)", whereStock, "lineasalbaranescli,albaranescli");
debug("select SUM(ld.cantidad) from lineasalbaranescli ld INNER JOIN albaranescli d ON ld.idalbaran = d.idalbaran where " + whereStock);
			if (isNaN(valor)) {
				valor = 0;
			}
			break;
		}
		case "cantidadap": {
			var whereStock:String = this.iface.dameWhereStock(cursor, "d.codalmacen");
			valor = util.sqlSelect("lineasalbaranesprov ld INNER JOIN albaranesprov  d ON ld.idalbaran = d.idalbaran", "SUM(ld.cantidad)", whereStock, "lineasalbaranesprov,albaranesprov");
debug("select SUM(ld.cantidad) from lineasalbaranesprov ld INNER JOIN albaranesprov d ON ld.idalbaran = d.idalbaran where " + whereStock);
			if (isNaN(valor)) {
				valor = 0;
			}
			break;
		}
		case "cantidadfc": {
			var whereStock:String = this.iface.dameWhereStock(cursor, "d.codalmacen");
			valor = util.sqlSelect("lineasfacturascli ld INNER JOIN facturascli d ON ld.idfactura = d.idfactura", "SUM(ld.cantidad)", whereStock + " AND d.automatica <> true", "lineasfacturascli,facturascli");
			if (isNaN(valor)) {
				valor = 0;
			}
			break;
		}
		case "cantidadfp": {
			var whereStock:String = this.iface.dameWhereStock(cursor, "d.codalmacen");
			valor = util.sqlSelect("lineasfacturasprov ld INNER JOIN facturasprov d ON ld.idfactura = d.idfactura", "SUM(ld.cantidad)", whereStock + " AND d.automatica <> true", "lineasfacturasprov,facturasprov");
			if (isNaN(valor)) {
				valor = 0;
			}
			break;
		}
		case "cantidadtpv": {
			var whereStock:String = this.iface.dameWhereStock(cursor, "pv.codalmacen");
			valor = util.sqlSelect("tpv_lineascomanda ld INNER JOIN tpv_comandas d ON ld.idtpv_comanda = d.idtpv_comanda INNER JOIN tpv_puntosventa pv ON d.codtpv_puntoventa = pv.codtpv_puntoventa", "SUM(ld.cantidad)", whereStock, "tpv_lineascomanda,tpv_comandas");
			if (isNaN(valor)) {
				valor = 0;
			}
			break;
		}
		case "cantidadts": {
			var whereStockOrigen:String = this.iface.dameWhereStock(cursor, "d.codalmaorigen");
			var valorOrigen:Number = util.sqlSelect("lineastransstock ld INNER JOIN transstock d ON ld.idtrans = d.idtrans", "SUM(ld.cantidad)", whereStockOrigen, "lineastransstock,transstock");
			if (isNaN(valorOrigen)) {
				valorOrigen = 0;
			}
			var whereStockDestino:String = this.iface.dameWhereStock(cursor, "d.codalmadestino");
			var valorDestino:Number = util.sqlSelect("lineastransstock ld INNER JOIN transstock d ON ld.idtrans = d.idtrans", "SUM(ld.cantidad)", whereStockDestino, "lineastransstock,transstock");
			if (isNaN(valorDestino)) {
				valorDestino = 0;
			}
			valor = parseFloat(valorDestino) - parseFloat(valorOrigen);
			break;
		}
		case "reservada": {
			var codAlmacen:String = cursor.valueBuffer("codalmacen");
			var referencia:String = cursor.valueBuffer("referencia");
			var where:String = "p.codalmacen = '" + codAlmacen + "' AND lp.referencia = '" + referencia + "' AND (lp.cerrada IS NULL OR lp.cerrada = false)";
			if (idPedido && idPedido != "") {
				where += " AND (p.servido IN ('No', 'Parcial') OR p.idpedido = " + idPedido + ")";
			} else {
				where += " AND p.servido IN ('No', 'Parcial')";
			}
			valor = util.sqlSelect("lineaspedidoscli lp INNER JOIN pedidoscli p ON lp.idpedido = p.idpedido", "sum(lp.cantidad - lp.totalenalbaran)", where, "lineaspedidoscli,pedidoscli");
			if (isNaN(valor)) {
				valor = 0;
			}
			break;
		}
		case "pterecibir": {
			var codAlmacen:String = cursor.valueBuffer("codalmacen");
			var referencia:String = cursor.valueBuffer("referencia");
			var where:String = "p.codalmacen = '" + codAlmacen + "' AND lp.referencia = '" + referencia + "' AND (lp.cerrada IS NULL OR lp.cerrada = false)";
			if (idPedido && idPedido != "") {
				where += " AND (p.servido IN ('No', 'Parcial') OR p.idpedido = " + idPedido + ")";
			} else {
				where += " AND p.servido IN ('No', 'Parcial')";
			}
			valor = util.sqlSelect("lineaspedidosprov lp INNER JOIN pedidosprov p ON lp.idpedido = p.idpedido", "sum(lp.cantidad - lp.totalenalbaran)", where, "lineaspedidosprov,pedidosprov");
			if (isNaN(valor)) {
				valor = 0;
			}
			break;
		}
		case "cantidad": {
			var cantidadUltReg:Number = parseFloat(cursor.valueBuffer("cantidadultreg"));
			if (isNaN(cantidadUltReg)) {
				cantidadUltReg = 0;
			}
debug("ap = " + cursor.valueBuffer("cantidadap"));
debug("fp = " + cursor.valueBuffer("cantidadfp"));
debug("ac = " + cursor.valueBuffer("cantidadac"));
debug("fp = " + cursor.valueBuffer("cantidadfc"));
debug("ts = " + cursor.valueBuffer("cantidadts"));
debug("tpv = " + cursor.valueBuffer("cantidadtpv"));
			valor = cantidadUltReg + parseFloat(cursor.valueBuffer("cantidadap")) + parseFloat(cursor.valueBuffer("cantidadfp")) - parseFloat(cursor.valueBuffer("cantidadac")) - parseFloat(cursor.valueBuffer("cantidadfc")) + parseFloat(cursor.valueBuffer("cantidadts")) - parseFloat(cursor.valueBuffer("cantidadtpv"));
			break;
		}
		default: {
			valor = this.iface.__commonCalculateField(fN, cursor);
		}
	}
debug(fN + " = " + valor);
	return valor;
}

function scab_calcularCantidad()
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil;
	
	this.iface.calcularValoresUltReg();

	cursor.setValueBuffer("cantidadac", this.iface.calculateField("cantidadac"));
	cursor.setValueBuffer("cantidadap", this.iface.calculateField("cantidadap"));
	cursor.setValueBuffer("cantidadfc", this.iface.calculateField("cantidadfc"));
	cursor.setValueBuffer("cantidadfp", this.iface.calculateField("cantidadfp"));
	cursor.setValueBuffer("cantidadts", this.iface.calculateField("cantidadts"));
	if (sys.isLoadedModule("flfact_tpv")) {
		cursor.setValueBuffer("cantidadtpv", this.iface.calculateField("cantidadtpv"));
	} else {
		cursor.setValueBuffer("cantidadtpv", 0);
	}
	this.child("fdbCantidad").setValue(this.iface.calculateField("cantidad"));
	
}

function scab_dameWhereStock(cursor:FLSqlCursor, campoAlmacen:String):String
{
	var whereStock:String = campoAlmacen + " = '" + cursor.valueBuffer("codalmacen") + "' AND ld.referencia = '" + cursor.valueBuffer("referencia") + "'";
	if (!cursor.isNull("fechaultreg")) {
		whereStock += " AND ((d.fecha > '" + cursor.valueBuffer("fechaultreg") + "') OR (d.fecha = '" + cursor.valueBuffer("fechaultreg") + "' AND d.hora > '" + cursor.valueBuffer("horaultreg").toString().right(8) + "'))";
	}
	return whereStock;
}

function scab_calcularMovimientos()
{
	var util:FLUtil = new FLUtil;

	if (this.iface.listaMovimientos_) {
		delete this.iface.listaMovimientos_
	}
	this.iface.listaMovimientos_ = [];
	
	if (!this.iface.cargarListaMovimientos()) {
		MessageBox.warning(util.translate("scripts", "Error al cargar la lista de movimientos"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	if (!this.iface.mostrarListaMovimientos()) {
		MessageBox.warning(util.translate("scripts", "Error al mostrar la lista de movimientos"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	return true;
}

function scab_cargarListaMovimientos():Boolean
{
	var util:FLUtil = new FLUtil;
	if (!this.iface.cargarUltReg()) {
		MessageBox.warning(util.translate("scripts", "Error al cargar el movimiento de última regularización"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	if (!this.iface.cargarAlbaranesCli()) {
		MessageBox.warning(util.translate("scripts", "Error al cargar los movimientos de albaranes de cliente"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	if (!this.iface.cargarAlbaranesProv()) {
		MessageBox.warning(util.translate("scripts", "Error al cargar los movimientos de albaranes de proveedor"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	if (!this.iface.cargarFacturasCli()) {
		MessageBox.warning(util.translate("scripts", "Error al cargar los movimientos de facturas de cliente"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	if (!this.iface.cargarFacturasProv()) {
		MessageBox.warning(util.translate("scripts", "Error al cargar los movimientos de facturas de proveedor"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	if (!this.iface.cargarTransStock()) {
		MessageBox.warning(util.translate("scripts", "Error al cargar los movimientos de transferencias de stock"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	if (sys.isLoadedModule("flfact_tpv")) {
debug("Cargando TPV");
		if (!this.iface.cargarVentasTPV()) {
			MessageBox.warning(util.translate("scripts", "Error al cargar los movimientos de ventas de TPV"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}
	return true;
}

function scab_crearMovimiento(qryMovimientos:FLSqlQuery, factor:Number, origen:String):Array
{
	var util:FLUtil = new FLUtil;
	var fecha:Date = qryMovimientos.value("d.fecha");
	var hora:Date = qryMovimientos.value("d.hora")
	fecha.setHours(hora.getHours());
	fecha.setMinutes(hora.getMinutes());
	fecha.setSeconds(hora.getSeconds());

	var cantidad:Number = parseFloat(qryMovimientos.value("ld.cantidad"));
	cantidad = cantidad * factor;
	var codigo:String = qryMovimientos.value("d.codigo");
	if (!codigo) {
		codigo = "";
	}
debug("Fecha movimiento = " + fecha.toString() + " / " + fecha.getTime());
	var movimiento:Array = [];
	movimiento["fecha"] = util.dateAMDtoDMA(fecha);
	movimiento["hora"] = fecha.toString().right(8);
	movimiento["msec"] = fecha.getTime();
	movimiento["cantidad"] = cantidad;
	movimiento["origen"] = origen;
	movimiento["desorigen"] = this.iface.descripcionOrigen(origen);
	movimiento["documento"] = " " + codigo;
	movimiento["iddocumento"] = this.iface.dameIdDocumento(origen, qryMovimientos);
	return movimiento;
}

function scab_tblMovimientos_currentChanged(row:Number, col:Number)
{
	this.iface.filaMovActual_ = row;
}

function scab_tbnVerDocumento_clicked()
{
	this.iface.mostrarDocumento(this.iface.filaMovActual_, false);
}

function scab_mostrarDocumento(fila:Number, col:Number)
{
	var curDocumento:FLSqlCursor;
	var origen:String = this.iface.tblMovimientos.text(fila, this.iface.COL_ORIGEN);
	var idDocumento:String = this.iface.tblMovimientos.text(fila, this.iface.COL_IDDOCUMENTO);
	switch (origen) {
		case "AC": {
			curDocumento = new FLSqlCursor("albaranescli");
			curDocumento.select("idalbaran = " + idDocumento);
			break;
		}
		case "AP": {
			curDocumento = new FLSqlCursor("albaranesprov");
			curDocumento.select("idalbaran = " + idDocumento);
			break;
		}
		case "FC": {
			curDocumento = new FLSqlCursor("facturascli");
			curDocumento.select("idfactura = " + idDocumento);
			break;
		}
		case "FP": {
			curDocumento = new FLSqlCursor("facturasprov");
			curDocumento.select("idfactura = " + idDocumento);
			break;
		}
		case "TPV": {
			curDocumento = new FLSqlCursor("tpv_comandas");
			curDocumento.select("idtpv_comanda = " + idDocumento);
			break;
		}
		case "TS": {
			curDocumento = new FLSqlCursor("transstock");
			curDocumento.select("idtrans = " + idDocumento);
			break;
		}
		default: {
			return;
		}
	}
	if (curDocumento && curDocumento.first()) {
		curDocumento.browseRecord();
	}
}

function scab_descripcionOrigen(origen:String):Boolean
{
	var util:FLUtil = new FLUtil;
	var descripcion:String = "";
	switch (origen) {
		case "AC": {
			descripcion = util.translate("scripts", "Alb.Cliente");
			break;
		}
		case "AP": {
			descripcion = util.translate("scripts", "Alb.Proveedor");
			break;
		}
		case "FC": {
			descripcion = util.translate("scripts", "Fra.Cliente");
			break;
		}
		case "FP": {
			descripcion = util.translate("scripts", "Fra.Proveedor");
			break;
		}
		case "TS": {
			descripcion = util.translate("scripts", "Trans.Stock");
			break;
		}
		case "TPV": {
			descripcion = util.translate("scripts", "Venta TPV");
			break;
		}
		case "RS": {
			descripcion = util.translate("scripts", "Reg.Stock");
			break;
		}
	}
	return descripcion;
}

function scab_dameIdDocumento(origen:String, qryMovimientos:FLSqlQuery):Boolean
{
	var util:FLUtil = new FLUtil;
	var idDocumento:String = "";
	switch (origen) {
		case "AC": {
			idDocumento = qryMovimientos.value("d.idalbaran");
			break;
		}
		case "AP": {
			idDocumento = qryMovimientos.value("d.idalbaran");
			break;
		}
		case "FC": {
			idDocumento = qryMovimientos.value("d.idfactura");
			break;
		}
		case "FP": {
			idDocumento = qryMovimientos.value("d.idfactura");
			break;
		}
		case "TS": {
			idDocumento = qryMovimientos.value("d.idtrans");
			break;
		}
		case "TPV": {
			idDocumento = qryMovimientos.value("d.idtpv_comanda");
			break;
		}
		case "RS": {
			break;
		}
	}
	return idDocumento;
}

function scab_cargarAlbaranesCli():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var qryMovimientos:FLSqlQuery = new FLSqlQuery;
	qryMovimientos.setTablesList("albaranescli,lineasalbaranescli");
	qryMovimientos.setSelect("d.fecha, d.hora, ld.cantidad, d.codigo, d.idalbaran");
	qryMovimientos.setFrom("albaranescli d INNER JOIN lineasalbaranescli ld ON d.idalbaran = ld.idalbaran");
	qryMovimientos.setWhere(this.iface.dameWhereStock(cursor, "d.codalmacen"));
	qryMovimientos.setForwardOnly(true);
	if (!qryMovimientos.exec()) {
		return false;
	}
	var iMovimiento:Number = this.iface.listaMovimientos_.length;
	while (qryMovimientos.next()) {
		this.iface.listaMovimientos_[iMovimiento] = this.iface.crearMovimiento(qryMovimientos, -1, "AC");
		iMovimiento++;
	}
	return true;
}

function scab_cargarVentasTPV():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var qryMovimientos:FLSqlQuery = new FLSqlQuery;
	qryMovimientos.setTablesList("tpv_comandas,tpv_lineascomanda");
	qryMovimientos.setSelect("d.fecha, d.hora, ld.cantidad, d.codigo, d.idtpv_comanda");
	qryMovimientos.setFrom("tpv_comandas d INNER JOIN tpv_lineascomanda ld ON d.idtpv_comanda = ld.idtpv_comanda INNER JOIN tpv_puntosventa pv ON d.codtpv_puntoventa = pv.codtpv_puntoventa");
	qryMovimientos.setWhere(this.iface.dameWhereStock(cursor, "pv.codalmacen"));
	qryMovimientos.setForwardOnly(true);
	if (!qryMovimientos.exec()) {
		return false;
	}
debug("qryMovimientos = " + qryMovimientos.sql());
	var iMovimiento:Number = this.iface.listaMovimientos_.length;
	while (qryMovimientos.next()) {
		this.iface.listaMovimientos_[iMovimiento] = this.iface.crearMovimiento(qryMovimientos, -1, "TPV");
		iMovimiento++;
	}
	return true;
}

function scab_cargarFacturasCli():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var qryMovimientos:FLSqlQuery = new FLSqlQuery;
	qryMovimientos.setTablesList("facturascli,lineasfacturascli");
	qryMovimientos.setSelect("d.fecha, d.hora, ld.cantidad, d.codigo, d.idfactura");
	qryMovimientos.setFrom("facturascli d INNER JOIN lineasfacturascli ld ON d.idfactura = ld.idfactura");
	qryMovimientos.setWhere(this.iface.dameWhereStock(cursor, "d.codalmacen") + " AND d.automatica <> true");
	qryMovimientos.setForwardOnly(true);
	if (!qryMovimientos.exec()) {
		return false;
	}
	var iMovimiento:Number = this.iface.listaMovimientos_.length;
	while (qryMovimientos.next()) {
		this.iface.listaMovimientos_[iMovimiento] = this.iface.crearMovimiento(qryMovimientos, -1, "FC");
		iMovimiento++;
	}
	return true;
}

function scab_cargarAlbaranesProv():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var qryMovimientos:FLSqlQuery = new FLSqlQuery;
	qryMovimientos.setTablesList("albaranesprov,lineasalbaranesprov");
	qryMovimientos.setSelect("d.fecha, d.hora, ld.cantidad, d.codigo, d.idalbaran");
	qryMovimientos.setFrom("albaranesprov d INNER JOIN lineasalbaranesprov ld ON d.idalbaran = ld.idalbaran");
	qryMovimientos.setWhere(this.iface.dameWhereStock(cursor, "d.codalmacen"));
	qryMovimientos.setForwardOnly(true);
	if (!qryMovimientos.exec()) {
		return false;
	}
	var iMovimiento:Number = this.iface.listaMovimientos_.length;
	while (qryMovimientos.next()) {
		this.iface.listaMovimientos_[iMovimiento] = this.iface.crearMovimiento(qryMovimientos, 1, "AP");
		iMovimiento++;
	}
	return true;
}

function scab_cargarFacturasProv():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var qryMovimientos:FLSqlQuery = new FLSqlQuery;
	qryMovimientos.setTablesList("facturasprov,lineasfacturasprov");
	qryMovimientos.setSelect("d.fecha, d.hora, ld.cantidad, d.codigo, d.idfactura");
	qryMovimientos.setFrom("facturasprov d INNER JOIN lineasfacturasprov ld ON d.idfactura = ld.idfactura");
	qryMovimientos.setWhere(this.iface.dameWhereStock(cursor, "d.codalmacen") + " AND d.automatica <> true");
	qryMovimientos.setForwardOnly(true);
	if (!qryMovimientos.exec()) {
		return false;
	}
	var iMovimiento:Number = this.iface.listaMovimientos_.length;
	while (qryMovimientos.next()) {
		this.iface.listaMovimientos_[iMovimiento] = this.iface.crearMovimiento(qryMovimientos, 1, "FP");
		iMovimiento++;
	}
	return true;
}


function scab_cargarTransStock():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var qryMovimientos:FLSqlQuery = new FLSqlQuery;
	qryMovimientos.setTablesList("transstock,lineastransstock");
	qryMovimientos.setSelect("d.fecha, d.hora, ld.cantidad, d.idtrans");
	qryMovimientos.setFrom("lineastransstock ld INNER JOIN transstock d ON ld.idtrans = d.idtrans");
	qryMovimientos.setWhere(this.iface.dameWhereStock(cursor, "d.codalmaorigen"));
	qryMovimientos.setForwardOnly(true);
	if (!qryMovimientos.exec()) {
		return false;
	}
	var iMovimiento:Number = this.iface.listaMovimientos_.length;
	while (qryMovimientos.next()) {
		this.iface.listaMovimientos_[iMovimiento] = this.iface.crearMovimiento(qryMovimientos, -1, "TS");
		iMovimiento++;
	}
	
	qryMovimientos.setWhere(this.iface.dameWhereStock(cursor, "d.codalmadestino"));
	if (!qryMovimientos.exec()) {
		return false;
	}
	while (qryMovimientos.next()) {
		this.iface.listaMovimientos_[iMovimiento] = this.iface.crearMovimiento(qryMovimientos, 1, "TS");
		iMovimiento++;
	}
	return true;
}

function scab_cargarUltReg():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	if (!cursor.isNull("fechaultreg")) {
		var iMovimiento:Number = this.iface.listaMovimientos_.length;
		this.iface.listaMovimientos_[iMovimiento] = [];
		
		var util:FLUtil = new FLUtil;
		var fecha:Date = cursor.valueBuffer("fechaultreg");
		var hora:Date = cursor.valueBuffer("horaultreg");
		fecha.setHours(hora.getHours());
		fecha.setMinutes(hora.getMinutes());
		fecha.setSeconds(hora.getSeconds());

		var cantidad:Number = parseFloat(cursor.valueBuffer("cantidadultreg"));
		var origen:String = "RS";
		var movimiento:Array = [];
		this.iface.listaMovimientos_[iMovimiento]["fecha"] = util.dateAMDtoDMA(fecha);
		this.iface.listaMovimientos_[iMovimiento]["hora"] = fecha.toString().right(8);
		this.iface.listaMovimientos_[iMovimiento]["msec"] = fecha.getTime();
		this.iface.listaMovimientos_[iMovimiento]["cantidad"] = cantidad;
		this.iface.listaMovimientos_[iMovimiento]["origen"] = origen;
		this.iface.listaMovimientos_[iMovimiento]["desorigen"] = this.iface.descripcionOrigen(origen);
		this.iface.listaMovimientos_[iMovimiento]["documento"] = "-";
		this.iface.listaMovimientos_[iMovimiento]["iddocumento"] = 0;
	}
	return true;
}

function scab_mostrarListaMovimientos():Boolean
{
	var util:FLUtil = new FLUtil;
	this.iface.listaMovimientos_.sort(this.iface.compararMovimientos);

	var numFilas:Number = this.iface.tblMovimientos.numRows();
	for (fila = numFilas - 1; fila >=0 ; fila--) {
		this.iface.tblMovimientos.removeRow(fila);
	}

	for (var i:Number = 0; i < this.iface.listaMovimientos_.length; i++) {
		debug(this.iface.listaMovimientos_[i]["fecha"] + " - " + this.iface.listaMovimientos_[i]["hora"] + " - " + this.iface.listaMovimientos_[i]["cantidad"] + " - " + this.iface.listaMovimientos_[i]["origen"] + " - " + this.iface.listaMovimientos_[i]["documento"] + " - " + this.iface.listaMovimientos_[i]["msec"]);
		if (!this.iface.insertarLineaTabla(i)) {
			return false;
		}
	}
	return true;
}

function scab_insertarLineaTabla(indice:Number):Boolean
{
	var util:FLUtil = new FLUtil;
	var acumulado:Number = 0;
	if (indice > 0) {
		acumulado = parseFloat(this.iface.tblMovimientos.text((indice - 1), this.iface.COL_ACUMULADO));
	}
	var cantidad:Number = parseFloat(this.iface.listaMovimientos_[indice]["cantidad"]);
	acumulado += cantidad;

	cantidad = util.roundFieldValue(cantidad, "stocks", "cantidad");
	acumulado = util.roundFieldValue(acumulado, "stocks", "cantidad");

	this.iface.tblMovimientos.insertRows(indice);
	this.iface.tblMovimientos.setText(indice, this.iface.COL_FECHA, this.iface.listaMovimientos_[indice]["fecha"]);
	this.iface.tblMovimientos.setText(indice, this.iface.COL_HORA, this.iface.listaMovimientos_[indice]["hora"]);
	this.iface.tblMovimientos.setText(indice, this.iface.COL_DESORIGEN, this.iface.listaMovimientos_[indice]["desorigen"]);
	this.iface.tblMovimientos.setText(indice, this.iface.COL_DOCUMENTO, this.iface.listaMovimientos_[indice]["documento"]);
	this.iface.tblMovimientos.setText(indice, this.iface.COL_CANTIDAD, cantidad);
	this.iface.tblMovimientos.setText(indice, this.iface.COL_ACUMULADO, acumulado);
	this.iface.tblMovimientos.setText(indice, this.iface.COL_IDDOCUMENTO, this.iface.listaMovimientos_[indice]["iddocumento"]);
	this.iface.tblMovimientos.setText(indice, this.iface.COL_ORIGEN, this.iface.listaMovimientos_[indice]["origen"]);
	return true;
}

function scab_compararMovimientos(mov1:Array, mov2:Array):Number
{
debug("Comparando " + mov1["fecha"] + " / " + mov1["msec"] + " con " + mov2["fecha"] + " / " + mov2["msec"]);
	var resultado:Number;
	if (mov1["msec"] > mov2["msec"]) {
		resultado = 1;
	} else if (mov1["msec"] < mov2["msec"]) {
		resultado = -1;
	} else {
		resultado = 0;
	}
	return resultado;
}

function scab_generarTabla()
{
	this.iface.COL_FECHA = 0;
	this.iface.COL_HORA = 1;
	this.iface.COL_CANTIDAD = 2;
	this.iface.COL_ACUMULADO = 3;
	this.iface.COL_DESORIGEN = 4;
	this.iface.COL_DOCUMENTO = 5;
	this.iface.COL_ORIGEN = 6;
	this.iface.COL_IDDOCUMENTO = 7;
	
	this.iface.tblMovimientos.setNumCols(8);
	this.iface.tblMovimientos.setColumnWidth(this.iface.COL_FECHA, 100);
	this.iface.tblMovimientos.setColumnWidth(this.iface.COL_HORA, 80);
	this.iface.tblMovimientos.setColumnWidth(this.iface.COL_CANTIDAD, 100);
	this.iface.tblMovimientos.setColumnWidth(this.iface.COL_ACUMULADO, 100);
	this.iface.tblMovimientos.setColumnWidth(this.iface.COL_ORIGEN, 100);
	this.iface.tblMovimientos.setColumnWidth(this.iface.COL_DOCUMENTO, 120);
	this.iface.tblMovimientos.setColumnLabels("/", "Fecha/Hora/Cantidad/Acumulado/Origen/Documento");
	this.iface.tblMovimientos.hideColumn(this.iface.COL_ORIGEN);
	this.iface.tblMovimientos.hideColumn(this.iface.COL_IDDOCUMENTO);
}

//// STOCKS CABECERA ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////