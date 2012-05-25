/***************************************************************************
                 co_modelo390.qs  -  description
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
El modelo 390 recoge la información relativa a la declaraciones anual de IVA.
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
	function oficial( context ) { interna( context ); }
	function lanzar(){ this.ctx.oficial_lanzar();}
	function bufferChanged( fN:String ) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function informarConDatosFiscales() {
		return this.ctx.oficial_informarConDatosFiscales();
	}
	function calcularValores() {
		return this.ctx.oficial_calcularValores();
	}
	function limpiarValores():Boolean {
		return this.ctx.oficial_limpiarValores();
	}
	function conectarDetalles() {
		return this.ctx.oficial_conectarDetalles();
	}
	function mostrarPartidas(filtro:String):Boolean {
		return this.ctx.oficial_mostrarPartidas(filtro);
	}
	function calcularCasillas01a06():Boolean { 
		return this.ctx.oficial_calcularCasillas01a06();
	}
	function calcularCasillas21a26():Boolean { 
		return this.ctx.oficial_calcularCasillas21a26();
	}
	function calcularCasillas35a42():Boolean { 
		return this.ctx.oficial_calcularCasillas35a42();
	}
	function calcularCasillas48a49():Boolean { 
		return this.ctx.oficial_calcularCasillas48a49();
	}
	function calcularCasillas50a51():Boolean { 
		return this.ctx.oficial_calcularCasillas50a51();
	}
	function calcularCasillas52a53():Boolean { 
		return this.ctx.oficial_calcularCasillas52a53();
	}
	function calcularCasillas54a55():Boolean { 
		return this.ctx.oficial_calcularCasillas54a55();
	}
	function calcularCasillas56a57():Boolean { 
		return this.ctx.oficial_calcularCasillas56a57();
	}
	function calcularCasillas58a59():Boolean { 
		return this.ctx.oficial_calcularCasillas58a59();
	}
	function partidasDatosRO0() {
		return this.ctx.oficial_partidasDatosRO0();
	}
	function partidasDatosRO1() {
		return this.ctx.oficial_partidasDatosRO1();
	}
	function partidasDatosRO2() {
		return this.ctx.oficial_partidasDatosRO2();
	}
	function partidasDatosai0() {
		return this.ctx.oficial_partidasDatosai0();
	}
	function partidasDatosai1() {
		return this.ctx.oficial_partidasDatosai1();
	}
	function partidasDatosai2() {
		return this.ctx.oficial_partidasDatosai2();
	}
	function partidasDatosRE0() {
		return this.ctx.oficial_partidasDatosRE0();
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
	function habilitarTributacionTerritorio() {
		return this.ctx.oficial_habilitarTributacionTerritorio();
	}
	function partidasDatosoibc() {
		return this.ctx.oficial_partidasDatosoibc();
	}
	function partidasDatosibi() {
		return this.ctx.oficial_partidasDatosibi();
	}
	function partidasDatosimbc() {
		return this.ctx.oficial_partidasDatosimbc();
	}
	function partidasDatosimbi() {
		return this.ctx.oficial_partidasDatosimbi();
	}
	function partidasDatosaibc() {
		return this.ctx.oficial_partidasDatosaibc();
	}
	function partidasDatosaibi() {
		return this.ctx.oficial_partidasDatosaibi();
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
	var cursor:FLSqlCursor = this.cursor();

	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this.child("pbnCalcularValores"), "clicked()", this, "iface.calcularValores()");

	this.child("fdbAnno").setDisabled(true);
	if (cursor.modeAccess() == cursor.Insert) {
		this.child("fdbCodEjercicio").setValue(flfactppal.iface.pub_ejercicioActual());
		this.iface.informarConDatosFiscales();
	}

	this.iface.conectarDetalles();
	this.iface.bufferChanged("sustitutiva");
	this.iface.habilitarTributacionTerritorio();
}

function interna_calculateField( fN:String ):String
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var valor:String;
	switch ( fN ) {
		case "anno": {
			var fecha:String = util.sqlSelect("ejercicios", "fechainicio", "codejercicio = '" + cursor.valueBuffer("codejercicio") + "'");
			if (!fecha) {
				valor = "";
				break;
			}
			var fecha2:Date = new Date (Date.parse(fecha.toString()));
			valor = fecha2.getYear();
			break;
		}
		case "totalivadev": {
			valor = parseFloat(cursor.valueBuffer("cuotatotalbc")) + parseFloat(cursor.valueBuffer("cuotaeq0")) + parseFloat(cursor.valueBuffer("cuotaeq1")) + parseFloat(cursor.valueBuffer("cuotaeq2")) + parseFloat(cursor.valueBuffer("cuotaeq3")) + parseFloat(cursor.valueBuffer("cuotamodeq")) + parseFloat(cursor.valueBuffer("cuotamodeqqs"));
			break;
		}
		case "baseimponibletotalbc": {
			valor = parseFloat(cursor.valueBuffer("baseimponiblero0")) + parseFloat(cursor.valueBuffer("baseimponiblero1")) +
			parseFloat(cursor.valueBuffer("baseimponiblero2")) +
			parseFloat(cursor.valueBuffer("baseimponiblere0")) +
			parseFloat(cursor.valueBuffer("baseimponiblere1")) +
			parseFloat(cursor.valueBuffer("baseimponiblere2")) +
			parseFloat(cursor.valueBuffer("baseimponibleav")) +
			parseFloat(cursor.valueBuffer("baseimponibleai0")) +
			parseFloat(cursor.valueBuffer("baseimponibleai1")) +
			parseFloat(cursor.valueBuffer("baseimponibleai2")) +
			parseFloat(cursor.valueBuffer("baseimponibleis")) +
			parseFloat(cursor.valueBuffer("baseimponiblebc")) +
			parseFloat(cursor.valueBuffer("baseimponibleqs"));
			break;
		}
		case "cuotatotalbc": {
			valor = parseFloat(cursor.valueBuffer("cuotaro0")) + parseFloat(cursor.valueBuffer("cuotaro1")) + parseFloat(cursor.valueBuffer("cuotaro2")) + parseFloat(cursor.valueBuffer("cuotare0")) + parseFloat(cursor.valueBuffer("cuotare1")) +
			parseFloat(cursor.valueBuffer("cuotare2")) + parseFloat(cursor.valueBuffer("cuotaav")) + parseFloat(cursor.valueBuffer("cuotaai0")) + parseFloat(cursor.valueBuffer("cuotaai1")) + parseFloat(cursor.valueBuffer("cuotaai2")) + parseFloat(cursor.valueBuffer("cuotais")) + parseFloat(cursor.valueBuffer("cuotabc")) + parseFloat(cursor.valueBuffer("cuotaqs")) + parseFloat(cursor.valueBuffer("cuotaoi0")) + parseFloat(cursor.valueBuffer("cuotaoi1")) + parseFloat(cursor.valueBuffer("cuotaoi2"));
			break;
		}
		case "sumaded": {
			valor = parseFloat(cursor.valueBuffer("cuotaoibc")) + parseFloat(cursor.valueBuffer("cuotaoibi")) + parseFloat(cursor.valueBuffer("cuotaimbc")) + parseFloat(cursor.valueBuffer("cuotaimbi")) + parseFloat(cursor.valueBuffer("cuotaaibc")) +
			parseFloat(cursor.valueBuffer("cuotaaibi")) + parseFloat(cursor.valueBuffer("cuotare")) + parseFloat(cursor.valueBuffer("cuotard")) + parseFloat(cursor.valueBuffer("cuotarbi")) + parseFloat(cursor.valueBuffer("cuotaoioibc")) + parseFloat(cursor.valueBuffer("cuotaoioibi") + parseFloat(cursor.valueBuffer("cuotarpdpro")));
			break;
		}
		case "resrg": {
			valor = parseFloat(cursor.valueBuffer("totalivadev")) - parseFloat(cursor.valueBuffer("sumaded"));
			break;
		}
		case "ressimpl": {
			valor = parseFloat(cursor.valueBuffer("totalcres")) - parseFloat(cursor.valueBuffer("sumadeducciones"));
			break;
		}
		case "totalcres": {
			valor = parseFloat(cursor.valueBuffer("sumacdan")) + parseFloat(cursor.valueBuffer("sumacda")) + parseFloat(cursor.valueBuffer("ivadevai")) + parseFloat(cursor.valueBuffer("ivadevis")) + parseFloat(cursor.valueBuffer("ivadevea"));
			break;
		}
		case "sumadeducciones": {
			valor = parseFloat(cursor.valueBuffer("ivasopaf")) + parseFloat(cursor.valueBuffer("regbienesi"));
			break;
		}
		case "sumacdan": {
			valor = parseFloat(cursor.valueBuffer("cuotaregsimpl")) + parseFloat(cursor.valueBuffer("cuotaregsimpl2"));
			break;
		}
		case "sumacda": {
			valor = parseFloat(cursor.valueBuffer("cderivadars1")) + parseFloat(cursor.valueBuffer("cderivadars2")) + parseFloat(cursor.valueBuffer("cderivadars3")) + parseFloat(cursor.valueBuffer("cderivadars4")) + parseFloat(cursor.valueBuffer("cderivadars5"));
			break;
		}
		case "resultado": {
			valor = (parseFloat(cursor.valueBuffer("cuotadevopc")) - parseFloat(cursor.valueBuffer("cuotassopopc"))) * parseFloat(cursor.valueBuffer("indicecorrector"));
			break;
		}
		case "resultado2": {
			valor = (parseFloat(cursor.valueBuffer("cuotadevopc2")) - parseFloat(cursor.valueBuffer("cuotassopopc2"))) * parseFloat(cursor.valueBuffer("indicecorrector2"));
			break;
		}
		case "cuotaminima": {
			valor = (parseFloat(cursor.valueBuffer("cuotadevopc")) * parseFloat(cursor.valueBuffer("porcuotaminima")) * parseFloat(cursor.valueBuffer("indicecorrector"))) + parseFloat(cursor.valueBuffer("devcuotassopop"));
			break;
		}
		case "cuotaminima2": {
			valor = (parseFloat(cursor.valueBuffer("cuotadevopc2")) * parseFloat(cursor.valueBuffer("porcuotaminima2")) * parseFloat(cursor.valueBuffer("indicecorrector"))) + parseFloat(cursor.valueBuffer("devcuotassopop2"));
			break;
		}
		case "cuotaregsimpl": {
		/** \C --cuotaregsimpl--: Será el valor máximo entre --resultado-- y --cuotaminima--
		\end */
			if (parseFloat(cursor.valueBuffer("resultado")) > parseFloat(cursor.valueBuffer("cuotaminima")))
				valor = cursor.valueBuffer("resultado");
			else
				valor = cursor.valueBuffer("cuotaminima");
			break;
		}
		case "cuotaregsimpl2": {
		/** \C --cuotaregsimpl2--: Será el valor máximo entre --resultado2-- y --cuotaminima2--
		\end */
			if (parseFloat(cursor.valueBuffer("resultado2")) > parseFloat(cursor.valueBuffer("cuotaminima2")))
				valor = cursor.valueBuffer("resultado2");
			else
				valor = cursor.valueBuffer("cuotaminima2");
			break;
		}
		case "sumares": {
			valor = parseFloat(cursor.valueBuffer("resrg")) + parseFloat(cursor.valueBuffer("ressimpl"));
			break;
		}
		case "resliquidacion": {
			valor = parseFloat(cursor.valueBuffer("sumares")) - parseFloat(cursor.valueBuffer("comcuotasea"));
			break;
		}
		case "resultadotc": {
			valor = (parseFloat(cursor.valueBuffer("sumares")) * parseFloat(cursor.valueBuffer("portc"))) / 100;
			break;
		}
		case "resliqtc": {
			valor = parseFloat(cursor.valueBuffer("resultadotc")) - parseFloat(cursor.valueBuffer("compcuotaseatc"));
			break;
		}
		case "totalvoloperaciones": {
			valor = parseFloat(cursor.valueBuffer("operacionesre")) +  parseFloat(cursor.valueBuffer("operacionesrs")) + parseFloat(cursor.valueBuffer("operacionesreagp")) + parseFloat(cursor.valueBuffer("operacionesrere")) + parseFloat(cursor.valueBuffer("entregasintraex")) + parseFloat(cursor.valueBuffer("entregasintraexcondd")) + parseFloat(cursor.valueBuffer("entregasintraexsinndd")) - parseFloat(cursor.valueBuffer("entregasbinmuebles")) - parseFloat(cursor.valueBuffer("entregasbinversion")) + parseFloat(cursor.valueBuffer("opnsdm")) + parseFloat(cursor.valueBuffer("entregasbo")) + parseFloat(cursor.valueBuffer("opregespbius")) + parseFloat(cursor.valueBuffer("opregesagenvia"));
			break;
		}
	}
	return valor;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Lanza el infome correspondiente al modelo seleccionado
