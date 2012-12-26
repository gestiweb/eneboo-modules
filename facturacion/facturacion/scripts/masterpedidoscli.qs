/***************************************************************************
                 masterpedidoscli.qs  -  description
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
	var ignorarAvisoStock_:Boolean;
	
    function oficial( context ) { interna( context ); } 
	function imprimir(codPedido:String) {
		return this.ctx.oficial_imprimir(codPedido);
	}
	function procesarEstado() {
		return this.ctx.oficial_procesarEstado();
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
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.oficial_commonCalculateField(fN, cursor);
	}
	function copiaLineas(idPedido:Number, idAlbaran:Number):Boolean {
		return this.ctx.oficial_copiaLineas(idPedido, idAlbaran);
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
	function comprobarStockEnAlbaranado(curLineaPedido:FLSqlCursor, cantidad:Number):Array {
		return this.ctx.oficial_comprobarStockEnAlbaranado(curLineaPedido, cantidad);
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

/** @class_declaration ivaIncluido */
//////////////////////////////////////////////////////////////////
//// IVAINCLUIDO /////////////////////////////////////////////////////
class ivaIncluido extends oficial {
    function ivaIncluido( context ) { oficial( context ); } 	
	function datosLineaAlbaran(curLineaPedido:FLSqlCursor):Boolean {
		return this.ctx.ivaIncluido_datosLineaAlbaran(curLineaPedido);
	}
	function totalesAlbaran():Boolean {
		return this.ctx.ivaIncluido_totalesAlbaran();
	}
}
//// IVAINCLUIDO /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////


/** @class_declaration envioMail */
/////////////////////////////////////////////////////////////////
//// ENVIO_MAIL ////////////////////////////////////////////////
class envioMail extends ivaIncluido {
    function envioMail( context ) { ivaIncluido ( context ); }
	function init() { 
		return this.ctx.envioMail_init(); 
	}
	function enviarDocumento(codPedido:String, codCliente:String) {
		return this.ctx.envioMail_enviarDocumento(codPedido, codCliente);
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

/** @class_declaration batchDocs */
/////////////////////////////////////////////////////////////////
//// BATCH_DOCS /////////////////////////////////////////////////
class batchDocs extends rappel {
	var pbnBatchPresupuestos;
    function batchDocs( context ) { rappel ( context ); }
	function init() {
		return this.ctx.batchDocs_init();
	}
	function pbnBatchPresupuestos_clicked() {
		return this.ctx.batchDocs_pbnBatchPresupuestos_clicked();
	}
	function whereAgrupacion(curAgrupar:FLSqlCursor):String {
		return this.ctx.batchDocs_whereAgrupacion(curAgrupar);
	}
}
//// BATCH_DOCS /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration dtoEspecial */
/////////////////////////////////////////////////////////////////
//// DTO ESPECIAL ///////////////////////////////////////////////
class dtoEspecial extends batchDocs {
    function dtoEspecial( context ) { batchDocs ( context ); }
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.dtoEspecial_commonCalculateField(fN, cursor);
	}
	function totalesAlbaran():Boolean {
		return this.ctx.dtoEspecial_totalesAlbaran();
	}
	function datosAlbaran(curPedido:FLSqlCursor,where:String,datosAgrupacion:Array):Boolean {
		return this.ctx.dtoEspecial_datosAlbaran(curPedido,where,datosAgrupacion);
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
	function pub_enviarDocumento(codPedido:String, codCliente:String) {
		return this.enviarDocumento(codPedido, codCliente);
	}
}

//// PUB_ENVIO_MAIL /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration ifaceCtx */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends pubEnvioMail {
    function ifaceCtx( context ) { pubEnvioMail( context ); }
	function pub_commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.commonCalculateField(fN, cursor);
	}
	function pub_generarAlbaran(where:String, cursor:FLSqlCursor, datosAgrupacion:Array):Number {
		return this.generarAlbaran(where, cursor, datosAgrupacion);
	}
	function pub_imprimir(codPedido:String) {
		return this.imprimir(codPedido);
	}
}

