/***************************************************************************
                 mv_masterfuncional.qs  -  description
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
/* \C 
Este formulario permite realizar las operaciones que componen el ciclo completo de desarrollo de una funcionalidad:
<ul>
	<li>Crear una nueva funcionalidad en el repositorio: Crearemos primero el registro de la funcionalidad y después, con el registro seleccionado, pulsaremos el botón 'Crear funcionalidad en el repositorio'. Esto genera un nuevo directorio 'nombre_funcionalidad/tronco/' en la rama del repositorio .../funcional/</li>
	<li>Obtener una copia local de la funcionalidad. Con la funcionalidad seleccionada pulsaremos el botón 'Obtener funcionalidad del repositorio'. Esto nos crea, en el directorio de trabajo, un directorio con el nombre de la funcionalidad, así como tres subdirectorios:
			<ul>
				<li>previo: Contiene los módulos afectados en su estado previo a la aplicación del parche.</li>
				<li>nuevo: Contiene los módulos afectados una vez aplicado el parche.</li>
				<li>nombre_funcionalidad: Contiene el fichero de parche nombre_funcionalidad.xml y los ficheros nuevos y de diferencias que componen el parche. </li>
				<li>test: Contiene los ficheros de las pruebas asociadas a cada una de las funcionalidades
			</ul>
	</li>
	<li>Desarrollar la funcionalidad: Para ello actuaremos siempre sobre el directorio Nuevo, modificando los ficheros que sea necesario hasta completar la funcionalidad. Una vez echo esto, o siempre que queramos guardar el trabajo realizado, debemos pulsar el botón 'Actualizar funcionalidad', de forma que el directorio Nombre_funcionalidad se regenera automáticamente a partir de las diferencias encontradas entre los directorios Previo y Nuevo.</li>
	<li>Subir la copia local de la funcionalidad seleccionadad al repositorio: Seleccionaremos la funcionalidad y pulsaremos el botón 'Subir funcionalidad al repositorio'. Con ello subiremos el contenido del directoio Nombre_funcionalidad/Nombre_funcionalidad al repositorio. Antes de realizar la operación podremos incluir el el fichero Changelog asociado a la funcionalidad una o más entradas que describan los cambios realizados</li>
</ul>

Comprobación del parche. Para cerciorarnos de que el parche funciona correctamente, podemos generar un directorio de pruebas mediante el botón 'Generar una funcionalidad de prueba'. Esto permite crear un directorio ¡prueba' que es copia de 'previo' y que tiene aplicadas las modificaciones del parche. Si todo va bien, la funcionalidad del directorio 'prueba' debe coincidir con la del directorio 'nuevo'.

En el desarrollo normal, a la hora de pasar un cambio de uno o más ficheros esde 'nuevo' hasta 'prueba', podemos usar el botón 'Recargar Pruebas'. Mediante este botón detectamos los ficheros modificados, actualizamos el parche y lo aplicamos de nuevo sobre el directorio 'prueba'.
*/
////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

