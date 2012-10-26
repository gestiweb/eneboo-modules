/***************************************************************************
                 pr_planificacion.qs  -  description
                             -------------------
    begin                : mar mar 02 2010
    copyright            : (C) 2010 by InfoSiAL S.L.
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
	var tdbLotes:FLTableDB;
	var tdbCentrosCoste:FLTableDB;
	var tdbTareas:FLTableDB;

	var picCuadricula_:Picture; /// Dibuja los recuadros
	var picTareas_:Picture; /// Dibuja las tareas

	var aColores_:Array;
	var aLotes_:Array;
	var aLotesI_:Array;
	var aTareas:Array;
	var aTareasI:Array;
	var aCentros:Array;
	var aCentrosI:Array;
	var aAnchoDia_:Array;
	var pix_;
	var graf_:Array;
	var xFechas_:Array; /// Array que indica la coordenada X para cada fecha en el diagrama de Gantt
	var fechaMax_:Date;

	var iAnchoActual_:Number; /// Índice del ancho por día actual

	var bloqueoLote_:Boolean;

	function oficial( context ) { interna( context ); }
	function cargarDatos() {
		return this.ctx.oficial_cargarDatos();
	}
	function dibujarCuadricula() {
		return this.ctx.oficial_dibujarCuadricula();
	}
	function dibujarTareas() {
		return this.ctx.oficial_dibujarTareas();
	}
	function dibujarTarea(pic:Picture, t:Number):Boolean {
		return this.ctx.oficial_dibujarTarea(pic, t);
	}
	function dameXFecha(fecha:Date):Number {
		return this.ctx.oficial_dameXFecha(fecha);
	}
	function fechaCabecera(fecha:String):String {
		return this.ctx.oficial_fechaCabecera(fecha);
	}
	function actualizarGantt():String {
		return this.ctx.oficial_actualizarGantt();
	}
	function colores() {
		return this.ctx.oficial_colores();
	}
	function agregarLoteArray(codLote:String):Boolean {
		return this.ctx.oficial_agregarLoteArray(codLote);
	}
// 	function tbnCerca_clicked() {
// 		return this.ctx.oficial_tbnCerca_clicked();
// 	}
// 	function tbnLejos_clicked() {
// 		return this.ctx.oficial_tbnLejos_clicked();
// 	}
	function sldEscala_valueChanged(valor:Number) {
		return this.ctx.oficial_sldEscala_valueChanged(valor);
	}
	function tbnAtras_clicked() {
		return this.ctx.oficial_tbnAtras_clicked();
	}
	function tbnAlante_clicked() {
		return this.ctx.oficial_tbnAlante_clicked();
	}
	function datosGantt(anchoDia:Number) {
		return this.ctx.oficial_datosGantt(anchoDia);
	}
	function dibujarGantt() {
		return this.ctx.oficial_dibujarGantt();
	}
	function tdbTareas_newBuffer() {
		return this.ctx.oficial_tdbTareas_newBuffer();
	}
	function tdbLotes_newBuffer() {
		return this.ctx.oficial_tdbLotes_newBuffer();
	}
	function tdbCentrosCoste_newBuffer() {
		return this.ctx.oficial_tdbCentrosCoste_newBuffer();
	}
	function filtrarTareas(masFiltro:String) {
		return this.ctx.oficial_filtrarTareas(masFiltro);
	}
	function filtrarLotes() {
		return this.ctx.oficial_filtrarLotes();
	}
	function resaltarTareasLote(codLote:String):Boolean {
		return this.ctx.oficial_resaltarTareasLote(codLote);
	}
	function resaltarTarea(t:Number):Boolean {
		return this.ctx.oficial_resaltarTarea(t);
	}
	function redibujarCuadricula() {
		return this.ctx.oficial_redibujarCuadricula();
	}
	function redibujarTareas() {
		return this.ctx.oficial_redibujarTareas();
	}
	function dameIndiceTarea(idTarea:String):Number {
		return this.ctx.oficial_dameIndiceTarea(idTarea);
	}
	function marcarSecuencias(codLote:String) {
		return this.ctx.oficial_marcarSecuencias(codLote);
	}
	function vistaTablas() {
		return this.ctx.oficial_vistaTablas();
	}
	function marcaTarea(aTarea:Array):Boolean {
		return this.ctx.oficial_marcaTarea(aTarea);
	}
	function filtroLotes():String {
		return this.ctx.oficial_filtroLotes();
	}
	function iniciarTablaLotes() {
		return this.ctx.oficial_iniciarTablaLotes();
	}
	function tbnOrdenLotes_clicked() {
		return this.ctx.oficial_tbnOrdenLotes_clicked();
	}
	function recalcularOrdenLotes(){
		return this.ctx.oficial_recalcularOrdenLotes()
	}
	function comprobarLote(iLote:Array):Boolean {
		return this.ctx.oficial_comprobarLote(iLote);
	}
	function tbnSubirPrioLote_clicked() {
		return this.ctx.oficial_tbnSubirPrioLote_clicked();
	}
	function tbnBajarPrioLote_clicked() {
		return this.ctx.oficial_tbnBajarPrioLote_clicked();
	}
	function moverLote(direccion:Number) {
		return this.ctx.oficial_moverLote(direccion);
	}
	function borrarPlanificacionLote(codLote:String):Boolean {
		return this.ctx.oficial_borrarPlanificacionLote(codLote);
	}
	function calcularPlan(ordenInicial:Number, codLoteInicial:String):Boolean {
		return this.ctx.oficial_calcularPlan(ordenInicial, codLoteInicial);
	}
	function fechaTopeLote(codLote:String):String {
		return this.ctx.oficial_fechaTopeLote(codLote);
	}
	function mostrarDatosLote(codLote:String) {
		return this.ctx.oficial_mostrarDatosLote(codLote);
	}
	function marcarFechaTope(fecha:String):Boolean {
		return this.ctx.oficial_marcarFechaTope(fecha);
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
	this.iface.bloqueoLote_ = false;
	this.iface.aAnchoDia_ = [30, 40, 50, 60, 70, 80, 90, 100, 120, 150];
	this.iface.iAnchoActual_ = 5;
	this.iface.colores();
	this.iface.actualizarGantt();

	connect(this.child("tbnActualizar"), "clicked()", this, "iface.actualizarGantt()");
// 	connect(this.child("tbnCerca"), "clicked()", this, "iface.tbnCerca_clicked()");
// 	connect(this.child("tbnLejos"), "clicked()", this, "iface.tbnLejos_clicked()");
// 	connect(this.child("sldEscala"), "valueChanged(int)", this, "iface.sldEscala_valueChanged()");
	connect(this.child("sldEscala"), "valueChanged(int)", this, "iface.sldEscala_valueChanged()");
	connect(this.child("tbnAtras"), "clicked()", this, "iface.tbnAtras_clicked()");
	connect(this.child("tbnAlante"), "clicked()", this, "iface.tbnAlante_clicked()");
	connect(this.child("tbnOrdenLotes"), "clicked()", this, "iface.tbnOrdenLotes_clicked()");
	connect(this.child("tbnSubirPrioLote"), "clicked()", this, "iface.tbnSubirPrioLote_clicked()");
	connect(this.child("tbnBajarPrioLote"), "clicked()", this, "iface.tbnBajarPrioLote_clicked()");

	this.iface.tdbLotes = this.child("tdbLotes");
	this.iface.tdbCentrosCoste = this.child("tdbCentrosCoste");
	this.iface.tdbTareas = this.child("tdbTareas");
	connect(this.iface.tdbLotes.cursor(), "newBuffer()", this, "iface.tdbLotes_newBuffer");
	connect(this.iface.tdbCentrosCoste.cursor(), "newBuffer()", this, "iface.tdbCentrosCoste_newBuffer");
	connect(this.iface.tdbTareas.cursor(), "newBuffer()", this, "iface.tdbTareas_newBuffer");

	this.iface.vistaTablas();
	this.iface.filtrarTareas();
	this.iface.iniciarTablaLotes();
}


//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_filtrarTareas(masFiltro:String)
{
	var filtro:String = "estado IN ('PTE', 'OFF')";
	if (masFiltro) {
		filtro += " AND " + masFiltro;
	}
	this.iface.tdbTareas.setFilter(filtro);
	this.iface.tdbTareas.refresh();
}

function oficial_iniciarTablaLotes()
{
	var campos:Array = ["ordenprod", "codlote", "referencia"];
	this.iface.tdbLotes.setOrderCols(campos);
	this.iface.filtrarLotes();
}
function oficial_filtrarLotes()
{
	this.iface.tdbLotes.setFilter(this.iface.filtroLotes());
	this.iface.tdbLotes.refresh();
}

function oficial_filtroLotes():String
{
	return "estado IN ('PTE', 'EN CURSO')";
}

function oficial_actualizarGantt()
{
	this.iface.cargarDatos();
	
	this.iface.datosGantt(this.iface.aAnchoDia_[this.iface.iAnchoActual_]);
	this.iface.dibujarGantt();
}

function oficial_datosGantt(anchoDia:Number)
{
	var tamanno:Size = this.child( "lblPlan" ).size;
	var d:Array = this.iface.graf_;
	d.ancho = tamanno.width; ///1000; /// Ancho total del lienzo
	d.alto = tamanno.height; ///600; /// Alto total del lienzo
	d.offX = 0; /// Margen X del lienzo
	d.offY = 0; /// Margen Y del lienzo
	d.altoCentro = 30; /// Altura de las filas (centros)
	d.anchoCabCentro = 100; /// Anchura de la columna de cabecera (nombres de centro)
	d.altoCabDias = 20; /// Altura de la fila de cabecera (días)
	// d.anchoDias = parseInt(d.ancho) - parseInt(d.anchoCabCentro); /// Anchura total de las columnas días
	d.altoGantt = 0; /// Altura de la tabla del diagrama (según el número de centros)
	// d.diasGantt = 15; /// Número de días representados
	d.offXCuad = 5; /// Offset X de texto en cuadrícula
	d.offYCuad = 5; /// Offset Y de texto en cuadrícula
	d.anchoDia = anchoDia; /// Anchura de la columna días
	d.factorFecha = d.anchoDia / (1000 * 60 * 60 * 24); /// Factor de conversión pixels / mseg
	d.xCuadriculaGantt = parseInt(d.offX) + parseInt(d.anchoCabCentro); /// Coord X del inicio de la cuadrícula
	d.yCuadriculaGantt = parseInt(d.offY) + parseInt(d.altoCabDias); /// Coord X del inicio de la cuadrícula
	d.anchoSaltoDia = d.anchoDia * 0.2; /// Ancho del hueco que indica un salto de días
}

function oficial_dibujarCuadricula()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var fechaInicio:String = this.child("dedFechaInicio").date;
	if (!fechaInicio || fechaInicio == undefined) {
		fechaInicio = new Date();
		fechaInicio.setHours(0);
		fechaInicio.setMinutes(0);
		fechaInicio.setSeconds(0);
		fechaInicio = fechaInicio.toString();
	}
	this.iface.xFechas_ = [];

	var d:Array = this.iface.graf_;

	var xTxt:Number, yTxt:Number; /// Posiciones de texto en cuadrícula
	var x:Number, y:Number;
	

	if (this.iface.picCuadricula_) {
		this.iface.picCuadricula_.cleanup();
	}
	this.iface.picCuadricula_ = new Picture;
	pic = this.iface.picCuadricula_;
	var clr = new Color();
	var cGris = new Color();
	var cBlanco = new Color();
	var clf = new Font();
	pic.begin();

	clr.setRgb( 0, 0, 0 );
	cGris.setRgb( 200, 200, 200 );
	cBlanco.setRgb( 255, 255, 255 );
	pic.setPen( clr, 1); // pic.DotLine );

	d.altoGantt = parseInt(d.altoCabDias) + (this.iface.aCentros.length * d.altoCentro);

	var qryFechas:FLSqlQuery = new FLSqlQuery;
	qryFechas.setTablesList("pr_calendario");
	qryFechas.setSelect("fecha");
	qryFechas.setFrom("pr_calendario");
	qryFechas.setWhere("fecha >= '" + fechaInicio + "' and tiempo > 0 ORDER BY fecha");
	qryFechas.setForwardOnly(true);
	if (!qryFechas.exec()) {
		return false;
	}
	
	x = d.offX;
	pic.drawLine( x, d.offY, x, parseInt(d.offY) + parseInt(d.altoGantt));
 	x += parseInt(d.anchoCabCentro)
	var i:Number = 0;
	var dFecha:Date;
	var sFecha:String, sFechaAnt:String = "";
	var maxX:Number = d.ancho - d.anchoDia;
	while (qryFechas.next() && x < maxX) {
		dFecha = qryFechas.value("fecha");
		sFecha = dFecha.toString();
debug("fecha = " + sFecha);
		if (sFechaAnt != "" && sFecha != util.addDays(sFechaAnt, 1).toString()) {
			pic.drawLine( x, d.offY, x, parseInt(d.offY) + parseInt(d.altoGantt));
			pic.setBrush(cGris);
			pic.setPen(cGris);
			pic.drawRect(x + 1, d.offY, d.anchoSaltoDia - 1, d.alto - d.offY);
			pic.setPen(clr);
			pic.setBrush(cBlanco);
			x += parseInt(d.anchoSaltoDia);
		}
		this.iface.xFechas_[sFecha] = x;
		pic.setBrush(cGris);
		pic.setPen(cGris);
		pic.drawRect(x + 1, d.offY, d.anchoDia - 1, d.altoCabDias - d.offY);
		pic.setPen(clr);
		pic.setBrush(cBlanco);
		pic.drawLine( x, d.offY, x, parseInt(d.offY) + parseInt(d.altoGantt));
		xTxt = x + parseInt(d.offXCuad);
		yTxt = d.offY + parseInt(d.altoCabDias) - parseInt(d.offYCuad);
		pic.drawText(xTxt, yTxt, this.iface.fechaCabecera(dFecha));
		x += parseInt(d.anchoDia);
		sFechaAnt = sFecha;
	}
	pic.drawLine( x, d.offY, x, parseInt(d.offY) + parseInt(d.altoGantt));
	d.xFinGantt = x;
	this.iface.fechaMax_ = dFecha;

	y = d.offY;
	pic.drawLine( d.offX, y, d.xFinGantt, y);
	pic.setBrush(cGris);
	pic.setPen(cGris);
	pic.drawRect(d.offX + 1, y + 1, d.anchoCabCentro- 1, d.altoCentro);
	pic.setPen(clr);
	pic.setBrush(cBlanco);
	y = d.offY + parseInt(d.altoCabDias)
	pic.drawLine( d.offX, y, d.xFinGantt, y);
	for (var c:Number = 0; c < this.iface.aCentros.length; c++) {
		pic.setBrush(cGris);
		pic.setPen(cGris);
		pic.drawRect(d.offX + 1, y + 1, d.anchoCabCentro - 1, d.altoCentro);
		pic.setPen(clr);
		pic.setBrush(cBlanco);
		y = d.offY + parseInt(d.altoCabDias) + (d.altoCentro * (c + 1));
		pic.drawLine(d.offX, y, d.xFinGantt, y);
		xTxt = d.offX + parseInt(d.offXCuad);
		yTxt = y - parseInt(d.offYCuad);
		pic.drawText(xTxt, yTxt, this.iface.aCentros[c]["codcentro"]);
	}
	
	var lblPix = this.child( "lblPlan" );
	this.iface.pix_ = new Pixmap();
	var devSize = this.child( "lblPlan" ).size;//new Size(ancho, alto);
	devSize.width -= 2; /// Evita que el formulario crezca al refescar el gráfico
	this.iface.pix_.resize( devSize );
	clr.setRgb( 255, 255, 255 );
	this.iface.pix_.fill( clr );
	this.iface.pix_ = pic.playOnPixmap( this.iface.pix_ );
	lblPix.pixmap = this.iface.pix_;
// 	pic.end();

}

function oficial_colores()
{
	this.iface.aColores_ = [];

	this.iface.aColores_[0] = new Color();
	this.iface.aColores_[0].setRgb(200, 100, 100);
	this.iface.aColores_[1] = new Color();
	this.iface.aColores_[1].setRgb(100, 200, 100);
	this.iface.aColores_[2] = new Color();
	this.iface.aColores_[2].setRgb(100, 100, 200);
	this.iface.aColores_[3] = new Color();
	this.iface.aColores_[3].setRgb(200, 200, 100);
}

function oficial_dibujarTareas()
{
	var x:Number, y:Number;
	var xTxt:Number, yTxt:Number; /// Posiciones de texto en cuadrícula

	if (this.iface.picTareas_) {
		this.iface.picTareas_.cleanup();
	}
	this.iface.picTareas_ = new Picture;
	var pic:Picture = this.iface.picTareas_;
	var clr = new Color();
	var clf = new Font();
	pic.begin();

	clr.setRgb( 0, 0, 0 );
	pic.setPen( clr, 1); // pic.DotLine );

	for (var t:Number = 0; t < this.iface.aTareas.length; t++) {
		if (!this.iface.dibujarTarea(pic, t)) {
			return false;
		}
	}

	var lblPix = this.child( "lblPlan" );
	this.iface.pix_ = pic.playOnPixmap( this.iface.pix_ );
	lblPix.pixmap = this.iface.pix_;
// 	pic.end();
}

/** \D Dibuja la tarea número t con el objeto pic
@param	pic: Objeto picture
@param	t: Índice de la tarea
\end */
function oficial_dibujarTarea(pic:Picture, t:Number):Boolean
{
	var d:Array = this.iface.graf_;

	var fechaMin:Date = this.child("dedFechaInicio").date;
	var altoTarea:Number = d.altoCentro * 0.5;
	var offYTarea:Number = d.altoCentro * 0.1;
	
	var fechaInicio:Date = this.iface.aTareas[t]["inicioprev"];
	this.iface.aTareas[t]["rect"] = false;
// debug("fechaInicio = " + fechaInicio);
// debug("fechaMin = " + fechaMin);
// debug("this.iface.fechaMax_ = " + this.iface.fechaMax_);

	var x1:Number;
	if (flprodppal.iface.compararFechas(fechaInicio, fechaMin) == 2) {
		x1 = d.xCuadriculaGantt;
	} else if (flprodppal.iface.compararFechas(fechaInicio, this.iface.fechaMax_) == 1) {
		return true;
	} else {
		x1 = this.iface.dameXFecha(fechaInicio);
	}

	var fechaFin:Date = this.iface.aTareas[t]["finprev"];
	var x2:Number;
// debug("fechaFin = " + fechaFin);
	if (flprodppal.iface.compararFechas(fechaFin, fechaMin) == 2) {
		return true;
	} else if (flprodppal.iface.compararFechas(fechaFin, this.iface.fechaMax_) == 1) {
		x2 = d.xFinGantt;
	} else {
		x2 = this.iface.dameXFecha(fechaFin);
	}

// debug("x1 = " + x1);
	var iCentro:Number = this.iface.aCentrosI[this.iface.aTareas[t]["codcentro"]];
	var y1:Number = d.yCuadriculaGantt + (iCentro * d.altoCentro)
	var anchoTarea:Number = parseInt(x2) - parseInt(x1);
	var codLote:String = this.iface.aTareas[t]["codlote"];
	var colorTarea = this.iface.aLotes_[this.iface.aLotesI_[codLote]]["color"];
debug("codTarea  = "  + this.iface.aTareas[t]["idtarea"]);
debug("coodlte  = "  + this.iface.aTareas[t]["codlote"]);
debug("idlote  = "  + this.iface.aLotesI_[codLote]);
	pic.setBrush(colorTarea);
	var rect = new Rect(x1, y1 + parseInt(offYTarea), anchoTarea, altoTarea);
	this.iface.aTareas[t]["rect"] = rect;
	pic.drawRect(rect);
	if (this.iface.aTareas[t]["marca"]) {
		var clrAnt = new Color();
		var clrMarca = new Color();
		clrMarca.setRgb(255, 0, 0);
		clrAnt.setRgb(0, 0, 0);
		pic.setPen(clrMarca);
		pic.drawText(x1 + parseFloat(anchoTarea) - 10, y1 + parseInt(offYTarea) + parseFloat(altoTarea), "*");
		pic.setPen(clrAnt);
	}
	return true;
}

