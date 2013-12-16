/***************************************************************************
                 flfactppal.qs  -  description
                             -------------------
    begin                : lun abr 26 2004
    copyright            : (C) 2004-2006 by InfoSiAL S.L.
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
	function afterCommit_dirclientes(curDirCli:FLSqlCursor):Boolean {
		return this.ctx.interna_afterCommit_dirclientes(curDirCli);
	}
	function afterCommit_dirproveedores(curDirProv:FLSqlCursor):Boolean {
		return this.ctx.interna_afterCommit_dirproveedores(curDirProv);
	}
	function afterCommit_clientes(curCliente:FLSqlCursor):Boolean {
		return this.ctx.interna_afterCommit_clientes(curCliente);
	}
	function beforeCommit_clientes(curCliente:FLSqlCursor):Boolean {
		return this.ctx.interna_beforeCommit_clientes(curCliente);
	}
	function afterCommit_proveedores(curProveedor:FLSqlCursor):Boolean {
		return this.ctx.interna_afterCommit_proveedores(curProveedor);
	}
	function beforeCommit_proveedores(curProveedor:FLSqlCursor):Boolean {
		return this.ctx.interna_beforeCommit_proveedores(curProveedor);
	}
	function afterCommit_empresa(curEmpresa:FLSqlCursor):Boolean {
		return this.ctx.interna_afterCommit_empresa(curEmpresa);
	}
	function beforeCommit_cuentasbcocli(curCuenta:FLSqlCursor):Boolean {
		return this.ctx.interna_beforeCommit_cuentasbcocli(curCuenta);
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	function oficial( context ) { interna( context ); }
	function msgNoDisponible(nombreModulo:String) {
		return this.ctx.oficial_msgNoDisponible(nombreModulo);
	}
	function ejecutarQry(tabla:String, campos:String, where:String, listaTablas:String):Array {
		return this.ctx.oficial_ejecutarQry(tabla, campos, where, listaTablas);
	}
	function valorDefectoEmpresa(fN:String):String {
		return this.ctx.oficial_valorDefectoEmpresa(fN);
	}
	function cerosIzquierda(numero:String, totalCifras:Number):String {
		return this.ctx.oficial_cerosIzquierda(numero, totalCifras);
	}
	function espaciosDerecha(texto:String, totalLongitud:Number):String {
		return this.ctx.oficial_espaciosDerecha(texto, totalLongitud);
	}
	function valoresIniciales() {
		return this.ctx.oficial_valoresIniciales();
	}
	function valorQuery(tablas:String, select:String, from:String, where:String):Array {
		return this.ctx.oficial_valorQuery(tablas, select, from, where);
	}
	function crearSubcuenta(codSubcuenta:String, descripcion:String, idCuentaEsp:String, codEjercicio:String):Number {
		return this.ctx.oficial_crearSubcuenta(codSubcuenta, descripcion, idCuentaEsp, codEjercicio);
	}
	function borrarSubcuenta(idSubcuenta:String):Boolean {
		return this.ctx.oficial_borrarSubcuenta(idSubcuenta);
	}
	function ejercicioActual():String {
		return this.ctx.oficial_ejercicioActual();
	}
	function cambiarEjercicioActual(codEjercicio:String):Boolean {
		return this.ctx.oficial_cambiarEjercicioActual(codEjercicio);
	}
	function datosCtaCliente(codCliente:String, valoresDefecto:Array):Array {
		return this.ctx.oficial_datosCtaCliente(codCliente, valoresDefecto);
	}
	function datosCtaProveedor(codProveedor:String, valoresDefecto:Array):Array {
		return this.ctx.oficial_datosCtaProveedor(codProveedor, valoresDefecto);
	}
	function calcularIntervalo(codIntervalo:String):Array {
		return this.ctx.oficial_calcularIntervalo(codIntervalo);
	}
	function crearSubcuentaCli(codSubcuenta:String, idSubcuenta:Number, codCliente:String, codEjercicio:String):Boolean {
		return this.ctx.oficial_crearSubcuentaCli(codSubcuenta, idSubcuenta, codCliente, codEjercicio);
	}
	function rellenarSubcuentasCli(codCliente:String, codSubcuenta:String, nombre:String):Boolean {
		return this.ctx.oficial_rellenarSubcuentasCli(codCliente, codSubcuenta, nombre);
	}
	function crearSubcuentaProv(codSubcuenta:String, idSubcuenta:Number, codProveedor:String, codEjercicio:String):Boolean {
		return this.ctx.oficial_crearSubcuentaProv(codSubcuenta, idSubcuenta, codProveedor, codEjercicio);
	}
	function rellenarSubcuentasProv(codProveedor:String, codSubcuenta:String, nombre:String):Boolean {
		return this.ctx.oficial_rellenarSubcuentasProv(codProveedor, codSubcuenta, nombre);
	}
	function automataActivado():Boolean {
		return this.ctx.oficial_automataActivado();
	}
	function clienteActivo(codCliente:String, fecha:String):Boolean {
		return this.ctx.oficial_clienteActivo(codCliente, fecha);
	}
	function obtenerProvincia(formulario:Object, campoId:String, campoProvincia:String, campoPais:String) {
		return this.ctx.oficial_obtenerProvincia(formulario, campoId, campoProvincia, campoPais);
	}
	function actualizarContactos20070525():Boolean {
		return this.ctx.oficial_actualizarContactos20070525();
	}
	function lanzarEvento(cursor:FLSqlCursor, evento:String):Boolean {
		return this.ctx.oficial_lanzarEvento(cursor, evento);
	}
	function actualizarContactosDeAgenda20070525(codCliente:String,codContacto:String,nombreCon:String,cargoCon:String,telefonoCon:String,faxCon:String,emailCon:String,idAgenda:Number):String {
		return this.ctx.oficial_actualizarContactosDeAgenda20070525(codCliente,codContacto,nombreCon,cargoCon,telefonoCon,faxCon,emailCon,idAgenda)
	}
	function actualizarContactosProv20070702():Boolean {
		return this.ctx.oficial_actualizarContactosProv20070702();
	}
	function actualizarContactosDeAgendaProv20070702(codProveedor:String,codContacto:String,nombreCon:String,cargoCon:String,telefonoCon:String,faxCon:String,emailCon:String,idAgenda:Number):String {
		return this.ctx.oficial_actualizarContactosDeAgendaProv20070702(codProveedor,codContacto,nombreCon,cargoCon,telefonoCon,faxCon,emailCon,idAgenda)
	}
	function elegirOpcion(opciones:Array, titulo:String):Number {
		return this.ctx.oficial_elegirOpcion(opciones, titulo);
	}
	function crearProvinciasEsp(codPais:String) {
		return this.ctx.oficial_crearProvinciasEsp(codPais);
	}
	function textoFecha(fecha:String):String {
		return this.ctx.oficial_textoFecha(fecha);
	}
	function validarNifIva(nifIva:String):String {
		return this.ctx.oficial_validarNifIva(nifIva);
	}
	function ejecutarComandoAsincrono(comando:String):Array {
		return this.ctx.oficial_ejecutarComandoAsincrono(comando);
	}
	function globalInit() {
		return this.ctx.oficial_globalInit();
	}
	function existeEnvioMail():Boolean {
		return this.ctx.oficial_existeEnvioMail();
	}
	function validarProvincia(cursor:FLSqlCursor, mtd:Array):Boolean {
		return this.ctx.oficial_validarProvincia(cursor, mtd);
	}
  function  simplify(str)     { return this.ctx.oficial_simplify(str); }
  function  escapeQuote(str)  { return this.ctx.oficial_escapeQuote(str); }
    function calcularIBAN(cuenta, codPais) {
        return this.ctx.oficial_calcularIBAN(cuenta, codPais);
    }
    function digitoControlMod97(numero, codPais) {
        return this.ctx.oficial_digitoControlMod97(numero, codPais);
    }
    function moduloNumero(num, div) {
        return this.ctx.oficial_moduloNumero(num, div);
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
	function pub_msgNoDisponible(modulo:String) {
		return this.msgNoDisponible(modulo);
	}
	function pub_ejecutarQry(tabla:String, campos:String, where:String, listaTablas:String):Array {
		return this.ejecutarQry(tabla, campos, where, listaTablas);
	}
	function pub_valorDefectoEmpresa(fN:String):String {
		return this.valorDefectoEmpresa(fN);
	}
	function pub_valorQuery(tablas:String, select:String, from:String, where:String):String {
		return this.valorQuery(tablas, select, from, where);
	}
	function pub_cerosIzquierda(numero:String, totalCifras:Number):String {
		return this.cerosIzquierda(numero, totalCifras);
	}
	function pub_espaciosDerecha(texto:String, totalLongitud:Number):String {
		return this.espaciosDerecha(texto, totalLongitud);
	}
	function pub_ejercicioActual():String {
		return this.ejercicioActual();
	}
	function pub_cambiarEjercicioActual(codEjercicio:String):Boolean {
		return this.cambiarEjercicioActual(codEjercicio);
	}
	function pub_datosCtaCliente(codCliente:String, valoresDefecto:Array):Array {
		return this.datosCtaCliente(codCliente, valoresDefecto);
	}
	function pub_datosCtaProveedor(codProveedor:String, valoresDefecto:Array):Array {
		return this.datosCtaProveedor(codProveedor, valoresDefecto);
	}
	function pub_calcularIntervalo(codIntervalo:String):Array {
		return this.calcularIntervalo(codIntervalo);
	}
	function pub_crearSubcuenta(codSubcuenta:String, descripcion:String, idCuentaEsp:String, codEjercicio:String):Number {
		return this.crearSubcuenta(codSubcuenta, descripcion, idCuentaEsp, codEjercicio);
	}
	function pub_crearSubcuentaCli(codSubcuenta:String, idSubcuenta:Number, codCliente:String, codEjercicio:String):Boolean {
		return this.crearSubcuentaCli(codSubcuenta, idSubcuenta, codCliente, codEjercicio);
	}
	function pub_crearSubcuentaProv(codSubcuenta:String, idSubcuenta:Number, codProveedor:String, codEjercicio:String):Boolean {
		return this.crearSubcuentaProv(codSubcuenta, idSubcuenta, codProveedor, codEjercicio);
	}
	function pub_rellenarSubcuentasCli(codCliente:String, codSubcuenta:String, nombre:String):Boolean {
		return this.rellenarSubcuentasCli(codCliente, codSubcuenta, nombre);
	}
	function pub_rellenarSubcuentasProv(codProveedor:String, codSubcuenta:String, nombre:String):Boolean {
		return this.rellenarSubcuentasProv(codProveedor, codSubcuenta, nombre);
	}
	function pub_automataActivado():Boolean {
		return this.automataActivado();
	}
	function pub_clienteActivo(codCliente:String, fecha:String):Boolean {
		return this.clienteActivo(codCliente, fecha);
	}
	function pub_obtenerProvincia(formulario:Object, campoId:String, campoProvincia:String, campoPais:String) {
		return this.obtenerProvincia(formulario, campoId, campoProvincia, campoPais);
	}
	function pub_lanzarEvento(cursor:FLSqlCursor, evento:String):Boolean {
		return this.lanzarEvento(cursor, evento);
	}
	function pub_elegirOpcion(opciones:Array, titulo:String):Number {
		return this.elegirOpcion(opciones, titulo);
	}
	function pub_textoFecha(fecha:String):String {
		return this.textoFecha(fecha);
	}
	function pub_validarNifIva(nifIva:String):String {
		return this.validarNifIva(nifIva);
	}
	function pub_ejecutarComandoAsincrono(comando:String):Array {
		return this.ejecutarComandoAsincrono(comando);
	}
	function pub_globalInit() {
		return this.globalInit();
	}
	function pub_existeEnvioMail():Boolean {
		return this.existeEnvioMail();
	}
	function pub_crearProvinciasEsp(codPais:String) {
		return this.crearProvinciasEsp(codPais);
	}
	function pub_validarProvincia(cursor:FLSqlCursor, mtd:Array):Boolean {
		return this.validarProvincia(cursor, mtd);
	}
  function pub_simplify(str)     { return this.simplify(str); }
  function pub_escapeQuote(str)  { return this.escapeQuote(str); }
    function pub_calcularIBAN(cuenta, codPais) {
        return this.calcularIBAN(cuenta, codPais);
    }
    function pub_digitoControlMod97(numero, codPais) {
        return this.digitoControlMod97(numero, codPais);
    }
    function pub_moduloNumero(num, div) {
        return this.moduloNumero(num, div);
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
	var util:FLUtil = new FLUtil();

// -------------------------------- 20070525 -------------------------------------
	var condicion:String = util.sqlSelect("clientes", "codcliente", "(codcontacto = '' OR codcontacto IS NULL) AND (contacto <> '' AND contacto IS NOT NULL)");
	var condicionProv:String = util.sqlSelect("proveedores", "codproveedor", "(codcontacto = '' OR codcontacto IS NULL) AND (contacto <> '' AND contacto IS NOT NULL)");

	if (condicion) {
		var cursor:FLSqlCursor = new FLSqlCursor("clientes");
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
			MessageBox.warning(util.translate("scripts", "Hubo un error al actualizar los datos de contactos del módulo de Facturación:\n" + e), MessageBox.Ok, MessageBox.NoButton);
		}
	}

	if (condicionProv) {
		var cursor:FLSqlCursor = new FLSqlCursor("proveedores");
		cursor.transaction(false);
		try {
			if (this.iface.actualizarContactosProv20070702()) {
				cursor.commit();
			} else {
				cursor.rollback();
			}
		}
		catch (e) {
			cursor.rollback();
			MessageBox.warning(util.translate("scripts", "Hubo un error al actualizar los datos de contactos del módulo de Facturación:\n" + e), MessageBox.Ok, MessageBox.NoButton);
		}
	}
//-------------------------------- 20070525 -------------------------------------

	if (util.sqlSelect("empresa", "id", "1 = 1"))
		return;
	
	var cursor:FLSqlCursor = new FLSqlCursor("empresa");
	cursor.select();
	if (!cursor.first()) {
		MessageBox.information(util.translate("scripts",
			"Se insertará una empresa por defecto y algunos valores iniciales para empezar a trabajar."),
			MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		this.iface.valoresIniciales();
		this.execMainScript("empresa");
	}
}

function interna_afterCommit_dirclientes(curDirCli:FLSqlCursor):Boolean
{
	if (curDirCli.modeAccess() == curDirCli.Del) {
		var domFact:String = curDirCli.valueBuffer("domfacturacion");
		var domEnv:String = curDirCli.valueBuffer("domenvio");
		if (domFact == true || domEnv == true) {
			var cursor:FLSqlCursor = new FLSqlCursor("dirclientes");
			cursor.select("codcliente = '" + curDirCli.valueBuffer("codcliente") + "' AND id <> " + curDirCli.valueBuffer("id"));
			if (cursor.first()) {
				cursor.setModeAccess(cursor.Edit);
				cursor.refreshBuffer();
				if (domFact == true)
					cursor.setValueBuffer("domfacturacion", domFact);
				if (domEnv == true)
					cursor.setValueBuffer("domenvio", domEnv);
				cursor.commitBuffer();
			}
		}
	}
	return true;
}

function interna_afterCommit_dirproveedores(curDirProv:FLSqlCursor):Boolean
{
	if (curDirProv.modeAccess() == curDirProv.Del) {
		var dirPpal:String = curDirProv.valueBuffer("direccionppal");
		if (dirPpal == true) {
			var cursor:FLSqlCursor = new FLSqlCursor("dirproveedores");
			cursor.select("codproveedor = '" + curDirProv.valueBuffer("codproveedor") + "' AND id <> " + curDirProv.valueBuffer("id"));
			if (cursor.first()) {
				cursor.setModeAccess(cursor.Edit);
				cursor.refreshBuffer();
				cursor.setValueBuffer("direccionppal", dirPpal);
				cursor.commitBuffer();
			}
		}
	}
	return true;
}

function interna_afterCommit_clientes(curCliente:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	if (!sys.isLoadedModule("flcontppal"))
		return true;

	var codSubcuenta:String = curCliente.valueBuffer("codsubcuenta");
	var idSubcuenta:Number = parseFloat(curCliente.valueBuffer("idsubcuenta"));
	var codCliente:String = curCliente.valueBuffer("codcliente");
	var idSubcuentaPrevia:Number = parseFloat(curCliente.valueBufferCopy("idsubcuenta"));
	
	switch(curCliente.modeAccess()) {
	/** \C Cuando el cliente se crea, se generan automáticamente las subcuentas para dicho cliente asociadas a los ejercicios con plan general contable creado.
	\end */
		case curCliente.Insert: {
			if (!this.iface.rellenarSubcuentasCli(codCliente, codSubcuenta, curCliente.valueBuffer("nombre")))
				return false;
			break;
		}
		/*
		case curCliente.Del: {
			if (!curCliente.isNull("idsubcuenta")) {
				if (!util.sqlSelect("clientes", "idsubcuenta", "idsubcuenta = " + idSubcuentaPrevia + " AND codcliente <> '" + codCliente + "'")) {
					if (!this.iface.borrarSubcuenta(idSubcuenta))
						return false;
				}
			}
			break;
		}
		*/
	}
	return true;
}

