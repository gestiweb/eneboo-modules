/***************************************************************************
                 gf_2dtabla.qs  -  description
                             -------------------
    begin                : mar jul 13 2010
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
	function main() {
		return this.ctx.interna_main();
	}
	function init() {
		return this.ctx.interna_init();
	}
	function validateForm():Boolean {
		return this.ctx.interna_validateForm();
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var xmlGrafico_:FLDomDocument;
	var timerGraf_;
	var bloqueoRefresco_:Boolean;
	var tblEstilos_:FLTable;

	var E_ID:Number;
	var E_NOMBRE:Number;
	var E_ID_ALINH:Number;
	var E_ALINH:Number;
	var E_RGB_FONDO:Number;
	var E_COL_FONDO:Number;
	var E_ANCHOCOL:Number;
	var E_ALTOFILA:Number;

	function oficial( context ) { interna( context ); }
	function dibujarGrafico(xmlDatos:FLDomDocument, marco:Rect):Picture {
		return this.ctx.oficial_dibujarGrafico(xmlDatos, marco);
	}
	function tbnValoresDefecto_clicked() {
		return this.ctx.oficial_tbnValoresDefecto_clicked();
	}
	function dameArrayEstilo(eEstilo:FLDomElement):Array {
		return this.ctx.oficial_dameArrayEstilo(eEstilo);
	}
	function dameEstiloCelda(eCelda:FLDomElement, aFilas:Array, aCols:Array, aEstilos:Array):Array {
		return this.ctx.oficial_dameEstiloCelda(eCelda, aFilas, aCols, aEstilos);
	}
	function restaurarValoresDefecto():Boolean {
		return this.ctx.oficial_restaurarValoresDefecto();
	}
	function dibujarGraficoPix() {
		return this.ctx.oficial_dibujarGraficoPix();
	}
	function tbnRefrescar_clicked() {
		return this.ctx.oficial_tbnRefrescar_clicked();
	}
	function refrescarGrafico() {
		return this.ctx.oficial_refrescarGrafico();
	}
	function cargarCampos():Boolean {
		return this.ctx.oficial_cargarCampos();
	}
	function iniciarValores() {
		return this.ctx.oficial_iniciarValores();
	}
	function habilitarControles() {
		return this.ctx.oficial_habilitarControles();
	}
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function renovarTimer() {
		return this.ctx.oficial_renovarTimer();
	}
	function iniciarMuestrasColor() {
		return this.ctx.oficial_iniciarMuestrasColor();
	}
	function tblEstilos_clicked(fila:Number, col:Number) {
		return this.ctx.oficial_tblEstilos_clicked(fila, col);
	}
	function cambiarColorFondo(iFila:Number) {
		return this.ctx.oficial_cambiarColorFondo(iFila);
	}
	function cambiarAlineacionH(iFila:Number) {
		return this.ctx.oficial_cambiarAlineacionH(iFila);
	}
	function cambiarAnchoCol(iFila:Number) {
		return this.ctx.oficial_cambiarAnchoCol(iFila);
	}
	function cambiarAltoFila(iFila:Number) {
		return this.ctx.oficial_cambiarAltoFila(iFila);
	}
	function pideNumeroUsuario(valorActual:Number, nombre:String, titulo:String):Number {
		return this.ctx.oficial_pideNumeroUsuario(valorActual, nombre, titulo);
	}
	function configurarTablas() {
		return this.ctx.oficial_configurarTablas();
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
	function pub_dibujarGrafico(xmlDatos:FLDomDocument, marco):Picture {
		return this.dibujarGrafico(xmlDatos, marco);
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
	var cursor:FLSqlCursor = this.cursor();
	
	this.iface.bloqueoRefresco_ = false;
	this.iface.tblEstilos_ = this.child("tblEstilos");

	connect(this.child("tbnValoresDefecto"), "clicked()", this, "iface.tbnValoresDefecto_clicked");
	connect(this.child("tbnRefrescar"), "clicked()", this, "iface.tbnRefrescar_clicked");
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this.iface.tblEstilos_, "clicked(int, int)", this, "iface.tblEstilos_clicked");
	
	this.iface.configurarTablas();
	this.iface.iniciarValores();
	this.iface.habilitarControles();

	var util:FLUtil = new FLUtil;
}

function interna_main()
{
debug("interna_main");
	var f:Object = new FLFormSearchDB("gf_2dtabla");
	var cursor:FLSqlCursor = f.cursor();

	cursor.select();
	if (!cursor.first()) {
		cursor.setModeAccess(cursor.Insert);
	} else {
		cursor.setModeAccess(cursor.Edit);
	}
	f.setMainWidget();

	if (cursor.modeAccess() == cursor.Insert) {
		f.child("pushButtonCancel").setDisabled(true);
	}
	cursor.refreshBuffer();
	var commitOk:Boolean = false;
	var acpt:Boolean;
	cursor.transaction(false);
	while (!commitOk) {
		acpt = false;
		f.exec("id");
		acpt = f.accepted();
		if (!acpt) {
			if (cursor.rollback())
				commitOk = true;
		} else {
			if (cursor.commitBuffer()) {
				cursor.commit();
				commitOk = true;
			}
		}
	}
}

function interna_validateForm():Boolean
{
	var util:FLUtil = new FLUtil();

	return true;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_dibujarGrafico(xmlDatos:FLDomDocument, marco:Rect):Picture
{
	var util:FLUtil = new FLUtil;
debug("dibujando gráfico: " + xmlDatos.toString(4));
	var pic:Picture = new Picture;
	var clr = new Color();
	var clf = new Font();
	pic.begin();
	
	var moverMarco:Boolean = marco && (marco.x != 0 || marco.y != 0);
	if (moverMarco) {
		pic.savePainter();
		pic.translate(marco.x, marco.y);
	}
	
	var eGrafico:FLDomElement = xmlDatos.firstChild().toElement();

	var ancho:Number = eGrafico.attribute("Ancho") != "" ? parseInt(eGrafico.attribute("Ancho")) : 0;
	var alto:Number = eGrafico.attribute("Alto") != "" ? parseInt(eGrafico.attribute("Alto")) : 0;
	var marco:Boolean = (eGrafico.attribute("Marco") == "true");

	var margenSuperior:Number = parseInt(eGrafico.attribute("MargenSuperior"));
	if (isNaN(margenSuperior)) { margenSuperior = 0; }
	var margenInferior:Number = parseInt(eGrafico.attribute("MargenInferior"));
	if (isNaN(margenInferior)) { margenInferior = 0; }
	var margenIzquierdo:Number = parseInt(eGrafico.attribute("MargenIzquierdo"));
	if (isNaN(margenIzquierdo)) { margenIzquierdo = 0; }
	var margenDerecho:Number = parseInt(eGrafico.attribute("MargenDerecho"));
	if (isNaN(margenDerecho)) { margenDerecho = 0; }
	
	var altoFila:Number = parseInt(eGrafico.attribute("AltoFila"));
	if (isNaN(altoFila)) { altoFila = 0; }
	
	var anchoCol:Number = parseInt(eGrafico.attribute("AnchoCol"));
	if (isNaN(anchoCol)) { anchoCol = 0; }
	
	var x:Array = [];
	var y:Array = [];

	var fontFamily:String = (eGrafico.attribute("FontFamily") != "" ? eGrafico.attribute("FontFamily") : "Arial");
	var fontSize:Number = (eGrafico.attribute("FontSize") != "" ? eGrafico.attribute("FontSize") : 10);
	var clf = flgraficos.iface.pub_dameFuente(fontFamily, fontSize);
	pic.setFont( clf );
	
	var titulo:String = eGrafico.attribute("Titulo");
	var altoTitulo:Number = (titulo && titulo != "" ? parseInt(fontSize) + 10 : 0);
	
	var nodoEstilos:FLDomElement = eGrafico.namedItem("Estilos");
	var idEstilo:String;
	var aEstilos:Array = [];
	if (nodoEstilos) {
		var eEstilo:FLDomElement;
		for (var nodoEstilo:FLDomNode = nodoEstilos.firstChild(); nodoEstilo; nodoEstilo = nodoEstilo.nextSibling()) {
			eEstilo = nodoEstilo.toElement();
			idEstilo = eEstilo.attribute("Id");
			aEstilos[idEstilo] = this.iface.dameArrayEstilo(eEstilo);
		}
	}
	
	var yIniTabla:Number = parseInt(margenSuperior) + parseInt(altoTitulo);
	var xIniTabla:Number = parseInt(margenIzquierdo);

	var xmlFilas:FLDomNode = eGrafico.namedItem("Filas");
	if (!xmlFilas) {
debug("Sin filas");
		return pic;
	}
	var eFilas:FLDomElement = xmlFilas.toElement();
	var numFilas:Number = eFilas.childNodes().length();
// 	var numFilas:Number = parseInt(eGrafico.attribute("NumFilas"));
	var numCols:Number = parseInt(eGrafico.attribute("NumCols"));
	
	var aFilas:Array = new Array(numFilas);
	for (var i:Number = 0; i < numFilas; i++) {
		aFilas[i] = [];
	}
	
	var eFila:FLDomElement;
	var iFila:Number = 0, iFilaVisible:Number = 0, numFilasSinAlto:Number = 0;
	var altoSobrante:Number = alto - yIniTabla - margenInferior;
	
	for (var nodoFila:FLDomNode = eFilas.firstChild(); nodoFila; nodoFila = nodoFila.nextSibling()) {
		eFila = nodoFila.toElement();
debug(eFila.attribute("Numero") + " de " + numFilas);
		aFilas[iFila]["element"] = eFila;
		idEstilo = eFila.attribute("Estilo");
		if (eFila.attribute("Oculta") == "true") {
			aFilas[iFila]["oculta"] = true;
		} else {
			aFilas[iFila]["oculta"] = false;
			aFilas[iFila]["filav"] = iFilaVisible++;
			if (eFila.attribute("Ancho") != "") {
				aFilas[iFila]["alto"] = eFila.attribute("Ancho");
			} else if (idEstilo != "" && aEstilos[idEstilo]["altofila"] != "") {
				aFilas[iFila]["alto"] = aEstilos[idEstilo]["altofila"];
			} else if (altoFila != "") {
				aFilas[iFila]["alto"] = altoFila;
			} else {
				aFilas[iFila]["alto"] = -1;
				numFilasSinAlto++;
			}
			altoSobrante -= aFilas[iFila]["alto"] > 0 ? parseInt(aFilas[iFila]["alto"]) : 0;
		}
		iFila++;
	}
	
	if (altoFila == "" && numFilasSinAlto != 0) {
		altoFila = Math.floor(altoSobrante / numFilasSinAlto);
	}
	var y:Number = yIniTabla;
	for (iFila = 0; iFila < numFilas; iFila++) {
		if (aFilas[iFila]["oculta"]) {
			continue;
		}
		if (aFilas[iFila]["alto"] == -1) {
			aFilas[iFila]["alto"] = altoFila;
		}
		aFilas[iFila]["y"] = y;
		y += parseInt(aFilas[iFila]["alto"]);
	}
	var yFinTabla:Number = y;
	
	var aCols:Array = new Array(numCols);
	for (var i:Number = 0; i < numCols; i++) {
		aCols[i] = [];
	}
	var eCols:FLDomElement = eGrafico.namedItem("Cols").toElement();
	var eCol:FLDomElement;
	var iCol:Number = 0, iColVisible:Number = 0, numColsSinAncho:Number = 0;
	var anchoSobrante:Number = ancho - margenIzquierdo - margenDerecho;
	for (var nodoCol:FLDomNode = eCols.firstChild(); nodoCol; nodoCol = nodoCol.nextSibling()) {
		eCol = nodoCol.toElement();
		aCols[iCol]["element"] = eCol;
		idEstilo = eCol.attribute("Estilo");
		if (eCol.attribute("Oculta") == "true") {
			aCols[iCol]["oculta"] = true;
		} else {
			aCols[iCol]["oculta"] = false;
			aCols[iCol]["colv"] = iColVisible++;
			if (eCol.attribute("Ancho") != "") {
				aCols[iCol]["ancho"] = eCol.attribute("Ancho");
			} else if (idEstilo != "" && aEstilos[idEstilo]["anchocol"] != "") {
				aCols[iCol]["ancho"] = aEstilos[idEstilo]["anchocol"];
			} else if (anchoCol != "") {
				aCols[iCol]["ancho"] = anchoCol;
			} else {
				aCols[iCol]["ancho"] = -1;
				numColsSinAncho++;
			}
			anchoSobrante -= aCols[iCol]["ancho"] > 0 ? parseInt(aCols[iCol]["ancho"]) : 0;
		}
		iCol++;
	}
	
	if (anchoCol == "" && numColsSinAncho != 0) {
		anchoCol = Math.floor(anchoSobrante / numColsSinAncho);
	}
	var x:Number = xIniTabla;
	for (iCol = 0; iCol < numCols; iCol++) {
		if (aCols[iCol]["oculta"]) {
			continue;
		}
		if (aCols[iCol]["ancho"] == -1) {
			aCols[iCol]["ancho"] = anchoCol;
		}
		aCols[iCol]["x"] = x;
		x += parseInt(aCols[iCol]["ancho"]);
	}
	var xFinTabla:Number = x;
	
// debug("numColsVisibles" + numColsVisibles);
// debug("numFilasVisibles" + numFilasVisibles);
	
	clr.setRgb( 0, 0, 0 );
	pic.setPen( clr, 1); // pic.DotLine );

/// Título
// debug("xIniTabla = " + xIniTabla);
// debug("margenSuperior = " + margenSuperior);
// debug("altoTitulo = " + altoTitulo);
	pic.drawText(xIniTabla, margenSuperior + parseInt(altoTitulo) - 10, titulo);

/// Marco
	if (marco) {
		pic.drawLine(1, 1, alto, 1);
		pic.drawLine(0, alto, ancho, alto);
		pic.drawLine(1, 1, 1, alto);
		pic.drawLine(ancho, 1, ancho, alto);
	}
	
/// Cuadrícula
	var x:Number;
	for (var iCol:Number = 0; iCol < numCols; iCol++) {
		if (aCols[iCol]["oculta"]) {
			continue;
		}
		x = aCols[iCol]["x"];
		pic.drawLine(x, yIniTabla, x, yFinTabla);
	}
	pic.drawLine(xFinTabla, yIniTabla, xFinTabla, yFinTabla);
	
	var y:Number;
	for (var iFila:Number = 0; iFila < numFilas; iFila++) {
		if (aFilas[iFila]["oculta"]) {
			continue;
		}
		y = aFilas[iFila]["y"];
		pic.drawLine(xIniTabla, y, xFinTabla, y);
	}
	pic.drawLine(xIniTabla, yFinTabla, xFinTabla, yFinTabla);
	
/// Valores
	
	var eValores:FLDomElement = eGrafico.namedItem("Valores").toElement();
	var eCelda:FLDomElement, aEstilo:Array;
	for (var nodoCelda:FLDomNode = eValores.firstChild(); nodoCelda; nodoCelda = nodoCelda.nextSibling()) {
		eCelda = nodoCelda.toElement();
		iFila = eCelda.attribute("Fila");
		if (iFila < 0 || iFila >= numFilas) {
			continue;
		}
		if (aFilas[iFila]["oculta"]) {
			continue;
		}
		iCol = eCelda.attribute("Col");
		if (iCol < 0 || iCol >= numCols) {
			continue;
		}
		if (aCols[iCol]["oculta"]) {
			continue;
		}
		x = aCols[iCol]["x"];
		y = aFilas[iFila]["y"];

		anchoCol = parseInt(aCols[iCol]["ancho"]);
		altoFila = parseInt(aFilas[iFila]["alto"]);
		
debug("dibujando " + x + ", " + y + ", valor: " + eCelda.attribute("Valor"));
		aEstilo = this.iface.dameEstiloCelda(eCelda, aFilas, aCols, aEstilos);
		if (!aEstilo) {
			pic.drawText(x, y + altoFila, eCelda.attribute("Valor"));
		} else {
			colorFondo = aEstilo["colorfondo"];
			pic.setPen(clr, 0, pic.NoPen)
			pic.setBrush(colorFondo);
			pic.drawRect(x + 1, y + 1, anchoCol - 1, altoFila - 1);
			try {
				pic.drawText(x + 1, y, anchoCol - 1, altoFila, aEstilo["alineacionh"], eCelda.attribute("Valor"), -1);
			} catch (e) {
				pic.drawText(x + 1, y, anchoCol - 1, altoFila, 0, eCelda.attribute("Valor"), -1);
			}
		}
	}
	
	if (moverMarco) {
		pic.restorePainter();
	}
	return pic;
}

function oficial_dameEstiloCelda(eCelda:FLDomElement, aFilas:Array, aCols:Array, aEstilos:Array):Array
{
	var iFila:Number = eCelda.attribute("Fila");
	var iCol:Number = eCelda.attribute("Col");
	var idEstilo:String = "", estiloCelda:String, estiloCol:String, estiloFila:String;
	
	estiloCelda = eCelda.attribute("Estilo");
	if (estiloCelda != "") {
		idEstilo = estiloCelda;
	} else {
		estiloCol = aCols[iCol]["element"].attribute("Estilo");
		if (estiloCol != "") {
			idEstilo = estiloCol;
		} else {
			estiloFila = aFilas[iFila]["element"].attribute("Estilo");
			if (estiloFila != "") {
				idEstilo = estiloFila;
			} else {
				idEstilo = "default";
			}
		}
	}
	
	try {
		aEstilo = aEstilos[idEstilo];
	} catch (e) {
		aEstilo = false;
	}
	
	return aEstilo;
}

function oficial_dameArrayEstilo(eEstilo:FLDomElement):Array
{
	var aEstilo:Array = [];
	
	var rgbFondo:String = eEstilo.attribute("ColorFondo");
	var colorFondo:Color = false;
	if (rgbFondo != "") {
		colorFondo = flgraficos.iface.pub_dameColor(rgbFondo)
	}
	aEstilo["colorfondo"] = colorFondo ? colorFondo : flgraficos.iface.pub_dameColor("255,255,255");
	
	var alineacionH:String = eEstilo.attribute("AlineacionH");
	var pic:Picture;
	switch (alineacionH) {
		case "AlignRight": {
			aEstilo["alineacionh"] = pic.AlignRight;
			break;
		}
		case "AlignLeft": {
			aEstilo["alineacionh"] = pic.AlignLeft;
			break;
		}
		case "AlignHCenter": {
			aEstilo["alineacionh"] = pic.AlignHCenter;
			break;
		}
		default: {
			aEstilo["alineacionh"] = pic.AlignRight;
		}
	}
	aEstilo["alineacionh"] = aEstilo["alineacionh"] | pic.AlignVCenter;
	aEstilo["anchocol"] = eEstilo.attribute("AnchoCol");
	aEstilo["altofila"] = eEstilo.attribute("AltoFila");

	return aEstilo;
}

function oficial_tbnValoresDefecto_clicked()
{
debug("oficial_tbnValoresDefecto_clicked");
	var util:FLUtil = new FLUtil;

	var res:Number = MessageBox.warning(util.translate("scripts", "Va a restaurar los valores por defecto del gráfico.\n¿Está seguro?"), MessageBox.Yes, MessageBox.No);
	if (res != MessageBox.Yes) {
		return;
	}
	
	this.iface.restaurarValoresDefecto();
	this.iface.cargarCampos();
}

function oficial_restaurarValoresDefecto():Boolean
{
debug("oficial_restaurarValoresDefecto");
	var util:FLUtil = new FLUtil;

	if (!this.iface.xmlGrafico_) {
		this.iface.xmlGrafico_ = new FLDomDocument();
		this.iface.xmlGrafico_.setContent("<Grafico Tipo='2d_tabla' />");
	}

	xmlDoc = this.iface.xmlGrafico_;
	var eGrafico:FLDomElement = xmlDoc.firstChild().toElement();
	eGrafico.setAttribute("Alto", 400);
	eGrafico.setAttribute("Ancho", 700);
	
	if (eGrafico.attribute("Titulo") != "") {
		eGrafico.setAttribute("Titulo", util.translate("scripts", "TITULO DEL INFORME"));
	}
	eGrafico.setAttribute("MargenSuperior", 20);
	eGrafico.setAttribute("MargenInferior", 20);
	eGrafico.setAttribute("MargenIzquierdo", 20);
	eGrafico.setAttribute("MargenDerecho", 20);
	
	var numFilas:Number = 10;
	var numCols:Number = 5;
	eGrafico.setAttribute("NumFilas", numFilas);
	eGrafico.setAttribute("NumCols", numCols);
	var aValores:Array = new Array(numFilas);
	for (var x:Number = 0; x < numFilas; x++) {
		aValores[x] = new Array(numCols);
		for (var y:Number = 0; y < numCols; y++) {
			aValores[x][y] = Math.round(Math.random() * 100);
		}
	}
	
	eGrafico.setAttribute("FontFamily", "Arial");
	eGrafico.setAttribute("FontSize", 10);
	
	var nodoFilas:FLDomElement = eGrafico.namedItem("Filas");
	var eFilas:FLDomElement;
	if (nodoFilas) {
		eGrafico.removeChild(nodoFilas);
	}
	eFilas = xmlDoc.createElement("Filas");
	eGrafico.appendChild(eFilas);
	var eFila:FLDomElement;
	for (var iFila:Number = 0; iFila < numFilas; iFila++) {
		eFila = xmlDoc.createElement("Fila");
		eFilas.appendChild(eFila);
	}
		
	var nodoCols:FLDomElement = eGrafico.namedItem("Cols");
	var eCols:FLDomElement;
	if (nodoCols) {
		eGrafico.removeChild(nodoCols);
	}
	eCols = xmlDoc.createElement("Cols");
	eGrafico.appendChild(eCols);
	var eCol:FLDomElement;
	for (var iCol:Number = 0; iCol < numCols; iCol++) {
		eCol = xmlDoc.createElement("Col");
		eCols.appendChild(eCol);
	}
	
	var nodoValores:FLDomElement = eGrafico.namedItem("Valores");
	var eValores:FLDomElement;
	if (nodoValores) {
		eGrafico.removeChild(nodoValores);
	}
	eValores = xmlDoc.createElement("Valores");
	eGrafico.appendChild(eValores);
	var eCelda:FLDomElement;
	for (var x:Number = 0; x < numFilas; x++) {
		for (var y:Number = 0; y < numCols; y++) {
			eCelda =  xmlDoc.createElement("Celda");
			eValores.appendChild(eCelda);
			eCelda.setAttribute("Fila", x);
			eCelda.setAttribute("Col", y);
			eCelda.setAttribute("Valor", aValores[x][y]);
		}
	}
	
	
debug("Gráfico defecto = " + this.iface.xmlGrafico_.toString(4));
	return true;
}

function oficial_dibujarGraficoPix()
{
	var eGrafico:FLDomElement = this.iface.xmlGrafico_.firstChild().toElement();

	var pic:Picture = this.iface.dibujarGrafico(this.iface.xmlGrafico_);
	var ancho:Number = parseInt(eGrafico.attribute("Ancho"));
	var alto:Number = parseInt(eGrafico.attribute("Alto"));
	var clr = new Color();
	var lblMuestra = this.child( "lblMuestra" );
	var pix = new Pixmap();
	var devSize = this.child( "lblMuestra" ).size;//new Size(ancho, alto);
	pix.resize( devSize );
	clr.setRgb( 255, 255, 255 );
	pix.fill( clr );
	pix = pic.playOnPixmap( pix );
	lblMuestra.pixmap = pix;
	pic.end();
}

function oficial_iniciarValores()
{
debug("oficial_iniciarValores");
	var cursor:FLSqlCursor = this.cursor();
	var xml:String = cursor.valueBuffer("xml");
	if (xml && xml != "") {
debug("XML");
		this.iface.xmlGrafico_ = new FLDomDocument;
		if (!this.iface.xmlGrafico_.setContent(xml)) {
			return false;
		}
	} else {
debug("!XML");
		this.iface.restaurarValoresDefecto();
	}
	this.iface.cargarCampos();
// 	this.iface.iniciarMuestrasColor();
	this.iface.tbnRefrescar_clicked();
}

function oficial_configurarTablas()
{
	var util:FLUtil = new FLUtil;

	this.iface.E_ID = 0;
	this.iface.E_NOMBRE = 1;
	this.iface.E_ID_ALINH = 2;
	this.iface.E_ALINH = 3;
	this.iface.E_RGB_FONDO = 4;
	this.iface.E_COL_FONDO = 5;
	this.iface.E_ANCHOCOL = 6;
	this.iface.E_ALTOFILA = 7;

	this.iface.tblEstilos_.setNumRows(0);
	this.iface.tblEstilos_.setNumCols(8);
	var cabecera:Array = ["ID", util.translate("scripts", "Estilo"), "ID ALIGN", util.translate("scripts", "Alin. H."), "RGBFONDO", util.translate("scripts", "Fondo"), util.translate("scripts", "Ancho C."), util.translate("scripts", "Alto F.")];
	this.iface.tblEstilos_.setColumnLabels("*", cabecera.join("*"));
	this.iface.tblEstilos_.hideColumn(this.iface.E_ID);
	this.iface.tblEstilos_.setColumnWidth(this.iface.E_NOMBRE, 200);
	this.iface.tblEstilos_.hideColumn(this.iface.E_ID_ALINH);
	this.iface.tblEstilos_.setColumnWidth(this.iface.E_ALINH, 100);
	this.iface.tblEstilos_.hideColumn(this.iface.E_RGB_FONDO);
	this.iface.tblEstilos_.setColumnWidth(this.iface.E_COL_FONDO, 80);
	this.iface.tblEstilos_.setColumnWidth(this.iface.E_ANCHOCOL, 60);
	this.iface.tblEstilos_.setColumnWidth(this.iface.E_ALTOFILA, 60);
}

function oficial_cargarCampos():Boolean
{
debug("oficial_cargarCampos");
	var util:FLUtil = new FLUtil;
	
	this.iface.bloqueoRefresco_ = true;
	var cursor:FLSqlCursor = this.cursor();

	var eGrafico:FLDomElement = this.iface.xmlGrafico_.firstChild().toElement();
	this.child("fdbAlto").setValue(eGrafico.attribute("Alto"));
	this.child("fdbAncho").setValue(eGrafico.attribute("Ancho"));
	this.child("fdbDimFijas").setValue(eGrafico.attribute("DimFijas") == "true");
	this.child("fdbMarco").setValue(eGrafico.attribute("Marco") == "true");

	this.child("fdbTitulo").setValue(eGrafico.attribute("Titulo"));
	this.child("fdbMargenSup").setValue(eGrafico.attribute("MargenSuperior"));
	this.child("fdbMargenInf").setValue(eGrafico.attribute("MargenInferior"));
	this.child("fdbMargenIzq").setValue(eGrafico.attribute("MargenIzquierdo"));
	this.child("fdbMargenDer").setValue(eGrafico.attribute("MargenDerecho"));
	
	this.child("fdbAltoFila").setValue(eGrafico.attribute("AltoFila"));
	this.child("fdbAnchoCol").setValue(eGrafico.attribute("AnchoCol"));

	this.child("fdbFamiliaFuente").setValue(eGrafico.attribute("FontFamily"));
	this.child("fdbTamanoFuente").setValue(eGrafico.attribute("FontSize"));

	this.iface.tblEstilos_.setNumRows(0);
	var nodoEstilos:FLDomNode = eGrafico.namedItem("Estilos");
	var iFila:Number = 0, colorFondo:Color, rgbFondo:String;
	if (nodoEstilos) {
		var eEstilo:FLDomElement;
		for (var nodoEstilo:FLDomNode = nodoEstilos.firstChild(); nodoEstilo; nodoEstilo = nodoEstilo.nextSibling()) {
			eEstilo = nodoEstilo.toElement();
			this.iface.tblEstilos_.insertRows(iFila);
			this.iface.tblEstilos_.setText(iFila, this.iface.E_ID, eEstilo.attribute("Id"));
			this.iface.tblEstilos_.setText(iFila, this.iface.E_NOMBRE, eEstilo.attribute("Nombre"));
			this.iface.tblEstilos_.setText(iFila, this.iface.E_ID_ALINH, eEstilo.attribute("AlineacionH"));
			this.iface.tblEstilos_.setText(iFila, this.iface.E_ALINH, flgraficos.iface.pub_traducirAlineacion(eEstilo.attribute("AlineacionH")));
			rgbFondo = eEstilo.attribute("ColorFondo");
			this.iface.tblEstilos_.setText(iFila, this.iface.E_RGB_FONDO, rgbFondo);
debug("TABLA rgbFondo = " + rgbFondo);
			if (rgbFondo != "") {
				colorFondo = flgraficos.iface.pub_dameColor(rgbFondo);
debug("TABLA colorFondo = " + colorFondo);
				if (colorFondo) {
debug("TABLA colorFondo PINTA = " + colorFondo);
					this.iface.tblEstilos_.setCellBackgroundColor(iFila, this.iface.E_COL_FONDO, colorFondo);
					this.iface.tblEstilos_.setText(iFila, this.iface.E_COL_FONDO, " ");
				}
			}
			this.iface.tblEstilos_.setText(iFila, this.iface.E_ANCHOCOL, eEstilo.attribute("AnchoCol"));
			this.iface.tblEstilos_.setText(iFila, this.iface.E_ALTOFILA, eEstilo.attribute("AltoFila"));
			iFila++;
		}
		this.iface.tblEstilos_.repaintContents();
	}
	
	this.iface.bloqueoRefresco_ = false;
	
	this.iface.dibujarGraficoPix();

	return true;
}

function oficial_tbnRefrescar_clicked()
{
	this.iface.refrescarGrafico();
}

function oficial_refrescarGrafico()
{
	killTimer(this.iface.timerGraf_);

	var cursor:FLSqlCursor = this.cursor();
	var eGrafico:FLDomElement = this.iface.xmlGrafico_.firstChild().toElement();
	eGrafico.setAttribute("Ancho", cursor.valueBuffer("ancho"));
	eGrafico.setAttribute("Alto", cursor.valueBuffer("alto"));
	eGrafico.setAttribute("DimFijas", (cursor.valueBuffer("dimfijas") ? "true" : "false"));
	eGrafico.setAttribute("Marco", (cursor.valueBuffer("marco") ? "true" : "false"));

	eGrafico.setAttribute("Titulo", cursor.valueBuffer("titulo"));
	eGrafico.setAttribute("MargenSuperior", cursor.valueBuffer("margensup"));
	eGrafico.setAttribute("MargenInferior", cursor.valueBuffer("margeninf"));
	eGrafico.setAttribute("MargenIzquierdo", cursor.valueBuffer("margenizq"));
	eGrafico.setAttribute("MargenDerecho", cursor.valueBuffer("margender"));
	
	eGrafico.setAttribute("AltoFila", cursor.valueBuffer("altofila"));
	eGrafico.setAttribute("AnchoCol", cursor.valueBuffer("anchocol"));

	eGrafico.setAttribute("FontFamily", cursor.valueBuffer("familiafuente"));
	eGrafico.setAttribute("FontSize", cursor.valueBuffer("tamanofuente"));
	
	var totalFilas:Number = this.iface.tblEstilos_.numRows();
	var eEstilo:FLDomElement, idEstilo:String;
	for (var iFila:Number = 0; iFila < totalFilas; iFila++) {
		idEstilo = this.iface.tblEstilos_.text(iFila, this.iface.E_ID);
		eEstilo = flgraficos.iface.pub_dameElementoXML(eGrafico, "Estilos/Estilo[@Id=" + idEstilo + "]");
		if (!eEstilo) {
			continue;
		}
		eEstilo.setAttribute("ColorFondo", this.iface.tblEstilos_.text(iFila, this.iface.E_RGB_FONDO));
		eEstilo.setAttribute("AlineacionH", this.iface.tblEstilos_.text(iFila, this.iface.E_ID_ALINH));
		eEstilo.setAttribute("AnchoCol", this.iface.tblEstilos_.text(iFila, this.iface.E_ANCHOCOL));
		eEstilo.setAttribute("AltoFila", this.iface.tblEstilos_.text(iFila, this.iface.E_ALTOFILA));
	}

	cursor.setValueBuffer("xml", this.iface.xmlGrafico_.toString(4));
	this.iface.dibujarGraficoPix();
}


/** \D Sólo es posible guardar los valores por defecto del gráfico cuando se accede desde el módulo de gráficos
\end */
function oficial_habilitarControles()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	var id:String = cursor.valueBuffer("id");
	this.child("tbnValoresDefecto").close();
	this.child("tbnGuardar").close();
}

