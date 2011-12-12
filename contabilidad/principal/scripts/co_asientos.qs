/***************************************************************************
                 co_asientos.qs  -  description
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
	function calculateField( fN:String ):String { return this.ctx.interna_calculateField( fN ); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var tdbPartidas:FLTableDB;
	var tbnPredefinido:Object;
	var usandoPredefinido:String;
	function oficial( context ) { interna( context ); } 
	function calculaDescuadre() {
		this.ctx.oficial_calculaDescuadre();
	}
	function tbnPredefinido_clicked() {
		this.ctx.oficial_tbnPredefinido_clicked();
	}
	function mostrarDatosSubcuenta() {
		return this.ctx.oficial_mostrarDatosSubcuenta();
	}
	function terminarPredefinido() {
		return this.ctx.oficial_terminarPredefinido();
	}
	function mostrarConceptoAsiento() {
		return this.ctx.oficial_mostrarConceptoAsiento();
	}
	function accionesCommitPartidas() {
		return this.ctx.oficial_accionesCommitPartidas();
	}
	function validarPartidasAsiento():Boolean {
		return this.ctx.oficial_validarPartidasAsiento();
	}
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration modelos */
/////////////////////////////////////////////////////////////////
//// MODELOS FISCALES ///////////////////////////////////////////
class modelos extends oficial {
    function modelos( context ) { oficial ( context ); }
	function init() {
		return this.ctx.modelos_init();
	}
	function habilitarPestanaModelos() {
		return this.ctx.modelos_habilitarPestanaModelos();
	}
}
//// MODELOS FISCALES ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration modelo347 */
/////////////////////////////////////////////////////////////////
//// MODELO 347 /////////////////////////////////////////////////
class modelo347 extends modelos {
    function modelo347( context ) { modelos ( context ); }
	function init() {
		return this.ctx.modelo347_init();
	}
	function habilitarPestanaModelos() {
		return this.ctx.modelo347_habilitarPestanaModelos();
	}
	function bufferChanged(fN:String) {
		return this.ctx.modelo347_bufferChanged(fN);
	}
	function bufferChanged(fN:String) {
		return this.ctx.modelo347_bufferChanged(fN);
	}
	function habilitar347() {
		return this.ctx.modelo347_habilitar347();
	}
}
//// MODELO 347 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends modelo347 {
    function head( context ) { modelo347 ( context ); }
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration ifaceCtx */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends head {
    function ifaceCtx( context ) { head( context ); }
	function pub_terminarPredefinido() {
		return this.terminarPredefinido();
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
/** \C Los nuevos asientos creados pertencen al ejercicio vigente en el momento de crearlos
\end */
function interna_init()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	this.iface.mostrarDatosSubcuenta();
	this.iface.tdbPartidas = this.child("tdbPartidas");
	this.iface.tbnPredefinido = this.child("tbnPredefinido");
	this.iface.usandoPredefinido = false;

	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this.iface.tdbPartidas.cursor(), "newBuffer()", this, "iface.mostrarDatosSubcuenta");
	connect(this.iface.tdbPartidas.cursor(), "bufferCommited()", this, "iface.accionesCommitPartidas");
	connect(this.iface.tbnPredefinido, "clicked()", this, "iface.tbnPredefinido_clicked");
		
	if (cursor.modeAccess() == cursor.Insert) {
		cursor.setValueBuffer("codejercicio", flfactppal.iface.pub_ejercicioActual());
		this.child("fdbAsiento").setValue(flcontppal.iface.siguienteNumero(cursor.valueBuffer("codejercicio"), "nasiento"));

		var miVar:FLVar = new FLVar();
		var tipoPredefinido:String = miVar.get("TIPOPRE");
		if (tipoPredefinido) {
			if (formco_asientos.iface.pub_pendientePre()) {
				formco_asientos.iface.pub_establecerPendientePre(false);
				var res:Number = MessageBox.information(util.translate("scripts", "Siguiente asiento:\n%1").arg(util.sqlSelect("co_planasientos", "descripcion", "codplanasiento = '" + tipoPredefinido + "'")), MessageBox.Ok, MessageBox.Cancel);
				if (res == MessageBox.Ok) {
					this.child("fdbCodPlanAsiento").setValue(tipoPredefinido);
					this.iface.tbnPredefinido_clicked();
				}
			}
		}
	} else {
		this.iface.tbnPredefinido.enabled = false;
	}
	this.iface.calculaDescuadre();
}

