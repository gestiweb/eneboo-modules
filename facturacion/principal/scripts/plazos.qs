/***************************************************************************
                 plazos.qs  -  description
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
	function validateForm():Boolean { return this.ctx.interna_validateForm(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
		var totalAplazado:Number;
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
/** \C El valor de --aplazado-- aparece como el 100% menos el total acumulado hasta el momento
\end */
function interna_init()
{
		var cursor:FLSqlCursor = this.cursor();
		if ( cursor.modeAccess() == cursor.Insert || cursor.modeAccess() == cursor.Edit ) {
				var query:FLSqlQuery = new FLSqlQuery();
				query.setTablesList("plazos");
				query.setSelect("SUM(aplazado)");
				query.setFrom("plazos");
				query.setWhere("upper(codpago) = '" +
											 cursor.valueBuffer("codpago").upper() + "' AND id <> " +
											 parseInt(cursor.valueBuffer("id")) + ";");
				query.exec();
				if (query.next())
						this.iface.totalAplazado = parseFloat(query.value(0));
				if ( cursor.modeAccess() == cursor.Insert )
					this.child("aplazado").setValue(100 - this.iface.totalAplazado);
		}
}

function interna_validateForm():Boolean
{
		var aplazado:FLFieldDB = this.child("aplazado");
		var util:FLUtil = new FLUtil();

		/** \C El --aplazado-- debe ser mayor que cero
		\end */
		if (aplazado.value() <= 0) {
				MessageBox.critical(util.translate("scripts", "El % aplazado debe ser mayor que cero"),
						MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				aplazado.setValue(100 - this.iface.totalAplazado);
				aplazado.setFocus();
				aplazado.selectAll();
				return false;
		}

		/** \C La suma de los porcentaje aplazados debe ser igual al 100%
		\end */
		var nuevoAplazado:Number = parseFloat(aplazado.value()) + this.iface.totalAplazado;
		if (nuevoAplazado > 100) {
				MessageBox.critical(util.translate("scripts", "La suma de aplazamientos no puede superar el 100%"),
						MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				aplazado.setValue(100 - this.iface.totalAplazado);
				aplazado.setFocus();
				aplazado.selectAll();
				return false;
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
