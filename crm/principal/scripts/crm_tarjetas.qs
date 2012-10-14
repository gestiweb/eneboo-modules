/***************************************************************************
                 crm_tarjetas.qs  -  description
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
	function calculateCounter() {
		return this.ctx.interna_calculateCounter();
	}
	function calculateField(fN:String):String {
		return this.ctx.interna_calculateField(fN);
	}
	function validateForm():Boolean {
		return this.ctx.interna_validateForm();
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var bloqueoProvinciaCon:Boolean;
	var bloqueoProvincia:Boolean;
	var toolButtonInsertContacto:Object;
	var toolButtonDeleteContacto:Object;
	var toolButtonDeleteContactoTarjeta:Object;
	var toolButtonInsertContactoTarjeta:Object;
	var curContacto_:FLSqlCursor;
	function oficial( context ) { interna( context ); }
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function lanzarEdicionContacto() {
		return this.ctx.oficial_lanzarEdicionContacto();
	}
	function crearContactoTarjeta(codContacto:String, codTarjeta:String):Boolean {
		return this.ctx.oficial_crearContactoTarjeta(codContacto, codTarjeta);
	}
	function insertContacto() {
		return this.ctx.oficial_insertContacto();
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
	function establecerDatosCliProv(tabla:String,where:String) {
		return this.ctx.oficial_establecerDatosCliProv(tabla,where);
	}
	function establecerDatosDirCliProv(tabla:String,where:String) {
		return this.ctx.oficial_establecerDatosDirCliProv(tabla,where);
	}
	function crearContactoTarjeta_clicked() {
		return this.ctx.oficial_crearContactoTarjeta_clicked();
	}
	function asociarContactoTarjeta() {
		return this.ctx.oficial_asociarContactoTarjeta();
	}
	function editarContacto(codContacto:String) {
		return this.ctx.oficial_editarContacto(codContacto);
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
	function enviarEmailContactoPrincipal() { 
		return this.ctx.oficial_enviarEmailContactoPrincipal(); 
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
function interna_calculateCounter()
{
	var util:FLUtil = new FLUtil();
	var siguienteCodigo:String = flcrm_ppal.iface.pub_siguienteSecuencia("crm_tarjetas", "codtarjeta", 6);
	return siguienteCodigo
}

function interna_init()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	this.iface.bloqueoProvincia = false;
	this.iface.bloqueoProvinciaCon = false;

	this.child("tdbContactos").cursor().setMainFilter("codcontacto IN(SELECT codcontacto FROM crm_contactostarjeta WHERE codtarjeta = '" + cursor.valueBuffer("codtarjeta") + "')");
	this.child("tdbContactos").setReadOnly(false);	

	this.iface.toolButtonInsertContacto = this.child("toolButtonInsertContacto");
	this.iface.toolButtonDeleteContacto = this.child("toolButtonDeleteContacto");
	this.iface.toolButtonDeleteContactoTarjeta = this.child("toolButtonDeleteContactoTarjeta");
	this.iface.toolButtonInsertContactoTarjeta = this.child("toolButtonInsertContactoTarjeta");

	
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this.child("tbnContactoPpal"), "clicked()", this, "iface.lanzarEdicionContacto()");
	connect(this.child("toolButtonEditContacto"), "clicked()", this, "iface.editarContacto()");

	connect(this.iface.toolButtonInsertContacto, "clicked()", this, "iface.insertContacto");
	connect(this.iface.toolButtonDeleteContacto, "clicked()", this, "iface.deleteContacto_clicked");
	connect(this.iface.toolButtonDeleteContactoTarjeta, "clicked()", this, "iface.deleteContactoAsociado_clicked");
	connect(this.iface.toolButtonInsertContactoTarjeta, "clicked()", this, "iface.insertContactoAsociado_clicked");
 	connect(this.child("tbnBuscarContacto"), "clicked()", this, "iface.buscarContacto()");

	connect(this.child("tbnEnviarMail"), "clicked()", this, "iface.enviarEmail()");
	connect(this.child("tbnWeb"), "clicked()", this, "iface.accesoWeb()");
	connect(this.child("tbnEnviarMailContacto"), "clicked()", this, "iface.enviarEmailContacto()");
	connect(this.child("tbnEnviarMailContactoPrincipal"), "clicked()", this, "iface.enviarEmailContactoPrincipal()");
	connect(this, "formReady()", this, "iface.accionesAutomaticas");

	var curCT:FLSqlCursor = new FLSqlCursor("crm_contactostarjeta"); /// Fuerza la creación de la tabla antes de aplicar el filtro
	this.child("fdbCodContacto").setFilter("codcontacto IN(SELECT codcontacto FROM crm_contactostarjeta WHERE codtarjeta = '" + this.cursor().valueBuffer("codtarjeta") + "')");

	this.iface.bufferChanged("tipo");
	switch (cursor.modeAccess()) {
		case cursor.Insert: {
			this.child("fdbResponsable").setValue(sys.nameUser());
			this.child("fdbCodEstado").setValue(util.sqlSelect("crm_estadostarjeta", "codestado", "valordefecto = true"));
			this.child("fdbCodFuente").setValue(util.sqlSelect("crm_fuentestarjeta", 	"codfuente", "valordefecto = true"));
			
			break;
		}
	}

	// Tareas
	if (sys.isLoadedModule("flcolaproc")) {
		var datosS:Array;
		datosS["tipoObjeto"] = "crm_tarjetas";
		datosS["idObjeto"] = cursor.valueBuffer("codtarjeta");
		flcolaproc.iface.pub_seguimientoOn(this, datosS);
	} else {
		this.child("tbwTarjeta").setTabEnabled("tareas", false);
	}
}

function interna_validateForm():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var codContacto:String = cursor.valueBuffer("codcontacto");
	if (codContacto && codContacto != "") {
		if (!util.sqlSelect("crm_contactos", "codcontacto", "codcontacto = '" + codContacto + "'")) {
			var res:Number = MessageBox.warning(util.translate("scripts", "El contacto indicado no existe"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	
		var codTarjeta:String = cursor.valueBuffer("codtarjeta");
		if (!util.sqlSelect("crm_contactostarjeta", "codcontacto", "codtarjeta = '" + codTarjeta + "' AND codcontacto = '" + codContacto + "'")) {
			var res:Number = MessageBox.warning(util.translate("scripts", "El contacto por defecto de la tarjeta no está incluido en la lista de contactos. ¿Desea incluirlo ahora?"), MessageBox.Yes, MessageBox.No);
			if (res != MessageBox.Yes) {
				return false;
			}
			if (cursor.modeAccess() == cursor.Insert) {
				if (!this.child("tdbComunicaciones").cursor().commitBufferCursorRelation()) {
					return false;
				}
			}
			if (!this.iface.crearContactoTarjeta(codContacto, codTarjeta)) {
				return false;
			}
		}
	}
	return true;
}

function interna_calculateField(fN:String):String
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var valor:String;

	switch (fN) {
		case "provincia": {
			if(cursor.valueBuffer("tipo") == 0)
				valor = util.sqlSelect("dirclientes", "provincia", "id = " + cursor.valueBuffer("coddir"));
			else
				valor = util.sqlSelect("dirproveedores", "provincia", "id = " + cursor.valueBuffer("coddirp"));
			if (!valor)
				valor = cursor.valueBuffer("provincia");
			break;
		}
		case "codpais": {
			if(cursor.valueBuffer("tipo") == 0)
				valor = util.sqlSelect("dirclientes", "codpais", "id = " + cursor.valueBuffer("coddir"));
			valor = util.sqlSelect("dirproveedores", "codpais", "id = " + cursor.valueBuffer("coddirp"));
			if (!valor)
				valor = cursor.valueBuffer("codpais");
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
		case "provinciacon": {
			if (!this.iface.bloqueoProvinciaCon) {
				this.iface.bloqueoProvinciaCon = true;
				flfactppal.iface.pub_obtenerProvincia(this, "idprovinciacon", "provinciacon", "codpaiscon");
				this.iface.bloqueoProvinciaCon = false;
			}
			break;
		}
		case "coddir": {
			var dirCli:String = this.child("fdbCodDir").value();
			if(!dirCli || !util.sqlSelect("dirclientes","id","id = " + dirCli))
				break;
			else
				this.iface.establecerDatosDirCliProv("dirclientes","id = " + dirCli);
			break;
		}
		case "coddirp": {
			var dirProv:String = this.child("fdbCodDirProv").value();
			if(!dirProv || !util.sqlSelect("dirproveedores","id","id = " + dirProv))
				break;
			else
				this.iface.establecerDatosDirCliProv("dirproveedores","id = " + dirProv);
			break;
		}
		case "tipo": {
			if(this.child("fdbTipo").value() == "0") {
				this.child("fdbCodProveedor").setValue("");
				this.child("fdbCodProveedor").setDisabled(true);
				this.child("fdbCodCliente").setDisabled(false);
	
				this.child("fdbCodDirProv").setValue("");
				this.child("fdbCodDirProv").setDisabled(true);
				this.child("fdbCodDir").setDisabled(false);
			}
			else {
				this.child("fdbCodCliente").setValue("");
				this.child("fdbCodCliente").setDisabled(true);
				this.child("fdbCodProveedor").setDisabled(false);
			
				this.child("fdbCodDir").setValue("");
				this.child("fdbCodDir").setDisabled(true);
				this.child("fdbCodDirProv").setDisabled(false);
			}
			break;
		}
		case "codcliente": {
			var codCliente:String = this.cursor().valueBuffer("codcliente");
			if(codCliente == "" || !codCliente || !util.sqlSelect("clientes","codcliente","codcliente = '" + codCliente + "'"))
				break;
			else
				this.iface.establecerDatosCliProv("clientes","codcliente = '" + codCliente + "'");
			break;
		}
		case "codproveedor": {
			var codProveedor:String = this.cursor().valueBuffer("codproveedor");
			if(codProveedor == "" || !codProveedor || !util.sqlSelect("proveedores","codproveedor","codproveedor = '" + codProveedor + "'"))
				break;
			else
				this.iface.establecerDatosCliProv("proveedores","codproveedor = '" + codProveedor + "'");
			break;
		}
	}
}

function oficial_establecerDatosCliProv(tabla:String,where:String)
{
	var qry:FLSqlQuery = new FLSqlQuery();
	qry.setTablesList(tabla);
	qry.setFrom(tabla);
	qry.setSelect("nombre,cifnif,telefono1,telefono2,fax,email");
	qry.setWhere(where);
	if (!qry.exec())
		return false;
	if(!qry.first())
		return false;

	this.child("fdbNombre").setValue(qry.value("nombre"));
	this.child("fdbCifNif").setValue(qry.value("cifnif"));
	this.child("fdbTelefono1").setValue(qry.value("telefono1"));
	this.child("fdbTelefono2").setValue(qry.value("telefono2"));
	this.child("fdbFax").setValue(qry.value("fax"));
	this.child("fdbEmail").setValue(qry.value("email"));
}

function oficial_establecerDatosDirCliProv(tabla:String,where:String)
{
	var qry:FLSqlQuery = new FLSqlQuery();
	qry.setTablesList(tabla);
	qry.setFrom(tabla);
	qry.setSelect("direccion,ciudad,codpostal");
	qry.setWhere(where);
	if (!qry.exec())
		return false;
	if(!qry.first())
		return false;

	this.child("fdbDireccion").setValue(qry.value("direccion"));
	this.child("fdbCiudad").setValue(qry.value("ciudad"));
	this.child("fdbCodpostal").setValue(qry.value("codpostal"));
	this.child("fdbProvincia").setValue(this.iface.calculateField("provincia"));
	this.child("fdbCodPais").setValue(this.iface.calculateField("codpais"));
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

function oficial_crearContactoTarjeta(codContacto:String, codTarjeta:String):Boolean
{
	var curContactoTarjeta:FLSqlCursor = new FLSqlCursor("crm_contactostarjeta");
	
	curContactoTarjeta.setModeAccess(curContactoTarjeta.Insert);
	curContactoTarjeta.refreshBuffer();
	curContactoTarjeta.setValueBuffer("codcontacto",codContacto);
	curContactoTarjeta.setValueBuffer("codtarjeta",codTarjeta);
	
	if (!curContactoTarjeta.commitBuffer()) {
		return false;
	}
	return true;
}

function oficial_insertContacto()
{
	var cursor:FLSqlCursor = this.cursor();
	if (cursor.modeAccess() == cursor.Insert) {
		if (!this.child("tdbComunicaciones").cursor().commitBufferCursorRelation())
			return false;
	}
	if (this.iface.curContacto_) {
		delete this.iface.curContacto_;
	}
	this.iface.curContacto_ = new FLSqlCursor("crm_contactos");
	
	connect(this.iface.curContacto_, "bufferCommited()", this, "iface.asociarContactoTarjeta");
	this.iface.curContacto_.insertRecord();
}

function oficial_crearContactoTarjeta_clicked()
{
	var cursor:FLSqlCursor = this.cursor();
	this.iface.crearContactoTarjeta(this.iface.curContacto_.valueBuffer("codcontacto"), cursor.valueBuffer("codtarjeta"));
	this.child("tdbContactos").refresh();
}

function oficial_deleteContacto_clicked()
{
	var cursor:FLSqlCursor = this.cursor();
	var codTarjeta:String = cursor.valueBuffer("codtarjeta");

	var codContacto:String = this.child("tdbContactos").cursor().valueBuffer("codcontacto");
	if(!codContacto || codContacto == "") {
		MessageBox.information(util.translate("scripts", "No hay ningún registro seleccionado"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	formRecordclientes.iface.pub_deleteContacto(codContacto, "tarjetas", codTarjeta);
	this.child("tdbContactos").refresh();


// 	var util:FLUtil;
// 	var cursor:FLSqlCursor = this.cursor();
// 	if (cursor.modeAccess() == cursor.Insert) {
// 		if (!this.child("tdbComunicaciones").cursor().commitBufferCursorRelation())
// 			return false;
// 	}
// 	if (!this.iface.curContacto_) {
// 		if (sys.isLoadedModule("flcrm_ppal")) {
// 			this.iface.curContacto_ = new FLSqlCursor("crm_contactos");
// 		} else {
// 			this.iface.curContacto_ = new FLSqlCursor("contactos");
// 		}
// 	}
// 
// 	var codContacto:String = this.child("tdbContactos").cursor().valueBuffer("codcontacto");
// 	if(!codContacto || codContacto == "") {
// 		MessageBox.information(util.translate("scripts", "No hay ningún registro seleccionado"), MessageBox.Ok, MessageBox.NoButton);
// 		return;
// 	}
// 	var res:String = MessageBox.information(util.translate("scripts", "El registro seleccionado será borrado. ¿Está seguro?"), MessageBox.Yes, MessageBox.No);
// 	if (res != MessageBox.Yes)
// 		return;
// 
// 	this.iface.curContacto_.select("codcontacto = '" + codContacto + "'");
// 	if (!this.iface.curContacto_.first())
// 		return false;
// 	this.iface.curContacto_.setModeAccess(this.iface.curContacto_.Del);
// 	this.iface.curContacto_.refreshBuffer();
// 	this.iface.curContacto_.commitBuffer();
// 	this.child("tdbContactos").refresh();
}

function oficial_deleteContactoAsociado_clicked()
{
	var util:FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var codTarjeta:String = cursor.valueBuffer("codtarjeta");
	
	var curContactos:FLSqlCursor = this.child("tdbContactos").cursor();
	var codContacto:String = curContactos.valueBuffer("codcontacto");
	if (!codContacto) {
		MessageBox.warning(util.translate("scripts", "No hay ningún contacto seleccionado"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var res:Number;
	res = MessageBox.information(util.translate("scripts", "Se va a desvincular el contacto seleccionado de la tarjeta. ¿Está seguro?"), MessageBox.Yes, MessageBox.No);
	if (res != MessageBox.Yes) {
		return false;
	}
	if (!util.sqlDelete("crm_contactostarjeta", "codcontacto = '" + codContacto + "' AND codtarjeta = '" + codTarjeta + "'")) {
		return false;
	}
	this.child("tdbContactos").refresh();
}

function oficial_insertContactoAsociado_clicked()
{
	var cursor:FLSqlCursor = this.cursor();
	if (cursor.modeAccess() == cursor.Insert) {
		if (!this.child("tdbOpVenta").cursor().commitBufferCursorRelation()) {
			return false;
		}
	}
	var codTarjeta:String = cursor.valueBuffer("codtarjeta");
	formRecordclientes.iface.pub_insertContactoAsociado("crm_tarjetas", codTarjeta);
	this.child("tdbContactos").refresh();
}

function oficial_editarContacto(codContacto:String)
{
	var cursor:FLSqlCursor = this.cursor();
	if (cursor.modeAccess() == cursor.Insert) {
		if (!this.child("tdbOpVenta").cursor().commitBufferCursorRelation()) {
			return false;
		}
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
	if (!this.iface.curContacto_.first()) {
		return;
	}
	connect(this.iface.curContacto_, "bufferCommited()", this, "iface.asociarContactoTarjeta");
	this.iface.curContacto_.editRecord();
}

function oficial_asociarContactoTarjeta()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var codTarjeta:String = cursor.valueBuffer("codtarjeta");
	var codContacto:String = this.iface.curContacto_.valueBuffer("codcontacto");

	this.iface.crearContactoTarjeta(codContacto, codTarjeta);
	var codContactoTarjeta:String = cursor.valueBuffer("codcontacto");
	if (!codContactoTarjeta || codContactoTarjeta == "") {
		this.child("fdbCodContacto").setValue(codContacto);
	}
	this.child("tdbContactos").refresh();
}

function oficial_buscarContacto()
{
	var util:FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var codTarjeta:String = cursor.valueBuffer("codtarjeta");
	if (!codTarjeta) {
		return;
	}

	f = new FLFormSearchDB("crm_contactos");
	f.setMainWidget();
	f.cursor().setMainFilter("codcontacto IN(SELECT codcontacto FROM crm_contactostarjeta WHERE codtarjeta = '" + codTarjeta + "')");
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

function oficial_enviarEmailContactoPrincipal()
{
	flcrm_ppal.iface.pub_mensajeSinEnvioMail();
}

function oficial_accionesAutomaticas()
{
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

	while (i < acciones.length && acciones[i]["contexto"] == "crm_tarjetas") {
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
			this.child("tbwTarjeta").showPage(accion["pestana"]);
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
