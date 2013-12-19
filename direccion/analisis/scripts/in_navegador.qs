/***************************************************************************
                 in_navegador.qs  -  description
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
	function main() {
		return this.ctx.interna_main();
	}
	function init() {
		return this.ctx.interna_init();
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var password:String = "";
	var tiempoAnterior_:Number = 0;
	var anoMin_:Number;
	var anoMax_:Number;
// 	var colorDimSel_:Color;
// 	var colorDimNoSel_:Color;
// 	var colorDatTotal_:Color;
// 	var colorDatCabecera_:Color;
// 	var colorDatNormal_:Color;
// 	var colorMedSel_:Color;
// 	var colorMedNoSel_:Color;
	var colorDimSel_:String;
	var colorDimNoSel_:String;
	var colorDatTotal_:String;
	var colorDatCabecera_:String;
	var colorDatNormal_:String;
	var colorMedSel_:String;
	var colorMedNoSel_:String;
	var aColorGrafico_:Array;
	var CD_LABEL:Number;
	var CD_NOMBRE:Number
	var CD_FILTRO:Number;
	var CM_SEL:Number = 0;
	var CM_NOMBRE:Number = 1;
	var CM_LABEL:Number = 2;
	var DAT_C_CABECERA_:Number = 0;
	var DAT_C_MEDIDA_:Number = 1;
	var DAT_F_CABECERA_:Number = 0;
	var DAT_F_MEDIDA_:Number = 1;
	var xmlPosActual_:FLDomDocument;
	var xmlSchema_:FLDomDocument;
	var rptViewer_:FLReportViewer;
	var dim_:Array; /// Array de las dimensiones cargadas y sus valores
	var listaDim_:Array; /// Lista de las dimensiones cargadas
	var bloqueoMedidas_:Boolean;
	var posicionesMemo_:Array;
	var iPosActual_:Number;
	var totalPosicionesMemo_:Number;
	var cubo_:String;
	var arrayTabla_:Array;
	var iColOrdenacion_:Number;
	var seleccionValores_:String; /// Lista con los valores de una dimension seleccionados por el usuario
	var dimensiones_:Array; /// Lista de dimensiones 
	var medidas_:Array; /// Lista de medidas 
	var jerarquias_:Array; /// Lista de jerarquías
	var niveles_:Array; /// Lista de niveles
	var iDimensiones_:Array /// Array con índices a las dimensiones del cubo
	var iMedidas_:Array /// Array con índices a las medidas del cubo
	var iJerarquias_:Array /// Array con índices a las jerarquías del cubo
	var iNiveles_:Array /// Array con índices a los niveles del cubo
	var conexion_:String; /// Conexión a la base de datos de origen de datos
	var conexionBI_:String; /// Conexión a la base de datos de BI (cubos)
	var xmlDatos_:FLDomDocument;
	var xmlGrafico_:FLDomDocument;
// 	var xmlGraficoTabla_:FLDomDocument;
	var xmlReportTemplate_:FLDomDocumet;
	var xmlReportData_:FLDomDocumet;
	var xmlEstiloReport_:FLDomDocumet;
	var nivelesY_:Array /// Array con los niveles a mostrar en el eje Y de la tabla
	var nivelesX_:Array /// Array con los niveles a mostrar en el eje X de la tabla
	var medidasTabla_:Array; /// Array con las medidas a mostrar en la tabla
	var aColumnasTabla_:Array; /// Array con los datos asociados a las columnas de la tabla
	var aFilasTabla_:Array; /// Array con los datos asociados a las filas de la tabla
	var aTabla_:Array; /// Array con los datos de la tabla
	var aTablaRaw_:Array; /// Array con los datos de la tabla sin formato de número
	var nivelesTabla_:Array /// Array con los niveles a mostrar en ambos ejes de la tabla
	var columnasClaveX_:Array; /// Array con los índices de columna para cada combinación de niveles del eje X
	var interfazDatos_:String; /// Indica el tipo de interfaz usado para mostrar los datos (Tabla o gráfico)
	var tipoGrafico_:String;  /// Indica el tipo de gráfico usado para mostrar los datos
	var elementosY_:Array; /// Array de combinaciones de elementos de una consulta para el eje Y (por clave)
	var iElementosY_:Array; /// Array de claves de combinaciones de elementos de una consulta para el eje Y (por índice)
	var nombrePosActual_:String; /// Nombre de la posición actual
	var nivelBGMes_:String; /// Nivel TimeMonths que se controla mediante el button gruop de meses
	var nivelBGTrim_:String; /// Nivel TimeTerms que se controla mediante el button gruop de trimestres
	var nivelBGAnno_:String; /// Nivel TimeYears que se controla mediante el button gruop de años
	var numBotonesAno_:String; /// Número de botones de selección de año a mostrar
	var tablaMostrada_:Boolean; /// Indica si la tabla de datos de la pestaña Tabla está mostrada y con datos actualizados.
	var tablaCargada_:Boolean; /// Indica si la tabla de datos interna está cargada y con datos actualizados.
	var graficoMostrado_:Boolean; /// Indica si el gráfico de la pestaña Gráfico está mostrado y con datos actualizados.
	var informeMostrado_:Boolean; /// Indica si el informe de la pestaña Informe está mostrado y con datos actualizados.
	var cachePicGraficos_:Array; /// Array que almacena los objetos picture de cada gráfico para no tenerlos que volver a cargar
	function oficial( context ) { interna( context );}
	function conectar():Boolean {
		return this.ctx.oficial_conectar();
	}
	function crearCabeceraCol() {
		return this.ctx.oficial_crearCabeceraCol();
	}
	function crearCabeceraCol3(maxProps:Number):Boolean {
		return this.ctx.oficial_crearCabeceraCol3(maxProps);
	}
	function dameSeleccionValores() {
		return this.ctx.oficial_dameSeleccionValores();
	}
	function ponSeleccionValores(s:String) {
		return this.ctx.oficial_ponSeleccionValores(s);
	}
	function cargarCubo_clicked() {
		return this.ctx.oficial_cargarCubo_clicked();
	}
	function cargarCubo():Boolean {
		return this.ctx.oficial_cargarCubo();
	}
	function cerosIzquierda(numero:String, totalCifras:Number):String {
		return this.ctx.oficial_cerosIzquierda(numero, totalCifras);
	}
	function cargarHome():Boolean {
		return this.ctx.oficial_cargarHome();
	}
	function cargarPosicion(memorizar:Boolean):Boolean {
		return this.ctx.oficial_cargarPosicion(memorizar);
	}
	function cargarDatos():Boolean {
		return this.ctx.oficial_cargarDatos();
	}
// 	function mostrarTabla():Boolean {
// 		return this.ctx.oficial_mostrarTabla();
// 	}
	function cargarDatosTabla():Boolean {
		return this.ctx.oficial_cargarDatosTabla();
	}
	function crearTabla() {
		return this.ctx.oficial_crearTabla();
	}
	function tbnDimX_clicked() {
		return this.ctx.oficial_tbnDimX_clicked();
	}
	function tbnDimY_clicked() {
		return this.ctx.oficial_tbnDimY_clicked();
	}
// 	function dameListaDimensiones():Array {
// 		return this.ctx.oficial_dameListaDimensiones();
// 	}
	function obtenerAlias(campo):String {
		return this.ctx.oficial_obtenerAlias(campo);
	}
	function obtenerDimension():String {
		return this.ctx.oficial_obtenerDimension();
	}
// 	function obtenerDesDimension(dimension:String, clave:String):String {
// 		return this.ctx.oficial_obtenerDesDimension(dimension, clave);
// 	}
	function obtenerDesNivel(nombreNivel:String, clave:String):String {
		return this.ctx.oficial_obtenerDesNivel(nombreNivel, clave);
	}
	function obtenerOrdinalDimension(dimension:String, clave:String):String {
		return this.ctx.oficial_obtenerOrdinalDimension(dimension, clave);
	}
	function obtenerOrdinalNivel(nombreNivel:String, clave:String):String {
		return this.ctx.oficial_obtenerOrdinalNivel(nombreNivel, clave);
	}
	function obtenerOpcionEF(arrayOps:Array):String {
		return this.ctx.oficial_obtenerOpcionEF(arrayOps);
	}
	function cargarDimensionCliente():Boolean {
		return this.ctx.oficial_cargarDimensionCliente();
	}
	function cargarDimensionAgente():Boolean{
		return this.ctx.oficial_cargarDimensionAgente();
	}
	function cargarDimensionProvincia():Boolean{
		return this.ctx.oficial_cargarDimensionProvincia();
	}
	function cargarDimensionEjercicio(ejercicios:String):Boolean{
		return this.ctx.oficial_cargarDimensionEjercicio(ejercicios);
	}
	function cargarDimensionArticulo():Boolean{
		return this.ctx.oficial_cargarDimensionArticulo();
	}
	function cargarDimensionMesAnno():Boolean{
		return this.ctx.oficial_cargarDimensionMesAnno();
	}
	function cargarDimensionTrimestre():Boolean{
		return this.ctx.oficial_cargarDimensionTrimestre();
	}
	function cargarDimensionDia():Boolean{
		return this.ctx.oficial_cargarDimensionDia();
	}
	function ordenarFilasAsc(filaA:Array, filaB:Array):Number {
		return this.ctx.oficial_ordenarFilasAsc(filaA, filaB);
	}
	function ordenarFilasDesc(filaA:Array, filaB:Array):Number {
		return this.ctx.oficial_ordenarFilasDesc(filaA, filaB);
	}
	function cargarDimensiones(ejercicios:String):Boolean {
		return this.ctx.oficial_cargarDimensiones(ejercicios);
	}
	function cambiarFiltro(campo:String, lista:String):Boolean {
		return this.ctx.oficial_cambiarFiltro(campo, lista);
	}
	function obtenerSeleccionActual(campo:String):Array {
		return this.ctx.oficial_obtenerSeleccionActual(campo);
	}
	function construirConsulta():FLSqlQuery {
		return this.ctx.oficial_construirConsulta();
	}
	function construirConsultaX():FLSqlQuery {
		return this.ctx.oficial_construirConsultaX();
	}
	function listarClaves(campo:String, lista:String):String {
		return this.ctx.oficial_listarClaves(campo, lista);
	}
	function cargarFiltros():Boolean {
		return this.ctx.oficial_cargarFiltros();
	}
	function cargarMedidas():Boolean {
		return this.ctx.oficial_cargarMedidas();
	}
	function cargaBGMeses(lista:String):Boolean {
		return this.ctx.oficial_cargaBGMeses(lista);
	}
	function cargaBGTrimestres(lista:String):Boolean {
		return this.ctx.oficial_cargaBGTrimestres(lista);
	}
	function cargaBGAnnos(lista:String):Boolean {
		return this.ctx.oficial_cargaBGAnnos(lista);
	}
	function buscarElementoArray(elemento:String, aLista:Array):Number {
		return this.ctx.oficial_buscarElementoArray(elemento, aLista);
	}
// 	function tablaDimension(dimension:String):String {
// 		return this.ctx.oficial_tablaDimension(dimension);
// 	}
// 	function filtrarTabla(dimension:String) {
// 		return this.ctx.oficial_filtrarTabla(dimension);
// 	}
	function borrarFiltro(dimension:String):Boolean {
		return this.ctx.oficial_borrarFiltro(dimension);
	}
	function memorizarPosicion() {
		return this.ctx.oficial_memorizarPosicion();
	}
	function tbnPrevio_clicked() {
		return this.ctx.oficial_tbnPrevio_clicked();
	}
	function tbnSiguiente_clicked() {
		return this.ctx.oficial_tbnSiguiente_clicked();
	}
	function habilitarNavegacion() {
		return this.ctx.oficial_habilitarNavegacion();
	}
	function tbnGuardar_clicked() {
		return this.ctx.oficial_tbnGuardar_clicked();
	}
	function tbnGuardarComo_clicked() {
		return this.ctx.oficial_tbnGuardarComo_clicked();
	}
	function guardarPosicionActual():Boolean {
		return this.ctx.oficial_guardarPosicionActual();
	}
	function guardarGraficoPosicionActual():Boolean {
		return this.ctx.oficial_guardarGraficoPosicionActual();
	}
	function guardarComoPosicionActual(nombre:String):Boolean {
		return this.ctx.oficial_guardarComoPosicionActual(nombre);
	}
	function tbnAbrir_clicked() {
		return this.ctx.oficial_tbnAbrir_clicked();
	}
	function dibujar2dBarras(marco:Rect) {
		return this.ctx.oficial_dibujar2dBarras(marco);
	}
	function dibujar2dTabla(marco:Rect) {
		return this.ctx.oficial_dibujar2dTabla(marco);
	}
	function dibujar2dTarta(marco:Rec) {
		return this.ctx.oficial_dibujar2dTarta(marco);
	}
	function dibujar1dAguja(marco:Rect) {
		return this.ctx.oficial_dibujar1dAguja(marco);
	}
	function dibujar2dMapa(marco:Rect):Boolean {
		return this.ctx.oficial_dibujar2dMapa(marco);
	}
	function dameTipo2dMapa():String {
		return this.ctx.oficial_dameTipo2dMapa();
	}
	function dibujar2dMapaPaises(contenedor:Object, marco:Rect):Boolean {
		return this.ctx.oficial_dibujar2dMapaPaises(contenedor, marco);
	}
	function maximoColArray(colDesde:Number, colHasta:Number, divisiones:Number):Number {
		return this.ctx.oficial_maximoColArray(colDesde, colHasta, divisiones);
	}
	function obtenerDimActual(eje:String):String {
		return this.ctx.oficial_obtenerDimActual(eje);
	}
// 	function obtenerClaveColumna(iCol:Number):String {
// 		return this.ctx.oficial_obtenerClaveColumna(iCol);
// 	}
// 	function obtenerColumnaClave(clave:String):Number {
// 		return this.ctx.oficial_obtenerColumnaClave(clave);
// 	}
	function sbxLimite_valueChanged(valor:Number) {
		return this.ctx.oficial_sbxLimite_valueChanged(valor);
	}
	function chkLimitar_toggled(activo) {
		return this.ctx.oficial_chkLimitar_toggled(activo);
	}
	function tblDimensiones_doubleClicked(fila:Number, col:Number) {
		return this.ctx.oficial_tblDimensiones_doubleClicked(fila, col);
	}
	function seleccionarValoresNivel(nombreNivel:String, listaSel:String):String {
		return this.ctx.oficial_seleccionarValoresNivel(nombreNivel, listaSel);
	}
	function dameListaFiltro(dimension:String):String {
		return this.ctx.oficial_dameListaFiltro(dimension);
	}
	function iniciarTablaDimensiones() {
		return this.ctx.oficial_iniciarTablaDimensiones();
	}
// 	function obtenerElementosDim(nombreDim:String):Array {
// 		return this.ctx.oficial_obtenerElementosDim(nombreDim);
// 	}
	function obtenerMiembrosNivel(nombreNivel:String):Array {
		return this.ctx.oficial_obtenerMiembrosNivel(nombreNivel);
	}
	function obtenerMiembrosNivelLista(aNivel:Array):Array {
		return this.ctx.oficial_obtenerMiembrosNivelLista(aNivel);
	}
	function cambiarColorFilaTabla(tabla:Object, iFila:Number, colorFila:Color) {
		return this.ctx.oficial_cambiarColorFilaTabla(tabla, iFila, colorFila);
	}
	function cambiarColorColumnaTabla(tabla:Object, iCol:Number, colorCol:Color) {
		return this.ctx.oficial_cambiarColorColumnaTabla(tabla, iCol, colorCol);
	}
	function colores() {
		return this.ctx.oficial_colores();
	}
// 	function tbnFiltrarFilas_clicked() {
// 		return this.ctx.oficial_tbnFiltrarFilas_clicked();
// 	}
// 	function tbnFiltrarColumnas_clicked() {
// 		return this.ctx.oficial_tbnFiltrarColumnas_clicked();
// 	}
// 	function metadatosCampo(xmlTabla:FLDomDocument, campo:String):Array {
// 		return this.ctx.oficial_metadatosCampo(xmlTabla, campo);
// 	}
	function buscarEnArray(contenido:Array, valor:String):Number {
		return this.ctx.oficial_buscarEnArray(contenido, valor);
	}
// 	function construirJoin(dimension:Array, arrayJoins:Array):String {
// 		return this.ctx.oficial_construirJoin(dimension, arrayJoins);
// 	}
	function construirJoinNivel(aNivel:Array, arrayJoins:Array):String {
		return this.ctx.oficial_construirJoinNivel(aNivel, arrayJoins);
	}
	function dameColumnaSql(nombreDim:String):String {
		return this.ctx.oficial_dameColumnaSql(nombreDim);
	}
	function seleccionarMeses(listaActual:String):String {
		return this.ctx.oficial_seleccionarMeses(listaActual);
	}
	function seleccionarTrimestre(listaActual:String):String {
		return this.ctx.oficial_seleccionarTrimestre(listaActual);
	}
	function seleccionarValoresLista(listaCompleta:String, listaActual:String):String {
		return this.ctx.oficial_seleccionarValoresLista(listaCompleta, listaActual);
	}
	function seleccionarAno(listaActual:String):String {
		return this.ctx.oficial_seleccionarAno(listaActual);
	}
	function establecerAnos() {
		return this.ctx.oficial_establecerAnos();
	}
	function cargarMedida(nodoMed:FLDomDocument):Boolean {
		return this.ctx.oficial_cargarMedida(nodoMed);
	}
	function cargarDimension(nodoDim:FLDomDocument):Boolean {
		return this.ctx.oficial_cargarDimension(nodoDim);
	}
	function cargarJerarquia(nodoJer:FLDomDocument):Boolean {
		return this.ctx.oficial_cargarJerarquia(nodoJer);
	}
	function cargarJoinJerarquia(nodoJoin:FLDomNode, aJerarquia:Array):Boolean {
		return this.ctx.oficial_cargarJoinJerarquia(nodoJoin, aJerarquia);
	}
	function cargarNivel(nodoLevel:FLDomDocument):Boolean {
		return this.ctx.oficial_cargarNivel(nodoLevel);
	}
	function cargarTipoNivel(aNivel:Array):Boolean {
		return this.ctx.oficial_cargarTipoNivel(aNivel);
	}
	function cargarPropiedadesNivel(eLevel:FLDomElement):Boolean {
		return this.ctx.oficial_cargarPropiedadesNivel(eLevel);
	}
	function dameColumnaAgregadaSql(nombreMedida:String):String {
		return this.ctx.oficial_dameColumnaAgregadaSql(nombreMedida);
	}
	function dameSqlAgregacion(nombreMedida:String):String {
		return this.ctx.oficial_dameSqlAgregacion(nombreMedida);
	}
	function tblDatos_doubleClicked(row:Number, col:Number):String {
		return this.ctx.oficial_tblDatos_doubleClicked(row, col);
	}
	function expandirFila(row:Number):Boolean {
		return this.ctx.oficial_expandirFila(row);
	}
	function expandirColumna(col:Number):Boolean {
		return this.ctx.oficial_expandirColumna(col);
	}
	function contraerFila(row:Number):Boolean {
		return this.ctx.oficial_contraerFila(row);
	}
	function contraerColumna(col:Number):Boolean {
		return this.ctx.oficial_contraerColumna(col);
	}
	function dameCabeceraFila(iFila:Number):Boolean {
		return this.ctx.oficial_dameCabeceraFila(iFila);
	}
	function dameCabeceraFila3(iFila:Number):String {
		return this.ctx.oficial_dameCabeceraFila3(iFila);
	}
	function informaPropiedadesFila(iFila:Number, maxProps:Number):Boolean {
		return this.ctx.oficial_informaPropiedadesFila(iFila, maxProps);
	}
	function dameCabeceraColumna(iCol:Number):Boolean {
		return this.ctx.oficial_dameCabeceraColumna(iCol);
	}
	function dameCabeceraColumna3(iCol:Number):String {
		return this.ctx.oficial_dameCabeceraColumna3(iCol);
	}
	function dameClaveColumnaX(nivel:Number, eRow:FLDomElement, consultaX:FLSqlQuery):String {
		return this.ctx.oficial_dameClaveColumnaX(nivel, eRow, consultaX);
	}
	function bgrMedidas_clicked(iBoton:Number) {
		return this.ctx.oficial_bgrMedidas_clicked(iBoton);
	}
	function tblMedidas_doubleClicked(fil:Number, col:Number) {
		return this.ctx.oficial_tblMedidas_doubleClicked(fil, col);
	}
	function actualizarMedidas() {
		return this.ctx.oficial_actualizarMedidas();
	}
	function sincronizarNiveles():Boolean {
		return this.ctx.oficial_sincronizarNiveles();
	}
	function sincronizarNivel(aNivel:Array):Boolean {
		return this.ctx.oficial_sincronizarNivel(aNivel);
	}
	function cargarHomeDefectoCubo() {
		return this.ctx.oficial_cargarHomeDefectoCubo();
	}
	function establecerCubo() {
		return this.ctx.oficial_establecerCubo();
	}
	function pedirPassword() {
		return this.ctx.oficial_pedirPassword();
	}
	function seleccionarCubo() {
		return this.ctx.oficial_seleccionarCubo();
	}
	function informarArrayCubos(aCubos:Array):Boolean {
		return this.ctx.oficial_informarArrayCubos(aCubos);
	}
	function nombreCubo(idCubo:String):String {
		return this.ctx.oficial_nombreCubo(idCubo);
	}
	function tbnCubo_clicked() {
		return this.ctx.oficial_tbnCubo_clicked();
	}
	function mostrarDatos() {
		return this.ctx.oficial_mostrarDatos();
	}
	function tbwResultados_currentChanged(tab:String) {
		return this.ctx.oficial_tbwResultados_currentChanged(tab);
	}
	function cargarFormatoGrafico() {
		return this.ctx.oficial_cargarFormatoGrafico();
	}
// 	function cargarFormatoGraficoTabla() {
// 		return this.ctx.oficial_cargarFormatoGraficoTabla();
// 	}
	function cargarFormatoInforme() {
		return this.ctx.oficial_cargarFormatoInforme();
	}
	function construir2dTartaDefecto() {
		return this.ctx.oficial_construir2dTartaDefecto();
	}
	function construir1dAgujaDefecto() {
		return this.ctx.oficial_construir1dAgujaDefecto();
	}
	function construir2dMapaProvDefecto(contenedor:Object, marco:Rect) {
		return this.ctx.oficial_construir2dMapaProvDefecto(contenedor, marco);
	}
	function construir2dMapaPaisesDefecto(contenedor:Object, marco:Rect) {
		return this.ctx.oficial_construir2dMapaPaisesDefecto(contenedor, marco);
	}
// 	function mostrar2dBarras() {
// 		return this.ctx.oficial_mostrar2dBarras();
// 	}
	function mostrarGrafico() {
		return this.ctx.oficial_mostrarGrafico();
	}
	function mostrarInforme() {
		return this.ctx.oficial_mostrarInforme();
	}
	function dameIndiceTipoGrafico(idTipoG:String):Number {
		return this.ctx.oficial_dameIndiceTipoGrafico(idTipoG);
	}
	function borraGraficoCache(idTipoG:String):Boolean {
		return this.ctx.oficial_borraGraficoCache(idTipoG);
	}
	function dibujarGrafico(marco:Rect):Picture {
		return this.ctx.oficial_dibujarGrafico(marco);
	}
	function mostrar2dTarta() {
		return this.ctx.oficial_mostrar2dTarta();
	}
	function mostrar1dAguja() {
		return this.ctx.oficial_mostrar1dAguja();
	}
	function dameElementosX(idNivel:String):Array {
		return this.ctx.oficial_dameElementosX(idNivel);
	}
	function redondearEjeY2dBarras(valor:Number):Number {
		return this.ctx.oficial_redondearEjeY2dBarras(valor);
	}
	function tbnTipoGrafico_clicked() {
		return this.ctx.oficial_tbnTipoGrafico_clicked();
	}
	function incluirOpcionesTG(aOpciones:Array, aDesOpciones:Array):Boolean {
		return this.ctx.oficial_incluirOpcionesTG(aOpciones, aDesOpciones);
	}
	function mostrarErrorGrafico2(mensaje:String, contenedor:Object) {
		return this.ctx.oficial_mostrarErrorGrafico2(mensaje, contenedor);
	}
	function mostrarErrorGrafico(mensaje:String, marco:Rect):Boolean {
		return this.ctx.oficial_mostrarErrorGrafico(mensaje, marco);
	}
	function tbn2dBarras_clicked() {
		return this.ctx.oficial_tbn2dBarras_clicked();
	}
	function tbn2dTabla_clicked() {
		return this.ctx.oficial_tbn2dTabla_clicked();
	}
	function tbn2dLineas_clicked() {
		return this.ctx.oficial_tbn2dLineas_clicked();
	}
	function tbn2dTarta_clicked() {
		return this.ctx.oficial_tbn2dTarta_clicked();
	}
	function tbn1dAguja_clicked() {
		return this.ctx.oficial_tbn1dAguja_clicked();
	}
	function tbn2dMapa_clicked() {
		return this.ctx.oficial_tbn2dMapa_clicked()
	}
// 	function tbn2dMapaPaises_clicked() {
// 		return this.ctx.oficial_tbn2dMapaPaises_clicked()
// 	}
	function tbnObjetivos_clicked() {
		return this.ctx.oficial_tbnObjetivos_clicked();
	}
	function colorValorObjetivo(medida:String, valor:String):Color {
		return this.ctx.oficial_colorValorObjetivo(medida, valor);
	}
	function borrarCabecerasTabla(tblTabla:FLTable, borrarFilas:Boolean, borrarColumnas:Boolean):Boolean {
		return this.ctx.oficial_borrarCabecerasTabla(tblTabla, borrarFilas, borrarColumnas);
	}
	function formatearValorMedida(valor:Number, idMedida:String):String {
		return this.ctx.oficial_formatearValorMedida(valor, idMedida);
	}
	function crearFilaDatos(iFila:Number) {
		return this.ctx.oficial_crearFilaDatos(iFila);
	}
	function crearFilaDatos3(iFila:Number, estilo:String):FLDomElement {
		return this.ctx.oficial_crearFilaDatos3(iFila, estilo);
	}
	function crearColDatos(iCol:Number, estilo:String):FLDomElement {
		return this.ctx.oficial_crearColDatos(iCol, estilo);
	}
	function dameAliasMedida(idMedida:String):String {
		return this.ctx.oficial_dameAliasMedida(idMedida);
	}
	function dameElementoArrayFilas():Array {
		return this.ctx.oficial_dameElementoArrayFilas();
	}
	function dameElementoArrayColumnas():Array {
		return this.ctx.oficial_dameElementoArrayColumnas();
	}
	function cargarCuboVentas():Boolean {
		return this.ctx.oficial_cargarCuboVentas();
	}
	function cuboActual():String {
		return this.ctx.oficial_cuboActual();
	}
	function cambiarCubo(cubo:String):Boolean {
		return this.ctx.oficial_cambiarCubo(cubo);
	}
	function nivelesCubo():Array {
		return this.ctx.oficial_nivelesCubo();
	}
	function iniciarPosicion():Boolean {
		return this.ctx.oficial_iniciarPosicion();
	}
	function ponerFiltro(campo:String, lista:String):Boolean {
		return this.ctx.oficial_ponerFiltro(campo, lista);
	}
	function ponerMedida(idMedida:String):Boolean {
		return this.ctx.oficial_ponerMedida(idMedida);
	}
	function ponerNivel(coord:String, idNivel:String, orden:String):Boolean {
		return this.ctx.oficial_ponerNivel(coord, idNivel, orden);
	}
	function quitarFiltro(campo:String):Boolean {
		return this.ctx.oficial_quitarFiltro(campo);
	}
	function quitarMedida(idMedida:String):Boolean {
		return this.ctx.oficial_quitarMedida(idMedida);
	}
	function quitarNivel(coord:String, idNivel:String) {
		return this.ctx.oficial_quitarNivel(coord, idNivel);
	}
	function cargarMetadatosCubo():Boolean {
		return this.ctx.oficial_cargarMetadatosCubo();
	}
	function chkOrdenarMedida_clicked() {
		return this.ctx.oficial_chkOrdenarMedida_clicked();
	}
	function bgrOrdenMed_clicked(iBoton:Number) {
		return this.ctx.oficial_bgrOrdenMed_clicked(iBoton);
	}
	function habilitarPorLimiteMedida() {
		return this.ctx.oficial_habilitarPorLimiteMedida();
	}
	function habilitarPorOrdenMedida() {
		return this.ctx.oficial_habilitarPorOrdenMedida();
	}
	function ocultarBotones() {
		return this.ctx.oficial_ocultarBotones();
	}
	function tbnExportarCRM_clicked() {
		return this.ctx.oficial_tbnExportarCRM_clicked();
	}
	function crearListaMarketing(codLista:String, codConsulta:String, idNivel:String):Boolean {
		return this.ctx.oficial_crearListaMarketing(codLista, codConsulta, idNivel);
	}
	function seleccionarPosicion(filtro:String):String {
		return this.ctx.oficial_seleccionarPosicion(filtro);
	}
	function datosPosicion(idPos:String):Array {
		return this.ctx.oficial_datosPosicion(idPos);
	}
	function obtenerNivelCRM():String {
		return this.ctx.oficial_obtenerNivelCRM();
	}
	function renovarElementosListaMarketing(codLista:String, idNivel:String):Boolean {
		return this.ctx.oficial_renovarElementosListaMarketing(codLista, idNivel);
	}
	function calcularDiasMesAno(mes:Number,ano:Number):Number {
		return this.ctx.oficial_calcularDiasMesAno(mes,ano);
	}
	function editarGrafico() {
		return this.ctx.oficial_editarGrafico();
	}
	function guardarGraficoPos(xmlPosicion:FLDomDocument):Boolean {
		return this.ctx.oficial_guardarGraficoPos(xmlPosicion);
	}
	function guardarInformePos():Boolean {
		return this.ctx.oficial_guardarInformePos();
	}
	function borrarInformePos():Boolean {
		return this.ctx.oficial_borrarInformePos();
	}
	function generarInforme():Boolean {
		return this.ctx.oficial_generarInforme();
	}
	function cargarEstiloReport() {
		return this.ctx.oficial_cargarEstiloReport();
	}
	function cargarReportData():Boolean {
		return this.ctx.oficial_cargarReportData();
	}
	function cargarReportTemplate(forzarRecalculo:Boolean):Boolean {
		return this.ctx.oficial_cargarReportTemplate(forzarRecalculo);
	}
	function formatoCampoKut(eField:FLDomElement) {
		return this.ctx.oficial_formatoCampoKut(eField);
	}
	function tbnEditarFormato_clicked() {
		return this.ctx.oficial_tbnEditarFormato_clicked();
	}
	function editarInforme() {
		return this.ctx.oficial_editarInforme();
	}
	function ejecutarComando(comando:Array, workdir:String):Array {
		return this.ctx.oficial_ejecutarComando(comando, workdir);
	}
	function precisionMedida(medida:String):Number {
		return this.ctx.oficial_precisionMedida(medida);
	}
	function tbnImprimirGrafico_clicked() {
		return this.ctx.oficial_tbnImprimirGrafico_clicked();
	}
	function bgMes_clicked(iMes:Number) {
		return this.ctx.oficial_bgMes_clicked(iMes);
	}
	function bgTrim_clicked(iTrim:Number) {
		return this.ctx.oficial_bgTrim_clicked(iTrim);
	}
	function bgAnno_clicked(iAnno:Number) {
		return this.ctx.oficial_bgAnno_clicked(iAnno);
	}
	function ordenaArrayNumerico(n1:Number, n2:Number):Number {
		return this.ctx.oficial_ordenaArrayNumerico(n1, n2);
	}
	function dameAnnoBoton(iAnno:Number):Number {
		return this.ctx.oficial_dameAnnoBoton(iAnno);
	}
	function iniciaBGTiempo() {
		return this.ctx.oficial_iniciaBGTiempo();
	}
	function colorearBotonDim(nombreBoton:String) {
		return this.ctx.oficial_colorearBotonDim(nombreBoton);
	}
	function establecerPosicion(idPos:String):Boolean {
		return this.ctx.oficial_establecerPosicion(idPos);
	}
	function establecerPosicionArray(aPos:Array):Boolean {
		return this.ctx.oficial_establecerPosicionArray(aPos);
	}
	function establecerTipoGrafico(tipoGrafico:String):Boolean {
		return this.ctx.oficial_establecerTipoGrafico(tipoGrafico);
	}
	function ponColorFondoFilaDatos(iFila:Number, colorFondo:Color) {
		return this.ctx.oficial_ponColorFondoFilaDatos(iFila, colorFondo);
	}
	function ponColorFondoColumnaDatos(iCol:Number, colorFondo:Color) {
		return this.ctx.oficial_ponColorFondoColumnaDatos(iCol, colorFondo);
	}
	function ajustarColumnaDatos(iCol:Number, ajustar:Boolean) {
		return this.ctx.oficial_ajustarColumnaDatos(iCol, ajustar);
	}
	function ponColorFondoCeldaDatos(iFila:Number, iCol:Number, colorFondo:Color) {
		return this.ctx.oficial_ponColorFondoCeldaDatos(iFila, iCol, colorFondo);
	}
	function ocultarColDatos(iCol:Number, ocultar:Boolean):Boolean {
		return this.ctx.oficial_ocultarColDatos(iCol, ocultar);
	}
	function ocultarFilaDatos(iFila:Number, ocultar):Boolean {
		return this.ctx.oficial_ocultarFilaDatos(iFila, ocultar);
	}
	function dameFilaDatosGraf(iFila:Number):FLDomElement {
		return this.ctx.oficial_dameFilaDatosGraf(iFila);
	}
	function dameColDatosGraf(iCol:Number):FLDomElement {
		return this.ctx.oficial_dameColDatosGraf(iCol);
	}
	function dameEstiloDatosGraf(idEstilo:String, nombre:String):FLDomElement {
		return this.ctx.oficial_dameEstiloDatosGraf(idEstilo, nombre);
	}
	function dameCeldaDatosGraf(iFila:Number, iCol:Number):FLDomElement {
		return this.ctx.oficial_dameCeldaDatosGraf(iFila, iCol);
	}
	function creaCeldaDatosGraf(iFila:Number, iCol:Number, texto:String):FLDomElement {
		return this.ctx.oficial_creaCeldaDatosGraf(iFila, iCol, texto);
	}	
	function ponTextoCelda(iFila:Number, iCol:Number, texto:String):Boolean {
		return this.ctx.oficial_ponTextoCelda(iFila, iCol, texto);
	}
	function ponAlineacionHCelda(iFila:Number, iCol:Number, alineacion:String):Boolean {
		return this.ctx.oficial_ponAlineacionHCelda(iFila, iCol, alineacion);
	}
	function alinearFilaDatos(tblDatos:FLTable, iFila:Number, alineacion:String) {
		return this.ctx.oficial_alinearFilaDatos(tblDatos, iFila, alineacion);
	}
	function alinearColumnaDatos(tblDatos:FLTable, iCol:Number, alineacion:String) {
		return this.ctx.oficial_alinearColumnaDatos(tblDatos, iCol, alineacion);
	}
	function alinearCeldaDatos(tblDatos:FLTable, iFila:Number, iCol:Number, alineacion:String) {
		return this.ctx.oficial_alinearCeldaDatos(tblDatos, iFila, iCol, alineacion);
	}
	function nivelEnCuboActual(nombreNivel:String):Boolean {
		return this.ctx.oficial_nivelEnCuboActual(nombreNivel);
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
	function pub_dameSeleccionValores() {
		return this.dameSeleccionValores();
	}
	function pub_ponSeleccionValores(s:String) {
		return this.ponSeleccionValores(s);
	}
	function pub_dibujar2dMapaProv(marco:Rect):Boolean {
		return this.dibujar2dMapaProv(marco);
	}
	function pub_dibujar2dMapaPaises(contenedor:Object, marco:Rect):Boolean {
		return this.dibujar2dMapaPaises(contenedor, marco);
	}
	function pub_dibujarGrafico(marco:Rect):Picture {
		return this.dibujarGrafico(marco);
	}
	function pub_cargarDatos():Boolean {
		return this.cargarDatos();
	}
	function pub_cuboActual():String {
		return this.cuboActual();
	}
	function pub_cambiarCubo(cubo:String):Boolean {
		return this.cambiarCubo(cubo);
	}
	function pub_nivelesCubo():Array {
		return this.nivelesCubo();
	}
	function pub_conectar():Boolean {
		return this.conectar();
	}
	function pub_iniciarPosicion():Boolean {
		return this.iniciarPosicion();
	}
	function pub_ponerFiltro(campo:String, lista:String):Boolean {
		return this.ponerFiltro(campo, lista);
	}
	function pub_ponerMedida(idMedida:String):Boolean {
		return this.ponerMedida(idMedida);
	}
	function pub_ponerNivel(coord:String, idNivel:String, orden:String):Boolean {
		return this.ponerNivel(coord, idNivel, orden);
	}
	function pub_quitarFiltro(campo:String):Boolean {
		return this.quitarFiltro(campo);
	}
	function pub_quitarMedida(idMedida:String):Boolean {
		return this.quitarMedida(idMedida);
	}
	function pub_quitarNivel(coord:String, idNivel:String) {
		return this.quitarNivel(coord, idNivel);
	}
	function pub_seleccionarPosicion(filtro:String):String {
		return this.seleccionarPosicion(filtro);
	}
	function pub_datosPosicion(idPos:String):Array {
		return this.datosPosicion(idPos);
	}
	function pub_obtenerNivelCRM():String {
		return this.obtenerNivelCRM();
	}
	function pub_renovarElementosListaMarketing(codLista:String, idNivel:String):Boolean {
		return this.renovarElementosListaMarketing(codLista, idNivel);
	}
	function pub_borrarCabecerasTabla(tblTabla:FLTable, borrarFilas:Boolean, borrarColumnas:Boolean):Boolean {
		return this.borrarCabecerasTabla(tblTabla, borrarFilas, borrarColumnas);
	}
	function pub_seleccionarValoresNivel(nombreNivel:String, listaSel:String):String {
		return this.seleccionarValoresNivel(nombreNivel, listaSel);
	}
	function pub_establecerPosicion(idPos:String):Boolean {
		return this.establecerPosicion(idPos);
	}
	function pub_establecerPosicionArray(aPos:Array):Boolean {
		return this.establecerPosicionArray(aPos);
	}
	function pub_establecerTipoGrafico(tipoGrafico:String):Boolean {
		return this.establecerTipoGrafico(tipoGrafico);
	}
	function pub_listarClaves(campo:String, lista:String):String {
		return this.listarClaves(campo, lista);
	}
	function pub_colores() {
		return this.colores();
	}
	function pub_cambiarColorFilaTabla(tabla:Object, iFila:Number, colorFila:Color) {
		return this.cambiarColorFilaTabla(tabla, iFila, colorFila);
	}
	function pub_editarGrafico():Boolean {
		return this.editarGrafico();
	}
	function pub_guardarGraficoPos(xmlPosicion:FLDomDocument):Boolean {
		return this.guardarGraficoPos(xmlPosicion);
	}
	function pub_guardarPosicionActual() {
		return this.guardarPosicionActual();
	}
	function pub_guardarGraficoPosicionActual():Boolean {
		return this.guardarGraficoPosicionActual();
	}
	function pub_nivelEnCuboActual(nombreNivel:String):Boolean {
		return this.nivelEnCuboActual(nombreNivel);
	}
	function pub_establecerAnos() {
		return this.establecerAnos();
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
/** \C Cuando cambia el ejercicio actual se establece el título de las ventanas principales con
el nombre del ejercicio seleccionado
\end */
function interna_init()
{
	var baseDatosLocal:String = fldireinne.iface.pub_valorConfiguracion("basedatoslocal");
	if (baseDatosLocal != "Destino") {
		if (!this.iface.conectar()) {
			this.close();
		}
	}

	var cursor:FLSqlCursor = this.cursor();
	if (!this.iface.dim_) {
		this.iface.dim_ = [];
		this.iface.listaDim_ = [];
	}
	this.iface.cachePicGraficos_ = false;
// 	this.iface.bloqueoFiltros_ = false;
	this.iface.bloqueoMedidas_ = false;
	this.iface.totalPosicionesMemo_ = 10;
	this.iface.establecerCubo();
	this.iface.interfazDatos_ = "TABLA";

	connect (this.child("tbnTipoGrafico"), "clicked()", this, "iface.tbnTipoGrafico_clicked");
	connect (this.child("tbn2dBarras"), "clicked()", this, "iface.tbn2dBarras_clicked");
	connect (this.child("tbn2dLineas"), "clicked()", this, "iface.tbn2dLineas_clicked");
	connect (this.child("tbn2dTabla"), "clicked()", this, "iface.tbn2dTabla_clicked");
	connect (this.child("tbn2dTarta"), "clicked()", this, "iface.tbn2dTarta_clicked");
	connect (this.child("tbn1dAguja"), "clicked()", this, "iface.tbn1dAguja_clicked");
	connect (this.child("tbn2dMapa"), "clicked()", this, "iface.tbn2dMapa_clicked");
// 	connect (this.child("tbn2dMapaPaises"), "clicked()", this, "iface.tbn2dMapaPaises_clicked");
// 	connect (this.child("tbnEditarGrafico"), "clicked()", this, "iface.tbnEditarGrafico_clicked");
	connect (this.child("tbnImprimirGrafico"), "clicked()", this, "iface.tbnImprimirGrafico_clicked");

	connect (this.child("tbnCargarCubo"), "clicked()", this, "iface.cargarCubo_clicked");
	connect (this.child("tbnDimY"), "clicked()", this, "iface.tbnDimY_clicked");
	connect (this.child("tbnDimX"), "clicked()", this, "iface.tbnDimX_clicked");

	connect (this.child("tbnPrevio"), "clicked()", this, "iface.tbnPrevio_clicked()");
	connect (this.child("tbnSiguiente"), "clicked()", this, "iface.tbnSiguiente_clicked()");
	connect (this.child("tbnGuardar"), "clicked()", this, "iface.tbnGuardar_clicked()");
	connect (this.child("tbnGuardarComo"), "clicked()", this, "iface.tbnGuardarComo_clicked()");
	connect (this.child("tbnAbrir"), "clicked()", this, "iface.tbnAbrir_clicked()");

	connect (this.child("sbxLimite"), "valueChanged(int)", this, "iface.sbxLimite_valueChanged");
	connect (this.child("chkLimitar"), "toggled(bool)", this, "iface.chkLimitar_toggled");

	connect (this.child("tblDimensiones"), "clicked(int, int)", this, "iface.tblDimensiones_doubleClicked");
	connect (this.child("tblDatos"), "clicked(int, int)", this, "iface.tblDatos_doubleClicked");

// 	connect (this.child("tbnFiltrarFilas"), "clicked()", this, "iface.tbnFiltrarFilas_clicked");
// 	connect (this.child("tbnFiltrarColumnas"), "clicked()", this, "iface.tbnFiltrarColumnas_clicked");

	connect (this.child("bgrMedidas"), "clicked(int)", this, "iface.bgrMedidas_clicked");
	connect (this.child("bgrOrdenMed"), "clicked(int)", this, "iface.bgrOrdenMed_clicked");
	connect (this.child("tblMedidas"), "clicked(int, int)", this, "iface.tblMedidas_doubleClicked");
// 	connect (this.child("tblMedidas"), "selectionChanged()", this, "iface.tblMedidas_doubleclicked");
	connect (this.child("tbnCubo"), "clicked()", this, "iface.tbnCubo_clicked()");
	connect (this.child("tbwResultados"), "currentChanged(QString)", this, "iface.tbwResultados_currentChanged()");

	connect (this.child("tbnObjetivos"), "clicked()", this, "iface.tbnObjetivos_clicked");
	connect (this.child("chkOrdenarMedida"), "clicked()", this, "iface.chkOrdenarMedida_clicked");

	connect (this.child("tbnExportarCRM"), "clicked()", this, "iface.tbnExportarCRM_clicked");
// 	connect (this.child("tbnInforme"), "clicked()", this, "iface.generarInforme()");
	connect (this.child("tbnEditarFormato"), "clicked()", this, "iface.tbnEditarFormato_clicked()");
	connect (this.child("bgMes"), "clicked(int)", this, "iface.bgMes_clicked()");
	connect (this.child("bgTrim"), "clicked(int)", this, "iface.bgTrim_clicked()");
	connect (this.child("bgAnos"), "clicked(int)", this, "iface.bgAnno_clicked()");
	
	
	this.iface.colores();
	this.iface.establecerAnos();
	this.iface.iniciaBGTiempo();
	this.iface.iniciarTablaDimensiones();

	this.iface.cargarHome();
	this.iface.cargarPosicion(true);
	this.iface.ocultarBotones();

	if (!sys.isLoadedModule("flgraficos")) {
		this.child("tbwResultados").setTabEnabled("grafico", false);
	}
	
	if (!this.child("pbnMedidas").on) {
		this.child("gbxMedidas").close();
	}

// 	this.child("fdbImagen").setValue("<img src=\"http://chart.apis.google.com/chart?cht=p3&chd=t:60,40&chs=250x100&chl=Hello|World\"/>");
// 	this.child("fdbImagen").setValue("<img src='file:////home/arodriguez/chart.png'/>");
// 	this.child("fdbImagen").setValue("<table><tr><td>Hola <i>pepe</i></td></tr></table>");
// 	connect(this.child("tbnCubo_2"), "clicked()", this, "iface.tbnCubo_clicked()");

// 	this.child("textLabel1").text = "<img src=\"http://chart.apis.google.com/chart?cht=p3&chd=t:60,40&chs=250x100&chl=Hello|World\"/>";
}

/**
\end */
function interna_main()
{

	var f:Object = new FLFormSearchDB("in_h_ventas");
	var cursor:FLSqlCursor = f.cursor();

	cursor.select();
	if (!cursor.first()) {
		cursor.setModeAccess(cursor.Insert);
	} else {
		cursor.setModeAccess(cursor.Edit);
	}
	f.setMainWidget();
	
	cursor.refreshBuffer();
	cursor.setValueBuffer("hipercubo", "in_h_ventas");
	var commitOk:Boolean = false;
	var acpt:Boolean;
	f.exec("id");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_ocultarBotones()
{
	this.child("tbnTipoGrafico").close();
// 	this.child("tbn2dTarta").close();
// 	this.child("tbn1dAguja").close();
// 	this.child("tbn2dMapaProv").close();
	this.child("tbn2dMapaPaises").close();
// 	this.child("tbn2dLineas").close();
}

/** Lanza la función de carga del cubo de ventas
\end */
function oficial_cargarCubo_clicked()
{
	var util:FLUtil = new FLUtil;
	
	var cubo:String = this.iface.nombreCubo(this.iface.cubo_);

	var res:Number = MessageBox.warning(util.translate("scripts", "Va a recargar el cubo %1 \n¿Está seguro?").arg(cubo), MessageBox.Yes, MessageBox.No);
	if (res != MessageBox.Yes) {
		return false;
	}
	
	var baseDatosLocal:String = fldireinne.iface.pub_valorConfiguracion("basedatoslocal");
	if (baseDatosLocal == "Destino" && !this.iface.conexion_) {
		if (!this.iface.conectar()) {
			this.close();
		}
	}

	var curTransaccion:FLSqlCursor = new FLSqlCursor("in_navegador");
	curTransaccion.transaction(false);
	try {
		if (this.iface.cargarCubo()) {
			curTransaccion.commit();
		} else {
			curTransaccion.rollback();
			util.destroyProgressDialog();
			return;
		}
	}
	catch (e) {
		curTransaccion.rollback();
		util.destroyProgressDialog();
		MessageBox.warning(util.translate("scripts", "Hubo un error en la carga del cubo de ventas:") + e, MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	MessageBox.information(util.translate("scripts", "El cubo ha sido cargado correctamente"), MessageBox.Ok, MessageBox.NoButton);
	this.iface.cargarHome();
	this.iface.cargarPosicion(true);
}

/** Carga el cubo de ventas
\end */
function oficial_cargarCubo():Boolean
{
	switch (this.iface.cubo_) {
		case "in_h_ventas": {
			if (!this.iface.cargarCuboVentas()) {
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

function oficial_cargarCuboVentas():Boolean
{
	var util:FLUtil = new FLUtil;
	var curVentas:FLSqlCursor;
	if (this.iface.conexionBI_) {
		curVentas = new FLSqlCursor("in_h_ventas", this.iface.conexionBI_);
	} else {
		curVentas = new FLSqlCursor("in_h_ventas");
	}
	curVentas.setActivatedCheckIntegrity(false);
	curVentas.setActivatedCommitActions(false);

	var qryEjercicios:FLSqlQuery = (this.iface.conexion_ ? new FLSqlQuery("", this.iface.conexion_) : new FLSqlQuery());
	qryEjercicios.setTablesList("ejercicios");
	qryEjercicios.setSelect("codejercicio, nombre");
	qryEjercicios.setFrom("ejercicios");
	qryEjercicios.setWhere("1 = 1 ORDER BY codejercicio");

	var util:FLUtil = new FLUtil;
	var opciones:Array = [];
	var indice:Number = 0;

	if (!qryEjercicios.exec()) {
		return false;
	}
	while(qryEjercicios.next()) {
		opciones[indice]= [];
		opciones[indice][0]= qryEjercicios.value("codejercicio");
		opciones[indice][1]= qryEjercicios.value("nombre");
		indice++;
	}

	var ejercicios:String = this.iface.obtenerOpcionEF(opciones);
	if (ejercicios == "") {
		return false;
	}
	if (!this.iface.cargarDimensiones(ejercicios)) {
		return false;
	}
	curVentas.setForwardOnly(true);
	curVentas.select("d_codejercicio IN (" + ejercicios + ")");
	util.createProgressDialog(util.translate("scripts", "Borrando cubo"), curVentas.size());
	var paso:Number = 0;
	while (curVentas.next()) {
		curVentas.setModeAccess(curVentas.Del);
		curVentas.refreshBuffer();
		if (!curVentas.commitBuffer()) {
			return false;
		}
		util.setProgress(paso++);
	}
	util.destroyProgressDialog();
	
	var qryVentas:FLSqlQuery;
	if (this.iface.conexion_) {
debug("SI conexion");
		qryVentas = new FLSqlQuery("", this.iface.conexion_);
	} else {
debug("!conexion");
		qryVentas = new FLSqlQuery();
	}
	qryVentas.setTablesList("lineasfacturascli,facturascli");
	qryVentas.setSelect("SUM(lf.pvptotal), SUM(lf.cantidad), lf.referencia, f.codcliente, f.codagente, EXTRACT(YEAR FROM f.fecha), EXTRACT(MONTH FROM f.fecha), f.codejercicio, f.idprovincia, f.codpais");
	qryVentas.setFrom("lineasfacturascli lf INNER JOIN facturascli f ON lf.idfactura = f.idfactura");
	qryVentas.setWhere("f.codejercicio IN (" + ejercicios + ") GROUP BY lf.referencia, f.codcliente, f.codagente, EXTRACT(YEAR FROM f.fecha), EXTRACT(MONTH FROM f.fecha), f.codejercicio, f.idprovincia, f.codpais");
	qryVentas.setForwardOnly(true);
debug(qryVentas.sql());
	if (!qryVentas.exec()) {
debug("error");
		return false;
	}

	util.createProgressDialog(util.translate("scripts", "Creando cubo"), qryVentas.size());
	paso = 0;
	var fecha:Date;
	var i:Number = 0;
	var mesAno:String;
	while (qryVentas.next()) {
		curVentas.setModeAccess(curVentas.Insert);
		curVentas.refreshBuffer();
		curVentas.setValueBuffer("m_venta", qryVentas.value("SUM(lf.pvptotal)"));
		curVentas.setValueBuffer("m_cantidad", qryVentas.value("SUM(lf.cantidad)"));
		curVentas.setValueBuffer("d_referencia", qryVentas.value("lf.referencia"));
		curVentas.setValueBuffer("d_codcliente", qryVentas.value("f.codcliente"));
		curVentas.setValueBuffer("d_codagente", qryVentas.value("f.codagente"));
		curVentas.setValueBuffer("d_codejercicio", qryVentas.value("f.codejercicio"));
		curVentas.setValueBuffer("d_idprovincia", qryVentas.value("f.idprovincia"));
		curVentas.setValueBuffer("d_codpais", qryVentas.value("f.codpais"));
		mesAno = qryVentas.value("EXTRACT(YEAR FROM f.fecha)") + this.iface.cerosIzquierda(qryVentas.value("EXTRACT(MONTH FROM f.fecha)"), 2);
		curVentas.setValueBuffer("d_mes", mesAno);
		if (!curVentas.commitBuffer()) {
			return false;
		}
		util.setProgress(paso++);
	}
	util.destroyProgressDialog();
// 	if (!this.iface.cargarDatossAgregadas("d_codejercicio IN (" + ejercicios + ")")) {
// 		return false;
// 	}
	return true;
}

/** \D Carga las tablas agregadas asociadas al cubo actual para los registros que cumplen la cláusula where
@param	where: Cláusula where de los registros a cargar
\end */
function oficial_cargarDatossAgregadas(where:String):Boolean
{
	var util:FLUtil = new FLUtil;

	var xmlMetadatos:FLDomDocument = fldireinne.iface.pub_metadatosTabla(this.iface.cubo_);
	if (!xmlMetadatos) {
		return false;
	}

	var numRegistros:Number;
	var curAgregadas:FLSqlCursor = new FLSqlCursor("in_agregadas");
	curAgregadas.select("cubo = '" + this.iface.cubo_ + "'");
	while (curAgregadas.next()) {
		curAgregadas.setModeAccess(curAgregadas.Edit);
		curAgregadas.refreshBuffer();
		tabla = curAgregadas.valueBuffer("fichero");
		numRegistros = fldireinne.iface.pub_cargarDatosAgregada(curAgregadas, xmlMetadatos);
		if (numRegistros < 0) {
			return false;
		}
		curAgregadas.setValueBuffer("registros", numRegistros);
		if (!curAgregadas.commitBuffer()) {
			return false;
		}
	}
	return true;
}

/** Construye un nodo XML que indica la posición inicial en el cubo actual
<Posicion>
<Medidas>
<Medida Nombre='Medida1' />
...
</Medidas>
<Dimensiones X='' Y='' />
<Agrupacion Lista='Dimension1,...' >
<Dimension Nombre='Dimension1' />
...
</Agrupacion>
</Posicion>
\end */
function oficial_cargarHome():Boolean
{
	if (this.iface.posicionesMemo_) {
		delete this.iface.posicionesMemo_;
	}
	this.iface.posicionesMemo_ = new Array(this.iface.totalPosicionesMemo_);
	for (var i:Number = 0; i < this.iface.totalPosicionesMemo_; i++) {
		this.iface.posicionesMemo_[i] = 0;
	}
	this.iface.iPosActual_ = -1;
	this.iface.habilitarNavegacion();
	
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	var hipercubo:String = this.iface.cubo_;
debug("hipercubo = " + hipercubo);
	var campos:Array = util.nombreCampos(hipercubo);
debug("campos = " + campos + "'");
	if (!campos || campos.length == 0) {
		this.iface.cubo_ = false;
		return false;
	}
	var cuenta:Number = parseFloat(campos[0]);

	var medidas:Array = [];
	var dimensiones:Array = [];
	var iMedidas:Number = 0;
	var iDimensiones:Number = 0;
	for (var i:Number = 1; i < campos.length; i++) {
		if (campos[i].startsWith("m_")) {
			medidas[iMedidas++] = campos[i];
		} else if (campos[i].startsWith("d_")) {
			dimensiones[iDimensiones++] = campos[i];
		}
	}
	this.iface.xmlPosActual_ = new FLDomDocument();
	this.iface.xmlPosActual_.setContent("<Posicion/>");
	var eFiltros:FLDomElement = this.iface.xmlPosActual_.createElement("Filtros");
	this.iface.xmlPosActual_.firstChild().appendChild(eFiltros);
	var eMedidas:FLDomElement = this.iface.xmlPosActual_.createElement("Medidas");
	eMedidas.setAttribute("Eje", "Y");
	this.iface.xmlPosActual_.firstChild().appendChild(eMedidas);
	var eMedida:FLDomElement;

// 	var dimX:String = "";
// 	var dimY:String = "";
	var eDimensiones:FLDomElement = this.iface.xmlPosActual_.createElement("Dimensiones");
	this.iface.xmlPosActual_.firstChild().appendChild(eDimensiones);
	var eY:FLDomElement = this.iface.xmlPosActual_.createElement("Y");
	eDimensiones.appendChild(eY);
	var eX:FLDomElement = this.iface.xmlPosActual_.createElement("X");
	eDimensiones.appendChild(eX);

// 	var eAgrupacion:FLDomElement = this.iface.xmlPosActual_.createElement("Agrupacion");
// 	this.iface.xmlPosActual_.firstChild().appendChild(eAgrupacion);
// 	var eDimension:FLDomElement;
// 	var listaAgrupacion:String = "";
// 	for (var i:Number = 0; i < dimensiones.length; i++) {
// 		if (dimensiones[i] != dimX && dimensiones[i] != dimY) {
// 			if (listaAgrupacion != "") {
// 				listaAgrupacion += ",";
// 			}
// 			listaAgrupacion += dimensiones[i];
// 		}
// 	}
// 	eAgrupacion.setAttribute("Lista", listaAgrupacion);

	var eLimite:FLDomElement = this.iface.xmlPosActual_.createElement("Limite");
	this.iface.xmlPosActual_.firstChild().appendChild(eLimite);
	eLimite.setAttribute("Valor", "0");
	eLimite.setAttribute("Activo", "false");
	
	this.iface.cargarHomeDefectoCubo();
	debug(this.iface.xmlPosActual_.toString());

	return true;
}

function oficial_cargarHomeDefectoCubo()
{
	var xmlPos:FLDomNode = this.iface.xmlPosActual_.firstChild();
	var nodoMedidas:FLDomNode = xmlPos.namedItem("Medidas");
	switch (this.iface.cubo_) {
		case "in_h_ventas": {
			var eMedida:FLDomElement = this.iface.xmlPosActual_.createElement("Medida");
			eMedida.setAttribute("Id", "ventas");
			nodoMedidas.appendChild(eMedida);
			break;
		}
	}
}

function oficial_memorizarPosicion()
{
	var xmlPos:FLDomNode = this.iface.xmlPosActual_.firstChild();

	var xmlNodoAux:FLDomNode = xmlPos.cloneNode(true);
	if (this.iface.iPosActual_ < (this.iface.totalPosicionesMemo_ - 1)) {
		this.iface.iPosActual_++;
debug("Guardando en posición " + this.iface.iPosActual_);
		this.iface.posicionesMemo_[this.iface.iPosActual_] = xmlNodoAux;

		for (var i:Number = (this.iface.iPosActual_ + 1); i < this.iface.totalPosicionesMemo_; i++) {
			this.iface.posicionesMemo_[i] = 0;
		}
	} else {
		this.iface.posicionesMemo_.shift();
debug("Guardando en posición " + this.iface.iPosActual_);
		this.iface.posicionesMemo_[this.iface.iPosActual_] = xmlNodoAux;
	}
}

/** \Obtiene el alias de un nivel
@param	nombreNivel: del nivel
@return	Alias
\end */
function oficial_obtenerAlias(nombreNivel):String
{
// 	return this.iface.dimensiones_[nombreNivel]["alias"];

	return this.iface.niveles_[nombreNivel]["element"].attribute("name");
}

/** \C Carga los datos de posición guardados en un nodo XML y recarga la tabla
\end */
function oficial_cargarPosicion(memorizar:Boolean):Boolean
{
debug("oficial_cargarPosicion");
	if (!this.iface.xmlPosActual_) {
		return false;
	}
debug("Cargando " + this.iface.xmlPosActual_.toString(4));
	var xmlPos:FLDomNode = this.iface.xmlPosActual_.firstChild();

	this.iface.tablaMostrada_ = false;
	this.iface.tablaCargada_ = false;
	this.iface.graficoMostrado_ = false;
	if (!this.iface.borraGraficoCache()) {
		return false;
	}
	this.iface.informeMostrado_ = false;
	
	this.iface.cargarDatos();
	this.iface.mostrarDatos();
	this.iface.cargarFiltros();
	this.iface.cargarMedidas();
	if (memorizar) {
		this.iface.memorizarPosicion();
	}
debug("oficial_cargarPosicion 1");
	this.iface.habilitarNavegacion();
debug("oficial_cargarPosicion OK");
	return true;
}

function oficial_colores()
{
// 	this.iface.colorDimSel_ = new Color(255, 200, 200);
// 	this.iface.colorDimNoSel_ = new Color(255, 255, 255);
// 	this.iface.colorMedSel_ = new Color(200, 255, 200);
// 	this.iface.colorMedNoSel_ = new Color(255, 255, 255);
// 	this.iface.colorDatTotal_= new Color(200, 200, 255);
// 	this.iface.colorDatCabecera_ = new Color(200, 200, 200);
// 	this.iface.colorDatNormal_= new Color(255, 255, 255);
	this.iface.colorDimSel_ = "255,200,200";
	this.iface.colorDimNoSel_ = "255,255,255";
	this.iface.colorMedSel_ = "200,255,200";
	this.iface.colorMedNoSel_ = "255,255,255";
	this.iface.colorDatTotal_ = "200,200,255";
	this.iface.colorDatCabecera_ = "200,200,200";
	this.iface.colorDatNormal_= "255,255,255";
	
	this.iface.aColorGrafico_ = new Array(5);
	this.iface.aColorGrafico_[0] = "0,0,255";
	this.iface.aColorGrafico_[1] = "0,255,0";
	this.iface.aColorGrafico_[2] = "255,0,0";
	this.iface.aColorGrafico_[3] = "255,255,0";
	this.iface.aColorGrafico_[4] = "255,0,255";
	this.iface.aColorGrafico_[5] = "0,255,255";
	this.iface.aColorGrafico_[6] = "100,100,255";
	this.iface.aColorGrafico_[7] = "100,255,100";
	this.iface.aColorGrafico_[8] = "255,100,100";
	this.iface.aColorGrafico_[9] = "0,100,200";
	this.iface.aColorGrafico_[10] = "100,200,0";
	this.iface.aColorGrafico_[11] = "200,0,100";
}

function oficial_cargarFiltros():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	var xmlPos:FLDomNode = this.iface.xmlPosActual_.firstChild();
	var tblDimensiones:Object = this.child("tblDimensiones");
	var numFilas:Number = tblDimensiones.numRows();
// 	var dimension:String;
	var nivel:String;
	var nodoFiltro:FLDomNode;
	var lista:String;
	var listaAlias:String;
	var colorFila:Color;
	for (var i:Number = 0; i < numFilas; i++) {
		colorFila = this.iface.colorDimNoSel_;
		nivel = tblDimensiones.text(i, this.iface.CD_NOMBRE);
		nodoFiltro = fldireinne.iface.pub_dameNodoXML(this.iface.xmlPosActual_, "Posicion/Filtros/Filtro[@Campo=" + nivel + "]");
		if (!nodoFiltro) {
			listaAlias = "*";
		} else {
			lista = nodoFiltro.toElement().attribute("Lista");
			if (lista && lista != "") {
// 				listaAlias = this.iface.listarClaves(dimension, lista);
				listaAlias = this.iface.listarClaves(nivel, lista);
				colorFila = this.iface.colorDimSel_;
			} else {
				listaAlias = "*";
			}
		}
		tblDimensiones.setText(i, this.iface.CD_FILTRO, listaAlias);
		this.iface.cambiarColorFilaTabla(tblDimensiones, i, colorFila);
	}
	if (this.iface.nivelBGMes_) {
		nivel = this.iface.nivelBGMes_;
		nodoFiltro = fldireinne.iface.pub_dameNodoXML(this.iface.xmlPosActual_, "Posicion/Filtros/Filtro[@Campo=" + nivel + "]");
		lista = "";
		if (nodoFiltro) {
			lista = nodoFiltro.toElement().attribute("Lista");
		}
		this.iface.cargaBGMeses(lista);
	}
	if (this.iface.nivelBGTrim_) {
		nivel = this.iface.nivelBGTrim_;
		nodoFiltro = fldireinne.iface.pub_dameNodoXML(this.iface.xmlPosActual_, "Posicion/Filtros/Filtro[@Campo=" + nivel + "]");
		lista = "";
		if (nodoFiltro) {
			lista = nodoFiltro.toElement().attribute("Lista");
		}
		this.iface.cargaBGTrimestres(lista);
	}
	if (this.iface.nivelBGAnno_) {
		nivel = this.iface.nivelBGAnno_;
		nodoFiltro = fldireinne.iface.pub_dameNodoXML(this.iface.xmlPosActual_, "Posicion/Filtros/Filtro[@Campo=" + nivel + "]");
		lista = "";
		if (nodoFiltro) {
			lista = nodoFiltro.toElement().attribute("Lista");
		}
		this.iface.cargaBGAnnos(lista);
	}
	tblDimensiones.adjustColumn(this.iface.CD_FILTRO);
}

/** \D Marca los botones del buttonGruop de meses según los valores de la lista
@param	lista: Lista de meses (1 = enero, 2 = febrero,..)
\end */
function oficial_cargaBGMeses(lista:String):Boolean
{
	var aLista:Array;
	if (!lista || lista == "") {
		aLista = [];
	} else {
		aLista = lista.split(", ");
	}
	var iLista:Number = 0;
	var mesOn:Boolean;
	var nombreBoton:String;
	for (var iMes:Number = 0; iMes < 12; iMes++) {
		mesOn = false;
		if (iLista < aLista.length) {
			if ((iMes + 1) == parseInt(aLista[iLista])) {
				mesOn = true;
				iLista++;
			}
		}
		nombreBoton = "pbnMes" + iMes.toString();
		this.child(nombreBoton).on = mesOn;
		this.iface.colorearBotonDim(nombreBoton);
	}
}

/** \D Marca los botones del buttonGruop de trimestres según los valores de la lista
@param	lista: Lista de trimestres (T1, T2, T3, T4)
\end */
function oficial_cargaBGTrimestres(lista:String):Boolean
{
	var aLista:Array;
	if (!lista || lista == "") {
		aLista = [];
	} else {
		aLista = lista.split(", ");
	}
	var iLista:Number = 0;
	var trimOn:Boolean;
	var nombreBoton:String;
	for (var iTrim:Number = 0; iTrim < 4; iTrim++) {
		trimOn = false;
		if (iLista < aLista.length) {
			if ((iTrim + 1) == parseInt(aLista[iLista])) {
				trimOn = true;
				iLista++;
			}
		}
		nombreBoton = "pbnTrim" + iTrim.toString();
		this.child(nombreBoton).on = trimOn;
		this.iface.colorearBotonDim(nombreBoton);
	}
}

/** \D Marca los botones del buttonGruop de años según los valores de la lista
@param	lista: Lista de años
\end */
function oficial_cargaBGAnnos(lista:String):Boolean
{
	var annoHasta:Number = this.iface.anoMax_;
	annoDesde = annoHasta - this.iface.numBotonesAno_ + 1;
	
	var aLista:Array;
	if (!lista || lista == "") {
		aLista = [];
	} else {
		aLista = lista.split(", ");
	}
	var annoOn:Boolean, iAnno:Number;
	for (var anno:Number = annoDesde; anno <= annoHasta; anno++) {
		annoOn = false;
		iAnno = anno - annoDesde;
		if (aLista.length > 0) {
			if (this.iface.buscarElementoArray(anno, aLista) >= 0) {
				annoOn = true;
			}
		}
		nombreBoton = "pbnAno" + iAnno.toString();
		this.child(nombreBoton).on = annoOn;
		this.iface.colorearBotonDim(nombreBoton);
	}
}
function oficial_buscarElementoArray(elemento:String, aLista:Array):Number
{
	if (!aLista) {
		return -1;
	}
	for (var i:Number = 0; i < aLista.length; i++) {
		if (aLista[i] == elemento) {
			return i;
		}
	}
	return -1;
}

function oficial_cargarMedidas():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	var xmlPos:FLDomNode = this.iface.xmlPosActual_.firstChild();
	var tblMedidas:Object = this.child("tblMedidas");
	var numFilas:Number = tblMedidas.numRows();

	var idMedida:String;
	var nodoMedida:FLDomNode;
	var colorFila:Color;
	var sel:String;
	var eMedidas:FLDomElement = xmlPos.namedItem("Medidas").toElement();
	var ejeMedida:String = eMedidas.attribute("Eje");
	var ordenado:Boolean = (eMedidas.attribute("Ordenado") == "true");
	var orden:String = eMedidas.attribute("Orden");
	var limitado:Boolean = (eMedidas.attribute("Limitado") == "true");
	var limite:Number = parseInt(eMedidas.attribute("Limite"));

	this.iface.bloqueoMedidas_ = true;
	if (ejeMedida == "X") {
		this.child("rbnMedidaColumna").checked = true;
	} else {
		this.child("rbnMedidaFila").checked = true;
	}

	this.child("chkOrdenarMedida").checked = ordenado;
	if (orden == "DESC") {
		this.child("rbnOrdenMedDesc").checked = true;
	} else {
		this.child("rbnOrdenMedAsc").checked = true;
	}

	this.child("chkLimitar").checked = limitado;
	if (limitado) {
		this.child("sbxLimite").value = limite;
	} else {
		this.child("sbxLimite").value = limite;
	}
	this.iface.bloqueoMedidas_ = false;

	for (var i:Number = 0; i < numFilas; i++) {
		colorFila = this.iface.colorMedNoSel_;
		idMedida = tblMedidas.text(i, this.iface.CM_NOMBRE);
		nodoMedida = fldireinne.iface.pub_dameNodoXML(this.iface.xmlPosActual_, "Posicion/Medidas/Medida[@Id=" + idMedida + "]");
		if (nodoMedida) {
			sel = "S";
			colorFila = this.iface.colorMedSel_;
		} else {
			sel = "N";
			colorFila = this.iface.colorMedNoSel_;
		}
		tblMedidas.setText(i, this.iface.CM_SEL, sel);
		this.iface.cambiarColorFilaTabla(tblMedidas, i, colorFila);
	}
	tblMedidas.repaintContents();
	this.iface.habilitarPorOrdenMedida();
	this.iface.habilitarPorLimiteMedida();
}

function oficial_cambiarColorFilaTabla(tabla:Object, iFila:Number, sColorFila:String)
{
	var numCol:Number = tabla.numCols();
	var colorFila:Color = fldireinne.iface.pub_dameColor(sColorFila);
	if (!colorFila) {
		return false;
	}
	for (var iCol:Number = 0; iCol < numCol; iCol++) {
		tabla.setCellBackgroundColor(iFila, iCol, colorFila);
	}
}

function oficial_cambiarColorColumnaTabla(tabla:Object, iCol:Number, sColorCol:String)
{
	var numRow:Number = tabla.numRows();
	var colorCol:Color = fldireinne.iface.pub_dameColor(sColorCol);
	if (!colorCol) {
		return false;
	}
	for (var iRow:Number = 0; iRow < numRow; iRow++) {
		tabla.setCellBackgroundColor(iRow, iCol, colorCol);
	}
}

// function oficial_listarClaves(campo:String, lista:String):String
function oficial_listarClaves(nivel:String, lista:String):String
{
	var listaClaves:String = "";
	if (!lista || lista == "") {
		return "";
	}
	var arrayLista:Array = lista.split(", ");
	for (var i:Number = 0; i < arrayLista.length; i++) {
		if (i > 0) {
			listaClaves += ", ";
		}
// 		listaClaves += this.iface.obtenerDesDimension(campo, arrayLista[i]);
		listaClaves += this.iface.obtenerDesNivel(nivel, arrayLista[i]);
	}
	return listaClaves;
}

/** \D Compone el nombre de la columna correspondiente a un nivel para ser usada en una consulta Sql
@param	nombreDim: Nombre de la dimensión
@return	cadena con el nombre de la columna
\end */
function oficial_dameColumnaSql(nombreNivel:String):String
{
	var columna:String;
	var aNivel:Array = this.iface.niveles_[nombreNivel];
	var eNivel:FLDomElement = aNivel["element"];
	columna = eNivel.attribute("table") + "." + eNivel.attribute("column");
	return columna;
}


/** \D Obtiene un array con la lista de claves de la tabla de un nivel
@param	nombreNivel: Nombre del nivel
@return	array de claves
\end */
/// XXXX
function oficial_obtenerMiembrosNivel(nombreNivel:String):Array
{
debug("********* oficial_obtenerMiembrosNivel para " + nombreNivel);

	var util:FLUtil = new FLUtil;

	var aNivel:Array = this.iface.niveles_[nombreNivel];
	if (aNivel["miembros"]) {
		return aNivel["miembros"];
	}
	aNivel["miembros"] = [];
	aNivel["indicemiembros"] = [];

	var eNivel:FLDomElement = aNivel["element"];
	var columna:String = eNivel.attribute("column");
	var listaColumnas:String = columna;
	var orden:String = columna;
	var columnaOrden:String;
	var columnaNombre:String;
	var tablaNivel:String = eNivel.attribute("table");
	if (tablaNivel == "none") {
		return this.iface.obtenerMiembrosNivelLista(aNivel);
	}
	
	columnaOrden = eNivel.attribute("ordinalColumn");
	if (columnaOrden != columna) {
		listaColumnas += ", " + columnaOrden;
		orden = columnaOrden;
	}
	
	columnaNombre = eNivel.attribute("nameColumn");
	if (columnaNombre != columna) {
		listaColumnas += ", " + columnaNombre;
	}
	
	var aProps:Array = aNivel["propiedades"];
	if (aProps) {
		var idProp:String;
		for (var i:Number = 0; i < aProps.length; i++) {
			idProp = aProps[i].attribute("Id");
			if (idProp != columna && idProp != columnaOrden && idProp != columnaNombre) {
				listaColumnas += ", " + idProp;
debug("listaColumnas " + listaColumnas);
			}
		}
	} else {
		debug("NO PROPS");
	}

	var elemento:Array;
	var qryMiembros:FLSqlQuery;
	if (this.iface.conexionBI_) {
		qryMiembros = new FLSqlQuery("", this.iface.conexionBI_);
	} else {
		qryMiembros = new FLSqlQuery();
	}
	qryMiembros.setTablesList(tablaNivel);
	qryMiembros.setSelect(listaColumnas);
	qryMiembros.setFrom(eNivel.attribute("table"));
	qryMiembros.setWhere("1 = 1 GROUP BY " + listaColumnas + " ORDER BY " + orden);
	qryMiembros.setForwardOnly(true);
	if (!qryMiembros.exec()) {
		return false;
	}
	var totalMiembros:Number = qryMiembros.size();
	if (totalMiembros == 0) {
		MessageBox.warning(util.translate("scripts", "Error al obtener los miembros del nivel %1.\nLa tabla está vacía").arg(eNivel.attribute("name")), MessageBox.Ok, MessageBox.NoButton);;
		return false;
	}
	var i:Number = 0;
	var clave:String, idProp:String;
	var hayDialogo:Boolean = false; //totalMiembros > 500;
	var progreso:Number = 0;
	if (hayDialogo) {
		util.createProgressDialog(util.translate("scripts", "Cargando nivel %1").arg(aNivel["nombre"]), totalMiembros);
	}
	while (qryMiembros.next()) {
		if (hayDialogo) {
			util.setProgress(++progreso);
		}
		aNivel["miembros"][i] = [];
		aNivel["miembros"][i]["clave"] = qryMiembros.value(columna);
// debug("Miembro " + i + " clave " + aNivel["miembros"][i]["clave"]);
		aNivel["indicemiembros"][aNivel["miembros"][i]["clave"]] = i;
		if (columnaOrden != columna) {
			aNivel["miembros"][i]["ordinal"] = qryMiembros.value(columnaOrden);
// debug("Ordinal column = " + aNivel["miembros"][i]["ordinal"]);
		}
		if (columnaNombre != columna) {
			aNivel["miembros"][i]["nombre"] = qryMiembros.value(columnaNombre);
		}
		aNivel["miembros"][i]["propiedades"] = [];
		for (var k:Number = 0; k < aProps.length; k++) {
			idProp = aProps[k].attribute("Id");
// debug("Asignando valor " + qryMiembros.value(idProp) + " a prop " + idProp);
			aNivel["miembros"][i]["propiedades"][idProp] = qryMiembros.value(idProp);
		}
		i++;
	}
	if (hayDialogo) {
		util.destroyProgressDialog();
	}
	return aNivel["miembros"];
}

/** \Obtiene los miembros de un nivel no de una tabla sino de un atributo lista (values)
\end */
function oficial_obtenerMiembrosNivelLista(aNivel:Array):Array
{
	var eNivel:FLDomElement = aNivel["element"];
	var lista:String = eNivel.attribute("values");
	if (!lista || lista == "") {
		return false;
	}
	var aLista:Array = lista.split(",");
	for (var i:Number = 0; i < aLista.length; i++) {
		aNivel["miembros"][i] = [];
		aNivel["miembros"][i]["clave"] = aLista[i];
		aNivel["indicemiembros"][aNivel["miembros"][i]["clave"]] = i;
	}
	return aNivel["miembros"];
}


function oficial_sbxLimite_valueChanged(valor)
{
	var xmlPos:FLDomNode = this.iface.xmlPosActual_.firstChild();

	var eMedidas:FLDomElement = xmlPos.namedItem("Medidas");
	eMedidas.setAttribute("Limite", valor);
	this.iface.cargarPosicion(true);
}


function oficial_construirConsulta():FLSqlQuery
{
// debug("oficial_construirConsulta para " + this.iface.xmlPosActual_.toString(8));
	var xmlPos:FLDomNode = this.iface.xmlPosActual_.firstChild();

	var miWhere:String = "1 = 1";
	var filtros:FLDomNodeList = xmlPos.namedItem("Filtros").childNodes();
	var lista:String;
	var campo:String;
	var tipoCampo:String;
	var hipercubo:String = this.iface.cubo_;
	var miFrom:String = hipercubo;
	var aNivel:Array;
	var eNivel:FLDomElement;

	var comilla:String;
	var foreignTable:String;
	var arrayJoins:Array = [];
	var qryConsulta:FLSqlQuery;
	if (this.iface.conexionBI_) {
		qryConsulta = new FLSqlQuery("", this.iface.conexionBI_);
	} else {
		qryConsulta = new FLSqlQuery();
	}
 
	if (filtros && filtros.length() > 0) {
		var eFiltro:FLDomElement;
		for (var i:Number = 0; i < filtros.length(); i++) {
			eFiltro = filtros.item(i).toElement();
			campo = eFiltro.attribute("Campo");
			lista = eFiltro.attribute("Lista");
			aNivel = this.iface.niveles_[campo];
			eNivel = aNivel["element"];
			tipoCampo = eNivel.attribute("type");
			if (lista != "") {
				switch (tipoCampo) {
					case "String":
					case "Date": {
						comilla = "'";
						var arrayFiltro:Array = lista.split(", ");
						lista = "'" + arrayFiltro.join("', '") + "'";
						break;
					}
					default: {
						comilla = "";
					}
				}
				foreignTable = eNivel.attribute("table");
				if (foreignTable != this.iface.cubo_ && foreignTable != "none") {
					miWhere += " AND " + foreignTable + "." + eNivel.attribute("column") + " IN (" + lista + ")";
					miFrom += this.iface.construirJoinNivel(aNivel, arrayJoins);
				} else {
					miWhere += " AND " + this.iface.cubo_ + "." + eNivel.attribute("column") + " IN (" + lista + ")";
				}
			}
		}
	}

	var miGroupBy:String = "";
	var miOrderBy:String = "";
	
	var miSelect:String = "";
	var miLimit:String = "";
	var eMedidas:FLDomElement = xmlPos.namedItem("Medidas").toElement();
	var funAgregacion:String;
	for (var i:Number = 0; i < this.iface.iMedidas_.length; i++) {
		if (miSelect != "") {
			miSelect += ",";
		}
		funAgregacion = this.iface.dameSqlAgregacion(this.iface.iMedidas_[i]);
		switch(funAgregacion) {
			case "AVG": {
				miSelect += "SUM(" + this.iface.medidas_[this.iface.iMedidas_[i]]["element"].attribute("column") + "*" + this.iface.medidas_[this.iface.iMedidas_[i]]["element"].attribute("peso") + ")/SUM(" + this.iface.medidas_[this.iface.iMedidas_[i]]["element"].attribute("peso") + ")";
				break;
			}
			default: {
				miSelect += funAgregacion+ "(" + this.iface.medidas_[this.iface.iMedidas_[i]]["element"].attribute("column") + ")";
				break;
			}
		}
		if (i == 0) {
			if (eMedidas.attribute("Ordenado") == "true") {
				switch(funAgregacion) {
					case "AVG": {
						miOrderBy = "SUM(" + this.iface.medidas_[this.iface.iMedidas_[i]]["element"].attribute("column") + "*" + this.iface.medidas_[this.iface.iMedidas_[i]]["element"].attribute("peso") + ")/SUM(" + this.iface.medidas_[this.iface.iMedidas_[i]]["element"].attribute("peso") + ")";
						break;
					}
					default: {
						miOrderBy = funAgregacion + "(" + this.iface.medidas_[this.iface.iMedidas_[i]]["element"].attribute("column") + ")";
						break;
					}
				}
				miOrderBy += (eMedidas.attribute("Orden") == "ASC" ? "ASC" : "DESC");
			}
			if (eMedidas.attribute("Limitado") == "true") {
				var limite:Number = parseInt(eMedidas.attribute("Limite"));
				if (limite > 0) {
					miLimit = limite.toString();
				}
			}
		}
	}
	
	var eY:FLDomElement = xmlPos.namedItem("Dimensiones").namedItem("Y");
	var aNivelesY:Array;
	var eNivelY:FLDomElement;
	var columnaY:String;
	var columnaOrdenY:String;
	for (var nodoNivelY:FLDomNode = eY.firstChild(); nodoNivelY; nodoNivelY = nodoNivelY.nextSibling()) {
		eNivelY = nodoNivelY.toElement();
		if (eNivelY.nodeName() != "Nivel") {
			continue;
		}
		aNivel = this.iface.niveles_[eNivelY.attribute("Id")];
		eNivel = aNivel["element"];
		foreignTable = eNivel.attribute("table");
		if (foreignTable && foreignTable != "none") {
			columnaY = foreignTable + "." + eNivel.attribute("column");
			miFrom += this.iface.construirJoinNivel(aNivel, arrayJoins);
			if (eNivel.attribute("ordinalColumn") != "") {
				columnaOrdenY = foreignTable + "." + eNivel.attribute("ordinalColumn");
				if (columnaOrdenY != columnaY) {
					columnaOrdenY += ", " + columnaY;
				}
			}
		} else {
			columnaY = this.iface.cubo_ + "." + eNivel.attribute("column");
			columnaOrdenY += ", " + columnaY;
		}
		
		miGroupBy += (miGroupBy == "" ? columnaOrdenY : (", " + columnaOrdenY));
		miOrderBy += (miOrderBy == "" ? columnaOrdenY : (", " + columnaOrdenY));
		miOrderBy += " " + eNivelY.attribute("Orden");
		miSelect += "," + columnaY;
	}

	var eX:FLDomElement = xmlPos.namedItem("Dimensiones").namedItem("X");
	var aNivelesX:Array;
	var eNivelX:FLDomElement;
	var columnaX:String;
	for (var nodoNivelX:FLDomNode = eX.firstChild(); nodoNivelX; nodoNivelX = nodoNivelX.nextSibling()) {
		eNivelX = nodoNivelX.toElement();

		aNivel = this.iface.niveles_[eNivelX.attribute("Id")];
		eNivel = aNivel["element"];
		foreignTable = eNivel.attribute("table");
		if (foreignTable && foreignTable != "none") {
			columnaX = eNivel.attribute("table") + "." + eNivel.attribute("column");
			miFrom += this.iface.construirJoinNivel(aNivel, arrayJoins);
		} else {
			columnaX = this.iface.cubo_ + "." + eNivel.attribute("table");
		}
		
		miGroupBy += (miGroupBy == "" ? columnaX : (", " + columnaX));
		miOrderBy += (miOrderBy == "" ? columnaX : (", " + columnaX));
		miOrderBy += " " + eNivelX.attribute("Orden");
		miSelect += "," + columnaX;
	}
	
	if (miGroupBy != "") {
		miWhere += " GROUP BY " + miGroupBy;
	}
	if (miOrderBy != "") {
		miWhere += " ORDER BY " + miOrderBy;
	}
	if (miLimit != "") {
		miWhere += " LIMIT " + miLimit;
	}
	
	var miTablesList:String = hipercubo;

debug("miTablesList = " + miTablesList);
debug("miSelect = " + miSelect);
debug("miFrom = " + miFrom);
debug("miWhere = " + miWhere);
	qryConsulta.setTablesList(miTablesList);
	qryConsulta.setSelect(miSelect);
	qryConsulta.setFrom(miFrom);
	qryConsulta.setWhere(miWhere);
	qryConsulta.setForwardOnly(true);
debug("SQL = " + qryConsulta.sql());
	if (miSelect == "") {
		return false;
	}
	return qryConsulta;
}

function oficial_construirConsultaX():FLSqlQuery
{
debug("oficial_construirConsultaX");
	var xmlPos:FLDomNode = this.iface.xmlPosActual_.firstChild();

	var miWhere:String = "1 = 1";
	var filtros:FLDomNodeList = xmlPos.namedItem("Filtros").childNodes();
	var lista:String;
	var campo:String;
	var tipoCampo:String;
	var hipercubo:String = this.iface.cubo_;
	var miFrom:String = hipercubo;
	var aNivel:Array;
	var eNivel:FLDomElement;

	var comilla:String;
	var foreignTable:String;
	var arrayJoins:Array = [];
	var qryConsulta:FLSqlQuery = (this.iface.conexionBI_ ? new FLSqlQuery("", this.iface.conexionBI_) : new FLSqlQuery());
	if (filtros && filtros.length() > 0) {
		var eFiltro:FLDomElement;
		for (var i:Number = 0; i < filtros.length(); i++) {
			eFiltro = filtros.item(i).toElement();
			campo = eFiltro.attribute("Campo");
			lista = eFiltro.attribute("Lista");
			aNivel = this.iface.niveles_[campo];
			eNivel = aNivel["element"];
			tipoCampo = eNivel.attribute("type");
debug("Campo = " + campo + " tipo = " + tipoCampo);
			if (lista != "") {
				switch (tipoCampo) {
					case "String":
					case "Date": {
						comilla = "'";
						var arrayFiltro:Array = lista.split(", ");
						lista = "'" + arrayFiltro.join("', '") + "'";
						break;
					}
					default: {
						comilla = "";
					}
				}
				foreignTable = eNivel.attribute("table");
debug("foreignTable = " + foreignTable);
				if (foreignTable != this.iface.cubo_ && foreignTable != "none") {
					miWhere += " AND " + foreignTable + "." + eNivel.attribute("column") + " IN (" + lista + ")";
					miFrom += this.iface.construirJoinNivel(aNivel, arrayJoins);
				} else {
					miWhere += " AND " + this.iface.cubo_ + "." + eNivel.attribute("column") + " IN (" + lista + ")";
				}
			}
		}
	}

	var miGroupBy:String = "";
	var miOrderBy:String = "";
	
	var miSelect:String = "";
	
	var eX:FLDomElement = xmlPos.namedItem("Dimensiones").namedItem("X");
	var aNivelesX:Array;
	var eNivelX:FLDomElement;
	var columnaX:String, colOrderBy;
	for (var nodoNivelX:FLDomNode = eX.firstChild(); nodoNivelX; nodoNivelX = nodoNivelX.nextSibling()) {
		eNivelX = nodoNivelX.toElement();

		aNivel = this.iface.niveles_[eNivelX.attribute("Id")];
		eNivel = aNivel["element"];
		foreignTable = eNivel.attribute("table");
		if (foreignTable && foreignTable != "none") {
			columnaX = eNivel.attribute("table") + "." + eNivel.attribute("column");
			miFrom += this.iface.construirJoinNivel(aNivel, arrayJoins);
			if (eNivel.attribute("ordinalColumn") != "") {
				colOrderBy = eNivel.attribute("table") + "." + eNivel.attribute("ordinalColumn") + ", " + columnaX;
			} else {
				colOrderBy = columnaX;
			}
		} else {
			columnaX = this.iface.cubo_ + "." + eNivel.attribute("column");
			colOrderBy = columnaX;
		}
		
		miGroupBy += (miGroupBy == "" ? colOrderBy : (", " + colOrderBy));
		miOrderBy += (miOrderBy == "" ? colOrderBy : (", " + colOrderBy));
		miOrderBy += " " + eNivelX.attribute("Orden");
		miSelect += "," + columnaX;
	}
	
	if (miGroupBy != "") {
		miWhere += " GROUP BY " + miGroupBy;
	}
	if (miOrderBy != "") {
		miWhere += " ORDER BY " + miOrderBy;
	}
	
	var miTablesList:String = hipercubo;

debug("miTablesList = " + miTablesList);
debug("miSelect = " + miSelect);
debug("miFrom = " + miFrom);
debug("miWhere = " + miWhere);
	qryConsulta.setTablesList(miTablesList);
	qryConsulta.setSelect(miSelect);
	qryConsulta.setFrom(miFrom);
	qryConsulta.setWhere(miWhere);
	qryConsulta.setForwardOnly(true);
debug("SQL = " + qryConsulta.sql());
	if (miSelect == "") {
		return false;
	}
	return qryConsulta;
}

/** \D Construye la sentencia JOIN para unir el hipercubo con la tabla asociada a una cierta dimensión
@param	dimension: Array con los datos de la dimensión
@param	arrayJoins: Array con los joins ya incluidos en el FROM
@return Sentencia JOIN, si es necesaria
\end */
function oficial_construirJoinNivel(aNivel:Array, arrayJoins:Array):String
{
	var hipercubo:String = this.iface.cubo_
	var eNivel:FLDomElement= aNivel["element"];
	var aJer:Array = aNivel["jerarquia"];
	var nombreJer:String = aJer["nombre"];
	var miJoin:String = "";
	if (nombreJer != "") {
		if (this.iface.buscarEnArray(arrayJoins, nombreJer) == -1) {
			miJoin = aJer["sqljoin"];
			arrayJoins.push(nombreJer);
		}
	}
	return miJoin;
}

/** \D Buscar un elemento (string) en un array unidimensional.
@param	contenido: Array
@param	valor: Cadena a buscar
@return Posición del primer elemento, -1 si no se encuentra
\end */
function oficial_buscarEnArray(contenido:Array, valor:String):Number
{
	var iPos:Number;
	if (!contenido) {
		return -1;
	}
	var numElementos:Number = contenido.length;
	for (iPos = 0; iPos < numElementos; iPos++) {
		if (contenido[iPos] == valor) {
			break;
		}
	}
	if (iPos >= numElementos) {
		iPos = -1;
	}
	return iPos;
}

/** \D Obtiene el ordinal de un nivel para una clave
@param	nombreNivel
@param	clave
\end */
function oficial_obtenerOrdinalNivel(nombreNivel:String, clave:String):String
{
	var util:FLUtil = new FLUtil;
	var ordinal:String;
debug("Obteniendo ordinal para " + nombreNivel + " clave " + clave);
	var aNivel:Array = this.iface.niveles_[nombreNivel];
	var eNivel:FLDomElement = aNivel["element"];
	if (eNivel.attribute("ordinalColumn") != eNivel.attribute("column")) {
		if (!aNivel["indicemiembros"]) {
			this.iface.obtenerMiembrosNivel(nombreNivel);
		}
		var iMiembro:Number = aNivel["indicemiembros"][clave];
		ordinal = aNivel["miembros"][iMiembro]["ordinal"];
	} else {
		ordinal = clave;
	}
	return ordinal;
}

function oficial_obtenerDesNivel(nombreNivel:String, clave:String):String
{
	var util:FLUtil = new FLUtil;
	
	if (!clave || clave == "") {
		return util.translate("scripts", "(Indefinido)");
	}
// 	return clave;
debug("oficial_obtenerDesNivel " + nombreNivel + " " + clave);
	var descripcion:String;

	var aNivel:Array = this.iface.niveles_[nombreNivel];
	if (aNivel["element"].attribute("levelType") == "TimeDays") {
		descripcion = util.dateAMDtoDMA(clave);
	} else if (aNivel["element"].attribute("nameColumn") != aNivel["element"].attribute("column")) {
		if (!aNivel["indicemiembros"]) {
			if (!this.iface.obtenerMiembrosNivel(nombreNivel)) {
				return false;
			}
		}
debug("Clave = " + clave);
		var iMiembro:Number;
		try {
			iMiembro = aNivel["indicemiembros"][clave];
			descripcion = aNivel["miembros"][iMiembro]["nombre"];
		} catch (e) {
			descripcion = clave;
		}
	} else {
		descripcion = clave;
	}
	return descripcion;
}

function oficial_obtenerDimension():String
{
	var util:FLUtil = new FLUtil;
	var dialogo = new Dialog;
	dialogo.okButtonText = util.translate("scripts", "Aceptar");
	dialogo.cancelButtonText = util.translate("scripts", "Cancelar");
	
	var gbxDialogo = new GroupBox;
	gbxDialogo.title = util.translate("scripts", "Seleccione dimensión");
	
	var rButtonNinguno = new RadioButton;
	rButtonNinguno.text = util.translate("scripts", "Ninguno");
	rButtonNinguno.checked = true;
	gbxDialogo.add(rButtonNinguno);

	var rButton:Array = new Array(this.iface.iNiveles_.length);
	for (var i:Number = 0; i < rButton.length; i++) {
		rButton[i] = new RadioButton;
		rButton[i].text = this.iface.niveles_[this.iface.iNiveles_[i]]["nombre"];
		rButton[i].checked = false;
		gbxDialogo.add(rButton[i]);
	}
	
	dialogo.add(gbxDialogo);

	if (!dialogo.exec()) {
		return false;
	}

	var i:Number;
	for (i = 0; i < rButton.length; i++) {
		if (rButton[i].checked) {
			break;
		}
	}
	if (i >= rButton.length) {
		return "ninguno";
	}

	return this.iface.iNiveles_[i];
}

function oficial_obtenerOpcionEF(arrayOps:Array):String
{
	var util:FLUtil = new FLUtil;
	var dialogo = new Dialog;
	dialogo.okButtonText = util.translate("scripts", "Aceptar");
	dialogo.cancelButtonText = util.translate("scripts", "Cancelar");
	
	var gbxDialogo = new GroupBox;
	gbxDialogo.title = util.translate("scripts", "Ejercicios fiscales");
	
	var rButton:Array = new Array(arrayOps.length);
	for (var i:Number = 0; i < rButton.length; i++) {
		rButton[i] = new CheckBox;
		rButton[i].text = arrayOps[i][0]+"  "+arrayOps[i][1];
		rButton[i].checked = false;
		gbxDialogo.add(rButton[i]);
	}
	
	dialogo.add(gbxDialogo);

	
	if (!dialogo.exec()) {
		return "";
	}
	var codigos:String="";
	for (var i:Number = 0; i < rButton.length; i++) {
		if (rButton[i].checked) {
			if(codigos!=""){
				codigos+=",";
			}
			codigos+="'"+arrayOps[i][0]+"'";
			
		}
	}
	return codigos;
}

/** \D Carga la tabla de dimensiones (restricciones)
 \end */
function oficial_iniciarTablaDimensiones()
{
	var util:FLUtil = new FLUtil;

	this.iface.CD_LABEL = 0;
	this.iface.CD_NOMBRE = 1;
	this.iface.CD_FILTRO = 2;

	var tblDimensiones:FLTable = this.child("tblDimensiones");
	tblDimensiones.setNumRows(0);
	tblDimensiones.setNumCols(3);
	tblDimensiones.hideColumn(this.iface.CD_NOMBRE);
	tblDimensiones.setColumnWidth(this.iface.CD_FILTRO, 500);
	tblDimensiones.setColumnLabels("*", util.translate("scripts", "Dimensión") + "* *" + util.translate("scripts", "Restricción"));

	var tblMedidas:FLTable = this.child("tblMedidas");
	tblMedidas.setNumRows(0);
	tblMedidas.setNumCols(3);
	tblMedidas.hideColumn(this.iface.CM_SEL);
	tblMedidas.hideColumn(this.iface.CM_NOMBRE);
	tblMedidas.setColumnLabels("*", " * *" + util.translate("scripts", "Medida"));
	
	if (!this.iface.cargarMetadatosCubo()) {
		return false;
	}

	var tblDimensiones = this.child("tblDimensiones");
	var eLevel:FLDomElement;
	var name:String;
	var visible:String;
	var iFila:Number = 0;
	for (var i:Number = 0; i < this.iface.iNiveles_.length; i++) {
		eLevel = this.iface.niveles_[this.iface.iNiveles_[i]]["element"];
		name = this.iface.niveles_[this.iface.iNiveles_[i]]["nombre"];
		if (name == this.iface.nivelBGMes_ || name == this.iface.nivelBGTrim_) {
			continue;
		}
		tblDimensiones.insertRows(iFila, 1);
		tblDimensiones.setText(iFila, this.iface.CD_LABEL, eLevel.attribute("alias"));
		tblDimensiones.setText(iFila, this.iface.CD_NOMBRE, name);
		iFila++;
	}

	var tblMedidas = this.child("tblMedidas");
	var eMed:FLDomElement;
	for (var i:Number = 0; i < this.iface.iMedidas_.length; i++) {
		eMed = this.iface.medidas_[this.iface.iMedidas_[i]]["element"];
		name = this.iface.medidas_[this.iface.iMedidas_[i]]["nombre"];
		visible = eMed.attribute("visible");
		if(visible == "false")
			continue;
		
		tblMedidas.insertRows(i, 1);
		tblMedidas.setText(i, this.iface.CM_LABEL, eMed.attribute("alias"));
		tblMedidas.setText(i, this.iface.CM_NOMBRE, name);
		tblMedidas.setText(i, this.iface.CM_SEL, "S");
		this.iface.cambiarColorFilaTabla(tblMedidas, i, this.iface.colorMedSel_);
	}
	
	this.iface.borrarCabecerasTabla(tblDimensiones, true, false);
	this.iface.borrarCabecerasTabla(tblMedidas, true, false);

	return true;
}

/** \D Indica si el nivel indicado está contenido en el cubo actual
\end */
function oficial_nivelEnCuboActual(nombreNivel:String):Boolean
{
	try {
		var aNivel:Array = this.iface.niveles_[nombreNivel];
	} catch (e) {
		return false;
	}
	return true;
}

function oficial_cargarMetadatosCubo():Boolean
{
	var util:FLUtil = new FLUtil;

	this.iface.medidas_ = [];
/// XXXX Guadar los datos de valores de niveles en arrays independientes (miembros e indicemiembros) y no borrarlos al cambiar de cubo
// 	if (!this.iface.dimensiones_) {
		this.iface.dimensiones_ = [];
		this.iface.jerarquias_ = [];
		this.iface.niveles_ = [];
// 	}

	this.iface.iMedidas_ = [];
// 	if (!this.iface.iDimensiones_) {
		this.iface.iDimensiones_ = [];
		this.iface.iJerarquias_ = [];
		this.iface.iNiveles_ = [];
// 	}

	var metadatosCubo:String = util.sqlSelect("flfiles", "contenido", "nombre = '" + this.iface.cubo_ + ".mtd'");
// debug("this.iface.cubo_ = " + this.iface.cubo_);
// debug("metadatosCubo = " + metadatosCubo);
	if (!metadatosCubo) {
		return;
	}
	if (!this.iface.xmlSchema_) {
		this.iface.xmlSchema_ = new FLDomDocument;
	}
	var xmlCubo:FLDomDocument = new FLDomDocument;
	xmlCubo.setContent(metadatosCubo);
	var nodoSchemaAux:FLDomNode = fldireinne.iface.pub_dameNodoXML(xmlCubo, "TMD/Schema");
	if (!nodoSchemaAux) {
		debug("!nodoSchemaAux");
		return false;
	}
	nodoSchema = nodoSchemaAux.cloneNode();
	this.iface.xmlSchema_.appendChild(nodoSchema);

	var nodoCube:FLDomNode = nodoSchema.namedItem("Cube");
	if (!nodoCube) {
		debug("!nodoCube");
		return false;
	}

	var nodoAux:FLDomNode;
	for (nodoAux = nodoCube.firstChild(); nodoAux; nodoAux = nodoAux.nextSibling()) {
		switch (nodoAux.nodeName()) {
			case "Dimension": {
				if (!this.iface.cargarDimension(nodoAux)) {
					return false;
				}
				break;
			}
			case "Measure": {
				if (!this.iface.cargarMedida(nodoAux)) {
					return false;
				}
				break;
			}
		}
	}
	return true;
}

/** \D Carga en memoria los datos de un nodo Measure
@param	nodoDim: Nodo Measure
\end */
function oficial_cargarMedida(nodoMed:FLDomDocument):Boolean
{
	var eMed:FLDomElement = nodoMed.toElement();

	var name:String = eMed.attribute("name");
	var alias:String = eMed.attribute("alias");
	if (!alias || alias == "") {
		alias = name;
	} else {
		alias = fldireinne.iface.pub_obtenerTraduccionAlias(alias);
	}
	eMed.setAttribute("alias", alias);

	var measureName:String = eMed.attribute("measureName");
	if (measureName && measureName != "") {
		measureName = fldireinne.iface.pub_obtenerTraduccionAlias(measureName);
	}
	eMed.setAttribute("measureName", measureName);
	
	this.iface.medidas_[name] = [];
	this.iface.medidas_[name]["element"] = eMed;
	this.iface.medidas_[name]["nombre"] = name;

	this.iface.iMedidas_[this.iface.iMedidas_.length] = name; ///this.iface.medidas_[name];
// debug("Cargando medida " + name + " para posición " + this.iface.iMedidas_.length);
// debug(this.iface.iMedidas_[0]);
// debug(this.iface.iMedidas_[0]["element"]);
// debug(this.iface.iMedidas_[0]["element"].attribute("name"));

	return true;
}

/** \D Carga en memoria los datos de un nodo Dimension
@param	nodoDim: Nodo Dimension
\end */
function oficial_cargarDimension(nodoDim:FLDomDocument):Boolean
{
	var eDim:FLDomElement = nodoDim.toElement();

	var name:String = eDim.attribute("name");
	
	this.iface.dimensiones_[name] = [];
	this.iface.dimensiones_[name]["element"] = eDim;
	
	this.iface.iDimensiones_[this.iface.iDimensiones_.length] = name;

	var nodoAux:FLDomNode;
	for (nodoAux = nodoDim.firstChild(); nodoAux; nodoAux = nodoAux.nextSibling()) {
		switch (nodoAux.nodeName()) {
			case "Hierarchy": {
				if (!this.iface.cargarJerarquia(nodoAux)) {
					return false;
				}
				break;
			}
		}
	}
	return true;
}

/** \D Carga en memoria los datos de un nodo Hierarchy
@param	nodoJer: Nodo Hierarchy
\end */
function oficial_cargarJerarquia(nodoJer:FLDomDocument):Boolean
{
	var eJer:FLDomElement = nodoJer.toElement();

	var nameDim:String = eJer.parentNode().toElement().attribute("name");
	var nameJer:String = eJer.attribute("name");
	if (nameJer == "") {
		eJer.setAttribute("name", nameJer);
	}
	var name:String = nameDim + "." + nameJer;

	this.iface.jerarquias_[name] = [];
	this.iface.jerarquias_[name]["element"] = eJer;
	this.iface.jerarquias_[name]["nombre"] = name;
	this.iface.jerarquias_[name]["dimension"] = this.iface.dimensiones_[nameDim];	
	
	this.iface.iJerarquias_[this.iface.iJerarquias_.length] = name;

	var nodoAux:FLDomNode;
	for (nodoAux = nodoJer.firstChild(); nodoAux; nodoAux = nodoAux.nextSibling()) {
		switch (nodoAux.nodeName()) {
			case "Table":
			case "Join": {
				if (!this.iface.cargarJoinJerarquia(nodoAux, this.iface.jerarquias_[name])) {
					return false;
				}
				break;
			}
			case "Level": {
				if (!this.iface.cargarNivel(nodoAux)) {
					return false;
				}
				break;
			}
		}
	}
	return true;
}

/** \D Construye y carga en memoria la sentencia JOIN necesaria para usar una jerarquía
@param	nodoJoin: Nodo Table o Join
@param	aJerarquia: Array con los datos de la jerarquía
\end */
/// XXXXX
function oficial_cargarJoinJerarquia(nodoJoin:FLDomNode, aJerarquia:Array):Boolean
{
	var eJoin:FLDomElement = nodoJoin.toElement();
	var eJerarquia:FLDomElement = aJerarquia["element"];
	var eDimension:FLDomElement = eJerarquia.parentNode().toElement();
	var sJoin:String;
	var nombreTabla:String;
	switch (nodoJoin.nodeName()) {
		case "Table": {
			nombreTabla = eJoin.attribute("name");
			if (nombreTabla && nombreTabla != "" && nombreTabla != "none") {
				sJoin = " INNER JOIN " + nombreTabla + " ON " + this.iface.cubo_ + "." + eDimension.attribute("foreignKey") + " = " + eJoin.attribute("name") + "." + eJerarquia.attribute("primaryKey");
				var pkTable:String = eJerarquia.attribute("primaryKeyTable");
				if (pkTable == "") { eJerarquia.setAttribute("primaryKeyTable", eJoin.attribute("name")); }
			} else {
				eJerarquia.setAttribute("primaryKeyTable", nombreTabla);
				sJoin = "";
			}
			break;
		}
		case "Join": {
			/// Por ahora no se soportan Joins anidados
			var nodosTable:FLDomNodeList = eJoin.elementsByTagName("Table");
			var eLeftTable:FLDomNode = nodosTable.item(0).toElement();
			var eRightTable:FLDomNode = nodosTable.item(1).toElement();
			sJoin = " LEFT OUTER JOIN " + eLeftTable.attribute("name") + " ON " + this.iface.cubo_ + "." + eDimension.attribute("foreignKey") + " = " + eLeftTable.attribute("name") + "." + eJerarquia.attribute("primaryKey");
			sJoin += " LEFT OUTER JOIN " + eRightTable.attribute("name") + " ON " + eLeftTable.attribute("name") + "." + eJoin.attribute("leftKey") + " = " + eRightTable.attribute("name") + "." + eJoin.attribute("rightKey");
			break;
		}
	}
	aJerarquia["sqljoin"] = sJoin;
	return true;
}

/** \D Carga en memoria los datos de un nodo Level
@param	nodoJer: Nodo Level
\end */
function oficial_cargarNivel(nodoLevel:FLDomDocument):Boolean
{
	var eLevel:FLDomElement = nodoLevel.toElement();

	var nameDim:String = eLevel.parentNode().parentNode().toElement().attribute("name");
	var nameJer:String = eLevel.parentNode().toElement().attribute("name");
	var nameLevel:String = eLevel.attribute("name");
	var name:String = nameDim + "." + nameJer + "." + nameLevel;

	var alias:String = eLevel.attribute("alias");
	if (!alias || alias == "") {
		alias = name;
	} else {
		alias = fldireinne.iface.pub_obtenerTraduccionAlias(alias);
	}
	eLevel.setAttribute("alias", alias);
	
	this.iface.niveles_[name] = [];
	this.iface.niveles_[name]["element"] = eLevel;
	this.iface.niveles_[name]["nombre"] = name;
	this.iface.niveles_[name]["jerarquia"] = this.iface.jerarquias_[nameDim + "." + nameJer];
	this.iface.niveles_[name]["miembros"] = false;
	this.iface.niveles_[name]["indicemiembros"] = false;
	this.iface.niveles_[name]["indicemiembrossel"] = false; /// Indice de miembros que cumplen las condiciones de búsqueda
	this.iface.niveles_[name]["filtroactual"] = false; /// Condiciones de búsqueda
	
	this.iface.iNiveles_[this.iface.iNiveles_.length] = name;

	var eJer:FLDomElement = this.iface.niveles_[name]["jerarquia"]["element"];

	var valorAtt:String;
	valorAtt = eLevel.attribute("ordinalColumn");
	(valorAtt == "" ? eLevel.setAttribute("ordinalColumn", eLevel.attribute("column")) : 0 );
	valorAtt = eLevel.attribute("nameColumn");
	(valorAtt == "" ? eLevel.setAttribute("nameColumn", eLevel.attribute("column")) : 0 );
	valorAtt = eLevel.attribute("table");
	(valorAtt == "" ? eLevel.setAttribute("table", eJer.attribute("primaryKeyTable")) : 0 );
	valorAtt = eLevel.attribute("type");
	(valorAtt == "" ? this.iface.cargarTipoNivel(this.iface.niveles_[name]) : 0 );
	
	this.iface.niveles_[name]["propiedades"] = this.iface.cargarPropiedadesNivel(eLevel);
	if (!this.iface.niveles_[name]["propiedades"]) {
		debug("No hay array propiedades");
		return false;
	}
	
	var levelType:String = eLevel.attribute("levelType");
	switch (levelType) {
		case "TimeMonths": {
			this.iface.nivelBGMes_ = name;
			break;
		}
		case "TimeTerms": {
			this.iface.nivelBGTrim_ = name;
			break;
		}
		case "TimeYears": {
			this.iface.nivelBGAnno_ = name;
			break;
		}
	}
// 	for (var i:Number = 0; i < this.iface.niveles_[name]["propiedades"].length; i++) {
// 		debug("Prop " + i + " : " + this.iface.niveles_[name]["propiedades"][i].attribute("name"));
// 	}

	return true;
}

/** Carga un array de FLDomElements con cada campo de la tabla de niveles como propiedad 
@param	eLevel: Nodo XML con los datos del nivel
@return	array de elementos propiedad
\end */
/// XXXXX
function oficial_cargarPropiedadesNivel(eLevel:FLDomElement):Array
{
	var util:FLUtil = new FLUtil;
	var aProps:Array = [];
	var nombreNivel:String = eLevel.attribute("name");
	var tablaNivel:String = eLevel.attribute("table");
	if (!tablaNivel || tablaNivel == "") {
		debug("No hay tabla para el nivel " + nombreNivel);
		return false;
	}
	if (tablaNivel == "none") {
		return aProps;
	}
	
	var metadatosNivel:String = util.sqlSelect("flfiles", "contenido", "nombre = '" + tablaNivel + ".mtd'");
	if (!metadatosNivel) {
		return;
	}
	var xmlPropsNivel:FLDomDocument = new FLDomDocument;
	xmlPropsNivel.setContent(metadatosNivel);
	var nodoTMD:FLDomNode = xmlPropsNivel.namedItem("TMD");
	if (!nodoTMD) {
		debug("!nodoTMD");
		return false;
	}
	var eField:FLDomElement;
	var eProp:FLDomElement;
	var indice:Number = 0, alias:String;
	for (var nodoAux:FLDomNode = nodoTMD.firstChild(); nodoAux; nodoAux = nodoAux.nextSibling()) {
		if (nodoAux.nodeName() != "field") {
			continue;
		}
		eField = nodoAux.toElement();
		if (eField.attribute("in_property") != "true") {
			continue;
		}
		eProp = xmlPropsNivel.createElement("Propiedad");
		aProps[indice++] = eProp;
		eProp.setAttribute("Id", eField.namedItem("name").firstChild().nodeValue());
		alias = eField.namedItem("alias").firstChild().nodeValue();
		alias = fldireinne.iface.pub_obtenerTraduccionAlias(alias);
		eProp.setAttribute("Alias", alias);
	}
		
	return aProps;
}

/** Busca y carga en memoria el tipo de un campo para un nivel
@param	aNivel: Array del nivel
\end */
function oficial_cargarTipoNivel(aNivel:Array):Boolean
{
	var util:FLUtil = new FLUtil;
	var campo:String = aNivel["element"].attribute("column");
// 	var tabla:String = aNivel["element"].parentNode().attribute("primaryKeyTable");
	var tabla:String = aNivel["element"].attribute("table");
	if (!tabla) {
		debug("!tabla");
		return false;
	}
	if (tabla == "none") {
		tabla = this.iface.cubo_;
	}
	var xmlMetadata:FLDomDocument = new FLDomDocument;
	var metadata:String = util.sqlSelect("flfiles", "contenido", "nombre = '" + tabla + ".mtd'");
	if (!metadata) {
		debug("!metadata " + tabla);
		return false;
	}
	xmlMetadata.setContent(metadata);
	var nodoField:FLDomNode;
	var nombreCampo:String;
	for (nodoField = xmlMetadata.namedItem("TMD").firstChild(); nodoField; nodoField = nodoField.nextSibling()) {
		if (nodoField.nodeName() != "field") {
			continue;
		}
		nodoName = nodoField.namedItem("name");
		if (!nodoName) {
			debug("!nodoName");
			return;
		}
		nombreCampo = nodoName.firstChild().nodeValue();
		if (nombreCampo == campo) {
			break;
		}
	}
	if (!nodoField) {
		debug("!nodoField");
		return false;
	}
	var nodoTipo:FLDomNode = nodoField.namedItem("type");
	if (!nodoTipo) {
		debug("!nodoTipo");
		return false;
	}
	var tipo:String = nodoTipo.firstChild().nodeValue();
	var tipoNivel:String;
	switch (tipo) {
		case "double":
		case "int":
		case "uint":
		case "serial": {
			tipoNivel = "Numeric";
			break;
		}
		case "string":
		case "stringlist":{
			tipoNivel = "String";
			break;
		}
		case "date": {
			tipoNivel = "Date";
			break;
		}
		default: {
			debug("Tipo no encontrado " + tipo);
			return false;
		}
	}
	aNivel["element"].setAttribute("type", tipoNivel);
	return true;
}

/** \D Busca y devuelve un array con los metadatos de un campo
@param	xmlTabla: Documento XML con los metadatos de la tabla
@param	campo: Nombre del campo
@return	Array con los metadatos. Los nombres de los miembros coinciden con los de los nodos hijos del nodo field
\end */
// function oficial_metadatosCampo(xmlTabla:FLDomDocument, campo:String):Array
// {
// 	var res:Array = false;
// 	var nodoField:FLDomNode;
// 	var nombreCampo:String;
// 	var nodoHijo:FLDomNode;
// 	for (nodoField = xmlTabla.namedItem("TMD").firstChild(); nodoField; nodoField = nodoField.nextSibling()) {
// 		if (nodoField.nodeName() != "field") {
// 			continue;
// 		}
// 		res = [];
// 		nodoHijo = nodoField.namedItem("name");
// 		if (!nodoHijo || nodoHijo.firstChild().nodeValue() != campo) {
// 			continue;
// 		}
// 		res["name"] = campo;
// 		nodoHijo = nodoField.namedItem("alias");
// 		if (nodoHijo) {
// 			var aliasCampo:String = nodoHijo.firstChild().nodeValue();
// 			if (aliasCampo.find("QT_TRANSLATE_NOOP") >= 0) {
// 				var iComillaFin:Number = aliasCampo.findRev("\"");
// 				var iComillaIni:Number = aliasCampo.findRev("\"", iComillaFin - 1);
// 				aliasCampo = aliasCampo.substring(iComillaIni + 1, iComillaFin);
// 			}
// 			res["alias"] = aliasCampo;
// 		} else {
// 			res["alias"] = false;
// 		}
// 		nodoHijo = nodoField.namedItem("type");
// 		if (nodoHijo) {
// 			res["type"] = nodoHijo.firstChild().nodeValue();
// 		} else {
// 			res["type"] = false;
// 		}
// 		break;
// 	}
// 	return res;
// }

function oficial_cargarDimensiones2():Boolean
{
	var util:FLUtil = new FLUtil;

	var dimension:Array;
	var totalDim:Number = this.iface.iDimensiones_.length;
	util.createProgressDialog(util.translate("scripts", "Cargando Dimensiones"), totalDim);
	
	for (var i:Number = 0; i < totalDim; i++) {
		dimension = this.iface.dimensiones_[this.iface.iDimensiones_[i]];
		util.setProgress(i + 1);
		util.setLabelText(util.translate("scripts", "Cargado %1").arg(dimension["alias"]));
		if (!this.iface.cargarDimensionX(dimension)) {
			MessageBox.warning(util.translate("scripts", "Error al cargar la dimensión %1").arg(dimension["alias"]), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}
	return true;
}

function oficial_sincronizarNiveles():Boolean
{
	var util:FLUtil = new FLUtil;

	var aNivel:Array;
	var totalNiveles:Number = this.iface.iNiveles_.length;
	util.createProgressDialog(util.translate("scripts", "Sincronizando niveles"), 100);
	
	for (var i:Number = 0; i < totalNiveles; i++) {
		aNivel = this.iface.niveles_[this.iface.iNiveles_[i]];
		util.setProgress(0);
		util.setLabelText(util.translate("scripts", "Sincronizando %1").arg(aNivel["nombre"]));
		if (!this.iface.sincronizarNivel(aNivel)) {
			MessageBox.warning(util.translate("scripts", "Error al sincronizar el nivel %1").arg(aNivel["nombre"]), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}
	return true;
}

/// XXXXX
function oficial_sincronizarNivel(aNivel:Array):Boolean
{
	var util:FLUtil = new FLUtil;
debug("Sincronizando nivel " + aNivel["nombre"]);
	var eNivel:FLDomElement = aNivel["element"];
	switch (eNivel.attribute("levelType")) {
		case "TimeDays": {
			this.iface.cargarDimensionDia();
			break;
		}
		case "TimeTerms": {
			this.iface.cargarDimensionTrimestre();
			break;
		}
		case "TimeMonths": {
			this.iface.cargarDimensionMesAnno();
			break;
		}
		case "TimeYears": {
			break;
		}
		default: {
			var tablaFuente:String = eNivel.attribute("sourceTable");
			if (!tablaFuente || tablaFuente == "" || tablaFuente == "none") {
				return true;
			}
			var uniqueMembers:Boolean= (eNivel.attribute("uniqueMembers") == "true");
			var tablaNivel:String = eNivel.attribute("table");
			var campoClave:String = eNivel.attribute("column");
			var curNivel:FLSqlCursor;
			if (this.iface.conexionBI_) {
				curNivel = new FLSqlCursor(tablaNivel, this.iface.conexionBI_);
			} else {
				curNivel = new FLSqlCursor(tablaNivel);
			}
			curNivel.setActivatedCheckIntegrity(false);
			curNivel.setForwardOnly(true);
			curNivel.select("1 = 1 AND 1 = 1 ORDER BY " + campoClave);
// 			while (curNivel.next()) {
// debug("Borrando articulo");
// 				curNivel.setModeAccess(curNivel.Del);
// 				curNivel.refreshBuffer();
// 				if (!curNivel.commitBuffer()) {
// 					return false;
// 				}
// 			}
			var arrayCampos:Array = util.nombreCampos(tablaNivel);
			var cuenta:Number = parseInt(arrayCampos[0]);
			arrayCampos.shift();
			var iUltimoCampo:Number = arrayCampos.length - 1;
			while (arrayCampos[iUltimoCampo].endsWith("check_column")) {
				arrayCampos.pop();
				iUltimoCampo--;
			}
			var listaCampos:String = arrayCampos.join(", ");

			var qryFuente:FLSqlQuery = (this.iface.conexion_ ? new FLSqlQuery("", this.iface.conexion_) : new FLSqlQuery());
			qryFuente.setTablesList(tablaFuente);
			qryFuente.setSelect(listaCampos);
			qryFuente.setFrom(tablaFuente);
			if (uniqueMembers) {
				qryFuente.setWhere("1 = 1 ORDER BY " + campoClave);
			} else {
				qryFuente.setWhere(listaCampos + " IS NOT NULL GROUP BY " + listaCampos + " ORDER BY " + campoClave);
			}
			qryFuente.setForwardOnly(true);
// debug(qryFuente.sql());
			if (!qryFuente.exec()) {
				return false;
			}

			var totalReg:Number = qryFuente.size();
			var regPaso:Number = Math.round(totalReg / 100);
			var progreso:Number = 0, progreso100:Number = 0;
			var valor:String;
			
			var claveD:String, claveF:String;
			var hayDestino:Boolean = curNivel.first();
			var hayFuente:Boolean = qryFuente.first();
			while (hayDestino || hayFuente) {
debug("hayDestino " + hayDestino);
debug("hayFuente " + hayFuente);
				if (progreso % regPaso == 0) {
					util.setProgress(++progreso100);
				}
				if (hayDestino && hayFuente) {
					claveD = curNivel.valueBuffer(campoClave);
					claveF = qryFuente.value(campoClave);
					if (claveD == claveF) {
						hayFuente = qryFuente.next();
						progreso++;
						hayDestino = curNivel.next();
					} else if (claveF > claveD) {
						curNivel.setModeAccess(curNivel.Del);
						curNivel.refreshBuffer();
						if (!curNivel.commitBuffer()) {
							return false;
						}
						hayDestino = curNivel.next();
					} else {
debug("1. Insertando Art " + arrayCampos[0]);
						curNivel.setModeAccess(curNivel.Insert);
						curNivel.refreshBuffer();
						for (var i:Number = 0; i < arrayCampos.length; i++) {
							valor = qryFuente.value(arrayCampos[i]);
		// debug(arrayCampos[i] + " = " + valor);
							if (valor == "") {
								valor = "N";
							}
							curNivel.setValueBuffer(arrayCampos[i], valor);
						}
						if (!curNivel.commitBuffer()) {
							return false;
						}
						hayFuente = qryFuente.next();
						progreso++;
					}
				} else if (!hayFuente) {
					curNivel.setModeAccess(curNivel.Del);
					curNivel.refreshBuffer();
					if (!curNivel.commitBuffer()) {
						return false;
					}
					hayDestino = curNivel.next();
				} else {
debug("2. Insertando Art " + arrayCampos[0]);
					curNivel.setModeAccess(curNivel.Insert);
					curNivel.refreshBuffer();
					for (var i:Number = 0; i < arrayCampos.length; i++) {
						valor = qryFuente.value(arrayCampos[i]);
	// debug(arrayCampos[i] + " = " + valor);
						if (valor == "") {
							valor = "N";
						}
						curNivel.setValueBuffer(arrayCampos[i], valor);
					}
					if (!curNivel.commitBuffer()) {
						return false;
					}
					hayFuente = qryFuente.next();
					progreso++;
				}
			}
// 			while (qryFuente.next()) {
// 				if (progreso++ % regPaso == 0) {
// 					util.setProgress(++progreso100);
// 				}
// 				curNivel.setModeAccess(curNivel.Insert);
// 				curNivel.refreshBuffer();
// 				for (var i:Number = 0; i < arrayCampos.length; i++) {
// 					valor = qryFuente.value(arrayCampos[i]);
// // debug(arrayCampos[i] + " = " + valor);
// 					if (valor == "") {
// 						valor = "N";
// 					}
// 					curNivel.setValueBuffer(arrayCampos[i], valor);
// 				}
// 				if (!curNivel.commitBuffer()) {
// 					return false;
// 				}
// 			}
			break;
		}
	}

	return true;
}


function oficial_cargarDimensionX(dimension:Array):Boolean
{
debug("Cargando dimension " + dimension["alias"]);
	switch (dimension["leveltype"]) {
		case "TimeMonths": {
			this.iface.cargarDimensionMesAnno();
			break;
		}
		case "TimeYears": {
			break;
		}
		default: {
			if (dimension["alias"] != "Referencia") {
				return true;
			}
debug("Cargando artículos");
			var foreignTable:String = dimension["foreigntable"];
			if (!foreignTable) {
				break;
			}
			var curDim:FLSqlCursor = new FLSqlCursor(foreignTable);
			curDim.setActivatedCheckIntegrity(false);
			curDim.select("1 = 1");
			curDim.setModeAccess(curDim.Del);
			curDim.refreshBuffer();
			if (!curDim.commitBuffer()) {
				return false;
			}
			var sourceTable:String = dimension["sourcetable"];
			if (!sourceTable) {
				break;
			}
			var arrayCampos:Array = util.nombreCampos(foreignTable);
			var cuenta:Number = parseInt(arrayCampos[0]);
			arrayCampos.shift();
			var listaCampos:String = arrayCampos.joint(", ");

			var qryST:FLSqlQuery = new FLSqlQuery();
			qryST.setTablesList(foreignTable);
			qryST.setSelect(listaCampos);
			qryST.setFrom(foreignTable);
			qryST.setWhere("1 = 1");
			qryST.setForwardOnly(true);
debug(qryST.sql());
			if (!qryST.exec()) {
				return false;
			}
			while (qryST.next()) {
				curDim.setModeAccess(curDim.Insert);
				curDim.refreshBuffer();
				for (var i:Number = 0; i < arrayCampos; i++) {
					curDim.setValueBuffer(arrayCampos[i], qryST.value(arrayCampos[i]));
				}
				if (!curDim.commitBuffer()) {
					return false;
				}
			}
			break;
		}
	}

	return true;
}


function oficial_cargarDimensiones():Boolean
{
	this.iface.sincronizarNiveles();
// 	this.iface.cargarDimensionMesAnno();
	return true;
}

// function oficial_cargarDimensionCliente():Boolean
// {
// 	this.iface.listaDim_[this.iface.listaDim_.length] = "d_codcliente";
// 	var util:FLUtil = new FLUtil;
// 	var curCliente:FLSqlCursor = new FLSqlCursor("in_dimcliente");
// 	curCliente.setActivatedCheckIntegrity(false);
// 	curCliente.select("1 = 1");
// 	while (curCliente.next()) {
// 		curCliente.setModeAccess(curCliente.Del);
// 		curCliente.refreshBuffer();
// 		curCliente.commitBuffer();
// 	}
// 
// 	var curDimCliente:FLSqlCursor = new FLSqlCursor("in_dimcliente");
// 	var qryDimCliente:FLSqlQuery = new FLSqlQuery();
// 	
// 	qryDimCliente.setTablesList("clientes");
// 	qryDimCliente.setSelect("codcliente, nombre");
// 	qryDimCliente.setFrom("clientes");
// 	qryDimCliente.setWhere("1=1");
// 	qryDimCliente.setForwardOnly( true );
// 	if (!qryDimCliente.exec()){
// 	   return false;
// 	}
// 
// 	var iCliente:Number = 0;
// 	this.iface.dim_["d_codcliente"] = [];
// 	var codCliente:String;
// 	while (qryDimCliente.next()) {
// 		codCliente = qryDimCliente.value("codcliente");
// 		curDimCliente.setModeAccess(curDimCliente.Insert);
// 		curDimCliente.refreshBuffer();
// 	
// 		curDimCliente.setValueBuffer("codcliente", codCliente);
// 		curDimCliente.setValueBuffer("nombre", qryDimCliente.value("nombre"));
// 		this.iface.dim_["d_codcliente"][iCliente++] = codCliente;
// 		
// 		if (!curDimCliente.commitBuffer()) {
// 			return false;
// 		}
// 	}
// 	return true;
// }
// 
// function oficial_cargarDimensionAgente():Boolean
// {
// 	this.iface.listaDim_[this.iface.listaDim_.length] = "d_codagente";
// 	var util:FLUtil = new FLUtil;
// 	if (!util.sqlDelete("in_dimagente", "1 = 1")) {
// 		return false;
// 	}
// 
// 	var curDimAgente:FLSqlCursor = new FLSqlCursor("in_dimagente");
// 	var qryDimAgente:FLSqlQuery = new FLSqlQuery();
// 	
// 	qryDimAgente.setTablesList("agentes");
// 	qryDimAgente.setSelect("codagente, nombre");
// 	qryDimAgente.setFrom("agentes");
// 	qryDimAgente.setWhere("1=1");
// 	try { qryDimAgente.setForwardOnly( true ); } catch (e) {}
// 	if (!qryDimAgente.exec()){
// 	   return false;
// 	}
// 
// 	var iAgente:Number = 0;
// 	this.iface.dim_["d_codagente"] = [];
// 	var codAgente:String;
// 	while (qryDimAgente.next()) {
// 		codAgente = qryDimAgente.value("codagente");
// 		curDimAgente.setModeAccess(curDimAgente.Insert);
// 		curDimAgente.refreshBuffer();
// 		curDimAgente.setValueBuffer("codagente", codAgente);
// 		curDimAgente.setValueBuffer("nombre", qryDimAgente.value("nombre"));
// 		if (!curDimAgente.commitBuffer()) {
// 			return false;
// 		}
// 		this.iface.dim_["d_codagente"][iAgente++] = codAgente;
// 	}
// 	return true;
// }
// 
// function oficial_cargarDimensionProvincia():Boolean
// {
// 	this.iface.listaDim_[this.iface.listaDim_.length] = "d_idprovincia";
// 	var util:FLUtil = new FLUtil;
// 	if (!util.sqlDelete("in_dimprovincia", "1 = 1")) {
// 		return false;
// 	}
// 
// 	var curDimProvincia:FLSqlCursor = new FLSqlCursor("in_dimprovincia");
// 	var qryDimProvincia:FLSqlQuery = new FLSqlQuery();
// 	
// 	qryDimProvincia.setTablesList("provincias");
// 	qryDimProvincia.setSelect("idprovincia, codigo, provincia");
// 	qryDimProvincia.setFrom("provincias");
// 	qryDimProvincia.setWhere("1 = 1");
// 	qryDimProvincia.setForwardOnly( true );
// 	if (!qryDimProvincia.exec()) {
// 	   return false;
// 	}
// 
// 	var iProvincia:Number = 0;
// 	this.iface.dim_["d_idprovincia"] = [];
// 	var idProvincia:String;
// 	while (qryDimProvincia.next()) {
// 		idProvincia = qryDimProvincia.value("idprovincia");
// 		curDimProvincia.setModeAccess(curDimProvincia.Insert);
// 		curDimProvincia.refreshBuffer();
// 		curDimProvincia.setValueBuffer("idprovincia", idProvincia);
// 		curDimProvincia.setValueBuffer("codigo", qryDimProvincia.value("codigo"));
// 		curDimProvincia.setValueBuffer("provincia", qryDimProvincia.value("provincia"));
// 		if (!curDimProvincia.commitBuffer()) {
// 			return false;
// 		}
// 		this.iface.dim_["d_idprovincia"][iProvincia++] = idProvincia;
// 	}
// 	return true;
// }
// 
// function oficial_cargarDimensionEjercicio(ejercicios:String):Boolean
// {
// 	this.iface.listaDim_[this.iface.listaDim_.length] = "d_codejercicio";
// 	var util:FLUtil = new FLUtil;
// 
// 	var where:String;
// 	if (ejercicios && ejercicios != "") {
// 		where = "codejercicio IN (" + ejercicios + ")";
// 	} else {
// 		where = "1 = 1";
// 	}
// 
// 	var curDimEjercicio:FLSqlCursor = new FLSqlCursor("in_dimejercicio");
// 	var qryDimEjercicio:FLSqlQuery = new FLSqlQuery();
// 	
// 	qryDimEjercicio.setTablesList("ejercicios");
// 	qryDimEjercicio.setSelect("codejercicio, nombre");
// 	qryDimEjercicio.setFrom("ejercicios");
// 	qryDimEjercicio.setWhere(where);
// 	qryDimEjercicio.setForwardOnly( true );
// 	if (!qryDimEjercicio.exec()){
// 	   return false;
// 	}
// 
// 	var iEjercicio:Number = 0;
// 	this.iface.dim_["d_codejercicio"] = [];
// 	var codEjercicio:String;
// 	while (qryDimEjercicio.next()) {
// 		codEjercicio = qryDimEjercicio.value("codejercicio");
// 		if (!util.sqlSelect("in_dimejercicio", "codejercicio", "codejercicio = '" + codEjercicio + "'")) {
// 			curDimEjercicio.setModeAccess(curDimEjercicio.Insert);
// 			curDimEjercicio.refreshBuffer();
// 			curDimEjercicio.setValueBuffer("codejercicio", codEjercicio);
// 			curDimEjercicio.setValueBuffer("nombre", qryDimEjercicio.value("nombre"));
// 			if (!curDimEjercicio.commitBuffer()) {
// 				return false;
// 			}
// 		}
// 		this.iface.dim_["d_codejercicio"][iEjercicio++] = codEjercicio;
// 	}
// 	
// 	return true;
// }
// 
// function oficial_cargarDimensionArticulo():Boolean
// {
// 	this.iface.listaDim_[this.iface.listaDim_.length] = "d_referencia";
// 	var util:FLUtil = new FLUtil;
// 	if (!util.sqlDelete("in_dimarticulo", "1 = 1")) {
// 		return false;
// 	}
// 
// 	var curDimArticulo:FLSqlCursor = new FLSqlCursor("in_dimarticulo");
// 	var qryDimArticulo:FLSqlQuery = new FLSqlQuery();
// 	
// 	qryDimArticulo.setTablesList("articulos");
// 	qryDimArticulo.setSelect("distinct(referencia), descripcion");
// 	qryDimArticulo.setFrom("articulos");
// 	qryDimArticulo.setWhere("1=1");
// 	try { qryDimArticulo.setForwardOnly( true ); } catch (e) {}
// 	if (!qryDimArticulo.exec()){
// 	   return false;
// 	}
// 
// 	var iArticulo:Number = 0;
// 	this.iface.dim_["d_referencia"] = [];
// 	var referencia:String;
// 	while (qryDimArticulo.next()) {
// 		referencia = qryDimArticulo.value("distinct(referencia)");
// 		curDimArticulo.setModeAccess(curDimArticulo.Insert);
// 		curDimArticulo.refreshBuffer();
// 	
// 		curDimArticulo.setValueBuffer("referencia", referencia);
// 		curDimArticulo.setValueBuffer("descripcion", qryDimArticulo.value("descripcion"));
// 		
// 		if (!curDimArticulo.commitBuffer()) {
// 			return false;
// 		}
// 		this.iface.dim_["d_referencia"][iArticulo++] = referencia;
// 	}
// 	
// 	return true;
// }

function oficial_cargarDimensionMesAnno():Boolean
{
	var util:FLUtil = new FLUtil;
	var fecha:Date;
	var mes:String;
	var anno:String;
debug("this.iface.conexionBI_ " + this.iface.conexionBI_);
debug("this.iface.conexion_ " + this.iface.conexion_);
	var curMes:FLSqlCursor;
	if (this.iface.conexionBI_) {
		curMes = new FLSqlCursor("in_dimmes", this.iface.conexionBI_);
	} else {
		curMes = new FLSqlCursor("in_dimmes");
	}
	curMes.setActivatedCheckIntegrity(false);
	curMes.select("1 = 1");
	while (curMes.next()) {
		curMes.setModeAccess(curMes.Del);
		curMes.refreshBuffer();
		curMes.commitBuffer();
	}
debug("1");
	var arrayMeses:String = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"];
	var arrayTrimestres:String = ["T1", "T1", "T1", "T2", "T2", "T2", "T3", "T3", "T3", "T4", "T4", "T4"];
	var curDimAnno:FLSqlCursor;
	var curDimMes:FLSqlCursor;
	if (this.iface.conexionBI_) {
		curDimAnno = new FLSqlCursor("in_dimanno", this.iface.conexionBI_);
		curDimMes = new FLSqlCursor("in_dimmes", this.iface.conexionBI_);
	} else {
		curDimAnno = new FLSqlCursor("in_dimanno");
		curDimMes = new FLSqlCursor("in_dimmes");
	}
	
debug("2");
	var mesAno:String;
	var iMes:Number = 0;
	var iAnno:Number = 0;
	var qryMesAno:FLSqlQuery;
	if (this.iface.conexionBI_) {
		qryMesAno = new FLSqlQuery("", this.iface.conexionBI_);
	} else {
		qryMesAno = new FLSqlQuery();
	}
debug("3 " + this.iface.anoMin_ + " " + this.iface.anoMax_);
	qryMesAno.setTablesList("in_dimmes");
	qryMesAno.setSelect("mesano");
	qryMesAno.setFrom("in_dimmes");
	for (var ano:Number = this.iface.anoMin_; ano <= this.iface.anoMax_; ano++) {
		for (var mes:Number = 1; mes <= 12; mes++) {
debug("mes = " + mes);
			if (mes < 10) {
				mesAno = ano.toString() + "0" + mes.toString();
			} else {
				mesAno = ano.toString() + mes.toString();
			}
			qryMesAno.setWhere("mesano = '" + mesAno + "'");
			qryMesAno.exec();
debug("4");
			if (!qryMesAno.first()) {
				curDimMes.setModeAccess(curDimMes.Insert);
				curDimMes.refreshBuffer();
				curDimMes.setValueBuffer("mesano", mesAno);
				curDimMes.setValueBuffer("mes", mes);
				curDimMes.setValueBuffer("nombremes", arrayMeses[mes - 1]);
				curDimMes.setValueBuffer("trimestre", arrayTrimestres[mes -1]);
				curDimMes.setValueBuffer("ano", ano);
				if (!curDimMes.commitBuffer()) {
					return false;
				}
			}
		}
	}
	return true;
}

function oficial_cargarDimensionTrimestre():Boolean
{
	var util:FLUtil = new FLUtil;

	var curT:FLSqlCursor;
	if (this.iface.conexionBI_) {
		curT = new FLSqlCursor("in_dimtrimestre", this.iface.conexionBI_);
	} else {
		curT = new FLSqlCursor("in_dimtrimestre");
	}
	curT.setActivatedCheckIntegrity(false);
	curT.select("1 = 1");
	while (curT.next()) {
		curT.setModeAccess(curT.Del);
		curT.refreshBuffer();
		curT.commitBuffer();
	}

	for(var t=1;t<5;t++) {
		curT.setModeAccess(curT.Insert);
		curT.refreshBuffer();
		curT.setValueBuffer("trimestre", "T" + t);
		if (!curT.commitBuffer())
			return false;
	}
	return true;
}

function oficial_cargarDimensionDia():Boolean
{
	var util:FLUtil = new FLUtil;
	var fecha:Date;
	var mes:String;
	var anno:String;
debug("this.iface.conexionBI_ " + this.iface.conexionBI_);
debug("this.iface.conexion_ " + this.iface.conexion_);
	var curFecha:FLSqlCursor;
	if (this.iface.conexionBI_) {
		curFecha = new FLSqlCursor("in_dimfecha", this.iface.conexionBI_);
	} else {
		curFecha = new FLSqlCursor("in_dimfecha");
	}
	curFecha.setActivatedCheckIntegrity(false);
	curFecha.select("1 = 1");
	while (curFecha.next()) {
		curFecha.setModeAccess(curFecha.Del);
		curFecha.refreshBuffer();
		curFecha.commitBuffer();
	}
debug("1");
	var arrayMeses:String = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"];

	var fecha:Date;
	var maxDias:Number;
	var qryFechas:FLSqlQuery;
	
	if (this.iface.conexionBI_) {
		qryFechas = new FLSqlQuery("", this.iface.conexionBI_);
	} else {
		qryFechas = new FLSqlQuery();
	}
debug("3 " + this.iface.anoMin_ + " " + this.iface.anoMax_);
	qryFechas.setTablesList("in_dimfecha");
	qryFechas.setSelect("dia");
	qryFechas.setFrom("in_dimfecha");
	for (var ano:Number = this.iface.anoMin_; ano <= this.iface.anoMax_; ano++) {
		for (var mes:Number = 1; mes <= 12; mes++) {
			maxDias = this.iface.calcularDiasMesAno(mes,ano);
			for (var dia:Number = 1; dia <= maxDias; dia++) {
debug("mes = " + mes);
				fecha = new Date( ano, mes, dia );
				qryFechas.setWhere("dia = '" + fecha + "'");
				qryFechas.exec();
	debug("4");
				if (!qryFechas.first()) {
					curFecha.setModeAccess(curFecha.Insert);
					curFecha.refreshBuffer();
					curFecha.setValueBuffer("dia", fecha);
					curFecha.setValueBuffer("mes", mes);
					curFecha.setValueBuffer("nombremes", arrayMeses[mes - 1]);
					curFecha.setValueBuffer("ano", ano);
					if (!curFecha.commitBuffer()) {
						return false;
					}
				}
			}
		}
	}
	return true;
}

// function oficial_filtrarTabla(dimension:String)
// {
// debug("oficial_filtrarTabla " + dimension);
// 	if (this.iface.bloqueoFiltros_) {
// 		return;
// 	}
// debug("oficial_filtrarTabla2 " + dimension);
// 	var nombreTabla:String = this.iface.tablaDimension(dimension);
// 	var listaSeleccion:String = "";
// 	var arraySeleccion:Array = this.child(nombreTabla).primarysKeysChecked();
// 	if (arraySeleccion.length != 0) {
// 		listaSeleccion = arraySeleccion.join(", ");
// 	}
// 	this.iface.cambiarFiltro(dimension, listaSeleccion);
// }


function oficial_cambiarFiltro(campo:String, lista:String):Boolean
{
debug("oficial_cambiarFiltro " + campo + " " + lista);
	if (!this.iface.ponerFiltro(campo, lista)) {
		return false;
	}

	this.iface.cargarPosicion(true);
}

/** Obtiene el filtro actual para la dimensión indicada
\end */
// function oficial_obtenerSeleccionActual(nombreDim:String):Array
/** Obtiene el filtro actual para el nivel indicado
@param	nombreNivel
@return	array con los miembros del nivel seleccionados
\end */
function oficial_obtenerSeleccionActual(nombreNivel:String):Array
{
	var seleccion:Array = [];
	var nodoFiltro:FLDomNode = fldireinne.iface.pub_dameNodoXML(this.iface.xmlPosActual_, "Posicion/Filtros/Filtro[@Campo=" + nombreNivel + "]");
	if (nodoFiltro) {
		var lista:String = nodoFiltro.toElement().attribute("Lista");
		if (lista && lista != "") {
// 			var miembros:Array = this.iface.obtenerElementosDim(nombreDim);
			var miembros:Array = this.iface.obtenerMiembrosNivel(nombreNivel);
// 			var indiceMiembros:Array = this.iface.dimensiones_[nombreDim]["indicemiembros"];
			var indiceMiembros:Array = this.iface.niveles_[nombreNivel]["indicemiembros"];
			var arrayClaves:Array = lista.split(", ");
			for (var i:Number = 0; i < arrayClaves.length; i++) {
debug("Buscando clave " + arrayClaves[i]);
debug("Valor = " + miembros[indiceMiembros[arrayClaves[i]]]);
				seleccion[i] = miembros[indiceMiembros[arrayClaves[i]]];
			}
		} else {
			return false;
		}
	} else {
		return false;
	}
	return seleccion;
}

/** Elimina el filtro asociado a la dimensión indicada
@param dimension: Dimensiónl cuyo filtro hay que eliminar
\end */
function oficial_borrarFiltro(dimension:String):Boolean
{
	var nodoFiltro:FLDomNode = fldireinne.iface.pub_dameNodoXML(this.iface.xmlPosActual_, "Posicion/Filtros/Filtro[@Campo=" + dimension + "]");
	if (nodoFiltro) {
		var nodoPadre:FLDomNode = nodoFiltro.parentNode();
		nodoPadre.removeChild(nodoFiltro);
	} else {
		return false;
	}
	return true;
}

function oficial_tbnPrevio_clicked()
{
	if (this.iface.iPosActual_ <= 0) {
		return;
	}
	this.iface.iPosActual_--;
debug("Cambiando a posición (-) >>> " + this.iface.iPosActual_);
	var xmlPos:FLDomNode = this.iface.xmlPosActual_.firstChild();
	this.iface.xmlPosActual_.removeChild(xmlPos);
	var nodoActual:FLDomNode = this.iface.posicionesMemo_[this.iface.iPosActual_].cloneNode(true);
	this.iface.xmlPosActual_.appendChild(nodoActual);
	this.iface.cargarPosicion(false);
}

function oficial_tbnSiguiente_clicked()
{
	if (this.iface.iPosActual_ >= (this.iface.totalPosicionesMemo_ - 1)) {
		return;
	}
	var nodoSiguiente:FLDomNode = this.iface.posicionesMemo_[this.iface.iPosActual_ + 1];
	if (!nodoSiguiente) {
		return;
	}
	this.iface.iPosActual_++;
debug("Cambiando a posición (+) >>> " + this.iface.iPosActual_);
	var xmlPos:FLDomNode = this.iface.xmlPosActual_.firstChild();
	this.iface.xmlPosActual_.removeChild(xmlPos);
	var nodoActual:FLDomNode = nodoSiguiente.cloneNode(true);
	this.iface.xmlPosActual_.appendChild(nodoActual);
	this.iface.cargarPosicion(false);

}

function oficial_habilitarNavegacion()
{
	var previoHab:Boolean = true;
	var siguienteHab:Boolean = true;

	if (this.iface.iPosActual_ <= 0) {
		previoHab = false;
	}

	if (this.iface.iPosActual_ == -1 || this.iface.iPosActual_ >= (this.iface.totalPosicionesMemo_ - 1)) {
		siguienteHab = false;
	} else {
		var nodoSiguiente:FLDomNode = this.iface.posicionesMemo_[this.iface.iPosActual_ + 1];
		if (!nodoSiguiente) {
			siguienteHab = false;
		}
	}
	
	this.child("tbnPrevio").enabled = previoHab;
	this.child("tbnSiguiente").enabled = siguienteHab;
}

function oficial_tbnGuardar_clicked()
{
	var util:FLUtil = new FLUtil;
	if (!this.iface.nombrePosActual_) {
		this.iface.tbnGuardarComo_clicked();
	}
	if (!this.iface.guardarPosicionActual()) {
		return false;
	}
	MessageBox.information(util.translate("scripts", "Se ha guardado la posición %1").arg(this.iface.nombrePosActual_), MessageBox.Ok, MessageBox.NoButton);
}

function oficial_tbnGuardarComo_clicked()
{
	var util:FLUtil = new FLUtil;
	var nombre = Input.getText(util.translate("scripts", "Nombre de la posición"), "", util.translate("scripts", "Guardar posición"));
	if (nombre) {
		if (nombre.length > 50) {
			nombre = nombre.left(50);
		}
		if (!this.iface.guardarComoPosicionActual(nombre)) {
			return false;
		}
		MessageBox.information(util.translate("scripts", "Se ha guardado la posición:\n%1").arg(nombre), MessageBox.Ok, MessageBox.NoButton);
	}
}

function oficial_guardarComoPosicionActual(nombre:String):Boolean
{
	var cursor:FLSqlCursor = this.cursor();
	var posicion:String = this.iface.xmlPosActual_.toString(4);

	var curPosiciones:FLSqlCursor = (this.iface.conexionBI_ ? new FLSqlCursor("in_posiciones", this.iface.conexionBI_) : new FLSqlCursor("in_posiciones"));
	curPosiciones.setModeAccess(curPosiciones.Insert);
	curPosiciones.refreshBuffer();
	curPosiciones.setValueBuffer("nombre", nombre);
	curPosiciones.setValueBuffer("posicion", posicion);
	curPosiciones.setValueBuffer("cubo", this.iface.cubo_);
	if (!curPosiciones.commitBuffer()) {
		return false;
	}
	this.iface.nombrePosActual_ = nombre;
	this.child("txtNombrePosicion").text = nombre;
	return true;
}

function oficial_guardarPosicionActual():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	if (!this.iface.nombrePosActual_) {
		return false;
	}
	if (!this.iface.guardarGraficoPos()) {
		return false,
	}
	if (!this.iface.guardarInformePos()) {
		return false,
	}
	var posicion:String = this.iface.xmlPosActual_.toString(4);
	var curPosiciones:FLSqlCursor = (this.iface.conexionBI_ ? new FLSqlCursor("in_posiciones", this.iface.conexionBI_) : new FLSqlCursor("in_posiciones"));
	curPosiciones.select("nombre = '" + this.iface.nombrePosActual_ + "' AND cubo = '" + this.iface.cubo_ + "'");
	if (!curPosiciones.first()) {
		MessageBox.warning(util.translate("scripts", "Error al guardar la posición. La posición %1 no existe.").arg(this.iface.nombrePosActual_), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	curPosiciones.setModeAccess(curPosiciones.Edit);
	curPosiciones.refreshBuffer();
	curPosiciones.setValueBuffer("posicion", posicion);
	if (!curPosiciones.commitBuffer()) {
		return false;
	}
	return true;
}

/** Guarda en la posición actual únicamente los cambios en el formato del gráfico
\end */
function oficial_guardarGraficoPosicionActual():Boolean
{
	var util:FLUtil = new FLUtil;
	
	var xmlPosAux:FLDomDocument = new FLDomDocument;
// 	xmlPosAux.appendChild(this.iface.xmlPosActual_.firstChild().cloneNode(true));
// 
// 	var xmlGrafAux:FLDomDocument = new FLDomDocument;
// 	xmlGrafAux.appendChild(this.iface.xmlGrafico_.firstChild().cloneNode(true));
	var curPosicion:FLSqlCursor = new FLSqlCursor("in_posiciones");
	curPosicion.select("nombre = '" + this.iface.nombrePosActual_ + "' AND cubo = '" + this.iface.cubo_ + "'");
	if (!curPosicion.first()) {
		return false;
	}
	curPosicion.setModeAccess(curPosicion.Edit);
	curPosicion.refreshBuffer();
	var sPosicion:String = curPosicion.valueBuffer("posicion");
	if (!xmlPosAux.setContent(sPosicion)) {
		return false;
	}
	if (!this.iface.guardarGraficoPos(xmlPosAux)) {
		return false;
	}
	curPosicion.setValueBuffer("posicion", xmlPosAux.toString(4));
	if (!curPosicion.commitBuffer()) {
		return false;
	}
	
// 	var idPos:String = util.sqlSelect("in_posiciones", "id", );
// 	if (!id) {
// 		return false;
// 	}
// 	if (!this.iface.establecerPosicion(id)) {
// 		return false;
// 	}
// 	this.iface.xmlGrafico_ = new FLDomDocument;
// 	this.iface.xmlGrafico_.appendChild(xmlGrafAux.firstChild().cloneNode(true));
// 	
// 	if (!this.iface.guardarPosicionActual()) {
// 		return false;
// 	}
// 	
// 	this.iface.xmlPosActual_ = new FLDomDocument;
// 	this.iface.xmlPosActual_.appendChild(xmlPosAux.firstChild().cloneNode(true));
	
	return true;
}

/** \D Guarda los valores de formato del gráfico actual en la posición actual
\end */
function oficial_guardarGraficoPos(xmlPosicion:FLDomDocument):Boolean
{
// debug("oficial_guardarGraficoPos");
	var eGrafico:FLDomElement;
	if (!this.iface.xmlGrafico_) {
// debug("!this.iface.xmlGrafico_");
		return true;
	}
	eGrafico = this.iface.xmlGrafico_.firstChild().toElement();
// debug("XML Gráfico = " + this.iface.xmlGrafico_.toString(4));

	
	var tipoGrafico:String = eGrafico.attribute("Tipo");
	var xmlDocPos:FLDomDocument = xmlPosicion ? xmlPosicion : this.iface.xmlPosActual_;
// debug("XML Posactual Antes = " + xmlDocPos.toString(4));
	var xmlPos:FLDomNode = xmlDocPos.firstChild();
	var xmlGraficosPos:FLDomNode = xmlPos.namedItem("Graficos");
	var eGraficosPos:FLDomElement;
	if (xmlGraficosPos) {
		eGraficosPos = xmlGraficosPos.toElement();
		var xmlGraficoPos:FLDomNode = fldireinne.iface.pub_dameNodoXML(eGraficosPos, "Grafico[@Tipo=" + tipoGrafico + "]");
		if (xmlGraficoPos) {
			eGraficosPos.removeChild(xmlGraficoPos);
		}
	} else {
		eGraficosPos = xmlDocPos.createElement("Graficos");
		xmlPos.appendChild(eGraficosPos);
	}
	
	var xmlFormatoGrafico:FLDomNode = eGrafico.cloneNode(true);
	var xmlValores:FLDomNode = xmlFormatoGrafico.namedItem("Valores");
	if (xmlValores) {
		xmlFormatoGrafico.removeChild(xmlValores);
	}
	var xmlFilas:FLDomNode = xmlFormatoGrafico.namedItem("Filas");
	if (xmlFilas) {
		xmlFormatoGrafico.removeChild(xmlFilas);
	}
	var xmlCols:FLDomNode = xmlFormatoGrafico.namedItem("Cols");
	if (xmlCols) {
		xmlFormatoGrafico.removeChild(xmlCols);
	}
// debug("XML Posactual Después = " + xmlDocPos.toString(4));
	eGraficosPos.appendChild(xmlFormatoGrafico);
	return true;
}

/** \D Guarda los valores de formato del informe actual en la posición actual
\end */
function oficial_guardarInformePos():Boolean
{
	if (!this.iface.xmlEstiloReport_) {
		return true;
	}
	var xmlPos:FLDomNode = this.iface.xmlPosActual_.firstChild();
	var xmlInformePos:FLDomNode = xmlPos.namedItem("Informe");
	var eInformePos:FLDomElement;
	if (xmlInformePos) {
		xmlPos.removeChild(xmlInformePos);
	}
// 	eInformePos = this.iface.xmlPosActual_.createElement("Informe");
// 	xmlPos.appendChild(eInformePos);
	var xmlFormatoInforme:FLDomNode = this.iface.xmlEstiloReport_.firstChild().cloneNode(true);
	xmlPos.appendChild(xmlFormatoInforme);
// 	eInformePos.appendChild(xmlFormatoInforme);
	return true;
}

function oficial_guardarInformePos2():Boolean
{
	if (!this.iface.xmlReportTemplate_) {
		return true;
	}
	var eReportTemplate:FLDomElement = fldireinne.iface.pub_dameNodoXML(this.iface.xmlReportTemplate_, "KugarTemplate").toElement();
// 	var tipoGrafico:String = eGrafico.attribute("Tipo");

	var xmlPos:FLDomNode = this.iface.xmlPosActual_.firstChild();
	var xmlInformePos:FLDomNode = xmlPos.namedItem("Informe");
	var eInformePos:FLDomElement;
	if (xmlInformePos) {
		xmlPos.removeChild(xmlInformePos);
	}
	eInformePos = this.iface.xmlPosActual_.createElement("Informe");
	xmlPos.appendChild(eInformePos);
	var xmlFormatoInforme:FLDomNode = eReportTemplate.cloneNode(true);
	eInformePos.appendChild(xmlFormatoInforme);
	return true;
}

/** \D Borra los valores de formato del informe actual de la posición actual
\end */
function oficial_borrarInformePos():Boolean
{
	var xmlPos:FLDomNode = this.iface.xmlPosActual_.firstChild();
	var xmlInformePos:FLDomNode = xmlPos.namedItem("Informe");
	if (xmlInformePos) {
		xmlPos.removeChild(xmlInformePos);
	}
	return true;
}

function oficial_tbnAbrir_clicked()
{
	var util:FLUtil = new FLUtil;
	var filtro:String = "cubo = '" + this.iface.cubo_ + "'";
	var idPos:String = this.iface.seleccionarPosicion(filtro);
debug("idPos = " + idPos);
	if (!idPos) {
		return false;
	}
// 	var aPos:Array = this.iface.datosPosicion(idPos);
// debug("aPos = " + aPos);
// 	if (!aPos) {
// 		return false;
// 	}
// debug("abrir 1");
// 	this.iface.nombrePosActual_ = aPos["nombre"];
// debug("abrir 2");
// 	if (!this.iface.establecerPosicionActual(aPos["posicion"])) {
// 		return false;
// 	}
	if (!this.iface.establecerPosicion(idPos)) {
		return false;
	}
debug("abrir 3");
	this.iface.cargarPosicion(true);
debug("abrir 4");
	this.child("txtNombrePosicion").text = this.iface.nombrePosActual_;
	MessageBox.information(util.translate("scripts", "Posición %1 abierta").arg(this.iface.nombrePosActual_), MessageBox.Ok, MessageBox.NoButton);
}

/** \C Carga el cubo y los datos de una posición
@param	idPos: Identificador de la posición
*/
function oficial_establecerPosicion(idPos:String):Boolean
{
	var util:FLUtil = new FLUtil;
	var aPos:Array = this.iface.datosPosicion(idPos);
	if (!aPos) {
		return false;
	}
	if (!this.iface.establecerPosicionArray(aPos)) {
		return false;
	}
	return true;
}

/** \D Establece la posición actual en base a un array con los siguientes campos:
cubo: Nombre del cubo
nombre: Nombre de la posición
posicion: Posición en formato XML
\end */
function oficial_establecerPosicionArray(aPos:Array):Boolean
{
	var util:FLUtil = new FLUtil;
	if (this.iface.cubo_ != aPos["cubo"]) {
		this.iface.cambiarCubo(aPos["cubo"]);
	}
	this.iface.nombrePosActual_ = aPos["nombre"];
	if (!this.iface.xmlPosActual_) {
		this.iface.xmlPosActual_ = new FLDomDocument;
	}
	if (!this.iface.xmlPosActual_.setContent(aPos["posicion"])) {
		MessageBox.warning(util.translate("scripts", "Error: No se ha podido cargar la posición seleccionada"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	if (this.iface.xmlGrafico_) {
		delete this.iface.xmlGrafico_;
	}
	this.iface.xmlGrafico_ = false;
	
	return true;
}

function oficial_establecerTipoGrafico(tipoGrafico:String):Boolean
{
	this.iface.tipoGrafico_ = tipoGrafico;
	return true;
}

/** \D Obtienes los datos relativos a una posición anteriormente guardada
@return	Array con:
	* nombre: Nombre de la posición
	* xmlpos: XML de la posición
	* cubo: Nombre del cubo
\end */
function oficial_datosPosicion(idPos:String):Array
{
debug("oficial_datosPosicion");
	var qryPosicion:FLSqlQuery = (this.iface.conexionBI_ ? new FLSqlQuery("", this.iface.conexionBI_) : new FLSqlQuery());
	qryPosicion.setTablesList("in_posiciones");
	qryPosicion.setSelect("nombre, posicion, cubo");
	qryPosicion.setFrom("in_posiciones");
	qryPosicion.setWhere("id = " + idPos);
	if (!qryPosicion.exec()) {
		return false;
	}
	if (!qryPosicion.first()) {
		return false;
	}
debug("oficial_datosPosicion 1");
	var aPos:Array = [];
	aPos["nombre"] = qryPosicion.value("nombre");
	aPos["posicion"] = qryPosicion.value("posicion");
	aPos["cubo"] = qryPosicion.value("cubo");
	aPos["idposicion"] = idPos;
debug("oficial_datosPosicion 2");
	return aPos;
}

function oficial_seleccionarPosicion(filtro:String):String
{
	var util:FLUtil = new FLUtil();
	
	var curPosicion:FLSqlCursor = (this.iface.conexionBI_ ? new FLSqlCursor("in_posiciones", this.iface.conexionBI_) : new FLSqlCursor("in_posiciones"));
	curPosicion.setMainFilter(filtro);
	
	var f:Object = new FLFormSearchDB(curPosicion, "in_posiciones");
	
	curPosicion.setMainFilter(filtro);
	
	f.setMainWidget();
	var id:String = f.exec("id");
	if (!id) {
		return false;
	}
	return id;
}

/** \C Devuelve el máximo valor de la tabla para un determinado rango de columnas
@param colDesde: Columna inicial del rango
@param colHasta: Columna final del rango. Opcional.
@return Máximo valor encontrado
\end */
function oficial_maximoColArray(colDesde:Number, colHasta:Number, divisiones:Number):Number
{
	if (!colHasta) {
		colHasta = colDesde;
	}
// 	this.iface.xmlDatos_
	var maximo:Number = Number.MIN_VALUE;
	var valor:Number;
	var numFilas:Number = this.iface.arrayTabla_.length - 1;
	for (var col:Number = colDesde; col <= colHasta; col++) {
		for (var fil:Number = 1; fil <= numFilas; fil++) {
			valor = parseFloat(this.iface.arrayTabla_[fil][col]);
debug("valor = " + valor);
			if (valor > maximo) {
				maximo = valor;
			}
		}
	}
debug("maximo = " + maximo);
	maximo = Math.ceil(maximo / divisiones) * divisiones;
debug("maximo2 = " + maximo);
	return maximo;
}


// function oficial_obtenerClaveColumna(iCol:Number):String
// {
// 	debug(this.iface.cabeceraTabla_.join(" - "));
// 	return this.iface.cabeceraTabla_[iCol];
// }
// 
// function oficial_obtenerColumnaClave(clave:String):Number
// {
// 	var columnas:Array = this.iface.cabeceraTabla_;
// 
// 	var iCol:Number = -1;
// 	for (var i:Number = 1; i < columnas.length; i++) {
// 		if (columnas[i] == clave) {
// 			iCol = i;
// 			break;
// 		}
// 	}
// 	return iCol;
// }


function oficial_obtenerDimActual(eje:String):String
{
	var eDimensiones:FLDomElement = this.iface.xmlPosActual_.firstChild().namedItem("Dimensiones").toElement();
	return eDimensiones.attribute(eje);
}

function oficial_ordenarFilasDesc(filaA:Array, filaB:Array):Number
{
	var eOrdenacion:FLDomElement = this.iface.xmlPosActual_.firstChild().namedItem("Ordenacion").toElement();
	
	var iCol:Number = this.iface.obtenerColumnaClave(eOrdenacion.attribute("Columna"));
	if (!iCol || isNaN(iCol)) {
		iCol = -1;
	}
	var resultado:Number = 0;
	if (iCol >= 0) {
		var valorA:Number = parseFloat(filaA[iCol]);
		var valorB:Number = parseFloat(filaB[iCol]);
		if (valorA < valorB) {
			resultado = 1;
		} else if (valorA > valorB) {
			resultado = -1;
		}
	} else {
		var nombreNivel:String = this.iface.obtenerDimActual("Y");
		var valorA:String = this.iface.obtenerOrdinalNivel(nombreNivel, filaA[0]);
		var valorB:String = this.iface.obtenerOrdinalNivel(nombreNivel, filaB[0]);
		if (valorA < valorB) {
			resultado = 1;
		} else if (valorA > valorB) {
			resultado = -1;
		}
	}
	return resultado;
}

function oficial_ordenarFilasAsc(filaA:Array, filaB:Array):Number
{
	var eOrdenacion:FLDomElement = this.iface.xmlPosActual_.firstChild().namedItem("Ordenacion").toElement();
	
	var iCol:Number = this.iface.obtenerColumnaClave(eOrdenacion.attribute("Columna"));
	if (!iCol || isNaN(iCol)) {
		iCol = -1;
	}
	var resultado:Number = 0;
	if (iCol >= 0) {
		var valorA:Number = parseFloat(filaA[iCol]);
		var valorB:Number = parseFloat(filaB[iCol]);
		if (valorA < valorB) {
			resultado = -1;
		} else if (valorA > valorB) {
			resultado = 1;
		}
	} else {
		var nombreNivel:String = this.iface.obtenerDimActual("Y");
		var valorA:String = this.iface.obtenerOrdinalNivel(nombreNivel, filaA[0]);
		var valorB:String = this.iface.obtenerOrdinalNivel(nombreNivel, filaB[0]);
		if (valorA < valorB) {
			resultado = -1;
		} else if (valorA > valorB) {
			resultado = 1;
		}
	}
	return resultado;
}

function oficial_chkLimitar_toggled(activo:Boolean)
{
	this.child("sbxLimite").enabled = activo;
	var xmlPos:FLDomNode = this.iface.xmlPosActual_.firstChild();

	var eMedidas:FLDomElement = xmlPos.namedItem("Medidas").toElement();
	eMedidas.setAttribute("Limitado", (activo ? "true" : "false"));
	this.iface.habilitarPorLimiteMedida();
	this.iface.cargarPosicion(true);
}

/** \D Muestra un formulario de multiseleccion para la dimension seleccionada
@param	fila: Fila seleccionada (dimension)
@param	col: Columna seleccionada (indiferente)
\end */
function oficial_tblDimensiones_doubleClicked(fila:Number, col:Number)
{
	var util:FLUtil = new FLUtil();
	var tblDimensiones:Object = this.child("tblDimensiones");
	var nombreNivel:String = tblDimensiones.text(fila, this.iface.CD_NOMBRE);
debug("nombreNivel = "  +  nombreNivel);
debug("this.iface.CD_NOMBRE = "  +  this.iface.CD_NOMBRE);
	var valores:String = this.iface.seleccionarValoresNivel(nombreNivel);
	if (valores == "CANCEL!") {
		return false;
	}

debug("valores  = " + valores);
	this.iface.cambiarFiltro(nombreNivel, valores);
}

/** \C Ofrece al usuario un cuadro de multiselección de los elementos de un nivel determinado
@param	nombreNivel: Nombre del nivel
@param	listaSel: Lista de elementos seleccionados actualmente (opcional)
@return	lista seleccionada por el usuario
\end */
function oficial_seleccionarValoresNivel(nombreNivel:String, listaSel:String):String
{
	var util:FLUtil = new FLUtil();
	var aNivel:Array = this.iface.niveles_[nombreNivel];
	var eNivel:FLDomElement = aNivel["element"];
	var valores:String = "";
debug("listaSel " + listaSel);
	var listaActual:String = listaSel ? listaSel : this.iface.dameListaFiltro(nombreNivel);
	if (listaActual == "*") {
		listaActual = "";
	}
debug("listaActual " + listaActual);
	var levelType:String = eNivel.attribute("levelType");
	switch (levelType) {
		case "TimeMonths": {
			valores = this.iface.seleccionarMeses(listaActual);
			break;
		}
		case "TimeYears": {
			valores = this.iface.seleccionarAno(listaActual);
			break;
		}
		case "TimeTerms": {
			valores = this.iface.seleccionarTrimestre(listaActual);
			break;
		}
		default: {
			var accion:String = eNivel.attribute("table"); //"in_sel" + eNivel.attribute("table");
debug("accion = " + accion);
			if (!accion) {
				return false;
			}
			if (accion == "none") {
				valores = this.iface.seleccionarValoresLista(eNivel.attribute("values"), listaActual);
			} else {
				var curAccion:FLSqlCursor = (this.iface.conexionBI_ ? new FLSqlCursor(accion, this.iface.conexionBI_) : new FLSqlCursor(accion));
				this.iface.seleccionValores_ = listaActual;

				var f:Object = new FLFormSearchDB(curAccion, accion);
				f.setMainWidget();
				f.exec();
	debug("¿accepted?");
				if (f.accepted()) {
					valores = this.iface.seleccionValores_;
				} else {
					valores = "CANCEL!";
				}
			}
		}
	}
debug("valores = '" + valores + "'");
	return valores;
}

/** \D Permite que el usuario seleccione uno o mas meses
@param	listaActual: Lista de meses actualmente seleccionados
@return	Lista de meses (numerica)
\end */
function oficial_seleccionarMeses(listaActual:String):String
{
	var util:FLUtil = new FLUtil;

	var dialogo:Dialog = new Dialog;
	dialogo.okButtonText = util.translate("scripts", "Aceptar");
	dialogo.cancelButtonText = util.translate("scripts", "Cancelar");
	
	var gbxDialogo = new GroupBox;
	gbxDialogo.title = util.translate("scripts", "Seleccione meses");
	dialogo.add(gbxDialogo);

	var arrayMeses:String = [util.translate("scripts", "Enero"), util.translate("scripts", "Febrero"), util.translate("scripts", "Marzo"), util.translate("scripts", "Abril"), util.translate("scripts", "Mayo"), util.translate("scripts", "Junio"), util.translate("scripts", "Julio"), util.translate("scripts", "Agosto"), util.translate("scripts", "Septiembre"), util.translate("scripts", "Octubre"), util.translate("scripts", "Noviembre"), util.translate("scripts", "Diciembre")];

	var chkMes:Array = [];
	for (var i:Number = 0; i < 12; i++) {
		chkMes[i] = new CheckBox;
		chkMes[i].text = arrayMeses[i];
		chkMes[i].checked = false;
		gbxDialogo.add(chkMes[i]);
	}
	if (listaActual && listaActual != "" && listaActual != "*") {
		var arrayActual:Array = listaActual.split(", ");
		for (var i:Number = 0; i < arrayActual.length; i++) {
			chkMes[arrayActual[i] - 1].checked = true;
		}
	}
	if (!dialogo.exec()) {
		return "CANCEL!";
	}
	var lista:String = "";
	for (var i:Number = 0; i < 12; i++) {
		if (chkMes[i].checked) {
			if (lista != "") {
				lista += ", ";
			}
			lista += (i + 1);
		}
	}
	return lista;
}

function oficial_seleccionarTrimestre(listaActual:String):String
{debug("listaActual " + listaActual);
	var util:FLUtil = new FLUtil;

	var dialogo:Dialog = new Dialog;
	dialogo.okButtonText = util.translate("scripts", "Aceptar");
	dialogo.cancelButtonText = util.translate("scripts", "Cancelar");
	
	var gbxDialogo = new GroupBox;
	gbxDialogo.title = util.translate("scripts", "Seleccione trimestre");
	dialogo.add(gbxDialogo);

	var arrayT:String = ["T1", "T2", "T3", "T4"];

	var chkT:Array = [];
	for (var i:Number = 0; i < 4; i++) {
		chkT[i] = new CheckBox;
		chkT[i].text = arrayT[i];
		chkT[i].checked = false;
		gbxDialogo.add(chkT[i]);
	}
	if (listaActual && listaActual != "" && listaActual != "*") {
		var arrayActual:Array = listaActual.split(", ");
		for (var i:Number = 0; i < arrayActual.length; i++) {
			chkT[i].checked = true;
		}
	}
	if (!dialogo.exec()) {
		return "CANCEL!";
	}
	var lista:String = "";
	for (var i:Number = 0; i < 4; i++) {
		if (chkT[i].checked) {
			if (lista != "") {
				lista += ", ";
			}
			lista += "T" +  (i + 1).toString();
		}
	}
	return lista;
}

function oficial_seleccionarValoresLista(listaCompleta:String, listaActual:String):String
{debug("listaActual " + listaActual);
debug("listaCompleta " + listaCompleta);
	var util:FLUtil = new FLUtil;

	if (!listaCompleta || listaCompleta == "") {
		return "";
	}
	var dialogo:Dialog = new Dialog;
	dialogo.okButtonText = util.translate("scripts", "Aceptar");
	dialogo.cancelButtonText = util.translate("scripts", "Cancelar");
	
	var gbxDialogo = new GroupBox;
	gbxDialogo.title = util.translate("scripts", "Seleccione valores");
	dialogo.add(gbxDialogo);

	var arrayL:String = listaCompleta.split(",");

	var chkL:Array = [];
	for (var i:Number = 0; i < arrayL.length; i++) {
		chkL[i] = new CheckBox;
		chkL[i].text = arrayL[i];
		chkL[i].checked = false;
		gbxDialogo.add(chkL[i]);
	}
	if (listaActual && listaActual != "" && listaActual != "*") {
		var arrayActual:Array = listaActual.split(", ");
		for (var i:Number = 0; i < arrayActual.length; i++) {
			for (var k:Number = 0; k < chkL.length; k++) {
				chkL[k].checked = (chkL[k].text == arrayActual[i]);
			}
		}
	}
	if (!dialogo.exec()) {
		return "CANCEL!";
	}
	var lista:String = "";
	for (var i:Number = 0; i < arrayL.length; i++) {
		if (chkL[i].checked) {
			if (lista != "") {
				lista += ", ";
			}
			lista += chkL[i].text;
		}
	}
	return lista;
}

/** \D Permite que el usuario seleccione uno o mas años
@param	listaActual: Lista de años actualmente seleccionados
@return	Lista de años
\end */
function oficial_seleccionarAno(listaActual:String):String
{
	var util:FLUtil = new FLUtil;

	var dialogo:Dialog = new Dialog;
	dialogo.okButtonText = util.translate("scripts", "Aceptar");
	dialogo.cancelButtonText = util.translate("scripts", "Cancelar");
	
	var gbxDialogo = new GroupBox;
	gbxDialogo.title = util.translate("scripts", "Seleccione años");
	dialogo.add(gbxDialogo);

	var chkMes:Array = [];
	var i:Number = 0;
	for (var ano:Number = this.iface.anoMin_; ano <= this.iface.anoMax_; ano++) {
		chkMes[i] = new CheckBox;
		chkMes[i].text = ano;
		chkMes[i].checked = false;
		gbxDialogo.add(chkMes[i]);
		i++;
	}
	var iCheckAno:Number;
	if (listaActual && listaActual != "" && listaActual != "*") {
		var arrayActual:Array = listaActual.split(", ");
		for (var k:Number = 0; k < arrayActual.length; k++) {
			iCheckAno = arrayActual[k] - this.iface.anoMin_;
			if (iCheckAno >= 0 && iCheckAno < chkMes.length) {
				chkMes[iCheckAno].checked = true;
			}
		}
	}
	if (!dialogo.exec()) {
		return "CANCEL!";
	}
	var lista:String = "";
	i = 0;
	var anoMin:Number = parseInt(this.iface.anoMin_);
	var anoMax:Number = parseInt(this.iface.anoMax_);
	for (var ano:Number = anoMin; ano <= anoMax; ano++) {
		if (chkMes[i].checked) {
			if (lista != "") {
				lista += ", ";
			}
			lista += anoMin + i;
		}
		i++;
	}
	return lista;
}

function oficial_dameSeleccionValores():String
{
	return this.iface.seleccionValores_;
}

function oficial_ponSeleccionValores(s:String)
{
	this.iface.seleccionValores_ = s;
}

/** \D Obtiene la lista de valores seleccionados como filtro para un determinado nivel
@param	dimension: Dimensión en la que actúa el filtro
\end */
function oficial_dameListaFiltro(nombreNivel:String):String
{
	var lista:String = "";
	var nodoFiltro:FLDomNode = fldireinne.iface.pub_dameNodoXML(this.iface.xmlPosActual_, "Posicion/Filtros/Filtro[@Campo=" + nombreNivel + "]");
	if (!nodoFiltro) {
		return lista;
	}
	lista = nodoFiltro.toElement().attribute("Lista");
	return lista;
}

// function oficial_tbnFiltrarColumnas_clicked()
// {
// 	var xmlPos:FLDomNode = this.iface.xmlPosActual_.firstChild();
// 	var dimX:String = xmlPos.namedItem("Dimensiones").attribute("X");
// 	if (!dimX || dimX == "") {
// 		return false;
// 	}
// 
// 	var tblDatos:FLTable = this.child("tblDatos");
// 	var columnasSel:Array = tblDatos.selectedCols();
// 	if (!columnasSel || columnasSel.length == 0) {
// 		return false;
// 	}
// 	var seleccion:String = "";
// 	for (var i:Number = 0; i < columnasSel.length; i++) {
// 		if (i > 0) {
// 			seleccion += ", ";
// 		}
// 		seleccion += this.iface.arrayTabla_[0][parseInt(columnasSel[i]) + 1];
// 	}
// 	this.iface.cambiarFiltro(dimX, seleccion);
// }
// 
// function oficial_tbnFiltrarFilas_clicked()
// {
// 	var xmlPos:FLDomNode = this.iface.xmlPosActual_.firstChild();
// 	var dimY:String = xmlPos.namedItem("Dimensiones").attribute("Y");
// 	if (!dimY || dimY == "") {
// 		return false;
// 	}
// 
// 	var tblDatos:FLTable = this.child("tblDatos");
// 	var filasSel:Array = tblDatos.selectedRows();
// 	if (!filasSel || filasSel.length == 0) {
// 		return false;
// 	}
// 	var seleccion:String = "";
// 	for (var i:Number = 0; i < filasSel.length; i++) {
// 		if (i > 0) {
// 			seleccion += ", ";
// 		}
// 		seleccion += this.iface.arrayTabla_[parseInt(filasSel[i]) + 1][0];
// 	}
// 	this.iface.cambiarFiltro(dimY, seleccion);
// }

function oficial_dibujar2dBarras(marco:Rect)
{
	var util:FLUtil = new FLUtil;

	var eGrafico:FLDomElement = this.iface.xmlGrafico_.firstChild().toElement();
	var pic:Picture;
	
	if (this.iface.nombrePosActual_ != "" && eGrafico.attribute("Titulo") == "") {
		eGrafico.setAttribute("Titulo", this.iface.nombrePosActual_);
	}
	var xmlValores:FLDomNode = this.iface.xmlGrafico_.firstChild().namedItem("Valores");
	if (xmlValores) {
		eGrafico.removeChild(xmlValores);
	}
	var eValores:FLDomElement = this.iface.xmlGrafico_.createElement("Valores");
	eGrafico.appendChild(eValores);
	
	var xmlPos:FLDomNode = this.iface.xmlPosActual_.firstChild();
	var xmlDat:FLDomNode = this.iface.xmlDatos_.firstChild();
	var nodoNivelX:FLDomNode = xmlPos.namedItem("Dimensiones").namedItem("X").namedItem("Nivel");
	var nodoMedida:FLDomNode = xmlPos.namedItem("Medidas").namedItem("Medida");
	if (!nodoMedida) {
		pic = this.iface.mostrarErrorGrafico(util.translate("scripts", "Debe indicar una medida a representar"), marco);
		return pic;
	}

	var nodoX:FLDomNode = xmlPos.namedItem("Dimensiones").namedItem("X");
	var xmlDimX:FLDomNodeList = nodoX.childNodes();
	if (xmlDimX && xmlDimX.length() > 1) {
		pic = this.iface.mostrarErrorGrafico(util.translate("scripts", "El total de niveles en el eje X debe ser 0 ó 1"), marco);
		return pic;
	}
	var idNivelX:String;
	var elementosX:Array;
	var secuenciasX:Array;
	var iSecuenciasX:Array;
	var totalSecuencias:Number;
	if (nodoNivelX) {
		idNivelX = nodoNivelX.toElement().attribute("Id");
		elementosX = this.iface.dameElementosX(idNivelX);
		secuenciasX = [];
		var idSecuencia:String;
		totalSecuencias = elementosX.length;
		for (var i:Number = 0; i < totalSecuencias; i++) {
			idSecuencia = elementosX[i];
			secuenciasX[idSecuencia] = this.iface.xmlGrafico_.createElement("Secuencia");
			eValores.appendChild(secuenciasX[idSecuencia]);
			secuenciasX[idSecuencia].setAttribute("Id", idSecuencia);
			secuenciasX[idSecuencia].setAttribute("Leyenda", this.iface.obtenerDesNivel(idNivelX, idSecuencia));
		}
	} else {
		idNivelX = "sinNivelX";
		secuenciasX = new Array(1);
		secuenciasX[0] = this.iface.xmlGrafico_.createElement("Secuencia");
		eValores.appendChild(secuenciasX[0]);
		secuenciasX[0].setAttribute("Id", "Sec. Única");
		totalSecuencias = 1;
	}
	eValores.setAttribute("Secuencias", totalSecuencias);
	
	var nodoY:FLDomNode = xmlPos.namedItem("Dimensiones").namedItem("Y");
	var nodosNivelY:FLDomNodeList = nodoY.childNodes();
	if (!nodosNivelY || nodosNivelY.count() != 1) {
		pic = this.iface.mostrarErrorGrafico(util.translate("scripts", "Debe indicar un nivel para el eje Y"), marco);
		return pic;
	}
	var nodoNivelY:FLDomNode = nodoY.namedItem("Nivel");
	var idNivelY:String = nodoNivelY.toElement().attribute("Id");
	var idMedida:String = nodoMedida.toElement().attribute("Id");
	var nombreMedida:String = this.iface.medidas_[idMedida]["element"].attribute("measureName");

	var eValor:FLDomElement;
	var eDato:FLDomElement;
	var valor:Number;
	var maxValor:Number = 0;
	var valorX:String;
	var valorY:String;
	var hayDatos:Boolean = false;
	for (var nodoDato:FLDomNode = xmlDat.firstChild(); nodoDato; nodoDato = nodoDato.nextSibling()) {
		hayDatos = true;
		eDato = nodoDato.toElement();
		eValor = this.iface.xmlGrafico_.createElement("Valor");
		valorX = (idNivelX == "sinNivelX" ? 0 : eDato.attribute(idNivelX));
		secuenciasX[valorX].appendChild(eValor);
		valorY = eDato.attribute(idNivelY);
		eValor.setAttribute("X", this.iface.elementosY_[valorY]);
		eValor.setAttribute("Y", eDato.attribute(idMedida));
		valor = parseFloat(eDato.attribute(idMedida));
		maxValor = (valor > maxValor ? valor : maxValor);
	}
	if (!hayDatos) {
		pic = this.iface.mostrarErrorGrafico(util.translate("scripts", "No hay datos que mostrar"), marco);
		return pic;
	}
	var eEjeX:FLDomElement = this.iface.xmlGrafico_.firstChild().namedItem("EjeX").toElement();
	eEjeX.setAttribute("Max", this.iface.iElementosY_.length);
	var eMarca:FLDomElement = eEjeX.namedItem("Marca");
	while (eMarca) {
		eEjeX.removeChild(eMarca);
		eMarca = eEjeX.namedItem("Marca");
	}
	for (var i:Number = 0; i < this.iface.iElementosY_.length; i++) {
		eMarca = this.iface.xmlGrafico_.createElement("Marca");
		eEjeX.appendChild(eMarca);
		eMarca.setAttribute("Id", i);
		eMarca.setAttribute("Label", this.iface.obtenerDesNivel(idNivelY, this.iface.iElementosY_[i]));
	}
	var eEjeY:FLDomElement = this.iface.xmlGrafico_.firstChild().namedItem("EjeY").toElement();
	eEjeY.setAttribute("Medida", nombreMedida);
/// 	eEjeY.setAttribute("Max", maxValor); // Se calcula automáticamente al dibujar

	if (eGrafico.attribute("DimFijas") != "true") {
		eGrafico.setAttribute("Alto", marco.height);
		eGrafico.setAttribute("Ancho", marco.width);
	}
	
// debug(this.iface.xmlGrafico_.toString(4));
	pic = flgraficos.iface.pub_dibujarGrafico(this.iface.xmlGrafico_, marco);
	return pic;
}

function oficial_dibujar2dTabla(marco:Rect)
{
	var util:FLUtil = new FLUtil;
// debug("oficial_dibujar2dTabla : " + this.iface.xmlGraficoTabla_.toString(4));
// 	debug("oficial_dibujar2dTabla : " + this.iface.xmlGrafico_.toString(4));
	var eGrafico:FLDomElement = this.iface.xmlGrafico_.firstChild().toElement();
	var pic:Picture;
	
	if (this.iface.nombrePosActual_ != "" && eGrafico.attribute("Titulo") == "") {
		eGrafico.setAttribute("Titulo", this.iface.nombrePosActual_);
	}
	var xmlValores:FLDomNode = this.iface.xmlGrafico_.firstChild().namedItem("Valores");
	if (xmlValores) {
		eGrafico.removeChild(xmlValores);
	}
	var eValores:FLDomElement = this.iface.xmlGrafico_.createElement("Valores");
	eGrafico.appendChild(eValores);
	
	var numFilas:Number = parseInt(eGrafico.attribute("NumFilas"));
	var numCols:Number = parseInt(eGrafico.attribute("NumCols"));
	if (!numFilas || !numCols) {
		pic = this.iface.mostrarErrorGrafico(util.translate("scripts", "El número de filas y columnas debe ser mayor que 0"), marco);
		return pic;
	}
	var aTabla:Array = this.iface.aTabla_;
	var eCelda:FLDomElement;
debug("NumFilas = " + numFilas);
	for (var iFila:Number = 0; iFila < numFilas; iFila++) {
debug("iFila = " + iFila);
		for (var iCol:Number = 0; iCol < numCols; iCol++) {
			eCelda = this.iface.creaCeldaDatosGraf(iFila, iCol);
			try {
				eCelda.setAttribute("Valor", aTabla[iFila][iCol]);
			} catch (e) {
				debug("No existe valor para celda " + iFila + ", " + iCol);
			}
		}
	}
	
	if (eGrafico.attribute("DimFijas") != "true") {
		eGrafico.setAttribute("Alto", marco.height);
		eGrafico.setAttribute("Ancho", marco.width);
	}
	
	pic = flgraficos.iface.pub_dibujarGrafico(this.iface.xmlGrafico_, marco);
	return pic;
}

function oficial_dibujar2dTarta(marco:Rec)
{
	debug("oficial_dibujar2dTarta");
	var util:FLUtil = new FLUtil;

	var eGrafico:FLDomElement = this.iface.xmlGrafico_.firstChild().toElement();
	var pic:Picture;
	
// 	var devSize = (contenedor ? contenedor.size : this.child( "lblGrafico" ).size);
// 	eGrafico.setAttribute("Alto", devSize.height);
// 	eGrafico.setAttribute("Ancho", devSize.width);
	if (this.iface.nombrePosActual_ != "" && eGrafico.attribute("Titulo") == "") {
		eGrafico.setAttribute("Titulo", this.iface.nombrePosActual_);
	}
	
	var xmlValores:FLDomNode = this.iface.xmlGrafico_.firstChild().namedItem("Valores");
	if(xmlValores)
		eGrafico.removeChild(xmlValores);
	
	var eValores:FLDomElement;eValores = this.iface.xmlGrafico_.createElement("Valores");
	eGrafico.appendChild(eValores);
	
	var xmlPos:FLDomNode = this.iface.xmlPosActual_.firstChild();
	var xmlDat:FLDomNode = this.iface.xmlDatos_.firstChild();
	
	var nodoMedida:FLDomNode = xmlPos.namedItem("Medidas").namedItem("Medida");
	if (!nodoMedida) {
		pic = this.iface.mostrarErrorGrafico(util.translate("scripts", "Debe indicar una medida a representar"),marco);
		return pic;
	}

	var nodoX:FLDomNode = xmlPos.namedItem("Dimensiones").namedItem("X");
	var xmlDimX:FLDomNodeList = nodoX.childNodes();
	if (xmlDimX && xmlDimX.length() > 1) {
		pic = this.iface.mostrarErrorGrafico(util.translate("scripts", "El total de niveles en el eje X debe ser 0 ó 1"), marco);
		return pic;
	}
	
	var nodoNivelX:FLDomNode = nodoX.namedItem("Nivel");
	var nodoY:FLDomNode = xmlPos.namedItem("Dimensiones").namedItem("Y");
	var nodosNivelY:FLDomNodeList = nodoY.childNodes();
	if (!nodosNivelY || nodosNivelY.length() != 1) {
		pic = this.iface.mostrarErrorGrafico(util.translate("scripts", "Debe indicar un nivel para el eje Y"),marco);
		return pic;
	}
	
	var nodoNivelY:FLDomNode = nodoY.namedItem("Nivel");
	var idNivelY:String = nodoNivelY.toElement().attribute("Id");
	var idMedida:String = nodoMedida.toElement().attribute("Id");
	var nombreMedida:String = this.iface.medidas_[idMedida]["element"].attribute("measureName");
	
	var idNivelX:String;
	var elementosX:Array;
	var secuenciasX:Array;
	var iSecuenciasX:Array;
	var totalSecuencias:Number;

	if (nodoNivelX) {
		idNivelX = nodoNivelX.toElement().attribute("Id");
		elementosX = this.iface.dameElementosX(idNivelX);
		secuenciasX = [];
		var idSecuencia:String;
		totalSecuencias = elementosX.length;
		for (var i:Number = 0; i < totalSecuencias; i++) {
			idSecuencia = elementosX[i];
			secuenciasX[idSecuencia] = this.iface.xmlGrafico_.createElement("Secuencia");
			eValores.appendChild(secuenciasX[idSecuencia]);
			secuenciasX[idSecuencia].setAttribute("Id", idSecuencia);
			secuenciasX[idSecuencia].setAttribute("Leyenda", this.iface.obtenerDesNivel(idNivelX, idSecuencia));
		}
	} else {
		idNivelX = "sinNivelX";
		secuenciasX = new Array(1);
		secuenciasX[0] = this.iface.xmlGrafico_.createElement("Secuencia");
		eValores.appendChild(secuenciasX[0]);
		secuenciasX[0].setAttribute("Id", "Sec. Única");
		totalSecuencias = 1;
	}
	eValores.setAttribute("Secuencias", totalSecuencias);
	

	var eValor:FLDomElement;
	var eDato:FLDomElement;
	var valor:Number;
	var valorX:String;
	var valorY:String;
	var total:Number = 0;
	var iValor:Number = 0;
	var hayDatos:Boolean = false;
	
	for (var nodoDato:FLDomNode = xmlDat.firstChild(); nodoDato; nodoDato = nodoDato.nextSibling()) {
		hayDatos = true;
		eDato = nodoDato.toElement();
		eValor = this.iface.xmlGrafico_.createElement("Valor");
		valorX = (idNivelX == "sinNivelX" ? 0 : eDato.attribute(idNivelX));
		secuenciasX[valorX].appendChild(eValor);
		valorY = eDato.attribute(idNivelY);
		
		valor = eDato.attribute(idMedida);
		eValor.setAttribute("Valor", valor);
		eValor.setAttribute("Label", this.iface.obtenerDesNivel(idNivelY, eDato.attribute(idNivelY)));
		total += parseFloat(valor);
		iValor++;
	}
	
	if (!hayDatos) {
		pic = this.iface.mostrarErrorGrafico(util.translate("scripts", "No hay datos que mostrar"), marco);
		return pic;
	}
	
	eValores.setAttribute("Total", total);
	eValores.setAttribute("NumValores", iValor);

	if (eGrafico.attribute("DimFijas") != "true") {
		eGrafico.setAttribute("Alto", marco.height);
		eGrafico.setAttribute("Ancho", marco.width);
	}
	
	debug(this.iface.xmlGrafico_.toString(4));
	pic = flgraficos.iface.pub_dibujarGrafico(this.iface.xmlGrafico_, marco);
	return pic;
}

function oficial_dibujar1dAguja(marco:Rect)
{debug("oficial_dibujar1dAguja");
	var util:FLUtil = new FLUtil;

	var eGrafico:FLDomElement = this.iface.xmlGrafico_.firstChild().toElement();
	var pic:Picture;
	
// 	var devSize = this.child( "lblGrafico" ).size;
// 	eGrafico.setAttribute("Alto", devSize.height);
// 	eGrafico.setAttribute("Ancho", devSize.width);
	
	var xmlValores:FLDomNode = this.iface.xmlGrafico_.firstChild().namedItem("Valores");
	if(xmlValores)
		eGrafico.removeChild(xmlValores);
	
	var eValores:FLDomElement;eValores = this.iface.xmlGrafico_.createElement("Valores");
	eGrafico.appendChild(eValores);
	
	var xmlPos:FLDomNode = this.iface.xmlPosActual_.firstChild();
	var xmlDat:FLDomNode = this.iface.xmlDatos_.firstChild();
	debug(this.iface.xmlDatos_.toString(4));
	debug(this.iface.xmlPosActual_.toString(4));
	var nodoMedida:FLDomNode = xmlPos.namedItem("Medidas").namedItem("Medida");
	if (!nodoMedida) {
		pic = this.iface.mostrarErrorGrafico(util.translate("scripts", "Debe indicar una medida a representar"),marco);
		return pic;
	}

	var idMedida:String = nodoMedida.toElement().attribute("Id");

	var nodoNivelY:FLDomNode = xmlPos.namedItem("Dimensiones").namedItem("Y").namedItem("Nivel");
	if (nodoNivelY) {
		pic = this.iface.mostrarErrorGrafico(util.translate("scripts", "No debe haber niveles en el eje Y"),marco);
		return pic;
	}
	
	var idNivel:String = "";
	var nodoNivelX:FLDomNode = xmlPos.namedItem("Dimensiones").namedItem("X").namedItem("Nivel");
	if (nodoNivelX) {
		idNivel =  nodoNivelX.toElement().attribute("Id");
	}

	var eValor:FLDomElement;
	var eDato:FLDomElement;
	var valor:Number;

	
	var clave:String;
	var titulo:String = this.iface.dameAliasMedida(idMedida);
	for (var nodoDato:FLDomNode = xmlDat.firstChild(); nodoDato; nodoDato = nodoDato.nextSibling()) {
		eDato = nodoDato.toElement();
		eValor = this.iface.xmlGrafico_.createElement("Valor");
		eValores.appendChild(eValor);
		valor = parseFloat(eDato.attribute(idMedida));
		eValor.setAttribute("Valor", valor);
		if (idNivel != "") {
			clave = eDato.attribute(idNivel);
			titulo = this.iface.obtenerDesNivel(idNivel, clave);
		}
		eValor.setAttribute("Titulo", titulo);
	}
	
	if (eGrafico.attribute("DimFijas") != "true") {
		eGrafico.setAttribute("Alto", marco.height);
		eGrafico.setAttribute("Ancho", marco.width);
	}
	
	pic = flgraficos.iface.pub_dibujarGrafico(this.iface.xmlGrafico_, marco);
	return pic;
}

function oficial_dibujar2dMapa(marco:Rect):pic
{
debug("oficial_dibujar2dMapaProv");
	var util:FLUtil = new FLUtil;

	var eGrafico:FLDomElement = this.iface.xmlGrafico_.firstChild().toElement();
	var pic:Picture;
	
// 	if (!this.iface.xmlGrafico_) {
// 		this.iface.construir2dMapaProvDefecto(contenedor, marco);
// 	} else {
// 		if (this.iface.xmlGrafico_.firstChild().toElement().attribute("Tipo") != "2d_mapaproves") {
// 			this.iface.construir2dMapaProvDefecto(contenedor, marco);
// 		}
// 	}

	var xmlValores:FLDomNode = this.iface.xmlGrafico_.firstChild().namedItem("Valores");
	if (xmlValores) {
		eGrafico.removeChild(xmlValores);
	}
// 	var devSize = this.child( "lblGrafico" ).size;
// 	eGrafico.setAttribute("Alto", devSize.height);
// 	eGrafico.setAttribute("Ancho", devSize.width);

	var eValores:FLDomElement = this.iface.xmlGrafico_.createElement("Valores");
	eGrafico.appendChild(eValores);

	var xmlPos:FLDomNode = this.iface.xmlPosActual_.firstChild();
	var xmlDat:FLDomNode = this.iface.xmlDatos_.firstChild();
// debug(this.iface.xmlDatos_.toString(4));

	var nodoMedida:FLDomNode = xmlPos.namedItem("Medidas").namedItem("Medida");
	if (!nodoMedida) {
		this.iface.mostrarErrorGrafico(util.translate("scripts", "Debe indicar una medida a representar"), marco);
		return false;
	}

	var nodoX:FLDomNode = xmlPos.namedItem("Dimensiones").namedItem("X");
	var xmlDimX:FLDomNodeList = nodoX.childNodes();
	if (xmlDimX && xmlDimX.length() > 0) {
		this.iface.mostrarErrorGrafico2(util.translate("scripts", "No debe haber niveles en el eje X"), marco);
		return false;
	}

	var nodoY:FLDomNode = xmlPos.namedItem("Dimensiones").namedItem("Y");
	var xmlDimY:FLDomNodeList = nodoY.childNodes();
	if (!xmlDimY || xmlDimY.length() != 1) {
		this.iface.mostrarErrorGrafico(util.translate("scripts", "Debe haber un único nivel en el eje Y"), marco);
		return false;
	}
	var idNivelY:String = xmlDimY.item(0).toElement().attribute("Id");

	var tipoMapa:String = this.iface.dameTipo2dMapa();
	if (!tipoMapa) {
		this.iface.mostrarErrorGrafico(util.translate("scripts", "El nivel Y no es representable en un mapa"), marco);
		return false;
	}

// 	var nodoY:FLDomNode = xmlPos.namedItem("Dimensiones").namedItem("Y");
// 	var nodosNivelY:FLDomNodeList = nodoY.childNodes();
// 	if (nodosNivelY.count() != 1) {
// 		this.iface.mostrarErrorGrafico2(util.translate("scripts", "Debe indicar un nivel para el eje Y"));
// 		return false;
// 	}
	var nodoNivelY:FLDomNode = nodoY.namedItem("Nivel");
	
	var idMedida:String = nodoMedida.toElement().attribute("Id");
	var idNivelY:String = nodoNivelY.toElement().attribute("Id");
debug("idNivelY = " + idNivelY);

	var eValor:FLDomElement;
	var eDato:FLDomElement;
	var valor:Number;
	var total:Number = 0;
	var iValor:Number = 0;
	for (var nodoDato:FLDomNode = xmlDat.firstChild(); nodoDato; nodoDato = nodoDato.nextSibling()) {
		eDato = nodoDato.toElement();
		eValor = this.iface.xmlGrafico_.createElement("Valor");
		eValores.appendChild(eValor);
		eValor.setAttribute("IdPos", eDato.attribute(idNivelY));
		eValor.setAttribute("Nombre", this.iface.obtenerDesNivel(idNivelY, eDato.attribute(idNivelY)));
		valor = parseFloat(eDato.attribute(idMedida));
		eValor.setAttribute("Valor", valor);
		total += valor;
		iValor++;
	}
	eValores.setAttribute("NumValores", iValor);

	pic = flgraficos.iface.pub_dibujarGrafico(this.iface.xmlGrafico_, marco);
	return pic;
/*
// debug(this.iface.xmlGrafico_.toString(4));
	var pic:Picture = flfactinfo.iface.pub_dibujarGrafico(this.iface.xmlGrafico_);
	if (!pic) {
		this.iface.mostrarErrorGrafico2(util.translate("scripts", "Error al construir el gráfico"), contenedor);
// 		MessageBox.warning(util.translate("scripts", "Error al construir el gráfico"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var ancho:Number = parseInt(eGrafico.attribute("Ancho"));
	var alto:Number = parseInt(eGrafico.attribute("Alto"));
debug(pic);
	var clr = new Color();
	var lblPix = (contenedor ? contenedor : this.child( "lblGrafico" ));
	var pix = new Pixmap();
// 	var devSize = this.child( "lblGrafico" ).size;//new Size(ancho, alto);
	var devSize = (marco ? marco.size : new Size(500, 395));
	pix.resize( devSize );
	clr.setRgb( 255, 255, 255 );
	pix.fill( clr );
	lblPix.pixmap = pix;

	var contenido:String = util.sqlSelect("i_ficheros", "imagen", "nombre = 'i_provincias_es.jpg'");
	if (!contenido) {
		MessageBox.warning(util.translate("scripts", "No tiene cargado el fichero i_paises_eu.jpg.\nEste fichero es necesario para representar el gráfico de paises."), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	File.write("i_provincias_es.xpm", contenido);
	pix.load("i_provincias_es.xpm");

	pix = pic.playOnPixmap( pix );
	lblPix.pixmap = pix;
	pic.end();*/
}

/** \D Busca, a partir del tipo de dimensión del nivel Y de la posición actual, qué tipo de mapa debe usarse para representar la posición.
@return	Tipo de mapa. False si la posición no es representable en un mapa
\end */
function oficial_dameTipo2dMapa():String
{
	var util:FLUtil = new FLUtil;
	var tipoMapa:String = false;
	var xmlPos:FLDomNode = this.iface.xmlPosActual_.firstChild();
	var nodoY:FLDomNode = xmlPos.namedItem("Dimensiones").namedItem("Y");
	var xmlDimY:FLDomNodeList = nodoY.childNodes();
	if (!xmlDimY || xmlDimY.length() != 1) {
		return false;
	}
	var idNivelY:String = xmlDimY.item(0).toElement().attribute("Id");
	switch(idNivelY) {
		case "provincia..provincia": {
			tipoMapa = "provincias";
			break;
		}
		case "pais..pais": {
			tipoMapa = "paises";
			break;
		}
	}
	return tipoMapa;
}

function oficial_dibujar2dMapaPaises(contenedor:Object, marco:Rect):Boolean
{
debug("oficial_dibujar2dMapaPaises");
	var util:FLUtil = new FLUtil;

	if (!this.iface.xmlGrafico_) {
		this.iface.construir2dMapaPaisesDefecto(contenedor, marco);
	} else {
		if (this.iface.xmlGrafico_.firstChild().toElement().attribute("Tipo") != "2d_mapaproves") {
			this.iface.construir2dMapaPaisesDefecto(contenedor, marco);
		}
	}

	var eGrafico:FLDomElement = this.iface.xmlGrafico_.firstChild().toElement();
	var devSize = (contenedor ? contenedor.size : this.child( "lblGrafico" ).size);
	eGrafico.setAttribute("Alto", devSize.height);
	eGrafico.setAttribute("Ancho", devSize.width);

	var eValores:FLDomElement = this.iface.xmlGrafico_.firstChild().namedItem("Valores").toElement();
	this.iface.xmlGrafico_.firstChild().removeChild(eValores);
	eValores = this.iface.xmlGrafico_.createElement("Valores");
	eGrafico.appendChild(eValores);

	var xmlPos:FLDomNode = this.iface.xmlPosActual_.firstChild();
	var xmlDat:FLDomNode = this.iface.xmlDatos_.firstChild();
// debug(this.iface.xmlDatos_.toString(4));

	var nodoMedida:FLDomNode = xmlPos.namedItem("Medidas").namedItem("Medida");
	if (!nodoMedida) {
		this.iface.mostrarErrorGrafico2(util.translate("scripts", "Debe indicar una medida a representar"), contenedor);
		return false;
	}

	var nodoX:FLDomNode = xmlPos.namedItem("Dimensiones").namedItem("X");
	var xmlDimX:FLDomNodeList = nodoX.childNodes();
	if (xmlDimX && xmlDimX.length() > 0) {
		this.iface.mostrarErrorGrafico2(util.translate("scripts", "No debe haber niveles en el eje X"), contenedor);
		return false;
	}

	var nodoY:FLDomNode = xmlPos.namedItem("Dimensiones").namedItem("Y");
	var xmlDimY:FLDomNodeList = nodoY.childNodes();
	if (!xmlDimY || xmlDimY.length() != 1) {
		this.iface.mostrarErrorGrafico2(util.translate("scripts", "Debe haber un único nivel (país) en el eje Y"), contenedor);
		return false;
	}
	if (xmlDimY.item(0).toElement().attribute("Id") != "pais..pais") {
		this.iface.mostrarErrorGrafico2(util.translate("scripts", "Debe haber un único nivel (país) en el eje Y"), contenedor);
		return false;
	}

	var nodoY:FLDomNode = xmlPos.namedItem("Dimensiones").namedItem("Y");
	var nodosNivelY:FLDomNodeList = nodoY.childNodes();
	if (nodosNivelY.count() != 1) {
		this.iface.mostrarErrorGrafico2(util.translate("scripts", "Debe indicar un nivel para el eje Y"));
		return false;
	}
	var nodoNivelY:FLDomNode = nodoY.namedItem("Nivel");
	
	var idMedida:String = nodoMedida.toElement().attribute("Id");
	var idNivelY:String = nodoNivelY.toElement().attribute("Id");
debug("idNivelY = " + idNivelY);

	var eValor:FLDomElement;
	var eDato:FLDomElement;
	var valor:Number;
	var total:Number = 0;
	var iValor:Number = 0;
	for (var nodoDato:FLDomNode = xmlDat.firstChild(); nodoDato; nodoDato = nodoDato.nextSibling()) {
		eDato = nodoDato.toElement();
		eValor = this.iface.xmlGrafico_.createElement("Valor");
		eValores.appendChild(eValor);
		eValor.setAttribute("Pais", eDato.attribute(idNivelY));
		valor = parseFloat(eDato.attribute(idMedida));
		eValor.setAttribute("Valor", valor);
		total += valor;
		iValor++;
	}
	eValores.setAttribute("NumValores", iValor);

// debug(this.iface.xmlGrafico_.toString(4));
	var pic:Picture = flfactinfo.iface.pub_dibujarGrafico(this.iface.xmlGrafico_);
	if (!pic) {
		this.iface.mostrarErrorGrafico2(util.translate("scripts", "Error al construir el gráfico"), contenedor);
// 		MessageBox.warning(util.translate("scripts", "Error al construir el gráfico"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var ancho:Number = parseInt(eGrafico.attribute("Ancho"));
	var alto:Number = parseInt(eGrafico.attribute("Alto"));
debug(pic);
	var clr = new Color();
	var lblPix = (contenedor ? contenedor : this.child( "lblGrafico" ));
	var pix = new Pixmap();
// 	var devSize = this.child( "lblGrafico" ).size;//new Size(ancho, alto);
	var devSize = (marco ? marco.size : new Size(500, 395));
	pix.resize( devSize );
	clr.setRgb( 255, 255, 255 );
	pix.fill( clr );
	lblPix.pixmap = pix;

	var contenido:String = util.sqlSelect("i_ficheros", "imagen", "nombre = 'i_paises_eu.jpg'");
	if (!contenido) {
		MessageBox.warning(util.translate("scripts", "No tiene cargado el fichero i_paises_eu.jpg.\nEste fichero es necesario para representar el gráfico de paises."), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	File.write("i_paises_eu.xpm", contenido);
	pix.load("i_paises_eu.xpm");

	pix = pic.playOnPixmap( pix );
	lblPix.pixmap = pix;
	pic.end();
}

function oficial_establecerAnos()
{
	this.iface.anoMax_ = fldireinne.iface.pub_valorConfiguracion("anomax");
	this.iface.anoMin_ = fldireinne.iface.pub_valorConfiguracion("anomin");
}

function oficial_cargarDatos():Boolean
{
// debug("Cargando tabla para posición:\n\n" + this.iface.xmlPosActual_.toString(4));
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	var xmlPos:FLDomNode = this.iface.xmlPosActual_.firstChild();
	
	var eY:FLDomElement = xmlPos.namedItem("Dimensiones").namedItem("Y");
	var totalNivelesY:Number = 0;
	var aNivelesY:Array = [];
	for (var nodoNivelY:FLDomNode = eY.firstChild(); nodoNivelY; nodoNivelY = nodoNivelY.nextSibling()) {
		if (nodoNivelY.nodeName() != "Nivel") {
			continue;
		}
		aNivelesY[totalNivelesY] = nodoNivelY;
		totalNivelesY++;
	}

	var eX:FLDomElement = xmlPos.namedItem("Dimensiones").namedItem("X");
	var totalNivelesX:Number = 0;
	var aNivelesX:Array = [];
	for (var nodoNivelX:FLDomNode = eX.firstChild(); nodoNivelX; nodoNivelX = nodoNivelX.nextSibling()) {
		if (nodoNivelX.nodeName() != "Nivel") {
			continue;
		}
		aNivelesX[totalNivelesX] = nodoNivelX;
		totalNivelesX++;
	}

	var qryTabla:FLSqlQuery = this.iface.construirConsulta();
	if (!qryTabla) {
		return false;
	}
	
	var hipercubo:String = this.iface.cubo_;
	delete this.iface.xmlDatos_;
	this.iface.xmlDatos_ = new FLDomDocument;
	this.iface.xmlDatos_.setContent("<Datos/>");
	
	debug("Consulta = " + qryTabla.sql());
	if (!qryTabla.exec()) {
		return false;
	}

	var eRow:FLDomElement;
	var valor:Number;
	var idNivel:String;
	if (this.iface.elementosY_) {
		delete this.iface.elementosY_;
	}
	this.iface.elementosY_ = [];
	if (this.iface.iElementosY_) {
		delete this.iface.iElementosY_;
	}
	this.iface.iElementosY_ = [];
	var idCombi:String;
	var iCombX:Number = 0; /// Combinaciones de elementos X
	var iCombY:Number = 0; /// Combinaciones de elementos Y
	var valorNivel:String;
	var nombreMedida:String;
	var campoMedida:String
	while (qryTabla.next()) {
		eRow = this.iface.xmlDatos_.createElement("Row");
		idCombi = "";
		for (var i:Number = 0; i < totalNivelesY; i++) {
			idNivel = aNivelesY[i].toElement().attribute("Id");
			valorNivel = qryTabla.value(this.iface.dameColumnaSql(idNivel));
			eRow.setAttribute(idNivel, valorNivel);
			idCombi += (idCombi == "" ? valorNivel : "%$&" + valorNivel);
		}
		try { this.iface.elementosY_[idCombi]; } catch (e) {
			this.iface.elementosY_[idCombi] = iCombY;
			this.iface.iElementosY_[iCombY] = idCombi;
			iCombY++;
		}
		
		for (var i:Number = 0; i < totalNivelesX; i++) {
			idNivel = aNivelesX[i].toElement().attribute("Id");
			eRow.setAttribute(idNivel, qryTabla.value(this.iface.dameColumnaSql(idNivel)));
		}
		for (var i:Number = 0; i < this.iface.iMedidas_.length; i++) {
			nombreMedida = this.iface.iMedidas_[i];
			campoMedida = this.iface.medidas_[nombreMedida]["element"].attribute("column");
			valor = qryTabla.value(this.iface.dameColumnaAgregadaSql(nombreMedida));
			valor = util.roundFieldValue(valor, this.iface.cubo_, campoMedida);
			eRow.setAttribute(this.iface.iMedidas_[i], valor); /// eliminado al poner la nueva formatearValorMedida this.iface.formatearValorMedida(this.iface.iMedidas_[i], valor));
		}
		this.iface.xmlDatos_.firstChild().appendChild(eRow);
	}
for (i = 0; i < iCombY; i++) {
	debug("iElementosY[" + i + "] = " + this.iface.iElementosY_[i]);
	debug("elementosY[" + this.iface.iElementosY_[i] + "] = " + this.iface.elementosY_[this.iface.iElementosY_[i]]);
}
// 	debug(this.iface.xmlDatos_.toString(4));
	return true;
}

/** \D Muestra los datos de la consulta en el formato que el usuario desee visualizar
\end */
function oficial_mostrarDatos()
{
	switch (this.iface.interfazDatos_) {
		case "TABLA": {
			if (this.iface.tablaMostrada_) {
				break;
			}
			this.iface.tipoGrafico_ = "2d_tabla";
			if (!this.iface.tablaCargada_) {
				this.iface.cargarDatosTabla();
			}
			this.iface.crearTabla();
			this.iface.tablaMostrada_ = true;
			this.iface.tablaCargada_ = true;
			break;
		}
		case "GRAFICO": {
			if (this.iface.graficoMostrado_) {
				break;
			}
			switch (this.iface.tipoGrafico_) {
				case "2d_barras": {
					this.iface.mostrarGrafico("2d_barras");
					break;
				}
				case "lineal": {
					this.iface.mostrarGrafico("lineal");
					break;
				}
				case "2d_tabla": {
					this.iface.mostrarGrafico("2d_tabla");
					this.iface.tablaCargada_ = true;
					break;
				}
				case "2dtarta": {
					this.iface.mostrarGrafico("2dtarta");
					break;
				}
				case "1daguja": {
					this.iface.mostrarGrafico("1daguja");
// 					this.iface.mostrar1dAguja();
					break;
				}
				case "2d_mapa": {
					this.iface.mostrarGrafico("2d_mapa");
					break;
				}
				case "2d_mapapaiseseu": {
					this.iface.dibujar2dMapaPaises();
					break;
				}
				default: {
					this.iface.tipoGrafico_ = "2d_barras";
					this.iface.mostrarGrafico("2d_barras");
					break;
				}
			}
			this.iface.graficoMostrado_ = true;
			break;
		}
		case "INFORME": {
			if (this.iface.informeMostrado_) {
				break;
			}
			if (!this.iface.tablaCargada_) {
				this.iface.cargarDatosTabla();
			}
			this.iface.mostrarInforme();
			this.iface.informeMostrado_ = true;
			this.iface.tablaCargada_ = true;
			break;
		}
	}
}

function oficial_mostrarGrafico()
{
	var devSize = this.child( "lblGrafico" ).size;
	var marco:Rect = new Rect(0, 0, devSize.width, devSize.height);
	var pic:Picture = false
	var idTipoG:String = this.iface.tipoGrafico_;
	if (!idTipoG) {
		return false;
	}
	var iGrafico:Number = this.iface.dameIndiceTipoGrafico(idTipoG);

	if (!this.iface.cachePicGraficos_[iGrafico]["pic"]) {
		this.iface.cachePicGraficos_[iGrafico]["pic"] = this.iface.dibujarGrafico(marco);
	}
	if (!this.iface.cachePicGraficos_[iGrafico]["pic"]) {
		return false;
	}
	
	var clr = new Color();
	clr.setRgb( 255, 255, 255 );
	var lblPix = this.child( "lblGrafico" );
	var pix = new Pixmap();
	pix.resize( devSize );
	pix.fill( clr );
	pix = this.iface.cachePicGraficos_[iGrafico]["pic"].playOnPixmap( pix );
	lblPix.pixmap = pix;
// 	pic.end();
}

/** \D Busca un elemento en el array global de gráficos que coincida con el tipo indicado. Si no lo encuentra lo crea
@param	idTipoG: Tipo de gráfico
@return	Índice en el array
\end */
function oficial_dameIndiceTipoGrafico(idTipoG:String):Number
{
	if (!this.iface.cachePicGraficos_) {
		this.iface.cachePicGraficos_ = [];
	}
	var i:Number;
	for (i = 0; i < this.iface.cachePicGraficos_.length; i++) {
		if (this.iface.cachePicGraficos_[i]["tipo"] == idTipoG) {
			break;
		}
	}
	if (i == this.iface.cachePicGraficos_.length) {
		this.iface.cachePicGraficos_[i] = [];
		this.iface.cachePicGraficos_[i]["tipo"] = idTipoG;
		this.iface.cachePicGraficos_[i]["pic"] = false;
	}
	return i;
}

/** \D Borra de la cache de gráficos el tipo indicado o todos si no se indica tipo
@param	idTipoG: Tipo a borrar
\end */
function oficial_borraGraficoCache(idTipoG:String):Boolean
{
	if (!this.iface.cachePicGraficos_) {
		return true;
	}
	var i:Number;
	for (i = 0; i < this.iface.cachePicGraficos_.length; i++) {
		if (!idTipoG || idTipoG == this.iface.cachePicGraficos_[i]["tipo"]) {
			if (this.iface.cachePicGraficos_[i]["pic"]) {
				this.iface.cachePicGraficos_[i]["pic"].end();
				this.iface.cachePicGraficos_[i]["pic"] = false;
			}
		}
	}
	return true;
}


function oficial_mostrarInforme()
{
	if (!this.iface.xmlReportTemplate_) {
		if (!this.iface.cargarFormatoInforme()) {
			return false;
		}
	}
	this.iface.generarInforme();
}

function oficial_dibujarGrafico(marco:Rect):Picture
{
	var util:FLUtil = new FLUtil;
	
	if (!this.iface.xmlGrafico_) {
		if (!this.iface.cargarFormatoGrafico()) {
			return false;
		}
	} else {
		if (this.iface.xmlGrafico_.firstChild().toElement().attribute("Tipo") != this.iface.tipoGrafico_) {
			if (!this.iface.cargarFormatoGrafico()) {
				return false;
			}
		}
	}
	debug("this.iface.xmlGrafico_ " + this.iface.xmlGrafico_.toString(4));
	var pic:Picture;
	debug("this.iface.tipoGrafico_ " + this.iface.tipoGrafico_);
	switch (this.iface.tipoGrafico_) {
		case "2d_barras": {
			pic = this.iface.dibujar2dBarras(marco);
			break;
		}
		case "2d_tabla": {
			if (!this.iface.tablaCargada_) {
				this.iface.cargarDatosTabla();
			}
			pic = this.iface.dibujar2dTabla(marco);
			break;
		}
		case "lineal": {
			pic = this.iface.dibujar2dBarras(marco);
			/// Se usa la misma funcion para los graficos 2d_barras y lineal porque en principio tiene las mismas comprobaciones. Si fuera necesario realizar alguna comprobación distinta para alguno de los dos habría que crear dos funciones distintas.
			break;
		}
		case "1daguja": {
			pic = this.iface.dibujar1dAguja(marco);
			break;
		}
		case "2dtarta": {
			pic = this.iface.dibujar2dTarta(marco);
			break;
		}
		case "2d_mapa": {
			pic = this.iface.dibujar2dMapa(marco);
			break;
		}
		default: {
			MessageBox.warning(util.translate("scripts", "No se puede dibujar el gráfico %1").arg(this.iface.tipoGrafico_), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}
	return pic;
}

// function oficial_mostrar2dBarras()
// {
// 	if (!this.iface.xmlGrafico_) {
// 		if (!this.iface.cargarFormatoGrafico()) {
// 			return false;
// 		}
// 	} else {
// 		if (this.iface.xmlGrafico_.firstChild().toElement().attribute("Tipo") != "2d_barras") {
// 			if (!this.iface.cargarFormatoGrafico()) {
// 				return false;
// 			}
// 		}
// 	}
// 	this.iface.dibujar2dBarras();
// }

function oficial_mostrar2dTarta()
{
debug("oficial_mostrar2dTarta");
	if (!this.iface.xmlGrafico_) {
		this.iface.construir2dTartaDefecto();
	} else {
		if (this.iface.xmlGrafico_.firstChild().toElement().attribute("Tipo") != "2d_tarta") {
			this.iface.construir2dTartaDefecto();
		}
	}
	this.iface.dibujar2dTarta();
}

function oficial_mostrar1dAguja()
{
debug("oficial_mostrar1dAguja");
	if (!this.iface.xmlGrafico_) {
		this.iface.construir1dAgujaDefecto();
	} else {
		if (this.iface.xmlGrafico_.firstChild().toElement().attribute("Tipo") != "1daguja") {
			this.iface.construir1dAgujaDefecto();
		}
	}
	this.iface.dibujar1dAguja();
}

// function oficial_mostrarTabla()
// {
// 	var xmlPos:FLDomNode = this.iface.xmlPosActual_.firstChild();
// 	
// 	var ejeMedidas:String = xmlPos.namedItem("Medidas").toElement().attribute("Eje");
// 
// 	var eY:FLDomElement = xmlPos.namedItem("Dimensiones").namedItem("Y");
// 	var totalNivelesY:Number = 0;
// 	this.iface.nivelesY_  = [];
// 	for (var nodoNivelY:FLDomNode = eY.firstChild(); nodoNivelY; nodoNivelY = nodoNivelY.nextSibling()) {
// 		if (nodoNivelY.nodeName() != "Nivel") {
// 			continue;
// 		}
// 		this.iface.nivelesY_[totalNivelesY] = nodoNivelY.toElement().attribute("Id");
// 		totalNivelesY++;
// 	}
// 	if (totalNivelesY == 0) {
// 		this.iface.nivelesY_ = ["sin niveles"];
// 	}
// 
// 	var eX:FLDomElement = xmlPos.namedItem("Dimensiones").namedItem("X");
// 	var totalNivelesX:Number = 0;
// 	this.iface.nivelesX_  = [];
// 	for (var nodoNivelX:FLDomNode = eX.firstChild(); nodoNivelX; nodoNivelX = nodoNivelX.nextSibling()) {
// 		if (nodoNivelX.nodeName() != "Nivel") {
// 			continue;
// 		}
// 		this.iface.nivelesX_[totalNivelesX] = nodoNivelX.toElement().attribute("Id");
// 		totalNivelesX++;
// 	}
// 	if (totalNivelesX == 0) {
// 		this.iface.nivelesX_  = ["sin niveles"];
// 	}
// 
// 	var totalNiveles:Number = totalNivelesY + totalNivelesX;
// 	if (totalNiveles > 0) {
// 		this.iface.nivelesTabla_ = new Array(totalNiveles);
// 		var n:Number = 0;
// 		for (var i:Number = 0; i < totalNivelesY; i++) {
// 			this.iface.nivelesTabla_[n] = this.iface.nivelesY_[i];
// 			n++;
// 		}
// 		for (var i:Number = 0; i < totalNivelesX; i++) {
// 			this.iface.nivelesTabla_[n] = this.iface.nivelesX_[i];
// 			n++;
// 		}
// 	} else {
// 		this.iface.nivelesTabla_ = ["sin niveles"];
// 	}
// 
// 	var tblDatos:Object = this.child("tblDatos");
// 	tblDatos.setNumCols(0);
// 	tblDatos.setNumRows(0);
// 
// 	var eMedidas:FLDomElement = xmlPos.namedItem("Medidas");
// 	var totalMedidas:Number = 0;
// 	this.iface.medidasTabla_ = [];
// 	for (var nodoMedida:FLDomNode = eMedidas.firstChild(); nodoMedida; nodoMedida = nodoMedida.nextSibling()) {
// 		if (nodoMedida.nodeName() != "Medida") {
// 			continue;
// 		}
// 		this.iface.medidasTabla_[totalMedidas] = nodoMedida.toElement().attribute("Id");
// 		totalMedidas++;
// 	}
// 	if (totalMedidas == 0) {
// 		return false;
// 	}
// 
// 	var totalColsOffset:Number = (ejeMedidas == "X" ? 1 : 2);
// 	tblDatos.setNumCols(totalColsOffset);
// 
// 	var totalFilOffset:Number = (ejeMedidas == "X" ? 2 : 1);
// 	for (var i:Number = 0; i < totalFilOffset; i++) {
// 		this.iface.crearFilaDatos(i);
// 	}
// 
// 	if (this.iface.nivelesY_[0] == "sin niveles") {
// 		tblDatos.hideColumn(this.iface.DAT_C_CABECERA_);
// 	}
// 	if (ejeMedidas == "Y" && totalMedidas == 1) {
// // 		tblDatos.hideColumn(this.iface.DAT_C_CABECERA_ + 1);
// 		tblDatos.hideColumn(this.iface.DAT_C_MEDIDA_);
// 	}
// 	if (this.iface.nivelesX_[0] == "sin niveles") {
// 		tblDatos.hideRow(this.iface.DAT_F_CABECERA_);
// 	}
// 	if (ejeMedidas == "X" && totalMedidas == 1) {
// // 		tblDatos.hideRow(this.iface.DAT_F_CABECERA_ + 1);
// 		tblDatos.hideRow(this.iface.DAT_F_MEDIDA_);
// 	}
// 
// 	this.iface.crearCabeceraCol();
// 
// 	var totalCols:Number = tblDatos.numCols();
// 
// 	var nodoDatos:FLDomNode = this.iface.xmlDatos_.firstChild();
// 	var eRow:FLDomElement;
// 	var iFila:Number = totalFilOffset;
// 	
// 	var iCol:Number = totalColsOffset;
// 	
// 	var aValorAnterior:Array = new Array(this.iface.nivelesTabla_.length);
// 	var aEspacios:Array = new Array(this.iface.nivelesTabla_.length);
// 	var aAcumulado:Array = new Array(this.iface.nivelesTabla_.length);
// 
// 	for (var i:Number = 0; i < aValorAnterior.length; i++) {
// 		aValorAnterior[i] = "";
// 		if (i < totalNivelesY) {
// 			(i == 0 ? aEspacios[i] = "" : aEspacios[i] = aEspacios[i - 1] + "  ")
// 		}
// 		aAcumulado[i] = [];
// 		for (var m:Number = 0; m < totalMedidas; m++) {
// 			aAcumulado[i][this.iface.medidasTabla_[m]] = 0;
// 		}
// 		aAcumulado[i]["fila"] = 0;
// 		aAcumulado[i]["col"] = 0;
// 	}
// 	var maxNivelY:Number = this.iface.nivelesY_.length - 1;
// 	var maxNivelX:Number = this.iface.nivelesX_.length - 1;
// 	var maxNivel:Number = this.iface.nivelesTabla_.length - 1;
// 	var nivelActual:Number = 0;
// 	var nivelRotura:Number = 0;
// 	var valorAcumulado:Number;
// 	var claveColumnaX:String;
// 	var idMedida:String;
// 
// 	delete this.iface.aTabla_;
// 	this.iface.aTabla_ = [];
// 	var aTabla:Array = this.iface.aTabla_;
// 	if (this.iface.aFilasTabla_) {
// 		delete this.iface.aFilasTabla_;
// 	}
// 	this.iface.aFilasTabla_ = [];
// 	for (var i:Number = 0; i < iFila; i++) {
// 		this.iface.aFilasTabla_[i]= [];
// 		this.iface.aFilasTabla_[i]["nivel"]= 0;
// 		this.iface.aFilasTabla_[i]["idmedida"]= false;
// 	}
// 	
// 	if (totalNivelesY == 0) {
// 		if (ejeMedidas == "X") {
// 			idMedida = false;
// 			this.iface.crearFilaDatos(iFila);
// 			aTabla[iFila] = new Array(totalCols);
// 			for (var c:Number = 0; c < totalCols; c++) { aTabla[iFila][c] = 0; }
// 			this.iface.aFilasTabla_[iFila] = this.iface.dameElementoArrayFilas(iFila);
// 			this.iface.dameCabeceraFila(iFila);
// 			iFila++;
// 		} else {
// 			for (var m:Number = 0; m < totalMedidas; m++) {
// 				idMedida = this.iface.medidasTabla_[m],
// 				this.iface.crearFilaDatos(iFila + m);
// 				aTabla[iFila + m] = new Array(totalCols);
// 				for (var c:Number = 0; c < totalCols; c++) { aTabla[iFila + m][c] = 0; }
// 				tblDatos.setText(iFila + m, this.iface.DAT_C_MEDIDA_, this.iface.dameAliasMedida(idMedida));
// 				this.iface.aFilasTabla_[iFila + m] = this.iface.dameElementoArrayFilas(iFila);
// 				this.iface.aFilasTabla_[iFila + m]["idmedida"] = idMedida;
// 				this.iface.dameCabeceraFila(iFila + m);
// 			}
// 			iFila += totalMedidas;
// 		}
// 	}
// 	var iFilaMedida:Number;
// 	var valor:Number;
// 	var valorF:String;
// 	var colorCeldaValor:Color;
// 	for (var nodoRow:FLDomNode = nodoDatos.firstChild(); nodoRow; nodoRow = nodoRow.nextSibling()) {
// 		eRow = nodoRow.toElement();
// 		nivelRotura = -1;
// 		for (var i:Number = 0; i <= maxNivel; i++) {
// 			if (nivelRotura== -1 && eRow.attribute(this.iface.nivelesTabla_[i]) != aValorAnterior[i]) {
// 				nivelRotura = i;
// 			}
// 			aValorAnterior[i] = eRow.attribute(this.iface.nivelesTabla_[i]);
// 		}
// 		/// Dibujar filas de niveles cabecera
// 		if (nivelRotura >= 0 && nivelRotura < totalNivelesY) {
// 			for (var n:Number = nivelRotura; n <= maxNivelY; n++) {
// 				if (ejeMedidas == "X") {
// 					idMedida = false;
// 					this.iface.crearFilaDatos(iFila);
// 					aTabla[iFila] = new Array(totalCols);
// 					for (var c:Number = 0; c < totalCols; c++) { aTabla[iFila][c] = 0; }
// 					this.iface.aFilasTabla_[iFila] = this.iface.dameElementoArrayFilas();
// 					this.iface.aFilasTabla_[iFila]["idmedida"] = idMedida;
// 					this.iface.aFilasTabla_[iFila]["nivel"] = n;
// 					this.iface.aFilasTabla_[iFila]["expande"] = (n == maxNivelY ? "" : "S");
// 					this.iface.aFilasTabla_[iFila]["clave"] = eRow.attribute(this.iface.nivelesTabla_[n]);
// 					this.iface.dameCabeceraFila(iFila);
// 				} else {
// 					for (var m:Number = 0; m < totalMedidas; m++) {
// 						idMedida = this.iface.medidasTabla_[m];
// 						this.iface.crearFilaDatos(iFila + m);
// 						aTabla[iFila + m] = new Array(totalCols);
// 						for (var c:Number = 0; c < totalCols; c++) { aTabla[iFila + m][c] = 0; }
// 						tblDatos.setText(iFila + m, this.iface.DAT_C_MEDIDA_, this.iface.dameAliasMedida(idMedida));
// 						
// 						this.iface.aFilasTabla_[iFila + m] = this.iface.dameElementoArrayFilas();
// 						this.iface.aFilasTabla_[iFila + m]["idmedida"] = idMedida;
// 						this.iface.aFilasTabla_[iFila + m]["nivel"] = n;
// 						this.iface.aFilasTabla_[iFila + m]["expande"] = (n == maxNivelY ? "" : "S");
// 						this.iface.aFilasTabla_[iFila + m]["clave"] = eRow.attribute(this.iface.nivelesTabla_[n]);
// 						this.iface.dameCabeceraFila(iFila + m);
// 					}
// 				}
// 				iFila += (ejeMedidas == "X" ? 1 : totalMedidas);
// 			}
// 		}
// 
// 		/// Dibujar filas de valores
// 		claveColumnaX = this.iface.dameClaveColumnaX(totalNiveles - totalNivelesY - 1, eRow);
// 		if (claveColumnaX !=  "") {
// 			iCol = this.iface.columnasClaveX_[claveColumnaX];
// 		}
// 		if (ejeMedidas == "X") {
// 			for (var m:Number = 0; m < totalMedidas; m++) {
// 				idMedida = this.iface.medidasTabla_[m];
// 				valor = eRow.attribute(idMedida);
// 				valorF = this.iface.formatearValorMedida(valor, idMedida);
// 				iFilaMedida = iFila - 1;
// 				aTabla[iFilaMedida][(iCol + m)] = [];
// 				aTabla[iFilaMedida][(iCol + m)]= valor;
// 				tblDatos.setText(iFilaMedida, (iCol + m), valorF);
// 				colorCeldaValor = this.iface.colorValorObjetivo(idMedida, valor);
// 				if (colorCeldaValor) {
// 					tblDatos.setCellBackgroundColor(iFilaMedida, (iCol + m), colorCeldaValor);
// 				}
// 				tblDatos.setCellAlignment(iFilaMedida, (iCol + m), tblDatos.AlignRight);
// 			}
// 		} else {
// 			for (var m:Number = 0; m < totalMedidas; m++) {
// 				idMedida = this.iface.medidasTabla_[m];
// 				valor = eRow.attribute(idMedida);
// 				valorF = this.iface.formatearValorMedida(valor, idMedida);
// 				iFilaMedida = iFila - totalMedidas + m;
// 				aTabla[iFilaMedida][iCol] = [];
// 				aTabla[iFilaMedida][iCol]= valor;
// 				tblDatos.setText(iFilaMedida, iCol, valorF);
// 				colorCeldaValor = this.iface.colorValorObjetivo(idMedida, valor);
// 				if (colorCeldaValor) {
// 					tblDatos.setCellBackgroundColor(iFilaMedida, iCol, colorCeldaValor);
// 				}
// 				tblDatos.setCellAlignment(iFilaMedida, iCol, tblDatos.AlignRight);
// 			}
// 		}
// 	}
// 	var acumulado:Number;
// 	var sigNivelX:Number = 0;
// 	var colAcum:Number;
// 	var incrementoCol:Number = (ejeMedidas == "X" ? totalMedidas : 1);
// 	var valorF:String;
// 	var funAgregacion:String;
// 	var idMedida:String;
// 	for (var nX:Number = (maxNivelX - 1); nX >= 0 ; nX--) {
// 		for (var col:Number = totalColsOffset; col < tblDatos.numCols() ; col++) {
// 			if (this.iface.aColumnasTabla_[col]["nivel"] != nX) {
// 				continue;
// 			}
// 			sigNivelX = nX + 1;
// 			for (var m:Number = 1; m <= incrementoCol; m++) {
// 				col += (m - 1);
// 				for (var fil:Number = totalFilOffset; fil < tblDatos.numRows() ; fil++) {
// 					acumulado = 0;
// 					colAcum = col + incrementoCol;
// 					if (ejeMedidas == "X") {
// 						idMedida = this.iface.aColumnasTabla_[col]["idmedida"];
// 					} else {
// 						idMedida = this.iface.aFilasTabla_[fil]["idmedida"];
// 					}
// 					while (colAcum < tblDatos.numCols() && this.iface.aColumnasTabla_[colAcum]["nivel"] >= sigNivelX) {
// 						if (this.iface.aColumnasTabla_[colAcum]["nivel"] > sigNivelX) {
// 							colAcum += incrementoCol;
// 							continue;
// 						}
// 						acumulado += parseFloat(aTabla[fil][colAcum]);
// 						colAcum += incrementoCol;
// 					}
// 					valorF = this.iface.formatearValorMedida(acumulado, idMedida);
// 					funAgregacion = this.iface.dameSqlAgregacion(idMedida);
// 					if (funAgregacion == "AVG") {
// 						valorF = "";
// 					}
// 					tblDatos.setText(fil, col, valorF);
// 					tblDatos.setCellAlignment(fil, col, tblDatos.AlignRight);
// 					aTabla[fil][col] = acumulado;
// 				}
// 			}
// 		}
// 	}
// 	
// 	var sigNivelY:Number = 0;
// 	var filAcum:Number;
// 	var incrementoFila:Number = (ejeMedidas == "X" ? 1 : totalMedidas);
// 	for (var nY:Number = (maxNivelY - 1); nY >= 0 ; nY--) {
// 		for (var fil:Number = totalFilOffset; fil < tblDatos.numRows() ; fil++) {
// 			if (this.iface.aFilasTabla_[fil]["nivel"] != nY) {
// 				continue;
// 			}
// 			sigNivelY = nY + 1;
// 			for (var m:Number = 1; m <= incrementoFila; m++) {
// 				fil += (m - 1);
// 				for (var col:Number = totalColsOffset; col < tblDatos.numCols() ; col++) {
// 					acumulado = 0;
// 					filAcum = fil + incrementoFila;
// 					if (ejeMedidas == "X") {
// 						idMedida = this.iface.aColumnasTabla_[col]["idmedida"];
// 					} else {
// 						idMedida = this.iface.aFilasTabla_[fil]["idmedida"];
// 					}
// 					while (filAcum < tblDatos.numRows() && this.iface.aFilasTabla_[filAcum]["nivel"] >= sigNivelY) {
// 						if (this.iface.aFilasTabla_[filAcum]["nivel"] > sigNivelY) {
// 							filAcum += incrementoFila;
// 							continue;
// 						}
// 						acumulado += parseFloat(aTabla[filAcum][col]);
// 						filAcum += incrementoFila;
// 					}
// 					valorF = this.iface.formatearValorMedida(acumulado, idMedida);
// 					funAgregacion = this.iface.dameSqlAgregacion(idMedida);
// 					if (funAgregacion == "AVG") {
// 						valorF = "";
// 					}
// 					tblDatos.setText(fil, col, valorF);
// 					tblDatos.setCellAlignment(fil, col, tblDatos.AlignRight);
// 					aTabla[fil][col] = acumulado;
// 				}
// 			}
// 		}
// 	}
// 	for (var c:Number = 0; c < totalCols; c++) {
// 		if (this.iface.aColumnasTabla_[c]["nivel"] < maxNivelX) {
// 			this.iface.cambiarColorColumnaTabla(tblDatos, c, this.iface.colorDatTotal_);
// 		}
// 		tblDatos.adjustColumn(c);
// 	}
// 	this.iface.borrarCabecerasTabla(tblDatos, true, true);
// 
// 	return true;
// }

function oficial_crearTabla()
{
	var eGrafico:FLDomElement = this.iface.xmlGrafico_.firstChild().toElement();
	if (!eGrafico) {
		return false;
	}
	var tblDatos:FLTable = this.child("tblDatos");
	var totalFilas:Number = parseInt(eGrafico.attribute("NumFilas"));
	if (!totalFilas || isNaN(totalFilas)) {
		tblDatos.setNumRows(0);
		tblDatos.setNumCols(0);
		return false;
	}
	var totalCols:Number = parseInt(eGrafico.attribute("NumCols"));
	if (!totalCols || isNaN(totalCols)) {
		tblDatos.setNumRows(0);
		tblDatos.setNumCols(0);
		return false;
	}
	var alineacionHTabla:String = "AlignRight";
	var colorFondoTabla:String = fldireinne.iface.pub_dameColor("255,255,255");
	var formatoTabla:String = "##.###,00";
	var aEstiloFila:Array = new Array(totalFilas);
	for (var i:Number = 0; i < totalFilas; i++) {
		aEstiloFila[i] = [];
		aEstiloFila[i]["alineacionh"] = false;
		aEstiloFila[i]["colorfondo"] = false;
		aEstiloFila[i]["formato"] = false;
	}
	var aEstiloCol:Array = new Array(totalCols);
	for (var i:Number = 0; i < totalCols; i++) {
		aEstiloCol[i] = [];
		aEstiloCol[i]["alineacionh"] = false;
		aEstiloCol[i]["colorfondo"] = false;
		aEstiloCol[i]["formato"] = false;
	}
	tblDatos.setNumRows(totalFilas);
	tblDatos.setNumCols(totalCols);
	var eFilas:FLDomElement = eGrafico.namedItem("Filas").toElement();
	var eFila:FLDomElement;
	var iFila:Number;
	for (var nodoFila:FLDomNode = eFilas.firstChild(); nodoFila; nodoFila = nodoFila.nextSibling()) {
		eFila = nodoFila.toElement();
		iFila = parseInt(eFila.attribute("Numero"));
		if (eFila.attribute("ColorFondo") != "") {
			aEstiloFila[iFila]["colorfondo"] = fldireinne.iface.pub_dameColor(eFila.attribute("ColorFondo"));
		}
		if (eFila.attribute("Oculta") == "true") {
			tblDatos.hideRow(iFila);
		} else {
			tblDatos.showRow(iFila);
		}
		if (eFila.attribute("AlineacionH") != "") {
			aEstiloFila[iFila]["alineacionh"] = eFila.attribute("AlineacionH");
		}
	}
	var eCols:FLDomElement = eGrafico.namedItem("Cols").toElement();
	var eCol:FLDomElement;
	var iCol:Number;
	for (var nodoCol:FLDomNode = eCols.firstChild(); nodoCol; nodoCol = nodoCol.nextSibling()) {
		eCol = nodoCol.toElement();
		iCol = parseInt(eCol.attribute("Numero"));
		if (eCol.attribute("ColorFondo") != "") {
			aEstiloCol[iCol]["colorfondo"] = fldireinne.iface.pub_dameColor(eCol.attribute("ColorFondo"));
		}
		if (eCol.attribute("Oculta") == "true") {
			tblDatos.hideColumn(iCol);
		} else {
			tblDatos.showColumn(iCol);
		}
		if (eCol.attribute("AlineacionH") != "") {
			aEstiloCol[iCol]["alineacionh"] = eCol.attribute("AlineacionH");
		}
	}
	var aTabla:Array = this.iface.aTabla_;
	for (iFila = 0; iFila < totalFilas; iFila++) {
		for (iCol = 0; iCol < totalCols; iCol++) {
			this.iface.alinearCeldaDatos(tblDatos, iFila, iCol, aEstiloCol[iCol]["alineacionh"] ? aEstiloCol[iCol]["alineacionh"] : aEstiloFila[iFila]["alineacionh"] ? aEstiloFila[iFila]["alineacionh"] : alineacionHTabla);
			tblDatos.setCellBackgroundColor(iFila, iCol, aEstiloCol[iCol]["colorfondo"] ? aEstiloCol[iCol]["colorfondo"] : aEstiloFila[iFila]["colorfondo"] ? aEstiloFila[iFila]["colorfondo"] : colorFondoTabla);
// debug("poniendo dato fila " + iFila + ", col " + iCol);
			tblDatos.setText(iFila, iCol, aTabla[iFila][iCol]);
			if (iFila == totalFilas - 1) {
// 				tblDatos.adjustColumn(iCol);
			}
		}
	}
	this.iface.borrarCabecerasTabla(tblDatos, true, true);
}

function oficial_cargarDatosTabla()
{
	var util:FLUtil = new FLUtil;
	this.iface.cargarFormatoGrafico();
	
	if (!this.iface.xmlGrafico_) {
		return false;
	}
// debug("formato gráfico cargado: " + this.iface.xmlGrafico_.toString(4));
	var eGrafico:FLDomElement = this.iface.xmlGrafico_.firstChild().toElement();
	if (!eGrafico) {
		return false;
	}
	eGrafico.setAttribute("NumCols", 0);
	eGrafico.setAttribute("NumFilas", 0);
	var nodoFilas:FLDomNode = eGrafico.namedItem("Filas");
	if (nodoFilas) {
		eGrafico.removeChild(nodoFilas);
	}
	var nodoCols:FLDomNode = eGrafico.namedItem("Cols");
	if (nodoCols) {
		eGrafico.removeChild(nodoCols);
	}
	
	var xmlPos:FLDomNode = this.iface.xmlPosActual_.firstChild();
	debug("XML Pos " + xmlPos.toString(4));
	var ejeMedidas:String = xmlPos.namedItem("Medidas").toElement().attribute("Eje");

	var eNivel:FLDomElement, eProps:FLDomElement, eProp:FLDomElement;
	var eY:FLDomElement = xmlPos.namedItem("Dimensiones").namedItem("Y");
	var totalNivelesY:Number = 0;
	this.iface.nivelesY_  = [];
	var maxProps:Number = 0;
	for (var nodoNivelY:FLDomNode = eY.firstChild(); nodoNivelY; nodoNivelY = nodoNivelY.nextSibling()) {
		if (nodoNivelY.nodeName() != "Nivel") {
			continue;
		}

		eNivel = nodoNivelY.toElement();
		this.iface.nivelesY_[totalNivelesY] = [];
		this.iface.nivelesY_[totalNivelesY]["id"] = eNivel.attribute("Id");
		this.iface.nivelesY_[totalNivelesY]["propiedades"] = new Array(0);
		eProps = eNivel.namedItem("Propiedades");
		if (eProps) {
			var iProp:Number = 0;
			for (var nodoProp:FLDomNode = eProps.firstChild(); nodoProp; nodoProp = nodoProp.nextSibling()) {
				eProp = nodoProp.toElement();
				this.iface.nivelesY_[totalNivelesY]["propiedades"][iProp] = eProp.attribute("Id");
				iProp++;
			}
			maxProps = (iProp > maxProps ? iProp : maxProps);
		}
		totalNivelesY++;
	}

	if (totalNivelesY == 0) {
		this.iface.nivelesY_ = ["sin niveles"];
	}
	/// XXXX Refrescar gráfico si medidas o restricciones cambian

	var eX:FLDomElement = xmlPos.namedItem("Dimensiones").namedItem("X");
	var totalNivelesX:Number = 0;
	this.iface.nivelesX_  = [];
	for (var nodoNivelX:FLDomNode = eX.firstChild(); nodoNivelX; nodoNivelX = nodoNivelX.nextSibling()) {
		if (nodoNivelX.nodeName() != "Nivel") {
			continue;
		}
		this.iface.nivelesX_[totalNivelesX] = nodoNivelX.toElement().attribute("Id");
		totalNivelesX++;
	}
	if (totalNivelesX == 0) {
		this.iface.nivelesX_  = ["sin niveles"];
	}

	var totalNiveles:Number = totalNivelesY + totalNivelesX;
	if (totalNiveles > 0) {
		this.iface.nivelesTabla_ = new Array(totalNiveles);
		var n:Number = 0;
		for (var i:Number = 0; i < totalNivelesY; i++) {
			this.iface.nivelesTabla_[n] = this.iface.nivelesY_[i]["id"];
			n++;
		}
		for (var i:Number = 0; i < totalNivelesX; i++) {
			this.iface.nivelesTabla_[n] = this.iface.nivelesX_[i];
			n++;
		}
	} else {
		this.iface.nivelesTabla_ = ["sin niveles"];
	}
	var eEstilo:FLDomElement;
	eEstilo = this.iface.dameEstiloDatosGraf("CabeceraFila", util.translate("scripts", "Cabecera fila"));
	if (eEstilo.attribute("AlineacionH") == "") {
		eEstilo.setAttribute("AlineacionH", "AlignLeft");
	}
	eEstilo = this.iface.dameEstiloDatosGraf("CabeceraCol", util.translate("scripts", "Cabecera columna"));
	if (eEstilo.attribute("AlineacionH") == "") {
		eEstilo.setAttribute("AlineacionH", "AlignLeft");
	}
	eEstilo = this.iface.dameEstiloDatosGraf("Datos", util.translate("scripts", "Datos"));
	if (eEstilo.attribute("AlineacionH") == "") {
		eEstilo.setAttribute("AlineacionH", "AlignRight");
	}
	
	var eMedidas:FLDomElement = xmlPos.namedItem("Medidas");
	var totalMedidas:Number = 0;
	this.iface.medidasTabla_ = [];
	for (var nodoMedida:FLDomNode = eMedidas.firstChild(); nodoMedida; nodoMedida = nodoMedida.nextSibling()) {
		if (nodoMedida.nodeName() != "Medida") {
			continue;
		}
		this.iface.medidasTabla_[totalMedidas] = nodoMedida.toElement().attribute("Id");
		totalMedidas++;
	}
	if (totalMedidas == 0) {
		return false;
	}

	var totalColsOffset:Number = (ejeMedidas == "X" ? 1 : 2);
	totalColsOffset += maxProps;

	var totalFilOffset:Number = (ejeMedidas == "X" ? 2 : 1);
	for (var i:Number = 0; i < totalFilOffset; i++) {
		this.iface.crearFilaDatos3(i, "CabeceraCol");
	}
	this.iface.DAT_C_MEDIDA_ = this.iface.DAT_C_CABECERA_ + maxProps + 1;
	
	
	
	
// 	for (var i:Number = 0; i < iFila; i++) {
// 		this.iface.aFilasTabla_[i]= [];
// 		this.iface.aFilasTabla_[i]["nivel"]= 0;
// 		this.iface.aFilasTabla_[i]["idmedida"]= false;
// 	}

	var maxNivelY:Number = this.iface.nivelesY_.length - 1;
	var maxNivelX:Number = this.iface.nivelesX_.length - 1;
	var nodoDatos:FLDomNode = this.iface.xmlDatos_.firstChild();
	
// 	var numFilasArray:Number = nodoDatos.childNodes().length() * maxNivelY;
// 	var numColsArray:Number = maxNivelX * 2 + 10;
	delete this.iface.aTabla_;
	delete this.iface.aTablaRaw_;
	delete this.iface.aFilasTabla_;
	this.iface.aTabla_ = [];
	this.iface.aTablaRaw_ = [];
	this.iface.aFilasTabla_ = [];
// debug("numFilasArray = " + numFilasArray);
// debug("numColsArray = " + numColsArray);
// 	this.iface.aTabla_ = new Array(numFilasArray); //, numColsArray);
// 	this.iface.aTablaRaw_ = new Array(numFilasArray); //, numColsArray);
// 	this.iface.aFilasTabla_ = new Array(numFilasArray);
	
	var aTabla:Array = this.iface.aTabla_;
	var aTablaRaw:Array = this.iface.aTablaRaw_; /// Guarda valores numéricos no formateados para el cálculo de totales

	if (!this.iface.crearCabeceraCol3(maxProps)) {
		return false;
	}
	this.iface.ocultarColDatos(this.iface.DAT_C_CABECERA_, (this.iface.nivelesY_[0] == "sin niveles"));
	this.iface.ocultarColDatos(this.iface.DAT_C_MEDIDA_, (ejeMedidas == "Y" && totalMedidas == 1));
	this.iface.ocultarFilaDatos(this.iface.DAT_F_CABECERA_, (this.iface.nivelesX_[0] == "sin niveles"));
	if (totalFilOffset > 1) {
		this.iface.ocultarFilaDatos(this.iface.DAT_F_MEDIDA_, (ejeMedidas == "X" && totalMedidas == 1));
	}

	var totalCols:Number = this.iface.aColumnasTabla_.length; //tblDatos.numCols();
	eGrafico.setAttribute("NumCols", totalCols);

	var eRow:FLDomElement;
	var iFila:Number = totalFilOffset;
	
	var iCol:Number = totalColsOffset;
	
	var aValorAnterior:Array = new Array(this.iface.nivelesTabla_.length);
	var aEspacios:Array = new Array(this.iface.nivelesTabla_.length);
	var aAcumulado:Array = new Array(this.iface.nivelesTabla_.length);
	for (var i:Number = 0; i < aValorAnterior.length; i++) {
		aValorAnterior[i] = "";
		if (i < totalNivelesY) {
			(i == 0 ? aEspacios[i] = "" : aEspacios[i] = aEspacios[i - 1] + "  ")
		}
		aAcumulado[i] = [];
		for (var m:Number = 0; m < totalMedidas; m++) {
			aAcumulado[i][this.iface.medidasTabla_[m]] = 0;
		}
		aAcumulado[i]["fila"] = 0;
		aAcumulado[i]["col"] = 0;
	}

	var maxNivel:Number = this.iface.nivelesTabla_.length - 1;
	var nivelActual:Number = 0;
	var nivelRotura:Number = 0;
	var valorAcumulado:Number;
	var claveColumnaX:String;
	var idMedida:String;
	
	
	for (var i:Number = 0; i < iFila; i++) {
		this.iface.aFilasTabla_[i]= [];
		this.iface.aFilasTabla_[i]["nivel"]= 0;
		this.iface.aFilasTabla_[i]["idmedida"]= false;
	}
	/// Cabeceras tabla
	if (totalNivelesY == 0) {
		if (ejeMedidas == "X") {
			idMedida = false;
			this.iface.crearFilaDatos3(iFila, "Datos");
			aTabla[iFila] = new Array(totalCols);
			aTablaRaw[iFila] = new Array(totalCols);
			for (var c:Number = 0; c < totalCols; c++) { aTabla[iFila][c] = 0; aTablaRaw[iFila][c] = 0; }
			this.iface.aFilasTabla_[iFila] = this.iface.dameElementoArrayFilas(iFila);
			aTabla[iFila][this.iface.DAT_C_CABECERA_] = this.iface.dameCabeceraFila3(iFila);
			iFila++;
		} else {
			for (var m:Number = 0; m < totalMedidas; m++) {
				idMedida = this.iface.medidasTabla_[m],
				this.iface.crearFilaDatos3(iFila + m, "Datos");
				aTabla[iFila + m] = new Array(totalCols);
				aTablaRaw[iFila + m] = new Array(totalCols);
				for (var c:Number = 0; c < totalCols; c++) { aTabla[iFila + m][c] = 0; aTablaRaw[iFila + m][c] = 0; }
				aTabla[iFila + m][this.iface.DAT_C_MEDIDA_] = this.iface.dameAliasMedida(idMedida);
				this.iface.aFilasTabla_[iFila + m] = this.iface.dameElementoArrayFilas(iFila);
				this.iface.aFilasTabla_[iFila + m]["idmedida"] = idMedida;
				aTabla[iFila][this.iface.DAT_C_CABECERA_] = this.iface.dameCabeceraFila3(iFila);
			}
			iFila += totalMedidas;
		}
	}
	var iFilaMedida:Number;
	var valor:Number;
	var valorF:String;
	var colorCeldaValor:Color;
	var hayDatos:Boolean = false;
	var eFilaDatos:FLDomElement;
	
// this.iface.tiempoAnterior_ = 0;
debug("nodo datos " + nodoDatos.toString(4));
	var nodosDatos:FLDomNodeList = nodoDatos.childNodes();
	if (!nodosDatos) {
		return false;
	}
	var totalDatos:Number = nodoDatos.childNodes().length();
	var progreso:Number = 0;
	var hayDialogo:Boolean = totalDatos > 500;
	var pasoAct:Number = Math.round(totalDatos / 100);
	if (hayDialogo) {
		util.destroyProgressDialog();
		util.createProgressDialog(util.translate("scripts", "Cargando tabla"), totalDatos);
	}
debug("totalDatos " + totalDatos + " hayDialogo " + hayDialogo);
// return false;

	for (var nodoRow:FLDomNode = nodoDatos.firstChild(); nodoRow; nodoRow = nodoRow.nextSibling()) {
		if (hayDialogo) {
			if (progreso++ % pasoAct == 0) {
				util.setProgress(progreso);
				sys.processEvents();
			}
		}
// var tiempo:Date = new Date(); debug("T1 = " + (tiempo.getTime() - this.iface.tiempoAnterior_)); this.iface.tiempoAnterior_ = tiempo.getTime();
		hayDatos = true;
		eRow = nodoRow.toElement();
		nivelRotura = -1;
		for (var i:Number = 0; i <= maxNivel; i++) {
			if (nivelRotura== -1 && eRow.attribute(this.iface.nivelesTabla_[i]) != aValorAnterior[i]) {
				nivelRotura = i;
			}
			aValorAnterior[i] = eRow.attribute(this.iface.nivelesTabla_[i]);
		}
// var tiempo2:Date = new Date(); debug("T2 = " + (tiempo2.getTime() - this.iface.tiempoAnterior_)); this.iface.tiempoAnterior_ = tiempo2.getTime();
		/// Dibujar filas de niveles cabecera
		if (nivelRotura >= 0 && nivelRotura < totalNivelesY) {
			for (var n:Number = nivelRotura; n <= maxNivelY; n++) {
				if (ejeMedidas == "X") {
					this.iface.crearFilaDatos3(iFila, "Datos");
					aTabla[iFila] = new Array(totalCols);
					aTablaRaw[iFila] = new Array(totalCols);
// 					for (var c:Number = (this.iface.DAT_C_CABECERA_ + 1); c < totalCols; c += totalMedidas) {
					for (var c:Number = (this.iface.DAT_C_MEDIDA_ + 1); c < totalCols; c += totalMedidas) {
						for (var m:Number = 0; m < totalMedidas; m++) {
							idMedida = this.iface.medidasTabla_[m];
							aTabla[iFila][c + m] = this.iface.formatearValorMedida(0, idMedida);
							aTablaRaw[iFila][c + m] = 0;
						}
					}
					idMedida = false;
					this.iface.aFilasTabla_[iFila] = this.iface.dameElementoArrayFilas();
					this.iface.aFilasTabla_[iFila]["idmedida"] = idMedida;
					this.iface.aFilasTabla_[iFila]["nivel"] = n;
					if (n == maxNivelY) {
						this.iface.aFilasTabla_[iFila]["expande"] = "";
					} else {
						this.iface.aFilasTabla_[iFila]["expande"] = "S";
						eFila = this.iface.dameFilaDatosGraf(iFila);
						eFila.setAttribute("ColorFondo", this.iface.colorDatTotal_);
					}
					this.iface.aFilasTabla_[iFila]["clave"] = eRow.attribute(this.iface.nivelesTabla_[n]);
					aTabla[iFila][this.iface.DAT_C_CABECERA_] = this.iface.dameCabeceraFila3(iFila);
					if (!this.iface.informaPropiedadesFila(iFila, maxProps)) {
						if (hayDialogo) {
							util.destroyProgressDialog();
						}
						return false;
					}
				} else {
					for (var m:Number = 0; m < totalMedidas; m++) {
// var tiempo21:Date = new Date(); debug("T2.1 = " + (tiempo21.getTime() - this.iface.tiempoAnterior_)); this.iface.tiempoAnterior_ = tiempo21.getTime();
						idMedida = this.iface.medidasTabla_[m];
						eFila = this.iface.crearFilaDatos3(iFila + m, "Datos");
// var tiempo22:Date = new Date(); debug("T2.2 = " + (tiempo22.getTime() - this.iface.tiempoAnterior_)); this.iface.tiempoAnterior_ = tiempo22.getTime();
						aTabla[iFila + m] = new Array(totalCols);
						aTablaRaw[iFila + m] = new Array(totalCols);
						for (var c:Number = (this.iface.DAT_C_MEDIDA_ + 1); c < totalCols; c++) {
							aTabla[iFila + m][c] = this.iface.formatearValorMedida(0, idMedida);
							aTablaRaw[iFila + m][c] = 0;
						}
// var tiempo23:Date = new Date(); debug("T2.3 = " + (tiempo23.getTime() - this.iface.tiempoAnterior_)); this.iface.tiempoAnterior_ = tiempo23.getTime();
						aTabla[iFila + m][this.iface.DAT_C_MEDIDA_] = this.iface.dameAliasMedida(idMedida);
						
						this.iface.aFilasTabla_[iFila + m] = this.iface.dameElementoArrayFilas();
						this.iface.aFilasTabla_[iFila + m]["idmedida"] = idMedida;
						this.iface.aFilasTabla_[iFila + m]["nivel"] = n;
						if (n == maxNivelY) {
							this.iface.aFilasTabla_[iFila + m]["expande"] = "";
						} else {
							this.iface.aFilasTabla_[iFila + m]["expande"] = "S";
							eFila.setAttribute("ColorFondo", this.iface.colorDatTotal_);
						}
// var tiempo24:Date = new Date(); debug("T2.4 = " + (tiempo24.getTime() - this.iface.tiempoAnterior_)); this.iface.tiempoAnterior_ = tiempo24.getTime();
						this.iface.aFilasTabla_[iFila + m]["clave"] = eRow.attribute(this.iface.nivelesTabla_[n]);
						aTabla[iFila + m][this.iface.DAT_C_CABECERA_] = this.iface.dameCabeceraFila3(iFila + m);
// var tiempo3:Date = new Date(); debug("T3 = " + (tiempo3.getTime() - this.iface.tiempoAnterior_)); this.iface.tiempoAnterior_ = tiempo3.getTime();
						if (!this.iface.informaPropiedadesFila(iFila + m, maxProps)) {
							if (hayDialogo) {
								util.destroyProgressDialog();
							}
							return false;
						}
					}
				}
				iFila += (ejeMedidas == "X" ? 1 : totalMedidas);
// debug("iFila " + iFila);
			}
		}
		

		/// Dibujar filas de valores
		claveColumnaX = this.iface.dameClaveColumnaX(totalNiveles - totalNivelesY - 1, eRow);
		if (claveColumnaX !=  "") {
			iCol = this.iface.columnasClaveX_[claveColumnaX];
		}
		if (ejeMedidas == "X") {
			for (var m:Number = 0; m < totalMedidas; m++) {
				idMedida = this.iface.medidasTabla_[m];
				valor = eRow.attribute(idMedida);
				valorF = this.iface.formatearValorMedida(valor, idMedida);
				iFilaMedida = iFila - 1;
				aTabla[iFilaMedida][(iCol + m)]= valorF;
				aTablaRaw[iFilaMedida][(iCol + m)]= valor;
				colorCeldaValor = this.iface.colorValorObjetivo(idMedida, valor);
				if (colorCeldaValor) {
					this.iface.ponColorFondoCeldaDatos(iFilaMedida, (iCol + m), colorCeldaValor);
				}
			}
		} else {
			for (var m:Number = 0; m < totalMedidas; m++) {
				idMedida = this.iface.medidasTabla_[m];
				valor = eRow.attribute(idMedida);
				valorF = this.iface.formatearValorMedida(valor, idMedida);
				iFilaMedida = iFila - totalMedidas + m;
				aTabla[iFilaMedida][iCol]= valorF;
				aTablaRaw[iFilaMedida][iCol]= valor;
			}
		}
// var tiempo4:Date = new Date(); debug("T4 = " + (tiempo4.getTime() - this.iface.tiempoAnterior_)); this.iface.tiempoAnterior_ = tiempo4.getTime();
	}
	if (hayDialogo) {
		util.destroyProgressDialog();
	}
	if (!hayDatos) {
		eGrafico.setAttribute("NumFilas", 0)
		return true;
	}
	var acumulado:Number;
	var sigNivelX:Number = 0;
	var colAcum:Number;
	var incrementoCol:Number = (ejeMedidas == "X" ? totalMedidas : 1);
	var valorF:String;
	var funAgregacion:String;
	var idMedida:String;
	var totalFilas:Number = parseInt(eGrafico.attribute("NumFilas"));
	
	/// Valores acumulados
	for (var nX:Number = (maxNivelX - 1); nX >= 0 ; nX--) {
// 		for (var col:Number = totalColsOffset; col < tblDatos.numCols() ; col++) {
		for (var col:Number = totalColsOffset; col < totalCols ; col++) {
			if (this.iface.aColumnasTabla_[col]["nivel"] != nX) {
				continue;
			}
			sigNivelX = nX + 1;
			for (var m:Number = 1; m <= incrementoCol; m++) {
				col += (m - 1);
// 				for (var fil:Number = totalFilOffset; fil < tblDatos.numRows() ; fil++) {
				for (var fil:Number = totalFilOffset; fil < totalFilas ; fil++) {
					acumulado = 0;
					colAcum = col + incrementoCol;
					if (ejeMedidas == "X") {
						idMedida = this.iface.aColumnasTabla_[col]["idmedida"];
					} else {
						idMedida = this.iface.aFilasTabla_[fil]["idmedida"];
					}
// 					while (colAcum < tblDatos.numCols() && this.iface.aColumnasTabla_[colAcum]["nivel"] >= sigNivelX) {
					while (colAcum < totalCols && this.iface.aColumnasTabla_[colAcum]["nivel"] >= sigNivelX) {
						if (this.iface.aColumnasTabla_[colAcum]["nivel"] > sigNivelX) {
							colAcum += incrementoCol;
							continue;
						}
						acumulado += parseFloat(aTablaRaw[fil][colAcum]);
						colAcum += incrementoCol;
					}
					valorF = this.iface.formatearValorMedida(acumulado, idMedida);
					funAgregacion = this.iface.dameSqlAgregacion(idMedida);
					if (funAgregacion == "AVG") {
						valorF = "";
					}
// 					tblDatos.setText(fil, col, valorF);
// 					this.iface.ponTextoCelda(fil, col, valorF);
// 					tblDatos.setCellAlignment(fil, col, tblDatos.AlignRight);
// 					this.iface.ponAlineacionHCelda(fil, col, "AlignRight");
					aTabla[fil][col] = valorF;
					aTablaRaw[fil][col] = acumulado;
				}
			}
		}
	}
	
	var sigNivelY:Number = 0;
	var filAcum:Number;
	var incrementoFila:Number = (ejeMedidas == "X" ? 1 : totalMedidas);
	for (var nY:Number = (maxNivelY - 1); nY >= 0 ; nY--) {
// 		for (var fil:Number = totalFilOffset; fil < tblDatos.numRows() ; fil++) {
		for (var fil:Number = totalFilOffset; fil < totalFilas ; fil++) {
			if (this.iface.aFilasTabla_[fil]["nivel"] != nY) {
				continue;
			}
			sigNivelY = nY + 1;
			for (var m:Number = 1; m <= incrementoFila; m++) {
				fil += (m - 1);
// 				for (var col:Number = totalColsOffset; col < tblDatos.numCols() ; col++) {
				for (var col:Number = totalColsOffset; col < totalCols ; col++) {
					acumulado = 0;
					filAcum = fil + incrementoFila;
					if (ejeMedidas == "X") {
						idMedida = this.iface.aColumnasTabla_[col]["idmedida"];
					} else {
						idMedida = this.iface.aFilasTabla_[fil]["idmedida"];
					}
// 					while (filAcum < tblDatos.numRows() && this.iface.aFilasTabla_[filAcum]["nivel"] >= sigNivelY) {
					while (filAcum < totalFilas && this.iface.aFilasTabla_[filAcum]["nivel"] >= sigNivelY) {
						if (this.iface.aFilasTabla_[filAcum]["nivel"] > sigNivelY) {
							filAcum += incrementoFila;
							continue;
						}
						acumulado += parseFloat(aTablaRaw[filAcum][col]);
						filAcum += incrementoFila;
					}
					valorF = this.iface.formatearValorMedida(acumulado, idMedida);
					funAgregacion = this.iface.dameSqlAgregacion(idMedida);
					if (funAgregacion == "AVG") {
						valorF = "";
					}
// 					tblDatos.setText(fil, col, valorF);
// 					this.iface.ponTextoCelda(fil, col, valorF);
// 					tblDatos.setCellAlignment(fil, col, tblDatos.AlignRight);
					this.iface.ponAlineacionHCelda(fil, col, "AlignRight");
					aTabla[fil][col] = valorF;
					aTablaRaw[fil][col] = acumulado;
				}
			}
		}
	}
	for (var c:Number = 0; c < totalCols; c++) {
		if (this.iface.aColumnasTabla_[c]["nivel"] < maxNivelX) {
// 			this.iface.cambiarColorColumnaTabla(tblDatos, c, this.iface.colorDatTotal_);
// 			this.iface.ponColorFondoColumnaDatos(c, this.iface.colorDatTotal_);
		}
// 		tblDatos.adjustColumn(c);
		this.iface.ajustarColumnaDatos(c, true);
	}

// 	debug(this.iface.xmlGrafico_.toString(4));
	
	return true;
}

// function oficial_mostrarTabla2(enGrafico:Boolean)
// {
// 	var xmlPos:FLDomNode = this.iface.xmlPosActual_.firstChild();
// 	
// // 	var eGrafico:FLDomElement;
// // 	if (enGrafico) {
// // 		eGrafico = this.iface.xmlGrafico_.firstChild().toElement();
// // 	}
// 	
// 	var ejeMedidas:String = xmlPos.namedItem("Medidas").toElement().attribute("Eje");
// 
// 	var eY:FLDomElement = xmlPos.namedItem("Dimensiones").namedItem("Y");
// 	var totalNivelesY:Number = 0;
// 	this.iface.nivelesY_  = [];
// 	for (var nodoNivelY:FLDomNode = eY.firstChild(); nodoNivelY; nodoNivelY = nodoNivelY.nextSibling()) {
// 		if (nodoNivelY.nodeName() != "Nivel") {
// 			continue;
// 		}
// 		this.iface.nivelesY_[totalNivelesY] = nodoNivelY.toElement().attribute("Id");
// 		totalNivelesY++;
// 	}
// 	if (totalNivelesY == 0) {
// 		this.iface.nivelesY_ = ["sin niveles"];
// 	}
// 
// 	var eX:FLDomElement = xmlPos.namedItem("Dimensiones").namedItem("X");
// 	var totalNivelesX:Number = 0;
// 	this.iface.nivelesX_  = [];
// 	for (var nodoNivelX:FLDomNode = eX.firstChild(); nodoNivelX; nodoNivelX = nodoNivelX.nextSibling()) {
// 		if (nodoNivelX.nodeName() != "Nivel") {
// 			continue;
// 		}
// 		this.iface.nivelesX_[totalNivelesX] = nodoNivelX.toElement().attribute("Id");
// 		totalNivelesX++;
// 	}
// 	if (totalNivelesX == 0) {
// 		this.iface.nivelesX_  = ["sin niveles"];
// 	}
// 
// 	var totalNiveles:Number = totalNivelesY + totalNivelesX;
// 	if (totalNiveles > 0) {
// 		this.iface.nivelesTabla_ = new Array(totalNiveles);
// 		var n:Number = 0;
// 		for (var i:Number = 0; i < totalNivelesY; i++) {
// 			this.iface.nivelesTabla_[n] = this.iface.nivelesY_[i];
// 			n++;
// 		}
// 		for (var i:Number = 0; i < totalNivelesX; i++) {
// 			this.iface.nivelesTabla_[n] = this.iface.nivelesX_[i];
// 			n++;
// 		}
// 	} else {
// 		this.iface.nivelesTabla_ = ["sin niveles"];
// 	}
// 
// 	var tblDatos:Object = this.child("tblDatos");
// 	tblDatos.setNumCols(0);
// 	tblDatos.setNumRows(0);
// 
// 	var eMedidas:FLDomElement = xmlPos.namedItem("Medidas");
// 	var totalMedidas:Number = 0;
// 	this.iface.medidasTabla_ = [];
// 	for (var nodoMedida:FLDomNode = eMedidas.firstChild(); nodoMedida; nodoMedida = nodoMedida.nextSibling()) {
// 		if (nodoMedida.nodeName() != "Medida") {
// 			continue;
// 		}
// 		this.iface.medidasTabla_[totalMedidas] = nodoMedida.toElement().attribute("Id");
// 		totalMedidas++;
// 	}
// 	if (totalMedidas == 0) {
// 		return false;
// 	}
// 
// 	var totalColsOffset:Number = (ejeMedidas == "X" ? 1 : 2);
// // 	tblDatos.setNumCols(totalColsOffset);
// // 
// 	var totalFilOffset:Number = (ejeMedidas == "X" ? 2 : 1);
// // 	for (var i:Number = 0; i < totalFilOffset; i++) {
// // 		this.iface.crearFilaDatos(i);
// // 	}
// // 
// // 	if (this.iface.nivelesY_[0] == "sin niveles") {
// // 		tblDatos.hideColumn(this.iface.DAT_C_CABECERA_);
// // 	}
// // 	if (ejeMedidas == "Y" && totalMedidas == 1) {
// // // 		tblDatos.hideColumn(this.iface.DAT_C_CABECERA_ + 1);
// // 		tblDatos.hideColumn(this.iface.DAT_C_MEDIDA_);
// // 	}
// // 	if (this.iface.nivelesX_[0] == "sin niveles") {
// // 		tblDatos.hideRow(this.iface.DAT_F_CABECERA_);
// // 	}
// // 	if (ejeMedidas == "X" && totalMedidas == 1) {
// // // 		tblDatos.hideRow(this.iface.DAT_F_CABECERA_ + 1);
// // 		tblDatos.hideRow(this.iface.DAT_F_MEDIDA_);
// // 	}
// 
// 	this.iface.crearCabeceraCol3();
// 
// 	var totalCols:Number = this.iface.aColumnasTabla_.length; //tblDatos.numCols();
// 
// 	var nodoDatos:FLDomNode = this.iface.xmlDatos_.firstChild();
// 	var eRow:FLDomElement;
// 	var iFila:Number = totalFilOffset;
// 	
// 	var iCol:Number = totalColsOffset;
// 	
// 	var aValorAnterior:Array = new Array(this.iface.nivelesTabla_.length);
// 	var aEspacios:Array = new Array(this.iface.nivelesTabla_.length);
// 	var aAcumulado:Array = new Array(this.iface.nivelesTabla_.length);
// 
// 	for (var i:Number = 0; i < aValorAnterior.length; i++) {
// 		aValorAnterior[i] = "";
// 		if (i < totalNivelesY) {
// 			(i == 0 ? aEspacios[i] = "" : aEspacios[i] = aEspacios[i - 1] + "  ")
// 		}
// 		aAcumulado[i] = [];
// 		for (var m:Number = 0; m < totalMedidas; m++) {
// 			aAcumulado[i][this.iface.medidasTabla_[m]] = 0;
// 		}
// 		aAcumulado[i]["fila"] = 0;
// 		aAcumulado[i]["col"] = 0;
// 	}
// 	var maxNivelY:Number = this.iface.nivelesY_.length - 1;
// 	var maxNivelX:Number = this.iface.nivelesX_.length - 1;
// 	var maxNivel:Number = this.iface.nivelesTabla_.length - 1;
// 	var nivelActual:Number = 0;
// 	var nivelRotura:Number = 0;
// 	var valorAcumulado:Number;
// 	var claveColumnaX:String;
// 	var idMedida:String;
// 
// 	var numFilasArray:Number = nodoDatos.childNodes().length() * maxNivelY;
// 	delete this.iface.aTabla_;
// // 	this.iface.aTabla_ = [];
// 	this.iface.aTabla_ = new Array(numFilasArray, totalCols);
// // 	var aTabla:Array = this.iface.aTabla_;
// 	var aTabla:Array = new Array(numFilasArray, totalCols);
// 	if (this.iface.aFilasTabla_) {
// 		delete this.iface.aFilasTabla_;
// 	}
// // 	this.iface.aFilasTabla_ = [];
// 	this.iface.aFilasTabla_ = new Array(numFilasArray);
// 	for (var i:Number = 0; i < iFila; i++) {
// 		this.iface.aFilasTabla_[i]= [];
// 		this.iface.aFilasTabla_[i]["nivel"]= 0;
// 		this.iface.aFilasTabla_[i]["idmedida"]= false;
// 	}
// 	
// 	if (totalNivelesY == 0) {
// 		if (ejeMedidas == "X") {
// 			idMedida = false;
// 			this.iface.crearFilaDatos(iFila);
// // 			aTabla[iFila] = new Array(totalCols);
// 			for (var c:Number = 0; c < totalCols; c++) { aTabla[iFila][c] = 0; }
// 			this.iface.aFilasTabla_[iFila] = this.iface.dameElementoArrayFilas(iFila);
// 			this.iface.dameCabeceraFila(iFila);
// 			iFila++;
// 		} else {
// 			for (var m:Number = 0; m < totalMedidas; m++) {
// 				idMedida = this.iface.medidasTabla_[m],
// 				this.iface.crearFilaDatos(iFila + m);
// // 				aTabla[iFila + m] = new Array(totalCols);
// 				for (var c:Number = 0; c < totalCols; c++) { aTabla[iFila + m][c] = 0; }
// 				tblDatos.setText(iFila + m, this.iface.DAT_C_MEDIDA_, this.iface.dameAliasMedida(idMedida));
// 				this.iface.aFilasTabla_[iFila + m] = this.iface.dameElementoArrayFilas(iFila);
// 				this.iface.aFilasTabla_[iFila + m]["idmedida"] = idMedida;
// 				this.iface.dameCabeceraFila(iFila + m);
// 			}
// 			iFila += totalMedidas;
// 		}
// 	}
// 	var iFilaMedida:Number;
// 	var valor:Number;
// 	var valorF:String;
// 	var colorCeldaValor:Color;
// 	for (var nodoRow:FLDomNode = nodoDatos.firstChild(); nodoRow; nodoRow = nodoRow.nextSibling()) {
// 		eRow = nodoRow.toElement();
// 		nivelRotura = -1;
// 		for (var i:Number = 0; i <= maxNivel; i++) {
// 			if (nivelRotura== -1 && eRow.attribute(this.iface.nivelesTabla_[i]) != aValorAnterior[i]) {
// 				nivelRotura = i;
// 			}
// 			aValorAnterior[i] = eRow.attribute(this.iface.nivelesTabla_[i]);
// 		}
// 		/// Dibujar filas de niveles cabecera
// 		if (nivelRotura >= 0 && nivelRotura < totalNivelesY) {
// 			for (var n:Number = nivelRotura; n <= maxNivelY; n++) {
// 				if (ejeMedidas == "X") {
// 					idMedida = false;
// 					this.iface.crearFilaDatos(iFila);
// // 					aTabla[iFila] = new Array(totalCols);
// 					for (var c:Number = 0; c < totalCols; c++) { aTabla[iFila][c] = 0; }
// 					this.iface.aFilasTabla_[iFila] = this.iface.dameElementoArrayFilas();
// 					this.iface.aFilasTabla_[iFila]["idmedida"] = idMedida;
// 					this.iface.aFilasTabla_[iFila]["nivel"] = n;
// 					this.iface.aFilasTabla_[iFila]["expande"] = (n == maxNivelY ? "" : "S");
// 					this.iface.aFilasTabla_[iFila]["clave"] = eRow.attribute(this.iface.nivelesTabla_[n]);
// 					this.iface.dameCabeceraFila(iFila);
// 				} else {
// 					for (var m:Number = 0; m < totalMedidas; m++) {
// 						idMedida = this.iface.medidasTabla_[m];
// 						this.iface.crearFilaDatos(iFila + m);
// // 						aTabla[iFila + m] = new Array(totalCols);
// 						for (var c:Number = 0; c < totalCols; c++) { aTabla[iFila + m][c] = 0; }
// 						tblDatos.setText(iFila + m, this.iface.DAT_C_MEDIDA_, this.iface.dameAliasMedida(idMedida));
// 						
// 						this.iface.aFilasTabla_[iFila + m] = this.iface.dameElementoArrayFilas();
// 						this.iface.aFilasTabla_[iFila + m]["idmedida"] = idMedida;
// 						this.iface.aFilasTabla_[iFila + m]["nivel"] = n;
// 						this.iface.aFilasTabla_[iFila + m]["expande"] = (n == maxNivelY ? "" : "S");
// 						this.iface.aFilasTabla_[iFila + m]["clave"] = eRow.attribute(this.iface.nivelesTabla_[n]);
// 						this.iface.dameCabeceraFila(iFila + m);
// 					}
// 				}
// 				iFila += (ejeMedidas == "X" ? 1 : totalMedidas);
// 			}
// 		}
// 
// 		/// Dibujar filas de valores
// 		claveColumnaX = this.iface.dameClaveColumnaX(totalNiveles - totalNivelesY - 1, eRow);
// 		if (claveColumnaX !=  "") {
// 			iCol = this.iface.columnasClaveX_[claveColumnaX];
// 		}
// 		if (ejeMedidas == "X") {
// 			for (var m:Number = 0; m < totalMedidas; m++) {
// 				idMedida = this.iface.medidasTabla_[m];
// 				valor = eRow.attribute(idMedida);
// 				valorF = this.iface.formatearValorMedida(valor, idMedida);
// 				iFilaMedida = iFila - 1;
// 				aTabla[iFilaMedida][(iCol + m)] = [];
// 				aTabla[iFilaMedida][(iCol + m)]= valor;
// 				tblDatos.setText(iFilaMedida, (iCol + m), valorF);
// 				colorCeldaValor = this.iface.colorValorObjetivo(idMedida, valor);
// 				if (colorCeldaValor) {
// 					tblDatos.setCellBackgroundColor(iFilaMedida, (iCol + m), colorCeldaValor);
// 				}
// 				tblDatos.setCellAlignment(iFilaMedida, (iCol + m), tblDatos.AlignRight);
// 			}
// 		} else {
// 			for (var m:Number = 0; m < totalMedidas; m++) {
// 				idMedida = this.iface.medidasTabla_[m];
// 				valor = eRow.attribute(idMedida);
// 				valorF = this.iface.formatearValorMedida(valor, idMedida);
// 				iFilaMedida = iFila - totalMedidas + m;
// 				aTabla[iFilaMedida][iCol] = [];
// 				aTabla[iFilaMedida][iCol]= valor;
// 				tblDatos.setText(iFilaMedida, iCol, valorF);
// 				colorCeldaValor = this.iface.colorValorObjetivo(idMedida, valor);
// 				if (colorCeldaValor) {
// 					tblDatos.setCellBackgroundColor(iFilaMedida, iCol, colorCeldaValor);
// 				}
// 				tblDatos.setCellAlignment(iFilaMedida, iCol, tblDatos.AlignRight);
// 			}
// 		}
// 	}
// 	var acumulado:Number;
// 	var sigNivelX:Number = 0;
// 	var colAcum:Number;
// 	var incrementoCol:Number = (ejeMedidas == "X" ? totalMedidas : 1);
// 	var valorF:String;
// 	var funAgregacion:String;
// 	var idMedida:String;
// 	for (var nX:Number = (maxNivelX - 1); nX >= 0 ; nX--) {
// 		for (var col:Number = totalColsOffset; col < tblDatos.numCols() ; col++) {
// 			if (this.iface.aColumnasTabla_[col]["nivel"] != nX) {
// 				continue;
// 			}
// 			sigNivelX = nX + 1;
// 			for (var m:Number = 1; m <= incrementoCol; m++) {
// 				col += (m - 1);
// 				for (var fil:Number = totalFilOffset; fil < tblDatos.numRows() ; fil++) {
// 					acumulado = 0;
// 					colAcum = col + incrementoCol;
// 					if (ejeMedidas == "X") {
// 						idMedida = this.iface.aColumnasTabla_[col]["idmedida"];
// 					} else {
// 						idMedida = this.iface.aFilasTabla_[fil]["idmedida"];
// 					}
// 					while (colAcum < tblDatos.numCols() && this.iface.aColumnasTabla_[colAcum]["nivel"] >= sigNivelX) {
// 						if (this.iface.aColumnasTabla_[colAcum]["nivel"] > sigNivelX) {
// 							colAcum += incrementoCol;
// 							continue;
// 						}
// 						acumulado += parseFloat(aTabla[fil][colAcum]);
// 						colAcum += incrementoCol;
// 					}
// 					valorF = this.iface.formatearValorMedida(acumulado, idMedida);
// 					funAgregacion = this.iface.dameSqlAgregacion(idMedida);
// 					if (funAgregacion == "AVG") {
// 						valorF = "";
// 					}
// 					tblDatos.setText(fil, col, valorF);
// 					tblDatos.setCellAlignment(fil, col, tblDatos.AlignRight);
// 					aTabla[fil][col] = acumulado;
// 				}
// 			}
// 		}
// 	}
// 	
// 	var sigNivelY:Number = 0;
// 	var filAcum:Number;
// 	var incrementoFila:Number = (ejeMedidas == "X" ? 1 : totalMedidas);
// 	for (var nY:Number = (maxNivelY - 1); nY >= 0 ; nY--) {
// 		for (var fil:Number = totalFilOffset; fil < tblDatos.numRows() ; fil++) {
// 			if (this.iface.aFilasTabla_[fil]["nivel"] != nY) {
// 				continue;
// 			}
// 			sigNivelY = nY + 1;
// 			for (var m:Number = 1; m <= incrementoFila; m++) {
// 				fil += (m - 1);
// 				for (var col:Number = totalColsOffset; col < tblDatos.numCols() ; col++) {
// 					acumulado = 0;
// 					filAcum = fil + incrementoFila;
// 					if (ejeMedidas == "X") {
// 						idMedida = this.iface.aColumnasTabla_[col]["idmedida"];
// 					} else {
// 						idMedida = this.iface.aFilasTabla_[fil]["idmedida"];
// 					}
// 					while (filAcum < tblDatos.numRows() && this.iface.aFilasTabla_[filAcum]["nivel"] >= sigNivelY) {
// 						if (this.iface.aFilasTabla_[filAcum]["nivel"] > sigNivelY) {
// 							filAcum += incrementoFila;
// 							continue;
// 						}
// 						acumulado += parseFloat(aTabla[filAcum][col]);
// 						filAcum += incrementoFila;
// 					}
// 					valorF = this.iface.formatearValorMedida(acumulado, idMedida);
// 					funAgregacion = this.iface.dameSqlAgregacion(idMedida);
// 					if (funAgregacion == "AVG") {
// 						valorF = "";
// 					}
// 					tblDatos.setText(fil, col, valorF);
// 					tblDatos.setCellAlignment(fil, col, tblDatos.AlignRight);
// 					aTabla[fil][col] = acumulado;
// 				}
// 			}
// 		}
// 	}
// 	for (var c:Number = 0; c < totalCols; c++) {
// 		if (this.iface.aColumnasTabla_[c]["nivel"] < maxNivelX) {
// 			this.iface.cambiarColorColumnaTabla(tblDatos, c, this.iface.colorDatTotal_);
// 		}
// 		tblDatos.adjustColumn(c);
// 	}
// 	this.iface.borrarCabecerasTabla(tblDatos, true, true);
// 
// 	return true;
// }

/** \D Obtiene el alias de una medidas
@param	idMedida: Identificador de la medidas
@return Alias de la medidas
\end */
function oficial_dameAliasMedida(idMedida:String):String
{
	var eMed:FLDomElement = this.iface.medidas_[idMedida]["element"];
	var alias:String;
	if (eMed) {
		alias = eMed.attribute("alias");
		if (!alias || alias == "") {
			alias = idMedida;
		}
	} else {
		alias = idMedida;
	}
	return alias;
}

/** \D Formatea un valor numérico según el formato asociado a la medida que representa
@param	valor: Valor a formatear
@param	idMedida: Identificador de la medidas
@return	Valor formateado
\end */
function oficial_formatearValorMedida(valor:Number, idMedida:String):String
{
	if (isNaN(valor)) {
		return false;
	}
	var util:FLUtil = new FLUtil;
	var valorF:String;
	var numDec:Number;
	var eMedida:FLDomElement = this.iface.medidas_[idMedida]["element"];
	var formato:String = eMedida.attribute("formatString");
	if (!formato || formato == "") {
		return valor.toString();
	}
	var longitud:Number = formato.length;
	var posComa:Number = formato.findRev(",");
	numDec = (posComa > -1 ? longitud - posComa - 1 : 0);
	valorF = util.buildNumber(valor, "f", numDec);
	if (formato.find(".") > -1) {
		valorF = util.formatoMiles(valorF);
	}
	return valorF;
}

/** \D Borra los labels de las cabeceras de filas y columnas
@param	tblTabla: Objeto tabla
@param	borrarFilas: Indica si hay que borrar las cabeceras de las filas
@param	borrarColumnas: Indica si hay que borrar las cabeceras de las columnas
\end */
function oficial_borrarCabecerasTabla(tblTabla:FLTable, borrarFilas:Boolean, borrarColumnas:Boolean):Boolean
{
	if (borrarFilas) {
		var totalFilas:Number = tblTabla.numRows();
		var lFilas:String = "";
		for (var i:Number = 0; i < totalFilas; i++) {
			lFilas += " *";
		}
		tblTabla.setRowLabels("*", lFilas);
		try {
			tblTabla.setLeftMargin(15);
		} catch (e) {}
	}

	if (borrarColumnas) {
		var totalCols:Number = tblTabla.numCols();
		var lCols:String = "";
		for (var i:Number = 0; i < totalCols; i++) {
			lCols += " *";
		}
		tblTabla.setColumnLabels("*", lCols);
		try {
			tblTabla.setTopMargin(15);
		} catch (e) {}
	}
}

/** \D Obtiene el color asociado a un valor en función de los tramos definidos en el correspondiente nodo Objetivo para la medida a tratar
@param	idMedida: Medida
@param	valor: Valor
@return color que corresponde al valor y la medida indicados
\end */
function oficial_colorValorObjetivo(idMedida:String, valor:String):Color
{
	var color:Color = new Color;
	var xmlPos:FLDomNode = this.iface.xmlPosActual_.firstChild();
	var nodoObjetivos:FLDomNode = xmlPos.namedItem("Objetivos");
	if (!nodoObjetivos) {
		return false;
	}
	var nodoTramos:FLDomNode = fldireinne.iface.pub_dameNodoXML(nodoObjetivos, "Objetivo[@IdMedida=" + idMedida + "]");
	if (!nodoTramos) {
		return false;
	}
	
	var eTramo:FLDomElement;
	var numTramo:Number = 1;
	var rgbColor:String = false;
	for (var nodoTramo:FLDomNode = nodoTramos.firstChild(); nodoTramo; nodoTramo = nodoTramo.nextSibling()) {
		eTramo = nodoTramo.toElement();
		if (numTramo == 1 && parseFloat(eTramo.attribute("Max")) >= valor) {
			rgbColor = eTramo.attribute("Color");
			break;
		}
		if (numTramo == 2 && parseFloat(eTramo.attribute("Min")) < valor && parseFloat(eTramo.attribute("Max")) >= valor) {
			rgbColor = eTramo.attribute("Color");
			break;
		}
		if (numTramo == 3 && parseFloat(eTramo.attribute("Min")) < valor) {
			rgbColor = eTramo.attribute("Color");
			break;
		}
		numTramo++;
	}
debug("rgbColor = " + rgbColor);
	if (!rgbColor) {
		return false;
	}
	var colores:Array = rgbColor.split(",");
	if (!colores || colores.length != 3) {
		return false;
	}
	color.setRgb(colores[0], colores[1], colores[2]);
	return color;
}

/** \D Crea la cabecera de columnas de la tabla basándose en una consulta que devuelve todos los valores que irán en las distintas columnasClaveX
\end */
function oficial_crearCabeceraCol()
{
	var xmlPos:FLDomNode = this.iface.xmlPosActual_.firstChild();

	var ejeMedidas:String = xmlPos.namedItem("Medidas").toElement().attribute("Eje");
	var totalMedidas:Number = this.iface.medidasTabla_.length;
	var medidasColumna:Number = (ejeMedidas == "X" ? totalMedidas : 1);

	if (this.iface.aColumnasTabla_) {
		delete this.iface.aColumnasTabla_;
	}
	this.iface.aColumnasTabla_ = [];

	this.iface.columnasClaveX_ = [];
	var tblDatos:Object = this.child("tblDatos");
	var iColumna:Number = (ejeMedidas == "X" ? this.iface.DAT_C_CABECERA_ + 1 : this.iface.DAT_C_MEDIDA_ + 1);///iCol = this.iface.DAT_C_MEDIDA_ + 1
	for (var i:Number = 0; i < iColumna; i++) {
		this.iface.aColumnasTabla_[i] = this.iface.dameElementoArrayColumnas();
	}

	var idMedida:String;
	var iCol:Number = 0;
	if (this.iface.nivelesX_[0] == "sin niveles") {
		for (var m:Number = 0; m < medidasColumna; m++) {
			idMedida = this.iface.medidasTabla_[m];
			tblDatos.insertColumns(iColumna);
			if (ejeMedidas == "X") {
				tblDatos.setText(this.iface.DAT_F_MEDIDA_, iColumna, this.iface.dameAliasMedida(idMedida));
				tblDatos.setCellAlignment(this.iface.DAT_F_MEDIDA_, iColumna, tblDatos.AlignLeft);
			}
			this.iface.aColumnasTabla_[iColumna] = this.iface.dameElementoArrayColumnas();
			this.iface.aColumnasTabla_[iColumna]["idmedida"] = idMedida;
			iColumna++;
		}
	} else {
		var aValorAnteriorX:Array = new Array(this.iface.nivelesX_.length);
		for (var i:Number = 0; i < aValorAnteriorX.length; i++) {
			aValorAnteriorX[i] = "";
		}
		var consultaX:FLSqlQuery = this.iface.construirConsultaX();
		if (!consultaX || !consultaX.exec()) {
			return false;
		}
		var maxNivelX:Number = this.iface.nivelesX_.length - 1;
		var nivelActual:Number = 0;
		var nivelRotura:Number = 0;
		var columnaNivelActual:String;
		var clave:String;
		var idMedida:String;
		while (consultaX.next()) {
			for (var n:Number = 0; n <= maxNivelX; n++) {
				if (consultaX.value(this.iface.dameColumnaSql(this.iface.nivelesX_[n])) != aValorAnteriorX[n]) {
					nivelRotura = n;
					break;
				}
			}
			for (var n:Number = nivelRotura; n <= maxNivelX; n++) {
				columnaNivelActual = this.iface.dameColumnaSql(this.iface.nivelesX_[n]);
				claveColumna = this.iface.dameClaveColumnaX(n, false, consultaX);
				this.iface.columnasClaveX_[claveColumna] = iColumna;
				aValorAnteriorX[n] = consultaX.value(columnaNivelActual);
				for (var m:Number = 0; m < medidasColumna; m++) {
					idMedida = this.iface.medidasTabla_[m];
					tblDatos.insertColumns(iColumna);
					if (ejeMedidas == "X") {
						tblDatos.setText(this.iface.DAT_F_MEDIDA_, iColumna, this.iface.dameAliasMedida(idMedida));
						tblDatos.setCellAlignment(this.iface.DAT_F_MEDIDA_, iColumna, tblDatos.AlignLeft);
					}
					this.iface.aColumnasTabla_[iColumna] = this.iface.dameElementoArrayColumnas();
					this.iface.aColumnasTabla_[iColumna]["idmedida"] = idMedida;
					this.iface.aColumnasTabla_[iColumna]["nivel"] = n;
					this.iface.aColumnasTabla_[iColumna]["expande"] = (n == maxNivelX ? "" : "S");
					this.iface.aColumnasTabla_[iColumna]["clave"] = consultaX.value(columnaNivelActual);
					this.iface.dameCabeceraColumna(iColumna);
					iColumna++;
				}
			}
		}
	}
}

function oficial_crearCabeceraCol3(maxProps:Number):Boolean
{
	var xmlPos:FLDomNode = this.iface.xmlPosActual_.firstChild();
	
	var aTabla:Array = this.iface.aTabla_;
	var nodoCol:FLDomNode, nodoFil:FLDomNode, eCol:FLDomElement, eFil:FLDomElement;
// 	var eGrafico:FLDomElement;
// 	if (enGrafico) {
// 		eGrafico = this.iface.xmlGrafico_.firstChild().toElement();
// 	}
	var ejeMedidas:String = xmlPos.namedItem("Medidas").toElement().attribute("Eje");
	var totalMedidas:Number = this.iface.medidasTabla_.length;
	var medidasColumna:Number;
	var eFila:FLDomElement, eCol:FLDomElement;
	if (ejeMedidas == "X") {
		medidasColumna = totalMedidas;
		aTabla[this.iface.DAT_F_MEDIDA_] = [];
		eFila = this.iface.dameFilaDatosGraf(this.iface.DAT_F_MEDIDA_);
		eFila.setAttribute("AlineacionH", "AlignLeft");
		eFila.setAttribute("ColorFondo", this.iface.colorDatCabecera_);
	} else {
		medidasColumna = 1;
	}

	if (this.iface.aColumnasTabla_) {
		delete this.iface.aColumnasTabla_;
	}
	this.iface.aColumnasTabla_ = [];

	this.iface.columnasClaveX_ = [];
	
	
// 	var tblDatos:Object;
// 	if (enGrafico) {
// 	} else {
// 		tblDatos = this.child("tblDatos");
// 		tblDatos.setNumCols(0);
// 		tblDatos.setNumRows(0);
// 	}
	
	aTabla[this.iface.DAT_F_CABECERA_] = [];
	eFila = this.iface.dameFilaDatosGraf(this.iface.DAT_F_CABECERA_);
	eFila.setAttribute("AlineacionH", "AlignLeft");
	eFila.setAttribute("ColorFondo", this.iface.colorDatCabecera_);
	//var iColumna:Number = (ejeMedidas == "X" ? this.iface.DAT_C_CABECERA_ + 1 : this.iface.DAT_C_MEDIDA_ + 1);///iCol = this.iface.DAT_C_MEDIDA_ + 1
	var iColumna:Number = (ejeMedidas == "X" ? this.iface.DAT_C_MEDIDA_ : this.iface.DAT_C_MEDIDA_ + 1);
// iColumna += maxProps;
	for (var i:Number = 0; i < iColumna; i++) {
		this.iface.aColumnasTabla_[i] = this.iface.dameElementoArrayColumnas();
		if (ejeMedidas == "X") {
			aTabla[this.iface.DAT_F_MEDIDA_][i] = "";
		}
debug("this.iface.DAT_F_CABECERA_ " + this.iface.DAT_F_CABECERA_);
debug("i " + i);
		aTabla[this.iface.DAT_F_CABECERA_][i] = "";
		eCol = this.iface.crearColDatos(i, i == this.iface.DAT_F_CABECERA_ ? "CabeceraFila" : "CabeceraCol");
		eCol.setAttribute("AlineacionH", "AlignLeft");
// debug("Color FONDO " + this.iface.colorDatCabecera_ + " para col " + i);
		eCol.setAttribute("ColorFondo", this.iface.colorDatCabecera_);
	}

	var idMedida:String;
	var iCol:Number = 0;
	if (this.iface.nivelesX_[0] == "sin niveles") {
		for (var m:Number = 0; m < medidasColumna; m++) {
			idMedida = this.iface.medidasTabla_[m];
			if (ejeMedidas == "X") {
				aTabla[this.iface.DAT_F_MEDIDA_][iColumna] = this.iface.dameAliasMedida(idMedida);
			}
			aTabla[this.iface.DAT_F_CABECERA_][iColumna] = "";
			this.iface.aColumnasTabla_[iColumna] = this.iface.dameElementoArrayColumnas();
			this.iface.aColumnasTabla_[iColumna]["idmedida"] = idMedida;
			iColumna++;
		}
	} else {
		var aValorAnteriorX:Array = new Array(this.iface.nivelesX_.length);
		for (var i:Number = 0; i < aValorAnteriorX.length; i++) {
			aValorAnteriorX[i] = "";
		}
		var consultaX:FLSqlQuery = this.iface.construirConsultaX();
		if (!consultaX || !consultaX.exec()) {
			return false;
		}
		var maxNivelX:Number = this.iface.nivelesX_.length - 1;
		var nivelActual:Number = 0;
		var nivelRotura:Number = 0;
		var columnaNivelActual:String;
		var clave:String;
		var idMedida:String;
		if (consultaX.size() == 0) {
			return false;
		}
		while (consultaX.next()) {
			for (var n:Number = 0; n <= maxNivelX; n++) {
				if (consultaX.value(this.iface.dameColumnaSql(this.iface.nivelesX_[n])) != aValorAnteriorX[n]) {
					nivelRotura = n;
					break;
				}
			}
			for (var n:Number = nivelRotura; n <= maxNivelX; n++) {
				columnaNivelActual = this.iface.dameColumnaSql(this.iface.nivelesX_[n]);
				claveColumna = this.iface.dameClaveColumnaX(n, false, consultaX);
				this.iface.columnasClaveX_[claveColumna] = iColumna;
				aValorAnteriorX[n] = consultaX.value(columnaNivelActual);
				for (var m:Number = 0; m < medidasColumna; m++) {
					idMedida = this.iface.medidasTabla_[m];
					if (ejeMedidas == "X") {
						aTabla[this.iface.DAT_F_MEDIDA_][iColumna] = this.iface.dameAliasMedida(idMedida);
					}
					this.iface.aColumnasTabla_[iColumna] = this.iface.dameElementoArrayColumnas();
					this.iface.aColumnasTabla_[iColumna]["idmedida"] = idMedida;
					this.iface.aColumnasTabla_[iColumna]["nivel"] = n;
					if (n == maxNivelX) {
						this.iface.aColumnasTabla_[iColumna]["expande"] = "";
					} else {
						this.iface.aColumnasTabla_[iColumna]["expande"] = "S";
						eCol = this.iface.crearColDatos(iColumna, "Datos");
						eCol.setAttribute("ColorFondo", this.iface.colorDatTotal_);
					}
					this.iface.aColumnasTabla_[iColumna]["clave"] = consultaX.value(columnaNivelActual);
					aTabla[this.iface.DAT_F_CABECERA_][iColumna] = this.iface.dameCabeceraColumna3(iColumna);
					iColumna++;
				}
			}
		}
	}
	return true;
}

function oficial_ponTextoCelda(iFila:Number, iCol:Number, texto:String):Boolean
{
	var eCelda:FLDomElement = this.iface.dameCeldaDatosGraf(iFila, iCol);
	if (!eCelda) {
		return false;
	}
	eCelda.setAttribute("Texto", texto);
	return true;
}

function oficial_crearColumnaTabla(enGrafico:Boolean, iCol:Number):Boolean
{
	if (enGrafico) {
		var eCol:FLDomElement = this.iface.dameColDatosGraf(iCol);
		if (!eCol) {
			return false;
		}
	} else {
		if (!this.iface.tblDatos_) {
			return false;
		}
		this.iface.tblDatos_.insertColumns(iCol);
	}
	return true;
}

function oficial_ponAlineacionHCelda(iFila:Number, iCol:Number, alineacion:String):Boolean
{
	var eCelda:FLDomElement = this.iface.dameCeldaDatosGraf(iFila, iCol);
	if (!eCelda) {
		return false;
	}
	eCelda.setAttribute("AlineacionH", alineacion);
	return true;
}


/** \D Obtiene una clave compuesta por la concatenación de los valores del eje X desde el nivel 0 hasta un nivel dado. Esta clave se usa para conocer la columna en la que hay que incluir los datos.
@param	nivel: Nivel máximo de la clave
@return	Clave
\end */
function oficial_dameClaveColumnaX(nivel:Number, eRow:FLDomElement, consultaX:FLSqlQuery):String
{
	var claveColumna:String = "";
	if (this.iface.nivelesX_[0] != "sin niveles") {
		for (var i:Number = 0; i <= nivel; i++) {
			if (eRow) {
				claveColumna += eRow.attribute(this.iface.nivelesX_[i]) + "%$&";
			} else {
				claveColumna += consultaX.value(this.iface.dameColumnaSql(this.iface.nivelesX_[i])) + "%$&";
			}
		}
	}
	return claveColumna;
}

/** \D Construye y escribe la descripción de la cabecera de una fila
@param	iFila: Número de fila
\end */
function oficial_dameCabeceraFila(iFila:Number):Boolean
{
	var xmlPos:FLDomNode = this.iface.xmlPosActual_.firstChild();
	var ejeMedidas:String = xmlPos.namedItem("Medidas").toElement().attribute("Eje");

	var tblDatos:Object = this.child("tblDatos");
	var cabecera:String = "";
// 	var nivel:Number = tblDatos.text(iFila, this.iface.DAT_C_NIVEL_);
	var nivel:Number = this.iface.aFilasTabla_[iFila]["nivel"];
	for (var n:Number = 0; n < nivel; n++) {
		cabecera += "  ";
	}
// 	var expand:String = tblDatos.text(iFila, this.iface.DAT_C_EXPAND_);
	var expand:String = this.iface.aFilasTabla_[iFila]["expande"];
	var esTotal:Boolean = false;
	switch (expand) {
		case "S": { cabecera += "(-) "; esTotal = true; break; }
		case "N": { cabecera += "(+) "; esTotal = true; break; }
	}
// 	var clave:String = tblDatos.text(iFila, this.iface.DAT_C_CLAVE_);
	var clave:String = this.iface.aFilasTabla_[iFila]["clave"];
	var nombreNivel:String = this.iface.nivelesY_[nivel];
	if (nombreNivel != "sin niveles") {
		cabecera += this.iface.obtenerDesNivel(nombreNivel, clave);
	}
	tblDatos.setText(iFila, this.iface.DAT_C_CABECERA_, cabecera);
debug("Cabecera para " + iFila + " = " + cabecera);
	if (esTotal) {
		this.iface.cambiarColorFilaTabla(tblDatos, iFila, this.iface.colorDatTotal_);
	} else {
		if (ejeMedidas != "X") {
		tblDatos.setCellBackgroundColor(iFila, this.iface.DAT_C_MEDIDA_, this.iface.colorDatTotal_);
		}
		tblDatos.setCellBackgroundColor(iFila, this.iface.DAT_C_CABECERA_, this.iface.colorDatCabecera_);
	}

	return true;
}

function oficial_informaPropiedadesFila(iFila:Number, maxProps:Number):Boolean
{
// 	return true;
	var aTabla:Array = this.iface.aTabla_;
// debug("oficial_informaPropiedadesFila " + iFila);
	if (this.iface.nivelesY_[0] == "sin niveles") {
		return true;
	}
	var nivel:Number = this.iface.aFilasTabla_[iFila]["nivel"];
	var nombreNivel:String = this.iface.nivelesY_[nivel]["id"]
// debug("nombreNivel " + nombreNivel);
	var clave:String = this.iface.aFilasTabla_[iFila]["clave"];
	var aProps:Array = this.iface.nivelesY_[nivel]["propiedades"];
	var propiedad:String, iMiembro:Number, valorProp:String;
// debug("long " + aProps.length);
	var numProps:Number = aProps.length;
	var iProp:Number;
	for (iProp = 0; iProp < numProps; iProp++) {
		propiedad = aProps[iProp];
// debug("propiedad  " + propiedad );
		if (clave && clave != "") {
			iMiembro = this.iface.niveles_[nombreNivel]["indicemiembros"][clave];
			valorProp = this.iface.niveles_[nombreNivel]["miembros"][iMiembro]["propiedades"][propiedad];
		} else {
			valorProp = "";
		}
		aTabla[iFila][this.iface.DAT_C_CABECERA_ + iProp + 1] = valorProp;
	}
	for (; iProp < maxProps; iProp++) {
		aTabla[iFila][this.iface.DAT_C_CABECERA_ + iProp + 1] = "";
	}
	return true;
}

/** \D Construye y escribe la descripción de la cabecera de una fila
@param	iFila: Número de fila
\end */
function oficial_dameCabeceraFila3(iFila:Number):String
{
	var xmlPos:FLDomNode = this.iface.xmlPosActual_.firstChild();
	var ejeMedidas:String = xmlPos.namedItem("Medidas").toElement().attribute("Eje");

	var cabecera:String = "";
	
	var nivel:Number = this.iface.aFilasTabla_[iFila]["nivel"];
	for (var n:Number = 0; n < nivel; n++) {
		cabecera += "  ";
	}

	var expand:String = this.iface.aFilasTabla_[iFila]["expande"];
	var esTotal:Boolean = false;
	switch (expand) {
		case "S": { cabecera += "(-) "; esTotal = true; break; }
		case "N": { cabecera += "(+) "; esTotal = true; break; }
	}

	var nombreNivel:String;
	var clave:String = this.iface.aFilasTabla_[iFila]["clave"];
	if (this.iface.nivelesY_[0] != "sin niveles") {
		nombreNivel = this.iface.nivelesY_[nivel]["id"];
		cabecera += this.iface.obtenerDesNivel(nombreNivel, clave);
	}
	return cabecera;
	
	
	this.iface.ponTextoCelda(iFila, this.iface.DAT_C_CABECERA_, cabecera);
// 	tblDatos.setText(iFila, this.iface.DAT_C_CABECERA_, cabecera);
debug("Cabecera para " + iFila + " = " + cabecera);
	if (esTotal) {
		this.iface.ponColorFondoFilaDatos(iFila, this.iface.colorDatTotal_);
// 		this.iface.cambiarColorFilaTabla(tblDatos, iFila, this.iface.colorDatTotal_);
	} else {
		if (ejeMedidas != "X") {
			this.iface.ponColorFondoCeldaDatos(iFila, this.iface.DAT_C_MEDIDA_, this.iface.colorDatTotal_);
			/// XXXXXXXX crear ponColorFondoCeldaDatos como ponColorFondoFilaDatos
// 			tblDatos.setCellBackgroundColor(iFila, this.iface.DAT_C_MEDIDA_, this.iface.colorDatTotal_);
		}
		this.iface.ponColorFondoCeldaDatos(iFila, this.iface.DAT_C_CABECERA_, this.iface.colorDatCabecera_);
// 		tblDatos.setCellBackgroundColor(iFila, this.iface.DAT_C_CABECERA_, this.iface.colorDatCabecera_);
	}

	return true;
}

/** \D Construye y escribe la descripción de la cabecera de una columna
@param	iCol: Número de columna
\end */
function oficial_dameCabeceraColumna(iCol:Number):Boolean
{
	var xmlPos:FLDomNode = this.iface.xmlPosActual_.firstChild();
	var ejeMedidas:String = xmlPos.namedItem("Medidas").toElement().attribute("Eje");

	var tblDatos:Object = this.child("tblDatos");
	var cabecera:String = "";
// 	var nivel:Number = tblDatos.text(this.iface.DAT_F_NIVEL_, iCol);
	var nivel:Number = this.iface.aColumnasTabla_[iCol]["nivel"];
// 	var expand:String = tblDatos.text(this.iface.DAT_F_EXPAND_, iCol);
	var expand:String = this.iface.aColumnasTabla_[iCol]["expande"];
	var esTotal:Boolean = false;
	switch (expand) {
		case "S": { cabecera += "(-) "; esTotal = true; break; }
		case "N": { cabecera += "(+) "; esTotal = true; break; }
	}
// 	var clave:String = tblDatos.text(this.iface.DAT_F_CLAVE_, iCol);
	var clave:String = this.iface.aColumnasTabla_[iCol]["clave"];
	var nombreNivel:String = this.iface.nivelesX_[nivel];
	if (nombreNivel != "sin niveles") {
		cabecera += this.iface.obtenerDesNivel(nombreNivel, clave);
	}
debug("Cabecera " + iCol + " = " + cabecera);
	tblDatos.setText(this.iface.DAT_F_CABECERA_, iCol, cabecera);
	if (esTotal) {
		this.iface.cambiarColorColumnaTabla(tblDatos, iCol, this.iface.colorDatTotal_);
	} else {
		if (ejeMedidas == "X") {
			tblDatos.setCellBackgroundColor(this.iface.DAT_F_MEDIDA_, iCol, this.iface.colorDatTotal_);
		}
		tblDatos.setCellBackgroundColor(this.iface.DAT_F_CABECERA_, iCol, this.iface.colorDatCabecera_);
	}

	return true;
}

function oficial_dameCabeceraColumna3(iCol:Number):String
{
	var xmlPos:FLDomNode = this.iface.xmlPosActual_.firstChild();
	var ejeMedidas:String = xmlPos.namedItem("Medidas").toElement().attribute("Eje");

	var tblDatos:Object = this.child("tblDatos");
	var cabecera:String = "";
// 	var nivel:Number = tblDatos.text(this.iface.DAT_F_NIVEL_, iCol);
	var nivel:Number = this.iface.aColumnasTabla_[iCol]["nivel"];
// 	var expand:String = tblDatos.text(this.iface.DAT_F_EXPAND_, iCol);
	var expand:String = this.iface.aColumnasTabla_[iCol]["expande"];
	var esTotal:Boolean = false;
	switch (expand) {
		case "S": { cabecera += "(-) "; esTotal = true; break; }
		case "N": { cabecera += "(+) "; esTotal = true; break; }
	}
// 	var clave:String = tblDatos.text(this.iface.DAT_F_CLAVE_, iCol);
	var clave:String = this.iface.aColumnasTabla_[iCol]["clave"];
	var nombreNivel:String = this.iface.nivelesX_[nivel];
	if (nombreNivel != "sin niveles") {
		cabecera += this.iface.obtenerDesNivel(nombreNivel, clave);
	}
	return cabecera;
	
debug("Cabecera " + iCol + " = " + cabecera);
	tblDatos.setText(this.iface.DAT_F_CABECERA_, iCol, cabecera);
	if (esTotal) {
		this.iface.cambiarColorColumnaTabla(tblDatos, iCol, this.iface.colorDatTotal_);
	} else {
		if (ejeMedidas == "X") {
			tblDatos.setCellBackgroundColor(this.iface.DAT_F_MEDIDA_, iCol, this.iface.colorDatTotal_);
		}
		tblDatos.setCellBackgroundColor(this.iface.DAT_F_CABECERA_, iCol, this.iface.colorDatCabecera_);
	}

	return true;
}

function oficial_dameColumnaAgregadaSql(nombreMedida:String):String
{
	var columna:String =
this.iface.medidas_[nombreMedida]["element"].attribute("column");
	var peso:String =
this.iface.medidas_[nombreMedida]["element"].attribute("peso");

	var funAgregacion:String =
	this.iface.dameSqlAgregacion(nombreMedida);
	var valor:String;
	switch(funAgregacion) {
		case "AVG": {
			valor = "SUM(" + columna + "*" + peso 
			+ ")/SUM(" + peso + ")";
			break;
		}
		default: {
			valor = funAgregacion + "(" + columna + ")";
			break;
		}
	}
	return valor;
}

function oficial_dameSqlAgregacion(nombreMedida:String):String
{
	var valor:String = "SUM";
	var funElemento:String =
this.iface.medidas_[nombreMedida]["element"].attribute("aggregator");
	switch(funElemento) {
		case "avg": {
			valor = "AVG";
			break;
		}
		default: {
			valor = "SUM";
			break;
		}
	}
	
	return valor;
}

function oficial_tblDatos_doubleClicked(row:Number, col:Number):String
{
	var tblDatos = this.child("tblDatos");
	if (col == this.iface.DAT_C_CABECERA_) {
		var expand:String = this.iface.aFilasTabla_[row]["expande"];
		switch (expand) {
			case "S": {
				this.iface.contraerFila(row);
				this.iface.aFilasTabla_[row]["expande"] = "N";
				tblDatos.setText(row, this.iface.DAT_C_CABECERA_, this.iface.dameCabeceraFila3(row));
				break;
			}
			case "N": {
				this.iface.expandirFila(row);
				this.iface.aFilasTabla_[row]["expande"] = "S";
				tblDatos.setText(row, this.iface.DAT_C_CABECERA_, this.iface.dameCabeceraFila3(row));
				break;
			}
		}
	} else if (row == this.iface.DAT_F_CABECERA_) {
		var expand:String = this.iface.aColumnasTabla_[col]["expande"];
		switch (expand) {
			case "S": {
				this.iface.contraerColumna(col);
				this.iface.aColumnasTabla_[col]["expande"] = "N";
				this.iface.dameCabeceraColumna(col);
				break;
			}
			case "N": {
				this.iface.expandirColumna(col);
// 				tblDatos.setText(this.iface.DAT_F_EXPAND_, col, "S");
				this.iface.aColumnasTabla_[col]["expande"] = "S";
				this.iface.dameCabeceraColumna(col);
				break;
			}
		}
	}
}

function oficial_contraerFila(row:Number):Boolean
{
	var tblDatos = this.child("tblDatos");
	var maxFilas:Number = tblDatos.numRows();
// 	var nivel:Number = parseInt(tblDatos.text(row, this.iface.DAT_C_NIVEL_));
	var nivel:Number = this.iface.aFilasTabla_[row]["nivel"];
	nivel++;
	var fila:Number = row + 1;
// 	while (fila < maxFilas && parseInt(tblDatos.text(fila, this.iface.DAT_C_NIVEL_)) >= nivel) {
	while (fila < maxFilas && this.iface.aFilasTabla_[fila]["nivel"] >= nivel) {
		tblDatos.hideRow(fila);
		fila++;
	}
	return true;
}

function oficial_contraerColumna(col:Number):Boolean
{
	var tblDatos = this.child("tblDatos");
	var maxCols:Number = tblDatos.numCols();
// 	var nivel:Number = parseInt(tblDatos.text(this.iface.DAT_F_NIVEL_, col));
	var nivel:Number = this.iface.aColumnasTabla_[col]["nivel"];
	nivel++;
	var columna:Number = col + 1;
// 	while (columna < maxCols && parseInt(tblDatos.text(this.iface.DAT_F_NIVEL_, columna)) >= nivel) {
	while (columna < maxCols && this.iface.aColumnasTabla_[columna]["nivel"] >= nivel) {
		tblDatos.hideColumn(columna);
		columna++;
	}
	return true;
}

function oficial_expandirFila(row:Number):Boolean
{
	var tblDatos = this.child("tblDatos");
	var maxFilas:Number = tblDatos.numRows();
// 	var nivel:Number = parseInt(tblDatos.text(row, this.iface.DAT_C_NIVEL_));
	var nivel:Number = this.iface.aFilasTabla_[row]["nivel"];
	nivel++;
	var fila:Number = row + 1;
// 	var nivelFila:Number = parseInt(tblDatos.text(fila, this.iface.DAT_C_NIVEL_));
	var nivelFila:Number = this.iface.aFilasTabla_[fila]["nivel"];
	while (nivelFila >= nivel) {
		if (nivelFila == nivel) {
			tblDatos.showRow(fila);
// 			if (tblDatos.text(fila, this.iface.DAT_C_EXPAND_) == "S") {
			if (this.iface.aFilasTabla_[fila]["expande"] == "S") {
				this.iface.expandirFila(fila);
			}
		}
		fila++;
		if (fila == maxFilas) {
			break;
		}
// 		nivelFila = parseInt(tblDatos.text(fila, this.iface.DAT_C_NIVEL_));
		nivelFila = this.iface.aFilasTabla_[fila]["nivel"];
	}
	return true;
}

function oficial_expandirColumna(col:Number):Boolean
{
	var tblDatos = this.child("tblDatos");
	var maxCols:Number = tblDatos.numCols();
// 	var nivel:Number = parseInt(tblDatos.text(this.iface.DAT_F_NIVEL_, col));
	var nivel:Number = this.iface.aColumnasTabla_[col]["nivel"];
	nivel++;
	var columna:Number = col + 1;
// 	var nivelColumna:Number = parseInt(tblDatos.text(this.iface.DAT_F_NIVEL_, columna));
	nivelColumna = this.iface.aColumnasTabla_[columna]["nivel"];
	while (nivelColumna >= nivel) {
		if (nivelColumna == nivel) {
			tblDatos.showColumn(columna);
// 			if (tblDatos.text(this.iface.DAT_F_EXPAND_, columna) == "S") {
			if (this.iface.aColumnasTabla_[columna]["expande"] == "S") {
				this.iface.expandirColumna(columna);
			}
		}
		columna++;
		if (columna == maxCols) {
			break;
		}
// 		nivelColumna = parseInt(tblDatos.text(this.iface.DAT_F_NIVEL_, columna));
		nivelColumna = this.iface.aColumnasTabla_[columna]["nivel"];
	}
	return true;
}

function oficial_tbnDimY_clicked()
{
	var f:Object = new FLFormSearchDB("in_eje");
	var curEje:FLSqlCursor = f.cursor();
	curEje.select("idusuario = '" + sys.nameUser() + "'");
	if (curEje.first()) {
		curEje.setModeAccess(curEje.Edit);
	} else {
		curEje.setModeAccess(curEje.Insert);
	}
	curEje.refreshBuffer();
	curEje.setValueBuffer("idusuario", sys.nameUser());
	curEje.setValueBuffer("eje", "Y");
	f.setMainWidget();
	f.exec();
	if (!f.accepted()) {
		return false;
	}

	this.iface.cargarPosicion(true);
}

function oficial_tbnDimX_clicked()
{
	var f:Object = new FLFormSearchDB("in_eje");
	var curEje:FLSqlCursor = f.cursor();
	curEje.select("idusuario = '" + sys.nameUser() + "'");
	if (curEje.first()) {
		curEje.setModeAccess(curEje.Edit);
	} else {
		curEje.setModeAccess(curEje.Insert);
	}
	curEje.refreshBuffer();
	curEje.setValueBuffer("idusuario", sys.nameUser());
	curEje.setValueBuffer("eje", "X");
	f.setMainWidget();
	f.exec();
	if (!f.accepted()) {
		return false;
	}

	this.iface.cargarPosicion(true);
}

function oficial_bgrMedidas_clicked(iBoton)
{
	if (this.iface.bloqueoMedidas_) {
		return;
	}
	var xmlPos:FLDomNode = this.iface.xmlPosActual_.firstChild();
	var nodoMedidas:FLDomNode = xmlPos.namedItem("Medidas");
	var eMedidas:FLDomElement = nodoMedidas.toElement();
	if (iBoton == 0) { /// Filas
		eMedidas.setAttribute("Eje", "Y");
	} else {
		eMedidas.setAttribute("Eje", "X");
	}
	this.iface.cargarPosicion(true);
}

function oficial_tblMedidas_doubleClicked(fil:Number, col:Number)
{
	var tblMedidas = this.child("tblMedidas");
	var sel:String = tblMedidas.text(fil, this.iface.CM_SEL);
	if (sel == "S") {
		tblMedidas.setText(fil, this.iface.CM_SEL, "N");
		this.iface.cambiarColorFilaTabla(tblMedidas, fil, this.iface.colorMedNoSel_);
	} else {
		tblMedidas.setText(fil, this.iface.CM_SEL, "S");
		this.iface.cambiarColorFilaTabla(tblMedidas, fil, this.iface.colorMedSel_);
	}
	tblMedidas.repaintContents()
	this.iface.actualizarMedidas();
}

function oficial_actualizarMedidas()
{
	var xmlPos:FLDomNode = this.iface.xmlPosActual_.firstChild();
	var nodoMedidas:FLDomNode = xmlPos.namedItem("Medidas");
	var nodoMedida:FLDomNode;
	while (nodoMedidas.hasChildNodes()) {
		nodoMedida = nodoMedidas.firstChild();
		nodoMedidas.removeChild(nodoMedida);
	}
// 	for (nodoMedida = nodoMedidas.firstChild(); nodoMedida; nodoMedida = nodoMedida.nextSibling()) {
// 		nodoMedidas.removeChild(nodoMedida);
// 	}
	var eMedida:FLDomElement;
	var tblMedidas:FLTable = this.child("tblMedidas");
	for (var iFila:Number = 0; iFila < tblMedidas.numRows(); iFila++) {
		if (tblMedidas.text(iFila, this.iface.CM_SEL) == "S") {
			eMedida = this.iface.xmlPosActual_.createElement("Medida");
			eMedida.setAttribute("Id", tblMedidas.text(iFila, this.iface.CM_NOMBRE));
			nodoMedidas.appendChild(eMedida);
		}
	}
	this.iface.cargarPosicion(true);
}

function oficial_conectar():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor()
	
	var baseDatosLocal:String = fldireinne.iface.pub_valorConfiguracion("basedatoslocal");
	if (baseDatosLocal == "Ambas") {
		this.iface.conexion_ = false;
		this.iface.conexionBI_ = false;
		return true;
	}
	var datosConexion:String = "";
	var nombreBD:String = fldireinne.iface.pub_valorConfiguracion("basedatos");
	datosConexion += "\n" + util.translate("scripts", "Base de datos %1").arg(nombreBD);
	var host:String = fldireinne.iface.pub_valorConfiguracion("servidor");
	datosConexion += "\n" + util.translate("scripts", "Servidor %1").arg(host);
	var driver:String = fldireinne.iface.pub_valorConfiguracion("driver");
	datosConexion += "\n" + util.translate("scripts", "Driver %1").arg(driver);
	var puerto:String = fldireinne.iface.pub_valorConfiguracion("puerto");
	datosConexion += "\n" + util.translate("scripts", "Puerto %1").arg(puerto);
	var requiereContra:Boolean = fldireinne.iface.pub_valorConfiguracion("requierecontra");
	
	if (!driver || !nombreBD || !host) {
		MessageBox.warning(util.translate("scripts", "Debe indicar los datos de conexión en la opción Configuración de este módulo"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var tipoDriver:String;
	if (sys.nameDriver().search("PSQL") > -1) {
		tipoDriver = "PostgreSQL";
	} else {
		tipoDriver = "MySQL";
	}

	if (host == sys.nameHost() && nombreBD == sys.nameBD() && driver == tipoDriver) {
		this.iface.conexion_ = false;
		return true;
	}

	var usuario:String = sys.nameUser();
	this.iface.pedirPassword();
	var password:String = this.iface.password;
	debug("Conectando..");

	if (baseDatosLocal == "Origen") {
		this.iface.conexion_ = false;
		this.iface.conexionBI_ = "BI";
		if (!sys.addDatabase(driver, nombreBD, usuario, password, host, puerto, this.iface.conexionBI_)) {
			MessageBox.warning(util.translate("scripts", "Error en la conexión:%1").arg(datosConexion), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	} else {
		this.iface.conexion_ = "CX";
		this.iface.conexionBI_ = false;
		if (!sys.addDatabase(driver, nombreBD, usuario, password, host, puerto, this.iface.conexion_)) {
			MessageBox.warning(util.translate("scripts", "Error en la conexión:%1").arg(datosConexion), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}
	
	this.iface.password = "";
	
	return true;
}

function oficial_pedirPassword()
{
	this.iface.password = "";
	
	var f:Object = new FLFormSearchDB("in_pedirpassword");
	var cursor:FLSqlCursor = f.cursor();
	
	cursor.setActivatedCheckIntegrity(false);
	cursor.select();
	if (!cursor.first()) {
		cursor.setModeAccess(cursor.Insert);
	} else {
		cursor.setModeAccess(cursor.Edit);
	}

	f.setMainWidget();
	cursor.refreshBuffer();
	f.exec("id");
}

function oficial_establecerCubo()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	this.iface.cubo_ = util.readSettingEntry("scripts/fldireinne/cuboactual");
	if (!this.iface.cubo_ || this.iface.cubo_ == "") {
		this.iface.seleccionarCubo();
		if (!this.iface.cubo_) {
			return false;
		}
	}
	this.child("txtNombreCubo").text = this.iface.nombreCubo(this.iface.cubo_);
}

function oficial_seleccionarCubo()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var aCubos:Array = [];
	this.iface.informarArrayCubos(aCubos);
	var aDesCubos:Array = new Array(aCubos.length);
	for (var i:Number = 0; i < aCubos.length; i++) {
		aDesCubos[i] = this.iface.nombreCubo(aCubos[i]);
	}
	var idOpcion:Number = fldireinne.iface.pub_elegirOpcion(aDesCubos, util.translate("scripts", "Seleccione cubo"));
debug("idOpcion = " + idOpcion);
	if (idOpcion < 0) {
		this.iface.cubo_ = false;
	} else {
		this.iface.cubo_ = aCubos[idOpcion];
		util.writeSettingEntry("scripts/fldireinne/cuboactual", this.iface.cubo_);
	}
debug("this.iface.cubo_ = " + this.iface.cubo_);
}

function oficial_informarArrayCubos(aCubos:Array):Boolean
{
	aCubos[aCubos.length] = "in_h_ventas";
	return true;
}

function oficial_nombreCubo(idCubo:String):String
{
	var util:FLUtil = new FLUtil;
	var nombre:String;
	switch (idCubo) {
		case "in_h_ventas": {
			nombre = util.translate("scripts", "Ventas");
			break;
		}
	}
	return nombre;
}

function oficial_tbnCubo_clicked()
{
	this.iface.seleccionarCubo();
	if (!this.iface.cubo_) {
		return false;
	}
	this.child("txtNombreCubo").text = this.iface.nombreCubo(this.iface.cubo_);
	this.iface.iniciarTablaDimensiones();
	this.iface.cargarHome();
}

function oficial_tbwResultados_currentChanged(tab:String)
{
	var util:FLUtil = new FLUtil;
	switch (tab) {
		case "tabla": {
			this.iface.interfazDatos_ = "TABLA";
			break;
		}
		case "grafico": {
			this.iface.interfazDatos_ = "GRAFICO";
			break;
		}
		case "informe": {
			this.iface.interfazDatos_ = "INFORME";
			break;
		}
	}
	this.iface.mostrarDatos();
}

function oficial_cargarFormatoInforme()
{
	var util:FLUtil = new FLUtil;

	if (this.iface.xmlReportTemplate_) {
		delete this.iface.xmlReportTemplate_;
		this.iface.xmlReportTemplate_ = false;
	}
	this.iface.xmlReportTemplate_ = new FLDomDocument();
	var xmlPos:FLDomElement = this.iface.xmlPosActual_.firstChild();
	var xmlInforme:FLDomNode = fldireinne.iface.pub_dameNodoXML(xmlPos, "Informe/KugarTemplate");
	if (xmlInforme) {
		this.iface.xmlReportTemplate_.appendChild(xmlInforme.cloneNode(true));
	}
	
	return true;
}

function oficial_cargarFormatoGrafico()
{
debug("oficial_cargarFormatoGrafico");
	var util:FLUtil = new FLUtil;

// 	if (this.iface.tipoGrafico_ == "2d_tabla") {
// 		return this.iface.cargarFormatoGraficoTabla();
// 	}
	
	
	if (this.iface.xmlGrafico_) {
		var tipoActual:String = this.iface.xmlGrafico_.firstChild().toElement().attribute("Tipo");
		if (tipoActual == this.iface.tipoGrafico_) {
			return true;
		}
		delete this.iface.xmlGrafico_;
	}
	this.iface.xmlGrafico_ = new FLDomDocument();
	var xmlPos:FLDomElement = this.iface.xmlPosActual_.firstChild();
// debug("Tipo = " + this.iface.tipoGrafico_);
// debug("xmlPos " + xmlPos.toString(4));
	var xmlGrafico:FLDomNode = fldireinne.iface.pub_dameNodoXML(xmlPos, "Graficos/Grafico[@Tipo=" + this.iface.tipoGrafico_ + "]");
	var xmlFormatoGrafico:FLDomNode;
	if (xmlGrafico) {
// debug("Encontrado");
		delete this.iface.xmlGrafico_;
		this.iface.xmlGrafico_ = new FLDomDocument;
		xmlFormatoGrafico = xmlGrafico.cloneNode(true);
		this.iface.xmlGrafico_.appendChild(xmlFormatoGrafico);
	} else {
// debug("NO Encontrado");
		var graficoDefecto:String;
		if (this.iface.tipoGrafico_ == "2d_mapa") {
			var tipoMapa:String = this.iface.dameTipo2dMapa()
			if (!tipoMapa) {
				MessageBox.warning(util.translate("scripts", "La posición actual es representable en un mapa"), MessageBox.Ok, MessageBox.NoButton);
				return false;
			}
			graficoDefecto = flgraficos.iface.pub_dameGraficoDefecto(this.iface.tipoGrafico_, tipoMapa);
		} else {
			graficoDefecto = flgraficos.iface.pub_dameGraficoDefecto(this.iface.tipoGrafico_);
		}
// 		debug("graficoDefecto " + graficoDefecto);
		if (!graficoDefecto) {
			this.iface.xmlGrafico_ = false;
			MessageBox.warning(util.translate("scripts", "El tipo de gráfico %1 no tiene formato por defecto").arg(this.iface.tipoGrafico_), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
		if (!this.iface.xmlGrafico_.setContent(graficoDefecto)) {
			return false;
		}
		this.iface.xmlGrafico_.firstChild().toElement().setAttribute("Titulo", "");
	}
	
	return true;
}


// function oficial_cargarFormatoGraficoTabla()
// {
// 	var util:FLUtil = new FLUtil;
// 
// 	if (this.iface.xmlGraficoTabla_) {
// 		return true;
// 		
// // 		delete this.iface.xmlGraficoTabla_;
// 	}
// 	this.iface.xmlGraficoTabla_ = new FLDomDocument();
// 	var xmlPos:FLDomElement = this.iface.xmlPosActual_.firstChild();
// 	var xmlGrafico:FLDomNode = fldireinne.iface.pub_dameNodoXML(xmlPos, "Graficos/Grafico[@Tipo=2d_tabla]");
// 	var xmlFormatoGrafico:FLDomNode;
// 	if (xmlGrafico) {
// 		xmlFormatoGrafico = xmlGrafico.cloneNode(true);
// 		this.iface.xmlGraficoTabla_.appendChild(xmlFormatoGrafico);
// 	} else {
// 		var graficoDefecto:String = flgraficos.iface.pub_dameGraficoDefecto("2d_tabla");
// 		if (!graficoDefecto) {
// 			this.iface.xmlGraficoTabla_ = false;
// 			MessageBox.warning(util.translate("scripts", "El tipo de gráfico %1 no tiene formato por defecto").arg("2d_tabla"), MessageBox.Ok, MessageBox.NoButton);
// 			return false;
// 		}
// 		if (!this.iface.xmlGraficoTabla_.setContent(graficoDefecto)) {
// 			return false;
// 		}
// 		this.iface.xmlGraficoTabla_.firstChild().toElement().setAttribute("Titulo", "");
// 	}
// 	
// 	return true;
// }

function oficial_construir2dTartaDefecto()
{
	if (this.iface.xmlGrafico_) {
		delete this.iface.xmlGrafico_;
	}
	this.iface.xmlGrafico_ = new FLDomDocument();
	var xmlGrafico:FLDomDocument = formin_navegador.iface.xmlGrafico_;
	xmlGrafico.setContent("<Grafico Tipo='2d_tarta' />");
	
	var eGrafico:FLDomElement = xmlGrafico.firstChild().toElement();
	var devSize = this.child( "lblGrafico" ).size;
	eGrafico.setAttribute("Alto", devSize.height);
	eGrafico.setAttribute("Ancho", devSize.width);

	var margenDerecho:Number = 5;
	var margenIzquierdo:Number = 5;
	var margenSuperior:Number = 5;
	var margenInferior:Number = 5;
// 	var margenLabelsX:Number = 20;
// 	var margenLabelsY:Number = 50;
// 	var anguloLabelX:Number = 0;

	var altoLey:Number = 20;
	var anchoLey:Number = 100;

	eGrafico.setAttribute("MargenDerecho", margenDerecho);
	eGrafico.setAttribute("MargenIzquierdo", margenIzquierdo);
	eGrafico.setAttribute("MargenSuperior", margenSuperior);
	eGrafico.setAttribute("MargenInferior", margenInferior);

// 	var eEjeX:FLDomElement = xmlGrafico.createElement("EjeX");
// 	eGrafico.appendChild(eEjeX);
// 	eEjeX.setAttribute("Min", "1");
// 	eEjeX.setAttribute("MarcarCada", "1");
// 	eEjeX.setAttribute("MarcarLabels", "false");
// 	eEjeX.setAttribute("MargenLabels", margenLabelsY);
// 	eEjeX.setAttribute("AnguloLabel", anguloLabelX);

// 	var eEjeY:FLDomElement = xmlGrafico.createElement("EjeY");
// 	eGrafico.appendChild(eEjeY);
// 	eEjeY.setAttribute("Min", "0");
// // 	eEjeY.setAttribute("MarcarCada", marcarCadaY);
// 	eEjeY.setAttribute("MarcarLabels", "true");
// 	eEjeY.setAttribute("MargenLabels", margenLabelsY);
	
	var eLeyenda:FLDomElement = xmlGrafico.createElement("Leyenda");
	eGrafico.appendChild(eLeyenda);
	eLeyenda.setAttribute("Posicion", "Arriba");
	eLeyenda.setAttribute("Alto", altoLey);
	eLeyenda.setAttribute("Ancho", anchoLey);

	var eValores:FLDomElement = xmlGrafico.createElement("Valores");
	eGrafico.appendChild(eValores);

	return true;
}

function oficial_construir1dAgujaDefecto()
{
	if (this.iface.xmlGrafico_) {
		delete this.iface.xmlGrafico_;
	}
	this.iface.xmlGrafico_ = new FLDomDocument();
	var xmlGrafico:FLDomDocument = formin_navegador.iface.xmlGrafico_;
	xmlGrafico.setContent("<Grafico Tipo='1daguja' />");
	
	var eGrafico:FLDomElement = xmlGrafico.firstChild().toElement();
	var devSize = this.child( "lblGrafico" ).size;
	eGrafico.setAttribute("Alto", devSize.height);
	eGrafico.setAttribute("Ancho", devSize.width);

	var margenDerecho:Number = 5;
	var margenIzquierdo:Number = 5;
	var margenSuperior:Number = 5;
	var margenInferior:Number = 5;

	var altoLey:Number = 20;
	var anchoLey:Number = 100;

	eGrafico.setAttribute("MargenDerecho", margenDerecho);
	eGrafico.setAttribute("MargenIzquierdo", margenIzquierdo);
	eGrafico.setAttribute("MargenSuperior", margenSuperior);
	eGrafico.setAttribute("MargenInferior", margenInferior);

	var eValores:FLDomElement = xmlGrafico.createElement("Valores");
	eGrafico.appendChild(eValores);

	return true;
}

function oficial_construir2dMapaProvDefecto(contenedor:Object, marco:Rect)
{
	if (this.iface.xmlGrafico_) {
		delete this.iface.xmlGrafico_;
	}
	this.iface.xmlGrafico_ = new FLDomDocument();
	var xmlGrafico:FLDomDocument = formin_navegador.iface.xmlGrafico_;
	xmlGrafico.setContent("<Grafico Tipo='2d_mapaproves' />");
	
	var eGrafico:FLDomElement = xmlGrafico.firstChild().toElement();
	var devSize = (contenedor ? contenedor.size : this.child( "lblGrafico" ).size);
	eGrafico.setAttribute("Alto", devSize.height);
	eGrafico.setAttribute("Ancho", devSize.width);
/*
	var margenDerecho:Number = 5;
	var margenIzquierdo:Number = 5;
	var margenSuperior:Number = 5;
	var margenInferior:Number = 5;*/

	var altoLey:Number = 20;
	var anchoLey:Number = 100;

// 	eGrafico.setAttribute("MargenDerecho", margenDerecho);
// 	eGrafico.setAttribute("MargenIzquierdo", margenIzquierdo);
// 	eGrafico.setAttribute("MargenSuperior", margenSuperior);
// 	eGrafico.setAttribute("MargenInferior", margenInferior);

	var eValores:FLDomElement = xmlGrafico.createElement("Valores");
	eGrafico.appendChild(eValores);

	return true;
}

function oficial_construir2dMapaPaisesDefecto(contenedor:Object, marco:Rect)
{
	if (this.iface.xmlGrafico_) {
		delete this.iface.xmlGrafico_;
	}
	this.iface.xmlGrafico_ = new FLDomDocument();
	var xmlGrafico:FLDomDocument = formin_navegador.iface.xmlGrafico_;
	xmlGrafico.setContent("<Grafico Tipo='2d_mapapaiseseu' />");
	
	var eGrafico:FLDomElement = xmlGrafico.firstChild().toElement();
	var devSize = (contenedor ? contenedor.size : this.child( "lblGrafico" ).size);
	eGrafico.setAttribute("Alto", devSize.height);
	eGrafico.setAttribute("Ancho", devSize.width);
/*
	var margenDerecho:Number = 5;
	var margenIzquierdo:Number = 5;
	var margenSuperior:Number = 5;
	var margenInferior:Number = 5;*/

	var altoLey:Number = 20;
	var anchoLey:Number = 100;

// 	eGrafico.setAttribute("MargenDerecho", margenDerecho);
// 	eGrafico.setAttribute("MargenIzquierdo", margenIzquierdo);
// 	eGrafico.setAttribute("MargenSuperior", margenSuperior);
// 	eGrafico.setAttribute("MargenInferior", margenInferior);

	var eValores:FLDomElement = xmlGrafico.createElement("Valores");
	eGrafico.appendChild(eValores);

	return true;
}

/** Construye un array con los elementos del nivel 
@param idNivel: Identificador del nivel 
\end */
function oficial_dameElementosX(idNivel:String):Array
{
debug("oficial_dameElementosX");
	var elementos:Array = [];
	var consultaX:FLSqlQuery = this.iface.construirConsultaX();
	if (!consultaX || !consultaX.exec()) {
		return false;
	}
	var i:Number = 0;
	while (consultaX.next()) {
		elementos[i] = consultaX.value(this.iface.dameColumnaSql(idNivel));
debug("Elemento " + i + " = " + elementos[i]);
		i++;
	}
	return elementos;
}

/** \D Redondea un número para establecer las marcas del gráfico en intervalos redondeados
@param valor: Valor a redondear
@return	Valor redondeado
\end */
function oficial_redondearEjeY2dBarras(valor:Number):Number
{
	var v:Number = valor;
	var pot:Number = 0;
	while (v > 10) {
		v = v / 10;
		pot++;
	}
	v = Math.round(v);
	if (v == 0) {
		v = 1;
	}
	for (var i:Number; i < pot; i++) {
		v = v * 10;
	}

	return v;
}

function oficial_tbnTipoGrafico_clicked()
{
	var util:FLUtil = new FLUtil;
	var aDesOpciones:Array = [];
	var aOpciones:Array = [];
	this.iface.incluirOpcionesTG(aOpciones, aDesOpciones);

	var opcion:Number = fldireinne.iface.pub_elegirOpcion(aDesOpciones, util.translate("scripts", "Seleccione gráfico"));
	if (opcion < 0) {
		return;
	}
	this.iface.tipoGrafico_ = aOpciones[opcion];
// 	this.iface.interfazDatos_ = aOpciones[opcion];
	this.iface.mostrarDatos();
}

function oficial_tbn2dBarras_clicked()
{
	this.iface.tipoGrafico_ = "2d_barras";
	this.iface.graficoMostrado_ = false;
	this.iface.mostrarDatos();
}

function oficial_tbn2dTabla_clicked()
{
	this.iface.tipoGrafico_ = "2d_tabla";
	this.iface.graficoMostrado_ = false;
	this.iface.mostrarDatos();
}

function oficial_tbn2dLineas_clicked()
{
	this.iface.tipoGrafico_ = "lineal";
	this.iface.graficoMostrado_ = false;
	this.iface.mostrarDatos();
}
	
function oficial_tbn2dTarta_clicked()
{
	this.iface.tipoGrafico_ = "2dtarta";
	this.iface.graficoMostrado_ = false;
	this.iface.mostrarDatos();
}

function oficial_tbn1dAguja_clicked()
{
	this.iface.tipoGrafico_ = "1daguja";
	this.iface.graficoMostrado_ = false;
	this.iface.mostrarDatos();
}

function oficial_tbn2dMapa_clicked()
{
	this.iface.tipoGrafico_ = "2d_mapa";
	this.iface.graficoMostrado_ = false;
	this.iface.mostrarDatos();
}

// function oficial_tbn2dMapaPaises_clicked()
// {
// 	this.iface.tipoGrafico_ = "2d_mapapaiseseu";
// 	this.iface.graficoMostrado_ = false;
// 	this.iface.mostrarDatos();
// }

function oficial_incluirOpcionesTG(aOpciones:Array, aDesOpciones:Array):Boolean
{
	var util:FLUtil = new FLUtil;

	aOpciones[aOpciones.length] = "2d_barras";
	aDesOpciones[aDesOpciones.length] = util.translate("scripts", "Barras");

	aOpciones[aOpciones.length] = "2dtarta";
	aDesOpciones[aDesOpciones.length] = util.translate("scripts", "Tarta");

	aOpciones[aOpciones.length] = "1daguja";
	aDesOpciones[aDesOpciones.length] = util.translate("scripts", "Aguja");

	return true;
}

function oficial_mostrarErrorGrafico2(mensaje:String, contenedor)
{
	var devSize = (contenedor ? contenedor.size : this.child( "lblGrafico" ).size);
	var alto:Number = devSize.height;
	var ancho:Number = devSize.height;
	var x:Number = ancho * 0.2;
	var y:Number = alto * 0.2;
	
	var clrFondo = new Color();
	var clrTinta = new Color();
	clrFondo.setRgb(200, 200, 200);
	clrTinta.setRgb(0, 0, 0);

	var pic:Picture = new Picture;
	pic.begin();
	var lblPix = (contenedor ? contenedor : this.child( "lblGrafico" ));
	var pix = new Pixmap();
	pix.resize( devSize );
	pix.fill( clrFondo );
	pic.setPen(clrTinta);
	pic.drawText(x, y, mensaje);
	pix = pic.playOnPixmap( pix );
	lblPix.pixmap = pix;
	pic.end();
}

function oficial_mostrarErrorGrafico(mensaje:String, marco:Rect):Boolean
{
	var devSize = (marco ? new Size(marco.width, marco.height) : this.child( "lblGrafico" ).size);
	var alto:Number = devSize.height;
	var ancho:Number = devSize.height;
	var x:Number = ancho * 0.2;
	var y:Number = alto * 0.2;
	
	var pic:Picture = new Picture;
	pic.begin();
	
	var clrTinta = new Color();
	clrTinta.setRgb(200, 0, 0);

	var moverMarco:Boolean = marco && (marco.x != 0 || marco.y != 0);
	if (moverMarco) {
		pic.savePainter();
		pic.translate(marco.x, marco.y);
	}

	pic.setPen(clrTinta);
	if (marco) {
		pic.drawRect(new Rect(0, 0, marco.width, marco.height));
	}
	pic.drawText(x, y, mensaje);

	if (moverMarco) {
		pic.restorePainter();
	}
	return pic;
}

function oficial_tbnObjetivos_clicked()
{
	var tblMedidas:Object = this.child("tblMedidas");
	var filaMedida:Number = tblMedidas.currentRow();
	if (filaMedida < 0) {
		return;
	}
	var idMedida:Number = tblMedidas.text(filaMedida, this.iface.CM_NOMBRE);
	
	var xmlPos:FLDomNode = this.iface.xmlPosActual_.firstChild();
	var nodoObjetivos:FLDomNode = xmlPos.namedItem("Objetivos");
	var eObjetivos:FLDomElement;
	if (nodoObjetivos) {
		eObjetivos = nodoObjetivos.toElement();
	} else {
		eObjetivos = this.iface.xmlPosActual_.createElement("Objetivos");
		xmlPos.appendChild(eObjetivos);
	}
	
	var nodoTramos:FLDomNode = fldireinne.iface.pub_dameNodoXML(eObjetivos, "Objetivo[@IdMedida=" + idMedida + "]");
	var eTramos:FLDomElement;
	if (nodoTramos) {
		eTramos = nodoTramos.toElement();
	} else {
		eTramos = this.iface.xmlPosActual_.createElement("Objetivo");
		eTramos.setAttribute("IdMedida", idMedida);
		eObjetivos.appendChild(eTramos);
	}
// 	this.iface.establecerObjetivosMedida(eTramos);
// }
// 
// /// XXXX crear accion objetivos medida y llamarla sin usar esta función
// function oficial_establecerObjetivosMedida(eTramos:FLDomElement):Boolean
// {
	var util:FLUtil;
	
	var f:Object = new FLFormSearchDB("in_objetivosmedida");
	var curObjetivos:FLSqlCursor = f.cursor();
	curObjetivos.setModeAccess(curObjetivos.Insert);
	curObjetivos.refreshBuffer();
	curObjetivos.setValueBuffer("idusuario", sys.nameUser());
	curObjetivos.setValueBuffer("idmedida", eTramos.attribute("IdMedida"));
	f.setMainWidget();
	var idObjetivo:String = f.exec("id");
	if (!idObjetivo) {
		return false;
	}
// 	debug("Guardados datos en: " + formin_navegador.iface.xmlPosActual_.toString(4));
	this.iface.cargarPosicion(true);
	return true;
}

/** \D Crea una fila en tblDatos iniciando correctamente los valores de color de fondo y alineación
@param	iFila: Número de fila a crear
\end */
function oficial_crearFilaDatos(iFila:Number)
{
	var tblDatos:FLTable = this.child("tblDatos");
	tblDatos.insertRows(iFila);
	var totalCols:Number = tblDatos.numCols();
	for (var iCol:Number = 0; iCol < totalCols; iCol++) {
		tblDatos.setCellBackgroundColor(iFila, iCol, this.iface.colorDatNormal_);
		tblDatos.setCellAlignment(iFila, iCol, tblDatos.AlignLeft);
	}
}

function oficial_alinearFilaDatos(tblDatos:FLTable, iFila:Number, alineacion:String)
{
	var totalCols:Number = tblDatos.numCols();
	for (var iCol:Number = 0; iCol < totalCols; iCol++) {
		switch (alineacion) {
			case "AlignLeft": {
				tblDatos.setCellAlignment(iFila, iCol, tblDatos.AlignLeft);
				break;
			}
			case "AlignRight": {
				tblDatos.setCellAlignment(iFila, iCol, tblDatos.AlignRight);
				break;
			}
		}
	}
}

function oficial_alinearColumnaDatos(tblDatos:FLTable, iCol:Number, alineacion:String)
{
	var totalFilas:Number = tblDatos.numRows();
	for (var iFila:Number = 0; iFila < totalFilas; iFila++) {
		switch (alineacion) {
			case "AlignLeft": {
				tblDatos.setCellAlignment(iFila, iCol, tblDatos.AlignLeft);
				break;
			}
			case "AlignRight": {
				tblDatos.setCellAlignment(iFila, iCol, tblDatos.AlignRight);
				break;
			}
		}
	}
}

function oficial_alinearCeldaDatos(tblDatos:FLTable, iFila:Number, iCol:Number, alineacion:String)
{
	switch (alineacion) {
		case "AlignLeft": {
			tblDatos.setCellAlignment(iFila, iCol, tblDatos.AlignLeft);
			break;
		}
		case "AlignRight": {
			tblDatos.setCellAlignment(iFila, iCol, tblDatos.AlignRight);
			break;
		}
	}
}

function oficial_crearFilaDatos3(iFila:Number, estilo:String):FLDomElement
{
	var eGrafico:FLDomElement = this.iface.xmlGrafico_.firstChild().toElement();
	var nodoFilas:FLDomNode, nodoFila:FLDomNode, eFilas:FLDomElement, eFila:FLDomElement;
	nodoFilas = eGrafico.namedItem("Filas");
	if (nodoFilas) {
		eFilas = nodoFilas.toElement();
	} else {
		eFilas = this.iface.xmlGrafico_.createElement("Filas");
		eGrafico.appendChild(eFilas);
	}
	eFila = this.iface.xmlGrafico_.createElement("Fila");
	eFilas.appendChild(eFila);
	eFila.setAttribute("Numero", iFila);
	
	var numFilas:Number = parseInt(eGrafico.attribute("NumFilas"));
	if (isNaN(numFilas)) {
		numFilas = 0;
	}
	if (numFilas < (iFila + 1)) {
		eGrafico.setAttribute("NumFilas", (iFila + 1));
	}
		
// 	var eFila:FLDomElement = this.iface.dameFilaDatosGraf(iFila);
// 	if (!eFila) {
// 		return false;
// 	}
	eFila.setAttribute("Estilo", estilo);
	return eFila;
}

function oficial_crearColDatos(iCol:Number, estilo:String):FLDomElement
{
	var eCol:FLDomElement = this.iface.dameColDatosGraf(iCol);
	if (!eCol) {
		return false;
	}
	eCol.setAttribute("Estilo", estilo);
	return eCol;
}

function oficial_ponColorFondoFilaDatos(iFila:Number, colorFondo:Color)
{
	var eFila:FLDomElement = this.iface.dameFilaDatosGraf(iFila);
	if (!eFila) {
		return false;
	}
	eFila.setAttribute("ColorFondo", colorFondo);
	return true;
}

function oficial_ponColorFondoColumnaDatos(iCol:Number, colorFondo:Color)
{
	var eCol:FLDomElement = this.iface.dameColDatosGraf(iCol);
	if (!eCol) {
		return false;
	}
	eCol.setAttribute("ColorFondo", colorFondo);
	return true;
}

function oficial_ajustarColumnaDatos(iCol:Number, ajustar:Boolean)
{
	var eCol:FLDomElement = this.iface.dameColDatosGraf(iCol);
	if (!eCol) {
		return false;
	}
	eCol.setAttribute("Ajustar", (ajustar ? "true" : "false"));
	return true;
}

function oficial_ponColorFondoCeldaDatos(iFila:Number, iCol:Number, colorFondo:Color)
{
	var eCelda:FLDomElement = this.iface.dameCeldaDatosGraf(iFila, iCol);
	if (!eCelda) {
		return false;
	}
	eCelda.setAttribute("ColorFondo", colorFondo);
	return true;
}

function oficial_ocultarColDatos(iCol:Number, ocultar):Boolean
{
	var eCol:FLDomElement = this.iface.dameColDatosGraf(iCol);
	if (!eCol) {
		return false;
	}
	eCol.setAttribute("Oculta", ocultar ? "true" : "false")
	return true;
}

function oficial_ocultarFilaDatos(iFila:Number, ocultar:Boolean):Boolean
{
	var eFila:FLDomElement = this.iface.dameFilaDatosGraf(iFila);
	if (!eFila) {
		return false;
	}
	eFila.setAttribute("Oculta", ocultar ? "true" : "false");
	return true;
}


function oficial_dameFilaDatosGraf(iFila:Number):FLDomElement
{
// 	var eGrafico:FLDomElement = this.iface.xmlGraficoTabla_.firstChild().toElement();
	var eGrafico:FLDomElement = this.iface.xmlGrafico_.firstChild().toElement();
	var nodoFilas:FLDomNode, nodoFila:FLDomNode, eFilas:FLDomElement, eFila:FLDomElement;
	nodoFilas = eGrafico.namedItem("Filas");
	if (nodoFilas) {
		eFilas = nodoFilas.toElement();
	} else {
// 		eFilas = this.iface.xmlGraficoTabla_.createElement("Filas");
		eFilas = this.iface.xmlGrafico_.createElement("Filas");
		eGrafico.appendChild(eFilas);
	}
	nodoFila = fldireinne.iface.pub_dameNodoXML(eFilas, "Fila[@Numero=" + iFila + "]");
	if (nodoFila) {
		eFila = nodoFila.toElement();
	} else {
// 		eFila = this.iface.xmlGraficoTabla_.createElement("Fila");
		eFila = this.iface.xmlGrafico_.createElement("Fila");
		eFilas.appendChild(eFila);
		eFila.setAttribute("Numero", iFila);
		var numFilas:Number = parseInt(eGrafico.attribute("NumFilas"));
		if (isNaN(numFilas)) {
			numFilas = 0;
		}
		if (numFilas < (iFila + 1)) {
			eGrafico.setAttribute("NumFilas", (iFila + 1));
		}
	}
	return eFila;
}

function oficial_dameEstiloDatosGraf(idEstilo:String, nombre:String):FLDomElement
{
	var eGrafico:FLDomElement = this.iface.xmlGrafico_.firstChild().toElement();
	var nodoEstilos:FLDomNode, nodoEstilo:FLDomNode, eEstilos:FLDomElement, eEstilo:FLDomElement;
	nodoEstilos = eGrafico.namedItem("Estilos");
	if (nodoEstilos) {
		eEstilos = nodoEstilos.toElement();
	} else {
		eEstilos = this.iface.xmlGrafico_.createElement("Estilos");
		eGrafico.appendChild(eEstilos);
	}
	nodoEstilo = fldireinne.iface.pub_dameNodoXML(eEstilos, "Estilo[@Id=" + idEstilo + "]");
	if (nodoEstilo) {
		eEstilo = nodoEstilo.toElement();
	} else {
		eEstilo = this.iface.xmlGrafico_.createElement("Estilo");
		eEstilos.appendChild(eEstilo);
		eEstilo.setAttribute("Id", idEstilo);
	}
	eEstilo.setAttribute("Nombre", nombre);
	return eEstilo;
}

function oficial_dameColDatosGraf(iCol:Number):FLDomElement
{
// 	var eGrafico:FLDomElement = this.iface.xmlGraficoTabla_.firstChild().toElement();
	var eGrafico:FLDomElement = this.iface.xmlGrafico_.firstChild().toElement();
	var nodoCols:FLDomNode, nodoCol:FLDomNode, eCols:FLDomElement, eCol:FLDomElement;
	nodoCols = eGrafico.namedItem("Cols");
	if (nodoCols) {
		eCols = nodoCols.toElement();
	} else {
// 		eCols = this.iface.xmlGraficoTabla_.createElement("Cols");
		eCols = this.iface.xmlGrafico_.createElement("Cols");
		eGrafico.appendChild(eCols);
	}
	nodoCol = fldireinne.iface.pub_dameNodoXML(eCols, "Col[@Numero=" + iCol + "]");
	if (nodoCol) {
		eCol = nodoCol.toElement();
	} else {
// 		eCol = this.iface.xmlGraficoTabla_.createElement("Col");
		eCol = this.iface.xmlGrafico_.createElement("Col");
		eCols.appendChild(eCol);
		eCol.setAttribute("Numero", iCol);
	}
	return eCol;
// 	var tblDatos:FLTable = this.child("tblDatos");
// 	tblDatos.insertRows(iFila);
// 	var totalCols:Number = tblDatos.numCols();
// 	for (var iCol:Number = 0; iCol < totalCols; iCol++) {
// 		tblDatos.setCellBackgroundColor(iFila, iCol, this.iface.colorDatNormal_);
// 		tblDatos.setCellAlignment(iFila, iCol, tblDatos.AlignLeft);
// 	}
}

function oficial_dameCeldaDatosGraf(iFila:Number, iCol:Number):FLDomElement
{
// 	var eGrafico:FLDomElement = this.iface.xmlGraficoTabla_.firstChild().toElement();
	var eGrafico:FLDomElement = this.iface.xmlGrafico_.firstChild().toElement();
	if (!eGrafico) {
		return false;
	}
	
	var nodoValores:FLDomNode, nodoCelda:FLDomNode, eValores:FLDomElement, eCelda:FLDomElement;
	nodoValores = eGrafico.namedItem("Valores");
	if (nodoValores) {
		eValores = nodoValores.toElement();
	} else {
// 		eValores = this.iface.xmlGraficoTabla_.createElement("Valores");
		eValores = this.iface.xmlGrafico_.createElement("Valores");
		eGrafico.appendChild(eValores);
	}
	for (nodoCelda = eValores.firstChild(); nodoCelda; nodoCelda = nodoCelda.nextSibling()) {
		eCelda = nodoCelda.toElement();
		if (eCelda.attribute("Fila") == iFila && eCelda.attribute("Col") == iCol) {
			break;
		}
	}
	if (!nodoCelda) {
// 		eCelda = this.iface.xmlGraficoTabla_.createElement("Celda");
		eCelda = this.iface.xmlGrafico_.createElement("Celda");
		eValores.appendChild(eCelda);
		eCelda.setAttribute("Fila", iFila);
		eCelda.setAttribute("Col", iCol);
	}
	return eCelda;
}

function oficial_creaCeldaDatosGraf(iFila:Number, iCol:Number, texto:String):FLDomElement
{
	var eGrafico:FLDomElement = this.iface.xmlGrafico_.firstChild().toElement();
	if (!eGrafico) {
		return false;
	}
	
	var nodoValores:FLDomNode, nodoCelda:FLDomNode, eValores:FLDomElement, eCelda:FLDomElement;
	nodoValores = eGrafico.namedItem("Valores");
	if (nodoValores) {
		eValores = nodoValores.toElement();
	} else {
		eValores = this.iface.xmlGrafico_.createElement("Valores");
		eGrafico.appendChild(eValores);
	}
	
	eCelda = this.iface.xmlGrafico_.createElement("Celda");
	eValores.appendChild(eCelda);
	eCelda.setAttribute("Fila", iFila);
	eCelda.setAttribute("Col", iCol);
	eCelda.setAttribute("Texto", texto);
	
	return eCelda;
}


/** \D Crea un array con los elementos inicializados de cada array elemento del array this.iface.aFilasTabla 
@return	Array inicializado
\end */
function oficial_dameElementoArrayFilas():Array
{
	var aFila:Array = [];
	aFila["idmedida"] = false;
	aFila["nivel"] = 0;
	aFila["expande"] = "";
	aFila["clave"] = "";
	return aFila;
}

/** \D Crea un array con los elementos inicializados de cada array elemento del array this.iface.aColumnasTabla 
@return	Array inicializado
\end */
function oficial_dameElementoArrayColumnas():Array
{
	var aColumna:Array = [];
	aColumna["idmedida"] = false;
	aColumna["nivel"] = 0;
	aColumna["expande"] = "";
	aColumna["clave"] = "";
	return aColumna;
}

function oficial_cuboActual():String
{
	return this.iface.cubo_;
}

function oficial_cambiarCubo(cubo:String):Boolean
{
	this.iface.cubo_ = cubo;
	if (!this.iface.cargarMetadatosCubo()) {
		return false;
	}
	return true;
}

function oficial_nivelesCubo():Array
{
	var aNiveles:Array = [];
	aNiveles["a"] = this.iface.niveles_;
	aNiveles["i"] = this.iface.iNiveles_;
	return aNiveles;
}

function oficial_iniciarPosicion():Boolean
{
	this.iface.xmlPosActual_ = new FLDomDocument();
	
	var ePos:FLDomElement = this.iface.xmlPosActual_.createElement("Posicion");
	this.iface.xmlPosActual_.appendChild(ePos);

	var eFiltros:FLDomElement = this.iface.xmlPosActual_.createElement("Filtros");
	ePos.appendChild(eFiltros);
// 	var eFiltro:FLDomElement = xmlDoc.createElement("Filtro");
// 	eFiltros.appendChild(eFiltro);
// 	eFiltro.setAttribute("Campo", "tiempo..ano");
// 	eFiltro.setAttribute("Lista", ano);

	var eMedidas:FLDomElement = this.iface.xmlPosActual_.createElement("Medidas");
	ePos.appendChild(eMedidas);
// 	var eMedida:FLDomElement = xmlDoc.createElement("Medida");
// 	eMedidas.appendChild(eMedida);
// 	eMedida.setAttribute("Id", "ventas");

	var eDimensiones:FLDomElement = this.iface.xmlPosActual_.createElement("Dimensiones");
	ePos.appendChild(eDimensiones);
	var eX:FLDomElement = this.iface.xmlPosActual_.createElement("X");
	eDimensiones.appendChild(eX);
	var eY:FLDomElement = this.iface.xmlPosActual_.createElement("Y");
	eDimensiones.appendChild(eY);
// 	var eNivel:FLDomElement = xmlDoc.createElement("Nivel");
// 	eY.appendChild(eNivel);
// 	eNivel.setAttribute("Orden", "ASC");
// 	eNivel.setAttribute("Id", "provincia..provincia");

// 	debug(this.iface.xmlPosActual_.toString(4));
	return true;
}

function oficial_ponerFiltro(campo:String, lista:String):Boolean
{
// 	var xmlDoc:FLDomNode = this.iface.xmlPosActual_.firstChild();
// debug("xmlDoc = " + xmlDoc);
// 	var xmlFiltro:FLDomNode = fldireinne.iface.pub_dameNodoXML(this.iface.xmlPosActual_, "Posicion/Filtros/Filtro[@Campo=" + campo + "]");
// 	var eFiltro:FLDomElement;
// 	if (xmlFiltro) {
// 		eFiltro = xmlFiltro.toElement();
// 	} else {
// 		var xmlFiltros:FLDomNode = xmlDoc.namedItem("Filtros");//.namedItem("Filtros");//ssd
// 		eFiltro = this.iface.xmlPosActual_.createElement("Filtro");
// 		xmlFiltros.appendChild(eFiltro);
// 	}
// 	eFiltro.setAttribute("Campo", campo);
// 	eFiltro.setAttribute("Lista", lista);
// 	return true;
	
	var nodoFiltros:FLDomNode = fldireinne.iface.pub_dameNodoXML(this.iface.xmlPosActual_, "Posicion/Filtros");
	var nodoFiltro:FLDomNode = fldireinne.iface.pub_dameNodoXML(nodoFiltros, "Filtro[@Campo=" + campo + "]");
	var eFiltro:FLDomElement;
	if (nodoFiltro) {
		eFiltro = nodoFiltro.toElement();
	} else {
		eFiltro = this.iface.xmlPosActual_.createElement("Filtro");
		nodoFiltros.appendChild(eFiltro);
		eFiltro.setAttribute("Campo", campo);
	}
	eFiltro.setAttribute("Lista", lista);

	return true;
}

function oficial_ponerMedida(idMedida:String):Boolean
{
	var xmlDoc:FLDomNode = this.iface.xmlPosActual_.firstChild();

	var xmlMedida:FLDomNode = fldireinne.iface.pub_dameNodoXML(this.iface.xmlPosActual_, "Posicion/Medidas/Medida[@Id=" + idMedida + "]");
	if (!xmlMedida) {
		var eMedida:FLDomElement = this.iface.xmlPosActual_.createElement("Medida");
		var xmlMedidas:FLDomNode = xmlDoc.namedItem("Medidas");
		xmlMedidas.appendChild(eMedida);
		eMedida.setAttribute("Id", idMedida);
	}
	return true;
}

function oficial_ponerNivel(coord:String, idNivel:String, orden:String):Boolean
{
	var xmlDoc:FLDomDocument = this.iface.xmlPosActual_.firstChild();

	var xmlNivel:FLDomNode = fldireinne.iface.pub_dameNodoXML(this.iface.xmlPosActual_, "Posicion/Dimensiones/" + coord + "/Nivel[@Id=" + idNivel + "]");
	var eNivel:FLDomElement;
	if (xmlNivel) {
		eNivel = xmlNivel.toElement();
	} else {
		var xmlNiveles:FLDomNode = xmlDoc.namedItem("Dimensiones").namedItem(coord);
		eNivel = this.iface.xmlPosActual_.createElement("Nivel");
		xmlNiveles.appendChild(eNivel);
	}
	eNivel.setAttribute("Id", idNivel);
	eNivel.setAttribute("Orden", (orden ? orden : "ASC"));
	return true;
}

function oficial_quitarFiltro(campo:String):Boolean
{
	var xmlDoc:FLDomDocument = this.iface.xmlPosActual_.firstChild();

	var xmlFiltro:FLDomNode = fldireinne.iface.pub_dameNodoXML(this.iface.xmlPosActual_, "Posicion/Filtros/Filtro[@Campo=" + campo + "]");
	var xmlFiltros:FLDomNode = xmlDoc.namedItem("Posicion").namedItem("Filtros");
	if (xmlFiltro) {
		xmlFiltros.removeChild(xmlFiltro);
	}
	return true;
}

function oficial_quitarMedida(idMedida:String):Boolean
{
	var xmlDoc:FLDomDocument = this.iface.xmlPosActual_.firstChild();

	var xmlMedida:FLDomNode = fldireinne.iface.pub_dameNodoXML(this.iface.xmlPosActual_, "Posicion/Medidas/Medida[@Id=" + idMedida + "]");
	var xmlMedidas:FLDomNode = xmlDoc.namedItem("Posicion").namedItem("Medidas");
	if (xmlMedida) {
		xmlMedidas.removeChild(xmlMedida);
	}
	return true;
}

function oficial_quitarNivel(coord:String, idNivel:String):Boolean
{
	var xmlDoc:FLDomDocument = this.iface.xmlPosActual_.firstChild();

	var xmlNivel:FLDomNode = fldireinne.iface.pub_dameNodoXML(this.iface.xmlPosActual_, "Posicion/Dimensiones/" + coord + "/Nivel[@Id=" + idNivel + "]");
	var xmlNiveles:FLDomNode = xmlDoc.namedItem("Posicion").namedItem("Dimensiones").namedItem(coord);
	if (xmlNivel) {
		xmlNiveles.removeChild(xmlNivel);
	}
	return true;
}

function oficial_chkOrdenarMedida_clicked()
{
	if (this.iface.bloqueoMedidas_) {
		return;
	}
	
	var xmlDoc:FLDomDocument = this.iface.xmlPosActual_.firstChild();

	var xmlMedidas:FLDomNode = fldireinne.iface.pub_dameNodoXML(this.iface.xmlPosActual_, "Posicion/Medidas");
	var eMedidas:FLDomElement = xmlMedidas.toElement();
	if (this.child("chkOrdenarMedida").checked) {
		eMedidas.setAttribute("Ordenado", "true");
// 		if (this.child("rbnOrdenMedDesc").checked) {
// 			eMedidas.setAttribute("Orden", "DESC");
// 		} else {
// 			eMedidas.setAttribute("Orden", "ASC");
// 		}
	} else {
		eMedidas.setAttribute("Ordenado", "false");
	}
	this.iface.habilitarPorOrdenMedida();
	this.iface.cargarPosicion(false);
}

function oficial_habilitarPorOrdenMedida()
{
	this.child("bgrOrdenMed").enabled = this.child("chkOrdenarMedida").checked;
}

function oficial_habilitarPorLimiteMedida()
{
	this.child("sbxLimite").enabled = this.child("chkLimitar").checked;
}

function oficial_bgrOrdenMed_clicked(iBoton:Number)
{
	if (this.iface.bloqueoMedidas_) {
		return;
	}
	var xmlPos:FLDomNode = this.iface.xmlPosActual_.firstChild();
	var nodoMedidas:FLDomNode = xmlPos.namedItem("Medidas");
	var eMedidas:FLDomElement = nodoMedidas.toElement();
	if (iBoton == 0) { /// ASC
		eMedidas.setAttribute("Orden", "ASC");
	} else {
		eMedidas.setAttribute("Orden", "DESC");
	}
	this.iface.cargarPosicion(true);
}

function oficial_tbnExportarCRM_clicked()
{
	var util:FLUtil;
	if (!sys.isLoadedModule("flcrm_mark")) {
		MessageBox.warning(util.translate("scripts", "Para usar esta funcionalidad debe tener cargado el módulo de Marketing"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	var idNivel:String = this.iface.obtenerNivelCRM();
	if (!idNivel) {
		return false;
	}
	var aNivel:Array = this.iface.niveles_[idNivel];
	var eNivel:FLDomElement = aNivel["element"];
	var tabla:String = eNivel.attribute("sourceTable");

	var curConsulta:FLSqlCursor = (this.iface.conexion_ ? new FLSqlCursor("crm_consultasmark", this.iface.conexion_) : new FLSqlCursor("crm_consultasmark"));
debug("Filtro: " + "campoclave LIKE '" + tabla + ".%'");
	curConsulta.setMainFilter("campoclave LIKE '" + tabla + ".%'");

	var f:Object = new FLFormSearchDB(curConsulta, "crm_consultasmark");
	f.setMainWidget();
	var codConsulta:String = f.exec("codconsulta");
	if (!codConsulta) {
		return;
	}
	var codLista:String = this.iface.nombrePosActual_;
	var codLista:String = Input.getText(util.translate("scripts", "Nombre de la lista"), codLista);
	if (!codLista) {
		return;
	}
	var curTrans:FLSqlCursor = (this.iface.conexion_ ? new FLSqlCursor("empresa", this.iface.conexion_) : new FLSqlCursor("empresa"));
	try {
		if (this.iface.crearListaMarketing(codLista, codConsulta, idNivel)) {
			curTrans.commit();
		} else {
			curTrans.rollback();
			MessageBox.warning(util.translate("scripts", "Error al crear la lista de marketing"), MessageBox.Ok, MessageBox.NoButton);
			return;
		}
	} catch(e) {
		curTrans.rollback();
		MessageBox.critical(util.translate("scripts", "Error al crear la lista de marketing: ") + e, MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	MessageBox.information(util.translate("scripts", "La lista de marketing %1 ha sido creada correctament").arg(codLista), MessageBox.Ok, MessageBox.NoButton);
}

/** \D Verifica que el nivel de la consulta es sólo 1 y que es apropiado para su exportación a CRM
@return	idNivel: Nivel obtenido si comple las condiciones, false en caso contrario
\end */
function oficial_obtenerNivelCRM():String
{
	var util:FLUtil;
	var xmlPos:FLDomNode = this.iface.xmlPosActual_.firstChild();
	var xmlNiveles:FLDomNodeList = xmlPos.namedItem("Dimensiones").toElement().elementsByTagName("Nivel");
	if (!xmlNiveles || xmlNiveles.count() > 1) {
		MessageBox.warning(util.translate("scripts", "El número de niveles debe ser 1"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var eNivelLista:FLDomElement = xmlNiveles.item(0).toElement();
	var idNivel:String = eNivelLista.attribute("Id");
	var aNivel:Array = this.iface.niveles_[idNivel];
	var eNivel:FLDomElement = aNivel["element"];
	var tabla:String = eNivel.attribute("sourceTable");
debug("tabla = " + tabla);
	switch (tabla) {
		case "clientes": {
			break;
		}
		default: {
			MessageBox.warning(util.translate("scripts", "El nivel escogido no es exportable como lista de marketing"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}
	return idNivel;
}

function oficial_crearListaMarketing(codLista:String, codConsulta:String, idNivel:String):Boolean
{
	var util:FLUtil;
	var curLista:FLSqlCursor = (this.iface.conexion_ ? new FLSqlCursor("crm_listasmark", this.iface.conexion_) : new FLSqlCursor("crm_listasmark"));
	curLista.select("UPPER(codlista) = '" + codLista.toUpperCase() + "'");
	if (curLista.first()) {
		var res:Number = MessageBox.warning(util.translate("scripts", "Ya existe una lista con este nombre. ¿Desea sobreescribirla?"), MessageBox.Yes, MessageBox.No);
		if (res != MessageBox.Yes) {
			return true;
		}
		curLista.setModeAccess(curLista.Edit);
	} else {
		curLista.setModeAccess(curLista.Insert);
	}
	curLista.refreshBuffer();
	curLista.setValueBuffer("codlista", codLista);
	curLista.setValueBuffer("descripcion", util.translate("scripts", "Lista importada %1").arg(codLista));
	curLista.setValueBuffer("codconsulta", codConsulta);
	curLista.setValueBuffer("manual", true);
	curLista.setValueBuffer("importanalisis", true);
	curLista.setValueBuffer("posanalisis", this.iface.xmlPosActual_.toString(4));
	curLista.setValueBuffer("cuboanalisis", this.iface.cubo_);
	if (!curLista.commitBuffer()) {
		return false;
	}
	if (!this.iface.renovarElementosListaMarketing(codLista, idNivel)) {
		return false;
	}
	return true;
}

function oficial_renovarElementosListaMarketing(codLista:String, idNivel:String):Boolean
{
	if (!idNivel) {
		idNivel = this.iface.obtenerNivelCRM();
		if (!idNivel) {
			return false;
		}
	}

	var curElementos:FLSqlCursor = (this.iface.conexion_ ? new FLSqlCursor("crm_elementoslista", this.iface.conexion_) : new FLSqlCursor("crm_elementoslista"));
	curElementos.select("codlista = '" + codLista + "'");
	while (curElementos.next()) {
		curElementos.setModeAccess(curElementos.Del);
		curElementos.refreshBuffer();
		if (!curElementos.commitBuffer()) {
			return false;
		}
	}
	var xmlDat:FLDomNode = this.iface.xmlDatos_.firstChild();
	var eRow:FLDomElement;
	var clave:String;
	for (var xmlRow:FLDomNode = xmlDat.firstChild(); xmlRow; xmlRow  = xmlRow.nextSibling()) {
		eRow = xmlRow.toElement();
		clave = eRow.attribute(idNivel);
		curElementos.setModeAccess(curElementos.Insert);
		curElementos.refreshBuffer();
		curElementos.setValueBuffer("codlista", codLista);
		curElementos.setValueBuffer("clave", clave);
		curElementos.setValueBuffer("nombre", this.iface.obtenerDesNivel(idNivel, clave));
		if (!curElementos.commitBuffer()) {
			return false;
		}
	}
	return true;
}

function oficial_calcularDiasMesAno(mes:Number,ano:Number):Number
{
	var dias:Number = 31;

	switch(mes) {
		case 4:
		case 6: 
		case 9: 
		case 11: {
			dias = 30;
			break;
		}
		case 2: {
			dias = 28;
			if ((ano%4 == 0 && ano%100 != 0)|| ano%400 == 0)
				dias = 29;
			break;
		}
		default: {
			dias = 31;
			break;
		}
	}

	return dias;
}

function oficial_editarGrafico():Boolean
{
	var util:FLUtil = new FLUtil;

	var eGrafico:FLDomElement = this.iface.xmlGrafico_.firstChild().toElement();
	var tipoGrafico:String = eGrafico.attribute("Tipo");
	var filtroEdicion:String = "";
	var accion:String;
	switch (tipoGrafico) {
		case "2d_barras": {
			accion = "gf_2dbarras";
			break;
		}
		case "lineal": {
			accion = "gf_lineal";
			break;
		}
		case "1daguja": {
			accion = "gf_1daguja";
			break;
		}
		case "2d_tabla": {
			accion = "gf_2dtabla";
			break;
		}
		case "2d_mapa": {
			accion = "gf_2dmapa_edit";
			var codMapa:String;
			var tabla:String = eGrafico.attribute("Tabla");
			if (util.sqlSelect("gf_2dmapa", "COUNT(*)", "tabla = '" + tabla + "'") > 1) {
				var fMapas:Object = new FLFormSearchDB("gf_2dmapa");
				var curMapa:FLSqlCursor = fMapas.cursor();
				curMapa.setMainFilter("tabla = '" + tabla + "'");
	// 			if (filtroEdicion) {
	// 				curGrafico.select(filtroEdicion);
	// 				if (!curGrafico.first()) {
	// 		debug("No se encuentra registro gráfico " + filtroEdicion);
	// 					return false;
	// 				}
	// 				curGrafico.setModeAccess(curGrafico.Edit);
	// 			} else {
	// 				curGrafico.setModeAccess(curGrafico.Insert);
	// 			}
	// 			curGrafico.refreshBuffer();
	// 			curGrafico.setValueBuffer("xml", this.iface.xmlGrafico_.toString(4));
				fMapas.setMainWidget();
				codMapa = fMapas.exec("codmapa");
				if (!fMapas.accepted()) {
					return false;
				}
			} else {
				codMapa = eGrafico.attribute("CodMapa");
			}
			filtroEdicion = "codmapa = '" + codMapa + "'";
			break;
		}
		case "2dtarta": {
			accion = "gf_2dtarta";
			break;
		}
		default: {
			MessageBox.warning(util.translate("scripts", "El gráfico tipo %1 no soporta edición.").arg(tipoGrafico), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}

	var f:Object = new FLFormSearchDB(accion);
	var curGrafico:FLSqlCursor = f.cursor();

	if (filtroEdicion) {
		curGrafico.select(filtroEdicion);
		if (!curGrafico.first()) {
debug("No se encuentra registro gráfico " + filtroEdicion);
			return false;
		}
		curGrafico.setModeAccess(curGrafico.Edit);
	} else {
		curGrafico.setModeAccess(curGrafico.Insert);
	}
	curGrafico.refreshBuffer();
	curGrafico.setValueBuffer("xml", this.iface.xmlGrafico_.toString(4));
	f.setMainWidget();
	f.exec("id");
	if (!f.accepted()) {
		return false;
	}
	this.iface.xmlGrafico_ = new FLDomDocument;
	this.iface.xmlGrafico_.setContent(curGrafico.valueBuffer("xml"));
// 	this.iface.mostrarDatos();
	return true;
}

function oficial_cargarEstiloReport():Boolean
{
	var util:FLUtil = new FLUtil;
	
	var xmlPos:FLDomNode = this.iface.xmlPosActual_.firstChild();
	if (!xmlPos) {
		return false;
	}
	delete this.iface.xmlEstiloReport_;
	this.iface.xmlEstiloReport_ = false;
	var xmlEstiloReport:FLDomNode = xmlPos.namedItem("Informe");
	if (xmlEstiloReport) {
		this.iface.xmlEstiloReport_ = new FLDomDocument;
		this.iface.xmlEstiloReport_.appendChild(xmlEstiloReport.cloneNode(true));
	} else {
		var estiloReport:String = util.sqlSelect("gf_informekut", "xml", "1 = 1");
		if (estiloReport) {
			this.iface.xmlEstiloReport_ = new FLDomDocument;
			this.iface.xmlEstiloReport_.setContent(estiloReport);
		}
	}
	return true;
}

function oficial_generarInforme()
{
	var util:FLUtil = new FLUtil;
	if (!this.iface.cargarReportData()) {
		return false;
	}
	if (!this.iface.cargarReportTemplate()) {
		return false;
	}
	if (!this.iface.cargarEstiloReport()) {
		return false;
	}
	if (this.iface.xmlEstiloReport_) {
		formgf_informekut.iface.aplicarEstiloReport(this.iface.xmlEstiloReport_, this.iface.xmlReportTemplate_);
	}
	var contenidoKut:String = this.iface.xmlReportTemplate_.toString(4);
	
debug("KugarTemplate = " + contenidoKut);
	var nuevoViewer = false;
	if (!this.iface.rptViewer_) {
		this.iface.rptViewer_ = new FLReportViewer();
		this.iface.rptViewer_.reparent(this.child("frmInforme"));
		nuevoViewer = true;
	}
	try {
		var xmlKT:FLDomNode = this.iface.xmlReportTemplate_.namedItem("KugarTemplate");
		this.iface.rptViewer_.setReportTemplate(xmlKT);
	} catch(e) {
		var nombreReport:String = "in_" + sys.nameUser();
		var ficheroKut:String = nombreReport + ".kut";
		var curFile:FLSqlCursor = new FLSqlCursor("flfiles");
		curFile.select("nombre = '" + ficheroKut + "'");
		if (curFile.first()) {
			curFile.setModeAccess(curFile.Edit);
		} else {
			curFile.setModeAccess(curFile.Insert);
		}
		curFile.refreshBuffer();
		curFile.setValueBuffer("idmodulo", "fldireinne");
		curFile.setValueBuffer("contenido", contenidoKut);
		curFile.setValueBuffer("nombre", ficheroKut);
		curFile.setValueBuffer("sha", util.sha1(contenidoKut));
		if (!curFile.commitBuffer()) {
			return false;
		}
		this.iface.rptViewer_.setReportTemplate(nombreReport);
	}
	
	this.iface.rptViewer_.setReportData(this.iface.xmlReportData_);
	this.iface.rptViewer_.renderReport();

	this.iface.xmlReportTemplate_.setContent(contenidoKut);
	this.iface.rptViewer_.updateReport();
}

function oficial_cargarReportData2():Boolean
{
	var util:FLUtil = new FLUtil;
// debug("Analizando pos " + this.iface.xmlPosActual_.toString());
	var xmlPos:FLDomNode = this.iface.xmlPosActual_.firstChild();
	if (!xmlPos) {
		return false;
	}
	var xmlDatos:FLDomNode = this.iface.xmlDatos_.firstChild();
	if (!xmlDatos) {
		return false;
	}
	
	if (this.iface.xmlReportData_) {
		delete this.iface.xmlReportData_;
	}
	this.iface.xmlReportData_ = new FLDomDocument;
	this.iface.xmlReportData_.setContent("<!DOCTYPE KUGAR_DATA><KugarData/>");
// debug(this.iface.xmlReportData_.toString(4));
	var xmlData:FLDomNode = this.iface.xmlReportData_.namedItem("KugarData");
// debug("xmlData = " + xmlData);

	var aNiveles:Array = [];
	var eDimY:FLDomElement = xmlPos.namedItem("Dimensiones").namedItem("Y");
	var eNivel:FLDomElement, iNivel:Number = 0;
	for (var xmlNivel:FLDomNode = eDimY.firstChild(); xmlNivel; xmlNivel = xmlNivel.nextSibling()) {
		eNivel = xmlNivel.toElement();
debug("Cargando nivel " + eNivel.attribute("Id"));
		aNiveles[iNivel] = eNivel.attribute("Id");
		iNivel++;
	}
	var niveles:Number = iNivel;
	
	var aMedidas:Array = [];
	var xmlMedidas:FLDomElement = xmlPos.namedItem("Medidas");
	var eMedida:FLDomElement, iMed:Number = 0;
	for (var xmlMedida:FLDomNode = xmlMedidas.firstChild(); xmlMedida; xmlMedida = xmlMedida.nextSibling()) {
		eMedida = xmlMedida.toElement();
debug("Cargando medida " + eMedida.attribute("Id"));
		aMedidas[iMed] = eMedida.attribute("Id");
		iMed++;
	}
	var medidas:Number = iMed;

	var aValoresAnt:Array = [];
	for (var i:Number = 0; i < niveles; i++) {
		aValoresAnt[aNiveles[i]] = false;
	}
	var eRowDatos:FLDomElement;
	var eRow:FLDomElement;
	var eRowLevel:FLDomElement;
	for (var xmlRowDatos:FLDomNode = xmlDatos.firstChild(); xmlRowDatos; xmlRowDatos = xmlRowDatos.nextSibling()) {
		eRowDatos = xmlRowDatos.toElement();
		iNivelRotura = 0;
		while (iNivelRotura < niveles && eRowDatos.attribute(aNiveles[iNivelRotura]) == aValoresAnt[aNiveles[iNivelRotura]]) {
			iNivelRotura++;
		}
		eRowLevel = eRowDatos.cloneNode(true).toElement();
		for (iNivel = 0; iNivel < niveles; iNivel++) {
			eRowLevel.setAttribute(aNiveles[iNivel], this.iface.obtenerDesNivel(aNiveles[iNivel], eRowLevel.attribute(aNiveles[iNivel])));
		}
		for (iNivel = iNivelRotura; iNivel < niveles; iNivel++) {
			eRow = eRowLevel.cloneNode(true).toElement();
			eRow.setAttribute("level", iNivel);
			xmlData.appendChild(eRow);
		}
		for (iNivel = 0; iNivel < niveles; iNivel++) {
			aValoresAnt[aNiveles[iNivel]] = eRowDatos.attribute(aNiveles[iNivel]);
		}
	}
	return true;
}

function oficial_cargarReportData():Boolean
{
	var util:FLUtil = new FLUtil;
	
	var xmlPos:FLDomNode = this.iface.xmlPosActual_.firstChild();
	var ejeMedidas:String = xmlPos.namedItem("Medidas").toElement().attribute("Eje");
	var xmlMedidas:FLDomNodeList = xmlPos.namedItem("Medidas").childNodes();
	if (!xmlMedidas) {
		return false;
	}
	var numMedidas:Number = xmlMedidas .count();
	
	if (this.iface.xmlReportData_) {
		delete this.iface.xmlReportData_;
	}
	this.iface.xmlReportData_ = new FLDomDocument;
	this.iface.xmlReportData_.setContent("<!DOCTYPE KUGAR_DATA><KugarData/>");
	var xmlData:FLDomNode = this.iface.xmlReportData_.namedItem("KugarData");
	
	var numProps:Number = this.iface.DAT_C_MEDIDA_ - this.iface.DAT_C_CABECERA_ - 1;
	var clave:String, nivel:String, nombreNivel:String, idValor:String;
	var aCols:Array = this.iface.aColumnasTabla_;
	var aFils:Array = this.iface.aFilasTabla_;
	var fil0:Number = ejeMedidas == "X" ? this.iface.DAT_F_MEDIDA_ + 1 : this.iface.DAT_F_CABECERA_ + 1;
	var col0:Number = ejeMedidas == "X" ? this.iface.DAT_C_CABECERA_ + 1 + numProps : this.iface.DAT_C_MEDIDA_ + 1;
	var incFila:Number = (ejeMedidas == "Y" && numMedidas > 1 ? numMedidas : 1);
	var iCol:Number;
debug("numProps = " + numProps);
	debug("pintando array");
	for(var i=0;i<this.iface.nivelesY_.length;i++){
		debug("this.iface.nivelesY_[" + i + "] ==> " + this.iface.nivelesY_[i]);
	}
	for (var iFil:Number = fil0; iFil < this.iface.aFilasTabla_.length; iFil += incFila) {
		eRow = this.iface.xmlReportData_.createElement("Row");
		eRow.setAttribute("level", 0);
		xmlData.appendChild(eRow);
		for (var f:Number = 0; f < incFila; f++) {
			for (iCol = col0; iCol < aCols.length; iCol++) {
debug("iFil = " + iFil);
 debug("Fila " + (parseInt(iFil) + parseInt(f)) + " Col " + iCol + " valor " + this.iface.aTabla_[iFil + f][iCol]);
				idValor = ejeMedidas == "X" ? aCols[iCol]["idmedida"] : aFils[iFil + f]["idmedida"];
				idValor += "_" + aCols[iCol]["nivel"] + "_" + aCols[iCol]["clave"];
				eRow.setAttribute(idValor, this.iface.aTablaRaw_[parseInt(iFil) + parseInt(f)][iCol]);
			}
			for (var iProp:Number = 0; iProp < numProps; iProp++) {
				iCol = this.iface.DAT_C_CABECERA_ + 1 + iProp;
				eRow.setAttribute("prop_" + iProp.toString(), this.iface.aTabla_[parseInt(iFil) + parseInt(f)][iCol]);
			}
		}
		if (this.iface.nivelesY_[aFils[iFil]["nivel"]] != "sin niveles") {
			nombreNivel = this.iface.nivelesY_[aFils[iFil]["nivel"]]["id"];
			eRow.setAttribute("cabecera_fila", aFils[iFil]["clave"] != "" ? " " + this.iface.obtenerDesNivel(nombreNivel, aFils[iFil]["clave"]) : "");
		} else {
			eRow.setAttribute("cabecera_fila", "");
		}
		
	}
 	debug(this.iface.xmlReportData_.toString(4));
	return true;
}

function oficial_cargarReportTemplate():Boolean
{
	var util:FLUtil = new FLUtil;

	var numProps:Number = this.iface.DAT_C_MEDIDA_ - this.iface.DAT_C_CABECERA_ - 1;
	var xmlPos:FLDomNode = this.iface.xmlPosActual_.firstChild();
	var ejeMedidas:String = xmlPos.namedItem("Medidas").toElement().attribute("Eje");
	var fil0:Number = ejeMedidas == "X" ? this.iface.DAT_F_MEDIDA_ + 1 : this.iface.DAT_F_CABECERA_ + 1;
	var col0:Number = ejeMedidas == "X" ? this.iface.DAT_C_CABECERA_ + 1 + numProps: this.iface.DAT_C_MEDIDA_ + 1;
	var xmlMedidas:FLDomNodeList = xmlPos.namedItem("Medidas").childNodes();
	if (!xmlMedidas) {
		return false;
	}
	var numMedidas:Number = xmlMedidas.count();
	
	if (this.iface.xmlReportTemplate_) {
		delete this.iface.xmlReportTemplate_;
	}
	this.iface.xmlReportTemplate_ = new FLDomDocument;

	this.iface.xmlReportTemplate_.setContent("<?xml version = '1.0' encoding = 'UTF-8'?><!DOCTYPE KugarTemplate SYSTEM 'kugartemplate.dtd'><KugarTemplate BottomMargin='50' TopMargin='50' RightMargin='30' LeftMargin='30' PageOrientation='0' PageSize='0' />");
	var eTemplate:FLDomNode = this.iface.xmlReportTemplate_.namedItem("KugarTemplate").toElement();

	eTemplate.setAttribute("EjeMedidas", ejeMedidas);
	var aCols:Array = this.iface.aColumnasTabla_;
	var aFils:Array = this.iface.aFilasTabla_;
	var x:Number = 0, y:Number = 0, w:Number = 100, height:Number = 20, wMedida:Number = 50, wProp:Number = 100;
	
	var ePageHeader:FLDomElement = this.iface.xmlReportTemplate_.createElement("PageHeader");
	eTemplate.appendChild(ePageHeader);
	ePageHeader.setAttribute("Height", height);
	var eLabel:FLDomElement;
	eLabel = this.iface.xmlReportTemplate_.createElement("Label");
	ePageHeader.appendChild(eLabel);
	eLabel.setAttribute("X", 0);
	eLabel.setAttribute("Y", 0);
	eLabel.setAttribute("Width", 600);
	eLabel.setAttribute("Text", this.iface.nombrePosActual_);
	this.iface.formatoCampoKut(eLabel);
	
	var eDetailHeader:FLDomElement = this.iface.xmlReportTemplate_.createElement("DetailHeader");
	eTemplate.appendChild(eDetailHeader);
	eDetailHeader.setAttribute("Level", "0");
	eDetailHeader.setAttribute("Height", (ejeMedidas == "X" && numMedidas > 1 ? height * 2 : height));

	/// Cabecera
	var texto:String, nombreNivel:String;
	x = w - 1;
	var idProp:String, iCol:Number, nombreProp;
	/// Cabecera -> Propiedades
	for (var iProp:Number = 0; iProp < numProps; iProp++) {
		iCol = this.iface.DAT_C_CABECERA_ + 1 + iProp;
		nombreProp = "prop_" + iProp.toString();
// 		texto = aCols[iCol]["clave"] != "" ? this.iface.obtenerDesNivel(nombreNivel, aCols[iCol]["clave"]) : "";
		eLabel = this.iface.xmlReportTemplate_.createElement("Label");
		eDetailHeader.appendChild(eLabel);
		eLabel.setAttribute("X", x);
		eLabel.setAttribute("Y", 0);
		eLabel.setAttribute("Width", w);
		eLabel.setAttribute("Text", "");
		eLabel.setAttribute("DataType", 0);
		eLabel.setAttribute("HAlignment", 2);
		eLabel.setAttribute("TipoTitulo", "Prop");
		this.iface.formatoCampoKut(eLabel);
		x += parseInt(wProp) - 1;
	}
	/// Cabecera -> Niveles y medidas
	for (var iCol:Number = col0; iCol < aCols.length; iCol++) {
		nombreNivel = this.iface.nivelesX_[aCols[iCol]["nivel"]];
		texto = aCols[iCol]["clave"] != "" ? this.iface.obtenerDesNivel(nombreNivel, aCols[iCol]["clave"]) : "";
		eLabel = this.iface.xmlReportTemplate_.createElement("Label");
		eDetailHeader.appendChild(eLabel);
		eLabel.setAttribute("X", x);
		eLabel.setAttribute("Y", 0);
		eLabel.setAttribute("Width", w);
		eLabel.setAttribute("Text", texto);
		eLabel.setAttribute("DataType", 0);
		eLabel.setAttribute("HAlignment", 2);
		eLabel.setAttribute("TipoTitulo", "Nivel");
		this.iface.formatoCampoKut(eLabel);
		
		if (ejeMedidas == "X" && numMedidas > 1) {
			texto = this.iface.dameAliasMedida(aCols[iCol]["idmedida"]);
			eLabel = this.iface.xmlReportTemplate_.createElement("Label");
			eDetailHeader.appendChild(eLabel);
			eLabel.setAttribute("X", x);
			eLabel.setAttribute("Y", height);
			eLabel.setAttribute("Width", w);
			eLabel.setAttribute("Text", texto);
			eLabel.setAttribute("DataType", 0);
			eLabel.setAttribute("HAlignment", 2);
			this.iface.formatoCampoKut(eLabel);
			eLabel.setAttribute("TipoTitulo", "Medida");
		}
		x += parseInt(w) - 1;
	}
	
	var alturaDetalle:Number = 20;
	var eDetail:FLDomElement = this.iface.xmlReportTemplate_.createElement("Detail");
	eTemplate.appendChild(eDetail);
	eDetail.setAttribute("Level", "0");
	eDetail.setAttribute("Height", alturaDetalle);
	
	var incFila:Number = (ejeMedidas == "Y" && numMedidas > 1 ? numMedidas : 1);
	var idMedida:String;
	x = 0;
	var eField:FLDomElement = this.iface.xmlReportTemplate_.createElement("Field");
	eField = this.iface.xmlReportTemplate_.createElement("Field");
	eDetail.appendChild(eField);
	eField.setAttribute("X", x);
	eField.setAttribute("Y", 0);
	eField.setAttribute("Width", w);
	eField.setAttribute("Field", "cabecera_fila");
	eField.setAttribute("DataType", 0);
	eField.setAttribute("HAlignment", 0);
	this.iface.formatoCampoKut(eField);
	eField.setAttribute("Height", alturaDetalle + 1);
	x += w;
	
	for (var iProp:Number = 0; iProp < numProps; iProp++) {
		iCol = this.iface.DAT_C_CABECERA_ + 1 + iProp;
		for (var f:Number = 0; f < incFila; f++) {
			y = f * alturaDetalle;
			idProp = "prop_" + iProp.toString();
			eField = this.iface.xmlReportTemplate_.createElement("Field");
			eDetail.appendChild(eField);
			eField.setAttribute("X", x);
			eField.setAttribute("Y", y);
			eField.setAttribute("Width", wProp);
			eField.setAttribute("Field", idProp);
			eField.setAttribute("DataType", 0);
			eField.setAttribute("HAlignment", 0);
			this.iface.formatoCampoKut(eField);
			eField.setAttribute("Height", alturaDetalle + 1);
		}
		x += wProp;
	}
	
	if (ejeMedidas == "Y" && numMedidas > 1) {
		eDetail.setAttribute("NumMedidasV", numMedidas);
		for (var f:Number = 0; f < incFila; f++) {
			y = f * alturaDetalle;
			idMedida = ejeMedidas == "X" ? aCols[iCol]["idmedida"] : aFils[fil0 + f]["idmedida"]
			texto = " " + this.iface.dameAliasMedida(idMedida);
			eLabel = this.iface.xmlReportTemplate_.createElement("Label");
			eDetail.appendChild(eLabel);
			eLabel.setAttribute("X", x);
			eLabel.setAttribute("Y", y);
			eLabel.setAttribute("Width", wMedida);
			eLabel.setAttribute("Text", texto);
			eLabel.setAttribute("DataType", 0);
			eLabel.setAttribute("HAlignment", 0);
			this.iface.formatoCampoKut(eLabel);
			eLabel.setAttribute("TipoTitulo", "Medida");
		}
		x += wMedida;
	}
	
	for (var iCol:Number = col0; iCol < aCols.length; iCol++) {
		for (var f:Number = 0; f < incFila; f++) {
			y = f * alturaDetalle;
			idMedida = ejeMedidas == "X" ? aCols[iCol]["idmedida"] : aFils[fil0 + f]["idmedida"]
			idValor = idMedida + "_" + aCols[iCol]["nivel"] + "_" + aCols[iCol]["clave"];
			eField = this.iface.xmlReportTemplate_.createElement("Field");
			eDetail.appendChild(eField);
			eField.setAttribute("X", x);
			eField.setAttribute("Y", y);
			eField.setAttribute("Width", w);
			eField.setAttribute("Field", idValor);
			eField.setAttribute("DataType", 2);
			eField.setAttribute("HAlignment", 2);
			this.iface.formatoCampoKut(eField);
			eField.setAttribute("Height", alturaDetalle + 1);
			eField.setAttribute("Precision", this.iface.precisionMedida(idMedida));
		}
		x += w;
	}
	
 	debug(this.iface.xmlReportTemplate_.toString(4));
	return true;
}

function oficial_cargarReportTemplate2(forzarRecalculo:Boolean):Booleam
{
	var util:FLUtil = new FLUtil;
// debug("DatosKugar = " + this.iface.xmlReportData_.toString(4));
// debug("report ya conocido 1 = " + this.iface.xmlReportTemplate_.toString(4));
	if (this.iface.xmlReportTemplate_) {
// debug("report ya conocido = " + this.iface.xmlReportTemplate_.toString(4));
		return true;
		delete this.iface.xmlReportTemplate_;
	}
	this.iface.xmlReportTemplate_ = new FLDomDocument;
	
	var xmlPos:FLDomNode = this.iface.xmlPosActual_.firstChild();
	if (!xmlPos) {
		return false;
	}
	
	var xmlReport:FLDomNode = fldireinne.iface.pub_dameNodoXML(xmlPos, "Informe/KugarTemplate");
	if (xmlReport && !forzarRecalculo) {
		this.iface.xmlReportTemplate_.setContent("<?xml version = '1.0' encoding = 'UTF-8'?><!DOCTYPE KugarTemplate SYSTEM 'kugartemplate.dtd'>");
		this.iface.xmlReportTemplate_.appendChild(xmlReport.cloneNode(true));
	} else {
		var aNiveles:Array = [];
		var eDimY:FLDomElement = xmlPos.namedItem("Dimensiones").namedItem("Y");
		var eNivel:FLDomElement, iNivel:Number = 0;
		for (var xmlNivel:FLDomNode = eDimY.firstChild(); xmlNivel; xmlNivel = xmlNivel.nextSibling()) {
			eNivel = xmlNivel.toElement();
	debug("Cargando nivel " + eNivel.attribute("Id"));
			aNiveles[iNivel] = eNivel.attribute("Id");
			iNivel++;
		}
		var niveles:Number = iNivel;
		
		var aMedidas:Array = [];
		var xmlMedidas:FLDomElement = xmlPos.namedItem("Medidas");
		var eMedida:FLDomElement, iMed:Number = 0;
		for (var xmlMedida:FLDomNode = xmlMedidas.firstChild(); xmlMedida; xmlMedida = xmlMedida.nextSibling()) {
			eMedida = xmlMedida.toElement();
	debug("Cargando medida " + eMedida.attribute("Id"));
			aMedidas[iMed] = eMedida.attribute("Id");
			iMed++;
		}
		var medidas:Number = iMed;
		
		this.iface.xmlReportTemplate_.setContent("<?xml version = '1.0' encoding = 'UTF-8'?><!DOCTYPE KugarTemplate SYSTEM 'kugartemplate.dtd'><KugarTemplate BottomMargin='50' TopMargin='50' RightMargin='30' LeftMargin='30' PageOrientation='0' PageSize='0' />");
		xmlReport = this.iface.xmlReportTemplate_.namedItem("KugarTemplate");

		var eDetail:FLDomElement, aDetailHeader:Array = new Array(niveles), aDetailFooter:Array = new Array(niveles);
		var eField:FLDomElement, eLabel:FLDomElement;
		var eLabel:FLDomElement;
		var altoNivel:Number = 20;
	// 	var altoCampo:Number = 20;
		var anchoCampo:Number = 100;
		var x:Number = 0;
		for (iNivel = 0; iNivel < niveles; iNivel++) {
			eDetail = this.iface.xmlReportTemplate_.createElement("Detail");
			xmlReport.appendChild(eDetail);
			eDetail.setAttribute("Level", iNivel);
			eDetail.setAttribute("Height", altoNivel);
			eField = this.iface.xmlReportTemplate_.createElement("Field");
			eDetail.appendChild(eField);
			eField.setAttribute("X", x);
			eField.setAttribute("Y", 0);
			eField.setAttribute("Width", anchoCampo);
			eField.setAttribute("Field", aNiveles[iNivel]);
			eField.setAttribute("DataType", 0);
			eField.setAttribute("HAlignment", 0);
			this.iface.formatoCampoKut(eField);
			
			aDetailFooter[iNivel] = this.iface.xmlReportTemplate_.createElement("DetailFooter");
			xmlReport.appendChild(aDetailFooter[iNivel]);
			aDetailFooter[iNivel].setAttribute("Level", iNivel);
			aDetailFooter[iNivel].setAttribute("Height", altoNivel);
			
			x += parseInt(anchoCampo);
			if (iNivel == (niveles - 1)) {
				aDetailHeader[iNivel] = this.iface.xmlReportTemplate_.createElement("DetailHeader");
				xmlReport.appendChild(aDetailHeader[iNivel]);
				aDetailHeader[iNivel].setAttribute("Level", iNivel);
				aDetailHeader[iNivel].setAttribute("Height", altoNivel);
				
				for (iMed = 0; iMed < medidas; iMed++) {
					eLabel = this.iface.xmlReportTemplate_.createElement("Label");
					aDetailHeader[iNivel].appendChild(eLabel);
					eLabel.setAttribute("X", x);
					eLabel.setAttribute("Y", 0);
					eLabel.setAttribute("Width", anchoCampo);
					eLabel.setAttribute("Text", this.iface.medidas_[aMedidas[iMed]]["element"].attribute("alias"));
					eLabel.setAttribute("DataType", "0");
					eLabel.setAttribute("HAlignment", 2);
					this.iface.formatoCampoKut(eLabel);
					
					eField = this.iface.xmlReportTemplate_.createElement("Field");
					eDetail.appendChild(eField);
					eField.setAttribute("X", x);
					eField.setAttribute("Y", 0);
					eField.setAttribute("Width", anchoCampo);
					eField.setAttribute("Field", aMedidas[iMed]);
					eField.setAttribute("DataType", "2");
					eField.setAttribute("HAlignment", 2);
					this.iface.formatoCampoKut(eField);
					
					for (var iFooter:Number = 0; iFooter < niveles; iFooter++) {
						eField = this.iface.xmlReportTemplate_.createElement("CalculatedField");
						aDetailFooter[iFooter].appendChild(eField);
						eField.setAttribute("CalculationType", "1");
						eField.setAttribute("X", x);
						eField.setAttribute("Y", 0);
						eField.setAttribute("Width", anchoCampo);
						eField.setAttribute("Field", aMedidas[iMed]);
						eField.setAttribute("DataType", 2);
						eField.setAttribute("HAlignment", 2);
						this.iface.formatoCampoKut(eField);
					}
					
					x += parseInt(anchoCampo) - 1;
				}
			}
		}
		if (!this.iface.borrarInformePos()) {
			return false;
		}
	}
	return true;
}

function oficial_formatoCampoKut(eField:FLDomElement):Boolean
{
	eField.setAttribute("BackgroundColor", "255,255,255");
	eField.setAttribute("ForegroundColor", "0,0,0");
	eField.setAttribute("VAlignment", "1");
	eField.setAttribute("FontFamily", "Arial");
	eField.setAttribute("FontSize", "10");
	eField.setAttribute("Height", "20");
	eField.setAttribute("BorderWidth", "0");
	eField.setAttribute("BorderStyle", "0");
	if (eField.nodeName() == "Field") {
		eField.setAttribute("CommaSeparator", "44");
	}
	
	return true;
}

function oficial_ejecutarComando(comando:Array, workdir:String):Array
{
debug("workdir = " + workdir);
	var res = new Array("ok", "salida");
	var proc = new Process;
	if (workdir != undefined && !workdir.isEmpty()) {
		proc.workingDirectory = workdir;
	} else {
		proc.workingDirectory = Dir.home;
	}
debug("WD = " + proc.workingDirectory);
	proc.arguments = comando;
	debug(proc.workingDirectory  + " " +  workdir + " $ " + proc.arguments.join(" "));

	proc.start();
	sys.processEvents();
	while (proc.running) {}
	sys.processEvents();

	var stdErr = proc.readStderr();
	if (!stdErr.isEmpty()) {
		res["ok"] = false;
		res["salida"] = stdErr;
	} else {
		res["ok"] = true;
		res["salida"] = proc.readStdout();
		debug("Ok\n" + res["salida"]);
	}
	return res;
}

function oficial_tbnEditarFormato_clicked()
{
	switch (this.iface.interfazDatos_) {
		case "TABLA": {
			break;
		}
		case "GRAFICO": {
			if (!this.iface.editarGrafico()) {
debug("Fallo editarGrafico");
				return false;
			}
			this.iface.graficoMostrado_ = false;
			this.iface.borraGraficoCache(this.iface.tipoGrafico_);
			this.iface.mostrarDatos();
			break;
		}
		case "INFORME": {
			this.iface.editarInforme();
			break;
		}
	}
}

function oficial_editarInforme()
{
	var util:FLUtil = new FLUtil;
	
	if (!this.iface.xmlReportTemplate_) {
		MessageBox.warning(util.translate("scripts", "No hay ningún modelo de informe cargado"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
// debug(this.iface.xmlReportTemplate_.toString(4));
// 	Dir.current = Dir.home;
// 	File.write("report.kut", this.iface.xmlReportTemplate_.toString(4));
// 	var aComando:Array = ["/home/arodriguez/motor/tronco/lite-instalacion/bin/kudesigner", "report.kut"];
// 	this.iface.ejecutarComando(aComando);
// 	var res:Number = MessageBox.information(util.translate("scripts", "Pulse aceptar si desea guardar los cambios realizados en el formato del informe"), MessageBox.Ok, MessageBox.Cancel);
// 	if (res != MessageBox.Ok) {
// 		return;
// 	}
// 	var contenido:String = File.read("report.kut");
// debug(contenido);
// 	if (!this.iface.xmlReportTemplate_.setContent(contenido)) {
// 		MessageBox.warning(util.translate("scripts", "Error en el formato XML del informe"), MessageBox.Ok, MessageBox.NoButton);
// 		return;
// 	}
// 	this.iface.generarInforme();
// return;
	var f:Object = new FLFormSearchDB("gf_informekut");///
	var curGrafico:FLSqlCursor = f.cursor();
		curGrafico.setModeAccess(curGrafico.Insert);
	curGrafico.refreshBuffer();
	curGrafico.setValueBuffer("xml", this.iface.xmlEstiloReport_.toString(4));
	curGrafico.setValueBuffer("xmlreport", this.iface.xmlReportTemplate_.toString(4));
	curGrafico.setValueBuffer("xmldata", this.iface.xmlReportData_.toString(4));
	f.setMainWidget();
	debug("EXEC ////////");
	f.exec("id");
	debug("2sEXEC ////////");
	if (!f.accepted()) {
		debug("No accepted");
		return false;
	}
	debug("accepted");
	this.iface.xmlEstiloReport_ = new FLDomDocument;
	this.iface.xmlEstiloReport_.setContent(curGrafico.valueBuffer("xml"));
	this.iface.guardarInformePos();
	this.iface.generarInforme();
}

function oficial_cerosIzquierda(numero:String, totalCifras:Number):String
{
	var ret:String = numero.toString();
	var numCeros:Number = totalCifras - ret.length;
	for ( ; numCeros > 0 ; --numCeros)
		ret = "0" + ret;
	return ret;
}

function oficial_precisionMedida(medida:String):Number
{
	var formatString:String = this.iface.medidas_[medida]["element"].attribute("formatString");
	debug("formatString " + formatString);
	if (!formatString || formatString == "") {
		return 0;
	}
	var precision:Number;
	var posComa:Number = formatString.find(",");
	debug("posComa " + posComa);
	
	if (posComa >= 0) {
		precision = formatString.length - posComa - 1;
	} else {
		precision = 0;
	}
	return precision;
}

function oficial_tbnImprimirGrafico_clicked()
{
	var devSize = this.child( "lblGrafico" ).size;
// 	var pageSize = new Size(645, 912); /// A4
	var marco:Rect = new Rect(0, 0, devSize.width, devSize.height);
	var pic:Picture = this.iface.dibujarGrafico(marco);
	if (!pic) {
		return false;
	}
	
	var visor = new FLReportViewer();
	visor.setPageDimensions(devSize);
	visor.setPageSize(0);
	visor.appendPage();
	var page = visor.getFirstPage();
	pic.playOnPicture(page);
	visor.updateDisplay();
	visor.exec();
	pic.end();
	
}

function oficial_bgMes_clicked(iMes:Number)
{
	if (!this.iface.nivelBGMes_) {
		return;
	}
	
	var lista:String = "";
	var sMes:String;
	for (var i:Number = 0; i < 12; i++) {
		if (this.child("pbnMes" + i.toString()).on) {
			sMes = (i + 1).toString();
			lista += lista != "" ? ", " + sMes : sMes;
		}
	}
debug("lista '" + lista + "'");
	if (iMes >= 0) {
		var nombrePbnMes:String = "pbnMes" + iMes.toString();
		this.iface.colorearBotonDim(nombrePbnMes);
	
		var iTrim:Number;
		if (iMes < 3) {
			iTrim = 0;
		} else if (iMes < 6) {
			iTrim = 1;
		} else if (iMes < 9) {
			iTrim = 2;
		} else {
			iTrim = 3;
		}
		/// Activa el trimestre correspondiente al mes activado en caso de que haya algún otro trimestre activado
		var nombrePbnTrim:String = "pbnTrim" + iTrim.toString();
		if (this.child(nombrePbnMes).on && !this.child(nombrePbnTrim).on) {
			if (this.child("pbnTrim0").on || this.child("pbnTrim1").on || this.child("pbnTrim2").on || this.child("pbnTrim3").on) {
				this.iface.ponerFiltro(this.iface.nivelBGMes_, lista);
				this.child(nombrePbnTrim).animateClick();
				return;
			}
		}
	}
	this.iface.cambiarFiltro(this.iface.nivelBGMes_, lista);
	
}

function oficial_colorearBotonDim(nombreBoton:String)
{
	var colorBoton:Color = (this.child(nombreBoton).on ? fldireinne.iface.pub_dameColor(this.iface.colorDimSel_) : fldireinne.iface.pub_dameColor(this.iface.colorDimNoSel_))
	this.child(nombreBoton).paletteBackgroundColor = colorBoton;
}

function oficial_bgTrim_clicked(iTrim:Number)
{
	if (!this.iface.nivelBGTrim_) {
		return;
	}
	
	var nombrePbnTrim:String = "pbnTrim" + iTrim.toString();
	this.iface.colorearBotonDim(nombrePbnTrim);
	/// Activa los trimestres correspondientes a meses activados. Esto puede darse si el trimestre actual es el primero que se activa, habiendo activado antes meses de otros trimestres
	if (this.child(nombrePbnTrim).on) {
		var iTrim2:Number;
		var nombrePbnTrim2:String;
		var nombrePbnMes:String;
		for (var iMes:Number = 0; iMes < 12; iMes++) {
			iTrim2 = Math.floor(iMes / 3);
			nombrePbnTrim2 = "pbnTrim" + iTrim2.toString();
			nombrePbnMes = "pbnMes" + iMes.toString();
			if (!this.child(nombrePbnTrim2).on && this.child(nombrePbnMes).on) {
				this.child(nombrePbnTrim2).on = true
				this.iface.colorearBotonDim(nombrePbnTrim2);
			}
		}
	}
	
	var lista:String = "";
	var sTrim:String;
	for (var i:Number = 0; i < 4; i++) {
		if (this.child("pbnTrim" + i.toString()).on) {
			sTrim = "T" + (i + 1).toString();
			lista += lista != "" ? ", " + sTrim : sTrim;
		}
	}
debug("lista '" + lista + "'");
	
	if (!this.child(nombrePbnTrim).on) {
		/// Desactiva los meses correspondientes al trimestre desactivado en caso de que haya algún otro trimestre activado
		if (this.child("pbnTrim0").on || this.child("pbnTrim1").on || this.child("pbnTrim2").on || this.child("pbnTrim3").on) {
			var iMesDesde:Number = iTrim * 3;
			var iMesHasta:Number = iMesDesde + 3;
			var nombrePbnMes:String;
			var mesCambiado:Boolean = false;
			for (var iMes:Number = iMesDesde;  iMes < iMesHasta; iMes++) {
				nombrePbnMes = "pbnMes" + iMes.toString();
				if (this.child(nombrePbnMes).on) {
					this.child(nombrePbnMes).on = false;
					this.iface.colorearBotonDim(nombrePbnMes);
					mesCambiado = true;
				}
			}
			if (mesCambiado) {
				this.iface.ponerFiltro(this.iface.nivelBGTrim_, lista);
				this.iface.bgMes_clicked(-1);
				return;
			}
		}
	}
	
	this.iface.cambiarFiltro(this.iface.nivelBGTrim_, lista);
	
}

function oficial_ordenaArrayNumerico(n1:Number, n2:Number):Number
{
	if (n1 == n2) {
		return 0;
	} else if (n1 > n2) {
		return 1;
	} else {
		return -1;
	}
}

function oficial_bgAnno_clicked(iAnno:Number)
{
	if (!this.iface.nivelBGAnno_) {
		return;
	}
	
	var nombrePbnAnno:String = "pbnAno" + iAnno.toString();
	this.iface.colorearBotonDim(nombrePbnAnno);
	var anno:Number = this.iface.dameAnnoBoton(iAnno);
	
	var lista:String = "";
	var nodoFiltro:FLDomNode = fldireinne.iface.pub_dameNodoXML(this.iface.xmlPosActual_, "Posicion/Filtros/Filtro[@Campo=" + this.iface.nivelBGAnno_ + "]");
	if (nodoFiltro) {
		lista = nodoFiltro.toElement().attribute("Lista");
	}
	if (lista && lista != "") {
		if (this.child(nombrePbnAnno).on) {
			var aLista:Array = lista.split(", ");
			if (this.iface.buscarElementoArray(anno, aLista) == -1) {
				aLista.push(anno);
				aLista.sort(this.iface.ordenaArrayNumerico);
				lista = aLista.join(", ");
			}
		} else {
			var aLista:Array = lista.split(", ");
			var iElemento:Number = this.iface.buscarElementoArray(anno, aLista);
			if (iElemento >= 0) {
				aLista.splice(iElemento, 1);
			}
			lista = aLista.join(", ");
		}
	} else {
		if (this.child(nombrePbnAnno).on) {
			lista = anno;
		}
	}
	
	this.iface.cambiarFiltro(this.iface.nivelBGAnno_, lista);
}

/** \D Inicia los labels de los botones de tiempo (años, trimestres, meses)
\end */
function oficial_iniciaBGTiempo()
{
	var util:FLUtil = new FLUtil;
	
	this.iface.nivelBGMes_ = false;
	this.iface.nivelBGTrim_ = false;
	this.iface.nivelBGAnno_ = false;
	
	var totalBotones:Number = 5
	this.iface.numBotonesAno_ = totalBotones;
	
	var totalAnos:Number = this.iface.anoMax_ - this.iface.anoMin_ + 1;
	if (totalAnos > 0 && totalAnos < this.iface.numBotonesAno_) {
		this.iface.numBotonesAno_ = totalAnos;
	}
	var annoDesde:Number = this.iface.anoMax_ - this.iface.numBotonesAno_ + 1;
	var anno:Number = annoDesde;
	for (var i:Number = 0; i < totalBotones; i++) {
		if (i < this.iface.numBotonesAno_) {
			this.child("pbnAno" + i.toString()).text = anno.toString().right(this.iface.numBotonesAno_ > 4 ? 2 : 4);
			anno++;
		} else {
			this.child("pbnAno" + i.toString()).close();
		}
	}
	var aTrim:Array = [util.translate("scripts", "T1"), util.translate("scripts", "T2"), util.translate("scripts", "T3"), util.translate("scripts", "T4")];
	for (var i:Number = 0; i < 4; i++) {
		this.child("pbnTrim" + i.toString()).text = aTrim[i];
	}
	var aMes:Array = [util.translate("scripts", "Ene"), util.translate("scripts", "Feb"), util.translate("scripts", "Mar"), util.translate("scripts", "Abr"), util.translate("scripts", "May"), util.translate("scripts", "Jun"), util.translate("scripts", "Jul"), util.translate("scripts", "Ago"), util.translate("scripts", "Sep"), util.translate("scripts", "Oct"), util.translate("scripts", "Nov"), util.translate("scripts", "Dic")];
	for (var i:Number = 0; i < 12; i++) {
		this.child("pbnMes" + i.toString()).text = aMes[i];
	}
}

/** \D Obtiene un año a partir del índice del boton pulsado en el buttonGruop de años
\end */
function oficial_dameAnnoBoton(iAnno:Number):Number
{
	var anno = this.iface.anoMax_ - (this.iface.numBotonesAno_ - 1) + iAnno;
	return anno;
}


//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
