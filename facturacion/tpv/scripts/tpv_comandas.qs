/***************************************************************************
                 tpv_comandas.qs  -  description
                             -------------------
    begin                : lun ago 19 2005
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
    function init() {
		return this.ctx.interna_init();
	}
	function calculateField(fN:String):String {
		return this.ctx.interna_calculateField(fN);
	}
	function validateForm():Boolean {
		return this.ctx.interna_validateForm();
	}
	function acceptedForm() {
		return this.ctx.interna_acceptedForm();
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var lblCantEntregada:Object;
	var lblCantCambio:Object;
	var lblCantPte:Object;
	var lblEntregado:Object;
	var lblCambio:Object;
	var fdbEstado:Object;
	var seleccionado:Boolean;
	var refrescoActivo:Boolean;
	var txtCanArticulo:Object;
	var txtDesArticulo:Object;
	var txtPvpArticulo:Object;
	var ivaArticulo:String;
	var tbnInsertarLinea:Object;
	var tbnImprimirVale:Object;
	var cursor:FLSqlCursor;
	var curLineas:FLSqlCursor;
	var curPagos:FLSqlCursor;
	var bloqueoProvincia:Boolean;
	var importePagado:Number;
	var config_:Array;
	function oficial( context ) { interna( context ); } 
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.oficial_commonCalculateField(fN, cursor);
	}
	function inicializarControles() {
		return this.ctx.oficial_inicializarControles();
	}
	function calcularTotales() {
		return this.ctx.oficial_calcularTotales();
	}
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function verificarHabilitaciones() {
		return this.ctx.oficial_verificarHabilitaciones();
	}
	function realizarPago():Boolean {
		return this.ctx.oficial_realizarPago();
	}
	function imprimirQuickClicked(){
		return this.ctx.oficial_imprimirQuickClicked();
	}
	function seleccionarTodo(){
		return this.ctx.oficial_seleccionarTodo();
	}
	function unoMas(){
		return this.ctx.oficial_unoMas();
	}
	function unoMenos(){
		return this.ctx.oficial_unoMenos();
	}
	function aplicarDescuento(){
		return this.ctx.oficial_aplicarDescuento();
	}
	function sumarUno(idLinea:Number):Boolean{
		return this.ctx.oficial_sumarUno(idLinea);
	}
	function restarUno(idLinea:Number):Boolean{
		return this.ctx.oficial_restarUno(idLinea);
	}
	function descontar(idLinea:Number,descuentoLineal:Number,porDescuento:Number):Boolean {
		return this.ctx.oficial_descontar(idLinea,descuentoLineal,porDescuento);
	}
	function calcularTotalesLinea(fN:String,cursor:FLSqlCursor):Number{
		return this.ctx.oficial_calcularTotalesLinea(fN,cursor);
	}
	function aplicarTarifa() {
		return this.ctx.oficial_aplicarTarifa();
	}
	function desconectar() {
		return this.ctx.oficial_desconectar();
	}
	function crearPago(importe:Number):Boolean {
		return this.ctx.oficial_crearPago(importe);
	}
	function refrescarPte() {
		return this.ctx.oficial_refrescarPte();
	}
	function calcularPagado() {
		return this.ctx.oficial_calcularPagado();
	}
	function abrirCajonClicked() {
		return this.ctx.oficial_abrirCajonClicked();
	}
	function insertarLineaClicked() {
		return this.ctx.oficial_insertarLineaClicked();
	}
	function datosLineaVenta() {
	    return this.ctx.oficial_datosLineaVenta();
	}
	function datosLineaVentaArt() {
	    return this.ctx.oficial_datosLineaVentaArt();
	}
	function datosLineaVentaCantidad() {
	    return this.ctx.oficial_datosLineaVentaCantidad();
	}
	function datosLineaVentaPrecio() {
	    return this.ctx.oficial_datosLineaVentaPrecio();
	}
	function imprimirVale() {
		return this.ctx.oficial_imprimirVale();
	}
	function mostrarFactura() {
		return this.ctx.oficial_mostrarFactura();
	}
	function datosVisorArt(curLineas:FLSqlCursor) {
		return this.ctx.oficial_datosVisorArt(curLineas);
	}
	function datosVisorPagar() {
		return this.ctx.oficial_datosVisorPagar();
	}
	function datosVisorImprimir() {
		return this.ctx.oficial_datosVisorImprimir();
	}
	function formatearLineaVisor(codPuntoVenta:String, numLinea:Number, datos:Array, formato:String):String {
		return this.ctx.oficial_formatearLineaVisor(codPuntoVenta, numLinea, datos, formato);
	}
	function escribirEnVisor(codPuntoVenta:String, datos:Array) {
		return this.ctx.oficial_escribirEnVisor(codPuntoVenta, datos);
	}
	function aplicarTarifaLinea(codTarifa:String):Boolean {
		return this.ctx.oficial_aplicarTarifaLinea(codTarifa);
	}
	function cargarConfiguracion() {
		return this.ctx.oficial_cargarConfiguracion();
	}
	function cursorAPosicionInicial() {
		return this.ctx.oficial_cursorAPosicionInicial();
	}
	function pbnPagar_clicked() {
		return this.ctx.oficial_pbnPagar_clicked();
	}
	function fdbCodBarras_returnPressed() {
		return this.ctx.oficial_fdbCodBarras_returnPressed();
	}
	function fdbReferencia_returnPressed() {
		return this.ctx.oficial_fdbReferencia_returnPressed();
	}
	function conectarInsercionRapida():Boolean {
		return this.ctx.oficial_conectarInsercionRapida();
	}
	function actualizarIvaLineas(codCliente:String) {
		return this.ctx.oficial_actualizarIvaLineas(codCliente);
	}
	function calcularIvaLinea(referencia:String) {
		return this.ctx.oficial_calcularIvaLinea(referencia);
	}
	function tbwComanda_currentChanged(tabName:String) {
		return this.ctx.oficial_tbwComanda_currentChanged(tabName);
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
Se calcula el arqueo buscando uno abierto para ese punto de venta que corresponda con la fecha establecida<br/>
Se establece por defecto el punto de venta local y como agente el agente asociado al punto de venta.
<br/>Al pulsar el botón pagar y establecer una cantidad la comanda se muestra en el recuadro superior derecho el importe entregado por el cliente y calcula el cambio que debemos devolverle.<br/>
Al pagar una comanda ésta se cerrará automáticamente creándose la factura, recibo, pago y asiento contable correspondientes.
*/
function interna_init()
{
	var util:FLUtil = new FLUtil();

	this.iface.bloqueoProvincia = false;

	if (!this.iface.curLineas)
		this.iface.curLineas = this.child("tdbLineasComanda").cursor();
	if (!this.iface.curPagos)
		this.iface.curPagos = this.child("tdbPagos").cursor();
	
	this.iface.lblCantEntregada = this.child("lblCantEntregada");
	this.iface.lblCantCambio = this.child("lblCantCambio");
	this.iface.lblCantPte = this.child("lblCantPte");
	this.iface.lblEntregado = this.child("lblEntregado");
	this.iface.lblCambio = this.child("lblCambio");
	this.iface.fdbEstado = this.child("fdbEstado");
	this.iface.lblCantCambio.setText("");
	this.iface.lblCantEntregada.setText("");
	this.iface.lblEntregado.setText("");
	this.iface.lblCambio.setText(""); 
	this.iface.seleccionado = false;
	this.iface.refrescoActivo = true;
	
	this.iface.txtCanArticulo = this.child("txtCanArticulo");
	this.iface.txtDesArticulo = this.child("txtDesArticulo");
	this.iface.txtPvpArticulo = this.child("txtPvpArticulo");
	this.iface.ivaArticulo = ""
	this.iface.tbnInsertarLinea = this.child("tbnInsertarLinea");
	this.iface.tbnImprimirVale = this.child("tbnImprimirVale");
	
	this.child("tdbRecibos").setReadOnly(true);
	
	var cursor:FLSqlCursor = this.cursor();
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this.child("tbwComanda"), "currentChanged(QString)", this, "iface.tbwComanda_currentChanged");

	connect(this.iface.curLineas, "bufferCommited()", this, "iface.calcularTotales()");
	connect(this.iface.curPagos, "bufferCommited()", this, "iface.calcularPagado()");
	
	connect(this.child("pbnPagar"), "clicked()", this, "iface.pbnPagar_clicked()");
	connect(this.child("tbnPrintQuick"),"clicked()", this, "iface.imprimirQuickClicked()");
	connect(this.child("tbnSelTodo"), "clicked()", this, "iface.seleccionarTodo()");
	connect(this.child("tbnUnoMas"), "clicked()", this, "iface.unoMas()");
	connect(this.child("tbnUnoMenos"), "clicked()", this, "iface.unoMenos()");
	connect(this.child("tbnDescuento"), "clicked()", this, "iface.aplicarDescuento()");
	connect(this.child("tbnOpenCash"),"clicked()", this, "iface.abrirCajonClicked()");
	connect(this.iface.tbnInsertarLinea, "clicked()", this, "iface.insertarLineaClicked()");
	connect(this.iface.tbnImprimirVale, "clicked()", this, "iface.imprimirVale()");
	connect(this.child("toolButtonZoomFactura"), "clicked()", this, "iface.mostrarFactura()");

	connect(this.iface.txtDesArticulo, "returnPressed()", this, "iface.insertarLineaClicked()");
	connect(this.iface.txtCanArticulo, "returnPressed()", this, "iface.insertarLineaClicked()");
	connect(this.iface.txtPvpArticulo, "returnPressed()", this, "iface.insertarLineaClicked()");

	this.iface.refrescarPte();
	switch (cursor.modeAccess()) {
		case cursor.Insert: {
			var hoy:Date = new Date;
			cursor.setValueBuffer("fecha", hoy.toString());
			var codTerminal:String = util.readSettingEntry("scripts/fltpv_ppal/codTerminal");
			if (codTerminal && util.sqlSelect("tpv_puntosventa","codtpv_puntoventa","codtpv_puntoventa ='" + codTerminal + "'")) {
				this.child("fdbCodTpvPuntoventa").setValue(codTerminal);
				this.child("fdbCodAlmacen").setValue(util.sqlSelect("tpv_puntosventa","codalmacen","codtpv_puntoventa ='" + codTerminal + "'"));
				var agente:String = util.sqlSelect("tpv_puntosventa","codtpv_agente","codtpv_puntoventa ='" + codTerminal + "'");
				if (!agente || agente == "") {
					MessageBox.warning(util.translate("scripts",
					"No hay establecido ningún agente para el punto de venta '" + codTerminal + "'"),MessageBox.Ok,MessageBox.NoButton,MessageBox.NoButton);
					this.form.close();
				}
				this.child("fdbAgente").setValue(agente);
			}
			else {
				MessageBox.warning(util.translate("scripts",
				"No hay establecido ningún Punto de Venta Local\no el Punto de Venta establecido no es válido.\nSeleccione un Punto de Venta válido en la tabla \ny pulse el botón Cambiar"),MessageBox.Ok,MessageBox.NoButton,MessageBox.NoButton);
				this.form.close();
				return;
			}
			this.child("fdbTarifa").setValue(util.sqlSelect("tpv_datosgenerales","tarifa","1=1"));
			this.child("fdbCodPago").setValue(util.sqlSelect("tpv_datosgenerales","pagoefectivo","1=1"));
			
			this.iface.txtCanArticulo.text = 1;
			this.child("fdbCodCliente").setValue(util.sqlSelect("tpv_datosgenerales", "codcliente", "1 = 1"));
			break;
		}
		case cursor.Edit: {
			this.child("fdbCodigo").setDisabled(true);
			this.child("fdbCodTpvPuntoventa").setDisabled(true);
			this.iface.txtCanArticulo.text = 1;
			break;
		}
	}
	this.iface.inicializarControles();
	this.iface.bufferChanged("tipopago");
	
	this.iface.importePagado = 0;

	this.iface.cargarConfiguracion();

}

