/***************************************************************************
                 co_epigrafes.qs  -  description
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
    function validateForm():Boolean { return this.ctx.interna_validateForm(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var tbnBuscarEpigrafe:Object;
	var ejercicioActual:String;
    function oficial( context ) { interna( context ); } 
	function desconexion() { return this.ctx.oficial_desconexion(); }
	function tbnBuscarEpigrafe_clicked() { return this.ctx.oficial_tbnBuscarEpigrafe_clicked(); }
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration pgc2008 */
/////////////////////////////////////////////////////////////////
//// PGC 2008 //////////////////////////////////////////////////////
class pgc2008 extends oficial {
    function pgc2008( context ) { oficial ( context ); }
    function init() { this.ctx.pgc2008_init(); }
    function validateForm():Boolean { return this.ctx.pgc2008_validateForm(); }
}
//// PGC 2008 //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends pgc2008 {
    function head( context ) { pgc2008 ( context ); }
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
	En modo edición los campos referentes al epígrafe padre del actual estarán inhabilitados
\end */
function interna_init()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	this.iface.tbnBuscarEpigrafe = this.child("tbnBuscarEpigrafe");
	this.iface.ejercicioActual = flfactppal.iface.pub_ejercicioActual();
	
	switch(cursor.modeAccess()) {
	case cursor.Insert:
		cursor.setValueBuffer("codejercicio", this.iface.ejercicioActual);
		break;
	case cursor.Edit:
		this.iface.tbnBuscarEpigrafe.enabled = false;
		break;
	}
	connect(this.iface.tbnBuscarEpigrafe, "clicked()", this, "iface.tbnBuscarEpigrafe_clicked");
	connect(form, "closed()", this, "iface.desconexion");
}

function interna_validateForm():Boolean
{
		var cursor:FLSqlCursor = this.cursor();
		var util:FLUtil = new FLUtil();
		
		/** \C El código de epígrafe tendrá como prefijo el código del epígrafe padre
		\end */
		var codEpigrafePadre:String = this.child("fdbCodPadre").value();
		var codEpigrafe:String = cursor.valueBuffer("codepigrafe");
		if (codEpigrafePadre != codEpigrafe.substring(0, codEpigrafePadre.length)) {
				MessageBox.critical(util.translate("scripts", 
						"El código del epígrafe debe tener como prefijo el de su epígrafe padre"),
						 MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				return false;
		}
		
		return true;
}


//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_desconexion()
{
		disconnect(this.cursor(), "bufferChanged(QString)", this, "bufferChanged");
		disconnect(this.iface.tbnBuscarEpigrafe, "clicked()", this, "iface.tbnBuscarEpigrafe_clicked");
}

function oficial_tbnBuscarEpigrafe_clicked()
{
		var cursor:FLSqlCursor = this.cursor();
		var f:Object = new FLFormSearchDB("co_epigrafes");
		f.setMainWidget();
		f.cursor().setMainFilter("codejercicio = '" + this.iface.ejercicioActual + "'");
		var idEpigrafe:String = f.exec("idepigrafe");
		if (idEpigrafe) {
				cursor.setValueBuffer("idpadre", idEpigrafe);
		}
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pgc2008 */
/////////////////////////////////////////////////////////////////
//// PGC 2008 //////////////////////////////////////////////////////

function pgc2008_init()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	this.iface.ejercicioActual = flfactppal.iface.pub_ejercicioActual();
	
	switch(cursor.modeAccess()) {
		case cursor.Insert:
			cursor.setValueBuffer("codejercicio", this.iface.ejercicioActual);
		break;
	}
}

function pgc2008_validateForm()
{
	return true;
}

//// PGC 2008 //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////



/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////