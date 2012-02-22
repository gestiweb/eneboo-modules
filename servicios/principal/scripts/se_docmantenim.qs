/***************************************************************************
                 se_docespec.qs  -  description
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
    function init() { this.ctx.interna_init(); }
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
	var urlDocumentacion:String;
	var pathLocal:String;
	var codContrato:String;
	var dirContrato:String;
	var rutaSer:String;
	var adjuntos:String;
	var proceso:FLProcess;
	var procesoMail:FLProcess;
	
    function oficial( context ) { interna( context ); } 
	function bufferChanged(fN:String) {	return this.ctx.oficial_bufferChanged(fN); }	
	function pbnPublicar_clicked() { return this.ctx.oficial_pbnPublicar_clicked();	}
	function pbnObtener_clicked() {	return this.ctx.oficial_pbnObtener_clicked();}
	function pbnVisualizar_clicked() { return this.ctx.oficial_pbnVisualizar_clicked();	}
	function pbnEnviar_clicked() { return this.ctx.oficial_pbnEnviar_clicked();	}
	function docPublicada():Boolean {return this.ctx.oficial_docPublicada();}
	function obtenerDoc(dirLocal:String):Boolean { return this.ctx.oficial_obtenerDoc(dirLocal);}
	function enviarMail() {	return this.ctx.oficial_enviarMail();}
	function mailEnviado() { return this.ctx.oficial_mailEnviado();}
    function obtenerRevision():String { return this.ctx.oficial_obtenerRevision(); }
	function insertarPlantillaMensaje() { return this.ctx.oficial_insertarPlantillaMensaje(); }
	function insertarPlantillaContenido() { return this.ctx.oficial_insertarPlantillaContenido(); }
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
El botón Visualizar abrirá un navegador con el documento de especificaciones

El botón Importar abrirá un cuadro de diálogo para la importación de las especificaciones
desde un directorio donde han sido generadas mediante el módulo de documentación hasta el
directorio donde los documentos de especificaciones serán copiados para después ser 
publicados mediante subversion
\end */
function interna_init()
{
	var util:FLUtil = new FLUtil;
	var rutaMantVer:String = util.readSettingEntry("scripts/flservppal/dirMantVer");
	
	this.iface.urlDocumentacion = util.sqlSelect("se_opciones", "urlrepositoriodoc", "1 = 1") + "mantenimientos/";
	
	this.iface.codContrato = this.cursor().valueBuffer("codcontrato");
	if (!this.iface.codContrato) {
		MessageBox.warning(util.translate("scripts", "La documentación debe estar asociada a un repositorio"), MessageBox.Ok, MessageBox.NoButton);
		this.close();
	}
		
	this.iface.dirContrato = util.sqlSelect("se_contratosman", "dirlocal", "codigo = '" + this.iface.codContrato + "'");
	if (!this.iface.dirContrato) {
		MessageBox.warning(util.translate("scripts", "El contrato de mantenimiento debe tener un directorio local asociado"), MessageBox.Ok, MessageBox.NoButton);
		this.close();
	}
	
	this.iface.pathLocal = rutaMantVer + this.iface.dirContrato + "docmantenim/";
	
	var cursor:FLSqlCursor = this.cursor();
	switch (cursor.modeAccess()) {
		case cursor.Insert: {
			this.child("pbnObtener").enabled = false;
			this.child("pbnEnviar").enabled = false;
			break;
		}
		case cursor.Edit: {
			this.child("pbnPublicar").enabled = false;
			break;
		}
		case cursor.Browse: {
			this.child("pbnObtener").enabled = false;
			this.child("pbnPublicar").enabled = false;
			this.child("pbnEnviar").enabled = false;
			break;
		}
	} 
		
	if (cursor.valueBuffer("estado") == "Enviada") {
		this.child("gbxGeneral").setDisabled(true);
		this.child("gbxEnvio").setDisabled(true);
	}
	
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this.child("pbnPublicar"), "clicked()", this, "iface.pbnPublicar_clicked");
	connect(this.child("pbnObtener"), "clicked()", this, "iface.pbnObtener_clicked");
	connect(this.child("pbnVisualizar"), "clicked()", this, "iface.pbnVisualizar_clicked");
	connect(this.child("pbnEnviar"), "clicked()", this, "iface.pbnEnviar_clicked");
	connect( this.child("pbnInsertarPlantillaMensaje"), "clicked()", this, "iface.insertarPlantillaMensaje()" );
	connect( this.child("pbnInsertarPlantillaContenido"), "clicked()", this, "iface.insertarPlantillaContenido()" );
}

