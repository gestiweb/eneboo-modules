/***************************************************************************
                 cl_comunicaciones.qs  -  description
                             -------------------
    begin                : mar ene 29 2008
    copyright            : (C) 2008 by InfoSiAL S.L.
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
	function calculateCounter() {
		return this.ctx.interna_calculateCounter();
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var arrayMailsDest:Array;
    function oficial( context ) { interna( context ); }
	function listaDirEmails():Boolean {
		return this.ctx.oficial_listaDirEmails();
	}
	function seleccionarDestino():String {
		return this.ctx.oficial_seleccionarDestino();
	}
	function selecDestinatarioClicked() {
		return this.ctx.oficial_selecDestinatarioClicked();
	}
	function insertarPlantilla() {
		return this.ctx.oficial_insertarPlantilla();
	}
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function enviarMail() {
		return this.ctx.oficial_enviarMail();
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
	return util.nextCounter("codcomunicacion", this.cursor());
}

function interna_init()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	connect(this.child("pbnSelecDestinatario"), "clicked()", this, "iface.selecDestinatarioClicked");
	connect(this.child("pbnInsertarPlantilla"), "clicked()", this, "iface.insertarPlantilla()" );
	connect(this.child("pbnEnviarMail"), "clicked()", this, "iface.enviarMail()" );

	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");

	switch (cursor.modeAccess()) {
		case cursor.Insert: {
			this.child("fdbCodComunicacion").setValue(this.iface.calculateCounter());
			this.child("fdbIdUsuario").setValue(sys.nameUser());
			this.child("fdbOrigen").setValue(util.sqlSelect("usuarios", "email", "idusuario = '" + sys.nameUser() + "'"));
			var curRelation:FLSqlCursor = cursor.cursorRelation();
			if (curRelation) {
				switch (curRelation.action()) {
					case "cl_incidencias": {
						this.child("fdbCodCliente").setValue(curRelation.valueBuffer("codcliente"));
						this.child("fdbCodProyecto").setValue(curRelation.valueBuffer("codproyecto"));
						this.child("fdbCodSubProyecto").setValue(curRelation.valueBuffer("codsubproyecto"));
						break;
					}
					case "cl_proyectos": {
						this.child("fdbCodCliente").setValue(curRelation.valueBuffer("codcliente"));
						break;
					}
				}
			}
			break;
		}
	}
	if (!sys.isLoadedModule("flcolaproy")) {
		this.child("gbxProyectos").close();
	}
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_bufferChanged(fN:String)
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil;
	switch(fN) {
		case "codincidencia": {
			this.child("fdbCodCliente").setValue(util.sqlSelect("cl_incidencias", "codcliente", "codincidencia = '" + cursor.valueBuffer("codincidencia") + "'"));
			break;
		}
	}
}
/** \D Llama a las funciones que construyen y muestran la lista de posibles destinatarios del correo, y establece el valor del campo --destino-- con las direcciones seleccionadas por el usuario
\end */
function oficial_selecDestinatarioClicked()
{
	var direcciones:String = this.iface.seleccionarDestino();
	if (!direcciones || direcciones == "")
		return;

	this.child("fdbDestino").setValue(direcciones);
}

/** \D Construye la lista de las direcciones de correo asociadas al cliente y/o contacto establecidos.
@return	true si la lista se construye correctamente, false en caso contrario
\end */
function oficial_listaDirEmails():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var codCliente:String = cursor.valueBuffer("codcliente");

	if (!this.iface.arrayMailsDest)
		this.iface.arrayMailsDest = [];

	var nEmails:Number = 0;
	var emailPrincipal:String;
	var nombrePrincipal:String;
	if (codCliente) {
		emailPrincipal = util.sqlSelect("clientes", "email", "codcliente = '" + codCliente + "'");
		nombrePrincipal = util.sqlSelect("clientes", "nombre", "codcliente = '" + codCliente + "'");
		if (emailPrincipal && emailPrincipal != "") {
			this.iface.arrayMailsDest[nEmails] = [];
			this.iface.arrayMailsDest[nEmails]["email"] = emailPrincipal ;
			this.iface.arrayMailsDest[nEmails]["nombre"] = nombrePrincipal ;
			nEmails++;
		}

		var q:FLSqlQuery = new FLSqlQuery();
		q.setTablesList("contactosclientes,crm_contactos");
		q.setFrom("contactosclientes cc INNER JOIN crm_contactos c ON cc.codcontacto = c.codcontacto");
		q.setSelect("c.email, c.nombre");
		q.setWhere("cc.codcliente = '" + codCliente + "' AND c.email <> ''");
		q.setForwardOnly(true);
		if (!q.exec())
			return false;

		while(q.next()) {
			this.iface.arrayMailsDest[nEmails] = [];
			this.iface.arrayMailsDest[nEmails]["email"] = q.value("c.email");
			this.iface.arrayMailsDest[nEmails]["nombre"] = q.value("c.nombre");
			nEmails++;
		}
	}
	
	return true;
}

