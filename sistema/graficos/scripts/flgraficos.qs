/***************************************************************************
                 flgraficos.qs  -  description
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
	function oficial( context ) { interna( context ); }
	function dameColor(color:String):Color {
		return this.ctx.oficial_dameColor(color);
	}
	function dameFuente(family:String, size:Number):Font {
		return this.ctx.oficial_dameFuente(family, size);
	}
	function dibujarGrafico(xmlGrafico:FLDomDocument, marco:Rect):Picture {
		return this.ctx.oficial_dibujarGrafico(xmlGrafico, marco);
	}
	function dameGraficoDefecto(tipoGrafico:String, subTipo:String):String {
		return this.ctx.oficial_dameGraficoDefecto(tipoGrafico, subTipo);
	}
	function colorearLabel(lblColor:Object, color:String):Boolean {
		return this.ctx.oficial_colorearLabel(lblColor, color);
	}
	function dameNodoXML(nodoPadre:FLDomNode, ruta:String, debeExistir:Boolean):FLDomNode {
		return this.ctx.oficial_dameNodoXML(nodoPadre, ruta, debeExistir);
	}
	function dameElementoXML(nodoPadre:FLDomNode, ruta:String, debeExistir:Boolean):FLDomElement {
		return this.ctx.oficial_dameElementoXML(nodoPadre, ruta, debeExistir);
	}
// 	function informarArrayGraficos(aGraficos:Array):Boolean {
// 		return this.ctx.oficial_informarArrayGraficos(aGraficos);
// 	}
// 	function nombreGrafico(idGrafico:String):String {
// 		return this.ctx.oficial_nombreGrafico(idGrafico);
// 	}
// 	function seleccionarGrafico():String {
// 		return this.ctx.oficial_seleccionarGrafico();
// 	}
	function elegirOpcion(opciones:Array, titulo:String):Number {
		return this.ctx.oficial_elegirOpcion(opciones, titulo);
	}
	function cargarTiposGrafico():Boolean {
		return this.ctx.oficial_cargarTiposGrafico();
	}
	function traducirAlineacion(alineacion:String):String {
		return this.ctx.oficial_traducirAlineacion(alineacion);
	}
	function formatearValor(valor:String, formato:String):String {
		return this.ctx.oficial_formatearValor(valor, formato);
	}
	function crearColoresIniciales() {
		return this.ctx.oficial_crearColoresIniciales();
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
	function pub_dameColor(color:String):Color {
		return this.dameColor(color);
	}
	function pub_dameFuente(family:String, size:Number):Font {
		return this.dameFuente(family, size);
	}
	function pub_dibujarGrafico(xmlGrafico:FLDomDocument, marco:Rect):Picture {
		return this.dibujarGrafico(xmlGrafico, marco);
	}
	function pub_dameGraficoDefecto(tipoGrafico:String, subTipo:String):String {
		return this.dameGraficoDefecto(tipoGrafico, subTipo);
	}
	function pub_colorearLabel(lblColor:Object, color:String):Boolean {
		return this.colorearLabel(lblColor, color);
	}
	function pub_dameNodoXML(nodoPadre:FLDomNode, ruta:String, debeExistir:Boolean):FLDomNode {
		return this.dameNodoXML(nodoPadre, ruta, debeExistir);
	}
	function pub_dameElementoXML(nodoPadre:FLDomNode, ruta:String, debeExistir:Boolean):FLDomElement {
		return this.dameElementoXML(nodoPadre, ruta, debeExistir);
	}
	function pub_traducirAlineacion(alineacion:String):String {
		return this.traducirAlineacion(alineacion);
	}
	function pub_formatearValor(valor:String, formato:String):String {
		return this.formatearValor(valor, formato);
	}
// 	function pub_seleccionarGrafico():String {
// 		return this.seleccionarGrafico();
// 	}
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
	if (!this.iface.cargarTiposGrafico()) {
		return false;
	}
	
	this.iface.crearColoresIniciales();
	
	return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_dameColor(color:String):Color
{
	var rgb:Array = new Array;
	if (!color || color == "") {
		rgb = [220, 220, 220];
	} else {
		rgb = color.split(",");
	}

	if (!rgb || rgb.length != 3) {
		debug("Error al obtener color " + color);
		rgb = [220, 220, 220];
	}

	var clr = new Color(); 
	clr.setRgb(rgb[0],rgb[1],rgb[2]);

	return clr;
}

function oficial_dameFuente(family:String, size:Number):Font
{
	var clf = new Font(); 
	if (!family || family == "") {
		family = "Arial";
	}
	if (!size || size == "") {
		size = 10;
	}
  
	clf.pointSize = size;
	clf.family = family;

	return clf;
}

function oficial_dibujarGrafico(xmlDatos:FLDomDocument, marco:Rect):Picture
{
	var util:FLUtil = new FLUtil;
	var pic:Picture;
	var eGrafico:FLDomElement = xmlDatos.firstChild().toElement();
	var tipoGrafico:String = eGrafico.attribute("Tipo");
	switch (tipoGrafico) {
		case "2d_barras": {
			pic = formgf_2dbarras.iface.pub_dibujarGrafico(xmlDatos, marco);
			break;
		}
		case "2d_tabla": {
			pic = formgf_2dtabla.iface.pub_dibujarGrafico(xmlDatos, marco);
			break;
		}
		case "lineal": {
			pic = formgf_lineal.iface.pub_dibujarGrafico(xmlDatos, marco);
			break;
		}
		case "1daguja": {
			pic = formgf_1daguja.iface.pub_dibujarGrafico(xmlDatos, marco);
			break;
		}
		case "2dtarta": {
			pic = formgf_2dtarta.iface.pub_dibujarGrafico(xmlDatos, marco);
			break;
		}
		case "2d_mapa": {
			pic = formRecordgf_2dmapa.iface.pub_dibujarGrafico(xmlDatos, marco);
			break;
		}
		case "informekut": {
			pic = formgf_informekut.iface.pub_dibujarGrafico(xmlDatos, marco);
			break;
		}
// 		case "2d_mapaproves": {
// 			pic = this.iface.dibujarGrafico2DMapaProvEs(xmlDatos);
// 			break;
// 		}
// 		case "2d_mapapaiseseu": {
// 			pic = this.iface.dibujarGrafico2DMapaPaisesEu(xmlDatos);
// 			break;
// 		}
		default: {
			MessageBox.warning(util.translate("scripts", "El gráfico tipo %1 no está registrado. No es posible mostrarlo.").arg(tipoGrafico), MessageBox.Ok, MessageBox.NoButton);
			pic = false;
		}
	}
	return pic;
}

function oficial_dameGraficoDefecto(tipoGrafico:String, subTipo:String):String
{
	var util:FLUtil = new FLUtil;
	var contenido:String;
	switch (tipoGrafico) {
		case "2d_barras": {
			contenido = util.sqlSelect("gf_2dbarras", "xml", "1 = 1");
			break;
		}
		case "2d_tabla": {
			contenido = util.sqlSelect("gf_2dtabla", "xml", "1 = 1");
			break;
		}
		case "informekut": {
			contenido = util.sqlSelect("gf_informekut", "xml", "1 = 1");
			break;
		}
		case "lineal": {
			contenido = util.sqlSelect("gf_lineal", "xml", "1 = 1");
			break;
		}
		case "1daguja": {
			contenido = util.sqlSelect("gf_1daguja", "xml", "1 = 1");
			break;
		}
		case "2dtarta": {
			contenido = util.sqlSelect("gf_2dtarta", "xml", "1 = 1");
			break;
		}
		case "2d_mapa": {
			contenido = util.sqlSelect("gf_2dmapa", "xml", "tabla = '" + subTipo + "'");
			break;
		}
		default: {
			MessageBox.warning(util.translate("scripts", "El gráfico tipo %1 no está registrado. No es posible obtener su formato por defecto.").arg(tipoGrafico), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}
	return contenido;
}

/** \D Rellena un label con el color indicado
@param	lblColor: Objeto label
@param	color: String en formato [0-255],[0-255],[0-255] (RGB)
\end */
function oficial_colorearLabel(lblColor:Object, color:String):Boolean
{
debug("color " + color);
	if (!color || color == undefined) {
		return false;
	}
	var colores:Array = color.split(",");
	if (!colores || colores.length != 3) {
		return false;
	}
	var clr = new Color();
	var pix = new Pixmap();
	var devSize = lblColor.size;
	pix.resize( devSize );
	clr.setRgb(colores[0], colores[1], colores[2]);
	pix.fill( clr );
	lblColor.pixmap = pix;
	return true;
}

