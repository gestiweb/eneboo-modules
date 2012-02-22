/***************************************************************************
                 se_enviossw.qs  -  description
                             -------------------
    begin                : lun jun 21 2005
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
////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

/** @class_declaration interna */
//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
class interna {
    var ctx:Object;
    function interna( context ) { this.ctx = context; }
    function init() {
		this.ctx.interna_init();
	}
	function calculateField(fN:String):String {
		return this.ctx.interna_calculateField(fN);
	}
	function validateForm():Boolean {
		return this.ctx.interna_validateForm();
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var rutaSer:String;
	var adjuntos:String;
	var listaModulos:String;
	var revision:String;
 	var proceso:FLProcess;
 	var procesoMail:FLProcess;
 	var padre:String;
    function oficial( context ) { interna( context ); } 
	function bufferChanged(fN:String) {	return this.ctx.oficial_bufferChanged(fN); }
    function actualizarLista() { return this.ctx.oficial_actualizarLista(); }
	function enviarMail() { return this.ctx.oficial_enviarMail(); }
	function procesar() { return this.ctx.oficial_procesar(); }
	function crearPaquetes() { return this.ctx.oficial_crearPaquetes(); }
	function obtenerRevision():String { return this.ctx.oficial_obtenerRevision(); }
	function actualizarDatosEnvio() { return this.ctx.oficial_actualizarDatosEnvio(); }
	function mailEnviado() { return this.ctx.oficial_mailEnviado(); }
	function generarComunicacion() { this.ctx.oficial_generarComunicacion(); }	
	function crearListaModulos() { this.ctx.oficial_crearListaModulos(); }	
	function anadirUnRegistro() { this.ctx.oficial_anadirUnRegistro(); }
	function eliminarUnRegistro() { this.ctx.oficial_eliminarUnRegistro(); }
	function anadirTodos() { this.ctx.oficial_anadirTodos(); }
	function eliminarTodos() { this.ctx.oficial_eliminarTodos(); }
	function refrescarTablas() { this.ctx.oficial_refrescarTablas(); }
	function insertarPlantillaTexto() { return this.ctx.oficial_insertarPlantillaTexto(); }
	function selecDestinatario() { return this.ctx.oficial_selecDestinatario(); }
	function ejecutarComando(comando:Array, mensaje:String):Array {
		return this.ctx.oficial_ejecutarComando(comando, mensaje);
	}
	function filtroIncidencia():String {
		return this.ctx.oficial_filtroIncidencia();
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

/** \C
Para los nuevos envíos el cliente debe establecerse según el --codsubproyecto--, 
--codincidencia-- o --idpactualizacion-- al que pertenece el envío

Para los nuevos envíos, el --codencargado-- por defecto será el que esté definido en las
preferencias

El --codcliente-- no podrá ser modificado

Un envío sólo deberá crearse a partir de un subproyecto, incidencia o período de actualización

Para las nuevas incidencias, el valor del --codencargado-- será el que conste en 
las opciones generales

\end */
function interna_init()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	
	if (cursor.modeAccess() == cursor.Insert) {
		var curRel:FLSqlCursor = cursor.cursorRelation();
		switch (curRel.table()) {
			case "se_incidencias": {
				this.child("fdbCodCliente").setValue(curRel.valueBuffer("codcliente"));
				this.child("fdbCodProyecto").setValue(curRel.valueBuffer("codproyecto"));
				this.child("fdbCodSubproyecto").setValue(curRel.valueBuffer("codsubproyecto"));
				this.child("fdbPara").setValue(util.sqlSelect("clientes", "email", "codcliente = '" + this.child("fdbCodCliente").value() + "'"));
				break;
			}
			case "se_subproyectos": {
				this.child("fdbCodProyecto").setValue(curRel.valueBuffer("codproyecto"));
				this.child("fdbCodCliente").setValue(curRel.valueBuffer("codcliente"));
				this.child("fdbCodCliente").setDisabled(true);
				this.child("fdbPara").setValue(util.sqlSelect("clientes", "email", "codcliente = '" + this.child("fdbCodCliente").value() + "'"));
				break;
			}
			case "se_proyectos": {
				this.child("fdbCodCliente").setValue(curRel.valueBuffer("codcliente"));
				this.child("fdbCodCliente").setDisabled(true);
				this.child("fdbPara").setValue(util.sqlSelect("clientes", "email", "codcliente = '" + this.child("fdbCodCliente").value() + "'"));
				break;
			}
		}
	}
	
	connect(this.child("pbnActualizarLista"), "clicked()", this, "iface.actualizarLista");
	connect(this.child("pbnProcesar"), "clicked()", this, "iface.procesar");
	connect(this.child("pbnAnadir"), "clicked()", this, "iface.anadirUnRegistro");
	connect(this.child("pbnEliminar"), "clicked()", this, "iface.eliminarUnRegistro");
	connect(this.child("pbnAnadirTodos"), "clicked()", this, "iface.anadirTodos");
	connect(this.child("pbnEliminarTodos"), "clicked()", this, "iface.eliminarTodos");
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect( this.child("pbnInsertarPlantillaTexto"), "clicked()", this, "iface.insertarPlantillaTexto()" );
	connect( this.child("pbnSelecDestinatario"), "clicked()", this,"iface.selecDestinatario()");
	
// 	this.child("gbxTipoEnvio").setDisabled(true);
	this.child("fdbRevision").setDisabled(true);
	this.child("fdbCodIncidencia").setFilter(this.iface.filtroIncidencia());
	
	this.child("fdbEnviarNot").setDisabled(false);
	if (cursor.valueBuffer("accion") == "Envio de modulos") {
		this.child("fdbEnviarNot").setDisabled(true);
		this.child("fdbEnviarNot").setValue(true);
	}
	
	if (cursor.valueBuffer("estado") == "Completado"){
		this.child("pbnProcesar").setDisabled(true);
		this.child("pbnEliminar").setDisabled(true);
		this.child("pbnAnadir").setDisabled(true);
		this.child("pbnAnadirTodos").setDisabled(true);
		this.child("pbnEliminarTodos").setDisabled(true);
	}
	
	this.iface.rutaSer = util.readSettingEntry("scripts/flservppal/dirServicios");
	
	this.iface.refrescarTablas();
}

function interna_calculateField(fN:String):String
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var valor:String;

	switch (fN) {
		/** \D El --codcliente-- se hereda del documento del que proviene el envío (subproyecto,incidencia,actualización)
		*/
		case "codcliente": {
			var codSubproyecto:String = this.cursor().valueBuffer("codsubproyecto");
			var codIncidencia:String = this.child("fdbCodIncidencia").value();
			var idPActualizacion:Number = this.cursor().valueBuffer("idpactualizacion");
			var codCliente:String;
			
			if (codSubproyecto) {
				valor = util.sqlSelect("se_subproyectos", "codcliente", "codigo = '" + codSubproyecto + "'")
			}
			
			if (codIncidencia) {
				valor = util.sqlSelect("se_incidencias", "codcliente", "codigo = '" + codIncidencia + "'")
			}
			
			if (idPActualizacion) {
				valor = util.sqlSelect("se_pactualizacion", "codcliente", "id = '" + idPActualizacion + "'")
			}
			break;
		}
	}
	return valor;
}

function interna_validateForm():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var codIncidencia:String = cursor.valueBuffer("codincidencia");
	if (codIncidencia && codIncidencia != "") {
		var filtro:String = this.iface.filtroIncidencia();
		if (!util.sqlSelect("se_incidencias", "codigo", filtro + " AND codigo = '" + codIncidencia + "'")) {
			MessageBox.warning(util.translate("scripts", "La incidencia indicada no concuerda con los valores de cliente, proyecto y subproyecto"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}
	return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_bufferChanged(fN:String)
{ 
	var cursor:FLSqlCursor = this.cursor();
	
	switch (fN) {
/** \C Cuando --accion-- es 'Envio de modulos' se deshabilita --enviarnot--
y se establece a verdadero
*/
		case "accion": {
			this.child("fdbEnviarNot").setDisabled(false);
			if (cursor.valueBuffer("accion") == "Envio de modulos") {
				this.child("fdbEnviarNot").setDisabled(true);
				this.child("fdbEnviarNot").setValue(true);
			}
			break;
		}
		case "codcliente":
		case "codproyecto":
		case "codsubroyecto": {
			this.child("fdbCodIncidencia").setFilter(this.iface.filtroIncidencia());
			break;
		}
/** \C Cuando --estado-- es 'Completado' se deshabilitan los botones de procesar
módulos y establecer la lista de módulos
*/
		case "estado": {
			if (cursor.valueBuffer("estado") == "Completado") {
				this.child("pbnProcesar").setDisabled(true);
				this.child("pbnEliminar").setDisabled(true);
				this.child("pbnAnadir").setDisabled(true);
				this.child("pbnAnadirTodos").setDisabled(true);
				this.child("pbnEliminarTodos").setDisabled(true);
			}
			else {
				this.child("pbnProcesar").setDisabled(false);
				this.child("pbnEliminar").setDisabled(false);
				this.child("pbnAnadir").setDisabled(false);
				this.child("pbnAnadirTodos").setDisabled(false);
				this.child("pbnEliminarTodos").setDisabled(false);
			}
			break;
		}
	}
}

/** \D Actualiza la lista de módulos que hay en disco y los introduce en la tabla de datos. Hace una pasada por los directorios desde el directorio de los módulos
\end */
function oficial_actualizarLista()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	if (cursor.modeAccess() == cursor.Insert) {
		var curES:FLSqlCursor = this.child("tdbModulosES").cursor();
		if (!curES.commitBufferCursorRelation()) {
			return false;
		}
	}
	
	var idEnvio:Number = this.cursor().valueBuffer("id");
	var curModulosES:FLSqlCursor = new FLSqlCursor("se_moduloses");
	var curModulos:FLSqlCursor = new FLSqlCursor("se_modulos");
	
	var codProyecto:String = cursor.valueBuffer("codproyecto");
	
	curModulosES.select("idenvio = " + idEnvio);
	while (curModulosES.next()) {
		curModulosES.setModeAccess(curModulosES.Del);
		curModulosES.refreshBuffer();
		if (!curModulosES.commitBuffer()) {
			return false;
		}
	}
	
	curModulos.select("codproyecto = '" + codProyecto + "'");
	
	while (curModulos.next()) {
		curModulosES.setModeAccess(curModulosES.Insert);
		curModulosES.refreshBuffer();
		curModulosES.setValueBuffer("idenvio", idEnvio);
		curModulosES.setValueBuffer("idmodulo", curModulos.valueBuffer("idmodulo"));
		curModulosES.setValueBuffer("idarea", curModulos.valueBuffer("idarea"));
		if (!curModulosES.commitBuffer()) {
			return false;
		}
	}
	
	this.child("tdbModulos").refresh();
}


/** \D Lanza el proceso del envío de software.
\end */
function oficial_procesar()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	
	var codProyecto:String = cursor.valueBuffer("codproyecto");
	
	this.iface.revision = this.iface.obtenerRevision();
	this.iface.crearListaModulos();
	
	if (cursor.valueBuffer("accion") == "Envio de modulos") {
		this.iface.crearPaquetes();
		return;
	}
	
	if (cursor.valueBuffer("enviarnot")) {
		this.iface.adjuntos = "";
		this.iface.enviarMail();
		return;
	}
	
	var util:FLUtil = new FLUtil();
	var res = MessageBox.information(util.translate("scripts", "Con los actuales parámetros no se generará una comunicación.\nPulse aceptar para actualizar la revisión y guardar los cambios"), MessageBox.Ok, MessageBox.Cancel);
	
	if (res != MessageBox.Ok) {
		return;
	}
	
	this.iface.actualizarDatosEnvio();
	this.accept();
}

/** \D Crea los paquetes con los módulos de la lista para enviarlos después.
Los paquetes tienen formato .tar.gz y se guardan el el directorio 'packets'
del módulo de servicios
\end */
function oficial_crearPaquetes()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var dirModulos:String;
	var rutaModulos:String = util.readSettingEntry("scripts/flservppal/dirMantVer");
	
	var codProyecto:String = cursor.valueBuffer("codproyecto");
	
	dirModulos = util.sqlSelect("se_proyectos", "codfuncional", "codigo = '" + codProyecto + "'");
	
	if (File.exists(rutaModulos + dirModulos + "/modulos/")) {
		rutaModulos = rutaModulos + dirModulos + "/modulos/";
	} else {
		rutaModulos = rutaModulos + dirModulos + "/prueba/";
	}
	
	if (!File.isDir(rutaModulos)) {
		MessageBox.critical(util.translate("scripts", "La ruta a los módulos no es correcta:\n%1").arg(rutaModulos), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	
	var comando:String = "cd " + rutaModulos + "; ";
	
	this.iface.adjuntos = "";
	var area, modulo:String;

	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList("se_moduloses");
	q.setFrom("se_moduloses");
	q.setSelect("idarea,idmodulo");
	q.setWhere("idenvio = " + cursor.valueBuffer("id"));
	
	if (!q.exec()) {
		return;
	}
	while (q.next()) {
		area = q.value(0);
		modulo = q.value(1);
		
		comando += 
				" tar --exclude .svn -cf " + area + "_" + modulo + ".tar " + area + "/" + modulo + ";" +
				" gzip " + area + "_" + modulo +  ".tar;" +
				" mv -f " + area + "_" + modulo +  ".tar.gz " + this.iface.rutaSer + "principal/packets/;"
		
		this.iface.adjuntos += " --attach " + this.iface.rutaSer + "principal/packets/" + area + "_" + modulo + ".tar.gz";
	}

	var fichProceso = this.iface.rutaSer + "principal/packets/comandomail";
	var f = new File(fichProceso);
	f.open(File.WriteOnly);
	f.write(comando);
	f.close();
	
	this.setDisabled( true );

	this.iface.proceso = new FLProcess(fichProceso);
	connect(this.iface.proceso, "exited()", this, "iface.enviarMail");
	this.iface.proceso.start();
}

/** \D Crea los textos de asunto, cuerpo y destino para llamar
al comando kmail y enviar el correo
\end */
function oficial_enviarMail()
{
	var util:FLUtil = new FLUtil();
	
	var codSubproyecto:String = this.cursor().valueBuffer("codsubproyecto");
	var asunto:String = "\"Módulos AbanQ - Subproyecto " + codSubproyecto + " (revision " + this.iface.revision + ")\"";
	
	var cuerpo:String = this.cursor().valueBuffer("texto");
	var patternRE:RegExp = new RegExp("\"");
	patternRE.global = true;
	cuerpo = cuerpo.replace(patternRE, "'");
	cuerpo += "\n\n\n_________________________________________\n\n";
	
	if (this.cursor().valueBuffer("accion") == "Envio de modulos")
		cuerpo += "Módulos adjuntos:\n\n" + this.iface.listaModulos;
	
	if (this.cursor().valueBuffer("accion") == "Actualizacion remota")
		cuerpo += "Módulos actualizados remotamente:\n\n" + this.iface.listaModulos;
	
	if (this.cursor().valueBuffer("accion") == "Descarga de repositorio")
		cuerpo += "Módulos a descargar del repositorio:\n\n" + this.iface.listaModulos;
	
	cuerpo += "\nRevisión de los módulos: " + this.iface.revision;
	cuerpo += "\n_________________________________________\n\n\n\nUn saludo,";
	
	cuerpo = "\"" + cuerpo + "\"";
	
	var destinatario:String = this.cursor().valueBuffer("para");
		
	var comando:String = flservppal.iface.pub_componerCorreo(destinatario, asunto, cuerpo, this.iface.adjuntos);

//  	var comando:String =  
// 			"kmail " +
// 			destinatario +
// 			" -s " + asunto +
// 			" --body " + cuerpo + 
// 			this.iface.adjuntos;

	debug(comando);
	
	var fichProceso = this.iface.rutaSer + "principal/packets/comandomail";
	var f = new File(fichProceso);
	f.open(File.WriteOnly);
	f.write(comando);
	f.close();
	
	this.iface.procesoMail = new FLProcess(fichProceso);
 	connect(this.iface.procesoMail, "exited()", this, "iface.mailEnviado");
   	this.iface.procesoMail.start();
}


/** \D Una vez enviado el mail, arranca la actualización del envío
y la generación de la comunicación
\end */
function oficial_mailEnviado()
{
	var util:FLUtil = new FLUtil();
	var res = MessageBox.information(util.translate("scripts", "Pulse \"Aceptar\" DESPUÉS de enviar el mensaje correctamente\nEsto generará un registro de comunicación"), MessageBox.Ok, MessageBox.Cancel);
	
	this.setDisabled( false );
	
	if (res == MessageBox.Ok) {
		this.iface.actualizarDatosEnvio();
		this.iface.generarComunicacion();
		this.accept();
	}
}


/** \D Una vez enviado el mail, actualiza los valores de --revision--, --fecha--,
--hora-- y --estado--
\end */
function oficial_actualizarDatosEnvio()
{
	var cursor:FLSqlCursor = this.cursor();
	var hoy = new Date();
	var ahora:String = hoy.toString().mid(11, 5);
	cursor.setValueBuffer("revision", this.iface.revision);
	cursor.setValueBuffer("fecha", hoy);
	cursor.setValueBuffer("hora", ahora);
	cursor.setValueBuffer("estado", "Completado");
}


/** \D Obtiene la revisión de los módulos que van a ser enviados
@return Código de la revisión
\end */
function oficial_obtenerRevision():String
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var revision:String;
	var codProyecto:String = cursor.valueBuffer("codproyecto");
	if (!codProyecto && !idPActualizacion) {
		MessageBox.critical(util.translate("scripts", "Este envío no pertenece a ningún proyecto"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var rutaModulos = util.readSettingEntry("scripts/flservppal/dirMantVer");
	var dirModulos:String;
	
	if (codProyecto) {
		dirModulos = util.sqlSelect("se_proyectos", "codfuncional", "codigo = '" + codProyecto + "'");
	}
	
	var esFuncional:Boolean = false;
	if (File.exists(rutaModulos + dirModulos + "/modulos/")) {
		rutaModulos = rutaModulos + dirModulos + "/temp/";
	} else { // Parche 
		esFuncional = true;
		rutaModulos = rutaModulos + dirModulos + "/" + dirModulos;
	}

	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList("se_moduloses");
	q.setFrom("se_moduloses");
	q.setSelect("idarea,idmodulo");
	q.setWhere("idenvio = " + this.cursor().valueBuffer("id"));
	
	if (!q.exec()) {
		MessageBox.critical(util.translate("scripts", "\nFalló la consulta de búsqueda de revisión"),
		MessageBox.Ok, MessageBox.Cancel, MessageBox.NoButton);
		return false;
	}
	if (!q.first())  {
		MessageBox.critical(util.translate("scripts", "\nNo hay módulos el la lista para obtener la revisión"),
		MessageBox.Ok, MessageBox.Cancel, MessageBox.NoButton);
		return false;
	}
	
	var dirModulo:String;
	if (esFuncional) {
		dirModulo = rutaModulos;
	} else {
		dirModulo = rutaModulos; // + q.value(0) + "/" + q.value(1);
	}
	
	var comando:Array = ["svn", "info", dirModulo];
	var res:Array = this.iface.ejecutarComando(comando);
	if (res["ok"] == false) {
		MessageBox.critical(util.translate("scripts", "Error al buscar la revisión de los módulos"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var info:String = res["salida"];
	var iRevision:Number = info.find("Revisión: ");
	var iFinRevision:Number;
	if (iRevision >= 0) {
		iFinRevision = info.find("\n", iRevision);
		debug(iFinRevision);
	}
	revision = info.substring(iRevision + 10, iFinRevision);
	return revision;
}

/** \D
Ejecuta un comando externo
@param	comando: Comando a ejecutar
@param	mensaje: Mensaje a mostrar en un diálogo de progreso mientras se ejecuta el comando
@return	Array con dos datos: 
	ok: True si no hay error, false en caso contrario
	salida: Mensaje de stdout o stderr obtenido
\end */
function oficial_ejecutarComando(comando:Array, mensaje:String):Array
{
	var util:FLUtil = new FLUtil;
	var tMax:Number = 25000;
	var res:Array = [];
	res["ok"] = false;

	var p = new Process();
	p.arguments = comando;
debug(p.arguments);

	try {
		p.start();
	} catch (e) {
debug(p.readStderr());
		MessageBox.warning(util.translate("scripts", "Error al iniciar el proceso %1:\n").arg(comando) + e, MessageBox.Ok, MessageBox.NoButton);
		return res;
	}
	var inicio:Date = new Date;
	var ahora:Date;
	var mSegundos:Number = 0;
	
	while (p.running && mSegundos < tMax) {
		ahora = new Date;
		mSegundos = ahora.getTime() - inicio.getTime();
	}
	if (mSegundos >= tMax) {
		MessageBox.warning(util.translate("scripts", "Se ha superado el tiempo máximo para ejecutar el comando %1").arg(comando), MessageBox.Ok, MessageBox.NoButton);
		return res;
	}
	res["ok"] = true;
	res["salida"] = p.readStdout();
	return res;
}

function oficial_filtroIncidencia():String
{
	var cursor:FLSqlCursor = this.cursor();

	var filtro:String = "";
	var codCliente:String = cursor.valueBuffer("codcliente");
	var codProyecto:String = cursor.valueBuffer("codproyecto");
	var codSubproyecto:String = cursor.valueBuffer("codsubproyecto");

	if (codSubproyecto && codSubproyecto != "") {
		filtro = "codsubproyecto = '" + codSubproyecto + "'";
	} else if (codProyecto && codProyecto != "") {
		filtro = "codproyecto = '" + codProyecto + "'";
	} else if (codCliente && codCliente != "") {
		filtro = "codcliente = '" + codCliente + "'";
	}
	return filtro;
}



/** \D Genera el registro de comunicación asociado al envío
\end */
function oficial_generarComunicacion()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();	
	
	if (cursor.valueBuffer("estado") != "Completado") {
		return;
	}
	
	var curCom:FLSqlCursor = new FLSqlCursor("se_comunicaciones");
	var codComunicacion:String = cursor.valueBuffer("codcomunicacion");
	var enviadoPor:String = util.sqlSelect("se_usuarios", "nombre", "codigo ='" + util.readSettingEntry("scripts/flservppal/codusuario") +  "'");
	var para:String = util.sqlSelect("clientes", "email", "codcliente = '" + this.child("fdbCodCliente").value() + "'");
	
	codComunicacion = util.nextCounter("codigo", curCom );
	cursor.setValueBuffer("codcomunicacion", codComunicacion);
	
	curCom.setModeAccess(curCom.Insert);
	curCom.refreshBuffer();
	curCom.setValueBuffer("codigo", codComunicacion);
	curCom.setValueBuffer("fecha", cursor.valueBuffer("fecha"));
	curCom.setValueBuffer("hora", cursor.valueBuffer("hora"));
	curCom.setValueBuffer("asunto", "Personalización de AbanQ (revision " + cursor.valueBuffer("revision") + ")");
	curCom.setValueBuffer("texto", "ENVIO DE SW: " + cursor.valueBuffer("texto"));
	curCom.setValueBuffer("codcliente", cursor.valueBuffer("codcliente"));
	curCom.setValueBuffer("idpactualizacion", cursor.valueBuffer("idpactualizacion"));
	curCom.setValueBuffer("codproyecto", cursor.valueBuffer("codproyecto"));
	curCom.setValueBuffer("codsubproyecto", cursor.valueBuffer("codsubproyecto"));
	curCom.setValueBuffer("codincidencia", cursor.valueBuffer("codincidencia"));
	curCom.setValueBuffer("enviadopor", enviadoPor);
	curCom.setValueBuffer("para", para);
	curCom.setValueBuffer("estado", "Enviado");
	curCom.commitBuffer();
	
	return true;
}

/** \D Crea un string con la lista de módulos enviados, para ser incluida en
el cuerpo del mensaje
\end */
function oficial_crearListaModulos()
{
	this.iface.listaModulos = "";
	
	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList("se_moduloses");
	q.setFrom("se_moduloses");
	q.setSelect("idarea, idmodulo");
	q.setWhere("idenvio = " + this.cursor().valueBuffer("id"));
	
	if (!q.exec()) {
		return false;
	}
	while(q.next()) {
		this.iface.listaModulos += "   Area " + q.value("idarea") + " - Módulo " + q.value("idmodulo") + "\n";
	}
}

/** \D Añade el módulo seleccionado de la lista de módulos existentes a la lista de módulos a enviar
\end */
function oficial_anadirUnRegistro()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	if (cursor.modeAccess() == cursor.Insert) {
		var curES:FLSqlCursor = this.child("tdbModulosES").cursor();
		if (!curES.commitBufferCursorRelation()) {
			return false;
		}
	}
	
	var curModulos:FLSqlCursor = this.child("tdbModulos").cursor()
	if (!curModulos.isValid()) {
		return false;
	}
	var idModulo:String = curModulos.valueBuffer("idModulo");
	var idArea:String = curModulos.valueBuffer("idarea");
	var idEnvio:String = cursor.valueBuffer("id");
	
	if (!idModulo) {
		return false;
	}
	
	var curModulosEs:FLSqlCursor = new FLSqlCursor("se_moduloses");
	with (curModulosEs) {
		setModeAccess(curModulosEs.Insert);
		refreshBuffer();
		setValueBuffer("idmodulo", idModulo);
		setValueBuffer("idarea", idArea);
		setValueBuffer("idenvio", idEnvio);
	}
	if (!curModulosEs.commitBuffer()) {
		return false;
	}
	
	this.iface.refrescarTablas();

	return true;
}

/** \D Elimina el módulo seleccionado de la lista de módulos a enviar
\end */
function oficial_eliminarUnRegistro()
{
	var util:FLUtil = new FLUtil();
	
	var curModulosES:FLSqlCursor = this.child("tdbModulosES").cursor()
	var id:String = curModulosES.valueBuffer("id");

	if (!util.sqlDelete("se_moduloses", "id = " + id)) {
debug("!delete en se_moduloses");
		return false;
	}
	
	this.iface.refrescarTablas();
	
	return true;
}

/** \D Añade todos los modulos de la lista de módulos existentes a la lista de módulos a enviar
\end */
function oficial_anadirTodos()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	if (cursor.modeAccess() == cursor.Insert) {
		var curES:FLSqlCursor = this.child("tdbModulosES").cursor();
		if (!curES.commitBufferCursorRelation()) {
			return false;
		}
	}
	
	var curModulosEs:FLSqlCursor = new FLSqlCursor("se_moduloses");
	
	var where:String = "codproyecto = '" + cursor.valueBuffer("codproyecto") + "'";
	
	var qryModulos:FLSqlQuery = new FLSqlQuery();
	qryModulos.setTablesList("se_modulos");
	qryModulos.setSelect("se_modulos.idarea, se_modulos.idmodulo");
	qryModulos.setFrom("se_modulos");
	qryModulos.setWhere(where);
	
	if (!qryModulos.exec()) {
		return false;
	}

	var idEnvio:String = cursor.valueBuffer("id");
	var idModulo:String;
	var idArea:String;
	while (qryModulos.next()) {
		idModulo = qryModulos.value("se_modulos.idmodulo");
		idArea = qryModulos.value("se_modulos.idarea");
		if (util.sqlSelect("se_moduloses", "id", "idenvio = " + idEnvio + " AND idmodulo = '" + idModulo + "' AND idarea = '" + idArea + "'")) {
			continue;
		}
		curModulosEs.setModeAccess(curModulosEs.Insert);
		curModulosEs.refreshBuffer();
		curModulosEs.setValueBuffer("idmodulo", idModulo);
		curModulosEs.setValueBuffer("idarea", idArea);
		curModulosEs.setValueBuffer("idenvio", idEnvio);
		if (!curModulosEs.commitBuffer()) {
			return false;
		}
	}

	this.iface.refrescarTablas();
	
	return true;
}

/** \D Elimina todos los modulos de la lista de módulos a enviar
\end */
function oficial_eliminarTodos()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	if (!util.sqlDelete("se_moduloses", "idenvio = " + cursor.valueBuffer("id"))) {
		return false;
	}
	
	this.iface.refrescarTablas();
	
	return true;
}

/** \D Hace un refresh de las tablas de modulos existentes y modulos a enviar filtrando la de modulos existentes por los modulos de ese subproyecto que no están en la otra tabla
\end */
function oficial_refrescarTablas()
{
	var cursor:FLSqlCursor = this.cursor();

	var codProyecto:String = cursor.valueBuffer("codproyecto");
	var codSubproyecto:String = cursor.valueBuffer("codsubproyecto");
	
	var where:String = "codproyecto = '" + codProyecto + "'";
	
	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList("se_moduloses,se_modulos");
	q.setFrom("se_modulos INNER JOIN se_moduloses ON se_modulos.idmodulo = se_moduloses.idmodulo AND se_modulos.idarea = se_moduloses.idarea");
	q.setSelect("se_modulos.id");
	q.setWhere(where + " AND idenvio = " + cursor.valueBuffer("id"));
	
	if (!q.exec()) {
		return false;
	}
debug(q.sql());
	var lista:String = "";
	while (q.next()) {
		if (lista != "") {
			lista += ",";
		}
		lista += q.value("se_modulos.id");
	}
	
	if (lista != "") {
		this.child("tdbModulos").cursor().setMainFilter("id NOT IN (" + lista + ") AND codproyecto = '" + codProyecto + "'");
	} else {
		this.child("tdbModulos").cursor().setMainFilter("codproyecto = '" + codProyecto + "'");
	}
	this.child("tdbModulosES").cursor().setMainFilter("idenvio = " + cursor.valueBuffer("id"));
	
debug(this.child("tdbModulos").cursor().mainFilter());
	this.child("tdbModulos").refresh();
	this.child("tdbModulosES").refresh();
}

/** \D Carga el texto de una plantilla al final del texto del envio
*/
function oficial_insertarPlantillaTexto() 
{ 
	var util:FLUtil = new FLUtil();
	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList("se_plantillastexto");
	q.setFrom("se_plantillastexto");
	q.setSelect("descripcion,texto");
	q.setWhere("1 = 1");
	
	if (!q.exec()) return;
	
	var dialog = new Dialog(util.translate ( "scripts", "Plantillas" ), 0);
	dialog.caption = "Selecciona la plantilla";
	dialog.OKButtonText = util.translate ( "scripts", "Aceptar" );
	dialog.cancelButtonText = util.translate ( "scripts", "Cancelar" );
	
	var bgroup:GroupBox = new GroupBox;
	dialog.add( bgroup );
	var cB:Array = [];
	var nPlan:Number = 0;
	
	while (q.next())  {
		cB[nPlan] = new RadioButton;
		cB[nPlan].text = util.translate ( "scripts", q.value(0));
		cB[nPlan].checked = false;
		bgroup.add( cB[nPlan] );
		nPlan ++;
	}
	if (nPlan > 0){
		nPlan --;
		if(dialog.exec()) {
			if(!q.first())
				return false;
			for (var i:Number = 0; i <= nPlan; i++){
				if (cB[i].checked == true){
					var texto:String = q.value(1);
					texto = this.cursor().valueBuffer("texto") + "\n\n\n---------------------------------------\n\n" + texto;
					this.cursor().setValueBuffer("texto", texto);
					this.child("txtTexto").text = texto;
					return;
				}
				q.next();
			}
		}
		else
			return;
	}
}

/** \D Busca el destinatario en la tabla de clientes. Cuando hay varios 
contactos en la agenda del cliente permite seleccionar uno de ellos
\end */
function oficial_selecDestinatario()
{
	var util:FLUtil = new FLUtil();
	var arrayMails:Array = [];
	var emailPrincipal:String = util.sqlSelect("clientes", "email", "codcliente = '" + this.child("fdbCodCliente").value() + "'");
	var nombrePrincipal:String = util.sqlSelect("clientes", "nombre", "codcliente = '" + this.child("fdbCodCliente").value() + "'");
			
	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList("contactosclientes,crm_contactos");
	q.setFrom("contactosclientes INNER JOIN crm_contactos ON contactosclientes.codcontacto = crm_contactos.codcontacto");
	q.setSelect("crm_contactos.email,crm_contactos.nombre");
	q.setWhere("contactosclientes.codcliente = '" + this.child("fdbCodCliente").value() + "' AND (crm_contactos.email <> '' AND crm_contactos.email IS NOT NULL)");
	if (!q.exec()) return false;
	debug("***CONSULTA***" + q.sql());
	var dialog = new Dialog(util.translate ( "scripts", "Contactos del cliente" ), 0);
	dialog.caption = "Selecciona el destinatario";
	dialog.OKButtonText = util.translate ( "scripts", "Aceptar" );
	dialog.cancelButtonText = util.translate ( "scripts", "Cancelar" );
	
	var bgroup:GroupBox = new GroupBox;
	dialog.add( bgroup );
	var cB:Array = [];
	var nEmails:Number = 0;	
	
	cB[nEmails] = new CheckBox;
	cB[nEmails].text = util.translate ( "scripts", nombrePrincipal + " (" + emailPrincipal + ")");
	arrayMails[nEmails] = emailPrincipal;
	cB[nEmails].checked = true;
	bgroup.add( cB[nEmails] );
	nEmails ++;
	
	while (q.next())  {
		cB[nEmails] = new CheckBox;
		cB[nEmails].text = util.translate ( "scripts", q.value(1) + " (" + q.value(0) + ")");
		arrayMails[nEmails] = q.value(0);
		cB[nEmails].checked = false;
		bgroup.add( cB[nEmails] );
		nEmails ++;
	}
	if (nEmails > 1){
		nEmails --;
		var lista:String = "";
		if(dialog.exec()) {
			for (var i:Number = 0; i <= nEmails; i++)
				if (cB[i].checked == true)
					lista += arrayMails[i] + ",";
		}
		else
			return;
		lista = lista.left(lista.length -1)
		if (lista == "")
			return;
		this.child("fdbPara").setValue(lista);
	}
	else
		this.child("fdbPara").setValue(emailPrincipal);
	
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
