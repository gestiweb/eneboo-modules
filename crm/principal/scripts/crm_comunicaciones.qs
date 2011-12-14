/***************************************************************************
                 crm_comunicaciones.qs  -  description
                             -------------------
    begin                : mar oct 24 2006
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
	var origen:Array;
	var destino:Array;
	var estadoPrevio:String;
    function oficial( context ) { interna( context ); }
	function listaDirEmails():Boolean {
		return this.ctx.oficial_listaDirEmails();
	}
	function seleccionarDestino():Array {
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
	function desconectar() {
		return this.ctx.oficial_desconectar();
	}
	function enviarMail() {
		return this.ctx.oficial_enviarMail();
	}
	function establecerOrigen() {
		return this.ctx.oficial_establecerOrigen();
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
// 	return util.nextCounter("codcomunicacion", this.cursor());
	var siguienteCodigo:String = flcrm_ppal.iface.pub_siguienteSecuencia("crm_comunicaciones","codcomunicacion",10);
	return siguienteCodigo
}

function interna_init()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	connect(this.child("pbnSelecDestinatario"), "clicked()", this, "iface.selecDestinatarioClicked");
	connect(this.child("pbnInsertarPlantilla"), "clicked()", this, "iface.insertarPlantilla()" );
	connect(this.child("pbnEnviarMail"), "clicked()", this, "iface.enviarMail()" );

	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this, "closed()", this, "iface.desconectar");

	this.iface.destino = [];
	this.iface.destino["email"] = "";
	this.iface.destino["telefono"] = "";
	this.iface.origen = [];
	this.iface.origen["email"] = "";
	this.iface.origen["telefono"] = "";

	switch (cursor.modeAccess()) {
		case cursor.Insert: {
			this.child("fdbCodComunicacion").setValue(this.iface.calculateCounter());
			this.child("fdbIdUsuario").setValue(sys.nameUser());
			var email:String = util.sqlSelect("usuarios", "email", "idusuario = '" + sys.nameUser() + "'");
			var nombre:String = util.sqlSelect("usuarios", "nombre", "idusuario = '" + sys.nameUser() + "'");

			this.iface.origen["email"] = email;
			this.iface.origen["telefono"] = nombre;

			this.child("fdbOrigen").setValue(this.iface.origen["email"]);
			var curRelation:FLSqlCursor = cursor.cursorRelation();
			if (curRelation) {
				switch (curRelation.action()) {
					case "crm_tarjetas": {
						this.child("fdbCodCliente").setValue(curRelation.valueBuffer("codcliente"));
						this.child("fdbCodContacto").setValue(curRelation.valueBuffer("codcontacto"));
						break;
					}
					case "crm_oportunidadventa": {
						this.child("fdbCodCliente").setValue(curRelation.valueBuffer("codcliente"));
						this.child("fdbCodContacto").setValue(curRelation.valueBuffer("codcontacto"));
						this.child("fdbCodTarjeta").setValue(curRelation.valueBuffer("codtarjeta"));
						break;
					}
					case "crm_incidencias": {
						this.child("fdbCodCliente").setValue(curRelation.valueBuffer("codcliente"));
						break;
					}
				}
			}
			var codContacto:String = this.child("fdbCodContacto").value();
			if(codContacto && codContacto != "") {
				this.iface.destino["email"] = util.sqlSelect("crm_contactos","email","codcontacto = '" + codContacto + "'");

				this.iface.destino["telefono"] = util.sqlSelect("crm_contactos","nombre","codcontacto = '" + codContacto + "'") + " (" + util.sqlSelect("crm_contactos","telefono1","codcontacto = '" + codContacto + "'") + ")";
			}
			
			var codCliente:String = this.child("fdbCodCliente").value();
			if(codCliente && codCliente != "") {
				if(!this.iface.destino["email"] || this.iface.destino["email"] == "") {
					this.iface.destino["email"] = util.sqlSelect("clientes","email","codcliente = '" + codCliente + "'");
				}
				if(!this.iface.destino["telefono"] || this.iface.destino["telefono"] == "") {
					this.iface.destino["telefono"] = util.sqlSelect("clientes","nombre","codcliente = '" + codCliente + "'") + " (" + util.sqlSelect("clientes","telefono1","codcliente = '" + codCliente + "'") + ")";
				}
			}

			this.child("fdbDestino").setValue(this.iface.destino["email"])
			break;
		}
		case cursor.Edit: {
			this.iface.destino = [];
			this.iface.origen = [];

			var usuario:String = sys.nameUser();
			if(!usuario || usuario == "")
				break;
			
			var email:String = util.sqlSelect("usuarios", "email", "idusuario = '" + sys.nameUser() + "'");
			var nombre:String = util.sqlSelect("usuarios", "nombre", "idusuario = '" + sys.nameUser() + "'");

			if (cursor.valueBuffer("estado") == "Recibido") {
				this.iface.destino["email"] = email;
				this.iface.destino["telefono"] = nombre;
				this.iface.origen["email"] = this.child("fdbOrigen").value();
				this.iface.origen["telefono"] = this.child("fdbOrigen").value();
			} else {
				this.iface.origen["email"] = email;
				this.iface.origen["telefono"] = nombre;
				this.iface.destino["email"] = this.child("fdbDestino").value();
				this.iface.destino["telefono"] = this.child("fdbDestino").value();
			}
			break;
		}
	}


	
	this.iface.estadoPrevio = cursor.valueBuffer("estado");
	if (!sys.isLoadedModule("flcolaproy")) {
		this.child("gbxProyectos").close();
	}
	this.iface.establecerOrigen();
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_desconectar()
{
	var cursor:FLSqlCursor = this.cursor();
	disconnect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
}

function oficial_bufferChanged(fN:String)
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil;
	switch(fN) {
		case "codincidencia": {
			this.child("fdbCodCliente").setValue(util.sqlSelect("crm_incidencias", "codcliente", "codincidencia = '" + cursor.valueBuffer("codincidencia") + "'"));
			break;
		}
		case "codtarjeta": {
			this.child("fdbCodCliente").setValue(util.sqlSelect("crm_tarjetas", "codcliente", "codtarjeta = '" + cursor.valueBuffer("codtarjeta") + "'"));
			this.child("fdbCodContacto").setValue(util.sqlSelect("crm_tarjetas", "codcontacto", "codtarjeta = '" + cursor.valueBuffer("codtarjeta") + "'"));
			break;
		}
		case "codoportunidad": {
			this.child("fdbCodTarjeta").setValue(util.sqlSelect("crm_oportunidadventa", "codtarjeta", "codoportunidad = '" + cursor.valueBuffer("codoportunidad") + "'"));
			this.child("fdbCodCliente").setValue(util.sqlSelect("crm_oportunidadventa", "codcliente", "codoportunidad = '" + cursor.valueBuffer("codoportunidad") + "'"));
			this.child("fdbCodContacto").setValue(util.sqlSelect("crm_oportunidadventa", "codcontacto", "codoportunidad = '" + cursor.valueBuffer("codoportunidad") + "'"));
			break;
		}
		
		case "estado": {
			var estado:String = cursor.valueBuffer("estado");
			if(estado != this.iface.estadoPrevio && (estado == "Recibido" || this.iface.estadoPrevio == "Recibido")) {
				var auxEmail = this.iface.origen["email"];
				var auxTelefono = this.iface.origen["telefono"];

				this.iface.origen["email"] = this.iface.destino["email"];
				this.iface.origen["telefono"] = this.iface.destino["telefono"];
				this.iface.destino["email"] = auxEmail;
				this.iface.destino["telefono"] = auxTelefono;

				this.iface.estadoPrevio = estado;
			}
		}
		case "canal": {
			var canal:String = "email";
			if(cursor.valueBuffer("canal") == "Teléfono")
				canal = "telefono";

			this.child("fdbOrigen").setValue(this.iface.origen[canal]);
			this.child("fdbDestino").setValue(this.iface.destino[canal]);
			break;
		}
		case "origen": {
			var canal:String = "email";
			if(cursor.valueBuffer("canal") == "Teléfono")
				canal = "telefono";
			
			this.iface.origen[canal] = this.child("fdbOrigen").value();
			break;
		}
		case "destino": {
			var canal:String = "email";
			if(cursor.valueBuffer("canal") == "Teléfono")
				canal = "telefono";
			
			this.iface.destino[canal] = this.child("fdbDestino").value();
			break;
		}
	}
}
/** \D Llama a las funciones que construyen y muestran la lista de posibles destinatarios del correo, y establece el valor del campo --destino-- con las direcciones seleccionadas por el usuario
\end */
function oficial_selecDestinatarioClicked()
{
	var listas:Array = this.iface.seleccionarDestino();
	if(!listas || listas.length == 0)
		return;

	if (!listas[0] || listas[0] == "")
		return;

	var canal:String = "email";
	if(this.cursor().valueBuffer("canal") == "E-mail")
			canal = "telefono";

	switch(this.cursor().valueBuffer("estado")) {
		case "Borrador":
		case "Enviado": {
			this.child("fdbDestino").setValue(listas[0]);
			this.iface.destino[canal] = listas[1];
			break;
		}
		case "Recibido": {
			this.child("fdbOrigen").setValue(listas[0]);
			this.iface.origen[canal] = listas[1];
			break;
		}
	}
}