function oficial_dameElementoXML(nodoPadre:FLDomNode, ruta:String, debeExistir:Boolean):FLDomElement
{
	var xmlNodo:FLDomNode = this.iface.dameNodoXML(nodoPadre, ruta, debeExistir);
	if (!xmlNodo) {
		return false;
	}
	return xmlNodo.toElement();
}

/** \C Busca un nodo en un nodo y sus nodos hijos
@param	nodoPadre: Nodo que contiene el nodo a buscar (o los nodos hijos que lo contienen)
@param	ruta: Cadena que especifica la ruta a seguir para encontrar el atributo. Su formato es NodoPadre/NodoHijo/NodoNieto/.../Nodo. Puede ser tan larga como sea necesario. Siempre se toma el primer nodo Hijo que tiene el nombre indicado.
@param	debeExistir: Si vale true la funci¨®n devuelve false si no encuentra el atributo
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
			nodoXML = nodoXML.namedItem(nombreActual);
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


/** \D Selecciona un tipo de gráfico de los disponibles
\d */
// function oficial_seleccionarGrafico():String
// {
// 	var util:FLUtil = new FLUtil;
// 	var cursor:FLSqlCursor = this.cursor();
// 
// 	var aGraficos:Array = [];
// 	this.iface.informarArrayGraficos(aGraficos);
// 	var aDesGraficos:Array = new Array(aGraficos.length);
// 	for (var i:Number = 0; i < aGraficos.length; i++) {
// 		aDesGraficos[i] = this.iface.nombreGrafico(aGraficos[i]);
// 	}
// 	var idOpcion:Number = this.iface.elegirOpcion(aDesGraficos, util.translate("scripts", "Seleccione gráfico"));
// debug("idOpcion = " + idOpcion);
// 	if (idOpcion < 0) {
// 		return false;
// 	}
// 	return aGraficos[idOpcion];
// }
// 
// function oficial_informarArrayGraficos(aGraficos:Array):Boolean
// {
// 	aGraficos[aGraficos.length] = "gf_2dbarras";
// 	aGraficos[aGraficos.length] = "gf_lineal"
// 	aGraficos[aGraficos.length] = "gf_informekut"
// 	return true;
// }
// 
// function oficial_nombreGrafico(idGrafico:String):String
// {
// 	var util:FLUtil = new FLUtil;
// 	var nombre:String;
// 	switch (idGrafico) {
// 		case "gf_2dbarras": {
// 			nombre = util.translate("scripts", "Barras");
// 			break;
// 		}
// 		case "gf_lineal": {
// 			nombre = util.translate("scripts", "Lineal");
// 			break;
// 		}
// 		case "gf_informekut": {
// 			nombre = util.translate("scripts", "Informe");
// 			break;
// 		}
// 	}
// 	return nombre;
// }

