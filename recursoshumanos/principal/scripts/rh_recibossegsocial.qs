/***************************************************************************
                 rh_recibossegsocial.qs  -  description
                             -------------------
    begin                : jue jul 26 2007
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
	function calculateCounter():String { 
		return this.ctx.interna_calculateCounter(); 
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
	var tbnBuscar:Object;
	var tbDelete:Object;
	function oficial( context ) { interna( context ); } 
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function calcularTotalNominas() {
		return this.ctx.oficial_calcularTotalNominas();
	}
	function filtrarNominas() {
		return this.ctx.oficial_filtrarNominas();
	}
	function quitarNomina() {
		return this.ctx.oficial_quitarNomina();
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
	var cursor:FLSqlCursor = this.cursor();

	this.iface.tbnBuscar = this.child("tbnBuscar");
	this.iface.tbDelete = this.child("tbDelete");

	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this.iface.tbnBuscar, "clicked()", this, "iface.filtrarNominas");
	connect(this.iface.tbDelete, "clicked()", this, "iface.quitarNomina");

	if (cursor.modeAccess() == cursor.Insert) 
		this.child("fdbCodEjercicio").setValue(flfactppal.iface.pub_ejercicioActual());

	this.child("tdbNominas").cursor().setMainFilter("codrecibo = '" + this.cursor().valueBuffer("codrecibo") + "'");
	this.child("tdbNominas").refresh();
	this.iface.calcularTotalNominas();
	this.child("tdbPartidas").setReadOnly(true);
}

function interna_calculateCounter()
{
	var util:FLUtil = new FLUtil();
	return util.nextCounter("codrecibo", this.cursor());
}

function interna_calculateField(fN:String):String
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var res:String = "";
	
	switch (fN) {
		case "totalnominas": {
			var total:Number = 0;
			var qry:FLSqlQuery = new FLSqlQuery();
			qry.setTablesList("rh_nominas");
			qry.setSelect("segsocial");
			qry.setFrom("rh_nominas");
			qry.setWhere("codrecibo = '" + cursor.valueBuffer("codrecibo") + "'");
			if (!qry.exec())
				return;
			while (qry.next()) {
				total += parseFloat(qry.value("segsocial"));
			}
			res = total;
			break;
		}
		case "resto": {
			res = parseFloat(cursor.valueBuffer("total")) - parseFloat(cursor.valueBuffer("totalnominas")); 
		}
	}
	return res;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_filtrarNominas()
{
	var util:FLUtil;

	if (this.cursor().modeAccess() == this.cursor().Insert) { 
		if (!this.child("tdbPartidas").cursor().commitBufferCursorRelation())
			return false;
	}

	var filtroFecha:String = "";
	var codRecibo:String = this.cursor().valueBuffer("codrecibo");
	
	if(!codRecibo || codRecibo == "")
		return;

	if (!util.sqlUpdate("rh_nominas", "codrecibo", "NULL","codrecibo = '" + codRecibo + "'"))
		return false;

	if (this.cursor().valueBuffer("fechanomina") && this.cursor().valueBuffer("fechanomina") != ""){
		filtroFecha = "fechanomina = '" + this.cursor().valueBuffer("fechanomina") + "' AND codrecibo IS NULL";
		this.child("tdbNominas").cursor().setMainFilter(filtroFecha);
	
		var curNominas:FLSqlCursor = new FLSqlCursor("rh_nominas");
		curNominas.select(filtroFecha);
		while (curNominas.next()) {debug("next " + curNominas.valueBuffer("codnomina"));
			curNominas.setModeAccess(curNominas.Edit);
			curNominas.refreshBuffer();
			curNominas.setValueBuffer("codrecibo", codRecibo);
			if (!curNominas.commitBuffer())
				return;
		}
	}
	this.child("tdbNominas").cursor().setMainFilter("codrecibo = '" + this.cursor().valueBuffer("codrecibo") + "'");
	this.child("tdbNominas").refresh();
	this.iface.calcularTotalNominas();
}

function oficial_bufferChanged(fN)
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	switch(fN) {
		case "": { 
			this.child("fdbTotalNominas").setValue(this.iface.calculateField("totalnominas"));
			break;
		}
		case "total": 
		case "totalnominas": { 
			this.child("fdbResto").setValue(this.iface.calculateField("resto"));
			break;
		}
		case "idasiento": {
			this.child("tdbPartidas").refresh();
			break;
		}
	}
}

function oficial_calcularTotalNominas()
{
	this.child("fdbTotalNominas").setValue(this.iface.calculateField("totalnominas"));
}

function oficial_quitarNomina()
{
	var util:FLUtil;
	var codNomina:String = this.child("tdbNominas").cursor().valueBuffer("codnomina");
	if(!codNomina || codNomina == "") {
		MessageBox.information(util.translate("scripts", "No hay ningún registro seleccionado"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	
	var res:Number = MessageBox.information(util.translate("scripts", "La nómina seleccionada será eliminada del recibo actual. ¿Desea continuar?"), MessageBox.Yes, MessageBox.No);
	if (res != MessageBox.Yes)
		return;

	if (!util.sqlUpdate("rh_nominas", "codrecibo", "NULL",  "codnomina = '" + codNomina + "'")) {
		MessageBox.warning(util.translate("scripts", "Hubo un error al eliminar el registro"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	
	this.child("tdbNominas").cursor().setMainFilter("codrecibo = '" + this.cursor().valueBuffer("codrecibo") + "'");

	this.child("tdbNominas").refresh();
	this.iface.calcularTotalNominas();
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
