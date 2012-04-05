/***************************************************************************
                 facturascli.qs  -  description
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
    function init() {
		return this.ctx.interna_init();
	}
	function calculateField(fN:String):String {
		return this.ctx.interna_calculateField(fN);
	}
	function validateForm():Boolean {
		return this.ctx.interna_validateForm();
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var bloqueoProvincia:Boolean;
	var lblDatosFacturaAbono:Object;
	var curLineaRectificacion_:FLSqlCursor;
	var pbnAplicarComision:Object;
    function oficial( context ) { interna( context ); } 
	function inicializarControles() {
		return this.ctx.oficial_inicializarControles();
	}
	function aplicarComision_clicked() {
		return this.ctx.oficial_aplicarComision_clicked();
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
	function buscarFactura() {
		this.ctx.oficial_buscarFactura();
	}
	function mostrarDatosFactura(idFactura:String):Boolean {
		return this.ctx.oficial_mostrarDatosFactura(idFactura);
	}
	function mostrarTraza() {
		return this.ctx.oficial_mostrarTraza();
	}
	function actualizarLineasIva(curFactura:FLSqlCursor):Boolean {
		return this.ctx.oficial_actualizarLineasIva(curFactura);
	}
	function actualizarIvaClicked() {
		return this.ctx.oficial_actualizarIvaClicked();
	}
	function calcularComisionAgente():Number {
		return this.ctx.oficial_calcularComisionAgente();
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
Este formulario realiza la gestión de los facturas a clientes.

Las facturas pueden ser generadas de forma manual o a partir de un albarán o albaranes (facturas automáticas).
\end */
function interna_init()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	this.iface.bloqueoProvincia = false;

	this.iface.lblDatosFacturaAbono = this.child("lblDatosFacturaAbono");
	this.iface.pbnAplicarComision = this.child("pbnAplicarComision");

	connect(this.iface.pbnAplicarComision, "clicked()", this, "iface.aplicarComision_clicked()");
	connect(this.child("tdbLineasFacturasCli").cursor(), "bufferCommited()", this, "iface.calcularTotales");
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this.child("tbnBuscarFactura"), "clicked()", this, "iface.buscarFactura()");
	connect(this.child("tbnTraza"), "clicked()", this, "iface.mostrarTraza()");
	connect(this.child("tbnActualizarIva"), "clicked()", this, "iface.actualizarIvaClicked()");

	this.iface.pbnAplicarComision.setDisabled(true);

	if (cursor.modeAccess() == cursor.Insert) {
		this.child("fdbCodEjercicio").setValue(flfactppal.iface.pub_ejercicioActual());
		this.child("fdbCodDivisa").setValue(flfactppal.iface.pub_valorDefectoEmpresa("coddivisa"));
		this.child("fdbCodPago").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codpago"));
		this.child("fdbCodAlmacen").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codalmacen"));
		this.child("fdbCodSerie").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codserie"));
		this.child("fdbTasaConv").setValue(util.sqlSelect("divisas", "tasaconv", "coddivisa = '" + this.child("fdbCodDivisa").value() + "'"));
		this.child("tbnBuscarFactura").setDisabled(true);
	}
	else {
		if (this.cursor().valueBuffer("deabono") == true){
			this.child("tbnBuscarFactura").setDisabled(false);
			this.iface.mostrarDatosFactura(util.sqlSelect("facturascli", "idfacturarect", "codigo = '" + this.child("fdbCodigo").value() + "'"));
		}
		else {
			this.child("tbnBuscarFactura").setDisabled(true);
		}
	}
	if (cursor.modeAccess() == cursor.Edit)
		this.child("fdbCodSerie").setDisabled(true);

	if (!cursor.valueBuffer("porcomision"))
		this.child("fdbPorComision").setDisabled(true);

	if (parseFloat(cursor.valueBuffer("idasiento")) != 0)
		this.child("ckbContabilizada").checked = true;

	if (cursor.valueBuffer("automatica") == true) {
		this.child("toolButtomInsert").setDisabled(true);
		this.child("toolButtonDelete").setDisabled(true);
		this.child("toolButtonEdit").setDisabled(true);
		this.child("tdbLineasFacturasCli").setReadOnly(true);
		this.child("fdbCodCliente").setDisabled(true);
		this.child("fdbNombreCliente").setDisabled(true);
		this.child("fdbCifNif").setDisabled(true);
		this.child("fdbCodDivisa").setDisabled(true);
		this.child("fdbRecFinanciero").setDisabled(true);
		this.child("fdbTasaConv").setDisabled(true);
	}
	this.iface.inicializarControles();
}