/** \D Busca la posición X asociada a una fecha
@param	fecha: Fecha a buscar
\end */
function oficial_dameXFecha(fecha:Date):Number
{
	var util:FLUtil = new FLUtil;
	var d:Array = this.iface.graf_;
// 	var fechaInicio:Date = this.child("dedFechaInicio").date;
// 	fechaInicio = util.addDays(fechaInicio, 1);
debug("\n\n");
// debug("fechaInicio = " + fechaInicio);
debug("fecha = " + fecha);
	
// 	var dFechaInicio:Date = new Date(Date.parse(fechaInicio));
	var dFechaH:Date = fecha; // new Date(Date.parse(fecha));
// 	var dFechaD:Date = new Date(Date.parse(fecha));
	var dFechaD:Date = new Date(Date.parse(fecha.toString()));
	dFechaD.setHours(0);
	dFechaD.setMinutes(0);
	dFechaD.setSeconds(0);
	
	var x:Number;
	try {
		x = this.iface.xFechas_[dFechaD.toString()];
	} catch (e) {
		return d.ancho;
	}

	var ms:Number = dFechaH.getTime() - dFechaD.getTime();
debug("dFechaH.getTime() = " + dFechaH.getTime());
debug("dFechaD.getTime() = " + dFechaD.getTime());
debug("ms = " + ms);
	var pixels:Number = ms * d.factorFecha;
debug("pixels = " + pixels);
	var res:Number = parseInt(x) + parseInt(pixels)
debug("res = " + res);
	return res;
}

