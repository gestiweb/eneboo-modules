/***************************************************************************
                 i_masterclientes.qs  -  description
                             -------------------
    begin                : mar jun 27 2006
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
	function obtenerParamInforme():Array {
		return this.ctx.oficial_obtenerParamInforme();
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
function oficial_lanzar()
{
	var cursor:FLSqlCursor = this.cursor();
	
	var pI = this.iface.obtenerParamInforme();
	if (!pI)
		return;

	flfactinfo.iface.pub_establecerId(cursor.valueBuffer("id"));
	flfactinfo.iface.pub_lanzarInforme(cursor, pI.nombreInforme, pI.orderBy, pI.groupBy, pI.etiquetas, pI.impDirecta, pI.whereFijo, pI.nombreReport);
}

/** \D Obtiene un array con los parámetros necesarios para establecer el informe
@return	array de parámetros o false si hay error
\end */
function oficial_obtenerParamInforme():Array
{
	var paramInforme:Array = [];
	paramInforme["nombreInforme"] = false;
	paramInforme["orderBy"] = "";
	paramInforme["groupBy"] = false;
	paramInforme["etiquetas"] = false;
	paramInforme["impDirecta"] = false;
	paramInforme["whereFijo"] = false;
	paramInforme["nombreReport"] = false;
	paramInforme["numCopias"] = false;

	var cursor:FLSqlCursor = this.cursor();
	var seleccion:String = cursor.valueBuffer("id");
	if (!seleccion)
		return;
		
	paramInforme.nombreInforme = cursor.action();
	
	if (cursor.valueBuffer("agruparxgrupo")) {
		paramInforme.nombreInforme = "i_clientesxgrupo";
		paramInforme.orderBy = "clientes.codgrupo";
	}
	if (cursor.valueBuffer("agruparxagente")) {
		paramInforme.nombreInforme = "i_clientesxagente";
		paramInforme.orderBy = "clientes.codagente";
	}
	
	paramInforme.whereFijo = "dirclientes.domfacturacion = true";
	
	var orderBy:String = "";
	var o:String = "";
	for (var i:Number = 1; i <= 3; i++) {
		o = this.iface.obtenerOrden(i, cursor);
		if (o) {
			if (orderBy == "")
				orderBy = o;
			else
				orderBy += ", " + o;
		}
	}
	
	if (paramInforme.orderBy && orderBy)
		paramInforme.orderBy += ", ";
	
	paramInforme.orderBy += orderBy;
	return paramInforme;
}

function oficial_obtenerOrden(nivel:Number, cursor:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil;
	var ret:String = "";
	var orden:String = cursor.valueBuffer("orden" + nivel.toString());

	switch (orden) {
		case util.translate("scripts","Cod. cliente"):
				ret += "clientes.codcliente";
				break;
		case util.translate("scripts","Cliente"):
				ret += "clientes.nombre";
				break;
		case util.translate("scripts","Población"):
				ret += "dirclientes.ciudad";
				break;
		case util.translate("scripts","Provincia"):
				ret += "dirclientes.provincia";
				break;
		case util.translate("scripts","País"):
				ret += "dirclientes.codpais";
				break;
		case util.translate("scripts","Cod.Postal"):
				ret += "dirclientes.codpostal";
				break;
	}

	if (ret != "") {
			var tipoOrden:String = cursor.valueBuffer("tipoorden" + nivel.toString());
			if (tipoOrden == util.translate("scripts","Descendente"))
					ret += " DESC";
	}
	return ret;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////