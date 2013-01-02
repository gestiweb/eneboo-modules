/***************************************************************************
                 crm_mastercausasmovimiento.qs  -  description
                             -------------------
    begin                : jue may 10 2007
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var tbnValorDefecto:Object;
	var tdbRecords:Object;

    function oficial( context ) { interna( context ); }
	function valorDefectoClicked() {
		return this.ctx.oficial_valorDefectoClicked();
	}
	function marcarValorDefecto(codCausa:String):Boolean {
		return this.ctx.oficial_marcarValorDefecto(codCausa);
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
	this.iface.tbnValorDefecto = this.child("tbnValorDefecto");
	this.iface.tdbRecords = this.child("tableDBRecords");
	
	connect(this.iface.tbnValorDefecto, "clicked()", this, "iface.valorDefectoClicked");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Abre una transacción y llama a la función que marca la causa seleccionada como el valor por defecto
\end */
function oficial_valorDefectoClicked()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var codCausa:String = cursor.valueBuffer("codcausa");
	if (!codCausa)
		return;

	cursor.transaction(false);
	try {
		if (this.iface.marcarValorDefecto(codCausa)) {
			cursor.commit();
			this.iface.tdbRecords.refresh();
		} else {
			cursor.rollback();
		}
	}
	catch (e) {
		cursor.rollback();
		MessageBox.critical(util.translate("scripts", "Hubo un error al marcar la causa seleccionada como valor por defecto:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
	}
}

/** \D Marca la causa seleccionada como el valor por defecto
@param	codCausa: causa que tomará el valor por defecto
@return	true si el cambio se realiza correctamente, false en caso contrario
\end */
function oficial_marcarValorDefecto(codCausa:String):Boolean
{
	var util:FLUtil = new FLUtil();
	if (!util.sqlUpdate("tpv_causasmovimiento", "valordefecto", "false", "valordefecto = true"))
		return false;

	if (!util.sqlUpdate("tpv_causasmovimiento", "valordefecto", "true", "codcausa = '" + codCausa + "'"))
		return false;
	return true;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
