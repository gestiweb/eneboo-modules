/***************************************************************************
                 co_i_cuentasanuales.qs  -  description
                             -------------------
    begin                : vie nov 09 2007
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
	function validateForm():Boolean { return this.ctx.interna_validateForm(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna 
{
    function oficial( context ) { interna( context ); } 
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function recalcularDatos() {
		return this.ctx.oficial_recalcularDatos();
	}
	function filtroDatos() {
		return this.ctx.oficial_filtroDatos();
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
Si no existe otro ejercicio más antiguo que el actual, los campos de ejercicio anterior aparecerán deshabilitados. Si existe algún ejercicio previo al actual, aparecerá como ejercicio anterior en el formulario aquel ejercicio más reciente de entre los pasados.
\end */
function interna_init()
{
	this.child("fdbEjercicioAct").setFilter("plancontable = '08'");
	this.child("fdbEjercicioAnt").setFilter("plancontable = '08'");
	
	connect(this.child("pbnRecalcular"), "clicked()", this, "iface.recalcularDatos");
	
	this.iface.filtroDatos();
}

/** \C 
La fecha de inicio del período de un ejercicio no puede ser posterior que la fecha de fin

Las fechas deben estar comprendidas dentro del período de cada ejercicio

Para poder realizar el balance sobre más de un ejercicio es necesario que ambos tengan igual número de dígitos en las subcuentas
\end */
function interna_validateForm():Boolean
{
	var fechaDesde:String;
	var fechaHasta:String;
	var fechaInicio:String;
	var fechaFin:String;

	var fechaInicioAct:String;
	var fechaFinAnt:String;

	var util:FLUtil = new FLUtil();
	var q:FLSqlQuery = new FLSqlQuery();

	var ejercicioAct:String = this.child("fdbEjercicioAct").value();
	if (!ejercicioAct)
		return true;
	
	fechaDesde = this.child("fdbFechaDesdeAct").value();
	fechaHasta = this.child("fdbFechaHastaAct").value();

	if (util.daysTo(fechaDesde, fechaHasta) < 0) {
		MessageBox.critical(util.translate("scripts", "La fecha de inicio del ejercicio actual debe ser menor que la de fin"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	q.setTablesList("ejercicios");
	q.setSelect("fechainicio, fechafin");
	q.setFrom("ejercicios");
	q.setWhere("codejercicio = '" + ejercicioAct + "';");

	q.exec();

	if (q.next()) {
		fechaInicio = q.value(0);
		fechaFin = q.value(1);
		fechaFinAnt = fechaFin;
	}

	if ((util.daysTo(fechaHasta, fechaFin) < 0) || (util.daysTo(fechaDesde, fechaInicio) > 0)) {
		MessageBox.critical(util.translate("scripts", "Las fechas de inicio y fin del ejercicio actual deben estar dentro del propio intervalo del ejercicio"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	var ejercicioAnt:String = this.child("fdbEjercicioAnt").value();
	if (!ejercicioAnt)
		return true;

	if (!flcontinfo.iface.pub_comprobarConsolidacion(ejercicioAct, ejercicioAnt)) {
		MessageBox.critical(util.translate("scripts", "Las subcuentas de los ejercicios deben tener la misma longitud"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	fechaDesde = this.child("fdbFechaDesdeAnt").value();
	fechaHasta = this.child("fdbFechaHastaAnt").value();

	if (util.daysTo(fechaDesde, fechaHasta) < 0) {
		MessageBox.critical(util.translate("scripts", "La fecha de inicio del ejercicio anterior debe ser menor que la de fin"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	q.setTablesList("ejercicios");
	q.setSelect("fechainicio, fechafin");
	q.setFrom("ejercicios");
	q.setWhere("codejercicio = '" + ejercicioAnt + "';");
	q.exec();

	if (q.next()) {
		fechaInicio = q.value(0);
		fechaFin = q.value(1);
		fechaFinAnt = fechaFin;
	}

	if ((util.daysTo(fechaHasta, fechaFin) < 0) || (util.daysTo(fechaDesde, fechaInicio) > 0)) {
		MessageBox.critical(util.translate("scripts", "Las fechas de inicio y fin del ejercicio anterior deben estar dentro del propio intervalo del ejercicio"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial*/
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_recalcularDatos()
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	
	if (cursor.modeAccess() == cursor.Insert) {
		var curD:FLSqlCursor = this.child("tdbDatos08").cursor();
		curD.setModeAccess(curD.Insert);
		if (!curD.commitBufferCursorRelation())
			return;
	}
	
	this.child("tdbDatos08").cursor().setMainFilter("");
	flcontinfo.iface.recalcularDatosBalance(cursor);
	this.iface.filtroDatos();
	
	MessageBox.information(util.translate("scripts", "Se recalcularon los datos del balance"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
}

function oficial_filtroDatos()
{
	var filtro:String = "";
	switch(this.cursor().valueBuffer("tipo")) {
		case "Situacion":
			filtro = "codbalance LIKE 'A-%' OR codbalance LIKE 'P-%'"
		break;
		case "Perdidas y ganancias":
			filtro = "codbalance LIKE 'PG-%'"
		break;		
			filtro = "codbalance LIKE 'IG-%'"
		break;		
	}
	
// 	this.child("tdbDatos08").cursor().setMainFilter(filtro);

	this.child("tdbDatos08").refresh();
	this.child("tdbSubtotales").refresh();
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
