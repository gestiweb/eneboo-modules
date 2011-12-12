/***************************************************************************
                 i_masterriesgocli.qs  -  description
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
    function oficial( context ) { interna( context ); } 
	function lanzar() {
		return this.ctx.oficial_lanzar();
	}
	function obtenerOrden(nivel:Number, cursor:FLSqlCursor):String {
		return this.ctx.oficial_obtenerOrden(nivel, cursor);
	}
	function rellenarTabla() { return this.ctx.oficial_rellenarTabla(); }
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
function oficial_rellenarTabla()
{
	var util:FLUtil = new FLUtil();
	var curRiesgo:FLSqlCursor = new FLSqlCursor("i_riesgocli_buffer");
	
	var impRecibos:Number;
	var impPagados:Number;
	var impPendientes:Number;
	var riesgoExced:Number;
	var riesgoMax:Number;
	var nombreCliente:String;
	var nombreAgente:String;
	var apellidosAgente:String;
	
	if (!util.sqlDelete("i_riesgocli_buffer", "1 = 1"))
		return false;
	
	var desde:String = this.cursor().valueBuffer("dfecha");
	var hasta:String = this.cursor().valueBuffer("hfecha");
	var whereFechas:String = "1 = 1";
	if (desde && desde != "")
		whereFechas += " AND reciboscli.fecha >= '" + desde + "'";
	if (hasta && hasta != "")
		whereFechas += " AND reciboscli.fecha <= '" + hasta + "'";

	var qry:FLSqlQuery = new FLSqlQuery();
	qry.setTablesList("clientes,reciboscli,agentes");
	qry.setSelect("clientes.codcliente,SUM(reciboscli.importe),clientes.riesgomax, clientes.nombre, agentes.nombre, agentes.apellidos");
	qry.setFrom("clientes INNER JOIN reciboscli ON reciboscli.codcliente = clientes.codcliente LEFT OUTER JOIN agentes ON clientes.codagente = agentes.codagente");
	qry.setWhere(whereFechas + " GROUP BY clientes.codcliente, clientes.nombre, agentes.nombre, agentes.apellidos,clientes.riesgomax");

	if (!qry.exec())
		return false;

	while (qry.next()) {
		
		impRecibos = qry.value(1);
		impPendientes = util.sqlSelect("reciboscli", "SUM(importe)", whereFechas + " AND codcliente = '" + qry.value(0) + "' AND estado IN ('Emitido','Devuelto')");
		impPagados = impRecibos - impPendientes;
		riesgoMax = qry.value(2);
		riesgoExced = impPendientes - riesgoMax;
		nombreCliente = qry.value(3);
		nombreAgente = qry.value(4);
		apellidosAgente = qry.value(5);
		
		if(riesgoExced < 0)
			riesgoExced = 0;
		if(!nombreAgente)
			nombreAgente = "";
		if(!apellidosAgente)
			apellidosAgente = "";
		
		curRiesgo.setModeAccess(curRiesgo.Insert);
		curRiesgo.refreshBuffer();
		curRiesgo.setValueBuffer("nombreagente",nombreAgente + " " + apellidosAgente);
		curRiesgo.setValueBuffer("codcliente",qry.value(0));
		curRiesgo.setValueBuffer("nombrecliente",nombreCliente);
		curRiesgo.setValueBuffer("riesgomax",riesgoMax);
		curRiesgo.setValueBuffer("imprecibos",impRecibos);
		curRiesgo.setValueBuffer("imppagados",impPagados);
		curRiesgo.setValueBuffer("imppendientes",impPendientes);
		curRiesgo.setValueBuffer("riesgoexced",riesgoExced);
		curRiesgo.commitBuffer();
	}
}

function oficial_lanzar()
{
		var cursor:FLSqlCursor = this.cursor();
		var seleccion:String = cursor.valueBuffer("id");
		
		this.iface.rellenarTabla();
		
		if (!seleccion)
				return;
		var nombreInforme:String = cursor.action();
		var orderBy:String = "";
		var o:String = "";
		o = this.iface.obtenerOrden(cursor);
		if (o) {
			if (orderBy == "")
				orderBy = o;
			else
				orderBy += ", " + o;
			}
			
		var where:String = "i_riesgocli.id = " + this.cursor().valueBuffer("id");
		
		if (this.cursor().valueBuffer("soloriesgo") == true)
			where += " AND i_riesgocli_buffer.riesgoexced > 0";
			
		var intervalo:Array = [];
		if(cursor.valueBuffer("codintervalo")) {
			intervalo = flfactppal.iface.pub_calcularIntervalo(cursor.valueBuffer("codintervalo"));
			cursor.setValueBuffer("dfecha",intervalo.desde);
			cursor.setValueBuffer("hfecha",intervalo.hasta);
		}
		flfactinfo.iface.pub_lanzarInforme(cursor, nombreInforme, orderBy, "", false, false, where);
}

function oficial_obtenerOrden(cursor:FLSqlCursor):String
{
	var ret:String = "";
	var orden:String = cursor.valueBuffer("orden");
	
	switch(orden) {
		case "Código": {
			ret += "i_riesgocli_buffer.codcliente";
			break;
		}
		case "Nombre": {
			ret += "i_riesgocli_buffer.nombrecliente";
			break;
		}
	}
	
	if (ret != "") {
		var tipoOrden:String = cursor.valueBuffer("tipoorden");
		switch(tipoOrden) {
			case "Descendente": {
				ret += " DESC";
				break;
			}
		}
	}
	return ret;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