function interna_calculateField(fN:String):String
{
	var util:FLUtil = new FLUtil();
	var valor:String;
	var cursor:FLSqlCursor = this.cursor();

	switch (fN) {
		/** \C
		El --pagado-- es la suma de los pagos
		*/
		case "pagado": {
			valor = util.sqlSelect("tpv_pagoscomanda", "SUM(importe)", "idtpv_comanda = " + cursor.valueBuffer("idtpv_comanda") + " AND estado = '" + util.translate("scripts" , "Pagado") + "'");
			valor = util.roundFieldValue(valor, "tpv_comandas", "pagado");
			break;
		}
		/** \C
		El --Pendiente-- es el --total-- menos el --pagado--
		*/
		case "pendiente": {
			valor = parseFloat(cursor.valueBuffer("total")) - parseFloat(cursor.valueBuffer("pagado"));
			break;
		}
		/** \C
		El --total-- es el --neto-- más el --totaliva-- más totalrecargo
		*/
		case "total": {
			var neto:Number = parseFloat(this.iface.calculateField("neto"));
			var totalIva:Number = parseFloat(this.iface.calculateField("totaliva"));
			var totalRecargo = parseFloat(cursor.valueBuffer("totalrecargo"));
			valor = neto + totalIva + totalRecargo;
			break;
		}
		/** \C
		El --neto-- es la suma del pvp total de las líneas de la comanda
		*/
		case "neto": {
			valor = util.sqlSelect("tpv_lineascomanda", "SUM(pvptotal)", "idtpv_comanda = " + cursor.valueBuffer("idtpv_comanda"));
			if (!valor)
				valor = 0;
			valor = util.roundFieldValue(valor, "tpv_comandas", "neto");
			break;
		}
		/** \C
		El --totaliva-- es la suma del iva correspondiente a las líneas de la comanda
		*/
		case "totaliva": {
			valor = util.sqlSelect("tpv_lineascomanda", "SUM((pvptotal * iva) / 100)", "idtpv_comanda = " + cursor.valueBuffer("idtpv_comanda"));
			valor = util.roundFieldValue(valor, "tpv_comandas", "totaliva");
			break;
		}
	    case "totalrecargo": {
	      	valor = util.sqlSelect("tpv_lineascomanda", "SUM((pvptotal * recargo) / 100)", "idtpv_comanda = " + cursor.valueBuffer("idtpv_comanda"));
	      	valor = util.roundFieldValue(valor, "tpv_comandas", "totalrecargo");
	      	break;
	    }
		case "desarticulo": {
			valor = util.sqlSelect("articulos", "descripcion", "referencia = '" + cursor.valueBuffer("referencia") + "'");
			if (!valor)
				valor = "";
			break;
		}
		case "pvparticulo": {
			valor = formRecordtpv_lineascomanda.iface.calcularPvpTarifa(cursor.valueBuffer("referencia"), cursor.valueBuffer("codtarifa"));
			if (!valor)
				valor = "0";
			break;
		}
		case "estado": {
			var total:Number = parseFloat(cursor.valueBuffer("total"));
			if (total != 0 && total == parseFloat(cursor.valueBuffer("pagado"))) {
				valor = "Cerrada";
			} else {
				valor = "Abierta";
			}
			break;
		}
		case "coddir": {
			valor = util.sqlSelect("dirclientes", "id", "codcliente = '" + cursor.valueBuffer("codcliente") +  "' AND domfacturacion = 'true'");
			if (!valor) {
				valor = "";
			}
			break;
		}
		case "provincia": {
			valor = util.sqlSelect("dirclientes", "provincia", "id = " + cursor.valueBuffer("coddir"));
			if (!valor)
				valor = cursor.valueBuffer("provincia");
			break;
		}
		case "codpais": {
			valor = util.sqlSelect("dirclientes", "codpais", "id = " + cursor.valueBuffer("coddir"));
			if (!valor)
				valor = cursor.valueBuffer("codpais");
			break;
		}
	}
	return valor;
}

