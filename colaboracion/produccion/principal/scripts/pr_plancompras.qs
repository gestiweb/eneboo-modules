/***************************************************************************
                 pr_compras.qs  -  description
                             -------------------
    begin                : mie mar 10 2010
    copyright            : (C) 2010 by InfoSiAL S.L.
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
	function main() {
		return this.ctx.interna_main();
	}
	function calculateField(fN:String):String {
		return this.ctx.interna_calculateField(fN);
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var tblEvolStock:FLTableDB;

	var aFechas_:Array; /// Array de fechas a mostrar en la tabla de stock
	var aIFechas_:Array; /// Array que devuelve el índice de aFechas_ a partir de una fecha
	var totalDatosES:Array; /// Array con la evolución de stock de la tabla
	var aDatosCompra_:Array; /// Almacena los datos de una línea de compra a crear

	var C_REFERENCIA:Number;
	var C_DESARTICULO:Number;
	var C_CODPROVEEDOR:Number;
	var C_NOMPROVEEDOR:Number;
	var C_PLAZO:Number;
	var C_STOCKMIN:Number;
	var C_STOCKMAX:Number;
	var C_STOCKACTUAL:Number;
	var C_IDSTOCK:Number;

	var colCeldaOK_:Color;
	var colCeldaMin_:Color;
	var colCeldaMax_:Color;
	var colCeldaOKMov_:Color;
	var colCeldaMinMov_:Color;
	var colCeldaMaxMov_:Color;

	var curDocumento_:FLSqlCursor;

	var numColCabecera_:Number; /// Número de columnas que se usan como cabecera, antes de los días.

	function oficial( context ) { interna( context ); }
	function tbnActualizar_clicked() {
		return this.ctx.oficial_tbnActualizar_clicked();
	}
	function consultaBusqueda():FLSqlQuery {
		return this.ctx.oficial_consultaBusqueda();
	}
	function construirWhere():String {
		return this.ctx.oficial_construirWhere();
	}
	function cargarCalendario() {
		return this.ctx.oficial_cargarCalendario();
	}
	function prepararTablaEvol() {
		return this.ctx.oficial_prepararTablaEvol();
	}
	function datosEvolStock(idStock:String, fechaDesde:String):Array {
		return this.ctx.oficial_datosEvolStock(idStock, fechaDesde);
	}
	function tblEvolStock_clicked(fil:Number, col:Number) {
		return this.ctx.oficial_tblEvolStock_clicked(fil, col);
	}
	function tblEvolStock_doubleClicked(fil:Number, col:Number) {
		return this.ctx.oficial_tblEvolStock_doubleClicked(fil, col);
	}
	function filtrarMovimientos(filtro:String) {
		return this.ctx.oficial_filtrarMovimientos(filtro);
	}
	function colores() {
		return this.ctx.oficial_colores();
	}
	function tbnDocumento_clicked() {
		return this.ctx.oficial_tbnDocumento_clicked();
	}
	function prepararTablaMovimientos() {
		return this.ctx.oficial_prepararTablaMovimientos();
	}
	function tbnComprar_clicked() {
		return this.ctx.oficial_tbnComprar_clicked();
	}
	function tbnEditMov_clicked() {
		return this.ctx.oficial_tbnEditMov_clicked();
	}
	function establecerDatosCompra(aDatos:Array):Boolean {
		return this.ctx.oficial_establecerDatosCompra(aDatos);
	}
	function datosCompra():Array {
		return this.ctx.oficial_datosCompra();
	}
	function tbnActualizar_clicked():Array {
		return this.ctx.oficial_tbnActualizar_clicked();
	}
	function tdbLineasPlan_bufferCommited() {
		return this.ctx.oficial_tdbLineasPlan_bufferCommited();
	}
	function tbnVerProv_clicked() {
		return this.ctx.oficial_tbnVerProv_clicked();
	}
	function calcularTotales() {
		return this.ctx.oficial_calcularTotales();
	}
	function tbnCalcular_clicked() {
		return this.ctx.oficial_tbnCalcular_clicked();
	}
	function calcularCompras():Boolean {
		return this.ctx.oficial_calcularCompras();
	}
	function crearLineaPlan(referencia:String, fechaPrev:String, cantidad:Number):Number {
		return this.ctx.oficial_crearLineaPlan(referencia, fechaPrev, cantidad);
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
	function pub_datosCompra():Array {
		return this.datosCompra();
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
function interna_init()
{
	var cursor:FLSqlCursor = this.cursor();

	this.iface.tblEvolStock = this.child("tblEvolStock");

	connect(this.child("tbnActualizar"), "clicked()", this, "iface.tbnActualizar_clicked()");
	connect(this.child("tbnDocumento"), "clicked()", this, "iface.tbnDocumento_clicked()");
	connect(this.child("tbnComprar"), "clicked()", this, "iface.tbnComprar_clicked()");
	connect(this.child("tbnEditMov"), "clicked()", this, "iface.tbnEditMov_clicked()");
	connect(this.child("tbnVerProv"), "clicked()", this, "iface.tbnVerProv_clicked()");
	connect(this.child("tbnCalcular"), "clicked()", this, "iface.tbnCalcular_clicked()");
	connect(this.child("tdbLineasPlan").cursor(), "bufferCommited()", this, "iface.tdbLineasPlan_bufferCommited()");
	connect (this.iface.tblEvolStock, "clicked(int, int)", this, "iface.tblEvolStock_clicked");

// 	connect (this.iface.tblEvolStock, "doubleClicked(int, int)", this, "iface.tblEvolStock_doubleClicked");

	this.iface.prepararTablaMovimientos();
	this.iface.colores();
	this.iface.prepararTablaEvol();
	this.iface.filtrarMovimientos();

	switch (cursor.modeAccess()) {
		case cursor.Insert: {
			this.child("fdbCodAlmacen").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codalmacen"));
			this.child("fdbIdUsario").setValue(sys.nameUser());
			break;
		}
	}
}

function interna_main()
{
	var util:FLUtil = new FLUtil;
	var f:Object = new FLFormSearchDB("pr_plancompras");
	var cursor:FLSqlCursor = f.cursor();

	cursor.select("iduser = '" + sys.nameUser() + "'");
	if (!cursor.first()) {
		cursor.setModeAccess(cursor.Insert);
	} else {
		cursor.setModeAccess(cursor.Edit);
	}

	f.setMainWidget();
	cursor.refreshBuffer();
	cursor.setValueBuffer("iduser", sys.nameUser());
	var curTransaccion:FLSqlCursor = new FLSqlCursor("empresa");
	curTransaccion.transaction(false);
	try {
		var acpt:String = f.exec("id");
// 		var lista:String;
		if (acpt && cursor.commitBuffer()) {
			curTransaccion.commit();
		} else {
			curTransaccion.rollback();
		}
	// 		var curRoturaStock:FLSqlCursor = new FLSqlCursor("roturastock");
	// 		curRoturaStock.select("idusuario = '" + sys.nameUser() + "'");
	// 		if (curRoturaStock.first()) {
	// 			lista = curRoturaStock.valueBuffer("lista");
	// 			if (!lista || lista == "")
	// 				return;
	// 
	// 			var curPedido:FLSqlCursor = new FLSqlCursor("pedidosprov");
	// 			curPedido.transaction(false);
	// 			try {
	// 				if (!this.iface.generarRoturaStock(lista, curRoturaStock)) {
	// 					curPedido.rollback();
	// 					util.destroyProgressDialog();
	// 				} else {
	// 					curPedido.commit();
	// 					util.destroyProgressDialog();
	// 				}
	// 			} catch (e) {
	// 				curPedido.rollback();
	// 				util.destroyProgressDialog();
	// 				MessageBox.critical(util.translate("scripts", "Hubo un error al generar los pedidos de artículos con rotura de stock: ") + e, MessageBox.Ok, MessageBox.NoButton);
	// 			}
	// 		}
	//	}
	} catch (e) {
		curTransaccion.rollback();
		MessageBox.critical(util.translate("scripts", "Error al realizar el plan de compras: ") + e, MessageBox.Ok, MessageBox.NoButton);
	}
	f.close();
// 	this.iface.tdbRecords.refresh();
}

function interna_calculateField(fN:String):String
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var valor:String;
	switch (fN) {
		case "costetotal": {
			valor = util.sqlSelect("pr_lineasplancompras lp INNER JOIN articulosprov ap ON lp.referencia = ap.referencia AND lp.codproveedor = ap.codproveedor", "SUM(lp.incremento * ap.coste)", "lp.idplan = " + cursor.valueBuffer("idplan"), "pr_lineasplancompras,articulosprov");
			break;
		}
	}
	return valor;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_consultaBusqueda():FLSqlQuery
{
	var cursor:FLSqlCursor = this.cursor();
	var miWhere:String;

	miWhere = this.iface.construirWhere();
	if (!miWhere) {
		return false;
	}
	var qryArticulos = new FLSqlQuery;
	with (qryArticulos) {
		setTablesList("articulos,articulosprov,stocks,proveedores");
		setSelect("ap.codproveedor, p.nombre, a.referencia, a.descripcion, a.stockmin, a.stockmax, ap.plazo, s.cantidad, s.idstock");
		setFrom("articulos a LEFT OUTER JOIN articulosprov ap ON a.referencia = ap.referencia INNER JOIN proveedores p ON ap.codproveedor = p.codproveedor LEFT OUTER JOIN stocks s ON a.referencia = s.referencia");
		setWhere(miWhere);
		setForwardOnly(true);
	}
debug(qryArticulos.sql());
	if (!qryArticulos.exec())
		return false;

	return qryArticulos;
}

function oficial_construirWhere():String
{
	var util:FLUtil;

	var cursor:FLSqlCursor = this.cursor();

	var where:String = "ap.pordefecto = true AND a.tipostock <> 'Sin stock'";
	var codProveedor:String = cursor.valueBuffer("codproveedor");
	if (codProveedor && codProveedor != "") {
		where += " AND ap.codproveedor = '" + codProveedor + "'";
	}

	var referencia:String = cursor.valueBuffer("referencia");
	if (referencia && referencia != "") {
		where += " AND a.referencia = '" + referencia + "'";
	}
	
	var codAlmacen:String = cursor.valueBuffer("codalmacen");
	if (!codAlmacen || codAlmacen == "") {
		MessageBox.warning(util.translate("scripts", "Debe especificar un almacén"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	where += " AND s.codalmacen = '" + codAlmacen + "'";

	var codFamilia:String = cursor.valueBuffer("codfamilia");
	if (codFamilia && codFamilia != "") {
		where += " AND a.codfamilia = '" + codFamilia + "'";
	}

	where += " ORDER BY ap.codproveedor, a.referencia";

	return where;
}

function oficial_cargarCalendario()
{
	var hoy:Date = new Date;
	var fechaInicio:String = hoy.toString().left(10) + "T00:00:00";

	var qryFechas:FLSqlQuery = new FLSqlQuery;
	qryFechas.setTablesList("pr_calendario");
	qryFechas.setSelect("fecha");
	qryFechas.setFrom("pr_calendario");
	qryFechas.setWhere("fecha >= '" + fechaInicio + "' and tiempo > 0 ORDER BY fecha");
	qryFechas.setForwardOnly(true);
	if (!qryFechas.exec()) {
		return false;
	}
	if (this.iface.aIFechas_) {
		delete this.iface.aIFechas_;
	}
	this.iface.aFechas_ = [];
	if (this.iface.aFechas_) {
		delete this.iface.aFechas_;
	}
	this.iface.aIFechas_ = [];

	var indice:Number = 0;
	var fecha:String;
	while (qryFechas.next() && indice < 365) {
		fecha = qryFechas.value("fecha").toString().left(10);
		this.iface.aIFechas_[fecha] = indice;
		this.iface.aFechas_[indice] = fecha;
		indice++;
	}
}

function oficial_prepararTablaEvol()
{
	var util:FLUtil = new FLUtil;

	this.iface.C_REFERENCIA = 0;
	this.iface.C_DESARTICULO = 1;
	this.iface.C_CODPROVEEDOR = 2;
	this.iface.C_NOMPROVEEDOR = 3;
	this.iface.C_PLAZO = 4;
	this.iface.C_STOCKMIN = 5;
	this.iface.C_STOCKMAX = 6;
	this.iface.C_STOCKACTUAL = 7;
	this.iface.C_IDSTOCK = 8;
	this.iface.numColCabecera_ = 9;
	this.iface.cargarCalendario();
	var numCols:Number = this.iface.numColCabecera_ + this.iface.aFechas_.length;

	this.iface.tblEvolStock.setNumCols(numCols);
	
	var aCabecera:Array = [util.translate("scripts", "Ref."), util.translate("scripts", "Artículo"), util.translate("scripts", "C.Prov."), util.translate("scripts", "Proveedor"), util.translate("scripts", "Plazo"), util.translate("scripts", "S.Min"), util.translate("scripts", "S.Max"), util.translate("scripts", "S.Actual"), util.translate("scripts", "Id.S.")];
	if (aCabecera.length != this.iface.numColCabecera_) {
		MessageBox.warning(util.translate("scripts", "Error de configuración: el número de columnas de cabecera no coincie con las etiquetas de cabecera"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var cabeceraFechas:String = "";
	for (var i:Number = 0; i < this.iface.aFechas_.length; i++) {
		cabeceraFechas += "*" + this.iface.aFechas_[i].right(2) + "-" + this.iface.aFechas_[i].mid(5, 2);
	}
	this.iface.tblEvolStock.setColumnLabels("*", aCabecera.join("*") + cabeceraFechas);
	this.iface.tblEvolStock.setColumnWidth(this.iface.C_REFERENCIA, 80);
	this.iface.tblEvolStock.setColumnWidth(this.iface.C_DESARTICULO, 100);
	this.iface.tblEvolStock.hideColumn(this.iface.C_CODPROVEEDOR);
	this.iface.tblEvolStock.hideColumn(this.iface.C_NOMPROVEEDOR);
	this.iface.tblEvolStock.setColumnWidth(this.iface.C_CODPROVEEDOR, 80);
	this.iface.tblEvolStock.setColumnWidth(this.iface.C_NOMPROVEEDOR, 100);
	this.iface.tblEvolStock.hideColumn(this.iface.C_PLAZO);
	this.iface.tblEvolStock.setColumnWidth(this.iface.C_PLAZO, 40);
	this.iface.tblEvolStock.setColumnWidth(this.iface.C_STOCKMIN, 50);
	this.iface.tblEvolStock.setColumnWidth(this.iface.C_STOCKMAX, 50);
	this.iface.tblEvolStock.hideColumn(this.iface.C_STOCKACTUAL);
	this.iface.tblEvolStock.setColumnWidth(this.iface.C_STOCKACTUAL, 40);
	this.iface.tblEvolStock.hideColumn(this.iface.C_IDSTOCK);
	this.iface.tblEvolStock.setColumnWidth(this.iface.C_IDSTOCK, 40);
	for (var i:Number = 0; i < this.iface.aFechas_.length; i++) {
		this.iface.tblEvolStock.setColumnWidth(this.iface.numColCabecera_ + i, 40);
	}

}

/** \D Construye un array con tantos elementos como días se van a mostrar, y guarda en cada elemento el stock previsto para el día correspondiente
@param idStock: Stock a calcular
@param fechaDesde: Fecha de inicio del cálculo
@return	Array de evolución de stock
\end*/
function oficial_datosEvolStock(idStock:String, fechaDesde:String):Array
{
	var util:FLUtil = new FLUtil;
	var aEvol:Array = new Array(this.iface.aFechas_.length);

	var qryEvol:FLSqlQuery = new FLSqlQuery();
	qryEvol.setTablesList("movistock");
	qryEvol.setSelect("cantidad, fechaprev");
	qryEvol.setFrom("movistock");
	qryEvol.setWhere("idstock = " + idStock + " AND fechaprev >= '" + fechaDesde + "' ORDER BY fechaprev ASC");
	qryEvol.setForwardOnly(true);
	if (!qryEvol.exec()) {
		return false;
	}
	var fechaActual:String = this.iface.aFechas_[0];
	var iActual:Number = 0;
	var dPrev:Date;
	var fechaPrev:String;
	var cantidad:Number = util.sqlSelect("stocks", "cantidad", "idstock = " + idStock);
	if (isNaN(cantidad)) {
		cantidad = 0;
	}
	var hayValores:Boolean = false;
	while (qryEvol.next()) {
		dPrev = qryEvol.value("fechaprev");
		if (!dPrev || dPrev == "" || dPrev == undefined) {
			continue;
		}
		hayValores = true;
		fechaPrev = dPrev.toString().left(10);
// debug("fechaActual = " + fechaActual);
// debug("fechaPrev = " + fechaPrev);
		indiceFecha = this.iface.aIFechas_[fechaPrev];
		if (util.daysTo(fechaActual, fechaPrev) > 0) {
			var i:Number;
			for (i = iActual; i < indiceFecha; i++) {
				aEvol[i] = cantidad;
			}
			iActual = i;
		}
		cantidad += parseFloat(qryEvol.value("cantidad"));
		aEvol[iActual] = cantidad;
	}
	if (hayValores) {
		iActual++;
	}
	for (var i:Number = iActual; i < aEvol.length; i++) {
		aEvol[i] = cantidad;
	}
// debug("aEvol = " + aEvol.join(", "));
	return aEvol;
}

