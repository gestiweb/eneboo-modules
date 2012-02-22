/***************************************************************************
                 se_comunicaciones.qs  -  description
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
//  ***************************************************************************/

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
	function calculateField(fN:String):String { return this.ctx.interna_calculateField(fN); }
	function calculateCounter() {
		return this.ctx.interna_calculateCounter();
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
	var procesoMail:FLProcess;
	var bloqueoFiltro_:Boolean;
	var charSetActual_:String;
    function oficial( context ) { interna( context ); } 
	function bufferChanged(fN:String) {	return this.ctx.oficial_bufferChanged(fN); }
    function importarMail() { return this.ctx.oficial_importarMail() ;}
	function procesarFichero(file:File ,arrayLineas:Array ,numLineas:Number):String { return this.ctx.oficial_procesarFichero(file,arrayLineas,numLineas);	}
	function extraerFecha(cadena:String):Date { return this.ctx.oficial_extraerFecha(cadena);}
	function convertirMes(cadena:String):String { return this.ctx.oficial_convertirMes(cadena);}
	function extraerHora(cadena:String):Date { return this.ctx.oficial_extraerHora(cadena);}
	function extraerFechaHora(cadena:String):Date { return this.ctx.oficial_extraerFechaHora(cadena);}
	function corregirCadena(cadena:String):String{ return this.ctx.oficial_corregirCadena(cadena);}
	function enviarMail() { return this.ctx.oficial_enviarMail(); }
	function mailEnviado() { return this.ctx.oficial_mailEnviado(); }
	function controlEstado() { return this.ctx.oficial_controlEstado(); }
	function establecerRespuesta() { return this.ctx.oficial_establecerRespuesta(); }
	function crearRemitente():String { return this.ctx.oficial_crearRemitente(); }
	function selecDestinatario() { return this.ctx.oficial_selecDestinatario(); }
	function insertarPlantillaTexto() { return this.ctx.oficial_insertarPlantillaTexto(); }
	function filtroIncidencia():String {
		return this.ctx.oficial_filtroIncidencia();
	}
// 	function establecerContenidoCorreo(datosIncidencia:Array):Boolean {
// 		return this.ctx.oficial_establecerContenidoCorreo(datosIncidencia);
// 	}
	function cargarFicheroMail():Array {
		return this.ctx.oficial_cargarFicheroMail();
	}
	function desconectar() {
		return this.ctx.oficial_desconectar();
	}
	function pbnResponder_clicked() {
		return this.ctx.oficial_pbnResponder_clicked();
	}
	function accionesAutomaticas() {
		return this.ctx.oficial_accionesAutomaticas();
	}
	function realizarAccionAutomatica(accion:Array):Boolean {
		return this.ctx.oficial_realizarAccionAutomatica(accion);
	}
	function resumenIncidencia():String {
		return this.ctx.oficial_resumenIncidencia();
	}
	function prefijoIncidencia():String {
		return this.ctx.oficial_prefijoIncidencia();
	}
	function heredarPadresCorreo(curCom:FLSqlCursor):Boolean {
		return this.ctx.oficial_heredarPadresCorreo(curCom);
	}
	function comprobarCharSet(linea:String) {
		return this.ctx.oficial_comprobarCharSet(linea);
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
	function pub_cargarFicheroMail():Array {
		return this.cargarFicheroMail();
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
function interna_calculateCounter()
{
	var util:FLUtil = new FLUtil();
	var siguienteCodigo:String = flservppal.iface.pub_siguienteSecuencia("se_comunicaciones","codigo",6);

	return siguienteCodigo
}
/** \C
Para las nuevas comunicaciones el cliente debe establecerse según el subproyecto, incidencia
o período de actualizacion al que pertenece el envío

El cliente no podrá ser modificado

Los valores de --codsubproyecto--, --codincidencia-- y --idpactualizacion-- no serán editables
Sólo uno de los tres será rellenado automáticamente según el origen de la comunicación
\end */
function interna_init()
{
	var util:FLUtil = new FLUtil();
	
	var cursor:FLSqlCursor = this.cursor();
	var codIncidencia:String;
	var descIncidencia:String;
	var texto:String = "";

	var curRel:FLSqlCursor = cursor.cursorRelation();
	if (cursor.modeAccess() == cursor.Insert) {
		if (curRel) {
			switch (curRel.table()) {
				case "se_incidencias": {
					this.child("fdbCodCliente").setValue(curRel.valueBuffer("codcliente"));
					this.child("fdbCodProyecto").setValue(curRel.valueBuffer("codproyecto"));
					this.child("fdbCodSubproyecto").setValue(curRel.valueBuffer("codsubproyecto"));
					this.child("fdbPara").setValue(util.sqlSelect("crm_contactos", "email", "codcontacto = '" + curRel.valueBuffer("codcontacto") + "'"));
					this.child("fdbAsunto").setValue(this.iface.prefijoIncidencia() + curRel.valueBuffer("desccorta"));
					this.child("fdbTexto").setValue(this.iface.resumenIncidencia());
					break;
				}
				case "se_subproyectos": {
					this.child("fdbCodProyecto").setValue(curRel.valueBuffer("codproyecto"));
					this.child("fdbCodCliente").setValue(curRel.valueBuffer("codcliente"));
					this.child("fdbCodCliente").setDisabled(true);
					this.child("fdbPara").setValue(util.sqlSelect("crm_contactos", "email", "codcontacto = '" + curRel.valueBuffer("codcontacto") + "'"));
					break;
				}
				case "se_proyectos": {
					this.child("fdbCodCliente").setValue(curRel.valueBuffer("codcliente"));
					this.child("fdbCodCliente").setDisabled(true);
					break;
				}
			}
		}
		cursor.setValueBuffer("codigo", this.iface.calculateCounter());
	
		var hoy = new Date();
		cursor.setValueBuffer("hora", hoy.toString().mid(11, 5));
 		cursor.setValueBuffer("enviadopor", this.iface.crearRemitente());
		this.iface.bloqueoFiltro_ = true;
		this.iface.establecerRespuesta();
	}
	this.iface.bloqueoFiltro_ = false;
	
	this.iface.controlEstado();
	
	connect( this.child("pbnImportarMail"), "clicked()", this, "iface.importarMail" );
	connect( this.child("pbnEnviarMail"), "clicked()", this, "iface.enviarMail");
	connect( this.child("pbnSelecDestinatario"), "clicked()", this, "iface.selecDestinatario");
	connect( this.child("pbnInsertarPlantillaTexto"), "clicked()", this, "iface.insertarPlantillaTexto()" );
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect( this.child("pbnResponder"), "clicked()", this, "iface.pbnResponder_clicked()" );
	connect(this, "formReady()", this, "iface.accionesAutomaticas");
	connect( this, "closed()", this, "iface.desconectar()");
	
// 	this.child("fdbCodCliente").setDisabled(true);
// 	this.child("gbxTipoComunicacion").setDisabled(true);

	this.child("fdbAdjuntarPDF").setDisabled(true);

	if (curRel) {
		switch (curRel.action()) {
			case "se_incidencias": {
				this.child("fdbAdjuntarPDF").setDisabled(false);
				if (codIncidencia) {
					texto = "INCIDENCIA " + codIncidencia + ": " + descIncidencia + "\n" + this.cursor().valueBuffer("texto");
					this.cursor().setValueBuffer("texto", texto);
					this.child("txtTexto").text = texto;
					debug(this.child("txtTexto").value);
				}
			}
		}
	}
	this.child("fdbCodIncidencia").setFilter(this.iface.filtroIncidencia());
}

function interna_calculateField(fN:String):String
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var valor:String;

/** \D El --codcliente-- se calcula a partir del origen de la comunicación:
--codsubproyecto--, --codincidencia-- o --idpactualizacion--
\end */
	switch(fN) {
		case "codcliente":
		
			var codSubproyecto:String = cursor.cursorRelation().valueBuffer("codsubproyecto")
			var idPActualizacion:Number = cursor.cursorRelation().valueBuffer("idpactualizacion")
		
			var codSubproyecto:String = cursor.valueBuffer("codsubproyecto");
			var codIncidencia:String = cursor.valueBuffer("codincidencia");
			var idPActualizacion:Number = cursor.valueBuffer("idpactualizacion");
			var codContrato:String = cursor.valueBuffer("codcontrato");
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
			if (codContrato) {
				valor = util.sqlSelect("se_contratosman", "codcliente", "codigo = '" + codContrato + "'")
			}
			break;
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
// function oficial_establecerContenidoCorreo(datosIncidencia:Array):Boolean
// {
// 	var util:FLUtil = new FLUtil;
// 	var cursor:FLSqlCursor = this.cursor();
// 
// 	var textoResumen:String = util.translate("scripts", "Código: %1.\nDescripción: %2.\nApertura: %3.\nResponsable: %4.\n").arg(cursor.valueBuffer("codincidencia")).arg(datosIncidencia["i.desccorta"]).arg(util.dateAMDtoDMA(datosIncidencia["i.fechaapertura"])).arg(datosIncidencia["u.nombre"])
// 
// 	switch (datosIncidencia["tipocorreo"]) {
// 		case "Resolucion": {
// 			this.child("fdbAsunto").setValue(util.translate("scripts", "Incidencia %1. Notificación de resolución").arg(cursor.valueBuffer("codincidencia")));
// 			this.child("fdbTexto").setValue(textoResumen);
// 			break;
// 		}
// 	}
// 	return true;
// }

function oficial_bufferChanged(fN:String)
{ 
	var cursor:FLSqlCursor = this.cursor();
	/** \D Al cambiar el --estado-- activa o desactiva determinados controles
	\end */
	switch (fN) {
		case "estado": {
			this.iface.controlEstado();
			break;
		}
		case "codcliente":
		case "codproyecto":
		case "codsubroyecto": {
			if (!this.iface.bloqueoFiltro_) {
				this.child("fdbCodIncidencia").setFilter(this.iface.filtroIncidencia());
			}
			break;
		}
	}
}

/** \D Realiza la importación de un correo electrónico desde un fichero en disco
parseando el contenido para rellenar los campos del registro
\end */
function oficial_importarMail() 
{
	var util:FLUtil = new FLUtil();
	
	var cursor:FLSqlCursor = this.cursor();

	var datosMail:Array = this.iface.cargarFicheroMail();
	if (!datosMail) {
		return false;
	}

	this.child("fdbEnviadoPor").setValue(datosMail["from"]);
	this.child("fdbAsunto").setValue(datosMail["subject"]);
	this.child("fdbFecha").setValue(datosMail["date"]);
	this.child("fdbHora").setValue(datosMail["time"]);
	this.child("fdbPara").setValue(datosMail["to"]);
	this.child("fdbTexto").setValue(datosMail["body"]);

	this.cursor().setValueBuffer("estado", "Recibido");
}

function oficial_cargarFicheroMail():Array
{
debug("oficial_cargarFicheroMail");
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	
	var archivo:String = util.readSettingEntry("scripts/flservppal/ficheromail");
	if (!archivo || archivo == "") {
		archivo = FileDialog.getOpenFileName("*", util.translate("scripts", "Elegir Fichero"));
	}
	if (!archivo) {
		return false;
	}
		
	var file = new File( archivo );
	try {
		file.open( File.ReadOnly );
	}
	catch (e) {
		return false;
	}
	
	var arrayLineas:Array;
	var numLineas:Number = 0;
	var texto:String = "";
// 	var tipoCodificacion:String = "";
// 	while(!file.eof){
// 		var linea:String = file.readLine();
// 		if(linea.find("charset=") != -1 ){
// 			if(linea.find("utf-8") != -1)
// 				tipoCodificacion = "utf-8";
// 			if(linea.find("iso-8859-1") != -1)
// 				tipoCodificacion = "iso-8859-1";
// 			if(linea.find("us-ascii") != -1)
// 				tipoCodificacion = "us-ascii";
// 		}
// 	}
	this.iface.charSetActual_ = "utf-8";
	file.close();
	
	file = new File( archivo );
	
	try {
		file.open( File.ReadOnly );
	}
	catch (e) {
debug("!Open file");
		return false;
	}
	var datosMail:Array = [];
	datosMail["from"] = "";
	datosMail["to"] = "";
	datosMail["subject"] = "";
	datosMail["body"] = "";
	datosMail["date"] = "";
	datosMail["time"] = "";

	while (!file.eof){
		switch (this.iface.procesarFichero(file,arrayLineas,numLineas))
		{
			case "from":
				arrayLineas[0] = this.iface.corregirCadena(arrayLineas[0]);
				datosMail["from"] = arrayLineas[0];
				break;
			case "to":
				arrayLineas[0] = this.iface.corregirCadena(arrayLineas[0]);
				datosMail["to"] = arrayLineas[0];
				break;
			case "subject":
				arrayLineas[0] = this.iface.corregirCadena(arrayLineas[0]);
				datosMail["subject"] = arrayLineas[0];
				break;
					
			case "texto": 
				for (i=0;i<arrayLineas.length;i++) {
					texto += arrayLineas[i];
				}
// 				texto = this.iface.corregirCadena(texto);
				datosMail["body"] = texto;
				break;
			case "date":
				var fecha = new Date();
				datosMail["date"] = this.iface.extraerFecha(arrayLineas[0]);
				datosMail["time"] = this.iface.extraerHora(arrayLineas[0]);
				break;
		}
		if (datosMail["body"] != "") {
			break;
		}
	}
	return datosMail;
}
/** \D Crea los campos de texto necesarios para el correo: asunto, cuerpo,
destino, etc. Estos campos son pasados como parámetros al comando kmail. 
Para ejecutar el comando se introduce el mismo en un fichero ejecutable y se
ejecuta el mismo
\end */
function oficial_enviarMail()
{
	var util:FLUtil = new FLUtil();
	var adjuntos:String = "";
	
	if(this.cursor().valueBuffer("adjuntarpdf")) {
		adjuntos = " --attach " + formse_clientes.iface.pub_informeSaldo(this.cursor().valueBuffer("codcliente"),20,true);
	}

	this.setDisabled( false );
	
	var asunto:String = "\"" + this.cursor().valueBuffer("asunto") + "\"";
	
	var cuerpo:String = this.cursor().valueBuffer("texto");
	var patternRE:RegExp = new RegExp("\"");
	patternRE.global = true;
	cuerpo = cuerpo.replace(patternRE, "'");
	cuerpo = cuerpo + "\n\n\nUn saludo,";
	
	cuerpo = "\"" + cuerpo + "\"";
	
	var destinatario:String = this.child("fdbPara").value();
	
	var comando:String = flservppal.iface.pub_componerCorreo(destinatario, asunto, cuerpo, adjuntos);
			
	var rutaSer:String = util.readSettingEntry("scripts/flservppal/dirServicios");
	var fichProceso = rutaSer + "principal/packets/comandomail";
	var f = new File(fichProceso);
	f.open(File.WriteOnly);
	f.write(comando);
	f.close();
	
	this.iface.procesoMail = new FLProcess(fichProceso);
 	connect(this.iface.procesoMail, "exited()", this, "iface.mailEnviado");
   	this.iface.procesoMail.start();
}

/** \D Una vez enviado el mail, se actualizan los campos de --fecha--, --hora-- y --estado--
\end */
function oficial_mailEnviado()
{
	var util:FLUtil = new FLUtil();
	var res = MessageBox.information(util.translate("scripts", "Pulse \"Aceptar\" DESPUÉS de enviar el mensaje correctamente"),
			MessageBox.Ok, MessageBox.Cancel, MessageBox.NoButton);
	
	this.setDisabled( false );
	
	if (res == MessageBox.Ok) {
		var hoy = new Date();
		
		var ahora:String = hoy.toString().mid(11, 5);
		this.cursor().setValueBuffer("fecha", hoy);
		this.cursor().setValueBuffer("hora", ahora);
		this.cursor().setValueBuffer("estado", "Enviado");
		this.accept();
	}
}

/** \D Toma una cadena de caracteres y sustituye los caracteres extraños por
los normales
@param cadena Cadena de texto a corregir
@return Cadena de texto corregida
\end */
function oficial_corregirCadena(cadena:String):String
{
	var array:Array = new Array;
	var tipoCodificacion:String = this.iface.charSetActual_.toLowerCase();
debug("Corrigiendo " + cadena + " para '" + tipoCodificacion + "'");
	var cadenaAux:String = cadena;

	var inicioCod:Number = cadenaAux.find("=?");
	if (inicioCod >= 0) {
		var finCod:Number = cadenaAux.find("?Q?");
		tipoCodificacion = cadenaAux.substring(inicioCod + 2, finCod - 1);
		tipoCodificacion = tipoCodificacion.toLowerCase();
debug("Cod en linea = " + tipoCodificacion);
		cadenaAux = cadenaAux.left(inicioCod) + cadenaAux.right(cadenaAux.length - (finCod + 3));
debug("cadenaAux  en linea = " + cadenaAux );
	}
	this.iface.comprobarCharSet(cadena);

// 		iso-8859-15?Q?
	switch (tipoCodificacion){
		case "utf-8":{
			array = [["=C3=B3","ó"],["=C3=A9","é"],
					["=C3=A1","á"],["=C3=AD","í"],
					["=C3=BA","ú"],["=?utf-8?Q?",""],
					["3D",""],["=20",""],
					["=C3=B1","ñ"],["=\n",""],
					["?="," "],["=BF","¿"],
					["=C2",""],["utf-8?Q?",""]];
			break;
		}
		case "iso-8859-15":
		case "iso-8859-1": {
			
		}
		default: {
			if (cadenaAux.endsWith("=\n")) {
				cadenaAux = cadenaAux.left(cadenaAux.length - 2);
				cadenaAux += "\n";
			}
			array = [["=?",""],["=3D","="],
				 ["iso-8859-15?q?",""],["=26","&"],
				 ["iso-8859-1?q?",""],["=24","$"],
				 ["=D1","Ñ"],["=BF","¿"],
				 ["?=",""],["=3F","?"],
				 ["=F1","ñ"],["=A1","¡"],
				 ["=E1","á"],["=5B","["],
				 ["=C1","Á"],["=5D","]"],
				 ["=E9","é"],["=7B","{"],
				 ["=C9","É"],["=7D","}"],
				 ["=F3","ó"],["=5F","_"],
				 ["=ED","í"],["=5C","\\"],
				 ["=CD","Í"],["iso-8859-1?b?3A==","Ü"],
				 ["=D3","Ó"],["iso-8859-1?b?ug==","º"],
				 ["=FA","ú"],["iso-8859-1?b?qg==","ª"],
				 ["=DA","Ú"],["iso-8859-1?b?/A==","ü"],
				 ["=23","#"],["=25","%"],
				 ["=20"," "],["=2D",""],
				 ["=E7","ç"],["=B7","·"],
				 ["=46","F"],["ISO-8859-1?Q?",""],
				 ["=3A_", ": "], ["_", " "],
				 ["=93", "\""], ["=94", "\""]];
			break;
		}
	}

// 	var cadenaAux:String = cadena;
// 
// 	 while (1 == 1) {
// 		for (i=0;i<array.length;i++) {
// 			var indice:Number;
// 			do {
// 				indice = cadena.find(array[i][0]);
// 				if (indice >= 0)
// 					cadena = cadena.replace(array[i][0],array[i][1]);
// 			} while ( indice >= 0)
// 		}
// 
// 		if (cadena == cadenaAux)
// 			return cadena;
// 
// 		cadenaAux = cadena;
// 	}
	
	for (i = 0; i < array.length; i++) {
		var indice:Number;
// debug("Buscando " + array[i][0] + " en " + cadenaAux);
		indice = cadenaAux.find(array[i][0]);
// debug ("En " + indice);
		while (indice >= 0) {
			cadenaAux = cadenaAux.replace(array[i][0], array[i][1]);
// debug("Buscando " + array[i][0] + " en " + cadenaAux);
			indice = cadenaAux.find(array[i][0]);
// debug ("En " + indice);
		}
	}
// debug("Resultado " + cadenaAux);
	return cadenaAux;
}


/** \D Convierte la fecha contenida en el fichero de correo electrónico en
un objeto fecha
@param cadena Texto con la fecha
@return Objeto fecha correspondiente
\end */
function oficial_extraerFecha(cadena:String):Date
{
	var fecha = new Date();
	
	var dia:String = cadena.mid(5,2);
	var i:Number = 0;
	if(dia.find(" ") != -1){
		dia = dia.left(1);	
		dia = "0" + dia;
		i=1;
	}	
	var aux:String = cadena.mid(8-i,3);
	var mes:Number = this.iface.convertirMes(aux);
	var anio:Number = cadena.mid(12-i,4);
	
	fecha.setDate(dia);
	fecha.setMonth(mes);
	fecha.setYear(anio);
	
	return fecha;
}


/** \D Convierte la hora contenida en el fichero de correo electrónico en
una cadena con formato de hora HH:MM:SS
@param cadena Texto con la hora
@return Texto con la hora convertida
\end */
function oficial_extraerHora(cadena:String):String
{
	var hora = String
	
	var dia:String = cadena.mid(5,2);
	var i:Number = 0;
	if(dia.find(" ") != -1)
		i=1;
		
	var hora:Number = cadena.mid(17-i,2);
	var min:Number = cadena.mid(20-i,2);
	var seg:Number = cadena.mid(23-i,2);
	hora = hora+ ":" + min + ":" + seg;
	
	return hora;
}

/** \D Convierte la fecha/hora contenida en el fichero de correo electrónico en
una cadena con formato de fecha/hora YYYY:MM:DD-THH:MM:SS
@param cadena Texto con la hora
@return Texto con la hora convertida
\end */
function oficial_extraerFechaHora(cadena:String):String
{
	var fecha:String;
	
	var dia:String = cadena.mid(5,2);
	var i:Number = 0;
	if(dia.find(" ") != -1){
	dia = dia.left(1);
	dia = "0" + dia;
		i=1;
	}
	
	var aux:String = cadena.mid(8 - i,3);
	var mes:Number = this.iface.convertirMes(aux);
	var anio:Number = cadena.mid(12 - i,4);
	
	fecha = anio + "-" + mes + "-" + dia + "T";
	
	var hora:Number = cadena.mid(17 - i,2);
	var min:Number = cadena.mid(20 - i,2);
	var seg:Number = cadena.mid(23 - i,2);
	
	fecha += hora + ":" + min + ":" + seg;
		
	return fecha;
}

/** \D Convierte el código de mes en un número de dos cifras
@param cadena Código del mes con formato MMM
@return Número de dos cifras con el código del mes
\end */
function oficial_convertirMes(cadena:String):String
{
	switch (cadena)
	{
		case "Jan": return "01";
		case "Feb": return "02";
		case "Mar": return "03";
		case "Apr": return "04";
		case "May": return "05";
		case "Jun": return "06";
		case "Jul": return "07";
		case "Aug": return "08";
		case "Sep": return "09";
		case "Oct": return "10";
		case "Nov": return "11";
		case "Dec": return "12";
	}
}


/** \D Lee el fichero del correo electrónico y lo procesa
\end */
function oficial_procesarFichero(file,arrayLineas,numLineas):String
{
	var util:FLUtil = new FLUtil;
	var tipoDato:String = "";
	var linea:String = "";
	var lineaBuffer:String = "";
	var paso:Number = 0;
	
	while (!file.eof) {
// debug("procesando línea");
		lineaBuffer = file.readLine();
// debug("linea2 = " + lineaBuffer + " a " + this.iface.charSetActual_);
		linea = sys.toUnicode(lineaBuffer, this.iface.charSetActual_); //util.toUnicode(lineaBuffer, this.iface.charSetActual_);
// debug("linea = " + linea);
		if (linea.find("From:") == 0){
		arrayLineas[0]= linea.substring(6);
			numLineas = 1;
			tipoDato = "from";
			return tipoDato;
		} else if (linea.find("To:") == 0){
			arrayLineas[0]= linea.substring(4);
			numLineas = 1;
			tipoDato = "to";
			return tipoDato;
		} else if (linea.find("Subject:") == 0){
			arrayLineas[0]= linea.substring(9);
			numLineas = 1;
			tipoDato = "subject";
			return tipoDato;
		} else if (linea.find("Date:") == 0){
			arrayLineas[0]= linea.substring(6);
			numLineas = 1;
			tipoDato = "date";
			return tipoDato;
		} else if (linea.find("X-KMail-MDN-Sent:") == 0 || linea.find("X-Length:") == 0){
			var boundaryEncontrado:Number = 0
			while (!file.eof && boundaryEncontrado <= 1){
				lineaBuffer = file.readLine();
				if(lineaBuffer.find("--Boundary") == 0){
					boundaryEncontrado++;
					if (boundaryEncontrado == 1){
						var i:Number = 0;
						while(i< 6 && !file.eof){
							lineaBuffer = file.readLine();
							i++;
						}
					}
				} else if (lineaBuffer.find("Content-Type:") >= 0) {
					if (lineaBuffer.find("multipart") == -1 && lineaBuffer.find("text") == -1) {
						boundaryEncontrado = 2;
					}
				}
				
				if(boundaryEncontrado <= 1){
					linea = sys.toUnicode(lineaBuffer, this.iface.charSetActual_);
					linea = this.iface.corregirCadena(linea);
					arrayLineas[numLineas] = linea;
					numLineas++;
				}
			}
			tipoDato = "texto";
			return tipoDato;
		} else {
			this.iface.comprobarCharSet(linea);
		}
	}
}

function oficial_comprobarCharSet(linea:String)
{
	var posCharSet:Number = linea.find("charset=");
	if (posCharSet > -1) {
debug("Charset");
		var nombreCharSet:String = linea.right(linea.length - (posCharSet + 8));
debug("nombreCharSet = " + nombreCharSet);
		var codCharSet:String = "";
		var caracter:String;
		for (var i:Number = 0; i < nombreCharSet.length; i++) {
			caracter = nombreCharSet.charAt(i);
debug("caracter = " + caracter);
			switch (caracter) {
				case "\"":
				case "\n": {
					continue;
					break;
				}
				default: {
					codCharSet += caracter;
debug("codCharSet = " + codCharSet);
				}
			}
		}
		this.iface.charSetActual_ = codCharSet;
	}
	return true;
}

/** \D Bloquea la edición de determinados controles en función del
estado de la comunicación
\end */
function oficial_controlEstado() 
{
	switch(this.cursor().valueBuffer("estado")) {	
		case "Nuevo":
			bloqueo = false;
		break;
		default:
			bloqueo = true;
	}
	
	this.child("pbnEnviarMail").setDisabled(bloqueo);
	this.child("fdbEnviadoPor").setDisabled(bloqueo);
	this.child("fdbPara").setDisabled(bloqueo);
	this.child("fdbAsunto").setDisabled(bloqueo);
	this.child("fdbFecha").setDisabled(bloqueo);
	this.child("fdbHora").setDisabled(bloqueo);
}


/** \D Cuando la comunicación se crea como respuesta a una comunicación previa,
se establece el destinatario como el remitente anterior y se prepara el texto
del cuerpo como el cuerpo del mensaje anterior como cita. Para ello usamos la
variable scripts/flservppal/codigoComResp
\end */
function oficial_establecerRespuesta()
{
	var util:FLUtil = new FLUtil();
 	var codResponderA = util.readSettingEntry("scripts/flservppal/codigoComResp");
debug("codResponderA  = " + codResponderA );
	
	if (codResponderA == 0) return;
 	util.writeSettingEntry("scripts/flservppal/codigoComResp", 0);
	
	var cursor = this.cursor();
	
	var curCom:FLSqlCursor = new FLSqlCursor("se_comunicaciones");
	curCom.select("codigo = '" + codResponderA + "'");
	
	if (curCom.first()) {
		
		if (!this.iface.heredarPadresCorreo(curCom)) {
			return false;
		}

		var nuevoTexto:String = "";
		var codIncidencia:String = cursor.valueBuffer("codincidencia");
		var codIncidenciaCom:String = curCom.valueBuffer("codincidencia");
		if (codIncidenciaCom && codIncidenciaCom != "" && codIncidencia == "") {
			codIncidencia = codIncidenciaCom;
			cursor.setValueBuffer("codincidencia", codIncidencia);
		}
		if (codIncidencia && codIncidencia != "") {
			var resumen:String = this.iface.resumenIncidencia();
			if (resumen != "") {
				nuevoTexto = resumen + "\n\n";
			}
		}
		
		nuevoTexto += util.translate("scripts", "El día %1 %2 escribió:").arg(util.dateAMDtoDMA(curCom.valueBuffer("fecha"))).arg(curCom.valueBuffer("enviadopor")) + "\n\n";

		var lineas = curCom.valueBuffer("texto");
		lineas = lineas.split("\n");
		for (i = 0; i < lineas.length; i++) nuevoTexto += "> " + lineas[i] + "\n";

		cursor.setValueBuffer("texto", nuevoTexto);
		var asunto:String = curCom.valueBuffer("asunto");
		
		if (codIncidencia && codIncidencia != "") {
			var rIncidencia:RegExp = new RegExp("Incidencia\\s\\d+(\\-\\d+)?\\.\\s");
			asunto.match(rIncidencia);
			var iPos:Number;
			var textoEncontrado:String;
			for (var i:Number = 0; i < rIncidencia.capturedTexts.length; i++) {
				textoEncontrado = rIncidencia.capturedTexts[i];
				if (textoEncontrado != "") {
					iPos = asunto.find(textoEncontrado);
					if (iPos >= 0) {
						asunto = asunto.left(iPos) + asunto.right(asunto.length - (iPos + textoEncontrado.length));
					}
				}
			}
		}
		asunto = this.iface.prefijoIncidencia() + "Re: " + asunto;
		cursor.setValueBuffer("asunto", asunto);
		cursor.setValueBuffer("codcliente", curCom.valueBuffer("codcliente"));
		cursor.setValueBuffer("codproyecto", curCom.valueBuffer("codproyecto"));
		cursor.setValueBuffer("codsubproyecto", curCom.valueBuffer("codsubproyecto"));
		cursor.setValueBuffer("codincidencia", curCom.valueBuffer("codincidencia"));
	}
}

/** \D Copia los valores de las tablas padre de una comunicación a partir de los datos de la comunicación a la que se responde
@param	curCom: Comunicación a la que se responde
\end */
function oficial_heredarPadresCorreo(curCom:FLSqlCursor):Boolean
{
	var cursor:FLSqlCursor = this.cursor();
	var codCliente:String = cursor.valueBuffer("codcliente");
	var codProyecto:String = cursor.valueBuffer("codproyecto");
	var codSubproyecto:String = cursor.valueBuffer("codsubproyecto");
	var codIncidencia:String = cursor.valueBuffer("codincidencia");

	var codClienteCom:String = curCom.valueBuffer("codcliente");
	var codProyectoCom:String = curCom.valueBuffer("codproyecto");
	var codSubproyectoCom:String = curCom.valueBuffer("codsubproyecto");
	var codIncidenciaCom:String = curCom.valueBuffer("codincidencia");

	if (codCliente == "" && codClienteCom != "") {
		cursor.setValueBuffer("codcliente", codClienteCom);
	}
	if (codProyecto == "" && codProyectoCom != "") {
		cursor.setValueBuffer("codproyecto", codProyectoCom);
	}
	if (codSubproyecto == "" && codSubproyectoCom != "") {
		cursor.setValueBuffer("codsubproyecto", codSubproyectoCom);
	}
	if (codIncidencia == "" && codIncidenciaCom != "") {
		cursor.setValueBuffer("codincidencia", codIncidenciaCom);
	}
	return true;
}

/** \D Toma como remitente de la comunicación el usuario que esté establecido
en las preferencias del módulo
\end */
function oficial_crearRemitente():String
{
	var util:FLUtil = new FLUtil();
	
	var q:FLSqlQuery = new FLSqlQuery();
// 	q.setTablesList("se_usuarios");
// 	q.setFrom("se_usuarios");
// 	q.setSelect("nombre,email");
// 	q.setWhere("codigo = '" + util.readSettingEntry("scripts/flservppal/codusuario") + "'");
	q.setTablesList("usuarios");
	q.setFrom("usuarios");
	q.setSelect("nombre, email");
	q.setWhere("idusuario = '" + sys.nameUser() + "'");
	
	if (!q.exec()) {
		return false;
	}
	if (!q.first()) {
		return false;
	}
	return q.value("nombre") + " <" + q.value("email") + ">"; 
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

/** \D Carga el texto de una plantilla al final del contenido del mensaje
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
					this.child("txtTexto").text += texto;
					return;
				}
				q.next();
			}
		}
		else
			return;
	}

// 	var curPlan:FLSqlCursor = new FLSqlCursor("se_plantillastexto");
// 	var formPlan:Object = new FLFormSearchDB("se_plantillastexto");
// 	formPlan.setCursor(curPlan);
// 	formPlan.setMainWidget();
// 	
// 	var texto:String = formPlan.exec("texto");
// 	texto = this.cursor().valueBuffer("texto") + "\n\n\n---------------------------------------\n\n" + texto;
// 	this.cursor().setValueBuffer("texto", texto);
// 	this.child("txtTexto").text = texto;
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

function oficial_desconectar()
{
debug("desconectar");

	var cursor:FLSqlCursor = this.cursor();

	disconnect( this.child("pbnImportarMail"), "clicked()", this, "iface.importarMail" );
	disconnect( this.child("pbnEnviarMail"), "clicked()", this, "iface.enviarMail");
	disconnect( this.child("pbnSelecDestinatario"), "clicked()", this, "iface.selecDestinatario");
	disconnect( this.child("pbnInsertarPlantillaTexto"), "clicked()", this, "iface.insertarPlantillaTexto()" );
	disconnect( this.child("pbnResponder"), "clicked()", this, "iface.pbnResponder_clicked()" );
	disconnect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	//disconnect( this, "closed()", this, "iface.desconectar()");
debug("desconectar OK");
}

function oficial_pbnResponder_clicked()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

 	util.writeSettingEntry("scripts/flservppal/codigoComResp", cursor.valueBuffer("codigo"));

	this.acceptContinue();
}

function oficial_accionesAutomaticas()
{
	var acciones:Array = flcolaproc.iface.pub_accionesAuto();
	if (!acciones) {
		return;
	}
	var i:Number = 0;
	while (i < acciones.length && acciones[i]["usada"]) { i++; }
	if (i == acciones.length) {
		return;
	}

	while (i < acciones.length && acciones[i]["contexto"] == "se_comunicaciones") {
		if (!this.iface.realizarAccionAutomatica(acciones[i])) {
			break;
		}
		i++;
	}
}

/** \D Realizar una determinada acción.
@return: Se devuelve false si algo falla o si la acción implica que no debe realizarse ninguna acción subsiguiente en el contexto actual.
\end */ 
function oficial_realizarAccionAutomatica(accion:Array):Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	switch (accion["accion"]) {
		case "importar_mail": {
			accion["usada"] = true;
			this.child("pbnImportarMail").animateClick();
			break;
		}
		case "notificar_resolucion": {
			accion["usada"] = true;
			var asunto:String = this.iface.prefijoIncidencia() + util.translate("scripts", "Notificación de resolución");
			this.child("fdbAsunto").setValue(asunto);
			var texto:String = this.iface.resumenIncidencia();
			texto += "\n" + util.translate("scripts", "La incidencia ha pasado a estado Resuelta");
			this.child("fdbTexto").setValue(texto);
			break;
		}
		case "notificar_pruebas": {
			accion["usada"] = true;
			var asunto:String = this.iface.prefijoIncidencia() + util.translate("scripts", "Notificación de paso a pruebas");
			this.child("fdbAsunto").setValue(asunto);
			var texto:String = this.iface.resumenIncidencia();
			texto += "\n" + util.translate("scripts", "La incidencia ha pasado a estado En pruebas");
			this.child("fdbTexto").setValue(texto);
			break;
		}
		default: {
			return false;
		}
	}
	return true;
}

/** \D Construye un texto de resumen de la incidencia asociada a la comunicación
@return Texto
\end */
function oficial_resumenIncidencia():String
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var codIncidencia:String = cursor.valueBuffer("codincidencia");
debug("codIncidencia = " + codIncidencia);
	if (!codIncidencia || codIncidencia == "") {
		return "";
	}
	var curIncidencia:FLSqlCursor = cursor.cursorRelation();
	if (!curIncidencia || curIncidencia.table() != "se_incidencias") {
debug("creando cursor");
		curIncidencia = new FLSqlCursor("se_incidencias");
		curIncidencia.select("codigo = '" + codIncidencia + "'");
		if (!curIncidencia.first()) {
debug("!first()");
			return "";
		}
	}
	
	var descCorta:String = curIncidencia.valueBuffer("desccorta");
	var fechaApertura:String = util.dateAMDtoDMA(curIncidencia.valueBuffer("fechaapertura"));
	var responsable:String = util.sqlSelect("usuarios", "nombre", "idusuario = '" + curIncidencia.valueBuffer("codencargado") + "'");
	if (!responsable) {
		responsable = util.translate("scripts", "(Sin asignar)");
	}
	var estado:String = curIncidencia.valueBuffer("estado");
	var creditos:String = "";
	if (curIncidencia.valueBuffer("enbolsa")) {
		var codCliente:String = curIncidencia.valueBuffer("codcliente");
		var precio:Number = curIncidencia.valueBuffer("precio") * -1;
		precio = (isNaN(precio) ? 0 : precio);
		creditos = "\n" + util.translate("scripts", "Créditos: %1").arg(precio);
		var saldoActual:Number = flservppal.iface.pub_calcularSaldoCliente(codCliente);
		creditos += ". " + util.translate("scripts", "Saldo actual: %1").arg(saldoActual);
	}
	var textoResumen:String = util.translate("scripts", "Incidencia %1: %2.\nApertura: %3.\nResponsable: %4.\nEstado: %5%6").arg(cursor.valueBuffer("codincidencia")).arg(descCorta).arg(fechaApertura).arg(responsable).arg(estado).arg(creditos);
	return textoResumen;
}

/** \D Construye un prefijo para los correos que están asociados a una incidencia, de forma que se sepa su número de orden
@return Prefijo
\end */
function oficial_prefijoIncidencia():String
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var codIncidencia:String = cursor.valueBuffer("codincidencia");
	if (!codIncidencia || codIncidencia == "") {
		return "";
	}

	var emitidos:Number = parseInt(util.sqlSelect("se_comunicaciones", "COUNT(*)", "codincidencia = '" + codIncidencia + "' AND estado = 'Enviado'"));
	emitidos = (isNaN(emitidos) ? 0 : emitidos);
	var numCorreo:String = flfactppal.iface.pub_cerosIzquierda(emitidos + 1, 2);
	var prefijo:String = util.translate("scripts", "Incidencia %1-%2. ").arg(codIncidencia).arg(numCorreo);
	return prefijo;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
