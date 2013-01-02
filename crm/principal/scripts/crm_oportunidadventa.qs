/***************************************************************************
                 crm_oportunidadventa.qs  -  description
                             -------------------
    begin                : jue sep 28 2006
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
	function calculateCounter() {
		return this.ctx.interna_calculateCounter();
	}
	function init() {
		return this.ctx.interna_init();
	}
	function validateForm():Boolean {
		return this.ctx.interna_validateForm();
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    function oficial( context ) { interna( context ); }
	function imprimirPresupuesto() {
		return this.ctx.oficial_imprimirPresupuesto();
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
function interna_calculateCounter()
{
	var util:FLUtil = new FLUtil();
	return util.nextCounter("codoportunidad", this.cursor());

// 	var cursor:FLSqlCursor = this.cursor();
// 	if (cursor)
// 		return util.nextCounter("codoportunidad", cursor);
}

function interna_init()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	connect(this.child("toolButtonPrintPre"), "clicked()", this, "iface.imprimirPresupuesto()");
	switch (cursor.modeAccess()) {
		case cursor.Insert: {
			var codCliente:String = cursor.valueBuffer("codcliente");
			if (codCliente && codCliente != "") {
				this.child("fdbNomCliente").setValue(util.sqlSelect("clientes", "nombre", "codcliente = '" + codCliente + "'"));
			}
			this.child("fdbIdUsuario").setValue(sys.nameUser());
			this.child("fdbCodEstado").setValue(util.sqlSelect("crm_estadosoportunidad", "codestado", "valordefecto = true"));
		}
	}
}

function interna_validateForm():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	/** \C Se pedirá confirmación si no se ha establecido fecha de cierre estimada
	\end */
	if (cursor.isNull("fechacierre")) {
		var res:Number = MessageBox.warning(util.translate("scripts", "No ha establecido la fecha de cierre estimada de esta oportunidad.\nLa oportunidad no aparecerá en los informes de previsión de ventas.\n¿Desea continuar?"), MessageBox.No, MessageBox.Yes);
		if (res != MessageBox.Yes)
			return false;
	}
	return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_imprimirPresupuesto()
{
	var codPresupuesto:String = this.child("tdbPresupuestosCli").cursor().valueBuffer("codigo");
	if (!codPresupuesto)
		return;
	formpresupuestoscli.iface.pub_imprimir(codPresupuesto);
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