function interna_afterCommit_proveedores(curProveedor:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	if (!sys.isLoadedModule("flcontppal"))
		return true;

	var codSubcuenta:String = curProveedor.valueBuffer("codsubcuenta");
	var idSubcuenta:Number = parseFloat(curProveedor.valueBuffer("idsubcuenta"));
	var codProveedor:String = curProveedor.valueBuffer("codproveedor");
	var idSubcuentaPrevia:Number = parseFloat(curProveedor.valueBufferCopy("idsubcuenta"));

	switch(curProveedor.modeAccess()) {
		/** \C Cuando el proveedor se crea, se generan automáticamente las subcuentas para dicho proveedor asociadas a los ejercicios con plan general contable creado.
		\end */
		case curProveedor.Insert: {
			if (!this.iface.rellenarSubcuentasProv(codProveedor, codSubcuenta, curProveedor.valueBuffer("nombre")))
				return false;
			break;
		}
		/*
		case curProveedor.Del: {
			if (!curProveedor.isNull("idsubcuenta")) {
				if (!util.sqlSelect("proveedores", "idsubcuenta", "idsubcuenta = " + idSubcuentaPrevia + " AND codcliente <> '" + codProveedor + "'")) {
					if (!this.iface.borrarSubcuenta(idSubcuenta))
						return false;
				}
			}
			break;
		}
		*/
	}
	return true;
}

function interna_beforeCommit_proveedores(curProveedor:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	if (!sys.isLoadedModule("flcontppal"))
		return true;

	switch(curProveedor.modeAccess()) {
		/** \C Cuando el proveedor se borra, se borran las subcuentas asociadas si éstas no tienen partidas asociadas ni están vinculadas con otro proveedor
		\end */
		case curProveedor.Del: {
			var qrySubcuentas:FLSqlQuery = new FLSqlQuery();
			qrySubcuentas.setTablesList("co_subcuentasprov,co_subcuentas");
			qrySubcuentas.setSelect("s.codsubcuenta,s.descripcion,s.codejercicio,s.saldo,s.idsubcuenta");
			qrySubcuentas.setFrom("co_subcuentasprov sp INNER JOIN co_subcuentas s ON sp.idsubcuenta = s.idsubcuenta")
			qrySubcuentas.setWhere("sp.codproveedor = '" + curProveedor.valueBuffer("codproveedor") + "'");
			try { qrySubcuentas.setForwardOnly( true ); } catch (e) {}
			if (!qrySubcuentas.exec())
				return false;

			var idSubcuenta:String;
			while (qrySubcuentas.next()) {
				idSubcuenta = qrySubcuentas.value("s.idsubcuenta"); 
				if (parseFloat(qrySubcuentas.value("s.saldo")) != 0)
					continue; 
				if (util.sqlSelect("co_partidas", "idpartida", "idsubcuenta = " + idSubcuenta))
					continue;
				if (util.sqlSelect("co_subcuentasprov", "idsubcuenta", "idsubcuenta = " + idSubcuenta + " AND codproveedor <> '" + curProveedor.valueBuffer("codproveedor") + "'"))
					continue;
				if (!util.sqlDelete("co_subcuentas", "idsubcuenta = " + idSubcuenta))
					return false;
			}
		}
	}
	return true;
}

function interna_beforeCommit_clientes(curCliente:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	if (!sys.isLoadedModule("flcontppal"))
		return true;

	switch(curCliente.modeAccess()) {
		/** \C Cuando el cliente se borra, se borran las subcuentas asociadas si éstas no tienen partidas asociadas ni están vinculadas con otro cliente
		\end */
		case curCliente.Del: {
			var qrySubcuentas:FLSqlQuery = new FLSqlQuery();
			qrySubcuentas.setTablesList("co_subcuentascli,co_subcuentas");
			qrySubcuentas.setSelect("s.codsubcuenta,s.descripcion,s.codejercicio,s.saldo,s.idsubcuenta");
			qrySubcuentas.setFrom("co_subcuentascli sc INNER JOIN co_subcuentas s ON sc.idsubcuenta = s.idsubcuenta")
			qrySubcuentas.setWhere("sc.codcliente = '" + curCliente.valueBuffer("codcliente") + "'");
			try { qrySubcuentas.setForwardOnly( true ); } catch (e) {}
			if (!qrySubcuentas.exec())
				return false;
			
			var idSubcuenta:String;
			while (qrySubcuentas.next()) {
				idSubcuenta = qrySubcuentas.value("s.idsubcuenta"); 
				if (parseFloat(qrySubcuentas.value("s.saldo")) != 0)
					continue; 
				if (util.sqlSelect("co_partidas", "idpartida", "idsubcuenta = " + idSubcuenta))
					continue;
				if (util.sqlSelect("co_subcuentascli", "idsubcuenta", "idsubcuenta = " + idSubcuenta + " AND codcliente <> '" + curCliente.valueBuffer("codcliente") + "'"))
					continue;
				if (!util.sqlDelete("co_subcuentas", "idsubcuenta = " + idSubcuenta))
					return false;
			}
		}
	}
	return true;
}

/** \C Cuando cambia el ejercicio actual se establece el título de las ventanas principales con
el nombre del ejercicio seleccionado
\end */
/** \D Cuando cambia el ejercicio actual se establece una variable global (ver FLVar) con el código
del ejercicio seleccionado. El nombre de esta variable está fomado por el literal "ejerUsr_" seguido
del nombre del usuario actual obtenido con la función sys.nameUser(). Esto significa que por cada usuario
se almacena el ejercicio en el que se encuentra.
\end */
function interna_afterCommit_empresa(curEmpresa:FLSqlCursor):Boolean {
	/*
	var util:FLUtil = new FLUtil();
	var codejercicio:String = curEmpresa.valueBuffer( "codejercicio" );
	var nombreEjercicio:String = util.sqlSelect( "ejercicios", "nombre", "codejercicio='" + codejercicio + "'" );
	sys.setCaptionMainWidget( nombreEjercicio );

	var ejerUsr:FLVar = new FLVar();
	var idVar:String = "ejerUsr_" + sys.nameUser();
	ejerUsr.set( idVar, codejercicio );
	*/
}

