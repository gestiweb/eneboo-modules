/***************************************************************************
                 crm_campanas.qs  -  description
                             -------------------
    begin                : mar oct 31 2006
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
	function calculateCounter() {
		return this.ctx.interna_calculateCounter();
	}
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
	function generarListaClicked() {
		return this.ctx.oficial_generarListaClicked();
	}
	function generarLista(cursor:FLSqlCursor):Boolean {
		return this.ctx.oficial_generarLista(cursor);
	}
	function valoresAlias(idLista:String):Array {
		return this.ctx.oficial_valoresAlias(idLista);
	}
	function tbnBajarLisClicked() {
		return this.ctx.oficial_tbnBajarLisClicked();
	}
	function tbnSubirLisClicked() {
		return this.ctx.oficial_tbnSubirLisClicked();
	}
	function moverLista(direccion:Number) {
		return this.ctx.oficial_moverLista(direccion);
	}
	function tbnLanzarClicked() {
		return this.ctx.oficial_tbnLanzarClicked();
	}
	function pbnPlantillaClicked() {
		return this.ctx.oficial_pbnPlantillaClicked();
	}
	function tbnEtiDireccionClicked() {
		return this.ctx.oficial_tbnEtiDireccionClicked();
	}
	function tbnCampoPlanClicked() {
		return this.ctx.oficial_tbnCampoPlanClicked();
	}
	function lanzarCampanaEmail() {
		return this.ctx.oficial_lanzarCampanaEmail();
	}
	function lanzarCampanaCorreo() {
		return this.ctx.oficial_lanzarCampanaCorreo();
	}
	function lanzarCampanaEmailManual() {
		return this.ctx.oficial_lanzarCampanaEmailManual();
	}
	function lanzarCampanaTelefono() {
		return this.ctx.oficial_lanzarCampanaTelefono();
	}
	function ejecutarComando(comando:String):Array {
		return this.ctx.oficial_ejecutarComando(comando);
	}
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function probarEnvio() {
		return this.ctx.oficial_probarEnvio();
	}
	function enviarEmailCampana(curDestinatario:FLSqlCursor, arrayAlias:Array):Boolean {
		return this.ctx.oficial_enviarEmailCampana(curDestinatario, arrayAlias);
	}
	function exportar() {
		return this.ctx.oficial_exportar();
	}
	function generarFichero():String {
		return this.ctx.oficial_generarFichero();
	}
	function crearComunicacionCampana(curDestinatario:FLSqlCursor, canal:String):Boolean {
		return this.ctx.oficial_crearComunicacionCampana(curDestinatario, canal);
	}
	function habilitarPlantillaEmail() {
		return this.ctx.oficial_habilitarPlantillaEmail();
	}
	function tbnRefrescarPlan_clicked() {
		return this.ctx.oficial_tbnRefrescarPlan_clicked();
	}
	function dameResponsableDestinatario(curDestinatario:FLSqlCursor):String {
		return this.ctx.oficial_dameResponsableDestinatario(curDestinatario);
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
	var cursor:FLSqlCursor = this.cursor();
	if (cursor)
		return util.nextCounter("codcampana", cursor);
}

function interna_init()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	connect(this.child("tbnGenerarLista"), "clicked()", this, "iface.generarListaClicked");
	connect(this.child("tbnBajarLis"), "clicked()", this, "iface.tbnBajarLisClicked");
	connect(this.child("tbnSubirLis"), "clicked()", this, "iface.tbnSubirLisClicked");
	connect(this.child("tbnLanzar"), "clicked()", this, "iface.tbnLanzarClicked");
	connect(this.child("pbnPlantilla"), "clicked()", this, "iface.pbnPlantillaClicked");
	connect(this.child("tbnEtiDireccion"), "clicked()", this, "iface.tbnEtiDireccionClicked");
	connect(this.child("tbnCampoPlan"), "clicked()", this, "iface.tbnCampoPlanClicked");
	connect(this.child("tbnProbar"), "clicked()", this, "iface.probarEnvio");
	connect(this.child("tbnRefrescarPlan"), "clicked()", this, "iface.tbnRefrescarPlan_clicked");
	connect(cursor, "bufferChanged(String)", this, "iface.bufferChanged");
	connect(this.child("tbnExportar"), "clicked()", this, "iface.exportar");

	switch (cursor.modeAccess()) {
		case cursor.Insert: {
			this.child("fdbIdUsuario").setValue(sys.nameUser());
			this.child("fdbCodEstado").setValue(util.sqlSelect("crm_estadoscampana", "codestado", "valordefecto = true"));
		}
	}
	this.iface.bufferChanged("canal");
	this.iface.habilitarPlantillaEmail();
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Genera la lista de destinatarios en función de las listas asociadas a la campaña
\end */
function oficial_generarListaClicked()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	cursor.transaction(false);
	try {
		if (this.iface.generarLista(cursor))
			cursor.commit();
		else
			cursor.rollback();
	}
	catch (e) {
		cursor.rollback();
		MessageBox.critical(util.translate("scripts", "Hubo un error en la generación de la lista:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
	}
	this.child("tdbDestinatariosCamp").refresh();
}

/** \D Genera la lista de destinatarios en función de las listas asociadas a la campaña
@param	cursor: Cursor correspondiente a la campaña cuya lista de destinatarios hay que generar
@return	true si la generación se realiza de forma correcta, false en caso contrario
\end */
function oficial_generarLista(cursor:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	var codCampana:String = cursor.valueBuffer("codcampana");

	if (!util.sqlDelete("crm_destinacampana", "codcampana = '" + codCampana + "'"))
		return false;

	var curDestina:FLSqlCursor = new FLSqlCursor("crm_destinacampana");

	var qryListas:FLSqlQuery = new FLSqlQuery;
	with (qryListas) {
		setTablesList("crm_listascampana,crm_listasmark");
		setSelect("lc.idlista, lc.tipo, lc.codlista, lm.codconsulta, lm.importanalisis");
		setFrom("crm_listascampana lc INNER JOIN crm_listasmark lm ON lc.codlista = lm.codlista");
		setWhere("lc.codcampana = '" + codCampana + "' ORDER BY lc.orden");
		setForwardOnly(true);
	}
debug(qryListas.sql());
	if (!qryListas.exec())
		return false;
	
	var qryListaCam:FLSqlQuery;
	var qryConsulta:FLSqlQuery;
	var arrayAlias:Array = [];
	var arrayAliasCampana:Array = [];
	var codigo:String;
	var nombre:String;
	var destino:String;
	var campoClave:String;
	var campoNombre:String;
	var campoDestino:String;
	var codLista:String;
	var codConsulta:String;
	var nodoDatos:String;
	var progreso:Number;
	var canal:String = cursor.valueBuffer("canal");
	var plantilla:String = cursor.valueBuffer("plantiemail");
	var incluirTodos:Boolean;
	while (qryListas.next()) {
		codLista = qryListas.value("lc.codlista");
		codConsulta = qryListas.value("lm.codconsulta");

		if (qryListas.value("lm.importanalisis")) {
			var res:Number = MessageBox.warning(util.translate("scripts", "La lista %1 está asociada al Módulo de Análisis.\n¿Desea recargar esta lista con los datos actuales de dicho módulo?").arg(codLista), MessageBox.Yes, MessageBox.No);
			if (res == MessageBox.Yes) {
				var curLista:FLSqlCursor = new FLSqlCursor("crm_listasmark");
				curLista.select("codlista = '" + codLista + "'");
				if (!curLista.first()) {
					return false;
				}
				if (!flcrm_mark.iface.pub_actualizarListaAnalisis(curLista)) {
					return false;
				}
			}
		}
		arrayAliasCampana = flcrm_mark.iface.pub_arrayAliasCampana(codCampana);
		if (qryListas.value("lc.tipo") == util.translate("scripts", "Normal")) {
			qryConsulta = new FLSqlQuery();
			with (qryConsulta) {
				setTablesList("crm_listasmark,crm_consultasmark");
				setSelect("cm.campoclave, cm.camponombre, cm.campoemail, cm.campotel, cm.campodir");
				setFrom("crm_listasmark lm INNER JOIN crm_consultasmark cm ON lm.codconsulta = cm.codconsulta");
				setWhere("lm.codlista = '" + codLista + "'");
				setForwardOnly(true);
			}
			if (!qryConsulta.exec())
				return false;

			if (!qryConsulta.first())
				return false;

			campoClave = qryConsulta.value("cm.campoclave");
			campoNombre = qryConsulta.value("cm.camponombre");
			switch (canal) {
				case "Teléfono": {
					campoDestino = qryConsulta.value("cm.campotel");
					break;
				}
				case "E-mail": {
					campoDestino = qryConsulta.value("cm.campoemail");
					break;
				}
				case "Correo ordinario": {
					campoDestino = qryConsulta.value("cm.campodir");
					break;
				}
				default: {
					return false;
				}
			}
			
			arrayAlias = this.iface.valoresAlias(qryListas.value("lc.idlista"));
			if (!arrayAlias)
				return false;

			qryListaCam = flcrm_mark.iface.pub_queryLista(codLista);
			if (!qryListaCam)
				return false;
			if (!qryListaCam.exec())
				return false;
			
			util.createProgressDialog(util.translate("scripts", "Incluyendo destinatarios de lista %1").arg(codLista), qryListaCam.size());
			progreso = 0;
			incluirTodos = false;
			while (qryListaCam.next()) {
				util.setProgress(progreso++);
				sys.processEvents();
				codigo = qryListaCam.value(campoClave);
				nombre = qryListaCam.value(campoNombre);
				nodoDatos = "<flcrm:destinatario ";
				for (var i:Number; i < arrayAlias.length; i++) {
					nodoDatos += arrayAlias[i]["alias"] + "='" + qryListaCam.value(arrayAlias[i]["campo"]) + "' ";
				}
				nodoDatos += "/>";
				
				if (canal == "Correo ordinario") {
					if (plantilla && plantilla != "") {
						destino = flcrm_mark.iface.pub_sustituirAlias(plantilla, nodoDatos, arrayAliasCampana);
					} else {
						listaCamposDir = campoDestino	;
						camposDir = listaCamposDir.split("%%");
						destino = "";
						if (camposDir) {
							for (var i:Number; i < (camposDir.length - 1); i++) {
								destino += qryListaCam.value(camposDir[i]) + "\n";
							}
						}
					}
				} else {
					destino = qryListaCam.value(campoDestino);
				}
				if (!destino || destino == "") {
					var res:Number = MessageBox.information(util.translate("scripts", "Lista %1.\nEl destinatario %2 - %3 no tiene %4 registrado.\nPulse Sí para incluir a este destinatario, No para excluirlo, o Cancelar para cancelar la generación de la lista.").arg(codLista).arg(codigo).arg(nombre).arg(util.translate("scripts", canal)), MessageBox.Yes, MessageBox.No, MessageBox.Cancel);
					if (res == MessageBox.No)
						continue;
					if (res != MessageBox.Yes) {
						util.destroyProgressDialog();
						return false;
					}
				}
				if (!incluirTodos) {
					if (!nombre || nombre == "") {
						var res:Number = MessageBox.information(util.translate("scripts", "Lista %1.\nEl destinatario %2 no tiene nombre registrado.\nPulse Sí para incluir a este destinatario, No para excluirlo o Ignore para incluir todos los destinatarios en esta situación.").arg(codLista).arg(codigo), MessageBox.Yes, MessageBox.No, MessageBox.Ignore, MessageBox.Cancel);
						if (res == MessageBox.No)
							continue;
						if (res == MessageBox.Cancel) {
							util.destroyProgressDialog();
							return false;
						}
						if (res == MessageBox.Ignore) {
							incluirTodos = true;
						}
					}
				}
				with (curDestina) {
					setModeAccess(Insert);
					refreshBuffer();
					setValueBuffer("codcampana", cursor.valueBuffer("codcampana"));
					setValueBuffer("campoclave", campoClave);
					setValueBuffer("codigo", codigo);
					setValueBuffer("nombre", nombre);
					setValueBuffer("destino", destino);
					setValueBuffer("codestado", util.sqlSelect("crm_estadosdestina", "codestado", "valordefecto = true"));
					setValueBuffer("datos", nodoDatos);
				}
				curDestina.setValueBuffer("idusuario", this.iface.dameResponsableDestinatario(curDestina));
				if (!curDestina.commitBuffer()) {
					util.destroyProgressDialog();
					return false;
				}
			}
			util.destroyProgressDialog();
		} else { /* Lista de exclusión */
			campoClave = util.sqlSelect("crm_listasmark lm INNER JOIN crm_consultasmark cm ON lm.codconsulta = cm.codconsulta", "cm.campoclave", "lm.codlista = '" + codLista + "'", "crm_listasmark,crm_consultasmark");
			
			qryListaCam = flcrm_mark.iface.pub_queryLista(codLista);
			if (!qryListaCam.exec())
				return false;
			
			util.createProgressDialog(util.translate("scripts", "Exluyendo destinatarios de lista %1").arg(codLista), qryListaCam.size());
			progreso = 0;
			while (qryListaCam.next()) {
				util.setProgress(progreso++);
				sys.processEvents();
				codigo = qryListaCam.value(campoClave);
				with (curDestina) {
					select("campoclave = '" + campoClave + "' AND codigo = '" + codigo + "'");
					if (first()) {
						setModeAccess(Del);
						refreshBuffer();
						if (!commitBuffer()) {
							util.destroyProgressDialog();
							return false;
						}
					}
				}
			}
			util.destroyProgressDialog();
		}
	}
	return true;
}

/** \D Construye un array de pares alias/campo asociado a una lista de campaña
@param	idLista: Lista
@return	array de pares o false si hay error
\end */
function oficial_valoresAlias(idLista:String):Array
{
	var arrayAlias:Array = [];
	var qryAlias:FLSqlQuery = new FLSqlQuery();
	with (qryAlias) {
		setTablesList("crm_valoresalias");
		setSelect("alias,campo");
		setFrom("crm_valoresalias");
		setWhere("idlista = " + idLista);
		setForwardOnly(true);
	}
	if (!qryAlias.exec())
		return false;
	
	var indice:Number = 0;
	while (qryAlias.next()) {
		arrayAlias[indice] = [];
		arrayAlias[indice]["alias"] = qryAlias.value("alias");
		arrayAlias[indice]["campo"] = qryAlias.value("campo");
		indice++;
	}
	return arrayAlias;
}

/** \D Mueve la lista seleccionado hacia arriba (antes) en el orden de ejecución
\end */
function oficial_tbnSubirLisClicked()
{
	this.iface.moverLista(-1);
}

/** \D Mueve la lista seleccionado hacia abajo (después) en el orden de ejecución
\end */
function oficial_tbnBajarLisClicked()
{
	this.iface.moverLista(1);
}

/** \D Mueve la lista seleccionada hacia arriba o hacia abajo en función de la dirección
@param	direccion: Indica la dirección en la que hay que mover el paso. Valores:
	1: Hacia abajo
	-1: Hacia arriba
\end */
function oficial_moverLista(direccion:Number)
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.child("tdbListasCampana").cursor();
	var codCampana:String = cursor.valueBuffer("codCampana");
	var orden:Number = cursor.valueBuffer("orden");
	var orden2:Number;
	var fila:Number = this.child("tdbListasCampana").currentRow();

	if (direccion == -1)
		orden2 = util.sqlSelect("crm_listascampana", "orden", "codcampana = '" + codCampana + "' AND orden < " + orden + " ORDER BY orden DESC");
	else
		orden2 = util.sqlSelect("crm_listascampana", "orden", "codcampana = '" + codCampana + "' AND orden > " + orden + " ORDER BY orden");

	if (!orden2)
		return;

	var curLista:FLSqlCursor = new FLSqlCursor("crm_listascampana");
	curLista.select("orden = '" + orden2 + "' AND codcampana = '" + codCampana + "'");
	if (!curLista.first())
		return;

	curLista.setModeAccess(curLista.Edit);
	curLista.refreshBuffer();
	curLista.setValueBuffer("orden", "-1");
	curLista.commitBuffer();

	cursor.setModeAccess(cursor.Edit);
	cursor.refreshBuffer();
	cursor.setValueBuffer("orden", orden2);
	cursor.commitBuffer();

	curLista.setModeAccess(curLista.Edit);
	curLista.refreshBuffer();
	curLista.setValueBuffer("orden", orden);
	curLista.commitBuffer();

	this.child("tdbListasCampana").refresh();
	fila += direccion;
	this.child("tdbListasCampana").setCurrentRow(fila);
}

