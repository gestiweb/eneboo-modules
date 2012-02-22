/***************************************************************************
                 mv_masterproyectos.qs  -  description
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
Este formulario permite generar y gestionar proyectos, es decir, configuraciones de módulos que conforman instalaciones completas de FacturaLUX. Generalmente, están asociadas a clientes. También permite gestionar el versionado de las pruebas asociadas a cada proyecto. Las acciones que podemos realizar desde este formulario son las siguientes:
<ul>
	<li>Crear un nuevo proyecto en el repositorio: Crearemos primero el registro de la funcionalidad y después, con el registro seleccionado, pulsaremos el botón 'Crear funcionalidad en el repositorio'. Esto genera un nuevo directorio 'nombre_funcionalidad/tronco/' en la rama del repositorio .../funcional/</li>
	<li>Obtener una copia local del proyecto. Con el proyecto seleccionado pulsaremos el botón 'Obtener proyecto del repositorio'. Esto nos crea, en el directorio de trabajo, un directorio con el nombre del proyecto, así como los siguientes subdirectorios:
		<ul>
			<li>modulos: Contiene los módulos asociados al proyecto con todas las funcionalidades necesarias instaladas.</li>
			<li>test: Contiene los ficheros de las pruebas asociadas a cada una de las funcionalidades instaladas.</li>
			<li>nombre_proyecto: Contiene un subdirectorio test, con las pruebas asociadas al proyecto.</li>
			<li>config: Contiene ficheros xml que definen la estructura del proyecto.</li>
			<li>doc: Este directorio contendrá la documentación asociada al proyecto.</li>
		</ul>
	</li>
	<li>Subir las pruebas asociadas al proyecto al repositorio: Seleccionaremos el proyecto y pulsaremos el botón 'Subir pruebas al repositorio'. Con ello subiremos el contenido del directoio nombre_proyecto/nombre_proyecto/test al repositorio.</li>
</ul>
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
    var tbnCrearPro:Object;
	var tbnBajarPro:Object;
	var tbnExportarPro:Object;
	var tbnSubirPruebas:Object;
	var tbnPeso:Object;
	var util:FLUtil;
	var pathLocal:String;
	var urlRepositorioMod:String;
	var urlRepositorioFun:String;
	var versionOficial:String;
	var xmlParche:FLDomDocument;
	var funcionalParche:String;
	
	function oficial( context ) { interna( context ); } 
	function tbnCrearPro_clicked() {
		return this.ctx.oficial_tbnCrearPro_clicked();
	}
	function tbnBajarPro_clicked() {
		return this.ctx.oficial_tbnBajarPro_clicked();
	}
	function tbnExportarPro_clicked() {
		return this.ctx.oficial_tbnExportarPro_clicked();
	}
	function tbnSubirPruebas_clicked() {
		return this.ctx.oficial_tbnSubirPruebas_clicked();
	}
	function crearPro(codFuncional:String) {
		return this.ctx.oficial_crearPro(codFuncional);
	}
	function bajarPro(codFuncional:String) {
		return this.ctx.oficial_bajarPro(codFuncional);
	}
	function exportarPro(codFuncional:String) {
		return this.ctx.oficial_exportarPro(codFuncional);
	}
	function subirPruebas(codFuncional:String) {
		return this.ctx.oficial_subirPruebas(codFuncional);
	}
	function generarDirModulos(codProyecto:String, directorio:String):Boolean {
		return this.ctx.oficial_generarDirModulos(codProyecto, directorio);
	}
	function funcionalidadExiste(codFuncional:String):Boolean {
		return this.ctx.oficial_funcionalidadExiste(codFuncional);
	}
	function lanzarLog(accion:String) {
		return this.ctx.oficial_lanzarLog(accion)
	}
	function calcularPeso() {
		return this.ctx.oficial_calcularPeso();
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
	function pub_crearPro(codFuncional:String) {
		return this.crearPro(codFuncional);
	}
	function pub_bajarPro(codFuncional:String) {
		return this.bajarPro(codFuncional);
	}
	function pub_subirPruebas(codFuncional:String) {
		return this.subirPruebas(codFuncional);
	}
	function pub_exportarPro(codFuncional:String)  {
		return this.exportarPro(codFuncional);
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
	this.iface.versionOficial = flmaveppal.iface.pub_obtenerVersionOficial();
	
	this.iface.tbnCrearPro = this.child("tbnCrearPro");
	this.iface.tbnExportarPro = this.child("tbnExportarPro");
	this.iface.tbnBajarPro = this.child("tbnBajarPro");
	this.iface.tbnSubirPruebas = this.child("tbnSubirPruebas");
	this.iface.tbnPeso = this.child("tbnPeso");

	this.child("toolButtomInsert").close();
	this.child("toolButtonEdit").close();
	this.child("toolButtonDelete").close();
	this.child("toolButtonZoom").close();
	this.child("toolButtonCopy").close();
	this.child("tbnCrearPro").close();
	this.child("tbnSubirPruebas").close();
	this.child("tbnPeso").close();
	
	connect(this.iface.tbnCrearPro, "clicked()", this, "iface.tbnCrearPro_clicked()");
	connect(this.iface.tbnBajarPro, "clicked()", this, "iface.tbnBajarPro_clicked()");
	connect(this.iface.tbnSubirPruebas, "clicked()", this, "iface.tbnSubirPruebas_clicked()");
	connect(this.iface.tbnPeso, "clicked()", this, "iface.calcularPeso()");
	connect(this.iface.tbnExportarPro, "clicked()", this, "iface.tbnExportarPro_clicked()");
	
	this.cursor().setMainFilter("esproyecto = false and proyecto = true");
	this.child("tableDBRecords").refresh();
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

/** \D Función intermedia que llama a la pantalla de log estableciendo antes el código de la acción a realizar sobre la funcionalidad o el cliente.
\end */
function oficial_tbnSubirPruebas_clicked() 
{
	this.iface.lanzarLog("PS");
}
function oficial_tbnCrearPro_clicked()  
{
	this.iface.lanzarLog("PC");
}
function oficial_tbnBajarPro_clicked() 
{
	this.iface.lanzarLog("PB");
}
function oficial_tbnExportarPro_clicked() 
{
	this.iface.lanzarLog("PE");
}

