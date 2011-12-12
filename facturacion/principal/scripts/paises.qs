/***************************************************************************
                 paises.qs  -  description
                             -------------------
    begin                : lun ago 06 2007
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
	var listaProv_:Array;
    function oficial( context ) { interna( context ); }
    function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
    }
	function normalizarProvincias_clicked() {
		return this.ctx.oficial_normalizarProvincias_clicked();
	}
	function normalizarProvincias() {
		return this.ctx.oficial_normalizarProvincias();
	}
	function normalizarProvTablas(provincias:Array):Boolean {
		return this.ctx.oficial_normalizarProvTablas(provincias);
	}
	function normalizarProvTabla(provincias:Array, tabla:String):Boolean {
		return this.ctx.oficial_normalizarProvTabla(provincias, tabla);
	}
	function dameDatosNormalizados(provincia:String, provincias:Array, ciudad:String):Array {
		return this.ctx.oficial_dameDatosNormalizados(provincia, provincias, ciudad);
	}
	function normalizarProvincia(provincia:String):String {
		return this.ctx.oficial_normalizarProvincia(provincia);
	}
	function dameMtdTabla(tabla:String):Array {
		return this.ctx.oficial_dameMtdTabla(tabla);
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
	var cursor:FLSqlCursor = this.cursor();
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");

	connect(this.child("tbnNormalizarProv"), "clicked()", this, "iface.normalizarProvincias_clicked()");
}

function calculateField(fN:String):String 
{ 
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_bufferChanged(fN:String)
{
}

function oficial_normalizarProvincias_clicked()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var nombre:String = cursor.valueBuffer("nombre");
	
	var res:Number = MessageBox.information(util.translate("scripts", "Va a normalizar las provincias asociadas a %1.\nEsto puede llevar varios minutos.\nEn caso de encontrar un valor no registrado en la tabla de provincias, AbanQ le pedirá que asocie este valor con la provincia correcta.\nEsta decisión será recordada y vuelta a aplicar para todas las direcciones cuya provincia tenga dicho valor.\n¿Desea continuar?").arg(nombre), MessageBox.Yes, MessageBox.No);
	if (res != MessageBox.Yes) {
		return;
	}
	this.iface.normalizarProvincias();
}

function oficial_normalizarProvincias()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var codPais:String = cursor.valueBuffer("codpais");
	var codISO:String = cursor.valueBuffer("codiso");

	if (codISO == "ES") {
		flfactppal.iface.pub_crearProvinciasEsp(codPais);
	}

	var qryProvincias:FLSqlQuery = new FLSqlQuery;
	qryProvincias.setTablesList("provincias");
	qryProvincias.setSelect("idprovincia, provincia, codigo");
	qryProvincias.setFrom("provincias");
	qryProvincias.setWhere("codpais = '" + codPais + "' ORDER BY codigo");
	qryProvincias.setForwardOnly(true);
	if (!qryProvincias.exec()) {
		return false;
	}
	var provincias:Array = [];
	this.iface.listaProv_ = [];
	var iProvincia:Number = 0;
	var provincia:String;
	while (qryProvincias.next()) {
		provincia = qryProvincias.value("provincia");
		provincias[iProvincia] = [];
		provincias[iProvincia]["id"] = qryProvincias.value("idprovincia");
		provincias[iProvincia]["provincia"] = provincia;
		provincias[iProvincia]["normalizada"] = this.iface.normalizarProvincia(provincia);
		provincias[iProvincia]["sinonimos"] = [];
		this.iface.listaProv_[iProvincia] = qryProvincias.value("codigo") + " / " + provincia;
		iProvincia++;
	}
	if (!this.iface.normalizarProvTablas(provincias)) {
		return false;
	}
	MessageBox.information(util.translate("scripts", "Las provincias han sido normalizadas"), MessageBox.Ok, MessageBox.NoButton);
}

function oficial_normalizarProvTablas(provincias:Array):Boolean
{
	var util:FLUtil = new FLUtil;

	var tablas:Array = ["empresa", "dirclientes", "dirproveedores", "almacenes", "sucursales", "agentes", "crm_contactos", "presupuestoscli", "pedidoscli", "albaranescli", "facturascli", "tpv_comandas"];

	for (var i:Number = 0; i < tablas.length; i++) {
		if (!this.iface.normalizarProvTabla(provincias, tablas[i])) {
			return false;
		}
	}
	return true;
}

function oficial_dameMtdTabla(tabla:String):Array
{
	var util:FLUtil = new FLUtil;
	var curTabla:FLSqlCursor = new FLSqlCursor(tabla);

	var metadatos:Array = [];

	if (!curTabla) {
		metadatos["tabla"] = "SIN MTD";
		return metadatos;
	}
	
	metadatos["tabla"] = tabla;
	metadatos["nombre"] = util.tableNameToAlias(tabla);
	metadatos["campoProvincia"] = "provincia";
	metadatos["campoIdProvincia"] = "idprovincia";
	metadatos["campoCiudad"] = "ciudad";
	metadatos["campoPais"] = "codpais";
	metadatos["campoClave"] = curTabla.primaryKey();
	metadatos["bloqueo"] = false;
	metadatos["campoBloqueo"] = false;

	switch (tabla) {
		case "presupuestoscli":
		case "pedidoscli":
		case "pedidosprov":
		case "facturascli":
		case "facturasprov": {
			metadatos["bloqueo"] = true;
			metadatos["campoBloqueo"] = "editable";
			break;
		}
		case "albaranesprov":
		case "albaranescli": {
			metadatos["bloqueo"] = true;
			metadatos["campoBloqueo"] = "ptefactura";
			break;
		}
	}
	return metadatos;
}

function oficial_normalizarProvTabla(provincias:Array, tabla:String):Boolean
{

	var metadatos:Array = this.iface.dameMtdTabla(tabla);
	if (!metadatos) {
		return false;
	} else if (metadatos.tabla == "SIN MTD") {
		return true;
	}

	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var curTabla:FLSqlCursor = new FLSqlCursor(metadatos.tabla);
	curTabla.setForwardOnly(true);
	var curBloqueo:FLSqlCursor = new FLSqlCursor(metadatos.tabla);
	curTabla.select(metadatos.campoPais + " = '" + cursor.valueBuffer("codpais") + "'");
	curTabla.setActivatedCheckIntegrity(false);
	curTabla.setActivatedCommitActions(false);
	curBloqueo.setActivatedCheckIntegrity(false);
	curBloqueo.setActivatedCommitActions(false);
	var bloqueado:Boolean;
	var clave:String;
	var provincia:String, ciudad:String;
	var datosNormalizados:Array;
	util.createProgressDialog(util.translate("scripts", "Normalizando %1").arg(metadatos.nombre), curTabla.size());
	var progreso:Number = 0;
	while (curTabla.next()) {
		clave = curTabla.valueBuffer(metadatos.campoClave);
		util.setProgress(++progreso);
		provincia = curTabla.valueBuffer(metadatos.campoProvincia);
		ciudad = curTabla.valueBuffer(metadatos.campoCiudad);
		datosNormalizados = this.iface.dameDatosNormalizados(provincia, provincias, ciudad);
		if (!datosNormalizados) {
			continue;
		}
		bloqueado = (metadatos.bloqueo && !curTabla.valueBuffer(metadatos.campoBloqueo));
		if (bloqueado) {
			curBloqueo.select(metadatos.campoClave + " = " + clave);
			if (!curBloqueo.first()) {
				util.destroyProgressDialog();
				return false;
			}
			curBloqueo.setUnLock(metadatos.campoBloqueo, true);

			curBloqueo.select(metadatos.campoClave + " = " + clave);
			if (!curBloqueo.first()) {
				util.destroyProgressDialog();
				return false;
			}
			curBloqueo.setModeAccess(curBloqueo.Edit);
			curBloqueo.refreshBuffer();
			curBloqueo.setValueBuffer(metadatos.campoIdProvincia, datosNormalizados["id"]);
			curBloqueo.setValueBuffer(metadatos.campoProvincia, datosNormalizados["provincia"]);
			if (!curBloqueo.commitBuffer()) {
				util.destroyProgressDialog();
				return false;
			}
			curBloqueo.select(metadatos.campoClave + " = " + clave);
			if (!curBloqueo.first()) {
				util.destroyProgressDialog();
				return false;
			}
			curBloqueo.setUnLock(metadatos.campoBloqueo, false);
		} else {
			curTabla.setModeAccess(curTabla.Edit);
			curTabla.refreshBuffer();
			curTabla.setValueBuffer(metadatos.campoIdProvincia, datosNormalizados["id"]);
			curTabla.setValueBuffer(metadatos.campoProvincia, datosNormalizados["provincia"]);
			if (!curTabla.commitBuffer()) {
				util.destroyProgressDialog();
				return false;
			}
		}
	}
	util.destroyProgressDialog();

	return true;
}

/** Obtiene la provincia normalizada comparando la cadena con las provincias candidatas
\end */
function oficial_dameDatosNormalizados(provincia:String, provincias:Array, ciudad:String):Array
{
	var util:FLUtil = new FLUtil;
	var provNormalizada:String = this.iface.normalizarProvincia(provincia);
	var datosNorm:Array = false;
	for (var i:Number = 0; i < provincias.length; i++) {
		if (provNormalizada == provincias[i]["normalizada"]) {
			datosNorm = provincias[i];
			break;
		} else {
			for (var s:Number = 0; s < provincias[i]["sinonimos"].length; s++) {
				if (provNormalizada == provincias[i]["sinonimos"][s]) {
					datosNorm = provincias[i];
					break;
				}
			}
		}
	}
	if (!datosNorm) {
		var iProvincia:Number = flfactppal.iface.elegirOpcion(this.iface.listaProv_, util.translate("scripts", "Seleccione la provincia asociada a %1 - %2").arg(provincia).arg(ciudad));
		if (iProvincia < 0) {
			return false;
		}
		datosNorm = provincias[iProvincia]
		provincias[iProvincia]["sinonimos"].push(provNormalizada);
	}
	return datosNorm;
}

/** \D Pasa la cadena a mayúsculas y elimina los acentos
\end */
function oficial_normalizarProvincia(provincia:String):String
{
	if (!provincia || provincia == "") {
		return "";
	}
	var provUpper:String = provincia.toUpperCase();
	var provNormalizada:String = "";
	var caracter:String;
	for (var i:Number = 0; i < provUpper.length; i++) {
		caracter = provUpper.charAt(i);
		switch (caracter) {
			case "Á": { provNormalizada += "A"; break; }
			case "É": { provNormalizada += "E"; break; }
			case "Í": { provNormalizada += "I"; break; }
			case "Ó": { provNormalizada += "O"; break; }
			case "U": { provNormalizada += "U"; break; }
			case "À": { provNormalizada += "A"; break; }
			case "È": { provNormalizada += "E"; break; }
			case "Ì": { provNormalizada += "I"; break; }
			case "Ò": { provNormalizada += "O"; break; }
			case "Ù": { provNormalizada += "U"; break; }
			default: { provNormalizada += caracter; break; }
		}
	}
	return provNormalizada;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