/** \D Llama a la correspondiente función de lanzamiento de campaña en función del canal a utilizar
\end */
function oficial_tbnLanzarClicked()
{
	var cursor:FLSqlCursor = this.cursor();
	switch (cursor.valueBuffer("canal")) {
		case "Teléfono": {
			this.iface.lanzarCampanaTelefono();
			break;
		}
		case "Correo ordinario": {
			this.iface.lanzarCampanaCorreo();
			break;
		}
		case "E-mail": {
			this.iface.lanzarCampanaEmail();
			break;
		}
	}
}

/** \D Lanza la campaña por el canal de correo electrónico
\end */
function oficial_lanzarCampanaTelefono()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var codCampana:String = cursor.valueBuffer("codcampana");

	if (!sys.isLoadedModule("flcrm_ppal")) {
		MessageBox.information(util.translate("scripts", "No es necesario lanzar la campaña.\n Puedes modificar el estado de los destinatarios desde el formulario maestro 'Destinatarios de campaña'"), MessageBox.Ok, MessageBox.NoButton);
		return true;
	}
	var res:Number = MessageBox.information(util.translate("scripts", "¿Desea crear un registro de comunicación en estado Borrador para cada destinatario?"), MessageBox.Yes, MessageBox.No);
	if (res != MessageBox.Yes) {
		return true;
	}

	var curDestinatarios:FLSqlCursor = new FLSqlCursor("crm_destinacampana");
	curDestinatarios.select("codcampana = '" + codCampana + "' AND codestado <> 'ENVIADO'");

	var envios:Number = 0;
	var limite:Number = curDestinatarios.size();
	util.createProgressDialog(util.translate("scripts", "Creando comunicaciones..."), limite);

	while (curDestinatarios.next()) {
		util.setProgress(envios);
		if (!this.iface.crearComunicacionCampana(curDestinatarios, "Teléfono")) {
			util.destroyProgressDialog();
			return false;
		}
		curDestinatarios.setModeAccess(curDestinatarios.Edit);
		curDestinatarios.refreshBuffer();
		curDestinatarios.setValueBuffer("codestado", "SIN RESPUESTA");
		if (!curDestinatarios.commitBuffer()) {
			util.destroyProgressDialog();
			return false;
		}
		envios++;
	}
	util.destroyProgressDialog();
	this.child("tdbDestinatariosCamp").refresh();
	MessageBox.information(util.translate("scripts", "Las comunicaciones han sido generadas"), MessageBox.Ok, MessageBox.NoButton);
}

