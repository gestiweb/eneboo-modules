/***************************************************************************
                 pr_tipostareapro.qs  -  description
                             -------------------
    begin                : mie oct 18 2006
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
/** \C
El formulario muestra una tarea asociada a un determinado tipo de proceso
\end */
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    function oficial( context ) { interna( context ); } 
	function habilitarCodigoTarea() {
		return this.ctx.oficial_habilitarCodigoTarea();
	}
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function calculateField(fN:String):String {
		return this.ctx.oficial_calculateField(fN);
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
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");

	this.child("fdbIdAlias").setFilter("idtipoproceso = '" + cursor.valueBuffer("idtipoproceso") + "'");

	switch (cursor.modeAccess()) {
		case cursor.Insert: {
			var orden:Number = parseFloat(util.sqlSelect("pr_tipostareapro", "ordenlista", "idtipoproceso = '" + cursor.valueBuffer("idtipoproceso") + "' ORDER BY ordenlista DESC"));
			if (!orden || isNaN(orden))
				orden = 0;
			orden++;
			this.child("fdbOrdenLista").setValue(orden);
			break;
		}
	}
	// Gestión documental
	if (sys.isLoadedModule("flcolagedo")) {
		var datosGD:Array;
		datosGD["txtRaiz"] = cursor.valueBuffer("idtipotareapro") + ": " + cursor.valueBuffer("descripcion");
		datosGD["tipoRaiz"] = "pr_tipostareapro";
		datosGD["idRaiz"] = cursor.valueBuffer("idtipotareapro");
		flcolagedo.iface.pub_gestionDocumentalOn(this, datosGD);
	} else {
		this.child("tbwTiposTareaPro").setTabEnabled("documentos", false);
	}
	this.iface.habilitarCodigoTarea();
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_habilitarCodigoTarea()
{
	var cursor:FLSqlCursor = this.cursor();

	var deshabilitar:Boolean = (cursor.modeAccess() != cursor.Insert);
	this.child("fdbCodTipoTareaPro").setDisabled(deshabilitar);
}

function oficial_bufferChanged(fN:String)
{
	var cursor:FLSqlCursor = this.cursor();
	switch (fN) {
		case "idtipotarea": {
			if (cursor.modeAccess() == cursor.Insert) {
				this.child("fdbCodTipoTareaPro").setValue(this.iface.calculateField("codtipotareapro"));
			}
			break;
		}
	}
}

function oficial_calculateField(fN:String):String
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var valor:String;
	switch (fN) {
		case "codtipotareapro": {
			var idTipoProceso:String = cursor.valueBuffer("idtipoproceso");
			valor = idTipoProceso + "_" + cursor.valueBuffer("idtipotarea");
			var rep:Number = util.sqlSelect("pr_tipostareapro", "COUNT(*)", "idtipoproceso = '" + idTipoProceso + "' AND codtipotareapro LIKE '" + valor + "%'");
			if (!isNaN(rep) && rep > 0) {
				rep++;
				valor += "_" + rep.toString();
			}
			break;
		}
	}
	return valor;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
