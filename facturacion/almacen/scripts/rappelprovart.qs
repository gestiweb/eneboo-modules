/***************************************************************************
                     rappelprovart.qs  -  description
                             -------------------
    begin                : mie nov 1 2006
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

/** @class_declaration rappel */
/////////////////////////////////////////////////////////////////
//// RAPPEL /////////////////////////////////////////////////////
class rappel extends oficial {
    function rappel( context ) { oficial ( context ); }
	function validateForm():Boolean {
		return this.ctx.rappel_validateForm();
	}
}
//// RAPPEL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends rappel {
    function head( context ) { rappel ( context ); }
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
function validateForm():Boolean {
    return this.iface.validateForm();
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition rappel */
/////////////////////////////////////////////////////////////////
//// RAPPEL /////////////////////////////////////////////////////
function rappel_validateForm():Boolean
{
	var fdbLimiteInferior:FLFieldDB = this.child("fdbLimiteInferior");
	var fdbLimiteSuperior:FLFieldDB = this.child("fdbLimiteSuperior");
	var fdbDescuento:FLFieldDB = this.child("fdbDescuento");

	var limiteInferior:Number = parseFloat(fdbLimiteInferior.value());
	var limiteSuperior:Number = parseFloat(fdbLimiteSuperior.value());
	var descuento:Number = parseFloat(fdbDescuento.value());
	
	var util:FLUtil = new FLUtil;

/** \C El porcentaje de descuento debe ser un numero entre 0 y 100
*/
	if (descuento < 0 || descuento > 100) {
		MessageBox.critical(util.translate("scripts", "El % de descuento debe ser un numero entre 0 y 100"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		fdbDescuento.setFocus();
		fdbDescuento.selectAll();
		return false;
	}

/** \C El limite inferior debe ser un numero positivo
*/
	if (limiteInferior <= 0) {
		MessageBox.critical(util.translate("scripts", "El limite inferior debe ser un numero positivo"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		fdbLimiteInferior.setFocus();
		fdbLimiteInferior.selectAll();
		return false;
	}

/** \C El limite superior del intervalo debe ser mayor que el limite inferior
*/
	if (limiteInferior > limiteSuperior) {
		MessageBox.critical(util.translate("scripts", "El limite superior del intervalo debe ser mayor que el limite inferior"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		fdbLimiteSuperior.setFocus();
		fdbLimiteSuperior.selectAll();
		return false;
	}

/** \C Los intervalos no pueden superponerse
*/
	var cursor:FLSqlCursor = form.cursor();
	if (cursor.modeAccess() == cursor.Insert || cursor.modeAccess() == cursor.Edit) {
		var query:FLSqlQuery = new FLSqlQuery();
		query.setTablesList("rappelprovart");
		query.setSelect("limiteinferior");
		query.setFrom("rappelprovart");
		query.setWhere("((limiteinferior BETWEEN " + limiteInferior + " AND " + limiteSuperior + ") OR (" + "limitesuperior BETWEEN " + limiteInferior + " AND " + limiteSuperior + "))" + " AND id = '" + cursor.valueBuffer("id") + "' AND idrappel <> " + cursor.valueBuffer("idrappel") + ";");
		if (!query.exec())
			return false;
		if (query.next()) {
			MessageBox.critical(util.translate("scripts", "El intervalo introducido se superpone a otro intervalo ya existente"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			fdbLimiteSuperior.setFocus();
			fdbLimiteSuperior.selectAll();
			return false;
		}
	}
	return true;
}
//// RAPPEL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
