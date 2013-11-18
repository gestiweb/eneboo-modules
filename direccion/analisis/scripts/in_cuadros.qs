/***************************************************************************
                 in_cuadros.qs  -  description
                             -------------------
    begin                : mie jun 30 2010
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
	function init() { this.ctx.interna_init(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var numBotonesAno_:Number;
	var paginaActual_:Number;
	var CD_LABEL:Number;
	var CD_NOMBRE:Number;
	var CD_FILTRO:Number;
	var CD_VALORES:Number;
	var aPosiciones_:Array;
	var aGraficos_:Array;
	var bloqueoSlider_:Boolean;
	var bloqueoTotalSlider_:Boolean;
	var bloqueoCommit_:Boolean;
	var bloqueoCurrentChanged_:Boolean;
	var modo_:String;
	function oficial( context ) { interna( context );}
	function dibujarPaginaActual(idPosCuadro:String) {
		return this.ctx.oficial_dibujarPaginaActual(idPosCuadro);
	}
	function refrescar() {
		return this.ctx.oficial_refrescar();
	}
	function damePixPaginaBlanco() {
		return this.ctx.oficial_damePixPaginaBlanco();
	}
	function resaltarPosicion(curPosicion:FLSqlCursor):Picture {
		return this.ctx.oficial_resaltarPosicion(curPosicion);
	}
// 	function dibujoPaginaActual() {
// 		return this.ctx.oficial_dibujoPaginaActual();
// 	}
	function dibujarPosicion(curPosicion:FLSqlCursor):pic {
		return this.ctx.oficial_dibujarPosicion(curPosicion);
	}
	function dibujarGrafico(curPosicion:FLSqlCursor):pic {
		return this.ctx.oficial_dibujarGrafico(curPosicion);
	}
	function cargarPosicion(curPosicion:FLSqlCursor):Boolean {
		return this.ctx.oficial_cargarPosicion(curPosicion);
	}
	function dameListaMesesSel():String {
		return this.ctx.oficial_dameListaMesesSel();
	}
	function dameListaTrimSel():String {
		return this.ctx.oficial_dameListaTrimSel();
	}
	function dameListaAnnosSel():String {
		return this.ctx.oficial_dameListaAnnosSel();
	}
	function tbwCuadro_currentChanged(nombreTab:String) {
		return this.ctx.oficial_tbwCuadro_currentChanged(nombreTab);
	}
	function cargarRestricciones() {
		return this.ctx.oficial_cargarRestricciones();
	}
	function dimensionYaEnTabla(nombreDim:String):Boolean {
		return this.ctx.oficial_dimensionYaEnTabla(nombreDim);
	}
	function tblDimensiones_clicked(fila:Number, col:Number) {
		return this.ctx.oficial_tblDimensiones_clicked(fila, col);
	}
	function tbnEditarGrafico_clicked() {
		return this.ctx.oficial_tbnEditarGrafico_clicked();
	}
	function cargarArrayPosiciones():Boolean {
		return this.ctx.oficial_cargarArrayPosiciones();
	}
	function actualizarPosicionArray(curPosicion:FLSqlCursor):Boolean {
		return this.ctx.oficial_actualizarPosicionArray(curPosicion);
	}
	function tdbPosicionesCuadro_currentChanged() {
		return this.ctx.oficial_tdbPosicionesCuadro_currentChanged();
	}
	function tdbPosicionesCuadro_bufferCommited() {
		return this.ctx.oficial_tdbPosicionesCuadro_bufferCommited();
	}
	function sldX_valueChanged(valor:Number) {
		return this.ctx.oficial_sldX_valueChanged(valor);
	}
	function sldY_valueChanged(valor:Number) {
		return this.ctx.oficial_sldY_valueChanged(valor);
	}
	function sldW_valueChanged(valor:Number) {
		return this.ctx.oficial_sldW_valueChanged(valor);
	}
	function sldH_valueChanged(valor:Number) {
		return this.ctx.oficial_sldH_valueChanged(valor);
	}
	function sldX_sliderReleased() {
		return this.ctx.oficial_sldX_sliderReleased();
	}
	function sldY_sliderReleased() {
		return this.ctx.oficial_sldY_sliderReleased();
	}
	function sldW_sliderReleased() {
		return this.ctx.oficial_sldW_sliderReleased();
	}
	function sldH_sliderReleased() {
		return this.ctx.oficial_sldH_sliderReleased();
	}
	function sldX_sliderPressed() {
		return this.ctx.oficial_sldX_sliderPressed();
	}
	function sldY_sliderPressed() {
		return this.ctx.oficial_sldY_sliderPressed();
	}
	function sldW_sliderPressed() {
		return this.ctx.oficial_sldW_sliderPressed();
	}
	function sldH_sliderPressed() {
		return this.ctx.oficial_sldH_sliderPressed();
	}
	function modificarGeoPosicion(campo:String, valor:Number):Boolean {
		return this.ctx.oficial_modificarGeoPosicion(campo, valor);
	}
	function refrescarSliderW(curPosicion:FLSqlCursor, x:Number) {
		return this.ctx.oficial_refrescarSliderW(curPosicion, x);
	}
	function refrescarSliderH(curPosicion:FLSqlCursor, y:Number) {
		return this.ctx.oficial_refrescarSliderH(curPosicion, y);
	}
	function tbnDiseno_clicked() {
		return this.ctx.oficial_tbnDiseno_clicked();
	}
	function tbnVisor_clicked() {
		return this.ctx.oficial_tbnVisor_clicked();
	}
	function establecerModo() {
		return this.ctx.oficial_establecerModo();
	}
	function establecerPagina(numPagina:Number) {
		return this.ctx.oficial_establecerPagina(numPagina);
	}
	function habilitarPorPagina() {
		return this.ctx.oficial_habilitarPorPagina();
	}
	function tbnPagSiguiente_clicked() {
		return this.ctx.oficial_tbnPagSiguiente_clicked();
	}
	function tbnPagAnterior_clicked() {
		return this.ctx.oficial_tbnPagAnterior_clicked();
	}
	function tbnImprimirCuadro_clicked() {
		return this.ctx.oficial_tbnImprimirCuadro_clicked();
	}
	function iniciaBGTiempo() {
		return this.ctx.oficial_iniciaBGTiempo();
	}
	function colorearBotonDim(nombreBoton:String) {
		return this.ctx.oficial_colorearBotonDim(nombreBoton);
	}
	function dameAnnoBoton(iAnno:Number):Number {
		return this.ctx.oficial_dameAnnoBoton(iAnno);
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
/** \C Cuando cambia el ejercicio actual se establece el título de las ventanas principales con
el nombre del ejercicio seleccionado
\end */
function interna_init()
{
	var cursor:FLSqlCursor = this.cursor();

	this.iface.aPosiciones_ = [];
	this.iface.aGraficos_ = [];
	this.iface.bloqueoSlider_ = false;
	this.iface.bloqueoTotalSlider_ = false;
	this.iface.bloqueoCommit_ = false;
	this.iface.bloqueoCurrentChanged_ = false;
	
	connect (this.child("tbnRefrescar"), "clicked()", this, "iface.refrescar");
	connect (this.child("tdbPosicionesCuadro").cursor(), "bufferCommited()", this, "iface.tdbPosicionesCuadro_bufferCommited()");
	connect (this.child("tdbPosicionesCuadro"), "currentChanged()", this, "iface.tdbPosicionesCuadro_currentChanged");
// 	connect (this.child("tbwCuadro"), "currentChanged(QString)", this, "iface.tbwCuadro_currentChanged");
	connect (this.child("tblDimensiones"), "clicked(int, int)", this, "iface.tblDimensiones_clicked");
	connect (this.child("tbnEditarGrafico"), "clicked()", this, "iface.tbnEditarGrafico_clicked");
	connect (this.child("sldX"), "valueChanged(int)", this, "iface.sldX_valueChanged");
	connect (this.child("sldX"), "sliderReleased()", this, "iface.sldX_sliderReleased");
	connect (this.child("sldX"), "sliderPressed()", this, "iface.sldX_sliderPressed");
	connect (this.child("sldW"), "valueChanged(int)", this, "iface.sldW_valueChanged");
	connect (this.child("sldW"), "sliderReleased()", this, "iface.sldW_sliderReleased");
	connect (this.child("sldW"), "sliderPressed()", this, "iface.sldW_sliderPressed");
	connect (this.child("sldY"), "valueChanged(int)", this, "iface.sldY_valueChanged");
	connect (this.child("sldY"), "sliderReleased()", this, "iface.sldY_sliderReleased");
	connect (this.child("sldY"), "sliderPressed()", this, "iface.sldY_sliderPressed");
	connect (this.child("sldH"), "valueChanged(int)", this, "iface.sldH_valueChanged");
	connect (this.child("sldH"), "sliderReleased()", this, "iface.sldH_sliderReleased");
	connect (this.child("sldH"), "sliderPressed()", this, "iface.sldH_sliderPressed");
	connect (this.child("tbnDiseno"), "clicked()", this, "iface.tbnDiseno_clicked");
	connect (this.child("tbnVisor"), "clicked()", this, "iface.tbnVisor_clicked");
	connect (this.child("tbnPagSiguiente"), "clicked()", this, "iface.tbnPagSiguiente_clicked");
	connect (this.child("tbnPagAnterior"), "clicked()", this, "iface.tbnPagAnterior_clicked");
	connect (this.child("tbnImprimirCuadro"), "clicked()", this, "iface.tbnImprimirCuadro_clicked");
	connect (this.child("bgMes"), "clicked(int)", this, "iface.bgMes_clicked()");
	connect (this.child("bgTrim"), "clicked(int)", this, "iface.bgTrim_clicked()");
	connect (this.child("bgAnos"), "clicked(int)", this, "iface.bgAnno_clicked()");
	
	if (!this.iface.cargarArrayPosiciones()) {
		return false;
	}
	
	formin_navegador.iface.pub_colores();
	formin_navegador.iface.pub_establecerAnos();
	this.iface.iniciaBGTiempo();
	
	this.iface.establecerPagina(1);
	
	this.iface.cargarRestricciones();
	switch (cursor.modeAccess()) {
		case cursor.Insert: {
			this.iface.tbnDiseno_clicked();
			break;
		}
		default: {
			this.iface.tbnVisor_clicked();
			break;
		}
	}
	
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_cargarArrayPosiciones():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	var curPosiciones:FLSqlCursor = new FLSqlCursor("in_posicionescuadro");
	var codCuadro:String = cursor.valueBuffer("codcuadro");
	curPosiciones.select("codcuadro = '" + codCuadro + "'");
	while (curPosiciones.next()) {
		curPosiciones.setModeAccess(curPosiciones.Browse);
		curPosiciones.refreshBuffer();
		if (!this.iface.actualizarPosicionArray(curPosiciones)) {
			return false;
		}
	}
	curPosiciones.select("codcuadro = '" + codCuadro + "'");
	while (curPosiciones.next()) {
		curPosiciones.setModeAccess(curPosiciones.Browse);
		curPosiciones.refreshBuffer();
	}
	return true;
}

