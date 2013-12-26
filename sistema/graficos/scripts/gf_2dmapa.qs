/***************************************************************************
                 gf_2dmapa.qs  -  description
                             -------------------
    begin                : mie sep 22 2010
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
	var aPosiciones_:Array;
	var timerGraf_;
	var bloqueoRefresco_:Boolean;
	var seleccionPaises_:String;
	var campoIdPos_:String;
	var campoNombre_:String;
	
	function oficial( context ) { interna( context ); }
	function dibujarGrafico(xmlDatos:FLDomDocument, marco:Rect):Picture {
		return this.ctx.oficial_dibujarGrafico(xmlDatos, marco);
	}
// 	function formatearValor(valor:String, formato:String):String {
// 		return this.ctx.oficial_formatearValor(valor, formato);
// 	}
// 	function tbnValoresDefecto_clicked() {
// 		return this.ctx.oficial_tbnValoresDefecto_clicked();
// 	}
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
	function configurarTablas() {
		return this.ctx.oficial_configurarTablas();
	}
	function cargaArrayPosiciones(xmlDatos:FLDomDocument):Boolean {
		return this.ctx.oficial_cargaArrayPosiciones(xmlDatos);
	}
	function tdbPosiciones_currentChanged() {
		return this.ctx.oficial_tdbPosiciones_currentChanged();
	}
	function sldX_sliderReleased() {
		return this.ctx.oficial_sldX_sliderReleased();
	}
	function sldY_sliderReleased() {
		return this.ctx.oficial_sldY_sliderReleased();
	}
	function cambiarCoordXML(idPos:String, aPos:Array):Boolean {
		return this.ctx.oficial_cambiarCoordXML(idPos, aPos);
	}
	function dameNodoPosicion(idPos:String):FLDomElement {
		return this.ctx.oficial_dameNodoPosicion(idPos);
	}
	function dameNodoValor(idPos:String, nombre:String):FLDomElement {
		return this.ctx.oficial_dameNodoValor(idPos, nombre);
	}
	function resaltarValor(idPos:String) {
		return this.ctx.oficial_resaltarValor(idPos);
	}
	function tbnPaises_clicked() {
		return this.ctx.oficial_tbnPaises_clicked();
	}
	function mostrarPaises() {
		return this.ctx.oficial_mostrarPaises();
	}
	function tbnBorrarPos_clicked() {
		return this.ctx.oficial_tbnBorrarPos_clicked();
	}
	function borraNodoValor(idPos:String, nombre:String):Boolean {
		return this.ctx.oficial_borraNodoValor(idPos, nombre);
	}
	function borraNodoPosicion(idPos:String):Boolean {
		return this.ctx.oficial_borraNodoPosicion(idPos);
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

	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this.child("tbnRefrescar"), "clicked()", this, "iface.tbnRefrescar_clicked");
	connect (this.child("tdbPosiciones"), "currentChanged()", this, "iface.tdbPosiciones_currentChanged");
	connect (this.child("sldX"), "sliderReleased()", this, "iface.sldX_sliderReleased");
	connect (this.child("sldY"), "sliderReleased()", this, "iface.sldY_sliderReleased");
	connect (this.child("tbnPaises"), "clicked()", this, "iface.tbnPaises_clicked");
	connect (this.child("sbxLimCarN"), "valueChanged(int)", this, "iface.renovarTimer");
	connect (this.child("sbxTamFuenteN"), "valueChanged(int)", this, "iface.renovarTimer");
	connect (this.child("chkMostrarN"), "clicked()", this, "iface.renovarTimer");
	connect (this.child("sbxTamFuenteV"), "valueChanged(int)", this, "iface.renovarTimer");
	connect (this.child("ledTitulo"), "textChanged(QString)", this, "iface.renovarTimer");
	connect (this.child("sbxTamFuenteT"), "valueChanged(int)", this, "iface.renovarTimer");
	connect (this.child("tbnBorrarPos"), "clicked()", this, "iface.tbnBorrarPos_clicked");
	var util:FLUtil = new FLUtil;
	
	this.iface.configurarTablas();
	this.iface.iniciarValores();
	this.iface.habilitarControles();
}

function interna_validateForm():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	if (this.iface.xmlGrafico_) {
debug("Guardando " + this.iface.xmlGrafico_.toString(4));
		cursor.setValueBuffer("xml", this.iface.xmlGrafico_.toString(4));
	}
	return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_cargaArrayPosiciones(xmlDatos:FLDomDocument):Boolean
{
debug("oficial_cargaArrayPosiciones");
	var eGrafico:FLDomElement = xmlDatos.firstChild().toElement();
	this.iface.aPosiciones_ = [];
	
	var nodoPosiciones:FLDomNode = eGrafico.namedItem("Posiciones");
	if (!nodoPosiciones) {
debug("oficial_cargaArrayPosiciones NO HAY");
		return true;
	}
	var ePos:FLDomElement, idPos:String;
	for (var nodoPos:FLDomNode = nodoPosiciones.firstChild(); nodoPos; nodoPos = nodoPos.nextSibling()) {
		ePos = nodoPos.toElement();
		idPos = ePos.attribute("IdPos");
		this.iface.aPosiciones_[idPos] = [];
		this.iface.aPosiciones_[idPos]["x"] = ePos.attribute("X");
		this.iface.aPosiciones_[idPos]["y"] = ePos.attribute("Y");
	}
	return true;
}

function oficial_dibujarGrafico(xmlDatos:FLDomDocument, marco:Rect):Picture
{
	debug("Dibujando " + xmlDatos.toString(4));
	var util:FLUtil = new FLUtil;
	var eGrafico:FLDomElement = xmlDatos.firstChild().toElement();
	
	var mapa = new Picture();
	var pic = new Picture();
	var clrNombre;
	var clrValor;
	
	var codMapa:String = eGrafico.attribute("CodMapa");
	if (!codMapa || codMapa == "") {
		
	}
	var altoTitulo:String = parseInt(eGrafico.attribute("AltoT"));
	if (isNaN(altoTitulo)) {
		altoTitulo = 20;
	}
	var offCoordY:Number = altoTitulo;
	var titulo:String = eGrafico.attribute("Titulo");

	pic.begin();
	
	var imagen:String;
	var alto:Number;
	var ancho:Number;
	var moverMarco:Boolean = marco && (marco.x != 0 || marco.y != 0);
	if (moverMarco) {
		pic.savePainter();
		pic.translate(marco.x, marco.y);
	}
	
	if (marco) {
		alto = marco.height;
		ancho = marco.width;
		imagen = util.sqlSelect("gf_2dmapa", "imagen", "codmapa = '" + codMapa + "'");
	} else {
		var tamMuestra = this.child("lblMuestra").size;
		alto = tamMuestra.height;
		ancho = tamMuestra.width;
		imagen = this.cursor().valueBuffer("imagen");
	}
	
// 	if (!this.iface.aPosiciones_) {
		if (!this.iface.cargaArrayPosiciones(xmlDatos)) {
			return false;
		}
// 	}
	if (!imagen) {
		pic.drawText(0, 0, ancho, alto, pic.AlignCenter, util.translate("scripts", "No tiene cargado el fichero de imagen para el mapa %1").arg(codMapa), -1);
		return pic;
// 		MessageBox.warning(util.translate("scripts", "No tiene cargado el fichero de imagen"), MessageBox.Ok, MessageBox.NoButton);
// 		return false;
	}
	var mapa = sys.toPixmap(imagen);
	var pixSize = mapa.size;
	alto = parseInt(pixSize.height) + parseInt(offCoordY);
	ancho = parseInt(pixSize.width);
	eGrafico.setAttribute("Alto", alto);
	eGrafico.setAttribute("Ancho", ancho);
	
	var familyT:String = eGrafico.attribute("FontFamilyT");
	if (!familyT || familyT == "") {
		familyN = "Arial";
	}
	var sizeT:String = parseInt(eGrafico.attribute("FontSizeT"));
	if (isNaN(sizeT)) {
		sizeT = 10;
	}
	var fuenteT = flgraficos.iface.pub_dameFuente(familyT, sizeT);
	var colorT:String = eGrafico.attribute("ColorT");
	if (!colorT || colorT == "") {
		colorT = "0,0,0";
	}
	var clrTitulo = flgraficos.iface.pub_dameColor(colorT);
	pic.setPen( clrTitulo, 1);
	pic.setFont(fuenteT);
	pic.drawText(0, 0, ancho, altoTitulo, pic.AlignCenter, titulo, -1);
	
	pic.drawPixmap(0, altoTitulo, mapa);

	var familyN:String = eGrafico.attribute("FontFamilyN");
	if (!familyN || familyN == "") {
		familyN = "Arial";
	}
	var sizeN:String = parseInt(eGrafico.attribute("FontSizeN"));
	if (isNaN(sizeN)) {
		sizeN = 10;
	}
	var fuenteN = flgraficos.iface.pub_dameFuente(familyN, sizeN);
	
	var limiteCarN:Number = parseInt(eGrafico.attribute("LimiteCarN"));
	if (isNaN(limiteCarN)) {
		limiteCarN = 0;
	}
	var mostrarN:Boolean = eGrafico.attribute("MostrarN") == "true";
debug("mostrarN = " + mostrarN);
	
	var colorN:String = eGrafico.attribute("ColorN");
	if (!colorN || colorN == "") {
		colorN = "0,0,0";
	}
	clrNombre = flgraficos.iface.pub_dameColor(colorN);
	
	
	var familyV:String = eGrafico.attribute("FontFamilyV");
	if (!familyV || familyV == "") {
		familyV = "Arial";
	}
	var sizeV:String = parseInt(eGrafico.attribute("FontSizeV"));
	if (isNaN(sizeV)) {
		sizeV = 7;
	}
	var fuenteV = flgraficos.iface.pub_dameFuente(familyV, sizeV);
	
	var colorV:String = eGrafico.attribute("ColorV");
	if (!colorV || colorV == "") {
		colorV = "0,0,255";
	}
	clrValor = flgraficos.iface.pub_dameColor(colorV);
	
	var formatoValor:String = eGrafico.attribute("FormatV");
	if (!formatoValor || formatoValor == "") {
		formatoValor = "Entero";
	}

	var valores:FLDomElement = eGrafico.namedItem("Valores").toElement();
	var eValor:FLDomElement;
	var idPos:String;
	var nombre:String;
	
	var valor:String = "";
	var idPos:String;
	var aPosicion:Array;
	var y:Number;
	for (var nodoValor:FLDomNode = valores.firstChild(); nodoValor; nodoValor = nodoValor.nextSibling()) {
		eValor = nodoValor.toElement();
		valor = eValor.attribute("Valor");
		valor = flgraficos.iface.pub_formatearValor(valor, formatoValor);
		idPos = eValor.attribute("IdPos");
		nombre = eValor.attribute("Nombre");
		try {
			aPosicion = this.iface.aPosiciones_[idPos]
		} catch (e) {
			aPosicion = [];
			aPosicion["x"] = 0;
			aPosicion["y"] = 0;
		}
		if (mostrarN) {
			pic.setPen( clrNombre, 1);
			pic.setFont(fuenteN);
			y = parseInt(offCoordY) + parseInt(aPosicion.y);
			if (limiteCarN > 0) {
				pic.drawText(aPosicion.x, y, nombre, limiteCarN);
			} else {
				pic.drawText(aPosicion.x, y, nombre);
			}
		}
		pic.setFont( fuenteV );
		pic.setPen( clrValor, 1);
		y = parseInt(offCoordY) + parseInt(aPosicion.y) + parseInt(sizeV);
debug("Posicion dibujo " + aPosicion.x + ", " +  y + " = " + valor);
		pic.drawText(aPosicion.x, y, valor);
	}
debug("Fin dibujar 1");
	if (moverMarco) {
		pic.restorePainter();
	}
debug("Fin dibujar 2");
	return pic;
}

// function oficial_formatearValor(valor:String, formato:String):String
// {
// // debug("Formateando " + valor + " con formato " + formato);
// 	if (!valor || valor == "") {
// 		return;
// 	}
// 
// 	var util:FLUtil = new FLUtil;
// 	var result:String = valor;
// 
// 	var numero:Number = parseFloat(valor);
// 	var n:Number;
// 	switch(formato) {
// 		case "KM": {
// 			if (numero >= 1000000) {
// 				n = numero / 1000000;
// 				if (n == Math.round(n)) {
// 					result = n.toString().split(".")[0] + "M";
// 				} else {
// 					result = n.toString().split(".")[0] + "." + n.toString().split(".")[1].left(1) + "M";
// 				}
// 				break
// 			}
// 			if (numero >= 1000) {
// 				n = numero / 1000;
// 				result = n.toString().split(".")[0] + "K";
// 				break;
// 			}
// 			if (numero < 1000) {
// 				n = numero / 1000;
// 				if (n == Math.round(n)) {
// 					result = n.toString().split(".")[0] + "K";
// 				} else {
// 					result = n.toString().split(".")[0] + "." + n.toString().split(".")[1].left(1) + "K";
// 				}
// 				break
// 			}
// 			break;
// 		}
// 		case "Entero": {
// 			result = Math.round(valor);
// 			result = util.formatoMiles(result);
// 			break;
// 		}
// 		case "2D": {
// 			result = util.buildNumber(valor, "f", 2);
// 			result = util.formatoMiles(result);
// 			break;
// 		}
// 		default: {
// 			var longitud:Number = formato.length;
// 			var posComa:Number = formato.findRev(",");
// 			var numDec:Number = (posComa > -1 ? longitud - posComa - 1 : 0);
// 			result = util.buildNumber(valor, "f", numDec);
// 			if (formato.find(".") > -1) {
// 				result = util.formatoMiles(valorF);
// 			}
// 			break;
// 		}
// 	}
// // debug("Valor formateado " + result);
// 
// 	return result;
// }

/*function oficial_tbnValoresDefecto_clicked()
{
debug("oficial_tbnValoresDefecto_clicked");
	var util:FLUtil = new FLUtil;

	var res:Number = MessageBox.warning(util.translate("scripts", "Va a restaurar los valores por defecto del gráfico.\n¿Está seguro?"), MessageBox.Yes, MessageBox.No);
	if (res != MessageBox.Yes) {
		return;
	}
	
	this.iface.restaurarValoresDefecto();
	this.iface.cargarCampos();
}*/

