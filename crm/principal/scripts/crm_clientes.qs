/***************************************************************************
                 crm_clientes.qs  -  description
                             -------------------
    begin                : jue sep 28 2006
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    function oficial( context ) { interna( context ); }
	var toolButtonInsertContacto:Object;
	var toolButtonDeleteContacto:Object;
	var toolButtonDeleteContactoCliente:Object;
	var toolButtonInsertContactoCliente:Object;
	var curContacto_:FLSqlCursor;
	function insertContacto() {
		return this.ctx.oficial_insertContacto();
	}
	function editarContacto(codContacto:String) {
		return this.ctx.oficial_editarContacto(codContacto);
	}
	function deleteContacto_clicked() {
		return this.ctx.oficial_deleteContacto_clicked();
	}
	function deleteContactoAsociado_clicked() {
		return this.ctx.oficial_deleteContactoAsociado_clicked();
	}
	function insertContactoAsociado_clicked() {
		return this.ctx.oficial_insertContactoAsociado_clicked();
	}
	function lanzarEdicionContacto() {
		return this.ctx.oficial_lanzarEdicionContacto();
	}
	function asociarContactoCliente() {
		return this.ctx.oficial_asociarContactoCliente();
	}
	function buscarContacto() {
		return this.ctx.oficial_buscarContacto();
	}
	function enviarEmail() { 
		return this.ctx.oficial_enviarEmail(); 
	}
	function accesoWeb():Boolean { 
		return this.ctx.oficial_accesoWeb(); 
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

	// Tareas
	if (sys.isLoadedModule("flcolaproc")) {
		var datosS:Array;
		datosS["tipoObjeto"] = "clientes";
		datosS["idObjeto"] = cursor.valueBuffer("codcliente");
		flcolaproc.iface.pub_seguimientoOn(this, datosS);
	} else {
		this.child("tbwCliente").setTabEnabled("tareas", false);
	}

	this.child("fdbCodContacto").setFilter("codcontacto IN(SELECT codcontacto FROM contactosclientes WHERE codcliente = '" + cursor.valueBuffer("codcliente") + "')");

	this.child("tdbContactos").cursor().setMainFilter("codcontacto IN(SELECT codcontacto FROM contactosclientes WHERE codcliente = '" + cursor.valueBuffer("codcliente") + "')");
	this.child("tdbContactos").setReadOnly(false);	

	this.iface.toolButtonInsertContacto = this.child("toolButtonInsertContacto");
	this.iface.toolButtonDeleteContacto = this.child("toolButtonDeleteContacto");
	this.iface.toolButtonDeleteContactoCliente = this.child("toolButtonDeleteContactoCliente");
	this.iface.toolButtonInsertContactoCliente = this.child("toolButtonInsertContactoCliente");

	connect(this.iface.toolButtonInsertContacto, "clicked()", this, "iface.insertContacto");
	connect(this.iface.toolButtonDeleteContacto, "clicked()", this, "iface.deleteContacto_clicked");
	connect(this.iface.toolButtonDeleteContactoCliente, "clicked()", this, "iface.deleteContactoAsociado_clicked");
	connect(this.child("toolButtonEditContacto"), "clicked()", this, "iface.editarContacto");
	connect(this.iface.toolButtonInsertContactoCliente, "clicked()", this, "iface.insertContactoAsociado_clicked");
	connect(this.child("tbnContactoPPal"), "clicked()", this, "iface.lanzarEdicionContacto()");
	connect(this.child("tbnBuscarContacto"), "clicked()", this, "iface.buscarContacto()");
	connect(this.child("tbnEnviarMail"), "clicked()", this, "iface.enviarEmail()");
	connect(this.child("tbnWeb"), "clicked()", this, "iface.accesoWeb()");
	connect(this.child("tbnEnviarMailContacto"), "clicked()", this, "iface.enviarEmailContacto()");
	connect(this, "formReady()", this, "iface.accionesAutomaticas");

	if (!sys.isLoadedModule("flcolaproy")) {
		this.child("tbwCliente").setTabEnabled("proyectos", false);
	}
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_insertContacto()
{
	var cursor:FLSqlCursor = this.cursor();
	if (cursor.modeAccess() == cursor.Insert) {
		if (!this.child("tdbDirecciones").cursor().commitBufferCursorRelation())
			return false;
	}
	if (this.iface.curContacto_) {
		delete this.iface.curContacto_;
	}
	this.iface.curContacto_ = new FLSqlCursor("crm_contactos");
	
	connect(this.iface.curContacto_, "bufferCommited()", this, "iface.asociarContactoCliente");
	this.iface.curContacto_.insertRecord();
}

function oficial_asociarContactoCliente()
{
	var cursor:FLSqlCursor = this.cursor();
	var codCliente:String = cursor.valueBuffer("codcliente");

	var curContactoCliente:FLSqlCursor = new FLSqlCursor("contactosclientes");
	curContactoCliente.setModeAccess(curContactoCliente.Insert);
	curContactoCliente.refreshBuffer();
	curContactoCliente.setValueBuffer("codcontacto", this.iface.curContacto_.valueBuffer("codcontacto"));
	curContactoCliente.setValueBuffer("codcliente", codCliente);
	
	if (!curContactoCliente.commitBuffer()) {
		return false;
	}
	this.child("tdbContactos").refresh();
}

function oficial_deleteContacto_clicked()
{
	var cursor:FLSqlCursor = this.cursor();
	var codCliente:String = cursor.valueBuffer("codcliente");

	var codContacto:String = this.child("tdbContactos").cursor().valueBuffer("codcontacto");
	if(!codContacto || codContacto == "") {
		MessageBox.information(util.translate("scripts", "No hay ningún registro seleccionado"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	formRecordclientes.iface.pub_deleteContacto(codContacto, "clientes", codCliente);
	this.child("tdbContactos").refresh();
}

function oficial_deleteContactoAsociado_clicked()
{
	var util:FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var codCliente:String = cursor.valueBuffer("codcliente");
	
// 	if (accion == "crm_tarjetas")
// 		f = new FLFormSearchDB("crm_editcontactotarjeta");
// 	else {

	var curContactos:FLSqlCursor = this.child("tdbContactos").cursor();
	var codContacto:String = curContactos.valueBuffer("codcontacto");
	if (!codContacto) {
		MessageBox.warning(util.translate("scripts", "No hay ningún contacto seleccionado"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var res:Number;
// 	if (accion == "crm_tarjetas")
// 		res = MessageBox.information(util.translate("scripts", "Se va a desvincular el contacto seleccionado de la tarjeta. ¿Está seguro?"), MessageBox.Yes, MessageBox.No);
// 	else
	res = MessageBox.information(util.translate("scripts", "Se va a desvincular el contacto seleccionado del cliente. ¿Está seguro?"), MessageBox.Yes, MessageBox.No);
	if (res != MessageBox.Yes) {
		return false;
	}
	if (!util.sqlDelete("contactosclientes", "codcontacto = '" + codContacto + "' AND codcliente = '" + codCliente + "'")) {
		return false;
	}
	this.child("tdbContactos").refresh();
}

function oficial_insertContactoAsociado_clicked()
{
	var cursor:FLSqlCursor = this.cursor();
	if (cursor.modeAccess() == cursor.Insert) {
		if (!this.child("tdbDirecciones").cursor().commitBufferCursorRelation()) {
			return false;
		}
	}
	var codCliente:String = cursor.valueBuffer("codcliente");
	formRecordclientes.iface.pub_insertContactoAsociado("clientes", codCliente);
	this.child("tdbContactos").refresh();
}

function oficial_lanzarEdicionContacto()
{
	var util:FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var codContacto:String = cursor.valueBuffer("codcontacto");
	if (!codContacto || codContacto == "") {
		this.iface.insertContacto();
	} else {
		this.iface.editarContacto(codContacto);
	}
}

function oficial_asociarContactoCliente()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var codCliente:String = cursor.valueBuffer("codcliente");
	var codContacto:String = this.iface.curContacto_.valueBuffer("codcontacto");
	if (!util.sqlSelect("contactosclientes", "id", "codcontacto = '" + codContacto + "' AND codcliente = '" + codCliente + "'")) {
		var curContactoCliente:FLSqlCursor = new FLSqlCursor("contactosclientes");
		curContactoCliente.setModeAccess(curContactoCliente.Insert);
		curContactoCliente.refreshBuffer();
		curContactoCliente.setValueBuffer("codcontacto", codContacto);
		curContactoCliente.setValueBuffer("codcliente", codCliente);
		
		if (!curContactoCliente.commitBuffer()) {
			return false;
		}
	}
	var codContactoCliente = cursor.valueBuffer("codcontacto");
	if (!codContactoCliente || codContactoCliente == "") {
		this.child("fdbCodContacto").setValue(codContacto);
	}
	this.child("tdbContactos").refresh();
}

function oficial_editarContacto(codContacto:String)
{
	var cursor:FLSqlCursor = this.cursor();
	if (cursor.modeAccess() == cursor.Insert) {
		if (!this.child("tdbDirecciones").cursor().commitBufferCursorRelation())
			return false;
	}

	if (this.iface.curContacto_) {
		delete this.iface.curContacto_;
	}
	this.iface.curContacto_ = new FLSqlCursor("crm_contactos");

	if (!codContacto) {
		codContacto = this.child("tdbContactos").cursor().valueBuffer("codcontacto");
		if (!codContacto || codContacto == "") {
			MessageBox.information(util.translate("scripts", "No hay ningún registro seleccionado"), MessageBox.Ok, MessageBox.NoButton);
			return;
		}
	}
	this.iface.curContacto_.select("codcontacto = '" + codContacto + "'");
	if (!this.iface.curContacto_.first())
		return;

	disconnect(this.iface.curContacto_, "bufferCommited()", this, "iface.asociarContactoCliente");
	this.iface.curContacto_.editRecord();
}

function oficial_buscarContacto()
{
	var util:FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var codCliente:String = cursor.valueBuffer("codcliente");
	if (!codCliente) {
		return;
	}

	f = new FLFormSearchDB("crm_contactos");
	f.setMainWidget();
	f.cursor().setMainFilter("codcontacto IN(SELECT codcontacto FROM contactosclientes WHERE codcliente = '" + codCliente + "')");
	var codContacto:String = f.exec("codcontacto");
	if (!codContacto) {
		return;
	}
	this.child("fdbCodContacto").setValue(codContacto);
}

function oficial_enviarEmail() 
{
	flcrm_ppal.iface.pub_mensajeSinEnvioMail();
}

function oficial_accesoWeb():Boolean
{
	flcrm_ppal.iface.pub_mensajeSinEnvioMail();
}

function oficial_enviarEmailContacto()
{
	flcrm_ppal.iface.pub_mensajeSinEnvioMail();
}

function oficial_accionesAutomaticas()
{
debug("oficial_accionesAutomaticas");
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	if (!sys.isLoadedModule("flcolaproc"))
		return;
	var acciones:Array = flcolaproc.iface.pub_accionesAuto();
	if (!acciones) {
		return;
	}
	var i:Number = 0;
	while (i < acciones.length && acciones[i]["usada"]) { i++; }
	if (i == acciones.length) {
		return;
	}

	while (i < acciones.length && acciones[i]["contexto"] == "crm_clientes") {
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
			this.child("tbwCliente").showPage(accion["pestana"]);
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
