/***************************************************************************
				 flservppal.qs  -  description
							 -------------------
	begin				: lun mar 12 2007
	copyright			: (C) 2007 by InfoSiAL S.L.
	email				: mail@infosial.com
 ***************************************************************************/

/***************************************************************************
 *                      												 *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or	 *
 *   (at your option) any later version.								   *
 *																		 *
 ***************************************************************************/

/** @file */

////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
class interna {
	var ctx:Object;
	function interna( context ) { this.ctx = context; }
	function init() { this.ctx.interna_init(); }

	function beforeCommit_se_enviossw(curEnv:FLSqlCursor):Boolean {
		return this.ctx.interna_beforeCommit_se_enviossw(curEnv);
	}
	function beforeCommit_se_docespec(curDoc:FLSqlCursor):Boolean {
		return this.ctx.interna_beforeCommit_se_docespec(curDoc);
	}
	function beforeCommit_se_pactualizacion(curPA:FLSqlCursor):Boolean {
		return this.ctx.interna_beforeCommit_se_pactualizacion(curPA);
	}
	function beforeCommit_se_comunicaciones(curCom:FLSqlCursor):Boolean {
		return this.ctx.interna_beforeCommit_se_comunicaciones(curCom);
	}	
	function beforeCommit_se_partners(curTab:FLSqlCursor):Boolean {
		return this.ctx.interna_beforeCommit_se_partners(curTab);
	}
	function beforeCommit_se_zonasporpartner(curTab:FLSqlCursor):Boolean {
		return this.ctx.interna_beforeCommit_se_zonasporpartner(curTab);
	}
	function beforeCommit_se_incidencias(curTab:FLSqlCursor):Boolean {
		return this.ctx.interna_beforeCommit_se_incidencias(curTab);
	}
	function beforeCommit_se_zonaspartners(curTab:FLSqlCursor):Boolean {
		return this.ctx.interna_beforeCommit_se_zonaspartners(curTab);
	}
	function afterCommit_se_incidencias(curInc:FLSqlCursor) {
		return this.ctx.interna_afterCommit_se_incidencias(curInc);
	}
	function afterCommit_se_historicos(curHis:FLSqlCursor) {
		return this.ctx.interna_afterCommit_se_historicos(curHis);
	}	
	function afterCommit_se_partners(curTab:FLSqlCursor):Boolean {
		return this.ctx.interna_afterCommit_se_partners(curTab);
	}
	function afterCommit_se_zonaspartners(curTab:FLSqlCursor):Boolean {
		return this.ctx.interna_afterCommit_se_zonaspartners(curTab);
	}
	function afterCommit_se_zonasporpartner(curTab:FLSqlCursor):Boolean {
		return this.ctx.interna_afterCommit_se_zonasporpartner(curTab);
	}
	function afterCommit_se_facthoras(curHoras:FLSqlCursor) {
		return this.ctx.interna_afterCommit_se_facthoras(curHoras);
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var valoresCom:Array;
	function oficial( context ) { interna( context ); } 
	function ejecutarComando(comando:String):Array {
		return this.ctx.oficial_ejecutarComando(comando);
	}
	function getValoresCom():Array {
		return this.ctx.oficial_getValoresCom(valoresCom);
	}
	function calcularSaldoCliente (codCliente:String):Number {	
		return this.ctx.oficial_calcularSaldoCliente(codCliente); 
	}
	function siguienteSecuencia(tabla:String,nombreCodigo:String,longCampo:Number):String {
		return this.ctx.oficial_siguienteSecuencia(tabla,nombreCodigo,longCampo);
	}
	function comprobarClienteCreditos(curIncidencia:FLSqlCursor):Boolean {
		return this.ctx.oficial_comprobarClienteCreditos(curIncidencia);
	}
	function componerCorreo(destinatario:String, asunto:String, cuerpo:String, adjuntos:String):String {
		return this.ctx.oficial_componerCorreo(destinatario, asunto, cuerpo, adjuntos);
	}
	function sincronizarProcesoIncidencia(curInc:FLSqlCursor):Boolean {
		return this.ctx.oficial_sincronizarProcesoIncidencia(curInc);
	}
	function crearProcesoIncidencia(curInc:FLSqlCursor):Boolean {
		return this.ctx.oficial_crearProcesoIncidencia(curInc);
	}
	function sincronizarFechaRevision(curIncidencia:FLSqlCursor):Boolean {
		return this.ctx.oficial_sincronizarFechaRevision(curIncidencia);
	}
	function dameDialogoD() {
		return this.ctx.oficial_dameDialogoD();
	}
	function dameGroupBoxD(titulo:String) {
		return this.ctx.oficial_dameGroupBoxD(titulo);
	}
	function dameRadioButtonD(texto:String, seleccionado:Boolean) {
		return this.ctx.oficial_dameRadioButtonD(texto, seleccionado);
	}
	function dameLineEditD(etiqueta:String, texto:String) {
		return this.ctx.oficial_dameLineEditD(etiqueta, texto);
	}
	function dameCheckBoxD(texto:String, seleccionado:Boolean) {
		return this.ctx.oficial_dameCheckBoxD(texto, seleccionado);
	}
	function reasignacionIncidencia(curIncidencia:FLSqlCursor):Boolean {
		return this.ctx.oficial_reasignacionIncidencia(curIncidencia);
	}
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends oficial {
	function head( context ) { oficial ( context ); }
}

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends head {
	function ifaceCtx( context ) { head( context ); }
	function pub_ejecutarComando(comando:String):Array {
		return this.ejecutarComando(comando);
	}
	function pub_getValoresCom() {
		return this.getValoresCom();
	}
	function pub_siguienteSecuencia(tabla:String,nombreCodigo:String,longCampo:Number):String {
		return this.siguienteSecuencia(tabla,nombreCodigo,longCampo);
	}
	function pub_componerCorreo(destinatario:String, asunto:String, cuerpo:String, adjuntos:String):String {
		return this.componerCorreo(destinatario, asunto, cuerpo, adjuntos);
	}
	function pub_calcularSaldoCliente(codCliente:String):Number {
		return this.calcularSaldoCliente(codCliente); 
	}
	function pub_sincronizarProcesoIncidencia(curInc:FLSqlCursor):Boolean {
		return this.sincronizarProcesoIncidencia(curInc);
	}
	function pub_dameDialogoD() {
		return this.dameDialogoD();
	}
	function pub_dameGroupBoxD(titulo:String) {
		return this.dameGroupBoxD(titulo);
	}
	function pub_dameRadioButtonD(texto:String, seleccionado:Boolean) {
		return this.dameRadioButtonD(texto, seleccionado);
	}
	function pub_dameLineEditD(etiqueta:String, texto:String) {
		return this.dameLineEditD(etiqueta, texto);
	}
	function pub_dameCheckBoxD(texto:String, seleccionado:Boolean) {
		return this.dameCheckBoxD(texto, seleccionado);
	}
}

const iface = new ifaceCtx( this );
//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////

function init() {
}

function interna_init() {
}

/** \C Al eliminar un envío de software se eliminará también
la comunicación asociada
\end */
function interna_beforeCommit_se_enviossw(curEnv)
{
	var util:FLUtil = new FLUtil();
	var curCom:FLSqlCursor = new FLSqlCursor("se_comunicaciones");
	var codComunicacion:String = curEnv.valueBuffer("codcomunicacion");
	
	switch (curEnv.modeAccess()) {

		case curEnv.Del:
			curCom.select("codigo = '" + codComunicacion + "'");
			if (curCom.first()) {
					curCom.setModeAccess(curCom.Del);
					curCom.refreshBuffer();
					curCom.commitBuffer();
			}
		break;
	}
	
	return true;
}	

/** \C Al eliminar un documento de especificación se eliminará también
la comunicación asociada
\end */
function interna_beforeCommit_se_docespec(curDoc)
{
	var util:FLUtil = new FLUtil();
	var curCom:FLSqlCursor = new FLSqlCursor("se_comunicaciones");
	var codComunicacion:String = curDoc.valueBuffer("codcomunicacion");
	
	switch (curDoc.modeAccess()) {

		case curDoc.Del:
			curCom.select("codigo = '" + codComunicacion + "'");
			if (curCom.first()) {
					curCom.setModeAccess(curCom.Del);
					curCom.refreshBuffer();
					curCom.commitBuffer();
			}
		break;
	}
	
	return true;
}	

/** \C Si un periodo de actualización ha sido facturado no se puede eliminar sin
eliminar antes la factura
\end */
function interna_beforeCommit_se_pactualizacion(curPA:FLSqlCursor):Boolean 
{
	var util:FLUtil = new FLUtil();
	
	switch (curPA.modeAccess()) {

		case curPA.Del:
			var codFactura:String = util.sqlSelect("facturascli", "codigo", "idfactura = " + curPA.valueBuffer("idfactura"));
			if (codFactura) {
				MessageBox.warning(util.translate( "scripts", "Antes de eliminar el período debería eliminar la Factura asociada: " ) + codFactura , MessageBox.Ok, MessageBox.NoButton);
				return false;
			}
		break;
	}
	return true;
}


function interna_beforeCommit_se_comunicaciones(curCom:FLSqlCursor):Boolean 
{
debug("BC1");
	if(curCom.modeAccess() == curCom.Del){
		var util:FLUtil = new FLUtil();
		util.sqlUpdate("se_historicos", "codcomunicacion",null,"codcomunicacion = '" + curCom.valueBuffer("codigo") + "'")
	}
debug("BC2");
	return true;
}

function interna_afterCommit_se_facthoras(curHoras:FLSqlCursor):Boolean
{
	var saldo:Number = 0;
	var saldo:Number = this.iface.calcularSaldoCliente(curHoras.valueBuffer("codcliente"));
	if (isNaN(saldo))
		return false;

	curHoras.cursorRelation().setValueBuffer("saldocreditos", saldo);
		
	return true;
}	

/** \C Si la incidencia corresponde a un período de actualización,
se recalcula el número de incidencias consumidas en el 
actual período de actualización.
Se recalcula el saldo de horas del cliente descontando el valor de la incidencia
\end */
function interna_afterCommit_se_incidencias(curInc:FLSqlCursor)
{
	var util:FLUtil = new FLUtil();
	var idPActualizacion:String = curInc.valueBuffer("idpactualizacion");
	
	if (idPActualizacion)
		formRecordse_pactualizacion.iface.pub_actualizarIncidencias();

	var saldo:Number = 0;
	var saldo:String = this.iface.calcularSaldoCliente(curInc.valueBuffer("codcliente"));
	if (isNaN(saldo))
		return false;

	var cursorPadre:FLSqlCursor = curInc.cursorRelation();
	if (cursorPadre && cursorPadre.action() == "se_clientes") {
		curInc.cursorRelation().setValueBuffer("saldocreditos", saldo);
	} else {
		if (!util.sqlUpdate("clientes", "saldocreditos", saldo, "codcliente = '" + curInc.valueBuffer("codcliente") + "'"))
			return false;
	}
	
	if (curInc.valueBuffer("enbolsa")) {
		flsistwebi.iface.pub_setBorrado(curInc);
	}
	
	if (!this.iface.crearProcesoIncidencia(curInc)) {
		return false;
	}

	if (!this.iface.sincronizarFechaRevision(curInc)) {
		return false;
	}

	if (!this.iface.reasignacionIncidencia(curInc)) {
		return false;
	}
	return true;
}

function oficial_crearProcesoIncidencia(curInc:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	var estado:String = curInc.valueBuffer("estado");
	switch (curInc.modeAccess()) {
		case curInc.Insert:
		case curInc.Edit: {
			switch (estado) {
				case "Pendiente": {
					if (!util.sqlSelect("pr_procesos", "idproceso", "idtipoproceso = 'SC_INCIDENCIA' AND idobjeto = '" + curInc.valueBuffer("codigo") + "'")) {
						var res:Number = MessageBox.information(util.translate("scripts", "¿Quieres lanzar un proceso de indicencia?"), MessageBox.Yes, MessageBox.No);
						if (res == MessageBox.Yes) {
							var idProceso:String = flcolaproc.iface.pub_crearProceso("SC_INCIDENCIA", "se_incidencias", curInc.valueBuffer("codigo"));
							if (!idProceso) {
								return false;
							}
						}
					} 
					break;
				}
			}
			break;
		}
	}
	return true;
}

/** \D Actualiza la fecha de activación de la tarea en función de la fecha de revisión de la incidencia asociada
@param	curIncidencia: Cursor de la incidencia
\end */
function oficial_sincronizarFechaRevision(curIncidencia:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	switch (curIncidencia.modeAccess()) {
		case curIncidencia.Edit: {
			var estado:String = curIncidencia.valueBuffer("estado");
			switch (estado) {
				case "En pruebas":
				case "En espera": {
					var fechaRevision:String = curIncidencia.valueBuffer("fecharevision");
					if (fechaRevision != curIncidencia.valueBufferCopy("fecharevision")) {
						var curTarea:FLSqlCursor = new FLSqlCursor("pr_tareas");
						curTarea.setActivatedCommitActions(false);
						curTarea.setActivatedCheckIntegrity(false);
						curTarea.select("tipoobjeto = 'se_incidencias' AND idobjeto = '" + curIncidencia.valueBuffer("codigo") + "' AND codtipotareapro = 'SC_INCIDENCIA_SC_RESOLVER'");
						if (curTarea.first()) {
							curTarea.setModeAccess(curTarea.Edit);
							curTarea.refreshBuffer();
							curTarea.setValueBuffer("fechaactivacion", fechaRevision);
							if (!curTarea.commitBuffer()) {
								return false;
							}
						}
					}
					break;
				}
			}
			break;
		}
	}
	return true;
}

/** \D Reasigna la tarea al nuevo usuario
@param	curIncidencia: Cursor de la incidencia
\end */
function oficial_reasignacionIncidencia(curIncidencia:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	switch (curIncidencia.modeAccess()) {
		case curIncidencia.Edit: {
			var usuarioActual:String = curIncidencia.valueBuffer("codencargado");
			var usuarioAnterior:String = curIncidencia.valueBufferCopy("codencargado");
			if (usuarioAnterior != "" && usuarioActual != "" && usuarioAnterior != usuarioActual) {
				var curTarea:FLSqlCursor = new FLSqlCursor("pr_tareas");
				curTarea.setActivatedCommitActions(false);
				curTarea.setActivatedCheckIntegrity(false);
				curTarea.select("tipoobjeto = 'se_incidencias' AND idobjeto = '" + curIncidencia.valueBuffer("codigo") + "' AND codtipotareapro = 'SC_INCIDENCIA_SC_RESOLVER'");
				if (curTarea.first()) {
					curTarea.setModeAccess(curTarea.Edit);
					curTarea.refreshBuffer();
					curTarea.setValueBuffer("iduser", usuarioActual);
					if (!curTarea.commitBuffer()) {
						return false;
					}
				}
			}
			break;
		}
	}
	return true;
}

/** \C Se establece el estado del subproyecto como el estado resultante
del histórico
\end */
function interna_afterCommit_se_historicos(curHis:FLSqlCursor)
{
	var util:FLUtil = new FLUtil();
	
	switch (curHis.modeAccess()) {
		case curHis.Insert:
		case curHis.Edit: {
			if (curHis.valueBuffer("estado") != curHis.valueBufferCopy("estado")) {
				var estado:String = util.sqlSelect("se_historicos", "estado", "codsubproyecto = '" + curHis.valueBuffer("codsubproyecto") + "' order by fecha desc, id desc");
				if (!curHis.cursorRelation())
					return false;
				curHis.cursorRelation().setValueBuffer("estado", estado);
			}
			break;
		}
	}
	
	return true;
}	


function interna_beforeCommit_se_zonaspartners(cursor:FLSqlCursor):Boolean {
	flsistwebi.iface.pub_setModificado(cursor);
	return true;
}
function interna_beforeCommit_se_partners(cursor:FLSqlCursor):Boolean {
	flsistwebi.iface.pub_setModificado(cursor);
	return true;
}
function interna_beforeCommit_se_zonasporpartner(cursor:FLSqlCursor):Boolean {
	flsistwebi.iface.pub_setModificado(cursor);
	return true;
}
function interna_beforeCommit_se_incidencias(curIncidencia:FLSqlCursor):Boolean {

	switch (curIncidencia.modeAccess()) {
		case curIncidencia.Insert:
		case curIncidencia.Edit: {
			if (curIncidencia.valueBuffer("enbolsa")) {
				if (!this.iface.comprobarClienteCreditos(curIncidencia))
					return false;
			}
			break;
		}
	}
	if (curIncidencia.valueBuffer("enbolsa")) {
		flsistwebi.iface.pub_setModificado(curIncidencia);
	}
	return true;
}

function interna_afterCommit_se_zonaspartners(cursor:FLSqlCursor):Boolean {
	flsistwebi.iface.pub_setBorrado(cursor);
	return true;
}
function interna_afterCommit_se_zonasporpartner(cursor:FLSqlCursor):Boolean {
	flsistwebi.iface.pub_setBorrado(cursor);
	return true;
}
function interna_afterCommit_se_partners(cursor:FLSqlCursor):Boolean {
	flsistwebi.iface.pub_setBorrado(cursor);
	return true;
}


//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_calcularSaldoCliente(codCliente:String):Number
{
	var saldo:Number = 0;
	var precios:Number = 0;

	var util:FLUtil = new FLUtil();
//  var horas:Number = util.sqlSelect("se_facthoras", "SUM(precio)", "codcliente = '" + codCliente + "' AND enbolsa = true");	
	
	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList("se_incidencias");
	q.setFrom("se_incidencias");
	q.setSelect("precio");
	q.setWhere("codcliente = '" + codCliente + "' AND enbolsa = true");

	if (!q.exec())
		return false;
	while(q.next()) {
		precios += parseFloat(q.value("precio"));
	}

	saldo = parseFloat(precios);
	saldo = util.roundFieldValue(saldo, "clientes", "saldocreditos");
	return saldo;
}


/** \D
Ejecuta un comando externo
@param	comando: Comando a ejecutar
@return	Array con dos datos: 
	ok: True si no hay error, false en caso contrario
	salida: Mensaje de stdout o stderr obtenido
\end */
function oficial_ejecutarComando(comando:String):Array
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

function oficial_siguienteSecuencia(tabla:String,nombreCodigo:String,longCampo:Number):String
{
	var util:FLUtil;
	var valor:Number = util.sqlSelect("se_secuencias","valor","nombre = '" + tabla + "'");

	var nuevoValor:Number;
	var curSecuencia:FLSqlCursor = new FLSqlCursor("se_secuencias");
	if (!valor) {
		valor = parseFloat(util.sqlSelect(tabla, "MAX(" + nombreCodigo + ")", "1 = 1"));
		if(!valor || valor == "") 
			valor = 0;

		valor += 1;
		nuevoValor = valor;

		with (curSecuencia) {
			setModeAccess(Insert);
			refreshBuffer();
			setValueBuffer("valor", nuevoValor);
			setValueBuffer("nombre", tabla);
			if (!commitBuffer())
				return false;
		}
	
	} else {
		curSecuencia.select("nombre = '" + tabla + "'");
		if (!curSecuencia.first())
			return false;
		valor += 1;
		nuevoValor = valor;

		curSecuencia.setModeAccess(curSecuencia.Edit);
		curSecuencia.refreshBuffer();
		curSecuencia.setValueBuffer("valor",nuevoValor);
		if (!curSecuencia.commitBuffer())
				return false;
	}
	return nuevoValor;
}

/** \D Comprueba que el cliente tiene marcado el indicador Créditos al asociársele una incidencia a cargar en la bolsa
@param	curIncidencia: Cursor de la incidencia
@return	true si la comprobación es correcta
\end */
function oficial_comprobarClienteCreditos(curIncidencia:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;

	var curRelation:FLSqlCursor = curIncidencia.cursorRelation();
	var codCliente:String = curIncidencia.valueBuffer("codcliente");
	var creditos:Boolean;
	if (curRelation && curRelation.table() == "clientes") {
		creditos = curRelation.valueBuffer("creditos");
		if (!creditos) {
			MessageBox.warning(util.translate("scripts", "Debe marcar la casilla de créditos antes de asociar indidencias a la bolsa de créditos del cliente"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	} else {
		creditos = util.sqlSelect("clientes", "creditos", "codcliente = '" + codCliente + "'");
		if (!creditos) {
			var res:Number = MessageBox.warning(util.translate("scripts", "Para guardar la incidencia es necesario que el cliente tenga activado el indicador de créditos.\n¿Desea activarlo ahora?"), MessageBox.Yes, MessageBox.No);
			if (res != MessageBox.Yes)
				return false;
			if (!util.sqlUpdate("clientes", "creditos", "true", "codcliente = '" + codCliente + "'"))
				return false;
		}
	}
	return true;
}

function oficial_componerCorreo(destinatario:String, asunto:String, cuerpo:String, adjuntos:String):String
{
	var util:FLUtil = new FLUtil();
	var clienteCorreo = util.readSettingEntry("scripts/flservppal/clientecorreo");
 	var comando:String;

	switch(clienteCorreo) {

		case "thunderbird":
			comando = "thunderbird -compose to='" + destinatario + "',subject=" + asunto + ",body='" + cuerpo + "'";
		break

		default:
			comando = "kmail " + destinatario +	" -s " + asunto + " --body " + cuerpo + adjuntos;
	}

	return comando;
}

function oficial_sincronizarProcesoIncidencia(curInc:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	var estado:String = curInc.valueBuffer("estado");
	var estadoAnt:String = curInc.valueBufferCopy("estado");
	switch (estado) {
		case "Resuelta": {
			var curTarea:FLSqlCursor = new FLSqlCursor("pr_tareas");
			curTarea.select("tipoobjeto = 'se_incidencias' AND idobjeto = '" + curInc.valueBuffer("codigo") + "' AND codtipotareapro = 'SC_INCIDENCIA_SC_RESOLVER'");
			if (curTarea.first()) {
				if (estadoAnt == "Cancelada") {
					var idTarea:String = curTarea.valueBuffer("idtarea");
					var idProceso:String = curTarea.valueBuffer("idproceso");
					if (!flcolaproc.iface.pub_reanudarProceso(idProceso)) {
						return false;
					}
					curTarea.select("idtarea = '" + idTarea + "'");
					curTarea.first();
				}
				if (curTarea.valueBuffer("estado") != "TERMINADA") {
					var curTransaccion:FLSqlCursor = new FLSqlCursor("empresa");
					curTransaccion.transaction(false);
					try {
						if (flcolaproc.iface.pub_terminarTareaPorEstado(curTarea)) {
							curTransaccion.commit();
						} else {
							curTransaccion.rollback();
							return false;
						}
					} catch (e) {
						curTransaccion.rollback();
						MessageBox.warning(util.translate("scripts", "Hubo un error al terminar la tarea %1:").arg(idTarea) + e, MessageBox.Ok, MessageBox.NoButton);
						return false;
					}
				}
				break;
			}
		}
		case "En espera":
		case "En pruebas": {
			var fechaRevision:String = curInc.valueBuffer("fecharevision");
			var curTarea:FLSqlCursor = new FLSqlCursor("pr_tareas");
			curTarea.select("tipoobjeto = 'se_incidencias' AND idobjeto = '" + curInc.valueBuffer("codigo") + "' AND codtipotareapro = 'SC_INCIDENCIA_SC_RESOLVER'");
			if (curTarea.first()) {
				if (estadoAnt == "Cancelada") {
					var idTarea:String = curTarea.valueBuffer("idtarea");
					var idProceso:String = curTarea.valueBuffer("idproceso");
					if (!flcolaproc.iface.pub_reanudarProceso(idProceso)) {
						return false;
					}
					curTarea.select("idtarea = '" + idTarea + "'");
					curTarea.first();
				}
				if (curTarea.valueBuffer("estado") != "DORMIDA") {
					var curTransaccion:FLSqlCursor = new FLSqlCursor("empresa");
					curTransaccion.transaction(false);
					try {
						if (flcolaproc.iface.pub_dormirTareaPorEstado(curTarea, fechaRevision)) {
							curTransaccion.commit();
						} else {
							curTransaccion.rollback();
							return false;
						}
					} catch (e) {
						curTransaccion.rollback();
						MessageBox.warning(util.translate("scripts", "Hubo un error al dormir la tarea %1:").arg(idTarea) + e, MessageBox.Ok, MessageBox.NoButton);
						return false;
					}
				}
			}
			break;
		}
		case "Pendiente":
		case "En desarrollo": {
			var curTarea:FLSqlCursor = new FLSqlCursor("pr_tareas");
			curTarea.select("tipoobjeto = 'se_incidencias' AND idobjeto = '" + curInc.valueBuffer("codigo") + "' AND codtipotareapro = 'SC_INCIDENCIA_SC_RESOLVER'");
			if (curTarea.first()) {
				if (estadoAnt == "Cancelada") {
					var idTarea:String = curTarea.valueBuffer("idtarea");
					var idProceso:String = curTarea.valueBuffer("idproceso");
					if (!flcolaproc.iface.pub_reanudarProceso(idProceso)) {
						return false;
					}
					curTarea.select("idtarea = '" + idTarea + "'");
					curTarea.first();
				}
				if (curTarea.valueBuffer("estado") != "PTE" && curTarea.valueBuffer("estado") != "EN CURSO") {
					var curTransaccion:FLSqlCursor = new FLSqlCursor("empresa");
					curTransaccion.transaction(false);
					try {
						if (flcolaproc.iface.pub_ponerTareaEnCursoPorEstado(curTarea)) {
							curTransaccion.commit();
						} else {
							curTransaccion.rollback();
							return false;
						}
					} catch (e) {
						curTransaccion.rollback();
						MessageBox.warning(util.translate("scripts", "Hubo un error al poner EN CURSO la tarea %1:").arg(curTarea.valueBuffer("idtarea")) + e, MessageBox.Ok, MessageBox.NoButton);
						return false;
					}
				}
			}
			break;
		}
		case "Cancelada": {
			var curTarea:FLSqlCursor = new FLSqlCursor("pr_tareas");
			curTarea.select("tipoobjeto = 'se_incidencias' AND idobjeto = '" + curInc.valueBuffer("codigo") + "' AND codtipotareapro = 'SC_INCIDENCIA_SC_RESOLVER'");
			if (curTarea.first()) {
				if (curTarea.valueBuffer("estado") != "PTE") {
					var curTransaccion:FLSqlCursor = new FLSqlCursor("empresa");
					curTransaccion.transaction(false);
					try {
						if (flcolaproc.iface.pub_ponerTareaPtePorEstado(curTarea)) {
							curTransaccion.commit();
						} else {
							curTransaccion.rollback();
							return false;
						}
					} catch (e) {
						curTransaccion.rollback();
						MessageBox.warning(util.translate("scripts", "Hubo un error al poner EN CURSO la tarea %1:").arg(curTarea.valueBuffer("idtarea")) + e, MessageBox.Ok, MessageBox.NoButton);
						return false;
					}
				}
				var idProceso:String = curTarea.valueBuffer("idproceso");
				if (!flcolaproc.iface.pub_cancelarProceso(idProceso)) {
					return false;
				}
			}
			break;
		}
	}
	return true;
}

function oficial_dameDialogoD()
{
	var util:FLUtil = new FLUtil;
	var dialogo = new Dialog;
	dialogo.okButtonText = util.translate("scripts", "Aceptar");
	dialogo.cancelButtonText = util.translate("scripts", "Cancelar");
	return dialogo;
}

function oficial_dameGroupBoxD(titulo:String)
{
	var util:FLUtil = new FLUtil;
	var gbx = new GroupBox;
	gbx.title = titulo;
	return gbx;
}

function oficial_dameRadioButtonD(texto:String, seleccionado:Boolean)
{
	var util:FLUtil = new FLUtil;
	var rbn:RadioButton = new RadioButton;
	rbn.text = texto;
	rbn.checked = seleccionado;
	return rbn;
}

function oficial_dameCheckBoxD(texto:String, seleccionado:Boolean)
{
	var util:FLUtil = new FLUtil;
	var chk:CheckBox = new CheckBox;
	chk.text = texto;
	chk.checked = seleccionado;
	return chk;
}

function oficial_dameLineEditD(etiqueta:String, texto:String)
{
	var util:FLUtil = new FLUtil;
	var led:LineEdit= new LineEdit;
	led.label = etiqueta;
	if (texto) {
		led.text = texto;
	}
	return led;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////

//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
