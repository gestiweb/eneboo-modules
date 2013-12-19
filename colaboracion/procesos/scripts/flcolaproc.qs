/***************************************************************************
                 flcolaproc.qs  -  description
                             -------------------
    begin                : mar oct 26 2006
    copyright            : (C) 2006 by InfoSiAL S.L.
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
El módulo de procesos lleva el control de los procesos y tareas.
Las principales acciones de este módulo son los procesos y las tareas

Los estados de un proceso son:
PTE: el proceso ha sido creado, pero no se ha comenzado a realizar ninguna de sus tareas (todas están en OFF o PTE)
EN CURSO: se ha iniciado al menos una tarea del proceso (hay alguna en EN CURSO o TERMINADA)
TERMINADO: todas las tareas del proceso han finalizado (están en estado TERMINADA)
DETENIDO: se he interrumpido momentáneamente el proceso. (las tareas PTEs pasan a DETENIDAs)
CANCELADO: se he interrumpido definitivamente el proceso. (las tareas PTEs o DETENIDAs pasan a CANCELADAs)

La duración de un proceso es el intervalo de tiempo que transcurre desde que pasa a estado EN CURSO hasta que pasa a FINALIZADO

Los estados de una tarea son:
OFF: La tarea ha sido creada pero no puede ser iniciada (generalmente porque sus predecesoras no han finalizado)
PTE: La tarea puede ser iniciada. Pasan a PTE las tareas marcadas como iniciales o aquellas cuyas predecesoras han finalizado
EN CURSO: La tarea ha sido iniciada por el usuario.
FINALIZADA: La tarea ha finalizado
DETENIDA: La tarea, que debería estar PTE, está anulada momentáneamente (no puede realizarse)
CANCELADA: La tarea, que debería estar PTE, está anulada definitivamente (no puede realizarse)

La duración de una tarea es el intervalo de tiempo que transcurre desde que pasa a estado EN CURSO hasta que pasa a FINALIZADA
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
		this.ctx.interna_init();
	}
	function afterCommit_pr_tareas(curTarea:FLSqlCursor):Boolean {
		return this.ctx.interna_afterCommit_pr_tareas(curTarea);
	}
	function afterCommit_pr_tipostareapro(curTTP:FLSqlCursor):Boolean {
		return this.ctx.interna_afterCommit_pr_tipostareapro(curTTP);
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var tipoObjeto_:String;
	var idObjeto_:String;
	var cursor_:FLSqlCursor;
	var filtroFormulario_:FLSqlCursor;
	var tdbTareasS:Object;
	var tbnLanzarTareaS:Object;
	var tbnEditTareaS:Object;
	var tbnDeleteTareaS:Object;
	var tbnVerTareaS:Object;
	var tbnIniciarTareaS:Object;
	var tbnDeshacerTareaS:Object;
	var tbnDetenerProcesoS:Object;
	var tbnCancelarProcesoS:Object;
	var tbnReanudarProcesoS:Object;
	var chkPteS:Object;
	var chkEnCursoS:Object;
	var chkTerminadaS:Object;
	var chkFueraPlazoS:Object;
	var chkETodasS:Object;
	var chkMiasS:Object;
	var chkDeMiGrupoS:Object;
	var chkSinAsignarS:Object;
	var chkTodasS:Object;
	var container_:Object;
	var curTarea_:Object;
	var accionesAuto_:Array;
	var curObjeto_:FLSqlCursor;
	var xmlDocParametros_:FLDomDocument;
	var timerTareas:Number;
	function oficial( context ) { interna( context ); }
	function valoresIniciales(){
		this.ctx.oficial_valoresIniciales();
	}
	function crearProceso(tipoProceso:String, tipoObjeto:String, idObjeto:String):Number {
		return this.ctx.oficial_crearProceso(tipoProceso, tipoObjeto, idObjeto);
	}
	function activarTarea(curTareaPrevia:FLSqlCursor, idTipoTareaPro:String):Number {
		return this.ctx.oficial_activarTarea(curTareaPrevia, idTipoTareaPro);
	}
	function activacionPosibleTarea(idProceso:String, idTipoTareaPro:String, numCiclo:String):Number {
		return this.ctx.oficial_activacionPosibleTarea(idProceso, idTipoTareaPro, numCiclo);
	}
	function iniciarTarea(curTareas:FLSqlCursor, idUser:String, ignorarEstadistica:Boolean) {
		return this.ctx.oficial_iniciarTarea(curTareas, idUser, ignorarEstadistica);
	}
	function tiempoMedioProceso(idTipoProceso:String):Boolean {
		return this.ctx.oficial_tiempoMedioProceso(idTipoProceso);
	}
	function tiempoUnidadProceso(idTipoProceso:String):Boolean {
		return this.ctx.oficial_tiempoUnidadProceso(idTipoProceso);
	}
	function tiempoMedioTarea(idTipoTarea:String):Boolean {
		return this.ctx.oficial_tiempoMedioTarea(idTipoTarea);
	}
	function iniciarProceso(idProceso:String):Boolean {
		return this.ctx.oficial_iniciarProceso(idProceso);
	}
	function calcularIntervalo(diaInicio:Date, tiempoInicio:Time, momentoFin:Date):Number {
		return this.ctx.oficial_calcularIntervalo(diaInicio, tiempoInicio, momentoFin)
	}
	function terminarProceso(idProceso:String):Boolean {
		return this.ctx.oficial_terminarProceso(idProceso);
	}
	function terminarTarea(curTareas:FLSqlCursor):Boolean {
		return this.ctx.oficial_terminarTarea(curTareas);
	}
	function activarSiguientesTareas(curTareas:FLSqlCursor):Boolean {
		return this.ctx.oficial_activarSiguientesTareas(curTareas);
	}
	function desactivarSiguientesTareas(curTareas:FLSqlCursor):Boolean {
		return this.ctx.oficial_desactivarSiguientesTareas(curTareas);
	}
	function esTareaInicial(idTipoTarea:String):Boolean {
		return this.ctx.oficial_esTareaInicial(idTipoTarea);
	}
	function cambiarEstadoObjeto(idProceso:Number, estadoProceso:String):Boolean {
		return this.ctx.oficial_cambiarEstadoObjeto(idProceso, estadoProceso);
	}
	function estadoObjeto(idProceso:Number):String {
		return this.ctx.oficial_estadoObjeto(idProceso);
	}
	function deshacerProcesoTerminado(idProceso:String):Boolean {
		return this.ctx.oficial_deshacerProcesoTerminado(idProceso);
	}
	function deshacerProcesoEnCurso(idProceso:String):Boolean {
		return this.ctx.oficial_deshacerProcesoEnCurso(idProceso);
	}
	function deshacerTareaTerminada(curTareas:FLSqlCursor):Boolean {
		return this.ctx.oficial_deshacerTareaTerminada(curTareas);
	}
	function deshacerTareaEnCurso(curTareas:FLSqlCursor):Boolean {
		return this.ctx.oficial_deshacerTareaEnCurso(curTareas);
	}
	function estadoObjetoInicial(idProceso:Number):String {
		return this.ctx.oficial_estadoObjetoInicial(idProceso);
	}
	function borrarProceso(idProceso:Number):Boolean {
		return this.ctx.oficial_borrarProceso(idProceso);
	}
	function detenerProceso(idProceso:Number):Boolean {
		return this.ctx.oficial_detenerProceso(idProceso);
	}
	function cancelarProceso(idProceso:Number):Boolean {
		return this.ctx.oficial_cancelarProceso(idProceso);
	}
	function reanudarProceso(idProceso:Number):Boolean {
		return this.ctx.oficial_reanudarProceso(idProceso);
	}
	function previoReanudarProceso(idProceso:Number):Boolean {
		return true; /// Función a sobrecargar
	}
	function previoDetenerProceso(idProceso:Number):Boolean {
		return true; /// Función a sobrecargar
	}
	function previoCancelarProceso(idProceso:Number):Boolean {
		return true; /// Función a sobrecargar
	}
	function cerosIzquierda(numero:String, totalCifras:Number):String {
		return this.ctx.oficial_cerosIzquierda(numero, totalCifras);
	}
	function calcularIdTarea():String {
		return this.ctx.oficial_calcularIdTarea();
	}
	function iniciarTareaEsp(curTareas:FLSqlCursor):Boolean {
		return true; //Función a sobrecargar
	}
	function terminarTareaEsp(curTareas:FLSqlCursor):Boolean {
		return true; //Función a sobrecargar
	}
	function deshacerTareaTerminadaEsp(curTareas:FLSqlCursor):Boolean {
		return true; //Función a sobrecargar
	}
	function deshacerTareaEnCursoEsp(curTareas:FLSqlCursor):Boolean {
		return true; //Función a sobrecargar
	}
	function iniciarProcesoEsp(idProceso:String):Boolean {
		return true; //Función a sobrecargar
	} 
	function terminarProcesoEsp(curProceso:FLSqlCursor):Boolean {
		return true; //Función a sobrecargar
	}
	function deshacerProcesoTerminadoEsp(idProceso:String):Boolean {
		return true; //Función a sobrecargar
	}
	function deshacerProcesoEnCursoEsp(idProceso:String):Boolean {
		return true; //Función a sobrecargar
	}
	function descripcionTarea(curTarea:FLSqlCursor):String {
		return this.ctx.oficial_descripcionTarea(curTarea);
	}
	function asignarTareas(idProceso:String, idTipoProceso:String):Boolean {
		return this.ctx.oficial_asignarTareas(idProceso, idTipoProceso);
	}
	function seguimientoOn(container:Object, datosS:Array):Boolean {
		return this.ctx.oficial_seguimientoOn(container, datosS);
	}
	function seguimientoOff():Boolean {
		return this.ctx.oficial_seguimientoOff();
	}
	function regenerarFiltroS() {
		return this.ctx.oficial_regenerarFiltroS();
	}
	function filtroEstadoS():String {
		return this.ctx.oficial_filtroEstadoS();
	}
	function filtroPropietarioS():String {
		return this.ctx.oficial_filtroPropietarioS();
	}
	function filtroFormularioS(filtro:String) {
		return this.ctx.oficial_filtroFormularioS(filtro);
	}
	function valoresDefectoFiltroS() {
		return this.ctx.oficial_valoresDefectoFiltroS();
	}
	function tbnLanzarTareaSClicked() {
		return this.ctx.oficial_tbnLanzarTareaSClicked();
	}
	function tbnEditTareaSClicked() {
		return this.ctx.oficial_tbnEditTareaSClicked();
	}
	function tbnDeleteTareaSClicked() {
		return this.ctx.oficial_tbnDeleteTareaSClicked();
	}
	function tbnVerTareaSClicked() {
		return this.ctx.oficial_tbnVerTareaSClicked();
	}
	function tbnIniciarTareaSClicked(idUsuario:String):Boolean {
		return this.ctx.oficial_tbnIniciarTareaSClicked(idUsuario);
	}
	function tbnDeshacerTareaSClicked():Boolean {
		return this.ctx.oficial_tbnDeshacerTareaSClicked();
	}
	function tbnCancelarProcesoSClicked():Boolean {
		return this.ctx.oficial_tbnCancelarProcesoSClicked();
	}
	function tbnDetenerProcesoSClicked():Boolean {
		return this.ctx.oficial_tbnDetenerProcesoSClicked();
	}
	function tbnReanudarProcesoSClicked():Boolean {
		return this.ctx.oficial_tbnReanudarProcesoSClicked();
	}
	function procesarEstadoS() {
		return this.ctx.oficial_procesarEstadoS();
	}
	function obtenerTipoProcesoS() {
		return this.ctx.oficial_obtenerTipoProcesoS();
	}
	function elegirOpcion(opciones:Array):Number {
		return this.ctx.oficial_elegirOpcion(opciones);
	}
	function notificar(mensaje:Array):Boolean {
		return this.ctx.oficial_notificar(mensaje);
	}
	function initMensaje():Array {
		return this.ctx.oficial_initMensaje();
	}
	function establecerAccionTareaS() {
		return this.ctx.oficial_establecerAccionTareaS();
	}
	function procesarEvento(datosEvento:Array):Boolean {
		return this.ctx.oficial_procesarEvento(datosEvento);
	}
	function actualizarTiempoTotal(tipoObjeto:String, idObjeto:String) {
		return this.ctx.oficial_actualizarTiempoTotal(tipoObjeto, idObjeto);
	}
	function calcularTiempo(tipoObjeto:String, idObjeto:String):Number {
		return this.ctx.oficial_calcularTiempo(tipoObjeto, idObjeto);
	}
	function convertirTiempoProceso(s:Number, idProceso:String):Number {
		return this.ctx.oficial_convertirTiempoProceso(s, idProceso);
	}
	function convertirTiempoMS(tiempoProceso:Number, idProceso:String):Number {
		return this.ctx.oficial_convertirTiempoMS(tiempoProceso, idProceso);
	}
	function comprobarTotalTiempoProceso(curTarea:FLSqlCursor):Boolean {
		return this.ctx.oficial_comprobarTotalTiempoProceso(curTarea);
	}
	function actualizarTotalTiempoProceso(curTarea:FLSqlCursor):Boolean {
		return this.ctx.oficial_actualizarTotalTiempoProceso(curTarea);
	}
	function calcularTiempoInvertido(curTareas:FLSqlCursor):Number {
		return this.ctx.oficial_calcularTiempoInvertido(curTareas);
	}
	function calcularTiemposFinalizacionTarea(curTareas:FLSqlCursor,fechaFin:Date):Boolean {
		return this.ctx.oficial_calcularTiemposFinalizacionTarea(curTareas,fechaFin);
	}
	function dameFechasPrevistas(curTarea:FLSqlCursor):FLDomElement {
		return this.ctx.oficial_dameFechasPrevistas(curTarea);
	}
	function datosTarea():Boolean {
		return this.ctx.oficial_datosTarea();
	}
	function actualizarEstadoObjeto(tipoObjeto:String, idObjeto:String, estadoObjeto:String):Boolean {
		return this.ctx.oficial_actualizarEstadoObjeto(tipoObjeto, idObjeto, estadoObjeto);
	}
	function borrarProcesosAsociados(tipoObjeto:String, idObjeto:String):Boolean {
		return this.ctx.oficial_borrarProcesosAsociados(tipoObjeto, idObjeto);
	}
	function calcularAsignacionTarea():Array {
		return this.ctx.oficial_calcularAsignacionTarea();
	}
	function condicionOK(idProceso:String, condicion:String):Boolean {
		return this.ctx.oficial_condicionOK(idProceso, condicion);
	}
	function condicionSecuenciaOK(idProceso:String, secuencia:String):Boolean {
		return this.ctx.oficial_condicionSecuenciaOK(idProceso, secuencia);
	}
	function crearXMLProceso(curProceso:FLSqlCursor):FLDomDocument {
		return this.ctx.oficial_crearXMLProceso(curProceso);
	}
	function dameXMLProceso(idProceso:String):FLDomNode {
		return this.ctx.oficial_dameXMLProceso(idProceso);
	}
	function accionesAuto():Array {
		return this.ctx.oficial_accionesAuto();
	}
	function establecerAtributoProceso(idProceso:String, atributo:String, valor:String):Boolean {
		return this.ctx.oficial_establecerAtributoProceso(idProceso, atributo, valor);
	}
	function refrescarTareasS() {
		return this.ctx.oficial_refrescarTareasS();
	}
	function setAccionesAuto(aa:Array) {
		return this.ctx.oficial_setAccionesAuto(aa);
	}
	function arrayAccion(contexto:String, accion:String):Array {
		return this.ctx.oficial_arrayAccion(contexto, accion);
	}
	function terminarTareaPorEstado(curTarea:FLSqlCursor):Boolean {
		return this.ctx.oficial_terminarTareaPorEstado(curTarea);
	}
	function ponerTareaEnCursoPorEstado(curTarea:FLSqlCursor):Boolean {
		return this.ctx.oficial_ponerTareaEnCursoPorEstado(curTarea);
	}
	function ponerTareaPtePorEstado(curTarea:FLSqlCursor):Boolean {
		return this.ctx.oficial_ponerTareaPtePorEstado(curTarea);
	}
	function dormirTareaPorEstado(curTarea:FLSqlCursor, fechaActivacion:String):Boolean {
		return this.ctx.oficial_dormirTareaPorEstado(curTarea, fechaActivacion);
	}
	function dormirTarea(curTarea:FLSqlCursor, fechaActivacion:String):Boolean {
		return this.ctx.oficial_dormirTarea(curTarea, fechaActivacion);
	}
	function despertarTarea(curTarea:FLSqlCursor):Boolean {
		return this.ctx.oficial_despertarTarea(curTarea);
	}
	function calcularFechaActivacion(curTarea:FLSqlCursor):String {
		return this.ctx.oficial_calcularFechaActivacion(curTarea);
	}
	function comprobarTareasInit() {
		return this.ctx.oficial_comprobarTareasInit();
	}
	function despertarTareasInit() {
		return this.ctx.oficial_despertarTareasInit();
	}
	function despertarTareaEsp(curTarea:FLSqlCursor):Boolean {
		return true;
	}
	function globalInit() {
		return this.ctx.oficial_globalInit();
	}
	function mostrarInbox() {
		return this.ctx.oficial_mostrarInbox();
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
	function pub_terminarTarea(curTareas:FLSqlCursor):Boolean {
		return this.terminarTarea(curTareas);
	}
	function pub_iniciarTarea(curTareas:FLSqlCursor, idUser:String, ignorarEstadistica:Boolean):Boolean {
		return this.iniciarTarea(curTareas, idUser, ignorarEstadistica);
	}
	function pub_crearProceso(tipoProceso:String, tipoObjeto:String, idObjeto:String):Number {
		return this.crearProceso(tipoProceso, tipoObjeto, idObjeto);
	}
	function pub_deshacerTareaTerminada(curTareas:FLSqlCursor):Boolean {
		return this.deshacerTareaTerminada(curTareas);
	}
	function pub_deshacerTareaEnCurso(curTareas:FLSqlCursor):Boolean {
		return this.deshacerTareaEnCurso(curTareas);
	}
	function pub_borrarProceso(idProceso:Number):Boolean {
		return this.borrarProceso(idProceso);
	}
	function pub_detenerProceso(idProceso:Number):Boolean {
		return this.detenerProceso(idProceso);
	}
	function pub_cancelarProceso(idProceso:Number):Boolean {
		return this.cancelarProceso(idProceso);
	}
	function pub_reanudarProceso(idProceso:Number):Boolean {
		return this.reanudarProceso(idProceso);
	}
	function pub_cerosIzquierda(numero:String, totalCifras:Number):String {
		return this.cerosIzquierda(numero, totalCifras);
	}
	function pub_formatearCodigo( lineEdit:Object, longCodigo:Number, posPuntoActual:Number ):Number {
		return this.formatearCodigo( lineEdit, longCodigo, posPuntoActual );
	}
	function pub_seguimientoOn(container:Object, datosS:Array):Boolean {
		return this.seguimientoOn(container, datosS);
	}
	function pub_filtroFormularioS(filtro:String) {
		return this.filtroFormularioS(filtro);
	}
	function pub_tbnIniciarTareaSClicked(idUsuario:String):Boolean {
		return this.tbnIniciarTareaSClicked(idUsuario);
	}
	function pub_tbnDetenerProcesoSClicked(idUsuario:String):Boolean {
		return this.tbnDetenerProcesoSClicked(idUsuario);
	}
	function pub_tbnCancelarProcesoSClicked(idUsuario:String):Boolean {
		return this.tbnCancelarProcesoSClicked(idUsuario);
	}
	function pub_tbnReanudarProcesoSClicked(idUsuario:String):Boolean {
		return this.tbnReanudarProcesoSClicked(idUsuario);
	}
	function pub_regenerarFiltroS() {
		return this.regenerarFiltroS();
	}
	function pub_procesarEvento(datosEvento:Array):Boolean {
		return this.procesarEvento(datosEvento);
	}
	function pub_tiempoUnidadProceso(idTipoProceso:String):Boolean {
		return this.tiempoUnidadProceso(idTipoProceso);
	}
	function pub_actualizarTiempoTotal(tipoObjeto:String, idObjeto:String) {
		return this.actualizarTiempoTotal(tipoObjeto, idObjeto);
	}
	function pub_convertirTiempoProceso(s:Number, idProceso:String):Number {
		return this.convertirTiempoProceso(s, idProceso);
	}
	function pub_convertirTiempoMS(tiempoProceso:Number, idProceso:String):Number {
		return this.convertirTiempoMS(tiempoProceso, idProceso);
	}
	function pub_borrarProcesosAsociados(tipoObjeto:String, idObjeto:String):Boolean {
		return this.borrarProcesosAsociados(tipoObjeto, idObjeto);
	}
	function pub_accionesAuto():Array {
		return this.accionesAuto();
	}
	function pub_setAccionesAuto(aa:Array) {
		return this.setAccionesAuto(aa);
	}
	function pub_arrayAccion(contexto:String, accion:String):Array {
		return this.arrayAccion(contexto, accion);
	}
	function pub_terminarTareaPorEstado(curTarea:FLSqlCursor):Boolean {
		return this.terminarTareaPorEstado(curTarea);
	}
	function pub_ponerTareaEnCursoPorEstado(curTarea:FLSqlCursor):Boolean {
		return this.ponerTareaEnCursoPorEstado(curTarea);
	}
	function pub_ponerTareaPtePorEstado(curTarea:FLSqlCursor):Boolean {
		return this.ponerTareaPtePorEstado(curTarea);
	}
	function pub_dormirTareaPorEstado(curTarea:FLSqlCursor, fechaActivacion:String):Boolean {
		return this.dormirTareaPorEstado(curTarea, fechaActivacion);
	}
	function pub_dormirTarea(curTarea:FLSqlCursor, fechaActivacion:String):Boolean {
		return this.dormirTarea(curTarea, fechaActivacion);
	}
	function pub_globalInit() {
		return this.globalInit();
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
	var util:FLUtil = new FLUtil;
	if (!util.sqlSelect("pr_tiposproceso", "idtipoproceso", "1 = 1")) {
		MessageBox.information(util.translate("scripts", "Se insertará un proceso de ejemplo para comenzar a trabajar"), MessageBox.Ok, MessageBox.NoButton);
		this.iface.valoresIniciales();
	}
}

function interna_afterCommit_pr_tareas(curTarea:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	switch (curTarea.modeAccess()) {
		case curTarea.Edit: {
			var idTarea:String = curTarea.valueBuffer("idtarea");
			var idTipoTareaPro:String = curTarea.valueBuffer("idtipotareapro");
			if ((curTarea.valueBuffer("iduser") != "" && curTarea.valueBufferCopy("estado") == "OFF" && curTarea.valueBuffer("estado") == "PTE") || (curTarea.valueBuffer("iduser") != "" && curTarea.valueBufferCopy("iduser") != curTarea.valueBuffer("iduser") && curTarea.valueBuffer("estado") == "PTE")) {
				if (util.sqlSelect("pr_tipostareapro", "notificarasignacion", "idtipotareapro = " + idTipoTareaPro)) {
					var mensaje:Array = this.iface.initMensaje();
					mensaje["editable"] = false;
					mensaje["usrdestino"] = curTarea.valueBuffer("iduser");
					mensaje["asunto"] = util.translate("scripts", "Asignación de tarea %1").arg(idTarea);
					mensaje["mensaje"] = util.translate("scripts", "Le ha sido asignada la tarea %1:\n%2\n\n%3").arg(idTarea).arg(curTarea.valueBuffer("descripcion")).arg(curTarea.valueBuffer("observaciones"));
					if (!this.iface.notificar(mensaje)) {
						return false;
					}
				}
			}
		}
	}
	if (!this.iface.actualizarTiempoTotal(curTarea.valueBuffer("tipoobjeto"), curTarea.valueBuffer("idobjeto")))
		return false;

	if (!this.iface.comprobarTotalTiempoProceso(curTarea))
		return false;

	return true;
}

function interna_afterCommit_pr_tipostareapro(curTTP:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;

	switch (curTTP.modeAccess()) {
		case curTTP.Del: {
			var idTipoTareaPro:Number = curTTP.valueBuffer("idtipotareapro");
			if(util.sqlSelect("pr_tareas","idtarea","idtipotareapro = " + idTipoTareaPro + " AND estado IN ('OFF','PTE')")) {
				MessageBox.warning(util.translate("scripts", "No se puede borrar el tipo de tarea ya que hay tareas de este tipo sin terminar."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				return false;
			}
		}
	}

	return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D
Rellena un string con ceros a la izquierda hasta completar la logitud especificada
@param numero: String que contiene el número
@param totalCifras: Longitud a completar
\end */
function oficial_cerosIzquierda(numero:String, totalCifras:Number):String
{
	var i:Number, j:Number;
	var valor:String = numero;
	for (i = 0; (numero.toString().charAt(i)); i++);
	if (i < totalCifras)
			for (j = i; j < totalCifras; j++)
					valor = "0" + valor;
	return valor;
}