\end */
function oficial_lanzar()
{
	var cursor:FLSqlCursor = this.cursor();
	var seleccion:String = cursor.valueBuffer("id");
	if (!seleccion)
		return;

	flcontmode.iface.pub_lanzarInforme(cursor, "co_modelo390_02", "");
}

function oficial_informarConDatosFiscales()
{
	var qryDatosFiscales:FLSqlQuery = new FLSqlQuery();
	qryDatosFiscales.setTablesList("co_datosfiscales");
	qryDatosFiscales.setSelect("apellidosrs, nombrepf, apellidospf, apellidospf2, personafisica, cifnif, codpos, municipio, idprovincia, codprovincia, provincia, codtipovia, nombrevia, numero, escalera, piso, puerta, telefono");
	qryDatosFiscales.setFrom("co_datosfiscales");
	qryDatosFiscales.setWhere("1 = 1");
	qryDatosFiscales.setForwardOnly(true);
	if (!qryDatosFiscales.exec()) {
		return false;
	}
	if (qryDatosFiscales.first()) {
		if (qryDatosFiscales.value("personafisica") == true) {
			this.child("fdbTipoPersona").setValue("Física");
		} else {
			this.child("fdbTipoPersona").setValue("Jurídica");
		}
		this.child("fdbCifNif").setValue(qryDatosFiscales.value("cifnif"));
		this.child("fdbNombre").setValue(qryDatosFiscales.value("nombrepf"));
		this.child("fdbApellido1").setValue(qryDatosFiscales.value("apellidospf"));
		this.child("fdbApellido2").setValue(qryDatosFiscales.value("apellidospf2"));
		this.child("fdbRazonSocial").setValue(qryDatosFiscales.value("apellidosrs"));
		this.child("fdbCodTipoVia").setValue(qryDatosFiscales.value("codtipovia"));
		this.child("fdbNombreVia").setValue(qryDatosFiscales.value("nombrevia"));
		this.child("fdbTelefono").setValue(qryDatosFiscales.value("telefono"));
		this.child("fdbNumero").setValue(qryDatosFiscales.value("numero"));
		this.child("fdbEscalera").setValue(qryDatosFiscales.value("escalera"));
		this.child("fdbPiso").setValue(qryDatosFiscales.value("piso"));
		this.child("fdbPuerta").setValue(qryDatosFiscales.value("puerta"));
		this.child("fdbMunicipio").setValue(qryDatosFiscales.value("municipio"));
		this.child("fdbCodPos").setValue(qryDatosFiscales.value("codpos"));
		this.child("fdbIdProvincia").setValue(qryDatosFiscales.value("idprovincia"));
		this.child("fdbCodProvincia").setValue(qryDatosFiscales.value("codprovincia"));
		this.child("fdbProvincia").setValue(qryDatosFiscales.value("provincia"));
	}
}

