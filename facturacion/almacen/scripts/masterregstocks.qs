/***************************************************************************
                 masterregstocks.qs  -  description
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
    var pbnTransferir:Object;
	function oficial( context ) { interna( context ); } 
	function pbnTransferir_clicked() {
		return this.ctx.oficial_pbnTransferir_clicked();
	}
	function transferirStock(idStock1:String):Boolean {
		return this.ctx.oficial_transferirStock(idStock1);
	}
	function transferencia(curTrans:FLSqlCursor):Boolean {
		return this.ctx.oficial_transferencia(curTrans);
	}
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration scab */
/////////////////////////////////////////////////////////////////
//// STOCKS CABECERA ////////////////////////////////////////////
class scab extends oficial {
	var tbnRevisarStock:Object;
    function scab( context ) { oficial ( context ); }
	function init() {
		return this.ctx.scab_init();
	}
	function tbnRevisarStock_clicked() {
		return this.ctx.scab_tbnRevisarStock_clicked();
	}
	function revisarStock(where:String):Boolean {
		return this.ctx.scab_revisarStock(where);
	}
}
//// STOCKS CABECERA ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends scab {
    function head( context ) { scab ( context ); }
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration ifaceCtx */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends head {
    function ifaceCtx( context ) { head( context ); }
	function pub_transferirStock(idStock1:String):Boolean {
		return this.transferirStock(idStock1);
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
/** \C La tabla de regularizaciones de stocks se muestra en modo de sólo lectura
\end */
function interna_init()
{
	//this.iface.pbnTransferir = this.child("pbnTransferir"); 
	//this.child("tdbRegStocks").setEditOnly(true);
	
	//connect(this.iface.pbnTransferir, "clicked()", this, "iface.pbnTransferir_clicked()");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_pbnTransferir_clicked()
{
	var cursor:FLSqlCursor = this.cursor();
	this.iface.transferirStock(cursor.valueBuffer("idstock"));
}

/** \D Realiza la transferencia de stock de un almacén a otro
@param idStock1: Identificador del stock desde el que se inicia la transferencia
@return	true si la transferencia se realiza correctamente, false en caso contrario
\end */
function oficial_transferirStock(idStock1:String):Boolean
{
	var util:FLUtil = new FLUtil;
	
	var referencia:String = util.sqlSelect("stocks", "referencia", "idstock = " + idStock1);
	if (!referencia)
		return false;
		
	var fecha:Date = new Date();
	
	var f:Object = new FLFormSearchDB("transstock");
	var curTrans:FLSqlCursor = f.cursor();
	
	curTrans.select();
	if (!curTrans.first())
		curTrans.setModeAccess(curTrans.Insert);
	else
		curTrans.setModeAccess(curTrans.Edit);
	
	f.setMainWidget();
	curTrans.refreshBuffer();
	curTrans.setValueBuffer("codalmacen2", "");
	curTrans.setValueBuffer("referencia", referencia);
	curTrans.setValueBuffer("idstock1", idStock1);
	curTrans.setValueBuffer("fecha", fecha);
	curTrans.setValueBuffer("hora", fecha);
	
	var acpt:String = f.exec("id");

	if (acpt) {
		if (!curTrans.commitBuffer())
			return false;
		var cantidad = parseFloat(curTrans.valueBuffer("cantidad"));
		if (!cantidad || isNaN(cantidad) || cantidad == 0) {
			MessageBox.warning(util.translate("scripts", "La cantidad a transferir no puede ser cero"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
		if (parseFloat(curTrans.valueBuffer("cantidadactual2")) == parseFloat(curTrans.valueBuffer("cantidadnueva2"))) {
			MessageBox.warning(util.translate("scripts", "No ha establecido el sentido de la transferencia"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
		
		curTrans.transaction(false);
		try {
			if (this.iface.transferencia(curTrans))
				curTrans.commit();
			else {
				curTrans.rollback();
				return false;
			}
		}
		catch (e) {
			curTrans.rollback();
			MessageBox.critical(util.translate("scripts", "Hubo un error en la transferencia:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}
	f.close();
	return true;
}

/** \D Realiza una transferencia de material de un almacén a otro
@param	curTrans: Cursor que contiene los datos de la transferencia a realizar
@return	true si la transferencia se realiza correctamente, false en caso contrario
\end */
function oficial_transferencia(curTrans:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	
	var codAlmacen2:String = curTrans.valueBuffer("codalmacen2");
	var codAlmacen1:String = util.sqlSelect("stocks", "codalmacen", "idstock = " +
	 curTrans.valueBuffer("idstock1"));
	var referencia:String = curTrans.valueBuffer("referencia");
	
	var idStock2:String = util.sqlSelect("stocks", "idstock", "codalmacen = '" + codAlmacen2 + "' AND referencia = '" + referencia + "'");
	if (!idStock2) {
		idStock2 = flfactalma.iface.pub_crearStock(codAlmacen2, referencia);
		if (!idStock2)
			return false;
	}
	var de1a2:Boolean;
	if (parseFloat(curTrans.valueBuffer("cantidadactual1")) < parseFloat(curTrans.valueBuffer("cantidadnueva1")))
		de1a2 = true;
	else
		de1a2 = false;
	
	var curLineaReg:FLSqlCursor = new FLSqlCursor("lineasregstocks");
	with(curLineaReg) {
		setModeAccess(Insert);
		refreshBuffer();
		setValueBuffer("idstock", curTrans.valueBuffer("idstock1"));
		setValueBuffer("fecha", curTrans.valueBuffer("fecha"));
		setValueBuffer("hora", curTrans.valueBuffer("hora"));
		setValueBuffer("codalmacendest", codAlmacen2);
		setValueBuffer("cantidadini", curTrans.valueBuffer("cantidadactual1"));
		setValueBuffer("cantidadfin", curTrans.valueBuffer("cantidadnueva1"));
		if (de1a2)
			setValueBuffer("motivo", util.translate("scripts", "Transferencia a ") + codAlmacen2);
		else
			setValueBuffer("motivo", util.translate("scripts", "Transferencia desde ") + codAlmacen2);
		if (!commitBuffer())
			return false;
	}
	if (!util.sqlUpdate("stocks", "cantidad", curTrans.valueBuffer("cantidadnueva1"), "idstock = " + curTrans.valueBuffer("idstock1")))
		return false;
		
	with(curLineaReg) {
		setModeAccess(Insert);
		refreshBuffer();
		setValueBuffer("idstock", idStock2);
		setValueBuffer("fecha", curTrans.valueBuffer("fecha"));
		setValueBuffer("hora", curTrans.valueBuffer("hora"));
		setValueBuffer("codalmacendest", codAlmacen1);
		setValueBuffer("cantidadini", curTrans.valueBuffer("cantidadactual2"));
		setValueBuffer("cantidadfin", curTrans.valueBuffer("cantidadnueva2"));
		if (de1a2)
			setValueBuffer("motivo", util.translate("scripts", "Transferencia desde ") + codAlmacen1);
		else
			setValueBuffer("motivo", util.translate("scripts", "Transferencia a ") + codAlmacen1);
		if (!commitBuffer())
			return false;
	}
	if (!util.sqlUpdate("stocks", "cantidad", curTrans.valueBuffer("cantidadnueva2"), "idstock = " + idStock2))
		return false;
	
	return true;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition scab */
/////////////////////////////////////////////////////////////////
//// STOCKS CABECERA ////////////////////////////////////////////
function scab_init()
{
	this.iface.__init();
	this.iface.tbnRevisarStock = this.child("tbnRevisarStock");

	connect (this.iface.tbnRevisarStock, "clicked()", this, "iface.tbnRevisarStock_clicked");
}

function scab_tbnRevisarStock_clicked()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	var codAlmacen:String = cursor.valueBuffer("codalmacen");
	if (!codAlmacen || codAlmacen == "") {
		return false;
	}

	var arrayOps:Array = [];
	arrayOps[0] = util.translate("scripts", "Actualizar el stock seleccionado");
	arrayOps[1] = util.translate("scripts", "Actualizar los stocks de %1").arg(codAlmacen);
	arrayOps[2] = util.translate("scripts", "Actualizar todos los stocks");

	var dialogo = new Dialog;
	dialogo.okButtonText = util.translate("scripts", "Aceptar");
	dialogo.cancelButtonText = util.translate("scripts", "Cancelar");
	
	var gbxDialogo = new GroupBox;
	gbxDialogo.title = util.translate("scripts", "Seleccione opción");
	
	var rButton:Array = new Array(arrayOps.length);
	for (var i:Number = 0; i < rButton.length; i++) {
		rButton[i] = new RadioButton;
		rButton[i].text = arrayOps[i];
		rButton[i].checked = false;
		gbxDialogo.add(rButton[i]);
	}
	
	dialogo.add(gbxDialogo);
	if (!dialogo.exec()) {
		return false;
	}
	var seleccion:Number = -1;
	for (var i:Number = 0; i < rButton.length; i++) {
		if (rButton[i].checked) {
			seleccion = i;
			break;
		}
	}
	if (seleccion == -1) {
		return false;
	}
	var where:String;
	switch (seleccion) {
		case 0: {
			where = "idstock = " + cursor.valueBuffer("idstock");
			break;
		}
		case 1: {
			where = "codalmacen = '" + codAlmacen + "'";
			break;
		}
		case 2: {
			where = "1 = 1";
			break;
		}
	}
	var curTransaccion:FLSqlCursor = new FLSqlCursor("empresa");
	curTransaccion.transaction(false);
	try {
		if (this.iface.revisarStock(where)) {
			curTransaccion.commit();
		} else {
			curTransaccion.rollback();
			MessageBox.warning(util.translate("scripts", "Error al revisar el stock"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	} catch(e) {
		curTransaccion.rollback();
		MessageBox.warning(util.translate("scripts", "Error al revisar el stock:") + e, MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	this.child("tdbRegStocks").refresh();
}

function scab_revisarStock(where:String):Boolean
{
	var util:FLUtil = new FLUtil;
	
	var curStock:FLSqlCursor = new FLSqlCursor("stocks");
	curStock.select(where);
	util.createProgressDialog(util.translate("scripts", "Revisando stocks..."), curStock.size());
	var paso:Number = 0;
	var canUltReg:Number;
	while (curStock.next()) {
		util.setProgress(++paso);
		curStock.setModeAccess(curStock.Edit);
		curStock.refreshBuffer();
		curStock.setValueBuffer("fechaultreg", formRecordregstocks.iface.pub_commonCalculateField("fechaultreg", curStock));
		curStock.setValueBuffer("horaultreg", formRecordregstocks.iface.pub_commonCalculateField("horaultreg", curStock));
		canUltReg = formRecordregstocks.iface.pub_commonCalculateField("cantidadultreg", curStock);
		if (!canUltReg || isNaN(canUltReg)) {
			canUltReg = 0;
		}
		curStock.setValueBuffer("cantidadultreg", canUltReg);
		curStock.setValueBuffer("reservada", formRecordregstocks.iface.pub_commonCalculateField("reservada", curStock));
		curStock.setValueBuffer("pterecibir", formRecordregstocks.iface.pub_commonCalculateField("pterecibir", curStock));
		curStock.setValueBuffer("cantidadac", formRecordregstocks.iface.pub_commonCalculateField("cantidadac", curStock));
		curStock.setValueBuffer("cantidadap", formRecordregstocks.iface.pub_commonCalculateField("cantidadap", curStock));
		curStock.setValueBuffer("cantidadfc", formRecordregstocks.iface.pub_commonCalculateField("cantidadfc", curStock));
		curStock.setValueBuffer("cantidadfp", formRecordregstocks.iface.pub_commonCalculateField("cantidadfp", curStock));
		curStock.setValueBuffer("cantidadts", formRecordregstocks.iface.pub_commonCalculateField("cantidadts", curStock));
		if (sys.isLoadedModule("flfact_tpv")) {
			curStock.setValueBuffer("cantidadtpv", formRecordregstocks.iface.pub_commonCalculateField("cantidadtpv", curStock));
		}
		curStock.setValueBuffer("cantidad", formRecordregstocks.iface.pub_commonCalculateField("cantidad", curStock));
		curStock.setValueBuffer("disponible", formRecordregstocks.iface.pub_commonCalculateField("disponible", curStock));
		if (!curStock.commitBuffer()) {
			util.destroyProgressDialog();
			return false;
		}
	}
	util.destroyProgressDialog();
	return true;
}
//// STOCKS CABECERA ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////