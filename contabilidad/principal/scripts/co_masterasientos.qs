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

/** @class_declaration renAsientos */
//////////////////////////////////////////////////////////////////
//// renAsientos ////////////////////////////////////////////////
class renAsientos extends oficial {
    function renAsientos( context ) { oficial( context ); } 
	function init() {
		return this.ctx.renAsientos_init();
	}
	function renumerarAsientos() {
		return this.ctx.renAsientos_renumerarAsientos();
	}
}
//// renAsientos/////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends renAsientos {
    function head( context ) { renAsientos ( context ); }
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

const iface = new renAsientosPub( this );
//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration renAsientosPub */
//////////////////////////////////////////////////////////////////
//// renAsientos_PUB/////////////////////////////////////////////
class renAsientosPub extends ifaceCtx {
    function renAsientosPub( context ) { ifaceCtx( context ); } 
		
	function pub_renumerarAsientos() {
		return this.renumerarAsientos();
	}
}
//// renAsientos_PUB/////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

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
///////////////////////////////////////////////////////////////
/** @class_definition renAsientos */
//////////////////////////////////////////////////////////////////
//// renAsientos/////////////////////////////////////////////////
function renAsientos_init()
{
	this.iface.__init();
	connect(this.child("pbnRenum"), "clicked()", this, "iface.renumerarAsientos()");
}

function renAsientos_renumerarAsientos()
{
	var util:FLUtil = new FLUtil();
	var desEjercicio:String = util.sqlSelect("ejercicios", "nombre", "codejercicio = '" + this.iface.ejercicioActual + "'");
	var res:Number = MessageBox.information(util.translate("scripts", "Se va a proceder a renumerar todos los asientos del diario correspondientes al ejercicio:\n%1 - %2.\n\n¿Desea continuar?").arg(this.iface.ejercicioActual).arg(desEjercicio), MessageBox.No, MessageBox.Yes);

	if (res != MessageBox.Yes)
		return;
	
	var codEjercicio:String = flfactppal.iface.pub_ejercicioActual();
	var numAsiento:Number = 1;
	var rollback:Boolean = false;
	
	var curAsientos:FLSqlCursor = new FLSqlCursor("co_asientos");
	curAsientos.setActivatedCommitActions(false);
	curAsientos.select("codejercicio = '" + codEjercicio + "' order by fecha");
	var cursorBloqueado:FLSqlCursor = new FLSqlCursor("co_asientos");

	var i:Number = 0;
	util.createProgressDialog(util.translate("scripts", "Renumerando asientos..."), curAsientos.size());
	util.setProgress(0);

	var idAsiento:Number;
	
	curAsientos.transaction(false);
		
	while (curAsientos.next()) {
	
		idAsiento = curAsientos.valueBuffer("idasiento");
		
		if (curAsientos.valueBuffer("editable") == true) {
			curAsientos.setModeAccess(curAsientos.Edit);
			curAsientos.refreshBuffer();
			curAsientos.setValueBuffer("numero", numAsiento);
			if (!curAsientos.commitBuffer()) {
				debug("error en el asiento " + idAsiento);
				rollback = true;
				break;
			}
		} else {
			cursorBloqueado.setActivatedCommitActions(false);
			cursorBloqueado.select("idasiento = " + idAsiento);
			cursorBloqueado.first();
			cursorBloqueado.setUnLock("editable", true);

			cursorBloqueado.select("idasiento = " + idAsiento);
			cursorBloqueado.first();
			cursorBloqueado.setModeAccess(curAsientos.Edit);
			cursorBloqueado.refreshBuffer();
			cursorBloqueado.setValueBuffer("numero", numAsiento);
			if (!cursorBloqueado.commitBuffer()) {
				debug("error en el asiento bloq" + idAsiento);
				rollback = true;
				break;
			}

			cursorBloqueado.select("idasiento = " + idAsiento);
			cursorBloqueado.first();
			cursorBloqueado.setUnLock("editable", false);
			
		}
		numAsiento++;
		
		util.setProgress(i++);
	}

	
	
	var siguienteAsiento:Number = numAsiento;
	if (!rollback) {
		if (util.sqlSelect("co_secuencias", "idsecuencia", "codejercicio = '" + this.iface.ejercicioActual + "' AND nombre = 'nasiento' AND valorout IS NOT NULL")) {
			if (!util.sqlUpdate("co_secuencias", "valorout", siguienteAsiento, "codejercicio = '" + this.iface.ejercicioActual + "' AND nombre = 'nasiento'"))
				rollback = true;
		} else {
			if (!util.sqlUpdate("co_secuencias", "valor", siguienteAsiento, "codejercicio = '" + this.iface.ejercicioActual + "' AND nombre = 'nasiento'"))
				rollback = true;
		}
	}

	if (rollback)
			curAsientos.rollback();
	else {
		curAsientos.commit();
	}

	util.destroyProgressDialog();

	this.iface.tdbRecords.refresh();

	var totalAsientos:Number = util.sqlSelect("co_asientos", "COUNT(idasiento)", "codejercicio = '" + this.iface.ejercicioActual + "'");
	var ultimoAsiento:Number = util.sqlSelect("co_asientos", "numero", "codejercicio = '" + this.iface.ejercicioActual + "' ORDER BY numero DESC");
	if (totalAsientos != ultimoAsiento) {
		MessageBox.warning(util.translate("scripts", "Ha habido un error en la renumeración:\nEl total de asientos (%1) no coincide con el número del último asiento (%2).\nVuelva a realizar la renumeración.").arg(totalAsientos).arg(ultimoAsiento), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	var proxSecuencia:Number;
	if (util.sqlSelect("co_secuencias", "idsecuencia", "codejercicio = '" + this.iface.ejercicioActual + "' AND nombre = 'nasiento' AND valorout IS NOT NULL")) {
		proxSecuencia = util.sqlSelect("co_secuencias", "valorout", "codejercicio = '" + this.iface.ejercicioActual + "' AND nombre = 'nasiento'");
	} else {
		proxSecuencia = util.sqlSelect("co_secuencias", "valor", "codejercicio = '" + this.iface.ejercicioActual + "' AND nombre = 'nasiento'");
	}
	if (proxSecuencia != ++ultimoAsiento) {
		MessageBox.warning(util.translate("scripts", "Ha habido un error en la renumeración:\nEl siguiente número de asiento en la secuencia (%1) no coincide con el número del último asiento más uno (%2).\nVuelva a realizar la renumeración.").arg(proxSecuencia).arg(ultimoAsiento), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	MessageBox.information(util.translate("scripts", "Renumeración completada correctamente."), MessageBox.Ok, MessageBox.NoButton);
}
//// renAsientos ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////
