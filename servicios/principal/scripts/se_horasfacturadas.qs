/***************************************************************************
                 se_horasfacturadas.qs  -  description
                             -------------------
    begin                : vie feb 05 2010
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

////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

/** @class_declaration interna */
//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
class interna {
    var ctx:Object;
    function interna( context ) { this.ctx = context; }
    function init() { this.ctx.interna_init(); }
	function calculateField(fN:String):String { return this.ctx.interna_calculateField(fN); }
    function validateForm() { return this.ctx.interna_validateForm(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var precioHora:Number;
	var refHora:String;
	var bloqueoHoras_:Boolean;
	function oficial( context ) { interna( context ); } 
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function guardarHoras():Boolean {
		return this.ctx.oficial_guardarHoras();
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
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	
	this.iface.bloqueoHoras_ = false;
	this.iface.refHora = util.sqlSelect("se_opciones", "se_opciones.refcostehora", "1 = 1");
	this.iface.precioHora = parseFloat(util.sqlSelect("articulos", "pvp", "referencia = '" + this.iface.refHora + "'"));

	if (cursor.modeAccess() == cursor.Insert) {
		this.child("fdbCodEncargado").setValue(sys.nameUser());
		this.child("fdbReferencia").setValue(this.iface.refHora);
	}

	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
}

function interna_calculateField(fN:String):String
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var valor:String;

	switch(fN) {
		case "precio": {
			valor = this.iface.precioHora * parseFloat(cursor.valueBuffer("horas"));
			if (!valor || isNaN(valor)) {
				valor = 0;
			}
			break;
		}
		case "precioref": {
			valor = util.sqlSelect("articulos", "pvp", "referencia = '" + cursor.valueBuffer("referencia") + "'")
			if (!valor || isNaN(valor)) {
				valor = 0;
			}
			break;
		}
	}
	return valor;
}

/** \C
La --fechaapertura-- no puede ser posterior a la --fechacierre--
\end */
function interna_validateForm()
{
	if (!this.iface.guardarHoras()) {
		return false;
	}

	return true;
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
		case "horas": {
			if (cursor.valueBuffer("referencia") == this.iface.refHora) {
				this.child("fdbPrecio").setValue(this.iface.calculateField("precio"));
			}
			break;
		}
		case "referencia": {
			if (cursor.valueBuffer("referencia") != this.iface.refHora) {
				this.child("fdbPrecio").setValue(this.iface.calculateField("precioref"));
				this.child("fdbHoras").setValue(0);
			}
			break;
		}
	}
}

function oficial_guardarHoras():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	var codIncidencia:String = cursor.valueBuffer("codincidencia");
	var idUsuario:String = sys.nameUser();
	var horasHoy:Number = util.sqlSelect("se_horastrabajadas", "SUM(horas)", "fecha = '" + cursor.valueBuffer("fecha") + "' AND codusuario = '" + idUsuario + "'");
	horasHoy = (isNaN(horasHoy) ? 0 : horasHoy);
	var horasEsto:Number = util.sqlSelect("se_horastrabajadas", "SUM(horas)", "fecha = '" + cursor.valueBuffer("fecha") + "' AND codusuario = '" + idUsuario + "' AND codincidencia = '" + codIncidencia + "'");
	horasEsto = (isNaN(horasEsto) ? 0 : horasEsto);
	var horasApuntar:Number = Input.getNumber(util.translate("scripts", "Horas a apuntar (%1 hoy, %2 en esto)").arg(horasHoy).arg(horasEsto), cursor.valueBuffer("horas"), 2);
	var curIncidencia:FLSqlCursor = cursor.cursorRelation();
	if (horasApuntar && horasApuntar > 0) {
		var curHoras:FLSqlCursor = new FLSqlCursor("se_horastrabajadas");
		curHoras.setModeAccess(curHoras.Insert);
		curHoras.refreshBuffer();
		curHoras.setValueBuffer("fecha", cursor.valueBuffer("fecha"));
		curHoras.setValueBuffer("codcliente", curIncidencia.valueBuffer("codcliente"));
		curHoras.setValueBuffer("codproyecto", curIncidencia.valueBuffer("codproyecto"));
		curHoras.setValueBuffer("codsubproyecto", curIncidencia.valueBuffer("codsubproyecto"));
		curHoras.setValueBuffer("codincidencia", codIncidencia);
		curHoras.setValueBuffer("codusuario", idUsuario);
		curHoras.setValueBuffer("horas", horasApuntar);
		curHoras.setValueBuffer("descripcion", curIncidencia.valueBuffer("desccorta"));
		if (!curHoras.commitBuffer()) {
			return false;
		}
// 		MessageBox.information(util.translate("scripts", "Apuntadas %1 horas.").arg(horasApuntar), MessageBox.Ok, MessageBox.NoButton);
	}
	return true;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