function oficial_dameResponsableDestinatario(curDestinatario:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil;
	var campoClave:String = curDestinatario.valueBuffer("campoclave");
	if (!campoClave || campoClave == "") {
		return "";
	}
	var aCC:Array = campoClave.split(".");
	var tabla:String = aCC[0];
debug("tabla " + tabla);
	var responsable:String;
	switch (tabla) {
		case "clientes": {
			responsable = util.sqlSelect("clientes c INNER JOIN agentes a ON c.codagente = a.codagente", "a.idusuario", "c.codcliente = '" + curDestinatario.valueBuffer("codigo") + "'", "clientes,agentes");
debug("responsable " + responsable);
			if (!responsable) {
				return "";
			}
			break;
		}
		case "crm_tarjetas": {
			responsable = util.sqlSelect("crm_tarjetas", "responsable", "codtarjeta = '" + curDestinatario.valueBuffer("codigo") + "'");
			if (!responsable) {
				return "";
			}
			break;
		}
		default: {
			responsable = "";
		}
	}
	return responsable;
}

function oficial_crearComunicacionCampana(curDestinatario:FLSqlCursor, canal:String):Boolean
{
	var util:FLUtil = new FLUtil;

	var curCampana:FLSqlCursor = this.cursor();
	var curComunicacion:FLSqlCursor = new FLSqlCursor("crm_comunicaciones");
	var codCampana:String = curDestinatario.valueBuffer("codcampana");
	var idDest:String = curDestinatario.valueBuffer("iddestinatario");
	curComunicacion.select("codcampana = '" + codCampana + "' AND iddestinatario = " + idDest);
	if (curComunicacion.first()) {
		return true;
	}
	var hoy:Date = new Date;
	var codComunicacion:String = flcrm_ppal.iface.pub_siguienteSecuencia("crm_comunicaciones", "codcomunicacion", 10);
	curComunicacion.setModeAccess(curComunicacion.Insert);
	curComunicacion.refreshBuffer();
	curComunicacion.setValueBuffer("codcomunicacion", codComunicacion);
	curComunicacion.setValueBuffer("fecha", hoy.toString());
	curComunicacion.setValueBuffer("asunto", curCampana.valueBuffer("descripcion"));
	curComunicacion.setValueBuffer("canal", canal);
	curComunicacion.setValueBuffer("origen", "?");
	if (canal == "E-mail") {
		curComunicacion.setValueBuffer("destino", curDestinatario.valueBuffer("destino"));
		curComunicacion.setValueBuffer("contenido", curCampana.valueBuffer("plantiemail"));
	} else {
		curComunicacion.setValueBuffer("destino", curDestinatario.valueBuffer("nombre") + " (" + curDestinatario.valueBuffer("destino") + ")");
	}
	curComunicacion.setValueBuffer("estado", "Borrador");
	switch (curDestinatario.valueBuffer("campoclave")) {
		case "clientes.codcliente": {
			curComunicacion.setValueBuffer("codcliente", curDestinatario.valueBuffer("codigo"));
			break;
		}
		case "crm_tarjetas.codtarjeta": {
			curComunicacion.setValueBuffer("codtarjeta", curDestinatario.valueBuffer("codigo"));
			break;
		}
		case "crm_contactos.codcontacto": {
			curComunicacion.setValueBuffer("codcontacto", curDestinatario.valueBuffer("codigo"));
			break;
		}
	}
	curComunicacion.setValueBuffer("codcampana", codCampana);
	curComunicacion.setValueBuffer("iddestinatario", idDest);
	if (!curComunicacion.commitBuffer()) {
		return false;
	}
	return true;
}

