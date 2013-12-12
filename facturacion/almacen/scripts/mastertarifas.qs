/***************************************************************************
                 masterarticulos.qs  -  description
                             -------------------
    begin                : jue jun 21 2007
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
    function init() { this.ctx.interna_init(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    var pbnTransferir:Object;
	function oficial( context ) { interna( context ); } 
	function pbnActualizar_clicked() {
		return this.ctx.oficial_pbnActualizar_clicked();
	}
	function actualizarPreciosTarifa(codTarifa:String):Boolean {
		return this.ctx.oficial_actualizarPreciosTarifa(codTarifa);
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
/** \C La tabla de regularizaciones de stocks se muestra en modo de sólo lectura
\end */
function interna_init()
{
	connect(this.child("pbnActualizar"), "clicked()", this, "iface.pbnActualizar_clicked()");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_pbnActualizar_clicked()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var curCommit:FLSqlCursor = new FLSqlCursor("tarifas");
	var codTarifa:String = cursor.valueBuffer("codtarifa"); 

	curCommit.transaction(false);
	try {
		if (this.iface.actualizarPreciosTarifa(codTarifa)) {
			curCommit.commit();
		} else {
			curCommit.rollback();
			return false;
		}
	} catch (e) {
		curCommit.rollback();
		MessageBox.critical(util.translate("scripts", "Hubo un error al actualizar los precios por tarifa: ") + e, MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	MessageBox.information(util.translate("scripts", "La tarifa %1 ha sido actualizada").arg(codTarifa), MessageBox.Ok, MessageBox.NoButton);
}

function oficial_actualizarPreciosTarifa(codTarifa:String):Boolean
{
	var util:FLUtil = new FLUtil;
	
	var res:Number = MessageBox.information(util.translate("scripts", "Se van a actualizar los precios de los articulos para la tarifa %1. \nEsto sobreescribirá cualquier precio que haya sido modificado manualmente.\n¿Desea continuar?").arg(codTarifa), MessageBox.Yes, MessageBox.No);
	if (res != MessageBox.Yes)
		return false;

	var curArt:FLSqlCursor = new FLSqlCursor("articulostarifas");
	curArt.select("codtarifa = '" + codTarifa + "'");
	util.createProgressDialog(util.translate("scripts", "Actualizando tarifa..."), curArt.size());
	var progreso = 0;
	while (curArt.next()) {
		progreso++;
		util.setProgress(progreso);

		curArt.setModeAccess(curArt.Edit);
		curArt.refreshBuffer();

		var incLineal:Number = parseFloat(util.sqlSelect("tarifas","inclineal","codtarifa = '" + codTarifa + "'"));
		if (!incLineal || isNaN(incLineal))
			incLineal = 0;

		var incPorcentual:Number = util.sqlSelect("tarifas","incporcentual","codtarifa = '" + codTarifa + "'");
		if (!incPorcentual || isNaN(incPorcentual))
			incPorcentual = 0;

		var pvp:Number = util.sqlSelect("articulos","pvp","referencia = '" + curArt.valueBuffer("referencia") + "'");
		if (!pvp || isNaN(pvp))
			pvp = 0;

		var pvpTarifa:Number = ((pvp * (100 + incPorcentual)) / 100) + incLineal;

		curArt.setValueBuffer("pvp", pvpTarifa);
		if (!curArt.commitBuffer()) {
			util.destroyProgressDialog();
			return false;
		}
	}
	util.destroyProgressDialog();
	return true;
}


//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
