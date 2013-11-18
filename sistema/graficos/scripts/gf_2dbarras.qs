/***************************************************************************
                 2dbarras.qs  -  description
                             -------------------
    begin                : mie abr 21 2010
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
	var tblColoresSec_:FLTable;

	var CS_ID:Number;
	var CS_COLOR:Number;
	var CS_RGB:Number;
	var CS_MUESTRA:Number;

	function oficial( context ) { interna( context ); }
	function dibujarGrafico(xmlDatos:FLDomDocument, marco:Rect):Picture {
		return this.ctx.oficial_dibujarGrafico(xmlDatos, marco);
	}
	function tbnValoresDefecto_clicked() {
		return this.ctx.oficial_tbnValoresDefecto_clicked();
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
	function redondearEjeY2dBarras(valor:Number):Number {
		return this.ctx.oficial_redondearEjeY2dBarras(valor);
	}
	function calcularMaxY(xmlDatos:FLDomDocument):Number {
		return this.ctx.oficial_calcularMaxY(xmlDatos);
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
	function activarDesactivarColoresDefecto() {
		return this.ctx.oficial_activarDesactivarColoresDefecto();
	}
	function mostrarTablaColores() {
		return this.ctx.oficial_mostrarTablaColores();
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
	function tbnCrearColorSec_clicked() {
		return this.ctx.oficial_tbnCrearColorSec_clicked();
	}
	function crearColorSec(idColor:String):Boolean {
		return this.ctx.oficial_crearColorSec(idColor);
	}
	function tbnCambiarColorSec_clicked() {
		return this.ctx.oficial_tbnCambiarColorSec_clicked();
	}
	function cambiarColorSec(fila:Number, idColor:String):Boolean {
		return this.ctx.oficial_cambiarColorSec(fila, idColor);
	}
	function tbnBorrarColorSec_clicked() {
		return this.ctx.oficial_tbnBorrarColorSec_clicked();
	}
	function cargarColoresSecuencias(eGrafico:FLDomElement):Array {
		return this.ctx.oficial_cargarColoresSecuencias(eGrafico);
	}
	function tbnSubirColorSec_clicked() {
		return this.ctx.oficial_tbnSubirColorSec_clicked();
	}
	function tbnBajarColorSec_clicked() {
		return this.ctx.oficial_tbnBajarColorSec_clicked();
	}
	function moverColorSec(fila1:Number, direccion:Number):Boolean {
		return this.ctx.oficial_moverColorSec(fila1, direccion);
	}
	function tblColoresSec_doubleClicked(fila:Number, col:Number) {
		return this.ctx.oficial_tblColoresSec_doubleClicked(fila, col);
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
	this.iface.tblColoresSec_ = this.child("tblColoresSec");

	connect(this.child("tbnValoresDefecto"), "clicked()", this, "iface.tbnValoresDefecto_clicked");
	connect(this.child("tbnRefrescar"), "clicked()", this, "iface.tbnRefrescar_clicked");
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this.child("tbnCrearColorSec"), "clicked()", this, "iface.tbnCrearColorSec_clicked");
	connect(this.child("tbnBorrarColorSec"), "clicked()", this, "iface.tbnBorrarColorSec_clicked");
	connect(this.child("tbnCambiarColorSec"), "clicked()", this, "iface.tbnCambiarColorSec_clicked");
	connect(this.child("tbnSubirColorSec"), "clicked()", this, "iface.tbnSubirColorSec_clicked");
	connect(this.child("tbnBajarColorSec"), "clicked()", this, "iface.tbnBajarColorSec_clicked");
	connect(this.iface.tblColoresSec_, "clicked(int, int)", this, "iface.tblColoresSec_doubleClicked");
	
	
	this.iface.configurarTablas();
	this.iface.iniciarValores();
	this.iface.habilitarControles();
}

/**
\C Los datos de la empresa son únicos, por tanto formulario de no presenta los botones de navegación por registros.
\end

\D La gestión del formulario se hace de forma manual mediante el objeto f (FLFormSearchDB)
\end
\end */
function interna_main()
{
	var f:Object = new FLFormSearchDB("gf_2dbarras");
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
debug("XXXXXXXXXXX\noficial_dibujarGrafico: " + xmlDatos.toString(4));
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
	
	var x:Array = [];
	var y:Array = [];

	var fontFamily:String = eGrafico.attribute("FontFamily");
	var fontSize:Number = eGrafico.attribute("FontSize");
	if (!fontSize || isNaN(fontSize)) {
		fontSize = 10;
	}
	var clf = flgraficos.iface.pub_dameFuente(fontFamily, fontSize); // FUENTE DE LAS ETIQUETAS EN LOS EJES
	pic.setFont( clf );
	
	var eValores:FLDomElement = eGrafico.namedItem("Valores").toElement();
	var xmlSecuenciasValor:FLDomNodeList = eValores.elementsByTagName("Secuencia");
	if (!xmlSecuenciasValor || xmlSecuenciasValor.length() == 0) {
		MessageBox.warning(util.translate("scripts", "No es posible representar el gráfico. No hay valores que representar"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var numSecuencias:Number = xmlSecuenciasValor.length();
	
	var posLeyenda:String = eGrafico.attribute("PosLeyenda");
	if (!posLeyenda || posLeyenda == "" || posLeyenda == "Auto") {
		if (numSecuencias > 1) {
			posLeyenda = "Abajo";
		} else {
			posLeyenda = "No";
		}
	}
	if (posLeyenda != "No") {
		anchoLeyenda = parseInt(eGrafico.attribute("AnchoLeyenda"));
		if (!anchoLeyenda || isNaN(anchoLeyenda)) { anchoLeyenda = Math.floor(ancho * 0.5 / numSecuencias); }
		altoLeyenda = parseInt(eGrafico.attribute("AltoLeyenda"));
		if (!altoLeyenda || isNaN(altoLeyenda)) { altoLeyenda = fontSize * 2; }
	} else {
		anchoLeyenda = 0;
		altoLeyenda = 0;
	}

	var titulo:String = eGrafico.attribute("Titulo");
	var altoTitulo:Number = (titulo && titulo != "" ? parseInt(fontSize) * 2 : 0);
	
	var eEjeX:FLDomElement = eGrafico.namedItem("EjeX").toElement();
	var minX:Number = parseFloat(eEjeX.attribute("Min"));
	if (isNaN(minX)) {
		minX = 0;
	}
	var maxX:Number = parseFloat(eEjeX.attribute("Max"));
	var margenLabelsX:Number = parseFloat(eEjeX.attribute("MargenLabels"));
	if (isNaN(margenLabelsX)) { margenLabelsX = 0;}
	var anguloLabelX:Number = parseFloat(eEjeX.attribute("AnguloLabel"));
	if (isNaN(anguloLabelX)) { anguloLabelX = 0;}

	var eEjeY:FLDomElement = eGrafico.namedItem("EjeY").toElement();
	var minY:Number = parseFloat(eEjeY.attribute("Min"));
	if (isNaN(minY)) {
		minY = 0;
	}

	var marcarCadaY:Number = parseFloat(eEjeY.attribute("MarcarCada"));
	var maxY:Number = parseFloat(eEjeY.attribute("Max"));
debug("maxY = " + maxY);
debug("isnan = " + isNaN(maxY));
	if (isNaN(maxY)) {
		maxY = this.iface.calcularMaxY(xmlDatos);
debug("maxY funcion = " + maxY);
		if (isNaN(maxY)) {
			MessageBox.warning(util.translate("scripts", "Error al calcular el máximo valor del gráfico"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
		if (!marcarCadaY || marcarCadaY == 0) {
			marcarCadaY = this.iface.redondearEjeY2dBarras(maxY / 5);
			maxY = Math.ceil(maxY / marcarCadaY) * marcarCadaY;
		}
	}
	var medidaY:String = eEjeY.attribute("Medida");
	var altoMedidaY:Number = (medidaY && medidaY != "" ? parseInt(fontSize) * 2 : 0);
	
	var aSecuencias:Array = this.iface.cargarColoresSecuencias(eGrafico);
	var margenLabelsY:Number = parseFloat(eEjeY.attribute("MargenLabels"));
	if (isNaN(margenLabelsY)) { margenLabelsY = 0;}

	var marcarLabelsY:Boolean = false;
	if (eEjeY.attribute("MarcarLabels") == "true" || eEjeY.attribute("MarcarLabels") == "1") {
		marcarLabelsY = true;
	}

	var formatoValor:String = eGrafico.attribute("FormatoV");
	if (!formatoValor || formatoValor == "")
		formatoValor = "Entero";
		
	var offGraficoX:Number = margenIzquierdo + margenLabelsY;
	var offGraficoY:Number = margenSuperior + parseInt(altoTitulo) + parseInt(altoMedidaY);
	var anchoNeto:Number;
	var altoNeto:Number;
	var leyendasPorFila:Number, filasLeyenda:Number;
	switch (posLeyenda) {
		case "Arriba": {
			anchoNeto = (ancho - margenIzquierdo - margenDerecho - margenLabelsY);
			leyendasPorFila = (anchoNeto > anchoLeyenda ? Math.floor(anchoNeto / anchoLeyenda) : 1);
			filasLeyenda = Math.ceil(numSecuencias / leyendasPorFila);
			offGraficoY += parseFloat(altoLeyenda * filasLeyenda);
			altoNeto = (alto - margenSuperior - altoTitulo - altoMedidaY - margenInferior - margenLabelsX - (altoLeyenda * filasLeyenda));
			break;
		}
		case "Abajo": {
			anchoNeto = (ancho - margenIzquierdo - margenDerecho - margenLabelsY);
			leyendasPorFila = (anchoNeto > anchoLeyenda ? Math.floor(anchoNeto / anchoLeyenda) : 1);
			filasLeyenda = Math.ceil(numSecuencias / leyendasPorFila);
			altoNeto = (alto - margenSuperior - altoTitulo - altoMedidaY - margenInferior - margenLabelsX - (altoLeyenda * filasLeyenda));
			break;
		}
		case "Izquierda": {
			anchoNeto = (ancho - margenIzquierdo - margenDerecho - margenLabelsY - anchoLeyenda);
			altoNeto = (alto - margenSuperior - altoTitulo - altoMedidaY - margenInferior - margenLabelsX);
			offGraficoX += parseFloat(anchoLeyenda);
			break;
		}
		case "Derecha": {
			anchoNeto = (ancho - margenIzquierdo - margenDerecho - margenLabelsY - anchoLeyenda);
			altoNeto = (alto - margenSuperior - altoTitulo - altoMedidaY - margenInferior - margenLabelsX);
			break;
		}
		default: {
			anchoNeto = (ancho - margenIzquierdo - margenDerecho - margenLabelsY);
			altoNeto = (alto - margenSuperior - altoTitulo - altoMedidaY - margenInferior - margenLabelsX);
			break;
		}
	}
	
	var factorX:Number = anchoNeto / (maxX - minX);
	var factorY:Number = altoNeto / (maxY - minY);
	
	var fMaxX = ((maxX - minX) * factorX);
	var fMaxY = (maxY - minY) * factorY;

	clr.setRgb( 0, 0, 0 );
	pic.setPen( clr, 1); // pic.DotLine );

/// Título
	try {
		pic.drawText(offGraficoX, margenSuperior, anchoNeto, altoTitulo, pic.AlignLeft | pic.AlignVCenter, titulo, -1);
	} catch (e) {
		pic.drawText(offGraficoX, margenSuperior + parseInt(altoTitulo) - 10, titulo);
	}

/// Marco
	if (marco) {
		pic.drawLine(1, 1, alto, 1);
		pic.drawLine(0, alto, ancho, alto);
		pic.drawLine(1, 1, 1, alto);
		pic.drawLine(ancho, 1, ancho, alto);
	}

/// Leyenda
	var eSecuencia:FLDomElement;
	if (posLeyenda != "No") {
		var fila:Number = 0, col:Number = 0, xLey:Number, yLey:Number;
		for (iSecuencia = 0; iSecuencia < numSecuencias; iSecuencia++) {
			eSecuencia = xmlSecuenciasValor.item(iSecuencia).toElement();
			switch (posLeyenda) {
				case "Arriba": {
					xLey = parseInt(offGraficoX) + (col * anchoLeyenda);
					yLey = parseInt(margenSuperior) + parseInt(altoTitulo) + (fila * altoLeyenda) + parseInt(fontSize);
					col++
					if (col == leyendasPorFila) {
						col = 0;
						fila++;
					}
					break;
				}
				case "Abajo": {
					xLey = parseInt(offGraficoX) + (col * anchoLeyenda);
					yLey = margenSuperior + altoNeto + altoTitulo + altoMedidaY + margenLabelsX + (fila * altoLeyenda) + parseInt(fontSize);
					col++
					if (col == leyendasPorFila) {
						col = 0;
						fila++;
					}
					break;
				}
				case "Izquierda": {
					xLey = margenIzquierdo;
					yLey = parseInt(offGraficoY) + (fila * altoLeyenda) + parseInt(fontSize);
					fila++
					break;
				}
				case "Derecha": {
					xLey = parseInt(offGraficoX) + anchoNeto;
					yLey = parseInt(offGraficoY) + (fila * altoLeyenda) + parseInt(fontSize);
					fila++
					break;
				}
				default: {
					continue;
				}
			}
			var clrBrushAnt:Color = flgraficos.iface.pub_dameColor("255,255,255");
			var clrLey:Color = flgraficos.iface.pub_dameColor(aSecuencias[iSecuencia][1]);
			pic.setBrush(clrLey);
			pic.drawRect(xLey, yLey - (fontSize / 2) - 5, 10, 10);
			pic.drawText(xLey + 15, yLey, eSecuencia.attribute("Leyenda"));
			pic.setBrush(clrBrushAnt);
		}
	}
	pic.drawLine( offGraficoX, parseInt(offGraficoY) + parseInt(fMaxY), parseInt(offGraficoX) + parseInt(fMaxX), parseInt(offGraficoY) + parseInt(fMaxY));
	pic.drawLine( offGraficoX, parseInt(offGraficoY) + parseInt(fMaxY), offGraficoX, offGraficoY );

/// Eje X
	var marcarCadaX:Number = parseFloat(eEjeX.attribute("MarcarCada"));
	var limiteLabelX:Number = parseFloat(eEjeX.attribute("LimiteLabel"));
	limiteLabelX = (isNaN(limiteLabelX) ? 0 : limiteLabelX);
	var xmlMarcas:FLDomNodeList = eEjeX.elementsByTagName("Marca");
	var xmlMarca:FLDomNode;
	var labelMarca:String;
	if (!isNaN(marcarCadaX) && marcarCadaX > 0) {
		var fMarcarCadaX:Number = marcarCadaX * factorX;
		var fX:Number;
		for (var x:Number = minX; x <= maxX; x += marcarCadaX) {
			fX = (x * factorX);
			fX = fX - (minX * factorX);
			pic.drawLine( parseInt(offGraficoX) + parseInt(fX), parseInt(offGraficoY) + parseInt(fMaxY), parseInt(offGraficoX) + parseInt(fX), parseInt(offGraficoY) + parseInt(fMaxY) + 5);
			if (x < maxX) {
				labelMarca = x.toString();
				if (xmlMarcas) {
					xmlMarca = xmlMarcas.item(x - minX);
					if (xmlMarca) {
						labelMarca = xmlMarca.toElement().attribute("Label");
					}
				}
				labelMarca = (limiteLabelX > 0 ? labelMarca.left(limiteLabelX) : labelMarca);
				if (anguloLabelX != 0) {
					pic.savePainter();
					pic.translate(parseInt(offGraficoX) + parseInt(fX) + factorX, parseInt(offGraficoY) + parseInt(fMaxY));// + parseInt(margenLabelsX / 2));
					pic.rotate(anguloLabelX);
					var r = new Rect(0, 0, -margenLabelsX, margenLabelsX);
					var maxLetras:Number = 10;
					pic.drawText((-1 * margenLabelsX), 0, labelMarca, maxLetras);
					pic.drawLine(0, 0, -margenLabelsX, 0)
					pic.restorePainter();
				} else {
					pic.drawText(parseInt(offGraficoX) + parseInt(fX), parseInt(offGraficoY) + parseInt(fMaxY) + parseInt(fontSize) + 10, labelMarca);
				}
			}
		}
	}

/// Eje Y
	var colorLineaMarcaY:String = eEjeY.attribute("ColorLineaMarca");
	var estiloLineaMarcaY:Number = parseInt(eEjeY.attribute("EstiloLineaMarca"));
	if (!estiloLineaMarcaY || isNaN(estiloLineaMarcaY)) {
		estiloLineaMarcaY = 0;
	}
	var clrLineaMarcaY:Color;
	if (colorLineaMarcaY && colorLineaMarcaY != "") {
		clrLineaMarcaY = flgraficos.iface.pub_dameColor(colorLineaMarcaY);
	} else {
		clrLineaMarcaY = false;
	}
	if (medidaY && medidaY != "") {
		try {
			pic.drawText(offGraficoX - margenLabelsY, margenSuperior + parseInt(altoTitulo), margenLabelsY, altoMedidaY, pic.AlignRight | pic.AlignVCenter, medidaY, -1);
		} catch (e) {
			pic.drawText(parseInt(offGraficoX) - margenLabelsY, margenSuperior + parseInt(altoTitulo) + parseInt(altoMedidaY) - fontSize, medidaY);
		}
	}
	if (!isNaN(marcarCadaY) && marcarCadaY > 0) {
		var fMarcarCadaY:Number = marcarCadaY * factorY;
		var fY:Number;
		var totalMarcas:Number = Math.ceil((maxY - minY) / marcarCadaY);
		var altoMarca:Number = marcarCadaY * factorY;
		var valory:Number;
		for (var y:Number = minY; y <= maxY; y += marcarCadaY) {
			fY = y * factorY - 1;
			fY = parseFloat(fMaxY) - fY + (minY * factorY);
			pic.drawLine( parseInt(offGraficoX),parseInt(offGraficoY) + parseInt(fY), parseInt(offGraficoX)-5, parseInt(offGraficoY) + parseInt(fY));
			if (clrLineaMarcaY && y > minY && estiloLineaMarcaY > 0) {
				pic.setPen(clrLineaMarcaY, 1, estiloLineaMarcaY);
				pic.drawLine( parseInt(offGraficoX), parseInt(offGraficoY) + parseInt(fY), parseInt(offGraficoX) + parseInt(fMaxX), parseInt(offGraficoY) + parseInt(fY));
				pic.setPen(clr, 1, 1);
			}
			
			if (marcarLabelsY) {
				valory = flgraficos.iface.pub_formatearValor(y, formatoValor);
				try {
					pic.drawText(parseInt(offGraficoX) - margenLabelsY, parseInt(offGraficoY) + parseInt(fY) - parseInt(altoMarca / 2), margenLabelsY - 10, altoMarca, pic.AlignRight | pic.AlignVCenter, valory.toString(), -1);
				} catch (e) {
					pic.drawText(parseInt(offGraficoX) - margenLabelsY, parseInt(offGraficoY) + parseInt(fY) + parseInt(fontSize / 2), valory.toString());
				}
			}
		}
	}

/// Barras
	var separacion:Number = factorX * 5 / 100 // SEPARACION ENTRE BARRAS
	var anchoBarra:Number = factorX * 90 / 100 / numSecuencias;
	var anchoSecuencia:Number = factorX * 95 / 100 / numSecuencias;
	var separacionSec:Number = factorX * 5 / 100 // SEPARACION ENTRE SECUENCIAS
	var colorBarras:String;
	var iSecuencia:Number = 0;
	for (iSecuencia = 0; iSecuencia < numSecuencias; iSecuencia++) {
		eSecuencia = xmlSecuenciasValor.item(iSecuencia).toElement();
		colorBarras = aSecuencias[iSecuencia][1];
		var clrBarras = flgraficos.iface.pub_dameColor(colorBarras); // COLOR BARRAS
		var nodos:FLDomNodeList = eSecuencia.toElement().elementsByTagName("Valor");
		if (!nodos) {
			continue;
		}
		var valor:FLDomElement;
		for (var i:Number = 0; i < nodos.length(); i++) {
			valor = nodos.item(i).toElement();
			var x:Number = (parseFloat(offGraficoX) + (parseFloat(valor.attribute("X")) * parseFloat(factorX)) + (iSecuencia * anchoSecuencia)) - (minX * factorX);
			var anchoRect:Number = anchoBarra; //(factorX-separacion);
			var y:String = ((parseFloat(fMaxY) - (parseFloat(valor.attribute("Y")) * parseFloat(factorY))) + parseFloat(offGraficoY)) + (minY * factorY);
			var labelX:String = valor.attribute("LabelX");
			var labelY:String = valor.attribute("LabelY");
			var altoRect:Number = (parseFloat(valor.attribute("Y")) * parseFloat(factorY));
			pic.fillRect(x, y, anchoRect, altoRect, clrBarras);
			
			if(labelY && labelY != "") {
				pic.drawText(parseInt(margenIzquierdo), y, labelY);
			}
		}
// 		iSecuencia++;
	}

	//pic.save("/home/lorena/picture.svg","svg");
	if (moverMarco) {
		pic.restorePainter();
	}
	return pic;
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
	var util:FLUtil = new FLUtil;

	if (!this.iface.xmlGrafico_) {
		this.iface.xmlGrafico_ = new FLDomDocument();
		this.iface.xmlGrafico_.setContent("<Grafico Tipo='2d_barras' />");
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
	
	eGrafico.setAttribute("PosLeyenda", "Abajo");
	eGrafico.setAttribute("AltoLeyenda", "20");
	eGrafico.setAttribute("AnchoLeyenda", "150");

	eGrafico.setAttribute("FormatoV", "Entero");
	eGrafico.setAttribute("FontFamily", "Arial");
	eGrafico.setAttribute("FontSize", 10);
	
	var aMarcasX:Array = [util.translate("scripts", "Enero"), util.translate("scripts", "Febrero"), util.translate("scripts", "Marzo"),
		util.translate("scripts", "Abril"), util.translate("scripts", "Mayo"), util.translate("scripts", "Junio"),
		util.translate("scripts", "Julio"), util.translate("scripts", "Agosto"), util.translate("scripts", "Septiembre"),
		util.translate("scripts", "Octubre"), util.translate("scripts", "Noviembre"), util.translate("scripts", "Diciembre")];
	var aValores0:Array = [[0, 100], [1, 300], [2, 700],
		[3, 100], [4, 100], [5, 100],
		[6, 100], [7, 100], [8, 100],
		[9, 100], [10, 100], [11, 100]];
	var aValores1:Array = [[0, 300], [1, 300], [2, 400],
		[3, 300], [4, 300], [5, 400],
		[6, 400], [7, 400], [8, 300],
		[9, 700], [10, 800], [11, 300]];
	var aValores:Array = new Array(2);
	aValores[0] = aValores0;
	aValores[1] = aValores1;
	var maxX:Number = aValores1.length;

	var nodoEjeX:FLDomElement = eGrafico.namedItem("EjeX");
	var eEjeX:FLDomElement;
	if (nodoEjeX) {
		eEjeX = nodoEjeX.toElement();
	} else {
		eEjeX = xmlDoc.createElement("EjeX");
		eGrafico.appendChild(eEjeX);
		eEjeX.setAttribute("Min", "0");
		eEjeX.setAttribute("Max", maxX);
		var eMarcaX:FLDomElement;
		for (var i:Number = 0; i < aMarcasX.length; i++) {
			eMarcaX = xmlDoc.createElement("Marca");
			eEjeX.appendChild(eMarcaX);
			eMarcaX.setAttribute("Id", i);
			eMarcaX.setAttribute("Label", aMarcasX[i]);
		}
	}
	eEjeX.setAttribute("MargenLabels", "50");
	eEjeX.setAttribute("AnguloLabel", "-45");
	eEjeX.setAttribute("MarcarCada", "1");
	

	var nodoEjeY:FLDomElement = eGrafico.namedItem("EjeY");
	var eEjeY:FLDomElement;
	if (nodoEjeY) {
		eEjeY = nodoEjeY.toElement();
	} else {
		eEjeY = xmlDoc.createElement("EjeY");
		eGrafico.appendChild(eEjeY);
	}
		
	eEjeY.setAttribute("Min", "0");
	eEjeY.setAttribute("Max", "");
	eEjeY.setAttribute("MargenLabels", "50");
	eEjeY.setAttribute("MarcarLabels", "true");
	eEjeX.setAttribute("MarcarCada", "1");
	eEjeX.setAttribute("ColorLineaMarca", "0,0,0");
	eEjeX.setAttribute("EstiloLineaMarca", "1");
	
	var nodoValores:FLDomElement = eGrafico.namedItem("Valores");
	var eValores:FLDomElement;
	if (nodoValores) {
		eValores = nodoValores.toElement();
	} else {
		eValores = xmlDoc.createElement("Valores");
		eGrafico.appendChild(eValores);
		eValores.setAttribute("Secuencias", aValores.length);
		var eSecuencia:FLDomElement;
		var eValor:FLDomDocument;
		var eValor:FLDomDocument;
		for (var s:Number = 0; s < 2; s++) {
			eSecuencia = xmlDoc.createElement("Secuencia");
			eValores.appendChild(eSecuencia);
			eSecuencia.setAttribute("Id", "Sec" + s.toString());
			eSecuencia.setAttribute("Leyenda", util.translate("scripts", "Ventas en %1").arg(2010 + parseInt(s)));
			for (var i:Number = 0; i < maxX; i++) {
				eValor = xmlDoc.createElement("Valor");
				eSecuencia.appendChild(eValor);
				eValor.setAttribute("X", aValores[s][i][0]);
				eValor.setAttribute("Y", aValores[s][i][1]);
			}
		}
	}
	return true;
}

function oficial_dibujarGraficoPix()
{
	var eGrafico:FLDomElement = this.iface.xmlGrafico_.firstChild().toElement();

	var pic:Picture = this.iface.dibujarGrafico(this.iface.xmlGrafico_);
	var ancho:Number = parseInt(eGrafico.attribute("Ancho"));
	var alto:Number = parseInt(eGrafico.attribute("Alto"));
// debug(pic);
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
	var cursor:FLSqlCursor = this.cursor();
	var xml:String = cursor.valueBuffer("xml");
	if (xml) {
		this.iface.xmlGrafico_ = new FLDomDocument;
		if (!this.iface.xmlGrafico_.setContent(xml)) {
			return false;
		}
	} else {	
		if (cursor.modeAccess() == cursor.Insert) {
			this.iface.restaurarValoresDefecto();
		} else {
			return false;
		}
	}
	this.iface.cargarCampos();
	this.iface.iniciarMuestrasColor();
	this.iface.tbnRefrescar_clicked();
	this.iface.activarDesactivarColoresDefecto();
}

function oficial_configurarTablas()
{
	var util:FLUtil = new FLUtil;

	this.iface.CS_ID = 0;
	this.iface.CS_COLOR = 1;
	this.iface.CS_RGB = 2;
	this.iface.CS_MUESTRA = 3;

	this.iface.tblColoresSec_.setNumRows(0);
	this.iface.tblColoresSec_.setNumCols(4);
	var cabecera:Array = [util.translate("scripts", "ID"), util.translate("scripts", "Color"), util.translate("scripts", "RGB"), util.translate("scripts", "Muestra")];
	this.iface.tblColoresSec_.setColumnLabels("*", cabecera.join("*"));
	this.iface.tblColoresSec_.hideColumn(this.iface.CS_ID);
	this.iface.tblColoresSec_.setColumnWidth(this.iface.CS_COLOR, 100);
	this.iface.tblColoresSec_.setColumnWidth(this.iface.CS_RGB, 0);
	this.iface.tblColoresSec_.setColumnWidth(this.iface.CS_MUESTRA, 80);
	this.iface.tblColoresSec_.hideColumn(this.iface.CS_RGB);
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
	this.child("fdbFormatoV").setValue(eGrafico.attribute("FormatoV"));
	var posLeyenda:String = eGrafico.attribute("PosLeyenda");
	if (posLeyenda == "") {
		posLeyenda = "Auto";
	}
	cursor.setValueBuffer("posleyenda", posLeyenda);
	this.child("fdbAltoLeyenda").setValue(eGrafico.attribute("AltoLeyenda"));
	this.child("fdbAnchoLeyenda").setValue(eGrafico.attribute("AnchoLeyenda"));

	this.child("fdbFamiliaFuente").setValue(eGrafico.attribute("FontFamily"));
	this.child("fdbTamanoFuente").setValue(eGrafico.attribute("FontSize"));

	var eEjeX:FLDomElement = eGrafico.namedItem("EjeX").toElement();
	this.child("fdbMargenLabelX").setValue(eEjeX.attribute("MargenLabels"));
	this.child("fdbAnguloLabelX").setValue(eEjeX.attribute("AnguloLabel"));
// 	this.child("fdbMarcarLabelX").setValue(eEjeX.attribute("MarcarLabels") == "true");
	this.child("fdbMarcarCadaX").setValue(eEjeX.attribute("MarcarCada"));
	this.child("fdbLimiteLabelX").setValue(eEjeX.attribute("LimiteLabel"));

	var eEjeY:FLDomElement = eGrafico.namedItem("EjeY").toElement();
	this.child("fdbMinY").setValue(eEjeY.attribute("Min"));
	this.child("fdbMaxY").setValue(parseFloat(eEjeY.attribute("Max")));
	this.child("fdbMargenLabelY").setValue(eEjeY.attribute("MargenLabels"));
	this.child("fdbMarcarLabelY").setValue(eEjeY.attribute("MarcarLabels") == "true");
	this.child("fdbMedidaY").setValue(eEjeY.attribute("Medida"));
	this.child("fdbMarcarCadaY").setValue(eEjeY.attribute("MarcarCada"));
	this.child("fdbColorMarcaY").setValue(eEjeY.attribute("ColorLineaMarca"));
	this.child("fdbEstiloMarcaY").setValue(eEjeY.attribute("EstiloLineaMarca"));

	this.iface.mostrarTablaColores();
	this.iface.bloqueoRefresco_ = false;
	
	this.iface.dibujarGraficoPix();

	return true;
}

function oficial_mostrarTablaColores()
{
	var util:FLUtil;

	var eGrafico:FLDomElement = this.iface.xmlGrafico_.firstChild().toElement();
	this.iface.tblColoresSec_.clear();
	var aSecuencias:Array = this.iface.cargarColoresSecuencias(eGrafico);
	var idColor:String, rgb:String, clrSecuencia:Color;
	this.iface.tblColoresSec_.setNumRows(0);
	for (var i:Number = 0; i < aSecuencias.length; i++) {
		this.iface.tblColoresSec_.insertRows(i);
		idColor = aSecuencias[i][0];
		debug("idColor " + idColor);
		debug("rgb " + aSecuencias[i][1]);
		if (idColor && idColor != "") {
			debug("idColor " + idColor);
			var nombre:String = util.sqlSelect("gf_colores", "nombre", "idcolor = " + idColor);
			this.iface.tblColoresSec_.setText(i, this.iface.CS_COLOR, nombre);
			rgb = util.sqlSelect("gf_colores", "rgb", "idcolor = " + idColor);
		} else {
			rgb = aSecuencias[i][1];
			var nombre:String = util.sqlSelect("gf_colores", "nombre", "rgb = '" + rgb + "'");
			this.iface.tblColoresSec_.setText(i, this.iface.CS_COLOR, nombre);
		}
		this.iface.tblColoresSec_.setText(i, this.iface.CS_RGB, rgb);
		clrSecuencia = flgraficos.iface.pub_dameColor(rgb);
		this.iface.tblColoresSec_.setCellBackgroundColor(i, this.iface.CS_MUESTRA, clrSecuencia);
		this.iface.tblColoresSec_.setText(i, this.iface.CS_MUESTRA, " ");
	}
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
	eGrafico.setAttribute("FormatoV", cursor.valueBuffer("formatov"));
	eGrafico.setAttribute("PosLeyenda", cursor.valueBuffer("posleyenda"));
	eGrafico.setAttribute("AltoLeyenda", cursor.valueBuffer("altoleyenda"));
	eGrafico.setAttribute("AnchoLeyenda", cursor.valueBuffer("ancholeyenda"));

	eGrafico.setAttribute("FontFamily", cursor.valueBuffer("familiafuente"));
	eGrafico.setAttribute("FontSize", cursor.valueBuffer("tamanofuente"));

	var eEjeX:FLDomElement = eGrafico.namedItem("EjeX").toElement();
	eEjeX.setAttribute("MargenLabels", cursor.valueBuffer("margenlabelx"));
	eEjeX.setAttribute("AnguloLabel", cursor.valueBuffer("angulolabelx"));
// 	eEjeX.setAttribute("MarcarLabels", cursor.valueBuffer("marcarlabelx") ? "true" : "false");
	eEjeX.setAttribute("MarcarCada", cursor.valueBuffer("marcarcadax"));
	eEjeX.setAttribute("LimiteLabel", cursor.valueBuffer("limitelabelx"));

	var eEjeY:FLDomElement = eGrafico.namedItem("EjeY").toElement();
	eEjeY.setAttribute("Min", cursor.valueBuffer("miny"));
	eEjeY.setAttribute("Max", (cursor.isNull("maxy") ? "" : cursor.valueBuffer("maxy")));
	eEjeY.setAttribute("MargenLabels", cursor.valueBuffer("margenlabely"));
	eEjeY.setAttribute("MarcarLabels", cursor.valueBuffer("marcarlabely") ? "true" : "false");
	eEjeY.setAttribute("Medida", cursor.valueBuffer("mediday"));
	eEjeY.setAttribute("MarcarCada", cursor.valueBuffer("marcarcaday"));
	eEjeY.setAttribute("ColorLineaMarca", cursor.valueBuffer("colormarcay"));
	eEjeY.setAttribute("EstiloLineaMarca", this.child("fdbEstiloMarcaY").value());

	var xmlSecuencias:FLDomElement = eGrafico.namedItem("Secuencias");
	if (xmlSecuencias) {
		eGrafico.removeChild(xmlSecuencias);
	}
	
	if(!cursor.valueBuffer("coloresdefecto")) {
		var eSecuencias:FLDomElement = this.iface.xmlGrafico_.createElement("Secuencias");
		eGrafico.appendChild(eSecuencias);

		var totalFilas:Number = this.iface.tblColoresSec_.numRows();
		var eSecuencia:FLDomElement;
		for (var fila:Number = 0; fila < totalFilas; fila++) {
			eSecuencia = this.iface.xmlGrafico_.createElement("Secuencia");;
			eSecuencias.appendChild(eSecuencia);
			eSecuencia.setAttribute("IdColor", this.iface.tblColoresSec_.text(fila, this.iface.CS_ID));
			eSecuencia.setAttribute("Color", this.iface.tblColoresSec_.text(fila, this.iface.CS_RGB));
		}
	}

	cursor.setValueBuffer("xml", this.iface.xmlGrafico_.toString(4));
	this.iface.dibujarGraficoPix();
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

function oficial_calcularMaxY(xmlDatos:FLDomDocument):Number
{
	var eGrafico:FLDomElement = xmlDatos.firstChild().toElement();
	var eValores:FLDomElement = eGrafico.namedItem("Valores").toElement();
	var xmlSecuencias:FLDomNodeList = eValores.elementsByTagName("Secuencia");
	if (!xmlSecuencias) {
		return false;
	}
	var max:Number = Number.MIN_VALUE;
	var valor:Number;
	var xmlValores:FLDomNodeList;
	for (var s:Number = 0; s < xmlSecuencias.length(); s++) {
		xmlValores = xmlSecuencias.item(s).toElement().elementsByTagName("Valor");
		if (!xmlValores) {
			continue;
		}
		for (var v:Number = 0; v < xmlValores.length(); v++) {
			valor = parseFloat(xmlValores.item(v).toElement().attribute("Y"));
			max = (valor > max ? valor : max);
		}
	}
	return max;
}

/** \D Sólo es posible guardar los valores por defecto del gráfico cuando se accede desde el módulo de gráficos
\end */
function oficial_habilitarControles()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	var id:String = cursor.valueBuffer("id");
// debug("id = " + id);
// 	if (!util.sqlSelect("gf_2dbarras", "id", "id = " + id) && cursor.modeAccess() != cursor.Insert) {
// 	if (id == 0) {
		this.child("tbnValoresDefecto").close();
// 	}
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
		case "colormarcay": {
			flgraficos.iface.pub_colorearLabel(this.child("lblColorMarcaY"), cursor.valueBuffer(fN));
			this.iface.renovarTimer();
			break;
		}
		case "coloresdefecto": {
			this.iface.activarDesactivarColoresDefecto();
			break;
		}
		default: {
			this.iface.renovarTimer();
		}
	}
}

function oficial_activarDesactivarColoresDefecto()
{
	var util:FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	if(cursor.valueBuffer("coloresdefecto")) {
		this.child("tbnCrearColorSec").setDisabled(true);
		this.child("tbnCambiarColorSec").setDisabled(true);
		this.child("tbnSubirColorSec").setDisabled(true);
		this.child("tbnBajarColorSec").setDisabled(true);
		this.child("tbnBorrarColorSec").setDisabled(true);		
	}
	else{
	
		this.child("tbnCrearColorSec").setDisabled(false);
		this.child("tbnCambiarColorSec").setDisabled(false);
		this.child("tbnSubirColorSec").setDisabled(false);
		this.child("tbnBajarColorSec").setDisabled(false);
		this.child("tbnBorrarColorSec").setDisabled(false);		
	}
	
	this.iface.refrescarGrafico();
	this.iface.mostrarTablaColores();
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
	flgraficos.iface.pub_colorearLabel(this.child("lblColorMarcaY"), cursor.valueBuffer("colormarcay"));
}

function oficial_tbnCrearColorSec_clicked()
{
	var f:Object = new FLFormSearchDB("gf_colores");
	f.setMainWidget();
	var idColor:String = f.exec("idcolor");
	if (!idColor) {
		return;
	}
	if (!this.iface.crearColorSec(idColor)) {
		return false;
	}
	this.iface.refrescarGrafico();
}

function oficial_crearColorSec(idColor:String):Boolean
{
	var util:FLUtil = new FLUtil;
	var fila:Number = this.iface.tblColoresSec_.numRows();
	this.iface.tblColoresSec_.insertRows(fila);
	if (!this.iface.cambiarColorSec(fila, idColor)) {
		return false;
	}
	return true;
}

function oficial_tbnCambiarColorSec_clicked()
{
	var fila:Number = this.iface.tblColoresSec_.currentRow();
	if (fila == undefined) {
		return false;
	}
	var f:Object = new FLFormSearchDB("gf_colores");
	f.setMainWidget();
	var idColor:String = f.exec("idcolor");
	if (!idColor) {
		return false;
	}
	if (!this.iface.cambiarColorSec(fila, idColor)) {
		return false;
	}
	this.iface.refrescarGrafico();
}

function oficial_tbnBorrarColorSec_clicked()
{
	var fila:Number = this.iface.tblColoresSec_.currentRow();
	if (fila == undefined) {
		return false;
	}
	this.iface.tblColoresSec_.removeRow(fila);
	var numFilas:Number = this.iface.tblColoresSec_.numRows();
	var clrFila:Color;
	for (var fila:Number = 0; fila < numFilas; fila++) {
		clrFila = flgraficos.iface.pub_dameColor(this.iface.tblColoresSec_.text(fila, this.iface.CS_RGB));
		this.iface.tblColoresSec_.setCellBackgroundColor(fila, this.iface.CS_MUESTRA, clrFila);
	}
	this.iface.tblColoresSec_.repaintContents();
	this.iface.refrescarGrafico();
}


function oficial_tbnSubirColorSec_clicked()
{
	var fila:Number = this.iface.tblColoresSec_.currentRow();
	if (fila == undefined) {
		return false;
	}
	if (fila == 0) {
		return false;
	}
	if (!this.iface.moverColorSec(fila, -1)) {
		return false;
	}
	this.iface.refrescarGrafico();
}

function oficial_tbnBajarColorSec_clicked()
{
	var fila:Number = this.iface.tblColoresSec_.currentRow();
	if (fila == undefined) {
		return false;
	}
	if (fila == this.iface.tblColoresSec_.numRows() - 1) {
		return false;
	}
	if (!this.iface.moverColorSec(fila, 1)) {
		return false;
	}
	this.iface.refrescarGrafico();
}

function oficial_moverColorSec(fila1:Number, direccion:Number):Boolean
{
	var fila2:Number = fila1 + direccion;
	var valor1:String, valor2:String;
// 	valor1 = this.iface.tblColoresSec_.text(fila1, this.iface.CS_ID);
// 	valor2 = this.iface.tblColoresSec_.text(fila2, this.iface.CS_ID);
// 	this.iface.tblColoresSec_.setText(fila1, this.iface.CS_ID, valor2);
// 	this.iface.tblColoresSec_.setText(fila2, this.iface.CS_ID, valor1);
// 
// 	valor1 = this.iface.tblColoresSec_.text(fila1, this.iface.CS_COLOR);
// 	valor2 = this.iface.tblColoresSec_.text(fila2, this.iface.CS_COLOR);
// 	this.iface.tblColoresSec_.setText(fila1, this.iface.CS_COLOR, valor2);
// 	this.iface.tblColoresSec_.setText(fila2, this.iface.CS_COLOR, valor1);
// 
	this.iface.tblColoresSec_.swapRows(fila1, fila2);
	
	valor1 = this.iface.tblColoresSec_.text(fila1, this.iface.CS_RGB);
	var color1:Color = flgraficos.iface.pub_dameColor(valor1);
	this.iface.tblColoresSec_.setCellBackgroundColor(fila1, this.iface.CS_MUESTRA, color1);
	
	valor2 = this.iface.tblColoresSec_.text(fila2, this.iface.CS_RGB);
	var color2:Color = flgraficos.iface.pub_dameColor(valor2);
	this.iface.tblColoresSec_.setCellBackgroundColor(fila2, this.iface.CS_MUESTRA, color2);

// 	this.iface.tblColoresSec_.setText(fila1, this.iface.CS_RGB, valor2);
// 	this.iface.tblColoresSec_.setText(fila2, this.iface.CS_RGB, valor1);
	
	
// 	this.iface.tblColoresSec_.selectRow(fila2);
	this.iface.tblColoresSec_.repaintContents();
	
	return true;
}

function oficial_cambiarColorSec(fila:Number, idColor:String):Boolean
{
	var util:FLUtil = new FLUtil;
	this.iface.tblColoresSec_.setText(fila, this.iface.CS_ID, idColor);
	this.iface.tblColoresSec_.setText(fila, this.iface.CS_COLOR, util.sqlSelect("gf_colores", "nombre", "idcolor = " + idColor));
	var rgb:String = util.sqlSelect("gf_colores", "rgb", "idcolor = " + idColor);
	this.iface.tblColoresSec_.setText(fila, this.iface.CS_RGB, rgb);
	var clrSecuencia:Color = flgraficos.iface.pub_dameColor(rgb);
	this.iface.tblColoresSec_.setCellBackgroundColor(fila, this.iface.CS_MUESTRA, clrSecuencia);
	this.iface.tblColoresSec_.setText(fila, this.iface.CS_MUESTRA, " ");
	this.iface.tblColoresSec_.repaintContents();
	return true;
}

function oficial_cargarColoresSecuencias(eGrafico:FLDomElement):Array
{
	var util:FLUtil;
// 	var aColoresDefecto:Array = [["", "0, 0, 200"], ["", "0, 200, 0"], ["", "200, 0, 0"], ["", "200, 200, 0"], ["", "200, 0, 200"], ["", "0, 200, 200"], ["", "100, 100, 200"], ["", "100, 200, 100"], ["", "200, 100, 100"], ["", "100, 100, 100"]];
// 	var totalColores:Number = aColoresDefecto.length;
	var totalColores:Number = parseInt(util.sqlSelect("gf_colores","count(idcolor)","1=1"));
	
	var aColores:Array = [];
	var totalSecuencias:Number;
	var xmlSecuencias:FLDomNodeList;
	var nodoSecuencias:FLDomNode = eGrafico.namedItem("Secuencias");
	if (nodoSecuencias) {
		xmlSecuencias = nodoSecuencias.toElement().elementsByTagName("Secuencia");
		totalSecuencias = (xmlSecuencias ? xmlSecuencias.count() : 0);
	} else {
		totalSecuencias = 0;
	}
	
	var eValores:FLDomElement = eGrafico.namedItem("Valores").toElement();
	var xmlSecValores:FLDomNodeList = eValores.elementsByTagName("Secuencia");
	var totalSecuenciasVal:Number = (xmlSecValores ? xmlSecValores.count() : 1);
	var eSecuencia:FLDomElement;
	var eSecuencia:FLDomElement, iSec:Number = 0;
	for (iSec = 0; iSec < totalSecuenciasVal; iSec++) {
		aColores[iSec] = [];
		if (iSec >= totalSecuencias) {
			aColores[iSec][0] = "";
			var color:String = "";
			var idColor:Number = util.sqlSelect("gf_colores","idcolor","orden = " + (iSec+1) % totalColores);
			if(!idColor) {
				idColor = 0;
				color = "255,255,255";
			}
			else
				color = util.sqlSelect("gf_colores","rgb","idcolor = " + idColor);
			
			aColores[iSec][0] = idColor;
			aColores[iSec][1] = color/*aColoresDefecto[iSec % totalColores][1]*/;
		} else {
			eSecuencia = xmlSecuencias.item(iSec).toElement();
			aColores[iSec][0] = eSecuencia.attribute("IdColor");
			aColores[iSec][1] = eSecuencia.attribute("Color");
		}
	}
	return aColores;
}

function oficial_tblColoresSec_doubleClicked(fila:Number, col:Number)
{
	if(this.cursor().valueBuffer("coloresdefecto"))
		return;
		
	this.iface.tbnCambiarColorSec_clicked();
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
