/***************************************************************************
                 masterpedidosprov.qs  -  description
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var pbnGAlbaran:Object;
	var pbnGFactura:Object;
	var tdbRecords:FLTableDB;
	var tbnImprimir:Object;
	var tbnAbrirCerrar:Object;
	var curAlbaran:FLSqlCursor;
	var curLineaAlbaran:FLSqlCursor;

    function oficial( context ) { interna( context ); } 
	function procesarEstado() {
		return this.ctx.oficial_procesarEstado();
	}
	function imprimir(codPedido:String) {
		return this.ctx.oficial_imprimir(codPedido);
	}
	function pbnGenerarAlbaran_clicked() {
		return this.ctx.oficial_pbnGenerarAlbaran_clicked();
	}
	function pbnGenerarFactura_clicked() {
		return this.ctx.oficial_pbnGenerarFactura_clicked();
	}
	function generarAlbaran(where:String, cursor:FLSqlCursor, datosAgrupacion:Array):Number {
		return this.ctx.oficial_generarAlbaran(where, cursor, datosAgrupacion);
	}
	function commonCalculateField(fN:String, cursor:FLSqlCursor):FLSqlCursor {
		return this.ctx.oficial_commonCalculateField(fN, cursor);
	}
	function copiaLineas(idPedido:Number, idAlbaran:Number, codAlmacen:String):Boolean {
		return this.ctx.oficial_copiaLineas(idPedido, idAlbaran, codAlmacen);
	}
	function copiaLineaPedido(curLineaPedido:FLSqlCursor, idAlbaran:Number):Number {
		return this.ctx.oficial_copiaLineaPedido(curLineaPedido, idAlbaran);
	}
	function actualizarDatosPedido(where:String, idAlbaran:String):Boolean {
		return this.ctx.oficial_actualizarDatosPedido(where, idAlbaran);
	}
	function totalesAlbaran():Boolean {
		return this.ctx.oficial_totalesAlbaran();
	}
	function datosAlbaran(curPedido:FLSqlCursor, where:String, datosAgrupacion:Array):Boolean {
		return this.ctx.oficial_datosAlbaran(curPedido, where, datosAgrupacion);
	}
	function datosLineaAlbaran(curLineaPedido:FLSqlCursor):Boolean {
		return this.ctx.oficial_datosLineaAlbaran(curLineaPedido);
	}
	function abrirCerrarPedido() {
		return this.ctx.oficial_abrirCerrarPedido();
	}
	function filtrarTabla():Boolean {
		return this.ctx.oficial_filtrarTabla();
	}
	function filtroTabla():String {
		return this.ctx.oficial_filtroTabla();
	}
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration envioMail */
/////////////////////////////////////////////////////////////////
//// ENVIO_MAIL ////////////////////////////////////////////////
class envioMail extends oficial {
    function envioMail( context ) { oficial ( context ); }
	function init() { 
		return this.ctx.envioMail_init(); 
	}
	function enviarDocumento(codPedido:String, codProveedor:String) {
		return this.ctx.envioMail_enviarDocumento(codPedido, codProveedor);
	}
	function imprimir(codPedido:String) {
		return this.ctx.envioMail_imprimir(codPedido);
	}
}
//// ENVIO_MAIL ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pedidosauto */
/////////////////////////////////////////////////////////////////
//// PEDIDOS_AUTO ///////////////////////////////////////////////
class pedidosauto extends envioMail {
	function pedidosauto( context ) { envioMail ( context ); }
	function recordDelBeforepedidosprov() { return this.ctx.pedidosauto_recordDelBeforepedidosprov() };
}
//// PEDIDOS_AUTO ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration rappel */
/////////////////////////////////////////////////////////////////
//// RAPPEL /////////////////////////////////////////////////////
class rappel extends pedidosauto {
    function rappel( context ) { pedidosauto ( context ); }
	function datosLineaAlbaran(curLineaPedido:FLSqlCursor):Boolean {
		return this.ctx.rappel_datosLineaAlbaran(curLineaPedido);
	}
}
//// RAPPEL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pedProvCli */
/////////////////////////////////////////////////////////////////
//// PED_PROV_CLI ///////////////////////////////////////////////
class pedProvCli extends rappel {	
	var pedidosSel_:Array;
	var lineasPedCli:Array;
	var mensajeFinal:String;
	var curPedidoProvCli_:FLSqlCursor;
    function pedProvCli( context ) { rappel ( context ); }
	function init() {
		return this.ctx.pedProvCli_init();
	}
	function tbnPedidosCli_clicked() {
		return this.ctx.pedProvCli_tbnPedidosCli_clicked();
	}
	function filtroPedidosCli():String {
		return this.ctx.pedProvCli_filtroPedidosCli();
	}
	function buscarProveedorArray(codProveedor:String):Number {
		return this.ctx.pedProvCli_buscarProveedorArray(codProveedor);
	}
	function crearArray(listaPedidos:String):Boolean {
		return this.ctx.pedProvCli_crearArray(listaPedidos);
	}
	function crearPedidos():Boolean {
		return this.ctx.pedProvCli_crearPedidos();
	}
	function buscarPedidosAbiertos(arrayPedCli:Array):Array {
		return this.ctx.pedProvCli_buscarPedidosAbiertos(arrayPedCli);
	}
	function crearPedidoProvCli(indice:Number,idPedido:Number):String {
		return this.ctx.pedProvCli_crearPedidoProvCli(indice,idPedido);
	}
	function copiarLineasPedidoProvCli(idPedidoCli:String,idPedidoProv:String,indice:Number):Boolean {
		return this.ctx.pedProvCli_copiarLineasPedidoProvCli(idPedidoCli,idPedidoProv,indice);
	}
	function datosLineaPedidoProvCli(curLineasCli:FLSqlCursor,curLineasProv:FLSqlCursor,idPedido:Number):String {
		return this.ctx.pedProvCli_datosLineaPedidoProvCli(curLineasCli, curLineasProv, idPedido);
	}
	function calcularTotalesPedidoProvCli():Boolean {
		return this.ctx.pedProvCli_calcularTotalesPedidoProvCli();
	}
	function asociarPedidoProvCli(idPedidoCli:Number,idPedidoProv:Number):Boolean {
		return this.ctx.pedProvCli_asociarPedidoProvCli(idPedidoCli,idPedidoProv);
	}
	function copiaLineasPedidoProvCli(idPedidoCli:String, idPedidoProv:String):Boolean {
		return this.ctx.pedProvCli_copiaLineasPedidoProvCli(idPedidoCli, idPedidoProv);
	}
	function datosPedidoProvCli(indice:Number):Boolean {
		return this.ctx.pedProvCli_datosPedidoProvCli(indice);
	}
	function imprimir(codPedido:String) {
		return this.ctx.pedProvCli_imprimir(codPedido);
	}
}
//// PED_PROV_CLI ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration dtoEspecial */
/////////////////////////////////////////////////////////////////
//// DTO ESPECIAL ///////////////////////////////////////////////
class dtoEspecial extends pedProvCli {
    function dtoEspecial( context ) { pedProvCli ( context ); }
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.dtoEspecial_commonCalculateField(fN, cursor);
	}
	function totalesAlbaran():Boolean {
		return this.ctx.dtoEspecial_totalesAlbaran();
	}
	function datosAlbaran(curPedido:FLSqlCursor, where:String, datosAgrupacion:Array):Boolean {
		return this.ctx.dtoEspecial_datosAlbaran(curPedido, where, datosAgrupacion);
	}
	function buscarPorDtoEsp(where:String):Number {
		return this.ctx.dtoEspecial_buscarPorDtoEsp(where);
	}
}
//// DTO ESPECIAL ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends dtoEspecial {
    function head( context ) { dtoEspecial ( context ); }
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubEnvioMail */
/////////////////////////////////////////////////////////////////
//// PUB_ENVIO_MAIL /////////////////////////////////////////////
class pubEnvioMail extends head {
    function pubEnvioMail( context ) { head( context ); }
	function pub_enviarDocumento(codPedido:String, codProveedor:String) {
		return this.enviarDocumento(codPedido, codProveedor);
	}
}

