/***************************************************************************
                 lineaspedidoscli.qs  -  description
                             -------------------
    begin                : lun abr 26 2004
    copyright            : (C) 2004 by InfoSiAL S.L.
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
    function init() { this.ctx.interna_init(); }
	function calculateField(fN:String):String { return this.ctx.interna_calculateField(fN); }
	function validateForm():Boolean { return this.ctx.interna_validateForm(); }
	function acceptedForm() { return this.ctx.interna_acceptedForm(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    function oficial( context ) { interna( context ); } 
	function desconectar() {
		return this.ctx.oficial_desconectar();
	}
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function commonBufferChanged(fN:String, miForm:Object) {
		return this.ctx.oficial_commonBufferChanged(fN, miForm);
	}
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.oficial_commonCalculateField(fN, cursor);
	}
	function obtenerTarifa(codCliente:String, cursor:FLSqlCursor):String {
		return this.ctx.oficial_obtenerTarifa(codCliente, cursor);
	}
	function datosTablaPadre(cursor:FLSqlCursor):Array {
		return this.ctx.oficial_datosTablaPadre(cursor);
	}
	function dameFiltroReferencia():String {
		return this.ctx.oficial_dameFiltroReferencia();
	}
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration ivaIncluido */
//////////////////////////////////////////////////////////////////
//// IVAINCLUIDO /////////////////////////////////////////////////////
class ivaIncluido extends oficial {
	var bloqueoPrecio:Boolean;
    function ivaIncluido( context ) { oficial( context ); } 	
	function init() {
		return this.ctx.ivaIncluido_init();
	}
	function habilitarPorIvaIncluido(miForm:Object) {
		return this.ctx.ivaIncluido_habilitarPorIvaIncluido(miForm);
	}
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.ivaIncluido_commonCalculateField(fN, cursor);
	}
	function commonBufferChanged(fN:String, miForm:Object) {
		return this.ctx.ivaIncluido_commonBufferChanged(fN, miForm);
	}
}
//// IVAINCLUIDO /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////


/** @class_declaration rappel */
/////////////////////////////////////////////////////////////////
//// RAPPEL /////////////////////////////////////////////////////
class rappel extends ivaIncluido {
    function rappel( context ) { ivaIncluido ( context ); }
	function init() {
		return this.ctx.rappel_init();
	}
	function commonBufferChanged(fN:String, miForm:Object) {
		return this.ctx.rappel_commonBufferChanged(fN, miForm);
	}
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.rappel_commonCalculateField(fN, cursor);
	}
}
//// RAPPEL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends rappel {
    function head( context ) { rappel ( context ); }
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration ifaceCtx */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends head {
    function ifaceCtx( context ) { head( context ); }
		function pub_commonBufferChanged(fN:String, miForm:Object) {
				return this.commonBufferChanged(fN, miForm);
		}
		function pub_commonCalculateField(fN:String, cursor:FLSqlCursor):String {
				return this.commonCalculateField(fN, cursor);
		}
}

const iface = new pubIvaIncluido( this );
//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubIvaIncluido */
/////////////////////////////////////////////////////////////////
//// PUB_IVA_INCLUIDO ///////////////////////////////////////////
class pubIvaIncluido extends ifaceCtx {
    function pubIvaIncluido( context ) { ifaceCtx( context ); }
	function pub_habilitarPorIvaIncluido(miForm:Object) {
		return this.habilitarPorIvaIncluido(miForm);
	}
}

