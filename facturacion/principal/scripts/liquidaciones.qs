/***************************************************************************
                              liquidaciones.qs
                             -------------------
    begin                : jue sep 29 2005
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
	function calculateField( fN:String ):String { return this.ctx.interna_calculateField(fN); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var codLiquidacion:Object;
	function oficial( context ) { 
		interna( context );
	}
	function agregarFactura():Boolean { 
		return this.ctx.oficial_agregarFactura(); 
	}
	function eliminarFactura():Boolean { 
		return this.ctx.oficial_eliminarFactura();
	}
	function eliminarFacturas():Boolean { 
		return this.ctx.oficial_eliminarFacturas();
	}
	function asociarFacturas():Boolean {
		return this.ctx.oficial_asociarFacturas();
	}
	function desasociarFactura(idFactura:String):Boolean {
		return this.ctx.oficial_desasociarFactura(idFactura);
	}
	function cambiarPorcentaje() {
		return this.ctx.oficial_cambiarPorcentaje();
	}
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.oficial_commonCalculateField(fN, cursor);
	}
	function establecerFechasPeriodo() {
		return this.ctx.oficial_establecerFechasPeriodo();
	}
	function habilitarPeriodo() {
		return this.ctx.oficial_habilitarPeriodo();
	}
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
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

/** @class_declaration puboficial */
//////////////////////////////////////////////////////////////////
//// oficial //////////////////////////////////////////////////
class puboficial extends ifaceCtx {
	function puboficial( context ) { ifaceCtx( context ); }
	function pub_commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.commonCalculateField(fN, cursor);
	}
}
const iface = new puboficial( this );
//// oficial ///////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition interna */
////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
function interna_init()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	
	connect( cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect( this.child( "tbInsert" ), "clicked()", this, "iface.agregarFactura");
	connect( this.child( "tbDelete" ), "clicked()", this, "iface.eliminarFactura");
	connect( this.child( "pbAsociar" ), "clicked()", this, "iface.asociarFacturas");
	connect( this.child( "tbPorcentaje" ), "clicked()", this, "iface.cambiarPorcentaje");

/** \C La tabla de facturas se muestra en modo de sólo lectura
\end */
	this.child( "tdbFacturas" ).setReadOnly( true );

	if ( cursor.modeAccess() == cursor.Edit )
		this.child( "fdbAgente" ).setDisabled( true );
	this.iface.codLiquidacion = this.cursor().valueBuffer("codliquidacion");
	this.child("fdbFactura").setDisabled(true);
	
	this.iface.habilitarPeriodo();
// 	var fechaActual:Date = new Date();
// 	this.child("dateDesde").setDate(fechaActual);
// 	this.child("dateHasta").setDate(fechaActual);
}

/** \C El total de la liquidación será la suma de las comisiones de las facturas que la componen
\end */
function interna_calculateField(fN:String):String
{
	var util:FLUtil = new FLUtil();
	var cursor = this.cursor();
	var res:String;
	switch (fN) {
		case "total": {
			res = this.iface.commonCalculateField("total", cursor);
			break;
		}
	}
	return res;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Se agrega una factura a la liquidación.
\end */
function oficial_agregarFactura():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	if (cursor.modeAccess() == cursor.Insert) {
		var curFacturas:FLSqlCursor = this.child("tdbFacturas").cursor();
		if (!curFacturas.commitBufferCursorRelation()) {
			return false;
		}
		/// Para poder quitar facturas con el botón correspondiente
		curFacturas.setModeAccess(curFacturas.Browse);
		curFacturas.refreshBuffer();
	}

	this.child( "fdbAgente" ).setDisabled( true );

	var facturas:Object = new FLFormSearchDB( "busfactliq" );
	facturas.setMainWidget();

	var filtro:String = flfactppal.iface.pub_obtenFiltroFacturas(cursor.valueBuffer("codagente"), cursor.valueBuffer("fechadesde"), cursor.valueBuffer("fechahasta"), cursor.valueBuffer("codejercicio"));

	facturas.cursor().setMainFilter( filtro );
	var idFactura:String = facturas.exec( "idfactura" );

	if ( idFactura ) {
		if (!flfactppal.iface.pub_asociarFacturaLiq(idFactura, this.iface.codLiquidacion))
			return false;
		
		this.child( "tdbFacturas" ).refresh();
		this.child("fdbTotal").setValue(this.iface.calculateField("total"));
	}

	return true;
}