function oficial_bufferChanged(fN:String)
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	switch (fN) {
		case "xml": {
			break;
		}
// 		case "colormarcay": {
// 			flgraficos.iface.pub_colorearLabel(this.child("lblColorMarcaY"), cursor.valueBuffer(fN));
// 			this.iface.renovarTimer();
// 			break;
// 		}
		default: {
			this.iface.renovarTimer();
		}
	}
}

function oficial_renovarTimer()
{
	killTimer(this.iface.timerGraf_);
	if (this.iface.bloqueoRefresco_) {
		return;
	}
	this.iface.timerGraf_ = startTimer(1000, this.iface.refrescarGrafico);
}

function oficial_iniciarMuestrasColor()
{
	var cursor:FLSqlCursor = this.cursor();
// 	flgraficos.iface.pub_colorearLabel(this.child("lblColorMarcaY"), cursor.valueBuffer("colormarcay"));
}

function oficial_tblEstilos_clicked(fila:Number, col:Number)
{
	switch (col) {
		case this.iface.E_COL_FONDO: {
			this.iface.cambiarColorFondo(fila);
			this.iface.refrescarGrafico();
			break;
		}
		case this.iface.E_ALINH: {
			this.iface.cambiarAlineacionH(fila);
			this.iface.refrescarGrafico();
			break;
		}
		case this.iface.E_ANCHOCOL: {
			this.iface.cambiarAnchoCol(fila);
			this.iface.refrescarGrafico();
			break;
		}
		case this.iface.E_ALTOFILA: {
			this.iface.cambiarAltoFila(fila);
			this.iface.refrescarGrafico();
			break;
		}
	}
}

