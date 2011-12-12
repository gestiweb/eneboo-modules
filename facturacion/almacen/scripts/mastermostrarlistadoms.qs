/***************************************************************************
                 mastermostrarlistadoms.qs  -  description
                             -------------------
    begin                : mar sep 16 2008
    copyright            : (C) 2008 by InfoSiAL S.L.
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var COL_FECHA;
	var COL_HORA;
	var COL_ORIG_DEST;
	var COL_TIPO_DOC;
	var COL_COD_DOC;
	var COL_CANTIDAD;
	var COL_ESTADO;
	var COL_LOTE;
	var tablaMostrarMoviStock:FLTable;
	var filaSeleccionada:Number;
	var XMLDoc:FLDomDocument = new FLDomDocument;
	var desdeUltimaReg:Object;
	var cantidadReservada:Number;
	var cantidadPteRecibir:Number;
	var cantidadAlmacen:Number

    function oficial( context ) { interna( context ); }
	function refrescarTabla(){
		return this.ctx.oficial_refrescarTabla();
	}
	function generarTabla(){
		return this.ctx.oficial_generarTabla();
	}
	function insertarLineaTabla(qry:FLSqlQuery):Boolean {
		return this.ctx.oficial_insertarLineaTabla(qry);
	}
	function identificarDocumento(qry:FLSqlQuery):Array {
		return this.ctx.oficial_identificarDocumento(qry);
	}
	function filtroTabla() {
		return this.ctx.oficial_filtroTabla();
	}
	function crearNodoRow():FLDomNode {
		return this.ctx.oficial_crearNodoRow();
	}
	function imprimir() {
		return this.ctx.oficial_imprimir();
	}
	function verDocumento() {
		return this.ctx.oficial_verDocumento();
	}
	function buscarUltimaReg() {
		return this.ctx.oficial_buscarUltimaReg();
	}
	function buscarPrimerMov() {
		return this.ctx.oficial_buscarPrimerMov()
	}
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function cambiarFilaSeleccionada(fila:Number,col:Number) {
		return this.ctx.oficial_cambiarFilaSeleccionada(fila,col);
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
function interna_init()
{
	var cursor:FLSqlCursor = this.cursor();
	this.iface.desdeUltimaReg = this.child("fdbDesdeUltimaReg");
	this.iface.tablaMostrarMoviStock = this.child("tblMoviStock");

	connect(this.child("pbnAplicarFiltro"), "clicked()", this, "iface.filtroTabla");
	connect(this.child("pbnImprimir"), "clicked()", this, "iface.imprimir");
	connect(this.child("tbnVerDocumento"), "clicked()", this, "iface.verDocumento()");
	connect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this.iface.tablaMostrarMoviStock, "clicked(int, int)", this, "iface.cambiarFilaSeleccionada()");

	this.iface.filaSeleccionada = 0;
	this.iface.bufferChanged("desdeultimareg");
	this.iface.generarTabla();
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_bufferChanged(fN:String)
{
	var cursor:FLSqlCursor = this.cursor();
	switch (fN) {
		case "desdeultimareg": {
			if(cursor.valueBuffer("desdeultimareg")) {
				this.iface.buscarUltimaReg();
			}
			else
				this.iface.buscarPrimerMov();
		}
	}
}

/** \D Compone una tabla de tantas filas como movimientos tiene el stock seleccionado*/
function oficial_generarTabla()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	this.iface.COL_FECHA = 0;
	this.iface.COL_HORA = 1;
	this.iface.COL_ORIG_DEST = 2;
	this.iface.COL_TIPO_DOC = 3;
	this.iface.COL_COD_DOC = 4;
	this.iface.COL_CANTIDAD = 5;
	this.iface.COL_ESTADO = 6;
	this.iface.COL_LOTE = 7;

	this.iface.tablaMostrarMoviStock.setNumCols(8);
	this.iface.tablaMostrarMoviStock.setColumnWidth(this.iface.COL_FECHA, 80);
	this.iface.tablaMostrarMoviStock.setColumnWidth(this.iface.COL_HORA, 70);
	this.iface.tablaMostrarMoviStock.setColumnWidth(this.iface.COL_ORIG_DEST, 240);
	this.iface.tablaMostrarMoviStock.setColumnWidth(this.iface.COL_TIPO_DOC, 140);
	this.iface.tablaMostrarMoviStock.setColumnWidth(this.iface.COL_COD_DOC, 90);
	this.iface.tablaMostrarMoviStock.setColumnWidth(this.iface.COL_CANTIDAD, 60);
	this.iface.tablaMostrarMoviStock.setColumnWidth(this.iface.COL_ESTADO, 50);
	this.iface.tablaMostrarMoviStock.setColumnWidth(this.iface.COL_LOTE, 90);

	this.iface.tablaMostrarMoviStock.setColumnLabels("/", "Fecha/Hora/Orig-Dest/Tipo doc./Documento/Cantidad/Estado/Lote");
	this.iface.tablaMostrarMoviStock.setColumnReadOnly(this.iface.COL_FECHA, true);
	this.iface.tablaMostrarMoviStock.setColumnReadOnly(this.iface.COL_HORA, true);
	this.iface.tablaMostrarMoviStock.setColumnReadOnly(this.iface.COL_ORIG_DEST, true);
	this.iface.tablaMostrarMoviStock.setColumnReadOnly(this.iface.COL_TIPO_DOC, true);
	this.iface.tablaMostrarMoviStock.setColumnReadOnly(this.iface.COL_COD_DOC, true);
	this.iface.tablaMostrarMoviStock.setColumnReadOnly(this.iface.COL_CANTIDAD, true);
	this.iface.tablaMostrarMoviStock.setColumnReadOnly(this.iface.COL_ESTADO, true);
	this.iface.tablaMostrarMoviStock.setColumnReadOnly(this.iface.COL_LOTE, true);

	this.iface.refrescarTabla();
}

