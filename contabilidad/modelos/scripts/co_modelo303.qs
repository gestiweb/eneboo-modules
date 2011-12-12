/***************************************************************************
                 co_modelo303.qs  -  description
                             -------------------
    begin                : mon may 16 2005
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

/** \C
El modelo 300 recoge la información relativa a las declaraciones-liquidaciones trimestrales de IVA.
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
    function init() { 
		return this.ctx.interna_init(); 
	}
	function calculateField( fN:String ):String { return this.ctx.interna_calculateField( fN ); }
	function validateForm():Boolean {
		return this.ctx.interna_validateForm();
	}
	function calculateField2009( fN:String ):String { 
		return this.ctx.interna_calculateField2009( fN ); 
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna 
{
	var ejercicio:Number;
	var curPartida_:FLSqlCursor;
	var whereFechas_:String;
	function oficial( context ) { interna( context ); } 
	function bufferChanged(fN) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function calcularValores() {
		this.ctx.oficial_calcularValores();
	}
	function establecerFechasPeriodo() {
		return this.ctx.oficial_establecerFechasPeriodo();
	}
	function comprobarFechas():String {
		return this.ctx.oficial_comprobarFechas();
	}
	function bufferChanged2009(fN) { 
		return this.ctx.oficial_bufferChanged2009(fN); 
	}
	function habilitarPeriodo() { 
		return this.ctx.oficial_habilitarPeriodo();
	}
	function calcularCasillas01a09():Boolean { 
		return this.ctx.oficial_calcularCasillas01a09();
	}
	function calcularCasillas10a18():Boolean { 
		return this.ctx.oficial_calcularCasillas10a18();
	}
	function calcularCasillas19a20():Boolean { 
		return this.ctx.oficial_calcularCasillas19a20();
	}
	function calcularCasillas22a23():Boolean { 
		return this.ctx.oficial_calcularCasillas22a23();
	}
	function calcularCasillas24a25():Boolean { 
		return this.ctx.oficial_calcularCasillas24a25();
	}
	function calcularCasillas26a27():Boolean { 
		return this.ctx.oficial_calcularCasillas26a27();
	}
	function calcularCasillas28a29():Boolean { 
		return this.ctx.oficial_calcularCasillas28a29();
	}
	function calcularCasillas30a31():Boolean { 
		return this.ctx.oficial_calcularCasillas30a31();
	}
	function calcularCasillas32a33():Boolean { 
		return this.ctx.oficial_calcularCasillas32a33();
	}
	function calcularCasillas34():Boolean { 
		return this.ctx.oficial_calcularCasillas34();
	}
	function calcularCasillas42():Boolean { 
		return this.ctx.oficial_calcularCasillas42();
	}
	function calcularCasillas43():Boolean { 
		return this.ctx.oficial_calcularCasillas43();
	}
	function calcularCasillas44():Boolean { 
		return this.ctx.oficial_calcularCasillas44();
	}
	function revisarFacturas():Boolean { 
		return this.ctx.oficial_revisarFacturas(); 
	}
	function dameTipoBienes(idAsiento:String):String { 
		return this.ctx.oficial_dameTipoBienes(idAsiento); 
	}
	function actualizarCasilla303Partida(idPartida:String, casilla303:String):Boolean { 
		return this.ctx.oficial_actualizarCasilla303Partida(idPartida, casilla303); 
	}
	function conectarDetalles() { 
		return this.ctx.oficial_conectarDetalles(); 
	}
	function partidasDatosRG1() { 
		return this.ctx.oficial_partidasDatosRG1(); 
	}
	function partidasDatosRG2() { 
		return this.ctx.oficial_partidasDatosRG2(); 
	}
	function partidasDatosRG3() { 
		return this.ctx.oficial_partidasDatosRG3(); 
	}
	function partidasDatosRE1() { 
		return this.ctx.oficial_partidasDatosRE1(); 
	}
	function partidasDatosRE2() { 
		return this.ctx.oficial_partidasDatosRE2(); 
	}
	function partidasDatosRE3() { 
		return this.ctx.oficial_partidasDatosRE3(); 
	}
	function partidasDatosIVADevAI() { 
		return this.ctx.oficial_partidasDatosIVADevAI(); 
	}
	function partidasDatosIVADedOIBC() { 
		return this.ctx.oficial_partidasDatosIVADedOIBC(); 
	}
	function partidasDatosIVADedOIBI() { 
		return this.ctx.oficial_partidasDatosIVADedOIBI(); 
	}
	function partidasDatosIVADedImBC() { 
		return this.ctx.oficial_partidasDatosIVADedImBC(); 
	}
	function partidasDatosIVADedImBI() { 
		return this.ctx.oficial_partidasDatosIVADedImBI(); 
	}
	function partidasDatosIVADedAIBC() { 
		return this.ctx.oficial_partidasDatosIVADedAIBC(); 
	}
	function partidasDatosIVADedAIBI() { 
		return this.ctx.oficial_partidasDatosIVADedAIBI(); 
	}
	function partidasDatosIVAComRe() { 
		return this.ctx.oficial_partidasDatosIVAComRe(); 
	}
	function partidasDatosEUE() { 
		return this.ctx.oficial_partidasDatosEUE();
	}
	function partidasDatosRXP() { 
		return this.ctx.oficial_partidasDatosRXP();
	}
	function partidasDatosREX() { 
		return this.ctx.oficial_partidasDatosREX();
	}
	function mostrarPartidas(filtro:String):Boolean { 
		return this.ctx.oficial_mostrarPartidas(filtro); 
	}
	function limpiarValores():Boolean { 
		return this.ctx.oficial_limpiarValores(); 
	}
	function actualizarWhereFechas() { 
		return this.ctx.oficial_actualizarWhereFechas(); 
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
/** \C El ejercicio por defecto al crear un nuevo modelo es el ejercicio marcado como actual en el formulario de empresa
\end */
function interna_init() 
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this.child("pbnCalcularValores"), "clicked()", this, "iface.calcularValores()");
	
	if (cursor.modeAccess() == cursor.Insert) {
		this.child("fdbCodEjercicio").setValue(flfactppal.iface.pub_ejercicioActual());
		var municipio:String = util.sqlSelect("co_datosfiscales", "municipio", "1 = 1");
		if (municipio) {
			this.child("fdbLocalidadFirma").setValue(municipio);
		}
	}
	
	this.iface.habilitarPeriodo();
	this.iface.conectarDetalles();
	this.iface.actualizarWhereFechas();
// 	this.iface.bloqueoPago = false;
}

function interna_calculateField( fN ):String
{
	var valor:String;
	var cursor:FLSqlCursor = this.cursor();
	var fecha:Number = parseFloat(cursor.valueBuffer("fechainicio"));
	this.iface.ejercicio = fecha.toString().left(4); 
	switch ( this.iface.ejercicio ) {
		default: {
			valor = this.iface.calculateField2009(fN);
			break;
		}
	}
	return valor;
}

