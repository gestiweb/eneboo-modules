/***************************************************************************
                 crm_mastertarjetas.qs  -  description
                             -------------------
    begin                : mar oct 24 2006
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
	var pbnGCliente:Object;
	var pbnGProveedor:Object;
	var pbnGOportunidad:Object;
	var tdbRecords:FLTableDB;
	var curCliente:FLSqlCursor;
	var curDirCliente:FLSqlCursor;
	var curProveedor:FLSqlCursor;
	var curDirProveedor:FLSqlCursor;
	var curContacto:FLSqlCursor;
	var curOportunidad:FLSqlCursor;

    function oficial( context ) { interna( context ); }
	function pbnGenerarClienteClicked() {
		return this.ctx.oficial_pbnGenerarClienteClicked();
	}
	function pbnGenerarProveedorClicked() {
		return this.ctx.oficial_pbnGenerarProveedorClicked();
	}
	function pbnGenerarOportunidadClicked() {
		return this.ctx.oficial_pbnGenerarOportunidadClicked();
	}
	function generarCliente(cursor:FLSqlCursor):String {
		return this.ctx.oficial_generarCliente(cursor);
	}
	function generarProveedor(cursor:FLSqlCursor):String {
		return this.ctx.oficial_generarProveedor(cursor);
	}
	function generarOportunidad(curTarjeta:FLSqlCursor):String {
		return this.ctx.oficial_generarOportunidad(curTarjeta);
	}
	function procesarEstado() {
		return this.ctx.oficial_procesarEstado();
	}
	function datosCliente(curTarjeta:FLSqlCursor):Boolean {
		return this.ctx.oficial_datosCliente(curTarjeta);
	}
	function datosDirCliente(curTarjeta:FLSqlCursor, codCliente:String):Boolean {
		return this.ctx.oficial_datosDirCliente(curTarjeta, codCliente);
	}
	function datosProveedor(curTarjeta:FLSqlCursor):Boolean {
		return this.ctx.oficial_datosProveedor(curTarjeta);
	}
	function datosDirProveedor(curTarjeta:FLSqlCursor, codProveedor:String):Boolean {
		return this.ctx.oficial_datosDirProveedor(curTarjeta, codProveedor);
	}
	function datosOportunidad(curTarjeta:FLSqlCursor):Boolean {
		return this.ctx.oficial_datosOportunidad(curTarjeta);
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
	this.iface.pbnGCliente = this.child("pbnGCliente");
	this.iface.pbnGProveedor = this.child("pbnGProveedor");
	this.iface.pbnGOportunidad = this.child("pbnGOportunidad");
	this.iface.tdbRecords = this.child("tableDBRecords");
	
	connect(this.iface.pbnGCliente, "clicked()", this, "iface.pbnGenerarClienteClicked()");
	connect(this.iface.pbnGProveedor, "clicked()", this, "iface.pbnGenerarProveedorClicked()");
	connect(this.iface.pbnGOportunidad, "clicked()", this, "iface.pbnGenerarOportunidadClicked()");
	connect(this.iface.tdbRecords, "currentChanged()", this, "iface.procesarEstado");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Controla la habilitación de los botones de generación de cliente y contacto en función de si la tarjeta seleccionada ya está asociada o no a un cliente y contacto existente
\end */
function oficial_procesarEstado()
{
	var cursor:FLSqlCursor = this.cursor();

	var codigo:String = ""
	if(cursor.valueBuffer("tipo") == "Cliente")
		codigo = cursor.valueBuffer("codcliente");
	else
		codigo = cursor.valueBuffer("codproveedor");

	var nombre:String = cursor.valueBuffer("nombre");

	if ((codigo && codigo != "") || (!nombre || nombre == "")) {
		this.iface.pbnGCliente.enabled = false;
		this.iface.pbnGProveedor.enabled = false;
	}
	else {
		if(cursor.valueBuffer("tipo") == "Cliente") {
			this.iface.pbnGCliente.enabled = true;
			this.iface.pbnGProveedor.enabled = false;
		}
		else {
			this.iface.pbnGCliente.enabled = false;
			this.iface.pbnGProveedor.enabled = true;
		}
	}

// 	var codContacto:String = cursor.valueBuffer("codcontacto");
// 	if (codContacto && codContacto != "")
// 		this.iface.pbnGContacto.enabled = false;
// 	else
// 		this.iface.pbnGContacto.enabled = true;
}