function oficial_refrescarTabla()
{
	var filtro:String = "";
	var cursor:FLSqlCursor = this.cursor();

	var numFilas:Number = this.iface.tablaMostrarMoviStock.numRows();
	for (fila = numFilas - 1; fila >= 0; fila--) {
		this.iface.tablaMostrarMoviStock.removeRow(fila);
	}

	this.iface.cantidadReservada = 0;
	this.iface.cantidadPteRecibir = 0;
	this.iface.cantidadAlmacen = 0;

	var pte:Boolean = cursor.valueBuffer("pendiente");
	var reservado:Boolean = cursor.valueBuffer("reservado");
	var hecho:Boolean = cursor.valueBuffer("hecho");
	
	filtro = "idstock = " + cursor.valueBuffer("idstock");

	if (hecho && pte && reservado) {
	}
	else {
		if(hecho) {
			if (pte) {
				filtro += " AND (estado = 'HECHO' OR (estado = 'PTE' AND cantidad > 0))";
			}
			else {
				if (reservado) {
					filtro += " AND (estado = 'HECHO' OR (estado = 'PTE' AND cantidad < 0))";
				}
				else {
					filtro += " AND estado = 'HECHO'";
				}
			}
		}
		else {
			if(pte && reservado) {
				filtro += " AND estado = 'PTE'";
			}
			else {
				if (pte) {
					filtro += " AND (estado = 'PTE' AND cantidad > 0)";
				}
				else {
					if (reservado) {
						filtro += " AND (estado = 'PTE' AND cantidad < 0)";
					}
				}
			}
		}
	}

	if(this.iface.desdeUltimaReg.value()) {
		if (cursor.valueBuffer("fechadesde") && cursor.valueBuffer("fechahasta") && hecho) {
			filtro += " AND (estado = 'HECHO' AND fechareal BETWEEN '" + cursor.valueBuffer("fechadesde") + "' AND '" + cursor.valueBuffer("fechahasta") + "')";
		}
	}
	else {
		if (cursor.valueBuffer("fechadesde") && cursor.valueBuffer("fechahasta")) {
			filtro +=  " AND ((estado = 'PTE' AND fechaprev BETWEEN '" + cursor.valueBuffer("fechadesde") + "' AND '" + cursor.valueBuffer("fechahasta") + "')  OR (estado = 'HECHO' AND fechareal BETWEEN '" + cursor.valueBuffer("fechadesde") + "' AND '" + cursor.valueBuffer("fechahasta") + "'))";
		}
	}
	var qry:FLSqlQuery = new FLSqlQuery;	
	with (qry) {
		setTablesList("movistock");
		setSelect("idmovimiento, referencia, estado, cantidad, fechaprev, fechareal, horareal, codlote, idlineaac, idlineapc, idlineaap, idlineapp, idlineapr, idlineaco, idlineava, idproceso, idlineats");
		setFrom("movistock");
		setWhere(filtro + " ORDER BY fechareal, horareal, fechaprev");
		setForwardOnly(true);
	}
	if (!qry.exec()) {
		return false;
	}


	this.iface.XMLDoc.setContent("<!DOCTYPE KUGAR_DATA><KugarData/>");

	while (qry.next()) {
		if (!this.iface.insertarLineaTabla(qry)) {
			return false;
		}
	}
	this.child("tlbTotalReservada").text = "Total Reservada = " + this.iface.cantidadReservada;
	this.child("tlbTotalPteRecibir").text = "Total Pte. Recibir = " + this.iface.cantidadPteRecibir;
	this.child("tlbTotalEnAlmacen").text = "Total En Almacen = " + this.iface.cantidadAlmacen;
}