function interna_calculateField2009( fN ):String
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var valor;
	switch ( fN ) {
		case "cuotadevtotal": {
			valor = parseFloat(cursor.valueBuffer("cuotarg1")) + parseFloat(cursor.valueBuffer("cuotarg2")) + parseFloat(cursor.valueBuffer("cuotarg3")) + parseFloat(cursor.valueBuffer("cuotare1")) + parseFloat(cursor.valueBuffer("cuotare2")) + parseFloat(cursor.valueBuffer("cuotare3")) + parseFloat(cursor.valueBuffer("cuotaai"));
			break;
		}
		case "cuotadedtotal": {
			valor = parseFloat(cursor.valueBuffer("cuotadedoibc")) + parseFloat(cursor.valueBuffer("cuotadedoibi")) + parseFloat(cursor.valueBuffer("cuotadedimbc")) + parseFloat(cursor.valueBuffer("cuotadedimbi")) + parseFloat(cursor.valueBuffer("cuotadedaibc")) + parseFloat(cursor.valueBuffer("cuotadedaibi")) + parseFloat(cursor.valueBuffer("cuotacomre")) + parseFloat(cursor.valueBuffer("cuotaregin")) + parseFloat(cursor.valueBuffer("cuotaregapli"));
			break;
		}
		case "cuotadif": {
			valor = parseFloat(cursor.valueBuffer("cuotadevtotal")) - parseFloat(cursor.valueBuffer("cuotadedtotal"));
			break;
		}
		case "cuotaestado": {
			valor = parseFloat(cursor.valueBuffer("cuotadif")) * parseFloat(cursor.valueBuffer("porcuotaestado")) / 100;
			break;
		}
		case "cuotaresultado": {
			valor = parseFloat(cursor.valueBuffer("cuotaestado")) - parseFloat(cursor.valueBuffer("cuotaanterior")) + parseFloat(cursor.valueBuffer("sujetospasivos"));
			break;
		}
		case "resliquid": {
			valor = parseFloat(cursor.valueBuffer("cuotaresultado")) - parseFloat(cursor.valueBuffer("adeducircompl"));
			break;
		}
		case "importei": {
			var resLiquid:Number = parseFloat(cursor.valueBuffer("resliquid"));
			if (resLiquid > 0) {
				valor = resLiquid
			} else {
				valor = 0;
			}
			break;
		}
		case "imported": {
			var resLiquid:Number = parseFloat(cursor.valueBuffer("resliquid"));
			if (resLiquid < 0) {
				valor = (resLiquid * -1) - parseFloat(cursor.valueBuffer("impcompensar"));
			} else {
				valor = 0;
			}
			break;
		}
// 		case "cuotaanterior":
			/** \C --cuotaanterior--: Suma de los saldos de las partidas correspondientes a la subcuenta de IVA compensado seleccionada, correspondientes al ejercicio seleccionado y anteriores a la fecha de fin del trimestre o período seleccionado
			\end */
// 			var fechaFin:Date = this.child("fdbFechaFin").value();
// 			var codEjercicio:String = this.child("fdbCodEjercicio").value();
// 			var idSubcuenta:Number = this.child("fdbIdSubcuentaCA").value();
// 			var q:FLSqlQuery = new FLSqlQuery();
// 			q.setTablesList("co_cuentas,co_subcuentas,co_asientos,co_partidas");
// 			q.setSelect("SUM(p.debe) - SUM(p.haber)");
// 			q.setFrom("co_cuentas c INNER JOIN co_subcuentas s ON c.idcuenta = s.idcuenta" +
// 					" INNER JOIN co_partidas p ON s.idsubcuenta = p.idsubcuenta" +
// 					" INNER JOIN co_asientos a ON p.idasiento = a.idasiento");
// 			q.setWhere("c.codejercicio = '" + codEjercicio + "'" +
// 					" AND a.fecha <= '" + fechaFin + "'" +
// 					" AND s.idsubcuenta = " + idSubcuenta);
// 			if (!q.exec()) return "";
// 			if (!q.first()) return "";
// 			valor = q.value(0);
// 			break;
			
// 		case "cuotarg1": 
// 			valor = parseFloat(this.child("fdbTipoRG0").value()) *
// 				parseFloat(this.child("fdbBaseImponibleRG0").value()) / 100;
// 			break;
// 		
// 		case "cuotarg2":
// 			valor = parseFloat(this.child("fdbTipoRG1").value()) *
// 				parseFloat(this.child("fdbBaseImponibleRG1").value()) / 100;
// 			break;
// 		
// 		case "cuotarg3":
// 			valor = parseFloat(this.child("fdbTipoRG2").value()) *
// 				parseFloat(this.child("fdbBaseImponibleRG2").value()) / 100;
// 			break;
// 			
// 		case "cuotare1":
// 			valor = parseFloat(this.child("fdbTipoRE0").value()) *
// 				parseFloat(this.child("fdbBaseImponibleRE0").value()) / 100;
// 			break;
// 		
// 		case "cuotare2":
// 			valor = parseFloat(this.child("fdbTipoRE1").value()) *
// 				parseFloat(this.child("fdbBaseImponibleRE1").value()) / 100;
// 			break;
// 		
// 		case "cuotare3":
// 			valor = parseFloat(this.child("fdbTipoRE2").value()) *
// 				parseFloat(this.child("fdbBaseImponibleRE2").value()) / 100;
// 			break;
		
		case "dcdev": {
			var entidad:String = cursor.valueBuffer("ctaentidaddev");
			var agencia:String = cursor.valueBuffer("ctaagenciadev");
			var cuenta:String = cursor.valueBuffer("cuentadev");
			if ( !entidad.isEmpty() && !agencia.isEmpty() && ! cuenta.isEmpty() && entidad.length == 4 && agencia.length == 4 && cuenta.length == 10 ) {
				var dc1:String = util.calcularDC(entidad + agencia);
				var dc2:String = util.calcularDC(cuenta);
				valor = dc1 + dc2;
			}
			break;
		}
		case "dcingreso": {
			var entidad:String = cursor.valueBuffer("ctaentidadingreso");
			var agencia:String = cursor.valueBuffer("ctaagenciaingreso");
			var cuenta:String = cursor.valueBuffer("cuentaingreso");
			if ( !entidad.isEmpty() && !agencia.isEmpty() && ! cuenta.isEmpty() && entidad.length == 4 && agencia.length == 4 && cuenta.length == 10 ) {
				var dc1:String = util.calcularDC(entidad + agencia);
				var dc2:String = util.calcularDC(cuenta);
				valor = dc1 + dc2;
			}
			break;
		}
			
// 		case "pagoefectivo": 
// 			if (cursor.valueBuffer("pagocuenta"))
// 				valor = false;
// 			break;
// 		
// 		case "pagocuenta": 
// 			if (cursor.valueBuffer("pagoefectivo"))
// 				valor = false;
// 			break;
	}
	return valor;
}

function interna_validateForm():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

/** \C Las fechas que definen el período deben ser coherentes (fin > inicio) y pertenecer al ejercicio seleccionado
\end */
	if (!this.iface.comprobarFechas()) {
		return false;
	}

/// A petición de Barnaplant, porque están inscritos en el registro de devolución mensual
// 	if (cursor.valueBuffer("idtipodec") == "D") {
// 		if (cursor.valueBuffer("tipoperiodo") == "Trimestre" && cursor.valueBuffer("trimestre") != "4T") {
// 			MessageBox.warning(util.translate("scripts", "Sólo puede marcar la declaración como A devolver (D) en el cuarto trimestre (4T)"), MessageBox.Ok, MessageBox.NoButton);
// 			return false;
// 		}
// 		if (cursor.valueBuffer("tipoperiodo") == "Mes" && cursor.valueBuffer("mes") != "Diciembre") {
// 			MessageBox.warning(util.translate("scripts", "Sólo puede marcar la declaración como A devolver (D) en el últim mes (Diciembre)"), MessageBox.Ok, MessageBox.NoButton);
// 			return false;
// 		}
// 	}

	return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_bufferChanged( fN ) 
{
	var cursor:FLSqlCursor = this.cursor();
	var fecha:Number = parseFloat(cursor.valueBuffer("fechainicio"));
	this.iface.ejercicio = fecha.toString().left(4); 
	switch ( this.iface.ejercicio ) {
		default: {
			this.iface.bufferChanged2009(fN);
			break;
		}
	}
}