/** \D Se elimina la factura activo de la liquidación
\end */
function oficial_eliminarFactura()
{
	var tdbFacturas:FLTableDB = this.child( "tdbFacturas" );
	var curF:FLSqlCursor = tdbFacturas.cursor();
	var idFactura:String = curF.valueBuffer("idfactura");
debug("idFactura = " + idFactura);

	if (!this.iface.desasociarFactura(idFactura)) {
		return false;
	}

	tdbFacturas.refresh();
	this.child("fdbTotal").setValue(this.iface.calculateField("total"));
}

/** \D Se elimina las facturas asociadas actualmente a la liquidación
\end */
function oficial_eliminarFacturas():Boolean
{
	var tdbFacturas:Object = this.child( "tdbFacturas" );
	var idFactura:String;

	var qryFacturas:FLSqlQuery = new FLSqlQuery();
	qryFacturas.setTablesList("facturascli");
	qryFacturas.setSelect("idfactura");
	qryFacturas.setFrom("facturascli");
	qryFacturas.setWhere("codliquidacion = '" + this.cursor().valueBuffer("codliquidacion") + "'");
	
	if (!qryFacturas.exec())
		return false;

	while (qryFacturas.next()) {
		if (!this.iface.desasociarFactura(qryFacturas.value("idfactura"))) {
			return false;
		}
	}

	tdbFacturas.refresh();
	this.child("fdbTotal").setValue(this.iface.calculateField("total"));
	return true;
}


/** \D Se quita la asociación de la factura y la liquidación
@param idFactura: Identificador de la factura a desasociar
@return	true si la asociación se quita correctamente, false en caso contrario
\end */
function oficial_desasociarFactura(idFactura:String):Boolean
{
debug("oficial_desasociarFactura " + idFactura);
	var editable:Boolean = true;
	var curFactura:FLSqlCursor = new FLSqlCursor("facturascli");
	curFactura.select("idfactura = " + idFactura);
	if (!curFactura.first()) {
debug(1);
		return false;
	}
	curFactura.setModeAccess(curFactura.Browse);
	curFactura.refreshBuffer();
	
	curFactura.setActivatedCommitActions(false);
	if (!curFactura.valueBuffer("editable")) {
		editable = false;
		curFactura.setUnLock("editable", true);
		curFactura.select("idfactura = " + idFactura);
		if (!curFactura.first()) {
debug(2);
			return false;
		}
	}
	
	curFactura.setModeAccess(curFactura.Edit);
	curFactura.refreshBuffer();
	curFactura.setNull( "codliquidacion" );
	if (!curFactura.commitBuffer())
		return false;
	
	if (editable == false) {
		curFactura.select("idfactura = " + idFactura);
		if (!curFactura.first()) {
debug(3);
			return false;
		}
		curFactura.setUnLock("editable", false);
	}
debug("oficial_desasociarFactura OK");
	return true;
}

