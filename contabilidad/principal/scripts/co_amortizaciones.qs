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
	var longSubcuenta:Number;
	var ejercicioActual:String;
	var bloqueoSubcuentaElem:Boolean;
	var bloqueoSubcuentaAmor:Boolean;
	var posActualPuntoSubcuentaElem:Number;
	var posActualPuntoSubcuentaAmor:Number;
	var bloqueoNumPeriodos:Boolean;
	var bloqueoVPeriodo:Boolean;
	
	function oficial( context ) { interna( context ); } 
	function bufferChanged(fN) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function calcularTotales() {
		return this.ctx.oficial_calcularTotales();
	}
	function calcularFechaFinPeriodo(fecha:Date,tipoPeriodo:String):Date {
		return this.ctx.oficial_calcularFechaFinPeriodo(fecha,tipoPeriodo);
	}
	function calcularDiasPeriodo(fecha:Date,tipoPeriodo:String):Number {
		return this.ctx.oficial_calcularDiasPeriodo(fecha,tipoPeriodo);
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
	function pub_calcularFechaFinPeriodo(fecha:Date,tipoPeriodo:String):Date {
		return this.calcularFechaFinPeriodo(fecha,tipoPeriodo);
	}
	function pub_calcularDiasPeriodo(fecha:Date,tipoPeriodo:String):Number {
		return this.calcularDiasPeriodo(fecha,tipoPeriodo);
	}
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

	this.iface.ejercicioActual = flfactppal.iface.pub_ejercicioActual();

	this.iface.longSubcuenta = util.sqlSelect("ejercicios", "longsubcuenta", "codejercicio = '" + this.iface.ejercicioActual + "'");
	this.iface.bloqueoSubcuentaAmor = false;
	this.iface.posActualPuntoSubcuentaAmor = -1;
	this.iface.bloqueoSubcuentaElem = false;
	this.iface.posActualPuntoSubcuentaElem = -1;

	this.iface.bloqueoNumPeriodos = false;
	this.iface.bloqueoVPeriodo = false;
	
	if(cursor.modeAccess() == cursor.Insert) {
		this.child("fdbIdSubcuentaElem").setFilter("codejercicio = '" + this.iface.ejercicioActual + "'");
		this.child("fdbDesSubcuentaElem").setValue("");
		this.child("fdbIdSubcuentaAmor").setFilter("codejercicio = '" + this.iface.ejercicioActual + "'");
		this.child("fdbDesSubcuentaAmor").setValue("");
	}
	else {
		if(this.cursor().valueBuffer("pendiente") == 0) {
// 			this.child("tdbDotaciones").setReadOnly(true);
			this.child("toolButtonInsert").setDisabled(true);
			this.child("fdbEstado").setDisabled(true);
		}
		if(util.sqlSelect("co_dotaciones","iddotacion","codamortizacion = '" + this.cursor().valueBuffer("codamortizacion") + "'")) {
			this.child("fdbFecha").setDisabled(true);
			this.child("fdbValorAdq").setDisabled(true);
			this.child("fdbValorResidual").setDisabled(true);
			this.child("fdbCodSubcuentaElem").setDisabled(true);
			this.child("fdbIdSubcuentaElem").setDisabled(true);
			this.child("fdbCodSubcuentaAmor").setDisabled(true);
			this.child("fdbIdSubcuentaAmor").setDisabled(true);
			this.child("fdbAmorAnual").setDisabled(true);
			this.child("fdbNumAnos").setDisabled(true);
			this.child("fdbAmorPrimerAno").setDisabled(true);
			this.child("fdbAmorUltimoAno").setDisabled(true);
			this.child("fdbPeriodo").setDisabled(true);
		}
	}
	
	connect(this.child("tdbDotaciones").cursor(), "bufferCommited()", this, "iface.calcularTotales()");
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
}