function oficial_bufferChanged( fN:String )
{
	var cursor:FLSqlCursor = this.cursor();		
	switch ( fN ) {
		case "codejercicio": {
			this.child("fdbAnno").setValue(this.iface.calculateField("anno"));
			break;
		}
		case "cuotatotalbc":
		case "cuotaeq0":
		case "cuotaeq1":
		case "cuotaeq2":
		case "cuotaeq3":
		case "cuotamodeq":
		case "cuotamodeqqs": {
			this.child("fdbTotalIvaDev").setValue(this.iface.calculateField("totalivadev"));
			break;
		}
		case "baseimponiblero0":
		case "baseimponiblero1":
		case "baseimponiblero2":
		case "baseimponiblere0":
		case "baseimponiblere1":
		case "baseimponiblere2":
		case "baseimponibleav":
		case "baseimponibleai0":
		case "baseimponibleai1":
		case "baseimponibleai2":
		case "baseimponibleis":
		case "baseimponiblebc":
		case "baseimponibleqs": {
			this.child("fdbBaseImponibleTotalbc").setValue(this.iface.calculateField("baseimponibletotalbc"));
			break;
		}
		case "cuotaro0":
		case "cuotaro1":
		case "cuotaro2":
		case "cuotare0":
		case "cuotare1":
		case "cuotare2":
		case "cuotaav":
		case "cuotaai0":
		case "cuotaai1":
		case "cuotaai2":
		case "cuotais":
		case "cuotabc":
		case "cuotaqs": 
		case "cuotaoi0": 
		case "cuotaoi1": 
		case "cuotaoi2": {
			this.child("fdbCuotaTotalbc").setValue(this.iface.calculateField("cuotatotalbc"));
			break;
		}
		case "cuotaoibc":
		case "cuotaoibi":
		case "cuotaimbc":
		case "cuotaimbi":
		case "cuotaaibc":
		case "cuotaaibi":
		case "cuotare":
		case "cuotard":
		case "cuotarbi": 
		case "cuotaoioibc": 
		case "cuotaoioibi": 
		case "cuotarpdpro": {
			this.child("fdbSumaDed").setValue(this.iface.calculateField("sumaded"));
			break;
		}
		case "totalivadev":
		case "sumaded": {
			this.child("fdbResrg").setValue(this.iface.calculateField("resrg"));
			break;
		}
		case "totalcres":
		case "sumadeducciones": {
			this.child("fdbResSimpl").setValue(this.iface.calculateField("ressimpl"));
			break;
		}
		case "sumacdan":
		case "sumacda":
		case "ivadevai":
		case "ivadevis":
		case "ivadevea": {
			this.child("fdbTotalCRes").setValue(this.iface.calculateField("totalcres"));
			break;
		}
		case "ivasopaf":
		case "regbienesi": {
			this.child("fdbSumaDeducciones").setValue(this.iface.calculateField("sumadeducciones"));
			break;
		}
		case "cuotaregsimpl":
		case "cuotaregsimpl2": {
			this.child("fdbSumacdan").setValue(this.iface.calculateField("sumacdan"));
			break;
		}
		case "cderivadars1":
		case "cderivadars2":
		case "cderivadars3":
		case "cderivadars4":
		case "cderivadars5": {
			this.child("fdbSumacda").setValue(this.iface.calculateField("sumacda"));
			break;
		}
		case "cuotadevopc":
		case "indicecorrector": {
			this.child("fdbCuotaMinima").setValue(this.iface.calculateField("cuotaminima"));
			this.child("fdbResultado").setValue(this.iface.calculateField("resultado"));
			break;
		}
		case "cuotassopopc": {
			this.child("fdbResultado").setValue(this.iface.calculateField("resultado"));
			break;
		}
		case "cuotadevopc2":
		case "indicecorrector2": {
			this.child("fdbCuotaMinima2").setValue(this.iface.calculateField("cuotaminima2"));
			this.child("fdbResultado2").setValue(this.iface.calculateField("resultado2"));
			break;
		}
		case "cuotassopopc2": {
			this.child("fdbResultado2").setValue(this.iface.calculateField("resultado2"));
			break;
		}
		case "porcuotaminima":
		case "devcuotassopop": {
			this.child("fdbCuotaMinima").setValue(this.iface.calculateField("cuotaminima"));
			break;
		}
		case "porcuotaminima2":
		case "devcuotassopop2": {
			this.child("fdbCuotaMinima2").setValue(this.iface.calculateField("cuotaminima2"));
			break;
		}
		case "resultado":
		case "cuotaminima": {
			this.child("fdbCuotaRegSimpl").setValue(this.iface.calculateField("cuotaregsimpl"));
			break;
		}
		case "resultado2":
		case "cuotaminima2": {
			this.child("fdbCuotaRegSimpl2").setValue(this.iface.calculateField("cuotaregsimpl2"));
			break;
		}
		case "resrg":
		case "ressimpl": {
			this.child("fdbSumaRes").setValue(this.iface.calculateField("sumares"));
			break;
		}
		case "sumares": {
			this.child("fdbResLiquidacion").setValue(this.iface.calculateField("resliquidacion"));
			this.child("fdbResultadoTC").setValue(this.iface.calculateField("resultadotc"));
			break;
		}
		case "comcuotasea": {
			this.child("fdbResLiquidacion").setValue(this.iface.calculateField("resliquidacion"));
			break;
		}
		case "portc": {
			this.child("fdbResultadoTC").setValue(this.iface.calculateField("resultadotc"));
			break;
		}
		case "resultadotc":
		case "compcuotaseatc": {
			this.child("fdbResLiqtc").setValue(this.iface.calculateField("resliqtc"));
			break;
		}
		case "operacionesre":
		case "operacionesrs":
		case "opnsdm":
		case "entregasbo":
		case "opregespbius":
		case "opregesagenvia":
		case "operacionesreagp":
		case "operacionesrere":
		case "entregasintraex":
		case "entregasintraexcondd":
		case "entregasintraexsinndd":
		case "entregasbinmuebles":
		case "entregasbinversion": {
			this.child("fdbTotalVolOperaciones").setValue(this.iface.calculateField("totalvoloperaciones"));
			break;
		}
		case "sustitutiva": {
			if (cursor.valueBuffer("sustitutiva")) {
				this.child("fdbNumJustificanteAnt").setDisabled(false);
			} else {
				this.child("fdbNumJustificanteAnt").setDisabled(true);
			}		
			break;
		}
		case "tributacionterr": {
			this.child("fdbPorTC").setValue("");
			this.child("fdbPorA").setValue("");
			this.child("fdbPorG").setValue("");
			this.child("fdbPorV").setValue("");
			this.child("fdbPorN").setValue("");
			this.child("fdbSumaRes8").setValue("");
			this.child("fdbResultadoTC").setValue("");
			this.child("fdbCompCuotaseatc").setValue("");
			this.child("fdbResLiqtc").setValue("");
			this.iface.habilitarTributacionTerritorio();
			break;
		}
	}
}