/** \D Asocia automáticamente a la liquidación todas la facturas pendientes de liquidar
con el agente actual
\end */
function oficial_asociarFacturas()
{
	var util:FLUtil = new FLUtil();
	var cursor = this.cursor();
	var curFacturas = this.child("tdbFacturas").cursor();
	if (cursor.modeAccess() == cursor.Insert) {
		curFacturas.setModeAccess(curFacturas.Insert);
		if (!curFacturas.commitBufferCursorRelation()) {
			return false;
		}
		/// Para poder quitar facturas con el botón correspondiente
		curFacturas.setModeAccess(curFacturas.Browse);
		curFacturas.refreshBuffer();
	}
	
	if (curFacturas.size() > 0) {
		if (!this.iface.eliminarFacturas(cursor.valueBuffer("codliquidacion"))) {
			return false;
		}
	}
	
	this.child( "fdbAgente" ).setDisabled( true );

	var filtro:String = flfactppal.iface.pub_obtenFiltroFacturas(cursor.valueBuffer("codagente"), cursor.valueBuffer("fechadesde"), cursor.valueBuffer("fechahasta"), cursor.valueBuffer("codejercicio"));

	if (!flfactppal.iface.pub_asociarFacturasLiq(filtro, this.iface.codLiquidacion)) {
		return false;
	}

	this.child( "tdbFacturas" ).refresh();
	this.child("fdbTotal").setValue(this.iface.calculateField("total"));

	return true;
}

function oficial_cambiarPorcentaje()
{
	var util:FLUtil = new FLUtil();
	var idFactura:Number = this.child("tdbFacturas").cursor().valueBuffer("idfactura");
	
	if(!idFactura)
		return;
	
	var dialog = new Dialog(util.translate ( "scripts", "Porcentaje de Comisión" ), 0);
	dialog.OKButtonText = util.translate ( "scripts", "Aceptar" );
	dialog.cancelButtonText = util.translate ( "scripts", "Cancelar" );
	
	var comision:NumberEdit = new NumberEdit;
	comision.label = util.translate ( "scripts", "% Comisión:" );
	comision.decimals = 2;
	comision.maximum = 100;
	comision.minimum = 0;
	dialog.add( comision );
	
	if(!dialog.exec())
		return;
	
	if(!comision.value)
		return;
		
	var curFactura:FLSqlCursor = new FLSqlCursor("facturascli");
	curFactura.select("idfactura = " + idFactura);
	if(!curFactura.first())
		return;
	
	var editable:Boolean = true;
	
	if(!curFactura.valueBuffer("editable")) {
		editable = false;
		curFactura.setUnLock("editable", true);
		curFactura.select("idfactura = " + idFactura);
		if(!curFactura.first())
			return;
	}

	curFactura.setModeAccess(curFactura.Edit);
	curFactura.refreshBuffer();
	if(curFactura.valueBuffer("porcomision")) {
		curFactura.setValueBuffer("porcomision",comision.value);

		if(!curFactura.commitBuffer())
			return;
	}
	else {
	if(!util.sqlUpdate("lineasfacturascli","porcomision",comision.value,"idfactura = " + idFactura))
		return false;
	}

	if(!editable){
		delete curFactura;
		curFactura = new FLSqlCursor("facturascli");
		curFactura.select("idfactura = " + idFactura);
		if(!curFactura.first())
			return;
		curFactura.setUnLock("editable", false);
	}
		
	this.child("tdbFacturas").refresh();
	var totalLiq:Number = this.iface.calculateField("total");
	this.child("fdbTotal").setValue(totalLiq);
}

function oficial_commonCalculateField(fN:String, cursor:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil();
	var res:String;
	
	switch (fN) {
		case "total": {
			res = flfactppal.iface.pub_calcularLiquidacionAgente("facturascli.codliquidacion = '" + this.iface.codLiquidacion + "'");
			break;
		}
		default: {
			res = this.iface.__commonCalculateField(fN, cursor);
			break;
		}
	}
	return res;
}

function oficial_bufferChanged(fN:String)
{
debug("oficial_bufferChanged * " + fN);
	switch (fN) {
		case "codejercicio":
		case "tipoperiodo": {
			this.iface.habilitarPeriodo();
			this.iface.establecerFechasPeriodo();
			break;
		}
		case "mes":
		case "trimestre": {
			this.iface.establecerFechasPeriodo();
			break;
		}
	}
}

