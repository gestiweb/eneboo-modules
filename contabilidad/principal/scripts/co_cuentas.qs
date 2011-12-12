/***************************************************************************
                 co_cuentas.qs  -  description
                             -------------------
    begin                : lun abr 26 2004
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
    function calculateField( fN:String ):String { return this.ctx.interna_calculateField( fN ); }
    function validateForm():Boolean { return this.ctx.interna_validateForm(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var ejercicioActual:String;
    function oficial( context ) { interna( context ); } 
	function desconexion() { return this.ctx.oficial_desconexion(); }
	function bufferChanged(fN) { return this.ctx.oficial_bufferChanged(fN); }
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration pgc2008 */
/////////////////////////////////////////////////////////////////
//// PGC 2008 //////////////////////////////////////////////////////
class pgc2008 extends oficial 
{
    function pgc2008( context ) { oficial ( context ); }
	function init() { this.ctx.pgc2008_init(); }
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
/** \C En modo edición. Los campos referentes al epígrafe del que procede la cuenta estarán inhabilitados. No se permitirá editar el tipo de cuenta especial si la cuenta tiene subcuentas asociadas
\end */
function interna_init()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	this.iface.ejercicioActual = flfactppal.iface.pub_ejercicioActual();
	
	switch(cursor.modeAccess()) {
		case cursor.Insert:
			cursor.setValueBuffer("codejercicio", this.iface.ejercicioActual);
			break;
		case cursor.Edit:
			this.child("fdbIdEpigrafe").setDisabled(true);
			this.child("fdbCodEpigrafe").setDisabled(true);
			break;
	}
	
	this.child("fdbIdEpigrafe").setFilter("codejercicio = '" + this.iface.ejercicioActual + "'");
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this, "closed()", this, "iface.desconexion");
}

function interna_calculateField(fN):String
{
	var util:FLUtil = new FLUtil();
	var res:Object;
	var cursor:FLSqlCursor = this.cursor();
	
	switch(fN) {
		/** \D El --codcuenta-- toma como prefijo el --codepigrafe-- al que pertenece
		\end */
		case "codcuenta":
			res = cursor.valueBuffer("codepigrafe");
			break;
		/** \D El --idepigrafe-- debe corresponder al ejercicio actual
		\end */
		case "idepigrafe":
			res = util.sqlSelect("co_epigrafes", "idepigrafe", "codejercicio = '" + this.iface.ejercicioActual + "'" + " AND codepigrafe = '" + cursor.valueBuffer("codepigrafe") + "'");
			break;
	}
	return res;
}

function interna_validateForm():Boolean
{
		var cursor:FLSqlCursor = this.cursor();
		var util:FLUtil = new FLUtil();
		
		/** \C El código de cuenta tendrá como prefijo el código del epígrafe al que pertenece
		\end */
		var codEpigrafe:String = cursor.valueBuffer("codepigrafe");
		var codCuenta:String = cursor.valueBuffer("codcuenta");
		if (codEpigrafe != codCuenta.substring(0, codEpigrafe.length)) {
				MessageBox.critical(util.translate("scripts", 
						"El código de la cuenta debe tener como prefijo el de su epígrafe padre"),
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
		disconnect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged");
}

function oficial_bufferChanged(fN)
{
		switch(fN) {
				/** \C Al cambiar el --codepigrafe-- el --codcuenta-- tomará el mismo valor que el --codepigrafe--
				\end */
				case "codepigrafe":
						this.child("fdbCodCuenta").setValue(this.iface.calculateField("codcuenta"));
						this.child("fdbIdEpigrafe").setValue(this.iface.calculateField("idepigrafe"));
						break;
		}
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pgc2008 */
/////////////////////////////////////////////////////////////////
//// PGC 2008 //////////////////////////////////////////////////////

function pgc2008_init()
{
	this.iface.__init();
	
	var util:FLUtil = new FLUtil();
	if (util.sqlSelect("ejercicios", "plancontable", "codejercicio = '" + this.cursor().valueBuffer("codejercicio") + "'") == "08")
		this.child("fdbCodBalance").setDisabled(true);

}

//// PGC 2008 //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////