/***************************************************************************
                 cl_proyectos.qs  -  description
                             -------------------
    begin                : mie dic 5 2007
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
	function calculateCounter():String {
		return this.ctx.interna_calculateCounter();
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

/** @class_declaration proyectoscc */
//////////////////////////////////////////////////////////////////
//// PROYECTOSCC /////////////////////////////////////////////////
class proyectoscc extends oficial {
	function proyectoscc( context ) { oficial( context ); } 
	function calculateCounter():String {
		return this.ctx.proyectoscc_calculateCounter();
	}
}
//// PROYECTOSCC /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends proyectoscc {
    function head( context ) { proyectoscc ( context ); }
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
	var cursor:FLSqlCursor = this.cursor();
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");

	// Tareas
	if (sys.isLoadedModule("flcolaproc")) {
		var datosS:Array;
		datosS["tipoObjeto"] = "cl_proyectos";
		datosS["idObjeto"] = cursor.valueBuffer("codproyecto");
		flcolaproc.iface.pub_seguimientoOn(this, datosS);
	} else {
		this.child("twProyectos").setTabEnabled("tareas", false);
	}
	
	// Gestión documental
	if (sys.isLoadedModule("flcolagedo")) {
		var datosGD:Array;
		datosGD["txtRaiz"] = cursor.valueBuffer("codproyecto") + ": " + cursor.valueBuffer("descripcion");
		datosGD["tipoRaiz"] = "cl_proyectos";
		datosGD["idRaiz"] = cursor.valueBuffer("codproyecto");
		flcolagedo.iface.pub_gestionDocumentalOn(this, datosGD);
	} else {
		this.child("twProyectos").setTabEnabled("gesdocu", false);
	}
}

/** \D Calcula un nuevo código de proyecto
\end */
function interna_calculateCounter()
{
	var util:FLUtil = new FLUtil();
	return util.nextCounter("codproyecto", this.cursor());
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_bufferChanged(fN:String)
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil;
	switch(fN) {
		case "X": {
			break;
		}
	}
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition proyectoscc */
//////////////////////////////////////////////////////////////////
//// PROYECTOSCC /////////////////////////////////////////////////
/** \D Calcula un nuevo código de proyecto
\end */
function proyectoscc_calculateCounter()
{
	var util:FLUtil = new FLUtil();
	var codigo:String = "PR000001";
	var ultimoCodigo:String = util.sqlSelect("cl_proyectos", "codproyecto", "codproyecto LIKE 'PR%' ORDER BY codproyecto DESC");
	if (ultimoCodigo) {
		var numUltimo:Number = parseFloat(ultimoCodigo.right(6));
		codigo = "PR" + flfactppal.iface.pub_cerosIzquierda((++numUltimo).toString(), 6);
	}
		
	return codigo;
}
//// PROYECTOSCC /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////