/** \D Muestra al usuario la lista de direcciones de correo relacionada con la comunicación actual, y permite al usuario seleccionar uno o más destinatarios de la misma
@return	lista de direcciones separada por comas o false si hay error.
\end */
function oficial_seleccionarDestino():String
{
	var util:FLUtil = new FLUtil;

	if (!this.iface.listaDirEmails())
		return false;

	var dialog = new Dialog(util.translate ( "scripts", "Contactos del cliente" ), 0);
	dialog.caption = "Seleccione el destinatario";
	dialog.OKButtonText = util.translate ( "scripts", "Aceptar" );
	dialog.cancelButtonText = util.translate ( "scripts", "Cancelar" );

	var lista:String = "";
	var bgroup:GroupBox = new GroupBox;
	dialog.add( bgroup );
	var cB:Array = [];
	
	if (!this.iface.arrayMailsDest) {
		MessageBox.information(util.translate("scripts", "No hay información de direcciones para el cliente y/o contacto indicados"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	
	if (this.iface.arrayMailsDest.length == 1)
		return this.iface.arrayMailsDest[0]["email"];

	var nEmails:Number;
	for (nEmails = 0; nEmails < this.iface.arrayMailsDest.length; nEmails++)  {
		cB[nEmails] = new CheckBox;
		cB[nEmails].text = this.iface.arrayMailsDest[nEmails]["nombre"] + " (" + this.iface.arrayMailsDest[nEmails]["email"] + ")";
		if (nEmails == 0)
			cB[nEmails].checked = true;
		else
			cB[nEmails].checked = false;
		bgroup.add(cB[nEmails]);
	}
	if (nEmails > 1) {
		if (dialog.exec()) {
			for (var i:Number = 0; i < nEmails; i++)
				if (cB[i].checked == true)
					lista += this.iface.arrayMailsDest[i]["email"] + ",";
		}
		else
			return;
		lista = lista.left(lista.length -1)
		if (lista == "")
			return false;
	}
	return lista;
}

/** \D Carga el texto de una plantilla al final del contenido del mensaje
*/
function oficial_insertarPlantilla()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var f:Object = new FLFormSearchDB("cl_plantillasmensaje");
	var curPlantillas:FLSqlCursor = f.cursor();
	
	f.setMainWidget();
	var plantilla:String = f.exec("texto");

	if (!plantilla)
		return

	var contenido:String = cursor.valueBuffer("contenido");
	if (contenido && contenido != "")
		contenido += "\n\n\n---------------------------------------\n\n" + plantilla;
	else
		contenido = plantilla;
	this.child("fdbContenido").setValue(contenido);
}

function oficial_enviarMail()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	if (cursor.valueBuffer("canal") != "E-mail") {
		MessageBox.warning(util.translate("scripts", "Para eviar un correo el canal de comunicación debe ser E-mail"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	if (cursor.valueBuffer("estado") == "Enviado") {
		var res:Number = MessageBox.information(util.translate("scripts", "El mensaje ya está marcado como enviado.\n¿Desea enviarlo de nuevo?"), MessageBox.Yes, MessageBox.No);
		if (res != MessageBox.Yes)
			return;
	}

	var correo:FLSmtpClient = new FLSmtpClient;
	correo.setFrom(cursor.valueBuffer("origen"));
	correo.setTo(cursor.valueBuffer("destino"));
	correo.setBody(cursor.valueBuffer("contenido"));
	correo.setSubject(cursor.valueBuffer("asunto"));
	var qryAttach:FLSqlQuery = new FLSqlQuery;
	with (qryAttach) {
		setTablesList("cl_adjuntoscom");
		setSelect("ruta, nombre");
		setFrom("cl_adjuntoscom");
		setWhere("codcomunicacion = '" + cursor.valueBuffer("codcomunicacion") + "'");
		setForwardOnly(true);
	}
	if (!qryAttach.exec())
		return false;
	
	var rutaFichero:String;
	while (qryAttach.next()) {
		rutaFichero = qryAttach.value("ruta") + "/" + qryAttach.value("nombre");
		if (!File.exists(rutaFichero)) {
			MessageBox.warning(util.translate("scripts", "No existe el fichero a adjuntar:\n%1").arg(rutaFichero), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
		correo.addAttachment(rutaFichero);
	}
	correo.startSend();
	cursor.setValueBuffer("estado", "Enviado");
	MessageBox.information(util.translate("scripts", "Mensaje enviado"), MessageBox.Ok, MessageBox.NoButton);
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
