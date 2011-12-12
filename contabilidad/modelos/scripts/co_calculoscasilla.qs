/***************************************************************************
                 co_calculoscasilla.qs  -  description
                             -------------------
    begin                : jue mar 6 2008
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
	var bloqueo:Boolean;
	var listaSubcuentas:String = "";

    function oficial( context ) { interna( context ); }
	function aplicarFiltro() {
		return this.ctx.oficial_aplicarFiltro();
	}
	function convertirCadena():String {
		return this.ctx.oficial_convertirCadena();
	}
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function seleccionarSubcuenta() {
		return this.ctx.oficial_seleccionarSubcuenta();
	}
	function eliminarSubcuenta() {
		return this.ctx.oficial_eliminarSubcuenta();
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

/** @class_declaration ifaceCtx*/
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
	var cursor:FLSqlCursor = this.cursor();
	this.iface.bloqueo = false;

	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this.child("pbnSelect"), "clicked()", this, "iface.seleccionarSubcuenta");
	connect(this.child("pbnEliminar"), "clicked()", this, "iface.eliminarSubcuenta");

	if (cursor.modeAccess() == cursor.Insert)
		this.iface.listaSubcuentas = "";
	
	this.iface.aplicarFiltro();
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_aplicarFiltro()
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var filtro:String = "codejercicio = '" + flfactppal.iface.pub_valorDefectoEmpresa("codejercicio") + "'";

	var subcuentas:String = this.iface.convertirCadena();

	this.child("tdbSubcuentas").setFilter(filtro + " AND codsubcuenta NOT IN (" + subcuentas + ")");
	this.child("tdbSubcuentasSelec").setFilter(filtro + " AND codsubcuenta IN (" + subcuentas + ")");
	this.child("tdbSubcuentas").refresh();
	this.child("tdbSubcuentasSelec").refresh();

}

function oficial_convertirCadena():String
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var cadena:String = "";
	var lista:Array = this.iface.listaSubcuentas.split(",");
	for (i = 0; i < lista.length; i++) {
		if (cadena == "")
			cadena = "'" + lista[i] + "'";
		else
			cadena += ", '" + lista[i] + "'";
	}
	return cadena;
}

function oficial_bufferChanged(fN:String)
{
	var cursor:FLSqlCursor = this.cursor();
	var codEjercicio:String = flfactppal.iface.pub_valorDefectoEmpresa("codejercicio");

	switch (fN) {
		case "codepigrafe": {
			if (!this.iface.bloqueo) {
				this.iface.bloqueo = true;
				this.child("fdbCodCuenta").setValue("");
				this.child("fdbDesCuenta").setValue("");
				this.iface.bloqueo = false;
			}
			this.iface.listaSubcuentas = "";
			this.iface.aplicarFiltro();
			break;
		}
		case "codcuenta": {
			if (!this.iface.bloqueo) {
				this.iface.bloqueo = true;
				this.child("fdbCodEpigrafe").setValue("");
				this.child("fdbDesEpigrafe").setValue("");
				this.iface.bloqueo = false;
			}
			this.iface.listaSubcuentas = "";
			this.iface.aplicarFiltro();
			break;
		}
	}
}

function oficial_seleccionarSubcuenta()
{
	this.child("fdbCodEpigrafe").setValue("");
	this.child("fdbCodCuenta").setValue("");
	this.child("fdbDesEpigrafe").setValue("");
	this.child("fdbDesCuenta").setValue("");

	var codSubcuenta:String = this.child("tdbSubcuentas").cursor().valueBuffer("codsubcuenta");
	if (this.iface.listaSubcuentas == "")
		this.iface.listaSubcuentas = codSubcuenta;
	else
		this.iface.listaSubcuentas += "," + codSubcuenta;

	this.iface.aplicarFiltro();
}

function oficial_eliminarSubcuenta()
{
	var arraySub:Array = this.iface.listaSubcuentas.split(",");
	var listaNueva:String = "";
	for (i = 0; i < arraySub.length; i++) {
		if (arraySub[i] != this.child("tdbSubcuentasSelec").cursor().valueBuffer("codsubcuenta")) {
			if (listaNueva == "")
				listaNueva = arraySub[i];
			else 
				listaNueva += "," + arraySub[i];
		}
	}
	this.iface.listaSubcuentas = listaNueva;

	this.iface.aplicarFiltro();
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
