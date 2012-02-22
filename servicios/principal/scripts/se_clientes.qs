/***************************************************************************
                 se_clientes.qs  -  description
                             -------------------
    begin                : lun jun 20 2005
    copyright            : (C) 2005 by InfoSiAL S.L.
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
    function init() { this.ctx.interna_init(); }
	function responderMail() {
		return this.ctx.oficial_responderMail();
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    function oficial( context ) { interna( context ); } 
	function cambioChkPendientes() {	return this.ctx.oficial_cambioChkPendientes(); }
	function calcularSaldo() {	
		return this.ctx.oficial_calcularSaldo(); 
	}
	function accionesAutomaticas() {
		return this.ctx.oficial_accionesAutomaticas();
	}
	function realizarAccionAutomatica(accion:Array):Boolean {
		return this.ctx.oficial_realizarAccionAutomatica(accion);
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
En la pestaña incidencias podemos ver sólo las incedencias pendientes
seleccionando la opción Sólo Pendientes
*/
function interna_init()
{
	connect(this.child("chkPendientes"), "clicked()", this, "iface.cambioChkPendientes");
	connect(this.child("pbnResponder"), "clicked()", this, "iface.responderMail" );
	connect(this, "formReady()", this, "iface.accionesAutomaticas");

	this.child("chkPendientes").checked = false;
	this.iface.calcularSaldo();
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Filtra las tabla de incidencias por incidencias pendientes de ese subproyecto si está activa la opcion de SóloPendientes, si no lo está la filta mostrando todas las incidencias del subproyecto y refresca la tabla
\end */
function oficial_cambioChkPendientes()
{ 
	if(this.child("chkPendientes").checked == true)
		this.child("tblIncidencias").cursor().setMainFilter("estado = 'Pendiente' AND codcliente = '" + this.child("fdbCodCliente").value() + "'");
	else
		this.child("tblIncidencias").cursor().setMainFilter("codcliente = '" + this.child("fdbCodCliente").value() + "'");
	this.child("tblIncidencias").refresh();
}

/** \D Lanza la respuesta a una comunicación seleccionada en el formulario maestro.
El id de dicha comunicacion queda registrado en la variable codigoConResp, y a continuación
se abre el formulario de inserción de una nueva comunicación.
\end */
function oficial_responderMail()
{
	var util:FLUtil = new FLUtil();
	var curCom:FLSqlCursor = this.child("tdbComunicaciones").cursor();	

 	util.writeSettingEntry("scripts/flservppal/codigoComResp", curCom.valueBuffer("codigo"));
	
	this.child("toolButtomInsertCom").animateClick();
}	

function oficial_calcularSaldo()
{
	var cursor:FLSqlCursor = this.cursor();
	var saldo:Number = flservppal.iface.pub_calcularSaldoCliente(cursor.valueBuffer("codcliente"));
	if (isNaN(saldo)) {
		return false;
	}
	cursor.setValueBuffer("saldocreditos", saldo);
}

function oficial_accionesAutomaticas()
{
	var acciones:Array = flcolaproc.iface.pub_accionesAuto();
	if (!acciones) {
		return;
	}
	var i:Number = 0;
	while (i < acciones.length && acciones[i]["usada"]) { i++; }
	if (i == acciones.length) {
		return;
	}

	while (i < acciones.length && acciones[i]["contexto"] == "se_clientes") {
		if (!this.iface.realizarAccionAutomatica(acciones[i])) {
			break;
		}
		i++;
	}
}

/** \D Realizar una determinada acción.
@return: Se devuelve false si algo falla o si la acción implica que no debe realizarse ninguna acción subsiguiente en el contexto actual.
\end */ 
function oficial_realizarAccionAutomatica(accion:Array):Boolean
{
debug("oficial_realizarAccionAutomatica " + accion["accion"]);
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	switch (accion["accion"]) {
		case "insertar_comunicacion": {
			accion["usada"] = true;
			var curComunicaciones:FLSqlCursor = this.child("tdbComunicaciones").cursor();
			curComunicaciones.insertRecord();
			break;
		}
		case "insertar_incidencia": {
debug("En insertar_incidencia");
			accion["usada"] = true;
			var curIncidencias:FLSqlCursor = this.child("tdbIncidencias").cursor();
			curIncidencias.insertRecord();
			break;
		}
		default: {
			return false;
		}
	}
	return true;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
