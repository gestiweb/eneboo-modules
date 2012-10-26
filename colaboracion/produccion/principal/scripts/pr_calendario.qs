/***************************************************************************
                 pr_calendario.qs  -  description
                             -------------------
    begin                : mar jul 03 2007
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
	function init() { return this.ctx.interna_init(); }
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
    function oficial( context ) { interna( context ); }
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
	return true;
}

function interna_validateForm():Boolean
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil;

	if (util.sqlSelect("pr_calendario","fecha","fecha = '" + cursor.valueBuffer("fecha") + "'") && cursor.modeAccess() == cursor.Insert) {
		MessageBox.warning(util.translate("scripts", "Ya existe en registro con esa fecha"), MessageBox.Ok, MessageBox.NoButton)
		return false;
	}

	var horaEntradaManana:String = cursor.valueBuffer("horaentradamanana");
	var horaSalidaManana:String = cursor.valueBuffer("horasalidamanana");
	var horaEntradaTarde:String = cursor.valueBuffer("horaentradatarde");
	var horaSalidaTarde:String = cursor.valueBuffer("horasalidatarde");

//------ COMPROBAR QUE HAY HORAS ESTABLECIDAS ----------------------------------------------

	if (horaEntradaManana && horaEntradaManana != "" && horaEntradaManana != "null" && (!horaSalidaManana || horaSalidaManana == "" || horaSalidaManana == "null")) {
		MessageBox.warning(util.translate("scripts", "Debe establecer la hora de salida por la mañana"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	if (horaEntradaTarde && horaEntradaTarde != "" && horaEntradaTarde != "null" && (!horaSalidaTarde || horaSalidaTarde == "" || horaSalidaTarde == "null")) {
		MessageBox.warning(util.translate("scripts", "Debe establecer la hora de salida por la tarde"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	if (horaSalidaManana && horaSalidaManana != "" && horaSalidaManana != "null" && (!horaEntradaManana || horaEntradaManana == "" || horaEntradaManana == "null")) {
		MessageBox.warning(util.translate("scripts", "Debe establecer la hora de entrada por la mañana"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	if (horaSalidaTarde && horaSalidaTarde != "" && horaSalidaTarde != "null" && (!horaEntradaTarde || horaEntradaTarde == "" || horaEntradaTarde == "null")) {
		MessageBox.warning(util.translate("scripts", "Debe establecer la hora de entrada por la tarde"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
//--------------------------------------------------------------------------------------------

//------ COMPROBAR QUE LAS HORAS ESTAN BIEN ESTABLECIDAS -------------------------------------
	var comparacion:Number = flprodppal.iface.compararHoras(horaEntradaManana,horaSalidaManana);

	if (comparacion == 0 || comparacion == 1) {
		MessageBox.warning(util.translate("scripts", "La hora de salida por la mañana debe ser mayor que la hora de entrada"), MessageBox.Ok, MessageBox.NoButton)
		return false;
	}
	
	comparacion = flprodppal.iface.compararHoras(horaSalidaManana,horaEntradaTarde);

	if (comparacion == 0 || comparacion == 1) {
		MessageBox.warning(util.translate("scripts", "La hora de entrada por la tarde debe ser mayor que la hora de salida por la mañana"), MessageBox.Ok, MessageBox.NoButton)
		return false;
	}
	
	comparacion = flprodppal.iface.compararHoras(horaEntradaTarde,horaSalidaTarde);

	if (comparacion == 0 || comparacion == 1) {
		MessageBox.warning(util.translate("scripts", "La hora de salida por la tarde debe ser mayor que la hora de entrada"), MessageBox.Ok, MessageBox.NoButton)
		return false;
	}
//--------------------------------------------------------------------------------------------
	return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