function oficial_actualizarPosicionArray(curPosicion:FLSqlCursor):Boolean
{
	var aPosicion:Array;
	var id:String = curPosicion.valueBuffer("idposicioncuadro");
	var idPosicion:String = curPosicion.valueBuffer("idposicion");
	try {
		aPosicion = this.iface.aPosiciones_[id];
	} catch (e) {
		this.iface.aPosiciones_[id] = [];
		this.iface.aPosiciones_[id]["idposicion"] = false;
	}
	if (this.iface.aPosiciones_[id]["idposicion"] != idPosicion) {
		this.iface.aPosiciones_[id] = formin_navegador.iface.pub_datosPosicion(idPosicion);
		if (!this.iface.aPosiciones_[id]) {
			MessageBox.warning(util.translate("scripts", "Error al cargar la posición %1").arg(idPosicion), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
debug("Cargando pos " + id + " para cubo " + this.iface.aPosiciones_[id]["cubo"]);
	}
	return true;
}

function oficial_dibujarPaginaActual(idPosCuadro:String)
{
debug("Dibujando página pos " + idPosCuadro);
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	var codCuadro:String = cursor.valueBuffer("codcuadro");
	var where:String = "codcuadro = '" + codCuadro + "' AND pagina = " + this.iface.paginaActual_;
	
	var idPosCCursor:String;
	var aIndice:Array = [], iPos:Number = 0;
	var curPosiciones:FLSqlCursor = new FLSqlCursor("in_posicionescuadro");
	curPosiciones.select(where);
	while (curPosiciones.next()) {
debug("Evaluando posicion");
		curPosiciones.setModeAccess(curPosiciones.Browse);
		curPosiciones.refreshBuffer();
		idPosCCursor = curPosiciones.valueBuffer("idposicioncuadro");
debug(idPosCCursor + " = " + idPosCuadro);
		aIndice[iPos++] = idPosCCursor;
		if (idPosCuadro && idPosCuadro != idPosCCursor) {
			continue;
		}
		try {
			if (this.iface.aGraficos_[idPosCCursor]) {
				this.iface.aGraficos_[idPosCCursor].cleanup();
				this.iface.aGraficos_[idPosCCursor].end();
				this.iface.aGraficos_[idPosCCursor] = false;
			}
		} catch (e) {
		}
		this.iface.aGraficos_[idPosCCursor] = this.iface.dibujarPosicion(curPosiciones);
		if (!this.iface.aGraficos_[idPosCCursor]) {
			return false;
		}
	}
	
	var pix:Pixmap = this.iface.damePixPaginaBlanco()
	var pic:Picture;
	for (var i:Number = 0; i < aIndice.length; i++) {
debug("dibujando posicion " + i);
		pic = this.iface.aGraficos_[aIndice[i]];
		pix = pic.playOnPixmap( pix );
	}
	if (this.iface.modo_ == "DISEÑO") {
		var curPosicion:FLSqlCursor = this.child("tdbPosicionesCuadro").cursor();
		var idPaginaPosActual:String = curPosicion.valueBuffer("pagina");
		if (idPaginaPosActual == this.iface.paginaActual_) {
// 			pic.begin();
			pic = this.iface.resaltarPosicion(curPosicion);
			pix = pic.playOnPixmap( pix );
// 			pic.cleanup();
// 			pic.end();
		}
	}
	var lblPix = this.child( "lblPagina" );
	lblPix.pixmap = pix;
debug("OK");
}

function oficial_resaltarPosicion(curPosicion:FLSqlCursor):Picture
{
	var pic:Picture = new Picture;
	pic.begin()
	
	var clr = new Color();
	clr.setRgb( 80, 120, 160 );
	var recResaltado:Rect = new Rect(curPosicion.valueBuffer("x") - 10, curPosicion.valueBuffer("y") - 10, curPosicion.valueBuffer("ancho") + 20, curPosicion.valueBuffer("alto") + 20);
	pic.setPen(clr, 3, pic.DashLine);
	pic.drawRect(recResaltado)
	return pic;
}

function oficial_damePixPaginaBlanco()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	var ancho:Number = cursor.valueBuffer("ancho");
	var alto:Number = cursor.valueBuffer("alto");

	var clr = new Color();
	clr.setRgb( 255, 255, 255 );
	var pix = new Pixmap();
	var devSize = new Size(ancho, alto);
	pix.resize( devSize );
	pix.fill( clr );
	return pix;
}

function oficial_dibujarPosicion(curPosicion:FLSqlCursor):Picture
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	if (!this.iface.cargarPosicion(curPosicion)) {
		return false,
	}
	
	var pic:Picture = this.iface.dibujarGrafico(curPosicion);
	if (!pic) {
		return false;
	}
	return pic;
}
	
