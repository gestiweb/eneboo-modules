/***************************************************************************
                 pr_i_tareas.qs  -  description
                             -------------------
    begin                : mar jul 22 2008
    copyright            : (C) 2008 by InfoSiAL S.L.
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
	function bufferChanged(fN:String) { this.ctx.oficial_bufferChanged(fN); }
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
		connect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged");

	this.iface.bufferChanged("i_pr__tareas_estado");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_bufferChanged(fN:String)
{
	var cursor:FLSqlCursor = this.cursor();
	
	switch(fN){
		/** \C Si cambia el intervalo se recalculan las fechas.
		\end */
		case "codintervalo":{
		var intervalo:Array = [];
		if(cursor.valueBuffer("codintervalo")){
			intervalo = flfactppal.iface.pub_calcularIntervalo(cursor.valueBuffer("codintervalo"));
			cursor.setValueBuffer("d_pr__tareas_fechainicioprev",intervalo.desde);
			cursor.setValueBuffer("h_pr__tareas_fechainicioprev",intervalo.hasta);
		}
		break;
		}
		case "codintervalorealizacion":{
		var intervalo:Array = [];
		if(cursor.valueBuffer("codintervalorealizacion")){
			intervalo = flfactppal.iface.pub_calcularIntervalo(cursor.valueBuffer("codintervalorealizacion"));
			cursor.setValueBuffer("d_pr__tareas_diafin",intervalo.desde);
			cursor.setValueBuffer("h_pr__tareas_diafin",intervalo.hasta);
		}
		break;
		}
		case "i_pr__tareas_estado":{
			switch (cursor.valueBuffer("i_pr__tareas_estado")) {
				case "OFF": {
					cursor.setNull("codintervalo");
					cursor.setNull("d_pr__tareas_fechainicioprev");
					cursor.setNull("h_pr__tareas_fechainicioprev");
					cursor.setNull("codintervalorealizacion");
					cursor.setNull("d_pr__tareas_diafin");
					cursor.setNull("h_pr__tareas_diafin");
 					
					this.child("fdbIntervalo").setDisabled(true);
					this.child("fdbDdesdeFecha").setDisabled(true);
					this.child("fdbHastaFecha").setDisabled(true);
					this.child("fdbIntervaloR").setDisabled(true);
					this.child("fdbDdesdeFechaR").setDisabled(true);
					this.child("fdbHastaFechaR").setDisabled(true);
					break;
				}
				case "PTE" :
				case "EN CURSO": {
					cursor.setNull("codintervalorealizacion");
					cursor.setNull("d_pr__tareas_diafin");
					cursor.setNull("h_pr__tareas_diafin");

					this.child("fdbIntervalo").setDisabled(false);
					this.child("fdbDdesdeFecha").setDisabled(false);
					this.child("fdbHastaFecha").setDisabled(false);
					this.child("fdbIntervaloR").setDisabled(true);
					this.child("fdbDdesdeFechaR").setDisabled(true);
					this.child("fdbHastaFechaR").setDisabled(true);
					break;
				}
				default: {
					this.child("fdbIntervalo").setDisabled(false);
					this.child("fdbDdesdeFecha").setDisabled(false);
					this.child("fdbHastaFecha").setDisabled(false);
					this.child("fdbIntervaloR").setDisabled(false);
					this.child("fdbDdesdeFechaR").setDisabled(false);
					this.child("fdbHastaFechaR").setDisabled(false);
				}
			}
			break;
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