function oficial_habilitarTributacionTerritorio()
{
	var cursor:FLSqlCursor = this.cursor();
	if (cursor.valueBuffer("tributacionterr")) {
		this.child("gbxTributacionTerr").setDisabled(false);
	} else {
		this.child("gbxTributacionTerr").setDisabled(true);
	}		
}

/** \D Calcula algunas de las casillas del modelo a partir de los contenidos de la base de datos de contabilidad
\end */
function oficial_calcularValores()
{
	if (!this.iface.limpiarValores()) {
		return false;
	}
	if (!this.iface.calcularCasillas01a06()) {
		return false;
	}
	if (!this.iface.calcularCasillas21a26()) {
		return false;
	}
	if (!this.iface.calcularCasillas35a42()) {
		return false;
	}
	if (!this.iface.calcularCasillas48a49()) {
		return false;
	}
	if (!this.iface.calcularCasillas50a51()) {
		return false;
	}
	if (!this.iface.calcularCasillas52a53()) {
		return false;
	}
	if (!this.iface.calcularCasillas54a55()) {
		return false;
	}
	if (!this.iface.calcularCasillas56a57()) {
		return false;
	}
	if (!this.iface.calcularCasillas58a59()) {
		return false;
	}
}

function oficial_calcularCasillas01a06():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var fechaDesde:String = cursor.valueBuffer("anno") + "-1-1";
	var fechaHasta:String = cursor.valueBuffer("anno") + "-12-31";
	var qryPartidas:FLSqlQuery = new FLSqlQuery();
	qryPartidas.setTablesList("co_partidas");
	qryPartidas.setSelect("SUM(p.baseimponible), p.iva, SUM(p.haber - p.debe)");
	qryPartidas.setFrom("co_asientos a INNER JOIN co_partidas p ON p.idasiento = a.idasiento");
	qryPartidas.setWhere("p.casilla303 = '[01]-[09]' AND p.iva <> 0 AND a.fecha BETWEEN '" + fechaDesde + "' AND '" + fechaHasta + "' GROUP BY p.iva ORDER BY p.iva ");
	qryPartidas.setForwardOnly(true);
	if (!qryPartidas.exec()) {
		return false;
	}
	if (qryPartidas.size() > 3) {
		MessageBox.warning(util.translate("scripts", "Error al obtener datos de I.V.A. del Régimen general:\nSe ha encontrado más de tres tipos de I.V.A."), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var baseImponible:Number = 0;
	var cuota:Number = 0;
	while (qryPartidas.next()) {
		baseImponible = qryPartidas.value("SUM(p.baseimponible)");
		cuota = qryPartidas.value("SUM(p.haber - p.debe)");
		switch (qryPartidas.value("p.iva")) {
			case 4: {
				this.child("fdbBaseImponibleRO0").setValue(baseImponible);
				this.child("fdbCuotaRO0").setValue(cuota);
				break;	
			}
			case 7: {
				this.child("fdbBaseImponibleRO1").setValue(baseImponible);
				this.child("fdbCuotaRO1").setValue(cuota);
				break;	
			}
			case 16: {
				this.child("fdbBaseImponibleRO2").setValue(baseImponible);
				this.child("fdbCuotaRO2").setValue(cuota);
				break;	
			}
		}
	}
	return true;
}

function oficial_calcularCasillas21a26():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var fechaDesde:String = cursor.valueBuffer("anno") + "-1-1";
	var fechaHasta:String = cursor.valueBuffer("anno") + "-12-31";
	var qryPartidas:FLSqlQuery = new FLSqlQuery();
	qryPartidas.setTablesList("co_partidas");
	qryPartidas.setSelect("SUM(p.baseimponible), p.iva, SUM(p.haber - p.debe)");
	qryPartidas.setFrom("co_asientos a INNER JOIN co_partidas p ON p.idasiento = a.idasiento");
	qryPartidas.setWhere("p.casilla303 = '[19]-[20]' AND p.iva <> 0 AND a.fecha BETWEEN '" + fechaDesde + "' AND '" + fechaHasta + "' GROUP BY p.iva ORDER BY p.iva ");
	qryPartidas.setForwardOnly(true);
	if (!qryPartidas.exec()) {
		return false;
	}
debug(qryPartidas.sql());	
	var baseImponible:Number = 0;
	var cuota:Number = 0;
	while (qryPartidas.next()) {
		baseImponible = qryPartidas.value("SUM(p.baseimponible)");
		cuota = qryPartidas.value("SUM(p.haber - p.debe)");
		switch (qryPartidas.value("p.iva")) {
			case 4: {
				this.child("fdbbaseimponibleai0").setValue(baseImponible);
				this.child("fdbCuotaai0").setValue(cuota);
				break;	
			}
			case 7: {
				this.child("fdbbaseimponibleai1").setValue(baseImponible);
				this.child("fdbCuotaai1").setValue(cuota);
				break;	
			}
			case 16: {
				this.child("fdbbaseimponibleai2").setValue(baseImponible);
				this.child("fdbCuotaai2").setValue(cuota);
				break;	
			}
		}
	}
	return true;
}
	