/** \D Lanza la campaña por el canal de correo electrónico
\end */
function oficial_lanzarCampanaEmail()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	if (cursor.valueBuffer("manual")) {
		if (!this.iface.lanzarCampanaEmailManual()) {
			return false;
		}
	}
	var codCampana:String = cursor.valueBuffer("codcampana");

	var curDestinatarios:FLSqlCursor = new FLSqlCursor("crm_destinacampana");
	curDestinatarios.select("codcampana = '" + codCampana + "' AND codestado <> 'ENVIADO'");
	
	var arrayAlias:Array = flcrm_mark.iface.pub_arrayAliasCampana(codCampana);
	if (!arrayAlias) {
		return false;
	}
	
	var limite:Number = Input.getNumber(util.translate("scripts", "Limite de envios (0 para lanzarlos todos)"));
	if (isNaN(limite)) {
		return false;
	}
	
	var envios:Number = 0;
	if (limite > curDestinatarios.size() || limite == 0) {
		limite = curDestinatarios.size();
	}
	util.createProgressDialog(util.translate("scripts", "Enviando correos..."), limite);
	while (curDestinatarios.next()) {
		util.setProgress(envios);
		if (envios >= limite) {
			break;
		}
		if (!this.iface.enviarEmailCampana(curDestinatarios, arrayAlias)) {
			util.destroyProgressDialog();
			return false;
		}
		curDestinatarios.setModeAccess(curDestinatarios.Edit);
		curDestinatarios.refreshBuffer();
		curDestinatarios.setValueBuffer("codestado", "ENVIADO");
		if (!curDestinatarios.commitBuffer()) {
			util.destroyProgressDialog();
			return false;
		}
		envios++;
	}
	util.destroyProgressDialog();
	this.child("tdbDestinatariosCamp").refresh();
	MessageBox.information(util.translate("scripts", "Los correos %1 han sido enviados").arg(envios), MessageBox.Ok, MessageBox.NoButton);
}