/** \D Lanza el formulario de log, estableciendo antes en una variable global el tipo de acción a realizar
\end */
function oficial_lanzarLog(accion:String)
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

/** \D Actualiza la funcionalidad seleccionada en el repositorio
\end */
function oficial_subirPruebas(codFuncional:String) 
{
	if (!this.iface.funcionalidadExiste(codFuncional))
		return;
			
	var res:Number = MessageBox.warning(this.iface.util.translate("scripts", "Va a actualizar en el repositorio el proyecto ") + codFuncional, MessageBox.Yes, MessageBox.No);
	if (res != MessageBox.Yes)
		return;
	
	var comando:String = "svn commit " + flmaveppal.iface.pathLocal + codFuncional + "/" + codFuncional + " -m AUTO_ACTUALIZACION_" + codFuncional;
	flmaveppal.iface.pub_log.child("log").append("Ejecutando " + comando);
	var resComando:Array = flmaveppal.iface.pub_ejecutarComando(comando);
	if (resComando.ok == false) {
		flmaveppal.iface.pub_log.child("log").append(this.iface.util.translate("scripts", "Error al actualizar la el proyecto en el repositorio"));
		return;
	}
	flmaveppal.iface.pub_log.child("log").append("OK");
	
	flmaveppal.iface.pub_log.child("log").append(this.iface.util.translate("scripts", "Las pruebas del proyecto seleccionado se actualizaron correctamente en el repositorio"));
	sys.processEvents();
}