function oficial_restaurarValoresDefecto():Boolean
{
	var util:FLUtil = new FLUtil;

	if (!this.iface.xmlGrafico_) {
		this.iface.xmlGrafico_ = new FLDomDocument();
		this.iface.xmlGrafico_.setContent("<Grafico Tipo='2d_mapa' />");
	}

	xmlDoc = this.iface.xmlGrafico_;
	var eGrafico:FLDomElement = xmlDoc.firstChild().toElement();
	eGrafico.setAttribute("Alto", "");
	eGrafico.setAttribute("Ancho", "");
	eGrafico.setAttribute("Tabla", "provincias");
	
	if (eGrafico.attribute("Titulo") != "") {
		eGrafico.setAttribute("Titulo", util.translate("scripts", "TITULO DEL GRAFICO"));
	}
	eGrafico.setAttribute("FontFamilyV", "Arial");
	eGrafico.setAttribute("FontSizeV", 10);
	eGrafico.setAttribute("FontFamilyN", "Arial");
	eGrafico.setAttribute("FontSizeN", 10);
	
	var nodoValores:FLDomElement = eGrafico.namedItem("Valores");
	var eValores:FLDomElement;
	if (nodoValores) {
		eGrafico.removeChild(nodoValores);
	}
	eValores = xmlDoc.createElement("Valores");
	eGrafico.appendChild(eValores);
	
// 	var curPosicionT:FLSqlCursor = this.child("tdbPosiciones").cursor();
// 	var curPosicion:FLSqlCursor = new FLSqlCursor(curPosicionT.table());
// 	curPosicion.select(curPosicionT.mainFilter());
// 	var totalPos:Number = curPosicion.size();
// 	if (totalPos < 1) {
// 		return false;
// 	}
// 	var eValor:FLDomElement;
// 	var aValores:Array = new Array(totalPos);
// 	while (curPosicion.next()) {
// 		eValor = xmlDoc.createElement("Valor");
// 		eValores.appendChild(eValor);
// 		eValor.setAttribute("IdPos", curPosicion.valueBuffer(this.iface.campoIdPos_));
// 		eValor.setAttribute("Valor", Math.round(Math.random() * 100000));
// 		eValor.setAttribute("Nombre", curPosicion.valueBuffer(this.iface.campoNombre_));
// 	}
	return true;
}

