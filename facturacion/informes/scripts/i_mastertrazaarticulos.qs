/***************************************************************************
                 i_masterventasmensual.qs  -  description
                             -------------------
    begin                : mie jun 7 2006
    copyright            : (C) 2006 by InfoSiAL S.L.
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
    function oficial( context ) { interna( context ); } 
	function lanzar() {
		return this.ctx.oficial_lanzar();
	}
	function rellenarDatos(cursor:FLSqlCursor) {
		return this.ctx.oficial_rellenarDatos(cursor);
	}
	function vaciarDatos() {
		return this.ctx.oficial_vaciarDatos();
	}
	function limpiarBuffer() {
		return this.ctx.oficial_limpiarBuffer();
	}
	function whereExtraFCompra():String {
		return this.ctx.oficial_whereExtraFCompra();
	}
	function whereExtraFVenta():String {
		return this.ctx.oficial_whereExtraFVenta();
	}
	function whereExtraRStock():String {
		return this.ctx.oficial_whereExtraRStock();
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
	function pub_rellenarDatos(cursor:FLSqlCursor) {
		return this.rellenarDatos(cursor);
	}
	function pub_vaciarDatos() {
		return this.vaciarDatos();
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
	connect (this.child("toolButtonPrint"), "clicked()", this, "iface.lanzar()");
	connect (this.child("toolButtonLimpiarBuffer"), "clicked()", this, "iface.limpiarBuffer()");
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_lanzar()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var seleccion:String = cursor.valueBuffer("id");
	if (!seleccion)
		return;
			
	if (cursor.valueBuffer("codintervalo")) {
		var intervalo:Array = [];
		intervalo = flfactppal.iface.pub_calcularIntervalo(cursor.valueBuffer("codintervalo"));
		cursor.setValueBuffer("fechadesde", intervalo.desde);
		cursor.setValueBuffer("fechahasta", intervalo.hasta);
	}
	
	if (!this.iface.rellenarDatos())
		return;
	
	var orden1:String = cursor.valueBuffer("orden1");
	var tipoOrden1:String = cursor.valueBuffer("tipoorden1");
	var orden2:String = cursor.valueBuffer("orden2");
	var tipoOrden2:String = cursor.valueBuffer("tipoorden2");
	var codFamilia:String = cursor.valueBuffer("codfamilia");
	
	var orderBy:String = "";
	var orderBy2:String = "";
	var where:String;
	
	switch(orden1) {
		case util.translate( "scripts", "Referencia"):
			orderBy += "i_trazaarticulos_buffer.referencia";
			break;
		case util.translate( "scripts", "Fecha"):
			orderBy += "i_trazaarticulos_buffer.fechafactura";
			break;
		case util.translate( "scripts", "Cliente/Proveedor"):
			orderBy += "i_trazaarticulos_buffer.nombrecliprov";
			break;
		case util.translate( "scripts", "Familia"):
			orderBy += "i_trazaarticulos_buffer.referencia";
			break;
	}
	
	if (orderBy && tipoOrden1 == util.translate( "scripts", "Descendente"))
		orderBy += " DESC";
	
	if (orderBy) {
		switch(orden2) {
			case util.translate( "scripts", "Referencia"):
				orderBy2 += ",i_trazaarticulos_buffer.referencia";
				break;
			case util.translate( "scripts", "Fecha"):
				orderBy2 += ",i_trazaarticulos_buffer.fechafactura";
				break;
			case util.translate( "scripts", "Cliente/Proveedor"):
				orderBy2 += ",i_trazaarticulos_buffer.nombrecliprov";
				break;
			case util.translate( "scripts", "Familia"):
				orderBy2 += ",i_trazaarticulos_buffer.referencia";
				break;
		}
		
		if (orderBy2 && tipoOrden2 == util.translate( "scripts", "Descendente"))
			orderBy2 += " DESC";
	}
		
	orderBy += orderBy2;
	
	
	where = "i_trazaarticulos_buffer.idsesion = '" + sys.idSession() + "' AND i_trazaarticulos.id = " + seleccion;
	
	if (codFamilia)
		where += " AND articulos.codfamilia = '" + codFamilia + "'";
	
 	var nombreInforme:String = cursor.action();
  	flfactinfo.iface.pub_lanzarInforme(cursor, nombreInforme, orderBy, false, false, false, where);

	this.iface.vaciarDatos();
}

function oficial_rellenarDatos(cursor:FLSqlCursor)
{
	if (!cursor)
		cursor = this.cursor();
	
	var util:FLUtil = new FLUtil();
	
	var curTab:FLSqlCursor = new FLSqlCursor("i_trazaarticulos_buffer");
 	var paso:Number = 0;
 	
 	var idSesion = sys.idSession();
	
	var fechaDesde = cursor.valueBuffer("fechadesde");
	var fechaHasta = cursor.valueBuffer("fechahasta");
	var referenciaDesde:String = cursor.valueBuffer("referenciadesde");
	var referenciaHasta:String = cursor.valueBuffer("referenciahasta");
	var almacenDesde:String = cursor.valueBuffer("almacendesde");
	var almacenHasta:String = cursor.valueBuffer("almacenhasta");
	var clienteDesde:String = cursor.valueBuffer("clientedesde");
	var clienteHasta:String = cursor.valueBuffer("clientehasta");
	var proveedorDesde:String = cursor.valueBuffer("proveedordesde");
	var proveedorHasta:String = cursor.valueBuffer("proveedorhasta");
	
	var verCompras:Boolean = cursor.valueBuffer("vercompras");
	var verVentas:Boolean = cursor.valueBuffer("verventas");
	var verRegstock:Boolean = cursor.valueBuffer("verregstock");
	var recCompras:Boolean = cursor.valueBuffer("reccompras");
	var recVentas:Boolean = cursor.valueBuffer("recventas");	
		
	var q:FLSqlQuery;
	var where:String = "1=1";
	var referencia:String, descripcion:String, nombre:String;
	var movimiento:String, cantidad:Number, precio:Number;
	var fechaFactura:String, fechaAlbaran:String;
	var codFactura:String, codAlbaran:String;
	
	
	// PASO 1 - FACTURAS DE VENTA
	if (fechaDesde)
		where += " AND f.fecha >= '" + fechaDesde + "'";
	if (fechaHasta)
		where += " AND f.fecha <= '" + fechaHasta + "'";
	
	if (referenciaDesde)
		where += " AND l.referencia >= '" + referenciaDesde + "'";
	if (referenciaHasta)
		where += " AND l.referencia <= '" + referenciaHasta + "'";
	
	if (clienteDesde)
		where += " AND f.codcliente >= '" + clienteDesde + "'";
	if (clienteHasta)
		where += " AND f.codcliente <= '" + clienteHasta + "'";
	if (clienteHasta || clienteDesde)
		where += " AND f.codcliente IS NOT NULL";
	
	if (almacenDesde)
		where += " AND f.codalmacen >= '" + almacenDesde + "'";
	if (almacenHasta)
		where += " AND f.codalmacen <= '" + almacenHasta + "'";

	var wE:String = this.iface.whereExtraFVenta();
	where += wE;
	
	q = new FLSqlQuery();
	q.setTablesList("facturascli,lineasfacturascli,albaranescli");
	q.setSelect("l.referencia,l.descripcion,f.nombrecliente,l.cantidad,l.pvptotal,a.fecha,a.codigo,f.fecha,f.codigo,f.idfacturarect,l.dtopor,l.pvpunitario");
	q.setFrom("facturascli f " +
				"INNER JOIN lineasfacturascli l ON f.idfactura = l.idfactura " +
				"LEFT JOIN albaranescli a ON l.idalbaran = a.idalbaran");
	q.setWhere(where);
	debug(q.sql());
	
 	paso = 0;
	
	if (!q.exec()) {
		MessageBox.critical(util.translate("scripts", "Falló la consulta"),
				MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return;
	}
			
 	util.createProgressDialog( util.translate( "scripts", "Recabando datos..." ), q.size() );
	
	while(q.next()) {
		
		util.setProgress(paso++);
		
		util.setLabelText(util.translate( "scripts", "Recabando datos de ventas" ));
		
		if (!q.value(9) && !verVentas) // Venta
			continue;
		
		if (q.value(9) && !recVentas) // Rectificativa
			continue;
		
		curTab.setModeAccess(curTab.Insert);
		curTab.refreshBuffer();
		curTab.setValueBuffer("referencia", q.value(0));
		curTab.setValueBuffer("descripcion", q.value(1));
		curTab.setValueBuffer("nombrecliprov", q.value(2));
		curTab.setValueBuffer("cantidad", q.value(3));
		curTab.setValueBuffer("precio", q.value(4));
		curTab.setValueBuffer("fechaalbaran", q.value(5));
		curTab.setValueBuffer("codalbaran", q.value(6));
		curTab.setValueBuffer("fechafactura", q.value(7));
		curTab.setValueBuffer("codfactura", q.value(8));
		curTab.setValueBuffer("idsesion", idSesion);
		curTab.setValueBuffer("dtopor", q.value(10));
		curTab.setValueBuffer("preciounidad", q.value(11));
		
		if (q.value(9))
			curTab.setValueBuffer("movimiento", "D");
		else
			curTab.setValueBuffer("movimiento", "V");
		
		curTab.commitBuffer();
	}
	
	util.destroyProgressDialog();
			
	
	
	// PASO 2 - FACTURAS DE COMPRA	
	where = "1=1";
	if (fechaDesde)
		where += " AND f.fecha >= '" + fechaDesde + "'";
	if (fechaHasta)
		where += " AND f.fecha <= '" + fechaHasta + "'";
	
	if (referenciaDesde)
		where += " AND l.referencia >= '" + referenciaDesde + "'";
	if (referenciaHasta)
		where += " AND l.referencia <= '" + referenciaHasta + "'";
	
	if (proveedorDesde)
		where += " AND f.codproveedor >= '" + proveedorDesde + "'";
	if (proveedorHasta)
		where += " AND f.codproveedor <= '" + proveedorHasta + "'";
	
	if (almacenDesde)
		where += " AND f.codalmacen >= '" + almacenDesde + "'";
	if (almacenHasta)
		where += " AND f.codalmacen <= '" + almacenHasta + "'";
	
	var wE:String = this.iface.whereExtraFCompra();
	where += wE;
		
	q = new FLSqlQuery();
	q.setTablesList("facturasprov,lineasfacturasprov,albaranesprov");
	q.setSelect("l.referencia,l.descripcion,f.nombre,l.cantidad,l.pvptotal,a.fecha,a.codigo,f.fecha,f.codigo,f.idfacturarect,l.dtopor,l.pvpunitario");
	q.setFrom("facturasprov f " +
				"INNER JOIN lineasfacturasprov l ON f.idfactura = l.idfactura " +
				"LEFT JOIN albaranesprov a ON l.idalbaran = a.idalbaran");
	q.setWhere(where);
	
 	paso2 = 0;
	
	if (!q.exec()) {
		MessageBox.critical(util.translate("scripts", "Falló la consulta"),
				MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return;
	}
			
 	util.createProgressDialog( util.translate( "scripts", "Recabando datos..." ), q.size() );
	
	while(q.next()) {
		
		util.setProgress(paso2++);
		
		if (!q.value(9) && !verCompras) // Compra
			continue;
		
		if (q.value(9) && !recCompras) // Rectificativa
			continue;
		
		util.setLabelText(util.translate( "scripts", "Recabando datos de compras" ));
		
		curTab.setModeAccess(curTab.Insert);
		curTab.refreshBuffer();
		curTab.setValueBuffer("referencia", q.value(0));
		curTab.setValueBuffer("descripcion", q.value(1));
		curTab.setValueBuffer("nombrecliprov", q.value(2));
		curTab.setValueBuffer("cantidad", q.value(3));
		curTab.setValueBuffer("precio", q.value(4));
		curTab.setValueBuffer("fechaalbaran", q.value(5));
		curTab.setValueBuffer("codalbaran", q.value(6));
		curTab.setValueBuffer("fechafactura", q.value(7));
		curTab.setValueBuffer("codfactura", q.value(8));
		curTab.setValueBuffer("idsesion", idSesion);
		curTab.setValueBuffer("dtopor", q.value(10));
		curTab.setValueBuffer("preciounidad", q.value(11));
		
		if (q.value(9))
			curTab.setValueBuffer("movimiento", "E");
		else
			curTab.setValueBuffer("movimiento", "C");
		
		curTab.commitBuffer();
	}
	
	util.destroyProgressDialog();
			
	
	// PASO 3 - REGULARIZACIONES DE STOCK
	if (verRegstock) {
	
		where = "1=1";
		if (fechaDesde)
			where += " AND l.fecha >= '" + fechaDesde + "'";
		if (fechaHasta)
			where += " AND l.fecha <= '" + fechaHasta + "'";
		
		if (referenciaDesde)
			where += " AND a.referencia >= '" + referenciaDesde + "'";
		if (referenciaHasta)
			where += " AND a.referencia <= '" + referenciaHasta + "'";
		
		if (almacenDesde)
			where += " AND s.codalmacen >= '" + almacenDesde + "'";
		if (almacenHasta)
			where += " AND s.codalmacen <= '" + almacenHasta + "'";

		var wE:String = this.iface.whereExtraRStock();
		where += wE;
	
		q = new FLSqlQuery();
		q.setTablesList("stocks,lineasregstocks,articulos");
		q.setSelect("a.referencia,a.descripcion,l.cantidadfin-l.cantidadini,l.fecha");
		q.setFrom("lineasregstocks l " +
					"INNER JOIN stocks s ON s.idstock = l.idstock " +
					"INNER JOIN articulos a ON s.referencia = a.referencia");
		q.setWhere(where);
		
		paso3 = 0;
		
		if (!q.exec()) {
			MessageBox.critical(util.translate("scripts", "Falló la consulta"),
					MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			return;
		}
				
		util.createProgressDialog( util.translate( "scripts", "Recabando datos..." ), q.size() );
		
		while(q.next()) {
			
			util.setProgress(paso3++);		
			
			util.setLabelText(util.translate( "scripts", "Recabando regularizaciones de stocks"));
			
			curTab.setModeAccess(curTab.Insert);
			curTab.refreshBuffer();
			curTab.setValueBuffer("referencia", q.value(0));
			curTab.setValueBuffer("descripcion", q.value(1));
			curTab.setValueBuffer("cantidad", q.value(2));
			curTab.setValueBuffer("fechafactura", q.value(3));		
			curTab.setValueBuffer("movimiento", "R");
			curTab.setValueBuffer("idsesion", idSesion);
			
			curTab.commitBuffer();
		}
		
		util.destroyProgressDialog();
	}
	
	
	if (paso == 0 && paso2 == 0 && paso3 == 0) {
		MessageBox.warning(util.translate("scripts",
				"No hay registros que cumplan los criterios de búsqueda establecidos"),
				MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
	
	return true;
}

function oficial_vaciarDatos()
{
	var util:FLUtil = new FLUtil();
	if (util.sqlDelete("i_trazaarticulos_buffer", "idsesion = '" + sys.idSession() + "'"))
		return true;
	
	return false
}


function oficial_limpiarBuffer()
{
	var util:FLUtil = new FLUtil();
	if (util.sqlDelete("i_trazaarticulos_buffer", "1=1"))
		MessageBox.information(util.translate("scripts", "Se vació el buffer"),
				MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
}

function oficial_whereExtraFCompra():String
{
	return "";
}

function oficial_whereExtraFVenta():String
{
	return "";
}

function oficial_whereExtraRStock():String
{
	return "";
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////