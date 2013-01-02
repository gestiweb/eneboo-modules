/***************************************************************************
                 crm_listasmark.qs  -  description
                             -------------------
    begin                : sab mar 20 2010
    copyright            : (C) 2010 by InfoSiAL S.L.
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
	var seleccionValores_:Array;
	var datosConsulta_:Array;
	function oficial( context ) { interna( context ); }
	function dameSeleccionValores() {
		return this.ctx.oficial_dameSeleccionValores();
	}
	function ponSeleccionValores(s:String) {
		return this.ctx.oficial_ponSeleccionValores(s);
	}
	function leerListaManual():Boolean {
		return this.ctx.oficial_leerListaManual();
	}
	function escribirListaManual():Boolean {
		return this.ctx.oficial_escribirListaManual();
	}
	function obtenerDatosConsulta():Boolean {
		return this.ctx.oficial_obtenerDatosConsulta();
	}
	function tbnModificarLM_clicked() {
		return this.ctx.oficial_tbnModificarLM_clicked();
	}
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function habilitarPorManual() {
		return this.ctx.oficial_habilitarPorManual();
	}
	function buscarPosicionAnalisis() {
		return this.ctx.oficial_buscarPosicionAnalisis();
	}
	function actualizarPosicionAnalisis() {
		return this.ctx.oficial_actualizarPosicionAnalisis();
	}
	function tbnBuscarListaAnalisis_clicked() {
		return this.ctx.oficial_tbnBuscarListaAnalisis_clicked();
	}
	function habilitarPorImportada() {
		return this.ctx.oficial_habilitarPorImportada();
	}
	function tbnActualizarListaAnalisis_clicked():Boolean {
		return this.ctx.oficial_tbnActualizarListaAnalisis_clicked();
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
	function pub_dameSeleccionValores() {
		return this.dameSeleccionValores();
	}
	function pub_ponSeleccionValores(s:String) {
		return this.ponSeleccionValores(s);
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
	var cursor:FLSqlCursor = this.cursor();

	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this.child("tbnModificarLM"), "clicked()", this, "iface.tbnModificarLM_clicked");
	connect(this.child("tbnBuscarListaAnalisis"), "clicked()", this, "iface.tbnBuscarListaAnalisis_clicked");
	connect(this.child("tbnActualizarListaAnalisis"), "clicked()", this, "iface.tbnActualizarListaAnalisis_clicked");
	this.iface.habilitarPorManual();
	this.iface.habilitarPorImportada();
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_dameSeleccionValores():String
{
	return this.iface.seleccionValores_;
}

function oficial_ponSeleccionValores(s:String)
{
	this.iface.seleccionValores_ = s;
}

/** \D 
\end */
function oficial_tbnModificarLM_clicked()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	if (cursor.modeAccess() == cursor.Insert) {
		if (!this.child("tdbCriteriosLista").cursor().commitBufferCursorRelation()) {
			return false;
		}
	}
	if (!this.iface.obtenerDatosConsulta()) {
		return false;
	}

	if (!this.iface.leerListaManual()) {
		return false;
	}
	var accion:String = "crm_listamark" + this.iface.datosConsulta_["tabla"];
	var f:Object;
	try {
		f = new FLFormSearchDB(accion);
	} catch (e) {
		MessageBox.warning(util.translate("scripts", "Error al lanzar el formulario de selección para la tabla %1").arg(tabla), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	f.setMainWidget();
	f.exec();

	if (!f.accepted()) {
		return;
	}
	this.iface.escribirListaManual();
}

function oficial_obtenerDatosConsulta():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	
	var codConsulta:String = cursor.valueBuffer("codconsulta");
	if (this.iface.datosConsulta_) {
		delete this.iface.datosConsulta_;
	}
	this.iface.datosConsulta_ = [];
	this.iface.datosConsulta_["ok"] = true;

	var campoClave:String = util.sqlSelect("crm_consultasmark", "campoclave", "codconsulta = '" + codConsulta + "'");
	if (!campoClave) {
		this.iface.datosConsulta_["ok"] = false;
		MessageBox.warning(util.translate("scripts", "Error al obtener el campo clave de la consulta asociada"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var datosClave:Array = campoClave.split(".");
	if (!datosClave || datosClave.length != 2) {
		this.iface.datosConsulta_["ok"] = false;
		MessageBox.warning(util.translate("scripts", "Error al analizar el campo clave de la consulta asociada"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	this.iface.datosConsulta_["tabla"] = datosClave[0];
	this.iface.datosConsulta_["clave"] = datosClave[1];
	if (!util.sqlSelect("flfiles", "nombre", "nombre = '" + this.iface.datosConsulta_["tabla"] + ".mtd'")) {
		this.iface.datosConsulta_["ok"] = false;
		MessageBox.warning(util.translate("scripts", "No existe la tabla %1 indicada en clave de la consulta %2").arg(this.iface.datosConsulta_["tabla"]).arg(codConsulta), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var campoNombre:String = util.sqlSelect("crm_consultasmark", "camponombre", "codconsulta = '" + codConsulta + "'");
	if (!campoNombre) {
		this.iface.datosConsulta_["ok"] = false;
		MessageBox.warning(util.translate("scripts", "Error al obtener el campo nombre de la consulta asociada"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var datosNombre:Array = campoNombre.split(".");
	if (!datosNombre || datosNombre.length != 2) {
		this.iface.datosConsulta_["ok"] = false;
		MessageBox.warning(util.translate("scripts", "Error al analizar el campo clave de la consulta asociada"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	this.iface.datosConsulta_["nombre"] = datosNombre[1];
	return true;
}

/** \D Carga en un array global la lista de valores en la tabla de elementos de lista manual
\end */
function oficial_leerListaManual():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var codLista:String = cursor.valueBuffer("codlista");
	if (this.iface.seleccionValores_) {
		delete this.iface.seleccionValores_;
	}
	this.iface.seleccionValores_ = [];

	var qryClaves:FLSqlQuery = new FLSqlQuery;
	qryClaves.setTablesList("crm_elementoslista");
	qryClaves.setSelect("clave");
	qryClaves.setFrom("crm_elementoslista");
	qryClaves.setWhere("codlista = '" + codLista + "'");
	qryClaves.setForwardOnly(true);
	if (!qryClaves.exec()) {
		return false;
	}
	var i:Number = 0;
	while (qryClaves.next()) {
		this.iface.seleccionValores_[i] = qryClaves.value("clave");
	}
	return true;
}

/** \D Escribe la lista manual a partir de un array global
\end */
function oficial_escribirListaManual():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var codLista:String = cursor.valueBuffer("codlista");

	if (!util.sqlDelete("crm_elementoslista", "codlista = '" + codLista + "'")) {
		return false;
	}
	if (!this.iface.seleccionValores_) {
		return false;
	}
	var curEL:FLSqlCursor = new FLSqlCursor("crm_elementoslista");
	var valorClave:String;
	for (var i:Number = 0; i < this.iface.seleccionValores_.length; i++) {
		valorClave = this.iface.seleccionValores_[i];
		curEL.setModeAccess(curEL.Insert);
		curEL.refreshBuffer();
		curEL.setValueBuffer("codlista", codLista);
		curEL.setValueBuffer("clave", valorClave);
		curEL.setValueBuffer("nombre", util.sqlSelect(this.iface.datosConsulta_["tabla"], this.iface.datosConsulta_["nombre"], this.iface.datosConsulta_["clave"] + " = '" + valorClave + "'"));
		if (!curEL.commitBuffer()) {
			return false;
		}
	}
	this.child("tdbElementosLista").refresh();
	return true;
}

function oficial_bufferChanged(fN:String)
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	switch (fN) {
		case "manual": {
			this.iface.habilitarPorManual();
			break;
		}
		case "importanalisis": {
			this.iface.habilitarPorImportada();
			break;
		}
	}
}

function oficial_habilitarPorImportada()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	if (cursor.valueBuffer("importanalisis")) {
		this.child("tbnBuscarListaAnalisis").enabled = true;
		this.child("tbnActualizarListaAnalisis").enabled = true;
	} else {
		this.child("tbnBuscarListaAnalisis").enabled = false;
		this.child("tbnActualizarListaAnalisis").enabled = false;
	}
}

function oficial_habilitarPorManual()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	if (cursor.valueBuffer("manual")) {
		this.child("tbwLista").setTabEnabled("listamanual", true);
	} else {
		this.child("tbwLista").setTabEnabled("listamanual", false);
	}
}

function oficial_tbnBuscarListaAnalisis_clicked()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	if (cursor.modeAccess() == cursor.Insert) {
		if (!this.child("tdbElementosLista").cursor().commitBufferCursorRelation()) {
			return false;
		}
	}

	var codLista:String = cursor.valueBuffer("codlista");

	if (!sys.isLoadedModule("fldireinne")) {
		MessageBox.warning(util.translate("scripts", "Para usar esta funcionalidad debe tener instalado el módulo de análisis"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	if (!formin_navegador.iface.pub_conectar()) {
		MessageBox.warning(util.translate("scripts", "Error al conectar a la base de datos de Anásis"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	var idPos:String = formin_navegador.iface.pub_seleccionarPosicion("");
	if (!idPos) {
		return;
	}
	var aPos:Array = formin_navegador.iface.pub_datosPosicion(idPos);
	if (!aPos) {
		return false;
	}
	cursor.setValueBuffer("posanalisis", aPos["posicion"]);
	cursor.setValueBuffer("cuboanalisis", aPos["cubo"]);

	if (!flcrm_mark.iface.pub_actualizarListaAnalisis(cursor)) {
		return false;
	}

	this.child("tdbElementosLista").refresh();
	MessageBox.information(util.translate("scripts", "La lista %1 ha sido importada correctamente").arg(aPos["nombre"]), MessageBox.Ok, MessageBox.NoButton);
	
}

function oficial_tbnActualizarListaAnalisis_clicked()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var posicion:String = cursor.valueBuffer("posanalisis");
	if (!posicion || posicion == "") {
		MessageBox.warning(util.translate("scripts", "No hay una posición cargada que refrescar.\nSeleciona la posición a asociar a la lista."), MessageBox.Ok, MessageBox.NoButton);
		this.iface.tbnBuscarListaAnalisis_clicked();
	}
	if (!flcrm_mark.iface.pub_actualizarListaAnalisis(cursor)) {
		return false;
	}

	this.child("tdbElementosLista").refresh();
	MessageBox.information(util.translate("scripts", "La lista ha sido actualizada correctamente"), MessageBox.Ok, MessageBox.NoButton);
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