function oficial_bufferChanged2009( fN ) 
{
	var cursor:FLSqlCursor = this.cursor();
	switch ( fN ) {
		case "cuotarg1":
		case "cuotarg2":
		case "cuotarg3":
		case "cuotare1":
		case "cuotare2":
		case "cuotare3":
		case "cuotaai": {
			this.child( "fdbCuotaDevTotal" ).setValue( this.iface.calculateField( "cuotadevtotal" ) );
			break;
		}
		case "cuotadedoibc":
		case "cuotadedoibi":
		case "cuotadedimbc":
		case "cuotadedimbi":
		case "cuotadedaibc":
		case "cuotadedaibi":
		case "cuotacomre":
		case "cuotaregin":
		case "cuotaregapli": {
			this.child( "fdbCuotaDedTotal" ).setValue( this.iface.calculateField( "cuotadedtotal" ) );
			break;
		}
		case "cuotadedtotal":
		case "cuotadevtotal": {
			this.child("fdbCuotaDif").setValue(this.iface.calculateField("cuotadif"));
			break;
		}
		case "cuotadif":
		case "porcuotaestado": {
			this.child("fdbCuotaEstado").setValue(this.iface.calculateField("cuotaestado"));
			break;
		}
		case "cuotaestado":
		case "cuotaanterior":
		case "sujetospasivos":{
			this.child("fdbCuotaResultado").setValue(this.iface.calculateField("cuotaresultado"));
			break;
		}
		case "cuotaresultado":
		case "adeducircompl":{
			this.child("fdbResultadoLiquidacion").setValue(this.iface.calculateField("resliquid"));
			break;
		}
		case "resliquid": {
			this.child("fdbImported").setValue(this.iface.calculateField("imported"));
			this.child("fdbImporteI").setValue(this.iface.calculateField("importei"));
			break;
		}
		case "impcompensar": {
			this.child("fdbImported").setValue(this.iface.calculateField("imported"));
			break;
		}
		case "fechainicio":
		case "fechafin": {
			this.iface.limpiarValores();
			break;
		}
		case "tipoperiodo": {
			this.iface.habilitarPeriodo();
			this.iface.establecerFechasPeriodo();
		}
		case "mes":
		case "trimestre": {
			this.iface.establecerFechasPeriodo();
			break;
		}
		case "codcuentaingreso":
		case "ctaentidadingreso":
		case "ctaagenciaingreso":
		case "cuentaingreso": {
			this.child("fdbDcIngreso").setValue(this.iface.calculateField("dcingreso"));
			break;
		}
		case "codcuentaingreso":
		case "ctaentidadingreso":
		case "ctaagenciaingreso":
		case "cuentaingreso": {
			this.child("fdbDcIngreso").setValue(this.iface.calculateField("dcingreso"));
			break;
		}
		case "codcuentadev":
		case "ctaentidaddev":
		case "ctaagenciadev":
		case "cuentadev": {
			this.child("fdbDcDev").setValue(this.iface.calculateField("dcdev"));
			break;
		}
	}
	return;

// 		case "baseimponiblerg1":
// 		case "tiporg1":
// 			this.child( "fdbCuotaRG0" ).setValue( this.iface.calculateField( "cuotarg1" ) );
// 			break;
// 			
// 		case "baseimponiblerg2":
// 		case "tiporg2":
// 			this.child( "fdbCuotaRG1" ).setValue( this.iface.calculateField( "cuotarg2" ) );
// 			break;
// 			
// 		case "baseimponiblerg3":
// 		case "tiporg3":
// 			this.child( "fdbCuotaRG2" ).setValue( this.iface.calculateField( "cuotarg3" ) );
// 			break;
// 			
// 		case "baseimponiblere1":
// 		case "tipore1":
// 			this.child( "fdbCuotaRE0" ).setValue( this.iface.calculateField( "cuotare1" ) );
// 			break;
// 			
// 		case "baseimponiblere2":
// 		case "tipore2":
// 			this.child( "fdbCuotaRE1" ).setValue( this.iface.calculateField( "cuotare2" ) );
// 			break;
// 			
// 		case "baseimponiblere3":
// 		case "tipore3":
// 			this.child( "fdbCuotaRE2" ).setValue( this.iface.calculateField( "cuotare3" ) );
// 			break;
// 			
// 		case "sujetospasivos":
// 		case "cuotaestado":
// 		case "cuotaanterior":
// 			this.child( "fdbCuotaResultado" ).setValue( this.iface.calculateField( "cuotaresultado" ) );
// 			break;
// 		
// 		case "cuotadedoi":
// 		case "cuotadedim":
// 		case "cuotadedai":
// 		case "cuotacomre":
// 		case "cuotaregin":
// 			this.child( "fdbCuotaDedTotal" ).setValue( this.iface.calculateField( "cuotadedtotal" ) );
// 			break;
// 		
// 		case "cuotadedtotal":
// 		case "cuotadevtotal":
// 			this.child( "fdbCuotaDif" ).setValue(this.iface.calculateField( "cuotadif" ));
// 			break;
// 	
// 		case "cuotadif":
// 		case "porcuotaestado":
// 			this.child( "fdbCuotaEstado" ).setValue(this.iface.calculateField( "cuotaestado" ));
// 			break;
// 	
// 		case "cuotaestado":
// 		case "cuotaanterior":
// 		case "sujetospasivos":
// 			this.child( "fdbCuotaResultado" ).setValue(this.iface.calculateField( "cuotaresultado" ));
// 			break;
// 	
// 		case "idsctacuotasanteriores":
// 			this.child( "fdbCuotaAnterior" ).setValue(this.iface.calculateField( "cuotaanterior" ));
// 			break;
// 	
// 		case "codejercicio":
// 			this.iface.borrarValores();
//  			this.iface.establecerFechasPeriodo();
// 			break;
// 	
// 		case "fechainicio":
// 		case "fechafin":
// 			this.iface.borrarValores();
// 			break;
// 			
// 		case "codcuentadev":
// 		case "ctaentidaddev":
// 		case "ctaagenciadev":
// 		case "cuentadev": 
// 			this.child("fdbDcDev").setValue(this.iface.calculateField("dcdev"));
// 			break;
// 			
// 		case "codcuentaingreso":
// 		case "ctaentidadingreso":
// 		case "ctaagenciaingreso":
// 		case "cuentaingreso": 
// 			this.child("fdbDcIngreso").setValue(this.iface.calculateField("dcingreso"));
// 			break;
// 			
// 		case "pagoefectivo": 
// 			if (!this.iface.bloqueoPago) {
// 				this.iface.bloqueoPago = true;
// 				this.child("fdbPagoCuenta").setValue(this.iface.calculateField("pagocuenta"));
// 				this.iface.bloqueoPago = false;
// 			}
// 			break;
// 			
// 		case "pagocuenta": 
// 			if (!this.iface.bloqueoPago) {
// 				this.iface.bloqueoPago = true;
// 				this.child("fdbPagoEfectivo").setValue(this.iface.calculateField("pagoefectivo"));
// 				this.iface.bloqueoPago = false;
// 			}
// 			break;
// 		case "cuotaregapli": {
// 			var ejercicio:Number = parseFloat(cursor.valueBuffer("fechainicio"));
// 			var temp:Number = ejercicio.toString().left(4); 
// 			if (temp <= 2006)
// 				break;
// 			else 
// 				this.child("fdbCuotaDedTotal").setValue(this.iface.calculateField("cuotadedtotal" ) );
// 			break;
// 		}
// 	}
}

