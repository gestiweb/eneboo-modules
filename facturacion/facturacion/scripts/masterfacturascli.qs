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

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
