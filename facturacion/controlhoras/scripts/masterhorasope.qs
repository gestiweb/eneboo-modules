/***************************************************************************
                 horasope.qs  -  description
                             -------------------
    begin                : jue nov 22 2007
    copyright            : (C) 2007 by KLO Ingeniería Informática S.L.L.
    email                : software@klo.es
    partly based on code by
    copyright            : (C) 2004 by InfoSiAL S.L.
    email                : mail@infosial.com
 ***************************************************************************/
 /***************************************************************************
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; version 2 of the License.               *
 ***************************************************************************/
/***************************************************************************
   Este  programa es software libre. Puede redistribuirlo y/o modificarlo
   bajo  los  términos  de  la  Licencia  Pública General de GNU   en  su
   versión 2, publicada  por  la  Free  Software Foundation.
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
//	function init() { this.ctx.interna_init(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration  oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    function oficial( context ) { interna( context ); } 

	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.oficial_commonCalculateField(fN, cursor);
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
	function pub_commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.commonCalculateField(fN, cursor);
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

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_commonCalculateField(fN:String, cursor:FLSqlCursor):String
{
		var util = new FLUtil();
		var valor;

//		MessageBox.critical(cursor.valueBuffer("idparte"),MessageBox.Ok, MessageBox.NoButton,MessageBox.NoButton);

		switch (fN) {
			/** \C
			El --Total Horas-- es la suma de las horas trabajadas en un parte de trabajo
			\end */
			case "totalhoras": {
				valor = util.sqlSelect("lineashorasope", "SUM(horastrabajadas)", "idparte = " + cursor.valueBuffer("idparte"));
				break;
			}
			/** \C
			El --Total Horas Jornada-- es la suma de las horas de la jornada de los operarios en un parte de trabajo
			\end */
			case "totalhorasjornada": {
				valor = util.sqlSelect("lineashorasope", "SUM(horasjornada)", "idparte = " + cursor.valueBuffer("idparte"));
				break;
			}
			/** \C
			El --Total Horas Extra-- es la suma de las horas extra de los operarios en un parte de trabajo
			\end */
			case "totalhorasextra": {
				valor = util.sqlSelect("lineashorasope", "SUM(horasextra)", "idparte = " + cursor.valueBuffer("idparte"));
				break;
			}
			/** \C
			El --Numero Operarios-- es número de operarios que han trabajado en dicho parte
			\end */
			case "numerooperarios": {
				valor = util.sqlSelect("lineashorasope", "COUNT('codoperario')", "idparte = " + cursor.valueBuffer("idparte"));
				break;
			}
		}
		return valor;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