function oficial_valoresIniciales()
{
	var util:FLUtil = new FLUtil;
	// TIPOS DE PROCESO
	var values:Array =
		[[util.translate("scripts", "TAREA UNITARIA"), util.translate("scripts", "Tarea sencilla de ejemplo"), true]];

	var cursor:FLSqlCursor = new FLSqlCursor("pr_tiposproceso");
	for (var i:Number = 0; i < values.length; i++) {
		with(cursor) {
			setModeAccess(cursor.Insert);
			refreshBuffer();
			setValueBuffer("idtipoproceso", values[i][0]);
			setValueBuffer("descripcion", values[i][1]);
			setValueBuffer("accesiblecrm", values[i][2]);
			commitBuffer();
		}
	}
	delete cursor;

	// TIPOS DE TAREA
	var values:Array =
		[[util.translate("scripts", "TAREA"), util.translate("scripts", "Tarea de ejemplo")]];
	var cursor:FLSqlCursor = new FLSqlCursor("pr_tipostarea");
	for (var i:Number = 0; i < values.length; i++) {
		with(cursor) {
			setModeAccess(cursor.Insert);
			refreshBuffer();
			setValueBuffer("idtipotarea", values[i][0]);
			setValueBuffer("descripcion", values[i][1]);
			commitBuffer();
		}
	}
	delete cursor;

	// TIPOS DE TAREA ASOCIADOS A PROCESOS
	var values:Array =
		[[util.translate("scripts", "TAREA_UNITARIA_TAREA"), util.translate("scripts", "TAREA"), util.translate("scripts", "Tarea de ejemplo"), util.translate("scripts", "TAREA UNITARIA"), "TERMINADO", true, true]];
	var cursor:FLSqlCursor = new FLSqlCursor("pr_tipostareapro");
	for (var i:Number = 0; i < values.length; i++) {
		with(cursor) {
			setModeAccess(cursor.Insert);
			refreshBuffer();
			setValueBuffer("idtipotareapro", values[i][0]);
			setValueBuffer("idtipotarea", values[i][1]);
			setValueBuffer("descripcion", values[i][2]);
			setValueBuffer("idtipoproceso", values[i][3]);
			setValueBuffer("subestadoproceso", values[i][4]);
			setValueBuffer("tareainicial", values[i][5]);
			setValueBuffer("tareafinal", values[i][6]);
			commitBuffer();
		}
	}
	delete cursor;

}