/** \D Habilita los controles de perído y tipo de período si hay un ejercicio especificado, y muestra el tipo de período (mes, trimestre o año) indicado por el usuario
\*/
function oficial_habilitarPeriodo()
{
	var cursor:FLSqlCursor = this.cursor();

	var codEjercicio:String = cursor.valueBuffer("codejercicio");
	if (codEjercicio && codEjercicio != "") {
		this.child("fdbMes").setDisabled(false);
		this.child("fdbTrimestre").setDisabled(false);
		this.child("fdbTipoPeriodo").setShowAlias(true);
		this.child("fdbTipoPeriodo").setShowEditor(true);
		switch (cursor.valueBuffer("tipoperiodo")) {
			case "Mes": {
				this.child("fdbMes").setShowAlias(true);
				this.child("fdbMes").setShowEditor(true);
				this.child("fdbTrimestre").setShowAlias(false);
				this.child("fdbTrimestre").setShowEditor(false);
				break;
			}
			case "Trimestre": {
				this.child("fdbTrimestre").setShowAlias(true);
				this.child("fdbTrimestre").setShowEditor(true);
				this.child("fdbMes").setShowAlias(false);
				this.child("fdbMes").setShowEditor(false);
				break;
			}
			default: {
				this.child("fdbTrimestre").setShowAlias(false);
				this.child("fdbTrimestre").setShowEditor(false);
				this.child("fdbMes").setShowAlias(false);
				this.child("fdbMes").setShowEditor(false);
			}
		}
	} else {
		this.child("fdbMes").setDisabled(true);
		this.child("fdbTrimestre").setDisabled(true);
		this.child("fdbTipoPeriodo").setShowAlias(false);
		this.child("fdbTipoPeriodo").setShowEditor(false);
		this.child("fdbTrimestre").setShowAlias(false);
		this.child("fdbTrimestre").setShowEditor(false);
		this.child("fdbMes").setShowAlias(false);
		this.child("fdbMes").setShowEditor(false);
	}
}


/** \D Establece las fechas de inicio y fin del período de liquidación
\end */
function oficial_establecerFechasPeriodo()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var fechaInicio:Date;
	var fechaFin:Date;
	var codEjercicio:String = cursor.valueBuffer("codejercicio");
	if (!codEjercicio || codEjercicio == "") {
		return false;
	}

	var inicioEjercicio = util.sqlSelect("ejercicios", "fechainicio", "codejercicio = '" + codEjercicio + "'");
	if (!inicioEjercicio) {
		return false;
	}
	
	fechaInicio.setYear(inicioEjercicio.getYear());
	fechaFin.setYear(inicioEjercicio.getYear());
	fechaInicio.setDate(1);

	switch (cursor.valueBuffer("tipoperiodo")) {
		case "Trimestre": {
			switch (cursor.valueBuffer("trimestre")) {
				case "1T": {
					fechaInicio.setMonth(1);
					fechaFin.setMonth(3);
					fechaFin.setDate(31);
					break;
				}
				case "2T": {
					fechaInicio.setMonth(4);
					fechaFin.setMonth(6);
					fechaFin.setDate(30);
					break;
				}
				case "3T":
					fechaInicio.setMonth(7);
					fechaFin.setMonth(9);
					fechaFin.setDate(30);
					break;
				case "4T": {
					fechaInicio.setMonth(10);
					fechaFin.setMonth(12);
					fechaFin.setDate(31);
					break;
				}
				default: {
					fechaInicio = false;
				}
			}
			break;
		}
		case "Mes": {
			var numMes:Number = parseInt(cursor.valueBuffer("mes"));
			fechaInicio.setDate(1);
			fechaInicio.setMonth(numMes);
			fechaFin = util.addMonths(fechaInicio, 1);
			fechaFin = util.addDays(fechaFin, -1);
			break;
		}
		default: {
			fechaInicio.setDate(1);
			fechaInicio.setMonth(1);
			fechaFin = util.addYears(fechaInicio, 1);
			fechaFin = util.addDays(fechaFin, -1);
			break;
		}
	}

	if (fechaInicio) {
		this.child("fdbFechaDesde").setValue(fechaInicio);
		this.child("fdbFechaHasta").setValue(fechaFin);
	}
}
//// OFICIAL ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
