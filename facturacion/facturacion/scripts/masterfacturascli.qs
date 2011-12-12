/***************************************************************************
                 masterfacturascli.qs  -  description
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
	function calculateField(fN:String):String {this.ctx.interna_calculateField(fN); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var pbnAFactura:Object;
	var tbnImprimir:Object;
	var tdbRecords:FLTableDB;
	var curFactura:FLSqlCursor;
	var curLineaFactura:FLSqlCursor;
	
    function oficial( context ) { interna( context ); } 
	function imprimir(codFactura:String) {
		return this.ctx.oficial_imprimir(codFactura);
	}
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.oficial_commonCalculateField(fN, cursor);
	}
	function asociarAFactura() {
		return this.ctx.oficial_asociarAFactura();
	}
	function whereAgrupacion(curAgrupar:FLSqlCursor):String {
		return this.ctx.oficial_whereAgrupacion(curAgrupar);
	}
	function copiarFactura_clicked() {
		return this.ctx.oficial_copiarFactura_clicked();
	}
	function copiarFactura(curFactura:FLSqlCursor):Number {
		return this.ctx.oficial_copiarFactura(curFactura);
	}
	function copiadatosFactura(curFactura:FLSqlCursor):Boolean {
		return this.ctx.oficial_copiadatosFactura(curFactura);
	}
	function copiaLineasFactura(idFacturaOrigen:Number,idFacturaDestino:Number):Boolean {
		return this.ctx.oficial_copiaLineasFactura(idFacturaOrigen,idFacturaDestino);
	}
	function copiaLineaFactura(curLineaFactura:FLSqlCursor, idFactura:Number):Number {
		return this.ctx.oficial_copiaLineaFactura(curLineaFactura, idFactura);
	}
	function totalesFactura():Boolean {
		return this.ctx.oficial_totalesFactura();
	}
	function copiadatosLineaFactura(curLineaFactura:FLSqlCursor):Boolean {
		return this.ctx.oficial_copiadatosLineaFactura(curLineaFactura);
	}
	function dameDatosAgrupacionAlbaranes(curAgruparAlbaranes:FLSqlCursor):Array {
		return this.ctx.oficial_dameDatosAgrupacionAlbaranes(curAgruparAlbaranes);
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
//// ENVIO MAIL /////////////////////////////////////////////////
class envioMail extends oficial {
    function envioMail( context ) { oficial ( context ); }
	function init() { 
		return this.ctx.envioMail_init(); 
	}
	function enviarDocumento(codFactura:String, codCliente:String) {
		return this.ctx.envioMail_enviarDocumento(codFactura, codCliente);
	}
	function imprimir(codFactura:String) {
		return this.ctx.envioMail_imprimir(codFactura);
	}
}
//// ENVIO MAIL /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration modelos */
/////////////////////////////////////////////////////////////////
//// BASE MODELOS ///////////////////////////////////////////////
class modelos extends envioMail {
	var tbnModelos:Object;
	function modelos( context ) { envioMail ( context ); }
	function init() {
		return this.ctx.modelos_init();
	}
	function tbnModelos_clicked() {
		return this.ctx.modelos_tbnModelos_clicked();
	}
	function completarOpcionesModelos(arrayOps:Array):Boolean {
		return this.ctx.modelos_completarOpcionesModelos(arrayOps);
	}
	function ejecutarOpcionModelo(opcion:String):Boolean {
		return this.ctx.modelos_ejecutarOpcionModelo(opcion);
	}
	function obtenerOpcionModelo(arrayOps:Array):String {
		return this.ctx.modelos_obtenerOpcionModelo(arrayOps);
	}
	function configurarBotonModelos() {
		return this.ctx.modelos_configurarBotonModelos();
	}
}
//// BASE MODELOS ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration modelo347 */
/////////////////////////////////////////////////////////////////
//// MODELO 347 /////////////////////////////////////////////////
class modelo347 extends modelos {
    function modelo347( context ) { modelos ( context ); }
	function completarOpcionesModelos(arrayOps:Array):Boolean {
		return this.ctx.modelo347_completarOpcionesModelos(arrayOps);
	}
	function ejecutarOpcionModelo(opcion:String):Boolean {
		return this.ctx.modelo347_ejecutarOpcionModelo(opcion);
	}
	function incluirExcluir347(incluir:Boolean):Boolean {
		return this.ctx.modelo347_incluirExcluir347(incluir);
	}
	function incluirExcluir347Trans(incluir:Boolean):Boolean {
		return this.ctx.modelo347_incluirExcluir347Trans(incluir);
	}
	function configurarBotonModelos() {
		return this.ctx.modelo347_configurarBotonModelos();
	}
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.modelo347_commonCalculateField(fN, cursor);
	}
	function totalesFactura():Boolean {
		return this.ctx.modelo347_totalesFactura();
	}
}
//// MODELO 347 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration modelo303 */
/////////////////////////////////////////////////////////////////
//// MODELO 303 /////////////////////////////////////////////////
class modelo303 extends modelo347 {
    function modelo303( context ) { modelo347 ( context ); }
	function completarOpcionesModelos(arrayOps:Array):Boolean {
		return this.ctx.modelo303_completarOpcionesModelos(arrayOps);
	}
	function ejecutarOpcionModelo(opcion:String):Boolean {
		return this.ctx.modelo303_ejecutarOpcionModelo(opcion);
	}
	function configurarBotonModelos() {
		return this.ctx.modelo303_configurarBotonModelos();
	}
}
//// MODELO 303 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration batchDocs */
/////////////////////////////////////////////////////////////////
//// BATCH_DOCS /////////////////////////////////////////////////
class batchDocs extends modelo303 {
    function batchDocs( context ) { modelo303 ( context ); }
	function init() {
		return this.ctx.batchDocs_init();
	}
	function pbnBatchAlbaranes_clicked():Boolean {
		return this.ctx.batchDocs_pbnBatchAlbaranes_clicked();
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
	function copiadatosFactura(curFactura:FLSqlCursor):Boolean {
		return this.ctx.dtoEspecial_copiadatosFactura(curFactura);
	}
	function totalesFactura():Boolean {
		return this.ctx.dtoEspecial_totalesFactura();
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
	function pub_whereAgrupacion(curAgrupar:FLSqlCursor):String {
		return this.whereAgrupacion(curAgrupar);
	}
	function pub_commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.commonCalculateField(fN, cursor);
	}
	function pub_imprimir(codFactura:String):String {
		return this.imprimir(codFactura);
	}
}
const iface = new pubEnvioMail( this );
//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubEnvioMail */
/////////////////////////////////////////////////////////////////
//// PUB ENVIO MAIL /////////////////////////////////////////////
class pubEnvioMail extends ifaceCtx {
    function pubEnvioMail( context ) { ifaceCtx ( context ); }
	function pub_enviarDocumento(codFactura:String, codCliente:String) {
		return this.enviarDocumento(codFactura, codCliente);
	}
}
//// PUB ENVIO MAIL /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition interna */
////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
/** \C
Este es el formulario maestro de facturas a cliente.
\end */
function interna_init()
{
	this.iface.pbnAFactura = this.child("pbnAsociarAFactura");
	this.iface.tbnImprimir = this.child("toolButtonPrint");
	this.iface.tdbRecords= this.child("tableDBRecords");

	connect(this.iface.tbnImprimir, "clicked()", this, "iface.imprimir");
	connect(this.iface.pbnAFactura, "clicked()", this, "iface.asociarAFactura()");
	connect(this.child("toolButtonCopy"), "clicked()", this, "iface.copiarFactura_clicked()");
	
	this.iface.filtrarTabla();
}

function interna_calculateField(fN:String):String
{
	return this.iface.commonCalculateField(fN, this.cursor());
	/** \C
	El --código-- se construye como la concatenación de --codserie--, --codejercicio-- y --numero--
	\end */
	/** \C
	El --total-- es el --neto-- menos el --totalirpf-- más el --totaliva-- más el --totalrecargo-- más el --recfinanciero--
	\end */
	/** \C
	El --totaleuros-- es el producto del --total-- por la --tasaconv--
	\end */
	/** \C
	El --neto-- es la suma del pvp total de las líneas de factura
	\end */
	/** \C
	El --totaliva-- es la suma del iva correspondiente a las líneas de factura
	\end */
	/** \C
	El --totarecargo-- es la suma del recargo correspondiente a las líneas de factura
	\end */
	/** \C
	El --coddir-- corresponde a la dirección del cliente marcada como dirección de facturación
	\end */
	/** \C
	El --irpf-- es el asociado al --codserie-- del albarán
	\end */
	/** \C
	El --totalirpf-- es el producto del --irpf-- por el --neto--
	\end */
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \C
Al pulsar el botón imprimir se lanzará el informe correspondiente a la factura seleccionada (en caso de que el módulo de informes esté cargado)
\end */
function oficial_imprimir(codFactura:String)
{
	if (sys.isLoadedModule("flfactinfo")) {
		
		var util:FLUtil = new FLUtil;
		var codigo:String;
		if (codFactura) {
			codigo = codFactura;
		} else {
			if (!this.cursor().isValid())
				return;
			codigo = this.cursor().valueBuffer("codigo");
		}
		
		var numCopias:Number = util.sqlSelect("facturascli f INNER JOIN clientes c ON c.codcliente = f.codcliente", "c.copiasfactura", "f.codigo = '" + codigo + "'", "facturascli,clientes");
		if (!numCopias)
			numCopias = 1;
			
		var curImprimir:FLSqlCursor = new FLSqlCursor("i_facturascli");
		curImprimir.setModeAccess(curImprimir.Insert);
		curImprimir.refreshBuffer();
		curImprimir.setValueBuffer("descripcion", "temp");
		curImprimir.setValueBuffer("d_facturascli_codigo", codigo);
		curImprimir.setValueBuffer("h_facturascli_codigo", codigo);
		flfactinfo.iface.pub_lanzarInforme(curImprimir, "i_facturascli", "", "", false, false, "", "i_facturascli", numCopias);
	} else
		flfactppal.iface.pub_msgNoDisponible("Informes");
}

function oficial_commonCalculateField(fN:String, cursor:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil();
	var valor:String;

	if (fN == "codigo")
		valor = flfacturac.iface.pub_construirCodigo(cursor.valueBuffer("codserie"), cursor.valueBuffer("codejercicio"), cursor.valueBuffer("numero"));

	switch (fN) {
		case "total": {
			var neto:Number = parseFloat(cursor.valueBuffer("neto"));
			var totalIrpf:Number = parseFloat(cursor.valueBuffer("totalirpf"));
			var totalIva:Number = parseFloat(cursor.valueBuffer("totaliva"));
			var totalRecargo:Number = parseFloat(cursor.valueBuffer("totalrecargo"));
			var recFinanciero:Number = (parseFloat(cursor.valueBuffer("recfinanciero")) * neto) / 100;
			recFinanciero = parseFloat(util.roundFieldValue(recFinanciero, "facturascli", "total"));
			valor = neto - totalIrpf + totalIva + totalRecargo + recFinanciero;
			valor = parseFloat(util.roundFieldValue(valor, "facturascli", "total"));
			break;
		}
		case "lblComision": {
			valor = (parseFloat(cursor.valueBuffer("porcomision")) * (parseFloat(cursor.valueBuffer("neto")))) / 100;
			valor = parseFloat(util.roundFieldValue(valor, "facturascli", "total"));
			break;
		}
		case "lblRecFinanciero": {
			valor = (parseFloat(cursor.valueBuffer("recfinanciero")) * (parseFloat(cursor.valueBuffer("neto")))) / 100;
			valor = parseFloat(util.roundFieldValue(valor, "facturascli", "total"));
			break;
		}
		case "totaleuros": {
			var total:Number = parseFloat(cursor.valueBuffer("total"));
			var tasaConv:Number = parseFloat(cursor.valueBuffer("tasaconv"));
			valor = total * tasaConv;
			valor = parseFloat(util.roundFieldValue(valor, "facturascli", "totaleuros"));
			valor = parseFloat(util.roundFieldValue(valor, "facturascli", "totaleuros"));
			break;
		}
		case "neto": {
			valor = util.sqlSelect("lineasfacturascli", "SUM(pvptotal)", "idfactura = " + cursor.valueBuffer("idfactura"));
			valor = parseFloat(util.roundFieldValue(valor, "facturascli", "neto"));
			break;
		}
		case "totaliva": {
			var codCli:String = cursor.valueBuffer("codcliente");
			var regIva:String = flfacturac.iface.pub_regimenIVACliente(cursor);
			if(regIva == "U.E." || regIva == "Exento" || regIva == "Exportaciones"){
				valor = 0;
				break;
			}
			valor = util.sqlSelect("lineasfacturascli", "SUM((pvptotal * iva) / 100)", "idfactura = " + cursor.valueBuffer("idfactura"));
			valor = parseFloat(util.roundFieldValue(valor, "facturascli", "totaliva"));
			break;
		}
		case "totalrecargo": {
			var codCli:String = cursor.valueBuffer("codcliente");
			var regIva:String = flfacturac.iface.pub_regimenIVACliente(cursor);
			if(regIva == "U.E." || regIva == "Exento" || regIva == "Exportaciones"){
				valor = 0;
				break;
			}
			valor = util.sqlSelect("lineasfacturascli", "SUM((pvptotal * recargo) / 100)", "idfactura = " + cursor.valueBuffer("idfactura"));
			valor = parseFloat(util.roundFieldValue(valor, "facturascli", "totalrecargo"));
			break;
		}
		case "coddir": {
			valor = util.sqlSelect("dirclientes", "id", "codcliente = '" + cursor.valueBuffer("codcliente") +  "' AND domfacturacion = 'true'");
			if (!valor) {
				valor = "";
			}
			break;
		}
		case "irpf": {
			valor = util.sqlSelect("series", "irpf", "codserie = '" + cursor.valueBuffer("codserie") + "'");
			break;
		}
		case "totalirpf": {
			valor = util.sqlSelect("lineasfacturascli", "SUM((pvptotal * irpf) / 100)", "idfactura = " + cursor.valueBuffer("idfactura"));
// 			valor = (parseFloat(cursor.valueBuffer("irpf")) * (parseFloat(cursor.valueBuffer("neto")))) / 100;
			valor = parseFloat(util.roundFieldValue(valor, "facturascli", "totalirpf"));
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
Al pulsar el botón de asociar a factura se abre la ventana de agrupar albaranes de cliente
\end */
function oficial_asociarAFactura()
{debug("oficial_asociarAFactura");
	var util:FLUtil = new FLUtil;
	var f:Object = new FLFormSearchDB("agruparalbaranescli");
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
debug("acpt " + acpt);
	if (acpt) {
		cursor.commitBuffer();
		var curAgruparAlbaranes:FLSqlCursor = new FLSqlCursor("agruparalbaranescli");
		curAgruparAlbaranes.select();
		if (curAgruparAlbaranes.first()) {
			where = this.iface.whereAgrupacion(curAgruparAlbaranes);
			var excepciones:String = curAgruparAlbaranes.valueBuffer("excepciones");
			if (!excepciones.isEmpty())
				where += " AND idalbaran NOT IN (" + excepciones + ")";

			var qryAgruparAlbaranes:FLSqlCursor = new FLSqlQuery;
			qryAgruparAlbaranes.setTablesList("albaranescli");
			qryAgruparAlbaranes.setSelect("codcliente,codalmacen");
			qryAgruparAlbaranes.setFrom("albaranescli");
			qryAgruparAlbaranes.setWhere(where + " GROUP BY codcliente,codalmacen");

			if (!qryAgruparAlbaranes.exec())
				return;
debug(qryAgruparAlbaranes.sql());
			var totalClientes:Number = qryAgruparAlbaranes.size();
			util.createProgressDialog(util.translate("scripts", "Generando facturas"), totalClientes);
			util.setProgress(1);
			var j:Number = 0;
			
			var curAlbaran:FLSqlCursor = new FLSqlCursor("albaranescli");
			var whereFactura:String;
			var datosAgrupacion:Array = [];
			while (qryAgruparAlbaranes.next()) {
				codCliente = qryAgruparAlbaranes.value(0);
				codAlmacen = qryAgruparAlbaranes.value(1);
				whereFactura = where;
				if(codCliente && codCliente != "")
					 whereFactura += " AND codcliente = '" + codCliente + "'";
				if(codAlmacen && codAlmacen != "")
					whereFactura += " AND codalmacen = '" + codAlmacen + "'";
debug("whereFactura " + whereFactura);
				curAlbaran.transaction(false);
				try {
					curAlbaran.select(whereFactura);
					if (!curAlbaran.first()) {
						curAlbaran.rollback();
						util.destroyProgressDialog();debug("return 1");
						return;
					}
					
					datosAgrupacion = this.iface.dameDatosAgrupacionAlbaranes(curAgruparAlbaranes);
					if (formalbaranescli.iface.pub_generarFactura(whereFactura, curAlbaran, datosAgrupacion)) {
						curAlbaran.commit();
					} else {
						MessageBox.warning(util.translate("scripts", "Falló la inserción de la factura correspondiente al cliente: ") + codCliente, MessageBox.Ok, MessageBox.NoButton);
						curAlbaran.rollback();
						util.destroyProgressDialog();
						return;
					}
				} catch (e) {
					curAlbaran.rollback();
					MessageBox.critical(util.translate("scripts", "Error al generar la factura:") + e, MessageBox.Ok, MessageBox.NoButton);
				}
				util.setProgress(++j);
			}
			util.setProgress(totalClientes);
			util.destroyProgressDialog();
		}

		f.close();
		this.iface.tdbRecords.refresh();
	}debug("FIN");
}

/** \D
Construye un array con los datos de la factura a generar especificados en el formulario de agrupación de albaranes
@param curAgruparAlbaranes: Cursor de la tabla agruparalbaranescli que contiene los valores
@return Array
\end */
function oficial_dameDatosAgrupacionAlbaranes(curAgruparAlbaranes:FLSqlCursor):Array
{
	var res:Array = [];
	res["fecha"] = curAgruparAlbaranes.valueBuffer("fecha");
	res["hora"] = curAgruparAlbaranes.valueBuffer("hora");
	return res;
}

/** \D
Construye la sentencia WHERE de la consulta que buscará los albaranes a agrupar
@param curAgrupar: Cursor de la tabla agruparalbaranescli que contiene los valores de los criterios de búsqueda
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
	var where:String = "albaranescli.ptefactura = 'true'";
	if (codCliente && !codCliente.isEmpty())
		where += " AND albaranescli.codcliente = '" + codCliente + "'";
	if (cifNif && !cifNif.isEmpty())
		where += " AND albaranescli.cifnif = '" + cifNif + "'";
	if (codAlmacen && !codAlmacen.isEmpty())
		where = where + " AND albaranescli.codalmacen = '" + codAlmacen + "'";
	where = where + " AND albaranescli.fecha >= '" + fechaDesde + "'";
	where = where + " AND albaranescli.fecha <= '" + fechaHasta + "'";
	if (codPago && !codPago.isEmpty())
		where = where + " AND albaranescli.codpago = '" + codPago + "'";
	if (codDivisa && !codDivisa.isEmpty())
		where = where + " AND albaranescli.coddivisa = '" + codDivisa + "'";
	if (codSerie && !codSerie.isEmpty())
		where = where + " AND albaranescli.codserie = '" + codSerie + "'";
	if (codEjercicio && !codEjercicio.isEmpty())
		where = where + " AND albaranescli.codejercicio = '" + codEjercicio + "'";
	return where;
}

function oficial_copiarFactura_clicked()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	cursor.transaction(false);
	try {
		if (this.iface.copiarFactura(cursor))
			cursor.commit();
		else
			cursor.rollback();
	}
	catch (e) {
		cursor.rollback();
		MessageBox.critical(util.translate("scripts", "Hubo un error en la copia de la factura:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
	}
	
	this.iface.tdbRecords.refresh();
}


function oficial_copiarFactura(curFactura:FLSqlCursor):Number
{
	var util:FLUtil = new FLUtil();

	if (!this.iface.curFactura)
		this.iface.curFactura = new FLSqlCursor("facturascli");

	util.createProgressDialog(util.translate("scripts", "Copiando Factura...."), 3);
	var progreso = 0;

	this.iface.curFactura.setModeAccess(this.iface.curFactura.Insert);
	this.iface.curFactura.refreshBuffer();
	
	progreso = 1;
	util.setProgress(progreso);

	if (!this.iface.copiadatosFactura(curFactura)) {
		util.destroyProgressDialog();
		return false;
	}

	if (!this.iface.curFactura.commitBuffer()) {
		util.destroyProgressDialog();
		return false;
	}
	
	var idFactura:Number = this.iface.curFactura.valueBuffer("idfactura");

	progreso = 2;
	util.setProgress(progreso);

	if (!this.iface.copiaLineasFactura(curFactura.valueBuffer("idfactura"), idFactura)) {
		util.destroyProgressDialog(); 
		return false;
	}
	
	this.iface.curFactura.select("idfactura = " + idFactura);
	if (this.iface.curFactura.first()) {
		this.iface.curFactura.setModeAccess(this.iface.curFactura.Edit);
		this.iface.curFactura.refreshBuffer();
	
		progreso = 3;
		util.setProgress(progreso);
	
		if (!this.iface.totalesFactura()) {
			util.destroyProgressDialog();
			return false;
		}
		if (this.iface.curFactura.commitBuffer() == false) {
			util.destroyProgressDialog();
			return false;
		}
	}
	util.destroyProgressDialog();
	return idFactura;
}

function oficial_copiadatosFactura(curFactura:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	var fecha:String;
	var hora:String;
	if (curFactura.action() == "facturascli") {
		var hoy:Date = new Date();
		fecha = hoy.toString();
		hora = hoy.toString().right(8);
	} else {
		fecha = curFactura.valueBuffer("fecha");
		hora = curFactura.valueBuffer("hora");
	}
	var codEjercicio:String = curFactura.valueBuffer("codejercicio");
	var datosDoc:Array = flfacturac.iface.pub_datosDocFacturacion(fecha, codEjercicio, "facturascli");
	if (!datosDoc.ok)
		return false;
	if (datosDoc.modificaciones == true) {
		codEjercicio = datosDoc.codEjercicio;
		fecha = datosDoc.fecha;
	}
	
	var codDir:Number = util.sqlSelect("dirclientes", "id", "codcliente = '" + curFactura.valueBuffer("codcliente") + "' AND domfacturacion = 'true'");
	with (this.iface.curFactura) {
		setValueBuffer("codserie", curFactura.valueBuffer("codserie"));
		setValueBuffer("codejercicio", codEjercicio);
		setValueBuffer("irpf", curFactura.valueBuffer("irpf"));
		setValueBuffer("fecha", fecha);
		setValueBuffer("hora", hora);
		setValueBuffer("codagente", curFactura.valueBuffer("codagente"));
		setValueBuffer("porcomision", curFactura.valueBuffer("porcomision"));
		setValueBuffer("codalmacen", curFactura.valueBuffer("codalmacen"));
		setValueBuffer("codpago", curFactura.valueBuffer("codpago"));
		setValueBuffer("coddivisa", curFactura.valueBuffer("coddivisa"));
		setValueBuffer("tasaconv", curFactura.valueBuffer("tasaconv"));
		setValueBuffer("codcliente", curFactura.valueBuffer("codcliente"));
		setValueBuffer("cifnif", curFactura.valueBuffer("cifnif"));
		setValueBuffer("nombrecliente", curFactura.valueBuffer("nombrecliente"));
		if (!codDir) {
			codDir = curFactura.valueBuffer("coddir")
			if (codDir == 0) {
				this.setNull("coddir");
			} else 
				setValueBuffer("coddir", curFactura.valueBuffer("coddir"));
				setValueBuffer("direccion", curFactura.valueBuffer("direccion"));
				setValueBuffer("codpostal", curFactura.valueBuffer("codpostal"));
				setValueBuffer("ciudad", curFactura.valueBuffer("ciudad"));
				setValueBuffer("provincia", curFactura.valueBuffer("provincia"));
				setValueBuffer("apartado", curFactura.valueBuffer("apartado"));
				setValueBuffer("codpais", curFactura.valueBuffer("codpais"));
		} else {
			setValueBuffer("coddir", codDir);
			setValueBuffer("direccion", util.sqlSelect("dirclientes","direccion","id = " + codDir));
			setValueBuffer("codpostal", util.sqlSelect("dirclientes","codpostal","id = " + codDir));
			setValueBuffer("ciudad", util.sqlSelect("dirclientes","ciudad","id = " + codDir));
			setValueBuffer("provincia", util.sqlSelect("dirclientes","provincia","id = " + codDir));
			setValueBuffer("apartado", util.sqlSelect("dirclientes","apartado","id = " + codDir));
			setValueBuffer("codpais", util.sqlSelect("dirclientes","codpais","id = " + codDir));
		}
		setValueBuffer("recfinanciero", curFactura.valueBuffer("recfinanciero"));
		setValueBuffer("automatica", false);
		setValueBuffer("observaciones", curFactura.valueBuffer("observaciones"));
		setValueBuffer("editable", true);
		setValueBuffer("nogenerarasiento", curFactura.valueBuffer("nogenerarasiento"));
		setNull("idasiento");
		setValueBuffer("deabono", curFactura.valueBuffer("deabono"));
		setValueBuffer("idfacturarect", curFactura.valueBuffer("idfacturarect"));
		setValueBuffer("codigorect", curFactura.valueBuffer("codigorect"));
		setValueBuffer("tpv", false);
		if (curFactura.valueBuffer("idpagodevol") != 0)
			setValueBuffer("idpagodevol", curFactura.valueBuffer("idpagodevol"));
	}
	return true;
}

function oficial_copiaLineasFactura(idFacturaOrigen:Number, idFacturaDestino:Number):Boolean
{
	var curLineaFactura:FLSqlCursor = new FLSqlCursor("lineasfacturascli");
	curLineaFactura.select("idfactura = " + idFacturaOrigen);
	
	while (curLineaFactura.next()) {
		curLineaFactura.setModeAccess(curLineaFactura.Browse);
		if (!this.iface.copiaLineaFactura(curLineaFactura, idFacturaDestino))
			return false;
	}
	return true;
}

function oficial_copiaLineaFactura(curLineaFactura:FLSqlCursor, idFactura:Number):Number
{
	if (!this.iface.curLineaFactura)
		this.iface.curLineaFactura = new FLSqlCursor("lineasfacturascli");
	
	with (this.iface.curLineaFactura) {
		setModeAccess(Insert);
		refreshBuffer();
		setValueBuffer("idfactura", idFactura);
	}
	
	if (!this.iface.copiadatosLineaFactura(curLineaFactura))
		return false;
		
	if (!this.iface.curLineaFactura.commitBuffer())
			return false;
	
	return this.iface.curLineaFactura.valueBuffer("idlinea");
}

function oficial_copiadatosLineaFactura(curLineaFactura:FLSqlCursor):Boolean
{
	with (this.iface.curLineaFactura) {
		setValueBuffer("referencia", curLineaFactura.valueBuffer("referencia"));
		setValueBuffer("descripcion", curLineaFactura.valueBuffer("descripcion"));
		setValueBuffer("pvpunitario", curLineaFactura.valueBuffer("pvpunitario"));
		setValueBuffer("pvpsindto", curLineaFactura.valueBuffer("pvpsindto"));
		setValueBuffer("cantidad", curLineaFactura.valueBuffer("cantidad"));
		setValueBuffer("pvptotal", curLineaFactura.valueBuffer("pvptotal"));
		setValueBuffer("codimpuesto", curLineaFactura.valueBuffer("codimpuesto"));
		setValueBuffer("irpf", curLineaFactura.valueBuffer("irpf"));
		setValueBuffer("iva", curLineaFactura.valueBuffer("iva"));
		setValueBuffer("recargo", curLineaFactura.valueBuffer("recargo"));
		setValueBuffer("dtolineal", curLineaFactura.valueBuffer("dtolineal"));
		setValueBuffer("dtopor", curLineaFactura.valueBuffer("dtopor"));
	}
	return true;
}


function oficial_totalesFactura():Boolean
{
	with (this.iface.curFactura) {
		setValueBuffer("neto", formfacturascli.iface.pub_commonCalculateField("neto", this));
		setValueBuffer("totaliva", formfacturascli.iface.pub_commonCalculateField("totaliva", this));
		setValueBuffer("totalrecargo", formfacturascli.iface.pub_commonCalculateField("totalrecargo", this));
		setValueBuffer("totalirpf", formfacturascli.iface.pub_commonCalculateField("totalirpf", this));
		setValueBuffer("total", formfacturascli.iface.pub_commonCalculateField("total", this));
		setValueBuffer("totaleuros", formfacturascli.iface.pub_commonCalculateField("totaleuros", this));
	}
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

/** @class_definition envioMail */
/////////////////////////////////////////////////////////////////
//// ENVIO MAIL /////////////////////////////////////////////////
function envioMail_init()
{
	this.iface.__init();
	//this.child("tbnEnviarMail").close();
	connect(this.child("tbnEnviarMail"), "clicked()", this, "iface.enviarDocumento()");
}

function envioMail_enviarDocumento(codFactura:String, codCliente:String)
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	if (!codFactura) {
		codFactura = cursor.valueBuffer("codigo");
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
	var asunto:String = util.translate("scripts", "Factura %1").arg(codFactura);
	var rutaDocumento:String = rutaIntermedia + "F_" + codFactura + ".pdf";

	var codigo:String;
	if (codFactura) {
		codigo = codFactura;
	} else {
		if (!cursor.isValid()) {
			return;
		}
		codigo = cursor.valueBuffer("codigo");
	}
	
	var numCopias:Number = util.sqlSelect("facturascli f INNER JOIN clientes c ON c.codcliente = f.codcliente", "c.copiasfactura", "f.codigo = '" + codigo + "'", "facturascli,clientes");
	if (!numCopias) {
		numCopias = 1;
	}
		
	var curImprimir:FLSqlCursor = new FLSqlCursor("i_facturascli");
	curImprimir.setModeAccess(curImprimir.Insert);
	curImprimir.refreshBuffer();
	curImprimir.setValueBuffer("descripcion", "temp");
	curImprimir.setValueBuffer("d_facturascli_codigo", codigo);
	curImprimir.setValueBuffer("h_facturascli_codigo", codigo);
	flfactinfo.iface.pub_lanzarInforme(curImprimir, "i_facturascli", "", "", false, false, "", "i_facturascli", 1, rutaDocumento, true);

	var arrayDest:Array = [];
	arrayDest[0] = [];
	arrayDest[0]["tipo"] = "to";
	arrayDest[0]["direccion"] = emailCliente;

	var arrayAttach:Array = [];
	arrayAttach[0] = rutaDocumento;

	flfactppal.iface.pub_enviarCorreo(cuerpo, asunto, arrayDest, arrayAttach);
}

function envioMail_imprimir(codFactura:String)
{
	var util:FLUtil = new FLUtil;
	
	var datosEMail:Array = [];
	datosEMail["tipoInforme"] = "facturascli";
	var codCliente:String;
	if (codFactura && codFactura != "") {
		datosEMail["codDestino"] = util.sqlSelect("facturascli", "codcliente", "codigo = '" + codFactura + "'");
		datosEMail["codDocumento"] = codFactura;
	} else {
		var cursor:FLSqlCursor = this.cursor();
		datosEMail["codDestino"] = cursor.valueBuffer("codcliente");
		datosEMail["codDocumento"] = cursor.valueBuffer("codigo");
	}
	flfactinfo.iface.datosEMail = datosEMail;
	this.iface.__imprimir(codFactura);
}
//// ENVIO MAIL /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition modelos */
/////////////////////////////////////////////////////////////////
//// BASE MODELOS ///////////////////////////////////////////////
function modelos_init()
{
	this.iface.__init();

	this.iface.tbnModelos = this.child("tbnModelos");
	connect (this.iface.tbnModelos, "clicked()", this, "iface.tbnModelos_clicked");
	this.iface.configurarBotonModelos();
}

function modelos_tbnModelos_clicked()
{
	var arrayOpciones:Array = [];
	if (!this.iface.completarOpcionesModelos(arrayOpciones)) {
		return false;
	}
	var opcion:String = this.iface.obtenerOpcionModelo(arrayOpciones);
	if (!opcion) {
		return false;
	}
	if (!this.iface.ejecutarOpcionModelo(opcion)) {
		return false;
	}
}

function modelos_completarOpcionesModelos(arrayOps:Array):Boolean
{
// 	var i:Number = arrayOps.length;
// 	arrayOps[i] = [];
// 	arrayOps[i]["texto"] = "prueba";
// 	arrayOps[i]["opcion"] = "PB";
	return true;
}

function modelos_ejecutarOpcionModelo(opcion:String):Boolean
{
// 	debug("Opción = " + opcion);
	return true;
}

function modelos_obtenerOpcionModelo(arrayOps:Array):String
{
	var util:FLUtil = new FLUtil;
	var dialogo = new Dialog;
	dialogo.okButtonText = util.translate("scripts", "Aceptar");
	dialogo.cancelButtonText = util.translate("scripts", "Cancelar");
	
	var gbxDialogo = new GroupBox;
	gbxDialogo.title = util.translate("scripts", "Seleccione opción");
	
	var rButton:Array = new Array(arrayOps.length);
	for (var i:Number = 0; i < rButton.length; i++) {
		rButton[i] = new RadioButton;
		rButton[i].text = arrayOps[i]["texto"];
		rButton[i].checked = false;
		gbxDialogo.add(rButton[i]);
	}
	
	dialogo.add(gbxDialogo);
	if (!dialogo.exec()) {
		return false;
	}
	for (var i:Number = 0; i < rButton.length; i++) {
		if (rButton[i].checked) {
			return arrayOps[i]["opcion"];
		}
	}
	return false;
}

function modelos_configurarBotonModelos()
{
	this.child("tbnModelos").close();
}

//// BASE MODELOS ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition modelo347 */
/////////////////////////////////////////////////////////////////
//// MODELO 347 /////////////////////////////////////////////////
function modelo347_completarOpcionesModelos(arrayOps:Array):Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	var idFactura:String = cursor.valueBuffer("idfactura");
	if (!idFactura) {
		return false;
	}
	var codFactura:String = cursor.valueBuffer("codigo");
	var noModelo347:Boolean = cursor.valueBuffer("nomodelo347");
	var i:Number = arrayOps.length;
	arrayOps[i] = [];
	if (noModelo347) {
		arrayOps[i]["texto"] = util.translate("scripts", "Incluir factura %1 en modelo 347").arg(codFactura);
		arrayOps[i]["opcion"] = "347S";
	} else {
		arrayOps[i]["texto"] = util.translate("scripts", "Excluir factura %1 de modelo 347").arg(codFactura);
		arrayOps[i]["opcion"] = "347N";
	}
	return true;
}

function modelo347_ejecutarOpcionModelo(opcion:String):Boolean
{
	switch (opcion) {
		case "347S": {
			this.iface.incluirExcluir347(true);
			break;
		}
		case "347N": {
			this.iface.incluirExcluir347(false);
			break;
		}
		default: {
			this.iface.__ejecutarOpcionModelo(opcion);
		}
	}
	return true;
}

function modelo347_incluirExcluir347(incluir:Boolean):Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var curTrans:FLSqlCursor = new FLSqlCursor("empresa");
	curTrans.transaction(false);
	try {
		if (this.iface.incluirExcluir347Trans(incluir)) {
			curTrans.commit();
		} else {
			curTrans.rollback();
			MessageBox.warning(util.translate("scripts", "Error al incluir/excluir la factura del modelo 347"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	} catch (e) {
		curTrans.rollback();
		MessageBox.critical(util.translate("scripts", "Error al incluir/excluir la factura del modelo 347: ") + e, MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	this.iface.tdbRecords.refresh();
	if (incluir) {
		MessageBox.information(util.translate("scripts", "Factura incluida correctamente"), MessageBox.Ok, MessageBox.NoButton);
	} else {
		MessageBox.information(util.translate("scripts", "Factura excluida correctamente"), MessageBox.Ok, MessageBox.NoButton);
	}
	return true;
}

function modelo347_incluirExcluir347Trans(incluir:Boolean):Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var idFactura:String = cursor.valueBuffer("idfactura");
	if (!idFactura) {
		return false;
	}
	if (!flfacturac.iface.pub_cambiarCampoRegistroBloqueado("facturascli", "idfactura", idFactura, "nomodelo347", !incluir, "editable")) {
		return false;
	}
	var idAsiento:String = cursor.valueBuffer("idasiento");
	if (!idAsiento) {
		return false;
	}
	if (!flfacturac.iface.pub_cambiarCampoRegistroBloqueado("co_asientos", "idasiento", idAsiento, "nomodelo347", !incluir, "editable")) {
		return false;
	}
	return true;
}

function modelo347_configurarBotonModelos()
{
	return true; //this.child("tbnModelos").close();
}

function modelo347_commonCalculateField(fN:String, cursor:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil();
	var valor:String;

	switch (fN) {
		case "nomodelo347": {
			var totalIrpf:Number = parseFloat(cursor.valueBuffer("totalirpf"));
			if (totalIrpf != 0) {
				valor = true;
			} else {
				valor = false;
			}
			break;
		}
		default : {
			valor = this.iface.__commonCalculateField(fN, cursor);
			break;
		}
	}
	return valor;
}

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

/** @class_definition modelo303 */
/////////////////////////////////////////////////////////////////
//// MODELO 303 /////////////////////////////////////////////////
function modelo303_configurarBotonModelos()
{
	return true;
}

function modelo303_completarOpcionesModelos(arrayOps:Array):Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var i:Number = arrayOps.length;
	arrayOps[i] = [];
	if (cursor.valueBuffer("excluir303")) {
		arrayOps[i]["texto"] = util.translate("scripts", "Incluir en modelo 303");
		arrayOps[i]["opcion"] = "303IN";
	} else {
		arrayOps[i]["texto"] = util.translate("scripts", "Excluir de modelo 303");
		arrayOps[i]["opcion"] = "303EX";
	}
	return true;
}

function modelo303_ejecutarOpcionModelo(opcion:String):Boolean
{
debug("modelo303_ejecutarOpcionModelo = " + opcion);
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	if (opcion != "303IN" && opcion != "303EX") {
		return this.iface.__ejecutarOpcionModelo(opcion);
	}

	var curFactura:FLSqlCursor = new FLSqlCursor("facturascli");
	curFactura.setActivatedCheckIntegrity(false);
	curFactura.setActivatedCommitActions(false);
	var idFactura:String = cursor.valueBuffer("idfactura");
	curFactura.select("idfactura = " + idFactura);
	if (!curFactura.first()) {
		return false;
	}

	var editable:Boolean = curFactura.valueBuffer("editable");
	if (!editable) {
		curFactura.setUnLock("editable", true);
		curFactura.select("idfactura = " + idFactura);
		if (!curFactura.first()) {
			return false;
		}
	}

	curFactura.setModeAccess(curFactura.Edit);
	curFactura.refreshBuffer();
	if (opcion == "303EX") {
		curFactura.setValueBuffer("excluir303", true);
	} else {
		curFactura.setValueBuffer("excluir303", false);
	}
	if (!curFactura.commitBuffer()) {
		return false;
	}

	if (!editable) {
		curFactura.select("idfactura = " + idFactura);
		if (!curFactura.first()) {
			return false;
		}
		curFactura.setUnLock("editable", false);
	}

	if (opcion == "303EX") {
		MessageBox.information(util.translate("scripts", "La factura %1 será excluida del modelo 303").arg(cursor.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
	} else {
		MessageBox.information(util.translate("scripts", "La factura %1 será incluida en el modelo 303").arg(cursor.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
	}
	this.iface.tdbRecords.refresh();
	return true;
}

//// MODELO 303 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition batchDocs */
/////////////////////////////////////////////////////////////////
//// BATCH_DOCS /////////////////////////////////////////////////
function batchDocs_init()
{
	this.iface.__init();
		
	pbnBatchAlbaranes = this.child("pbnBatchAlbaranes");
	connect(pbnBatchAlbaranes, "clicked()", this, "iface.pbnBatchAlbaranes_clicked()");
}

/** \C
Al pulsar el botón de Batch de albaranes se abre la ventana de batch de albaranes de cliente
*/
function batchDocs_pbnBatchAlbaranes_clicked():Boolean
{
	var f:Object = new FLFormSearchDB("agruparalbaranescli");
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
		var curAgruparAlbaranes:FLSqlCursor = new FLSqlCursor("agruparalbaranescli");
		curAgruparAlbaranes.select();
		if (curAgruparAlbaranes.first()) {
			where = this.iface.whereAgrupacion(curAgruparAlbaranes);
			var excepciones:String = curAgruparAlbaranes.valueBuffer("excepciones");
			if (!excepciones.isEmpty())
				where += " AND idalbaran NOT IN (" + excepciones + ")";

			var qryAgruparAlbaranes:FLSqlQuery = new FLSqlQuery;
			qryAgruparAlbaranes.setTablesList("albaranescli");
			qryAgruparAlbaranes.setSelect("idalbaran");
			qryAgruparAlbaranes.setFrom("albaranescli");
			qryAgruparAlbaranes.setWhere(where);

			if (!qryAgruparAlbaranes.exec())
				return false;

			var curAlbaran:FLSqlCursor = new FLSqlCursor("albaranescli");
			var whereFactura:String;
			while (qryAgruparAlbaranes.next()) {
				whereFactura = "idalbaran = " + qryAgruparAlbaranes.value(0);
				curAlbaran.transaction(false);
				curAlbaran.select(whereFactura);
				if (!curAlbaran.first()) {
					curAlbaran.rollback();
					return false;
				}
				curAlbaran.setValueBuffer("fecha", curAgruparAlbaranes.valueBuffer("fecha"));
				if (formalbaranescli.iface.pub_generarFactura(whereFactura, curAlbaran)) {
					curAlbaran.commit();
				} else {
					curAlbaran.rollback();
					return false;
				}
			}
		}
		
		f.close();
		if (this.iface.tdbRecords)
			this.iface.tdbRecords.refresh();
	}  else {
		f.close();
		return false;
	}
	
	return true;
}
//// BATCH_DOCS /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/** @class_definition dtoEspecial */
/////////////////////////////////////////////////////////////////
//// DTO ESPECIAL ///////////////////////////////////////////////
function dtoEspecial_commonCalculateField(fN:String, cursor:FLSqlCursor):String
{
	var util = new FLUtil();
	var valor;

	switch (fN) {
		case "totaliva": {
			var porDto:Number = cursor.valueBuffer("pordtoesp");
			if (!porDto || porDto == 0) {
				valor = this.iface.__commonCalculateField(fN, cursor);
				break;
			}
			var codCli:String = cursor.valueBuffer("codcliente");
			var regIva:String = util.sqlSelect("clientes", "regimeniva", "codcliente = '" + codCli + "'");
			if (regIva == "U.E." || regIva == "Exento") {
				valor = 0;
				break;
			}
			valor = util.sqlSelect("lineasfacturascli", "SUM((pvptotal * iva * (100 - " + porDto + ")) / 100 / 100)", "idfactura = " + cursor.valueBuffer("idfactura"));
			valor = parseFloat(util.roundFieldValue(valor, "facturascli", "totaliva"));
			break;
		}
		case "totalrecargo": {
			var porDto:Number = cursor.valueBuffer("pordtoesp");
			if (!porDto || porDto == 0) {
				valor = this.iface.__commonCalculateField(fN, cursor);
				break;
			}
			var codCli:String = cursor.valueBuffer("codcliente");
			var regIva:String = util.sqlSelect("clientes", "regimeniva", "codcliente = '" + codCli + "'");
			if (regIva == "U.E." || regIva == "Exento") {
				valor = 0;
				break;
			}
			valor = util.sqlSelect("lineasfacturascli", "SUM((pvptotal * recargo * (100 - " + porDto + ")) / 100 / 100)", "idfactura = " + cursor.valueBuffer("idfactura"));
			valor = parseFloat(util.roundFieldValue(valor, "facturascli", "totalrecargo"));
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
			valor = parseFloat(util.roundFieldValue(valor, "facturascli", "neto"));
			break;
		}
	/** \C
	El --dtoesp-- es el --netosindtoesp-- menos el porcentaje que marca el --pordtoesp--
	\end */
		case "dtoesp": {
			valor = (parseFloat(cursor.valueBuffer("netosindtoesp")) * parseFloat(cursor.valueBuffer("pordtoesp"))) / 100;
			valor = parseFloat(util.roundFieldValue(valor, "facturascli", "dtoesp"));
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
			valor = parseFloat(util.roundFieldValue(valor, "facturascli", "pordtoesp"));
			break;
		}
		default: {
			valor = this.iface.__commonCalculateField(fN, cursor);
			break;
		}
	}
	return valor;
}

function dtoEspecial_copiadatosFactura(curFactura:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	var porDtoEsp:Number = curFactura.valueBuffer("pordtoesp");
	
	var fecha:String;
	if (curFactura.action() == "facturascli") {
		var hoy:Date = new Date();
		fecha = hoy.toString();
	} else
		fecha = curFactura.valueBuffer("fecha");
	
	with (this.iface.curFactura) {
		setValueBuffer("pordtoesp", porDtoEsp);
	}
	
	if(!this.iface.__copiadatosFactura(curFactura))
		return false;

	return true;
}

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

//// DTO ESPECIAL ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
//////////////////////////////////////////////////////