function oficial_dibujarGrafico(curPosicion:FLSqlCursor):pic
{
	var util:FLUtil = new FLUtil;
	
	var marco:Rect = new Rect(curPosicion.valueBuffer("x"), curPosicion.valueBuffer("y"), curPosicion.valueBuffer("ancho"), curPosicion.valueBuffer("alto"));
	formin_navegador.iface.tablaCargada_ = false;
	var pic:Picture = formin_navegador.iface.pub_dibujarGrafico(marco);
	if (!pic) {
		return false;
	}
	return pic;
}

function oficial_cargarPosicion(curPosicion:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	
	var id:String = curPosicion.valueBuffer("idposicioncuadro");
	if (!formin_navegador.iface.pub_establecerPosicionArray(this.iface.aPosiciones_[id])) {
		return false;
	}

	var tblDimensiones:FLTable = this.child("tblDimensiones");
	var numFilas:Number = tblDimensiones.numRows();
	var nombreNivel:String, valores:String;
	for (var i:Number = 0; i < numFilas; i++) {
		nombreNivel = tblDimensiones.text(i, this.iface.CD_NOMBRE);
		valores = tblDimensiones.text(i, this.iface.CD_VALORES);
		if (valores == "") {
			continue;
		}
		if (formin_navegador.iface.pub_nivelEnCuboActual(nombreNivel)) {
			formin_navegador.iface.pub_ponerFiltro(nombreNivel, valores);
		}
	}
	if (formin_navegador.iface.nivelBGMes_) {
		nombreNivel = formin_navegador.iface.nivelBGMes_;
		valores = this.iface.dameListaMesesSel();
		if (valores && valores != "") {
			if (formin_navegador.iface.pub_nivelEnCuboActual(nombreNivel)) {
				formin_navegador.iface.pub_ponerFiltro(nombreNivel, valores);
			}
		}
	}
	if (formin_navegador.iface.nivelBGTrim_) {
		nombreNivel = formin_navegador.iface.nivelBGTrim_;
		valores = this.iface.dameListaTrimSel();
		if (valores && valores != "") {
			if (formin_navegador.iface.pub_nivelEnCuboActual(nombreNivel)) {
				formin_navegador.iface.pub_ponerFiltro(nombreNivel, valores);
			}
		}
	}
	if (formin_navegador.iface.nivelBGAnno_) {
		nombreNivel = formin_navegador.iface.nivelBGAnno_;
		valores = this.iface.dameListaAnnosSel();
		if (valores && valores != "") {
			if (formin_navegador.iface.pub_nivelEnCuboActual(nombreNivel)) {
				formin_navegador.iface.pub_ponerFiltro(nombreNivel, valores);
			}
		}
	}
	if (!formin_navegador.iface.pub_cargarDatos()) {
		return false;
	}
	
	if (!formin_navegador.iface.pub_establecerTipoGrafico(curPosicion.valueBuffer("codtipografico"))) {
		return false;
	}
	return true;
}