/** \D
Actualiza la lista de pedidos en función de los criterios de búsqueda especificados
\end */
function oficial_tbnActualizar_clicked()
{
debug("oficial_tbnActualizar_clicked");
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	if (this.iface.totalDatosES) {
		delete this.iface.totalDatosES;
	}
	this.iface.totalDatosES = [];

	var hoy:Date = new Date;
	this.iface.tblEvolStock.setNumRows(0);

	var referencia:String;
// 	var incluir:String;
// 	var datosRotura:Array;
// 	var fechaPedido:String;
// 	var fechaRotura:String;
	var codAlmacen:String = cursor.valueBuffer("codalmacen");
	var nomProveedor:String;
	var plazo:Number;
	var stockMinimo:Number;
	var stockMaximo:Number;
// 	var cantidad:Number;
	var idStock:String;

	var qryArticulos:FLSqlQuery = this.iface.consultaBusqueda()
	if (!qryArticulos) {
		return false;
	}
	util.createProgressDialog( util.translate( "scripts", "Buscando artículos..." ), qryArticulos.size());
	util.setProgress(0);
	var i:Number = 1;
	var fila:Number = 0, cantidad:Number, canAnterior:Number, columna:Number;
	var avisar:Boolean = true;
	while (qryArticulos.next()) {
		util.setProgress(i);
		i++;
		referencia = qryArticulos.value("a.referencia");
		nomProveedor = qryArticulos.value("p.nombre");

		plazo = qryArticulos.value("ap.plazo");
		if (!plazo || isNaN(plazo)) {
			plazo = 0;
		}
		stockMinimo = qryArticulos.value("a.stockmin");
		if (!stockMinimo || isNaN(stockMinimo)) {
			stockMinimo = 0;
		}
		stockMaximo = qryArticulos.value("a.stockmax");
		if (!stockMaximo || isNaN(stockMaximo)) {
			stockMaximo = 0;
		}
		idStock = qryArticulos.value("s.idstock");
		this.iface.totalDatosES[fila] = this.iface.datosEvolStock(idStock, hoy.toString()); //flfactalma.iface.pub_datosEvolStock(idStock, hoy.toString(), avisar);

		if (!this.iface.totalDatosES[fila]) {
			util.destroyProgressDialog();
			return false;
		}
	
		this.iface.tblEvolStock.insertRows(fila);
		this.iface.tblEvolStock.setText(fila, this.iface.C_CODPROVEEDOR, qryArticulos.value("ap.codproveedor"));
		this.iface.tblEvolStock.setText(fila, this.iface.C_NOMPROVEEDOR, nomProveedor);
		this.iface.tblEvolStock.setText(fila, this.iface.C_REFERENCIA, referencia);
		this.iface.tblEvolStock.setText(fila, this.iface.C_DESARTICULO, qryArticulos.value("a.descripcion"));
		this.iface.tblEvolStock.setText(fila, this.iface.C_PLAZO, plazo);
		canAnterior = qryArticulos.value("s.cantidad");
		this.iface.tblEvolStock.setText(fila, this.iface.C_STOCKACTUAL, canAnterior);
		this.iface.tblEvolStock.setText(fila, this.iface.C_STOCKMIN, stockMinimo);
		this.iface.tblEvolStock.setText(fila, this.iface.C_STOCKMAX, stockMaximo);
		this.iface.tblEvolStock.setText(fila, this.iface.C_IDSTOCK, idStock);

		for (var i:Number = 0; i < this.iface.totalDatosES[fila].length; i++) {
			cantidad = this.iface.totalDatosES[fila][i];
			columna = this.iface.numColCabecera_ + i;
			this.iface.tblEvolStock.setText(fila, columna, cantidad);
			if (cantidad > stockMaximo) {
				this.iface.tblEvolStock.setCellBackgroundColor(fila, columna, (cantidad == canAnterior ? this.iface.colCeldaMax_ : this.iface.colCeldaMaxMov_));
			} else if (cantidad < stockMinimo) {
				this.iface.tblEvolStock.setCellBackgroundColor(fila, columna, (cantidad == canAnterior ? this.iface.colCeldaMin_ : this.iface.colCeldaMinMov_));
			} else {
				this.iface.tblEvolStock.setCellBackgroundColor(fila, columna, (cantidad == canAnterior ? this.iface.colCeldaOK_ : this.iface.colCeldaOKMov_));
			}
			
			canAnterior = cantidad;
		}
		fila++;
	}

	util.setProgress(qryArticulos.size());
	util.destroyProgressDialog();

}