/** \D Calcula algunas de las casillas del modelo a partir de los contenidos de la base de datos de contabilidad
\end */
function oficial_calcularValores()
{
	var util:FLUtil = new FLUtil;

// 	if (!this.iface.cargarSubcuentas()) {
// 		MessageBox.warning(util.translate("scripts", "Ha habido un error al cargar los datos de subcuentas de I.V.A.\nEl modelo no puede calcularse"), MessageBox.Ok, MessageBox.NoButton);
// 		return false;
// 	}
	if (!this.iface.limpiarValores()) {
		return false;
	}

	if (!this.iface.comprobarFechas()) {
		return false;
	}

	if (!this.iface.revisarFacturas()) {
		return false;
	}

	if (!this.iface.calcularCasillas01a09()) {
		return false;
	}

	if (!this.iface.calcularCasillas10a18()) {
		return false;
	}

	if (!this.iface.calcularCasillas19a20()) {
		return false;
	}

	if (!this.iface.calcularCasillas22a23()) {
		return false;
	}

	if (!this.iface.calcularCasillas24a25()) {
		return false;
	}

	if (!this.iface.calcularCasillas26a27()) {
		return false;
	}

	if (!this.iface.calcularCasillas28a29()) {
		return false;
	}
	
	if (!this.iface.calcularCasillas30a31()) {
		return false;
	}
	
	if (!this.iface.calcularCasillas32a33()) {
		return false;
	}

	if (!this.iface.calcularCasillas34()) {
		return false;
	}

	if (!this.iface.calcularCasillas42()) {
		return false;
	}

	if (!this.iface.calcularCasillas43()) {
		return false;
	}

	if (!this.iface.calcularCasillas44()) {
		return false;
	}

	return;
}

function oficial_calcularCasillas01a09():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var porcentajes:String = "";
	var arrayPorcentajes:Array;
	var baseImponible:Number = 0;
	var iva:Number = 0;
	var cuota:Number = 0;
	var i:Number = 1;
	
	var qryPartidas:FLSqlQuery = new FLSqlQuery();
	qryPartidas.setTablesList("co_partidas");
	qryPartidas.setSelect("SUM(p.baseimponible), p.iva, SUM(p.haber - p.debe)");
	qryPartidas.setFrom("co_asientos a INNER JOIN co_partidas p ON p.idasiento = a.idasiento");
	qryPartidas.setForwardOnly(true);
	
	var c1:Number;
	var c2:Number;
	var c3:Number;
	for(var v=0;v<7;v=v+3) {
		// Primera vuelta casillas 1 2 3
		// Segunda vuelta casillas 4 5 6
		// Tercera vuelta casillas 7 8 9
		c1=1 + v;
		c2=2 + v;
		c3=3 + v;
		arrayPorcentajes = [];
		porcentajes = util.sqlSelect("co_datosfiscales", "porcentajes"+ c1 + c2 + c3, "1 = 1");
		if(!porcentajes || porcentajes == "")
			continue;
		
		arrayPorcentajes = porcentajes.split(",");
		porcentajes = "";
		for(var p=0;p<arrayPorcentajes.length;p++) {
			if(porcentajes != "")
				porcentajes += ",";
			porcentajes += "'" + arrayPorcentajes[p] + "'";
		}
		if(porcentajes || porcentajes != "") {
			qryPartidas.setWhere(this.iface.whereFechas_ + " AND p.casilla303 = '[01]-[09]' AND p.iva IN (" + porcentajes + ") GROUP BY p.iva ORDER BY p.iva");
			if (!qryPartidas.exec()) {
				return false;
			}
			debug(qryPartidas.sql());
	// 		if (qryPartidas.size() == 0) {
	// 			MessageBox.warning(util.translate("scripts", "Error al obtener datos de I.V.A. del Régimen general:\nSe ha encontrado más de tres tipos de I.V.A."), MessageBox.Ok, MessageBox.NoButton);
	// 			return false;
	// 		}
			baseImponible = 0;
			cuota = 0;
			iva = 0;
			while(qryPartidas.next()) {
				baseImponible += parseFloat(qryPartidas.value("SUM(p.baseimponible)"));
				cuota += parseFloat(qryPartidas.value("SUM(p.haber - p.debe)"));
			}
			iva = cuota/baseImponible*100;
			iva = util.roundFieldValue(iva, "co_partidas", "iva");

			this.child("fdbBaseImponibleRG" + i.toString()).setValue(baseImponible);
			this.child("fdbTipoRG" + i.toString()).setValue(iva);
			this.child("fdbCuotaRG" + i.toString()).setValue(cuota);
			i++;
		}
	}
	return true;
}

function oficial_calcularCasillas10a18():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var qryPartidas:FLSqlQuery = new FLSqlQuery();
	qryPartidas.setTablesList("co_partidas");
	qryPartidas.setSelect("SUM(p.baseimponible), p.recargo, SUM(p.haber - p.debe)");
	qryPartidas.setFrom("co_asientos a INNER JOIN co_partidas p ON p.idasiento = a.idasiento");
	qryPartidas.setWhere(this.iface.whereFechas_ + " AND p.casilla303 = '[10]-[18]' AND p.recargo <> 0 GROUP BY p.recargo ORDER BY p.recargo ");
	qryPartidas.setForwardOnly(true);
	if (!qryPartidas.exec()) {
		return false;
	}
	if (qryPartidas.size() > 3) {
		MessageBox.warning(util.translate("scripts", "Error al obtener datos de Recargo de equivalencia del Régimen general:\nSe ha encontrado más de tres tipos de recargo"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var baseImponible:Number = 0;
	var re:Number = 0;
	var cuota:Number = 0;
	var i:Number = 1;
	while (qryPartidas.next()) {
		baseImponible = qryPartidas.value("SUM(p.baseimponible)");
		cuota = qryPartidas.value("SUM(p.haber - p.debe)");
		re = qryPartidas.value("p.recargo");
		this.child("fdbBaseImponibleRE" + i.toString()).setValue(baseImponible);
		this.child("fdbTipoRE" + i.toString()).setValue(re);
		this.child("fdbCuotaRE" + i.toString()).setValue(cuota);
		i++;
	}
	
	return true;
}

function oficial_calcularCasillas19a20():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var qryPartidas:FLSqlQuery = new FLSqlQuery();
	qryPartidas.setTablesList("co_partidas");
	qryPartidas.setSelect("SUM(p.baseimponible), SUM(p.haber - p.debe)");
	qryPartidas.setFrom("co_asientos a INNER JOIN co_partidas p ON p.idasiento = a.idasiento");
	qryPartidas.setWhere(this.iface.whereFechas_ + " AND p.casilla303 = '[19]-[20]'");
	qryPartidas.setForwardOnly(true);
	if (!qryPartidas.exec()) {
		return false;
	}
	
	var baseImponible:Number = 0;
	var cuota:Number = 0;
	if (qryPartidas.first()) {
		baseImponible = qryPartidas.value("SUM(p.baseimponible)");
		cuota = qryPartidas.value("SUM(p.haber - p.debe)");
	}
	this.child("fdbBaseImponibleAI").setValue(baseImponible);
	this.child("fdbCuotaAI").setValue(cuota);
	
	return true;
}

function oficial_calcularCasillas22a23():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var qryPartidas:FLSqlQuery = new FLSqlQuery();
	qryPartidas.setTablesList("co_partidas");
	qryPartidas.setSelect("SUM(p.baseimponible), SUM(p.debe - p.haber)");
	qryPartidas.setFrom("co_asientos a INNER JOIN co_partidas p ON p.idasiento = a.idasiento");
	qryPartidas.setWhere(this.iface.whereFechas_ + " AND p.casilla303 = '[22]-[23]'");
	qryPartidas.setForwardOnly(true);
	if (!qryPartidas.exec()) {
		return false;
	}
	
	var baseImponible:Number = 0;
	var cuota:Number = 0;
	if (qryPartidas.first()) {
		baseImponible = qryPartidas.value("SUM(p.baseimponible)");
		cuota = qryPartidas.value("SUM(p.debe - p.haber)");
	}
	this.child("fdbBaseDedoibc").setValue(baseImponible);
	this.child("fdbCuotaDedOI").setValue(cuota);
	
	return true;
}

