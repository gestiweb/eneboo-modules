/***************************************************************************
                 co_masterasientos.qs  -  description
                             -------------------
    begin                : jue jul 22 2004
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
	var pteAsientoPre:Boolean;
	var tdbRecords:FLTableDB;
	var ejercicioActual:String;
	
	function oficial( context ) { interna( context ); } 
	function pendientePre():Boolean {
		return this.ctx.oficial_pendientePre();
	}
	function establecerPendientePre(pte:Boolean) {
		return this.ctx.oficial_establecerPendientePre(pte);
	}
	function rellenarConceptos() {
		return this.ctx.oficial_rellenarConceptos();
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
	function pub_pendientePre() {
		return this.pendientePre();
	}
	function pub_establecerPendientePre(pte:Boolean) {
		return this.establecerPendientePre(pte);
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
/** \C El formulario mostrará los asientos asociados al ejercicio actual
\end */
function interna_init()
{
		var util:FLUtil = new FLUtil();
		var cursor:FLSqlCursor = this.cursor();

		this.iface.tdbRecords = this.child("tableDBRecords");
		this.iface.ejercicioActual = flfactppal.iface.pub_ejercicioActual();
		this.iface.pteAsientoPre = false;
		
		connect(this.child("pbnConceptos"), "clicked()", this, "iface.rellenarConceptos");
		cursor.setMainFilter("codEjercicio = '" + this.iface.ejercicioActual + "'");
		this.iface.tdbRecords.refresh();
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_pendientePre():Boolean
{
	return this.iface.pteAsientoPre;
}

function oficial_establecerPendientePre(pte:Boolean)
{
	this.iface.pteAsientoPre = pte;
}

function oficial_rellenarConceptos()
{
	var util:FLUtil = new FLUtil();
	
	var res:Object = MessageBox.information(util.translate("scripts",  "A continuación se rellenarán los conceptos vacíos de los asientos de este ejercicio\nPara ello se copiará el concepto de la primera partida de cada asiento\n\n¿Desea continuar?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
	if (res != MessageBox.Yes)
		return;
	
	var codEjercicio:String = flfactppal.iface.pub_ejercicioActual();
	
	var curAsientos:FLSqlCursor = new FLSqlCursor("co_asientos");
	curAsientos.setActivatedCommitActions(false);
	curAsientos.select("(concepto is NULL OR concepto = '' OR importe = 0) AND codejercicio = '" + codEjercicio + "'");
	var cursorBloqueado:FLSqlCursor = new FLSqlCursor("co_asientos");

	var i:Number = 0;
	util.createProgressDialog(util.translate("scripts", "Rellenando conceptos..."), curAsientos.size());
	util.setProgress(0);

	var idAsiento:Number, idPartida:Number;
	var datosPartida:Array;
		
	while (curAsientos.next()) {
	
		idAsiento = curAsientos.valueBuffer("idasiento");
		
		datosPartida = flfactppal.iface.pub_ejecutarQry("co_partidas", "concepto,idconcepto,documento,tipodocumento", "concepto IS NOT NULL AND idasiento = " + idAsiento + " order by documento");
		if (datosPartida.result < 1)
			continue;
		
		if (curAsientos.valueBuffer("editable") == true) {
			curAsientos.setModeAccess(curAsientos.Edit);
			curAsientos.refreshBuffer();
			curAsientos.setValueBuffer("concepto", datosPartida.concepto);
			curAsientos.setValueBuffer("idconcepto", datosPartida.idconcepto);
			curAsientos.setValueBuffer("documento", datosPartida.documento);
			curAsientos.setValueBuffer("tipodocumento", datosPartida.tipodocumento);
			if (!curAsientos.commitBuffer())
				return false;
	
			if (!flcontppal.iface.pub_comprobarAsiento(idAsiento))
				return false;
		} else {
			cursorBloqueado.setActivatedCommitActions(false);
			cursorBloqueado.select("idasiento = " + idAsiento);
			cursorBloqueado.first();
			cursorBloqueado.setUnLock("editable", true);

			cursorBloqueado.select("idasiento = " + idAsiento);
			cursorBloqueado.first();
			cursorBloqueado.setModeAccess(curAsientos.Edit);
			cursorBloqueado.refreshBuffer();
			cursorBloqueado.setValueBuffer("concepto", datosPartida.concepto);
			cursorBloqueado.setValueBuffer("idconcepto", datosPartida.idconcepto);
			cursorBloqueado.setValueBuffer("documento", datosPartida.documento);
			cursorBloqueado.setValueBuffer("tipodocumento", datosPartida.tipodocumento);
			if (!cursorBloqueado.commitBuffer())
				return false;

			if (!flcontppal.iface.pub_comprobarAsiento(idAsiento))
				return false;

			cursorBloqueado.select("idasiento = " + idAsiento);
			cursorBloqueado.first();
			cursorBloqueado.setUnLock("editable", false);
		}
		
		util.setProgress(i++);
	}

	util.destroyProgressDialog();
	
	this.iface.tdbRecords.refresh();
	
	MessageBox.information(util.translate("scripts",  "Proceso finalizado. Se actualizaron conceptos de %0 asientos").arg(curAsientos.size()), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);	
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
