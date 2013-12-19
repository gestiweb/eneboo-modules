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
	function pub_generarAlbaran(where:String, cursor:FLSqlCursor, datosAgrupacion:Array):Number {
		return this.generarAlbaran(where, cursor, datosAgrupacion);
	}
	function pub_imprimir(codPedido:String) {
		return this.imprimir(codPedido);
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
	var pvpSinDto:Number = parseFloat(curLineaPedido.valueBuffer("pvpsindto")) * cantidad / parseFloat(curLineaPedido.valueBuffer("cantidad"));
	pvpSinDto = util.roundFieldValue(pvpSinDto, "lineasalbaranescli", "pvpsindto");
	
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
		setValueBuffer("pvpsindto", pvpSinDto);
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
							cantidadStock = 0;
							break;
						}
						case MessageBox.Ignore: {
							this.iface.ignorarAvisoStock_ = true;
							cantidadStock = 0;
							break;
						}
						default: {
							res["ok"] = false;
							return res;
						}
					}
				} else {
					cantidadStock = 0;
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

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