/** \D Realiza una prueba de envío para el destinatario seleccionado (cambia el destinatario por el proporcionado por el usuario en caso de que el canal sea correo electrónico)
\end */
function oficial_probarEnvio()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	if (cursor.valueBuffer("canal") != "E-mail")
		return false;

	var emailDefecto:String = util.sqlSelect("usuarios", "email", "idusuario = '" + sys.nameUser() + "'");
	if (!emailDefecto)
		emailDefecto = "";
	var destino:String = Input.getText(util.translate("scripts", "Indique E-mail del destinatario del correo de prueba"), emailDefecto, util.translate("scripts", "Prueba de envío"));
	if (!destino)
		return false;

	var curDestinatario:FLSqlCursor = this.child("tdbDestinatariosCamp").cursor();
	curDestinatario.setModeAccess(curDestinatario.Edit);
	curDestinatario.refreshBuffer();
	curDestinatario.setValueBuffer("destino", destino);
	
	var arrayAlias:Array = flcrm_mark.iface.pub_arrayAliasCampana(cursor.valueBuffer("codCampana"));
	if (!arrayAlias)
		return false;

	if (!this.iface.enviarEmailCampana(curDestinatario, arrayAlias))
		return false;

	MessageBox.information(util.translate("scripts", "El e-mail de prueba ha sido enviado"), MessageBox.Ok, MessageBox.NoButton);
}

