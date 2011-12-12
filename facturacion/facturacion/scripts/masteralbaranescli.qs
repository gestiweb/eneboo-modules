/***************************************************************************
                 masteralbaranescli.qs  -  description
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
	/** \D @var pbnAAlbaran Botón de asociar a albarán \end */
	var pbnAAlbaran:Object;
	var pbnGFactura:Object;
	var tdbRecords:FLTableDB;
	var tbnImprimir:Object;
	var tbnAbrirCerrar:Object;
	var curFactura:FLSqlCursor;
	var curLineaFactura:FLSqlCursor;
	
    function oficial( context ) { interna( context ); } 
	function imprimir(codAlbaran:String) {
		return this.ctx.oficial_imprimir(codAlbaran);
	}
	function procesarEstado() {
		return this.ctx.oficial_procesarEstado();
	}
	function pbnGenerarFactura_clicked() {
		return this.ctx.oficial_pbnGenerarFactura_clicked();
	}
	function generarFactura(where:String, curAlbaran:FLSqlCursor, datosAgrupacion):Number {
		return this.ctx.oficial_generarFactura(where, curAlbaran, datosAgrupacion);
	}
	function copiaLineasAlbaran(idAlbaran:Number, idFactura:Number):Boolean {
		return this.ctx.oficial_copiaLineasAlbaran(idAlbaran, idFactura);
	}
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.oficial_commonCalculateField(fN, cursor);
	}
	function restarCantidad(idLineaPedido:Number, idLineaAlbaran:Number) {
		return this.ctx.oficial_restarCantidad(idLineaPedido, idLineaAlbaran);
	}
	function asociarAAlbaran() {
		return this.ctx.oficial_asociarAAlbaran();
	}
	function whereAgrupacion(curAgrupar:FLSqlCursor):String {
		return this.ctx.oficial_whereAgrupacion(curAgrupar);
	}
	function copiaLineaAlbaran(curLineaAlbaran:FLSqlCursor, idFactura:Number):Number {
		return this.ctx.oficial_copiaLineaAlbaran(curLineaAlbaran, idFactura);
	}
	function totalesFactura():Boolean {
		return this.ctx.oficial_totalesFactura();
	}
	function datosFactura(curAlbaran:FLSqlCursor, where:String, datosAgrupacion:Array):Boolean {
		return this.ctx.oficial_datosFactura(curAlbaran, where, datosAgrupacion);
	}
	function datosLineaFactura(curLineaAlbaran:FLSqlCursor):Boolean {
		return this.ctx.oficial_datosLineaFactura(curLineaAlbaran);
	}
	function dameDatosAgrupacionPedidos(curAgruparPedidos:FLSqlCursor):Array {
		return this.ctx.oficial_dameDatosAgrupacionPedidos(curAgruparPedidos);
	}
	function validarFactura(idFactura:String):Boolean {
		return this.ctx.oficial_validarFactura(idFactura);
	}
	function filtrarTabla():Boolean {
		return this.ctx.oficial_filtrarTabla();
	}
	function filtroTabla():String {
		return this.ctx.oficial_filtroTabla();
	}
	function tbnAbrirCerrar_clicked() {
		return this.ctx.oficial_tbnAbrirCerrar_clicked();
	}
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration ivaIncluido */
//////////////////////////////////////////////////////////////////
//// IVAINCLUIDO /////////////////////////////////////////////////////
class ivaIncluido extends oficial {
    function ivaIncluido( context ) { oficial( context ); } 	
	function datosLineaFactura(curLineaAlbaran:FLSqlCursor):Boolean {
		return this.ctx.ivaIncluido_datosLineaFactura(curLineaAlbaran);
	}
	function totalesFactura():Boolean {
		return this.ctx.ivaIncluido_totalesFactura();
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
	function enviarDocumento(codAlbaran:String, codCliente:String) {
		return this.ctx.envioMail_enviarDocumento(codAlbaran, codCliente);
	}
	function imprimir(codAlbaran:String) {
		return this.ctx.envioMail_imprimir(codAlbaran);
	}
}

//// ENVIO_MAIL ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration modelo347 */
/////////////////////////////////////////////////////////////////
//// MODELO347 //////////////////////////////////////////////////
class modelo347 extends envioMail {
    function modelo347( context ) { envioMail ( context ); }
    function totalesFactura():Boolean {
		return this.ctx.modelo347_totalesFactura();
	}
}
//// MODELO347 //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration rappel */
/////////////////////////////////////////////////////////////////
//// RAPPEL /////////////////////////////////////////////////////
class rappel extends modelo347 {
    function rappel( context ) { modelo347 ( context ); }
	function datosLineaFactura(curLineaAlbaran:FLSqlCursor):Boolean {
		return this.ctx.rappel_datosLineaFactura(curLineaAlbaran);
	}
}
//// RAPPEL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration batchDocs */
/////////////////////////////////////////////////////////////////
//// BATCH_DOCS /////////////////////////////////////////////////
class batchDocs extends rappel {
	var pbnBatchPedidos:Object;
    function batchDocs( context ) { rappel ( context ); }
	function init() {
		return this.ctx.batchDocs_init();
	}
	function pbnBatchPedidos_clicked() {
		return this.ctx.batchDocs_pbnBatchPedidos_clicked();
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
	function totalesFactura():Boolean {
		return this.ctx.dtoEspecial_totalesFactura();
	}
	function datosFactura(curAlbaran:FLSqlCursor, where:String, datosAgrupacion:Array):Boolean {
		return this.ctx.dtoEspecial_datosFactura(curAlbaran, where, datosAgrupacion);
	}
	function buscarPorDtoEsp(where:String):Number  {
		return this.ctx.dtoEspecial_buscarPorDtoEsp(where);
	}
}

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
	function pub_enviarDocumento(codAlbaran:String, codCliente:String) {
		return this.enviarDocumento(codAlbaran, codCliente);
	}
}

//// PUB_ENVIO_MAIL /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration ifaceCtx */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends pubEnvioMail {
    function ifaceCtx( context ) { pubEnvioMail( context ); }
	function pub_whereAgrupacion(curAgrupar:FLSqlCursor):String {
		return this.whereAgrupacion(curAgrupar);
	}
	function pub_generarFactura(where:String, curAlbaran:FLSqlCursor, datosAgrupacion:Array):Number {
		return this.generarFactura(where, curAlbaran, datosAgrupacion);
	}
	function pub_commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.commonCalculateField(fN, cursor);
	}
	function pub_restarCantidad(idLineaPedido:Number, idLineaAlbaran:Number) {
		return this.restarCantidad(idLineaPedido, idLineaAlbaran);
	}
	function pub_imprimir(codAlbaran:String) {
		return this.imprimir(codAlbaran);
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
Este es el formulario maestro de albaranes a cliente.
\end */
function interna_init()
{
	this.iface.pbnAAlbaran = this.child("pbnAsociarAAlbaran");
	this.iface.pbnGFactura = this.child("pbnGenerarFactura");
	this.iface.tdbRecords = this.child("tableDBRecords");
	this.iface.tbnImprimir = this.child("toolButtonPrint");
	this.iface.tbnAbrirCerrar = this.child("tbnAbrirCerrar");

	connect(this.iface.pbnAAlbaran, "clicked()", this, "iface.asociarAAlbaran");
	connect(this.iface.pbnGFactura, "clicked()", this, "iface.pbnGenerarFactura_clicked");
	connect(this.iface.tdbRecords, "currentChanged()", this, "iface.procesarEstado");
	connect(this.iface.tbnImprimir, "clicked()", this, "iface.imprimir");
	connect(this.iface.tbnAbrirCerrar, "clicked()", this, "iface.tbnAbrirCerrar_clicked");

	this.iface.filtrarTabla();
	this.iface.procesarEstado();
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \C
Al pulsar el botón imprimir se lanzará el informe correspondiente al albarán seleccionado (en caso de que el módulo de informes esté cargado)
\end */
function oficial_imprimir(codAlbaran:String)
{
	var util:FLUtil;
	if (sys.isLoadedModule("flfactinfo")) {
		var codigo:String;
		if (codAlbaran) {
			codigo = codAlbaran;
		} else {
			if (!this.cursor().isValid())
				return;
			codigo = this.cursor().valueBuffer("codigo");
		}

		var nombreInforme:String = "i_albaranescli";
		var idAlbaran:Number = util.sqlSelect("albaranescli","idalbaran","codigo = '" + codigo + "'");
		if (!idAlbaran) {
			return;
		}

		var curImprimir:FLSqlCursor = new FLSqlCursor("i_albaranescli");
		curImprimir.setModeAccess(curImprimir.Insert);
		curImprimir.refreshBuffer();
		curImprimir.setValueBuffer("descripcion", "temp");
		curImprimir.setValueBuffer("d_albaranescli_codigo", codigo);
		curImprimir.setValueBuffer("h_albaranescli_codigo", codigo);
		flfactinfo.iface.pub_lanzarInforme(curImprimir, nombreInforme);
	} else {
		flfactppal.iface.pub_msgNoDisponible("Informes");
	}
}

function oficial_procesarEstado()
{
		if (this.cursor().valueBuffer("ptefactura") == true)
				this.iface.pbnGFactura.setDisabled(false);
		else
				this.iface.pbnGFactura.setDisabled(true);
}

/** \C
Al pulsar el botón de generar factura se creará la factura correspondiente al albarán.
\end */
function oficial_pbnGenerarFactura_clicked()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var where:String = "idalbaran = " + cursor.valueBuffer("idalbaran");

	if (cursor.valueBuffer("ptefactura") == false) {
		MessageBox.warning(util.translate("scripts", "Ya existe la factura correspondiente a este albarán"), MessageBox.Ok, MessageBox.NoButton);
		this.iface.procesarEstado();
		return;
	}
	this.iface.pbnGFactura.setEnabled(false);

	cursor.transaction(false);
	try {
		if (this.iface.generarFactura(where, cursor))
			cursor.commit();
		else
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
Genera la factura asociada a uno o más albaranes
@param where: Sentencia where para la consulta de búsqueda de los albaranes a agrupar
@param curAlbaran: Cursor con los datos principales que se copiarán del albarán a la factura
@param datosAgrupacion: Array con los datos indicados en el formulario de agrupación de albaranes
@return True: Copia realizada con éxito, False: Error
\end */
function oficial_generarFactura(where:String, curAlbaran:FLSqlCursor, datosAgrupacion:Array):Number
{
	if (!this.iface.curFactura)
		this.iface.curFactura = new FLSqlCursor("facturascli");
	
	this.iface.curFactura.setModeAccess(this.iface.curFactura.Insert);
	this.iface.curFactura.refreshBuffer();
	
	if (!this.iface.datosFactura(curAlbaran, where, datosAgrupacion)) {
		return false;
	}
	
	if (!this.iface.curFactura.commitBuffer()) {
		return false;
	}
	
	var idFactura:Number = this.iface.curFactura.valueBuffer("idfactura");
	
	var curAlbaranes:FLSqlCursor = new FLSqlCursor("albaranescli");
	curAlbaranes.select(where);
	var idAlbaran:Number;
	while (curAlbaranes.next()) {
		curAlbaranes.setModeAccess(curAlbaranes.Edit);
		curAlbaranes.refreshBuffer();
		idAlbaran = curAlbaranes.valueBuffer("idalbaran");
		if (!this.iface.copiaLineasAlbaran(idAlbaran, idFactura)) {
			return false;
		}
		curAlbaranes.setValueBuffer("idfactura", idFactura);
		curAlbaranes.setValueBuffer("ptefactura", false);
		if (!curAlbaranes.commitBuffer()) {
			return false;
		}
	}

	this.iface.curFactura.select("idfactura = " + idFactura);
	if (this.iface.curFactura.first()) {
/*
		if (!formRecordfacturascli.iface.pub_actualizarLineasIva(idFactura))
			return false;
*/
			
		this.iface.curFactura.setModeAccess(this.iface.curFactura.Edit);
		this.iface.curFactura.refreshBuffer();
		
		if (!this.iface.totalesFactura())
			return false;
		
		if (this.iface.curFactura.commitBuffer() == false)
			return false;
	}
	if (!this.iface.validarFactura(idFactura)) {
		return false;
	}
	return idFactura;
}

function oficial_validarFactura(idFactura:String):Boolean
{
	var util:FLUtil = new FLUtil;
	/// Comprobación de R.E.
	var qryRecargo:FLSqlQuery = new FLSqlQuery;
	qryRecargo.setTablesList("facturascli,lineasfacturascli");
	qryRecargo.setSelect("f.codigo, f.nombrecliente");
	qryRecargo.setFrom("facturascli f inner join lineasfacturascli lf on f.idfactura = lf.idfactura inner join lineasfacturascli lf2 on f.idfactura = lf2.idfactura");
	qryRecargo.setWhere("f.idfactura = " + idFactura + " AND lf.recargo = 0 AND lf2.recargo <> 0");
	qryRecargo.setForwardOnly(true);
	if (!qryRecargo.exec()) {
		return false;
	}
	if (qryRecargo.first()) {
		var res:Number = MessageBox.warning(util.translate("scripts", "La factura %1 para %2 a generar tiene recargo de equivalencia sólo en algunas de sus líneas. ¿Desea continuar?").arg(qryRecargo.value("f.codigo")).arg(qryRecargo.value("f.nombrecliente")), MessageBox.Yes, MessageBox.No);
		if (res != MessageBox.Yes) {
			return false;
		}
	}
	return true;
}

/** \D Informa los datos de una factura a partir de los de uno o varios albaranes
@param	curAlbaran: Cursor que contiene los datos a incluir en la factura
@param where: Sentencia where para la consulta de búsqueda de los albaranes a agrupar
@param datosAgrupacion: Array con los datos indicados en el formulario de agrupación de albaranes
@return	True si el cálculo se realiza correctamente, false en caso contrario
\end */
function oficial_datosFactura(curAlbaran:FLSqlCursor, where:String, datosAgrupacion:Array):Boolean
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
		
	var codEjercicio:String = curAlbaran.valueBuffer("codejercicio");
	var datosDoc:Array = flfacturac.iface.pub_datosDocFacturacion(fecha, codEjercicio, "facturascli");
	if (!datosDoc.ok)
		return false;
	if (datosDoc.modificaciones == true) {
		codEjercicio = datosDoc.codEjercicio;
		fecha = datosDoc.fecha;
	}
	
	var codDir:Number = util.sqlSelect("dirclientes", "id", "codcliente = '" + curAlbaran.valueBuffer("codcliente") + "' AND domfacturacion = 'true'");
	with (this.iface.curFactura) {
		setValueBuffer("codserie", curAlbaran.valueBuffer("codserie"));
		setValueBuffer("codejercicio", codEjercicio);
		setValueBuffer("irpf", curAlbaran.valueBuffer("irpf"));
		setValueBuffer("fecha", fecha);
		setValueBuffer("hora", hora);
		setValueBuffer("codagente", curAlbaran.valueBuffer("codagente"));
		setValueBuffer("porcomision", curAlbaran.valueBuffer("porcomision"));
		setValueBuffer("codalmacen", curAlbaran.valueBuffer("codalmacen"));
		setValueBuffer("codpago", curAlbaran.valueBuffer("codpago"));
		setValueBuffer("coddivisa", curAlbaran.valueBuffer("coddivisa"));
		setValueBuffer("tasaconv", curAlbaran.valueBuffer("tasaconv"));
		setValueBuffer("codcliente", curAlbaran.valueBuffer("codcliente"));
		setValueBuffer("cifnif", curAlbaran.valueBuffer("cifnif"));
		setValueBuffer("nombrecliente", curAlbaran.valueBuffer("nombrecliente"));
		if (!codDir) {
			codDir = curAlbaran.valueBuffer("coddir")
			if (codDir == 0) {
				this.setNull("coddir");
			} else 
				setValueBuffer("coddir", curAlbaran.valueBuffer("coddir"));
			setValueBuffer("direccion", curAlbaran.valueBuffer("direccion"));
			setValueBuffer("codpostal", curAlbaran.valueBuffer("codpostal"));
			setValueBuffer("ciudad", curAlbaran.valueBuffer("ciudad"));
			setValueBuffer("provincia", curAlbaran.valueBuffer("provincia"));
			setValueBuffer("apartado", curAlbaran.valueBuffer("apartado"));
			setValueBuffer("codpais", curAlbaran.valueBuffer("codpais"));
		} else {
			setValueBuffer("coddir", codDir);
			setValueBuffer("direccion", util.sqlSelect("dirclientes","direccion","id = " + codDir));
			setValueBuffer("codpostal", util.sqlSelect("dirclientes","codpostal","id = " + codDir));
			setValueBuffer("ciudad", util.sqlSelect("dirclientes","ciudad","id = " + codDir));
			setValueBuffer("provincia", util.sqlSelect("dirclientes","provincia","id = " + codDir));
			setValueBuffer("apartado", util.sqlSelect("dirclientes","apartado","id = " + codDir));
			setValueBuffer("codpais", util.sqlSelect("dirclientes","codpais","id = " + codDir));
		}
		setValueBuffer("observaciones", curAlbaran.valueBuffer("observaciones"));
		setValueBuffer("recfinanciero", curAlbaran.valueBuffer("recfinanciero"));
		setValueBuffer("automatica", true);
	}
	return true;
}

/** \D Copia los datos de una línea de albarán en una línea de factura
@param	curLineaAlbaran: Cursor que contiene los datos a incluir en la línea de factura
@return	True si la copia se realiza correctamente, false en caso contrario
\end */
function oficial_datosLineaFactura(curLineaAlbaran:FLSqlCursor):Boolean
{
	var iva:Number, recargo:Number;
	var codImpuesto:String = curLineaAlbaran.valueBuffer("codimpuesto");
	
	with (this.iface.curLineaFactura) {
		setValueBuffer("referencia", curLineaAlbaran.valueBuffer("referencia"));
		setValueBuffer("descripcion", curLineaAlbaran.valueBuffer("descripcion"));
		setValueBuffer("pvpunitario", curLineaAlbaran.valueBuffer("pvpunitario"));
		setValueBuffer("pvpsindto", curLineaAlbaran.valueBuffer("pvpsindto"));
		setValueBuffer("cantidad", curLineaAlbaran.valueBuffer("cantidad"));
		setValueBuffer("pvptotal", curLineaAlbaran.valueBuffer("pvptotal"));
		setValueBuffer("codimpuesto", codImpuesto);
		if (curLineaAlbaran.isNull("iva")) {
			setNull("iva");
		} else {
			iva = curLineaAlbaran.valueBuffer("iva");
			if (iva != 0 && codImpuesto && codImpuesto != "") {
				iva = formRecordlineaspedidoscli.iface.pub_commonCalculateField("iva", this); /// Para cambio de IVA según fechas
			}
			setValueBuffer("iva", iva);
		}
		if (curLineaAlbaran.isNull("recargo")) {
			setNull("recargo");
		} else {
			recargo = curLineaAlbaran.valueBuffer("recargo");
			if (recargo != 0 && codImpuesto && codImpuesto != "") {
				recargo = formRecordlineaspedidoscli.iface.pub_commonCalculateField("recargo", this); /// Para cambio de IVA según fechas
			}
			setValueBuffer("recargo", recargo);
		}
		setValueBuffer("irpf", curLineaAlbaran.valueBuffer("irpf"));
		setValueBuffer("dtolineal", curLineaAlbaran.valueBuffer("dtolineal"));
		setValueBuffer("dtopor", curLineaAlbaran.valueBuffer("dtopor"));
		setValueBuffer("porcomision", curLineaAlbaran.valueBuffer("porcomision"));
		setValueBuffer("idalbaran", curLineaAlbaran.valueBuffer("idalbaran"));
	}
	return true;
}

/** \D Informa los datos de una factura referentes a totales (I.V.A., neto, etc.)
@return	True si el cálculo se realiza correctamente, false en caso contrario
\end */
function oficial_totalesFactura():Boolean
{
	with (this.iface.curFactura) {
		setValueBuffer("neto", formfacturascli.iface.pub_commonCalculateField("neto", this));
		setValueBuffer("totaliva", formfacturascli.iface.pub_commonCalculateField("totaliva", this));
		setValueBuffer("totalirpf", formfacturascli.iface.pub_commonCalculateField("totalirpf", this));
		setValueBuffer("totalrecargo", formfacturascli.iface.pub_commonCalculateField("totalrecargo", this));
		setValueBuffer("total", formfacturascli.iface.pub_commonCalculateField("total", this));
		setValueBuffer("totaleuros", formfacturascli.iface.pub_commonCalculateField("totaleuros", this));
	}
	return true;
}

/** \D
Copia las líneas de un albarán como líneas de su factura asociada
@param idAlbaran: Identificador del albarán
@param idFactura: Identificador de la factura
@return	Verdadero si no hay error, falso en caso contrario
\end */
function oficial_copiaLineasAlbaran(idAlbaran:Number, idFactura:Number):Boolean
{
	var curLineaAlbaran:FLSqlCursor = new FLSqlCursor("lineasalbaranescli");
	curLineaAlbaran.select("idalbaran = " + idAlbaran);
	
	while (curLineaAlbaran.next()) {
		curLineaAlbaran.setModeAccess(curLineaAlbaran.Browse);
		if (!this.iface.copiaLineaAlbaran(curLineaAlbaran, idFactura))
			return false;
	}
	return true;
}

/** \D
Copia una línea de albarán en su factura asociada
@param curLineaAlbaran: Cursor posicionado en la línea de albarán a copiar
@param idFactura: Identificador de la factura
@return	Identificador de la línea de factura si no hay error, falso en caso contrario
\end */
function oficial_copiaLineaAlbaran(curLineaAlbaran:FLSqlCursor, idFactura:Number):Number
{
	if (!this.iface.curLineaFactura)
		this.iface.curLineaFactura = new FLSqlCursor("lineasfacturascli");
	
	with (this.iface.curLineaFactura) {
		setModeAccess(Insert);
		refreshBuffer();
		setValueBuffer("idfactura", idFactura);
	}
	
	if (!this.iface.datosLineaFactura(curLineaAlbaran))
		return false;
		
	if (!this.iface.curLineaFactura.commitBuffer())
			return false;
	
	return this.iface.curLineaFactura.valueBuffer("idlinea");
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
			recFinanciero = parseFloat(util.roundFieldValue(recFinanciero, "albaranescli", "total"));
			valor = neto - totalIrpf + totalIva + totalRecargo + recFinanciero;
			valor = parseFloat(util.roundFieldValue(valor, "albaranescli", "total"));
			break;
		}
		case "lblComision": {
			valor = (parseFloat(cursor.valueBuffer("porcomision")) * (parseFloat(cursor.valueBuffer("neto")))) / 100;
			valor = parseFloat(util.roundFieldValue(valor, "albaranescli", "total"));
			break;
		}
		case "lblRecFinanciero": {
			valor = (parseFloat(cursor.valueBuffer("recfinanciero")) * (parseFloat(cursor.valueBuffer("neto")))) / 100;
			valor = parseFloat(util.roundFieldValue(valor, "albaranescli", "total"));
			break;
		}
		/** \C
		El --totaleuros-- es el producto del --total-- por la --tasaconv--
		\end */
		case "totaleuros": {
			var total:Number = parseFloat(cursor.valueBuffer("total"));
			var tasaConv:Number = parseFloat(cursor.valueBuffer("tasaconv"));
			valor = total * tasaConv;
			valor = parseFloat(util.roundFieldValue(valor, "albaranescli", "totaleuros"));
			break;
		}
		/** \C
		El --neto-- es la suma del pvp total de las líneas de albarán
		\end */
		case "neto": {
			valor = util.sqlSelect("lineasalbaranescli", "SUM(pvptotal)", "idalbaran = " + cursor.valueBuffer("idalbaran"));
			valor = parseFloat(util.roundFieldValue(valor, "albaranescli", "neto"));
			break;
		}
		/** \C
		El --totaliva-- es la suma del iva correspondiente a las líneas de albarán
		\end */
		case "totaliva": {
			var codCli:String = cursor.valueBuffer("codcliente");
			var regIva:String = flfacturac.iface.pub_regimenIVACliente(cursor);
			if(regIva == "U.E." || regIva == "Exento" || regIva == "Exportaciones"){
				valor = 0;
				break;
			}
			valor = util.sqlSelect("lineasalbaranescli", "SUM((pvptotal * iva) / 100)", "idalbaran = " + cursor.valueBuffer("idalbaran"));
			valor = parseFloat(util.roundFieldValue(valor, "albaranescli", "totaliva"));
			break;
		}
		/** \C
		El --totarecargo-- es la suma del recargo correspondiente a las líneas de albarán
		\end */
		case "totalrecargo": {
			var regIva:String = flfacturac.iface.pub_regimenIVACliente(cursor);
			if(regIva == "U.E." || regIva == "Exento" || regIva == "Exportaciones"){
				valor = 0;
				break;
			}
			valor = util.sqlSelect("lineasalbaranescli", "SUM((pvptotal * recargo) / 100)", "idalbaran = " + cursor.valueBuffer("idalbaran"));
			valor = parseFloat(util.roundFieldValue(valor, "albaranescli", "totalrecargo"));
			break;
		}
		/** \C
		El --coddir-- corresponde a la dirección del cliente marcada como dirección de facturación
		\end */
		case "coddir": {
			valor = util.sqlSelect("dirclientes", "id", "codcliente = '" + cursor.valueBuffer("codcliente") + "' AND domenvio = 'true'");
			if (!valor) {
				valor = "";
			}
			break;
		}
		/** \C
		El --irpf-- es el asociado a la --codserie-- del albarán
		\end */
		case "irpf": {
			valor = util.sqlSelect("series", "irpf", "codserie = '" + cursor.valueBuffer("codserie") + "'");
			break;
		}
		/** \C
		El --totalirpf-- es el producto del --irpf-- por el --neto--
		\end */
		case "totalirpf": {
			valor = util.sqlSelect("lineasalbaranescli", "SUM((pvptotal * irpf) / 100)", "idalbaran = " + cursor.valueBuffer("idalbaran"));
// 			valor = (parseFloat(cursor.valueBuffer("irpf")) * (parseFloat(cursor.valueBuffer("neto")))) / 100;
			valor = parseFloat(util.roundFieldValue(valor, "albaranescli", "totalirpf"));
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

/** \C
Al pulsar el botón de asociar a albarán se abre la ventana de agrupar pedidos de cliente
\end */
function oficial_asociarAAlbaran()
{
	var util:FLUtil = new FLUtil;
	var f:Object = new FLFormSearchDB("agruparpedidoscli");
	var cursor:FLSqlCursor = f.cursor();
	var where:String;
	var codCliente:String;
	var codAlmacen:String;

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
		var curAgruparPedidos:FLSqlCursor = new FLSqlCursor("agruparpedidoscli");
		curAgruparPedidos.select();
		if (curAgruparPedidos.first()) {
				where = this.iface.whereAgrupacion(curAgruparPedidos);
				var excepciones = curAgruparPedidos.valueBuffer("excepciones");
				if (!excepciones.isEmpty())
						where += " AND idpedido NOT IN (" + excepciones + ")";

				var qryAgruparPedidos = new FLSqlQuery;
				qryAgruparPedidos.setTablesList("pedidoscli");
				qryAgruparPedidos.setSelect("codcliente,codalmacen");
				qryAgruparPedidos.setFrom("pedidoscli");
				qryAgruparPedidos.setWhere(where + " GROUP BY codcliente,codalmacen");
				if (!qryAgruparPedidos.exec())
						return;
						
				var totalClientes:Number = qryAgruparPedidos.size();
				util.createProgressDialog(util.translate("scripts", "Generando albaranes"), totalClientes);
				util.setProgress(1);
				var j:Number = 0; 
				
				var curPedido :FLSqlCursor= new FLSqlCursor("pedidoscli");
				var whereAlbaran:String;
				var datosAgrupacion:Array = [];
				while (qryAgruparPedidos.next()) {
						codCliente = qryAgruparPedidos.value(0);
						codAlmacen = qryAgruparPedidos.value(1);
						whereAlbaran = where;
						if(codCliente && codCliente != "")
							whereAlbaran += " AND codcliente = '" + codCliente + "'";
						if(codAlmacen && codAlmacen != "")
							whereAlbaran += " AND codalmacen = '" + codAlmacen + "'";
						curPedido.transaction(false);
						try {
							curPedido.select(whereAlbaran);
							if (!curPedido.first()) {
								curPedido.rollback();
								util.destroyProgressDialog();
								return;
							}
			
							datosAgrupacion = this.iface.dameDatosAgrupacionPedidos(curAgruparPedidos);
							if (formpedidoscli.iface.pub_generarAlbaran(whereAlbaran, curPedido, datosAgrupacion)) {
							curPedido.commit();
							} else {
								curPedido.rollback();
								util.destroyProgressDialog();
								return;
							
							}
						} catch (e) {
							curPedido.rollback();
							MessageBox.critical(util.translate("scripts", "Error al generar el albarán:") + e, MessageBox.Ok, MessageBox.NoButton);
						}
							util.setProgress(++j);
				}		
				util.setProgress(totalClientes);
				util.destroyProgressDialog();
			}
			f.close();
			this.iface.tdbRecords.refresh();
	}
}

/** \D
Construye un array con los datos del albarán a generar especificados en el formulario de agrupación de pedidos
@param curAgruparPedidos: Cursor de la tabla agruparpedidoscli que contiene los valores
@return Array
\end */
function oficial_dameDatosAgrupacionPedidos(curAgruparPedidos:FLSqlCursor):Array
{
	var res:Array = [];
	res["fecha"] = curAgruparPedidos.valueBuffer("fecha");
	res["hora"] = curAgruparPedidos.valueBuffer("hora");
	return res;
}


/** \D
Construye la sentencia WHERE de la consulta que buscará los pedidos a agrupar
@param curAgrupar: Cursor de la tabla agruparpedidoscli que contiene los valores de los criterios de búsqueda
@return Sentencia where
\end */
function oficial_whereAgrupacion(curAgrupar:FLSqlCursor):String
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
		var where:String = "servido <> 'Sí'";
		if (codCliente && !codCliente.isEmpty())
				where += " AND codcliente = '" + codCliente + "'";
		if (cifNif && !cifNif.isEmpty())
				where += " AND cifnif = '" + cifNif + "'";
		if (codAlmacen && !codAlmacen.isEmpty())
				where = where + " AND codalmacen = '" + codAlmacen + "'";
		where = where + " AND fecha >= '" + fechaDesde + "'";
		where = where + " AND fecha <= '" + fechaHasta + "'";
		if (codPago && !codPago.isEmpty() != "")
				where = where + " AND codpago = '" + codPago + "'";
		if (codDivisa && !codDivisa.isEmpty())
				where = where + " AND coddivisa = '" + codDivisa + "'";
		if (codSerie && !codSerie.isEmpty())
				where = where + " AND codserie = '" + codSerie + "'";
		if (codEjercicio && !codEjercicio.isEmpty())
				where = where + " AND codejercicio = '" + codEjercicio + "'";
		return where;
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

function oficial_tbnAbrirCerrar_clicked()
{
	var util:FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var idAlbaran:Number = cursor.valueBuffer("idalbaran");
	if (!idAlbaran) {
		MessageBox.warning(util.translate("scripts", "No hay ningún albarán seleccionado"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	var codAlbaran:String = cursor.valueBuffer("codigo");

	var cerrar:Boolean = true;
	var res:Number;
	if (!cursor.isNull("idfactura") && cursor.valueBuffer("idfactura")) {
		MessageBox.warning(util.translate("scripts", "El albarán ya está facturado"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	var editable:Boolean = cursor.valueBuffer("ptefactura")
	if (editable) {
		res = MessageBox.information(util.translate("scripts", "Se va a cerrar el albarán %1 y no podrá facturarse.\n¿Desea continuar?").arg(codAlbaran), MessageBox.Yes, MessageBox.No);
		if (res != MessageBox.Yes) {
			return;
		}
	} else {
		res = MessageBox.information(util.translate("scripts", "Se va a reabrir el albarán %1.\n¿Desea continuar?").arg(codAlbaran), MessageBox.Yes, MessageBox.No);
		if (res != MessageBox.Yes) {
			return;
		}
	}
	cursor.setUnLock("ptefactura", !editable);
	this.iface.tdbRecords.refresh();
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition ivaIncluido */
//////////////////////////////////////////////////////////////////
//// IVAINCLUIDO /////////////////////////////////////////////////////
/** \D Copia los datos de una línea de albarán en una línea de factura
@param	curLineaAlbaran: Cursor que contiene los datos a incluir en la línea de factura
@return	True si la copia se realiza correctamente, false en caso contrario
\end */
function ivaIncluido_datosLineaFactura(curLineaAlbaran:FLSqlCursor):Boolean
{
	if (!this.iface.__datosLineaFactura(curLineaAlbaran)) {
		return false;
	}
	with (this.iface.curLineaFactura) {
		setValueBuffer("ivaincluido", curLineaAlbaran.valueBuffer("ivaincluido"));
		setValueBuffer("pvpunitarioiva", curLineaAlbaran.valueBuffer("pvpunitarioiva"));
	}
	/// El cambio puede deberse a que la fecha del nuevo documento esté asociada a un tipo de IVA distinto del documento origens
	if (curLineaAlbaran.valueBuffer("iva") != this.iface.curLineaFactura.valueBuffer("iva")) {
		if (this.iface.curLineaFactura.valueBuffer("ivaincluido")) {
			this.iface.curLineaFactura.setValueBuffer("pvpunitario", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpunitario2", this.iface.curLineaFactura));
			this.iface.curLineaFactura.setValueBuffer("pvpsindto", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpsindto", this.iface.curLineaFactura));
			this.iface.curLineaFactura.setValueBuffer("pvptotal", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotal", this.iface.curLineaFactura));
		}
	}
	
	return true;
}

function ivaIncluido_totalesFactura():Boolean
{
	this.iface.__totalesFactura();

	// Comprobar redondeo y recalcular totales
	formRecordfacturascli.iface.comprobarRedondeoIVA(this.iface.curFactura, "idfactura")
	with (this.iface.curFactura) {
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

function envioMail_enviarDocumento(codAlbaran:String, codCliente:String)
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	if (!codAlbaran) {
		codAlbaran = cursor.valueBuffer("codigo");
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
	var asunto:String = util.translate("scripts", "Albaran %1").arg(codAlbaran);
	var rutaDocumento:String = rutaIntermedia + "A_" + codAlbaran + ".pdf";

	var util:FLUtil = new FLUtil;
	var codigo:String;
	if (codAlbaran) {
		codigo = codAlbaran;
	} else {
		if (!cursor.isValid()) {
			return;
		}
		codigo = cursor.valueBuffer("codigo");
	}
	
	var numCopias:Number = util.sqlSelect("albaranescli a INNER JOIN clientes c ON c.codcliente = a.codcliente", "c.copiasfactura", "a.codigo = '" + codigo + "'", "albaranescli,clientes");
	if (!numCopias) {
		numCopias = 1;
	}
		
	var curImprimir:FLSqlCursor = new FLSqlCursor("i_albaranescli");
	curImprimir.setModeAccess(curImprimir.Insert);
	curImprimir.refreshBuffer();
	curImprimir.setValueBuffer("descripcion", "temp");
	curImprimir.setValueBuffer("d_albaranescli_codigo", codigo);
	curImprimir.setValueBuffer("h_albaranescli_codigo", codigo);
	flfactinfo.iface.pub_lanzarInforme(curImprimir, "i_albaranescli", "", "", false, false, "", "i_albaranescli", 1, rutaDocumento, true);

	var arrayDest:Array = [];
	arrayDest[0] = [];
	arrayDest[0]["tipo"] = "to";
	arrayDest[0]["direccion"] = emailCliente;

	var arrayAttach:Array = [];
	arrayAttach[0] = rutaDocumento;

	flfactppal.iface.pub_enviarCorreo(cuerpo, asunto, arrayDest, arrayAttach);
}

function envioMail_imprimir(codAlbaran:String)
{
	var util:FLUtil = new FLUtil;
	
	var datosEMail:Array = [];
	datosEMail["tipoInforme"] = "albaranescli";
	var codCliente:String;
	if (codAlbaran && codAlbaran != "") {
		datosEMail["codDestino"] = util.sqlSelect("albaranescli", "codcliente", "codigo = '" + codAlbaran + "'");
		datosEMail["codDocumento"] = codAlbaran;
	} else {
		var cursor:FLSqlCursor = this.cursor();
		datosEMail["codDestino"] = cursor.valueBuffer("codcliente");
		datosEMail["codDocumento"] = cursor.valueBuffer("codigo");
	}
	flfactinfo.iface.datosEMail = datosEMail;
	this.iface.__imprimir(codAlbaran);
}

//// ENVIO_MAIL /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition modelo347 */
/////////////////////////////////////////////////////////////////
//// MODELO 347 /////////////////////////////////////////////////
function modelo347_totalesFactura():Boolean
{
	if (!this.iface.__totalesFactura()) {
		return false;
	}
	with (this.iface.curFactura) {
		setValueBuffer("nomodelo347", formfacturascli.iface.pub_commonCalculateField("nomodelo347", this));
	}
	return true;
}
//// MODELO 347 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition rappel */
/////////////////////////////////////////////////////////////////
//// RAPPEL /////////////////////////////////////////////////////
/** \D Copia los datos de una línea de albarán en una línea de factura añadiendo el dato de descuento por rappel a una línea de factura
@param	curLineaAlbaran: Cursor que contiene los datos a incluir en la línea de factura
@return	True si la copia se realiza correctamente, false en caso contrario
\end */
function rappel_datosLineaFactura(curLineaAlbaran:FLSqlCursor):Boolean
{
	if(!this.iface.__datosLineaFactura(curLineaAlbaran))
		return false;

	with (this.iface.curLineaFactura) {
		setValueBuffer("dtorappel", curLineaAlbaran.valueBuffer("dtorappel"));
	}
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
		
		this.iface.pbnBatchPedidos = this.child("pbnBatchPedidos");
		connect(this.iface.pbnBatchPedidos, "clicked()", this, "iface.pbnBatchPedidos_clicked()");
}

/** \C
Al pulsar el botón de Batch de albaranes se abre la ventana de batch de albaranes de cliente
\end */
function batchDocs_pbnBatchPedidos_clicked()
{
	var f:Object = new FLFormSearchDB("agruparpedidoscli");
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
		var curAgruparPedidos:FLSqlCursor = new FLSqlCursor("agruparpedidoscli");
		curAgruparPedidos.select();
		if (curAgruparPedidos.first()) {
			where = this.iface.whereAgrupacion(curAgruparPedidos);
			var excepciones:String = curAgruparPedidos.valueBuffer("excepciones");
			if (!excepciones.isEmpty())
				where += " AND idpedido NOT IN (" + excepciones + ")";

			var qryAgruparPedidos:FLSqlQuery = new FLSqlQuery;
			qryAgruparPedidos.setTablesList("pedidoscli");
			qryAgruparPedidos.setSelect("idpedido");
			qryAgruparPedidos.setFrom("pedidoscli");
			qryAgruparPedidos.setWhere(where);

			if (!qryAgruparPedidos.exec())
				return;

			var curPedido:FLSqlCursor = new FLSqlCursor("pedidoscli");
			var whereAlbaran:String;
			while (qryAgruparPedidos.next()) {
				whereAlbaran = "idpedido = " + qryAgruparPedidos.value(0);
				curPedido.transaction(false);
				curPedido.select(whereAlbaran);
				if (!curPedido.first()) {
					curPedido.rollback();
					return;
				}
				curPedido.setValueBuffer("fecha", curAgruparPedidos.valueBuffer("fecha"));
				if (formpedidoscli.iface.pub_generarAlbaran(whereAlbaran, curPedido)) {
					curPedido.commit();
				} else {
					curPedido.rollback();
					return;
				}
			}
		}

		f.close();
		this.iface.tdbRecords.refresh();
	}
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
debug("Calculando " + fN);
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
			valor = util.sqlSelect("lineasalbaranescli", "SUM((pvptotal * iva * (100 - " + porDto + ")) / 100 / 100)", "idalbaran = " + cursor.valueBuffer("idalbaran"));
			valor = parseFloat(util.roundFieldValue(valor, "albaranescli", "totaliva"));
			break;
		}
	/** \C
	El --totarecargo-- es la suma del recargo correspondiente a las líneas de factura
	*/
		case "totalrecargo": {
			var porDto:Number = cursor.valueBuffer("pordtoesp");
			if (!porDto || porDto == 0) {
				valor = this.iface.__commonCalculateField(fN, cursor);
				break;
			}
			valor = util.sqlSelect("lineasalbaranescli", "SUM((pvptotal * recargo * (100 - " + porDto + ")) / 100 / 100)", "idalbaran = " + cursor.valueBuffer("idalbaran"));
			valor = parseFloat(util.roundFieldValue(valor, "albaranescli", "totalrecargo"));
			break;
		}
	/** \C
	El --netosindtoesp-- es la suma del pvp total de las líneas de factura
	*/
		case "netosindtoesp": {
			valor = this.iface.__commonCalculateField("neto", cursor); 
			break;
		}
	/** \C
	El --neto-- es el --netosindtoesp-- menos el --dtoesp--
	*/
		case "neto": {
			valor = parseFloat(cursor.valueBuffer("netosindtoesp")) - parseFloat(cursor.valueBuffer("dtoesp"));
			valor = parseFloat(util.roundFieldValue(valor, "albaranescli", "neto"));
			break;
		}
	/** \C
	El --dtoesp-- es el --netosindtoesp-- menos el porcentaje que marca el --pordtoesp--
	*/
		case "dtoesp": {
			valor = (parseFloat(cursor.valueBuffer("netosindtoesp")) * parseFloat(cursor.valueBuffer("pordtoesp"))) / 100;
			valor = parseFloat(util.roundFieldValue(valor, "albaranescli", "dtoesp"));
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
			valor = parseFloat(util.roundFieldValue(valor, "albaranescli", "pordtoesp"));
			break;
		}
		default: {
			valor = this.iface.__commonCalculateField(fN, cursor);
			break;
		}
	}
	return valor;
}

/** \D Informa los datos de una factura referentes a totales (I.V.A., neto, etc.)
@return	True si el cálculo se realiza correctamente, false en caso contrario
\end */
function dtoEspecial_totalesFactura():Boolean
{
	with(this.iface.curFactura) {
		setValueBuffer("netosindtoesp", formfacturascli.iface.pub_commonCalculateField("netosindtoesp", this));
		setValueBuffer("dtoesp", formfacturascli.iface.pub_commonCalculateField("dtoesp", this));
		setValueBuffer("neto", formfacturascli.iface.pub_commonCalculateField("neto", this));
		setValueBuffer("totaliva", formfacturascli.iface.pub_commonCalculateField("totaliva", this));
		setValueBuffer("totalirpf", formfacturascli.iface.pub_commonCalculateField("totalirpf", this));
		setValueBuffer("totalrecargo", formfacturascli.iface.pub_commonCalculateField("totalrecargo", this));
		setValueBuffer("total", formfacturascli.iface.pub_commonCalculateField("total", this));
		setValueBuffer("totaleuros", formfacturascli.iface.pub_commonCalculateField("totaleuros", this));
	}
	
	return true;
}

/** \D Informa los datos de una factura a partir de los de uno o varios albaranes
@param	curAlbaran: Cursor que contiene los datos a incluir en la factura
@return	True si el cálculo se realiza correctamente, false en caso contrario
\end */
function dtoEspecial_datosFactura(curAlbaran:FLSqlCursor,where:String,datosAgrupacion:Array):Boolean
{
	var util:FLUtil = new FLUtil();
	var porDtoEsp:Number = this.iface.buscarPorDtoEsp(where);
	if (porDtoEsp == -1) {
		MessageBox.critical(util.translate("scripts", "No es posible generar un único albarán para pedidos con distinto porcentaje de descuento especial"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	
	var fecha:String;
	if (curAlbaran.action() == "albaranescli") {
		var hoy:Date = new Date();
		fecha = hoy.toString();
	} else
		fecha = curAlbaran.valueBuffer("fecha");
	
	with (this.iface.curFactura) {
		setValueBuffer("pordtoesp", porDtoEsp);
	}
	if(!this.iface.__datosFactura(curAlbaran, where, datosAgrupacion))
		return false;

	return true;
}

/** \D
Busca el porcentaje de descuento especial realizado a los albaranes que se agruparán en una factura. Si existen dos pedidos con distinto porcentaje devuelve un código de error.
@param where: Cláusula where para buscar los pedidos
@return porcenteje de descuento (-1 si hay error);
*/
function dtoEspecial_buscarPorDtoEsp(where:String):Number
{
	var util:FLUtil = new FLUtil;
	var porDtoEsp:Number = util.sqlSelect("albaranescli", "pordtoesp", where);
	var porDtoEsp2:Number = util.sqlSelect("albaranescli", "pordtoesp", where + " AND pordtoesp <> " + porDtoEsp);
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