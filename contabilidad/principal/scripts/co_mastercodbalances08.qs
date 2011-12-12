/***************************************************************************
                 co_mastercodbalances08.qs  -  description
                             -------------------
    begin                : jue jul 22 2004
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
class oficial extends interna 
{
	function oficial( context ) { interna( context ); } 	
	function actualizarCodBalances2008() {
		return this.ctx.oficial_actualizarCodBalances2008();
	}
	function actualizarCuentas2008() {
		return this.ctx.oficial_actualizarCuentas2008();
	}
	function actualizarCuentas2008ba() {
		return this.ctx.oficial_actualizarCuentas2008ba();
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
/** \C El formulario mostrará los asientos asociados al ejercicio actual
\end */
function interna_init()
{
	connect(this.child("pbnActualizarCodBalances2008"), "clicked()", this, "iface.actualizarCodBalances2008");
	connect(this.child("pbnActualizarCuentas2008"), "clicked()", this, "iface.actualizarCuentas2008");
	connect(this.child("pbnActualizarCuentas2008ba"), "clicked()", this, "iface.actualizarCuentas2008ba");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_actualizarCodBalances2008():Boolean
{
	var util:FLUtil = new FLUtil();
	var res:Object = MessageBox.information(util.translate("scripts",  "A continuación se regenerarán los códigos de balance 2008\n\n¿Desea continuar?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
	if (res != MessageBox.Yes)
		return;
	
	util.sqlDelete("co_cuentascb", "");
	util.sqlDelete("co_cuentascbba", "");
	util.sqlDelete("co_codbalances08", "");
	flcontppal.iface.generarCodigosBalance2008();
	flcontppal.iface.actualizarCuentas2008();
	flcontppal.iface.actualizarCuentas2008ba();
	
	MessageBox.information(util.translate("scripts",  "Proceso finalizado"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);	
}

function oficial_actualizarCuentas2008():Boolean
{
	var util:FLUtil = new FLUtil();
	var res:Object = MessageBox.information(util.translate("scripts",  "A continuación se regenerarán las correspondencias entre cuentas y códigos de balance\n\n¿Desea continuar?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
	if (res != MessageBox.Yes)
		return;
	
	util.sqlDelete("co_cuentascb", "");
	flcontppal.iface.actualizarCuentas2008();
	
	MessageBox.information(util.translate("scripts",  "Proceso finalizado"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);	
}

function oficial_actualizarCuentas2008ba():Boolean
{
	var util:FLUtil = new FLUtil();
	var res:Object = MessageBox.information(util.translate("scripts",  "A continuación se regenerarán las correspondencias entre cuentas y códigos de balance\n\n¿Desea continuar?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
	if (res != MessageBox.Yes)
		return;
	
	util.sqlDelete("co_cuentascbba", "");
	flcontppal.iface.actualizarCuentas2008ba();
	
	MessageBox.information(util.translate("scripts",  "Proceso finalizado"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);	
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
