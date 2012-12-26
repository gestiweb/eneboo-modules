/***************************************************************************
                 pr_mastercentroscoste.qs  -  description
                             -------------------
    begin                : mar jun 26 2007
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
	var lblCCosteActual:Object;
    function oficial( context ) { interna( context ); } 
	function actualizarCentroCosteActual() {
		return this.ctx.oficial_actualizarCentroCosteActual();
	}
	function cambiarCentroCoste() {
		return this.ctx.oficial_cambiarCentroCoste();
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
En el formulario maestro se muestra el centro de coste stablecido como local
El botón cambiar permite cambiar el centro de coste local
*/
function interna_init()
{
	this.iface.lblCCosteActual = this.child("lblCCosteActual");
	connect(this.child("pbnCambiar"), "clicked()", this, "iface.cambiarCentroCoste()");
	
	this.iface.actualizarCentroCosteActual();
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D
Cambia el centro de coste local por el centro de coste seleccionado en ese momento
*/
function oficial_cambiarCentroCoste()
{
	var util:FLUtil = new FLUtil;
	
	var valor:String = this.cursor().valueBuffer("codcentro");
	var valorAnterior:String = util.readSettingEntry("scripts/flprodppal/codCentroCoste");
	if (valor == valorAnterior)
		util.writeSettingEntry("scripts/flprodppal/codCentroCoste", "");
	else
		util.writeSettingEntry("scripts/flprodppal/codCentroCoste", valor);
	
	this.iface.actualizarCentroCosteActual();
}

/** \D
Muestra el codigo y descripcion del centro de coste local
*/
function oficial_actualizarCentroCosteActual()
{
	var util:FLUtil = new FLUtil();
	var codTerminal:String;
	codTerminal = util.readSettingEntry("scripts/flprodppal/codCentroCoste");
	var descripcion:String = "";
	
	if (codTerminal && codTerminal != "")
		descripcion = codTerminal + " - " + util.sqlSelect("pr_centroscoste", "descripcion", "codcentro = '" + codTerminal + "'");

	this.iface.lblCCosteActual.text = descripcion;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