/** \D Comprueba que el total es mayor que la suma de los pagos
\end */
function interna_validateForm():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	if (parseFloat(cursor.valueBuffer("total")) < parseFloat(cursor.valueBuffer("pagado"))) {
		MessageBox.warning(util.translate("scripts", "El total de la venta no puede ser inferior a los pagos registrados"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	if (!flfactppal.iface.pub_validarProvincia(cursor)) {
		return false;
	}

	var idComanda = cursor.valueBuffer("idtpv_comanda");
	var codCliente = cursor.valueBuffer("codcliente");
	if (!flfacturac.iface.pub_validarIvaRecargoCliente(codCliente, idComanda, "tpv_lineascomanda", "idtpv_comanda")) {
		return false;
	}

	return true;
}

/** \D Si la comanda está completamente pagada, pasa a estado Cerrada
\end */
function interna_acceptedForm()
{
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_commonCalculateField(fN:String, cursor:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil();
	var valor:String;

	switch (fN) {
		case "ivaarticulo": {
			var codSerie:String = "";
			var codCliente:String = util.sqlSelect("tpv_comandas", "codcliente", "idtpv_comanda = '" + cursor.valueBuffer("idtpv_comanda") + "'");
			if (flfacturac.iface.pub_tieneIvaDocCliente(codSerie, codCliente)) {
				valor = util.sqlSelect("articulos", "codimpuesto", "referencia = '" + cursor.valueBuffer("referencia") + "'");
			}
			else {
				valor = "";
			}
			break;
		}
	}
	return valor;
}

/** \D
Llama a la función verificarHabilitaciones
*/
function oficial_inicializarControles()
{
	this.iface.verificarHabilitaciones();
}

/** \D
Calcula el neto, totaliva y total llamando a la función claculateField
*/
function oficial_calcularTotales()
{
	this.child("fdbNeto").setValue(this.iface.calculateField("neto"));
	this.child("fdbTotalIva").setValue(this.iface.calculateField("totaliva"));
  	this.child("fdbTotalRecargo").setValue(this.iface.calculateField("totalrecargo"));
	this.child("fdbTotalComanda").setValue(this.iface.calculateField("total"));
	
	this.iface.verificarHabilitaciones();
}

function oficial_bufferChanged(fN:String)
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	switch (fN) {
		/** \C
		Al cambiar el --totaliva-- se calcula el --total-- 
		*/
		case "totaliva":{
			this.child("fdbTotalComanda").setValue(this.iface.calculateField("total"));
			this.iface.verificarHabilitaciones();
			break;
		}
		/** \C
		Al cambiar el --total-- o el --pagado-- se actualiza el pendiente de pago
		*/
		case "total":
		case "pagado": {
			this.child("fdbPendiente").setValue(this.iface.calculateField("pendiente"));
			this.iface.refrescarPte();
			cursor.setValueBuffer("estado", this.iface.calculateField("estado"));
			break;
		}
		/** \C
		Al calculase el arqueo se desabilita el código, punto de venta, agente y fecha
		*/
		case "idtpv_arqueo":{
			if(cursor.valueBuffer("idtpv_arqueo")) {
				this.child("fdbCodigo").setDisabled(true);
				this.child("fdbCodTpvPuntoventa").setDisabled(true);
				this.child("fdbAgente").setDisabled(true);
				this.child("fdbFecha").setDisabled(true);
			}
			break;
		}
		/** \C
		Al cambiar la --codtarifa-- se recalculan los totales aplicando la nueva tarifa a todas las lineas de la comanda preguntando antes si deseamos hacerlo
		*/
		case "codtarifa":{
			if (!cursor.valueBuffer("codtarifa"))
				break;
			if(this.child("tdbLineasComanda").cursor().size() > 0){
				var res:Number = MessageBox.warning(util.translate("scripts", "¿Desea aplicar la nueva tarifa a todas las lineas?"),MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
				if(res == MessageBox.Yes)
					this.iface.aplicarTarifa();
			}
			break;
		}
		/** \C
		Al cambiar el --tipopago-- se calcula la forma de pago establecida por defecto para ese tipo de pago en el formulario de datos generales
		*/
		case "tipopago":{
			if (cursor.valueBuffer("tipopago") == "Efectivo") {
				var pagoEfectivo:String = util.sqlSelect("tpv_datosgenerales", "pagoefectivo", "1=1");
				if(!pagoEfectivo || pagoEfectivo == "")
					MessageBox.information(util.translate("scripts", "No tiene configurada la forma de pago efectivo en el formulario de datos generales"),MessageBox.Ok, MessageBox.NoButton);
				cursor.setValueBuffer("codpago", pagoEfectivo);
			}
			else if (cursor.valueBuffer("tipopago") == "Tarjeta") {
				var pagoTarjeta:String = util.sqlSelect("tpv_datosgenerales", "pagotarjeta", "1=1");
				if(!pagoTarjeta || pagoTarjeta == "")
					MessageBox.information(util.translate("scripts", "No tiene configurada la forma de pago tarjeta en el formulario de datos generales"),MessageBox.Ok, MessageBox.NoButton);
				cursor.setValueBuffer("codpago", pagoTarjeta);
			}
			else {
				var pagoVale:String = util.sqlSelect("tpv_datosgenerales", "pagovale", "1=1");
				if (!pagoVale || pagoVale == "")
					MessageBox.information(util.translate("scripts", "No tiene configurada la forma de pago vale en el formulario de datos generales"),MessageBox.Ok, MessageBox.NoButton);
				cursor.setValueBuffer("codpago", pagoVale );
			}
			break;
		}
		/** \C
		Al cambiar la --referencia-- se calcula su descripción y precio unitario, y se almacena su impuesto asociado
		*/
		case "referencia": {
			this.iface.txtDesArticulo.text = this.iface.calculateField("desarticulo");
			this.iface.txtPvpArticulo.text = this.iface.calculateField("pvparticulo");
			this.iface.ivaArticulo = this.iface.calculateField("ivaarticulo");
			if(cursor.valueBuffer("tipopago") == "Efectivo") 
				cursor.setValueBuffer("codpago",util.sqlSelect("tpv_datosgenerales","pagoefectivo","1=1"));
			else
				cursor.setValueBuffer("codpago",util.sqlSelect("tpv_datosgenerales","pagotarjeta","1=1"));
			break;
		}
		/** \C
		El valor de --coddir-- por defecto corresponde a la dirección del cliente marcada como dirección de facturación
		\end */
		case "codcliente": {
			this.child("fdbCodDir").setValue("0");
			this.child("fdbCodDir").setValue(this.iface.calculateField("coddir"));
			this.iface.actualizarIvaLineas(cursor.valueBuffer("codcliente"));
			break;
		}
		case "provincia": {
			if (!this.iface.bloqueoProvincia) {
				this.iface.bloqueoProvincia = true;
				flfactppal.iface.pub_obtenerProvincia(this);
				this.iface.bloqueoProvincia = false;
			}
			break;
		}
		case "idprovincia": {
			if (cursor.valueBuffer("idprovincia") == 0)
				cursor.setNull("idprovincia");
			break;
		}
		case "coddir": {
			this.child("fdbProvincia").setValue(this.iface.calculateField("provincia"));
			this.child("fdbCodPais").setValue(this.iface.calculateField("codpais"));
			break;
		}
		case "codbarrasLinea": {
			var referencia:String = util.sqlSelect("articulos", "referencia", "codbarras = '" + cursor.valueBuffer("codbarras") + "'");
			if (referencia) {
				this.child("fdbReferencia").setValue(referencia);
			}
			break;
		}
		case "codbarras": {
			/// Borrar cuando funcione codBarras_returnPressed()
			var referencia:String = util.sqlSelect("articulos", "referencia", "codbarras = '" + cursor.valueBuffer("codbarras") + "'");
			if (referencia) {
				this.child("fdbReferencia").setValue(referencia);
			}
			break;
		}
	}
}

/** \C
Si la comanda está cerrada no podrá modificarse.<br/>
Si el --total-- es 0 no se podrá pagar, aplicar un descuento o sumar y restar 1 a la cantidad de las lineas
*/
function oficial_verificarHabilitaciones()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	if (parseFloat(this.child("fdbTotalComanda").value()) == 0){
			this.child("pbnPagar").setDisabled(true);
	} else {
		this.child("pbnPagar").setDisabled(false);
	}
	
	if (!util.sqlSelect("tpv_lineascomanda", "idtpv_linea", "idtpv_comanda = " + cursor.valueBuffer("idtpv_comanda"))) {
		this.child("fdbCodAlmacen").setDisabled(false);
	} else {
		this.child("fdbCodAlmacen").setDisabled(true);
	}

}

/** \C
Al establecer una cantidad de pago se calcula el importe a devolver
Si el importe entregado es mayor o igual al importe total de las lineas de la comanda, ésta se establecerá como cerrada
*/
function oficial_realizarPago():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	this.iface.datosVisorPagar();

	this.iface.refrescarPte();
	var impPendiente:Number = parseFloat(this.iface.lblCantPte.text);
	if (!impPendiente)
		return false;
	
	/*
	var dialog:Dialog = new Dialog(util.translate ( "scripts", "Importe entregado" ), 0, "entregado");
	
	dialog.OKButtonText = util.translate ( "scripts", "Aceptar" );
	dialog.cancelButtonText = util.translate ( "scripts", "Cancelar" );
	
	var entregado:LineEdit= new LineEdit;
	entregado.label = util.translate ( "scripts", "Importe entregado:" );
	entregado.text = impPendiente;
	dialog.add( entregado );

	if ( !dialog.exec() )
		return false;
	*/
	var idUsuario:String = sys.nameUser();
	var f:Object = new FLFormSearchDB("tpv_cantidadpago");
	var curCantidadPago:FLSqlCursor = f.cursor();
	
	curCantidadPago.select("idusuario = '" + idUsuario + "'");
	if (!curCantidadPago.first())
		curCantidadPago.setModeAccess(curCantidadPago.Insert);
	else
		curCantidadPago.setModeAccess(curCantidadPago.Edit);
	
	
	f.setMainWidget();
	curCantidadPago.refreshBuffer();
	curCantidadPago.setValueBuffer("idusuario", idUsuario);
	curCantidadPago.setValueBuffer("importe", impPendiente);
	
	var entregado:String = f.exec("importe");
	if (!entregado)
		return false;

	this.iface.importePagado = entregado;
		
	curCantidadPago.commitBuffer();
	
	var impEntregado:Number = parseFloat(entregado);
	var cambio:Number = 0;
	if (impEntregado == 0)
		return false;
		
	this.iface.lblEntregado.setText(util.translate("scripts", "Entregado"));
	this.iface.lblCantEntregada.setText(util.roundFieldValue(impEntregado, "tpv_comandas", "total"));
	cursor.setValueBuffer("ultentregado", util.roundFieldValue(impEntregado, "tpv_comandas", "total"));
		
	cambio = impEntregado - impPendiente;
	if (cambio > 0) {
		this.iface.lblCambio.setText(util.translate("scripts", "Cambio"));
		this.iface.lblCantCambio.setText(util.roundFieldValue(cambio, "tpv_comandas", "total"));
		cursor.setValueBuffer("ultcambio", util.roundFieldValue(cambio, "tpv_comandas", "total"));
		if (!this.iface.crearPago(impPendiente))
			return false;
	} else {
		this.iface.lblCambio.setText(util.translate("scripts", "Nuevo Pte."));
		this.iface.lblCantCambio.setText(util.roundFieldValue(cambio * -1, "tpv_comandas", "total"));
		cursor.setValueBuffer("ultcambio", 0);
		if (!this.iface.crearPago(impEntregado))
			return false;
	}

	this.iface.verificarHabilitaciones();
	return true;
}

/** \D
Imprime el tique de la comanda. Antes guarda los datos actuales para poder obtenerlos correctamente en el informe
*/
function oficial_imprimirQuickClicked()
{
	var cursor:FLSqlCursor = this.cursor();

	this.iface.datosVisorImprimir();

	if (!this.iface.validateForm())
		return false;
	this.iface.acceptedForm();
	if (!cursor.commitBuffer())
		return false;
	cursor.setModeAccess(cursor.Edit);
	cursor.refreshBuffer();

	var util:FLUtil = new FLUtil();
	var pv:String = util.readSettingEntry( "scripts/fltpv_ppal/codTerminal" );

	if ( !pv )
			pv = util.sqlSelect( "tpv_puntosventa", "codtpv_puntoventa", "1=1") ;
		
	var impresora:String = util.sqlSelect( "tpv_puntosventa", "impresora","codtpv_puntoventa = '" + pv + "'") ;
	
	if (!formtpv_comandas.iface.pub_imprimirQuick(this.cursor().valueBuffer("codigo"), impresora))
		return false;
}

/** \D
Selecciona todas las lineas de la comanda
*/
function oficial_seleccionarTodo()
{
	if(this.iface.seleccionado){
		this.child("tbnSelTodo").setOn(false);
		this.iface.seleccionado = false;
	}
	else {
		this.child("tbnSelTodo").setOn(true);
		this.iface.seleccionado = true;
	}
}

/** \D
Suma uno a la cantidad de las líneas seleccionadas
*/
function oficial_unoMas()
{
	var cursor:FLSqlCursor = this.cursor();
	var curTrans:FLSqlCursor = new FLSqlCursor("tpv_lineascomanda");
	
	if (this.iface.seleccionado){
		var qry:FLSqlQuery = new FLSqlQuery();
		qry.setTablesList("tpv_lineascomanda");
		qry.setSelect("idtpv_linea");
		qry.setFrom("tpv_lineascomanda");
		qry.setWhere("idtpv_comanda = '" + cursor.valueBuffer("idtpv_comanda") + "'");
		if (!qry.exec())
			return;
		while(qry.next()) {
			curTrans.transaction(false);
			try {
				if (this.iface.sumarUno(qry.value(0)))
					curTrans.commit();
				else
					curTrans.rollback();
			} catch (e) {
				MessageBox.warning(util.translate("scripts", "Hubo un error al incrementar la cantidad de las líneas:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
				curTrans.rollback();
			}
		}
	} else {
		curTrans.transaction(false);
		try {
			if (this.iface.sumarUno(this.child("tdbLineasComanda").cursor().valueBuffer("idtpv_linea")))
				curTrans.commit();
			else
				curTrans.rollback();
		} catch (e) {
			MessageBox.warning(util.translate("scripts", "Hubo un error al incrementar la cantidad de las líneas:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
			curTrans.rollback();
		}
	}
		
	this.child("tdbLineasComanda").refresh();
}

/** \D
Suma uno a la cantidad de una linea
@param idLinea identificador de la linea
@return devuelve true si se ha sumado correctamente y false si ha habido algún error
*/
function oficial_sumarUno(idLinea:Number):Boolean
{
	if (!idLinea)
		return false;
		
	var curLinea:FLSqlCursor = new FLSqlCursor("tpv_lineascomanda");
	curLinea.select("idtpv_linea = " + idLinea);
	curLinea.first();
	curLinea.setModeAccess(curLinea.Edit);
	curLinea.refreshBuffer();
	curLinea.setValueBuffer("cantidad",parseFloat(curLinea.valueBuffer("cantidad")) + 1);
	curLinea.setValueBuffer("pvpsindto",this.iface.calcularTotalesLinea("pvpsindto",curLinea));
	curLinea.setValueBuffer("pvptotal",this.iface.calcularTotalesLinea("pvptotal",curLinea));
	if (!curLinea.commitBuffer())
		return false;

	this.iface.calcularTotales();
	return true;
}


/** \D
Resta uno a la cantidad de las lineas seleccionadas
Si la cantidad es cero elimina las lineas
*/
function oficial_unoMenos()
{
	var cursor:FLSqlCursor = this.cursor();
	var curTrans:FLSqlCursor = new FLSqlCursor("tpv_lineascomanda");

	if (this.iface.seleccionado){
		var qry:FLSqlQuery = new FLSqlQuery();
		qry.setTablesList("tpv_lineascomanda");
		qry.setSelect("idtpv_linea");
		qry.setFrom("tpv_lineascomanda");
		qry.setWhere("idtpv_comanda = '" + cursor.valueBuffer("idtpv_comanda") + "'");
		if (!qry.exec())
			return;
		while (qry.next()) {
			curTrans.transaction(false);
			try {
				if (this.iface.restarUno(qry.value(0)))
					curTrans.commit();
				else
					curTrans.rollback();
			} catch (e) {
				MessageBox.warning(util.translate("scripts", "Hubo un error al decrementar la cantidad de las líneas:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
				curTrans.rollback();
			}
		}
	} else {
		curTrans.transaction(false);
		try {
			if (this.iface.restarUno(this.child("tdbLineasComanda").cursor().valueBuffer("idtpv_linea")))
				curTrans.commit();
			else
				curTrans.rollback();
		} catch (e) {
			MessageBox.warning(util.translate("scripts", "Hubo un error al decrementar la cantidad de las líneas:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
			curTrans.rollback();
		}
	}
	this.child("tdbLineasComanda").refresh();
}

/** \D
Resta uno a la cantidad de una linea
@param idLinea identificador de la linea
@return devuelve true si se ha restado correctamente y false si ha habido algún error
*/
function oficial_restarUno(idLinea:Number):Boolean
{
	if(!idLinea)
		return false;
	
	var util:FLUtil = new FLUtil();
	var curLinea:FLSqlCursor = new FLSqlCursor("tpv_lineascomanda");
	curLinea.select("idtpv_linea = " + idLinea);
	curLinea.first();
	var cantidad:Number = parseFloat(curLinea.valueBuffer("cantidad")) - 1;
	if(cantidad == 0){
		var res:Number = MessageBox.warning(util.translate("scripts", "La cantidad de la linea ") + idLinea + util.translate("scripts", " es 0 ¿Seguro que desea eliminarla?"),MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
		if(res != MessageBox.Yes)
			return false;
		curLinea.setModeAccess(curLinea.Del);
	}
	else {
		curLinea.setModeAccess(curLinea.Edit);
		curLinea.refreshBuffer();
		curLinea.setValueBuffer("cantidad",cantidad);
		curLinea.setValueBuffer("pvpsindto",this.iface.calcularTotalesLinea("pvpsindto",curLinea));
		curLinea.setValueBuffer("pvptotal",this.iface.calcularTotalesLinea("pvptotal",curLinea));
	}
	if(!curLinea.commitBuffer())
		return false;
	this.iface.calcularTotales();
	return true;
}

/** \D
Aplica un descueto a las líneas selecciondas
*/
function oficial_aplicarDescuento()
{
	var util:FLUtil = new FLUtil();
	var dialog:Dialog = new Dialog(util.translate ( "scripts", "Descuento" ), 0, "desucento");
	
	dialog.OKButtonText = util.translate ( "scripts", "Aceptar" );
	dialog.cancelButtonText = util.translate ( "scripts", "Cancelar" );
	
	var descuentoLineal:NumberEdit= new NumberEdit;
	descuentoLineal.value = this.child("tdbLineasComanda").cursor().valueBuffer("dtolineal");
	descuentoLineal.label = util.translate ( "scripts", "Descuento lineal:" );
	descuentoLineal.maximum = this.child("tdbLineasComanda").cursor().valueBuffer("pvpsindto");
	descuentoLineal.decimals = 2;
	dialog.add( descuentoLineal );
	
	var porDescuento:NumberEdit= new NumberEdit;
	porDescuento.value = this.child("tdbLineasComanda").cursor().valueBuffer("dtopor");
	porDescuento.label = util.translate ( "scripts", "% Descuento:" );
	porDescuento.maximum = 100;
	porDescuento.decimals = 2;
	dialog.add( porDescuento );

	if ( !dialog.exec() )
		return true;

	if(this.iface.seleccionado){
		var qry:FLSqlQuery = new FLSqlQuery();
		qry.setTablesList("tpv_lineascomanda");
		qry.setSelect("idtpv_linea");
		qry.setFrom("tpv_lineascomanda");
		qry.setWhere("idtpv_comanda = '" + this.cursor().valueBuffer("idtpv_comanda") + "'");
		if (!qry.exec())
			return;
		while(qry.next())
			this.iface.descontar(qry.value(0),descuentoLineal.value,porDescuento.value);
	}
	else
		this.iface.descontar(this.child("tdbLineasComanda").cursor().valueBuffer("idtpv_linea"),descuentoLineal.value,porDescuento.value);

	this.child("tdbLineasComanda").refresh();
}

/** \D
Aplica un descuento a la linea
@param idLinea identificador de la linea
@param descuentoLineal descuento lineal
@param porDescuento descuento en porcentaje
@return devuelve true si se ha aplicado correctamente y false si ha habido algún error
*/
function oficial_descontar(idLinea:Number,descuentoLineal:Number,porDescuento:Number):Boolean
{
	if(!idLinea)
		return false;
		
	var curLinea:FLSqlCursor = new FLSqlCursor("tpv_lineascomanda");
	curLinea.select("idtpv_linea = " + idLinea);
	curLinea.first();
	curLinea.setModeAccess(curLinea.Edit);
	curLinea.refreshBuffer();
	curLinea.setValueBuffer("dtolineal",descuentoLineal);
	curLinea.setValueBuffer("dtopor",porDescuento);
	curLinea.setValueBuffer("pvptotal",this.iface.calcularTotalesLinea("pvptotal",curLinea));
	if(!curLinea.commitBuffer())
		return false;
	this.iface.calcularTotales();
	return true;
}

/** \D
Calcula los totales de la linea de la factura creada
*/
function oficial_calcularTotalesLinea(fN:String,cursor:FLSqlCursor):Number
{
	var util:FLUtil = new FLUtil();
	var valor:Number;

	switch (fN) {
		/** \c
		EL --pvpsindto-- es el --pvpunitario-- multiplicado por la --cantidad--
		*/
		case "pvpsindto":{
			valor = parseFloat(cursor.valueBuffer("pvpunitario")) * parseFloat(cursor.valueBuffer("cantidad"));
			valor = util.roundFieldValue(valor, "tpv_lineascomanda", "pvpsindto");
			break;
		}
		/** \c
		EL --pvptotal-- es el --pvpsindto-- menos el descuento --dtopor-- menos el --dtolineal--
		*/
		case "pvptotal":{ 
			var dtoPor:Number = (cursor.valueBuffer("pvpsindto") * cursor.valueBuffer("dtopor")) / 100;
			dtoPor = util.roundFieldValue(dtoPor, "tpv_lineascomanda", "pvpsindto");
			valor = cursor.valueBuffer("pvpsindto") - parseFloat(dtoPor) - cursor.valueBuffer("dtolineal");
			break;
		}
	}
	return valor;
}

/** \D
Aplica la tarifa establecida a todas las lineas de la comanda
*/
function oficial_aplicarTarifa()
{
	var codTarifa = this.cursor().valueBuffer("codtarifa");
	var qry:FLSqlQuery = new FLSqlQuery();
	qry.setTablesList("tpv_lineascomanda");
	qry.setSelect("idtpv_linea,referencia");
	qry.setFrom("tpv_lineascomanda");
	qry.setWhere("idtpv_comanda = '" + this.cursor().valueBuffer("idtpv_comanda") + "'");
	if (!qry.exec()) {
		return;
	}
	
	if (!this.iface.curLineas) {
		this.iface.curLineas = new FLSqlCursor("tpv_lineascomanda");
	}
	while(qry.next()) {
// 		var pvp:Number = formRecordtpv_lineascomanda.iface.pub_calcularPvpTarifa(qry.value(1),codTarifa);
		this.iface.curLineas.select("idtpv_linea = " + qry.value("idtpv_linea"));
		this.iface.curLineas.first();
		
		this.iface.curLineas.setModeAccess(this.iface.curLineas.Edit);
		this.iface.curLineas.refreshBuffer();
		if (!this.iface.aplicarTarifaLinea(codTarifa)) {
			return false;
		}
		if (!this.iface.curLineas.commitBuffer()) {
			return;
		}
	}
	
	this.iface.calcularTotales();
	this.child("tdbLineasComanda").refresh();
}

function oficial_aplicarTarifaLinea(codTarifa:String):Boolean
{
	this.iface.curLineas.setValueBuffer("pvpunitario", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpunitario", this.iface.curLineas));
	this.iface.curLineas.setValueBuffer("pvpsindto",
	formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpsindto", this.iface.curLineas));
	this.iface.curLineas.setValueBuffer("pvptotal",
	formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotal", this.iface.curLineas));
	return true;
}

/** \D
Desconecta las funciones conectadas en el init
*/
function oficial_desconectar()
{
	disconnect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged");
	disconnect(this.child("tdbLineasComanda").cursor(), "bufferCommited()", this, "iface.calcularTotales()");
	disconnect(this.child("pbnPagar"), "clicked()", this, "iface.realizarPago()");
	disconnect(this.child("tbnPrintQuick"),"clicked()", this, "iface.imprimirQuickClicked()");
	disconnect(this.child("tbnSelTodo"), "clicked()", this, "iface.seleccionarTodo()");
	disconnect(this.child("tbnUnoMas"), "clicked()", this, "iface.unoMas()");
	disconnect(this.child("tbnUnoMenos"), "clicked()", this, "iface.unoMenos()");
	disconnect(this.child("tbnDescuento"), "clicked()", this, "iface.aplicarDescuento()");
	disconnect(this.child("tbnOpenCash"),"clicked()", this, "iface.abrirCajonClicked()");
}

/** \D
Crea un pago
@param	importe: Importe del pago
@return	true si el pago se crea correctamente, false en caso contrario
*/
function oficial_crearPago(importe:Number):Boolean
{
	this.iface.refrescoActivo = false;
	
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var fecha:Date = cursor.valueBuffer("fecha");
	var idComanda:String = cursor.valueBuffer("idtpv_comanda");
	
	var curPago:FLSqlCursor = this.child("tdbPagos").cursor();
	var codTerminal:String = util.readSettingEntry("scripts/fltpv_ppal/codTerminal");
	with (curPago) {
		setModeAccess(Insert);
		refreshBuffer();
		setValueBuffer("idtpv_comanda", idComanda);
		setValueBuffer("importe", importe);
		setValueBuffer("fecha", fecha);
		setValueBuffer("estado", util.translate("scripts", "Pagado"));
		if (codTerminal) {
			setValueBuffer("codtpv_puntoventa", codTerminal);
			setValueBuffer("codtpv_agente", cursor.valueBuffer("codtpv_agente")); //util.sqlSelect("tpv_puntosventa","codtpv_agente","codtpv_puntoventa ='" + codTerminal + "'"));
		}
	}
	curPago.setValueBuffer("codpago", cursor.valueBuffer("codpago"));
	
	if (!curPago.commitBuffer()) {
		this.iface.refrescoActivo = true;
		return false;
	}
	
	this.iface.refrescoActivo = true;
	return true;
}

/** \D Refresca el display con la cantidad pendiente de pago
\end */
function oficial_refrescarPte() 
{
	if (!this.iface.refrescoActivo)
		return;
	
	var util:FLUtil = new FLUtil;
	this.iface.lblCantPte.setText(util.roundFieldValue(this.cursor().valueBuffer("pendiente"), "tpv_comandas", "total"));
	this.iface.lblEntregado.setText("");
	this.iface.lblCambio.setText("");
	this.iface.lblCantEntregada.setText("");
	this.iface.lblCantCambio.setText("");
	
}

/** \D Calcula el total pagado cuando el cursor de pagos cambia
\end */
function oficial_calcularPagado()
{
	this.child("fdbPagado").setValue(this.iface.calculateField("pagado"));
}

/** \D Abre el cajón portamonedas
*/
function oficial_abrirCajonClicked()
{
	var util:FLUtil = new FLUtil();
	var pv:String = util.readSettingEntry( "scripts/fltpv_ppal/codTerminal" );

	if ( !pv ) {
		pv = util.sqlSelect( "tpv_puntosventa", "codtpv_puntoventa", "1=1") ;
	}

	var impresora:String = util.sqlSelect( "tpv_puntosventa", "impresora", "codtpv_puntoventa = '" + pv + "'") ;
	var escAbrir:String = util.sqlSelect( "tpv_puntosventa", "abrircajon", "codtpv_puntoventa = '" + pv + "'") ;
	formtpv_comandas.iface.pub_abrirCajon( impresora, escAbrir);
}

/** \D Inserta la línea con los datos de inserción rápida
\end */
function oficial_insertarLineaClicked()
{
	var util:FLUtil = new FLUtil;
	if (isNaN(parseFloat(this.iface.txtCanArticulo.text)))
		return;
	if (isNaN(parseFloat(this.iface.txtPvpArticulo.text)))
		return;
	if (this.iface.txtDesArticulo.text == "")
		return;

	var cursor:FLSqlCursor = this.cursor();
	this.iface.curLineas = this.child("tdbLineasComanda").cursor();
	this.iface.curLineas.setModeAccess(this.iface.curLineas.Insert);

	if (cursor.modeAccess() == cursor.Insert) {
		if (!this.iface.curLineas.commitBufferCursorRelation()){
			return;
		}
	}
	this.iface.curLineas.refreshBuffer();
	if (!this.iface.datosLineaVenta()){
		return;
	}

	this.iface.datosVisorArt(this.iface.curLineas);

	if (!this.iface.curLineas.commitBuffer()){
		return;
	}
	this.iface.txtCanArticulo.text = "";
	this.child("fdbReferencia").setValue("");
	this.child("fdbCodBarras").setValue("");
	this.iface.txtDesArticulo.text = "";
	this.iface.txtPvpArticulo.text = "";
	this.iface.ivaArticulo = "";
	this.iface.txtCanArticulo.text = "1";
	this.iface.cursorAPosicionInicial();

	this.child("tdbLineasComanda").refresh();
}

/** |D Establece los datos de la línea de ventas a crear mediante la inserción rápida
\end */
function oficial_datosLineaVenta()
{
	if (!this.iface.datosLineaVentaArt()) {
		return false;
	}
	if (!this.iface.datosLineaVentaCantidad()) {
		return false;
	}
	if (!this.iface.datosLineaVentaPrecio()) {
		return false;
	}
	return true;
}

function oficial_datosLineaVentaArt()
{
  var util = new FLUtil;
  var cursor = this.cursor();
  this.iface.curLineas.setValueBuffer("referencia", cursor.valueBuffer("referencia"));
  this.iface.curLineas.setValueBuffer("descripcion", this.iface.txtDesArticulo.text);
  this.iface.curLineas.setValueBuffer("pvpunitario", util.roundFieldValue(this.iface.txtPvpArticulo.text, "tpv_lineascomanda", "pvpunitario"));
  this.iface.curLineas.setValueBuffer("iva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("iva", this.iface.curLineas));
  this.iface.curLineas.setValueBuffer("recargo", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("recargo", this.iface.curLineas));
  
  return true;
}

function oficial_datosLineaVentaCantidad()
{
  var util = new FLUtil;
  var cursor = this.cursor();
  this.iface.curLineas.setValueBuffer("cantidad", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("cantidad", this.iface.curLineas));
  return true;
}

function oficial_datosLineaVentaPrecio()
{
  var util = new FLUtil;
  var cursor = this.cursor();
  this.iface.curLineas.setValueBuffer("codimpuesto",  this.iface.calcularIvaLinea(this.iface.curLineas.valueBuffer("referencia")));
  this.iface.curLineas.setValueBuffer("pvpsindto", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpsindto", this.iface.curLineas));
  this.iface.curLineas.setValueBuffer("dtopor", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("dtopor", this.iface.curLineas));
  this.iface.curLineas.setValueBuffer("pvptotal", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotal", this.iface.curLineas));
  return true;
}

function oficial_calcularIvaLinea(referencia:String):String
{
	var cursor:FLSqlCursor = this.cursor();
	var valor:String;	
	var util:FLUtil = new FLUtil();
	var codSerie:String = "";
	if (flfacturac.iface.pub_tieneIvaDocCliente(codSerie, cursor.valueBuffer("codcliente"))) {
		if (referencia) {
			valor = util.sqlSelect("articulos", "codimpuesto", "referencia = '" + referencia + "'");
		} else {
			valor = flfactalma.iface.pub_valorDefectoAlmacen("codimpuesto");
		}
	}
	else {
		valor = "";
	}
	return valor;
}

/** \D Imprime el vale seleccionado
\end */
function oficial_imprimirVale()
{
	var referenciaVale:String = this.child("tdbVales").cursor().valueBuffer("referencia");
	if (!referenciaVale)
		return;

	formtpv_vales.iface.pub_imprimir(referenciaVale);
}

/** \D Muestra la factura asociada a la venta
\end */
function oficial_mostrarFactura()
{
	var cursor:FLSqlCursor = this.cursor();
	var idFactura:String = cursor.valueBuffer("idfactura");
	if (!idFactura || idFactura == "")
		return;
	var curFactura:FLSqlCursor = new FLSqlCursor("facturascli");
	curFactura.select("idfactura = " + idFactura);
	if (!curFactura.first())
		return;
	curFactura.browseRecord();
}

function oficial_datosVisorArt(curLineas:FLSqlCursor)
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var codPuntoVenta:String = cursor.valueBuffer("codtpv_puntoventa");

	var datos:Array = [];
	datos[0] = cursor.valueBuffer("referencia");
	
	var des:String = util.sqlSelect("articulos", "descripcion", "referencia = '" + datos[0] + "'");
	if (!des)
		des = "";
	datos[1] = des;

	var otrosDatos:Array = [];
	otrosDatos[0] = "PVP";
	
	var precio:Number = util.roundFieldValue(this.child("txtPvpArticulo").text, "tpv_comandas", "total");
	if (!precio || precio == "")
		precio = 0;
	otrosDatos[1] = precio;
	
	var linea1:String = this.iface.formatearLineaVisor(codPuntoVenta, 1, datos, "CONCAT");
	var linea2:String = this.iface.formatearLineaVisor(codPuntoVenta, 2, otrosDatos, "SEPARAR");
	var datosVisor:Array = [];
	datosVisor[0] = linea1;
	datosVisor[1] = linea2;
debug(datosVisor);
	this.iface.escribirEnVisor(codPuntoVenta, datosVisor);
}


function oficial_datosVisorPagar()
{
	var cursor:FLSqlCursor = this.cursor();
	var codPuntoVenta:String = cursor.valueBuffer("codtpv_puntoventa");

	var datos:Array = [];
	datos[0] = "TOTAL";
	datos[1] = cursor.valueBuffer("total");
	
	var linea1:String = this.iface.formatearLineaVisor(codPuntoVenta, 1, datos, "SEPARAR");
	var linea2:String = "";
	var datosVisor:Array = [];
	datosVisor[0] = linea1;
	datosVisor[1] = linea2;
	this.iface.escribirEnVisor(codPuntoVenta, datosVisor);
}

function oficial_datosVisorImprimir()
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var codPuntoVenta:String = cursor.valueBuffer("codtpv_puntoventa");
	var datos:Array = [];
	datos [0] = "ENTREGADO";
	datos [1] = util.roundFieldValue(this.iface.importePagado,"tpv_comandas","total");

	var otrosDatos:Array = [];
	otrosDatos[0] = "CAMBIO";
	otrosDatos[1] = util.roundFieldValue(parseFloat(this.iface.importePagado - cursor.valueBuffer("total")),"tpv_comandas","total");

	var linea1:String = this.iface.formatearLineaVisor(codPuntoVenta, 1, datos, "SEPARAR");
	var linea2:String = this.iface.formatearLineaVisor(codPuntoVenta, 2, otrosDatos, "SEPARAR");
	var datosVisor:Array = [];
	datosVisor[0] = linea1;
	datosVisor[1] = linea2;
	this.iface.escribirEnVisor(codPuntoVenta, datosVisor);
}

function oficial_formatearLineaVisor(codPuntoVenta:String, numLinea:Number, datos:Array, formato:String):String
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var cadena:String = "";
	var longLinea = util.sqlSelect("tpv_puntosventa", "numcaractvisor", "codtpv_puntoventa = '" + codPuntoVenta + "'");
	if (!longLinea) {
		longLinea  = 25;
	}
	var numDatos:Number = datos.length;
	
	switch (formato) {
		case "CONCAT": {
			for (var i:Number = 0; i < numDatos; i++) {
				if (cadena == "") {
					cadena = datos[i];
				} else {
					cadena += "-" + datos[i];
				}
			}
			cadena = cadena.left(longLinea);
			break;
		}
		case "SEPARAR": {
			var ultimoValor:String = datos[numDatos - 1].toString();
			for (var i:Number = 0; i < (numDatos - 1); i++)
				cadena += datos[i] + " ";
			var totalEspacios:Number = longLinea - cadena.length - ultimoValor.length;
			if (totalEspacios < 0) {
				cadena = cadena.left(longLinea - (ultimoValor.length + 1));
				cadena += " ";
			} else {
				for (var i:Number = 0; i < totalEspacios; i++)
					cadena += " ";
			}
			cadena += ultimoValor;
			break;
		}
	}

	var visor:String = "";
	for (var i:Number = 0; i < longLinea; i++) {
		visor += "*";
	}
debug(visor);
debug(cadena);
	return cadena;
}

function oficial_escribirEnVisor(codPuntoVenta:String, datos:Array)
{
	var util:FLUtil = new FLUtil();

	try {
    	var serialPort:FLSerialPort = new FLSerialPort( nameSerialPort );
	} catch (e) { return; }

	var usarVisor:Boolean = util.sqlSelect("tpv_puntosventa", "usarvisor", "codtpv_puntoventa = '" + codPuntoVenta + "'");
	if (usarVisor != true) {
		return;
	}
    var nameSerialPort:String = util.sqlSelect("tpv_puntosventa", "nombrepuertovisor", "codtpv_puntoventa = '" + codPuntoVenta + "'");

	if (!nameSerialPort || nameSerialPort == "") {
		MessageBox.information(util.translate("scripts",
		"No es posible usar el visor asociado al punto de venta '" + codPuntoVenta + "'.\n Debe informar el campo Nombre puerto en el formulario del punto de venta"),MessageBox.Ok,MessageBox.NoButton);
		return false;
	}
	
	var serialPort:FLSerialPort = new FLSerialPort( nameSerialPort );

	var baud:String = "";
	var baudRateVisor:Number = util.sqlSelect("tpv_puntosventa", "baudratevisor", "codtpv_puntoventa = '" + codPuntoVenta + "'");
	if (!baudRateVisor || baudRateVisor == "") {
		MessageBox.information(util.translate("scripts",
		"No es posible usar el visor asociado al punto de venta '" + codPuntoVenta + "'.\n Debe informar el campo Baud Rate en el formulario del punto de venta"),MessageBox.Ok,MessageBox.NoButton);
		return false;
	}
	switch (baudRateVisor) {
		case "50": {
			baud = serialPort.BAUD50;
			break;
		}
		case "75": {
			baud = serialPort.BAUD75;
			break;
		}
		case "110": {
			baud = serialPort.BAUD110;
			break;
		}
		case "134": {
			baud = serialPort.BAUD134;
			break;
		}
		case "150": {
			baud = serialPort.BAUD150;
			break;
		}
		case "200": {
			baud = serialPort.BAUD200;
			break;
		}
		case "300": {
			baud = serialPort.BAUD300;
			break;
		}
		case "600": {
			baud = serialPort.BAUD600;
			break;
		}
		case "1200": {
			baud = serialPort.BAUD1200;
			break;
		}
		case "1800": {
			baud = serialPort.BAUD1800;
			break;
		}
		case "2400": {
			baud = serialPort.BAUD2400;
			break;
		}
		case "4800": {
			baud = serialPort.BAUD4800;
			break;
		}
		case "9600": {
			baud = serialPort.BAUD9600;
			break;
		}
		case "14400": {
			baud = serialPort.BAUD14400;
			break;
		}
		case "19200": {
			baud = serialPort.BAUD19200;
			break;
		}
		case "38400": {
			baud = serialPort.BAUD38400;
			break;
		}
		case "56000": {
			baud = serialPort.BAUD56000;
			break;
		}
		case "57600": {
			baud = serialPort.BAUD57600;
			break;
		}
		case "76800": {
			baud = serialPort.BAUD76800;
			break;
		}
		case "115200": {
			baud = serialPort.BAUD115200;
			break;
		}
		case "128000": {
			baud = serialPort.BAUD128000;
			break;
		}
		case "256000": {
			baud = serialPort.BAUD256000;
			break;
		}
	}

	var data:String = "";
	var bitDatos:Number = util.sqlSelect("tpv_puntosventa", "bitdatosvisor", "codtpv_puntoventa = '" + codPuntoVenta + "'");
	if (!bitDatos || bitDatos == "") {
		MessageBox.information(util.translate("scripts",
		"No es posible usar el visor asociado al punto de venta '" + codPuntoVenta + "'.\n Debe informar el campo Bit datos en el formulario del punto de venta"),MessageBox.Ok,MessageBox.NoButton);
		return false;
	}
	switch (bitDatos) {
		case "5": {
			data = serialPort.DATA_5;
			break;
		}
		case "6": {
			data = serialPort.DATA_6;
			break;
		}
		case "7": {
			data = serialPort.DATA_7;
			break;
		}
		case "8": {
			data = serialPort.DATA_8;
			break;
		}
	}

	var par:String = "";
	var paridad:String = util.sqlSelect("tpv_puntosventa", "paridadvisor", "codtpv_puntoventa = '" + codPuntoVenta + "'");
	if (!paridad || paridad == "") {
		MessageBox.information(util.translate("scripts",
		"No es posible usar el visor asociado al punto de venta '" + codPuntoVenta + "'.\n Debe informar el campo Paridad en el formulario del punto de venta"),MessageBox.Ok,MessageBox.NoButton);
		return false;
	}
	switch (paridad) {
		case "Sin paridad": {
			par = serialPort.PAR_NONE;
			break;
		}
		case "Impar": {
			par = serialPort.PAR_ODD;
			break;
		}
		case "Par": {
			par = serialPort.PAR_EVEN;
			break;
		}
		case "MARK": {
			par = serialPort.PAR_MARK;
			break;
		}
		case "SPACE": {
			par = serialPort.PAR_SPACE;
			break;
		}
	}

	var stop:String = "";
	var bitStop:String = util.sqlSelect("tpv_puntosventa", "bitstopvisor", "codtpv_puntoventa = '" + codPuntoVenta + "'");
	if (!bitStop || bitStop == "") {
		MessageBox.information(util.translate("scripts",
		"No es posible usar el visor asociado al punto de venta '" + codPuntoVenta + "'.\n Debe informar el campo Bit stop en el formulario del punto de venta"),MessageBox.Ok,MessageBox.NoButton);
		return false;
	}
	switch (bitStop) {
		case "1": {
			stop = serialPort.STOP_1;
			break;
		}
		case "1_5": {
			stop = serialPort.STOP_1_5;
			break;
		}
		case "2": {
			stop = serialPort.STOP_2;
			break;
		}
	}

	var flow:String = "";
	var flowControl:String = util.sqlSelect("tpv_puntosventa", "flowcontrol", "codtpv_puntoventa = '" + codPuntoVenta + "'");
	if (!flowControl || flowControl == "") {
		MessageBox.information(util.translate("scripts",
		"No es posible usar el visor asociado al punto de venta '" + codPuntoVenta + "'.\n Debe informar el campo Control Flujo en el formulario del punto de venta"),MessageBox.Ok,MessageBox.NoButton);
		return false;
	}
	switch (flowControl) {
		case "FLOW_HARDWARE": {
			flow = serialPort.FLOW_HARDWARE;
			break;
		}
		case "FLOW_OFF": {
			flow = serialPort.FLOW_OFF;
			break;
		}
		case "FLOW_XONXOFF": {
			flow = serialPort.FLOW_XONXOFF;
			break;
		}
	}
    serialPort.setBaudRate( baud );
    serialPort.setDataBits( data );
    serialPort.setParity( par );
    serialPort.setStopBits( stop );
    serialPort.setFlowControl( flow  );
    serialPort.setTimeout( 0, 30 );

	var qry:FLSqlQuery = new FLSqlQuery();
	qry.setTablesList("tpv_puntosventa");
	qry.setSelect("iniciarvisor, limpiarvisor, prefprimeralinea, sufprimeralinea, prefsegundalinea, sufsegundalinea");
	qry.setFrom("tpv_puntosventa");
	qry.setWhere("codtpv_puntoventa = '" + codPuntoVenta + "'");
	if (!qry.exec())
		return;
	var iniciar:String = "";
	var limpiar:String = "";
	var prefPrimera:String = "";
	var sufPrimera:String = "";
	var prefSegunda:String = "";
	var sufSegunda:String = "";
	if (qry.first()) {
		var iniciarVisor:String = qry.value("iniciarvisor");
		var arrayIniciarVisor:Array = iniciarVisor.split(",");
		for (var i:Number = 0; i < arrayIniciarVisor.length; i++) {
			iniciar += String.fromCharCode(arrayIniciarVisor[i]);
		}
		var limpiarVisor:String = qry.value("limpiarvisor");
		var arrayLimpiarVisor:Array = limpiarVisor.split(",");
		for (var i:Number = 0; i < arrayLimpiarVisor.length; i++) {
			limpiar += String.fromCharCode(arrayLimpiarVisor[i]);
		}
		var ppl:String = qry.value("prefprimeralinea");
		var arrayPpl:Array = ppl.split(",");
		for (var i:Number = 0; i < arrayPpl.length; i++) {
			prefPrimera += String.fromCharCode(arrayPpl[i]);
		}
		var spl:String = qry.value("sufprimeralinea");
		var arraySpl:Array = spl.split(",");
		for (var i:Number = 0; i < arraySpl.length; i++) {
			sufPrimera += String.fromCharCode(arraySpl[i]);
		}
		var psl:String = qry.value("prefsegundalinea");
		var arraySpl:Array = psl.split(",");
		for (var i:Number = 0; i < arraySpl.length; i++) {
			prefSegunda += String.fromCharCode(arraySpl[i]);
		}
		var ssl:String = qry.value("sufsegundalinea");
		var arraySsl:Array = ssl.split(",");
		for (var i:Number = 0; i < arraySsl.length; i++) {
			sufSegunda += String.fromCharCode(arraySsl[i]);
		}
	}

	var sec:String;
    if ( serialPort.open() ) {
	sec = iniciar;
	sec += limpiar;
	sec += prefPrimera;
	sec += datos[0];
	sec += sufPrimera;
	sec += prefSegunda;
	sec += datos[1];
	sec += sufSegunda;
	serialPort.writeText( sec );
	serialPort.close();
    } 
}

//     debug( "Prueba posdiplay" );
//     var nameSerialPort:String = "/dev/ttyS0";
//     var serialPort:FLSerialPort = new FLSerialPort( nameSerialPort );
//     
//     serialPort.setBaudRate( serialPort.BAUD9600 );
//     serialPort.setDataBits( serialPort.DATA_8 );
//     serialPort.setParity( serialPort.PAR_NONE );
//     serialPort.setStopBits( serialPort.STOP_1 );
//     serialPort.setFlowControl( serialPort.FLOW_HARDWARE );
//     serialPort.setTimeout( 0, 30 );
//     
//     var sec:String;
//     if ( serialPort.open() ) {
// 	sec = String.fromCharCode( 27, 64, 12, 27, 81, 65 );
// 	sec += datos[0];
// 	sec += String.fromCharCode( 13, 27, 81, 66 );
// 	sec += datos[1];
// 	sec += String.fromCharCode( 13 );
// 	serialPort.writeText( sec );
// 	serialPort.close();
//     } else
// 	debug( "Error abriendo puerto serie " + nameSerialPort );

/** \C Posicina el cursor según la parametrización indicada en el formulario de Datos Generales
\end */
function oficial_cursorAPosicionInicial()
{
	var posInicial:String = this.iface.config_["ircursorinicio"];
	switch (posInicial) {
		case "Referencia": {
			this.child("fdbReferencia").setFocus();
			break;
		}
		case "Cod.Barras": {
			this.child("fdbCodBarras").setFocus();
			break;
		}
		case "Cantidad": {
			this.child("txtCanArticulo").setFocus();
			break;
		}
	}
}

/** \C Carga los parámetros de configuración del formulario de datos generales de TPV
\end */
function oficial_cargarConfiguracion()
{
	this.iface.config_ = flfact_tpv.iface.pub_ejecutarQry("tpv_datosgenerales", "rvimprimirtique,rvabrircajon,rvpasarsiguiente,ircursorinicio,irultrarrapida", "1 = 1", "tpv_datosgenerales");
	if (this.iface.config_.result != 1) {
		return;
	}
	
	this.iface.conectarInsercionRapida();

	this.iface.cursorAPosicionInicial();
}

function oficial_conectarInsercionRapida():Boolean
{
	try {
	connect(this.child("fdbReferencia"), "keyReturnPressed()", this, "iface.fdbReferencia_returnPressed");
	connect(this.child("fdbCodBarras"), "keyReturnPressed()", this, "iface.fdbCodBarras_returnPressed");
	} catch (e) {}
	return true;
}
function oficial_fdbCodBarras_returnPressed()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	this.iface.bufferChanged("codbarrasLinea");
	
	if (this.iface.config_["irultrarrapida"]) {
		this.iface.insertarLineaClicked();
	} else {
		this.child("txtDesArticulo").setFocus();
	}
}

function oficial_fdbReferencia_returnPressed()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	if (this.iface.config_["irultrarrapida"]) {
		this.iface.insertarLineaClicked();
	} else {
		this.child("txtDesArticulo").setFocus();
	}
}

function oficial_actualizarIvaLineas(codCliente:String)
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var codImpuesto:String = "";
	var curLinea:FLSqlCursor = new FLSqlCursor("tpv_lineascomanda");
	curLinea.select("idtpv_comanda = " + cursor.valueBuffer("idtpv_comanda"));
	while (curLinea.next()) {
		curLinea.setModeAccess(curLinea.Edit);
		curLinea.refreshBuffer();
		curLinea.setValueBuffer("codimpuesto", this.iface.calcularIvaLinea(curLinea.valueBuffer("referencia")));
		curLinea.setValueBuffer("iva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("iva", curLinea));
		curLinea.commitBuffer();
	}
	this.iface.calcularTotales();
	this.child("tdbLineasComanda").refresh();
}

function oficial_pbnPagar_clicked()
{
	this.iface.realizarPago();

	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var pendiente:Number = parseFloat(cursor.valueBuffer("pendiente"));
	if (!isNaN(pendiente) && pendiente <= 0) {
		if (this.iface.config_["rvimprimirtique"]) {
			this.iface.imprimirQuickClicked();
		}
		if (this.iface.config_["rvabrircajon"]) {
			this.iface.abrirCajonClicked();
		}
		if (this.iface.config_["rvpasarsiguiente"]) {
			var res:Number = MessageBox.information(util.translate("scripts", "Venta realizada.\nPulse aceptar para pasar a la siguiente"), MessageBox.Ok, MessageBox.Cancel);
			if (res != MessageBox.Ok) {
					return;
			}
			///this.acceptContinue(); no la usamos porque en algunas bases de datos cierra el programa
			this.child("pushButtonAcceptContinue").animateClick();
		}
	}
}

function oficial_tbwComanda_currentChanged(tabName:String)
{
	return true;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////