function oficial_insertarLineaTabla(qry:FLSqlQuery):Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var numLinea:Number = this.iface.tablaMostrarMoviStock.numRows();
	this.iface.tablaMostrarMoviStock.insertRows(numLinea);
	this.iface.tablaMostrarMoviStock.setText(numLinea, this.iface.COL_CANTIDAD, qry.value("cantidad"));
	this.iface.tablaMostrarMoviStock.setText(numLinea, this.iface.COL_ESTADO, qry.value("estado"));
	this.iface.tablaMostrarMoviStock.setText(numLinea, this.iface.COL_LOTE, qry.value("codlote"));
	var hora:String = qry.value("horareal");
	if (!hora) {
		hora = "";
	}

	hora = hora.toString().right(8);
	this.iface.tablaMostrarMoviStock.setText(numLinea, this.iface.COL_HORA, hora);
	var fecha:Date;
	if (qry.value("estado") == "PTE") {
		if(parseFloat(qry.value("cantidad")) > 0) {
			this.iface.cantidadPteRecibir += parseFloat(qry.value("cantidad"));
		}
		else {
			this.iface.cantidadReservada += (parseFloat(qry.value("cantidad"))*-1);
		}
		fecha = qry.value("fechaprev");
		fecha = util.dateAMDtoDMA(fecha);
		this.iface.tablaMostrarMoviStock.setText(numLinea, this.iface.COL_FECHA, fecha);
	}
	if (qry.value("estado") == "HECHO") {
		this.iface.cantidadAlmacen += parseFloat(qry.value("cantidad"));
		fecha = qry.value("fechareal");
		fecha = util.dateAMDtoDMA(fecha);
		this.iface.tablaMostrarMoviStock.setText(numLinea, this.iface.COL_FECHA, fecha);
	}

	var datosDoc:Array = [];
	datosDoc = this.iface.identificarDocumento(qry);

	this.iface.tablaMostrarMoviStock.setText(numLinea, this.iface.COL_ORIG_DEST, datosDoc["origen"]);
	this.iface.tablaMostrarMoviStock.setText(numLinea, this.iface.COL_TIPO_DOC, datosDoc["tipo"]);

	this.iface.tablaMostrarMoviStock.setText(numLinea, this.iface.COL_COD_DOC, datosDoc["codigo"]);

	var nodoRow:FLDomNode;
	var eRow:FLDomElement;
	nodoRow = this.iface.crearNodoRow();
	this.iface.XMLDoc.firstChild().appendChild(nodoRow);
	eRow = nodoRow.toElement();
	var fecha:Date;

	if (qry.value("estado") == "PTE") {
		fecha = qry.value("fechaprev");
	} 
	if (qry.value("estado") == "HECHO") {
		fecha = qry.value("fechareal");
	}

	fecha = util.dateAMDtoDMA(fecha);
	eRow.setAttribute("referencia", cursor.valueBuffer("referencia"));
	eRow.setAttribute("codalmacen", cursor.valueBuffer("codalmacen"));
	eRow.setAttribute("fecha", fecha);
	eRow.setAttribute("hora", hora);
	eRow.setAttribute("origen", datosDoc["origen"]);
	eRow.setAttribute("tipodoc", datosDoc["tipo"]);
	eRow.setAttribute("documento", datosDoc["codigo"]);
	eRow.setAttribute("cantidad", qry.value("cantidad"));
	eRow.setAttribute("codunidad", util.sqlSelect("articulos","codunidad","referencia = '" + qry.value("referencia") + "'"));
	eRow.setAttribute("estado", qry.value("estado"));
	eRow.setAttribute("codlote", qry.value("codlote"));
	eRow.setAttribute("level", 0);

	return true;
}

