/***************************************************************************
                 seleccionarticulos.qs  -  descripcion
                             -------------------
    begin                : 22-01-2007
    copyright            : (C) 2007 by Mathias Behrle
    email                : mathiasb@behrle.dyndns.org
    partly based on code by
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
	var pbnRStockOrd:Object;
// 	var tdbArticulos:Object;
// 	var tdbArticulosSel:Object;
	var pbnAceptar:Object;
	var COL_REF:Number;
	var COL_DES:Number;
	var COL_SMIN:Number;
	var COL_SFIS:Number;
	var COL_PREC:Number;
	var COL_PEDIR:Number;
	var COL_SEL:Number;
	var tblArticulos:FLTable;
	var colorVerde:Color;
	var colorBlanco:Color;

    function oficial( context ) { interna( context ); } 
	function desconectar() {
		return this.ctx.oficial_desconectar();
	}
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function incluirFila(iFila:Number, iCol:Number, sel:String) {
		return this.ctx.oficial_incluirFila(iFila, iCol, sel);
	}
	function generarTabla() {
		return this.ctx.oficial_generarTabla();
	}
	function cargarTabla() {
		return this.ctx.oficial_cargarTabla();
	}
	function limpiarTabla() {
		return this.ctx.oficial_limpiarTabla();
	}
	function buscar() {
		return this.ctx.oficial_buscar();
	}
	function colorearFila(iFila:Number) {
		return this.ctx.oficial_colorearFila(iFila);
	}
	function pbnResetearStockOrd_clicked() {
		return this.ctx.oficial_pbnResetearStockOrd_clicked();
	}
	function seleccionar() {
		return this.ctx.oficial_seleccionar();
	}
	function seleccionarTodos() {
		return this.ctx.oficial_seleccionarTodos();
	}
	function quitar() {
		return this.ctx.oficial_quitar();
	}
	function quitarTodos() {
		return this.ctx.oficial_quitarTodos();
	}
	function guardarDatos() {
		return this.ctx.oficial_guardarDatos();
	}
	function chkFiltrarArtStockOrd_clicked() {
		return this.ctx.oficial_chkFiltrarArtStockOrd_clicked();
	}
	function habilitarPorStockOrd() {
		return this.ctx.oficial_habilitarPorStockOrd();
	}
// 	function refrescarTablas() {
// 		return this.ctx.oficial_refrescarTablas();
// 	}
// 	function establecerFiltro() {
// 		return this.ctx.oficial_establecerFiltro();
// 	}
// 	function isNumeric(checkstring:String):Boolean {
// 		return this.ctx.oficial_isNumeric(checkstring);
// 	}
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
/** \C
Este formulario muestra una lista de lineas de proveedor que cumplen un determinado filtro, y permite al usuario seleccionar uno o más lineas de la lista
\end */
function interna_init()
{
	var cursor:FLSqlCursor = this.cursor();
	
	this.iface.pbnRStockOrd = this.child("pbnResetearStockOrd");
	this.iface.tblArticulos = this.child("tblArticulos");
	this.iface.pbnAceptar = this.child("pushButtonAccept");
	
	this.iface.colorVerde = new Color();
	this.iface.colorBlanco = new Color();
	this.iface.colorVerde.setRgb(0, 200, 0);
	this.iface.colorBlanco.setRgb(200, 200, 200);

// 	this.iface.tdbArticulos = this.child("tdbArticulos");
// 	this.iface.tdbArticulosSel = this.child("tdbArticulosSel");
	
// 	this.iface.tdbArticulos.setReadOnly(true);
// 	this.iface.tdbArticulosSel.setReadOnly(true);
	
	this.child("chkFiltrarArtProv").checked = true;
	this.child("chkFiltrarArtStockFis").checked = true;
	this.child("chkFiltrarArtStockMin").checked = true;
	this.child("chkFiltrarArtStockOrd").checked = true;
	connect(this.iface.tblArticulos, "doubleClicked(int, int)", this, "iface.incluirFila");

	disconnect(this.iface.pbnAceptar, "clicked()", this, "accept()");
	connect(this.iface.pbnAceptar, "clicked()", this, "iface.guardarDatos()");
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this.iface.pbnRStockOrd, "clicked()", this, "iface.pbnResetearStockOrd_clicked");
	connect(this.child("chkFiltrarArtProv"), "clicked()", this, "iface.buscar");
	connect(this.child("chkFiltrarArtStockFis"), "clicked()", this, "iface.buscar");
	connect(this.child("chkFiltrarArtStockMin"), "clicked()", this, "iface.buscar");
	connect(this.child("chkFiltrarArtStockOrd"), "clicked()", this, "iface.chkFiltrarArtStockOrd_clicked");
