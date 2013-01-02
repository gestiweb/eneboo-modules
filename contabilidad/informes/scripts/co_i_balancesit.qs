/***************************************************************************
                 co_i_balancesit.qs  -  description
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
	function validateForm():Boolean { return this.ctx.interna_validateForm(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    function oficial( context ) { interna( context ); } 
	function bufferChanged(fN:String) {
			return this.ctx.oficial_bufferChanged(fN);
	}
	function unicoEjercicio() {
			return this.ctx.oficial_unicoEjercicio();
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
	var util:FLUtil = new FLUtil();
	this.child("fdbEjercicioAct").setDisabled(true);

	var cursor:FLSqlCursor = this.cursor();
	var ejercicioActual:String;
	var ejercicioAnterior:String;
	
	if (cursor.modeAccess() == cursor.Insert) {
		ejercicioActual = flfactppal.iface.pub_ejercicioActual();
		var fechaInicioActual:String = util.sqlSelect("ejercicios", "fechainicio", "codejercicio = '" + ejercicioActual + "'");
		ejercicioAnterior = util.sqlSelect("ejercicios", "codejercicio", "fechafin < '" + fechaInicioActual + "' ORDER BY fechafin DESC");
		if (!ejercicioAnterior) {
			ejercicioAnterior = ejercicioActual;
			//this.iface.unicoEjercicio();
		}
		this.child("fdbEjercicioAct").setValue(ejercicioActual);
		this.child("fdbEjercicioAnt").setValue(ejercicioAnterior);
	} else {
		ejercicioActual = this.child("fdbEjercicioAct").value();
		ejercicioAnterior = this.child("fdbEjercicioAnt").value();;
		if (ejercicioActual == ejercicioAnterior) {
			this.iface.unicoEjercicio();
		}
	}

	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	this.child("fdbDescripcion").setFocus();
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
		fechaDesde = this.child("fdbFechaDesdeAct").value();
		fechaHasta = this.child("fdbFechaHastaAct").value();

		if (util.daysTo(fechaDesde, fechaHasta) < 0) {
				MessageBox.critical
						(util.
						 translate("scripts",
											 "La fecha de inicio del ejercicio actual debe ser menor que la de fin"),
						 MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
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
				MessageBox.critical
						(util.
						 translate("scripts",
											 "Las fechas de inicio y fin del ejercicio actual deben estar dentro del propio intervalo del ejercicio"),
						 MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				return false;
		}

		if (!this.child("fdbEjercicioAnterior").value())
				return true;


		var ejercicioAnt:String = this.child("fdbEjercicioAnt").value();

		if (!flcontinfo.iface.pub_comprobarConsolidacion(ejercicioAct, ejercicioAnt)) {
				MessageBox.critical
						(util.
						 translate("scripts",
											 "Las subcuentas de los ejercicios deben tener la misma longitud"),
						 MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				return false;
		}

		fechaDesde = this.child("fdbFechaDesdeAnt").value();
		fechaHasta = this.child("fdbFechaHastaAnt").value();

		if (util.daysTo(fechaDesde, fechaHasta) < 0) {
				MessageBox.critical
						(util.
						 translate("scripts",
											 "La fecha de inicio del ejercicio anterior debe ser menor que la de fin"),
						 MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
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
				MessageBox.critical
						(util.
						 translate("scripts",
											 "Las fechas de inicio y fin del ejercicio anterior deben estar dentro del propio intervalo del ejercicio"),
						 MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				return false;
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
		var codEjercicio:String;

		switch (fN) {

/** \C
Al pulsar sobre --ejercicioanterior-- se habilitan o deshabilitan los campos de ejercicio anterior
\end */
		case "ejercicioanterior":
				if (this.child("fdbEjercicioAnterior").value()) {
						this.child("gbEjAnt").setDisabled(false);
						this.child("fdbConsolidar").setDisabled(false);
				} else {
						this.child("gbEjAnt").setDisabled(true);
						this.child("fdbConsolidar").setValue(false);
						this.child("fdbConsolidar").setDisabled(true);
				}

				break;
		}

}

/** \D Se ejecuta cuando sólo hay un ejercicio factible de aparecen en el formulario, esto es, cuando no hay ningún ejercicio anterior al actual. Se encarga de deshabilitar los campos de ejercicio anterior
\end */
function oficial_unicoEjercicio()
{
		this.child("gbEjAnt").setDisabled(true);
		this.child("fdbEjercicioAnterior").setValue(false);
		this.child("fdbEjercicioAnterior").setDisabled(true);
		this.child("fdbConsolidar").setDisabled(true);
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