function oficial_calcularCasillas24a25():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var qryPartidas:FLSqlQuery = new FLSqlQuery();
	qryPartidas.setTablesList("co_partidas");
	qryPartidas.setSelect("SUM(p.baseimponible), SUM(p.debe - p.haber)");
	qryPartidas.setFrom("co_asientos a INNER JOIN co_partidas p ON p.idasiento = a.idasiento");
	qryPartidas.setWhere(this.iface.whereFechas_ + " AND p.casilla303 = '[24]-[25]'");
	qryPartidas.setForwardOnly(true);
	if (!qryPartidas.exec()) {
		return false;
	}
	
	var baseImponible:Number = 0;
	var cuota:Number = 0;
	if (qryPartidas.first()) {
		baseImponible = qryPartidas.value("SUM(p.baseimponible)");
		cuota = qryPartidas.value("SUM(p.debe - p.haber)");
	}
	this.child("fdbBaseDedoibi").setValue(baseImponible);
	this.child("fdbCuotaDedIm").setValue(cuota);
	
	return true;
}

function oficial_calcularCasillas26a27():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var qryPartidas:FLSqlQuery = new FLSqlQuery();
	qryPartidas.setTablesList("co_partidas");
	qryPartidas.setSelect("SUM(p.baseimponible), SUM(p.debe - p.haber)");
	qryPartidas.setFrom("co_asientos a INNER JOIN co_partidas p ON p.idasiento = a.idasiento");
	qryPartidas.setWhere(this.iface.whereFechas_ + " AND p.casilla303 = '[26]-[27]'");
	qryPartidas.setForwardOnly(true);
	if (!qryPartidas.exec()) {
		return false;
	}
	
	var baseImponible:Number = 0;
	var cuota:Number = 0;
	if (qryPartidas.first()) {
		baseImponible = qryPartidas.value("SUM(p.baseimponible)");
		cuota = qryPartidas.value("SUM(p.debe - p.haber)");
	}
	this.child("fdbBaseDedimc").setValue(baseImponible);
	this.child("fdbCuotaDedimbc").setValue(cuota);
	
	return true;
}

function oficial_calcularCasillas28a29():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var qryPartidas:FLSqlQuery = new FLSqlQuery();
	qryPartidas.setTablesList("co_partidas");
	qryPartidas.setSelect("SUM(p.baseimponible), SUM(p.debe - p.haber)");
	qryPartidas.setFrom("co_asientos a INNER JOIN co_partidas p ON p.idasiento = a.idasiento");
	qryPartidas.setWhere(this.iface.whereFechas_ + " AND p.casilla303 = '[28]-[29]'");
	qryPartidas.setForwardOnly(true);
	if (!qryPartidas.exec()) {
		return false;
	}
	
	var baseImponible:Number = 0;
	var cuota:Number = 0;
	if (qryPartidas.first()) {
		baseImponible = qryPartidas.value("SUM(p.baseimponible)");
		cuota = qryPartidas.value("SUM(p.debe - p.haber)");
	}
	this.child("fdbBaseDedimbi").setValue(baseImponible);
	this.child("fdbCuotaDedimbi").setValue(cuota);
	
	return true;
}

function oficial_calcularCasillas30a31():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var qryPartidas:FLSqlQuery = new FLSqlQuery();
	qryPartidas.setTablesList("co_partidas");
	qryPartidas.setSelect("SUM(p.baseimponible), SUM(p.debe - p.haber)");
	qryPartidas.setFrom("co_asientos a INNER JOIN co_partidas p ON p.idasiento = a.idasiento");
	qryPartidas.setWhere(this.iface.whereFechas_ + " AND p.casilla303 = '[30]-[31]'");
	qryPartidas.setForwardOnly(true);
	if (!qryPartidas.exec()) {
		return false;
	}
	
	var baseImponible:Number = 0;
	var cuota:Number = 0;
	if (qryPartidas.first()) {
		baseImponible = qryPartidas.value("SUM(p.baseimponible)");
		cuota = qryPartidas.value("SUM(p.debe - p.haber)");
	}
	this.child("fdbBaseDedaibc").setValue(baseImponible);
	this.child("fdbCuotaDedaibc").setValue(cuota);
	
	return true;
}

function oficial_calcularCasillas32a33():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var qryPartidas:FLSqlQuery = new FLSqlQuery();
	qryPartidas.setTablesList("co_partidas");
	qryPartidas.setSelect("SUM(p.baseimponible), SUM(p.debe - p.haber)");
	qryPartidas.setFrom("co_asientos a INNER JOIN co_partidas p ON p.idasiento = a.idasiento");
	qryPartidas.setWhere(this.iface.whereFechas_ + " AND p.casilla303 = '[32]-[33]'");
	qryPartidas.setForwardOnly(true);
	if (!qryPartidas.exec()) {
		return false;
	}
	
	var baseImponible:Number = 0;
	var cuota:Number = 0;
	if (qryPartidas.first()) {
		baseImponible = qryPartidas.value("SUM(p.baseimponible)");
		cuota = qryPartidas.value("SUM(p.debe - p.haber)");
	}
	this.child("fdbBaseDedaibi").setValue(baseImponible);
	this.child("fdbCuotaDedaibi").setValue(cuota);
	
	return true;
}

function oficial_calcularCasillas34():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var qryPartidas:FLSqlQuery = new FLSqlQuery();
	qryPartidas.setTablesList("co_partidas");
	qryPartidas.setSelect("SUM(p.baseimponible), SUM(p.debe - p.haber)");
	qryPartidas.setFrom("co_asientos a INNER JOIN co_partidas p ON p.idasiento = a.idasiento");
	qryPartidas.setWhere(this.iface.whereFechas_ + " AND p.casilla303 = '[34]'");
	qryPartidas.setForwardOnly(true);
	if (!qryPartidas.exec()) {
		return false;
	}
	
	var baseImponible:Number = 0;
	var cuota:Number = 0;
	if (qryPartidas.first()) {
		baseImponible = qryPartidas.value("SUM(p.baseimponible)");
		cuota = qryPartidas.value("SUM(p.debe - p.haber)");
	}
	this.child("fdbCuotaComRE").setValue(cuota);
	
	return true;
}

function oficial_calcularCasillas42():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var qryPartidas:FLSqlQuery = new FLSqlQuery();
	qryPartidas.setTablesList("co_partidas");
	qryPartidas.setSelect("SUM(p.baseimponible), SUM(p.debe - p.haber)");
	qryPartidas.setFrom("co_asientos a INNER JOIN co_partidas p ON p.idasiento = a.idasiento");
	qryPartidas.setWhere(this.iface.whereFechas_ + " AND p.casilla303 = '[42]'");
	qryPartidas.setForwardOnly(true);
	if (!qryPartidas.exec()) {
		return false;
	}
	
	var baseImponible:Number = 0;
	var cuota:Number = 0;
	if (qryPartidas.first()) {
		baseImponible = qryPartidas.value("SUM(p.baseimponible)");
		cuota = qryPartidas.value("SUM(p.debe - p.haber)");
	}
	this.child("fdbEntregasI").setValue(baseImponible);
	
	return true;
}

function oficial_calcularCasillas43():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var qryPartidas:FLSqlQuery = new FLSqlQuery();
	qryPartidas.setTablesList("co_partidas");
	qryPartidas.setSelect("SUM(p.baseimponible), SUM(p.debe - p.haber)");
	qryPartidas.setFrom("co_asientos a INNER JOIN co_partidas p ON p.idasiento = a.idasiento");
	qryPartidas.setWhere(this.iface.whereFechas_ + " AND p.casilla303 = '[43]'");
	qryPartidas.setForwardOnly(true);
	if (!qryPartidas.exec()) {
		return false;
	}
	
	var baseImponible:Number = 0;
	var cuota:Number = 0;
	if (qryPartidas.first()) {
		baseImponible = qryPartidas.value("SUM(p.baseimponible)");
		cuota = qryPartidas.value("SUM(p.debe - p.haber)");
	}
	this.child("fdbExportaciones").setValue(baseImponible);
	
	return true;
}