// 	connect(this.iface.tdbArticulos.cursor(), "recordChoosed()", this, "iface.seleccionar()");
// 	connect(this.iface.tdbArticulosSel.cursor(), "recordChoosed()", this, "iface.quitar()");
	connect(this.child("pbnSeleccionar"), "clicked()", this, "iface.seleccionar()");
	connect(this.child("pbnSeleccionarTodos"), "clicked()", this, "iface.seleccionarTodos()");
	connect(this.child("pbnQuitar"), "clicked()", this, "iface.quitar()");
	connect(this.child("pbnQuitarTodos"), "clicked()", this, "iface.quitarTodos()");
	connect(form, "closed()", this, "iface.desconectar");
	
// 	this.iface.refrescarTablas();
	this.iface.generarTabla();
	this.iface.cargarTabla();
	this.child("fdbProveedor").setFocus();
	this.iface.habilitarPorStockOrd();
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_incluirFila(iFila:Number, iCol:Number, sel:String)
{
	if (iCol == this.iface.COL_PEDIR) {
		return;
	}
	if (!sel) {
		sel = this.iface.tblArticulos.text(iFila, this.iface.COL_SEL);
		if (sel == "S") {
			sel = "N";
		} else {
			sel = "S";
		}
	}
	debug("iFila = " + iFila);
	debug("this.iface.COL_SEL = " + this.iface.COL_SEL);
	debug("sel = " + sel);
	this.iface.tblArticulos.setText(iFila, this.iface.COL_SEL, sel);
	this.iface.colorearFila(iFila);
}

function oficial_generarTabla()
{
	var util:FLUtil = new FLUtil;

	this.iface.COL_SEL = 0;
	this.iface.COL_REF = 1;
	this.iface.COL_DES = 2;
	this.iface.COL_SMIN = 3;
	this.iface.COL_SFIS = 4;
	this.iface.COL_PREC = 5;
	this.iface.COL_PEDIR = 6;

	this.iface.tblArticulos.setNumCols(7);
	this.iface.tblArticulos.setColumnWidth(this.iface.COL_REF, 120);
	this.iface.tblArticulos.setColumnWidth(this.iface.COL_DES, 350);
	this.iface.tblArticulos.setColumnWidth(this.iface.COL_SMIN, 80);
	this.iface.tblArticulos.setColumnWidth(this.iface.COL_SFIS, 80);
	this.iface.tblArticulos.setColumnWidth(this.iface.COL_PREC, 80);
	this.iface.tblArticulos.setColumnWidth(this.iface.COL_PEDIR, 80);

	this.iface.tblArticulos.setColumnReadOnly(this.iface.COL_REF, true);
	this.iface.tblArticulos.setColumnReadOnly(this.iface.COL_DES, true);
	this.iface.tblArticulos.setColumnReadOnly(this.iface.COL_SMIN, true);
	this.iface.tblArticulos.setColumnReadOnly(this.iface.COL_SFIS, true);
	this.iface.tblArticulos.setColumnReadOnly(this.iface.COL_PREC, true);
	this.iface.tblArticulos.setColumnReadOnly(this.iface.COL_PEDIR, false);

	var cabeceras:String = " /" + util.translate("scripts", "Referencia") + "/" + util.translate("scripts", "Descripción") + "/" + util.translate("scripts", "S.Mínimo (m)") + "/" + util.translate("scripts", "S.Físico (F)") + "/" + util.translate("scripts", "S.Por Recibir (R)") + "/" + util.translate("scripts", "A Pedir (P=m-F-R)");
	this.iface.tblArticulos.setColumnLabels("/", cabeceras);
	this.iface.tblArticulos.hideColumn(this.iface.COL_SEL);
}