function oficial_fechaCabecera(fecha:String):String
{
	if (!fecha) {
		return "";
	}
	var valor:String = fecha.toString();
	var res:String = valor.mid(8, 2) + "-" + valor.mid(5, 2);
	return res;
	
}

function oficial_cargarDatos()
{
	var cursor:FLSqlCursor = this.cursor();
	var fechaInicio:String = this.child("dedFechaInicio").date;
	if (!fechaInicio || fechaInicio == undefined) {
		fechaInicio = new Date();
		fechaInicio.setHours(0);
		fechaInicio.setMinutes(0);
		fechaInicio.setSeconds(0);
		fechaInicio = fechaInicio.toString();
		this.child("dedFechaInicio").date = fechaInicio;
	}

	this.iface.aLotes_ = [];
	this.iface.aLotesI_ = [];
	this.iface.aTareas = [];
	this.iface.aTareasI = [];
	this.iface.aCentros = [];
	this.iface.aCentrosI = [];
	this.iface.graf_ = [];

	var qryTareas:FLSqlQuery = new FLSqlQuery;
	qryTareas.setTablesList("pr_tareas");
	qryTareas.setSelect("idtarea, fechainicioprev, horainicioprev, fechafinprev, horafinprev, tiempoprevisto, codcentro, idobjeto");
	qryTareas.setFrom("pr_tareas");
	qryTareas.setWhere("fechafinprev >= '" + fechaInicio + "'");
	qryTareas.setForwardOnly(true);
	if (!qryTareas.exec()) {
		return false;
	}
	var t:Number = 0;
	var fechaInicioT:String, fechaFinT:String, horaInicioT:String, horaFinT:String;
	var codLote:String, fecha:String, idTarea:String;
	while (qryTareas.next()) {
		idTarea = qryTareas.value("idtarea");
		this.iface.aTareas[t] = [];
		this.iface.aTareas[t]["idtarea"] = idTarea;
		this.iface.aTareasI[idTarea] = t;
		fechaInicioT = qryTareas.value("fechainicioprev");
		if (!fechaInicioT || fechaInicioT == undefined) {
			continue;
		}
		fechaFinT = qryTareas.value("fechafinprev");
		if (!fechaFinT || fechaFinT == undefined) {
			continue;
		}
		horaInicioT = qryTareas.value("horainicioprev");
		if (!horaInicioT || horaInicioT == undefined) {
			continue;
		}
		horaFinT = qryTareas.value("horafinprev");
		if (!horaFinT || horaFinT == undefined) {
			continue;
		}
		fecha = fechaInicioT.toString().left(10) + "T" + horaInicioT.toString().right(8);
		this.iface.aTareas[t]["inicioprev"] = new Date(Date.parse(fecha));
		fecha = fechaFinT.toString().left(10) + "T" + horaFinT.toString().right(8);
		this.iface.aTareas[t]["finprev"] = new Date(Date.parse(fecha));
		this.iface.aTareas[t]["tiempoprevisto"] = qryTareas.value("tiempoprevisto");
		this.iface.aTareas[t]["codcentro"] = qryTareas.value("codcentro");
		codLote = qryTareas.value("idobjeto");
		this.iface.aTareas[t]["codlote"] = codLote;
		this.iface.aTareas[t]["rect"] = false;
		this.iface.aTareas[t]["marca"] = this.iface.marcaTarea(this.iface.aTareas[t]);
		if (!this.iface.agregarLoteArray(codLote)) {
			return false;
		}
		t++;
	}

	var qryCentros:FLSqlQuery = new FLSqlQuery;
	qryCentros.setTablesList("pr_centroscoste");
	qryCentros.setSelect("codcentro");
	qryCentros.setFrom("pr_centroscoste");
	qryCentros.setWhere("1 = 1 order by codcentro ");
	qryCentros.setForwardOnly(true);
	if (!qryCentros.exec()) {
		return false;
	}
	var c:Number = 0;
	var codCentro:String;
	while (qryCentros.next()) {
		codCentro = qryCentros.value("codcentro");
		this.iface.aCentrosI[codCentro] = c;
		this.iface.aCentros[c] = [];
		this.iface.aCentros[c]["codcentro"] = codCentro;
		c++;
	}
}

