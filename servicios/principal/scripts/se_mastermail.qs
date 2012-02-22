/***************************************************************************
                 se_mastermail.qs  -  description
                             -------------------
    begin                : mie ago 26 2008
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
		return this.ctx.interna_init();
	}
	function main() {
		return this.ctx.interna_main();
	}
	function calculateField(fN:String):String {
		return this.ctx.interna_calculateField(fN);
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var curComunicacion_:FLSqlCursor;
	function oficial( context ) { interna( context ); } 
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function responderMail() {
		return this.ctx.oficial_responderMail();
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
function interna_init()
{
	debug("Va el init");
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
}

function interna_main()
{
	debug("Va el main");
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var datosMail:Array = formRecordse_comunicaciones.iface.pub_cargarFicheroMail();
	if (!datosMail) {
debug("!DatosMail");
		return;
	}

	var asunto:String = datosMail["subject"];
	var asuntoLC:String = asunto.toLowerCase();
debug("asunto = " + asunto);
	var codCliente:String = false;
	var codProyecto:String = false;
	var codSubproyecto:String = false;
	var codIncidencia:String = false;
	var iIncidencia:Number = asuntoLC.find("incidencia ");
	if (iIncidencia >= 0) {
		var cadena:String = asuntoLC.right(asuntoLC.length - (iIncidencia + 11));
		var numero:RegExp = new RegExp("[0-9]{1,5}")
		cadena.match(numero);
		if (numero.capturedTexts.length > 0) {
			codIncidencia = numero.capturedTexts[0];
			var datosIncidencia:Array = flfactppal.iface.pub_ejecutarQry("se_incidencias", "codcliente,codproyecto,codsubproyecto,desccorta", "codigo = '" + codIncidencia + "'");
			if (datosIncidencia.result == 1) {
				codCliente = datosIncidencia["codcliente"];
				codProyecto = datosIncidencia["codproyecto"];
				codSubproyecto = datosIncidencia["codsubproyecto"];
			} else {
				codIncidencia = false;
			}
		}
	}
// codIncidencia = false;
	var nuevaIncidencia:Boolean = false;
	var descCorta:String;
	var de:String = datosMail["from"];
debug("from = " + de);
debug("Cod incidencia = " + codIncidencia);
	if (!codIncidencia) {
		var entreMM:RegExp = new RegExp("\\b([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})\\b");
		de.match(entreMM);

		var email:String = "";
		if (entreMM.capturedTexts.length > 0) {
			email = entreMM.capturedTexts[0];
		}
debug("email = " + email);
		if (email && email != "") {
			var codContacto:String = util.sqlSelect("crm_contactos", "codcontacto", "email = '" + email + "'");
			if (!codContacto || codContacto == "") {
				MessageBox.warning(util.translate("scripts", "No hay ningún contacto con email %1").arg(email), MessageBox.Ok, MessageBox.NoButton);
				return false;
			}
			var lista:Array = [];
			var listaCodigos:Array = [];
			var iLista:Number = 0;
			var qrySubproyectos:FLSqlQuery = new FLSqlQuery;
			qrySubproyectos.setTablesList("se_subproyectos");
			qrySubproyectos.setSelect("codigo, descripcion, codproyecto, codcliente");
			qrySubproyectos.setFrom("se_subproyectos");
			qrySubproyectos.setWhere("codcontacto = '" + codContacto + "'");
			qrySubproyectos.setForwardOnly(true);
			if (!qrySubproyectos.exec()) {
				return false;
			}

			var dialogo:Dialog = flservppal.iface.pub_dameDialogoD();
			var rbnOpcion:Array = [];
			var ledIncidencia:LineEdit;
			var gbxOpciones:GroupBox = flservppal.iface.pub_dameGroupBoxD(util.translate("scripts", "Asociar comunicación a..."));
			dialogo.add(gbxOpciones);
			while (qrySubproyectos.next()) {
				rbnOpcion[iLista] = flservppal.iface.pub_dameRadioButtonD(util.translate("scripts", "Subproyecto %1 - %2").arg(qrySubproyectos.value("codigo")).arg(qrySubproyectos.value("descripcion")));
				gbxOpciones.add(rbnOpcion[iLista]);
// 				lista[iLista] = util.translate("scripts", "Subproyecto %1 - %2").arg(qrySubproyectos.value("codigo")).arg(qrySubproyectos.value("descripcion"));
				listaCodigos[iLista] = [];
				listaCodigos[iLista]["tipo"] = "SUBPROYECTO";;
				listaCodigos[iLista]["codigo"] = qrySubproyectos.value("codigo");
				listaCodigos[iLista]["codigo2"] = qrySubproyectos.value("codproyecto");
				listaCodigos[iLista]["codigo3"] = qrySubproyectos.value("codcliente");
				iLista++;
				rbnOpcion[iLista] = flservppal.iface.pub_dameRadioButtonD(util.translate("scripts", "Nueva incidencia en subproyecto %1 - %2").arg(qrySubproyectos.value("codigo")).arg(qrySubproyectos.value("descripcion")));
				gbxOpciones.add(rbnOpcion[iLista]);
// 				lista[iLista] = util.translate("scripts", "Nueva incidencia en subproyecto %1 - %2").arg(qrySubproyectos.value("codigo")).arg(qrySubproyectos.value("descripcion"));
				listaCodigos[iLista] = [];
				listaCodigos[iLista]["tipo"] = "NUEVA INCIDENCIA EN SUBPROYECTO";;
				listaCodigos[iLista]["codigo"] = qrySubproyectos.value("codigo");
				listaCodigos[iLista]["codigo2"] = qrySubproyectos.value("codproyecto");
				listaCodigos[iLista]["codigo3"] = qrySubproyectos.value("codcliente");
				iLista++;
			}
			var qryClientes:FLSqlQuery = new FLSqlQuery;
			qryClientes.setTablesList("clientes,contactosclientes");
			qryClientes.setSelect("c.codcliente, c.nombre");
			qryClientes.setFrom("contactosclientes cc INNER JOIN clientes c ON cc.codcliente = c.codcliente");
			qryClientes.setWhere("cc.codcontacto = '" + codContacto + "'");
			qryClientes.setForwardOnly(true);
			if (!qryClientes.exec()) {
				return false;
			}
			while (qryClientes.next()) {
				rbnOpcion[iLista] = flservppal.iface.pub_dameRadioButtonD(util.translate("scripts", "Cliente %1 - %2").arg(qryClientes.value("c.codcliente")).arg(qryClientes.value("c.nombre")));
				gbxOpciones.add(rbnOpcion[iLista]);
// 				lista[iLista] = util.translate("scripts", "Cliente %1 - %2").arg(qryClientes.value("c.codcliente")).arg(qryClientes.value("c.nombre"));
				listaCodigos[iLista] = [];
				listaCodigos[iLista]["tipo"] = "CLIENTE";
				listaCodigos[iLista]["codigo"] = qryClientes.value("c.codcliente");
				iLista++;
				rbnOpcion[iLista] = flservppal.iface.pub_dameRadioButtonD(util.translate("scripts", "Nueva incidencia en cliente %1 - %2").arg(qryClientes.value("c.codcliente")).arg(qryClientes.value("c.nombre")));
				gbxOpciones.add(rbnOpcion[iLista]);
// 				lista[iLista] = util.translate("scripts", "Nueva incidencia en cliente %1 - %2").arg(qryClientes.value("c.codcliente")).arg(qryClientes.value("c.nombre"));
				listaCodigos[iLista] = [];
				listaCodigos[iLista]["tipo"] = "NUEVA INCIDENCIA EN CLIENTE";
				listaCodigos[iLista]["codigo"] = qryClientes.value("c.codcliente");
				iLista++;
			}
			if (iLista == 0) {
				var nombreContacto:String = util.sqlSelect("crm_contactos", "nombre", "codcontacto = '" + codContacto + "'");
				MessageBox.warning(util.translate("scripts", "No hay clientes ni subproyectos asociadas al contacto %1 - %2").arg(codContacto).arg(nombreContacto), MessageBox.Ok, MessageBox.NoButton);
				return false;
			}
			ledIncidencia = flservppal.iface.pub_dameLineEditD(util.translate("scripts", "Nueva incidencia"), asunto);
			gbxOpciones.add(ledIncidencia);
			if (!dialogo.exec()) {
				return false;
			}
			var seleccion:Number = 0;
			for (seleccion = 0; seleccion < iLista; seleccion++) {
				if (rbnOpcion[seleccion].checked) {
					break;
				}
			}
			if (seleccion == iLista) {
				return false;
			}
			descCorta = ledIncidencia.text;

// 			var seleccion:Number = flfactppal.iface.pub_elegirOpcion(lista);
// 			if (seleccion < 0) {
// 				return false;
// 			}
			switch (listaCodigos[seleccion]["tipo"]) {
				case "NUEVA INCIDENCIA EN CLIENTE": {
					nuevaIncidencia = true;
				}
				case "CLIENTE": {
					codCliente = listaCodigos[seleccion]["codigo"];
					break;
				}
				case "NUEVA INCIDENCIA EN SUBPROYECTO": {
					nuevaIncidencia = true;
				}
				case "SUBPROYECTO": {
					codCliente = listaCodigos[seleccion]["codigo3"];
					codProyecto = listaCodigos[seleccion]["codigo2"];
					codSubproyecto = listaCodigos[seleccion]["codigo"];
					break;
				}
			}
			if (nuevaIncidencia && (!descCorta || descCorta == "")) {
				MessageBox.warning(util.translate("scripts", "Si vas a crear una incidencia debes indicar su descripcion corta"), MessageBox.Ok, MessageBox.NoButton);
				return false;
			}
		}
	}

	if (codIncidencia && codIncidencia != "") {
		var curIncidencia:FLSqlCursor = new FLSqlCursor("se_incidencias");
		curIncidencia.select("codigo = '" + codIncidencia + "'");
		if (!curIncidencia.first()) {
			return false;
		}
		var acciones:Array = [];
		acciones[0] = flcolaproc.iface.pub_arrayAccion("se_incidencias", "insertar_comunicacion");
		acciones[1] = flcolaproc.iface.pub_arrayAccion("se_comunicaciones", "importar_mail");
		acciones[2] = flcolaproc.iface.pub_arrayAccion("se_incidencias", "responder_comunicacion");
		flcolaproc.iface.pub_setAccionesAuto(acciones);
		curIncidencia.editRecord();
		return true;
	} else if (codSubproyecto && codSubproyecto != "") {
		var acciones:Array = [];
		if (nuevaIncidencia) {
			acciones[0] = flcolaproc.iface.pub_arrayAccion("se_subproyectos", "insertar_incidencia");
			acciones[1] = flcolaproc.iface.pub_arrayAccion("se_incidencias", "alta_automatica");
			acciones[1]["desccorta"] = descCorta;
			acciones[2] = flcolaproc.iface.pub_arrayAccion("se_incidencias", "insertar_comunicacion");
			acciones[3] = flcolaproc.iface.pub_arrayAccion("se_comunicaciones", "importar_mail");
			acciones[4] = flcolaproc.iface.pub_arrayAccion("se_incidencias", "responder_comunicacion");
		} else {
			acciones[0] = flcolaproc.iface.pub_arrayAccion("se_subproyectos", "insertar_comunicacion");
			acciones[1] = flcolaproc.iface.pub_arrayAccion("se_comunicaciones", "importar_mail");
		}

		var curSubproyecto:FLSqlCursor = new FLSqlCursor("se_subproyectos");
		curSubproyecto.select("codigo = '" + codSubproyecto + "'");
		if (!curSubproyecto.first()) {
			return false;
		}
		flcolaproc.iface.pub_setAccionesAuto(acciones);
		curSubproyecto.editRecord();
		return true;
	} else if (codCliente && codCliente != "") {
		var curCliente:FLSqlCursor = new FLSqlCursor("clientes");
		curCliente.setAction("se_clientes");
		curCliente.select("codcliente = '" + codCliente + "'");
		if (!curCliente.first()) {
			return false;
		}
		var acciones:Array = [];
		if (nuevaIncidencia) {
			acciones[0] = flcolaproc.iface.pub_arrayAccion("se_clientes", "insertar_incidencia");
			acciones[1] = flcolaproc.iface.pub_arrayAccion("se_incidencias", "alta_automatica");
			acciones[1]["desccorta"] = descCorta;
			acciones[2] = flcolaproc.iface.pub_arrayAccion("se_incidencias", "insertar_comunicacion");
			acciones[3] = flcolaproc.iface.pub_arrayAccion("se_comunicaciones", "importar_mail");
			acciones[4] = flcolaproc.iface.pub_arrayAccion("se_incidencias", "responder_comunicacion");
		} else {
			acciones[0] = flcolaproc.iface.pub_arrayAccion("se_clientes", "insertar_comunicacion");
			acciones[1] = flcolaproc.iface.pub_arrayAccion("se_comunicaciones", "importar_mail");
			acciones[2] = flcolaproc.iface.pub_arrayAccion("se_incidencias", "responder_comunicacion");
		}
		flcolaproc.iface.pub_setAccionesAuto(acciones);
		curCliente.editRecord();
		return true;
	} else {
		MessageBox.warning(util.translate("scripts", "No se ha podido ubicar el correo de %1").arg(de), MessageBox.Ok, MessageBox.NoButton);
	}
	return true;
}

function interna_calculateField(fN:String):String
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var valor:String;

	switch(fN) {
		case "X": {
			break;
		}
	}
	return valor;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_bufferChanged(fN:String)
{ 
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	switch (fN) {
		case "X": {
			break;
		}
	}
}

function oficial_responderMail()
{
	var util:FLUtil = new FLUtil;
	var res:Number = MessageBox.information(util.translate("scripts", "¿Responder?"), MessageBox.Yes, MessageBox.No);
	if (res == MessageBox.Yes) {
		while (this.iface.curComunicacion_.transactionLevel() > 0) {
			debug(this.iface.curComunicacion_.transactionLevel());
			sys.processEvents();
		}
		util.writeSettingEntry("scripts/flservppal/codigoComResp", this.iface.curComunicacion_.valueBuffer("codigo"));
		this.iface.curComunicacion_.insertRecord();
	}
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