function oficial_cargarTabla()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	this.iface.limpiarTabla();

	var datos:String = cursor.valueBuffer("datos");
	var xmlDatos:FLDomDocument = new FLDomDocument;
	if (!xmlDatos.setContent(datos)) {
		return false;
	}
	var xmlArticulos:FLDomNodeList = xmlDatos.elementsByTagName("Articulo");
	if (xmlArticulos && xmlArticulos.count() > 0) {
debug("count = xmlArticulos.count()");
		var eArticulo:FLDomElement;
		var referencia:String;
		var sMin:Number;
		var sFis:Number;
		var pteRecibir:Number;
		var pedir:Number;
		var groupBy:String = " GROUP BY a.descripcion, a.stockmin, a.stockfis";

		var qryStock:FLSqlQuery = new FLSqlQuery;
		qryStock.setTablesList("articulos,stocks");
		qryStock.setSelect("a.descripcion, a.stockmin, a.stockfis, SUM(s.pterecibir)");
		qryStock.setFrom("articulos a LEFT OUTER JOIN stocks s ON a.referencia = s.referencia");
		qryStock.setForwardOnly(true);

		for (var i:Number = 0; i < xmlArticulos.count(); i++) {
			eArticulo = xmlArticulos.item(i).toElement();
			referencia = eArticulo.attribute("Referencia");
			qryStock.setWhere("a.referencia = '" + referencia + "'" + groupBy);
			if (!qryStock.exec()) {
				return false;
			}
			if (!qryStock.first()) {
				return false;
			}

			sMin = (isNaN(qryStock.value("a.stockmin")) ? 0 : qryStock.value("a.stockmin"));
			sFis = (isNaN(qryStock.value("a.stockfis")) ? 0 : qryStock.value("a.stockfis"));
			pteRecibir = (isNaN(qryStock.value("SUM(s.pterecibir)")) ? 0 : qryStock.value("SUM(s.pterecibir)"));
			pedir = eArticulo.attribute("Pedir");
			
			this.iface.tblArticulos.insertRows(i);
			this.iface.tblArticulos.setText(i, this.iface.COL_REF, referencia);
			this.iface.tblArticulos.setText(i, this.iface.COL_DES, qryStock.value("a.descripcion"));
			this.iface.tblArticulos.setText(i, this.iface.COL_SMIN, sMin);
			this.iface.tblArticulos.setText(i, this.iface.COL_SFIS, sFis);
			this.iface.tblArticulos.setText(i, this.iface.COL_PREC, pteRecibir);
			this.iface.tblArticulos.setText(i, this.iface.COL_PEDIR, pedir);
			this.iface.tblArticulos.setText(i, this.iface.COL_SEL, "S");
			this.iface.colorearFila(i);
		}
	} else {
debug("buscando");
		this.iface.buscar();
	}
}

function oficial_limpiarTabla()
{
	var numFilas:Number = this.iface.tblArticulos.numRows();
	for (var iFila:Number = (numFilas - 1); iFila >= 0; iFila--) {
		this.iface.tblArticulos.removeRow(iFila);
	}
}

function oficial_buscar()
{debug("buscar");
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	this.iface.limpiarTabla();
	
	var filtro:String = "1 = 1";
	var fromSelect:String = "articulos a LEFT OUTER JOIN stocks s ON a.referencia = s.referencia";
	if (this.child("chkFiltrarArtProv").checked) {
		filtro += " AND ap.codproveedor = '" + cursor.valueBuffer("codproveedor") + "'";
		fromSelect += " INNER JOIN articulosprov ap ON a.referencia = ap.referencia";
	}
	if (this.child("chkFiltrarArtStockMin").checked) {
		filtro += " AND a.stockmin > 0";
	}

	var groupBy:String = " GROUP BY a.referencia, a.descripcion, a.stockmin, a.stockfis ORDER BY a.referencia";
	var qryStock:FLSqlQuery = new FLSqlQuery;
	qryStock.setTablesList("articulos,stocks,articulosprov");
	qryStock.setSelect("a.referencia, a.descripcion, a.stockmin, a.stockfis, SUM(s.pterecibir)");
	qryStock.setFrom(fromSelect);
	qryStock.setWhere(filtro + groupBy);
	qryStock.setForwardOnly(true);
debug("q = " + qryStock.sql());
	if (!qryStock.exec()) {
		return false;
	}
	var totalArticulos:Number = qryStock.size();
	var referencia:String;
	var sMin:Number;
	var sFis:Number;
	var pteRecibir:Number;
	var pedir:Number;

	var iFila:Number = 0;
	util.createProgressDialog(util.translate("scripts", "Informando tabla de artículos"), totalArticulos);
	while (qryStock.next()) {
		util.setProgress(iFila);
		sMin = (isNaN(qryStock.value("a.stockmin")) ? 0 : qryStock.value("a.stockmin"));
		sFis = (isNaN(qryStock.value("a.stockfis")) ? 0 : qryStock.value("a.stockfis"));
		pteRecibir = (isNaN(qryStock.value("SUM(s.pterecibir)")) ? 0 : qryStock.value("SUM(s.pterecibir)"));
		pedir = sMin - (sFis + pteRecibir);
		if (pedir < 0) {
			pedir = 0;
		}

		if (this.child("chkFiltrarArtStockFis").checked) {
			if (sMin <= (sFis + pteRecibir)) {
				continue;
			}
		}
		if (this.child("chkFiltrarArtStockOrd").checked) {
			if ((sMin - (sFis + pteRecibir)) < cursor.valueBuffer("cantidadmin")) {
				continue;
			}
		}
		
		
		this.iface.tblArticulos.insertRows(iFila);
		this.iface.tblArticulos.setText(iFila, this.iface.COL_REF, qryStock.value("a.referencia"));
		this.iface.tblArticulos.setText(iFila, this.iface.COL_DES, qryStock.value("a.descripcion"));
		this.iface.tblArticulos.setText(iFila, this.iface.COL_SMIN, sMin);
		this.iface.tblArticulos.setText(iFila, this.iface.COL_SFIS, sFis);
		this.iface.tblArticulos.setText(iFila, this.iface.COL_PREC, pteRecibir);
		this.iface.tblArticulos.setText(iFila, this.iface.COL_PEDIR, pedir);
		this.iface.tblArticulos.setText(iFila, this.iface.COL_SEL, "N");
		this.iface.colorearFila(iFila);
		iFila++;
	}
	util.destroyProgressDialog();
}