/** \C La subcuenta establecida debe existir en la tabla de subcuentas
\end */
function interna_validateForm():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var codEjercicio:String = this.iface.ejercicioActual;
	if (!util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + cursor.valueBuffer("codsubcuentaelem") + "' AND codejercicio = '" + codEjercicio + "'")) {
		this.child("fdbCodSubcuentaElem").setDisabled(false);
		this.child("fdbIdSubcuentaElem").setDisabled(false);
		MessageBox.warning(util.translate("scripts", "No existe la subcuenta %1 para el ejercicio %2").arg(cursor.valueBuffer("codsubcuentaelem")).arg(codEjercicio), MessageBox.Ok, MessageBox.NoButton);
  	return false;
	}

	if (!util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + cursor.valueBuffer("codsubcuentaamor") + "' AND codejercicio = '" + codEjercicio + "'")) {
		this.child("fdbCodSubcuentaAmor").setDisabled(false);
		this.child("fdbIdSubcuentaAmor").setDisabled(false);
		MessageBox.warning(util.translate("scripts", "No existe la subcuenta %1 para el ejercicio %2").arg(cursor.valueBuffer("codsubcuentaamor")).arg(codEjercicio), MessageBox.Ok, MessageBox.NoButton);
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
		case "valoramortizable":{
			var vAdquisicion:Number = parseFloat(cursor.valueBuffer("valoradquisicion"));
			if (!vAdquisicion)
				vAdquisicion = 0;
			var vResidual:Number = parseFloat(cursor.valueBuffer("valorresidual"));
			if (!vResidual)
				vResidual = 0;
			res = vAdquisicion - vResidual;
			break;
		}
		case "porcentajeperiodo":{
			var metodo:String = cursor.valueBuffer("metodo");
			if(metodo == "Lineal") {
				var amorPeriodo:Number = parseFloat(cursor.valueBuffer("amorperiodo"));
				if (!amorPeriodo)
					amorPeriodo = 0;
				var vAmortizable:Number = parseFloat(cursor.valueBuffer("valoramortizable"));
				if (vAmortizable && vAmortizable != 0)
					res = (amorPeriodo / vAmortizable) * 100;
			}
			break;
		}
		case "numperiodos":{
			var metodo:String = cursor.valueBuffer("metodo");
			if(metodo == "Lineal") {
				var vAmortizable:Number = parseFloat(cursor.valueBuffer("valoramortizable"));
				if (!vAmortizable)
					vAmortizable = 0;
				var amorPeriodo:Number = parseFloat(cursor.valueBuffer("amorperiodo"));
				if (amorPeriodo && amorPeriodo != 0)
					res = vAmortizable / amorPeriodo;
			}
			break;
		}
		case "amorperiodo": {
			var vAmortizable:Number = parseFloat(cursor.valueBuffer("valoramortizable"));
			if (!vAmortizable)
				vAmortizable = 0;
			var numPeriodos:Number = parseFloat(cursor.valueBuffer("numperiodos"));
			if (numPeriodos && numPeriodos != 0)
				res = vAmortizable / numPeriodos;
			break;
		}
		case "amorprimerperiodo": {
			var metodo:String = cursor.valueBuffer("metodo");
			if(metodo == "Lineal") {
				var amorPeriodo:Number = parseFloat(cursor.valueBuffer("amorperiodo"));
				if (!amorPeriodo)
					amorPeriodo = 0;
				var fechaAdquisicion:Date = cursor.valueBuffer("fecha");
				var tipoPeriodo:String = cursor.valueBuffer("periodo");

				var periodo:Number = fechaAdquisicion.getYear();
				var fechaFinPeriodo:Date = this.iface.calcularFechaFinPeriodo(fechaAdquisicion,tipoPeriodo);

				var dias:Number = parseFloat(util.daysTo(fechaAdquisicion,fechaFinPeriodo));
				var diasPeriodo:Number = this.iface.calcularDiasPeriodo(fechaAdquisicion,tipoPeriodo);

				res = amorPeriodo * dias / diasPeriodo;
			}
			break;
		}
		case "amorultimoperiodo": {
			var metodo:String = cursor.valueBuffer("metodo");
			if(metodo == "Lineal") {
				var vAmortizable:Number = parseFloat(cursor.valueBuffer("valoramortizable"));
				if (!vAmortizable)
					vAmortizable = 0;
				var amorPeriodo:Number = parseFloat(cursor.valueBuffer("amorperiodo"));
				if (!amorPeriodo)
					amorPeriodo = 0;
				var numPeriodos:Number = parseFloat(cursor.valueBuffer("numperiodos"));
				if (!numPeriodos)
					numPeriodos = 0;
				var amorPrimerPeriodo:Number = parseFloat(cursor.valueBuffer("amorprimerperiodo"));
				if (!amorPrimerPeriodo)
					amorPrimerPeriodo = 0;
				res = vAmortizable - (amorPeriodo * (numPeriodos - 1)) - amorPrimerPeriodo;
				if(res < 0)
					res = 0;
			}
			break;
		}			
		case "totalamortizado":
		case "pendiente":
		case "estado": {
			res = this.iface.commonCalculateField(fN, cursor);
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
function oficial_bufferChanged(fN)
{
	var util:FLUtil = new FLUtil();

	switch(fN) {
		case "codsubcuentaelem":
		/** 
		\D
		Cuando alcanza el número de dígitos de la subcuenta, busca los datos asociados.
		\end 
		\C
		Al introducir --codsubcuenta--, si el usuario pulsa la tecla "punto" (.), la subcuenta se informa automaticamente con el código de cuenta más tantos ceros como sea necesario para completar la longitud de subcuenta asociada al ejercicio actual.
		\end 
		*/
			if (!this.iface.bloqueoSubcuentaElem) {
				this.iface.bloqueoSubcuentaElem = true;
				this.iface.posActualPuntoSubcuentaElem = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuentaElem", this.iface.longSubcuenta, this.iface.posActualPuntoSubcuentaElem);
				this.iface.bloqueoSubcuentaElem = false;
			}
			break;
		case "codsubcuentaamor":
			if (!this.iface.bloqueoSubcuentaAmor) {
				this.iface.bloqueoSubcuentaAmor = true;
				this.iface.posActualPuntoSubcuentaAmor = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuentaAmor", this.iface.longSubcuenta, this.iface.posActualPuntoSubcuentaAmor);
				this.iface.bloqueoSubcuentaAmor = false;
			}
			break;

		case "valoradquisicion":
		case "valorresidual": {
				this.cursor().setValueBuffer("valoramortizable",this.iface.calculateField("valoramortizable"));
			}
			break;
		case "valoramortizable": {
				this.cursor().setValueBuffer("amorperiodo",this.iface.calculateField("amorperiodo"));
				this.cursor().setValueBuffer("pendiente",this.iface.calculateField("pendiente"));
			}
		case "amorperiodo" : {
				this.iface.bloqueoVPeriodo = true;
				if(!this.iface.bloqueoNumPeriodos)
					this.cursor().setValueBuffer("numperiodos",this.iface.calculateField("numperiodos"));
				else
					this.iface.bloqueoNumPeriodos = false;
				this.iface.bloqueoVPeriodo = false;
				this.cursor().setValueBuffer("amorprimerperiodo",this.iface.calculateField("amorprimerperiodo"));
				this.cursor().setValueBuffer("porcentajeperiodo",this.iface.calculateField("porcentajeperiodo"));
			}
		case "amorprimerperiodo": {
				this.cursor().setValueBuffer("amorultimoperiodo",this.iface.calculateField("amorultimoperiodo"));
				this.cursor().setValueBuffer("totalamortizado",this.iface.calculateField("totalamortizado"));
			}
			break;
		case "numperiodos": {
				this.iface.bloqueoNumPeriodos = true;
				if(!this.iface.bloqueoVPeriodo)
					this.cursor().setValueBuffer("amorperiodo",this.iface.calculateField("amorperiodo"));
				else
					this.iface.bloqueoVPeriodo = false;
				this.iface.bloqueoNumPeriodos = false;
				this.cursor().setValueBuffer("amorultimoperiodo",this.iface.calculateField("amorultimoperiodo"));
			}
			break;
		case "periodo":
		case "fecha": {
				this.cursor().setValueBuffer("amorprimerperiodo",this.iface.calculateField("amorprimerperiodo"));
			}
			break;
		case "pendiente": {
				if(this.cursor().valueBuffer("pendiente") == 0) {
					this.child("toolButtonInsert").setDisabled(true);
					this.cursor().setValueBuffer("estado","Terminada");
					this.child("fdbEstado").setDisabled(true);
				}	
				if(this.cursor().valueBuffer("pendiente") > 0) {
					this.child("toolButtonInsert").setDisabled(false);
					this.cursor().setValueBuffer("estado","En Curso");
					this.child("fdbEstado").setDisabled(false);
				}
			}
			break;
	}
}
function oficial_calcularTotales()
{
	var util:FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	this.cursor().setValueBuffer("totalamortizado", this.iface.calculateField("totalamortizado"));
	this.cursor().setValueBuffer("pendiente", this.iface.calculateField("pendiente"));
	this.cursor().setValueBuffer("estado", this.iface.calculateField("estado"));

	if(util.sqlSelect("co_dotaciones","iddotacion","codamortizacion = '" + this.cursor().valueBuffer("codamortizacion") + "'")) {
		this.child("fdbFecha").setDisabled(true);
		this.child("fdbValorAdq").setDisabled(true);
		this.child("fdbValorResidual").setDisabled(true);
		this.child("fdbCodSubcuentaElem").setDisabled(true);
		this.child("fdbIdSubcuentaElem").setDisabled(true);
		this.child("fdbCodSubcuentaAmor").setDisabled(true);
		this.child("fdbIdSubcuentaAmor").setDisabled(true);
		this.child("fdbAmorAnual").setDisabled(true);
		this.child("fdbNumAnos").setDisabled(true);
		this.child("fdbAmorPrimerAno").setDisabled(true);
		this.child("fdbAmorUltimoAno").setDisabled(true);
		this.child("fdbPeriodo").setDisabled(true);
	}
	else {
		this.child("fdbFecha").setDisabled(false);
		this.child("fdbValorAdq").setDisabled(false);
		this.child("fdbValorResidual").setDisabled(false);
		this.child("fdbCodSubcuentaElem").setDisabled(false);
		this.child("fdbIdSubcuentaElem").setDisabled(false);
		this.child("fdbCodSubcuentaAmor").setDisabled(false);
		this.child("fdbIdSubcuentaAmor").setDisabled(false);
		this.child("fdbAmorAnual").setDisabled(false);
		this.child("fdbNumAnos").setDisabled(false);
		this.child("fdbAmorPrimerAno").setDisabled(false);
		this.child("fdbAmorUltimoAno").setDisabled(false);
		this.child("fdbPeriodo").setDisabled(false);
	}
}

function oficial_calcularFechaFinPeriodo(fecha:Date,tipoPeriodo:String):Date
{
	var dia:Number = fecha.getDate();
	var mes:Number = fecha.getMonth();
	var ano:Number = fecha.getYear();
	var res:Number = ano / 4;
	if (res == 502)
		res = 1
	else
		res = 0;
	
	switch (tipoPeriodo) {
		case "Mensual": {
			switch (mes) {
				case 2:
					dia = (28 + res);
					break;
				case 1:
				case 3:
				case 5:
				case 7:
				case 8:
				case 10:
				case 12:
					dia = 31;
					break;
				case 4:
				case 6:
				case 9:
				case 11:
					dia = 30;
					break;
			}
		}
		break;
		case "Trimestral": {
			if(mes <= 3) {
				dia = 31;
				mes = 3;
				break;
			}
			if (mes <= 6) {
				dia = 30;
				mes = 6
				break;
			}
			if (mes <= 9){
				dia = 30;
				mes = 9
				break;
			}
			if (mes <= 12) {
				dia = 31;
				mes = 12;
				break;
			}
		}
		break;
		case "Semestral": {
			if(mes <= 6) {
				dia = 30;
				mes = 6;
				break;
			}
			if (mes <= 13) {
				dia = 31;
				mes = 12;
				break;
			}
		}
		break;
		case "Anual": {
			dia = 31;
			mes = 12;
		}
		break;
	}

	var fechaFin:Date = new Date(ano,mes,dia);
	return fechaFin;
}

function oficial_calcularDiasPeriodo(fecha:Date,tipoPeriodo:String):Number
{
	var mes:Number = fecha.getMonth();
	var ano:Number = fecha.getYear();
	var res:Number = ano / 4;
	if (res == 502)
		res = 1
	else
		res = 0;

	switch (tipoPeriodo) {
		case "Mensual": {
			
			switch (mes) {
				case 2:
					return (28 + res);
				case 1:
				case 3:
				case 5:
				case 7:
				case 8:
				case 10:
				case 12:
					return 31;
				case 4:
				case 6:
				case 9:
				case 11:
					return 30;
			}
		}
		break;
		case "Trimestral": {
			if(mes <= 3)
				return (90 + res);
			if (mes <= 6)
				return 91;
			if (mes <= 12)
				return 92;
		}
		break;
		case "Semestral": {
			if (mes <= 6)
				return (181 + res);
			else
				return 184;
		}
		break;
		case "Anual": {
			return (365 + res);
		}
		break;
	}
}

function oficial_commonCalculateField(fN:String, cursor:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil;
	var res:Number;
	
	switch(fN) {
		case "totalamortizado": {
			res = parseFloat(util.sqlSelect("co_dotaciones","SUM(importe)","codamortizacion = '" + cursor.valueBuffer("codamortizacion") + "'"));
			if (!res) {
				res = 0;
			}
			break;
		}
		case "pendiente": {
			var vAmortizable:Number = parseFloat(cursor.valueBuffer("valoramortizable"));
			if (!vAmortizable) {
				vAmortizable = 0;
			}
			var totalAmortizado:Number = parseFloat(cursor.valueBuffer("totalamortizado"));
			if (!totalAmortizado) {
				totalAmortizado = 0;
			}
			res = vAmortizable - totalAmortizado;
			break;
		}
		case "estado": {
			var pendiente:Number = parseFloat(cursor.valueBuffer("pendiente"));
			if (!pendiente) {
				pendiente = 0;
			}
			if (pendiente == 0) {
				res = "Terminada";
			} else {
				if (cursor.valueBuffer("estado") == "Terminada") {
					res = "En Curso";
				} else {
					res = cursor.valueBuffer("estado");
				}
			}
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