/** Indica si hay que marcar la tarea porque no pueda finalizarse antes de la fecha de pedido
\end */
function oficial_marcaTarea(aTarea:Array):Boolean
{
	var util:FLUtil = new FLUtil;
	var codLote:String = aTarea["codlote"];
	var fechaPrevista:String = this.iface.fechaTopeLote(codLote);
	if (!fechaPrevista) {
		return false;
	}
	if (util.daysTo(aTarea["finprev"], fechaPrevista) < 0) {
		return true;
	}
	return false;
}

/** \D Comprueba si el lote indicado cumple su fecha de producción, es decir, que las tareas de su proceso de producción terminen antes de su fecha de alta en el stock
\end */
function oficial_comprobarLote(iLote:Array):Boolean
{
	var util:FLUtil = new FLUtil;
	var codLote:String = this.iface.aLotes_[iLote]["codlote"];
	var fechaPrevista:String = util.sqlSelect("movistock", "fechaprev", "codlote = '" + codLote + "' AND cantidad > 0");
	this.iface.aLotes_[iLote]["fechaprod"] = false;
	this.iface.aLotes_[iLote]["cumplefechaprod"] = true;
	if (fechaPrevista) {
		this.iface.aLotes_[iLote]["fechaprod"] = fechaPrevista;
		/// Cambiar por un repaso a las tareas del array
		if (util.sqlSelect("pr_tareas", "idtarea", "tipoobjeto = 'lotesstock' AND idobjeto = '" + codLote + "' AND fechafinprev >= '" + fechaPrevista + "'")) {
			this.iface.aLotes_[iLote]["cumplefechaprod"] = false;
		}
	}
	return true;
}

