/**************************************************************************
                 seleccionrecibosprov.qs  -  description
                             -------------------
    begin                : jue dic 21 2006
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
	var tdbRecibos:Object;
	var tdbRecibosSel:Object;
	
    function oficial( context ) { interna( context ); } 
	function seleccionar() {
		return this.ctx.oficial_seleccionar();
	}
	function quitar() {
		return this.ctx.oficial_quitar();
	}
	function refrescarTablas() {
		return this.ctx.oficial_refrescarTablas();
	}
	function tbnTodos_clicked() {
		return this.ctx.oficial_tbnTodos_clicked();
	}
	function tbnNinguno_clicked() {
		return this.ctx.oficial_tbnNinguno_clicked();
	}
	function tbnTodosSel_clicked() {
		return this.ctx.oficial_tbnTodosSel_clicked();
	}
	function tbnNingunoSel_clicked() {
		return this.ctx.oficial_tbnNingunoSel_clicked();
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
Este formulario muestra una lista de recibos de cliente que cumplen un determinado filtro, y permite al usuario seleccionar uno o más recibos de la lista
\end */
function interna_init()
{
	this.iface.tdbRecibos = this.child("tdbRecibos");
	this.iface.tdbRecibosSel = this.child("tdbRecibosSel");
	
	this.iface.tdbRecibos.setReadOnly(true);
	this.iface.tdbRecibosSel.setReadOnly(true);
	
	var filtro:String = this.cursor().valueBuffer("filtro");
	if (filtro && filtro != "") {
		this.iface.tdbRecibos.cursor().setMainFilter(filtro);
		this.iface.tdbRecibosSel.cursor().setMainFilter(filtro);
	}
	this.iface.refrescarTablas();
	
	connect(this.iface.tdbRecibos.cursor(), "recordChoosed()", this, "iface.seleccionar()");
	connect(this.iface.tdbRecibosSel.cursor(), "recordChoosed()", this, "iface.quitar()");
	connect(this.child("tbnSeleccionar"), "clicked()", this, "iface.seleccionar()");
	connect(this.child("tbnQuitar"), "clicked()", this, "iface.quitar()");
	connect(this.child("tbnTodos"), "clicked()", this, "iface.tbnTodos_clicked()");
	connect(this.child("tbnNinguno"), "clicked()", this, "iface.tbnNinguno_clicked()");
	connect(this.child("tbnTodosSel"), "clicked()", this, "iface.tbnTodosSel_clicked()");
	connect(this.child("tbnNingunoSel"), "clicked()", this, "iface.tbnNingunoSel_clicked()");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Refresca las tablas, en función del filtro y de los datos seleccionados hasta el momento
*/
function oficial_refrescarTablas()
{
	var datos:String = this.cursor().valueBuffer("datos");
	var filtro:String = this.cursor().valueBuffer("filtro");
	if (filtro && filtro != "")
		filtro += " AND ";

	if (!datos || datos == "") {
		this.iface.tdbRecibos.cursor().setMainFilter(filtro + "1 = 1");
		this.iface.tdbRecibosSel.cursor().setMainFilter(filtro + "1 = 2");
	} else {
		this.iface.tdbRecibos.cursor().setMainFilter(filtro + "idrecibo NOT IN (" + datos + ")");
		this.iface.tdbRecibosSel.cursor().setMainFilter(filtro + "idrecibo IN (" + datos + ")");
	}
	this.iface.tdbRecibos.refresh();
	this.iface.tdbRecibosSel.refresh();
}

/** \D Incluye un recibo en la lista de datos
*/
function oficial_seleccionar()
{
	var cursor:FLSqlCursor = this.cursor();
	var datos:String = cursor.valueBuffer("datos");

	var aRecibos:Array = this.iface.tdbRecibos.primarysKeysChecked();
	if (aRecibos && aRecibos.length > 0) {
		var listaRecibos:String = aRecibos.join(",");
		if (!datos || datos == "") {
			datos = listaRecibos;
		} else {
			datos += "," + listaRecibos;
		}
		for (var i:Number = 0; i < aRecibos.length; i++) {
			this.iface.tdbRecibos.setPrimaryKeyChecked(aRecibos[i], false);
		}
	}
// 	var idRecibo:String = this.iface.tdbRecibos.cursor().valueBuffer("idRecibo");
// 	if (!idRecibo)
// 		return;
// 	if (!datos || datos == "")
// 		datos = idRecibo;
// 	else
// 		datos += "," + idRecibo;

debug("Datos = " + datos);
	cursor.setValueBuffer("datos", datos);
	
	this.iface.refrescarTablas();
}

/** \D Quita un recibo de la lista de datos
*/
function oficial_quitar()
{
	var cursor:FLSqlCursor = this.cursor();
	var datos:String = cursor.valueBuffer("datos");

	if (!datos || datos == "") {
		return;
	}
	var recibos:Array = datos.split(",");
	var aRecibos:Array = this.iface.tdbRecibosSel.primarysKeysChecked();
	if (!aRecibos || aRecibos.length == 0) {
		return;
	}
	var datosNuevos:String = "";
	
	var quitar:Boolean;
	for (var i:Number = 0; i < recibos.length; i++) {
		quitar = false;
		for (var iRecibo:Number = 0; iRecibo < aRecibos.length; iRecibo++) {
			if (recibos[i] == aRecibos[iRecibo]) {
				quitar = true;
				break;
			}
		}
		if (quitar) {
			this.iface.tdbRecibosSel.setPrimaryKeyChecked(recibos[i], false);
			continue;
		}
		if (datosNuevos == "") {
			datosNuevos = recibos[i];
		} else {
			datosNuevos += "," + recibos[i];
		}
	}
debug("Datos = " + datosNuevos);
	cursor.setValueBuffer("datos", datosNuevos);

// 	var idRecibo:String = this.iface.tdbRecibosSel.cursor().valueBuffer("idRecibo");
// 	if (!idRecibo)
// 		return;
// 	
// 	if (!datos || datos == "")
// 		return;
// 	var recibos:Array = datos.split(",");
// 	var datosNuevos:String = "";
// 	for (var i:Number = 0; i < recibos.length; i++) {
// 		if (recibos[i] != idRecibo) {
// 			if (datosNuevos == "") 
// 				datosNuevos = recibos[i];
// 			else
// 				datosNuevos += "," + recibos[i];
// 		}
// 	}
// 	cursor.setValueBuffer("datos", datosNuevos);
	this.iface.refrescarTablas();
}

/** \D Selecciona todos los recibos de la tabla superior
\end */
function oficial_tbnTodos_clicked()
{
	var filtro:String = this.iface.tdbRecibos.cursor().mainFilter();
	if (!filtro || filtro == "") {
		return;
	}
	var qryRecibos:FLSqlQuery = new FLSqlQuery();
	qryRecibos.setTablesList("recibosprov");
	qryRecibos.setSelect("idrecibo");
	qryRecibos.setFrom("recibosprov");
	qryRecibos.setWhere(filtro);
	qryRecibos.setForwardOnly(true);
	if (!qryRecibos.exec()) {
		return false;
	}
	while (qryRecibos.next()) {
		this.iface.tdbRecibos.setPrimaryKeyChecked(qryRecibos.value("idrecibo"), true);
	}
	this.iface.tdbRecibos.refresh();
}

/** \D Elimina la selección de todos los recibos de la tabla superior
\end */
function oficial_tbnNinguno_clicked()
{
	this.iface.tdbRecibos.clearChecked();
	this.iface.tdbRecibos.refresh();
}

/** \D Selecciona todos los recibos de la tabla inferior
\end */
function oficial_tbnTodosSel_clicked()
{
	var filtro:String = this.iface.tdbRecibosSel.cursor().mainFilter();
	if (!filtro || filtro == "") {
		return;
	}
	var qryRecibos:FLSqlQuery = new FLSqlQuery();
	qryRecibos.setTablesList("recibosprov");
	qryRecibos.setSelect("idrecibo");
	qryRecibos.setFrom("recibosprov");
	qryRecibos.setWhere(filtro);
	qryRecibos.setForwardOnly(true);
	if (!qryRecibos.exec()) {
		return false;
	}
	while (qryRecibos.next()) {
		this.iface.tdbRecibosSel.setPrimaryKeyChecked(qryRecibos.value("idrecibo"), true);
	}
	this.iface.tdbRecibosSel.refresh();
}

/** \D Elimina la selección de todos los recibos de la tabla inferior
\end */
function oficial_tbnNingunoSel_clicked()
{
	this.iface.tdbRecibosSel.clearChecked();
	this.iface.tdbRecibosSel.refresh();
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
