/***************************************************************************
                 flpedidosaut.qs  -  description
                             -------------------
    begin                : 22-01-2007
    copyright            : (C) 2007 by Mathias Behrle
    email                : mathiasb@behrle.dyndns.org
    partly based on code by
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	function oficial( context ) { interna( context ); }
	function cambiarStockOrd(referencia:String, variacion:Number):Boolean {
		return this.ctx.oficial_cambiarStockOrd(referencia, variacion);
	}
}
/// OFICIAL /////////////////////////////////////////////////////
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
	function pub_cambiarStockOrd(referencia:String, variacion:Number):Boolean {
		return this.cambiarStockOrd(referencia, variacion);
	}
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
/** \D Se actualiza el campo stockord de la tabla articulos
\end */
function interna_init()
{
	var util:FLUtil;
	if (util.sqlSelect("articulos", "referencia", "stockord IS NULL")) {
	
		var curArticulos:FLSqlCursor = new FLSqlCursor("articulos");
		curArticulos.select("stockord IS NULL");
		
		while (curArticulos.next()) {
			curArticulos.setModeAccess(curArticulos.Edit);
			curArticulos.refreshBuffer();
			curArticulos.setValueBuffer("stockord", 0);
			if (!curArticulos.commitBuffer())
				return false;
		}
	}
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////


/** \D Cambia el valor del stock pedido de un articulo. 

@param referencia Referencia del artículo
@param variación Variación en el número de existencias del artículo
@return True si la modificación tuvo éxito, false en caso contrario
\end */
function oficial_cambiarStockOrd(referencia:String, variacion:Number):Boolean
{
	var util:FLUtil = new FLUtil();
	if (referencia == "" || !referencia)
		return true;

	var cantidadPrevia:Number;
	var cantidadNueva:Number;
	var curArticulos:FLSqlCursor = new FLSqlCursor("articulos");
	curArticulos.select("referencia = '" + referencia + "'");
	curArticulos.first();
	curArticulos.setModeAccess(curArticulos.Edit);
	curArticulos.refreshBuffer();
	cantidadPrevia = parseFloat(curArticulos.valueBuffer("stockord"));
	cantidadNueva = parseFloat(cantidadPrevia) + parseFloat(variacion);
	if (parseFloat(cantidadNueva) < 0)
		cantidadNueva = 0;
	curArticulos.setValueBuffer("stockord", cantidadNueva);
	if (!curArticulos.commitBuffer())
		return false;

	return true;
}



/// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