function oficial_colorearFila(iFila:Number)
{
	var numCols:Number = this.iface.tblArticulos.numCols();
	for (var iCol:Number = 0; iCol < numCols; iCol++) {
		if (this.iface.tblArticulos.text(iFila, this.iface.COL_SEL) == "S") {
			this.iface.tblArticulos.setCellBackgroundColor(iFila, iCol, this.iface.colorVerde);
		} else {
			this.iface.tblArticulos.setCellBackgroundColor(iFila, iCol, this.iface.colorBlanco);
		}
		this.iface.tblArticulos.adjustColumn(iCol);
	}
}

function oficial_desconectar()
{
	disconnect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged");
	disconnect(this.child("chkFiltrarArtProv"), "clicked()", this, "iface.filtrarArtProv");
	disconnect(this.child("chkFiltrarArtStockFis"), "clicked()", this, "iface.filtrarArtStockFis");
	disconnect(this.child("chkFiltrarArtStockMin"), "clicked()", this, "iface.filtrarArtStockMin");
}

/** \C
\end */
function oficial_bufferChanged(fN:String)
{
	switch(fN) {
		case "codproveedor":
// 			var codProveedor:String = this.cursor().valueBuffer("codproveedor");
// 			if (!codProveedor)
// 				return;			
// 			var miVar:FLVar = new FLVar();
// 			if (!miVar.set("CODPROVTEMP", codProveedor))
// 				return false;
// 			this.iface.refrescarTablas();
			break;
		case "cantidadmin":
// 			this.iface.refrescarTablas();
			break;
	}
}


/** \C
Al pulsar el botón de resetear les unidades pedidos 
\end */
function oficial_pbnResetearStockOrd_clicked()
{
	var numFilas:Number = this.iface.tblArticulos.numRows();
	for (var iFila:Number = 0; iFila < numFilas; iFila++) {
		this.iface.tblArticulos.setText(iFila, this.iface.COL_PEDIR, 0);
	}
// 	var util:FLUtil = new FLUtil();
// 	var cursor:FLSqlCursor = this.cursor();
// 
// 	var codProveedor:String = cursor.valueBuffer("codproveedor");
// 	var res:Number = MessageBox.warning(util.translate("scripts", "Esta acción reseteará todas las unidades pedidas\n pendientes de servir en pedidos automáticos para este proveedor!\n\n¿Estás seguro?"), MessageBox.Ok, MessageBox.Cancel);
// 	if (res == MessageBox.Cancel)
// 		return;
// 	
// 	var clausulaSelect:String = "referencia IN (SELECT referencia FROM articulosprov WHERE codproveedor = '" + codProveedor + "')";
// 	
// 	var curArticulos:FLSqlCursor = new FLSqlCursor("articulos");
// 	curArticulos.select(clausulaSelect);
// 	while (curArticulos.next()) {
// 		curArticulos.setModeAccess(curArticulos.Edit);
// 		curArticulos.refreshBuffer();
// 		// curArticulos.setAtomicValueBuffer("stockord", 0); 
// 		curArticulos.setValueBuffer("stockord", 0);
// 	if (!curArticulos.commitBuffer())
// 			return false;
// 	}
// 
// 	return true;
}

