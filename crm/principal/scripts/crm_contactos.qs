/***************************************************************************
                 crm_contactos.qs  -  description
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var bloqueoProvincia:Boolean;
	var tbnAsociarCliente:Object;
	var tbnQuitarClienteAsociado:Object;
	var toolButtonEdit:Object;
    function oficial( context ) { interna( context ); }
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function asociarCliente() {
		return this.ctx.oficial_asociarCliente();
	}
	function quitarClienteAsociado() {
		return this.ctx.oficial_quitarClienteAsociado();
	}
	function editarCliente() {
		return this.ctx.oficial_editarCliente();
	}
	function enviarEmailContacto() { 
		return this.ctx.oficial_enviarEmailContacto(); 
	}
	function accionesAutomaticas() {
		return this.ctx.oficial_accionesAutomaticas();
	}
	function realizarAccionAutomatica(accion:Array):Boolean {
		return this.ctx.oficial_realizarAccionAutomatica(accion);
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

	var listaCampos:Array = ["codcliente", "codcontacto"];
	this.child("tdbClientes").refresh();
	this.child("tdbClientes").setOrderCols(listaCampos);
	this.iface.tbnAsociarCliente = this.child("tbnAsociarCliente");
	this.iface.tbnQuitarClienteAsociado = this.child("tbnQuitarClienteAsociado");
	this.iface.toolButtonEdit = this.child("toolButtonEdit");

	this.iface.bloqueoProvincia = false;

	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this.iface.tbnAsociarCliente, "clicked()", this, "iface.asociarCliente");
	connect(this.iface.tbnQuitarClienteAsociado, "clicked()", this, "iface.quitarClienteAsociado");
	connect(this.iface.toolButtonEdit, "clicked()", this, "iface.editarCliente");
	connect(this.child("tbnEnviarMail"), "clicked()", this, "iface.enviarEmailContacto()");
	connect(this, "formReady()", this, "iface.accionesAutomaticas");

	switch (cursor.modeAccess()) {
		case cursor.Insert: {
			this.child("fdbIdUsuario").setValue(sys.nameUser());
			this.child("fdbCodEstado").setValue(util.sqlSelect("crm_estadoscontacto", "codestado", "valordefecto = true"));
			break;
		}
	}

	// Tareas
	if (sys.isLoadedModule("flcolaproc")) {
		var datosS:Array;
		datosS["tipoObjeto"] = "crm_contactos";
		datosS["idObjeto"] = cursor.valueBuffer("codcontacto");
		flcolaproc.iface.pub_seguimientoOn(this, datosS);
	} else {
		this.child("tbwContactos").setTabEnabled("tareas", false);
	}


	this.child("tdbClientes").setFilter("codcliente IN (SELECT codcliente FROM contactosclientes WHERE codcontacto = '" + cursor.valueBuffer("codcontacto") + "')");
}

function interna_calculateCounter()
{
	var util:FLUtil = new FLUtil();
	var curContacto:FLSqlCursor = new FLSqlCursor("crm_contactos");
	var valor:String = util.nextCounter("codcontacto", curContacto);
	return valor;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_bufferChanged(fN:String)
{
	var util:FLUtil = new FLUtil();
	switch (fN) {
		case "provincia": {
			if (!this.iface.bloqueoProvincia) {
				this.iface.bloqueoProvincia = true;
				flfactppal.iface.pub_obtenerProvincia(this);
				this.iface.bloqueoProvincia = false;
			}
			break;
		}
	}
}

function oficial_asociarCliente()
{
	var f:Object = new FLFormSearchDB("clientes");
	var curClientes:FLSqlCursor = f.cursor();
	var codCliente:String;
	
	f.setMainWidget();
	curClientes.refreshBuffer();
	f.exec("codcliente");

	if (f.accepted()) {
		curClientes.commitBuffer();
		codCliente = curClientes.valueBuffer("codCliente");
	}

	if(!codCliente || codCliente == ""){debug("return");
		return;}
	
	var curClientesContactos:FLSqlCursor = new FLSqlCursor("contactosclientes");
	curClientesContactos.setModeAccess(curClientesContactos.Insert);
	curClientesContactos.refreshBuffer();
	curClientesContactos.setValueBuffer("codcontacto",this.cursor().valueBuffer("codcontacto"));
	curClientesContactos.setValueBuffer("codcliente",codCliente);
	if (!curClientesContactos.commitBuffer())
		return false;
	this.child("tdbClientes").refresh();
}

function oficial_quitarClienteAsociado()
{
	var util:FLUtil;

	var codContacto:String = this.cursor().valueBuffer("codcontacto");
	if(!codContacto || codContacto == "")
		return;
	var codCliente:String = this.child("tdbClientes").cursor().valueBuffer("codcliente");
debug("Cliente " + codCliente);

	if(!codCliente || codCliente == "" || !util.sqlSelect("contactosclientes","codcliente","codcontacto = '" + codContacto + "' AND codcliente = '" + codCliente + "'")) {
		MessageBox.information(util.translate("scripts", "No hay ningún registro seleccionado."), MessageBox.Ok, MessageBox.NoButton);
		return;
	}

	var res:String = MessageBox.information(util.translate("scripts", "Se eliminará la asociación del cliente seleccionado con el contacto %1 ¿Desea continuar?").arg(codContacto), MessageBox.Yes, MessageBox.No)
	if (res != MessageBox.Yes)
		return;

	util.sqlDelete("contactosclientes","codcontacto = '" + codContacto + "' AND codcliente = '" + codCliente + "'");

	this.child("tdbClientes").refresh();
}

function oficial_editarCliente()
{
	var util:FLUtil;

	var codContacto:String = this.cursor().valueBuffer("codcontacto");
	if(!codContacto || codContacto == "")
		return;
	var codCliente:String = this.child("tdbClientes").cursor().valueBuffer("codcliente");
debug("codCliente " + codCliente);
	if(!codCliente || codCliente == "" || !util.sqlSelect("contactosclientes","codcliente","codcontacto = '" + codContacto + "' AND codcliente = '" + codCliente + "'")) {
		MessageBox.information(util.translate("scripts", "No hay ningún registro seleccionado."), MessageBox.Ok, MessageBox.NoButton);
		return;
	}

	var curCliente:FLSqlCursor = new FLSqlCursor("clientes");
	curCliente.select("codcliente = '" + codCliente + "'");
	curCliente.refreshBuffer();
	curCliente.first();
	curCliente.editRecord();
}

function oficial_enviarEmailContacto()
{
	flcrm_ppal.iface.pub_mensajeSinEnvioMail();
}

function oficial_accionesAutomaticas()
{
	if (!sys.isLoadedModule("flcolaproc")) {
		return;
	}
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var acciones:Array = flcolaproc.iface.pub_accionesAuto();
	if (!acciones) {
		return;
	}
	var i:Number = 0;
	while (i < acciones.length && acciones[i]["usada"]) { i++; }
	if (i == acciones.length) {
		return;
	}

	while (i < acciones.length && acciones[i]["contexto"] == "crm_contactos") {
		if (!this.iface.realizarAccionAutomatica(acciones[i])) {
			break;
		}
		i++;
	}
}

/** \D Realizar una determinada acción.
@return: Se devuelve false si algo falla o si la acción implica que no debe realizarse ninguna acción subsiguiente en el contexto actual.
\end */ 
function oficial_realizarAccionAutomatica(accion:Array):Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	switch (accion["accion"]) {
		case "escoger_pestana": {
			accion["usada"] = true;
			this.child("tbwContactos").showPage(accion["pestana"]);
			break;
		}
		case "editar_comunicacion": {
			accion["usada"] = true;
			var curComunicaciones:FLSqlCursor = this.child("tdbComunicaciones").cursor();
			curComunicaciones.select(accion["filtro"]);
			if (curComunicaciones.first()) {
				curComunicaciones.editRecord();
			} else {
				return false;
			}
			break;
		}
		default: {
			return false;
		}
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
