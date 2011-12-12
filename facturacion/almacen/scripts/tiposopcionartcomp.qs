/***************************************************************************
                 tiposopcionartcomp.qs  -  description
                             -------------------
    begin                : jue oct 27 2004
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
		this.ctx.interna_validateForm();
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	function oficial( context ) { interna( context ); }
	function tbnOpcionDefecto_clicked() {
		this.ctx.oficial_tbnOpcionDefecto_clicked();
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
	var cursor:FLSqlCursor = this.cursor();

	connect(this.child("tbnOpcionDefecto"), "clicked()", this, "iface.tbnOpcionDefecto_clicked");
}

function interna_validateForm():Boolean
{
	var util:FLUtil = new FLUtil();
	MessageBox.warning(util.translate("scripts", "Aviso: Las opciones en los artículos sólo se incluyen a modo informativo, y no afectan al control de stock.\n Si desea usar las opciones en los documentos de facturación y en el control de stocks debe instalar la extensión de Producción."), MessageBox.Ok, MessageBox.NoButton);

	return true;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_tbnOpcionDefecto_clicked()
{
	var util:FLUtil = new FLUtil();
	var cursorOpcion:FLSqlCursor = this.child("tdbOpcionesArticuloComp").cursor();

	var idOpcionArticulo:String = cursorOpcion.valueBuffer("idopcionarticulo");
	if (!idOpcionArticulo || idOpcionArticulo == "")
		return false;

	if (!util.sqlUpdate("opcionesarticulocomp", "valordefecto", false, "idtipoopcionart = " + cursorOpcion.valueBuffer("idtipoopcionart")))
		return false;

	if (!util.sqlUpdate("opcionesarticulocomp", "valordefecto", true, "idopcionarticulo = " + idOpcionArticulo))
		return false;

	this.child("tdbOpcionesArticuloComp").refresh();

	return true;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
