/***************************************************************************
                 flcolagedo.qs  -  description
                             -------------------
    begin                : jue jul 20 2006
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
		this.ctx.interna_init();
	}
	function beforeCommit_gd_documentos(curDocumento:FLSqlCursor):Boolean {
		return this.ctx.interna_beforeCommit_gd_documentos(curDocumento);
	}
	function afterCommit_gd_documentos(curDocumento:FLSqlCursor):Boolean {
		return this.ctx.interna_afterCommit_gd_documentos(curDocumento);
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var tipoActual_:String;
	var itemActual_:Object;
	var pathLocal:String;
	var tipoRepositorio_:String;
	var urlRepositorio_:String;
	var container_:Object;
	var cursor_:Object;
	var tipoObjetoRaiz_:String;
	var curDocumento_:FLSqlCursor;
	var comandoCP_:String;
	function oficial( context ) { interna( context ); }
	function valoresIniciales() {
		return this.ctx.oficial_valoresIniciales();
	}
	function siguienteNumero(tipoDoc:String):Number {
		return this.ctx.oficial_siguienteNumero(tipoDoc);
	}
	function gestionDocumentalOn(container:Object, datosGD:Array):Boolean {
		return this.ctx.oficial_gestionDocumentalOn(container, datosGD);
	}
	function gestionDocumentalOff() {
		return this.ctx.oficial_gestionDocumentalOff();
	}
	function ejecutarComando(comando, workdir):Array {
		return this.ctx.oficial_ejecutarComando(comando, workdir);
	}
	function ejecutarComandoAsincrono(comando):Array {
		return this.ctx.oficial_ejecutarComandoAsincrono(comando);
	}
	function obtenerRevision(codDocumento:String):String {
		return this.ctx.oficial_obtenerRevision(codDocumento);
	}
	function verificarDirLocal(url:String):Boolean {
		return this.ctx.oficial_verificarDirLocal(url);
	}
	function svnUp(nombre:String, version:String, revision:String, rutaReposotorio:String):String {
		return this.ctx.oficial_svnUp(nombre, version, revision, rutaReposotorio);
	}
	function svnStatus(nombre:String, version:String):String {
		return this.ctx.oficial_svnStatus(nombre, version);
	}
	function dirUp(nombre:String, version:String):String {
		return this.ctx.oficial_dirUp(nombre, version);
	}
	function distUp(nombre:String, rutaRepositorio:String):String {
		return this.ctx.oficial_distUp(nombre, rutaRepositorio);
	}
	function dirStatus(nombre:String, version:String):String {
		return this.ctx.oficial_dirStatus(nombre, version);
	}
	function distStatus(nombre:String, rutaRepositorio:String):String {
		return this.ctx.oficial_distStatus(nombre, rutaRepositorio);
	}
	function borrarDocRepo(codigo:String):Boolean {
		return this.ctx.oficial_borrarDocRepo(codigo);
	}
	function dirBorrarDocRepo(codigo:String):Boolean {
		return this.ctx.oficial_dirBorrarDocRepo(codigo);
	}
	function subirDocumento(nombre:String, comentario:String):String {
		return this.ctx.oficial_subirDocumento(nombre, comentario);
	}
	function dirSubirDocumento(nombre:String, comentario:String):String {
		return this.ctx.oficial_dirSubirDocumento(nombre, comentario);
	}
	function distSubirDocumento(curDocumento:FLSqlCursor, comentario:String):String {
		return this.ctx.oficial_distSubirDocumento(curDocumento, comentario);
	}
	function copiarDocRepo(codDocumento:String, pathDoc:String, version:String):Boolean {
		return this.ctx.oficial_copiarDocRepo(codDocumento, pathDoc, version);
	}
	function obtenerPathLocal():String {
		return this.ctx.oficial_obtenerPathLocal();
	}
	function obtenerDocumento(codDocumento:String, pathDirectorio:String, version:String, revision:String, rutaRepositorio:String):Boolean {
		return this.ctx.oficial_obtenerDocumento(codDocumento, pathDirectorio, version, revision, rutaRepositorio);
	}
	function obtenerCodigoDoc(tipo:String):String {
		return this.ctx.oficial_obtenerCodigoDoc(tipo);
	}
	function asociarDocumento(idDocumento:String, tipoObjeto:String, idContenedor:String):Boolean {
		return this.ctx.oficial_asociarDocumento(idDocumento, tipoObjeto, idContenedor);
	}
	function abrirDocumentoGD(item:FLListViewItem):Boolean {
		return this.ctx.oficial_abrirDocumentoGD(item);
	}
	function cambiarSeleccionGD(item:FLListViewItem) {
		return this.ctx.oficial_cambiarSeleccionGD(item);
	}
	function editarDocumentoGD(item:FLListViewItem) {
		return this.ctx.oficial_editarDocumentoGD(item);
	}
	function asociarDoc_clickedGD() {
		return this.ctx.oficial_asociarDoc_clickedGD();
	}
	function quitarDoc_clickedGD() {
		return this.ctx.oficial_quitarDoc_clickedGD();
	}
	function comprobarDependenciasGD(idDocumento:String, tipoObjeto:String, idContenedor:String):Boolean {
		return this.ctx.oficial_comprobarDependenciasGD(idDocumento, tipoObjeto, idContenedor);
	}
	function crearDocumentoGD() {
		return this.ctx.oficial_crearDocumentoGD();
	}
	function borrarDocumentoGD() {
		return this.ctx.oficial_borrarDocumentoGD();
	}
	function verDocumentoGD() {
		return this.ctx.oficial_verDocumentoGD();
	}
	function bajarDocumentoGD():Boolean {
		return this.ctx.oficial_bajarDocumentoGD();
	}
	function vincularDocumentoGD():Boolean {
		return this.ctx.oficial_vincularDocumentoGD();
	}
	function verificarConfiguracion():Boolean {
		return this.ctx.oficial_verificarConfiguracion();
	}
	function datosUsrFecha(idUsuario:String, fecha:String, hora:String):String {
		return this.ctx.oficial_datosUsrFecha(idUsuario, fecha, hora);
	}
	function datosItemActual():Array {
		return this.ctx.oficial_datosItemActual();
	}
	function abrirItemActual() {
		return this.ctx.oficial_abrirItemActual();
	}
	function mostrarDocsRelacionados(item:FLListViewItem, tipoObjeto:String, clave:String):Boolean {
		return this.ctx.oficial_mostrarDocsRelacionados(item, tipoObjeto, clave);
	}
	function nombreObjetoContenedor(tipoObjeto:String, clave:String):String {
		return this.ctx.oficial_nombreObjetoContenedor(tipoObjeto, clave);
	}
	function dameObjetoVinculado(eVinculos:FLDomElement, tipoObjeto:String):String {
		return this.ctx.oficial_dameObjetoVinculado(eVinculos, tipoObjeto);
	}
	function crearDocumento(codTipo:String, nombre:String, prefijo:String, masDatos:Array):String {
		return this.ctx.oficial_crearDocumento(codTipo, nombre, prefijo, masDatos);
	}
	function valorCampoPlantilla(codTipo:String, campo:String, eDoc:FLDomElement):String {
		return this.ctx.oficial_valorCampoPlantilla(codTipo, campo, eDoc);
	}
	function generarProcesoDoc(curDocumento:FLSqlCursor):Boolean {
		return this.ctx.oficial_generarProcesoDoc(curDocumento);
	}
	function borrarDocumento(idDocumento:String):Boolean {
		return this.ctx.oficial_borrarDocumento(idDocumento);
	}
	function borrarContenidoContenedor(idDocContenedor:String):Boolean {
		return this.ctx.oficial_borrarContenidoContenedor(idDocContenedor);
	}
	function datosDocumento(datos:Array):Boolean {
		return this.ctx.oficial_datosDocumento(datos);
	}
	function adaptarRuta(ruta:String):String {
		return this.ctx.oficial_adaptarRuta(ruta);
	}
	function obtenerTipoRepositorio():String {
		return this.ctx.oficial_obtenerTipoRepositorio();
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
	function pub_gestionDocumentalOn(container, datosGD) {
		return this.gestionDocumentalOn(container, datosGD);
	}
	function pub_gestionDocumentalOff() {
		return this.gestionDocumentalOff();
	}
	function pub_svnUp(nombre:String, version:String, revision:String, rutaRepositorio:String):String {
		return this.svnUp(nombre, version, revision, rutaRepositorio);
	}
	function pub_svnStatus(nombre:String, version:String):String {
		return this.svnStatus(nombre, version);
	}
	function pub_copiarDocRepo(codDocumento:String, pathDoc:String, version:String):Boolean {
		return this.copiarDocRepo(codDocumento, pathDoc, version);
	}
	function pub_obtenerPathLocal():String {
		return this.obtenerPathLocal();
	}
	function pub_ejecutarComando(comando, workdir):Array {
		return this.ejecutarComando(comando, workdir);
	}
	function pub_ejecutarComandoAsincrono(comando):Array {
		return this.ejecutarComandoAsincrono(comando);
	}
	function pub_obtenerDocumento(codDocumento:String, pathDirectorio:String, version:String, revision:String, rutaRepositorio:String):Boolean {
		return this.obtenerDocumento(codDocumento, pathDirectorio, version, revision, rutaRepositorio);
	}
	function pub_obtenerCodigoDoc(tipo:String):String {
		return this.obtenerCodigoDoc(tipo);
	}
	function pub_subirDocumento(nombre:String, comentario:String):String {
		return this.subirDocumento(nombre, comentario);
	}
	function pub_asociarDocumento(idDocumento:String, tipoObjeto:String, idContenedor:String):Boolean {
		return this.asociarDocumento(idDocumento, tipoObjeto, idContenedor);
	}
	function pub_datosItemActual():Array {
		return this.datosItemActual();
	}
	function pub_abrirItemActual() {
		return this.abrirItemActual();
	}
	function pub_dameObjetoVinculado(eVinculos:FLDomElement, tipoObjeto:String):String {
		return this.dameObjetoVinculado(eVinculos, tipoObjeto);
	}
	function pub_crearDocumento(codTipo:String, nombre:String, prefijo:String, masDatos:Array):String {
		return this.crearDocumento(codTipo, nombre, prefijo, masDatos);
	}
	function pub_valorCampoPlantilla(codTipo:String, campo:String, eDoc:FLDomElement):String {
		return this.valorCampoPlantilla(codTipo, campo, eDoc);
	}
	function pub_adaptarRuta(ruta:String):String {
		return this.adaptarRuta(ruta);
	}
	function pub_obtenerTipoRepositorio():String {
		return this.obtenerTipoRepositorio();
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
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = new FLSqlCursor("gd_tiposdoc");
	cursor.select();
	if (!cursor.first()) {
		MessageBox.information(util.translate("scripts", "Se insertarán los tipos de documento por defecto para empezar a trabajar."), MessageBox.Ok, MessageBox.NoButton);
		this.iface.valoresIniciales();
		this.execMainScript("gd_config");
	}
	
	this.iface.verificarConfiguracion();
}

function interna_beforeCommit_gd_documentos(curDocumento:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	switch (curDocumento.modeAccess()) {
		/** \C Alta: Se obtiene un código único que será el nombre del documento en el repositorio
		\end */
		case curDocumento.Insert: {
			var codigo:String;
			if (curDocumento.valueBuffer("codigo") == "0") {
				codigo = this.iface.obtenerCodigoDoc("general");
				curDocumento.setValueBuffer("codigo", codigo);
			}
			if (curDocumento.isNull("estado")) {
				var estado:String = util.sqlSelect("gd_tiposdoc", "estadoinicial", "codtipo = '" + curDocumento.valueBuffer("codtipo") + "'");
				curDocumento.setValueBuffer("estado", estado);
			}
			break;
		}
		case curDocumento.Del: {
			if (util.sqlSelect("gd_tiposdoc", "contenedor", "codtipo = '" + curDocumento.valueBuffer("codtipo") + "'")) {
				if (!this.iface.borrarContenidoContenedor(curDocumento.valueBuffer("iddocumento"))) {
					return false;
				}
			}
			break;
		}
	}
	return true;
}