function oficial_calcularCasillas35a42():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var fechaDesde:String = cursor.valueBuffer("anno") + "-1-1";
	var fechaHasta:String = cursor.valueBuffer("anno") + "-12-31";
	var qryPartidas:FLSqlQuery = new FLSqlQuery();
	qryPartidas.setTablesList("co_partidas");
	qryPartidas.setSelect("SUM(p.baseimponible), p.recargo, SUM(p.haber - p.debe)");
	qryPartidas.setFrom("co_asientos a INNER JOIN co_partidas p ON p.idasiento = a.idasiento");
	qryPartidas.setWhere("p.casilla303 = '[10]-[18]' AND p.recargo <> 0 AND a.fecha BETWEEN '" + fechaDesde + "' AND '" + fechaHasta + "' GROUP BY p.recargo ORDER BY p.recargo ");
	qryPartidas.setForwardOnly(true);
	if (!qryPartidas.exec()) {
		return false;
	}
	var baseImponible:Number = 0;
	var cuota:Number = 0;
	while (qryPartidas.next()) {
		baseImponible = qryPartidas.value("SUM(p.baseimponible)");
		cuota = qryPartidas.value("SUM(p.haber - p.debe)");
		switch (qryPartidas.value("p.recargo")) {
			case 0.5: {
				this.child("fdbBaseImponibleRE0").setValue(baseImponible);
				this.child("fdbCuotaRE0").setValue(cuota);
				break;	
			}
			case 1: {
				this.child("fdbBaseImponibleRE1").setValue(baseImponible);
				this.child("fdbCuotaRE1").setValue(cuota);
				break;	
			}
			case 4: {
				this.child("fdbBaseImponibleRE2").setValue(baseImponible);
				this.child("fdbCuotaRE2").setValue(cuota);
				break;	
			}
			case 1.75: {
				this.child("fdbBaseImponibleRE3").setValue(baseImponible);
				this.child("fdbCuotaRE3").setValue(cuota);
				break;	
			}
		}
	}
	
	return true;
}