function interna_beforeCommit_cuentasbcocli(curCuenta:FLSqlCursor):Boolean
{
	/** \C No se permite borrar la cuenta de un cliente si tiene recibos pendientes de pago asociados a dicha cuenta
	\end */
	switch(curCuenta.modeAccess()) {
	
		case curCuenta.Del:
			var util:FLUtil = new FLUtil;
			var codRecibo:String = util.sqlSelect("reciboscli", "codigo", "codcliente = '" + curCuenta.valueBuffer("codcliente") + "' AND codcuenta = '" + curCuenta.valueBuffer("codcuenta") + "' AND estado <> 'Pagado'");
			if (codRecibo && codRecibo != "") {
				MessageBox.warning(util.translate("scripts", "No puede eliminar la cuenta del cliente porque hay al menos un recibo (%1) pendiente de pago asociado a esta cuenta.\nDebe cambiar la cuenta de los recibos pendientes de este cliente antes de borrarla.").arg(codRecibo), MessageBox.Ok, MessageBox.NoButton);
				return false;
			}
		break;
	}
	return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_msgNoDisponible(nombreModulo:String)
{
	var util:FLUtil = new FLUtil();
	MessageBox.information(util.translate("scripts", "El módulo '") +
		nombreModulo + util.translate("scripts",
		"' no está disponible."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
}

/** \D Ejecuta la query especificada y devuelve un array con los datos de los campos seleccionados. Devuelve un campo extra 'result' que es 1 = Ok, 0 = Error, -1 No encontrado
@param	tabla: Nombre de la tabla
@param	campos: Nombre de los campos, separados por comas
@param	where: Cláusula where
@param	listaTablas: Lista de las tablas empleadas en la consulta. Este parámetro es opcional y se usa si la consulta afecta a más de una tabla.
@return	Array con los valores de los campos solicitados, más el campo result.
\end */
function oficial_ejecutarQry(tabla:String, campos:String, where:String, listaTablas:String):Array
{
	var util:FLUtil = new FLUtil;
	var campo:Array = campos.split(",");
	var valor:Array = [];
	valor["result"] = 1;
	var query:FLSqlQuery = new FLSqlQuery();
	if (listaTablas)
		query.setTablesList(listaTablas);
	else
		query.setTablesList(tabla);
	try { query.setForwardOnly( true ); } catch (e) {}
	query.setSelect(campo);
	query.setFrom(tabla);
	query.setWhere(where);
	if (query.exec()) {
		if (query.next()) {
			for (var i:Number = 0; i < campo.length; i++) {
				valor[campo[i]] = query.value(i);
			}
		} else {
			valor.result = -1;
		}
	} else {
		MessageBox.critical(util.translate("scripts", "Falló la consulta") + query.sql(),
			MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		valor.result = 0;
	}

	return valor;
}

function oficial_valorDefectoEmpresa(fN:String):String
{
	var query:FLSqlQuery = new FLSqlQuery();

	query.setTablesList( "empresa" );
	try { query.setForwardOnly( true ); } catch (e) {}
	query.setSelect( fN );
	query.setFrom( "empresa" );
	if ( query.exec() )
		if ( query.next() )
			return query.value( 0 );

	return "";
}

/** \D Devuelve el ejercicio actual para el usuario conectado
@return	codEjercicio: Código del ejercicio actual
\end */
function oficial_ejercicioActual():String
{
	var util:FLUtil = new FLUtil;
	var codEjercicio:String 
	try {
		var settingKey:String = "ejerUsr_" + sys.nameUser();
		codEjercicio = util.readDBSettingEntry(settingKey);
		/*if (!codEjercicio)
			codEjercicio = this.iface.cambiarEjercicioActual(this.iface.valorDefectoEmpresa("codejercicio"));*/
	}
	catch ( e ) {}
	
	if (!codEjercicio)
		codEjercicio = this.iface.valorDefectoEmpresa("codejercicio");
	
	return codEjercicio;
}

/** \D Establece el ejercicio actual para el usuario conectado
Cuando cambia el ejercicio actual se establece un setting de base de datos (tabla flsettings) con el código
del ejercicio seleccionado. El nombre de esta variable está fomado por el literal "ejerUsr_" seguido
del nombre del usuario actual obtenido con la función sys.nameUser(). Esto significa que por cada usuario
se almacena el ejercicio en el que se encuentra.

@param	codEjercicio: Código del ejercicio actual
@return	true si la asignación del ejercicio se realizó correctamente, false en caso contrario
\end */
function oficial_cambiarEjercicioActual(codEjercicio:String):Boolean
{
	var util:FLUtil = new FLUtil();
	var ok:Boolean = false;
	
	try {
		var settingKey:String = "ejerUsr_" + sys.nameUser();
		ok = util.writeDBSettingEntry(settingKey, codEjercicio);
	}
	catch (e) {}
	
	return ok;
}

function oficial_cerosIzquierda(numero:String, totalCifras:Number):String
{
	var ret:String = numero.toString();
	var numCeros:Number = totalCifras - ret.length;
	for ( ; numCeros > 0 ; --numCeros)
		ret = "0" + ret;
	return ret;
}

function oficial_espaciosDerecha(texto:String, totalLongitud:Number):String
{
	var ret:String = texto.toString();
	var numEspacios:Number = totalLongitud - ret.length;
	for ( ; numEspacios > 0 ; --numEspacios)
		ret += " ";
	return ret;
}

function oficial_valoresIniciales()
{
	var cursor:FLSqlCursor = new FLSqlCursor("bancos");
	var bancos:Array =
		[["0019", "DEUTSCHE BANK"],["0049", "BANCO SANTANDER"],
		["0061", "BANCA MARCH"],["0065", "BARCLAYS BANK"],
		["0073", "OPEN BANK"],["0075", "BANCO POPULAR"],
		["0081", "BANCO DE SABADELL"],["0128", "BANKINTER"],
		["0138", "BANKOA"],["0182", "BANCO BILBAO VIZCAYA ARGENTARIA"],
		["0487", "BANCO MARE NOSTRUM"],["2013", "CATALUNYA BANC"],
		["2038", "BANKIA"],["2048", "LIBERBANK"],
		["2080", "NCG BANCO"],["2085", "IBERCAJA BANCO"],
		["2095", "KUTXABANK"],["2100", "CAIXABANK"],
		["2103", "UNICAJA BANCO"],["2108", "BANCO CEISS"]];
	for (var i:Number = 0; i < bancos.length; i++) {
		with(cursor) {
			setModeAccess(cursor.Insert);
			refreshBuffer();
			setValueBuffer("entidad", bancos[i][0]);
			setValueBuffer("nombre", bancos[i][1]);
			commitBuffer();
		}
	}
	delete cursor;

	cursor = new FLSqlCursor("impuestos");
	with(cursor) {
		setModeAccess(cursor.Insert);
		refreshBuffer();
		setValueBuffer("codimpuesto", "GEN");
		setValueBuffer("descripcion", "I.V.A. General");
		setValueBuffer("iva", "21");
		setValueBuffer("recargo", "5.2");
		commitBuffer();
		setModeAccess(cursor.Insert);
		refreshBuffer();
		setValueBuffer("codimpuesto", "RED");
		setValueBuffer("descripcion", "I.V.A. Reducido");
		setValueBuffer("iva", "10");
		setValueBuffer("recargo", "1.4");
		commitBuffer();
		setModeAccess(cursor.Insert);
		refreshBuffer();
		setValueBuffer("codimpuesto", "SRED");
		setValueBuffer("descripcion", "I.V.A. Superreducido");
		setValueBuffer("iva", "4");
		setValueBuffer("recargo", "0.5");
		commitBuffer();
	}
	delete cursor;

	cursor = new FLSqlCursor("paises");
	with(cursor) {
		setModeAccess(cursor.Insert);
		refreshBuffer();
		setValueBuffer("codpais", "ES");
		setValueBuffer("nombre", "ESPAÑA");
        setValueBuffer("bandera", "/* XPM */\nstatic char * esp_xpm[] = {\n\"30 16 16 1\",\n\"  c #6C1E04\",\n\".	c #B78B19\",\n\"+	c #E4D31A\",\n\"@	c #8E4F09\",\n\"#	c #FBFC05\",\n\"$	c #EF0406\",\n\"%	c #F9978D\",\n\"&	c #FCFA36\",\n\"*	c #FC595C\",\n\"=	c #E1B025\",\n\"-	c #FB3634\",\n\";	c #E67559\",\n\">	c #A26E13\",\n\",	c #FCACAC\",\n\"'	c #B29F19\",\n\")	c #9D0204\",\n\",,%%%%%%%%%%%%%%%%%%%%%%%%%%;$\",\n\";;**************************$)\",\n\"--$$$$$$$$$$$$$$$$$$$$$$$$$$$)\",\n\"--$$$$$$$$$$$$$$$$$$$$$$$$$$$)\",\n\"&&####&#&++&################+'\",\"&&####&=.>..&###############+'\",\n\"&&####@=@@@=>=##############+'\",\n\"&&####='>;>%=+&#############+'\",\n\"&&####@@@ @>>.##############+'\",\n\"&&####.=>@;;#;##############+'\",\"&&+###>..>..>=##############+'\",\n\"&&####.+===+.+&#############+.\",\n\"--$$$$$$$$$$$$$$$$$$$$$$$$$$$)\",\n\"--$$$$$$$$$$$$$$$$$$$$$$$$$$$)\",\n\"$$$)$)$)$))$)$)$)$)$)$)$)$)$))\",\n\"))))))))))))))))))))))))))))))\"};\n");
		setValueBuffer("codiso", "ES");
		commitBuffer();
	}
	delete cursor;

	cursor = new FLSqlCursor("divisas");
	with(cursor) {
		setModeAccess(cursor.Insert);
		refreshBuffer();
		setValueBuffer("coddivisa", "EUR");
		setValueBuffer("descripcion", "EUROS");
		setValueBuffer("tasaconv", "1");
		setValueBuffer("codiso", "978");
		commitBuffer();
		setModeAccess(cursor.Insert);
		refreshBuffer();
		setValueBuffer("coddivisa", "USD");
		setValueBuffer("descripcion", "DÓLARES USA");
		setValueBuffer("tasaconv", "0.845");
		setValueBuffer("codiso", "849");
		commitBuffer();
		setModeAccess(cursor.Insert);
		refreshBuffer();
		setValueBuffer("coddivisa", "GBP");
		setValueBuffer("descripcion", "LIBRAS ESTERLINAS");
		setValueBuffer("tasaconv", "1.48");
		setValueBuffer("codiso", "826");
		commitBuffer();
		setModeAccess(cursor.Insert);
		refreshBuffer();
		setValueBuffer("coddivisa", "CHF");
		setValueBuffer("descripcion", "FRANCOS SUIZOS");
		setValueBuffer("tasaconv", "0.648");
		setValueBuffer("codiso", "756");
		commitBuffer();
		setModeAccess(cursor.Insert);
		refreshBuffer();
		setValueBuffer("coddivisa", "SEK");
		setValueBuffer("descripcion", "CORONAS SUECAS");
		setValueBuffer("tasaconv", "0.106");
		setValueBuffer("codiso", "752");
		commitBuffer();
		setModeAccess(cursor.Insert);
		refreshBuffer();
		setValueBuffer("coddivisa", "NOK");
		setValueBuffer("descripcion", "CORONAS NORUEGAS");
		setValueBuffer("tasaconv", "0.126");
		setValueBuffer("codiso", "578");
		commitBuffer();
		setModeAccess(cursor.Insert);
		refreshBuffer();
		setValueBuffer("coddivisa", "NZD");
		setValueBuffer("descripcion", "DÓLARES NEOZELANDESES");
		setValueBuffer("tasaconv", "0.608");
		setValueBuffer("codiso", "554");
		commitBuffer();
		setModeAccess(cursor.Insert);
		refreshBuffer();
		setValueBuffer("coddivisa", "JPY");
		setValueBuffer("descripcion", "YENES JAPONESES");
		setValueBuffer("tasaconv", "0.007");
		setValueBuffer("codiso", "392");
		commitBuffer();
		setModeAccess(cursor.Insert);
		refreshBuffer();
		setValueBuffer("coddivisa", "DKK");
		setValueBuffer("descripcion", "CORONAS DANESAS");
		setValueBuffer("tasaconv", "0.134");
		setValueBuffer("codiso", "208");
		commitBuffer();
		setModeAccess(cursor.Insert);
		refreshBuffer();
		setValueBuffer("coddivisa", "CAD");
		setValueBuffer("descripcion", "DÓLARES CANADIENSES");
		setValueBuffer("tasaconv", "0.735");
		setValueBuffer("codiso", "124");
		commitBuffer();
		setModeAccess(cursor.Insert);
		refreshBuffer();
		setValueBuffer("coddivisa", "AUD");
		setValueBuffer("descripcion", "DÓLARES AUSTRALIANOS");
		setValueBuffer("tasaconv", "0.639");
		setValueBuffer("codiso", "036");
		commitBuffer();
	}
	delete cursor;

	cursor = new FLSqlCursor("formaspago");
	with(cursor) {
		setModeAccess(cursor.Insert);
		refreshBuffer();
		setValueBuffer("codpago", "CONT");
		setValueBuffer("descripcion", "CONTADO");
		commitBuffer();
	}
	delete cursor;

	cursor = new FLSqlCursor("plazos");
	with(cursor) {
		setModeAccess(cursor.Insert);
		refreshBuffer();
		setValueBuffer("codpago", "CONT");
		setValueBuffer("dias", "0");
		setValueBuffer("aplazado", "100");
		commitBuffer();
	}
	delete cursor;

	cursor = new FLSqlCursor("ejercicios");
	var hoy:Date = new Date()
	var fechaInicio:Date = new Date(hoy.getYear(), 1, 1);
	var fechaFin:Date = new Date(hoy.getYear(), 12, 31);
	var codEjercicio:String = hoy.getYear();
	with(cursor) {
		setModeAccess(cursor.Insert);
		refreshBuffer();
		setValueBuffer("codejercicio", codEjercicio);
		setValueBuffer("nombre", "EJERCICIO " + codEjercicio);
		setValueBuffer("fechainicio", fechaInicio);
		setValueBuffer("fechafin", fechaFin);
		setValueBuffer("estado", "ABIERTO");
		commitBuffer();
	}
	delete cursor;

	this.iface.cambiarEjercicioActual( codEjercicio );

	cursor = new FLSqlCursor("series");
	with(cursor) {
		setModeAccess(cursor.Insert);
		refreshBuffer();
		setValueBuffer("codserie", "A");
		setValueBuffer("descripcion", "SERIE A");
		commitBuffer();
	}
	delete cursor;

	cursor = new FLSqlCursor("secuenciasejercicios");
	var idSec:Number;
	with(cursor) {
		setModeAccess(cursor.Insert);
		refreshBuffer();
		setValueBuffer("codserie", "A");
		setValueBuffer("codejercicio", codEjercicio);
		idSec = valueBuffer( "id" );
		commitBuffer();
	}
	delete cursor;

	cursor = new FLSqlCursor("secuencias");
	with(cursor) {
		setModeAccess(cursor.Insert);
		refreshBuffer();
		setValueBuffer("id", idSec);
		setValueBuffer("nombre", "nfacturacli");
		setValueBuffer("valor", 1);
		commitBuffer();
		setModeAccess(cursor.Insert);
		refreshBuffer();
		setValueBuffer("id", idSec);
		setValueBuffer("nombre", "nfacturaprov");
		setValueBuffer("valor", 1);
		commitBuffer();
	}
	delete cursor;
	
	cursor = new FLSqlCursor("empresa");
        cursor.setActivatedCheckIntegrity(false);
	var milogo:String = "";
	milogo+='/* XPM */\n';
	milogo+='static char * logo_xpm[] = {\n';
	milogo+='"50 16 7 1",\n';
	milogo+='" 	c #1E00FF",\n';
	milogo+='".	c #FF0000",\n';
	milogo+='"+	c #FF00FF",\n';
	milogo+='"@	c #18FF00",\n';
	milogo+='"#	c #33FFFF",\n';
	milogo+='"$	c #FFFF00",\n';
	milogo+='"%	c #FFFFFF",\n';
	milogo+='"%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%",\n';
	milogo+='"%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%",\n';
	milogo+='"%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%",\n';
	milogo+='"%%$%%%%%%%%%%%%%%%%%%%%%%%%%% %%% %%%%%%%%%%%%%%%%",\n';
	milogo+='"%%.%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%",\n';
	milogo+='"%%.%%%%%%@@@%%%@@@@@%%%   %%    % %%   ++%%%...%%%",\n';
	milogo+='"%%.%%%%%$%%%@%%@%%%@%%#%%% %% %%% %% %%%+%%.%%%.%%",\n';
	milogo+='"%%.%%%%%$%%%@%%@%%%@%%#%%% %% %%% %% %%% %%+%%%.%%",\n';
	milogo+='"%%.%%%%%$%%%@%%@%%%@%%@%%%#%% %%% %% %%% %%+%%%.%%",\n';
	milogo+='"%%.%%%%%.%%%$%%@%%%@%%@%%%#%%#%%% %% %%% %% %%%+%%",\n';
	milogo+='"%%.....%%.$$%%%%@@@@%%%@@@%%%## % %%     %%%  +%%%",\n';
	milogo+='"%%%%%%%%%%%%%%%%%%%@%%%%%%%%%%%%%%%% %%%%%%%%%%%%%",\n';
	milogo+='"%%%%%%%%%%%%%%%$$$$%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%",\n';
	milogo+='"%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%",\n';
	milogo+='"%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%",\n';
	milogo+='"%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"};\n';
    with(cursor) {
		setModeAccess(cursor.Insert);
		refreshBuffer();
		setValueBuffer("nombre", "Empresa por defecto");
		setValueBuffer("cifnif", "Z99999999");
		setValueBuffer("administrador", "ANONIMO");
		setValueBuffer("direccion", "C/ CALLE 999");
		setValueBuffer("codejercicio", codEjercicio);
		setValueBuffer("coddivisa", "EUR");
		setValueBuffer("codpago", "CONT");
		setValueBuffer("codserie", "A");
		setValueBuffer("codpostal", "00000");
		setValueBuffer("ciudad", "MADRID");
		setValueBuffer("provincia", "MADRID");
		setValueBuffer("telefono", "96 111 22 33");
		setValueBuffer("email", "email@example.com");
		setValueBuffer("codpais", "ES");
		setValueBuffer("logo", milogo);
		commitBuffer();
	}
	this.iface.crearProvinciasEsp();
}

function oficial_crearProvinciasEsp(codPais:String)
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = new FLSqlCursor("provincias");
	var provincias:Array =
			[["ALAVA", "ES", "01"], ["ALBACETE", "ES", "02"], ["ALICANTE", "ES", "03"], ["ALMERIA", "ES", "04"], ["ASTURIAS", "ES", "33"], ["AVILA", "ES", "05"], ["BADAJOZ", "ES", "06"], ["BALEARES", "ES", "07"], ["BARCELONA", "ES", "08"], ["BURGOS", "ES", "09"], ["CACERES", "ES", "10"], ["CADIZ", "ES", "11"], ["CANTABRIA", "ES", "39"], ["CASTELLON", "ES", "12"], ["CIUDAD REAL", "ES", "12"], ["CIUDAD REAL", "ES", "13"], ["CORDOBA", "ES", "14"], ["LA CORUÑA", "ES", "15"], ["CUENCA", "ES", "16"], ["GERONA", "ES", "17"], ["GRANADA", "ES", "18"], ["GUADALAJARA", "ES", "19"], ["GUIPUZCOA", "ES", "20"], ["HUELVA", "ES", "21"], ["HUESCA", "ES", "22"], ["JAEN", "ES", "23"], ["LEON", "ES", "24"], ["LERIDA", "ES", "25"], ["LUGO", "ES", "27"], ["MADRID", "ES", "28"], ["MALAGA", "ES", "29"], ["MURCIA", "ES", "30"], ["NAVARRA", "ES", "31"], ["ORENSE", "ES", "32"], ["PALENCIA", "ES", "34"], ["LAS PALMAS", "ES", "35"], ["PONTEVEDRA", "ES", "36"], ["LA RIOJA", "ES", "26"], ["SALAMANCA", "ES", "37"], ["SEGOVIA", "ES", "40"],["SEVILLA", "ES", "41"], ["SORIA", "ES", "42"], ["TARRAGONA", "ES", "43"], ["SANTA CRUZ DE TENERIFE", "ES", "38"], ["TERUEL", "ES", "44"], ["TOLEDO", "ES", "45"], ["VALENCIA", "ES", "46"], ["VALLADOLID", "ES", "47"], ["VIZCAYA", "ES", "48"], ["ZAMORA", "ES", "49"], ["ZARAGOZA", "ES", "50"], ["CEUTA", "ES", "51"], ["MELILLA", "ES", "52"]];

	var codPaisProvincia:String;
	for (var i:Number = 0; i < provincias.length; i++) {
		codPaisProvincia = (codPais ? codPais : provincias[i][1]);
		if (util.sqlSelect("provincias", "idprovincia", "codpais = '" + codPaisProvincia + "' AND (UPPER(provincia) = '" + provincias[i][0] + "' OR codigo = '" + provincias[i][2] + "')"  )) {
			continue;
		}
		with(cursor) {
			setModeAccess(cursor.Insert);
			refreshBuffer();
			setValueBuffer("provincia", provincias[i][0]);
			setValueBuffer("codpais", codPaisProvincia);
			setValueBuffer("codigo", provincias[i][2]);
			commitBuffer();
		}
	}
}

function oficial_valorQuery(tablas:String, select:String, from:String, where:String):String
{
	var qry:FLSqlQuery = new FLSqlQuery();
	try { qry.setForwardOnly( true ); } catch (e) {}
	qry.setTablesList(tablas);
	qry.setSelect(select);
	qry.setFrom(from);
	qry.setWhere(where);
	qry.exec();
	if (qry.next())
		return qry.value(0);
	else
		return "";
}

/** \D
Crea una subcuenta contable, si no existe ya la combinación Código de subcuenta - Ejercicio actual
@param	codSubcuenta: Código de la subcuenta a crear
@param	descripcion: Descripción de la subcuenta a crear
@param	idCuentaEsp: Indicador del tipo de cuenta especial (CLIENT = cliente, PROVEE = proveedor)
@param	codEjercicio: Código del ejercicio en el que se va a crear la subcuenta
@return	id de la subcuenta creada o ya existente.
\end */
function oficial_crearSubcuenta(codSubcuenta:String, descripcion:String, idCuentaEsp:String, codEjercicio:String):Number
{
	var util:FLUtil = new FLUtil();

	var datosEmpresa:Array;
	if (!codEjercicio) {
		datosEmpresa["codejercicio"] = this.iface.ejercicioActual();
	} else {
		datosEmpresa["codejercicio"] = codEjercicio;
	}
	datosEmpresa["coddivisa"] = this.iface.valorDefectoEmpresa("coddivisa");
	
	var idSubcuenta:String = util.sqlSelect("co_subcuentas", "idsubcuenta","codsubcuenta = '" + codSubcuenta + "' AND codejercicio = '" + datosEmpresa.codejercicio + "'");
	if (idSubcuenta) {
		return idSubcuenta;
	}
	var codCuenta3:String = codSubcuenta.left(3);
	var codCuenta4:String = codSubcuenta.left(4);
	var datosCuenta:Array = this.iface.ejecutarQry("co_cuentas", "codcuenta,idcuenta",
		"idcuentaesp = '" + idCuentaEsp + "'" +
		" AND codcuenta = '" + codCuenta4 + "'" + 
		" AND codejercicio = '" + datosEmpresa.codejercicio + "' ORDER BY codcuenta");

	if (datosCuenta.result == -1) {
		datosCuenta = this.iface.ejecutarQry("co_cuentas", "codcuenta,idcuenta", "idcuentaesp = '" + idCuentaEsp + "'" + " AND codcuenta = '" + codCuenta3 + "'" + " AND codejercicio = '" + datosEmpresa.codejercicio + "' ORDER BY codcuenta");
		if (datosCuenta.result == -1)  {
			return true;
		}
	}
	var curSubcuenta:FLSqlCursor = new FLSqlCursor("co_subcuentas");
	with (curSubcuenta) {
		setModeAccess(curSubcuenta.Insert);
		refreshBuffer();
		setValueBuffer("codsubcuenta", codSubcuenta);
		setValueBuffer("descripcion", descripcion);
		setValueBuffer("idcuenta", datosCuenta.idcuenta);
		setValueBuffer("codcuenta", datosCuenta.codcuenta);
		setValueBuffer("coddivisa", datosEmpresa.coddivisa);
		setValueBuffer("codejercicio", datosEmpresa.codejercicio);
	}
	if (!curSubcuenta.commitBuffer()) {
		return false;
	}

	return curSubcuenta.valueBuffer("idsubcuenta");
}

/** \D Borra una subcuenta contable en el caso de que no existan partidas asociadas
@param	idSubcuenta: Identificador de la subcuenta a borrar
@return	True si no hay error, False en otro caso
\end */
function oficial_borrarSubcuenta(idSubcuenta:Number):Boolean
{
	var util:FLUtil = new FLUtil();
	if (!util.sqlSelect("co_partidas", "idpartida",
		"idsubcuenta = " + idSubcuenta)) {
		var curSubcuenta:FLSqlCursor = new FLSqlCursor("co_subcuentas");
		curSubcuenta.select("idsubcuenta = " + idSubcuenta);
		curSubcuenta.first();
		curSubcuenta.setModeAccess(curSubcuenta.Del);
		curSubcuenta.refreshBuffer();
		if (!curSubcuenta.commitBuffer()) {
			return false;
		}
	}
	return true;
}

/* \D Devuelve el código e id de la subcuenta de cliente según su código
@param codCliente: Código del cliente
@param valoresDefecto: Array con los datos de ejercicio y divisa actuales
@return Los datos componen un vector de tres valores:
error: 0.Sin error 1.Datos no encontrados 2.Error al ejecutar la query
idsubcuenta: Identificador de la subcuenta
codsubcuenta: Código de la subcuenta
\end */
function oficial_datosCtaCliente(codCliente:String, valoresDefecto:Array):Array
{
	/* \C En caso de que el código de cliente sea vacío, la subcuenta de clientes será la primera que depende de la cuenta especial de clientes (generalmente 430...0)
	\end */
	if ( !codCliente || codCliente == "" )
		return flfacturac.iface.pub_datosCtaEspecial("CLIENT", valoresDefecto.codejercicio);

	var util:FLUtil = new FLUtil();
	var ctaCliente:Array = [];
	ctaCliente["codsubcuenta"] = "";
	ctaCliente["idsubcuenta"] = "";
	if (!codCliente.toString().isEmpty()) {
		var qrySubcuenta:FLSqlQuery = new FLSqlQuery();
		try { qrySubcuenta.setForwardOnly( true ); } catch (e) {}
		qrySubcuenta.setTablesList("co_subcuentascli");
		qrySubcuenta.setSelect("idsubcuenta, codsubcuenta");
		qrySubcuenta.setFrom("co_subcuentascli");
		qrySubcuenta.setWhere("codcliente = '" + codCliente + "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
		if (!qrySubcuenta.exec()) {
			ctaCliente.error = 2;
			return ctaCliente;
		}
		if (!qrySubcuenta.first()) {
			MessageBox.critical(util.translate("scripts", "No hay ninguna subcuenta asociada al cliente ") + codCliente + util.translate("scripts", " para el ejercicio ") + valoresDefecto.codejercicio + ".\n" + util.translate("scripts", "Debe crear la subcuenta en el formulario de clientes."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			ctaCliente.error = 1;
			return ctaCliente;
		}
		ctaCliente.idsubcuenta = qrySubcuenta.value(0);
		ctaCliente.codsubcuenta = qrySubcuenta.value(1);
	}
	ctaCliente.error = 0;
	return ctaCliente;
}

/* \D Devuelve el código e id de la subcuenta de proveedor según su código
@param codProveedor: Código del proveedor
@param valoresDefecto: Array con los datos de ejercicio y divisa actuales
@return Los datos componen un vector de tres valores:
error: 0.Sin error 1.Datos no encontrados 2.Error al ejecutar la query
idsubcuenta: Identificador de la subcuenta
codsubcuenta: Código de la subcuenta
\end */
function oficial_datosCtaProveedor(codProveedor:String, valoresDefecto:Array):Array
{
	/* \C En caso de que el código de proveedor sea vacío, la subcuenta de proveedores será la primera que depende de la cuenta especial de proveedores (generalmente 400...0)
	\end */
	if ( !codProveedor || codProveedor == "" )
		return flfacturac.iface.pub_datosCtaEspecial("PROVEE", valoresDefecto.codejercicio);

	var util:FLUtil = new FLUtil();
	var ctaProveedor:Array = [];
	ctaProveedor["codsubcuenta"] = "";
	ctaProveedor["idsubcuenta"] = "";
	if (!codProveedor.toString().isEmpty()) {
		var qrySubcuenta:FLSqlQuery = new FLSqlQuery();
		qrySubcuenta.setTablesList("co_subcuentasprov");
		qrySubcuenta.setSelect("idsubcuenta, codsubcuenta");
		qrySubcuenta.setFrom("co_subcuentasprov");
		qrySubcuenta.setWhere("codproveedor = '" + codProveedor + "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
		if (!qrySubcuenta.exec()) {
			ctaProveedor.error = 1;
			return ctaProveedor;
		}
		if (!qrySubcuenta.first()) {
			MessageBox.critical(util.translate("scripts", "No hay ninguna subcuenta asociada al proveedor ") + codProveedor + util.translate("scripts", " para el ejercicio ") + valoresDefecto.codejercicio + ".\n" + util.translate("scripts", "Debe crear la subcuenta en el formulario de proveedores."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			ctaProveedor.error = 1;
			return ctaProveedor;
		}
		ctaProveedor.idsubcuenta = qrySubcuenta.value(0);
		ctaProveedor.codsubcuenta = qrySubcuenta.value(1);
	}
	ctaProveedor.error = 0;
	return ctaProveedor;
}

/** \D Calcula la fecha inicial y la fecha final del intervalo
@param	codIntervalo: código del intervalo.
@return	 intervalo: array con las fechas inicial y final del intervalo
\end */
function oficial_calcularIntervalo(codIntervalo:String):Array 
{
	var util:FLUtil = new FLUtil();
	var intervalo:Array = [];

	var textoFun:String = util.sqlSelect("intervalos", "funcionintervalo", "codigo = '" + codIntervalo + "'");

	var funcionVal = new Function(textoFun);
	var resultado = funcionVal();
	if (resultado)
		return resultado;

	intervalo["desde"] = false;
	intervalo["hasta"] = false;

	var fechaDesde:Date = new Date();
	var fechaHasta:Date = new Date();
	var mes:Number;
	var anio:Number;

	switch(codIntervalo) {
		case "000001": {
			intervalo.desde = fechaDesde;
			intervalo.hasta = fechaHasta;
			break;
		}

		case "000002": {
			intervalo.desde = util.addDays(fechaDesde,-1);
			intervalo.hasta = util.addDays(fechaHasta,-1);
			break;
		}
		
		case "000003": {
			var dias:Number = fechaDesde.getDay() -1;
			dias = dias * -1;
			intervalo.desde = util.addDays(fechaDesde, dias);
			intervalo.hasta = util.addDays(intervalo.desde,6);
			break;
		}
		
		case "000004": {
			var dias:Number = fechaHasta.getDay() -1;
			dias = dias * -1;
			intervalo.hasta = util.addDays(fechaHasta, dias -1);
			intervalo.desde = util.addDays(intervalo.hasta,-6);
			break;
		}
			
		case "000005": {
			mes = fechaDesde.getMonth();
			fechaDesde.setDate(1);
			intervalo.desde = fechaDesde;
			fechaHasta.setDate(1);
			fechaHasta = util.addMonths(fechaHasta, 1);;
			fechaHasta = util.addDays(fechaHasta,-1);
			intervalo.hasta = fechaHasta;
			break;
		}
		
		case "000006": {
			fechaDesde.setDate(1);
			fechaDesde = util.addMonths(fechaDesde, -1);
			intervalo.desde = fechaDesde;
			fechaHasta.setDate(1);
			fechaHasta = util.addDays(fechaHasta,-1);
			intervalo.hasta = fechaHasta;
			break;
		}
		
		case "000007": {
			fechaDesde.setDate(1);
			fechaDesde.setMonth(1);
			intervalo.desde = fechaDesde;
			fechaHasta.setMonth(12)
			fechaHasta.setDate(31);
			intervalo.hasta = fechaHasta;
			break;
		}
		
		case "000008": {
			anio = fechaDesde.getYear() - 1;
			fechaDesde.setDate(1);
			fechaDesde.setMonth(1);
			fechaDesde.setYear(anio);
			intervalo.desde = fechaDesde;
			fechaHasta.setMonth(12);
			fechaHasta.setDate(31);
			fechaHasta.setYear(anio);
			intervalo.hasta = fechaHasta;
			break;
		}
		
		case "000009": {
			intervalo.desde = "1970-01-01";
			intervalo.hasta = "3000-01-01";
			break;
		}
		
		case "000010": {
			intervalo.desde = "1970-01-01";
			intervalo.hasta = fechaHasta;
			break;
		}
	}
	return intervalo;
}

/** \D
Crea una subcuenta contable, si no existe ya la combinación Código de subcuenta - Ejercicio actual
@param	codSubcuenta: Código de la subcuenta a crear
@param	idSubcuenta: Identificador de la subcuenta a crear
@param	codCliente: Cliente para el que se crea la subcuenta
@param	codEjercicio: Código del ejercicio en el que se va a crear la subcuenta
@return	Verdadero si no hay error, Falso en otro caso
\end */
function oficial_crearSubcuentaCli(codSubcuenta:String, idSubcuenta:Number, codCliente:String, codEjercicio:String):Boolean
{
	var curSubcuentaCli:FLSqlCursor = new FLSqlCursor("co_subcuentascli");
	with (curSubcuentaCli) {
		setModeAccess(curSubcuentaCli.Insert);
		refreshBuffer();
		setValueBuffer("codsubcuenta", codSubcuenta);
		setValueBuffer("idSubcuenta", idSubcuenta);
		setValueBuffer("codcliente", codCliente);
		setValueBuffer("codejercicio", codEjercicio);
	}
	if (!curSubcuentaCli.commitBuffer())
		return false;

	return true;
}

/** \D
Crea una subcuenta contable, si no existe ya la combinación Código de subcuenta - Ejercicio actual
@param	codSubcuenta: Código de la subcuenta a crear
@param	idSubcuenta: Identificador de la subcuenta a crear
@param	codProveedor: Proveedor para el que se crea la subcuenta
@param	codEjercicio: Código del ejercicio en el que se va a crear la subcuenta
@return	Verdadero si no hay error, Falso en otro caso
\end */
function oficial_crearSubcuentaProv(codSubcuenta:String, idSubcuenta:Number, codProveedor:String, codEjercicio:String):Boolean
{
	var curSubcuentaProv:FLSqlCursor = new FLSqlCursor("co_subcuentasprov");
	with (curSubcuentaProv) {
		setModeAccess(curSubcuentaProv.Insert);
		refreshBuffer();
		setValueBuffer("codsubcuenta", codSubcuenta);
		setValueBuffer("idSubcuenta", idSubcuenta);
		setValueBuffer("codproveedor", codProveedor);
		setValueBuffer("codejercicio", codEjercicio);
	}
	if (!curSubcuentaProv.commitBuffer())
		return false;

	return true;
}

/** \D Crea las subcuentas  asociadas a un cliente que todavía no existen en los ejercicios con plan general contable 
@param codCliente: Código de cliente
@param codSubcuenta: Código de subcuenta
@param nombre: Nombre del cliente
@return True si la generación de subcuentas finaliza correctamente, falso en caso contrario
*/
function oficial_rellenarSubcuentasCli(codCliente:String, codSubcuenta:String, nombre:String):Boolean
{
	if (!sys.isLoadedModule("flcontppal"))
		return true;
	if (!codSubcuenta)
		return true;
	
	var util:FLUtil = new FLUtil;
	var qry:FLSqlQuery = new FLSqlQuery();
	qry.setTablesList("ejercicios,co_subcuentascli");
	qry.setSelect("e.codejercicio");
	qry.setFrom("ejercicios e LEFT OUTER JOIN co_subcuentascli s ON e.codejercicio = s.codejercicio AND s.codcliente = '" + codCliente + "'");
	qry.setWhere("s.id IS NULL AND e.estado = 'ABIERTO' AND e.fechafin >= CURRENT_DATE");
	if (!qry.exec())
		return false;
	
	var idSubcuenta:Number;
	var codEjercicio:String;
	while (qry.next()) {
		codEjercicio = qry.value(0);
		if (!util.sqlSelect("co_epigrafes", "codepigrafe", "codejercicio = '" + codEjercicio + "'"))
			continue;
		idSubcuenta = this.iface.crearSubcuenta(codSubcuenta, nombre, "CLIENT", codEjercicio);
		if (!idSubcuenta)
			return false;
		
		if (idSubcuenta == true)
			continue;
		
		if (!this.iface.crearSubcuentaCli(codSubcuenta, idSubcuenta, codCliente, codEjercicio))
			return false;
	}
	
	return true;
}

/** \D Crea las subcuentas  asociadas a un proveedor que todavía no existen en los ejercicios con plan general contable 
@param codProveedor: Código de proveedor
@param codSubcuenta: Código de subcuenta
@param nombre: Nombre del proveedor
@return True si la generación de subcuentas finaliza correctamente, falso en caso contrario
*/
function oficial_rellenarSubcuentasProv(codProveedor:String, codSubcuenta:String, nombre:String):Boolean
{
	if (!sys.isLoadedModule("flcontppal")) {
		return;
	}

	var util:FLUtil = new FLUtil;
	var qry:FLSqlQuery = new FLSqlQuery();
	qry.setTablesList("ejercicios,co_subcuentasprov");
	qry.setSelect("e.codejercicio");
	qry.setFrom("ejercicios e LEFT OUTER JOIN co_subcuentasprov s ON e.codejercicio = s.codejercicio AND s.codproveedor = '" + codProveedor + "'");
	qry.setWhere("s.id IS NULL AND e.estado = 'ABIERTO' AND e.fechafin >= CURRENT_DATE");
	if (!qry.exec())
		return false;
	
	var idSubcuenta:Number;
	var codEjercicio:String;
	while (qry.next()) {
		codEjercicio = qry.value(0);
		if (!util.sqlSelect("co_epigrafes", "codepigrafe", "codejercicio = '" + codEjercicio + "'"))
			continue;
		idSubcuenta = this.iface.crearSubcuenta(codSubcuenta, nombre, "PROVEE", codEjercicio);
		if (!idSubcuenta)
			return false;
		
		if (idSubcuenta == true) 
			continue;
		
		if (!this.iface.crearSubcuentaProv(codSubcuenta, idSubcuenta, codProveedor, codEjercicio))
			return false;
	}
	
	return true;
}

/** \D Indica si el módulo de autómata está instalado y activado
@return	true si está activado, false en caso contrario
\end */
function oficial_automataActivado():Boolean
{
	if (!sys.isLoadedModule("flautomata"))
		return false;
	
	if (formau_automata.iface.pub_activado())
		return true;
	
	return false;
}


/** \D Indica si el cliente está activo (no está de baja) para la fecha especificada
@param	codCliente: Código de cliente
@param	fecha: Fecha a considerar
@return	true si está activo, false en caso contrario o si hay error
\end */
function oficial_clienteActivo(codCliente:String, fecha:String):Boolean
{
	var util:FLUtil = new FLUtil;
	if (!codCliente || codCliente == "")
		return true;
	
	var qryBaja:FLSqlQuery = new FLSqlQuery();
	qryBaja.setTablesList("clientes");
	qryBaja.setSelect("debaja, fechabaja");
	qryBaja.setFrom("clientes");
	qryBaja.setWhere("codcliente = '" + codCliente + "'");
	qryBaja.setForwardOnly(true);
	if (!qryBaja.exec())
		return false;
	
	if (!qryBaja.first())
		return false;
	
	if (!qryBaja.value("debaja"))
		return true;
		
	if (util.daysTo(fecha, qryBaja.value("fechabaja")) <= 0) {
		if (!this.iface.automataActivado()) {
			var fechaDdMmAaaa:String = util.dateAMDtoDMA(fecha);
			MessageBox.warning(util.translate("scripts", "El cliente está de baja para la fecha especificada (%1)").arg(fechaDdMmAaaa), MessageBox.Ok, MessageBox.NoButton);
		}
		return false;
	}
	return true;
}

/** \D Autocompleta la provincia cuando el usuario pulsa . u ofrece la lista de provincias que comienzan por el valor actual del campo para que el usuario elija
@param	formulario	Formulario que contiene el campo de provincia
@param	campoId Campo del id de provincia en base de datos
@param	campoProvincia Campo del valor de la provincia en base de datos
@param	campoPais Campo del código de país en base de datos
\end */
function oficial_obtenerProvincia(formulario:Object, campoId:String, campoProvincia:String, campoPais:String)
{
	var util:FLUtil = new FLUtil;
	if (!campoId)
		campoId = "idprovincia";

	if (!campoProvincia)
		campoProvincia = "provincia";

	if (!campoPais)
		campoPais = "codpais";

	var provincia:String = formulario.cursor().valueBuffer(campoProvincia);
	if (!provincia || provincia == "") {
		return;
	}
	if (provincia.endsWith(".")) {
		formulario.cursor().setNull(campoId);
		//provincia = util.utf8(provincia);

		provincia = provincia.left(provincia.length - 1);
		provincia = provincia.toUpperCase();
		
		var where:String = "UPPER(provincia) LIKE '" + provincia + "%'";
		var codPais:String = formulario.cursor().valueBuffer(campoPais);
		if (codPais && codPais != "")
			where += " AND codpais = '" + codPais + "'";
		
		var qryProvincia:FLSqlQuery = new FLSqlQuery;
		with (qryProvincia) {
			setTablesList("provincias");
			setSelect("idprovincia");
			setFrom("provincias");
			setForwardOnly(true);
		}
		qryProvincia.setWhere(where);

		if (!qryProvincia.exec())
			return false;

		switch (qryProvincia.size()) {
			case 0: {
				return;
			}
			case 1: {
				if (!qryProvincia.first()) {
					return false;
				}
				formulario.cursor().setValueBuffer(campoId, qryProvincia.value("idprovincia"));
				break;
			}
			default: {
				var listaProvincias:String = "";
				while (qryProvincia.next()) {
					if (listaProvincias != "")
						listaProvincias += ", ";
					listaProvincias += qryProvincia.value("idprovincia");
				}
				var f:Object = new FLFormSearchDB("provincias");
				var curProvincias:FLSqlCursor = f.cursor();
				curProvincias.setMainFilter("idprovincia IN (" + listaProvincias + ")");
	
				f.setMainWidget();
				var idProvincia:String = f.exec("idprovincia");

				if (idProvincia)
					formulario.cursor().setValueBuffer(campoId, idProvincia);
				break;
			}
		}
	}
}


function oficial_actualizarContactos20070525():Boolean
{
	var util:FLUtil;

	var qryClientes:FLSqlQuery = new FLSqlQuery();
	qryClientes.setTablesList("clientes");
	qryClientes.setFrom("clientes");
	qryClientes.setSelect("codcliente,codcontacto,contacto");
	qryClientes.setWhere("");
	if (!qryClientes.exec()) 
		return false;

	util.createProgressDialog(util.translate("scripts", "Reorganizando Contactos"), qryClientes.size());
	util.setProgress(0);

	var cont:Number = 1;
	
	while (qryClientes.next()) {
		util.setProgress(cont);
		cont += 1;
		var codCliente:String = qryClientes.value("codcliente");
		
		if(!codCliente) {
			util.destroyProgressDialog();
			return false;
		}
			
		var qryAgenda:FLSqlQuery = new FLSqlQuery();
		qryAgenda.setTablesList("contactosclientes");
		qryAgenda.setFrom("contactosclientes");
		qryAgenda.setSelect("contacto,cargo,telefono,fax,email,id,codcliente");
		qryAgenda.setWhere("codcliente = '" + codCliente + "'");
		if (!qryAgenda.exec()) {
			util.destroyProgressDialog();
			return false;
		}

		if (sys.isLoadedModule("flcrm_ppal")) {
			var qryClientesContactos:FLSqlQuery = new FLSqlQuery();
			qryClientesContactos.setTablesList("crm_clientescontactos");
			qryClientesContactos.setFrom("crm_clientescontactos");
			qryClientesContactos.setSelect("codcontacto");
			qryClientesContactos.setWhere("codcliente = '" + codCliente + "' AND codcontacto NOT IN(SELECT codcontacto FROM contactosclientes WHERE codcliente = '" + codCliente + "')");
			if (!qryClientesContactos.exec()) {
				util.destroyProgressDialog();
				return false;
			}
				
	
			while (qryClientesContactos.next())
				this.iface.actualizarContactosDeAgenda20070525(codCliente,qryClientesContactos.value("codcontacto"));
		}

		while (qryAgenda.next()) {
			var nombreCon:String = qryAgenda.value("contacto");
			var cargoCon:String = qryAgenda.value("cargo");
			var telefonoCon:String = qryAgenda.value("telefono");
			var faxCon:String = qryAgenda.value("fax");
			var emailCon:String = qryAgenda.value("email");
			var idAgenda:Number = qryAgenda.value("id");
			if (!idAgenda || idAgenda == 0) {
				util.destroyProgressDialog();
				return false;
			}
			
			var qryContactos:FLSqlQuery = new FLSqlQuery();
			qryContactos.setTablesList("crm_contactos,contactosclientes");
			qryContactos.setFrom("crm_contactos INNER JOIN contactosclientes ON crm_contactos.codcontacto = contactosclientes.codcontacto");
			qryContactos.setSelect("crm_contactos.codcontacto");
			qryContactos.setWhere("crm_contactos.nombre = '" + nombreCon + "' AND (contactosclientes.codcliente = '" + codCliente + "' AND (crm_contactos.email = '" + emailCon + "' AND crm_contactos.telefono1 = '" + telefonoCon + "'))");
			if (!qryContactos.exec()) {
				util.destroyProgressDialog();
				return false;
			}
			
			var codContacto:String = "";

			if (qryContactos.first())
				codContacto = qryContactos.value("crm_contactos.codcontacto");

			if(!this.iface.actualizarContactosDeAgenda20070525(codCliente,codContacto,nombreCon,cargoCon,telefonoCon,faxCon,emailCon,idAgenda)) {
				util.destroyProgressDialog();
				return false;
			}
		}

		if ((qryClientes.value("contacto") && qryClientes.value("contacto") != "") && (!qryClientes.value("codcontacto") || qryClientes.value("codcontacto") == "")) {
				codContacto = util.sqlSelect("crm_contactos", "codcontacto", "nombre = '" +  this.iface.escapeQuote(qryClientes.value("contacto")) + "'");
				if (codContacto)
					this.iface.actualizarContactosDeAgenda20070525(codCliente,codContacto,qryClientes.value("contacto"));
				else
					codContacto = this.iface.actualizarContactosDeAgenda20070525(codCliente,"",qryClientes.value("contacto"));

				if(!codContacto) {
					util.destroyProgressDialog();
					return false;
				}
			
				var curCliente:FLSqlCursor = new FLSqlCursor("clientes");
				curCliente.select("codcliente = '" + codCliente + "'");
				curCliente.setModeAccess(curCliente.Edit);
				if (!curCliente.first()) {
					util.destroyProgressDialog();
					return false;
				}
				curCliente.refreshBuffer();
				curCliente.setValueBuffer("codcontacto", codContacto);
			
				if (!curCliente.commitBuffer()) {
					util.destroyProgressDialog();
					return false;
				}
		}
	}
	util.setProgress(qryClientes.size());
	util.destroyProgressDialog();
	return true;
}

function oficial_actualizarContactosProv20070702():Boolean
{
	var util:FLUtil;

	var qryProveedores:FLSqlQuery = new FLSqlQuery();
	qryProveedores.setTablesList("proveedores");
	qryProveedores.setFrom("proveedores");
	qryProveedores.setSelect("codproveedor,codcontacto,contacto");
	qryProveedores.setWhere("");
	if (!qryProveedores.exec()) 
		return false;

	util.createProgressDialog(util.translate("scripts", "Reorganizando Contactos"), qryProveedores.size());
	util.setProgress(0);

	var cont:Number = 1;
	
	while (qryProveedores.next()) {
		util.setProgress(cont);
		cont += 1;
		var codProveedor:String = qryProveedores.value("codproveedor");
		
		if(!codProveedor) {
			util.destroyProgressDialog();
			return false;
		}
			
		var qryAgenda:FLSqlQuery = new FLSqlQuery();
		qryAgenda.setTablesList("contactosproveedores");
		qryAgenda.setFrom("contactosproveedores");
		qryAgenda.setSelect("contacto,cargo,telefono,fax,email,id,codproveedor");
		qryAgenda.setWhere("codproveedor = '" + codProveedor + "'");
		if (!qryAgenda.exec()) {
			util.destroyProgressDialog();
			return false;
		}

		while (qryAgenda.next()) {
			var nombreCon:String = qryAgenda.value("contacto");
			var cargoCon:String = qryAgenda.value("cargo");
			var telefonoCon:String = qryAgenda.value("telefono");
			var faxCon:String = qryAgenda.value("fax");
			var emailCon:String = qryAgenda.value("email");
			var idAgenda:Number = qryAgenda.value("id");
			if (!idAgenda || idAgenda == 0) {
				util.destroyProgressDialog();
				return false;
			}
			
			var qryContactos:FLSqlQuery = new FLSqlQuery();
			qryContactos.setTablesList("crm_contactos,contactosproveedores");
			qryContactos.setFrom("crm_contactos INNER JOIN contactosproveedores ON crm_contactos.codcontacto = contactosproveedores.codcontacto");
			qryContactos.setSelect("crm_contactos.codcontacto");
			qryContactos.setWhere("crm_contactos.nombre = '" + nombreCon + "' AND (contactosproveedores.codproveedor = '" + codProveedor + "' AND (crm_contactos.email = '" + emailCon + "' AND crm_contactos.telefono1 = '" + telefonoCon + "'))");
			if (!qryContactos.exec()) {
				util.destroyProgressDialog();
				return false;
			}
			
			var codContacto:String = "";

			if (qryContactos.first())
				codContacto = qryContactos.value("crm_contactos.codcontacto");

			if(!this.iface.actualizarContactosDeAgendaProv20070702(codProveedor,codContacto,nombreCon,cargoCon,telefonoCon,faxCon,emailCon,idAgenda)) {
				util.destroyProgressDialog();
				return false;
			}
		}

		if ((qryProveedores.value("contacto") && qryProveedores.value("contacto") != "") && (!qryProveedores.value("codcontacto") || qryProveedores.value("codcontacto") == "")) {
				codContacto = util.sqlSelect("crm_contactos", "codcontacto", "nombre = '" + qryProveedores.value("contacto") + "'");
				if (codContacto)
					this.iface.actualizarContactosDeAgendaProv20070702(codProveedor,codContacto,qryProveedores.value("contacto"));
				else
					codContacto = this.iface.actualizarContactosDeAgendaProv20070702(codProveedor,"",qryProveedores.value("contacto"));

				if(!codContacto) {
					util.destroyProgressDialog();
					return false;
				}
			
				var curProveedor:FLSqlCursor = new FLSqlCursor("proveedores");
				curProveedor.select("codproveedor = '" + codProveedor + "'");
				curProveedor.setModeAccess(curProveedor.Edit);
				if (!curProveedor.first()) {
					util.destroyProgressDialog();
					return false;
				}
				curProveedor.refreshBuffer();
				curProveedor.setValueBuffer("codcontacto", codContacto);
			
				if (!curProveedor.commitBuffer()) {
					util.destroyProgressDialog();
					return false;
				}
		}
	}
	util.setProgress(qryProveedores.size());
	util.destroyProgressDialog();
	return true;
}

function oficial_actualizarContactosDeAgenda20070525(codCliente:String,codContacto:String,nombreCon:String,cargoCon:String,telefonoCon:String,faxCon:String,emailCon:String,idAgenda:Number):String {

	var util:FLUtil;
	var curContactos:FLSqlCursor = new FLSqlCursor("crm_contactos");
	var curAgenda:FLSqlCursor = new FLSqlCursor("contactosclientes");

	if (codContacto && codContacto != "") {
		curContactos.select("codcontacto = '" + codContacto + "'");
		if (!curContactos.first())
			return false;
		curContactos.setModeAccess(curContactos.Edit);
		curContactos.refreshBuffer();
		if (!curContactos.valueBuffer("cargo") || curContactos.valueBuffer("cargo") == "") {
			curContactos.setValueBuffer("cargo", cargoCon);
		}
		
		if (!curContactos.valueBuffer("telefono1") || curContactos.valueBuffer("telefono1") == "") {
			curContactos.setValueBuffer("telefono1", telefonoCon);
		}
		else {
			if (!curContactos.valueBuffer("telefono2") || 		curContactos.valueBuffer("telefono2") == "") {
				curContactos.setValueBuffer("telefono2", telefonoCon);
			}
		}
		if (!curContactos.valueBuffer("fax") || curContactos.valueBuffer("fax") == "") {
			curContactos.setValueBuffer("fax", faxCon);
		}
		if (!curContactos.valueBuffer("email") || curContactos.valueBuffer("email") == "") {
			curContactos.setValueBuffer("email", emailCon);
		}
	}
	else {
		with (curContactos) {
			setModeAccess(Insert);
			refreshBuffer();
			setValueBuffer("codcontacto", util.nextCounter("codcontacto", this));
			setValueBuffer("nombre",nombreCon);
			setValueBuffer("email",emailCon);
			setValueBuffer("telefono1",telefonoCon);
			setValueBuffer("cargo",cargoCon);
			setValueBuffer("fax",faxCon);
		}
	
		if (!curContactos.commitBuffer())
			return false;

		codContacto = curContactos.valueBuffer("codcontacto");
		if(!codContacto)
			return false;
	}
	if (!idAgenda || idAgenda == 0) {
		if (!util.sqlSelect("contactosclientes","id","codcontacto = '" + codContacto + "' AND codcliente = '" + codCliente + "'")) {
			curAgenda.setModeAccess(curAgenda.Insert);
			curAgenda.refreshBuffer();
			curAgenda.setValueBuffer("codcliente",codCliente);
			curAgenda.setValueBuffer("codcontacto",codContacto);
			if (!curAgenda.commitBuffer())
				return false;
		}
	}
	else {
		curAgenda.select("id = " + idAgenda);
		if (!curAgenda.first())
			return false;
		curAgenda.setModeAccess(curAgenda.Edit);
		curAgenda.refreshBuffer();
		curAgenda.setValueBuffer("codcontacto",codContacto);
		if (!curAgenda.commitBuffer())
			return false;
	}

	

	return codContacto;
}

function oficial_lanzarEvento(cursor:FLSqlCursor, evento:String):Boolean
{
	var datosEvento:Array = [];
	datosEvento["tipoobjeto"] = cursor.table();
	datosEvento["idobjeto"] = cursor.valueBuffer(cursor.primaryKey());
	datosEvento["evento"] = evento;
	if (!flcolaproc.iface.pub_procesarEvento(datosEvento))
		return false;

	return true;
}

function oficial_actualizarContactosDeAgendaProv20070702(codProveedor:String,codContacto:String,nombreCon:String,cargoCon:String,telefonoCon:String,faxCon:String,emailCon:String,idAgenda:Number):String 
{
	var util:FLUtil;
	var curContactos:FLSqlCursor = new FLSqlCursor("crm_contactos");
	var curAgenda:FLSqlCursor = new FLSqlCursor("contactosproveedores");

	if (codContacto && codContacto != "") {
		curContactos.select("codcontacto = '" + codContacto + "'");
		if (!curContactos.first())
			return false;
		curContactos.setModeAccess(curContactos.Edit);
		curContactos.refreshBuffer();
		if (!curContactos.valueBuffer("cargo") || curContactos.valueBuffer("cargo") == "") {
			curContactos.setValueBuffer("cargo", cargoCon);
		}
		
		if (!curContactos.valueBuffer("telefono1") || curContactos.valueBuffer("telefono1") == "") {
			curContactos.setValueBuffer("telefono1", telefonoCon);
		}
		else {
			if (!curContactos.valueBuffer("telefono2") || 		curContactos.valueBuffer("telefono2") == "") {
				curContactos.setValueBuffer("telefono2", telefonoCon);
			}
		}
		if (!curContactos.valueBuffer("fax") || curContactos.valueBuffer("fax") == "") {
			curContactos.setValueBuffer("fax", faxCon);
		}
		if (!curContactos.valueBuffer("email") || curContactos.valueBuffer("email") == "") {
			curContactos.setValueBuffer("email", emailCon);
		}
	}
	else {
		with (curContactos) {
			setModeAccess(Insert);
			refreshBuffer();
			setValueBuffer("codcontacto", util.nextCounter("codcontacto", this));
			setValueBuffer("nombre",nombreCon);
			setValueBuffer("email",emailCon);
			setValueBuffer("telefono1",telefonoCon);
			setValueBuffer("cargo",cargoCon);
			setValueBuffer("fax",faxCon);
		}
	
		if (!curContactos.commitBuffer())
			return false;

		codContacto = curContactos.valueBuffer("codcontacto");
		if(!codContacto)
			return false;
	}
	if (!idAgenda || idAgenda == 0) {
		if (!util.sqlSelect("contactosproveedores","id","codcontacto = '" + codContacto + "' AND codproveedor = '" + codProveedor + "'")) {
			curAgenda.setModeAccess(curAgenda.Insert);
			curAgenda.refreshBuffer();
			curAgenda.setValueBuffer("codproveedor",codProveedor);
			curAgenda.setValueBuffer("codcontacto",codContacto);
			if (!curAgenda.commitBuffer())
				return false;
		}
	}
	else {
		curAgenda.select("id = " + idAgenda);
		if (!curAgenda.first())
			return false;
		curAgenda.setModeAccess(curAgenda.Edit);
		curAgenda.refreshBuffer();
		curAgenda.setValueBuffer("codcontacto",codContacto);
		if (!curAgenda.commitBuffer())
			return false;
	}

	

	return codContacto;
}

/** \D
Da a elegir al usuario entre una serie de opciones
@param	opciones: Array con las n opciones a elegir
@return	El índice de la opción elegida si se pulsa Aceptar
		-1 si se pulsa Cancelar
		-2 si hay error
\end */
function oficial_elegirOpcion(opciones:Array, titulo:String):Number
{
	var util:FLUtil = new FLUtil();
	var dialog:Dialog = new Dialog;
	dialog.okButtonText = util.translate("scripts","Aceptar");
	dialog.cancelButtonText = util.translate("scripts","Cancelar");
	dialog.title = titulo;
	var bgroup:GroupBox = new GroupBox;
	dialog.add(bgroup);
	var rB:Array = [];
	for (var i:Number = 0; i < opciones.length; i++) {
		rB[i] = new RadioButton;
		bgroup.add(rB[i]);
		rB[i].text = opciones[i];
		if (i == 0) {
			rB[i].checked = true;
		} else {
			rB[i].checked = false;
		}
		if ((i + 1) % 25 == 0) {
			bgroup.newColumn();
		}
	}

	if (dialog.exec()) {
		for (var i:Number = 0; i < opciones.length; i++) {
			if (rB[i].checked == true) {
				return i;
			}
		}
	} else {
		return -1;
	}
}

/** \D Pasa a formato de texto una fecha 
@param fecha: Fecha en formato en formato AAAA-MM-DD...
\end */
function oficial_textoFecha(fecha:String):String
{
	var util:FLUtil;
	if (!fecha || fecha == "") {
		return "";
	}
	var mes:String = fecha.mid(5, 2);
	var textoMes:String;
	switch (mes) {
		case "01": { textoMes = util.translate("scripts", "Enero"); break; }
		case "02": { textoMes = util.translate("scripts", "Febrero"); break; }
		case "03": { textoMes = util.translate("scripts", "Marzo"); break; }
		case "04": { textoMes = util.translate("scripts", "Abril"); break; }
		case "05": { textoMes = util.translate("scripts", "Mayo"); break; }
		case "06": { textoMes = util.translate("scripts", "Junio"); break; }
		case "07": { textoMes = util.translate("scripts", "Julio"); break; }
		case "08": { textoMes = util.translate("scripts", "Agosto"); break; }
		case "09": { textoMes = util.translate("scripts", "Septiembre"); break; }
		case "10": { textoMes = util.translate("scripts", "Octubre"); break; }
		case "11": { textoMes = util.translate("scripts", "Noviembre"); break; }
		case "12": { textoMes = util.translate("scripts", "Diciembre"); break; }
	}
	var dia:String = parseInt(fecha.mid(8, 2));
	var ano:String = parseInt(fecha.mid(0, 4));
	var texto:String = util.translate("scripts", "%1 de %2 de %3").arg(dia.toString()).arg(textoMes).arg(ano);
	return texto;
}

function oficial_validarNifIva(nifIva:String):String
{
	var util:FLUtil = new FLUtil;
	var error:String;
	if (!nifIva || nifIva == "") {
		error = util.translate("scripts", "No se ha establecido el NIF/IVA");
		return error;
	}
	var codPais:String = nifIva.left(2);
	var pais:String;
	var longPosibles:Array;
	switch (codPais) {
		case "DE": {
			longPosibles = [9];
			pais = util.translate("scripts", "Alemania");
			break;
		}
		case "AT": {
			longPosibles = [9];
			pais = util.translate("scripts", "Austria");
			break;
		}
		case "BE": {
			longPosibles = [9, 10];
			pais = util.translate("scripts", "Bélgica");
			break;
		}
		case "BG": {
			longPosibles = [9, 10];
			pais = util.translate("scripts", "Bulgaria");
			break;
		}
		case "CY": {
			longPosibles = [9];
			pais = util.translate("scripts", "Chipre");
			break;
		}
		case "CZ": {
			longPosibles = [9];
			pais = util.translate("scripts", "Chequia");
			break;
		}
		case "DK": {
			longPosibles = [8];
			pais = util.translate("scripts", "Dinamarca");
			break;
		}
		case "EE": {
			longPosibles = [9];
			pais = util.translate("scripts", "Estonia");
			break;
		}
		case "FI": {
			longPosibles = [8];
			pais = util.translate("scripts", "Finlandia");
			break;
		}
		case "FR": {
			longPosibles = [11];
			pais = util.translate("scripts", "Francia");
			break;
		}
		case "EL": {
			longPosibles = [9];
			pais = util.translate("scripts", "Grecia");
			break;
		}
		case "GB": {
			longPosibles = [5, 9, 12];
			pais = util.translate("scripts", "Gran Bretaña");
			break;
		}
		case "NL": {
			longPosibles = [12];
			pais = util.translate("scripts", "Holanda");
			break;
		}
		case "HU": {
			longPosibles = [8];
			pais = util.translate("scripts", "Hungría");
			break;
		}
		case "IT": {
			longPosibles = [11];
			pais = util.translate("scripts", "Gran Bretaña");
			break;
		}
		case "IE": {
			longPosibles = [8];
			pais = util.translate("scripts", "Irlanda");
			break;
		}
		case "LT": {
			longPosibles = [9, 12];
			pais = util.translate("scripts", "Lituania");
			break;
		}
		case "LU": {
			longPosibles = [8];
			pais = util.translate("scripts", "Luxemburgo");
			break;
		}
		case "PL": {
			longPosibles = [10];
			pais = util.translate("scripts", "Polonia");
			break;
		}
		case "PT": {
			longPosibles = [9];
			pais = util.translate("scripts", "Portugal");
			break;
		}
		case "RO": {
			longPosibles = [2, 3, 4, 5, 6, 7, 8, 9, 10];
			pais = util.translate("scripts", "Rumanía");
			break;
		}
		case "SE": {
			longPosibles = [12];
			pais = util.translate("scripts", "Suecia");
			break;
		}
		case "SI": {
			longPosibles = [8];
			pais = util.translate("scripts", "Eslovenia");
			break;
		}
		case "SK": {
			longPosibles = [10];
			pais = util.translate("scripts", "Eslovaquia");
			break;
		}
		default: {
			error = util.translate("scripts", "El código de país %1 no es correcto").arg(codPais);
			return error;
		}
	}
	var longOk:Boolean = false;
	var longitud:Number = nifIva.length - 2;
	for (var i:Number = 0; i < longPosibles.length; i++) {
		if (longitud == longPosibles[i]) {
			longOk = true;
		}
	}
	if (!longOk) {
		var longTotales:Array = new Array(longPosibles.length);
		for (var i:Number = 0; i < longPosibles.length; i++) longTotales[i] = longPosibles[i] + 2;
		error = util.translate("scripts", "Error en la validación del NIF/IVA %1 para el país %2:\nLas longitudes admitidas son: %3").arg(nifIva).arg(pais).arg(longTotales.join(", "));
		return error;
	}
	return "OK";
}

/** \D
Ejecuta un comando externo de forma asíncrona
@param	comando: Comando a ejecutar
@return	Array con dos datos: 
	ok: True si no hay error, false en caso contrario
	salida: Mensaje de stdout o stderr obtenido
\end */
function oficial_ejecutarComandoAsincrono(comando:String):Array
{
	var res:Array = [];
	Process.execute(comando);
	if (Process.stderr != "") {
		res["ok"] = false;
		res["salida"] = Process.stderr;
	} else {
		res["ok"] = true;
		res["salida"] = Process.stdout;
	}
	return res;
}

/** \D Función que se ejecuta al lanzarse la aplicación si está correctamente establecido el setting local application/callFunction
\end */
function oficial_globalInit()
{
	if (sys.isLoadedModule("flcolaproc")) {
		try {
			flcolaproc.iface.pub_globalInit();
		} catch (e) {}
	}

	if (sys.isLoadedModule("flcolamens")) {
		try {
			flcolamens.iface.pub_globalInit();
		} catch (e) {}
	}
}

function oficial_existeEnvioMail():Boolean
{
	return false;
}

/** \D si el país de la dirección indicada tiene activado el indicador de validación de sus provincias, se comprueba que la provincia y el país son válidos, informando si es necesario el campo idprovincia
@param cursor: Cursor de la tabla que contiene la dirección
@param mtd: Metadatos sobre los campos 
@return False si la provincia no es correcta, true si lo es.
\end */
function oficial_validarProvincia(cursor:FLSqlCursor, mtd:Array):Boolean
{
	var util:FLUtil = new FLUtil();
	if (!mtd) {
		mtd = [];
		mtd["idprovincia"] = "idprovincia";
		mtd["provincia"] = "provincia";
		mtd["codpais"] = "codpais";
	}
	var idProvincia:String = cursor.valueBuffer(mtd["idprovincia"]);
	var provincia:String = cursor.valueBuffer(mtd["provincia"]);
	var codPais:String = cursor.valueBuffer(mtd["codpais"]);

	if (util.sqlSelect("paises", "validarprov", "codpais = '" + codPais + "'")) {
		if (!idProvincia || idProvincia == "") {
			idProvincia = false;
			if (provincia && provincia != "" && provincia != undefined) {
				idProvincia = util.sqlSelect("provincias", "idprovincia", "UPPER(provincia) = '" + provincia.toUpperCase() + "' AND codpais = '" + codPais + "'");
				if (idProvincia) {
					cursor.setValueBuffer(mtd["idprovincia"], idProvincia)
				}
			}
			if (!idProvincia) {
				MessageBox.warning(util.translate("scripts", "La provincia %1 no pertenece al país %2").arg(provincia).arg(codPais), MessageBox.Ok, MessageBox.NoButton);
				return false;
			}
		} else {
			var idProvTabla:String = util.sqlSelect("provincias", "idprovincia", "UPPER(provincia) = '" + provincia.toUpperCase() + "' AND codpais = '" + codPais + "' AND idprovincia = " + idProvincia);
			if (!idProvTabla) {
				MessageBox.warning(util.translate("scripts", "La provincia %1 no pertenece al país %2").arg(provincia).arg(codPais), MessageBox.Ok, MessageBox.NoButton);
				return false;
			}
		}
	}
	return true;
}

function oficial_simplify(str)
{
  var regExp = new RegExp("( |\n|\r|\t|\f)");
  regExp.global = true;
  str = str.replace(regExp, "");
  return str;
}

function oficial_escapeQuote(str)
{
  var regExp = new RegExp("'");
  regExp.global = true;
  str = str.replace(regExp, "''");
  return str;
}

function oficial_calcularIBAN(cuenta, codPais)
{
    var util:FLUtil = new FLUtil();
    var _i = this.iface;
    var IBAN = "";
    
    if (!cuenta || cuenta == "") {
        return "";
    }
    var codIso;
    if (codPais && codPais != "") {
        codIso = util.sqlSelect("paises", "codiso", "codpais = '" + codPais + "'");
        codIso = (!codIso || codIso == "") ? "ES" : codIso;
    } else {
        codIso = "ES";
    }
    var digControl = _i.digitoControlMod97(cuenta, codIso);
    IBAN += codIso + digControl + cuenta;
    
    return IBAN;
}


function oficial_moduloNumero(num, div)
{
    var d, i = 0, a = 1;
    var parcial = 0;
    for (i = num.length - 1; i >= 0 ; i--) {
        d = parseInt(num.charAt(i));
        parcial += (d * a);
        a = (a * 10) % div;
    }
    return parcial % div;
}


function oficial_digitoControlMod97(numero, codPais)
{
    var _i = this.iface;
    var cadena = "";

    cadena += numero.toString() + codPais.toUpperCase() + "00";
    
    for(var i = 0; i < cadena.length; i++) {
        if(isNaN(cadena.charAt(i))) {
            var trans = cadena.charCodeAt(i) - 55;
            cadena = cadena.replace(cadena.charAt(i),trans);
        }
    }

    var digControl = _i.moduloNumero(cadena, 97);
    digControl = 98 - digControl;
        
    digControl = flfactppal.iface.pub_cerosIzquierda(digControl, 2);
    
    return digControl;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
