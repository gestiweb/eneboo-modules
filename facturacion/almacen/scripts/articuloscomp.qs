/***************************************************************************
                 articuloscomp.qs  -  description
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
    function init() { this.ctx.interna_init(); }
	function validateForm():Boolean {
		return this.ctx.interna_validateForm();
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	function oficial( context ) { interna( context ); }
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
/** \C El valor de --stockfis-- se calcula automáticamente para cada artículo como la suma de existencias del artículo en todos los almacenes.
\end */
function interna_init()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	this.child("fdbRefComponente").setFilter("1 = 1");

	var referencia:String = "";
	switch (cursor.modeAccess()) {
		case cursor.Insert: {
			referencia = formRecordarticulos.iface.referenciaComp_;
			cursor.setValueBuffer("refcompuesto",referencia);
			
			idTipoOpcionArt = formRecordarticulos.iface.idTipoOpcionArt_;
			if (idTipoOpcionArt) {
				var idOpcionArticulo:String =  formRecordarticulos.iface.pub_buscarOpcionActual(idTipoOpcionArt);
				this.child("fdbIdTipoOpcionArt").setValue(idTipoOpcionArt);
				this.child("fdbIdOpcionArticulo").setValue(idOpcionArticulo);
			}
		
			if(!referencia || referencia == "")
				referencia = this.child("fdbRefCompuesto").value();
		
			var lista:String = "";
			if (referencia && referencia != "") {
				lista = flfactalma.iface.pub_calcularFiltroReferencia(referencia);
		
				if (lista && lista != "")
					this.child("fdbRefComponente").setFilter("1 = 1 AND referencia NOT IN (" + lista + ")");
			}
			break;
		}
		case cursor.Edit : {
			this.child("fdbRefComponente").setDisabled(true);
			this.child("fdbRefCompuesto").setDisabled(true);
			break;
		}
	}

	this.child("fdbIdTipoOpcionArt").setFilter("referencia = '" + cursor.valueBuffer("refcompuesto") + "'");
}

function interna_validateForm():Boolean
{
	return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