function interna_calculateField(fN:String):String
{
	return formfacturascli.iface.pub_commonCalculateField(fN, this.cursor());
}

function interna_validateForm()
{
	var cursor:FLSqlCursor = this.cursor();
	if (!flfactppal.iface.pub_validarProvincia(cursor)) {
		return false;
	}

	var idFactura = cursor.valueBuffer("idfactura");
	var codCliente = this.child("fdbCodCliente").value();
	if (!flfacturac.iface.pub_validarIvaRecargoCliente(codCliente, idFactura, "lineasfacturascli", "idfactura")) {
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

	this.child("lblRecFinanciero").setText(this.iface.calculateField("lblRecFinanciero"));
	this.child("lblComision").setText(this.iface.calculateField("lblComision"));
	this.child("tdbLineasIvaFactCli").setReadOnly(true);
	this.child("tbnActualizarIva").enabled = false;
	this.iface.verificarHabilitaciones();
}

function oficial_calcularTotales()
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	this.child("fdbNeto").setValue(this.iface.calculateField("neto"));
	this.child("lblComision").setText(this.iface.calculateField("lblComision"));
	this.child("fdbTotalIva").setValue(this.iface.calculateField("totaliva"));
	this.child("fdbTotalRecargo").setValue(this.iface.calculateField("totalrecargo"));
	this.child("fdbTotaIrpf").setValue(this.iface.calculateField("totalirpf"));

	this.iface.actualizarLineasIva(this.cursor());
	this.child("tdbLineasIvaFactCli").refresh();
	this.child("tbnActualizarIva").enabled = false;

	this.iface.verificarHabilitaciones();
	
// 	var codAgente:String = cursor.valueBuffer("codagente");
// 	if (codAgente)
// 		this.child("fdbPorComision").setValue(this.iface.calcularComisionAgente());
}

function oficial_bufferChanged(fN:String)
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	switch (fN) {
		case "recfinanciero":
		case "neto":{
			this.child("lblRecFinanciero").setText(this.iface.calculateField("lblRecFinanciero"));
			this.child("fdbTotaIrpf").setValue(this.iface.calculateField("totalirpf"));
		}
		/** \C
		El --total-- es el --neto-- menos el --totalirpf-- más el --totaliva-- más el --totalrecargo-- más el --recfinanciero--
		\end */
		case "totaliva":
		case "totalirpf":
		case "totalrecargo":{
			this.child("fdbTotal").setValue(this.iface.calculateField("total"));
			break;
		}
		/** \C
		El --totaleuros-- es el producto del --total-- por la --tasaconv--
		\end */
		case "total": {
			this.child("fdbTotalEuros").setValue(this.iface.calculateField("totaleuros"));
			this.child("lblComision").setText(this.iface.calculateField("lblComision"));
			break;
		}
		case "tasaconv": {
			this.child("fdbTotalEuros").setValue(this.iface.calculateField("totaleuros"));
			break;
		}
		/** \C
		Al cambiar el --porcomision-- se mostrará el total de comisión aplicada
		\end */
		case "porcomision":{
			this.child("lblComision").setText(this.iface.calculateField("lblComision"));
			break;
		}
		/** \C
		El valor de --coddir-- por defecto corresponde a la dirección del cliente marcada como dirección de facturación
		\end */
		case "codcliente": {
			this.child("fdbCodDir").setValue("0");
			this.child("fdbCodDir").setValue(this.iface.calculateField("coddir"));
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
		case "codagente": {
			this.iface.pbnAplicarComision.setDisabled(false);
// 			this.child("fdbPorComision").setValue(this.iface.calcularComisionAgente());
			break;
		}
	}
}

function oficial_verificarHabilitaciones()
{
		var util:FLUtil = new FLUtil();
		if (!util.sqlSelect("lineasfacturascli", "idfactura", "idfactura = " + this.cursor().valueBuffer("idfactura"))) {
				this.child("fdbCodAlmacen").setDisabled(false);
				this.child("fdbCodDivisa").setDisabled(false);
				this.child("fdbTasaConv").setDisabled(false);
		} else {
				this.child("fdbCodAlmacen").setDisabled(true);
				this.child("fdbCodDivisa").setDisabled(true);
				this.child("fdbTasaConv").setDisabled(true);
		}
}

