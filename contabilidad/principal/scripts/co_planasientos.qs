/***************************************************************************
                 co_planasientos.qs  -  description
                             -------------------
    begin                : lun mar 27 2006
    copyright            : (C) 2006 by InfoSiAL S.L. y Guillermo Molleda Jimena
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
	var tdbPlanPartidas:FLTableDB;
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
/** \C Los nuevos asientos creados pertencen al ejercicio vigente en el momento de crearlos
\end */
function interna_init()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	this.iface.tdbPlanPartidas = this.child("tdbPlanPartidas");
	flcontppal.iface.pub_clearPreMemoria();

	var tipoPredefinido:String = this.child("fdbPreasiento").value().toString();
	var curPlanPartidas:FLSqlCursor = new FLSqlCursor("co_planpartidas");
	curPlanPartidas.select("codplanasiento = '" + tipoPredefinido + "' ORDER BY numorden");
	var totalPlanpartidas:Number = curPlanPartidas.size();
	var nombreMem:String = "";

	if (cursor.modeAccess() == cursor.Edit) {
		for (var contador = 0; contador < totalPlanpartidas; contador++){
			curPlanPartidas.next();
			curPlanPartidas.setModeAccess(curPlanPartidas.Browse);
			curPlanPartidas.refreshBuffer();
			nombreMem = curPlanPartidas.valueBuffer("nsubcuenta").toString();
			if (nombreMem != "") {
				flcontppal.iface.pub_putPreMemoria(nombreMem, "Subcuenta");
			}
			nombreMem = curPlanPartidas.valueBuffer("nimporte").toString();
			if (nombreMem != "") {
				flcontppal.iface.pub_putPreMemoria(nombreMem, "Importe");
			}
			nombreMem = curPlanPartidas.valueBuffer("nconcepto").toString();
			if (nombreMem != "") {
				flcontppal.iface.pub_putPreMemoria(nombreMem, "Concepto");
			}
			nombreMem = curPlanPartidas.valueBuffer("ncontrapartida").toString();
			if (nombreMem != "") {
				flcontppal.iface.pub_putPreMemoria(nombreMem, "Subcuenta");
			}
			nombreMem = curPlanPartidas.valueBuffer("nbaseimponible").toString();
			if (nombreMem != "") {
				flcontppal.iface.pub_putPreMemoria(nombreMem, "Importe");
			}
			nombreMem = curPlanPartidas.valueBuffer("nimporteme").toString();
			if (nombreMem != "") {
				flcontppal.iface.pub_putPreMemoria(nombreMem, "Importe");
			}
		}
	}
}

/** \C El asiento predefinido deberá liberar la memoria utilizada
\end */
function interna_validateForm():Boolean
{
	flcontppal.iface.pub_clearPreMemoria();
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
