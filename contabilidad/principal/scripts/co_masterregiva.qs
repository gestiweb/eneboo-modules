/***************************************************************************
                 co_masterregiva.qs  -  description
                             -------------------
    begin                : lun jul 11 2004
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var tdbRecords:FLTableDB;
	var toolButtonDelete:Object;
	var ejercicioActual:String;
	function oficial( context ) { interna( context ); } 
	function toolButtonDelete_clicked() {
		return this.ctx.oficial_toolButtonDelete_clicked();
	}
	function editarAsiento() {
		return this.ctx.oficial_editarAsiento();
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
	var util:FLUtil = new FLUtil();
	var ejercicioActual:String = flfactppal.iface.pub_ejercicioActual();
	
	this.iface.toolButtonDelete = this.child("toolButtonDelete");
	this.iface.tdbRecords = this.child("tableDBRecords");
	this.iface.tdbRecords.cursor().setMainFilter("codejercicio = '" + ejercicioActual + "'");
	this.iface.tdbRecords.setInsertOnly(true);
	this.iface.tdbRecords.refresh();
	
	connect(this.iface.toolButtonDelete, "clicked()", this, "iface.toolButtonDelete_clicked");
	connect(this.child("tbnEditarAsiento"), "clicked()", this, "iface.editarAsiento");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_toolButtonDelete_clicked()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var idregiva:String = cursor.valueBuffer("idregiva");
	if (!idregiva)
		return;
	var res:Number = MessageBox.information(util.translate("scripts", "El registro activo y su asiento asociado serán borrados ¿Está seguro?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
	if (res != MessageBox.Yes)
		return;
	util.sqlDelete("co_regiva", "idregiva = " + idregiva);
	this.iface.tdbRecords.refresh();
}

function oficial_editarAsiento()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	if (!cursor.isValid()) {
		MessageBox.warning(util.translate("scripts", "No hay ningún registro seleccionado"), MessageBox.Ok, MessageBox.NoButton)
		return;
	}

	var res:Number = MessageBox.information(util.translate("scripts", "Va a editar el asiento correspondiente a la regularización.\n¿Está seguro?"), MessageBox.Yes, MessageBox.No);
	if (res != MessageBox.Yes) {
		return false;
	}
	var curAsiento:FLSqlCursor = new FLSqlCursor("co_asientos");
	curAsiento.select("idasiento = " + cursor.valueBuffer("idasiento"));
	curAsiento.first();
	if (!curAsiento.valueBuffer("editable")) {
		curAsiento.setUnLock("editable", true);
	}
	curAsiento.select("idasiento = " + cursor.valueBuffer("idasiento"));
	curAsiento.first();
	curAsiento.editRecord();
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
