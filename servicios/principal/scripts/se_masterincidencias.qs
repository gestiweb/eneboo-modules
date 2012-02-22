/***************************************************************************
                 se_masterincidencias.qs  -  description
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var filtroInicial_:String;
    function oficial( context ) { interna( context ); } 
	function filtroIncidencias() {
		return this.ctx.oficial_filtroIncidencias();
	}
	function toolButtonPrint_clicked() {
		return this.ctx.oficial_toolButtonPrint_clicked();
	}
	function crearLineaCreditos() {
		return this.ctx.oficial_crearLineaCreditos();
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
	var cursor:FLSqlCursor = this.cursor();

	connect(this.child("chkPendientes"), "clicked()", this, "iface.filtroIncidencias");
	connect(this.child("toolButtonPrint"), "clicked()", this, "iface.toolButtonPrint_clicked");
	this.child("chkPendientes").checked = false;

	this.iface.filtroInicial_ = cursor.mainFilter();
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Filtra las tabla de incidencias por incidencias pendientes si está activa la opcion de SóloPendientes y refresca la tabla
\end */
function oficial_filtroIncidencias()
{
	var cursor:FLSqlCursor = this.cursor();

	var filtro:String = this.iface.filtroInicial_;
	if (this.child("chkPendientes").checked) {
		if (filtro != "") {
			filtro += " AND ";
		}
		filtro += "estado = 'Pendiente'";
	}
	cursor.setMainFilter(filtro);
	this.child("tableDBRecords").refresh();
}

function oficial_toolButtonPrint_clicked()
{
// 	this.iface.crearLineaCreditos();
}

function oficial_crearLineaCreditos()
{
	var util:FLUtil = new FLUtil;
	var qryIncidencias:FLSqlQuery = new FLSqlQuery();
	qryIncidencias.setTablesList("se_incidencias");
	qryIncidencias.setSelect("horas, precio, codigo, codencargado, fechaapertura");
	qryIncidencias.setFrom("se_incidencias");
	qryIncidencias.setWhere("precio < 0");
	qryIncidencias.setForwardOnly(true);
	if (!qryIncidencias.exec()) {
		return false;
	}
	util.createProgressDialog("Procesando...", qryIncidencias.size());
	var i:Number = 0;
	var curHF:FLSqlCursor = new FLSqlCursor("se_horasfacturadas");
	while (qryIncidencias.next()) {
		if (qryIncidencias.value("codencargado") == "NULL") {
			continue;
		}
		curHF.setModeAccess(curHF.Insert);
		curHF.refreshBuffer();
		curHF.setValueBuffer("fecha", qryIncidencias.value("fechaapertura"));
		curHF.setValueBuffer("codincidencia", qryIncidencias.value("codigo"));
		curHF.setValueBuffer("codencargado", qryIncidencias.value("codencargado"));
		curHF.setValueBuffer("horas", qryIncidencias.value("horas"));
		curHF.setValueBuffer("precio", -1 * qryIncidencias.value("precio"));
		curHF.setValueBuffer("referencia", "HORADESARROLLO");
		util.setProgress(i++);
		if (!curHF.commitBuffer()) {
			util.destroyProgressDialog();
			return false;
		}
	}
	util.destroyProgressDialog();
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
