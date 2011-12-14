/***************************************************************************
                 flcrm_ppal.qs  -  description
                             -------------------
    begin                : mie oct 25 2006
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
	function init() { return this.ctx.interna_init(); }
	function afterCommit_crm_comunicaciones(curCom:FLSqlCursor):Boolean {
		return this.ctx.interna_afterCommit_crm_comunicaciones(curCom);
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    function oficial( context ) { interna( context ); }
	function crearClienteContacto(codCliente:String, codContacto:String):Boolean {
		return this.ctx.oficial_crearClienteContacto(codCliente, codContacto);
	}
	function crearProveedorContacto(codProveedor:String, codContacto:String):Boolean {
		return this.ctx.oficial_crearProveedorContacto(codProveedor, codContacto);
	}
	function crearContactosTarjeta(codContacto:String,codTarjeta:String):Boolean {
		return this.ctx.oficial_crearContactosTarjeta(codContacto,codTarjeta);
	}
	function actualizarContactos20070525():Boolean {
		return this.ctx.oficial_actualizarContactos20070525();
	}
	function crearContacto20070525(codTarjeta:String):String {
		return this.ctx.oficial_crearContacto20070525(codTarjeta);
	}
	function actualizarContactoEnTarjeta20070525(codTarjeta:String,codContacto:String):Boolean {
		return this.ctx.oficial_actualizarContactoEnTarjeta20070525(codTarjeta,codContacto);
	}
	function siguienteSecuencia(tabla:String,nombreCodigo:String,longCampo:Number):String {
		return this.ctx.oficial_siguienteSecuencia(tabla,nombreCodigo,longCampo);
	}
	function mensajeSinEnvioMail() {
		return this.ctx.oficial_mensajeSinEnvioMail();
	}
	function valorConfigPpal(nombreValor:String):String {
		return this.ctx.oficial_valorConfigPpal(nombreValor);
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
	function pub_crearClienteContacto(codCliente:String, codContacto:String):Boolean {
		return this.crearClienteContacto(codCliente, codContacto);
	}
	function pub_crearProveedorContacto(codProveedor:String, codContacto:String):Boolean {
		return this.crearProveedorContacto(codProveedor, codContacto);
	}
	function pub_crearContactosTarjeta(codContacto:String,codTarjeta:String):Boolean {
		return this.ctx.crearContactosTarjeta(codContacto,codTarjeta);
	}
	function pub_actualizarContactos20070525():Boolean {
		return this.actualizarContactos20070525();
	}
	function pub_siguienteSecuencia(tabla:String,nombreCodigo:String,longCampo:Number):String {
		return this.siguienteSecuencia(tabla,nombreCodigo,longCampo);
	}
	function pub_mensajeSinEnvioMail() {
		return this.mensajeSinEnvioMail();
	}
	function pub_valorConfigPpal(nombreValor:String):String {
		return this.valorConfigPpal(nombreValor);
	}
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
	var util:FLUtil;
//-------------------------------- 20070525 -------------------------------------
	if (util.sqlSelect("crm_tarjetas", "codtarjeta", "contacto <> '' AND (codcontacto IS NULL OR codcontacto = '')")) { 
		var cursor:FLSqlCursor = new FLSqlCursor("crm_tarjetas");
		cursor.transaction(false);
		try {
			if (this.iface.actualizarContactos20070525()) {
				cursor.commit();
			} else {
				cursor.rollback();
			}
		}
		catch (e) {
			cursor.rollback();
			MessageBox.warning(util.translate("scripts", "Hubo un error al actualizar los datos de contactos del modulo de CRM:\n" + e), MessageBox.Ok, MessageBox.NoButton);
		}
	}
//-------------------------------- 20070525 -------------------------------------
}

function interna_afterCommit_crm_comunicaciones(curCom:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();

	switch (curCom.modeAccess()) {
		/// Si la comunicación está generada por una campaña, se pregunta al usuario por el estado de la misma y se guarda en el registro de destino de campaña.
		case curCom.Edit: {
			var idDestinoCampana:String = curCom.valueBuffer("iddestinatario");
			if (idDestinoCampana && idDestinoCampana != "") {
				var f:Object = new FLFormSearchDB("crm_estadosdestina");
				f.setMainWidget();
				var codEstado:String = f.exec("codestado");
				if (!codEstado) {
					return fase;
				}
				if (!util.sqlUpdate("crm_destinacampana", "codestado", codEstado, "iddestinatario = " + idDestinoCampana)) {
					return false;
				}
			}
			break;
		}
	}
	return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Crea un registro en crm_clientescontactos
@param	codCliente: Código del cliente
@param	codContacto: Código del contacto
@return	true si el registro se crea correctamente, false en caso contrario
\end */
function oficial_crearClienteContacto(codCliente:String, codContacto:String):Boolean
{
	var util:FLUtil = new FLUtil;

	var curCliCon:FLSqlCursor = new FLSqlCursor("contactosclientes");
	with(curCliCon) {
		setModeAccess(Insert);
		refreshBuffer();
		setValueBuffer("codcliente", codCliente);
		setValueBuffer("codcontacto", codContacto);
		if (!commitBuffer())
			return false;
	}
	return true;
}