/** \D
Da a elegir al usuario entre una serie de opciones
@param	opciones: Array con las n opciones a elegir
@return	El Índice de la opción elegida si se pulsa Aceptar
		-1 si se pulsa Cancelar
		-2 si hay error
\end */
function oficial_elegirOpcion(opciones:Array, titulo:String):Number
{
	var util:FLUtil = new FLUtil();
	var dialog:Dialog = new Dialog;
	dialog.okButtonText = util.translate("scripts","Aceptar");
	dialog.cancelButtonText = util.translate("scripts","Cancelar");
	var bgroup:GroupBox = new GroupBox;
	bgroup.title = titulo;
	dialog.add(bgroup);
	var rB:Array = [];
	for (var i:Number = 0; i < opciones.length; i++) {
		rB[i] = new RadioButton;
		bgroup.add(rB[i]);
		rB[i].text = opciones[i];
		if (i == 0) {
			rB[i].checked = true;
		} else {
			rB[i].checked = false;
		}
	}

	if (dialog.exec()) {
		for (var i:Number = 0; i < opciones.length; i++) {
			if (rB[i].checked == true) {
				return i;
			}
		}
	} else {
		return -1;
	}
}

function oficial_cargarTiposGrafico():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = new FLSqlCursor("gf_tiposgrafico");
	var aTipos:Array =
		[["2d_barras", nombre = util.translate("scripts", "Barras")],
		["lineal", util.translate("scripts", "Lineal")],
		["gf_informekut", util.translate("scripts", "Informe")],
		["2d_tabla", util.translate("scripts", "Tabla")],
		["1daguja", util.translate("scripts", "Aguja")],
		["2d_mapa", util.translate("scripts", "Mapa")],
		["2dtarta", util.translate("scripts", "Tarta")]];
	for (var i:Number = 0; i < aTipos.length; i++) {
		with(cursor) {
			select("codtipografico = '" + aTipos[i][0] + "'");
			if (!first()) {
				setModeAccess(cursor.Insert);
				refreshBuffer();
				setValueBuffer("codtipografico", aTipos[i][0]);
				setValueBuffer("nombre", aTipos[i][1]);
				commitBuffer();
			}
		}
	}
	delete cursor;
	return true;
}