function oficial_tblEvolStock_clicked(fil:Number, col:Number)
{
	var idStock:String = this.iface.tblEvolStock.text(fil, this.iface.C_IDSTOCK);
	if (!idStock) {
		return;
	}
	this.iface.filtrarMovimientos("idstock = " + idStock);

	if (col < this.iface.numColCabecera_) {
		return;
	}
	var fecha:String = this.iface.aFechas_[col - this.iface.numColCabecera_];
	if (!fecha) {
		return;
	}
// 	var idStock:String = this.iface.tblEvolStock.text(fil, this.iface.C_IDSTOCK);
// 	if (!idStock) {
// 		return;
// 	}
// 	this.iface.filtrarMovimientos("idstock = " + idStock);
	
	var curMov:FLSqlCursor = this.child("tdbMovistock").cursor();
	var i:Number = 0;
	fecha += "T00:00:00";
	while (i < curMov.size()) {
		if (!curMov.next()) {
			curMov.first();
		}
		debug("Buscando Fecha " + fecha+ " en " + curMov.valueBuffer("fechaprev"));
		if (curMov.valueBuffer("fechaprev").toString() == fecha) {
			break;
		}
		i++;
	}
}

function oficial_tblEvolStock_doubleClicked(fil:Number, col:Number)
{
	if (col < this.iface.numColCabecera_) {
		return;
	}
// 	var fecha:String = this.iface.aFechas_[col - this.iface.numColCabecera_];
// 	if (!fecha) {
// 		return;
// 	}

	
// 	var curMov:FLSqlCursor = this.child("tdbMovistock").cursor();
// 	curMov.select("fechaprev = '" + fecha + "'");
// 	if (curMov.first()) {
		this.child("tbnDocumento").animateClick();
// 	}
}