function oficial_dibujarGraficoPix()
{
	debug("oficial_dibujarGraficoPix");
// 	var eGrafico:FLDomElement = this.iface.xmlGrafico_.firstChild().toElement();

	var util:FLUtil = new FLUtil;
	var pic:Picture = this.iface.dibujarGrafico(this.iface.xmlGrafico_);
	if (!pic) {
		return false;
	}
// debug(pic);
	var clr = new Color();
	
	var lblMuestra = this.child( "lblMuestra" );
	var imagen:String = this.cursor().valueBuffer("imagen");
	var eGrafico:FLDomElement = this.iface.xmlGrafico_.firstChild().toElement();
	var altoT:Number = parseInt(eGrafico.attribute("AltoT"));
	var alto:Number = parseInt(eGrafico.attribute("Alto"));
	var ancho:Number = parseInt(eGrafico.attribute("Ancho"));
	var pixSize = new Size(ancho, alto);
// 	this.child("sldY").resize(this.child("sldY").size.width, alto - 50);
	
	
	
// 	if (imagen) {
// 		var mapa = sys.toPixmap(imagen);
// 		pixSize = mapa.size;
// 	} else {
// 		pixSize = lblMuestra.size;
// 	}
	
	var pix = new Pixmap();
// 	var devSize = this.child( "lblMuestra" ).size;//new Size(ancho, alto);
	pix.resize( pixSize );
	clr.setRgb( 255, 255, 255 );
	pix.fill( clr );
	pix = pic.playOnPixmap( pix );
	lblMuestra.pixmap = pix;
	this.child("lblTit").minimumSize = new Size(this.child("lblTit").size.width, altoT);
debug("Height = " + this.child("lblTit").size.height);
this.child("lblTit").show();
	pic.end();
}