function oficial_traducirAlineacion(alineacion:String):String
{
	var util:FLUtil = new FLUtil;
	var traduccion:String;
	switch (alineacion) {
		case "AlignLeft": {
			valor = util.translate("scripts", "Izquierda");
			break;
		}
		case "AlignRight": {
			valor = util.translate("scripts", "Derecha");
			break;
		}
		case "AlignTop": {
			valor = util.translate("scripts", "Arriba");
			break;
		}
		case "AlignBottom": {
			valor = util.translate("scripts", "Abajo");
			break;
		}
		case "AlignHCenter":
		case "AlignVCenter":
		case "AlignCenter": {
			valor = util.translate("scripts", "Centro");
			break;
		}
	}
	return valor;
}

function oficial_formatearValor(valor:String, formato:String):String
{
// debug("Formateando " + valor + " con formato " + formato);
	if (!valor || valor == "") {
		return "";
	}

	var util:FLUtil = new FLUtil;
	var result:String = valor;

	var numero:Number = parseFloat(valor);
	var n:Number;
	switch(formato) {
		case "KM": {
			if (numero >= 1000000) {
				n = numero / 1000000;
				if (n == Math.round(n)) {
					result = n.toString().split(".")[0] + "M";
				} else {
					result = n.toString().split(".")[0] + "." + n.toString().split(".")[1].left(1) + "M";
				}
				break
			}
			if (numero >= 1000) {
				n = numero / 1000;
				result = n.toString().split(".")[0] + "K";
				break;
			}
			if (numero < 1000) {
				n = numero / 1000;
				if (n == Math.round(n)) {
					result = n.toString().split(".")[0] + "K";
				} else {
					result = n.toString().split(".")[0] + "." + n.toString().split(".")[1].left(1) + "K";
				}
				break
			}
			break;
		}
		case "Entero": {
			result = Math.round(valor);
			result = util.formatoMiles(result);
			break;
		}
		case "2D": {
			result = util.buildNumber(valor, "f", 2);
			result = util.formatoMiles(result);
			break;
		}
		default: {
			var longitud:Number = formato.length;
			var posComa:Number = formato.findRev(",");
			var numDec:Number = (posComa > -1 ? longitud - posComa - 1 : 0);
			result = util.buildNumber(valor, "f", numDec);
			if (formato.find(".") > -1) {
				result = util.formatoMiles(valorF);
			}
			break;
		}
	}
// debug("Valor formateado " + result);

	return result;
}