function oficial_cambiarColorFondo(iFila:Number)
{
	var f:Object = new FLFormSearchDB("gf_colores");
	f.setMainWidget();
	var rgbColor:String = f.exec("rgb");
	if (!rgbColor) {
		return false;
	}
	var colorFondo:Color = flgraficos.iface.pub_dameColor(rgbColor);
	if (!colorFondo) {
		return false;
	}
	this.iface.tblEstilos_.setText(iFila, this.iface.E_RGB_FONDO, rgbColor);
	this.iface.tblEstilos_.setCellBackgroundColor(iFila, this.iface.E_COL_FONDO, colorFondo);
	this.iface.tblEstilos_.setText(iFila, this.iface.E_COL_FONDO, " ");
	this.iface.tblEstilos_.repaintContents();
}

function oficial_cambiarAlineacionH(iFila:Number)
{
	var aTipos:Array = ["AlignLeft", "AlignHCenter", "AlignRight"];
	var tipo:String = this.iface.tblEstilos_.text(iFila, this.iface.E_ID_ALINH);
	var i:Number;
	for (i = 0; i < aTipos.length; i++) {
		if (tipo == aTipos[i]) {
			break;
		}
	}
	if (i == aTipos.length) {
		i = 0;
	} else {
		if (i == aTipos.length - 1) {
			i = 0;
		} else {
			i++;
		}
	}
	this.iface.tblEstilos_.setText(iFila, this.iface.E_ID_ALINH, aTipos[i]);
	this.iface.tblEstilos_.setText(iFila, this.iface.E_ALINH, flgraficos.iface.pub_traducirAlineacion(aTipos[i]));
}

