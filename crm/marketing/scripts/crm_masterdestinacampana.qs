/***************************************************************************
                 crm_masterdestinacampana.qs  -  description
                             -------------------
    begin                : mar mar 23 2010
    copyright            : (C) 2010 by InfoSiAL S.L.
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var tbnLlamar:Object;
	var tbnEnviarEmail:Object;
	var curDestino_:FLSqlCursor;
    function oficial( context ) { interna( context ); }
	function tbnLlamar_clicked() {
		return this.ctx.oficial_tbnLlamar_clicked();
	}
	function tbnEnviarEmail_clicked() {
		return this.ctx.oficial_tbnEnviarEmail_clicked();
	}
	function editarComunicacion() {
		return this.ctx.oficial_editarComunicacion();
	}
	function refrescarTabla() {
		return this.ctx.oficial_refrescarTabla();
	}
	function tbnBuscarCampana() {
		return this.ctx.oficial_tbnBuscarCampana();
	}
	function modificarEstadoDestinatario() {
		return this.ctx.oficial_modificarEstadoDestinatario();
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
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	this.iface.tbnLlamar = this.child("tbnLlamar");
	this.iface.tbnEnviarEmail = this.child("tbnEnviarEmail");
	connect(this.iface.tbnLlamar, "clicked()", this, "iface.tbnLlamar_clicked");
	connect(this.iface.tbnEnviarEmail, "clicked()", this, "iface.tbnEnviarEmail_clicked");
	connect(this.child("tbnBuscarCampana"), "clicked()", this, "iface.tbnBuscarCampana");
	
	this.child("tableDBRecords").setEditOnly(true);
	var aCampos:Array = ["idusuario", "codigo", "nombre", "codestado"]
	this.child("tableDBRecords").setOrderCols(aCampos);
	this.child("tableDBRecords").refresh();
	this.child("txtCampana").setText("");
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_tbnLlamar_clicked()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	
	if (util.sqlSelect("crm_campanas", "canal", "codcampana = '" + cursor.valueBuffer("codcampana") + "'") != "Teléfono") {
		MessageBox.warning(util.translate("scripts", "Para realizar las llamadas el canal usado en la campaña tiene que ser telefónico."), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	this.iface.editarComunicacion();
}

function oficial_tbnEnviarEmail_clicked()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	
	if (util.sqlSelect("crm_campanas", "canal", "codcampana = '" + cursor.valueBuffer("codcampana") + "'") != "E-mail") {
		MessageBox.warning(util.translate("scripts", "Para enviar el Email el canal usado en la campaña tiene que ser E-mail."), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	this.iface.editarComunicacion();
}

function oficial_editarComunicacion()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var idDestinatario:String = cursor.valueBuffer("iddestinatario");
	var campoClave:String = cursor.valueBuffer("campoclave");

	if (!sys.isLoadedModule("flcrm_ppal")) {
		this.iface.modificarEstadoDestinatario();
		return;
	}

	if (!sys.isLoadedModule("flcolaproc")) {
		MessageBox.warning(util.translate("scripts", "Para generar un registro de comunicación es necesario cargar el módulo de procesos (Workflow)"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}

	if (this.iface.curDestino_) {
		disconnect(this.iface.curDestino_, "bufferCommited()", this, "iface.refrescarTabla");
		delete this.iface.curDestino_;
	}
	var tabla:String, formulario:String, filtro:String;
	switch (campoClave) {
		case "clientes.codcliente": {
			tabla = "clientes";
			accion = "crm_clientes";
			filtro = "codcliente = '" + cursor.valueBuffer("codigo") + "'";
			break;
		}
		case "crm_tarjetas.codtarjeta": {
			tabla = "crm_tarjetas";
			accion = "crm_tarjetas";
			filtro = "codtarjeta = '" + cursor.valueBuffer("codigo") + "'";
			break;
		}
		case "crm_contactos.codcontacto": {
			tabla = "crm_contactos";
			accion = "crm_contactos";
			filtro = "codcontacto = '" + cursor.valueBuffer("codigo") + "'";
			break;
		}
		default: {
			return false;
		}
	}
	this.iface.curDestino_ = new FLSqlCursor(tabla);
	this.iface.curDestino_.setAction(accion);

	var acciones:Array = [];
	acciones[0] = flcolaproc.iface.pub_arrayAccion(accion, "escoger_pestana");
	acciones[0]["pestana"] = "comunicaciones";
	acciones[1] = flcolaproc.iface.pub_arrayAccion(accion, "editar_comunicacion");
	acciones[1]["filtro"] = "iddestinatario = " + idDestinatario;
	flcolaproc.iface.pub_setAccionesAuto(acciones);

	connect(this.iface.curDestino_, "bufferCommited()", this, "iface.refrescarTabla");
	this.iface.curDestino_.select(filtro);
	if (!this.iface.curDestino_.first()) {
		return false;
	}
	this.iface.curDestino_.editRecord();
}

function oficial_refrescarTabla()
{
	this.child("tableDBRecords").refresh();
}

function oficial_tbnBuscarCampana()
{
	var util:FLUtil = new FLUtil();
	var f:Object;
	try {
		f = new FLFormSearchDB("crm_campanas");
	} catch (e) {
		MessageBox.warning(util.translate("scripts", "Error al lanzar el formulario de selección de campañas"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	f.setMainWidget();
	var codCampana:String = f.exec("codcampana");

	if (!f.accepted()) {
		return;
	}
	if (codCampana && codCampana != "") {
		var descripcion:String = util.sqlSelect("crm_campanas", "descripcion", "codcampana = '" + codCampana + "'");
		this.child("txtCampana").setText(descripcion);
		this.child("tableDBRecords").setFilter("codcampana = '" + codCampana + "'");
	} 
	this.child("tableDBRecords").refresh();
}

function oficial_modificarEstadoDestinatario()
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var f:Object;
	try {
		f = new FLFormSearchDB("crm_estadosdestina");
	} catch (e) {
		MessageBox.warning(util.translate("scripts", "Error al lanzar el formulario de selección de estados de destinatario"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	f.setMainWidget();
	var codEstado:String = f.exec("codestado");

	if (!f.accepted()) {
		return;
	}
	if (codEstado && codEstado != "") {
		util.sqlUpdate("crm_destinacampana", "codestado", codEstado, "iddestinatario = " + cursor.valueBuffer("iddestinatario"));
	} 
	this.child("tableDBRecords").refresh();
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