function oficial_crearColoresIniciales()
{

	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = new FLSqlCursor("gf_colores");
	var aColores:Array =
		[["Blue","0,0,255"],
		["Lime","0,255,0"],
		["Crimson","220,20,60"],
		["Gold","255,215,0"],
		["Fuchsia / Magenta","255,0,255"],
		["Silver","192,192,192"],
		["Indigo","75,0,130"],
		["Turquoise","64,224,208"],
		["Salmon","250,128,114"],
		["SpringGreen","0,255,127"],
		["MediumVioletRed","199,21,133"],
		["DarkBlue","0,0,139"],
		["Orange","255,165,0"],
		["SlateBlue","106,90,205"],
		["Yellow","255,255,0"],
		["DarkGreen","0,100,0"],
		["HotPink","255,105,180"],
		["Chartreuse","127,255,0"],
		["DarkViolet","148,0,211"],
		["SkyBlue","135,206,235"],
		["Red","255,0,0"],
		["YellowGreen","154,205,50"],
		["RosyBrown","188,143,143"],
		["Pink","255,192,203"],
		["BurlyWood","222,184,135"],
		["DarkKhaki","189,183,107"],
		["IndianRed","205,92,92"],
		["LightCoral","240,128,128"],
		["DarkSalmon","233,150,122"],
		["LightSalmon","255,160,122"],
		["FireBrick","178,34,34"],
		["DarkRed","139,0,0"],
		["LightPink","255,182,193"],
		["DeepPink","255,20,147"],
		["IndianRed","205,92,92"],
		["SandyBrown","244,164,96"],
		["PaleVioletRed","219,112,147"],
		["LightSalmon","255,160,122"],
		["Coral","255,127,80"],
		["Tomato","255,99,71"],
		["OrangeRed","255,69,0"],
		["DarkOrange","255,140,0"],
		["Goldenrod","218,165,32"],
		["LightYellow","255,255,224"],
		["LemonChiffon","255,250,205"],
		["LightGoldenrodYellow","250,250,210"],
		["PapayaWhip","255,239,213"],
		["Moccasin","255,228,181"],
		["PeachPuff","255,218,185"],
		["PaleGoldenrod","238,232,170"],
		["Khaki","240,230,140"],
		["Lavender","230,230,250"],
		["Thistle","216,191,216"],
		["Plum","221,160,221"],
		["Violet","238,130,238"],
		["Orchid","218,112,214"],
		["MediumOrchid","186,85,211"],
		["MediumPurple","147,112,219"],
		["BlueViolet","138,43,226"],
		["DarkOrchid","153,50,204"],
		["DarkMagenta","139,0,139"],
		["Purple","128,0,128"],
		["DarkSlateBlue","72,61,139"],
		["GreenYellow","173,255,47"],
		["LawnGreen","124,252,0"],
		["LimeGreen","50,205,50"],
		["PaleGreen","152,251,152"],
		["LightGreen","144,238,144"],
		["MediumSpringGreen","0,250,154"],
		["MediumSeaGreen","60,179,113"],
		["SeaGreen","46,139,87"],
		["ForestGreen","34,139,34"],
		["Green","0,128,0"],
		["OliveDrab","107,142,35"],
		["Olive","128,128,0"],
		["DarkOliveGreen","85,107,47"],
		["MediumAquamarine","102,205,170"],
		["DarkSeaGreen","143,188,143"],
		["LightSeaGreen","32,178,170"],
		["DarkCyan","0,139,139"],
		["Teal","0,128,128"],
		["Aqua/Cyan","0,255,255"],
		["LightCyan","224,255,255"],
		["PaleTurquoise","175,238,238"],
		["Aquamarine","127,255,212"],
		["MediumTurquoise","72,209,204"],
		["DarkTurquoise","0,206,209"],
		["CadetBlue","95,158,160"],
		["SteelBlue","70,130,180"],
		["LightSteelBlue","176,196,222"],
		["PowderBlue","176,224,230"],
		["LightBlue","173,216,230"],
		["LightSkyBlue","135,206,250"],
		["DeepSkyBlue","0,191,255"],
		["DodgerBlue","30,144,255"],
		["CornflowerBlue","100,149,237"],
		["MediumSlateBlue","123,104,238"],
		["RoyalBlue","65,105,225"],
		["MediumBlue","0,0,205"],
		["Navy","0,0,128"],
		["MidnightBlue","25,25,112"],
		["Cornsilk","255,248,220"],
		["BlanchedAlmond","255,235,205"],
		["Bisque","255,228,196"],
		["NavajoWhite","255,222,173"],
		["Wheat","245,222,179"],
		["Tan","210,180,140"],
		["DarkGoldenrod","184,134,11"],
		["Peru","205,133,63"],
		["Chocolate","210,105,30"],
		["SaddleBrown","139,69,19"],
		["Sienna","160,82,45"],
		["Brown","165,42,42"],
		["Maroon","128,0,0"],
		["White","255,255,255"],
		["Snow","255,250,250"],
		["Honeydew","240,255,240"],
		["MintCream","245,255,250"],
		["Azure","240,255,255"],
		["AliceBlue","240,248,255"],
		["GhostWhite","248,248,255"],
		["WhiteSmoke","245,245,245"],
		["Seashell","255,245,238"],
		["Beige","245,245,220"],
		["OldLace","253,245,230"],
		["FloralWhite","255,250,240"],
		["Ivory","255,255,240"],
		["AntiqueWhite","250,235,215"],
		["Linen","250,240,230"],
		["LavenderBlush","255,240,245"],
		["MistyRose","255,228,225"],
		["Gainsboro","220,220,220"],
		["LightGrey","211,211,211"],
		["DarkGray","169,169,169"],
		["Gray","128,128,128"],
		["DimGray","105,105,105"],
		["LightSlateGray","119,136,153"],
		["SlateGray","112,128,144"],
		["DarkSlateGray","47,79,79"],
		["Black","0,0,0"]];
		
	var rgb:Array = [];
	var orden:Number = 1;
	for (var i:Number = 0; i < aColores.length; i++) {
		with(cursor) {
			select("rgb = '" + aColores[i][1] + "'");
			if (!first()) {
				rgb = [];
				rgb = aColores[i][1].split(",");
				setModeAccess(cursor.Insert);
				refreshBuffer();
				setValueBuffer("nombre", aColores[i][0]);
				setValueBuffer("r", rgb[0]);
				setValueBuffer("g", rgb[1]);
				setValueBuffer("b", rgb[2]);
				setValueBuffer("rgb", aColores[i][1]);
				setValueBuffer("orden", orden);
				setValueBuffer("hex",formRecordgf_colores.iface.pub_obtenerColorHexadecimal(aColores[i][1]));
				orden++;
				commitBuffer();
			}
		}
	}
	
	delete cursor;
	return true;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