function oficial_filtrarMovimientos(filtro)
{
	var hoy:Date = new Date;
	var filtroMov:String = "fechaprev >= '" + hoy.toString() + "'";
	if (filtro && filtro != "") {
		filtroMov += " AND " + filtro;
	} else {
		filtroMov += " AND 1 = 2";
	}
	this.child("tdbMovistock").setFilter(filtroMov);
	this.child("tdbMovistock").refresh();
}

function oficial_colores()
{
	this.iface.colCeldaOK_ = new Color(200, 255, 200);
	this.iface.colCeldaMin_ = new Color(255, 200, 200);
	this.iface.colCeldaMax_ = new Color(200, 200, 255);
	this.iface.colCeldaOKMov_ = new Color(100, 255, 100);
	this.iface.colCeldaMinMov_ = new Color(255, 100, 100);
	this.iface.colCeldaMaxMov_ = new Color(100, 100, 255);
}

function oficial_tbnDocumento_clicked()
{
	var util:FLUtil = new FLUtil;

	var curMov:FLSqlCursor = this.child("tdbMovistock").cursor();
	var idMov:String = curMov.valueBuffer("idmovimiento");
	if (!idMov) {
		MessageBox.warning(util.translate("scripts", "No hay ningún movimiento seleccionado"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	if (this.iface.curDocumento_) {
		delete this.iface.curDocumento_;
	}
	var idLineaPC:String = curMov.valueBuffer("idlineapc");
	var idLineaPP:String = curMov.valueBuffer("idlineapp");
	var idProceso:String = curMov.valueBuffer("idproceso");
	if (idLineaPC && idLineaPC != "") {
		var idPedido:Number = util.sqlSelect("lineaspedidoscli", "idpedido", "idlinea = " + idLineaPC);
		if (!idPedido || idPedido == "") {
			MessageBox.warning(util.translate("scripts", "No se ha encontrado el pedido de cliente correspondiente a la línea %1").arg(idLineaPC), MessageBox.Ok, MessageBox.NoButton);
			return;
		}
		this.iface.curDocumento_ = new FLSqlCursor("pedidoscli");
		this.iface.curDocumento_.select("idpedido = " + idPedido);
		if (!this.iface.curDocumento_.first()) {
			return false;
		}
		var acciones:Array = [];
		acciones[0] = flcolaproc.iface.pub_arrayAccion("pedidoscli", "editar_linea");
		acciones[0]["idlinea"] = idLineaPC;
		flcolaproc.iface.pub_setAccionesAuto(acciones);
		
		disconnect(this.iface.curDocumento_, "bufferCommited()", this, "iface.tbnActualizar_clicked()");
		connect(this.iface.curDocumento_, "bufferCommited()", this, "iface.tbnActualizar_clicked()");
		this.iface.curDocumento_.editRecord();
	} else if (idLineaPP && idLineaPP != "") {
		var idPedido:Number = util.sqlSelect("lineaspedidosprov", "idpedido", "idlinea = " + idLineaPP);
		if (!idPedido || idPedido == "") {
			MessageBox.warning(util.translate("scripts", "No se ha encontrado el pedido de proveedor correspondiente a la línea %1").arg(idLineaPP), MessageBox.Ok, MessageBox.NoButton);
			return;
		}
		this.iface.curDocumento_ = new FLSqlCursor("pedidosprov");
		this.iface.curDocumento_.select("idpedido = " + idPedido);
		if (!this.iface.curDocumento_.first()) {
			return false;
		}
		var acciones:Array = [];
		acciones[0] = flcolaproc.iface.pub_arrayAccion("pedidosprov", "editar_linea");
		acciones[0]["idlinea"] = idLineaPP;
		flcolaproc.iface.pub_setAccionesAuto(acciones);

		disconnect(this.iface.curDocumento_, "bufferCommited()", this, "iface.tbnActualizar_clicked()");
		connect(this.iface.curDocumento_, "bufferCommited()", this, "iface.tbnActualizar_clicked()");
		this.iface.curDocumento_.editRecord();
	} else if (idProceso && idProceso != "") {
		var codLote:String = util.sqlSelect("pr_procesos", "idobjeto", "idproceso = " + idProceso);
		if (!codLote || codLote == "") {
			MessageBox.warning(util.translate("scripts", "No se ha encontrado el lote correspondiente al proceso %1").arg(idProceso), MessageBox.Ok, MessageBox.NoButton);
			return;
		}
		this.iface.curDocumento_ = new FLSqlCursor("lotesstock");
		this.iface.curDocumento_.select("codLote = '" + codLote + "'");
		if (!this.iface.curDocumento_.first()) {
			return false;
		}
		disconnect(this.iface.curDocumento_, "bufferCommited()", this, "iface.tbnActualizar_clicked()");
		connect(this.iface.curDocumento_, "bufferCommited()", this, "iface.tbnActualizar_clicked()");
		this.iface.curDocumento_.editRecord();
	}
}

function oficial_prepararTablaMovimientos()
{
	var campos:Array = ["fechaprev", "cantidad"];
	this.child("tdbMovistock").setOrderCols(campos);
	this.child("tdbMovistock").refresh();
}

/** \D Abre el formulario de líneas de compra en modo Insert e informa los datos a introducir en el formulario en el array global aDatosCompra_
\end */
function oficial_tbnComprar_clicked()
{
	var util:FLUtil = new FLUtil;
	var fil:Number = this.iface.tblEvolStock.currentRow();
	if (fil == undefined) {
		MessageBox.warning(util.translate("scripts", "Seleccione un día de recepción en la tabla de stocks antes de pulsar este botón"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var col:Number = this.iface.tblEvolStock.currentColumn();
	if (col != undefined && col < this.iface.numColCabecera_) {
		MessageBox.warning(util.translate("scripts", "Seleccione un día de recepción en la tabla de stocks antes de pulsar este botón"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	var fecha:String = this.iface.aFechas_[col - this.iface.numColCabecera_];
	if (!fecha) {
		return;
	}
	fecha += "T00:00:00";

	var aDatosCompra:Array = [];
	aDatosCompra["referencia"] = this.iface.tblEvolStock.text(fil, this.iface.C_REFERENCIA);
	aDatosCompra["codproveedor"] = this.iface.tblEvolStock.text(fil, this.iface.C_CODPROVEEDOR);
	aDatosCompra["fecha"] = fecha;
	aDatosCompra["canprevia"] = false;
	aDatosCompra["fechaprevia"] = false;
	aDatosCompra["idlineapedido"] = false;
	this.iface.establecerDatosCompra(aDatosCompra);

	var curLinea:FLSqlCursor = this.child("tdbLineasPlan").cursor();
	curLinea.insertRecord();
}

/** \D Abre el formulario de líneas de compra en modo Insert o Edit e informa los datos a introducir en el formulario en el array global aDatosCompra_ con los datos del movimiento de entrada seleccionado.
\end */
function oficial_tbnEditMov_clicked()
{
	var util:FLUtil = new FLUtil;
	var fil:Number = this.iface.tblEvolStock.currentRow();
	if (fil == undefined) {
		MessageBox.warning(util.translate("scripts", "Seleccione un día de recepción en la tabla de stocks antes de pulsar este botón"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var curMov:FLSqlCursor = this.child("tdbMovistock").cursor();
	var idLineaPP:String = curMov.valueBuffer("idlineapp");
	if (!idLineaPP || idLineaPP == "") {
		MessageBox.warning(util.translate("scripts", "No ha seleccionado un movimiento de stock o el movimiento no está asociado a un pedido de compra"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var aDatosCompra:Array = [];
	aDatosCompra["referencia"] = this.iface.tblEvolStock.text(fil, this.iface.C_REFERENCIA);
	aDatosCompra["codproveedor"] = this.iface.tblEvolStock.text(fil, this.iface.C_CODPROVEEDOR);
	aDatosCompra["fecha"] = curMov.valueBuffer("fechaprev");
	aDatosCompra["canprevia"] = curMov.valueBuffer("cantidad");
	aDatosCompra["fechaprevia"] = curMov.valueBuffer("fechaprev");
	aDatosCompra["idlineapedido"] = idLineaPP;
	this.iface.establecerDatosCompra(aDatosCompra);

	var curLinea:FLSqlCursor = this.child("tdbLineasPlan").cursor();
	curLinea.select("idlineapedido = " + idLineaPP);
	if (curLinea.first()) {
		curLinea.editRecord();
	} else {
		curLinea.insertRecord();
	}
}

function oficial_tdbLineasPlan_bufferCommited()
{
	this.iface.tbnActualizar_clicked();
	this.iface.calcularTotales();
}

function oficial_establecerDatosCompra(aDatos:Array):Boolean
{
	this.iface.aDatosCompra_ = aDatos;
}

function oficial_datosCompra():Array
{
	return this.iface.aDatosCompra_;
}

function oficial_tbnVerProv_clicked()
{
	if (this.child("tbnVerProv").on) {
		this.iface.tblEvolStock.showColumn(this.iface.C_CODPROVEEDOR);
		this.iface.tblEvolStock.showColumn(this.iface.C_NOMPROVEEDOR);
		this.iface.tblEvolStock.showColumn(this.iface.C_PLAZO);
	} else {
		this.iface.tblEvolStock.hideColumn(this.iface.C_CODPROVEEDOR);
		this.iface.tblEvolStock.hideColumn(this.iface.C_NOMPROVEEDOR);
		this.iface.tblEvolStock.hideColumn(this.iface.C_PLAZO);
	}
}

function oficial_calcularTotales()
{
	this.child("fdbCosteTotal").setValue(this.iface.calculateField("costetotal"));
}

function oficial_tbnCalcular_clicked()
{
	this.iface.calcularCompras();
}

function oficial_calcularCompras():Boolean
{
	var totalFilas:Number = this.iface.tblEvolStock.numRows();
debug("totalFilas = " + totalFilas);
	if (totalFilas == 0) {
		return false;
	}
	var referencia:String, fechaRecepcion:String;
	var stockMin:Number, stockMax:Number, stockDia:Number, plazo:Number, totalDias:Number;
	var col:Number, aPedir:Number, yaPedido:Number;
	for (var fil:Number = 0; fil < totalFilas; fil++) {
		referencia = this.iface.tblEvolStock.text(fil, this.iface.C_REFERENCIA);
debug("Referencia = " + referencia);
		stockMin = this.iface.tblEvolStock.text(fil, this.iface.C_STOCKMIN);
		stockMax = this.iface.tblEvolStock.text(fil, this.iface.C_STOCKMAX);
		plazo = this.iface.tblEvolStock.text(fil, this.iface.C_PLAZO);
		totalDias = this.iface.totalDatosES[fil].length;
		dia1 = (totalDias > plazo ? plazo : totalDias);
debug("Dia1 = " + dia1);
		yaPedido = 0;
		for (var dia:Number = dia1; dia < this.iface.totalDatosES[fil].length; dia++) {
debug("   dia = " + dia);
			col = this.iface.numColCabecera_ + dia;
			stockDia = this.iface.totalDatosES[fil][dia] + parseFloat(yaPedido);
debug("   stockDia = " + stockDia);
			if (stockDia < stockMin) {
				aPedir = stockMax - stockDia;
				fechaRecepcion = (dia > 0 ? this.iface.aFechas_[dia - 1] : this.iface.aFechas_[0]);
				if (!this.iface.crearLineaPlan(referencia, fechaRecepcion, aPedir)) {
					return false;
				}
				yaPedido += parseFloat(aPedir);
			}
		}
	}
	this.iface.tbnActualizar_clicked();
	this.iface.calcularTotales();
	this.child("tdbLineasPlan").refresh();

	return true;
}


/** Crea una línea del plan de ventas
@param referencia: Referencia del artículo
@param fecha: Fecha de recepción del artículo
@param cantidad: Cantidad a pedir
@return Id. de la línea creada
\end */
function oficial_crearLineaPlan(referencia:String, fecha:String, cantidad:Number):Number
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	if (cursor.modeAccess() == cursor.Insert) {
		if (!this.child("tdbLineasPlan").cursor().commitBufferCursorRelation()) {
			return false;
		}
	}

	var codProveedor:String = util.sqlSelect("articulosprov", "codproveedor", "referencia = '" + referencia + "' AND pordefecto = true");
	if (!codProveedor) {
		MessageBox.warning(util.translate("scripts", "El artículo %1 no tiene asociado ningún proveedor al que realizar el pedido").arg(referencia), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var nombreProv:String = util.sqlSelect("proveedores", "nombre", "codproveedor = '" + codProveedor + "'");

	var curLinea:FLSqlCursor = new FLSqlCursor("pr_lineasplancompras");
	curLinea.setModeAccess(curLinea.Insert);
	curLinea.refreshBuffer();
	curLinea.setValueBuffer("idplan", cursor.valueBuffer("idplan"));
	curLinea.setValueBuffer("fecha", fecha);
	curLinea.setValueBuffer("referencia", referencia);
	curLinea.setValueBuffer("incremento", cantidad);
	curLinea.setValueBuffer("cantidad", cantidad);
	curLinea.setValueBuffer("codproveedor", codProveedor);
	curLinea.setValueBuffer("nombre", nombreProv);
	if (!curLinea.commitBuffer()) {
		return false;
	}
	var idLinea:String = curLinea.valueBuffer("idlinea");
	return idLinea;
}


/** Devuelve el índice correspondiente a una fecha fruto de la suma de un número de días a una fecha inicial
@param dias:
\end */
function oficial_sumarDias(dia1:Number, dias:Number):Number
{
	
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
