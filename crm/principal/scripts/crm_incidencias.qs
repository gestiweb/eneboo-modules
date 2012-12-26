/***************************************************************************
                 crm_incidencias.qs  -  description
                             -------------------
    begin                : vie sep 29 2006
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
	function calculateCounter() {
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
	var bloqueoCliProv:Boolean;
	function oficial( context ) { interna( context ); } 
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function habilitarCliProv() {
		return this.ctx.oficial_habilitarCliProv();
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

	this.iface.bloqueoCliProv = false;

	// Tareas
	if (sys.isLoadedModule("flcolaproc")) {
		var datosS:Array;
		datosS["tipoObjeto"] = "crm_incidencias";
		datosS["idObjeto"] = cursor.valueBuffer("codincidencia");
		flcolaproc.iface.pub_seguimientoOn(this, datosS);
	} else {
		this.child("tbwIncidencia").setTabEnabled("tareas", false);
	}
	switch (cursor.modeAccess()) {
		case cursor.Insert: {
			this.child("fdbIdUsuario").setValue(sys.nameUser());
			this.child("fdbCodIncidencia").setValue(this.iface.calculateCounter());
			var curRel:FLSqlCursor = cursor.cursorRelation();
			if (curRel && (curRel.table() == "clientes" || curRel.table() == "proveedores" || curRel.table () == "servicioscli" )) {
				this.child("fdbNomCliente").setValue(curRel.valueBuffer("nombre"));
				this.child("fdbCodCliente").setValue(curRel.valueBuffer("codCliente"));
			}
			break;
		}
	}

	if (!sys.isLoadedModule("flcolaproy")) {
		this.child("gbxProyectos").close();
	}
	
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");

	this.iface.habilitarCliProv();
}

function interna_calculateCounter()
{
	var util:FLUtil = new FLUtil();
// 	return util.nextCounter("codcomunicacion", this.cursor());
	var siguienteCodigo:String = flcrm_ppal.iface.pub_siguienteSecuencia("crm_incidencias","codincidencia", 8);
	return siguienteCodigo
}

function interna_calculateField(fN:String):String
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var valor:String;
	switch (fN) {
		case "nombrecliente": {
			valor = util.sqlSelect("clientes", "nombre", "codcliente = '" + cursor.valueBuffer("codcliente") + "'");
			break;
		}
		case "nombreproveedor": {
			valor = util.sqlSelect("proveedores", "nombre", "codproveedor = '" + cursor.valueBuffer("codproveedor") + "'");
			break;
		}
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
	switch (fN) {
		case "codcliente": {
			if (!this.iface.bloqueoCliProv) {
				this.iface.bloqueoCliProv = true;
				this.child("fdbCodProveedor").setValue("");
				this.iface.habilitarCliProv();
				this.iface.bloqueoCliProv = false;
				this.child("fdbNomCliente").setValue(this.iface.calculateField("nombrecliente"));
			}
			break;
		}
		case "codproveedor": {
			if (!this.iface.bloqueoCliProv) {
				this.iface.bloqueoCliProv = true;
				this.child("fdbCodCliente").setValue("");
				this.iface.habilitarCliProv();
				this.iface.bloqueoCliProv = false;
				this.child("fdbNomCliente").setValue(this.iface.calculateField("nombreproveedor"));
			}
			break;
		}
	}
}

function oficial_habilitarCliProv()
{
	var cursor:FLSqlCursor = this.cursor();
	var codCliente:String = cursor.valueBuffer("codcliente");
	var hayCliente:Boolean = (codCliente && codCliente != "");
	var codProveedor:String = cursor.valueBuffer("codproveedor");
	var hayProveedor:Boolean = (codProveedor && codProveedor != "");

	if (!hayCliente && !hayProveedor) {
		this.child("fdbCodCliente").setDisabled(false);
		this.child("fdbCodProveedor").setDisabled(false);
	} else if (!hayCliente && hayProveedor) {
		this.child("fdbCodCliente").setDisabled(true);
		this.child("fdbCodProveedor").setDisabled(false);
	} else if (hayCliente && !hayProveedor) {
		this.child("fdbCodCliente").setDisabled(false);
		this.child("fdbCodProveedor").setDisabled(true);
	}
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