function oficial_cambiarAnchoCol(iFila:Number)
{
	var util:FLUtil = new FLUtil;
	
	var valor:Number = this.iface.tblEstilos_.text(iFila, this.iface.E_ANCHOCOL);
	if (isNaN(valor)) {
		valor = 0;
	}
	
	var ancho:Number = this.iface.pideNumeroUsuario(valor, util.translate("scripts", "Ancho"), util.translate("scripts", "Ancho col."));
	if (ancho == -2) {
		return false;
	}
	if (ancho == -1) {
		ancho = "";
	}
	this.iface.tblEstilos_.setText(iFila, this.iface.E_ANCHOCOL, ancho);
}

function oficial_cambiarAltoFila(iFila:Number)
{
	var util:FLUtil = new FLUtil;
	
	var valor:Number = this.iface.tblEstilos_.text(iFila, this.iface.E_ALTOFILA);
	if (isNaN(valor)) {
		valor = 0;
	}
	
	var alto:Number = this.iface.pideNumeroUsuario(valor, util.translate("scripts", "Alto"), util.translate("scripts", "Alto fila"));
	if (alto == -2) {
		return false;
	}
	if (alto == -1) {
		alto = "";
	}
	this.iface.tblEstilos_.setText(iFila, this.iface.E_ALTOFILA, alto);
}

function oficial_pideNumeroUsuario(valorActual:Number, nombre:String, titulo:String):Number
{
	var util:FLUtil = new FLUtil;
	
	var dialogo = new Dialog;
	dialogo.caption = titulo;
	dialogo.okButtonText = util.translate("scripts", "Aceptar");
	dialogo.cancelButtonText = util.translate("scripts", "Cancelar");
	
	var chkDefecto = new CheckBox;
	chkDefecto.text = util.translate("scripts", "Tomar valor por defecto");
	
	var spbValor = new SpinBox;
	spbValor.label = nombre;
	spbValor.value = valorActual;
	spbValor.minimum = 0;
	spbValor.maximum = 10000;
	
	dialogo.add(spbValor);
	dialogo.add(chkDefecto);
	
	if (!dialogo.exec()) {
		return -2;
	}
	if (chkDefecto.checked) {
		return -1;
	}
	return spbValor.value;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