/** @class_declaration interna */
//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
class interna {
    var ctx:Object;
    function interna( context ) { this.ctx = context; }
    function init() { this.ctx.interna_init(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    function oficial( context ) { interna( context ); } 
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends oficial {
	var tbnCrearFun:Object;
	var tbnBajarFun:Object;
	var tbnSubirFun:Object;
	var tbnActualizarFun:Object;
	var tbnProbarFun:Object;
	var tbnRecargarFun:Object;
	var util:FLUtil;
	var pathLocal:String;
	var urlRepositorioMod:String;
	var urlRepositorioFun:String;
	var urlRepositorioWebOficial:String;
	var urlRepositorioWebFun:String;
	var versionOficial:String;
	var xmlParche:FLDomDocument;
	var funcionalParche:String;
		
	function head( context ) { oficial ( context ); }
	function tbnCrearFun_clicked() {
		return this.ctx.head_tbnCrearFun_clicked();
	}
	function tbnBajarFun_clicked() {
		return this.ctx.head_tbnBajarFun_clicked();
	}
	function tbnSubirFun_clicked() {
		return this.ctx.head_tbnSubirFun_clicked();
	}
	function tbnActualizarFun_clicked() {
		return this.ctx.head_tbnActualizarFun_clicked();
	}
	function tbnProbarFun_clicked() {
		return this.ctx.head_tbnProbarFun_clicked();
	}
	function tbnRecargarFun_clicked() {
		return this.ctx.head_tbnRecargarFun_clicked();
	}
	function crearFun(codFuncional:String) {
		return this.ctx.head_crearFun(codFuncional);
	}
	function bajarFun(codFuncional:String) {
		return this.ctx.head_bajarFun(codFuncional);
	}
	function subirFun(codFuncional:String) {
		return this.ctx.head_subirFun(codFuncional);
	}
	function actualizarFun(codFuncional:String) {
		return this.ctx.head_actualizarFun(codFuncional);
	}
	function probarFun(codFuncional:String) {
		return this.ctx.head_probarFun(codFuncional);
	}
	function recargarFun(codFuncional:String) {
		return this.ctx.head_recargarFun(codFuncional);
	}
	function generarDirPrevio(codFuncional:String):Boolean {
		return this.ctx.head_generarDirPrevio(codFuncional);
	}
	function generarDirPrueba(codFuncional:String, directorio:String):Boolean {
		return this.ctx.head_generarDirPrueba(codFuncional, directorio);
	}
	function crearParche(ruta:String):Boolean {
		return this.ctx.head_crearParche(ruta);
	}
	function funcionalidadExiste(codFuncional:String):Boolean {
		return this.ctx.head_funcionalidadExiste(codFuncional);
	}
	function grabarFicheroParche(ruta:String, nombre:String, contenido:String):Boolean {
		return this.ctx.head_grabarFicheroParche(ruta, nombre, contenido);
	}
	function actualizarChangelog(codFuncional:String):Boolean {
		return this.ctx.head_actualizarChangelog(codFuncional);
	}
	function regenerarParche(codFuncional:String):Boolean {
		return this.ctx.head_regenerarParche(codFuncional);
	}
	function parcheFichero(nombre:String, ruta:String, comprobar:Boolean):Boolean {
		return this.ctx.head_parcheFichero(nombre, ruta, comprobar);
	}
	function anadirNodoParche(txt:String, comprobar:Boolean):Boolean {
		return this.ctx.head_anadirNodoParche(txt, comprobar);
	}
	function anadirNodoParche(txt:String, comprobar:Boolean):Boolean {
		return this.ctx.head_anadirNodoParche(txt, comprobar);
	}
	function buscarNodoParche(nombre:String, ruta:String):FLDomNode {
		return this.ctx.head_buscarNodoParche(nombre, ruta);
	}
	function lanzarLog(accion:String) {
		return this.ctx.head_lanzarLog(accion);
	}
	function comprobarConsistencia(codFuncional:String):Boolean {
		return this.ctx.head_comprobarConsistencia(codFuncional);
	}
	function anadirFicheroParche(ruta:String, nombre:String):Boolean {
		return this.ctx.head_anadirFicheroParche(ruta, nombre);
	}
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration ifaceCtx */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends head {
    function ifaceCtx( context ) { head( context ); }
	function pub_crearFun(codFuncional:String) {
		return this.crearFun(codFuncional);
	}
	function pub_bajarFun(codFuncional:String) {
		return this.bajarFun(codFuncional);
	}
	function pub_subirFun(codFuncional:String) {
		return this.subirFun(codFuncional);
	}
	function pub_actualizarFun(codFuncional:String) {
		return this.actualizarFun(codFuncional);
	}
	function pub_probarFun(codFuncional:String) {
		return this.probarFun(codFuncional);
	}
	function pub_recargarFun(codFuncional:String) {
		return this.recargarFun(codFuncional);
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
	this.iface.util = new FLUtil;
	this.iface.pathLocal = flmaveppal.iface.pub_obtenerPathLocal();
	this.iface.urlRepositorioMod = flmaveppal.iface.pub_obtenerUrlRepositorioMod();
	this.iface.urlRepositorioFun = flmaveppal.iface.pub_obtenerUrlRepositorioFun();
	this.iface.urlRepositorioWebOficial = flmaveppal.iface.pub_obtenerUrlRepositorioWebOficial();
	this.iface.urlRepositorioWebFun = flmaveppal.iface.pub_obtenerUrlRepositorioWebFun();
	this.iface.versionOficial = flmaveppal.iface.pub_obtenerVersionOficial();
	
	this.iface.tbnCrearFun = this.child("tbnCrearFun");
	this.iface.tbnBajarFun = this.child("tbnBajarFun");
	this.iface.tbnSubirFun = this.child("tbnSubirFun");
	this.iface.tbnActualizarFun = this.child("tbnActualizarFun");
	this.iface.tbnProbarFun = this.child("tbnProbarFun");
	this.iface.tbnRecargarFun = this.child("tbnRecargarFun");
	
	connect(this.iface.tbnCrearFun, "clicked()", this, "iface.tbnCrearFun_clicked()");
	connect(this.iface.tbnBajarFun, "clicked()", this, "iface.tbnBajarFun_clicked()");
	connect(this.iface.tbnSubirFun, "clicked()", this, "iface.tbnSubirFun_clicked()");
	connect(this.iface.tbnActualizarFun, "clicked()", this, "iface.tbnActualizarFun_clicked()");
	connect(this.iface.tbnProbarFun, "clicked()", this, "iface.tbnProbarFun_clicked()");
	connect(this.iface.tbnRecargarFun, "clicked()", this, "iface.tbnRecargarFun_clicked()");
	
	this.cursor().setMainFilter("esproyecto = false");
	this.child("tableDBRecords").refresh();
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

/** \D Función intermedia que llama a la pantalla de log estableciendo antes el código de la acción a realizar sobre la funcionalidad o el cliente.
\end */
function head_tbnRecargarFun_clicked() 
{
	this.iface.lanzarLog("FR");
}
function head_tbnProbarFun_clicked()
{
	this.iface.lanzarLog("FP");
}
function head_tbnSubirFun_clicked() 
{
	this.iface.lanzarLog("FS");
}
function head_tbnCrearFun_clicked()  
{
	this.iface.lanzarLog("FC");
}
function head_tbnBajarFun_clicked() 
{
	this.iface.lanzarLog("FB");
}
function head_tbnActualizarFun_clicked() 
{
	this.iface.lanzarLog("FA");
}

/** \D Lanza el formulario de log, estableciendo antes en una variable global el tipo de acción a realizar
\end */
function head_lanzarLog(accion:String)
{
	var codFuncional = this.cursor().valueBuffer("codfuncional");
	if (!codFuncional)
		return;
	
	var miVar:FLVar = new FLVar();
	miVar.set("ACCIONMV", accion);
	
	flmaveppal.iface.pub_log = new FLFormSearchDB("mv_log");
	var cursor:FLSqlCursor = flmaveppal.iface.pub_log.cursor();
	cursor.select("codfuncional = '" + codFuncional + "'");
	cursor.first();
	cursor.setModeAccess(cursor.Browse);
	flmaveppal.iface.pub_log.setMainWidget();
	cursor.refreshBuffer();
	flmaveppal.iface.pub_log.exec("codfuncional");
	flmaveppal.iface.pub_log.close();
}

/** \D Genera un subdirectorio con la funcionalidad que en debe ser igual al directorio 'Nuevo' y sirve para comprobar que el parche generado funciona correctamente
\end */
function head_recargarFun(codFuncional:String)
{
	Dir.current = flmaveppal.iface.pathLocal;
	if (!File.exists(codFuncional)) {
		MessageBox.warning(Dir.current + "/" + codFuncional + "\n" + this.iface.util.translate("scripts", "El directorio local no existe. No es posible regenerar el directorio de prueba"), MessageBox.Yes, MessageBox.NoButton, MessageBox.NoButton);
		return;
	}
	
	if (!File.exists(codFuncional + "/prueba")) {
		MessageBox.warning(Dir.current + "/" + codFuncional + "\n" + this.iface.util.translate("scripts", "El directorio prueba no existe. Debe crear el directorio."), MessageBox.Yes, MessageBox.NoButton, MessageBox.NoButton);
		return;
	}
	
	if (!this.iface.regenerarParche(codFuncional)) {
		flmaveppal.iface.pub_log.child("log").append("Error al regenerar el parche y el directorio de pruebas");
		return;
	}
	
	flmaveppal.iface.pub_log.child("log").append(this.iface.util.translate("scripts", "El parche y el directorio de pruebas asociado a la funcionalidad seleccionada ha sido regenerado correctamente"));
	sys.processEvents();
}

/** \D Busca los ficheros que se han modificado después de el fichero de parche 'funcionalidad.xml'. Para cada fichero extrae su parche, lo aplica al directorio 'prueba' y modifica el parche 'funcionalidad.xml'

@param	codFuncional: Código de la funcionalidad
@return	True si no hay error, false en caso contrario
\end */
function head_regenerarParche(codFuncional:String):Boolean
{
	var dirParche:String = codFuncional + "/" + codFuncional + "/";
	var rutaParche:String = flmaveppal.iface.pathLocal + dirParche;
	
	this.iface.funcionalParche = codFuncional;
	if (!this.iface.xmlParche)
		this.iface.xmlParche= new FLDomDocument;

	if (!this.iface.xmlParche.setContent(File.read(rutaParche + codFuncional + ".xml"))) {
		flmaveppal.iface.pub_log.child("log").append("Error al leer el fichero " + codFuncional + ".xml");
		return false;
	}

	Dir.current = flmaveppal.iface.pathLocal + codFuncional + "/nuevo/";
	var comando:String = "find . -newer " + rutaParche + codFuncional + ".xml -type f";
	var resComando:Array = flmaveppal.iface.pub_ejecutarComando(comando);
	if (resComando.ok == false) {
		flmaveppal.iface.pub_log.child("log").append("Error al Buscar los ficheros que han cambiado en el directorio nuevo");
		return false;
	}

	var ruta:String;
	var nombre:String;
	var ficheros:Array = resComando.salida.split("\n");
	if (ficheros.length == 1)
		return true;
			
	var posAux:Number;
	for (var i:Number = 0; i < (ficheros.length - 1); i++) {
		posAux = ficheros[i].findRev("/") + 1; 
		nombre = ficheros[i].substring(posAux, ficheros[i].length);
		if (nombre.endsWith("~"))
			continue;
		ruta = ficheros[i].substring(2, posAux);
		if (!this.iface.parcheFichero(nombre, ruta, true))
			return false;

		var nodo:FLDomNode = this.iface.buscarNodoParche(nombre, ruta);
		if (!nodo)
			continue;

		if (!flmaveppal.iface.pub_aplicarParcheNodo(nodo, dirParche, codFuncional + "/previo/", codFuncional + "/prueba/"))
			return false;
	}
	
	if (!this.iface.grabarFicheroParche(flmaveppal.iface.pathLocal + dirParche,
		codFuncional + ".xml", this.iface.xmlParche.toString(4))) {
		flmaveppal.iface.pub_log.child("log").append("Error al guardar el fichero " + codFuncional + ".xml");
		return false;
	}
	
	return true;
}

/** \D Genera un subdirectorio con la funcionalidad que en debe ser igual al directorio 'Nuevo' y sirve para comprobar que el parche generado funciona correctamente
\end */
function head_probarFun(codFuncional:String)
{
	if (!this.iface.funcionalidadExiste(codFuncional)) {
		return;
	}
	
	Dir.current = flmaveppal.iface.pathLocal;
	if (!File.exists(codFuncional)) {
		MessageBox.warning(Dir.current + "/" + codFuncional + "\n" + this.iface.util.translate("scripts", "El directorio local no existe. No es posible generar el directorio de prueba"), MessageBox.Yes, MessageBox.NoButton, MessageBox.NoButton);
		return;
	}
	
	if (!this.iface.generarDirPrueba(codFuncional, "prueba")) {
		flmaveppal.iface.pub_log.child("log").append("Error al generar el directorio 'prueba'");
		return;
	}
	
	var comando:String = "touch " + flmaveppal.iface.pathLocal + codFuncional + "/" + codFuncional + "/" + codFuncional + ".xml";
	var resComando:Array = flmaveppal.iface.pub_ejecutarComando(comando);
	if (resComando.ok == false) {
		return;
	}
	
	flmaveppal.iface.pub_log.child("log").append(this.iface.util.translate("scripts", "El directorio de pruebas asociado a la funcionalidad seleccionada ha sido regenerado correctamente"));
	sys.processEvents();
}

/** \D Actualiza la funcionalidad seleccionada en el repositorio
\end */
function head_subirFun(codFuncional:String) 
{
	if (!this.iface.funcionalidadExiste(codFuncional))
		return;
	

	if (!this.iface.comprobarConsistencia(codFuncional))
		return;

	var res:Number = MessageBox.warning(this.iface.util.translate("scripts", "Va a actualizar en el repositorio la funcionalidad %1").arg(codFuncional), MessageBox.Yes, MessageBox.No);
	if (res != MessageBox.Yes)
		return;
	
	if (!this.iface.actualizarChangelog(codFuncional)) {
		flmaveppal.iface.pub_log.child("log").append("Error al actualizar el Changelog");
		return false;
	}

	var comando:String = "svn commit " + flmaveppal.iface.pathLocal + codFuncional + "/" + codFuncional + " -m AUTO_ACTUALIZACION_" + codFuncional;
	flmaveppal.iface.pub_log.child("log").append("Ejecutando " + comando);
	var resComando:Array = flmaveppal.iface.pub_ejecutarComando(comando);
	if (resComando.ok == false) {
		flmaveppal.iface.pub_log.child("log").append(this.iface.util.translate("scripts", "Error al actualizar la funcionalidad en el repositorio"));
		return;
	}
	flmaveppal.iface.pub_log.child("log").append("OK");
	
	flmaveppal.iface.pub_log.child("log").append(this.iface.util.translate("scripts", "La funcionalidad seleccionada se actualizó correctamente en el repositorio"));
	
	// Actualizamos la fecha de modificación
	var hoy = new Date();
	var cursor:FLSqlCursor = this.cursor();
	cursor.setModeAccess(cursor.Edit);
	cursor.refreshBuffer();
	cursor.setValueBuffer("fechamod", hoy);
	if (!cursor.commitBuffer())
		flmaveppal.iface.pub_log.child("log").append("Error al actualizar la fecha de modificación de la funcionalidad");
	else			
		flmaveppal.iface.pub_log.child("log").append("Fecha de modificación actualizada a  " + hoy.toString());
	
	sys.processEvents();
}

/** \D Comprueba que todos los ficheros del directorio del parche están en la lista del parche y viceversa
@param	codFuncional: Código de la funcionalidad a comprobar
\end */
function head_comprobarConsistencia(codFuncional:String):Boolean
{
	Dir.current = flmaveppal.iface.pub_obtenerPathLocal();
	var dirParche:String = codFuncional + "/" + codFuncional;

	flmaveppal.iface.pub_log.child("log").append("Comprobando consistencia para %1...".arg(codFuncional));
	sys.processEvents();

	if (!File.exists(dirParche + "/" + codFuncional + ".xml")) {
		flmaveppal.iface.pub_log.child("log").append("El parche " + codFuncional + " está vacío");
		return false;
	}
	var xmlParche:FLDomDocument = new FLDomDocument;
	xmlParche.setContent(File.read(dirParche + "/" + codFuncional + ".xml"));
	var nodo:FLDomNode;
	var nodoDoc:FLDomNode = xmlParche.namedItem("flpatch:modifications");
	
	var ok:Boolean = true;
	var fichero:String;
	for (nodo = nodoDoc.firstChild(); nodo; nodo = nodo.nextSibling()) {
		fichero = nodo.toElement().attribute("name");
		if (!File.exists(dirParche + "/" + fichero)) {
			ok = false;
			flmaveppal.iface.pub_log.child("log").append("La entrada para el fichero %1 del fichero %2 no existe en el directorio %2".arg(fichero).arg(codFuncional + ".xml").arg(codFuncional));
		}
	}

	var dirFuncional = new Dir(dirParche);
	var ficheros:Array = dirFuncional.entryList("*");
	var encontrado:Boolean;
// 	var contenido:String = "";
// 	var rutaFichDestino:String = "";
// 	var rutaFichOrigen:String = "";
	
	for (var i:Number = 0; i < ficheros.length; i++) {
		//rutaFichero = dirParche + "/" + ficheros[i];
debug("ficheros = " + ficheros[i]);
		if (ficheros[i] == "." || ficheros[i] == "..") {
			continue;
		}
		if (ficheros[i] == "Changelog" || ficheros[i] == "test") {
			continue;
		}
		if (ficheros[i].endsWith("~")) {
			continue;
		}
		if (ficheros[i] == (codFuncional + ".xml")) {
			continue;
		}
		encontrado = false;
		for (nodo = nodoDoc.firstChild(); nodo; nodo = nodo.nextSibling()) {
			if (nodo.toElement().attribute("name") == ficheros[i]) {
				encontrado = true;
				break;
			}
		}
		if (!encontrado) {
			ok = false;
			flmaveppal.iface.pub_log.child("log").append("El fichero %1 no tiene una entrada en el fichero de parche %2)".arg(ficheros[i]).arg(codFuncional + ".xml"));
		}
	}
	if (ok) {
		flmaveppal.iface.pub_log.child("log").append("COMPROBACIÓN DE CONSISTENCIA OK");
	} else {
		flmaveppal.iface.pub_log.child("log").append("ERROR DE CONSISTENCIA EN EL PARCHE");
	}
	
	return ok;
}

/** \D Actualiza el fichero Changelog asociado a la funcionalidad seleccionada antes de hacer un commit al repositorio. La actualización de este fichero es opcional a menos que el fichero esté vacío.
@param	codFuncional: Código de la funcionalidad a actualizar
\end */
function head_actualizarChangelog(codFuncional:String):Boolean
{
	var existe:Boolean = File.exists(this.iface.pathLocal + codFuncional + "/" + codFuncional + "/Changelog");
	if (existe) {
		var res:Number = MessageBox.information(this.iface.util.translate("scripts", "¿Desea actualizar el fichero Changelog asociado?"), MessageBox.Yes, MessageBox.No);
		if (res != MessageBox.Yes) {
			return true;
		}
	}
	var contenido:String = "";
	if (existe)
			contenido = File.read(this.iface.pathLocal + codFuncional + "/" + codFuncional + "/Changelog");
	else {
		var hoyFecha:Date = new Date;
		var hoyString:String = hoyFecha.toString();
		hoyString = hoyString.substring(8, 10) + "/" + hoyString.substring(5, 7) + "/" + hoyString.substring(0, 4);
		contenido = "!! " + hoyString + " SVN:\n* Creación de la funcionalidad " + codFuncional;
	}
	
	var dialog = new Dialog;
	dialog.caption = "Changelog de " + codFuncional;
	dialog.okButtonText = "Aceptar"
	dialog.cancelButtonText = "Cancelar";
	
	var txtContenido = new TextEdit;
	txtContenido.text = contenido;
	dialog.add( txtContenido );
	
	if( dialog.exec() ) {
		contenido = txtContenido.text;
		if (!this.iface.grabarFicheroParche(this.iface.pathLocal + codFuncional + "/" + codFuncional + "/",
			"Changelog", contenido)) {
			flmaveppal.iface.pub_log.child("log").append("Error al guardar el fichero Changelog");
			return false;
		}
	}
	
	return true;	
}

/** \D Crea una funcionalidad en el repositorio
\end */
function head_crearFun(codFuncional:String) 
{
	var util:FLUtil = new FLUtil;
	
	if (this.iface.funcionalidadExiste(codFuncional)) {
		MessageBox.warning(this.iface.util.translate("scripts", "La funcionalidad seleccionada ya existe en el repositorio"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	
	var repositorio:String;
	var codigoWeb:Boolean = util.sqlSelect("mv_funcional", "codigoweb", "codfuncional = '" + codFuncional + "'");
	if (codigoWeb) {
		repositorio = this.iface.urlRepositorioWebFun;
	} else {
		repositorio = this.iface.urlRepositorioFun + "tronco/";
	}
	var res:Number = MessageBox.warning(util.translate("scripts", "Va a crear en el repositorio %1 la funcionalidad %2").arg(repositorio).arg(codFuncional), MessageBox.Yes, MessageBox.No);
	if (res != MessageBox.Yes)
		return;
	
	var comando:String = "svn mkdir " + repositorio + codFuncional + " -m AUTO_CREACION_" + codFuncional;
	var resComando:Array = flmaveppal.iface.pub_ejecutarComando(comando);
	if (resComando.ok == false) {
		flmaveppal.iface.pub_log.child("log").append(this.iface.util.translate("scripts", "Error al crear la funcionalidad en el repositorio"));
		return;
	}
	
	comando = "svn mkdir " + repositorio + codFuncional + "/tronco -m AUTO_CREACION_" + codFuncional;
	resComando = flmaveppal.iface.pub_ejecutarComando(comando);
	if (resComando.ok == false) {
		flmaveppal.iface.pub_log.child("log").append(this.iface.util.translate("scripts", "Error al crear la funcionalidad en el repositorio"));
		return;
	}
	
// 	comando = "svn mkdir " + repositorio + codFuncional + "/tronco/test -m AUTO_CREACION_" + codFuncional;
// 	resComando = flmaveppal.iface.pub_ejecutarComando(comando);
// 	if (resComando.ok == false) {
// 		flmaveppal.iface.pub_log.child("log").append(this.iface.util.translate("scripts", "Error al crear la funcionalidad en el repositorio"));
// 		return;
// 	}
	
	flmaveppal.iface.pub_log.child("log").append(this.iface.util.translate("scripts", "La funcionalidad seleccionada se creó correctamente en el repositorio:\n%1").arg(repositorio));
	sys.processEvents();
}

/** \D Comprueba si una determinada funcionalidad existe o no en el repositorio

@param	codFuncional: funcionalidad
@return	True si la funcionalidad existe, false en caso contrario
\end */
function head_funcionalidadExiste(codFuncional:String):Boolean
{
	var util:FLUtil = new FLUtil;
	var codigoWeb:Boolean = util.sqlSelect("mv_funcional", "codigoweb", "codfuncional = '" + codFuncional + "'");
	var versionBase:String = util.sqlSelect("mv_funcional", "versionbase", "codfuncional = '" + codFuncional + "'");
	if (!versionBase) {
		versionBase = "tronco";
	}
debug(codigoWeb);
debug(this.iface.urlRepositorioWebFun);
	var comando:String;
	if (codigoWeb) {
		comando = "svn ls " + this.iface.urlRepositorioWebFun + codFuncional;
	} else {
		comando = "svn ls " + this.iface.urlRepositorioFun + versionBase + "/" + codFuncional;
	}
debug(comando);

	var resComando:Array = flmaveppal.iface.pub_ejecutarComando(comando);
	return resComando.ok;
}

/** \D Obtiene la funcionalidad del repositorio, creando los directorios previo, nuevo y nombre_funcionalidad para poder editarla.
\end */
function head_bajarFun(codFuncional:String) 
{
	if (!this.iface.funcionalidadExiste(codFuncional))
		return;
	
	var dialog:Dialog = new Dialog;
	dialog.caption = this.iface.util.translate ( "scripts", "Obtener funcionalidad" );
	dialog.OKButtonText = this.iface.util.translate ( "scripts", "Aceptar" );
	dialog.cancelButtonText = this.iface.util.translate ( "scripts", "Cancelar" );

	var bgroup:GroupBox = new GroupBox;
	dialog.add( bgroup );

	var lblModBase:CheckBox = new CheckBox;
	lblModBase.text = this.iface.util.translate ( "scripts", "Módulos y funcionalidad base" );
	lblModBase.checked = true;
	bgroup.add( lblModBase );
	
	var lblParche:CheckBox = new CheckBox;
	lblParche.text = this.iface.util.translate ( "scripts", "Parche de funcionalidad" );
	lblParche.checked = true;
	bgroup.add( lblParche );

	if ( !dialog.exec() )
		return;
	
	if (!lblModBase.checked && !lblParche.checked)
		return;
	
	Dir.current = flmaveppal.iface.pathLocal;
	if (File.exists(codFuncional)) {
		var res:Number = MessageBox.warning(Dir.current + "/" + codFuncional + "\n" + this.iface.util.translate("scripts", "El directorio local ya existe ¿desea sobreescribirlo?"), MessageBox.Yes, MessageBox.No);
		if (res != MessageBox.Yes)
				return;
	} else {
		var resComando:Array = flmaveppal.iface.pub_ejecutarComando("mkdir " + codFuncional);
		if (resComando.ok == false) {
			flmaveppal.iface.pub_log.child("log").append("Error mkdir arbol");
			return;
		}
	}
	
	
	if (File.exists(codFuncional + "/nuevo") && File.exists(codFuncional + "/" + codFuncional + "/" + codFuncional + ".xml")) {
		var comando:String = "find " + codFuncional + "/nuevo -newer " + codFuncional + "/" + codFuncional + "/" + codFuncional + ".xml -type f";
		var resComando:Array = flmaveppal.iface.pub_ejecutarComando(comando);
		if (resComando.ok == false) {
			flmaveppal.iface.pub_log.child("log").append("Error al Buscar los ficheros que han cambiado en el directorio nuevo");
			return false;
		}
		var ficheros:Array = resComando.salida.split("\n");
		if (ficheros.length > 1) {
			var res:Number = MessageBox.warning(this.iface.util.translate("scripts", "Los siguientes ficheros han sido modificados despues de la última generación del parche:\n") + resComando.salida + this.iface.util.translate("scripts", "¿desea continuar?"), MessageBox.Yes, MessageBox.No);
			if (res != MessageBox.Yes)
				return;
		}
	}
	
	if (lblModBase.checked) {
		if (!this.iface.generarDirPrevio(codFuncional)) {
			flmaveppal.iface.pub_log.child("log").append("Error al generar el directorio 'previo'");
			return;
		}
	}
	
	if (lblParche.checked) {
		if (!flmaveppal.iface.pub_checkoutParche(codFuncional, codFuncional + "/" + codFuncional)) {
			flmaveppal.iface.pub_log.child("log").append("Error al obtener el parche " + codFuncional);
			return false;
		}
	}
	
	if (!this.iface.generarDirPrueba(codFuncional, "nuevo")) {
		flmaveppal.iface.pub_log.child("log").append("Error al generar el directorio 'nuevo'");
		return;
	}
	
	flmaveppal.iface.pub_log.child("log").append(this.iface.util.translate("scripts", "La funcionalidad seleccionada ha sido obtenida correctamente"));
  
  var cleanupDom = new FLDomDocument;
	cleanupDom.cleanup();
  
	sys.processEvents();
}

/** \D Regenera los ficheros de funcionalidad ('funcionalidad.xml' y ficheros modificados)
\end */
function head_actualizarFun() 
{
	var codFuncional:String = this.cursor().valueBuffer("codfuncional");
	if (!codFuncional) {
		MessageBox.warning(this.iface.util.translate("scripts", "No hay ninguna funcionalidad seleccionada"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	
	flmaveppal.iface.pub_log.child("log").append("Creando parche para " + codFuncional);
	this.iface.funcionalParche = codFuncional;
	if (!this.iface.xmlParche)
		this.iface.xmlParche= new FLDomDocument;
	this.iface.xmlParche.setContent("<flpatch:modifications name=\"" + codFuncional + "\"/>");
	if (!this.iface.crearParche("")) {
		flmaveppal.iface.pub_log.child("log").append("Error creando el parche " + codFuncional );
		return;
	}
	
	if (!this.iface.grabarFicheroParche(this.iface.pathLocal + "/" + codFuncional + "/" + codFuncional + "/", codFuncional + ".xml", this.iface.xmlParche.toString(4))) {
		flmaveppal.iface.pub_log.child("log").append("Error al guardar el fichero " + codFuncional + ".xml");
		return;
	}
	flmaveppal.iface.pub_log.child("log").append("Parche creado");
	sys.processEvents();
	
	MessageBox.information(this.iface.util.translate("scripts", "La funcionalidad seleccionada se actualizó correctamente"), MessageBox.Ok, MessageBox.NoButton);
}

/** \D Función recursiva que regenera los ficheros de funcionalidad ('funcionalidad.xml' y ficheros modificados) en la ruta especificada. 

@param	ruta: path donde reside la funcionalidad a generar
@return	True si la generación del parche se realiza con éxito, false en caso contrario
\end */
function head_crearParche(ruta:String):Boolean
{
	var rutaNuevo:String = this.iface.pathLocal + this.iface.funcionalParche + "/nuevo/" + ruta;
	var dirNuevo:Dir = new Dir(rutaNuevo);
	
	var ficheros:Array = dirNuevo.entryList("*", Dir.Files);
	for (var i:Number = 0; i < ficheros.length; i++) {
		if (ficheros[i].endsWith("~"))
			continue;
		if (!this.iface.parcheFichero(ficheros[i], ruta, false))
			return false;
	}
	
	var directorios:Array = dirNuevo.entryList("*", Dir.Dirs);
	for (var i:Number = 0; i < directorios.length; i++) {
		if (directorios[i].startsWith("."))
			continue;
		if (!this.iface.crearParche(ruta + directorios[i] + "/")) {
			flmaveppal.iface.pub_log.child("log").append("Error al crear parche en la ruta " + ruta + directorios[i] + "/");
			return false;
		}
	}
	return true;
}

/** \D Función que actualiza el fichero de parche para un determinado fichero

@param	nombre: Nombre del fichero
@param	ruta: Path relativo al directorio 'nuevo' donde reside el fichero
@param	sustituir: Indica si el nodo de diferencias generado sustituirá a un nodo ya existente en el fichero de parche
@return	True si no hay error, false en caso contrario
\end */
function head_parcheFichero(nombre:String, ruta:String, sustituir:Boolean):Boolean
{
	var rutaNuevo:String = this.iface.pathLocal + this.iface.funcionalParche + "/nuevo/" + ruta;
	var rutaPrevio:String = this.iface.pathLocal + this.iface.funcionalParche + "/previo/" + ruta;
	var rutaParche:String = this.iface.pathLocal + this.iface.funcionalParche + "/" + this.iface.funcionalParche + "/";
	
	if (File.exists(rutaPrevio + nombre)) {
		var comando:String = "diff --brief " + rutaNuevo + nombre + " " + rutaPrevio + nombre;
		var resComando:Array = flmaveppal.iface.pub_ejecutarComando(comando);
		if (resComando.ok == false)
			return false;
		if (resComando.salida != "") {
			var extension:String = nombre.substring(nombre.findRev(".") + 1, nombre.length);
			var contenido:String;
			switch(extension) {
				case "ui":
				case "mtd":
				case "xml":
					flmaveppal.iface.pub_log.child("log").append("Generando parche para " + nombre);
					contenido = flmaveppal.iface.pub_obtenerXmlDif(rutaPrevio + nombre, rutaNuevo + nombre, this.iface.funcionalParche);
					if (!contenido) {
						flmaveppal.iface.pub_log.child("log").append("Error al obtener diferencias para el fichero xml " + nombre);
						return false;
					}
					if (!this.iface.anadirNodoParche("<flpatch:patchXml name=\"" + nombre + "\" path=\"" + ruta + "\"/>", sustituir)) {
						return false;
					}
					if (!this.iface.grabarFicheroParche(rutaParche, nombre, contenido)) {
						flmaveppal.iface.pub_log.child("log").append("Error al guardar el fichero " + nombre);
						return false;
					}
					break;
				case "qs":
					flmaveppal.iface.pub_log.child("log").append("Generando parche para " + nombre);
					contenido = flmaveppal.iface.pub_obtenerScriptDif(rutaPrevio + nombre, rutaNuevo + nombre, this.iface.funcionalParche);
					if (!contenido) {
						flmaveppal.iface.pub_log.child("log").append("Error al obtener diferencias para el script " + nombre);
						return false;
					}
					if (!this.iface.anadirNodoParche("<flpatch:patchScript name=\"" + nombre + "\" path=\"" + ruta + "\"/>", sustituir)) {
						return false;
					}
					if (!this.iface.grabarFicheroParche(rutaParche, nombre, contenido)) {
						flmaveppal.iface.pub_log.child("log").append("Error al guardar el fichero " + nombre);
						return false;
					}
					break;
				case "php":
					flmaveppal.iface.pub_log.child("log").append("Generando parche para " + nombre);
					contenido = flmaveppal.iface.pub_obtenerPhpDif(rutaPrevio + nombre, rutaNuevo + nombre, this.iface.funcionalParche);
					if (!contenido) {
						flmaveppal.iface.pub_log.child("log").append("Error al obtener diferencias para el fichero php " + nombre);
						return false;
					}
					if (!this.iface.anadirNodoParche("<flpatch:patchPhp name=\"" + nombre + "\" path=\"" + ruta + "\"/>", sustituir)) {
						return false;
					}
					if (!this.iface.grabarFicheroParche(rutaParche, nombre, contenido)) {
						flmaveppal.iface.pub_log.child("log").append("Error al guardar el fichero " + nombre);
						return false;
					}
					break;
				default:
					flmaveppal.iface.pub_log.child("log").append("Leyendo nueva versión de " + nombre);
					
// 					contenido = File.read(rutaNuevo + nombre);
					if (!this.iface.anadirNodoParche("<flpatch:replaceFile name=\"" + nombre + "\" path=\"" + ruta + "\"/>", sustituir))
						return false;

					var comando:String = "cp -f " + rutaNuevo + nombre + " " + rutaParche + nombre;
					var resComando:Array = flmaveppal.iface.pub_ejecutarComando(comando);
					if (resComando.ok == false) {
						this.iface.pub_log.child("log").append("Error al copiar el fichero con: " + comando);
						return;
					}
					if (!this.iface.anadirFicheroParche(rutaParche, nombre)) {
						return false;
					}
			}
			
			flmaveppal.iface.pub_log.child("log").append("OK");
		}
	} else {
		flmaveppal.iface.pub_log.child("log").append("Leyendo nuevo fichero " + nombre);
		if (!this.iface.anadirNodoParche("<flpatch:addFile name=\"" + nombre + "\" path=\"" + ruta + "\"/>", sustituir)) {
			return false;
		}

		var comando:String = "cp -f " + rutaNuevo + nombre + " " + rutaParche + nombre;
		var resComando:Array = flmaveppal.iface.pub_ejecutarComando(comando);
		if (resComando.ok == false) {
			this.iface.pub_log.child("log").append("Error al copiar el fichero con: " + comando);
			return;
		}
		if (!this.iface.anadirFicheroParche(rutaParche, nombre)) {
			return false;
		}
// 		if (!this.iface.grabarFicheroParche(rutaParche, nombre, File.read(rutaNuevo + nombre))) {
// 			flmaveppal.iface.pub_log.child("log").append("Error al guardar el fichero " + nombre);
// 			return false;
// 		}
		flmaveppal.iface.pub_log.child("log").append("OK");
		sys.processEvents();
	}
	return true;
}

/** \D Establece el tipo de documento actual

@param	tipoDoc: Tipo de documento
@return	true su no hay error, false en caso contrario
\end */
function head_anadirNodoParche(txt:String, sustituir:Boolean):Boolean 
{
	var xmlAux:FLDomDocument = new FLDomDocument;
	if (!(xmlAux.setContent(txt)))
		return false;
	
	if (sustituir) {
		var nombre:String = xmlAux.firstChild().toElement().attribute("name");
		var ruta:String = xmlAux.firstChild().toElement().attribute("path");
		var nodoPrevio:FLDomNode = this.iface.buscarNodoParche(nombre, ruta);
		if (nodoPrevio) {
			this.iface.xmlParche.firstChild().replaceChild(xmlAux.firstChild(), nodoPrevio);
		} else {
			this.iface.xmlParche.firstChild().appendChild(xmlAux.firstChild());
		}
	} else {
		this.iface.xmlParche.firstChild().appendChild(xmlAux.firstChild());
	}

	return true;
}

/** \D Busca un nodo en el fichero de parche por los atributos 'name' y 'path'

@param	nombre: Valor del atributo 'name'
@param	ruta: Valor del atributo 'path'
@return	Nodo si se ha encontrado, false en caso contrario
\end */
function head_buscarNodoParche(nombre:String, ruta:String):FLDomNode
{
	var listaNodos:FLDomNodeList = this.iface.xmlParche.firstChild().childNodes();
	for (var j:Number = 0; j < listaNodos.length(); j++) {
		if (listaNodos.item(j).toElement().attribute("name") == nombre && listaNodos.item(j).toElement().attribute("path") == ruta) {
			return listaNodos.item(j);
		}
	}
	return false;
}

/** \D Guarda un fichero en disco y lo incluye en el control de versiones

@param	ruta: ruta del fichero
@param	nombre: nombre del fichero
@param	contenido: contenido del fichero
@return	True si no hay error, false en caso contrario
\end */
function head_grabarFicheroParche(ruta:String, nombre:String, contenido:String):Boolean
{
	File.write(ruta + nombre, contenido);
	if (!this.iface.anadirFicheroParche(ruta, nombre)) {
		return false;
	}
	
	return true;
}

function head_anadirFicheroParche(ruta:String, nombre:String):Boolean
{
	var resComando:Array = flmaveppal.iface.pub_ejecutarComando("svn status " + ruta + nombre);
	if (resComando.ok == false)
		return false;
	if (resComando.salida.charAt(0) == "?")
		resComando = flmaveppal.iface.pub_ejecutarComando("svn add " + ruta + nombre);
	return true;
}


/** \D Genera el directorio 'prueba' como copia de 'previo' más el parche correspondiente a la funcionalidad a desarrollar sin bajar dicho parche del repositorio, es decir, con la copia local

@param	codFuncional: funcionalidad
@return	True si no hay error, false en caso contrario
\end */
function head_generarDirPrueba(codFuncional:String, directorio:String):Boolean
{
	Dir.current = flmaveppal.iface.pathLocal + codFuncional;
	
	flmaveppal.iface.pub_log.child("log").append("Regenerando directorio " + Dir.current + "/" + directorio);
	var resComando:Array = flmaveppal.iface.pub_ejecutarComando("rm -rf " + directorio);
	if (resComando.ok == false) {
		return false;
	}
	
	resComando = flmaveppal.iface.pub_ejecutarComando("cp -rf previo " + directorio);
	if (resComando.ok == false) {
		flmaveppal.iface.pub_log.child("log").append("Error al crear el directorio " + directorio);
		return false;
	}
	flmaveppal.iface.pub_log.child("log").append("OK");
	sys.processEvents();
	
	if (!flmaveppal.iface.pub_aplicarParche(codFuncional, codFuncional + "/" + codFuncional, codFuncional + "/" + directorio)) {
		flmaveppal.iface.pub_log.child("log").append("Error al aplicar el parche " + codFuncional + " sobre " + directorio);
		return false;
	}
	return true;
}

/** \D Crea el directorio previo como el total de los módulos afectados más los parches de las funcionalidades de las cuales depende la funcionalidad a desarrollar

@param	codFuncional: funcionalidad
@return	True si no hay error, false en caso contrario
\end */
function head_generarDirPrevio(codFuncional:String):Boolean
{
	var util:FLUtil = new FLUtil;
	var versionBase:String = util.sqlSelect("mv_funcional", "versionbase", "codfuncional = '" + codFuncional + "'");

	var resComando:Array = flmaveppal.iface.pub_ejecutarComando("rm -rf " + codFuncional + "/previo ");
	if (resComando.ok == false) {
		return;
	}
	
	resComando = flmaveppal.iface.pub_ejecutarComando("rm -rf " + codFuncional + "/test ");
	if (resComando.ok == false) {
		return;
	}
	
	if (!File.exists(codFuncional + "/doc")) {
		resComando = flmaveppal.iface.pub_ejecutarComando("mkdir " + codFuncional + "/doc");
		if (resComando.ok == false) {
			flmaveppal.iface.pub_log.child("log").append("Error mkdir árbol");
			return;
		}
	}
	
	resComando = flmaveppal.iface.pub_ejecutarComando("rm -rf " + codFuncional + "/config");
	if (resComando.ok == false) {
		flmaveppal.iface.pub_log.child("log").append("Error mkdir árbol");
		return;
	}
	resComando = flmaveppal.iface.pub_ejecutarComando("mkdir " + codFuncional + "/config");
	if (resComando.ok == false) {
		flmaveppal.iface.pub_log.child("log").append("Error mkdir árbol");
		return;
	}
	
	resComando = flmaveppal.iface.pub_ejecutarComando("mkdir " + codFuncional + "/previo ");
	if (resComando.ok == false) {
		flmaveppal.iface.pub_log.child("log").append("Error mkdir arbol");
		return;
	}
	
	if (!flmaveppal.iface.pub_checkoutMods(codFuncional, codFuncional, "previo", versionBase)) {
		flmaveppal.iface.pub_log.child("log").append("Error al obtener los módulos afectados por la funcionalidad " + codFuncional);
		return false;
	}
	
	var listaDep:Array = flmaveppal.iface.pub_obtenerListaDep(codFuncional);
	if (!listaDep) {
		flmaveppal.iface.pub_log.child("log").append("Error al obtener la lista de dependencias de " + codFuncional);
		return false;
	}
	
debug("Funcional = " + codFuncional);
debug("versionBase = " + versionBase);
	for (var i:Number = 0; i < listaDep.length; i++) {
		resComando = flmaveppal.iface.pub_ejecutarComando("rm -rf " + flmaveppal.iface.pathLocal + "/" + codFuncional + "/temp");
		if (resComando.ok == false) {
			flmaveppal.iface.pub_log.child("log").append("Error al borrar el directorio temporal");
			return false;
		}
		if (!flmaveppal.iface.pub_checkoutMods(listaDep[i], codFuncional, "previo", versionBase)) {
			flmaveppal.iface.pub_log.child("log").append("Error al obtener los módulos afectados por la funcionalidad " + listaDep[i]);
			return false;
		}
		if (!flmaveppal.iface.pub_checkoutParche(listaDep[i], codFuncional + "/temp", versionBase)) {
debug("Error");
			flmaveppal.iface.pub_log.child("log").append("Error al obtener el parche " + listaDep[i]);
			return false;
		}
		if (!flmaveppal.iface.pub_aplicarParche(listaDep[i], codFuncional + "/temp", codFuncional + "/previo")) {
			flmaveppal.iface.pub_log.child("log").append("Error al aplicar el parche " + listaDep[i]);
			return false;
		}
		if (!flmaveppal.iface.pub_anadirTest(codFuncional + "/temp", codFuncional)) {
			flmaveppal.iface.pub_log.child("log").append("Error al añadir las pruebas de " + listaDep[i]);
			return false;
		}
		if (!flmaveppal.iface.pub_anadirAConfig(listaDep[i], codFuncional)) {
			flmaveppal.iface.pub_log.child("log").append("Error al añadir la funcionalidad " + listaDep[i] + " al fichero de configuración del proyecto");
			return false;
		}
	}
	
	return true;
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////