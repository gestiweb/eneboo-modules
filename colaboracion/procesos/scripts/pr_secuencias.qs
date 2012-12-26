/***************************************************************************
                 pr_secuencias.qs  -  description
                             -------------------
    begin                : mar sep 18 2007
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
/** \C
El formulario gestiona los distintos tipos de proceso, permitiendo lanzar procesos del tipo seleccionado
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
	function validateForm():Boolean {
		return this.ctx.interna_validateForm();
	}
	function calculateField(fN:String):String {
		return this.ctx.interna_calculateField(fN);
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	function oficial( context ) { interna( context ); }
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function habilitarCondicionada() {
		return this.ctx.oficial_habilitarCondicionada();
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

	this.iface.habilitarCondicionada();
}

function interna_validateForm():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	var tareaInicio:String = cursor.valueBuffer("tareainicio");
	var tareaFin:String = cursor.valueBuffer("tareafin");
	if ( tareaInicio == tareaFin) {
		MessageBox.warning(util.translate("scripts", "Las tareas de inicio y fin no puedene coincidir"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	if (util.sqlSelect("pr_secuencias", "idsecuencia", "idtipoproceso = '" + cursor.valueBuffer("idtipoproceso") + "' AND tareainicio = '" + tareaInicio + "' AND tareafin = '" + tareaFin + "' AND idsecuencia <> " + cursor.valueBuffer("idsecuencia"))) {
		MessageBox.warning(util.translate("scripts", "Ya existe una secuencia con las tareas de inicio y fin especificadas para este tipo de proceso"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	return true;
}

function interna_calculateField(fN:String):String
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var valor:String;
	switch (fN) {
	}
	return valor;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_bufferChanged(fN:String)
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	switch (fN) {
		case "condicionada": {
			this.iface.habilitarCondicionada();
			break;
		}
	}
}

function oficial_habilitarCondicionada()
{
	/// Por ahora se calcula la condición sólo desde código
	this.child("fdbCondicionada").close();
	this.child("gbxCondicion").close();
	return;

	var cursor:FLSqlCursor = this.cursor();
	if (cursor.valueBuffer("condicionada")) {
		this.child("gbxCondicion").enabled = true;
	} else {
		this.child("gbxCondicion").enabled = false;
	}
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