function oficial_dameListaMesesSel():String
{
	var lista:String = "";
	var sMes:String;
	for (var i:Number = 0; i < 12; i++) {
		if (this.child("pbnMes" + i.toString()).on) {
			sMes = (i + 1).toString();
			lista += lista != "" ? ", " + sMes : sMes;
		}
	}
	return lista;
}

function oficial_dameListaTrimSel():String
{
	var lista:String = "";
	var sTrim:String;
	for (var i:Number = 0; i < 4; i++) {
		if (this.child("pbnTrim" + i.toString()).on) {
			sTrim = "T" + (i + 1).toString();
			lista += lista != "" ? ", " + sTrim : sTrim;
		}
	}
	return lista;
}

function oficial_dameListaAnnosSel():String
{
	var lista:String = "";
	var sAnno:String;
	for (var i:Number = 0; i < this.iface.numBotonesAno_; i++) {
debug("i = " + i);
		if (this.child("pbnAno" + i.toString()).on) {
			sAnno = this.iface.dameAnnoBoton(i);
			lista += lista != "" ? ", " + sAnno : sAnno;
		}
	}
	return lista;
}

function oficial_tbwCuadro_currentChanged(nombreTab:String)
{
	switch (nombreTab) {
		case "visor": {
			this.iface.cargarRestricciones();
			break;
		}
	}
}

function oficial_cargarRestricciones()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	var codCuadro:String = cursor.valueBuffer("codcuadro");
	
	this.iface.CD_LABEL = 0;
	this.iface.CD_FILTRO = 1;
	this.iface.CD_NOMBRE = 2;
	this.iface.CD_VALORES = 3;

	var tblDimensiones:FLTable = this.child("tblDimensiones");
	tblDimensiones.setNumRows(0);
	tblDimensiones.setNumCols(4);
	tblDimensiones.hideColumn(this.iface.CD_NOMBRE);
	tblDimensiones.hideColumn(this.iface.CD_VALORES);
	tblDimensiones.setColumnWidth(this.iface.CD_FILTRO, 500);
	tblDimensiones.setColumnLabels("*", util.translate("scripts", "Dimensión") + "*" + util.translate("scripts", "Restricción"));

	var qryCubos:FLSqlQuery = new FLSqlQuery;
	qryCubos.setTablesList("in_posicionescuadro,in_posiciones");
	qryCubos.setSelect("p.cubo");
	qryCubos.setFrom("in_posicionescuadro pc INNER JOIN in_posiciones p ON pc.idposicion = p.id");
	qryCubos.setWhere("pc.codcuadro = '" + codCuadro + "' GROUP BY p.cubo");
	qryCubos.setForwardOnly(true);
	if (!qryCubos.exec()) {
		return false;
	}
	var cubo:String;
	while (qryCubos.next()) {
		cubo = qryCubos.value("p.cubo");
	
		if (!formin_navegador.iface.pub_cambiarCubo(cubo)) {
			return false;
		}

		var aDatosNiveles:Array = formin_navegador.iface.pub_nivelesCubo();
		if (!aDatosNiveles) {
			return false;
		}
		var iNiveles:Array = aDatosNiveles["i"];
		var aNiveles:Array = aDatosNiveles["a"];
		
		var tblDimensiones = this.child("tblDimensiones");
		var eLevel:FLDomElement;
		var name:String;
		var visible:String;
		var iFila:Number = 0;
		for (var i:Number = 0; i < iNiveles.length; i++) {
			eLevel = aNiveles[iNiveles[i]]["element"];
			name = aNiveles[iNiveles[i]]["nombre"];
			if (name == formin_navegador.iface.nivelBGMes_ || name == formin_navegador.iface.nivelBGTrim_ || name == formin_navegador.iface.nivelBGAnno_) {
				continue;
			}
			if (this.iface.dimensionYaEnTabla(name)) {
				continue;
			}
			tblDimensiones.insertRows(iFila, 1);
			tblDimensiones.setText(iFila, this.iface.CD_LABEL, eLevel.attribute("alias"));
			tblDimensiones.setText(iFila, this.iface.CD_NOMBRE, name);
			iFila++;
		}
	}

	formin_navegador.iface.pub_borrarCabecerasTabla(tblDimensiones, true, false);

	return true;
}

