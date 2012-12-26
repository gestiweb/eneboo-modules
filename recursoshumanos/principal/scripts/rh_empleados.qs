/***************************************************************************
                 rh_empleados.qs  -  description
                             -------------------
    begin                : mar jul 2 200
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
	function calculateCounter():String { 
		return this.ctx.interna_calculateCounter(); 
	}
	function calculateField(fN:String):String { 
		return this.ctx.interna_calculateField(fN); 
	}
	function validateForm():String { 
		return this.ctx.interna_validateForm();
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var bloqueoSubcuenta:Boolean;
	var longSubcuenta:Number;
	var posActualPuntoSubcuenta:Number;
	var ejercicioActual:String;
	function oficial( context ) { interna( context ); } 
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function calcularSaldoVacaciones() {
		return this.ctx.oficial_calcularSaldoVacaciones();
	}
	function calcularEdad() {
		return this.ctx.oficial_calcularEdad();
	}
	function insertarHistorico() {
		return this.ctx.oficial_insertarHistorico();
	}
	function cambiarBloqueo() {
		return this.ctx.oficial_cambiarBloqueo();
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
function interna_init()
{
	var util:FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this.child("tdbVacaciones").cursor(), "bufferCommited()", this, "iface.calcularSaldoVacaciones");
	connect(this.child("tbnInsertarHistorico"), "clicked()", this, "iface.insertarHistorico()");
	connect(this.child("pbnBloqueo"), "clicked()", this, "iface.cambiarBloqueo()");
	this.iface.ejercicioActual = flfactppal.iface.pub_ejercicioActual();
	this.iface.longSubcuenta = util.sqlSelect("ejercicios", "longsubcuenta", "codejercicio = '" + this.iface.ejercicioActual + "'");
	this.iface.bloqueoSubcuenta = false;
	this.iface.posActualPuntoSubcuenta = -1;
	this.child("fdbIdSubcuenta").setFilter("codejercicio = '" + this.iface.ejercicioActual + "'");
	if (cursor.modeAccess() != cursor.Insert) {
		this.child("pbnBloqueo").setOn(true);
		this.child("fdbSueldoBruto").setDisabled(true);
		this.child("fdbIrpf").setDisabled(true);
		this.child("fdbSegSocial").setDisabled(true);
		this.child("fdbFechaDesde").setDisabled(true);
		
	}
	this.iface.bufferChanged("all");
	this.iface.calcularEdad();
}

function interna_calculateCounter()
{
	var util:FLUtil = new FLUtil();
	return util.nextCounter("codempleado", this.cursor());
}

function interna_calculateField(fN:String):String
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var res:Number;
	
	switch (fN) {
		case "sueldoneto": {
			res = parseFloat(cursor.valueBuffer("sueldobruto") - cursor.valueBuffer("irpf") - cursor.valueBuffer("segsocial"));
			break;
		}
		case "saldovacaciones": {
			res = util.sqlSelect("rh_vacaciones","SUM(dias)","codempleado = '" + cursor.valueBuffer("codempleado") + "'");
			if (!res || isNaN(res))
				res = 0;
			break;
		}
	}
	return res;
}

/** \C La subcuenta establecida debe existir en la tabla de subcuentas
\end */
function interna_validateForm():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var codSubcuenta:String = cursor.valueBuffer("codSubcuenta");
	var idSubcuenta:Number = parseFloat(cursor.valueBuffer("idsubcuenta"));

	if (codSubcuenta != util.sqlSelect("co_subcuentas","codsubcuenta","idsubcuenta = " + idSubcuenta)) {
		MessageBox.warning(util.translate("scripts", "La subcuenta establecida no es correcta"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_bufferChanged(fN)
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	switch(fN) {
		
		case "sueldobruto": 
		case "irpf": 
		case "segsocial":
			this.child("fdbSueldoNeto").setValue(this.iface.calculateField("sueldoneto"));
		break;
		
		case "codsubcuenta":
			/** 
			\D
			Cuando alcanza el número de dígitos de la subcuenta, busca los datos asociados.
			\end 
			\C
			Al introducir --codsubcuenta--, si el usuario pulsa la tecla "punto" (.), la subcuenta se informa automaticamente con el código de cuenta más tantos ceros como sea necesario para completar la longitud de subcuenta asociada al ejercicio actual.
			\end 
			*/
			if (!this.iface.bloqueoSubcuenta) {
				this.iface.bloqueoSubcuenta = true;
				this.iface.posActualPuntoSubcuenta = flcontppal.iface.pub_formatearCodSubcta(this, "fdbSubcuenta", this.iface.longSubcuenta, this.iface.posActualPuntoSubcuenta);
				this.iface.bloqueoSubcuenta = false;
			}
		break;
		
		case "fnacimiento":
			this.iface.calcularEdad();
		break;
	}

	if (fN == "agencia" || fN == "entidad" || fN == "all") {
		var entidad:String = this.child("entidad").value();
		var agencia:String = this.child("agencia").value();
		var dc1:String = util.calcularDC(entidad + agencia);
		this.child("dc1").setText(dc1);
	}

	if (fN == "cuenta" || fN == "all") {
		var cuenta:String = this.child("cuenta").value();
		var dc2:String = util.calcularDC(cuenta);
		this.child("dc2").setText(dc2);
	}
}

function oficial_calcularSaldoVacaciones()
{
	this.child("fdbSaldoVacaciones").setValue(this.iface.calculateField("saldovacaciones"));
}

function oficial_insertarHistorico()
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var fechaHasta:Date = new Date();

	if (this.cursor().modeAccess() == this.cursor().Insert)
		if (!this.child("tdbHistorico").cursor().commitBufferCursorRelation())
			return false;

	var fechaDesde:Date = cursor.valueBuffer("fechadesde");

	if (!fechaDesde || fechaDesde == "")
		fechaDesde = util.sqlSelect("rh_historicoempleados","fechahasta","codempleado = '" + cursor.valueBuffer("codempleado") + "' ORDER BY fechahasta DESC");

	if (!fechaDesde || fechaDesde == "")
		fechaDesde = cursor.valueBuffer("finicio");
	else
		fechaDesde = util.addDays(fechaDesde, 1);

	if (!fechaDesde || fechaDesde == "")
		fechaDesde = new Date();

	fechaHasta = util.addDays(fechaHasta, -1);
	var dialog = new Dialog;
	dialog.caption = "Fecha de finalización";
	dialog.okButtonText = "Aceptar"
	dialog.cancelButtonText = "Cancelar";

	var fecha = new DateEdit;
	fecha.label = "Fecha de fin de las condiciones: ";
	fecha.date = fechaHasta;
	dialog.add( fecha );

	if( dialog.exec() == true )
    	fechaHasta = fecha.date;
	else
		return;

	var curHistorico:FLSqlCursor = new FLSqlCursor("rh_historicoempleados");
	curHistorico.setModeAccess(curHistorico.Insert);
	curHistorico.refreshBuffer();
	curHistorico.setValueBuffer("codempleado", cursor.valueBuffer("codempleado"));
	curHistorico.setValueBuffer("fechadesde", fechaDesde);
	curHistorico.setValueBuffer("fechahasta", fechaHasta);
	curHistorico.setValueBuffer("sueldobruto", cursor.valueBuffer("sueldobruto"));
	curHistorico.setValueBuffer("segsocial", cursor.valueBuffer("segsocial"));
	curHistorico.setValueBuffer("irpf", cursor.valueBuffer("irpf"));
	curHistorico.setValueBuffer("sueldoneto", cursor.valueBuffer("sueldoneto"));
	curHistorico.setValueBuffer("tipocontrato", cursor.valueBuffer("tipocontrato"));

	if (!curHistorico.commitBuffer())
		return false;
	
	cursor.setValueBuffer("fechadesde",util.addDays(fechaHasta, 1));
	this.child("tdbHistorico").refresh();
}

function oficial_cambiarBloqueo()
{
	var util:FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	if(this.child("pbnBloqueo").on) {
		this.child("fdbSueldoBruto").setDisabled(true);
		this.child("fdbIrpf").setDisabled(true);
		this.child("fdbSegSocial").setDisabled(true);
		this.child("fdbFechaDesde").setDisabled(true);
		
	} 
	else {
		if (cursor.modeAccess() != cursor.Insert || cursor.valueBuffer("sueldoneto") != 0) {
		var res:Number = MessageBox.information(util.translate("scripts", "Antes de modificar las condiciones salariales debería guardarlas en el histórico.\n ¿Desea guardarlas?"), MessageBox.Yes, MessageBox.No);
		if (res == MessageBox.Yes)
			this.iface.insertarHistorico();
		}

		this.child("fdbSueldoBruto").setDisabled(false);
		this.child("fdbIrpf").setDisabled(false);
		this.child("fdbSegSocial").setDisabled(false);
		this.child("fdbFechaDesde").setDisabled(false);
		
	}
}

function oficial_calcularEdad()
{
	var util:FLUtil = new FLUtil();
	
	var fNacimiento = this.cursor().valueBuffer("fnacimiento");
	if (!fNacimiento)
		return;
	
	var dNacimiento = new Date(Date.parse(fNacimiento.toString()));
	var hoy:Date = new Date();
	
	var edad:Number = hoy.getYear() - dNacimiento.getYear();
	dNacimiento.setYear(hoy.getYear());
	
	if (dNacimiento > hoy)
		edad--;
	
	this.child("leEdad").text = util.translate("scripts", "Edad: ") + edad;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
