/***************************************************************************
                 masterintervalos.qs  -  description
                             -------------------
    begin                : vie ene 27 2006
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
    function oficial( context ) { interna( context ); } 
	function rellenarIntervalos() {
		return this.ctx.oficial_rellenarIntervalos();
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
/** \C Si los datos de intervalos no están definidos, se insertan
\end */
function interna_init()
{
	var cursor:FLSqlCursor = this.cursor();
	if (cursor.size() <= 0) {
		this.iface.rellenarIntervalos();
		this.child("tableDBRecords").refresh();
	}
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Rellena la tabla con los posibles intervalos de fechas
*/
function oficial_rellenarIntervalos()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = new FLSqlCursor("intervalos");
	var intervalos:Array =
		[["000001", util.translate("scripts", "Hoy"), util.translate("scripts", "Muestra todos los informes con fecha de hoy"), "hoy = new Date();\n" +
			"intervalo.desde = hoy;\n" +
			"intervalo.hasta = hoy;\n" +
			"return intervalo;\n"],
		["000002", util.translate("scripts", "Ayer"), util.translate("scripts", "Muestra todos los informes con fecha de ayer"), "hoy = new Date();\n" +
			"intervalo.desde = util.addDays(hoy,-1);\n" + 
			"intervalo.hasta = util.addDays(hoy,-1);\n" + 
			"return intervalo;\n"],
		["000003", util.translate("scripts", "Esta semana"), util.translate("scripts", "Muestra todos los informes de esta semana"), "desde = new Date();\n" + 
			"dias = desde.getDay() -1;\n" + 
			"dias = dias * -1;\n" + 
			"intervalo.desde = util.addDays(desde, dias);\n" + 
			"intervalo.hasta = util.addDays(intervalo.desde,6);\n" + 
			"return intervalo;\n"],
		["000004", util.translate("scripts", "Semana pasada"), util.translate("scripts", "Muestra todos los informes de la semana pasada"), "desde = new Date();\n" +
			"dias = desde.getDay() -1;\n" +
			"dias = dias * -1;\n" +
			"intervalo.hasta = util.addDays(desde, dias -1);\n" +
			"intervalo.desde = util.addDays(intervalo.hasta,-6);\n" +
			"return intervalo;\n"],
		["000005", util.translate("scripts", "Este mes"), util.translate("scripts", "Muestra todos los informes de este mes"), "desde = new Date();\n" +
			"mes = desde.getMonth();\n" +
			"desde = desde.setDate(1);\n" +
			"intervalo.desde = desde;\n" +
			"ultimodia = new Date();\n" +
			"hasta = ultimodia.setDate(1);\n" +
			"hasta = util.addMonths(hasta, 1);\n" +
			"hasta = util.addDays(hasta,-1);\n" +
			"intervalo.hasta = hasta;\n" +
			"return intervalo;\n"],
		["000006", util.translate("scripts", "Mes pasado"), util.translate("scripts", "Muestra todos los informes del mes pasado"), "primerdia = new Date();\n" +
			"desde = primerdia.setDate(1);\n" +
			"desde = util.addMonths(desde, -1);\n" +
			"intervalo.desde = desde;\n" +
			"ultimodia = new Date();\n" +
			"hasta = ultimodia.setDate(1);\n" +
			"hasta = util.addDays(hasta,-1);\n" +
			"intervalo.hasta = hasta;\n" +
			"return intervalo;\n"],
		["000007", util.translate("scripts", "Este año"), util.translate("scripts", "Muestra todos los informes de este año"), "desde = new Date();\n" +
			"desde = desde.setMonth(1);\n" +
			"desde = desde.setDate(1);\n" +
			"intervalo.desde = desde;\n" +
			"hasta = new Date();\n" +
			"hasta = hasta.setMonth(12)\n" +
			"hasta = hasta.setDate(31);\n" +
			"intervalo.hasta = hasta;\n" +
			"return intervalo;\n"],
		["000008", util.translate("scripts", "Año pasado"), util.translate("scripts", "Muestra todos los informes del año pasado"), "desde = new Date();\n" +
			"anio = desde.getYear() - 1;\n" + 
			"desde = desde.setDate(1);\n" + 
			"desde = desde.setMonth(1);\n" + 
			"desde = desde.setYear(anio);\n" + 
			"intervalo.desde = desde;\n" + 
			"hasta = new Date();\n" + 
			"hasta = hasta.setMonth(12)\n" + 
			"hasta = hasta.setDate(31);\n" +
			"hasta = hasta.setYear(anio);\n" + 
			"intervalo.hasta = hasta;\n" + 
			"return intervalo;\n"],
		["000009", util.translate("scripts", "Siempre"), util.translate("scripts", "Muestra todos los informes existentes"), "intervalo.desde = '1970-01-01';\n" + 
			"intervalo.hasta = '3000-01-01';\n" + 
			"return intervalo;\n"],
		["000010", util.translate("scripts", "Hasta hoy"), util.translate("scripts", "Muestra todos los informes hasta la fecha de hoy"), "hoy = new Date();\n" + 
			"intervalo.desde = '1970-01-01';\n" + 
			"intervalo.hasta = hoy;\n" + 
			"return intervalo;\n"]];
	for (var i:Number = 0; i < intervalos.length; i++) {
		with(cursor) {
			setModeAccess(cursor.Insert);
			refreshBuffer();
			setValueBuffer("codigo", intervalos[i][0]);
			setValueBuffer("intervalo", intervalos[i][1]);
			setValueBuffer("descripcion", intervalos[i][2]);
			setValueBuffer("funcionintervalo", intervalos[i][3]);
			commitBuffer();
		}
	}
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
