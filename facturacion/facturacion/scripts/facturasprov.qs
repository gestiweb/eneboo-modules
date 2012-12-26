/***************************************************************************
                 facturasprov.qs  -  description
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
	function calculateField(fN:String):String { return this.ctx.interna_calculateField(fN); }
	function validateForm():Boolean { return this.ctx.interna_validateForm(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var arrayCosteM_:Array;
	var lblDatosFacturaAbono:Object;
	var curLineaRectificacion_:FLSqlCursor;
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
	function verificarHabilitaciones() {
		return this.ctx.oficial_verificarHabilitaciones();
	}
	function actualizarLineasIva(curFactura:FLSqlCursor):Boolean {
		return this.ctx.oficial_actualizarLineasIva(curFactura);
	}
	function buscarFactura() {
		this.ctx.oficial_buscarFactura();
	}
	function mostrarDatosFactura(idFactura:String):Boolean {
		return this.ctx.oficial_mostrarDatosFactura(idFactura);
	}
	function mostrarTraza() {
		return this.ctx.oficial_mostrarTraza();
	}
	function actualizarIvaClicked() {
		return this.ctx.oficial_actualizarIvaClicked();
	}
	function copiarLineasRec(idFacturaOriginal:String, factor:Number):Boolean {
		return this.ctx.oficial_copiarLineasRec(idFacturaOriginal, factor);
	}
	function copiarCampoLineaRec(nombreCampo:String, curLineaOriginal:FLSqlCursor, factor:Number):Boolean {
		return this.ctx.oficial_copiarCampoLineaRec(nombreCampo, curLineaOriginal, factor);
	}
	function copiarDatosLineaRec(idLinea:String, idLineaOriginal:String, factor:Number):Boolean {
		return this.ctx.oficial_copiarDatosLineaRec(idLinea, idLineaOriginal, factor);
	}
	function mostrarOpcionesFacturaRec(idFactura:String) {
		return this.ctx.oficial_mostrarOpcionesFacturaRec(idFactura);
	}
	function cargarArrayCosteMedio():Array {
		return this.ctx.oficial_cargarArrayCosteMedio();
	}
	function controlCosteMedio():Boolean {
		return this.ctx.oficial_controlCosteMedio();
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
/** @class_declaration frasImport */
/////////////////////////////////////////////////////////////////
//// FRAS IMPORT ////////////////////////////////////////////////
class frasImport extends scab {
	var tdbLineas:FLTableDB;
    function frasImport( context ) { scab ( context ); }
    function init() { 
		return this.ctx.frasImport_init(); 
	}
    function crearLinea_clicked() { 
		return this.ctx.frasImport_crearLinea_clicked(); 
	}
    function crearLinea():Boolean { 
		return this.ctx.frasImport_crearLinea(); 
	}
    function buscarFacturaImport() { 
		return this.ctx.frasImport_buscarFacturaImport(); 
	}
}
//// FRAS IMPORT ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration modelo347 */
/////////////////////////////////////////////////////////////////
//// MODELO 347 /////////////////////////////////////////////////
class modelo347 extends frasImport {
    function modelo347( context ) { frasImport ( context ); }
    function calcularTotales() {
		return this.ctx.modelo347_calcularTotales();
	}
}
//// MODELO 347 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration dtoEspecial */
/////////////////////////////////////////////////////////////////
//// DTO ESPECIAL ///////////////////////////////////////////////
class dtoEspecial extends modelo347 {
    var bloqueoDto:Boolean;
    function dtoEspecial( context ) { modelo347 ( context ); }
	function init() {
		return this.ctx.dtoEspecial_init();
	}
	function bufferChanged(fN:String) {
		return this.ctx.dtoEspecial_bufferChanged(fN);
	}
	function calcularTotales() {
		return this.ctx.dtoEspecial_calcularTotales();
	}
	function actualizarLineasIva(curFactura:FLSqlCursor):Boolean {
		return this.ctx.dtoEspecial_actualizarLineasIva(curFactura);
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
	function pub_actualizarLineasIva(curFactura:FLSqlCursor):Boolean {
		return this.actualizarLineasIva(curFactura);
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
Este formulario realiza la gestión de los facturas a proveedores.

Las facturas pueden ser generadas de forma manual o a partir de un albarán o albaranes (facturas automáticas).
\end */
function interna_init()
{
	var util:FLUtil = new FLUtil();
	this.iface.lblDatosFacturaAbono = this.child("lblDatosFacturaAbono");
	connect(this.child("tdbLineasFacturasProv").cursor(), "bufferCommited()", this, "iface.calcularTotales");
	connect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this.child("tbnBuscarFactura"), "clicked()", this, "iface.buscarFactura()");
	connect(this.child("tbnTraza"), "clicked()", this, "iface.mostrarTraza()");
	connect(this.child("tbnActualizarIva"), "clicked()", this, "iface.actualizarIvaClicked()");

	var cursor:FLSqlCursor = this.cursor();
	if (cursor.modeAccess() == cursor.Insert) {
		this.child("fdbCodEjercicio").setValue(flfactppal.iface.pub_ejercicioActual());
		this.child("fdbCodDivisa").setValue(flfactppal.iface.pub_valorDefectoEmpresa("coddivisa"));
		this.child("fdbCodPago").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codpago"));
		this.child("fdbCodAlmacen").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codalmacen"));
		this.child("fdbCodSerie").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codserie"));
		this.child("fdbTasaConv").setValue(util.sqlSelect("divisas", "tasaconv", "coddivisa = '" + this.child("fdbCodDivisa").value() + "'"));
		this.child("tbnBuscarFactura").setDisabled(true);
	} else {
		this.child("fdbCodSerie").setDisabled(true);
		if (this.cursor().valueBuffer("deabono") == true){
			this.child("tbnBuscarFactura").setDisabled(false);
			this.iface.mostrarDatosFactura(util.sqlSelect("facturasprov", "idfacturarect", "codigo = '" + this.child("fdbCodigo").value() + "'"));
		} else {
			this.child("tbnBuscarFactura").setDisabled(true);
		}
	}

	if (parseFloat(cursor.valueBuffer("idasiento")) != 0)
		this.child("ckbContabilizada").checked = true;

	if (cursor.valueBuffer("automatica") == true) {
		this.child("toolButtomInsert").setDisabled(true);
		this.child("toolButtonDelete").setDisabled(true);
		this.child("toolButtonEdit").setDisabled(true);
		this.child("tdbLineasFacturasProv").setReadOnly(true);
		this.child("fdbCodProveedor").setDisabled(true);
		this.child("fdbNombreProveedor").setDisabled(true);
		this.child("fdbCifNif").setDisabled(true);
		this.child("fdbCodDivisa").setDisabled(true);
		this.child("fdbRecFinanciero").setDisabled(true);
		this.child("fdbTasaConv").setDisabled(true);
	}
	this.iface.inicializarControles();

	this.iface.arrayCosteM_ = this.iface.cargarArrayCosteMedio();
	if (!this.iface.arrayCosteM_) {
		MessageBox.warning(util.translate("scripts", "Error al cargar los datos de coste medio"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
}

function interna_calculateField(fN:String):String
{
	var valor:String;
	var cursor:FLSqlCursor = this.cursor();
	switch (fN) {
		case "total": {
			this.child("lblRecFinanciero").setText((parseFloat(cursor.valueBuffer("recfinanciero")) * parseFloat(cursor.valueBuffer("neto"))) / 100);
			valor = formfacturasprov.iface.pub_commonCalculateField(fN, cursor);
			break;
		}
		default: {
			valor = formfacturasprov.iface.pub_commonCalculateField(fN, cursor);
			break;
		}
	}
	return valor;
}

function interna_validateForm()
{
	var cursor:FLSqlCursor = this.cursor();	
	var util:FLUtil = new FLUtil();

	var idFactura = cursor.valueBuffer("idfactura");
	if(!idFactura)
		return false;

	var codProveedor = this.child("fdbCodProveedor").value();
	var codproveedor = cursor.valueBuffer("codproveedor");
	var qryNum:FLSqlQuery = new FLSqlQuery;
	with (qryNum) {
		setTablesList("facturasprov");
		setSelect("numproveedor");
		setFrom("facturasprov");
		setWhere("idfactura <> " + idFactura + " AND codproveedor = '" + codproveedor + "'");
		setForwardOnly(true);
	}
	if (!qryNum.exec()) {
		return false;
	}
	
	while (qryNum.next()) {
		if (qryNum.value("numproveedor") && qryNum.value("numproveedor") == cursor.valueBuffer("numproveedor")) {
		var res:Number = MessageBox.information(util.translate("scripts", "Hay otra factura con el mismo número de proveedor.\n¿Desea continuar?"), MessageBox.Yes, MessageBox.No);
		if (res != 	MessageBox.Yes)
			return false;
		}
	}

	if(!flfacturac.iface.pub_validarIvaRecargoProveedor(codProveedor,idFactura,"lineasfacturasprov","idfactura")) {
		return false;
	}

	if (!this.iface.controlCosteMedio()) {
		return false;
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
	var util:FLUtil = new FLUtil();
	if (!sys.isLoadedModule("flcontppal") || !util.sqlSelect("empresa", "contintegrada", "1 = 1")) {
		this.child("tbwFactura").setTabEnabled("contabilidad", false);
	} else {
		this.child("tdbPartidas").setReadOnly(true);
	}

	if (this.cursor().valueBuffer("recfinanciero")) {
		this.child("lblRecFinanciero").setText((parseFloat(this.cursor().valueBuffer("recfinanciero")) * parseFloat(this.cursor().valueBuffer("neto"))) / 100);
	}
	this.child("tdbLineasIvaFactprov").setReadOnly(true);
	this.child("tbnActualizarIva").enabled = false;
	this.iface.verificarHabilitaciones();
}

function oficial_calcularTotales()
{
	this.child("fdbNeto").setValue(this.iface.calculateField("neto"));
	this.child("fdbTotalIva").setValue(this.iface.calculateField("totaliva"));
	this.child("fdbTotalRecargo").setValue(this.iface.calculateField("totalrecargo"));
	this.child("fdbTotaIrpf").setValue(this.iface.calculateField("totalirpf"));

	this.iface.actualizarLineasIva(this.cursor());
	this.child("tdbLineasIvaFactprov").refresh();
	this.child("tbnActualizarIva").enabled = false;

	this.iface.verificarHabilitaciones();
}

function oficial_bufferChanged(fN:String)
{
		var cursor:FLSqlCursor = this.cursor();
		var util:FLUtil = new FLUtil();
		switch (fN) {
		/** \C
		El --total-- es el --neto-- más el --totaliva-- más el --totalrecargo-- más el --recfinanciero--
		\end */
		case "recfinanciero":
		case "neto":{
				this.child("fdbTotaIrpf").setValue(this.iface.calculateField("totalirpf"));
			}
		case "totalrecargo":
		case "totalirpf":
		case "totaliva":{
						this.child("fdbTotal").setValue(this.iface.calculateField("total"));
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
		case "codserie":{
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
		case "deabono": {
						if(this.cursor().valueBuffer("deabono") == true)
							this.child("tbnBuscarFactura").setDisabled(false);
						else{
							this.child("tbnBuscarFactura").setDisabled(true);
							this.iface.lblDatosFacturaAbono.text = "";
 							this.cursor().setValueBuffer("codigorect", ""); 
							this.cursor().setNull("idfacturarect");
							}
						break;
				}
		}
}

function oficial_verificarHabilitaciones()
{
		var util:FLUtil = new FLUtil();
		if (!util.sqlSelect("lineasfacturasprov", "idfactura", "idfactura = " + this.cursor().valueBuffer("idfactura"))) {
				this.child("fdbCodAlmacen").setDisabled(false);
				this.child("fdbCodDivisa").setDisabled(false);
				this.child("fdbTasaConv").setDisabled(false);
		} else {
				this.child("fdbCodAlmacen").setDisabled(true);
				this.child("fdbCodDivisa").setDisabled(true);
				this.child("fdbTasaConv").setDisabled(true);
		}
}

/** \D
Actualiza (borra y reconstruye) los datos referentes a la factura en la tabla de agrupaciones por IVA (lineasivafactprov)
@param curFactura: Cursor posicionado en la factura
\end */
function oficial_actualizarLineasIva(curFactura:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	var idFactura:String;
	try {
		idFactura = curFactura.valueBuffer("idfactura");
	} catch (e) {
		// Antes se recibía sólo idFactura
		MessageBox.critical(util.translate("scripts", "Hay un problema con la actualización de su personalización.\nPor favor, póngase en contacto con InfoSiAL para solucionarlo"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var netoExacto:Number = curFactura.valueBuffer("neto");
	var lineasSinIVA:Number = util.sqlSelect("lineasfacturasprov", "SUM(pvptotal)", "idfactura = " + idFactura + " AND iva IS NULL");
	lineasSinIVA = (isNaN(lineasSinIVA) ? 0 : lineasSinIVA);
	netoExacto -= lineasSinIVA;
	netoExacto = util.roundFieldValue(netoExacto, "facturasprov", "neto");

	var ivaExacto:Number = curFactura.valueBuffer("totaliva");
	var reExacto:Number = curFactura.valueBuffer("totalrecargo");
	
	if (!util.sqlDelete("lineasivafactprov", "idfactura = " + idFactura)) {
		return false;
	}

	var codImpuestoAnt:Number = 0;
	var codImpuesto:Number = 0;
	var iva:Number;
	var recargo:Number;
	var totalNeto:Number = 0;
	var totalIva:Number = 0;
	var totalRecargo:Number = 0;
	var totalLinea:Number = 0;
	var acumNeto:Number = 0;
	var acumIva:Number = 0;
	var acumRecargo:Number = 0;
	
	var curLineaIva:FLSqlCursor = new FLSqlCursor("lineasivafactprov");
	var qryLineasFactura:FLSqlQuery = new FLSqlQuery;
	with (qryLineasFactura) {
		setTablesList("lineasfacturasprov");
		setSelect("codimpuesto, iva, recargo, pvptotal");
		setFrom("lineasfacturasprov");
		setWhere("idfactura = " + idFactura + " AND pvptotal <> 0 AND iva IS NOT NULL ORDER BY iva, codimpuesto"); /// Se ordena primero por IVA para evitar líneas con %IVA 0 y valor != 0 cuando este iva es el último, por efectos del redondeo
		setForwardOnly(true);
	}
	if (!qryLineasFactura.exec())
		return false;
	
	while (qryLineasFactura.next()) {
		codImpuesto = qryLineasFactura.value("codimpuesto");
		if (codImpuestoAnt != 0 && codImpuestoAnt != codImpuesto) {
			totalNeto = util.roundFieldValue(totalNeto, "lineasivafactprov", "neto");
			totalIva = util.roundFieldValue((iva * totalNeto) / 100, "lineasivafactprov", "totaliva");
			totalRecargo = util.roundFieldValue((recargo * totalNeto) / 100, "lineasivafactprov", "totalrecargo");
			totalLinea = parseFloat(totalNeto) + parseFloat(totalIva) + parseFloat(totalRecargo);
			totalLinea = util.roundFieldValue(totalLinea, "lineasivafactprov", "totallinea");
			
			acumNeto += parseFloat(totalNeto);
			acumIva += parseFloat(totalIva);
			acumRecargo += parseFloat(totalRecargo);

			with(curLineaIva) {
				setModeAccess(Insert);
				refreshBuffer();
				setValueBuffer("idfactura", idFactura);
				setValueBuffer("codimpuesto", codImpuestoAnt);
				setValueBuffer("iva", iva);
				setValueBuffer("recargo", recargo);
				setValueBuffer("neto", totalNeto);
				setValueBuffer("totaliva", totalIva);
				setValueBuffer("totalrecargo", totalRecargo);
				setValueBuffer("totallinea", totalLinea);
			}
			if (!curLineaIva.commitBuffer())
					return false;
			totalNeto = 0;
		}
		codImpuestoAnt = codImpuesto;
		iva = parseFloat(qryLineasFactura.value("iva"));
		recargo = parseFloat(qryLineasFactura.value("recargo"));
		if (isNaN(recargo)) {
			recargo = 0;
		}
		totalNeto += parseFloat(qryLineasFactura.value("pvptotal"));
	}

	if (totalNeto != 0) {
		totalNeto = util.roundFieldValue(netoExacto - acumNeto, "lineasivafactprov", "neto");
		totalIva = util.roundFieldValue(ivaExacto - acumIva, "lineasivafactprov", "totaliva");
		totalRecargo = util.roundFieldValue(reExacto - acumRecargo, "lineasivafactprov", "totalrecargo");
		totalLinea = parseFloat(totalNeto) + parseFloat(totalIva) + parseFloat(totalRecargo);
		totalLinea = util.roundFieldValue(totalLinea, "lineasivafactprov", "totallinea");

		with(curLineaIva) {
			setModeAccess(Insert);
			refreshBuffer();
			setValueBuffer("idfactura", idFactura);
			setValueBuffer("codimpuesto", codImpuestoAnt);
			setValueBuffer("iva", iva);
			setValueBuffer("recargo", recargo);
			setValueBuffer("neto", totalNeto);
			setValueBuffer("totaliva", totalIva);
			setValueBuffer("totalrecargo", totalRecargo);
			setValueBuffer("totallinea", totalLinea);
		}
		if (!curLineaIva.commitBuffer())
			return false;
	}
	return true;
}

/* \D Muebra el formulario de busqueda de facturas de cliente filtrando las facturas 
que no estan abonadas y que no son la factura que se esta editando.
\end */
function oficial_buscarFactura()
{
	var ruta:Object = new FLFormSearchDB("busfactprov");
	var curFacturas:FLSqlCursor = ruta.cursor();
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	
	var codProveedor:String = cursor.valueBuffer("codproveedor");
	var masFiltro:String = "";
	if (codProveedor)
		masFiltro += " AND codproveedor = '" + codProveedor + "'";
	
	if (cursor.modeAccess() == cursor.Insert)
		curFacturas.setMainFilter("deabono = false" + masFiltro);
	else
		curFacturas.setMainFilter("deabono = false and idfactura <> " + this.cursor().valueBuffer("idfactura") + masFiltro);

	ruta.setMainWidget();
	var idFactura:String = ruta.exec("idfactura");

	if (!idFactura) {
		return false;
	}

	cursor.setValueBuffer("idfacturarect", idFactura);
	var codigo:String = util.sqlSelect("facturasprov", "codigo", "idfactura = '" + idFactura + "'");
	cursor.setValueBuffer("codigorect", codigo);
	this.iface.mostrarDatosFactura(idFactura);

	this.iface.mostrarOpcionesFacturaRec(idFactura);
}

function oficial_mostrarOpcionesFacturaRec(idFactura:String)
{
	var util:FLUtil = new FLUtil;
	var opciones:Array = [util.translate("scripts", "Copiar líneas de la factura"), util.translate("scripts", "Copiar líneas de la factura con cantidad negativa"), util.translate("scripts", "No copiar líneas")];
	var opcion:Number = flfactppal.iface.pub_elegirOpcion(opciones);
	switch (opcion) {
		case 0: {
			if (!this.iface.copiarLineasRec(idFactura, 1)) {
				return false;
			}
			break;
		}
		case 1: {
			if (!this.iface.copiarLineasRec(idFactura, -1)) {
				return false;
			}
			break;
		}
	}
}

function oficial_copiarDatosLineaRec(idLinea:String, idLineaOriginal:String, factor:Number)
{
	return true;
}


function oficial_copiarLineasRec(idFacturaOriginal:String, factor:Number):Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	if (cursor.modeAccess() == cursor.Insert) {
		var curLineas:FLSqlCursor = this.child("tdbLineasFacturasProv").cursor();
		if (!curLineas.commitBufferCursorRelation()) {
			return false;
		}
	}

	var curLineaOriginal:FLSqlCursor = new FLSqlCursor("lineasfacturasprov");
	this.iface.curLineaRectificacion_ = new FLSqlCursor("lineasfacturasprov");

	var camposLinea:Array = util.nombreCampos("lineasfacturasprov");
	var totalCampos:Number = camposLinea[0];
	var idLinea:String;
	curLineaOriginal.select("idfactura = " + idFacturaOriginal + " ORDER BY idlinea");
	while (curLineaOriginal.next()) {
		curLineaOriginal.setModeAccess(curLineaOriginal.Browse);
		curLineaOriginal.refresh();
		this.iface.curLineaRectificacion_.setModeAccess(this.iface.curLineaRectificacion_.Insert);
		this.iface.curLineaRectificacion_.refresh();

		for (var i:Number = 1; i <= totalCampos; i++) {
			if (!this.iface.copiarCampoLineaRec(camposLinea[i], curLineaOriginal, factor)) {
				return false;
			}
		}
		if (!this.iface.curLineaRectificacion_.commitBuffer()) {
			return false;
		}
		idLinea = this.iface.curLineaRectificacion_.valueBuffer("idlinea");
		if (!this.iface.copiarDatosLineaRec(idLinea, curLineaOriginal.valueBuffer("idlinea"), factor)) {
			return false;
		}
	}
	this.iface.calcularTotales();
	this.child("tdbLineasFacturasProv").refresh();

	return true;
}

function oficial_copiarCampoLineaRec(nombreCampo:String, curLineaOriginal:FLSqlCursor, factor:Number):Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	switch (nombreCampo) {
		case "idlinea":
		case "idalbaran": {
			return true;
			break;
		}
		case "idfactura": {
			this.iface.curLineaRectificacion_.setValueBuffer("idfactura", cursor.valueBuffer("idfactura"));
			break;
		}
		case "cantidad":
		case "dtolineal":
		case "pvpsindto":
		case "pvptotal": {
			this.iface.curLineaRectificacion_.setValueBuffer(nombreCampo, curLineaOriginal.valueBuffer(nombreCampo) * factor);
			break;
		}
		case "idsubcuenta": {
			if (curLineaOriginal.isNull(nombreCampo)) {
				this.iface.curLineaRectificacion_.setNull(nombreCampo);
			} else {
				this.iface.curLineaRectificacion_.setValueBuffer("idsubcuenta", util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + curLineaOriginal.valueBuffer("codsubcuenta") + "' AND codejercicio = '" + cursor.valueBuffer("codejercicio") + "'"));
			}
			break;
		}
		default: {
			if (curLineaOriginal.isNull(nombreCampo)) {
				this.iface.curLineaRectificacion_.setNull(nombreCampo);
			} else {
				this.iface.curLineaRectificacion_.setValueBuffer(nombreCampo, curLineaOriginal.valueBuffer(nombreCampo));
			}
		}
	}
	return true;
}

/* \D Compone los datos dela factura a abonar en un label
@param	idFactura: identificador de la factura
@return	VERDADERO si no hay error. FALSO en otro caso
\end */
function oficial_mostrarDatosFactura(idFactura:String):Boolean
{
	var util:FLUtil = new FLUtil();
	var q:FLSqlQuery = new FLSqlQuery();
	
	q.setTablesList("facturasprov");
	q.setSelect("codigo,fecha");
	q.setFrom("facturasprov");
	q.setWhere("idfactura = '" + idFactura + "'");
	if (!q.exec())
		return false;
	if (!q.first())
		return false;
	var codFactura:String = q.value(0);
	var fecha:String = util.dateAMDtoDMA(q.value(1));
	this.iface.lblDatosFacturaAbono.text = "Rectifica a la factura  " + codFactura + " con fecha " + fecha;
	
	return true;
}

function oficial_mostrarTraza()
{
	flfacturac.iface.pub_mostrarTraza(this.cursor().valueBuffer("codigo"), "facturasprov");
}

/** \D Llama a la función de actualizar líneas de IVA cuando se pulsa el botón
\end */
function oficial_actualizarIvaClicked()
{
	this.iface.actualizarLineasIva(this.cursor());
	this.child("tdbLineasIvaFactprov").refresh();
	this.child("tbnActualizarIva").enabled = false;
}

/** \D Carga una array con los datos que afectan al cálculo del coste medio de todas las líneas de la factura
\end */
function oficial_cargarArrayCosteMedio():Array
{
	if (!sys.isLoadedModule("flfactalma")) {
		return true;
	}

	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var arrayCoste:Array = [];

	var qryCoste:FLSqlQuery = new FLSqlQuery;
	qryCoste.setTablesList("facturasprov,lineasfacturasprov");
	qryCoste.setSelect("lf.referencia, lf.pvptotal, lf.cantidad");
	qryCoste.setFrom("facturasprov f INNER JOIN lineasfacturasprov lf ON f.idfactura = lf.idfactura");
	qryCoste.setWhere("f.idfactura = " + cursor.valueBuffer("idfactura") + " AND lf.referencia IS NOT NULL");
	qryCoste.setForwardOnly(true);
	if (!qryCoste.exec()) {
		return false;
	}
	var i:Number = 0;
	while (qryCoste.next()) {
		arrayCoste[i] = [];
		arrayCoste[i]["idarticulo"] = qryCoste.value("lf.referencia");
		arrayCoste[i]["pvptotal"] = qryCoste.value("lf.pvptotal");
		arrayCoste[i]["cantidad"] = qryCoste.value("lf.cantidad");
		i++;
	}
	return arrayCoste;
}

/** \D Compara los datos de cálculo de coste medio inicial y final, para llamar a la función de recálculo en los casos en los que estos han cambiado
\end */
function oficial_controlCosteMedio():Boolean
{
	if (!sys.isLoadedModule("flfactalma")) {
		return true;
	}
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	var arrayActual:Array = this.iface.cargarArrayCosteMedio();
	if (!arrayActual) {
		MessageBox.warning(util.translate("scripts", "Error al cargar los datos de coste medio"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var arrayAfectados:Array = flfacturac.iface.pub_arrayCostesAfectados(this.iface.arrayCosteM_, arrayActual);
	if (!arrayAfectados) {
		return false;
	}
	for (var i:Number = 0; i < arrayAfectados.length; i++) {
		if (!flfactalma.iface.pub_cambiarCosteMedio(arrayAfectados[i]["idarticulo"])) {
			return false;
		}
	}

	return true;
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
	qryStocks.setTablesList("facturasprov,lineasfacturasprov");
	qryStocks.setSelect("lf.referencia, SUM(lf.cantidad)");
	qryStocks.setFrom("facturasprov f INNER JOIN lineasfacturasprov lf ON f.idfactura = lf.idfactura");
	qryStocks.setWhere("f.idfactura = " + cursor.valueBuffer("idfactura") + " AND lf.referencia IS NOT NULL GROUP BY f.codalmacen, lf.referencia");
	qryStocks.setForwardOnly(true);
	if (!qryStocks.exec()) {
		return false;
	}
	var i:Number = 0;
	while (qryStocks.next()) {
		arrayStocks[i] = [];
		arrayStocks[i]["idarticulo"] = qryStocks.value("lf.referencia");
		arrayStocks[i]["codalmacen"] = cursor.valueBuffer("codalmacen");
		arrayStocks[i]["cantidad"] = qryStocks.value("SUM(lf.cantidad)");
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
		if (!flfactalma.iface.pub_actualizarStockFisico(arrayAfectados[i]["idarticulo"], arrayAfectados[i]["codalmacen"], "cantidadfp")) {
			return false;
		}
	}

	return true;
}

//// CONTROL STOCK CABECERA /////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition frasImport */
/////////////////////////////////////////////////////////////////
//// FRAS IMPORT ////////////////////////////////////////////////
function frasImport_init()
{
	this.iface.__init();

	this.iface.tdbLineas = this.child("tdbLineasFacturasProv");
	var cursor:FLSqlCursor = this.cursor();
	connect(this.child("tbnCrearLinea"), "clicked()", this, "iface.crearLinea_clicked()");
	connect(this.child("tbnBuscarFacturaImport"), "clicked()", this, "iface.buscarFacturaImport()");
}

function frasImport_buscarFacturaImport()
{
	var cursor:FLSqlCursor = this.cursor();
	var f:Object = new FLFormSearchDB("busfactprov");
	var curFacturas:FLSqlCursor = f.cursor();
	f.setMainWidget();
	var idFactura:String = f.exec("idfactura");
	if (!idFactura) {
		return false;
	} else {
		cursor.setValueBuffer("idfacturaimport", idFactura);
	}
}

function frasImport_crearLinea_clicked()
{
	var cursor:FLSqlCursor = this.cursor();
	if (cursor.modeAccess() == cursor.Insert) {
		if (!this.iface.tdbLineas.cursor().commitBufferCursorRelation()) {
			return false;
		}
	}
	var util:FLUtil = new FLUtil();
	var curTrans:FLSqlCursor = new FLSqlCursor("empresa");
	curTrans.transaction(false);
	try {
		if (this.iface.crearLinea()) {
			curTrans.commit();
		} else {
			curTrans.rollback();
		}
	}
	catch (e) {
		curTrans.rollback();
		MessageBox.critical(util.translate("scripts", "Hubo un error al crear la línea:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
	}
	
	this.iface.tdbLineas.refresh();
}

function frasImport_crearLinea():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var refImport:String = util.sqlSelect("factalma_general", "refivaimport", "1 = 1");
	if (!refImport) {
		MessageBox.warning(util.translate("scripts", "Antes de crear la línea deberá crear la referencia correspondiente a la línea de IVA\n(con la subcuenta de compras marcada como cuenta especial IVASIM)\n y asociarla en el formulario de datos generales del módulo de almacen"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var curLinea:FLSqlCursor = new FLSqlCursor("lineasfacturasprov");
	curLinea.select("idfactura = " + cursor.valueBuffer("idfactura") + " AND referencia = '" + refImport + "'");
	if (curLinea.first()) {
		MessageBox.information(util.translate("scripts", "Ya existe una línea creada para el IVA importación"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	
	var qryArt:FLSqlQuery = new FLSqlQuery();
	qryArt.setTablesList("articulos");
	qryArt.setSelect("descripcion,idsubcuentacom,codsubcuentacom");
	qryArt.setFrom("articulos");
	qryArt.setWhere("referencia = '" + refImport + "'");
	if (!qryArt.exec()) {
		return false;
	}
	if (!qryArt.first()) {
		return false;
	}
 
	curLinea.setModeAccess(curLinea.Insert);
	curLinea.refreshBuffer();
	curLinea.setValueBuffer("idfactura", cursor.valueBuffer("idfactura"));
	curLinea.setValueBuffer("referencia", refImport);
	curLinea.setValueBuffer("descripcion", qryArt.value("descripcion"));
	curLinea.setValueBuffer("cantidad", 1);
	curLinea.setValueBuffer("pvpunitario", cursor.valueBuffer("cuotaimport"));
	curLinea.setValueBuffer("pvpsindto", cursor.valueBuffer("cuotaimport"));
	curLinea.setValueBuffer("pvptotal", cursor.valueBuffer("cuotaimport"));
	curLinea.setValueBuffer("idsubcuenta", qryArt.value("idsubcuentacom"));
	curLinea.setValueBuffer("codsubcuenta", qryArt.value("codsubcuentacom"));

	if (!curLinea.commitBuffer()) {
		return false;
	}
	this.iface.calcularTotales();
	return true;
}
//// FRAS IMPORT ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition modelo347 */
/////////////////////////////////////////////////////////////////
//// MODELO 347 /////////////////////////////////////////////////
function modelo347_calcularTotales()
{
	this.iface.__calcularTotales();
	this.child("fdbNoModelo347").setValue(this.iface.calculateField("nomodelo347"));
}
//// MODELO 347 /////////////////////////////////////////////////
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
	var idFactura:Number = this.cursor().valueBuffer("idfactura");
	this.child("fdbNetoSinDtoEsp").setValue(this.iface.calculateField("netosindtoesp"));
	this.iface.__calcularTotales();
}

/** \D
Actualiza (borra y reconstruye) los datos referentes a la factura en la tabla de agrupaciones por IVA (lineasivafactcli)
@param curFactura: Cursor posicionado en la factura
\end */
function dtoEspecial_actualizarLineasIva(curFactura:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	var idFactura:String;
	try {
		idFactura = curFactura.valueBuffer("idfactura");
	} catch (e) {
		// Antes se recibía sólo idFactura
		MessageBox.critical(util.translate("scripts", "Hay un problema con la actualización de su personalización.\nPor favor, póngase en contacto con InfoSiAL para solucionarlo"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var porDto:Number = parseFloat(curFactura.valueBuffer("pordtoesp"));
	if (isNaN(porDto))
		porDto = 0;
	if (!porDto || porDto == 0)
		return this.iface.__actualizarLineasIva(curFactura);

	var netoExacto:Number = curFactura.valueBuffer("neto");
	var lineasSinIVA:Number = util.sqlSelect("lineasfacturasprov", "SUM(pvptotal)", "idfactura = " + idFactura + " AND iva IS NULL");
	lineasSinIVA = (isNaN(lineasSinIVA) ? 0 : lineasSinIVA);
	netoExacto -= lineasSinIVA;
	netoExacto = util.roundFieldValue(netoExacto, "facturasprov", "neto");

	var ivaExacto:Number = util.sqlSelect("lineasfacturasprov", "SUM((pvptotal * iva * (100 - " + porDto + ")) / 100 / 100)", "idfactura = " + idFactura);
	if (!ivaExacto)
		ivaExacto = 0;
	var reExacto:Number = util.sqlSelect("lineasfacturasprov", "SUM((pvptotal * recargo * (100 - " + porDto + ")) / 100 / 100)", "idfactura = " + idFactura);
	if (!reExacto)
		reExacto = 0;
	
	if (!util.sqlDelete("lineasivafactprov", "idfactura = " + idFactura)) {
		return false;
	}

	var codImpuestoAnt:Number = 0;
	var codImpuesto:Number = 0;
	var iva:Number;
	var recargo:Number;
	var totalNeto:Number = 0;
	var totalIva:Number = 0;
	var totalRecargo:Number = 0;
	var totalLinea:Number = 0;
	var acumNeto:Number = 0;
	var acumIva:Number = 0;
	var acumRecargo:Number = 0;
	
	var curLineaIva:FLSqlCursor = new FLSqlCursor("lineasivafactprov");
	var qryLineasFactura:FLSqlQuery = new FLSqlQuery;
	with (qryLineasFactura) {
		setTablesList("lineasfacturasprov");
		setSelect("codimpuesto, iva, recargo, pvptotal");
		setFrom("lineasfacturasprov");
		setWhere("idfactura = " + idFactura + " AND pvptotal <> 0 AND iva IS NOT NULL ORDER BY codimpuesto");
		setForwardOnly(true);
	}
	if (!qryLineasFactura.exec())
		return false;
	
	while (qryLineasFactura.next()) {
		codImpuesto = qryLineasFactura.value("codimpuesto");
		if (codImpuestoAnt != 0 && codImpuestoAnt != codImpuesto) {
			totalNeto = (totalNeto * (100 - porDto)) / 100;
			totalNeto = util.roundFieldValue(totalNeto, "lineasivafactprov", "neto");
			totalIva = util.roundFieldValue((iva * totalNeto) / 100, "lineasivafactprov", "totaliva");
			totalRecargo = util.roundFieldValue((recargo * totalNeto) / 100, "lineasivafactprov", "totalrecargo");
			totalLinea = parseFloat(totalNeto) + parseFloat(totalIva) + parseFloat(totalRecargo);
			totalLinea = util.roundFieldValue(totalLinea, "lineasivafactprov", "totallinea");
			
			acumNeto += parseFloat(totalNeto);
			acumIva += parseFloat(totalIva);
			acumRecargo += parseFloat(totalRecargo);

			with(curLineaIva) {
				setModeAccess(Insert);
				refreshBuffer();
				setValueBuffer("idfactura", idFactura);
				setValueBuffer("codimpuesto", codImpuestoAnt);
				setValueBuffer("iva", iva);
				setValueBuffer("recargo", recargo);
				setValueBuffer("neto", totalNeto);
				setValueBuffer("totaliva", totalIva);
				setValueBuffer("totalrecargo", totalRecargo);
				setValueBuffer("totallinea", totalLinea);
			}
			if (!curLineaIva.commitBuffer())
					return false;
			totalNeto = 0;
		}
		codImpuestoAnt = codImpuesto;
		iva = parseFloat(qryLineasFactura.value("iva"));
		recargo = parseFloat(qryLineasFactura.value("recargo"));
		totalNeto += parseFloat(qryLineasFactura.value("pvptotal"));
	}

	if (totalNeto != 0) {
		totalNeto = util.roundFieldValue(netoExacto - acumNeto, "lineasivafactprov", "neto");
		totalIva = util.roundFieldValue(ivaExacto - acumIva, "lineasivafactprov", "totaliva");
		totalRecargo = util.roundFieldValue(reExacto - acumRecargo, "lineasivafactprov", "totalrecargo");
		totalLinea = parseFloat(totalNeto) + parseFloat(totalIva) + parseFloat(totalRecargo);
		totalLinea = util.roundFieldValue(totalLinea, "lineasivafactprov", "totallinea");

		with(curLineaIva) {
			setModeAccess(Insert);
			refreshBuffer();
			setValueBuffer("idfactura", idFactura);
			setValueBuffer("codimpuesto", codImpuestoAnt);
			setValueBuffer("iva", iva);
			setValueBuffer("recargo", recargo);
			setValueBuffer("neto", totalNeto);
			setValueBuffer("totaliva", totalIva);
			setValueBuffer("totalrecargo", totalRecargo);
			setValueBuffer("totallinea", totalLinea);
		}
		if (!curLineaIva.commitBuffer())
			return false;
	}
	return true;
}

function dtoEspecial_init()
{
	this.iface.__init();

	this.iface.bloqueoDto = false;
}
//// DTO ESPECIAL ////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
//////////////////////////////////////////////////////////