/** \C El asiento deberá presentar descuadre cero
\end */
function interna_validateForm():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	cursor.setValueBuffer("importe", this.iface.calculateField("importe"));

	this.iface.calculaDescuadre();
	if (parseFloat(this.child("ledDescuadre").text) != 0) {
		MessageBox.warning(util.translate("scripts", "El descuadre del asiento debe ser cero"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	if (!flcontppal.iface.pub_comprobarAsiento(cursor.valueBuffer("idasiento"), true))
		return false;

	return true;
}

function interna_calculateField( fN ):String
{
	var util:FLUtil = new FLUtil();
	var result:String;
	var cursor:FLSqlCursor = this.cursor();

	switch(fN) {
		/** \D Se calcula el descuadre del asiento: total del debe - total del haber en sus partidas
		\end */
		case "ledDescuadre": {
			var debe:Number = util.sqlSelect("co_partidas", "SUM(debe)", "idasiento = " + cursor.valueBuffer("idasiento"));
			var haber:Number = util.sqlSelect("co_partidas", "SUM(haber)", "idasiento = " + cursor.valueBuffer("idasiento"));
			var valorDescuadre:Number = debe - haber;
			result = Math.round(valorDescuadre * 100) / 100 
			result = util.roundFieldValue(result, "co_partidas", "debe");
			break;
		}
		case "importe": {
			result = util.sqlSelect("co_partidas", "SUM(debe)", "idasiento = " + cursor.valueBuffer("idasiento"));
			result = util.roundFieldValue(result, "co_asientos", "importe");
			break;
		}
	}
	
	return result;
}



//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

/** \D Actualiza el valor de la etiqueta de descuadre
\end */
function oficial_calculaDescuadre()
{
	var util:FLUtil = new FLUtil;
	this.child("ledDescuadre").text = this.iface.calculateField("ledDescuadre");
	if (this.iface.usandoPredefinido == "Terminado") {
		var siguientePlan:String = util.sqlSelect("co_planasientos", "concatenar", "codplanasiento = '" + this.cursor().valueBuffer("codplanasiento") + "'");
		if (siguientePlan && siguientePlan != "") {
			var miVar:FLVar = new FLVar();
			if (!miVar.set("TIPOPRE", siguientePlan))
				return false;
			formco_asientos.iface.pub_establecerPendientePre(true);
			this.child("pushButtonAcceptContinue").animateClick();
		} else {
			flcontppal.iface.pub_clearPreMemoria();
		}
	}
}

/** \D Marca el asiento predefinido como Terminado. Sirve para que el formulario sepa que tiene que pasar al siguiente asiento.
\end */
function oficial_terminarPredefinido()
{
	this.iface.usandoPredefinido = "Terminado";
}

/** \D Da a elegir al usuario entre una serie de opciones de partidas predefinidas
\end */
function oficial_tbnPredefinido_clicked()
{
	var cursor:FLSqlCursor = this.iface.tdbPartidas.cursor();
	var miVar:FLVar = new FLVar();
	cursor.setAction("co_partidaspre");
	var tipoPredefinido:String = this.cursor().valueBuffer("codplanasiento");
	if (tipoPredefinido) {
		this.iface.usandoPredefinido = "En uso";
		if (!miVar.set("TIPOPRE", tipoPredefinido))
			return false;
		this.iface.tdbPartidas.cursor().insertRecord();
		//this.child("toolButtonInsertPar").animateClick();
	}
}

function oficial_mostrarDatosSubcuenta()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.child("tdbPartidas").cursor();	

	if(!cursor.isValid()){
		this.child("lblDatosSubcuenta").text = "";
		return;
	}
	
	var idSubcuenta:String = this.child("tdbPartidas").cursor().valueBuffer("idsubcuenta");
	var q:FLSqlQuery = new FLSqlQuery();
	
	q.setTablesList("co_subcuentas");
	q.setSelect("codsubcuenta,descripcion,saldo");
	q.setFrom("co_subcuentas");
	q.setWhere("idsubcuenta = '" + idSubcuenta + "'");
	if (!q.exec())
		return false;
	if (!q.first())
		return false;
	var codsubcuenta:String = q.value(0);
	var descripcion:String = q.value(1);
	var saldo:String = util.roundFieldValue(q.value(2), "co_subcuentas", "saldo");
			
	this.child("lblDatosSubcuenta").text = codsubcuenta + " - " + descripcion;
	this.child("lblSaldoSubcuenta").text = saldo;
}

function oficial_accionesCommitPartidas()
{
	this.iface.mostrarConceptoAsiento();

	var predefinido:String = this.cursor().valueBuffer("codplanasiento");
	if(predefinido && predefinido != "" && this.iface.usandoPredefinido == "Terminado") {
		if(this.iface.validarPartidasAsiento())
			this.iface.usandoPredefinido = false;
		this.iface.tdbPartidas.refresh();
	}
}

function oficial_validarPartidasAsiento():Boolean
{
	var util:FLUtil;

	var idAsiento:Number = this.cursor().valueBuffer("idasiento");

	var curPartidas:FLSqlCursor = new FLSqlCursor("co_partidas");
	curPartidas.select("idasiento = " + idAsiento + " ORDER BY idpartida");

	var qPlantillas:FLSqlQuery = new FLSqlQuery();
	qPlantillas.setTablesList("co_planpartidas");
	qPlantillas.setSelect("saltarsicero");
	qPlantillas.setFrom("co_planpartidas");
	qPlantillas.setWhere("codplanasiento = '" + this.cursor().valueBuffer("codplanasiento") + "' ORDER BY numorden");
	if (!qPlantillas.exec())
		return false;

	while(curPartidas.next() && qPlantillas.next()) {
		if(qPlantillas.value("saltarsicero") && curPartidas.valueBuffer("debe") == 0 && curPartidas.valueBuffer("haber") == 0) {
			curPartidas.setModeAccess(curPartidas.Del);
			curPartidas.refreshBuffer();
			if(!curPartidas.commitBuffer())
				return false;
		}
	}

	return true;
}

function oficial_mostrarConceptoAsiento()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var conceptoAsiento:String = cursor.valueBuffer("concepto");
	if (!conceptoAsiento || conceptoAsiento == "") {
		if (this.child("tdbPartidas").cursor().isValid()) {
			var concepto:String = this.child("tdbPartidas").cursor().valueBuffer("concepto");
			cursor.setValueBuffer("concepto", concepto);
		}
	}

	var idConceptoAsiento:String = cursor.valueBuffer("idconcepto");
	if (!idConceptoAsiento || idConceptoAsiento == "") {
		if (this.child("tdbPartidas").cursor().isValid()) {
			var idConcepto:String = this.child("tdbPartidas").cursor().valueBuffer("idconcepto");
			cursor.setValueBuffer("idconcepto", idConcepto);
		}
	}

	var docAsiento:String = cursor.valueBuffer("documento");
	if (!docAsiento || docAsiento == "") {
		if (this.child("tdbPartidas").cursor().isValid()) {
			var documento:String = this.child("tdbPartidas").cursor().valueBuffer("documento");
			cursor.setValueBuffer("documento", documento);
		}
	}

	var tipoDocAsiento:String = cursor.valueBuffer("tipodocumento");
	if (!tipoDocAsiento || tipoDocAsiento == "") {
		if (this.child("tdbPartidas").cursor().isValid()) {
			var tipoDocumento:String = this.child("tdbPartidas").cursor().valueBuffer("tipodocumento");
			cursor.setValueBuffer("tipodocumento", tipoDocumento);
		}
	}

	this.iface.calculaDescuadre();
}