function interna_afterCommit_gd_documentos(curDocumento:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	switch (curDocumento.modeAccess()) {
		/** \C Alta: El documento se asocia al contenedor desde donde se ha creado
		\end */
		case curDocumento.Insert: {
			if (sys.isLoadedModule("flcolaproc")) {
				if (!this.iface.generarProcesoDoc(curDocumento)) {
					return false;
				}
			}
			break;
		}
		case curDocumento.Edit: {
			break;
		}
		case curDocumento.Del: {
			if (sys.isLoadedModule("flcolaproc")) {
				if (!flcolaproc.iface.pub_borrarProcesosAsociados("gd_documentos", curDocumento.valueBuffer("iddocumento"))) {
					MessageBox.warning(util.translate("scripts", "Error al borrar los procesos asociados al documento %1: %2").arg(curDocumento.valueBuffer("codigo")).arg(curDocumento.valueBuffer("nombre")), MessageBox.Ok, MessageBox.NoButton);
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
/** \D
Obtiene el siguiente número de la secuencia de documentos
@param tipoDoc: Tipo de documento
@return Número correspondiente al siguiente documento o false si hay error
\end */
function oficial_siguienteNumero(tipoDoc:String):Number
{
	var numero:Number = 1;
	var util:FLUtil = new FLUtil;
	
	/** \C
	Para minimizar bloqueos las secuencias se han separado en distintos registros de otra tabla
	llamada secuencias
	\end */
	var cursorSecs:FLSqlCursor = new FLSqlCursor( "gd_secuencias" );
	cursorSecs.setContext( this );
	cursorSecs.setActivatedCheckIntegrity( false );
	/** \C
	Si el registro no existe lo crea inicializandolo con su antiguo valor del campo correspondiente
	en la tabla secuenciasejercicios.
	\end */
	cursorSecs.select( "nombre='" + tipoDoc + "'" );
	if ( !cursorSecs.next() ) {
		var pass:String = util.readSettingEntry( "DBA/password");
		var port:String = util.readSettingEntry( "DBA/port");
		if (!sys.addDatabase(sys.nameDriver(), sys.nameBD(), sys.nameUser(), pass, sys.nameHost(), port, "conAux")) {
			MessageBox.warning(util.translate("scripts", "Ha habido un error al establecer una conexión auxiliar con la base de datos %1").arg(sys.nameBD()), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
		var curSecuencia:FLSqlCursor = new FLSqlCursor("gd_secuencias", "conAux");
		curSecuencia.setModeAccess(curSecuencia.Insert);
		curSecuencia.refreshBuffer();
		curSecuencia.setValueBuffer("nombre", tipoDoc);
		curSecuencia.setValueBuffer("valorout", 2);
		if (!curSecuencia.commitBuffer()) {
			return false;
		}
	} else {
		cursorSecs.setModeAccess( cursorSecs.Edit );
		cursorSecs.refreshBuffer();
		numero = cursorSecs.valueBuffer( "valorout" );
		cursorSecs.setValueBuffer( "valorout", numero + 1);
		cursorSecs.commitBuffer();
	}
	cursorSecs.setActivatedCheckIntegrity( true );
	return numero;
}

/** \D
Ejecuta un comando externo
@param comando: Comando a ejecutar
@param workdir: Directorio de trabajo donde se iniciará el comando
@return Array con dos datos:
	ok: True si no hay error, false en caso contrario
	salida: Mensaje de stdout o stderr obtenido
\end */
function oficial_ejecutarComando(comando, workdir):Array
{
debug("workdir = " + workdir);
	var res = new Array("ok", "salida");
	var proc = new Process;
	if (workdir != undefined && !workdir.isEmpty()) {
		proc.workingDirectory = workdir;
	} else {
		proc.workingDirectory = Dir.home;
	}
debug("WD = " + proc.workingDirectory);
	proc.arguments = comando;
	debug(proc.workingDirectory  + " " +  workdir + " $ " + proc.arguments.join(" "));

	proc.start();
	sys.processEvents();
	while (proc.running) {}
	sys.processEvents();

	var stdErr = proc.readStderr();
	if (!stdErr.isEmpty()) {
		res["ok"] = false;
		res["salida"] = stdErr;
	} else {
		res["ok"] = true;
		res["salida"] = proc.readStdout();
		debug("Ok\n" + res["salida"]);
	}
	return res;
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

/** \D Obtiene la revisión del documento en subversion
@param	codDocumento: Nombre del documento en el repositorio
@return	Código de la revisión o false si hay error
\end */
function oficial_obtenerRevision(codDocumento:String):String
{
	var util:FLUtil = new FLUtil();
/*
	var fichSVN = this.iface.pathLocal + codDocumento + "/.svn/entries";
	if (!File.exists(fichSVN)) {
		MessageBox.critical(util.translate("scripts", "%1\nno se encuentra bajo control de versiones. Imposible obtener el número de revisión").arg(this.iface.pathLocal + codDocumento), MessageBox.Ok, MessageBox.Cancel);
		return false;
	}

	var svnEntradas:FLDomDocument = new FLDomDocument;
	if (!svnEntradas.setContent(File.read(fichSVN)))
		return false;

	var entradas:FLDomNodeList = svnEntradas.elementsByTagName("entry");
	var revision:String;
	for (var i:Number = 0; i < entradas.length(); i++) {
		if (entradas.item(i).toElement().attribute("name") == codDocumento) {
			revision = entradas.item(i).toElement().attribute("committed-rev");
			break;
		}
	}
*/

	var dirModulo:String = this.iface.pathLocal + codDocumento;
	var comando:String = ["svn", "info", dirModulo];
	var res:Array = this.iface.ejecutarComando(comando);
	if (res["ok"] == false) {
		MessageBox.critical(util.translate("scripts", "Error al buscar la revisión del documento %1").arg(codDocumento), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var info:String = res["salida"];
// 	var caracteresRev:Number = 10;
// 	var iRevision:Number = info.find("Revisión: ");
// 	if (iRevision < 0) {
// 		iRevision = info.find("Revision: ");
// 	}
// 	if (iRevision < 0) {
// 		iRevision = info.find("Revisió: ");
// 		caracteresRev = 9;
// 	}
// 	var iFinRevision:Number;
// 	if (iRevision >= 0) {
// 		iFinRevision = info.find("\n", iRevision);
// 	}
// 	revision = info.substring(iRevision + caracteresRev, iFinRevision);
	var iRevision:Number = info.find("Revisi");
	if (iRevision < 0) {
		return 1;
	}
	iRevision = info.find(": ", iRevision);
	if (iRevision < 0) {
		return 1;
	}
	var iFinRevision:Number;
	iFinRevision = info.find("\n", iRevision);
	revision = info.substring(iRevision + 2, iFinRevision);

	return revision;
}


function oficial_obtenerTipoRepositorio():String
{
	return this.iface.tipoRepositorio_;
}

/** \D Comprueba que el directorio local existe y está asociado al repositorio. Si no existe, lo crea.
@param	url: U.R.L. del repositorio
@return	True si la verificación se realiza con éxito, false en caso contrario
\end */
function oficial_verificarDirLocal(url:String):Boolean
{
	var util:FLUtil = new FLUtil;
	var comando:String;
	var resComando:Array;
	if (!File.exists(Dir.home + "/tmp")) {
		var dir:Dir = new Dir(Dir.home);
		dir.mkdir("tmp");
	}
	var nombreBD:String = sys.nameBD();
	switch (this.iface.tipoRepositorio_) {
		case "Directorio":
		case "Distribuido": {
			if (!File.exists(Dir.home + "/tmp/bqdoc_" + nombreBD)) {
				var dir:Dir = new Dir(Dir.home + "/tmp");
				dir.mkdir("bqdoc_" + nombreBD);
			}
			break;
		}
		case "Repositorio Subversion": {
			if (!File.exists(Dir.home + "/tmp/bqdoc_" + nombreBD)) {
				//comando = "svn co -N " + url + " " + Dir.home + "/tmp/fldoc";
				comando = ["svn", "co", "-N", url, Dir.home + "/tmp/bqdoc_" + nombreBD];
				resComando = this.iface.ejecutarComando(comando);
				if (resComando.ok == false) {
					MessageBox.warning(util.translate("scripts", "Error al conectar con el repositorio.\n%1\n%2").arg(comando).arg(resComando.salida), MessageBox.Ok, MessageBox.NoButton);
					return false;
				}
			}
		
			//comando = "svn status " + Dir.home + "/tmp/fldoc";
			comando = ["svn", "status", Dir.home + "/tmp/bqdoc_" + nombreBD];
			resComando = this.iface.ejecutarComando(comando);
			if (resComando.ok == false) {
				MessageBox.warning(util.translate("scripts", "Error al comprobar el directorio local.\n%1\n%2").arg(comando).arg(resComando.salida), MessageBox.Ok, MessageBox.NoButton);
				return false;
			}
			break;
		}
	}
	return true;
}

/** \D Comprueba si un documento existe actualmente en el repositorio
@param: nombre: Nombre del documento en el repositorio
@param: versión a obtener: Si no está definida se toma la última 
@param: revisión a obtener: Si no está definida se toma la última (HEAD)
@param rutaRepositorio: Ruta del fichero en el repositorio (para el tipo de repositorio distribuido)
@return	Los posibles valores son:
<p/>X: El documento no existe
<p/>XX: El directorio que contiene el documento no existe
<p/>?: El documento existe pero no está incluido en el control de versiones
<p/>??: El directorio del documento existe pero no está incluido en el control de versiones
<p/>U: El documento existe y está sincronizado con el repositorio
<p/>M: El documento existe y está modificado respecto al repositorio
<p/>A: El documento existe y está planificado para ser añadido al repositorio
<p/>C: El documento tiene un conflicto
\end */
function oficial_svnUp(nombre:String, version:String, revision:String, rutaRepositorio:String):String
{
	switch (this.iface.tipoRepositorio_) {
		case "Directorio": {
			return this.iface.dirUp(nombre, version);
			break;
		}
		case "Distribuido": {
			return this.iface.distUp(nombre, rutaRepositorio);
			break;
		}
	}

	var util:FLUtil = new FLUtil;
	//var comando:String = "svn up " + this.iface.pathLocal + nombre;
	var comando:String = ["svn", "up", this.iface.pathLocal + nombre];
	if (revision) {
		//comando += " -r " + revision;
		comando[3] = "-r";
		comando[4] = revision;
	}
	var resComando:Array = this.iface.ejecutarComando(comando);
	if (resComando.ok == false) {
		MessageBox.warning(util.translate("scripts", "Error al obtener el fichero.\n%1\n%2").arg(comando).arg(resComando.salida), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var resultado:String = this.iface.svnStatus(nombre);
	return resultado;
}

/** \D Comprueba si un documento existe actualmente en el repositorio
@param: nombre: Nombre del documento en el repositorio
@param: revision: Es la versión del documento a obtener
@return	Los posibles valores son:
<p/>X: El documento no existe
<p/>XX: El directorio que contiene el documento no existe
<p/>?: El documento existe pero no está incluido en el control de versiones
<p/>??: El directorio del documento existe pero no está incluido en el control de versiones
<p/>U: El documento existe y está sincronizado con el repositorio
<p/>M: El documento existe y está modificado respecto al repositorio
<p/>A: El documento existe y está planificado para ser añadido al repositorio
<p/>C: El documento tiene un conflicto
\end */
function oficial_dirUp(nombre:String, version:String):String
{
	var util:FLUtil = new FLUtil;

	if (!version) {
		version = util.sqlSelect("gd_documentos d INNER JOIN gd_versionesdoc vd ON d.idversionactual = vd.idversion", "vd.version", "d.codigo = '" + nombre + "'", "gd_versionesdoc,gd_documentos");
		if (!version) {
			return false;
		}
	}
	if (File.exists(this.iface.urlRepositorio_ + "/" + nombre + "/" + nombre + "-" + version)) {
		if (!File.exists(this.iface.pathLocal + nombre )) {
			var dir:Dir = new Dir(this.iface.pathLocal);
			dir.mkdir(nombre);
		}
		//var comando:String = "cp " + this.iface.urlRepositorio_ + "/" + nombre + "/" + nombre + "-" + version + " " + this.iface.pathLocal + nombre + "/" + nombre;
		var comando:String = [this.iface.comandoCP_, this.iface.urlRepositorio_ + "/" + nombre + "/" + nombre + "-" + version, this.iface.pathLocal + nombre + "/" + nombre];
		var resComando:Array = this.iface.ejecutarComando(comando);
		if (resComando.ok == false) {
			MessageBox.warning(util.translate("scripts", "Error al obtener el fichero.\n%1\n%2").arg(comando).arg(resComando.salida), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}
	var resultado:String = this.iface.dirStatus(nombre, version);
	return resultado;
}

function oficial_distUp(nombre:String, rutaRepositorio:String):String
{
debug("oficial_distUp");
	var util:FLUtil = new FLUtil;

	if (File.exists(rutaRepositorio + "/" + nombre)) {
		if (!File.exists(this.iface.pathLocal + nombre )) {
			var dir:Dir = new Dir(this.iface.pathLocal);
			dir.mkdir(nombre);
		}
		var comando:String = [this.iface.comandoCP_, rutaRepositorio + "/" + nombre, this.iface.pathLocal + nombre];
		var resComando:Array = this.iface.ejecutarComando(comando);
		if (resComando.ok == false) {
			MessageBox.warning(util.translate("scripts", "Error al obtener el fichero.\n%1\n%2").arg(comando).arg(resComando.salida), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}
	var resultado:String = this.iface.distStatus(nombre, rutaRepositorio);
	return resultado;
}

/** \D Comprueba el estado de la versión local de un documento respecto a la versión del repositorio
@param nombre: Nombre del documento en el repositorio
@param version: Version del documento
@return	Los posibles valores son:
<p/>X: El documento no existe
<p/>XX: El directorio que contiene el documento no existe
<p/>?: El documento existe pero no está incluido en el control de versiones
<p/>??: El directorio del documento existe pero no está incluido en el control de versiones
<p/>U: El documento existe y está sincronizado con el repositorio
<p/>M: El documento existe y está modificado respecto al repositorio
<p/>A: El documento existe y está planificado para ser añadido al repositorio
<p/>C: El documento tiene un conflicto
\end */
function oficial_svnStatus(nombre:String, version:String):String
{
	if (this.iface.tipoRepositorio_ == "Directorio")
		return this.iface.dirStatus(nombre, version);

	var util:FLUtil = new FLUtil;
	var comando:String;
	var resComando:Array;
	if (!File.exists(this.iface.pathLocal + nombre))
		return "XX";

	if (!File.exists(this.iface.pathLocal + nombre + "/" + nombre))
		return "X";

	if (!File.exists(this.iface.pathLocal + nombre + "/.svn"))
		return "??";

	//comando = "svn status " + this.iface.pathLocal + nombre + "/" + nombre;
	comando = ["svn", "status", this.iface.pathLocal + nombre + "/" + nombre];
	resComando = this.iface.ejecutarComando(comando);
	if (resComando.ok == false) {
		MessageBox.warning(util.translate("scripts", "Error obtener el estado del documento:\n%1\n%2").arg(comando).arg(resComando.salida), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var salida:Array = resComando.salida.split("\n");
	if (salida[0] == "")
		return "U";
	var resultado:String = resComando.salida.charAt(0);
	return resultado;
}

/** \D Comprueba el estado de la versión local de un documento respecto a la versión del repositorio
@param: nombre: Nombre del documento en el repositorio
@param: version: Versión del documento en el repositorio
@return	Los posibles valores son:
<p/>X: El documento no existe
<p/>XX: El directorio que contiene el documento no existe
<p/>?: El directorio del documento no existe en el repositorio
<p/>??: El documento existe no existe en el repositorio
<p/>U: El documento existe y está sincronizado con el repositorio
\end */
function oficial_dirStatus(nombre:String, version:String):String
{
	var util:FLUtil = new FLUtil;
	var comando:String;
	var resComando:Array;

	if (!File.exists(this.iface.pathLocal + nombre))
		return "XX";

	if (!File.exists(this.iface.pathLocal + nombre + "/" + nombre))
		return "X";
debug(this.iface.urlRepositorio_ + nombre);
	if (!File.exists(this.iface.urlRepositorio_ + nombre))
		return "?";

debug(this.iface.urlRepositorio_ + nombre + "/" + nombre + "-" + version);
	if (!File.exists(this.iface.urlRepositorio_ + nombre + "/" + nombre + "-" + version))
		return "??";

	/********** C Controlar fechas ************/
	
	return "U";
}

/** \D Comprueba el estado de la versión local de un documento respecto a la versión del repositorio
@param: nombre: Nombre del documento en el repositorio
@param: version: Versión del documento en el repositorio
@return	Los posibles valores son:
<p/>X: El documento no existe
<p/>XX: El directorio que contiene el documento no existe
<p/>?: El directorio del documento no existe en el repositorio
<p/>??: El documento existe no existe en el repositorio
<p/>U: El documento existe y está sincronizado con el repositorio
\end */
function oficial_distStatus(nombre:String, rutaRepositorio:String):String
{
	var util:FLUtil = new FLUtil;
	var comando:String;
	var resComando:Array;
// debug(this.iface.pathLocal + nombre);
// 	if (!File.exists(this.iface.pathLocal + nombre)) {
// 		return "X";
// 	}
debug(this.iface.urlRepositorio_ + rutaRepositorio);
	if (!File.exists(rutaRepositorio)) {
		return "?";
	}

debug(this.iface.urlRepositorio_ + rutaRepositorio + "/" + nombre);
	if (!File.exists(rutaRepositorio + "/" + nombre)) {
		return "??";
	}

	/********** C Controlar fechas ************/
	
	return "U";
}


/** \D Borra un documento del repositorio
@param	codigo: Nombre del documento en el repositorio
@return	True si el documento es eliminado correctamente, false en caso contrario
\end */
function oficial_borrarDocRepo(codigo:String):Boolean
{
	if (this.iface.tipoRepositorio_ == "Directorio")
		return this.iface.dirBorrarDocRepo(codigo);

	var util:FLUtil = new FLUtil;
	var urlRepo:String = util.sqlSelect("gd_config", "urlrepositorio", "1 = 1");
	if (!urlRepo)
		return false;

	var estado:String = this.iface.svnUp(codigo);
	switch (estado) {
		case "C": {
			MessageBox.warning(util.translate("scripts", "No puede actualizar el documento en el repositorio.\nHay un conflicto entre la versión local y la del repositorio"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
		case "XX":
		case "X":
		case "??":
		case "?": {
			break;
		}
		case "A": {
			comando = ["svn", "revert", codigo];
			resComando = this.iface.ejecutarComando(comando, this.iface.pathLocal);
			if (resComando.ok == false) {
				MessageBox.warning(util.translate("scripts", "Error al revertir el estado del documento %1:\n%2").arg(codigo).arg(resComando.salida), MessageBox.Ok, MessageBox.NoButton);
				return false;
			}
			break;
		}
		case "U":
		case "M": {
			//comando = "svn del " + this.iface.pathLocal + codigo;
			comando = ["svn", "del", codigo];
			resComando = this.iface.ejecutarComando(comando, this.iface.pathLocal);
			if (resComando.ok == false) {
				MessageBox.warning(util.translate("scripts", "Error al borrar el documento %1:\n%2").arg(codigo).arg(resComando.salida), MessageBox.Ok, MessageBox.NoButton);
				return false;
			}
			comando = ["svn", "commit", codigo, "-m", "HOLA"];
			resComando = this.iface.ejecutarComando(comando, this.iface.pathLocal);

// 			comando = ["svn", "commit", this.iface.pathLocal + codigo, "-m", "HOLA"];
// 			resComando = this.iface.ejecutarComando(comando);
			if (resComando.ok == false) {
				MessageBox.warning(util.translate("scripts", "Error al borrar el documento %1 en el repositorio:\n%2").arg(codigo).arg(resComando.salida), MessageBox.Ok, MessageBox.NoButton);
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

/** \D Borra un documento del repositorio
@param	codigo: Nombre del documento en el repositorio
@return	True si el documento es eliminado correctamente, false en caso contrario
\end */
function oficial_dirBorrarDocRepo(codigo:String):Boolean
{
	//var comando:String = "rm -rf " + this.iface.pathLocal + codigo;
	var comando:String = ["rm", "-rf", this.iface.pathLocal + codigo];
	var resComando:Array = this.iface.ejecutarComando(comando);
	if (resComando.ok == false) {
		MessageBox.warning(util.translate("scripts", "Error al borrar el documento %1:\n%2").arg(codigo).arg(resComando.salida), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	//comando = "rm -rf  " + this.iface.urlRepositorio_ + codigo;
	comando = ["rm", "-rf", this.iface.urlRepositorio_ + codigo];
	resComando = this.iface.ejecutarComando(comando);
	if (resComando.ok == false) {
		MessageBox.warning(util.translate("scripts", "Error al borrar el documento %1 en el repositorio:\n%2").arg(codigo).arg(resComando.salida), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	return true;
}

/** \D Sube un documento al repositorio
@param: curDocumento: Cursor con los datos del documento
@param: comentario: texto con el que se etiquetará la nueva versión
@return	revisión actual si el documento es actualizado correctamente en el repositorio, false en caso contrario
\end */
function oficial_subirDocumento(curDocumento:FLSqlCursor, comentario:String):String
{
	switch (this.iface.tipoRepositorio_) {
		case "Directorio": {
			return this.iface.dirSubirDocumento(curDocumento, comentario);
			break;
		}
		case "Distribuido": {
			return this.iface.distSubirDocumento(curDocumento, comentario);
			break;
		}
	}

	var util:FLUtil = new FLUtil;
	var codigo:String = curDocumento.valueBuffer("codigo");
	util.createProgressDialog(util.translate("scripts", "Actualizando documento en el repositorio"), 5);
	util.setProgress(1);
	util.setLabelText(util.translate("scripts", "Comprobado estado..."));
	var estado:String = this.iface.svnStatus(codigo);
	switch (estado) {
		case "C": {
			MessageBox.warning(util.translate("scripts", "No puede actualizar el documento en el repositorio.\nHay un conflicto entre la versión local y la del repositorio"), MessageBox.Ok, MessageBox.NoButton);
			util.destroyProgressDialog();
			return false;
		}
		case "U": {
			// El documento está actualizado, no hace falta subirlo
			break;;
		}
		case "XX":
		case "X": {
			MessageBox.warning(util.translate("scripts", "No ha especificado el documento a enviar."), MessageBox.Ok, MessageBox.NoButton);
			util.destroyProgressDialog();
			return false;
		}
		case "??":
		case "?": {
			util.setProgress(2);
			util.setLabelText(util.translate("scripts", "Añadiendo nuevo fichero..."));
			if (estado == "??") {
				//comando = "svn add " + this.iface.pathLocal + codigo;
				comando = ["svn", "add", this.iface.pathLocal + codigo];
			} else {
				//comando = "svn add " + this.iface.pathLocal + codigo + "/" + codigo;
				comando = ["svn", "add", this.iface.pathLocal + codigo + "/" + codigo];
			}
			resComando = this.iface.ejecutarComando(comando);
			if (resComando.ok == false) {
				MessageBox.warning(util.translate("scripts", "Error al añadir el documento %1 al repositorio:\n%2").arg(codigo).arg(resComando.salida), MessageBox.Ok, MessageBox.NoButton);
				util.destroyProgressDialog();
				return false;
			}
		}
		case "M":
		case "A": {
			util.setProgress(3);
			util.setLabelText(util.translate("scripts", "Actualizando el repositorio..."));
			//comando = "svn commit " + this.iface.pathLocal + codigo + " -m HOLA";
			comando = ["svn", "commit", codigo, "-m", "HOLA"];
			resComando = this.iface.ejecutarComando(comando, this.iface.pathLocal);
			if (resComando.ok == false) {
				MessageBox.warning(util.translate("scripts", "Error al subir el documento %1 al repositorio:\n%2").arg(codigo).arg(resComando.salida), MessageBox.Ok, MessageBox.NoButton);
				util.destroyProgressDialog();
				return false;
			}
			break;
		}
		default: {
			util.destroyProgressDialog();
			return false;
		}
	}
	util.setProgress(4);
	util.setLabelText(util.translate("scripts", "Obteniendo última revisión..."));
	var revision:String = this.iface.obtenerRevision(codigo);
	if (!revision) {
		MessageBox.warning(util.translate("scripts", "Error al obtener la revisión actual del documento %1:\n%2").arg(codigo).arg(resComando.salida), MessageBox.Ok, MessageBox.NoButton);
		util.destroyProgressDialog();
		return false;
	}
	util.setProgress(5);
	util.setLabelText(util.translate("scripts", "Actualizando versión actual..."));
	if (!util.sqlUpdate("gd_versionesdoc", "versionrep", revision, "idversion = " + curDocumento.valueBuffer("idversionactual"))) {
		util.destroyProgressDialog();
		return false;
	}
	util.destroyProgressDialog();
	return true;
}

/** \D Sube un documento al repositorio
@param: curDocumento: Cursor con los datos del documento
@param: comentario: texto con el que se etiquetará la nueva versión
@return	revisión actual si el documento es actualizado correctamente en el repositorio, false en caso contrario
\end */
function oficial_dirSubirDocumento(curDocumento:FLSqlCursor, comentario:String):String
{
	var util:FLUtil = new FLUtil;
	var codigo:String = curDocumento.valueBuffer("codigo");
	util.createProgressDialog(util.translate("scripts", "Actualizando documento en el repositorio"), 4);
	util.setProgress(1);
	util.setLabelText(util.translate("scripts", "Comprobado estado..."));
	var version:String = util.sqlSelect("gd_versionesdoc", "version", "idversion = " + curDocumento.valueBuffer("idversionactual"));
	if (!version) {
		MessageBox.warning(util.translate("scripts", "No es posible enviar el documento al repositorio:\nNo se ha establecido correctamente la versión del documento"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var estado:String = this.iface.dirStatus(codigo, version);

	switch (estado) {
		case "C": {
			var res:Number = MessageBox.warning(util.translate("scripts", "La fecha de la versión local es anterior a la del repositorio. ¿Desea continuar enviando el documento?"), MessageBox.Yes, MessageBox.No);
			if (res != MessageBox.Yes) {
				util.destroyProgressDialog();
				return false;
			}
			break;
		}
		case "XX":
		case "X": {
			MessageBox.warning(util.translate("scripts", "No ha especificado el documento a enviar."), MessageBox.Ok, MessageBox.NoButton);
			util.destroyProgressDialog();
			return false;
		}
		case "?": {
			var rutaDir:String = this.iface.adaptarRuta(this.iface.urlRepositorio_);
			var dir:Dir = new Dir(rutaDir);
			dir.mkdir(codigo);
		}
		case "U":
		case "??":
		case "M":
		case "A": {
			util.setProgress(3);
			util.setLabelText(util.translate("scripts", "Actualizando el repositorio..."));
			//comando = "cp " + this.iface.pathLocal + codigo + "/" + codigo + " " + this.iface.urlRepositorio_ + codigo + "/" + codigo + "-" + version;
			comando = [this.iface.comandoCP_, this.iface.pathLocal + codigo + "/" + codigo, this.iface.urlRepositorio_ + codigo + "/" + codigo + "-" + version];
			resComando = this.iface.ejecutarComando(comando);
			if (resComando.ok == false) {
				MessageBox.warning(util.translate("scripts", "Error al subir el documento %1 al repositorio:\n%2").arg(codigo).arg(resComando.salida), MessageBox.Ok, MessageBox.NoButton);
				util.destroyProgressDialog();
				return false;
			}
			break;
		}
		default: {
			util.destroyProgressDialog();
			return false;
		}
	}
	util.setProgress(4);
	util.setLabelText(util.translate("scripts", "Actualizando versión actual..."));
	if (!util.sqlUpdate("gd_versionesdoc", "versionrep", version, "idversion = " + curDocumento.valueBuffer("idversionactual"))) {
		util.destroyProgressDialog();
		return false;
	}
	util.destroyProgressDialog();
	return true;
}

/** \D Sube un documento al repositorio en repositorios distribuidos
@param: curDocumento: Cursor con los datos del documento
@param: comentario: texto con el que se etiquetará la nueva versión
@return	revisión actual si el documento es actualizado correctamente en el repositorio, false en caso contrario
\end */
function oficial_distSubirDocumento(curDocumento:FLSqlCursor, comentario:String):String
{
	var util:FLUtil = new FLUtil;
	var codigo:String = curDocumento.valueBuffer("codigo");
	util.createProgressDialog(util.translate("scripts", "Actualizando documento en el repositorio"), 4);
	util.setProgress(1);
	util.setLabelText(util.translate("scripts", "Comprobado estado..."));
	var version:String = util.sqlSelect("gd_versionesdoc", "version", "idversion = " + curDocumento.valueBuffer("idversionactual"));
	if (!version) {
		MessageBox.warning(util.translate("scripts", "No es posible enviar el documento al repositorio:\nNo se ha establecido correctamente la versión del documento"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var fichero:String = curDocumento.valueBuffer("fichero");
	var rutaRepositorio:String = curDocumento.valueBuffer("rutarepositorio");
	var estado:String = this.iface.distStatus(fichero, rutaRepositorio);

	switch (estado) {
		case "C": {
			break;
		}
		case "XX":
		case "X": {
			return false;
		}
		case "?": {
			var dir:Dir = new Dir(rutaRepositorio);
		}
		case "U":
		case "??":
		case "M":
		case "A": {
			util.setProgress(3);
			util.setLabelText(util.translate("scripts", "Actualizando el repositorio..."));
			//comando = "cp " + this.iface.pathLocal + codigo + "/" + codigo + " " + this.iface.urlRepositorio_ + codigo + "/" + codigo + "-" + version;
			comando = [this.iface.comandoCP_, this.iface.pathLocal + fichero, rutaRepositorio + "/" + fichero];
			resComando = this.iface.ejecutarComando(comando);
			if (resComando.ok == false) {
				MessageBox.warning(util.translate("scripts", "Error al subir el documento %1 al repositorio:\n%2").arg(fichero).arg(resComando.salida), MessageBox.Ok, MessageBox.NoButton);
				util.destroyProgressDialog();
				return false;
			}
			break;
		}
		default: {
			util.destroyProgressDialog();
			return false;
		}
	}
	util.setProgress(4);
	util.setLabelText(util.translate("scripts", "Actualizando versión actual..."));
	if (!util.sqlUpdate("gd_versionesdoc", "versionrep", version, "idversion = " + curDocumento.valueBuffer("idversionactual"))) {
		util.destroyProgressDialog();
		return false;
	}
	util.destroyProgressDialog();
	return true;
}

/** \D Copia un documento al directorio local del repositorio
@param	codDocumento: Nombre del documento en el repositorio
@param	pathDoc: Ruta al fichero que contiene el documento a copiar
@return	true si la copia se realiza correctamente, false en caso contrario
\end */
function oficial_copiarDocRepo(codDocumento:String, pathDoc:String, version:String):Boolean
{
	var util:FLUtil = new FLUtil;
	var comando:String;
	var resComando:Array;
	var dirExiste = true;

	if (!this.iface.pathLocal) {
		if (!this.iface.verificarConfiguracion()) {
			return true;
		}
	}

	var pathRepo:String;
	switch (this.iface.tipoRepositorio_) {
		case "Distribuido": {
			pathRepo = this.iface.pathLocal + codDocumento;
			break;
		}
		default: {
			if (!File.exists(this.iface.pathLocal + codDocumento)) {
				dirExiste = false;
				var directorio = new Dir(this.iface.pathLocal);
				directorio.mkdir(codDocumento);
			}
			pathRepo = this.iface.pathLocal + codDocumento + "/" + codDocumento;
		}
	}


	if (File.exists(pathRepo)) {
		var fileRepo = new File(pathRepo);
		var fileLocal = new File(pathDoc);
		if (!fileLocal) {
			return false;
		}
		
		if (fileRepo.lastModified > fileLocal.lastModified) {
			var res:Number = MessageBox.warning(util.translate("scripts", "La versión del repositorio es más reciente (%1) que la versión local (%2) de:\n%3\n¿Desea continuar y sobreescribir la versión del repositorio?").arg(fileRepo.lastModified).arg(fileLocal.lastModified).arg(pathDoc), MessageBox.Yes, MessageBox.No);
			if (res != MessageBox.Yes)
				return false;
		}
	}

	//comando = "cp " + pathDoc+ " " + pathRepo;
	comando = [this.iface.comandoCP_, pathDoc, pathRepo];
	resComando = this.iface.ejecutarComando(comando);
	if (resComando.ok == false) {
		MessageBox.warning(util.translate("scripts", "Error al copiar el fichero.\n%1\n%2").arg(comando).arg(resComando.salida), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	return true;
}

function oficial_obtenerPathLocal():String
{
	return this.iface.pathLocal;
}

/** \D Baja un documento del repositorio y lo copia en el directorio especificado
@param: codDocumento: Nombre del documento en el repositorio
@param: pathDirectorio: Ruta al directorio de destino
@param: version: Versión a obtener. Si no está definida se obtiene la última
@param: revisión: Revisión a obtener. Si no está definida se obtiene la última
@param: rutaRepositorio: Ruta del documento en el repositorio (tipo de repositorio distribuido)
@return	true si el documento se obtiene correctamente, false en caso contrario
\end */
function oficial_obtenerDocumento(codDocumento:String, pathDirectorio:String, version:String, revision:String, rutaRepositorio:String):Boolean
{
	var util:FLUtil = new FLUtil;
	var comando:String;
	var resComando:Array;

	var estado:String = this.iface.svnUp(codDocumento, version, revision, rutaRepositorio);
	switch (estado) {
		case "X":
		case "XX": {
			MessageBox.warning(util.translate("scripts", "Error al obtener el fichero:\nEl documento no está incluido en el repositorio."), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
		case "U": {
			break;
		}
		default: {
			MessageBox.warning(util.translate("scripts", "Error al obtener el fichero."), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}
	
	if (File.exists(pathDirectorio)) {
		var fileRepo = new File(this.iface.pathLocal + codDocumento + "/" + codDocumento);
		if (!fileRepo)
			return false;
		var fileLocal = new File(pathDirectorio);
		if (fileRepo.lastModified < fileLocal.lastModified) {
			var res:Number = MessageBox.warning(util.translate("scripts", "El fichero local %1\n ha sido modificado más recientemente (%2) que el fichero del repositorio (%3).\n¿Desea continuar y sobreescribir el fichero local?").arg(pathDirectorio).arg(fileLocal.lastModified).arg(fileRepo.lastModified), MessageBox.Yes, MessageBox.No);
			if (res != MessageBox.Yes)
				return false;
		}
	}

	//comando = "cp " + this.iface.pathLocal + codDocumento + "/" + codDocumento + " " + pathDirectorio;
	switch (this.iface.tipoRepositorio_) {
		case "Distribuido": {
			comando = [this.iface.comandoCP_, this.iface.pathLocal + codDocumento, pathDirectorio];
			break;
		}
		default: {
			comando = [this.iface.comandoCP_, this.iface.pathLocal + codDocumento + "/" + codDocumento, pathDirectorio];
			break;
		}
	}
	resComando = this.iface.ejecutarComando(comando);
	if (resComando.ok == false) {
		MessageBox.warning(util.translate("scripts", "Error al copiar el fichero.\n%1\n%2").arg(comando).arg(resComando.salida), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	if (revision && this.iface.tipoRepositorio_ == "Repositorio Subversion") {
		if (!this.iface.svnUp(codDocumento)) {
			MessageBox.warning(util.translate("scripts", "Error al obtener la última versión del documento"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}
	return true;
}

/** \D Obtiene un nuevo código único de documento
@param	tipo: Tipo del documento
@return	Código del documento o false si hay error
\end */
function oficial_obtenerCodigoDoc(tipo:String):String
{
	var numero:Number = this.iface.siguienteNumero(tipo);
	if (!numero)
		return false;
	var codigo:String = flfacturac.iface.pub_cerosIzquierda(numero, 10);
	return codigo;
}

/** \D Asocia un documento a otro de tipo contenedor
@param	idDocumento: Identificador del documento 
@param	tipoObjeto: Tipo del documento contenedor
@param	idContenedor: Identificador del documento contenedor
@return	True si la asociación se realiza correctamente, false en caso contrario.
\end */
function oficial_asociarDocumento(idDocumento:String, tipoObjeto:String, idContenedor:String):Boolean
{
debug("1idContenedor " + idContenedor);
	var util:FLUtil = new FLUtil;

	if (tipoObjeto == "gd_documentos") {
		if (util.sqlSelect("gd_documentos d INNER JOIN gd_tiposdoc td ON d.codtipo = td.codtipo", "td.contenedor", "d.iddocumento = " + idDocumento, "gd_documentos,gd_tiposdoc")) {
			if (!this.iface.comprobarDependenciasGD(idDocumento, tipoObjeto, idContenedor)) {
				MessageBox.warning(util.translate("scripts", "No puede asociar el documento al contenedor ya que el documento contiene a su vez al contenedor"), MessageBox.Ok, MessageBox.NoButton);
				return false;
			}
		}
	}

/// El idContenedor debe llegar ya sin la parte de tipoObjeto + "-" + ...
// 	if (isNaN(idContenedor)) {
// 		var iSep:Number = idContenedor.toString().find("-");
// 		if (iSep >= 0) {
// 			idContenedor = idContenedor.right(idContenedor.length - iSep - 1);
// 		}
// 	}
	
	var curObjetoDoc:FLSqlCursor = new FLSqlCursor("gd_objetosdoc");
	curObjetoDoc.select("iddocumento = " + idDocumento + " AND tipoobjeto = '" + tipoObjeto + "' AND clave = '" + idContenedor + "'");
	if (!curObjetoDoc.first()) {
		with (curObjetoDoc) {
			setModeAccess(curObjetoDoc.Insert);
			refreshBuffer();
debug("idDocumento " + idDocumento);
debug("tipoObjeto " + tipoObjeto);
debug("idContenedor " + idContenedor);
			setValueBuffer("iddocumento", idDocumento);
			setValueBuffer("tipoobjeto", tipoObjeto);
			setValueBuffer("clave", idContenedor);
			if (!commitBuffer())
				return false;
		}
	}

	
	return true;
}

/** \D Inicia los elementos de gestión documental de un formulario
@param	container: Formulario contenedor. Debe contener un groupBox con los controles a los que se hace referencia en la función
@param	datosGD: Array con los siguientes datos<ul>
<li>txtRaíz: Texto del elemento raíz<li/>
<li>tipoRaíz: Tipo de objeto del elemento raíz<li/>
<li>idRaíz: Identificador del elemento raíz<li/>
</ul>
@return	True se la iniciación se hace correctamente, false en caso contrario
\end */
function oficial_gestionDocumentalOn(container:Object, datosGD:Array):Boolean
{
	var util:FLUtil = new FLUtil;
	
	if (!this.iface.verificarConfiguracion()) {
		MessageBox.warning(util.translate("scripts", "No tiene definidos los parámetros de configuración de gestión documental.\nLa gestión de documentos puede fallar por esta causa.\nDebe definir estos parámetros en el formulario de configuración del módulo \"Gestión documental\"."), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	if (!container)
		return false;
	
	if (this.iface.container_) {
		this.iface.gestionDocumentalOff();
	}

	if (this.iface.cursor_) {
		delete this.iface.cursor_;
	}
	this.iface.cursor_ = new FLSqlCursor("gd_documentos");


	var lvwDocumentos:Object = container.child("lvwGDDocumentos");
	lvwDocumentos.setColumnText(0, util.translate("scripts", "Documento"));
	lvwDocumentos.addColumn(util.translate("scripts", "Ver."));
	lvwDocumentos.addColumn(util.translate("scripts", "Estado"));
	lvwDocumentos.addColumn(util.translate("scripts", "Creación"));
	lvwDocumentos.addColumn(util.translate("scripts", "Última modificación"));
	lvwDocumentos.addColumn(util.translate("scripts", "Código"));
	lvwDocumentos.addColumn(util.translate("scripts", "Tipo"));
	
	lvwDocumentos.clear();
	var raiz = new FLListViewItem(lvwDocumentos);
	raiz.setText(0, datosGD.txtRaiz);
	raiz.setKey(datosGD.tipoRaiz + "-" + datosGD.idRaiz);
	raiz.setExpandable(true);

	this.iface.container_ = container;
	this.iface.tipoObjetoRaiz_ = datosGD.tipoRaiz;

	connect (lvwDocumentos, "doubleClicked(FLListViewItemInterface)", this, "iface.editarDocumentoGD()");
	connect (lvwDocumentos, "expanded(FLListViewItemInterface)", this, "iface.abrirDocumentoGD()");
	connect (lvwDocumentos, "selectionChanged(FLListViewItemInterface)", this, "iface.cambiarSeleccionGD()");
	connect (container.child("tbnAsociarDocGD"), "clicked()", this, "iface.asociarDoc_clickedGD()");
	connect (this.iface.container_.child("tbnQuitarDocGD"), "clicked()", this, "iface.quitarDoc_clickedGD()");
	connect (this.iface.container_.child("toolButtonInsertGD"), "clicked()", this, "iface.crearDocumentoGD");
	connect (this.iface.container_.child("toolButtonEditGD"), "clicked()", this, "iface.editarDocumentoGD");
	connect (this.iface.container_.child("toolButtonDeleteGD"), "clicked()", this, "iface.borrarDocumentoGD");
	connect (this.iface.container_.child("toolButtonZoomGD"), "clicked()", this, "iface.verDocumentoGD");
// 	connect (this.iface.cursor_, "bufferCommited()", this, "iface.abrirDocumentoGD()");
	//connect (this.iface.container_, "closed()", this, "iface.gestionDocumentalOff()");
	
	this.iface.tipoActual_ = this.iface.tipoObjetoRaiz_;
	this.iface.itemActual_ = raiz;
	this.iface.abrirDocumentoGD(raiz);
}

function oficial_gestionDocumentalOff()
{
	if (!this.iface.container_)
		return;

	var lvwDocumentos:Object = this.iface.container_.child("lvwGDDocumentos");
	if (!lvwDocumentos)
		return;
	disconnect(lvwDocumentos, "doubleClicked(FLListViewItemInterface)", this, "iface.editarDocumentoGD()");
	disconnect(lvwDocumentos, "expanded(FLListViewItemInterface)", this, "iface.abrirDocumentoGD()");
	disconnect(lvwDocumentos, "selectionChanged(FLListViewItemInterface)", this, "iface.cambiarSeleccionGD()");
	disconnect(this.iface.container_.child("tbnAsociarDocGD"), "clicked()", this, "iface.asociarDoc_clickedGD()");
	disconnect(this.iface.container_.child("tbnQuitarDocGD"), "clicked()", this, "iface.quitarDoc_clickedGD()");
	disconnect (this.iface.container_.child("toolButtonInsertGD"), "clicked()", this, "iface.crearDocumentoGD");
	disconnect (this.iface.container_.child("toolButtonEditGD"), "clicked()", this, "iface.editarDocumentoGD");
	disconnect (this.iface.container_.child("toolButtonDeleteGD"), "clicked()", this, "iface.borrarDocumentoGD");
	disconnect (this.iface.container_.child("toolButtonZoomGD"), "clicked()", this, "iface.verDocumentoGD");
// 	disconnect (this.iface.cursor_, "bufferCommited()", this, "iface.abrirDocumentoGD()");
}


/** \D Lanza el formulario de inserción de documentos, comprobando que se ha seleccionado un documento que es contenedor o el elemento raíz
\end */
function oficial_crearDocumentoGD()
{
	var util:FLUtil = new FLUtil;
	var clave:String = this.iface.itemActual_.key();
	if (this.iface.tipoActual_ == "gd_documentos") {
		if (!util.sqlSelect("gd_documentos d INNER JOIN gd_tiposdoc td ON d.codtipo = td.codtipo", "td.contenedor", "d.iddocumento = " + clave, "gd_documentos,gd_tiposdoc")) {
			MessageBox.warning(util.translate("scripts", "El documento seleccionado no es de tipo contenedor"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}
	if (!this.iface.itemActual_.isExpandable()) {
		return true;
	}
// 	if (!this.iface.cursor_.isValid()) {
// 		this.iface.cursor_.select("1 = 1");
// 		this.iface.cursor_.first();
// 	}
	disconnect(this.iface.cursor_, "bufferCommited()", this, "iface.vincularDocumentoGD");
	delete this.iface.cursor_;
	this.iface.cursor_ = new FLSqlCursor("gd_documentos");
	connect (this.iface.cursor_, "bufferCommited()", this, "iface.vincularDocumentoGD");

	this.iface.cursor_.insertRecord();
}

function oficial_vincularDocumentoGD():Boolean
{
	var util:FLUtil = new FLUtil;
	
	try {
		var idContenedor:String = this.iface.itemActual_.key();
		var tipoObjeto:String = this.iface.tipoActual_;
		
		var iSep:Number = idContenedor.find("-");
		if (iSep >= 0) {
			idContenedor = idContenedor.right(idContenedor.length - iSep - 1);
		}
	
		if (!idContenedor || !tipoObjeto) {
			throw (util.translate("scripts", "No puede asociarse el documento a ningún documento contenedor"));
		}
		if (!this.iface.asociarDocumento(this.iface.cursor_.valueBuffer("iddocumento"), tipoObjeto, idContenedor)) {
			throw (util.translate("scripts", "Error al vincular el documeto al item seleccionado"));
		}
	} catch (e) {
		MessageBox.warning(e, MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	this.iface.abrirDocumentoGD();
}

/** \D Borra el documento y todas sus versiones, así como su vinculación al contenedor y su espacio en el repositorio
\end */
function oficial_borrarDocumentoGD()
{
	var util:FLUtil = new FLUtil;
	if (!this.iface.itemActual_) {
		MessageBox.warning(util.translate("scripts", "No ha seleccionado ningún elemento"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var padre:Object = this.iface.itemActual_.parent();
	if (!padre) {
		return false;
	}

	if (this.iface.tipoActual_ != "gd_documentos") {
		return true;
	}

	var res:Number = MessageBox.information(util.translate("scripts", "El documento seleccionado será eliminado del repositorio.\n¿Está seguro?"), MessageBox.Yes, MessageBox.No);
	if (res != MessageBox.Yes)
		return false;

	var idDocumento:String = this.iface.itemActual_.key();
	
	if (!this.iface.borrarDocumento(idDocumento)) {
		return false;
	}
	this.iface.abrirDocumentoGD(padre);
}

function oficial_borrarDocumento(idDocumento:String):Boolean
{
	var util:FLUtil = new FLUtil;

	var relaciones:Number = util.sqlSelect("gd_objetosdoc", "COUNT(idrelacion)", "iddocumento = " + idDocumento);
	if (relaciones && relaciones > 1) {
		var nombreDoc:String = util.sqlSelect("gd_documentos", "nombre", "iddocumento = " + idDocumento);
		res = MessageBox.information(util.translate("scripts", "El documento \"%1\" tiene más de un vínculo.\n¿Desea continuar?").arg(nombreDoc), MessageBox.Yes, MessageBox.No);
		if (res != MessageBox.Yes)
			return false;
	}
	
	var curDocumento:FLSqlCursor = new FLSqlCursor("gd_documentos");
	var codigo:String;
	curDocumento.transaction(false);
	try {
		with (curDocumento) {
			select("iddocumento = " + idDocumento);
			if (!first())
				throw util.translate("scripts", "No existe el documento");
			setModeAccess(Del);
			refreshBuffer();
			codigo = curDocumento.valueBuffer("codigo");
			if (!commitBuffer())
				throw util.translate("scripts", "Falló la eliminación del documento");
		}
		if (!this.iface.borrarDocRepo(codigo))
			MessageBox.warning(util.translate("scripts", "Hubo un error al borrar el documento en el repositorio.\nDebe eliminarlo manualmente."), MessageBox.Ok, MessageBox.NoButton);
		
		curDocumento.commit();
	}
	catch (e) {
		curDocumento.rollback();
		if (!e || e == "")
			e = util.translate("scripts", "Falló la eliminación del documento");
		MessageBox.critical(util.translate("scripts", "Hubo un error al borrar el documento:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	return true;
}

function oficial_borrarContenidoContenedor(idDocContenedor:String):Boolean
{
	var qryContenido:FLSqlQuery = new FLSqlQuery;
	with (qryContenido) {
		setTablesList("gd_objetosdoc");
		setSelect("iddocumento");
		setFrom("gd_objetosdoc");
		setWhere("tipoobjeto = 'gd_documentos' AND clave = '" + idDocContenedor + "'");
		setForwardOnly(true);
	}
	if (!qryContenido.exec()) {
		return false;
	}
	while (qryContenido.next()) {
		if (!this.iface.borrarDocumento(qryContenido.value("iddocumento"))) {
			return false;
		}
	}
	return true;
}


/** \C Muestra el contenido de un objeto de tipo contenedor
@param	item: Elemento de la lista correspondiente al documento seleccionado
\end */
function oficial_abrirDocumentoGD(item:FLListViewItem):Boolean
{
	if (!item) {
		item = this.iface.itemActual_; 
		if (item && !item.isExpandable()) {
			item = item.parent();
			if (item) {
				this.iface.cambiarSeleccionGD(item);
			}
		}
	}
	if (!item) {
		return false;
	}

	if (!item.isExpandable()) {
		return true;
	}

	var tipoObjeto:String;
	var clave:String = item.key();
	var iSep:Number = clave.find("-");
	if (iSep >= 0) {
		tipoObjeto = clave.left(iSep);
		clave = clave.right(clave.length - iSep - 1);
	} else {
		tipoObjeto = this.iface.tipoActual_;
	}
	
	var hermano;
	for (var hijo = item.firstChild(); hijo; hijo = hermano) {
		hermano = hijo.nextSibling();
		hijo.del();
	}

	var util:FLUtil = new FLUtil;
	var qryDocs:FLSqlQuery = new FLSqlQuery;
	qryDocs.setTablesList("gd_objetosdoc,gd_documentos,gd_tiposdoc");
	qryDocs.setSelect("d.iddocumento, d.codigo, d.estado, d.nombre, d.creadopor, d.fechacreacion, d.horacreacion, td.descripcion, td.contenedor, td.icono, vd.version, vd.modificadopor, vd.fechamodif, vd.horamodif");
	qryDocs.setFrom("gd_objetosdoc od INNER JOIN gd_documentos d ON od.iddocumento = d.iddocumento LEFT OUTER JOIN gd_tiposdoc td ON d.codtipo = td.codtipo LEFT OUTER JOIN gd_versionesdoc vd ON d.idversionactual = vd.idversion");
	qryDocs.setWhere("od.tipoobjeto = '" + tipoObjeto + "' AND od.clave = '" + clave + "'");
	qryDocs.setForwardOnly(true);
	if (!qryDocs.exec()) {
		return false;
	}

	var itemHijo;
	var icono:String;
	while (qryDocs.next()) {
		itemHijo = new FLListViewItem(item);
		itemHijo.setKey(qryDocs.value("d.iddocumento"));
		itemHijo.setText(0, qryDocs.value("d.nombre"));
		itemHijo.setText(1, qryDocs.value("vd.version"));
		itemHijo.setText(2, qryDocs.value("d.estado"));
		itemHijo.setText(3, this.iface.datosUsrFecha(qryDocs.value("d.creadopor"), qryDocs.value("d.fechacreacion"), qryDocs.value("d.horacreacion")));
		itemHijo.setText(4, this.iface.datosUsrFecha(qryDocs.value("vd.modificadopor"), qryDocs.value("vd.fechamodif"), qryDocs.value("vd.horamodif")));
		itemHijo.setText(5, qryDocs.value("d.codigo"));
		itemHijo.setText(6, qryDocs.value("td.descripcion"));
		
		icono = qryDocs.value("td.icono");
		if (icono && icono != "")
			itemHijo.setPixmap(0, icono);
		
		if (qryDocs.value("td.contenedor"))
			itemHijo.setExpandable(true);
	}
	if (!this.iface.mostrarDocsRelacionados(item, tipoObjeto, clave)) {
		return false;
	}
	item.setOpen(true);
}

/** \D Establece como documento actual el correspondiente al elemento de la lista seleccionado
@param	item: Elemento de la lista seleccionado
\end */
function oficial_cambiarSeleccionGD(item:FLListViewItem)
{
	this.iface.itemActual_ = item;
	if (this.iface.itemActual_.parent()) {
		var keyItem:String = this.iface.itemActual_.key();
		var iSep:Number = keyItem.find("-");
		if (iSep >= 0) {
			this.iface.tipoActual_ = keyItem.left(iSep);
		} else {
			this.iface.tipoActual_ = "gd_documentos";
		}
	} else {
		this.iface.tipoActual_ = this.iface.tipoObjetoRaiz_;
	}
}

/** \D Selecciona el documento actual y lanza el formulario de edición
@param	item: Elemento de la lista seleccionado
\end */
function oficial_editarDocumentoGD(item:FLListViewItem)
{
	if (!item) {
		item = this.iface.itemActual_;
		if (!item) {
			return;
		}
	} else {
		this.iface.cambiarSeleccionGD(item);
	}
	if (this.iface.tipoActual_ != "gd_documentos") {
		return false;
	}

	disconnect(this.iface.cursor_, "bufferCommited()", this, "iface.abrirDocumentoGD");
	delete this.iface.cursor_;
	this.iface.cursor_ = new FLSqlCursor("gd_documentos");
	connect (this.iface.cursor_, "bufferCommited()", this, "iface.abrirDocumentoGD");

	this.iface.cursor_.select("iddocumento = " + item.key());
	if (!this.iface.cursor_.first()) {
		return false;
	}
	if (!this.iface.cursor_.valueBuffer("iddocumento")) {
		return false;
	}
	this.iface.cursor_.editRecord();
}

/** \D Selecciona el documento actual y lanza el formulario de edición
@param	item: Elemento de la lista seleccionado
\end */
function oficial_verDocumentoGD()
{
	var util:FLUtil = new FLUtil;
	if (!this.iface.itemActual_) {
		MessageBox.warning(util.translate("scripts", "No ha seleccionado ningún elemento"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	if (this.iface.tipoActual_ == this.iface.tipoObjetoRaiz_) {
		return false;
	}

	disconnect(this.iface.cursor_, "bufferCommited()", this, "iface.abrirDocumentoGD");
	delete this.iface.cursor_;
	this.iface.cursor_ = new FLSqlCursor("gd_documentos");
	connect (this.iface.cursor_, "bufferCommited()", this, "iface.abrirDocumentoGD");

	this.iface.cursor_.select("iddocumento = " + this.iface.itemActual_.key());
	if (!this.iface.cursor_.first()) {
		return false;
	}
	if (!this.iface.cursor_.valueBuffer("iddocumento")) {
		return false;
	}
	this.iface.cursor_.browseRecord();
}

/** \C Permite al usuario seleccionar un documento del repositorio para asignarlo al documento contenedor seleccionado
@param	item: Elemento de la lista seleccionado
\end */
function oficial_asociarDoc_clickedGD()
{
	if (!this.iface.itemActual_)
		return false;
	
	var util:FLUtil = new FLUtil;
	var clave:String = this.iface.itemActual_.key();
	if (isNaN(clave)) {
		var iSep:Number = clave.find("-");
		if (iSep >= 0) {
			clave = clave.right(clave.length - iSep - 1);
		}
	}

	if (this.iface.tipoActual_ == "gd_documentos") {
		if (!util.sqlSelect("gd_documentos d INNER JOIN gd_tiposdoc td ON d.codtipo = td.codtipo", "td.contenedor", "d.iddocumento = " + clave, "gd_documentos,gd_tiposdoc")) {
			MessageBox.warning(util.translate("scripts", "El documento seleccionado no es de tipo contenedor"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}

	var f:Object = new FLFormSearchDB("gd_buscardoc");
	var curDocumentos:FLSqlCursor = f.cursor();
	
	f.setMainWidget();
	var idDocumento:String = f.exec("iddocumento");

	if (idDocumento) {
		this.iface.asociarDocumento(idDocumento, this.iface.tipoActual_, clave);
		this.iface.abrirDocumentoGD(this.iface.itemActual_);
	}
}

/** \D Comprueba que un documento puede asociarse a un contenedor sin establecer un bucle, es decir, que el documento no contenga a su vez al contenedor
@param	idDocumento: Identificador del documento
@param	tipoObjeto: Tipo del objeto contenedor
@param	idContenedor: Identificador del contenedor
@return	true si la comprobación indica que no hay bucles, false en caso contrario
\end */
function oficial_comprobarDependenciasGD(idDocumento:String, tipoObjeto:String, idContenedor:String):Boolean
{
	if (tipoObjeto != "gd_documentos")
		return true;

	var qryContenedores:FLSqlQuery = new FLSqlQuery;
	qryContenedores.setTablesList("gd_objetosdoc");
	qryContenedores.setSelect("tipoobjeto, clave");
	qryContenedores.setFrom("gd_objetosdoc");
	qryContenedores.setWhere("iddocumento = " + idContenedor);
	qryContenedores.setForwardOnly(true);
	if (!qryContenedores.exec())
		return false;
	while (qryContenedores.next()) {
		// Se llega al elemento raíz sin obtener coincidencias
		if (qryContenedores.value("tipoobjeto") != "gd_documentos")
			return true;
		// Se llega a un contenedor que resulta ser el documento. Bucle encontrado
		if (qryContenedores.value("tipoobjeto") == "gd_documentos" && qryContenedores.value("clave") == idDocumento)
			return false;
		// Se comprueba si los documentos que contienen el contenedor actual coinciden con el documento
		if (!this.iface.comprobarDependenciasGD(idDocumento, qryContenedores.value("tipoobjeto"), qryContenedores.value("clave")))
			return false;
	}
	return true;
}

/** \C Elimina la asociación entre un documento y su contenedor
\end */
function oficial_quitarDoc_clickedGD()
{
	var util:FLUtil = new FLUtil;
	if (!this.iface.itemActual_) {
		MessageBox.warning(util.translate("scripts", "No ha seleccionado ningún elemento"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	if (this.iface.tipoActual_ != "gd_documentos")
		return true;

	var padre:Object = this.iface.itemActual_.parent();
	if (!padre)
		return false;

	var tipoObjeto:String;
	var idContenedor:String = padre.key();
	var iSep:Number = idContenedor.find("-");
	if (iSep >= 0) {
		tipoObjeto = idContenedor.left(iSep);
		idContenedor = idContenedor.right(idContenedor.length - iSep - 1);
	} else {
		tipoObjeto = "gd_documentos";
	}
	var idDocumento:String = this.iface.itemActual_.key();

	if (!util.sqlSelect("gd_objetosdoc", "idrelacion", "iddocumento = " + idDocumento + " AND (tipoobjeto <> '" + tipoObjeto + "' OR clave <> '" + idContenedor + "')")) {
		MessageBox.warning(util.translate("scripts", "Los documentos deben estar asociados al menos a un contenedor.\nEl documento seleccionado sólo está asociado al contenedor que se muestra."), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var res:Number = MessageBox.information(util.translate("scripts", "Va a eliminar el vínculo del documento seleccionado con el contenedor que se muestra.\n¿Desea continuar?"), MessageBox.Yes, MessageBox.No);
	if (res != MessageBox.Yes)
		return true;

	if (!util.sqlDelete("gd_objetosdoc", "iddocumento = " + idDocumento + " AND tipoobjeto = '" + tipoObjeto + "' AND clave = '" + idContenedor + "'")) {
		MessageBox.warning(util.translate("scripts", "Falló la acción de desasignar el documento"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	this.iface.abrirDocumentoGD(padre);

	return true;
}

/** \D Comprueba que los parámetros de configuración de la gestión documental están correctamente establecidos
\return	True si la comprobación es satisfactoria, false en caso contrario
\end */
function oficial_verificarConfiguracion():Boolean
{
	var util:FLUtil = new FLUtil;
	this.iface.tipoRepositorio_ = util.sqlSelect("gd_config", "tiporepositorio", "1 = 1");
	if (!this.iface.tipoRepositorio_) {
		MessageBox.warning(util.translate("scripts", "No tiene establecido el tipo de repositorio.\nPara usar este módulo es necesario establecer este dato en el formulario de configuración"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	this.iface.urlRepositorio_ = util.sqlSelect("gd_config", "urlrepositorio", "1 = 1");
	if (!this.iface.urlRepositorio_) {
		MessageBox.warning(util.translate("scripts", "No tiene establecida la URL del repositorio.\nPara usar este módulo es necesario establecer este dato en el formulario de configuración"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	if (!this.iface.urlRepositorio_.endsWith("/"))
		this.iface.urlRepositorio_ += "/";

	if (!this.iface.pathLocal) {
		if (!this.iface.verificarDirLocal(this.iface.urlRepositorio_)) {
			return false;
		}
		var nombreBD:String = sys.nameBD();
		this.iface.pathLocal = Dir.home + "/tmp/bqdoc_" + nombreBD + "/";
	}

	this.iface.comandoCP_ = util.readSettingEntry("scripts/flcolagedo/comandocp");
debug("leyendo cp " + this.iface.comandoCP_);
	if (!this.iface.comandoCP_) {
		this.iface.comandoCP_ = "cp";
	}
	return true;
}

function oficial_valoresIniciales()
{
	var cursor:FLSqlCursor = new FLSqlCursor("gd_tiposdoc");
	var tiposDoc:Array =
		[["Carpeta", "Carpeta de documentos", true, "/* XPM */\nstatic char * folder_yellow_xpm[] = {\n\"16 16 54 1\",\n\" 	c None\",\n\".	c #F5A400\",\n\"+	c #F4A300\",\n\"@	c #FFFBB3\",\n\"#	c #FFFAA5\",\n\"$	c #F4A100\",\n\"%	c #FFF866\",\n\"&	c #F7B100\",\n\"*	c #F39F00\",\n\"=	c #FFF436\",\n\"-	c #FFF42F\",\n\";	c #F39C00\",\n\">	c #FFF116\",\n\",	c #F29600\",\n\"'	c #F29900\",\n\")	c #FFEC06\",\n\"!	c #FFED07\",\n\"~	c #FEDF00\",\n\"{	c #FFFDD8\",\n\"]	c #FFE500\",\n\"^	c #F29700\",\n\"/	c #FFE701\",\n\"(	c #FDD600\",\n\"_	c #FED900\",\n\":	c #F19500\",\n\"<	c #FFE300\",\n\"[	c #F19100\",\n\"}	c #FCCC00\",\n\"|	c #F19200\",\n\"1	c #FEDD00\",\n\"2	c #EF8C00\",\n\"3	c #FABF00\",\n\"4	c #F9BE00\",\n\"5	c #F19000\",\n\"6	c #EE8500\",\n\"7	c #F7B200\",\n\"8	c #EE8400\",\n\"9	c #F08F00\",\n\"0	c #FDD400\",\n\"a	c #EC7D00\",\n\"b	c #F5A800\",\n\"c	c #F5A700\",\n\"d	c #FCCF00\",\n\"e	c #EA7400\",\n\"f	c #FFFEEB\",\n\"g	c #EA7500\",\n\"h	c #EF8A00\",\n\"i	c #E76C00\",\n\"j	c #EF8800\",\n\"k	c #FBC600\",\n\"l	c #E56400\",\n\"m	c #EE8600\",\n\"n	c #E25B00\",\n\"o	c #E25A00\",\n\"  ......        \",\n\" +@#@###+       \",\n\"$%%%%%%%&$$$$$$ \",\n\"*=====-===-====*\",\n\";>>>>>>>>,,,,,,,\",\n\"'))!)!)),~{{{{],\",\n\"^//,,,,,({_____,\",\n\":<[}{{{{{}}}}}}[\",\n\"|123334333333342\",\n\"5_677777777\n7778\",\n\"90abbbbbbbcbcbba\",\n\"2defffffffffff(g\",\n\"hdifffffffffff(i\",\n\"jkl((((((((((((l\",\n\" mnnonnnnnnnnnn \",\n\"                \"};"],
		["Documento", "Documento genérico", false, "/* XPM */\nstatic char * document2_xpm[] = {\n\"16 16 86 1\",\n\" 	c None\",\n\".	c #8F8F8F\",\n\"+	c #FFFFFF\",\n\"@	c #C2D7FC\",\n\"#	c #B4CDF9\",\n\"$	c #A1C1F6\",\n\"%	c #71A0EB\",\n\"&	c #6699E8\",\n\"*	c #5C93E4\",\n\"=	c #518BE0\",\n\"-	c #4683DC\",\n\";	c #3C7CD8\",\n\">	c #2F73D2\",\n\",	c #246CCE\",\n\"'	c #1764CA\",\n\")	c #CDD2DA\",\n\"!	c #D1D6DF\",\n\"~	c #C7CDD6\",\n\"{	c #D4DBE6\",\n\"]	c #C4CBD7\",\n\"^	c #C4CDD9\",\n\"/	c #C3CCD8\",\n\"(	c #C0C9D6\",\n\"_	c #C1CAD8\",\n\":	c #D3DCEB\",\n\"<	c #D8E3F1\",\n\"[	c #D4DFEE\",\n\"}	c #E5E5E3\",\n\"|	c #E4E3E2\",\n\"1	c #DCDBDA\",\n\"2	c #E5E4E2\",\n\"3	c #E0DFDC\",\n\"4	c #DFDEDB\",\n\"5	c #DFDEDC\",\n\"6	c #F0EEEC\",\n\"7	c #F7F5F2\",\n\"8	c #FAF8F5\",\n\"9	c #FAF8F6\",\n\"0	c #F9F7F4\",\n\"a	c #EAEAEA\",\n\"b	c #E9E9E9\",\n\"c	c #E8E8E8\",\n\"d	c #E4E4E4\",\n\"e	c #E5E5E5\",\n\"f	c #DFDFDF\",\n\"g	c #E0E0E0\",\n\"h	c #DEDEDE\",\n\"i	c #D3D3D3\",\n\"j	c #DBDBDB\",\n\"k	c #D7D7D7\",\n\"l	c #D2D2D2\",\n\"m	c #D5D5D5\",\n\"n	c #D0D0D0\",\n\"o	c #D6D6D6\",\n\"p	c #CCCCCC\",\n\"q	c #CFCFCF\",\n\"r	c #CDCDCD\",\n\"s	c #DDDDDD\",\n\"t	c #DCDCDC\",\n\n\"u	c #D4D4D4\",\n\"v	c #D9D9D9\",\n\"w	c #D1D1D1\",\n\"x	c #CBCBCB\",\n\"y	c #E7E7E7\",\n\"z	c #E1E1E1\",\n\"A	c #DADADA\",\n\"B	c #E6E6E6\",\n\"C	c #ECECEC\",\n\"D	c #E2E2E2\",\n\"E	c #F7F7F7\",\n\"F	c #F4F4F4\",\n\"G	c #F2F2F2\",\n\"H	c #F1F1F1\",\n\"I	c #F0F0F0\",\n\"J	c #EFEFEF\",\n\"K	c #EEEEEE\",\n\"L	c #D8D8D8\",\n\"M	c #C8C8C8\",\n\"N	c #CACACA\",\n\"O	c #F5F5F5\",\n\"P	c #F9F9F9\",\n\"Q	c #FAFAFA\",\n\"R	c #F3F3F3\",\n\"S	c #A8A8A8\",\n\"T	c #C5C5C5\",\n\"U	c #CECECE\",\n\"................\",\n\".+@#$%&*=-;>,'+.\",\n\".+)!~{]^/(_:<[+.\",\n\".+}|1234567890+.\",\n\".+abbacdecffgh+.\",\n\".+ijkklmnoplqr+.\",\n\".+os\ntjuvwnlrxx+.\",\n\".+baabyezzetAf+.\",\n\".+BCDcEFGHIJKJ+.\",\n\".+lurLLlLiMiNM+.\",\n\".+gshDshvumLlw+.\",\n\".+zdgftOPQRSSSS.\",\n\".+LjzjkzdBjS++. \",\n\".+riiwTpwUpS+.  \",\n\".+thoeGRRRHS.   \",\n\"............    \"};"]];
	for (var i:Number = 0; i < tiposDoc.length; i++) {
		with(cursor) {
			setModeAccess(cursor.Insert);
			refreshBuffer();
			setValueBuffer("codtipo", tiposDoc[i][0]);
			setValueBuffer("descripcion", tiposDoc[i][1]);
			setValueBuffer("contenedor", tiposDoc[i][2]);
			setValueBuffer("icono", tiposDoc[i][3]);
			commitBuffer();
		}
	}
	delete cursor;
}

/** \D Construye una cadena con los datos de usuario, fecha y hora
@param	idUsuario: Identificador (login) del usuario
@param	fecha: Fecha en formato ISO
@param	hora: Hora en formato ISO
@return Cadena
\end */
function oficial_datosUsrFecha(idUsuario:String, fecha:String, hora:String):String
{
	var util:FLUtil = new FLUtil;
	var datosUsrFecha:String = "";
	if (fecha) {
		fecha = util.dateAMDtoDMA(fecha);
		fecha = fecha.toString().left(10);
		datosUsrFecha += fecha
	} else 
		datosUsrFecha += "          ";
	if (hora && !hora.toString().endsWith("00:00:00")) {
		hora = hora.toString().right(8);
		datosUsrFecha += ", " + hora
	} else 
		datosUsrFecha += "        ";

	if (idUsuario)
		datosUsrFecha += " (" + idUsuario + ")"

	return datosUsrFecha;
}

/** \D Baja el documento actual del repositorio al directorio local de documentos
\end */
function oficial_bajarDocumentoGD():Boolean
{
	var util:FLUtil = new FLUtil;
	if (!this.iface.itemActual_) {
		MessageBox.warning(util.translate("scripts", "No ha seleccionado ningún elemento"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	if (this.iface.tipoActual_ == this.iface.tipoObjetoRaiz_)
		return false;

	var codDocumento:String = util.sqlSelect("gd_documentos", "codigo", "iddocumento = " + this.iface.itemActual_.key());
	if (!codDocumento)
		return false;
	
	var pathFichero:String = this.iface.pathLocal;
	if (!File.isDir(pathFichero)) {
		pathFichero = FileDialog.getExistingDirectory(Dir.home, util.translate("scripts", "Seleccione directorio"));
		if (!pathFichero)
			return false;
	}

	if (!this.iface.pub_obtenerDocumento(codDocumento, pathFichero + "/" + cursor.valueBuffer("fichero"), false, false, cursor.valueBuffer("rutarepositorio"))) {
		return false;
	}

	return true;
}

function oficial_datosItemActual():Array
{
	var valor:Array = [];
	valor["tipoObjeto"] = this.iface.tipoActual_;
	if (this.iface.itemActual_)
		valor["idObjeto"] = this.iface.itemActual_.key();
	else
		valor["idObjeto"] = false;
	return valor;
}

function oficial_abrirItemActual()
{
	this.iface.abrirDocumentoGD(this.iface.itemActual_);
}

function oficial_mostrarDocsRelacionados(item:FLListViewItem, tipoObjeto:String, clave:String):Boolean
{
	var util:FLUtil = new FLUtil;
	switch (tipoObjeto) {
		case "cl_proyectos": {
			var qrySP:FLSqlQuery = new FLSqlQuery;
			with (qrySP) {
				setTablesList("cl_subproyectos");
				setSelect("codsubproyecto, descripcion");
				setFrom("cl_subproyectos");
				setWhere("codproyecto = '" + clave + "'");
				setForwardOnly(true);
			}
			if (!qrySP.exec())
				return false;
		
			while (qrySP.next()) {
				itemHijo = new FLListViewItem(item);
				itemHijo.setKey("cl_subproyectos" + "-" + qrySP.value("codsubproyecto"));
				itemHijo.setText(0, this.iface.nombreObjetoContenedor("cl_subproyectos", qrySP.value("codsubproyecto")));
				itemHijo.setText(1, "");
				itemHijo.setText(2, "");
				itemHijo.setText(3, "");
				itemHijo.setText(4, "");
		
				icono = util.sqlSelect("cl_configproy", "iconosubproyecto", "1 = 1");
				if (icono && icono != "")
					itemHijo.setPixmap(0, icono);
				
				itemHijo.setExpandable(true);
			 }
			break;
		}
		case "clientes": {
			if (!sys.isLoadedModule("flcolaproy")) {
				break;
			}
			var qrySP:FLSqlQuery = new FLSqlQuery;
			with (qrySP) {
				setTablesList("cl_proyectos");
				setSelect("codproyecto");
				setFrom("cl_proyectos");
				setWhere("codcliente = '" + clave + "'");
				setForwardOnly(true);
			}
			if (!qrySP.exec())
				return false;
		
			while (qrySP.next()) {
				itemHijo = new FLListViewItem(item);
				itemHijo.setKey("cl_proyectos" + "-" + qrySP.value("codproyecto"));
				itemHijo.setText(0, this.iface.nombreObjetoContenedor("cl_proyectos", qrySP.value("codproyecto")));
				itemHijo.setText(1, "");
				itemHijo.setText(2, "");
				itemHijo.setText(3, "");
				itemHijo.setText(4, "");
		
				icono = util.sqlSelect("cl_configproy", "iconoproyecto", "1 = 1");
				if (icono && icono != "")
					itemHijo.setPixmap(0, icono);
				
				itemHijo.setExpandable(true);
			 }
			break;
		}
	}
	return true;
}

function oficial_nombreObjetoContenedor(tipoObjeto:String, clave:String):String
{
	var util:FLUtil = new FLUtil();
	var nombre:String;
	switch (tipoObjeto) {
		case "cl_proyectos": {
			var desSP:String = util.sqlSelect("cl_proyectos", "descripcion", "codproyecto = '" + clave + "'");
			nombre = util.translate("scripts", "Proy. %1 - %2").arg(clave).arg(desSP);
			break;
		}
		case "cl_subproyectos": {
			var desSP:String = util.sqlSelect("cl_subproyectos", "descripcion", "codsubproyecto = '" + clave + "'");
			nombre = util.translate("scripts", "Subp. %1 - %2").arg(clave).arg(desSP);
			break;
		}
	}

	return nombre;
}

function oficial_dameObjetoVinculado(eVinculos:FLDomElement, tipoObjeto:String):String
{
	var objetos:FLDomNodeList = eVinculos.elementsByTagName("Objeto");
	if (!objetos || objetos == undefined) {
		return false;
	}

	for (var i:Number = 0; i < objetos.length(); i++) {
		if (objetos.item(i).toElement().attribute("Tipo") == tipoObjeto) {
    		return objetos.item(i).toElement().attribute("IdObjeto");
  		}
	}

	return false;
}

/** \D Crea un registro de documento
\end */
function oficial_crearDocumento(codTipo:String, nombre:String, prefijo:String, masDatos:Array):String
{
	var numero:Number = this.iface.siguienteNumero(prefijo);
	if (!numero) {
		return false;
	}
	var codigo:String = codTipo + flfacturac.iface.pub_cerosIzquierda(numero, (10 - prefijo.length));
	var usuario:String = sys.nameUser();
	var ahora:Date = new Date;

	if (!this.iface.curDocumento_) {
		this.iface.curDocumento_ = new FLSqlCursor("gd_documentos");
	}
	this.iface.curDocumento_.setModeAccess(this.iface.curDocumento_.Insert);
	this.iface.curDocumento_.refreshBuffer();
	this.iface.curDocumento_.setValueBuffer("codtipo", codTipo);
	this.iface.curDocumento_.setValueBuffer("nombre", nombre);
	this.iface.curDocumento_.setValueBuffer("codigo", codigo);
	this.iface.curDocumento_.setValueBuffer("creadopor", usuario);
	this.iface.curDocumento_.setValueBuffer("fechacreacion", ahora);
	this.iface.curDocumento_.setValueBuffer("horacreacion", ahora);

	if (masDatos) {
		if (!this.iface.datosDocumento(masDatos)) {
			return false;
		}
	}

	if (!this.iface.curDocumento_.commitBuffer()) {
		return false;
	}
	return this.iface.curDocumento_.valueBuffer("iddocumento");
}

/** \D Función a sobrecargar
\end */
function oficial_datosDocumento(datos:Array):Boolean
{
	return true;
}

function oficial_valorCampoPlantilla(codTipo:String, campo:String, eDoc:FLDomElement):String
{
	return false;
}

/** Genera un proceso asociado al documento si el tipo del documento tiene un tipo de proceso asociado
@param	curDocumeto: Cursor asociado al documento
\end */
function oficial_generarProcesoDoc(curDocumento:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;

	var codTipo:String = curDocumento.valueBuffer("codtipo");
	var idTipoProceso:String = util.sqlSelect("gd_tiposdoc", "idtipoproceso", "codtipo = '" + codTipo + "'");
	var idProceso:String;

	if (idTipoProceso && idTipoProceso != "") {
		idProceso = flcolaproc.iface.pub_crearProceso(idTipoProceso, "gd_documentos", curDocumento.valueBuffer("iddocumento"));
		if (!idProceso || idProceso == "") {
			return false;
		}
	}
	return true;
}

function oficial_adaptarRuta(ruta:String):String
{
	var util:FLUtil = new FLUtil();

	var rutaAdaptada:String = "";
	var caracterAnterior:String = "0";
	for (var i:Number = 0; i < ruta.length; i++) {
		if (ruta.charAt(i) == "/" && caracterAnterior == "/") {
			continue;
		}
		rutaAdaptada += ruta.charAt(i);
		caracterAnterior = ruta.charAt(i)
	}
	var os:String = util.getOS();
	
	if (os == "WIN32") {
		var rutaWin:String = "";
		for (var i:Number = 0; i < rutaAdaptada.length; i++) {
			if (rutaAdaptada.charAt(i) == "/") {
				rutaWin += "\\";
			} else {
				rutaWin += rutaAdaptada.charAt(i);
			}
		}
		rutaAdaptada = rutaWin;
	}
	return rutaAdaptada;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