function oficial_iniciarValores()
{
	var cursor:FLSqlCursor = this.cursor();
	var xml:String = cursor.valueBuffer("xml");
debug("xml " + xml);
	if (xml) {
		this.iface.xmlGrafico_ = new FLDomDocument;
		if (!this.iface.xmlGrafico_.setContent(xml)) {
			return false;
		}
	} else {	
		if (cursor.modeAccess() == cursor.Insert) {
			this.iface.restaurarValoresDefecto();
		} else {
			this.iface.restaurarValoresDefecto();
		}
	}
	this.iface.cargarCampos();
	this.iface.iniciarMuestrasColor();
	this.iface.tbnRefrescar_clicked();
}

function oficial_configurarTablas()
{
debug(0);
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	var tabla:String = cursor.valueBuffer("tabla");
	switch (tabla) {
		case "provincias": {
			if (sys.isLoadedModule("flfactppal")) {
				this.child("tdbPosiciones").setTableName("provincias");
				this.child("tdbPosiciones").cursor().setAction("provincias");
			} else {
				this.child("tdbPosiciones").setTableName("in_dimprovincia");
				this.child("tdbPosiciones").cursor().setAction("in_dimprovincia");
			}
			this.iface.campoIdPos_ = "idprovincia";
			this.iface.campoNombre_ = "provincia";
			this.child("gbxPaises").show();
			break;
		}
		case "paises": {
			if (sys.isLoadedModule("flfactppal")) {
				this.child("tdbPosiciones").setTableName("paises");
				this.child("tdbPosiciones").cursor().setAction("paises");
			} else {
				this.child("tdbPosiciones").setTableName("in_dimpais");
				this.child("tdbPosiciones").cursor().setAction("in_dimpais");
			}
			this.iface.campoIdPos_ = "codpais";
			this.iface.campoNombre_ = "nombre";
			this.iface.seleccionPaises_ = false;
			this.child("ledPaises").text = "";
			this.child("gbxPaises").close();
			break;
		}
	}
	this.child("tdbPosiciones").setFilter("");
	this.child("tdbPosiciones").refresh(true, true);
}