/** \D Envia un mail al destinatario
@param curDestinatario: Cursor posicionado en los datos del destinatario del correo
@param arrayAlias: Lista de alias a sustituir por los datos del destinatario
|end */
function oficial_enviarEmailCampana(curDestinatario:FLSqlCursor, arrayAlias:Array):Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	var rutaPlantilla:String = cursor.valueBuffer("planticorreo");
	var formatoHtml:Boolean = (rutaPlantilla && rutaPlantilla != "" && rutaPlantilla.toLowerCase().endsWith(".html"));
	
	var correo:FLSmtpClient = new FLSmtpClient;
	var dirCorreSaliente:String = flcrm_mark.iface.pub_valorConfigMarketing("hostcorreosaliente");
	if (!dirCorreSaliente || dirCorreSaliente == "") {
		dirCorreSaliente = "localhost";
	}
	correo.setMailServer(dirCorreSaliente);
	var remite:String = cursor.valueBuffer("remiteemail");
	if (!remite || remite == "") {
		MessageBox.warning(util.translate("scripts", "Debe establecer email del remitente de esta campaña en la pestaña Plantilla -> E-mail"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var qryAttach:FLSqlQuery = new FLSqlQuery;
	with (qryAttach) {
		setTablesList("crm_adjuntoscampana");
		setSelect("ruta, nombre, idfichero");
		setFrom("crm_adjuntoscampana");
		setWhere("codcampana = '" + cursor.valueBuffer("codcampana") + "'");
		setForwardOnly(true);
	}
	if (!qryAttach.exec()) {
		return false;
	}
	
	var rutaFichero:String;
	while (qryAttach.next()) {
		rutaFichero = qryAttach.value("ruta") + "/" + qryAttach.value("nombre");
		if (!File.exists(rutaFichero)) {
			MessageBox.warning(util.translate("scripts", "No existe el fichero a adjuntar:\n%1").arg(rutaFichero), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
		try {
			correo.addAttachment(rutaFichero, qryAttach.value("idfichero"));
		} catch (e) {
			correo.addAttachment(rutaFichero);
		}
	}
	var codificacion:String = util.readSettingEntry("scripts/flfacturac/encodingLocal");
	var asunto:String = cursor.valueBuffer("descripcion");
	var cuerpoCorreo:String;
	if (rutaPlantilla != "") {
		cuerpoCorreo =  File.read(cursor.valueBuffer("planticorreo"));
		cuerpoCorreo = sys.toUnicode(cuerpoCorreo, codificacion);
	} else {
		cursor.valueBuffer("plantiemail");
	}
	cuerpoCorreo = flcrm_mark.iface.sustituirAlias(cuerpoCorreo, curDestinatario.valueBuffer("datos"), arrayAlias);
	

/// Para solucionar esto se usa export LC_CTYPE=...
// 	asunto = sys.fromUnicode(asunto, codificacion );

debug("formatoHtml = " + formatoHtml);
debug("cuerpoCorreo = " + cuerpoCorreo);
  try {
    if (formatoHtml) {
      correo.setMimeType("text/html");
      correo.setBody(cuerpoCorreo);
//       correo.addTextPart(cuerpoCorreo, "text/html");
    } else {
      correo.setMimeType("text/plain");
      correo.setBody(cuerpoCorreo);
//       correo.addTextPart(cuerpoCorreo, "text/plain");
    }
  } catch (e) {MessageBox(e);
    correo.setBody(cuerpoCorreo);
  }
	
	correo.setFrom(remite);
	correo.setTo(curDestinatario.valueBuffer("destino"));
// 	correo.setBody(cuerpoCorreo);
	correo.setSubject(asunto);
	correo.startSend();
debug("va");
	return true;
}

/** \C Genera un registro de comunicación por cada envío pendiente para que se edite y envíe de forma manual
\end */
function oficial_lanzarCampanaEmailManual()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var codCampana:String = cursor.valueBuffer("codcampana");
	var curDestinatarios:FLSqlCursor = new FLSqlCursor("crm_destinacampana");
	curDestinatarios.select("codcampana = '" + codCampana + "' AND codestado NOT IN ('ENVIADO', 'SIN RESPUESTA')");

	var envios:Number = 0;
	var limite:Number = curDestinatarios.size();
	util.createProgressDialog(util.translate("scripts", "Creando comunicaciones..."), limite);

	while (curDestinatarios.next()) {
		util.setProgress(envios);
		if (!this.iface.crearComunicacionCampana(curDestinatarios, "E-mail")) {
			util.destroyProgressDialog();
			return false;
		}
		curDestinatarios.setModeAccess(curDestinatarios.Edit);
		curDestinatarios.refreshBuffer();
		curDestinatarios.setValueBuffer("codestado", "SIN RESPUESTA");
		if (!curDestinatarios.commitBuffer()) {
			util.destroyProgressDialog();
			return false;
		}
		envios++;
	}
	util.destroyProgressDialog();
	this.child("tdbDestinatariosCamp").refresh();
	MessageBox.information(util.translate("scripts", "Las comunicaciones han sido generadas"), MessageBox.Ok, MessageBox.NoButton);
	return false;
}


/** \D Lanza la campaña por el canal de correo electrónico
\end */
function oficial_lanzarCampanaCorreo()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var codCampana:String = cursor.valueBuffer("codcampana");
	var ahora:Date = new Date();
	var dirDestino:String = cursor.valueBuffer("codcampana") + "-" + ahora.toString();
	
	dirDestino = dirDestino.replace(":", "-");
	dirDestino = dirDestino.replace(":", "-");
	var dirTemp:String = "borrame_" + dirDestino;

	var curDestinatarios:FLSqlCursor = new FLSqlCursor("crm_destinacampana");
	curDestinatarios.select("codcampana = '" + codCampana + "'");
	var cuerpoCorreo:String;
	var arrayAlias:Array = flcrm_mark.iface.pub_arrayAliasCampana(codCampana);
	if (!arrayAlias)
		return false;

	var rutaPlantilla:String = cursor.valueBuffer("planticorreo");
	if (!File.exists(rutaPlantilla)) {
		MessageBox.warning(util.translate("scripts", "El fichero especificado en la ruta:\n%1\nno existe.").arg(rutaPlantilla), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var fichPlantilla = new File(rutaPlantilla);
	var dirPlantilla:Dir = new Dir(fichPlantilla.path);
	
	dirPlantilla.mkdir(dirTemp);
	dirPlantilla.mkdir(dirDestino);

	var indice:Number = 0;
	util.createProgressDialog(util.translate("scripts", "Generando documentos"), curDestinatarios.size());
	var campoClave:String;
	Dir.current = fichPlantilla.path + "/" + dirTemp;
		
	var resComando:Array = this.iface.ejecutarComando("unzip ../" + fichPlantilla.name);
	if (resComando.ok == false) {
		return false;
	}
	var codificacion:String = util.readSettingEntry("scripts/flfacturac/encodingLocal");

	var plantilla:String = File.read(fichPlantilla.path + "/" + dirTemp + "/content.xml");
	if (!plantilla)
		return false;
	plantilla = sys.toUnicode(plantilla, codificacion );
		
	while (curDestinatarios.next()) {
		util.setProgress(indice);
		curDestinatarios.setModeAccess(curDestinatarios.Browse);
		curDestinatarios.refreshBuffer();

		var campoClave:String = curDestinatarios.valueBuffer("campoclave");
		campoClave = campoClave.replace(".", "-");
		campoClave += curDestinatarios.valueBuffer("codigo");

		indice++;
		cuerpoCorreo = flcrm_mark.iface.sustituirAlias(plantilla, curDestinatarios.valueBuffer("datos"), arrayAlias);

		cuerpoCorreo = sys.fromUnicode(cuerpoCorreo, codificacion);
		File.write(fichPlantilla.path + "/" + dirTemp + "/content.xml", cuerpoCorreo);
		
		resComando = this.iface.ejecutarComando("zip -r ../" + dirDestino + "/" + campoClave + ".odt  Configurations2/ META-INF/ mimetype styles.xml content.xml meta.xml settings.xml Thumbnails/");
		if (resComando.ok == false) {
			util.destroyProgressDialog();
			return false;
		}
		sys.processEvents();
	}
	util.destroyProgressDialog();
	MessageBox.information(util.translate("scripts", "Los documentos se generaron en el directorio %1").arg(fichPlantilla.path + "/" + dirDestino), MessageBox.Ok, MessageBox.NoButton);
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
		debug(comando + "\n" + Process.stderr);
	} else {
		res["ok"] = true;
		res["salida"] = Process.stdout;
	}

	return res;
}

function oficial_pbnPlantillaClicked()
{
	this.child("fdbPlantiCorreo").setValue(FileDialog.getOpenFileName("*.*"))
	var cursor:FLSqlCursor = this.cursor();
	if (cursor.valueBuffer("canal") == "E-mail") {
		if (cursor.valueBuffer("planticorreo") != "") {
			this.child("fdbPlantiEmail").setValue(File.read(cursor.valueBuffer("planticorreo")));
		} else {
			this.child("fdbPlantiEmail").setValue("");
		}
	}
}

function oficial_tbnEtiDireccionClicked()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var nombresReport:Array = ["Apli 70x35mm", "Apli 105x48mm"];
	var nombreReport:String;

	var seleccion = Input.getItem(util.translate("scripts", "Seleccione modelo"), nombresReport, false, false, util.translate("scripts", "Título"));
	if (!seleccion)
		return;
	switch (seleccion) {
		case "Apli 70x35mm": {
			nombreReport = "crm_i_apli_70x35";
			break;
		}
		case "Apli 105x48mm": {
			nombreReport = "crm_i_apli_105x48";
			break;
		}
	}
	var qryDestinos:FLSqlQuery = new FLSqlQuery;
	with (qryDestinos) {
		setTablesList("crm_destinacampana");
		setSelect("destino");
		setFrom("crm_destinacampana");
		setWhere("codcampana = '" + cursor.valueBuffer("codcampana") + "'");
		setForwardOnly(true);
	}
	var etiquetaInicial:Array = flfactinfo.iface.seleccionEtiquetaInicial();

	var rptViewer:FLReportViewer = new FLReportViewer();
	rptViewer.setReportTemplate(nombreReport);
	rptViewer.setReportData(qryDestinos);
	rptViewer.renderReport(etiquetaInicial.fila, etiquetaInicial.col);
	rptViewer.exec();
}

/** \D Muestra al usuario la lista de alias para que elija el que quiere insertar en la plantilla
\end */
function oficial_tbnCampoPlanClicked()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	var codCampana:String = cursor.valueBuffer("codcampana");
	var plantilla:String = cursor.valueBuffer("plantiemail");
	if (!plantilla)
		plantilla = "";

	var arrayAlias:Array = flcrm_mark.iface.pub_arrayAliasCampana(codCampana);
	var seleccion:String = Input.getItem(util.translate("scripts", "Seleccione alias"), arrayAlias);
	if (!seleccion)
		return;
	this.child("fdbPlantiEmail").editor().insert("#" + seleccion + "#");
	
}

function oficial_bufferChanged(fN:String)
{
	var cursor:FLSqlCursor = this.cursor();
	switch (fN) {
		case "canal": {
			if (cursor.valueBuffer("canal") == "E-mail") {
				this.child("tbwPlantilla").setTabEnabled("datosemail", true);
			} else {
				this.child("tbwPlantilla").setTabEnabled("datosemail", false);
			}
			break;
		}
		case "planticorreo": {
			this.iface.habilitarPlantillaEmail();
			break;
		}
	}
}

function oficial_habilitarPlantillaEmail()
{
	var cursor:FLSqlCursor = this.cursor();
	var canal:String = cursor.valueBuffer("canal");
	switch (canal) {
		case "E-mail": {
			var plantiCorreo:String = cursor.valueBuffer("planticorreo");
			if (plantiCorreo && plantiCorreo != "") {
				this.child("fdbPlantiEmail").setDisabled(true);
				this.child("tbnCampoPlan").enabled = false;
				this.child("tbnRefrescarPlan").enabled = true;
			} else {
				this.child("fdbPlantiEmail").setDisabled(false);
				this.child("tbnCampoPlan").enabled = true;
				this.child("tbnRefrescarPlan").enabled = false;
			}
			break;
		}
		case "Correo ordinario": {
			this.child("fdbPlantiEmail").setDisabled(false);
			this.child("tbnCampoPlan").enabled = true;
			this.child("tbnRefrescarPlan").enabled = false;
			break;
		}
		case "Teléfono": {
			this.child("fdbPlantiEmail").setDisabled(true);
			this.child("tbnCampoPlan").enabled = false;
			this.child("tbnRefrescarPlan").enabled = false;
			break;
		}
	}
}

function oficial_exportar()
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	var fichero:String = FileDialog.getSaveFileName("*.csv", "Seleccionar fichero...")
	if (!fichero) {
		return;
	}
	var file = new File(fichero);
	file.open(File.WriteOnly);
	var contenido:String = this.iface.generarFichero();
	file.write(contenido);
	file.close();
	MessageBox.information(util.translate("scripts", "Generado fichero en :\n\n" + fichero + "\n\n"), MessageBox.Ok, MessageBox.NoButton);
}

