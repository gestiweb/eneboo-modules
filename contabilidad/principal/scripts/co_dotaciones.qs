/***************************************************************************
                 co_amortizaciones.qs  -  description
                             -------------------
    begin                : vie dic 28 2007
    copyright            : (C) 2007 by InfoSiAL S.L.
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
	function calculateField( fN:String ):String {
		return this.ctx.interna_calculateField( fN );
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var bloqImporte:Boolean;
	var bloqPorcentaje:Boolean;
	function oficial( context ) { interna( context ); } 
	function bufferChanged(fN) {
		return this.ctx.oficial_bufferChanged(fN);
	}
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
function interna_init()
{
	var util:FLUtil = new FLUtil(); 
	var cursor:FLSqlCursor = this.cursor();

	if (cursor.modeAccess() == cursor.Insert) {
		this.child("fdbFechaInicio").setValue(this.iface.calculateField("fechainicio"));
		this.child("fdbFechaFin").setValue(this.iface.calculateField("fechafin"));
		this.child("fdbImporte").setValue(this.iface.calculateField("importeinicio"));
		this.cursor().setValueBuffer("acumulado",this.iface.calculateField("acumulado"));
		this.cursor().setValueBuffer("resto",this.iface.calculateField("resto"));
		this.cursor().setValueBuffer("porcentaje",this.iface.calculateField("porcentaje"));
	}

	this.iface.bloqImporte = false;
	this.iface.bloqPorcentaje = false

	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	
}

function interna_validateForm():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	if (cursor.valueBuffer("resto") < 0) {
		MessageBox.warning(util.translate("scripts", "El importe a amortizar no puede ser mayor que la cantidad pendiente de amortizar."), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var fechaInicio:Date = cursor.valueBuffer("fechainicio");
	var fechaFin:Date = cursor.valueBuffer("fechafin");
	var fecha:Date = cursor.valueBuffer("fecha");
	var ultimaFechaFin:Date = util.sqlSelect("co_dotaciones","MAX(fechafin)","codamortizacion = '" + this.cursor().valueBuffer("codamortizacion") + "' AND iddotacion <> " + cursor.valueBuffer("iddotacion"));
	if(!ultimaFechaFin)
	ultimaFechaFin = cursor.cursorRelation().valueBuffer("fecha");
	if (util.daysTo(ultimaFechaFin,fechaInicio) < 0 ) {
		MessageBox.warning(util.translate("scripts", "La fecha de inicio debe ser mayor que la fecha de adquisición y la fecha de fin de la última dotación"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	
	if (util.daysTo(fechaInicio,fechaFin) <= 0 ) {
		MessageBox.warning(util.translate("scripts", "La fecha de fin debe ser mayor que la fecha de inicio"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	if (util.daysTo(fechaInicio,fecha) < 0 || util.daysTo(fecha,fechaFin) < 0) {
		MessageBox.warning(util.translate("scripts", "La fecha del asiento debe estar comprendida en el intervalo de fechas de la dotación"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	return true;
}

function interna_calculateField(fN):String
{
	var util:FLUtil = new FLUtil;
	var res:Number;
	var cursor:FLSqlCursor = this.cursor();

	switch(fN) {
		case "X": {
			break;
		}
		default: {
			res = this.iface.commonCalculateField(fN, cursor);
		}
	}

	return res;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_bufferChanged(fN)
{
	var util:FLUtil = new FLUtil();

	switch(fN) {
		case "porcentaje": {
			if (!this.iface.bloqImporte) {
				this.iface.bloqImporte = true;
				this.cursor().setValueBuffer("importe",this.iface.calculateField("importe"));
				this.iface.bloqImporte = false;
			}
			break;
		}
		case "importe": {
			if (!this.iface.bloqImporte) {
				this.iface.bloqImporte = true;
				this.cursor().setValueBuffer("porcentaje", this.iface.calculateField("porcentaje"));
				this.iface.bloqImporte = false;
			}
			this.cursor().setValueBuffer("acumulado", this.iface.calculateField("acumulado"));
			break;
		}
		case "acumulado": {
			this.cursor().setValueBuffer("resto",this.iface.calculateField("resto"));
			break;
		}
	}
}

function oficial_commonCalculateField(fN:String, cursor:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil;
	var res:Number;

	switch(fN) {
		case "importe": {
			var valorAmortizable:Number;
			if (cursor.cursorRelation()) {
				valorAmortizable = parseFloat(cursor.cursorRelation().valueBuffer("valoramortizable"));
			} else {
				valorAmortizable = parseFloat(util.sqlSelect("co_amortizaciones", "valoramortizable", "codamortizacion = '" + cursor.valueBuffer("codamortizacion") + "'"));
			}
			res = (parseFloat(cursor.valueBuffer("porcentaje")) * valorAmortizable) / 100;
			break;
		}
		case "porcentaje": {
			var valorAmortizable:Number;
			if (cursor.cursorRelation()) {
				valorAmortizable = parseFloat(cursor.cursorRelation().valueBuffer("valoramortizable"));
			} else {
				valorAmortizable = parseFloat(util.sqlSelect("co_amortizaciones", "valoramortizable", "codamortizacion = '" + cursor.valueBuffer("codamortizacion") + "'"));
			}
			res = (parseFloat(cursor.valueBuffer("importe")) *100) / valorAmortizable;
			break;
		}
		case "acumulado": {
			res = parseFloat(util.sqlSelect("co_dotaciones","acumulado","codamortizacion = '" + cursor.valueBuffer("codamortizacion") + "' AND iddotacion <> " + cursor.valueBuffer("iddotacion") + " ORDER BY fechafin DESC"));
			if (!res) {
				if (cursor.cursorRelation()) {
					res = parseFloat(cursor.cursorRelation().valueBuffer("totalamortizado"));
				} else {
					res = parseFloat(util.sqlSelect("co_amortizaciones", "totalamortizado", "codamortizacion = '" + cursor.valueBuffer("codamortizacion") + "'"));
				}
			}
			if (!res || isNaN(res)) {
				res = 0;
			}
			res += parseFloat(cursor.valueBuffer("importe"));
			break;
		}
		case "resto": {
			var valorAmortizable:Number;
			if (cursor.cursorRelation()) {
				valorAmortizable = parseFloat(cursor.cursorRelation().valueBuffer("valoramortizable"));
			} else {
				valorAmortizable = parseFloat(util.sqlSelect("co_amortizaciones", "valoramortizable", "codamortizacion = '" + cursor.valueBuffer("codamortizacion") + "'"));
			}
			res = valorAmortizable - parseFloat(cursor.valueBuffer("acumulado"));
			break;
		}
		case "fechainicio": {
			var fechaInicio:Date = util.sqlSelect("co_dotaciones","fechafin","codamortizacion = '" + cursor.valueBuffer("codamortizacion") + "' AND iddotacion <> " + cursor.valueBuffer("iddotacion") + " ORDER BY fechafin DESC");
			if (!fechaInicio) {
				if (cursor.cursorRelation()) {
					fechaInicio = cursor.cursorRelation().valueBuffer("fecha");
				} else {
					fechaInicio = util.sqlSelect("co_amortizaciones", "fecha", "codamortizacion = '" + cursor.valueBuffer("codamortizacion") + "'");
				}
			} else {
				fechaInicio = util.addDays(fechaInicio, 1);
			}
			res = fechaInicio;
			break;
		}
		case "fechafin": {
			var periodo:String;
			if (cursor.cursorRelation()) {
				periodo = cursor.cursorRelation().valueBuffer("periodo");
			} else {
				periodo = util.sqlSelect("co_amortizaciones", "periodo", "codamortizacion = '" + cursor.valueBuffer("codamortizacion") + "'");
			}
			res = formRecordco_amortizaciones.iface.pub_calcularFechaFinPeriodo(cursor.valueBuffer("fechainicio"), periodo);
			break;
		}
		case "importeinicio": {
			var importe:Number;
			if (!util.sqlSelect("co_dotaciones","iddotacion","codamortizacion = '" + cursor.valueBuffer("codamortizacion") + "' AND iddotacion <> " + cursor.valueBuffer("iddotacion"))) {
				if (cursor.cursorRelation()) {
					importe = cursor.cursorRelation().valueBuffer("amorprimerperiodo");
				} else {
					importe = util.sqlSelect("co_amortizaciones", "amorprimerperiodo", "codamortizacion = '" + cursor.valueBuffer("codamortizacion") + "'");
				}
			} else {
				var pendiente:Number;
				if (cursor.cursorRelation()) {
					pendiente = parseFloat(cursor.cursorRelation().valueBuffer("pendiente"));
					importe = cursor.cursorRelation().valueBuffer("amorperiodo");
				} else {
					pendiente = util.sqlSelect("co_amortizaciones", "pendiente", "codamortizacion = '" + cursor.valueBuffer("codamortizacion") + "'");
					importe = util.sqlSelect("co_amortizaciones", "amorperiodo", "codamortizacion = '" + cursor.valueBuffer("codamortizacion") + "'");
				}
				if (parseFloat(pendiente) <= parseFloat(importe)) {
					importe = pendiente;
				}
			}
			res = importe;
			break;
		}
	}

	return res;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

