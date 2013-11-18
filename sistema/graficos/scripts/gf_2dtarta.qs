/***************************************************************************
                 gf_2dtarta.qs  -  description
                             -------------------
    begin                : mar jun 15 2010
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
	function calcularAlturaSinSolape(rectTexto:Rect,rectAnt:Rect,operacion:String):Number {
		return this.ctx.oficial_calcularAlturaSinSolape(rectTexto,rectAnt,operacion);
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
	function mostrarTablaColores() {
		return this.ctx.oficial_mostrarTablaColores();
	}
	function redondearEjeY2dTarta(valor:Number):Number {
		return this.ctx.oficial_redondearEjeY2dTarta(valor);
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
	function pub_dibujarGrafico(xmlDatos:FLDomDocument, marco:Rect):Picture {
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
	connect(this, "formReady()", this, "iface.iniciarValores()");
	
	
	this.iface.configurarTablas();
// 	this.iface.iniciarValores();
	this.iface.habilitarControles();
	var util:FLUtil = new FLUtil;
}

/**
\C Los datos de la empresa son únicos, por tanto formulario de no presenta los botones de navegación por registros.
\end

\D La gestión del formulario se hace de forma manual mediante el objeto f (FLFormSearchDB)
\end
\end */
function interna_main()
{
	var f:Object = new FLFormSearchDB("gf_2dtarta");
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
// debug("XXXXXXXXXXX\noficial_dibujarGrafico: " + xmlDatos.toString(4));
	var pic:Picture = new Picture;
	var clr = new Color();
	var clrTitulo = new Color();
	var clfTitulo = new Font();
	var clf = new Font();
	pic.begin();
	

// 	var moverMarco:Boolean = true;
// 	if (moverMarco) {
// 		pic.savePainter();
// 		pic.translate(50, 50);
// 	}

	var moverMarco:Boolean = marco && (marco.x != 0 || marco.y != 0);
	if (moverMarco) {
		pic.savePainter();
		pic.translate(marco.x, marco.y);
	}
	
	var eGrafico:FLDomElement = xmlDatos.firstChild().toElement();
	var eValores:FLDomElement = eGrafico.namedItem("Valores").toElement();
	var xmlSecuencias:FLDomNodeList = eValores.elementsByTagName("Secuencia");
	if(!xmlSecuencias)
		return pic;
	
	var numSecuencias:Number = parseInt(xmlSecuencias.length());
	var anchoAbs:Number = parseInt(eGrafico.attribute("Ancho"));
	if(anchoAbs == 0)
		return pic;

	var altoAbs:Number = parseInt(eGrafico.attribute("Alto"));
	if(altoAbs == 0)
		return pic;
	
	var mostrarFlechas:Boolean = (eGrafico.attribute("Flechas") == "true");
	var mostrarCircunferencia:Boolean = (eGrafico.attribute("Circunferencia") == "true");
	


	var altoTitulo:Number = 0;
	var fontFamilyTitulo:String = eGrafico.attribute("FontFamilyTitulo");
	var fontSizeTitulo:Number = parseInt(eGrafico.attribute("FontSizeTitulo"));
	altoTitulo = fontSizeTitulo+(fontSizeTitulo*80/100);
	var anchoTitulo:Number = 0;
	if(!fontSizeTitulo)
		altoTitulo = 0;
	altoAbs = altoAbs - altoTitulo;
		
////////////////////////////////////////////////
	var factor:Number = anchoAbs/altoAbs;
	var numSecuenciasY:Number;
	var numSecuenciasX:Number = Math.sqrt(numSecuencias*factor);
	var numSecuenciasX1:Number = Math.ceil(numSecuenciasX);
	var numSecuenciasX2:Number = Math.floor(numSecuenciasX);
	
	if (numSecuenciasX == 0)
		return pic;
	
	var numSecuenciasY1:Number = numSecuencias / numSecuenciasX1;
	var numSecuenciasY2:Number = numSecuencias / numSecuenciasX2;
	numSecuenciasY1 = Math.floor(numSecuenciasY1);
	numSecuenciasY2 = Math.floor(numSecuenciasY2);
	if ((numSecuenciasY1 * numSecuenciasX1) < numSecuencias) {
		numSecuenciasY1++;
	}
	if ((numSecuenciasY2 * numSecuenciasX2) < numSecuencias) {
		numSecuenciasY2++;
	}

	if(numSecuenciasY == 0)
		numSecuenciasY = 1;

	var ancho1:Number = anchoAbs/numSecuenciasX1;
	var alto1:Number = altoAbs/numSecuenciasY1;

// 	if(ancho1 != alto1) {
// 		if(ancho1 < alto1)
// 			alto1 = ancho1;
// 		else
// 			ancho1 = alto1;
// 	}

	var ancho2:Number = anchoAbs/numSecuenciasX2;
	var alto2:Number = altoAbs/numSecuenciasY2;
	
// 	if(ancho2 != alto2) {
// 		if(ancho2 < alto2)
// 			alto2 = ancho2;
// 		else
// 			ancho2 = alto2;
// 	}

	var ancho:Number;
	var alto:Number;

	if(ancho1 > ancho2) {
		ancho = ancho1;
		alto = alto1;
		numSecuenciasX = numSecuenciasX1;
		numSecuenciasY = numSecuenciasY1;
	}
	else {
		ancho = ancho2;
		alto = alto2;
		numSecuenciasX = numSecuenciasX2;
		numSecuenciasY = numSecuenciasY2;
	}
	
	var aSecuencias:Array = this.iface.cargarColoresSecuencias(eGrafico);
	/////////// PINTAR TÍTULO ///////////////////////////////////////
	clfTitulo = flgraficos.iface.pub_dameFuente(fontFamilyTitulo, fontSizeTitulo); // FUENTE DEL TÍTULO
	var colorTitulo:String = eGrafico.attribute("ColorTitulo");
	if (!colorTitulo || colorTitulo == "") {
		colorTitulo = "0,0,0";
	}
	clrTitulo = flgraficos.iface.pub_dameColor(colorTitulo);
	
	var titulo:String = eGrafico.attribute("Titulo");
// 	clrTitulo.setRgb( 0, 0, 0 );
	pic.setPen(clrTitulo, 1);
	pic.setFont(clfTitulo); // pic.DotLine );
	
	try {
		pic.drawText(0, 0,  anchoAbs, altoTitulo, pic.AlignHCenter | pic.AlignVCenter, titulo, -1);
	} catch (e) {
		pic.drawText(0, 0,  anchoAbs, altoTitulo, 0, titulo, -1);
	}
	
////////////////////////////////////////////////////	

	var marcoG:Boolean = (eGrafico.attribute("Marco") == "true");
	
	var margenSuperior:Number = parseInt(parseInt(eGrafico.attribute("MargenSuperior")));
	if (isNaN(margenSuperior)) { margenSuperior = 0; }
	var margenInferior:Number = parseInt(parseInt(eGrafico.attribute("MargenInferior")));
	if (isNaN(margenInferior)) { margenInferior = 0; }
	var margenIzquierdo:Number = parseInt(parseInt(eGrafico.attribute("MargenIzquierdo")));
	if (isNaN(margenIzquierdo)) { margenIzquierdo = 0; }
	var margenDerecho:Number = parseInt(parseInt(eGrafico.attribute("MargenDerecho")));
	if (isNaN(margenDerecho)) { margenDerecho = 0; }

	var mostrarValor:Boolean = (eGrafico.attribute("Valor") == "true");
	var mostrarPorcentaje:Boolean = (eGrafico.attribute("Porcentaje") == "true");
	var mostrarNombre:Boolean = (eGrafico.attribute("Nombre") == "true");
	
	var formatoValor:String = eGrafico.attribute("FormatoV");
	if (!formatoValor || formatoValor == "") {
		formatoValor = "Entero";
	}
	
	var margenLabel:Number = parseInt(eGrafico.attribute("MargenLabel"));
	if (isNaN(margenLabel)) { margenLabel= 0; }
	

	var fontFamily:String = eGrafico.attribute("FontFamily");
	var fontSize:Number = parseFloat(eGrafico.attribute("FontSize"));
	var clf = flgraficos.iface.pub_dameFuente(fontFamily, fontSize); // FUENTE DE LAS ETIQUETAS EN LOS EJES
	
	var altoLabel:Number = parseInt(fontSize) + 5;
		
	var offGraficoX:Number = margenIzquierdo;
	if(mostrarValor || mostrarPorcentaje || mostrarNombre)
		offGraficoX += margenLabel;
		
	var offGraficoY:Number = margenSuperior + parseInt(altoLabel);
	if(mostrarValor || mostrarPorcentaje || mostrarNombre)
		offGraficoY += margenLabel;
	
	var anchoT:Number;
	var altoT:Number;
	if(mostrarValor || mostrarPorcentaje || mostrarNombre) {
		 anchoT= ancho - margenIzquierdo - margenDerecho - (margenLabel*2);
		altoT = alto - margenSuperior - margenInferior - (margenLabel*2)-altoLabel;
	}
	else {
		anchoT= ancho - margenIzquierdo - margenDerecho;
		altoT = alto - margenSuperior - margenInferior-altoLabel;
	}
	
	if(mostrarCircunferencia) {
		if(anchoT < altoT)
			altoT = anchoT;
		else
			anchoT = altoT;
	}

	var puntoInicioX:Number = 0;
	var puntoInicioY:Number = 0;
	var puntoTransladoX:Number;
	var puntoTransladoY:Number;
	var nodoSec:FLDomNode;
	var nodoValor:FLDomNode;
	var iSec:Number = -1;
	var valor:Array;
	var color:Array;
	var clrSeccion = new Color();
	var colores:Array;
	var label:Array;
	anchoTitulo = ancho;
	for (nodoSec = eValores.namedItem("Secuencia"); nodoSec; nodoSec = nodoSec.nextSibling()) {
		iSec++;
	
// 		if(iSec > 1)
// 			pic.restorePainter();
		
		if(iSec > 0) {
			if(iSec < numSecuenciasX){
				puntoTransladoX= puntoInicioX + (ancho*iSec);
				puntoTransladoY = puntoInicioY;
				anchoTitulo += ancho;
			}
			else {
				var fila:Number = (iSec+1)/numSecuenciasX;
				fila = Math.ceil(fila);
				var columna:Number = iSec - (numSecuenciasX*(fila-1));
				puntoTransladoX= puntoInicioX + (ancho*columna);
				puntoTransladoY = puntoInicioY + (alto*(fila-1));
			}	
		}
		else {
			puntoTransladoX= puntoInicioX;
			puntoTransladoY = puntoInicioY + altoTitulo;
		}
		
		pic.savePainter();
		pic.translate(puntoTransladoX,puntoTransladoY);

		pic.setPen( clr, 1); // pic.DotLine );
	/// Marco
		pic.setFont( clf );
		if (marcoG) {
			pic.drawLine(0, 0, ancho, 0);
			pic.drawLine(0, alto, ancho, alto);
			pic.drawLine(0, 0, 0, alto);
			pic.drawLine(ancho, 0, ancho, alto);
		}	

	/// Título
		var tituloValor:String = nodoSec.toElement().attribute("Leyenda")
		clr.setRgb( 0, 0, 0 );
		pic.setPen( clr, 1); // pic.DotLine );
		try {
			pic.drawText(0, 0,  ancho, altoLabel, pic.AlignHCenter, tituloValor, -1);
		} catch (e) {
			pic.drawText(0, 0,  ancho, altoLabel, 0, tituloValor, -1);
		}
		
	/// Sectores
		var angInicio:Number = 270*16;
		var iValores:Number = 0;
		var sumValores:Number = 0;
		for (nodoValor = nodoSec.namedItem("Valor"); nodoValor; nodoValor = nodoValor.nextSibling()) {
			valor[iValores] = parseFloat(nodoValor.toElement().attribute("Valor"));
			color[iValores] = aSecuencias[iValores % aSecuencias.length][1];
			label[iValores] = nodoValor.toElement().attribute("Label");
	
			sumValores += valor[iValores];

			iValores++;
		}
		
// 		pic.drawPie(offGraficoX,offGraficoY,altoT,anchoT,0,90*16);
		
		var anguloInicio:Number = -90*16;
		var anguloTotal:Number = 360*16;
		var anguloSeccion:Number;
		var labelSeccion:String;
		var arraySector1:Array = []; // Inferior derecho
		var arraySector2:Array = []; // Superior derecho
		var arraySector3:Array = []; // Superior izquierdo
		var arraySector4:Array = []; // Inferior izquierdo
		
		for(var i=0;i<iValores;i++) {
			clrSeccion = new Color();
			colores = color[i].split(",");
			clrSeccion.setRgb(colores[0],colores[1],colores[2])
			pic.setBrush(clrSeccion);
			
			anguloSeccion = (anguloTotal * valor[i])/sumValores;
			if(!anguloSeccion)
				anguloSeccion = 0;

			pic.drawPie(offGraficoX,offGraficoY,anchoT,altoT,anguloInicio,anguloSeccion);
			
			if(margenLabel > 0) {
				var centroX:Number = offGraficoX + anchoT / 2;
				var centroY:Number = offGraficoY + altoT / 2;
				var anguloM:Number = (anguloInicio + anguloSeccion / 2)/16;
				var radianes = anguloM*Math.PI/180;
				
				var altoD = altoT;
				var anchoD = anchoT
				var xD = centroX + anchoD / 2* Math.cos(radianes);
				var yD = centroY - altoD / 2 * Math.sin(radianes);
				
				var altoF = altoT+altoT*15/100;
				var anchoF = anchoT +altoT*15/100
				var xF = centroX + anchoF / 2* Math.cos(radianes);
				var yF = centroY - altoF / 2 * Math.sin(radianes);
				
	// 			pic.drawLine(centroX, centroY, centroX + anchoT / 2* Math.cos(radianes), centroY - altoT / 2 * Math.sin(radianes));
// 				if(mostrarFlechas && marcarLabel)
// 					pic.drawLine(xD,yD,xF,yF);

				if(mostrarValor || mostrarPorcentaje || mostrarNombre) {
					labelSeccion = "";
					if(mostrarNombre) {
						if(label[i]) {
							if(labelSeccion != "")
								labelSeccion += " ";
							labelSeccion += label[i];
						}
					}		
					if(mostrarValor)  {
						var valorAux:Number;
						if(!valor[i])
							valor[i] = 0;
						valorAux = flgraficos.iface.pub_formatearValor(valor[i], formatoValor);
						if(labelSeccion != "")
							labelSeccion += " ";
						labelSeccion += valorAux.toString();
					}
					if(mostrarPorcentaje) {
						var porcentaje:Number = parseInt((valor[i]*100)/sumValores);
						if(!porcentaje)
							porcentaje = 0;
						if(labelSeccion != "")
							labelSeccion += " ";
						labelSeccion += porcentaje.toString() + "%";
					}
				}
				
				if(anguloM <0 ) { // 1
					var pos:Number = arraySector1.length;
					arraySector1[pos] = []
					arraySector1[pos]["x1linea"] = xD;
					arraySector1[pos]["y1linea"] = yD;
					arraySector1[pos]["x2linea"] = xF;
					arraySector1[pos]["y2linea"] = yF;
					arraySector1[pos]["x"] = xF;
					arraySector1[pos]["y"] = yF;
					arraySector1[pos]["ancho"] = ancho-xF;
					arraySector1[pos]["texto"] = labelSeccion;
				}
				else {
					if(anguloM <= 90) { // 2
						var pos:Number = arraySector2.length;
						arraySector2[pos] = []
						arraySector2[pos]["x1linea"] = xD;
						arraySector2[pos]["y1linea"] = yD;
						arraySector2[pos]["x2linea"] = xF;
						arraySector2[pos]["y2linea"] = yF;
						arraySector2[pos]["x"] = xF;
						arraySector2[pos]["y"] = yF-altoLabel;
						arraySector2[pos]["ancho"] = ancho-xF;
						arraySector2[pos]["texto"] = labelSeccion;
					}
					else {
						if(anguloM <= 180) { // 3
							var pos:Number = arraySector3.length;
							arraySector3[pos] = []
							arraySector3[pos]["x1linea"] = xD;
							arraySector3[pos]["y1linea"] = yD;
							arraySector3[pos]["x2linea"] = xF;
							arraySector3[pos]["y2linea"] = yF;
							arraySector3[pos]["x"] = 0;
							arraySector3[pos]["y"] = yF-altoLabel;
							arraySector3[pos]["ancho"] = xF;
							arraySector3[pos]["texto"] = labelSeccion;
						}
						else { // 4
							var pos:Number = arraySector4.length;
							arraySector4[pos] = []
							arraySector4[pos]["x1linea"] = xD;
							arraySector4[pos]["y1linea"] = yD;
							arraySector4[pos]["x2linea"] = xF;
							arraySector4[pos]["y2linea"] = yF;
							arraySector4[pos]["x"] = 0;
							arraySector4[pos]["y"] = yF;
							arraySector4[pos]["ancho"] = xF;
							arraySector4[pos]["texto"] = labelSeccion;
						}
					}
				}
// 				if(anguloM <0 ) { // 1
// 					try {
// 						pic.drawText(xF, yF+altoLabel,   ancho-xF, altoLabel, pic.AligLeft | pic.AlignVCenter, labelSeccion, -1);
// 					} catch (e) {
// 						pic.drawText(xF, yF+altoLabel, labelSeccion);
// 					}
// 				}
// 				else {
// 					if(anguloM <= 90) { // 2
// 						try {
// 							pic.drawText(xF, yF-altoLabel,  ancho-xF, altoLabel, pic.AlignLeft | pic.AlignVCenter, labelSeccion, -1);
// 						} catch (e) {
// 							pic.drawText(xF, yF, labelSeccion);
// 						}
// 					}
// 					else {
// 						if(anguloM <= 180) { // 3
// 							try {
// 								pic.drawText(0, yF-altoLabel,  xF, altoLabel, pic.AlignRight | pic.AlignVCenter, labelSeccion, -1);
// 							} catch (e) {
// 								pic.drawText(xF-margenLabel, yF, labelSeccion);
// 							}
// 						}
// 						else { // 4
// 							try {
// 								pic.drawText(0, yF,  xF, altoLabel, pic.AlignRight | pic.AlignVCenter, labelSeccion, -1);
// 							} catch (e) {
// 								pic.drawText(xF-margenLabel, yF+altoLabel, labelSeccion);
// 							}
// 						}
// 					}
// 				}
			}
			anguloInicio += anguloSeccion;
		}
		
		var y:Number;
		var rectAnt:Rect;
		var rectAntTmp:Rect;
		var rectTexto:Rect;
		var heightTexto:Number;
////////////////////////////////////////// PINTANDO SECCION 1 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		if(arraySector1.length>0) {
			var i=arraySector1.length-1;
			y = arraySector1[i]["y"];
			rectAnt = pic.boundingRect(arraySector1[i]["x"],y,arraySector1[i]["ancho"],altoLabel, pic.AlignLeft | pic.AlignVCenter,arraySector1[i]["texto"], -1);	
			rectAntTmp = rectAnt;
			try {
				pic.drawText(arraySector1[i]["x"], y,  arraySector1[i]["ancho"], altoLabel,  pic.AlignLeft | pic.AlignVCenter, arraySector1[i]["texto"], -1);
			} catch (e) {
				pic.drawText(arraySector1[i]["x"], y, arraySector1[i]["texto"]);
			}
			
			if(mostrarFlechas && (mostrarValor || mostrarPorcentaje || mostrarNombre))
				pic.drawLine(arraySector1[i]["x1linea"],arraySector1[i]["y1linea"],arraySector1[i]["x2linea"],y);
			
			for(var i=arraySector1.length-2;i>=0;i--) {
				if(arraySector1[i]["y"] > rectAnt.y)
					y = arraySector1[i]["y"];
				rectTexto = pic.boundingRect(arraySector1[i]["x"],y,arraySector1[i]["ancho"],altoLabel,pic.AlignLeft | pic.AlignVCenter,arraySector1[i]["texto"],-1);
				heightTexto =  rectTexto.height;
				if(((rectTexto.y >= rectAnt.y) && (rectTexto.y <= (rectAnt.y+rectAnt.height))) && ((rectTexto.x+rectTexto.width) >= rectAnt.x)) {
					y = rectAnt.y + rectAnt.height + 1;
					rectTexto.y = y;
					rectTexto.height = heightTexto;
				}

				try {
					pic.drawText(arraySector1[i]["x"], y,  arraySector1[i]["ancho"], altoLabel,  pic.AlignLeft | pic.AlignVCenter, arraySector1[i]["texto"], -1);
				} catch (e) {
					pic.drawText(arraySector1[i]["x"], y, arraySector1[i]["texto"]);
				}
				
				if(mostrarFlechas && (mostrarValor || mostrarPorcentaje || mostrarNombre))
					pic.drawLine(arraySector1[i]["x1linea"],arraySector1[i]["y1linea"],arraySector1[i]["x2linea"],y);

				rectAnt.y = rectTexto.y;
				rectAnt.x = rectTexto.x;
				rectAnt.height = rectTexto.height;
				rectAnt.width = rectTexto.width;
			}
		}
		
////////////////////////////////////////// PINTANDO SECCION 2 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		rectAnt = rectAntTmp;
		for(var i=0;i<arraySector2.length;i++) {
			if(i==0) {
				y = arraySector2[i]["y"];
			}
			else {
				if(arraySector2[i]["y"] < rectAnt.y)
					y = arraySector2[i]["y"];
			}
			
			rectTexto = pic.boundingRect(arraySector2[i]["x"],y,arraySector2[i]["ancho"],altoLabel,pic.AlignLeft | pic.AlignVCenter,arraySector2[i]["texto"],-1);
			heightTexto =  rectTexto.height;
			if((((rectTexto.y + rectTexto.height) <= (rectAnt.y + rectAnt.height)) && ((rectTexto.y + rectTexto.height) >= rectAnt.y))  && ((rectTexto.x+rectTexto.width) >= rectAnt.x)) {
				y = rectAnt.y - rectAnt.height - 1;
				rectTexto.y = y;
				rectTexto.height = heightTexto;
			}
			
			try {
				pic.drawText(arraySector2[i]["x"], y,  arraySector2[i]["ancho"], altoLabel,  pic.AlignLeft | pic.AlignVCenter, arraySector2[i]["texto"], -1);
			} catch (e) {
				pic.drawText(arraySector2[i]["x"], y, arraySector2[i]["texto"]);
			}
			
			if(mostrarFlechas && (mostrarValor || mostrarPorcentaje || mostrarNombre))
				pic.drawLine(arraySector2[i]["x1linea"],arraySector2[i]["y1linea"],arraySector2[i]["x2linea"],y+altoLabel);

			rectAnt.y = rectTexto.y;
			rectAnt.x = rectTexto.x;
			rectAnt.height = rectTexto.height;
			rectAnt.width = rectTexto.width;
		}
		
////////////////////////////////////////// PINTANDO SECCION 3 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		if(arraySector3.length > 0) {
			var i=arraySector3.length-1;
			y = arraySector3[i]["y"];
			rectAnt = pic.boundingRect(arraySector3[i]["x"],y,arraySector3[i]["ancho"],altoLabel, pic.AlignRight | pic.AlignVCenter, arraySector3[i]["texto"], -1);	
			rectAntTmp = rectAnt;
			try {
				pic.drawText(arraySector3[i]["x"], y,  arraySector3[i]["ancho"], altoLabel,  pic.AlignRight | pic.AlignVCenter, arraySector3[i]["texto"], -1);
			} catch (e) {
				pic.drawText(arraySector3[i]["x"], y, arraySector3[i]["texto"]);
			}
			
			if(mostrarFlechas && (mostrarValor || mostrarPorcentaje || mostrarNombre))
				pic.drawLine(arraySector3[i]["x1linea"],arraySector3[i]["y1linea"],arraySector3[i]["x2linea"],y+altoLabel);
			
			for(var i=arraySector3.length-2;i>=0;i--) {
				if(arraySector3[i]["y"] < rectAnt.y)
					y = arraySector3[i]["y"];
				
				rectTexto = pic.boundingRect(arraySector3[i]["x"],y,arraySector3[i]["ancho"],altoLabel, pic.AlignRight | pic.AlignVCenter,arraySector3[i]["texto"],-1);
				heightTexto =  rectTexto.height;
				if((((rectTexto.y + rectTexto.height) <= (rectAnt.y + rectAnt.height)) && ((rectTexto.y + rectTexto.height) >= rectAnt.y)) && (rectTexto.x < (rectAnt.x + rectAnt.width))) {
					y = rectAnt.y - rectAnt.height - 1;
					rectTexto.y = y;
					rectTexto.height = heightTexto;
				}
				
				try {
					pic.drawText(arraySector3[i]["x"], y,  arraySector3[i]["ancho"], altoLabel,  pic.AlignRight | pic.AlignVCenter, arraySector3[i]["texto"], -1);
				} catch (e) {
					pic.drawText(arraySector3[i]["x"], y, arraySector3[i]["texto"]);
				}
				
				if(mostrarFlechas && (mostrarValor || mostrarPorcentaje || mostrarNombre))
					pic.drawLine(arraySector3[i]["x1linea"],arraySector3[i]["y1linea"],arraySector3[i]["x2linea"],y+altoLabel);

				rectAnt.y = rectTexto.y;
				rectAnt.x = rectTexto.x;
				rectAnt.height = rectTexto.height;
				rectAnt.width = rectTexto.width;
			}
		}
	
