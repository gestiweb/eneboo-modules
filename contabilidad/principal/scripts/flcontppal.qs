/***************************************************************************
                 flcontppal.qs  -  description
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
	function beforeCommit_co_regiva(curRegIVA:FLSqlCursor):Boolean {
		return this.ctx.interna_beforeCommit_co_regiva(curRegIVA); 
	}
	function afterCommit_co_regiva(curRegiva:FLSqlCursor):Boolean {
		return this.ctx.interna_afterCommit_co_regiva(curRegiva);
	}
	function beforeCommit_co_subcuentas(curSubcuenta:FLSqlCursor):Boolean {
		return this.ctx.interna_beforeCommit_co_subcuentas(curSubcuenta);
	}
	function beforeCommit_co_asientos(curAsiento:FLSqlCursor):Boolean {
		return this.ctx.interna_beforeCommit_co_asientos(curAsiento);
	}
	function beforeCommit_co_partidas(curPartida:FLSqlCursor):Boolean {
		return this.ctx.interna_beforeCommit_co_partidas(curPartida);
	}
	function afterCommit_co_partidas(curPartida:FLSqlCursor):Boolean {
		return this.ctx.interna_afterCommit_co_partidas(curPartida);
	}
	function beforeCommit_co_dotaciones(curDotacion:FLSqlCursor):Boolean {
		return this.ctx.interna_beforeCommit_co_dotaciones(curDotacion);
	}
	function afterCommit_co_dotaciones(curDotacion:FLSqlCursor):Boolean {
		return this.ctx.interna_afterCommit_co_dotaciones(curDotacion);
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var PreMemorias:Array;
	function oficial( context ) { interna( context ); }
	function ejecutarQry(tabla, campos, where, listaTablas):Array {
		return this.ctx.oficial_ejecutarQry(tabla, campos, where, listaTablas);
	}
	function valoresIniciales() {
		return this.ctx.oficial_valoresIniciales();
	}
	function generarPGC(codEjercicio) {
		return this.ctx.oficial_generarPGC(codEjercicio);
	}
	function generarCodigosBalance() {
		return this.ctx.oficial_generarCodigosBalance();
	}
	function generarSubcuentas(codEjercicio, longSubcuenta) {
		return this.ctx.oficial_generarSubcuentas(codEjercicio, longSubcuenta);
	}
	function comprobarEjercicios() {
		return this.ctx.oficial_comprobarEjercicios();
	}
	function valorPorClave(tabla, campo, where, listaTablas) {
		return this.ctx.oficial_valorPorClave(tabla, campo, where, listaTablas);
	}
	function comprobarRegIVA(idSubcuenta, idAsiento):Boolean {
		return this.ctx.oficial_comprobarRegIVA(idSubcuenta, idAsiento);
	}
	function calcularSaldo(idSubcuenta):Boolean {
		return this.ctx.oficial_calcularSaldo(idSubcuenta);
	}
	function formatearCodSubcta(curFormSubcuenta:Object, campoSubcuenta:String, longSubcuenta:Number,  posPuntoActual:Number):Number {
		return this.ctx.oficial_formatearCodSubcta(curFormSubcuenta, campoSubcuenta, longSubcuenta, posPuntoActual); 
	}
	function rellenarSubcuentas() {
		return this.ctx.oficial_rellenarSubcuentas();
	}
	function rellenarCuentaEsp() {
		return this.ctx.oficial_rellenarCuentaEsp();
	}
	function clearPreMemoria() {
		return this.ctx.oficial_clearPreMemoria();
	}
	function arrayPreMemoria():Array {
		return this.ctx.oficial_arrayPreMemoria();
	}
	function reponerArrayPreMemoria(nuevoArray:Array) {
		return this.ctx.oficial_reponerArrayPreMemoria(nuevoArray);
	}
	function putPreMemoria(nombreMemoria:String, valorMemoria:String) {
		return this.ctx.oficial_putPreMemoria(nombreMemoria, valorMemoria);
	}
	function putLugarPreMemoria(lugarOcupado:Number, nombreMemoria:String, valorMemoria:String):Number {
		return this.ctx.oficial_putLugarPreMemoria(lugarOcupado, nombreMemoria, valorMemoria);
	}
	function getPreMemoria(nombreMemoria:String):String {
		return this.ctx.oficial_getPreMemoria(nombreMemoria);
	}
	function lugarPreMemoria(nombreMemoria:String):Number {
		return this.ctx.oficial_lugarPreMemoria(nombreMemoria);
	}
	function getNombrePreMemoria(lugarOcupado:Number):String {
		return this.ctx.oficial_getNombrePreMemoria(lugarOcupado);
	}
	function cantidadPreMemoria():Number {
		return this.ctx.oficial_cantidadPreMemoria();
	}
	function siguienteNumero(codEjercicio:String, fN:String):Number {
		return this.ctx.oficial_siguienteNumero(codEjercicio, fN);
	}
	function comprobarAsiento(idAsiento:String, omitirImporte:Boolean):Boolean {
		return this.ctx.oficial_comprobarAsiento(idAsiento, omitirImporte);
	}
	function informarImporteAsiento(idAsiento:String, importe:Number):Boolean {
		return this.ctx.oficial_informarImporteAsiento(idAsiento, importe);
	}
	function generarAsientoDotacion(curDotacion:FLSqlCursor):Boolean {
		return this.ctx.oficial_generarAsientoDotacion(curDotacion);
	}
	function generarPartidasDotacion(curDotacion:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean {
		return this.ctx.oficial_generarPartidasDotacion(curDotacion, idAsiento, valoresDefecto);
	}
	function copiarCuenta(codCuenta:String, codEjercicioAnt:String, codEjercicio:String):String {
		return this.ctx.oficial_copiarCuenta(codCuenta, codEjercicioAnt, codEjercicio);
	}
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration pgc2008 */
/////////////////////////////////////////////////////////////////
//// PGC 2008 //////////////////////////////////////////////////////
class pgc2008 extends oficial {

    function pgc2008( context ) { oficial ( context ); }
	function init(init) {
		this.ctx.pgc2008_init();
	}
	function generarPGC(codEjercicio) {
		return this.ctx.pgc2008_generarPGC(codEjercicio);
	}
	function generarCodigosBalance2008() {
		return this.ctx.pgc2008_generarCodigosBalance2008();
	}
	function actualizarCuentasEspeciales(codEjercicio:String) {
		return this.ctx.pgc2008_actualizarCuentasEspeciales(codEjercicio);
	}
	function actualizarCuentas2008(codEjercicio:String) {
		return this.ctx.pgc2008_actualizarCuentas2008(codEjercicio);
	}
	function actualizarCuentas2008ba(codEjercicio:String) {
		return this.ctx.pgc2008_actualizarCuentas2008ba(codEjercicio);
	}
	function generarCuadroCuentas(codEjercicio:String) {
		return this.ctx.pgc2008_generarCuadroCuentas(codEjercicio);
	}
	
	
	function generarGrupos(codEjercicio:String) {
		return this.ctx.pgc2008_generarGrupos(codEjercicio);
	}
	function generarSubgrupos(codEjercicio:String) {
		return this.ctx.pgc2008_generarSubgrupos(codEjercicio);
	}
	function generarCuentas(codEjercicio:String) {
		return this.ctx.pgc2008_generarCuentas(codEjercicio);
	}
	function generarSubcuentas(codEjercicio:String, longSubcuenta:Number) {
		return this.ctx.pgc2008_generarSubcuentas(codEjercicio, longSubcuenta);
	}
	
	
	function generarCorrespondenciasCC(codEjercicio:String) {
		return this.ctx.pgc2008_generarCorrespondenciasCC(codEjercicio);
	}
	function convertirCodSubcuenta(codEjercicio:String, codSubcuenta90:String):String {
		return this.ctx.pgc2008_convertirCodSubcuenta(codEjercicio, codSubcuenta90);
	}
	function convertirCodCuenta(codSubcuenta90:String):String {
		return this.ctx.pgc2008_convertirCodCuenta(codSubcuenta90);
	}
	
	
	function datosGrupos():Array {
		return this.ctx.pgc2008_datosGrupos();
	}
	function datosSubgrupos():Array {
		return this.ctx.pgc2008_datosSubgrupos();
	}
	function datosCuentas():Array {
		return this.ctx.pgc2008_datosCuentas();
	}
	function datosCorrespondencias():Array {
		return this.ctx.pgc2008_datosCorrespondencias();
	}
	function datosCuentasEspeciales():Array {
		return this.ctx.pgc2008_datosCuentasEspeciales();
	}
	function datosCuentasHuerfanas():Array {
		return this.ctx.pgc2008_datosCuentasHuerfanas();
	}
	function completarTiposEspeciales():Array {
		return this.ctx.pgc2008_completarTiposEspeciales();
	}
	
	function generarOrden3CB() {
		return this.ctx.pgc2008_generarOrden3CB();
	}
	
	function regenerarPGC(codEjercicio:String) {
		return this.ctx.pgc2008_regenerarPGC(codEjercicio);
	}
	function actualizarCuentasDigitos(codEjercicio:String) {
		return this.ctx.pgc2008_actualizarCuentasDigitos(codEjercicio);
	}
}
//// PGC 2008 //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends pgc2008 {
	function head( context ) { pgc2008 ( context ); }
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration ifaceCtx */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends head {
	function ifaceCtx( context ) { head( context ); }
	function pub_ejecutarQry(tabla, campos, where, listaTablas):Array {
		return this.ejecutarQry(tabla, campos, where, listaTablas);
	}
	function pub_generarPGC(codEjercicio) {
		return this.generarPGC(codEjercicio);
	}
	function pub_generarSubcuentas(codEjercicio, longSubcuenta) {
		return this.generarSubcuentas(codEjercicio, longSubcuenta);
	}
	function pub_formatearCodSubcta(curFormSubcuenta:Object, campoSubcuenta:String, longSubcuenta:Number, posPuntoActual:Number):Number {
		return this.formatearCodSubcta(curFormSubcuenta, campoSubcuenta, longSubcuenta, posPuntoActual);
	}
	function pub_calcularSaldo(idSubcuenta):Boolean {
		return this.calcularSaldo(idSubcuenta);
	}
	function pub_clearPreMemoria() {
		return this.clearPreMemoria();
	}
	function pub_arrayPreMemoria():Array {
		return this.arrayPreMemoria();
	}
	function pub_reponerArrayPreMemoria(nuevoArray:Array) {
		return this.reponerArrayPreMemoria(nuevoArray);
	}
	function pub_putPreMemoria(nombreMemoria:String, valorMemoria:String) {
		return this.putPreMemoria(nombreMemoria, valorMemoria);
	}
	function pub_putLugarPreMemoria(lugarOcupado:Number, nombreMemoria:String, valorMemoria:String):Number {
		return this.putLugarPreMemoria(lugarOcupado, nombreMemoria, valorMemoria);
	}
	function pub_getPreMemoria(nombreMemoria:String):String {
		return this.getPreMemoria(nombreMemoria);
	}
	function pub_lugarPreMemoria(nombreMemoria:String):Number {
		return this.lugarPreMemoria(nombreMemoria);
	}
	function pub_getNombrePreMemoria(lugarOcupado:Number):String {
		return this.getNombrePreMemoria(lugarOcupado);
	}
	function pub_cantidadPreMemoria():Number {
		return this.cantidadPreMemoria();
	}
	function pub_comprobarAsiento(idAsiento:String, omitirImporte:Boolean):Boolean {
		return this.comprobarAsiento(idAsiento, omitirImporte);
	}
	function pub_copiarCuenta(codCuenta:String, codEjercicioAnt:String, codEjercicio:String):String {
		return this.copiarCuenta(codCuenta, codEjercicioAnt, codEjercicio);
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
/** \D Se comprueba si se han introducido ya los valores iniciales buscando alguna cuenta especial. Si no se encuentra, se introducen valores iniciales y se comprueban los ejercicios. Se pregunta si se desea activar la integración entre facturación y contabilidad
\end */
function interna_init()
{
	this.iface.PreMemorias = new Array(0);
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = new FLSqlCursor("co_codbalances");
	cursor.select();
	if (!cursor.first()) {
		this.iface.valoresIniciales();
		this.iface.comprobarEjercicios();
		if (util.sqlSelect("empresa", "contintegrada", "1 = 1") == false) {
			var res:Object = MessageBox.information(util.translate("scripts",  "¿Desea activar la integración entre facturación y contabilidad?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
			if (res == MessageBox.Yes) {
				var curEmpresa = new FLSqlCursor("empresa");
				curEmpresa.select();
				curEmpresa.first();
				curEmpresa.setModeAccess(curEmpresa.Edit);
				curEmpresa.refreshBuffer();
				curEmpresa.setValueBuffer("contintegrada", true);
				curEmpresa.commitBuffer();
			}
		}
	}
	this.iface.rellenarSubcuentas();
	this.iface.rellenarCuentaEsp();
}

function interna_beforeCommit_co_regiva(curRegIVA):Boolean
{
/** \C El período de regularización por iva debe pertenecer al ejercicio actual.
\end */
		var util:FLUtil = new FLUtil();
		if (curRegIVA.modeAccess() == curRegIVA.Insert
				|| curRegIVA.modeAccess() == curRegIVA.Edit) {
				var codEjercicio:String = util.sqlSelect("co_asientos", "codejercicio",
						"idasiento = " + curRegIVA.valueBuffer("idasiento"));
				var qryEjercicio:FLSqlQuery = new FLSqlQuery();
				qryEjercicio.setTablesList("ejercicios");
				qryEjercicio.setSelect("fechainicio, fechafin");
				qryEjercicio.setFrom("ejercicios");
				qryEjercicio.setWhere("codejercicio = '" + codEjercicio + "'");
				try { qryEjercicio.setForwardOnly( true ); } catch (e) {}
				if (!qryEjercicio.exec())
						return false;
				if (!qryEjercicio.next())
						return false;

				var iniRegIVA:Date = new Date(Date.parse(curRegIVA.valueBuffer("fechainicio").toString()));
				var finRegIVA:Date = new Date(Date.parse(curRegIVA.valueBuffer("fechafin").toString()));
				
				/** \C El período no puede superponerse a ningún otro período de regularización
				\end \end */
				if (util.sqlSelect("co_regiva", "idregiva",
						"fechainicio <= '" + iniRegIVA + "' AND fechafin >= '" + iniRegIVA + "'" + 
						" AND idregiva <> " + curRegIVA.valueBuffer("idregiva"))) {
						MessageBox.warning(util.translate("scripts", 
								"La fecha de inicio del período se superpone a un período ya existente"),
								MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
						return false;
				}
				if (util.sqlSelect("co_regiva", "idregiva",
						"fechainicio <= '" + finRegIVA + "' AND fechafin >= '" + iniRegIVA + "'"  + 
						" AND idregiva <> " + curRegIVA.valueBuffer("idregiva"))) {
						MessageBox.warning(util.translate("scripts", 
								"La fecha de fin del período se superpone a un período ya existente"),
								MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
						return false;
				}
		}
		
		return true;
}

/** \C
El código de subcuenta tendrá como prefijo el código de la cuenta
\end */
function interna_beforeCommit_co_subcuentas(curSubcuenta):Boolean
{
		var util:FLUtil = new FLUtil();
		switch(curSubcuenta.modeAccess()) {
		case curSubcuenta.Insert:
				if (!curSubcuenta.valueBuffer("codsubcuenta").startsWith(curSubcuenta.valueBuffer("codcuenta").toString().left(3))) {
						MessageBox.warning(util.translate("scripts",
								"El código de subcuenta debe tener como prefijo el código de la cuenta de la que depende:") + curSubcuenta.valueBuffer("codcuenta"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
						return false;
				}
		}
		return true;
}

function interna_beforeCommit_co_asientos(curAsiento):Boolean
{
	var util:FLUtil = new FLUtil();
	
	/** \C La fecha del asiento debe pertenecer a un ejercicio abierto				
		\end \end */
	switch(curAsiento.modeAccess()) {
		case curAsiento.Edit: {
			if (!util.sqlSelect("ejercicios", "codejercicio", "fechainicio <= '" + curAsiento.valueBufferCopy("fecha") + "'" +  " AND fechafin >= '" + curAsiento.valueBufferCopy("fecha") + "'" +  " AND estado = 'ABIERTO'")) {
				MessageBox.warning(util.translate("scripts", "Sólo pueden modificarse los asientos que pertenecen a un ejercicio abierto"), MessageBox.Ok, MessageBox.NoButton);
				return false;
			}
		}
		case curAsiento.Del:
		case curAsiento.Insert: {
			if (!util.sqlSelect("ejercicios", "codejercicio", "codejercicio = '" + curAsiento.valueBuffer("codejercicio") + "'" +  " AND fechainicio <= '" + curAsiento.valueBuffer("fecha") + "'" + " AND fechafin >= '" + curAsiento.valueBuffer("fecha") + "'" + " AND estado = 'ABIERTO'")) {
				MessageBox.warning(util.translate("scripts",  "El asiento contable no pertenece al período del ejercicio asignado, o el ejercicio no está abierto"), MessageBox.Ok, MessageBox.NoButton);
				return false;
			}
			if (curAsiento.modeAccess() == curAsiento.Insert || curAsiento.modeAccess() == curAsiento.Edit) {
				if (util.sqlSelect("co_asientos", "numero", "codejercicio = '" + curAsiento.valueBuffer("codejercicio") + "' AND numero = '" + curAsiento.valueBuffer("numero") + "' AND idasiento <> " + curAsiento.valueBuffer("idasiento"))) {
					//MessageBox.information(util.translate("scripts", "Ya existe un asiento con el número y ejercicio especificados.\nEl número de asiento volverá a calcularse."), MessageBox.Ok, MessageBox.NoButton);
					curAsiento.setValueBuffer("numero", this.iface.siguienteNumero(curAsiento.valueBuffer("codejercicio"), "nasiento"));
				}
			}
		}
	}

	switch(curAsiento.modeAccess()) {
		case curAsiento.Insert: {
			if (curAsiento.valueBuffer("numero") == 0) {
				numero = this.iface.siguienteNumero(curAsiento.valueBuffer("codejercicio"), "nasiento");
				if (!numero)
					return false;
				curAsiento.setValueBuffer("numero", numero);
			}
		}
	}
	return true;
}

/** \C Si la partida es de IVA, la fecha del asiento al que pertenece no puede estar incluida en un período de I.V.A. regularizado
\end \end */
function interna_beforeCommit_co_partidas(curPartida):Boolean
{
	var idSubcuenta:Number = curPartida.valueBuffer("idsubcuenta");
	var idSubcuentaPrevia:Number = curPartida.valueBufferCopy("idsubcuenta");
	var idAsiento:Number = curPartida.valueBuffer("idasiento");
	switch (curPartida.modeAccess()) {
	case curPartida.Edit: {
			if (idSubcuenta == idSubcuentaPrevia) {
				if (curPartida.valueBuffer("debe") == curPartida.valueBufferCopy("debe") && curPartida.valueBuffer("haber") == curPartida.valueBufferCopy("haber"))
					return true;
			} else {
				if (!this.iface.comprobarRegIVA(idSubcuentaPrevia, idAsiento))
					return false;
			}
		}
	case curPartida.Insert:
	case curPartida.Del: {
			if (!this.iface.comprobarRegIVA(idSubcuenta, idAsiento))
				return false;
			break;
		}
	}

	return true;
}


/** \C Recálculo del debe, haber y saldo de la correspondiente subcuenta
\end */
function interna_afterCommit_co_partidas(curPartida):Boolean
{
		var util:FLUtil = new FLUtil();
		var curAsiento:FLSqlCursor = new FLSqlCursor("co_asientos");
		var idAsiento:String = curPartida.valueBuffer("idasiento");
		var idSubcuentaPrevia:Number = curPartida.valueBufferCopy("idsubcuenta");
		var idSubcuenta:Number = curPartida.valueBuffer("idsubcuenta");
		switch (curPartida.modeAccess()) {
			case curPartida.Edit: {
				if (idSubcuenta != idSubcuentaPrevia) {
					if (!this.iface.calcularSaldo(idSubcuentaPrevia))
						return false;
				}
			}
			case curPartida.Insert:
			case curPartida.Del: {
				if (!this.iface.calcularSaldo(idSubcuenta))
					return false;
			}
		}
		return true;

}

/** \C Borra el asiento asociado al registro de regularización de I.V.A.
\end */
function interna_afterCommit_co_regiva(curRegiva):Boolean
{
	var util:FLUtil = new FLUtil;
	switch(curRegiva.modeAccess()) {
		case curRegiva.Del: {
			var curAsiento:FLSqlCursor = new FLSqlCursor("co_asientos");
			curAsiento.select("idasiento = " + curRegiva.valueBuffer("idasiento"));
			if (curAsiento.first()) {
				curAsiento.setUnLock("editable", true);
				curAsiento.setModeAccess(curAsiento.Del);
				curAsiento.refreshBuffer();
				if (!curAsiento.commitBuffer())
					return false;
			}
			break;
		}
	}
	
	return true;	
}

function interna_beforeCommit_co_dotaciones(curDotacion:FLSqlCursor):Boolean
{
	if (!this.iface.generarAsientoDotacion(curDotacion)) {
		return false;
	}
	
	return true;
}

function interna_afterCommit_co_dotaciones(curDotacion:FLSqlCursor):Boolean
{
	switch (curDotacion.modeAccess()) {
		case curDotacion.Del: {
			if (!flfacturac.iface.pub_eliminarAsiento(curDotacion.valueBuffer("idasiento")))
				return false;
			break;
		}
		case curDotacion.Edit: {
			if (curDotacion.valueBuffer("nogenerarasiento")) {
				var idAsientoAnterior:String = curDotacion.valueBufferCopy("idasiento");
				if (idAsientoAnterior && idAsientoAnterior != "") {
					if (!flfacturac.iface.pub_eliminarAsiento(idAsientoAnterior))
						return false;
				}
			}
			break;
		}
	}

	return true;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Ejecuta una query especificada
 
@param tabla Argumento de setTablesList 
@param campo Argumento de setSelect
@param tabla Argumento de setWhere
@param tabla Argumento de setFrom

@return Un array con los datos de los campos seleccionados. Un campo extra 'result' que es 1 = Ok, 0 = Error, -1 No encontrado
\end */
function oficial_ejecutarQry(tabla, campos, where, listaTablas):Array
{
		var util:FLUtil = new FLUtil;
		var campo:Array = campos.split(",");
		var valor = [];
		valor["result"] = 1;
		var query:FLSqlQuery = new FLSqlQuery();
		if (listaTablas)
				query.setTablesList(listaTablas);
		else
				query.setTablesList(tabla);
		query.setSelect(campo);
		query.setFrom(tabla);
		query.setWhere(where);
		try { query.setForwardOnly( true ); } catch (e) {}
		if (query.exec()) {
				if (query.next()) {
						for (var i = 0; i < campo.length; i++) {
								valor[campo[i]] = query.value(i);
						}
				} else {
						valor.result = -1;
				}
		} else {
				MessageBox.critical
						(util.translate("scripts", "Falló la consulta") + query.sql(),
						MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				valor.result = 0;
		}

		return valor;
}

/** \D Se dan de alta las cuentas especiales
\end */
function oficial_valoresIniciales()
{
		var datos =
				[["IVAREP","Cuentas de IVA repercutido"],
				["IVASOP","Cuentas de IVA soportado"],
				["IVARUE","Cuentas de IVA repercutido en adquisiciones intracomunitarias"],
				["IVASUE","Cuentas de IVA soportado en adquisiciones intracomunitarias"],
				["IVASIM","Cuentas de IVA soportado en importaciones"],
				["IVAEUE","Cuentas de IVA repercutido en entregas intracomunitarias"],
				["IVAREX","Cuentas de IVA repercutido para clientes exentos de IVA"],
				["IVARXP","Cuentas de IVA repercutido en exportaciones"],
				["IVAACR","Cuentas acreedoras de IVA en la regularización"],
				["IVADEU","Cuentas deudoras de IVA en la regularización"],
				["PYG","Pérdidas y ganancias"],
				["PREVIO","Cuentas relativas al ejercicio previo"],
				["CAMPOS","Cuentas de diferencias positivas de cambio"],
				["CAMNEG","Cuentas de diferencias negativas de cambio"],
				["DIVPOS","Cuentas por diferencias positivas en divisa extranjera"],
				["EURPOS","Cuentas por diferencias positivas de conversión a la moneda local"],
				["EURNEG","Cuentas por diferencias negativas de conversión a la moneda local"],
				["CLIENT","Cuentas de clientes"],
				["PROVEE","Cuentas de proveedores y acreedores"],
				["COMPRA","Cuentas de compras"],
				["VENTAS","Cuentas de ventas"],
				["CAJA","Cuentas de caja"],
				["IRPFPR","Cuentas de retenciones para proveedores IRPFPR"],
				["IRPF","Cuentas de retenciones IRPF"],
				["GTORF","Gastos por recargo financiero"],
				["INGRF","Ingresos por recargo financiero"],
				["DEVCOM","Devoluciones de compras"],
				["DEVVEN","Devoluciones de ventas"]];
				
		var cursor:FLSqlCursor = new FLSqlCursor("co_cuentasesp");
		for (i = 0; i < datos.length; i++) {
				cursor.setModeAccess(cursor.Insert);
				cursor.refreshBuffer();
				cursor.setValueBuffer("idcuentaesp", datos[i][0]);
				cursor.setValueBuffer("descripcion", datos[i][1]);
				cursor.commitBuffer();
		} 
		this.iface.generarCodigosBalance();
}

/** \D Se comprueba si el ejercicio actual tiene plan general contable asociado y, en caso de no tenerlo, se propone crearlo
\end */
function oficial_comprobarEjercicios()
{
		var util:FLUtil = new FLUtil();
		var q:FLSqlQuery = new FLSqlQuery();
		q.setTablesList("empresa,ejercicios,co_epigrafes");
		q.setSelect("ej.codejercicio, ej.nombre, ej.longsubcuenta");
		q.setFrom("empresa em INNER JOIN ejercicios ej" + 
				" ON em.codejercicio = ej.codejercicio" +
				" LEFT OUTER JOIN co_epigrafes ep" +
				" ON em.codejercicio = ep.codejercicio");
		q.setWhere("ep.codejercicio IS NULL");
		try { q.setForwardOnly( true ); } catch (e) {}
		
		if (!q.exec())
				return;
		
		var res;
		if (q.next()) {
				res = MessageBox.information(util.translate("scripts", "El ejercicio actual: ") +
						q.value(0) + "-" + q.value(1) +
						util.translate("scripts", 
						" no tiene Plan General Contable asociado\n¿desea crearlo ahora?"),
						MessageBox.Yes, MessageBox.No, MessageBox.NoButton);

				if (res == MessageBox.Yes) {
						var dialog:Dialog = new Dialog;
						dialog.okButtonText = util.translate("scripts", "Aceptar");
						dialog.cancelButtonText = util.translate("scripts", "Cancelar");
						
						var ledLongSubcuenta:SpinBox = new SpinBox;
						ledLongSubcuenta.value = q.value(2);
						ledLongSubcuenta.minimum = 5;
						ledLongSubcuenta.maximum = 15;
						ledLongSubcuenta.label = "Número de dígitos de subcuenta: ";
						dialog.add(ledLongSubcuenta);
						
						if(dialog.exec()) {
								var curEjercicio:FLSqlCursor = new FLSqlCursor("ejercicios");
								curEjercicio.select("codejercicio = '" + q.value(0) + "'");
								curEjercicio.first();
								curEjercicio.setModeAccess(curEjercicio.Edit);
								curEjercicio.refreshBuffer();
								curEjercicio.setValueBuffer("longsubcuenta", ledLongSubcuenta.value);
								if (!curEjercicio.commitBuffer())
										return false;
						} else
								return false;

						this.iface.generarPGC(q.value(0));
						this.iface.generarSubcuentas(q.value(0), ledLongSubcuenta.value);
				}
		}
}

/** \D Se comienza la creación de un nuevo plan general contable. Se introducen cuentas y epígrafes
@param codEjercicio Código del ejercicio sobre el que se genera el PGC
\end */
function oficial_generarPGC(codEjercicio)
{
		var util:FLUtil = new FLUtil();
		
		var numCuentasEsp:Number = this.iface.valorPorClave("co_cuentasesp", "count(idcuentaesp)", "1 = 1");
		if (numCuentasEsp == 0) this.iface.valoresIniciales();
		
		var curEpi:FLSqlCursor = new FLSqlCursor("co_epigrafes");
		var curCue:FLSqlCursor = new FLSqlCursor("co_cuentas");
		
		var datos =	[["1","1. FINANCIACION BASICA","EPI","1","","1","",""],
				["2","10. CAPITAL","EPI","10","1","10","",""],
				["1","100. Capital social","CUE","100","2","10","","P-A-I"],
				["2","1000. Capital ordinario","CUE","1000","2","10","","P-A-I"],
				["3","1001. Capital privilegiado","CUE","1001","2","10","","P-A-I"],
				["4","1002. Capital sin derecho a voto","CUE","1002","2","10","","P-A-I"],
				["5","1003. Capital con derechos restringidos","CUE","1003","2","10","","P-A-I"],
				["6","101. Fondo social","CUE","101","2","10","","P-A-I"],
				["7","102. Capital","CUE","102","2","10","","P-A-I"],
				["3","11. RESERVAS","EPI","11","1","11","",""],
				["8","110. Prima de emision de acciones","CUE","110","3","11","","P-A-II"],
				["9","111. Reservas de revalorización","CUE","111","3","11","","P-A-III"],
				["10","112. Reserva legal","CUE","112","3","11","","P-A-IV-1"],
				["11","113. Reservas especiales","CUE","113","3","11","","P-A-IV-5"],
				["12","114. Reservas para acciones de la sociedad dominante","CUE","114","3","11","","P-A-IV-3"],
				["13","115. Reservas para acciones propias","CUE","115","3","11","","P-A-IV-2"],
				["14","116. Reservas estatutarias","CUE","116","3","11","","P-A-IV-4"],
				["15","117. Reservas voluntarias","CUE","117","3","11","","P-A-IV-5"],
				["16","118. Reserva por capital amortizado","CUE","118","3","11","","P-A-IV-5"],
				["17","119. Diferencias por ajuste del capital a euros","CUE","119","3","11","","P-A-IV-5"],
				["4","12. RESULTADOS PENDIENTES DE APLICACION","EPI","12","1","12","",""],
				["18","120. Remanente","CUE","120","4","12","PREVIO","P-A-V-1"],
				["19","121. Resultados negativos de ejercicios anteriores","CUE","121","4","12","PREVIO","P-A-V-2"],
				["20","122. Aportaciones de socios para compensación de pérdidas","CUE","122","4","12","","P-A-V-3"],
				["21","129. Pérdidas y Ganancias","CUE","129","4","12","PYG","P-A-VI"],
				["5","13. INGRESOS A DISTRIBUIR EN VARIOS EJERCICIOS","EPI","13","1","13","",""],
				["22","130. Subvenciones oficiales de capital","CUE","130","5","13","","P-B-I"],
				["23","1300. Subvenciones del Estado","CUE","1300","5","13","","P-B-I"],
				["24","1301. Subvenciones de otras Administraciones Públicas","CUE","1301","5","13","","P-B-I"],
				["25","131. Subvenciones de capital","CUE","131","5","13","","P-B-I"],
				["26","135. Ingresos por intereses diferidos","CUE","135","5","13","","P-B-III"],
				["27","136. Diferencias positivas en moneda extranjera","CUE","136","5","13","DIVPOS","P-B-II"],
				["28","137. Ingresos fiscales por diferencias permantes a distribuir en varios ejercicios","CUE","137","5","13","","P-B-IV"],
				["29","138. Ingresos fiscales por deducciones y bonificaciones fiscales a distribuir en varios ejercicios","CUE","138","5","13","","P-B-IV"],
				["6","14. PROVISIONES PARA RIESGOS Y GASTOS","EPI","14","1","14","",""],
				["30","140. Provisión para pensiones y obligaciones similares","CUE","140","6","14","","P-C-I"],
				["31","141. Provisión para impuestos","CUE","141","6","14","","P-C-II"],
				["32","142. Provisión para responsabilidades","CUE","142","6","14","","P-C-III"],
				["33","143. Provisión para grandes reparaciones","CUE","143","6","14","","P-C-III"],
				["34","144. Fondo de reversión","CUE","144","6","14","","P-C-IV"],
				["7","15. EMPRESTITOS Y OTRAS EMISIONES ANALOGAS","EPI","15","1","15","",""],
				["35","150. Obligaciones y bonos","CUE","150","7","15","","P-D-I-1"],
				["36","1500. Obligaciones y bonos simples","CUE","1500","7","15","","P-D-I-1"],
				["37","1501. Obligaciones y bonos garantizados","CUE","1501","7","15","","P-D-I-1"],
				["38","1502. Obligaciones y bonos subordinados","CUE","1502","7","15","","P-D-I-1"],
				["39","1503. Obligaciones y bonos cupón cero","CUE","1503","7","15","","P-D-I-1"],
				["40","1504. Obligaciones y bonos con opción de adquisición de acciones","CUE","1504","7","15","","P-D-I-1"],
				["41","1505. Obligaciones y bonos con participación en beneficios","CUE","1505","7","15","","P-D-I-1"],
				["42","151. Obligaciones y bonos convertibles","CUE","151","7","15","","P-D-I-2"],
				["43","155. Deudas representadas en otros valores negociables","CUE","155","7","15","","P-D-I-3"],
				["8","16. DEUDAS LARGO PLAZO CON EMPRESAS DEL GRUPO Y ASOCIADAS","EPI","16","1","16","",""],
				["44","160. Deudas a largo plazo con empresas del grupo","CUE","160","8","16","","P-D-III-1"],
				["45","1600. Préstamos a largo plazo de empresas del grupo","CUE","1600","8","16","","P-D-III-1"],
				["46","1608. Deudas a l/p con empresas del grupo por efecto impositivo","CUE","1608","8","16","","P-D-III-1"],
				["47","1609. Otras deudas a largo plazo con empresas del grupo","CUE","1609","8","16","","P-D-III-1"],
				["48","161. Deudas a largo plazo con empresas asociadas","CUE","161","8","16","","P-D-III-2"],
				["49","162. Deudas a l/p con entidades de crédito del grupo","CUE","162","8","16","","P-D-III-1"],
				["50","163. Deudas a l/p con entidades de crédito asociadas","CUE","163","8","16","","P-D-III-2"],
				["51","164. Proveedores de inmovilizado a l/p, empresas grupo","CUE","164","8","16","","P-D-III-1"],
				["52","165. Proveedores de inmovilizado l/p, empresas asociadas","CUE","165","8","16","","P-D-III-2"],
				["9","17. DEUDAS A LARGO PLAZO POR PRESTAMOS RECIBIDOS Y OTROS CONCEPTOS","EPI","17","1","17","",""],
				["53","170. Deudas a largo plazo con entidades de crédito","CUE","170","9","17","","P-D-II-1"],
				["54","1700. Préstamos a largo plazo de entidades de crédito","CUE","1700","9","17","","P-D-II-1"],
				["55","1709. Otras deudas a largo plazo con entidades de crédito","CUE","1709","9","17","","P-D-II-1"],
				["56","171. Deudas a largo plazo","CUE","171","9","17","","P-D-IV-2"],
				["57","172. Deudas a largo plazo transformables en subvenciones","CUE","172","9","17","","P-D-IV-2"],
				["58","173. Proveedores de inmovilizado a largo plazo","CUE","173","9","17","","P-D-IV-2"],
				["59","174. Efectos a pagar a largo plazo","CUE","174","9","17","","P-D-IV-1"],
				["10","18. FIANZAS Y DEPOSITOS RECIBIDOS A LARGO PLAZO","EPI","18","1","18","",""],
				["60","180. Fianzas recibidas a largo plazo","CUE","180","10","18","","P-D-IV-3"],
				["61","185. Depósitos recibidos a largo plazo","CUE","185","10","18","","P-D-IV-3"],
				["11","19. SITUACIONES TRANSITORIAS DE FINANCIACION","EPI","19","1","19","",""],
				["62","190. Accionistas por desembolsos no exigidos","CUE","190","11","19","","A-A"],
				["63","191. Accionistas por desembolsos no exigidos, empresas del grupo","CUE","191","11","19","","A-A"],
				["64","192. Accionistas por desembolsos no exigidos, empresas asociadas","CUE","192","11","19","","A-A"],
				["65","193. Accionistas por aportaciones no dinerarias pendientes","CUE","193","11","19","","A-A"],
				["66","194. Accionistas por aportaciones no dinerarias pendientes, empresas del grupo","CUE","194","11","19","","A-A"],
				["67","195. Accionistas por aportaciones no dinerarias pendientes, empresas asociadas","CUE","195","11","19","","A-A"],
				["68","196. Socios, parte no desembolsada","CUE","196","11","19","","A-A"],
				["69","198. Acciones propias en situaciones especiales","CUE","198","11","19","","A-B-V"],
				["70","199. Acciones propias para reducción de capital","CUE","199","11","19","","P-A-VIII"],
				["12","2. INMOVILIZADO","EPI","2","","2","",""],
				["13","20. GASTOS DE ESTABLECIMIENTO","EPI","20","12","20","",""],
				["71","200. Gastos de constitución","CUE","200","13","20","","A-B-I"],
				["72","201. Gastos de primer establecimiento","CUE","201","13","20","","A-B-I"],
				["73","202. Gastos de ampliación de capital","CUE","202","13","20","","A-B-I"],
				["14","21. INMOVILIZACIONES INMATERIALES","EPI","21","12","21","",""],
				["74","210. Gastos de investigación y desarrollo","CUE","210","14","21","","A-B-II-1"],
				["75","2100. Gastos de I+D en proyectos no terminados","CUE","2100","14","21","","A-B-II-1"],
				["76","2101. Gastos de I+D en proyectos terminados","CUE","2101","14","21","","A-B-II-1"],
				["77","211. Concesiones administrativas","CUE","211","14","21","","A-B-II-2"],
				["78","212. Propiedad industrial","CUE","212","14","21","","A-B-II-2"],
				["79","213. Fondo de comercio","CUE","213","14","21","","A-B-II-3"],
				["80","214. Derechos de traspaso","CUE","214","14","21","","A-B-II-4"],
				["81","215. Aplicaciones informáticas","CUE","215","14","21","","A-B-II-5"],
				["82","217. Derechos sobre bienes en régimen de arrendamiento financiero","CUE","217","14","21","","A-B-II-6"],
				["83","219. Anticipos para inmovilizaciones inmateriales","CUE","219","14","21","","A-B-II-7"],
				["15","22. INMOVILIZACIONES MATERIALES","EPI","22","12","22","",""],
				["84","220. Terrenos y bienes naturales","CUE","220","15","22","","A-B-III-1"],
				["85","221. Construcciones","CUE","221","15","22","","A-B-III-1"],
				["86","222. Instalaciones técnicas","CUE","222","15","22","","A-B-III-2"],
				["87","223. Maquinaria","CUE","223","15","22","","A-B-III-2"],
				["88","224. Utillaje","CUE","224","15","22","","A-B-III-3"],
				["89","225. Otras instalaciones","CUE","225","15","22","","A-B-III-3"],
				["90","226. Mobiliario","CUE","226","15","22","","A-B-III-3"],
				["91","227. Equipos para procesos de información","CUE","227","15","22","","A-B-III-5"],
				["92","228. Elementos de transporte","CUE","228","15","22","","A-B-III-5"],
				["93","229. Otro inmovilizado material","CUE","229","15","22","","A-B-III-5"],
				["16","23. INMOVILIZACIONES MATERIALES EN CURSO","EPI","23","12","23","",""],
				["94","230. Adaptación de terrenos y de bienes naturales","CUE","230","16","23","","A-B-III-4"],
				["95","231. Construcciones en curso","CUE","231","16","23","","A-B-III-4"],
				["96","232. Instalaciones técnicas en montaje","CUE","232","16","23","","A-B-III-4"],
				["97","233. Maquinaria en montaje","CUE","233","16","23","","A-B-III-4"],
				["98","237. Equipos para procesos de información en montaje","CUE","237","16","23","","A-B-III-4"],
				["99","239. Anticipos para inmovilizaciones materiales","CUE","239","16","23","","A-B-III-4"],
				["17","24. INVERSIONES FINANCIERAS EN EMPRESAS DEL GRUPO Y ASOCIADAS","EPI","24","12","24","",""],
				["100","240. Participaciones en empresas del grupo","CUE","240","17","24","","A-B-IV-1"],
				["101","241. Participaciones en empresas asociadas","CUE","241","17","24","","A-B-IV-3"],
				["102","242. Valores de renta fija de empresas del grupo","CUE","242","17","24","","A-B-IV-2"],
				["103","243. Valores de renta fija de empresas asociadas","CUE","243","17","24","","A-B-IV-4"],
				["104","244. Créditos a largo plazo a empresas del grupo","CUE","244","17","24","","A-B-IV-2"],
				["105","2448. Créditos a l/p con empresas del grupo por efecto impositivo","CUE","2448","17","24","","A-B-IV-2"],
				["106","245. Créditos a largo plazo a empresas asociadas","CUE","245","17","24","","A-B-IV-4"],
				["107","246. Intereses a l/p de inversiones financieras en empresas del grupo","CUE","246","17","24","","A-B-IV-2"],
				["108","247. Intereses a l/p de inversiones financieras en empresas asociadas","CUE","247","17","24","","A-B-IV-4"],
				["109","248. Desembolsos pendientes sobre acciones de empresas del grupo","CUE","248","17","24","","P-D-V-1"],
				["110","249. Desembolsos pendientes sobre acciones de empresas asociadas","CUE","249","17","24","","P-D-V-2"],
				["18","25. OTRAS INVERSIONES FINANCIERAS PERMANENTES","EPI","25","12","25","",""],
				["111","250. Inversiones financieras permanentes en capital","CUE","250","18","25","","A-B-IV-5"],
				["112","2500. Inversiones financieras permantes en acciones con cotización en mercado secundario organizado","CUE","2500","18","25","","A-B-IV-5"],
				["113","2501. Inversiones financieras permantes en acciones sin cotización en mercado secundario organizado","CUE","2501","18","25","","A-B-IV-5"],
				["114","2502. Otras inversiones financieras en capital","CUE","2502","18","25","","A-B-IV-5"],
				["115","251. Valores de renta fija","CUE","251","18","25","","A-B-IV-5"],
				["116","2158. Participación en Fondos de Inversión en Activos del Mercado Monetario a l/p","CUE","2158","14","21","","A-B-IV-5"],
				["117","252. Créditos a largo plazo","CUE","252","18","25","","A-B-IV-6"],
				["118","253. Créditos a l/p por enajenación de inmovilizado","CUE","253","18","25","","A-B-IV-6"],
				["119","254. Creditos a largo plazo al personal","CUE","254","18","25","","A-B-IV-6"],
				["120","256. Intereses a largo plazo de valores de renta fija","CUE","256","18","25","","A-B-IV-5"],
				["121","257. Intereses a largo plazo de créditos","CUE","257","18","25","","A-B-IV-6"],
				["122","258. Imposiciones a largo plazo","CUE","258","18","25","","A-B-IV-6"],
				["123","259. Desembolsos pendientes sobre acciones","CUE","259","18","25","","P-D-V-3"],
				["19","26. FIANZAS Y DEPOSITOS CONSTITUIDOS A LARGO PLAZO","EPI","26","12","26","",""],
				["124","260. Fianzas constituidas a largo plazo","CUE","260","19","26","","A-B-IV-7"],
				["125","265. Depositos constituidos a largo plazo","CUE","265","19","26","","A-B-IV-7"],
				["20","27. GASTOS A DISTRIBUIR EN VARIOS EJERCICIOS","EPI","27","12","27","",""],
				["126","270. Gastos de formalización de deudas","CUE","270","20","27","","A-C"],
				["127","271. Gastos por intereses diferidos de valores negociables","CUE","271","20","27","","A-C"],
				["128","272. Gastos por intereses diferidos","CUE","272","20","27","","A-C"],
				["21","28. AMORTIZACION ACUMULADA DEL INMOVILIZADO","EPI","28","12","28","",""],
				["129","281. Amortización acumulada del inmovilizado inmaterial","CUE","281","21","28","","A-B-II-9"],
				["130","2810. Amortización acumulada de gastos de I+D","CUE","2810","21","28","","A-B-II-9"],
				["131","2811. Amortización acumulada de concesiones administrativas","CUE","2811","21","28","","A-B-II-9"],
				["132","2812. Amortización acumulada de propiedad industrial","CUE","2812","21","28","","A-B-II-9"],
				["133","2813. Amortización acumulada de fondo de comercio","CUE","2813","21","28","","A-B-II-9"],
				["134","2814. Amortización acumulada de derechos de traspaso","CUE","2814","21","28","","A-B-II-9"],
				["135","2815. Amortización acumulada de aplicaciones informáticas","CUE","2815","21","28","","A-B-II-9"],
				["136","2817. Amortización acumulada de derechos sobre bienes en régimen de arrendamiento financiero","CUE","2817","21","28","","A-B-II-9"],
				["137","282. Amortización acumulada del inmovilizado material","CUE","282","21","28","","A-B-III-7"],
				["138","2821. Amortización acumulada de construcciones","CUE","2821","21","28","","A-B-III-7"],
				["139","2822. Amortización acumulada de instalaciones técnicas","CUE","2822","21","28","","A-B-III-7"],
				["140","2823. Amortización acumulada de maquinaria","CUE","2823","21","28","","A-B-III-7"],
				["141","2824. Amortización acumulada de utillaje","CUE","2824","21","28","","A-B-III-7"],
				["142","2825. Amortización acumulada de otras instalaciones","CUE","2825","21","28","","A-B-III-7"],
				["143","2826. Amortización acumulada de mobiliario","CUE","2826","21","28","","A-B-III-7"],
				["144","2827. Amortización acumulada de equipos para procesos informáticos","CUE","2827","21","28","","A-B-III-7"],
				["145","2828. Amortización acumulada de elementos de transporte","CUE","2828","21","28","","A-B-III-7"],
				["146","2829. Amortización acumulada de otro inmovilizado material","CUE","2829","21","28","","A-B-III-7"],
				["22","29. PROVISIONES DE INMOVILIZADO","EPI","29","12","29","",""],
				["147","291. Provisión por depreciación inmovilizado inmaterial","CUE","291","22","29","","A-B-II-8"],
				["148","292. Provisión por depreciación inmovilizado material","CUE","292","22","29","","A-B-III-6"],
				["149","293. Provisión por depreciación valores negociables l/p de empresas del grupo","CUE","293","22","29","","A-B-IV-8"],
				["150","2930. Provisión por depreciación participaciones en capital l/p de empresas del grupo","CUE","2930","22","29","","A-B-IV-8"],
				["151","2935. Provisión por depreciación valores renta fija l/p de empresas del grupo","CUE","2935","22","29","","A-B-IV-8"],
				["152","294. Provisión por depreciación valores negociables l/p de empresas asociadas","CUE","294","22","29","","A-B-IV-8"],
				["153","2941. Provisión por depreciación participaciones en capital l/p de empresas asociadas","CUE","2941","22","29","","A-B-IV-8"],
				["154","2946. Provisión por depreciación valores renta fija l/p de empresas asociadas","CUE","2946","22","29","","A-B-IV-8"],
				["155","295. Provisión para insolvencias de creditos l/p a empresas del grupo","CUE","295","22","29","","A-B-IV-8"],
				["156","296. Provisión para insolvencias de creditos l/p a empresasa asociadas","CUE","296","22","29","","A-B-IV-8"],
				["157","297. Provisión por depreciación de valores negociables l/p","CUE","297","22","29","","A-B-IV-8"],
				["158","298. Provisión para insolvencias de créditos a l/p","CUE","298","22","29","","A-B-IV-8"],
				["23","3. EXISTENCIAS","EPI","3","","3","",""],
				["24","30. COMERCIALES","EPI","30","23","30","",""],
				["159","300. Mercaderias A","CUE","300","24","30","","A-D-II-1"],
				["160","301. Mercaderias B","CUE","301","24","30","","A-D-II-1"],
				["25","31. MATERIAS PRIMAS","EPI","31","23","31","",""],
				["161","310. Materias primas A","CUE","310","25","31","","A-D-II-2"],
				["162","311. Materias primas B","CUE","311","25","31","","A-D-II-2"],
				["26","32. OTROS APROVISIONAMIENTOS","EPI","32","23","32","",""],
				["163","320. Elementos y conjuntos incorporables","CUE","320","26","32","","A-D-II-2"],
				["164","321. Combustibles","CUE","321","26","32","","A-D-II-2"],
				["165","322. Repuestos","CUE","322","26","32","","A-D-II-2"],
				["166","325. Materiales diversos","CUE","325","26","32","","A-D-II-2"],
				["167","326. Embalajes","CUE","326","26","32","","A-D-II-2"],
				["168","327. Envases","CUE","327","26","32","","A-D-II-2"],
				["169","328. Material de oficina","CUE","328","26","32","","A-D-II-2"],
				["27","33. PRODUCTOS EN CURSO","EPI","33","23","33","",""],
				["170","330. Productos en curso A","CUE","330","27","33","","A-D-II-3"],
				["171","331. Productos en curso B","CUE","331","27","33","","A-D-II-3"],
				["28","34. PRODUCTOS SEMITERMINADOS","EPI","34","23","34","",""],
				["172","340. Productos semiterminados A","CUE","340","28","34","","A-D-II-3"],
				["173","341. Productos semiterminados B","CUE","341","28","34","","A-D-II-3"],
				["29","35. PRODUCTOS TERMINADOS","EPI","35","23","35","",""],
				["174","350. Productos terminados A","CUE","350","29","35","","A-D-II-4"],
				["175","351. Productos terminados B","CUE","351","29","35","","A-D-II-4"],
				["30","36. SUBPRODUCTOS, RESIDUOS Y MATERIALES RECUPERADOS","EPI","36","23","36","",""],
				["176","360. Subproductos A","CUE","360","30","36","","A-D-II-5"],
				["177","361. Subproductos B","CUE","361","30","36","","A-D-II-5"],
				["178","365. Residuos A","CUE","365","30","36","","A-D-II-5"],
				["179","366. Residuos B","CUE","366","30","36","","A-D-II-5"],
				["180","368. Materiales recuperados A","CUE","368","30","36","","A-D-II-5"],
				["181","369. Materiales recuperados B","CUE","369","30","36","","A-D-II-5"],
				["31","39. PROVISIONES POR DEPRECIACION DE EXISTENCIAS","EPI","39","23","39","",""],
				["182","390. Provisión por depreciación de mercaderías","CUE","390","31","39","","A-D-II-7"],
				["183","391. Provisión por depreciación de materias primas","CUE","391","31","39","","A-D-II-7"],
				["184","392. Provisión por depreciación de otros aprovisionamientos","CUE","392","31","39","","A-D-II-7"],
				["185","393. Provisión por depreciación de productos en curso","CUE","393","31","39","","A-D-II-7"],
				["186","394. Provisión por depreciación de productos semiterminados","CUE","394","31","39","","A-D-II-7"],
				["187","395. Provisión por depreciación de productos terminado","CUE","395","31","39","","A-D-II-7"],
				["188","396. Provisión por depreciación de subproductos,residuos y materiales recuperados","CUE","396","31","39","","A-D-II-7"],
				["32","4. ACREEDORES Y DEUDORES POR OPERACIONES DE TRAFICO","EPI","4","","4","",""],
				["33","40. PROVEEDORES","EPI","40","32","40","",""],
				["189","400. Proveedores","CUE","400","33","40","PROVEE","P-E-IV-2"],
				["191","4004. Proveedores (moneda extranjera)","CUE","4004","33","40","PROVEE","P-E-IV-2"],
				["192","4009. Proveedores facturas pendientes de recibir o formalizar","CUE","4009","33","40","PROVEE","P-E-IV-2"],
				["193","401. Proveedores, efectos comerciales a pagar","CUE","401","33","40","PROVEE","P-E-IV-3"],
				["194","402. Proveedores, empresas del grupo","CUE","402","33","40","PROVEE","P-E-III-1"],
				["195","4020. Proveedores, empresas del grupo (euros)","CUE","4020","33","40","PROVEE","P-E-III-1"],
				["196","4021. Efectos comerciales a pagar, empresas del grupo","CUE","4021","33","40","PROVEE","P-E-III-1"],
				["197","4024. Proveedores, empresas del grupo (moneda extranjera","CUE","4024","33","40","PROVEE","P-E-III-1"],
				["198","4026. Envases y embalajes a devolver a proveedores, empresas del grupo","CUE","4026","33","40","PROVEE","P-E-III-1"],
				["199","4029. Proveedores, empresas del grupo,facturas pendientes de recibir o formalizar","CUE","4029","33","40","PROVEE","P-E-III-1"],
				["200","403. Proveedores, empresas asociadas","CUE","403","33","40","PROVEE","P-E-III-2"],
				["201","406. Envases y embalajes a devolver a proveedores","CUE","406","33","40","PROVEE","P-E-IV-2"],
				["202","407. Anticipos a proveedores","CUE","407","33","40","PROVEE","A-D-II-6"],
				["34","41. ACREEDORES VARIOS","EPI","41","32","41","",""],
				["203","410. Acreedores por prestaciones de servicios","CUE","410","34","41","PROVEE","P-E-IV-2"],
				["204","4100. Acreedores por prestaciones de servicios (euros)","CUE","4100","34","41","PROVEE","P-E-IV-2"],
				["205","4104. Acreedores por prestaciones de servicios (moneda extranjera)","CUE","4104","34","41","PROVEE","P-E-IV-2"],
				["206","4109. Acreedores por prestaciones de servicios,facturas pendientes de recibir o formalizar","CUE","4109","34","41","PROVEE","P-E-IV-2"],
				["207","411. Acreedores, efectos comerciales a pagar","CUE","411","34","41","PROVEE","P-E-IV-3"],
				["208","419. Acreedores por operaciones en común","CUE","419","34","41","PROVEE","P-E-IV-2"],
				["35","43. CLIENTES","EPI","43","32","43","",""],
				["209","430. Clientes","CUE","430","35","43","CLIENT","A-D-III-1"],
				["211","4304. Clientes (moneda extranjera)","CUE","4304","35","43","CLIENT","A-D-III-1"],
				["212","4309. Clientes, facturas pendientes de formalizar","CUE","4309","35","43","CLIENT","A-D-III-1"],
				["213","431. Clientes, efectos comerciales a cobrar","CUE","431","35","43","CLIENT","A-D-III-1"],
				["214","4310. Efectos comerciales en cartera","CUE","4310","35","43","CLIENT","A-D-III-1"],
				["215","4311. Efectos comerciales descontados","CUE","4311","35","43","CLIENT","A-D-III-1"],
				["216","4312. Efectos comerciales en gestión de cobro","CUE","4312","35","43","CLIENT","A-D-III-1"],
				["217","4315. Efectos comerciales impagados","CUE","4315","35","43","CLIENT","A-D-III-1"],
				["218","432. Clientes, empresas del grupo","CUE","432","35","43","CLIENT","A-D-III-2"],
				["219","4320. Clientes, empresas del grupo (euros)","CUE","4320","35","43","CLIENT","A-D-III-2"],
				["220","4321. Efectos comerciales a cobrar, empresas del grupo","CUE","4321","35","43","CLIENT","A-D-III-2"],
				["221","4324. Clientes, empresas del grupo (moneda extranjera)","CUE","4324","35","43","CLIENT","A-D-III-2"],
				["222","4326. Envases y embalajes a devolver a clientes, empresas del grupo","CUE","4326","35","43","CLIENT","A-D-III-2"],
				["223","4329. Clientes, empresas del grupo, facturas pendientes formalizar","CUE","4329","35","43","CLIENT","A-D-III-2"],
				["224","433. Clientes, empresas asociadas","CUE","433","35","43","CLIENT","A-D-III-3"],
				["225","435. Clientes de dudoso cobro","CUE","435","35","43","CLIENT","A-D-III-1"],
				["226","436. Envases y embalajes a devolver por clientes","CUE","436","35","43","CLIENT","A-D-III-1"],
				["227","437. Anticipos de clientes","CUE","437","35","43","CLIENT","P-E-IV-1"],
				["36","44. DEUDORES VARIOS","EPI","44","32","44","",""],
				["228","440. Deudores","CUE","440","36","44","CLIENT","A-D-III-4"],
				["229","4400. Deudores (euros)","CUE","4400","36","44","CLIENT","A-D-III-4"],
				["230","4404. Deudores (moneda extranjera)","CUE","4404","36","44","CLIENT","A-D-III-4"],
				["231","4409. Deudores, facturas pendientes de formalizar","CUE","4409","36","44","CLIENT","A-D-III-4"],
				["232","441. Deudores, efectos comerciales a cobrar","CUE","441","36","44","CLIENT","A-D-III-4"],
				["233","4410. Deudores, efectos comerciales en cartera","CUE","4410","36","44","CLIENT","A-D-III-4"],
				["234","4411. Deudores, efectos comerciales descontados","CUE","4411","36","44","CLIENT","A-D-III-4"],
				["235","4412. Deudores, efectos comerciales en gestión de cobro","CUE","4412","36","44","CLIENT","A-D-III-4"],
				["236","4415. Deudores, efectos comerciales impagados","CUE","4415","36","44","CLIENT","A-D-III-4"],
				["237","445. Deudores de dudoso cobro","CUE","445","36","44","CLIENT","A-D-III-4"],
				["238","449. Deudores por operaciones en común","CUE","449","36","44","CLIENT","A-D-III-4"],
				["37","46. PERSONAL","EPI","46","32","46","",""],
				["239","460. Anticipos de remuneraciones","CUE","460","37","46","","A-D-III-5"],
				["240","465. Remuneraciones pendientes de pago","CUE","465","37","46","","P-E-V-4"],
				["38","47. ADMINISTRACIONES PUBLICAS","EPI","47","32","47","",""],
				["241","470. Hacienda Pública, deudor por diversos conceptos","CUE","470","38","47","IVADEU","A-D-III-6"],
				["242","4700. Hacienda Pública, deudor por IVA","CUE","4700","38","47","IVADEU","A-D-III-6"],
				["243","4707. Hacienda Pública, deudor por IGIC","CUE","4707","38","47","","A-D-III-6"],
				["244","47070. Hacienda Pública, deudor por IGIC","CUE","47070","38","47","","A-D-III-6"],
				["245","47071. Hacienda Pública, deudor por IGIC régimen transitorio, circulante","CUE","47071","38","47","","A-D-III-6"],
				["246","47072. Hacienda Pública, deudor por IGIC régimen transitorio, inversión","CUE","47072","38","47","","A-D-III-6"],
				["247","4708. Hacienda Pública, deudor por subvenciones concedidas","CUE","4708","38","47","","A-D-III-6"],
				["248","4709. Hacienda Pública, deudor por devolución impuestos","CUE","4709","38","47","","A-D-III-6"],
				["249","471. Organismos de la Seguridad Social, deudores","CUE","471","38","47","","A-D-III-6"],
				["250","472. Hacienda Publica, IVA soportado","CUE","472","38","47","IVASOP","A-D-III-6"],
				["251","4720. IVA soportado","CUE","4720","38","47","IVASOP","A-D-III-6"],
				["252","4727. IGIC soportado","CUE","4727","38","47","","A-D-III-6"],
				["253","473. Hacienda Pública, retenciones y pagos a cuenta","CUE","473","38","47","","P-E-V-1"],
				["254","4732. Hacienda Pública, retenciones y pagos a cuenta","CUE","4732","38","47","","P-E-V-1"],
				["255","474. Impuesto sobre beneficios anticipado y compensación de pérdidas","CUE","474","38","47","","A-D-III-6"],
				["256","4740. Impuesto sobre beneficios anticipado","CUE","4740","38","47","","A-D-III-6"],
				["257","4741. Impuestos sobre beneficios anticipado a l/p","CUE","4741","38","47","","A-D-III-6"],
				["258","4745. Crédito por pérdidas a compensar del ejercicio....","CUE","4745","38","47","","A-D-III-6"],
				["259","4746. Crédito por pérdidas a compensar del ejercicio..a l/p","CUE","4746","38","47","","A-D-III-6"],
				["260","4748. Impuesto sobre beneficios anticipado por operaciones intra-grupo","CUE","4748","38","47","","A-D-III-6"],
				["261","4749. Crédito por perdidas a compensar en régimen de declaración consolidada del ejercicio...","CUE","4749","38","47","","A-D-III-6"],
				["262","475. Hacienda Pública, acreedor por conceptos fiscales","CUE","475","38","47","IVAACR","P-E-V-1"],
				["263","4750. Hacienda Pública, acreedor por IVA","CUE","4750","38","47","IVAACR","P-E-V-1"],
				["264","4751. Hacienda Pública, acreedor por retenciones practicadas","CUE","4751","38","47","IRPFPR","P-E-V-1"],
				["265","4752. Hacienda Pública, acreedor por impuesto sobre sociedades","CUE","4752","38","47","","P-E-V-1"],
				["266","4757. Hacienda Pública, acreedor por IGIC","CUE","4757","38","47","","P-E-V-1"],
				["267","4758. Hacienda Pública, acreedor por subvenciones a reintegrar","CUE","4758","38","47","","P-E-V-1"],
				["268","476. Organismos de la Seguridad Social, acreedores","CUE","476","38","47","","P-E-V-1"],
				["269","477. Hacienda Pública, IVA repercutido","CUE","477","38","47","IVAREP","P-E-V-1"],
				["270","4770. IVA repercutido","CUE","4770","38","47","IVAREP","P-E-V-1"],
				["271","4777. IGIC repercutido","CUE","4777","38","47","","P-E-V-1"],
				["272","479. Impuesto sobre beneficios diferido","CUE","479","38","47","","P-E-V-1"],
				["273","4791. Impuesto sobre beneficios diferido a l/p","CUE","4791","38","47","","P-E-V-1"],
				["274","4798. Impuesto sobre beneficios diferido por operaciones intra-grupo","CUE","4798","38","47","","P-E-V-1"],
				["39","48. AJUSTES POR PERIODIFICACION","EPI","48","32","48","",""],
				["275","480. Gastos anticipados","CUE","480","39","48","","A-D-VII"],
				["276","485. Ingresos anticipados","CUE","485","39","48","","P-E-VII"],
				["40","49. PROVISIONES POR OPERACIONES DE TRAFICO","EPI","49","32","49","",""],
				["277","490. Provisión para insolvencias de tráfico","CUE","490","40","49","","A-D-III-7"],
				["278","493. Provisión para insolvencias de tráfico de empresas del grupo","CUE","493","40","49","","A-D-III-7"],
				["279","494. Provisión para insolvencias de tráfico de empresas asociadas","CUE","494","40","49","","A-D-III-7"],
				["280","499. Provisión para otras operaciones de tráfico","CUE","499","40","49","","P-E-VI"],
				["41","5. CUENTAS FINANCIERAS","EPI","5","","5","",""],
				["42","50. EMPRESTITOS Y OTRAS EMISIONES ANALOGAS A CORTO PLAZO","EPI","50","41","50","",""],
				["281","500. Obligaciones y bonos a corto plazo","CUE","500","42","50","","P-E-I-1"],
				["282","501. Obligaciones y bonos convertibles a corto plazo","CUE","501","42","50","","P-E-I-2"],
				["283","505. Deudas representadas otros valores negociables c/p","CUE","505","42","50","","P-E-I-3"],
				["284","506. Intereses de empréstitos y otras emisiones análogas","CUE","506","42","50","","P-E-I-4"],
				["285","509. Valores negociables amortizados","CUE","509","42","50","","P-E-V-3"],
				["286","5090. Obligaciones y bonos amortizados","CUE","5090","42","50","","P-E-V-3"],
				["287","5091. Obligaciones y bonos convertibles amortizados","CUE","5091","42","50","","P-E-V-3"],
				["288","5095. Otros valores negociables amortizados","CUE","5095","42","50","","P-E-V-3"],
				["43","51. DEUDAS A CORTO PLAZO CON EMPRESAS DEL GRUPO Y ASOCIADAS","EPI","51","41","51","",""],
				["289","510. Deudas a corto plazo con empresas del grupo","CUE","510","43","51","","P-E-III-1"],
				["290","5100. Préstamos a corto plazo de empresas del grupo","CUE","5100","43","51","","P-E-III-1"],
				["291","5108. Deudas a c/p con empresas del grupo por efectos impositivos","CUE","5108","43","51","","P-E-III-1"],
				["292","5109. Otras deudas a corto plazo con empresas del grupo","CUE","5109","43","51","","P-E-III-1"],
				["293","511. Deudas a corto plazo con empresas asociadas","CUE","511","43","51","","P-E-III-2"],
				["294","512. Deudas a c/p con entidades de crédito del grupo","CUE","512","43","51","","P-E-III-1"],
				["295","5120. Préstamos a c/p de entidades de crédito del grupo","CUE","5120","43","51","","P-E-III-1"],
				["296","5128. Deudas por efectos descontados en entididades de crédito del grupo","CUE","5128","43","51","","P-E-III-1"],
				["297","5129. Otras deudas c/p con entidades de crédito del grupo","CUE","5129","43","51","","P-E-III-1"],
				["298","513. Deudas a c/p con entidades de credito asociadas","CUE","513","43","51","","P-E-III-2"],
				["299","514. Proveedores de inmovilizado a c/p, empresas del grupo","CUE","514","43","51","","P-E-III-1"],
				["300","515. Proveedores de inmovilizado a c/p, empresas asociadas","CUE","515","43","51","","P-E-III-2"],
				["301","516. Intereses a c/p de deudas con empresas del grupo","CUE","516","43","51","","P-E-III-1"],
				["302","517. Intereses a c/p de deudas con empresas asociadas","CUE","517","43","51","","P-E-III-2"],
				["44","52. DEUDAS A CORTO PLAZO POR PRESTAMOS RECIBIDOS Y OTROS CONCEPTOS","EPI","52","41","52","",""],
				["303","520. Deudas a corto plazo con entidades de crédito","CUE","520","44","52","","P-E-II-1"],
				["304","5200. Préstamos a corto plazo de entidades de crédito","CUE","5200","44","52","","P-E-II-1"],
				["305","5201. Deudas a corto plazo por crédito dispuesto","CUE","5201","44","52","","P-E-II-1"],
				["306","5208. Deudas por efectos descontados","CUE","5208","44","52","","P-E-II-1"],
				["307","521. Deudas a corto plazo","CUE","521","44","52","","P-E-V-3"],
				["308","523. Proveedores de inmovilizado a corto plazo","CUE","523","44","52","","P-E-V-3"],
				["309","524. Efectos a pagar a corto plazo","CUE","524","44","52","","P-E-V-2"],
				["310","525. Dividendo activo a pagar","CUE","525","44","52","","P-E-V-3"],
				["311","526. Intereses a c/p de deudas con entidades de crédito","CUE","526","44","52","","P-E-II-2"],
				["312","527. Intereses a corto plazo de deudas","CUE","527","44","52","","P-E-V-3"],
				["45","53. INVERSIONES FINANCIERAS A CORTO PLAZO EN EMPRESAS DEL GRUPO Y ASOCIADAS","EPI","53","41","53","",""],
				["313","530. Participaciones a c/p en empresas del grupo","CUE","530","45","53","","A-D-IV-1"],
				["314","531. Participaciones a c/p en empresas asociadas","CUE","531","45","53","","A-D-IV-3"],
				["315","532. Valores de renta fija a c/p de empresas del grupo","CUE","532","45","53","","A-D-IV-2"],
				["316","533. Valores de renta fija a c/p de empresas asociadas","CUE","533","45","53","","A-D-IV-4"],
				["317","534. Créditos a corto plazo a empresas del grupo","CUE","534","45","53","","A-D-IV-2"],
				["318","5348. Créditos a c/p con empresas del grupo por efecto impositivo","CUE","5348","45","53","","A-D-IV-2"],
				["319","535. Créditos a corto plazo a empresas asociadas","CUE","535","45","53","","A-D-IV-4"],
				["320","536. Intereses a c/p de inversiones financieras en empresas del grupo","CUE","536","45","53","","A-D-IV-2"],
				["321","5360. Intereses c/p valores renta fija de empresas del grupo","CUE","5360","45","53","","A-D-IV-2"],
				["322","5361. Intereses c/p de créditos a empresas del grupo","CUE","5361","45","53","","A-D-IV-2"],
				["323","537. Intereses a c/p de inversiones financieras en empresas asociadas","CUE","537","45","53","","A-D-IV-4"],
				["324","538. Desembolsos pendientes sobre acciones a c/p de empresas del grupo","CUE","538","45","53","","A-D-IV-1"],
				["325","539. Desembolsos pendientes sobre acciones a c/p de empresas asociadas","CUE","539","45","53","","A-D-IV-3"],
				["46","54. OTRAS INVERSIONES FINANCIERAS TEMPORALES","EPI","54","41","54","",""],
				["326","540. Inversiones financieras temporales en capital","CUE","540","46","54","","A-D-IV-5"],
				["327","5400. Inversiones financieras temporales en acciones con cotización en mercado secundario organizado","CUE","5400","46","54","","A-D-IV-5"],
				["328","5401. Inversiones financieras temporales en acciones sin cotización en mercado secundario organizado","CUE","5401","46","54","","A-D-IV-5"],
				["329","5409. Otras inversiones financieras temporales en capital","CUE","5409","46","54","","A-D-IV-5"],
				["330","541. Valores de renta fija a corto plazo","CUE","541","46","54","","A-D-IV-5"],
				["331","5418. Participaciones en Fondos de Inversión en Activos del Mercado Monetario a c/p","CUE","5418","46","54","","A-D-IV-5"],
				["332","542. Créditos a corto plazo","CUE","542","46","54","","A-D-IV-6"],
				["333","543. Creditos a c/p por enajenación de inmovilizado","CUE","543","46","54","","A-D-IV-6"],
				["334","544. Créditos a corto plazo al personal","CUE","544","46","54","","A-D-III-5"],
				["335","545. Dividendo a cobrar","CUE","545","46","54","","A-D-IV-6"],
				["336","546. Intereses a corto plazo de valores de renta fija","CUE","546","46","54","","A-D-IV-5"],
				["337","547. Intereses a corto plazo de créditos","CUE","547","46","54","","A-D-IV-6"],
				["338","548. Imposiciones a corto plazo","CUE","548","46","54","","A-D-IV-6"],
				["339","549. Desembolsos pendientes sobre acciones a corto plazo","CUE","549","46","54","","A-D-IV-5"],
				["47","55. OTRAS CUENTAS NO BANCARIAS","EPI","55","41","55","",""],
				["340","550. Titular de la explotación","CUE","550","47","55","","P-E-V-3"],
				["341","551. Cuenta corriente con empresas del grupo","CUE","551","47","55","","A-D-III-2"],
				["342","552. Cuenta corriente con empresas asociadas","CUE","552","47","55","","P-E-III-2"],
				["343","553. Cuenta corriente con socios y administradores","CUE","553","47","55","","A-D-III-4"],
				["344","555. Partidas pendientes de aplicación","CUE","555","47","55","","A-D-III-4"],
				["345","556. Desembolsos exigidos sobre acciones","CUE","556","47","55","","P-E-V-3"],
				["346","5560. Desembolsos exigidos sobre acciones de empresas del grupo","CUE","5560","47","55","","P-E-V-3"],
				["347","5561. Desembolsos exigidos sobre acciones de empresas asociadas","CUE","5561","47","55","","P-E-V-3"],
				["348","5562. Desembolsos exigidos sobre acciones de otras empresas","CUE","5562","47","55","","P-E-V-3"],
				["349","557. Dividendo activo a cuenta","CUE","557","47","55","","P-A-VII"],
				["350","558. Accionistas por desembolsos exigidos","CUE","558","47","55","","A-D-I"],
				["48","56. FIANZAS Y DEPOSITOS RECIBIDOS Y CONSTITUIDOS A CORTO PLAZO","EPI","56","41","56","",""],
				["351","560. Fianzas recibidas a corto plazo","CUE","560","48","56","","P-E-V-5"],
				["352","561. Depósitos recibidos a corto plazo","CUE","561","48","56","","P-E-V-5"],
				["353","565. Fianzas constituidas a corto plazo","CUE","565","48","56","","A-D-IV-7"],
				["354","566. Depósitos constituidos a corto plazo","CUE","566","48","56","","A-D-IV-7"],
				["49","57. TESORERIA","EPI","57","41","57","",""],
				["355","570. Caja, euros","CUE","570","49","57","CAJA","A-D-VI"],
				["356","571. Caja, moneda extranjera","CUE","571","49","57","","A-D-VI"],
				["357","572. Bancos e instituciones de crédito c/c. vista, euros","CUE","572","49","57","","A-D-VI"],
				["358","573. Bancos e instituciones de crédito c/c. vista, moneda extranjera","CUE","573","49","57","","A-D-VI"],
				["359","574. Bancos e instituciones de crédito, cuentas de ahorro, euros","CUE","574","49","57","","A-D-VI"],
				["360","575. Bancos e instituciones de crédito, cuentas de ahorro, moneda extranjera","CUE","575","49","57","","A-D-VI"],
				["50","58. AJUSTES POR PERIODIFICACION","EPI","58","41","58","",""],
				["361","580. Intereses pagados por anticipado","CUE","580","50","58","","A-D-VII"],
				["362","585. Intereses cobrados por anticipado","CUE","585","50","58","","P-E-VII"],
				["51","59. PROVISIONES FINANCIERAS","EPI","59","41","59","",""],
				["363","593. Provisión por depreciación de valores negociables a c/p de empresas del grupo","CUE","593","51","59","","A-D-IV-8"],
				["364","594. Provisión por depreciación de valores negociables a c/p de empresas asociadas","CUE","594","51","59","","A-D-IV-8"],
				["365","595. Provisión para insolvencias de créditos a c/p a empresas del grupo","CUE","595","51","59","","A-D-IV-8"],
				["366","596. Provisión para insolvencias de créditos a c/p a empresas asociadas","CUE","596","51","59","","A-D-IV-8"],
				["367","597. Provisión por depreciación de valores negociables a c/p","CUE","597","51","59","","A-D-IV-8"],
				["368","598. Provisión para insolvencias de créditos a c/p","CUE","598","51","59","","A-D-IV-8"],
				["52","6. COMPRAS Y GASTOS","EPI","6","","6","",""],
				["53","60. COMPRAS","EPI","60","52","60","",""],
				["369","600. Compras de mercaderías","CUE","600","53","60","COMPRA","D-A-2-a"],
				["370","601. Compras de materias primas","CUE","601","53","60","","D-A-2-b"],
				["371","602. Compras de otros aprovisionamientos","CUE","602","53","60","","D-A-2-b"],
				["372","607. Trabajos realizados por otras empresas","CUE","607","53","60","","D-A-2-c"],
				["373","608. Devoluciones de compras y operaciones similares","CUE","608","53","60","DEVCOM","D-A-2-a"],
				["374","6080. Devoluciones de compras de mercaderías","CUE","6080","53","60","","D-A-2-a"],
				["375","6081. Devoluciones de compras de materias primas","CUE","6081","53","60","","D-A-2-b"],
				["376","6082. Devoluciones de compras de otros aprovisionamients","CUE","6082","53","60","","D-A-2-b"],
				["377","609. Rappels por compras","CUE","609","53","60","","D-A-2-a"],
				["378","6090. Rappels por compras de mercaderías","CUE","6090","53","60","","D-A-2-a"],
				["379","6091. Rapels por compras de materias primas","CUE","6091","53","60","","D-A-2-b"],
				["380","6092. Rappels por compras de otros aprovisionamientos","CUE","6092","53","60","","D-A-2-b"],
				["54","61. VARIACION DE EXISTENCIAS","EPI","61","52","61","",""],
				["381","610. Variación de existencias de mercaderías","CUE","610","54","61","","D-A-2-a"],
				["382","611. Variación de existencias de materias primas","CUE","611","54","61","","D-A-2-b"],
				["383","612. Variación de existencias de otros aprovisionamientos","CUE","612","54","61","","D-A-2-b"],
				["55","62. SERVICIOS EXTERIORES","EPI","62","52","62","",""],
				["384","620. Gastos en investigación y desarrollo del ejercicio","CUE","620","55","62","","D-A-6-a"],
				["385","621. Arrendamientos y cánones","CUE","621","55","62","","D-A-6-a"],
				["386","622. Reparaciones y conservación","CUE","622","55","62","","D-A-6-a"],
				["387","623. Servicios de profesionales independientes","CUE","623","55","62","","D-A-6-a"],
				["388","624. Transportes","CUE","624","55","62","","D-A-6-a"],
				["389","625. Primas de seguros","CUE","625","55","62","","D-A-6-a"],
				["390","626. Servicios bancarios y similares","CUE","626","55","62","","D-A-6-a"],
				["391","627. Publicidad, propaganda y relaciones públicas","CUE","627","55","62","","D-A-6-a"],
				["392","628. Suministros","CUE","628","55","62","","D-A-6-a"],
				["393","629. Otros servicios","CUE","629","55","62","","D-A-6-a"],
				["56","63. TRIBUTOS","EPI","63","52","63","",""],
				["394","630. Impuesto sobre beneficios","CUE","630","56","63","","D-V-5"],
				["395","631. Otros tributos","CUE","631","56","63","","D-A-6-b"],
				["396","632. Sociedades transparentes, efecto impositivo","CUE","632","56","63","","D-V-5"],
				["397","6320. Importes a cuenta no recuperables por entidades transparentes","CUE","6320","56","63","","D-V-6"],
				["398","6321. Importes a cuenta no recuperables por agrupaciones de interés económico","CUE","6321","56","63","","D-V-5"],
				["399","6323. Ajustes negativos en la imposición en sociedades transparentes","CUE","6323","56","63","","D-V-5"],
				["400","6328. Ajustes positivos en la imposición en sociedades transparentes","CUE","6328","56","63","","D-V-5"],
				["401","633. Ajustes negativos en imposicion sobre beneficios","CUE","633","56","63","","D-V-5"],
				["402","634. Ajustes negativos en la imposicion indirecta","CUE","634","56","63","","D-A-6-b"],
				["403","6341. Ajustes negativos en IVA de circulante","CUE","6341","56","63","","D-A-6-b"],
				["404","6342. Ajustes negativos en IVA de inversiones","CUE","6342","56","63","","D-A-6-b"],
				["405","6343. Ajustes negativos en IGIC, de circulante","CUE","6343","56","63","","D-A-6-b"],
				["406","6344. Ajustes negativos en IGIC, de inversión","CUE","6344","56","63","","D-A-6-b"],
				["407","635. Impuesto sobre beneficios extranjero","CUE","635","56","63","","D-V-6"],
				["408","636. Devolución de impuestos","CUE","636","56","63","","D-A-6-b"],
				["409","637. Imposición indirecta, regímenes especiales","CUE","637","56","63","","D-V-6"],
				["410","6371. Régimen simplificado, IVA","CUE","6371","56","63","","D-V-6"],
				["411","6372. Régimen simplificado, IGIC","CUE","6372","56","63","","D-V-6"],
				["412","6373. Régimen de la agricultura,ganadería y pesca, IVA","CUE","6373","56","63","","D-V-6"],
				["413","6374. Régimen de la agricultura y ganadería, IGIC","CUE","6374","56","63","","D-V-6"],
				["414","638. Ajustes positivos en imposicion sobre beneficios","CUE","638","56","63","","D-V-5"],
				["415","639. Ajustes positivos en la imposicion indirecta","CUE","639","56","63","","D-A-6-b"],
				["416","6391. Ajustes positivos en IVA de circulante","CUE","6391","56","63","","D-A-6-b"],
				["417","6392. Ajustes positivos en IVA de inversiones","CUE","6392","56","63","","D-A-6-b"],
				["418","6393. Ajustes positivos en IGIC de circulante","CUE","6393","56","63","","D-A-6-b"],
				["419","6394. Ajustes positivos en IGIC de inversión","CUE","6394","56","63","","D-A-6-b"],
				["57","64. GASTOS DE PERSONAL","EPI","64","52","64","",""],
				["420","640. Sueldos y salarios","CUE","640","57","64","","D-A-3-a"],
				["421","641. Indemnizaciones","CUE","641","57","64","","D-A-3-a"],
				["422","642. Seguridad Social a cargo de la empresa","CUE","642","57","64","","D-A-3-b"],
				["423","643. Aportaciones a sistemas complementarios pensiones","CUE","643","57","64","","D-A-3-b"],
				["424","649. Otros gastos sociales","CUE","649","57","64","","D-A-3-b"],
				["58","65. OTROS GASTOS DE GESTION","EPI","65","52","65","",""],
				["425","650. Pérdidas de créditos comerciales incobrables","CUE","650","58","65","","D-A-5-b"],
				["426","651. Resultados de operaciones en común","CUE","651","58","65","","D-A-6-c"],
				["427","6510. Beneficio transferido (gestor)","CUE","6510","58","65","","D-A-6-c"],
				["428","6511. Pérdida soportada (partícipe o asociado no gestor)","CUE","6511","58","65","","D-A-6-c"],
				["429","659. Otras pérdidas en gestión corriente","CUE","659","58","65","","D-A-6-c"],
				["59","66. GASTOS FINANCIEROS","EPI","66","52","66","",""],
				["430","661. Intereses de obligaciones y bonos","CUE","661","59","66","","D-I-7-a"],
				["431","6610. Intereses de obligaciones y bonos l/p en empresas del grupo","CUE","6610","59","66","","D-I-7-a"],
				["432","6611. Intereses de obligaciones y bonos l/p en empresas asociadas","CUE","6611","59","66","","D-I-7-b"],
				["433","6613. Intereses de obligaciones y bonos l/p en otras empresas","CUE","6613","59","66","","D-I-7-c"],
				["434","6615. Intereses de obligaciones y bonos c/p en empresas del grupo","CUE","6615","59","66","","D-I-7-a"],
				["435","6616. Intereses de obligaciones y bonos c/p en empresas asociadas","CUE","6616","59","66","","D-I-7-b"],
				["436","6618. Intereses de obligaciones y bonos c/p en otras empresas","CUE","6618","59","66","","D-I-7-c"],
				["437","662. Intereses de deudas a largo plazo","CUE","662","59","66","","D-I-7-a"],
				["438","6620. Intereses de deudas a l/p con empresas del grupo","CUE","6620","59","66","","D-I-7-a"],
				["439","6621. Intereses de deudas a l/p con empresas asociadas","CUE","6621","59","66","","D-I-7-b"],
				["440","6622. Intereses de deudas a l/p con entidades de crédito","CUE","6622","59","66","","D-I-7-c"],
				["441","6623. Intereses de deudas a l/p con otras empresas","CUE","6623","59","66","","D-I-7-c"],
				["442","663. Intereses de deudas a corto plazo","CUE","663","59","66","","D-I-7-a"],
				["443","6630. Intereses de deudas a c/p con empresas del grupo","CUE","6630","59","66","","D-I-7-a"],
				["444","6631. Intereses de deudas a c/p con empresas asociadas","CUE","6631","59","66","","D-I-7-b"],
				["445","6632. Intereses de deudas a c/p con entidades de crédito","CUE","6632","59","66","","D-I-7-c"],
				["446","6633. Intereses de deudas a c/p con otras empresas","CUE","6633","59","66","","D-I-7-c"],
				["447","664. Intereses por descuento de efectos","CUE","664","59","66","","D-I-7-a"],
				["448","6640. Intereses por descuento de efectos en entidades de crédito del grupo","CUE","6640","59","66","","D-I-7-a"],
				["449","6641. Intereses por descuento de efectos en entidades de crédito asociadas","CUE","6641","59","66","","D-I-7-b"],
				["450","6643. Intereses por descuento de efectos en otras entidades de crédito","CUE","6643","59","66","","D-I-7-c"],
				["451","665. Descuentos sobre ventas por pronto pago","CUE","665","59","66","","D-I-7-a"],
				["452","6650. Descuentos sobre ventas por pronto pago a empresas del grupo","CUE","6650","59","66","","D-I-7-a"],
				["453","6651. Descuentos sobre ventas por pronto pago a empresas asociadas","CUE","6651","59","66","","D-I-7-b"],
				["454","6653. Descuentos sobre ventas por pronto pago a otras empresas","CUE","6653","59","66","","D-I-7-c"],
				["455","666. Pérdidas en valores negociables","CUE","666","59","66","","D-I-7-d"],
				["456","6660. Pérdidas en valores negociables a l/p de empresas del grupo","CUE","6660","59","66","","D-I-7-d"],
				["457","6661. Pérdidas en valores negociables a l/p de empresas asociadas","CUE","6661","59","66","","D-I-7-d"],
				["458","6663. Pérdidas en valores negociables a l/p de otras empresas","CUE","6663","59","66","","D-I-7-d"],
				["459","6665. Pérdidas en valores negociables a c/p de empresas del grupo","CUE","6665","59","66","","D-I-7-d"],
				["460","6666. Pérdidas en valores negociables a c/p de empresas asociadas","CUE","6666","59","66","","D-I-7-d"],
				["461","6668. Pérdidas en valores negociables a c/p de otras empresas","CUE","6668","59","66","","D-I-7-d"],
				["462","667. Pérdidas de créditos","CUE","667","59","66","","D-I-7-d"],
				["463","6670. Pérdidas de créditos a l/p a empresas del grupo","CUE","6670","59","66","","D-I-7-d"],
				["464","6671. Pérdidas de créditos a l/p a empresas asociadas","CUE","6671","59","66","","D-I-7-d"],
				["465","6673. Pérdidas de créditos a l/p a otras empresas","CUE","6673","59","66","","D-I-7-d"],
				["466","6675. Pérdidas de créditos a c/p a empresas del grupo","CUE","6675","59","66","","D-I-7-d"],
				["467","6676. Pérdidas de créditos a c/p a empresas asociadas","CUE","6676","59","66","","D-I-7-d"],
				["468","6678. Pérdidas de créditos a c/p a otras empresas","CUE","6678","59","66","","D-I-7-d"],
				["469","668. Diferencias negativas de cambio","CUE","668","59","66","CAMNEG","D-I-9"],
				["470","6680. Diferencias negativas de cambio por la introducción del euro","CUE","6680","59","66","EURNEG","D-I-9"],
				["471","6681. Diferencias negativas de cambio","CUE","6681","59","66","","D-I-9"],
				["472","669. Otros gastos financieros","CUE","669","59","66","","D-I-7-c"],
				["473","6690. Gastos por diferencias derivadas del redondeo del euro","CUE","6690","59","66","","D-I-7-c"],
				["474","6691. Otros gastos financieros","CUE","6691","59","66","","D-I-7-c"],
				["60","67. PERDIDAS PROCEDENTES DEL INMOVILIZADO Y GASTOS EXCEPCIONALES","EPI","67","52","67","",""],
				["475","670. Pérdidas procedentes de inmovilizado inmaterial","CUE","670","60","67","","D-III-1"],
				["476","671. Pérdidas procedentes de inmovilizado material","CUE","671","60","67","","D-III-1"],
				["477","672. Pérdidas procedentes de participaciones en capital a l/p de empresas del grupo","CUE","672","60","67","","D-III-1"],
				["478","673. Pérdidas procedentes de participaciones en capital a l/p de empresas asociadas","CUE","673","60","67","","D-III-1"],
				["479","674. Pérdidas por operaciones con acciones y obligaciones propias","CUE","674","60","67","","D-III-2"],
				["480","676. Donaciones del inmovilizado material","CUE","676","60","67","","D-III-1"],
				["481","678. Gastos extraordinarios","CUE","678","60","67","","D-III-3"],
				["482","6780. Gastos producidos por la introducción del euro","CUE","6780","60","67","","D-III-3"],
				["483","6781. Otros gastos extraordinarios","CUE","6781","60","67","","D-III-3"],
				["484","679. Gastos y pérdidas de ejercicios anteriores","CUE","679","60","67","","D-III-4"],
				["61","68. DOTACIONES PARA AMORTIZACIONES","EPI","68","52","68","",""],
				["485","680. Amortización de gastos de establecimiento","CUE","680","61","68","","D-A-4"],
				["486","681. Amortización del inmovilizado inmaterial","CUE","681","61","68","","D-A-4"],
				["487","682. Amortización del inmovilizado material","CUE","682","61","68","","D-A-4"],
				["62","69. DOTACIONES A LAS PROVISIONES","EPI","69","52","69","",""],
				["488","690. Dotación al fondo de reversión","CUE","690","62","69","","D-A-6-d"],
				["489","691. Dotación a la provisión de inmovilizado inmaterial","CUE","691","62","69","","D-III-0"],
				["490","692. Dotación a la provisión del inmovilizado material","CUE","692","62","69","","D-III-0"],
				["491","693. Dotación a la provisión de existencias","CUE","693","62","69","","D-A-5-a"],
				["492","694. Dotación a la provisión para insolvencias de tráfico","CUE","694","62","69","","D-A-5-b"],
				["493","695. Dotación a la provisión para otras operaciones de tráfico","CUE","695","62","69","","D-A-5-c"],
				["494","696. Dotación a la provisión para valores negociables a l/p","CUE","696","62","69","","D-I-8"],
				["495","6960. Dotación a la provisión para participaciones en capital a l/p de empresas del grupo","CUE","6960","62","69","","D-III-0"],
				["496","6961. Dotación a la provisión para participaciones en capital a l/p de empresas asociadas","CUE","6961","62","69","","D-III-0"],
				["497","6963. Dotación a la provisión para participaciones en capital a l/p de otras empresas","CUE","6963","62","69","","D-I-8"],
				["498","6965. Dotación a la provisión para valores de renta fija a l/p de empresas del grupo","CUE","6965","62","69","","D-I-8"],
				["499","6966. Dotación a la provisión para valores de renta fija a l/p de empresas asociadas","CUE","6966","62","69","","D-I-8"],
				["500","697. Dotación a la provisión para insolvencias de créditos a l/p","CUE","697","62","69","","D-I-8"],
				["501","6970. Dotación a la provisión para insolvencias de créditos a l/p a empresas del grupo","CUE","6970","62","69","","D-I-8"],
				["502","6971. Dotación a la provisión para insolvencias de créditos a l/p a empresas asociadas","CUE","6971","62","69","","D-I-8"],
				["503","6973. Dotación a la provisión para insolvencias de créditos a l/p a otras empresas","CUE","6973","62","69","","D-I-8"],
				["504","698. Dotacion a la provisión para valores negociables a c/p","CUE","698","62","69","","D-I-8"],
				["505","6980. Dotacion a la provisión para valores negociables a c/p de empresas del grupo","CUE","6980","62","69","","D-I-8"],
				["506","6981. Dotacion a la provisión para valores negociables a c/p de empresas asociadas","CUE","6981","62","69","","D-I-8"],
				["507","6983. Dotacion a la provisión para valores negociables a c/p de otras empresas","CUE","6983","62","69","","D-I-8"],
				["508","699. Dotación a la provisión para insolvencias de créditos a c/p","CUE","699","62","69","","D-I-8"],
				["509","6990. Dotación a la provisión para insolvencias de créditos a c/p a empresas del grupo","CUE","6990","62","69","","D-I-8"],
				["510","6991. Dotación a la provisión para insolvencias de créditos a c/p a empresas asociadas","CUE","6991","62","69","","D-I-8"],
				["511","6993. Dotación a la provisión para insolvencias de créditos a c/p a otras empresas","CUE","6993","62","69","","D-I-8"],
				["63","7. VENTAS E INGRESOS","EPI","7","","7","",""],
				["64","70. VENTAS DE MERCADERIAS,DE PRODUCCION PROPIA,DE SERVICIOS, ETC.","EPI","70","63","70","",""],
				["512","700. Ventas de mercaderías","CUE","700","64","70","VENTAS","H-B-1-a"],
				["513","701. Ventas de productos terminados","CUE","701","64","70","VENTAS","H-B-1-a"],
				["514","702. Ventas de productos semiterminados","CUE","702","64","70","VENTAS","H-B-1-a"],
				["515","703. Ventas de subproductos y residuos","CUE","703","64","70","VENTAS","H-B-1-a"],
				["516","704. Ventas de envases y embalajes","CUE","704","64","70","VENTAS","H-B-1-a"],
				["517","705. Prestaciones de servicios","CUE","705","64","70","VENTAS","H-B-1-b"],
				["518","708. Devoluciones de ventas y operaciones similares","CUE","708","64","70","DEVVEN","H-B-1-c"],
				["519","7080. Devoluciones de ventas de mercaderías","CUE","7080","64","70","","H-B-1-c"],
				["520","7081. Devoluciones de ventas de productos terminados","CUE","7081","64","70","","H-B-1-c"],
				["521","7082. Devoluciones de ventas de productos semiterminados","CUE","7082","64","70","","H-B-1-c"],
				["522","7083. Devoluciones de ventas de subproductos y residuos","CUE","7083","64","70","","H-B-1-c"],
				["523","7084. Devoluciones de ventas de envases y embalajes","CUE","7084","64","70","","H-B-1-c"],
				["524","709. Rappels sobre ventas","CUE","709","64","70","","H-B-1-c"],
				["525","7090. Rappels sobre ventas de mercaderías","CUE","7090","64","70","","H-B-1-c"],
				["526","7091. Rappels sobre ventas de productos terminados","CUE","7091","64","70","","H-B-1-c"],
				["527","7092. Rappels sobre ventas de productos semiterminados","CUE","7092","64","70","","H-B-1-c"],
				["528","7093. Rappels sobre ventas de subproductos y residuos","CUE","7093","64","70","","H-B-1-c"],
				["529","7094. Rappels sobre ventas de envases y embalajes","CUE","7094","64","70","","H-B-1-c"],
				["65","71. VARIACION DE EXISTENCIAS","EPI","71","63","71","",""],
				["530","710. Variación de existencias de productos en curso","CUE","710","65","71","","D-A-1"],
				["531","711. Variación de existencias de productos semiterminados","CUE","711","65","71","","H-B-2"],
				["532","712. Variación de existencias de productos terminados","CUE","712","65","71","","H-B-2"],
				["533","713. Variación de existencias de subproductos, residuos y materiales recuperados","CUE","713","65","71","","H-B-2"],
				["66","73. TRABAJOS REALIZADOS PARA LA EMPRESA","EPI","73","63","73","",""],
				["534","730. Incorporación al activo de gastos de establecimiento","CUE","730","66","73","","H-B-3"],
				["535","731. Trabajos realizados para inmovilizado inmaterial","CUE","731","66","73","","H-B-3"],
				["536","732. Trabajos realizados para inmovilizado material","CUE","732","66","73","","H-B-3"],
				["537","733. Trabajos realizados para inmovilizado material en curso","CUE","733","66","73","","H-B-3"],
				["538","737. Incorporación al activo de gastos de formalización de deudas","CUE","737","66","73","","H-B-3"],
				["67","74. SUBVENCIONES A LA EXPLOTACION","EPI","74","63","74","",""],
				["539","740. Subvenciones oficiales a la explotación","CUE","740","67","74","","H-B-4-b"],
				["540","741. Otras subvenciones a la explotación","CUE","741","67","74","","H-B-4-b"],
				["68","75. OTROS INGRESOS DE GESTION","EPI","75","63","75","",""],
				["541","751. Resultados de operaciones en común","CUE","751","68","75","","H-B-4-a"],
				["542","7510. Pérdida transferida (gestor)","CUE","7510","68","75","","H-B-4-a"],
				["543","7511. Beneficio atribuido (partícipe o asociado no gestor)","CUE","7511","68","75","","H-B-4-a"],
				["544","752. Ingresos por arrendamientos","CUE","752","68","75","","H-B-4-a"],
				["545","753. Ingresos de propiedad industrial cedida en explotación","CUE","753","68","75","","H-B-4-a"],
				["546","754. Ingresos por comisiones","CUE","754","68","75","","H-B-4-a"],
				["547","755. Ingresos por servicios al personal","CUE","755","68","75","","H-B-4-a"],
				["548","759. Ingresos por servicios diversos","CUE","759","68","75","","H-B-4-a"],
				["69","76. INGRESOS FINANCIEROS","EPI","76","63","76","",""],
				["549","760. Ingresos de participaciones en capital","CUE","760","69","76","","H-I-5-a"],
				["550","7600. Ingresos de participaciones en capital de empresas del grupo","CUE","7600","69","76","","H-I-5-a"],
				["551","7601. Ingresos de participaciones en capital de empresas asociadas","CUE","7601","69","76","","H-I-5-b"],
				["552","7603. Ingresos de participaciones en capital de otras empresas","CUE","7603","69","76","","H-I-5-c"],
				["553","761. Ingresos de valores de renta fija","CUE","761","69","76","","H-I-6-a"],
				["554","7610. Ingresos de valores renta fija de empresas del grupo","CUE","7610","69","76","","H-I-6-a"],
				["555","7611. Ingresos de valores renta fija de empresas asociadas","CUE","7611","69","76","","H-I-6-b"],
				["556","7613. Ingresos de valores renta fija de otras empresas","CUE","7613","69","76","","H-I-6-c"],
				["557","7618. Ingresos de participaciones en Fondos de Inversión en Activos del Mercado Monetario","CUE","7618","69","76","","H-I-6-c"],
				["558","762. Ingresos de créditos a largo plazo","CUE","762","69","76","","H-I-6-a"],
				["559","7620. Ingresos de créditos a l/p a empresas del grupo","CUE","7620","69","76","","H-I-6-a"],
				["560","7621. Ingresos de créditos a l/p a empresas asociadas","CUE","7621","69","76","","H-I-6-b"],
				["561","7623. Ingresos de créditos a l/p a otras empresas","CUE","7623","69","76","","H-I-6-c"],
				["562","763. Ingresos de créditos a corto plazo","CUE","763","69","76","","H-I-7-a"],
				["563","7630. Ingresos de créditos a c/p a empresas del grupo","CUE","7630","69","76","","H-I-7-a"],
				["564","7631. Ingresos de créditos a c/p a empresas asociadas","CUE","7631","69","76","","H-I-7-b"],
				["565","7633. Ingresos de créditos a c/p a otras empresas","CUE","7633","69","76","","H-I-7-c"],
				["566","765. Descuentos sobre compras por pronto pago","CUE","765","69","76","","H-I-7-a"],
				["567","7650. Descuentos sobre compras por pronto pago de empresas del grupo","CUE","7650","69","76","","H-I-7-a"],
				["568","7651. Descuentos sobre compras por pronto pago de empresas asociadas","CUE","7651","69","76","","H-I-7-b"],
				["569","7653. Descuentos sobre compras por pronto pago de otras empresas","CUE","7653","69","76","","H-I-7-c"],
				["570","766. Beneficios en valores negociables","CUE","766","69","76","","H-I-7-d"],
				["571","7660. Beneficios en valores negociables a l/p de empresas del grupo","CUE","7660","69","76","","H-I-7-d"],
				["572","7661. Beneficios en valores negociables a l/p de empresas asociadas","CUE","7661","69","76","","H-I-7-d"],
				["573","7663. Beneficios en valores negociables a l/p de otras empresas","CUE","7663","69","76","","H-I-7-d"],
				["574","7665. Beneficios en valores negociables a c/p de empresas del grupo","CUE","7665","69","76","","H-I-7-d"],
				["575","7666. Beneficios en valores negociables a c/p de empresas asociadas","CUE","7666","69","76","","H-I-7-d"],
				["576","7668. Beneficios en valores negociables a c/p de otras empresas","CUE","7668","69","76","","H-I-7-d"],
				["577","768. Diferencias positivas de cambio","CUE","768","69","76","CAMPOS","H-I-8"],
				["578","7680. Diferencias positivas de cambio por la introducción del euro","CUE","7680","69","76","EURPOS","H-I-8"],
				["579","7681. Diferencias positivas de cambio","CUE","7681","69","76","","H-I-8"],
				["580","769. Otros ingresos financieros","CUE","769","69","76","","H-I-7-c"],
				["581","7690. Ingresos por diferencias derivadas del redondeo del euro","CUE","7690","69","76","","H-I-7-c"],
				["582","7691. Otros ingresos financieros","CUE","7691","69","76","","H-I-7-c"],
				["70","77. BENEFICIOS PROCEDENTES DEL INMOVILIZADO E INGRESOS EXCEPCIONALES","EPI","77","63","77","",""],
				["583","770. Beneficios procedentes de inmovilizado inmaterial","CUE","770","70","77","","H-III-A"],
				["584","771. Beneficios procedentes de inmovilizado material","CUE","771","70","77","","H-III-A"],
				["585","772. Beneficios procedentes de participaciones en capital a l/p de empresas del grupo","CUE","772","70","77","","H-III-A"],
				["586","773. Beneficios procedentes de participaciones en capital a l/p de empresas asociadas","CUE","773","70","77","","H-III-A"],
				["587","774. Beneficios por operaciones con acciones y obligaciones propias","CUE","774","70","77","","H-III-B"],
				["588","775. Subvenciones de capital traspasadas al resultado del ejercicio","CUE","775","70","77","","H-III-C"],
				["589","778. Ingresos extraordinarios","CUE","778","70","77","","H-III-D"],
				["590","779. Ingresos y beneficios de ejercicios anteriores","CUE","779","70","77","","H-III-E"],
				["71","79. EXCESOS Y APLICACIONES DE PROVISIONES","EPI","79","63","79","",""],
				["591","790. Exceso de provisión para riesgos y gastos","CUE","790","71","79","","H-B-4-c"],
				["592","791. Exceso de provisión del inmovilizado inmaterial","CUE","791","71","79","","D-III-0"],
				["593","792. Exceso de provisión del inmovilizado material","CUE","792","71","79","","D-III-0"],
				["594","793. Provisión de existencias aplicada","CUE","793","71","79","","D-A-5-a"],
				["595","794. Provisión para insolvencias de tráfico aplicada","CUE","794","71","79","","D-A-5-b"],
				["596","795. Provisión para otras operaciones de tráfico aplicada","CUE","795","71","79","","D-A-5-c"],
				["597","796. Exceso de provisión para valores negociables a l/p","CUE","796","71","79","","D-III-1"],
				["598","7960. Exceso de provisión para participaciones en capital a l/p de empresas del grupo","CUE","7960","71","79","","D-III-0"],
				["599","7961. Exceso de provisión para participaciones en capital a l/p de empresas asociadas","CUE","7961","71","79","","D-III-0"],
				["600","7963. Exceso de provisión para valores negociables a l/p de otras empresas","CUE","7963","71","79","","D-I-8"],
				["601","7965. Exceso de provisión para valores de renta fija a l/p de empresas del grupo","CUE","7965","71","79","","D-I-8"],
				["602","7966. Exceso de provisión para valores de renta fija a l/p de empresas asociadas","CUE","7966","71","79","","D-I-8"],
				["603","797. Exceso de provisión para insolvencias de créditos a l/p","CUE","797","71","79","","D-I-8"],
				["604","7970. Exceso de provisión para insolvencias de créditos a l/p de empresas del grupo","CUE","7970","71","79","","D-I-8"],
				["605","7971. Exceso de provisión para insolvencias de créditos a l/p de empresas asociadas","CUE","7971","71","79","","D-I-8"],
				["606","7973. Exceso de provisión para insolvencias de créditos a l/p de otras empresas","CUE","7973","71","79","","D-I-8"],
				["607","798. Exceso de provisión para valores negociables a c/p","CUE","798","71","79","","D-I-8"],
				["608","7980. Exceso de provisión para valores negociables a c/p de empresas del grupo","CUE","7980","71","79","","D-I-8"],
				["609","7981. Exceso de provisión para valores negociables a c/p de empresas asociadas","CUE","7981","71","79","","D-I-8"],
				["610","7983. Exceso de provisión para valores negociables a c/p de otras empresas","CUE","7983","71","79","","D-I-8"],
				["611","799. Exceso de provisión para insolvencias de créditos a c/p","CUE","799","71","79","","D-I-8"],
				["612","7990. Exceso de provisión para insolvencias de créditos a c/p de empresas del grupo","CUE","7990","71","79","","D-I-8"],
				["613","7991. Exceso de provisión para insolvencias de créditos a c/p de empresas asociadas","CUE","7991","71","79","","D-I-8"],
				["614","7993. Exceso de provisión para insolvencias de créditos a c/p de otras empresas","CUE","7993","71","79","","D-I-8"]];

		var idEpigrafeIni:Number = util.sqlSelect("co_epigrafes", "MAX(idepigrafe)","idepigrafe <> 0");
		var idCuentaIni:Number = util.sqlSelect("co_cuentas", "MAX(idcuenta)","idcuenta <> 0");
		idEpigrafeIni = parseFloat (idEpigrafeIni);  
		idCuentaIni = parseFloat (idCuentaIni);
		if (!idEpigrafeIni)
				idEpigrafeIni = 0;
		if (!idCuentaIni)
				idCuentaIni = 0;
		var idEpigrafe:Number = 0;
		var idPadre:Number = 0;
		var idCuenta:Number = 0;
		util.createProgressDialog(util.translate("scripts", "Creando Plan General Contable"),
				datos.length);
		var j:Number = 0;
		util.setProgress(0);
		for (i = 0; i < datos.length; i++) {
				if (datos[i][2] == "EPI") {
						if (idPadre == 0)
								idPadre = "";
								
						curEpi.setModeAccess(curEpi.Insert);
						curEpi.refreshBuffer();
						curEpi.setValueBuffer("descripcion", datos[i][1]);
						curEpi.setValueBuffer("codepigrafe", datos[i][3]);
						curEpi.setValueBuffer("codejercicio", codEjercicio);
						
						if (parseFloat(datos[i][4]) == 0)
								idPadre = "";
						else 
								idPadre = idEpigrafeIni + parseFloat(datos[i][4]);
						curEpi.setValueBuffer("idpadre", idPadre);
						idEpigrafe = idEpigrafeIni + parseFloat(datos[i][0]);
						curEpi.setValueBuffer("idepigrafe", idEpigrafe);
						curEpi.commitBuffer();
				} else {
						idCuenta = idCuentaIni + parseFloat(datos[i][0]);
						idEpigrafe = idEpigrafeIni + parseFloat(datos[i][4]);
								
						curCue.setModeAccess(curCue.Insert);
						curCue.refreshBuffer();
						curCue.setValueBuffer("descripcion", datos[i][1]);
						curCue.setValueBuffer("codcuenta", datos[i][3]);
						curCue.setValueBuffer("codejercicio", codEjercicio);
						curCue.setValueBuffer("idepigrafe", idEpigrafe);
						curCue.setValueBuffer("codepigrafe", datos[i][5]);
						curCue.setValueBuffer("idcuentaesp", datos[i][6]);
						curCue.setValueBuffer("codbalance", datos[i][7]);
						curCue.commitBuffer();
				
				}
				if (j++ > 50) {
						j = 0;
						util.setProgress(i);
				}
		}
		util.setProgress(datos.length);
		util.destroyProgressDialog();
}

/** \D Se introducen los códigos de balance, independientes del ejercicio
\end */
function oficial_generarCodigosBalance()
{

		var curCbl:FLSqlCursor = new FLSqlCursor("co_codbalances");
		curCbl.setActivatedCheckIntegrity(false);
		
		var datos =
				[["A","A","ACTIVO","","","","","",""],
				["A-A","A","ACTIVO","A","A) ACCIONISTAS ( SOCIOS ) POR DESEMBOLSOS NO EXIGIDOS","","","",""],
				["A-B","A","ACTIVO","B","B) INMOVILIZADO","","","",""],
				["A-B-I","A","ACTIVO","B","B) INMOVILIZADO","I","I. Gastos de establecimiento","",""],
				["A-B-II","A","ACTIVO","B","B) INMOVILIZADO","II","II. Inmovilizaciones inmateriales","",""],
				["A-B-II-1","A","ACTIVO","B","B) INMOVILIZADO","II","II. Inmovilizaciones inmateriales","1","1. Gastos de investigación y desarrollo"],
				["A-B-II-2","A","ACTIVO","B","B) INMOVILIZADO","II","II. Inmovilizaciones inmateriales","2","2. Concesiones, patentes, licencias, marcas y similares"],
				["A-B-II-3","A","ACTIVO","B","B) INMOVILIZADO","II","II. Inmovilizaciones inmateriales","3","3. Fondo de comercio"],
				["A-B-II-4","A","ACTIVO","B","B) INMOVILIZADO","II","II. Inmovilizaciones inmateriales","4","4. Derechos de traspaso"],
				["A-B-II-5","A","ACTIVO","B","B) INMOVILIZADO","II","II. Inmovilizaciones inmateriales","5","5. Aplicaciones informáticas"],
				["A-B-II-6","A","ACTIVO","B","B) INMOVILIZADO","II","II. Inmovilizaciones inmateriales","6","6. Derechos s/bienes en régimen de arrendamiento financiero"],
				["A-B-II-7","A","ACTIVO","B","B) INMOVILIZADO","II","II. Inmovilizaciones inmateriales","7","7. Anticipos"],
				["A-B-II-8","A","ACTIVO","B","B) INMOVILIZADO","II","II. Inmovilizaciones inmateriales","8","8. Provisiones"],
				["A-B-II-9","A","ACTIVO","B","B) INMOVILIZADO","II","II. Inmovilizaciones inmateriales","9","9. Amortizaciones"],
				["A-B-III","A","ACTIVO","B","B) INMOVILIZADO","III","III. Inmovilizaciones materiales","",""],
				["A-B-III-1","A","ACTIVO","B","B) INMOVILIZADO","III","III. Inmovilizaciones materiales","1","1. Terrenos y construcciones"],
				["A-B-III-2","A","ACTIVO","B","B) INMOVILIZADO","III","III. Inmovilizaciones materiales","2","2. Instalaciones técnicas y maquinaria"],
				["A-B-III-3","A","ACTIVO","B","B) INMOVILIZADO","III","III. Inmovilizaciones materiales","3","3. Otras instalaciones, utillaje y mobiliario"],
				["A-B-III-4","A","ACTIVO","B","B) INMOVILIZADO","III","III. Inmovilizaciones materiales","4","4. Anticipos e inmovilizaciones materiales en curso"],
				["A-B-III-5","A","ACTIVO","B","B) INMOVILIZADO","III","III. Inmovilizaciones materiales","5","5. Otro inmovilizado"],
				["A-B-III-6","A","ACTIVO","B","B) INMOVILIZADO","III","III. Inmovilizaciones materiales","6","6. Provisiones"],
				["A-B-III-7","A","ACTIVO","B","B) INMOVILIZADO","III","III. Inmovilizaciones materiales","7","7. Amortizaciones"],
				["A-B-IV","A","ACTIVO","B","B) INMOVILIZADO","IV","IV. Inmovilizaciones financieras","",""],
				["A-B-IV-1","A","ACTIVO","B","B) INMOVILIZADO","IV","IV. Inmovilizaciones financieras","1","1. Participaciones en empresas del grupo"],
				["A-B-IV-2","A","ACTIVO","B","B) INMOVILIZADO","IV","IV. Inmovilizaciones financieras","2","2. Créditos a empresas del grupo"],
				["A-B-IV-3","A","ACTIVO","B","B) INMOVILIZADO","IV","IV. Inmovilizaciones financieras","3","3. Participaciones en empresas asociadas"],
				["A-B-IV-4","A","ACTIVO","B","B) INMOVILIZADO","IV","IV. Inmovilizaciones financieras","4","4. Créditos a empresas asociadas"],
				["A-B-IV-5","A","ACTIVO","B","B) INMOVILIZADO","IV","IV. Inmovilizaciones financieras","5","5. Cartera de valores a largo plazo"],
				["A-B-IV-6","A","ACTIVO","B","B) INMOVILIZADO","IV","IV. Inmovilizaciones financieras","6","6. Otros Créditos"],
				["A-B-IV-7","A","ACTIVO","B","B) INMOVILIZADO","IV","IV. Inmovilizaciones financieras","7","7. Depósitos y fianzas constituidos a largo plazo"],
				["A-B-IV-8","A","ACTIVO","B","B) INMOVILIZADO","IV","IV. Inmovilizaciones financieras","8","8. Provisiones"],
				["A-B-IV-9","A","ACTIVO","B","B) INMOVILIZADO","IV","IV. Inmovilizaciones financieras","9","9. Administraciones públicas a largo plazo"],
				["A-B-V","A","ACTIVO","B","B) INMOVILIZADO","V","V. Acciones propias","",""],
				["A-B-VI","A","ACTIVO","B","B) INMOVILIZADO","VI","VI. Deudores por operaciones de tráfico a largo plazo","",""],
				["A-C","A","ACTIVO","C","C) GASTOS A DISTRIBUIR EN VARIOS EJERCICIOS","","","",""],
				["A-D","A","ACTIVO","D","D) ACTIVO CIRCULANTE","","","",""],
				["A-D-I","A","ACTIVO","D","D) ACTIVO CIRCULANTE","I","I. Accionistas por desembolsos exigidos","",""],
				["A-D-II","A","ACTIVO","D","D) ACTIVO CIRCULANTE","II","II. Existencias","",""],
				["A-D-II-1","A","ACTIVO","D","D) ACTIVO CIRCULANTE","II","II. Existencias","1","1. Comerciales"],
				["A-D-II-2","A","ACTIVO","D","D) ACTIVO CIRCULANTE","II","II. Existencias","2","2. Materias primas y otros aprovisionamientos"],
				["A-D-II-3","A","ACTIVO","D","D) ACTIVO CIRCULANTE","II","II. Existencias","3","3. Productos en curso y semiterminados"],
				["A-D-II-4","A","ACTIVO","D","D) ACTIVO CIRCULANTE","II","II. Existencias","4","4. Productos terminados"],
				["A-D-II-5","A","ACTIVO","D","D) ACTIVO CIRCULANTE","II","II. Existencias","5","5. Subproductos, residuos y materiales recuperados"],
				["A-D-II-6","A","ACTIVO","D","D) ACTIVO CIRCULANTE","II","II. Existencias","6","6. Anticipos"],
				["A-D-II-7","A","ACTIVO","D","D) ACTIVO CIRCULANTE","II","II. Existencias","7","7. Provisiones"],
				["A-D-III","A","ACTIVO","D","D) ACTIVO CIRCULANTE","III","III. Deudores","",""],
				["A-D-III-1","A","ACTIVO","D","D) ACTIVO CIRCULANTE","III","III. Deudores","1","1. Clientes por ventas y prestaciones de servicios"],
				["A-D-III-2","A","ACTIVO","D","D) ACTIVO CIRCULANTE","III","III. Deudores","2","2. Empresas del grupo, deudores"],
				["A-D-III-3","A","ACTIVO","D","D) ACTIVO CIRCULANTE","III","III. Deudores","3","3. Empresas asociadas, deudores"],
				["A-D-III-4","A","ACTIVO","D","D) ACTIVO CIRCULANTE","III","III. Deudores","4","4. Deudores varios"],
				["A-D-III-5","A","ACTIVO","D","D) ACTIVO CIRCULANTE","III","III. Deudores","5","5. Personal"],
				["A-D-III-6","A","ACTIVO","D","D) ACTIVO CIRCULANTE","III","III. Deudores","6","6. Administraciones públicas"],
				["A-D-III-7","A","ACTIVO","D","D) ACTIVO CIRCULANTE","III","III. Deudores","7","7. Provisiones"],
				["A-D-IV","A","ACTIVO","D","D) ACTIVO CIRCULANTE","IV","IV. Inversiones financieras temporales","",""],
				["A-D-IV-1","A","ACTIVO","D","D) ACTIVO CIRCULANTE","IV","IV. Inversiones financieras temporales","1","1. Participaciones en empresas del grupo"],
				["A-D-IV-2","A","ACTIVO","D","D) ACTIVO CIRCULANTE","IV","IV. Inversiones financieras temporales","2","2. Créditos a empresas del grupo"],
				["A-D-IV-3","A","ACTIVO","D","D) ACTIVO CIRCULANTE","IV","IV. Inversiones financieras temporales","3","3. Participaciones en empresas asociadas"],
				["A-D-IV-4","A","ACTIVO","D","D) ACTIVO CIRCULANTE","IV","IV. Inversiones financieras temporales","4","4. Créditos a empresas asociadas"],
				["A-D-IV-5","A","ACTIVO","D","D) ACTIVO CIRCULANTE","IV","IV. Inversiones financieras temporales","5","5. Cartera de valores a corto plazo"],
				["A-D-IV-6","A","ACTIVO","D","D) ACTIVO CIRCULANTE","IV","IV. Inversiones financieras temporales","6","6. Otros créditos"],
				["A-D-IV-7","A","ACTIVO","D","D) ACTIVO CIRCULANTE","IV","IV. Inversiones financieras temporales","7","7. Depósitos y fianzas constituidos a corto plazo"],
				["A-D-IV-8","A","ACTIVO","D","D) ACTIVO CIRCULANTE","IV","IV. Inversiones financieras temporales","8","8. Provisiones"],
				["A-D-V","A","ACTIVO","D","D) ACTIVO CIRCULANTE","V","V. Acciones propias a corto plazo","",""],
				["A-D-VI","A","ACTIVO","D","D) ACTIVO CIRCULANTE","VI","VI. Tesorería","",""],
				["A-D-VII","A","ACTIVO","D","D) ACTIVO CIRCULANTE","VII","VII. Ajustes por periodificación","",""],
				["A-E","A","ACTIVO","E","TOTAL  ACTIVO","","","",""],
				["D","D","DEBE","","","","","",""],
				["D-A","D","DEBE","A","A) GASTOS ( A1 a A16 )","","","",""],
				["D-A-1","D","DEBE","A","A) GASTOS ( A1 a A16 )","1","A1. Reducción de existencias de productos terminados y en curso de fabricación","",""],
				["D-A-2","D","DEBE","A","A) GASTOS ( A1 a A16 )","2","A2. Aprovisionamientos","",""],
				["D-A-2-a","D","DEBE","A","A) GASTOS ( A1 a A16 )","2","A2. Aprovisionamientos","a","a) Consumo de mercaderías"],
				["D-A-2-b","D","DEBE","A","A) GASTOS ( A1 a A16 )","2","A2. Aprovisionamientos","b","b) Consumo de materias primas y otras materias consumibles"],
				["D-A-2-c","D","DEBE","A","A) GASTOS ( A1 a A16 )","2","A2. Aprovisionamientos","c","c) Otros gastos externos"],
				["D-A-3","D","DEBE","A","A) GASTOS ( A1 a A16 )","3","A3. Gastos de personal","",""],
				["D-A-3-a","D","DEBE","A","A) GASTOS ( A1 a A16 )","3","A3. Gastos de personal","a","a) Sueldos, salarios y asimilados"],
				["D-A-3-b","D","DEBE","A","A) GASTOS ( A1 a A16 )","3","A3. Gastos de personal","b","b) Cargas sociales"],
				["D-A-4","D","DEBE","A","A) GASTOS ( A1 a A16 )","4","A4. Dotaciones para amortizaciones de inmovilizado","",""],
				["D-A-5","D","DEBE","A","A) GASTOS ( A1 a A16 )","5","A5. Variación de las provisiones de tráfico","",""],
				["D-A-5-a","D","DEBE","A","A) GASTOS ( A1 a A16 )","5","A5. Variación de las provisiones de tráfico","a","a) Variación de provisiones de existencias"],
				["D-A-5-b","D","DEBE","A","A) GASTOS ( A1 a A16 )","5","A5. Variación de las provisiones de tráfico","b","b) Variación de provisiones y pérdidas de créditos incobrables"],
				["D-A-5-c","D","DEBE","A","A) GASTOS ( A1 a A16 )","5","A5. Variación de las provisiones de tráfico","c","c) Variación de otras provisiones de tráfico"],
				["D-A-6","D","DEBE","A","A) GASTOS ( A1 a A16 )","6","A6. Otros gastos de explotación","",""],
				["D-A-6-a","D","DEBE","A","A) GASTOS ( A1 a A16 )","6","A6. Otros gastos de explotación","a","a) Servicios exteriores"],
				["D-A-6-b","D","DEBE","A","A) GASTOS ( A1 a A16 )","6","A6. Otros gastos de explotación","b","b) Tributos"],
				["D-A-6-c","D","DEBE","A","A) GASTOS ( A1 a A16 )","6","A6. Otros gastos de explotación","c","c) Otros gastos de gestión corriente"],
				["D-A-6-d","D","DEBE","A","A) GASTOS ( A1 a A16 )","6","A6. Otros gastos de explotación","d","d) Dotación al fondo de reversión"],
				["D-I","D","DEBE","I","AI. BENEFICIOS DE EXPLOTACION   ( B1+B2+B3+B4-A1-A2-A3-A4-A5-A6 )","","","",""],
				["D-I-7","D","DEBE","I","AI. BENEFICIOS DE EXPLOTACION   ( B1+B2+B3+B4-A1-A2-A3-A4-A5-A6 )","7","A7. Gastos financieros y gastos asimilados","",""],
				["D-I-7-a","D","DEBE","I","AI. BENEFICIOS DE EXPLOTACION   ( B1+B2+B3+B4-A1-A2-A3-A4-A5-A6 )","7","A7. Gastos financieros y gastos asimilados","a","a) Por deudas con empresas del grupo"],
				["D-I-7-b","D","DEBE","I","AI. BENEFICIOS DE EXPLOTACION   ( B1+B2+B3+B4-A1-A2-A3-A4-A5-A6 )","7","A7. Gastos financieros y gastos asimilados","b","b) Por deudas con empresas asociadas"],
				["D-I-7-c","D","DEBE","I","AI. BENEFICIOS DE EXPLOTACION   ( B1+B2+B3+B4-A1-A2-A3-A4-A5-A6 )","7","A7. Gastos financieros y gastos asimilados","c","c) Por deudas con terceros y gastos asimilados"],
				["D-I-7-d","D","DEBE","I","AI. BENEFICIOS DE EXPLOTACION   ( B1+B2+B3+B4-A1-A2-A3-A4-A5-A6 )","7","A7. Gastos financieros y gastos asimilados","d","d) Pérdidas de inversiones financieras"],
				["D-I-8","D","DEBE","I","AI. BENEFICIOS DE EXPLOTACION   ( B1+B2+B3+B4-A1-A2-A3-A4-A5-A6 )","8","A8. Variación de las provisiones de inversiones financieras","",""],
				["D-I-9","D","DEBE","I","AI. BENEFICIOS DE EXPLOTACION   ( B1+B2+B3+B4-A1-A2-A3-A4-A5-A6 )","9","A9. Diferencias negativas de cambio","",""],
				["D-II","D","DEBE","II","AII. RESULTADOS FINANCIEROS POSITIVOS  ( B5+B6+B7+B8-A7-A8-A9 )","","","",""],
				["D-III","D","DEBE","III","AIII. BENEFICIOS DE LAS ACTIVIDADES ORDINARIAS ( AI+AII-BI-BII )","","","",""],
				["D-III-0","D","DEBE","III","AIII. BENEFICIOS DE LAS ACTIVIDADES ORDINARIAS ( AI+AII-BI-BII )","10","A10. Variación de las provisiones de inmovilizado inmaterial, material y cartera de control","",""],
				["D-III-1","D","DEBE","III","AIII. BENEFICIOS DE LAS ACTIVIDADES ORDINARIAS ( AI+AII-BI-BII )","11","A11. Pérdidas procedentes de inmovilizado inmaterial, material y cartera de control","",""],
				["D-III-2","D","DEBE","III","AIII. BENEFICIOS DE LAS ACTIVIDADES ORDINARIAS ( AI+AII-BI-BII )","12","A12. Pérdidas por operaciones con acciones y obligaciones propias","",""],
				["D-III-3","D","DEBE","III","AIII. BENEFICIOS DE LAS ACTIVIDADES ORDINARIAS ( AI+AII-BI-BII )","13","A13. Gastos extraordinarios","",""],
				["D-III-4","D","DEBE","III","AIII. BENEFICIOS DE LAS ACTIVIDADES ORDINARIAS ( AI+AII-BI-BII )","14","A14. Gastos y pérdidas de otros ejercicios","",""],
				["D-IV","D","DEBE","IV","AIV. RESULTADOS EXTRAORDINARIOS POSITIVOS ( B9+B10+B11+B12+B13-A10-A11-A12-A13-A14 )","","","",""],
				["D-V","D","DEBE","V","AV. BENEFICIOS ANTES DE IMPUESTOS ( AIII + AIV - BIII - BIV )","","","",""],
				["D-V-5","D","DEBE","V","AV. BENEFICIOS ANTES DE IMPUESTOS ( AIII + AIV - BIII - BIV )","15","A15. Impuesto sobre sociedades","",""],
				["D-V-6","D","DEBE","V","AV. BENEFICIOS ANTES DE IMPUESTOS ( AIII + AIV - BIII - BIV )","16","A16. Otros impuestos","",""],
				["D-VI","D","DEBE","VI","AVI. RESULTADOS DEL EJERCICIO ( BENEFICIOS ) ( AV - A15 - A16 )","","","",""],
				["H","H","HABER","","","","","",""],
				["H-B","H","HABER","B","B) INGRESOS( B1 a B13 )","","","",""],
				["H-B-1","H","HABER","B","B) INGRESOS( B1 a B13 )","1","B1. Importe neto de la cifra de negocios","",""],
				["H-B-1-a","H","HABER","B","B) INGRESOS( B1 a B13 )","1","B1. Importe neto de la cifra de negocios","a","a) Ventas"],
				["H-B-1-b","H","HABER","B","B) INGRESOS( B1 a B13 )","1","B1. Importe neto de la cifra de negocios","b","b) Prestaciones de servicios"],
				["H-B-1-c","H","HABER","B","B) INGRESOS( B1 a B13 )","1","B1. Importe neto de la cifra de negocios","c","c) Devoluciones y rappels sobre ventas"],
				["H-B-2","H","HABER","B","B) INGRESOS( B1 a B13 )","2","B2. Aumento de existencias de productos terminados y en curso de fabricación","",""],
				["H-B-3","H","HABER","B","B) INGRESOS( B1 a B13 )","3","B3. Trabajos efectuados por la empresa para el inmovilizado","",""],
				["H-B-4","H","HABER","B","B) INGRESOS( B1 a B13 )","4","B4. Otros ingresos de explotación","",""],
				["H-B-4-a","H","HABER","B","B) INGRESOS( B1 a B13 )","4","B4. Otros ingresos de explotación","a","a) Ingresos accesorios y otros de gestión corriente"],
				["H-B-4-b","H","HABER","B","B) INGRESOS( B1 a B13 )","4","B4. Otros ingresos de explotación","b","b) Subvenciones"],
				["H-B-4-c","H","HABER","B","B) INGRESOS( B1 a B13 )","4","B4. Otros ingresos de explotación","c","c) Exceso de provisiones de riesgos y gastos"],
				["H-I","H","HABER","I","BI. PERDIDAS DE EXPLOTACION  ( A1+A2+A3+A4+A5+A6-B1-B2-B3-B4 )","","","",""],
				["H-I-5","H","HABER","I","BI. PERDIDAS DE EXPLOTACION  ( A1+A2+A3+A4+A5+A6-B1-B2-B3-B4 )","5","B5. Ingresos de participaciones en capital","",""],
				["H-I-5-a","H","HABER","I","BI. PERDIDAS DE EXPLOTACION  ( A1+A2+A3+A4+A5+A6-B1-B2-B3-B4 )","5","B5. Ingresos de participaciones en capital","a","a) En empresas del grupo"],
				["H-I-5-b","H","HABER","I","BI. PERDIDAS DE EXPLOTACION  ( A1+A2+A3+A4+A5+A6-B1-B2-B3-B4 )","5","B5. Ingresos de participaciones en capital","b","b) En empresas asociadas"],
				["H-I-5-c","H","HABER","I","BI. PERDIDAS DE EXPLOTACION  ( A1+A2+A3+A4+A5+A6-B1-B2-B3-B4 )","5","B5. Ingresos de participaciones en capital","c","c) En empresas fuera del grupo"],
				["H-I-6","H","HABER","I","BI. PERDIDAS DE EXPLOTACION  ( A1+A2+A3+A4+A5+A6-B1-B2-B3-B4 )","6","B6. Ingresos de otros valores negociables y de créditos de activo inmovilizado","",""],
				["H-I-6-a","H","HABER","I","BI. PERDIDAS DE EXPLOTACION  ( A1+A2+A3+A4+A5+A6-B1-B2-B3-B4 )","6","B6. Ingresos de otros valores negociables y de créditos de activo inmovilizado","a","a) De empresas del grupo"],
				["H-I-6-b","H","HABER","I","BI. PERDIDAS DE EXPLOTACION  ( A1+A2+A3+A4+A5+A6-B1-B2-B3-B4 )","6","B6. Ingresos de otros valores negociables y de créditos de activo inmovilizado","b","b) De empresas asociadas"],
				["H-I-6-c","H","HABER","I","BI. PERDIDAS DE EXPLOTACION  ( A1+A2+A3+A4+A5+A6-B1-B2-B3-B4 )","6","B6. Ingresos de otros valores negociables y de créditos de activo inmovilizado","c","c) De empresas fuera del grupo"],
				["H-I-7","H","HABER","I","BI. PERDIDAS DE EXPLOTACION  ( A1+A2+A3+A4+A5+A6-B1-B2-B3-B4 )","7","B7. Otros intereses o ingresos asimilados","",""],
				["H-I-7-a","H","HABER","I","BI. PERDIDAS DE EXPLOTACION  ( A1+A2+A3+A4+A5+A6-B1-B2-B3-B4 )","7","B7. Otros intereses o ingresos asimilados","a","a) De empresas del grupo"],
				["H-I-7-b","H","HABER","I","BI. PERDIDAS DE EXPLOTACION  ( A1+A2+A3+A4+A5+A6-B1-B2-B3-B4 )","7","B7. Otros intereses o ingresos asimilados","b","b) De empresas asociadas"],
				["H-I-7-c","H","HABER","I","BI. PERDIDAS DE EXPLOTACION  ( A1+A2+A3+A4+A5+A6-B1-B2-B3-B4 )","7","B7. Otros intereses o ingresos asimilados","c","c) Otros intereses"],
				["H-I-7-d","H","HABER","I","BI. PERDIDAS DE EXPLOTACION  ( A1+A2+A3+A4+A5+A6-B1-B2-B3-B4 )","7","B7. Otros intereses o ingresos asimilados","d","d) Beneficios en inversiones financieras"],
				["H-I-8","H","HABER","I","BI. PERDIDAS DE EXPLOTACION  ( A1+A2+A3+A4+A5+A6-B1-B2-B3-B4 )","8","B8. Diferencias positivas de cambio","",""],
				["H-II","H","HABER","II","BII. RESULTADOS FINANCIEROS NEGATIVOS  ( A7+A8+A9-B5-B6-B7-B8 )","","","",""],
				["H-III","H","HABER","III","BIII. PERDIDAS DE LAS ACTIVIDADES ORDINARIAS ( BI + BII - AI - AII )","","","",""],
				["H-III-A","H","HABER","III","BIII. PERDIDAS DE LAS ACTIVIDADES ORDINARIAS ( BI + BII - AI - AII )","B9","B9. Beneficios en enajenación de inmovilizado inmaterial, material y cartera de control","",""],
				["H-III-B","H","HABER","III","BIII. PERDIDAS DE LAS ACTIVIDADES ORDINARIAS ( BI + BII - AI - AII )","B10","B10. Beneficios por operaciones con acciones y obligaciones propias","",""],
				["H-III-C","H","HABER","III","BIII. PERDIDAS DE LAS ACTIVIDADES ORDINARIAS ( BI + BII - AI - AII )","B11","B11. Subvenciones de capital transferidas al resultado del ejercicio","",""],
				["H-III-D","H","HABER","III","BIII. PERDIDAS DE LAS ACTIVIDADES ORDINARIAS ( BI + BII - AI - AII )","B12","B12. Ingresos extraordinarios","",""],
				["H-III-E","H","HABER","III","BIII. PERDIDAS DE LAS ACTIVIDADES ORDINARIAS ( BI + BII - AI - AII )","B13","B13. Ingresos y beneficios de otros ejercicios","",""],
				["H-IV","H","HABER","IV","BIV. RESULTADOS EXTRAORDINARIOS NEGATIVOS ( A10+A11+A12+A13+A14-B9-B10-B11-B12-B13 )","","","",""],
				["H-V","H","HABER","V","BV. PERDIDAS ANTES DE IMPUESTOS ( BIII + BIV - AIII - AIV )","","","",""],
				["H-VI","H","HABER","VI","BVI. RESULTADOS DEL EJERCICIO ( PERDIDAS ) ( BV + A15 + A16 )","","","",""],
				["P","P","PASIVO","","","","","",""],
				["P-A","P","PASIVO","A","A) FONDOS PROPIOS","","","",""],
				["P-A-I","P","PASIVO","A","A) FONDOS PROPIOS","I","I. Capital suscrito","",""],
				["P-A-II","P","PASIVO","A","A) FONDOS PROPIOS","II","II. Prima de emisión","",""],
				["P-A-III","P","PASIVO","A","A) FONDOS PROPIOS","III","III. Reserva de revalorización","",""],
				["P-A-IV","P","PASIVO","A","A) FONDOS PROPIOS","IV","IV. Reservas","",""],
				["P-A-IV-1","P","PASIVO","A","A) FONDOS PROPIOS","IV","IV. Reservas","1","1. Reserva legal"],
				["P-A-IV-2","P","PASIVO","A","A) FONDOS PROPIOS","IV","IV. Reservas","2","2. Reservas para acciones propias"],
				["P-A-IV-3","P","PASIVO","A","A) FONDOS PROPIOS","IV","IV. Reservas","3","3. Reservas para acciones de la sociedad dominante"],
				["P-A-IV-4","P","PASIVO","A","A) FONDOS PROPIOS","IV","IV. Reservas","4","4. Reservas estatutarias"],
				["P-A-IV-5","P","PASIVO","A","A) FONDOS PROPIOS","IV","IV. Reservas","5","5. Diferencias por ajuste del capital a euros"],
				["P-A-V","P","PASIVO","A","A) FONDOS PROPIOS","V","V. Resultados de ejercicios anteriores","",""],
				["P-A-V-1","P","PASIVO","A","A) FONDOS PROPIOS","V","V. Resultados de ejercicios anteriores","1","1. Remanente"],
				["P-A-V-2","P","PASIVO","A","A) FONDOS PROPIOS","V","V. Resultados de ejercicios anteriores","2","2. Resultados negativos de ejercicios anteriores"],
				["P-A-V-3","P","PASIVO","A","A) FONDOS PROPIOS","V","V. Resultados de ejercicios anteriores","3","3. Aportaciones de socios para compensación de pérdidas"],
				["P-A-VI","P","PASIVO","A","A) FONDOS PROPIOS","VI","VI. Pérdidas y ganancias ( Beneficio o Pérdida )","",""],
				["P-A-VII","P","PASIVO","A","A) FONDOS PROPIOS","VII","VII. Dividendo a cuenta entregado en el ejercicio","",""],
				["P-A-VIII","P","PASIVO","A","A) FONDOS PROPIOS","VIII","VIII. Acciones propias para reducción de capital","",""],
				["P-B","P","PASIVO","B","B) INGRESOS A DISTRIBUIR EN VARIOS EJERCICIOS","","","",""],
				["P-B-I","P","PASIVO","B","B) INGRESOS A DISTRIBUIR EN VARIOS EJERCICIOS","I","1. Subvenciones de capital","",""],
				["P-B-II","P","PASIVO","B","B) INGRESOS A DISTRIBUIR EN VARIOS EJERCICIOS","II","2. Diferencias positivas de cambio","",""],
				["P-B-III","P","PASIVO","B","B) INGRESOS A DISTRIBUIR EN VARIOS EJERCICIOS","III","3. Otros ingresos a distribuir en varios ejercicios","",""],
				["P-B-IV","P","PASIVO","B","B) INGRESOS A DISTRIBUIR EN VARIOS EJERCICIOS","IV","4. Ingresos fiscales a distribuir en varios ejercicios","",""],
				["P-C","P","PASIVO","C","C) PROVISIONES PARA RIESGOS Y GASTOS","","","",""],
				["P-C-I","P","PASIVO","C","C) PROVISIONES PARA RIESGOS Y GASTOS","I","1. Provisiones para pensiones y obligaciones similares","",""],
				["P-C-II","P","PASIVO","C","C) PROVISIONES PARA RIESGOS Y GASTOS","II","2. Provisiones para impuestos","",""],
				["P-C-III","P","PASIVO","C","C) PROVISIONES PARA RIESGOS Y GASTOS","III","3. Otras provisiones","",""],
				["P-C-IV","P","PASIVO","C","C) PROVISIONES PARA RIESGOS Y GASTOS","IV","4. Fondo de reversión","",""],
				["P-D","P","PASIVO","D","D) ACREEDORES A LARGO PLAZO","","","",""],
				["P-D-I","P","PASIVO","D","D) ACREEDORES A LARGO PLAZO","I","I. Emisiones de obligaciones y otros valores negociables","",""],
				["P-D-I-1","P","PASIVO","D","D) ACREEDORES A LARGO PLAZO","I","I. Emisiones de obligaciones y otros valores negociables","1","1. Obligaciones no convertibles"],
				["P-D-I-2","P","PASIVO","D","D) ACREEDORES A LARGO PLAZO","I","I. Emisiones de obligaciones y otros valores negociables","2","2. Obligaciones convertibles"],
				["P-D-I-3","P","PASIVO","D","D) ACREEDORES A LARGO PLAZO","I","I. Emisiones de obligaciones y otros valores negociables","3","3. Otras deudas representadas en valores negociables"],
				["P-D-II","P","PASIVO","D","D) ACREEDORES A LARGO PLAZO","II","II. Deudas con entidades de crédito","",""],
				["P-D-II-1","P","PASIVO","D","D) ACREEDORES A LARGO PLAZO","II","II. Deudas con entidades de crédito","1","1. Deudas a largo plazo con entidades de crédito"],
				["P-D-II-2","P","PASIVO","D","D) ACREEDORES A LARGO PLAZO","II","II. Deudas con entidades de crédito","2","2. Acreedores por arrendamiento financiero a largo plazo"],
				["P-D-III","P","PASIVO","D","D) ACREEDORES A LARGO PLAZO","III","III. Deudas con empresas del grupo y asociadas","",""],
				["P-D-III-1","P","PASIVO","D","D) ACREEDORES A LARGO PLAZO","III","III. Deudas con empresas del grupo y asociadas","1","1. Deudas con empresas del grupo"],
				["P-D-III-2","P","PASIVO","D","D) ACREEDORES A LARGO PLAZO","III","III. Deudas con empresas del grupo y asociadas","2","2. Deudas con empresas asociadas"],
				["P-D-IV","P","PASIVO","D","D) ACREEDORES A LARGO PLAZO","IV","IV. Otros acreedores","",""],
				["P-D-IV-1","P","PASIVO","D","D) ACREEDORES A LARGO PLAZO","IV","IV. Otros acreedores","1","1. Deudas representadas por efectos a pagar"],
				["P-D-IV-2","P","PASIVO","D","D) ACREEDORES A LARGO PLAZO","IV","IV. Otros acreedores","2","2. Otras deudas"],
				["P-D-IV-3","P","PASIVO","D","D) ACREEDORES A LARGO PLAZO","IV","IV. Otros acreedores","3","3. Fianzas y depósitos recibidos a largo plazo"],
				["P-D-IV-4","P","PASIVO","D","D) ACREEDORES A LARGO PLAZO","IV","IV. Otros acreedores","4","4. Administraciones públicas a largo plazo"],
				["P-D-V","P","PASIVO","D","D) ACREEDORES A LARGO PLAZO","V","V. Desembolsos pendientes sobre acciones no exigidos","",""],
				["P-D-V-1","P","PASIVO","D","D) ACREEDORES A LARGO PLAZO","V","V. Desembolsos pendientes sobre acciones no exigidos","1","1. De empresas del grupo"],
				["P-D-V-2","P","PASIVO","D","D) ACREEDORES A LARGO PLAZO","V","V. Desembolsos pendientes sobre acciones no exigidos","2","2. De empresas asociadas"],
				["P-D-V-3","P","PASIVO","D","D) ACREEDORES A LARGO PLAZO","V","V. Desembolsos pendientes sobre acciones no exigidos","3","3. De otras empresas"],
				["P-D-VI","P","PASIVO","D","D) ACREEDORES A LARGO PLAZO","VI","VI. Acreedores por operaciones de tráfico a largo plazo","",""],
				["P-E","P","PASIVO","E","E) ACREEDORES A CORTO PLAZO","","","",""],
				["P-E-I","P","PASIVO","E","E) ACREEDORES A CORTO PLAZO","I","I. Emisiones de obligaciones y otros valores negociables","",""],
				["P-E-I-1","P","PASIVO","E","E) ACREEDORES A CORTO PLAZO","I","I. Emisiones de obligaciones y otros valores negociables","1","1. Obligaciones no convertibles"],
				["P-E-I-2","P","PASIVO","E","E) ACREEDORES A CORTO PLAZO","I","I. Emisiones de obligaciones y otros valores negociables","2","2. Obligaciones convertibles"],
				["P-E-I-3","P","PASIVO","E","E) ACREEDORES A CORTO PLAZO","I","I. Emisiones de obligaciones y otros valores negociables","3","3. Otras deudas representadas en valores negociables"],
				["P-E-I-4","P","PASIVO","E","E) ACREEDORES A CORTO PLAZO","I","I. Emisiones de obligaciones y otros valores negociables","4","4. Intereses de obligaciones y otros valores"],
				["P-E-II","P","PASIVO","E","E) ACREEDORES A CORTO PLAZO","II","II. Deudas con entidades de crédito","",""],
				["P-E-II-1","P","PASIVO","E","E) ACREEDORES A CORTO PLAZO","II","II. Deudas con entidades de crédito","1","1. Préstamos y otras deudas"],
				["P-E-II-2","P","PASIVO","E","E) ACREEDORES A CORTO PLAZO","II","II. Deudas con entidades de crédito","2","2. Deudas por intereses"],
				["P-E-II-3","P","PASIVO","E","E) ACREEDORES A CORTO PLAZO","II","II. Deudas con entidades de crédito","3","3. Acreedores por arrendamiento financiero a corto plazo"],
				["P-E-III","P","PASIVO","E","E) ACREEDORES A CORTO PLAZO","III","III. Deudas con empresas del grupo y asociadas a corto plazo","",""],
				["P-E-III-1","P","PASIVO","E","E) ACREEDORES A CORTO PLAZO","III","III. Deudas con empresas del grupo y asociadas a corto plazo","1","1. Deudas con empresas del grupo"],
				["P-E-III-2","P","PASIVO","E","E) ACREEDORES A CORTO PLAZO","III","III. Deudas con empresas del grupo y asociadas a corto plazo","2","2. Deudas con empresas asociadas"],
				["P-E-IV","P","PASIVO","E","E) ACREEDORES A CORTO PLAZO","IV","IV. Acreedores comerciales","",""],
				["P-E-IV-1","P","PASIVO","E","E) ACREEDORES A CORTO PLAZO","IV","IV. Acreedores comerciales","1","1. Anticipos recibidos por pedidos"],
				["P-E-IV-2","P","PASIVO","E","E) ACREEDORES A CORTO PLAZO","IV","IV. Acreedores comerciales","2","2. Deudas por compras o prestaciones de servicios"],
				["P-E-IV-3","P","PASIVO","E","E) ACREEDORES A CORTO PLAZO","IV","IV. Acreedores comerciales","3","3. Deudas representadas por efectos a pagar"],
				["P-E-V","P","PASIVO","E","E) ACREEDORES A CORTO PLAZO","V","V. Otras deudas no comerciales","",""],
				["P-E-V-1","P","PASIVO","E","E) ACREEDORES A CORTO PLAZO","V","V. Otras deudas no comerciales","1","1. Administraciones públicas"],
				["P-E-V-2","P","PASIVO","E","E) ACREEDORES A CORTO PLAZO","V","V. Otras deudas no comerciales","2","2. Deudas representadas por efectos a pagar"],
				["P-E-V-3","P","PASIVO","E","E) ACREEDORES A CORTO PLAZO","V","V. Otras deudas no comerciales","3","3. Otras deudas"],
				["P-E-V-4","P","PASIVO","E","E) ACREEDORES A CORTO PLAZO","V","V. Otras deudas no comerciales","4","4. Remuneraciones pendientes de pago"],
				["P-E-V-5","P","PASIVO","E","E) ACREEDORES A CORTO PLAZO","V","V. Otras deudas no comerciales","5","5. Fianzas y depósitos recibidos a corto plazo"],
				["P-E-VI","P","PASIVO","E","E) ACREEDORES A CORTO PLAZO","VI","VI. Provisiones para operaciones de tráfico","",""],
				["P-E-VII","P","PASIVO","E","E) ACREEDORES A CORTO PLAZO","VII","VII. Ajustes por periodificación","",""],
				["P-F","P","PASIVO","F","F) PROVISIONES PARA RIESGOS Y GASTOS A CORTO PLAZO","","","",""],
				["P-G","P","PASIVO","G","TOTAL  PASIVO","","","",""]];
		
		for (i = 0; i < datos.length; i++) {
				with(curCbl) {
						setModeAccess(curCbl.Insert);
						refreshBuffer();
						setValueBuffer("codbalance", datos[i][0]);
						setValueBuffer("naturaleza", datos[i][2]);
						setValueBuffer("nivel1", datos[i][3]);
						setValueBuffer("descripcion1", datos[i][4]);
						setValueBuffer("nivel2", datos[i][5]);
						setValueBuffer("descripcion2", datos[i][6]);
						setValueBuffer("nivel3", datos[i][7]);
						setValueBuffer("descripcion3", datos[i][8]);
						commitBuffer();
				}
		}
}

/** \D Se generan las subcuentas, independientes del ejercicio
@param codEjercicio Código del ejercicio sobre el que se generan las subcuentas
@param longSubcuenta Número de dígitos de subcuenta del ejercicio sobre el que se generan las subcuentas
\end */
function oficial_generarSubcuentas(codEjercicio, longSubcuenta)
{
		var util:FLUtil = new FLUtil();
		var i,j:Number; 
		var numCuentas:Number = this.iface.valorPorClave("co_cuentas", "count(codcuenta)", "codejercicio = '" + codEjercicio + "'");
		
		var cont1:Number = 0
		var cont2:Number = 0;
		util.createProgressDialog(util.translate("scripts", "Generando Subcuentas"), numCuentas);
		util.setProgress(0);
		
		var curCuenta:FLSqlCursor = new FLSqlCursor("co_cuentas");
		var curSubcuenta:FLSqlCursor = new FLSqlCursor("co_subcuentas");
		curCuenta.setActivatedCheckIntegrity(false);
		curSubcuenta.setActivatedCheckIntegrity(false);
		curCuenta.select("codejercicio = '" + codEjercicio + "'");
		var codSubcuenta:String;
		var numCeros:Number;
		
		while (curCuenta.next()) {
				curCuenta.setModeAccess(curCuenta.Browse);
				curCuenta.refreshBuffer();
				codSubcuenta = curCuenta.valueBuffer("codcuenta");
				
				//D Para evitar duplicados en las subcuentas cuando hay dos cuentas con el código x00 y x000
				var auxCSC:String = codSubcuenta.toString();
				
				numCeros = longSubcuenta - codSubcuenta.toString().length;
				for (var i = 0; i < numCeros; i++)
						codSubcuenta += "0";
						
				if (auxCSC.length > 3 && auxCSC.right(1) == "0") 
						codSubcuenta = codSubcuenta.left(codSubcuenta.length-1) + "1";
						
				//D Para evitar duplicados en las subcuentas durante las importaciones
				curSubcuenta.select("codsubcuenta = '" + codSubcuenta + "' AND codejercicio = '" + codEjercicio + "'");
				if (curSubcuenta.first()) {
					continue;
				}
				
				with(curSubcuenta) {
						setModeAccess(curSubcuenta.Insert);
						refreshBuffer();
						setValueBuffer("codsubcuenta", codSubcuenta);
						setValueBuffer("descripcion", curCuenta.valueBuffer("descripcion"));
						setValueBuffer("codejercicio", codEjercicio);
						setValueBuffer("idcuenta", curCuenta.valueBuffer("idcuenta"));
						setValueBuffer("codcuenta", curCuenta.valueBuffer("codcuenta"));
						setValueBuffer("idcuentaesp", curCuenta.valueBuffer("idcuentaesp"));
						setValueBuffer("coddivisa", util.sqlSelect("empresa", "coddivisa", "1 = 1"));
						commitBuffer();
				}
				
				cont1++;
				cont2++;
				if (cont2 > 20) {
						cont2 = 0;
						util.setProgress(cont1);
				}
		}
		util.setProgress(numCuentas);
}

/** \D Utilizado para realizar una consulta sencilla rápidamente con un sólo valor como resultado. Se realiza mediante un FLSqlQuery

@param tabla Argumento de setTablesList 
@param campo Argumento de setSelect
@param tabla Argumento de setWhere
@param tabla Argumento de setFrom

@return Resultado de la consulta, false si no se encontró ningún valor
\end */
function oficial_valorPorClave(tabla, campo, where, listaTablas)
{
		var query:FLSqlQuery = new FLSqlQuery();
		if (listaTablas)
				query.setTablesList(listaTablas);
		else
				query.setTablesList(tabla);
		query.setSelect(campo);
		query.setFrom(tabla);
		query.setWhere(where);
		try { query.setForwardOnly( true ); } catch (e) {}
		if ( query.exec() )
			if ( query.next() )
				return query.value( 0 );

		return false;
}

/** \D Comprueba si la subcuenta es de I.V.A. y si la fecha del asiento está comprendida en un período de regularización de I.V.A. Si el asiento es el de regularización, devuelve siempre Verdadero

@param idSubcuenta Subcuenta a comprobar
@param idAsiento Asiento a comprobar
@return Verdadero si la condición no se cumple (no es I.V.A. o no está comprendida o el asiento es de regularizacón de I.V.A.)
\end */
function oficial_comprobarRegIVA(idSubcuenta, idAsiento):Boolean
{
	var util:FLUtil = new FLUtil();
	if (util.sqlSelect("co_regiva", "idregiva", "idasiento = " + idAsiento)) {
		return true;
	}

	var idCuentaEsp:String = util.sqlSelect("co_subcuentas s INNER JOIN co_cuentas c ON s.idcuenta = c.idcuenta", "c.idcuentaesp", "s.idsubcuenta = " + idSubcuenta, "co_subcuentas,co_cuentas");
	if (idCuentaEsp == "IVAREP" || idCuentaEsp == "IVASOP") {
		var fechaAsiento:String = util.sqlSelect("co_asientos", "fecha", "idasiento = " + idAsiento);
		var ejercicioAsiento:String = util.sqlSelect("co_asientos", "codejercicio", "idasiento = " + idAsiento);
		if (util.sqlSelect("co_regiva", "idregiva", "fechainicio <= '" + fechaAsiento + "' AND fechafin >= '" + fechaAsiento + "' and codejercicio = '" + ejercicioAsiento + "'")) {
			MessageBox.warning(util.translate("scripts", "No puede modificarse una partida de I.V.A. en un período ya regularizado"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}
	return true;
}

/** \D Actualiza los campos Debe, Haber y Saldo de la subcuenta especificada sumando los campos debe y haber de las partidas que utilizan la subcuenta

@param idsubcuenta Id de la subcuenta
@return True en caso de éxito, false en caso contrario
\end */
function oficial_calcularSaldo(idSubcuenta):Boolean
{
	var util:FLUtil = new FLUtil;
	var qryTotales:FLSqlQuery = new FLSqlQuery();
	with (qryTotales) {
		setTablesList("co_partidas");
		setSelect("SUM(debe), SUM(haber)");
		setFrom("co_partidas");
		setWhere("idsubcuenta = " + idSubcuenta);
	}
	try { qryTotales.setForwardOnly( true ); } catch (e) {}
	if (!qryTotales.exec()) {
		return false;
	}
	var debe:Number = 0;
	var haber:Number = 0;
	var saldo:Number = 0;
	if (qryTotales.next()) {
		debe = parseFloat(qryTotales.value(0));
		if (isNaN(debe))
			debe = 0;
		debe = util.roundFieldValue(debe, "co_subcuentas", "debe");
		haber = parseFloat(qryTotales.value(1));
		if (isNaN(haber))
			haber = 0;
		haber = util.roundFieldValue(haber, "co_subcuentas", "haber");
		saldo = debe - haber;
		saldo = util.roundFieldValue(saldo, "co_subcuentas", "saldo");
	}
	var curSubcuenta:FLSqlCursor = new FLSqlCursor("co_subcuentas");
	curSubcuenta.select("idsubcuenta = " + idSubcuenta);
	if (!curSubcuenta.first())
		return false;
	with (curSubcuenta) {
		setModeAccess(curSubcuenta.Edit);
		refreshBuffer();
		setValueBuffer("debe", debe);
		setValueBuffer("haber", haber);
		setValueBuffer("saldo", saldo);
	}
	if (!curSubcuenta.commitBuffer())
		return false;
	
	return true;
}

/** \D Reformateaa el valor de codSubcuenta reemplazando el carácter ".", si es que existe, por los ceros "0" necesarios hasta completar el número de dígitos de subcuenta del ejercicio actual, a su vez elimina los caracteres sobrantes cuando se supere el límite de dígitos.

@param curFormSubcuenta: Formulario en el que se encuentra el campo subcuenta
@param campoSubcuenta: Nombre del campo subcuenta
@param longSubcuenta: Longitud de las subcuentas
@param posPuntoActual: Posición del punto en el valor actual de la subcuenta

@return Nueva posición del punto en el valor actual de la subcuenta
\end */
function oficial_formatearCodSubcta(curFormSubcuenta:Object, campoSubcuenta:String, longSubcuenta:Number, posPuntoActual:Number):Number
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = curFormSubcuenta.cursor();
	var cambiado:Boolean = false;
	var valCodSubcta:String = curFormSubcuenta.child(campoSubcuenta).value().toString();
	var lenValCodSubcta:Number = valCodSubcta.length;
	var nuevoPunto:Number = valCodSubcta.find(".");
	
	if (nuevoPunto < 0 && lenValCodSubcta > longSubcuenta) { 
		// En caso de superar el nº de dígitos, se eliminarán los ceros insertados por el "."
		if (posPuntoActual >= 0) {
			if (valCodSubcta.mid(posPuntoActual,1) == "0") 
				// Sólo en caso de que sigan existiendo "0" insertados
				valCodSubcta = valCodSubcta.left(posPuntoActual) + valCodSubcta.right(longSubcuenta - posPuntoActual);
		}
		if (valCodSubcta.length > longSubcuenta) { 
			// Pero si ya se eliminaron los "0" insertados, se elimina el último dígito tecleado.
			valCodSubcta = valCodSubcta.left(longSubcuenta);
		} 
		cambiado = true;
	}
	if (nuevoPunto > -1 && posPuntoActual > -1) {
		// El punto pulsado por segunda vez debe sustituir al anterior
		posPuntoActual = -1;
	}
	
	if (posPuntoActual == -1)
		posPuntoActual = nuevoPunto;
	if (nuevoPunto > -1) {
		var numCeros = longSubcuenta - (valCodSubcta.length-1);
		var strCeros = "";
		for (var i = 0; i < numCeros; i++)
			strCeros += "0";
		valCodSubcta = valCodSubcta.replace(".", strCeros);
		cambiado = true;
	}
	if (cambiado) {
		curFormSubcuenta.child(campoSubcuenta).setValue(valCodSubcta);
	}
	return posPuntoActual;
}

function oficial_rellenarSubcuentas()
{
	var util:FLUtil = new FLUtil;
	var i:Number = 0;
	if (!util.sqlSelect("co_subcuentascli", "id", "1 = 1")) {
		var qryClientes:FLSqlQuery = new FLSqlQuery();
		qryClientes.setTablesList("clientes");
		qryClientes.setSelect("codcliente, codsubcuenta, nombre");
		qryClientes.setFrom("clientes");
		qryClientes.setWhere("codsubcuenta IS NOT NULL AND codsubcuenta <> ''");
		if (!qryClientes.exec())
			return;
		util.createProgressDialog(util.translate("scripts", "Creando subcuentas por cliente"), qryClientes.size());
		util.setProgress(0);
		while (qryClientes.next()) {
			flfactppal.iface.pub_rellenarSubcuentasCli(qryClientes.value(0), qryClientes.value(1), qryClientes.value(2));
			util.setProgress(i++);
		}
		util.setProgress(qryClientes.size());
		util.destroyProgressDialog();
	}
	i = 0;
	if (!util.sqlSelect("co_subcuentasprov", "id", "1 = 1")) {
		var qryProveedores:FLSqlQuery = new FLSqlQuery();
		qryProveedores.setTablesList("proveedores");
		qryProveedores.setSelect("codproveedor, codsubcuenta, nombre");
		qryProveedores.setFrom("proveedores");
		qryProveedores.setWhere("codsubcuenta IS NOT NULL AND codsubcuenta <> ''");
		if (!qryProveedores.exec())
			return;
		util.createProgressDialog(util.translate("scripts", "Creando subcuentas por proveedor"), qryProveedores.size());
		util.setProgress(0);
		while (qryProveedores.next()) {
			flfactppal.iface.pub_rellenarSubcuentasProv(qryProveedores.value(0), qryProveedores.value(1), qryProveedores.value(2));
			util.setProgress(i++);
		}
		util.setProgress(qryProveedores.size());
		util.destroyProgressDialog();
	}
}

/** \D Limpia la memoria para los asientos predefinidos
\end */
function oficial_clearPreMemoria()
{
	this.iface.PreMemorias.splice(0,this.iface.PreMemorias.length);
//	delete (this.iface.PreMemorias);
//	this.iface.PreMemorias = new Array(0);
}

/** \D Retorna el array con todas las memorias
@return	el array PreMemorias
\end */
function oficial_arrayPreMemoria():Array {
	return this.iface.PreMemorias;
}

/** \D Reescribe el array con todas las memorias
@param	nuevoArray: El nuevo array para PreMemorias
\end */
function oficial_reponerArrayPreMemoria(nuevoArray:Array) {
	this.iface.PreMemorias = nuevoArray.slice(0, nuevoArray.length);
}

/** \D Establece un valor en la memoria para los asientos predefinidos
@param	nombreMemoria: Identificador de la variable
@param	valorMemoria: Nuevo valor
\end */
function oficial_putPreMemoria(nombreMemoria:String, valorMemoria:String)
{
	var lugarOcupado:Number = this.iface.lugarPreMemoria(nombreMemoria);
	if (lugarOcupado == -1) {
		this.iface.PreMemorias.push(nombreMemoria);
		this.iface.PreMemorias.push(valorMemoria);
	}
	else // Ya existía
		this.iface.PreMemorias[lugarOcupado+1] = valorMemoria;
}

/** \D Establece un valor en un lugar de la memoria para los asientos predefinidos
@param	lugarOcupado: posición de la variable en la memoria
@param	nombreMemoria: Identificador de la variable
@param	valorMemoria: Nuevo valor
@return	lugarOcupado: posición de la variable en la memoria
\end */
function oficial_putLugarPreMemoria(lugarOcupado:Number, nombreMemoria:String, valorMemoria:String):Number
{
	if (lugarOcupado < 0) lugarOcupado = this.iface.PreMemorias.length;
	if (lugarOcupado >= this.iface.PreMemorias.length) {
		this.iface.PreMemorias.push(nombreMemoria);
		lugarOcupado = this.iface.PreMemorias.push(valorMemoria)-2;
	}
	else { // Ya existía
		this.iface.PreMemorias[lugarOcupado] = nombreMemoria;
		this.iface.PreMemorias[lugarOcupado+1] = valorMemoria;
	}
	return lugarOcupado;
}

/** \D Obtiene un valor de la memoria para los asientos predefinidos
@param	nombreMemoria: Identificador de la variable
@return	valor almacenado
\end */
function oficial_getPreMemoria(nombreMemoria:String):String
{
	var lugarOcupado:Number = this.iface.lugarPreMemoria(nombreMemoria);
	var res:String = "";
	if (lugarOcupado != -1) {
		res = this.iface.PreMemorias[lugarOcupado+1];
	}
	return res;
}

/** \D Obtiene el lugar que un valor tiene en la memoria para los asientos predefinidos
@param	nombreMemoria: Identificador de la variable
@return	Índice del valor en la memoria
\end */
function oficial_lugarPreMemoria(nombreMemoria:String):Number
{
	var contador:Number = this.iface.PreMemorias.length;
	var res:Number = -1;
	for (var i:Number = 0; i < contador; i+=2)
		if (this.iface.PreMemorias[i] == nombreMemoria)
			res = i;
	return res;
}

/** \D Obtiene un nombre identificador de la memoria para los asientos predefinidos
@param	nombreMemoria: Identificador de la variable
@return	valor almacenado
\end */
function oficial_getNombrePreMemoria(lugarOcupado:Number):String
{
	var res:String = "";
	if (lugarOcupado >= 0 && lugarOcupado < this.iface.PreMemorias.length) {
		res = this.iface.PreMemorias[lugarOcupado];
	}
	return res;
}

/** \D Obtiene la cantidad de valores existente en la memoria
@param	nombreMemoria: Identificador de la variable
@return	Cantidad de valores en la memoria
\end */
function oficial_cantidadPreMemoria():Number
{
	var total:Number = this.iface.PreMemorias.length;
	return total;
}

/** \D
Obtiene el siguiente número de la secuencia de documentos contables por ejercicio
@param codEjercicio: Código de ejercicio del documento
@param fN: Tipo de documento (factura a cliente, a proveedor, albarán, etc.)
@return Número correspondiente al siguiente documento en la serie o false si hay error
\end */
function oficial_siguienteNumero(codEjercicio:String, fN:String):Number
{
	var numero:Number;
	var siguienteNumero:Number;
	var vOut:Boolean;

	var util:FLUtil = new FLUtil;
	var cursorSecuencias:FLSqlCursor = new FLSqlCursor("co_secuencias");
	cursorSecuencias.setContext(this);
	cursorSecuencias.setActivatedCheckIntegrity(false);
	cursorSecuencias.select("upper(codejercicio)='" + codEjercicio + "' AND nombre = '" + fN + "'");
	if (cursorSecuencias.next()) {
		cursorSecuencias.setModeAccess( cursorSecuencias.Edit );
		cursorSecuencias.refreshBuffer();
		if ( !cursorSecuencias.isNull( "valorout" ) ) {
			vOut = true;
			numero = cursorSecuencias.valueBuffer( "valorout" );
		} else {
			vOut = false;
			numero = cursorSecuencias.valueBuffer( "valor" );
		}

		if (!numero)
			numero = 1;
		siguienteNumero = (parseFloat(numero) + 1);

		if (vOut) {
			cursorSecuencias.setValueBuffer( "valorout", siguienteNumero );

		} else {
			cursorSecuencias.setValueBuffer( "valor", siguienteNumero );
		}
		cursorSecuencias.commitBuffer();

	} else {
		numero = util.sqlSelect("co_asientos", "numero", "codejercicio = '" + codEjercicio + "' ORDER BY numero DESC");
		if (!numero)
			numero = 0;

		numero = parseFloat(numero) + 1;
		siguienteNumero = parseFloat(numero) + 1;
		cursorSecuencias.setModeAccess( cursorSecuencias.Insert );
		cursorSecuencias.refreshBuffer();
		cursorSecuencias.setValueBuffer( "codejercicio", codEjercicio);
		cursorSecuencias.setValueBuffer( "nombre", fN );
		cursorSecuencias.setValueBuffer( "valorout",  siguienteNumero);
		cursorSecuencias.commitBuffer();
	}
	cursorSecuencias.setActivatedCheckIntegrity(true);

	return numero;
}

/** \C Comprueba que el asiento generado esté cuadrado y que todas las subcuentas pertenezcan al mismo ejercicio
@param	idAsiento: Identificador del asiento
@return	true si el asiento es correcto, false en caso contrario
\end */
function oficial_comprobarAsiento(idAsiento:String, omitirImporte:Boolean):Boolean
{
	var util:FLUtil = new FLUtil;

	var totalDebe:Number = 0;
	var totalHaber:Number = 0;
	var lista:String = util.translate("scripts", "\nSubcuenta\tDebe\Haber\t");
	var qryPartidas:FLSqlQuery = new FLSqlQuery();
	with (qryPartidas) {
		setTablesList("co_partidas");
		setSelect("codsubcuenta, debe, haber");
		setFrom("co_partidas");
		setWhere("idasiento = " + idAsiento);
		setForwardOnly(true);
	}
	if (!qryPartidas.exec())
		return false;

	var debe:Number;
	var haber:Number;
	while (qryPartidas.next()) {
		debe = parseFloat(qryPartidas.value("debe"));
		if (isNaN(debe))
			debe = 0;
		haber = parseFloat(qryPartidas.value("haber"));
		if (isNaN(haber))
			haber = 0;

		if (debe != util.roundFieldValue(debe, "co_partidas", "debe") || haber != util.roundFieldValue(haber, "co_partidas", "haber")) {
			MessageBox.critical(util.translate("scripts", "Error de redondeo:\nSubcuenta\tDebe\Haber \n%2\n%3\n%4").arg(qryPartidas.value("codsubcuenta")).arg(debe).arg(haber), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
		debe = util.roundFieldValue(debe, "co_partidas", "debe");
		haber = util.roundFieldValue(haber, "co_partidas", "haber");
		totalDebe += parseFloat(debe);
		totalHaber += parseFloat(haber);
		lista += "\n" + qryPartidas.value("codsubcuenta") + "\t" + qryPartidas.value("debe") + "\t" + qryPartidas.value("haber");
	}
	// Redondeo porque totalDebe += parseFloat(debe); mete decimales que no existen
	totalDebe = util.roundFieldValue(totalDebe, "co_partidas", "debe");
	totalHaber = util.roundFieldValue(totalHaber, "co_partidas", "haber");
	if (totalDebe != totalHaber) {
		MessageBox.critical(util.translate("scripts", "Ha habido un error al generar el asiento:\nEl asiento no cuadra:%1").arg(lista), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	if (util.sqlSelect("co_partidas p inner join co_asientos a on p.idasiento = a.idasiento inner join co_subcuentas s on p.idsubcuenta = s.idsubcuenta", "a.idasiento", "a.idasiento = " + idAsiento + " AND a.codejercicio <> s.codejercicio", "co_asientos,co_partidas,co_subcuentas")) {
		MessageBox.critical(util.translate("scripts", "Ha habido un error al generar el asiento:\nEl ejercicio de las distintas subcuentas no coincide.\n Asegúrese de estar en el ejercicio correcto y vuelva a generar el asiento."), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	if (!omitirImporte) {
		if (!this.iface.informarImporteAsiento(idAsiento, totalDebe)) {
			return false;
		}
	}
	return true;
}

function oficial_informarImporteAsiento(idAsiento:String, importe:Number):Boolean
{
	var curAsiento:FLSqlCursor = new FLSqlCursor("co_asientos");
	curAsiento.select("idasiento = " + idAsiento);
	if (!curAsiento.first()) {
		return false;
	}

	var editable:Boolean = curAsiento.valueBuffer("editable");
	if (!editable) {
		curAsiento.setUnLock("editable", true);
		curAsiento.select("idasiento = " + idAsiento);
		if (!curAsiento.first()) {
			return false;
		}
	}
	curAsiento.setModeAccess(curAsiento.Edit);
	curAsiento.refreshBuffer();
	curAsiento.setValueBuffer("importe", importe);
	if (!curAsiento.commitBuffer()) {
		return false;
	}

	if (!editable) {
		curAsiento.select("idasiento = " + idAsiento);
		if (!curAsiento.first()) {
			return false;
		}
		curAsiento.setUnLock("editable", false);
	}
	return true;
}

function oficial_generarAsientoDotacion(curDotacion:FLSqlCursor):Boolean
{
	if (curDotacion.modeAccess() != curDotacion.Insert && curDotacion.modeAccess() != curDotacion.Edit)
		return true;

	if (curDotacion.valueBuffer("nogenerarasiento")) {
		curDotacion.setNull("idasiento");
		return true;
	}

	var util:FLUtil = new FLUtil;
	var ejercicios:Array = [];
	var datosAsiento:Array = [];
	var valoresDefecto:Array;
	var fecha:Date = curDotacion.valueBuffer("fecha");
	
	var idAsiento:Number = curDotacion.valueBuffer("idasiento");
	var ejercicio:String = "";
	if (idAsiento) {
		ejercicio = util.sqlSelect("co_asientos","codejercicio","idasiento = " + idAsiento);
	} else {
		ejercicio = flfactppal.iface.pub_ejercicioActual();
// 		var qryEjercicio:FLSqlQuery = new FLSqlQuery();
// 		qryEjercicio.setTablesList("ejercicios");
// 		qryEjercicio.setSelect("codejercicio");
// 		qryEjercicio.setFrom("ejercicios");
// 		qryEjercicio.setWhere("fechainicio <= '" + fecha + "' AND fechafin >= '" + fecha + "'");
// 		
// 		if (!qryEjercicio.exec()) {
// 			return false;
// 		}
// 	
// 		while (qryEjercicio.next()) {
// 			ejercicios[ejercicios.length] = qryEjercicio.value("codejercicio");
// 		}
// debug("Ejercicios = " + ejercicios);
// 		if (qryEjercicio.size() == 0) {
// 			MessageBox.warning(util.translate("scripts", "No existe ningún ejercicio para la fecha de la dotación"), MessageBox.Ok, MessageBox.NoButton);
// 			return false;
// 		}
// 		var seleccion:Number = -1;
// 		if (ejercicios.length > 1) {
// 			var dialog = new Dialog;
// 			dialog.caption = "Ejercicios";
// 			dialog.okButtonText = "Aceptar"
// 			dialog.cancelButtonText = "Cancelar";
// 			var gbx = new GroupBox;
// 			gbx.title = util.translate("scripts", "Existe más de un ejercicio para la fecha establecida. Seleccione el que corresponda.");
// 			dialog.add( gbx );
// 			var opciones:Array = [];
// 			for (var j=0; j < ejercicios.length; j++) {
// 				opciones[j] = new RadioButton;
// 				var nombreEjercicio:String = util.sqlSelect("ejercicios", "nombre", "codejercicio = '" + ejercicios[j] + "'");
// 				opciones[j].text = ejercicios[j] + " - " + nombreEjercicio;
// 				gbx.add( opciones[j] );
// 			}
// 			
// 			if (!dialog.exec() ) {
// 				return false;
// 			}
// 			
// 			for (var j=0; j < ejercicios.length; j++) {
// 				if (opciones[j].checked) {
// 					seleccion = j;
// 					break;
// 				}
// 			}
// 			if (seleccion == -1) {
// 				return false;
// 			}
// 			ejercicio = ejercicios[seleccion].split(" - ")[0];
// 		}
// 		if (ejercicios.length == 1) {
// 			ejercicio = ejercicios[0];
// 		}
	}
debug("ejercicio = " + ejercicio);
debug("curDotacion = " + curDotacion.valueBuffer("fecha"));
	valoresDefecto["codejercicio"] = ejercicio;
	valoresDefecto["coddivisa"] = flfactppal.iface.pub_valorDefectoEmpresa("coddivisa");

	datosAsiento = flfacturac.iface.pub_regenerarAsiento(curDotacion, valoresDefecto);
	if (datosAsiento.error == true)
		return false;

	if (!this.iface.generarPartidasDotacion(curDotacion, datosAsiento.idasiento, valoresDefecto))
		return false;

	curDotacion.setValueBuffer("idasiento", datosAsiento.idasiento);

	if (!flcontppal.iface.pub_comprobarAsiento(datosAsiento.idasiento))
		return false;

	return true;
}

function oficial_generarPartidasDotacion(curDotacion:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean
{
	var util:FLUtil = new FLUtil();

	var fecha:Date = curDotacion.valueBuffer("fecha");
	var codEjercicio:String = valoresDefecto["codejercicio"];
	var codDivisa:String = valoresDefecto["coddivisa"];
	var tasaConv:Number = parseFloat(util.sqlSelect("divisas","tasaconv","coddivisa = '" + codDivisa + "'"));

	var importe:Number = curDotacion.valueBuffer("importe");
	var importeME:Number = importe * tasaConv;		
	importe = util.roundFieldValue(importe, "co_partidas", "haber");
	importeME = util.roundFieldValue(importeME, "co_partidas", "haberme");

	var codSubcuentaElem:String = util.sqlSelect("co_amortizaciones","codsubcuentaelem","codamortizacion = '" + curDotacion.valueBuffer("codamortizacion") + "'");
	var idSubcuentaElem:Number = util.sqlSelect("co_subcuentas","idsubcuenta","codsubcuenta = '" + codSubcuentaElem + "' AND codejercicio = '" + codEjercicio + "'");
	if(!idSubcuentaElem) {
		MessageBox.warning(util.translate("scripts", "No existe la subcuenta %1 para el ejercicio %2.\nAntes de crear la dotación para esta fecha debe crear la subcuenta").arg(codSubcuentaElem).arg(codEjercicio), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
	with (curPartida) {
		setModeAccess(curPartida.Insert);
		refreshBuffer();
		setValueBuffer("idsubcuenta", idSubcuentaElem);
		setValueBuffer("codsubcuenta", codSubcuentaElem);
		setValueBuffer("idasiento", idAsiento);
		setValueBuffer("debe", 0);
		setValueBuffer("haber", importe);
		setValueBuffer("coddivisa", codDivisa);
		setValueBuffer("tasaconv", tasaConv);
		setValueBuffer("debeME", 0);
		setValueBuffer("haberME", importeME);
		setValueBuffer("concepto", util.translate("scripts", "Dotación de ") + util.sqlSelect("co_amortizaciones","elemento","codamortizacion = '" + curDotacion.valueBuffer("codamortizacion") + "'") + " - " + util.dateAMDtoDMA(fecha));
	}
	
	if (!curPartida.commitBuffer())
			return false;


	var codSubcuentaAmor:String = util.sqlSelect("co_amortizaciones","codsubcuentaamor","codamortizacion = '" + curDotacion.valueBuffer("codamortizacion") + "'")
	var idSubcuentaAmor:Number = util.sqlSelect("co_subcuentas","idsubcuenta","codsubcuenta = '" + codSubcuentaAmor + "' AND codejercicio = '" + codEjercicio + "'")
	if(!idSubcuentaAmor) {
		MessageBox.warning(util.translate("scripts", "No existe la subcuenta %1 para el ejercicio %2.\nAntes de crear la dotación para esta fecha debe crear la subcuenta").arg(codSubcuentaAmor).arg(codEjercicio), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
	with (curPartida) {
		setModeAccess(curPartida.Insert);
		refreshBuffer();
		setValueBuffer("idsubcuenta", idSubcuentaAmor);
		setValueBuffer("codsubcuenta",codSubcuentaAmor);
		setValueBuffer("idasiento", idAsiento);
		setValueBuffer("debe", importe);
		setValueBuffer("haber", 0);
		setValueBuffer("coddivisa", codDivisa);
		setValueBuffer("tasaconv", tasaConv);
		setValueBuffer("debeME", importeME);
		setValueBuffer("haberME", 0);
		setValueBuffer("concepto", util.translate("scripts", "Dotación de ") + util.sqlSelect("co_amortizaciones","elemento","codamortizacion = '" + curDotacion.valueBuffer("codamortizacion") + "'") + " - " + util.dateAMDtoDMA(fecha));
	}
	
	if (!curPartida.commitBuffer())
		return false;

	return true;
}

function oficial_rellenarCuentaEsp()
{
	var util:FLUtil = new FLUtil;
	if (util.sqlSelect("co_subcuentas", "idsubcuenta", "idcuentaesp IS NOT NULL AND idsubcuenta <> 0")) {
		return;
	}
	var qryCuentas:FLSqlQuery = new FLSqlQuery;
	with (qryCuentas) {
		setTablesList("co_cuentas");
		setSelect("idcuenta, idcuentaesp, codcuenta");
		setFrom("co_cuentas");
		setWhere("idcuentaesp IS NOT NULL AND idcuentaesp <> ''");
		setForwardOnly(true);
	}
	if (!qryCuentas.exec()) {
		return;
	}
	var total:Number = qryCuentas.size();
	var paso:Number = 0;
	util.createProgressDialog(util.translate("scripts", "Actualizando cuentas especiales (1/2)..."), total);
	var idCuentaEsp:String;
	while (qryCuentas.next()) {
		util.setProgress(++paso);
debug("codcuenta " + qryCuentas.value("codcuenta"))
		idCuentaEsp = qryCuentas.value("idcuentaesp");
		if (!util.sqlUpdate("co_subcuentas", "idcuentaesp", idCuentaEsp, "idcuenta = " + qryCuentas.value("idcuenta"))) {
			util.destroyProgressDialog();
			return false;
		}
	}
	util.destroyProgressDialog();

	var qryCuentasEsp:FLSqlQuery = new FLSqlQuery;
	with (qryCuentasEsp) {
		setTablesList("co_cuentasesp");
		setSelect("idcuentaesp, codsubcuenta");
		setFrom("co_cuentasesp");
		setWhere("1 = 1");
		setForwardOnly(true);
	}
	if (!qryCuentasEsp.exec()) {
		return;
	}
	total = qryCuentasEsp.size();
	paso = 0;
	util.createProgressDialog(util.translate("scripts", "Actualizando cuentas especiales (2/2)..."), total);
	var idCuentaEsp:String;
	var codSubcuenta:String;
	while (qryCuentasEsp.next()) {
		util.setProgress(++paso);
		codSubcuenta = qryCuentasEsp.value("codsubcuenta");
		idCuentaEsp = qryCuentasEsp.value("idcuentaesp");
		if (!util.sqlUpdate("co_subcuentas", "idcuentaesp", idCuentaEsp, "codsubcuenta = '" + codSubcuenta + "'")) {
			util.destroyProgressDialog();
			return false;
		}
	}
	util.destroyProgressDialog();
}

function oficial_copiarCuenta(codCuenta:String, codEjercicioAnt:String, codEjercicio:String):String
{
	var util:FLUtil = new FLUtil();
	var curCuentaOrigen:FLSqlCursor = new FLSqlCursor("co_cuentas");
	curCuentaOrigen.select("codcuenta = '" + codCuenta + "' AND codejercicio = '" + codEjercicioAnt + "'");
	if (!curCuentaOrigen.first()) {
		return false;
	}
	curCuentaOrigen.setModeAccess(curCuentaOrigen.Browse);
	curCuentaOrigen.refreshBuffer();
	

	var codEpigrafe:String = curCuentaOrigen.valueBuffer("codepigrafe");
	var idEpigrafe:String = util.sqlSelect("co_epigrafes", "idepigrafe", "codepigrafe = '" + codEpigrafe + "' AND codejercicio = '" + codEjercicio + "'");
	if (!idEpigrafe) {
		MessageBox.warning(util.translate("scripts", "El epígrafe %1 no existe en el ejercicio %2.").arg(codEpigrafe).arg(codEjercicio), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	
	var curCuenta:FLSqlCursor = new FLSqlCursor("co_cuentas");
	curCuenta.setModeAccess(curCuenta.Insert);
	curCuenta.refreshBuffer();
	curCuenta.setValueBuffer("codcuenta", codCuenta);
	curCuenta.setValueBuffer("descripcion", curCuentaOrigen.valueBuffer("descripcion"));
	curCuenta.setValueBuffer("codejercicio", codEjercicio);
	curCuenta.setValueBuffer("idepigrafe", idEpigrafe);
	curCuenta.setValueBuffer("codepigrafe", codEpigrafe);
	curCuenta.setValueBuffer("codbalance", curCuentaOrigen.valueBuffer("codbalance"));
	curCuenta.setValueBuffer("idcuentaesp", curCuentaOrigen.valueBuffer("idcuentaesp"));
	if (!curCuenta.commitBuffer()) {
		return false;
	}
	var idCuenta:String = curCuenta.valueBuffer("idcuenta");
	return idCuenta;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pgc2008 */
/////////////////////////////////////////////////////////////////
//// PGC 2008 //////////////////////////////////////////////////////

function pgc2008_init()
{
	this.iface.__init();

	var util:FLUtil = new FLUtil();
	if (util.sqlSelect("ejercicios", "codejercicio", "plancontable = '08'") && !util.sqlSelect("co_cuentascbba", "codcuenta", "1=1"))
		MessageBox.information(util.translate("scripts", "ATENCIÓN. Es necesario que regenere su plan contable para todos los ejercicios del nuevo PGC 2008.\nPara ello, abra el menú Ejercicio -> Ver todos, seleccione el(los) ejercicio(s) y pulse \"Regenerar\" "), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
}

function pgc2008_generarPGC(codEjercicio:String)
{
	var util:FLUtil = new FLUtil();
	
	if (util.sqlSelect("ejercicios", "plancontable", "codejercicio = '" + codEjercicio + "'") != "08")
		return this.iface.__generarPGC(codEjercicio);
	
	var longSubcuenta:Number = util.sqlSelect("ejercicios", "longsubcuenta", "codejercicio = '" + codEjercicio + "'");
	
	var numCuentasEsp:Number = this.iface.valorPorClave("co_cuentasesp", "count(idcuentaesp)", "1 = 1");
	if (!numCuentasEsp)
		this.iface.valoresIniciales();
	
	this.iface.generarCuadroCuentas(codEjercicio)
	this.iface.generarCodigosBalance2008();
	this.iface.actualizarCuentas2008(codEjercicio);
	this.iface.actualizarCuentas2008ba(codEjercicio);
	this.iface.generarCorrespondenciasCC(codEjercicio);
	this.iface.actualizarCuentasEspeciales(codEjercicio);	
	this.iface.generarSubcuentas(codEjercicio, longSubcuenta);
	
	MessageBox.information(util.translate("scripts", "Se generó el cuadro de cuentas"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
}


/** \D Se introducen los códigos de balance, independientes del ejercicio
\end */
function pgc2008_generarCodigosBalance2008()
{
	var util:FLUtil = new FLUtil;
	if (util.sqlSelect("co_codbalances08", "codbalance", "1=1"))
		return;	
	
	var curCbl:FLSqlCursor = new FLSqlCursor("co_codbalances08");
	curCbl.setActivatedCheckIntegrity(false);
	
	var datos = [
		["A-A--I-1", "A", "A", "A) ACTIVO NO CORRIENTE", "", "", "I", "I. Inmovilizado intangible.", "1", "1. Desarrollo."],
		["A-A--I-2", "A", "A", "A) ACTIVO NO CORRIENTE", "", "", "I", "I. Inmovilizado intangible.", "2", "2. Concesiones."],
		["A-A--I-3", "A", "A", "A) ACTIVO NO CORRIENTE", "", "", "I", "I. Inmovilizado intangible.", "3", "3. Patentes, licencias, marcas y similares."],
		["A-A--I-4", "A", "A", "A) ACTIVO NO CORRIENTE", "", "", "I", "I. Inmovilizado intangible.", "4", "4. Fondo de comercio."],
		["A-A--I-5", "A", "A", "A) ACTIVO NO CORRIENTE", "", "", "I", "I. Inmovilizado intangible.", "5", "5. Aplicaciones informáticas."],
		["A-A--I-6", "A", "A", "A) ACTIVO NO CORRIENTE", "", "", "I", "I. Inmovilizado intangible.", "6", "6. Otro inmovilizado intangible."],
		["A-A--II-1", "A", "A", "A) ACTIVO NO CORRIENTE", "", "", "II", "II. Inmovilizado material.", "1", "1. Terrenos y construcciones."],
		["A-A--II-2", "A", "A", "A) ACTIVO NO CORRIENTE", "", "", "II", "II. Inmovilizado material.", "2", "2. Instalaciones técnicas, y otro inmovilizado material."],
		["A-A--II-3", "A", "A", "A) ACTIVO NO CORRIENTE", "", "", "II", "II. Inmovilizado material.", "3", "3. Inmovilizado en curso y anticipos."],
		["A-A--III-1", "A", "A", "A) ACTIVO NO CORRIENTE", "", "", "III", "III. Inversiones inmobiliarias.", "1", "1. Terrenos."],
		["A-A--III-2", "A", "A", "A) ACTIVO NO CORRIENTE", "", "", "III", "III. Inversiones inmobiliarias.", "2", "2. Construcciones."],
		["A-A--IV-1", "A", "A", "A) ACTIVO NO CORRIENTE", "", "", "IV", "IV. Inversiones en empresas del grupo y asociadas a largo plazo", "1", "1. Instrumentos de patrimonio."],
		["A-A--IV-2", "A", "A", "A) ACTIVO NO CORRIENTE", "", "", "IV", "IV. Inversiones en empresas del grupo y asociadas a largo plazo", "2", "2. Créditos a empresas."],
		["A-A--IV-3", "A", "A", "A) ACTIVO NO CORRIENTE", "", "", "IV", "IV. Inversiones en empresas del grupo y asociadas a largo plazo", "3", "3. Valores representativos de deuda."],
		["A-A--IV-4", "A", "A", "A) ACTIVO NO CORRIENTE", "", "", "IV", "IV. Inversiones en empresas del grupo y asociadas a largo plazo", "4", "4. Derivados."],
		["A-A--IV-5", "A", "A", "A) ACTIVO NO CORRIENTE", "", "", "IV", "IV. Inversiones en empresas del grupo y asociadas a largo plazo", "5", "5. Otros activos financieros."],
		["A-A--V-1", "A", "A", "A) ACTIVO NO CORRIENTE", "", "", "V", "V. Inversiones financieras a largo plazo.", "1", "1. Instrumentos de patrimonio."],
		["A-A--V-2", "A", "A", "A) ACTIVO NO CORRIENTE", "", "", "V", "V. Inversiones financieras a largo plazo.", "2", "2. Créditos a terceros"],
		["A-A--V-3", "A", "A", "A) ACTIVO NO CORRIENTE", "", "", "V", "V. Inversiones financieras a largo plazo.", "3", "3. Valores representativos de deuda"],
		["A-A--V-4", "A", "A", "A) ACTIVO NO CORRIENTE", "", "", "V", "V. Inversiones financieras a largo plazo.", "4", "4. Derivados."],
		["A-A--V-5", "A", "A", "A) ACTIVO NO CORRIENTE", "", "", "V", "V. Inversiones financieras a largo plazo.", "5", "5. Otros activos financieros."],
		["A-A--VI-", "A", "A", "A) ACTIVO NO CORRIENTE", "", "", "VI", "VI. Activos por impuesto diferido.", "", ""],
		["A-B--I-", "A", "B", "B) ACTIVO CORRIENTE", "", "", "I", "I. Activos no corrientes mantenidos para la venta.", "", ""],
		["A-B--II-1", "A", "B", "B) ACTIVO CORRIENTE", "", "", "II", "II. Existencias.", "1", "1. Comerciales."],
		["A-B--II-2", "A", "B", "B) ACTIVO CORRIENTE", "", "", "II", "II. Existencias.", "2", "2. Materias primas y otros aprovisionamientos."],
		["A-B--II-3", "A", "B", "B) ACTIVO CORRIENTE", "", "", "II", "II. Existencias.", "3", "3. Productos en curso."],
		["A-B--II-4", "A", "B", "B) ACTIVO CORRIENTE", "", "", "II", "II. Existencias.", "4", "4. Productos terminados."],
		["A-B--II-5", "A", "B", "B) ACTIVO CORRIENTE", "", "", "II", "II. Existencias.", "5", "5. Subproductos, residuos y materiales recuperados."],
		["A-B--II-6", "A", "B", "B) ACTIVO CORRIENTE", "", "", "II", "II. Existencias.", "6", "6. Anticipos a proveedores"],
		["A-B--III-1", "A", "B", "B) ACTIVO CORRIENTE", "", "", "III", "III. Deudores comerciales y otras cuentas a cobrar.", "1", "1. Clientes por ventas y prestaciones de servicios."],
		["A-B--III-2", "A", "B", "B) ACTIVO CORRIENTE", "", "", "III", "III. Deudores comerciales y otras cuentas a cobrar.", "2", "2. Clientes, empresas del grupo y asociadas."],
		["A-B--III-3", "A", "B", "B) ACTIVO CORRIENTE", "", "", "III", "III. Deudores comerciales y otras cuentas a cobrar.", "3", "3. Deudores varios."],
		["A-B--III-4", "A", "B", "B) ACTIVO CORRIENTE", "", "", "III", "III. Deudores comerciales y otras cuentas a cobrar.", "4", "4. Personal."],
		["A-B--III-5", "A", "B", "B) ACTIVO CORRIENTE", "", "", "III", "III. Deudores comerciales y otras cuentas a cobrar.", "5", "5. Activos por impuesto corriente."],
		["A-B--III-6", "A", "B", "B) ACTIVO CORRIENTE", "", "", "III", "III. Deudores comerciales y otras cuentas a cobrar.", "6", "6. Otros créditos con las Administraciones Públicas."],
		["A-B--III-7", "A", "B", "B) ACTIVO CORRIENTE", "", "", "III", "III. Deudores comerciales y otras cuentas a cobrar.", "7", "7. Accionistas (socios) por desembolsos exigidos"],
		["A-B--IV-1", "A", "B", "B) ACTIVO CORRIENTE", "", "", "IV", "IV. Inversiones en empresas del grupo y asociadas a corto plazo", "1", "1. Instrumentos de patrimonio."],
		["A-B--IV-2", "A", "B", "B) ACTIVO CORRIENTE", "", "", "IV", "IV. Inversiones en empresas del grupo y asociadas a corto plazo", "2", "2. Créditos a empresas."],
		["A-B--IV-3", "A", "B", "B) ACTIVO CORRIENTE", "", "", "IV", "IV. Inversiones en empresas del grupo y asociadas a corto plazo", "3", "3. Valores representativos de deuda."],
		["A-B--IV-4", "A", "B", "B) ACTIVO CORRIENTE", "", "", "IV", "IV. Inversiones en empresas del grupo y asociadas a corto plazo", "4", "4. Derivados."],
		["A-B--IV-5", "A", "B", "B) ACTIVO CORRIENTE", "", "", "IV", "IV. Inversiones en empresas del grupo y asociadas a corto plazo", "5", "5. Otros activos financieros."],
		["A-B--V-1", "A", "B", "B) ACTIVO CORRIENTE", "", "", "V", "V. Inversiones financieras a corto plazo.", "1", "1. Instrumentos de patrimonio."],
		["A-B--V-2", "A", "B", "B) ACTIVO CORRIENTE", "", "", "V", "V. Inversiones financieras a corto plazo.", "2", "2. Créditos a empresas"],
		["A-B--V-3", "A", "B", "B) ACTIVO CORRIENTE", "", "", "V", "V. Inversiones financieras a corto plazo.", "3", "3. Valores representativos de deuda."],
		["A-B--V-4", "A", "B", "B) ACTIVO CORRIENTE", "", "", "V", "V. Inversiones financieras a corto plazo.", "4", "4. Derivados."],
		["A-B--V-5", "A", "B", "B) ACTIVO CORRIENTE", "", "", "V", "V. Inversiones financieras a corto plazo.", "5", "5. Otros activos financieros."],
		["A-B--VI-", "A", "B", "B) ACTIVO CORRIENTE", "", "", "VI", "VI. Periodificaciones a corto plazo.", "", ""],
		["A-B--VII-1", "A", "B", "B) ACTIVO CORRIENTE", "", "", "VII", "VII. Efectivo y otros activos líquidos equivalentes.", "1", "1. Tesorería."],
		["A-B--VII-2", "A", "B", "B) ACTIVO CORRIENTE", "", "", "VII", "VII. Efectivo y otros activos líquidos equivalentes.", "2", "2. Otros activos líquidos equivalentes."],
		["P---VII-2", "P", "", "", "", "", "VII", "VII. Efectivo y otros activos líquidos equivalentes.", "2", "2. Otros activos líquidos equivalentes."],
		["P-A-1-I-1", "P", "A", "A) PATRIMONIO NETO", "1", "A-1) Fondos propios.", "I", "I. Capital.", "1", "1. Capital escriturado."],
		["P-A-1-I-2", "P", "A", "A) PATRIMONIO NETO", "1", "A-1) Fondos propios.", "I", "I. Capital.", "2", "2. (Capital no exigido)."],
		["P-A-1-II-", "P", "A", "A) PATRIMONIO NETO", "1", "A-1) Fondos propios.", "II", "II. Prima de emisión.", "", ""],
		["P-A-1-III-1", "P", "A", "A) PATRIMONIO NETO", "1", "A-1) Fondos propios.", "III", "III. Reservas.", "1", "1. Legal y estatutarias."],
		["P-A-1-III-2", "P", "A", "A) PATRIMONIO NETO", "1", "A-1) Fondos propios.", "III", "III. Reservas.", "2", "2. Otras reservas."],
		["P-A-1-IV-", "P", "A", "A) PATRIMONIO NETO", "1", "A-1) Fondos propios.", "IV", "IV. (Acciones y participaciones en patrimonio propias).", "", ""],
		["P-A-1-V-1", "P", "A", "A) PATRIMONIO NETO", "1", "A-1) Fondos propios.", "V", "V. Resultados de ejercicios anteriores.", "1", "1. Remanente."],
		["P-A-1-V-2", "P", "A", "A) PATRIMONIO NETO", "1", "A-1) Fondos propios.", "V", "V. Resultados de ejercicios anteriores.", "2", "2. (Resultados negativos de ejercicios anteriores)."],
		["P-A-1-VI-", "P", "A", "A) PATRIMONIO NETO", "1", "A-1) Fondos propios.", "VI", "VI. Otras aportaciones de socios.", "", ""],
		["P-A-1-VII-", "P", "A", "A) PATRIMONIO NETO", "1", "A-1) Fondos propios.", "VII", "VII. Resultado del ejercicio.", "", ""],
		["P-A-1-VIII-", "P", "A", "A) PATRIMONIO NETO", "1", "A-1) Fondos propios.", "VIII", "VIII. (Dividendo a cuenta).", "", ""],
		["P-A-1-IX-", "P", "A", "A) PATRIMONIO NETO", "1", "A-1) Fondos propios.", "IX", "IX. Otros instrumentos de patrimonio neto.", "", ""],
		["P-A-2-I-", "P", "A", "A) PATRIMONIO NETO", "2", "A-2) Ajustes por cambios de valor.", "I", "I. Activos financieros disponibles para la venta", "", ""],
		["P-A-2-II-", "P", "A", "A) PATRIMONIO NETO", "2", "A-2) Ajustes por cambios de valor.", "II", "II. Operaciones de cobertura.", "", ""],
		["P-A-2-III-", "P", "A", "A) PATRIMONIO NETO", "2", "A-2) Ajustes por cambios de valor.", "III", "III. Otros.", "", ""],
		["P-A-3--", "P", "A", "A) PATRIMONIO NETO", "3", "A-3) Subvenciones, donaciones y legados recibidos.", "", "", "", ""],
		["P-B--I-1", "P", "B", "B) PASIVO NO CORRIENTE", "", "", "I", "I. Provisiones a largo plazo.", "1", "1. Obligaciones por prestaciones a largo plazo al personal."],
		["P-B--I-2", "P", "B", "B) PASIVO NO CORRIENTE", "", "", "I", "I. Provisiones a largo plazo.", "2", "2. Actuaciones medioambientales."],
		["P-B--I-3", "P", "B", "B) PASIVO NO CORRIENTE", "", "", "I", "I. Provisiones a largo plazo.", "3", "3. Provisiones por reestructuración."],
		["P-B--I-4", "P", "B", "B) PASIVO NO CORRIENTE", "", "", "I", "I. Provisiones a largo plazo.", "4", "4. Otras provisiones."],
		["P-B--II-1", "P", "B", "B) PASIVO NO CORRIENTE", "", "", "II", "II. Deudas a largo plazo.", "1", "1. Obligaciones y otros valores negociables."],
		["P-B--II-2", "P", "B", "B) PASIVO NO CORRIENTE", "", "", "II", "II. Deudas a largo plazo.", "2", "2. Deudas con entidades de crédito."],
		["P-B--II-3", "P", "B", "B) PASIVO NO CORRIENTE", "", "", "II", "II. Deudas a largo plazo.", "3", "3. Acreedores por arrendamiento financiero."],
		["P-B--II-4", "P", "B", "B) PASIVO NO CORRIENTE", "", "", "II", "II. Deudas a largo plazo.", "4", "4. Derivados."],
		["P-B--II-5", "P", "B", "B) PASIVO NO CORRIENTE", "", "", "II", "II. Deudas a largo plazo.", "5", "5. Otros pasivos financieros."],
		["P-B--III-", "P", "B", "B) PASIVO NO CORRIENTE", "", "", "III", "III. Deudas con empresas del grupo y asociadas a largo plazo.", "", ""],
		["P-B--IV-", "P", "B", "B) PASIVO NO CORRIENTE", "", "", "IV", "IV. Pasivos por impuesto diferido.", "", ""],
		["P-B--V-", "P", "B", "B) PASIVO NO CORRIENTE", "", "", "V", "V. Periodificaciones a largo plazo.", "", ""],
		["P-C--I-", "P", "C", "C) PASIVO CORRIENTE", "", "", "I", "I. Pasivos vinculados con activos no corrientes mantenidos para la venta", "", ""],
		["P-C--II-", "P", "C", "C) PASIVO CORRIENTE", "", "", "II", "II. Provisiones a corto plazo.", "", ""],
		["P-C--III-1", "P", "C", "C) PASIVO CORRIENTE", "", "", "III", "III. Deudas a corto plazo.", "1", "1. Obligaciones y otros valores negociables."],
		["P-C--III-2", "P", "C", "C) PASIVO CORRIENTE", "", "", "III", "III. Deudas a corto plazo.", "2", "2. Deudas con entidades de crédito."],
		["P-C--III-3", "P", "C", "C) PASIVO CORRIENTE", "", "", "III", "III. Deudas a corto plazo.", "3", "3. Acreedores por arrendamiento financiero."],
		["P-C--III-4", "P", "C", "C) PASIVO CORRIENTE", "", "", "III", "III. Deudas a corto plazo.", "4", "4. Derivados."],
		["P-C--III-5", "P", "C", "C) PASIVO CORRIENTE", "", "", "III", "III. Deudas a corto plazo.", "5", "5. Otros pasivos financieros."],
		["P-C--IV-", "P", "C", "C) PASIVO CORRIENTE", "", "", "IV", "IV. Deudas con empresas del grupo y asociadas a corto plazo.", "", ""],
		["P-C--V-1", "P", "C", "C) PASIVO CORRIENTE", "", "", "V", "V. Acreedores comerciales y otras cuentas a pagar.", "1", "1. Proveedores"],
		["P-C--V-2", "P", "C", "C) PASIVO CORRIENTE", "", "", "V", "V. Acreedores comerciales y otras cuentas a pagar.", "2", "2. Proveedores, empresas del grupo y asociadas."],
		["P-C--V-3", "P", "C", "C) PASIVO CORRIENTE", "", "", "V", "V. Acreedores comerciales y otras cuentas a pagar.", "3", "3. Acreedores varios."],
		["P-C--V-4", "P", "C", "C) PASIVO CORRIENTE", "", "", "V", "V. Acreedores comerciales y otras cuentas a pagar.", "4", "4. Personal (remuneraciones pendientes de pago)."],
		["P-C--V-5", "P", "C", "C) PASIVO CORRIENTE", "", "", "V", "V. Acreedores comerciales y otras cuentas a pagar.", "5", "5. Pasivos por impuesto corriente."],
		["P-C--V-6", "P", "C", "C) PASIVO CORRIENTE", "", "", "V", "V. Acreedores comerciales y otras cuentas a pagar.", "6", "6. Otras deudas con las Administraciones Públicas."],
		["P-C--V-7", "P", "C", "C) PASIVO CORRIENTE", "", "", "V", "V. Acreedores comerciales y otras cuentas a pagar.", "7", "7. Anticipos de clientes."],
		["P-C--VI-", "P", "C", "C) PASIVO CORRIENTE", "", "", "VI", "VI. Periodificaciones a corto plazo.", "", ""],
		
		["PG-A-1-a-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "1", "1. Importe neto de la cifra de negocios. ", "a", " a) Ventas ", "", ""],
		["PG-A-1-b-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "1", "1. Importe neto de la cifra de negocios. ", "b", " b) Prestaciones de servicios ", "", ""],
		["PG-A-2--", "PG", "A", "A) OPERACIONES CONTINUADAS ", "2", "2. Variación de existencias de productos terminados y en curso de fabricación ", "", "", "", ""],
		["PG-A-3--", "PG", "A", "A) OPERACIONES CONTINUADAS ", "3", "3. Trabajos realizados por la empresa para su activo ", "", "", "", ""],
		["PG-A-4-a-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "4", "4. Aprovisionamientos ", "a", " a) Consumo de mercaderías ", "", ""],
		["PG-A-4-b-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "4", "4. Aprovisionamientos ", "b", " b) Consumo de materias primas y otras materias consumibles ", "", ""],
		["PG-A-4-c-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "4", "4. Aprovisionamientos ", "c", " c) Trabajos realizados por otras empresas ", "", ""],
		["PG-A-4-d-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "4", "4. Aprovisionamientos ", "d", " d) Deterioro de mercaderias , materias primas y otros aprovisioamientos ", "", ""],
		["PG-A-5-a-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "5", "5. Otros ingresos de explotación ", "a", " a) Ingresos accesorios y otros de gestión corriente ", "", ""],
		["PG-A-5-b-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "5", "5. Otros ingresos de explotación ", "b", " b) Subvenciones de explotación incorporadas al resultado del ejercicio ", "", ""],
		["PG-A-6-a-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "6", "6. Gastos de personal ", "a", " a) Sueldos , salarios y asimilados ", "", ""],
		["PG-A-6-b-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "6", "6. Gastos de personal ", "b", " b) Cargas sociales ", "", ""],
		["PG-A-6-c-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "6", "6. Gastos de personal ", "c", " c) Provisiones ", "", ""],
		["PG-A-7-a-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "7", "7. Otros gastos de explotación ", "a", " a) Servicios exteriores ", "", ""],
		["PG-A-7-b-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "7", "7. Otros gastos de explotación ", "b", " b) Tributos ", "", ""],
		["PG-A-7-c-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "7", "7. Otros gastos de explotación ", "c", " c) Pérdidas , deterioro y variación de provisiones por operaciones comerciales ", "", ""],
		["PG-A-7-d-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "7", "7. Otros gastos de explotación ", "d", " d) Otros gastos de gestión corriente ", "", ""],
		["PG-A-8--", "PG", "A", "A) OPERACIONES CONTINUADAS ", "8", "8. Amortización del inmovilizado ", "", "", "", ""],
		["PG-A-9--", "PG", "A", "A) OPERACIONES CONTINUADAS ", "9", "9. Imputación de subvenciones de inmovilizado no financiero y otras ", "", "", "", ""],
		["PG-A-10--", "PG", "A", "A) OPERACIONES CONTINUADAS ", "10", "10. Excesos de provisiones ", "", "", "", ""],
		["PG-A-11-a-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "11", "11. Deterioro y resultado por enajenaciones del inmovilizado ", "a", " a) Deterioros y pérdidas ", "", ""],
		["PG-A-11-b-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "11", "11. Deterioro y resultado por enajenaciones del inmovilizado ", "b", " b) Resultados por enajenaciones y otras ", "", ""],
		["PG-A-12-a-1", "PG", "A", "A) OPERACIONES CONTINUADAS ", "12", "12. Ingresos financieros ", "a", " a) De participaciones en instrumentos de patrimonio ", "1", " a1) En empresas del grupo y asociadas "],
		["PG-A-12-a-2", "PG", "A", "A) OPERACIONES CONTINUADAS ", "12", "12. Ingresos financieros ", "a", " a) De participaciones en instrumentos de patrimonio ", "2", " a2) En empresas terceros "],
		["PG-A-12-b-1", "PG", "A", "A) OPERACIONES CONTINUADAS ", "12", "12. Ingresos financieros ", "b", " b) De valores negociables y otros instrumentos financieros ", "1", " b1) De empresas del grupo y asociadas "],
		["PG-A-12-b-2", "PG", "A", "A) OPERACIONES CONTINUADAS ", "12", "12. Ingresos financieros ", "b", " b) De valores negociables y otros instrumentos financieros ", "2", " b2) De terceros "],
		["PG-A-13-a-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "13", "13. Gastos financieros ", "a", " a) Por deudas con empresas del grupo y asociadas ", "", ""],
		["PG-A-13-b-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "13", "13. Gastos financieros ", "b", " b) Por deudas con terceros ", "", ""],
		["PG-A-13-c-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "13", "13. Gastos financieros ", "c", " c) Por actualización de provisiones ", "", ""],
		["PG-A-14-a-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "14", "14. Variación de valor razonable en instrumentos financieros ", "a", " a) Cartera de negociación y otros ", "", ""],
		["PG-A-14-b-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "14", "14. Variación de valor razonable en instrumentos financieros ", "b", " b) Imputación al resultado del ejercicio por activos fros. disponibles para la venta ", "", ""],
		["PG-A-15--", "PG", "A", "A) OPERACIONES CONTINUADAS ", "15", "15. Diferencias de cambio ", "", "", "", ""],
		["PG-A-16-a-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "16", "16. Deterioro y resultado por enajenaciones de instrumentos financieros ", "a", " a) Deterioros y pérdidas ", "", ""],
		["PG-A-16-b-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "16", "16. Deterioro y resultado por enajenaciones de instrumentos financieros ", "b", " b) Resultados por enajenaciones y otras ", "", ""],
		["PG-A-17--", "PG", "A", "A) OPERACIONES CONTINUADAS ", "17", "17. Impuesto sobre beneficios ", "", "  ", "", ""],
		["PG-B-18--", "PG", "B", "B) OPERACIONES INTERRUMPIDAS ", "18", "18. Resultado del ejercicio procedente de operaciones interrumpidas neto de impuestos ", "", "  ", "", ""],
			
		["IG-A--I-1", "IG", "A", "Ingresos y gastos imputados directamente al patrimonio neto ", "", "", "I", "I. Por valoración instrumentos financieros. ", "1", "1. Activos financieros disponibles para la venta. "],
		["IG-A--I-2", "IG", "A", "Ingresos y gastos imputados directamente al patrimonio neto ", "", "", "I", "I. Por valoración instrumentos financieros. ", "2", "2. Otros ingresos/gastos. "],
		["IG-A--II-", "IG", "A", "Ingresos y gastos imputados directamente al patrimonio neto ", "", "", "II", "II. Por coberturas de flujos de efectivo. ", "", ""],
		["IG-A--III-", "IG", "A", "Ingresos y gastos imputados directamente al patrimonio neto ", "", "", "III", "III. Subvenciones, donaciones y legados recibidos. ", "", ""],
		["IG-A--IV-", "IG", "A", "Ingresos y gastos imputados directamente al patrimonio neto ", "", "", "IV", "IV. Por ganancias y pérdidas actuariales y otros ajustes. ", "", ""],
		["IG-A--V-", "IG", "A", "Ingresos y gastos imputados directamente al patrimonio neto ", "", "", "V", "V. Efecto impositivo. ", "", ""],
		["IG-B--VI-1", "IG", "B", "Transferencias a la cuenta de pérdidas y ganancias ", "", "", "VI", "VI. Por valoración de instrumentos financieros. ", "1", "1.Activos financieros disponibles para la venta. "],
		["IG-B--VI-2", "IG", "B", "Transferencias a la cuenta de pérdidas y ganancias ", "", "", "VI", "VI. Por valoración de instrumentos financieros. ", "2", "2. Otros ingresos/gastos. "],
		["IG-B--VII-", "IG", "B", "Transferencias a la cuenta de pérdidas y ganancias ", "", "", "VII", "VII. Por coberturas de flujos de efectivo. ", "", ""],
		["IG-B--VIII-", "IG", "B", "Transferencias a la cuenta de pérdidas y ganancias ", "", "", "VIII", "VIII. Subvenciones, donaciones y legados recibidos. ", "", ""],
		["IG-B--IX-", "IG", "B", "Transferencias a la cuenta de pérdidas y ganancias ", "", "", "IX", "IX. Efecto impositivo. ", "", ""],
	];
		
	var orden:Number;
	util.createProgressDialog(util.translate("scripts", "Creando códigos de balance 2008"), datos.length);
			
	for (i = 0; i < datos.length; i++) {
		util.setProgress(i);
		
		curCbl.setModeAccess(curCbl.Insert);
		curCbl.refreshBuffer();
		curCbl.setValueBuffer("codbalance", datos[i][0]);
		curCbl.setValueBuffer("naturaleza", datos[i][1]);
		if (datos[i][2])
			curCbl.setValueBuffer("nivel1", datos[i][2]);
		if (datos[i][3])
			curCbl.setValueBuffer("descripcion1", datos[i][3]);
		if (datos[i][4])
			curCbl.setValueBuffer("nivel2", datos[i][4]);
		if (datos[i][5])
			curCbl.setValueBuffer("descripcion2", datos[i][5]);
		if (datos[i][6])
			curCbl.setValueBuffer("nivel3", datos[i][6]);
		if (datos[i][7])
			curCbl.setValueBuffer("descripcion3", datos[i][7]);
		if (datos[i][8])
			curCbl.setValueBuffer("nivel4", datos[i][8]);
		if (datos[i][9])
			curCbl.setValueBuffer("descripcion4", datos[i][9]);
		
		curCbl.commitBuffer();
	}
	
	this.iface.pgc2008_generarOrden3CB();
	
	util.destroyProgressDialog();
}


/** \D Es necesario actualizar el orden del nivel 3 en los códigos
para poder ordenar por números romanos
\end */
function pgc2008_generarOrden3CB()
{
	var romanos:String = "ðIðIIðIIIðIVðVðVIðVIIðVIIIðIXð";
	var nivel3:String;

	var roman2arab = [];
	roman2arab["I"] = 1;
	roman2arab["II"] = 2;
	roman2arab["III"] = 3;
	roman2arab["IV"] = 4;
	roman2arab["V"] = 5;
	roman2arab["VI"] = 6;
	roman2arab["VII"] = 7;
	roman2arab["VIII"] = 8;
	roman2arab["IX"] = 9;

	var curCbl:FLSqlCursor = new FLSqlCursor("co_codbalances08");
	curCbl.select();
	
	while (curCbl.next()) {
		
		curCbl.setModeAccess(curCbl.Edit);
		curCbl.refreshBuffer();
		
		nivel3 = curCbl.valueBuffer("nivel3");
		if (romanos.search("ð" + nivel3 + "ð") == -1)
			curCbl.setValueBuffer("orden3", nivel3.toString());
		else		
			curCbl.setValueBuffer("orden3", roman2arab[nivel3]);
			
		curCbl.commitBuffer();
	}
}

/** \D Se actualizan los códigos de balance en las cuentas
\end */
function pgc2008_actualizarCuentas2008(codEjercicio:String)
{
	var util:FLUtil = new FLUtil;
	var curCbl:FLSqlCursor = new FLSqlCursor("co_cuentascb");
	curCbl.setActivatedCheckIntegrity(false);
	
	var datos = [
		["201","A-A--I-1"],
		["2801","A-A--I-1"],
		["200","A-A--I-1"],
		["2901","A-A--I-1"],
		["2900","A-A--I-1"],
		["2802","A-A--I-2"],
		["2902","A-A--I-2"],
		["202","A-A--I-2"],
		["203","A-A--I-3"],
		["2803","A-A--I-3"],
		["2903","A-A--I-3"],
		["204","A-A--I-4"],
		["206","A-A--I-5"],
		["2806","A-A--I-5"],
		["2906","A-A--I-5"],
		["209","A-A--I-6"],
		["205","A-A--I-6"],
		["2905","A-A--I-6"],
		["2805","A-A--I-6"],
		["2910","A-A--II-1"],
		["2911","A-A--II-1"],
		["210","A-A--II-1"],
		["2811","A-A--II-1"],
		["211","A-A--II-1"],
		["216","A-A--II-2"],
		["2919","A-A--II-2"],
		["2918","A-A--II-2"],
		["2917","A-A--II-2"],
		["2916","A-A--II-2"],
		["2915","A-A--II-2"],
		["2914","A-A--II-2"],
		["2913","A-A--II-2"],
		["2912","A-A--II-2"],
		["2819","A-A--II-2"],
		["2818","A-A--II-2"],
		["2817","A-A--II-2"],
		["2816","A-A--II-2"],
		["2815","A-A--II-2"],
		["2814","A-A--II-2"],
		["2813","A-A--II-2"],
		["2812","A-A--II-2"],
		["212","A-A--II-2"],
		["213","A-A--II-2"],
		["214","A-A--II-2"],
		["215","A-A--II-2"],
		["217","A-A--II-2"],
		["218","A-A--II-2"],
		["219","A-A--II-2"],
		["23","A-A--II-3"],
		["220","A-A--III-1"],
		["2920","A-A--III-1"],
		["282","A-A--III-2"],
		["221","A-A--III-2"],
		["2921","A-A--III-2"],
		["2493","A-A--IV-1"],
		["2404","A-A--IV-1"],
		["2494","A-A--IV-1"],
		["2403","A-A--IV-1"],
		["293","A-A--IV-1"],
		["2953","A-A--IV-2"],
		["2424","A-A--IV-2"],
		["2423","A-A--IV-2"],
		["2954","A-A--IV-2"],
		["2414","A-A--IV-3"],
		["2943","A-A--IV-3"],
		["2944","A-A--IV-3"],
		["2413","A-A--IV-3"],
		["2405","A-A--V-1"],
		["2495","A-A--V-1"],
		["250","A-A--V-1"],
		["259","A-A--V-1"],
		["2955","A-A--V-2"],
		["298","A-A--V-2"],
		["252","A-A--V-2"],
		["253","A-A--V-2"],
		["254","A-A--V-2"],
		["2425","A-A--V-2"],
		["251","A-A--V-3"],
		["2415","A-A--V-3"],
		["2945","A-A--V-3"],
		["297","A-A--V-3"],
		["255","A-A--V-4"],
		["258","A-A--V-5"],
		["26","A-A--V-5"],
		["474","A-A--VI-"],
		["580","A-B--I-"],
		["582","A-B--I-"],
		["583","A-B--I-"],
		["584","A-B--I-"],
		["599","A-B--I-"],
		["581","A-B--I-"],
		["390","A-B--II-1"],
		["30","A-B--II-1"],
		["32","A-B--II-2"],
		["392","A-B--II-2"],
		["391","A-B--II-2"],
		["31","A-B--II-2"],
		["33","A-B--II-3"],
		["34","A-B--II-3"],
		["394","A-B--II-3"],
		["393","A-B--II-3"],
		["395","A-B--II-4"],
		["35","A-B--II-4"],
		["396","A-B--II-5"],
		["36","A-B--II-5"],
		["407","A-B--II-6"],
		["430","A-B--III-1"],
		["490","A-B--III-1"],
		["4935","A-B--III-1"],
		["437","A-B--III-1"],
		["436","A-B--III-1"],
		["435","A-B--III-1"],
		["432","A-B--III-1"],
		["431","A-B--III-1"],
		["4934","A-B--III-2"],
		["434","A-B--III-2"],
		["433","A-B--III-2"],
		["4933","A-B--III-2"],
		["5533","A-B--III-3"],
		["44","A-B--III-3"],
		["5531","A-B--III-3"],
		["460","A-B--III-4"],
		["544","A-B--III-4"],
		["4709","A-B--III-5"],
		["472","A-B--III-6"],
		["471","A-B--III-6"],
		["4708","A-B--III-6"],
		["4700","A-B--III-6"],
		["5585","A-B--III-7"],
		["5580","A-B--III-7"],
		["5393","A-B--IV-1"],
		["5303","A-B--IV-1"],
		["5304","A-B--IV-1"],
		["5394","A-B--IV-1"],
		["593","A-B--IV-1"],
		["5954","A-B--IV-2"],
		["5953","A-B--IV-2"],
		["5344","A-B--IV-2"],
		["5343","A-B--IV-2"],
		["5324","A-B--IV-2"],
		["5323","A-B--IV-2"],
		["5334","A-B--IV-3"],
		["5333","A-B--IV-3"],
		["5314","A-B--IV-3"],
		["5944","A-B--IV-3"],
		["5313","A-B--IV-3"],
		["5943","A-B--IV-3"],
		["5524","A-B--IV-5"],
		["5354","A-B--IV-5"],
		["5353","A-B--IV-5"],
		["5523","A-B--IV-5"],
		["540","A-B--V-1"],
		["5305","A-B--V-1"],
		["5395","A-B--V-1"],
		["549","A-B--V-1"],
		["598","A-B--V-2"],
		["5325","A-B--V-2"],
		["5345","A-B--V-2"],
		["542","A-B--V-2"],
		["543","A-B--V-2"],
		["547","A-B--V-2"],
		["5955","A-B--V-2"],
		["5335","A-B--V-3"],
		["5315","A-B--V-3"],
		["541","A-B--V-3"],
		["597","A-B--V-3"],
		["546","A-B--V-3"],
		["5945","A-B--V-3"],
		["5590","A-B--V-4"],
		["5593","A-B--V-4"],
		["565","A-B--V-5"],
		["566","A-B--V-5"],
		["5525","A-B--V-5"],
		["551","A-B--V-5"],
		["550","A-B--V-5"],
		["548","A-B--V-5"],
		["545","A-B--V-5"],
		["5355","A-B--V-5"],
		["480","A-B--VI-"],
		["567","A-B--VI-"],
		["573","A-B--VII-1"],
		["575","A-B--VII-1"],
		["574","A-B--VII-1"],
		["570","A-B--VII-1"],
		["571","A-B--VII-1"],
		["572","A-B--VII-1"],
		["576","A-B--VII-2"],
		["992","IG-A--I-1"],
		["89","IG-A--I-1"],
		["800","IG-A--I-1"],
		["900","IG-A--I-1"],
		["991","IG-A--I-1"],
		["811","IG-A--II-"],
		["810","IG-A--II-"],
		["910","IG-A--II-"],
		["94","IG-A--III-"],
		["85","IG-A--IV-"],
		["95","IG-A--IV-"],
		["834","IG-A--V-"],
		["835","IG-A--V-"],
		["838","IG-A--V-"],
		["8300","IG-A--V-"],
		["833","IG-A--V-"],
		["836","IG-B--IX-"],
		["8301","IG-B--IX-"],
		["837","IG-B--IX-"],
		["902","IG-B--VI-1"],
		["993","IG-B--VI-1"],
		["994","IG-B--VI-1"],
		["802","IG-B--VI-1"],
		["813","IG-B--VII-"],
		["912","IG-B--VII-"],
		["812","IG-B--VII-"],
		["84","IG-B--VIII-"],
		["101","P-A-1-I-1"],
		["102","P-A-1-I-1"],
		["100","P-A-1-I-1"],
		["1030","P-A-1-I-2"],
		["1040","P-A-1-I-2"],
		["110","P-A-1-II-"],
		["1141","P-A-1-III-1"],
		["112","P-A-1-III-1"],
		["119","P-A-1-III-2"],
		["1140","P-A-1-III-2"],
		["115","P-A-1-III-2"],
		["113","P-A-1-III-2"],
		["1142","P-A-1-III-2"],
		["1143","P-A-1-III-2"],
		["1144","P-A-1-III-2"],
		["108","P-A-1-IV-"],
		["109","P-A-1-IV-"],
		["111","P-A-1-IX-"],
		["120","P-A-1-V-1"],
		["121","P-A-1-V-2"],
		["118","P-A-1-VI-"],
		["129","P-A-1-VII-"],
		["557","P-A-1-VIII-"],
		["133","P-A-2-I-"],
		["136","P-A-2-I-"],
		["1340","P-A-2-II-"],
		["1341","P-A-2-II-"],
		["137","P-A-2-III-"],
		["135","P-A-2-III-"],
		["131","P-A-3--"],
		["130","P-A-3--"],
		["132","P-A-3--"],
		["140","P-B--I-1"],
		["145","P-B--I-2"],
		["146","P-B--I-3"],
		["142","P-B--I-4"],
		["141","P-B--I-4"],
		["147","P-B--I-4"],
		["143","P-B--I-4"],
		["177","P-B--II-1"],
		["178","P-B--II-1"],
		["179","P-B--II-1"],
		["1605","P-B--II-2"],
		["170","P-B--II-2"],
		["1625","P-B--II-3"],
		["174","P-B--II-3"],
		["176","P-B--II-4"],
		["171","P-B--II-5"],
		["173","P-B--II-5"],
		["172","P-B--II-5"],
		["175","P-B--II-5"],
		["189","P-B--II-5"],
		["185","P-B--II-5"],
		["150","P-B--II-5"],
		["180","P-B--II-5"],
		["1615","P-B--II-5"],
		["1635","P-B--II-5"],
		["1604","P-B--III-"],
		["1603","P-B--III-"],
		["1613","P-B--III-"],
		["1614","P-B--III-"],
		["1623","P-B--III-"],
		["1624","P-B--III-"],
		["1633","P-B--III-"],
		["1634","P-B--III-"],
		["479","P-B--IV-"],
		["181","P-B--V-"],
		["588","P-C--I-"],
		["589","P-C--I-"],
		["587","P-C--I-"],
		["586","P-C--I-"],
		["585","P-C--I-"],
		["499","P-C--II-"],
		["529","P-C--II-"],
		["506","P-C--III-1"],
		["500","P-C--III-1"],
		["501","P-C--III-1"],
		["505","P-C--III-1"],
		["527","P-C--III-2"],
		["5105","P-C--III-2"],
		["520","P-C--III-2"],
		["5125","P-C--III-3"],
		["524","P-C--III-3"],
		["5598","P-C--III-4"],
		["5595","P-C--III-4"],
		["1034","P-C--III-5"],
		["194","P-C--III-5"],
		["1044","P-C--III-5"],
		["525","P-C--III-5"],
		["192","P-C--III-5"],
		["569","P-C--III-5"],
		["5532","P-C--III-5"],
		["509","P-C--III-5"],
		["5135","P-C--III-5"],
		["5530","P-C--III-5"],
		["528","P-C--III-5"],
		["5145","P-C--III-5"],
		["526","P-C--III-5"],
		["561","P-C--III-5"],
		["560","P-C--III-5"],
		["521","P-C--III-5"],
		["522","P-C--III-5"],
		["190","P-C--III-5"],
		["523","P-C--III-5"],
		["5566","P-C--III-5"],
		["555","P-C--III-5"],
		["5565","P-C--III-5"],
		["5525","P-C--III-5"],
		["5115","P-C--III-5"],
		["551","P-C--III-5"],
		["5113","P-C--IV-"],
		["5114","P-C--IV-"],
		["5123","P-C--IV-"],
		["5124","P-C--IV-"],
		["5133","P-C--IV-"],
		["5104","P-C--IV-"],
		["5103","P-C--IV-"],
		["5134","P-C--IV-"],
		["5143","P-C--IV-"],
		["5144","P-C--IV-"],
		["5563","P-C--IV-"],
		["5564","P-C--IV-"],
		["400","P-C--V-1"],
		["405","P-C--V-1"],
		["406","P-C--V-1"],
		["401","P-C--V-1"],
		["403","P-C--V-2"],
		["404","P-C--V-2"],
		["41","P-C--V-3"],
		["465","P-C--V-4"],
		["466","P-C--V-4"],
		["4752","P-C--V-5"],
		["476","P-C--V-6"],
		["477","P-C--V-6"],
		["4758","P-C--V-6"],
		["4751","P-C--V-6"],
		["4750","P-C--V-6"],
		["438","P-C--V-7"],
		["485","P-C--VI-"],
		["568","P-C--VI-"],
		["7951","PG-A-10--"],
		["7952","PG-A-10--"],
		["7956","PG-A-10--"],
		["7955","PG-A-10--"],
		["691","PG-A-11-a-"],
		["792","PG-A-11-a-"],
		["791","PG-A-11-a-"],
		["790","PG-A-11-a-"],
		["690","PG-A-11-a-"],
		["692","PG-A-11-a-"],
		["770","PG-A-11-b-"],
		["670","PG-A-11-b-"],
		["671","PG-A-11-b-"],
		["672","PG-A-11-b-"],
		["771","PG-A-11-b-"],
		["772","PG-A-11-b-"],
		["7601","PG-A-12-a-1"],
		["7600","PG-A-12-a-1"],
		["7602","PG-A-12-a-2"],
		["7603","PG-A-12-a-2"],
		["7611","PG-A-12-b-1"],
		["7610","PG-A-12-b-1"],
		["76200", "PG-A-12-b-1"],
		["76211", "PG-A-12-b-1"],
		["76210", "PG-A-12-b-1"],
		["76201", "PG-A-12-b-1"],
		["76202", "PG-A-12-b-2"],
		["76213", "PG-A-12-b-2"],
		["76212", "PG-A-12-b-2"],
		["76203", "PG-A-12-b-2"],
		["7612","PG-A-12-b-2"],
		["7613","PG-A-12-b-2"],
		["767","PG-A-12-b-2"],
		["769","PG-A-12-b-2"],
		["6615","PG-A-13-a-"],
		["6616","PG-A-13-a-"],
		["6651","PG-A-13-a-"],
		["6650","PG-A-13-a-"],
		["6620","PG-A-13-a-"],
		["6621","PG-A-13-a-"],
		["6641","PG-A-13-a-"],
		["6640","PG-A-13-a-"],
		["6610","PG-A-13-a-"],
		["6611","PG-A-13-a-"],
		["6655","PG-A-13-a-"],
		["6654","PG-A-13-a-"],
		["6657","PG-A-13-b-"],
		["6612","PG-A-13-b-"],
		["6613","PG-A-13-b-"],
		["6617","PG-A-13-b-"],
		["6618","PG-A-13-b-"],
		["6622","PG-A-13-b-"],
		["6623","PG-A-13-b-"],
		["6624","PG-A-13-b-"],
		["6642","PG-A-13-b-"],
		["6643","PG-A-13-b-"],
		["6652","PG-A-13-b-"],
		["6653","PG-A-13-b-"],
		["6656","PG-A-13-b-"],
		["669","PG-A-13-b-"],
		["660","PG-A-13-c-"],
		["7633","PG-A-14-a-"],
		["6631","PG-A-14-a-"],
		["6633","PG-A-14-a-"],
		["6630","PG-A-14-a-"],
		["7630","PG-A-14-a-"],
		["7631","PG-A-14-a-"],
		["7632","PG-A-14-b-"],
		["6632","PG-A-14-b-"],
		["768","PG-A-15--"],
		["668","PG-A-15--"],
		["699","PG-A-16-a-"],
		["797","PG-A-16-a-"],
		["798","PG-A-16-a-"],
		["799","PG-A-16-a-"],
		["696","PG-A-16-a-"],
		["697","PG-A-16-a-"],
		["698","PG-A-16-a-"],
		["796","PG-A-16-a-"],
		["673","PG-A-16-b-"],
		["667","PG-A-16-b-"],
		["666","PG-A-16-b-"],
		["775","PG-A-16-b-"],
		["773","PG-A-16-b-"],
		["766","PG-A-16-b-"],
		["675","PG-A-16-b-"],
		["6301","PG-A-17--"],
		["638","PG-A-17--"],
		["6300","PG-A-17--"],
		["633","PG-A-17--"],
		["702","PG-A-1-a-"],
		["706","PG-A-1-a-"],
		["708","PG-A-1-a-"],
		["709","PG-A-1-a-"],
		["701","PG-A-1-a-"],
		["700","PG-A-1-a-"],
		["703","PG-A-1-a-"],
		["704","PG-A-1-a-"],
		["705","PG-A-1-b-"],
		["6930","PG-A-2--"],
		["7930","PG-A-2--"],
		["71","PG-A-2--"],
		["73","PG-A-3--"],
		["6060","PG-A-4-a-"],
		["600","PG-A-4-a-"],
		["6080","PG-A-4-a-"],
		["6090","PG-A-4-a-"],
		["610","PG-A-4-a-"],
		["6062","PG-A-4-b-"],
		["6091","PG-A-4-b-"],
		["602","PG-A-4-b-"],
		["6061","PG-A-4-b-"],
		["601","PG-A-4-b-"],
		["6092","PG-A-4-b-"],
		["612","PG-A-4-b-"],
		["611","PG-A-4-b-"],
		["6081","PG-A-4-b-"],
		["6082","PG-A-4-b-"],
		["607","PG-A-4-c-"],
		["7931","PG-A-4-d-"],
		["6932","PG-A-4-d-"],
		["6931","PG-A-4-d-"],
		["7932","PG-A-4-d-"],
		["7933","PG-A-4-d-"],
		["6933","PG-A-4-d-"],
		["75","PG-A-5-a-"],
		["740","PG-A-5-b-"],
		["747","PG-A-5-b-"],
		["6450","PG-A-6-a-"],
		["640","PG-A-6-a-"],
		["641","PG-A-6-a-"],
		["642","PG-A-6-b-"],
		["643","PG-A-6-b-"],
		["649","PG-A-6-b-"],
		["7950","PG-A-6-c-"],
		["644","PG-A-6-c-"],
		["6457","PG-A-6-c-"],
		["7957","PG-A-6-c-"],
		["62","PG-A-7-a-"],
		["634","PG-A-7-b-"],
		["636","PG-A-7-b-"],
		["631","PG-A-7-b-"],
		["639","PG-A-7-b-"],
		["694","PG-A-7-c-"],
		["695","PG-A-7-c-"],
		["794","PG-A-7-c-"],
		["7954","PG-A-7-c-"],
		["650","PG-A-7-c-"],
		["651","PG-A-7-d-"],
		["659","PG-A-7-d-"],
		["68","PG-A-8--"],
		["746","PG-A-9--"]
	];
		
	util.createProgressDialog(util.translate("scripts", "Actualizando códigos de balance"), datos.length);
	
	datos.sort();
			
	for (i = datos.length - 1; i >= 0; i--) {
	
		util.setProgress(datos.length - i);
		
		codCuenta = datos[i][0];
		
		curCbl.select("codcuenta = '" + codCuenta + "'");
		if (curCbl.first()) {
			continue;
		}
		else {
			curCbl.setModeAccess(curCbl.Insert);
			curCbl.refreshBuffer();
			curCbl.setValueBuffer("codcuenta", codCuenta);
			curCbl.setValueBuffer("codbalance", datos[i][1]);
			curCbl.commitBuffer();
		}
		
		
	}

	util.destroyProgressDialog();
}


/** \D Se actualizan los códigos de balance en las cuentas
\end */
function pgc2008_actualizarCuentas2008ba(codEjercicio:String)
{
	var util:FLUtil = new FLUtil;
	var curCbl:FLSqlCursor = new FLSqlCursor("co_cuentascbba");
	curCbl.setActivatedCheckIntegrity(false);
	
	var datos = [
		["290","A-A--I-1"],
		["280","A-A--I-1"],
		["20","A-A--I-1"],
		["281","A-A--II-1"],
		["291","A-A--II-1"],
		["23","A-A--II-1"],
		["21","A-A--II-1"],
		["282","A-A--III-1"],
		["292","A-A--III-1"],
		["22","A-A--III-1"],
		["293","A-A--IV-1"],
		["2494","A-A--IV-1"],
		["2424","A-A--IV-1"],
		["2493","A-A--IV-1"],
		["2423","A-A--IV-1"],
		["2404","A-A--IV-1"],
		["2414","A-A--IV-1"],
		["2413","A-A--IV-1"],
		["2403","A-A--IV-1"],
		["2944","A-A--IV-1"],
		["2954","A-A--IV-1"],
		["2953","A-A--IV-1"],
		["2943","A-A--IV-1"],
		["254","A-A--V-1"],
		["253","A-A--V-1"],
		["252","A-A--V-1"],
		["251","A-A--V-1"],
		["250","A-A--V-1"],
		["2495","A-A--V-1"],
		["2425","A-A--V-1"],
		["2415","A-A--V-1"],
		["2405","A-A--V-1"],
		["26","A-A--V-1"],
		["259","A-A--V-1"],
		["258","A-A--V-1"],
		["257","A-A--V-1"],
		["298","A-A--V-1"],
		["255","A-A--V-1"],
		["2955","A-A--V-1"],
		["297","A-A--V-1"],
		["2945","A-A--V-1"],
		["474","A-A--VI-"],
		["580","A-B--I-"],
		["581","A-B--I-"],
		["582","A-B--I-"],
		["583","A-B--I-"],
		["584","A-B--I-"],
		["599","A-B--I-"],
		["31","A-B--II-1"],
		["407","A-B--II-1"],
		["39","A-B--II-1"],
		["36","A-B--II-1"],
		["35","A-B--II-1"],
		["34","A-B--II-1"],
		["33","A-B--II-1"],
		["32","A-B--II-1"],
		["30","A-B--II-1"],
		["431","A-B--III-1"],
		["430","A-B--III-1"],
		["493","A-B--III-1"],
		["490","A-B--III-1"],
		["437","A-B--III-1"],
		["436","A-B--III-1"],
		["435","A-B--III-1"],
		["434","A-B--III-1"],
		["433","A-B--III-1"],
		["432","A-B--III-1"],
		["5580","A-B--III-2"],
		["5533","A-B--III-3"],
		["44","A-B--III-3"],
		["460","A-B--III-3"],
		["470","A-B--III-3"],
		["471","A-B--III-3"],
		["472","A-B--III-3"],
		["544","A-B--III-3"],
		["5531","A-B--III-3"],
		["5353","A-B--IV-1"],
		["5943","A-B--IV-1"],
		["5944","A-B--IV-1"],
		["5354","A-B--IV-1"],
		["5393","A-B--IV-1"],
		["5953","A-B--IV-1"],
		["5954","A-B--IV-1"],
		["5303","A-B--IV-1"],
		["5394","A-B--IV-1"],
		["5523","A-B--IV-1"],
		["5524","A-B--IV-1"],
		["5313","A-B--IV-1"],
		["5304","A-B--IV-1"],
		["593","A-B--IV-1"],
		["5344","A-B--IV-1"],
		["5343","A-B--IV-1"],
		["5334","A-B--IV-1"],
		["5333","A-B--IV-1"],
		["5324","A-B--IV-1"],
		["5323","A-B--IV-1"],
		["5314","A-B--IV-1"],
		["549","A-B--V-1"],
		["5305","A-B--V-1"],
		["5315","A-B--V-1"],
		["5325","A-B--V-1"],
		["5335","A-B--V-1"],
		["5345","A-B--V-1"],
		["5355","A-B--V-1"],
		["5395","A-B--V-1"],
		["540","A-B--V-1"],
		["541","A-B--V-1"],
		["542","A-B--V-1"],
		["543","A-B--V-1"],
		["545","A-B--V-1"],
		["546","A-B--V-1"],
		["547","A-B--V-1"],
		["548","A-B--V-1"],
		["551","A-B--V-1"],
		["5525","A-B--V-1"],
		["5590","A-B--V-1"],
		["5593","A-B--V-1"],
		["565","A-B--V-1"],
		["566","A-B--V-1"],
		["5945","A-B--V-1"],
		["5955","A-B--V-1"],
		["597","A-B--V-1"],
		["598","A-B--V-1"],
		["480","A-B--VI-"],
		["567","A-B--VI-"],
		["57","A-B--VII-1"],
		["800","IG-A--I-1"],
		["89","IG-A--I-1"],
		["900","IG-A--I-1"],
		["991","IG-A--I-1"],
		["992","IG-A--I-1"],
		["910","IG-A--II-"],
		["810","IG-A--II-"],
		["94","IG-A--III-"],
		["95","IG-A--IV-"],
		["85","IG-A--IV-"],
		["8301","IG-A--V-"],
		["833","IG-A--V-"],
		["835","IG-A--V-"],
		["838","IG-A--V-"],
		["834","IG-A--V-"],
		["8300","IG-A--V-"],
		["837","IG-B--IX-"],
		["8301","IG-B--IX-"],
		["836","IG-B--IX-"],
		["902","IG-B--VI-1"],
		["802","IG-B--VI-1"],
		["994","IG-B--VI-1"],
		["993","IG-B--VI-1"],
		["812","IG-B--VII-"],
		["912","IG-B--VII-"],
		["84","IG-B--VIII-"],
		["101","P-A-1-I-1"],
		["102","P-A-1-I-1"],
		["100","P-A-1-I-1"],
		["1030","P-A-1-I-2"],
		["1040","P-A-1-I-2"],
		["110","P-A-1-II-"],
		["113","P-A-1-III-1"],
		["114","P-A-1-III-1"],
		["115","P-A-1-III-1"],
		["119","P-A-1-III-1"],
		["112","P-A-1-III-1"],
		["108","P-A-1-IV-"],
		["109","P-A-1-IV-"],
		["111","P-A-1-IX-"],
		["121","P-A-1-V-1"],
		["120","P-A-1-V-1"],
		["118","P-A-1-VI-"],
		["129","P-A-1-VII-"],
		["557","P-A-1-VIII-"],
		["137","P-A-2-I-"],
		["1340","P-A-2-I-"],
		["133","P-A-2-I-"],
		["132","P-A-3--"],
		["130","P-A-3--"],
		["131","P-A-3--"],
		["14","P-B--I-1"],
		["170","P-B--II-1"],
		["1605","P-B--II-1"],
		["1625","P-B--II-2"],
		["174","P-B--II-2"],
		["1635","P-B--II-3"],
		["171","P-B--II-3"],
		["172","P-B--II-3"],
		["173","P-B--II-3"],
		["1615","P-B--II-3"],
		["189","P-B--II-3"],
		["185","P-B--II-3"],
		["180","P-B--II-3"],
		["179","P-B--II-3"],
		["178","P-B--II-3"],
		["177","P-B--II-3"],
		["176","P-B--II-3"],
		["175","P-B--II-3"],
		["1603","P-B--III-"],
		["1634","P-B--III-"],
		["1633","P-B--III-"],
		["1624","P-B--III-"],
		["1623","P-B--III-"],
		["1614","P-B--III-"],
		["1613","P-B--III-"],
		["1604","P-B--III-"],
		["479","P-B--IV-"],
		["181","P-B--V-"],
		["589","P-C--I-"],
		["588","P-C--I-"],
		["587","P-C--I-"],
		["586","P-C--I-"],
		["585","P-C--I-"],
		["529","P-C--II-"],
		["499","P-C--II-"],
		["5105","P-C--III-1"],
		["527","P-C--III-1"],
		["520","P-C--III-1"],
		["524","P-C--III-2"],
		["5125","P-C--III-2"],
		["5135","P-C--III-3"],
		["5115","P-C--III-3"],
		["509","P-C--III-3"],
		["506","P-C--III-3"],
		["505","P-C--III-3"],
		["501","P-C--III-3"],
		["500","P-C--III-3"],
		["194","P-C--III-3"],
		["192","P-C--III-3"],
		["190","P-C--III-3"],
		["5145","P-C--III-3"],
		["1034","P-C--III-3"],
		["5530","P-C--III-3"],
		["1044","P-C--III-3"],
		["560","P-C--III-3"],
		["561","P-C--III-3"],
		["569","P-C--III-3"],
		["522","P-C--III-3"],
		["523","P-C--III-3"],
		["525","P-C--III-3"],
		["526","P-C--III-3"],
		["528","P-C--III-3"],
		["551","P-C--III-3"],
		["5525","P-C--III-3"],
		["5532","P-C--III-3"],
		["555","P-C--III-3"],
		["5565","P-C--III-3"],
		["5566","P-C--III-3"],
		["5595","P-C--III-3"],
		["521","P-C--III-3"],
		["5598","P-C--III-3"],
		["5564","P-C--IV-"],
		["5103","P-C--IV-"],
		["5113","P-C--IV-"],
		["5114","P-C--IV-"],
		["5123","P-C--IV-"],
		["5124","P-C--IV-"],
		["5133","P-C--IV-"],
		["5134","P-C--IV-"],
		["5143","P-C--IV-"],
		["5144","P-C--IV-"],
		["5523","P-C--IV-"],
		["5524","P-C--IV-"],
		["5563","P-C--IV-"],
		["5104","P-C--IV-"],
		["405","P-C--V-1"],
		["406","P-C--V-1"],
		["404","P-C--V-1"],
		["403","P-C--V-1"],
		["401","P-C--V-1"],
		["400","P-C--V-1"],
		["475","P-C--V-2"],
		["476","P-C--V-2"],
		["477","P-C--V-2"],
		["41","P-C--V-2"],
		["438","P-C--V-2"],
		["465","P-C--V-2"],
		["466","P-C--V-2"],
		["568","P-C--VI-"],
		["485","P-C--VI-"],
		["7951","PG-A-10--"],
		["7956","PG-A-10--"],
		["7955","PG-A-10--"],
		["7952","PG-A-10--"],
		["670","PG-A-11-a-"],
		["792","PG-A-11-a-"],
		["791","PG-A-11-a-"],
		["790","PG-A-11-a-"],
		["772","PG-A-11-a-"],
		["771","PG-A-11-a-"],
		["770","PG-A-11-a-"],
		["692","PG-A-11-a-"],
		["691","PG-A-11-a-"],
		["690","PG-A-11-a-"],
		["672","PG-A-11-a-"],
		["671","PG-A-11-a-"],
		["769","PG-A-12-a-1"],
		["762","PG-A-12-a-1"],
		["761","PG-A-12-a-1"],
		["760","PG-A-12-a-1"],
		["767","PG-A-12-a-1"],
		["669","PG-A-13-a-"],
		["660","PG-A-13-a-"],
		["665","PG-A-13-a-"],
		["664","PG-A-13-a-"],
		["662","PG-A-13-a-"],
		["661","PG-A-13-a-"],
		["763","PG-A-14-a-"],
		["663","PG-A-14-a-"],
		["668","PG-A-15--"],
		["768","PG-A-15--"],
		["675","PG-A-16-a-"],
		["667","PG-A-16-a-"],
		["666","PG-A-16-a-"],
		["698","PG-A-16-a-"],
		["697","PG-A-16-a-"],
		["696","PG-A-16-a-"],
		["668","PG-A-16-a-"],
		["799","PG-A-16-a-"],
		["798","PG-A-16-a-"],
		["797","PG-A-16-a-"],
		["796","PG-A-16-a-"],
		["775","PG-A-16-a-"],
		["773","PG-A-16-a-"],
		["766","PG-A-16-a-"],
		["699","PG-A-16-a-"],
		["638","PG-A-17--"],
		["633","PG-A-17--"],
		["6301","PG-A-17--"],
		["6300","PG-A-17--"],
		["708","PG-A-1-a-"],
		["703","PG-A-1-a-"],
		["700","PG-A-1-a-"],
		["701","PG-A-1-a-"],
		["702","PG-A-1-a-"],
		["704","PG-A-1-a-"],
		["705","PG-A-1-a-"],
		["706","PG-A-1-a-"],
		["709","PG-A-1-a-"],
		["71","PG-A-2--"],
		["7930","PG-A-2--"],
		["6930","PG-A-2--"],
		["73","PG-A-3--"],
		["600","PG-A-4-a-"],
		["601","PG-A-4-a-"],
		["602","PG-A-4-a-"],
		["606","PG-A-4-a-"],
		["607","PG-A-4-a-"],
		["608","PG-A-4-a-"],
		["609","PG-A-4-a-"],
		["61","PG-A-4-a-"],
		["6931","PG-A-4-a-"],
		["6932","PG-A-4-a-"],
		["6933","PG-A-4-a-"],
		["7931","PG-A-4-a-"],
		["7933","PG-A-4-a-"],
		["7932","PG-A-4-a-"],
		["75","PG-A-5-a-"],
		["740","PG-A-5-a-"],
		["747","PG-A-5-a-"],
		["64","PG-A-6-a-"],
		["634","PG-A-7-a-"],
		["62","PG-A-7-a-"],
		["636","PG-A-7-a-"],
		["631","PG-A-7-a-"],
		["7954","PG-A-7-a-"],
		["794","PG-A-7-a-"],
		["695","PG-A-7-a-"],
		["694","PG-A-7-a-"],
		["65","PG-A-7-a-"],
		["639","PG-A-7-a-"],
		["68","PG-A-8--"],
		["746","PG-A-9--"]
	];
		
	util.createProgressDialog(util.translate("scripts", "Actualizando códigos de balance abreviado"), datos.length);
	
	datos.sort();
			
	for (i = datos.length - 1; i >= 0; i--) {
	
		util.setProgress(datos.length - i);
		
		codCuenta = datos[i][0];
		
		curCbl.select("codcuenta = '" + codCuenta + "'");
		if (curCbl.first()) {
			continue;
		}
		else {
			curCbl.setModeAccess(curCbl.Insert);
			curCbl.refreshBuffer();
			curCbl.setValueBuffer("codcuenta", codCuenta);
			curCbl.setValueBuffer("codbalance", datos[i][1]);
			curCbl.commitBuffer();
		}
		
		
	}
	
	util.destroyProgressDialog();
	
	
	// Descripciones de balance abreviado
	var datos = [
		["A-B--III-1", "1. Clientes por ventas y prestaciones de servicios"],
		["A-B--III-2", "2. Accionistas (socios) por desembolsos exigidos"],
		["A-B--III-3", "3. Otros deudores"],
		["P-A-1-I-1", "1. Capital escriturado"],
		["P-A-1-I-2", "2. (Capital no exigido)"],
		["P-B--II-1", "1. Deudas con entidades de crédito"],
		["P-B--II-2", "2. Acreedores por arrendamiento financiero"],
		["P-B--II-3", "3. Otras deudas a largo plazo"],
		["P-C--III-1", "1. Deudas con entidades de crédito"],
		["P-C--III-2", "2. Acreedores por arrendamiento financiero"],
		["P-C--III-3", "3. Otras deudas a corto plazo"],
		["P-C--V-1", "1. Proveedores"],
		["P-C--V-2", "2. Otros acreedores"],
	];
		
	util.createProgressDialog(util.translate("scripts", "Actualizando nombres de códigos de balance abreviado"), datos.length);
	
	curCbl = new FLSqlCursor("co_codbalances08");
	curCbl.setActivatedCheckIntegrity(false);
			
	for (i = 0; i < datos.length; i++) {
	
		util.setProgress(i);
		
		curCbl.select("codbalance = '" + datos[i][0] + "'");
		if (!curCbl.first())
			continue;
		else {
			curCbl.setModeAccess(curCbl.Edit);
			curCbl.refreshBuffer();
			curCbl.setValueBuffer("descripcion4ba", datos[i][1]);
			curCbl.commitBuffer();
		}
		
	}
	
	util.destroyProgressDialog();
	
	
	
	return;
	/************* ASIENTO DE PRUEBAS */
	
	util.sqlDelete("co_partidas", "idasiento = 19");
	var curP:FLSqlCursor = new FLSqlCursor("co_partidas");
	var curS:FLSqlCursor = new FLSqlCursor("co_subcuentas");
	curS.select("codejercicio = '0002'");
	haber = 0;
	paso = 0;
		
	util.createProgressDialog(util.translate("scripts", "Creando asiento de pruebas"), curS.size());
	
	while(curS.next()) {
	
		util.setProgress(paso++);
		haber += parseFloat(curS.valueBuffer("codcuenta"));
	
		curP.setModeAccess(curP.Insert);
		curP.refreshBuffer();
	
		curP.setValueBuffer("idasiento", 19);
		curP.setValueBuffer("idsubcuenta", curS.valueBuffer("idsubcuenta"));
		curP.setValueBuffer("codsubcuenta", curS.valueBuffer("codsubcuenta"));
		curP.setValueBuffer("debe", curS.valueBuffer("codcuenta"));
		curP.setValueBuffer("haber", 0);
		curP.setValueBuffer("tasaconv", 1);
		curP.setValueBuffer("debeme", 0);
		curP.setValueBuffer("haberme", 0);
		curP.setValueBuffer("baseimponible", 0);
		curP.setValueBuffer("iva", 0);
		curP.setValueBuffer("recargo", 0);
		curP.commitBuffer();
	}
	
	curP.setModeAccess(curP.Insert);
	curP.refreshBuffer();
	
	curP.setValueBuffer("idasiento", 19);
	curP.setValueBuffer("idsubcuenta", curS.valueBuffer("idsubcuenta"));
	curP.setValueBuffer("codsubcuenta", curS.valueBuffer("codsubcuenta"));
	curP.setValueBuffer("debe", 0);
	curP.setValueBuffer("haber", haber);
	curP.setValueBuffer("tasaconv", 1);
	curP.setValueBuffer("debeme", 0);
	curP.setValueBuffer("haberme", 0);
	curP.setValueBuffer("baseimponible", 0);
	curP.setValueBuffer("iva", 0);
	curP.setValueBuffer("recargo", 0);
	curP.commitBuffer();
	
	util.destroyProgressDialog();
}


/** Se establecen los códigos de cuenta especial en las cuentas que lo requieren del nuevo ejercicio
*/
function pgc2008_actualizarCuentasEspeciales(codEjercicio:String)
{
	var util:FLUtil = new FLUtil;
	var curCbl:FLSqlCursor = new FLSqlCursor("co_cuentas");
	
	this.iface.completarTiposEspeciales();
	var datos:Array = this.iface.datosCuentasEspeciales();
			
	util.createProgressDialog(util.translate("scripts", "Actualizando cuentas especiales"), datos.length);
	
	for (i = 0; i < datos.length; i++) {
		util.setProgress(i);
		with(curCbl) {
		
			codCuenta08 = util.sqlSelect("co_correspondenciascc", "codigo08", "codigo90 = '" + datos[i][0] + "'");
		
			select("codcuenta = '" + codCuenta08 + "' and codejercicio = '" + codEjercicio + "'");
			if (!first())
				continue;
				
			setModeAccess(curCbl.Edit);
			refreshBuffer();
			setValueBuffer("idcuentaesp", datos[i][1]);
			commitBuffer();
		}
	}
	
	util.destroyProgressDialog();
}




/** \D Se crean los epígrafes y cuentas
\end */
function pgc2008_generarCuadroCuentas(codEjercicio:String)
{
	this.iface.generarGrupos(codEjercicio);
	this.iface.generarSubgrupos(codEjercicio);
	this.iface.generarCuentas(codEjercicio);
}

function pgc2008_generarGrupos(codEjercicio:String)
{	
	var util:FLUtil = new FLUtil;
	var curCbl:FLSqlCursor;	
	
	// GRUPOS
	var datos:Array = this.iface.datosGrupos();
	
	curCbl = new FLSqlCursor("co_gruposepigrafes");
	curCbl.setActivatedCheckIntegrity(false);
	util.createProgressDialog(util.translate("scripts", "Creando grupos 2008"), datos.length);
			
	for (i = 0; i < datos.length; i++) {
		util.setProgress(i);
		with(curCbl) {
			setModeAccess(curCbl.Insert);
			refreshBuffer();
			setValueBuffer("codgrupo", datos[i][0]);
			setValueBuffer("descripcion", datos[i][1]);
			setValueBuffer("codejercicio", codEjercicio);
			commitBuffer();
		}
	}
	util.destroyProgressDialog();
}				
	
function pgc2008_generarSubgrupos(codEjercicio:String)
{	
	var util:FLUtil = new FLUtil;
	var curCbl:FLSqlCursor;	
	
	// SUBGRUPOS (antes Epígrafes)
	var datos:Array = this.iface.datosSubgrupos();		
	curCbl = new FLSqlCursor("co_epigrafes");
	curCbl.setActivatedCheckIntegrity(false);
	util.createProgressDialog(util.translate("scripts", "Creando epigrafes 2008"), datos.length);
			
	for (i = 0; i < datos.length; i++) {
		
		idGrupo = util.sqlSelect("co_gruposepigrafes", "idgrupo", "codgrupo = '" + datos[i][2] + "' and codejercicio = '" + codEjercicio + "'");
		
		util.setProgress(i);
		with(curCbl) {
			setModeAccess(curCbl.Insert);
			refreshBuffer();
			setValueBuffer("codepigrafe", datos[i][0]);
			setValueBuffer("descripcion", datos[i][1]);
			setValueBuffer("idgrupo", idGrupo);
			setValueBuffer("codejercicio", codEjercicio);
			commitBuffer();
		}
	}
	util.destroyProgressDialog();
}		
		
function pgc2008_generarCuentas(codEjercicio:String)
{	
	var util:FLUtil = new FLUtil;
	var curCbl:FLSqlCursor;	
	
	// CUENTAS
	var datos:Array = this.iface.datosCuentas();		
	curCbl = new FLSqlCursor("co_cuentas");
	curCbl.setActivatedCheckIntegrity(false);
	
	util.createProgressDialog(util.translate("scripts", "Creando cuentas 2008"), datos.length);
			
	for (i = 0; i < datos.length; i++) {
		util.setProgress(i);
		
		idEpigrafe = util.sqlSelect("co_epigrafes", "idepigrafe", "codepigrafe = '" + datos[i][2] + "' and codejercicio = '" + codEjercicio + "'");
		
		with(curCbl) {
			setModeAccess(curCbl.Insert);
			refreshBuffer();
			setValueBuffer("codcuenta", datos[i][0]);
			setValueBuffer("descripcion", datos[i][1]);
			setValueBuffer("idepigrafe", idEpigrafe);
			setValueBuffer("codepigrafe", datos[i][2]);
			setValueBuffer("codejercicio", codEjercicio);
			commitBuffer();
		}
	}
	util.destroyProgressDialog();
}

/** Genera las subcuentas necesarias a partir de las cuentas ya existentes
*/
function pgc2008_generarSubcuentas(codEjercicio:String, longSubcuenta:Number)
{
	var util:FLUtil = new FLUtil();
	var curCuenta:FLSqlCursor = new FLSqlCursor("co_cuentas");
	var curSubcuenta:FLSqlCursor = new FLSqlCursor("co_subcuentas");
	curCuenta.setActivatedCheckIntegrity(false);
	curSubcuenta.setActivatedCheckIntegrity(false);
	
	var codSubcuenta:String;
	var numCeros:Number;
	var paso:Number = 0;
	
	var codDivisa =	util.sqlSelect("empresa", "coddivisa", "1 = 1");
	
	curCuenta.select("codejercicio = '" + codEjercicio + "'");
	util.createProgressDialog(util.translate("scripts", "Generando subcuentas adicionales"), curCuenta.size());
	
	
	while (curCuenta.next()) {
	
		util.setProgress(paso++);
	
		curCuenta.setModeAccess(curCuenta.Browse);
		curCuenta.refreshBuffer();
		codSubcuenta = curCuenta.valueBuffer("codcuenta");
		
		numCeros = longSubcuenta - codSubcuenta.toString().length;
		for (var i = 0; i < numCeros; i++)
			codSubcuenta += "0";
			
		// Existe ya la subcuenta?
		curSubcuenta.select("codsubcuenta = '" + codSubcuenta + "' AND codejercicio = '" + codEjercicio + "'");		
		if (curSubcuenta.first()) {
		
			// Corresponde a la cuenta o sólo coincide el código (ejemplo: cuentas 133 y 1330)
			if (!util.sqlSelect("co_subcuentas", "idcuenta", "idcuenta = " + curCuenta.valueBuffer("idcuenta") + " AND codsubcuenta = '" + codSubcuenta + "' AND codejercicio = '" + codEjercicio + "'")) {
				codSubcuenta = codSubcuenta.left(longSubcuenta - 1) + "1"; // Código -> 1330000001
				// Nueva comprobación
				curSubcuenta.select("codsubcuenta = '" + codSubcuenta + "' AND codejercicio = '" + codEjercicio + "'");		
				if (curSubcuenta.first())
					continue;
			}
					
			else
				continue;
		}
		
		with(curSubcuenta) {
			setModeAccess(curSubcuenta.Insert);
			refreshBuffer();
			setValueBuffer("codsubcuenta", codSubcuenta);
			setValueBuffer("descripcion", curCuenta.valueBuffer("descripcion"));
			setValueBuffer("codejercicio", codEjercicio);
			setValueBuffer("idcuenta", curCuenta.valueBuffer("idcuenta"));
			setValueBuffer("codcuenta", curCuenta.valueBuffer("codcuenta"));
			setValueBuffer("coddivisa", codDivisa);
			commitBuffer();
		}
	}
	util.destroyProgressDialog();
}

/** Se rellena la tabla de correspondencias entre cuentas de los planes 90-08
Sólo si no existen
*/
function pgc2008_generarCorrespondenciasCC(codEjercicio:String)
{
	var util:FLUtil = new FLUtil;
	
	if (util.sqlSelect("co_correspondenciascc", "codigo90", ""))
		return;
		
	var curCbl:FLSqlCursor;	
	
	var datos:Array = this.iface.datosCorrespondencias();
	curCbl = new FLSqlCursor("co_correspondenciascc");
	curCbl.setActivatedCheckIntegrity(false);
	util.createProgressDialog(util.translate("scripts", "Creando correspondencias entre planes 1990-2008"), datos.length);
	
	var datosCuenta:Array;
	
	for (i = 0; i < datos.length; i++) {
		util.setProgress(i);
		
		datosCuenta = flfactppal.iface.pub_ejecutarQry("co_cuentas", "descripcion,idepigrafe", "codcuenta = '" + datos[i][1] + "' AND codejercicio = '" + codEjercicio + "'");
		
		with(curCbl) {
			setModeAccess(curCbl.Insert);
			refreshBuffer();
			setValueBuffer("codigo90", datos[i][0]);
			setValueBuffer("codigo08", datos[i][1]);
			commitBuffer();
		}
	}
	util.destroyProgressDialog();
}


function pgc2008_convertirCodSubcuenta(codEjercicio:String, codSubcuenta90:String):String
{
	var util:FLUtil = new FLUtil();

	var codCuenta90:String = util.sqlSelect("co_subcuentas", "codcuenta", "codsubcuenta = '" + codSubcuenta90 + "' and codejercicio = '" + codEjercicio + "'");
	var rightSubcuenta90:String = codSubcuenta90.right(codSubcuenta90.length - codCuenta90.length);
	var codCuenta08:String = util.sqlSelect("co_correspondenciascc", "codigo08", "codigo90 = '" + codCuenta90 + "'");
	if (!codCuenta08)
		return false;	
	
	var rightSubcuenta08:String = rightSubcuenta90.right(codSubcuenta90.length - codCuenta08.length);
	
	// se completa con ceros
	while (rightSubcuenta08.length < codSubcuenta90.length - codCuenta08.length)
		rightSubcuenta08 = "0" + rightSubcuenta08;
		
	return codCuenta08 + rightSubcuenta08;
}

function pgc2008_convertirCodCuenta(codCuenta90:String):String
{
	var util:FLUtil = new FLUtil();
	return util.sqlSelect("co_correspondenciascc", "codigo08", "codigo90 = '" + codCuenta90 + "'");
}



function pgc2008_datosGrupos():Array
{
	var datos:Array = [
		["1","Financiación básica"],
		["2","Activo no corriente"],
		["3","Existencias"],
		["4","Acreedores y deudores por operaciones comerciales"],
		["5","Cuentas financieras"],
		["6","Compras y gastos"],
		["7","Ventas e ingresos"],
		["8","Gastos imputados al patrimonio neto"],
		["9","Ingresos imputados al patrimonio neto"]
	];
	
	return datos;
}

function pgc2008_datosSubgrupos():Array
{
	var datos:Array = [
		["10","Capital","1"],
		["11","Reservas y otros instrumentos de patrimonio","1"],
		["12","Resultados pendientes de aplicacion","1"],
		["13","Subvenciones, donaciones y ajustes por cambios de valor","1"],
		["14","Provisiones","1"],
		["15","Deudas a largo plazo con caracteristicas especiales","1"],
		["16","Deudas a largo plazo con partes vinculadas","1"],
		["17","Deudas a largo plazo por prestamos recibidos, emprestitos y otros conceptos","1"],
		["18","Pasivos por fianzas, garantias y otros conceptos a largo plazo","1"],
		["19","Situaciones transitorias de financiacion","1"],
		["20","Inmovilizaciones intangibles","2"],
		["21","Inmovilizaciones materiales","2"],
		["22","Inversiones inmobiliarias","2"],
		["23","Inmovilizaciones materiales en curso","2"],
		["24","Inversiones financieras a largo plazo en partes vinculadas","2"],
		["25","Otras inversiones financieras a largo plazo","2"],
		["26","Fianzas y depositos constituidos a largo plazo","2"],
		["28","Amortizacion acumulada del inmovilizado","2"],
		["29","Deterioro de valor de activos no corrientes","2"],
		["30","Comerciales","3"],
		["31","Materias primas","3"],
		["32","Otros aprovisionamientos","3"],
		["33","Productos en curso","3"],
		["34","Productos semiterminados","3"],
		["35","Productos terminados","3"],
		["36","Subproductos, residuos y materiales recuperados","3"],
		["39","Deterioro de valor de las existencias","3"],
		["40","Proveedores","4"],
		["41","Acreedores varios","4"],
		["43","Clientes","4"],
		["44","Deudores varios","4"],
		["46","Personal","4"],
		["47","Administraciones publicas","4"],
		["48","Ajustes por periodificacion","4"],
		["49","Deterioro de valor de creditos comerciales y provisiones a corto plazo","4"],
		["50","Emprestitos, deudas con caracteristicas especiales y otras emisiones analogas a corto plazo","5"],
		["51","Deudas a corto plazo con partes vinculadas","5"],
		["52","Deudas a corto plazo por prestamos recibidos y otros conceptos","5"],
		["53","Inversiones financieras a corto plazo en partes vinculadas","5"],
		["54","Otras inversiones financieras a corto plazo","5"],
		["55","Otras cuentas no bancarias","5"],
		["56","Fianzas y depósitos recibidos y constituidos a corto plazo y ajustes por periodificación","5"],
		["57","Tesorería","5"],
		["58","Activos no corrientes mantenidos para la venta y activos y pasivos asociados","5"],
		["59","Deterioro del valor de inversiones financieras a corto plazo y de activos no corrientes mantenidos para la venta","5"],
		["60","Compras","6"],
		["61","Variación de existencias","6"],
		["62","Servicios exteriores","6"],
		["63","Tributos","6"],
		["64","Gastos de personal","6"],
		["65","Otros gastos de gestión","6"],
		["66","Gastos financieros","6"],
		["67","Pérdidas procedentes de activos no corrientes y gastos excepcionales","6"],
		["68","Dotaciones para amortizaciones","6"],
		["69","Pérdidas por deterioro y otras dotaciones","6"],
		["70","Ventas de mercaderías, de producción propia, de servicios, etc","7"],
		["71","Variación de existencias","7"],
		["73","Trabajos realizados para la empresa","7"],
		["74","Subvenciones, donaciones y legados","7"],
		["75","Otros ingresos de gestión","7"],
		["76","Ingresos financieros","7"],
		["77","Beneficios procedentes de activos no corrientes e ingresos excepcionales","7"],
		["79","Excesos y aplicaciones de provisiones y de pérdidas por deterioro","7"],
		["80","Gastos financieros por valoración de activos y pasivos","8"],
		["81","Gastos en operaciones de cobertura","8"],
		["82","Gastos por diferencias de conversión","8"],
		["83","Impuesto sobre beneficios","8"],
		["84","Transferencias de subvenciones, donaciones y legados","8"],
		["85","Gastos por pérdidas actuariales y ajustes en los activos por retribuciones a largo plazo de prestación definida","8"],
		["86","Gastos por activos no corrientes en venta","8"],
		["89","Gastos de participaciones en empresas del grupo o asociadas con ajustes valorativos positivos previos","8"],
		["90","Ingresos financieros por valoración de activos y pasivos","9"],
		["91","Ingresos en operaciones de cobertura","9"],
		["92","Ingresos por diferencias de conversion","9"],
		["94","Ingresos por subvenciones, donaciones y legados","9"],
		["95","Ingresos por ganancias actuariales y ajustes en los activos por retribuciones a largo plazo de prestacion definida","9"],
		["96","Ingresos por activos no corrientes en venta","9"],
		["99","Ingresos de participaciones en empresas del grupo o asociadas con ajustes valorativos negativos previos","9"]
	];

	return datos;
}



function pgc2008_datosCuentas():Array
{
	var datos:Array = [
		["100","Capital social","10"],
		["101","Fondo social","10"],
		["102","Capital","10"],
		["1030","Socios por desembolsos no exigidos, capital social","10"],
		["1034","Socios por desembolsos no exigidos, capital pendiente de inscripción","10"],
		["1040","Socios por aportaciones no dinerarias pendientes, capital social","10"],
		["1044","Socios por aportaciones no dinerarias pendientes, capital pendiente de inscripción","10"],
		["108","Acciones o participaciones propias en situaciones especiales","10"],
		["109","Acciones o participaciones propias para reducción de capital","10"],
		["110","Prima de emisión o asunción","11"],
		["1110","Patrimonio neto por emisión de instrumentos financieros compuestos","11"],
		["1111","Resto de instrumentos de patrimonio neto","11"],
		["112","Reserva legal","11"],
		["113","Reservas voluntarias","11"],
		["1140","Reservas para acciones o participaciones de la sociedad dominante","11"],
		["1141","Reservas estatutarias","11"],
		["1142","Reserva por capital amortizado","11"],
		["1143","Reserva por fondo de comercio","11"],
		["1144","Reservas por acciones propias aceptadas en garantía","11"],
		["115","Reservas por pérdidas y ganancias actuariales y otros ajustes","11"],
		["118","Aportaciones de socios o propietarios","11"],
		["119","Diferencias por ajuste del capital a euros","11"],
		["120","Remanente","12"],
		["121","Resultados negativos de ejercicios anteriores","12"],
		["129","Resultado del ejercicio","12"],
		["130","Subvenciones oficiales de capital","13"],
		["131","Donaciones y legados de capital","13"],
		["132","Otras subvenciones, donaciones y legados","13"],
		["133","Ajustes por valoración en activos financieros disponibles para la venta","13"],
		["1340","Cobertura de flujos de efectivo","13"],
		["1341","Cobertura de una inversión neta en un negocio en el extranjero","13"],
		["135","Diferencias de conversión","13"],
		["136","Ajustes por valoración en activos no corrientes y grupos enajenables de elementos, mantenidos para la venta","13"],
		["1370","Ingresos fiscales por diferencias permanentes a distribuir en varios ejercicios","13"],
		["1371","Ingresos fiscales por deducciones y bonificaciones a distribuir en varios ejercicios","13"],
		["140","Provisión por retribuciones a largo plazo al personal","14"],
		["141","Provisión para impuestos","14"],
		["142","Provisión para otras responsabilidades","14"],
		["143","Provisión por desmantelamiento, retiro o rehabilitación del inmovilizado","14"],
		["145","Provisión para actuaciones medioambientales","14"],
		["146","Provisión para reestructuraciones","14"],
		["147","Provisión por transacciones con pagos basados en instrumentos de patrimonio","14"],
		["150","Acciones o participaciones a largo plazo consideradas como pasivos financieros","15"],
		["1533","Desembolsos no exigidos, empresas del grupo","15"],
		["1534","Desembolsos no exigidos, empresas asociadas","15"],
		["1535","Desembolsos no exigidos, otras partes vinculadas","15"],
		["1536","Otros desembolsos no exigidos","15"],
		["1543","Aportaciones no dinerarias pendientes, empresas del grupo","15"],
		["1544","Aportaciones no dinerarias pendientes, empresas asociadas","15"],
		["1545","Aportaciones no dinerarias pendientes, otras partes vinculadas","15"],
		["1546","Otras aportaciones no dinerarias pendientes","15"],
		["1603","Deudas a largo plazo con entidades de crédito, empresas del grupo","16"],
		["1604","Deudas a largo plazo con entidades de crédito, empresas asociadas","16"],
		["1605","Deudas a largo plazo con otras entidades de crédito vinculadas","16"],
		["1613","Proveedores de inmovilizado a largo plazo, empresas del grupo","16"],
		["1614","Proveedores de inmovilizado a largo plazo, empresas asociadas","16"],
		["1615","Proveedores de inmovilizado a largo plazo, otras partes vinculadas","16"],
		["1623","Acreedores por arrendamiento financiero a largo plazo, empresas de grupo","16"],
		["1624","Acreedores por arrendamiento financiero a largo plazo, empresas asociadas","16"],
		["1625","Acreedores por arrendamiento financiero a largo plazo, otras partes vinculadas.","16"],
		["1633","Otras deudas a largo plazo, empresas del grupo","16"],
		["1634","Otras deudas a largo plazo, empresas asociadas","16"],
		["1635","Otras deudas a largo plazo, con otras partes vinculadas","16"],
		["170","Deudas a largo plazo con entidades de crédito","17"],
		["171","Deudas a largo plazo","17"],
		["172","Deudas a largo plazo transformables en subvenciones, donaciones y legados","17"],
		["173","Proveedores de inmovilizado a largo plazo","17"],
		["174","Acreedores por arrendamiento financiero a largo plazo","17"],
		["175","Efectos a pagar a largo plazo","17"],
		["1765","Pasivos por derivados financieros a largo plazo, cartera de negociación","17"],
		["1768","Pasivos por derivados financieros a largo plazo, instrumentos de cobertura","17"],
		["177","Obligaciones y bonos","17"],
		["178","Obligaciones y bonos convertibles","17"],
		["179","Deudas representadas en otros valores negociables","17"],
		["180","Fianzas recibidas a largo plazo","18"],
		["181","Anticipos recibidos por ventas o prestaciones de servicios a largo plazo","18"],
		["185","Depósitos recibidos a largo plazo","18"],
		["189","Garantías financieras a largo plazo","18"],
		["190","Acciones o participaciones emitidas","19"],
		["192","Suscriptores de acciones","19"],
		["194","Capital emitido pendiente de inscripción","19"],
		["195","Acciones o participaciones emitidas consideradas como pasivos financieros","19"],
		["197","Suscriptores de acciones consideradas como pasivos financieros","19"],
		["199","Acciones o participaciones emitidas consideradas como pasivos financieros pendientes de inscripción.","19"],
		["200","Investigación","20"],
		["201","Desarrollo","20"],
		["202","Concesiones administrativas","20"],
		["203","Propiedad industrial","20"],
		["204","Fondo de comercio","20"],
		["205","Derechos de traspaso","20"],
		["206","Aplicaciones informáticas","20"],
		["209","Anticipos para inmovilizaciones intangibles","20"],
		["210","Terrenos y bienes naturales","21"],
		["211","Construcciones","21"],
		["212","Instalaciones técnicas","21"],
		["213","Maquinaria","21"],
		["214","Utillaje","21"],
		["215","Otras instalaciones","21"],
		["216","Mobiliario","21"],
		["217","Equipos para procesos de información","21"],
		["218","Elementos de transporte","21"],
		["219","Otro inmovilizado material","21"],
		["220","Inversiones en terrenos y bienes naturales","22"],
		["221","Inversiones en construcciones","22"],
		["230","Adaptación de terrenos y bienes naturales","23"],
		["231","Construcciones en curso","23"],
		["232","Instalaciones técnicas en montaje","23"],
		["233","Maquinaria en montaje","23"],
		["237","Equipos para procesos de información en montaje","23"],
		["239","Anticipos para inmovilizaciones materiales","23"],
		["2403","Participaciones a largo plazo en empresas del grupo","24"],
		["2404","Participaciones a largo plazo en empresas asociadas","24"],
		["2405","Participaciones a largo plazo en otras partes vinculadas","24"],
		["2413","Valores representativos de deuda a largo plazo de empresas del grupo","24"],
		["2414","Valores representativos de deuda a largo plazo de empresas asociadas","24"],
		["2415","Valores representativos de deuda a largo plazo de otras partes vinculadas","24"],
		["2423","Créditos a largo plazo a empresas del grupo","24"],
		["2424","Créditos a largo plazo a empresas asociadas","24"],
		["2425","Créditos a largo plazo a otras partes vinculadas","24"],
		["2493","Desembolsos pendientes sobre participaciones a largo plazo en empresas del grupo.","24"],
		["2494","Desembolsos pendientes sobre participaciones a largo plazo en empresas asociadas.","24"],
		["2495","Desembolsos pendientes sobre participaciones a largo plazo en otras partes vinculadas","24"],
		["250","Inversiones financieras a largo plazo en instrumentos de patrimonio","25"],
		["251","Valores representativos de deuda a largo plazo","25"],
		["252","Créditos a largo plazo","25"],
		["253","Créditos a largo plazo por enajenación de inmovilizado","25"],
		["254","Créditos a largo plazo al personal","25"],
		["2550","Activos por derivados financieros a largo plazo, cartera de negociación","25"],
		["2553","Activos por derivados financieros a largo plazo, instrumentos de cobertura","25"],
		["257","Derechos de reembolso derivados de contratos de seguro relativos a retribuciones a largo plazo al personal","25"],
		["258","Imposiciones a largo plazo","25"],
		["259","Desembolsos pendientes sobre participaciones en el patrimonio neto a largo plazo","25"],
		["260","Fianzas constituidas a largo plazo","26"],
		["265","Depósitos constituidos a largo plazo","26"],
		["2800","Amortización acumulada de investigación","28"],
		["2801","Amortización acumulada de desarrollo","28"],
		["2802","Amortización acumulada de concesiones administrativas","28"],
		["2803","Amortización acumulada de propiedad industrial","28"],
		["2805","Amortización acumulada de derechos de traspaso","28"],
		["2806","Amortización acumulada de aplicaciones informáticas","28"],
		["2811","Amortización acumulada de construcciones","28"],
		["2812","Amortización acumulada de instalaciones técnicas","28"],
		["2813","Amortización acumulada de maquinaria","28"],
		["2814","Amortización acumulada de utillaje","28"],
		["2815","Amortización acumulada de otras instalaciones","28"],
		["2816","Amortización acumulada de mobiliario","28"],
		["2817","Amortización acumulada de equipos para procesos de información","28"],
		["2818","Amortización acumulada de elementos de transporte","28"],
		["2819","Amortización acumulada de otro inmovilizado material","28"],
		["282","Amortización acumulada de las inversiones inmobiliarias","28"],
		["2900","Deterioro de valor de investigación","29"],
		["2901","Deterioro del valor de desarrollo","29"],
		["2902","Deterioro de valor de concesiones administrativas","29"],
		["2903","Deterioro de valor de propiedad industrial","29"],
		["2905","Deterioro de valor de derechos de traspaso","29"],
		["2906","Deterioro de valor de aplicaciones informáticas","29"],
		["2910","Deterioro de valor de terrenos y bienes naturales","29"],
		["2911","Deterioro de valor de construcciones","29"],
		["2912","Deterioro de valor de instalaciones técnicas","29"],
		["2913","Deterioro de valor de maquinaria","29"],
		["2914","Deterioro de valor de utillaje","29"],
		["2915","Deterioro de valor de otras instalaciones","29"],
		["2916","Deterioro de valor de mobiliario","29"],
		["2917","Deterioro de valor de equipos para procesos de información","29"],
		["2918","Deterioro de valor de elementos de transporte","29"],
		["2919","Deterioro de valor de otro inmovilizado material","29"],
		["2920","Deterioro de valor de los terrenos y bienes naturales","29"],
		["2921","Deterioro de valor de construcciones","29"],
		["2933","Deterioro de valor de participaciones a largo plazo en empresas del grupo","29"],
		["2934","Deterioro de valor de participaciones a largo plazo en empresas asociadas","29"],
		["2943","Deterioro de valor de valores representativos de deuda a largo plazo de empresas del grupo","29"],
		["2944","Deterioro de valor de valores representativos de deuda a largo plazo de empresas asociadas","29"],
		["2945","Deterioro de valor de valores representativos de deuda a largo plazo de otras partes vinculadas","29"],
		["2953","Deterioro de valor de créditos a largo plazo a empresas del grupo","29"],
		["2954","Deterioro de valor de créditos a largo plazo a empresas asociadas","29"],
		["2955","Deterioro de valor de créditos a largo plazo a otras partes vinculadas","29"],
		["297","Deterioro de valor de valores representativos de deuda a largo plazo","29"],
		["298","Deterioro de valor de créditos a largo plazo","29"],
		["300","Mercaderías a","30"],
		["301","Mercaderías b","30"],
		["310","Materias primas a","31"],
		["311","Materias primas b","31"],
		["320","Elementos y conjuntos incorporables","32"],
		["321","Combustibles","32"],
		["322","Repuestos","32"],
		["325","Materiales diversos","32"],
		["326","Embalajes","32"],
		["327","Envases","32"],
		["328","Material de oficina","32"],
		["330","Productos en curso a","33"],
		["331","Productos en curso b","33"],
		["340","Productos semiterminados a","34"],
		["341","Productos semiterminados b","34"],
		["350","Productos terminados a","35"],
		["351","Productos terminados b","35"],
		["360","Subproductos a","36"],
		["361","Subproductos b","36"],
		["365","Residuos a","36"],
		["366","Residuos b","36"],
		["368","Materiales recuperados a","36"],
		["369","Materiales recuperados b","36"],
		["390","Deterioro de valor de las mercaderías","39"],
		["391","Deterioro de valor de las materias primas","39"],
		["392","Deterioro de valor de otros aprovisionamientos","39"],
		["393","Deterioro de valor de los productos en curso","39"],
		["394","Deterioro de valor de los productos semiterminados","39"],
		["395","Deterioro de valor de los productos terminados","39"],
		["396","Deterioro de valor de los subproductos, residuos y materiales recuperados","39"],
		["400","Proveedores","40"],
		["4000","Proveedores (euros)","40"],
		["4004","Proveedores (moneda extranjera)","40"],
		["4009","Proveedores, facturas pendientes de recibir o de formalizar","40"],
		["401","Proveedores, efectos comerciales a pagar","40"],
		["4030","Proveedores, empresas del grupo (euros)","40"],
		["4031","Efectos comerciales a pagar, empresas del grupo","40"],
		["4034","Proveedores, empresas del grupo (moneda extranjera)","40"],
		["4036","Envases y embalajes a devolver a proveedores, empresas del grupo","40"],
		["4039","Proveedores, empresas del grupo, facturas pendientes de recibir o de formalizar","40"],
		["404","Proveedores, empresas asociadas","40"],
		["405","Proveedores, otras partes vinculadas","40"],
		["406","Envases y embalajes a devolver a proveedores","40"],
		["407","Anticipos a proveedores","40"],
		["410","Acreedores","41"],
		["4100","Acreedores por prestaciones de servicios (euros)","41"],
		["4104","Acreedores por prestaciones de servicios, (moneda extranjera)","41"],
		["4109","Acreedores por prestaciones de servicios, facturas pendientes de recibir o de formalizar","41"],
		["411","Acreedores, efectos comerciales a pagar","41"],
		["419","Acreedores por operaciones en común","41"],
		["430","Clientes","43"],
		["4300","Clientes (euros)","43"],
		["4304","Clientes (moneda extranjera)","43"],
		["4309","Clientes, facturas pendientes de formalizar","43"],
		["4310","Efectos comerciales en cartera","43"],
		["4311","Efectos comerciales descontados","43"],
		["4312","Efectos comerciales en gestión de cobro","43"],
		["4315","Efectos comerciales impagados","43"],
		["432","Clientes, operaciones de factoring","43"],
		["4330","Clientes empresas del grupo (euros)","43"],
		["4331","Efectos comerciales a cobrar, empresas del grupo","43"],
		["4332","Clientes empresas del grupo, operaciones de factoring","43"],
		["4334","Clientes empresas del grupo (moneda extranjera)","43"],
		["4336","Clientes empresas del grupo de dudoso cobro","43"],
		["4337","Envases y embalajes a devolver a clientes, empresas del grupo","43"],
		["4339","Clientes empresas del grupo, facturas pendientes de formalizar","43"],
		["434","Clientes, empresas asociadas","43"],
		["435","Clientes, otras partes vinculadas","43"],
		["436","Clientes de dudoso cobro","43"],
		["437","Envases y embalajes a devolver por clientes","43"],
		["438","Anticipos de clientes","43"],
		["4400","Deudores (euros)","44"],
		["4404","Deudores (moneda extranjera)","44"],
		["4409","Deudores, facturas pendientes de formalizar","44"],
		["4410","Deudores, efectos comerciales en cartera","44"],
		["4411","Deudores, efectos comerciales descontados","44"],
		["4412","Deudores, efectos comerciales en gestión de cobro","44"],
		["4415","Deudores, efectos comerciales impagados","44"],
		["446","Deudores de dudoso cobro","44"],
		["449","Deudores por operaciones en común","44"],
		["460","Anticipos de remuneraciones","46"],
		["465","Remuneraciones pendientes de pago","46"],
		["466","Remuneraciones mediante sistemas de aportación definida pendientes de pago","46"],
		["4700","Hacienda pública, deudora por iva","47"],
		["4708","Hacienda pública, deudora por subvenciones concedidas","47"],
		["4709","Hacienda pública, deudora por devolución de impuestos","47"],
		["471","Organismos de la seguridad social, deudores","47"],
		["472","Hacienda pública, iva soportado","47"],
		["473","Hacienda pública, retenciones y pagos a cuenta","47"],
		["4740","Activos por diferencias temporarias deducibles","47"],
		["4742","Derechos por deducciones y bonificaciones pendientes de aplicar","47"],
		["4745","Crédito por pérdidas a compensar del ejercicio","47"],
		["4750","Hacienda pública, acreedora por iva","47"],
		["4751","Hacienda pública, acreedora por retenciones practicadas","47"],
		["4752","Hacienda pública, acreedora por impuesto sobre sociedades","47"],
		["4758","Hacienda pública, acreedora por subvenciones a reintegrar","47"],
		["476","Organismos de la seguridad social, acreedores","47"],
		["477","Hacienda pública, iva repercutido","47"],
		["479","Pasivos por diferencias temporarias imponibles","47"],
		["480","Gastos anticipados","48"],
		["485","Ingresos anticipados","48"],
		["490","Deterioro de valor de créditos por operaciones comerciales","49"],
		["4933","Deterioro de valor de créditos por operaciones comerciales con empresas del grupo","49"],
		["4934","Deterioro de valor de créditos por operaciones comerciales con empresas asociadas","49"],
		["4935","Deterioro de valor de créditos por operaciones comerciales con otras partes vinculadas","49"],
		["4994","Provisión por contratos onerosos","49"],
		["4999","Provisión para otras operaciones comerciales","49"],
		["500","Obligaciones y bonos a corto plazo","50"],
		["501","Obligaciones y bonos convertibles a corto plazo","50"],
		["502","Acciones o participaciones a corto plazo consideradas como pasivos financieros","50"],
		["505","Deudas representadas en otros valores negociables a corto plazo","50"],
		["506","Intereses a corto plazo de empréstitos y otras emisiones análogas","50"],
		["507","Dividendos de acciones o participaciones consideradas como pasivos financieros","50"],
		["5090","Obligaciones y bonos amortizados","50"],
		["5091","Obligaciones y bonos convertibles amortizados","50"],
		["5095","Otros valores negociables amortizados","50"],
		["5103","Deudas a corto plazo con entidades de crédito, empresas del grupo","51"],
		["5104","Deudas a corto plazo con entidades de crédito, empresas asociadas","51"],
		["5105","Deudas a corto plazo con otras entidades de crédito vinculadas","51"],
		["5113","Proveedores de inmovilizado a corto plazo, empresas del grupo","51"],
		["5114","Proveedores de inmovilizado a corto plazo, empresas asociadas","51"],
		["5115","Proveedores de inmovilizado a corto plazo, otras partes vinculadas","51"],
		["5123","Acreedores por arrendamiento financiero a corto plazo, empresas del grupo","51"],
		["5124","Acreedores por arrendamiento financiero a corto plazo, empresas asociadas","51"],
		["5125","Acreedores por arrendamiento financiero a corto plazo, otras partes vinculadas","51"],
		["5133","Otras deudas a corto plazo con empresas del grupo","51"],
		["5134","Otras deudas a corto plazo con empresas asociadas","51"],
		["5135","Otras deudas a corto plazo con otras partes vinculadas","51"],
		["5143","Intereses a corto plazo de deudas, empresas del grupo","51"],
		["5144","Intereses a corto plazo de deudas, empresas asociadas","51"],
		["5145","Intereses a corto plazo de deudas, otras partes vinculadas","51"],
		["5200","Préstamos a corto plazo de entidades de crédito","52"],
		["5201","Deudas a corto plazo por crédito dispuesto","52"],
		["5208","Deudas por efectos descontados","52"],
		["5209","Deudas por operaciones de factoring","52"],
		["521","Deudas a corto plazo","52"],
		["522","Deudas a corto plazo transformables en subvenciones, donaciones y legados","52"],
		["523","Proveedores de inmovilizado a corto plazo","52"],
		["524","Acreedores por arrendamiento financiero a corto plazo","52"],
		["525","Efectos a pagar a corto plazo","52"],
		["526","Dividendo activo a pagar","52"],
		["527","Intereses a corto plazo de deudas con entidades de crédito","52"],
		["528","Intereses a corto plazo de deudas","52"],
		["5290","Provisión a corto plazo por retribuciones al personal","52"],
		["5291","Provisión a corto plazo para impuestos","52"],
		["5292","Provisión a corto plazo para otras responsabilidades","52"],
		["5293","Provisión a corto plazo por desmantelamiento, retiro o rehabilitación del inmovilizado","52"],
		["5295","Provisión a corto plazo para actuaciones medioambientales","52"],
		["5296","Provisión a corto plazo para reestructuraciones","52"],
		["5297","Provisión a corto plazo por transacciones con pagos basados en instrumentos de patrimonio","52"],
		["5303","Participaciones a corto plazo, en empresas del grupo","53"],
		["5304","Participaciones a corto plazo, en empresas asociadas","53"],
		["5305","Participaciones a corto plazo, en otras partes vinculadas","53"],
		["5313","Valores representativos de deuda a corto plazo de empresas del grupo","53"],
		["5314","Valores representativos de deuda a corto plazo de empresas asociadas","53"],
		["5315","Valores representativos de deuda a corto plazo de otras partes vinculadas","53"],
		["5323","Créditos a corto plazo a empresas del grupo","53"],
		["5324","Créditos a corto plazo a empresas asociadas","53"],
		["5325","Créditos a corto plazo a otras partes vinculadas","53"],
		["5333","Intereses a corto plazo de valores representativos de deuda de empresas del grupo","53"],
		["5334","Intereses a corto plazo de valores representativos de deuda de empresas asociadas","53"],
		["5335","Intereses a corto plazo de valores representativos de deuda de otras partes vinculadas","53"],
		["5343","Intereses a corto plazo de créditos a empresas del grupo","53"],
		["5344","Intereses a corto plazo de créditos a empresas asociadas","53"],
		["5345","Intereses a corto plazo de créditos a otras partes vinculadas","53"],
		["5353","Dividendo a cobrar de empresas de grupo","53"],
		["5354","Dividendo a cobrar de empresas asociadas","53"],
		["5355","Dividendo a cobrar de otras partes vinculadas","53"],
		["5393","Desembolsos pendientes sobre participaciones a corto plazo en empresas del grupo.","53"],
		["5394","Desembolsos pendientes sobre participaciones a corto plazo en empresas asociadas.","53"],
		["5395","Desembolsos pendientes sobre participaciones a corto plazo en otras partes vinculadas","53"],
		["540","Inversiones financieras a corto plazo en instrumentos de patrimonio","54"],
		["541","Valores representativos de deuda a corto plazo","54"],
		["542","Créditos a corto plazo","54"],
		["543","Créditos a corto plazo por enajenación de inmovilizado","54"],
		["544","Créditos a corto plazo al personal","54"],
		["545","Dividendo a cobrar","54"],
		["546","Intereses a corto plazo de valores representativos de deudas","54"],
		["547","Intereses a corto plazo de créditos","54"],
		["548","Imposiciones a corto plazo","54"],
		["549","Desembolsos pendientes sobre participaciones en el patrimonio neto a corto plazo","54"],
		["550","Titular de la explotación","55"],
		["551","Cuenta corriente con socios y administradores","55"],
		["5523","Cuenta corriente con empresas del grupo","55"],
		["5524","Cuenta corriente con empresas asociadas","55"],
		["5525","Cuenta corriente con otras partes vinculadas","55"],
		["5530","Socios de sociedad disuelta","55"],
		["5531","Socios, cuenta de fusión","55"],
		["5532","Socios de sociedad escindida","55"],
		["5533","Socios, cuenta de escisión","55"],
		["554","Cuenta corriente con uniones temporales de empresas y comunidades de bienes","55"],
		["555","Partidas pendientes de aplicación","55"],
		["5563","Desembolsos exigidos sobre participaciones, empresas del grupo","55"],
		["5564","Desembolsos exigidos sobre participaciones, empresas asociadas","55"],
		["5565","Desembolsos exigidos sobre participaciones, otras partes vinculadas","55"],
		["5566","Desembolsos exigidos sobre participaciones de otras empresas","55"],
		["557","Dividendo activo a cuenta","55"],
		["5580","Socios por desembolsos exigidos sobre acciones o participaciones ordinarias","55"],
		["5585","Socios por desembolsos exigidos sobre acciones o participaciones consideradas como pasivos financieros","55"],
		["5590","Activos por derivados financieros a corto plazo, cartera de negociación","55"],
		["5593","Activos por derivados financieros a corto plazo, instrumentos de cobertura","55"],
		["5595","Pasivos por derivados financieros a corto plazo, cartera de negociación","55"],
		["5598","Pasivos por derivados financieros a corto plazo, instrumentos de cobertura","55"],
		["560","Fianzas recibidas a corto plazo","56"],
		["561","Depósitos recibidos a corto plazo","56"],
		["565","Fianzas constituidas a corto plazo","56"],
		["566","Depósitos constituidos a corto plazo","56"],
		["567","Intereses pagados por anticipado","56"],
		["568","Intereses cobrados por anticipado","56"],
		["569","Garantías financieras a corto plazo","56"],
		["570","Caja, euros","57"],
		["571","Caja, moneda extranjera","57"],
		["572","Bancos e instituciones de crédito c/c vista, euros","57"],
		["573","Bancos e instituciones de crédito c/c vista, moneda extranjera","57"],
		["574","Bancos e instituciones de crédito, cuentas de ahorro, euros","57"],
		["575","Bancos e instituciones de crédito, cuentas de ahorro, moneda extranjera","57"],
		["576","Inversiones a corto plazo de gran liquidez","57"],
		["580","Inmovilizado","58"],
		["581","Inversiones con personas y entidades vinculadas","58"],
		["582","Inversiones financieras","58"],
		["583","Existencias, deudores comerciales y otras cuentas a cobrar","58"],
		["584","Otros activos","58"],
		["585","Provisiones","58"],
		["586","Deudas con características especiales","58"],
		["587","Deudas con personas y entidades vinculadas","58"],
		["588","Acreedores comerciales y otras cuentas a pagar","58"],
		["589","Otros pasivos","58"],
		["5933","Deterioro de valor de participaciones a corto plazo en empresas del grupo","59"],
		["5934","Deterioro de valor de participaciones a corto plazo en empresas asociadas","59"],
		["5943","Deterioro de valor de valores representativos de deuda a corto plazo de empresas del grupo","59"],
		["5944","Deterioro de valor de valores representativos de deuda a corto plazo de empresas asociadas","59"],
		["5945","Deterioro de valor de valores representativos de deuda a corto plazo de otras partes vinculadas","59"],
		["5953","Deterioro de valor de créditos a corto plazo a empresas del grupo","59"],
		["5954","Deterioro de valor de créditos a corto plazo a empresas asociadas","59"],
		["5955","Deterioro de valor de créditos a corto plazo a otras partes vinculadas","59"],
		["597","Deterioro de valor de valores representativos de deuda a corto plazo","59"],
		["598","Deterioro de valor de créditos a corto plazo","59"],
		["5990","Deterioro de valor de inmovilizado no corriente mantenido para la venta","59"],
		["5991","Deterioro de valor de inversiones con personas y entidades vinculadas no corrientes mantenidas para la venta","59"],
		["5992","Deterioro de valor de inversiones financieras no corrientes mantenidas para la venta","59"],
		["5993","Deterioro de valor de existencias, deudores comerciales y otras cuentas a cobrar integrados en un grupo enajenable mantenido para la venta","59"],
		["5994","Deterioro de valor de otros activos mantenidos para la venta","59"],
		["600","Compras de mercaderías","60"],
		["601","Compras de materias primas","60"],
		["602","Compras de otros aprovisionamientos","60"],
		["6060","Descuentos sobre compras por pronto pago de mercaderías","60"],
		["6061","Descuentos sobre compras por pronto pago de materias primas","60"],
		["6062","Descuentos sobre compras por pronto pago de otros aprovisionamientos","60"],
		["607","Trabajos realizados por otras empresas","60"],
		["6080","Devoluciones de compras de mercaderías","60"],
		["6081","Devoluciones de compras de materias primas","60"],
		["6082","Devoluciones de compras de otros aprovisionamientos","60"],
		["6090","Rappels por compras de mercaderías","60"],
		["6091","Rappels por compras de materias primas","60"],
		["6092","Rappels por compras de otros aprovisionamientos","60"],
		["610","Variación de existencias de mercaderías","61"],
		["611","Variación de existencias de materias primas","61"],
		["612","Variación de existencias de otros aprovisionamientos","61"],
		["620","Gastos en investigación y desarrollo del ejercicio","62"],
		["621","Arrendamientos y cánones","62"],
		["622","Reparaciones y conservación","62"],
		["623","Servicios de profesionales independientes","62"],
		["624","Transportes","62"],
		["625","Primas de seguros","62"],
		["626","Servicios bancarios y similares","62"],
		["627","Publicidad, propaganda y relaciones públicas","62"],
		["628","Suministros","62"],
		["629","Otros servicios","62"],
		["6300","Impuesto corriente","63"],
		["6301","Impuesto diferido","63"],
		["631","Otros tributos","63"],
		["633","Ajustes negativos en la imposición sobre beneficios","63"],
		["6341","Ajustes negativos en iva de activo corriente","63"],
		["6342","Ajustes negativos en iva de inversiones","63"],
		["636","Devolución de impuestos","63"],
		["638","Ajustes positivos en la imposición sobre beneficios","63"],
		["6391","Ajustes positivos en iva de activo corriente","63"],
		["6392","Ajustes positivos en iva de inversiones","63"],
		["640","Sueldos y salarios","64"],
		["641","Indemnizaciones","64"],
		["642","Seguridad social a cargo de la empresa","64"],
		["643","Retribuciones a largo plazo mediante sistemas de aportación definida","64"],
		["6440","Contribuciones anuales","64"],
		["6442","Otros costes","64"],
		["6450","Retribuciones al personal liquidados con instrumentos de patrimonio","64"],
		["6457","Retribuciones al personal liquidados en efectivo basado en instrumentos de patrimonio","64"],
		["649","Otros gastos sociales","64"],
		["650","Pérdidas de créditos comerciales incobrables","65"],
		["6510","Beneficio transferido (gestor)","65"],
		["6511","Pérdida soportada (partícipe o asociado no gestor)","65"],
		["659","Otras pérdidas en gestión corriente","65"],
		["660","Gastos financieros por actualización de provisiones","66"],
		["6610","Intereses de obligaciones y bonos a largo plazo, empresas del grupo","66"],
		["6611","Intereses de obligaciones y bonos a largo plazo, empresas asociadas","66"],
		["6612","Intereses de obligaciones y bonos a largo plazo, otras partes vinculadas","66"],
		["6613","Intereses de obligaciones y bonos a largo plazo, otras empresas","66"],
		["6615","Intereses de obligaciones y bonos a corto plazo, empresas del grupo","66"],
		["6616","Intereses de obligaciones y bonos a corto plazo, empresas asociadas","66"],
		["6617","Intereses de obligaciones y bonos a corto plazo, otras partes vinculadas","66"],
		["6618","Intereses de obligaciones y bonos a corto plazo, otras empresas","66"],
		["6620","Intereses de deudas, empresas del grupo","66"],
		["6621","Intereses de deudas, empresas asociadas","66"],
		["6622","Intereses de deudas, otras partes vinculadas","66"],
		["6623","Intereses de deudas con entidades de crédito","66"],
		["6624","Intereses de deudas, otras empresas","66"],
		["6630","Pérdidas de cartera de negociación","66"],
		["6631","Pérdidas de designados por la empresa","66"],
		["6632","Pérdidas de disponibles para la venta","66"],
		["6633","Pérdidas de instrumentos de cobertura","66"],
		["6640","Dividendos de pasivos, empresas del grupo","66"],
		["6641","Dividendos de pasivos, empresas asociadas","66"],
		["6642","Dividendos de pasivos, otras partes vinculadas","66"],
		["6643","Dividendos de pasivos, otras empresas","66"],
		["6650","Intereses por descuento de efectos en entidades de crédito del grupo","66"],
		["6651","Intereses por descuento de efectos en entidades de crédito asociadas","66"],
		["6652","Intereses por descuento de efectos en otras entidades de crédito vinculadas","66"],
		["6653","Intereses por descuento de efectos en otras entidades de crédito","66"],
		["6654","Intereses por operaciones de factoring con entidades de crédito del grupo","66"],
		["6655","Intereses por operaciones de factoring con entidades de crédito asociadas","66"],
		["6656","Intereses por operaciones de factoring con otras entidades de crédito vinculadas","66"],
		["6657","Intereses por operaciones de factoring con otras entidades de crédito","66"],
		["6660","Pérdidas en valores representativos de deuda a largo plazo, empresas del grupo","66"],
		["6661","Pérdidas en valores representativos de deuda a largo plazo, empresas asociadas","66"],
		["6662","Pérdidas en valores representativos de deuda a largo plazo, otras partes vinculadas","66"],
		["6663","Pérdidas en participaciones y valores representativos de deuda a largo plazo, otras empresas","66"],
		["6665","Pérdidas en participaciones y valores representativos de deuda a corto plazo, empresas del grupo","66"],
		["6666","Pérdidas en participaciones y valores representativos de deuda a corto plazo, empresas asociadas","66"],
		["6667","Pérdidas en valores representativos de deuda a corto plazo, otras partes vinculadas","66"],
		["6668","Pérdidas en valores representativos de deuda a corto plazo, otras empresas","66"],
		["6670","Pérdidas de créditos a largo plazo, empresas del grupo","66"],
		["6671","Pérdidas de créditos a largo plazo, empresas asociadas","66"],
		["6672","Pérdidas de créditos a largo plazo, otras partes vinculadas","66"],
		["6673","Pérdidas de créditos a largo plazo, otras empresas","66"],
		["6675","Pérdidas de créditos a corto plazo, empresas del grupo","66"],
		["6676","Pérdidas de créditos a corto plazo, empresas asociadas","66"],
		["6677","Pérdidas de créditos a corto plazo, otras partes vinculadas","66"],
		["6678","Pérdidas de créditos a corto plazo, otras empresas","66"],
		["668","Diferencias negativas de cambio","66"],
		["669","Otros gastos financieros","66"],
		["670","Pérdidas procedentes del inmovilizado intangible","67"],
		["671","Pérdidas procedentes del inmovilizado material","67"],
		["672","Pérdidas procedentes de las inversiones inmobiliarias","67"],
		["6733","Pérdidas procedentes de participaciones a largo plazo, empresas del grupo","67"],
		["6734","Pérdidas procedentes de participaciones a largo plazo, empresas asociadas","67"],
		["6735","Pérdidas procedentes de participaciones a largo plazo, otras partes vinculadas","67"],
		["675","Pérdidas por operaciones con obligaciones propias","67"],
		["678","Gastos excepcionales","67"],
		["680","Amortización del inmovilizado intangible","68"],
		["681","Amortización del inmovilizado material","68"],
		["682","Amortización de las inversiones inmobiliarias","68"],
		["690","Pérdidas por deterioro del inmovilizado intangible","69"],
		["691","Pérdidas por deterioro del inmovilizado material","69"],
		["692","Pérdidas por deterioro de las inversiones inmobiliarias","69"],
		["6930","Pérdidas por deterioro de productos terminados y en curso de fabricación","69"],
		["6931","Pérdidas por deterioro de mercaderías","69"],
		["6932","Pérdidas por deterioro de materias primas","69"],
		["6933","Pérdidas por deterioro de otros aprovisionamientos","69"],
		["694","Pérdidas por deterioro de créditos por operaciones comerciales","69"],
		["6954","Dotación a la provisión por contratos onerosos","69"],
		["6959","Dotación a la provisión para otras operaciones comerciales","69"],
		["6960","Pérdidas por deterioro de participaciones en instrumentos de patrimonio neto a largo plazo, empresas del grupo","69"],
		["6961","Pérdidas por deterioro de participaciones en instrumentos de patrimonio neto a largo plazo, empresas asociadas","69"],
		["6962","Pérdidas por deterioro de participaciones en instrumentos de patrimonio neto a largo plazo, otras partes vinculadas","69"],
		["6963","Pérdidas por deterioro de participaciones en instrumentos de patrimonio neto a largo plazo, otras empresas","69"],
		["6965","Pérdidas por deterioro en valores representativos de deuda a largo plazo, empresas del grupo","69"],
		["6966","Pérdidas por deterioro en valores representativos de deuda a largo plazo, empresas asociadas","69"],
		["6967","Pérdidas por deterioro en valores representativos de deuda a largo plazo, otras partes vinculadas","69"],
		["6968","Pérdidas por deterioro en valores representativos de deuda a largo plazo, de otras empresas","69"],
		["6970","Pérdidas por deterioro de créditos a largo plazo, empresas del grupo","69"],
		["6971","Pérdidas por deterioro de créditos a largo plazo, empresas asociadas","69"],
		["6972","Pérdidas por deterioro de créditos a largo plazo, otras partes vinculadas","69"],
		["6973","Pérdidas por deterioro de créditos a largo plazo, otras empresas","69"],
		["6980","Pérdidas por deterioro de participaciones en instrumentos de patrimonio neto a corto plazo, empresas del grupo","69"],
		["6981","Pérdidas por deterioro de participaciones en instrumentos de patrimonio neto a corto plazo, empresas asociadas","69"],
		["6985","Pérdidas por deterioro en valores representativos de deuda a corto plazo, empresas del grupo","69"],
		["6986","Pérdidas por deterioro en valores representativos de deuda a corto plazo, empresas asociadas","69"],
		["6987","Pérdidas por deterioro en valores representativos de deuda a corto plazo, otras partes vinculadas","69"],
		["6988","Pérdidas por deterioro en valores representativos de deuda a corto plazo, de otras empresas","69"],
		["6990","Pérdidas por deterioro de créditos a corto plazo, empresas del grupo","69"],
		["6991","Pérdidas por deterioro de créditos a corto plazo, empresas asociadas","69"],
		["6992","Pérdidas por deterioro de créditos a corto plazo, otras partes vinculadas","69"],
		["6993","Pérdidas por deterioro de créditos a corto plazo, otras empresas","69"],
		["700","Ventas de mercaderías","70"],
		["701","Ventas de productos terminados","70"],
		["702","Ventas de productos semiterminados","70"],
		["703","Ventas de subproductos y residuos","70"],
		["704","Ventas de envases y embalajes","70"],
		["705","Prestaciones de servicios","70"],
		["7060","Descuentos sobre ventas por pronto pago de mercaderías","70"],
		["7061","Descuentos sobre ventas por pronto pago de productos terminados","70"],
		["7062","Descuentos sobre ventas por pronto pago de productos semiterminados","70"],
		["7063","Descuentos sobre ventas por pronto pago de subproductos y residuos","70"],
		["7080","Devoluciones de ventas de mercaderías","70"],
		["7081","Devoluciones de ventas de productos terminados","70"],
		["7082","Devoluciones de ventas de productos semiterminados","70"],
		["7083","Devoluciones de ventas de subproductos y residuos","70"],
		["7084","Devoluciones de ventas de envases y embalajes","70"],
		["7090","Rappels sobre ventas de mercaderías","70"],
		["7091","Rappels sobre ventas de productos terminados","70"],
		["7092","Rappels sobre ventas de productos semiterminados","70"],
		["7093","Rappels sobre ventas de subproductos y residuos","70"],
		["7094","Rappels sobre ventas de envases y embalajes","70"],
		["710","Variación de existencias de productos en curso","71"],
		["711","Variación de existencias de productos semiterminados","71"],
		["712","Variación de existencias de productos terminados","71"],
		["713","Variación de existencias de subproductos,residuos y materiales recuperados","71"],
		["730","Trabajos realizados para el inmovilizado intangible","73"],
		["731","Trabajos realizados para el inmovilizado material","73"],
		["732","Trabajos realizados en inversiones inmobiliarias","73"],
		["733","Trabajos realizados para el inmovilizado material en curso","73"],
		["740","Subvenciones, donaciones y legados a la explotación","74"],
		["746","Subvenciones, donaciones y legados de capital transferidos al resultado del ejercicio","74"],
		["747","Otras subvenciones, donaciones y legados transferidos al resultado del ejercicio","74"],
		["7510","Pérdida transferida (gestor)","75"],
		["7511","Beneficio atribuido (partícipe o asociado no gestor)","75"],
		["752","Ingresos por arrendamientos","75"],
		["753","Ingresos de propiedad industrial cedida en explotación","75"],
		["754","Ingresos por comisiones","75"],
		["755","Ingresos por servicios al personal","75"],
		["759","Ingresos por servicios diversos","75"],
		["7600","Ingresos de participaciones en instrumentos de patrimonio, empresas del grupo","76"],
		["7601","Ingresos de participaciones en instrumentos de patrimonio, empresas asociadas","76"],
		["7602","Ingresos de participaciones en instrumentos de patrimonio, otras partes vinculadas","76"],
		["7603","Ingresos de participaciones en instrumentos de patrimonio, otras empresas","76"],
		["7610","Ingresos de valores representativos de deuda, empresas del grupo","76"],
		["7611","Ingresos de valores representativos de deuda, empresas asociadas","76"],
		["7612","Ingresos de valores representativos de deuda, otras partes vinculadas","76"],
		["7613","Ingresos de valores representativos de deuda, otras empresas","76"],
		["76200","Ingresos de créditos a largo plazo, empresas del grupo","76"],
		["76201","Ingresos de créditos a largo plazo, empresas asociadas","76"],
		["76202","Ingresos de créditos a largo plazo, otras partes vinculadas","76"],
		["76203","Ingresos de créditos a largo plazo, otras empresas","76"],
		["76210","Ingresos de créditos a corto plazo, empresas del grupo","76"],
		["76211","Ingresos de créditos a corto plazo, empresas asociadas","76"],
		["76212","Ingresos de créditos a corto plazo, otras partes vinculadas","76"],
		["76213","Ingresos de créditos a corto plazo, otras empresas","76"],
		["7630","Beneficios de cartera de negociación","76"],
		["7631","Beneficios de designados por la empresa","76"],
		["7632","Beneficios de disponibles para la venta","76"],
		["7633","Beneficios de instrumentos de cobertura","76"],
		["7660","Beneficios en valores representativos de deuda a largo plazo, empresas del grupo","76"],
		["7661","Beneficios en valores representativos de deuda a largo plazo, empresas asociadas","76"],
		["7662","Beneficios en valores representativos de deuda a largo plazo, otras partes vinculadas","76"],
		["7663","Beneficios en participaciones y valores representativos de deuda a largo plazo, otras empresas","76"],
		["7665","Beneficios en participaciones y valores representativos de deuda a corto plazo, empresas del grupo","76"],
		["7666","Beneficios en participaciones y valores representativos de deuda a corto plazo, empresas asociadas","76"],
		["7667","Beneficios en valores representativos de deuda a corto plazo, otras partes vinculadas","76"],
		["7668","Beneficios en valores representativos de deuda a corto plazo, otras empresas","76"],
		["767","Ingresos de activos afectos y de derechos de reembolso relativos a retribuciones a largo plazo","76"],
		["768","Diferencias positivas de cambio","76"],
		["769","Otros ingresos financieros","76"],
		["770","Beneficios procedentes del inmovilizado intangible","77"],
		["771","Beneficios procedentes del inmovilizado material","77"],
		["772","Beneficios procedentes de las inversiones inmobiliarias","77"],
		["7733","Beneficios procedentes de participaciones a largo plazo, empresas del grupo","77"],
		["7734","Beneficios procedentes de participaciones a largo plazo, empresas asociadas","77"],
		["7735","Beneficios procedentes de participaciones a largo plazo, otras partes vinculadas","77"],
		["774","Diferencia negativa en combinaciones de negocios","77"],
		["775","Beneficios por operaciones con obligaciones propias","77"],
		["778","Ingresos excepcionales","77"],
		["790","Reversión del deterioro del inmovilizado intangible","79"],
		["791","Reversión del deterioro del inmovilizado material","79"],
		["792","Reversión del deterioro de las inversiones inmobiliarias","79"],
		["7930","Reversión del deterioro de productos terminados y en curso de fabricación","79"],
		["7931","Reversión del deterioro de mercaderías","79"],
		["7932","Reversión del deterioro de materias primas","79"],
		["7933","Reversión del deterioro de otros aprovisionamientos","79"],
		["794","Reversión del deterioro de créditos por operaciones comerciales","79"],
		["7950","Exceso de provisión por retribuciones al personal","79"],
		["7951","Exceso de provisión para impuestos","79"],
		["7952","Exceso de provisión para otras responsabilidades","79"],
		["79544","Exceso de provisión por contratos onerosos","79"],
		["79549","Exceso de provisión para otras operaciones comerciales","79"],
		["7955","Exceso de provisión para actuaciones medioambientales","79"],
		["7956","Exceso de provisión para reestructuraciones","79"],
		["7957","Exceso de provisión por transacciones con pagos basados en instrumentos de patrimonio","79"],
		["7960","Reversión del deterioro de participaciones en instrumentos de patrimonio neto a largo plazo, empresas del grupo","79"],
		["7961","Reversión del deterioro de participaciones en instrumentos de patrimonio neto a largo plazo, empresas asociadas","79"],
		["7965","Reversión del deterioro de valores representativos de deuda a largo plazo, empresas del grupo","79"],
		["7966","Reversión del deterioro de valores representativos de deuda a largo plazo, empresas asociadas","79"],
		["7967","Reversión del deterioro de valores representativos de deuda a largo plazo, otras partes vinculadas","79"],
		["7968","Reversión del deterioro de valores representativos de deuda a largo plazo, otras empresas","79"],
		["7970","Reversión del deterioro de créditos a largo plazo, empresas del grupo","79"],
		["7971","Reversión del deterioro de créditos a largo plazo, empresas asociadas","79"],
		["7972","Reversión del deterioro de créditos a largo plazo, otras partes vinculadas","79"],
		["7973","Reversión del deterioro de créditos a largo plazo, otras empresas","79"],
		["7980","Reversión del deterioro de participaciones en instrumentos de patrimonio neto a corto plazo, empresas del grupo","79"],
		["7981","Reversión del deterioro de participaciones en instrumentos de patrimonio neto a corto plazo, empresas asociadas","79"],
		["7985","Reversión del deterioro en valores representativos de deuda a corto plazo, empresas del grupo","79"],
		["7986","Reversión del deterioro en valores representativos de deuda a corto plazo, empresas asociadas","79"],
		["7987","Reversión del deterioro en valores representativos de deuda a corto plazo, otras partes vinculadas","79"],
		["7988","Reversión del deterioro en valores representativos de deuda a corto plazo, otras empresas","79"],
		["7990","Reversión del deterioro de créditos a corto plazo, empresas del grupo","79"],
		["7991","Reversión del deterioro de créditos a corto plazo, empresas asociadas","79"],
		["7992","Reversión del deterioro de créditos a corto plazo, otras partes vinculadas","79"],
		["7993","Reversión del deterioro de créditos a corto plazo, otras empresas","79"],
		["800","Pérdidas en activos financieros disponibles para la venta","80"],
		["802","Transferencia de beneficios en activos financieros disponibles para la venta","80"],
		["810","Pérdidas por coberturas de flujos de efectivo","81"],
		["811","Pérdidas por coberturas de inversiones netas en un negocio en el extranjero","81"],
		["812","Transferencia de beneficios por coberturas de flujos de efectivo","81"],
		["813","Transferencia de beneficios por coberturas de inversiones netas en un negocio en el extranjero","81"],
		["820","Diferencias de conversión negativas","82"],
		["821","Transferencia de diferencias de conversión positivas","82"],
		["8300","Impuesto corriente","83"],
		["8301","Impuesto diferido","83"],
		["833","Ajustes negativos en la imposición sobre beneficios","83"],
		["834","Ingresos fiscales por diferencias permanentes","83"],
		["835","Ingresos fiscales por deducciones y bonificaciones","83"],
		["836","Transferencia de diferencias permanentes","83"],
		["837","Transferencia de deducciones y bonificaciones","83"],
		["838","Ajustes positivos en la imposición sobre beneficios","83"],
		["840","Transferencia de subvenciones oficiales de capital","84"],
		["841","Transferencia de donaciones y legados de capital","84"],
		["842","Transferencia de otras subvenciones, donaciones y legados","84"],
		["850","Pérdidas actuariales","85"],
		["851","Ajustes negativos en activos por retribuciones a largo plazo de prestación definida","85"],
		["860","Pérdidas en activos no corrientes y grupos enajenables de elementos mantenidos para la venta","86"],
		["862","Transferencia de beneficios en activos no corrientes y grupos enajenables de elementos mantenidos para la venta","86"],
		["891","Deterioro de participaciones en el patrimonio, empresas del grupo","89"],
		["892","Deterioro de participaciones en el patrimonio, empresas asociadas","89"],
		["900","Beneficios en activos financieros disponibles para la venta","90"],
		["902","Transferencia de pérdidas de activos financieros disponibles para la venta","90"],
		["910","Beneficios por coberturas de flujos de efectivo","91"],
		["911","Beneficios por coberturas de una inversión neta en un negocio en el extranjero","91"],
		["912","Transferencia de pérdidas por coberturas de flujos de efectivo","91"],
		["913","Transferencia de pérdidas por coberturas de una inversión neta en un negocio en el extranjero","91"],
		["920","Diferencias de conversión positivas","92"],
		["921","Transferencia de diferencias de conversión negativas","92"],
		["940","Ingresos de subvenciones oficiales de capital","94"],
		["941","Ingresos de donaciones y legados de capital","94"],
		["942","Ingresos de otras subvenciones, donaciones y legados","94"],
		["950","Ganancias actuariales","95"],
		["951","Ajustes positivos en activos por retribuciones a largo plazo de prestación definida","95"],
		["960","Beneficios en activos no corrientes y grupos enajenables de elementos mantenidos para la venta","96"],
		["962","Transferencia de pérdidas en activos no corrientes y grupos enajenables de elementos mantenidos para la venta","96"],
		["991","Recuperación de ajustes valorativos negativos previos, empresas del grupo","99"],
		["992","Recuperación de ajustes valorativos negativos previos, empresas asociadas","99"],
		["993","Transferencia por deterioro de ajustes valorativos negativos previos, empresas del grupo","99"],
		["994","Transferencia por deterioro de ajustes valorativos negativos previos, empresas asociadas","99"],	];
	return datos;
}


function pgc2008_datosCorrespondencias():Array
{
	var datos:String = [
		["100","100"],
		["1000","100"],
		["1001","100"],
		["1002","100"],
		["1003","100"],
		["101","101"],
		["102","102"],
		["","1030"],
		["","1034"],
		["","1040"],
		["","1044"],
		["110","110"],
		["","111"],
		["111",""],
		["","1110"],
		["","1111"],
		["112","112"],
		["113","114"],
		["114","1140"],
		["","1143"],
		["","115"],
		["115","1144"],
		["116","1141"],
		["117","113"],
		["118","1142"],
		["119","119"],
		["120","120"],
		["121","121"],
		["122","118"],
		["129","129"],
		["130","130"],
		["1300","130"],
		["1301","130"],
		["131","131"],
		["","132"],
		["","133"],
		["","134"],
		["","1340"],
		["","1341"],
		["135",""],
		["","136"],
		["136","135"],
		["","137"],
		["137","1370"],
		["138","1371"],
		["140","140"],
		["141","141"],
		["142","142"],
		["143","143"],
		["144","142"],
		["145","145"],
		["","146"],
		["","147"],
		["","150"],
		["150","177"],
		["1500","177"],
		["1501","177"],
		["1502","177"],
		["1503","177"],
		["1504","177"],
		["1505","177"],
		["151","178"],
		["","153"],
		["","1533"],
		["","1534"],
		["","1535"],
		["","1536"],
		["","154"],
		["","1543"],
		["","1544"],
		["","1545"],
		["","1546"],
		["155","179"],
		["","160"],
		["160","1633"],
		["1600","1633"],
		["","1605"],
		["1608","1633"],
		["1609","1633"],
		["","161"],
		["161","1634"],
		["","1615"],
		["","162"],
		["162","1603"],
		["","1623"],
		["","1624"],
		["","1625"],
		["","163"],
		["163","1604"],
		["","1635"],
		["164","1613"],
		["165","1614"],
		["170","170"],
		["1700","170"],
		["1709","170"],
		["171","171"],
		["172","172"],
		["173","173"],
		["","174"],
		["174","175"],
		["","176"],
		["","1765"],
		["","1768"],
		["180","180"],
		["","181"],
		["185","185"],
		["","189"],
		["","190"],
		["190","103"],
		["191","103"],
		["","192"],
		["192","103"],
		["193","104"],
		["","194"],
		["194","104"],
		["","195"],
		["195","104"],
		["196","103"],
		["","197"],
		["198","108"],
		["","199"],
		["199","109"],
		["200",""],
		["201",""],
		["202",""],
		["210","201"],
		["210","200"],
		["2100","201"],
		["2100","200"],
		["2101","201"],
		["2101","200"],
		["211","202"],
		["212","203"],
		["213","204"],
		["214","205"],
		["215","206"],
		["219","209"],
		["","220"],
		["220","210"],
		["","221"],
		["221","211"],
		["222","212"],
		["223","213"],
		["224","214"],
		["225","215"],
		["226","216"],
		["227","217"],
		["228","218"],
		["229","219"],
		["230","230"],
		["231","231"],
		["232","232"],
		["233","233"],
		["237","237"],
		["239","239"],
		["","240"],
		["240","2403"],
		["","2405"],
		["","241"],
		["241","2404"],
		["","2415"],
		["","242"],
		["242","2413"],
		["","2425"],
		["243","2414"],
		["244","2423"],
		["2448","2423"],
		["245","2424"],
		["246","2423"],
		["247","2424"],
		["248","2493"],
		["","249"],
		["249","2494"],
		["","2495"],
		["250","250"],
		["2500","250"],
		["2501","250"],
		["2502","250"],
		["251","251"],
		["2518","251"],
		["252","252"],
		["253","253"],
		["254","254"],
		["","255"],
		["","2550"],
		["","2553"],
		["256","252"],
		["","257"],
		["257","252"],
		["258","258"],
		["259","259"],
		["260","260"],
		["265","265"],
		["270",""],
		["271",""],
		["272",""],
		["281","280"],
		["2810","2801"],
		["2810","2800"],
		["2811","2802"],
		["2812","2803"],
		["2813","204"],
		["2814","2805"],
		["2815","2806"],
		["2817","281"],
		["2817","280"],
		["","282"],
		["282","281"],
		["2821","2811"],
		["2822","2812"],
		["2823","2813"],
		["2824","2814"],
		["2825","2815"],
		["2826","2816"],
		["2827","2817"],
		["2828","2818"],
		["2829","2819"],
		["","2900"],
		["","2901"],
		["","2902"],
		["","2903"],
		["","2905"],
		["","2906"],
		["291","290"],
		["","2910"],
		["","2911"],
		["","2912"],
		["","2913"],
		["","2914"],
		["","2915"],
		["","2916"],
		["","2917"],
		["","2918"],
		["","2919"],
		["","292"],
		["292","291"],
		["","2920"],
		["","2921"],
		["","293"],
		["293","2943"],
		["293","2933"],
		["2930","2933"],
		["2935","2943"],
		["","294"],
		["294","2944"],
		["294","2934"],
		["2941","2934"],
		["","2945"],
		["2946","2944"],
		["","295"],
		["295","2953"],
		["","2955"],
		["296","2954"],
		["297","297"],
		["298","298"],
		["300","300"],
		["301","301"],
		["310","310"],
		["311","311"],
		["320","320"],
		["321","321"],
		["322","322"],
		["325","325"],
		["326","326"],
		["327","327"],
		["328","328"],
		["330","330"],
		["331","331"],
		["340","340"],
		["341","341"],
		["350","350"],
		["351","351"],
		["360","360"],
		["361","361"],
		["365","365"],
		["366","366"],
		["368","368"],
		["369","369"],
		["390","390"],
		["391","391"],
		["392","392"],
		["393","393"],
		["394","394"],
		["395","395"],
		["396","396"],
		["400","400"],
		["4000","4000"],
		["4004","4004"],
		["4009","4009"],
		["401","401"],
		["402","403"],
		["4020","4030"],
		["4021","4031"],
		["4024","4034"],
		["4026","4036"],
		["4029","4039"],
		["403","404"],
		["","405"],
		["406","406"],
		["407","407"],
		["410","410"],
		["4100","4100"],
		["4104","4104"],
		["4109","4109"],
		["411","411"],
		["419","419"],
		["430","430"],
		["4300","4300"],
		["4301","4304"],
		["4309","4309"],
		["431","431"],
		["4310","4310"],
		["4311","4311"],
		["4312","4312"],
		["4315","4315"],
		["","432"],
		["432","433"],
		["4320","4330"],
		["4321","4331"],
		["4324","4334"],
		["4326","4337"],
		["4329","4339"],
		["433","434"],
		["","4332"],
		["","4336"],
		["","435"],
		["435","436"],
		["436","437"],
		["437","438"],
		["440","440"],
		["4400","4400"],
		["4404","4404"],
		["4409","4409"],
		["441","441"],
		["4410","4410"],
		["4411","4411"],
		["4412","4412"],
		["4415","4415"],
		["445","446"],
		["449","449"],
		["460","460"],
		["465","465"],
		["","466"],
		["470","470"],
		["4700","4700"],
		["4707","470"],
		["4708","4708"],
		["4709","4709"],
		["471","471"],
		["472","472"],
		["4727","472"],
		["473","473"],
		["4732","473"],
		["474","474"],
		["4740","4740"],
		["4741","4740"],
		["4742","4742"],
		["4744","4742"],
		["4745","4745"],
		["4746","4745"],
		["4748","4740"],
		["4749","4745"],
		["475","475"],
		["4750","4750"],
		["4751","4751"],
		["4752","4752"],
		["4757","475"],
		["4758","4758"],
		["476","476"],
		["477","477"],
		["4777","477"],
		["479","479"],
		["4791","479"],
		["4798","479"],
		["480","480"],
		["485","485"],
		["490","490"],
		["","493"],
		["493","4933"],
		["","4935"],
		["494","4934"],
		["","499"],
		["499","4999"],
		["","4994"],
		["500","500"],
		["501","501"],
		["","502"],
		["505","505"],
		["506","506"],
		["","507"],
		["509","509"],
		["5090","5090"],
		["5091","5091"],
		["5095","5095"],
		["","510"],
		["510","5133"],
		["5100","5133"],
		["","5105"],
		["5108","5133"],
		["5109","5133"],
		["","511"],
		["511","5134"],
		["","5115"],
		["","512"],
		["512","5103"],
		["5120","5103"],
		["","5123"],
		["","5124"],
		["","5125"],
		["5128","5103"],
		["5129","5103"],
		["","513"],
		["513","5104"],
		["","5135"],
		["","514"],
		["514","5113"],
		["","5145"],
		["515","5114"],
		["516","5143"],
		["517","5144"],
		["520","520"],
		["5200","5200"],
		["5201","5201"],
		["5208","5208"],
		["","5209"],
		["521","521"],
		["","522"],
		["523","523"],
		["","524"],
		["524","525"],
		["525","526"],
		["526","527"],
		["527","528"],
		["","529"],
		["","5290"],
		["","5291"],
		["","5292"],
		["","5293"],
		["","5295"],
		["","5296"],
		["","5297"],
		["","530"],
		["530","5303"],
		["","5305"],
		["","531"],
		["531","5304"],
		["","5315"],
		["","532"],
		["532","5313"],
		["","5325"],
		["","533"],
		["533","5314"],
		["","5335"],
		["","534"],
		["534","5323"],
		["","5344"],
		["","5345"],
		["5348","5323"],
		["","535"],
		["535","5324"],
		["","5353"],
		["","5354"],
		["","5355"],
		["536","5333"],
		["5360","5333"],
		["5361","5343"],
		["537","5334"],
		["538","5393"],
		["","539"],
		["539","5394"],
		["","5395"],
		["540","540"],
		["5400","540"],
		["5401","540"],
		["5409","540"],
		["541","541"],
		["5418","541"],
		["542","542"],
		["543","543"],
		["544","544"],
		["545","545"],
		["546","546"],
		["547","547"],
		["548","548"],
		["549","549"],
		["550","550"],
		["551","5523"],
		["","552"],
		["552","5524"],
		["","5525"],
		["","553"],
		["553","551"],
		["","5530"],
		["","5531"],
		["","5532"],
		["","5533"],
		["","554"],
		["555","555"],
		["556","556"],
		["5560","5563"],
		["5561","5564"],
		["5562","5566"],
		["","5565"],
		["557","557"],
		["558","558"],
		["","5580"],
		["","5585"],
		["","559"],
		["","5590"],
		["","5593"],
		["","5595"],
		["","5598"],
		["560","560"],
		["561","561"],
		["565","565"],
		["566","566"],
		["","569"],
		["570","570"],
		["571","571"],
		["572","572"],
		["573","573"],
		["574","574"],
		["575","575"],
		["","576"],
		["","580"],
		["580","567"],
		["","581"],
		["","582"],
		["","583"],
		["","584"],
		["","585"],
		["585","568"],
		["","586"],
		["","587"],
		["","588"],
		["","589"],
		["","593"],
		["593","5943"],
		["593","5933"],
		["","594"],
		["594","5944"],
		["594","5934"],
		["","5945"],
		["","595"],
		["595","5953"],
		["","5955"],
		["596","5954"],
		["597","597"],
		["598","598"],
		["","599"],
		["","5990"],
		["","5991"],
		["","5992"],
		["","5993"],
		["","5994"],
		["600","600"],
		["601","601"],
		["602","602"],
		["","6060"],
		["","6061"],
		["","6062"],
		["607","607"],
		["608","608"],
		["6080","6080"],
		["6081","6081"],
		["6082","6082"],
		["609","609"],
		["6090","6090"],
		["6091","6091"],
		["6092","6092"],
		["610","610"],
		["611","611"],
		["612","612"],
		["620","620"],
		["621","621"],
		["6210","621"],
		["6211","621"],
		["622","622"],
		["6220","622"],
		["6223","622"],
		["623","623"],
		["6230","623"],
		["6233","623"],
		["624","624"],
		["625","625"],
		["626","626"],
		["627","627"],
		["628","628"],
		["629","629"],
		["630","630"],
		["","6300"],
		["6300","630"],
		["","6301"],
		["6301","630"],
		["631","631"],
		["632","631"],
		["6320","631"],
		["6321","631"],
		["6323","633"],
		["6328","638"],
		["633","633"],
		["634","634"],
		["6341","6341"],
		["6342","6342"],
		["6343","6341"],
		["6344","6342"],
		["635","630"],
		["636","636"],
		["637","631"],
		["6371","631"],
		["6372","631"],
		["6373","631"],
		["6374","631"],
		["638","638"],
		["639","639"],
		["6391","6391"],
		["6392","6392"],
		["6393","6391"],
		["6394","6392"],
		["640","640"],
		["641","641"],
		["642","642"],
		["643","644"],
		["643","643"],
		["","6440"],
		["","6442"],
		["","645"],
		["","6450"],
		["","6457"],
		["649","649"],
		["650","650"],
		["651","651"],
		["6510","6510"],
		["6511","6511"],
		["659","659"],
		["","660"],
		["661","661"],
		["6610","6610"],
		["6611","6611"],
		["","6612"],
		["6613","6613"],
		["6615","6615"],
		["6616","6616"],
		["","6617"],
		["6618","6618"],
		["662","662"],
		["6620","6620"],
		["6621","6621"],
		["","6622"],
		["6622","6623"],
		["6623","6624"],
		["","663"],
		["663","662"],
		["","6630"],
		["6630","6620"],
		["","6631"],
		["6631","6621"],
		["","6632"],
		["6632","6623"],
		["","6633"],
		["6633","6624"],
		["","664"],
		["664","665"],
		["","6640"],
		["6640","6650"],
		["","6641"],
		["6641","6651"],
		["","6642"],
		["","6643"],
		["6643","6653"],
		["665","706"],
		["6650","706"],
		["6651","706"],
		["","6652"],
		["6653","706"],
		["","6654"],
		["","6655"],
		["","6656"],
		["","6657"],
		["666","666"],
		["6660","6660"],
		["6661","6661"],
		["","6662"],
		["6663","6663"],
		["6665","6665"],
		["6666","6666"],
		["","6667"],
		["6668","6668"],
		["667","667"],
		["6670","6670"],
		["6671","6671"],
		["","6672"],
		["6673","6673"],
		["6675","6675"],
		["6676","6676"],
		["","6677"],
		["6678","6678"],
		["668","668"],
		["6680","668"],
		["6681","668"],
		["669","669"],
		["6690","669"],
		["6691","669"],
		["670","670"],
		["671","671"],
		["","672"],
		["672","6733"],
		["","673"],
		["673","6734"],
		["","6735"],
		["674","675"],
		["676","671"],
		["678","678"],
		["6780","678"],
		["6781","678"],
		["679","678"],
		["680",""],
		["681","680"],
		["","682"],
		["682","681"],
		["690","669"],
		["691","690"],
		["","692"],
		["692","691"],
		["693","693"],
		["","6930"],
		["","6931"],
		["","6932"],
		["","6933"],
		["694","694"],
		["695","695"],
		["6950","6959"],
		["6951","6954"],
		["696","696"],
		["6960","6960"],
		["6961","6961"],
		["","6962"],
		["6963","6968"],
		["6963","6963"],
		["6965","6965"],
		["6966","6966"],
		["","6967"],
		["697","697"],
		["6970","6970"],
		["6971","6971"],
		["","6972"],
		["6973","6973"],
		["698","698"],
		["6980","6985"],
		["6980","6980"],
		["6981","6986"],
		["6981","6981"],
		["6983","6988"],
		["","6987"],
		["699","699"],
		["6990","6990"],
		["6991","6991"],
		["","6992"],
		["6993","6993"],
		["700","700"],
		["701","701"],
		["702","702"],
		["703","703"],
		["704","704"],
		["705","705"],
		["","7060"],
		["","7061"],
		["","7062"],
		["","7063"],
		["708","708"],
		["7080","7080"],
		["7081","7081"],
		["7082","7082"],
		["7083","7083"],
		["7084","7084"],
		["709","709"],
		["7090","7090"],
		["7091","7091"],
		["7092","7092"],
		["7093","7093"],
		["7094","7094"],
		["710","710"],
		["711","711"],
		["712","712"],
		["713","713"],
		["730",""],
		["731","730"],
		["","732"],
		["732","731"],
		["733","733"],
		["737",""],
		["740","740"],
		["741","747"],
		["751","751"],
		["7510","7510"],
		["7511","7511"],
		["752","752"],
		["753","753"],
		["754","754"],
		["755","755"],
		["759","759"],
		["760","760"],
		["7600","7600"],
		["7601","7601"],
		["","7602"],
		["7603","7603"],
		["761","761"],
		["7610","7610"],
		["7611","7611"],
		["","7612"],
		["7613","7613"],
		["7618","761"],
		["","762"],
		["762","7620"],
		["7620","76200"],
		["","76202"],
		["7621","76201"],
		["","76212"],
		["7623","76203"],
		["","763"],
		["763","7621"],
		["","7630"],
		["7630","76210"],
		["","7631"],
		["7631","76211"],
		["","7632"],
		["","7633"],
		["7633","76213"],
		["765","606"],
		["7650","606"],
		["7651","606"],
		["7653","606"],
		["766","766"],
		["7660","7660"],
		["7661","7661"],
		["","7662"],
		["7663","7663"],
		["7665","7665"],
		["7666","7666"],
		["","7667"],
		["7668","7668"],
		["","767"],
		["768","768"],
		["7680","768"],
		["7681","768"],
		["769","769"],
		["7690","769"],
		["7691","769"],
		["770","770"],
		["771","771"],
		["","772"],
		["772","7733"],
		["","773"],
		["773","7734"],
		["","7735"],
		["","774"],
		["774","775"],
		["775","746"],
		["776","747"],
		["778","778"],
		["779","778"],
		["790","795"],
		["791","790"],
		["","792"],
		["792","791"],
		["793","793"],
		["","7930"],
		["","7931"],
		["","7932"],
		["","7933"],
		["794","794"],
		["795","794"],
		["","7950"],
		["","7951"],
		["","7952"],
		["","7954"],
		["","79544"],
		["","79549"],
		["","7955"],
		["","7956"],
		["","7957"],
		["796","796"],
		["7960","7960"],
		["7961","7961"],
		["7963","7968"],
		["7965","7965"],
		["7966","7966"],
		["","7967"],
		["797","797"],
		["7970","7970"],
		["7971","7971"],
		["","7972"],
		["7973","7973"],
		["798","798"],
		["7980","7985"],
		["7980","7980"],
		["7981","7986"],
		["7981","7981"],
		["7983","7988"],
		["","7987"],
		["799","799"],
		["7990","7990"],
		["7991","7991"],
		["","7992"],
		["7993","7993"],
		["","800"],
		["","802"],
		["","810"],
		["","811"],
		["","812"],
		["","813"],
		["","820"],
		["","821"],
		["","830"],
		["","8300"],
		["","8301"],
		["","833"],
		["","834"],
		["","835"],
		["","836"],
		["","837"],
		["","838"],
		["","840"],
		["","841"],
		["","842"],
		["","850"],
		["","851"],
		["","860"],
		["","862"],
		["","891"],
		["","892"],
		["","900"],
		["","902"],
		["","910"],
		["","911"],
		["","912"],
		["","913"],
		["","920"],
		["","921"],
		["","940"],
		["","941"],
		["","942"],
		["","950"],
		["","951"],
		["","960"],
		["","962"],
		["","991"],
		["","992"],
		["","993"],
		["","994"]
	];
	
	return datos;
}


function pgc2008_datosCuentasEspeciales()
{
	var datos:Array = [
		["570","CAJA"],
		["668","CAMNEG"],
		["768","CAMPOS"],
		["437","CLIENT"],
		["435","CLIENT"],
		["436","CLIENT"],
		["440","CLIENT"],
		["449","CLIENT"],
		["445","CLIENT"],
		["432","CLIENT"],
		["4320","CLIENT"],
		["4321","CLIENT"],
		["4324","CLIENT"],
		["4326","CLIENT"],
		["4329","CLIENT"],
		["4415","CLIENT"],
		["4412","CLIENT"],
		["4411","CLIENT"],
		["4410","CLIENT"],
		["441","CLIENT"],
		["4409","CLIENT"],
		["4404","CLIENT"],
		["4400","CLIENT"],
		["430","CLIENT"],
		["4300","CLIENT"],
		["4304","CLIENT"],
		["4309","CLIENT"],
		["431","CLIENT"],
		["4310","CLIENT"],
		["4311","CLIENT"],
		["4312","CLIENT"],
		["4315","CLIENT"],
		["433","CLIENT"],
		["600","COMPRA"],
		["608","DEVCOM"],
		["708","DEVVEN"],
		["136","DIVPOS"],
		["6680","EURNEG"],
		["7680","EURPOS"],
		["4751","IRPFPR"],
		["475","IVAACR"],
		["4750","IVAACR"],
		["4700","IVADEU"],
		["470","IVADEU"],
		["477","IVAREP"],
		["4770","IVAREP"],
		["4720","IVASOP"],
		["472","IVASOP"],
		["120","PREVIO"],
		["121","PREVIO"],
		["411","PROVEE"],
		["419","PROVEE"],
		["401","PROVEE"],
		["4029","PROVEE"],
		["4026","PROVEE"],
		["400","PROVEE"],
		["4000","PROVEE"],
		["4004","PROVEE"],
		["4009","PROVEE"],
		["407","PROVEE"],
		["403","PROVEE"],
		["406","PROVEE"],
		["410","PROVEE"],
		["4100","PROVEE"],
		["4104","PROVEE"],
		["4109","PROVEE"],
		["4024","PROVEE"],
		["4021","PROVEE"],
		["4020","PROVEE"],
		["402","PROVEE"],
		["129","PYG"],
		["705","VENTAS"],
		["704","VENTAS"],
		["703","VENTAS"],
		["700","VENTAS"],
		["701","VENTAS"],
		["702","VENTAS"]
	];
	
	return datos;
}


function pgc2008_datosCuentasHuerfanas()
{
	var datos:Array = [
		["111","Reservas de revalorización"],
		["135","Ingresos por intereses diferidos"],
		["200","Gastos de constitución"],
		["201","Gastos de primer establecimiento"],
		["202","Gastos de ampliación de capital"],
		["217","Derechos sobre bienes en régimen de arrendamiento financiero."],
		["270","Gastos de formalización de deudas"],
		["271","Gastos por intereses diferidos de valores negociables"],
		["272","Gastos por intereses diferidos"],
		["2813","Amortización acumulada de fondo de comercio"],
		["680","Amortización de gastos de establecimiento"],
		["730","Incorporación al activo de gastos de establecimiento"],
		["737","Incorporación al activo de gastos de formalización de deudas"]];
	
	return datos;
}


/** \D Se dan de alta las cuentas especiales, si existen se ignoran
\end */
function pgc2008_completarTiposEspeciales()
{
	var datos =
		[["IVAREP","Cuentas de IVA repercutido"],
		["IVASOP","Cuentas de IVA soportado"],
		["IVARUE","Cuentas de IVA repercutido UE"],
		["IVASUE","Cuentas de IVA soportado UE"],
		["IVAACR","Cuentas acreedoras de IVA en la regularización"],
		["IVADEU","Cuentas deudoras de IVA en la regularización"],
		["PYG","Pérdidas y ganancias"],
		["PREVIO","Cuentas relativas al ejercicio previo"],
		["CAMPOS","Cuentas de diferencias positivas de cambio"],
		["CAMNEG","Cuentas de diferencias negativas de cambio"],
		["DIVPOS","Cuentas por diferencias positivas en divisa extranjera"],
		["EURPOS","Cuentas por diferencias positivas de conversión a la moneda local"],
		["EURNEG","Cuentas por diferencias negativas de conversión a la moneda local"],
		["CLIENT","Cuentas de clientes"],
		["PROVEE","Cuentas de proveedores"],
		["COMPRA","Cuentas de compras"],
		["VENTAS","Cuentas de ventas"],
		["CAJA","Cuentas de caja"],
		["IRPFPR","Cuentas de retenciones para proveedores IRPFPR"],
		["IRPF","Cuentas de retenciones IRPF"],
		["GTORF","Gastos por recargo financiero"],
		["INGRF","Ingresos por recargo financiero"],
		["DEVCOM","Devoluciones de compras"],
		["DEVVEN","Devoluciones de ventas"]];
			
	var cursor:FLSqlCursor = new FLSqlCursor("co_cuentasesp");
	for (i = 0; i < datos.length; i++) {
	
		cursor.select("idcuentaesp = '" + datos[i][0] + "'");
		if (cursor.first())
			continue;
	
		cursor.setModeAccess(cursor.Insert);
		cursor.refreshBuffer();
		cursor.setValueBuffer("idcuentaesp", datos[i][0]);
		cursor.setValueBuffer("descripcion", datos[i][1]);
		cursor.commitBuffer();
	} 
}

function pgc2008_regenerarPGC(codEjercicio:String)
{
	var util:FLUtil = new FLUtil;
	var curCbl:FLSqlCursor;	
	var longSubcuenta:Number = util.sqlSelect("ejercicios", "longsubcuenta", "codejercicio = '" + codEjercicio + "'");
	
	
	// CORRESPONDENCIAS
	util.createProgressDialog(util.translate("scripts", "Preparando..."), 2);
	util.setProgress(1);
	util.sqlDelete("co_correspondenciascc", "");
	util.destroyProgressDialog();
	
	this.iface.generarCorrespondenciasCC(codEjercicio);
	
	
	// DESCRIPCIONES DE GRUPOS
	var datos:Array = this.iface.datosGrupos();
	curCbl = new FLSqlCursor("co_gruposepigrafes");
	curCbl.setActivatedCheckIntegrity(false);
	util.createProgressDialog(util.translate("scripts", "Actualizando grupos"), datos.length);
			
	for (i = 0; i < datos.length; i++) {
		util.setProgress(i);
		curCbl.select("codgrupo = '" + datos[i][0] + "' AND codejercicio = '" + codEjercicio + "'");
		if (curCbl.first()) {
			with(curCbl) {
				setModeAccess(curCbl.Edit);
				refreshBuffer();
				setValueBuffer("descripcion", datos[i][1]);
				commitBuffer();
			}
		}
	}
	util.destroyProgressDialog();
	
	
	
	// SUBGRUPOS
	var datos:Array = this.iface.datosSubgrupos();		
	curCbl = new FLSqlCursor("co_epigrafes");
	curCbl.setActivatedCheckIntegrity(false);
	util.createProgressDialog(util.translate("scripts", "Actualizando subgrupos"), datos.length);
			
	for (i = 0; i < datos.length; i++) {
		
		idGrupo = util.sqlSelect("co_gruposepigrafes", "idgrupo", "codgrupo = '" + datos[i][2] + "' and codejercicio = '" + codEjercicio + "'");
		
		util.setProgress(i);
		curCbl.select("codepigrafe = '" + datos[i][0] + "' AND codejercicio = '" + codEjercicio + "'");
		if (curCbl.first()) {
			with(curCbl) {
				setModeAccess(curCbl.Edit);
				refreshBuffer();
				setValueBuffer("descripcion", datos[i][1]);
				commitBuffer();
			}
		}
		else 
			with(curCbl) {
				setModeAccess(curCbl.Insert);
				refreshBuffer();
				setValueBuffer("codepigrafe", datos[i][0]);
				setValueBuffer("descripcion", datos[i][1]);
				setValueBuffer("idgrupo", idGrupo);
				setValueBuffer("codejercicio", codEjercicio);
				commitBuffer();
			}
	}
	util.destroyProgressDialog();
	
	
	// CUENTAS
	var datos:Array = this.iface.datosCuentas();		
	curCbl = new FLSqlCursor("co_cuentas");
	curCbl.setActivatedCheckIntegrity(false);
	
	util.createProgressDialog(util.translate("scripts", "Actualizando cuentas"), datos.length);
			
	for (i = 0; i < datos.length; i++) {
		util.setProgress(i);
		
		idEpigrafe = util.sqlSelect("co_epigrafes", "idepigrafe", "codepigrafe = '" + datos[i][2] + "' and codejercicio = '" + codEjercicio + "'");
		
		curCbl.select("codcuenta = '" + datos[i][0] + "' AND codejercicio = '" + codEjercicio + "'");
		if (curCbl.first()) {
				with(curCbl) {
				setModeAccess(curCbl.Edit);
				refreshBuffer();
				setValueBuffer("descripcion", datos[i][1]);
				commitBuffer();
			}
		}
		
		else 
			with(curCbl) {
				setModeAccess(curCbl.Insert);
				refreshBuffer();
				setValueBuffer("codcuenta", datos[i][0]);
				setValueBuffer("descripcion", datos[i][1]);
				setValueBuffer("idepigrafe", idEpigrafe);
				setValueBuffer("codepigrafe", datos[i][2]);
				setValueBuffer("codejercicio", codEjercicio);
				commitBuffer();
			}
	
	}
	util.destroyProgressDialog();
	
	
	// SUBCUENTAS (sólo las que vienen directas de cuenta: XXX000000)
	var datos:Array = this.iface.datosCuentas();		
	curCbl = new FLSqlCursor("co_subcuentas");
	curCbl.setActivatedCheckIntegrity(false);
	
	util.createProgressDialog(util.translate("scripts", "Actualizando subcuentas"), datos.length);
			
	for (i = 0; i < datos.length; i++) {
		util.setProgress(i);
		
		codSubcuenta = datos[i][0];
		numCeros = longSubcuenta - codSubcuenta.toString().length;
		for (var i = 0; i < numCeros; i++)
			codSubcuenta += "0";
			
		curCbl.select("codsubcuenta = '" + codSubcuenta + "' AND codejercicio = '" + codEjercicio + "'");
		if (curCbl.first()) {
				with(curCbl) {
				setModeAccess(curCbl.Edit);
				refreshBuffer();
				setValueBuffer("descripcion", datos[i][1]);
				commitBuffer();
			}
		}
	
	}
	util.destroyProgressDialog();
	
	// SUBCUENTAS QUE FALTAN TRAS CREAR LAS CUENTAS
	this.iface.generarSubcuentas(codEjercicio, longSubcuenta);
	
	// CÓDIGOS DE BALANCE abreviado
	util.sqlDelete("co_cuentascbba", "");
	util.sqlDelete("co_cuentascb", "");
	util.sqlDelete("co_codbalances08", "");
	
	// CÓDIGOS DE BALANCE
	this.iface.generarCodigosBalance2008();
	this.iface.actualizarCuentas2008(codEjercicio);
	this.iface.actualizarCuentas2008ba(codEjercicio);

	this.iface.actualizarCuentasDigitos(codEjercicio);

	MessageBox.information(util.translate("scripts",  "Proceso finalizado"), MessageBox.Ok, MessageBox.NoButton);
}


/**
Las cuentas de 4 dígitos prevalecen sobre las de 3 dígitos. Ej: 830 desaparece y queda 8300
*/
function pgc2008_actualizarCuentasDigitos(codEjercicio:String)
{
	var curCbl:FLSqlCursor;	
	var util:FLUtil = new FLUtil;
	var curCbl:FLSqlCursor;
	var codCuenta:String, codCuenta3:String, lastCodCuenta3:String = "";
	var paso:Number = 0;
	
	curCbl = new FLSqlCursor("co_cuentas");
	
	curCbl.select("codejercicio = '" + codEjercicio + "' ORDER BY codcuenta");
	util.createProgressDialog(util.translate("scripts", "Actualizando cuentas por dígitos"), curCbl.size());
	
	while (curCbl.next()) {
	
		util.setProgress(paso++);
		
		idCuenta = curCbl.valueBuffer("idcuenta");
		codCuenta = curCbl.valueBuffer("codcuenta");
		
		if (codCuenta.length != 4)
			continue;
		 
		codCuenta3 = codCuenta.left(3);
		
		if (codCuenta3 == lastCodCuenta3)
			continue;
		
		lastCodCuenta3 = codCuenta3;		
		
		idCuenta3 = util.sqlSelect("co_cuentas", "idcuenta", "codcuenta = '" + codCuenta3 + "' AND codejercicio = '" + codEjercicio + "'");
		if (!idCuenta3)
			continue;
		
		// Migrar las subcuentas dependientes
 		util.sqlUpdate("co_subcuentas", "idcuenta,codcuenta", idCuenta + "," + codCuenta, "idcuenta = " + idCuenta3);
 		util.sqlUpdate("series", "idcuenta", idCuenta, "idcuenta = " + idCuenta3)
	}
	
	util.destroyProgressDialog();
}




//// PGC 2008 //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////