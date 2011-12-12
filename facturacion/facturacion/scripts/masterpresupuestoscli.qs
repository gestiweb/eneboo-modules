/***************************************************************************
                 masterpresupuestoscli.qs  -  description
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
	var pbnGPedido:Object;
	var tdbRecords:FLTableDB;
	var tbnImprimir:Object;
	var tbnDuplicarPres:Object;
	var curPedido:FLSqlCursor;
	var curLineaPedido:FLSqlCursor;
	var curPresupuesto_:FLSqlCursor;
	var curLineaPres_:FLSqlCursor;

    function oficial( context ) { interna( context ); } 
	function imprimir(codPresupuesto:String) {
		return this.ctx.oficial_imprimir(codPresupuesto);
	}
	function procesarEstado() {
		return this.ctx.oficial_procesarEstado();
	}
	function pbnGenerarPedido_clicked() {
		return this.ctx.oficial_pbnGenerarPedido_clicked();
	}
	function generarPedido(cursor:FLSqlCursor, where:String):Number {
		return this.ctx.oficial_generarPedido(cursor, where);
	}
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.oficial_commonCalculateField(fN, cursor);
	}
	function copiaLineas(idPresupuesto:Number, idPedido:Number):Boolean {
		return this.ctx.oficial_copiaLineas(idPresupuesto, idPedido);
	}
	function copiaLineaPresupuesto(curLineaPresupuesto:FLSqlCursor, idPedido:Number):Number {
		return this.ctx.oficial_copiaLineaPresupuesto(curLineaPresupuesto, idPedido);
	}
	function totalesPedido():Boolean {
		return this.ctx.oficial_totalesPedido();
	}
	function datosPedido(curPresupuesto:FLSqlCursor):Boolean {
		return this.ctx.oficial_datosPedido(curPresupuesto);
	}
	function datosLineaPedido(curLineaPresupuesto:FLSqlCursor):Boolean {
		return this.ctx.oficial_datosLineaPedido(curLineaPresupuesto);
	}
	function duplicarPresupuesto_clicked() {
		return this.ctx.oficial_duplicarPresupuesto_clicked();
	}
	function duplicarPresupuesto(curOrigen:FLSqlCursor):String {
		return this.ctx.oficial_duplicarPresupuesto(curOrigen);
	}
	function copiarCampoPresupuesto(nombreCampo:String, cursor:FLSqlCursor, campoInformado:Array):Boolean {
		return this.ctx.oficial_copiarCampoPresupuesto(nombreCampo, cursor, campoInformado);
	}
	function duplicarHijosPresupuesto(idPresOrigen:String, idPresDestino:String):Boolean {
		return this.ctx.oficial_duplicarHijosPresupuesto(idPresOrigen, idPresDestino);
	}
	function duplicarLineasPresupuesto(idPresOrigen:String, idPresDestino:String):String {
		return this.ctx.oficial_duplicarLineasPresupuesto(idPresOrigen, idPresDestino);
	}
	function copiarCampoLineaPresupuesto(nombreCampo:String, cursor:FLSqlCursor, campoInformado:Array):Boolean {
		return this.ctx.oficial_copiarCampoLineaPresupuesto(nombreCampo, cursor, campoInformado);
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
	function datosLineaPedido(curLineaPresupuesto:FLSqlCursor):Boolean {
		return this.ctx.ivaIncluido_datosLineaPedido(curLineaPresupuesto);
	}
	function totalesPedido():Boolean {
		return this.ctx.ivaIncluido_totalesPedido();
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
	function enviarDocumento(codPresupuesto:String, codCliente:String) {
		return this.ctx.envioMail_enviarDocumento(codPresupuesto, codCliente);
	}
	function imprimir(codPresupuesto:String) {
		return this.ctx.envioMail_imprimir(codPresupuesto);
	}
}

//// ENVIO_MAIL ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration rappel */
/////////////////////////////////////////////////////////////////
//// RAPPEL /////////////////////////////////////////////////////
class rappel extends envioMail {
    function rappel( context ) { envioMail ( context ); }
	function datosLineaPedido(curLineaPresupuesto:FLSqlCursor):Boolean {
		return this.ctx.rappel_datosLineaPedido(curLineaPresupuesto);
	}
}
//// RAPPEL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration clientesPot */
/////////////////////////////////////////////////////////////////
//// CLIENTESPOT //////////////////////////////////////////////////
class clientesPot extends rappel {
	function clientesPot( context ) { rappel ( context ); }
	function generarPedido(cursor:FLSqlCursor):Number {
		return this.ctx.clientesPot_generarPedido(cursor);
	}
}
//// CLIENTESPOT //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration dtoEspecial */
/////////////////////////////////////////////////////////////////
//// DTO ESPECIAL ///////////////////////////////////////////////
class dtoEspecial extends clientesPot {
    function dtoEspecial( context ) { clientesPot ( context ); }
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.dtoEspecial_commonCalculateField(fN, cursor);
	}
	function totalesPedido():Boolean {
		return this.ctx.dtoEspecial_totalesPedido();
	}
	function datosPedido(curPresupuesto:FLSqlCursor):Boolean {
		return this.ctx.dtoEspecial_datosPedido(curPresupuesto);
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
	function pub_enviarDocumento(codPresupuesto:String, codCliente:String) {
		return this.enviarDocumento(codPresupuesto, codCliente);
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
	function pub_imprimir(codPresupuesto:String) {
		return this.imprimir(codPresupuesto);
	}
	function pub_generarPedido(cursor:FLSqlCursor, where:String):Number {
		return this.generarPedido(cursor, where);
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
}
//// PUB_BATCH_DOCS /////////////////////////////////////////////
//////////////////////////////////////////////////////////////
/** @class_definition interna */
////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
/** \C
Este es el formulario maestro de presupuestos a cliente.
\end */
function interna_init()
{
	this.iface.pbnGPedido = this.child("pbnGenerarPedido");
	this.iface.tdbRecords= this.child("tableDBRecords");
	this.iface.tbnImprimir = this.child("toolButtonPrint");
	this.iface.tbnDuplicarPres = this.child("tbnDuplicarPres");

	connect(this.iface.pbnGPedido, "clicked()", this, "iface.pbnGenerarPedido_clicked");
	connect(this.iface.tdbRecords, "currentChanged()", this, "iface.procesarEstado");
	connect(this.iface.tbnImprimir, "clicked()", this, "iface.imprimir");
	connect(this.iface.tbnDuplicarPres, "clicked()", this, "iface.duplicarPresupuesto_clicked");

	this.iface.filtrarTabla();
	this.iface.procesarEstado();
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \C
Al pulsar el botón imprimir se lanzará el informe correspondiente al presupuesto seleccionado (en caso de que el módulo de informes esté cargado)
\end */
function oficial_imprimir(codPresupuesto:String)
{
	if (sys.isLoadedModule("flfactinfo")) {
		
		var codigo:String;
		if (codPresupuesto) {
			codigo = codPresupuesto;
		} else {
			if (!this.cursor().isValid())
				return;
			codigo = this.cursor().valueBuffer("codigo");
		}
		var curImprimir:FLSqlCursor = new FLSqlCursor("i_presupuestoscli");
		curImprimir.setModeAccess(curImprimir.Insert);
		curImprimir.refreshBuffer();
		curImprimir.setValueBuffer("descripcion", "temp");
		curImprimir.setValueBuffer("d_presupuestoscli_codigo", codigo);
		curImprimir.setValueBuffer("h_presupuestoscli_codigo", codigo);
		flfactinfo.iface.pub_lanzarInforme(curImprimir, "i_presupuestoscli");
		return;
	}

	var tipoDoc:String = "presupuestoscli";
	var f:Object = new FLFormSearchDB("facturas_imp");
	var cursor:FLSqlCursor = f.cursor();

	cursor.setActivatedCheckIntegrity(false);
	cursor.select();
	if (!cursor.first())
		cursor.setModeAccess(cursor.Insert);
	else
		cursor.setModeAccess(cursor.Edit);

	f.setMainWidget();
	cursor.refreshBuffer();
	var acpt:String = f.exec("desde");
	if (acpt) {
		cursor.commitBuffer();
		var q:FLSqlQuery = new FLSqlQuery(tipoDoc);
		q.setValueParam("from", cursor.valueBuffer("desde"));
		q.setValueParam("to", cursor.valueBuffer("hasta"));
		var rptViewer = new FLReportViewer();
		rptViewer.setReportTemplate(tipoDoc);
		rptViewer.setReportData(q);
		rptViewer.renderReport();
		rptViewer.exec();
		f.close();
	}
}

function oficial_procesarEstado()
{
		var cursor:FLSqlCursor = this.cursor();
		if (cursor.valueBuffer("editable") == false)
				this.iface.pbnGPedido.setEnabled(false);
		else
				this.iface.pbnGPedido.setEnabled(true);
}

/** \C
Al pulsar el botón de generar pedido se creará el albarán correspondiente al presupuesto seleccionado.
\end */
function oficial_pbnGenerarPedido_clicked()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	if (cursor.valueBuffer("editable") == false) {
		MessageBox.warning(util.translate("scripts", "El presupuesto ya está aprobado"), MessageBox.Ok, MessageBox.NoButton);
		this.iface.procesarEstado();
		return;
	}
	this.iface.pbnGPedido.setEnabled(false);

	cursor.transaction(false);
	try {
		if (this.iface.generarPedido(cursor))
			cursor.commit();
		else
			cursor.rollback();
	}
	catch (e) {
		cursor.rollback();
		MessageBox.critical(util.translate("scripts", "Hubo un error en la generación del pedido:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
	}
	this.iface.tdbRecords.refresh();
	this.iface.procesarEstado();
}

/** \D
Genera el pedido asociado a un presupuesto
@param cursor: Cursor con los datos principales que se copiarán del presupuesto al pedido
@return True: Copia realizada con éxito, False: Error
\end */
function oficial_generarPedido(curPresupuesto:FLSqlCursor, where:String):Number
{
	if (!this.iface.curPedido)
		this.iface.curPedido = new FLSqlCursor("pedidoscli");
	
	var idPresupuesto:String = curPresupuesto.valueBuffer("idpresupuesto");
	
	this.iface.curPedido.setModeAccess(this.iface.curPedido.Insert);
	this.iface.curPedido.refreshBuffer();
	this.iface.curPedido.setValueBuffer("idpresupuesto", idPresupuesto);
	
	if (!this.iface.datosPedido(curPresupuesto))
		return false;
	
	if (!this.iface.curPedido.commitBuffer())
		return false;
	
	var idPedido:Number = this.iface.curPedido.valueBuffer("idpedido");
	var curPresupuestos:FLSqlCursor = new FLSqlCursor("presupuestoscli");
	curPresupuestos.select("idpresupuesto = " + idPresupuesto);
	if (!curPresupuestos.first())
		return false;
	
	curPresupuestos.setModeAccess(curPresupuestos.Edit);
	curPresupuestos.refreshBuffer();
	if (!this.iface.copiaLineas(idPresupuesto, idPedido))
		return false;
	curPresupuestos.setValueBuffer("editable", false);
	if (!curPresupuestos.commitBuffer())
		return false;
	
	this.iface.curPedido.select("idpedido = " + idPedido);
	if (this.iface.curPedido.first()) {
		this.iface.curPedido.setModeAccess(this.iface.curPedido.Edit);
		this.iface.curPedido.refreshBuffer();
		this.iface.curPedido.setValueBuffer("idpresupuesto", idPresupuesto);
		
		if (!this.iface.totalesPedido())
			return false;
		
		if (this.iface.curPedido.commitBuffer() == false)
			return false;
	}
	return idPedido;
}

/** \D Informa los datos de un pedido a partir de los de un presupuesto
@param	curPresupuesto: Cursor que contiene los datos a incluir en el pedido
@return	True si el cálculo se realiza correctamente, false en caso contrario
\end */
function oficial_datosPedido(curPresupuesto:FLSqlCursor):Boolean
{
	var fecha:String;
	if (curPresupuesto.action() == "presupuestoscli") {
		var hoy:Date = new Date();
		fecha = hoy.toString();
	} else
		fecha = curPresupuesto.valueBuffer("fecha");
	
	var codEjercicio:String = curPresupuesto.valueBuffer("codejercicio");
	var datosDoc:Array = flfacturac.iface.pub_datosDocFacturacion(fecha, codEjercicio, "pedidoscli");
	if (!datosDoc.ok)
		return false;
	if (datosDoc.modificaciones == true) {
		codEjercicio = datosDoc.codEjercicio;
		fecha = datosDoc.fecha;
	}
	
	var codDir:Number = curPresupuesto.valueBuffer("coddir");
	with (this.iface.curPedido) {
		setValueBuffer("codserie", curPresupuesto.valueBuffer("codserie"));
		setValueBuffer("codejercicio", codEjercicio);
		setValueBuffer("irpf", curPresupuesto.valueBuffer("irpf"));
		setValueBuffer("fecha", fecha);
		setValueBuffer("codagente", curPresupuesto.valueBuffer("codagente"));
		setValueBuffer("porcomision", curPresupuesto.valueBuffer("porcomision"));
		setValueBuffer("codalmacen", curPresupuesto.valueBuffer("codalmacen"));
		setValueBuffer("codpago", curPresupuesto.valueBuffer("codpago"));
		setValueBuffer("coddivisa", curPresupuesto.valueBuffer("coddivisa"));
		setValueBuffer("tasaconv", curPresupuesto.valueBuffer("tasaconv"));
		setValueBuffer("codcliente", curPresupuesto.valueBuffer("codcliente"));
		setValueBuffer("cifnif", curPresupuesto.valueBuffer("cifnif"));
		setValueBuffer("nombrecliente", curPresupuesto.valueBuffer("nombrecliente"));
		if (codDir == 0)
			setNull("coddir");
		else
			setValueBuffer("coddir", codDir);
		setValueBuffer("direccion", curPresupuesto.valueBuffer("direccion"));
		setValueBuffer("codpostal", curPresupuesto.valueBuffer("codpostal"));
		setValueBuffer("ciudad", curPresupuesto.valueBuffer("ciudad"));
		setValueBuffer("provincia", curPresupuesto.valueBuffer("provincia"));
		setValueBuffer("apartado", curPresupuesto.valueBuffer("apartado"));
		setValueBuffer("codpais", curPresupuesto.valueBuffer("codpais"));
		setValueBuffer("recfinanciero", curPresupuesto.valueBuffer("recfinanciero"));
		setValueBuffer("fechasalida", curPresupuesto.valueBuffer("fechasalida"));
		setValueBuffer("observaciones", curPresupuesto.valueBuffer("observaciones"));
	}
	
	return true;
}

/** \D Informa los datos de un pedido referentes a totales (I.V.A., neto, etc.)
@return	True si el cálculo se realiza correctamente, false en caso contrario
\end */
function oficial_totalesPedido():Boolean
{
	with (this.iface.curPedido) {
		setValueBuffer("neto", formpedidoscli.iface.pub_commonCalculateField("neto", this));
		setValueBuffer("totaliva", formpedidoscli.iface.pub_commonCalculateField("totaliva", this));
		setValueBuffer("totalirpf", formpedidoscli.iface.pub_commonCalculateField("totalirpf", this));
		setValueBuffer("totalrecargo", formpedidoscli.iface.pub_commonCalculateField("totalrecargo", this));
		setValueBuffer("total", formpedidoscli.iface.pub_commonCalculateField("total", this));
		setValueBuffer("totaleuros", formpedidoscli.iface.pub_commonCalculateField("totaleuros", this));
	}
	return true;
}


function oficial_commonCalculateField(fN:String, cursor:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil();
	var valor:String;

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
			var neto:Number = parseFloat(cursor.valueBuffer("neto"));
			var totalIrpf:Number = parseFloat(cursor.valueBuffer("totalirpf"));
			var totalIva:Number = parseFloat(cursor.valueBuffer("totaliva"));
			var totalRecargo:Number = parseFloat(cursor.valueBuffer("totalrecargo"));
			var recFinanciero:Number = (parseFloat(cursor.valueBuffer("recfinanciero")) * neto) / 100;
			recFinanciero = parseFloat(util.roundFieldValue(recFinanciero, "presupuestoscli", "total"));
			valor = neto - totalIrpf + totalIva + totalRecargo + recFinanciero;
			valor = parseFloat(util.roundFieldValue(valor, "presupuestoscli", "total"));
			break;
		}
		case "lblComision": {
			valor = (parseFloat(cursor.valueBuffer("porcomision")) * (parseFloat(cursor.valueBuffer("neto")))) / 100;
			valor = parseFloat(util.roundFieldValue(valor, "presupuestoscli", "total"));
			break;
		}
		case "lblRecFinanciero": {
			valor = (parseFloat(cursor.valueBuffer("recfinanciero")) * (parseFloat(cursor.valueBuffer("neto")))) / 100;
			valor = parseFloat(util.roundFieldValue(valor, "presupuestoscli", "total"));
			break;
		}
		/** \C
		El --totaleuros-- es el producto del --total-- por la --tasaconv--
		\end */
		case "totaleuros": {
			var total:Number = parseFloat(cursor.valueBuffer("total"));
			var tasaConv:Number = parseFloat(cursor.valueBuffer("tasaconv"));
			valor = total * tasaConv;
			valor = parseFloat(util.roundFieldValue(valor, "presupuestoscli", "totaleuros"));
			break;
		}
		/** \C
		El --neto-- es la suma del pvp total de las líneas de factura
		\end */
		case "neto": {
			valor = util.sqlSelect("lineaspresupuestoscli", "SUM(pvptotal)", "idpresupuesto = " + cursor.valueBuffer("idpresupuesto"));
			valor = parseFloat(util.roundFieldValue(valor, "presupuestoscli", "neto"));
			break;
		}
		/** \C
		El --totaliva-- es la suma del iva correspondiente a las líneas de factura
		\end */
		case "totaliva": {
			var codCli:String = cursor.valueBuffer("codcliente");
			var regIva:String = flfacturac.iface.pub_regimenIVACliente(cursor);
			if(regIva == "U.E." || regIva == "Exento" || regIva == "Exportaciones"){
				valor = 0;
				break;
			}
			valor = util.sqlSelect("lineaspresupuestoscli", "SUM((pvptotal * iva) / 100)", "idpresupuesto = " + cursor.valueBuffer("idpresupuesto"));
			valor = parseFloat(util.roundFieldValue(valor, "presupuestoscli", "totaliva"));
			break;
		}
		/** \C
		El --totarecargo-- es la suma del recargo correspondiente a las líneas de factura
		\end */
		case "totalrecargo": {
			var codCli:String = cursor.valueBuffer("codcliente");
			var regIva:String =flfacturac.iface.pub_regimenIVACliente(cursor);
			if(regIva == "U.E." || regIva == "Exento" || regIva == "Exportaciones"){
				valor = 0;
				break;
			}
			valor = util.sqlSelect("lineaspresupuestoscli", "SUM((pvptotal * recargo) / 100)", "idpresupuesto = " + cursor.valueBuffer("idpresupuesto"));
			valor = parseFloat(util.roundFieldValue(valor, "presupuestoscli", "totalrecargo"));
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
			valor = util.sqlSelect("lineaspresupuestoscli", "SUM((pvptotal * irpf) / 100)", "idpresupuesto = " + cursor.valueBuffer("idpresupuesto"));
// 			valor = (parseFloat(cursor.valueBuffer("irpf")) * (parseFloat(cursor.valueBuffer("neto")))) / 100;
			valor = parseFloat(util.roundFieldValue(valor, "presupuestoscli", "totalirpf"));
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
@param idPresupuesto: Identificador del pedido
@param idPedido: Identificador del pedido
\end */
function oficial_copiaLineas(idPresupuesto:Number, idPedido:Number):Boolean
{
	var curLineaPresupuesto:FLSqlCursor = new FLSqlCursor("lineaspresupuestoscli");
	curLineaPresupuesto.select("idpresupuesto = " + idPresupuesto);
	while (curLineaPresupuesto.next()) {
		curLineaPresupuesto.setModeAccess(curLineaPresupuesto.Browse);
		curLineaPresupuesto.refreshBuffer();
		if (!this.iface.copiaLineaPresupuesto(curLineaPresupuesto, idPedido))
			return false;
	}
	return true;
}

function oficial_copiaLineaPresupuesto(curLineaPresupuesto:FLSqlCursor, idPedido:Number):Number
{
	if (!this.iface.curLineaPedido)
		this.iface.curLineaPedido = new FLSqlCursor("lineaspedidoscli");
	
	with (this.iface.curLineaPedido) {
		setModeAccess(Insert);
		refreshBuffer();
		setValueBuffer("idpedido", idPedido);
	}
	
	if (!this.iface.datosLineaPedido(curLineaPresupuesto))
		return false;
		
	if (!this.iface.curLineaPedido.commitBuffer())
		return false;
	
	return this.iface.curLineaPedido.valueBuffer("idlinea");
}

/** \D Copia los datos de una línea de presupuesto en una línea de pedido
@param	curLineaPresupuesto: Cursor que contiene los datos a incluir en la línea de pedido
@return	True si la copia se realiza correctamente, false en caso contrario
\end */
function oficial_datosLineaPedido(curLineaPresupuesto:FLSqlCursor):Boolean
{
	var iva:Number, recargo:Number;
	var codImpuesto:String = curLineaPresupuesto.valueBuffer("codimpuesto");

	with (this.iface.curLineaPedido) {
		setValueBuffer("idlineapresupuesto", curLineaPresupuesto.valueBuffer("idlinea"));
		setValueBuffer("pvpunitario", curLineaPresupuesto.valueBuffer("pvpunitario"));
		setValueBuffer("pvpsindto", curLineaPresupuesto.valueBuffer("pvpsindto"));
		setValueBuffer("pvptotal", curLineaPresupuesto.valueBuffer("pvptotal"));
		setValueBuffer("cantidad", curLineaPresupuesto.valueBuffer("cantidad"));
		setValueBuffer("referencia", curLineaPresupuesto.valueBuffer("referencia"));
		setValueBuffer("descripcion", curLineaPresupuesto.valueBuffer("descripcion"));
		setValueBuffer("codimpuesto", codImpuesto);
		if (curLineaPresupuesto.isNull("iva")) {
			setNull("iva");
		} else {
			iva = curLineaPresupuesto.valueBuffer("iva");
			if (iva != 0 && codImpuesto && codImpuesto != "") {
				iva = formRecordlineaspedidoscli.iface.pub_commonCalculateField("iva", this); /// Para cambio de IVA según fechas
			}
			setValueBuffer("iva", iva);
		}
		if (curLineaPresupuesto.isNull("recargo")) {
			setNull("recargo");
		} else {
			recargo = curLineaPresupuesto.valueBuffer("recargo");
			if (recargo != 0 && codImpuesto && codImpuesto != "") {
				recargo = formRecordlineaspedidoscli.iface.pub_commonCalculateField("recargo", this); /// Para cambio de IVA según fechas
			}
			setValueBuffer("recargo", recargo);
		}
		setValueBuffer("irpf", curLineaPresupuesto.valueBuffer("irpf"));
		setValueBuffer("dtolineal", curLineaPresupuesto.valueBuffer("dtolineal"));
		setValueBuffer("dtopor", curLineaPresupuesto.valueBuffer("dtopor"));
		setValueBuffer("porcomision", curLineaPresupuesto.valueBuffer("porcomision"));
	}
	return true;
}

function oficial_duplicarPresupuesto_clicked() 
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var codPresupuesto:String;
	cursor.transaction(false);
	try {
		codPresupuesto = this.iface.duplicarPresupuesto(cursor);
		if (codPresupuesto) {
			cursor.commit();
			MessageBox.information(util.translate("scripts", "Se ha copiado el presupuesto %1 con código %2").arg(cursor.valueBuffer("codigo")).arg(codPresupuesto), MessageBox.Ok, MessageBox.NoButton);
			this.iface.tdbRecords.refresh();
		} else {
			cursor.rollback();
		}
	}
	catch (e) {
		cursor.rollback();
		MessageBox.critical(util.translate("scripts", "Hubo un error en la copia del presupuesto:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
	}
}


function oficial_duplicarPresupuesto(curOrigen:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil;

	if (!this.iface.curPresupuesto_) {
		this.iface.curPresupuesto_ = new FLSqlCursor("presupuestoscli");
	}
	this.iface.curPresupuesto_.setModeAccess(this.iface.curPresupuesto_.Insert);
	this.iface.curPresupuesto_.refreshBuffer();

	var campos:Array = util.nombreCampos("presupuestoscli");
	var totalCampos:Number = campos[0];

	var campoInformado:Array = [];
	for (var i:Number = 1; i <= totalCampos; i++) {
		campoInformado[campos[i]] = false;
	}
	for (var i:Number = 1; i <= totalCampos; i++) {
		if (!this.iface.copiarCampoPresupuesto(campos[i], curOrigen, campoInformado)) {
			return false;
		}
	}
	if (!this.iface.curPresupuesto_.commitBuffer()) {
		return false;
	}
	var idPresDestino:String = this.iface.curPresupuesto_.valueBuffer("idpresupuesto");
	if (!this.iface.duplicarHijosPresupuesto(curOrigen.valueBuffer("idpresupuesto"), idPresDestino)) {
		return false;
	}
	var codPresupuesto:String = this.iface.curPresupuesto_.valueBuffer("codigo");
	return codPresupuesto;
}

function oficial_copiarCampoPresupuesto(nombreCampo:String, cursor:FLSqlCursor, campoInformado:Array):Boolean
{
	if (campoInformado[nombreCampo]) {
		return true;
	}
	var nulo:Boolean =false;

	var cursor:FLSqlCursor = this.cursor();
	switch (nombreCampo) {
		case "idpresupuesto": {
			return true;
			break;
		}
		case "numero": {
			return true;
			break;
		}
		case "editable": {
			valor = true;
			break;
		}
		case "codejercicio": {
			valor = flfactppal.iface.pub_ejercicioActual();
			break;
		}
		case "fecha": {
			var hoy:Date = new Date();
			valor = hoy;
			break;
		}
		default: {
			if (cursor.isNull(nombreCampo)) {
				nulo = true;
			} else {
				valor = cursor.valueBuffer(nombreCampo);
			}
		}
	}
	if (nulo) {
		this.iface.curPresupuesto_.setNull(nombreCampo);
	} else {
		this.iface.curPresupuesto_.setValueBuffer(nombreCampo, valor);
	}
	campoInformado[nombreCampo] = true;
	
	return true;
}

function oficial_duplicarHijosPresupuesto(idPresOrigen:String, idPresDestino:String):Boolean
{
	if (!this.iface.duplicarLineasPresupuesto(idPresOrigen, idPresDestino)) {
		return false;
	}
	return true;
}

function oficial_duplicarLineasPresupuesto(idPresOrigen:String, idPresDestino:String):String
{
	var util:FLUtil = new FLUtil;

	if (!this.iface.curLineaPres_) {
		this.iface.curLineaPres_ = new FLSqlCursor("lineaspresupuestoscli");
	}
	
	var campos:Array = util.nombreCampos("lineaspresupuestoscli");
	var totalCampos:Number = campos[0];

	var campoInformado:Array = [];
	
	var curLineaOrigen:FLSqlCursor = new FLSqlCursor("lineaspresupuestoscli");
	curLineaOrigen.select("idpresupuesto = " + idPresOrigen);
	while (curLineaOrigen.next()) {
		for (var i:Number = 1; i <= totalCampos; i++) {
			campoInformado[campos[i]] = false;
		}
		this.iface.curLineaPres_.setModeAccess(this.iface.curLineaPres_.Insert);
		this.iface.curLineaPres_.refreshBuffer();
		this.iface.curLineaPres_.setValueBuffer("idpresupuesto", idPresDestino);

		for (var i:Number = 1; i <= totalCampos; i++) {
			if (!this.iface.copiarCampoLineaPresupuesto(campos[i], curLineaOrigen, campoInformado)) {
				return false;
			}
		}
		if (!this.iface.curLineaPres_.commitBuffer()) {
			return false;
		}
	}
	return true;
}

function oficial_copiarCampoLineaPresupuesto(nombreCampo:String, curLineaOrigen:FLSqlCursor, campoInformado:Array):Boolean
{
	if (campoInformado[nombreCampo]) {
		return true;
	}
	var nulo:Boolean =false;

	switch (nombreCampo) {
		case "idlinea":
		case "idpresupuesto": {
			return true;
			break;
		}
		case "iva": {
			if (!campoInformado["codimpuesto"]) {
				if (!this.iface.copiarCampoLineaPresupuesto("codimpuesto", curLineaOrigen, campoInformado)) {
					return false;
				}
			}
			if (curLineaOrigen.isNull("iva")) {
				nulo = true;
			} else {
				valor = curLineaOrigen.valueBuffer("iva");
				var codImpuesto:String = curLineaOrigen.valueBuffer("codimpuesto");
				if (valor != 0 && codImpuesto && codImpuesto != "") {
					valor = formRecordlineaspedidoscli.iface.pub_commonCalculateField("iva", this.iface.curLineaPres_); /// Para cambio de IVA según fechas
				}
			}
			break;
		}
		case "recargo": {
			if (!campoInformado["codimpuesto"]) {
				if (!this.iface.copiarCampoLineaPresupuesto("codimpuesto", curLineaOrigen, campoInformado)) {
					return false;
				}
			}
			if (curLineaOrigen.isNull("recargo")) {
				nulo = true;
			} else {
				valor = curLineaOrigen.valueBuffer("recargo");
				var codImpuesto:String = curLineaOrigen.valueBuffer("codimpuesto");
				if (valor != 0 && codImpuesto && codImpuesto != "") {
					valor = formRecordlineaspedidoscli.iface.pub_commonCalculateField("recargo", this.iface.curLineaPres_); /// Para cambio de IVA según fechas
				}
			}
			break;
		}
		default: {
			if (curLineaOrigen.isNull(nombreCampo)) {
				nulo = true;
			} else {
				valor = curLineaOrigen.valueBuffer(nombreCampo);
			}
		}
	}
	if (nulo) {
		this.iface.curLineaPres_.setNull(nombreCampo);
	} else {
		this.iface.curLineaPres_.setValueBuffer(nombreCampo, valor);
	}
	campoInformado[nombreCampo] = true;
	
	return true;
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
/** \D Copia los datos de una línea de presupuesto en una línea de pedido
@param	curLineaPresupuesto: Cursor que contiene los datos a incluir en la línea de pedido
@return	True si la copia se realiza correctamente, false en caso contrario
\end */
function ivaIncluido_datosLineaPedido(curLineaPresupuesto:FLSqlCursor):Boolean
{
	if (!this.iface.__datosLineaPedido(curLineaPresupuesto)) {
		return false;
	}
	with (this.iface.curLineaPedido) {
		setValueBuffer("ivaincluido", curLineaPresupuesto.valueBuffer("ivaincluido"));
		setValueBuffer("pvpunitarioiva", curLineaPresupuesto.valueBuffer("pvpunitarioiva"));
	}
	/// El cambio puede deberse a que la fecha del nuevo documento esté asociada a un tipo de IVA distinto del documento origens
	if (curLineaPresupuesto.valueBuffer("iva") != this.iface.curLineaPedido.valueBuffer("iva")) {
		if (this.iface.curLineaPedido.valueBuffer("ivaincluido")) {
			this.iface.curLineaPedido.setValueBuffer("pvpunitario", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpunitario2", this.iface.curLineaPedido));
			this.iface.curLineaPedido.setValueBuffer("pvpsindto", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpsindto", this.iface.curLineaPedido));
			this.iface.curLineaPedido.setValueBuffer("pvptotal", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotal", this.iface.curLineaPedido));
		}
	}
	
	return true;
}

function ivaIncluido_totalesPedido():Boolean
{
	this.iface.__totalesPedido();

	// Comprobar redondeo y recalcular totales
	formRecordfacturascli.iface.comprobarRedondeoIVA(this.iface.curPedido, "idpedido")
	with (this.iface.curPedido) {
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

function envioMail_enviarDocumento(codPresupuesto:String, codCliente:String)
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	if (!codPresupuesto) {
		codPresupuesto = cursor.valueBuffer("codigo");
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
	var asunto:String = util.translate("scripts", "Presupuesto %1").arg(codPresupuesto);

	var rutaDocumento:String = rutaIntermedia + "Pr_" + codPresupuesto + ".pdf";
	var codigo:String;
	if (codPresupuesto) {
		codigo = codPresupuesto;
	} else {
		if (!cursor.isValid()) {
			return;
		}
		codigo = cursor.valueBuffer("codigo");
	}
	var numCopias:Number = util.sqlSelect("presupuestoscli p INNER JOIN clientes c ON c.codcliente = p.codcliente", "c.copiasfactura", "p.codigo = '" + codigo + "'", "presupuestoscli,clientes");
	if (!numCopias) {
		numCopias = 1;
	}
		
	var curImprimir:FLSqlCursor = new FLSqlCursor("i_presupuestoscli");
	curImprimir.setModeAccess(curImprimir.Insert);
	curImprimir.refreshBuffer();
	curImprimir.setValueBuffer("descripcion", "temp");
	curImprimir.setValueBuffer("d_presupuestoscli_codigo", codigo);
	curImprimir.setValueBuffer("h_presupuestoscli_codigo", codigo);
	flfactinfo.iface.pub_lanzarInforme(curImprimir, "i_presupuestoscli", "", "", false, false, "", "i_presupuestoscli", 1, rutaDocumento, true);

	var arrayDest:Array = [];
	arrayDest[0] = [];
	arrayDest[0]["tipo"] = "to";
	arrayDest[0]["direccion"] = emailCliente;

	var arrayAttach:Array = [];
	arrayAttach[0] = rutaDocumento;

	flfactppal.iface.pub_enviarCorreo(cuerpo, asunto, arrayDest, arrayAttach);
}

function envioMail_imprimir(codPresupuesto:String)
{
	var util:FLUtil = new FLUtil;
	
	var datosEMail:Array = [];
	datosEMail["tipoInforme"] = "presupuestoscli";
	var codCliente:String;
	if (codPresupuesto && codPresupuesto != "") {
		datosEMail["codDestino"] = util.sqlSelect("presupuestoscli", "codcliente", "codigo = '" + codPresupuesto + "'");
		datosEMail["codDocumento"] = codPresupuesto;
	} else {
		var cursor:FLSqlCursor = this.cursor();
		datosEMail["codDestino"] = cursor.valueBuffer("codcliente");
		datosEMail["codDocumento"] = cursor.valueBuffer("codigo");
	}
	flfactinfo.iface.datosEMail = datosEMail;
	this.iface.__imprimir(codPresupuesto);
}

//// ENVIO_MAIL /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition rappel */
/////////////////////////////////////////////////////////////////
//// RAPPEL /////////////////////////////////////////////////////
/** \D Copia los datos de una línea de presupuesto en una línea de pedido añadiendo el dato de descuento por rappel a una línea de pedido
@param	curLineaPresupuesto: Cursor que contiene los datos a incluir en la línea de pedido
@return	True si la copia se realiza correctamente, false en caso contrario
\end */
function rappel_datosLineaPedido(curLineaPresupuesto:FLSqlCursor):Boolean
{
	if(!this.iface.__datosLineaPedido(curLineaPresupuesto))
		return false;

	with (this.iface.curLineaPedido) {
		setValueBuffer("dtorappel", curLineaPresupuesto.valueBuffer("dtorappel"));
	}
	return true;
}

//// RAPPEL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
/** @class_definition clientesPot */
/////////////////////////////////////////////////////////////////
//// CLIENTESPOT //////////////////////////////////////////////////

/** \D Si el cliente del presupuesto es potencial, se pregunta la posibilidad de
pasarlo a cliente real
*/
function clientesPot_generarPedido(curPresupuesto:FLSqlCursor):Number
{
	if (!curPresupuesto.valueBuffer("clientepot"))
		return this.iface.__generarPedido(curPresupuesto);
	
	var codigo:String =  curPresupuesto.valueBuffer("codclientepot");
	if (!codigo)
		return this.iface.__generarPedido(curPresupuesto);
	
	var util:FLUtil = new FLUtil;
	var res:Object = MessageBox.information(util.translate("scripts",  "Este presupuesto está asociado a un cliente potencial\nA continuación se va a crear un cliente real a partir del cliente potencial\n\n¿Continuar?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
	
	if (res != MessageBox.Yes) 
		return false;
		
	var curTab:FLSqlCursor = new FLSqlCursor("clientespot");
	curTab.select("codigo = '" + codigo + "'");
	
	// Código no válido
	if (!curTab.first())
		MessageBox.information(util.translate("scripts",  "El código del cliente potencial del presupuesto no es válido"), MessageBox.Ok, MessageBox.Cancel, MessageBox.NoButton);		
	
	var codCliente:String = formclientespot.iface.pub_aprobarCliente(curTab);
	if (!codCliente)
		return false;
	
	var curPres:FLSqlCursor = new FLSqlCursor("presupuestoscli");
	curPres.select("idpresupuesto = " + curPresupuesto.valueBuffer("idpresupuesto"));
	if (!curPres.first()) {
		return false;
	}
	curPres.setActivatedCommitActions(false);
	curPres.setModeAccess(curPres.Edit);
	curPres.refreshBuffer();
	curPres.setValueBuffer("codcliente", codCliente);
	if (!curPres.commitBuffer()) {
		return false;
	}
	return this.iface.__generarPedido(curPresupuesto);
}
//// CLIENTESPOT //////////////////////////////////////////////////
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
	*/
	case "totaliva": {
			var porDto:Number = cursor.valueBuffer("pordtoesp");
			if (!porDto || porDto == 0) {
				valor = this.iface.__commonCalculateField(fN, cursor);
				break;
			}
			valor = util.sqlSelect("lineaspresupuestoscli", "SUM((pvptotal * iva * (100 - " + porDto + ")) / 100 / 100)", "idpresupuesto = " + cursor.valueBuffer("idpresupuesto"));
			valor = parseFloat(util.roundFieldValue(valor, "presupuestoscli", "totaliva"));
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
			valor = util.sqlSelect("lineaspresupuestoscli", "SUM((pvptotal * recargo * (100 - " + porDto + ")) / 100 / 100)", "idpresupuesto = " + cursor.valueBuffer("idpresupuesto"));
			valor = parseFloat(util.roundFieldValue(valor, "presupuestoscli", "totalrecargo"));
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
			valor = parseFloat(util.roundFieldValue(valor, "presupuestoscli", "neto"));
			break;
		}
	/** \C
	El --dtoesp-- es el --netosindtoesp-- menos el porcentaje que marca el --pordtoesp--
	\end */
	case "dtoesp": {
			valor = (parseFloat(cursor.valueBuffer("netosindtoesp")) * parseFloat(cursor.valueBuffer("pordtoesp"))) / 100;
			valor = parseFloat(util.roundFieldValue(valor, "presupuestoscli", "dtoesp"));
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
			valor = parseFloat(util.roundFieldValue(valor, "presupuestoscli", "pordtoesp"));
			break;
		}
	default: {
			valor = this.iface.__commonCalculateField(fN, cursor);
			break;
		}
	}
	return valor;
}

/** \D Informa los datos de un pedido a partir de los de un presupuesto
@param	curPresupuesto: Cursor que contiene los datos a incluir en el pedido
@return	True si el cálculo se realiza correctamente, false en caso contrario
\end */
function dtoEspecial_datosPedido(curPresupuesto:FLSqlCursor):Boolean
{
	var fecha:String;
	if (curPresupuesto.action() == "pedidoscli") {
		var hoy:Date = new Date();
		fecha = hoy.toString();
	} else
		fecha = curPresupuesto.valueBuffer("fecha");
			
	with (this.iface.curPedido) {
		setValueBuffer("pordtoesp", curPresupuesto.valueBuffer("pordtoesp"));
	}
	
	if(!this.iface.__datosPedido(curPresupuesto))
		return false;
	
	return true;
}

/** \D Informa los datos de un pedido referentes a totales (I.V.A., neto, etc.)
@return	True si el cálculo se realiza correctamente, false en caso contrario
\end */
function dtoEspecial_totalesPedido():Boolean
{
	with (this.iface.curPedido) {
		setValueBuffer("netosindtoesp", formpedidoscli.iface.pub_commonCalculateField("netosindtoesp", this));
		setValueBuffer("dtoesp", formpedidoscli.iface.pub_commonCalculateField("dtoesp", this));
		setValueBuffer("neto", formpedidoscli.iface.pub_commonCalculateField("neto", this));
		setValueBuffer("totaliva", formpedidoscli.iface.pub_commonCalculateField("totaliva", this));
		setValueBuffer("totalirpf", formpedidoscli.iface.pub_commonCalculateField("totalirpf", this));
		setValueBuffer("totalrecargo", formpedidoscli.iface.pub_commonCalculateField("totalrecargo", this));
		setValueBuffer("total", formpedidoscli.iface.pub_commonCalculateField("total", this));
		setValueBuffer("totaleuros", formpedidoscli.iface.pub_commonCalculateField("totaleuros", this));
	}
	return true;
}
//// DTO ESPECIAL ///////////////////////////////////////////////
//////////////////////////////////////////////////////////
/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
//////////////////////////////////////////////////////