function oficial_dimensionYaEnTabla(nombreDim:String):Boolean
{
	var tblDimensiones = this.child("tblDimensiones");
	var numFilas:Number = tblDimensiones.numRows();
	for (var iF:Number = 0; iF < numFilas; iF++) {
		if (tblDimensiones.text(iF, this.iface.CD_NOMBRE) == nombreDim) {
			return true;
		}
	}
	return false;
}

function oficial_tblDimensiones_clicked(fila:Number, col:Number)
{
	var util:FLUtil = new FLUtil();
	var tblDimensiones:Object = this.child("tblDimensiones");
	var nombreNivel:String = tblDimensiones.text(fila, this.iface.CD_NOMBRE);
debug("nombreNivel = "  +  nombreNivel);
debug("this.iface.CD_NOMBRE = "  +  this.iface.CD_NOMBRE);
	var listaSel:String = tblDimensiones.text(fila, this.iface.CD_VALORES);
	if (!listaSel) {
		listaSel = "*";
	}
	var valores:String = formin_navegador.iface.pub_seleccionarValoresNivel(nombreNivel, listaSel);
debug("valores " + valores);
	if (valores == "CANCEL!") {
debug("!valores");
		return false;
	}
	var listaAlias:String;
	var colorFila:Color;
	if (valores && valores != "") {
		listaAlias = formin_navegador.iface.pub_listarClaves(nombreNivel, valores);
		colorFila = formin_navegador.iface.colorDimSel_;
	} else {
		listaAlias = "*";
		colorFila = formin_navegador.iface.colorDimNoSel_;
		valores = "";
	}
	tblDimensiones.setText(fila, this.iface.CD_FILTRO, listaAlias);
	tblDimensiones.setText(fila, this.iface.CD_VALORES, valores);
	formin_navegador.iface.cambiarColorFilaTabla(tblDimensiones, fila, colorFila);
	tblDimensiones.adjustColumn(this.iface.CD_FILTRO);
	this.iface.dibujarPaginaActual();
	
}

function oficial_tbnEditarGrafico_clicked()
{
	var curPosicion:FLSqlCursor = this.child("tdbPosicionesCuadro").cursor();
	var idPosCuadro:String = curPosicion.valueBuffer("idposicioncuadro");
	if (!idPosCuadro) {
		return false;
	}
	if (!this.iface.cargarPosicion(curPosicion)) {
		return false,
	}
	var pic:Picture = this.iface.dibujarGrafico(curPosicion);
	if (!pic) {
		return false;
	}
	if (!formin_navegador.iface.pub_editarGrafico()) {
		return false;
	}
// 	if (!formin_navegador.iface.pub_guardarPosicionActual()) {
// 		return false;
// 	}
	if (!formin_navegador.iface.pub_guardarGraficoPos()) {
		return false;
	}
	if (!formin_navegador.iface.pub_guardarGraficoPosicionActual()) {
		return false;
	}
	this.iface.aPosiciones_[idPosCuadro]["posicion"] = formin_navegador.iface.xmlPosActual_.toString();
	this.iface.dibujarPaginaActual(idPosCuadro);
}

function oficial_tdbPosicionesCuadro_bufferCommited()
{
	if (this.iface.bloqueoCommit_) {
		return;
	}
	var curPosicion:FLSqlCursor = this.child("tdbPosicionesCuadro").cursor();
	var idPosCuadro:String = curPosicion.valueBuffer("idposicioncuadro");
	if (!idPosCuadro) {
		return false;
	}
	if (!this.iface.actualizarPosicionArray(curPosicion)) {
		return false;
	}
	this.iface.dibujarPaginaActual(idPosCuadro);
	
	if (this.iface.bloqueoCurrentChanged_) {
		this.iface.bloqueoCurrentChanged_ = false; // Al volver de edición de posiciones
		return;
	}		
}

function oficial_tdbPosicionesCuadro_currentChanged()
{
	if (this.iface.bloqueoCurrentChanged_) {
		return;
	}
	if (this.iface.bloqueoSlider_) {
		return;
	}
	
debug("oficial_tdbPosicionesCuadro_currentChanged");
	this.iface.refrescar();
	
	var curPosicion:FLSqlCursor = this.child("tdbPosicionesCuadro").cursor();
	var idPosCuadro:String = curPosicion.valueBuffer("idposicioncuadro");
	if (!idPosCuadro) {
		return false;
	}
	var cursor:FLSqlCursor = this.cursor();
	var x:Number = Math.round(100 * curPosicion.valueBuffer("x") / cursor.valueBuffer("ancho"));
	if (!isNaN(x)) {
		this.iface.bloqueoTotalSlider_ = true;
		this.child("sldX").setValue(x);
		this.iface.bloqueoTotalSlider_ = false;
	}
	this.iface.refrescarSliderW(curPosicion, x);
	
	var y:Number = Math.round(100 * curPosicion.valueBuffer("y") / cursor.valueBuffer("alto"));
	if (!isNaN(y)) {
		this.iface.bloqueoTotalSlider_ = true;
		this.child("sldY").setValue(y);
		this.iface.bloqueoTotalSlider_ = false;
	}
	this.iface.refrescarSliderH(curPosicion, y);
}

function oficial_refrescarSliderW(curPosicion:FLSqlCursor, x:Number)
{
	var cursor:FLSqlCursor = this.cursor();
	var ancho:Number = Math.round(100 * curPosicion.valueBuffer("ancho") / cursor.valueBuffer("ancho"));
	if (!isNaN(ancho)) {
		ancho += parseInt(x);
		this.iface.bloqueoTotalSlider_ = true;
		this.child("sldW").setValue(ancho);
		this.iface.bloqueoTotalSlider_ = false;
	}
}
function oficial_refrescarSliderH(curPosicion:FLSqlCursor, y:Number)
{
	var cursor:FLSqlCursor = this.cursor();
	var alto:Number = Math.round(100 * curPosicion.valueBuffer("alto") / cursor.valueBuffer("alto"));
	if (!isNaN(alto)) {
		alto += parseInt(y);
		this.iface.bloqueoTotalSlider_ = true;
		this.child("sldH").setValue(alto);
		this.iface.bloqueoTotalSlider_ = false;
	}
}