function oficial_cargarCampos():Boolean
{
debug("oficial_cargarCampos");
	var util:FLUtil = new FLUtil;
	
	this.iface.bloqueoRefresco_ = true;
	var cursor:FLSqlCursor = this.cursor();

	var eGrafico:FLDomElement = this.iface.xmlGrafico_.firstChild().toElement();
	this.child("ledTitulo").text = (eGrafico.attribute("Titulo"));
	this.child("fdbAltoT").setValue(eGrafico.attribute("AltoT"));
	
	this.child("fdbFamFuenteT").setValue(eGrafico.attribute("FontFamilyT"));
	this.child("sbxTamFuenteT").value = eGrafico.attribute("FontSizeT")
	this.child("fdbColorT").setValue(eGrafico.attribute("ColorT"));

	this.child("fdbFamFuenteN").setValue(eGrafico.attribute("FontFamilyN"));
	this.child("sbxTamFuenteN").value = eGrafico.attribute("FontSizeN")
	this.child("sbxLimCarN").value = eGrafico.attribute("LimiteCarN")
	this.child("chkMostrarN").checked = (eGrafico.attribute("MostrarN") == "" || eGrafico.attribute("MostrarN") == "true");
	this.child("fdbColorN").setValue(eGrafico.attribute("ColorN"));
	
	this.child("fdbFamFuenteV").setValue(eGrafico.attribute("FontFamilyV"));
	this.child("fdbFormatoV").setValue(eGrafico.attribute("FormatV"));
	this.child("sbxTamFuenteV").value = eGrafico.attribute("FontSizeV")
	this.child("fdbColorV").setValue(eGrafico.attribute("ColorV"));
	
	this.iface.bloqueoRefresco_ = false;
	
	return true;
}

function oficial_tbnRefrescar_clicked()
{
debug("oficial_tbnRefrescar_clicked");
// 	this.iface.restaurarValoresDefecto();
	
	this.iface.refrescarGrafico();
}

