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
	function obtenerOrden(nivel:Number, cursor:FLSqlCursor):String {
		return this.ctx.oficial_obtenerOrden(nivel, cursor);
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

function oficial_obtenerOrden(nivel:Number, cursor:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil();
	var ret:String = "";
	var orden:String = cursor.valueBuffer("orden" + nivel.toString());
	switch(nivel) {
		case 1:
			switch(orden) {
				case util.translate("scripts","Código de cliente"):
					ret += "i_ventasmcli_buffer.codcliente";
				break;
				case util.translate("scripts","Nombre de cliente"):
					ret += "i_ventasmcli_buffer.nombre";
				break;
				case util.translate("scripts","Volumen de ventas"):
					ret += "sum(ventascli)";
				break;
			}
			break;
		break;
	}
	
	if (ret) {
		var tipoOrden:String = cursor.valueBuffer("tipoorden" + nivel.toString());
		switch(tipoOrden) {
			case util.translate("scripts","Descendente"):
				ret += " DESC";
				break;
		}
	}

	return ret;
}

function oficial_lanzar()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var seleccion:String = cursor.valueBuffer("id");
	if (!seleccion)
		return;
			
	var codEjercicio = cursor.valueBuffer("codejercicio");
	var clienteDesde = cursor.valueBuffer("clientedesde");
	var clienteHasta = cursor.valueBuffer("clientehasta");
	var codSerie = cursor.valueBuffer("codserie");
	var fechaInicio = cursor.valueBuffer("fechainicio");
	var fechaFin = cursor.valueBuffer("fechafin");
	
	var whereEjercicio:String = "";
	if (codEjercicio)
		whereEjercicio = " AND codejercicio = '" + codEjercicio + "' ";
	
	var whereSerie:String = "";
	if (codSerie)
		whereSerie = " AND codserie = '" + codSerie + "' ";
	
	var whereFecha:String = "";
	if (fechaInicio)
		whereFecha += " AND fecha >= '" + fechaInicio + "' ";
	if (fechaFin)
		whereFecha += " AND fecha <= '" + fechaFin + "' ";
	
	var whereCliente:String = "";
	if (clienteDesde)
		whereCliente += " AND codcliente >= '" + clienteDesde + "' ";
	if (clienteHasta)
		whereCliente += " AND codcliente <= '" + clienteHasta + "' ";
	
	var q:FLSqlQuery = new FLSqlQuery;
	q.setTablesList("facturascli");
	q.setSelect("codcliente,fecha,total,nombrecliente");
	q.setFrom("facturascli");
	q.setWhere("1=1 " + whereFecha + whereCliente + whereEjercicio + whereSerie);
	
	var contenido:Number = 0;
	var partesFecha:Array, fecha:String, codCliente:String, nomCliente:String, ventas:Number;
	var curTab:FLSqlCursor = new FLSqlCursor("i_ventasmcli_buffer");
 	var paso:Number = 0;
	
	// Vaciar la tabla
	var numRegBuf:Number = util.sqlSelect("i_ventasmcli_buffer", "count(id)", "1=1");
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
		
		codCliente = q.value(0);
		partesFecha = q.value(1).toString().split("-");
		mes = partesFecha[1];
		ventas = q.value(2);
		nomCliente = q.value(3);
		
 		debug(mes + " - " + codCliente + " - " + ventas);
		util.setLabelText(util.translate( "scripts", "Recabando datos de ventas\nCliente " ) + codCliente);
		
		curTab.setModeAccess(curTab.Insert);
		curTab.refreshBuffer();
		curTab.setValueBuffer("codcliente", codCliente);
		curTab.setValueBuffer("nombre", nomCliente);
		curTab.setValueBuffer("ventas" + mes, ventas);
		curTab.setValueBuffer("ventascli", ventas);
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
	
	var orderBy:String = "";
	var o:String = "";
	o = this.iface.obtenerOrden(1, cursor);
	if (o) {
		if (orderBy == "")
			orderBy = o;
		else
			orderBy += ", " + o;
	}
	
 	flfactinfo.iface.pub_lanzarInforme(cursor, nombreInforme, orderBy, "codcliente,i_ventasmcli_buffer.nombre,empresa.nombre,i_ventasmcli.fechainicio,i_ventasmcli.fechafin,i_ventasmcli.codejercicio,i_ventasmcli.clientedesde,i_ventasmcli.clientehasta,i_ventasmcli.codserie", false, false, "i_ventasmcli.id = " + seleccion);
}


//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
