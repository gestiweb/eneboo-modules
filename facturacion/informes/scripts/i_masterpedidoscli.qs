/***************************************************************************
                 i_masterpedidoscli.qs  -  description
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
	function obtenerParamInforme():Array {
		return this.ctx.oficial_obtenerParamInforme();
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

	flfactinfo.iface.pub_lanzarInforme(cursor, pI.nombreInforme, pI.orderBy, pI.groupBy, pI.etiquetas, pI.impDirecta, pI.whereFijo);
}

/** \D Obtiene un array con los parámetros necesarios para establecer el informe
@return	array de parámetros o false si hay error
\end */
function oficial_obtenerParamInforme():Array
{
	var paramInforme:Array = [];
	paramInforme["nombreInforme"] = false;
	paramInforme["orderBy"] = false;
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
	paramInforme.orderBy = "";
	var o:String = "";
	for (var i:Number = 1; i < 3; i++) {
		o = formi_albaranescli.iface.pub_obtenerOrden(i, cursor, "pedidoscli");
		if (o) {
			if (paramInforme.orderBy == "")
				paramInforme.orderBy = o;
			else
				paramInforme.orderBy += ", " + o;
		}
	}

// 	if (cursor.valueBuffer("pedidoscli_servido") == "Todos" || !cursor.valueBuffer("pedidoscli_servido"))
// 		paramInforme.whereFijo = "";
// 	else
// 		paramInforme.whereFijo = "pedidoscli.servido = '" + cursor.valueBuffer("pedidoscli_servido") + "'";
	
	if (cursor.valueBuffer("codintervalo")) {
		var intervalo:Array = [];
		intervalo = flfactppal.iface.pub_calcularIntervalo(cursor.valueBuffer("codintervalo"));
		cursor.setValueBuffer("d_pedidoscli_fecha", intervalo.desde);
		cursor.setValueBuffer("h_pedidoscli_fecha", intervalo.hasta);
	}
	
	return paramInforme;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