/** \D Construye la lista de las direcciones de correo asociadas al cliente y/o contacto establecidos.
@return	true si la lista se construye correctamente, false en caso contrario
\end */
function oficial_listaDirEmails():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var codCliente:String = cursor.valueBuffer("codcliente");
	var codContacto:String = cursor.valueBuffer("codcontacto");

	if (!this.iface.arrayMailsDest)
		this.iface.arrayMailsDest = [];

	var nEmails:Number = 0;
	var emailPrincipal:String;
	var telPrincipal:String;
	var nombrePrincipal:String;
	if (codCliente && codCliente != "") {
		emailPrincipal = util.sqlSelect("clientes", "email", "codcliente = '" + codCliente + "'");
		telPrincipal = util.sqlSelect("clientes", "telefono1", "codcliente = '" + codCliente + "'");
		nombrePrincipal = util.sqlSelect("clientes", "nombre", "codcliente = '" + codCliente + "'");
		if ((emailPrincipal && emailPrincipal != "") || (telPrincipal && telPrincipal != "")) {
			this.iface.arrayMailsDest[nEmails] = [];
			this.iface.arrayMailsDest[nEmails]["email"] = emailPrincipal ;
			this.iface.arrayMailsDest[nEmails]["telefono"] = telPrincipal ;
			this.iface.arrayMailsDest[nEmails]["nombre"] = nombrePrincipal ;
			nEmails++;
		}

		var q:FLSqlQuery = new FLSqlQuery();
		q.setTablesList("contactosclientes,crm_contactos");
		q.setFrom("contactosclientes INNER JOIN crm_contactos ON contactosclientes.codcontacto = crm_contactos.codcontacto");
		q.setSelect("crm_contactos.email,crm_contactos.telefono1,crm_contactos.nombre");
		q.setWhere("contactosclientes.codcliente = '" + codCliente + "' AND (crm_contactos.email <> '' AND crm_contactos.email IS NOT NULL)");
		q.setForwardOnly(true);
		if (!q.exec())
			return false;
		
		while(q.next()) {
			this.iface.arrayMailsDest[nEmails] = [];
			this.iface.arrayMailsDest[nEmails]["email"] = q.value(0);
			this.iface.arrayMailsDest[nEmails]["telefono"] = q.value(1);
			this.iface.arrayMailsDest[nEmails]["nombre"] = q.value(2);
			nEmails++;
		}
	}
	
	if (codContacto && codContacto != "") {
		emailPrincipal = util.sqlSelect("crm_contactos", "email", "codcontacto = '" + codContacto + "'");
		telPrincipal = util.sqlSelect("crm_contactos", "telefono1", "codcontacto = '" + codContacto + "'");
		nombrePrincipal = util.sqlSelect("crm_contactos", "nombre", "codcontacto = '" + codContacto + "'");
		if ((emailPrincipal && emailPrincipal != "") || (telPrincipal && telPrincipal != "")) {
			this.iface.arrayMailsDest[nEmails] = [];
			this.iface.arrayMailsDest[nEmails]["email"] = emailPrincipal ;
			this.iface.arrayMailsDest[nEmails]["telefono"] = telPrincipal ;
			this.iface.arrayMailsDest[nEmails]["nombre"] = nombrePrincipal ;
			nEmails++;
		}
	}

	return true;
}