/** \D Crea un registro en contactosproveedores
@param	codProveedor: Código del proveedor
@param	codContacto: Código del contacto
@return	true si el registro se crea correctamente, false en caso contrario
\end */
function oficial_crearProveedorContacto(codProveedor:String, codContacto:String):Boolean
{
	var util:FLUtil = new FLUtil;

	var curProvCon:FLSqlCursor = new FLSqlCursor("contactosproveedores");
	with(curProvCon) {
		setModeAccess(Insert);
		refreshBuffer();
		setValueBuffer("codproveedor", codProveedor);
		setValueBuffer("codcontacto", codContacto);
		if (!commitBuffer())
			return false;
	}
	return true;
}

/** \D Crea un registro en crm_contactostarjeta
@param	codContacto: Código del contacto
@param	codTarjeta: Código de la tarjeta
@return	true si el registro se crea correctamente, false en caso contrario
\end */
function oficial_crearContactosTarjeta(codContacto:String,codTarjeta:String):Boolean
{
	var curContactosTarjeta:FLSqlCursor = new FLSqlCursor("crm_contactostarjeta");
	curContactosTarjeta.setModeAccess(curContactosTarjeta.Insert);
	curContactosTarjeta.refreshBuffer();
	curContactosTarjeta.setValueBuffer("codcontacto",codContacto);
	curContactosTarjeta.setValueBuffer("codtarjeta",codTarjeta);
	if (!curContactosTarjeta.commitBuffer())
		return false;

	return true;
}

function oficial_actualizarContactos20070525():Boolean
{

	var util:FLUtil;
	var qryTarjetas:FLSqlQuery = new FLSqlQuery();
	qryTarjetas.setTablesList("crm_tarjetas");
	qryTarjetas.setFrom("crm_tarjetas");
	qryTarjetas.setSelect("codtarjeta,codcontacto,contacto");
	qryTarjetas.setWhere("");
	if (!qryTarjetas.exec())
		return false;

	util.createProgressDialog(util.translate("scripts", "Reorganizando Contactos"), qryTarjetas.size());
	util.setProgress(0);

	var cont:Number = 1;

	while (qryTarjetas.next()) {
		util.setProgress(cont);
		cont += 1;
		var codTarjeta:String = qryTarjetas.value("codtarjeta");
		var codContacto:String = qryTarjetas.value("codcontacto");
		var contacto:String = qryTarjetas.value("contacto");

		if (contacto != "" && (codContacto == "" || !codContacto)) {

			codContacto = this.iface.crearContacto20070525(codTarjeta);
			if (!codContacto) {
				util.destroyProgressDialog();
				return false;
			}
			if (!this.iface.actualizarContactoEnTarjeta20070525(codTarjeta, codContacto)) {
				util.destroyProgressDialog();
				return false;
			}
		}
		if ((codContacto && codContacto != "") && !util.sqlSelect("crm_contactostarjeta", "codcontacto", "codcontacto = '" + codContacto + "'")) {
			if (!this.iface.crearContactosTarjeta(codContacto, codTarjeta)) {
					util.destroyProgressDialog();
					return false;
			}
		}
	}
	util.setProgress(qryTarjetas.size());
	util.destroyProgressDialog();
	return true;
}


