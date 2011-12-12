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
	function whereExtra():String {
		return this.ctx.oficial_whereExtra();
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
	connect (this.child("toolButtonPrint"), "clicked()", this, "iface.lanzar()");
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
			
	var codEjercicio = cursor.valueBuffer("codejercicio");
	var codFamilia = cursor.valueBuffer("codfamilia");
	var codSerie = cursor.valueBuffer("codserie");
	var fechaInicio = cursor.valueBuffer("fechainicio");
	var fechaFin = cursor.valueBuffer("fechafin");
	
	var whereEjercicio:String = "";
	if (codEjercicio)
		whereEjercicio = " AND facturascli.codejercicio = '" + codEjercicio + "' ";
	
	var whereFamilia:String = "";
	if (codFamilia)
		whereFamilia = " AND articulos.codfamilia = '" + codFamilia + "' ";
	
	var whereSerie:String = "";
	if (codSerie)
		whereSerie = " AND facturascli.codserie = '" + codSerie + "' ";
	
	var whereFechaFin:String = "";
	if (fechaFin)
		whereFechaFin = " AND facturascli.fecha <= '" + fechaFin + "' ";
	
	var wE:String = this.iface.whereExtra();

	var q:FLSqlQuery = new FLSqlQuery;
	q.setTablesList("facturascli,lineasfacturascli,articulos");
	q.setSelect("articulos.referencia,facturascli.fecha,sum(lineasfacturascli.cantidad),articulos.descripcion");
	q.setFrom("articulos INNER JOIN lineasfacturascli ON lineasfacturascli.referencia = articulos.referencia INNER JOIN facturascli ON lineasfacturascli.idfactura = facturascli.idfactura");
	q.setWhere("facturascli.fecha >= '" + fechaInicio + "'" + whereFechaFin + whereEjercicio + whereFamilia + whereSerie + wE + "GROUP BY articulos.referencia, articulos.descripcion, facturascli.fecha ORDER BY referencia, fecha");
	
	var contenido:Number = 0;
	var partesFecha:Array, fecha:String, referencia:String, descripcion:String, ventas:Number;
	var curTab:FLSqlCursor = new FLSqlCursor("i_ventasmensual_buffer");
 	var paso:Number = 0;
	
	// Vaciar la tabla
	var numRegBuf:Number = util.sqlSelect("i_ventasmensual_buffer", "count(id)", "1=1");
 	util.createProgressDialog( util.translate( "scripts", "Preparando informe..." ), numRegBuf );
	curTab.select();
	while(curTab.next()) {
		curTab.setModeAccess(curTab.Del);
		curTab.refreshBuffer();
		curTab.commitBuffer();
		util.setProgress(paso++);
	}
	util.destroyProgressDialog();
	
 	paso = 0;
	
	if (!q.exec()) {
		MessageBox.critical(util.translate("scripts", "Falló la consulta"),
				MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return;
	}
			
 	util.createProgressDialog( util.translate( "scripts", "Recabando datos de ventas..." ), q.size() );
	
	while(q.next()) {
		
		util.setProgress(paso++);
		
		referencia = q.value(0);
		partesFecha = q.value(1).toString().split("-");
		mes = partesFecha[1];
		ventas = q.value(2);
		descripcion = q.value(3);
		
// 		debug(mes + " - " + referencia + " - " + ventas);
		util.setLabelText(util.translate( "scripts", "Recabando datos de ventas\nArtículo " ) + referencia);
		
		curTab.setModeAccess(curTab.Insert);
		curTab.refreshBuffer();
		curTab.setValueBuffer("referencia", referencia);
		curTab.setValueBuffer("descripcion", descripcion);
		curTab.setValueBuffer("ventas" + mes, ventas);
		curTab.setValueBuffer("ventasart", ventas);
		curTab.commitBuffer();
	}
	
	util.destroyProgressDialog();
			
	if (paso == 0) {
		MessageBox.warning(util.translate("scripts",
				"No hay registros que cumplan los criterios de búsqueda establecidos"),
				MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return;
	}
	
	var nombreInforme:String = cursor.action();
	
 	flfactinfo.iface.pub_lanzarInforme(cursor, nombreInforme, "referencia", "referencia,i_ventasmensual_buffer.descripcion,empresa.nombre,i_ventasmensual.fechainicio,i_ventasmensual.fechafin,i_ventasmensual.codejercicio,i_ventasmensual.codfamilia,i_ventasmensual.codserie", false, false, "i_ventasmensual.id = " + seleccion);
}

function oficial_whereExtra():String
{
	return "";
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