/** \D Refresca las tablas, en función del filtro y de los datos seleccionados hasta el momento
*/
// function oficial_refrescarTablas()
// {
// 	var datos:String = this.cursor().valueBuffer("datos");
// 	this.iface.establecerFiltro();
// 	var filtro:String = this.cursor().valueBuffer("filtro");
// 	
// 	if (filtro && filtro != "")
// 		filtro += " AND ";
// 	if (!datos || datos == "") {
// 		this.iface.tdbArticulos.setFilter(filtro + "1 = 1");
// 		this.iface.tdbArticulosSel.setFilter(filtro + "1 = 2");
// 	} else {
// 		// cost ~ 8700
// 		this.iface.tdbArticulos.setFilter(filtro + "articulos.referencia NOT IN (" + datos + ")");
// 		// first statement in filter has to be 1=1 to workaround bug 1780329 
// 		// cost ~ 4100
// 		this.iface.tdbArticulosSel.setFilter("1=1 AND articulos.referencia IN (" + datos + ")");
// 	}
// 	debug(this.iface.tdbArticulos.cursor().mainFilter());
// 	this.iface.tdbArticulos.refresh();
// 	this.iface.tdbArticulosSel.refresh();
// }

/** \D Incluye un articulo en la lista de datos
*/
function oficial_seleccionar()
{
	var iFila:Number = this.iface.tblArticulos.currentRow();
	if (iFila < 0) {
		return;
	}
	this.iface.incluirFila(iFila, 0, "S");
	
// 	var cursor:FLSqlCursor = this.cursor();
// 	var datos:String = cursor.valueBuffer("datos");
// 	var referencia:String = this.iface.tdbArticulos.cursor().valueBuffer("referencia");
// 	if (!referencia)
// 		return;
// 	if (!datos || datos == "")
// 		datos = "'" + referencia + "'";
// 	else
// 		datos += "," + "'" + referencia + "'";
// 		
// 	cursor.setValueBuffer("datos", datos);
// 	
// 	this.iface.refrescarTablas();
}

/** \D Incluye todos los articulos en la lista de datos
*/
function oficial_seleccionarTodos()
{
	var numFilas:Number = this.iface.tblArticulos.numRows();
	for (var iFila:Number = 0; iFila < numFilas; iFila++) {
debug("incluyendo fila "  + iFila);
		this.iface.incluirFila(iFila, 0, "S");
	}

// debug(1);
// 	var cursor:FLSqlCursor = this.cursor();
// 	var datos:String = cursor.valueBuffer("datos");
// 	var curLineas:FLSqlCursor = this.iface.tdbArticulos.cursor();
// 	switch (curLineas.size()) {
// 		case 0: {debug(curLineas.size());
// 			return;
// 		}
// 		default: {debug("default");debug(curLineas.size());
// 			curLineas.first();
// 			referencia = curLineas.valueBuffer("referencia");
// debug(datos);
// debug(referencia);
// 			if (!datos || datos == "")
// 				datos = "'" + referencia + "'";
// 			else
// 				datos += "," + "'" + referencia + "'";
// 			
// 			while (curLineas.next()) {
// 				referencia = curLineas.valueBuffer("referencia");
// debug(datos);
// debug(referencia);
// 				if (!datos || datos == "")
// 					datos = "'" + referencia + "'";
// 				else
// 					datos += "," + "'" + referencia + "'";
// 			}
// 		break;
// 		}
// 	}
// 	debug(2);
// 	cursor.setValueBuffer("datos", datos);
// 	this.iface.refrescarTablas();
// debug("fin");
}

/** \D Quira un articulo de la lista de datos
*/
function oficial_quitar()
{
	var iFila:Number = this.iface.tblArticulos.currentRow();
	if (iFila < 0) {
		return;
	}
	this.iface.incluirFila(iFila, 0, "N");

// 	var cursor:FLSqlCursor = this.cursor();
// 	var datos:String = cursor.valueBuffer("datos");
// 	var referencia:String = this.iface.tdbArticulosSel.cursor().valueBuffer("referencia");
// 	if (!referencia)
// 		return;
// 	
// 	if (!datos || datos == "")
// 		return;
// 	var lineas:Array = datos.split(",");
// 	var datosNuevos:String = "";
// 	for (var i:Number = 0; i < lineas.length; i++) {
// 		if (lineas[i] != "'" + referencia + "'") {
// 			if (datosNuevos == "") 
// 				datosNuevos = lineas[i];
// 			else
// 				datosNuevos += "," + lineas[i];
// 		}
// 	}
// 	cursor.setValueBuffer("datos", datosNuevos);
// 	this.iface.refrescarTablas();
}