/* \D Muestra el formulario de busqueda de facturas de cliente filtrando las facturas 
que no estan abonadas y que no son la factura que se esta editando.
\end */
function oficial_buscarFactura()
{
	var ruta:Object = new FLFormSearchDB("busfactcli");
	var curFacturas:FLSqlCursor = ruta.cursor();
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	
	var codCliente:String = cursor.valueBuffer("codcliente");
	var masFiltro:String = "";
	if (codCliente)
		masFiltro += " AND codcliente = '" + codCliente + "'";
	
	if (cursor.modeAccess() == cursor.Insert)
		curFacturas.setMainFilter("deabono = false" + masFiltro);
	else
		curFacturas.setMainFilter("deabono = false and idfactura <> " + this.cursor().valueBuffer("idfactura") + masFiltro);

	ruta.setMainWidget();
	var idFactura:String = ruta.exec("idfactura");

	if (!idFactura) {
		return;
	}

	cursor.setValueBuffer("idfacturarect", idFactura);
	var codigo:String = util.sqlSelect("facturascli", "codigo", "idfactura = '" + idFactura + "'");
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
		var curLineas:FLSqlCursor = this.child("tdbLineasFacturasCli").cursor();
		if (!curLineas.commitBufferCursorRelation()) {
			return false;
		}
	}

	var curLineaOriginal:FLSqlCursor = new FLSqlCursor("lineasfacturascli");
	this.iface.curLineaRectificacion_ = new FLSqlCursor("lineasfacturascli");

	var camposLinea:Array = util.nombreCampos("lineasfacturascli");
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
	this.child("tdbLineasFacturasCli").refresh();

	return true;
}

function oficial_copiarCampoLineaRec(nombreCampo:String, curLineaOriginal:FLSqlCursor, factor:Number):Boolean
{
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
	
	q.setTablesList("facturascli");
	q.setSelect("codigo,fecha");
	q.setFrom("facturascli");
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
	flfacturac.iface.pub_mostrarTraza(this.cursor().valueBuffer("codigo"), "facturascli");
}

