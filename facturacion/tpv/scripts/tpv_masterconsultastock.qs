/***************************************************************************
                 tpv_masterconsultastock.qs  -  description
                             -------------------
    begin                : lub nov 29 2010
    copyright            : Por ahora (C) 2010 by InfoSiAL S.L.
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
		this.ctx.interna_init();
	}
	function main() {
		this.ctx.interna_main();
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var tblStock_:FLTable;
	var aAlmacenes_:Array;
	var aAlmacenesI_:Array;
	var COL_REF:Number;
	var COL_DES:Number;
	var colsIzquierda_:Number;
	
	function oficial( context ) { interna( context ); } 
	function tbnArticulo_clicked() {
		return this.ctx.oficial_tbnArticulo_clicked()
	}
	function filtrarStock(referencia:String) {
		return this.ctx.oficial_filtrarStock(referencia);
	}
	function ledArticulo_returnPressed() {
		return this.ctx.oficial_ledArticulo_returnPressed();
	}
	function preparaTabla() {
		return this.ctx.oficial_preparaTabla();
	}
	function cargaAlmacenes():Boolean {
		return this.ctx.oficial_cargaAlmacenes();
	}
	function iniciaFiltro() {
		return this.ctx.oficial_iniciaFiltro();
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
/** \C 
*/
function interna_init()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	
	connect(this.child("tbnArticulo"), "clicked()", this, "iface.tbnArticulo_clicked");
	connect(this.child("ledArticulo"), "returnPressed()", this, "iface.ledArticulo_returnPressed");
	
	this.iface.preparaTabla();
	
	this.iface.iniciaFiltro();
}

function interna_main()
{
	flfact_tpv.iface.pub_consultarStock("");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_cargaAlmacenes():Boolean
{
	var qryAlmacen:FLSqlQuery = new FLSqlQuery;
	qryAlmacen.setTablesList("almacenes");
	qryAlmacen.setSelect("codalmacen, nombre");
	qryAlmacen.setFrom("almacenes");
	qryAlmacen.setWhere("1 = 1 ORDER BY codalmacen");
	qryAlmacen.setForwardOnly(true);
	if (!qryAlmacen.exec()) {
		return false;
	}
	this.iface.aAlmacenesI_ = new Array;
	this.iface.aAlmacenes_ = new Array;
	var i:Number = 0, codAlmacen:String;
	while (qryAlmacen.next()) {
		codAlmacen = qryAlmacen.value("codalmacen");
		this.iface.aAlmacenesI_[i] = codAlmacen;
		this.iface.aAlmacenes_[codAlmacen] = [];
		this.iface.aAlmacenes_[codAlmacen]["nombre"] = qryAlmacen.value("nombre");
		this.iface.aAlmacenes_[codAlmacen]["col"] = 0;
		i++;
	}
	return true;
}

function oficial_preparaTabla()
{
	this.iface.tblStock_ = this.child("tblStock");
	
	var util:FLUtil = new FLUtil;
	if (!this.iface.cargaAlmacenes()) {
		return false;
	}
	var numAlmacenes:Number = this.iface.aAlmacenesI_.length;
	
	this.iface.COL_REF = 0;
	this.iface.COL_DES = 1;
	this.iface.colsIzquierda_ = 2;
	var numCols:Number = this.iface.colsIzquierda_ + numAlmacenes;
	var sep:String = "*";
	var cabecera:String = util.translate("scripts", "Ref.") + sep + util.translate("scripts", "Artículo");

	this.iface.tblStock_.setNumCols(numCols);
	this.iface.tblStock_.setColumnWidth(this.iface.COL_REF, 80);
	this.iface.tblStock_.setColumnWidth(this.iface.COL_DES, 130);
	var codAlmacen:String, col:Number;
	for (var i:Number = 0 ; i < numAlmacenes; i++) {
		codAlmacen = this.iface.aAlmacenesI_[i];
		col = this.iface.colsIzquierda_ + i;
		this.iface.tblStock_.setColumnWidth(col, 100);
		cabecera += sep + this.iface.aAlmacenes_[codAlmacen]["nombre"];
		this.iface.aAlmacenes_[codAlmacen]["col"] = col;
	}
	this.iface.tblStock_.setColumnLabels(sep, cabecera);
}

function oficial_tbnArticulo_clicked()
{
	var util:FLUtil = new FLUtil();
	var f:Object = new FLFormSearchDB("articulos");
	f.setMainWidget();
	
	var referencia:String = f.exec("referencia");
	if (!referencia) {
		return false;
	}
	this.child("ledArticulo").text = referencia;
	this.iface.ledArticulo_returnPressed();
}

function oficial_ledArticulo_returnPressed()
{
	var referencia:String = this.child("ledArticulo").text;
	this.iface.filtrarStock(referencia);
}

function oficial_iniciaFiltro()
{
	var referencia:String = flfact_tpv.iface.dameRefConsultaStock();
	if (!referencia || referencia == "") {
		return;
	}
	this.child("ledArticulo").text = referencia;
	this.iface.ledArticulo_returnPressed();
}

function oficial_filtrarStock(referencia:String)
{
	var util:FLUtil = new FLUtil();
	
	var where:String;
	var descripcion:String = util.sqlSelect("articulos", "descripcion", "referencia = '" + referencia + "'");
	if (!descripcion) {
		descripcion = util.translate("scripts", "El artículo %1 no existe").arg(referencia);
		where = "1 = 2";
	} else {
		where = "s.referencia = '" + referencia + "'";
	}
		
	this.child("lblDesArticulo").text = descripcion;
	this.iface.tblStock_.setNumRows(0);
	var qryStock:FLSqlQuery = new FLSqlQuery;
	qryStock.setTablesList("stocks,articulos");
	qryStock.setSelect("s.referencia, s.cantidad, s.codalmacen, a.descripcion");
	qryStock.setFrom("stocks s INNER JOIN articulos a ON s.referencia = a.referencia");
	qryStock.setWhere(where + " ORDER BY s.referencia");
	qryStock.setForwardOnly(true);
	if (!qryStock.exec()) {
		return false;
	}
	var refAnterior:String = "", referencia:String, codAlmacen:String, cantidad:Number, fila:Number = -1, col:Number;
	while (qryStock.next()) {
		referencia = qryStock.value("s.referencia");
		codAlmacen = qryStock.value("s.codalmacen");
		cantidad = qryStock.value("s.cantidad");
		if (refAnterior == "" || refAnterior != referencia) {
			fila++;
			this.iface.tblStock_.insertRows(fila);
			this.iface.tblStock_.setText(fila, this.iface.COL_REF, referencia);
			this.iface.tblStock_.setText(fila, this.iface.COL_DES, qryStock.value("a.descripcion"));
		}
		col = this.iface.aAlmacenes_[codAlmacen]["col"];
		this.iface.tblStock_.setText(fila, col, cantidad);
		refAnterior = referencia;
	}
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
