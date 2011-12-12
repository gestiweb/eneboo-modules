/***************************************************************************
                 tpv_comandastactil.qs  -  description
                             -------------------
    begin                : mie ene 20 2010
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var tdbLineasComanda:Object;
	var tableArticulos:Object;
	var tbnAtras:Object;
	var tbnSiguiente:Object;
	var tbnArriba:Object;
	var tlbCantidad:Object;
	var botones:Object;
	var numRows:Number;
	var numCols:Number;
	var nivelOrigen:String;
	var arrayArticulos:Array;
	var paginas:Array;
	var paginaActual:Array;
	var nivelActual:String;
	var curLineas:FLSqlCursor;
	var tlbTotal:Object;
	var tbnDescuento:Object;
	var tbnBorrarLinea:Object;
	var tbnImprimirComanda:Object;
	var tbnMasUnidades:Object;
	var tbnMenosUnidades:Object;
	var tbnSeleccionarTodo:Object;
	var pbnEfectivo:Object;
	var pbnTarjeta:Object;
	var tdbPagos:Object;
	var curPagos:FLSqlCursor;
	var tbnTarifaGeneral:Object;
	var tbnTarifaEspecial:Object;
	var tbnPrecioLibre:Object;
	var precioLibre:Number;
	var impuestoLibre:String;
	var fdbComandas:Object;
	var tbnProductoGenerico:Object;
	var anchoArticulos:Number;
	var altoArticulos:Number;
	var volverNivelBase_:Boolean;
	var secuenciaLinea_:String;
	
	function oficial( context ) { interna( context ); } 
	function modificarCantidad(numero:Number) {
		return this.ctx.oficial_modificarCantidad(numero);
	}
	function tbnOK_clicked() {
		return this.ctx.oficial_tbnOK_clicked();
	}
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function construirArrayArticulos(nivel:String) {
		return this.ctx.oficial_construirArrayArticulos(nivel);
	}
	function mostrarPagina() {
		return this.ctx.oficial_mostrarPagina();
	}
	function formReady() {
		return this.ctx.oficial_formReady();
	}
	function paginaSiguiente() {
		return this.ctx.oficial_paginaSiguiente();
	}
	function paginaAnterior() {
		return this.ctx.oficial_paginaAnterior();
	}
	function clickedTabla(fil:Number,col:Number) {
		return this.ctx.oficial_clickedTabla(fil,col);
	}
	function probarInsercionLinea():Boolean {
		return this.ctx.oficial_probarInsercionLinea();
	}
	function dameIndiceCelda(fil:Number, col:Number):Number {
		return this.ctx.oficial_dameIndiceCelda(fil, col);
	}
	function nivelAnterior() {
		return this.ctx.oficial_nivelAnterior();
	}
	function insertarLinea(referencia:String, cantidad:Number) {
		return this.ctx.oficial_insertarLinea(referencia, cantidad);
	}
	function datosLineaVenta(referencia:String, cantidad:Number,comanda:Number):Boolean {
		return this.ctx.oficial_datosLineaVenta(referencia, cantidad,comanda);
	}
	function commitLineas() {
		return this.ctx.oficial_commitLineas();
	}
	function commitPagos() {
		return this.ctx.oficial_commitPagos();
	}
	function mostrarTotal() {
		return this.ctx.oficial_mostrarTotal();
	}
	function tbnDescuento_clicked() {
		return this.ctx.oficial_tbnDescuento_clicked();
	}
	function pideDtoUsuario():Number {
		return this.ctx.oficial_pideDtoUsuario();
	}
	function aplicarDtoLineas(porDto:Number):Boolean {
		return this.ctx.oficial_aplicarDtoLineas(porDto);
	}
	function borrarLinea() {
		return this.ctx.oficial_borrarLinea();
	}
	function imprimir() {
		return this.ctx.oficial_imprimir();
	}
	function sumarCantidad() {
		return this.ctx.oficial_sumarCantidad();
	}
	function restarCantidad() {
		return this.ctx.oficial_restarCantidad();
	}
	function sumarUno(idLinea:Number):Boolean{
		return this.ctx.oficial_sumarUno(idLinea);
	}
	function restarUno(idLinea:Number):Boolean {
		return this.ctx.oficial_restarUno(idLinea);
	}
	function aplicarDtoLinea(idLinea:Number, porDto:Number):Boolean {
		return this.ctx.oficial_aplicarDtoLinea(idLinea, porDto);
	}
	function pagarEfectivo() {
		return this.ctx.oficial_pagarEfectivo();
	}
	function pagarTarjeta() {
		return this.ctx.oficial_pagarTarjeta();
	}
	function abrirCajonClicked() {
		return this.ctx.oficial_abrirCajonClicked();
	}
	function actualizarTotalesComanda() {
		return this.ctx.oficial_actualizarTotalesComanda();
	}
	function realizarPago(codPago:String):Boolean {
		return this.ctx.oficial_realizarPago(codPago);
	}
	function crearPago(importe:Number,codPago:String):Boolean {
		return this.ctx.oficial_crearPago(importe,codPago);
	}
	function  tarifaGeneral_clicked() {
		return this.ctx.oficial_tarifaGeneral_clicked();
	}
	function tarifaEspecial_clicked() {
		return this.ctx.oficial_tarifaEspecial_clicked();
	}
	function precioLibre_clicked() {
		return this.ctx.oficial_precioLibre_clicked();
	}
	function productoGenerico_clicked() {
		return this.ctx.oficial_productoGenerico_clicked();
	}
	function comandas_clicked() {
		return this.ctx.oficial_comandas_clicked();
	}
	function refrescarLineasComanda() {
		return this.ctx.oficial_refrescarLineasComanda();
	}
	function refrescarLineasPagos() {
		return this.ctx.oficial_refrescarLineasPagos();
	}
	function tbnStock_clicked() {
		return this.ctx.oficial_tbnStock_clicked();
	}
// 	function redimensionarTabla() {
// 		return this.ctx.oficial_redimensionarTabla();
// 	}
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration tpvtactIvainc */
/////////////////////////////////////////////////////////////////
//// TPV_TACTIL + IVA_INCLUIDO ///////////////////////
class tpvtactIvainc extends oficial {
    function tpvtactIvainc( context ) { oficial ( context ); }
    function datosLineaVenta(referencia:String, cantidad:Number,comanda:Number):Boolean {
		return this.ctx.tpvtactIvainc_datosLineaVenta(referencia, cantidad,comanda);
	}
}
//// TPV_TACTIL + IVA_INCLUIDO ///////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends tpvtactIvainc {
    function head( context ) { tpvtactIvainc ( context ); }
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
	var util:FLUtil;
	
	this.iface.volverNivelBase_ = flfact_tpv.iface.pub_valorDefectoTPV("volvernivelbase");
	this.iface.secuenciaLinea_ = flfact_tpv.iface.pub_valorDefectoTPV("secuenciaLinea");

	this.iface.tlbTotal = this.child("tlbTotal");
	this.iface.tdbLineasComanda = this.child("tdbLineasComanda");
	this.iface.tableArticulos = this.child("tableArticulos");
	this.iface.tbnAtras = this.child("tbnAtras");
	this.iface.tbnSiguiente = this.child("tbnSiguiente");
	this.iface.tbnArriba = this.child("tbnArriba");
	this.iface.tlbCantidad = this.child("tlbCantidad");
	this.iface.botones = this.child("botones");
	this.iface.tbnDescuento = this.child("tbnDescuento");
	this.iface.tbnBorrarLinea = this.child("tbnBorrarLinea");
	this.iface.tbnImprimirComanda = this.child("tbnImprimirComanda");
	this.iface.tbnMasUnidades = this.child("tbnMasUnidades");
	this.iface.tbnMenosUnidades = this.child("tbnMenosUnidades");
	this.iface.tbnSeleccionarTodo = this.child("tbnSeleccionarTodo");
	this.iface.pbnEfectivo = this.child("pbnEfectivo");
	this.iface.pbnTarjeta = this.child("pbnTarjeta");
	this.iface.tdbPagos = this.child("tdbPagos");
	this.iface.tbnTarifaGeneral = this.child("tbnTarifaGeneral");
	this.iface.tbnTarifaEspecial = this.child("tbnTarifaEspecial");
	this.iface.tbnPrecioLibre = this.child("tbnPrecioLibre");
	this.iface.fdbComandas = this.child("fdbComandas");
	this.iface.tbnProductoGenerico = this.child("tbnProductoGenerico");
	this.iface.precioLibre = 0;
	this.iface.impuestoLibre = "";
	
	if (!this.iface.curLineas)
		this.iface.curLineas = this.child("tdbLineasComanda").cursor();
	if (!this.iface.curPagos)
		this.iface.curPagos = this.child("tdbPagos").cursor();

	this.iface.numRows = util.sqlSelect("tpv_datosgenerales","nfilas","1=1");
	this.iface.numCols= util.sqlSelect("tpv_datosgenerales","ncolumnas","1=1");
	this.iface.nivelOrigen = util.sqlSelect("tpv_datosgenerales","codnivel","1=1");
	this.iface.paginas = [];
	this.iface.paginaActual = [];
	this.iface.arrayArticulos = [];

	this.iface.tableArticulos.setLeftMargin(0);
	this.iface.tableArticulos.setTopMargin(0);
	
	var sizeTabla = this.child("gbxArticulos").size;
	this.iface.anchoArticulos = sizeTabla.width;
	this.iface.altoArticulos = sizeTabla.height;
	
	var ancho:Number = this.iface.anchoArticulos/this.iface.numCols;
	this.iface.tableArticulos.setNumCols(this.iface.numCols);
	for(var i=0;i<this.iface.numRows;i++) {
		this.iface.tableArticulos.setColumnWidth(i, ancho);
	}
	
	this.iface.refrescarLineasComanda();
	this.iface.refrescarLineasPagos();
	
	connect(this.iface.tableArticulos, "clicked(int,int)", this, "iface.clickedTabla");
	connect(this.iface.tbnAtras,"clicked()",this,"iface.paginaAnterior");
	connect(this.iface.tbnSiguiente,"clicked()",this,"iface.paginaSiguiente");
	connect(this.iface.tbnArriba,"clicked()",this,"iface.nivelAnterior");
	connect(this.iface.botones, "clicked(int)", this, "iface.modificarCantidad");
	connect(this.iface.curLineas, "bufferCommited()", this, "iface.commitLineas");
	connect(this.iface.curPagos, "bufferCommited()", this, "iface.commitPagos");
	connect(this.iface.tbnDescuento,"clicked()",this,"iface.tbnDescuento_clicked");
	connect(this.iface.tbnBorrarLinea,"clicked()",this,"iface.borrarLinea");
	connect(this.iface.tbnImprimirComanda,"clicked()",this,"iface.imprimir");
	connect(this.iface.tbnMasUnidades,"clicked()",this,"iface.sumarCantidad");
	connect(this.iface.tbnMenosUnidades,"clicked()",this,"iface.restarCantidad");
	connect(this.iface.pbnEfectivo,"clicked()",this,"iface.pagarEfectivo");
	connect(this.iface.pbnTarjeta,"clicked()",this,"iface.pagarTarjeta");
	connect(this.child("tbnOpenCash"),"clicked()", this, "iface.abrirCajonClicked()");
	connect(this.iface.tbnTarifaGeneral,"clicked()", this, "iface.tarifaGeneral_clicked()");
	connect(this.iface.tbnTarifaEspecial,"clicked()", this, "iface.tarifaEspecial_clicked()");
	connect(this.iface.tbnPrecioLibre,"clicked()", this, "iface.precioLibre_clicked()");
	connect(this.iface.fdbComandas,"clicked()", this, "iface.comandas_clicked()");
	connect(this.iface.tbnProductoGenerico,"clicked()", this, "iface.productoGenerico_clicked()");
	connect(this.child("tbnRedimensionar"), "clicked()" ,this, "iface.mostrarPagina");
	connect(this.child("tbnStock"), "clicked()", this, "iface.tbnStock_clicked()");
	connect(this.child("tbnOK"), "clicked()", this, "iface.tbnOK_clicked()");
	connect(this, "formReady()", this, "iface.formReady");
	connect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged");
	
	var orden:Array = ["cantidad","descripcion","pvptotal","codimpuesto"];
	 this.child("tdbLineasComanda").setOrderCols(orden);
	
	this.iface.construirArrayArticulos(this.iface.nivelOrigen);

	var cursor:FLSqlCursor = this.cursor();
	switch (cursor.modeAccess()) {
		case cursor.Edit: {("editando");break;}
		case cursor.Browse: {debug("visualizando");break;}
		case cursor.Del: {debug("borrando");break;}
		case cursor.Insert: {debug("insertando");
			var hoy:Date = new Date;
			cursor.setValueBuffer("fecha", hoy.toString());
			cursor.setValueBuffer("hora", hoy.toString().right(8));
			var codTerminal:String = util.readSettingEntry("scripts/fltpv_ppal/codTerminal");
			if (codTerminal && util.sqlSelect("tpv_puntosventa","codtpv_puntoventa","codtpv_puntoventa ='" + codTerminal + "'")) {
				cursor.setValueBuffer("codtpv_puntoventa",codTerminal);
				cursor.setValueBuffer("codalmacen", util.sqlSelect("tpv_puntosventa","codalmacen","codtpv_puntoventa ='" + codTerminal + "'"));
				var agente:String = util.sqlSelect("tpv_puntosventa","codtpv_agente","codtpv_puntoventa ='" + codTerminal + "'");
				if (!agente || agente == "") {
					MessageBox.warning(util.translate("scripts",
					"No hay establecido ningún agente para el punto de venta '" + codTerminal + "'"),MessageBox.Ok,MessageBox.NoButton,MessageBox.NoButton);
					this.form.close();
				}
				cursor.setValueBuffer("codtpv_agente",agente);
			}
			else {
				MessageBox.warning(util.translate("scripts",
				"No hay establecido ningún Punto de Venta Local\no el Punto de Venta establecido no es válido.\nSeleccione un Punto de Venta válido en la tabla \ny pulse el botón Cambiar"),MessageBox.Ok,MessageBox.NoButton,MessageBox.NoButton);
				this.form.close();
				return;
			}
			cursor.setValueBuffer("codtarifa",util.sqlSelect("tpv_datosgenerales","tarifa","1=1"));
			cursor.setValueBuffer("codpago",util.sqlSelect("tpv_datosgenerales","pagoefectivo","1=1"));
			cursor.setValueBuffer("codcliente",util.sqlSelect("tpv_datosgenerales", "codcliente", "1 = 1"));
			break;
		}
	}
	if (this.iface.secuenciaLinea_ == "Cantidad_Referencia") {
		this.iface.modificarCantidad(1);
		this.child("tbnOK").close();
	}
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
		El --total-- es el --neto-- más el --totaliva-- 
		*/
		case "total": {
			var neto:Number = parseFloat(this.iface.calculateField("neto"));
			var totalIva:Number = parseFloat(this.iface.calculateField("totaliva")); 
			valor = neto + totalIva;
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
		case "estado": {
			var total:Number = parseFloat(cursor.valueBuffer("total"));
			if (total != 0 && total == parseFloat(cursor.valueBuffer("pagado"))) {
				valor = "Cerrada";
			} else {
				valor = "Abierta";
			}
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
function oficial_modificarCantidad(numero:Number)
{
	if (numero == 10) {
		this.iface.tlbCantidad.text = 0;
		return;
	}
	
	var cantidad = this.iface.tlbCantidad.text;
	if (!cantidad || cantidad == 0) {
		this.iface.tlbCantidad.text = numero;
	} else {
		this.iface.tlbCantidad.text += numero;
	}
	
// 	if (this.iface.secuenciaLinea_ == "Referencia_Cantidad") {
// 		if (!this.iface.probarInsercionLinea()) {
// 			return false;
// 		}
// 	}
}

function oficial_tbnOK_clicked()
{
	if (!this.iface.probarInsercionLinea()) {
		return false;
	}
}

function oficial_construirArrayArticulos(nivel:String)
{
	this.iface.arrayArticulos[nivel] = [];
	this.iface.paginas[nivel] = 0;
	var i:Number = 0;

	var qry:FLSqlQuery = new FLSqlQuery();
	qry.setTablesList("articulos");
	qry.setSelect("referencia,descripcion,imagen");
	qry.setFrom("articulos");
	qry.setWhere("codnivel = '" + nivel + "' order by referencia");
	if (!qry.exec())
		return;

	if(qry.first()) {
		do {
			this.iface.arrayArticulos[nivel][i] = [];
			this.iface.arrayArticulos[nivel][i]["tipo"] = "articulo";
			this.iface.arrayArticulos[nivel][i]["id"] = qry.value("referencia");
			this.iface.arrayArticulos[nivel][i]["desc"] = qry.value("descripcion");
			this.iface.arrayArticulos[nivel][i]["imagen"] = qry.value("imagen");
			i++;
		}while(qry.next());
	}
	
	qry.setTablesList("nivelestpv");
	qry.setSelect("codnivel,descripcion,imagen");
	qry.setFrom("nivelestpv");
	qry.setWhere("codnivelsup = '" + nivel + "' order by codnivel");
	if (!qry.exec())
		return;

	if(qry.first()) {
		do {
			this.iface.arrayArticulos[nivel][i] = [];
			this.iface.arrayArticulos[nivel][i]["tipo"] = "nivel";
			this.iface.arrayArticulos[nivel][i]["id"] = qry.value("codnivel");
			this.iface.arrayArticulos[nivel][i]["desc"] = qry.value("descripcion");
			this.iface.arrayArticulos[nivel][i]["imagen"] = qry.value("imagen");
			i++;
		}while(qry.next());
	}

	this.iface.nivelActual = nivel;
	this.iface.paginaActual[this.iface.nivelActual] = 0;
	this.iface.paginas[nivel] = 0;
	
	if(i!=0) {
		this.iface.paginas[nivel] = parseFloat(this.iface.arrayArticulos[nivel].length/(this.iface.numRows*this.iface.numCols));
		var aux:Array = this.iface.paginas[nivel].toString().split(".");
		this.iface.paginas[nivel] = aux[0];
		if(aux[1] > 0)
			this.iface.paginas[nivel]++;
	}

	this.iface.mostrarPagina();
}

function oficial_formReady()
{
}

function oficial_mostrarPagina()
{	
	try {
		this.iface.tableArticulos.clear();
	} catch (e) {
		var filas:Number =this.iface.numRows;
		var i:Number = 0;
		while (filas >= 0) {
			i++;
			util.setProgress(i);
			this.iface.tableArticulos.removeRow(filas);
			filas = filas - 1;
		}
	}

	var sizeTabla = this.child("gbxArticulos").size;
	this.iface.anchoArticulos = sizeTabla.width;
	this.iface.altoArticulos = sizeTabla.height;
	
	var indice:Number = 0;
	var alto:Number = this.iface.altoArticulos/this.iface.numRows;
	var ancho:Number = this.iface.anchoArticulos/this.iface.numCols;
	
	var pixSize:Size, pixScaleAlto:Number, pixScaleAncho:Number;
	for(var f=0;f<this.iface.numRows;f++) {
		this.iface.tableArticulos.insertRows(f);
		this.iface.tableArticulos.setRowHeight(f, alto);
		for(var c=0;c<this.iface.numCols;c++) {
			this.iface.tableArticulos.setColumnWidth(c, ancho);
			indice = (this.iface.numRows*this.iface.numCols*this.iface.paginaActual[this.iface.nivelActual]) + (f*this.iface.numCols)+c;
			if(this.iface.arrayArticulos[this.iface.nivelActual].length > indice) {
				var pic = new Picture;
				var pixNew = new Pixmap;
				var clr = new Color;

				clr.setRgb(255,255,255);
				pixNew.resize(ancho, alto );
				pixNew.fill(clr);

				pic.begin();
				pic.drawPixmap(0, 0, pixNew);
				
				var pixOrig = sys.toPixmap(this.iface.arrayArticulos[this.iface.nivelActual][indice]["imagen"]);
				pixSize = pixOrig.size;
				if (pixSize.width && pixSize.height) {
// 				pic.scale(1.5,1.5);
					
					pixScaleAlto = (alto - 25) / pixSize.height;
					debug("pixScaleAlto " + pixScaleAlto + " = alto " + alto + "/ pixSize.height " + pixSize.height);;
					pixScaleAncho = (ancho - 10) / pixSize.width;
pixScaleAlto = 1;
pixScaleAncho = 1;
					if (pixScaleAncho > pixScaleAlto) {
						pixScaleAncho = pixScaleAlto;
					} else {
						pixScaleAlto = pixScaleAncho;
					}
					pic.scale(pixScaleAncho, pixScaleAlto);
debug("5 + ((ancho - 10 - (pixSize.width * pixScaleAncho)) / 2)");
var x:Number = 5 + ((ancho - 10 - (pixSize.width * pixScaleAncho)) / 2);
debug("5 + ((" + ancho + " - 10 - (" + pixSize.width + " * " + pixScaleAncho + ")) / 2) = " + x);
					pic.drawPixmap((5 + ((ancho - 10 - (pixSize.width)) / 2)) / pixScaleAncho, 5, pixOrig);
				}
// 				pic.drawText(5, pixOrig.size.height + 18, this.iface.arrayArticulos[this.iface.nivelActual][indice]["desc"]);
				pixNew = pic.playOnPixmap(pixNew);
				pic.end();
				
				pic.begin();
				pic.drawText(5, alto - 5, this.iface.arrayArticulos[this.iface.nivelActual][indice]["desc"]);
				pixNew = pic.playOnPixmap(pixNew);
				pic.end();

				this.iface.tableArticulos.setPixmap(f, c, pixNew);
// 				this.iface.tableArticulos.setText(f,c,this.iface.arrayArticulos[this.iface.nivelActual][indice]["desc"]);
// 				this.iface.tableArticulos.setPixmap(f,c,sys.toPixmap(this.iface.arrayArticulos[this.iface.nivelActual][indice]["imagen"]));
			}
			else {
				this.iface.tableArticulos.setText(f,c,"");
			}
		}
	}
}

function oficial_paginaSiguiente()
{
	if(this.iface.paginaActual[this.iface.nivelActual] < this.iface.paginas[this.iface.nivelActual]-1) {
		this.iface.paginaActual[this.iface.nivelActual]++;
		this.iface.mostrarPagina();
	}
}

function oficial_paginaAnterior()
{
	if(this.iface.paginaActual[this.iface.nivelActual] > 0) {
		this.iface.paginaActual[this.iface.nivelActual]--;
		this.iface.mostrarPagina();
	}
}

function oficial_dameIndiceCelda(fil:Number, col:Number):Number
{
	if (fil < 0 || fil >= this.iface.numRows) {
		return -1;
	}
	if (col < 0 || col >= this.iface.numCols) {
		return -1;
	}

	var indice:Number = (this.iface.numRows*this.iface.numCols*this.iface.paginaActual[this.iface.nivelActual]) + (fil*this.iface.numCols)+col;
	if (this.iface.arrayArticulos[this.iface.nivelActual].length <= indice) {
		return -1;
	}
	return indice;
}

function oficial_clickedTabla(fil:Number,col:Number)
{
	
	var indice:Number = this.iface.dameIndiceCelda(fil, col);
	if (indice < 0) {
		return false;
	}
	
	var tipo:String = this.iface.arrayArticulos[this.iface.nivelActual][indice]["tipo"];

	switch(tipo) {
		case "nivel": {
			this.iface.construirArrayArticulos(this.iface.arrayArticulos[this.iface.nivelActual][indice]["id"]);
			break;
		}
		case "articulo": {
			if (this.iface.secuenciaLinea_ == "Cantidad_Referencia") {
				if (!this.iface.probarInsercionLinea()) {
					break;
				}
				this.iface.modificarCantidad(1);
			}
			break;
		}
	}
}

/** \D Comprueba si es posible insertar una línea, y si no es, se hace
\end */
function oficial_probarInsercionLinea():Boolean
{
	var cantidad:Number = parseFloat(this.iface.tlbCantidad.text);
	if (!cantidad || cantidad == 0) {
		return false;
	}
	var fil:Number = this.iface.tableArticulos.currentRow();
	var col:Number = this.iface.tableArticulos.currentColumn();
	var indice:Number = this.iface.dameIndiceCelda(fil, col);
	if (indice < 0) {
		return false;
	}
	var referencia:String = this.iface.arrayArticulos[this.iface.nivelActual][indice]["id"];
	if (!referencia || referencia == "") {
		return false;
	}
	this.iface.insertarLinea(referencia, cantidad);
	this.iface.modificarCantidad(10); /// CE
	if (this.iface.volverNivelBase_) {
		this.iface.construirArrayArticulos(this.iface.nivelOrigen);
	}
	return true;
}

function oficial_insertarLinea(referencia:String,cantidad:Number)
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
// 	var curLineas:F
	this.iface.curLineas = this.child("tdbLineasComanda").cursor();
	if (cursor.modeAccess() == cursor.Insert) {
		if (!this.iface.curLineas.commitBufferCursorRelation())
			return;
	}
	var comanda:Number = cursor.valueBuffer("idtpv_comanda");
	
	this.iface.curLineas.setModeAccess(this.iface.curLineas.Insert);
	this.iface.curLineas.refreshBuffer();
	if (!this.iface.datosLineaVenta(referencia, cantidad,comanda))
		return;
	
// 	this.iface.datosVisorArt(this.iface.curLineas);

	if (!this.iface.curLineas.commitBuffer())
		return;

	this.iface.precioLibre = 0;
	this.iface.impuestoLibre = "";
	this.iface.tbnPrecioLibre.on = false;
	this.iface.precioLibre_clicked();
	this.iface.refrescarLineasComanda();
}

function oficial_refrescarLineasComanda()
{
	this.child("tdbLineasComanda").refresh();
	for(var i=0;i<this.child("tdbLineasComanda").cursor().size();i++)
		this.child("tdbLineasComanda").setRowHeight(i,35);
	
}

function oficial_refrescarLineasPagos()
{
	this.child("tdbPagos").refresh();
	for(var i=0;i<this.child("tdbPagos").cursor().size();i++)
		this.child("tdbPagos").setRowHeight(i,35);
	
}
/** |D Establece los datos de la línea de ventas a crear mediante la inserción rápida
\end */
function oficial_datosLineaVenta(referencia:String, cantidad:Number,comanda:Number):Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	this.iface.curLineas.setValueBuffer("idtpv_comanda",comanda);
	this.iface.curLineas.setValueBuffer("cantidad", cantidad);
	this.iface.curLineas.setValueBuffer("referencia", referencia);
	if(referencia && referencia != "")
		this.iface.curLineas.setValueBuffer("descripcion", util.sqlSelect("articulos","descripcion","referencia = '" + referencia + "'"));
	else
		this.iface.curLineas.setValueBuffer("descripcion", "Varios");
	var pvp:Number;
	if(this.iface.precioLibre && this.iface.precioLibre != 0)
		pvp = this.iface.precioLibre;
	else
		pvp = formRecordtpv_lineascomanda.iface.calcularPvpTarifa(referencia, cursor.valueBuffer("codtarifa"));
	
	var codImpuesto:String;
	if(this.iface.impuestoLibre && this.iface.impuestoLibre != "")
		codImpuesto = this.iface.impuestoLibre;
	else
		codImpuesto = formRecordtpv_comandas.iface.calcularIvaLinea(referencia);
	
	this.iface.curLineas.setValueBuffer("pvpunitario", pvp);
	this.iface.curLineas.setValueBuffer("codimpuesto",  codImpuesto);
	this.iface.curLineas.setValueBuffer("iva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("iva", this.iface.curLineas));
	this.iface.curLineas.setValueBuffer("pvpsindto", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpsindto", this.iface.curLineas));
	this.iface.curLineas.setValueBuffer("pvptotal", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotal", this.iface.curLineas));

	return true;
}

function oficial_nivelAnterior()
{
	var util:FLUtil;
	if(this.iface.nivelActual == this.iface.nivelOrigen)
		return;

	var nivelAnt:String = util.sqlSelect("nivelestpv","codnivelsup","codnivel = '" + this.iface.nivelActual + "'");
	if(!nivelAnt || nivelAnt == "")
		return;

	this.iface.nivelActual = nivelAnt;
	this.iface.mostrarPagina();
}

function oficial_commitLineas()
{
	this.iface.mostrarTotal();
}

function oficial_commitPagos()
{
	this.iface.mostrarTotal();
}

function oficial_mostrarTotal()
{
	this.iface.actualizarTotalesComanda();
// 	var util:FLUtil;
// 
// 	var idComanda:Number = this.cursor().valueBuffer("idtpv_comanda");
// 	if(!idComanda)
// 		return false;
// 
// 	var total:Number = parseFloat(util.sqlSelect("tpv_lineascomanda","SUM(pvptotal)","idtpv_comanda = " + idComanda));
// 	if(!total)
// 		total = 0;
// 
// 	total = util.roundFieldValue(total, "tpv_lineascomanda", "pvptotal");
// 	this.iface.tlbTotal.text = total
}

function oficial_tbnDescuento_clicked()
{
	var porDto:Number = this.iface.pideDtoUsuario();
	if (isNaN(porDto) && !porDto) {
		return false;
	}
	if (!this.iface.aplicarDtoLineas(porDto)) {
		return false;
	}
	return true;
}

function oficial_pideDtoUsuario():Number
{
	var util:FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var idUsuario:String = sys.nameUser();
	
	var f:Object = new FLFormSearchDB("tpv_dtocomandatactil");
	var curDescuento:FLSqlCursor = f.cursor();
	
	curDescuento.select("idusuario = '" + idUsuario + "'");
	if (!curDescuento.first()) {
		curDescuento.setModeAccess(curDescuento.Insert);
	} else {
		curDescuento.setModeAccess(curDescuento.Edit);
	}
	
	f.setMainWidget();
	curDescuento.refreshBuffer();
	curDescuento.setValueBuffer("idusuario", idUsuario);
	curDescuento.setValueBuffer("pordto", 0);
	
	var porDto:String = f.exec("pordto");
	return porDto;
}

function oficial_aplicarDtoLineas(porDto:Number):Boolean
{
	var util:FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	if (isNaN(porDto) && !porDto) {
		return false;
	}
	
	var curTrans:FLSqlCursor = new FLSqlCursor("empresa");
	if (this.iface.tbnSeleccionarTodo.on) {
		var qry:FLSqlQuery = new FLSqlQuery();
		qry.setTablesList("tpv_lineascomanda");
		qry.setSelect("idtpv_linea");
		qry.setFrom("tpv_lineascomanda");
		qry.setWhere("idtpv_comanda = '" + cursor.valueBuffer("idtpv_comanda") + "'");
		if (!qry.exec()) {
			return;
		}
		while (qry.next()) {
			curTrans.transaction(false);
			try {
				if (this.iface.aplicarDtoLinea(qry.value("idtpv_linea"), porDto)) {
					curTrans.commit();
				} else {
					curTrans.rollback();
				}
			} catch (e) {
				MessageBox.warning(util.translate("scripts", "Hubo un error al aplicar el descuento:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
				curTrans.rollback();
			}
		}
	} else {
		curTrans.transaction(false);
		try {
			if (this.iface.aplicarDtoLinea(this.child("tdbLineasComanda").cursor().valueBuffer("idtpv_linea"), porDto)) {
				curTrans.commit();
			} else {
				curTrans.rollback();
			}
		} catch (e) {
			MessageBox.warning(util.translate("scripts", "Hubo un error al aplicar el descuento:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
			curTrans.rollback();
		}
	}
	
	this.iface.refrescarLineasComanda();
	this.iface.mostrarTotal();
}

function oficial_borrarLinea()
{
	var util:FLUtil;

	if(this.iface.tbnSeleccionarTodo.on) {
		this.iface.tbnDescuento_clicked();
	}
	else {
		var idLineaComanda:Number = this.child("tdbLineasComanda").cursor().valueBuffer("idtpv_linea");
		if(!idLineaComanda)
			return false;
		
		if(!util.sqlDelete("tpv_lineascomanda","idtpv_linea = " + idLineaComanda))
			return false;
	}
	
	this.iface.refrescarLineasComanda();
	this.iface.mostrarTotal();
}

function oficial_imprimir()
{
	if (!this.cursor().isValid())
		return;
	
	var util:FLUtil = new FLUtil();
	var pv:String = util.readSettingEntry( "scripts/fltpv_ppal/codTerminal" );

	if ( !pv )
			pv = util.sqlSelect( "tpv_puntosventa", "codtpv_puntoventa", "1=1") ;
		
	var impresora:String = util.sqlSelect( "tpv_puntosventa", "impresora","codtpv_puntoventa = '" + pv + "'") ;	
	
	formtpv_comandastactil.iface.pub_imprimirQuick( this.cursor().valueBuffer( "codigo" ) , impresora );
}

function oficial_sumarCantidad()
{
	var util:FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var curTrans:FLSqlCursor = new FLSqlCursor("empresa");
	if(this.iface.tbnSeleccionarTodo.on) {
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
		
	this.iface.refrescarLineasComanda();
	this.iface.mostrarTotal();
}

function oficial_restarCantidad()
{
	var cursor:FLSqlCursor = this.cursor();
	var curTrans:FLSqlCursor = new FLSqlCursor("tpv_lineascomanda");

	if (this.iface.tbnSeleccionarTodo.on){
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
	this.iface.refrescarLineasComanda();
	this.iface.mostrarTotal();
}

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
	curLinea.setValueBuffer("pvpsindto",formRecordtpv_comandas.iface.calcularTotalesLinea("pvpsindto",curLinea));
	curLinea.setValueBuffer("pvptotal",formRecordtpv_comandas.iface.calcularTotalesLinea("pvptotal",curLinea));
	if (!curLinea.commitBuffer())
		return false;

// 	this.iface.calcularTotales();
	return true;
}

function oficial_aplicarDtoLinea(idLinea:Number, porDto:Number):Boolean
{
	if (!idLinea) {
		return false;
	}
	var curLinea:FLSqlCursor = new FLSqlCursor("tpv_lineascomanda");
	curLinea.select("idtpv_linea = " + idLinea);
	curLinea.first();
	curLinea.setModeAccess(curLinea.Edit);
	curLinea.refreshBuffer();
	curLinea.setValueBuffer("dtopor", porDto);
	curLinea.setValueBuffer("pvpsindto", formRecordtpv_comandas.iface.calcularTotalesLinea("pvpsindto", curLinea));
	curLinea.setValueBuffer("pvptotal", formRecordtpv_comandas.iface.calcularTotalesLinea("pvptotal", curLinea));
	if (!curLinea.commitBuffer()) {
		return false;
	}
	return true;
}

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
		curLinea.setValueBuffer("pvpsindto",formRecordtpv_comandas.iface.calcularTotalesLinea("pvpsindto",curLinea));
		curLinea.setValueBuffer("pvptotal",formRecordtpv_comandas.iface.calcularTotalesLinea("pvptotal",curLinea));
	}
	if(!curLinea.commitBuffer())
		return false;
// 	this.iface.calcularTotales();
	return true;
}

function oficial_pagarEfectivo()
{
	var util:FLUtil;
	var pagoEfectivo:String = util.sqlSelect("tpv_datosgenerales", "pagoefectivo", "1=1");
	if(!pagoEfectivo || pagoEfectivo == "") {
		MessageBox.information(util.translate("scripts", "No tiene configurada la forma de pago efectivo en el formulario de datos generales"),MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	
	this.iface.realizarPago(pagoEfectivo);
}

function oficial_pagarTarjeta()
{
	var util:FLUtil;
	var pagoTarjeta:String = util.sqlSelect("tpv_datosgenerales", "pagotarjeta", "1=1");
	if(!pagoTarjeta || pagoTarjeta == "") {
		MessageBox.information(util.translate("scripts", "No tiene configurada la forma de pago tarjeta en el formulario de datos generales"),MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	
	this.iface.realizarPago(pagoTarjeta);
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

function oficial_actualizarTotalesComanda()
{
// 	this.child("fdbNetoComanda").setValue(this.iface.calculateField("neto"));
// 	this.child("fdbTotalIvaComanda").setValue(this.iface.calculateField("totaliva"));
// 	this.child("fdbTotalComanda").setValue(this.iface.calculateField("total"));
	this.cursor().setValueBuffer("neto",this.iface.calculateField("neto"));
	this.cursor().setValueBuffer("totaliva",this.iface.calculateField("totaliva"));
	this.cursor().setValueBuffer("total",this.iface.calculateField("total"));
	this.cursor().setValueBuffer("pagado",this.iface.calculateField("pagado"));
	this.cursor().setValueBuffer("pendiente",this.iface.calculateField("pendiente"));
}

function oficial_realizarPago(codPago:String):Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var impPendiente:Number = parseFloat(cursor.valueBuffer("pendiente"));
	if (!impPendiente)
		return false;
	
	var idUsuario:String = sys.nameUser();
	var f:Object = new FLFormSearchDB("tpv_pagarcomanda");
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

// // 	curCantidadPago.commitBuffer();
	
	var impEntregado:Number = parseFloat(entregado);
	var cambio:Number = 0;
	if (impEntregado == 0)
		return false;
		
	cursor.setValueBuffer("ultentregado", util.roundFieldValue(impEntregado, "tpv_comandas", "total"));
		
	cambio = impEntregado - impPendiente;
	if (cambio > 0) {
		cursor.setValueBuffer("ultcambio", util.roundFieldValue(cambio, "tpv_comandas", "total"));
		if (!this.iface.crearPago(impPendiente,codPago))
			return false;
	} else {
		cursor.setValueBuffer("ultcambio", 0);
		if (!this.iface.crearPago(impEntregado,codPago))
			return false;
	}
// 	this.iface.verificarHabilitaciones();
	return true;
}

/** \D
Crea un pago
@param	importe: Importe del pago
@return	true si el pago se crea correctamente, false en caso contrario
*/
function oficial_crearPago(importe:Number,codPago:String):Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var fecha:Date = new Date;
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
	curPago.setValueBuffer("codpago", codPago);
	
	if (!curPago.commitBuffer()) {
		return false;
	}

	this.iface.refrescarLineasPagos();
	return true;
}

function  oficial_tarifaGeneral_clicked()
{
	var util:FLUtil;
	var codTarifa:String
	if(this.iface.tbnTarifaGeneral.on) {
		codTarifa = util.sqlSelect("tpv_datosgenerales","tarifa","1=1");
		this.iface.tbnTarifaEspecial.on = false;
		this.iface.tbnPrecioLibre.on = false;
	}
	else {
		codTarifa = util.sqlSelect("tpv_datosgenerales","tarifaesp","1=1");
		this.iface.tbnTarifaEspecial.on = true;
	}
	
	if(codTarifa && codTarifa != "")
			this.cursor().setValueBuffer("codtarifa",codTarifa)
}

function oficial_tarifaEspecial_clicked()
{
	var util:FLUtil;
	var codTarifa:String
	if(this.iface.tbnTarifaEspecial.on) {
		codTarifa = util.sqlSelect("tpv_datosgenerales","tarifaesp","1=1");
		this.iface.tbnTarifaGeneral.on = false;
		this.iface.tbnPrecioLibre.on = false;
	}
	else {
		codTarifa = util.sqlSelect("tpv_datosgenerales","tarifa","1=1");
		this.iface.tbnTarifaGeneral.on = true;
	}
	
	if(codTarifa && codTarifa != "")
			this.cursor().setValueBuffer("codtarifa",codTarifa)
}

function oficial_precioLibre_clicked()
{
	var util:FLUtil;
	if(this.iface.tbnPrecioLibre.on) {
		this.iface.tbnTarifaGeneral.on = false;
		this.iface.tbnTarifaEspecial.on = false;
		var idUsuario:String = sys.nameUser();
		var f:Object = new FLFormSearchDB("tpv_pagolibre");
		var curPagoLibre:FLSqlCursor = f.cursor();
		
		curPagoLibre.select("idusuario = '" + idUsuario + "'");
		if (!curPagoLibre.first())
			curPagoLibre.setModeAccess(curPagoLibre.Insert);
		else
			curPagoLibre.setModeAccess(curPagoLibre.Edit);
		
		
		f.setMainWidget();
		curPagoLibre.refreshBuffer();
		curPagoLibre.setValueBuffer("idusuario", idUsuario);
		
		var idPago:Number = f.exec("id");
		if (!idPago)
			return false;

		curPagoLibre.commitBuffer();
		curPagoLibre.select("id = " + idPago);
		if (!curPagoLibre.first())
			return false;
		curPagoLibre.setModeAccess(curPagoLibre.Edit);
		
		this.iface.precioLibre = curPagoLibre.valueBuffer("importe");
		if(!this.iface.precioLibre)
			this.iface.precioLibre = 0;
		this.iface.impuestoLibre = curPagoLibre.valueBuffer("codimpuesto");
		if(!this.iface.impuestoLibre)
			this.iface.impuestoLibre = "";
	}
	else {
		if(this.cursor().valueBuffer("codtarifa") == util.sqlSelect("tpv_datosgenerales","tarifa","1=1"))
			this.iface.tbnTarifaGeneral.on = true;
		if(this.cursor().valueBuffer("codtarifa") == util.sqlSelect("tpv_datosgenerales","tarifaesp","1=1"))
			this.iface.tbnTarifaEspecial.on = true;
	}
}

function oficial_productoGenerico_clicked()
{
	var util:FLUtil;

	var idUsuario:String = sys.nameUser();
	var f:Object = new FLFormSearchDB("tpv_pagolibre");
	var curPagoLibre:FLSqlCursor = f.cursor();
	
	curPagoLibre.select("idusuario = '" + idUsuario + "'");
	if (!curPagoLibre.first())
		curPagoLibre.setModeAccess(curPagoLibre.Insert);
	else
		curPagoLibre.setModeAccess(curPagoLibre.Edit);
	
	
	f.setMainWidget();
	curPagoLibre.refreshBuffer();
	curPagoLibre.setValueBuffer("idusuario", idUsuario);
	
	var idPago:Number = f.exec("id");
	if (!idPago)
		return false;

	curPagoLibre.commitBuffer();
	curPagoLibre.select("id = " + idPago);
	if (!curPagoLibre.first())
		return false;
	curPagoLibre.setModeAccess(curPagoLibre.Edit);
	
	this.iface.precioLibre = curPagoLibre.valueBuffer("importe");
	if(!this.iface.precioLibre)
		this.iface.precioLibre = 0;
	this.iface.impuestoLibre = curPagoLibre.valueBuffer("codimpuesto");
	if(!this.iface.impuestoLibre)
		this.iface.impuestoLibre = "";
	
	this.iface.insertarLinea("",1);
	this.iface.precioLibre = 0;
	this.iface.impuestoLibre = "";	
}

function oficial_comandas_clicked()
{
	var util:FLUtil;
	
	var idUsuario:String = sys.nameUser();
	var f:Object = new FLFormSearchDB("tpv_comandastactil");
	f.setMainWidget();
	
	var idComanda:Number = f.exec("idtpv_comanda");
	if (!idComanda)
		return false;
	
	var cursor:FLSqlCursor = this.cursor();
	cursor.select("idtpv_comanda = " + idComanda);
	if (!cursor.first())
		return false;

	cursor.setModeAccess(cursor.Edit);
	cursor.refreshBuffer();
}

function oficial_bufferChanged(fN:String)
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	switch (fN) {
		/** \C
		Al cambiar el --total-- o el --pagado-- se actualiza el pendiente de pago
		*/
		case "total":
		case "pagado": {
// 			this.child("fdbPendiente").setValue(this.iface.calculateField("pendiente"));
// 			this.iface.refrescarPte();
			cursor.setValueBuffer("estado", this.iface.calculateField("estado"));
			break;
		}
	}
}

function oficial_tbnStock_clicked()
{
	var fil:Number = this.iface.tableArticulos.currentRow();
	var col:Number = this.iface.tableArticulos.currentColumn();
	
	var indice:Number = this.iface.dameIndiceCelda(fil, col);
	if (indice < 0) {
		return false;
	}
	
	var tipo:String = this.iface.arrayArticulos[this.iface.nivelActual][indice]["tipo"];
	var referencia:String = "";
	switch(tipo) {
		case "articulo": {
			referencia = this.iface.arrayArticulos[this.iface.nivelActual][indice]["id"];
			break;
		}
	}
	if (referencia && referencia != "") {
		if (!flfact_tpv.iface.pub_consultarStock(referencia)) {
			return false;
		}
	}
	return true;
}

// function oficial_redimensionarTabla()
// {
// 	var util:FLUtil;
// 	
// 	var sizeTabla = this.child("gbxArticulos").size;
// 	this.iface.anchoArticulos = sizeTabla.width;
// 	this.iface.altoArticulos = sizeTabla.height;
// 
// 	this.iface.mostrarPagina();
// }
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition tpvtactIvainc */
/////////////////////////////////////////////////////////////////
//// TPV_TACTIL + IVA_INCLUIDO ///////////////////////
function tpvtactIvainc_datosLineaVenta(referencia:String, cantidad:Number,comanda:Number)
{
	if(!this.iface.__datosLineaVenta(referencia, cantidad,comanda))
		return false;
	
	var ivaIncluido;
	if (this.iface.precioLibre) {
		ivaIncluido = true;
		this.iface.curLineas.setValueBuffer("ivaincluido", ivaIncluido);
		this.iface.curLineas.setValueBuffer("pvpunitarioiva", this.iface.precioLibre);
		this.iface.curLineas.setValueBuffer("pvpunitario", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpunitario2", this.iface.curLineas));
	} else {
		ivaIncluido= formRecordtpv_lineascomanda.iface.pub_commonCalculateField("ivaincluido", this.iface.curLineas);
		this.iface.curLineas.setValueBuffer("ivaincluido", ivaIncluido);
		if (ivaIncluido) {
			this.iface.curLineas.setValueBuffer("pvpunitarioiva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpunitarioiva", this.iface.curLineas));
			this.iface.curLineas.setValueBuffer("pvpunitario", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpunitario2", this.iface.curLineas));
		} else {
			this.iface.curLineas.setValueBuffer("pvpunitario", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpunitario", this.iface.curLineas));
			this.iface.curLineas.setValueBuffer("pvpunitarioiva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpunitarioiva2", this.iface.curLineas));
		}
	}
	this.iface.curLineas.setValueBuffer("pvpsindto", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpsindto", this.iface.curLineas));
	this.iface.curLineas.setValueBuffer("pvptotal", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotal", this.iface.curLineas));
	
	return true;
}
//// TPV_TACTIL + IVA_INCLUIDO ///////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////