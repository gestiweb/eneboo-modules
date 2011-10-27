/***************************************************************************
                 i_masterreciboscli.qs  -  description
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    function oficial( context ) { interna( context ); } 
	function lanzar() {
		return this.ctx.oficial_lanzar();
	}
	function obtenerOrden(nivel:Number, cursor:FLSqlCursor):String {
		return this.ctx.oficial_obtenerOrden(nivel, cursor);
	}
	function obtenerParamInforme():Array {
		return this.ctx.oficial_obtenerParamInforme();
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
	connect (this.child("toolButtonPrint"), "clicked()", this, "iface.lanzar()");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_lanzar()
{
	var cursor:FLSqlCursor = this.cursor();
	var pI = this.iface.obtenerParamInforme();
	if (!pI) {
		return;
	}

	flfactinfo.iface.pub_lanzarInforme(cursor, pI.nombreInforme, pI.orderBy, "", false, false, pI.whereFijo);
}

/** \D Obtiene un array con los parámetros necesarios para establecer el informe
@return	array de parámetros o false si hay error
\end */
function oficial_obtenerParamInforme():Array
{
	var paramInforme:Array = [];
	paramInforme["nombreInforme"] = false;
	paramInforme["orderBy"] = false;
	paramInforme["groupBy"] = false;
	paramInforme["etiquetas"] = false;
	paramInforme["impDirecta"] = false;
	paramInforme["whereFijo"] = false;
	paramInforme["nombreReport"] = false;
	paramInforme["numCopias"] = false;

	var cursor:FLSqlCursor = this.cursor();
	var seleccion:String = cursor.valueBuffer("id");
	if (!seleccion) {
		return false;
	}
	paramInforme.nombreInforme = cursor.action();
	paramInforme.orderBy = "";
	var o:String = "";
	for (var i:Number = 1; i < 3; i++) {
		o = this.iface.obtenerOrden(i, cursor);
		if (o) {
			if (paramInforme.orderBy == "")
				paramInforme.orderBy = o;
			else
				paramInforme.orderBy += ", " + o;
		}
	}
	
	var intervalo:Array = [];
	if (cursor.valueBuffer("codintervalo")){
		intervalo = flfactppal.iface.pub_calcularIntervalo(cursor.valueBuffer("codintervalo"));
		cursor.setValueBuffer("d_reciboscli_fecha",intervalo.desde);
		cursor.setValueBuffer("h_reciboscli_fecha",intervalo.hasta);
	}
	var intervalov:Array = [];
	if (cursor.valueBuffer("codintervalov")){
		intervalov = flfactppal.iface.pub_calcularIntervalo(cursor.valueBuffer("codintervalov"));
		cursor.setValueBuffer("d_reciboscli_fechav",intervalov.desde);
		cursor.setValueBuffer("h_reciboscli_fechav",intervalov.hasta);
	}
	
	var idRemesa:String = cursor.valueBuffer("idremesa");
	var masWhere:String;
	if (idRemesa && idRemesa != "") {
		masWhere += "idrecibo IN (SELECT idrecibo FROM pagosdevolcli WHERE idremesa = " + idRemesa + ")";
		paramInforme.whereFijo = masWhere;
	}
	
	return paramInforme;
}

function oficial_obtenerOrden(nivel:Number, cursor:FLSqlCursor):String
{
	var ret:String = "";
	var orden:String = cursor.valueBuffer("orden" + nivel.toString());
	switch(nivel) {
		case 1:
		case 2: {
			switch(orden) {
				case "Código": {
					ret += "reciboscli.codigo";
					break;
				}
				case "Cod.Cliente": {
					ret += "reciboscli.codcliente";
					break;
				}
				case "Cliente": {
					ret += "reciboscli.nombrecliente";
					break;
				}
				case "Fecha": {
					ret += "reciboscli.fecha";
					break;
				}
				case "Vencimiento": {
					ret += "reciboscli.fechav";
					break;
				}
				case "Importe": {
					ret += "reciboscli.importe";
					break;
				}
			}
			break;
		}
		break;
	}
	if (ret != "") {
		var tipoOrden:String = cursor.valueBuffer("tipoorden" + nivel.toString());
		switch(tipoOrden) {
			case "Descendente": {
				ret += " DESC";
				break;
			}
		}
	}

	if (nivel == 2 && orden != "Código") {
		if (ret == "") {
			ret +=  "reciboscli.codigo";
		} else {
			ret += ", reciboscli.codigo";
		}
	}
	return ret;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
