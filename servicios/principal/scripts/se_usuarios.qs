/***************************************************************************
                 se_usuarios.qs  -  description
                             -------------------
    begin                : lun jun 21 2005
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
    function oficial( context ) { interna( context ); } 
	function ultimaComunicacion() { return this.ctx.oficial_ultimaComunicacion(); }
	
	function calcularPrev() {
		this.ctx.oficial_calcularPrev();
	}
	function obtenerHtmlPrev():String {
		return this.ctx.oficial_obtenerHtmlPrev();
	}
	function refrescarFiltro() {
		return this.ctx.oficial_refrescarFiltro();
	}
	function tbnRecalcularPlan_clicked() {
		return this.ctx.oficial_tbnRecalcularPlan_clicked();
	}
	function tbnSubirOrden_clicked() {
		return this.ctx.oficial_tbnSubirOrden_clicked();
	}
	function tbnBajarOrden_clicked() {
		return this.ctx.oficial_tbnBajarOrden_clicked();
	}
	function desplazarOrden(direccion:Number) {
		return this.ctx.oficial_desplazarOrden(direccion);
	}
	function revisarPlan():Boolean {
		return this.ctx.oficial_revisarPlan();
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
El formulario de edición de ususarios muestra los subproyectos y las incidencias de cada usuario
Permite ver también la su última comunicación
\end */
function interna_init()
{
	var util:FLUtil = new FLUtil();
	
	connect(this.child("chkPendientes"),"clicked()", this, "iface.refrescarFiltro");
	connect(this.child("tbnRecalcularPlan"),"clicked()", this, "iface.tbnRecalcularPlan_clicked");
	connect(this.child("tbnBajarOrden"),"clicked()", this, "iface.tbnBajarOrden_clicked");
	connect(this.child("tbnSubirOrden"),"clicked()", this, "iface.tbnSubirOrden_clicked");
	connect(this.child("tdbIncidencias").cursor(), "bufferCommited()", this, "iface.revisarPlan");
	
	var campos:Array = ["orden", "fechaestimada", "fechaplan", "atiempo", "desccorta", "horasplan", "horasporhacer", "horashechas"];
	this.child("tdbIncidencias").setOrderCols(campos);

	if (!this.iface.revisarPlan()) {
		return false;
	}

	this.iface.refrescarFiltro();
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_refrescarFiltro()
{
	var filtro:String = "";
	if (this.child("chkPendientes").checked) {
		filtro = "estado = 'Pendiente'";
	} else {
		filtro = "1 = 1";
	}
	this.child("tdbIncidencias").setFilter(filtro);
	this.child("tdbIncidencias").refresh();
}

function oficial_tbnRecalcularPlan_clicked()
{
	var util:FLUtil = new FLUtil;

	if (!this.iface.revisarPlan()) {
		return false;
	}
	this.child("tdbIncidencias").refresh();
}

function oficial_tbnSubirOrden_clicked()
{
	this.iface.desplazarOrden(-1);
}

function oficial_tbnBajarOrden_clicked()
{
	this.iface.desplazarOrden(1);
}

function oficial_desplazarOrden(direccion:Number)
{
	var cursor:FLSqlCursor = this.cursor();

	var tdbIncidencias:Object = this.child("tdbIncidencias");
	var cursorTabla:FLSqlCursor = tdbIncidencias.cursor();
	if (!cursorTabla.isValid()) {
		return;
	}
	
	var codEncargado:String = cursor.valueBuffer("codigo");
	if (!codEncargado) {
		return;
	}
	
	var orden1:Number = cursorTabla.valueBuffer("orden");
	var codIncidencia1:String = cursorTabla.valueBuffer("codigo");
	var codIncidencia2:String;
	var orden2:Number;
	var row:Number = tdbIncidencias.currentRow();
	var util:FLUtil = new FLUtil();

	if (direccion == -1) {
		codIncidencia2 = util.sqlSelect("se_incidencias", "codigo", "codencargado = '" + codEncargado + "' AND estado = 'Pendiente' AND orden < " + orden1 + " ORDER BY orden DESC");
	} else {
		codIncidencia2 = util.sqlSelect("se_incidencias", "codigo", "codencargado = '" + codEncargado + "' AND estado = 'Pendiente' AND orden > " + orden1 + " ORDER BY orden ASC");
	}

	if (!codIncidencia2) {
		return;
	}

	var curIncidencia:FLSqlCursor = new FLSqlCursor("se_incidencias");
	curIncidencia.setActivatedCheckIntegrity(false);
	curIncidencia.setActivatedCommitActions(false);
	curIncidencia.select("codigo = '" + codIncidencia2 + "'");
	if (!curIncidencia.first()) {
		return;
	}
	curIncidencia.setModeAccess(curIncidencia.Edit);
	curIncidencia.refreshBuffer();
	orden2 = curIncidencia.valueBuffer("orden");
	curIncidencia.setValueBuffer("orden", orden1);
	curIncidencia.commitBuffer();

	curIncidencia.select("codigo = '" + codIncidencia1 + "'");
	if (!curIncidencia.first()) {
		return;
	}
	curIncidencia.setModeAccess(curIncidencia.Edit);
	curIncidencia.refreshBuffer();
	curIncidencia.setValueBuffer("orden", orden2);
	curIncidencia.commitBuffer();

	if (!this.iface.revisarPlan()) {
		return false;
	}
	tdbIncidencias.refresh();
	row += direccion;
	tdbIncidencias.setCurrentRow(row);
}

function oficial_revisarPlan():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var codEncargado:String = cursor.valueBuffer("codigo");
	if (!codEncargado) {
		return;
	}

	var horasIncidencia:Number;
	var horasOcupadas:Number = 0;
	var horasDia:Number = cursor.valueBuffer("horasplan");
	var horasDisponibles:Number;
	var diaHabil:Boolean;
	var hoy:Date = new Date;
	
	var qryCalendario:FLSqlQuery = new FLSqlQuery;
	qryCalendario.setTablesList("calendariolab");
	qryCalendario.setSelect("fecha, totalhoras");
	qryCalendario.setFrom("calendariolab");
	qryCalendario.setWhere("fecha > '" + hoy.toString() + "' ORDER BY fecha");
	qryCalendario.setForwardOnly(true);
	if (!qryCalendario.exec()) {
		return false;
	}
	if (!qryCalendario.first()) {
		MessageBox.warning(util.translate("scripts", "Se han agotado los registros del calendario. Genera más días en Facturación -> Principal -> Tablas auxiliares -> Calendario"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	if (qryCalendario.value("totalhoras") == 0) {
		horasOcupadas = horasDia;
	}

	var curIncidencia:FLSqlCursor = new FLSqlCursor("se_incidencias");
	curIncidencia.setActivatedCheckIntegrity(false);
	curIncidencia.setActivatedCommitActions(false);
	curIncidencia.select("codencargado = '" + codEncargado + "' AND estado = 'Pendiente' ORDER BY orden");

	var fecha:String;
	var orden:Number = 1;
	while (curIncidencia.next()) {
		horasIncidencia = parseFloat(curIncidencia.valueBuffer("horasporhacer"));
// debug("Incidencia " + curIncidencia.valueBuffer("codigo") + " de " + horasIncidencia);
		while ((horasDia - horasOcupadas) < horasIncidencia) {
			if (!qryCalendario.next()) {
				MessageBox.warning(util.translate("scripts", "Se han agotado los registros del calendario. Genera más días en Facturación -> Principal -> Tablas auxiliares -> Calendario"), MessageBox.Ok, MessageBox.NoButton);
				return false;
			}
			if (qryCalendario.value("totalhoras") == 0) {
				continue;
			}
			horasIncidencia = horasIncidencia - (horasDia - horasOcupadas);
			horasOcupadas = 0;
		}
		fecha = qryCalendario.value("fecha");
		if (curIncidencia.valueBuffer("fechaestimada") != fecha || curIncidencia.valueBuffer("orden") != orden) {
			curIncidencia.setModeAccess(curIncidencia.Edit);
			curIncidencia.refreshBuffer();
			curIncidencia.setValueBuffer("fechaestimada", fecha);
			curIncidencia.setValueBuffer("orden", orden);
			if (curIncidencia.isNull("fechaplan") || util.daysTo(fecha, curIncidencia.valueBuffer("fechaplan")) >= 0) {
				curIncidencia.setValueBuffer("atiempo", true);
			} else {
				curIncidencia.setValueBuffer("atiempo", false);
			}
			if (!curIncidencia.commitBuffer()) {
				return false;
			}
		}
		horasOcupadas += parseFloat(horasIncidencia);
		orden++;
// debug("Asignada a " + qryCalendario.value("fecha") + " con " + horasOcupadas + " horasOcupadas");
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
