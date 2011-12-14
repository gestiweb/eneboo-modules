/***************************************************************************
                 crm_destinacampana.qs  -  description
                             -------------------
    begin                : jue nov 1 2006
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
	function init() {
		return this.ctx.interna_init();
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    function oficial( context ) { interna( context ); }
	function mostrarDatos() {
		return this.ctx.oficial_mostrarDatos();
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
	var curR:FLSqlCursor = cursor.cursorRelation();
	if (!curR) {
		curR = new FLSqlCursor("crm_campanas");
		curR.select("codcampana = '" + cursor.valueBuffer("codcampana") + "'");
		if (!curR.first()) {
			return false;
		}
	}
	if (curR.valueBuffer("canal") == "Correo ordinario") {
		this.child("fdbDestino").close();
	} else {
		this.child("tbwDestinatario").setTabEnabled("dirpostal", false);
	}
	this.iface.mostrarDatos();
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Muestra los datos asociados a los alias del registro de destinatario
\end */
function oficial_mostrarDatos()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var arrayAlias:Array = flcrm_mark.iface.pub_arrayAliasCampana(cursor.valueBuffer("codcampana"));
	if (!arrayAlias)
		return false;

	var datos:String = "";
	var xmlDoc:FLDomDocument = new FLDomDocument();
	if (!xmlDoc.setContent(cursor.valueBuffer("datos")))
		return false;

	for (var i:Number = 0; i < arrayAlias.length; i++) {
		datos += arrayAlias[i] + ": " + xmlDoc.firstChild().attributeValue(arrayAlias[i]) + "\n";
	}
	this.child("lblDatos").text = datos;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
