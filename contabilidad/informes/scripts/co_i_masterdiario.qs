 /***************************************************************************
                 i_masteralbaranesprov.qs  -  description
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    function oficial( context ) { interna( context ); } 
		function lanzar() {
				return this.ctx.oficial_lanzar();
		}
		function obtenerOrden(nivel:Number, cursor:FLSqlCursor):String {
				return this.ctx.oficial_obtenerOrden(nivel, cursor);
		}
		function comprobarTodosAsientos() {
				return this.ctx.oficial_comprobarTodosAsientos();
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
/** \C El botón de impresión lanza el informe
\end */
function interna_init()
{ 
		this.iface.comprobarTodosAsientos();
		connect(this.child("toolButtonPrint"), "clicked()", this, "iface.lanzar()");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Lanza el informe 
\end */
function oficial_lanzar()
{
		var cursor:FLSqlCursor = this.cursor();

		if (!cursor.isValid())
				return;

/** \D Lee el valor del campo tipo para establecer el nombre del report (archivo .kut) que será llamado en la ejecución del informe
\end */
		var tipoInforme:String = cursor.valueBuffer("tipo");
		var nombreInforme:String = cursor.action();
		var nombreReport:String = nombreInforme;

		switch (tipoInforme) {

		case "Borrador":
				nombreReport = nombreReport + "_b";
				break;

		case "Analitico":
				nombreReport = nombreReport + "_a";
				break;

		case "Oficial":
				nombreReport = nombreReport + "_o";
				break;

		case "Oficial mensual":
				nombreReport = nombreReport + "_om";
				break;

		}

/** \D Si el informe incluye datos de I.V.A. se añade '_iva' al final del nombre del reporte
\end */
		if (cursor.valueBuffer("datosIva") == 1)
				nombreReport = nombreReport + "_iva";


	var orderBy:String = "";
/** \D Si el informe se debe agrupar por meses se añade '_mes' al final del nombre del reporte
\end */
		if (cursor.valueBuffer("agruparmeses") == 1) {
				nombreReport = nombreReport + "_mes";
				nombreInforme = nombreInforme + "_mes";
				orderBy = "co_asientos.fecha";
		}

/** \D Se añade un ORDER BY a la consulta en función de los niveles de ordenamiento seleccionados
\end */
	
		var o:String = "";
		for (var i:Number = 1; i <= 3; i++) {
				o = this.iface.obtenerOrden(i, cursor);
				if (o) {
						if (orderBy == "")
								orderBy = o;
						else
								orderBy += ", " + o;
				}
		}
		flcontinfo.iface.pub_lanzarInforme(cursor, nombreInforme, nombreReport, orderBy, "", "", cursor.valueBuffer("id"));
}

/** \D Devuelve un criterio de orden para el informe en base a su nivel. Si el orden está marcado como descendente, se añade DESC al valor devuelto. Se utiliza para crear la cláusula ORDER BY de la consulta del informe

@param nivel Nivel de ordenamiento (1, 2, 3...)
@param cursor Cursor sobre la tabla de informes de diario
@return Criterio de ordenación (y opcionalmente DESC).
*/
function oficial_obtenerOrden(nivel:Number, cursor:FLSqlCursor):String
{
		var ret:String = "";
		var orden:String = cursor.valueBuffer("orden" + nivel.toString());

		switch (orden) {
		case "Asiento":
				ret += "co_asientos.numero";
				break;
		case "Fecha":
				ret += "co_asientos.fecha";
				break;
		case "Subcuenta":
				ret += "co_subcuentas.codsubcuenta";
				break;
		}

		if (ret != "") {
				var tipoOrden:String = cursor.valueBuffer("tipoorden" + nivel.toString());
				if (tipoOrden == "Descendente")
						ret += " DESC";
		}
		return ret;
}

/** \D Si está marcada la opción --todosasientos-- se busca el mayor y el menor
\end */
function oficial_comprobarTodosAsientos() {

		var q:FLSqlQuery = new FLSqlQuery();
		var curDiario:FLSqlCursor = new FLSqlCursor("co_i_diario");
		
		curDiario.select("1=1");
		while (curDiario.next()) {
				
				if (!curDiario.valueBuffer("todosasientos")) continue;
				
				q.setTablesList("co_asientos");
				q.setSelect("MIN(numero), MAX(numero)");
				q.setFrom("co_asientos");
				q.setWhere("codejercicio = '" + 
							curDiario.valueBuffer("i_co__subcuentas_codejercicio") + "'");
						
				if (!q.exec()) continue;
				if (!q.first()) continue;

				curDiario.setModeAccess(curDiario.Edit);
				curDiario.refreshBuffer();
				curDiario.setValueBuffer("d_co__asientos_numero", q.value(0));
				curDiario.setValueBuffer("h_co__asientos_numero", q.value(1));
				curDiario.commitBuffer();
		}
 		this.child("tableDBRecords").refresh();
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