function oficial_agregarLoteArray(codLote:String):Boolean
{
	var aLote:Array = [];
	try {
		aLote = this.iface.aLotesI_[codLote];
	} catch (e) {
		var iLote:Number = this.iface.aLotes_.length;
		this.iface.aLotes_[iLote] = [];
debug("iLote = " + iLote);
debug("resto = " + iLote % this.iface.aColores_.length);
debug("length = " + this.iface.aColores_.length);
		this.iface.aLotes_[iLote]["color"] = this.iface.aColores_[parseInt(codLote.right(6)) % this.iface.aColores_.length];
		this.iface.aLotes_[iLote]["codlote"] = codLote;
		this.iface.aLotesI_[codLote] = iLote;
		if (!this.iface.comprobarLote(iLote)) {
			return false;
		}
	}
	return true;
}

function oficial_sldEscala_valueChanged(valor:Number)
{
	this.iface.iAnchoActual_ = valor;
	var ancho:Number = this.iface.aAnchoDia_[this.iface.iAnchoActual_];
	this.iface.datosGantt(ancho);
	this.iface.dibujarCuadricula();
	this.iface.dibujarGantt();
	this.iface.tdbLotes_newBuffer();
}

// function oficial_tbnCerca_clicked()
// {
// 	if ((this.iface.iAnchoActual_ + 1) < this.iface.aAnchoDia_.length) {
// 		this.iface.iAnchoActual_++;
// 		var ancho:Number = this.iface.aAnchoDia_[this.iface.iAnchoActual_];
// 		this.iface.datosGantt(ancho);
// 		this.iface.dibujarCuadricula();
// 		this.iface.dibujarGantt();
// 		this.iface.tdbLotes_newBuffer();
// 	}
// }
// 
// function oficial_tbnLejos_clicked()
// {
// 	if ((this.iface.iAnchoActual_) > 0) {
// 		this.iface.iAnchoActual_--;
// 		var ancho:Number = this.iface.aAnchoDia_[this.iface.iAnchoActual_];
// 		this.iface.datosGantt(ancho);
// 		this.iface.dibujarCuadricula();
// 		this.iface.dibujarGantt();
// 		this.iface.tdbLotes_newBuffer();
// 	}
// }

