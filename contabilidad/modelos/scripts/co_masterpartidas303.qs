/***************************************************************************
                 co_masterpartidas303.qs  -  description
                             -------------------
    begin                : fri jan 30 2009
    copyright            : (C) 2009 by InfoSiAL S.L.
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
		this.ctx.interna_init();
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna 
{
	function oficial( context ) { interna( context ); } 
	function refrescarTotales() {
		return oficial_refrescarTotales();
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
/** \C El ejercicio por defecto al crear un nuevo modelo es el ejercicio marcado como actual en el formulario de empresa
\end */
function interna_init() 
{
	var cursor:FLSqlCursor = this.cursor();
	
	var campos:Array = ["codsubcuenta", "baseimponible", "iva", "debe", "haber", "concepto"];
	this.child("tableDBRecords").setReadOnly(true);
	this.child("tableDBRecords").setOrderCols(campos);
	this.child("tableDBRecords").refresh();

	this.iface.refrescarTotales();
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_refrescarTotales()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	var qryTotales:FLSqlQuery = new FLSqlQuery;
	qryTotales.setTablesList("co_partidas");
	qryTotales.setSelect("SUM(baseimponible), SUM(haber - debe)");
	qryTotales.setFrom("co_partidas");
	qryTotales.setWhere(cursor.mainFilter());
	qryTotales.setForwardOnly(true);
	if (!qryTotales.exec()) {
		return false;
	}
	if (qryTotales.first()) {
		this.child("ledBaseImponible").text = util.roundFieldValue(qryTotales.value("SUM(baseimponible)"), "co_partidas", "baseimponible");
		this.child("ledCuota").text = util.roundFieldValue(qryTotales.value("SUM(haber - debe)"), "co_partidas", "haber");
	} else {
		this.child("ledBaseImponible").text = util.roundFieldValue(0, "co_partidas", "baseimponible");
		this.child("ledCuota").text = util.roundFieldValue(0, "co_partidas", "haber");
	}
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