/** \D Crea una funcionalidad en el repositorio
\end */
function oficial_crearPro(codFuncional:String) 
{
	if (this.iface.funcionalidadExiste(codFuncional)) {
		MessageBox.warning(this.iface.util.translate("scripts", "El proyecto seleccionado ya existe en el repositorio"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	
	var res:Number = MessageBox.warning(this.iface.util.translate("scripts", "Va a crear en el repositorio el proyecto ") + codFuncional, MessageBox.Yes, MessageBox.No);
	if (res != MessageBox.Yes)
		return;
	
	var comando:String = "svn mkdir " + this.iface.urlRepositorioFun + "tronco/" + codFuncional + " -m AUTO_CREACION_" + codFuncional;
	var resComando:Array = flmaveppal.iface.pub_ejecutarComando(comando);
	if (resComando.ok == false) {
		flmaveppal.iface.pub_log.child("log").append(this.iface.util.translate("scripts", "Error al crear el proyecto en el repositorio"));
		return;
	}
	
	comando = "svn mkdir " + this.iface.urlRepositorioFun + "tronco/" + codFuncional + "/tronco -m AUTO_CREACION_" + codFuncional;
	resComando = flmaveppal.iface.pub_ejecutarComando(comando);
	if (resComando.ok == false) {
		flmaveppal.iface.pub_log.child("log").append(this.iface.util.translate("scripts", "Error al crear el proyecto en el repositorio"));
		return;
	}
	
	comando = "svn mkdir " + this.iface.urlRepositorioFun + "tronco/" + codFuncional + "/tronco/test -m AUTO_CREACION_" + codFuncional;
	resComando = flmaveppal.iface.pub_ejecutarComando(comando);
	if (resComando.ok == false) {
		flmaveppal.iface.pub_log.child("log").append(this.iface.util.translate("scripts", "Error al crear el proyecto en el repositorio"));
		return;
	}
	
	flmaveppal.iface.pub_log.child("log").append(this.iface.util.translate("scripts", "El proyecto seleccionado se creó correctamente en el repositorio"));
	sys.processEvents();
}

/** \D Comprueba si una determinado proyecto existe o no en el repositorio

@param	codFuncional: funcionalidad
@return	True si la funcionalidad existe, false en caso contrario
\end */
function oficial_funcionalidadExiste(codFuncional:String):Boolean
{
	var util:FLUtil = new FLUtil;
	var comando:String = "svn ls " + this.iface.urlRepositorioFun + "tronco/" + codFuncional;
	var resComando:Array = flmaveppal.iface.pub_ejecutarComando(comando);
	return resComando.ok;
}

/** \D Obtiene el proyecto del repositorio.
@param	codFuncional: funcionalidad
\end */
function oficial_bajarPro(codFuncional:String)
{
	var util:FLUtil = new FLUtil;
	if (!this.iface.funcionalidadExiste(codFuncional)) {
		return;
	}
	
	var directorio:String = util.sqlSelect("mv_funcional", "nombreproyecto", "codfuncional = '" + codFuncional + "'");
	if (!directorio || directorio == "") {
		MessageBox.warning(util.translate("scripts", "Debe establecer el nombre del proyecto donde generar el directorio 'modulos'"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}

	Dir.current = flmaveppal.iface.pathLocal;
	if (!File.exists(directorio)) {
		var resComando:Array = flmaveppal.iface.pub_ejecutarComando("mkdir " + directorio);
		if (resComando.ok == false) {
			flmaveppal.iface.pub_log.child("log").append("Error mkdir arbol");
			return;
		}
	}
	
	if (!this.iface.generarDirModulos(codFuncional, directorio)) {
		flmaveppal.iface.pub_log.child("log").append("Error al generar el directorio 'modulos'");
		return;
	}
	
// 	if (!flmaveppal.iface.pub_checkoutParche(codFuncional, codFuncional + "/" + codFuncional)) {
// 		flmaveppal.iface.pub_log.child("log").append("Error al obtener las pruebas del proyecto " + codFuncional);
// 		return false;
// 	}

	resComando = flmaveppal.iface.pub_ejecutarComando("rm -rf " + flmaveppal.iface.pathLocal + "/" + directorio + "/temp");
	if (resComando.ok == false) {
		flmaveppal.iface.pub_log.child("log").append("Error al borrar el directorio temporal");
		return false;
	}
	if (!flmaveppal.iface.pub_checkoutParche(codFuncional, directorio + "/temp")) {
		flmaveppal.iface.pub_log.child("log").append("Error al obtener el parche " + codFuncional);
		return false;
	}
	if (!flmaveppal.iface.pub_aplicarParche(codFuncional, directorio + "/temp", directorio + "/modulos")) {
		flmaveppal.iface.pub_log.child("log").append("Error al aplicar el parche " + codFuncional);
		return false;
	}
	
	flmaveppal.iface.pub_log.child("log").append(this.iface.util.translate("scripts", "El proyecto seleccionado ha sido obtenido correctamente"));
	sys.processEvents();
}


/** \D Crea el directorio modulos como el total de los módulos afectados más los parches de las funcionalidades que componen el proyecto

@param	codFuncional: Funcionalidad
@param	directorio: Directorio donde está el directorio módulos.
@return	True si no hay error, false en caso contrario
\end */
function oficial_generarDirModulos(codFuncional:String, directorio:String):Boolean
{
	var util:FLUtil = new FLUtil;
	var versionBase:String = util.sqlSelect("mv_funcional", "versionbase", "codfuncional = '" + codFuncional + "'");

	var resComando:Array = flmaveppal.iface.pub_ejecutarComando("rm -rf " + directorio + "/modulos ");
	if (resComando.ok == false) {
		return;
	}
	
	var resComando:Array = flmaveppal.iface.pub_ejecutarComando("rm -rf " + directorio + "/test ");
	if (resComando.ok == false) {
		return;
	}
	
	var resComando:Array = flmaveppal.iface.pub_ejecutarComando("rm -rf " + directorio + "/config ");
	if (resComando.ok == false) {
		return;
	}
	
	resComando = flmaveppal.iface.pub_ejecutarComando("mkdir " + directorio + "/modulos ");
	if (resComando.ok == false) {
		flmaveppal.iface.pub_log.child("log").append("Error mkdir arbol");
		return;
	}
	
	if (!File.exists(directorio + "/doc")) {
		resComando = flmaveppal.iface.pub_ejecutarComando("mkdir " + directorio + "/doc");
		if (resComando.ok == false) {
			flmaveppal.iface.pub_log.child("log").append("Error mkdir árbol");
			return;
		}
	}
	resComando = flmaveppal.iface.pub_ejecutarComando("mkdir " + directorio + "/config");
	if (resComando.ok == false) {
		flmaveppal.iface.pub_log.child("log").append("Error mkdir árbol");
		return;
	}
	
	if (!flmaveppal.iface.pub_checkoutMods(codFuncional, directorio, "modulos", versionBase)) {
		flmaveppal.iface.pub_log.child("log").append("Error al obtener los módulos afectados por la funcionalidad " + codFuncional);
		return false;
	}
	
	var listaDep:Array = flmaveppal.iface.pub_obtenerListaDep(codFuncional);
	if (!listaDep) {
		flmaveppal.iface.pub_log.child("log").append("Error al obtener la lista de dependencias de " + codFuncional);
		return false;
	}
	
	for (var i:Number = 0; i < listaDep.length; i++) {
		resComando = flmaveppal.iface.pub_ejecutarComando("rm -rf " + flmaveppal.iface.pathLocal + "/" + directorio + "/temp");
		if (resComando.ok == false) {
			flmaveppal.iface.pub_log.child("log").append("Error al borrar el directorio temporal");
			return false;
		}
		if (!flmaveppal.iface.pub_checkoutMods(listaDep[i], directorio, "modulos", versionBase)) {
			flmaveppal.iface.pub_log.child("log").append("Error al obtener los módulos de la funcionalidad " + listaDep[i]);
			return false;
		}
		if (!flmaveppal.iface.pub_checkoutParche(listaDep[i], directorio + "/temp", versionBase)) {
			flmaveppal.iface.pub_log.child("log").append("Error al obtener el parche " + listaDep[i]);
			return false;
		}
		if (!flmaveppal.iface.pub_aplicarParche(listaDep[i], directorio + "/temp", directorio + "/modulos")) {
			flmaveppal.iface.pub_log.child("log").append("Error al aplicar el parche " + listaDep[i]);
			return false;
		}
// 		if (!flmaveppal.iface.pub_anadirTest(directorio + "/temp", codFuncional)) {
// 			flmaveppal.iface.pub_log.child("log").append("Error al añadir las pruebas de " + listaDep[i]);
// 			return false;
// 		}
// 		if (!flmaveppal.iface.pub_anadirAConfig(listaDep[i], codFuncional)) {
// 			flmaveppal.iface.pub_log.child("log").append("Error al añadir la funcionalidad " + listaDep[i] + " al fichero de configuración del proyecto");
// 			return false;
// 		}
	}
	
	return true;
}

function oficial_calcularPeso() 
{
	var f:Object = new FLFormSearchDB("mv_pesoparche");
	var cursor:FLSqlCursor = f.cursor();

	cursor.select();
	if (!cursor.first())
		cursor.setModeAccess(cursor.Insert);
	else
		cursor.setModeAccess(cursor.Edit);
	f.setMainWidget();
	
	cursor.refreshBuffer();
	f.exec("id");
}

/** \D Exporta el proyecto a un directorio externo
@param	codFuncional: funcionalidad
\end */
function oficial_exportarPro(codFuncional:String) 
{
	var util:FLUtil = new FLUtil;
	var directorio:String = util.sqlSelect("mv_funcional", "nombreproyecto", "codfuncional = '" + codFuncional + "'");

	var pathDirOrigen:String = flmaveppal.iface.pathLocal + "/" + directorio + "/modulos";
	if (!File.exists(pathDirOrigen)) {
		MessageBox(util.translate("scripts", "No existe el directorio modulos de origen"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	
	var pathDirDestino:String = FileDialog.getExistingDirectory();
	if (!pathDirDestino) {
		return false;
	}
	flmaveppal.iface.pub_log.child("log").append("Exportando proyecto...");
	
	var shell:String = "rm -rf $HOME/tmp/tmpExportPro \n" + 
		"cp -rf $1 $HOME/tmp/tmpExportPro \n" + 
		"rm -rf $(find $HOME/tmp/tmpExportPro -name .svn) \n" +
		"cp -rf $HOME/tmp/tmpExportPro/* $2 \n";
		
	File.write(this.iface.pathLocal + "export.sh", shell);
	comando = "chmod 777 " + this.iface.pathLocal + "export.sh";
	resComando = flmaveppal.iface.pub_ejecutarComando(comando);
	if (resComando.ok == false) {
		return;
	}
	comando = this.iface.pathLocal + "export.sh " + pathDirOrigen + " " + pathDirDestino;
	resComando = flmaveppal.iface.pub_ejecutarComando(comando);
	if (resComando.ok == false) {
		return;
	}
	/*
	var comando:String = "cp -rf " + pathDirOrigen + " " + pathDirDestino";
	var resComando:Array = flmaveppal.iface.pub_ejecutarComando(comando);
	if (resComando.ok == false) {
		flmaveppal.iface.pub_log.child("log").append(this.iface.util.translate("scripts", "Error al exportar el proyecto"));
		return;
	}
	flmaveppal.iface.pub_log.child("log").append("Ok");
	
	flmaveppal.iface.pub_log.child("log").append("Procesando proyecto...");
	comando = "rm -rf $(find " + flmaveppal.iface.pathLocal + "tmpExportMod -name .svn)";
	resComando = flmaveppal.iface.pub_ejecutarComando(comando);
	if (resComando.ok == false) {
		flmaveppal.iface.pub_log.child("log").append(this.iface.util.translate("scripts", "Error al borrar los archivos .svn en el directorio tmpExportMod"));
		return;
	}
	flmaveppal.iface.pub_log.child("log").append("Ok");
	
	flmaveppal.iface.pub_log.child("log").append("Escribiendo proyecto...");
	comando = "cp -rf " + flmaveppal.iface.pathLocal + "tmpExportMod/* " + pathDirDestino;
	resComando = flmaveppal.iface.pub_ejecutarComando(comando);
	if (resComando.ok == false) {
		flmaveppal.iface.pub_log.child("log").append(this.iface.util.translate("scripts", "Error al copiar el proyecto a " + pathDirDestino));
		return;
	}
	flmaveppal.iface.pub_log.child("log").append("Ok");
	
	flmaveppal.iface.pub_log.child("log").append("Eliminando archivos temporales...");
	comando = "rm -rf " + flmaveppal.iface.pathLocal + "dtmpExportMod";
	resComando = flmaveppal.iface.pub_ejecutarComando(comando);
	if (resComando.ok == false) {
		flmaveppal.iface.pub_log.child("log").append(this.iface.util.translate("scripts", "Error al eliminar el directorio tmpExportMod"));
		return;
	}
	flmaveppal.iface.pub_log.child("log").append("Ok");
	*/
	flmaveppal.iface.pub_log.child("log").append("El proyecto ha sido exportado correctamente");
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////