function oficial_crearNodoRow():FLDomNode
{
	var xmlRow:FLDomDocument = new FLDomDocument;
	xmlRow.setContent("<Row/>");
	return xmlRow.firstChild();
}

function oficial_identificarDocumento(qry:FLSqlQuery):Array
{
	var datosDoc:Array = [];
	datosDoc["tipo"] = "";
	datosDoc["codigo"] = "";
	datosDoc["origen"] = "";
	var util:FLUtil = new FLUtil();
	var qryCodigo:FLSqlQuery = new FLSqlQuery;	
	var idLineaPedido:Number = "";

	if (qry.value("estado") == "PTE") {
		if (qry.value("idproceso") && qry.value("idproceso") != "") {
			datosDoc["tipo"] = "Proceso";
			datosDoc["codigo"] = "";
			with (qryCodigo) {
				setTablesList("pr_procesos");
				setSelect("descripcion,idproceso,idlineapedidocli");
				setFrom("pr_procesos");
				setWhere("idproceso = " + qry.value("idproceso"));
				setForwardOnly(true);
			}
			if (!qryCodigo.exec()) {
				return false;
			}
			if (qryCodigo.first()) {
				idLineaPedido = qryCodigo.value("idlineapedidocli");
				if(!idLineaPedido || idLineaPedido == 0) {
					datosDoc["codigo"] = qryCodigo.value("idproceso");
					datosDoc["origen"] = qryCodigo.value("descripcion");
				}
				else {
					datosDoc["tipo"] = "";
				}
			}
			else
				return false;
		}
		if(!datosDoc["tipo"] || datosDoc["tipo"] == "" || idLineaPedido) {
			if(!idLineaPedido || idLineaPedido == 0)
				idLineaPedido = qry.value("idlineapc");
			if (idLineaPedido && idLineaPedido != 0) {
				datosDoc["tipo"] = "Pedido cliente";
				with (qryCodigo) {
					setTablesList("pedidoscli,lineaspedidoscli");
					setSelect("p.codigo, p.codcliente, p.nombrecliente");
					setFrom("pedidoscli p INNER JOIN lineaspedidoscli l ON p.idpedido = l.idpedido");
					setWhere("l.idlinea = " + idLineaPedido);
					setForwardOnly(true);
				}
				if (!qryCodigo.exec()) {
					return false;
				}
				if (qryCodigo.first()) {
					datosDoc["codigo"] = qryCodigo.value("p.codigo");
					datosDoc["origen"] = qryCodigo.value("p.codcliente") + " - " + qryCodigo.value("p.nombrecliente");
				} 
			} else if (qry.value("idlineapp") && qry.value("idlineapp") != "") {
				datosDoc["tipo"] = "Pedido proveedor";
				with (qryCodigo) {
					setTablesList("pedidosprov,lineaspedidosprov");
					setSelect("p.codigo, p.codproveedor, p.nombre");
					setFrom("pedidosprov p INNER JOIN lineaspedidosprov l ON p.idpedido = l.idpedido");
					setWhere("l.idlinea = " + qry.value("idlineapp"));
					setForwardOnly(true);
				}
				if (!qryCodigo.exec()) {
					return false;
				}
				if (qryCodigo.first()) {
					datosDoc["codigo"] = qryCodigo.value("p.codigo");
					datosDoc["origen"] = qryCodigo.value("p.codproveedor") + " - " + qryCodigo.value("p.nombre");
				} 
			}
		}
	}
	if (qry.value("estado") == "HECHO") {
		if (qry.value("idlineaac") && qry.value("idlineaac") != "") {
			datosDoc["tipo"] = "Albarán cliente";
			with (qryCodigo) {
				setTablesList("albaranescli,lineasalbaranescli");
				setSelect("a.codigo,a.codcliente,a.nombrecliente");
				setFrom("albaranescli a INNER JOIN lineasalbaranescli l ON a.idalbaran = l.idalbaran");
				setWhere("l.idlinea = " + qry.value("idlineaac"));
				setForwardOnly(true);
			}
			if (!qryCodigo.exec()) {
				return false;
			}
			if (qryCodigo.first()) {
				datosDoc["codigo"] = qryCodigo.value("a.codigo");
				datosDoc["origen"] = qryCodigo.value("a.codcliente") + " - " + qryCodigo.value("a.nombrecliente");
			} 
		} else if (qry.value("idlineaap") && qry.value("idlineaap") != "") {
			datosDoc["tipo"] = "Albarán proveedor";
			with (qryCodigo) {
				setTablesList("albaranesprov,lineasalbaranesprov");
				setSelect("a.codigo, a.codproveedor, a.nombre");
				setFrom("albaranesprov a INNER JOIN lineasalbaranesprov l ON a.idalbaran = l.idalbaran");
				setWhere("l.idlinea = " + qry.value("idlineaap"));
				setForwardOnly(true);
			}
			if (!qryCodigo.exec()) {
				return false;
			}
			if (qryCodigo.first()) {
				datosDoc["codigo"] = qryCodigo.value("a.codigo");
				datosDoc["origen"] = qryCodigo.value("a.codproveedor") + " - " + qryCodigo.value("a.nombre");
			} 
		} else if (qry.value("idlineats") && qry.value("idlineats") != "") {
			datosDoc["tipo"] = "Transferencia";
			with (qryCodigo) {
				setTablesList("transstock,lineastransstock");
				setSelect("t.fecha, t.codalmaorigen, t.codalmadestino");
				setFrom("transstock t LEFT OUTER JOIN lineastransstock l ON t.idtrans = l.idtrans");
				setWhere("l.idlinea = " + qry.value("idlineats"));
				setForwardOnly(true);
			}
			if (!qryCodigo.exec()) {
				return false;
			}
			if (qryCodigo.first()) {
				datosDoc["codigo"] = util.dateAMDtoDMA(qryCodigo.value("t.fecha"));
				datosDoc["origen"] = qryCodigo.value("t.codalmaorigen") + " -> " + qryCodigo.value("t.codalmadestino");
			} 
		} else if (qry.value("idlineaco") && qry.value("idlineaco") != "") {
			datosDoc["tipo"] = "Vta TPV";
			with (qryCodigo) {
				setTablesList("tpv_comandas,tpv_lineascomanda");
				setSelect("c.codigo");
				setFrom("tpv_comandas c LEFT OUTER JOIN tpv_lineascomanda l ON c.idtpv_comanda = l.idtpv_comanda");
				setWhere("l.idtpv_linea = " + qry.value("idlineaco"));
				setForwardOnly(true);
			}
			if (!qryCodigo.exec()) {
				return false;
			}
			if (qryCodigo.first()) {
				datosDoc["codigo"] = qryCodigo.value("c.codigo");
				datosDoc["origen"] = "";
			} 
		} else if (qry.value("idlineava") && qry.value("idlineava") != "") {
			datosDoc["tipo"] = "Devol TPV";
			with (qryCodigo) {
				setTablesList("tpv_lineasvale,tpv_lineascomanda");
				setSelect("lv.refvale, c.codigo");
				setFrom("tpv_lineasvale lv LEFT OUTER JOIN tpv_lineascomanda lc ON lv.idtpv_linea = lc.idtpv_linea LEFT OUTER JOIN tpv_comandas c ON lc.idtpv_comanda = c.idtpv_comanda");
				setWhere("lv.idlinea = " + qry.value("idlineava"));
				setForwardOnly(true);
			}
			if (!qryCodigo.exec()) {
				return false;
			}
			if (qryCodigo.first()) {
				datosDoc["origen"] = "Vale: " + qryCodigo.value("lv.refvale");
				datosDoc["codigo"] = qryCodigo.value("c.codigo");
			} 
		}
		if(!datosDoc["tipo"] || datosDoc["tipo"] == "") {
			if (qry.value("idproceso") && qry.value("idproceso") != "") {
				datosDoc["tipo"] = "Proceso";
				datosDoc["codigo"] = "";
				with (qryCodigo) {
					setTablesList("pr_procesos");
					setSelect("descripcion,idproceso");
					setFrom("pr_procesos");
					setWhere("idproceso = " + qry.value("idproceso"));
					setForwardOnly(true);
				}
				if (!qryCodigo.exec()) {
					return false;
				}
				if (qryCodigo.first()) {
					datosDoc["codigo"] = qryCodigo.value("idproceso");
					datosDoc["origen"] = qryCodigo.value("descripcion");
				} 
			}
		}
	}

	return datosDoc;
}

