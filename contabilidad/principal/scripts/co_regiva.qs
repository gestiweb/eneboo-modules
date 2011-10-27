/***************************************************************************
                 co_regiva.qs  -  description
                             -------------------
    begin                : lun jul 11 2004
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
	function calculateField(fN:String):String {
		return interna_calculateField(fN);
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var tbnCalcular:Object;
	var divisaDefecto:String;
	var tdbPartidas:FLTableDB;
	var bloqueo:Boolean;
	var codEjercicioActual:String; 
	
	function oficial( context ) { interna( context ); } 
	function generarAsiento():Boolean {
		return this.ctx.oficial_generarAsiento();
	}
	function calcular() {
		return this.ctx.oficial_calcular();
	}
	function regenerarAsiento():Array {
		return this.ctx.oficial_regenerarAsiento();
	}
	function asientoBorrable(idAsiento:Number):Boolean {
		return this.ctx.oficial_asientoBorrable(idAsiento);
	}
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function obtenerAsientosReg():String {
		return this.ctx.oficial_obtenerAsientosReg();
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
/** \C La tabla de partidas se muestra en modo de sólo lectura
\end */    
function interna_init()
{ 
	var util:FLUtil = new FLUtil;
	
	this.iface.codEjercicioActual = flfactppal.iface.pub_ejercicioActual();
	this.child("fdbCodEjercicio").setValue(this.iface.codEjercicioActual);
	var datosEjercicio:Array = flcontppal.iface.pub_ejecutarQry("ejercicios", "fechainicio,fechafin",  "codejercicio = '" + this.iface.codEjercicioActual + "'");
	var cursor:FLSqlCursor = this.cursor();
	
	this.iface.divisaDefecto = util.sqlSelect("empresa", "coddivisa", "1 = 1");
	this.iface.tbnCalcular = this.child("tbnCalcular");
	this.iface.bloqueo = false;
	
	connect(this.iface.tbnCalcular, "clicked()", this, "iface.calcular");
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");

	if (cursor.modeAccess() == cursor.Insert) {
		var ultFechaReg:String = util.sqlSelect("co_regiva", "fechafin",
				"fechainicio >= '" + datosEjercicio.fechainicio + "'" + 
				" AND fechafin <= '" + datosEjercicio.fechafin + "'" +
				" ORDER BY fechafin DESC");
		if (ultFechaReg) {
				this.child("fdbFechaInicio").setValue(util.addDays(ultFechaReg, 1));
		} else {
				this.child("fdbFechaInicio").setValue(datosEjercicio.fechainicio);
		}
		var fecha:String = util.addMonths(this.child("fdbFechaInicio").value(), 3);
		fecha = util.addDays(fecha, -1);
		this.child("fdbFechaFin").setValue(fecha);
		
		this.child("fdbCodSubcuentaDeu").setValue(util.sqlSelect("co_cuentas c INNER JOIN co_subcuentas s " + 
				" ON c.idcuenta = s.idcuenta", "s.codsubcuenta", 
				" s.idcuentaesp = 'IVADEU' AND c.codejercicio = '" + this.iface.codEjercicioActual + "' ORDER BY s.codsubcuenta",
				"co_cuentas,co_subcuentas"));
		this.child("fdbCodSubcuentaAcr").setValue(util.sqlSelect("co_cuentas c INNER JOIN co_subcuentas s " + 
				" ON c.idcuenta = s.idcuenta", "s.codsubcuenta", 
				" s.idcuentaesp = 'IVAACR' AND c.codejercicio = '" + this.iface.codEjercicioActual + "' ORDER BY s.codsubcuenta",
				"co_cuentas,co_subcuentas"));
	}
	
	this.iface.tdbPartidas = this.child("tdbPartidas");
	this.iface.tdbPartidas.setReadOnly(true);
	this.iface.tdbPartidas.cursor().setMainFilter("idasiento = " + cursor.valueBuffer("idasiento"));
	this.iface.tdbPartidas.refresh();
}

