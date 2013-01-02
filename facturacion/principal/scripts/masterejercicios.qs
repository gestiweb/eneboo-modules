/***************************************************************************
                 masterejercicios.qs  -  description
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
		function imprimir() { return this.ctx.oficial_imprimir(); }
		function pbnPGC_clicked() { return this.ctx.oficial_pbnPGC_clicked(); }
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
/** \C El botón de plan general contable aparece habilitado cuando está cargado el módulo principal de contabilidad
\end */
function interna_init()
{
		var imprimir:Object = this.child("toolButtonPrint");
		connect(imprimir, "clicked()", this, "iface.imprimir");
		
		var pbnPGC:Object = this.child("pbnPGC");
		connect(pbnPGC, "clicked()", this, "iface.pbnPGC_clicked");
		
		if (!sys.isLoadedModule("flcontppal")) 
				pbnPGC.enabled = false;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Imprime un listado de ejercicios
\end */
function oficial_imprimir()
{
		var f:Object = new FLFormSearchDB("ejercicios_imp");
		var cursor:FLSqlCursor = f.cursor();

		cursor.setActivatedCheckIntegrity(false);
		cursor.select();
		if (!cursor.first())
				cursor.setModeAccess(cursor.Insert);
		else
				cursor.setModeAccess(cursor.Edit);

		f.setMainWidget();
		cursor.refreshBuffer();
		var acpt:String = f.exec("desde");
		if (acpt) {
				cursor.commitBuffer();
				var q:FLSqlQuery = new FLSqlQuery("ejercicios");
				q.setValueParam("from", cursor.valueBuffer("desde"));
				q.setValueParam("to", cursor.valueBuffer("hasta"));
				var rptViewer:FLReportViewer = new FLReportViewer();
				rptViewer.setReportTemplate("ejercicios");
				rptViewer.setReportData(q);
				rptViewer.renderReport();
				rptViewer.exec();
		}
}

/** \D Muestra el plan general contable asociado al ejercicio
\end */
function oficial_pbnPGC_clicked()
{
		var util:FLUtil = new FLUtil();
		var cursor:FLSqlCursor = this.cursor();
		var codEjercicio:String = this.cursor().valueBuffer("codejercicio");
		if (!codEjercicio)
				return;
		
		if (util.sqlSelect("co_epigrafes", "idepigrafe", 
				"codejercicio = '" + codEjercicio + "'")) {
				MessageBox.information(util.translate("scripts", 
						"El ejercicio ya tiene Plan General Contable asociado"),
						 MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				return;
		}

		cursor.setModeAccess(cursor.Edit);
		cursor.refreshBuffer();
		if (formRecordejercicios.iface.pub_buscarPlanContable(cursor))
				cursor.commitBuffer();
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