function oficial_dibujarGantt()
{
	this.iface.dibujarCuadricula();
	this.iface.dibujarTareas();
}

function oficial_tbnAtras_clicked()
{
	var util:FLUtil = new FLUtil;

	var fechaInicio:String = this.child("dedFechaInicio").date;
	if (!fechaInicio || fechaInicio == undefined) {
		fechaInicio = new Date();
		fechaInicio.setHours(0);
		fechaInicio.setMinutes(0);
		fechaInicio.setSeconds(0);
		fechaInicio = fechaInicio.toString();
	}
	fechaInicio = util.addDays(fechaInicio, -1);
	this.child("dedFechaInicio").date = fechaInicio;
	this.iface.dibujarGantt();
}

function oficial_tbnAlante_clicked()
{
	var util:FLUtil = new FLUtil;

	var fechaInicio:String = this.child("dedFechaInicio").date;
	if (!fechaInicio || fechaInicio == undefined) {
		fechaInicio = new Date();
		fechaInicio.setHours(0);
		fechaInicio.setMinutes(0);
		fechaInicio.setSeconds(0);
		fechaInicio = fechaInicio.toString();
	}
	fechaInicio = util.addDays(fechaInicio, 1);
	this.child("dedFechaInicio").date = fechaInicio;
	this.iface.dibujarGantt();
}

function oficial_tdbLotes_newBuffer()
{
	if (this.iface.bloqueoLote_) {
		return;
	}
	var curLote:FLSqlCursor = this.iface.tdbLotes.cursor();
	var codLote:String = curLote.valueBuffer("codlote");
	if (!codLote) {
		return false;
	}
	this.iface.filtrarTareas("idobjeto = '" + codLote + "'");
	this.iface.resaltarTareasLote(codLote);
	this.iface.mostrarDatosLote(codLote);
}

function oficial_mostrarDatosLote(codLote:String)
{
	var util:FLUtil = new FLUtil;
	var fechaTope:String = this.iface.fechaTopeLote(codLote);
	this.iface.marcarFechaTope(fechaTope);

	var curLote:FLSqlCursor = this.child("tdbLotes").cursor();
	var referencia:String = curLote.valueBuffer("referencia");
	var cantidad:String = curLote.valueBuffer("canlote");
	var desArticulo:String = util.sqlSelect("articulos", "descripcion", "referencia = '" + referencia + "'");
	var sFechaTope:String = util.dateAMDtoDMA(fechaTope);
	var datos:String = util.translate("scripts", "%1. %2 (%3). Fecha límite %4").arg(codLote).arg(desArticulo).arg(cantidad).arg(sFechaTope);
	this.child("lblLote").text = datos;
	return false;
}

function oficial_fechaTopeLote(codLote:String):String
{
	var util:FLUtil = new FLUtil;
	var fechaPrevista:String = util.sqlSelect("movistock", "fechaprev", "codlote = '" + codLote + "' AND cantidad > 0");
	return fechaPrevista;
}


function oficial_tdbCentrosCoste_newBuffer()
{
	var curCentro:FLSqlCursor = this.iface.tdbCentrosCoste.cursor();
	var codCentro:String = curCentro.valueBuffer("codcentro");
	if (!codCentro) {
		return false;
	}
	this.iface.filtrarTareas("codCentro = '" + codCentro + "'");
}

function oficial_tdbTareas_newBuffer()
{
}

function oficial_resaltarTareasLote(codLote:String):Boolean
{
	this.iface.redibujarCuadricula();
	this.iface.redibujarTareas();

	for (var i:Number = 0; i < this.iface.aTareas.length; i++) {
		if (this.iface.aTareas[i]["codlote"] == codLote) {
			this.iface.resaltarTarea(i);
		}
	}
	this.iface.marcarSecuencias(codLote);
}

