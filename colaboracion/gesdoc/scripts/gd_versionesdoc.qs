/***************************************************************************
                 gd_versionesdoc.qs  -  description
                             -------------------
    begin                : vie jul 21 2006
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
		this.ctx.interna_init();
	}
	function calculateField(fN:String):Boolean {
		return this.ctx.interna_calculateField(fN);
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var fichero_:String;
	function oficial( context ) { interna( context ); }
	function establecerFichero() {
		this.ctx.oficial_establecerFichero();
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
/** \C Cada versión hereda por defecto el nombre del fichero y los comentarios del documento del que proviene
\end */
function interna_init()
{
	var cursor:FLSqlCursor = this.cursor();
	switch (cursor.modeAccess()) {
		case cursor.Insert: {
			this.child("fdbFichero").setValue(cursor.cursorRelation().valueBuffer("fichero"));
			this.child("fdbComentarios").setValue(cursor.cursorRelation().valueBuffer("comentarios"))
			this.child("fdbModificadoPor").setValue(sys.nameUser());
			break;
		}
	}
}

function interna_calculateField(fN:String):Boolean
{
	var cursor:FLSqlCursor = this.cursor();
	var valor:String;
	switch (fN) {
		case "nombre": {
			var pathFichero:String = this.child("lblFichero").text;
			if (pathFichero && pathFichero != "") {
				var posBarra:Number = pathFichero.findRev("/");
				if (posBarra)
					valor = pathFichero.right(pathFichero.length - posBarra - 1);
			}
			break;
		}
	}
	return valor;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_establecerFichero()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor()
	var nombreDoc:String = cursor.cursorRelation().valueBuffer("nombre");
	var estado:String = flcolagedo.iface.pub_estadoDocumento(nombreDoc);
	switch (estado) {
		case "C": {
			MessageBox.warning(util.translate("scripts", "Existe un conflicto entre la versión local del documento y la versión del repositorio.\nNo es posible añadir una nueva versión sin antes resolver el conflicto.\n"), MessageBox.Ok, MessageBox.NoButton);
			break;
		}
		case "?":
		case "??":
		case "M": {
			var res:Number = MessageBox.warning(util.translate("scripts", "El documento actual tiene modificaciones pendientes de subir al repositorio.\nSi selecciona una nueva versión del fichero dichas modificaciones se perderán.\n¿Desea continuar?"), MessageBox.Yes, MessageBox.No);
			if (res != MessageBox.Yes)
				return false;
		}
		case "X":
		case "XX":
		case "U": {
			break;
		}
		default: {
			return false;
		}
	}
	
	var pathFichero:String = FileDialog.getOpenFileName();
	if (pathFichero)
		flcolagedo.iface.pub_setPathVersion(pathFichero)
	this.child("lblFichero").text = pathFichero;
	this.child("fdbNombre").setValue(this.iface.calculateField("nombre"));
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
