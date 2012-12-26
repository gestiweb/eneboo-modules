/***************************************************************************
                 pedidosprov.qs  -  description
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
////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

/** @class_declaration interna */
//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
class interna {
    var ctx:Object;
    function interna( context ) { this.ctx = context; }
    function init() { this.ctx.interna_init(); }
	function calculateField(fN:String):String { return this.ctx.interna_calculateField(fN); }
	function validateForm():Boolean { return this.ctx.interna_validateForm(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    function oficial( context ) { interna( context ); } 
	function inicializarControles() {
		return this.ctx.oficial_inicializarControles();
	}
	function calcularTotales() {
		return this.ctx.oficial_calcularTotales();
	}
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function procesarEstadoLinea() {
		return this.ctx.oficial_procesarEstadoLinea();
	}
	function verificarHabilitaciones() {
		return this.ctx.oficial_verificarHabilitaciones();
	}
	function mostrarTraza() {
		return this.ctx.oficial_mostrarTraza();
	}
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration scab */
/////////////////////////////////////////////////////////////////
//// CONTROL STOCK CABECERA /////////////////////////////////////
class scab extends oficial {
	var arrayStocks_:Array;
    function scab( context ) { oficial ( context ); }
	function init() {
		return this.ctx.scab_init();
	}
	function validateForm():Boolean {
		return this.ctx.scab_validateForm();
	}
	function cargarArrayStocks():Boolean {
		return this.ctx.scab_cargarArrayStocks();
	}
	function controlStockCabecera():Boolean {
		return this.ctx.scab_controlStockCabecera();
	}
}
//// CONTROL STOCK CABECERA /////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pedProvCli */
/////////////////////////////////////////////////////////////////
//// PED_PROV_CLI ///////////////////////////////////////////////
class pedProvCli extends scab {
    function pedProvCli( context ) { scab ( context ); }
	function init() {
		return this.ctx.pedProvCli_init();
	}
	function tbnPedidosCli_clicked() {
		return this.ctx.pedProvCli_tbnPedidosCli_clicked();
	}
	function asociarPedidoCli(idPedidoCli:String, curPedidoProv:FLSqlCursor):Boolean {
		return this.ctx.pedProvCli_asociarPedidoCli(idPedidoCli, curPedidoProv);
	}
	function actualizarCodPedidoCli() {
		return this.ctx.pedProvCli_actualizarCodPedidoCli();
	}
}
//// PED_PROV_CLI ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration dtoEspecial */
/////////////////////////////////////////////////////////////////
//// DTO ESPECIAL ///////////////////////////////////////////////
class dtoEspecial extends pedProvCli {
    var bloqueoDto:Boolean;
    function dtoEspecial( context ) { pedProvCli ( context ); }
	function init() {
		return this.ctx.dtoEspecial_init();
	}
	function bufferChanged(fN:String) {
		return this.ctx.dtoEspecial_bufferChanged(fN);
	}
	function calcularTotales() {
		return this.ctx.dtoEspecial_calcularTotales();
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
Este formulario realiza la gestión de los pedidos a proveedores.

Los pedidos son generados de forma manual.
\end */
function interna_init()
{
		var util:FLUtil = new FLUtil();
		var cursor:FLSqlCursor = this.cursor();
		connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
		connect(this.child("tdbArticulosPedProv").cursor(), "bufferCommited()", this, "iface.calcularTotales()");
		connect(this.child("tdbArticulosPedProv").cursor(), "newBuffer()", this, "iface.procesarEstadoLinea");
		connect(this.child("tbnTraza"), "clicked()", this, "iface.mostrarTraza()");

		if (cursor.modeAccess() == cursor.Insert) {
				this.child("fdbCodEjercicio").setValue(flfactppal.iface.pub_ejercicioActual());
				this.child("fdbCodDivisa").setValue(flfactppal.iface.pub_valorDefectoEmpresa("coddivisa"));
				this.child("fdbCodPago").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codpago"));
				this.child("fdbCodAlmacen").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codalmacen"));
				this.child("fdbCodSerie").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codserie"));
				this.child("fdbTasaConv").setValue(util.sqlSelect("divisas", "tasaconv", "coddivisa = '" + this.child("fdbCodDivisa").value() + "'"));
		}
		if (cursor.modeAccess() == cursor.Edit)
			this.child("fdbCodSerie").setDisabled(true);
		this.iface.inicializarControles();
}

/** \U
Los valores de los campos de este formulario se calculan en el script asociado al formulario maestro
\end */
function interna_calculateField(fN:String):String
{
		var valor:String;
		var cursor:FLSqlCursor = this.cursor();
		switch (fN) {
				default: {
						valor = formpedidosprov.iface.pub_commonCalculateField(fN, cursor);
						break;
				}
		}
		return valor;
}

function interna_validateForm():Boolean
{
	var cursor:FLSqlCursor = this.cursor();

	var idPedido = cursor.valueBuffer("idPedido");
	if (!idPedido) {
		return false;
	}

	var codProveedor = this.child("fdbCodProveedor").value();
	if (!flfacturac.iface.pub_validarIvaRecargoProveedor(codProveedor,idPedido,"lineaspedidosprov","idpedido")) {
		return false;
	}

	/** \C
	Se establecerá el estado del pedido actual en función de si está No servido, Servido o Parcialmente servido
	\end */
	var estado:String = formRecordlineasalbaranesprov.iface.pub_obtenerEstadoPedido(cursor.valueBuffer("idpedido"));
	cursor.setValueBuffer("servido", estado);
	if (estado == "Sí") {
		cursor.setValueBuffer("editable", false);
	}

	return true;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_inicializarControles()
{
		this.child("lblRecFinanciero").setText(this.iface.calculateField("lblRecFinanciero"));
		this.iface.verificarHabilitaciones();
}

/** \U
Calcula los campos que son resultado de una suma de las líneas de pedido
\end */
function oficial_calcularTotales()
{
	this.child("fdbNeto").setValue(this.iface.calculateField("neto"));
	this.child("fdbTotalIva").setValue(this.iface.calculateField("totaliva"));
	this.child("fdbTotalRecargo").setValue(this.iface.calculateField("totalrecargo"));
	this.child("fdbTotaIrpf").setValue(this.iface.calculateField("totalirpf"));
	this.iface.verificarHabilitaciones();
}

function oficial_bufferChanged(fN:String)
{
		var cursor:FLSqlCursor = this.cursor();
		var util:FLUtil = new FLUtil();
		switch (fN) {
		/** \C
		El --total-- es el --neto-- más el --totaliva-- más el --totalrecargo-- más el --recfinanciero--
		*/
		case "recfinanciero":
		case "neto":{
			this.child("fdbTotaIrpf").setValue(this.iface.calculateField("totalirpf"));
		}
		case "totalrecargo":
		case "totalirpf":
		case "totaliva":{
						var total:String = this.iface.calculateField("total");
						this.child("fdbTotal").setValue(total);
						break;
				}
		/** \C
		El --totaleuros-- es el producto del --total-- por la --tasaconv--
		\end */
		case "total":
		case "tasaconv":{
						this.child("fdbTotalEuros").setValue(this.iface.calculateField("totaleuros"));
						break;
				}
		/** \C
		El --irpf-- es el asociado a la --codserie-- del albarán
		\end */
		case "codserie": {
						if (cursor.modeAccess() == cursor.Insert) {
						    this.cursor().setValueBuffer("irpf", this.iface.calculateField("irpf"));
						} else {
						    if (cursor.valueBuffer("codserie") != cursor.valueBufferCopy("codserie")) {
							cursor.setValueBuffer("codserie", cursor.valueBufferCopy("codserie"));
						    }
						}
						break;
				}
		/** \C
		El --totalirpf-- es el producto del --irpf-- por el --neto--
		\end */
		case "irpf": {
						this.child("fdbTotaIrpf").setValue(this.iface.calculateField("totalirpf"));
						break;
				}
		}
}

/** \U
Inhabilita el botón de borrar líneas si la línea tiene una línea de albarán asociada
\end */
function oficial_procesarEstadoLinea()
{
		var curLinea:FLSqlCursor = this.child("tdbArticulosPedProv").cursor();
		if (parseFloat(curLinea.valueBuffer("totalenalbaran")) > 0)
				this.child("toolButtonDelete").setEnabled(false);
		else
				this.child("toolButtonDelete").setEnabled(true);
}

/** \U
Verifica que los campos --codalmacen--, --coddivisa-- y ..tasaconv-- estén habilitados en caso de que el pedido no tenga líneas asociadas.
\end */
function oficial_verificarHabilitaciones()
{
		var util:FLUtil = new FLUtil();
		var idLinea:Number = util.sqlSelect("lineaspedidosprov", "idpedido", "idpedido = " + this.cursor().valueBuffer("idpedido"));
		if (!idLinea) {
				this.child("fdbCodAlmacen").setDisabled(false);
				this.child("fdbCodDivisa").setDisabled(false);
				this.child("fdbTasaConv").setDisabled(false);
		} else {
				this.child("fdbCodAlmacen").setDisabled(true);
				this.child("fdbCodDivisa").setDisabled(true);
				this.child("fdbTasaConv").setDisabled(true);
		}
}

function oficial_mostrarTraza()
{
	flfacturac.iface.pub_mostrarTraza(this.cursor().valueBuffer("codigo"), "pedidosprov");
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition scab */
/////////////////////////////////////////////////////////////////
//// CONTROL STOCK CABECERA /////////////////////////////////////
function scab_init()
{
	this.iface.__init();

	var util:FLUtil = new FLUtil;

	this.iface.arrayStocks_ = this.iface.cargarArrayStocks();
	if (!this.iface.arrayStocks_) {
		MessageBox.warning(util.translate("scripts", "Error al cargar los datos de stock"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
}

function scab_cargarArrayStocks():Array
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var arrayStocks:Array = [];

	var qryStocks:FLSqlQuery = new FLSqlQuery;
	qryStocks.setTablesList("pedidosprov,lineaspedidosprov");
	qryStocks.setSelect("lp.referencia, SUM(lp.cantidad)");
	qryStocks.setFrom("pedidosprov p INNER JOIN lineaspedidosprov lp ON p.idpedido = lp.idpedido");
	qryStocks.setWhere("p.idpedido = " + cursor.valueBuffer("idpedido") + " AND lp.referencia IS NOT NULL AND (lp.cerrada IS NULL OR lp.cerrada = false) GROUP BY p.codalmacen, lp.referencia");
	qryStocks.setForwardOnly(true);
	if (!qryStocks.exec()) {
		return false;
	}
	var i:Number = 0;
	while (qryStocks.next()) {
		arrayStocks[i] = [];
		arrayStocks[i]["idarticulo"] = qryStocks.value("lp.referencia");
		arrayStocks[i]["codalmacen"] = cursor.valueBuffer("codalmacen");
		arrayStocks[i]["cantidad"] = qryStocks.value("SUM(lp.cantidad)");
		i++;
	}
	return arrayStocks;
}

function scab_validateForm():Boolean
{
	if (!this.iface.__validateForm()) {
		return false;
	}

	if (!this.iface.controlStockCabecera()) {
		return false;
	}

	return true;
}

function scab_controlStockCabecera():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	var arrayActual:Array = this.iface.cargarArrayStocks();
	if (!arrayActual) {
		MessageBox.warning(util.translate("scripts", "Error al cargar los datos de stock"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var arrayAfectados:Array = flfactalma.iface.pub_arraySocksAfectados(this.iface.arrayStocks_, arrayActual);
	if (!arrayAfectados) {
		return false;
	}
	for (var i:Number = 0; i < arrayAfectados.length; i++) {
		if (!flfactalma.iface.pub_actualizarStockPteRecibir(arrayAfectados[i]["idarticulo"], arrayAfectados[i]["codalmacen"], -1)) {
			return false;
		}
	}

	return true;
}
//// CONTROL STOCK CABECERA /////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pedProvCli*/
/////////////////////////////////////////////////////////////////
//// PED_PROV_CLI ///////////////////////////////////////////////
function pedProvCli_init()
{
	this.iface.__init();
	connect(this.child("tbnPedidosCli"), "clicked()", this, "iface.tbnPedidosCli_clicked");
	this.iface.actualizarCodPedidoCli();
}

function pedProvCli_tbnPedidosCli_clicked()
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	
	if (cursor.modeAccess() == cursor.Insert) {
		var curLineas:FLSqlCursor = this.child("tdbArticulosPedProv").cursor();
		curLineas.setModeAccess(curLineas.Insert);
		if (!curLineas.commitBufferCursorRelation())
			return false;
	}
	
	var f:Object = new FLFormSearchDB("buscapedcli");
	var curPedidosCli:FLSqlCursor = f.cursor();
	
	curPedidosCli.setMainFilter(formpedidosprov.iface.filtroPedidosCli());
	f.setMainWidget();
	var idPedido:String = f.exec("idpedido");
	if (idPedido) {
	
		var codPedidoProv:String = util.sqlSelect("pedidoscli", "codpedidoprov", "idpedido = " + idPedido + " AND idpedidoprov <> " + this.cursor().valueBuffer("idpedido"));
		if (codPedidoProv) {
			res = MessageBox.warning(util.translate("scripts", "Este pedido de cliente ya se encuentra asociado al pedido de proveedor %0\n¿Desea continuar?").arg(codPedidoProv), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
			if (res != MessageBox.Yes)
				return false;
		}
	
		if (!this.iface.asociarPedidoCli(idPedido, cursor))
			return false;
	
		this.iface.actualizarCodPedidoCli();
	}
	
	this.iface.calcularTotales();
	this.child("tdbArticulosPedProv").refresh();
	
}

/** \D Asocia las líneas de un pedido de cliente a un pedido de proveedor
@param	idPedidoCli: Identificador del pedido de cliente
@param	curPedidoProv: Cursor posicionado sobre el pedido de proveedor
@return	true si la asociación se realiza de forma correcta, false si hay error
\end */
function pedProvCli_asociarPedidoCli(idPedidoCli:String, curPedidoProv:FLSqlCursor):Boolean
{
	
	
	if (!formpedidosprov.iface.pub_copiarLineasPedidoProvCli(idPedidoCli, curPedidoProv.valueBuffer("idpedido")))
		return false;

	if(!formpedidosprov.iface.pub_asociarPedidoProvCli(idPedidoCli,curPedidoProv.valueBuffer("idpedido")))
		return false;
	
		
	return true;
}

function pedProvCli_actualizarCodPedidoCli()
{
	var util:FLUtil = new FLUtil();

	var qryPedidos:FLSqlQuery = new FLSqlQuery();
	qryPedidos.setTablesList("pedidoscli,lineaspedidoscli,lineaspedidosprov");
	qryPedidos.setSelect("pc.codigo");
	qryPedidos.setFrom("pedidoscli pc INNER JOIN lineaspedidoscli lpc on pc.idpedido = lpc.idpedido INNER JOIN lineaspedidosprov lpp ON lpc.idlinea = lpp.idlineacli");
	qryPedidos.setWhere("lpp.idpedido = " + this.cursor().valueBuffer("idpedido"));

	if (!qryPedidos.exec())
		return false;

	var pedidos:String = "";
	while (qryPedidos.next()) {
		if(pedidos.find(qryPedidos.value("pc.codigo")) >= 0)
			continue;
		if(pedidos != "")
			pedidos += ", ";
		pedidos += qryPedidos.value("pc.codigo");
	}
	
	if (pedidos && pedidos != "")
		this.child("leCodPedidoCli").text = pedidos;
}

//// PED_PROV_CLI ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition dtoEspecial */
//////////////////////////////////////////////////////////////////
//// DTO ESPECIAL ////////////////////////////////////////////////
function dtoEspecial_bufferChanged(fN:String)
{
	switch (fN) {
		case "neto": {
			form.child("fdbTotalIva").setValue(this.iface.calculateField("totaliva"));
			form.child("fdbTotalRecargo").setValue(this.iface.calculateField("totalrecargo"));
			this.iface.__bufferChanged(fN);
			break;
		}
		/** \C
		El --neto-- es el producto del --netosindtoesp-- por el --pordtoesp--
		\end */
		case "netosindtoesp": {
			if (!this.iface.bloqueoDto) {
				this.iface.bloqueoDto = true;
				this.child("fdbDtoEsp").setValue(this.iface.calculateField("dtoesp"));
				this.iface.bloqueoDto = false;
			}
			break;
		}
		case "pordtoesp": {
			if (!this.iface.bloqueoDto) {
				this.iface.bloqueoDto = true;
				this.child("fdbDtoEsp").setValue(this.iface.calculateField("dtoesp"));
				this.iface.bloqueoDto = false;
			}
			break;
		}
		case "dtoesp": {
			if (!this.iface.bloqueoDto) {
				this.iface.bloqueoDto = true;
				this.child("fdbPorDtoEsp").setValue(this.iface.calculateField("pordtoesp"));
				this.iface.bloqueoDto = false;
			}
			this.child("fdbNeto").setValue(this.iface.calculateField("neto"));
			break;
		}
		default: {
			this.iface.__bufferChanged(fN);
			break;
		}
	}
}

function dtoEspecial_calcularTotales()
{
	this.child("fdbNetoSinDtoEsp").setValue(this.iface.calculateField("netosindtoesp"));
	this.iface.__calcularTotales();
}

function dtoEspecial_init()
{
	this.iface.__init();

	this.iface.bloqueoDto = false;
}
//// DTO ESPECIAL ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////
