/***************************************************************************
                 flprodppal.qs  -  description
                             -------------------
    begin                : mar jul 03 2007
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
	function beforeCommit_pr_horarios(curHorario:FLSqlCursor):Boolean {
		return this.ctx.interna_beforeCommit_pr_horarios(curHorario);
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var tareaMemo:Array;
	var loteMemo:Array;
	var centroMemo:Array;
	var colorLote:Array;
	var iColorLote:Number;
	var curTareas_:FLSqlCursor;
    function oficial( context ) { interna( context ); }
	function compararHoras(hora1:String,hora2:String):Number {
		return this.ctx.oficial_compararHoras(hora1,hora2)
	}
	function aplicarAlgoritmo(algoritmo:String):Boolean {
		return this.ctx.oficial_aplicarAlgoritmo(algoritmo);
	}
	function aplicarAlgoritmoFIFO():Boolean {
		return this.ctx.oficial_aplicarAlgoritmoFIFO();
	}
	function asignarTareaFIFO(iTarea:Number):Boolean {
		return this.ctx.oficial_asignarTareaFIFO(iTarea);
	}
	function fechaMinimaTarea(iTarea:Number):Date {
		return this.ctx.oficial_fechaMinimaTarea(iTarea);
	}
	function buscarFechaMinimaTarea():Date {
		return this.ctx.oficial_buscarFechaMinimaTarea();
	}
	function buscarFechaMaximaTarea():Date {
		return this.ctx.oficial_buscarFechaMaximaTarea();
	}
	function actualizarTareasProceso(idProceso:String, codLote:String,mostrarProgreso:Boolean):Boolean {
		return this.ctx.oficial_actualizarTareasProceso(idProceso, codLote,mostrarProgreso);
	}
	function limpiarMemoria() {
		return this.ctx.oficial_limpiarMemoria();
	}
	function buscarSiguienteTiempoFin(fecha:Date):Date {
		return this.ctx.oficial_buscarSiguienteTiempoFin(fecha);
	}
	function buscarSiguienteTiempoInicio(fecha:Date):Date {
		return this.ctx.oficial_buscarSiguienteTiempoInicio(fecha);
	}
	function cargarTareasLote(datosLote:Array):Boolean {
		return this.ctx.oficial_cargarTareasLote(datosLote);
	}
	function establecerSecuencias():Boolean {
		return this.ctx.oficial_establecerSecuencias();
	}
	function establecerSecuenciasTarea(iTarea:Number, iLote:Number):Boolean {
		return this.ctx.oficial_establecerSecuenciasTarea(iTarea, iLote);
	}
	function buscarTarea(codLote:String, idTipoTareaPro:String):Number {
		return this.ctx.oficial_buscarTarea(codLote, idTipoTareaPro);
	}
	function buscarLote(codLote:String):Number {
		return this.ctx.oficial_buscarLote(codLote);
	}
	function buscarProceso(idProceso:String):Number {
		return this.ctx.oficial_buscarProceso(idProceso);
	}
	function buscarCentroCoste(codCentro:String):Number {
		return this.ctx.oficial_buscarCentroCoste(codCentro);
	}
	function nuevaTarea():Array {
		return this.ctx.oficial_nuevaTarea();
	}
	function nuevoLote():Array {
		return this.ctx.oficial_nuevoLote();
	}
	function nuevoCentroCoste():Array {
		return this.ctx.oficial_nuevoCentroCoste();
	}
	function tareasFinales(codLote:String):Array {
		return this.ctx.oficial_tareasFinales(codLote);
	}
	function establecerSecuencia(iTareaInicial, iTareaFinal):Boolean {
		return this.ctx.oficial_establecerSecuencia(iTareaInicial, iTareaFinal);
	}
	function asignarCentroCosteTarea(iTarea:Number):Boolean {
		return this.ctx.oficial_asignarCentroCosteTarea(iTarea);
	}
	function iniciarCentrosCoste():Boolean {
		return this.ctx.oficial_iniciarCentrosCoste();
	}
	function convetirTiempoMS(tiempo:Number, codCentro:String):Number {
		return this.ctx.oficial_convetirTiempoMS(tiempo, codCentro);
	}
	function sumarTiempo(fecha:Date, tiempo:Number, codCentro:String):Number {
		return this.ctx.oficial_sumarTiempo(fecha, tiempo, codCentro);
	}
	function compararFechas(fecha1:Date, fecha2:Date):Number {
		return this.ctx.oficial_compararFechas(fecha1, fecha2);
	}
	function datosTarea(idTipoTareaPro:String):String {
		return this.ctx.oficial_datosTarea(idTipoTareaPro);
	}
	function tareasCentroCoste(codCentro:String):Array {
		return this.ctx.oficial_tareasCentroCoste(codCentro);
	}
	function restriccionesConsumo():Boolean {
		return this.ctx.oficial_restriccionesConsumo();
	}
	function buscarPedidoFechaMinima(codLote:String,criterios:String):Array {
		return this.ctx.oficial_buscarPedidoFechaMinima(codLote,criterios);
	}
	function costeCentroTarea(codTipoCentro:String,referencia:String,iTarea:Number,iLote:Number,codCentro:String):Number {
		return this.ctx.oficial_costeCentroTarea(codTipoCentro,referencia,iTarea,iLote,codCentro);
	}
	function elegirOpcion(opciones:Array):Number {
		return this.ctx.oficial_elegirOpcion(opciones);
	}
	function htmlPlanificacion():String {
		return this.ctx.oficial_htmlPlanificacion();
	}
	function htmlCentroCoste(codCentro:String, minFecha:Date, maxFecha:Date):String {
		return this.ctx.oficial_htmlCentroCoste(codCentro, minFecha, maxFecha);
	}
	function calcularRestoDia(fecha:Date):Number {
		return this.ctx.oficial_calcularRestoDia(fecha);
	}
	function modificarEstadoOrden(codOrden:String):Boolean {
		return this.ctx.oficial_modificarEstadoOrden(codOrden);
	}
	function dameAtributoXML(nodoPadre:FLDomNode, ruta:String, debeExistir:Boolean):String {
		return this.ctx.oficial_dameAtributoXML(nodoPadre, ruta, debeExistir);
	}
	function dameNodoXML(nodoPadre:FLDomNode, ruta:String, debeExistir:Boolean):FLDomNode {
		return this.ctx.oficial_dameNodoXML(nodoPadre, ruta, debeExistir);
	}
	function datosTareaActualizada(tarea:Array):Boolean {
		return this.ctx.oficial_datosTareaActualizada(tarea);
	}
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration visual */
/////////////////////////////////////////////////////////////////
//// PRODUCCIÓN VISUAL //////////////////////////////////////////
class visual extends oficial {
	var curPedidoProv_:FLSqlCursor;
	var curLineaPedidoProv_:FLSqlCursor;
    function visual( context ) { oficial ( context ); }
	function asignarCentroCosteTarea(iTarea:Number):Boolean {
		return this.ctx.visual_asignarCentroCosteTarea(iTarea);
	}
	function sumarTiempo(fecha:Date, tiempo:Number, codCentro:String):Number {
		return this.ctx.visual_sumarTiempo(fecha, tiempo, codCentro);
	}
	function iniciarCentrosCoste():Boolean {
		return this.ctx.visual_iniciarCentrosCoste();
	}
	function beforeCommit_pr_lineasplancompras(curLC:FLSqlCursor):Boolean {
		return this.ctx.visual_beforeCommit_pr_lineasplancompras(curLC);
	}
	function crearCompraPlan(curLC:FLSqlCursor):Boolean {
		return this.ctx.visual_crearCompraPlan(curLC);
	}
	function modificarCompraPlan(curLC:FLSqlCursor, usarPrevios:Boolean):Boolean {
		return this.ctx.visual_modificarCompraPlan(curLC, usarPrevios);
	}
	function borrarCompraPlan(curLC:FLSqlCursor):Boolean {
		return this.ctx.visual_borrarCompraPlan(curLC);
	}
	function crearLineaCompraPlan(idPedido:String, curLC:FLSqlCursor):Boolean {
		return this.ctx.visual_crearLineaCompraPlan(idPedido, curLC);
	}
	function modificarLineaCompraPlan(curLC:FLSqlCursor, usarPrevios:Boolean):Boolean {
		return this.ctx.visual_modificarLineaCompraPlan(curLC, usarPrevios);
	}
	function datosLineaCompraPlan(curLC:FLSqlCursor, usarPrevios:Boolean):Boolean {
		return this.ctx.visual_datosLineaCompraPlan(curLC, usarPrevios);
	}
	function datosCompraPlan(curLC:FLSqlCursor):Boolean {
		return this.ctx.visual_datosCompraPlan(curLC);
	}
	function totalesPedido():Boolean {
		return this.ctx.visual_totalesPedido();
	}
	function restriccionesConsumo():Boolean {
		return this.ctx.visual_restriccionesConsumo();
	}
}
//// PRODUCCIÓN VISUAL //////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends visual {
    function head( context ) { visual ( context ); }
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration ifaceCtx */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends head {
    function ifaceCtx( context ) { head( context ); }
	function pub_compararHoras(hora1:String,hora2:String) {
		return this.compararHoras(hora1,hora2);
	}
	function pub_cargarTareasLote(datosLote:Array):Boolean {
		return this.cargarTareasLote(datosLote);
	}
	function pub_establecerSecuencias():Boolean {
		return this.establecerSecuencias();
	}
	function pub_aplicarAlgoritmo(algoritmo:String):Boolean {
		return this.aplicarAlgoritmo(algoritmo);
	}
	function pub_iniciarCentrosCoste():Boolean {
		return this.iniciarCentrosCoste();
	}
	function pub_iniciarCentrosCoste():Boolean {
		return this.iniciarCentrosCoste();
	}
	function pub_limpiarMemoria() {
		return this.limpiarMemoria();
	}
	function pub_actualizarTareasProceso(idProceso:String, codLote:String,mostrarProgreso:Boolean):Boolean {
		return this.actualizarTareasProceso(idProceso, codLote,mostrarProgreso);
	}
	function pub_buscarPedidoFechaMinima(codLote:String,criterios:String):Array {
		return this.buscarPedidoFechaMinima(codLote,criterios);
	}
	function pub_elegirOpcion(opciones:Array):Number {
		return this.elegirOpcion(opciones);
	}
	function pub_modificarEstadoOrden(codOrden) {
		return this.modificarEstadoOrden(codOrden);
	}
	function pub_dameAtributoXML(nodoPadre:FLDomNode, ruta:String, debeExistir:Boolean):String {
		return this.dameAtributoXML(nodoPadre, ruta, debeExistir);
	}
	function pub_dameNodoXML(nodoPadre:FLDomNode, ruta:String, debeExistir:Boolean):FLDomNode {
		return this.dameNodoXML(nodoPadre, ruta, debeExistir);
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
function interna_beforeCommit_pr_horarios(curHorario:FLSqlCursor):Boolean
{
	if (curHorario.modeAccess() == curHorario.Insert || curHorario.modeAccess() == curHorario.Edit) {
		var horaEntradaManana:String = curHorario.valueBuffer("horaentradamanana");
		var horaSalidaManana:String = curHorario.valueBuffer("horasalidamanana");
		var horaEntradaTarde:String = curHorario.valueBuffer("horaentradatarde");
		var horaSalidaTarde:String = curHorario.valueBuffer("horasalidatarde");
	
		var tiempo:Number = 0;

		if (horaEntradaManana && horaEntradaManana != "" && horaEntradaManana != "null" && (horaSalidaManana && horaSalidaManana != "" && horaSalidaManana != "null"))
			tiempo += horaSalidaManana.getTime() - horaEntradaManana.getTime();

		if (horaEntradaTarde && horaEntradaTarde != "" && horaEntradaTarde != "null" && (horaSalidaTarde && horaSalidaTarde != "" && horaSalidaTarde != "null"))
			tiempo += horaSalidaTarde.getTime() - horaEntradaTarde.getTime();

		curHorario.setValueBuffer("tiempo",tiempo);

	}
	return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_compararHoras(hora1:String,hora2:String):Number
{
	if(!hora1 || !hora2 || hora1 == "null" || hora2 == "null" || hora1 == "" || hora2 == ""){
		return -1;
	}
// debug(hora1);
// debug(hora2);
// 	var d:Date = new Date( Date.parse( "1976-01-25T" + hora1 ) );
// debug(d);
	var horas1:Number = hora1.getHours();
	var minutos1:Number = hora1.getMinutes();
	var segundos1:Number = hora1.getSeconds();
	if(horas1 == 0 && minutos1 == 0 && segundos1 == 0)
		return -1;
// 	delete d;
// 	d = new Date( Date.parse( "1976-01-25T" + hora2 ) );
	var horas2:Number = hora2.getHours();
	var minutos2:Number = hora2.getMinutes();
	var segundos2:Number = hora2.getSeconds();

	if(horas2 == 0 && minutos2 == 0 && segundos2 == 0)
		return -1;

	if (horas1 > horas2)
		return 1;
	if (horas1 < horas2)
		return 2;
	if (minutos1 > minutos2)
		return 1;
	if (minutos1 < minutos2)
		return 2;
	if (segundos1 > segundos2)
		return 1
	if (segundos1 < segundos2)
		return 2;

	return 0;
}
function oficial_aplicarAlgoritmo(algoritmo:String):Boolean
{
	switch (algoritmo) {
		case "FIFO": {
			if (!this.iface.aplicarAlgoritmoFIFO())
				return false;
			break;
		}
	}
	return true;
}

function oficial_aplicarAlgoritmoFIFO():Boolean
{
	var util:FLUtil;
	util.createProgressDialog(util.translate("scripts", "Planificando tareas ..."), this.iface.tareaMemo.length);
	for (var iTarea:Number = 0; iTarea < this.iface.tareaMemo.length; iTarea++) {
		util.setProgress(iTarea);
		if (!this.iface.asignarTareaFIFO(iTarea)) {
			util.destroyProgressDialog()
			return false;
		}
	}
	util.destroyProgressDialog();
	return true;
}

function oficial_asignarTareaFIFO(iTarea:Number):Boolean
{
	if (this.iface.tareaMemo[iTarea]["asignada"])
		return true;

	var totalPredecesoras:Number = this.iface.tareaMemo[iTarea]["predecesora"].length;
	for (var iPredecesora:Number = 0; iPredecesora < totalPredecesoras; iPredecesora++) {
		if (!this.iface.asignarTareaFIFO(this.iface.tareaMemo[iTarea]["predecesora"][iPredecesora]))
			return false;
	}

	if (!this.iface.asignarCentroCosteTarea(iTarea))
		return false;

	return true;
}

/** \D Obtiene la fecha mínima de comienzo de una tarea en función de la máxima fecha de finalización de sus tareas predecesoras
@param iTarea: Indice de la tarea
@return	fecha mínima de inicio
|end */
function oficial_fechaMinimaTarea(iTarea:Number):Date
{
	var iTP:Number;
	var fechaMin:Date = false;
	var totalPredecesoras:Number = this.iface.tareaMemo[iTarea]["predecesora"].length;
	var iTP:Number;
	var fechaPredecesora:Date;
	for (var iPredecesora:Number = 0; iPredecesora < totalPredecesoras; iPredecesora++) {
		iTP = this.iface.tareaMemo[iTarea]["predecesora"][iPredecesora];
		if (!fechaMin) {
			if (this.iface.tareaMemo[iTP]["saltada"]) {
				fechaMin = this.iface.fechaMinimaTarea(iTP);
			} else {
				fechaMin = this.iface.tareaMemo[iTP]["fechafin"];
			}
		} else {
			if (this.iface.tareaMemo[iTP]["saltada"]) {
				fechaPredecesora = this.iface.fechaMinimaTarea(iTP);
			} else {
				fechaPredecesora = this.iface.tareaMemo[iTP]["fechafin"];
			}
			if (this.iface.compararFechas(fechaPredecesora, fechaMin) == 1) {
				fechaMin = fechaPredecesora;
			}
		}
	}
	return fechaMin;
}

function oficial_asignarCentroCosteTarea(iTarea:Number):Boolean
{
	var util:FLUtil = new FLUtil;
	var codLote:String = this.iface.tareaMemo[iTarea]["codlote"];
	var idProceso:String = this.iface.tareaMemo[iTarea]["idproceso"];
	var iLote:Number;
	iLote = this.iface.buscarProceso(idProceso);
	if (iLote < 0) {
		MessageBox.warning(util.translate("scripts", "Error al buscar los datos del proceso %1").arg(idProceso), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var idTipoTareaPro:String = this.iface.tareaMemo[iTarea]["idtipotareapro"];
	var xmlTarea:FLDomNode = this.iface.tareaMemo[iTarea]["xmltarea"];
	var eTarea:FLDomElement;	
	if (xmlTarea) {
		eTarea = xmlTarea.toElement();
		if (eTarea.attribute("Estado") == "Saltada") {
			this.iface.tareaMemo[iTarea]["asignada"] = true;
			this.iface.tareaMemo[iTarea]["saltada"] = true;
			return true;
		}
	}
	this.iface.tareaMemo[iTarea]["saltada"] = false;
	
	var referencia:String = this.iface.loteMemo[iLote]["referencia"];

	var fechaMinTarea:Date = this.iface.fechaMinimaTarea(iTarea);

	var qryCentros:FLSqlQuery = new FLSqlQuery;
	if (eTarea && eTarea.attribute("CodTipoCentro") != "") {
		with (qryCentros) {
			setTablesList("pr_centroscoste");
			setSelect("codcentro, codtipocentro");
			setFrom("pr_centroscoste");
			setWhere("codTipoCentro = '" + eTarea.attribute("CodTipoCentro") + "'");
			setForwardOnly(true);
		}
	} else {
		with (qryCentros) {
			setTablesList("pr_costestarea,pr_centroscoste");
			setSelect("cc.codcentro, ct.codtipocentro");
			setFrom("pr_costestarea ct INNER JOIN pr_centroscoste cc ON ct.codtipocentro = cc.codtipocentro");
			setWhere("ct.idtipotareapro = " + idTipoTareaPro);
			setForwardOnly(true);
		}
	}
	if (!qryCentros.exec()) {
		return false;
	}

	var minFechaInicio:Date = false;
	var minFechaFin:Date = false;
	var minICentro:Number = -1;
	var minTiempo:Number;

	var fechaFin:Date;
	var fechaInicio:Date;
	var minCentro:String;
	var iCentro:Number;
	var dia:Date;
	var tiempo:Number;
	var costeFijo:Number;
	var costeUnidad:Number;
	var codCentro:String;
	var tiempoTotalTarea:Number;

	while (qryCentros.next()) {

		codCentro = qryCentros.value(0);
		iCentro = this.iface.buscarCentroCoste(codCentro);

		if (iCentro < 0) {
			MessageBox.warning(util.translate("scripts", "Error al buscar los datos del centro de coste %1").arg(codCentro), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}

		tiempo = this.iface.costeCentroTarea(qryCentros.value(1),referencia,iTarea,iLote,codCentro);
		if (tiempo == -2)
			return false;

		if (tiempo == -1)
			continue;

		tiempoTotalTarea = tiempo;
		
		if (fechaMinTarea && this.iface.compararFechas(fechaMinTarea, this.iface.centroMemo[iCentro]["fechainicio"]) == 1)
			fechaInicio = fechaMinTarea;
		else
			fechaInicio = this.iface.centroMemo[iCentro]["fechainicio"];

		if (!util.sqlSelect("pr_calendario","fecha","1 = 1")) {
			MessageBox.warning(util.translate("scripts", "Antes de calcular el tiempo de finalización de la tarea debe generar el calendario laboral."), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
		var tiempoFinDia:Number = -1;
		var masDias:Boolean = true;
		tiempoFinDia = this.iface.calcularRestoDia(fechaInicio);;
		
		if (tiempoFinDia > tiempo) {
			// Hay tiempo para hacerlo en un sólo día
			fechaFin = this.iface.sumarTiempo(fechaInicio, tiempo, codCentro);
		} else {
			// No hay tiempo para hacerlo en un sólo día
			fechaFin = new Date(fechaInicio.getTime());
			tiempo -= tiempoFinDia;
			var qryCalendario:FLSqlQuery = new FLSqlQuery;
			qryCalendario.setTablesList("pr_calendario");
			qryCalendario.setSelect("fecha,tiempo");
			qryCalendario.setFrom("pr_calendario");
			qryCalendario.setWhere("fecha > '" + fechaFin + "' ORDER BY fecha ASC");
			if (!qryCalendario.exec())
				return -1;
	
			var buscarSiguienteDia:Boolean = true;
			if (!qryCalendario.first())
				buscarSiguienteDia = false;
	
			while (buscarSiguienteDia) {
				if (parseFloat(qryCalendario.value("tiempo")) <= tiempo && tiempo > 0) {
					tiempo -= parseFloat(qryCalendario.value("tiempo"));
					fechaFin = qryCalendario.value("fecha");
					if(!qryCalendario.next())
						buscarSiguienteDia = false;
				}
				else
					buscarSiguienteDia = false;
			}
			fechaFin = this.iface.buscarSiguienteTiempoInicio(fechaFin);
	
			fechaFin = this.iface.sumarTiempo(fechaFin, tiempo, codCentro);
		}
		if (!fechaFin)
			return false;
		if (minFechaFin && this.iface.compararFechas(minFechaFin, fechaFin) == 2)
			continue;
		minFechaInicio = fechaInicio;
		minFechaFin = fechaFin;
		minCodCentro = codCentro;
		minTiempo = tiempoTotalTarea;
		minICentro = iCentro;
	}
	if (minICentro < 0) {
		MessageBox.warning(util.translate("scripts", "No se ha podido asignar centro de coste a la tarea:\n%1\nAsociada al lote %2").arg(this.iface.datosTarea(idTipoTareaPro)).arg(codLote), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	this.iface.tareaMemo[iTarea]["codcentrocoste"] = minCodCentro;
	this.iface.tareaMemo[iTarea]["fechainicio"] = minFechaInicio;
	this.iface.tareaMemo[iTarea]["fechafin"] = minFechaFin;

	this.iface.tareaMemo[iTarea]["duracion"] = minTiempo;
	this.iface.tareaMemo[iTarea]["asignada"] = true;
	this.iface.centroMemo[minICentro]["fechainicio"] = minFechaFin;

	return true;
}

function oficial_calcularRestoDia(fecha:Date):Number
{
// debug("calcularRestoDia " + fecha.toString());
	var util:FLUtil;
	var tiempo:Number = -1;
	
	var curCalendario:FLSqlCursor = new FLSqlCursor("pr_calendario");
	curCalendario.select("fecha = '" + fecha + "'");
	if (!curCalendario.first()) {
		return -1;
	}
	curCalendario.setModeAccess(curCalendario.Browse);
	curCalendario.refreshBuffer();
	if (!curCalendario.isNull("horaentradatarde") && !curCalendario.isNull("horasalidatarde")) {
		var horaEntradaTarde:Date = curCalendario.valueBuffer("horaentradatarde");
		horaEntradaTarde.setYear(fecha.getYear())
		horaEntradaTarde.setMonth(fecha.getMonth())
		horaEntradaTarde.setDate(fecha.getDate())
		var horaSalidaTarde:Date = curCalendario.valueBuffer("horasalidatarde");
		horaSalidaTarde.setYear(fecha.getYear())
		horaSalidaTarde.setMonth(fecha.getMonth())
		horaSalidaTarde.setDate(fecha.getDate())
		
		if (fecha.getTime() > horaSalidaTarde.getTime()) {
			tiempo = 0;
			return tiempo;
		} else {
			if (fecha.getTime() > horaEntradaTarde.getTime()) {
				tiempo = horaSalidaTarde.getTime() - fecha.getTime();
			} else {
				tiempo = horaSalidaTarde.getTime() - horaEntradaTarde.getTime();
			}
		}
	}

	if (!curCalendario.isNull("horaentradamanana") && !curCalendario.isNull("horasalidamanana")) {
		var horaEntradaManana:Date = curCalendario.valueBuffer("horaentradamanana");
		horaEntradaManana.setYear(fecha.getYear())
		horaEntradaManana.setMonth(fecha.getMonth())
		horaEntradaManana.setDate(fecha.getDate())
		var horaSalidaManana:Date =  curCalendario.valueBuffer("horasalidamanana");
		horaSalidaManana.setYear(fecha.getYear())
		horaSalidaManana.setMonth(fecha.getMonth())
		horaSalidaManana.setDate(fecha.getDate())
// debug("horaEntradaManana " + horaEntradaManana + " - " + horaSalidaManana + " para " + fecha.toString());
		if (fecha.getTime() < horaSalidaManana.getTime()) {
			if (fecha.getTime() < horaEntradaManana.getTime()) {
				if (tiempo == -1) {
					tiempo = 0;
				}
				tiempo += horaSalidaManana.getTime() - horaEntradaManana.getTime();
			} else {
				if (tiempo == -1) {
					tiempo = 0;
				}
				tiempo += horaSalidaManana.getTime() - fecha.getTime();
			}
		}
	}

	return tiempo;
}

function oficial_costeCentroTarea(codTipoCentro:String, referencia:String, iTarea:Number, iLote:Number, codCentro:String):Number
{
	var util:FLUtil;
	var tiempo:Number;

	var tiempoXML:String;
	var xmlTarea:FLDomNode = this.iface.tareaMemo[iTarea]["xmltarea"];
	if (xmlTarea) {
		tiempoXML = xmlTarea.toElement().attribute("Tiempo");
	}
	if (tiempoXML != "") {
		tiempo = parseFloat(xmlTarea.toElement().attribute("Tiempo"));
	} else {
		var qryCostes:FLSqlQuery = new FLSqlQuery;
		qryCostes.setTablesList("pr_costestarea");
		qryCostes.setSelect("costeinicial,costeunidad");
		qryCostes.setFrom("pr_costestarea");
		qryCostes.setForwardOnly(true);
		qryCostes.setWhere("codtipocentro = '" + codTipoCentro + "' AND idtipotareapro = " + this.iface.tareaMemo[iTarea]["idtipotareapro"] + " AND referencia = '" + referencia + "'");
	
		if (!qryCostes.exec())
			return -1;
	
		if (!qryCostes.first()) {
			qryCostes.setWhere("codtipocentro = '" + codTipoCentro + "' AND idtipotareapro = " + this.iface.tareaMemo[iTarea]["idtipotareapro"] + " AND referencia IS NULL");
			if (!qryCostes.exec())
				return -1;
	
			if (!qryCostes.first()) {
				return -1;
			}
		}
	
		var costeFijo:Number = parseFloat(qryCostes.value("costeinicial"));
		if (!costeFijo || isNaN(costeFijo))
			costeFijo = 0;
	
		var costeUnidad:Number = parseFloat(qryCostes.value("costeunidad"));
		if (!costeUnidad || isNaN(costeUnidad))
			costeUnidad = 0;
	
		tiempo = costeFijo + (costeUnidad * this.iface.loteMemo[iLote]["cantidad"]);
	}
	tiempo = flcolaproc.iface.pub_convertirTiempoMS(tiempo, this.iface.tareaMemo[iTarea]["idproceso"]);
	if (isNaN(tiempo)) {
		tiempo = 0;
	}

	return tiempo;
}

/** \D Pasa el tiempo a milisegundos. Función a sobrecargar para calcular los milisegundos en función de la unidad en la que trabaja cada centro de coste. Por defecto, se convierte de minutos a milisegundos
@param	tiempo: Tiempo en minutos
@param	codCentro: Código de centro
@return	Tiempo en milisegundos
\end */
function oficial_convetirTiempoMS(tiempo:Number, codCentro:String):Number
{
	var resultado:Number;
	resultado = tiempo * 60000;
	return resultado;
}

/** \D Suma el tiempo en milisegundos a una fecha, teniendo en cuena el horario del centro de coste
@param	fechaInicio: Fecha inicial
@param	tiempo: Tiempo en ms
@param	codCentro: Código de centro
@return	Fecha final
\end */
function oficial_sumarTiempo(fecha:Date, tiempo:Number, codCentro:String):Date
{
	if (!fecha)
		return false;
	var tiempoInicio:Number = fecha.getTime(); //Date.parse(fecha);

	var fechaFin:Date = this.iface.buscarSiguienteTiempoFin(fecha);

	if (!fechaFin)
		return false;
	var tiempoFin:Number = fechaFin.getTime();

	var tiempoAux:Number = tiempoFin - tiempoInicio;

	if (tiempoAux >= tiempo) {
		tiempoFin = tiempoInicio + tiempo;
		fechaFin = new Date(tiempoFin);
		return fechaFin;
	}
	
	tiempo = tiempo - tiempoAux;

	var fechaInicio:Date = this.iface.buscarSiguienteTiempoInicio(fechaFin);
	if (!fechaInicio)
		return false;
	return this.iface.sumarTiempo(fechaInicio,tiempo,codCentro);
	
// 	var fecha:Date = new Date(tiempoFin);
// 	return fecha;
}

function oficial_buscarSiguienteTiempoFin(fecha):Date
{
	var util:FLUtil;

	var d:Date = new Date( fecha.getYear(), fecha.getMonth(), fecha.getDate());
	var tiempoFinManana:Date = util.sqlSelect("pr_calendario","horasalidamanana","fecha = '" + d + "'");
	if (!tiempoFinManana) {
		MessageBox.warning(util.translate("scripts", "No hay definido ningún registro en el calendario para el día %1").arg(util.dateAMDtoDMA(d)), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
//	tiempoFinManana.getTime(Date.parse(d.toString().left(11) + tiempoFinManana.toString().right(8)));
	tiempoFinManana = tiempoFinManana.setYear(d.getYear());
	tiempoFinManana = tiempoFinManana.setMonth(d.getMonth());
	tiempoFinManana = tiempoFinManana.setDate(d.getDate());
	
	var comparar:Number = this.iface.compararHoras(fecha,tiempoFinManana);
	if (comparar == 2){
		return tiempoFinManana;
	}

	var tiempoFinTarde:Date = util.sqlSelect("pr_calendario","horasalidatarde","fecha = '" + d + "'");
//	tiempoFinTarde.getTime(Date.parse(d.toString().left(11) + tiempoFinTarde.toString().right(8)));
	tiempoFinTarde = tiempoFinTarde.setYear(d.getYear());
	tiempoFinTarde = tiempoFinTarde.setMonth(d.getMonth());
	tiempoFinTarde = tiempoFinTarde.setDate(d.getDate());

	comparar = this.iface.compararHoras(fecha,tiempoFinTarde);
	if (comparar == 2){
debug("tiempoFinTarde" + tiempoFinTarde)
		return tiempoFinTarde;
	}

	var fecha2:Date = new Date(fecha.getYear(), fecha.getMonth(), fecha.getDate());

	var qry:FLSqlQuery = new FLSqlQuery();
	qry.setTablesList("pr_calendario");
	qry.setSelect("horasalidamanana,horasalidatarde");
	qry.setFrom("pr_calendario")
	
	var fechaAux:Date = new Date(fecha2.getYear(), fecha2.getMonth(), fecha2.getDate());
	do {
		fechaAux = util.addDays(fechaAux, 1);
		
		qry.setWhere("fecha = '" + fechaAux + "'");
	
		if (!qry.exec())
			return false;

		if (!qry.first()) {
			MessageBox.warning(util.translate("scripts", "No se ha encontrado un registro para el día %1 en el Calendario Laboral").arg(util.dateAMDtoDMA(fechaAux)), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}

		if (qry.value("horaentradamanana") == qry.value("horasalidamanana")) {
			fecha2 = false;
		} else {
			fecha2 = qry.value("horasalidamanana");
//		fecha2.getTime(Date.parse(fechaAux.toString().left(11) + fecha2.toString().right(8)));
			fecha2 = fecha2.setYear(fechaAux.getYear());
			fecha2 = fecha2.setMonth(fechaAux.getMonth());
			fecha2 = fecha2.setDate(fechaAux.getDate());
		}
	
		if (!fecha2) {
			if (qry.value("horaentradatarde") == qry.value("horasalidatarde")) {
				fecha2 = false;
			} else {
				fecha2 = qry.value("horasalidatarde");
				//fecha2.getTime(Date.parse(fechaAux.toString().left(11) + fecha2.toString().right(8)));
				fecha2 = fecha2.setYear(fechaAux.getYear());
				fecha2 = fecha2.setMonth(fechaAux.getMonth());
				fecha2 = fecha2.setDate(fechaAux.getDate());
			}
		}

	} while (!fecha2);
debug("FIN Encontrada " + fecha2);
	return fecha2;
}

function oficial_buscarSiguienteTiempoInicio(fecha):Date
{
debug("XXXXXXXXXXXXXXXXXXXXXXX");
debug("oficial_buscarSiguienteTiempoInicio para " + fecha);
	var util:FLUtil;
	if (!fecha)
		return false;

	var d:Date = new Date( fecha.getYear(), fecha.getMonth(), fecha.getDate());
	var tiempoInicioManana:Date = util.sqlSelect("pr_calendario","horaentradamanana","fecha = '" + d + "'");
	if (!tiempoInicioManana) {
		MessageBox.warning(util.translate("scripts", "No hay definido ningún registro en el calendario para el día %1").arg(util.dateAMDtoDMA(d)), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
//	tiempoInicioManana.getTime(Date.parse(d.toString().left(11) + tiempoInicioManana.toString().right(8)));
	tiempoInicioManana = tiempoInicioManana.setYear(d.getYear());
	tiempoInicioManana = tiempoInicioManana.setMonth(d.getMonth());
	tiempoInicioManana = tiempoInicioManana.setDate(d.getDate());
	
	var comparar:Number = this.iface.compararHoras(fecha,tiempoInicioManana);
	if (comparar == 2){
		return tiempoInicioManana;
	}

	var tiempoInicioTarde:Date = util.sqlSelect("pr_calendario","horaentradatarde","fecha = '" + d + "'");
//	tiempoInicioTarde.getTime(Date.parse(d.toString().left(11) + tiempoInicioTarde.toString().right(8)));
	tiempoInicioTarde = tiempoInicioTarde.setYear(d.getYear());
	tiempoInicioTarde = tiempoInicioTarde.setMonth(d.getMonth());
	tiempoInicioTarde = tiempoInicioTarde.setDate(d.getDate());	

	comparar = this.iface.compararHoras(fecha,tiempoInicioTarde);
	if (comparar == 2){
		return tiempoInicioTarde;
	}

	var fecha2:Date = new Date(fecha.getYear(), fecha.getMonth(), fecha.getDate());

	var qry:FLSqlQuery = new FLSqlQuery();
	qry.setTablesList("pr_calendario");
	qry.setSelect("horaentradamanana,horasalidamanana,horaentradatarde,horasalidatarde");
	qry.setFrom("pr_calendario")
	var fechaAux:Date = new Date(fecha2.getYear(), fecha2.getMonth(), fecha2.getDate());
	do {
		fechaAux = util.addDays(fechaAux, 1);
		//var fechaAux:Date = new Date(fecha2.getYear(), fecha2.getMonth(), fecha2.getDate());

		qry.setWhere("fecha = '" + fechaAux + "'");
	
		if (!qry.exec())
			return false;

		if (!qry.first()) {
			MessageBox.warning(util.translate("scripts", "No se ha encontrado un registro para el día %1 en el Calendario Laboral").arg(util.dateAMDtoDMA(fechaAux)), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
		if (qry.value("horaentradamanana") == qry.value("horasalidamanana")) {
			fecha2 = false;
		} else {
			fecha2 = qry.value("horaentradamanana");
//			fecha2.getTime(Date.parse(fechaAux.toString().left(11) + fecha2.toString().right(8)));
			fecha2 = fecha2.setYear(fechaAux.getYear());
			fecha2 = fecha2.setMonth(fechaAux.getMonth());
 			fecha2 = fecha2.setDate(fechaAux.getDate());
		}
// 		fecha2 = fecha2.setYear(fechaAux.getYear());
// 		fecha2 = fecha2.setMonth(fechaAux.getMonth());
// 		fecha2 = fecha2.setDate(fechaAux.getDate());
	
		if (!fecha2) {
			if (qry.value("horaentradatarde") == qry.value("horasalidatarde")) {
				fecha2 = false;
			} else {
				fecha2 = qry.value("horaentradatarde");
// 				fecha2 = Date.parse(fechaAux.toString().left(11) + fecha2.toString().right(8));
				fecha2 = fecha2.setYear(fechaAux.getYear());
				fecha2 = fecha2.setMonth(fechaAux.getMonth());
				fecha2 = fecha2.setDate(fechaAux.getDate());
			}
		}
	} while (!fecha2);
debug("Encontrada " + fecha2);
	return fecha2;
}

/** \D Compara dos fechs
@param	fecha1: Fecha 
@param	fecha2: Fecha 
@return	0 Si son iguales, 1 si la primera es mayor, 2 si la segunda es mayor
\end */
function oficial_compararFechas(fecha1:Date, fecha2:Date):Number
{
	if (!fecha1 || fecha1 == "" || !fecha2 || fecha2 == "")
		return false;

	if (fecha1.getTime() > fecha2.getTime())
		return 1;
	else if (fecha2.getTime() > fecha1.getTime())
		return 2;
	else 
		return 0;
}

function oficial_iniciarCentrosCoste():Boolean
{
	var util:FLUtil = new FLUtil;

	var qryCentros:FLSqlQuery = new FLSqlQuery;
	with (qryCentros) {
		setTablesList("pr_centroscoste");
		setSelect("codcentro");
		setFrom("pr_centroscoste");
		setWhere("1 = 1");
		setForwardOnly(true);
	}
	if (!qryCentros.exec())
		return false;

	var iCentro:Number = this.iface.centroMemo.length;
	var maxFechaPrev:Date;
	var maxFechaPrevS:String;
	var maxFecha:String;
	var hoy:Date;
	while (qryCentros.next()) {
		this.iface.centroMemo[iCentro] = this.iface.nuevoCentroCoste();
		this.iface.centroMemo[iCentro]["codcentro"] = qryCentros.value("codcentro");
		this.iface.centroMemo[iCentro]["codtipocentro"] = qryCentros.value("codtipocentro");
		this.iface.centroMemo[iCentro]["idtipotareapro"] = qryCentros.value("idtipotareapro");
		this.iface.centroMemo[iCentro]["costeinicial"] = qryCentros.value("costeinicial");
		this.iface.centroMemo[iCentro]["costeunidad"] = qryCentros.value("costeunidad");

		//maxFechaPrev = util.sqlSelect("pr_tareas", "MAX(diafin)", "codcentro = '" + qryCentros.value("codcentro") + "'");
		maxFechaPrevS = util.sqlSelect("pr_tareas", "MAX(fechafinprev)", "codcentro = '" + qryCentros.value("codcentro") + "'");
// debug("MFP = " + maxFechaPrevS);
// debug("CODCENTRO = " + qryCentros.value("codcentro"));
		hoy = new Date;
		if (maxFechaPrevS) {
			maxFechaPrev = new Date(Date.parse(maxFechaPrevS));
			if (util.daysTo(maxFechaPrev, hoy) < 0)
				this.iface.centroMemo[iCentro]["fechainicio"] = hoy;
			else
				this.iface.centroMemo[iCentro]["fechainicio"] = maxFechaPrev;
		} else {
			this.iface.centroMemo[iCentro]["fechainicio"] = hoy;
		}
// debug("FINICIO CC = " + this.iface.centroMemo[iCentro]["fechainicio"]);
		iCentro++;
	}
	return true;
}

function oficial_cargarTareasLote(datosLote:Array):Boolean
{
debug("oficial_cargarTareasLote");
	var util:FLUtil = new FLUtil;

	var idProceso:String = datosLote["idProceso"];
	var codLote:String = datosLote["codLote"];
	var cantidad:String = datosLote["cantidad"];
	var referencia:String = datosLote["referencia"];

	var idTipoProceso:String = util.sqlSelect("pr_procesos", "idtipoproceso", "idproceso = " + idProceso);
	if (!idTipoProceso) {
		MessageBox.warning(util.translate("scripts", "Error al obtener el tipo de proceso asociado al lote %1").arg(codLote), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var contenidoProceso:String = util.sqlSelect("pr_procesos", "xmlparametros", "idproceso = " + idProceso);
	var xmlProceso:FLDomNode;
	if (contenidoProceso && contenidoProceso != "") {
		var xmlLote:FLDomDocument;
		if (!xmlLote.setContent(contenidoProceso)) {
			MessageBox.warning(util.translate("scripts", "Error al leer el contenido XML de parámetros del proceso %1").arg(idProceso), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
		xmlProceso = xmlLote.firstChild();
	}

	var iLote:Number = this.iface.loteMemo.length;
	this.iface.loteMemo[iLote] = this.iface.nuevoLote();
	this.iface.loteMemo[iLote]["codlote"] = codLote;
	this.iface.loteMemo[iLote]["cantidad"] = cantidad;
	this.iface.loteMemo[iLote]["referencia"] = referencia;
	this.iface.loteMemo[iLote]["idproceso"] = idProceso;
	this.iface.loteMemo[iLote]["idtipoproceso"] = idTipoProceso;
	this.iface.loteMemo[iLote]["xmlproceso"] = xmlProceso;
	this.iface.loteMemo[iLote]["color"] = this.iface.colorLote[this.iface.iColorLote++];
	if (this.iface.iColorLote >= this.iface.colorLote.length)
		this.iface.iColorLote = 0;

	var qryTareas:FLSqlQuery = new FLSqlQuery();
	with (qryTareas) {
		setTablesList("pr_tipostareapro");
		setSelect("idtipotareapro,idtipotarea");
		setFrom("pr_tipostareapro");
		setWhere("idtipoproceso = '" + idTipoProceso + "'");
		setForwardOnly(true);
	}
	if (!qryTareas.exec())
		return false;

	var indice:Number;
	var idTipoTareaPro:String;
	var xmlTarea:FLDomNode;
debug("oficial_cargarTareasLote TAREAS");
	while (qryTareas.next()) {
		idTipoTareaPro = qryTareas.value("idtipotareapro");
debug("oficial_cargarTareasLoteS " + idTipoTareaPro);
		indice = this.iface.tareaMemo.length;
		this.iface.tareaMemo[indice] = this.iface.nuevaTarea();
		this.iface.tareaMemo[indice]["codlote"] = codLote;
		this.iface.tareaMemo[indice]["idtipotareapro"] = idTipoTareaPro;
		this.iface.tareaMemo[indice]["idproceso"] = idProceso;
		this.iface.tareaMemo[indice]["idtipotarea"] = qryTareas.value("idtipotarea");
		this.iface.tareaMemo[indice]["cantidad"] = cantidad;

		if (xmlProceso) {
			xmlTarea = this.iface.dameNodoXML(xmlProceso, "Tareas/Tarea[@IdTipoTareaPro=" + idTipoTareaPro + "]");
			if (xmlTarea) {
				this.iface.tareaMemo[indice]["xmltarea"] = xmlTarea;
			}
			else {
			debug("No hay tarea");
			}
		} else {
debug("No hay proceso");
		}
	}
	return true;
}

function oficial_establecerSecuencias():Boolean
{
	var codLote:String;
	var idTipoTarea:String;
	var iTarea:Number = 0;
	var totalTareas:Number = this.iface.tareaMemo.length;
	for (var iLote:Number = 0; iLote < this.iface.loteMemo.length; iLote++) {
		codLote = this.iface.loteMemo[iLote]["codlote"];
		while (iTarea < totalTareas && this.iface.tareaMemo[iTarea]["codlote"] == codLote) {
			if (!this.iface.establecerSecuenciasTarea(iTarea, iLote))
				return false;
			iTarea++;
		}
	}
	if (!this.iface.restriccionesConsumo())
		return false;

	return true;
}

function oficial_restriccionesConsumo():Boolean
{
	var util:FLUtil = new FLUtil;
	var codLote:String;
	var idProceso:Number;
	var idTipoTareaPro:String;
	var idProceso:Number;
	var iTarea:Number;
	var iLoteComsumo:Number;
	var estadoLoteConsumo:String;
	var codLoteConsumo:Number;
	var qryConsumos:FLSqlQuery = new FLSqlQuery;
	

	for (iLote = 0; iLote < this.iface.loteMemo.length; iLote++) {
		codLote = this.iface.loteMemo[iLote]["codlote"];
		idProceso = this.iface.loteMemo[iLote]["idproceso"];
		with (qryConsumos) {
			setTablesList("movistock");
			setSelect("ms.codlote, a.idtipoproceso, ac.idtipotareapro");
			setFrom("movistock ms INNER JOIN articuloscomp ac ON ms.idarticulocomp = ac.id INNER JOIN articulos a ON ac.refcomponente = a.referencia");
			setWhere("ms.codloteprod = '" + codLote + "' AND ms.idproceso = " + idProceso + " AND a.fabricado = true");
			setForwardOnly(true);
		}
		if (!qryConsumos.exec())
			return false;
	
		while (qryConsumos.next()) {
			idTipoTareaPro = qryConsumos.value("ac.idtipotareapro");
			iTarea = this.iface.buscarTarea(codLote, idTipoTareaPro);
			if (iTarea < 0) {
				MessageBox.warning(util.translate("scripts", "Restricciones de consumo: Error al buscar la tarea:\n%1\nAsiciada al lote %2.").arg(this.iface.datosTarea(idTipoTareaPro)).arg(codLote), MessageBox.Ok, MessageBox.NoButton);
				return false;
			}

			codLoteConsumo = qryConsumos.value("ms.codlote");
			idProceso = util.sqlSelect("pr_procesos", "idproceso", "idtipoproceso = '" + qryConsumos.value("a.idtipoproceso") + "' AND idobjeto = '" + codLoteConsumo + "'");
			if (idProceso && !isNaN(idProceso)) {
	///// POR HACER
			} else {
				iLoteComsumo = this.iface.buscarLote(codLoteConsumo);
				estadoLoteConsumo = util.sqlSelect("lotesstock","estado","codlote = '" + codLoteConsumo + "'");
/// Controlar que si el lote no está terminado esté en la orden y asociado a un proceso de tipo Fabricación
// 				if (estadoLoteConsumo != "TERMINADO"){
// 					if (iLoteComsumo < 0) {
// 						MessageBox.warning(util.translate("scripts", "Para fabricar el lote %1 es necesario tener disponible el lote %2.\nDicho lote no está fabricado ni incluido en esta orden.").arg(codLote).arg(codLoteConsumo), MessageBox.Ok, MessageBox.NoButton);
// 						return false;
// 					}
// 				}
				var tareasFin:Array = this.iface.tareasFinales(codLoteConsumo);
				if (tareasFin.length > 0) {
					for (var i:Number = 0; i < tareasFin.length; i++) {
						if (!this.iface.establecerSecuencia(tareasFin[i], iTarea))
							return false;
				
					}
				}
			}
		}
	}
	return true;
}

function oficial_establecerSecuenciasTarea(iTarea:Number, iLote:Number):Boolean
{
	var util:FLUtil = new FLUtil;
	var qrySucesoras:FLSqlQuery = new FLSqlQuery();
	var sucesora:Array;
	var iSucesora:Number;
	var qryPredecesoras:FLSqlQuery = new FLSqlQuery();
	var predecesora:Array;
	var iPredecesora:Number;
	
	var codLote:String = this.iface.loteMemo[iLote]["codlote"];
	var idTipoTareaPro:String = this.iface.tareaMemo[iTarea]["idtipotareapro"];

	with (qrySucesoras) {
		setTablesList("pr_secuencias");
		setSelect("tareafin");
		setFrom("pr_secuencias");
		setWhere("tareainicio = " + idTipoTareaPro);
		setForwardOnly(true);
	}
	if (!qrySucesoras.exec())
		return false; 

	var iTareaSucesora:Number;
	while (qrySucesoras.next()) {
		iTareaSucesora = this.iface.buscarTarea(codLote, qrySucesoras.value("tareafin"));
		if (iTareaSucesora < 0) {
			MessageBox.warning(util.translate("scripts", "Ha habido un error al buscar la tarea:\n%1\nAsociada al lote %2").arg(this.iface.datosTarea(qrySucesoras.value("tareafin"))).arg(codLote), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
		if (!this.iface.establecerSecuencia(iTarea, iTareaSucesora))
			return false;
	}
	return true;
}

function oficial_tareasFinales(codLote:String):Array
{
	var tareasFinales:Array = [];
	var totalTareas:Number = this.iface.tareaMemo.length;
	for (var iTarea:Number = 0; iTarea < totalTareas; iTarea++) {
		if (this.iface.tareaMemo[iTarea]["codlote"] == codLote && this.iface.tareaMemo[iTarea]["sucesora"].length == 0) {
			tareasFinales[tareasFinales.length] = iTarea;
		}
	}
// debug(tareasFinales);
	return tareasFinales;
}

function oficial_establecerSecuencia(iTareaInicial:Number, iTareaFinal:Number):Boolean
{
	var iSucesora:Number = this.iface.tareaMemo[iTareaInicial]["sucesora"].length;
	this.iface.tareaMemo[iTareaInicial]["sucesora"][iSucesora] = iTareaFinal;

	var iPredecesora:Number = this.iface.tareaMemo[iTareaFinal]["predecesora"].length;
	this.iface.tareaMemo[iTareaFinal]["predecesora"][iPredecesora] = iTareaInicial;

	return true;
}

function oficial_buscarTarea(codLote:String, idTipoTareaPro:String):Number
{
	var i:Number;
	for (i = 0; i < this.iface.tareaMemo.length; i++) {
		if (this.iface.tareaMemo[i]["codlote"] == codLote && this.iface.tareaMemo[i]["idtipotareapro"] == idTipoTareaPro)
			return i;
	}
	return -1;
}

function oficial_buscarLote(codLote:String):Number
{
	var i:Number;
	for (i = 0; i < this.iface.loteMemo.length; i++) {
		if (this.iface.loteMemo[i]["codlote"] == codLote)
			return i;
	}
	return -1;
}

function oficial_buscarProceso(idProceso:String):Number
{
	var i:Number;
	for (i = 0; i < this.iface.loteMemo.length; i++) {
		if (this.iface.loteMemo[i]["idproceso"] == idProceso)
			return i;
	}
	return -1;
}

function oficial_buscarCentroCoste(codCentro:String):Number
{
	var i:Number;
	for (i = 0; i < this.iface.centroMemo.length; i++) {
		if (this.iface.centroMemo[i]["codcentro"] == codCentro)
			return i;
	}
	return -1;
}

/** \D Busca la mínima fecha de inicio de entre todas las tareas consideradas
@return fecha mínima
\end */
function oficial_buscarFechaMinimaTarea():Date
{
	var fechaMin:Date = false;
	for (var iTarea:Number = 0; iTarea < this.iface.tareaMemo.length; iTarea++) {
debug(iTarea);
debug(this.iface.tareaMemo[iTarea]["fechafin"]);

		if (!fechaMin) {
			fechaMin = this.iface.tareaMemo[iTarea]["fechainicio"];
		} else {
			if (this.iface.compararFechas(fechaMin, this.iface.tareaMemo[iTarea]["fechainicio"]) == 1) {
				fechaMin = this.iface.tareaMemo[iTarea]["fechainicio"];
			}
		}
	}
	var ret:Date = new Date(fechaMin.getTime());
	return ret;
}

/** \D Busca la máxima fecha de fin de entre todas las tareas consideradas
@return fecha máxima
\end */
function oficial_buscarFechaMaximaTarea():Date
{
	var fechaMax:Date = false;
	for (var iTarea:Number = 0; iTarea < this.iface.tareaMemo.length; iTarea++) {
debug(iTarea);
debug(this.iface.tareaMemo[iTarea]["fechafin"]);
		if (!fechaMax) {
			fechaMax = this.iface.tareaMemo[iTarea]["fechafin"];
		} else {
			if (this.iface.compararFechas(fechaMax, this.iface.tareaMemo[iTarea]["fechafin"]) == 2) {
				fechaMax = this.iface.tareaMemo[iTarea]["fechafin"];
			}
		}
	}
	var ret:Date = new Date(fechaMax.getTime());
	return ret;
}


/** \D Construye un array con los índices de las tareas asociadas a un centro de coste ordenadas por fecha de inicio
@param codCentro: Centro en el que se buscan las tareas
@return	array de índices ordenado
\end */
// function oficial_tareasCentroCoste(codCentro:String):Array
// {
// 	var tareas:Array = [];
// 	var fechaNueva:Date;
// 	var fechaTarea:Date;
// 	var iTareaMod:Number;
// 	var longTareas:Number;
// 	for (var iTarea:Number = 0; iTarea < this.iface.tareaMemo.length; iTarea++) {
// 		if (this.iface.tareaMemo[iTarea]["codcentrocoste"] != codCentro)
// 			continue;
// 		fechaNueva = this.iface.tareaMemo[iTarea]["fechainicio"];
// 		var iTareaCoste:Number;
// 		for (iTareaCoste = 0; iTareaCoste < tareas.length; iTareaCoste++) {
// 			fechaTarea = this.iface.tareaMemo[tareas[iTareaCoste]]["fechainicio"];
// 			if (this.iface.compararFechas(fechaTarea, fechaNueva) == 1)
// 				break;
// 		}
// 		longTareas = tareas.length;
// 		for (var iTareaCam:Number = iTareaCoste + 1; iTareaCam <= longTareas; iTareaCam++) {
// 			tareas[iTareaCam] = tareas[iTareaCam - 1]
// 		}
// 		tareas[iTareaCoste] = iTarea;
// 	}
// 	return tareas;
// }

/** \D Construye un array con los índices de las tareas asociadas a un centro de coste ordenadas por fecha de inicio
@param codCentro: Centro en el que se buscan las tareas
@return	array de índices ordenado
\end */
function oficial_tareasCentroCoste(codCentro:String):Array
{
	var tareas:Array = [];
	var fechaNueva:Date;
	var fechaTarea:Date;
	var iTareaMod:Number;
	var longTareas:Number;
	for (var iTarea:Number = 0; iTarea < this.iface.tareaMemo.length; iTarea++) {
		if (this.iface.tareaMemo[iTarea]["codcentrocoste"] != codCentro) {
			continue;
		}
		fechaNueva = this.iface.tareaMemo[iTarea]["fechainicio"];
		var iTareaCoste:Number;
		for (iTareaCoste = 0; iTareaCoste < tareas.length; iTareaCoste++) {
			fechaTarea = this.iface.tareaMemo[tareas[iTareaCoste]]["fechainicio"];
			if (this.iface.compararFechas(fechaTarea, fechaNueva) == 1) {
				break;
			}
		}
		longTareas = tareas.length;
		for (var iTareaCam:Number = longTareas; iTareaCam >= iTareaCoste + 1; iTareaCam--) {
			tareas[iTareaCam] = tareas[iTareaCam - 1]
		}
		tareas[iTareaCoste] = iTarea;
	}
	return tareas;
}

function oficial_nuevaTarea():Array
{
	var tarea:Array = [];
	tarea["codlote"] = false;
	tarea["idtipotareapro"] = false;
	tarea["predecesora"] = [];
	tarea["sucesora"] = [];
	tarea["codcentrocoste"] = false;
	tarea["fechainicio"] = false;
	tarea["duracion"] = false;
	tarea["fechafin"] = false;
	tarea["cantidad"] = false;
	tarea["asignada"] = false;
	tarea["xmltarea"] = false;

	return tarea;
}

function oficial_nuevoLote():Array
{
	var lote:Array = [];
	lote["codlote"] = false;
	lote["cantidad"] = false;
	lote["referencia"] = false;
	lote["idtipoproceso"] = false;
	lote["color"] = false;
	lote["xmlproceso"] = false;

	return lote;
}

function oficial_nuevoCentroCoste():Array
{
	var centro:Array = [];
	centro["codcentro"] = false;
	centro["codtipocentro"] = false;
	centro["idtipotareapro"] = false;
	centro["costeinicial"] = false;
	centro["costeunidad"] = false;
	centro["fechainicio"] = false;

	return centro;
}

function oficial_datosTarea(idTipoTareaPro:String):String
{
	var util:FLUtil = new FLUtil;
	var texto:String = "";
	var qryDatos:FLSqlQuery = new FLSqlQuery;
	with (qryDatos) {
		setTablesList("pr_tipostareapro");
		setSelect("idtipotarea, descripcion, idtipoproceso");
		setFrom("pr_tipostareapro");
		setWhere("idtipotareapro = " + idTipoTareaPro);
		setForwardOnly(true);
	}
	if (!qryDatos.exec())
		return false;

	if (!qryDatos.first())
		return false;
	
	texto = util.translate("scripts", "Tarea %1: %2 (Proceso %3)").arg(qryDatos.value("idtipotarea")).arg(qryDatos.value("descripcion")).arg(qryDatos.value("idtipoproceso"));

	return texto;
}

/** \D Actualiza las fechas y horas desde y hasta de ejecución prevista de las tareas del proceso asociado a un lote de fabricación
@param	idProceso: Identificador del proceso
@param	codLote: Código del lote
@return true si la función termina correctamente, false en caso contrario
\end */
function oficial_actualizarTareasProceso(idProceso:String, codLote:String,mostrarProgreso:Boolean):Boolean
{
// debug("ATP");
	var util:FLUtil = new FLUtil;
	var fechaInicio:String;
	var horaInicio:String;
	var fechaFin:String;
	var horaFin:String;
	var fechaAux:Date;
	var idTipoTareaPro:String;
	var codCentro:String;
	var tiempoPrevisto:String;
	if (this.iface.curTareas_)
		delete this.iface.curTareas_;
	this.iface.curTareas_ = new FLSqlCursor("pr_tareas");

	if(mostrarProgreso)
		util.createProgressDialog(util.translate("scripts", "Actualizando tareas..."), this.iface.tareaMemo.length);

	for (var iTarea:Number = 0; iTarea < this.iface.tareaMemo.length; iTarea++) {
		if(mostrarProgreso)
			util.setProgress(iTarea);
		if (this.iface.tareaMemo[iTarea]["saltada"]) {
			continue;
		}
		if (this.iface.tareaMemo[iTarea]["idproceso"] != idProceso)
			continue;
		idTipoTareaPro = this.iface.tareaMemo[iTarea]["idtipotareapro"];
		codCentro = this.iface.tareaMemo[iTarea]["codcentrocoste"];
		fechaInicio = this.iface.tareaMemo[iTarea]["fechainicio"].toString().left(10);
		horaInicio = this.iface.tareaMemo[iTarea]["fechainicio"].toString().right(8);
		fechaFin = this.iface.tareaMemo[iTarea]["fechafin"].toString().left(10);
		horaFin = this.iface.tareaMemo[iTarea]["fechafin"].toString().right(8);
		
		var s:Number = Math.ceil(this.iface.tareaMemo[iTarea]["duracion"]);
		tiempoPrevisto = flcolaproc.iface.pub_convertirTiempoProceso(s, idProceso);

debug("TP = " + tiempoPrevisto);
		this.iface.curTareas_.select("idproceso = " + idProceso + " AND idtipotareapro = " + idTipoTareaPro);
		if (!this.iface.curTareas_.first()) {
// 			MessageBox.warning(util.translate("scripts", "Error al obtener la tarea:\n%1 para el lote %2").arg(this.iface.datosTarea(idTipoTareaPro)).arg(codLote), MessageBox.Ok, MessageBox.NoButton);
// 			return false;
			continue;
		}
		with (this.iface.curTareas_) {
			setModeAccess(Edit);
			refreshBuffer();
// debug(fechaInicio);
			setValueBuffer("fechainicioprev", fechaInicio);
			setValueBuffer("horainicioprev", horaInicio);
			setValueBuffer("fechafinprev", fechaFin);
			setValueBuffer("horafinprev", horaFin);
			setValueBuffer("codcentro", codCentro);
			setValueBuffer("tiempoprevisto", tiempoPrevisto);
		}
		if (!this.iface.datosTareaActualizada(this.iface.tareaMemo[iTarea])) {
			if(mostrarProgreso)
				util.destroyProgressDialog();
			return false;
		}

		if (!this.iface.curTareas_.commitBuffer()) {
			if(mostrarProgreso)
				util.destroyProgressDialog();
			return false;
		}
	}

	if(mostrarProgreso)
		util.destroyProgressDialog();

	return true;
}

function oficial_datosTareaActualizada(tarea:Array):Boolean
{
	return true;
}

function oficial_limpiarMemoria()
{
	delete this.iface.tareaMemo;
	this.iface.tareaMemo = [];

	delete this.iface.loteMemo;
	this.iface.loteMemo = [];

	delete this.iface.centroMemo;
	this.iface.centroMemo = [];

	this.iface.colorLote = ["000000", "FF0000", "00FF00", "0000FF"];
	this.iface.iColorLote = 0;
}

function oficial_buscarPedidoFechaMinima(codLote:String, criterios:String):Array
{

	var util:FLUtil;
	var fechaMin:String = "";
	var fecha:String = "";
	var idPedido:Number;
	var datosPedido:Array = new Array();
	var hayDatos:Boolean = false;

	var qryFechaPedido:FLSqlQuery = new FLSqlQuery();
	with(qryFechaPedido) {
		setTablesList("lotesstock,lineaspedidoscli,pedidoscli");
		setSelect("MIN(p.fechasalida), p.codigo, p.nombrecliente");
		setFrom("movistock ms LEFT OUTER JOIN lineaspedidoscli lp ON ms.idlineapc = lp.idlinea LEFT OUTER JOIN pedidoscli p ON lp.idpedido = p.idpedido");
		setWhere("ms.estado = 'PTE' AND (ms.idproceso IS NULL OR ms.idproceso = 0) AND ms.codlote = '" + codLote + "' GROUP BY p.codigo, p.nombrecliente");
	}
// debug(qryFechaPedido.sql());
	if (!qryFechaPedido.exec())
		return false;

	if (qryFechaPedido.first()) {
		datosPedido["fecha"] = qryFechaPedido.value("MIN(p.fechasalida)");
		datosPedido["codigo"] = qryFechaPedido.value("p.codigo");
		datosPedido["nombreCliente"] = qryFechaPedido.value("p.nombrecliente");
		hayDatos = true;
	}

	var qryComponentes:FLSqlQuery = new FLSqlQuery();
	with(qryComponentes) {
		setTablesList("movistock,articulos");
		setSelect("ms.codloteprod");
		setFrom("movistock ms INNER JOIN articulos a ON ms.referencia = a.referencia");
		setWhere("ms.codlote = '" + codLote + "' AND (codloteprod IS NOT NULL OR codloteprod <> '') AND a.fabricado");
	}
	
	if (!qryComponentes.exec())
		return false;

	var datosPedidoComp:Array;
	while (qryComponentes.next()) {
		datosPedidoComp = this.iface.buscarPedidoFechaMinima(qryComponentes.value("ms.codloteprod"), criterios);
		if (!datosPedidoComp)
			continue;

		if (!hayDatos) {
			datosPedido["fecha"] = datosPedidoComp["fecha"];
			datosPedido["codigo"] = datosPedidoComp["codigo"];
			datosPedido["nombreCliente"] = datosPedidoComp["nombreCliente"];
			hayDatos = true;
		}
		else {
			switch (this.iface.compararFechas(datosPedidoComp["fecha"], datosPedido["fecha"])) {
				case 0:
				case 1: {
					break;
				}
				case 2: {
					datosPedido["fecha"] = datosPedidoComp["fecha"];
					datosPedido["codigo"] = datosPedidoComp["codigo"];
					datosPedido["nombreCliente"] = datosPedidoComp["nombreCliente"];
					break;
				}
			}
		}
	}

	if (!hayDatos)
		return false;

	return datosPedido;
}

/** \D
Da a elegir al usuario entre una serie de opciones
@param	opciones: Array con las n opciones a elegir
@return	El índice de la opción elegida si se pulsa Aceptar
		-1 si se pulsa Cancelar
		-2 si hay error
\end */
function oficial_elegirOpcion(opciones:Array):Number
{
		var util:FLUtil = new FLUtil();
		var dialog:Dialog = new Dialog;
		dialog.okButtonText = util.translate("scripts","Aceptar");
		dialog.cancelButtonText = util.translate("scripts","Cancelar");
		var bgroup:GroupBox = new GroupBox;
		dialog.add(bgroup);
		var rB:Array = [];
		for (var i:Number = 0; i < opciones.length; i++) {
				rB[i] = new RadioButton;
				bgroup.add(rB[i]);
				rB[i].text = opciones[i];
				if (i == 0)
						rB[i].checked = true;
				else
						rB[i].checked = false;
		}

		if(dialog.exec()) {
				for (var i:Number = 0; i < opciones.length; i++)
						if (rB[i].checked == true)
								return i;
		} else
				return -1;
}

function oficial_htmlPlanificacion():String
{
	var util:FLUtil = new FLUtil;
	var codCentro:String;
	var html:String = "<font size=\"1\"><table width=\"100%\" border=\"1\" cellspacing=\"0\">\n";
	var minFecha:Date = this.iface.buscarFechaMinimaTarea();
	var maxFecha:Date = this.iface.buscarFechaMaximaTarea();
	minFecha.setHours(0);
	minFecha.setMinutes(0);
	minFecha.setSeconds(0);
	maxFecha.setHours(23);
	maxFecha.setMinutes(59);
	maxFecha.setSeconds(59);
	var dias:Number = util.daysTo(minFecha, maxFecha);
	var qryCC:FLSqlQuery = new FLSqlQuery;
	with (qryCC) {
		setTablesList("pr_centroscoste");
		setSelect("codcentro");
		setFrom("pr_centroscoste");
		setWhere("1 = 1");
		setForwardOnly(true);
	}
	if (!qryCC.exec())
		return false;

	html += "\t<tr>";
	html += "<td width=\"20%\">" + "C.C." + "</td>";
	var numFechas:Number = 0;
	for (var iFecha:Date = minFecha; util.daysTo(iFecha, maxFecha) >= 0; iFecha = util.addDays(iFecha, 1)) {
		html += "<td>" + iFecha.getDate() + "</td>";
		numFechas++
	}
	html += "\t</tr>\n";
	while (qryCC.next()) {
		codCentro = qryCC.value("codcentro");
		html += "\t<tr>";
		html += "<td>" + codCentro + "</td>";
		html += "<td colspan=\"" + numFechas + "\">" + this.iface.htmlCentroCoste(codCentro, minFecha, maxFecha) + "</td>";

		html += "\t</tr>\n";
	}
	html += "\n</table></font>";
	
	return html;
}

/** \D Genera una línea html consistente en una tabla de una única fila en la que cada celda representa una tarea asignada al centro de coste
@param	codCentro: Centro de coste
@param	minFecha: Fecha mínima considerada
@param	maxFecha: Fecha máxima considerada
@return	html con la tabla
\end */
function oficial_htmlCentroCoste(codCentro:String, minFecha:Date, maxFecha:Date):String
{
	var util:FLUtil = new FLUtil;
	var html:String = "\n\t<font size=\"1\"><table width=\"100%\" height=\"100%\" cellspacing=\"0\" border=\"0\"><tr>\n";
	var tareasCentro:Array = this.iface.tareasCentroCoste(codCentro);
	var tiempoTotal:Number = maxFecha.getTime() - minFecha.getTime();
	var iTarea:Number;
	var fecha:Date = minFecha;
	var compFechas:Number;
	var porcentaje:Number;
	var tiempoTarea:Number;
	var tiempoHueco:Number;
	var iLote:Number;
	var color:String;
	for (var iTC:Number = 0; iTC < tareasCentro.length; iTC++) {
		iTarea = tareasCentro[iTC];
		
		compFechas = this.iface.compararFechas(fecha, this.iface.tareaMemo[iTarea]["fechainicio"]);
		switch (compFechas) {
			case 1: {
				MessageBox.warning(util.translate("scripts", "Error al mostrar las tareas del centro de coste %1:\nLas tareas se solapan").arg(codCentro), MessageBox.Ok, MessageBox.NoButton);
				return false;
				break;
			}
			case 2: {
				tiempoHueco = this.iface.tareaMemo[iTarea]["fechainicio"].getTime() - fecha.getTime();
				porcentaje = Math.round(tiempoHueco * 100 / tiempoTotal);
				html += "\t\t<td width=\"" + porcentaje + "%\">" + "<p><span style=\"font-size:7pt\"></span></p>" + "</td>\n";
				break;
			}
		}
		tiempoTarea = this.iface.tareaMemo[iTarea]["fechafin"].getTime() - this.iface.tareaMemo[iTarea]["fechainicio"].getTime();
		porcentaje = Math.round(tiempoTarea * 100 / tiempoTotal);
		html += "\t\t<td bgcolor=\"" + color +"\" width=\"" + porcentaje + "%\">" + "<p><span style=\"font-size:7pt\"></span></p>" + "</td>\n";

		fecha = this.iface.tareaMemo[iTarea]["fechafin"];
	}

	if (this.iface.compararFechas(maxFecha, fecha) == 1) {
		tiempoHueco = maxFecha.getTime() - fecha.getTime();
		porcentaje = Math.round(tiempoHueco * 100 / tiempoTotal);
		html += "\t\t<td width=\"" + porcentaje + "%\"><p><span style=\"font-size:7pt\"></span></p></td>\n";
	}
	html += "\t</tr></table></font>\n";
	return html;
}

function oficial_modificarEstadoOrden(codOrden:String):Boolean
{
	var util:FLUtil = new FLUtil;
	
	var estadoPrevio:String = util.sqlSelect("pr_ordenesproduccion", "estado", "codorden = '" + codOrden + "'");
	var estadoActual:String = "TERMINADA";

	if(util.sqlSelect("pr_procesos", "idproceso", "codordenproduccion = '"  + codOrden + "' AND estado <> 'TERMINADO'")) {
		if(util.sqlSelect("pr_procesos", "idproceso", "codordenproduccion = '"  + codOrden + "' AND estado <> 'PTE'"))
			estadoActual = "EN CURSO";
		else
			estadoActual = "PTE";
	}
// 	if (util.sqlSelect("pr_procesos", "idproceso", "codordenproduccion = '" + codOrden + "' AND estado = 'PTE'", "pr_procesos")) {
// 		estadoActual = "PTE";
// 	} else if (util.sqlSelect("pr_procesos", "idproceso", "codordenproduccion = '" + codOrden + "' AND estado = 'EN CURSO'", "pr_procesos")) {
// 		estadoActual = "EN CURSO";
// 	} else if (util.sqlSelect("pr_procesos", "idproceso", "codordenproduccion = '" + codOrden + "'", "pr_procesos")) {
// 		estadoActual = "TERMINADA";
// 	} else {
// 		estadoActual = "PTE";
// 	}

	if (estadoActual != estadoPrevio) {
		if (!util.sqlUpdate("pr_ordenesproduccion", "estado", estadoActual, "codorden = '" + codOrden + "'"))
			return false;
	}
	return true;
}
/** \C Buscar un atributo en un nodo y sus nodos hijos
@param	nodoPadre: Nodo que contiene el atributo (o los nodos hijos que lo contienen)
@param	ruta: Cadena que especifica la ruta a seguir para encontrar el atributo. Su formato es NodoPadre/NodoHijo/NodoNieto/.../Nodo@Atributo. Puede ser tan larga como sea necesario. Siempre se toma el primer nodo Hijo que tiene el nombre indicado.
@param	debeExistir: Si vale true la función devuelve false si no encuentra el atributo
@return	Valor del atributo o false si hay error
\end */
function oficial_dameAtributoXML(nodoPadre:FLDomNode, ruta:String, debeExistir:Boolean):String
{
	var util:FLUtil = new FLUtil;

	var valor:String;
	var nombreNodo:Array = ruta.split("/");
	var nombreAtributo:String;
	var nodoXML:FLDomNode = nodoPadre;
	var i:Number;
	var iAtributo:Number;
	for (i = 0; i < nombreNodo.length; i++) {
		iAtributo = nombreNodo[i].find("@");
		if (iAtributo > -1) {
			nombreAtributo = nombreNodo[i].right(nombreNodo[i].length - iAtributo - 1);
			nombreNodo[i] = nombreNodo[i].left(iAtributo);
		}
		if (nombreNodo[i] != "") {
			nodoXML = nodoXML.namedItem(nombreNodo[i]);
		}
		if (!nodoXML) {
			if (debeExistir) {
				MessageBox.warning(util.translate("scripts", "No se pudo leer el nodo de la ruta:\n%1.\nNo se encuentra el nodo <%2>").arg(ruta).arg(nombreNodo[i]), MessageBox.Ok, MessageBox.NoButton);
			}
			return false;
		}
	}

	valor = nodoXML.toElement().attribute(nombreAtributo);
	return valor;
}

/** \C Busca un nodo en un nodo y sus nodos hijos
@param	nodoPadre: Nodo que contiene el nodo a buscar (o los nodos hijos que lo contienen)
@param	ruta: Cadena que especifica la ruta a seguir para encontrar el atributo. Su formato es NodoPadre/NodoHijo/NodoNieto/.../Nodo. Puede ser tan larga como sea necesario. Siempre se toma el primer nodo Hijo que tiene el nombre indicado.
@param	debeExistir: Si vale true la función devuelve false si no encuentra el atributo
@return	Nodo buscado o false si hay error o no se encuentra el nodo
\end */
function oficial_dameNodoXML(nodoPadre:FLDomNode, ruta:String, debeExistir:Boolean):FLDomNode
{
	var util:FLUtil = new FLUtil;

	var valor:String;
	var nombreNodo:Array = ruta.split("/");
	var nodoXML:FLDomNode = nodoPadre;
	var i:Number;
	var nombreActual:String;
	var iInicioCorchete:Number
	for (i = 0; i < nombreNodo.length; i++) {
		nombreActual = nombreNodo[i];
		iInicioCorchete = nombreActual.find("[");
		if (iInicioCorchete > -1) {
			iFinCorchete = nombreActual.find("]");
			var condicion:String = nombreActual.substring(iInicioCorchete + 1, iFinCorchete);
			var paramCond:Array = condicion.split("=");
			if (!paramCond[0].startsWith("@")) {
				MessageBox.warning(util.translate("scripts", "Error al procesar la ruta XML %1 en %2").arg(ruta).arg(nombreActual), MessageBox.Ok, MessageBox.NoButton);
				return false;
			}
			nombreActual = nombreActual.left(iInicioCorchete);
			var atributo:String = paramCond[0].right(paramCond[0].length - 1);
			var nodoHijo:FLDomNode;
			for (nodoHijo = nodoXML.firstChild(); nodoHijo; nodoHijo = nodoHijo.nextSibling()) {
				if (nodoHijo.nodeName() == nombreActual && nodoHijo.toElement().attribute(atributo) == paramCond[1]) {
					break;
				}
			}
			if (nodoHijo) {
				nodoXML = nodoHijo;
			} else {
				if (debeExistir) {
					MessageBox.warning(util.translate("scripts", "No se encontró el nodo en la ruta ruta %1").arg(ruta), MessageBox.Ok, MessageBox.NoButton);
				}
				return false;
			}
		} else {
			nodoXML = nodoXML.namedItem(nombreActual)
			if (!nodoXML) {
				if (debeExistir) {
					MessageBox.warning(util.translate("scripts", "No se pudo leer el nodo de la ruta:\n%1.\nNo se encuentra el nodo <%2>").arg(ruta).arg(nombreNodo[i]), MessageBox.Ok, MessageBox.NoButton);
				}
				return false;
			}
		}
	}
	return nodoXML;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition visual */
/////////////////////////////////////////////////////////////////
//// PRODUCCION VISUAL //////////////////////////////////////////
function visual_asignarCentroCosteTarea(iTarea:Number):Boolean
{
	var util:FLUtil = new FLUtil;
	var codLote:String = this.iface.tareaMemo[iTarea]["codlote"];
	var idProceso:String = this.iface.tareaMemo[iTarea]["idproceso"];
	var iLote:Number;
	iLote = this.iface.buscarProceso(idProceso);
	if (iLote < 0) {
		MessageBox.warning(util.translate("scripts", "Error al buscar los datos del proceso %1").arg(idProceso), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var idTipoTareaPro:String = this.iface.tareaMemo[iTarea]["idtipotareapro"];
	var xmlTarea:FLDomNode = this.iface.tareaMemo[iTarea]["xmltarea"];
	var eTarea:FLDomElement;	
	if (xmlTarea) {
		eTarea = xmlTarea.toElement();
		if (eTarea.attribute("Estado") == "Saltada") {
			this.iface.tareaMemo[iTarea]["asignada"] = true;
			this.iface.tareaMemo[iTarea]["saltada"] = true;
			return true;
		}
	}
	this.iface.tareaMemo[iTarea]["saltada"] = false;
	
	var referencia:String = this.iface.loteMemo[iLote]["referencia"];

	var fechaMinTarea:Date = this.iface.fechaMinimaTarea(iTarea);

	var qryCentros:FLSqlQuery = new FLSqlQuery;
	if (eTarea && eTarea.attribute("CodTipoCentro") != "") {
		with (qryCentros) {
			setTablesList("pr_centroscoste");
			setSelect("codcentro, codtipocentro");
			setFrom("pr_centroscoste");
			setWhere("codTipoCentro = '" + eTarea.attribute("CodTipoCentro") + "'");
			setForwardOnly(true);
		}
	} else {
		with (qryCentros) {
			setTablesList("pr_costestarea,pr_centroscoste");
			setSelect("cc.codcentro, ct.codtipocentro");
			setFrom("pr_costestarea ct INNER JOIN pr_centroscoste cc ON ct.codtipocentro = cc.codtipocentro");
			setWhere("ct.idtipotareapro = " + idTipoTareaPro);
			setForwardOnly(true);
		}
	}
	if (!qryCentros.exec()) {
		return false;
	}

	var minFechaInicio:Date = false;
	var minFechaFin:Date = false;
	var minICentro:Number = -1;
	var minTiempo:Number;

	var fechaFin:Date;
	var fechaInicio:Date;
	var minCentro:String;
	var iCentro:Number;
	var dia:Date;
	var tiempo:Number;
	var costeFijo:Number;
	var costeUnidad:Number;
	var codCentro:String;
	var tiempoTotalTarea:Number;

	while (qryCentros.next()) {

		codCentro = qryCentros.value(0);
		iCentro = this.iface.buscarCentroCoste(codCentro);

		if (iCentro < 0) {
			MessageBox.warning(util.translate("scripts", "Error al buscar los datos del centro de coste %1").arg(codCentro), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}

		tiempo = this.iface.costeCentroTarea(qryCentros.value(1),referencia,iTarea,iLote,codCentro);
		if (tiempo == -2)
			return false;

		if (tiempo == -1)
			continue;
tiempo *= 1000; /// Paso a s
		tiempoTotalTarea = tiempo;
debug("Tiempo inicial " + tiempo);
		if (fechaMinTarea && this.iface.compararFechas(fechaMinTarea, this.iface.centroMemo[iCentro]["fechainicio"]) == 1) {
			fechaInicio = fechaMinTarea;
		} else {
			fechaInicio = this.iface.centroMemo[iCentro]["fechainicio"];
		}
		if (!util.sqlSelect("pr_calendario","fecha","1 = 1")) {
			MessageBox.warning(util.translate("scripts", "Antes de calcular el tiempo de finalización de la tarea debe generar el calendario laboral."), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
		var tiempoFinDia:Number = -1;
		var masDias:Boolean = true;
		tiempoFinDia = this.iface.calcularRestoDia(fechaInicio);;
debug("tiempoFinDia " + tiempoFinDia);
		if (tiempoFinDia > tiempo) {
			// Hay tiempo para hacerlo en un sólo día
			fechaFin = this.iface.sumarTiempo(fechaInicio, tiempo, codCentro);
		} else {
			// No hay tiempo para hacerlo en un sólo día
			fechaFin = new Date(fechaInicio.getTime());
			tiempo -= tiempoFinDia;
			var qryCalendario:FLSqlQuery = new FLSqlQuery;
			qryCalendario.setTablesList("pr_calendario");
			qryCalendario.setSelect("fecha,tiempo");
			qryCalendario.setFrom("pr_calendario");
			qryCalendario.setWhere("fecha > '" + fechaFin + "' ORDER BY fecha ASC");
			if (!qryCalendario.exec())
				return -1;
	
			var buscarSiguienteDia:Boolean = true;
			if (!qryCalendario.first())
				buscarSiguienteDia = false;
	
			while (buscarSiguienteDia) {
debug("tiempo = " + tiempo);
debug("tiempo = " + qryCalendario.value("fecha") + " = " + qryCalendario.value("tiempo"));
				if (parseFloat(qryCalendario.value("tiempo")) <= tiempo && tiempo > 0) {
					tiempo -= parseFloat(qryCalendario.value("tiempo"));
					fechaFin = qryCalendario.value("fecha");
					if(!qryCalendario.next())
						buscarSiguienteDia = false;
				}
				else
					buscarSiguienteDia = false;
			}
			fechaFin = this.iface.buscarSiguienteTiempoInicio(fechaFin);
	
			fechaFin = this.iface.sumarTiempo(fechaFin, tiempo, codCentro);
		}
		if (!fechaFin)
			return false;
		if (minFechaFin && this.iface.compararFechas(minFechaFin, fechaFin) == 2)
			continue;
		minFechaInicio = fechaInicio;
		minFechaFin = fechaFin;
		minCodCentro = codCentro;
		minTiempo = tiempoTotalTarea;
		minICentro = iCentro;
	}
	if (minICentro < 0) {
		MessageBox.warning(util.translate("scripts", "No se ha podido asignar centro de coste a la tarea:\n%1\nAsociada al lote %2").arg(this.iface.datosTarea(idTipoTareaPro)).arg(codLote), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	this.iface.tareaMemo[iTarea]["codcentrocoste"] = minCodCentro;
	this.iface.tareaMemo[iTarea]["fechainicio"] = minFechaInicio;
	this.iface.tareaMemo[iTarea]["fechafin"] = minFechaFin;

	this.iface.tareaMemo[iTarea]["duracion"] = minTiempo;
	this.iface.tareaMemo[iTarea]["asignada"] = true;
	this.iface.centroMemo[minICentro]["fechainicio"] = minFechaFin;

	return true;
}

/** \D Suma el tiempo en milisegundos a una fecha, teniendo en cuena el horario del centro de coste
@param	fechaInicio: Fecha inicial
@param	tiempo: Tiempo en ms
@param	codCentro: Código de centro
@return	Fecha final
\end */
function visual_sumarTiempo(fecha:Date, tiempo:Number, codCentro:String):Date
{
	if (!fecha)
		return false;

debug("Sumar " + tiempo + " a " + fecha);
	var tiempoInicio:Number = fecha.getTime(); //Date.parse(fecha);
debug("Inicio " + tiempoInicio);
	var fechaFin:Date = this.iface.buscarSiguienteTiempoFin(fecha);
debug("Siguiente fin" + fechaFin);

	if (!fechaFin)
		return false;
	var tiempoFin:Number = fechaFin.getTime();

	var tiempoAux:Number = tiempoFin - tiempoInicio;

	if (tiempoAux >= tiempo) {
		tiempoFin = tiempoInicio + tiempo;
		fechaFin = new Date(tiempoFin);
		return fechaFin;
	}
	
	tiempo = tiempo - tiempoAux;

	var fechaInicio:Date = this.iface.buscarSiguienteTiempoInicio(fechaFin);
	if (!fechaInicio)
		return false;
	return this.iface.sumarTiempo(fechaInicio,tiempo,codCentro);
	
// 	var fecha:Date = new Date(tiempoFin);
// 	return fecha;
}

function visual_iniciarCentrosCoste():Boolean
{
	var util:FLUtil = new FLUtil;

	var qryCentros:FLSqlQuery = new FLSqlQuery;
	with (qryCentros) {
		setTablesList("pr_centroscoste");
		setSelect("codcentro");
		setFrom("pr_centroscoste");
		setWhere("1 = 1");
		setForwardOnly(true);
	}
	if (!qryCentros.exec())
		return false;

	var iCentro:Number = this.iface.centroMemo.length;
	var dMaxFechaPrev:Date;
	var sMaxFechaPrev:String;
	var maxFecha:String;
	var hoy:Date;
	while (qryCentros.next()) {
		this.iface.centroMemo[iCentro] = this.iface.nuevoCentroCoste();
		this.iface.centroMemo[iCentro]["codcentro"] = qryCentros.value("codcentro");
		this.iface.centroMemo[iCentro]["codtipocentro"] = qryCentros.value("codtipocentro");
		this.iface.centroMemo[iCentro]["idtipotareapro"] = qryCentros.value("idtipotareapro");
		this.iface.centroMemo[iCentro]["costeinicial"] = qryCentros.value("costeinicial");
		this.iface.centroMemo[iCentro]["costeunidad"] = qryCentros.value("costeunidad");

		var qryMaxFecha:FLSqlQuery = new FLSqlQuery;
		qryMaxFecha.setTablesList("pr_tareas");
		qryMaxFecha.setSelect("fechafinprev, horafinprev");
		qryMaxFecha.setFrom("pr_tareas");
		qryMaxFecha.setWhere("codcentro = '" + qryCentros.value("codcentro") + "' ORDER BY fechafinprev DESC, horafinprev DESC");
		qryMaxFecha.setForwardOnly(true);
		if (!qryMaxFecha.exec()) {
			return false;
		}
		if (qryMaxFecha.first()) {
			sMaxFechaPrev = qryMaxFecha.value("fechafinprev").toString().left(10) + "T" + qryMaxFecha.value("horafinprev").toString().right(8);
debug("MFP = " + sMaxFechaPrev );
debug("CODCENTRO = " + qryCentros.value("codcentro"));
			if (sMaxFechaPrev == "T00:00:00") {
				dMaxFechaPrev = new Date();
			} else {
				dMaxFechaPrev = new Date(Date.parse(sMaxFechaPrev));
			}
			hoy = new Date;
			if (this.iface.compararFechas(dMaxFechaPrev, hoy) == 2) {
				this.iface.centroMemo[iCentro]["fechainicio"] = hoy;
			} else {
				this.iface.centroMemo[iCentro]["fechainicio"] = dMaxFechaPrev;
			}
		} else {
			this.iface.centroMemo[iCentro]["fechainicio"] = hoy;
		}
debug("FINICIO CC = " + this.iface.centroMemo[iCentro]["fechainicio"]);
		iCentro++;
	}
	return true;
}

function visual_beforeCommit_pr_lineasplancompras(curLC:FLSqlCursor):Boolean
{
	/// Sincroniza los pedidos de compras con la línea de plan de compras
	var util:FLUtil = new FLUtil;
	var curTran:FLSqlCursor = new FLSqlCursor("empresa");
	curTran.transaction(false);
	try {
		switch (curLC.modeAccess()) {
			case curLC.Insert: {
				if (!this.iface.crearCompraPlan(curLC)) {
					curTran.rollback();
					return false;
				}
				break;
			}
			case curLC.Edit: {
				if (!this.iface.modificarCompraPlan(curLC)) {
					curTran.rollback();
					return false;
				}
				break;
			}
			case curLC.Del: {
				if (!this.iface.borrarCompraPlan(curLC)) {
					curTran.rollback();
					return false;
				}
				break;
			}
		}
		curTran.commit();
	} catch (e) {
		curTran.rollback();
		MessageBox.critical(util.translate("scripts", "La sincronización de compras con la línea de plan de compras ha fallado: ") + e, MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	return true;
}

/** \D Crea una línea de pedido a proveedor asociada a los datos de una línea de plan de compras
@param	curLC: Cursor de la línea de plan de compras
\end */
function visual_crearCompraPlan(curLC:FLSqlCursor):Boolean
{
	var idLineaPP:String = curLC.valueBuffer("idlineapedido");
	if (!idLineaPP || idLineaPP == "") {
		if (!this.iface.curPedidoProv_) {
			this.iface.curPedidoProv_ = new FLSqlCursor("pedidosprov");
		}
		this.iface.curPedidoProv_.setModeAccess(this.iface.curPedidoProv_.Insert);
		this.iface.curPedidoProv_.refreshBuffer();
		if (!this.iface.datosCompraPlan(curLC)) {
			return false;
		}
		if (!this.iface.curPedidoProv_.commitBuffer()) {
			return false;
		}
		idPedido = this.iface.curPedidoProv_.valueBuffer("idpedido");
		curLC.setValueBuffer("idpedido", idPedido);
		if (!this.iface.crearLineaCompraPlan(idPedido, curLC)) {
			return false;
		}
		this.iface.curPedidoProv_.select("idpedido = " + idPedido);
		if (!this.iface.curPedidoProv_.first()) {
			return false;
		}
		this.iface.curPedidoProv_.setModeAccess(this.iface.curPedidoProv_.Edit);
		this.iface.curPedidoProv_.refreshBuffer();
		if (!this.iface.totalesPedido()) {
			return false;
		}
		if (!this.iface.curPedidoProv_.commitBuffer()) {
			return false;
		}
	} else {
		if (!this.iface.modificarCompraPlan(curLC)) {
			return false;
		}
	}
	return true;
}

/** \D Modifica un pedido de proveedor con respecto a una línea de plan de ventas
@param	curLC: Cursor de la línea de plan de ventas
@param	usarPrevios: Indica si usar los valores de cantidad y fecha previos o actuales
\end */
function visual_modificarCompraPlan(curLC:FLSqlCursor, usarPrevios:Boolean):Boolean
{
	var util:FLUtil = new FLUtil;
	var idPedido:String = curLC.valueBuffer("idpedido");
	if (!idPedido || idPedido == "") {
		return false;
	}
	var idLineaPP:String = curLC.valueBuffer("idlineapedido");
	if (!idLineaPP || idLineaPP == "") {
		return false;
	}
	if (!this.iface.curPedidoProv_) {
		this.iface.curPedidoProv_ = new FLSqlCursor("pedidosprov");
	}
	this.iface.curPedidoProv_.select("idpedido = " + idPedido);
	if (!this.iface.curPedidoProv_.first()) {
		MessageBox.warning(util.translate("scripts", "Error al buscar el pedido de compras asociado a la línea de plan de compras"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	this.iface.curPedidoProv_.setModeAccess(this.iface.curPedidoProv_.Edit);
	this.iface.curPedidoProv_.refreshBuffer();
	if (usarPrevios) {
		this.iface.curPedidoProv_.setValueBuffer("fechaentrada", curLC.valueBuffer("fechaprevia"));
	} else {
		this.iface.curPedidoProv_.setValueBuffer("fechaentrada", curLC.valueBuffer("fecha"));
	}
	if (!this.iface.modificarLineaCompraPlan(curLC, usarPrevios)) {
		return false;
	}
	if (!this.iface.totalesPedido()) {
		return false;
	}
	if (!this.iface.curPedidoProv_.commitBuffer()) {
		return false;
	}
	
	return true;
}

/** \D Borra o modifica una línea de pedido a proveedor asociada a los datos de una línea de plan de compras. Si la línea de plan no tenía datos previos de cantidad y fechas, la línea de pedido se borra. Si sí los tenía los valores previos son restiuidos
@param	curLC: Cursor de la línea de plan de compras
\end */
function visual_borrarCompraPlan(curLC:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	var idPedido:String = curLC.valueBuffer("idpedido");
	if (!idPedido || idPedido == "") {
		return false;
	}
	var idLineaPP:String = curLC.valueBuffer("idlineapedido");
	if (!idLineaPP || idLineaPP == "") {
		return false;
	}
	var canPrevia:Number = curLC.valueBuffer("canprevia");
	if (canPrevia == 0) {
		if (!util.sqlDelete("lineaspedidosprov", "idlinea = " + idLineaPP)) {
			return false;
		}
		if (!util.sqlDelete("pedidosprov", "idpedido = " + idPedido)) {
			return false;
		}
	} else {
		if (!this.iface.modificarCompraPlan(curLC, true)) {
			return false;
		}
	}
	return true;
}

/** \D Crea una línea de pedido de proveedor asociada a una línea del plan de compras
@param	idPedido: Identificador del pedido al que asociar la línea
@param	curLC: Cursor de la línea de plan de compras
\end */
function visual_crearLineaCompraPlan(idPedido:String, curLC:FLSqlCursor):Boolean
{
	if (!this.iface.curLineaPedidoProv_) {
		this.iface.curLineaPedidoProv_ = new FLSqlCursor("lineaspedidosprov");
	}
	this.iface.curLineaPedidoProv_.setModeAccess(this.iface.curLineaPedidoProv_.Insert);
	this.iface.curLineaPedidoProv_.refreshBuffer();
	this.iface.curLineaPedidoProv_.setValueBuffer("idpedido", idPedido);
	if (!this.iface.datosLineaCompraPlan(curLC)) {
		return false;
	}
	if (!this.iface.curLineaPedidoProv_.commitBuffer()) {
		return false;
	}
	var idLinea:String = this.iface.curLineaPedidoProv_.valueBuffer("idlinea");
	curLC.setValueBuffer("idlineapedido", idLinea);
	return true;
}

/** \D Modifica una línea de pedido de proveedor asociada a una línea del plan de compras
@param	curLC: Cursor de la línea de plan de compras
@param	usarPrevios: Indica si usar los valores de cantidad y fecha previos o actuales
\end */
function visual_modificarLineaCompraPlan(curLC:FLSqlCursor, usarPrevios:Boolean):Boolean
{
	if (!this.iface.curLineaPedidoProv_) {
		this.iface.curLineaPedidoProv_ = new FLSqlCursor("lineaspedidosprov");
	}
	this.iface.curLineaPedidoProv_.select("idlinea = " + curLC.valueBuffer("idlineapedido"));
debug("select lineapedprov idlinea = " + curLC.valueBuffer("idlineapedido"));
	if (!this.iface.curLineaPedidoProv_.first()) {
debug("no está");
		return false;
	}
	this.iface.curLineaPedidoProv_.setModeAccess(this.iface.curLineaPedidoProv_.Edit);
	this.iface.curLineaPedidoProv_.refreshBuffer();
	if (!this.iface.datosLineaCompraPlan(curLC, usarPrevios)) {
debug("!datosLineaCompraPlan");
		return false;
	}
	if (!this.iface.curLineaPedidoProv_.commitBuffer()) {
debug("!curLineaPedidoProv_.commitBuffer");
		return false;
	}
	return true;
}

function visual_datosLineaCompraPlan(curLC:FLSqlCursor, usarPrevios:Boolean):Boolean
{
	var util:FLUtil = new FLUtil;

	var codProveedor:String = util.sqlSelect("pedidosprov", "codproveedor", "idpedido = " + this.iface.curLineaPedidoProv_.valueBuffer("idpedido"));

	var referencia:String = curLC.valueBuffer("referencia");
	var qryArticulo:FLSqlQuery = new FLSqlQuery;
	qryArticulo.setTablesList("articulos");
	qryArticulo.setSelect("descripcion, codimpuesto");
	qryArticulo.setFrom("articulos");
	qryArticulo.setWhere("referencia = '" + referencia + "'");
	qryArticulo.setForwardOnly(true);
	if (!qryArticulo.exec()) {
		return false;
	}
	if (!qryArticulo.first()) {
		return false;
	}
	
	with (this.iface.curLineaPedidoProv_) {
		if (usarPrevios) {
			setValueBuffer("cantidad", curLC.valueBuffer("canprevia"));
		} else {
			setValueBuffer("cantidad", curLC.valueBuffer("cantidad"));
		}
		setValueBuffer("referencia", referencia);
		setValueBuffer("descripcion", qryArticulo.value("descripcion"));
		setValueBuffer("codimpuesto", qryArticulo.value("codimpuesto"));
		setValueBuffer("iva", formRecordlineaspedidosprov.iface.pub_commonCalculateField("iva", this));
		setValueBuffer("recargo", formRecordlineaspedidosprov.iface.pub_commonCalculateField("recargo", this));
		setValueBuffer("irpf", formRecordlineaspedidosprov.iface.pub_commonCalculateField("irpf", this));
		setValueBuffer("dtopor", formRecordlineaspedidosprov.iface.pub_commonCalculateField("dtopor", this));
		setValueBuffer("porcomision", formRecordlineaspedidosprov.iface.pub_commonCalculateField("porcomision", this));
		setValueBuffer("pvpunitario", formRecordlineaspedidosprov.iface.pub_commonCalculateField("pvpunitario", this));
		setValueBuffer("pvpsindto", formRecordlineaspedidosprov.iface.pub_commonCalculateField("pvpsindto", this));
		setValueBuffer("pvptotal", formRecordlineaspedidosprov.iface.pub_commonCalculateField("pvptotal", this));
	}
	return true;
}

function visual_datosCompraPlan(curLC:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;

	var codProveedor:String = curLC.valueBuffer("codproveedor");
	
	var qryProveedor:FLSqlQuery = new FLSqlQuery;
	qryProveedor.setTablesList("proveedores");
	qryProveedor.setSelect("codserie, codpago, coddivisa, cifnif, nombre");
	qryProveedor.setFrom("proveedores");
	qryProveedor.setWhere("codproveedor = '" + codProveedor + "'");
	qryProveedor.setForwardOnly(true);
	if (!qryProveedor.exec()) {
		return false;
	}
	if (!qryProveedor.first()) {
		return false;
	}
	
	var codSerie:String = qryProveedor.value("codserie");
	if (!codSerie) {
		codSerie = flfactppal.iface.pub_valorDefectoEmpresa("codserie");
	}
	var codPago:String = qryProveedor.value("codpago");
	if (!codPago) {
		codPago = flfactppal.iface.pub_valorDefectoEmpresa("codpago");
	}
	var codDivisa:String = qryProveedor.value("coddivisa");
	if (!codDivisa) {
		codDivisa = flfactppal.iface.pub_valorDefectoEmpresa("coddivisa");
	}
	var tasaConv:String = util.sqlSelect("divisas", "tasaconv", "coddivisa = '" + codDivisa + "'");
	var codEjercicio:FLSqlCursor = flfactppal.iface.pub_ejercicioActual();
	var hoy:Date = new Date;
	var codAlmacen:String;
	if (curLC.cursorRelation()) {
		codAlmacen = curLC.cursorRelation().valueBuffer("codalmacen");
	} else {
		codAlmacen = util.sqlSelect("pr_plancompras", "codalmacen", "idplan = " + curLC.valueBuffer("idplan"));
	}
	
	with (this.iface.curPedidoProv_) {
		setValueBuffer("codserie", codSerie);
		setValueBuffer("codejercicio", codEjercicio);
		setValueBuffer("fecha", hoy.toString());
		setValueBuffer("codalmacen", codAlmacen);
		setValueBuffer("codpago", codPago);
		setValueBuffer("coddivisa", codDivisa);
		setValueBuffer("tasaconv", tasaConv);
		setValueBuffer("codproveedor", codProveedor);
		setValueBuffer("cifnif", qryProveedor.value("cifnif"));
		setValueBuffer("nombre", qryProveedor.value("nombre"));
		setValueBuffer("fechaentrada", curLC.valueBuffer("fecha"));
	}
	return true;
}

/** \D Informa los datos de un pedido referentes a totales (I.V.A., neto, etc.)
@return	True si el cálculo se realiza correctamente, false en caso contrario
\end */
function visual_totalesPedido():Boolean
{
	with (this.iface.curPedidoProv_) {
		setValueBuffer("neto", formpedidosprov.iface.pub_commonCalculateField("neto", this));
		setValueBuffer("totaliva", formpedidosprov.iface.pub_commonCalculateField("totaliva", this));
		setValueBuffer("totalirpf", formpedidosprov.iface.pub_commonCalculateField("totalirpf", this));
		setValueBuffer("totalrecargo", formpedidosprov.iface.pub_commonCalculateField("totalrecargo", this));
		setValueBuffer("total", formpedidosprov.iface.pub_commonCalculateField("total", this));
		setValueBuffer("totaleuros", formpedidosprov.iface.pub_commonCalculateField("totaleuros", this));
	}
	return true;
}

/** \D Establece secuencias entre tareas de distintos procesos de producción cuando los lotes de dichos procesos son unos consumos de los otros, para evitar planificar el lote producto antes que el lote consumo
\end */
function visual_restriccionesConsumo():Boolean
{
	var util:FLUtil = new FLUtil;
	var codLote:String;
	var idProceso:Number;
	var idTipoTareaPro:String;
	var idProceso:Number;
	var iTarea:Number;
	var iLoteComsumo:Number;
	var estadoLoteConsumo:String;
	var codLoteConsumo:Number;
	var qryConsumos:FLSqlQuery = new FLSqlQuery;
	
	for (iLote = 0; iLote < this.iface.loteMemo.length; iLote++) {
		codLote = this.iface.loteMemo[iLote]["codlote"];
		idProceso = this.iface.loteMemo[iLote]["idproceso"];
		with (qryConsumos) {
			setTablesList("movistock");
			setSelect("ms.codlote, a.idtipoproceso, ac.idtipotareapro");
			setFrom("movistock ms INNER JOIN articuloscomp ac ON ms.idarticulocomp = ac.id INNER JOIN articulos a ON ac.refcomponente = a.referencia");
			setWhere("ms.codloteprod = '" + codLote + "' AND ms.idproceso = " + idProceso + " AND a.fabricado = true");
			setForwardOnly(true);
		}
		if (!qryConsumos.exec()) {
			return false;
		}
		while (qryConsumos.next()) {
			idTipoTareaPro = qryConsumos.value("ac.idtipotareapro");
			iTarea = this.iface.buscarTarea(codLote, idTipoTareaPro);
			if (iTarea < 0) {
				MessageBox.warning(util.translate("scripts", "Restricciones de consumo: Error al buscar la tarea:\n%1\nAsiciada al lote %2.").arg(this.iface.datosTarea(idTipoTareaPro)).arg(codLote), MessageBox.Ok, MessageBox.NoButton);
				return false;
			}

			codLoteConsumo = qryConsumos.value("ms.codlote");
			idProceso = util.sqlSelect("pr_procesos", "idproceso", "idtipoproceso = '" + qryConsumos.value("a.idtipoproceso") + "' AND idobjeto = '" + codLoteConsumo + "' AND estado <> 'OFF'");
			if (idProceso && !isNaN(idProceso)) {
	///// POR HACER
			} else {
				iLoteComsumo = this.iface.buscarLote(codLoteConsumo);
				estadoLoteConsumo = util.sqlSelect("lotesstock","estado","codlote = '" + codLoteConsumo + "'");
/// Controlar que si el lote no está terminado esté en la orden y asociado a un proceso de tipo Fabricación
// 				if (estadoLoteConsumo != "TERMINADO"){
// 					if (iLoteComsumo < 0) {
// 						MessageBox.warning(util.translate("scripts", "Para fabricar el lote %1 es necesario tener disponible el lote %2.\nDicho lote no está fabricado ni incluido en esta orden.").arg(codLote).arg(codLoteConsumo), MessageBox.Ok, MessageBox.NoButton);
// 						return false;
// 					}
// 				}
				var tareasFin:Array = this.iface.tareasFinales(codLoteConsumo);
				if (tareasFin.length > 0) {
					for (var i:Number = 0; i < tareasFin.length; i++) {
						if (!this.iface.establecerSecuencia(tareasFin[i], iTarea))
							return false;
				
					}
				}
			}
		}
	}
	return true;
}

//// PRODUCCION VISUAL //////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////