/** \D
Crea un proceso en estado PTE y todas sus tareas asociadas, lanzando las tareas marcadas como iniciales
@param tipoProceso: Tipo del proceso a crear
@param tipoObjeto: Tipo de objeto asociado al proceso
@param idObjeto: Identificador del objeto asociado al proceso
@return Identificador del proceso si la creación tiene éxito. 0 en otro caso.
\end */
function oficial_crearProceso(tipoProceso:String, tipoObjeto:String, idObjeto:String):Number
{
	var idProceso:Number;
	var util:FLUtil = new FLUtil;
	var curProceso:FLSqlCursor = new FLSqlCursor("pr_procesos");
	var tipoObjetoProceso:String = util.sqlSelect("pr_tiposproceso","tipoobjeto","idtipoproceso = '" + tipoProceso + "'");
	if(!tipoObjeto || tipoObjeto == "") {
		if(tipoObjetoProceso && tipoObjetoProceso != "") {
			MessageBox.warning(util.translate("scripts", "El proceso debe tener un objeto asociado del tipo %1.\nAntes de generar el proceso debe crear el objeto").arg(tipoObjetoProceso), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			return false;
		}
	} else {
		if (tipoObjetoProceso && tipoObjetoProceso != "" && tipoObjetoProceso != tipoObjeto) {
			MessageBox.warning(util.translate("scripts", "El proceso debe tener un objeto asociado del tipo %1 y se le está intentando asociar un objeto del tipo %2").arg(tipoObjetoProceso).arg(tipoObjeto), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			return false;
		}
	}
	var generarTodas:Boolean = util.sqlSelect("pr_tiposproceso", "generartodas", "idtipoproceso = '" + tipoProceso + "'");

	var filtroTodas:String = "";
	if (!generarTodas) {
		filtroTodas = " AND tareainicial = true";
	}

	with (curProceso) {
		setModeAccess(curProceso.Insert);
		refreshBuffer();
		setValueBuffer("idtipoproceso", tipoProceso);
		setValueBuffer("tipoobjeto", tipoObjeto);
		setValueBuffer("idobjeto", idObjeto);
		setValueBuffer("estado", "PTE");
	}
	if (!curProceso.commitBuffer()) {
		return false;
	}

	idProceso = curProceso.valueBuffer("idproceso");

	var qryTiposTarea:FLSqlQuery = new FLSqlQuery();
	with (qryTiposTarea) {
		setTablesList("pr_tipostareapro");
		setSelect("idtipotarea, idtipotareapro, codtipotareapro, tareainicial");
		setFrom("pr_tipostareapro");
		setWhere("idtipoproceso = '" + tipoProceso + "'" + filtroTodas + " ORDER BY ordenlista");
	}
	if (!qryTiposTarea.exec())
		return false;

	if (!this.iface.curTarea_) {
		this.iface.curTarea_ = new FLSqlCursor("pr_tareas");
	}
	while (qryTiposTarea.next()) {
		this.iface.curTarea_.setModeAccess(this.iface.curTarea_.Insert);
		this.iface.curTarea_.refreshBuffer();
		this.iface.curTarea_.setValueBuffer("idtarea", this.iface.calcularIdTarea());
		this.iface.curTarea_.setValueBuffer("idproceso", idProceso);
		if (qryTiposTarea.value("tareainicial")) {
			this.iface.curTarea_.setValueBuffer("estado", "PTE");
		} else {
			this.iface.curTarea_.setValueBuffer("estado", "OFF");
		}
		this.iface.curTarea_.setValueBuffer("idtipotarea", qryTiposTarea.value("idtipotarea"));
		this.iface.curTarea_.setValueBuffer("idtipotareapro", qryTiposTarea.value("idtipotareapro"));
		this.iface.curTarea_.setValueBuffer("codtipotareapro", qryTiposTarea.value("codtipotareapro"));
		this.iface.curTarea_.setValueBuffer("tipoobjeto", tipoObjeto);
		this.iface.curTarea_.setValueBuffer("idobjeto", idObjeto);
		this.iface.curTarea_.setValueBuffer("numciclo", 1);
		this.iface.curTarea_.setValueBuffer("descripcion", this.iface.descripcionTarea(this.iface.curTarea_));
		
		if (!this.iface.datosTarea()) {
			return false;
		}
		
		if (!this.iface.curTarea_.commitBuffer()) {
			return false;
		}
	}

	if (!this.iface.asignarTareas(idProceso, tipoProceso))
		return false;

	curProceso.select("idproceso = " + idProceso);
	if (!curProceso.first()) {
		return false;
	}

	curProceso.setModeAccess(curProceso.Edit);
	curProceso.refreshBuffer();

	var xmlProceso:FLDomDocument = this.iface.crearXMLProceso(curProceso);
	if (!xmlProceso) {
		return false;
	}
	curProceso.setValueBuffer("xmlparametros", xmlProceso.toString(4));
	if (!curProceso.commitBuffer()) {
		return false;
	}
	return idProceso;
}

/** \D Pide al usuario que indique los responsables de cada tarea
@param	idProceso: Identificador del proceso
@param	idTipoProceso: Identificador del tipo de proceso
@return	true si no hay error, false en caso contrario
\end */
function oficial_asignarTareas(idProceso:String, idTipoProceso:String):Boolean
{
	var util:FLUtil = new FLUtil;
	var arrayAlias:Array = [];
	var qryAlias:FLSqlQuery = new FLSqlQuery();

	qryAlias.setTablesList("pr_aliasproceso");
	qryAlias.setSelect("idalias, alias, idusuariodef, idgrupodef");
	qryAlias.setFrom("pr_aliasproceso");
	qryAlias.setWhere("idtipoproceso = '" + idTipoProceso + "'");
	qryAlias.setForwardOnly(true);
	if (!qryAlias.exec())
		return false;

	var usuarioActual:String = sys.nameUser();
	var idUser:String;
	var idGroup:String;
	var idAsignacion:String;
	while (qryAlias.next()) {
		var fAlias:Object = new FLFormSearchDB("pr_asignaralias");
		var curAsignar:FLSqlCursor = fAlias.cursor();
	
		// Asignación de usuario y/o grupo a todos los alias del proceso
		curAsignar.select("idusuariocon = '" + usuarioActual + "'");
		if (curAsignar.first()) {
			curAsignar.setModeAccess(curAsignar.Edit);
		} else {
			curAsignar.setModeAccess(curAsignar.Insert);
		}
		curAsignar.refreshBuffer();
		curAsignar.setValueBuffer("idusuariocon", usuarioActual);
		curAsignar.setValueBuffer("alias", qryAlias.value("alias"));
		curAsignar.setValueBuffer("idgroup",qryAlias.value("idgrupodef"));
		curAsignar.setValueBuffer("iduser",qryAlias.value("idusuariodef"));

		fAlias.setMainWidget();
		idAsignacion = fAlias.exec("idasignacion");

		if (idAsignacion) {
			if (!curAsignar.commitBuffer())
				return false;
			// Actualización de todas las tareas del proceso asociadas al alias con el usuario y grupo especificados.
			var qryAsignarAlias:FLSqlQuery = new FLSqlQuery;
			qryAsignarAlias.setTablesList("pr_tareas,pr_tipostareapro");
			qryAsignarAlias.setSelect("t.idtarea");
			qryAsignarAlias.setFrom("pr_tareas t INNER JOIN pr_tipostareapro tp ON t.idtipotareapro = tp.idtipotareapro");
			qryAsignarAlias.setWhere("t.idproceso = " + idProceso + " AND tp.idalias = " + qryAlias.value("idalias"));
			qryAsignarAlias.setForwardOnly(true);
			if (!qryAsignarAlias.exec())
				return false;
			while (qryAsignarAlias.next()) {
				idUser = util.sqlSelect("pr_asignaralias", "iduser", "idasignacion = " + idAsignacion);
				if (!idUser)
					idUser = "NULL";
				idGroup = util.sqlSelect("pr_asignaralias", "idgroup", "idasignacion = " + idAsignacion);
				if (!idGroup)
					idGroup = "NULL";
				if (!util.sqlUpdate("pr_tareas", "iduser,idgroup", idUser + "," + idGroup, "idtarea = '" + qryAsignarAlias.value("t.idtarea") + "'"))
					return false;
			}
		}
	}

	var qryTareas:FLSqlQuery = new FLSqlQuery;
	with (qryTareas) {
		setTablesList("pr_tareas,pr_tipostareapro");
		setSelect("idtarea");
		setFrom("pr_tareas t INNER JOIN pr_tipostareapro ttp ON t.idtipotareapro = ttp.idtipotareapro");
		setWhere("t.idproceso = " + idProceso + " AND ttp.idalias IS NULL ORDER BY idtarea");
		setForwardOnly(true);
	}
	if (!qryTareas.exec())
		return false;

	var ok:String;
	var f:Object;
	var curTareas:FLSqlCursor;
	while (qryTareas.next()) {
		f = new FLFormSearchDB("pr_asignartarea");
		curTareas = f.cursor();
		curTareas.select("idtarea = '" + qryTareas.value("idtarea") + "'");
		if (!curTareas.first())
			return false;
		
		curTareas.setModeAccess(curTareas.Edit);
		curTareas.refreshBuffer();
		
		f.setMainWidget();
		ok = f.exec("idtarea");
		if (ok) {
			if (!curTareas.commitBuffer())
				return false;
		}
		f.close();
		delete f;
	}
	return true;
}
/** \D Obtiene la descripción de la tarea
@param	curTarea: Cursor con los datos de la tarea
@return	Descripción
\end */
function oficial_descripcionTarea(curTarea:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil;
	return util.sqlSelect("pr_tipostareapro", "descripcion", "idtipotareapro = " + curTarea.valueBuffer("idtipotareapro"));
}

/** \D Obtiene el siguiente código de tarea
@return	Código de tarea (TA + Número de 6 cifras)
\end */
function oficial_calcularIdTarea():String
{
	var util:FLUtil = new FLUtil();
	var prefijo = "TA";
	var ultimaTarea:Number = util.sqlSelect("pr_secuenciastareas", "valor", "prefijo = '" + prefijo + "'");

	if (!ultimaTarea) {
		var idUltima:String = util.sqlSelect("pr_tareas", "idtarea", "idtarea LIKE '" + prefijo + "%' ORDER BY idtarea DESC");

		if (idUltima) {
			ultimaTarea = parseFloat(idUltima.right(6));
		} else {
			ultimaTarea = 0;
		}

		var pass:String = util.readSettingEntry( "DBA/password");
		var port:String = util.readSettingEntry( "DBA/port");
		if (!sys.addDatabase(sys.nameDriver(), sys.nameBD(), sys.nameUser(), pass, sys.nameHost(), port, "conAux")) {
			MessageBox.warning(util.translate("scripts", "Ha habido un error al establecer una conexión auxiliar con la base de datos %1").arg(sys.nameBD()), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
		ultimaTarea += 1;
		var curSecuencia:FLSqlCursor = new FLSqlCursor("pr_secuenciastareas", "conAux");
		curSecuencia.setModeAccess(curSecuencia.Insert);
		curSecuencia.refreshBuffer();
		curSecuencia.setValueBuffer("prefijo", "TA");
		curSecuencia.setValueBuffer("valor", ultimaTarea);
		if (!curSecuencia.commitBuffer()) {
			return false;
		}
	}
	else {
		ultimaTarea += 1;
		util.sqlUpdate("pr_secuenciastareas", "valor", ultimaTarea, "prefijo = '" + prefijo + "'");
	}

	var id:String = prefijo + flfacturac.iface.pub_cerosIzquierda((ultimaTarea).toString(), 6);

	return id;
}

/** \C
Cambia el estado de la tarea a PTE si es la tarea inicial o si todas sus predecesoras requeridas están en estado TERMINADA y cumplen la condición si la hay
@param curTareaPrevia: Cursor asociado a una tarea previa a la que hay que activar o al proceso de la tarea
@param idTipoTareaPro: Tipo de tarea por proceso de la tarea a activar
@return 0 Siha habido algún error; 1 si la tarea ha sido activada; 2 si la tarea no se puede activar
\end */
function oficial_activarTarea(curTareaPrevia:FLSqlCursor, idTipoTareaPro:String):Number
{
debug("Activar tarea");
	var util:FLUtil = new FLUtil();
	var estado:String;

	var idProceso:String = curTareaPrevia.valueBuffer("idproceso");
	var idObjeto:String = curTareaPrevia.valueBuffer("idobjeto");
	var tipoObjeto:String = curTareaPrevia.valueBuffer("tipoobjeto");

	var numCiclo:String;
	if (curTareaPrevia.table() == "pr_tareas") {
		numCiclo = curTareaPrevia.valueBuffer("numciclo");
	} else {
		numCiclo = "1";
	}
	var activable:Number = this.iface.activacionPosibleTarea(idProceso, idTipoTareaPro, numCiclo);
	if (activable != 1) {
		return activable;
	}
	

	if (!this.iface.curTarea_) {
		this.iface.curTarea_ = new FLSqlCursor("pr_tareas");
	}
	this.iface.curTarea_.select("idproceso = " + idProceso + " AND idtipotareapro = " + idTipoTareaPro + " AND numciclo = " + numCiclo + " AND estado = 'OFF'");
	if (!this.iface.curTarea_.first()) {
		var numCiclo:Number = parseInt(util.sqlSelect("pr_tareas", "COUNT(*)", "idproceso = " + idProceso + " AND idtipotareapro = " + idTipoTareaPro));
		numCiclo = (isNaN(numCiclo) ? 0 : numCiclo);
		numCiclo++;
		this.iface.curTarea_.setModeAccess(this.iface.curTarea_.Insert);
		this.iface.curTarea_.refreshBuffer();
	
		this.iface.curTarea_.setValueBuffer("idtarea", this.iface.calcularIdTarea());
		this.iface.curTarea_.setValueBuffer("idproceso", idProceso);
		this.iface.curTarea_.setValueBuffer("idtipotarea", util.sqlSelect("pr_tipostareapro", "idtipotarea", "idtipotareapro = " + idTipoTareaPro));
		this.iface.curTarea_.setValueBuffer("codtipotareapro", util.sqlSelect("pr_tipostareapro", "codtipotareapro", "idtipotareapro = " + idTipoTareaPro));
		this.iface.curTarea_.setValueBuffer("idtipotareapro", idTipoTareaPro);
		this.iface.curTarea_.setValueBuffer("tipoobjeto", tipoObjeto);
		this.iface.curTarea_.setValueBuffer("idobjeto", idObjeto);
		this.iface.curTarea_.setValueBuffer("numciclo", numCiclo);
		this.iface.curTarea_.setValueBuffer("descripcion", this.iface.descripcionTarea(this.iface.curTarea_));
		var datosAsignacion:Array = this.iface.calcularAsignacionTarea();
		if (datosAsignacion) {
			this.iface.curTarea_.setValueBuffer("idgroup", datosAsignacion["idgrupo"]);
			this.iface.curTarea_.setValueBuffer("iduser", datosAsignacion["idusuario"]);
		}
		if (!this.iface.datosTarea()) {
			return false;
		}
	} else {
		this.iface.curTarea_.setModeAccess(this.iface.curTarea_.Edit);
		this.iface.curTarea_.refreshBuffer();
	}
	var fechasPrevistas:FLDomElement = this.iface.dameFechasPrevistas(this.iface.curTarea_);
	var hoy:Date = new Date;
	var asignado:String = this.iface.curTarea_.valueBuffer("iduser");
	with (this.iface.curTarea_) {
		setValueBuffer("estado", "PTE");
		if (fechasPrevistas && fechasPrevistas.attribute("FechaPteEnCurso") != "NULL") {
			setValueBuffer("fechainicioprev", fechasPrevistas.attribute("FechaPteEnCurso"));
		}
		if (fechasPrevistas && fechasPrevistas.attribute("HoraPteEnCurso") != "NULL") {
			setValueBuffer("horainicioprev", fechasPrevistas.attribute("HoraPteEnCurso"));
		}
		if (fechasPrevistas && fechasPrevistas.attribute("FechaPteTerminada") != "NULL") {
			setValueBuffer("fechafinprev", fechasPrevistas.attribute("FechaPteTerminada"));
		}
		if (fechasPrevistas && fechasPrevistas.attribute("FechaPteTerminada") != "NULL") {
			setValueBuffer("horafinprev", fechasPrevistas.attribute("HoraPteTerminada"));
		}
		setValueBuffer("fechaactivacion", hoy);
	}
	if (!this.iface.curTarea_.commitBuffer()) {
		return 0;
	}
	return 1;
}

/** \D Indica si la tarea indicada puede ser activada o no
@return: 0 Error. 1 Activable. 2 No activable.
\end */
function oficial_activacionPosibleTarea(idProceso:String, idTipoTareaPro:String, numCiclo:String):Number
{
	var util:FLUtil = new FLUtil();
	
	var tareaInicial:Boolean = util.sqlSelect("pr_tipostareapro", "tareainicial", "idtipotareapro = " + idTipoTareaPro);
debug("activando " + tareaInicial);
	var qryPrevias:FLSqlQuery = new FLSqlQuery;
	qryPrevias.setTablesList("pr_tipostareapro,pr_secuencias");
	qryPrevias.setSelect("s.condicionada, s.condicion, s.requerida, s.codtareainicio, s.codtareafin, t.estado, t.idtarea");
	qryPrevias.setFrom("pr_tareas t INNER JOIN pr_secuencias s ON t.idtipotareapro = s.tareainicio");
	qryPrevias.setWhere("t.idproceso = " + idProceso + " AND s.tareafin = " + idTipoTareaPro + " AND t.numciclo = " + numCiclo);
	qryPrevias.setForwardOnly(true);
	if (!qryPrevias.exec()) {
		return 0;
	}
	var secuencia:String;
	while (qryPrevias.next()) {
		if (qryPrevias.value("s.requerida") == true) {
debug("requerida");
			if (qryPrevias.value("t.estado") != "TERMINADA") {
				return 2;
			}
			secuencia = qryPrevias.value("s.codtareainicio") + " >> " + qryPrevias.value("s.codtareafin");
			if (!this.iface.condicionSecuenciaOK(idProceso, secuencia)) {
				return 2;
			}
debug("terminada");
/** Por ahora la condicion solo se comprueba por codigo. 
			if (qryPrevias.value("s.condicionada") == true) {
debug("condicionada");
				if (!this.iface.condicionOK(idProceso, qryPrevias.value("s.condicion"))) {
					return 2;
				}
			} else {
			}
*/
		}
	}
	return 1;
}

function oficial_dameFechasPrevistas(curTarea:FLSqlCursor):FLDomElement
{
debug("oficial_dameFechasPrevistas");
	var qryTipoTarea:FLSqlQuery = new FLSqlQuery;
	qryTipoTarea.setTablesList("pr_tiposproceso,pr_tipostareapro");
	qryTipoTarea.setSelect("tp.unidad, tt.tiempopteencurso, tt.tiempopteterminada");
	qryTipoTarea.setFrom("pr_tipostareapro tt INNER JOIN pr_tiposproceso tp ON tt.idtipoproceso = tp.idtipoproceso");
	qryTipoTarea.setWhere("tt.idtipotarea = '" + curTarea.valueBuffer("idtipotarea") + "'");
	qryTipoTarea.setForwardOnly(true);
	if (!qryTipoTarea.exec()) {
		return false;
	}
	if (!qryTipoTarea.first()) {
		return false;
	}
	var ahora:Date = new Date;
	var mAhora:Number = ahora.getTime();
	var milisegundos:Number;
	var unidadTiempo:Number = qryTipoTarea.value("tp.unidad");
	switch (unidadTiempo) {
		case "Segundos": {
			milisegundos = 1000;
			break;
		}
		case "Minutos": {
			milisegundos = 60000; //1000 * 60;
			break;
		}
		case "Horas": {
			milisegundos = 3600000; //1000 * 60 * 60;
			break;
		}
		case "Días": {
			milisegundos = 86400000; //1000 * 60 * 60 * 24;
			break;
		}
	}
	var mInicio:Number = mAhora + milisegundos * parseFloat(qryTipoTarea.value("tt.tiempopteencurso"));
debug(mInicio);
	var mFin:Number = mAhora + milisegundos * parseFloat(qryTipoTarea.value("tt.tiempopteterminada"));
debug(mFin);
	var fechaInicio:Date = new Date(mInicio);
	var fechaFin:Date = new Date(mFin);
debug(fechaFin.toString());
	var xmlDoc:FLDomDocument = new FLDomDocument;
	var eFechas:FLDomElement = xmlDoc.createElement("Fechas");
	eFechas.setAttribute("FechaPteEnCurso", fechaInicio.toString().left(10));
	eFechas.setAttribute("FechaPteTerminada", fechaFin.toString().left(10));
	eFechas.setAttribute("HoraPteEnCurso", fechaInicio.toString().right(8));
	eFechas.setAttribute("HoraPteTerminada", fechaFin.toString().right(8));
	xmlDoc.appendChild(eFechas);
debug(xmlDoc.toString(4));
	return eFechas;
}

/** \C
Cambia el estado de la tarea de PTE a EN CURSO, llamando -si existe- a la acción asociada a la tarea
@param curTareas: Cursor posicionado sobre la tarea a iniciar
@param idUser: Identificador del usuario que inicia la tarea
@param ignorarEstadistica: En producción, marca la tarea para no ser incluida en las estadísticas. (Posible paso a oficial).
@return VERDADERO si la tarea ha sido iniciada. FALSO en otro caso
\end */
function oficial_iniciarTarea(curTareas:FLSqlCursor, idUser:String, ignorarEstadistica:Boolean)
{
	var util:FLUtil = new FLUtil();
	var idTipoTarea:String = curTareas.valueBuffer("idtipotarea");
	var idTipoTareaPro:String = curTareas.valueBuffer("idtipotareapro");
	var idTarea:String = curTareas.valueBuffer("idtarea");
	var idProceso:String = curTareas.valueBuffer("idproceso");
	var estado:String = curTareas.valueBuffer("estado");

	var fechaInicio:Date = new Date();
	var horaInicio:String = fechaInicio.toString().substring(11, 19);

	with(curTareas) {
		setModeAccess(curTareas.Edit);
		refreshBuffer();
		setValueBuffer("estado", "EN CURSO");
		setValueBuffer("tiempoinicio", horaInicio);
		setValueBuffer("diainicio", fechaInicio);
		setValueBuffer("realizadapor", idUser);
	}
	if (!curTareas.commitBuffer())
		return false;

	curTareas.select("idtarea = '" + idTarea + "'");
	curTareas.first();
	curTareas.setModeAccess(curTareas.Edit);
	curTareas.refreshBuffer();

/** \C Si la tarea es una tarea inicial, se inicia el proceso asociado, y se marca el objeto relacionado para indicar que está incluido en un proceso ya iniciado
\end */
	if (this.iface.esTareaInicial(idTipoTareaPro)) {
		if (!this.iface.iniciarProceso(idProceso))
			return false;

		var estadoObjeto:String = this.iface.estadoObjetoInicial(idProceso);
		if (!this.iface.cambiarEstadoObjeto(idProceso, estadoObjeto))
			return false;
	}
	if (!this.iface.iniciarTareaEsp(curTareas))
		return false;

	return true;
}

/** \D
Indica si el tipo de tarea especificado corresponde a una tarea marcada como inicial
@param idTipoTareaPro: Tipo de tarea por proceso
@return VERDADERO si la tarea es inicial. FALSO en otro caso
\end */
function oficial_esTareaInicial(idTipoTareaPro:String):Boolean
{
	var util:FLUtil = new FLUtil();
	var tareaInicial:String = util.sqlSelect("pr_tipostareapro", "tareainicial", "idtipotareapro = " + idTipoTareaPro);
	if (tareaInicial == false || tareaInicial == "f")
		return false;
	else
		return true;
}
function oficial_terminarTarea(curTareas:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	var idTipoTarea:String = curTareas.valueBuffer("idtipotarea");
	var idTipoTareaPro:String = curTareas.valueBuffer("idtipotareapro");
	var idTarea:String = curTareas.valueBuffer("idtarea");
	var idProceso:String = curTareas.valueBuffer("idproceso");

	if (!this.iface.terminarTareaEsp(curTareas))
		return false;

	var qryTiposTarea:FLSqlQuery = new FLSqlQuery();
	with (qryTiposTarea) {
		setTablesList("pr_tipostareapro");
		setSelect("subestadoproceso, estadoobjeto");
		setFrom("pr_tipostareapro");
		setWhere("idtipotareapro = " + idTipoTareaPro);
	}
	if (!qryTiposTarea.exec())
		return false;
	if (!qryTiposTarea.first())
		return false;
	var subestadoProceso:String = qryTiposTarea.value("subestadoproceso");
	var estadoObjeto:String = qryTiposTarea.value("estadoobjeto");

	if (subestadoProceso && subestadoProceso != "") {
		util.sqlUpdate("pr_procesos", "subestado", subestadoProceso, "idproceso = '" + idProceso + "'");
	}

	if (estadoObjeto && estadoObjeto != "") {
		if (!this.iface.cambiarEstadoObjeto(idProceso, estadoObjeto)) {
			return false;
		}
	}
	var fechaFin:Date = new Date();
	var horaFin:String = fechaFin.toString().substring(11, 19);
	with(curTareas) {
		if (curTareas.modeAccess() != curTareas.Edit) {
			setModeAccess(curTareas.Edit);
			refreshBuffer();
		}
		setValueBuffer("estado", "TERMINADA");
		setValueBuffer("tiempofin", horaFin);
		setValueBuffer("diafin", fechaFin);
	}

	this.iface.calcularTiemposFinalizacionTarea(curTareas,fechaFin);

	if (!curTareas.commitBuffer())
		return false;

	var tareaFinal:Number = util.sqlSelect("pr_tipostareapro", "tareafinal", "idtipotareapro = " + idTipoTareaPro);
	if (tareaFinal == false || tareaFinal == "f") {
		if (!this.iface.activarSiguientesTareas(curTareas))
			return false;
	} else {
		// El proceso acaba si no hay ninguna tarea final que no esté terminada
		if (!util.sqlSelect("pr_tareas t INNER JOIN pr_tipostareapro tt ON t.idtipotareapro = tt.idtipotareapro", "idtarea ", "t.idproceso = " + idProceso + " AND tt.tareafinal = true AND t.estado <> 'TERMINADA'", "pr_tareas,pr_tipostareapro")) {
			if (!this.iface.terminarProceso(idProceso))
				return false;
		}
	}

	return true;
}

function oficial_calcularTiemposFinalizacionTarea(curTareas:FLSqlCursor,fechaFin:Date):Boolean
{
	var intervalo:Number = this.iface.calcularIntervalo(curTareas.valueBuffer("diainicio"), curTareas.valueBuffer("tiempoinicio"), fechaFin);
	curTareas.setValueBuffer("intervalo", intervalo);
	curTareas.setValueBuffer("tiempoinvertido", this.iface.calcularTiempoInvertido(curTareas));
	return true;
}

/** \D Activa las tareas siguientes a una determinada tarea, según las secuencias en las que dicha tarea es la tarea inicial
\param	curTareas: Cursor con las tarea inicial
\end */
function oficial_activarSiguientesTareas(curTareas:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	var idTipoTareaPro:String = curTareas.valueBuffer("idTipoTareaPro");
	var idProceso:String = curTareas.valueBuffer("idProceso");
	var qrySiguienteTarea:FLSqlQuery = new FLSqlQuery();
	with (qrySiguienteTarea) {
		setTablesList("pr_tipostareapro,pr_secuencias");
		setSelect("s.tareafin");
		setFrom("pr_tipostareapro tt INNER JOIN pr_secuencias s ON tt.idtipotareapro = s.tareainicio");
		setWhere("tt.idtipotareapro = " + idTipoTareaPro);
	}
	if (!qrySiguienteTarea.exec())
		return false;

	var idTipoSiguienteTarea:String;
	while (qrySiguienteTarea.next()) {
		idTipoSiguienteTarea = qrySiguienteTarea.value("s.tareafin");
		if (!this.iface.activarTarea(curTareas, idTipoSiguienteTarea)) {
			return false;
		}
	}
	return true;
}

/** \D
Pasa el estado del proceso a TERMINADO, calculando el intervalo medio del tipo de proceso correspondiente
@param idProceso: Identificador del proceso que ha terminado
@return VERDADERO si el proceso finaliza correctamente. FALSO en otro caso
\end */
function oficial_terminarProceso(idProceso:String):Boolean
{
	var util:FLUtil = new FLUtil();
	var fechaFin:Date = new Date();
	var horaFin:String = fechaFin.toString().substring(11, 19);
	var curProceso:FLSqlCursor = new FLSqlCursor("pr_procesos");
	if (!curProceso.select("idproceso = " + idProceso))
		return false;
	if (!curProceso.first())
		return false;
	with(curProceso) {
		setModeAccess(curProceso.Edit);
		refreshBuffer();
		setValueBuffer("estado", "TERMINADO");
		setValueBuffer("tiempofin", horaFin);
		setValueBuffer("diafin", fechaFin);
	}
	var idTipoProceso:String = curProceso.valueBuffer("idtipoproceso");
	var intervalo:Number = this.iface.calcularIntervalo(curProceso.valueBuffer("diainicio"), curProceso.valueBuffer("tiempoinicio"), fechaFin);

	curProceso.setValueBuffer("intervalo", intervalo);
	if (!curProceso.commitBuffer())
		return false;

	if (!this.iface.tiempoMedioProceso(idTipoProceso))
		return false;

	if (!this.iface.terminarProcesoEsp(curProceso))
		return false;

	return true;
}

/** \D
Pasa el estado del proceso de TERMINADO a EN CURSO, borrando las fechas y tiempos de fin de proceso
@param idProceso: Identificador del proceso que ha terminado
@return VERDADERO si el proceso finaliza correctamente. FALSO en otro caso
\end */
function oficial_deshacerProcesoTerminado(idProceso:String):Boolean
{
	var util:FLUtil = new FLUtil();
	var fechaFin:Date = new Date();
	var horaFin:String = fechaFin.toString().substring(11, 19);
	var curProceso:FLSqlCursor = new FLSqlCursor("pr_procesos");

	if (!curProceso.select("idproceso = " + idProceso))
		return false;
	if (!curProceso.first())
		return false;
	with(curProceso) {
		setModeAccess(curProceso.Edit);
		refreshBuffer();
		setValueBuffer("estado", "EN CURSO");
		setNull("tiempofin");
		setNull("diafin");
		setNull("intervalo");
	}
	var idTipoProceso:String = curProceso.valueBuffer("idtipoproceso");
	if (!curProceso.commitBuffer())
		return false;
	if (!this.iface.tiempoMedioProceso(idTipoProceso))
		return false;

// 	var idTipoProceso:String = util.sqlSelect("pr_procesos", "idtipoproceso", "idproceso = " + idProceso);
// 	var codLote:String = util.sqlSelect("pr_procesos", "idobjeto", "idproceso = " + idProceso);
// 	if (util.sqlSelect("pr_tiposproceso","fabricacion","idtipoproceso = '" + idTipoProceso + "'")) {
// 		if (!util.sqlUpdate("lotesstock","estado","EN CURSO","codlote = '" + codLote + "'"))
// 			return false;
// 	}

	if (!this.iface.deshacerProcesoTerminadoEsp(idProceso))
		return false;

	return true;
}

/** \D
Calcula el intervalo en segundos entre dos momentos
@param diaInicio: Fecha del momento de inicio
@param tiempoInicio: Hora del momento de inicio
@param momentoFin: Momento de fin
@return intervalo en segundos
\end */
function oficial_calcularIntervalo(diaInicio:Date, tiempoInicio:Time, momentoFin:Date):Number
{
	var intervalo:Number = new Number;
	var longTiempoInicio:Number = tiempoInicio.toString().length;
	var horaInicio:String = diaInicio.toString().substring(0, 10) + ":" + tiempoInicio.toString().substring(longTiempoInicio - 8, longTiempoInicio);
	var momentoInicio:Date = new Date(Date.parse(horaInicio));

	intervalo = (momentoFin.getTime() - momentoInicio.getTime()) / 1000;
	return intervalo;
}


/** \D
Pasa el estado del proceso a EN CURSO
@param idProceso: Identificador del proceso que ha terminado
@return VERDADERO si el proceso se activa correctamente. FALSO en otro caso
\end */
function oficial_iniciarProceso(idProceso:String):Boolean
{
	var util:FLUtil = new FLUtil();

	var estado:String = util.sqlSelect("pr_procesos", "estado", "idproceso = " + idProceso);
	if (estado != "PTE")
		return true;

	var estadoObjeto:String = this.iface.estadoObjeto(idProceso);
	if (!estadoObjeto && estadoObjeto != "") {
		MessageBox.warning(util.translate("scripts", "Hubo un error al obtener el estado del objeto"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	if (estadoObjeto == "")
		estadoObjeto = "NULL";

	var fechaInicio:Date = new Date();
	var horaInicio:String = fechaInicio.toString().substring(11, 19);

	var result:Boolean = util.sqlUpdate("pr_procesos", "tiempoinicio,diainicio,estado,estadoprevio",  horaInicio + "," + fechaInicio + ",EN CURSO," + estadoObjeto, "idproceso = " + idProceso);

	/*var idTipoProceso:String = util.sqlSelect("pr_procesos", "idtipoproceso", "idproceso = " + idProceso);
	var codLote:String = util.sqlSelect("pr_procesos", "idobjeto", "idproceso = " + idProceso);
	if (util.sqlSelect("pr_tiposproceso","fabricacion","idtipoproceso = '" + idTipoProceso + "'")) {
		if (!util.sqlUpdate("lotesstock","estado","EN CURSO","codlote = '" + codLote + "'"))
			return false;
	}*/

	if (!this.iface.iniciarProcesoEsp(idProceso))
		return false;

	return result;
}

/** \D
Pasa el estado del proceso de EN CURSO a PTE
@param idProceso: Identificador del proceso que ha terminado
@return VERDADERO si el proceso se desactiva correctamente. FALSO en otro caso
\end */
function oficial_deshacerProcesoEnCurso(idProceso:String):Boolean
{
	var util:FLUtil = new FLUtil();

	var estado:String = util.sqlSelect("pr_procesos", "estado", "idproceso = " + idProceso);
	if (estado == "PTE")
		return true;
	if (estado != "EN CURSO") {
		MessageBox.warning(util.translate("scripts", "El proceso asociado a la tarea no puede cambiar a PTE por no estar en estado EN CURSO"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
	var curProceso:FLSqlCursor = new FLSqlCursor("pr_procesos");
	if (!curProceso.select("idproceso = " + idProceso))
		return false;
	if (!curProceso.first())
		return false;
	with(curProceso) {
		setModeAccess(curProceso.Edit);
		refreshBuffer();
		setValueBuffer("estado", "PTE");
		setNull("tiempoinicio");
		setNull("diainicio");
	}
	if (!curProceso.commitBuffer())
		return false;
 
// 	var idTipoProceso:String = util.sqlSelect("pr_procesos", "idtipoproceso", "idproceso = " + idProceso);
// 	var codLote:String = util.sqlSelect("pr_procesos", "idobjeto", "idproceso = " + idProceso);
// 	if (util.sqlSelect("pr_tiposproceso","fabricacion","idtipoproceso = '" + idTipoProceso + "'")) {
// 		if (!util.sqlUpdate("lotesstock","estado","PTE","codlote = '" + codLote + "'"))
// 			return false;
// 	}

	if (!this.iface.deshacerProcesoEnCursoEsp(idProceso))
		return false;

	return true;
}

/** \D
Recalcula el tiempo medio correspondiente a las tareas del tipo especificado
@param idTipoTarea: Tipo de tarea a recalcular
@return VERDADERO si el cálculo se realiza correctamente. FALSO en otro caso
\end */
function oficial_tiempoMedioTarea(idTipoTarea:String):Boolean
{
	var util:FLUtil = new FLUtil();
	var tiempoMedio:FLSqlCursor = util.sqlSelect("pr_tareas", "AVG(intervalo)", "idtipotarea = '" + idTipoTarea + "'");
	if (!tiempoMedio)
		return false;

	if (!util.sqlUpdate("pr_tipostarea", "tiempomedio", tiempoMedio, "idtipotarea = '" + idTipoTarea + "'"))
		return false;

	return true;
}

/** \D
Recalcula el tiempo medio correspondiente a los procesos del tipo especificado
@param idTipoProceso: Tipo de proceso a recalcular
@return VERDADERO si el cálculo se realiza correctamente. FALSO en otro caso
\end */
function oficial_tiempoMedioProceso(idTipoProceso:String):Boolean
{
	var util:FLUtil = new FLUtil();
	var tiempoMedio:Number = util.sqlSelect("pr_procesos", "AVG(intervalo)", "idtipoproceso = '" + idTipoProceso + "'");

	if (!tiempoMedio && tiempoMedio != 0)
		return false;

	if (!util.sqlUpdate("pr_tiposproceso", "tiempomedio", tiempoMedio,  "idtipoproceso = '" + idTipoProceso + "'"))
		return false;

	if(!this.iface.tiempoUnidadProceso(idTipoProceso))
		return false;

	return true;
}

/** \D
Recalcula el tiempo medio correspondiente a los procesos del tipo especificado
@param idTipoProceso: Tipo de proceso a recalcular
@return VERDADERO si el cálculo se realiza correctamente. FALSO en otro caso
\end */
function oficial_tiempoUnidadProceso(idTipoProceso:String):Boolean
{
	var util:FLUtil = new FLUtil();
	var unidad:String = "";
	var tiempoUnidad:Number = 0;
	var tiempoMedio:Number = parseFloat(util.sqlSelect("pr_tiposproceso", "tiempomedio", "idtipoproceso = '" + idTipoProceso + "'"));

	if (tiempoMedio && tiempoMedio != 0) {
		unidad = util.sqlSelect("pr_tiposproceso", "unidad", "idtipoproceso = '" + idTipoProceso + "'");

		switch (unidad) {
			case "Segundos":
				tiempoUnidad = tiempoMedio;
				break;
			case "Minutos":
				tiempoUnidad = tiempoMedio / 60;
				break;
			case "Horas":
				tiempoUnidad = tiempoMedio / (60 * 60)
				break;
			case "Dias":
				tiempoUnidad = tiempoMedio / (60 * 60 * 24)
				break;
			default:
				tiempoUnidad = 0;
		}
	}
	if (!util.sqlUpdate("pr_tiposproceso", "tiempounidad", tiempoUnidad,  "idtipoproceso = '" + idTipoProceso + "'"))
		return false;
	
	return true;
}

/** \C
Cambia el estado de una tarea TERMINADA a EN CURSO.

@param curTareas: Cursor posicionado sobre la tarea a deshacer
@return VERDADERO si la tarea ha sido deshecha. FALSO en otro caso
\end */
function oficial_deshacerTareaTerminada(curTareas:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	var idTipoTarea:String = curTareas.valueBuffer("idtipotarea");
	var idTipoTareaPro:String = curTareas.valueBuffer("idtipotareapro");
	var idTarea:String = curTareas.valueBuffer("idtarea");
	var idProceso:String = curTareas.valueBuffer("idproceso");

/** \C Condiciones:

EL proceso asociado debe estar TERMINADO o EN CURSO
\end */
	if (curTareas.valueBuffer("estado") != "TERMINADA") {
		MessageBox.warning(util.translate("scripts", "La tarea a deshacer debe estar en estado TERMINADA"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
	var estadoProceso:String = util.sqlSelect("pr_procesos", "estado", "idProceso = " + idProceso);
	if (estadoProceso != "TERMINADO" && estadoProceso != "EN CURSO") {
		MessageBox.warning(util.translate("scripts", "El proceso asociado a la tarea debe estar en estado TERMINADO o EN CURSO"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
/** \C Debe ser una tarea final, o bien sus tareas subsiguientes deben estar en estado OFF o PTE.
Las tareas subsiguientes que estaban en estado PTE, pasan a estado OFF
\end */
	var esTareaFinal:Boolean = util.sqlSelect("pr_tipostareapro", "tareafinal", "idtipotareapro = " + idTipoTareaPro);
	if (!esTareaFinal) {
		if (!this.iface.desactivarSiguientesTareas(curTareas)) {
			return false;
		}
	} else {
/** \C Si la tarea está marcada como tarea de fin de proceso, pasa el proceso de TERMINADO a EN CURSO
\end */
		if (!this.iface.deshacerProcesoTerminado(idProceso))
			return false;
	}

	with(curTareas) {
		if (curTareas.modeAccess() != curTareas.Edit) {
			setModeAccess(curTareas.Edit);
			refreshBuffer();
		}
		setValueBuffer("estado", "EN CURSO");
		setNull("tiempofin");
		setNull("diafin");
		setNull("intervalo");
		setNull("tiempoinvertido");
	}
	if (!curTareas.commitBuffer())
		return false;
/** \C
El subestado del proceso pasará a ser el de la última tarea (mayor fecha de fin) en estado TERMINADA
\end */
	var subestadoProceso:String = "";
	var qryEstadoProceso:FLSqlQuery = new FLSqlQuery();
	with (qryEstadoProceso) {
		setTablesList("pr_tareas,pr_tipostareapro");
		setSelect("tt.subestadoproceso");
		setFrom("pr_tareas t INNER JOIN pr_tipostareapro tt ON t.idtipotareapro = tt.idtipotareapro");
		setWhere("t.idproceso = " + idProceso + " AND t.estado = 'TERMINADA' AND tt.subestadoproceso IS NOT NULL ORDER BY t.tiempofin DESC");
	}
	if (!qryEstadoProceso.exec())
		return false;
	if (qryEstadoProceso.first())
		subestadoProceso = qryEstadoProceso.value(0);
	else
		subestadoProceso = "";

	if (!util.sqlUpdate("pr_procesos", "subestado", subestadoProceso, "idproceso = " + idProceso))
		return false;

/** \C
El estado del objeto asociado al proceso pasará a ser el establecido en la última tarea (mayor fecha de fin) en estado TERMINADA, o el estado inicial en caso de no haber ninguna.
\end */
	var estadoObjeto:String = "";
	var qryEstadoObjeto:FLSqlQuery = new FLSqlQuery();
	with (qryEstadoObjeto) {
		setTablesList("pr_tareas,pr_tipostareapro");
		setSelect("tt.estadoobjeto");
		setFrom("pr_tareas t INNER JOIN pr_tipostareapro tt ON t.idtipotareapro = tt.idtipotareapro");
		setWhere("t.idproceso = " + idProceso + " AND t.estado = 'TERMINADA' AND tt.estadoobjeto IS NOT NULL ORDER BY t.tiempofin DESC");
	}
	if (!qryEstadoObjeto.exec())
		return false;
	if (qryEstadoObjeto.first())
		estadoObjeto = qryEstadoObjeto.value("tt.estadoobjeto");
	else {
		estadoObjeto = this.iface.estadoObjetoInicial(idProceso);
	}

	if (estadoObjeto && estadoObjeto != "") {
		if (!this.iface.cambiarEstadoObjeto(idProceso, estadoObjeto)) {
			return false;
		}
	}

/** \C
Si la tarea consumía algún tipo de material, se restituye el material al almacén.
\end */

/** \C
Si la tarea realizaba alguna acción específica al pasar a TERMINADA, la acción es deshecha
\end */
	if (!this.iface.deshacerTareaTerminadaEsp(curTareas))
		return false;

	return true;
}


function oficial_desactivarSiguientesTareas(curTareas:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	var idTipoTareaPro:String = curTareas.valueBuffer("idtipotareapro");
	var idProceso:String = curTareas.valueBuffer("idproceso");

	var qrySiguienteTarea:FLSqlQuery = new FLSqlQuery();
	with (qrySiguienteTarea) {
		setTablesList("pr_tipostareapro,pr_secuencias");
		setSelect("s.tareafin");
		setFrom("pr_tipostareapro tt INNER JOIN pr_secuencias s ON tt.idtipotareapro = s.tareainicio");
		setWhere("tt.idtipotareapro = " + idTipoTareaPro);
	}
	if (!qrySiguienteTarea.exec())
		return false;
	
	var estadoTareaSiguiente:String = "";
	while (qrySiguienteTarea.next()) {
		var qryDatosTareaSig:FLSqlQuery = new FLSqlQuery;
		with (qryDatosTareaSig) {
			setTablesList("pr_tareas");
			setSelect("idtarea, estado");
			setFrom("pr_tareas");
			setWhere("idproceso = " + idProceso + " AND idtipotareapro = " + qrySiguienteTarea.value("s.tareafin"))
			setForwardOnly(true);
		}
		if (!qryDatosTareaSig.exec())
			return false;
	
		if (!qryDatosTareaSig.first())
			return false;
	
		estadoTareaSiguiente = qryDatosTareaSig.value("estado");
		if (estadoTareaSiguiente != "OFF" && estadoTareaSiguiente != "PTE") {
			MessageBox.warning(util.translate("scripts", "La tarea a deshacer debe tener todas sus tareas subsiguientes en estado OFF o PTE"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			return false;
		}
		if (estadoTareaSiguiente == "PTE") {
			if (!util.sqlUpdate("pr_tareas", "estado", "OFF", "idtarea = '" + qryDatosTareaSig.value("idtarea") + "'"))
				return false;
		}
		return true;
	}
	return true;
}

/** \D Cambia el estado del objeto asociado a un proceso
@param	idPoceso: Identificador del proceso
@param	estadoObjeto: Estado del objeto
@return True si el cambio se realiza correctamente, False en otro caso
\end */
function oficial_cambiarEstadoObjeto(idProceso:Number, estadoObjeto:String):Boolean
{
	var util:FLUtil = new FLUtil;
	if (!estadoObjeto || estadoObjeto == "")
		return true;

	var qryProceso:FLSqlQuery = new FLSqlQuery();
	with (qryProceso) {
		setTablesList("pr_procesos,pr_tiposproceso");
		setSelect("p.idobjeto, tp.tipoobjeto");
		setFrom("pr_procesos p INNER JOIN pr_tiposproceso tp ON p.idtipoproceso = tp.idtipoproceso");
		setWhere("idproceso = '" + idProceso + "'");
	}
	if (!qryProceso.exec())
		return false;
	if (!qryProceso.first())
		return false;
	var idObjeto:String = qryProceso.value(0);
	var tipoObjeto:String  = qryProceso.value(1);
	if (!idObjeto || idObjeto == "" || !tipoObjeto || tipoObjeto == "")
		return true;

	if (!this.iface.actualizarEstadoObjeto(tipoObjeto, idObjeto, estadoObjeto)) {
		 return false;
	}
	return true;
}

/** Cambia el estado de un objeto. Esta función puede sobrecargarse para cambiar el cursor actual si hay un formulario asociado al objeto ya abierto
\end */
function oficial_actualizarEstadoObjeto(tipoObjeto:String, idObjeto:String, estadoObjeto:String):Boolean
{
	var util:FLUtil = new FLUtil;
	var curObjeto:FLSqlCursor = new FLSqlCursor(tipoObjeto);
	return util.sqlUpdate(tipoObjeto, "estado", estadoObjeto, curObjeto.primaryKey() + " = '" + idObjeto + "'");
}

/** \D Lee el estado del objeto asociado a un proceso
@param	idPoceso: Identificador del proceso
@return	Estado del objeto, "" si no existe y false si hay error
\end */
function oficial_estadoObjeto(idProceso:Number):String
{
	var util:FLUtil = new FLUtil;

	var qryProceso:FLSqlQuery = new FLSqlQuery();
	with (qryProceso) {
		setTablesList("pr_procesos,pr_tiposproceso");
		setSelect("p.idobjeto, tp.tipoobjeto");
		setFrom("pr_procesos p INNER JOIN pr_tiposproceso tp ON p.idtipoproceso = tp.idtipoproceso");
		setWhere("idproceso = '" + idProceso + "'");
	}
	if (!qryProceso.exec())
		return false;

	if (!qryProceso.first())
		return "";

	var idObjeto:String = qryProceso.value(0);
	var tipoObjeto:String  = qryProceso.value(1);
	if (!idObjeto || idObjeto == "" || !tipoObjeto || tipoObjeto == "")
		return "";

	var curObjeto:FLSqlCursor = new FLSqlCursor(tipoObjeto);
	curObjeto.select(curObjeto.primaryKey() + " = '" + idObjeto + "'");
	if (!curObjeto.first()) {
		return false;
	}
	curObjeto.setModeAccess(curObjeto.Browse);
	curObjeto.refreshBuffer();
	var estado:String = curObjeto.valueBuffer("estado");
	if (!estado) {
		estado = "";
	}
	return estado;
}

/** \C
Cambia el estado de la tarea de EN CURSO a PTE, deshaciendo también -si existe- a la acción asociada a la tarea
@param curTareas: Cursor posicionado sobre la tarea a iniciar
@return VERDADERO si la tarea ha sido deshecha. FALSO en otro caso
\end */
function oficial_deshacerTareaEnCurso(curTareas:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	var idTipoTarea:String = curTareas.valueBuffer("idtipotarea");
	var idTipoTareaPro:String = curTareas.valueBuffer("idtipotareapro");
	var idTarea:String = curTareas.valueBuffer("idtarea");
	var idProceso:String = curTareas.valueBuffer("idproceso");
	var estado:String = curTareas.valueBuffer("estado");

	if (!this.iface.deshacerTareaEnCursoEsp(curTareas))
		return false;

	with(curTareas) {
		setModeAccess(curTareas.Edit);
		refreshBuffer();
		setValueBuffer("estado", "PTE");
		setNull("tiempoinicio");
		setNull("diainicio");
		setNull("realizadapor");
	}
	if (!curTareas.commitBuffer())
		return false;

/** \C
Si la tarea pasada a PTE es la última del proceso, el proceso pasa también a PTE y restituye el objeto asociado a su estado previo
\end */
	if (this.iface.esTareaInicial(idTipoTareaPro)) {
		if (!util.sqlSelect("pr_tareas", "idtarea", "idproceso = " + idProceso + " AND estado NOT IN ('PTE', 'OFF')")) {
			if (!this.iface.deshacerProcesoEnCurso(idProceso))
				return false;
			var estadoObjeto:String = util.sqlSelect("pr_procesos", "estadoprevio", "idproceso = " + idProceso);
			if (!this.iface.cambiarEstadoObjeto(idProceso, estadoObjeto))
				return false;
		}
	}

// 	curTareas.select("idtarea = '" + idTarea + "'");
// 	curTareas.first();
// 	curTareas.setModeAccess(curTareas.Edit);
// 	curTareas.refreshBuffer();

	return true;
}

/** \C
Obtiene el estado del objeto asociado a un proceso que debe establecerse cuando el proceso tiene su primera tarea en estado 'EN CURSO', para denotar que el objeto se encuentra asociado a un proceso ya comenzado
@param curTareas: Cursor posicionado sobre la tarea a iniciar
@return Estado inicial del proceso, FALSO si hay error
\end */
function oficial_estadoObjetoInicial(idProceso:Number):String
{
	return "EN CURSO";
}

/** \C
Borra un proceso.
El proceso debe estar en estado PTE y todas sus tareas en estado OFF o PTE
@param idProceso: Identificador del proceso a borrar
@return True si el proceso se borró correctamente, false en caso contrario
\end */
function oficial_borrarProceso(idProceso:Number):Boolean
{
	var util:FLUtil = new FLUtil();
	var estadoProceso:String = util.sqlSelect("pr_procesos", "estado", "idproceso = " + idProceso);
	if (estadoProceso != "PTE" && estadoProceso != "OFF") {
		MessageBox.warning(util.translate("scripts", "Borrar proceso: El proceso debe estar en estado OFF o PTE"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var hayTareasIniciadas:Number = util.sqlSelect("pr_tareas", "idtarea", "idproceso = " + idProceso + " AND estado NOT IN ('PTE', 'OFF')");
	if (hayTareasIniciadas) {
		MessageBox.warning(util.translate("scripts", "Borrar proceso: Todas las tareas del proceso deben estar en estado OFF o PTE"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var paso:Number = 0;
	var curProcesos:FLSqlCursor = new FLSqlCursor("pr_procesos");
	curProcesos.select("idproceso = " + idProceso);

	while(curProcesos.next()) {
		curProcesos.setModeAccess(curProcesos.Del);
		curProcesos.refreshBuffer();
		if (!curProcesos.commitBuffer()) {
			MessageBox.critical(util.translate("scripts", "Borrar proceso: Hubo un error al borrar el proceso"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}

	var curTareas:FLSqlCursor = new FLSqlCursor("pr_tareas");
	curTareas.select("idproceso = " + idProceso);

	while(curTareas.next()) {
		curTareas.setModeAccess(curTareas.Del);
		curTareas.refreshBuffer();
		if (!curTareas.commitBuffer()) {
			MessageBox.critical(util.translate("scripts", "Borrar tareas: Hubo un error al borrar las tareas asociadas al proceso"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}
	return true;
}

/** \C
Detiene un proceso.
El proceso debe estar en estado EN CURSO o CANCELADO y todas sus tareas en estado OFF, PTE, TERMINADA, CANCELADA (ninguna EN CURSO)
Las tareas en estado PTE o CANCELADA pasan a DETENIDA
@param idProceso: Identificador del proceso a detener
@return True si el proceso se detuvo correctamente, false en caso contrario
\end */
function oficial_detenerProceso(idProceso:Number):Boolean
{
	if (!this.iface.previoDetenerProceso(idProceso)) {
		return false;
	}
	var util:FLUtil = new FLUtil();
	var estadoProceso:String = util.sqlSelect("pr_procesos", "estado", "idproceso = " + idProceso);
	if (estadoProceso != "PTE" && estadoProceso != "EN CURSO" && estadoProceso != "CANCELADO") {
		MessageBox.warning(util.translate("scripts", "Detener proceso: El proceso debe estar en estado PTE, EN CURSO o CANCELADO"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var hayTareasEnCurso:Number = util.sqlSelect("pr_tareas", "idtarea", "idproceso = " + idProceso + " AND estado = 'EN CURSO'");
	if (hayTareasEnCurso) {
		MessageBox.warning(util.translate("scripts", "Detener proceso: No es posible detener el proceso porque alguna de sus tareas esta EN CURSO"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	if (!util.sqlUpdate("pr_tareas", "estado", "DETENIDA", "idproceso = '" + idProceso + "' AND estado IN ('PTE', 'CANCELADA')")) {
		MessageBox.warning(util.translate("scripts", "Ha habido un error al detener el proceso"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	if (!util.sqlUpdate("pr_procesos", "estado", "DETENIDO", "idproceso = '" + idProceso + "'")) {
		MessageBox.warning(util.translate("scripts", "Ha habido un error al detener el proceso"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	return true;
}

/** \C
Cancela un proceso.
El proceso debe estar en estado EN CURSO o DETENIDO y todas sus tareas en estado OFF, PTE, TERMINADA o DETENIDA (ninguna EN CURSO)
Las tareas en estado PTE o DETENIDA pasan a CANCELADA
@param idProceso: Identificador del proceso a cancelar
@return True si el proceso se canceló correctamente, false en caso contrario
\end */
function oficial_cancelarProceso(idProceso:Number):Boolean
{
	if (!this.iface.previoCancelarProceso(idProceso)) {
		return false;
	}
	var util:FLUtil = new FLUtil();
	var estadoProceso:String = util.sqlSelect("pr_procesos", "estado", "idproceso = " + idProceso);
	if (estadoProceso == "CANCELADO") {
		return true;
	}
	if (estadoProceso != "PTE" && estadoProceso != "EN CURSO" && estadoProceso != "DETENIDO") {
		MessageBox.warning(util.translate("scripts", "Cancelar proceso: El proceso debe estar en estado PTE, EN CURSO o DETENIDO"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var hayTareasEnCurso:Number = util.sqlSelect("pr_tareas", "idtarea", "idproceso = " + idProceso + " AND estado = 'EN CURSO'");
	if (hayTareasEnCurso) {
		MessageBox.warning(util.translate("scripts", "Cancelar proceso: Alguna de las tareas del proceso está EN CURSO"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	if (!util.sqlUpdate("pr_tareas", "estado", "CANCELADA", "idproceso = '" + idProceso + "' AND estado IN ('PTE', 'DETENIDA')")) {
		MessageBox.critical(util.translate("scripts", "Cancelar proceso: Hubo un error al cancelar el proceso"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	if (!util.sqlUpdate("pr_procesos", "estado", "CANCELADO", "idproceso = '" + idProceso + "'")) {
		MessageBox.critical(util.translate("scripts", "Cancelar proceso: Hubo un error al cancelar el proceso"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	return true;
}

/** \C
Reanuda un proceso DETENIDO o CANCELADO, pasando a EN CURSO
Las tareas en estado DETENIDA o CANCELADA pasan a PTE
@param idProceso: Identificador del proceso a cancelar
@return True si el proceso se reanudó correctamente, false en caso contrario
\end */
function oficial_reanudarProceso(idProceso:Number):Boolean
{
	if (!this.iface.previoReanudarProceso(idProceso)) {
		return false;
	}
	var util:FLUtil = new FLUtil();
	var estadoProceso:String = util.sqlSelect("pr_procesos", "estado", "idproceso = " + idProceso);
	if (estadoProceso != "DETENIDO" && estadoProceso != "CANCELADO") {
		MessageBox.warning(util.translate("scripts", "Reanudar proceso: El proceso debe estar DETENIDO o CANCELADO"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	if (!util.sqlUpdate("pr_tareas", "estado", "PTE", "idproceso = '" + idProceso + "' AND estado IN ('DETENIDA', 'CANCELADA')")) {
		MessageBox.critical(util.translate("scripts", "Reanudar proceso: Hubo un error al reanudar el proceso"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var estadoProceso:String;
	if (util.sqlSelect("pr_tareas", "idtarea", "idproceso = '" + idProceso + "' AND estado IN ('EN CURSO', 'TERMINADA')")) {
		estadoProceso = "EN CURSO";
	} else {
		estadoProceso = "PTE";
	}
	if (!util.sqlUpdate("pr_procesos", "estado", estadoProceso, "idproceso = '" + idProceso + "'")) {
		MessageBox.critical(util.translate("scripts", "Reanudar proceso: Hubo un error al reanudar el proceso"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	return true;
}

/** \D Inicia los elementos de seguimiento (procesos) de un formulario
@param	container: Formulario contenedor. Debe contener un groupBox con los controles a los que se hace referencia en la función
@param	datosS: Array con los siguientes datos<ul>
<li>tipoObjeto: Tipo de objeto relacionado con las tareas a mostrar<li/>
<li>idObjeto: Identificador del objeto<li/>
</ul>
@return	True se la iniciación se hace correctamente, false en caso contrario
\end */
function oficial_seguimientoOn(container:Object, datosS:Array):Boolean
{
	var util:FLUtil = new FLUtil;
	
	if (!container)
		return false;
	
	if (this.iface.container_)
		this.iface.seguimientoOff();

	if (this.iface.cursor_)
		delete this.iface.cursor_;
	

	this.iface.container_ = container;
	var tdbTareasS:FLTableDB = this.iface.container_.child("tdbTareasS");
	if (!tdbTareasS) {
		return false;
	}
	this.iface.cursor_ = this.iface.container_.child("tdbTareasS").cursor();;

	this.iface.tdbTareasS = this.iface.container_.child("tdbTareasS");
	this.iface.tbnDeshacerTareaS = this.iface.container_.child("tbnDeshacerTareaS");
	this.iface.tbnLanzarTareaS = this.iface.container_.child("tbnLanzarTareaS");
	this.iface.tbnEditTareaS = this.iface.container_.child("tbnEditTareaS");
	this.iface.tbnDeleteTareaS = this.iface.container_.child("tbnDeleteTareaS");

	this.iface.tbnVerTareaS = this.iface.container_.child("tbnVerTareaS");
	this.iface.tbnIniciarTareaS = this.iface.container_.child("tbnIniciarTareaS");
	this.iface.tbnDetenerProcesoS = this.iface.container_.child("tbnDetenerProcesoS");
	this.iface.tbnCancelarProcesoS = this.iface.container_.child("tbnCancelarProcesoS");
	this.iface.tbnReanudarProcesoS = this.iface.container_.child("tbnReanudarProcesoS");

	this.iface.chkPteS = this.iface.container_.child("chkPteS");
	this.iface.chkEnCursoS = this.iface.container_.child("chkEnCursoS");
	this.iface.chkTerminadaS = this.iface.container_.child("chkTerminadaS");
	this.iface.chkFueraPlazoS = this.iface.container_.child("chkFueraPlazoS");
	this.iface.chkETodasS = this.iface.container_.child("chkETodasS");
debug("this.iface.chkETodasS = " + this.iface.chkETodasS);
	this.iface.chkMiasS = this.iface.container_.child("chkMiasS");
	this.iface.chkDeMiGrupoS = this.iface.container_.child("chkDeMiGrupoS");
	this.iface.chkSinAsignarS = this.iface.container_.child("chkSinAsignarS");
	this.iface.chkTodasS = this.iface.container_.child("chkTodasS");
	
	//this.iface.tdbTareasS.setReadOnly(true);
	if (this.iface.chkPteS) {
		connect (this.iface.chkPteS, "clicked()", this, "iface.regenerarFiltroS()");
	}
	if (this.iface.chkEnCursoS) {
		connect (this.iface.chkEnCursoS, "clicked()", this, "iface.regenerarFiltroS()");
	}
	if (this.iface.chkTerminadaS) {
		connect (this.iface.chkTerminadaS, "clicked()", this, "iface.regenerarFiltroS()");
	}
	if (this.iface.chkFueraPlazoS) {
		connect (this.iface.chkFueraPlazoS, "clicked()", this, "iface.regenerarFiltroS()");
	}
	if (this.iface.chkETodasS ) {
debug("Conectando");
		connect (this.iface.chkETodasS , "clicked()", this, "iface.regenerarFiltroS()");
	}
	if (this.iface.chkMiasS) {
		connect (this.iface.chkMiasS, "clicked()", this, "iface.regenerarFiltroS()");
	}
	if (this.iface.chkDeMiGrupoS) {
		connect (this.iface.chkDeMiGrupoS, "clicked()", this, "iface.regenerarFiltroS()");
	}
	if (this.iface.chkSinAsignarS) {
		connect (this.iface.chkSinAsignarS, "clicked()", this, "iface.regenerarFiltroS()");
	}
	if (this.iface.chkTodasS) {
		connect (this.iface.chkTodasS, "clicked()", this, "iface.regenerarFiltroS()");
	}
	
	if (this.iface.tbnLanzarTareaS) {
		connect (this.iface.tbnLanzarTareaS, "clicked()", this, "iface.tbnLanzarTareaSClicked()");
	}
	if (this.iface.tbnEditTareaS) {
		connect (this.iface.tbnEditTareaS, "clicked()", this, "iface.tbnEditTareaSClicked()");
	}
	if (this.iface.tbnDeleteTareaS) {
		connect (this.iface.tbnDeleteTareaS, "clicked()", this, "iface.tbnDeleteTareaSClicked()");
	}

	if (this.iface.tbnVerTareaS) {
		connect (this.iface.tbnVerTareaS, "clicked()", this, "iface.tbnVerTareaSClicked()");
	}
	if (this.iface.tbnIniciarTareaS) {
		connect (this.iface.tbnIniciarTareaS, "clicked()", this, "iface.tbnIniciarTareaSClicked()");
	}
	if (this.iface.tbnDetenerProcesoS) {
		connect (this.iface.tbnDetenerProcesoS, "clicked()", this, "iface.tbnDetenerProcesoSClicked()");
	}
	if (this.iface.tbnCancelarProcesoS) {
		connect (this.iface.tbnCancelarProcesoS, "clicked()", this, "iface.tbnCancelarProcesoSClicked()");
	}
	if (this.iface.tbnReanudarProcesoS) {
		connect (this.iface.tbnReanudarProcesoS, "clicked()", this, "iface.tbnReanudarProcesoSClicked()");
	}
	if (this.iface.tbnDeshacerTareaS) {
		connect (this.iface.tbnDeshacerTareaS, "clicked()", this, "iface.tbnDeshacerTareaSClicked()");
	}
	
	connect (this.iface.tdbTareasS, "currentChanged()", this, "iface.procesarEstadoS");


	this.iface.tipoObjeto_ = datosS["tipoObjeto"];
	this.iface.idObjeto_ = datosS["idObjeto"];
	this.iface.filtroFormulario_ = "";
	this.iface.valoresDefectoFiltroS();
	this.iface.regenerarFiltroS();

	return true;
}

function oficial_seguimientoOff()
{
	if (!this.iface.container_)
		return;
/*
	disconnect (this.iface.chkPteS, "clicked()", this, "iface.regenerarFiltroS()");
	disconnect (this.iface.chkEnCursoS, "clicked()", this, "iface.regenerarFiltroS()");
	disconnect (this.iface.chkTerminadaS, "clicked()", this, "iface.regenerarFiltroS()");
	disconnect (this.iface.chkMiasS, "clicked()", this, "iface.regenerarFiltroS()");
	disconnect (this.iface.chkDeMiGrupoS, "clicked()", this, "iface.regenerarFiltroS()");
	disconnect (this.iface.chkSinAsignarS, "clicked()", this, "iface.regenerarFiltroS()");
	disconnect (this.iface.chkTodasS, "clicked()", this, "iface.regenerarFiltroS()");
	
	disconnect (this.iface.tbnLanzarTareaS, "clicked()", this, "iface.tbnLanzarTareaSClicked()");
	disconnect (this.iface.tbnEditTareaS, "clicked()", this, "iface.tbnEditTareaSClicked()");
	disconnect (this.iface.tbnDeleteTareaS, "clicked()", this, "iface.tbnDeleteTareaSClicked()");

	disconnect (this.iface.tbnVerTareaS, "clicked()", this, "iface.tbnVerTareaSClicked()");

	disconnect (this.iface.tbnIniciarTareaS, "clicked()", this, "iface.tbnIniciarTareaSClicked()");
	disconnect (this.iface.tbnDeshacerTareaS, "clicked()", this, "iface.tbnDeshacerTareaSClicked()");
	disconnect (this.iface.tdbTareasS, "currentChanged()", this, "iface.procesarEstadoS");
*/
}

/** \D Regenera el filtro en función de los criterios de búsqueda de tareas especificados por el usuario
\end */
function oficial_regenerarFiltroS()
{
	var filtro:String = "";
	if (this.iface.tipoObjeto_ != "todos") {
		filtro = "tipoobjeto = '" + this.iface.tipoObjeto_ + "' AND idobjeto = '" + this.iface.idObjeto_ + "'";
	}

	var filtroEs:String = this.iface.filtroEstadoS();
	if (filtroEs) {
		if (filtro != "") {
			filtro += " AND ";
		}
		filtro += filtroEs;
	}
	var filtroPro:String = this.iface.filtroPropietarioS();
	if (filtroPro) {
		if (filtro != "") {
			filtro += " AND ";
		}
		filtro += filtroPro;
	}
	
	if (this.iface.filtroFormulario_ && this.iface.filtroFormulario_ != "") {
		if (filtro != "") {
			filtro += " AND ";
		}
		filtro += this.iface.filtroFormulario_;
	}
debug("Filtro = " + filtro);
	this.iface.tdbTareasS.cursor().setMainFilter(filtro);
	this.iface.tdbTareasS.refresh();
	this.iface.procesarEstadoS();
}

/** \D Construye la parte del filtro de tareas referente al estado
@return	Filtro
\end */
function oficial_filtroEstadoS():String
{
	if (!this.iface.chkPteS) {
		return "1 = 1";
	}
debug("oficial_filtroEstadoS");
	if (this.iface.chkETodasS && this.iface.chkETodasS.checked) {
debug("OK todas");
		return "estado <> 'OFF'";
	}
	var filtro:String = "";
	var listaEstados = "";
	if (this.iface.chkPteS && this.iface.chkPteS.checked)
		listaEstados += "'PTE'";

	if (this.iface.chkEnCursoS && this.iface.chkEnCursoS.checked) {
		if (listaEstados != "")
			listaEstados += ", ";
		listaEstados += "'EN CURSO'";
	}

	if (this.iface.chkTerminadaS && this.iface.chkTerminadaS.checked) {
		if (listaEstados != "")
			listaEstados += ", ";
		listaEstados += "'TERMINADA'";
	}
	
	if (listaEstados != "") {
		filtro = "estado IN (" + listaEstados + ")";
	}

	if (this.iface.chkFueraPlazoS && this.iface.chkFueraPlazoS.checked) {
		if (filtro != "") {
			filtro += " AND ";
		}
		filtro += "((estado = 'PTE' AND (fechainicioprev < CURRENT_DATE OR (fechainicioprev = CURRENT_DATE AND horainicioprev < CURRENT_TIME))) OR (estado IN ('PTE', 'EN CURSO') AND (fechafinprev < CURRENT_DATE OR (fechafinprev = CURRENT_DATE AND horafinprev < CURRENT_TIME))))";
	}
	
	if (filtro == "") {
		filtro = "1 = 2";
	}
	return filtro;
}


/** \D Construye la parte del filtro de tareas referente al propietario de las mismas
@return	Filtro
\end */
function oficial_filtroPropietarioS():String
{
	if (!this.iface.chkMiasS)
		return "1 = 1";
	
	var util:FLUtil = new FLUtil;
	var preFiltro:String = "(";
	var filtro:String = "";
	var idUsuario:String = sys.nameUser();
	var idGrupo:String = util.sqlSelect("flusers", "idgroup", "iduser = '" + idUsuario + "'");

	if (this.iface.chkMiasS && this.iface.chkMiasS.checked)
		preFiltro += "iduser = '" + idUsuario + "'";

	if (this.iface.chkDeMiGrupoS && this.iface.chkDeMiGrupoS.checked && idGrupo) {
		if (preFiltro != "(")
			preFiltro += " OR ";
		preFiltro += "idgroup = '" + idGrupo + "'";
	}

	if (this.iface.chkSinAsignarS && this.iface.chkSinAsignarS.checked) {
		if (preFiltro != "(")
			preFiltro += " OR ";
		preFiltro += "iduser IS NULL";
	}

	if (this.iface.chkTodasS && this.iface.chkTodasS.checked) {
		preFiltro = ""
	}

	if (preFiltro == "")
		filtro = "";
	else if (preFiltro == "(")
		filtro = "1 = 2";
	else
		filtro = preFiltro + ")";

	return filtro;
}

function oficial_valoresDefectoFiltroS()
{
	if (this.iface.chkMiasS) {
		this.iface.chkMiasS.checked = true;
	}
	if (this.iface.chkDeMiGrupoS) {
		this.iface.chkDeMiGrupoS.checked = true;
	}
	if (this.iface.chkPteS) {
		this.iface.chkPteS.checked = true;
	}
	if (this.iface.chkEnCursoS) {
		this.iface.chkEnCursoS.checked = true;
	}
}

/** \D
Si la tarea está en estado PTE, llama a iniciarTarea. Si está en estado EN CURSO, llama a terminarTarea
\end */
function oficial_tbnIniciarTareaSClicked(idUsuario:String):Boolean
{
	var util:FLUtil = new FLUtil;
	var ok:Boolean = true;
	if (!this.iface.cursor_.isValid()) {
		ok = false;
		return ok;
	}

	if (!idUsuario)
		idUsuario = sys.nameUser();
	if (!util.sqlSelect("flusers", "iduser", "iduser = '" + idUsuario + "'")) {
		MessageBox.warning(util.translate("scripts", "El usuario actual (%1) no está dado de alta en la tabla de usuarios del módulo de Administración.\nDebe dar de alta este usuario antes de realizar tareas con él.").arg(idUsuario), MessageBox.Ok, MessageBox.NoButton);
		ok = false;
		return ok;
	}
	var curTarea:FLSqlCursor = new FLSqlCursor("pr_tareas");
	curTarea.select("idtarea = '" + this.iface.cursor_.valueBuffer("idtarea") + "'");
	if (!curTarea.first()) {
		ok = false;
		return ok;
	}

	this.iface.cursor_.refreshBuffer();

	if (this.iface.cursor_.valueBuffer("estado") == "EN CURSO") {
		this.iface.cursor_.transaction(false);
		try {
			if (this.iface.terminarTarea(curTarea))
				this.iface.cursor_.commit();
			else {
				this.iface.cursor_.rollback();
				ok = false;
			}
		} catch(e) {
			ok = false;
			this.iface.cursor_.rollback();
			MessageBox.critical(util.translate("scripts", "Hubo un error en la finalización de la tarea:\n") + e, MessageBox.Ok, MessageBox.NoButton);
		}
	}
	if (this.iface.cursor_.valueBuffer("estado") == "PTE") {
		var unPaso:Boolean = util.sqlSelect("pr_tipostareapro", "terminaenunpaso", "idtipotareapro = " + curTarea.valueBuffer("idtipotareapro"));
		
		this.iface.cursor_.transaction(false);
		try {
			if (this.iface.iniciarTarea(curTarea, idUsuario))
				if (unPaso) {
					if (this.iface.terminarTarea(curTarea)) {
						this.iface.cursor_.commit();
					} else {
						this.iface.cursor_.rollback();
						ok = false;
					}
				} else {
					this.iface.cursor_.commit();
				}
			else {
				this.iface.cursor_.rollback();
				ok = false;
			}
		} catch(e) {
			ok = false;
			this.iface.cursor_.rollback();
			MessageBox.critical(util.translate("scripts", "Hubo un error en el inicio de la tarea:\n") + e, MessageBox.Ok, MessageBox.NoButton);
		}
	}
	this.iface.tdbTareasS.refresh();
	this.iface.procesarEstadoS();
	return ok;
}

/** \D
Si la tarea está en estado PTE, llama a detener proceso
\end */
function oficial_tbnDetenerProcesoSClicked():Boolean
{
	var util:FLUtil = new FLUtil;
	var ok:Boolean = true;
	if (!this.iface.cursor_.isValid()) {
		ok = false;
		return ok;
	}

	var idProceso:String = this.iface.cursor_.valueBuffer("idproceso");
	this.iface.cursor_.transaction(false);
	try {
		if (this.iface.detenerProceso(idProceso)) {
			this.iface.cursor_.commit();
		} else {
			this.iface.cursor_.rollback();
			return false;
		}
	} catch(e) {
		this.iface.cursor_.rollback();
		MessageBox.critical(util.translate("scripts", "Hubo un error al detener el proceso:\n") + e, MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	this.iface.tdbTareasS.refresh();
	this.iface.procesarEstadoS();
	return true;
}

/** \D
Si la tarea está en estado PTE, llama a cancelar proceso
\end */
function oficial_tbnCancelarProcesoSClicked():Boolean
{
	var util:FLUtil = new FLUtil;
	var ok:Boolean = true;
	if (!this.iface.cursor_.isValid()) {
		ok = false;
		return ok;
	}

	var idProceso:String = this.iface.cursor_.valueBuffer("idproceso");

	this.iface.cursor_.transaction(false);
	try {
		if (this.iface.cancelarProceso(idProceso)) {
			this.iface.cursor_.commit();
		} else {
			this.iface.cursor_.rollback();
			return false;
		}
	} catch(e) {
		this.iface.cursor_.rollback();
		MessageBox.critical(util.translate("scripts", "Hubo un error a ldetener el proceso:\n") + e, MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	this.iface.tdbTareasS.refresh();
	this.iface.procesarEstadoS();
	return true;
}

/** \D
Si la tarea está en estado PTE, llama a reanudar proceso
\end */
function oficial_tbnReanudarProcesoSClicked():Boolean
{
	var util:FLUtil = new FLUtil;
	var ok:Boolean = true;
	if (!this.iface.cursor_.isValid()) {
		ok = false;
		return ok;
	}

	var idProceso:String = this.iface.cursor_.valueBuffer("idproceso");
	this.iface.cursor_.transaction(false);
	try {
		if (this.iface.reanudarProceso(idProceso)) {
			this.iface.cursor_.commit();
		} else {
			this.iface.cursor_.rollback();
			return false;
		}
	} catch(e) {
		this.iface.cursor_.rollback();
		MessageBox.critical(util.translate("scripts", "Hubo un error a ldetener el proceso:\n") + e, MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	this.iface.tdbTareasS.refresh();
	this.iface.procesarEstadoS();
	return true;
}

/** \D
Pulsación del botón deshacer
\end */
function oficial_tbnDeshacerTareaSClicked():Boolean
{
	if (!this.iface.cursor_.isValid())
		return false;

	var util:FLUtil = new FLUtil;
	this.iface.tbnDeshacerTareaS.enabled = false;
	var estado:String = this.iface.cursor_.valueBuffer("estado");
	if (estado != "TERMINADA" && estado != "EN CURSO") {
		MessageBox.warning(util.translate("scripts", "La tarea debe estar en estado TERMINADA o EN CURSO"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
	var unPaso:Boolean = util.sqlSelect("pr_tipostareapro", "terminaenunpaso", "idtipotareapro = " + this.iface.cursor_.valueBuffer("idtipotareapro"));
	var ok:Boolean = true;
	try {
		this.iface.cursor_.transaction(false);
		if (estado == "TERMINADA") {
			if (this.iface.deshacerTareaTerminada(this.iface.cursor_)) {
				if (unPaso) {
					if (!this.iface.deshacerTareaEnCurso(this.iface.cursor_)) {
						this.iface.cursor_.rollback();
						ok = false;
					}
				}
			} else {
				this.iface.cursor_.rollback();
				ok = false;
			}
		} else if (estado == "EN CURSO") {
			if (!this.iface.deshacerTareaEnCurso(this.iface.cursor_)) {
				this.iface.cursor_.rollback();
				ok = false;
			}
		}
		if (ok)
			this.iface.cursor_.commit();
	} catch(e) {
		this.iface.cursor_.rollback();
		ok = false;
		MessageBox.critical(util.translate("scripts", "Hubo un error al deshacer la tarea:\n") + e, MessageBox.Ok, MessageBox.NoButton);
	}
	this.iface.tdbTareasS.refresh();
	this.iface.procesarEstadoS();
	return ok;
}

/** \D
Habilita el botón 'Deshacer tarea' si el estado de la tarea seleccionada es TERMINADA o EN CURSO
\end */
function oficial_procesarEstadoS()
{
	if (!this.iface.cursor_) {
		var datosS:Array;
		datosS["tipoObjeto"] = "todos";
		datosS["idObjeto"] = "0";
		this.iface.seguimientoOn(formpr_inbox, datosS);
	}

	var estado:String = this.iface.cursor_.valueBuffer("estado");
	switch (estado) {
		case "PTE": {
			if (this.iface.tbnIniciarTareaS) {
				this.iface.tbnIniciarTareaS.enabled = true;
			}
			if (this.iface.tbnDeshacerTareaS) {
				this.iface.tbnDeshacerTareaS.enabled = false;
			}
			if (this.iface.tbnDetenerProcesoS) {
				this.iface.tbnDetenerProcesoS.enabled = true;
			}
			if (this.iface.tbnCancelarProcesoS) {
				this.iface.tbnCancelarProcesoS.enabled = true;
			}
			if (this.iface.tbnReanudarProcesoS) {
				this.iface.tbnReanudarProcesoS.enabled = false;
			}
			break;
		}
		case "EN CURSO": {
			if (this.iface.tbnIniciarTareaS) {
				this.iface.tbnIniciarTareaS.enabled = true;
			}
			if (this.iface.tbnDeshacerTareaS) {
				this.iface.tbnDeshacerTareaS.enabled = true;
			}
			if (this.iface.tbnDetenerProcesoS) {
				this.iface.tbnDetenerProcesoS.enabled = false;
			}
			if (this.iface.tbnCancelarProcesoS) {
				this.iface.tbnCancelarProcesoS.enabled = false;
			}
			if (this.iface.tbnReanudarProcesoS) {
				this.iface.tbnReanudarProcesoS.enabled = false;
			}
			break;
		}
		case "TERMINADA": {
			if (this.iface.tbnIniciarTareaS) {
				this.iface.tbnIniciarTareaS.enabled = false;
			}
			if (this.iface.tbnDeshacerTareaS) {
				this.iface.tbnDeshacerTareaS.enabled = true;
			}
			if (this.iface.tbnDetenerProcesoS) {
				this.iface.tbnDetenerProcesoS.enabled = false;
			}
			if (this.iface.tbnCancelarProcesoS) {
				this.iface.tbnCancelarProcesoS.enabled = false;
			}
			if (this.iface.tbnReanudarProcesoS) {
				this.iface.tbnReanudarProcesoS.enabled = false;
			}
			break;
		}
		case "DETENIDA": {
			if (this.iface.tbnIniciarTareaS) {
				this.iface.tbnIniciarTareaS.enabled = false;
			}
			if (this.iface.tbnDeshacerTareaS) {
				this.iface.tbnDeshacerTareaS.enabled = false;
			}
			if (this.iface.tbnDetenerProcesoS) {
				this.iface.tbnDetenerProcesoS.enabled = false;
			}
			if (this.iface.tbnCancelarProcesoS) {
				this.iface.tbnCancelarProcesoS.enabled = true;
			}
			if (this.iface.tbnReanudarProcesoS) {
				this.iface.tbnReanudarProcesoS.enabled = true;
			}
			break;
		}
		case "CANCELADA": {
			if (this.iface.tbnIniciarTareaS) {
				this.iface.tbnIniciarTareaS.enabled = false;
			}
			if (this.iface.tbnDeshacerTareaS) {
				this.iface.tbnDeshacerTareaS.enabled = false;
			}
			if (this.iface.tbnDetenerProcesoS) {
				this.iface.tbnDetenerProcesoS.enabled = false;
			}
			if (this.iface.tbnCancelarProcesoS) {
				this.iface.tbnCancelarProcesoS.enabled = false;
			}
			if (this.iface.tbnReanudarProcesoS) {
				this.iface.tbnReanudarProcesoS.enabled = true;
			}
			break;
		}
	}
	this.iface.establecerAccionTareaS();
}

function oficial_establecerAccionTareaS()
{
	var idTipoTarea:String = this.iface.cursor_.valueBuffer("idtipotarea");
	switch (idTipoTarea) {
		default: {
			this.iface.cursor_.setAction("pr_tareas");
		}
	}
}

function oficial_tbnLanzarTareaSClicked()
{
	var util:FLUtil = new FLUtil;
	if (!this.iface.idObjeto_ || this.iface.idObjeto_ == "") {
		MessageBox.warning(util.translate("scripts", "No es posible asociar la tarea a un objeto sin identificador.\nGuarde el objeto y vuelva a lanzar la tarea"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	var tipoProceso:String = this.iface.obtenerTipoProcesoS();
	if (!tipoProceso)
		return false;
	this.iface.crearProceso(tipoProceso, this.iface.tipoObjeto_, this.iface.idObjeto_);
	this.iface.tdbTareasS.refresh();
}

function oficial_obtenerTipoProcesoS()
{
	var util:FLUtil = new FLUtil;
	var valor:String;
	switch (this.iface.tipoObjeto_) {
		case "clientes":
		case "crm_contactos":
		case "crm_tarjetas":
		case "crm_incidencias": {
			var qryProcesos:FLSqlQuery = new FLSqlQuery;
			with (qryProcesos) {
				setTablesList("pr_tiposproceso");
				setSelect("idtipoproceso, descripcion");
				setFrom("pr_tiposproceso");
				setWhere("accesiblecrm = true");
				setForwardOnly(true);
			}
			if (!qryProcesos.exec())
				return false;
			if (qryProcesos.size() < 1) {
				MessageBox.warning(util.translate("scripts", "No tiene definido ningún tipo de proceso como Accesible desde C.R.M.\nDebe crear y marcar los tipos de proceso que son accesibles desde el módulo C.R.M. en el módulo de procesos"), MessageBox.Ok, MessageBox.NoButton);
				return false;
			}
			var arrayProcesos:Array = [];
			var arrayOpciones:Array = [];
			while (qryProcesos.next()) {
				arrayProcesos[arrayProcesos.length] = qryProcesos.value("idtipoproceso");
				arrayOpciones[arrayOpciones.length] = qryProcesos.value("idtipoproceso") + " (" + qryProcesos.value("descripcion") + ")";
			}
			var procesoElegido:Number = this.iface.elegirOpcion(arrayOpciones);
			if (procesoElegido < 0)
				return false;
			valor = arrayProcesos[procesoElegido];
			break;
		}
		default: {
			var f:Object = new FLFormSearchDB("pr_tiposproceso");
			f.setMainWidget();
			valor = f.exec("idtipoproceso");
		}
	}
	return valor;
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

function oficial_tbnEditTareaSClicked()
{
	if (!this.iface.cursor_.isValid())
		return;
	
	this.iface.cursor_.editRecord();
}

function oficial_tbnDeleteTareaSClicked()
{
	var idProceso:String = this.iface.cursor_.valueBuffer("idproceso");
	if (!idProceso)
		return;
		
	this.iface.borrarProceso(idProceso);
	this.iface.tdbTareasS.refresh();
}

function oficial_tbnVerTareaSClicked()
{
	if (!this.iface.cursor_.isValid())
		return;
	
	this.iface.cursor_.browseRecord();
}

function oficial_filtroFormularioS(filtro:String)
{
	this.iface.filtroFormulario_ = filtro;
	this.iface.regenerarFiltroS();
}

/** \D Notifica vía email la asignación de una tarea a un usuario
@param	mensaje: Array con los datos del mensaje
@param	curTarea: Cursor posicionado en la tarea asignada
@return	True si la conexión se establece correctamente
|end */
function oficial_notificar(mensaje:Array):Boolean
{
	var util:FLUtil = new FLUtil;
	var dialogo = new Dialog;
	dialogo.okButtonText = util.translate("scripts", "Enviar");
	dialogo.cancelButtonText = util.translate("scripts", "Cancelar");

	var ledOrigen = new LineEdit;
	var emailOrigen:String;
	if (mensaje["usrorigen"]) {
		ledOrigen.label = util.translate("scripts", "De %1:").arg(mensaje["usrorigen"]);
		emailOrigen = util.sqlSelect("usuarios", "email", "idusuario = '" + mensaje["usrorigen"] + "'");
	} else {
		ledOrigen.label = util.translate("scripts", "De:");
		emailOrigen = util.sqlSelect("pr_config","emailnotificacion","1=1");
		if (!emailOrigen) {
			emailOrigen = "noreplay@workflow_engine";
		}
	}
// 	emailDestino = util.sqlSelect("usuarios", "email", "idusuario = '" + mensaje["usrdestino"] + "'");
	if (emailOrigen)
		ledOrigen.text = emailOrigen;
	dialogo.add(ledOrigen);

	var ledDestino = new LineEdit;
	var emailDestino:String;
	ledDestino.label = util.translate("scripts", "Para %1:").arg(mensaje["usrdestino"]);
	emailDestino = util.sqlSelect("usuarios", "email", "idusuario = '" + mensaje["usrdestino"] + "'");
	if (emailDestino)
		ledDestino.text = emailDestino;
	else
		ledDestino.text = mensaje["usrdestino"];
	dialogo.add(ledDestino);

	var ledAsunto = new LineEdit;
	ledAsunto.label = util.translate("scripts", "Asunto:");
	ledAsunto.text = mensaje["asunto"];
	dialogo.add(ledAsunto);

	var tedMensaje = new TextEdit;
	tedMensaje.text = mensaje["mensaje"];
	dialogo.add(tedMensaje);

	if (mensaje["editable"]) {
		if (!dialogo.exec())
			return true;
	}
	emailOrigen = ledOrigen.text;
	emailDestino = ledDestino.text;
	mensaje["asunto"] = ledAsunto.text;
	mensaje["mensaje"] = tedMensaje.text;
	
	var correo:FLSmtpClient = new FLSmtpClient;
	correo.setMailServer("localhost");
	correo.setFrom(emailOrigen);
	correo.setTo(emailDestino);
	correo.setSubject(mensaje["asunto"]);
	correo.setBody(mensaje["mensaje"]);
	if (!File.exists(Dir.home + "/tmpMail.txt"))
		File.write(Dir.home + "/tmpMail.txt", "Archivo adjunto auxiliar");
	//var ficheroTonto = new File("tmpMail.txt");
	//correo.addAttachment(ficheroTonto.fullName);
	correo.addAttachment(Dir.home + "/tmpMail.txt");
	correo.startSend();
	if (mensaje["editable"]) {
		MessageBox.information(util.translate("scripts", "Mensaje enviado"), MessageBox.Ok, MessageBox.NoButton);
	}

	return true;
}

/** \D Inicia un array con los datos del mensaje
@return	array - mensaje
\end */
function oficial_initMensaje():Array
{
	var mensaje:Array = [];

	mensaje["usrorigen"] = false;
	mensaje["usrdestino"] = false;
	mensaje["cc"] = false;
	mensaje["asunto"] = false;
	mensaje["mensaje"] = false;
	mensaje["editable"] = false;
	
	return mensaje;
}

function oficial_procesarEvento(datosEvento:Array):Boolean
{
	return true; // Función a sobrecargar 
}

function oficial_actualizarTiempoTotal(tipoObjeto:String, idObjeto:String)
{
	var util:FLUtil = new FLUtil();
	var tiempo:Number = this.iface.calcularTiempo(tipoObjeto, idObjeto);
	if (isNaN(tiempo))
		return false;

	switch (tipoObjeto) {
		case "cl_subproyectos": {
			if (formRecordcl_subproyectos.child("fdbCodSubproyecto"))
				formRecordcl_subproyectos.child("fdbTiempoTotal").setValue(tiempo);
			else
				util.sqlUpdate("cl_subproyectos", "tiempototal", tiempo, "codsubproyecto = '" + idObjeto + "'");
			break;
		}
		case "cl_proyectos": {
			if (formRecordcl_proyectos.child("fdbCodProyecto"))
				formRecordcl_proyectos.child("fdbTiempoTotal").setValue(tiempo);
			else
				util.sqlUpdate("cl_proyectos", "tiempototal", tiempo, "codproyecto = '" + idObjeto + "'");
			break;
		}
	}
	return true;
}

function oficial_calcularTiempo(tipoObjeto:String, idObjeto:String):Number
{
	var util:FLUtil = new FLUtil();
	var total:Number;
	switch (tipoObjeto) {
		case "cl_subproyectos": {
			total = util.sqlSelect("pr_tareas", "SUM(tiempoinvertido)", "tipoobjeto = '" + tipoObjeto + "' AND idobjeto = '" + idObjeto + "'");
		
			if (isNaN(total))
				return false;
			break;
		}
		case "cl_proyectos": {
			var tiempoTareas:Number = util.sqlSelect("pr_tareas", "SUM(tiempoinvertido)", "tipoobjeto = '" + tipoObjeto + "' AND idobjeto = '" + idObjeto + "'");
			if (isNaN(tiempoTareas))
				return false;

			var tiempoSubp:Number = util.sqlSelect("cl_subproyectos", "SUM(tiempototal)", "codproyecto = '" + idObjeto + "'");
			if (isNaN(tiempoSubp))
				return false;

			total = parseFloat(tiempoTareas + tiempoSubp);
			break;
		}
	}
	return total;
}

/** \D Convierte un tiempo en segundos a la unidad de medida del tipo de proceso
\end */
function oficial_convertirTiempoProceso(s:Number, idProceso:String):Number
{
	var util:FLUtil = new FLUtil;
	var valor:Number;
	var unidades:String;
	unidades = util.sqlSelect("pr_procesos p INNER JOIN pr_tiposproceso tp ON p.idtipoproceso = tp.idtipoproceso", "tp.unidad", "p.idproceso = " + idProceso, "pr_procesos,pr_tiposproceso");

	switch (unidades) {
		case "Segundos": {
			valor = s;
			break;
		}
		case "Minutos": {
			valor = s / 60;
			break;
		}
		case "Horas": {
			valor = s / 60 / 60;
			break;
		}
		case "Días": {
			valor = s / 24 / 60 / 60;
			break;
		}
	}
	return valor;
}

/** \D Convierte un tiempo de la unidad de medida del tipo de proceso a segundos
\end */
function oficial_convertirTiempoMS(tiempoProceso:Number, idProceso:String):Number
{
	var util:FLUtil = new FLUtil;
	var valor:Number;
	var unidades:String;
	unidades = util.sqlSelect("pr_procesos p INNER JOIN pr_tiposproceso tp ON p.idtipoproceso = tp.idtipoproceso", "tp.unidad", "p.idproceso = " + idProceso, "pr_procesos,pr_tiposproceso");
	switch (unidades) {
		case "Segundos": {
			valor = tiempoProceso;
			break;
		}
		case "Minutos": {
			valor = tiempoProceso * 60;
			break;
		}
		case "Horas": {
			valor = tiempoProceso * 60 * 60;
			break;
		}
		case "Días": {
			valor = tiempoProceso * 24 * 60 * 60;
			break;
		}
	}
	return valor;
}

/** \D Comprueba si es necesario recalcular los tiempos invertido y previsto de un proceso
@param	curTarea: Cursor asociado a la tarea que se ha modificado
\end */
function oficial_comprobarTotalTiempoProceso(curTarea:FLSqlCursor):Boolean
{
	switch (curTarea.modeAccess()) {
		case curTarea.Edit: {
			if (curTarea.valueBuffer("tiempoinvertido") != curTarea.valueBufferCopy("tiempoinvertido") || curTarea.valueBuffer("tiempoprevisto") != curTarea.valueBufferCopy("tiempoprevisto")) {
				if (!this.iface.actualizarTotalTiempoProceso(curTarea)) {
					return false;
				}
			}
			break;
		}
	}
	return true;
}

/** \D Modifica el tiempo invertido y previsto de un proceso
@param	curTarea: Cursor asociado a la tarea que se ha modificado
\end */
function oficial_actualizarTotalTiempoProceso(curTarea:FLSqlCursor):Boolean
{
	var curProceso:FLSqlCursor = curTarea.cursorRelation();
	if (curProceso && curProceso.table() == "pr_procesos") {
		return true;
	}
	curProceso = new FLSqlCursor("pr_procesos");
	curProceso.select("idproceso = " + curTarea.valueBuffer("idproceso"));
	if (!curProceso.first()) {
		return false;
	}
	curProceso.setModeAccess(curProceso.Edit);
	curProceso.refreshBuffer();
	curProceso.setValueBuffer("tiempoprevisto", formRecordpr_procesos.iface.pub_commonCalculateField("tiempoprevisto", curProceso));
	curProceso.setValueBuffer("tiempoinvertido", formRecordpr_procesos.iface.pub_commonCalculateField("tiempoinvertido", curProceso));
	if (!curProceso.commitBuffer()) {
		return false;
	}
	return true;
}

function oficial_calcularTiempoInvertido(curTareas:FLSqlCursor):Number
{debug("TP = " + this.iface.convertirTiempoProceso(curTareas.valueBuffer("intervalo"), curTareas.valueBuffer("idproceso")));
	return this.iface.convertirTiempoProceso(curTareas.valueBuffer("intervalo"), curTareas.valueBuffer("idproceso"));
}

/** Función a sobrecargar
\end */
function oficial_datosTarea():Boolean
{
	return true;
}

function oficial_borrarProcesosAsociados(tipoObjeto:String, idObjeto:String):Boolean
{
	var qryProcesos:FLSqlQuery = new FLSqlQuery;
	qryProcesos.setTablesList("pr_procesos");
	qryProcesos.setSelect("idproceso");
	qryProcesos.setFrom("pr_procesos");
	qryProcesos.setWhere("tipoobjeto = '" + tipoObjeto + "' AND idobjeto = '" + idObjeto + "'");
	qryProcesos.setForwardOnly(true);
	if (!qryProcesos.exec()) {
		return false;
	}
	while (qryProcesos.next()) {
		if (!this.iface.borrarProceso(qryProcesos.value("idproceso"))) {
			return false;
		}
	}
	return true;
}

/** \D Calcula el usuario y grupo al que hay que asignar la tarea actual segun los alias
@return	Array con dos elementos, idusuario e idgrupo
\end */
function oficial_calcularAsignacionTarea():Array
{
	var util:FLUtil = new FLUtil;
	var datos:Array = [];
	var idAlias:String = util.sqlSelect("pr_tipostareapro", "idalias", "idtipotareapro = " + this.iface.curTarea_.valueBuffer("idtipotareapro"));
	if (idAlias && idAlias != "" && idAlias != "0") {
		datos["idusuario"] = util.sqlSelect("pr_aliasproceso", "idusuariodef", "idalias = " + idAlias);
		datos["idgrupo"] = util.sqlSelect("pr_aliasproceso", "idgrupodef", "idalias = " + idAlias);
	} else {
		datos = false;
	}
	return datos;
}

/** \D Ejecuta una función pasando por parámetro el XML de un proceso y devuelve su resultado
@param	idProceso: Identificador del proceso
@param	condicion: Código de la función
\end */
function oficial_condicionOK(idProceso:String, condicion:String):Boolean
{
// debug("condicion = " + condicion);
	var nodoProceso:FLDomNode = this.iface.dameXMLProceso(idProceso);
	var eProceso:FLDomElement = false;
	if (nodoProceso) {
		eProceso = nodoProceso.toElement();
	}

	var funcionVal = new Function("eProceso", condicion);
	var resultado:Boolean = funcionVal(eProceso);
// debug("resultado = " + resultado);
	return resultado;
}


/** \D Función a sobrecargar. Indica si la condición para que una secuencia se aplique se cumple o no
@param	idProceso: Identificador del proceso
@param	secuencia: Nombre de la secuencia, construida como codTipoTareaInicio + " >> " + codTipoTareaFin
\end */
function oficial_condicionSecuenciaOK(idProceso:String, secuencia:String):Boolean
{
	return true;
}

function oficial_crearXMLProceso(curProceso:FLSqlCursor):FLDomDocument
{
	var util:FLUtil = new FLUtil;

	var idTipoProceso:String = curProceso.valueBuffer("idtipoproceso");
	var idProceso:String = curProceso.valueBuffer("idproceso");
	var contenido:String = "<Proceso IdProceso='" + idProceso + "' IdTipoProceso='" + idTipoProceso + "'>";
	contenido += "</Proceso>";

	var xmlDocProceso:FLDomDocument = new FLDomDocument;
	if (!xmlDocProceso.setContent(contenido))
		return false;
	
	return xmlDocProceso;
}

function oficial_dameXMLProceso(idProceso:String):FLDomNode
{
// debug("prod_dameXMLProceso " + idProceso);
	var util:FLUtil = new FLUtil;
	var xmlProceso:FLDomNode;
	var parametrosXML:String = util.sqlSelect("pr_procesos", "xmlparametros", "idproceso = " + idProceso);
	
	if (parametrosXML && parametrosXML != "") {
// debug("hay parametros");
		if (this.iface.xmlDocParametros_) {
			delete this.iface.xmlDocParametros_;
		}
		this.iface.xmlDocParametros_ = new FLDomDocument;
		if (!this.iface.xmlDocParametros_.setContent(parametrosXML)) {
			MessageBox.warning(util.translate("scripts", "Error al cargar los parámetros XML correspondientes al proceso %1").arg(idProceso), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
// debug(xmlDocParametros.toString(4));
		xmlProceso = this.iface.xmlDocParametros_.firstChild();
	}
	if (!xmlProceso) {
// debug("no hay proceso");
		return false;
	}
	return xmlProceso;
}

function oficial_accionesAuto():Array
{
	return this.iface.accionesAuto_;
}

/** \D establece un atributo del XML asociado a un proceso
@param	idProceso: Identificador del proceso
@param	atributo: Nombre del atributo
@param	valor: Valor del atributo
\end */
function oficial_establecerAtributoProceso(idProceso:String, atributo:String, valor:String):Boolean
{
	var curProceso:FLSqlCursor = new FLSqlCursor("pr_procesos");
	curProceso.select("idproceso = " + idProceso);
	if (!curProceso.first()) {
		return false;
	}
	curProceso.setModeAccess(curProceso.Edit);
	curProceso.refreshBuffer();
	var xmlProceso:FLDomDocument = new FLDomDocument;
	if (!xmlProceso.setContent(curProceso.valueBuffer("xmlparametros"))) {
		return false;
	}
	var eProceso:FLDomElement = xmlProceso.firstChild().toElement();
	eProceso.setAttribute(atributo, valor);
	curProceso.setValueBuffer("xmlparametros", xmlProceso.toString(4));
	if (!curProceso.commitBuffer()) {
		return false;
	}
	return true;
}

/// Para cuando se apliquen condiciones en funciones guardadas en los formularios
// function head_terminarTareaEsp(curTarea:FLSqlCursor):Boolean
// {
// 	var util:FLUtil = new FLUtil;
// 	var resultado:Boolean
// 	var funcionVal;
// 	var xmlProceso:FLDomDocument = new FLDomDocument();
// 	var eProceso:FLDomElement = false;
// 	var contenido:String;
// 
// 	var codigoTT:String = util.sqlSelect("pr_tipostareapro", "codigott", "idtipotareapro = '" + curTarea.valueBuffer("idtipotareapro") + "'");
// 	if (codigoTT && codigoTT != "") {
// 		var curProceso:FLSqlCursor = new FLSqlCursor("pr_procesos");
// 		curProceso.setActivatedCommitActions(false);
// 		curProceso.select("idproceso = " + curTarea.valueBuffer("idproceso"));
// 		if (!curProceso.first()) {
// 			return false;
// 		}
// 		curProceso.setModeAccess(curProceso.Edit);
// 		curProceso.refreshBuffer();
// 		contenido = curProceso.valueBuffer("xmlparametros");
// 		if (contenido && contenido != "") {
// 			xmlProceso.setContent(contenido);
// 			eProceso = xmlProceso.firstChild().toElement();
// 		}
// 		
// 		funcionVal = new Function("eProceso", codigoTT);
// 		resultado = funcionVal(eProceso);
// 		if (!resultado) {
// 			return false;
// 		}
// 		curProceso.setValueBuffer("xmlparametros", xmlProceso.toString(4));
// 		if (!curProceso.commitBuffer()) {
// 			return false;
// 		}
// 	}
// 	return true;
// }
// 
// function head_iniciarTareaEsp(curTarea:FLSqlCursor):Boolean
// {
// 	var util:FLUtil = new FLUtil;
// 	var resultado:Boolean
// 	var funcionVal;
// 	var xmlProceso:FLDomDocument = new FLDomDocument();
// 	var eProceso:FLDomElement = false;
// 	var contenido:String;
// 
// 	var codigoCT:String = util.sqlSelect("pr_tipostareapro", "codigoct", "idtipotareapro = '" + curTarea.valueBuffer("idtipotareapro") + "'");
// 	if (codigoCT && codigoCT != "") {
// 		var curProceso:FLSqlCursor = new FLSqlCursor("pr_procesos");
// 		curProceso.setActivatedCommitActions(false);
// 		curProceso.select("idproceso = " + curTarea.valueBuffer("idproceso"));
// 		if (!curProceso.first()) {
// 			return false;
// 		}
// 		curProceso.setModeAccess(curProceso.Edit);
// 		curProceso.refreshBuffer();
// 		contenido = curProceso.valueBuffer("xmlparametros");
// 		if (contenido && contenido != "") {
// 			xmlProceso.setContent(contenido);
// 			eProceso = xmlProceso.firstChild().toElement();
// 		}
// 		
// 		funcionVal = new Function("eProceso", codigoCT);
// 		resultado = funcionVal(eProceso);
// 		if (!resultado) {
// 			return false;
// 		}
// 		curProceso.setValueBuffer("xmlparametros", xmlProceso.toString(4));
// 		if (!curProceso.commitBuffer()) {
// 			return false;
// 		}
// 	}
// 	return true;
// }

function oficial_refrescarTareasS()
{
	if (this.iface.tdbTareasS) {
		this.iface.tdbTareasS.refresh();
	}
}

function oficial_setAccionesAuto(aa:Array)
{
	this.iface.accionesAuto_ = aa;
}

function oficial_arrayAccion(contexto:String, accion:String):Array
{
	var aAccion:Array = [];
	aAccion["usada"] = false;
	aAccion["contexto"] = contexto;
	aAccion["accion"] = accion;
	return aAccion;
}

/** \D Pasa una tarea a estado TERMINADA, realizando las acciones oportunas según sea el estado de la misma. hay estados para los que el paso a TERMINADA no es posible
@param curTarea: Cursor de la tarea
\end */
function oficial_terminarTareaPorEstado(curTarea:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	var idTarea:String = curTarea.valueBuffer("idtarea");
	switch (curTarea.valueBuffer("estado")) {
		case "PTE": {
			if (!this.iface.iniciarTarea(curTarea, sys.nameUser())) {
				return false;
			}
			curTarea.select("idtarea = '" + idTarea + "'");
			if (!curTarea.first()) {
				return false;
			}
			if (!this.iface.terminarTarea(curTarea)) {
				return false;
			}
			break;
		}
		case "EN CURSO": {
			if (!this.iface.terminarTarea(curTarea)) {
				return false;
			}
			break;
		}
		case "DORMIDA": {
			if (!this.iface.despertarTarea(curTarea)) {
				return false;
			}
			curTarea.select("idtarea = '" + idTarea + "'");
			if (!curTarea.first()) {
				return false;
			}
			if (!this.iface.terminarTareaPorEstado(curTarea)) {
				return false;
			}
			break;
		}
		case "TERMINADA": {
			break;
		}
		default: {
			return false;
		}
	}
	return true;
}

/** \D Pasa una tarea a estado EN CURSO, realizando las acciones oportunas según sea el estado de la misma. hay estados para los que el paso a EN CURSO no es posible
@param curTarea: Cursor de la tarea
\end */
function oficial_ponerTareaEnCursoPorEstado(curTarea:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	var idTarea:String = curTarea.valueBuffer("idtarea");
	switch (curTarea.valueBuffer("estado")) {
		case "PTE": {
			if (!this.iface.iniciarTarea(curTarea, sys.nameUser())) {
				return false;
			}
			break;
		}
		case "EN CURSO": {
			break;
		}
		case "DORMIDA": {
			if (!this.iface.despertarTarea(curTarea)) {
				return false;
			}
			curTarea.select("idtarea = '" + idTarea + "'");
			if (!curTarea.first()) {
				return false;
			}
			if (!this.iface.ponerTareaEnCursoPorEstado(curTarea)) {
				return false;
			}
			break;
		}
		case "TERMINADA": {
			if (!this.iface.deshacerTareaTerminada(curTarea)) {
				return false;
			}
			break;
		}
		default: {
			return false;
		}
	}
	return true;
}

/** \D Pasa una tarea a estado PTE, realizando las acciones oportunas según sea el estado de la misma. hay estados para los que el paso a PTE no es posible
@param curTarea: Cursor de la tarea
\end */
function oficial_ponerTareaPtePorEstado(curTarea:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	var idTarea:String = curTarea.valueBuffer("idtarea");
	switch (curTarea.valueBuffer("estado")) {
		case "PTE": {
			break;
		}
		case "EN CURSO": {
			if (!this.iface.deshacerTareaEnCurso(curTarea)) {
				return false;
			}
			break;
		}
		case "DORMIDA": {
			if (!this.iface.despertarTarea(curTarea)) {
				return false;
			}
			curTarea.select("idtarea = '" + idTarea + "'");
			if (!curTarea.first()) {
				return false;
			}
			if (!this.iface.ponerTareaPtePorEstado(curTarea)) {
				return false;
			}
			break;
		}
		case "TERMINADA": {
			if (!this.iface.deshacerTareaTerminada(curTarea)) {
				return false;
			}
			if (!this.iface.ponerTareaPtePorEstado(curTarea)) {
				return false;
			}
			break;
		}
		default: {
			return false;
		}
	}
	return true;
}

/** \D Pasa una tarea a estado DORMIDA, realizando las acciones oportunas según sea el estado actual de la misma. hay estados para los que el paso a DORMIDA no es posible
@param curTarea: Cursor de la tarea
@param fechaActivacion: Fecha de activación automática de la tarea
\end */
function oficial_dormirTareaPorEstado(curTarea:FLSqlCursor, fechaActivacion:String):Boolean
{
	var util:FLUtil = new FLUtil;
	var idTarea:String = curTarea.valueBuffer("idtarea");
	switch (curTarea.valueBuffer("estado")) {
		case "PTE":
		case "EN CURSO": {
			if (!this.iface.dormirTarea(curTarea, fechaActivacion)) {
				return false;
			}
			break;
		}
		default: {
			return false;
		}
	}
	return true;
}

/** \D Pasa una tarea a estado DORMIDA
@param curTarea: Cursor de la tarea
@param fechaActivacion: Fecha de activación automática de la tarea
\end */
function oficial_dormirTarea(curTarea:FLSqlCursor, fechaActivacion:String):Boolean
{
	var curTareaD:FLSqlCursor = new FLSqlCursor("pr_tareas");
	curTareaD.setActivatedCommitActions(false);
	curTareaD.select("idtarea = '" + curTarea.valueBuffer("idtarea") + "'");
	if (!curTareaD.first()) {
		return false;
	}
	if (!fechaActivacion || fechaActivacion == "") {
		fechaActivacion = this.iface.calcularFechaActivacion(curTarea);
	}
	curTareaD.setModeAccess(curTareaD.Edit);
	curTareaD.refreshBuffer();
	curTareaD.setValueBuffer("estado", "DORMIDA");
	curTareaD.setValueBuffer("fechaactivacion", fechaActivacion);
	if (!curTareaD.commitBuffer()) {
		return false;
	}
	return true;
}

/** \D Pasa una tarea de DORMIDA a PTE o EN CURSO
@param curTarea: Cursor de la tarea
\end */
function oficial_despertarTarea(curTarea:FLSqlCursor):Boolean
{
	var curTareaD:FLSqlCursor = new FLSqlCursor("pr_tareas");
	curTareaD.setActivatedCommitActions(false);
	curTareaD.select("idtarea = '" + curTarea.valueBuffer("idtarea") + "'");
	if (!curTareaD.first()) {
		return false;
	}
	curTareaD.setModeAccess(curTareaD.Edit);
	curTareaD.refreshBuffer();
	if (curTareaD.isNull("diainicio")) {
		curTareaD.setValueBuffer("estado", "PTE");
	} else {
		curTareaD.setValueBuffer("estado", "EN CURSO");
	}
	if (!curTareaD.commitBuffer()) {
		return false;
	}
	return true;
}

function oficial_calcularFechaActivacion(curTarea:FLSqlCursor):String
{
	var util:FLUtil;
	var fA:String;
	var hoy:String = util.sqlSelect("empresa", "CURRENT_DATE", "1=1");
	switch (curTarea.valueBuffer("idtipotareapro")) {
		case "X": {
			
			break;
		}
		default: {
			var dialogo:Dialog = new Dialog;
			dialogo.okButtonText = util.translate("scripts", "Aceptar");
			dialogo.cancelButtonText = util.translate("scripts", "Cancelar");
			var dedFechaActivacion:DateEdit = new DateEdit;
			dedFechaActivacion.date = hoy;
			dedFechaActivacion.minimum = hoy;
			dedFechaActivacion.label = util.translate("scripts", "Fecha de activación");
			dialogo.add(dedFechaActivacion);
			if (!dialogo.exec()) {
				return false;
			}
			fA = dedFechaActivacion.date;
		}
	}
	return fA;
}

function oficial_comprobarTareasInit()
{
	var util:FLUtil = new FLUtil;
	
	if (!this.iface.despertarTareasInit()) {
	}
	var idUsuario:String = sys.nameUser();
	var texto:String = util.translate("scripts", "Hola %1").arg(idUsuario);
	texto += "\n";
	texto += "\n";
	var pendientes:Number = parseInt(util.sqlSelect("pr_tareas", "COUNT(*)", "iduser = '" + idUsuario + "' AND estado = 'PTE'"));
	pendientes = (isNaN(pendientes) ? 0 : pendientes);
	
	var enCurso:Number = parseInt(util.sqlSelect("pr_tareas", "COUNT(*)", "realizadapor = '" + idUsuario + "' AND estado = 'EN CURSO'"));
	enCurso = (isNaN(enCurso) ? 0 : enCurso);
	
	if (pendientes == 0 && enCurso == 0) {
		texto += util.translate("scripts", "No hay tareas pendientes");
		texto += "\n";
	} else {
		if (pendientes > 0) {
			texto += util.translate("scripts", "Tiene %1 tareas Pendientes").arg(pendientes);
			texto += "\n";
		}
		if (enCurso > 0) {
			texto += util.translate("scripts", "Tiene %1 tareas En Curso").arg(enCurso);
			texto += "\n";
		}
		texto += util.translate("scripts", "¿Desea ir a la inbox?");

		var res:Number = MessageBox.information(texto, MessageBox.Yes, MessageBox.No);
		if (res == MessageBox.Yes) {
			this.iface.timerTareas = startTimer(3000, this.iface.mostrarInbox);
		}
	}
}

function oficial_mostrarInbox()
{
	killTimer(this.iface.timerTareas);
	var formInbox = new FLFormDB( "pr_inbox", 0, 1 );
	formInbox.setMainWidget();
	formInbox.show();
}

function oficial_despertarTareasInit()
{
	var util:FLUtil = new FLUtil;

	var hoy:String = util.sqlSelect("empresa", "CURRENT_DATE", "1 = 1");
	var curTareas:FLSqlCursor = new FLSqlCursor("pr_tareas");
	curTareas.setActivatedCommitActions(false);
	curTareas.select("estado = 'DORMIDA' AND fechaactivacion <='" + hoy + "'");
	while (curTareas.next()) {
		curTareas.setModeAccess(curTareas.Edit);
		curTareas.refreshBuffer();
		if (curTareas.isNull("diainicio")) {
			curTareas.setValueBuffer("estado", "PTE");
		} else {
			curTareas.setValueBuffer("estado", "EN CURSO");
		}
		if (!this.iface.despertarTareaEsp(curTareas)) {
		}
		if (!curTareas.commitBuffer()) {
		}
	}
}

function oficial_globalInit()
{
	var util:FLUtil = new FLUtil;
	
	var checkTareas:String = util.readSettingEntry("scripts/flcolaproc/checkTareas");
	if (checkTareas == "true") {
		this.iface.comprobarTareasInit();
	}
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