function oficial_bufferChanged(fN:String)
{
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition modelos */
/////////////////////////////////////////////////////////////////
//// MODELOS FISCALES ///////////////////////////////////////////
function modelos_init()
{
	this.iface.__init();
	this.iface.habilitarPestanaModelos();
}

function modelos_habilitarPestanaModelos()
{
	this.child("tbwAsiento").setTabEnabled("modelos", false);
}
//// MODELOS FISCALES ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition modelo347 */
/////////////////////////////////////////////////////////////////
//// MODELO 347 /////////////////////////////////////////////////
function modelo347_init()
{
	this.iface.__init();
	this.iface.habilitar347();
}

function modelo347_habilitarPestanaModelos()
{
	return true;
}

function modelo347_bufferChanged(fN:String)
{
	switch (fN) {
		case "tipodocumento": {
			this.iface.habilitar347();
			this.iface.__bufferChanged(fN);
			break;
		}
		default: {
			this.iface.__bufferChanged(fN);
			break;
		}
	}
}

function modelo347_habilitar347()
{
	var cursor:FLSqlCursor = this.cursor();
	switch (cursor.valueBuffer("tipodocumento")) {
		case "Factura de cliente":
		case "Factura de proveedor": {
			this.child("fdbNoModelo347").setDisabled(false);
			break;
		}
		default: {
			this.child("fdbNoModelo347").setDisabled(true);
			break;
		}
	}
}
//// MODELO 347 /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////