function oficial_sldX_sliderReleased()
{
	this.iface.bloqueoSlider_ = false;
	this.iface.sldX_valueChanged(this.child("sldX").value);
}

function oficial_sldY_sliderReleased()
{
	this.iface.bloqueoSlider_ = false;
	this.iface.sldY_valueChanged(this.child("sldY").value);
}

function oficial_sldX_sliderPressed()
{
	this.iface.bloqueoSlider_ = true;
}

function oficial_sldY_sliderPressed()
{
	this.iface.bloqueoSlider_ = true;
}

function oficial_sldW_sliderReleased()
{
	this.iface.bloqueoSlider_ = false;
	this.iface.sldW_valueChanged(this.child("sldW").value);
}

function oficial_sldH_sliderReleased()
{
	this.iface.bloqueoSlider_ = false;
	this.iface.sldH_valueChanged(this.child("sldH").value);
}

function oficial_sldW_sliderPressed()
{
	this.iface.bloqueoSlider_ = true;
}

function oficial_sldH_sliderPressed()
{
	this.iface.bloqueoSlider_ = true;
}

function oficial_sldX_valueChanged(valor:Number)
{
	if (this.iface.bloqueoTotalSlider_) {
		return true;
	}
	var cursor:FLSqlCursor = this.cursor();
	var x:Number = Math.round(cursor.valueBuffer("ancho") * (valor + 1) / 100);
	if (!this.iface.modificarGeoPosicion("x", x)) {
		return false;
	}

	var curPosicion:FLSqlCursor = this.child("tdbPosicionesCuadro").cursor();
	var idPosCuadro:String = curPosicion.valueBuffer("idposicioncuadro");
	if (!idPosCuadro) {
		return false;
	}
	this.iface.refrescarSliderW(curPosicion, valor);

	return true;
}

function oficial_sldY_valueChanged(valor:Number)
{
	if (this.iface.bloqueoTotalSlider_) {
		return true;
	}
	var cursor:FLSqlCursor = this.cursor();
	var y:Number = Math.round(cursor.valueBuffer("alto") * (valor + 1) / 100);
	if (!this.iface.modificarGeoPosicion("y", y)) {
		return false;
	}

	var curPosicion:FLSqlCursor = this.child("tdbPosicionesCuadro").cursor();
	var idPosCuadro:String = curPosicion.valueBuffer("idposicioncuadro");
	if (!idPosCuadro) {
		return false;
	}
	this.iface.refrescarSliderH(curPosicion, valor);

	return true;
}

function oficial_sldW_valueChanged(valor:Number)
{
	if (this.iface.bloqueoTotalSlider_) {
		return true;
	}

	var cursor:FLSqlCursor = this.cursor();
	var ancho:Number = Math.round(parseInt(cursor.valueBuffer("ancho")) * (valor + 1) / 100);
	var valorX:Number = this.child("sldX").value;
	var x:Number = Math.round(parseInt(cursor.valueBuffer("ancho")) * (valorX + 1) / 100);
	ancho = ancho - x;
	if (ancho < 0) {
		ancho = 0;
	}
	if (!this.iface.modificarGeoPosicion("ancho", ancho)) {
		return false;
	}
	return true;
}

function oficial_sldH_valueChanged(valor:Number)
{
	if (this.iface.bloqueoTotalSlider_) {
		return true;
	}

	var cursor:FLSqlCursor = this.cursor();
	var alto:Number = Math.round(parseInt(cursor.valueBuffer("alto")) * (valor + 1) / 100);
	var valorY:Number = this.child("sldY").value;
	var y:Number = Math.round(parseInt(cursor.valueBuffer("alto")) * (valorY + 1) / 100);
	alto = alto - y;
	if (alto < 0) {
		alto = 0;
	}
	if (!this.iface.modificarGeoPosicion("alto", alto)) {
		return false;
	}
	return true;
}

function oficial_modificarGeoPosicion(campo:String, valor:Number):Boolean
{
	var curPosicion:FLSqlCursor = this.child("tdbPosicionesCuadro").cursor();
	var idPosCuadro:String = curPosicion.valueBuffer("idposicioncuadro");
	if (!idPosCuadro) {
		return false;
	}
	curPosicion.setModeAccess(curPosicion.Edit);
	curPosicion.refreshBuffer()
	curPosicion.setValueBuffer(campo, valor);
	this.iface.bloqueoCommit_ = true;
	curPosicion.commitBuffer();
	this.iface.bloqueoCommit_ = false;
	
	if (this.iface.bloqueoSlider_) {
		this.iface.refrescar();
	} else {
		this.iface.dibujarPaginaActual(idPosCuadro);
	}
	return true;
}


function oficial_refrescar()
{
debug("Refrescando");
	this.iface.dibujarPaginaActual(-1);
}

function oficial_tbnDiseno_clicked()
{
	this.iface.modo_ = "DISEÑO";
	this.iface.establecerModo();
}
function oficial_tbnVisor_clicked()
{
	this.iface.modo_ = "VISOR";
	this.iface.establecerModo();
}
function oficial_establecerModo()
{
	switch (this.iface.modo_) {
		case "DISEÑO": {
			this.child("tbnDiseno").close();
			this.child("tbnVisor").show();
			this.child("sldX").show();
			this.child("sldW").show();
			this.child("sldY").show();
			this.child("sldH").show();
			this.child("gbxNada").show();
			this.child("gbxDiseno").show();
			this.child("gbxVisor").close();
			break;
		}
		case "VISOR": {
			this.child("tbnDiseno").show();
			this.child("tbnVisor").close();
			this.child("sldX").close();
			this.child("sldW").close();
			this.child("sldY").close();
			this.child("sldH").close();
			this.child("gbxNada").close();
			this.child("gbxDiseno").close();
			this.child("gbxVisor").show();
			break;
		}
	}
}