function oficial_calcularCasillas48a49():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var fechaDesde:String;
	var fechaHasta:String;
	var codEjercicio:String = cursor.valueBuffer("codejercicio");
	if (codEjercicio && codEjercicio != "") {
		fechaDesde = util.sqlSelect("ejercicios", "fechainicio", "codejercicio = '" + codEjercicio + "'");
		fechaHasta = util.sqlSelect("ejercicios", "fechafin", "codejercicio = '" + codEjercicio + "'");
	}

	var qryPartidas:FLSqlQuery = new FLSqlQuery();
	qryPartidas.setTablesList("co_partidas");
	qryPartidas.setSelect("SUM(p.baseimponible), SUM(p.debe - p.haber)");
	qryPartidas.setFrom("co_asientos a INNER JOIN co_partidas p ON p.idasiento = a.idasiento");
	qryPartidas.setWhere("a.codejercicio = '" + codEjercicio + "' AND a.fecha BETWEEN '" + fechaDesde + "' AND '" + fechaHasta + "' AND p.casilla303 = '[22]-[23]'");
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
	this.child("fdbBaseImponibleoibc").setValue(baseImponible);
	this.child("fdbCuotaoibc").setValue(cuota);
	
	return true;
}

function oficial_calcularCasillas50a51():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var fechaDesde:String;
	var fechaHasta:String;
	var codEjercicio:String = cursor.valueBuffer("codejercicio");
	if (codEjercicio && codEjercicio != "") {
		fechaDesde = util.sqlSelect("ejercicios", "fechainicio", "codejercicio = '" + codEjercicio + "'");
		fechaHasta = util.sqlSelect("ejercicios", "fechafin", "codejercicio = '" + codEjercicio + "'");
	}

	var qryPartidas:FLSqlQuery = new FLSqlQuery();
	qryPartidas.setTablesList("co_partidas");
	qryPartidas.setSelect("SUM(p.baseimponible), SUM(p.debe - p.haber)");
	qryPartidas.setFrom("co_asientos a INNER JOIN co_partidas p ON p.idasiento = a.idasiento");
	qryPartidas.setWhere("a.codejercicio = '" + codEjercicio + "' AND a.fecha BETWEEN '" + fechaDesde + "' AND '" + fechaHasta + "' AND p.casilla303 = '[24]-[25]'");
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
	this.child("fdbBaseImponibleoibi").setValue(baseImponible);
	this.child("fdbCuotaoibi").setValue(cuota);
	
	return true;
}

