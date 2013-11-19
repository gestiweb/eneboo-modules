/***************************************************************************
                 gf_1daguja.qs  -  description
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
	function redondearEjeY1dAguja(valor:Number):Number {
		return this.ctx.oficial_redondearEjeY1dAguja(valor);
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
	function renovarTimer() {
		return this.ctx.oficial_renovarTimer();
	}
	function iniciarMuestrasColor() {
		return this.ctx.oficial_iniciarMuestrasColor();
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
	
	connect(this.child("tbnValoresDefecto"), "clicked()", this, "iface.tbnValoresDefecto_clicked");
	connect(this.child("tbnRefrescar"), "clicked()", this, "iface.tbnRefrescar_clicked");
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	
	this.iface.iniciarValores();
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
	var f:Object = new FLFormSearchDB("gf_1daguja");
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
	var eValores:FLDomElement = eGrafico.namedItem("Valores").toElement();
	var xmlValores:FLDomNodeList = eValores.elementsByTagName("Valor");
	if(!xmlValores)
		return pic;
	
	var numValores:Number = parseInt(xmlValores.length());
	var anchoAbs:Number = parseInt(eGrafico.attribute("Ancho"));
	if(anchoAbs == 0)
		return pic;
	debug("anchoAbs " + anchoAbs);
	var altoAbs:Number = parseInt(eGrafico.attribute("Alto"));
	if(altoAbs == 0)
		return pic;
	
////////////////////////////////////////////////
	var factor:Number = anchoAbs/altoAbs;
	var numValoresY:Number;
	var numValoresX:Number = Math.sqrt(numValores*factor);
	var numValoresX1:Number = Math.ceil(numValoresX);
	var numValoresX2:Number = Math.floor(numValoresX);
	
	debug("numValoresX " + numValoresX);
	if (numValoresX == 0)
		return pic;
	
	var numValoresY1:Number = numValores / numValoresX1;
	var numValoresY2:Number = numValores / numValoresX2;
	numValoresY1 = Math.floor(numValoresY1);
	numValoresY2 = Math.floor(numValoresY2);
	if ((numValoresY1 * numValoresX1) < numValores) {
		numValoresY1++;
	}
	if ((numValoresY2 * numValoresX2) < numValores) {
		numValoresY2++;
	}

	if(numValoresY == 0)
		numValoresY = 1;

	var ancho1:Number = anchoAbs/numValoresX1;
	var alto1:Number = altoAbs/numValoresY1;

	if(ancho1 != alto1) {
		if(ancho1 < alto1)
			alto1 = ancho1;
		else
			ancho1 = alto1;
	}

	var ancho2:Number = anchoAbs/numValoresX2;
	var alto2:Number = altoAbs/numValoresY2;
	
	if(ancho2 != alto2) {
		if(ancho2 < alto2)
			alto2 = ancho2;
		else
			ancho2 = alto2;
	}

	var ancho:Number;
	var alto:Number;

	if(ancho1 > ancho2) {
		ancho = ancho1;
		alto = alto1;
		numValoresX = numValoresX1;
		numValoresY = numValoresY1;
	}
	else {
		ancho = ancho2;
		alto = alto2;
		numValoresX = numValoresX2;
		numValoresY = numValoresY2;
	}
////////////////////////////////////////////////////
	
	var marco:Boolean = (eGrafico.attribute("Marco") == "true");
	
	var margenSuperior:Number = parseInt(parseInt(eGrafico.attribute("MargenSuperior")));
	if (isNaN(margenSuperior)) { margenSuperior = 0; }
	debug("margenSuperior "  + margenSuperior);
	var margenInferior:Number = parseInt(parseInt(eGrafico.attribute("MargenInferior")));
	if (isNaN(margenInferior)) { margenInferior = 0; }
	debug("margenInferior "  + margenInferior);
	var margenIzquierdo:Number = parseInt(parseInt(eGrafico.attribute("MargenIzquierdo")));
	if (isNaN(margenIzquierdo)) { margenIzquierdo = 0; }
	debug("margenIzquierdo "  + margenIzquierdo);
	var margenDerecho:Number = parseInt(parseInt(eGrafico.attribute("MargenDerecho")));
	if (isNaN(margenDerecho)) { margenDerecho = 0; }
	debug("margenDerecho "  + margenDerecho);
	
	var posicionValor:Number = parseInt(eGrafico.attribute("PosicionValor"));
	if (isNaN(posicionValor)) { posicionValor = 0; }
	var marcarLabel:Boolean = (eGrafico.attribute("MarcarLabel") == "true");
	
	
	var valor1:Number = parseInt(eGrafico.attribute("Valor1"));
	if (isNaN(valor1)) { valor1 = 0; }
	var valor2:Number = parseInt(eGrafico.attribute("Valor2"));
	if (isNaN(valor2)) { valor2 = 0; }
	var valor3:Number = parseInt(eGrafico.attribute("Valor3"));
	if (isNaN(valor3)) { valor3 = 0; }
	var valor4:Number = parseInt(eGrafico.attribute("Valor4"));
	if (isNaN(valor4)) { valor4 = 0; }
	
	var margenLabel:Number = parseInt(eGrafico.attribute("MargenLabel"));
	if (isNaN(margenLabel)) { margenLabel= 0; }
	var anguloInicio:Number = parseInt(eGrafico.attribute("AnguloInicio"));
	if (isNaN(anguloInicio)) { anguloInicio= 0; }
	var anguloFin:Number = parseInt(eGrafico.attribute("AnguloFin"));
	if (isNaN(anguloFin)) { anguloFin= 0; }
	var radio:Number = parseInt(eGrafico.attribute("Radio"));
	if (isNaN(radio)) { radio= 0; }
	
	var color1:String = eGrafico.attribute("ColorSeccion1");
	if(!color1 || color1 == "") color1 = "0,0,0";
	var color2:String = eGrafico.attribute("ColorSeccion2");
	if(!color2 || color2 == "") color2 = "0,0,0";
	var color3:String = eGrafico.attribute("ColorSeccion3");
	if(!color3 || color3 == "") color3 = "0,0,0";
	var colorValor:String = eGrafico.attribute("ColorValor");
	if(!colorValor || colorValor == "") colorValor = "0,0,0";
	
	var fontFamily:String = eGrafico.attribute("FontFamily");
	var fontSize:Number = parseFloat(eGrafico.attribute("FontSize"));
	var fontFamilyValor:String = eGrafico.attribute("FontFamilyValor");
	var fontSizeValor:Number = parseFloat(eGrafico.attribute("FontSizeValor"));
	
	var formatoValor:String = eGrafico.attribute("FormatoV");
	if (!formatoValor || formatoValor == "") {
		formatoValor = "Entero";
	}
	
	var anchoC:Number;
	var altoC:Number;
	if(marcarLabel) {
		 anchoC= ancho - margenIzquierdo - margenDerecho - (margenLabel*2);
		altoC = alto - margenSuperior - margenInferior - (margenLabel*2);
	}
	else {
		anchoC= ancho - margenIzquierdo - margenDerecho;
		altoC = alto - margenSuperior - margenInferior;
	}
	
	var x:Array = [];
	var y:Array = [];

	var clf = flgraficos.iface.pub_dameFuente(fontFamily, fontSize); // FUENTE DE LAS ETIQUETAS EN LOS EJES
	
	
	var titulo:String = eGrafico.attribute("Titulo");
	var altoTitulo:Number = (titulo && titulo != "" ? parseInt(fontSize) + 10 : 0);
	
	var offGraficoX:Number = margenIzquierdo;
	if(marcarLabel)
		offGraficoX += margenLabel;
		
	var offGraficoY:Number = margenSuperior + parseInt(altoTitulo);
	if(marcarLabel)
		offGraficoY += margenLabel;
	
	var puntoInicioX:Number = 0;
	var puntoInicioY:Number = 0;
	var puntoTransladoX:Number;
	var puntoTransladoY:Number;
	for (iValor = 0; iValor < numValores; iValor++) {
		if(iValor > 0) {
			if(iValor < numValoresX){
				puntoTransladoX= puntoInicioX + (ancho*iValor);
				puntoTransladoY = puntoInicioY;
			}
			else {
				var fila:Number = (iValor+1)/numValoresX;
				fila = Math.ceil(fila);
				var columna:Number = iValor - (numValoresX*(fila-1));
				puntoTransladoX= puntoInicioX + (ancho*columna);
				puntoTransladoY = puntoInicioY + (alto*(fila-1));
			}
			pic.savePainter();
			pic.translate(puntoTransladoX,puntoTransladoY);
		}

		var valor:Number;
		eValor = xmlValores.item(iValor).toElement();
		valor = parseFloat(eValor.attribute("Valor"));
		
		var tituloValor:String = eValor.attribute("Titulo")
		var altoTitulo:Number = (tituloValor && tituloValor != "" ? parseInt(fontSize) + 10 : 0);
	
		var offGraficoX:Number = margenIzquierdo;
		if(marcarLabel)
			offGraficoX += margenLabel;
			
		var offGraficoY:Number = margenSuperior + parseInt(altoTitulo);
		if(marcarLabel)
			offGraficoY += margenLabel;
		
		pic.setFont( clf );
	/// Título
		clr.setRgb( 0, 0, 0 );
		pic.setPen( clr, 1); // pic.DotLine );
		try {
			pic.drawText(margenIzquierdo, margenSuperior,  ancho - margenIzquierdo - margenDerecho, altoTitulo, pic.AlignHCenter, tituloValor, -1);
		} catch (e) {
			pic.drawText(margenIzquierdo, margenSuperior,  ancho - margenIzquierdo - margenDerecho, altoTitulo, 0, tituloValor, -1);
		}
// 			pic.drawText(offGraficoX, margenSuperior + parseInt(altoTitulo) - 10, titulo);
	/// Marco
		if (marco) {
			pic.drawLine(1, 1, alto, 1);
			pic.drawLine(0, alto, ancho, alto);
			pic.drawLine(1, 1, 1, alto);
			pic.drawLine(ancho, 1, ancho, alto);
		}

	/// Seccion 3
		var totalARepresntar = valor4-valor1;	
		var clrSeccion = new Color();
		var colores:Array = color3.split(",");
		clrSeccion.setRgb(colores[0],colores[1],colores[2])
		pic.setBrush(clrSeccion);
		
		var inicio:Number = (270+anguloFin)*16;
		var anguloTotal:Number = (360-anguloInicio-anguloFin)*16;
		var anguloSeccion3:Number = (anguloTotal * (valor4-valor3))/totalARepresntar;
		pic.drawPie(offGraficoX,offGraficoY,altoC,anchoC,inicio,anguloSeccion3);
		var finSeccion2:Number = anguloSeccion3-((90-anguloFin)*16);
		
	/// Seccion 2
		clrSeccion = new Color();
		colores = color2.split(",");
		clrSeccion.setRgb(colores[0],colores[1],colores[2])
		pic.setBrush(clrSeccion);
		var anguloSeccion2:Number = (anguloTotal * (valor3-valor2))/totalARepresntar;
		pic.drawPie(offGraficoX,offGraficoY,altoC,anchoC,finSeccion2,anguloSeccion2);
		var finSeccion1:Number = anguloSeccion2+finSeccion2;
		
	/// Seccion 1
		clrSeccion = new Color();
		colores = color1.split(",");
		clrSeccion.setRgb(colores[0],colores[1],colores[2])
		pic.setBrush(clrSeccion);
		var fin:Number = anguloTotal - finSeccion1-((90-anguloFin)*16);
		pic.drawPie(offGraficoX,offGraficoY,altoC,anchoC,finSeccion1,fin);
		
	/// Radio
		if(radio > 0 && radio < anchoC && radio < altoC ) {
			clrSeccion.setRgb(255,255,255)
			pic.setBrush(clrSeccion);
			var altoCC = altoC-radio;
			
			var anchoCC = anchoC-radio;
			var offGraficoXC = offGraficoX+(radio/2);
			var offGraficoYC = offGraficoY+(radio/2);
			
			var inicio:Number = (270+anguloFin)*16;
			var anguloTotal:Number = (360-anguloInicio-anguloFin)*16;
			var anguloSeccion3:Number = (anguloTotal * (valor4-valor3))/totalARepresntar;
			pic.drawPie(offGraficoXC,offGraficoYC,altoCC,anchoCC,inicio,anguloTotal);
			
			pic.setPen(clrSeccion, 0); // pic.DotLine );
			pic.drawPie(offGraficoXC+2,offGraficoYC+2,altoCC-4,anchoCC-4,inicio,360*16);
			pic.setPen( clr, 1); // pic.DotLine );
		}
		
		
	///  Labels
		if(marcarLabel) {
			var marcarCada:Number = parseFloat(eGrafico.attribute("MarcarCada"));
			if (!marcarCada || marcarCada == 0)
				marcarCada = valor4/5;
				
			var totalMarcas:Number = Math.ceil((valor4 - valor1) / marcarCada);
			var anguloMedida:Number;
			var angulo:Number;
			var radianes:Number;
			var lado:Number;
			var radioC:Number = anchoC/2;
			var longMarca:Number = radioC*10/100;
			var anchoAux:Number = radioC -longMarca;
			var valorm:Number;
			for (var m:Number = valor1; m < (valor4+marcarCada); m += marcarCada) {
				valorm = flgraficos.iface.pub_formatearValor(m, formatoValor);
				angulo = ((anguloTotal/16 * (valor4-m))/totalARepresntar);
		
				var angulo16 = angulo*16;
				if(angulo16>anguloTotal || angulo16<0)
					continue;
				
				angulo = angulo+anguloFin-90;
				radianes = angulo*Math.PI/180;
			
				x=(offGraficoX+radioC)+radioC*Math.cos(radianes);
				y=offGraficoY+radioC-(radioC*Math.sin(radianes));
				
				x2=(offGraficoX+radioC)+anchoAux*Math.cos(radianes);
				y2=offGraficoY+(radioC-(anchoAux*Math.sin(radianes)));
			
				pic.drawLine(x,y,x2,y2);
				var xt:Number = x;
				var yt:Number = y;
		
				if(angulo <0 ) { // 1
					try {
						pic.drawText(xt, yt+parseFloat(fontSize),   ancho-xt, parseFloat(fontSize), pic.AligLeft | pic.AlignVCenter, valorm.toString(), -1);
					} catch (e) {
						pic.drawText(xt, yt+parseFloat(fontSize), valorm.toString());
					}
				}
				else {
					if(angulo <= 90) { // 2
						try {
							pic.drawText(xt, yt-parseFloat(fontSize),  ancho-xt, parseFloat(fontSize), pic.AlignLeft | pic.AlignVCenter, valorm.toString(), -1);
						} catch (e) {
							pic.drawText(xt, yt, valorm.toString());
						}
					}
					else {
						if(angulo <= 180) { // 3
							try {
								pic.drawText(0, yt-parseFloat(fontSize),  xt, parseFloat(fontSize), pic.AlignRight | pic.AlignVCenter, valorm.toString(), -1);
							} catch (e) {
								pic.drawText(xt-margenLabel, yt, valorm.toString());
							}
						}
						else { // 4
							try {
								pic.drawText(0, yt,  xt, parseFloat(fontSize), pic.AlignRight | pic.AlignVCenter, valorm.toString(), -1);
							} catch (e) {
								pic.drawText(xt-margenLabel, yt+parseFloat(fontSize), valorm.toString());
							}
						}
					}
				}
				
// 				if(angulo >90 && angulo <= 180) {
// 					xt = parseFloat(x)-parseFloat(margenLabel);
// 					try {
// 						pic.drawText(xt, yt-parseFloat(fontSize),  parseFloat(margenLabel), parseFloat(fontSize),pic.AlignHCenter | pic.AlignVCenter, valorm.toString(), -1);
// 					} catch (e) {
// 						pic.drawText(xt, yt, valorm.toString());
// 					}
// 				}
// 				if(angulo >180 && angulo <= 270) {
// 					yt = parseFloat(y)+parseFloat(fontSize);
// 					xt = parseFloat(x)-parseFloat(margenLabel);
// 				}
// 				if(angulo <0 ) {
// 					yt = parseFloat(y)+parseFloat(fontSize);
// 				}
// 				
// 				try {
// 					pic.drawText(xt, yt-parseFloat(fontSize),  parseFloat(margenLabel), parseFloat(fontSize),pic.AlignHCenter | pic.AlignVCenter, valorm.toString(), -1);
// 				} catch (e) {
// 					pic.drawText(xt, yt, valorm.toString());
// 				}
				
			}
		}

	/// Aguja
		
		var angulo:Number;
		var radianes:Number;
		var radioC:Number = anchoC/2;
		var tamInicioAguja:Number = radioC*15/100;
		var radioInicioAguja:Number = tamInicioAguja/2;
		var xIni:Number=offGraficoX+radioC;
		var yIni:Number=offGraficoY+radioC;
		var x:Number;
		var y:Number;
		pic.setPen( clr, 3);	
		
		var valorR:Number = valor;
		if(valorR<valor1)
			valorR = valor1;
			
		if(valorR>valor4)
			valorR = valor4;
			
		angulo = ((anguloTotal/16 * (valor4-valorR))/totalARepresntar);
		angulo = angulo+anguloFin-90;
		if(valor<valor1) 
			angulo +=3;
		if(valor>valor4)
			angulo -= 3;
		radianes = angulo*Math.PI/180;

		x=(offGraficoX+radioC)+radioC*Math.cos(radianes);
		y=offGraficoY+(radioC-(radioC*Math.sin(radianes)));
		
		pic.drawLine(xIni,yIni,x,y);
		
		/// Bola aguja
		clrSeccion.setRgb(0,0,0)
		pic.setBrush(clrSeccion);
		pic.setPen(clrSeccion, 0); // pic.DotLine );
		
		var offGraficoXA = offGraficoX+radioC - radioInicioAguja;
		var offGraficoYA = offGraficoY+radioC - radioInicioAguja;
		
		var inicio:Number = (270+anguloFin)*16;
		var anguloTotal:Number = (360-anguloInicio-anguloFin)*16;
		var anguloSeccion3:Number = (anguloTotal * (valor4-valor3))/totalARepresntar;
		pic.drawPie(offGraficoXA,offGraficoYA,tamInicioAguja,tamInicioAguja,0,360*16);
		pic.setPen( clr, 1); // pic.DotLine );
		
		
		/// Valor

		var clf = flgraficos.iface.pub_dameFuente(fontFamilyValor, fontSizeValor); // FUENTE DE LAS ETIQUETAS EN LOS EJES
		pic.setFont( clf );
		var color = colorValor.split(",");
		clrSeccion.setRgb(color[0],color[1],color[2])
		pic.setPen(clrSeccion,1);
		
		
// 		var xValor:Number = xIni;
// 		var yValor:Number = parseFloat(yIni) + parseFloat(posicionValor) + parseFloat(fontSizeValor);
		var xValor:Number = margenIzquierdo;
		var pos:Number = alto*posicionValor/100;
		var yValor:Number = parseFloat(pos);
		var anchoValor:Number = ancho - margenIzquierdo - margenDerecho;
		var altoValor:Number = parseFloat(fontSizeValor) + 10;

		valor = flgraficos.iface.pub_formatearValor(valor, formatoValor);
		
		try {
			pic.drawText(xValor, yValor , anchoValor, altoValor, pic.AlignHCenter, valor.toString(), -1);
		} catch (e) {
			pic.drawText(xIni, parseFloat(yIni) + parseFloat(posicionValor) + parseFloat(fontSizeValor), valor.toString());
		}
		
		pic.setPen(clr,1);
		
		if(iValor > 0)
			pic.restorePainter();
	}
	
	if (moverMarco) {
		pic.restorePainter();
	}
	
	return pic;
}

// function oficial_dibujarGrafico(xmlDatos:FLDomDocument):Picture
// {
// 	var util:FLUtil = new FLUtil;
// debug("XXXXXXXXXXX\noficial_dibujarGrafico: " + xmlDatos.toString(4));
// 	var pic:Picture = new Picture;
// 	var clr = new Color();
// 	var clf = new Font();
// 	pic.begin();
// 	
// 	var eGrafico:FLDomElement = xmlDatos.firstChild().toElement();
// 	var eValores:FLDomElement = eGrafico.namedItem("Valores").toElement();
// 	var xmlValores:FLDomNodeList = eValores.elementsByTagName("Valor");
// 	var numValores:Number = xmlValores.length();
// 	var ancho:Number = parseInt(eGrafico.attribute("Ancho"));
// 	var ancho :Number = anchoAbs/numValores;
// 	var alto:Number = parseInt(eGrafico.attribute("Alto"));
// 	var marco:Boolean = (eGrafico.attribute("Marco") == "true");
// 	
// 	var margenSuperior:Number = parseInt(eGrafico.attribute("MargenSuperior"));
// 	if (isNaN(margenSuperior)) { margenSuperior = 0; }
// 	var margenInferior:Number = parseInt(eGrafico.attribute("MargenInferior"));
// 	if (isNaN(margenInferior)) { margenInferior = 0; }
// 	var margenIzquierdo:Number = parseInt(eGrafico.attribute("MargenIzquierdo"));
// 	if (isNaN(margenIzquierdo)) { margenIzquierdo = 0; }
// 	var margenDerecho:Number = parseInt(eGrafico.attribute("MargenDerecho"));
// 	if (isNaN(margenDerecho)) { margenDerecho = 0; }
// 	var margenDerecho:Number = parseInt(eGrafico.attribute("MargenDerecho"));
// 	if (isNaN(margenDerecho)) { margenDerecho = 0; }
// 	var posicionValor:Number = parseInt(eGrafico.attribute("PosicionValor"));
// 	if (isNaN(posicionValor)) { posicionValor = 0; }
// 	var marcarLabel:Boolean = (eGrafico.attribute("MarcarLabel") == "true");
// 	
// 	
// 	var valor1:Number = parseInt(eGrafico.attribute("Valor1"));
// 	if (isNaN(valor1)) { valor1 = 0; }
// 	var valor2:Number = parseInt(eGrafico.attribute("Valor2"));
// 	if (isNaN(valor2)) { valor2 = 0; }
// 	var valor3:Number = parseInt(eGrafico.attribute("Valor3"));
// 	if (isNaN(valor3)) { valor3 = 0; }
// 	var valor4:Number = parseInt(eGrafico.attribute("Valor4"));
// 	if (isNaN(valor4)) { valor4 = 0; }
// 	
// 	var margenLabel:Number = parseInt(eGrafico.attribute("MargenLabel"));
// 	if (isNaN(margenLabel)) { margenLabel= 0; }
// 	var anguloInicio:Number = parseInt(eGrafico.attribute("AnguloInicio"));
// 	if (isNaN(anguloInicio)) { anguloInicio= 0; }
// 	var anguloFin:Number = parseInt(eGrafico.attribute("AnguloFin"));
// 	if (isNaN(anguloFin)) { anguloFin= 0; }
// 	var radio:Number = parseInt(eGrafico.attribute("Radio"));
// 	if (isNaN(radio)) { radio= 0; }
// 	
// 	var color1:String = eGrafico.attribute("ColorSeccion1");
// 	if(!color1 || color1 == "") color1 = "0,0,0";
// 	var color2:String = eGrafico.attribute("ColorSeccion2");
// 	if(!color2 || color2 == "") color2 = "0,0,0";
// 	var color3:String = eGrafico.attribute("ColorSeccion3");
// 	if(!color3 || color3 == "") color3 = "0,0,0";
// 	var colorValor:String = eGrafico.attribute("ColorValor");
// 	if(!colorValor || colorValor == "") colorValor = "0,0,0";
// 	
// 	var fontFamily:String = eGrafico.attribute("FontFamily");
// 	var fontSize:Number = parseFloat(eGrafico.attribute("FontSize"));
// 	var fontFamilyValor:String = eGrafico.attribute("FontFamilyValor");
// 	var fontSizeValor:Number = parseFloat(eGrafico.attribute("FontSizeValor"));
// 	
// 	var anchoC:Number;
// 	var altoC:Number;
// 	if(marcarLabel) {
// 		 anchoC= ancho - margenIzquierdo - margenDerecho - (margenLabel*2);
// 		altoC = alto - margenSuperior - margenInferior - (margenLabel*2);
// 	}
// 	else {
// 		anchoC= ancho - margenIzquierdo - margenDerecho;
// 		altoC = alto - margenSuperior - margenInferior;
// 	}
// 	
// 	var x:Array = [];
// 	var y:Array = [];
// 
// 	var clf = flgraficos.iface.pub_dameFuente(fontFamily, fontSize); // FUENTE DE LAS ETIQUETAS EN LOS EJES
// 	
// 	
// 	var titulo:String = eGrafico.attribute("Titulo");
// 	var altoTitulo:Number = (titulo && titulo != "" ? parseInt(fontSize) + 10 : 0);
// 	
// 	var offGraficoX:Number = margenIzquierdo;
// 	if(marcarLabel)
// 		offGraficoX += margenLabel;
// 		
// 	var offGraficoY:Number = margenSuperior + parseInt(altoTitulo);
// 	if(marcarLabel)
// 		offGraficoY += margenLabel;
// 	
// 	var puntoInicioX:Number = 0;
// 	var puntoInicioY:Number = 0;
// 	var puntoTransladoX:Number;
// 	var puntoTransladoY:Number;
// 	for (iValor = 0; iValor < numValores; iValor++) {
// 		debug("iValor " + iValor);
// 		if(iValor > 0) {
// 			puntoTransladoX= puntoInicioX + (ancho*iValor);
// 			puntoTransladoY = puntoInicioY;
// 			pic.savePainter();
// 			pic.translate(puntoTransladoX,puntoTransladoY);
// 		}
// 					
// 		debug("puntoTransladoX " + puntoTransladoX);
// 		debug("puntoTransladoY " + puntoTransladoY);
// 			
// 		pic.setFont( clf );
// 	/// Título
// 		clr.setRgb( 0, 0, 0 );
// 		pic.setPen( clr, 1); // pic.DotLine );
// 		try {
// 			pic.drawText(margenIzquierdo, margenSuperior,  ancho - margenIzquierdo - margenDerecho, altoTitulo, pic.AlignHCenter, titulo, -1);
// 		} catch (e) {
// 			pic.drawText(margenIzquierdo, margenSuperior,  ancho - margenIzquierdo - margenDerecho, altoTitulo, 0, titulo, -1);
// 		}
// // 			pic.drawText(offGraficoX, margenSuperior + parseInt(altoTitulo) - 10, titulo);
// 	/// Marco
// 		if (marco) {
// 			pic.drawLine(1, 1, alto, 1);
// 			pic.drawLine(0, alto, ancho, alto);
// 			pic.drawLine(1, 1, 1, alto);
// 			pic.drawLine(ancho, 1, ancho, alto);
// 		}
// 
// 	/// Seccion 3
// 		var totalARepresntar = valor4-valor1;	
// 		var clrSeccion = new Color();
// 		var colores:Array = color3.split(",");
// 		clrSeccion.setRgb(colores[0],colores[1],colores[2])
// 		pic.setBrush(clrSeccion);
// 		
// 		var inicio:Number = (270+anguloFin)*16;
// 		var anguloTotal:Number = (360-anguloInicio-anguloFin)*16;
// 		var anguloSeccion3:Number = (anguloTotal * (valor4-valor3))/totalARepresntar;
// 		pic.drawPie(offGraficoX,offGraficoY,altoC,anchoC,inicio,anguloSeccion3);
// 		var finSeccion2:Number = anguloSeccion3-((90-anguloFin)*16);
// 		
// 	/// Seccion 2
// 		clrSeccion = new Color();
// 		colores = color2.split(",");
// 		clrSeccion.setRgb(colores[0],colores[1],colores[2])
// 		pic.setBrush(clrSeccion);
// 		var anguloSeccion2:Number = (anguloTotal * (valor3-valor2))/totalARepresntar;
// 		pic.drawPie(offGraficoX,offGraficoY,altoC,anchoC,finSeccion2,anguloSeccion2);
// 		var finSeccion1:Number = anguloSeccion2+finSeccion2;
// 		
// 	/// Seccion 1
// 		clrSeccion = new Color();
// 		colores = color1.split(",");
// 		clrSeccion.setRgb(colores[0],colores[1],colores[2])
// 		pic.setBrush(clrSeccion);
// 		var fin:Number = anguloTotal - finSeccion1-((90-anguloFin)*16);
// 		pic.drawPie(offGraficoX,offGraficoY,altoC,anchoC,finSeccion1,fin);
// 		
// 	/// Radio
// 		if(radio > 0 && radio < anchoC && radio < altoC ) {
// 			clrSeccion.setRgb(255,255,255)
// 			pic.setBrush(clrSeccion);
// 			var altoCC = altoC-radio;
// 			
// 			var anchoCC = anchoC-radio;
// 			var offGraficoXC = offGraficoX+(radio/2);
// 			var offGraficoYC = offGraficoY+(radio/2);
// 			
// 			var inicio:Number = (270+anguloFin)*16;
// 			var anguloTotal:Number = (360-anguloInicio-anguloFin)*16;
// 			var anguloSeccion3:Number = (anguloTotal * (valor4-valor3))/totalARepresntar;
// 			pic.drawPie(offGraficoXC,offGraficoYC,altoCC,anchoCC,inicio,anguloTotal);
// 			
// 			pic.setPen(clrSeccion, 0); // pic.DotLine );
// 			pic.drawPie(offGraficoXC+2,offGraficoYC+2,altoCC-4,anchoCC-4,inicio,360*16);
// 			pic.setPen( clr, 1); // pic.DotLine );
// 		}
// 		
// 		
// 	///  Labels
// 		if(marcarLabel) {
// 			var marcarCada:Number = parseFloat(eGrafico.attribute("MarcarCada"));
// 			if (!marcarCada || marcarCada == 0)
// 				marcarCada = valor4/5;
// 				
// 			var totalMarcas:Number = Math.ceil((valor4 - valor1) / marcarCada);
// 			var anguloMedida:Number;
// 			var angulo:Number;
// 			var radianes:Number;
// 			var lado:Number;
// 			var radioC:Number = anchoC/2;
// 			var longMarca:Number = radioC*10/100;
// 			var anchoAux:Number = radioC -longMarca;
// 			for (var m:Number = valor1; m < (valor4+marcarCada); m += marcarCada) {
// 				angulo = ((anguloTotal/16 * (valor4-m))/totalARepresntar);
// 		
// 				var angulo16 = angulo*16;
// 				if(angulo16>anguloTotal || angulo16<0)
// 					continue;
// 				
// 				angulo = angulo+anguloFin-90;
// 				radianes = angulo*Math.PI/180;
// 			
// 				x=(offGraficoX+radioC)+radioC*Math.cos(radianes);
// 				y=offGraficoY+radioC-(radioC*Math.sin(radianes));
// 				
// 				x2=(offGraficoX+radioC)+anchoAux*Math.cos(radianes);
// 				y2=offGraficoY+(radioC-(anchoAux*Math.sin(radianes)));
// 			
// 				pic.drawLine(x,y,x2,y2);
// 				var xt:Number = x;
// 				var yt:Number = y;
// 		
// 				if(angulo >90 && angulo <= 180) {
// 					xt = parseFloat(x)-parseFloat(margenLabel);
// 					try {
// 						pic.drawText(xt, yt-parseFloat(fontSize),  parseFloat(margenLabel), parseFloat(fontSize),pic.AlignHCenter | pic.AlignVCenter, parseInt(m).toString(), -1);
// 					} catch (e) {
// 						pic.drawText(xt, yt, parseInt(m).toString());
// 					}
// 				}
// 				if(angulo >180 && angulo <= 270) {
// 					yt = parseFloat(y)+parseFloat(fontSize);
// 					xt = parseFloat(x)-parseFloat(margenLabel);
// 				}
// 				if(angulo <0 ) {
// 					yt = parseFloat(y)+parseFloat(fontSize);
// 				}
// 				
// 				try {
// 					pic.drawText(xt, yt-parseFloat(fontSize),  parseFloat(margenLabel), parseFloat(fontSize),pic.AlignHCenter | pic.AlignVCenter, parseInt(m).toString(), -1);
// 				} catch (e) {
// 					pic.drawText(xt, yt, parseInt(m).toString());
// 				}
// 				
// 			}
// 		}
// 
// 	/// Aguja
// 		var valor:Number;
// 		var angulo:Number;
// 		var radianes:Number;
// 		var radioC:Number = anchoC/2;
// 		var tamInicioAguja:Number = radioC*15/100;
// 		var radioInicioAguja:Number = tamInicioAguja/2;
// 		var xIni:Number=offGraficoX+radioC;
// 		var yIni:Number=offGraficoY+radioC;
// 		var x:Number;
// 		var y:Number;
// 		pic.setPen( clr, 3);
// 	
// 		eValor = xmlValores.item(iValor).toElement();
// 		valor = parseFloat(eValor.attribute("Valor"));
// 		debug("valor " + valor);
// 		
// 		
// 		angulo = ((anguloTotal/16 * (valor4-valor))/totalARepresntar);
// 		angulo = angulo+anguloFin-90;
// 		radianes = angulo*Math.PI/180;
// 
// 		x=(offGraficoX+radioC)+radioC*Math.cos(radianes);
// 		y=offGraficoY+(radioC-(radioC*Math.sin(radianes)));
// 		
// 		pic.drawLine(xIni,yIni,x,y);
// 		
// 		/// Bola aguja
// 		clrSeccion.setRgb(0,0,0)
// 		pic.setBrush(clrSeccion);
// 		pic.setPen(clrSeccion, 0); // pic.DotLine );
// 		
// 		var offGraficoXA = offGraficoX+radioC - radioInicioAguja;
// 		var offGraficoYA = offGraficoY+radioC - radioInicioAguja;
// 		
// 		var inicio:Number = (270+anguloFin)*16;
// 		var anguloTotal:Number = (360-anguloInicio-anguloFin)*16;
// 		var anguloSeccion3:Number = (anguloTotal * (valor4-valor3))/totalARepresntar;
// 		pic.drawPie(offGraficoXA,offGraficoYA,tamInicioAguja,tamInicioAguja,0,360*16);
// 		pic.setPen( clr, 1); // pic.DotLine );
// 		
// 		
// 		/// Valor
// 
// 		var clf = flgraficos.iface.pub_dameFuente(fontFamilyValor, fontSizeValor); // FUENTE DE LAS ETIQUETAS EN LOS EJES
// 		pic.setFont( clf );
// 		var color = colorValor.split(",");
// 		clrSeccion.setRgb(color[0],color[1],color[2])
// 		pic.setPen(clrSeccion,1);
// 		
// 		
// // 		var xValor:Number = xIni;
// // 		var yValor:Number = parseFloat(yIni) + parseFloat(posicionValor) + parseFloat(fontSizeValor);
// 		var xValor:Number = margenIzquierdo;
// 		var yValor:Number = parseFloat(yIni) + parseFloat(posicionValor);
// 		var anchoValor:Number = ancho - margenIzquierdo - margenDerecho;
// 		var altoValor:Number = parseFloat(fontSizeValor) + 10;
// 
// 		try {
// 			pic.drawText(xValor, yValor , anchoValor, altoValor, pic.AlignHCenter, valor.toString(), -1);
// 		} catch (e) {
// 			pic.drawText(xIni, parseFloat(yIni) + parseFloat(posicionValor) + parseFloat(fontSizeValor), valor.toString());
// 		}
// 		
// 		pic.setPen(clr,1);
// 		
// 		if(iValor > 0)
// 			pic.restorePainter();
// 	}
// 	
// 
// 	return pic;
// }

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
	xmlDoc.setContent("<Grafico Tipo='1daguja' />");

	var eGrafico:FLDomElement = xmlDoc.firstChild().toElement();
	eGrafico.setAttribute("Alto", 350);
	eGrafico.setAttribute("Ancho", 350);
	
	eGrafico.setAttribute("Titulo", util.translate("scripts", "TITULO DEL INFORME"));
	eGrafico.setAttribute("MargenSuperior", 10);
	eGrafico.setAttribute("MargenInferior", 10);
	eGrafico.setAttribute("MargenIzquierdo", 10);
	eGrafico.setAttribute("MargenDerecho", 10);
	eGrafico.setAttribute("Marco", "true");
	eGrafico.setAttribute("FontFamily", "Arial");
	eGrafico.setAttribute("FontSize", 10);
	eGrafico.setAttribute("FontFamilyValor", "Arial");
	eGrafico.setAttribute("FontSizeValor", 15);
	eGrafico.setAttribute("MarcarLabel","true");
	eGrafico.setAttribute("FormatoV","Entero");
	eGrafico.setAttribute("MargenLabel",20);
	eGrafico.setAttribute("PosicionValor",25);
	eGrafico.setAttribute("MarcarCada",100);
	eGrafico.setAttribute("AnguloInicio",60);
	eGrafico.setAttribute("AnguloFin",60);
	eGrafico.setAttribute("Radio",150);
	eGrafico.setAttribute("Valor1",0);
	eGrafico.setAttribute("Valor2",300);
	eGrafico.setAttribute("Valor3",600);
	eGrafico.setAttribute("Valor4",900);
	eGrafico.setAttribute("ColorSeccion1","220,0,0");
	eGrafico.setAttribute("ColorSeccion2","240,240,0");
	eGrafico.setAttribute("ColorSeccion3","0,220,0");
	eGrafico.setAttribute("ColorValor","0,0,220");
	

	var eValores:FLDomElement = xmlDoc.createElement("Valores");
	eGrafico.appendChild(eValores);
		
	
	var eValor:FLDomDocument;
	var eValor:FLDomDocument;
	for(var i=0;i<500;i+=100) {
		eValor = xmlDoc.createElement("Valor");
		eValores.appendChild(eValor);
		eValor.setAttribute("Valor", 250+i);
		eValor.setAttribute("Titulo", "Título valor " + 250+i);
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
}

function oficial_cargarCampos():Boolean
{
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
	
	this.child("fdbFamiliaFuenteValor").setValue(eGrafico.attribute("FontFamilyValor"));
	this.child("fdbTamanoFuenteValor").setValue(eGrafico.attribute("FontSizeValor"));
	
	this.child("fdbMarcarLabel").setValue(eGrafico.attribute("MarcarLabel"));
	this.child("fdbFormatoV").setValue(eGrafico.attribute("FormatoV"));
	this.child("fdbMarcarCada").setValue(eGrafico.attribute("MarcarCada"));
	this.child("fdbMargenLabel").setValue(eGrafico.attribute("MargenLabel"));
	this.child("fdbPosicion").setValue(eGrafico.attribute("PosicionValor"));
	this.child("fdbAnguloInicio").setValue(eGrafico.attribute("AnguloInicio"));
	this.child("fdbAnguloFin").setValue(eGrafico.attribute("AnguloFin"));
	this.child("fdbRadio").setValue(eGrafico.attribute("Radio"));
	this.child("fdbValor1").setValue(eGrafico.attribute("Valor1"));
	this.child("fdbValor2").setValue(eGrafico.attribute("Valor2"));
	this.child("fdbValor3").setValue(eGrafico.attribute("Valor3"));
	this.child("fdbValor4").setValue(eGrafico.attribute("Valor4"));
	this.child("fdbColorSeccion1").setValue(eGrafico.attribute("ColorSeccion1"));
	this.child("fdbColorSeccion2").setValue(eGrafico.attribute("ColorSeccion2"));
	this.child("fdbColorSeccion3").setValue(eGrafico.attribute("ColorSeccion3"));
	this.child("fdbColorValor").setValue(eGrafico.attribute("ColorValor"));

	this.iface.bloqueoRefresco_ = false;
	this.iface.dibujarGraficoPix();

	return true;
}

function oficial_tbnRefrescar_clicked()
{
	this.iface.refrescarGrafico();
}

function oficial_refrescarGrafico()
{debug("oficial_refrescarGrafico");
	killTimer(this.iface.timerGraf_);
debug(1);
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
	eGrafico.setAttribute("FontFamilyValor", cursor.valueBuffer("familiafuentevalor"));
	eGrafico.setAttribute("FontSizeValor", cursor.valueBuffer("tamanofuentevalor"));
	eGrafico.setAttribute("MarcarLabel", cursor.valueBuffer("marcarlabel"));
	eGrafico.setAttribute("FormatoV", cursor.valueBuffer("formatov"));
	eGrafico.setAttribute("PosicionValor", cursor.valueBuffer("posicionvalor"));
	eGrafico.setAttribute("MarcarCada", cursor.valueBuffer("marcarcada"));
	eGrafico.setAttribute("MargenLabel", cursor.valueBuffer("margenlabel"));
	eGrafico.setAttribute("AnguloInicio", cursor.valueBuffer("anguloinicio"));
	eGrafico.setAttribute("AnguloFin", cursor.valueBuffer("angulofin"));
	eGrafico.setAttribute("Radio", cursor.valueBuffer("radio"));
	eGrafico.setAttribute("Valor1", cursor.valueBuffer("valor1"));
	eGrafico.setAttribute("Valor2", cursor.valueBuffer("valor2"));
	eGrafico.setAttribute("Valor3", cursor.valueBuffer("valor3"));
	eGrafico.setAttribute("Valor4", cursor.valueBuffer("valor4"));
	eGrafico.setAttribute("ColorSeccion1", cursor.valueBuffer("colorseccion1"));
	eGrafico.setAttribute("ColorSeccion2", cursor.valueBuffer("colorseccion2"));
	eGrafico.setAttribute("ColorSeccion3", cursor.valueBuffer("colorseccion3"));
	eGrafico.setAttribute("ColorValor", cursor.valueBuffer("colorvalor"));
	var xmlSecuencias:FLDomElement = eGrafico.namedItem("Secuencias");
	if (xmlSecuencias) {
		eGrafico.removeChild(xmlSecuencias);
	}
debug("**************** XML ************************ \n" + this.iface.xmlGrafico_.toString(4));
	cursor.setValueBuffer("xml", this.iface.xmlGrafico_.toString(4));
	this.iface.dibujarGraficoPix();
}

/** \D Redondea un número para establecer las marcas del gráfico en intervalos redondeados
@param valor: Valor a redondear
@return	Valor redondeado
\end */
function oficial_redondearEjeY1dAguja(valor:Number):Number
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
	if (!util.sqlSelect("gf_1daguja", "id", "id = " + id)) {
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
// 		case "ancho": { // El ancho y el alto deben ser iguales.
// 			this.child("fdbAlto").setValue(cursor.valueBuffer("ancho"));
// 			break;
// 		}
		case "colorseccion1": {
			flgraficos.iface.pub_colorearLabel(this.child("lblColorSeccion1"), cursor.valueBuffer(fN));
			this.iface.renovarTimer();
			break;
		}
		case "colorseccion2": {
			flgraficos.iface.pub_colorearLabel(this.child("lblColorSeccion2"), cursor.valueBuffer(fN));
			this.iface.renovarTimer();
			break;
		}
		case "colorseccion3": {
			flgraficos.iface.pub_colorearLabel(this.child("lblColorSeccion3"), cursor.valueBuffer(fN));
			this.iface.renovarTimer();
			break;
		}
		case "colorvalor": {
			flgraficos.iface.pub_colorearLabel(this.child("lblColorValor"), cursor.valueBuffer(fN));
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
}

function oficial_iniciarMuestrasColor()
{
	var cursor:FLSqlCursor = this.cursor();
	flgraficos.iface.pub_colorearLabel(this.child("lblColorSeccion1"), cursor.valueBuffer("colorseccion1"));
	flgraficos.iface.pub_colorearLabel(this.child("lblColorSeccion2"), cursor.valueBuffer("colorseccion2"));
	flgraficos.iface.pub_colorearLabel(this.child("lblColorSeccion3"), cursor.valueBuffer("colorseccion3"));
	flgraficos.iface.pub_colorearLabel(this.child("lblColorValor"), cursor.valueBuffer("colorvalor"));
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