const iface = new pubBatchDocs( this );
//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubBatchDocs */
/////////////////////////////////////////////////////////////////
//// PUB_BATCH_DOCS /////////////////////////////////////////////
class pubBatchDocs extends ifaceCtx {
    function pubBatchDocs( context ) { ifaceCtx ( context ); }
	function pub_whereAgrupacion(curAgrupar:FLSqlCursor):String {
		return this.whereAgrupacion(curAgrupar);
	}
}
//// PUB_BATCH_DOCS /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition interna */
////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
/** \C
Este es el formulario maestro de pedidos a cliente.
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
	connect(this.iface.tdbRecords, "currentChanged()", this, "iface.procesarEstado");
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
		var curImprimir:FLSqlCursor = new FLSqlCursor("i_pedidoscli");
		curImprimir.setModeAccess(curImprimir.Insert);
		curImprimir.refreshBuffer();
		curImprimir.setValueBuffer("descripcion", "temp");
		curImprimir.setValueBuffer("d_pedidoscli_codigo", codigo);
		curImprimir.setValueBuffer("h_pedidoscli_codigo", codigo);
		flfactinfo.iface.pub_lanzarInforme(curImprimir, "i_pedidoscli");
	} else
			flfactppal.iface.pub_msgNoDisponible("Informes");
}

function oficial_procesarEstado()
{
		if (this.cursor().valueBuffer("editable") == true) {
				this.iface.pbnGAlbaran.enabled = true;
				this.iface.pbnGFactura.enabled = true;
		} else {
				this.iface.pbnGAlbaran.enabled = false;
				this.iface.pbnGFactura.enabled = false;
		}
}

/** \C
Al pulsar el botón de generar albarán se creará el albarán correspondiente al pedido seleccionado.
\end */
function oficial_pbnGenerarAlbaran_clicked()
{
	var cursor:FLSqlCursor = this.cursor();
	var where:String = "idpedido = " + cursor.valueBuffer("idpedido");
	var util:FLUtil = new FLUtil;

	if (cursor.valueBuffer("editable") == false) {
		MessageBox.warning(util.translate("scripts", "El pedido ya está servido"), MessageBox.Ok, MessageBox.NoButton);
		this.iface.procesarEstado();
		return;
	}
	this.iface.pbnGAlbaran.setEnabled(false);
	this.iface.pbnGFactura.setEnabled(false); 

	var ok:Boolean;
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
	var util:FLUtil = new FLUtil;
	var curAlbaran:FLSqlCursor = new FLSqlCursor("albaranescli");
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
			cursor.commit();
			cursor.transaction(false);
			where = "idalbaran = " + idAlbaran;
			curAlbaran.select(where);
			if (curAlbaran.first()) {
				if (formalbaranescli.iface.pub_generarFactura(where, curAlbaran))
					cursor.commit();
				else
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
	var util:FLUtil = new FLUtil;

	if (!this.iface.curAlbaran) {
		this.iface.curAlbaran = new FLSqlCursor("albaranescli");
	}
	this.iface.curAlbaran.setModeAccess(this.iface.curAlbaran.Insert);
	this.iface.curAlbaran.refreshBuffer();
	
	if (!this.iface.datosAlbaran(curPedido, where, datosAgrupacion)) {
		return false;
	}
	if (!this.iface.curAlbaran.commitBuffer()) {
		return false;
	}
	
	var idAlbaran:Number = this.iface.curAlbaran.valueBuffer("idalbaran");
	
	var qryPedidos:FLSqlQuery = new FLSqlQuery();
	qryPedidos.setTablesList("pedidoscli");
	qryPedidos.setSelect("idpedido");
	qryPedidos.setFrom("pedidoscli");
	qryPedidos.setWhere(where);

	if (!qryPedidos.exec()) {
		return false;
	}
	var idPedido:String;
	while (qryPedidos.next()) {
		idPedido = qryPedidos.value(0);
		if (!this.iface.copiaLineas(idPedido, idAlbaran))
			return false;
	}

	this.iface.curAlbaran.select("idalbaran = " + idAlbaran);
	if (this.iface.curAlbaran.first()) {
		if (util.sqlSelect("lineasalbaranescli", "idlinea", "idalbaran = " + idAlbaran)) {
			this.iface.curAlbaran.setModeAccess(this.iface.curAlbaran.Edit);
			this.iface.curAlbaran.refreshBuffer();
			if (!this.iface.totalesAlbaran()) {
				return false;
			}
			if (this.iface.curAlbaran.commitBuffer() == false) {
				return false;
			}
		} else {
			res = MessageBox.warning(util.translate("scripts", "El albarán generado no tiene ninguna línea.\n¿Desea generarlo de todas formas?"), MessageBox.Yes, MessageBox.No);
			if (res == MessageBox.No) {
				this.iface.curAlbaran.setModeAccess(this.iface.curAlbaran.Del);
				this.iface.curAlbaran.refreshBuffer();
				if (this.iface.curAlbaran.commitBuffer() == false) {
					return false;
				}
			}
		}
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
	var util:FLUtil = new FLUtil();
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
	var datosDoc:Array = flfacturac.iface.pub_datosDocFacturacion(fecha, codEjercicio, "albaranescli");
	if (!datosDoc.ok)
		return false;
	if (datosDoc.modificaciones == true) {
		codEjercicio = datosDoc.codEjercicio;
		fecha = datosDoc.fecha;
	}
	
	var codDir:Number = util.sqlSelect("dirclientes", "id", "codcliente = '" + curPedido.valueBuffer("codcliente") + "' AND domenvio = 'true'");
		
	with (this.iface.curAlbaran) {
		setValueBuffer("codserie", curPedido.valueBuffer("codserie"));
		setValueBuffer("codejercicio", codEjercicio);
		setValueBuffer("irpf", curPedido.valueBuffer("irpf"));
		setValueBuffer("fecha", fecha);
		setValueBuffer("hora", hora);
		setValueBuffer("codagente", curPedido.valueBuffer("codagente"));
		setValueBuffer("porcomision", curPedido.valueBuffer("porcomision"));
		setValueBuffer("codalmacen", curPedido.valueBuffer("codalmacen"));
		setValueBuffer("codpago", curPedido.valueBuffer("codpago"));
		setValueBuffer("coddivisa", curPedido.valueBuffer("coddivisa"));
		setValueBuffer("tasaconv", curPedido.valueBuffer("tasaconv"));
		setValueBuffer("codcliente", curPedido.valueBuffer("codcliente"));
		setValueBuffer("cifnif", curPedido.valueBuffer("cifnif"));
		setValueBuffer("nombrecliente", curPedido.valueBuffer("nombrecliente"));
		if (!codDir) {
			codDir = curPedido.valueBuffer("coddir")
			if (codDir == 0)
				setNull("coddir");
			else 
				setValueBuffer("coddir", curPedido.valueBuffer("coddir"));
			setValueBuffer("direccion", curPedido.valueBuffer("direccion"));
			setValueBuffer("codpostal", curPedido.valueBuffer("codpostal"));
			setValueBuffer("ciudad", curPedido.valueBuffer("ciudad"));
			setValueBuffer("provincia", curPedido.valueBuffer("provincia"));
			setValueBuffer("apartado", curPedido.valueBuffer("apartado"));
			setValueBuffer("codpais", curPedido.valueBuffer("codpais"));
		} else {
			setValueBuffer("coddir", codDir);
			setValueBuffer("direccion", util.sqlSelect("dirclientes","direccion","id = " + codDir));
			setValueBuffer("codpostal", util.sqlSelect("dirclientes","codpostal","id = " + codDir));
			setValueBuffer("ciudad", util.sqlSelect("dirclientes","ciudad","id = " + codDir));
			setValueBuffer("provincia", util.sqlSelect("dirclientes","provincia","id = " + codDir));
			setValueBuffer("apartado", util.sqlSelect("dirclientes","apartado","id = " + codDir));
			setValueBuffer("codpais", util.sqlSelect("dirclientes","codpais","id = " + codDir));
		}
		setValueBuffer("recfinanciero", curPedido.valueBuffer("recfinanciero"));
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
		setValueBuffer("neto", formalbaranescli.iface.pub_commonCalculateField("neto", this));
		setValueBuffer("totaliva", formalbaranescli.iface.pub_commonCalculateField("totaliva", this));
		setValueBuffer("totalirpf", formalbaranescli.iface.pub_commonCalculateField("totalirpf", this));
		setValueBuffer("totalrecargo", formalbaranescli.iface.pub_commonCalculateField("totalrecargo", this));
		setValueBuffer("total", formalbaranescli.iface.pub_commonCalculateField("total", this));
		setValueBuffer("totaleuros", formalbaranescli.iface.pub_commonCalculateField("totaleuros", this));
	}
	return true;
}

function oficial_actualizarDatosPedido(where:String, idAlbaran:String):Boolean
{
	var curPedidos:FLSqlCursor = new FLSqlCursor("pedidoscli");
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

function oficial_commonCalculateField(fN:String, cursor:FLSqlCursor):String
{
		var util = new FLUtil();
		var valor;
		/** \C
		El --código-- se construye como la concatenación de --codserie--, --codejercicio-- y --numero--
		\end */
		if (fN == "codigo")
				valor = flfacturac.iface.pub_construirCodigo(cursor.valueBuffer("codserie"), cursor.valueBuffer("codejercicio"), cursor.valueBuffer("numero"));

		switch (fN) {
			/** \C
			El --total-- es el --neto-- menos el --totalirpf-- más el --totaliva-- más el --totalrecargo-- más el --recfinanciero--
			\end */
			case "total": {
				var neto = parseFloat(cursor.valueBuffer("neto"));
				var totalIrpf = parseFloat(cursor.valueBuffer("totalirpf"));
				var totalIva = parseFloat(cursor.valueBuffer("totaliva"));
				var totalRecargo = parseFloat(cursor.valueBuffer("totalrecargo"));
				var recFinanciero = (parseFloat(cursor.valueBuffer("recfinanciero")) * neto) / 100;
				recFinanciero = parseFloat(util.roundFieldValue(recFinanciero, "pedidoscli", "total"));
				valor = neto - totalIrpf + totalIva + totalRecargo + recFinanciero;
				valor = parseFloat(util.roundFieldValue(valor, "pedidoscli", "total"));
				break;
			}
			case "lblComision": {
				valor = (parseFloat(cursor.valueBuffer("porcomision")) * (parseFloat(cursor.valueBuffer("neto")))) / 100;
				valor = parseFloat(util.roundFieldValue(valor, "pedidoscli", "total"));
				break;
			}
			case "lblRecFinanciero": {
				valor = (parseFloat(cursor.valueBuffer("recfinanciero")) * (parseFloat(cursor.valueBuffer("neto")))) / 100;
				valor = parseFloat(util.roundFieldValue(valor, "pedidoscli", "total"));
				break;
			}
			/** \C
			El --totaleuros-- es el producto del --total-- por la --tasaconv--
			\end */
			case "totaleuros": {
				var total = parseFloat(cursor.valueBuffer("total"));
				var tasaConv = parseFloat(cursor.valueBuffer("tasaconv"));
				valor = total * tasaConv;
				valor = parseFloat(util.roundFieldValue(valor, "pedidoscli", "totaleuros"));
				break;
			}
			/** \C
			El --neto-- es la suma del pvp total de las líneas de factura
			\end */
			case "neto": {
				valor = util.sqlSelect("lineaspedidoscli", "SUM(pvptotal)", "idpedido = " + cursor.valueBuffer("idpedido"));
				valor = parseFloat(util.roundFieldValue(valor, "pedidoscli", "neto"));
				break;
			}
			/** \C
			El --totaliva-- es la suma del iva correspondiente a las líneas de factura
			\end */
			case "totaliva": {
				var codCli:String = cursor.valueBuffer("codcliente");
				var regIva:String = flfacturac.iface.pub_regimenIVACliente(cursor);
				if(regIva == "U.E." || regIva == "Exento" || regIva == "Exportaciones") {
					valor = 0;
					break;
				}
				valor = util.sqlSelect("lineaspedidoscli", "SUM((pvptotal * iva) / 100)", "idpedido = " + cursor.valueBuffer("idpedido"));
				valor = parseFloat(util.roundFieldValue(valor, "pedidoscli", "totaliva"));
				break;
			}
			/** \C
			El --totarecargo-- es la suma del recargo correspondiente a las líneas de factura
			\end */
			case "totalrecargo": {
				var codCli:String = cursor.valueBuffer("codcliente");
				var regIva:String = flfacturac.iface.pub_regimenIVACliente(cursor);
				if(regIva == "U.E." || regIva == "Exento" || regIva == "Exportaciones") {
					valor = 0;
					break;
				}
				valor = util.sqlSelect("lineaspedidoscli", "SUM((pvptotal * recargo) / 100)", "idpedido = " + cursor.valueBuffer("idpedido"));
				valor = parseFloat(util.roundFieldValue(valor, "pedidoscli", "totalrecargo"));
				break;
			}
			/** \C
			El --coddir-- corresponde a la dirección del cliente marcada como dirección de facturación
			\end */
			case "coddir": {
				valor = util.sqlSelect("dirclientes", "id", "codcliente = '" + cursor.valueBuffer("codcliente") + "' AND domfacturacion = 'true'");
				if (!valor) {
					valor = "";
				}
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
				valor = util.sqlSelect("lineaspedidoscli", "SUM((pvptotal * irpf) / 100)", "idpedido = " + cursor.valueBuffer("idpedido"));
// 				valor = (parseFloat(cursor.valueBuffer("irpf")) * (parseFloat(cursor.valueBuffer("neto")))) / 100;
				valor = parseFloat(util.roundFieldValue(valor, "pedidoscli", "totalirpf"));
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

/** \D
Copia las líneas de un pedido como líneas de su albarán asociado
@param idPedido: Identificador del pedido
@param idAlbaran: Identificador del albarán
@return VERDADERO si no hay error. FALSE en otro caso.
\end */
function oficial_copiaLineas(idPedido:Number, idAlbaran:Number):Boolean
{
	var util:FLUtil = new FLUtil;
	var cantidad:Number;
	var totalEnAlbaran:Number;
	this.iface.ignorarAvisoStock_ = false;
	var curLineaPedido:FLSqlCursor = new FLSqlCursor("lineaspedidoscli");
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
	if (!this.iface.curLineaAlbaran) {
		this.iface.curLineaAlbaran = new FLSqlCursor("lineasalbaranescli");
	}
	with (this.iface.curLineaAlbaran) {
		setModeAccess(Insert);
		refreshBuffer();
		setValueBuffer("idalbaran", idAlbaran);
	}
	
	if (!this.iface.datosLineaAlbaran(curLineaPedido)) {
		return false;
	}

 	/// Este If está puesto para no crear líneas de albararán con cantidad 0 cuando el pedido tiene una cantidad superior pero no hay stock
 	if (!(this.iface.curLineaAlbaran.valueBuffer("cantidad") == 0 && curLineaPedido.valueBuffer("cantidad") != 0)) {
		if (!this.iface.curLineaAlbaran.commitBuffer()) {
			return false;
		}
 	}
	
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
	var comprobarStock:Array = this.iface.comprobarStockEnAlbaranado(curLineaPedido, cantidad);
	if (!comprobarStock["ok"])
		return false;
	
	if (!comprobarStock["haystock"]) {
		cantidad = comprobarStock["cantidad"];
	}
/// Eliminado para evitar fallos de redondeo en extensión IVA incluido
// 	var pvpSinDto:Number = parseFloat(curLineaPedido.valueBuffer("pvpsindto")) * cantidad / parseFloat(curLineaPedido.valueBuffer("cantidad"));
// 	pvpSinDto = util.roundFieldValue(pvpSinDto, "lineasalbaranescli", "pvpsindto");
	
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
				iva = formRecordlineaspedidoscli.iface.pub_commonCalculateField("iva", this); /// Para cambio de IVA según fechas
			}
			setValueBuffer("iva", iva);
		}
		if (curLineaPedido.isNull("recargo")) {
			setNull("recargo");
		} else {
			recargo = curLineaPedido.valueBuffer("recargo");
			if (recargo != 0 && codImpuesto && codImpuesto != "") {
				recargo = formRecordlineaspedidoscli.iface.pub_commonCalculateField("recargo", this); /// Para cambio de IVA según fechas
			}
			setValueBuffer("recargo", recargo);
		}
		setValueBuffer("irpf", curLineaPedido.valueBuffer("irpf"));
		setValueBuffer("dtolineal", curLineaPedido.valueBuffer("dtolineal"));
		setValueBuffer("dtopor", curLineaPedido.valueBuffer("dtopor"));
		setValueBuffer("porcomision", curLineaPedido.valueBuffer("porcomision"));
// 		setValueBuffer("pvpsindto", pvpSinDto);
		setValueBuffer("pvpsindto", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpsindto", this));
		setValueBuffer("pvptotal", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotal", this));
	}
	return true;
}

function oficial_comprobarStockEnAlbaranado(curLineaPedido:FLSqlCursor, cantidad:Number):Array
{
	var util:FLUtil = new FLUtil;
	var res:Array = [];

	res["haystock"] = true;
	res["cantidad"] = 0;
	res["ok"] = true;
	var referencia:String = curLineaPedido.valueBuffer("referencia");
	if (referencia && referencia != "") {
		var controlStock:Boolean = util.sqlSelect("articulos", "controlstock", "referencia = '" + referencia + "'");
		if (!controlStock) {
			var codAlmacen:String;
			if (curLineaPedido.cursorRelation())
				codAlmacen = curLineaPedido.cursorRelation().valueBuffer("codalmacen");
			else
				codAlmacen = util.sqlSelect("pedidoscli", "codalmacen", "idpedido = " + curLineaPedido.valueBuffer("idpedido"));

			var cantidadStock:Number = parseFloat(util.sqlSelect("stocks", "cantidad", "referencia = '" + referencia + "' AND codalmacen = '" + codAlmacen + "'"));
			if (!cantidadStock || isNaN(cantidadStock))
				cantidadStock = 0;

			if (cantidadStock < cantidad) {
				res["haystock"] = false;
				if (!this.iface.ignorarAvisoStock_) {
					var resCuestion:Number = MessageBox.warning(util.translate("scripts", "El artículo %1 no permite ventas sin stocks.\nEstá albaranando más cantidad (%2) que la disponible (%3) ahora mismo en el almacén %4.\n¿Desea continuar dejando el pedido parcialmente albaranado?\n(pulse Ignorar para evitar esta pregunta en el resto de las líneas)").arg(referencia).arg(cantidad).arg(cantidadStock).arg(codAlmacen), MessageBox.No, MessageBox.Yes, MessageBox.Ignore);
					switch (resCuestion) {
						case MessageBox.Yes: {
							break;
						}
						case MessageBox.Ignore: {
							this.iface.ignorarAvisoStock_ = true;
							break;
						}
						default: {
							res["ok"] = false;
							return res;
						}
					}
				}
				if (cantidadStock < 0) {
					cantidadStock = 0;
				}
				res["cantidad"] = cantidadStock;
			}
		}
	}
	return res;
}

function oficial_abrirCerrarPedido()
{
	var util:FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var idPedido:Number = cursor.valueBuffer("idpedido");
	if(!idPedido) {
		MessageBox.warning(util.translate("scripts", "No hay ningún registro seleccionado"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}

	var cerrar:Boolean = true;
	var res:Number;
	if(util.sqlSelect("lineaspedidoscli","cerrada","idpedido = " + idPedido + " AND cerrada")) {
		cerrar = false;
		res = MessageBox.information(util.translate("scripts", "El pedido seleccionado tiene líneas cerradas.\n¿Seguro que desea abrirlas?"), MessageBox.Yes, MessageBox.No);
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

	if(!util.sqlUpdate("lineaspedidoscli","cerrada",cerrar,"idpedido = " + idPedido))
		return;

	if (!flfacturac.iface.pub_actualizarEstadoPedidoCli(idPedido))
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

/** @class_definition ivaIncluido */
//////////////////////////////////////////////////////////////////
//// IVAINCLUIDO /////////////////////////////////////////////////////
/** \D Copia los datos de una línea de pedido en una línea de albarán
@param	curLineaPedido: Cursor que contiene los datos a incluir en la línea de albarán
@return	True si la copia se realiza correctamente, false en caso contrario
\end */
function ivaIncluido_datosLineaAlbaran(curLineaPedido:FLSqlCursor):Boolean
{
	if (!this.iface.__datosLineaAlbaran(curLineaPedido)) {
		return false;
	}
	with (this.iface.curLineaAlbaran) {
		setValueBuffer("ivaincluido", curLineaPedido.valueBuffer("ivaincluido"));
		setValueBuffer("pvpunitarioiva", curLineaPedido.valueBuffer("pvpunitarioiva"));
	}
	/// El cambio puede deberse a que la fecha del nuevo documento esté asociada a un tipo de IVA distinto del documento origens
	if (curLineaPedido.valueBuffer("iva") != this.iface.curLineaAlbaran.valueBuffer("iva")) {
		if (this.iface.curLineaAlbaran.valueBuffer("ivaincluido")) {
			this.iface.curLineaAlbaran.setValueBuffer("pvpunitario", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpunitario2", this.iface.curLineaAlbaran));
			this.iface.curLineaAlbaran.setValueBuffer("pvpsindto", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpsindto", this.iface.curLineaAlbaran));
			this.iface.curLineaAlbaran.setValueBuffer("pvptotal", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotal", this.iface.curLineaAlbaran));
		} else {
			this.iface.curLineaAlbaran.setValueBuffer("pvpunitarioiva", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpunitarioiva2", this.iface.curLineaAlbaran));
		}
	}
	
	return true;
}

function ivaIncluido_totalesAlbaran():Boolean
{
	this.iface.__totalesAlbaran();

	// Comprobar redondeo y recalcular totales
	formRecordfacturascli.iface.comprobarRedondeoIVA(this.iface.curAlbaran, "idalbaran")
	with (this.iface.curAlbaran) {
		setValueBuffer("total", formpedidoscli.iface.pub_commonCalculateField("total", this));
		setValueBuffer("totaleuros", formpedidoscli.iface.pub_commonCalculateField("totaleuros", this));
	}
	return true;
}



//// IVAINCLUIDO /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////


/** @class_definition envioMail */
/////////////////////////////////////////////////////////////////
//// ENVIO_MAIL /////////////////////////////////////////////////
function envioMail_init()
{
	this.iface.__init();
	//this.child("tbnEnviarMail").close();
	connect(this.child("tbnEnviarMail"), "clicked()", this, "iface.enviarDocumento()");
}

function envioMail_enviarDocumento(codPedido:String, codCliente:String)
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	if (!codPedido) {
		codPedido = cursor.valueBuffer("codigo");
	}

	if (!codCliente) {
		codCliente = cursor.valueBuffer("codcliente");
	}
	var tabla:String = "clientes";
	var emailCliente:String = flfactppal.iface.pub_componerListaDestinatarios(codCliente, tabla);
	if (!emailCliente) {
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
	
	var numCopias:Number = util.sqlSelect("pedidoscli p INNER JOIN clientes c ON c.codcliente = p.codcliente", "c.copiasfactura", "p.codigo = '" + codigo + "'", "pedidoscli,clientes");
	if (!numCopias) {
		numCopias = 1;
	}
		
	var curImprimir:FLSqlCursor = new FLSqlCursor("i_pedidoscli");
	curImprimir.setModeAccess(curImprimir.Insert);
	curImprimir.refreshBuffer();
	curImprimir.setValueBuffer("descripcion", "temp");
	curImprimir.setValueBuffer("d_pedidoscli_codigo", codigo);
	curImprimir.setValueBuffer("h_pedidoscli_codigo", codigo);
	flfactinfo.iface.pub_lanzarInforme(curImprimir, "i_pedidoscli", "", "", false, false, "", "i_pedidoscli", numCopias, rutaDocumento, true);

	var arrayDest:Array = [];
	arrayDest[0] = [];
	arrayDest[0]["tipo"] = "to";
	arrayDest[0]["direccion"] = emailCliente;

	var arrayAttach:Array = [];
	arrayAttach[0] = rutaDocumento;

	flfactppal.iface.pub_enviarCorreo(cuerpo, asunto, arrayDest, arrayAttach);
}

function envioMail_imprimir(codPedido:String)
{
	var util:FLUtil = new FLUtil;
	
	var datosEMail:Array = [];
	datosEMail["tipoInforme"] = "pedidoscli";
	var codCliente:String;
	if (codPedido && codPedido != "") {
		datosEMail["codDestino"] = util.sqlSelect("pedidoscli", "codcliente", "codigo = '" + codPedido + "'");
		datosEMail["codDocumento"] = codPedido;
	} else {
		var cursor:FLSqlCursor = this.cursor();
		datosEMail["codDestino"] = cursor.valueBuffer("codcliente");
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

//// PEDIDOS_AUTO ///////////////////////////////////////////////
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

/** @class_definition batchDocs */
/////////////////////////////////////////////////////////////////
//// BATCH_DOCS /////////////////////////////////////////////////
function batchDocs_init()
{
	this.iface.__init();
		
	this.iface.pbnBatchPresupuestos = this.child("pbnBatchPresupuestos");
	connect(this.iface.pbnBatchPresupuestos, "clicked()", this, "iface.pbnBatchPresupuestos_clicked()");
}

/** \C
Al pulsar el botón de Batch de albaranes se abre la ventana de batch de albaranes de cliente
\end */
function batchDocs_pbnBatchPresupuestos_clicked()
{
	var f:Object = new FLFormSearchDB("agruparpresupuestoscli");
	var cursor:FLSqlCursor = f.cursor();
	var where:String;

	cursor.setActivatedCheckIntegrity(false);
	cursor.select();
	if (!cursor.first())
		cursor.setModeAccess(cursor.Insert);
	else
		cursor.setModeAccess(cursor.Edit);

	f.setMainWidget();
	cursor.refreshBuffer();
	var acpt:String = f.exec("codejercicio");
	if (acpt) {
		cursor.commitBuffer();
		var curAgruparPresupuestos:FLSqlCursor = new FLSqlCursor("agruparpresupuestoscli");
		curAgruparPresupuestos.select();
		if (curAgruparPresupuestos.first()) {
			where = this.iface.whereAgrupacion(curAgruparPresupuestos);
			var excepciones:String = curAgruparPresupuestos.valueBuffer("excepciones");
			if (!excepciones.isEmpty())
				where += " AND idpresupuesto NOT IN (" + excepciones + ")";

			var qryAgruparPresupuestos:FLSqlQuery = new FLSqlQuery;
			qryAgruparPresupuestos.setTablesList("presupuestoscli");
			qryAgruparPresupuestos.setSelect("idpresupuesto");
			qryAgruparPresupuestos.setFrom("presupuestoscli");
			qryAgruparPresupuestos.setWhere(where);

			if (!qryAgruparPresupuestos.exec())
				return;

			var curPresupuesto:FLSqlCursor = new FLSqlCursor("presupuestoscli");
			var wherePedido:String;
			while (qryAgruparPresupuestos.next()) {
				wherePedido = "idpresupuesto = " + qryAgruparPresupuestos.value(0);
				curPresupuesto.transaction(false);
				curPresupuesto.select(wherePedido);
				if (!curPresupuesto.first()) {
					curPresupuesto.rollback();
					return;
				}
				curPresupuesto.setValueBuffer("fecha", curAgruparPresupuestos.valueBuffer("fecha"));
				if (formpresupuestoscli.iface.pub_generarPedido(curPresupuesto)) {
					curPresupuesto.commit();
				} else {
					curPresupuesto.rollback();
					return;
				}
			}
		}

		f.close();
		this.iface.tdbRecords.refresh();
	}
}

/** \D
Construye la sentencia WHERE de la consulta que buscará los pedidos a agrupar
@param curAgrupar: Cursor de la tabla agruparpedidoscli que contiene los valores de los criterios de búsqueda
@return Sentencia where
\end */
function batchDocs_whereAgrupacion(curAgrupar:FLSqlCursor):String
{
	var codCliente:String = curAgrupar.valueBuffer("codcliente");
	var nombreCliente:String = curAgrupar.valueBuffer("nombrecliente");
	var cifNif:String = curAgrupar.valueBuffer("cifnif");
	var codAlmacen:String = curAgrupar.valueBuffer("codalmacen");
	var codPago:String = curAgrupar.valueBuffer("codpago");
	var codDivisa:String = curAgrupar.valueBuffer("coddivisa");
	var codSerie:String = curAgrupar.valueBuffer("codserie");
	var codEjercicio:String = curAgrupar.valueBuffer("codejercicio");
	var fechaDesde:String = curAgrupar.valueBuffer("fechadesde");
	var fechaHasta:String = curAgrupar.valueBuffer("fechahasta");
	var where:String = "editable = true";
	if (!codCliente.isEmpty())
		where += " AND codcliente = '" + codCliente + "'";
	if (!cifNif.isEmpty())
		where += " AND cifnif = '" + cifNif + "'";
	if (!codAlmacen.isEmpty())
		where = where + " AND codalmacen = '" + codAlmacen + "'";
	where = where + " AND fecha >= '" + fechaDesde + "'";
	where = where + " AND fecha <= '" + fechaHasta + "'";
	if (!codPago.isEmpty() != "")
		where = where + " AND codpago = '" + codPago + "'";
	if (!codDivisa.isEmpty())
		where = where + " AND coddivisa = '" + codDivisa + "'";
	if (!codSerie.isEmpty())
		where = where + " AND codserie = '" + codSerie + "'";
	if (!codEjercicio.isEmpty())
		where = where + " AND codejercicio = '" + codEjercicio + "'";
	return where;
}
//// BATCH_DOCS /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
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
		case "totaliva":{
			var porDto:Number = cursor.valueBuffer("pordtoesp");
			if (!porDto || porDto == 0) {
				valor = this.iface.__commonCalculateField(fN, cursor);
				break;
			}
			valor = util.sqlSelect("lineaspedidoscli", "SUM((pvptotal * iva * (100 - " + porDto + ")) / 100 / 100)", "idpedido = " + cursor.valueBuffer("idpedido"));
			valor = parseFloat(util.roundFieldValue(valor, "pedidoscli", "totaliva"));
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
			valor = util.sqlSelect("lineaspedidoscli", "SUM((pvptotal * recargo * (100 - " + porDto + ")) / 100 / 100)", "idpedido = " + cursor.valueBuffer("idpedido"));
			valor = parseFloat(util.roundFieldValue(valor, "pedidoscli", "totalrecargo"));
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
			valor = parseFloat(util.roundFieldValue(valor, "pedidoscli", "neto"));
			break;
		}
	/** \C
	El --dtoesp-- es el --netosindtoesp-- menos el porcentaje que marca el --pordtoesp--
	\end */
		case "dtoesp": {
			valor = (parseFloat(cursor.valueBuffer("netosindtoesp")) * parseFloat(cursor.valueBuffer("pordtoesp"))) / 100;
			valor = parseFloat(util.roundFieldValue(valor, "pedidoscli", "dtoesp"));
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
			valor = parseFloat(util.roundFieldValue(valor, "pedidoscli", "pordtoesp"));
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
function dtoEspecial_datosAlbaran(curPedido:FLSqlCursor,where:String,datosAgrupacion:Array):Boolean
{
	var util:FLUtil = new FLUtil();
	var porDtoEsp:Number = this.iface.buscarPorDtoEsp(where);
	if (porDtoEsp == -1) {
		MessageBox.critical(util.translate("scripts", "No es posible generar un único albarán para pedidos con distinto porcentaje de descuento especial"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	
	var fecha:String;
	if (curPedido.action() == "pedidoscli") {
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
		setValueBuffer("netosindtoesp", formalbaranescli.iface.pub_commonCalculateField("netosindtoesp", this));
		setValueBuffer("dtoesp", formalbaranescli.iface.pub_commonCalculateField("dtoesp", this));
		setValueBuffer("neto", formalbaranescli.iface.pub_commonCalculateField("neto", this));
		setValueBuffer("totaliva", formalbaranescli.iface.pub_commonCalculateField("totaliva", this));
		setValueBuffer("totalirpf", formalbaranescli.iface.pub_commonCalculateField("totalirpf", this));
		setValueBuffer("totalrecargo", formalbaranescli.iface.pub_commonCalculateField("totalrecargo", this));
		setValueBuffer("total", formalbaranescli.iface.pub_commonCalculateField("total", this));
		setValueBuffer("totaleuros", formalbaranescli.iface.pub_commonCalculateField("totaleuros", this));
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
	var porDtoEsp:Number = util.sqlSelect("pedidoscli", "pordtoesp", where);
	var porDtoEsp2:Number = util.sqlSelect("pedidoscli", "pordtoesp", where + " AND pordtoesp <> " + porDtoEsp);
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
////////////////////////////////////////////////////