//// PUB_ENVIO_MAIL /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration ifaceCtx */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends pubEnvioMail {
    function ifaceCtx( context ) { pubEnvioMail( context ); }
	function pub_commonCalculateField(fN:String, cursor:FLSqlCursor):FLSqlCursor {
		return this.commonCalculateField(fN, cursor);
	}
	function pub_generarAlbaran(where:String, cursor:FLSqlCursor, datosAgrupacion:Array):Number {
		return this.generarAlbaran(where, cursor, datosAgrupacion);
	}
	function pub_imprimir(codPedido:String) {
		return this.imprimir(codPedido);
	}
}

const iface = new pubPedProvCli( this );
//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubPedProvCli */
/////////////////////////////////////////////////////////////////
//// PUB_PEDPROVCLI  ////////////////////////////////////////////
class pubPedProvCli extends ifaceCtx {
    function pubPedProvCli( context ) { ifaceCtx( context ); }
	function pub_commonCalculateField(fN:String, cursor:FLSqlCursor):FLSqlCursor {
		return this.commonCalculateField(fN, cursor);
	}
	function pub_generarAlbaran(where:String, cursor:FLSqlCursor, datosAgrupacion:Array):Number {
		return this.generarAlbaran(where, cursor, datosAgrupacion);
	}
	function pub_imprimir(codPedido:String) {
		return this.imprimir(codPedido);
	}
	function pub_copiarLineasPedidoProvCli(idPedidoCli:String,idPedidoProv:String,indice:Number):Boolean {
		return this.copiarLineasPedidoProvCli(idPedidoCli,idPedidoProv,indice);
	}
	function pub_asociarPedidoProvCli(idPedidoCli:Number,idPedidoProv:Number):Boolean {
		return this.asociarPedidoProvCli(idPedidoCli,idPedidoProv);
	}
}
//// PUB_PEDPROVCLI  ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition interna */
////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
/** \C
Este es el formulario maestro de pedidos a proveedor.
\end */
function interna_init()
{
	this.iface.pbnGAlbaran = this.child("pbnGenerarAlbaran");
	this.iface.pbnGFactura = this.child("pbnGenerarFactura");
	this.iface.tdbRecords = this.child("tableDBRecords");
	this.iface.tbnImprimir = this.child("toolButtonPrint");
	this.iface.tbnAbrirCerrar = this.child("tbnAbrirCerrar");

	connect(this.iface.pbnGAlbaran, "clicked()", this, "iface.pbnGenerarAlbaran_clicked()");
	connect(this.iface.pbnGFactura, "clicked()", this, "iface.pbnGenerarFactura_clicked()");
	connect(this.iface.tdbRecords, "currentChanged()", this, "iface.procesarEstado()");
	connect(this.iface.tbnImprimir, "clicked()", this, "iface.imprimir");
	connect(this.iface.tbnAbrirCerrar, "clicked()", this, "iface.abrirCerrarPedido()");

	this.iface.filtrarTabla();
	this.iface.procesarEstado();
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \C
Al pulsar el botón imprimir se lanzará el informe correspondiente al pedido seleccionado (en caso de que el módulo de informes esté cargado)
\end */
function oficial_imprimir(codPedido:String)
{
	if (sys.isLoadedModule("flfactinfo")) {
		var codigo:String;
		if (codPedido) {
			codigo = codPedido;
		} else {
			if (!this.cursor().isValid())
				return;
			codigo = this.cursor().valueBuffer("codigo");
		}
		var curImprimir:FLSqlCursor = new FLSqlCursor("i_pedidosprov");
		curImprimir.setModeAccess(curImprimir.Insert);
		curImprimir.refreshBuffer();
		curImprimir.setValueBuffer("descripcion", "temp");
		curImprimir.setValueBuffer("d_pedidosprov_codigo", codigo);
		curImprimir.setValueBuffer("h_pedidosprov_codigo", codigo);
		flfactinfo.iface.pub_lanzarInforme(curImprimir, "i_pedidosprov");
	} else
		flfactppal.iface.pub_msgNoDisponible("Informes");
}

function oficial_procesarEstado()
{
		if (this.cursor().valueBuffer("editable") == true) {
				this.iface.pbnGAlbaran.setEnabled(true);
				this.iface.pbnGFactura.setEnabled(true);
		} else {
				this.iface.pbnGAlbaran.setEnabled(false);
				this.iface.pbnGFactura.setEnabled(false);
		}
}

/** \C
Al pulsar el botón de generar albarán se creará el albarán correspondiente al pedido seleccionado.
\end */
function oficial_pbnGenerarAlbaran_clicked()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var where:String = "idpedido = " + cursor.valueBuffer("idpedido");

	if (cursor.valueBuffer("editable") == false) {
		MessageBox.warning(util.translate("scripts", "El pedido ya está servido"), MessageBox.Ok, MessageBox.NoButton);
		this.iface.procesarEstado();
		return;
	}
	this.iface.pbnGAlbaran.setEnabled(false);
	this.iface.pbnGFactura.setEnabled(false);

	cursor.transaction(false);
	try {
		if (this.iface.generarAlbaran(where, cursor))
			cursor.commit();
		else
			cursor.rollback();
	}
	catch (e) {
		cursor.rollback();
		MessageBox.critical(util.translate("scripts", "Hubo un error en la generación del albarán:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
	}
	
	this.iface.tdbRecords.refresh();
	this.iface.procesarEstado();
}

/** \C
Al pulsar el botón de generar factura se crearán tanto el albarán como la factura correspondientes al pedido seleccionado.
\end */
function oficial_pbnGenerarFactura_clicked()
{
	var idAlbaran:Number;
	var idFactura:Number;
	var util:FLUtil = new FLUtil;
	var curAlbaran:FLSqlCursor = new FLSqlCursor("albaranesprov");
	var cursor:FLSqlCursor = this.cursor();
	var where:String = "idpedido = " + cursor.valueBuffer("idpedido");

	if (cursor.valueBuffer("editable") == false) {
		MessageBox.warning(util.translate("scripts", "El pedido ya está servido. Genere la factura desde la ventana de albaranes"), MessageBox.Ok, MessageBox.NoButton);
		this.iface.procesarEstado();
		return;
	}
	this.iface.pbnGAlbaran.setEnabled(false);
	this.iface.pbnGFactura.setEnabled(false);

	cursor.transaction(false);
	try {
		idAlbaran = this.iface.generarAlbaran(where, cursor);
		if (idAlbaran) {
			where = "idalbaran = " + idAlbaran;
			curAlbaran.select(where);
			if (curAlbaran.first()) {
				cursor.commit();
				cursor.transaction(false);
				idFactura = formalbaranesprov.iface.pub_generarFactura(where, curAlbaran);
				if (idFactura) {
					cursor.commit();
				} else
					cursor.rollback();
			} else
				cursor.rollback();
		} else
			cursor.rollback();
    }
	catch (e) {
		cursor.rollback();
		MessageBox.critical(util.translate("scripts", "Hubo un error en la generación de la factura:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
	}
	
	this.iface.tdbRecords.refresh();
	this.iface.procesarEstado();
}

/** \D 
Genera el albarán asociado a uno o más pedidos
@param where: Sentencia where para la consulta de búsqueda de los pedidos a agrupar
@param cursor: Cursor con los datos principales que se copiarán del pedido al albarán
@param datosAgrupacion: Array con los datos indicados en el formulario de agrupación de pedidos
@return Identificador del albarán generado. FALSE si hay error
\end */
function oficial_generarAlbaran(where:String, curPedido:FLSqlCursor, datosAgrupacion:Array):Number
{
	if (!this.iface.curAlbaran)
		this.iface.curAlbaran = new FLSqlCursor("albaranesprov");
	
	this.iface.curAlbaran.setModeAccess(this.iface.curAlbaran.Insert);
	this.iface.curAlbaran.refreshBuffer();
	
	if (!this.iface.datosAlbaran(curPedido, where, datosAgrupacion))
		return false;
	
	if (!this.iface.curAlbaran.commitBuffer()) {
		return false;
	}
	
	var idAlbaran:Number = this.iface.curAlbaran.valueBuffer("idalbaran");
	
	var qryPedidos:FLSqlQuery = new FLSqlQuery();
	qryPedidos.setTablesList("pedidosprov");
	qryPedidos.setSelect("idpedido");
	qryPedidos.setFrom("pedidosprov");
	qryPedidos.setWhere(where);

	if (!qryPedidos.exec())
		return false;

	var idPedido:String;
	while (qryPedidos.next()) {
		idPedido = qryPedidos.value(0);
		if (!this.iface.copiaLineas(idPedido, idAlbaran))
			return false;
	}

	this.iface.curAlbaran.select("idalbaran = " + idAlbaran);
	if (this.iface.curAlbaran.first()) {
		this.iface.curAlbaran.setModeAccess(this.iface.curAlbaran.Edit);
		this.iface.curAlbaran.refreshBuffer();
		
		if (!this.iface.totalesAlbaran())
			return false;
		
		if (this.iface.curAlbaran.commitBuffer() == false)
			return false;
	}
	return idAlbaran;
}

/** \D Informa los datos de un albarán a partir de los de uno o varios pedidos
@param	curPedido: Cursor que contiene los datos a incluir en el albarán
@param where: Sentencia where para la consulta de búsqueda de los pedidos a agrupar
@param datosAgrupacion: Array con los datos indicados en el formulario de agrupación de pedidos
@return	True si el cálculo se realiza correctamente, false en caso contrario
\end */
function oficial_datosAlbaran(curPedido:FLSqlCursor, where:String, datosAgrupacion:Array):Boolean
{
	var fecha:String;
	var hora:String;
	if (datosAgrupacion) {
		fecha = datosAgrupacion["fecha"];
		hora = datosAgrupacion["hora"];
	} else {
		var hoy:Date = new Date();
		fecha = hoy.toString();
		hora = hoy.toString().right(8);
	}
	
	var codEjercicio:String = curPedido.valueBuffer("codejercicio");
	var datosDoc:Array = flfacturac.iface.pub_datosDocFacturacion(fecha, codEjercicio, "albaranesprov");
	if (!datosDoc.ok)
		return false;
	if (datosDoc.modificaciones == true) {
		codEjercicio = datosDoc.codEjercicio;
		fecha = datosDoc.fecha;
	}

	with (this.iface.curAlbaran) {
		setValueBuffer("codproveedor", curPedido.valueBuffer("codproveedor"));
		setValueBuffer("nombre", curPedido.valueBuffer("nombre"));
		setValueBuffer("cifnif", curPedido.valueBuffer("cifnif"));
		setValueBuffer("coddivisa", curPedido.valueBuffer("coddivisa"));
		setValueBuffer("tasaconv", curPedido.valueBuffer("tasaconv"));
		setValueBuffer("recfinanciero", curPedido.valueBuffer("recfinanciero"));
		setValueBuffer("codpago", curPedido.valueBuffer("codpago"));
		setValueBuffer("codalmacen", curPedido.valueBuffer("codalmacen"));
		setValueBuffer("fecha", fecha);
		setValueBuffer("hora", hora);
		setValueBuffer("codserie", curPedido.valueBuffer("codserie"));
		setValueBuffer("codejercicio", codEjercicio);
		setValueBuffer("tasaconv", curPedido.valueBuffer("tasaconv"));
		setValueBuffer("recfinanciero", curPedido.valueBuffer("recfinanciero"));
		setValueBuffer("irpf", curPedido.valueBuffer("irpf"));
		setValueBuffer("observaciones", curPedido.valueBuffer("observaciones"));
	}
	
	return true;
}

/** \D Informa los datos de un albarán referentes a totales (I.V.A., neto, etc.)
@return	True si el cálculo se realiza correctamente, false en caso contrario
\end */
function oficial_totalesAlbaran():Boolean
{
	with (this.iface.curAlbaran) {
		setValueBuffer("neto", formalbaranesprov.iface.pub_commonCalculateField("neto", this));
		setValueBuffer("totaliva", formalbaranesprov.iface.pub_commonCalculateField("totaliva", this));
		setValueBuffer("totalirpf", formalbaranesprov.iface.pub_commonCalculateField("totalirpf", this));
		setValueBuffer("totalrecargo", formalbaranesprov.iface.pub_commonCalculateField("totalrecargo", this));
		setValueBuffer("total", formalbaranesprov.iface.pub_commonCalculateField("total", this));
		setValueBuffer("totaleuros", formalbaranesprov.iface.pub_commonCalculateField("totaleuros", this));
	}
	return true;
}


function oficial_actualizarDatosPedido(where:String, idAlbaran:String):Boolean
{
	var curPedidos:FLSqlCursor = new FLSqlCursor("pedidosprov");
	curPedidos.select(where);
	while (curPedidos.next()) {
		curPedidos.setModeAccess(curPedidos.Edit);
		curPedidos.refreshBuffer();
		curPedidos.setValueBuffer("servido", "Sí");
		curPedidos.setValueBuffer("editable", false);
		if(!curPedidos.commitBuffer()) 
			return false;
	}
	return true;
}

function oficial_commonCalculateField(fN:String, cursor:FLSqlCursor):FLSqlCursor
{
	var util:FLUtil = new FLUtil();
	var valor:String;

	/** \C
	El --código-- se construye como la concatenación de --codserie--, --codejercicio-- y --numero--
	\end */
	if (fN == "codigo") {
		valor = flfacturac.iface.pub_construirCodigo(cursor.valueBuffer("codserie"), cursor.valueBuffer("codejercicio"), cursor.valueBuffer("numero"));
	}

	switch (fN) {
		/** \C
		El --total-- es el --neto-- menos el --totalirpf-- más el --totaliva-- más el --totalrecargo-- más el --recfinanciero--
		\end */
		case "total": {
			var neto:Number = parseFloat(cursor.valueBuffer("neto"));
			var totalIrpf = parseFloat(cursor.valueBuffer("totalirpf"));
			var totalIva:Number = parseFloat(cursor.valueBuffer("totaliva"));
			var totalRecargo:Number = parseFloat(cursor.valueBuffer("totalrecargo"));
			var recFinanciero:Number = (parseFloat(cursor.valueBuffer("recfinanciero")) * neto) / 100;
			recFinanciero = parseFloat(util.roundFieldValue(recFinanciero, "pedidosprov", "total"));
			valor = neto - totalIrpf + totalIva + totalRecargo + recFinanciero;
			valor = parseFloat(util.roundFieldValue(valor, "pedidosprov", "total"));
			break;
		}
		/** \C
		El --totaleuros-- es el producto del --total-- por la --tasaconv--
		\end */
		case "totaleuros":{
			var total:Number = parseFloat(cursor.valueBuffer("total"));
			var tasaConv:Number = parseFloat(cursor.valueBuffer("tasaconv"));
			valor = total * tasaConv;
			valor = parseFloat(util.roundFieldValue(valor, "pedidosprov", "totaleuros"));
			break;
		}
		/** \C
		El --neto-- es la suma del pvp total de las líneas de albarán
		\end */
		case "neto": {
			valor = util.sqlSelect("lineaspedidosprov", "SUM(pvptotal)", "idpedido = " + cursor.valueBuffer("idpedido"));
			valor = parseFloat(util.roundFieldValue(valor, "pedidosprov", "neto"));
			break;
		}
		/** \C
		El --totaliva-- es la suma del iva correspondiente a las líneas de albarán
		\end */
		case "totaliva": {
			if (formfacturasprov.iface.pub_sinIVA(cursor)) {
				valor = 0;
			} else {
				valor = util.sqlSelect("lineaspedidosprov", "SUM((pvptotal * iva) / 100)", "idpedido = " + cursor.valueBuffer("idpedido"));
			}
			valor = parseFloat(util.roundFieldValue(valor, "pedidosprov", "totaliva"));
			break;
		}
		/** \C
		El --totarecargo-- es la suma del recargo correspondiente a las líneas de albarán
		\end */
		case "totalrecargo": {
			if (formfacturasprov.iface.pub_sinIVA(cursor)) {
				valor = 0;
			} else {
				valor = util.sqlSelect("lineaspedidosprov", "SUM((pvptotal * recargo) / 100)", "idpedido = " + cursor.valueBuffer("idpedido"));
			}
			valor = parseFloat(util.roundFieldValue(valor, "pedidosprov", "totalrecargo"));
			break;
		}
		/** \C
		El --irpf-- es el asociado al --codserie-- del albarán
		\end */
		case "irpf": {
			valor = util.sqlSelect("series", "irpf", "codserie = '" + cursor.valueBuffer("codserie") + "'");
			break;
		}
		/** \C
		El --totalirpf-- es el producto del --irpf-- por el --neto--
		\end */
		case "totalirpf": {
			valor = util.sqlSelect("lineaspedidosprov", "SUM((pvptotal * irpf) / 100)", "idpedido = " + cursor.valueBuffer("idpedido"));
			valor = parseFloat(util.roundFieldValue(valor, "pedidosprov", "totalirpf"));
			break;
		}
	}
	return valor;
}

/** \D
Copia las líneas de un pedido como líneas de su albarán asociado
@param idPedido: Identificador del pedido
@param idAlbaran: Identificador del albarán
@return VERDADERO si la copia se realiza correctamente. FALSO en otro caso
\end */
function oficial_copiaLineas(idPedido:Number, idAlbaran:Number):Boolean
{
	var cantidad:Number;
	var totalEnAlbaran:Number;
	var curLineaPedido:FLSqlCursor = new FLSqlCursor("lineaspedidosprov");
	curLineaPedido.select("idpedido = " + idPedido + " AND (cerrada = false or cerrada IS NULL)");
	while (curLineaPedido.next()) {
		curLineaPedido.setModeAccess(curLineaPedido.Browse);
		curLineaPedido.refreshBuffer();
		cantidad = parseFloat(curLineaPedido.valueBuffer("cantidad"));
		totalEnAlbaran = parseFloat(curLineaPedido.valueBuffer("totalenalbaran"));
		if (cantidad != totalEnAlbaran) { /// > cambiado por != para poder albaranar líneas con cantidad negativa
			if (!this.iface.copiaLineaPedido(curLineaPedido, idAlbaran)) {
				return false;
			}
		}
	}
	return true;
}

/** \D
Copia una líneas de un pedido en su albarán asociado
@param curdPedido: Cursor posicionado en la línea de pedido a copiar
@param idAlbaran: Identificador del albarán
@return identificador de la línea de albarán creada si no hay error. FALSE en otro caso.
\end */
function oficial_copiaLineaPedido(curLineaPedido:FLSqlCursor, idAlbaran:Number):Number
{
	if (!this.iface.curLineaAlbaran)
		this.iface.curLineaAlbaran = new FLSqlCursor("lineasalbaranesprov");
	
	with (this.iface.curLineaAlbaran) {
		setModeAccess(Insert);
		refreshBuffer();
		setValueBuffer("idalbaran", idAlbaran);
	}
	
	if (!this.iface.datosLineaAlbaran(curLineaPedido))
		return false;
		
	if (!this.iface.curLineaAlbaran.commitBuffer())
		return false;
	
	return this.iface.curLineaAlbaran.valueBuffer("idlinea");
}

/** \D Copia los datos de una línea de pedido en una línea de albarán
@param	curLineaPedido: Cursor que contiene los datos a incluir en la línea de albarán
@return	True si la copia se realiza correctamente, false en caso contrario
\end */
function oficial_datosLineaAlbaran(curLineaPedido:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	var cantidad:Number = parseFloat(curLineaPedido.valueBuffer("cantidad")) - parseFloat(curLineaPedido.valueBuffer("totalenalbaran"));
	var pvpSinDto:Number = parseFloat(curLineaPedido.valueBuffer("pvpsindto")) * cantidad / parseFloat(curLineaPedido.valueBuffer("cantidad"));
	pvpSinDto = util.roundFieldValue(pvpSinDto, "lineasalbaranesprov", "pvpsindto");
	var iva:Number, recargo:Number;
	var codImpuesto:String = curLineaPedido.valueBuffer("codimpuesto");
	
	with (this.iface.curLineaAlbaran) {
		setValueBuffer("idlineapedido", curLineaPedido.valueBuffer("idlinea"));
		setValueBuffer("idpedido", curLineaPedido.valueBuffer("idpedido"));
		setValueBuffer("referencia", curLineaPedido.valueBuffer("referencia"));
		setValueBuffer("descripcion", curLineaPedido.valueBuffer("descripcion"));
		setValueBuffer("pvpunitario", curLineaPedido.valueBuffer("pvpunitario"));
		setValueBuffer("cantidad", cantidad);
		setValueBuffer("codimpuesto", codImpuesto);
		if (curLineaPedido.isNull("iva")) {
			setNull("iva");
		} else {
			iva = curLineaPedido.valueBuffer("iva");
			if (iva != 0 && codImpuesto && codImpuesto != "") {
				iva = formRecordlineaspedidosprov.iface.pub_commonCalculateField("iva", this); /// Para cambio de IVA según fechas
			}
			setValueBuffer("iva", iva);
		}
		if (curLineaPedido.isNull("recargo")) {
			setNull("recargo");
		} else {
			recargo = curLineaPedido.valueBuffer("recargo");
			if (recargo != 0 && codImpuesto && codImpuesto != "") {
				recargo = formRecordlineaspedidosprov.iface.pub_commonCalculateField("recargo", this); /// Para cambio de IVA según fechas
			}
			setValueBuffer("recargo", recargo);
		}
		setValueBuffer("irpf", curLineaPedido.valueBuffer("irpf"));
		setValueBuffer("dtolineal", curLineaPedido.valueBuffer("dtolineal"));
		setValueBuffer("dtopor", curLineaPedido.valueBuffer("dtopor"));
		setValueBuffer("pvpsindto", pvpSinDto);
		setValueBuffer("pvptotal", formRecordlineaspedidosprov.iface.pub_commonCalculateField("pvptotal", this));
	}
	return true;
}

function oficial_abrirCerrarPedido()
{
	var util:FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var idPedido:Number = cursor.valueBuffer("idpedido");
	if(!idPedido) {
		MessageBox.warning(util.translate("scripts", "No hay ningún registro seleccionado"), MessageBox.Ok, MessageBox.NoButton);
	}

	var cerrar:Boolean = true;
	var res:Number;
	if(util.sqlSelect("lineaspedidosprov","cerrada","idpedido = " + idPedido + " AND cerrada")) {
		cerrar = false;
		res = MessageBox.information(util.translate("scripts", "El pedido seleccionado tiene líneas cerradas.\n¿Seguro que desa abrirlas?"), MessageBox.Yes, MessageBox.No);
	}
	else {
		if(!cursor.valueBuffer("editable")) {
			MessageBox.warning(util.translate("scripts", "El pedido ya ha sido servido completamente."), MessageBox.Ok, MessageBox.NoButton);
			return;
		}
		res = MessageBox.information(util.translate("scripts", "Se va a cerrar el pedido y no podrá terminar de servirse.\n¿Desea continuar?"), MessageBox.Yes, MessageBox.No);
	}
	if(res != MessageBox.Yes)
		return;

	if(!util.sqlUpdate("lineaspedidosprov","cerrada",cerrar,"idpedido = " + idPedido))
		return;

	if (!flfacturac.iface.pub_actualizarEstadoPedidoProv(idPedido))
		return;

	this.iface.tdbRecords.refresh();
}

function oficial_filtrarTabla():Boolean
{
	var filtro:String = this.iface.filtroTabla();
	this.cursor().setMainFilter(filtro);
	return true;
}

function oficial_filtroTabla():String
{
	var filtro:String = "";
	var codEjercicio:String = flfactppal.iface.pub_ejercicioActual();
	if (codEjercicio) {
		filtro = "codejercicio='" + codEjercicio + "'";
	}
	return filtro;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition envioMail */
/////////////////////////////////////////////////////////////////
//// ENVIO_MAIL /////////////////////////////////////////////////
function envioMail_init()
{
	this.iface.__init();
	//this.child("tbnEnviarMail").close();
	connect(this.child("tbnEnviarMail"), "clicked()", this, "iface.enviarDocumento()");
}

function envioMail_enviarDocumento(codPedido:String, codProveedor:String)
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	if (!codPedido) {
		codPedido = cursor.valueBuffer("codigo");
	}

	if (!codProveedor) {
		codProveedor = cursor.valueBuffer("codproveedor");
	}

	var tabla:String = "proveedores";
	var emailProveedor:String = flfactppal.iface.pub_componerListaDestinatarios(codProveedor, tabla);
	if (!emailProveedor) {	
		return;
	}

	var rutaIntermedia:String = util.readSettingEntry("scripts/flfactinfo/dirCorreo");
	if (!rutaIntermedia.endsWith("/")) {
		rutaIntermedia += "/";
	}

	var cuerpo:String = "";
	var asunto:String = util.translate("scripts", "Pedido %1").arg(codPedido);
	var rutaDocumento:String = rutaIntermedia + "P_" + codPedido + ".pdf";

	var codigo:String;
	if (codPedido) {
		codigo = codPedido;
	} else {
		if (!cursor.isValid()) {
			return;
		}
		codigo = cursor.valueBuffer("codigo");
	}
	
	var curImprimir:FLSqlCursor = new FLSqlCursor("i_pedidosprov");
	curImprimir.setModeAccess(curImprimir.Insert);
	curImprimir.refreshBuffer();
	curImprimir.setValueBuffer("descripcion", "temp");
	curImprimir.setValueBuffer("d_pedidosprov_codigo", codigo);
	curImprimir.setValueBuffer("h_pedidosprov_codigo", codigo);
	flfactinfo.iface.pub_lanzarInforme(curImprimir, "i_pedidosprov", "", "", false, false, "", "i_pedidosprov", 1, rutaDocumento, true);

	var arrayDest:Array = [];
	arrayDest[0] = [];
	arrayDest[0]["tipo"] = "to";
	arrayDest[0]["direccion"] = emailProveedor;

	var arrayAttach:Array = [];
	arrayAttach[0] = rutaDocumento;

	flfactppal.iface.pub_enviarCorreo(cuerpo, asunto, arrayDest, arrayAttach);
}

function envioMail_imprimir(codPedido:String)
{
	var util:FLUtil = new FLUtil;
	
	var datosEMail:Array = [];
	datosEMail["tipoInforme"] = "pedidosprov";
	var codCliente:String;
	if (codPedido && codPedido != "") {
		datosEMail["codDestino"] = util.sqlSelect("pedidosprov", "codproveedor", "codigo = '" + codPedido + "'");
		datosEMail["codDocumento"] = codPedido;
	} else {
		var cursor:FLSqlCursor = this.cursor();
		datosEMail["codDestino"] = cursor.valueBuffer("codproveedor");
		datosEMail["codDocumento"] = cursor.valueBuffer("codigo");
	}
	flfactinfo.iface.datosEMail = datosEMail;
	this.iface.__imprimir(codPedido);
}

//// ENVIO_MAIL /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pedidosauto */
/////////////////////////////////////////////////////////////////
//// PEDIDOS_AUTO //////////////////////////////////////////////

function pedidosauto_recordDelBeforepedidosprov()
{
	var cursor:FLSqlCursor = this.cursor();
	if (!cursor.isValid())
		return false;
		
	if (cursor.modeAccess() != cursor.Del)
		return true;
	
	var curTab:FLSqlCursor = new FLSqlCursor("pedidosaut");
	curTab.select("idpedidoaut = " + cursor.valueBuffer("idpedidoaut"));
	if (!curTab.first())
		return true;
		
	with(curTab) {
		setUnLock("editable", true);
		setModeAccess(Edit);
		refreshBuffer();
		commitBuffer();
	}
	
	return true;
}
//// PEDIDOS_AUTO //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition rappel */
/////////////////////////////////////////////////////////////////
//// RAPPEL /////////////////////////////////////////////////////
/** \D Copia los datos de una línea de pedido en una línea de albarán añadiendo el dato de descuento por rappel a una línea de albarán
@param	curLineaPedido: Cursor que contiene los datos a incluir en la línea de albarán
@return	True si la copia se realiza correctamente, false en caso contrario
\end */
function rappel_datosLineaAlbaran(curLineaPedido:FLSqlCursor):Boolean
{
	with (this.iface.curLineaAlbaran) {
		setValueBuffer("dtorappel", curLineaPedido.valueBuffer("dtorappel"));
	}
	
	if(!this.iface.__datosLineaAlbaran(curLineaPedido))
		return false;
		
	return true;
}

//// RAPPEL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////

/** @class_definition pedProvCli*/
/////////////////////////////////////////////////////////////////
//// PED_PROV_CLI ///////////////////////////////////////////////
function pedProvCli_init()
{
	var util:FLUtil;

	this.iface.__init();
	
	connect(this.child("tbnPedidosCli"), "clicked()", this, "iface.tbnPedidosCli_clicked");

	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList("pedidosprov");
	q.setSelect("idpedido");
	q.setFrom("pedidosprov");
	q.setWhere("editable = false AND abierto = true");

	if (!q.exec())
		return false;

	var curPed:FLSqlCursor = new FLSqlCursor("pedidosprov");
	curPed.setActivatedCommitActions(false);
	while (q.next()) {
		curPed.select("idpedido = " + q.value("idpedido"));
		curPed.first();
		curPed.setUnLock("editable", true);

		curPed.select("idpedido = " + q.value("idpedido"));
		curPed.first();
		curPed.setModeAccess(curPed.Edit);
		curPed.refreshBuffer();
		curPed.setValueBuffer("abierto",false);
		curPed.commitBuffer();
		
		curPed.select("idpedido = " + q.value("idpedido"));
		curPed.first();
		curPed.setUnLock("editable", false);
	}
}

function pedProvCli_tbnPedidosCli_clicked()
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	this.iface.mensajeFinal = "";
	var f:Object = new FLFormSearchDB("buscapedclisel");
	var curPedidosCli:FLSqlCursor = f.cursor();
	
	curPedidosCli.setMainFilter(this.iface.filtroPedidosCli());
	f.setMainWidget();
	if (!f.exec("idpedido")) {
		return;
	}
	if (this.iface.pedidosSel_.length == 0) {
		return;
	}
	var listaPedidos:String = this.iface.pedidosSel_.toString();
	if (!this.iface.crearArray(listaPedidos)) {
		return false;
	}

	var curT:FLSqlCursor = new FLSqlCursor("empresa");
	curT.transaction(false);
	try {
		if (this.iface.crearPedidos()) {
			curT.commit();
		}
		else {
			curT.rollback();
			return;
		}
	}
	catch (e) {
		curT.rollback();
		MessageBox.critical(util.translate("scripts", "Hubo un error en la generación de pedidos:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	
	this.iface.tdbRecords.refresh();
	this.iface.procesarEstado();
	
	MessageBox.information(util.translate("scripts", "Pedidos implicados: \n%1").arg(this.iface.mensajeFinal), MessageBox.Ok, MessageBox.NoButton);
}

function pedProvCli_crearPedidos():Boolean
{
	var util:FLUtil;

	var pedidosAbiertos:Array;
	for(var indice=0;indice<this.iface.lineasPedCli.length;indice++) {

		delete pedidosAbiertos;
		pedidosAbiertos = this.iface.buscarPedidosAbiertos(this.iface.lineasPedCli[indice]);
		if(pedidosAbiertos.length > 0) {

			var dialog = new Dialog;
			dialog.caption = "Pedidos abiertos";
			dialog.okButtonText = "Aceptar"
			dialog.cancelButtonText = "Cancelar";
			
			var gbx = new GroupBox;
			var codProveedor:String = this.iface.lineasPedCli[indice][0];
			var nombreProv:String = util.sqlSelect("proveedores", "nombre", "codproveedor = '" + codProveedor + "'");
			gbx.title = util.translate("scripts", "Existen pedidos abiertos para el proveedor %1 - %2. Selecciona el pedido al cual asociar las líneas:").arg(codProveedor).arg(nombreProv);
			dialog.add(gbx)
			var pedidos:Array = new Array();
			pedidos[0] = new RadioButton;
			pedidos[0].text = "Pedido nuevo";
			pedidos[0].checked = false;
			gbx.add(pedidos[0]);
			
			for(var i=0;i<pedidosAbiertos.length;i++) {
				pedidos[i+1] = new RadioButton;
				pedidos[i+1].text = util.translate("scripts", "Pedido %1 del %2    Importe: %3").arg(pedidosAbiertos[i][1]).arg(util.dateAMDtoDMA(pedidosAbiertos[i][2])).arg(util.roundFieldValue(parseFloat(pedidosAbiertos[i][3]), "pedidosprov","total"));
				if(i == pedidosAbiertos.length -1) {
					pedidos[i+1].checked = true;
				} else {
					pedidos[i+1].checked = false;
				}
				gbx.add(pedidos[i+1]);
			}
			
			if (!dialog.exec()) {
				return false;
			}
			var nuevoPed:String;
			if (pedidos[0].checked) {
				nuevoPed = this.iface.crearPedidoProvCli(indice);
				if (!nuevoPed) {
					return false;
				} else {
					this.iface.mensajeFinal += nuevoPed + " (NUEVO)" + "\n";
				}
			} else {
				for (var i=1;i<=pedidosAbiertos.length;i++) {
					if (pedidos[i].checked) {
						nuevoPed = this.iface.crearPedidoProvCli(indice,pedidosAbiertos[i-1][0]);
						if (!nuevoPed) {
							return false;
						} else {
							this.iface.mensajeFinal += nuevoPed + " (MODIFICADO)" + "\n";
						}
						i = pedidosAbiertos.length;
					}
				}
			}
		} else {
			nuevoPed = this.iface.crearPedidoProvCli(indice);
			if (!nuevoPed) {
				return false;
			} else {
				this.iface.mensajeFinal += nuevoPed + " (NUEVO)" + "\n";
			}
		}
	}
	return true;
}

function pedProvCli_crearPedidoProvCli(indice:Number,idPedido:Number):String
{
	var util:FLUtil;

	if (!this.iface.curPedidoProvCli_) {
		this.iface.curPedidoProvCli_ = new FLSqlCursor("pedidosprov");
	}

	if (!idPedido) {
		this.iface.curPedidoProvCli_.setModeAccess(this.iface.curPedidoProvCli_.Insert);
		this.iface.curPedidoProvCli_.refreshBuffer();
		if (!this.iface.datosPedidoProvCli(indice)) {
			return false;
		}
		if (!this.iface.curPedidoProvCli_.commitBuffer()) {
			return false;
		}
		idPedido = this.iface.curPedidoProvCli_.valueBuffer("idpedido");
	}
	if (!this.iface.copiarLineasPedidoProvCli(false, idPedido, indice)) {
		return false;
	}
	this.iface.curPedidoProvCli_.select("idpedido = " + idPedido);
	if (!this.iface.curPedidoProvCli_.first()) {
		return false;
	}
	this.iface.curPedidoProvCli_.setModeAccess(this.iface.curPedidoProvCli_.Edit);
	this.iface.curPedidoProvCli_.refreshBuffer();
	
	if (!this.iface.calcularTotalesPedidoProvCli()) {
		return false;
	}
	if (!this.iface.curPedidoProvCli_.commitBuffer()) {
		return false;
	}
	
	return this.iface.curPedidoProvCli_.valueBuffer("codigo");
}

function pedProvCli_datosPedidoProvCli(indice:Number):Boolean
{
	var util:FLUtil;

	var codProveedor:String = this.iface.lineasPedCli[indice][0];
	if (!codProveedor || codProveedor == "") {
		return false;
	}

	var hoy:Date = new Date();
	with(this.iface.curPedidoProvCli_) {
		setValueBuffer("fecha",hoy);
		setValueBuffer("codproveedor", codProveedor);
		setValueBuffer("nombre", util.sqlSelect("proveedores","nombre","codproveedor = '" + codProveedor + "'"));
		setValueBuffer("cifnif", util.sqlSelect("proveedores","cifnif","codproveedor = '" + codProveedor + "'"));
		setValueBuffer("codejercicio", flfactppal.iface.pub_ejercicioActual());
		setValueBuffer("codserie", flfactppal.iface.pub_valorDefectoEmpresa("codserie"));
		setValueBuffer("irpf", formpedidosprov.iface.pub_commonCalculateField("irpf", this));
		setValueBuffer("codalmacen", flfactppal.iface.pub_valorDefectoEmpresa("codalmacen"));
		setValueBuffer("coddivisa", flfactppal.iface.pub_valorDefectoEmpresa("coddivisa"));
		setValueBuffer("tasaconv", util.sqlSelect("divisas", "tasaconv", "coddivisa = '" + valueBuffer("coddivisa") + "'"));
		setValueBuffer("codpago", flfactppal.iface.pub_valorDefectoEmpresa("codpago"));
	}

	return true;
}

function pedProvCli_calcularTotalesPedidoProvCli():Boolean
{
	with (this.iface.curPedidoProvCli_) {
		setValueBuffer("neto", formpedidosprov.iface.pub_commonCalculateField("neto", this));
		setValueBuffer("totaliva", formpedidosprov.iface.pub_commonCalculateField("totaliva", this));
		setValueBuffer("totalirpf", formpedidosprov.iface.pub_commonCalculateField("totalirpf", this));
		setValueBuffer("totalrecargo", formpedidosprov.iface.pub_commonCalculateField("totalrecargo", this));
		setValueBuffer("total", formpedidosprov.iface.pub_commonCalculateField("total", this));
		setValueBuffer("totaleuros", formpedidosprov.iface.pub_commonCalculateField("totaleuros", this));
	}

	return true;
}

/** \D Copia las líneas de un pedido de cliente en líneas de un pedido a proveedor
@param	idPedidoCli: Identificador del pedido de cliente
@param	idPedidoProv: Identificador del pedido de proveedor
@return	true si la copia se realiza de forma correcta, false si hay error
\end */
function pedProvCli_copiarLineasPedidoProvCli(idPedidoCli:String, idPedidoProv:String,indice:Number):Boolean
{
	var util:FLUtil = new FLUtil;
	var curLineasCli:FLSqlCursor = new FLSqlCursor("lineaspedidoscli");
	var curLineasProv:FLSqlCursor = new FLSqlCursor("lineaspedidosprov");

	if(idPedidoCli)
		curLineasCli.select("idpedido = " + idPedidoCli);
	else {
		if(indice >= 0)
			curLineasCli.select("idlinea IN (" + this.iface.lineasPedCli[indice][1].toString() + ")");
		else
			return false;
	}
	
	var cantidad:Number, cantidadProv:Number;
	var estadoCopia:String;
	while (curLineasCli.next()) {
		curLineasCli.setModeAccess(curLineasCli.Edit);
		curLineasCli.refreshBuffer();

		cantidad = parseFloat(curLineasCli.valueBuffer("cantidad")) - parseFloat(curLineasCli.valueBuffer("totalenalbaran"));
		cantidadProv = util.sqlSelect("lineaspedidosprov", "SUM(CASE WHEN cerrada THEN totalenalbaran ELSE cantidad END)", "idlineacli = " + curLineasCli.valueBuffer("idlinea"));
		cantidad -= (isNaN(cantidadProv) ? 0 : parseFloat(cantidadProv));
		if (cantidad <= 0) {
			continue;
		}

		curLineasProv.setModeAccess(curLineasProv.Insert);
		curLineasProv.refreshBuffer();
		curLineasProv.setValueBuffer("cantidad", cantidad);
		
		estadoCopia = this.iface.datosLineaPedidoProvCli(curLineasCli,curLineasProv,idPedidoProv);
		switch (estadoCopia) {
			case "OK": {
				break;
			}
			case "SALTAR": {
				continue;
				break;
			}
			default: {
				return false;
			}
		}
		
		if (!curLineasProv.commitBuffer()) {
			return false;
		}
		curLineasCli.setValueBuffer("idlineaprov", curLineasProv.valueBuffer("idlinea"));
		if (!curLineasCli.commitBuffer()) {
			return false;
		}
	}
	
	return true;
}

function pedProvCli_asociarPedidoProvCli(idPedidoCli:Number,idPedidoProv:Number):Boolean
{
	if(!idPedidoCli || !idPedidoProv)
		return false;

	var util:FLUtil = new FLUtil();
	var curPedidoCli:FLSqlCursor = new FLSqlCursor("pedidoscli");
	curPedidoCli.select("idpedido = " + idPedidoCli);
	if (!curPedidoCli.first())
		return false;
	
	curPedidoCli.setModeAccess(curPedidoCli.Edit);
	curPedidoCli.refreshBuffer();
	curPedidoCli.setValueBuffer("idpedidoprov", idPedidoProv);
	curPedidoCli.setValueBuffer("codpedidoprov", util.sqlSelect("pedidosprov","codigo","idpedido = " + idPedidoProv));
	if (!curPedidoCli.commitBuffer())
		return false;
		
	return true;
}

/** \D Copia los datos de la línea de pedido de cliente en la línea de pedido de proveedor
@param	curLineasCli: Cursor de la línea de pedido de cliente
@param	curLineasProv: Cursor de la línea de pedido de proveedor
@param	idPedido: Identificador del pedido de proveedor
@return	Valores:
 * OK: Correcto
 * SALTAR: No copiar la línea, continuar con la siguiente
 * false: Error
\end */
function pedProvCli_datosLineaPedidoProvCli(curLineasCli:FLSqlCursor,curLineasProv:FLSqlCursor,idPedido:Number):String
{
	var util:FLUtil;
	var valor:Number;
	
	with (curLineasProv) {
		setValueBuffer("idpedido", idPedido);
		setValueBuffer("referencia", curLineasCli.valueBuffer("referencia"));
		setValueBuffer("descripcion", curLineasCli.valueBuffer("descripcion"));
// 		setValueBuffer("cantidad", cantidad);

		valor = formRecordlineaspedidosprov.iface.pub_commonCalculateField("pvpunitario", curLineasProv);
		if (!valor || isNaN(valor)) {
			valor = 0;	
		}
		setValueBuffer("pvpunitario", parseFloat(valor));

		valor = formRecordlineaspedidosprov.iface.pub_commonCalculateField("pvpsindto", curLineasProv);
		setValueBuffer("pvpsindto", parseFloat(valor));

		setValueBuffer("codimpuesto", formRecordlineaspedidosprov.iface.pub_commonCalculateField("codimpuesto", curLineasProv));

		valor = formRecordlineaspedidosprov.iface.pub_commonCalculateField("iva", curLineasProv);
		setValueBuffer("iva", parseFloat(valor));

		valor = formRecordlineaspedidosprov.iface.pub_commonCalculateField("recargo", curLineasProv);
		setValueBuffer("recargo", parseFloat(valor));

		valor = formRecordlineaspedidosprov.iface.pub_commonCalculateField("dtopor", curLineasProv);
		if (!valor || isNaN(valor)) {
			valor = 0;
		}
		setValueBuffer("dtopor", parseFloat(valor));

		valor = formRecordlineaspedidosprov.iface.pub_commonCalculateField("pvptotal", curLineasProv);
		setValueBuffer("pvptotal", parseFloat(valor));

		setValueBuffer("idlineacli", curLineasCli.valueBuffer("idlinea"));
	}

	return "OK";
}

function pedProvCli_buscarPedidosAbiertos(arrayPedCli:Array):Array
{
	var array:Array = new Array();
	var tam:Number = 0;
	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList("pedidosprov");
	q.setSelect("idpedido,codigo,fecha,total");
	q.setFrom("pedidosprov");
	q.setWhere("abierto AND codproveedor = '" + arrayPedCli[0] + "' ORDER BY fecha");

	if (!q.exec()) {
		return false;
	}
	while (q.next()) {
		array[tam] = new Array();
		array[tam][0] = q.value("idpedido");
		array[tam][1] = q.value("codigo");
		array[tam][2] = q.value("fecha");
		array[tam][3] = q.value("total");
		tam ++;
	}
	return array;
}

function pedProvCli_crearArray(listaPedidos:String):Boolean
{
	var util:FLUtil;

	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList("lineaspedidoscli");
	q.setSelect("referencia,cantidad,totalenalbaran,idlinea");
	q.setFrom("lineaspedidoscli");
	q.setWhere("idpedido IN(" + listaPedidos + ") AND (cerrada IS NULL OR cerrada = false)");

	if (!q.exec()) {
		return false;
	}
	delete this.iface.lineasPedCli;
	this.iface.lineasPedCli = new Array();
	var codProveedor:String = "";
	var referencia:String = "";
	var cantidad:Number;
	var posicion:Number = -1;
	while (q.next()) {
		referencia = q.value("referencia");
		if (!referencia || referencia == "") {
			continue;
		}
		cantidad = parseFloat(q.value("cantidad")) - parseFloat(q.value("totalenalbaran"));
		if (cantidad <= 0) {
			continue;
		}
		codProveedor = util.sqlSelect("articulosprov","codproveedor","referencia = '" + referencia + "' AND pordefecto = true");
		if (!codProveedor || codProveedor == "") {
			var res:Number = MessageBox.warning(util.translate("scripts", "No se ha encontrado un proveedor para el artículo %1.\n¿Desea continuar generando el resto de pedidos?").arg(referencia), MessageBox.Yes, MessageBox.No);
			if (res != MessageBox.Yes) {
				return false;
			}
			continue;
		}

		posicion = this.iface.buscarProveedorArray(codProveedor);
		if (posicion == -1) {
			posicion = this.iface.lineasPedCli.length;
			this.iface.lineasPedCli[posicion] = new Array();
			this.iface.lineasPedCli[posicion][0] = codProveedor;
			this.iface.lineasPedCli[posicion][1] = new Array();
		}
		var linea:Number = this.iface.lineasPedCli[posicion][1].length
		this.iface.lineasPedCli[posicion][1][linea] = q.value("idlinea");
	}

// 	debug("===============================================");
// 	for(var i=0;i<this.iface.lineasPedCli.length;i++) {
// 		debug("------ Proveedor // " + this.iface.lineasPedCli[i][0] + " //");
// 		for(var j=0;j<this.iface.lineasPedCli[i][1].length;j++) {
// 			debug("------ Linea " + this.iface.lineasPedCli[i][1][j]);
// 		}
// 		debug("");
// 	}
// 	debug("===============================================");

	return true;
}

function pedProvCli_buscarProveedorArray(codProveedor:String):Number
{
	for (var i:Number = 0; i < this.iface.lineasPedCli.length; i++) {
		if (this.iface.lineasPedCli[i][0] == codProveedor) {
			return i;
		}
	}
	return -1;
}

/** \D Obtiene el filtro a aplicar sobre el formulario de búsqueda de pedidos de cliente
@return	filtro a aplicar
\end */
function pedProvCli_filtroPedidosCli():String
{
	return "pedido IN ('No', 'Parcial') AND servido IN ('No', 'Parcial')";
}

function pedProvCli_imprimir(codPedido:String)
{
	var util:FLUtil;

	this.iface.__imprimir(codPedido);
	
	var codigo:String;
	if (codPedido) {
		codigo = codPedido;
	} else {
		if (!this.cursor().isValid())
			return;
		codigo = this.cursor().valueBuffer("codigo");
	}
	
	if(util.sqlSelect("pedidosprov","abierto","codigo = '" + codigo + "'")) {
		var res:Number = MessageBox.information(util.translate("scripts", "¿Desea marcar el pedido como no abierto"), MessageBox.Yes, MessageBox.No);
		if(res == MessageBox.Yes)
			util.sqlUpdate("pedidosprov","abierto",false,"codigo = '" + codigo + "'");
	}
}
//// PED_PROV_CLI ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition dtoEspecial */
/////////////////////////////////////////////////////////////////
//// DTO ESPECIAL ///////////////////////////////////////////////
function dtoEspecial_commonCalculateField(fN:String, cursor:FLSqlCursor):String
{
	var util = new FLUtil();
	var valor;

	switch (fN) {
	/** \C
	El --totaliva-- es la suma del iva correspondiente a las líneas de factura
	\end */
		case "totaliva": {
			var porDto:Number = cursor.valueBuffer("pordtoesp");
			if (!porDto || porDto == 0) {
				valor = this.iface.__commonCalculateField(fN, cursor);
				break;
			}
			valor = util.sqlSelect("lineaspedidosprov", "SUM((pvptotal * iva * (100 - " + porDto + ")) / 100 / 100)", "idpedido = " + cursor.valueBuffer("idpedido"));
			valor = parseFloat(util.roundFieldValue(valor, "pedidosprov", "totaliva"));
			break;
		}
	/** \C
	El --totarecargo-- es la suma del recargo correspondiente a las líneas de factura
	\end */
		case "totalrecargo":{
			var porDto:Number = cursor.valueBuffer("pordtoesp");
			if (!porDto || porDto == 0) {
				valor = this.iface.__commonCalculateField(fN, cursor);
				break;
			}
			valor = util.sqlSelect("lineaspedidosprov", "SUM((pvptotal * recargo * (100 - " + porDto + ")) / 100 / 100)", "idpedido = " + cursor.valueBuffer("idpedido"));
			valor = parseFloat(util.roundFieldValue(valor, "pedidosprov", "totalrecargo"));
			break;
		}
	/** \C
	El --netosindtoesp-- es la suma del pvp total de las líneas de factura
	\end */
		case "netosindtoesp":{
			valor = this.iface.__commonCalculateField("neto", cursor); 
			break;
		}
	/** \C
	El --neto-- es el --netosindtoesp-- menos el --dtoesp--
	\end */
		case "neto": {
			valor = parseFloat(cursor.valueBuffer("netosindtoesp")) - parseFloat(cursor.valueBuffer("dtoesp"));
			valor = parseFloat(util.roundFieldValue(valor, "pedidosprov", "neto"));
			break;
		}
	/** \C
	El --dtoesp-- es el --netosindtoesp-- menos el porcentaje que marca el --pordtoesp--
	\end */
		case "dtoesp": {
			valor = (parseFloat(cursor.valueBuffer("netosindtoesp")) * parseFloat(cursor.valueBuffer("pordtoesp"))) / 100;
			valor = parseFloat(util.roundFieldValue(valor, "pedidosprov", "dtoesp"));
			break;
		}
	/** \C
	El --pordtoesp-- es el --dtoesp-- entre el --netosindtoesp-- por 100
	\end */
		case "pordtoesp": {
			if (parseFloat(cursor.valueBuffer("netosindtoesp")) != 0) {
				valor = (parseFloat(cursor.valueBuffer("dtoesp")) / parseFloat(cursor.valueBuffer("netosindtoesp"))) * 100;
			} else {
				valor = cursor.valueBuffer("pordtoesp");
			}
			valor = parseFloat(util.roundFieldValue(valor, "pedidosprov", "pordtoesp"));
			break;
		}
		default: {
			valor = this.iface.__commonCalculateField(fN, cursor);
			break;
		}
	}
	return valor;
}

/** \D Informa los datos de un albarán a partir de los de uno o varios pedidos
@param	curPedido: Cursor que contiene los datos a incluir en el albarán
@return	True si el cálculo se realiza correctamente, false en caso contrario
\end */
function dtoEspecial_datosAlbaran(curPedido:FLSqlCursor, where:String, datosAgrupacion:Array):Boolean
{
	var util:FLUtil = new FLUtil();
	var porDtoEsp:Number = this.iface.buscarPorDtoEsp(where);
	if (porDtoEsp == -1) {
		MessageBox.critical(util.translate("scripts", "No es posible generar un único albarán para pedidos con distinto porcentaje de descuento especial"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	
	var fecha:String;
	if (curPedido.action() == "pedidosprov") {
		var hoy:Date = new Date();
		fecha = hoy.toString();
	} else
		fecha = curPedido.valueBuffer("fecha");
			
	with (this.iface.curAlbaran) {
		setValueBuffer("pordtoesp", porDtoEsp);
	}
	
	if(!this.iface.__datosAlbaran(curPedido, where, datosAgrupacion))
		return false;
	
	return true;
}

/** \D Informa los datos de un albarán referentes a totales (I.V.A., neto, etc.)
@return	True si el cálculo se realiza correctamente, false en caso contrario
\end */
function dtoEspecial_totalesAlbaran():Boolean
{
	with (this.iface.curAlbaran) {
		setValueBuffer("netosindtoesp", formalbaranesprov.iface.pub_commonCalculateField("netosindtoesp", this));
		setValueBuffer("dtoesp", formalbaranesprov.iface.pub_commonCalculateField("dtoesp", this));
		setValueBuffer("neto", formalbaranesprov.iface.pub_commonCalculateField("neto", this));
		setValueBuffer("totaliva", formalbaranesprov.iface.pub_commonCalculateField("totaliva", this));
		setValueBuffer("totalirpf", formalbaranesprov.iface.pub_commonCalculateField("totalirpf", this));
		setValueBuffer("totalrecargo", formalbaranesprov.iface.pub_commonCalculateField("totalrecargo", this));
		setValueBuffer("total", formalbaranesprov.iface.pub_commonCalculateField("total", this));
		setValueBuffer("totaleuros", formalbaranesprov.iface.pub_commonCalculateField("totaleuros", this));
	}
	return true;
}


/** \D
Busca el porcentaje de descuento especial realizado a los pedidos que se agruparán en un albarán. Si existen dos pedidos con distinto porcentaje devuelve un código de error.
@param where: Cláusula where para buscar los pedidos
@return porcenteje de descuento (-1 si hay error);
\end */
function dtoEspecial_buscarPorDtoEsp(where:String):Number
{
	var util:FLUtil = new FLUtil;
	var porDtoEsp:Number = util.sqlSelect("pedidosprov", "pordtoesp", where);
	var porDtoEsp2:Number = util.sqlSelect("pedidosprov", "pordtoesp", where + "AND pordtoesp <> " + porDtoEsp);
	if (!porDtoEsp2 && isNaN(parseFloat(porDtoEsp2)))
		return porDtoEsp;
	else
		return -1;
}
//// DTO ESPECIAL ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
//////////////////////////////////////////////////////