/** \D Muestra al usuario la lista de direcciones de correo relacionada con la comunicación actual, y permite al usuario seleccionar uno o más destinatarios de la misma
@return	lista de direcciones separada por comas o false si hay error.
\end */
function oficial_seleccionarDestino():Array
{
	var util:FLUtil = new FLUtil;

	if (!this.iface.listaDirEmails())
		return false;

	var dialog = new Dialog(util.translate ( "scripts", "Contactos del cliente" ), 0);
	dialog.caption = "Seleccione el destinatario";
	dialog.OKButtonText = util.translate ( "scripts", "Aceptar" );
	dialog.cancelButtonText = util.translate ( "scripts", "Cancelar" );

	var lista:String = "";
	var otraLista:String = "";
	var bgroup:GroupBox = new GroupBox;
	dialog.add( bgroup );
	var cB:Array = [];
	
	if (!this.iface.arrayMailsDest) {
		MessageBox.information(util.translate("scripts", "No hay información de direcciones para el cliente y/o contacto indicados"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	
	var campo:String = "email";
	if(this.cursor().valueBuffer("canal") == "Teléfono")
		campo = "telefono";

	if (this.iface.arrayMailsDest.length == 1) {
		var arrayDatos:Array = [];
		if(campo == "telefono") {
			arrayDatos[0] = this.iface.arrayMailsDest[0]["nombre"] + " (" + this.iface.arrayMailsDest[0][campo] + ")";
			arrayDatos[1] = this.iface.arrayMailsDest[0]["email"];
		}
		else {
			arrayDatos[0] = this.iface.arrayMailsDest[0][campo];
			arrayDatos[1] = this.iface.arrayMailsDest[0]["nombre"] + " (" + this.iface.arrayMailsDest[0]["telefono"] + ")";
		}
		
		return arrayDatos;
	}

	var nEmails:Number;
	for (nEmails = 0; nEmails < this.iface.arrayMailsDest.length; nEmails++)  {
		cB[nEmails] = new CheckBox;
		cB[nEmails].text = this.iface.arrayMailsDest[nEmails]["nombre"] + " (" + this.iface.arrayMailsDest[nEmails][campo] + ")";
		if (nEmails == 0)
			cB[nEmails].checked = true;
		else
			cB[nEmails].checked = false;
		bgroup.add(cB[nEmails]);
	}
	
	if (nEmails > 1) {
		if (dialog.exec()) {
			for (var i:Number = 0; i < nEmails; i++)
				if (cB[i].checked == true) {
					if(campo == "telefono") {
						lista += this.iface.arrayMailsDest[i]["nombre"] + " (" + this.iface.arrayMailsDest[i][campo] + "),";
						otraLista += this.iface.arrayMailsDest[i]["email"] + ",";
					}
					else {
						lista += this.iface.arrayMailsDest[i][campo] + ",";
						otraLista += this.iface.arrayMailsDest[i]["nombre"] + " (" + this.iface.arrayMailsDest[i]["telefono"] + "),";
					}
				}
		}
		else {
			return false;
		}
		lista = lista.left(lista.length -1)
		if (lista == "")
			return false;

		otraLista = otraLista.left(otraLista.length -1)
		
	}
	var arrayDatos:Array = [];
	arrayDatos[0] = lista;
	arrayDatos[1] = otraLista;

	return arrayDatos;
}

/** \D Carga el texto de una plantilla al final del contenido del mensaje
*/
function oficial_insertarPlantilla()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var f:Object = new FLFormSearchDB("crm_plantillasmensaje");
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
	var dirCorreSaliente:String = flcrm_ppal.iface.pub_valorConfigPpal("hostcorreosaliente");
	if (!dirCorreSaliente || dirCorreSaliente == "") {
		dirCorreSaliente = "localhost";
	}
	correo.setMailServer(dirCorreSaliente);
	
	correo.setFrom(cursor.valueBuffer("origen"));
	correo.setTo(cursor.valueBuffer("destino"));
	correo.setBody(cursor.valueBuffer("contenido"));
	correo.setSubject(cursor.valueBuffer("asunto"));
	var qryAttach:FLSqlQuery = new FLSqlQuery;
	with (qryAttach) {
		setTablesList("crm_adjuntoscom");
		setSelect("ruta, nombre");
		setFrom("crm_adjuntoscom");
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

/** \D Establece el valor del origen para comunicaciones en estado borrador que son abiertas por un usuario
\end */
function oficial_establecerOrigen()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var canal:String = (cursor.valueBuffer("canal") == "Teléfono" ? "telefono" : "email");
	
	if (cursor.valueBuffer("estado") == "Borrador" && cursor.valueBuffer("origen") == "?") {
		this.child("fdbOrigen").setValue(this.iface.origen[canal]);
	}
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
