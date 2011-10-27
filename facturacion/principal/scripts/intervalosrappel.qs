/***************************************************************************
                 intervalosrappel.qs  -  description
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
    function validateForm():Boolean { return this.ctx.interna_validateForm(); }
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
function interna_validateForm():Boolean
{
		var limiteinferior:FLFieldDB = this.child("limiteinferior");
		var limitesuperior:FLFieldDB = this.child("limitesuperior");
		var descuento:FLFieldDB = this.child("descuento");
		var util:FLUtil = new FLUtil;

		var limiteInferior:Number = parseFloat(limiteinferior.value());
		var limiteSuperior:Number = parseFloat(limitesuperior.value());

/** \C El porcentaje de descuento debe ser un numero entre 0 y 100
\end */
		if (descuento.value() < 0 || parseFloat(descuento.value()) > 100) {
				MessageBox.critical(util.translate("scripts", "El % de descuento debe ser un numero entre 0 y 100"),
						MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				descuento.setFocus();
				descuento.selectAll();
				return false;
		}

/** \C El limite inferior debe ser un numero positivo
\end */
		if (limiteInferior <= 0) {
				MessageBox.critical(util.translate("scripts", "El limite inferior debe ser un numero positivo"),
						MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				limiteinferior.setFocus();
				limiteinferior.selectAll();
				return false;
		}

/** \C El limite superior del intervalo debe ser mayor que el limite inferior
\end */
		if (parseFloat(limiteInferior) > parseFloat(limiteSuperior)) {
				MessageBox.critical(util.translate("scripts", 
						"El limite superior del intervalo debe ser mayor que el limite inferior"), 
						MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				limitesuperior.setFocus();
				limitesuperior.selectAll();
				return false;
		}

/** \C Los intervalos no pueden superponerse
\end */
		var cursor:FLSqlCursor = this.cursor();
		if (cursor.modeAccess() == cursor.Insert || cursor.modeAccess() == cursor.Edit) {
				var query:FLSqlQuery = new FLSqlQuery();
				query.setTablesList("intervalosrappel");
				query.setSelect("limiteinferior");
				query.setFrom("intervalosrappel");
				query.setWhere("((limiteinferior BETWEEN " + limiteInferior +
											 " AND " + limiteSuperior + ") OR (" +
											 "limitesuperior BETWEEN " + limiteInferior + " AND " +
											 limiteSuperior + "))" + " AND upper(codtiporappel) = '" +
											 cursor.valueBuffer("codtiporappel").upper() +
											 "' AND id <> " + parseFloat(cursor.valueBuffer("id")) +
											 ";");
				query.exec();
				if (query.next()) {
						MessageBox.critical(util.translate("scripts", 
								"El intervalo introducido se superpone a otro intervalo ya existente"),
								MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
						limitesuperior.setFocus();
						limitesuperior.selectAll();
						return false;
				}
		}
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