function oficial_refrescarGrafico()
{
debug("oficial_refrescarGrafico");
	killTimer(this.iface.timerGraf_);
debug("oficial_refrescarGrafico 2");
	var cursor:FLSqlCursor = this.cursor();
	if (cursor.isNull("tabla")) {
		return false;
	}
debug("oficial_refrescarGrafico3");
	var cursor:FLSqlCursor = this.cursor();
// 	this.iface.mostrarPaises()
	var eGrafico:FLDomElement = this.iface.xmlGrafico_.firstChild().toElement();

	eGrafico.setAttribute("CodMapa", cursor.valueBuffer("codmapa"));
	eGrafico.setAttribute("Tabla", cursor.valueBuffer("tabla"));
	eGrafico.setAttribute("Titulo", this.child("ledTitulo").text);
	eGrafico.setAttribute("ColorT", cursor.valueBuffer("colort"));
	eGrafico.setAttribute("AltoT", cursor.valueBuffer("altot"));
	
	eGrafico.setAttribute("FontFamilyT", cursor.valueBuffer("famfuentet"));
	eGrafico.setAttribute("FontSizeT", this.child("sbxTamFuenteT").value);
	
	eGrafico.setAttribute("FontFamilyN", cursor.valueBuffer("famfuenten"));
	eGrafico.setAttribute("FontSizeN", this.child("sbxTamFuenteN").value);
	eGrafico.setAttribute("LimiteCarN", this.child("sbxLimCarN").value);
	eGrafico.setAttribute("MostrarN", this.child("chkMostrarN").checked ? "true" : "false");
	eGrafico.setAttribute("ColorN", cursor.valueBuffer("colorn"));
	
	eGrafico.setAttribute("FontFamilyV", cursor.valueBuffer("famfuentev"));
	eGrafico.setAttribute("FormatV", cursor.valueBuffer("formatov"));
	eGrafico.setAttribute("FontSizeV", this.child("sbxTamFuenteV").value);
	eGrafico.setAttribute("ColorV", cursor.valueBuffer("colorv"));

	cursor.setValueBuffer("xml", this.iface.xmlGrafico_.toString(4));
debug("oficial_refrescarGrafico4");
	this.iface.dibujarGraficoPix();
}

/** \D Sólo es posible guardar los valores por defecto del gráfico cuando se accede desde el módulo de gráficos
\end */
function oficial_habilitarControles()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	var codMapa:String = cursor.valueBuffer("codmapa");
	this.child("fdbColorT").close();
	this.child("fdbColorN").close();
	this.child("fdbColorV").close();
// 	this.child("tbnValoresDefecto").close();
// 	this.child("tbnGuardar").close();
}