function oficial_crearContacto20070525(codTarjeta:String):String
{
	var qryTarjetas:FLSqlQuery = new FLSqlQuery();
	qryTarjetas.setTablesList("crm_tarjetas");
	qryTarjetas.setFrom("crm_tarjetas");
	qryTarjetas.setSelect("contacto,emailcon,telefono1con,codcontacto,cargo,nifcon,direccioncon,ciudadcon,idprovinciacon,provinciacon,codpaiscon,telefono2con,responsable");
	qryTarjetas.setWhere("codtarjeta = '" + codTarjeta + "'");
	if (!qryTarjetas.exec())
		return false;

	if (!qryTarjetas.first())
		return false;

	var util:FLUtil;
	

	var curContactos:FLSqlCursor = new FLSqlCursor("crm_contactos");
	curContactos.setModeAccess(curContactos.Insert);
	curContactos.refreshBuffer();

	with (curContactos) {
		setValueBuffer("codcontacto", util.nextCounter("codcontacto", this));
		setValueBuffer("nombre",qryTarjetas.value("contacto"));
		setValueBuffer("email",qryTarjetas.value("emailcon"));
		setValueBuffer("telefono1",qryTarjetas.value("telefono1con"));
		setValueBuffer("cargo",qryTarjetas.value("cargo"));
		setValueBuffer("nif",qryTarjetas.value("nifcon"));
		setValueBuffer("direccion",qryTarjetas.value("direccioncon"));
		setValueBuffer("ciudad",qryTarjetas.value("ciudadcon"));
		setValueBuffer("codpais",qryTarjetas.value("codpaiscon"));
		setValueBuffer("telefono2",qryTarjetas.value("telefono2con"));
		setValueBuffer("idusuario",qryTarjetas.value("responsable"));
	}

	if (qryTarjetas.value("idprovinciacon") != 0 && qryTarjetas.value("idprovinciacon") != "")
		curContactos.setValueBuffer("idprovincia",qryTarjetas.value("idprovinciacon"));
	
	if (!curContactos.commitBuffer())
		return false;

	return curContactos.valueBuffer("codcontacto");
}


function oficial_actualizarContactoEnTarjeta20070525(codTarjeta:String,codContacto:String):Boolean
{
	var curTarjetas:FLSqlCursor = new FLSqlCursor("crm_tarjetas");
	curTarjetas.select("codtarjeta = '" + codTarjeta + "'");
	if (!curTarjetas.first())
		return false;

	curTarjetas.setModeAccess(curTarjetas.Edit);
	curTarjetas.refreshBuffer();
	curTarjetas.setValueBuffer("codcontacto",codContacto);
	if (!curTarjetas.commitBuffer())
		return false;

	return true;
}

function oficial_siguienteSecuencia(tabla:String,nombreCodigo:String,longCampo:Number):String
{
	var util:FLUtil;
	var valor:Number = util.sqlSelect("crm_secuencias","valor","nombre = '" + tabla + "'");
	var nuevoValor;
	var curSecuencia:FLSqlCursor = new FLSqlCursor("crm_secuencias");
	if (!valor) {
		valor = parseFloat(util.sqlSelect(tabla, "MAX(" + nombreCodigo + ")", "1 = 1"));
		if(!valor || valor == "") 
			valor = 0;

		valor += 1;
		nuevoValor = flfactppal.iface.pub_cerosIzquierda(valor, longCampo);
		with (curSecuencia) {
			setModeAccess(Insert);
			refreshBuffer();
			setValueBuffer("valor", nuevoValor);
			setValueBuffer("nombre", tabla);
			if (!commitBuffer())
				return false;
		}
	
	}
	else {
		curSecuencia.select("nombre = '" + tabla + "'");
		if (!curSecuencia.first())
			return false;
		valor += 1;
		nuevoValor = flfactppal.iface.pub_cerosIzquierda(valor, longCampo);
		curSecuencia.setModeAccess(curSecuencia.Edit);
		curSecuencia.refreshBuffer();
		curSecuencia.setValueBuffer("valor",nuevoValor);
		if (!curSecuencia.commitBuffer())
				return false;	
	}
	return nuevoValor;
}

function oficial_mensajeSinEnvioMail()
{
	var util:FLUtil;
	MessageBox.information(util.translate("scripts", "Esta opción no está disponible. Es necesario tener\n cargada la extensión de envío mail para el módulo de CRM.\nPara más información consulte con InfoSiAL (www.infosial.com)."), MessageBox.Ok, MessageBox.NoButton);
}

function oficial_valorConfigPpal(nombreValor:String):String
{
	var util:FLUtil = new FLUtil;
	var valor:String = util.sqlSelect("crm_configppal", nombreValor, "1 = 1");
	return valor;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
