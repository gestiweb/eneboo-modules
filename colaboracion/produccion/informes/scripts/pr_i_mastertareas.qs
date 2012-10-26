/***************************************************************************
                 pr_i_mastertareas.qs  -  description
                             -------------------
    begin                : mar jul 22 2008
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
    function init() { this.ctx.interna_init(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    function oficial( context ) { interna( context ); } 
	function lanzar(cursor:FLSqlCursor) {
			return this.ctx.oficial_lanzar(cursor);
	}
	function obtenerOrden(nivel:Number, cursor:FLSqlCursor, tabla:String):String {
			return this.ctx.oficial_obtenerOrden(nivel, cursor, tabla);
	}
	function obtenerNombreInforme():String {
		return this.ctx.oficial_obtenerNombreInforme();
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
	function pub_lanzar(cursor:FLSqlCursor) {
		return this.lanzar(cursor);
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
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_lanzar(cursor:FLSqlCursor)
{
	if(!cursor)
		cursor = this.cursor()

	var seleccion:String = cursor.valueBuffer("id");
	if (!seleccion)
		return;

	var nombreInforme:String = this.iface.obtenerNombreInforme();

	
	var orderBy:String = "";
	if(nombreInforme == "pr_i_tareascc")
		orderBy = "pr_tareas.codcentro ASC";

	var o:String = "";
	for (var i:Number = 1; i < 3; i++) {
			o = this.iface.obtenerOrden(i, cursor, "albaranescli");
			if (o) {
					if (orderBy == "")
							orderBy = o;
					else
							orderBy += ", " + o;
			}
	}

	var intervalo:Array = [];
	if(cursor.valueBuffer("codintervalo")){
		intervalo = flfactppal.iface.pub_calcularIntervalo(cursor.valueBuffer("codintervalo"));
		cursor.setValueBuffer("d_pr__tareas_fechainicioprev",intervalo.desde);
		cursor.setValueBuffer("h_pr__tareas_fechainicioprev",intervalo.hasta);
	}

	var whereFijo:String = "pr_i_tareas.id = " + seleccion;
	if(cursor.valueBuffer("tareassinterminar"))
		whereFijo += "AND pr_tareas.estado IN ('PTE','EN CURSO')";

	flprodinfo.iface.pub_lanzarInforme(cursor, nombreInforme, orderBy, "", false, false, whereFijo);
}

function oficial_obtenerOrden(nivel:Number, cursor:FLSqlCursor, tabla:String):String
{
	var ret:String = "";
	var orden:String = cursor.valueBuffer("orden" + nivel.toString());
	switch(nivel) {
		case 1: {
				switch(orden) {
					case "Cliente": {
						ret += "clientes.nombre";
						break;
					}
					case "Pedido": {
						ret += "pedidoscli.codigo";
						break;
					}
					case "Orden": {
						ret += "pr_ordenesproduccion.codorden";
						break;
					}
					case "Lote": {
						ret += "pr_procesos.idobjeto";
						break;
					}
				}
		}
		break;
		case 2: {
				switch(orden) {
					case "Estado": {
						ret +="pr_tareas.estado";
						break;
					}
				}
		}
		break;
		case 3: {
				switch(orden) {
					case "Fecha prevista": {
						ret += "pr_tareas.fechainicioprev";
						break;
					}
				}
		}
		break;
	}
	if (ret != "") {
		var tipoOrden:String = cursor.valueBuffer("tipoorden" + nivel.toString());
		switch(tipoOrden) {
				case "Descendente": {
						ret += " DESC";
						break;
				}
		}
	}

	return ret;
}

function oficial_obtenerNombreInforme():String
{
	var cursor:FLSqlCursor = this.cursor();

	var nombreInforme:String = cursor.action();

	switch (cursor.valueBuffer("formato")) {
		case "Sin Agrupar": {
			nombreInforme = "pr_i_tareas";
			break;
		}
		case "Centros de coste": {
			nombreInforme = "pr_i_tareascc";
			break;
		}
	}

	return nombreInforme;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