/** \C
Para dar de alta un documento, el número de revisión debe estar informado, es decir, el documento debe estar publicado.
\end */
function interna_validateForm():Boolean
{
	var util:FLUtil = new FLUtil;
	var revision:String = this.cursor().valueBuffer("revision");
	if (!revision || revision.toString().isEmpty()) {
		MessageBox.warning(util.translate("scripts", "Antes de crear el registro debe publicar el documento"), MessageBox.Ok, MessageBox.NoButton);
		return false;
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
		/** \D Según el --estado-- se habilitan e inhabilitan las pestañas General y Envío
		*/
		case "estado": 
			if (cursor.valueBuffer("estado") == "Enviada") {
				this.child("gbxGeneral").setDisabled(true);
				this.child("gbxEnvio").setDisabled(true);
			}
			else {
				this.child("gbxGeneral").setDisabled(false);
				this.child("gbxEnvio").setDisabled(false);
			}
		break;
	}
}

/** \D Sube al repositorio de documentación el contenido del directorio de documentación local
*/
function oficial_pbnPublicar_clicked()
{
	var util:FLUtil = new FLUtil;
	
	var comando:String;
	var resComando:Array;
	var respuesta:Number;
	var progreso:Number = 0;
	
	respuesta = MessageBox.information(util.translate("scripts", "Va a publicar la documentación de:\n") + this.iface.pathLocal + util.translate("scripts", "\nEn:\n") + this.iface.urlDocumentacion + this.iface.dirContrato, MessageBox.Ok, MessageBox.Cancel);
	if (respuesta != MessageBox.Ok)
		return false;
	
	if (!this.iface.docPublicada()) {
		respuesta = MessageBox.information(util.translate("scripts", "La documentación del contrato de mantenimiento seleccionado no existe en el repositorio\n ¿desea crearla?"), MessageBox.Yes, MessageBox.No);
		if (respuesta != MessageBox.Yes)
			return false;
			
		util.createProgressDialog(util.translate("scripts", "Publicando documentación"), 9);
		util.setProgress(++progreso);
		comando = "svn mkdir " + this.iface.urlDocumentacion + this.iface.dirContrato + " -m AUTO_CREACION_" + this.iface.dirContrato;
		resComando = flservppal.iface.pub_ejecutarComando(comando);
		if (resComando.ok == false) {
			util.destroyProgressDialog();
			MessageBox.critical(comando + "\n" + util.translate("scripts", "No pudo crearse la documentación seleccionada en el repositorio"), MessageBox.Ok, MessageBox.NoButton);
			return;
		}
		util.setProgress(++progreso);
		comando = "svn checkout " + this.iface.urlDocumentacion + this.iface.dirContrato + " " + this.iface.pathLocal;
		resComando = flservppal.iface.pub_ejecutarComando(comando);
		if (resComando.ok == false) {
			util.destroyProgressDialog();
			MessageBox.critical(comando + "\n" + util.translate("scripts", "No pudo obtenerse la documentación seleccionada en el repositorio"), MessageBox.Ok, MessageBox.NoButton);
			return;
		}
	} else {
		util.createProgressDialog(util.translate("scripts", "Publicando documentación"), 7);
		util.setProgress(++progreso);
		if (!this.iface.obtenerDoc(this.iface.pathLocal)) {
			util.destroyProgressDialog();
			return;
		}
	}
	util.setProgress(++progreso);
	
	comando = "svn status " + this.iface.pathLocal;
	resComando = flservppal.iface.pub_ejecutarComando(comando);
	if (resComando.ok == false) {
		util.destroyProgressDialog();
		MessageBox.critical(comando + "\n" + util.translate("scripts", "No pudo obtenerse la lista de ficheros modificados"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	util.setProgress(++progreso);
	
	var listaDocs:Array = resComando.salida.split("\n");
	for (var i:Number = 0; i < listaDocs.length; i++) {
		if (listaDocs[i].startsWith("?")) {
			comando = "svn add " + listaDocs[i].right(listaDocs[i].length - 7);
			resComando = flservppal.iface.pub_ejecutarComando(comando);
			if (resComando.ok == false) {
				util.destroyProgressDialog();
				MessageBox.critical(comando + "\n" + util.translate("scripts", "No se pudo añadir el fichero al repositorio"), MessageBox.Ok, MessageBox.NoButton);
				return;
			}
		}
	}
	util.setProgress(++progreso);
	
	comando = "svn commit " + this.iface.pathLocal + " -m AUTO_" + this.iface.dirContrato;
	resComando = flservppal.iface.pub_ejecutarComando(comando);
	if (resComando.ok == false) {
		util.destroyProgressDialog();
		MessageBox.critical(comando + "\n" + util.translate("scripts", "No se pudo subir la documentación al repositorio"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	util.setProgress(++progreso);
	
	comando = "svn up " + this.iface.pathLocal;
	resComando = flservppal.iface.pub_ejecutarComando(comando);
	if (resComando.ok == false) {
		util.destroyProgressDialog();
		MessageBox.critical(comando + "\n" + util.translate("scripts", "No se pudo obtener el número de la revisión actual"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	util.setProgress(++progreso);
	
	revision = this.iface.obtenerRevision();
	if (!revision) {
		util.destroyProgressDialog();
		return false;
	}
	util.destroyProgressDialog();
	
	MessageBox.information(util.translate("scripts", "La documentación se actualizó correctamente en el repositorio"), MessageBox.Ok, MessageBox.NoButton);
	
	this.cursor().setValueBuffer("revision", revision);
 	this.accept();
}

/** \D Llama a la función que baja la documentación. Si no hay error, propone al usuario visualizarla
*/
function oficial_pbnObtener_clicked()
{
	var util:FLUtil = new FLUtil;
	var respuesta:Number;
	
	var dirLocal:String = FileDialog.getExistingDirectory(this.iface.pathLocal, util.translate("scripts", "Seleccione directorio"));
	
	respuesta = MessageBox.information(util.translate("scripts", "Va a obtener la documentación publicada en :\n") + this.iface.urlDocumentacion + this.iface.dirContrato + util.translate("scripts", "\nEn el directorio:\n") + dirLocal, MessageBox.Ok, MessageBox.Cancel);
	if (respuesta != MessageBox.Ok)
		return false;
		
	util.createProgressDialog(util.translate("scripts", "Descargando documentación"), 2);
	util.setProgress(1);
	if (!this.iface.obtenerDoc(dirLocal))
		return;
	util.destroyProgressDialog();
	
	respuesta = MessageBox.information(util.translate("scripts", "La documentación se ha obtenido correctamente\n¿desea visualizarla?"), MessageBox.Yes, MessageBox.No);
	if (respuesta == MessageBox.Yes)
		this.iface.pbnVisualizar_clicked();
}

/** \D Baja al directorio de documentación local el contenido del repositorio de documentación para la documentación seleccionada
@param	dirLocal: Directorio donde obtener la documentación.
@return	true si se obtuvo la documentación correctamente, false en caso contrario
*/
function oficial_obtenerDoc(dirLocal:String):Boolean
{
	var util:FLUtil = new FLUtil;
	var comando:String;
	var resComando:Array;
	var respuesta:Number;
	var enControlVersiones:Boolean = false;
	
	if (File.exists(this.iface.pathLocal)) {
		resComando = flservppal.iface.pub_ejecutarComando("svn status " + dirLocal);
		if (resComando.ok == true) {
			var revision:Number = this.cursor().valueBuffer("revision");
			if (!revision || revision == 0)
				comando = "svn up " + dirLocal;
			else
				comando = "svn up -r " + this.cursor().valueBuffer("revision") + " " + dirLocal;
			resComando = flservppal.iface.pub_ejecutarComando(comando);
			if (resComando.ok == false) {
				MessageBox.critical(comando + "\n" + util.translate("scripts", "No se pudo obtener la documentación"), MessageBox.Ok, MessageBox.NoButton);
				return false;
			}
			var listaDocs:Array = resComando.salida.split("\n");
			for (var i:Number = 0; i < listaDocs.length; i++) {
				if (listaDocs[i].startsWith("C")) {
					MessageBox.warning(util.translate("scripts", "Algunos de los ficheros obtenidos han entrado en conflicto con la versión local"), MessageBox.Ok, MessageBox.NoButton);
					return false;
				}
			}
			enControlVersiones = true;
		}
	}
	
	if (!enControlVersiones) {
		comando = "svn checkout " + this.iface.urlDocumentacion + this.iface.dirContrato + " " + dirLocal;
		resComando = flservppal.iface.pub_ejecutarComando(comando);
		if (resComando.ok == false) {
			MessageBox.critical(comando + "\n" + util.translate("scripts", "No se pudo obtener la documentación"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}
	
	return true;
}

/** \D Muestra la documentación en un navegador
*/
function oficial_pbnVisualizar_clicked()
{
	var util:FLUtil = new FLUtil();
	if (!File.exists(this.iface.pathLocal)) {
		MessageBox.warning(util.translate("scripts", "No existe el directorio de documentación:\n") + this.iface.pathLocal, MessageBox.Ok, MessageBox.NoButton);
		return;
	}	
	
 	var navegador:String = util.readSettingEntry("scripts/flservppal/navegador");
 	var explorador:String = util.readSettingEntry("scripts/flservppal/explorador");
	
	if (File.exists(this.iface.pathLocal + "U/index.html"))
		comando = navegador + " " + this.iface.pathLocal + "U/index.html";
	else 
		comando = explorador + " " + this.iface.pathLocal;
				
	try {
		resComando = flservppal.iface.pub_ejecutarComando(comando);
	}
	catch (e) {
		MessageBox.critical(comando + "\n\n" + util.translate("scripts", "Falló la llamada al navegador/explorador.\nDebe especificar una ruta correcta al navegador/explorador en las opciones generales"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
}

/** \D Envía un correo al cliente con la documentación adjunta en 
un fichero comprimido
*/
function oficial_pbnEnviar_clicked()
{
	var util:FLUtil = new FLUtil();
	this.iface.rutaSer = util.readSettingEntry("scripts/flservppal/dirServicios");
	
	if (!File.exists(this.iface.pathLocal)) {
		MessageBox.warning(util.translate("scripts", "No existe el directorio de documentación:\n") + this.iface.pathLocal, MessageBox.Ok, MessageBox.NoButton);
		return;
	}	
	
	if (this.child("fdbModoEnvio").value() == 0) {
		
		this.iface.adjuntos = "";
		var ficheros = FileDialog.getOpenFileNames( this.iface.pathLocal, "*", "Ficheros de Especificaciones");
		
		if (!ficheros) return false;
		
		ficheros = ficheros.toString().split(",");
		for (var i:Number = 0; i < ficheros.length; i++) 
			this.iface.adjuntos += " --attach " + ficheros[i];
		
		this.iface.enviarMail();
		return;
	}
	
	var nomPaquete:String = "espec_sp" + this.cursor().valueBuffer("codcontrato") + "_v" + this.cursor().valueBuffer("version");
	
	var comando:String = 
			"cd " + this.iface.pathLocal + ";" +
			" tar --exclude .svn -cf " + nomPaquete + ".tar *;" +
			" gzip " + nomPaquete +  ".tar;" +
			" mv -f " + nomPaquete +  ".tar.gz " + this.iface.rutaSer + "principal/packets/;"

	this.iface.adjuntos = " --attach " + this.iface.rutaSer + "principal/packets/" + nomPaquete + ".tar.gz";
	
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

/** \D Crea los campos de destinatario, asunto, y cuerpo del mansaje, y lanza el
envio mediante kmail
\end */
function oficial_enviarMail()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();	
	
	var asunto:String = "\"Especificaciones de AbanQ. Contrato de mantenimiento " + this.cursor().valueBuffer("codcontrato") + "  V" + this.cursor().valueBuffer("version") + "\"";
	
 	var cuerpo:String = this.cursor().valueBuffer("textomensaje");
	var patternRE:RegExp = new RegExp("\"");
	patternRE.global = true;
	cuerpo = cuerpo.replace(patternRE, "'");
	cuerpo = "\"" + cuerpo + "\"";
	
 	var codCliente:String = util.sqlSelect("se_contratosman", "codcliente", "codigo ='" + cursor.valueBuffer("codcontrato") +  "'");
 	var destinatario:String = util.sqlSelect("clientes", "email", "codcliente = '" + codCliente + "'");
	
 	var comando:String =  
			"kmail " +
			destinatario +
			" -s " + asunto +
			" --body " + cuerpo + 
			this.iface.adjuntos;
			
	
	var fichProceso = this.iface.rutaSer + "principal/packets/comandomail";
	var f = new File(fichProceso);
	f.open(File.WriteOnly);
	f.write(comando);
	f.close();
	
	this.iface.procesoMail = new FLProcess(fichProceso);
 	connect(this.iface.procesoMail, "exited()", this, "iface.mailEnviado");
   	this.iface.procesoMail.start();
}

/** \D Una vez enviado correctamente el correo se genera un registro de 
documentación correspondiente
\end */
function oficial_mailEnviado()
{
	var util:FLUtil = new FLUtil();
	var res = MessageBox.information(util.translate("scripts", "Pulse \"Aceptar\" DESPUÉS de enviar el mensaje correctamente\nEsto generará un registro de comunicación"),
			MessageBox.Ok, MessageBox.Cancel, MessageBox.NoButton);
	
	this.setDisabled( false );
	
	if (res != MessageBox.Ok) return;
	
	var cursor:FLSqlCursor = this.cursor();	
	
	var curCom:FLSqlCursor = new FLSqlCursor("se_comunicaciones");
	var codComunicacion:String = util.nextCounter("codigo", curCom );
	var enviadoPor:String = util.sqlSelect("se_usuarios", "nombre", "codigo ='" + util.readSettingEntry("scripts/flservppal/codusuario") +  "'");
 	var codCliente:String = util.sqlSelect("se_contratosman", "codcliente", "codigo ='" + cursor.valueBuffer("codcontrato") +  "'");
 	var para:String = util.sqlSelect("clientes", "email", "codcliente = '" + codCliente + "'");
				
	var hoy = new Date();
	var ahora:String = hoy.toString().mid(11, 5);
	cursor.setValueBuffer("fechaenvio", hoy);
	
	cursor.setValueBuffer("estado", "Enviada");
	curCom.setModeAccess(curCom.Insert);
	curCom.refreshBuffer();
	curCom.setValueBuffer("codigo", codComunicacion);
	curCom.setValueBuffer("fecha", hoy);
	curCom.setValueBuffer("hora", ahora);
	curCom.setValueBuffer("asunto", cursor.valueBuffer("descripcion"));
 	curCom.setValueBuffer("texto", cursor.valueBuffer("textomensaje"));
 	curCom.setValueBuffer("codcliente", codCliente);
	curCom.setValueBuffer("codcontrato", cursor.valueBuffer("codcontrato"));
	curCom.setValueBuffer("enviadopor", enviadoPor);
	curCom.setValueBuffer("para", para);
	curCom.setValueBuffer("estado", "Enviado");
	curCom.commitBuffer();
	
	this.accept();
}	

/** \D Comprueba si la documentación del contrato existe o no en el repositorio

@return	True si la funcionalidad existe, false en caso contrario
\end */
function oficial_docPublicada():Boolean 
{ 
	var comando:String = "svn ls " + this.iface.urlDocumentacion + this.iface.dirContrato;
	var resComando:Array = flservppal.iface.pub_ejecutarComando(comando);
	return resComando.ok;
}


/** \D Obtiene la revisión del documento en subversion

@return	Código de la revisión
\end */
function oficial_obtenerRevision():String
{
	var util:FLUtil = new FLUtil();	

	var fichSVN = this.iface.pathLocal + "/.svn/entries";
	if (!File.exists(fichSVN)) {
		MessageBox.critical(this.iface.pathLocal + util.translate("scripts", "\nno se encuentra bajo control de versiones. Imposible obtener el número de revisión"),
			MessageBox.Ok, MessageBox.Cancel, MessageBox.NoButton);
		return false;
	}
	
	var f = new File(fichSVN);
	f.open(File.ReadOnly);
	var contFichero = (f.read());
	f.close();

	var arrayFichero:Array;
	arrayFichero = contFichero.split("revision=\"");
	contFichero = arrayFichero[1];
	arrayFichero = contFichero.split("\"/>");
	
	return arrayFichero[0];
}

/** \D Carga el texto de una plantilla al final del texto de envío
*/
function oficial_insertarPlantillaMensaje() 
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
					texto = this.cursor().valueBuffer("textomensaje") + "\n\n\n---------------------------------------\n\n" + texto;
					this.cursor().setValueBuffer("textomensaje", texto);
					this.child("txtTextoMensaje").text = texto;
					return;
				}
				q.next();
			}
		}
		else
			return;
	}
}

/** \D Carga el texto de una plantilla al final del contenido de envío
*/
function oficial_insertarPlantillaContenido() 
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
					texto = this.cursor().valueBuffer("contenido") + "\n\n\n---------------------------------------\n\n" + texto;
					this.cursor().setValueBuffer("contenido", texto);
					this.child("txtContenido").text = texto;
					return;
				}
				q.next();
			}
		}
		else
			return;
	}

}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