function oficial_calcularCasillas52a53():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var fechaDesde:String;
	var fechaHasta:String;
	var codEjercicio:String = cursor.valueBuffer("codejercicio");
	if (codEjercicio && codEjercicio != "") {
		fechaDesde = util.sqlSelect("ejercicios", "fechainicio", "codejercicio = '" + codEjercicio + "'");
		fechaHasta = util.sqlSelect("ejercicios", "fechafin", "codejercicio = '" + codEjercicio + "'");
	}

	var qryPartidas:FLSqlQuery = new FLSqlQuery();
	qryPartidas.setTablesList("co_partidas");
	qryPartidas.setSelect("SUM(p.baseimponible), SUM(p.debe - p.haber)");
	qryPartidas.setFrom("co_asientos a INNER JOIN co_partidas p ON p.idasiento = a.idasiento");
	qryPartidas.setWhere("a.codejercicio = '" + codEjercicio + "' AND a.fecha BETWEEN '" + fechaDesde + "' AND '" + fechaHasta + "' AND p.casilla303 = '[26]-[27]'");
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
	this.child("fdbBaseImponibleimbc").setValue(baseImponible);
	this.child("fdbCuotaimbc").setValue(cuota);
	
	return true;
}

function oficial_calcularCasillas54a55():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var fechaDesde:String;
	var fechaHasta:String;
	var codEjercicio:String = cursor.valueBuffer("codejercicio");
	if (codEjercicio && codEjercicio != "") {
		fechaDesde = util.sqlSelect("ejercicios", "fechainicio", "codejercicio = '" + codEjercicio + "'");
		fechaHasta = util.sqlSelect("ejercicios", "fechafin", "codejercicio = '" + codEjercicio + "'");
	}

	var qryPartidas:FLSqlQuery = new FLSqlQuery();
	qryPartidas.setTablesList("co_partidas");
	qryPartidas.setSelect("SUM(p.baseimponible), SUM(p.debe - p.haber)");
	qryPartidas.setFrom("co_asientos a INNER JOIN co_partidas p ON p.idasiento = a.idasiento");
	qryPartidas.setWhere("a.codejercicio = '" + codEjercicio + "' AND a.fecha BETWEEN '" + fechaDesde + "' AND '" + fechaHasta + "' AND p.casilla303 = '[28]-[29]'");
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
	this.child("fdbBaseImponibleimbi").setValue(baseImponible);
	this.child("fdbCuotaimbi").setValue(cuota);
	
	return true;
}

function oficial_calcularCasillas56a57():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var fechaDesde:String;
	var fechaHasta:String;
	var codEjercicio:String = cursor.valueBuffer("codejercicio");
	if (codEjercicio && codEjercicio != "") {
		fechaDesde = util.sqlSelect("ejercicios", "fechainicio", "codejercicio = '" + codEjercicio + "'");
		fechaHasta = util.sqlSelect("ejercicios", "fechafin", "codejercicio = '" + codEjercicio + "'");
	}

	var qryPartidas:FLSqlQuery = new FLSqlQuery();
	qryPartidas.setTablesList("co_partidas");
	qryPartidas.setSelect("SUM(p.baseimponible), SUM(p.debe - p.haber)");
	qryPartidas.setFrom("co_asientos a INNER JOIN co_partidas p ON p.idasiento = a.idasiento");
	qryPartidas.setWhere("a.codejercicio = '" + codEjercicio + "' AND a.fecha BETWEEN '" + fechaDesde + "' AND '" + fechaHasta + "' AND p.casilla303 = '[30]-[31]'");
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
	this.child("fdbBaseImponibleaibc").setValue(baseImponible);
	this.child("fdbCuotaaibc").setValue(cuota);
	
	return true;
}

function oficial_calcularCasillas58a59():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var fechaDesde:String;
	var fechaHasta:String;
	var codEjercicio:String = cursor.valueBuffer("codejercicio");
	if (codEjercicio && codEjercicio != "") {
		fechaDesde = util.sqlSelect("ejercicios", "fechainicio", "codejercicio = '" + codEjercicio + "'");
		fechaHasta = util.sqlSelect("ejercicios", "fechafin", "codejercicio = '" + codEjercicio + "'");
	}

	var qryPartidas:FLSqlQuery = new FLSqlQuery();
	qryPartidas.setTablesList("co_partidas");
	qryPartidas.setSelect("SUM(p.baseimponible), SUM(p.debe - p.haber)");
	qryPartidas.setFrom("co_asientos a INNER JOIN co_partidas p ON p.idasiento = a.idasiento");
	qryPartidas.setWhere("a.codejercicio = '" + codEjercicio + "' AND a.fecha BETWEEN '" + fechaDesde + "' AND '" + fechaHasta + "' AND p.casilla303 = '[32]-[33]'");
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
	this.child("fdbBaseImponibleaibi").setValue(baseImponible);
	this.child("fdbCuotaaibi").setValue(cuota);
	
	return true;
}

function oficial_limpiarValores():Boolean
{
	this.child("fdbBaseImponibleRO0").setValue("");
	this.child("fdbBaseImponibleRO1").setValue("");
	this.child("fdbBaseImponibleRO2").setValue("");
	this.child("fdbCuotaRO0").setValue("");
	this.child("fdbCuotaRO1").setValue("");
	this.child("fdbCuotaRO2").setValue("");
	this.child("fdbbaseimponibleai0").setValue("");
	this.child("fdbbaseimponibleai1").setValue("");
	this.child("fdbbaseimponibleai2").setValue("");
	this.child("fdbCuotaai0").setValue("");
	this.child("fdbCuotaai1").setValue("");
	this.child("fdbCuotaai2").setValue("");
	this.child("fdbBaseImponibleRE0").setValue("");
	this.child("fdbBaseImponibleRE1").setValue("");
	this.child("fdbBaseImponibleRE2").setValue("");
	this.child("fdbBaseImponibleRE3").setValue("");
	this.child("fdbCuotaRE0").setValue("");
	this.child("fdbCuotaRE1").setValue("");
	this.child("fdbCuotaRE2").setValue("");
	this.child("fdbCuotaRE3").setValue("");
	this.child("fdbBaseImponibleoibc").setValue("");
	this.child("fdbBaseImponibleoibi").setValue("");
	this.child("fdbBaseImponibleimbc").setValue("");
	this.child("fdbBaseImponibleimbi").setValue("");
	this.child("fdbBaseImponibleaibc").setValue("");
	this.child("fdbBaseImponibleaibi").setValue("");
	this.child("fdbCuotaoibc").setValue("");
	this.child("fdbCuotaoibi").setValue("");
	this.child("fdbCuotaimbc").setValue("");
	this.child("fdbCuotaimbi").setValue("");
	this.child("fdbCuotaaibc").setValue("");
	this.child("fdbCuotaaibi").setValue("");
	return true;
}