function oficial_establecerPagina(numPagina:Number)
{
	var util:FLUtil = new FLUtil;
	this.iface.paginaActual_ = numPagina;
	this.child("lblNumPagina").text = util.translate("scripts", "Página %1").arg(this.iface.paginaActual_);
	this.iface.habilitarPorPagina();
	this.iface.dibujarPaginaActual();
}

function oficial_habilitarPorPagina()
{
	var cursor:FLSqlCursor = this.cursor();
	var numPaginas:Number = parseInt(cursor.valueBuffer("numpaginas"));
	this.child("tbnPagAnterior").enabled = (this.iface.paginaActual_ > 1);
	this.child("tbnPagSiguiente").enabled = (this.iface.paginaActual_ < numPaginas);
}

function oficial_tbnPagSiguiente_clicked()
{
	var cursor:FLSqlCursor = this.cursor();
	var numPaginas:Number = parseInt(cursor.valueBuffer("numpaginas"));
	var pagActual:Number = this.iface.paginaActual_;
	if (pagActual < numPaginas) {
		pagActual++;
		this.iface.establecerPagina(pagActual);
	}
}

function oficial_tbnPagAnterior_clicked()
{
	var pagActual:Number = this.iface.paginaActual_;
	if (pagActual > 1) {
		pagActual--;
		this.iface.establecerPagina(pagActual);
	}
}

function oficial_tbnImprimirCuadro_clicked()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	var opciones:Array = [util.translate("scripts", "Página actual"), util.translate("scripts", "Cuadro completo")];
	var opcion:Number = fldireinne.iface.pub_elegirOpcion(opciones, util.translate("scripts", "Imprimir cuadro"));
	if (opcion < 0) {
		return;
	}
	var codCuadro:String = cursor.valueBuffer("codcuadro");
	var numPaginas:Number = parseInt(cursor.valueBuffer("numpaginas"));
	
	var lblPix = this.child( "lblPagina" );
	var visor = new FLReportViewer();
	visor.setPageDimensions(lblPix.size);
	visor.setPageSize(0);
	
	var curPosiciones:FLSqlCursor = new FLSqlCursor("in_posicionescuadro");
	var iPaginaViewer:Number = 0;
	for (var iPagina:Number = 1; iPagina <= numPaginas; iPagina++) {
debug("Dibujando pagina " + iPagina);
		if (opcion == 0 && iPagina != this.iface.paginaActual_) {
			continue;
		}
		var idPosCCursor:String;
		var aIndice:Array = [], iPos:Number = 0;
		curPosiciones.select("codcuadro = '" + codCuadro + "' AND pagina = " + iPagina);
		while (curPosiciones.next()) {
			curPosiciones.setModeAccess(curPosiciones.Browse);
			curPosiciones.refreshBuffer();
			idPosCCursor = curPosiciones.valueBuffer("idposicioncuadro");
			aIndice[iPos++] = idPosCCursor;
			if (iPagina != this.iface.paginaActual_) {
				try {
					if (this.iface.aGraficos_[idPosCCursor]) {
						this.iface.aGraficos_[idPosCCursor].cleanup();
						this.iface.aGraficos_[idPosCCursor].end();
						this.iface.aGraficos_[idPosCCursor] = false;
					}
				} catch (e) {
				}
				this.iface.aGraficos_[idPosCCursor] = this.iface.dibujarPosicion(curPosiciones);
				if (!this.iface.aGraficos_[idPosCCursor]) {
					return false;
				}
			}
		}
		
		visor.appendPage();
		var page = visor.getPageAt(iPaginaViewer++); //getFirstPage();
		
		var pix:Pixmap = this.iface.damePixPaginaBlanco()
		var pic:Picture, picTotal:Picture;
		for (var i:Number = 0; i < aIndice.length; i++) {
			pic = this.iface.aGraficos_[aIndice[i]];
			pix = pic.playOnPixmap( pix );
		}
		picTotal.begin();
		picTotal.drawPixmap(0, 0, pix);
		page = picTotal.playOnPicture(page);
		picTotal.end();
	}

	visor.setCurrentPage(0);
	visor.updateDisplay();
	visor.exec();
	
	
// 	if (this.iface.modo_ == "DISEÑO") {
// 		var curPosicion:FLSqlCursor = this.child("tdbPosicionesCuadro").cursor();
// 		var idPaginaPosActual:String = curPosicion.valueBuffer("pagina");
// 		if (idPaginaPosActual == this.iface.paginaActual_) {
// 			pic = this.iface.resaltarPosicion(curPosicion);
// 			pix = pic.playOnPixmap( pix );
// 			pic.end();
// 		}
// 	}
// 	var lblPix = this.child( "lblPagina" );
// 	lblPix.pixmap = pix;
// 	
// 	
// 	var devSize = this.child( "lblPagina" ).size;
// // 	var pageSize = new Size(645, 912); /// A4
// 	var marco:Rect = new Rect(0, 0, devSize.width, devSize.height);
// 	var pic:Picture = this.iface.dibujarGrafico(marco);
// 	if (!pic) {
// 		return false;
// 	}
// 	
// 	var visor = new FLReportViewer();
// 	visor.setPageDimensions(devSize);
// 	visor.setPageSize(0);
// 	visor.appendPage();
// 	var page = visor.getFirstPage();
// 	pic.playOnPicture(page);
// 	visor.updateDisplay();
// 	visor.exec();
// 	pic.end();
}