function oficial_marcarSecuencias(codLote:String)
{
	var util:FLUtil = new FLUtil;
	var d:Array = this.iface.graf_;

	var idProceso:String = util.sqlSelect("pr_procesos", "idproceso", "idobjeto = '" + codLote + "'");
	if (!idProceso) {
		return false;
	}
	var idTipoProceso:String = util.sqlSelect("pr_procesos", "idtipoproceso", "idproceso = " + idProceso);
	var qrySecuencias:FLSqlQuery = new FLSqlQuery();
	qrySecuencias.setTablesList("pr_procesos,pr_secuencias,pr_tareas");
	qrySecuencias.setSelect("t1.idtarea, t2.idtarea");
	qrySecuencias.setFrom("pr_secuencias s INNER JOIN pr_tareas t1 ON (s.tareainicio = t1.idtipotareapro AND t1.idproceso = " + idProceso + ") INNER JOIN pr_tareas t2 ON (s.tareafin = t2.idtipotareapro AND t2.idproceso = " + idProceso + ")");
	qrySecuencias.setWhere("s.idtipoproceso = '" + idTipoProceso + "'");
	qrySecuencias.setForwardOnly(true);
debug(qrySecuencias.sql());
	if (!qrySecuencias.exec()) {
		return false;
	}

	var pic:Picture = new Picture;
	var clr = new Color();
	var clf = new Font();
	pic.begin();

	clr.setRgb( 0, 0, 200 );
	pic.setPen( clr, 2);
	pic.setBrush(clr);	
	
	var t1:Number, t2:Number;
	var idTarea1:String, idTarea2:String;
	var rect1:Rect, rect2:Rect;
	var alto1:Number;
	var alto2:Number;
	while (qrySecuencias.next()) {
		idTarea1 = qrySecuencias.value("t1.idtarea");
debug("idTarea1 " + idTarea1 );
		t1 = this.iface.dameIndiceTarea(idTarea1);
		if (t1 == -1) {
			continue;
		}
		idTarea2 = qrySecuencias.value("t2.idtarea");
debug("idTarea2 " + idTarea2 );
		t2 = this.iface.dameIndiceTarea(idTarea2);
		if (t2 == -1) {
			continue;
		}
		rect1 = this.iface.aTareas[t1]["rect"];
		if (!rect1) {
			continue;
		}
		rect2 = this.iface.aTareas[t2]["rect"];
		if (!rect2) {
			continue;
		}
debug("rect1.x = " + rect1.x);
debug("rect1.bottom = " + rect1.bottom);
debug("rect2.x = " + rect2.x);
debug("rect2.top = " + rect2.top);
		if (rect1.top < rect2.top) {
			alto1 = rect1.bottom + (d.altoCentro * 0.2);
			alto2 = rect1.bottom + (d.altoCentro * 0.5);
			pic.drawLine(rect1.right + 1, rect1.bottom, rect1.right + 1, alto1);
			pic.drawLine(rect1.right + 1, alto1, rect2.left + 1, alto1);
			pic.drawLine(rect2.left + 1, alto1, rect2.left + 1, rect2.top - 2);

			pic.drawLine(rect2.left + 1, rect2.top - 2, rect2.left - 4, rect2.top - 7);
			pic.drawLine(rect2.left, rect2.top - 2, rect2.left + 5, rect2.top - 7);
		} else {
			alto1 = rect1.top - (d.altoCentro * 0.2);
			alto2 = rect1.top - (d.altoCentro * 0.5);
			pic.drawLine(rect1.right + 1, rect1.top, rect1.right + 1, alto1);
			pic.drawLine(rect1.right + 1, alto1, rect2.left + 1, alto1);
			pic.drawLine(rect2.left + 1, alto1, rect2.left + 1, rect2.bottom + 2);

			pic.drawLine(rect2.left + 1, rect2.bottom + 2, rect2.left - 4, rect2.bottom + 7);
			pic.drawLine(rect2.left, rect2.bottom + 2, rect2.left + 5, rect2.bottom + 7);
// 			pic.drawRect(rect2.left - 3, rect2.bottom, 6, 6);
// 			pic.drawPie(rect2.left - 10, rect2.top - 10, 20, 20, 720, 2160);
		}
	}

	var lblPix = this.child( "lblPlan" );
	this.iface.pix_ = pic.playOnPixmap( this.iface.pix_ );
	lblPix.pixmap = this.iface.pix_;
	pic.end();

}

function oficial_dameIndiceTarea(idTarea:String):Number
{
	var res:Number;
	try {
		res = this.iface.aTareasI[idTarea];
	} catch (e) {
		res = -1;
	}
	return res;
}

function oficial_redibujarCuadricula()
{
	var clr = new Color();
	var lblPix = this.child( "lblPlan" );
	var devSize = this.child( "lblPlan" ).size;//new Size(ancho, alto);
	this.iface.pix_.resize( devSize );
	clr.setRgb( 255, 255, 255 );
	this.iface.pix_.fill( clr );
	this.iface.pix_ = this.iface.picCuadricula_.playOnPixmap( this.iface.pix_ );
	lblPix.pixmap = this.iface.pix_;
}

function oficial_redibujarTareas()
{
	var lblPix = this.child( "lblPlan" );
	this.iface.pix_ = this.iface.picTareas_.playOnPixmap( this.iface.pix_ );
	lblPix.pixmap = this.iface.pix_;
}

function oficial_resaltarTarea(t:Number):Boolean
{
	var rectTarea = this.iface.aTareas[t]["rect"];
	if (!rectTarea) {
		return false;
	}

	var pic:Picture = new Picture;
	var clr = new Color();
	var clf = new Font();
	pic.begin();

	clr.setRgb( 0, 0, 200 );
	pic.setPen( clr, 3);
	pic.drawRect(rectTarea);
	
	var lblPix = this.child( "lblPlan" );
	this.iface.pix_ = pic.playOnPixmap( this.iface.pix_ );
	lblPix.pixmap = this.iface.pix_;
	pic.end();
	
}

function oficial_marcarFechaTope(fecha:String):Boolean
{
	var pic:Picture = new Picture;
	var clr = new Color();
	var clf = new Font();
	pic.begin();

	var d:Array = this.iface.graf_;
	var x:Number = this.iface.dameXFecha(fecha);

	clr.setRgb( 200, 0, 0 );
	pic.setPen( clr, 3);
	pic.drawLine(x, 0, x, d.altoGantt);
	
	var lblPix = this.child( "lblPlan" );
	this.iface.pix_ = pic.playOnPixmap( this.iface.pix_ );
	lblPix.pixmap = this.iface.pix_;
	pic.end();
}

function oficial_vistaTablas()
{
	var aTareas:Array = ["fechainicioprev", "horainicioprev", "descripcion", "fechafinprev", "horafinprev", "idobjeto", "codcentro", "estado"];
	this.iface.tdbTareas.setOrderCols(aTareas);
}

function oficial_tbnOrdenLotes_clicked()
{
	this.iface.recalcularOrdenLotes();
	this.iface.tdbLotes.refresh();
	this.iface.actualizarGantt();
	this.iface.tdbLotes_newBuffer();
}

/** Regenera los datos del campo orden de la tabla de lotes
\end */	
function oficial_recalcularOrdenLotes()
{
	var codLote:String;
	var whereLotes:String = this.iface.filtroLotes();
	var qryLotes:FLSqlQuery = new FLSqlQuery;
	qryLotes.setTablesList("lotesstock");
	qryLotes.setSelect("codlote");
	qryLotes.setFrom("lotesstock");
	qryLotes.setWhere(whereLotes);
	qryLotes.setForwardOnly(true);
	if (!qryLotes.exec()) {
		return false;
	}
	while (qryLotes.next()) {
		codLote = qryLotes.value("codlote");
		if (!this.iface.borrarPlanificacionLote(codLote)) {
			return false;
		}
	}

	var curLotes:FLSqlCursor = new FLSqlCursor("lotesstock");
	curLotes.setActivatedCommitActions(false);
	curLotes.setActivatedCheckIntegrity(false);
	curLotes.select(whereLotes + " ORDER BY ordenprod, codlote");
	var orden:Number = 1;
	while (curLotes.next()) {
		curLotes.setModeAccess(curLotes.Edit);
		curLotes.refreshBuffer();
		curLotes.setValueBuffer("ordenprod", orden++);
		if (!curLotes.commitBuffer()) {
			return false;
		}
	}
	if (!this.iface.calcularPlan()) {
		return false;
	}
	return true;
}