function oficial_filtroTabla():String
{
	this.iface.refrescarTabla();
}


function oficial_imprimir()
{
	var util:FLUtil = new FLUtil;

	var cursor:FLSqlCursor = this.cursor()
	if (!cursor.isValid())
		return;

	var nombreInforme:String = "i_mostrarlistadoms";
	var nombreReport:String = nombreInforme;
	
	var rptViewer:FLReportViewer = new FLReportViewer();
	rptViewer.setReportTemplate(nombreReport);
	rptViewer.setReportData(this.iface.XMLDoc);
	rptViewer.renderReport();
	rptViewer.exec();

}

function oficial_buscarUltimaReg()
{
	var util:FLUtil;
	var idStock:Number = this.cursor().valueBuffer("idstock");
	if(!idStock)
		return;

	var hoy:Date = new Date();

	if(!util.sqlSelect("lineasregstocks","id","idstock = " + idStock))
		this.iface.buscarPrimerMov();
	else {
		var ultFecha:String = util.sqlSelect("lineasregstocks", "fecha", "idstock = " + idStock + " ORDER BY fecha DESC, hora DESC");
		if (ultFecha && ultFecha != "") {
			this.child("fdbFechaDesde").setValue(ultFecha);
			this.child("fdbFechaHasta").setValue(hoy);
	
			var ultHora:String = util.sqlSelect("lineasregstocks", "hora", "idstock = " + idStock + " AND fecha = '" + ultFecha + "' ORDER BY hora DESC");
			if (ultHora && ultHora != "") {
				this.child("fdbHoraDesde").setValue(ultHora);
				this.child("fdbHoraHasta").setValue(hoy);
			}
		}
	}
}