/** \D
Actualiza (borra y reconstruye) los datos referentes a la factura en la tabla de agrupaciones por IVA (lineasivafactcli)
@param idFactura: Identificador de la factura
\end */
function oficial_actualizarLineasIva(curFactura:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	var idFactura:String;
	try {
		idFactura = curFactura.valueBuffer("idfactura");
	} catch (e) {
		// Antes se recibía sólo idFactura
		MessageBox.critical(util.translate("scripts", "Hay un problema con la actualización de su personalización."), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var netoExacto:Number = curFactura.valueBuffer("neto");
	var lineasSinIVA:Number = util.sqlSelect("lineasfacturascli", "SUM(pvptotal)", "idfactura = " + idFactura + " AND iva IS NULL");
	lineasSinIVA = (isNaN(lineasSinIVA) ? 0 : lineasSinIVA);
	netoExacto -= lineasSinIVA;
	netoExacto = util.roundFieldValue(netoExacto, "facturascli", "neto");

	var ivaExacto:Number = curFactura.valueBuffer("totaliva");
	var reExacto:Number = curFactura.valueBuffer("totalrecargo");
	
	if (!util.sqlDelete("lineasivafactcli", "idfactura = " + idFactura)) {
		return false;
	}

	var codImpuestoAnt:String = "";
	var codImpuesto:String = "";
	var iva:Number;
	var recargo:Number;
	var totalNeto:Number = 0;
	var totalIva:Number = 0;
	var totalRecargo:Number = 0;
	var totalLinea:Number = 0;
	var acumNeto:Number = 0;
	var acumIva:Number = 0;
	var acumRecargo:Number = 0;
	
	var curLineaIva:FLSqlCursor = new FLSqlCursor("lineasivafactcli");
	var qryLineasFactura:FLSqlQuery = new FLSqlQuery;
	with (qryLineasFactura) {
		setTablesList("lineasfacturascli");
		setSelect("codimpuesto, iva, recargo, pvptotal");
		setFrom("lineasfacturascli");
		setWhere("idfactura = " + idFactura + " AND pvptotal <> 0 AND iva IS NOT NULL ORDER BY iva, codimpuesto"); /// Se ordena primero por IVA para evitar líneas con %IVA 0 y valor != 0 cuando este iva es el último, por efectos del redondeo
		setForwardOnly(true);
	}
	if (!qryLineasFactura.exec()) {
		return false;
	}

	var regIva:String = flfacturac.iface.pub_regimenIVACliente(curFactura);
	
	
	while (qryLineasFactura.next()) {
		codImpuesto = qryLineasFactura.value("codimpuesto");
		if (codImpuestoAnt != "" && codImpuestoAnt != codImpuesto) {
			totalNeto = util.roundFieldValue(totalNeto, "lineasivafactcli", "neto");
			totalIva = util.roundFieldValue((iva * totalNeto) / 100, "lineasivafactcli", "totaliva");
			totalRecargo = util.roundFieldValue((recargo * totalNeto) / 100, "lineasivafactcli", "totalrecargo");
			totalLinea = parseFloat(totalNeto) + parseFloat(totalIva) + parseFloat(totalRecargo);
			totalLinea = util.roundFieldValue(totalLinea, "lineasivafactcli", "totallinea");
			
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
		if (regIva == "U.E." || regIva == "Exento" || regIva == "Exportaciones") {
			iva = 0;
			recargo = 0;
		} else {
			iva = parseFloat(qryLineasFactura.value("iva"));
			recargo = parseFloat(qryLineasFactura.value("recargo"));
			if (isNaN(recargo)) {
				recargo = 0;
			}
		}
		totalNeto += parseFloat(qryLineasFactura.value("pvptotal"));
	}

	totalNeto = util.roundFieldValue(netoExacto - acumNeto, "lineasivafactcli", "neto");
	totalIva = util.roundFieldValue(ivaExacto - acumIva, "lineasivafactcli", "totaliva");
	totalRecargo = util.roundFieldValue(reExacto - acumRecargo, "lineasivafactcli", "totalrecargo");
	totalLinea = parseFloat(totalNeto) + parseFloat(totalIva) + parseFloat(totalRecargo);
	totalLinea = util.roundFieldValue(totalLinea, "lineasivafactcli", "totallinea");

	codImpuestoAnt = (codImpuestoAnt == 0 ? "" : codImpuestoAnt);
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

	return true;
}

/** \D Llama a la función de actualizar líneas de IVA cuando se pulsa el botón
\end */
function oficial_actualizarIvaClicked()
{
	this.iface.actualizarLineasIva(this.cursor());
	this.child("tdbLineasIvaFactCli").refresh();
	this.child("tbnActualizarIva").enabled = false;
}

function oficial_calcularComisionAgente():Number
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var comision:Number = 0;
	var cont:Number = 0;
	var total:Number = 0;

	var qry:FLSqlQuery = new FLSqlQuery();
	
	qry.setTablesList("lineasfacturascli");
	qry.setSelect("referencia");
	qry.setFrom("lineasfacturascli");
	qry.setWhere("idfactura = " + cursor.valueBuffer("idfactura"));
	if (!qry.exec())
		return false;

	while (qry.next()) {
		var com:Number = util.sqlSelect("articulosagen", "comision", "referencia = '" + qry.value("referencia") + "' AND codagente = '" + cursor.valueBuffer("codagente") + "'");
		if (com) {
			comision += com;
			cont ++;
		}
		else {
			comision += util.sqlSelect("agentes", "porcomision", "codagente = '" + cursor.valueBuffer("codagente") + "'");
			cont ++;
		}
	}

	total = parseFloat(comision/cont);
	if (comision == 0)
		total = 0;
	return total;
}

function oficial_aplicarComision_clicked()
{
	var util:FLUtil;
	
	var idFactura:Number = this.cursor().valueBuffer("idfactura");
	if(!idFactura)
		return;
	var codAgente:String = this.cursor().valueBuffer("codagente");
	if(!codAgente || codAgente == "")
		return;

	var res:Number = MessageBox.information(util.translate("scripts", "¿Seguro que desea actualizar la comisión en todas las líneas?"), MessageBox.Yes, MessageBox.No);
	if(res != MessageBox.Yes)
		return;

	var cursor:FLSqlCursor = new FLSqlCursor("empresa");
	cursor.transaction(false);

	try {
		if(!flfacturac.iface.pub_aplicarComisionLineas(codAgente,"lineasfacturascli","idfactura = " + idFactura)) {
			cursor.rollback();
			return;
		}
		else {
			cursor.commit();
		}
	} catch (e) {
		MessageBox.critical(util.translate("scripts", "Hubo un error al aplicarse la comisión en las líneas.\n%1").arg(e), MessageBox.Ok, MessageBox.NoButton);
		cursor.rollback();
		return false;
	}

	MessageBox.information(util.translate("scripts", "La comisión se actualizó correctamente."), MessageBox.Ok, MessageBox.NoButton);
	this.iface.pbnAplicarComision.setDisabled(true);
	this.child("tdbLineasFacturasCli").refresh();
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
