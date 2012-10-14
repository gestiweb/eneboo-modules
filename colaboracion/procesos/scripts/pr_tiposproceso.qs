/***************************************************************************
                 pr_tiposproceso.qs  -  description
                             -------------------
    begin                : jue jul 19 2007
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
/** \C
El formulario gestiona los distintos tipos de proceso, permitiendo lanzar procesos del tipo seleccionado
\end */
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
	function validateForm():Boolean {
		return this.ctx.interna_validateForm();
	}
	function calculateField(fN:String):String {
		return this.ctx.interna_calculateField(fN);
	}
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
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
}

function interna_validateForm():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var tipoProceso = cursor.valueBuffer("idtipoproceso");

// COMPROBAR QUE HAY TAREAS INICIAL Y FINAL
	if (!util.sqlSelect("pr_tipostareapro", "idtipotareapro", "idtipoproceso = '" + tipoProceso + "' AND tareainicial = true")) {
		MessageBox.warning(util.translate("scripts", "Debe indicar qué tarea o tareas son las tareas iniciales"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	if (!util.sqlSelect("pr_tipostareapro", "idtipotareapro", "idtipoproceso = '" + tipoProceso + "' AND tareafinal = true")) {
		MessageBox.warning(util.translate("scripts", "Debe indicar qué tarea o tareas son las tareas finales"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

// COMPROBAR SECUENCIAS
	var qryTiposTarea:FLSqlQuery = new FLSqlQuery();
	with (qryTiposTarea) {
		setTablesList("pr_tipostareapro");
		setSelect("idtipotarea, idtipotareapro, tareainicial, tareafinal");
		setFrom("pr_tipostareapro");
		setWhere("idtipoproceso = '" + tipoProceso + "' ORDER BY ordenlista");
	}
	if (!qryTiposTarea.exec())
		return false;

	if (qryTiposTarea.size() > 1) {

		while (qryTiposTarea.next()) {
	
			if (qryTiposTarea.value("tareainicial")) {
				if (!qryTiposTarea.value("tareafinal") && !util.sqlSelect("pr_secuencias","idsecuencia","idtipoproceso = '" + tipoProceso + "' AND tareainicio = '" + qryTiposTarea.value("idtipotareapro") + "'")) {
					MessageBox.warning(util.translate("scripts", "Debe existir al menos una secuencia en la que la tarea %1 sea tarea inicial").arg(qryTiposTarea.value("idtipotarea")), MessageBox.Ok, MessageBox.NoButton);
					return false;
				}
			}
	
			if (qryTiposTarea.value("tareafinal")) {
				if (!qryTiposTarea.value("tareainicial") && !util.sqlSelect("pr_secuencias","idsecuencia","idtipoproceso = '" + tipoProceso + "' AND tareafin = '" + qryTiposTarea.value("idtipotareapro") + "'")) {
					MessageBox.warning(util.translate("scripts", "Debe existir al menos una secuencia en la que la tarea %1 sea tarea final").arg(qryTiposTarea.value("idtipotarea")), MessageBox.Ok, MessageBox.NoButton);
					return false;
				}
				if (util.sqlSelect("pr_secuencias","idsecuencia","idtipoproceso = '" + tipoProceso + "' AND tareainicio = '" + qryTiposTarea.value("idtipotareapro") + "'")) {
					MessageBox.warning(util.translate("scripts", "La tarea %1 es una tarea final, por lo tanto, no debe existir como tarea inicial en ninguna secuencia.").arg(qryTiposTarea.value("idtipotarea")), MessageBox.Ok, MessageBox.NoButton);
					return false;
				}
			}
	
			if (!qryTiposTarea.value("tareainicial") && !qryTiposTarea.value("tareafinal")) {
				if(!(util.sqlSelect("pr_secuencias","idsecuencia","idtipoproceso = '" + tipoProceso + "' AND tareafin = '" + qryTiposTarea.value("idtipotareapro") + "'") && util.sqlSelect("pr_secuencias","idsecuencia","idtipoproceso = '" + tipoProceso + "' AND tareainicio = '" + qryTiposTarea.value("idtipotareapro") + "'"))) {
					MessageBox.warning(util.translate("scripts", "La tarea %1 es una tarea intermedia, por lo tanto, debe aparecer en las secuencias como tarea de inicio y tarea de fin.").arg(qryTiposTarea.value("idtipotarea")), MessageBox.Ok, MessageBox.NoButton);
					return false;
				}
			}
		}
	}
	return true;
}


function interna_calculateField(fN:String):String
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var valor:String;
	switch (fN) {
	}
	return valor;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_bufferChanged(fN:String)
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	switch (fN) {
		case "unidad": 
			var unidad:String = cursor.valueBuffer("unidad");
			var tiempoUnidad:Number = 0;
			var tiempoMedio:Number = cursor.valueBuffer("tiempomedio");

			if (tiempoMedio && tiempoMedio != 0) {
				
				switch (unidad) {
					case "Segundos":
						tiempoUnidad = tiempoMedio;
						break;
					case "Minutos":
						tiempoUnidad = tiempoMedio / 60;
						break;
					case "Horas":
						tiempoUnidad = tiempoMedio / (60 * 60)
						break;
					case "Dias":
						tiempoUnidad = tiempoMedio / (60 * 60 * 24)
						break;
					default:
						tiempoUnidad = 0;
				}
			}
			this.child("fdbTiempoUnidad").setValue(tiempoUnidad);
	}
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