function oficial_calcularCasillas44():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var qryPartidas:FLSqlQuery = new FLSqlQuery();
	qryPartidas.setTablesList("co_partidas");
	qryPartidas.setSelect("SUM(p.baseimponible), SUM(p.debe - p.haber)");
	qryPartidas.setFrom("co_asientos a INNER JOIN co_partidas p ON p.idasiento = a.idasiento");
	qryPartidas.setWhere(this.iface.whereFechas_ + " AND p.casilla303 = '[44]'");
	qryPartidas.setForwardOnly(true);
	if (!qryPartidas.exec()) {
		return false;
	}
	
	var baseImponible:Number = 0;
	var cuota:Number = 0;
	if (qryPartidas.first()) {
		baseImponible = qryPartidas.value("SUM(p.baseimponible)");
		cuota = qryPartidas.value("SUM(p.debe - p.haber)");
	}
	this.child("fdbNoSujetas").setValue(baseImponible);
	
	return true;
}
/** \D Establece las fechas de inicio y fin de trimestre en función del trimestre seleccionado
\end */
function oficial_establecerFechasPeriodo()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var fechaInicio:Date;
	var fechaFin:Date;
	var codEjercicio:String = this.child("fdbCodEjercicio").value();
	var inicioEjercicio = util.sqlSelect("ejercicios", "fechainicio", 
		"codejercicio = '" + codEjercicio + "'");
		
	if (!inicioEjercicio) {
		return false;
	}
	
	fechaInicio.setYear(inicioEjercicio.getYear());
	fechaFin.setYear(inicioEjercicio.getYear());
	fechaInicio.setDate(1);
	
debug(cursor.valueBuffer("tipoperiodo") + " " + cursor.valueBuffer("trimestre"));
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
			switch (cursor.valueBuffer("mes")) {
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
				default: {
					fechaInicio = false;
				}
			}
			break;
		}
	}
	
	if (fechaInicio) {
debug("Fechainicio = " + fechaInicio);
		this.child("fdbFechaInicio").setValue(fechaInicio);
		this.child("fdbFechaFin").setValue(fechaFin);
	} else {
debug("!Fechainicio");
		cursor.setNull("fechainicio");
		cursor.setNull("fechafin");
	}
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

function oficial_habilitarPeriodo()
{
	var cursor:FLSqlCursor = this.cursor();

	if (cursor.valueBuffer("tipoperiodo") == "Mes") {
		this.child("fdbMes").setShowAlias(true);
		this.child("fdbMes").setShowEditor(true);
		this.child("fdbTrimestre").setShowAlias(false);
		this.child("fdbTrimestre").setShowEditor(false);
	} else {
		this.child("fdbTrimestre").setShowAlias(true);
		this.child("fdbTrimestre").setShowEditor(true);
		this.child("fdbMes").setShowAlias(false);
		this.child("fdbMes").setShowEditor(false);
	}
}

function oficial_revisarFacturas():Boolean
{
	this.iface.actualizarWhereFechas();
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var fechaDesde:String = this.child("fdbFechaInicio").value();
	var fechaHasta:String = this.child("fdbFechaFin").value();
	var codEjercicio:String = this.child("fdbCodEjercicio").value();

	var whereFacturas:String = "a.codejercicio = '" + codEjercicio + "' AND a.fecha BETWEEN '" + fechaDesde + "' AND '" + fechaHasta + "' AND excluir303 <> true";
	var qryFacturasCli:FLSqlQuery = new FLSqlQuery();
	with (qryFacturasCli) {
		setTablesList("clientes,facturascli,co_asientos,co_partidas,co_subcuentas");
		setSelect("p.idpartida");
		setFrom("facturascli f INNER JOIN co_asientos a ON f.idasiento = a.idasiento INNER JOIN co_partidas p ON a.idasiento = p.idasiento INNER JOIN co_subcuentas s ON p.idsubcuenta = s.idsubcuenta");
		setWhere(whereFacturas + " GROUP BY p.idpartida");
		setForwardOnly(true);
	}
debug(qryFacturasCli.sql());
	if (!qryFacturasCli.exec()) {
		return false;
	}

	var totalPasos:Number = qryFacturasCli.size();
	var paso:Number = 0;
	util.createProgressDialog(util.translate("scripts", "Limpiando partidas de facturas de cliente"), totalPasos);
	while (qryFacturasCli.next()) {
		util.setProgress(++paso);
		if (!this.iface.actualizarCasilla303Partida(qryFacturasCli.value("p.idpartida"), "NULL")) {
			util.destroyProgressDialog();
			return false;
		}
	}
	util.destroyProgressDialog();
	
	with (qryFacturasCli) {
		setSelect("p.idpartida, p.codsubcuenta, s.idcuentaesp");
		setWhere(whereFacturas);
	}
debug(qryFacturasCli.sql());
	if (!qryFacturasCli.exec()) {
		return false;
	}
	totalPasos = qryFacturasCli.size();
	paso = 0;
	util.createProgressDialog(util.translate("scripts", "Procesando facturas de cliente"), totalPasos);
	
	var idCuentaEsp:String;
	var casilla:String;
	var codSubcuenta:String;
	while (qryFacturasCli.next()) {
		util.setProgress(++paso);
		codSubcuenta = qryFacturasCli.value("p.codsubcuenta");
		idCuentaEsp = qryFacturasCli.value("s.idcuentaesp");
debug("codSubcuenta = " + codSubcuenta + "  idCuentaEsp = " + idCuentaEsp);
		switch (idCuentaEsp) {
			case "IVAREP": {
				casilla = "[01]-[09]";
				break;
			}
			case "IVARRE":
			case "IVAACR": {
				casilla = "[10]-[18]";
				break;
			}
			case "IVAEUE": {
				casilla = "[42]";
				break;
			}
			case "IVARXP": {
				casilla = "[43]";
				break;
			}
			case "IVAREX": {
				casilla = "[44]";
				break;
			}
			default: {
				continue;
			}
		}

		if (!this.iface.actualizarCasilla303Partida(qryFacturasCli.value("p.idpartida"), casilla)) {
			util.destroyProgressDialog();
			return false;
		}
	}
	util.destroyProgressDialog();

	var qryFacturasProv:FLSqlQuery = new FLSqlQuery();
	with (qryFacturasProv) {
		setTablesList("clientes,facturascli,co_asientos,co_partidas,co_subcuentas");
		setSelect("p.idpartida");
		setFrom("facturasprov f INNER JOIN co_asientos a ON f.idasiento = a.idasiento INNER JOIN co_partidas p ON a.idasiento = p.idasiento INNER JOIN co_subcuentas s ON p.idsubcuenta = s.idsubcuenta");
		setWhere(whereFacturas + " GROUP BY p.idpartida");
		setForwardOnly(true);
	}

	if (!qryFacturasProv.exec()) {
		return false;
	}

	totalPasos = qryFacturasProv.size();
	paso = 0;
	util.createProgressDialog(util.translate("scripts", "Limpiando partidas de facturas de proveedor"), totalPasos);
	while (qryFacturasProv.next()) {
		util.setProgress(++paso);
		if (!this.iface.actualizarCasilla303Partida(qryFacturasProv.value("p.idpartida"), "NULL")) {
			util.destroyProgressDialog();
			return false;
		}
	}
	util.destroyProgressDialog();
	

	with (qryFacturasProv) {
		setSelect("p.idasiento, p.idpartida, p.codsubcuenta, s.idcuentaesp, f.codigo");
		setWhere(whereFacturas);
	}
debug(qryFacturasProv.sql());

	if (!qryFacturasProv.exec()) {
		return false;
	}
	var casilla:String;
	var codSubcuenta:String;
	totalPasos = qryFacturasProv.size();
	paso = 0;
	util.createProgressDialog(util.translate("scripts", "Procesando facturas de proveedor"), totalPasos);
	while (qryFacturasProv.next()) {
		util.setProgress(++paso);
		codSubcuenta = qryFacturasProv.value("p.codsubcuenta");
		idCuentaEsp = qryFacturasProv.value("s.idcuentaesp");
		switch (idCuentaEsp) {
			case "IVARUE": {
				casilla = "[19]-[20]";
				break;
			}
			case "IVASOP": {
				var tipoBienes:String = this.iface.dameTipoBienes(qryFacturasProv.value("p.idasiento"));
				if (!tipoBienes) {
					util.destroyProgressDialog();
					return false;
				}
				switch (tipoBienes) {
					case "corrientes": {
						casilla = "[22]-[23]";
						break;
					}
					case "inversion": {
						casilla = "[24]-[25]";
						break;
					}
					case "indefinido": {
						MessageBox.warning(util.translate("scripts", "No se ha podido determinar si la factura %1 corresponde a la compra de bienes corrientes o de inversión.\nLa factura no será incluida de forma automática en el modelo").arg(qryFacturasProv.value("f.codigo")), MessageBox.Ok, MessageBox.NoButton);
						continue;
					}
				}
				break;
			}
			case "IVASIM": {
				var tipoBienes:String = this.iface.dameTipoBienes(qryFacturasProv.value("p.idasiento"));
				if (!tipoBienes) {
					util.destroyProgressDialog();
					return false;
				}
				switch (tipoBienes) {
					case "corrientes": {
						casilla = "[26]-[27]";
						break;
					}
					case "inversion": {
						casilla = "[28]-[29]";
						break;
					}
					case "indefinido": {
						MessageBox.warning(util.translate("scripts", "No se ha podido determinar si la factura %1 corresponde a la compra de bienes corrientes o de inversión.\nLa factura no será incluida de forma automática en el modelo").arg(qryFacturasProv.value("f.codigo")), MessageBox.Ok, MessageBox.NoButton);
						continue;
					}
				}
				break;
			}
			case "IVASUE": {
				var tipoBienes:String = this.iface.dameTipoBienes(qryFacturasProv.value("p.idasiento"));
				if (!tipoBienes) {
					util.destroyProgressDialog();
					return false;
				}
				switch (tipoBienes) {
					case "corrientes": {
						casilla = "[30]-[31]";
						break;
					}
					case "inversion": {
						casilla = "[32]-[33]";
						break;
					}
					case "indefinido": {
						MessageBox.warning(util.translate("scripts", "No se ha podido determinar si la factura %1 corresponde a la compra de bienes corrientes o de inversión.\nLa factura no será incluida de forma automática en el modelo").arg(qryFacturasProv.value("f.codigo")), MessageBox.Ok, MessageBox.NoButton);
						continue;
					}
				}
				break;
			}
			case "IVASRA": {
				casilla = "[34]";
				break;
			}
			default: {
				continue;
			}
		}

		if (!this.iface.actualizarCasilla303Partida(qryFacturasProv.value("p.idpartida"), casilla)) {
			util.destroyProgressDialog();
			return false;
		}
	}
	util.destroyProgressDialog();

	return true;
}