function interna_calculateField(fN:String):String
{
	var res:String = "";
	var cursor = this.cursor();
	var util:FLUtil = new FLUtil;
	switch(fN) {
		case "periodo": {
			var fechaInicio:Date = new Date(Date.parse(cursor.valueBuffer("fechainicio").toString()));
			var diaInicio:Number = fechaInicio.getDate();
			var mesInicio:Number = fechaInicio.getMonth();
			var fechaFin:Date = new Date(Date.parse(cursor.valueBuffer("fechaFin").toString()));
			var diaFin:Number = fechaFin.getDate();
			var mesFin:Number = fechaFin.getMonth();
			
			if (diaInicio == 1 && mesInicio == 1 && diaFin == 31 && mesFin == 3)
				res = "T1";
			else if (diaInicio == 1 && mesInicio == 4 && diaFin == 30 && mesFin == 6)
				res = "T2";
			else if (diaInicio == 1 && mesInicio == 7 && diaFin == 30 && mesFin == 9)
				res = "T3";
			else if (diaInicio == 1 && mesInicio == 10 && diaFin == 31 && mesFin == 12)
				res = "T4";
			else 
				res = "Ninguno";
			break;
		}
		case "fechainicio": {
			var fechaEjercicio:Date = this.child("fdbIniEjercicio").value();
			var fechaInicio:Date = this.child("fdbFechaInicio").value();
			
			fechaInicio.setDate(1);
			switch(cursor.valueBuffer("periodo").toString()) {
				case "T1": {
					fechaInicio.setMonth(1);
					break;
				}
				case "T2": {
					fechaInicio.setMonth(4);
					break;
				}
				case "T3": {
					fechaInicio.setMonth(7);
					break;
				}
				case "T4": {
					fechaInicio.setMonth(10);
					break;
				}
			}
			fechaInicio.setYear(fechaEjercicio.getYear());
			res = fechaInicio.toString();
			break;
		}
		case "fechafin": {
			var fechaInicio:String = cursor.valueBuffer("fechainicio");
			res = util.addMonths(fechaInicio, 3);
			res = util.addDays(res, -1);
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
function oficial_calcular()
{
	var util:FLUtil = new FLUtil;
	if (!this.iface.generarAsiento()) {
		MessageBox.critical(util.translate("scripts", "No se pudo generar el asiento correspondiente a la regularización de IVA"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return;
	}
}

/** \C La generación del asiento de regularización de IVA se realiza de la siguiente forma:
1. Se totaliza el IVA repercutido en el período definido en el formulario (R), es decir, la suma de las partidas pertenecientes a asientos de dicho período y cuya subcuenta deriva de una cuenta especial de tipo IVAREP.

2. Se totaliza el IVA soportado en el período definido en el formulario (S), es decir, la suma de las partidas pertenecientes a asientos de dicho período y cuya subcuenta deriva de una cuenta especial de tipo IVASOP.

3. Si el IVA repercutido es mayor que el soportado (R > S), la diferencia se asigna a la subcuenta de Hacienda Pública Deudora especificada en el formulario.

4. Si el IVA soportado es mayor que el repercutido (S > R), se comprueba el saldo actual de la subcuenta Hacienda Pública Deudora para el ejercicio seleccionado (D). 

4.1 Si el saldo D es positivo (D > 0), se compara dicho saldo con la diferencia entre el IVA soportado y el repercutido (S - R).

4.1.2 Si D >= (S - R), la diferencia de IVA (D - R) se asigna en su totalidad a la subcuenta de Hacienda Pública Deudora.

4.1.3 Si D < (S - R), se asigna la cantidad D a la subcuenta de Hacienda Pública Deudora y el resto hasta completar la diferencia (S - R - D) a la subcuenta de Hacienda Pública Acreedora especificada en el formulario
\end */
function oficial_generarAsiento()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var codEjercicio = cursor.valueBuffer("codejercicio");
	
	var asiento:Array = this.iface.regenerarAsiento();
	if (asiento.error == true) {
		return false;
	}
	cursor.setValueBuffer("idasiento", asiento.idasiento);
	this.iface.tdbPartidas.cursor().setMainFilter("idasiento = " + cursor.valueBuffer("idasiento"));
		
/** \D Realiza un consulta sobre las partidas de subcuentas de I.V.A. soportado o repercutido y obtiene el total sumado de debe y haber de dichas partidas
\end */
	var listaAsientosReg:String = this.iface.obtenerAsientosReg();
	if (!listaAsientosReg) {
		return false;
	}
	var miWhere:String  = "(s.idcuentaesp IN ('IVASOP', 'IVAREP', 'IVASIM', 'IVASRA', 'IVASUE', 'IVARUE', 'IVAEUE', 'IVASIM', 'IVAREX', 'IVARXP', 'IVASEX') OR (s.idcuentaesp IN ('IVARRE', 'IVAACR') AND p.recargo <> 0 AND p.recargo IS NOT NULL))" +
		" AND c.codejercicio = '" + codEjercicio + "'" +
		" AND a.fecha >= '" + this.child("fdbFechaInicio").value() + "'" +
		" AND a.fecha <= '" + this.child("fdbFechaFin").value() + "'";
	if (listaAsientosReg != "NO") {
		miWhere += " AND a.idasiento NOT IN (" + listaAsientosReg + ")";
	}
	miWhere += " GROUP BY s.idsubcuenta, s.codsubcuenta";
	
	var qryRegIVA:FLSqlQuery = new FLSqlQuery();
	qryRegIVA.setTablesList("co_cuentas,co_subcuentas,co_asientos,co_partidas");
	qryRegIVA.setSelect("s.idsubcuenta, s.codsubcuenta, SUM(p.debe), SUM(p.haber)");
	qryRegIVA.setFrom("co_cuentas c INNER JOIN co_subcuentas s ON c.idcuenta = s.idcuenta" +
		" INNER JOIN co_partidas p ON s.idsubcuenta = p.idsubcuenta" +
		" INNER JOIN co_asientos a ON p.idasiento = a.idasiento");
	qryRegIVA.setWhere(miWhere);

	if (!qryRegIVA.exec()) {
		return false;
	}
/** \D Los valores debe y haber obtenidos se utilizan para crear el nuevo asiento de regularización
\end */
	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
	var acumuladoDebe:Number = 0;
	var acumuladoHaber:Number = 0;
	while (qryRegIVA.next()) {
		curPartida.setModeAccess(curPartida.Insert);
		curPartida.refreshBuffer();
		curPartida.setValueBuffer("idasiento", cursor.valueBuffer("idasiento"));
		curPartida.setValueBuffer("idsubcuenta", qryRegIVA.value(0));
		curPartida.setValueBuffer("codsubcuenta", qryRegIVA.value(1));
		curPartida.setValueBuffer("concepto", "REGULARIZACIÓN IVA");
		curPartida.setValueBuffer("debe", qryRegIVA.value(3));
		curPartida.setValueBuffer("haber", qryRegIVA.value(2));
		curPartida.setValueBuffer("coddivisa", this.iface.divisaDefecto);
		
		if (!curPartida.commitBuffer()) 
			return false;
		
		acumuladoDebe += parseFloat(qryRegIVA.value(2));
		acumuladoHaber += parseFloat(qryRegIVA.value(3));
	}
	
	if (acumuladoDebe == 0 && acumuladoHaber == 0) {
		MessageBox.warning(util.translate("scripts", "No hay datos de IVA para el período seleccionado"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return true;
	}

	if (acumuladoDebe > acumuladoHaber) {
		acumuladoDebe = acumuladoDebe - acumuladoHaber;
		acumuladoHaber = 0;
	} else {
		acumuladoHaber = acumuladoHaber - acumuladoDebe;
		acumuladoDebe = 0;
	}
	
	var codSubcuenta:String;
	if (acumuladoDebe > acumuladoHaber) {
		codSubcuenta = this.child("fdbCodSubcuentaDeu").value();
	} else {
		codSubcuenta = this.child("fdbCodSubcuentaAcr").value();
		var codSubcuentaDeu:String = this.child("fdbCodSubcuentaDeu").value();
		var saldoSubcuentaDeu:Number = util.sqlSelect("co_subcuentas", "saldo", "codsubcuenta = '" + codSubcuentaDeu + "' AND codejercicio = '" + codEjercicio + "'");
		if (saldoSubcuentaDeu > 0) {
			if (saldoSubcuentaDeu > acumuladoHaber)
				codSubcuenta = codSubcuentaDeu;
			else {
				acumuladoHaber = acumuladoHaber - saldoSubcuentaDeu;
				curPartida.setModeAccess(curPartida.Insert);
				curPartida.refreshBuffer();
				curPartida.setValueBuffer("idasiento", cursor.valueBuffer("idasiento"));
				curPartida.setValueBuffer("concepto", "REGULARIZACIÓN IVA");
				curPartida.setValueBuffer("coddivisa", this.iface.divisaDefecto);
				curPartida.setValueBuffer("debe", 0);
				curPartida.setValueBuffer("haber", saldoSubcuentaDeu);
				curPartida.setValueBuffer("codsubcuenta", codSubcuentaDeu);
				curPartida.setValueBuffer("idsubcuenta", util.sqlSelect("co_subcuentas", "idsubcuenta",
					"codsubcuenta = '" + codSubcuentaDeu + "' AND codejercicio = '" + codEjercicio + "'"));
				if (!curPartida.commitBuffer()) 
					return false;
			}
		}
	}
	curPartida.setModeAccess(curPartida.Insert);
	curPartida.refreshBuffer();
	curPartida.setValueBuffer("idasiento", cursor.valueBuffer("idasiento"));
	curPartida.setValueBuffer("concepto", "REGULARIZACIÓN IVA");
	curPartida.setValueBuffer("coddivisa", this.iface.divisaDefecto);
	curPartida.setValueBuffer("debe", acumuladoDebe);
	curPartida.setValueBuffer("haber", acumuladoHaber);
	curPartida.setValueBuffer("codsubcuenta", codSubcuenta);
	curPartida.setValueBuffer("idsubcuenta", util.sqlSelect("co_subcuentas", "idsubcuenta",
		"codsubcuenta = '" + codSubcuenta + "' AND codejercicio = '" + codEjercicio + "'"));
	if (!curPartida.commitBuffer()) 
		return false;
		
	var importeAsiento:Number = util.sqlSelect("co_partidas", "SUM(debe)", "idasiento = " + asiento.idasiento);
	var curAsiento:FLSqlCursor = new FLSqlCursor("co_asientos");
	curAsiento.select("idasiento = " + asiento.idasiento);
	curAsiento.first();
	if (!curAsiento.valueBuffer("editable")) {
		curAsiento.setUnLock("editable", true);
	}
	curAsiento.select("idasiento = " + asiento.idasiento);
	curAsiento.first();
	curAsiento.setModeAccess(curAsiento.Edit);
	curAsiento.refreshBuffer();
	curAsiento.setValueBuffer("importe", importeAsiento);
	curAsiento.commitBuffer();
	curAsiento.select("idasiento = " + asiento.idasiento);
	curAsiento.first();
	curAsiento.setUnLock("editable", false);



	this.iface.tdbPartidas.refresh();
	
	return true;
}

/** \D Genera o regenera el registro en la tabla de asientos correspondiente a la factura. Si el asiento ya estaba creado borra sus partidas asociadas.
@return	array con los siguientes datos:
asiento.idasiento: Id del asiento 
asiento.numero: numero del asiento 
asiento.fecha: fecha del asiento 
asiento.error: indicador booleano de que ha habido un error en la función
\end */
function oficial_regenerarAsiento():Array
{
	var asiento:Array = [];
	var cursor = this.cursor();
	var idAsiento:Number = cursor.valueBuffer("idasiento");
	if (cursor.isNull("idasiento")) {
		var curAsiento:FLSqlCursor = new FLSqlCursor("co_asientos");
		curAsiento.setModeAccess(curAsiento.Insert);
		curAsiento.refreshBuffer();
		curAsiento.setValueBuffer("numero", 0);
		curAsiento.setValueBuffer("fecha", this.child("fdbFechaAsiento").value());
		curAsiento.setValueBuffer("codejercicio", this.iface.codEjercicioActual);
		curAsiento.setValueBuffer("concepto", "REGULARIZACIÓN IVA");
		
		if (!curAsiento.commitBuffer()) {
			asiento.error = true;
			return asiento;
		}
		asiento.idasiento = curAsiento.valueBuffer("idasiento");
		asiento.numero = curAsiento.valueBuffer("numero");
		asiento.fecha = curAsiento.valueBuffer("fecha");
		curAsiento.select("idasiento = " + asiento.idasiento);
		curAsiento.first();
		curAsiento.setUnLock("editable", false);
	} else {
		if (!this.iface.asientoBorrable(idAsiento)) {
			asiento.error = true;
			return asiento;
		}
		asiento = flcontppal.iface.pub_ejecutarQry("co_asientos", "idasiento,numero,fecha", "idasiento = '" + idAsiento + "'");
		var curPartidas = new FLSqlCursor("co_partidas");
		curPartidas.select("idasiento = " + idAsiento);
		while (curPartidas.next()) {
			curPartidas.setModeAccess(curPartidas.Del);
			curPartidas.refreshBuffer();
			if (!curPartidas.commitBuffer()) {
				asiento.error = true;
				return asiento;
			}
		}
	}
	asiento.error = false;
	return asiento;
}

/* \D Indica si el asiento asociado a la factura puede o no regenerarse, según pertenezca a un ejercicio abierto o cerrado
@param idAsiento: Identificador del asiento
@return True: Asiento borrable, False: Asiento no borrable
\end */
function oficial_asientoBorrable(idAsiento:Number):Boolean
{
	var util:FLUtil = new FLUtil();
	var qryEjerAsiento:FLSqlQuery = new FLSqlQuery();
	qryEjerAsiento.setTablesList("ejercicios,co_asientos");
	qryEjerAsiento.setSelect("e.estado");
	qryEjerAsiento.setFrom("co_asientos a INNER JOIN ejercicios e ON a.codejercicio = e.codejercicio");
	qryEjerAsiento.setWhere("a.idasiento = " + idAsiento);

	if (!qryEjerAsiento.exec())
		return false;

	if (!qryEjerAsiento.first())
		return false;

	if (qryEjerAsiento.value(0) != util.translate("scripts", "ABIERTO")) {
		MessageBox.critical(util.translate("scripts", "No puede realizarse la modificación porque el asiento contable correspondiente pertenece a un ejercicio cerrado"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
	return true;
}

/** \C Mediante el campo --periodo-- podemos establecer automáticamente las fechas desde y hasta del trimestre seleccionado. Si seleccionamos manualmente unas fechas desde y hasta que no definen un trimestre, el valor del campo --periodo-- será 'Ninguno'
\end */
function oficial_bufferChanged(fN:String)
{
	var cursor = this.cursor();
	switch(fN) {
		case "fechainicio":
		case "fechafin": {
			if (!cursor.valueBuffer("fechainicio") || !cursor.valueBuffer("fechafin"))
				return;
			if (!this.iface.bloqueo) {
				this.iface.bloqueo = true;
				cursor.setValueBuffer("periodo", this.iface.calculateField("periodo"));
				this.iface.bloqueo = false;
			}
			break;
		}
		case "periodo": {
			if (!this.iface.bloqueo) {
				this.iface.bloqueo = true;
				this.child("fdbFechaInicio").setValue(this.iface.calculateField("fechainicio"));
				this.child("fdbFechaFin").setValue(this.iface.calculateField("fechafin"));
				this.iface.bloqueo = false;
			}
			break;
		}
	}
}

/** \D Obtiene la lista de asientos de regularización a descontar de la búsqueda de partidas de IVA

@return Lista de los identificadores de los asientos separada por comas, false si hay error, NO si no hay asientos;
\end */
function oficial_obtenerAsientosReg():String
{
	var res:String = "";
	var qryReg:FLSqlQuery = new FLSqlQuery;
	qryReg.setTablesList("co_regiva,co_asientos");
	qryReg.setSelect("a.idasiento");
	qryReg.setFrom("co_regiva ri INNER JOIN co_asientos a ON a.idasiento = ri.idasiento");
	qryReg.setWhere("a.codejercicio = '" + this.child("fdbCodEjercicio").value() + "' AND a.fecha BETWEEN '" + this.child("fdbFechaInicio").value() + "' AND '" + this.child("fdbFechaFin").value() + "'");
	if (!qryReg.exec())
		return false;
	while (qryReg.next()) {
		if (res != "")
			res += ",";
		res += qryReg.value(0);
	}
	if (res == "")
		res = "NO";
	return res;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