function oficial_conectarDetalles()
{
	connect(this.child("pbnDatosRO0"), "clicked()", this, "iface.partidasDatosRO0");
	connect(this.child("pbnDatosRO1"), "clicked()", this, "iface.partidasDatosRO1");
	connect(this.child("pbnDatosRO2"), "clicked()", this, "iface.partidasDatosRO2");
	connect(this.child("pbnDatosai0"), "clicked()", this, "iface.partidasDatosai0");
	connect(this.child("pbnDatosai1"), "clicked()", this, "iface.partidasDatosai1");
	connect(this.child("pbnDatosai2"), "clicked()", this, "iface.partidasDatosai2");
	connect(this.child("pbnDatosRE0"), "clicked()", this, "iface.partidasDatosRE0");
	connect(this.child("pbnDatosRE1"), "clicked()", this, "iface.partidasDatosRE1");
	connect(this.child("pbnDatosRE2"), "clicked()", this, "iface.partidasDatosRE2");
	connect(this.child("pbnDatosRE3"), "clicked()", this, "iface.partidasDatosRE3");
	connect(this.child("pbnDatosoibc"), "clicked()", this, "iface.partidasDatosoibc");
	connect(this.child("pbnDatosibi"), "clicked()", this, "iface.partidasDatosibi");
	connect(this.child("pbnDatosimbc"), "clicked()", this, "iface.partidasDatosimbc");
	connect(this.child("pbnDatosimbi"), "clicked()", this, "iface.partidasDatosimbi");
	connect(this.child("pbnDatosaibc"), "clicked()", this, "iface.partidasDatosaibc");
	connect(this.child("pbnDatosaibi"), "clicked()", this, "iface.partidasDatosaibi");
}

function oficial_partidasDatosRO0()
{
	this.iface.mostrarPartidas("casilla303 = '[01]-[09]' AND iva = 4");
}

function oficial_partidasDatosRO1()
{
	this.iface.mostrarPartidas("casilla303 = '[01]-[09]' AND iva = 7");
}

function oficial_partidasDatosRO2()
{
	this.iface.mostrarPartidas("casilla303 = '[01]-[09]' AND iva = 16");
}

function oficial_partidasDatosai0()
{
	this.iface.mostrarPartidas("casilla303 = '[19]-[20]' AND iva = 4");
}

function oficial_partidasDatosai1()
{
	this.iface.mostrarPartidas("casilla303 = '[19]-[20]' AND iva = 7");
}

function oficial_partidasDatosai2()
{
	this.iface.mostrarPartidas("casilla303 = '[19]-[20]' AND iva = 16");
}

function oficial_partidasDatosRE0()
{
	this.iface.mostrarPartidas("casilla303 = '[10]-[18]' AND recargo = 0.5");
}

function oficial_partidasDatosRE1()
{
	this.iface.mostrarPartidas("casilla303 = '[10]-[18]' AND recargo = 1");
}

function oficial_partidasDatosRE2()
{
	this.iface.mostrarPartidas("casilla303 = '[10]-[18]' AND recargo = 4");
}

function oficial_partidasDatosRE3()
{
	this.iface.mostrarPartidas("casilla303 = '[10]-[18]' AND recargo = 1.75");
}

function oficial_partidasDatosoibc()
{
	this.iface.mostrarPartidas("casilla303 = '[22]-[23]'");
}

function oficial_partidasDatosibi()
{
	this.iface.mostrarPartidas("casilla303 = '[24]-[25]'");
}

function oficial_partidasDatosimbc()
{
	this.iface.mostrarPartidas("casilla303 = '[26]-[27]'");
}

function oficial_partidasDatosimbi()
{
	this.iface.mostrarPartidas("casilla303 = '[28]-[29]'");
}

function oficial_partidasDatosaibc()
{
	this.iface.mostrarPartidas("casilla303 = '[30]-[31]'");
}

function oficial_partidasDatosaibi()
{
	this.iface.mostrarPartidas("casilla303 = '[32]-[33]'");
}

function oficial_mostrarPartidas(filtro:String):Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	
	var f:Object = new FLFormSearchDB("co_partidas303");
	var curPartidas:FLSqlCursor = f.cursor();
	var codEjercicio:String = this.child("fdbCodEjercicio").value();

	curPartidas.setMainFilter(filtro + " AND idasiento IN (SELECT idasiento FROM co_asientos a WHERE a.codejercicio = '" + codEjercicio + "')");
	f.setMainWidget();
	var idPartida:String = f.exec("idpartida");
	if (f.accepted()) {
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
