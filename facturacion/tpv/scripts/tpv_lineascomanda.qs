/***************************************************************************
                 tpv_lineascomanda.qs  -  description
                             -------------------
    begin                : lun ago 19 2005
    copyright            : Por ahora (C) 2005 by InfoSiAL S.L.
    email                : lveb@telefonica.net
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
	function calcularPvpTarifa(referencia:String, codTarifa:String):Number {
		return this.ctx.oficial_calcularPvpTarifa(referencia, codTarifa);
	}
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.oficial_commonCalculateField(fN, cursor);
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
	function pub_calcularPvpTarifa(referencia:String, codTarifa:String):Number {
		return this.calcularPvpTarifa(referencia, codTarifa);
	}
	function pub_commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.commonCalculateField(fN, cursor);
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
function interna_init()
{
	var cursor:FLSqlCursor = this.cursor();
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(form, "closed()", this, "iface.desconectar");

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
		this.child("fdbDtoPor").setValue(this.iface.calculateField("dtopor"));
	}

	this.child("lblDtoPor").setText(this.iface.calculateField("lbldtopor"));
}

function interna_calculateField(fN:String):String
{
	return this.iface.commonCalculateField(fN, this.cursor());
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_commonCalculateField(fN:String, cursor:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil();
	var valor:String;

	switch (fN) {
		/** \C
		El --pvpunitario-- se calcula como el pvp establecido para el artículo seleccionado
		*/
		case "pvpunitario":{
			valor = this.iface.calcularPvpTarifa(cursor.valueBuffer("referencia"), cursor.cursorRelation().valueBuffer("codtarifa"));
			valor = util.roundFieldValue(valor, "tpv_lineascomanda", "pvpunitario");
			break;
		}
		/** \C
		El --pvpsindto-- es el el --pvpunitario-- multiplicado por la --cantidad--
		*/
		case "pvpsindto":{
			valor = parseFloat(cursor.valueBuffer("pvpunitario")) * parseFloat(cursor.valueBuffer("cantidad"));
			valor = util.roundFieldValue(valor, "tpv_lineascomanda", "pvpsindto");
			break;
		}
		case "iva":{
			var fecha:String;
			var curComanda:FLSqlCursor = cursor.cursorRelation();
			if (curComanda) {
				fecha = curComanda.valueBuffer("fecha");
			} else {
				fecha = util.sqlSelect("tpv_comandas", "fecha", "idtpv_comanda = " + cursor.valueBuffer("idtpv_comanda"));
			}
			valor = flfacturac.iface.pub_campoImpuesto("iva", cursor.valueBuffer("codimpuesto"), fecha);
			if (!valor) {
				valor = 0;
			}
			break;
		}
		/** \C
		El descuento se calcula como el --pvpsindto-- por el porcentaje de descuento
		*/
		case "lbldtopor":{
			valor = (cursor.valueBuffer("pvpsindto") * cursor.valueBuffer("dtopor")) / 100;
			valor = util.roundFieldValue(valor, "tpv_lineascomanda", "pvpsindto");
			break;
		}
		/** \C
		El --pvptotal-- es el --pvpsindto-- menos el descuento menos el descuento lineal
		*/
		case "pvptotal": {
			var dtoPor:Number = (cursor.valueBuffer("pvpsindto") * cursor.valueBuffer("dtopor")) / 100;
			dtoPor = util.roundFieldValue(dtoPor, "tpv_lineascomanda", "pvpsindto");
			valor = cursor.valueBuffer("pvpsindto") - parseFloat(dtoPor) - cursor.valueBuffer("dtolineal");
			break;
		}
		case "dtopor":{
			valor = cursor.valueBuffer("dtopor");
			break;
		}
		case "codimpuesto": {
			var codSerie:String = "";
			if (flfacturac.iface.pub_tieneIvaDocCliente(codSerie, cursor.cursorRelation().valueBuffer("codcliente"))) {
				valor = util.sqlSelect("articulos", "codimpuesto", "referencia = '" + cursor.valueBuffer("referencia") + "'");
			}
			else {
				valor = "";
			}
			break;
		}
		case "recargo":{
			var codCliente:String = cursor.cursorRelation().valueBuffer("codcliente");
			var aplicarRecEq:Boolean = util.sqlSelect("clientes", "recargo", "codcliente = '" + codCliente + "'");
			if (aplicarRecEq == true) {
				valor = flfacturac.iface.pub_campoImpuesto("recargo", cursor.valueBuffer("codimpuesto"), cursor.cursorRelation().valueBuffer("fecha"));
			} else {
				valor = "";
			}
			if (isNaN(valor)) {
				valor = "";
			}
			break;
		}
	}
	return valor;
}

/** \D
Desconecta la función bufferChanged conectada en el init
*/
function oficial_desconectar()
{
		disconnect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged");
}

function oficial_bufferChanged(fN:String)
{
	switch (fN) {
		/** \C
		Al cambiar la referencia se recalculan el --pvpunitario-- y el --codimpuesto--
		*/
		case "referencia":{
			this.child("fdbPvpUnitario").setValue(this.iface.calculateField("pvpunitario"));
			this.child("fdbCodImpuesto").setValue(this.iface.calculateField("codimpuesto"));
			break;
		}
		/** \C
		Al cambiar el --codimpuesto-- se recalcula el porcentaje de iva que se aplicará
		*/
		case "codimpuesto":{
			this.child("fdbIva").setValue(this.iface.calculateField("iva"));
			this.child("fdbRecargo").setValue(this.iface.calculateField("recargo"));
			break;
		}
		/** \C
		Al cambiar la --cantidad-- o el --pvpunitario-- se recalcula el --pvpsindto--
		*/
		case "cantidad":
		case "pvpunitario":{
			this.child("fdbPvpSinDto").setValue(this.iface.calculateField("pvpsindto"));
			break;
		}
		case "pvpsindto":
		case "dtopor":{
			this.child("lblDtoPor").setText(this.iface.calculateField("lbldtopor"));
		}
		/** \C
		Al cambiar el --dtolineal-- se recalcula el --pvptotal--
		*/
		case "dtolineal":{
			this.child("fdbPvpTotal").setValue(this.iface.calculateField("pvptotal"));
			break;
		}
	}
}

/** \D
Calcula el --pvpunitario-- aplicandole la tarifa establecida el el formulario de edición de comandas
@param referencia identificador del artíuclo
@param codTarifa identificador de la tarifa
@return devuelve el pvp del articulo con la tarifa apliada si la tiene o el pvp del artículo si no hay ninguna tarifa especificada
*/
function oficial_calcularPvpTarifa(referencia:String, codTarifa:String):Number
{
	var util:FLUtil = new FLUtil();
	var pvp:Number;

	if (codTarifa)
		pvp = util.sqlSelect("articulostarifas", "pvp", "referencia = '" + referencia + "' AND codtarifa = '" + codTarifa + "'");
		
	if (!pvp)
		pvp = util.sqlSelect("articulos", "pvp", "referencia = '" + referencia + "'");
	
	return pvp;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////