function oficial_bufferChanged(fN:String)
{
debug("BCh " + fN);
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	switch (fN) {
		case "codmapa":
		case "xml":{
			break;
		}
		case "tabla": {
			this.iface.configurarTablas();
			break;
		}
		case "imagen": {
			break;
		}
		case "colorn": {
			flgraficos.iface.pub_colorearLabel(this.child("lblColorN"), cursor.valueBuffer(fN));
			this.iface.renovarTimer();
			break;
		}
		case "colorv": {
			flgraficos.iface.pub_colorearLabel(this.child("lblColorV"), cursor.valueBuffer(fN));
			this.iface.renovarTimer();
			break;
		}
		case "colort": {
			flgraficos.iface.pub_colorearLabel(this.child("lblColorT"), cursor.valueBuffer(fN));
			this.iface.renovarTimer();
			break;
		}
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
// debug("Nuevo timer");
}

function oficial_iniciarMuestrasColor()
{
	var cursor:FLSqlCursor = this.cursor();
	flgraficos.iface.pub_colorearLabel(this.child("lblColorV"), cursor.valueBuffer("colorv"));
	flgraficos.iface.pub_colorearLabel(this.child("lblColorN"), cursor.valueBuffer("colorn"));
	flgraficos.iface.pub_colorearLabel(this.child("lblColorT"), cursor.valueBuffer("colort"));
}

function oficial_tdbPosiciones_currentChanged()
{
	if (!this.iface.aPosiciones_) {
		return false;
	}
	var curPosicion:FLSqlCursor = this.child("tdbPosiciones").cursor();
	var idPos:String = curPosicion.valueBuffer(this.iface.campoIdPos_);
	if (!idPos) {
		return false;
	}
	var nombre:String = curPosicion.valueBuffer(this.iface.campoNombre_);
	var aPos:Array;
	try {
		aPos = this.iface.aPosiciones_[idPos];
	} catch (e) {
		aPos = [];
		aPos["x"] = 25;
		aPos["y"] = 25;
		this.iface.aPosiciones_[idPos] = aPos;
	}
	var sMapa = this.child("lblMuestra").size;
	this.child("sldX").setValue(Math.round(aPos.x * 100 / sMapa.width));
	this.child("sldY").setValue(Math.round(aPos.y * 100 / sMapa.height));
	
	var eValor:FLDomElement = this.iface.dameNodoValor(idPos, nombre);
	this.iface.resaltarValor(idPos);
}

function oficial_resaltarValor(idPos:String)
{
	if (!this.iface.xmlGrafico_) {
		return false;
	}
	var eGrafico:FLDomElement = this.iface.xmlGrafico_.firstChild().toElement();
	var ePos:FLDomElement = this.iface.dameNodoPosicion(idPos);
	this.iface.refrescarGrafico();
// 	var eValor:FLDomElement = this.iface.dameNodoValor(idPos);
}

function oficial_sldX_sliderReleased()
{
	if (!this.iface.aPosiciones_) {
		return false;
	}
	var curPosicion:FLSqlCursor = this.child("tdbPosiciones").cursor();
	var idPos:String = curPosicion.valueBuffer(this.iface.campoIdPos_);
	if (!idPos) {
		return false;
	}
	var aPos:Array;
	try {
		aPos = this.iface.aPosiciones_[idPos];
	} catch (e) {
		debug("No hay IdPos");
		return;
	}
	var sMapa = this.child("lblMuestra").size;
	var x:Number = this.child("sldX").value;
	aPos.x = Math.round(sMapa.width * (x / 100));
	this.iface.cambiarCoordXML(idPos, aPos);
	this.iface.refrescarGrafico();
}

function oficial_sldY_sliderReleased()
{
	var curPosicion:FLSqlCursor = this.child("tdbPosiciones").cursor();
	var idPos:String = curPosicion.valueBuffer(this.iface.campoIdPos_);
	if (!idPos) {
		return false;
	}
	var aPos:Array;
	try {
		aPos = this.iface.aPosiciones_[idPos];
	} catch (e) {
debug("No hay IdPos");
		return;
	}
	var sMapa = this.child("lblMuestra").size;
	aPos.y = Math.round(sMapa.height * (this.child("sldY").value / 100));
	this.iface.cambiarCoordXML(idPos, aPos);
	this.iface.refrescarGrafico();
}

function oficial_cambiarCoordXML(idPos:String, aPos:Array):Boolean
{
	ePos = this.iface.dameNodoPosicion(idPos);
	if (!ePos) {
		return false;
	}
	ePos.setAttribute("X", aPos.x);
	ePos.setAttribute("Y", aPos.y);
	return true;
}

function oficial_dameNodoPosicion(idPos:String):FLDomElement
{
	var eGrafico:FLDomElement = this.iface.xmlGrafico_.firstChild().toElement();
	var nodoPosiciones:FLDomNode = eGrafico.namedItem("Posiciones");
	var ePosiciones:FLDomElement;
	if (nodoPosiciones) {
		ePosiciones = nodoPosiciones.toElement();
	} else {
		ePosiciones = this.iface.xmlGrafico_.createElement("Posiciones");
		eGrafico.appendChild(ePosiciones);
	}
	var ePos:FLDomElement;
	for (var nodoPos:FLDomNode = ePosiciones.firstChild(); nodoPos; nodoPos = nodoPos.nextSibling()) {
		ePos = nodoPos.toElement();
		if (ePos.attribute("IdPos") == idPos) {
			return ePos;
			break;
		}
	}
	ePos = this.iface.xmlGrafico_.createElement("Posicion");
	ePosiciones.appendChild(ePos);
	ePos.setAttribute("IdPos", idPos);
	ePos.setAttribute("X", "0");
	ePos.setAttribute("Y", "0");
	return ePos;
}

function oficial_borraNodoPosicion(idPos:String):Boolean
{
	var eGrafico:FLDomElement = this.iface.xmlGrafico_.firstChild().toElement();
	var nodoPosiciones:FLDomNode = eGrafico.namedItem("Posiciones");
	var ePosiciones:FLDomElement;
	if (!nodoPosiciones) {
		return true;
	}
	ePosiciones = nodoPosiciones.toElement();
	var ePos:FLDomElement;
	for (var nodoPos:FLDomNode = ePosiciones.firstChild(); nodoPos; nodoPos = nodoPos.nextSibling()) {
		ePos = nodoPos.toElement();
		if (ePos.attribute("IdPos") == idPos) {
			ePosiciones.removeChild(ePos);
			break;
		}
	}
	return true;
}

function oficial_dameNodoValor(idPos:String, nombre:String):FLDomElement
{
	if (!this.iface.xmlGrafico_) {
		return false;
	}
	var eGrafico:FLDomElement = this.iface.xmlGrafico_.firstChild().toElement();
	var nodoValores:FLDomNode = eGrafico.namedItem("Valores");
	var eValores:FLDomElement;
	if (nodoValores) {
		eValores = nodoValores.toElement();
	} else {
		eValores = this.iface.xmlGrafico_.createElement("Valores");
		eGrafico.appendChild(eValores);
	}
	var eValor:FLDomElement;
	for (var nodoValor:FLDomNode = eValores.firstChild(); nodoValor; nodoValor = nodoValor.nextSibling()) {
		eValor = nodoValor.toElement();
		if (eValor.attribute("IdPos") == idPos) {
			return eValor;
			break;
		}
	}
	eValor = this.iface.xmlGrafico_.createElement("Valor");
	eValores.appendChild(eValor);
	eValor.setAttribute("IdPos", idPos);
	eValor.setAttribute("Nombre", nombre);
	eValor.setAttribute("Valor", "0");
	return eValor;
}

function oficial_borraNodoValor(idPos:String, nombre:String):Boolean
{
	var eGrafico:FLDomElement = this.iface.xmlGrafico_.firstChild().toElement();
	var nodoValores:FLDomNode = eGrafico.namedItem("Valores");
	var eValores:FLDomElement;
	if (!nodoValores) {
		return true;
	}
	eValores = nodoValores.toElement();
	var eValor:FLDomElement;
	for (var nodoValor:FLDomNode = eValores.firstChild(); nodoValor; nodoValor = nodoValor.nextSibling()) {
		eValor = nodoValor.toElement();
		if (eValor.attribute("IdPos") == idPos) {
			eValores.removeChild(eValor);
			break;
		}
	}
	return true;
}

function oficial_tbnPaises_clicked()
{
	if (!this.iface.xmlGrafico_) {
		return false;
	}
	var eGrafico:FLDomElement = this.iface.xmlGrafico_.firstChild().toElement();
	this.iface.seleccionPaises_ = eGrafico.attribute("Paises");
	
	var curPaises:FLSqlCursor = (sys.isLoadedModule("flfactppal") ? new FLSqlCursor("paises") : new FLSqlCursor("in_dimpais"));
	var f:Object = new FLFormSearchDB(curPaises, "gf_seleccionpaises");
	f.setMainWidget();
	f.exec();
	if (f.accepted()) {
// 		eGrafico.setAttribute("Paises", this.iface.seleccionPaises_);
		this.iface.mostrarPaises();
	}
}

function oficial_mostrarPaises()
{
debug("oficial_mostrarPaises");
	if (!this.iface.xmlGrafico_) {
		return false;
	}
	var util:FLUtil = new FLUtil;
	var eGrafico:FLDomElement = this.iface.xmlGrafico_.firstChild().toElement();
	var paises:String =  this.iface.seleccionPaises_; //eGrafico.attribute("Paises");
	var filtro:String = "";
	var lista:String = "";
	if (paises && paises != "") {
		filtro = "codpais IN (";
		var tablaPais:String = (sys.isLoadedModule("flfactppal") ? "paises" : "in_dimpais");
		var aPaises:Array = paises.split(", ");
		var pais:String;
		for (var i:Number = 0; i < aPaises.length; i++) {
			pais = util.sqlSelect(tablaPais, "nombre", "codpais = '" + aPaises[i] + "'");
			lista += lista == "" ? pais : ", " + pais;
			filtro += i > 0 ? ", " : "";
			filtro += "'" + aPaises[i] + "'";
		}
		filtro += ")";
	}
	this.child("tdbPosiciones").setFilter(filtro);
	this.child("tdbPosiciones").refresh();
	this.child("ledPaises").text = lista;
	
}

function oficial_tbnBorrarPos_clicked()
{
	var curPos:FLSqlCursor = this.child("tdbPosiciones").cursor();
	var idPos:String = curPos.valueBuffer(this.iface.campoIdPos_);
	if (!idPos) {
		return true;
	}
	if (!this.iface.borraNodoValor(idPos)) {
		return false;
	}
	if (!this.iface.borraNodoPosicion(idPos)) {
		return false;
	}
	this.iface.dibujarGraficoPix();
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