function oficial_calcularPlan(ordenInicial:Number, codLoteInicial:String):Boolean
{
debug("Calcular plan");
	var util:FLUtil = new FLUtil;
	var whereLotes:String = this.iface.filtroLotes();
	if (ordenInicial) {
		whereLotes += " AND ordenprod >= " + ordenInicial;
	}
	if (codLoteInicial) {
		whereLotes += " AND codlote >= '" + codLoteInicial + "'";
	}

	var qryLote:FLSqlQuery = new FLSqlQuery;
	qryLote.setTablesList("lotesstock");
	qryLote.setSelect("codlote, canlote, referencia");
	qryLote.setFrom("lotesstock");
	qryLote.setWhere(whereLotes + " ORDER BY ordenprod, codlote");
	qryLote.setForwardOnly(true);
	if (!qryLote.exec()) {
debug("Calcular plan 1");
		return false;
	}

	flprodppal.iface.pub_limpiarMemoria();

	var idProceso:String, codLote:String;
	var aLote:Array;
	while (qryLote.next()) {
		codLote = qryLote.value("codlote");
		idProceso = util.sqlSelect("pr_procesos", "idproceso", "idobjeto = '" + codLote + "'");
		aLote = [];
		aLote["codLote"] = codLote;
		aLote["cantidad"] = qryLote.value("canlote");
		aLote["referencia"] = qryLote.value("referencia");
		aLote["idProceso"] = idProceso;
		if (!flprodppal.iface.pub_cargarTareasLote(aLote)) {
debug("Calcular plan 2 en lote " + codLote);
			return false;
		}
	}
	if (!flprodppal.iface.pub_establecerSecuencias()) {
debug("Calcular plan 3");
		return false;
	}
	if (!flprodppal.iface.pub_iniciarCentrosCoste()) {
debug("Calcular plan 4");
		return false;
	}
	if (!flprodppal.iface.pub_aplicarAlgoritmo("FIFO")) {
debug("Calcular plan 5");
		return false;
	}

	if (!qryLote.exec()) {
debug("Calcular plan 6");
		return false;
	}
	while (qryLote.next()) {
		codLote = qryLote.value("codlote");
		idProceso = util.sqlSelect("pr_procesos", "idproceso", "idobjeto = '" + codLote + "'");
		if (!flprodppal.iface.pub_actualizarTareasProceso(idProceso, codLote, false)) {
debug("Calcular plan 7");
			return false;
		}
	}
debug("Calcular plan OK");
	return true;
}

function oficial_borrarPlanificacionLote(codLote:String):Boolean
{
	var curTareasLote:FLSqlCursor = new FLSqlCursor("pr_tareas");
	curTareasLote.setActivatedCommitActions(false);
	curTareasLote.setActivatedCheckIntegrity(false);
	curTareasLote.select("tipoobjeto = 'lotesstock' AND idobjeto = '" + codLote + "' AND estado IN ('OFF', 'PTE')");
	while (curTareasLote.next()) {
		curTareasLote.setModeAccess(curTareasLote.Edit);
		curTareasLote.refreshBuffer();
		curTareasLote.setNull("fechainicioprev");
		curTareasLote.setNull("horainicioprev");
		curTareasLote.setNull("fechafinprev");
		curTareasLote.setNull("horafinprev");
		if (!curTareasLote.commitBuffer()) {
			return false;
		}
	}
	return true;	
}

function oficial_tbnSubirPrioLote_clicked()
{
	this.iface.moverLote(-1);
}

function oficial_tbnBajarPrioLote_clicked()
{
	this.iface.moverLote(1);
}

function oficial_moverLote(direccion:Number)
{
	this.iface.bloqueoLote_ = true;

	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.child("tdbLotes").cursor();
	cursor.setActivatedCommitActions(false);
	cursor.setActivatedCheckIntegrity(false);
	
	var codLote:String = cursor.valueBuffer("codlote");
	var orden:Number = cursor.valueBuffer("ordenprod");
	var orden2:Number;
	var fila:Number = this.child("tdbLotes").currentRow();
	var filtro:String = this.iface.filtroLotes();

	var codLote2:String;
	if (direccion == -1) {
		codLote2 = util.sqlSelect("lotesstock", "codlote", filtro + " AND ordenprod < " + orden + " ORDER BY ordenprod DESC");
	} else {
		codLote2 = util.sqlSelect("lotesstock", "codlote", filtro + " AND ordenprod > " + orden + " ORDER BY ordenprod");
	}
	orden2 = util.sqlSelect("lotesstock", "ordenprod", "codlote = '" + codLote2 + "'");
	if (!orden2) {
		return;
	}

	var curLote:FLSqlCursor = new FLSqlCursor("lotesstock");
	curLote.setActivatedCommitActions(false);
	curLote.setActivatedCheckIntegrity(false);

	curLote.select("codlote = '" + codLote2 + "'");
	if (!curLote.first()) {
		return;
	}
	curLote.setModeAccess(curLote.Edit);
	curLote.refreshBuffer();
	curLote.setValueBuffer("ordenprod", "-1");
	curLote.commitBuffer();

	cursor.setModeAccess(cursor.Edit);
	cursor.refreshBuffer();
	cursor.setValueBuffer("ordenprod", orden2);
	cursor.commitBuffer();

	curLote.setModeAccess(curLote.Edit);
	curLote.refreshBuffer();
	curLote.setValueBuffer("ordenprod", orden);
	curLote.commitBuffer();

	this.child("tdbLotes").refresh();
	fila += direccion;
	this.child("tdbLotes").setCurrentRow(fila);

	this.iface.bloqueoLote_ = false;
	this.iface.tdbLotes_newBuffer();
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
