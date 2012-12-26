/***************************************************************************
         pr_lotesproducto.qs  -  description
                             -------------------
    begin                : mie abr 18 2007
    copyright            : (C) 2007 by InfoSiAL S.L.
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
	function calculateCounter():String {
		return this.ctx.interna_calculateCounter();
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var tdbProduccion:Object;
	var lblSubestado:Object;
	function oficial( context ) { interna( context ); } 
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
	function pub_calculateCounter():String {
		return this.calculateCounter();
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
	var util:FLUtil = new FLUtil;
	this.iface.tdbProduccion = this.child("tdbProduccion");
	this.iface.lblSubestado = this.child("lblSubestado");

	var cursor:FLSqlCursor = this.cursor();
/** \C
Si ha comenzado el proceso de producción asociado a la unidad de producto seleccionada, el proceso es mostrado en la tabla inferior
\end */
	var idProceso:String = util.sqlSelect("pr_procesos", "idproceso", "idobjeto = '" + cursor.valueBuffer("idlote") + "'" + " AND idtipoproceso IN ('PROD', 'ALMOHA')");
	if (idProceso) {
		this.iface.tdbProduccion.cursor().setMainFilter("idproceso = " + idProceso);
		this.iface.lblSubestado.setText(util.sqlSelect("pr_procesos", "subestado", "idproceso = " + idProceso));
	} else
		this.iface.tdbProduccion.cursor().setMainFilter("1 = 2");
	this.iface.tdbProduccion.refresh();
}

function interna_calculateCounter():String
{
	var util:FLUtil = new FLUtil();
	var id:String = "LP00000001";
	var idUltimo:String = util.sqlSelect("pr_lotesproducto", "idlote", "idlote LIKE 'LP%' ORDER BY idlote DESC");
	if (idUltimo) {
		var numUltimo:Number = parseFloat(idUltimo.right(8));
		id = "LP" + flprodppal.iface.pub_cerosIzquierda((++numUltimo).toString(), 8);
	}
	
	return id;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
