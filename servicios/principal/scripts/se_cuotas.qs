/***************************************************************************
                 se_coutas.qs  -  description
                             -------------------
    begin                : lun jun 21 2005
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
////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

/** @class_declaration interna */
//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
class interna {
    var ctx:Object;
    function interna( context ) { this.ctx = context; }
    function init() { this.ctx.interna_init(); }
	function validateForm():Boolean{ return this.ctx.interna_validateForm(); }
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

function interna_init()
{
}

function interna_validateForm()
{
		var util:FLUtil = new FLUtil;
		var limiteInferior:Number = this.child("fdbLimiteInferior").value();
		var limiteSuperior:Number = this.child("fdbLimiteSuperior").value();
		var tipoContrato:String = this.child("fdbTipoContrato").value();

/** \C El limite inferior debe ser un numero positivo
\end */
		if (limiteInferior < 0) {
				MessageBox.critical(util.translate("scripts", "El limite inferior debe ser un numero positivo"),
						MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				return false;
		}

/** \C El limite superior del intervalo debe ser mayor que el limite inferior
\end */
		if (parseFloat(limiteInferior) > parseFloat(limiteSuperior)) {
				MessageBox.critical(util.translate("scripts", 
						"El limite superior del intervalo debe ser mayor que el limite inferior"), 
						MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				return false;
		}

/** \C El intervalo de pesos de parche de una cuota no podrá superponerse a ningún otro
\end */
		var cursor:FLSqlCursor = this.cursor();
		if (cursor.modeAccess() == cursor.Insert || cursor.modeAccess() == cursor.Edit) {
				var query:FLSqlQuery = new FLSqlQuery();
				query.setTablesList("se_cuotas");
				query.setSelect("limiteinferior");
				query.setFrom("se_cuotas");
				query.setWhere("((limiteinferior BETWEEN " + limiteInferior +
											 " AND " + limiteSuperior + ") OR (" +
											 "limitesuperior BETWEEN " + limiteInferior + 
											 " AND " + limiteSuperior + "))" +
											 " AND id <> " + parseFloat(cursor.valueBuffer("id")) +
											 " AND tipocontrato = '" + tipoContrato + "'" +
											 ";");
											 debug(query.sql());
				query.exec();
				if (query.next()) {
						MessageBox.critical(util.translate("scripts", 
								"El intervalo introducido se superpone a otro intervalo ya existente"),
								MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
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