function oficial_dameTipoBienes(idAsiento:String):String
{
	var util:FLUtil = new FLUtil;

	var qryTB:FLSqlQuery = new FLSqlQuery;
	qryTB.setTablesList("co_partidas");
	qryTB.setSelect("codsubcuenta");
	qryTB.setFrom("co_partidas");
	qryTB.setWhere("idasiento = " + idAsiento);
	qryTB.setForwardOnly(true);
	if (!qryTB.exec()) {
		return false;
	}
	var corrientes:Boolean = false;
	var inversion:Boolean = false;
	var codSubcuenta:String;
	while (qryTB.next()) {
		codSubcuenta = qryTB.value("codsubcuenta");
		if (codSubcuenta.toString().startsWith("5") || codSubcuenta.toString().startsWith("6")) {
			corrientes = true;
		} else if (codSubcuenta.toString().startsWith("2")) {
			inversion = true;
		}
	}
	var valor:String = "indefinido";
	if (corrientes && !inversion) {
		valor = "corrientes";
	} else if (!corrientes && inversion) {
		valor = "inversion";
	}
	return valor;
}

function oficial_conectarDetalles()
{
	connect(this.child("pbnDatosRG1"), "clicked()", this, "iface.partidasDatosRG1");
	connect(this.child("pbnDatosRG2"), "clicked()", this, "iface.partidasDatosRG2");
	connect(this.child("pbnDatosRG3"), "clicked()", this, "iface.partidasDatosRG3");
	connect(this.child("pbnDatosRE1"), "clicked()", this, "iface.partidasDatosRE1");
	connect(this.child("pbnDatosRE2"), "clicked()", this, "iface.partidasDatosRE2");
	connect(this.child("pbnDatosRE3"), "clicked()", this, "iface.partidasDatosRE3");
	connect(this.child("pbnDatosIVADevAI"), "clicked()", this, "iface.partidasDatosIVADevAI");

	connect(this.child("pbnDatosDedOIBC"), "clicked()", this, "iface.partidasDatosIVADedOIBC");
	connect(this.child("pbnDatosDedOIBI"), "clicked()", this, "iface.partidasDatosIVADedOIBI");
	connect(this.child("pbnDatosDedImBC"), "clicked()", this, "iface.partidasDatosIVADedImBC");
	connect(this.child("pbnDatosDedImBI"), "clicked()", this, "iface.partidasDatosIVADedImBI");
	connect(this.child("pbnDatosDedAIBC"), "clicked()", this, "iface.partidasDatosIVADedAIBC");
	connect(this.child("pbnDatosDedAIBI"), "clicked()", this, "iface.partidasDatosIVADedAIBI");
	connect(this.child("pbnDatosComRe"), "clicked()", this, "iface.partidasDatosIVAComRe");

	connect(this.child("pbnDatosEUE"), "clicked()", this, "iface.partidasDatosEUE");
	connect(this.child("pbnDatosRXP"), "clicked()", this, "iface.partidasDatosRXP");
	connect(this.child("pbnDatosREX"), "clicked()", this, "iface.partidasDatosREX");
}

function oficial_partidasDatosRG1()
{
	var util:FLUtil;
	var porcentajes:String = "";
	var fechaLimite = new Date(2010,6,30);
	if(util.daysTo(this.cursor().valueBuffer("fechafin"),fechaLimite) >= 0) {
		porcentajes = this.cursor().valueBuffer("tiporg1");
	}
	else {
		var arrayPorcentajes:Array = [];
		porcentajes = util.sqlSelect("co_datosfiscales", "porcentajes123", "1 = 1");
		if(!porcentajes || porcentajes == "")
			return;
		
		arrayPorcentajes = porcentajes.split(",");
		porcentajes = "";
		for(var p=0;p<arrayPorcentajes.length;p++) {
			if(porcentajes != "")
				porcentajes += ",";
			porcentajes += "'" + arrayPorcentajes[p] + "'";
		}
	}

	this.iface.mostrarPartidas("casilla303 = '[01]-[09]' AND iva IN (" + porcentajes + ")");
}

function oficial_partidasDatosRG2()
{
	var util:FLUtil;
	var porcentajes:String = "";
	var fechaLimite:Date = new Date(2010,6,30);
	if(util.daysTo(this.cursor().valueBuffer("fechafin"),fechaLimite) >= 0) {
		porcentajes = this.cursor().valueBuffer("tiporg2");
	}
	else {
		var arrayPorcentajes:Array = [];
		porcentajes = util.sqlSelect("co_datosfiscales", "porcentajes456", "1 = 1");
		if(!porcentajes || porcentajes == "")
			return;
		
		arrayPorcentajes = porcentajes.split(",");
		porcentajes = "";
		for(var p=0;p<arrayPorcentajes.length;p++) {
			if(porcentajes != "")
				porcentajes += ",";
			porcentajes += "'" + arrayPorcentajes[p] + "'";
		}
	}

	this.iface.mostrarPartidas("casilla303 = '[01]-[09]' AND iva IN (" + porcentajes + ")");
}