/** \D Inicia los labels de los botones de tiempo (años, trimestres, meses)
\end */
function oficial_iniciaBGTiempo()
{
	var util:FLUtil = new FLUtil;
	var totalBotones:Number = 5
	this.iface.numBotonesAno_ = totalBotones;
	
	var totalAnos:Number = formin_navegador.iface.anoMax_ - formin_navegador.iface.anoMin_ + 1;
	if (totalAnos > 0 && totalAnos < this.iface.numBotonesAno_) {
		this.iface.numBotonesAno_ = totalAnos;
	}
	var annoDesde:Number = formin_navegador.iface.anoMax_ - this.iface.numBotonesAno_ + 1;
	var anno:Number = annoDesde;
	for (var i:Number = 0; i < totalBotones; i++) {
		if (i < this.iface.numBotonesAno_) {
			this.child("pbnAno" + i.toString()).text = anno.toString().right(this.iface.numBotonesAno_ > 4 ? 2 : 4);
			this.iface.colorearBotonDim("pbnAno" + i.toString());
			anno++;
		} else {
			this.child("pbnAno" + i.toString()).close();
		}
	}
	var aTrim:Array = [util.translate("scripts", "T1"), util.translate("scripts", "T2"), util.translate("scripts", "T3"), util.translate("scripts", "T4")];
	for (var i:Number = 0; i < 4; i++) {
		this.child("pbnTrim" + i.toString()).text = aTrim[i];
		this.iface.colorearBotonDim("pbnTrim" + i.toString());
	}
	var aMes:Array = [util.translate("scripts", "Ene"), util.translate("scripts", "Feb"), util.translate("scripts", "Mar"), util.translate("scripts", "Abr"), util.translate("scripts", "May"), util.translate("scripts", "Jun"), util.translate("scripts", "Jul"), util.translate("scripts", "Ago"), util.translate("scripts", "Sep"), util.translate("scripts", "Oct"), util.translate("scripts", "Nov"), util.translate("scripts", "Dic")];
	for (var i:Number = 0; i < 12; i++) {
		this.child("pbnMes" + i.toString()).text = aMes[i];
		this.iface.colorearBotonDim("pbnMes" + i.toString());
	}
}

function oficial_bgMes_clicked(iMes:Number)
{
	if (!formin_navegador.iface.nivelBGMes_) {
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
// 				this.iface.ponerFiltro(formin_navegador.iface.nivelBGMes_, lista);
				this.child(nombrePbnTrim).animateClick();
				return;
			}
		}
	}
	this.iface.dibujarPaginaActual();
// 	this.iface.cambiarFiltro(formin_navegador.iface.nivelBGMes_, lista);
	
}

function oficial_bgTrim_clicked(iTrim:Number)
{
	if (!formin_navegador.iface.nivelBGTrim_) {
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
// 			var mesCambiado:Boolean = false;
			for (var iMes:Number = iMesDesde;  iMes < iMesHasta; iMes++) {
				nombrePbnMes = "pbnMes" + iMes.toString();
				if (this.child(nombrePbnMes).on) {
					this.child(nombrePbnMes).on = false;
					this.iface.colorearBotonDim(nombrePbnMes);
// 					mesCambiado = true;
				}
			}
// 			if (mesCambiado) {
// 				this.iface.ponerFiltro(formin_navegador.iface.nivelBGTrim_, lista);
// 				this.iface.bgMes_clicked(-1);
// 				return;
// 			}
		}
	}
	this.iface.dibujarPaginaActual();
// 	this.iface.cambiarFiltro(this.iface.nivelBGTrim_, lista);
	
}

function oficial_bgAnno_clicked(iAnno:Number)
{
	if (!formin_navegador.iface.nivelBGAnno_) {
		return;
	}
	
	var nombrePbnAnno:String = "pbnAno" + iAnno.toString();
	this.iface.colorearBotonDim(nombrePbnAnno);
	var anno:Number = this.iface.dameAnnoBoton(iAnno);
	
	this.iface.dibujarPaginaActual();
	
// 	var lista:String = "";
// 	var nodoFiltro:FLDomNode = fldireinne.iface.pub_dameNodoXML(this.iface.xmlPosActual_, "Posicion/Filtros/Filtro[@Campo=" + this.iface.nivelBGAnno_ + "]");
// 	if (nodoFiltro) {
// 		lista = nodoFiltro.toElement().attribute("Lista");
// 	}
// 	if (lista && lista != "") {
// 		if (this.child(nombrePbnAnno).on) {
// 			var aLista:Array = lista.split(", ");
// 			if (this.iface.buscarElementoArray(anno, aLista) == -1) {
// 				aLista.push(anno);
// 				aLista.sort(this.iface.ordenaArrayNumerico);
// 				lista = aLista.join(", ");
// 			}
// 		} else {
// 			var aLista:Array = lista.split(", ");
// 			var iElemento:Number = this.iface.buscarElementoArray(anno, aLista);
// 			if (iElemento >= 0) {
// 				aLista.splice(iElemento, 1);
// 			}
// 			lista = aLista.join(", ");
// 		}
// 	} else {
// 		if (this.child(nombrePbnAnno).on) {
// 			lista = anno;
// 		}
// 	}
// 	
// 	this.iface.cambiarFiltro(this.iface.nivelBGAnno_, lista);
}

function oficial_colorearBotonDim(nombreBoton:String)
{
debug("Coloreando " + nombreBoton);
	var colorBoton:Color = (this.child(nombreBoton).on ? fldireinne.iface.pub_dameColor(formin_navegador.iface.colorDimSel_) : fldireinne.iface.pub_dameColor(formin_navegador.iface.colorDimNoSel_))
	this.child(nombreBoton).paletteBackgroundColor = colorBoton;
}

/** \D Obtiene un año a partir del índice del boton pulsado en el buttonGruop de años
\end */
function oficial_dameAnnoBoton(iAnno:Number):Number
{
	var anno = formin_navegador.iface.anoMax_ - (this.iface.numBotonesAno_ - 1) + iAnno;
	return anno;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
