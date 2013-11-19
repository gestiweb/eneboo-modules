/***************************************************************************
                 fldireinne.qs  -  description
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
	function init() { this.ctx.interna_init(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	function oficial( context ) { interna( context );}
	function valorConfiguracion(campo:String):String {
		return this.ctx.oficial_valorConfiguracion(campo);
	}
	function elegirOpcion(opciones:Array, titulo:String):Number {
		return this.ctx.oficial_elegirOpcion(opciones, titulo);
	}
	function dameNodoXML(nodoPadre:FLDomNode, ruta:String, debeExistir:Boolean):FLDomNode {
		return this.ctx.oficial_dameNodoXML(nodoPadre, ruta, debeExistir);
	}
	function colorearLabel(lblColor:Object, color:String):Boolean {
		return this.ctx.oficial_colorearLabel(lblColor, color);
	}
	function obtenerTraduccionAlias(valorAlias:String):String {
		return this.ctx.oficial_obtenerTraduccionAlias(valorAlias);
	}
	function metadatosTabla(tabla:String):FLDomDocument {
		return this.ctx.oficial_metadatosTabla(tabla);
	}
	function valorEnLista(valor:String, lista:Array):Boolean {
		return this.ctx.oficial_valorEnLista(valor, lista);
	}
	function cargarTablaAgregada(curAgregada:String, xmlMetadatos:FLDomDocument):Number {
		return this.ctx.oficial_cargarTablaAgregada(curAgregada, xmlMetadatos);
	}
	function dameColor(sColor:String):Color {
		return this.ctx.oficial_dameColor(sColor);
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
	function pub_valorConfiguracion(campo:String):String {
		return this.valorConfiguracion(campo);
	}
	function pub_elegirOpcion(opciones:Array, titulo:String):Number {
		return this.elegirOpcion(opciones, titulo);
	}
	function pub_dameNodoXML(nodoPadre:FLDomNode, ruta:String, debeExistir:Boolean):FLDomNode {
		return this.dameNodoXML(nodoPadre, ruta, debeExistir);
	}
	function pub_colorearLabel(lblColor:Object, color:String):Boolean {
		return this.colorearLabel(lblColor, color);
	}
	function pub_obtenerTraduccionAlias(valorAlias:String):String {
		return this.obtenerTraduccionAlias(valorAlias);
	}
	function pub_metadatosTabla(tabla:String):FLDomDocument {
		return this.metadatosTabla(tabla);
	}
	function pub_valorEnLista(valor:String, lista:Array):Boolean {
		return this.valorEnLista(valor, lista);
	}
	function pub_cargarTablaAgregada(curAgregada:String, xmlMetadatos:FLDomDocument):Number {
		return this.cargarTablaAgregada(curAgregada, xmlMetadatos);
	}
	function pub_dameColor(sColor:String):Color {
		return this.dameColor(sColor);
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
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_valorConfiguracion(campo:String):String
{
	var util:FLUtil = new FLUtil;
	valor = util.sqlSelect("in_config", campo, "1 = 1");
	return valor;
}

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

function oficial_dameColor(sColor:String):Color
{
	var colores:Array = sColor.split(",");
	if (!colores || colores.length != 3) {
		return false;
	}
	var clr = new Color();
	clr.setRgb(colores[0], colores[1], colores[2]);
	return clr;
}
/** \D Rellena un label con el color indicado
@param	lblColor: Objeto label
@param	color: String en formato [0-255],[0-255],[0-255] (RGB)
\end */
function oficial_colorearLabel(lblColor:Object, color:String):Boolean
{
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

/** \D Parsea un texto con formato QT_TRANSLATE_NOOP('entorno', 'cadena') y busca la traducción de cadena en entorno
@param	valorAlias: Valor de la cadena contenida en el atributo Alias
@return	Cadena traducida
\end */
function oficial_obtenerTraduccionAlias(valorAlias:String):String
{
	if (!valorAlias || valorAlias == "") {
		return "";
	}
	var util:FLUtil = new FLUtil;
	var valor:String;
	if (valorAlias.find("QT_TRANSLATE_NOOP") >= 0) {
		var iComillaFin:Number = valorAlias.findRev("\"");
		if (iComillaFin < 0) {
			iComillaFin = valorAlias.findRev("'");
		}
		var iComillaIni:Number = valorAlias.findRev("\"", iComillaFin - 1);
		if (iComillaIni < 0) {
			iComillaIni = valorAlias.findRev("'", iComillaFin - 1);
		}
		valor = valorAlias.substring(iComillaIni + 1, iComillaFin);
	} else {
		valor = valorAlias;
	}
	return valor;
}

/** \D Obtiene un documento XML con los metadatos de una tabla
@param	tabla: Nombre de la tabla
@return	Documento XML de metadatos
\end */
function oficial_metadatosTabla(tabla:String):FLDomDocument
{
	var util:FLUtil = new FLUtil;

	var xmlMetadatos:FLDomDocument = new FLDomDocument;
	contenido = util.sqlSelect("flfiles", "contenido", "nombre = '" + tabla + ".mtd'");
	if (!contenido || contenido == "") {
		return false;
	}
	if (!xmlMetadatos.setContent(contenido)) {
		return false;
	}
	return xmlMetadatos;
}

function oficial_valorEnLista(valor:String, lista:Array):Boolean
{
	for (var i:Number = 0; i < lista.length; i++) {
		if (valor == lista[i]) {
			return true;
		}
	}
	return false;
}

/** \D Repuebla una tabla agregada
@param	curAgregada: Cursor en in_agregadas que contiene los datos de la tabla agregada
@param	xmlMetadatos: Metadatos del cubo completo (opcional)
@return	Número de registros cargados. -1 si hay error.
\end */
function oficial_cargarTablaAgregada(curAgregada:String, xmlMetadatos:FLDomDocument):Number
{
	var util:FLUtil = new FLUtil;

	var tabla:String = curAgregada.valueBuffer("fichero");
	var cubo:String = curAgregada.valueBuffer("cubo");

	if (!xmlMetadatos) {
		xmlMetadatos = fldireinne.iface.pub_metadatosTabla(cubo);
		if (!xmlMetadatos) {
			return -1;
		}
	}

	var agrupacion:String, campos:String, contenido:String, nombreCampo:String;
	var aMedidas:Array = [], aAgrupacion:Array = [];
	var iMedida:Number = 0, iAgrupacion:Number = 0;
	var dim:String = curAgregada.valueBuffer("lista");
	var aDim:Array = dim.split(",");
	for (var nodoField:FLDomNode = xmlMetadatos.namedItem("TMD").firstChild(); nodoField; nodoField = nodoField.nextSibling()) {
		switch (nodoField.nodeName()) {
			case "field": {
				nodoName = nodoField.namedItem("name");
				if (!nodoName) {
					return -1;
				}
				nombreCampo = nodoName.firstChild().nodeValue();
				if (nombreCampo.startsWith("d_")) {
					if (!fldireinne.iface.pub_valorEnLista(nombreCampo, aDim)) {
						aAgrupacion[iAgrupacion++] = nombreCampo;
					}
				}
				if (nombreCampo.startsWith("m_")) {
					aMedidas[iMedida++] = nombreCampo;
				}
				break;
			}
		}
	}
	var curTabla:FLSqlCursor = new FLSqlCursor(tabla);
	curTabla.setActivatedCheckIntegrity(false);
	curTabla.select();
	while (curTabla.next()) {
		curTabla.setModeAccess(curTabla.Del);
		curTabla.refreshBuffer();
		if (!curTabla.commitBuffer()) {
			return -1;
		}
	}

	var totalMed:Number = aMedidas.length;
	var listaMedidas:String = "";
	for (var i:Number = 0; i < totalMed; i++) {
		listaMedidas += (i > 0 ? ", " : "") + "SUM(" + aMedidas[i] + ")";
	}
	var totalDim:Number = aDim.length;
	var listaDim:String = aDim.join(", ");
	var select:String = listaMedidas + listaDim;

	var listaAgrupacion:String = aAgrupacion.join(", ");
	if (!listaAgrupacion || listaAgrupacion == "") {
		return false;
	}

	var qryCubo:FLSqlQuery = new FLSqlQuery;
	qryCubo.setTablesList(cubo);
	qryCubo.setSelect(select);
	qryCubo.setFrom(cubo);
	qryCubo.setWhere("1 = 1 GROUP BY " + listaAgrupacion);
	qryCubo.setForwardOnly(true);
	if (!qryCubo.exec()) {
		return -1;
	}
	var totalReg:Number = qryCubo.size();
	var numRegistros:Number = 0;
	util.createProgressDialog(util.translate("scripts", "Cargando tabla agregada %1").arg(tabla), totalReg);
	util.setProgress(numRegistros);
	while (qryCubo.next()) {
		curTabla.setModeAccess(curTabla.Insert);
		curTabla.refreshBuffer();
		for (var i:Number = 0; i < totalMed; i++) {
			curTabla.setValueBuffer(aMedidas[i], qryCubo.value(i));
		}
		for (var i:Number = 0; i < totalDim; i++) {
			curTabla.setValueBuffer(aDim[i], qryCubo.value(aDim[i]));
		}
		if (!curTabla.commitBuffer()) {
			util.destroyProgressDialog();
			return -1;
		}
		util.setProgress(++numRegistros);
	}
	util.destroyProgressDialog();
	return numRegistros;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
