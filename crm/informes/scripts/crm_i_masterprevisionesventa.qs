/***************************************************************************
                 crm_i_masterprevisionesventa.qs  -  description
                             -------------------
    begin                : lun oct 30 2006
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var tbnImprimir:Object;
    function oficial( context ) { interna( context ); }
	function lanzar() {
		return this.ctx.oficial_lanzar();
	}
	function datosCabecera(nodo:FLDomNode, campo:String):String {
		return this.ctx.oficial_datosCabecera(nodo, campo);
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
	function pub_datosCabecera(nodo:FLDomNode, campo:String):String {
		return this.datosCabecera(nodo, campo);
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
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	this.iface.tbnImprimir = this.child("toolButtonPrint");

	connect(this.iface.tbnImprimir, "clicked()", this, "iface.lanzar()");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_lanzar()
{
	var cursor:FLSqlCursor = this.cursor()
	var seleccion:String = cursor.valueBuffer("id");
	if (!seleccion)
		return;
	
	var intervalo:Array = [];
	if (cursor.valueBuffer("codintervalo")){
		intervalo = flfactppal.iface.pub_calcularIntervalo(cursor.valueBuffer("codintervalo"));
		cursor.setValueBuffer("d_crm__oportunidadventa_fechacierre", intervalo.desde);
		cursor.setValueBuffer("h_crm__oportunidadventa_fechacierre", intervalo.hasta);
	}
		
	flfactinfo.iface.pub_lanzarInforme(cursor, "crm_i_previsionesventa");
}

function oficial_datosCabecera(nodo:FLDomNode, campo:String):String
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var valor:String;
	switch (campo) {
		case "intervalo": {
			valor = cursor.valueBuffer("codintervalo");
			var fechaDesde:String = cursor.valueBuffer("d_crm__oportunidadventa_fechacierre");
			var fechaHasta:String = cursor.valueBuffer("h_crm__oportunidadventa_fechacierre");
			if (fechaDesde && fechaDesde != "") {
				fechaDesde = util.dateAMDtoDMA(fechaDesde);
				fechaDesde = fechaDesde.left(10);
			}
			if (fechaHasta && fechaHasta != "") {
				fechaHasta = util.dateAMDtoDMA(fechaHasta);
				fechaHasta = fechaHasta.left(10);
			}
			if (valor && valor != "")
				valor = util.sqlSelect("intervalos", "intervalo", "codigo = '" + valor + "'") + " (" + fechaDesde + " / " + fechaHasta + ")";
			else
				valor = fechaDesde + " / " + fechaHasta;
			break;
		}
	}
	return valor;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