////////////////////////////////////////// PINTANDO SECCION 4 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		rectAnt = rectAntTmp;
		for(var i=0;i<arraySector4.length;i++) {
			if(i==0)
				y = arraySector4[i]["y"];
			else {
				if(arraySector4[i]["y"] > rectAnt.y)
					y = arraySector4[i]["y"];
			}
			
			rectTexto = pic.boundingRect(arraySector4[i]["x"],y,arraySector4[i]["ancho"],altoLabel,pic.AlignRight | pic.AlignVCenter,arraySector4[i]["texto"],-1);
			heightTexto =  rectTexto.height;
// 			pic.drawRect(rectTexto);
			debug("((rectTexto.y <= (rectAnt.y + rectAnt.height)) && (rectTexto.y >= rectAnt.y)) && (rectTexto.x < (rectAnt.x + rectAnt.width))");
			debug("((" + rectTexto.y + " <= (" + rectAnt.y + " + " + rectAnt.height + ")) && (" + rectTexto.y + " >= " + rectAnt.y + ")) && (" + rectTexto.x + " < (" + rectAnt.x + " + " + rectAnt.width + "))");
			if (((rectTexto.y <= (rectAnt.y + rectAnt.height)) && (rectTexto.y >= rectAnt.y)) && (rectTexto.x < (rectAnt.x + rectAnt.width))) {
				debug("cambia");
				y = rectAnt.y + rectAnt.height + 1;
				rectTexto.y = y;
				rectTexto.height = heightTexto;
			}
			else {
				debug("no cambia");
			}
			try {
				pic.drawText(arraySector4[i]["x"], y,  arraySector4[i]["ancho"], altoLabel,  pic.AlignRight | pic.AlignVCenter, arraySector4[i]["texto"], -1);
			} catch (e) {
				pic.drawText(arraySector4[i]["x"], y, arraySector4[i]["texto"]);
			}
			
			if(mostrarFlechas && (mostrarValor || mostrarPorcentaje || mostrarNombre))
				pic.drawLine(arraySector4[i]["x1linea"],arraySector4[i]["y1linea"],arraySector4[i]["x2linea"],y);

			rectAnt.y = rectTexto.y;
			rectAnt.x = rectTexto.x;
			rectAnt.height = rectTexto.height;
			rectAnt.width = rectTexto.width;
		}
		
		if(iSec > 0)
			pic.restorePainter();
	}
	
	if (moverMarco) {
		pic.restorePainter();
	}
	
	return pic;
}

