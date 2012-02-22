/***************************************************************************
                  flmaveppal.qs  -  description
                             -------------------
    begin                : lun mar 28 2005
    copyright            : (C) 2005 by InfoSiAL S.L.
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

	function beforeCommit_mv_funcional(curTab:FLSqlCursor):Boolean {
		return this.ctx.interna_beforeCommit_mv_funcional(curTab);
	}
	
	function afterCommit_mv_funcional(curInc) {
		return this.ctx.interna_afterCommit_mv_funcional(curInc);
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    function oficial( context ) { interna( context ); } 
	function anadirAConfig(idFuncional:String, codProyecto:String):Boolean {
		return this.ctx.oficial_anadirAConfig(idFuncional, codProyecto);
	}
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends oficial {
	var versionOficial:String;
	var pathLocal:String;
	var pathPeso:String;
	var urlRepositorioMod:String;
	var urlRepositorioFun:String;
	var urlRepositorioWebOficial:String;
	var urlRepositorioWebFun:String;
	var tipoDocActual:String;
	var funcionalActual:String;
	var xmlDif:FLDomDocument;
	var xmlPrevio:FLDomDocument;
	var localEnc_:String;

	function head( context ) { oficial ( context ); }
	function init() {
		return this.ctx.head_init();
	}
	function obtenerPathLocal():String {
		return this.ctx.head_obtenerPathLocal();
	}
	function cambiarPathLocal(dirActual:String):Boolean {
		return this.ctx.head_cambiarPathLocal(dirActual);
	}
	function obtenerPathPeso():String {
		return this.ctx.head_obtenerPathPeso();
	}
	function cambiarPathPeso(dirActual:String):Boolean {
		return this.ctx.head_cambiarPathPeso(dirActual);
	}
	function obtenerUrlRepositorioMod():String {
		return this.ctx.head_obtenerUrlRepositorioMod();
	}
	function obtenerUrlRepositorioFun():String {
		return this.ctx.head_obtenerUrlRepositorioFun();
	}
	function obtenerUrlRepositorioWebOficial():String {
		return this.ctx.head_obtenerUrlRepositorioWebOficial();
	}
	function obtenerUrlRepositorioWebFun():String {
		return this.ctx.head_obtenerUrlRepositorioWebFun();
	}
	function obtenerVersionOficial():String {
		return this.ctx.head_obtenerVersionOficial();
	}
	function cambiarVersionOficial(versionActual:String):Boolean {
		return this.ctx.head_cambiarVersionOficial(versionActual);
	}
	function ejecutarComando(comando:String):Array {
		return this.ctx.head_ejecutarComando(comando);
	}
	function obtenerXmlDif(ruta1:String, ruta2:String, codFuncional:String):String {
		return this.ctx.head_obtenerXmlDif(ruta1, ruta2, codFuncional);
	}
	function compararNodos(nodo1:FLDomNode, nodo2:FLDomNode, ruta:String, idNodo:String):Boolean {
		return this.ctx.head_compararNodos(nodo1, nodo2, ruta, idNodo);
	}
	function obtenerIdNodo(nodo:FLDomNode, nomNodo:String, numNodo:String):Array {
		return this.ctx.head_obtenerIdNodo(nodo, nomNodo, numNodo);
	}
	function buscarNodoPorId(nodoPadre:FLDomNode, nombreNodo:String, id:Array):FLDomNode {
		return this.ctx.head_buscarNodoPorId(nodoPadre, nombreNodo, id);
	}
	function preprocesarNodo(nodo:FLDomNode):FLDomNode {
		return this.ctx.head_preprocesarNodo(nodo);
	}
	function obtenerNodoImagen(doc:FLDomDocument, nombre:String):FLDomNode {
		return this.ctx.head_obtenerNodoImagen(doc, nombre);
	}
	function anadirNodoDif(txt:String, nodo:FLDomNode):Boolean {
		return this.ctx.head_anadirNodoDif(txt, nodo);
	}
	function anadirNodoLista(listaNodos:Array, nomNodo:String):Array {
		return this.ctx.head_anadirNodoLista(listaNodos, nomNodo);
	}
	function buscarNodoLista(listaNodos:Array, nomNodo:String):Number {
		return this.ctx.head_buscarNodoLista(listaNodos, nomNodo);
	}
	function obtenerScriptDif(ruta1:String, ruta2:String, codFuncional:String):String {
		return this.ctx.head_obtenerScriptDif(ruta1, ruta2, codFuncional);
	}
	function obtenerPhpDif(ruta1:String, ruta2:String, codFuncional:String):String {
		return this.ctx.head_obtenerPhpDif(ruta1, ruta2, codFuncional);
	}
	function compararScripts(contenido1:String, contenido2:String):String {
		return this.ctx.head_compararScripts(contenido1, contenido2);
	}
	function compararPhps(contenido1:String, contenido2:String):String {
		return this.ctx.head_compararPhps(contenido1, contenido2);
	}
	function listaClases(contenido:String):Array {
		return this.ctx.head_listaClases(contenido);
	}
	function listaClasesPhp(contenido:String):Array {
		return this.ctx.head_listaClasesPhp(contenido);
	}
	function obtenerNombreClase(contenido:String, pos:Number):String {
		return this.ctx.head_obtenerNombreClase(contenido, pos);
	}
	function buscarClase(nombre:String, tipo:String, lista:Array):Number {
		return this.ctx.head_buscarClase(nombre, tipo, lista);
	}
	function obtenerNombreClaseBase(contenido:String, pos:Number, clase:String):String {
		return this.ctx.head_obtenerNombreClaseBase(contenido, pos, clase);
	}
	function gestionConfXml(contenidoParche:String, contenidoActual:String):String {
		return this.ctx.head_gestionConfXml(contenidoParche, contenidoActual);
	}
	function gestionConfScript(qsDif:String, qsActual:String):String {
		return this.ctx.head_gestionConfScript(qsDif, qsActual);
	}
	function gestionConfPhp(phpDif:String, phpActual:String):String {
		return this.ctx.head_gestionConfPhp(phpDif, phpActual);
	}
	function obtenerTipoNodo(nomNodo:String):String {
		return this.ctx.head_obtenerTipoNodo(nomNodo);
	}
	function aplicarParche(codFuncional:String, dirParche:String, dirDest:String):Boolean {
		return this.ctx.head_aplicarParche(codFuncional, dirParche, dirDest);
	}
	function aplicarParcheNodo(nodo:FLDomNode, dirParche:String, dirOrig:String, dirDest:String):Boolean {
		return this.ctx.head_aplicarParcheNodo(nodo, dirParche, dirOrig, dirDest);
	}
	function obtenerListaDep(codFuncional:String):Array {
		return this.ctx.head_obtenerListaDep(codFuncional);
	}
	function buscarPalabra(palabra:String, lista:Array):Number {
		return this.ctx.head_buscarPalabra(palabra, lista);
	}
	function sinDependencias(codFuncional:String, listaDep:Array):Boolean {
		return this.ctx.head_sinDependencias(codFuncional, listaDep);
	}
	function obtenerListaDepDes(codFuncional:String):Array {
		return this.ctx.head_obtenerListaDepDes(codFuncional);
	}
	function obtenerListaDepCliente(idCliente:String):Array {
		return this.ctx.head_obtenerListaDepCliente(idCliente);
	}
	function ordenarListaDep(listaDesordenada:Array):Array {
		return this.ctx.head_ordenarListaDep(listaDesordenada);
	}
	function checkoutMods(codFuncional:String, dirDestino1:String, dirDestino2:String, versionBase:String):Boolean {
		return this.ctx.head_checkoutMods(codFuncional, dirDestino1, dirDestino2, versionBase);
	}
	function checkoutParche(codFuncional:String, dirParche:String, versionBase:String):Boolean {
		return this.ctx.head_checkoutParche(codFuncional, dirParche, versionBase);
	}
	function ordenarNodos(listaNodos:FLDomNodeList):Array {
		return this.ctx.head_ordenarNodos(listaNodos);
	}
	function obtenerIdMin(lista:Array):Number {
		return this.ctx.head_obtenerIdMin(lista);
	}
	function compararIds(id1:Array, id2:Array):Number {
		return this.ctx.head_compararIds(id1, id2);
	}
	function guardarModsXml(listaMod:Array, ruta:String):Boolean {
		return this.ctx.head_guardarModsXml(listaMod, ruta);
	}
	function guardarModXml(mod:Array, ruta:String):Boolean {
		return this.ctx.head_guardarModXml(mod, ruta);
	}
	function obtenerIndiceMin(lista:Array):Number {
		return this.ctx.head_obtenerIndiceMin(lista);
	}
	function buscarUltClaseDerivada(listaClases:Array):String {
		return this.ctx.head_buscarUltClaseDerivada(listaClases);
	}
	function buscarUltClaseDerivadaPhp(listaClases:Array):String {
		return this.ctx.head_buscarUltClaseDerivadaPhp(listaClases);
	}
	function anadirTest(rutaDirTest:String, codFuncional:String):Boolean {
		return this.ctx.head_anadirTest(rutaDirTest, codFuncional);
	}
	function reemplazar(texto:String, antes:String, despues:String):String {
		return this.ctx.head_reemplazar(texto, antes, despues);
	}
	function cargarCodificacionLocal() {
		return this.ctx.head_cargarCodificacionLocal();
	}
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration ifaceCtx */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends head {
	var pub_log:Object;
	
	function ifaceCtx( context ) { head( context ); }
	function pub_obtenerPathLocal():String {
		return this.obtenerPathLocal();
	}
	function pub_obtenerPathPeso():String {
		return this.obtenerPathPeso();
	}
	function pub_obtenerUrlRepositorioMod():String {
		return this.obtenerUrlRepositorioMod();
	}
	function pub_obtenerUrlRepositorioFun():String {
		return this.obtenerUrlRepositorioFun();
	}
	function pub_obtenerUrlRepositorioWebOficial():String {
		return this.obtenerUrlRepositorioWebOficial();
	}
	function pub_obtenerUrlRepositorioWebFun():String {
		return this.obtenerUrlRepositorioWebFun();
	}
	function pub_obtenerVersionOficial():String {
		return this.obtenerVersionOficial();
	}
	function pub_obtenerPathRepositorio():String {
		return this.obtenerPathRepositorio();
	}
	function pub_ejecutarComando(comando:String):Array {
		return this.ejecutarComando(comando);
	}
	function pub_obtenerXmlDif(ruta1:String, ruta2:String, codFuncional:String):String {
		return this.obtenerXmlDif(ruta1, ruta2, codFuncional);
	}
	function pub_obtenerScriptDif(ruta1:String, ruta2:String, codFuncional:String):String {
		return this.obtenerScriptDif(ruta1, ruta2, codFuncional);
	}
	function pub_obtenerPhpDif(ruta1:String, ruta2:String, codFuncional:String):String {
		return this.obtenerPhpDif(ruta1, ruta2, codFuncional);
	}
	function pub_aplicarParche(codFuncional:String, dirParche:String, dirDest:String):Boolean {
		return this.aplicarParche(codFuncional, dirParche, dirDest);
	}
	function pub_aplicarParcheNodo(nodo:FLDomNode, dirParche:String, dirOrig:String, dirDest:String):Boolean {
		return this.aplicarParcheNodo(nodo, dirParche, dirOrig, dirDest);
	}
	function pub_obtenerListaDep(codFuncional:String):Array {
		return this.obtenerListaDep(codFuncional);
	}
	function pub_obtenerListaDepCliente(idCliente:String):Array {
		return this.obtenerListaDepCliente(idCliente);
	}
	function pub_checkoutMods(codFuncional:String, dirDestino1:String, dirDestino2:String, versionBase:String):Boolean {
		return this.checkoutMods(codFuncional, dirDestino1, dirDestino2, versionBase);
	}
	function pub_checkoutParche(codFuncional:String, dirParche:String, versionBase:String):Boolean {
		return this.checkoutParche(codFuncional, dirParche, versionBase);
	}
	function pub_cambiarPathLocal(dirActual):Boolean {
		return this.cambiarPathLocal(dirActual);
	}
	function pub_cambiarVersionOficial(versionActual:String):Boolean {
		return this.cambiarVersionOficial(versionActual);
	}
	function pub_anadirTest(rutaDirTest:String, codFuncional:String):Boolean {
		return this.anadirTest(rutaDirTest, codFuncional);
	}
	function pub_anadirAConfig(idFuncional:String, codProyecto:String):Boolean {
		return this.anadirAConfig(idFuncional, codProyecto);
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
function interna_init() {

}

function interna_beforeCommit_mv_funcional(cursor:FLSqlCursor):Boolean {
	flsistwebi.iface.pub_setModificado(cursor);
	return true;
}

function interna_afterCommit_mv_funcional(cursor:FLSqlCursor):Boolean {
	flsistwebi.iface.pub_setBorrado(cursor);
	return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Añade al directorio config el fichero de parche .xml asociado a una funcionalidad. Añade también un nodo al fichero xml de configuración del proyecto. Estos datos son leídos por el módulo de documentación para realizar documentación de proyectos
@param idFuncional: Identificador de la funcionalidad que se añade
@param	codProyecto: Identificador del proyecto o funcionalidad que se genera
@return True si la adición se realiza correctamente, false en caso contrario
\end */
function oficial_anadirAConfig(idFuncional:String, codProyecto:String):Boolean
{
	// Función obsoleta
	return true;

	var contenido:String;
	if (idFuncional == codProyecto) 
		contenido = File.read(this.iface.pathLocal + codProyecto + "/" + idFuncional + "/" + idFuncional + ".xml");
	else
		contenido = File.read(this.iface.pathLocal + codProyecto + "/temp/" + idFuncional + ".xml");
		
	File.write(this.iface.pathLocal + codProyecto + "/config/" + idFuncional + ".xml", contenido);
	
	var xmlConfig:FLDomDocument = new FLDomDocument();
	var xmlAux:FLDomDocument = new FLDomDocument();
	
	if (File.exists(this.iface.pathLocal + codProyecto + "/config/config.xml")) 
		contenido = File.read(this.iface.pathLocal + codProyecto + "/config/config.xml");
	else
		contenido = "<flmaveconfig:client name =\"" + codProyecto + "\"/>";

	if (!xmlConfig.setContent(contenido))
		return false;

	if (!xmlAux.setContent("<flmaveconfig:patch name =\"" + idFuncional + "\"/>"))
		return false;
		
	xmlConfig.firstChild().appendChild(xmlAux.firstChild());
	File.write(this.iface.pathLocal + codProyecto + "/config/config.xml", xmlConfig.toString(4));

	return true; 
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
/** \D Obtiene la ruta al directorio de desarrollo
@return	Ruta al directorio
\end */
function head_obtenerPathLocal():String {
	var util:FLUtil = new FLUtil;
	if (!this.iface.pathLocal) {
		this.iface.pathLocal = util.readSettingEntry("scripts/flmaveppal/pathlocal");
		if (!this.iface.pathLocal) {
			MessageBox.information(util.translate("scripts", "No hay un directorio de trabajo establecido, por favor, seleccione el directorio"), MessageBox.Ok, MessageBox.NoButton);
			this.iface.cambiarPathLocal("");
		}
	}
	
	return this.iface.pathLocal;
}

/** \D Obtiene la ruta al directorio de modulos que se usa para obtener el peso de un parche
@return	Ruta al directorio
\end */
function head_obtenerPathPeso():String {
	/*
	var util:FLUtil = new FLUtil;
	if (!this.iface.pathPeso) {
		this.iface.pathPeso = util.readSettingEntry("scripts/flmaveppal/pathpeso");
		if (!this.iface.pathPeso ) {
			MessageBox.information(util.translate("scripts", "No hay un directorio de referencia para obtener el peso de los parches, por favor, seleccione el directorio"), MessageBox.Ok, MessageBox.NoButton);
			this.iface.cambiarPathPeso("");
		}
	}
OBSOLETO
	*/
	
	return this.iface.pathPeso;
}

/** \D Obtiene la versión oficial de los módulos a utilizar

@return	Nombre de la versión
\end */
function head_obtenerVersionOficial():String 
{
	var util:FLUtil = new FLUtil;
	if (!this.iface.versionOficial) {
		this.iface.versionOficial = util.readSettingEntry("scripts/flmaveppal/versionoficial");
		if (!this.iface.versionOficial) {
			MessageBox.information(util.translate("scripts", "No hay una versión de los módulos oficiales establecida, por favor, seleccione una"), MessageBox.Ok, MessageBox.NoButton);
			this.iface.cambiarVersionOficial("");
		}
	}
	return this.iface.versionOficial;
}

/** \D Cambia el directorio de trabajo local

@param	dirActual: Ruta al nuevo directorio
@return	True si no hay error, false en caso contrario
\end */
function head_cambiarPathLocal(dirActual:String):Boolean
{
	var util:FLUtil = new FLUtil;
	var directorio:String = FileDialog.getExistingDirectory(dirActual);
	if (!directorio)
		return false;
	
	util.writeSettingEntry("scripts/flmaveppal/pathlocal", directorio);
	this.iface.pathLocal = util.readSettingEntry("scripts/flmaveppal/pathlocal");
	return true;
}

/** \D Cambia el directorio de referencia para obtener el peso de los parches

@param	dirActual: Ruta al nuevo directorio
@return	True si no hay error, false en caso contrario
\end */
function head_cambiarPathPeso(dirActual:String):Boolean
{
/*	var util:FLUtil = new FLUtil;
	var directorio:String = FileDialog.getExistingDirectory(dirActual);
	if (!directorio)
		return false;
			
	util.writeSettingEntry("scripts/flmaveppal/pathpeso", directorio);
	this.iface.pathPeso = util.readSettingEntry("scripts/flmaveppal/pathpeso");
	return true;
OBSOLETO
*/
}

/** \D Cambia el nombre de la versión oficial de los módulos

@param	versionActual: Nuevo nombre de la versión oficial
@return	True si no hay error, false en caso contrario
\end */
function head_cambiarVersionOficial(versionActual:String):Boolean
{
	var util:FLUtil = new FLUtil;
	
	var resComando:Array = this.iface.ejecutarComando("svn ls " + this.iface.obtenerUrlRepositorioMod() + "oficial/");
	if (resComando.ok == false) {
		if (this.iface.pub_log) {
			this.iface.pub_log.child("log").append("Error al listar el repositorio en " + this.iface.urlRepositorio + "oficial/");
		}
		return false;
	}
	var opciones:Array = resComando.salida.split("\n");
	opciones.pop();
	var version = Input.getItem("Selecciona la versión", opciones, "", false, "Versión de módulos oficiales");
	if (!version)
		return false; 
	
	util.writeSettingEntry("scripts/flmaveppal/versionoficial", version);
	this.iface.versionOficial = util.readSettingEntry("scripts/flmaveppal/versionoficial");
	return true;
}

/** \D Crea el registro de configuración si no existía ya.
\end */
function head_init() {
	var cursor:FLSqlCursor = new FLSqlCursor("mv_config");
	var util:FLUtil = new FLUtil();
	cursor.select();
	if (!cursor.first()) {
		MessageBox.information(util.translate("scripts", "No hay valores de configuración, debe crear estos valores para comenzar a trabajar."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		this.execMainScript("mv_config");
	}
	this.iface.cargarCodificacionLocal();
}

/** \D Obtiene la url del repositorio de módulos

@return	Valor de la URL
\end */
function head_obtenerUrlRepositorioMod():String {
	var util:FLUtil = new FLUtil();
	if (!this.iface.urlRepositorioMod)
		this.iface.urlRepositorioMod = util.sqlSelect("mv_config", "urlrepositoriomod", "1 = 1");
	
	return this.iface.urlRepositorioMod;
}

/** \D Obtiene la url del repositorio de funcionalidades

@return	Valor de la URL
\end */
function head_obtenerUrlRepositorioFun():String {
	var util:FLUtil = new FLUtil();
	if (!this.iface.urlRepositorioFun)
		this.iface.urlRepositorioFun = util.sqlSelect("mv_config", "urlrepositoriofun", "1 = 1");
	
	return this.iface.urlRepositorioFun;
}

/** \D Obtiene la url del repositorio de codigo web oficial

@return	Valor de la URL
\end */
function head_obtenerUrlRepositorioWebOficial():String {
	var util:FLUtil = new FLUtil();
	if (!this.iface.urlRepositorioWebOficial)
		this.iface.urlRepositorioWebOficial = util.sqlSelect("mv_config", "urlrepositorioweboficial", "1 = 1");
	
	return this.iface.urlRepositorioWebOficial;
}

/** \D Obtiene la url del repositorio de código web funcional

@return	Valor de la URL
\end */
function head_obtenerUrlRepositorioWebFun():String {
	var util:FLUtil = new FLUtil();
	if (!this.iface.urlRepositorioWebFun)
		this.iface.urlRepositorioWebFun = util.sqlSelect("mv_config", "urlrepositoriowebfun", "1 = 1");
	
	return this.iface.urlRepositorioWebFun;
}

/** \D
Ejecuta un comando externo
@param	comando: Comando a ejecutar
@return	Array con dos datos: 
	ok: True si no hay error, false en caso contrario
	salida: Mensaje de stdout o stderr obtenido
\end */
function head_ejecutarComando(comando:String):Array
{
	var res:Array = [];
	Process.execute(comando);
debug(comando);
	//this.iface.pub_log.child("log").append(comando);
	if (Process.stderr != "") {
		res["ok"] = false;
		res["salida"] = Process.stderr;
		if (this.iface.pub_log) {
			this.iface.pub_log.child("log").append("Error al ejecutar el comando: " + comando + "\n" + Process.stderr);
			this.iface.pub_log.child("log").append(res.salida);
		}
	} else {
		res["ok"] = true;
		res["salida"] = Process.stdout;
	}

	return res;
}

/** Obtiene el fichero xml de las modificaciones (parche) que hay que hacer al fichero 1 para convertirlo en el fichero 2
@param	ruta1: Ruta al primer fichero
@param	ruta2: Ruta al segundo fichero
@param	codFuncional: Código de la funcionalidad que se está tratando
@return	Documento xml de diferencias o false si hay error
*/
function head_obtenerXmlDif(ruta1:String, ruta2:String, codFuncional:String):String
{
	var contenido:String;
	this.iface.tipoDocActual = ruta1.substring(ruta1.findRev(".") + 1, ruta1.length);
	this.iface.funcionalActual = codFuncional;
	
	if (!File.exists(ruta1)) {
		this.iface.pub_log.child("log").append("No se encuentra el fichero " + ruta1);
		return false;
	}
	contenido = File.read(ruta1);
	this.iface.xmlPrevio = new FLDomDocument();
	//var xml1:FLDomDocument = new FLDomDocument();
	//xml1.setContent(contenido);
	this.iface.xmlPrevio.setContent(contenido);

	if (!File.exists(ruta2)) {
		this.iface.pub_log.child("log").append("No se encuentra el fichero " + ruta2);
		return false;
	}
	contenido = File.read(ruta2);
	var xml2:FLDomDocument = new FLDomDocument();
	xml2.setContent(contenido);

	if (this.iface.xmlDif)
		delete this.iface.xmlDif;
	this.iface.xmlDif = new FLDomDocument();

	
	this.iface.xmlDif.setContent("<xupdate:modifications/>")
	if (!this.iface.compararNodos(this.iface.xmlPrevio.firstChild(), xml2.firstChild(), "", "")) {
		this.iface.pub_log.child("log").append("Error comparando ficheros");
		return false;
	}

	var resultado:String = this.iface.xmlDif.toString();
	return resultado;
}

/** \D Compara dos nodos anotando las diferencias en un documento xml

@param	nodo1: Primer nodo a comparar
@param	nodo2: Segundo nodo a comparar
@param	ruta: ruta al nodo comparado
@return	True si son iguales, false en caso contrario
\end */
function head_compararNodos(nodo1:FLDomNode, nodo2:FLDomNode, ruta:String, idNodo:String):Boolean
{
	var lista1:FLDomNodeList = nodo1.childNodes();
	var lista2:FLDomNodeList = nodo2.childNodes();
	
	var lo1:Array = this.iface.ordenarNodos(lista1);
	var lo2:Array = this.iface.ordenarNodos(lista2);
	
	var nombreHijo1:String;
	var nombreHijo2:String;
	
	var indiceLo1 = 0;
	var indiceLo2 = 0;
	var nodoHijo1:FLDomNode;
	var nodoHijo2:FLDomNode;
	
	var listaMod:Array = [];
	
	if (ruta == "")
		ruta = "/" + nodo2.nodeName() + "[" + nodo2.nodeName() + ",1]";
	else
		ruta += "/" + nodo2.nodeName() + "[" + idNodo + "]";

	var limite1:Number = lo1.length;// - 1;
	var limite2:Number = lo2.length;// - 1;

	var comparacion:Number;
	do {
		if (indiceLo1 == limite1) {
			nodoHijo2 = lista2.item(lo2[indiceLo2].indice);
			nombreHijo2 = nodoHijo2.nodeName();
			comparacion = 1;
		} else if (indiceLo2 == limite2) {
			nodoHijo1 = lista1.item(lo1[indiceLo1].indice);
			nombreHijo1 = nodoHijo1.nodeName();
			comparacion = 2;
		} else {
			nodoHijo1 = lista1.item(lo1[indiceLo1].indice);
			nombreHijo1 = nodoHijo1.nodeName();
			nodoHijo2 = lista2.item(lo2[indiceLo2].indice);
			nombreHijo2 = nodoHijo2.nodeName();
			comparacion = this.iface.compararIds(lo1[indiceLo1].id, lo2[indiceLo2].id);
		}
		switch (comparacion) {
			case 0:
				if (nodoHijo2.nodeName() == "#text") {
					if (nodo1.toElement().text() == nodo2.toElement().text()) {
						return true;
					} else {
						txt = "<xupdate:update select=\"" + ruta + "/text()[1]\">" + nodo2.toElement().text()  + "</xupdate:update>";
						if (!this.iface.anadirNodoDif(txt))
							return false;
						return true;
					}
				}
				if (!nodoHijo2.isEqualNode(nodoHijo1)) {
					if (!this.iface.compararNodos(nodoHijo1, nodoHijo2, ruta, lo2[indiceLo2].id)) {
						this.iface.pub_log.child("log").append("Error en los nodos hijos de " + ruta);
						return false;
					}
				}
				indiceLo1++;
				indiceLo2++;
				break;
			case 1:
				var i:Number = listaMod.length;
				listaMod[i] = [];
				listaMod[i].indice = lo2[indiceLo2].indice;
				listaMod[i].nodo = nodoHijo2;
				indiceLo2++;
				break;
			case 2:
				var txt:String;
				txt = "<xupdate:delete select=\"" + ruta + "/" + nombreHijo1 + "[" + lo1[indiceLo1].id + "]\"/>";
				if (!this.iface.anadirNodoDif(txt))
					return false;
				indiceLo1++;
				break;
		}
	} while (indiceLo1 < limite1 || indiceLo2 < limite2);

	if (!this.iface.guardarModsXml(listaMod, ruta))
		return false;
	return true;
}

/** \D Guarda en el documento xml de diferencias los nodos <xupdate:insert-after> o <xupdate:append-first> en el orden correcto, de forma que los nodos de referencia en el atributo 'select'.

@param	listaMod: Array con los datos de los nodos a guardar:
	indice del nodo en el documento original (valor por el que se ordenará)
	nodo: objeto nodo a insertar
@param	ruta: ruta al nodo padre de los nodos a insertar
@return	True si no hay error, false en caso contrario
\end */
function head_guardarModsXml(listaMod:Array, ruta:String):Boolean
{
	var indiceMin:Number;
	for (var i:Number = 0; i < listaMod.length; i++) {
		indiceMin = this.iface.obtenerIndiceMin(listaMod);
		if (!this.iface.guardarModXml(listaMod[indiceMin], ruta))
			return false;
		listaMod[indiceMin].indice = -1;
	}
	return true;
}

/** \D Obtiene el índice del elemento del array cuyo valor 'indice' es el mínimo mayor que -1

@param	lista: Array con los datos de los nodos:
	indice del nodo en el documento original (valor por el que se ordenará)
	nodo: objeto nodo a insertar
@return	Índice del elemento con valor mínimo
\end */
function head_obtenerIndiceMin(lista:Array):Number
{
	var res:Number = 0;
	while (lista[res].indice == -1)
		res++;
	
	var indice:Number = res;
	while (indice < lista.length) {
		if (lista[indice].indice > -1) {
			if (lista[res].indice > lista[indice].indice)
				res = indice;
		}
		indice++;
	}
	return res;
}

/** \D Guarda un nodo xml de tipo <xupdate:insert-after> o <xupdate:append-first> en el documento xml de diferencias

@param	mod: Array con los datos del nodo a insertar:
	indice del nodo en el documento original (valor por el que se ordenará)
	nodo: objeto nodo a insertar
@param	ruta: ruta al nodo padre del nodo a insertar
@return	True si no hay error, false en caso contrario
\end */
function head_guardarModXml(mod:Array, ruta:String):Boolean
{
	var txt:String;
	var nodoPrevio = mod.nodo.previousSibling();
	if (nodoPrevio) {
		var indicePrevio:Number = 0;
		for (var nodoAux:FLDomNode = nodoPrevio; nodoAux; nodoAux = nodoAux.previousSibling()) {
			if (nodoAux.nodeName() == nodoPrevio.nodeName())
				indicePrevio++;
		}
		var idPrevio:Array = this.iface.obtenerIdNodo(nodoPrevio, nodoPrevio.nodeName(), indicePrevio);
		txt = "<xupdate:insert-after select=\"" + ruta + "/" + nodoPrevio.nodeName() + "[" + idPrevio + "]\"/>";
	} else {
		txt = "<xupdate:append-first select=\"" + ruta + "\"/>";
	}
	if (!this.iface.anadirNodoDif(txt, mod.nodo))
		return false;

	return true;
}

/** \D Ordena una lista de nodos por el valor del Id de cada uno de ellos
@param	listaNodos: Objeto de lista de nodos
@return	Array con los índices de los nodos ordenados. Los elementos de cada elemento del array son:
	indice: Índice que ocupa el nodo en la lista listaNodos
	nombre: Nombre del nodo
	id: Valor del id del nodo
\end */
function head_ordenarNodos(listaNodos:FLDomNodeList):Array
{
	var res:Array = [];
	if (!listaNodos)
		return res;

	var indice:Number = 0;
	var indiceNodo:Number;
	var arrayAux = [];
	var listaIds:Array = [];
	var nombreNodo:String;

	for (var i:Number = 0; i < listaNodos.length(); i++) {
		nombreNodo = listaNodos.item(i).nodeName();
		if (listaNodos.item(i).isComment()) {
			continue;
		}
		if (nombreNodo == "images") {
			continue;
		}
		listaIds = this.iface.anadirNodoLista(listaIds, nombreNodo);
		indiceNodo = this.iface.buscarNodoLista(listaIds, nombreNodo);
		arrayAux[indice] = [];
		arrayAux[indice].indice = i;
		arrayAux[indice].nombre = nombreNodo;
		arrayAux[indice].id = this.iface.obtenerIdNodo(listaNodos.item(i), nombreNodo, listaIds[indiceNodo].cuenta);
		indice++;
	}
	var indiceMin:Number;
	for (var i:Number = 0; i < arrayAux.length; i++) {
		indiceMin = this.iface.obtenerIdMin(arrayAux);
		res[i] = arrayAux[indiceMin];
		arrayAux[indiceMin] = 0;
	}
	return res;
}

/** \D Obtiene el índice del elemento del array cuyo valor 'id' es el mínimo. Los elementos con valor 0 son deshechados.

@param	lista: Array con los datos de los nodos:
	indice: Índice que ocupa el nodo en la lista listaNodos
	nombre: Nombre del nodo
	id: Valor del id del nodo
@return	Índice del elemento con valor mínimo
\end */
function head_obtenerIdMin(lista:Array):Number
{
	var res:Number = 0;
	while (lista[res] == 0)
		res++;
	
	var indice:Number = res;
	while (indice < lista.length) {
		if (lista[indice] != 0) {
			if (this.iface.compararIds(lista[res].id, lista[indice].id) == 1)
				res = indice;
		}
		indice++;
	}
	return res;
}

/** \D Compara los Ids de dos nodos, comparando uno a uno todos sus elementos

@param	id1: Primer Id a comparar
@param	id2: Segundo Id a comparar
@return	0 si son iguales, 1 si el primero es mayor, 2 si el segundo es mayor
\end */
function head_compararIds(id1:Array, id2:Array):Number
{
	for (var i:Number = 0; i < id1.length; i++) {
		if (id1[i] > id2[i])
			return 1;
		if (id2[i] > id1[i])
			return 2;
	}
	return 0;
}

/** \D
Obtiene el identificador unívoco de un nodo. Algunos nodos tienen valores únicos determinados por su significado funcional (p.e. los nodos 'field' están identificados por el valor de su nodo hijo 'name')

@param	nodo: Nodo cuyo identificado se desea extraer
@param	nomNodo: Nombre del nodo
@param	numNodo: Ordinal del nodo en la lista de nodos hermanos con el mismo nombre
@return	Array con los datos de identificación del nodo. Por defecto es la combinación nomNodo, numNodo
\end */
function head_obtenerIdNodo(nodo:FLDomNode, nomNodo:String, numNodo:String):Array
{
	var res:Array = [];
	switch(this.iface.tipoDocActual) {
		case "xml": 
			switch (nodo.nodeName()) {
				case "action":
					res[0] = nodo.namedItem("name").toElement().text();
					break;
				default:
					res[0] = nomNodo;
					res[1] = numNodo;
			}
			break;
	
		case "ui":
			switch (nodo.nodeName()) {
				case "action":
					if (nodo.parentNode().nodeName() == "actions" || nodo.parentNode().nodeName() == "actiongroup") {
						// actions
						res[0] = nodo.firstChild().firstChild().toElement().text();
					} else {
						// menubar/item, toolbars/toolbar
						res[0] = nodo.toElement().attribute("name");
					}
					break;
				case "image":
					// images
					res[0] = nodo.toElement().attribute("name");
					res[1] = nodo.namedItem("data").toElement().text();
					break;
				case "toolbar":
				case "spacer":
					// toolbars
					res[0] = nodo.firstChild().firstChild().toElement().text();
					break;
				case "widget":
					res[0] = nodo.toElement().attribute("class");
					res[1] = nodo.firstChild().firstChild().toElement().text();
					break;
				case "includehint":
					res[0] = nodo.toElement().text();
					break;
				case "connection":
					res[0] = nodo.namedItem("sender").toElement().text();
					res[1] = nodo.namedItem("signal").toElement().text();
					res[2] = nodo.namedItem("receiver").toElement().text();
					res[3] = nodo.namedItem("slot").toElement().text();
					break;
				case "item":
					if (nodo.parentNode().nodeName() == "menubar") {
						res[0] = nodo.toElement().attribute("name");
					} else {
						res[0] = nomNodo;
						res[1] = numNodo;
					}
					break;
				case "property":
					res[0] = nodo.toElement().attribute("name");
					break;
				default:
					res[0] = nomNodo;
					res[1] = numNodo;
			}
			break;
			
		case "mtd": 
			switch (nodo.nodeName()) {
				case "field":
					if (nodo.parentNode().nodeName() == "TMD") {
							res[0] = nodo.namedItem("name").toElement().text();
					} else {
							res[0] = nomNodo;
							res[1] = numNodo;
					}
					break;
				case "relation":
					res[0] = nodo.namedItem("table").toElement().text();
					res[1] = nodo.namedItem("field").toElement().text();
					break;
				case "associated":
					res[0] = nodo.namedItem("with").toElement().text();
					res[1] = nodo.namedItem("by").toElement().text();
					break;
				default:
					res[0] = nomNodo;
					res[1] = numNodo;
			}
			break;
	}
	return res;
}

/** \D
Busca un nodo determinado cuyo id coincida con el parámetro

@param	nodoPadre: Nodo padre del nodo buscado
@param	id: Array con los datos de identificación del nodo. Por defecto es la combinación nombre - número de nodo
@return	Nodo encontrado o 0 en caso de que no exista
\end */
function head_buscarNodoPorId(nodoPadre:FLDomNode, nombreNodo:String, id:Array):FLDomNode 
{
	var res:FLDomNode = 0;
	
	if (id.length > 1 && nombreNodo == id[0] && !isNaN(parseFloat(id[1]))) {
		var i:Number = 0;
		for (var nodo:FLDomNode = nodoPadre.firstChild(); nodo; nodo = nodo.nextSibling()) {
			if (nodo.nodeName() == id[0]) {
				if (++i == id[1]) {
					res = nodo;
					return res;
				}
			}
		}
	}
	
	switch(this.iface.tipoDocActual) {
		case "xml":
			switch(nombreNodo) {
				case "action":
					var listaAcciones:FLDomNodeList = nodoPadre.toElement().elementsByTagName("action")
					for (var j:Number = 0; j < listaAcciones.length(); j++) {
						if (listaAcciones.item(j).namedItem("name").toElement().text() == id[0]) {
							res = listaAcciones.item(j);
							break;
						}
					}
					return res;
					break;
			}
			break;
			
		case "ui":
			switch(nombreNodo) {
				case "action":
					switch (nodoPadre.nodeName()) {
						case "actions":
						case "actiongroup":
							var listaAcciones:FLDomNodeList = nodoPadre.toElement().elementsByTagName("action")
							for (var j:Number = 0; j < listaAcciones.length(); j++) {
								if (listaAcciones.item(j).firstChild().firstChild().toElement().text() == id[0]) {
									res = listaAcciones.item(j);
									break;
								}
							}
							return res;
							break;
						case "toolbar":
						case "item":
							var listaAcciones:FLDomNodeList = nodoPadre.toElement().elementsByTagName("action")
							for (var j:Number = 0; j < listaAcciones.length(); j++) {
								if (listaAcciones.item(j).toElement().attribute("name") == id[0]) {
									res = listaAcciones.item(j);
									break;
								}
							}
							return res;
							break;
					}
					break;
				case "property":
					var listaPropiedades:FLDomNodeList = nodoPadre.childNodes();
					for (var j:Number = 0; j < listaPropiedades.length(); j++) {
						if (listaPropiedades.item(j).nodeName() != "property") {
							continue;
						}
						if (listaPropiedades.item(j).toElement().attribute("name") == id[0]) {
							res = listaPropiedades.item(j);
							break;
						}
					}
					return res;
					break;
				case "item":
					switch (nodoPadre.nodeName()) {
						case "menubar":
							var listaItems:FLDomNodeList = nodoPadre.toElement().elementsByTagName("item")
							for (var j:Number = 0; j < listaItems.length(); j++) {
								if (listaItems.item(j).toElement().attribute("name") == id[0]) {
									res = listaItems.item(j);
									break;
								}
							}
							return res;
							break;
					}
					break;
				case "image":
					switch (nodoPadre.nodeName()) {
						case "images":
							var listaImagenes:FLDomNodeList = nodoPadre.toElement().elementsByTagName("image")
							for (var j:Number = 0; j < listaImagenes.length(); j++) {
								if (listaImagenes.item(j).toElement().attribute("name") == id[0] && 
									listaImagenes.item(j).namedItem("data").toElement().text() == id[1]) {
									res = listaImagenes.item(j);
									break;
								}
							}
							return res;
							break;
					}
					break;
					
				case "toolbar":
					switch (nodoPadre.nodeName()) {
						case "toolbars":
							var listaToolbars:FLDomNodeList = nodoPadre.toElement().elementsByTagName("toolbar");
							for (var j:Number = 0; j < listaToolbars.length(); j++) {
								if (listaToolbars.item(j).firstChild().firstChild().toElement().text() == id[0]) {
									res = listaToolbars.item(j);
									break;
								}
							}
							return res;
							break;
					}
					break;
				case "spacer":
					for (var nodo:FLDomNode = nodoPadre.firstChild(); nodo; nodo = nodo.nextSibling()) {
						if (nodo.nodeName() == "spacer" && nodo.firstChild().firstChild().toElement().text() == id[0]) {
							res = nodo;
							break;
						}
					}
					return res;
					break;
				case "connection":
					var listaConexiones:FLDomNodeList = nodoPadre.toElement().elementsByTagName("connection")
					for (var j:Number = 0; j < listaConexiones.length(); j++) {
						if (listaConexiones.item(j).namedItem("sender").toElement().text() == id[0] && listaConexiones.item(j).namedItem("signal").toElement().text() == id[1] && listaConexiones.item(j).namedItem("receiver").toElement().text() == id[2] && listaConexiones.item(j).namedItem("slot").toElement().text() == id[3]) {
								res = listaConexiones.item(j);
								break;
						}
					}
					return res;
					break;
				case "widget":
					var listaWidgets:FLDomNodeList = nodoPadre.toElement().elementsByTagName("widget");
					for (var j:Number = 0; j < listaWidgets.length(); j++) {
						if (listaWidgets.item(j).toElement().attribute("class") == id[0] &&
							listaWidgets.item(j).firstChild().firstChild().toElement().text() == id[1]) {
							res = listaWidgets.item(j);
							break;
						}
					}
					return res;
					break;
			case "includehint":
					var listaHints:FLDomNodeList = nodoPadre.toElement().elementsByTagName("includehint")
					for (var j:Number = 0; j < listaHints.length(); j++) {
						if (listaHints.item(j).toElement().text() == id[0]) {
							res = listaHints.item(j);
							break;
						}
					}
					return res;
					break;
			}
			break;
			
		case "mtd":
			switch(nombreNodo) {
				case "field":
					switch (nodoPadre.nodeName()) {
						case "TMD":
							var listaCampos:FLDomNodeList = nodoPadre.toElement().childNodes();
							for (var j:Number = 0; j < listaCampos.length(); j++) {
								if (listaCampos.item(j).nodeName() == "field") {
									if (listaCampos.item(j).namedItem("name").toElement().text() == id[0]) {
										res = listaCampos.item(j);
										break;
									}
								}
							}
							return res;
							break;
					}
					break;

				case "relation":
					var listaRelaciones:FLDomNodeList = nodoPadre.toElement().elementsByTagName("relation")
					for (var j:Number = 0; j < listaRelaciones.length(); j++) {
						if (listaRelaciones.item(j).namedItem("table").toElement().text() == id[0] &&
							listaRelaciones.item(j).namedItem("field").toElement().text() == id[1]) {
							res = listaRelaciones.item(j);
							break;
						}
					}
					return res;
					break;
					
				case "associated":
					var listaRelaciones:FLDomNodeList = nodoPadre.toElement().elementsByTagName("associated")
					for (var j:Number = 0; j < listaRelaciones.length(); j++) {
						if (listaRelaciones.item(j).namedItem("with").toElement().text() == id[0] &&
							listaRelaciones.item(j).namedItem("by").toElement().text() == id[1]) {
							res = listaRelaciones.item(j);
							break;
						}
					}
					return res;
					break;
			}
			break;
	}
	
	return res;
}

/** \D
Realiza ciertas acciones (generalmente añadir un prefijo al identificador del nodo) para evitar duplicidades al añadir un nodo nuevo al documento actual

@param	nodo: Nodo a añadir
@return	Nodo preprocesado o False si hay error
\end */
function head_preprocesarNodo(nodo:FLDomNode):FLDomNode
{
	var res:FLDomNode = nodo.cloneNode();
	
	switch(this.iface.tipoDocActual) {
		case "ui":
			var listaImagenes:FLDomNodeList = nodo.toElement().elementsByTagName("iconset");
			if (!listaImagenes)
				break;
			for (var j:Number = 0; j < listaImagenes.length(); j++) {
				var nombreImagen:String = listaImagenes.item(j).toElement().text();
				var nodoImagen:FLDomNode = this.iface.obtenerNodoImagen(nodo.ownerDocument(), nombreImagen);
				
				var nodoImagesPrevio:FLDomNode = this.iface.xmlPrevio.firstChild().namedItem("images");
				if (!nodoImagesPrevio) {
					var nodoImagesDif:FLDomNodeList = this.iface.xmlDif.elementsByTagName("images");
					if (!nodoImagesDif) {
						var txt = "<xupdate:append-first select=\"/UI[UI,1]\"> <images/> </xupdate:append-first>";
						if (!this.iface.anadirNodoDif(txt))
							return false;
					}
				}
				var txt = "<xupdate:append-first select=\"/UI[UI,1]/images[images,1]\" />";
				
				if (!nombreImagen.startsWith(this.iface.funcionalActual)) {
					nombreImagen = this.iface.funcionalActual + nombreImagen;
					nodoImagen.toElement().setAttribute("name", nombreImagen);
				}
				if (!this.iface.anadirNodoDif(txt, nodoImagen))
					return false;
					
				res.toElement().elementsByTagName("iconset").item(j).firstChild().setNodeValue(nombreImagen);
				
			}
			break;
	}
	return res;
}

/** \D Obtiene un nodo <UI><images><image> en un documento .ui con un determinado atributo name
@param	doc: xml correspondiente al documento ui
@param	nombre: valor del atributo name
@return	nodo <image>
\end */
function head_obtenerNodoImagen(doc:FLDomDocument, nombre:String):FLDomNode
{
	var nodoImages = doc.namedItem("UI").namedItem("images");
	var listaImagenes:FLDomNodeList = nodoImages.toElement().elementsByTagName("image")
	for (var j:Number = 0; j < listaImagenes.length(); j++) {
		if (listaImagenes.item(j).toElement().attribute("name") == nombre) {
			return listaImagenes.item(j).cloneNode();
		}
	}
	return 0;
}

/** \D Añade un nodo al documento de modificaciones
@param	txt: Texto del nodo a añadir
@param	nodo: Nodo hijo a añadir
@return	true si no hay error, false en caso contrario
\end */
function head_anadirNodoDif(txt:String, nodo:FLDomNode):Boolean
{
	var rE:RegExp = /&(?!amp;)/g;
	rE.global = true;
	txt = txt.replace(rE, "&amp;");

	var xmlDifAux:FLDomDocument = new FLDomDocument;
	if (!(xmlDifAux.setContent(txt)))
		return false;
	
	if (nodo) {
		var nodoNuevo:FLDomNode = this.iface.preprocesarNodo(nodo);
		if (!nodoNuevo)
			return false
		xmlDifAux.firstChild().appendChild(nodoNuevo.cloneNode());
	}
	this.iface.xmlDif.firstChild().appendChild(xmlDifAux.firstChild());
	return true;
}

/** \D Incrementa el valor 'cuenta' del elemento de la lista cuyo nombre coincide con el parámetro 'nomNodo'. Si el elemento no existe, se crea uno con 'cuenta' = 1
@param	listaNodos: Lista de nodos
@param	nomNodo: Nombre del nodo
@return	Lista de nodos con el nodo añadido
\end */
function head_anadirNodoLista(listaNodos:Array, nomNodo:String):Array
{
	var i:Number;
	for (i = 0; i < listaNodos.length; i++) {
		if (listaNodos[i].nombre == nomNodo)
				break;
	}
	if (i == listaNodos.length) {
		listaNodos[i] = [];
		listaNodos[i].nombre = nomNodo;
		listaNodos[i].cuenta = 1;
	} else
		listaNodos[i].cuenta += 1;
	
	return listaNodos;
}

/** \D Busca un nodo en la lista de nodos por nombre y obtiene el índice correspondiente
@param	listaNodos: Lista de nodos
@param	nomNodo: Nombre del nodo
@return	Indice
\end */
function head_buscarNodoLista(listaNodos:Array, nomNodo:String):Number
{
	var i:Number;
	for (i = 0; i < listaNodos.length; i++) {
		if (listaNodos[i].nombre == nomNodo)
			break;
	}
	return i;
}

/** Obtiene el fichero de script de las modificaciones (parche) que hay que hacer al fichero 1 para convertirlo en el fichero 2
@param	ruta1: Ruta al primer fichero
@param	ruta2: Ruta al segundo fichero
@param	codFuncional: Código de la funcionalidad que se está tratando
@return	Documento script de diferencias o false si hay error
*/
function head_obtenerScriptDif(ruta1:String, ruta2:String, codFuncional:String):String
{
	var contenido1:String;
	var contenido2:String;
	
	if (!File.exists(ruta1)) {
		this.iface.pub_log.child("log").append("No se encuentra el fichero " + ruta1);
		return false;
	}
	contenido1 = File.read(ruta1);

	if (!File.exists(ruta2)) {
		this.iface.pub_log.child("log").append("No se encuentra el fichero " + ruta2);
		return 0;
	}
	contenido2 = File.read(ruta2);

	var dif:String = this.iface.compararScripts(contenido1, contenido2);
	return dif;
}

/** Obtiene el fichero php de las modificaciones (parche) que hay que hacer al fichero 1 para convertirlo en el fichero 2
@param	ruta1: Ruta al primer fichero
@param	ruta2: Ruta al segundo fichero
@param	codFuncional: Código de la funcionalidad que se está tratando
@return	Documento script de diferencias o false si hay error
*/
function head_obtenerPhpDif(ruta1:String, ruta2:String, codFuncional:String):String
{
	var contenido1:String;
	var contenido2:String;
	
	if (!File.exists(ruta1)) {
		this.iface.pub_log.child("log").append("No se encuentra el fichero " + ruta1);
		return false;
	}
	contenido1 = File.read(ruta1);

	if (!File.exists(ruta2)) {
		this.iface.pub_log.child("log").append("No se encuentra el fichero " + ruta2);
		return 0;
	}
	contenido2 = File.read(ruta2);

	var dif:String = this.iface.compararPhps(contenido1, contenido2);
	return dif;
}

/** \D Obtiene la declaración y definición de las clases que están en el fichero 2 pero no en el fichero 1
@param	contenido1: Contenido del fichero 1
@param	contenido2: Contenido del fichero 2
@return	String con la declaración y definición de la clase.
\end */
function head_compararScripts(contenido1:String, contenido2:String):String
{
	var res:String = "";
	var lista1:Array = this.iface.listaClases(contenido1);
	var lista2:Array = this.iface.listaClases(contenido2);
	
	var i:Number;
	for (i = 0; i < lista2.length; i++) {
		if (lista2[i].tipoClase == "declaration") {
			if (this.iface.buscarClase(lista2[i].nombreClase, "declaration", lista1) == -1) {
				res += "\n" + contenido2.substring(lista2[i].posInicio, lista2[i].posFin);
			}
		}
	}
	
	for (i = 0; i < lista2.length; i++) {
		if (lista2[i].tipoClase == "definition") {
			if (this.iface.buscarClase(lista2[i].nombreClase, "definition", lista1) == -1) {
				res += "\n" + contenido2.substring(lista2[i].posInicio, lista2[i].posFin);;
			}
		}
	}
	
	return res;
}

/** \D Obtiene la declaración y definición de las clases que están en el fichero php 2 pero no en el fichero 1
@param	contenido1: Contenido del fichero 1
@param	contenido2: Contenido del fichero 2
@return	String con la declaración y definición de la clase.
\end */
function head_compararPhps(contenido1:String, contenido2:String):String
{
	var res:String = "";
	var lista1:Array = this.iface.listaClasesPhp(contenido1);
	var lista2:Array = this.iface.listaClasesPhp(contenido2);
	
	var i:Number;
	for (i = 0; i < lista2.length; i++) {
		if (lista2[i].tipoClase == "definition") {
			if (this.iface.buscarClase(lista2[i].nombreClase, "definition", lista1) == -1) {
				res += "\n" + contenido2.substring(lista2[i].posInicio, lista2[i].posFin);;
			}
		}
	}
	
	return res;
}

/** \D Obtiene el índice de la clase que concuerda en nombre y tipo dentro de un vector de clases
@param	nombre: Nombre de la clase buscada
@param	tipo: Tipo de la clase buscada (declaration o definition)
@param	lista: Vector de clases
@return	Indice de la clase encontrada o -1 si no se encuentra
\end */
function head_buscarClase(nombre:String, tipo:String, lista:Array):Number
{
	for (var i:Number = 0; i < lista.length; i++) {
		if (lista[i].nombreClase == nombre && lista[i].tipoClase == tipo) {
			return i;
		}
	}
	return -1;
}

/** \D Obtiene un vector de clases con los siguientes datos para cada elemento:

@param	contenido: Contenido del fichero de script
@return	Array con los datos de cada parte del script. Los miembros de cada elemento son:
	Nombre: Nombre de la clase
	Tipo: Indica si se trata de la declaracion (declaration) o de la definición (definition)
	ClaseBase: Nombre de la clase base (sólo para tipo declaracion)
	posInicio: Posición (carácter) en la que se inicia esta parte
	posFin: Posición (carácter) en la que se finaliza esta parte
\end */
function head_listaClases(contenido:String):Array
{
	var sep:String = "[\\s,\\t,\\n,\{]*";
	var label:RegExp = new RegExp("/\\*\\*" + sep + "@class_");
	var res:Array = [];
	var pos:Number = 0;
	var posNueva:Number = contenido.find(label, pos);
	var indice:Number = 0;
	while (posNueva != contenido.length) {
		var clase:Array = [];
		var posAux = contenido.find("@class_", posNueva) + 7;
		clase.tipoClase = this.iface.obtenerNombreClase(contenido, posAux);
		clase.nombreClase = this.iface.obtenerNombreClase(contenido, posAux + clase.tipoClase.length);
		if (contenido.substring(posAux, posAux + 11) == "declaration")
			clase.nombreClaseBase =  this.iface.obtenerNombreClaseBase(contenido, posAux, clase.nombreClase);
		var posFinClase:Number = contenido.find(label, posNueva + 1);
		if (posFinClase == -1)
			posFinClase = contenido.length;
		clase.posInicio = posNueva;
		clase.posFin = posFinClase - 1;

		res[indice++] = clase;
		posNueva = posFinClase;
	}
	return res;
}

/** \D Obtiene un vector de clases con los siguientes datos para cada elemento:

@param	contenido: Contenido del fichero de script
@return	Array con los datos de cada parte del script. Los miembros de cada elemento son:
	Nombre: Nombre de la clase
	Tipo: Indica si se trata de la declaracion (sólo hay definition)
	ClaseBase: Nombre de la clase base 
	posInicio: Posición (carácter) en la que se inicia esta parte
	posFin: Posición (carácter) en la que se finaliza esta parte
\end */
function head_listaClasesPhp(contenido:String):Array
{
	var sep:String = "[\\s,\\t,\\n,\{]*";
	var label:RegExp = new RegExp("/\\*\\*" + sep + "@class_");
	var labelMain:RegExp = new RegExp("/\\*\\*" + sep + "@main_");
	var res:Array = [];
	var pos:Number = 0;
	var posNueva:Number = contenido.find(label, pos);
	var posMain:Number = contenido.find(labelMain, pos);
	var indice:Number = 0;
	while (posNueva > -1) {
debug("posNueva = " + posNueva);
		var clase:Array = [];
		var posAux = contenido.find("@class_", posNueva) + 7;
		clase.tipoClase = this.iface.obtenerNombreClase(contenido, posAux);
		clase.nombreClase = this.iface.obtenerNombreClase(contenido, posAux + clase.tipoClase.length);
		clase.nombreClaseBase = this.iface.obtenerNombreClaseBase(contenido, posAux, clase.nombreClase);
		var posFinClase:Number = contenido.find(label, posNueva + 1);
debug("posFinClase = " + posFinClase);
		
		clase.posInicio = posNueva;
		if (posFinClase == -1) {
			posNueva = -1;
			if (posMain > -1)
				posFinClase = posMain;
			else
				posFinClase = contenido.length;
		} else {
			posNueva = posFinClase;
		}
		clase.posFin = posFinClase - 1;

		res[indice++] = clase;
	}
	return res;
}


/** \D Obtiene la palabra siguiente a la palabra extends (nombre de una clase base)

@param	contenido: Contenido del fichero
@param	pos: Posición a partir de la cual buscar la palabra
@param	clase: Nombre de la clase derivada
@return	palabra
\end */
function head_obtenerNombreClaseBase(contenido:String, pos:Number, clase:String):String
{
	var sep:String = "[\\s,\\t,\\n,\{]*";
	var label:RegExp = new RegExp(clase + sep + "extends");
	var posExtends:Number = contenido.find(label, pos);
	if (posExtends == -1)
		return "";
			
	posExtends = contenido.find("extends", pos);
	return this.iface.obtenerNombreClase(contenido, posExtends + 7);
}

/** \D Obtiene la siguiente palabra (texto entre los caracteres ' ', tab, newline, '*')
@param	contenido: Contenido del fichero
@param	pos: Posición a partir de la cual buscar la palabra
@return	palabra
\end */
function head_obtenerNombreClase(contenido:String, pos:Number):String
{
	var nombre:String = "";
	var estado:Number = 0;
	var indice:Number = 0;
	var caracter:String;
	
	while (estado < 2) {
		caracter = contenido.charAt(pos + indice);
		switch(estado) {
			case 0: // Antes del nombre
				if (caracter != " " && caracter != "\t" && caracter != "\n" && caracter != "*" && caracter != "{") {
					nombre = caracter;
					estado = 1;
				}
				break;
			case 1: // En el nombre
				if (caracter != " " && caracter != "\t" && caracter != "\n" && caracter != "*" && caracter != "{") {
					nombre += caracter;
				} else {
					estado = 2;
				}
				break;
		}
		indice++;
	}
	return nombre;
}

/** \D
Resuelve automáticamente un conflicto en un archivo xml (ui, mtd, xml)

@param	contenidoParche: Contenido del parche de modificaciones
@param	contenidoActual: Contenido del fichero sin modificar
@return	contenido del fichero modificado, false si hay error
\end */
function head_gestionConfXml(contenidoParche:String, contenidoActual:String):String
{
	var xmlActual:FLDomDocument = new FLDomDocument;
	xmlActual.setContent(contenidoActual);
	
	var xmlNuevo:FLDomDocument = new FLDomDocument;
	xmlNuevo.setContent(contenidoActual);

	var xmlDif:FLDomDocument = new FLDomDocument;
	xmlDif.setContent(contenidoParche);
	
	var nodoDoc:FLDomNode = xmlDif.namedItem("xupdate:modifications");
	var nodoActual:FLDomNode;
  var nodoDif:FLDomNode;
	var nombreNodo:String;
	var rutaNodo:Array;

  var tipoNodo:String;
  var nomNodo:String;
  var numNodo:String;
  var nodoEncontrado:Number = 0;
  var idNodo:Array;
  var i:Number;
  
	for (nodoDif = nodoDoc.firstChild(); nodoDif; nodoDif = nodoDif.nextSibling()) {
		nombreNodo = nodoDif.nodeName();
		//this.iface.pub_log.child("log").append(nombreNodo);
		rutaNodo = nodoDif.attributeValue("select").split("/");
		nodoActual = xmlActual;
		tipoNodo = ""
		nomNodo = "";
		numNodo = "";
		nodoEncontrado = 0;
    if (idNodo ) delete idNodo;
    
		for (i = 1; i < rutaNodo.length; i++) {
			if (rutaNodo[i].charAt(0) == "@") {
					nomNodo = rutaNodo[i];
					numNodo = 0;
			} else {
					nomNodo = rutaNodo[i].substring(0, rutaNodo[i].find("["));
					numNodo = rutaNodo[i].substring(rutaNodo[i].find("[") + 1, rutaNodo[i].find("]"));
			}

			tipoNodo = this.iface.obtenerTipoNodo(nomNodo);
			if (tipoNodo != "normal") 
					continue;
			
			idNodo = numNodo.split(",");
			var nodoAux:FLDomNode = nodoActual;
			nodoActual = this.iface.buscarNodoPorId(nodoActual, nomNodo, idNodo);
			if (!nodoActual || nodoActual == 0) {
					if (i == (rutaNodo.length - 1)) 
							nodoEncontrado = 1;
					else
							nodoEncontrado = 2;
					nodoActual = nodoAux;
					break;
			}
		}
		switch(nombreNodo) {
			case "xupdate:insert-after":
				switch (nodoEncontrado) {
					case 0:
						var nodoAux:FLDomNode = nodoDif.firstChild().cloneNode();
						nodoActual = nodoActual.parentNode().insertAfter(nodoAux, nodoActual);
						break;
					case 1:
						this.iface.pub_log.child("log").append("Insert-after: No se ha encontrado el nodo de referencia en " + nodoDif.attributeValue("select"));
						this.iface.pub_log.child("log").append("Warning: El nodo se insertará como último hijo");
						var nodoAux:FLDomNode = nodoDif.firstChild().cloneNode();
						nodoActual = nodoActual.appendChild(nodoAux);
						break;
					case 2:
						this.iface.pub_log.child("log").append("Insert-after: No se ha encontrado la ruta de referencia para " + nodoDif.attributeValue("select") + "en " + nomNodo + "-" + rutaNodo[i]);
						this.iface.pub_log.child("log").append("Error: El nodo no puede insertarse");
						return false;
						break;
				}
				break;
			case "xupdate:append-first":
				switch (nodoEncontrado) {
					case 0:
						var nodoAux:FLDomNode = nodoDif.firstChild().cloneNode();
						nodoActual = nodoActual.insertBefore(nodoAux);
						break;
					case 1:
					case 2:
						this.iface.pub_log.child("log").append("Append-first:");
						this.iface.pub_log.child("log").append("Error: Se perdió el nodo actual buscando " + nodoDif.attributeValue("select") + " en " + nomNodo + "-" + rutaNodo[i]);
						return false;
				}
				break;
			case "xupdate:delete":
				switch (nodoEncontrado) {
					case 0:
						nodoActual = nodoActual.parentNode().removeChild(nodoActual);
						break;
					case 1:
						this.iface.pub_log.child("log").append("Delete: Eliminación de " + nodoDif.attributeValue("select"));
						this.iface.pub_log.child("log").append("Warning: El nodo especificado no existe");
						break;
					case 2:
						this.iface.pub_log.child("log").append("Delete:");
						this.iface.pub_log.child("log").append("Error: Se perdió el nodo actual buscando " + nodoDif.attributeValue("select") + " en " + nomNodo + "-" + idNodo);
						return false;
						break;
				}
				break;
			case "xupdate:update":
				switch (nodoEncontrado) {
					case 0:
						switch(tipoNodo) {
							case "normal":
								break;
							case "texto":
								nodoActual.firstChild().setNodeValue(nodoDif.firstChild().nodeValue());
								break;
							case "atributo":
								var nomAtributo:String = nomNodo.substring(1, nomNodo.length);
								nodoActual.toElement().setAttribute(nomAtributo, nodoDif.firstChild().nodeValue());
								break;
						}
						break;
					case 1:
					case 2:
						this.iface.pub_log.child("log").append("Update:");
						this.iface.pub_log.child("log").append("Error: Se perdió el nodo actual buscando " + nodoDif.attributeValue("select") + " en " + nomNodo + "-" + idNodo);
						return false;
						break;
				}
				break;
		}
	}
	
	return xmlActual.toString(4);
}

/** \D
Obtiene el tipo de nodo que se va a modificar, en función del nombre del nodo

@param	nomNodo: Nombre del nodo
@return	tipo del nodo. Los posibles valores son:
	atributo: El nombre del nodo empieza por @
	texto: El nombre del nodo es text()
	normal: Cualquier otro caso
\end */
function head_obtenerTipoNodo(nomNodo:String):String
{
	if (nomNodo.charAt(0) == "@") {
		return "atributo";
	} else if (nomNodo == "text()") {
		return "texto";
	} else {
		return "normal";
	}
}

/** \D
Resuelve automáticamente un conflicto en un archivo de script (qs)

@param	contenidoParche: Contenido del parche de modificaciones
@param	contenidoActual: Contenido del fichero sin modificar
@return	contenido del fichero modificado, false si hay error
\end */
function head_gestionConfScript(qsDif:String, qsActual:String):String
{
	var qsNuevo:String = qsActual;
	var posIniPalabra:Number;
	var posFinPalabra:Number;
	var indiceClase:Number;
	var indiceClaseBase:Number;
	var posAux:Number = 0;
	var reAux:RegExp;
	var labelDeclaracion = "@class_declaration";
	var sep = "[\\s,\\t,\\n,{]";
	
	var listaNuevo:Array = this.iface.listaClases(qsNuevo);
	var listaDif:Array = this.iface.listaClases(qsDif);
	var listaClasesBase:Array = [];
	
  var nombreClase:String;
  var nombreClasePrevia:String;
      
	for (var indice:Number = 0; indice < listaDif.length; indice++) {
		
    nombreClase = listaDif[indice].nombreClase;
    
		if (listaDif[indice].tipoClase == "declaration") {
			listaClasesBase[nombreClase] = listaDif[indice].nombreClaseBase;
			nombreClasePrevia = "";
      
			for (var i:Number = 0; i < listaNuevo.length; i++) {
				nombreClasePrevia = listaNuevo[i].nombreClase;
				reAux = new RegExp("class" + sep + nombreClasePrevia + sep + "extends" + sep + listaClasesBase[nombreClase] + sep);
				posAux = qsNuevo.find(reAux, listaNuevo[i].posInicio);
				if (posAux != -1)
					break;
			}

			if (posAux != -1) {
				// Cambia 'extends claseBase' por 'extends claseNueva' en la clase que será hija de claseNueva
				posIniPalabra = qsNuevo.find(listaClasesBase[nombreClase], posAux);
				posFinPalabra = posIniPalabra + listaClasesBase[nombreClase].length;
				qsNuevo = qsNuevo.substring(0, posIniPalabra) + nombreClase + qsNuevo.substring(posFinPalabra, qsNuevo.length - 1);
				// Cambia el constructor para que llame al constructor de la clase nueva
				reAux = new RegExp("function" + sep + nombreClasePrevia + sep + "*\\(");
				posAux = qsNuevo.find(reAux, posAux);
				posIniPalabra = qsNuevo.find(listaClasesBase[nombreClase], posAux);
				posFinPalabra = posIniPalabra + listaClasesBase[nombreClase].length;
				qsNuevo = qsNuevo.substring(0, posIniPalabra) + nombreClase + qsNuevo.substring(posFinPalabra, qsNuevo.length - 1);
			}

			// Introduce la declaración de la clase nueva
			listaNuevo= this.iface.listaClases(qsNuevo);
			indiceClaseBase = this.iface.buscarClase(listaClasesBase[nombreClase], "declaration", listaNuevo);
			indiceClase = this.iface.buscarClase(nombreClase, "declaration", listaDif);
			qsNuevo = qsNuevo.substring(0, listaNuevo[indiceClaseBase].posFin) + "\n" + qsDif.substring(listaDif[indiceClase].posInicio, listaDif[indiceClase].posFin) + "\n" + qsNuevo.substring(listaNuevo[indiceClaseBase].posFin + 1, qsNuevo.length);
		} else {
			// Introduce la definición de la clase nueva
			listaNuevo= this.iface.listaClases(qsNuevo);
			indiceClaseBase = this.iface.buscarClase(listaClasesBase[nombreClase], "definition", listaNuevo);

			if (indiceClaseBase == -1)
				indiceClaseBase = listaNuevo.length - 1;
			indiceClase = this.iface.buscarClase(nombreClase, "definition", listaDif);
			qsNuevo = qsNuevo.substring(0, listaNuevo[indiceClaseBase].posFin) + "\n" + qsDif.substring(listaDif[indiceClase].posInicio, listaDif[indiceClase].posFin + 1) + "\n" + qsNuevo.substring(listaNuevo[indiceClaseBase].posFin + 1, qsNuevo.length + 1);
		}
	}

	// Cambia, si es necesario la clase del objeto iface
	listaNuevo= this.iface.listaClases(qsNuevo);
	reAux = new RegExp("const" + sep + "iface" + sep + "=" + sep + "new");
	posAux = qsNuevo.find(reAux);
	posIniPalabra = qsNuevo.find("new", posAux) + 4;
	posFinPalabra = qsNuevo.find("(", posAux) - 1;
	var ultimaClase:String = this.iface.buscarUltClaseDerivada(listaNuevo);
	if (!ultimaClase) {
			this.iface.pub_log.child("log").append("Error de consistencia en la estructura de clases");
			return false;
	}
	qsNuevo = qsNuevo.substring(0, posIniPalabra) + ultimaClase +
			qsNuevo.substring(posFinPalabra + 1, qsNuevo.length);
	return qsNuevo;
}     

/** \D
Resuelve automáticamente un conflicto en un archivo de código php(qs)

@param	contenidoParche: Contenido del parche de modificaciones
@param	contenidoActual: Contenido del fichero sin modificar
@return	contenido del fichero modificado, false si hay error
\end */
function head_gestionConfPhp(qsDif:String, qsActual:String):String
{
	var qsNuevo:String = qsActual;
	var posIniPalabra:Number;
	var posFinPalabra:Number;
	var indiceClase:Number;
	var indiceClaseBase:Number;
	var posAux:Number = 0;
	var posMain:Number = 0;
	var reAux:RegExp;
	var labelDeclaracion = "@class_definition";
	var sep = "[\\s,\\t,\\n,{]";
	
	var listaNuevo:Array = this.iface.listaClasesPhp(qsNuevo);
	var listaDif:Array = this.iface.listaClasesPhp(qsDif);
	var listaClasesBase:Array = [];
	
	for (var indice:Number = 0; indice < listaDif.length; indice++) {
		var nombreClase:String = listaDif[indice].nombreClase;
		if (listaDif[indice].tipoClase == "definition") {
			listaClasesBase[nombreClase] = listaDif[indice].nombreClaseBase;
			var nombreClasePrevia:String;
			for (var i:Number = 0; i < listaNuevo.length; i++) {
				nombreClasePrevia = listaNuevo[i].nombreClase;
				reAux = new RegExp("class" + sep + nombreClasePrevia + sep + "extends" + sep + listaClasesBase[nombreClase] + sep);
				posAux = qsNuevo.find(reAux, listaNuevo[i].posInicio);
				if (posAux != -1)
					break;
			}

			if (posAux != -1) {
				// Cambia 'extends claseBase' por 'extends claseNueva' en la clase que será hija de claseNueva
				posIniPalabra = qsNuevo.find(listaClasesBase[nombreClase], posAux);
				posFinPalabra = posIniPalabra + listaClasesBase[nombreClase].length;
				qsNuevo = qsNuevo.substring(0, posIniPalabra) + nombreClase + qsNuevo.substring(posFinPalabra, qsNuevo.length - 1);
			}

			// Introduce la declaración de la clase nueva
			listaNuevo= this.iface.listaClasesPhp(qsNuevo);
			indiceClaseBase = this.iface.buscarClase(listaClasesBase[nombreClase], "definition", listaNuevo);
			indiceClase = this.iface.buscarClase(nombreClase, "definition", listaDif);
			qsNuevo = qsNuevo.substring(0, listaNuevo[indiceClaseBase].posFin) + "\n" + qsDif.substring(listaDif[indiceClase].posInicio, listaDif[indiceClase].posFin) + "\n" + qsNuevo.substring(listaNuevo[indiceClaseBase].posFin + 1, qsNuevo.length);
		} else {
			// No debe entrar nunca para archivos php (sólo tienen definition)
		}
	}

	// Cambia, si es necesario la clase del objeto iface
	listaNuevo= this.iface.listaClasesPhp(qsNuevo);
	reAux = new RegExp("@main_class_definition");
	posAux = qsNuevo.find(reAux);
	posAux = qsNuevo.find("extends", posAux);
	posIniPalabra = posAux + 8;
	posFinPalabra= qsNuevo.find("{", posIniPalabra);
	var ultimaClase:String = this.iface.buscarUltClaseDerivadaPhp(listaNuevo);
	if (!ultimaClase) {
		this.iface.pub_log.child("log").append("Error de consistencia en la estructura de clases");
		return false;
	}
	posAux = qsNuevo.find("extends", posAux);
	qsNuevo = qsNuevo.substring(0, posIniPalabra) + ultimaClase +
		qsNuevo.substring(posFinPalabra, qsNuevo.length);
	return qsNuevo;
}

/** \D Busca la clase la clase derivada que no es base de ninguna otra clase en un script. También comprueba que todas las clases del script forman una cadena de herencia continua y de una sola rama

@param listaClases: Lista con los datos de cada una de las clases
@return nombre de la clase buscada o false si no existe o si la estructura de clases no es correcta
\end */
function head_buscarUltClaseDerivada(listaClases:Array):String
{
	var datosClases:Array = [];
	var indice = 0;
	var clase:String = "";
	for (var i:Number = 0; i < listaClases.length; i++) {
		if (listaClases[i].tipoClase != "declaration") 
			continue;
		datosClases[indice] = [];
		datosClases[indice].clase = listaClases[i].nombreClase;
		datosClases[indice].claseBase = listaClases[i].nombreClaseBase;
		indice++;
	}
	for (var i:Number = 0; i < datosClases.length; i++) {
		var k:Number;
		for(k = 0; k < datosClases.length; k++) {
			if (datosClases[k].claseBase == clase) {
				clase = datosClases[k].clase;
				break;
			}
		}
		if (k == datosClases.length)
			return false;
	}
	return clase;
}

/** \D Busca la clase la clase derivada que no es base de ninguna otra clase en un fichero php. También comprueba que todas las clases del fichero forman una cadena de herencia continua y de una sola rama
@param listaClases: Lista con los datos de cada una de las clases
@return nombre de la clase buscada o false si no existe o si la estructura de clases no es correcta
\end */

function head_buscarUltClaseDerivadaPhp(listaClases:Array):String
{
	var datosClases:Array = [];
	var indice = 0;
	var clase:String = "";
	for (var i:Number = 0; i < listaClases.length; i++) {
		if (listaClases[i].tipoClase != "definition")
			continue;
		datosClases[indice] = [];
		datosClases[indice].clase = listaClases[i].nombreClase;
		datosClases[indice].claseBase = listaClases[i].nombreClaseBase;
		indice++;
	}
	for (var i:Number = 0; i < datosClases.length; i++) {
		var k:Number;
		for(k = 0; k < datosClases.length; k++) {
			if (datosClases[k].claseBase == clase) {
				clase = datosClases[k].clase;
				break;
			}
		}
		if (k == datosClases.length)
			return false;
	}
	return clase;
}

/** \D Aplica el parche de una determinada funcionalidad 

@param	codFuncional: funcionalidad
@param	dirParche: directorio donde reside dicho parche
@param	dirDest: directorio donde se aplicará el parche
@return	True si no hay error, false en caso contrario
\end */
function head_aplicarParche(codFuncional:String, dirParche:String, dirDest:String):Boolean
{
	Dir.current = this.iface.obtenerPathLocal();
	if (!File.exists(dirParche + "/" + codFuncional + ".xml")) {
		this.iface.pub_log.child("log").append("El parche " + codFuncional + " está vacío");
		return true;
	}
	var xmlParche = new FLDomDocument;
	xmlParche.setContent(File.read(dirParche + "/" + codFuncional + ".xml"));
	var nodo:FLDomNode;
	var nodoDoc:FLDomNode = xmlParche.namedItem("flpatch:modifications");
	
	for (nodo = nodoDoc.firstChild(); nodo; nodo = nodo.nextSibling()) {
		if (!this.iface.aplicarParcheNodo(nodo, dirParche, dirDest, dirDest)) {
			return false;
		}
	}
	return true;
}

function head_aplicarParcheNodo(nodo:FLDomNode, dirParche:String, dirOrig:String, dirDest:String):Boolean 
{
	var pathFichero:String = nodo.toElement().attribute("path");
	var nombre:String = nodo.toElement().attribute("name");
	
	if (!File.exists(this.iface.obtenerPathLocal() + dirParche + "/" + nombre)) {
		this.iface.pub_log.child("log").append("El fichero " + dirParche + "/" + nombre + " no existe");
		return false;
	}
	var contenido:String;
	switch(nodo.nodeName()) {
		case "flpatch:patchXml":
			this.iface.pub_log.child("log").append("Aplicando parche a " + nombre);
			if (!File.exists(this.iface.pathLocal + dirOrig + "/" + pathFichero + nombre)) {
				this.iface.pub_log.child("log").append("El fichero " + this.iface.pathLocal + dirParche + "/" + pathFichero + nombre + " no existe");
				return false;
			}
			this.iface.tipoDocActual = nombre.substring(nombre.findRev(".") + 1, nombre.length);
			contenido = this.iface.gestionConfXml(File.read(this.iface.pathLocal + dirParche + "/" + nombre), File.read(this.iface.pathLocal + dirOrig + "/" + pathFichero + nombre));
			if (!contenido) {
				this.iface.pub_log.child("log").append("Error al aplicar el parche al fichero " + nombre);
				return false;
			}
			contenido = this.iface.reemplazar(contenido, "&quot;", "\"");
			File.write(this.iface.pathLocal + dirDest + "/" + pathFichero + nombre, contenido);
			break;
	
		case "flpatch:patchScript":
			this.iface.pub_log.child("log").append("Aplicando parche a " + nombre);
// debug("Ruta = " + this.iface.pathLocal + dirOrig + "/" + pathFichero + nombre);
			if (!File.exists(this.iface.pathLocal + dirOrig + "/" + pathFichero + nombre)) {
				this.iface.pub_log.child("log").append("El fichero " + this.iface.pathLocal + dirParche + "/" + nombre + " no existe");
				return false;
			}
			contenido = this.iface.gestionConfScript(File.read(this.iface.pathLocal + dirParche + "/" + nombre), File.read(this.iface.pathLocal + dirOrig + "/" + pathFichero + nombre));
			if (!contenido) {
				this.iface.pub_log.child("log").append("Error al aplicar el parche al fichero " + nombre);
				return false;
			}
			contenido = this.iface.reemplazar(contenido, "&quot;", "\"");
			File.write(this.iface.pathLocal + dirDest + "/" + pathFichero + nombre, contenido);
			break;

		case "flpatch:patchPhp":
			this.iface.pub_log.child("log").append("Aplicando parche a " + nombre);
			if (!File.exists(this.iface.pathLocal + dirOrig + "/" + pathFichero + nombre)) {
				this.iface.pub_log.child("log").append("El fichero " + this.iface.pathLocal + dirParche + "/" + nombre + " no existe");
				return false;
			}
			contenido = this.iface.gestionConfPhp(File.read(this.iface.pathLocal + dirParche + "/" + nombre), File.read(this.iface.pathLocal + dirOrig + "/" + pathFichero + nombre));
			if (!contenido) {
				this.iface.pub_log.child("log").append("Error al aplicar el parche al fichero " + nombre);
				return false;
			}
			contenido = this.iface.reemplazar(contenido, "&quot;", "\"");
			File.write(this.iface.pathLocal + dirDest + "/" + pathFichero + nombre, contenido);
			break;

		case "flpatch:replaceFile":
			this.iface.pub_log.child("log").append("Reemplazando " + nombre);
			var comando:String = "cp -f " + this.iface.pathLocal + dirParche + "/" + nombre + " " + this.iface.pathLocal + dirDest + "/" + pathFichero + nombre;
			var resComando:Array = this.iface.ejecutarComando(comando);
			if (resComando.ok == false) {
				this.iface.pub_log.child("log").append("Error al copiar el fichero con: " + comando);
				return;
			}
			/// Si el parche incluye un cambio sobre un archivo kut, se borra el correspondiente archivo ar para que sea el kut el que se cargue.
			if (nombre.endsWith(".kut")) {
				var nombreAr:String = nombre.left(nombre.length - 3);
				nombreAr += "ar";
				comando = "rm -f " + this.iface.pathLocal + dirDest + "/" + pathFichero + nombreAr;
				resComando = this.iface.ejecutarComando(comando);
				if (resComando.ok == false) {
					this.iface.pub_log.child("log").append("Error al eliminar el fichero con: " + comando);
					return;
				}
			}
// debug("dirDest  = " + dirDest);
			if (nombre.endsWith(".ar") && (dirDest.endsWith("modulos") ||dirDest.endsWith("prueba")) ) {
				contenido = File.read(this.iface.pathLocal + dirParche + "/" + nombre);
				contenido = sys.toUnicode(contenido, "UTF-8");
				var contenidoKut:String = flar2kut.iface.pub_ar2kut(contenido);
				contenidoKut = sys.fromUnicode(contenidoKut, this.iface.localEnc_);
				var nombreKut:String = nombre.left(nombre.length - 2);
				nombreKut += "kut";
				File.write(this.iface.pathLocal + dirDest + "/" + pathFichero + nombreKut, contenidoKut);
			}
// 			contenido = File.read(this.iface.pathLocal + dirParche + "/" + nombre);
			break;
		case "flpatch:addFile":
			this.iface.pub_log.child("log").append("Añadiendo " + nombre);
			var comando:String = "cp -f " + this.iface.pathLocal + dirParche + "/" + nombre + " " + this.iface.pathLocal + dirDest + "/" + pathFichero + nombre;
			var resComando:Array = this.iface.ejecutarComando(comando);
			if (resComando.ok == false) {
				this.iface.pub_log.child("log").append("Error al copiar el fichero con: " + comando);
				return;
			}
// debug("dirDest = " + dirDest);
			if (nombre.endsWith(".ar") && (dirDest.endsWith("modulos") ||dirDest.endsWith("prueba")) ) {
				contenido = File.read(this.iface.pathLocal + dirParche + "/" + nombre);
				contenido = sys.toUnicode(contenido, "UTF-8");
				var contenidoKut:String = flar2kut.iface.pub_ar2kut(contenido);
				contenidoKut = sys.fromUnicode(contenidoKut, this.iface.localEnc_);
				var nombreKut:String = nombre.left(nombre.length - 2);
				nombreKut += "kut";
				File.write(this.iface.pathLocal + dirDest + "/" + pathFichero + nombreKut, contenidoKut);
			}
// 			contenido = File.read(this.iface.pathLocal + dirParche + "/" + nombre);
			break;
	}
	
	this.iface.pub_log.child("log").append("OK");
	sys.processEvents();
	return true;
}

function head_cargarCodificacionLocal()
{
	var util:FLUtil = new FLUtil;
	this.iface.localEnc_ = util.readSettingEntry("scripts/sys/conversionArENC");
	if (!this.iface.localEnc_) {
		this.iface.localEnc_ = "ISO-8859-15";
	}
}

/** \D Obtiene una lista ordenada (orden de instalación) de las funcionalidades de las que depende una determinada funcionalidad

@param	codFuncional: funcionalidad
@return	Lista de funcionalidades
\end */
function head_obtenerListaDep(codFuncional:String):Array
{
// debug("F = " + codFuncional);
		var listaDesordenada:Array = this.iface.obtenerListaDepDes(codFuncional);
// debug("LD = " + listaDesordenada);
		var listaOrdenada:Array = this.iface.ordenarListaDep(listaDesordenada);
// debug("LO = " + listaOrdenada);
		return listaOrdenada;
}

/** \D Obtiene una lista ordenada (orden de instalación) de las funcionalidades asociadas a un cliente, así como de sus dependencias

@param	idCliente: identificador del cliente
@return	Lista de funcionalidades
\end */
function head_obtenerListaDepCliente(idCliente:String):Array
{
	var listaDesordenada:Array = [];
	var qryDep:FLSqlQuery = new FLSqlQuery();
	qryDep.setTablesList("mv_funcionalcli");
	qryDep.setSelect("codfuncional");
	qryDep.setFrom("mv_funcionalcli");
	qryDep.setWhere("idcliente = '" + idCliente + "'");
	if (!qryDep.exec()) {
		this.iface.pub_log.child("log").append ("Error al ejecutar la consulta");
		return false;
	}
	while (qryDep.next()) {
		listaDesordenada[listaDesordenada.length] = qryDep.value(0);
		listaDesordenada = listaDesordenada.concat(this.iface.obtenerListaDepDes(qryDep.value(0)));
	}
	
	var listaOrdenada:Array = this.iface.ordenarListaDep(listaDesordenada);
	return listaOrdenada;
}

/** \D Ordena una lista de funcionalidades desde las padres hasta las hijas y con las repeticiones eliminadas

@param	listaDesordenada: Lista a ordenar
@return	Lista ordenada
\end */
function head_ordenarListaDep(listaDesordenada:Array):Array
{
	var listaOrdenada:Array = [];
	var iDesor:Number = 0;
	var procesadas:Number = 0;
	var iOrden:Number = 0;
	while (procesadas < listaDesordenada.length) {
		if (this.iface.sinDependencias(listaDesordenada[iDesor], listaDesordenada)) {
			listaOrdenada[iOrden++] = listaDesordenada[iDesor];
			var funcionalidad = listaDesordenada[iDesor];
			var i:Number = iDesor;
			do {
				listaDesordenada[i] = "";
				procesadas++;

				i = this.iface.buscarPalabra(funcionalidad, listaDesordenada)
			} while (i > -1)
			iDesor = -1;
		}
		if (++iDesor == listaDesordenada.length) {
			iDesor = 0;
		}
	}

	return listaOrdenada;
}

/** \D Busca el elemento de la lista cuyo valor coincide con el parámetro 'palabra'

@param	palabra: palabra buscada
@param	lista: lista de palabras
@return	indice del elemento cuyo valor coincide, o -1 si no existe
\end */
function head_buscarPalabra(palabra:String, lista:Array):Number
{
	for (var i:Number = 0; i < lista.length; i++) {
		if (lista[i] == palabra)
			return i;
	}
	return -1;
}

/** \D Indica si una funcionalidad tiene o no dependencias dentro de una lista dada

@param	codFuncional: funcionalidad
@param	listaDep: lista de funcionalidades
@return	true si tiene dependencias, false en caso contrario
\end */
function head_sinDependencias(codFuncional:String, listaDep:Array):Boolean
{
	if (codFuncional == "")
		return false;
			
	var qryDep:FLSqlQuery = new FLSqlQuery();
	qryDep.setTablesList("mv_dependencias");
	qryDep.setSelect("codpadre");
	qryDep.setFrom("mv_dependencias");
	qryDep.setWhere("codhijo = '" + codFuncional + "'");
	if (!qryDep.exec()) {
		this.iface.pub_log.child("log").append ("Error al ejecutar la consulta");
		return false;
	}
	while (qryDep.next()) {
		if (this.iface.buscarPalabra(qryDep.value(0), listaDep) != -1)
			return false;
	}
	return true;
}

/** \D Obtiene una lista desordenada de las funcionalidades de las que depende una determinada funcionalidad

@param	codFuncional: funcionalidad
@return	Lista de funcionalidades
\end */
function head_obtenerListaDepDes(codFuncional:String):Array
{
	var lista:Array = [];
	var qryDep:FLSqlQuery = new FLSqlQuery();
	qryDep.setTablesList("mv_dependencias");
	qryDep.setSelect("codpadre");
	qryDep.setFrom("mv_dependencias");
	qryDep.setWhere("codhijo = '" + codFuncional + "' ORDER BY orden");
	if (!qryDep.exec()) {
		this.iface.pub_log.child("log").append ("Error al ejecutar la consulta");
		return false;
	}

	while (qryDep.next()) {
		lista[lista.length] = qryDep.value(0);
		lista = lista.concat(this.iface.obtenerListaDepDes(qryDep.value(0)));
	}
	return lista;
}

/** \D Obtiene los módulos necesarios para instalar una determinada funcionalidad

@param	codFuncional: funcionalidad
@param	dirDestino1: directorio base donde instalar los módulos
@param	dirDestino2: directorio donde instalar los módulos
@return	True si no hay error, false en caso contrario
\end */
function head_checkoutMods(codFuncional:String, dirDestino1:String, dirDestino2:String, versionBase:String):Boolean
{
	var util:FLUtil = new FLUtil;

	var codigoWeb:Boolean = util.sqlSelect("mv_funcional", "codigoweb", "codfuncional = '" + codFuncional + "'");
	var repositorio:String;
	if (codigoWeb) {
		repositorio = this.iface.urlRepositorioWebOficial;
	} else {
		repositorio = this.iface.urlRepositorioMod;
	}
	
	Dir.current = this.iface.pathLocal + dirDestino1 + "/" + dirDestino2;
	
	var qryMods = new FLSqlQuery();
	qryMods.setTablesList("mv_modulosfun,mv_modulos,mv_areas");
	qryMods.setSelect("mf.idmodulo, m.directorio, a.directorio, s.directorio");
	qryMods.setFrom("mv_modulosfun mf INNER JOIN mv_modulos m ON mf.idmodulo = m.idmodulo INNER JOIN mv_areas a ON m.idarea = a.idarea INNER JOIN mv_secciones s ON a.idseccion = s.idseccion");
	qryMods.setWhere("mf.codfuncional = '" + codFuncional + "'");
	if (!qryMods.exec()) {
		this.iface.pub_log.child("log").append("Error al ejecutar la consulta de módulos afectados por " + codFuncional);
		return false;
	}
	var dirArea:String;
	var dirMod:String;
	var dirSec:String;
	
	if (!versionBase) {
		versionBase = this.iface.versionOficial;
	}
	
	while (qryMods.next()) {
		dirMod = qryMods.value("m.directorio");
		dirArea = qryMods.value("a.directorio");
		dirSec = qryMods.value("s.directorio");
debug("****Sec = " + dirSec);
debug("****Area = " + dirArea);
debug("****Mod = " + dirMod);
		this.iface.pub_log.child("log").append("Obteniendo módulo " + dirArea + "/" + dirMod);
		if (!File.exists(dirArea)) {
			var resComando:Array = this.iface.ejecutarComando("mkdir " + dirArea);
			if (resComando.ok == false) {
				this.iface.pub_log.child("log").append("Error mkdir " + dirArea);
				return false;
			}
			var comando:String;
			if (dirSec == "oficial") {
				comando = "svn checkout -N " +  repositorio + dirSec + "/" + versionBase + "/" + dirArea + " " +  dirArea;
			} else {
				comando = "svn checkout -N " +  repositorio + dirSec + "/" + "tronco/" + dirArea + " " +  dirArea;
			}
			var resComando:Array = this.iface.ejecutarComando(comando);
			if (resComando.ok == false) {
				this.iface.pub_log.child("log").append("Error checkout " + dirArea);
				return false;
			}
		}
		if (File.exists(dirArea + "/" + dirMod)) {
			continue;
		}
		var comando:String;
		if (dirSec == "oficial") {
			comando = "svn checkout " + repositorio + dirSec + "/" + versionBase + "/" + dirArea + "/" + dirMod + " " +  dirArea + "/" + dirMod;
		} else {
			comando = "svn checkout " + repositorio + dirSec + "/" + "tronco/" + dirArea + "/" + dirMod + " " +  dirArea + "/" + dirMod;
		}
		var resComando:Array = this.iface.ejecutarComando(comando);
		if (resComando.ok == false) {
			this.iface.pub_log.child("log").append("Error checkout " + dirArea + "/" + dirMod);
			return false;
		}
		if (!this.iface.anadirTest(dirDestino1 + "/" + dirDestino2 + "/" + dirArea + "/" + dirMod, dirDestino1)) {
			return false;
		}
		this.iface.pub_log.child("log").append("OK");
		sys.processEvents();
	}

// debug("Borrando svn de " + this.iface.pathLocal + dirDestino1 + "/" + dirDestino2);
	var shell:String = "rm -rf $(find " + this.iface.pathLocal + dirDestino1 + "/" + dirDestino2 + " -name .svn)\n";
		
	File.write(this.iface.pathLocal + "delsvn.sh", shell);
	comando = "chmod 777 " + this.iface.pathLocal + "delsvn.sh";
	resComando = flmaveppal.iface.pub_ejecutarComando(comando);
	if (resComando.ok == false) {
		this.iface.pub_log.child("log").append("Error al borrar los archivos ocultos de subversion en " + dirDestino1 + "/" + dirDestino2);
		return false;
	}

	comando = this.iface.pathLocal + "delsvn.sh ";
	resComando = flmaveppal.iface.pub_ejecutarComando(comando);
	if (resComando.ok == false) {
		this.iface.pub_log.child("log").append("Error al borrar los archivos ocultos de subversion en " + dirDestino1 + "/" + dirDestino2);
		return false;
	}
	
// 	var resComando:Array = this.iface.ejecutarComando("rm -rf .svn");
// 	if (resComando.ok == false) {
// 		this.iface.pub_log.child("log").append("Error al borrar los archivos ocultos de subversion en " + dirDestino1 + "/" + dirDestino2);
// 		return false;
// 	}
	return true;
}

/** \D Concatena las pruebas de un directorio test al directorio test global del parche

@param	rutaDirTest: ruta al directorio donde obtener el parche, relativa al directorio de funcionalidades local
@param	codFuncional: Nombre de la funcionalidad (directorio) donde se concatenarán las pruebas obtenidas (también puede ser un identificador de cliente)
@return	True si no hay error, false en caso contrario
*/
function head_anadirTest(rutaDirTest:String, codFuncional:String):Boolean
{
	return true;
	/// Obsoleto
	rutaDirTestC = this.iface.pathLocal + rutaDirTest + "/test";
	if (!File.exists(rutaDirTestC))
		return true;
	var dirTestOrigen = new Dir(rutaDirTestC);
	var ficherosCsv:Array = dirTestOrigen.entryList("*.csv");
	var contenido:String = "";
	var rutaFichDestino:String = "";
	var rutaFichOrigen:String = "";
	
	if (!File.exists(this.iface.pathLocal + codFuncional + "/test")) {
		var dirTest = new Dir(this.iface.pathLocal + codFuncional);
		dirTest.mkdir("test");
	}
	
	for (var i:Number = 0; i < ficherosCsv.length; i++) {
		rutaFichDestino = this.iface.pathLocal + codFuncional + "/test/" + ficherosCsv[i];
		rutaFichOrigen = rutaDirTestC + "/" + ficherosCsv[i];
		if (File.exists(rutaFichDestino))
			contenido = File.read(rutaFichDestino);
		else
			contenido = "";
		contenido += File.read(rutaFichOrigen);
		File.write(rutaFichDestino, contenido);
	}
	return true;
}

/** \D Obtiene un parche del repositorio

@param	codFuncional: funcionalidad
@param	dirParche: directorio donde obtener el parche
@return	True si no hay error, false en caso contrario
\end */
function head_checkoutParche(codFuncional:String, dirParche:String, versionBase:String):Boolean
{
	var util:FLUtil = new FLUtil;
	var comando:String;
	var resComando:Array;
	this.iface.pub_log.child("log").append("Obteniendo parche " + codFuncional);
	
	Dir.current = flmaveppal.iface.pathLocal;
	if (File.exists(dirParche)) {
		resComando = this.iface.ejecutarComando("svn up " + dirParche);
		if (resComando.ok == false) {
			this.iface.pub_log.child("log").append("Error al actualizar el directorio " + dirParche);
			return false;
		}
	} else {
		var codigoWeb:Boolean = util.sqlSelect("mv_funcional", "codigoweb", "codfuncional = '" + codFuncional + "'");
		var repositorio:String;
// debug("CO " + versionBase);
		if (!versionBase) {
			versionBase = "tronco";
		}
// debug("CO2 " + versionBase);
		if (codigoWeb) {
			repositorio = this.iface.urlRepositorioWebFun;
		} else {
			repositorio = this.iface.urlRepositorioFun + versionBase + "/";
		}
		comando = "svn checkout " + repositorio + codFuncional + "/tronco/ " + dirParche;
		resComando = this.iface.ejecutarComando(comando);
		if (resComando.ok == false) {
			this.iface.pub_log.child("log").append("Error en el checkout del parche " + codFuncional + " en " + dirParche);
			return false;
		}
	}
	
	this.iface.pub_log.child("log").append("OK");
	sys.processEvents();
	return true;
}

function head_reemplazar(texto:String, antes:String, despues:String):String
{
	var resultado:String = texto;
	while (resultado.find(antes) > 0) {
		resultado = resultado.replace(antes, despues);
	}
	return resultado;
}

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////