//// PUB_IVA_INCLUIDO ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition interna */
////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
/** \C
Este formulario realiza la gestión de las líneas de pedidos a clientes.
\end */
function interna_init()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(form, "closed()", this, "iface.desconectar");
	
	var codSerie:String = "";
	var porComision:Number = 0;
	var codAgente:String = "";
	var codCliente:String = "";
	
	if(cursor.cursorRelation()) {debug("con cursorRelation");
		codSerie = cursor.cursorRelation().valueBuffer("codserie");
		porComision = cursor.cursorRelation().valueBuffer("porcomision");
		codAgente = cursor.cursorRelation().valueBuffer("codagente");
		codCliente = cursor.cursorRelation().valueBuffer("codcliente");
	}
	else {debug("sin cursorRelation");
		var idPedido:Number = cursor.valueBuffer("idpedido");
		debug("idPedido " + idPedido);
		if(idPedido) {
			codSerie = util.sqlSelect("pedidoscli", "codserie", "idpedido = " + idPedido);
			porComision = util.sqlSelect("pedidoscli", "porcomision", "idpedido = " + idPedido);
			codAgente = util.sqlSelect("pedidoscli", "codagente", "idpedido = " + idPedido);
			codCliente = util.sqlSelect("pedidoscli", "codcliente", "idpedido = " + idPedido);
		}
	}

	var irpf:Number = 0;
	if (codSerie && codSerie != "") {
		irpf = util.sqlSelect("series", "irpf", "codserie = '" + codSerie + "'");
	}
	if (!irpf) {
		irpf = 0;
	}

	if (cursor.modeAccess() == cursor.Insert) {
		var opcionIvaRec:Number = flfacturac.iface.pub_tieneIvaDocCliente(cursor.cursorRelation().valueBuffer("codserie"), cursor.cursorRelation().valueBuffer("codcliente"));
		switch (opcionIvaRec) {
			case 0: {
				this.child("fdbCodImpuesto").setValue("");
				this.child("fdbIva").setValue(0);
			}
			case 1: {
				this.child("fdbRecargo").setValue(0);
				break;
			}
		}
		this.child("fdbIRPF").setValue(irpf);
		this.child("fdbDtoPor").setValue(this.iface.calculateField("dtopor"));
		if (porComision) {
			this.child("fdbPorComision").setDisabled(true);
		} else {
			if (!codAgente || codAgente == "") {
				this.child("fdbPorComision").setDisabled(true);
			} else {
				this.child("fdbPorComision").setValue(this.iface.calculateField("porcomision"));
			}
		}
	}

	if (porComision) {
		this.child("fdbPorComision").setDisabled(true);
	}

	this.child("lblComision").setText(this.iface.calculateField("lblComision"));
	this.child("lblDtoPor").setText(this.iface.calculateField("lbldtopor"));
	
	var filtroReferencia:String = this.iface.dameFiltroReferencia();
	this.child("fdbReferencia").setFilter(filtroReferencia);
}

function interna_calculateField(fN:String):String
{
		return this.iface.commonCalculateField(fN, this.cursor());
		/** \C
		El --pvpunitario-- será el correspondiente al artículo según la tarifa asociada al cliente. Si no se ha especificado este dato, se tomará el pvp asociado al artículo.
		\end */
		/** \C
		El --pvpsindto-- será el producto del campo --cantidad-- por el campo --pvpunitario--
		\end */
		/** \C
		El --iva-- será el correspondiente al --codimpuesto-- en la tabla de impuestos
		\end */
		/** \C
		El --pvptotal-- será el --pvpsindto-- menos el --dtopor-- y menos el --dtolineal--
		\end */
		/** \Cvar util:FLUtil = new FLUtil();
		El --dtopor-- será el descuento asociado al cliente
		\end */
		/** \C
		El --recargo-- será el correspondiente al --codimpuesto-- en la tabla de impuestos en el caso de que el cliente tenga activado el campo Aplicar recargo de equivalencia en su correspondiente formulario.
		\end */
}

function interna_validateForm():Boolean
{
		var cursor:FLSqlCursor = this.cursor();

		/** \C
		La cantidad de artículos especificada será mayor o igual que la del --totalenalbaran--
		\end */
		if (parseFloat(cursor.valueBuffer("cantidad")) < parseFloat(cursor.valueBuffer("totalenalbaran"))) {
				var util:FLUtil = new FLUtil();
				MessageBox.critical(util.translate("scripts","La cantidad especificada no puede ser menor que la servida."),
						MessageBox.Ok, MessageBox.NoButton,MessageBox.NoButton);
				return false;
		}
		return true;
}