function oficial_calcularAlturaSinSolape(rectTexto:Rect,rectAnt:Rect,operacion:String):Number
{
	var y:Number = rectTexto.y;
	
	
	
	return y;
}

function oficial_tbnValoresDefecto_clicked()
{

	var util:FLUtil = new FLUtil;

	var res:Number = MessageBox.warning(util.translate("scripts", "Va a restaurar los valores por defecto del gráfico.\n¿Está seguro?"), MessageBox.Yes, MessageBox.No);
	if (res != MessageBox.Yes) {
		return;
	}
	
	this.iface.restaurarValoresDefecto();
	this.iface.cargarCampos();
}

function oficial_restaurarValoresDefecto()
{
	var util:FLUtil = new FLUtil;

	var res:Number = MessageBox.warning(util.translate("scripts", "Va a restaurar los valores por defecto del gráfico.\n¿Está seguro?"), MessageBox.Yes, MessageBox.No);
	if (res != MessageBox.Yes) {
		return;
	}

	this.iface.xmlGrafico_ = new FLDomDocument();
	xmlDoc = this.iface.xmlGrafico_;
	xmlDoc.setContent("<Grafico Tipo='2dtarta' />");

	var eGrafico:FLDomElement = xmlDoc.firstChild().toElement();
	eGrafico.setAttribute("Alto", 250);
	eGrafico.setAttribute("Ancho", 300);
	
	eGrafico.setAttribute("Titulo", util.translate("scripts", "TITULO DEL INFORME"));
	eGrafico.setAttribute("MargenSuperior", 10);
	eGrafico.setAttribute("MargenInferior", 10);
	eGrafico.setAttribute("MargenIzquierdo", 10);
	eGrafico.setAttribute("MargenDerecho", 10);
	eGrafico.setAttribute("Marco", "true");
	eGrafico.setAttribute("FontFamily", "Arial");
	eGrafico.setAttribute("FontSize", 10);
	eGrafico.setAttribute("FontFamilyValor", "Arial");
	eGrafico.setAttribute("FontSizeValor", 10);
	eGrafico.setAttribute("FormatoV","Entero");
	eGrafico.setAttribute("Valor","false");
	eGrafico.setAttribute("Porcentaje","true");
	eGrafico.setAttribute("Nombre","false");
	eGrafico.setAttribute("MargenLabel",20);
	eGrafico.setAttribute("FontFamilyTitulo", "Arial");
	eGrafico.setAttribute("FontSizeTitulo", 15);
	eGrafico.setAttribute("Flechas", "true");
	eGrafico.setAttribute("Circunferencia", "true");
	eGrafico.setAttribute("ColorTitulo", "0,0,255");
	var eValores:FLDomElement = xmlDoc.createElement("Valores");
	eGrafico.appendChild(eValores);
		
	var eValor:FLDomDocument;
	var eSecuencia:FLDomDocument;
	for(var s=0;s<4;s++) {
		eSecuencia = xmlDoc.createElement("Secuencia");
		eValores.appendChild(eSecuencia);
		eSecuencia.setAttribute("id", s);
		eSecuencia.setAttribute("Leyenda", "Secuencia " + s);
	
		eValor = xmlDoc.createElement("Valor");
		eSecuencia.appendChild(eValor);
		eValor.setAttribute("Valor", 50);
		eValor.setAttribute("Label", "Valor 50");
	
		eValor = xmlDoc.createElement("Valor");
		eSecuencia.appendChild(eValor);
		eValor.setAttribute("Valor", 100);
		eValor.setAttribute("Label", "Valor 100");
		
		eValor = xmlDoc.createElement("Valor");
		eSecuencia.appendChild(eValor);
		eValor.setAttribute("Valor", 150);
		eValor.setAttribute("Label", "Valor 150");
	
		eValor = xmlDoc.createElement("Valor");
		eSecuencia.appendChild(eValor);
		eValor.setAttribute("Valor", 200);
		eValor.setAttribute("Label", "Valor 200");
			
		eValor = xmlDoc.createElement("Valor");
		eSecuencia.appendChild(eValor);
		eValor.setAttribute("Valor", 250);
		eValor.setAttribute("Label", "Valor 250");
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
	debug("xml " + xml);
	if (xml) {
		this.iface.xmlGrafico_ = new FLDomDocument;
		if (!this.iface.xmlGrafico_.setContent(xml)) {
			return false;
		}
	} else {
		switch(cursor.modeAccess()) {
			case cursor.Insert: {
				break;
			}
			case cursor.Edit: {
				break;
			}
			case cursor.Browse: {
				break;
			}
		}
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
	var util:FLUtil;
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

	this.child("fdbFamiliaFuente").setValue(eGrafico.attribute("FontFamily"));
	this.child("fdbTamanoFuente").setValue(eGrafico.attribute("FontSize"));
	
	this.child("fdbFamiliaFuenteTitulo").setValue(eGrafico.attribute("FontFamilyTitulo"));
	this.child("fdbTamanoFuenteTitulo").setValue(eGrafico.attribute("FontSizeTitulo"));
	this.child("fdbColorTitulo").setValue(eGrafico.attribute("ColorTitulo"));
	this.child("fdbFlechas").setValue(eGrafico.attribute("Flechas"));
	this.child("fdbCircunferencia").setValue(eGrafico.attribute("Circunferencia"));
	this.child("fdbFormatoV").setValue(eGrafico.attribute("FormatoV"));
	this.child("fdbValor").setValue(eGrafico.attribute("Valor"));
	this.child("fdbPorcentaje").setValue(eGrafico.attribute("Porcentaje"));
	this.child("fdbNombre").setValue(eGrafico.attribute("Nombre"));
	this.child("fdbMargenLabel").setValue(eGrafico.attribute("MargenLabel"));

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
	eGrafico.setAttribute("FontFamily", cursor.valueBuffer("familiafuente"));
	eGrafico.setAttribute("FontSize", cursor.valueBuffer("tamanofuente"));
	eGrafico.setAttribute("FontFamilyTitulo", cursor.valueBuffer("familiafuentetitulo"));
	eGrafico.setAttribute("FontSizeTitulo", cursor.valueBuffer("tamanofuentetitulo"));
	eGrafico.setAttribute("Flechas", cursor.valueBuffer("flechas"));
	eGrafico.setAttribute("Circunferencia", cursor.valueBuffer("circunferencia"));
	eGrafico.setAttribute("ColorTitulo", cursor.valueBuffer("colortitulo"));
	eGrafico.setAttribute("FormatoV", cursor.valueBuffer("formatov"));
	eGrafico.setAttribute("Valor", cursor.valueBuffer("valor"));
	eGrafico.setAttribute("Porcentaje", cursor.valueBuffer("porcentaje"));
	eGrafico.setAttribute("Nombre", cursor.valueBuffer("nombre"));
	eGrafico.setAttribute("MargenLabel", cursor.valueBuffer("margenlabel"));
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

debug("**************** XML ************************ \n" + this.iface.xmlGrafico_.toString(4));
	cursor.setValueBuffer("xml", this.iface.xmlGrafico_.toString(4));
	this.iface.dibujarGraficoPix();
}

/** \D Redondea un número para establecer las marcas del gráfico en intervalos redondeados
@param valor: Valor a redondear
@return	Valor redondeado
\end */
function oficial_redondearEjeY2dTarta(valor:Number):Number
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
			return false;
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
	if (!util.sqlSelect("gf_2dtarta", "id", "id = " + id)) {
		this.child("tbnValoresDefecto").close();
		this.child("tbnGuardar").close();
	}
}

function oficial_bufferChanged(fN:String)
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	switch (fN) {
		case "xml": {
			break;
		}
		case "colortitulo": {
			flgraficos.iface.pub_colorearLabel(this.child("lblColorTitulo"), cursor.valueBuffer(fN));
			this.iface.renovarTimer();
			break;
		}
		case "coloresdefecto": {
			this.iface.activarDesactivarColoresDefecto();
			break;
		}
// 		case "ancho": { // El ancho y el alto deben ser iguales.
// 			this.child("fdbAlto").setValue(cursor.valueBuffer("ancho"));
// 			break;
// 		}
// 		case "colorseccion1": {
// 			flgraficos.iface.pub_colorearLabel(this.child("lblColorSeccion1"), cursor.valueBuffer(fN));
// 			this.iface.renovarTimer();
// 			break;
// 		}
// 		case "colorseccion2": {
// 			flgraficos.iface.pub_colorearLabel(this.child("lblColorSeccion2"), cursor.valueBuffer(fN));
// 			this.iface.renovarTimer();
// 			break;
// 		}
// 		case "colorseccion3": {
// 			flgraficos.iface.pub_colorearLabel(this.child("lblColorSeccion3"), cursor.valueBuffer(fN));
// 			this.iface.renovarTimer();
// 			break;
// 		}
// 		case "colorvalor": {
// 			flgraficos.iface.pub_colorearLabel(this.child("lblColorValor"), cursor.valueBuffer(fN));
// 			this.iface.renovarTimer();
// 			break;
// 		}
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
	flgraficos.iface.pub_colorearLabel(this.child("lblColorTitulo"), cursor.valueBuffer("colortitulo"));
// 	flgraficos.iface.pub_colorearLabel(this.child("lblColorSeccion1"), cursor.valueBuffer("colorseccion1"));
// 	flgraficos.iface.pub_colorearLabel(this.child("lblColorSeccion2"), cursor.valueBuffer("colorseccion2"));
// 	flgraficos.iface.pub_colorearLabel(this.child("lblColorSeccion3"), cursor.valueBuffer("colorseccion3"));
// 	flgraficos.iface.pub_colorearLabel(this.child("lblColorValor"), cursor.valueBuffer("colorvalor"));
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
	var totalSecuenciasVal:Number = 0;
	var totalValores:Number = 0;
	var eValores:FLDomElement = eGrafico.namedItem("Valores");
	if (eValores) {
		var eSecuencia:FLDomElement, iSec:Number = 0;
		var xmlValoresSec:FLDomNodeList;
		for (var xmlValor:FLDomNode = eValores.firstChild(); xmlValor; xmlValor = xmlValor.nextSibling()) {
			eSecuencia = xmlValor.toElement();
			xmlValoresSec = eSecuencia.elementsByTagName("Valor");
			totalValores = (xmlValoresSec ? xmlValoresSec.count() : 1);
			if(totalValores > totalSecuenciasVal)
				totalSecuenciasVal = totalValores;
		}
	}

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
	
// 	var aColores:Array = [["", "0, 0, 200"], ["", "0, 200, 0"], ["", "200, 0, 0"], ["", "200, 200, 0"], ["", "200, 0, 200"], ["", "0, 200, 200"], ["", "100, 100, 200"], ["", "100, 200, 100"], ["", "200, 100, 100"], ["", "100, 100, 100"]];
// 	var eSecuencias:FLDomElement = eGrafico.namedItem("Secuencias");
// 	if (eSecuencias) {
// 		var eSecuencia:FLDomElement, iSec:Number = 0;
// 		for (var xmlSecuencia:FLDomNode = eSecuencias.firstChild(); xmlSecuencia; xmlSecuencia = xmlSecuencia.nextSibling()) {
// 			eSecuencia = xmlSecuencia.toElement();
// 			aColores[iSec][0] = eSecuencia.attribute("IdColor");
// 			aColores[iSec][1] = eSecuencia.attribute("Color");
// 			iSec++;
// 		}
// 	}
// 	return aColores;
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

