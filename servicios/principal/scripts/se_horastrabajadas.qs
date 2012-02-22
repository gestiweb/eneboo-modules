/***************************************************************************
                 se_horastrabajadas.qs  -  description
                             -------------------
    begin                : jue oct 18 2007
    copyright            : (C) 2007 by InfoSiAL S.L.
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
	var bloqueo_:Boolean;
	var hastaAhora_:Number;
    function oficial( context ) { interna( context ); } 
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN); 
	}
	function filtroIncidencias() {
		return this.ctx.oficial_filtroIncidencias(); 
	}
	function filtroProyectos() {
		return this.ctx.oficial_filtroProyectos(); 
	}
	function filtroSubproyectos() {
		return this.ctx.oficial_filtroSubproyectos(); 
	}
	function hayProyecto():Boolean {
		return this.ctx.oficial_hayProyecto(); 
	}
	function haySubproyecto():Boolean {
		return this.ctx.oficial_haySubroyecto(); 
	}
	function verIncidencia():Boolean {
		return this.ctx.oficial_verIncidencia(); 
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
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this.child("pbnVerIncidencia"), "clicked()", this, "iface.verIncidencia");

	switch (cursor.modeAccess()) {
		case cursor.Insert: {
			this.child("fdbCodUsuario").setValue(this.iface.calculateField("codusuario"));
			break;
		}
	}
	this.iface.hastaAhora_ = this.iface.calculateField("hastaahora");
	this.child("lblTotalHoras").text = this.iface.calculateField("totalhoras");
}

function interna_calculateField(fN:String):String
{
debug("Calculando " + fN);
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var valor:String;

	switch (fN) {
		case "codusuario": {
// 			valor = util.readSettingEntry("scripts/flservppal/codusuario");
			valor = sys.nameUser();
			if (!valor) {
				MessageBox.information( util.translate( "scripts", "No se ha definido usuario actual"), MessageBox.Ok, MessageBox.NoButton);
				return;
			}
			break;
		}
		case "hastaahora": {
			valor = util.sqlSelect("se_horastrabajadas", "SUM(horas)", "codusuario = '" + cursor.valueBuffer("codusuario") + "' AND fecha = '" + cursor.valueBuffer("fecha") + "' AND id <> " + cursor.valueBuffer("id"));
			if (isNaN(valor)) {
				valor = 0;
			}
			break;
		}
		case "totalhoras": {
			var total:Number = this.iface.hastaAhora_ + parseFloat(cursor.valueBuffer("horas"));;
			if (isNaN(total)) {
				total = 0;
			}
			valor = util.translate("scripts", "Total del día: %1").arg(util.roundFieldValue(total, "se_horastrabajadas", "horas"));
			break;
		}
		case "codcliente":{
			valor = util.sqlSelect("se_proyectos", "codcliente", "codigo = '" + cursor.valueBuffer("codproyecto") + "'");
			if (!valor) {
				valor = cursor.valueBuffer("codcliente");
			}
			break;
		}
		case "codproyecto":{
			valor = util.sqlSelect("se_subproyectos", "codproyecto", "codigo = '" + cursor.valueBuffer("codsubproyecto") + "'");
			if (!valor) {
				valor = cursor.valueBuffer("codproyecto");
			}
			break;
		}
		case "codsubproyecto":{
			valor = util.sqlSelect("se_incidencias", "codsubproyecto", "codigo = '" + cursor.valueBuffer("codincidencia") + "'");
			if (!valor) {
				valor = cursor.valueBuffer("codsubproyecto");
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

	var codIncidencia:String = util.sqlSelect("se_horastrabajadas", "codincidencia", "id = " + cursor.valueBuffer("id"));
	if (codIncidencia) {
		var codSubproyecto:String = util.sqlSelect("se_incidencias", "codsubproyecto", "codigo = '" + cursor.valueBuffer("codincidencia") + "'");
		if (codSubproyecto != cursor.valueBuffer("codsubproyecto")) {
			MessageBox.warning(util.translate("scripts", "La incidencia seleccionada no corresponde al subproyecto %1").arg(cursor.valueBuffer("codsubproyecto")), MessageBox.Ok, MessageBox.NoButton);
			return false;	
		}
		var codCliente:String = util.sqlSelect("se_incidencias", "codcliente", "codigo = '" + cursor.valueBuffer("codincidencia") + "'");
		if (codCliente != cursor.valueBuffer("codcliente")) {
			MessageBox.warning(util.translate("scripts", "La incidencia seleccionada no corresponde al cliente %1").arg(cursor.valueBuffer("codcliente")), MessageBox.Ok, MessageBox.NoButton);
			return false;	
		}
	}

	var codSubproyecto:String = util.sqlSelect("se_horastrabajadas", "codsubproyecto", "id = " + cursor.valueBuffer("id"));
	if (codSubproyecto) {
		var codProyecto:String = util.sqlSelect("se_subproyectos", "codproyecto", "codigo = '" + cursor.valueBuffer("codsubproyecto") + "'");
		if (codProyecto != cursor.valueBuffer("codproyecto")) {
			MessageBox.warning(util.translate("scripts", "La subproyecto seleccionado no corresponde al proyecto %1").arg(cursor.valueBuffer("codproyecto")), MessageBox.Ok, MessageBox.NoButton);
			return false;	
		}
	}

	var codProyecto:String = util.sqlSelect("se_horastrabajadas", "codproyecto", "id = " + cursor.valueBuffer("id"));
	if (codProyecto) {
		var codCliente:String = util.sqlSelect("se_proyectos", "codcliente", "codigo = '" + cursor.valueBuffer("codproyecto") + "'");
		if (codCliente != cursor.valueBuffer("codcliente")) {
			MessageBox.warning(util.translate("scripts", "La proyecto seleccionado no corresponde al cliente %1").arg(cursor.valueBuffer("codcliente")), MessageBox.Ok, MessageBox.NoButton);
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
		case "codcliente": {
			if (!this.iface.bloqueo_) {
				if (!this.iface.hayProyecto()) {
					this.child("fdbCodProyecto").setFilter(this.iface.filtroProyectos());
					this.child("fdbCodSubproyecto").setFilter(this.iface.filtroSubproyectos());
					this.child("fdbCodIncidencia").setFilter(this.iface.filtroIncidencias());
				}
			}
			break;
		}
		case "codproyecto": {
			this.child("fdbCodCliente").setValue(this.iface.calculateField("codcliente"));
// 			if (!this.iface.bloqueo_) {
				if (!this.iface.haySubproyecto()) {
					this.child("fdbCodSubproyecto").setFilter(this.iface.filtroSubproyectos());
					this.child("fdbCodIncidencia").setFilter(this.iface.filtroIncidencias());
				}
// 			}
			break;
		}
		case "codsubproyecto": {
			this.child("fdbCodProyecto").setValue(this.iface.calculateField("codproyecto"));
			this.child("fdbCodCliente").setValue(this.iface.calculateField("codcliente"));
			this.child("fdbCodIncidencia").setFilter(this.iface.filtroIncidencias());
			break;
		}
		case "codincidencia": {
			this.child("fdbCodSubproyecto").setValue(this.iface.calculateField("codsubproyecto"));
			this.child("fdbCodProyecto").setValue(this.iface.calculateField("codproyecto"));
			this.child("fdbCodCliente").setValue(this.iface.calculateField("codcliente"));
			break;
		}
		case "fecha": {
			this.iface.hastaAhora_ = this.iface.calculateField("hastaahora");
			this.child("lblTotalHoras").text = this.iface.calculateField("totalhoras");
			break;
		}
		case "horas": {
			this.child("lblTotalHoras").text = this.iface.calculateField("totalhoras");
			break;
		}
	}
}

function oficial_hayProyecto():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var hay:Boolean = false;
	var codCliente:String = cursor.valueBuffer("codcliente");
	if (codCliente && codCliente != "") {
		var numProyectos:Number = util.sqlSelect("se_proyectos", "COUNT(*)", "codcliente = '" + codCliente + "'");
		switch (numProyectos) {
			case 0: {
				this.iface.bloqueo_ = true;
				this.child("fdbCodProyecto").setValue("");
				this.iface.bloqueo_ = false;
				break;
			}
			case 1: {
				this.iface.bloqueo_ = true;
				this.child("fdbCodProyecto").setValue(util.sqlSelect("se_proyectos", "codigo", "codcliente = '" + codCliente + "'"));
				this.iface.bloqueo_ = false;
				hay = true;
				break;
			}
		}
	}
	return hay;
}

function oficial_haySubroyecto():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var hay:Boolean = false;
	var codProyecto:String = cursor.valueBuffer("codproyecto");
	if (codProyecto && codProyecto != "") {
		if (util.sqlSelect("se_subproyectos", "COUNT(*)", "codproyecto = '" + codProyecto + "'") == 1) {
			this.iface.bloqueo_ = true;
			this.child("fdbCodSubproyecto").setValue(util.sqlSelect("se_subproyectos", "codigo", "codproyecto = '" + codProyecto + "'"));
			this.iface.bloqueo_ = false;
			
		}
	}
	return hay;
}

function oficial_filtroProyectos():String
{
	var cursor:FLSqlCursor = this.cursor();
	var filtro:String = "";
	var codCliente:String = cursor.valueBuffer("codcliente");
	if (codCliente && codCliente != "") {
		filtro = "codcliente = '" + codCliente + "'";
	}
	return filtro;
}

function oficial_filtroSubproyectos():String
{
	var cursor:FLSqlCursor = this.cursor();
	var filtro:String = "";

	var codProyecto:String = cursor.valueBuffer("codproyecto");
	var codCliente:String = cursor.valueBuffer("codcliente");
	if (codProyecto && codProyecto != "") {
		filtro = "codproyecto = '" + codProyecto + "'";
	} else if (codCliente && codCliente != "") {
		filtro = "codcliente = '" + codCliente + "'";
	}

	return filtro;
}

function oficial_filtroIncidencias():String
{
	var cursor:FLSqlCursor = this.cursor();
	var filtro:String = "";

	var codSubproyecto:String = cursor.valueBuffer("codsubproyecto");
	var codProyecto:String = cursor.valueBuffer("codproyecto");
	var codCliente:String = cursor.valueBuffer("codcliente");
	if (codSubproyecto && codProyecto != "") {
		filtro = "codsubproyecto = '" + codSubproyecto + "'";
	} else if (codProyecto && codProyecto != "") {
		filtro = "codproyecto = '" + codProyecto + "'";
	} else if (codCliente && codCliente != "") {
		filtro = "codcliente = '" + codCliente + "'";
	}

	return filtro;
}

function oficial_verIncidencia()
{
	if (!this.cursor().valueBuffer("codincidencia"))
		return;

	var curTab:FLSqlCursor = new FLSqlCursor("se_incidencias");
	curTab.select("codigo = '" + this.cursor().valueBuffer("codincidencia") + "'");
	if (curTab.first()) {
		curTab.setModeAccess(curTab.Browse);
		curTab.refreshBuffer();
		curTab.browseRecord();
	}
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