/** \D Quira todos los articulos de la lista de datos
*/
function oficial_quitarTodos()
{
	var numFilas:Number = this.iface.tblArticulos.numRows();
	for (var iFila:Number = 0; iFila < numFilas; iFila++) {
		this.iface.incluirFila(iFila, 0, "N");
	}
// 	var cursor:FLSqlCursor = this.cursor();
// 	cursor.setValueBuffer("datos", "");
// 	this.iface.refrescarTablas();
}

/** \D Muestra únicamente los artículos que cumplen un determinado filtro
*/
// function oficial_establecerFiltro()
// {
// 	var util:FLUtil = new FLUtil();
// 	var cursor:FLSqlCursor = this.cursor();
// 	
// 	var filtro:String = "articulos.auslaufartikel = FALSE";
// 	if (this.child("chkFiltrarArtProv").checked)
// 		filtro += " AND articulosprov.codproveedor = '" + cursor.valueBuffer("codproveedor") + "'";
// 			
// 	if (this.child("chkFiltrarArtStockOrd").checked)
// 		filtro += " AND articulos.stockmin - articulos.stockfis - articulos.stockord >= " + cursor.valueBuffer("cantidadmin");
// 	else
// 		if (this.child("chkFiltrarArtStockFis").checked)
// 			filtro += " AND articulos.stockord < articulos.stockmin";
// 
// 	if (this.child("chkFiltrarArtStockMin").checked)
// 		filtro += " AND articulos.stockmin > 0";
// 			
// 			
// 	var q:FLSqlQuery = new FLSqlQuery("qry_articulos_composed");
// 	q.setSelect("articulos.referencia, articulosprov.id");
// 	q.setWhere(filtro);
// 	q.setOrderBy("articulos.referencia");
// 	q.exec();
// 	var lastRef:String = "";
// 	var excluir:String = "";
// 	while(q.next()) {
// 		if (q.value(0) == lastRef) {
// 			if (excluir) excluir += ",";
// 			excluir += q.value(1);
// 		}
// 		lastRef = q.value(0);
// 	}
// 	
// 	if (excluir)
// 		filtro += " AND (articulosprov.id is null OR articulosprov.id NOT IN (" + excluir + "))";
// 			
// 	debug(filtro);
// 	
// 	cursor.setValueBuffer("filtro", filtro);
// }

// function oficial_isNumeric(checkstring:String):Boolean
// {
//    var validChars:String = "0123456789.";
//    var isNumber:Boolean = true;
//    var charPos:String;
// 
//    for (i = 0; i < checkstring.length && isNumber == true; i++) {
//       charPos = checkstring.charAt(i);
//       if (validChars.indexOf(charPos) == -1)
//          isNumber = false;
//    }
//    return isNumber;
// }

function oficial_guardarDatos()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var numFilas:Number = this.iface.tblArticulos.numRows();
	var xmlDatos:FLDomDocument = new FLDomDocument;
	xmlDatos.setContent("<PedidoAuto/>");
	var eArticulo:FLDomElement;
	for (var iFila:Number = 0; iFila < numFilas; iFila++) {
		if (this.iface.tblArticulos.text(iFila, this.iface.COL_SEL) == "N") {
			continue;
		}
		eArticulo = xmlDatos.createElement("Articulo");
		eArticulo.setAttribute("Referencia", this.iface.tblArticulos.text(iFila, this.iface.COL_REF));
		eArticulo.setAttribute("Pedir", this.iface.tblArticulos.text(iFila, this.iface.COL_PEDIR));
		xmlDatos.firstChild().appendChild(eArticulo);
	}
debug(xmlDatos.toString(4));
	cursor.setValueBuffer("datos", xmlDatos.toString(4));
	this.accept();
}

function oficial_chkFiltrarArtStockOrd_clicked()
{
	this.iface.habilitarPorStockOrd()
	this.iface.buscar();
}

function oficial_habilitarPorStockOrd()
{
	if (this.child("chkFiltrarArtStockOrd").checked) {
		this.child("fdbCantidadMin").setDisabled(true);
	} else {
		this.child("fdbCantidadMin").setDisabled(false);
	}
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
