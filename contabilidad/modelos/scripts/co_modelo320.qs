/***************************************************************************
                 co_modelo320.qs  -  description
                             -------------------
    begin                : jue mar 12 2009
    copyright            : (C) 2009 by InfoSiAL S.L.
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

/** \C
El modelo 320 recoge la información relativa a las declaraciones-liquidaciones mensuales de IVA.
Restricciones del modelo: El proceso actual únicamente calcula los valores descritos en este documento. El resto de valores debe ser introducido por el usuario de forma manual.
Datos necesarios: En las partidas de asientos de contabilidad relativas a subcuentas de IVA devengado y deducible (subcuentas que derivan de cuentas marcadas como IVAREP e IVASOP), deben estar correctamente informados los campos relativos a base imponible, porcentaje de IVA y porcentaje de recargo de equivalencia.
\end */

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
	function calculateField( fN:String ):String { return this.ctx.interna_calculateField( fN ); }
	function validateForm():Boolean { return this.ctx.interna_validateForm(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna 
{
	var ctaIVADevAdquisicionesUE:Array;
	var ctaIVADevEntregasUE:Array;
	var ctaIVADedAdquisicionesUE:Array;
	var bloqueoPago:Boolean;
	function oficial( context ) { interna( context ); } 
	function bufferChanged(fN) { return this.ctx.oficial_bufferChanged(fN); }
	function calcularValores() { this.ctx.oficial_calcularValores(); }
	function establecerFechasPeriodo() { return this.ctx.oficial_establecerFechasPeriodo(); }
	function listaAsientosReg():String { return this.ctx.oficial_listaAsientosReg();}
	function borrarValores():String { return this.ctx.oficial_borrarValores();}
	function comprobarFechas():String { return this.ctx.oficial_comprobarFechas();}
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
/** \C El ejercicio por defecto al crear un nuevo modelo es el ejercicio marcado como actual en el formulario de empresa
\end */
function interna_init() 
{
	var cursor:FLSqlCursor = this.cursor();
	
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this.child("pbnCalcularValores"), "clicked()", this, "iface.calcularValores()");
	
	if (cursor.modeAccess() == cursor.Insert) {
		this.child("fdbCodEjercicio").setValue(flfactppal.iface.pub_ejercicioActual());
		this.child("fdbPersonaContacto").setValue(flcontmode.iface.pub_valorDefectoDatosFiscales("nombre"));
		this.child("fdbTelefono").setValue(flcontmode.iface.pub_valorDefectoDatosFiscales("telefono"));
	}
	
	this.iface.bloqueoPago = false;
}

function interna_calculateField( fN ) 
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var valor;
	switch ( fN ) {
		case "cuotadevtotal":
			valor = parseFloat(this.child("fdbCuotaRG0").value()) + 
				parseFloat(this.child("fdbCuotaRG1").value()) +
				parseFloat(this.child("fdbCuotaRG2").value()) + 
				parseFloat(this.child("fdbCuotaRE0").value()) +
				parseFloat(this.child("fdbCuotaRE1").value()) + 
				parseFloat(this.child("fdbCuotaRE2").value()) +
				parseFloat(this.child("fdbCuotaAI").value());
		break;

		case "cuotadedtotal":
			valor = parseFloat(this.child("fdbCuotaDedOI").value()) + 
				parseFloat(this.child("fdbCuotaDedIm").value()) +
				parseFloat(this.child("fdbCuotaDedAI").value()) + 
				parseFloat(this.child("fdbCuotaComRE").value()) +
				parseFloat(this.child("fdbCuotaRegIn").value());
		break;

		case "cuotadif":
			valor = parseFloat(this.child("fdbCuotaDevTotal").value()) - 
				parseFloat(this.child("fdbCuotaDedTotal").value());
		break;

		case "cuotaestado":
			valor = parseFloat(this.child("fdbCuotaDif").value()) *
				parseFloat(this.child("fdbPorCuotaEstado").value()) / 100;
		break;
		
		case "cuotaresultado":
			valor = parseFloat(this.child("fdbCuotaEstado").value()) -
				parseFloat(this.child("fdbCuotaAnterior").value()) +
				parseFloat(this.child("fdbSujetosPasivos").value());
			break;
		
		case "cuotaanterior":
			/** \C --cuotaanterior--: Suma de los saldos de las partidas correspondientes a la subcuenta de IVA compensado seleccionada, correspondientes al ejercicio seleccionado y anteriores a la fecha de fin del trimestre o período seleccionado
			\end */
			var fechaFin:Date = this.child("fdbFechaFin").value();
			var codEjercicio:String = this.child("fdbCodEjercicio").value();
			var idSubcuenta:Number = this.child("fdbIdSubcuentaCA").value();
			var q:FLSqlQuery = new FLSqlQuery();
			q.setTablesList("co_cuentas,co_subcuentas,co_asientos,co_partidas");
			q.setSelect("SUM(p.debe) - SUM(p.haber)");
			q.setFrom("co_cuentas c INNER JOIN co_subcuentas s ON c.idcuenta = s.idcuenta" +
					" INNER JOIN co_partidas p ON s.idsubcuenta = p.idsubcuenta" +
					" INNER JOIN co_asientos a ON p.idasiento = a.idasiento");
			q.setWhere("c.codejercicio = '" + codEjercicio + "'" +
					" AND a.fecha <= '" + fechaFin + "'" +
					" AND s.idsubcuenta = " + idSubcuenta);
			if (!q.exec()) return "";
			if (!q.first()) return "";
			valor = q.value(0);
			break;
			
		case "cuotarg1":
			valor = parseFloat(this.child("fdbTipoRG0").value()) *
				parseFloat(this.child("fdbBaseImponibleRG0").value()) / 100;
			break;
		
		case "cuotarg2":
			valor = parseFloat(this.child("fdbTipoRG1").value()) *
				parseFloat(this.child("fdbBaseImponibleRG1").value()) / 100;
			break;
		
		case "cuotarg3":
			valor = parseFloat(this.child("fdbTipoRG2").value()) *
				parseFloat(this.child("fdbBaseImponibleRG2").value()) / 100;
			break;
			
		case "cuotare1":
			valor = parseFloat(this.child("fdbTipoRE0").value()) *
				parseFloat(this.child("fdbBaseImponibleRE0").value()) / 100;
			break;
		
		case "cuotare2":
			valor = parseFloat(this.child("fdbTipoRE1").value()) *
				parseFloat(this.child("fdbBaseImponibleRE1").value()) / 100;
			break;
		
		case "cuotare3":
			valor = parseFloat(this.child("fdbTipoRE2").value()) *
				parseFloat(this.child("fdbBaseImponibleRE2").value()) / 100;
			break;
		
		/**\C --entregasi-- es la suma de las bases imponibles de las partidas con subcuenta asociada al tipo especial IVAEUE (Iva de entregas intracomunitarias) cuya fecha de asiento está comprendida en el período declarado
		\end*/
		case "entregasi":
			if (this.iface.ctaIVADevEntregasUE) {
				valor = util.sqlSelect("co_partidas p INNER JOIN co_asientos a ON p.idasiento = a.idasiento", "SUM(p.baseimponible)", "p.idsubcuenta = " + this.iface.ctaIVADevEntregasUE["idsubcuenta"] + " AND a.fecha BETWEEN '" + cursor.valueBuffer("fechainicio") + "' AND '" + cursor.valueBuffer("fechafin") + "'", "co_subcuentas,co_asientos");
			} else {
				valor = 0;
			}
			valor = util.roundFieldValue(valor, "co_modelo300", "entregasi");
			break;
			
		/**\C --baseimponibleai-- es la suma de las bases imponibles de las partidas con subcuenta asociada al tipo especial IVASUE (Iva soportado de adquisiciones intracomunitarias) cuya fecha de asiento está comprendida en el período declarado
		\end*/
		case "baseimponibleai":
			if (this.iface.ctaIVADevAdquisicionesUE) {
				valor = util.sqlSelect("co_partidas p INNER JOIN co_asientos a ON p.idasiento = a.idasiento", "SUM(p.baseimponible)", "p.idsubcuenta = " + this.iface.ctaIVADevAdquisicionesUE["idsubcuenta"] + " AND a.fecha BETWEEN '" + cursor.valueBuffer("fechainicio") + "' AND '" + cursor.valueBuffer("fechafin") + "'", "co_subcuentas,co_asientos");
			} else {
				valor = 0;
			}
			valor = util.roundFieldValue(valor, "co_modelo300", "baseimponibleai");
			break;
		
		/**\C --cuotaai-- es la suma de los saldos (haber - debe) de las partidas con subcuenta asociada al tipo especial IVASUE (Iva soportado de adquisiciones intracomunitarias) cuya fecha de asiento está comprendida en el período declarado
		\end*/
		case "cuotaai":
			if (this.iface.ctaIVADevAdquisicionesUE) {
				valor = util.sqlSelect("co_partidas p INNER JOIN co_asientos a ON p.idasiento = a.idasiento", "SUM(p.haber - p.debe)", "p.idsubcuenta = " + this.iface.ctaIVADevAdquisicionesUE["idsubcuenta"] + " AND a.fecha BETWEEN '" + cursor.valueBuffer("fechainicio") + "' AND '" + cursor.valueBuffer("fechafin") + "'", "co_subcuentas,co_asientos");
			} else {
				valor = 0;
			}
			valor = util.roundFieldValue(valor, "co_modelo300", "cuotaai");
			break;
			
		/**\C --cuotadedai-- es la suma de los saldos (debe - haber) de las partidas con subcuenta asociada al tipo especial IVADUE (Iva devengado de adquisiciones intracomunitarias) cuya fecha de asiento está comprendida en el período declarado
		\end*/
		case "cuotadedai":
			if (this.iface.ctaIVADedAdquisicionesUE) {
				valor = util.sqlSelect("co_partidas p INNER JOIN co_asientos a ON p.idasiento = a.idasiento", "SUM(p.debe - p.haber)", "p.idsubcuenta = " + this.iface.ctaIVADedAdquisicionesUE["idsubcuenta"] + " AND a.fecha BETWEEN '" + cursor.valueBuffer("fechainicio") + "' AND '" + cursor.valueBuffer("fechafin") + "'", "co_subcuentas,co_asientos");
			} else {
				valor = 0;
			}
			valor = util.roundFieldValue(valor, "co_modelo300", "cuotaai");
			break;
	
		case "dcdev": 
			var entidad:String = cursor.valueBuffer("ctaentidaddev");
			var agencia:String = cursor.valueBuffer("ctaagenciadev");
			var cuenta:String = cursor.valueBuffer("cuentadev");
			if ( !entidad.isEmpty() && !agencia.isEmpty() && ! cuenta.isEmpty() && entidad.length == 4 && agencia.length == 4 && cuenta.length == 10 ) {
				var dc1:String = util.calcularDC(entidad + agencia);
				var dc2:String = util.calcularDC(cuenta);
				valor = dc1 + dc2;
			}
			break;
			
		case "dcingreso": 
			var entidad:String = cursor.valueBuffer("ctaentidadingreso");
			var agencia:String = cursor.valueBuffer("ctaagenciaingreso");
			var cuenta:String = cursor.valueBuffer("cuentaingreso");
			if ( !entidad.isEmpty() && !agencia.isEmpty() && ! cuenta.isEmpty() && entidad.length == 4 && agencia.length == 4 && cuenta.length == 10 ) {
				var dc1:String = util.calcularDC(entidad + agencia);
				var dc2:String = util.calcularDC(cuenta);
				valor = dc1 + dc2;
			}
			break;
			
		case "pagoefectivo": 
			if (cursor.valueBuffer("pagocuenta"))
				valor = false;
			break;
		
		case "pagocuenta": 
			if (cursor.valueBuffer("pagoefectivo"))
				valor = false;
			break;
	}
	return valor;
}

function interna_validateForm():Boolean
{
/** \C Las fechas que definen el período deben ser coherentes (fin > inicio) y pertenecer al ejercicio seleccionado
\end */
	if (!this.iface.comprobarFechas()) 
		return false;
	return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_bufferChanged( fN ) 
{
	switch ( fN ) {
		case "cuotarg1":
		case "cuotarg2":
		case "cuotarg3":
		case "cuotare1":
		case "cuotare2":
		case "cuotare3":
		case "cuotaai":
			this.child( "fdbCuotaDevTotal" ).setValue( this.iface.calculateField( "cuotadevtotal" ) );
			break;
			
		case "baseimponiblerg1":
		case "tiporg1":
			this.child( "fdbCuotaRG0" ).setValue( this.iface.calculateField( "cuotarg1" ) );
			break;
			
		case "baseimponiblerg2":
		case "tiporg2":
			this.child( "fdbCuotaRG1" ).setValue( this.iface.calculateField( "cuotarg2" ) );
			break;
			
		case "baseimponiblerg3":
		case "tiporg3":
			this.child( "fdbCuotaRG2" ).setValue( this.iface.calculateField( "cuotarg3" ) );
			break;
			
		case "baseimponiblere1":
		case "tipore1":
			this.child( "fdbCuotaRE0" ).setValue( this.iface.calculateField( "cuotare1" ) );
			break;
			
		case "baseimponiblere2":
		case "tipore2":
			this.child( "fdbCuotaRE1" ).setValue( this.iface.calculateField( "cuotare2" ) );
			break;
			
		case "baseimponiblere3":
		case "tipore3":
			this.child( "fdbCuotaRE2" ).setValue( this.iface.calculateField( "cuotare3" ) );
			break;
			
		case "periodo":
			this.iface.establecerFechasPeriodo();
			break;
			
		case "sujetospasivos":
		case "cuotaestado":
		case "cuotaanterior":
			this.child( "fdbCuotaResultado" ).setValue( this.iface.calculateField( "cuotaresultado" ) );
			break;
		
		case "cuotadedoi":
		case "cuotadedim":
		case "cuotadedai":
		case "cuotacomre":
		case "cuotaregin":
			this.child( "fdbCuotaDedTotal" ).setValue( this.iface.calculateField( "cuotadedtotal" ) );
			break;
		
		case "cuotadedtotal":
		case "cuotadevtotal":
			this.child( "fdbCuotaDif" ).setValue(this.iface.calculateField( "cuotadif" ));
			break;
	
		case "cuotadif":
		case "porcuotaestado":
			this.child( "fdbCuotaEstado" ).setValue(this.iface.calculateField( "cuotaestado" ));
			break;
	
		case "cuotaestado":
		case "cuotaanterior":
		case "sujetospasivos":
			this.child( "fdbCuotaResultado" ).setValue(this.iface.calculateField( "cuotaresultado" ));
			break;
	
		case "idsctacuotasanteriores":
			this.child( "fdbCuotaAnterior" ).setValue(this.iface.calculateField( "cuotaanterior" ));
			break;
	
		case "codejercicio":
			this.iface.borrarValores();
 			this.iface.establecerFechasPeriodo();
			break;
	
		case "fechainicio":
		case "fechafin":
			this.iface.borrarValores();
			break;
			
		case "codcuentadev":
		case "ctaentidaddev":
		case "ctaagenciadev":
		case "cuentadev": 
			this.child("fdbDcDev").setValue(this.iface.calculateField("dcdev"));
			break;
			
		case "codcuentaingreso":
		case "ctaentidadingreso":
		case "ctaagenciaingreso":
		case "cuentaingreso": 
			this.child("fdbDcIngreso").setValue(this.iface.calculateField("dcingreso"));
			break;
			
		case "pagoefectivo": 
			if (!this.iface.bloqueoPago) {
				this.iface.bloqueoPago = true;
				this.child("fdbPagoCuenta").setValue(this.iface.calculateField("pagocuenta"));
				this.iface.bloqueoPago = false;
			}
			break;
			
		case "pagocuenta": 
			if (!this.iface.bloqueoPago) {
				this.iface.bloqueoPago = true;
				this.child("fdbPagoEfectivo").setValue(this.iface.calculateField("pagoefectivo"));
				this.iface.bloqueoPago = false;
			}
			break;
	}
}

/** \D Calcula algunas de las casillas del modelo a partir de los contenidos de la base de datos de contabilidad
\end */
function oficial_calcularValores()
{
	if (!this.iface.comprobarFechas()) return false;

	var util:FLUtil = new FLUtil();
	var fechaInicio:Date = this.child("fdbFechaInicio").value();
	var fechaFin:Date = this.child("fdbFechaFin").value();
	var codEjercicio:String = this.child("fdbCodEjercicio").value();
	var inicioEjercicio = util.sqlSelect("ejercicios", "fechainicio", 
		"codejercicio = '" + codEjercicio + "'");
	var listaAR:String = flcontmode.iface.pub_listaAsientosReg();

	this.iface.ctaIVADevAdquisicionesUE = flfacturac.iface.pub_datosCtaEspecial("IVARUE", codEjercicio);
	if (this.iface.ctaIVADevAdquisicionesUE["error"] != 0)
		this.iface.ctaIVADevAdquisicionesUE = false;

	this.iface.ctaIVADevEntregasUE = flfacturac.iface.pub_datosCtaEspecial("IVAEUE", codEjercicio);
	if (this.iface.ctaIVADevEntregasUE["error"] != 0)
		this.iface.ctaIVADevEntregasUE = false;

	this.iface.ctaIVADedAdquisicionesUE = flfacturac.iface.pub_datosCtaEspecial("IVASUE", codEjercicio);
	if (this.iface.ctaIVADedAdquisicionesUE["error"] != 0)
		this.iface.ctaIVADedAdquisicionesUE = false;
	
	var baseImponible:Number;
	var cuota:Number;
	
	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
	var qryRegIVA:FLSqlQuery = new FLSqlQuery();
	qryRegIVA.setTablesList("co_cuentas,co_subcuentas,co_asientos,co_partidas");
	qryRegIVA.setSelect("SUM(baseimponible), SUM(p.haber - p.debe)");
	qryRegIVA.setFrom("co_cuentas c INNER JOIN co_subcuentas s ON c.idcuenta = s.idcuenta" +
			" INNER JOIN co_partidas p ON s.idsubcuenta = p.idsubcuenta" +
			" INNER JOIN co_asientos a ON p.idasiento = a.idasiento");


/** \C IVA Devengado: Para el régimen general, las 3 bases imponibles son la suma de la base imponible de todas las partidas cuya subcuenta desciende de una cuenta marcada como IVA Repercutido (IVAREP: 477xxx), cuyo porcentaje de IVA es respectivamente 16, 7 y 4, y cuya fecha de asiento está comprendida en el trimestre o período seleccionado. No se incluyen las partidas correspondientes a asientos de regularización de IVA.

Las coutas de IVA se calculan como el producto de sus respectivas bases imponibles por el porcentaje de IVA correspondiente
\end */
	var ivas:Array = [16,7,4];
	for (var i:Number = 0; i < ivas.length; i++) {
		
		where = "(c.idcuentaesp = 'IVAREP')" + 
			" AND c.codejercicio = '" + codEjercicio + "'" +
			" AND p.iva = " + ivas[i] + 
			" AND a.fecha >= '" + fechaInicio + "'" + 
			" AND a.fecha <= '" + fechaFin + "'" +
			" AND a.idasiento NOT IN (" + listaAR + ")";

		if (this.iface.ctaIVADevAdquisicionesUE) {
			where += " AND s.idsubcuenta <> " + this.iface.ctaIVADevAdquisicionesUE["idsubcuenta"];
		}
		if (this.iface.ctaIVADevEntregasUE) {
			where += " AND s.idsubcuenta <> " + this.iface.ctaIVADevEntregasUE["idsubcuenta"];
		}

		where += " GROUP BY s.idsubcuenta, s.codsubcuenta";

		qryRegIVA.setWhere(where);
		if (!qryRegIVA.exec()) {
			continue;
		}
	
		baseImponible = 0;
		cuota = 0;
		
		while (qryRegIVA.next()) {
			baseImponible += qryRegIVA.value(0);
			cuota += qryRegIVA.value(1);
		}
			
		this.child("fdbBaseImponibleRG" + i.toString()).setValue(baseImponible);
		this.child("fdbTipoRG" + i.toString()).setValue(ivas[i]);
		this.child("fdbCuotaRG" + i.toString()).setValue(cuota);
	}
	

/** \C IVA Devengado: Para los recargos de equivalencia, las 3 bases imponibles son la suma de la base imponible de todas las partidas cuya subcuenta desciende de una cuenta marcada como IVA Repercutido (IVAREP: 477xxx), cuyo porcentaje de recargo de equivalencia es respectivamente 4, 1 y 0.5, y cuya fecha de asiento está comprendida en el trimestre o período seleccionado. No se incluyen las partidas correspondientes a asientos de regularización de IVA

Las coutas de recargo de equivalencia se calculan como el producto de sus respectivas bases imponibles por el porcentaje de recargo correspondiente
\end */
	var recargos:Array = [4,1,0.5];
	for (var i:Number = 0; i < ivas.length; i++) {
			
		where = "(c.idcuentaesp = 'IVAREP')" + 
			" AND c.codejercicio = '" + codEjercicio + "'" +
			" AND p.recargo = " + recargos[i] + 
			" AND a.fecha >= '" + fechaInicio + "'" + 
			" AND a.fecha <= '" + fechaFin + "'" +
			" AND a.idasiento NOT IN (" + listaAR + ")";

		qryRegIVA.setWhere(where);
		if (!qryRegIVA.exec()) {
			continue;
		}
	
		baseImponible = 0;
		cuota = 0;
		
		while (qryRegIVA.next()) {
			baseImponible += qryRegIVA.value(0);
			cuota += qryRegIVA.value(1);
		}
			
		this.child("fdbBaseImponibleRE" + i.toString()).setValue(baseImponible);
		this.child("fdbTipoRE" + i.toString()).setValue(recargos[i]);
		this.child("fdbCuotaRE" + i.toString()).setValue(this.iface.calculateField("cuotare" + (i + 1).toString()));
	}
	
/** \C IVA Soportado: --cuotadedoi--: Es la suma del producto de la base imponible por el porcentaje de IVA correspondiente de todas las partidas cuya subcuenta desciende de una cuenta marcada como IVA Soportado (IVASOP: 472xxx), y cuya fecha de asiento está comprendida en el trimestre o período seleccionado. No se incluyen las partidas correspondientes a asientos de regularización de IVA
\end */
	where = "(c.idcuentaesp = 'IVASOP')" + 
		" AND c.codejercicio = '" + codEjercicio + "'" +
		" AND a.fecha >= '" + fechaInicio + "'" + 
		" AND a.fecha <= '" + fechaFin + "'" +
		" AND a.idasiento NOT IN (" + listaAR + ")";

	if (this.iface.ctaIVADedAdquisicionesUE) {
		where += " AND s.idsubcuenta <> " + this.iface.ctaIVADedAdquisicionesUE["idsubcuenta"];
	}

	where += " GROUP BY p.iva";
	qryRegIVA.setWhere(where);
	qryRegIVA.setSelect("SUM(baseimponible), p.iva, SUM(p.debe - p.haber)");

	if (!qryRegIVA.exec()) {
		return false;
	}

	var sumaDebe:Number = 0;
	
	while (qryRegIVA.next()) {
		sumaDebe += qryRegIVA.value(2);
		//(qryRegIVA.value(0) * qryRegIVA.value(1)) / 100;
	}
	
	this.child("fdbCuotaDedOI").setValue(sumaDebe);
	this.child( "fdbCuotaAnterior" ).setValue(this.iface.calculateField( "cuotaanterior" ));
	this.child( "fdbEntregasI" ).setValue(this.iface.calculateField( "entregasi" ));
	this.child( "fdbbaseimponibleai" ).setValue(this.iface.calculateField( "baseimponibleai" ));
	this.child( "fdbCuotaAI" ).setValue(this.iface.calculateField( "cuotaai" ));
	this.child( "fdbCuotaDedAI" ).setValue(this.iface.calculateField( "cuotadedai" ));
}

/** \D Establece las fechas de inicio y fin de mes en función del mes seleccionado
\end */
function oficial_establecerFechasPeriodo()
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var fechaInicio:Date;
	var fechaFin:Date;
	var codEjercicio:String = this.child("fdbCodEjercicio").value();
	var inicioEjercicio = util.sqlSelect("ejercicios", "fechainicio", 
		"codejercicio = '" + codEjercicio + "'");
		
	if (!inicioEjercicio) 
		return false;
	
	fechaInicio.setYear(inicioEjercicio.getYear());
	fechaFin.setYear(inicioEjercicio.getYear());
	fechaInicio.setDate(1);
debug(this.child("fdbPeriodo").value());
	switch (cursor.valueBuffer("periodo")) {
		case "Enero": {
			fechaInicio.setMonth(1);
			fechaFin.setMonth(1);
			fechaFin.setDate(31);
			break;
		}
		case "Febrero": {
			fechaInicio.setMonth(2);
			fechaFin.setMonth(2);
			fechaFin.setDate(28);
			break;
		}
		case "Marzo": {
			fechaInicio.setMonth(3);
			fechaFin.setMonth(3);
			fechaFin.setDate(31);
			break;
		}
		case "Abril": {
			fechaInicio.setMonth(4);
			fechaFin.setMonth(4);
			fechaFin.setDate(30);
			break;
		}
		case "Mayo": {
			fechaInicio.setMonth(5);
			fechaFin.setMonth(5);
			fechaFin.setDate(31);
			break;
		}
		case "Junio": {
			fechaInicio.setMonth(6);
			fechaFin.setMonth(6);
			fechaFin.setDate(30);
			break;
		}
		case "Julio": {
			fechaInicio.setMonth(7);
			fechaFin.setMonth(7);
			fechaFin.setDate(31);
			break;
		}
		case "Agosto": {
			fechaInicio.setMonth(8);
			fechaFin.setMonth(8);
			fechaFin.setDate(31);
			break;
		}
		case "Septiembre": {
			fechaInicio.setMonth(9);
			fechaFin.setMonth(9);
			fechaFin.setDate(30);
			break;
		}
		case "Octubre": {
			fechaInicio.setMonth(10);
			fechaFin.setMonth(10);
			fechaFin.setDate(31);
			break;
		}
		case "Noviembre": {
			fechaInicio.setMonth(11);
			fechaFin.setMonth(11);
			fechaFin.setDate(30);
			break;
		}
		case "Diciembre": {
			fechaInicio.setMonth(12);
			fechaFin.setMonth(12);
			fechaFin.setDate(31);
			break;
		}
	}
	
	this.child("fdbFechaInicio").setValue(fechaInicio);
	this.child("fdbFechaFin").setValue(fechaFin);
}

/** \D Borra algunas de las casillas calculadas
\end */
function oficial_borrarValores()
{
	if (!this.child("fdbBaseImponibleRG0")) return false;
	
	this.child("fdbBaseImponibleRG0").setValue(0);
	this.child("fdbBaseImponibleRG1").setValue(0);
	this.child("fdbBaseImponibleRG2").setValue(0);
	this.child("fdbBaseImponibleRE0").setValue(0);
	this.child("fdbBaseImponibleRE1").setValue(0);
	this.child("fdbBaseImponibleRE2").setValue(0);
	this.child("fdbCuotaDedOI").setValue(0);
	
}

/** \D Comprueba que fechainicio < fechafin y que ambas pertenecen al ejercicio seleccionado

@return	True si la comprobación es buena, false en caso contrario
\end */
function oficial_comprobarFechas():Boolean
{
	var util:FLUtil = new FLUtil();
	
	var codEjercicio:String = this.child("fdbCodEjercicio").value();
	var fechaInicio:String = this.child("fdbFechaInicio").value();
	var fechaFin:String = this.child("fdbFechaFin").value();

	if (util.daysTo(fechaInicio, fechaFin) < 0) {
		MessageBox.critical(util.translate("scripts", "La fecha de inicio debe ser menor que la de fin"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
	
	var inicioEjercicio:String = util.sqlSelect("ejercicios", "fechainicio", "codejercicio = '" + codEjercicio + "'");
	var finEjercicio:String = util.sqlSelect("ejercicios", "fechafin", "codejercicio = '" + codEjercicio + "'");

	if ((util.daysTo(inicioEjercicio, fechaInicio) < 0) || (util.daysTo(fechaFin, finEjercicio) < 0)) {
		MessageBox.critical(util.translate("scripts", "Las fechas seleccionadas no corresponden al ejercicio"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
	
	return true;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