function oficial_generarFichero():String
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var contenido:String;

	var opciones:Array = [util.translate("scripts", "Intro"), util.translate("scripts", "Tabulador"), util.translate("scripts", "Otro")];
	var titulo:String = util.translate("scripts", "Seleccione caracter separador");

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
	var ledCaracter = new LineEdit;
	ledCaracter.label = util.translate("scripts", "Carácter");;
	dialog.add(ledCaracter);

	if (!dialog.exec()) {
		return false;
	}
	var i:Number;
	for (i = 0; i < opciones.length; i++) {
		if (rB[i].checked == true) {
			break;
		}
	}
	var caracter:String;
	switch (i) {
		case 0: {
			caracter = "\r\n";
			break;
		}
		case 1: {
			caracter = "\t";
			break;
		}
		case 2: {
			caracter = ledCaracter.text;
			if (!caracter || caracter == "") {
				MessageBox.warning(util.translate("scripts", "Debe indicar el caracter separador"), MessageBox.Ok, MessageBox.NoButton);
				return false;
			}
			break;
		}
	}
	
	var qryDestino:FLSqlQuery = new FLSqlQuery;
	qryDestino.setTablesList("crm_destinacampana");
	qryDestino.setSelect("destino");
	qryDestino.setFrom("crm_destinacampana");
	qryDestino.setWhere("codcampana = '" + cursor.valueBuffer("codcampana") + "'");
	qryDestino.setForwardOnly(true);
	
	if (!qryDestino.exec()) {
		return;
	}

	while(qryDestino.next()) {
		contenido += qryDestino.value(0) + caracter;
	}
	return contenido;
}

function oficial_tbnRefrescarPlan_clicked()
{
	var cursor:FLSqlCursor = this.cursor();
	var rutaPlantilla:String = cursor.valueBuffer("planticorreo");
	if (!File.exists(rutaPlantilla)) {
		MessageBox.warning(util.translate("scripts", "El fichero especificado en la ruta:\n%1\nno existe.").arg(rutaPlantilla), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	this.child("fdbPlantiEmail").setValue(File.read(cursor.valueBuffer("planticorreo")));
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