/** \C
Al pulsar el botón de generar cliente se creará el cliente correspondiente a la tarjeta seleccionada.
\end */
function oficial_pbnGenerarClienteClicked()
{
	var util:FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var codCliente:String = cursor.valueBuffer("codcliente");
	if (codCliente && codCliente != "") {
		MessageBox.warning(util.translate("scripts", "Ya se ha generado un cliente para la tarjeta seleccionada"), MessageBox.Ok, MessageBox.NoButton);
		this.iface.procesarEstado();
		return;
	}

	var util:FLUtil = new FLUtil;

	this.iface.pbnGCliente.setEnabled(false);

	cursor.transaction(false);
	
	try {
		codCliente = this.iface.generarCliente(cursor)
		if (codCliente) {
			cursor.commit();
			MessageBox.warning(util.translate("scripts", "Se ha creado el cliente %1 - %2 en la tabla de clientes").arg(codCliente).arg(cursor.valueBuffer("nombre")), MessageBox.Ok, MessageBox.NoButton);
		} else
			cursor.rollback();
	}
	catch (e) {
		cursor.rollback();
		MessageBox.critical(util.translate("scripts", "Hubo un error en la generación del cliente:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
	}

	this.iface.tdbRecords.refresh();
	this.iface.procesarEstado();
}

/** \C
Al pulsar el botón de generar proveedor se creará el proveedor correspondiente a la tarjeta seleccionada.
\end */
function oficial_pbnGenerarProveedorClicked()
{
	var util:FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var codProveedor:String = cursor.valueBuffer("codproveedor");
	if (codProveedor && codProveedor != "") {
		MessageBox.warning(util.translate("scripts", "Ya se ha generado un proveedor para la tarjeta seleccionada"), MessageBox.Ok, MessageBox.NoButton);
		this.iface.procesarEstado();
		return;
	}

	var util:FLUtil = new FLUtil;

	this.iface.pbnGProveedor.setEnabled(false);

	cursor.transaction(false);
	
	try {
		codProveedor = this.iface.generarProveedor(cursor)
		if (codProveedor) {
			cursor.commit();
			MessageBox.warning(util.translate("scripts", "Se ha creado el proveedor %1 - %2 en la tabla de proveedores").arg(codProveedor).arg(cursor.valueBuffer("nombre")), MessageBox.Ok, MessageBox.NoButton);
		} else
			cursor.rollback();
	}
	catch (e) {
		cursor.rollback();
		MessageBox.critical(util.translate("scripts", "Hubo un error en la generación del proveedor:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
	}

	this.iface.tdbRecords.refresh();
	this.iface.procesarEstado();
}

/** \D 
Genera el cliente asociado a una tarjeta
@param curTarjeta: Cursor con los datos principales que se copiarán de la tarjeta al cliente
@return Identificador del cliente generado. FALSE si hay error
\end */
function oficial_generarCliente(curTarjeta:FLSqlCursor):String
{
	var util:FLUtil;

	if (!this.iface.curCliente)
		this.iface.curCliente = new FLSqlCursor("clientes");
	
	this.iface.curCliente.setModeAccess(this.iface.curCliente.Insert);
	this.iface.curCliente.refreshBuffer();
	
	if (!this.iface.datosCliente(curTarjeta))
		return false;
	
	if (!this.iface.curCliente.commitBuffer()) {
		return false;
	}
	var codCliente:String = this.iface.curCliente.valueBuffer("codcliente");
	
	// Direcciones de cliente
	if (!this.iface.curDirCliente)
		this.iface.curDirCliente = new FLSqlCursor("dirclientes");
	
	this.iface.curDirCliente.setModeAccess(this.iface.curDirCliente.Insert);
	this.iface.curDirCliente.refreshBuffer();
	
	if (!this.iface.datosDirCliente(curTarjeta, codCliente))
		return false;
	
	if (!this.iface.curDirCliente.commitBuffer()) {
		return false;
	}

	with(curTarjeta) {
		setModeAccess(Edit);
		refreshBuffer();
		setValueBuffer("codcliente", codCliente);
		if (!commitBuffer())
			return false;
	}

	var codContacto:String = curTarjeta.valueBuffer("codcontacto");
	if (codContacto && codContacto != "") {
		if (!flcrm_ppal.iface.pub_crearClienteContacto(codCliente, codContacto))
			return false;
	}
	
	// Contactos de cliente
	
	var qryContactosTarjeta:FLSqlQuery = new FLSqlQuery();
	qryContactosTarjeta.setTablesList("crm_contactostarjeta");
	qryContactosTarjeta.setFrom("crm_contactostarjeta");
	qryContactosTarjeta.setSelect("codcontacto");
	qryContactosTarjeta.setWhere("codtarjeta = '" + curTarjeta.valueBuffer("codtarjeta") + "'");
	qryContactosTarjeta.setForwardOnly(true);
	if (!qryContactosTarjeta.exec())
		return false;
	
	while(qryContactosTarjeta.next()) {
		if (!flcrm_ppal.iface.pub_crearClienteContacto(codCliente,  qryContactosTarjeta.value("codcontacto")))
			return false;
	}

	if(!util.sqlUpdate("crm_comunicaciones","codcliente",codCliente,"codtarjeta = '" + curTarjeta.valueBuffer("codtarjeta") + "'"))
		return false;

	if(!util.sqlUpdate("crm_oportunidadventa","codcliente",codCliente,"codtarjeta = '" + curTarjeta.valueBuffer("codtarjeta") + "'"))
		return false;

	return codCliente;
}

/** \D Informa los datos de un cliente a partir de los de una tarjeta
@param	curTarjeta: Cursor que contiene los datos a incluir en el cliente
@return	True si la copia de datos se realiza correctamente, false en caso contrario
\end */
function oficial_datosCliente(curTarjeta:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	var longSubcuenta:Number;

	with (this.iface.curCliente) {
		setValueBuffer("codcliente", util.nextCounter("codcliente", this));
		setValueBuffer("nombre", curTarjeta.valueBuffer("nombre"));
		setValueBuffer("cifnif", curTarjeta.valueBuffer("cifnif"));
		setValueBuffer("telefono1", curTarjeta.valueBuffer("telefono1"));
		setValueBuffer("codcontacto", curTarjeta.valueBuffer("codcontacto"));
		setValueBuffer("codpago", flfactppal.iface.pub_valorDefectoEmpresa("codpago"));
		setValueBuffer("coddivisa", flfactppal.iface.pub_valorDefectoEmpresa("coddivisa"));
		setValueBuffer("codserie", flfactppal.iface.pub_valorDefectoEmpresa("codserie"));
		setValueBuffer("telefono2", curTarjeta.valueBuffer("telefono2"));
		setValueBuffer("email", curTarjeta.valueBuffer("email"));
		setValueBuffer("fax", curTarjeta.valueBuffer("fax"));
		setValueBuffer("web", curTarjeta.valueBuffer("web"));
		if (sys.isLoadedModule("flcontppal")) {
			longSubcuenta = util.sqlSelect("ejercicios", "longsubcuenta", "codejercicio = '" + flfactppal.iface.pub_ejercicioActual() + "'");
			setValueBuffer("codsubcuenta", formRecordclientes.iface.pub_calcularSubcuentaCli(this, longSubcuenta));
		}
	}
	
	return true;
}

/** \D Informa los datos de una dirección de cliente a partir de los de una tarjeta
@param	curTarjeta: Cursor que contiene los datos a incluir en la dirección del cliente
@param	codCliente: Código del cliente al que se asociará la dirección
@return	True si la copia de datos se realiza correctamente, false en caso contrario
\end */
function oficial_datosDirCliente(curTarjeta:FLSqlCursor, codCliente:String):Boolean
{
	var util:FLUtil = new FLUtil();
	
	with (this.iface.curDirCliente) {
		setValueBuffer("descripcion", util.translate("scripts", "Dirección principal"));
		setValueBuffer("domfacturacion", true);
		setValueBuffer("domenvio", true);
		setValueBuffer("direccion", curTarjeta.valueBuffer("direccion"));
		setValueBuffer("ciudad", curTarjeta.valueBuffer("ciudad"));
		setValueBuffer("provincia", curTarjeta.valueBuffer("provincia"));
		setValueBuffer("codpais", curTarjeta.valueBuffer("codpais"));
		setValueBuffer("codcliente", codCliente);
		setValueBuffer("codpostal", curTarjeta.valueBuffer("codpostal"));
	}
	
	return true;
}


/** \D 
Genera el proveedor asociado a una tarjeta
@param curTarjeta: Cursor con los datos principales que se copiarán de la tarjeta al proveedor
@return Identificador del proveedor generado. FALSE si hay error
\end */
function oficial_generarProveedor(curTarjeta:FLSqlCursor):String
{
	if (!this.iface.curProveedor)
		this.iface.curProveedor = new FLSqlCursor("proveedores");
	
	this.iface.curProveedor.setModeAccess(this.iface.curProveedor.Insert);
	this.iface.curProveedor.refreshBuffer();
	
	if (!this.iface.datosProveedor(curTarjeta))
		return false;
	
	if (!this.iface.curProveedor.commitBuffer()) {
		return false;
	}
	var codProveedor:String = this.iface.curProveedor.valueBuffer("codproveedor");
	
	// Direcciones de proveedor
	if (!this.iface.curDirProveedor)
		this.iface.curDirProveedor = new FLSqlCursor("dirproveedores");
	
	this.iface.curDirProveedor.setModeAccess(this.iface.curDirProveedor.Insert);
	this.iface.curDirProveedor.refreshBuffer();
	
	if (!this.iface.datosDirProveedor(curTarjeta, codProveedor))
		return false;
	
	if (!this.iface.curDirProveedor.commitBuffer()) {
		return false;
	}

	with(curTarjeta) {
		setModeAccess(Edit);
		refreshBuffer();
		setValueBuffer("codproveedor", codProveedor);
		if (!commitBuffer())
			return false;
	}

	var codContacto:String = curTarjeta.valueBuffer("codcontacto");
	if (codContacto && codContacto != "") {
		if (!flcrm_ppal.iface.pub_crearProveedorContacto(codProveedor, codContacto))
			return false;
	}
	

	// Contactos de proveedor
	
	var qryContactosTarjeta:FLSqlQuery = new FLSqlQuery();
	qryContactosTarjeta.setTablesList("crm_contactostarjeta");
	qryContactosTarjeta.setFrom("crm_contactostarjeta");
	qryContactosTarjeta.setSelect("codcontacto");
	qryContactosTarjeta.setWhere("codtarjeta = '" + curTarjeta.valueBuffer("codtarjeta") + "'");
	qryContactosTarjeta.setForwardOnly(true);
	if (!qryContactosTarjeta.exec())
		return false;
	
	while(qryContactosTarjeta.next()) {
		if (!flcrm_ppal.iface.pub_crearProveedorContacto(codProveedor,  qryContactosTarjeta.value("codcontacto")))
			return false;
	}
	return codProveedor;
}

/** \D Informa los datos de un proveedor a partir de los de una tarjeta
@param	curTarjeta: Cursor que contiene los datos a incluir en el proveedor
@return	True si la copia de datos se realiza correctamente, false en caso contrario
\end */
function oficial_datosProveedor(curTarjeta:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	var longSubcuenta:Number;

	with (this.iface.curProveedor) {
		setValueBuffer("codproveedor", util.nextCounter("codproveedor", this));
		setValueBuffer("nombre", curTarjeta.valueBuffer("nombre"));
		setValueBuffer("cifnif", curTarjeta.valueBuffer("cifnif"));
		setValueBuffer("telefono1", curTarjeta.valueBuffer("telefono1"));
		setValueBuffer("codcontacto", curTarjeta.valueBuffer("codcontacto"));
		setValueBuffer("codpago", flfactppal.iface.pub_valorDefectoEmpresa("codpago"));
		setValueBuffer("coddivisa", flfactppal.iface.pub_valorDefectoEmpresa("coddivisa"));
		setValueBuffer("codserie", flfactppal.iface.pub_valorDefectoEmpresa("codserie"));
		setValueBuffer("telefono2", curTarjeta.valueBuffer("telefono2"));
		setValueBuffer("email", curTarjeta.valueBuffer("email"));
		setValueBuffer("fax", curTarjeta.valueBuffer("fax"));
		setValueBuffer("web", curTarjeta.valueBuffer("web"));
		if (sys.isLoadedModule("flcontppal")) {
			longSubcuenta = util.sqlSelect("ejercicios", "longsubcuenta", "codejercicio = '" + flfactppal.iface.pub_ejercicioActual() + "'");
			setValueBuffer("codsubcuenta", formRecordproveedores.iface.pub_calcularSubcuentaPro(this, longSubcuenta));
		}
	}
	
	return true;
}

/** \D Informa los datos de una dirección de proveedor a partir de los de una tarjeta
@param	curTarjeta: Cursor que contiene los datos a incluir en la dirección del proveedor
@param	codProveedor: Código del proveedor al que se asociará la dirección
@return	True si la copia de datos se realiza correctamente, false en caso contrario
\end */
function oficial_datosDirProveedor(curTarjeta:FLSqlCursor, codProveedor:String):Boolean
{
	var util:FLUtil = new FLUtil();
	
	with (this.iface.curDirProveedor) {
		setValueBuffer("descripcion", util.translate("scripts", "Dirección principal"));
		setValueBuffer("direccionppal", true);
		setValueBuffer("direccion", curTarjeta.valueBuffer("direccion"));
		setValueBuffer("ciudad", curTarjeta.valueBuffer("ciudad"));
		setValueBuffer("provincia", curTarjeta.valueBuffer("provincia"));
		setValueBuffer("codpais", curTarjeta.valueBuffer("codpais"));
		setValueBuffer("codproveedor", codProveedor);
		setValueBuffer("codpostal", curTarjeta.valueBuffer("codpostal"));
	}
	
	return true;
}

/** \C
Al pulsar el botón de generar oportunidad se creará la oportunidad de ventas correspondiente a la tarjeta seleccionada.
\end */
function oficial_pbnGenerarOportunidadClicked()
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil;
	var codOportunidad:String;

	var codOporAnterior:String = util.sqlSelect("crm_oportunidadventa", "codoportunidad", "codtarjeta = '" + cursor.valueBuffer("codtarjeta") + "'");
	if (codOporAnterior) {
		var res:Number = MessageBox.warning(util.translate("scripts", "Ya existe al menos una oportunidad creada (%1) para la tarjeta seleccioanda.\n¿Desea continuar?").arg(codOporAnterior), MessageBox.Yes, MessageBox.No);
		if (res != MessageBox.Yes)
			return false;
	}

	cursor.transaction(false);
	try {
		codOportunidad = this.iface.generarOportunidad(cursor)
		if (codOportunidad) {
			cursor.commit();
			MessageBox.warning(util.translate("scripts", "Se ha creado la oportunidad %1 en la tabla de oportunidades de venta").arg(codOportunidad), MessageBox.Ok, MessageBox.NoButton);
		} else
			cursor.rollback();
	}
	catch (e) {
		cursor.rollback();
		MessageBox.critical(util.translate("scripts", "Hubo un error en la generación de la oportunidad:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
	}
}

/** \D 
Genera la oportunidad asociada a una tarjeta
@param curTarjeta: Cursor con los datos principales que se copiarán de la tarjeta a la oportunidad
@return Identificador de la oportunidad generado. FALSE si hay error
\end */
function oficial_generarOportunidad(curTarjeta:FLSqlCursor):String
{
	if (!this.iface.curOportunidad)
		this.iface.curOportunidad = new FLSqlCursor("crm_oportunidadventa");
	
	this.iface.curOportunidad.setModeAccess(this.iface.curOportunidad.Insert);
	this.iface.curOportunidad.refreshBuffer();
	
	if (!this.iface.datosOportunidad(curTarjeta))
		return false;
	
	if (!this.iface.curOportunidad.commitBuffer()) {
		return false;
	}
	var codOportunidad:String = this.iface.curOportunidad.valueBuffer("codoportunidad");
	
	return codOportunidad;
}

/** \D Informa los datos de una oportunidad de ventas a partir de los de una tarjeta
@param	curTarjeta: Cursor que contiene los datos a incluir en la oportunidad
@return	True si la copia de datos se realiza correctamente, false en caso contrario
\end */
function oficial_datosOportunidad(curTarjeta:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	var codEstado:String = util.sqlSelect("crm_estadosoportunidad", "codestado", "valordefecto = true");
	if (!codEstado) {
		MessageBox.warning(util.translate("scripts", "No tiene ningún estado de oportunidad de ventas marcado como valor por defecto.\nDebe establecer el estado por defecto antes de generar la oportunidad"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var codTarjeta:String = curTarjeta.valueBuffer("codtarjeta");
	with (this.iface.curOportunidad) {
		setValueBuffer("codoportunidad", util.nextCounter("codoportunidad", this));
		setValueBuffer("descripcion", util.translate("scripts", "Oportunidad proveniente de tarjeta %1").arg(codTarjeta));
		setValueBuffer("nomcliente", curTarjeta.valueBuffer("nombre"));
		setValueBuffer("codestado", codEstado);
		setValueBuffer("probabilidad", util.sqlSelect("crm_estadosoportunidad", "probabilidad", "codestado = '" + codEstado + "'"));
		setValueBuffer("codcliente", curTarjeta.valueBuffer("codcliente"));
		setValueBuffer("codcontacto", curTarjeta.valueBuffer("codcontacto"));
		setValueBuffer("codtarjeta", codTarjeta);
		setValueBuffer("idusuario", curTarjeta.valueBuffer("responsable"));
		setValueBuffer("observaciones", curTarjeta.valueBuffer("observaciones"));
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
