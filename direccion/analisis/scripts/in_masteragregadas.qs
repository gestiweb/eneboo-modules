/***************************************************************************
                 in_masteragregadas.qs  -  description
                             -------------------
    begin                : jue feb 4 2010
    copyright            : (C) 2010 by InfoSiAL S.L.
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
	function oficial( context ) { interna( context );}
	function tbnRecargar_clicked() {
		return this.ctx.oficial_tbnRecargar_clicked();
	}
	function recargarTabla(curAgregada:FLSqlCursor):Number {
		return this.ctx.oficial_recargarTabla(curAgregada);
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
\end */
function interna_init()
{
	var cursor:FLSqlCursor = this.cursor();
	
	var tbnRecargar:Object = this.child("tbnRecargar");
	connect (tbnRecargar, "clicked()", this, "iface.tbnRecargar_clicked");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_tbnRecargar_clicked()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	if (!cursor.isValid()) {
		return false;
	}

	var nombre:String = cursor.valueBuffer("nombre");
	var res:Number = MessageBox.information(util.translate("scripts", "Va a recargar la tabla %1. ¿Está seguro?").arg(nombre), MessageBox.Yes, MessageBox.No);
	if (res != MessageBox.Yes) {
		return;
	}

	var curTransaccion:FLSqlCursor = new FLSqlCursor("empresa");
	curTransaccion.transaction(false);
	try {
		var numRegistros:Number = this.iface.recargarTabla(cursor);
		if (numRegistros >= 0) {
			curTransaccion.commit();
			MessageBox.information(util.translate("scripts", "La tabla %1 se recargó corectamente con %2 registros").arg(nombre).arg(numRegistros), MessageBox.Ok, MessageBox.NoButton);
		} else {
			curTransaccion.rollback();
			MessageBox.warning(util.translate("scripts", "Ha habido un error al recargar la tabla %1").arg(nombre), MessageBox.Ok, MessageBox.NoButton);
		}
	} catch (e) {
		curTransaccion.rollback();
		MessageBox.critical(util.translate("scripts", "Error al recargar la tabla:\n") + e, MessageBox.Ok, MessageBox.NoButton);
	}
}

function oficial_recargarTabla(curAgregada:FLSqlCursor):Number
{
	var util:FLUtil = new FLUtil;

	curAgregada.setModeAccess(curAgregada.Edit);
	curAgregada.refreshBuffer();
	var numRegistros:Number = fldireinne.iface.pub_cargarTablaAgregada(curAgregada);
	if (numRegistros < 0) {
		return false;
	}
	curAgregada.setValueBuffer("registros", numRegistros);
	if (!curAgregada.commitBuffer()) {
		return false;
	}
	return numRegistros;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
