/***************************************************************************
                 fechaejercicio.qs  -  description
                             -------------------
    begin                : mar ene 03 2006
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
	function init() { this.ctx.interna_init(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var tbnAceptar:Object;
    function oficial( context ) { interna( context ); } 
	function aceptarFormulario() {
		return this.ctx.oficial_aceptarFormulario();
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
/** \C
\end */
function interna_init()
{
	var util:FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var tipoDoc:String = cursor.valueBuffer("label");
	var label:String;
	var solucion:String;

	this.iface.tbnAceptar = this.child("tbnAceptar");
	this.child("pushButtonAccept").close();

	connect(this.iface.tbnAceptar, "clicked()", this, "iface.aceptarFormulario");

	switch (tipoDoc) {
		case "pedidoscli": {
			label = util.translate("scripts", "Pedidos de cliente");
			solucion = util.translate("scripts", "Escoja un ejercicio que contenga la fecha establecida o cambie el valor de la fecha")
			break;
		}
		case "albaranescli": {
			label = util.translate("scripts", "Albaranes de cliente");
			solucion = util.translate("scripts", "Escoja un ejercicio que contenga la fecha establecida o cambie el valor de la fecha")
			break;
		}
		case "facturascli": {
			label = util.translate("scripts", "Facturas de cliente");
			solucion = util.translate("scripts", "Escoja un ejercicio que contenga la fecha establecida o cambie el valor de la fecha")
			break;
		}
		case "albaranesprov": {
			label = util.translate("scripts", "Albaranes de proveedor");
			solucion = util.translate("scripts", "Escoja un ejercicio que contenga la fecha establecida o cambie el valor de la fecha")
			break;
		}
		case "facturasprov": {
			label = util.translate("scripts", "Facturas de proveedor");
			solucion = util.translate("scripts", "Escoja un ejercicio que contenga la fecha establecida o cambie el valor de la fecha")
			break;
		}
		case "pagosdevolcli": {
			label = util.translate("scripts", "Pagos y devoluciones de cliente");
			solucion = util.translate("scripts", "Escoja un ejercicio que contenga la fecha establecida")
			this.child("fdbFecha").setDisabled(true);
			break;
		}
		case "pagosdevolprov": {
			label = util.translate("scripts", "Pagos y devoluciones de proveedor");
			solucion = util.translate("scripts", "Escoja un ejercicio que contenga la fecha establecida")
			this.child("fdbFecha").setDisabled(true);
			break;
		}
	}
	
	label += "\n" + util.translate("scripts", "Los datos actuales de fecha y ejercicio del documento a generar no son coherentes:") + "\n" + util.translate("scripts", "Fecha: ") + util.dateAMDtoDMA(cursor.valueBuffer("fecha")) + "\n" + util.translate("scripts", "Ejercicio: ") + cursor.valueBuffer("codEjercicio") + "\n" + solucion;
	this.child("fdbLabel").setValue(label);
	this.child("fdbCodEjercicio").setFilter("estado = 'ABIERTO'");
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_aceptarFormulario()
{
	var util:FLUtil;

	var codEjercicio:String = this.cursor().valueBuffer("codEjercicio");
	var fecha:String = this.cursor().valueBuffer("fecha");

	if (!util.sqlSelect("ejercicios", "codejercicio", "codejercicio = '" + codEjercicio + "' AND '" + fecha + "' BETWEEN fechainicio AND fechafin")) {
		MessageBox.warning(util.translate("scripts", "La fecha establecida debe estar comprendida en el intervalo del ejercicio especificado."), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	
	this.child("pushButtonAccept").animateClick();
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
