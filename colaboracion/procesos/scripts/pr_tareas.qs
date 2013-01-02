/***************************************************************************
                 pr_tareas.qs  -  description
                             -------------------
    begin                : mie ene 9 2008
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
/** \C
El formulario muestra una tarea asociada a un determinado tipo de proceso
\end */
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
	function verDocumentacion() {
		return this.ctx.oficial_verDocumentacion();
	}
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
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
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	connect (cursor, "bufferChanged(QString)", this, "iface.bufferChanged");

	if (!sys.isLoadedModule("flcolagedo")) {
		this.child("tbwTarea").setTabEnabled("gesdocu", false);
	} else {
		connect (this.child("pbnVerDocumentacion"), "clicked()", this, "iface.verDocumentacion");
		var datosGD:Array;
		datosGD["txtRaiz"] = cursor.valueBuffer("idtarea") + ": " + cursor.valueBuffer("descripcion");
		datosGD["tipoRaiz"] = "pr_tareas";
		datosGD["idRaiz"] = cursor.valueBuffer("idtarea");
		flcolagedo.iface.pub_gestionDocumentalOn(this, datosGD);
	}
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_bufferChanged(fN:String)
{
	switch (fN) {
		default: {
		}
	}
}

function oficial_verDocumentacion()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var curObjetoDoc:FLSqlCursor = new FLSqlCursor("gd_objetosdoc");

	var qry:FLSqlQuery = new FLSqlQuery;
	qry.setTablesList("gd_objetosdoc");
	qry.setSelect("iddocumento");
	qry.setFrom("gd_objetosdoc");
	qry.setWhere("tipoobjeto = 'pr_tipostarea' AND clave = '" + cursor.valueBuffer("idtipotarea") + "'");
	qry.setForwardOnly(true);
	if (!qry.exec())
		return false;
	while (qry.next()) {
		with (curObjetoDoc) {
			setModeAccess(curObjetoDoc.Insert);
			refreshBuffer();
			setValueBuffer("iddocumento", qry.value("iddocumento"));
			setValueBuffer("tipoobjeto", "pr_tareas");
			setValueBuffer("clave", cursor.valueBuffer("idtarea"));
			if (!commitBuffer())
				return false;
		}
	}

	var q:FLSqlQuery = new FLSqlQuery;
	q.setTablesList("gd_objetosdoc");
	q.setSelect("iddocumento");
	q.setFrom("gd_objetosdoc");
	q.setWhere("tipoobjeto = 'pr_tipostareapro' AND clave = '" + cursor.valueBuffer("idtipotareapro") + "'");
	q.setForwardOnly(true);
	if (!q.exec())
		return false;
	while (q.next()) {
		with (curObjetoDoc) {
			setModeAccess(curObjetoDoc.Insert);
			refreshBuffer();
			setValueBuffer("iddocumento", q.value("iddocumento"));
			setValueBuffer("tipoobjeto", "pr_tareas");
			setValueBuffer("clave", cursor.valueBuffer("idtarea"));
			if (!commitBuffer())
				return false;
		}
	}

	var datosGD:Array;
	datosGD["txtRaiz"] = cursor.valueBuffer("idtarea") + ": " + cursor.valueBuffer("descripcion");
	datosGD["tipoRaiz"] = "pr_tareas";
	datosGD["idRaiz"] = cursor.valueBuffer("idtarea");
	flcolagedo.iface.pub_gestionDocumentalOn(this, datosGD);

}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