function interna_acceptedForm()
{
		disconnect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged");
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_desconectar()
{
		disconnect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged");
}

function oficial_bufferChanged(fN:String)
{
		this.iface.commonBufferChanged(fN, form);
		/** \C
		Al cambiar la --referencia-- se mostrarán los valores asociados de --pvpvunitario-- y --codimpuesto--
		\end */
		/** \C
		Al cambiar el --codimpuesto-- se mostrarán los valores asociados de --iva-- y --recargo--
		\end */
		/** \C
		Al cambiar la --cantidad-- o el --pvpunitario-- se mostrará el valor asociado de --pvpsindto--
		\end */
		/** \C
		Al cambiar el --pvpsindto--, el --dtopor-- o el --dtolineal-- se mostrará el valor asociado de --pvptotal--
		\end */
}

function oficial_commonBufferChanged(fN:String, miForm:Object)
{
	var cursor:FLSqlCursor = miForm.cursor();
	switch (fN) {
		case "referencia":{
			miForm.child("fdbPvpUnitario").setValue(this.iface.commonCalculateField("pvpunitario", miForm.cursor()));
			miForm.child("fdbCodImpuesto").setValue(this.iface.commonCalculateField("codimpuesto", miForm.cursor()));
			break;
		}
		case "codimpuesto":{
			miForm.child("fdbIva").setValue(this.iface.commonCalculateField("iva", miForm.cursor()));
			miForm.child("fdbRecargo").setValue(this.iface.commonCalculateField("recargo", miForm.cursor()));
			break;
		}
		case "cantidad":
		case "pvpunitario":{
			miForm.child("fdbPvpSinDto").setValue(this.iface.commonCalculateField("pvpsindto", miForm.cursor()));
			break;
		}
		case "pvpsindto":
		case "dtopor":{
			miForm.child("lblDtoPor").setText(this.iface.commonCalculateField("lbldtopor", miForm.cursor()));
		}
		case "dtolineal":{
			miForm.child("fdbPvpTotal").setValue(this.iface.commonCalculateField("pvptotal", miForm.cursor()));
			break;
		}
		case "pvptotal":
		case "porcomision": {
			var tabla:String = cursor.table();
			switch (tabla) {
				case "lineaspresupuestoscli":
				case "lineaspedidoscli":
				case "lineasalbaranescli":
				case "lineasfacturascli": {
					miForm.child("lblComision").setText(this.iface.commonCalculateField("lblComision", cursor));
					break;
				}
			}
			break;
		}
	}
}

/** \D Obtiene la tarifa asociada a un cliente
@param codCliente: código del cliente
@param cursor: Cursor del documento que busca la tarifa. Para sobreescribir
@return Código de la tarifa asociada o false si no tiene ninguna tarifa asociada
\end */
function oficial_obtenerTarifa(codCliente:String, cursor:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil;
	var codTarifa;
	switch (cursor.table()) {
		case "tpv_lineascomanda": {
			var curRel = cursor.cursorRelation();
			if (curRel && curRel.table() == "tpv_comandas") {
				codTarifa = curRel.valueBuffer("codtarifa");
			} else {
				codTarifa = util.sqlSelect("tpv_comandas", "codtarifa", "idtpv_comanda = " + cursor.valueBuffer("idtpv_comanda"));
			}
			break;
		}
		default: {
			codTarifa = util.sqlSelect("clientes c INNER JOIN gruposclientes gc ON c.codgrupo = gc.codgrupo", "gc.codtarifa", "codcliente = '" + codCliente + "'", "clientes,gruposclientes");
		}
	}
	return codTarifa;
}

function oficial_commonCalculateField(fN:String, cursor:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil();
	var datosTP:Array = this.iface.datosTablaPadre(cursor);
	if (!datosTP)
		return false;
	var wherePadre:String = datosTP.where;
	var tablaPadre:String = datosTP.tabla;
	
	var valor:String;
	switch (fN) {
		case "pvpunitario":{
			var codCliente:String = datosTP["codcliente"];
			var referencia:String = cursor.valueBuffer("referencia");
			var codTarifa:String = this.iface.obtenerTarifa(codCliente, cursor);
			if (codTarifa) {
				valor = util.sqlSelect("articulostarifas", "pvp", "referencia = '" + referencia + "' AND codtarifa = '" + codTarifa + "'");
			}
			if (!valor) {
				valor = util.sqlSelect("articulos", "pvp", "referencia = '" + referencia + "'");
			}
			var tasaConv:Number = datosTP["tasaconv"];
			valor = parseFloat(valor) / tasaConv;
			break;
		}
		case "pvpsindto":{
			valor = parseFloat(cursor.valueBuffer("pvpunitario")) * parseFloat(cursor.valueBuffer("cantidad"));
			valor = util.roundFieldValue(valor, "lineaspedidoscli", "pvpsindto");
			break;
		}
		case "iva": {
			valor = flfacturac.iface.pub_campoImpuesto("iva", cursor.valueBuffer("codimpuesto"), datosTP["fecha"]);
			if (isNaN(valor)) {
				valor = "";
			}
			break;
		}
		case "lbldtopor":{
			valor = (cursor.valueBuffer("pvpsindto") * cursor.valueBuffer("dtopor")) / 100;
			valor = util.roundFieldValue(valor, "lineaspedidoscli", "pvpsindto");
			break;
		}
		case "pvptotal":{
			var dtoPor:Number = (cursor.valueBuffer("pvpsindto") * cursor.valueBuffer("dtopor")) / 100;
			dtoPor = util.roundFieldValue(dtoPor, "lineaspedidoscli", "pvpsindto");
			valor = cursor.valueBuffer("pvpsindto") - parseFloat(dtoPor) - cursor.valueBuffer("dtolineal");
			valor = util.roundFieldValue(valor, cursor.table(), "pvptotal");
			break;
		}
		case "dtopor":{
			var codCliente:String = datosTP["codcliente"];
			valor = flfactppal.iface.pub_valorQuery("descuentosclientes,descuentos", "SUM(d.dto)", "descuentosclientes dc INNER JOIN descuentos d ON dc.coddescuento = d.coddescuento", "dc.codcliente = '" + codCliente + "';");
			break;
		}
		case "recargo":{
			var codCliente:String = datosTP["codcliente"];;
			var aplicarRecEq:Boolean = util.sqlSelect("clientes", "recargo", "codcliente = '" + codCliente + "'");
			if (aplicarRecEq == true) {
				valor = flfacturac.iface.pub_campoImpuesto("recargo", cursor.valueBuffer("codimpuesto"), datosTP["fecha"]);
			} else {
				valor = "";
			}
			if (isNaN(valor)) {
				valor = "";
			}
			break;
		}
		case "codimpuesto": {
			var codCliente:String = datosTP["codcliente"];;
			var codSerie:String = datosTP["codserie"];;
			if (flfacturac.iface.pub_tieneIvaDocCliente(codSerie, codCliente)) {
				valor = util.sqlSelect("articulos", "codimpuesto", "referencia = '" + cursor.valueBuffer("referencia") + "'");
			} else {
				valor = "";
			}
			break;
		}
		case "porcomision": {
			var porComisionPadre:String = datosTP["porcomision"];
			if (porComisionPadre) {
				valor = "";
				break;
			}
			var codAgente:String = datosTP["codagente"];
			if (!codAgente || codAgente == "") {
				valor = "";
				break;
			}
			var comisionAgente:Number = flfacturac.iface.pub_calcularComisionLinea(codAgente,cursor.valueBuffer("referencia"));
			comisionAgente = util.roundFieldValue(comisionAgente, cursor.table(), "porcomision");
			valor = comisionAgente.toString();
			break;
		}
		case "lblComision": {
			var porComision:Number = parseFloat(cursor.valueBuffer("porcomision"));
			if (!porComision) {
				break;
			}
			var pvpTotal:Number = parseFloat(cursor.valueBuffer("pvptotal"));
			var comision:Number = (porComision * pvpTotal) / 100;
			comision = util.roundFieldValue(comision, cursor.table(), "pvptotal");
			valor = comision.toString();
			break;
		}
	}
	return valor;
}

/** \D Devuelve la tabla padre de la tabla parámetro, así como la cláusula where necesaria para localizar el registro padre
@param	cursor: Cursor cuyo padre se busca
@return	Array formado por:
	* where: Cláusula where
	* tabla: Nombre de la tabla padre
o false si hay error
\end */
function oficial_datosTablaPadre(cursor:FLSqlCursor):Array
{
	var datos:Array;
	switch (cursor.table()) {
		case "lineaspresupuestoscli": {
			datos.where = "idpresupuesto = "+ cursor.valueBuffer("idpresupuesto");
			datos.tabla = "presupuestoscli";
			break;
		}
		case "lineaspedidoscli": {
			datos.where = "idpedido = "+ cursor.valueBuffer("idpedido");
			datos.tabla = "pedidoscli";
			break;
		}
		case "lineasalbaranescli": {
			datos.where = "idalbaran = "+ cursor.valueBuffer("idalbaran");
			datos.tabla = "albaranescli";
			break;
		}
		case "lineasfacturascli": {
			datos.where = "idfactura = "+ cursor.valueBuffer("idfactura");
			datos.tabla = "facturascli";
			break;
		}
		case "tpv_lineascomanda": {
			datos.where = "idtpv_comanda = "+ cursor.valueBuffer("idtpv_comanda");
			datos.tabla = "tpv_comandas";
			break;
		}
	}
	var curRel:FLSqlCursor = cursor.cursorRelation();
	if (curRel && curRel.table() == datos.tabla) {
		switch (cursor.table()) {
			case "tpv_lineascomanda": {
				datos["tasaconv"] = 1;
				datos["codserie"] = false;
				datos["porcomision"] = 0;
				datos["codagente"] = false;
				break;
			}
			default: {
				datos["tasaconv"] = curRel.valueBuffer("tasaconv");
				datos["codserie"] = curRel.valueBuffer("codserie");
				datos["porcomision"] = curRel.valueBuffer("porcomision");
				datos["codagente"] = curRel.valueBuffer("codagente");
			}
		}
		datos["codcliente"] = curRel.valueBuffer("codcliente");
		datos["fecha"] = curRel.valueBuffer("fecha");
	} else {
		var qryDatos:FLSqlQuery = new FLSqlQuery;
		qryDatos.setTablesList(datos.tabla);
		switch (cursor.table()) {
			case "tpv_lineascomanda": {
				qryDatos.setSelect("codcliente, fecha");
				break;
			}
			default: {
				qryDatos.setSelect("tasaconv, codcliente, fecha, codserie, porcomision, codagente");
			}
		}
		
		qryDatos.setFrom(datos.tabla);
		qryDatos.setWhere(datos.where);
		qryDatos.setForwardOnly(true);
		if (!qryDatos.exec()) {
			return false;
		}
		if (!qryDatos.first()) {
			return false;
		}
		switch (cursor.table()) {
			case "tpv_lineascomanda": {
				datos["tasaconv"] = 1;
				datos["codserie"] = false;
				datos["porcomision"] = 0;
				datos["codagente"] = false;
				break;
			}
			default: {
				datos["tasaconv"] = qryDatos.value("tasaconv");
				datos["codserie"] = qryDatos.value("codserie");
				datos["porcomision"] = qryDatos.value("porcomision");
				datos["codagente"] = qryDatos.value("codagente");
			}
		}
		datos["codcliente"] = qryDatos.value("codcliente");
		datos["fecha"] = qryDatos.value("fecha");
	}
	return datos;
}

function oficial_dameFiltroReferencia():String
{
	return "sevende";
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition ivaIncluido */
//////////////////////////////////////////////////////////////////
//// IVAINCLUIDO /////////////////////////////////////////////////////
function ivaIncluido_init()
{
	this.iface.__init();
	this.iface.habilitarPorIvaIncluido(form);
}

function ivaIncluido_habilitarPorIvaIncluido(miForm:Object)
{
	if (miForm.cursor().valueBuffer("ivaincluido")) {
		miForm.child("fdbPvpUnitarioIva").setDisabled(false);
		miForm.child("fdbPvpUnitario").setDisabled(true);
	} else {
		miForm.child("fdbPvpUnitarioIva").setDisabled(true);
		miForm.child("fdbPvpUnitario").setDisabled(false);
	}
}
	
function ivaIncluido_commonBufferChanged(fN:String, miForm:Object)
{
	var util:FLUtil = new FLUtil();
	
	switch (fN) {
		case "referencia":
			this.iface.bloqueoPrecio = true;
			var ivaIncluido:Boolean = this.iface.commonCalculateField("ivaincluido", miForm.cursor());
			miForm.child("fdbIvaIncluido").setValue(ivaIncluido);
			miForm.child("fdbCodImpuesto").setValue(this.iface.commonCalculateField("codimpuesto", miForm.cursor()));
	
			if (ivaIncluido) {
				miForm.child("fdbPvpUnitarioIva").setValue(this.iface.commonCalculateField("pvpunitarioiva", miForm.cursor()));
				miForm.cursor().setValueBuffer("pvpunitario", this.iface.commonCalculateField("pvpunitario2", miForm.cursor()));
			} else {
				miForm.cursor().setValueBuffer("pvpunitario", this.iface.commonCalculateField("pvpunitario", miForm.cursor()));
				miForm.child("fdbPvpUnitarioIva").setValue(this.iface.commonCalculateField("pvpunitarioiva2", miForm.cursor()));
			}
			this.iface.bloqueoPrecio = false;
			this.iface.habilitarPorIvaIncluido(miForm);
			break;
		case "codimpuesto":
			miForm.child("fdbIva").setValue(this.iface.commonCalculateField("iva", miForm.cursor()));
			miForm.child("fdbRecargo").setValue(this.iface.commonCalculateField("recargo", miForm.cursor()));
/*			if (!this.iface.bloqueoPrecio && miForm.cursor().valueBuffer("ivaincluido")) {
				this.iface.bloqueoPrecio = true;
				miForm.cursor().setValueBuffer("pvpunitario", this.iface.commonCalculateField("pvpunitario", miForm.cursor()));
				this.iface.bloqueoPrecio = false;
			}*/
			break;
		
		case "ivaincluido":
			this.iface.habilitarPorIvaIncluido(miForm);
		case "iva": {
			if (!this.iface.bloqueoPrecio) {
				this.iface.bloqueoPrecio = true;
				if (miForm.cursor().valueBuffer("ivaincluido")) {
					miForm.cursor().setValueBuffer("pvpunitario", this.iface.commonCalculateField("pvpunitario2", miForm.cursor()));
				} else {
					miForm.child("fdbPvpUnitarioIva").setValue(this.iface.commonCalculateField("pvpunitarioiva2", miForm.cursor()));
				}
				this.iface.bloqueoPrecio = false;
			}
			break;
		}
		case "recargo": {
			if (!this.iface.bloqueoPrecio) {
				this.iface.bloqueoPrecio = true;
				if (miForm.cursor().valueBuffer("ivaincluido")) {
					miForm.cursor().setValueBuffer("pvpunitario", this.iface.commonCalculateField("pvpunitario2", miForm.cursor()));
				} else {
					miForm.child("fdbPvpUnitarioIva").setValue(this.iface.commonCalculateField("pvpunitarioiva2", miForm.cursor()));
				}
				this.iface.bloqueoPrecio = false;
			}
			break;
		}
		case "pvpunitarioiva": {
			if (!this.iface.bloqueoPrecio) {
				this.iface.bloqueoPrecio = true;
				miForm.cursor().setValueBuffer("pvpunitario", this.iface.commonCalculateField("pvpunitario2", miForm.cursor()));
				this.iface.bloqueoPrecio = false;
			}
			break;
		}
		case "pvpunitario": {
			if (!this.iface.bloqueoPrecio) {
				this.iface.bloqueoPrecio = true;
				miForm.child("fdbPvpUnitarioIva").setValue(this.iface.commonCalculateField("pvpunitarioiva2", miForm.cursor()));
				this.iface.bloqueoPrecio = false;
			}
		}
		case "cantidad": {
			if (miForm.cursor().valueBuffer("ivaincluido")) {
				miForm.cursor().setValueBuffer("pvpsindto", this.iface.commonCalculateField("pvpsindto", miForm.cursor()));
			} else {
				return this.iface.__commonBufferChanged(fN, miForm);
			}
			break;
		}
		case "pvpsindto":
		case "dtopor": {
			miForm.child("lblDtoPor").setText(this.iface.commonCalculateField("lbldtopor", miForm.cursor()));
		}
		case "dtolineal": {
			if (miForm.cursor().valueBuffer("ivaincluido")) {
				miForm.cursor().setValueBuffer("pvptotal", this.iface.commonCalculateField("pvptotal", miForm.cursor()));
			} else {
				return this.iface.__commonBufferChanged(fN, miForm);
			}
			break;
		}
		default:
			return this.iface.__commonBufferChanged(fN, miForm);
	}
}

function ivaIncluido_commonCalculateField(fN, cursor):String 
{
	var util:FLUtil = new FLUtil();
	var valor:String;
	var referencia:String = cursor.valueBuffer("referencia");
	
	switch (fN) {
		case "pvpunitarioiva":
			valor = this.iface.__commonCalculateField("pvpunitario", cursor);
			break;
		case "pvpunitarioiva2": {
			var iva:Number = parseFloat(cursor.valueBuffer("iva"));
			if (isNaN(iva)) {
				iva = 0;
			}
			var recargo:Number = parseFloat(cursor.valueBuffer("recargo"));
			if (isNaN(recargo)) {
				iva = recargo;
			}
			iva += parseFloat(recargo);
			valor = cursor.valueBuffer("pvpunitario") * ((100 + iva) / 100);
			break;
		}
		case "pvpunitario2": {
			var iva:Number = parseFloat(cursor.valueBuffer("iva"));
			if (isNaN(iva)) {
				iva = 0;
			}
debug("iva " + iva);
			var recargo:Number = parseFloat(cursor.valueBuffer("recargo"));
			if (isNaN(recargo)) {
				recargo = 0;
			}
			iva += parseFloat(recargo);
debug("iva " + iva);
debug("pvp con iva " + cursor.valueBuffer("pvpunitarioiva"));
			valor = parseFloat(cursor.valueBuffer("pvpunitarioiva")) / ((100 + iva) / 100);
			break;
		}
		case "pvpsindto":
			valor = parseFloat(cursor.valueBuffer("pvpunitario")) * parseFloat(cursor.valueBuffer("cantidad"));
			break;
		
		case "ivaincluido":
			valor = util.sqlSelect("articulos", "ivaincluido", "referencia = '" + referencia + "'");
			break;
		
		case "pvptotal":{
debug("pvptotal iva incli");
			var dtoPor:Number = (cursor.valueBuffer("pvpsindto") * cursor.valueBuffer("dtopor")) / 100;
			dtoPor = util.roundFieldValue(dtoPor, "lineaspedidoscli", "pvpsindto");
			valor = cursor.valueBuffer("pvpsindto") - parseFloat(dtoPor) - cursor.valueBuffer("dtolineal");
debug("valor = " + valor);
			break;
		}
		default:
			return this.iface.__commonCalculateField(fN, cursor);
	}
	return valor;
}
//// IVAINCLUIDO /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////


/** @class_definition rappel */
/////////////////////////////////////////////////////////////////
//// RAPPEL /////////////////////////////////////////////////////
function rappel_init()
{
	this.iface.__init();
	this.child("lblDtoRappel").setText(this.iface.commonCalculateField("lbldtorappel", this.cursor()));
}

function rappel_commonBufferChanged(fN:String, miForm:Object)
{
	var util:FLUtil = new FLUtil();
	switch (fN) {
		case "referencia":
			miForm.child("fdbPvpUnitario").setValue(this.iface.commonCalculateField("pvpunitario", miForm.cursor()));
			var serie:String = miForm.cursor().cursorRelation().valueBuffer("codserie");
			var sinIva:Boolean = util.sqlSelect("series","siniva","codserie = '" + serie + "'");
			if(sinIva == false)
				miForm.child("fdbCodImpuesto").setValue(this.iface.commonCalculateField("codimpuesto", miForm.cursor()));
			miForm.child("fdbDtoRappel").setValue(this.iface.commonCalculateField("dtorappel", miForm.cursor()));
			this.iface.__commonBufferChanged(fN, miForm);
			break;
		case "dtorappel":
			miForm.child("fdbPvpTotal").setValue(this.iface.commonCalculateField("pvptotal", miForm.cursor()));
			miForm.child("lblDtoRappel").setText(this.iface.commonCalculateField("lbldtorappel", miForm.cursor()));
			break;
		case "cantidad":
			miForm.child("fdbPvpSinDto").setValue(this.iface.commonCalculateField("pvpsindto", miForm.cursor()));
			miForm.child("fdbDtoRappel").setValue(this.iface.commonCalculateField("dtorappel", miForm.cursor()));
			this.iface.__commonBufferChanged(fN, miForm);
			break;
		case "pvpsindto":
			miForm.child("fdbPvpTotal").setValue(this.iface.commonCalculateField("pvptotal", miForm.cursor()));
			miForm.child("lblDtoPor").setText(this.iface.commonCalculateField("lbldtopor", miForm.cursor()));
			miForm.child("lblDtoRappel").setText(this.iface.commonCalculateField("lbldtorappel", miForm.cursor()));
			this.iface.__commonBufferChanged(fN, miForm);
			break;
		default:
			this.iface.__commonBufferChanged(fN, miForm);
			break;
	}
}

function rappel_commonCalculateField(fN:String, cursor:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil();
	var valor:String;

	switch (fN) {
		case "dtorappel":
			var cantidad:String = parseFloat(cursor.valueBuffer("cantidad"));
			if (!cantidad || cantidad < 0)
				return 0;
			var referencia:String = cursor.valueBuffer("referencia");
			valor = util.sqlSelect("rappelarticulos", "descuento", "referencia = '" + referencia + "' AND limiteinferior <= " + cantidad + " AND limitesuperior >= " + cantidad );
			if (!valor) 
				valor = 0;
			break;
		case "lbldtorappel":
			valor = (parseFloat(cursor.valueBuffer("pvpsindto")) * parseFloat(cursor.valueBuffer("dtorappel"))) / 100;
			valor = util.roundFieldValue(valor, "lineaspedidoscli", "pvpsindto");
			break;
		case "pvptotal":
			var dtoPor:Number = (parseFloat(cursor.valueBuffer("pvpsindto")) * parseFloat(cursor.valueBuffer("dtopor"))) / 100;
			dtoPor = util.roundFieldValue(dtoPor, "lineaspedidoscli", "pvpsindto");
			var dtoRappel:Number = (parseFloat(cursor.valueBuffer("pvpsindto")) * parseFloat(cursor.valueBuffer("dtorappel"))) / 100;
			dtoRappel = util.roundFieldValue(dtoRappel, "lineaspedidoscli", "pvpsindto");
			valor = parseFloat(cursor.valueBuffer("pvpsindto")) - dtoPor - parseFloat(cursor.valueBuffer("dtolineal")) - dtoRappel;
			break;
		default:
			valor = this.iface.__commonCalculateField(fN, cursor);
			break;
	}
	return valor;
}

//// RAPPEL /////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