function oficial_buscarPrimerMov()
{
	var util:FLUtil;
	var idStock:Number = this.cursor().valueBuffer("idstock");
	if(!idStock)
		return;

	var hoy:Date = new Date();

	var primFecha:String = util.sqlSelect("lineasregstocks", "fecha", "idstock = " + idStock + " ORDER BY fecha ASC, hora DESC");
	if (primFecha && primFecha != "") {
		this.child("fdbFechaDesde").setValue(primFecha);
		this.child("fdbFechaHasta").setValue(hoy);

			var primHora:String = util.sqlSelect("lineasregstocks", "hora", "idstock = " + idStock + " AND fecha = '" + primFecha + "' ORDER BY hora ASC");
		if (primHora && primHora != "") {
			this.child("fdbHoraDesde").setValue(primHora);
			this.child("fdbHoraHasta").setValue(hoy);
		}
	}
}

function oficial_verDocumento()
{
	if(!this.iface.filaSeleccionada && this.iface.filaSeleccionada != 0)
		return;

	var tipo:String = this.iface.tablaMostrarMoviStock.text(this.iface.filaSeleccionada, this.iface.COL_TIPO_DOC);
	if(!tipo || tipo == "")
		return;

	var identificador:String = this.iface.tablaMostrarMoviStock.text(this.iface.filaSeleccionada, this.iface.COL_COD_DOC);
	if(!identificador || identificador == "")
		return;

	var tabla:String = "";
	var where:String = "";
	
	switch (tipo) {
		case "Proceso": {
			tabla = "pr_procesos";
			where = "idproceso = " + identificador;
			break;
		}
		case "Pedido cliente": {
			tabla = "pedidoscli";
			where = "codigo = '" + identificador + "'";
			break;
		}
		case "Pedido proveedor": {
			tabla = "pedidosprov";
			where = "codigo = '" + identificador + "'";
			break;
		}
		case "Albarán cliente": {
			tabla = "albaranescli";
			where = "codigo = '" + identificador + "'";
			break;
		}
		case "Albarán proveedor": {
			tabla = "albaranesprov";
			where = "codigo = '" + identificador + "'";
			break;
		}
		case "Transferencia": {
			tabla = "transstock";
			where = "fecha = '" + identificador + "'";
			break;
		}
		case "Vta TPV":
		case "Devol TPV": {
			tabla = "tpv_comandas";
			where = "codigo = '" + identificador + "'";
			break;
		}
		default: {
			return;
			break;
		}
	}
	var cursor:FLSqlCursor = new FLSqlCursor(tabla);
	cursor.select(where);
	cursor.refreshBuffer();
	cursor.first();
	cursor.browseRecord();
}

function oficial_cambiarFilaSeleccionada(fila:Number,col:Number)
{
	this.iface.filaSeleccionada = fila;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