function oficial_partidasDatosRG3()
{
	var util:FLUtil;
	var porcentajes:String = "";
	var fechaLimite = new Date(2010,6,30);
	if(util.daysTo(this.cursor().valueBuffer("fechafin"),fechaLimite) >= 0) {
		porcentajes = this.cursor().valueBuffer("tiporg3");
	}
	else {
		var arrayPorcentajes:Array = [];
		porcentajes = util.sqlSelect("co_datosfiscales", "porcentajes789", "1 = 1");
		if(!porcentajes || porcentajes == "")
			return;
		
		arrayPorcentajes = porcentajes.split(",");
		porcentajes = "";
		for(var p=0;p<arrayPorcentajes.length;p++) {
			if(porcentajes != "")
				porcentajes += ",";
			porcentajes += "'" + arrayPorcentajes[p] + "'";
		}
	}
		
	this.iface.mostrarPartidas("casilla303 = '[01]-[09]' AND iva IN (" + porcentajes + ")");
}

function oficial_partidasDatosRE1()
{
	this.iface.mostrarPartidas("casilla303 = '[10]-[18]' AND recargo = " + this.cursor().valueBuffer("tipore1"));
}

function oficial_partidasDatosRE2()
{
	this.iface.mostrarPartidas("casilla303 = '[10]-[18]' AND recargo = " + this.cursor().valueBuffer("tipore2"));
}

function oficial_partidasDatosRE3()
{
	this.iface.mostrarPartidas("casilla303 = '[10]-[18]' AND recargo = " + this.cursor().valueBuffer("tipore3"));
}

function oficial_partidasDatosIVADevAI()
{
	this.iface.mostrarPartidas("casilla303 = '[19]-[20]'");
}

function oficial_partidasDatosIVADedOIBC()
{
	this.iface.mostrarPartidas("casilla303 = '[22]-[23]'");
}

function oficial_partidasDatosIVADedOIBI()
{
	this.iface.mostrarPartidas("casilla303 = '[24]-[25]'");
}

function oficial_partidasDatosIVADedImBC()
{
	this.iface.mostrarPartidas("casilla303 = '[26]-[27]'");
}

function oficial_partidasDatosIVADedImBI()
{
	this.iface.mostrarPartidas("casilla303 = '[28]-[29]'");
}

function oficial_partidasDatosIVADedAIBC()
{
	this.iface.mostrarPartidas("casilla303 = '[30]-[31]'");
}

function oficial_partidasDatosIVADedAIBI()
{
	this.iface.mostrarPartidas("casilla303 = '[32]-[33]'");
}

function oficial_partidasDatosIVAComRe()
{
	this.iface.mostrarPartidas("casilla303 = '[34]'");
}

function oficial_partidasDatosEUE()
{
	this.iface.mostrarPartidas("casilla303 = '[42]'");
}
function oficial_partidasDatosRXP()
{
	this.iface.mostrarPartidas("casilla303 = '[43]'");
}

function oficial_partidasDatosREX()
{
	this.iface.mostrarPartidas("casilla303 = '[44]'");
}


function oficial_mostrarPartidas(filtro:String):Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	
	var f:Object = new FLFormSearchDB("co_partidas303");
	var curPartidas:FLSqlCursor = f.cursor();
	
	curPartidas.setMainFilter(filtro + " AND idasiento IN (SELECT idasiento FROM co_asientos a WHERE " + this.iface.whereFechas_ + ")");

	f.setMainWidget();
	var idPartida:String = f.exec("idpartida");
	if (f.accepted()) {
		return false;
	}
	return true;
}

function oficial_actualizarCasilla303Partida(idPartida:String, casilla303:String):Boolean
{
debug("oficial_actualizarCasilla303Partida " + idPartida + " " + casilla303);
	if (!this.iface.curPartida_) {
		this.iface.curPartida_ = new FLSqlCursor("co_partidas");
		this.iface.curPartida_.setActivatedCommitActions(false);
	}
	this.iface.curPartida_.select("idpartida = " + idPartida);
	if (!this.iface.curPartida_.first()) {
		return false;
	}
	this.iface.curPartida_.setModeAccess(this.iface.curPartida_.Edit);
	this.iface.curPartida_.refreshBuffer();
	if (casilla303 == "NULL") {
		this.iface.curPartida_.setNull("casilla303");
	} else {
		this.iface.curPartida_.setValueBuffer("casilla303", casilla303);
	}
	if (!this.iface.curPartida_.commitBuffer()) {
		return false;
	}
debug("oficial_actualizarCasilla303Partida " + idPartida + " " + casilla303 + " OK ");
	return true;
}

function oficial_limpiarValores():Boolean
{
	this.child("fdbBaseImponibleRG1").setValue("");
	this.child("fdbBaseImponibleRG2").setValue("");
	this.child("fdbBaseImponibleRG3").setValue("");
	this.child("fdbTipoRG1").setValue("");
	this.child("fdbTipoRG2").setValue("");
	this.child("fdbTipoRG3").setValue("");
	this.child("fdbCuotaRG1").setValue("");
	this.child("fdbCuotaRG2").setValue("");
	this.child("fdbCuotaRG3").setValue("");
	this.child("fdbBaseImponibleRE1").setValue("");
	this.child("fdbBaseImponibleRE2").setValue("");
	this.child("fdbBaseImponibleRE3").setValue("");
	this.child("fdbTipoRE1").setValue("");
	this.child("fdbTipoRE2").setValue("");
	this.child("fdbTipoRE3").setValue("");
	this.child("fdbCuotaRE1").setValue("");
	this.child("fdbCuotaRE2").setValue("");
	this.child("fdbCuotaRE3").setValue("");
	this.child("fdbBaseImponibleAI").setValue("");
	this.child("fdbCuotaAI").setValue("");
	this.child("fdbCuotaDevTotal").setValue("");
	this.child("fdbBaseDedoibc").setValue("");
	this.child("fdbCuotaDedOI").setValue("");
	this.child("fdbBaseDedoibi").setValue("");
	this.child("fdbCuotaDedIm").setValue("");
	this.child("fdbBaseDedimc").setValue("");
	this.child("fdbCuotaDedimbc").setValue("");
	this.child("fdbBaseDedimbi").setValue("");
	this.child("fdbCuotaDedimbi").setValue("");
	this.child("fdbBaseDedaibc").setValue("");
	this.child("fdbCuotaDedaibc").setValue("");
	this.child("fdbBaseDedaibi").setValue("");
	this.child("fdbCuotaDedaibi").setValue("");
	this.child("fdbCuotaComRE").setValue("");
	this.child("fdbCuotaRegIn").setValue("");
	this.child("fdbCuotaRegApli").setValue("");
	this.child("fdbCuotaDedTotal").setValue("");
	this.child("fdbCuotaDif").setValue("");

	return true;

}

function oficial_actualizarWhereFechas()
{
	var cursor:FLSqlCursor = this.cursor();

	var fechaDesde:String = this.child("fdbFechaInicio").value();
	var fechaHasta:String = this.child("fdbFechaFin").value();
	var codEjercicio:String = this.child("fdbCodEjercicio").value();

	if (!fechaHasta || fechaHasta == "" || !fechaDesde || fechaDesde == "") {
		this.iface.whereFechas_ = "1 = 2";
	} else {
		this.iface.whereFechas_ = "a.codejercicio = '" + codEjercicio + "' AND a.fecha BETWEEN '" + fechaDesde + "' AND '" + fechaHasta + "'";
	}
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
