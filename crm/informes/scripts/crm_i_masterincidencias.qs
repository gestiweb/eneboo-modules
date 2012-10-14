/***************************************************************************
                 crm_i_masterincidencias.qs  -  description
                             -------------------
    begin                : lun nov 13 2009
    copyright            : (C) 2009 by InfoSiAL S.L.
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var tbnImprimir:Object;
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
	this.iface.tbnImprimir = this.child("toolButtonPrint");
	connect(this.iface.tbnImprimir, "clicked()", this, "iface.lanzar()");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_lanzar()
{
	var cursor:FLSqlCursor = this.cursor()
	var seleccion:String = cursor.valueBuffer("id");
	if (!seleccion)
		return;
	
	var intervalo:Array = [];
	if (cursor.valueBuffer("codintervalo")){
		intervalo = flfactppal.iface.pub_calcularIntervalo(cursor.valueBuffer("codintervalo"));
		cursor.setValueBuffer("d_crm__incidencias_fecha", intervalo.desde);
		cursor.setValueBuffer("h_crm__incidencias_fecha", intervalo.hasta);
	}
	
	var orderBy:String = "";
	var o:String = "";
	for (var i:Number = 1; i < 3; i++) {
		o = this.iface.obtenerOrden(i, cursor);
		if (o) {
			if (orderBy == "") {
				orderBy = o;
			} else {
				orderBy += ", " + o;
			}
		}
	}
	
	flfactinfo.iface.pub_lanzarInforme(cursor, "crm_i_incidencias", orderBy);
}

function oficial_obtenerOrden(nivel:Number, cursor:FLSqlCursor):String
{
	var ret:String = "";
	var orden:String = cursor.valueBuffer("orden" + nivel.toString());
	switch(nivel) {
		case 1:
		case 2: {
			switch(orden) {
				case "Código": {
					ret += "crm_incidencias.codincidencia";
					break;
				}
				case "Fecha": {
					ret += "crm_incidencias.fecha";
					break;
				}
				case "Cliente/Proveedor": {
					ret += "crm_incidencias.codcliente,crm_incidencias.codproveedor";
					break;
				}
				case "Prioridad": {
					ret += "crm_incidencias.prioridad";
					break;
				}
			}
			break;
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
			case "Ascendente": {
				ret += " ASC";
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
