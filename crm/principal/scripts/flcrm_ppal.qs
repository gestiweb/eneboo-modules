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

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// TAREAS /////////////////////////////////////////////////////
class tareas extends oficial {
	var tipoObjeto_:String;
	var idObjeto_:String;
	var cursor_:FLSqlCursor;
	var filtroFormulario_:FLSqlCursor;
	var tdbTareasS:Object;
	var tbnLanzarTareaS:Object;
	var tbnEditTareaS:Object;
	var tbnDeleteTareaS:Object;
	var tbnVerTareaS:Object;
	var tbnIniciarTareaS:Object;
	var tbnDeshacerTareaS:Object;
	var chkPteS:Object;
	var chkEnCursoS:Object;
	var chkTerminadaS:Object;
	var chkMiasS:Object;
	var chkDeMiGrupoS:Object;
	var chkSinAsignarS:Object;
	var chkTodasS:Object;
	var container_:Object;

	function tareas( context ) { oficial( context ); }
	function valoresIniciales(){
		this.ctx.tareas_valoresIniciales();
	}
	function crearProceso(tipoProceso:String, tipoObjeto:String, idObjeto:String):Number {
		return this.ctx.tareas_crearProceso(tipoProceso, tipoObjeto, idObjeto);
	}
	function activarTarea(idTarea:String):Boolean {
		return this.ctx.tareas_activarTarea(idTarea);
	}
	function iniciarTarea(curTareas:FLSqlCursor, idUser:String) {
		return this.ctx.tareas_iniciarTarea(curTareas, idUser);
	}
	function tiempoMedioProceso(idTipoProceso:String):Boolean {
		return this.ctx.tareas_tiempoMedioProceso(idTipoProceso);
	}
	function tiempoUnidadProceso(idTipoProceso:String):Boolean {
		return this.ctx.tareas_tiempoUnidadProceso(idTipoProceso);
	}
	function tiempoMedioTarea(idTipoTarea:String):Boolean {
		return this.ctx.tareas_tiempoMedioTarea(idTipoTarea);
	}
	function iniciarProceso(idProceso:String):Boolean {
		return this.ctx.tareas_iniciarProceso(idProceso);
	}
	function calcularIntervalo(diaInicio:Date, tiempoInicio:Time, momentoFin:Date):Number {
		return this.ctx.tareas_calcularIntervalo(diaInicio, tiempoInicio, momentoFin)
	}
	function terminarProceso(idProceso:String):Boolean {
		return this.ctx.tareas_terminarProceso(idProceso);
	}
	function terminarTarea(curTareas:FLSqlCursor):Boolean {
		return this.ctx.tareas_terminarTarea(curTareas);
	}
	function esTareaInicial(idTipoTarea:String):Boolean {
		return this.ctx.tareas_esTareaInicial(idTipoTarea);
	}
	function cambiarEstadoObjeto(idProceso:Number, estadoProceso:String):Boolean {
		return this.ctx.tareas_cambiarEstadoObjeto(idProceso, estadoProceso);
	}
	function estadoObjeto(idProceso:Number):String {
		return this.ctx.tareas_estadoObjeto(idProceso);
	}
	function deshacerProcesoTerminado(idProceso:String):Boolean {
		return this.ctx.tareas_deshacerProcesoTerminado(idProceso);
	}
	function deshacerProcesoEnCurso(idProceso:String):Boolean {
		return this.ctx.tareas_deshacerProcesoEnCurso(idProceso);
	}
	function deshacerTareaTerminada(curTareas:FLSqlCursor):Boolean {
		return this.ctx.tareas_deshacerTareaTerminada(curTareas);
	}
	function deshacerTareaEnCurso(curTareas:FLSqlCursor):Boolean {
		return this.ctx.tareas_deshacerTareaEnCurso(curTareas);
	}
	function estadoObjetoInicial(idProceso:Number):String {
		return this.ctx.tareas_estadoObjetoInicial(idProceso);
	}
	function borrarProceso(idProceso:Number):Boolean {
		return this.ctx.tareas_borrarProceso(idProceso);
	}
	function detenerProceso(idProceso:Number):Boolean {
		return this.ctx.tareas_detenerProceso(idProceso);
	}
	function cancelarProceso(idProceso:Number):Boolean {
		return this.ctx.tareas_cancelarProceso(idProceso);
	}
	function reanudarProceso(idProceso:Number):Boolean {
		return this.ctx.tareas_reanudarProceso(idProceso);
	}
	function cerosIzquierda(numero:String, totalCifras:Number):String {
		return this.ctx.tareas_cerosIzquierda(numero, totalCifras);
	}
	function calcularIdTarea():String {
		return this.ctx.tareas_calcularIdTarea();
	}
	function iniciarTareaEsp(curTareas:FLSqlCursor):Boolean {
		return true; //Función a sobrecargar
	}
	function terminarTareaEsp(curTareas:FLSqlCursor):Boolean {
		return true; //Función a sobrecargar
	}
	function deshacerTareaTerminadaEsp(curTareas:FLSqlCursor):Boolean {
		return true; //Función a sobrecargar
	}
	function deshacerTareaEnCursoEsp(curTareas:FLSqlCursor):Boolean {
		return true; //Función a sobrecargar
	}
	function iniciarProcesoEsp(idProceso:String):Boolean {
		return true; //Función a sobrecargar
	} 
	function terminarProcesoEsp(curProceso:FLSqlCursor):Boolean {
		return true; //Función a sobrecargar
	}
	function deshacerProcesoTerminadoEsp(idProceso:String):Boolean {
		return true; //Función a sobrecargar
	}
	function deshacerProcesoEnCursoEsp(idProceso:String):Boolean {
		return true; //Función a sobrecargar
	}
	function descripcionTarea(curTarea:FLSqlCursor):String {
		return this.ctx.tareas_descripcionTarea(curTarea);
	}
	function asignarTareas(idProceso:String, idTipoProceso:String):Boolean {
		return this.ctx.tareas_asignarTareas(idProceso, idTipoProceso);
	}
	function seguimientoOn(container:Object, datosS:Array):Boolean {
		return this.ctx.tareas_seguimientoOn(container, datosS);
	}
	function seguimientoOff():Boolean {
		return this.ctx.tareas_seguimientoOff();
	}
	function regenerarFiltroS() {
		return this.ctx.tareas_regenerarFiltroS();
	}
	function filtroEstadoS():String {
		return this.ctx.tareas_filtroEstadoS();
	}
	function filtroPropietarioS():String {
		return this.ctx.tareas_filtroPropietarioS();
	}
	function filtroFormularioS(filtro:String) {
		return this.ctx.tareas_filtroFormularioS(filtro);
	}
	function valoresDefectoFiltroS() {
		return this.ctx.tareas_valoresDefectoFiltroS();
	}
	function tbnLanzarTareaSClicked() {
		return this.ctx.tareas_tbnLanzarTareaSClicked();
	}
	function tbnEditTareaSClicked() {
		return this.ctx.tareas_tbnEditTareaSClicked();
	}
	function tbnDeleteTareaSClicked() {
		return this.ctx.tareas_tbnDeleteTareaSClicked();
	}
	function tbnVerTareaSClicked() {
		return this.ctx.tareas_tbnVerTareaSClicked();
	}
	function tbnIniciarTareaSClicked(idUsuario:String):Boolean {
		return this.ctx.tareas_tbnIniciarTareaSClicked(idUsuario);
	}
	function tbnDeshacerTareaSClicked():Boolean {
		return this.ctx.tareas_tbnDeshacerTareaSClicked();
	}
	function procesarEstadoS() {
		return this.ctx.tareas_procesarEstadoS();
	}
	function obtenerTipoProcesoS() {
		return this.ctx.tareas_obtenerTipoProcesoS();
	}
	function elegirOpcion(opciones:Array):Number {
		return this.ctx.tareas_elegirOpcion(opciones);
	}
	function notificar(mensaje:Array):Boolean {
		return this.ctx.tareas_notificar(mensaje);
	}
	function initMensaje():Array {
		return this.ctx.tareas_initMensaje();
	}
	function establecerAccionTareaS() {
		return this.ctx.tareas_establecerAccionTareaS();
	}
	function procesarEvento(datosEvento:Array):Boolean {
		return this.ctx.tareas_procesarEvento(datosEvento);
	}
	function actualizarTiempoTotal(tipoObjeto:String, idObjeto:String) {
		return this.ctx.tareas_actualizarTiempoTotal(tipoObjeto, idObjeto);
	}
	function calcularTiempo(tipoObjeto:String, idObjeto:String):Number {
		return this.ctx.tareas_calcularTiempo(tipoObjeto, idObjeto);
	}
}
//// TAREAS /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends tareas {
    function head( context ) { tareas ( context ); }
    	function pub_cerosIzquierda(numero:String, totalCifras:Number):String {
		return this.cerosIzquierda(numero, totalCifras);
	}
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
	function pub_filtroFormularioS(filtro:String) {
		return this.filtroFormularioS(filtro);
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

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// TAREAS /////////////////////////////////////////////////////
/** \D
Rellena un string con ceros a la izquierda hasta completar la logitud especificada
@param numero: String que contiene el número
@param totalCifras: Longitud a completar
\end */
function tareas_cerosIzquierda(numero:String, totalCifras:Number):String
{
	var i:Number, j:Number;
	var valor:String = numero;
	for (i = 0; (numero.toString().charAt(i)); i++);
	if (i < totalCifras)
			for (j = i; j < totalCifras; j++)
					valor = "0" + valor;
	return valor;
}

function tareas_valoresIniciales()
{
	var util:FLUtil = new FLUtil;
	// TIPOS DE PROCESO
	var values:Array =
		[[util.translate("scripts", "TAREA UNITARIA"), util.translate("scripts", "Tarea sencilla de ejemplo"), true]];

	var cursor:FLSqlCursor = new FLSqlCursor("pr_tiposproceso");
	for (var i:Number = 0; i < values.length; i++) {
		with(cursor) {
			setModeAccess(cursor.Insert);
			refreshBuffer();
			setValueBuffer("idtipoproceso", values[i][0]);
			setValueBuffer("descripcion", values[i][1]);
			setValueBuffer("accesiblecrm", values[i][2]);
			commitBuffer();
		}
	}
	delete cursor;

	// TIPOS DE TAREA
	var values:Array =
		[[util.translate("scripts", "TAREA"), util.translate("scripts", "Tarea de ejemplo")]];
	var cursor:FLSqlCursor = new FLSqlCursor("pr_tipostarea");
	for (var i:Number = 0; i < values.length; i++) {
		with(cursor) {
			setModeAccess(cursor.Insert);
			refreshBuffer();
			setValueBuffer("idtipotarea", values[i][0]);
			setValueBuffer("descripcion", values[i][1]);
			commitBuffer();
		}
	}
	delete cursor;

	// TIPOS DE TAREA ASOCIADOS A PROCESOS
	var values:Array =
		[[util.translate("scripts", "TAREA"), util.translate("scripts", "Tarea de ejemplo"), util.translate("scripts", "TAREA UNITARIA"), "TERMINADO", true, true]];
	var cursor:FLSqlCursor = new FLSqlCursor("pr_tipostareapro");
	for (var i:Number = 0; i < values.length; i++) {
		with(cursor) {
			setModeAccess(cursor.Insert);
			refreshBuffer();
			setValueBuffer("idtipotarea", values[i][0]);
			setValueBuffer("descripcion", values[i][1]);
			setValueBuffer("idtipoproceso", values[i][2]);
			setValueBuffer("subestadoproceso", values[i][3]);
			setValueBuffer("tareainicial", values[i][4]);
			setValueBuffer("tareafinal", values[i][5]);
			commitBuffer();
		}
	}
	delete cursor;

}

/** \D
Crea un proceso en estado PTE y todas sus tareas asociadas, lanzando las tareas marcadas como iniciales
@param tipoProceso: Tipo del proceso a crear
@param tipoObjeto: Tipo de objeto asociado al proceso
@param idObjeto: Identificador del objeto asociado al proceso
@return Identificador del proceso si la creación tiene éxito. 0 en otro caso.
\end */
function tareas_crearProceso(tipoProceso:String, tipoObjeto:String, idObjeto:String):Number
{
	var idProceso:Number;
	var util:FLUtil = new FLUtil;
	var curProceso:FLSqlCursor = new FLSqlCursor("pr_procesos");
	with (curProceso) {
		setModeAccess(curProceso.Insert);
		refreshBuffer();
		setValueBuffer("idtipoproceso", tipoProceso);
		setValueBuffer("idobjeto", idObjeto);
		setValueBuffer("estado", "PTE");
	}
	if (!curProceso.commitBuffer())
		return false;

	idProceso = curProceso.valueBuffer("idproceso");

	var qryTiposTarea:FLSqlQuery = new FLSqlQuery();
	with (qryTiposTarea) {
		setTablesList("pr_tipostareapro");
		setSelect("idtipotarea, idtipotareapro");
		setFrom("pr_tipostareapro");
		setWhere("idtipoproceso = '" + tipoProceso + "' ORDER BY ordenlista");
	}
	if (!qryTiposTarea.exec())
		return false;

	var curTarea:FLSqlCursor = new FLSqlCursor("pr_tareas");
	while (qryTiposTarea.next()) {
		curTarea.setModeAccess(curTarea.Insert);
		curTarea.refreshBuffer();
		curTarea.setValueBuffer("idtarea", this.iface.calcularIdTarea());
		curTarea.setValueBuffer("idproceso", idProceso);
		curTarea.setValueBuffer("estado", "OFF");
		curTarea.setValueBuffer("idtipotarea", qryTiposTarea.value("idtipotarea"));
		curTarea.setValueBuffer("idtipotareapro", qryTiposTarea.value("idtipotareapro"));
		curTarea.setValueBuffer("descripcion", this.iface.descripcionTarea(curTarea));
		curTarea.setValueBuffer("tipoobjeto", tipoObjeto);
		curTarea.setValueBuffer("idobjeto", idObjeto);
		curTarea.setValueBuffer("idusuario", sys.nameUser()); // Añade el usuario actual a la tarea

		if (!curTarea.commitBuffer())
			return false;
	}

	if (!this.iface.asignarTareas(idProceso, tipoProceso))
		return false;

	var qryTareasIniciales:FLSqlQuery = new FLSqlQuery;
	with (qryTareasIniciales) {
		setTablesList("pr_tipostareapro,pr_tareas");
		setSelect("t.idtarea");
		setFrom("pr_tareas t INNER JOIN pr_tipostareapro tt ON t.idtipotareapro = tt.idtipotareapro");
		setWhere("t.idproceso = '" + idProceso + "'" + " AND tt.tareainicial IN ('1','TRUE','t')");
	}
	if (!qryTareasIniciales.exec())
		return false;

	while (qryTareasIniciales.next()) {
		if (!this.iface.activarTarea(qryTareasIniciales.value("t.idtarea")))
			return false;
	}
	return idProceso;
}


/** \D Pide al usuario que indique los responsables de cada tarea
@param	idProceso: Identificador del proceso
@param	idTipoProceso: Identificador del tipo de proceso
@return	true si no hay error, false en caso contrario
\end */
function tareas_asignarTareas(idProceso:String, idTipoProceso:String):Boolean
{
	var util:FLUtil = new FLUtil;
	var arrayAlias:Array = [];
	var qryAlias:FLSqlQuery = new FLSqlQuery();

	qryAlias.setTablesList("pr_aliasproceso");
	qryAlias.setSelect("idalias, alias, idusuariodef, idgrupodef");
	qryAlias.setFrom("pr_aliasproceso");
	qryAlias.setWhere("idtipoproceso = '" + idTipoProceso + "'");
	qryAlias.setForwardOnly(true);
	if (!qryAlias.exec())
		return false;

	var usuarioActual:String = sys.nameUser();
	var idUser:String;
	var idGroup:String;
	var idAsignacion:String;
	while (qryAlias.next()) {
		var fAlias:Object = new FLFormSearchDB("pr_asignaralias");
		var curAsignar:FLSqlCursor = fAlias.cursor();
	
		// Asignación de usuario y/o grupo a todos los alias del proceso
		curAsignar.select("idusuariocon = '" + usuarioActual + "'");
		if (curAsignar.first()) {
			curAsignar.setModeAccess(curAsignar.Edit);
		} else {
			curAsignar.setModeAccess(curAsignar.Insert);
		}
		curAsignar.refreshBuffer();
		curAsignar.setValueBuffer("idusuariocon", usuarioActual);
		curAsignar.setValueBuffer("alias", qryAlias.value("alias"));
		curAsignar.setValueBuffer("idgroup",qryAlias.value("idgrupodef"));
		curAsignar.setValueBuffer("iduser",qryAlias.value("idusuariodef"));

		fAlias.setMainWidget();
		idAsignacion = fAlias.exec("idasignacion");

		if (idAsignacion) {
			if (!curAsignar.commitBuffer())
				return false;
			// Actualización de todas las tareas del proceso asociadas al alias con el usuario y grupo especificados.
			var qryAsignarAlias:FLSqlQuery = new FLSqlQuery;
			qryAsignarAlias.setTablesList("pr_tareas,pr_tipostareapro");
			qryAsignarAlias.setSelect("t.idtarea");
			qryAsignarAlias.setFrom("pr_tareas t INNER JOIN pr_tipostareapro tp ON t.idtipotareapro = tp.idtipotareapro");
			qryAsignarAlias.setWhere("t.idproceso = " + idProceso + " AND tp.idalias = " + qryAlias.value("idalias"));
			qryAsignarAlias.setForwardOnly(true);
			if (!qryAsignarAlias.exec())
				return false;
			while (qryAsignarAlias.next()) {
				idUser = util.sqlSelect("pr_asignaralias", "iduser", "idasignacion = " + idAsignacion);
				if (!idUser)
					idUser = "NULL";
				idGroup = util.sqlSelect("pr_asignaralias", "idgroup", "idasignacion = " + idAsignacion);
				if (!idGroup)
					idGroup = "NULL";
				if (!util.sqlUpdate("pr_tareas", "iduser,idgroup", idUser + "," + idGroup, "idtarea = '" + qryAsignarAlias.value("t.idtarea") + "'"))
					return false;
			}
		}
	}

	var qryTareas:FLSqlQuery = new FLSqlQuery;
	with (qryTareas) {
		setTablesList("pr_tareas,pr_tipostareapro");
		setSelect("idtarea");
		setFrom("pr_tareas t INNER JOIN pr_tipostareapro ttp ON t.idtipotareapro = ttp.idtipotareapro");
		setWhere("t.idproceso = " + idProceso + " AND ttp.idalias IS NULL ORDER BY idtarea");
		setForwardOnly(true);
	}
	if (!qryTareas.exec())
		return false;

	var ok:String;
	var f:Object;
	var curTareas:FLSqlCursor;
	while (qryTareas.next()) {
		f = new FLFormSearchDB("pr_asignartarea");
		curTareas = f.cursor();
		curTareas.select("idtarea = '" + qryTareas.value("idtarea") + "'");
		if (!curTareas.first())
			return false;
		
		curTareas.setModeAccess(curTareas.Edit);
		curTareas.refreshBuffer();
		
		f.setMainWidget();
		ok = f.exec("idtarea");
		if (ok) {
			if (!curTareas.commitBuffer())
				return false;
		}
		f.close();
		delete f;
	}
	return true;
}
/** \D Obtiene la descripción de la tarea
@param	curTarea: Cursor con los datos de la tarea
@return	Descripción
\end */
function tareas_descripcionTarea(curTarea:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil;
	return util.sqlSelect("pr_tipostareapro", "descripcion", "idtipotareapro = " + curTarea.valueBuffer("idtipotareapro"));
}

/** \D Obtiene el siguiente código de tarea
@return	Código de tarea (TA + Número de 6 cifras)
\end */
function tareas_calcularIdTarea():String
{
	var util:FLUtil = new FLUtil();
	var id:String = "TA000001";
	var idUltima:String = util.sqlSelect("pr_tareas", "idtarea", "idtarea LIKE 'TA%' ORDER BY idtarea DESC");
	if (idUltima) {
		var numUltima:Number = parseFloat(idUltima.right(6));
		id = "TA" + this.iface.pub_cerosIzquierda((++numUltima).toString(), 6);
	}

	return id;
}

/** \C
Cambia el estado de la tarea a PTE si es la tarea inicial o si todas sus predecesoras están en estado TERMINADA
@param idTarea: Identificador de la tarea
@return VERDADERO si la tarea ha sido activada. FALSO en otro caso
\end */
function tareas_activarTarea(idTarea:String):Boolean
{
	var util:FLUtil = new FLUtil();
	var curTarea:FLSqlCursor = new FLSqlCursor("pr_tareas");
	var estado:String;

	curTarea.select("idtarea = '" + idTarea + "'");
	if (!curTarea.first())
		return false;

	var idProceso:Number = curTarea.valueBuffer("idproceso");
	var idTipoTareaPro:String = curTarea.valueBuffer("idtipotareapro");
	var tareaInicial:Boolean = util.sqlSelect("pr_tipostareapro", "tareainicial", "idtipotareapro = " + idTipoTareaPro);
	if (!this.iface.esTareaInicial(idTipoTareaPro)) {
		var tareaPreviaPte:Number = util.sqlSelect("pr_tareas t INNER JOIN pr_secuencias s ON t.idtipotareapro = s.tareainicio", "t.idtarea", "t.idproceso = " + idProceso + " AND t.estado <> 'TERMINADA' AND s.tareafin = " + idTipoTareaPro, "pr_tipostareapro,pr_secuencias");
		if (tareaPreviaPte)
			return false;
	}

	var hoy:Date = new Date;
	var asignado:String = curTarea.valueBuffer("iduser");
	with (curTarea) {
		setModeAccess(curTarea.Edit);
		refreshBuffer();
		setValueBuffer("estado", "PTE");
		setValueBuffer("fechaactivacion", hoy);
	}
	if (!curTarea.commitBuffer()) {
		return false;
	}
	return true;
}

/** \C
Cambia el estado de la tarea de PTE a EN CURSO, llamando -si existe- a la acción asociada a la tarea
@param curTareas: Cursor posicionado sobre la tarea a iniciar
@param idUser: Identificador del usuario que inicia la tarea
@return VERDADERO si la tarea ha sido iniciada. FALSO en otro caso
\end */
function tareas_iniciarTarea(curTareas:FLSqlCursor, idUser:String)
{
	var util:FLUtil = new FLUtil();
	var idTipoTarea:String = curTareas.valueBuffer("idtipotarea");
	var idTipoTareaPro:String = curTareas.valueBuffer("idtipotareapro");
	var idTarea:String = curTareas.valueBuffer("idtarea");
	var idProceso:String = curTareas.valueBuffer("idproceso");
	var estado:String = curTareas.valueBuffer("estado");

	var fechaInicio:Date = new Date();
	var horaInicio:String = fechaInicio.toString().substring(11, 19);

	with(curTareas) {
		setModeAccess(curTareas.Edit);
		refreshBuffer();
		setValueBuffer("estado", "EN CURSO");
		setValueBuffer("tiempoinicio", horaInicio);
		setValueBuffer("diainicio", fechaInicio);
		setValueBuffer("realizadapor", idUser);
	}
	if (!curTareas.commitBuffer())
		return false;

	curTareas.select("idtarea = '" + idTarea + "'");
	curTareas.first();
	curTareas.setModeAccess(curTareas.Edit);
	curTareas.refreshBuffer();

/** \C Si la tarea es una tarea inicial, se inicia el proceso asociado, y se marca el objeto relacionado para indicar que está incluido en un proceso ya iniciado
\end */
	if (this.iface.esTareaInicial(idTipoTareaPro)) {
		if (!this.iface.iniciarProceso(idProceso))
			return false;

		var estadoObjeto:String = this.iface.estadoObjetoInicial(idProceso);
		if (!this.iface.cambiarEstadoObjeto(idProceso, estadoObjeto))
			return false;
	}
	if (!this.iface.iniciarTareaEsp(curTareas))
		return false;

	return true;
}

/** \D
Indica si el tipo de tarea especificado corresponde a una tarea marcada como inicial
@param idTipoTareaPro: Tipo de tarea por proceso
@return VERDADERO si la tarea es inicial. FALSO en otro caso
\end */
function tareas_esTareaInicial(idTipoTareaPro:String):Boolean
{
	var util:FLUtil = new FLUtil();
	var tareaInicial:String = util.sqlSelect("pr_tipostareapro", "tareainicial", "idtipotareapro = " + idTipoTareaPro);
	if (tareaInicial == false || tareaInicial == "f")
		return false;
	else
		return true;
}
/** \C
Cambia el estado de la tarea a TERMINADA, activando las tareas subsiguientes.
Si la tarea está configurada para cambiar el estado del proceso, realiza el cambio de estado.
Si la tarea está configurada para cambiar el estado del objeto asociado al proceso, realiza el cambio de estado.
Si la tarea está marcada como tarea de fin de proceso, finaliza el proceso.
@param curTareas: Cursor posicionado sobre la tarea a finalizar
@return VERDADERO si la tarea ha sido finalizada. FALSO en otro caso
\end */
function tareas_terminarTarea(curTareas:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	var idTipoTarea:String = curTareas.valueBuffer("idtipotarea");
	var idTipoTareaPro:String = curTareas.valueBuffer("idtipotareapro");
	var idTarea:String = curTareas.valueBuffer("idtarea");
	var idProceso:String = curTareas.valueBuffer("idproceso");

	if (!this.iface.terminarTareaEsp(curTareas))
		return false;

	var qryTiposTarea:FLSqlQuery = new FLSqlQuery();
	with (qryTiposTarea) {
		setTablesList("pr_tipostareapro");
		setSelect("subestadoproceso, estadoobjeto");
		setFrom("pr_tipostareapro");
		setWhere("idtipotareapro = " + idTipoTareaPro);
	}
	if (!qryTiposTarea.exec())
		return false;
	if (!qryTiposTarea.first())
		return false;
	var subestadoProceso:String = qryTiposTarea.value("subestadoproceso");
	var estadoObjeto:String = qryTiposTarea.value("estadoobjeto");

	if (subestadoProceso != "")
		util.sqlUpdate("pr_procesos", "subestado", subestadoProceso, "idproceso = '" + idProceso + "'");

	if (!this.iface.cambiarEstadoObjeto(idProceso, estadoObjeto))
		return false;
	var fechaFin:Date = new Date();
	var horaFin:String = fechaFin.toString().substring(11, 19);
	with(curTareas) {
		if (curTareas.modeAccess() != curTareas.Edit) {
			setModeAccess(curTareas.Edit);
			refreshBuffer();
		}
		setValueBuffer("estado", "TERMINADA");
		setValueBuffer("tiempofin", horaFin);
		setValueBuffer("diafin", fechaFin);
	}

	var intervalo:Number = this.iface.calcularIntervalo(curTareas.valueBuffer("diainicio"), curTareas.valueBuffer("tiempoinicio"), fechaFin);
	curTareas.setValueBuffer("intervalo", intervalo);

	if (!curTareas.commitBuffer())
		return false;

	var tareaFinal:Number = util.sqlSelect("pr_tipostareapro", "tareafinal", "idtipotareapro = " + idTipoTareaPro);
	if (tareaFinal == false || tareaFinal == "f") {
		var qrySiguienteTarea:FLSqlQuery = new FLSqlQuery();
		with (qrySiguienteTarea) {
			setTablesList("pr_tipostareapro,pr_secuencias");
			setSelect("s.tareafin");
			setFrom("pr_tipostareapro tt INNER JOIN pr_secuencias s ON tt.idtipotareapro = s.tareainicio");
			setWhere("tt.idtipotareapro = " + idTipoTareaPro);
		}
		if (!qrySiguienteTarea.exec())
			return false;
		var siguienteTarea:String;
		while (qrySiguienteTarea.next()) {
			siguienteTarea = util.sqlSelect("pr_tareas", "idtarea", "idproceso = '" + idProceso + "' AND idtipotareapro = " + qrySiguienteTarea.value("s.tareafin"));
			this.iface.activarTarea(siguienteTarea);
		}
	} else {
		// El proceso acaba si no hay ninguna tarea final que no esté terminada
		if (!util.sqlSelect("pr_tareas t INNER JOIN pr_tipostareapro tt ON t.idtipotareapro = tt.idtipotareapro", "idtarea ", "t.idproceso = " + idProceso + " AND tt.tareafinal = true AND t.estado <> 'TERMINADA'", "pr_tareas,pr_tipostareapro")) {
			if (!this.iface.terminarProceso(idProceso))
				return false;
		}
	}
	
	if ( curTareas.valueBuffer("tipoobjeto") == "ase_casoscli") {
		if (!this.iface.insertarGestion(curTareas, curTareas.valueBuffer("idobjeto")))
			return false;
	}

	return true;
}

/** \D
Pasa el estado del proceso a TERMINADO, calculando el intervalo medio del tipo de proceso correspondiente
@param idProceso: Identificador del proceso que ha terminado
@return VERDADERO si el proceso finaliza correctamente. FALSO en otro caso
\end */
function tareas_terminarProceso(idProceso:String):Boolean
{
	var util:FLUtil = new FLUtil();
	var fechaFin:Date = new Date();
	var horaFin:String = fechaFin.toString().substring(11, 19);
	var curProceso:FLSqlCursor = new FLSqlCursor("pr_procesos");
	if (!curProceso.select("idproceso = " + idProceso))
		return false;
	if (!curProceso.first())
		return false;
	with(curProceso) {
		setModeAccess(curProceso.Edit);
		refreshBuffer();
		setValueBuffer("estado", "TERMINADO");
		setValueBuffer("tiempofin", horaFin);
		setValueBuffer("diafin", fechaFin);
	}
	var idTipoProceso:String = curProceso.valueBuffer("idtipoproceso");
	var intervalo:Number = this.iface.calcularIntervalo(curProceso.valueBuffer("diainicio"), curProceso.valueBuffer("tiempoinicio"), fechaFin);

	curProceso.setValueBuffer("intervalo", intervalo);
	if (!curProceso.commitBuffer())
		return false;

	if (!this.iface.tiempoMedioProceso(idTipoProceso))
		return false;

	if (!this.iface.terminarProcesoEsp(curProceso))
		return false;
	
	return true;
}

/** \D
Pasa el estado del proceso de TERMINADO a EN CURSO, borrando las fechas y tiempos de fin de proceso
@param idProceso: Identificador del proceso que ha terminado
@return VERDADERO si el proceso finaliza correctamente. FALSO en otro caso
\end */
function tareas_deshacerProcesoTerminado(idProceso:String):Boolean
{
	var util:FLUtil = new FLUtil();
	var fechaFin:Date = new Date();
	var horaFin:String = fechaFin.toString().substring(11, 19);
	var curProceso:FLSqlCursor = new FLSqlCursor("pr_procesos");

	if (!curProceso.select("idproceso = " + idProceso))
		return false;
	if (!curProceso.first())
		return false;
	with(curProceso) {
		setModeAccess(curProceso.Edit);
		refreshBuffer();
		setValueBuffer("estado", "EN CURSO");
		setNull("tiempofin");
		setNull("diafin");
		setNull("intervalo");
	}
	var idTipoProceso:String = curProceso.valueBuffer("idtipoproceso");
	if (!curProceso.commitBuffer())
		return false;
	if (!this.iface.tiempoMedioProceso(idTipoProceso))
		return false;

// 	var idTipoProceso:String = util.sqlSelect("pr_procesos", "idtipoproceso", "idproceso = " + idProceso);
// 	var codLote:String = util.sqlSelect("pr_procesos", "idobjeto", "idproceso = " + idProceso);
// 	if (util.sqlSelect("pr_tiposproceso","fabricacion","idtipoproceso = '" + idTipoProceso + "'")) {
// 		if (!util.sqlUpdate("lotesstock","estado","EN CURSO","codlote = '" + codLote + "'"))
// 			return false;
// 	}

	if (!this.iface.deshacerProcesoTerminadoEsp(idProceso))
		return false;

	return true;
}

/** \D
Calcula el intervalo en segundos entre dos momentos
@param diaInicio: Fecha del momento de inicio
@param tiempoInicio: Hora del momento de inicio
@param momentoFin: Momento de fin
@return intervalo en segundos
\end */
function tareas_calcularIntervalo(diaInicio:Date, tiempoInicio:Time, momentoFin:Date):Number
{
	var intervalo:Number = new Number;
	var longTiempoInicio:Number = tiempoInicio.toString().length;
	var horaInicio:String = diaInicio.toString().substring(0, 10) + ":" + tiempoInicio.toString().substring(longTiempoInicio - 8, longTiempoInicio);
	var momentoInicio:Date = new Date(Date.parse(horaInicio));

	intervalo = (momentoFin.getTime() - momentoInicio.getTime()) / 1000;
	return intervalo;
}


/** \D
Pasa el estado del proceso a EN CURSO
@param idProceso: Identificador del proceso que ha terminado
@return VERDADERO si el proceso se activa correctamente. FALSO en otro caso
\end */
function tareas_iniciarProceso(idProceso:String):Boolean
{
	var util:FLUtil = new FLUtil();

	var estado:String = util.sqlSelect("pr_procesos", "estado", "idproceso = " + idProceso);
	if (estado != "PTE")
		return true;

	var estadoObjeto:String = this.iface.estadoObjeto(idProceso);
	if (!estadoObjeto && estadoObjeto != "") {
		MessageBox.warning(util.translate("scripts", "Hubo un error al obtener el estado del objeto"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	if (estadoObjeto == "")
		estadoObjeto = "NULL";

	var fechaInicio:Date = new Date();
	var horaInicio:String = fechaInicio.toString().substring(11, 19);

	var result:Boolean = util.sqlUpdate("pr_procesos", "tiempoinicio,diainicio,estado,estadoprevio",  horaInicio + "," + fechaInicio + ",EN CURSO," + estadoObjeto, "idproceso = " + idProceso);

	/*var idTipoProceso:String = util.sqlSelect("pr_procesos", "idtipoproceso", "idproceso = " + idProceso);
	var codLote:String = util.sqlSelect("pr_procesos", "idobjeto", "idproceso = " + idProceso);
	if (util.sqlSelect("pr_tiposproceso","fabricacion","idtipoproceso = '" + idTipoProceso + "'")) {
		if (!util.sqlUpdate("lotesstock","estado","EN CURSO","codlote = '" + codLote + "'"))
			return false;
	}*/

	if (!this.iface.iniciarProcesoEsp(idProceso))
		return false;

	return result;
}

/** \D
Pasa el estado del proceso de EN CURSO a PTE
@param idProceso: Identificador del proceso que ha terminado
@return VERDADERO si el proceso se desactiva correctamente. FALSO en otro caso
\end */
function tareas_deshacerProcesoEnCurso(idProceso:String):Boolean
{
	var util:FLUtil = new FLUtil();

	var estado:String = util.sqlSelect("pr_procesos", "estado", "idproceso = " + idProceso);
	if (estado == "PTE")
		return true;
	if (estado != "EN CURSO") {
		MessageBox.warning(util.translate("scripts", "El proceso asociado a la tarea no puede cambiar a PTE por no estar en estado EN CURSO"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
	var curProceso:FLSqlCursor = new FLSqlCursor("pr_procesos");
	if (!curProceso.select("idproceso = " + idProceso))
		return false;
	if (!curProceso.first())
		return false;
	with(curProceso) {
		setModeAccess(curProceso.Edit);
		refreshBuffer();
		setValueBuffer("estado", "PTE");
		setNull("tiempoinicio");
		setNull("diainicio");
	}
	if (!curProceso.commitBuffer())
		return false;
 
// 	var idTipoProceso:String = util.sqlSelect("pr_procesos", "idtipoproceso", "idproceso = " + idProceso);
// 	var codLote:String = util.sqlSelect("pr_procesos", "idobjeto", "idproceso = " + idProceso);
// 	if (util.sqlSelect("pr_tiposproceso","fabricacion","idtipoproceso = '" + idTipoProceso + "'")) {
// 		if (!util.sqlUpdate("lotesstock","estado","PTE","codlote = '" + codLote + "'"))
// 			return false;
// 	}

	if (!this.iface.deshacerProcesoEnCursoEsp(idProceso))
		return false;

	return true;
}

/** \D
Recalcula el tiempo medio correspondiente a las tareas del tipo especificado
@param idTipoTarea: Tipo de tarea a recalcular
@return VERDADERO si el cálculo se realiza correctamente. FALSO en otro caso
\end */
function tareas_tiempoMedioTarea(idTipoTarea:String):Boolean
{
	var util:FLUtil = new FLUtil();
	var tiempoMedio:FLSqlCursor = util.sqlSelect("pr_tareas", "AVG(intervalo)", "idtipotarea = '" + idTipoTarea + "'");
	if (!tiempoMedio)
		return false;

	if (!util.sqlUpdate("pr_tipostarea", "tiempomedio", tiempoMedio, "idtipotarea = '" + idTipoTarea + "'"))
		return false;

	return true;
}

/** \D
Recalcula el tiempo medio correspondiente a los procesos del tipo especificado
@param idTipoProceso: Tipo de proceso a recalcular
@return VERDADERO si el cálculo se realiza correctamente. FALSO en otro caso
\end */
function tareas_tiempoMedioProceso(idTipoProceso:String):Boolean
{
	var util:FLUtil = new FLUtil();
	var tiempoMedio:Number = util.sqlSelect("pr_procesos", "AVG(intervalo)", "idtipoproceso = '" + idTipoProceso + "'");

	if (!tiempoMedio && tiempoMedio != 0)
		return false;

	if (!util.sqlUpdate("pr_tiposproceso", "tiempomedio", tiempoMedio,  "idtipoproceso = '" + idTipoProceso + "'"))
		return false;

	if(!this.iface.tiempoUnidadProceso(idTipoProceso))
		return false;

	return true;
}

/** \D
Recalcula el tiempo medio correspondiente a los procesos del tipo especificado
@param idTipoProceso: Tipo de proceso a recalcular
@return VERDADERO si el cálculo se realiza correctamente. FALSO en otro caso
\end */
function tareas_tiempoUnidadProceso(idTipoProceso:String):Boolean
{
	var util:FLUtil = new FLUtil();
	var unidad:String = "";
	var tiempoUnidad:Number = 0;
	var tiempoMedio:Number = parseFloat(util.sqlSelect("pr_tiposproceso", "tiempomedio", "idtipoproceso = '" + idTipoProceso + "'"));

	if (tiempoMedio && tiempoMedio != 0) {
		unidad = util.sqlSelect("pr_tiposproceso", "unidad", "idtipoproceso = '" + idTipoProceso + "'");

		switch (unidad) {
			case "Segundos":
				tiempoUnidad = tiempoMedio;
				break;
			case "Minutos":
				tiempoUnidad = tiempoMedio / 60;
				break;
			case "Horas":
				tiempoUnidad = tiempoMedio / (60 * 60)
				break;
			case "Dias":
				tiempoUnidad = tiempoMedio / (60 * 60 * 24)
				break;
			default:
				tiempoUnidad = 0;
		}
	}
	if (!util.sqlUpdate("pr_tiposproceso", "tiempounidad", tiempoUnidad,  "idtipoproceso = '" + idTipoProceso + "'"))
		return false;
	
	return true;
}

/** \C
Cambia el estado de una tarea TERMINADA a EN CURSO.

@param curTareas: Cursor posicionado sobre la tarea a deshacer
@return VERDADERO si la tarea ha sido deshecha. FALSO en otro caso
\end */
function tareas_deshacerTareaTerminada(curTareas:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	var idTipoTarea:String = curTareas.valueBuffer("idtipotarea");
	var idTipoTareaPro:String = curTareas.valueBuffer("idtipotareapro");
	var idTarea:String = curTareas.valueBuffer("idtarea");
	var idProceso:String = curTareas.valueBuffer("idproceso");

/** \C Condiciones:

EL proceso asociado debe estar TERMINADO o EN CURSO
\end */
	if (curTareas.valueBuffer("estado") != "TERMINADA") {
		MessageBox.warning(util.translate("scripts", "La tarea a deshacer debe estar en estado TERMINADA"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
	var estadoProceso:String = util.sqlSelect("pr_procesos", "estado", "idProceso = " + idProceso);
	if (estadoProceso != "TERMINADO" && estadoProceso != "EN CURSO") {
		MessageBox.warning(util.translate("scripts", "El proceso asociado a la tarea debe estar en estado TERMINADO o EN CURSO"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
/** \C Debe ser una tarea final, o bien sus tareas subsiguientes deben estar en estado OFF o PTE.
Las tareas subsiguientes que estaban en estado PTE, pasan a estado OFF
\end */
	var esTareaFinal:Boolean = util.sqlSelect("pr_tipostareapro", "tareafinal", "idtipotareapro = " + idTipoTareaPro);
	if (!esTareaFinal) {
		var qrySiguienteTarea:FLSqlQuery = new FLSqlQuery();
		with (qrySiguienteTarea) {
			setTablesList("pr_tipostareapro,pr_secuencias");
			setSelect("s.tareafin");
			setFrom("pr_tipostareapro tt INNER JOIN pr_secuencias s ON tt.idtipotareapro = s.tareainicio");
			setWhere("tt.idtipotareapro = " + idTipoTareaPro);
		}
		if (!qrySiguienteTarea.exec())
			return false;

		var estadoTareaSiguiente:String = "";
		while (qrySiguienteTarea.next()) {
			var qryDatosTareaSig:FLSqlQuery = new FLSqlQuery;
			with (qryDatosTareaSig) {
				setTablesList("pr_tareas");
				setSelect("idtarea, estado");
				setFrom("pr_tareas");
				setWhere("idproceso = " + idProceso + " AND idtipotareapro = " + qrySiguienteTarea.value("s.tareafin"))
				setForwardOnly(true);
			}
			if (!qryDatosTareaSig.exec())
				return false;

			if (!qryDatosTareaSig.first())
				return false;

			estadoTareaSiguiente = qryDatosTareaSig.value("estado");
			if (estadoTareaSiguiente != "OFF" && estadoTareaSiguiente != "PTE") {
				MessageBox.warning(util.translate("scripts", "La tarea a deshacer debe tener todas sus tareas subsiguientes en estado OFF o PTE"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				return false;
			}
			if (estadoTareaSiguiente == "PTE") {
				if (!util.sqlUpdate("pr_tareas", "estado", "OFF", "idtarea = '" + qryDatosTareaSig.value("idtarea") + "'"))
					return false;
			}
		}
	} else {
/** \C Si la tarea está marcada como tarea de fin de proceso, pasa el proceso de TERMINADO a EN CURSO
\end */
		if (!this.iface.deshacerProcesoTerminado(idProceso))
			return false;
	}

	with(curTareas) {
		if (curTareas.modeAccess() != curTareas.Edit) {
			setModeAccess(curTareas.Edit);
			refreshBuffer();
		}
		setValueBuffer("estado", "EN CURSO");
		setNull("tiempofin");
		setNull("diafin");
		setNull("intervalo");
	}
	if (!curTareas.commitBuffer())
		return false;
/** \C
El subestado del proceso pasará a ser el de la última tarea (mayor fecha de fin) en estado TERMINADA
\end */
	var subestadoProceso:String = "";
	var qryEstadoProceso:FLSqlQuery = new FLSqlQuery();
	with (qryEstadoProceso) {
		setTablesList("pr_tareas,pr_tipostareapro");
		setSelect("tt.subestadoproceso");
		setFrom("pr_tareas t INNER JOIN pr_tipostareapro tt ON t.idtipotareapro = tt.idtipotareapro");
		setWhere("t.idproceso = " + idProceso + " AND t.estado = 'TERMINADA' AND tt.subestadoproceso IS NOT NULL ORDER BY t.tiempofin DESC");
	}
	if (!qryEstadoProceso.exec())
		return false;
	if (qryEstadoProceso.first())
		subestadoProceso = qryEstadoProceso.value(0);
	else
		subestadoProceso = "";

	if (!util.sqlUpdate("pr_procesos", "subestado", subestadoProceso, "idproceso = " + idProceso))
		return false;

/** \C
El estado del objeto asociado al proceso pasará a ser el establecido en la última tarea (mayor fecha de fin) en estado TERMINADA, o el estado inicial en caso de no haber ninguna.
\end */
	var estadoObjeto:String = "";
	var qryEstadoObjeto:FLSqlQuery = new FLSqlQuery();
	with (qryEstadoObjeto) {
		setTablesList("pr_tareas,pr_tipostareapro");
		setSelect("tt.estadoobjeto");
		setFrom("pr_tareas t INNER JOIN pr_tipostareapro tt ON t.idtipotareapro = tt.idtipotareapro");
		setWhere("t.idproceso = " + idProceso + " AND t.estado = 'TERMINADA' AND tt.estadoobjeto IS NOT NULL ORDER BY t.tiempofin DESC");
	}
	if (!qryEstadoObjeto.exec())
		return false;
	if (qryEstadoObjeto.first())
		estadoObjeto = qryEstadoObjeto.value("tt.estadoobjeto");
	else {
		estadoObjeto = this.iface.estadoObjetoInicial(idProceso);
	}

	if (!this.iface.cambiarEstadoObjeto(idProceso, estadoObjeto))
		return false;

/** \C
Si la tarea consumía algún tipo de material, se restituye el material al almacén.
\end */

/** \C
Si la tarea realizaba alguna acción específica al pasar a TERMINADA, la acción es deshecha
\end */
	if (!this.iface.deshacerTareaTerminadaEsp(curTareas))
		return false;

	return true;
}

/** \D Cambia el estado del objeto asociado a un proceso
@param	idPoceso: Identificador del proceso
@param	estadoObjeto: Estado del objeto
@return True si el cambio se realiza correctamente, False en otro caso
\end */
function tareas_cambiarEstadoObjeto(idProceso:Number, estadoObjeto:String):Boolean
{
	var util:FLUtil = new FLUtil;
	if (!estadoObjeto || estadoObjeto == "")
		return true;

	var qryProceso:FLSqlQuery = new FLSqlQuery();
	with (qryProceso) {
		setTablesList("pr_procesos,pr_tiposproceso");
		setSelect("p.idobjeto, tp.tipoobjeto");
		setFrom("pr_procesos p INNER JOIN pr_tiposproceso tp ON p.idtipoproceso = tp.idtipoproceso");
		setWhere("idproceso = '" + idProceso + "'");
	}
	if (!qryProceso.exec())
		return false;
	if (!qryProceso.first())
		return false;
	var idObjeto:String = qryProceso.value(0);
	var tipoObjeto:String  = qryProceso.value(1);
	if (!idObjeto || idObjeto == "" || !tipoObjeto || tipoObjeto == "")
		return true;

	var curObjeto:FLSqlCursor = new FLSqlCursor(tipoObjeto);

	return util.sqlUpdate(tipoObjeto, "estado", estadoObjeto, curObjeto.primaryKey() + " = '" + idObjeto + "'");
}

/** \D Lee el estado del objeto asociado a un proceso
@param	idPoceso: Identificador del proceso
@return	Estado del objeto, "" si no existe y false si hay error
\end */
function tareas_estadoObjeto(idProceso:Number):String
{
	var util:FLUtil = new FLUtil;

	var qryProceso:FLSqlQuery = new FLSqlQuery();
	with (qryProceso) {
		setTablesList("pr_procesos,pr_tiposproceso");
		setSelect("p.idobjeto, tp.tipoobjeto");
		setFrom("pr_procesos p INNER JOIN pr_tiposproceso tp ON p.idtipoproceso = tp.idtipoproceso");
		setWhere("idproceso = '" + idProceso + "'");
	}
	if (!qryProceso.exec())
		return false;

	if (!qryProceso.first())
		return "";

	var idObjeto:String = qryProceso.value(0);
	var tipoObjeto:String  = qryProceso.value(1);
	if (!idObjeto || idObjeto == "" || !tipoObjeto || tipoObjeto == "")
		return "";

	var curObjeto:FLSqlCursor = new FLSqlCursor(tipoObjeto);

	var qryObjeto:FLSqlQuery = new FLSqlQuery;
	with (qryObjeto) {
		setTablesList(tipoObjeto);
		setSelect("estado");
		setFrom(tipoObjeto);
		setWhere(curObjeto.primaryKey() + " = '" + idObjeto + "'");
		setForwardOnly(true);
	}
	// Por si la tabla no tiene campo estado
	if (!qryObjeto.exec())
		return "";
	if (!qryObjeto.first())
		return false;

	return qryObjeto.value("estado");
}

/** \C
Cambia el estado de la tarea de EN CURSO a PTE, deshaciendo también -si existe- a la acción asociada a la tarea
@param curTareas: Cursor posicionado sobre la tarea a iniciar
@return VERDADERO si la tarea ha sido deshecha. FALSO en otro caso
\end */
function tareas_deshacerTareaEnCurso(curTareas:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	var idTipoTarea:String = curTareas.valueBuffer("idtipotarea");
	var idTipoTareaPro:String = curTareas.valueBuffer("idtipotareapro");
	var idTarea:String = curTareas.valueBuffer("idtarea");
	var idProceso:String = curTareas.valueBuffer("idproceso");
	var estado:String = curTareas.valueBuffer("estado");

	if (!this.iface.deshacerTareaEnCursoEsp(curTareas))
		return false;

	with(curTareas) {
		setModeAccess(curTareas.Edit);
		refreshBuffer();
		setValueBuffer("estado", "PTE");
		setNull("tiempoinicio");
		setNull("diainicio");
		setNull("realizadapor");
	}
	if (!curTareas.commitBuffer())
		return false;

/** \C
Si la tarea pasada a PTE es la última del proceso, el proceso pasa también a PTE y restituye el objeto asociado a su estado previo
\end */
	if (this.iface.esTareaInicial(idTipoTareaPro)) {
		if (!util.sqlSelect("pr_tareas", "idtarea", "idproceso = " + idProceso + " AND estado NOT IN ('PTE', 'OFF')")) {
			if (!this.iface.deshacerProcesoEnCurso(idProceso))
				return false;
			var estadoObjeto:String = util.sqlSelect("pr_procesos", "estadoprevio", "idproceso = " + idProceso);
			if (!this.iface.cambiarEstadoObjeto(idProceso, estadoObjeto))
				return false;
		}
	}

	curTareas.select("idtarea = '" + idTarea + "'");
	curTareas.first();
	curTareas.setModeAccess(curTareas.Edit);
	curTareas.refreshBuffer();

	return true;
}

/** \C
Obtiene el estado del objeto asociado a un proceso que debe establecerse cuando el proceso tiene su primera tarea en estado 'EN CURSO', para denotar que el objeto se encuentra asociado a un proceso ya comenzado
@param curTareas: Cursor posicionado sobre la tarea a iniciar
@return Estado inicial del proceso, FALSO si hay error
\end */
function tareas_estadoObjetoInicial(idProceso:Number):String
{
	return "EN CURSO";
}

/** \C
Borra un proceso.
El proceso debe estar en estado PTE y todas sus tareas en estado OFF o PTE
@param idProceso: Identificador del proceso a borrar
@return True si el proceso se borró correctamente, false en caso contrario
\end */
function tareas_borrarProceso(idProceso:Number):Boolean
{
	var util:FLUtil = new FLUtil();
	var estadoProceso:String = util.sqlSelect("pr_procesos", "estado", "idproceso = " + idProceso);
	if (estadoProceso != "PTE") {
		MessageBox.warning(util.translate("scripts", "Borrar proceso: El proceso debe estar en estado OFF o PTE"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var hayTareasIniciadas:Number = util.sqlSelect("pr_tareas", "idtarea", "idproceso = " + idProceso + " AND estado NOT IN ('PTE', 'OFF')");
	if (hayTareasIniciadas) {
		MessageBox.warning(util.translate("scripts", "Borrar proceso: Todas las tareas del proceso deben estar en estado OFF o PTE"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var paso:Number = 0;
	var curProcesos:FLSqlCursor = new FLSqlCursor("pr_procesos");
	curProcesos.select("idproceso = " + idProceso);

	while(curProcesos.next()) {
		curProcesos.setModeAccess(curProcesos.Del);
		curProcesos.refreshBuffer();
		if (!curProcesos.commitBuffer()) {
			MessageBox.critical(util.translate("scripts", "Borrar proceso: Hubo un error al borrar el proceso"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}

	var curTareas:FLSqlCursor = new FLSqlCursor("pr_tareas");
	curTareas.select("idproceso = " + idProceso);

	while(curTareas.next()) {
		curTareas.setModeAccess(curTareas.Del);
		curTareas.refreshBuffer();
		if (!curTareas.commitBuffer()) {
			MessageBox.critical(util.translate("scripts", "Borrar tareas: Hubo un error al borrar las tareas asociadas al proceso"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}
	return true;
}

/** \C
Detiene un proceso.
El proceso debe estar en estado EN CURSO o CANCELADO y todas sus tareas en estado OFF, PTE, TERMINADA, CANCELADA (ninguna EN CURSO)
Las tareas en estado PTE o CANCELADA pasan a DETENIDA
@param idProceso: Identificador del proceso a detener
@return True si el proceso se detuvo correctamente, false en caso contrario
\end */
function tareas_detenerProceso(idProceso:Number):Boolean
{
	var util:FLUtil = new FLUtil();
	var estadoProceso:String = util.sqlSelect("pr_procesos", "estado", "idproceso = " + idProceso);
	if (estadoProceso != "EN CURSO" && estadoProceso != "CANCELADO") {
		MessageBox.warning(util.translate("scripts", "No es posible detener el proceso porque no está en estado EN CURSO o CANCELADO"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var hayTareasEnCurso:Number = util.sqlSelect("pr_tareas", "idtarea", "idproceso = " + idProceso + " AND estado = 'EN CURSO'");
	if (hayTareasEnCurso) {
		MessageBox.warning(util.translate("scripts", "No es posible detener el proceso porque alguna de sus tareas esta EN CURSO"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	if (!util.sqlUpdate("pr_tareas", "estado", "DETENIDA", "idproceso = '" + idProceso + "' AND estado IN ('PTE', 'CANCELADA')")) {
		MessageBox.warning(util.translate("scripts", "Ha habido un error al detener el proceso"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	if (!util.sqlUpdate("pr_procesos", "estado", "DETENIDO", "idproceso = '" + idProceso + "'")) {
		MessageBox.warning(util.translate("scripts", "Ha habido un error al detener el proceso"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	return true;
}

/** \C
Cancela un proceso.
El proceso debe estar en estado EN CURSO o DETENIDO y todas sus tareas en estado OFF, PTE, TERMINADA o DETENIDA (ninguna EN CURSO)
Las tareas en estado PTE o DETENIDA pasan a CANCELADA
@param idProceso: Identificador del proceso a cancelar
@return True si el proceso se canceló correctamente, false en caso contrario
\end */
function tareas_cancelarProceso(idProceso:Number):Boolean
{
	var util:FLUtil = new FLUtil();
	var estadoProceso:String = util.sqlSelect("pr_procesos", "estado", "idproceso = " + idProceso);
	if (estadoProceso == "CANCELADO") {
		return true;
	}
	if (estadoProceso != "EN CURSO" && estadoProceso != "DETENIDO") {
		MessageBox.warning(util.translate("scripts", "Cancelar proceso: El proceso debe estar en estado EN CURSO o DETENIDO"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var hayTareasEnCurso:Number = util.sqlSelect("pr_tareas", "idtarea", "idproceso = " + idProceso + " AND estado = 'EN CURSO'");
	if (hayTareasEnCurso) {
		MessageBox.warning(util.translate("scripts", "Cancelar proceso: Alguna de las tareas del proceso está EN CURSO"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	if (!util.sqlUpdate("pr_tareas", "estado", "CANCELADA", "idproceso = '" + idProceso + "' AND estado IN ('PTE', 'DETENIDA')")) {
		MessageBox.critical(util.translate("scripts", "Cancelar proceso: Hubo un error al cancelar el proceso"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	if (!util.sqlUpdate("pr_procesos", "estado", "CANCELADO", "idproceso = '" + idProceso + "'")) {
		MessageBox.critical(util.translate("scripts", "Cancelar proceso: Hubo un error al cancelar el proceso"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	return true;
}

/** \C
Reanuda un proceso DETENIDO o CANCELADO, pasando a EN CURSO
Las tareas en estado DETENIDA o CANCELADA pasan a PTE
@param idProceso: Identificador del proceso a cancelar
@return True si el proceso se reanudó correctamente, false en caso contrario
\end */
function tareas_reanudarProceso(idProceso:Number):Boolean
{
	var util:FLUtil = new FLUtil();
	var estadoProceso:String = util.sqlSelect("pr_procesos", "estado", "idproceso = " + idProceso);
	if (estadoProceso != "DETENIDO" && estadoProceso != "CANCELADO") {
		MessageBox.warning(util.translate("scripts", "Reanudar proceso: El proceso debe estar DETENIDO o CANCELADO"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	if (!util.sqlUpdate("pr_tareas", "estado", "PTE", "idproceso = '" + idProceso + "' AND estado IN ('DETENIDA', 'CANCELADA')")) {
		MessageBox.critical(util.translate("scripts", "Reanudar proceso: Hubo un error al reanudar el proceso"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	if (!util.sqlUpdate("pr_procesos", "estado", "EN CURSO", "idproceso = '" + idProceso + "'")) {
		MessageBox.critical(util.translate("scripts", "Reanudar proceso: Hubo un error al reanudar el proceso"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	return true;
}

/** \D Inicia los elementos de seguimiento (procesos) de un formulario
@param	container: Formulario contenedor. Debe contener un groupBox con los controles a los que se hace referencia en la función
@param	datosS: Array con los siguientes datos<ul>
<li>tipoObjeto: Tipo de objeto relacionado con las tareas a mostrar<li/>
<li>idObjeto: Identificador del objeto<li/>
</ul>
@return	True se la iniciación se hace correctamente, false en caso contrario
\end */
function tareas_seguimientoOn(container:Object, datosS:Array):Boolean
{
	var util:FLUtil = new FLUtil;
	
	if (!container)
		return false;
	
	if (this.iface.container_)
		this.iface.seguimientoOff();

	if (this.iface.cursor_)
		delete this.iface.cursor_;
	

	this.iface.container_ = container;
	this.iface.cursor_ = this.iface.container_.child("tdbTareasS").cursor();;

	this.iface.tdbTareasS = this.iface.container_.child("tdbTareasS");
	this.iface.tbnDeshacerTareaS = this.iface.container_.child("tbnDeshacerTareaS");
	this.iface.tbnLanzarTareaS = this.iface.container_.child("tbnLanzarTareaS");
	this.iface.tbnEditTareaS = this.iface.container_.child("tbnEditTareaS");
	this.iface.tbnDeleteTareaS = this.iface.container_.child("tbnDeleteTareaS");

	this.iface.tbnVerTareaS = this.iface.container_.child("tbnVerTareaS");
	this.iface.tbnIniciarTareaS = this.iface.container_.child("tbnIniciarTareaS");

	this.iface.chkPteS = this.iface.container_.child("chkPteS");
	this.iface.chkEnCursoS = this.iface.container_.child("chkEnCursoS");
	this.iface.chkTerminadaS = this.iface.container_.child("chkTerminadaS");
	this.iface.chkMiasS = this.iface.container_.child("chkMiasS");
	this.iface.chkDeMiGrupoS = this.iface.container_.child("chkDeMiGrupoS");
	this.iface.chkSinAsignarS = this.iface.container_.child("chkSinAsignarS");
	this.iface.chkTodasS = this.iface.container_.child("chkTodasS");
	
	//this.iface.tdbTareasS.setReadOnly(true);
	if (this.iface.chkPteS)
		connect (this.iface.chkPteS, "clicked()", this, "iface.regenerarFiltroS()");
	if (this.iface.chkEnCursoS)
		connect (this.iface.chkEnCursoS, "clicked()", this, "iface.regenerarFiltroS()");
	if (this.iface.chkTerminadaS)
		connect (this.iface.chkTerminadaS, "clicked()", this, "iface.regenerarFiltroS()");
	if (this.iface.chkMiasS)
		connect (this.iface.chkMiasS, "clicked()", this, "iface.regenerarFiltroS()");
	if (this.iface.chkDeMiGrupoS)
		connect (this.iface.chkDeMiGrupoS, "clicked()", this, "iface.regenerarFiltroS()");
	if (this.iface.chkSinAsignarS)
		connect (this.iface.chkSinAsignarS, "clicked()", this, "iface.regenerarFiltroS()");
	if (this.iface.chkTodasS)
		connect (this.iface.chkTodasS, "clicked()", this, "iface.regenerarFiltroS()");
	
	if (this.iface.tbnLanzarTareaS)
		connect (this.iface.tbnLanzarTareaS, "clicked()", this, "iface.tbnLanzarTareaSClicked()");
	if (this.iface.tbnEditTareaS)
		connect (this.iface.tbnEditTareaS, "clicked()", this, "iface.tbnEditTareaSClicked()");
	if (this.iface.tbnDeleteTareaS)
		connect (this.iface.tbnDeleteTareaS, "clicked()", this, "iface.tbnDeleteTareaSClicked()");

	if (this.iface.tbnVerTareaS)
		connect (this.iface.tbnVerTareaS, "clicked()", this, "iface.tbnVerTareaSClicked()");
	if (this.iface.tbnIniciarTareaS)
		connect (this.iface.tbnIniciarTareaS, "clicked()", this, "iface.tbnIniciarTareaSClicked()");
	if (this.iface.tbnDeshacerTareaS)
		connect (this.iface.tbnDeshacerTareaS, "clicked()", this, "iface.tbnDeshacerTareaSClicked()");
	
	connect (this.iface.tdbTareasS, "currentChanged()", this, "iface.procesarEstadoS");


	this.iface.tipoObjeto_ = datosS["tipoObjeto"];
	this.iface.idObjeto_ = datosS["idObjeto"];
	this.iface.filtroFormulario_ = "";
	this.iface.valoresDefectoFiltroS();
	this.iface.regenerarFiltroS();
}

function tareas_seguimientoOff()
{
	if (!this.iface.container_)
		return;
/*
	disconnect (this.iface.chkPteS, "clicked()", this, "iface.regenerarFiltroS()");
	disconnect (this.iface.chkEnCursoS, "clicked()", this, "iface.regenerarFiltroS()");
	disconnect (this.iface.chkTerminadaS, "clicked()", this, "iface.regenerarFiltroS()");
	disconnect (this.iface.chkMiasS, "clicked()", this, "iface.regenerarFiltroS()");
	disconnect (this.iface.chkDeMiGrupoS, "clicked()", this, "iface.regenerarFiltroS()");
	disconnect (this.iface.chkSinAsignarS, "clicked()", this, "iface.regenerarFiltroS()");
	disconnect (this.iface.chkTodasS, "clicked()", this, "iface.regenerarFiltroS()");
	
	disconnect (this.iface.tbnLanzarTareaS, "clicked()", this, "iface.tbnLanzarTareaSClicked()");
	disconnect (this.iface.tbnEditTareaS, "clicked()", this, "iface.tbnEditTareaSClicked()");
	disconnect (this.iface.tbnDeleteTareaS, "clicked()", this, "iface.tbnDeleteTareaSClicked()");

	disconnect (this.iface.tbnVerTareaS, "clicked()", this, "iface.tbnVerTareaSClicked()");

	disconnect (this.iface.tbnIniciarTareaS, "clicked()", this, "iface.tbnIniciarTareaSClicked()");
	disconnect (this.iface.tbnDeshacerTareaS, "clicked()", this, "iface.tbnDeshacerTareaSClicked()");
	disconnect (this.iface.tdbTareasS, "currentChanged()", this, "iface.procesarEstadoS");
*/
}

/** \D Regenera el filtro en función de los criterios de búsqueda de tareas especificados por el usuario
\end */
function tareas_regenerarFiltroS()
{
	var filtro:String = "";
	if (this.iface.tipoObjeto_ != "todos") {
		filtro = "tipoobjeto = '" + this.iface.tipoObjeto_ + "' AND idobjeto = '" + this.iface.idObjeto_ + "'";
	}

	var filtroEs:String = this.iface.filtroEstadoS();
	if (filtroEs) {
		if (filtro != "") {
			filtro += " AND ";
		}
		filtro += filtroEs;
	}
	var filtroPro:String = this.iface.filtroPropietarioS();
	if (filtroPro) {
		if (filtro != "") {
			filtro += " AND ";
		}
		filtro += filtroPro;
	}
	
	if (this.iface.filtroFormulario_ && this.iface.filtroFormulario_ != "") {
		if (filtro != "") {
			filtro += " AND ";
		}
		filtro += this.iface.filtroFormulario_;
	}

	this.iface.tdbTareasS.cursor().setMainFilter(filtro);
	this.iface.tdbTareasS.refresh();
	this.iface.procesarEstadoS();
}

/** \D Construye la parte del filtro de tareas referente al estado
@return	Filtro
\end */
function tareas_filtroEstadoS():String
{
	if (!this.iface.chkPteS)
		return "1 = 1";
		
	var filtro:String = "";
	var listaEstados = "";
	if (this.iface.chkPteS && this.iface.chkPteS.checked)
		listaEstados += "'PTE'";

	if (this.iface.chkEnCursoS && this.iface.chkEnCursoS.checked) {
		if (listaEstados != "")
			listaEstados += ", ";
		listaEstados += "'EN CURSO'";
	}

	if (this.iface.chkTerminadaS && this.iface.chkTerminadaS.checked) {
		if (listaEstados != "")
			listaEstados += ", ";
		listaEstados += "'TERMINADA'";
	}
	if (listaEstados != "") {
		filtro = "estado IN (" + listaEstados + ")";
	} else {
		filtro = "1 = 2";
	}
	return filtro;
}


/** \D Construye la parte del filtro de tareas referente al propietario de las mismas
@return	Filtro
\end */
function tareas_filtroPropietarioS():String
{
	if (!this.iface.chkMiasS)
		return "1 = 1";
	
	var util:FLUtil = new FLUtil;
	var preFiltro:String = "(";
	var filtro:String = "";
	var idUsuario:String = sys.nameUser();
	var idGrupo:String = util.sqlSelect("flusers", "idgroup", "iduser = '" + idUsuario + "'");
	
	//Obtengo el valor del permiso (TRUE/FALSE)
	var permiso:Boolean = util.sqlSelect("flusers", "permiso", "iduser = '" +  idUsuario + "'");

	if (this.iface.chkMiasS && this.iface.chkMiasS.checked)
		preFiltro += "iduser = '" + idUsuario + "'";

	if (this.iface.chkDeMiGrupoS && this.iface.chkDeMiGrupoS.checked && idGrupo) {
		if (preFiltro != "(")
			preFiltro += " OR ";
		preFiltro += "idgroup = '" + idGrupo + "'";
	}

	if (this.iface.chkSinAsignarS && this.iface.chkSinAsignarS.checked) {
		if (preFiltro != "(")
			preFiltro += " OR ";
		preFiltro += "iduser IS NULL";
	}

	if (this.iface.chkTodasS && this.iface.chkTodasS.checked) {
	  preFiltro = "";
	}

	if (preFiltro == "")
		filtro = "";
	else if (preFiltro == "(")
		filtro = "1 = 2";
	else
		filtro = preFiltro + ")";

	return filtro;
}

function tareas_valoresDefectoFiltroS()
{
	if (this.iface.chkMiasS)
		this.iface.chkMiasS.checked = true;
	if (this.iface.chkPteS)
		this.iface.chkPteS.checked = true;
	if (this.iface.chkEnCursoS)
		this.iface.chkEnCursoS.checked = true;
	if (this.iface.tipoObjeto_ == "ase_casoscli") {
		this.iface.chkTerminadaS.checked = true;
		this.iface.chkTodasS.checked = true;
	}
}

/** \D
Si la tarea está en estado PTE, llama a iniciarTarea. Si está en estado EN CURSO, llama a terminarTarea
\end */
function tareas_tbnIniciarTareaSClicked(idUsuario:String):Boolean
{
	var util:FLUtil = new FLUtil;
	var ok:Boolean = true;
	if (!this.iface.cursor_.isValid()) {
		ok = false;
		return ok;
	}

	if (!idUsuario)
		idUsuario = sys.nameUser();
	if (!util.sqlSelect("flusers", "iduser", "iduser = '" + idUsuario + "'")) {
		MessageBox.warning(util.translate("scripts", "El usuario actual (%1) no está dado de alta en la tabla de usuarios del módulo de Administración.\nDebe dar de alta este usuario antes de realizar tareas con él.").arg(idUsuario), MessageBox.Ok, MessageBox.NoButton);
		ok = false;
		return ok;
	}
	var curTarea:FLSqlCursor = new FLSqlCursor("pr_tareas");
	curTarea.select("idtarea = '" + this.iface.cursor_.valueBuffer("idtarea") + "'");
	if (!curTarea.first()) {
		ok = false;
		return ok;
	}

	this.iface.cursor_.refreshBuffer();

	if (this.iface.cursor_.valueBuffer("estado") == "EN CURSO") {
		this.iface.cursor_.transaction(false);
		try {
			if (this.iface.terminarTarea(curTarea))
				this.iface.cursor_.commit();
			else
				this.iface.cursor_.rollback();
		} catch(e) {
			this.iface.cursor_.rollback();
			MessageBox.critical(util.translate("scripts", "Hubo un error en la finalización de la tarea:\n") + e, MessageBox.Ok, MessageBox.NoButton);
		}
	}
	if (this.iface.cursor_.valueBuffer("estado") == "PTE") {
		var unPaso:Boolean = util.sqlSelect("pr_tipostareapro", "terminaenunpaso", "idtipotareapro = " + curTarea.valueBuffer("idtipotareapro"));
		
		this.iface.cursor_.transaction(false);
		try {
			if (this.iface.iniciarTarea(curTarea, idUsuario))
				if (unPaso) {
					if (this.iface.terminarTarea(curTarea)) {
						this.iface.cursor_.commit();
					} else {
						this.iface.cursor_.rollback();
						ok = false;
					}
				} else {
					this.iface.cursor_.commit();
				}
			else {
				this.iface.cursor_.rollback();
				ok = false;
			}
		} catch(e) {
			ok = false;
			this.iface.cursor_.rollback();
			MessageBox.critical(util.translate("scripts", "Hubo un error en el inicio de la tarea:\n") + e, MessageBox.Ok, MessageBox.NoButton);
		}
	}
	this.iface.tdbTareasS.refresh();
	return ok;
}

/** \D
Pulsación del botón deshacer
\end */
function tareas_tbnDeshacerTareaSClicked():Boolean
{
	if (!this.iface.cursor_.isValid())
		return false;

	var util:FLUtil = new FLUtil;
	this.iface.tbnDeshacerTareaS.enabled = false;
	var estado:String = this.iface.cursor_.valueBuffer("estado");
	if (estado != "TERMINADA" && estado != "EN CURSO") {
		MessageBox.warning(util.translate("scripts", "La tarea debe estar en estado TERMINADA o EN CURSO"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
	var unPaso:Boolean = util.sqlSelect("pr_tipostareapro", "terminaenunpaso", "idtipotareapro = " + this.iface.cursor_.valueBuffer("idtipotareapro"));
	var ok:Boolean = true;
	try {
		this.iface.cursor_.transaction(false);
		if (estado == "TERMINADA") {
			if (!this.iface.deshacerTareaTerminada(this.iface.cursor_)) {
				this.iface.cursor_.rollback();
				ok = false;
			}
			if (unPaso) {
				if (!this.iface.deshacerTareaEnCurso(this.iface.cursor_)) {
					this.iface.cursor_.rollback();
					ok = false;
				}
			}
		} else if (estado == "EN CURSO") {
			if (!this.iface.deshacerTareaEnCurso(this.iface.cursor_)) {
				this.iface.cursor_.rollback();
				ok = false;
			}
		}
		if (ok)
			this.iface.cursor_.commit();
	} catch(e) {
		this.iface.cursor_.rollback();
		ok = false;
		MessageBox.critical(util.translate("scripts", "Hubo un error al deshacer la tarea:\n") + e, MessageBox.Ok, MessageBox.NoButton);
	}
	this.iface.tdbTareasS.refresh();
	return ok;
}

/** \D
Habilita el botón 'Deshacer tarea' si el estado de la tarea seleccionada es TERMINADA o EN CURSO
\end */
function tareas_procesarEstadoS()
{
	var estado:String = this.iface.cursor_.valueBuffer("estado");
	if (estado == "TERMINADA" || estado == "EN CURSO") {
		if (this.iface.tbnDeshacerTareaS)
			this.iface.tbnDeshacerTareaS.enabled = true;
	} else {
		if (this.iface.tbnDeshacerTareaS)
			this.iface.tbnDeshacerTareaS.enabled = false;
	}
	this.iface.establecerAccionTareaS();
}

function tareas_establecerAccionTareaS()
{
	var idTipoTarea:String = this.iface.cursor_.valueBuffer("idtipotarea");
	switch (idTipoTarea) {
		default: {
			this.iface.cursor_.setAction("pr_tareas");
		}
	}
}

function tareas_tbnLanzarTareaSClicked()
{
	var util:FLUtil = new FLUtil;
	var tipoProceso:String = this.iface.obtenerTipoProcesoS();
	if (!tipoProceso)
		return false;
	this.iface.crearProceso(tipoProceso, this.iface.tipoObjeto_, this.iface.idObjeto_);
	this.iface.tdbTareasS.refresh();
	
	MessageBox.warning(util.translate("scripts", "Tarea guardada correctamente"), MessageBox.Ok, MessageBox.NoButton);
}

function tareas_obtenerTipoProcesoS()
{
	var util:FLUtil = new FLUtil;
	var valor:String;
	switch (this.iface.tipoObjeto_) {
		case "clientes":
		case "crm_contactos":
		case "crm_tarjetas":
		case "crm_incidencias":
		case "ase_casoscli": {
			var qryProcesos:FLSqlQuery = new FLSqlQuery;
			with (qryProcesos) {
				setTablesList("pr_tiposproceso");
				setSelect("idtipoproceso, descripcion");
				setFrom("pr_tiposproceso");
				setWhere("accesiblecrm = true");
				setForwardOnly(true);
			}
			if (!qryProcesos.exec())
				return false;
			if (qryProcesos.size() < 1) {
				MessageBox.warning(util.translate("scripts", "No tiene definido ningún tipo de proceso como Accesible desde C.R.M.\nDebe crear y marcar los tipos de proceso que son accesibles desde el módulo C.R.M. en el módulo de procesos"), MessageBox.Ok, MessageBox.NoButton);
				return false;
			}
			var arrayProcesos:Array = [];
			var arrayOpciones:Array = [];
			while (qryProcesos.next()) {
				arrayProcesos[arrayProcesos.length] = qryProcesos.value("idtipoproceso");
				arrayOpciones[arrayOpciones.length] = qryProcesos.value("idtipoproceso") + " (" + qryProcesos.value("descripcion") + ")";
			}
			var procesoElegido:Number = this.iface.elegirOpcion(arrayOpciones);
			if (procesoElegido < 0)
				return false;
			valor = arrayProcesos[procesoElegido];
			break;
		}
		default: {
			var f:Object = new FLFormSearchDB("pr_tiposproceso");
			f.setMainWidget();
			valor = f.exec("idtipoproceso");
		}
	}
	return valor;
}

/** \D
Da a elegir al usuario entre una serie de opciones
@param	opciones: Array con las n opciones a elegir
@return	El índice de la opción elegida si se pulsa Aceptar
		-1 si se pulsa Cancelar
		-2 si hay error
\end */
function tareas_elegirOpcion(opciones:Array):Number
{
	var util:FLUtil = new FLUtil();
	var dialog:Dialog = new Dialog;
	dialog.okButtonText = util.translate("scripts","Aceptar");
	dialog.cancelButtonText = util.translate("scripts","Cancelar");
	var bgroup:GroupBox = new GroupBox;
	dialog.add(bgroup);
	var rB:Array = [];
	for (var i:Number = 0; i < opciones.length; i++) {
		rB[i] = new RadioButton;
		bgroup.add(rB[i]);
		rB[i].text = opciones[i];
		if (i == 0)
			rB[i].checked = true;
		else
			rB[i].checked = false;
	}

	if(dialog.exec()) {
		for (var i:Number = 0; i < opciones.length; i++)
			if (rB[i].checked == true)
				return i;
	} else
		return -1;
}

function tareas_tbnEditTareaSClicked()
{
	if (!this.iface.cursor_.isValid())
		return;
	
	this.iface.cursor_.editRecord();
}

function tareas_tbnDeleteTareaSClicked()
{
	var idProceso:String = this.iface.cursor_.valueBuffer("idproceso");
	if (!idProceso)
		return;
		
	this.iface.borrarProceso(idProceso);
	this.iface.tdbTareasS.refresh();
}

function tareas_tbnVerTareaSClicked()
{
	if (!this.iface.cursor_.isValid())
		return;
	
	this.iface.cursor_.browseRecord();
}

function tareas_filtroFormularioS(filtro:String)
{
	this.iface.filtroFormulario_ = filtro;
	this.iface.regenerarFiltroS();
}

/** \D Notifica vía email la asignación de una tarea a un usuario
@param	mensaje: Array con los datos del mensaje
@param	curTarea: Cursor posicionado en la tarea asignada
@return	True si la conexión se establece correctamente
|end */
function tareas_notificar(mensaje:Array):Boolean
{
	var util:FLUtil = new FLUtil;
	var dialogo = new Dialog;
	dialogo.okButtonText = util.translate("scripts", "Enviar");
	dialogo.cancelButtonText = util.translate("scripts", "Cancelar");

	var ledOrigen = new LineEdit;
	var emailOrigen:String;
	if (mensaje["usrorigen"]) {
		ledOrigen.label = util.translate("scripts", "De %1:").arg(mensaje["usrorigen"]);
		emailOrigen = util.sqlSelect("usuarios", "email", "idusuario = '" + mensaje["usrorigen"] + "'");
	} else {
		ledOrigen.label = util.translate("scripts", "De:");
		emailOrigen = util.sqlSelect("pr_config","emailnotificacion","1=1");
		if(!emailOrigen)
			emailOrigen = "noreplay@workflow_engine";
	}

	if (emailOrigen)
		ledOrigen.text = emailOrigen;
	dialogo.add(ledOrigen);

	var ledDestino = new LineEdit;
	var emailDestino:String;
	ledDestino.label = util.translate("scripts", "Para %1:").arg(mensaje["usrdestino"]);
	emailDestino = util.sqlSelect("usuarios", "email", "idusuario = '" + mensaje["usrdestino"] + "'");
	if (emailDestino)
		ledDestino.text = emailDestino;
	else
		ledDestino.text = mensaje["usrdestino"];
	dialogo.add(ledDestino);

	var ledAsunto = new LineEdit;
	ledAsunto.label = util.translate("scripts", "Asunto:");
	ledAsunto.text = mensaje["asunto"];
	dialogo.add(ledAsunto);

	var tedMensaje = new TextEdit;
	tedMensaje.text = mensaje["mensaje"];
	dialogo.add(tedMensaje);

	if (mensaje["editable"]) {
		if (!dialogo.exec())
			return true;
	}
	emailOrigen = ledOrigen.text;
	emailDestino = ledDestino.text;
	mensaje["asunto"] = ledAsunto.text;
	mensaje["mensaje"] = tedMensaje.text;
	
		var correo:FLSmtpClient = new FLSmtpClient;
	correo.setFrom(emailOrigen);
	correo.setTo(emailDestino);
	correo.setSubject(mensaje["asunto"]);
	correo.setBody(mensaje["mensaje"]);
	if (!File.exists(Dir.home + "/tmpMail.txt"))
		File.write(Dir.home + "/tmpMail.txt", "Archivo adjunto auxiliar");
	//var ficheroTonto = new File("tmpMail.txt");
	//correo.addAttachment(ficheroTonto.fullName);
	correo.addAttachment(Dir.home + "/tmpMail.txt");
	correo.startSend();
	if (mensaje["editable"]) {
		MessageBox.information(util.translate("scripts", "Mensaje enviado"), MessageBox.Ok, MessageBox.NoButton);
	}

	return true;
}

/** \D Inicia un array con los datos del mensaje
@return	array - mensaje
\end */
function tareas_initMensaje():Array
{
	var mensaje:Array = [];

	mensaje["usrorigen"] = false;
	mensaje["usrdestino"] = false;
	mensaje["cc"] = false;
	mensaje["asunto"] = false;
	mensaje["mensaje"] = false;
	mensaje["editable"] = false;
	
	return mensaje;
}

function tareas_procesarEvento(datosEvento:Array):Boolean
{
	return true; // Función a sobrecargar 
}

function tareas_actualizarTiempoTotal(tipoObjeto:String, idObjeto:String)
{
	var util:FLUtil = new FLUtil();
	var tiempo:Number = this.iface.calcularTiempo(tipoObjeto, idObjeto);
	if (isNaN(tiempo))
		return false;

	switch (tipoObjeto) {
		case "cl_subproyectos": {
			if (formRecordcl_subproyectos.child("fdbCodSubproyecto"))
				formRecordcl_subproyectos.child("fdbTiempoTotal").setValue(tiempo);
			else
				util.sqlUpdate("cl_subproyectos", "tiempototal", tiempo, "codsubproyecto = '" + idObjeto + "'");
			break;
		}
		case "cl_proyectos": {
			if (formRecordcl_proyectos.child("fdbCodProyecto"))
				formRecordcl_proyectos.child("fdbTiempoTotal").setValue(tiempo);
			else
				util.sqlUpdate("cl_proyectos", "tiempototal", tiempo, "codproyecto = '" + idObjeto + "'");
			break;
		}
	}
	return true;
}

function tareas_calcularTiempo(tipoObjeto:String, idObjeto:String):Number
{
	var util:FLUtil = new FLUtil();
	var total:Number;
	switch (tipoObjeto) {
		case "cl_subproyectos": {
			total = util.sqlSelect("pr_tareas", "SUM(tiempoinvertido)", "tipoobjeto = '" + tipoObjeto + "' AND idobjeto = '" + idObjeto + "'");
		
			if (isNaN(total))
				return false;
			break;
		}
		case "cl_proyectos": {
			var tiempoTareas:Number = util.sqlSelect("pr_tareas", "SUM(tiempoinvertido)", "tipoobjeto = '" + tipoObjeto + "' AND idobjeto = '" + idObjeto + "'");
			if (isNaN(tiempoTareas))
				return false;

			var tiempoSubp:Number = util.sqlSelect("cl_subproyectos", "SUM(tiempototal)", "codproyecto = '" + idObjeto + "'");
			if (isNaN(tiempoSubp))
				return false;

			total = parseFloat(tiempoTareas + tiempoSubp);
			break;
		}
	}
	return total;
}

function tareas_filtroFormularioS(filtro:String)
{
	this.iface.filtroFormulario_ = filtro;
	this.iface.regenerarFiltroS();
}
/** \D Regenera el filtro en función de los criterios de búsqueda de tareas especificados por el usuario
\end */
function tareas_regenerarFiltroS()
{
	var filtro:String = "";
	if (this.iface.tipoObjeto_ != "todos") {
		filtro = "tipoobjeto = '" + this.iface.tipoObjeto_ + "' AND idobjeto = '" + this.iface.idObjeto_ + "'";
	}

	var filtroEs:String = this.iface.filtroEstadoS();
	if (filtroEs) {
		if (filtro != "") {
			filtro += " AND ";
		}
		filtro += filtroEs;
	}
	var filtroPro:String = this.iface.filtroPropietarioS();
	if (filtroPro) {
		if (filtro != "") {
			filtro += " AND ";
		}
		filtro += filtroPro;
	}
	
	if (this.iface.filtroFormulario_ && this.iface.filtroFormulario_ != "") {
		if (filtro != "") {
			filtro += " AND ";
		}
		filtro += this.iface.filtroFormulario_;
	}
debug("Filtro = " + filtro);
	this.iface.tdbTareasS.cursor().setMainFilter(filtro);
	this.iface.tdbTareasS.refresh();
	this.iface.procesarEstadoS();
}
//// TAREAS /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
