/***************************************************************************
                 in_eje.qs  -  description
                             -------------------
    begin                : jue sep 01 2009
    copyright            : (C) 2009 by InfoSiAL S.L.
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
	var COL_E_NIVEL:Number;
	var COL_E_NOMBRE:Number;
	var COL_E_ORDEN:Number;
	var COL_N_NIVEL:Number;
	var COL_N_NOMBRE:Number;
	var COL_PE_ID:Number;
	var COL_PE_IDNIVEL:Number;
	var COL_PE_ALIAS:Number;
	var COL_PE_ORDEN:Number;
	var COL_P_ID:Number;
	var COL_P_IDNIVEL:Number;
	var COL_P_ALIAS:Number;
	
	var tblNiveles_:FLTable;
	var tblEje_:FLTable;
	var tblPropiedades_:FLTable;
	var tblPropsEje_:FLTable;
	
	var aPropNivelSel_:Array /// Array con las propiedades seleccionadas por nivel
	var xmlProps_:FLDomDocument;

	function oficial( context ) { interna( context );}
	function cargarDatos() {
		return this.ctx.oficial_cargarDatos();
	}
	function tbnPonerNivel_clicked() {
		return this.ctx.oficial_tbnPonerNivel_clicked();
	}
	function tbnPonerProp_clicked() {
		return this.ctx.oficial_tbnPonerProp_clicked();
	}
	function ponerNivel(filaNivel:Number, filaEje:Number):Boolean {
		return this.ctx.oficial_ponerNivel(filaNivel, filaEje);
	}
	function ponerProp(filaNivel:Number, filaEje:Number):Boolean {
		return this.ctx.oficial_ponerProp(filaNivel, filaEje);
	}
	function tbnQuitarNivel_clicked() {
		return this.ctx.oficial_tbnQuitarNivel_clicked();
	}
	function tbnQuitarProp_clicked() {
		return this.ctx.oficial_tbnQuitarProp_clicked();
	}
	function limpiarTablasProp() {
		return this.ctx.oficial_limpiarTablasProp();
	}
	function quitarNivel(filaEje:Number, filaNivel:Number):Boolean {
		return this.ctx.oficial_quitarNivel(filaEje, filaNivel);
	}
	function quitarProp(filaEje:Number, filaProp:Number):Boolean {
		return this.ctx.oficial_quitarProp(filaEje, filaProp);
	}
	function tblNiveles_doubleClicked(fila:Number, col:Number) {
		return this.ctx.oficial_tblNiveles_doubleClicked(fila, col);
	}
	function tblPropiedades_doubleClicked(fila:Number, col:Number) {
		return this.ctx.oficial_tblPropiedades_doubleClicked(fila, col);
	}
	function tblEje_doubleClicked(fila:Number, col:Number) {
		return this.ctx.oficial_tblEje_doubleClicked(fila, col);
	}
	function tblPropsEje_doubleClicked(fila:Number, col:Number) {
		return this.ctx.oficial_tblPropsEje_doubleClicked(fila, col);
	}
	function cambiarOrdenNivel(fila:Number, col:Number, tabla:FLTable) {
		return this.ctx.oficial_cambiarOrdenNivel(fila, col, tabla);
	}
	function tbnSubirNivel_clicked() {
		return this.ctx.oficial_tbnSubirNivel_clicked();
	}
	function tbnBajarNivel_clicked() {
		return this.ctx.oficial_tbnBajarNivel_clicked();
	}
	function tbnSubirProp_clicked() {
		return this.ctx.oficial_tbnSubirProp_clicked();
	}
	function tbnBajarProp_clicked() {
		return this.ctx.oficial_tbnBajarProp_clicked();
	}
	function cambiarIndicesPropsSel(fila1:Number, fila2:Number):Boolean {
		return this.ctx.oficial_cambiarIndicesPropsSel(fila1, fila2);
	}
	function dameElementoPropSel(idProp:String, idNivel:String):FLDomElement {
		return this.ctx.oficial_dameElementoPropSel(idProp, idNivel);
	}
	function aceptar() {
		return this.ctx.oficial_aceptar();
	}
	function guardarDatos() {
		return this.ctx.oficial_guardarDatos();
	}
	function nivelIncluidoEje(idNivel:String):Boolean {
		return this.ctx.oficial_nivelIncluidoEje(idNivel);
	}
	function cargarPropsNivel(eNivel:FLDomElement):Boolean {
		return this.ctx.oficial_cargarPropsNivel(eNivel);
	}
	function incluirPropSel(idNivel:String, eProp:FLDomElement):Boolean {
		return this.ctx.oficial_incluirPropSel(idNivel, eProp);
	}
	function excluirPropSel(idNivel:String, idProp:String):Boolean {
		return this.ctx.oficial_excluirPropSel(idNivel, idProp);
	}
	function dameAliasProp(idNivel:String, idProp:String):String {
		return this.ctx.oficial_dameAliasProp(idNivel, idProp);
	}
	function guardarAtributoPropSel(idNivel:String, idProp:String, atributo:String, valor:String):Boolean {
		return this.ctx.oficial_guardarAtributoPropSel(idNivel, idProp, atributo, valor);
	}
	function dameArrayPropSel(idNivel:String):Array {
		return this.ctx.oficial_dameArrayPropSel(idNivel);
	}
	function mostrarPropsSelNivel():Boolean {
		return this.ctx.oficial_mostrarPropsSelNivel();
	}
	function ordenarPropsSel(eProp1:FLDomElement, eProp2:FLDomElement):Number {
		return this.ctx.oficial_ordenarPropsSel(eProp1, eProp2);
	}
	function mostrarPropsNivel():Boolean {
		return this.ctx.oficial_mostrarPropsNivel();
	}
	function propIncluidaEje(idProp:String):Boolean {
		return this.ctx.oficial_propIncluidaEje(idProp);
	}
	function tblEje_currentChanged(fila:Number, col:Number) {
		return this.ctx.oficial_tblEje_currentChanged(fila, col);
	}
	function habilitarPropiedades() {
		return this.ctx.oficial_habilitarPropiedades();
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
debug("interna_init");
	var cursor:FLSqlCursor = this.cursor();

	this.iface.tblNiveles_ = this.child("tblNiveles");
	this.iface.tblEje_ = this.child("tblEje");
	this.iface.tblPropiedades_ = this.child("tblPropiedades");
	this.iface.tblPropsEje_ = this.child("tblPropsEje");
	this.iface.aPropNivelSel_ = [];
	
	this.iface.xmlProps_ = new FLDomDocument;

	disconnect (this.child("pushButtonAccept"), "clicked()", this, "accept");
	connect (this.child("pushButtonAccept"), "clicked()", this, "iface.aceptar");
	connect (this.child("tbnPonerNivel"), "clicked()", this, "iface.tbnPonerNivel_clicked");
	connect (this.child("tbnPonerProp"), "clicked()", this, "iface.tbnPonerProp_clicked");
	connect (this.child("tbnQuitarNivel"), "clicked()", this, "iface.tbnQuitarNivel_clicked");
	connect (this.child("tbnQuitarProp"), "clicked()", this, "iface.tbnQuitarProp_clicked");
	connect (this.child("tbnSubirNivel"), "clicked()", this, "iface.tbnSubirNivel_clicked");
	connect (this.child("tbnBajarNivel"), "clicked()", this, "iface.tbnBajarNivel_clicked");
	connect (this.child("tbnSubirProp"), "clicked()", this, "iface.tbnSubirProp_clicked");
	connect (this.child("tbnBajarProp"), "clicked()", this, "iface.tbnBajarProp_clicked");
	connect (this.iface.tblNiveles_, "doubleClicked(int, int)", this, "iface.tblNiveles_doubleClicked");
	connect (this.iface.tblPropiedades_, "doubleClicked(int, int)", this, "iface.tblPropiedades_doubleClicked");
	connect (this.iface.tblEje_, "doubleClicked(int, int)", this, "iface.tblEje_doubleClicked");
	connect (this.iface.tblPropsEje_, "doubleClicked(int, int)", this, "iface.tblPropsEje_doubleClicked");
	disconnect (this.iface.tblEje_, "currentChanged(int, int)", this, "iface.tblEje_currentChanged");
	this.iface.cargarDatos();
	connect (this.iface.tblEje_, "currentChanged(int, int)", this, "iface.tblEje_currentChanged");
	
	this.iface.habilitarPropiedades();
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_habilitarPropiedades()
{
	var cursor:FLSqlCursor = this.cursor();
	var eje:String = cursor.valueBuffer("eje");
	if (eje == "Y") {
		this.child("gbxPropiedades").show();
	} else {
		this.child("gbxPropiedades").close();
	}
}

function oficial_tblEje_currentChanged(fila:Number, col:Number)
{
	debug("oficial_tblEje_currentChanged");
	this.iface.mostrarPropsSelNivel();
	this.iface.mostrarPropsNivel();
}

function oficial_cargarPropsNivel(eNivel:FLDomElement):Boolean
{
	var idNivel:String = eNivel.attribute("Id");
	var aPropsSel:Array = this.iface.dameArrayPropSel(idNivel);
	var nodoProps:FLDomNode = eNivel.namedItem("Propiedades");
	if (!nodoProps) {
		return true;
	}
	var eProp:FLDomElement;
	for (var nodoProp:FLDomNode = nodoProps.firstChild(); nodoProp; nodoProp = nodoProp.nextSibling()) {
		eProp = nodoProp.toElement();
		if (!this.iface.incluirPropSel(idNivel, eProp)) {
			return false;
		}
	}
	
// 	debug("Propiedades para " + idNivel);
// 	for (var i:Number = 0; i < aPropsSel.length; i++) { debug(aPropsSel[i].attribute("Id") + ", "); }
	
	return true;
}

function oficial_incluirPropSel(idNivel:String, eProp:FLDomElement):Boolean
{
	var aPropsSel:Array = this.iface.dameArrayPropSel(idNivel);
	eProp.setAttribute("Indice", aPropsSel.length);
	aPropsSel.push(eProp);
	
	return true;
}

function oficial_excluirPropSel(idNivel:String, idProp:String):Boolean
{
	var aPropsSel:Array = this.iface.dameArrayPropSel(idNivel);
	if (!aPropsSel) {
		return false;
	}
	var i:Number;
	for (i = 0; i < aPropsSel.length; i++) {
		if (aPropsSel[i].attribute("Id") == idProp) {
			break;
		}
	}
	if (i < aPropsSel.length) {
		aPropsSel.splice(i, 1); /// Borra el elemento de la posición i
	}
	return true;
}

function oficial_dameAliasProp(idNivel:String, idProp:String):String
{
	var aNiveles:Array = formin_navegador.iface.niveles_;
	var aProps:Array = aNiveles[idNivel]["propiedades"];
	if (!aProps || aProps.length == 0) {
		return false;
	}
	var i:Number;
	var alias:String = false;
	for (i = 0; i < aProps.length; i++) {
		if (aProps[i].attribute("Id") == idProp) {
			alias = aProps[i].attribute("Alias");
			break;
		}
	}
	return alias;
}


function oficial_guardarAtributoPropSel(idNivel:String, idProp:String, atributo:String, valor:String):Boolean
{
	var aPropsSel:Array = this.iface.dameArrayPropSel(idNivel);
	if (!aPropsSel) {
		return false;
	}
	var i:Number;
	for (i = 0; i < aPropsSel.length; i++) {
		if (aPropsSel[i].attribute("Id") == idProp) {
			aPropsSel[i].setAttribute(atributo, valor);
			break;
		}
	}
	return true;
}

function oficial_dameArrayPropSel(idNivel:String):Array
{
	var aPropSel:Array;
	try {
		aPropSel = this.iface.aPropNivelSel_[idNivel];
	} catch(e) {
		this.iface.aPropNivelSel_[idNivel] = new Array(0);
		aPropSel = this.iface.aPropNivelSel_[idNivel];
	}
	return aPropSel;
}

function oficial_mostrarPropsSelNivel():Boolean
{
debug("oficial_mostrarPropsSelNivel ");
	var aNiveles:Array = formin_navegador.iface.niveles_;
	this.iface.tblPropsEje_.setNumRows(0);
	
	var filaSelNivel:Number = this.iface.tblEje_.currentRow();
	if (filaSelNivel == undefined) {
		return true;
	}
	var idNivel:String = this.iface.tblEje_.text(filaSelNivel, this.iface.COL_E_NIVEL);
	var aPropsSel:Array = this.iface.dameArrayPropSel(idNivel);
	aPropsSel.sort(this.iface.ordenarPropsSel);
	var eProp:FLDomElement;
	for (var i:Number = 0; i < aPropsSel.length; i++) {
		eProp = aPropsSel[i];
		this.iface.tblPropsEje_.insertRows(i);
		this.iface.tblPropsEje_.setText(i, this.iface.COL_PE_ID, eProp.attribute("Id"));
		this.iface.tblPropsEje_.setText(i, this.iface.COL_PE_IDNIVEL, idNivel);
		this.iface.tblPropsEje_.setText(i, this.iface.COL_PE_ALIAS, this.iface.dameAliasProp(idNivel, eProp.attribute("Id")));
		this.iface.tblPropsEje_.setText(i, this.iface.COL_PE_ORDEN, eProp.attribute("Orden"));
	}
	return true;
}

function oficial_ordenarPropsSel(eProp1:FLDomElement, eProp2:FLDomElement):Number
{
	var res:Number = 0;
	if (parseInt(eProp1.attribute("Indice")) > parseInt(eProp2.attribute("Indice"))) {
		res = 1;
	} else if (parseInt(eProp1.attribute("Indice")) < parseInt(eProp2.attribute("Indice"))) {
		res = -1;
	}
	return res;
}

function oficial_cargarDatos()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
debug("oficial_cargarDatos");
	this.iface.tblEje_.setNumCols(3);
	this.iface.COL_E_NIVEL = 0;
	this.iface.COL_E_NOMBRE = 1;
	this.iface.COL_E_ORDEN = 2;
	this.iface.tblEje_.hideColumn(this.iface.COL_E_NIVEL);
	this.iface.tblEje_.setColumnLabels("*", util.translate("scripts", "Nivel") + "*" + util.translate("scripts", "Nivel") + "*" + util.translate("scripts", "Orden"));
	
	this.iface.tblPropsEje_.setNumCols(4);
	this.iface.COL_PE_ID = 0;
	this.iface.COL_PE_IDNIVEL = 1;
	this.iface.COL_PE_ALIAS = 2;
	this.iface.COL_PE_ORDEN = 3;
	this.iface.tblPropsEje_.hideColumn(this.iface.COL_PE_ID);
	this.iface.tblPropsEje_.hideColumn(this.iface.COL_PE_IDNIVEL);
	this.iface.tblPropsEje_.hideColumn(this.iface.COL_PE_ORDEN); /// Por ahora no permitimos ordenar por propiedades (hay que tocar la consulta)
	this.iface.tblPropsEje_.setColumnLabels("*", util.translate("scripts", "Propiedad") + "*" + util.translate("scripts", "Nivel") + "*" + util.translate("scripts", "Propiedad") + "*" + util.translate("scripts", "Orden"));
	
	var xmlPos:FLDomNode = formin_navegador.iface.xmlPosActual_.firstChild();
	var aNiveles:Array = formin_navegador.iface.niveles_;
	var aINiveles:Array = formin_navegador.iface.iNiveles_;

	var idNivel:String;
	var eje:String = cursor.valueBuffer("eje");
debug("eje = " + eje);
	var ejeOpuesto:String = (eje == "X" ? ejeOpuesto = "Y" : ejeOpuesto = "X");

	var nodoY:FLDomNode = xmlPos.namedItem("Dimensiones").namedItem(eje);
	var listaNiveles:FLDomNodeList = nodoY.toElement().elementsByTagName("Nivel");
	if (listaNiveles) {
		var eNivel:FLDomElement;
		for (var i:Number = 0; i < listaNiveles.length(); i++) {
			eNivel = listaNiveles.item(i).toElement();
			idNivel = eNivel.attribute("Id");
			this.iface.tblEje_.insertRows(i);
			this.iface.tblEje_.setText(i, this.iface.COL_E_NIVEL, idNivel);
			this.iface.tblEje_.setText(i, this.iface.COL_E_NOMBRE, aNiveles[idNivel]["element"].attribute("alias"));
			this.iface.tblEje_.setText(i, this.iface.COL_E_ORDEN, eNivel.attribute("Orden"));
			this.iface.cargarPropsNivel(eNivel);
		}
	}

	this.iface.tblPropiedades_.setNumCols(3);
	this.iface.COL_P_ID = 0;
	this.iface.COL_P_IDNIVEL = 1;
	this.iface.COL_P_ALIAS = 2;
	this.iface.tblPropiedades_.hideColumn(this.iface.COL_P_ID);
	this.iface.tblPropiedades_.hideColumn(this.iface.COL_P_IDNIVEL);
	this.iface.tblPropiedades_.setColumnLabels("*", util.translate("scripts", "Propiedad") + "*" + util.translate("scripts", "Nivel") + "*" + util.translate("scripts", "Propiedad"));
	
	this.iface.tblNiveles_.setNumCols(2);
	this.iface.COL_N_NIVEL = 0;
	this.iface.COL_N_NOMBRE = 1;
	this.iface.tblNiveles_.hideColumn(this.iface.COL_N_NIVEL);
	this.iface.tblNiveles_.setColumnLabels("*", util.translate("scripts", "Nivel") + "*" + util.translate("scripts", "Nivel"));
	var iFila:Number = 0;
	for (var i:Number = 0; i < aINiveles.length; i++) {
		idNivel = aINiveles[i];
		if (this.iface.nivelIncluidoEje(idNivel)) {
			continue;
		}
		this.iface.tblNiveles_.insertRows(iFila);
		this.iface.tblNiveles_.setText(iFila, this.iface.COL_N_NIVEL, idNivel);
		this.iface.tblNiveles_.setText(iFila, this.iface.COL_N_NOMBRE, aNiveles[idNivel]["element"].attribute("alias")); //aNiveles[idNivel]["element"].attribute("name"));
		iFila++;
	}
	this.iface.tblEje_currentChanged();
}

function oficial_mostrarPropsNivel():Boolean
{
	var util:FLUtil = new FLUtil;
	
	var aNiveles:Array = formin_navegador.iface.niveles_;
	this.iface.tblPropiedades_.setNumRows(0);
	
	var filaSelNivel:Number = this.iface.tblEje_.currentRow();
	if (filaSelNivel < 0) {
		this.child("gbxPropiedades").title = util.translate("scrips", "Propiedades");
		return true;
	}
debug("filaSelNivel " + filaSelNivel );
	var idNivel:String = this.iface.tblEje_.text(filaSelNivel, this.iface.COL_E_NIVEL);
	if (!idNivel || idNivel == 0) {
		this.child("gbxPropiedades").title = util.translate("scrips", "Propiedades");
		return true;
	}
	this.child("gbxPropiedades").title = util.translate("scrips", "Propiedades de %1").arg(this.iface.tblEje_.text(filaSelNivel, this.iface.COL_E_NOMBRE));
	
	var aProps:Array = aNiveles[idNivel]["propiedades"];
	var aPropsSel:Array = this.iface.dameArrayPropSel(idNivel);
	var eProp:FLDomElement;
	var iFila:Number = 0;
	for (var i:Number = 0; i < aProps.length; i++) {
		eProp = aProps[i];
		if (this.iface.propIncluidaEje(eProp.attribute("Id"))) {
			continue;
		}
		this.iface.tblPropiedades_.insertRows(iFila);
		this.iface.tblPropiedades_.setText(iFila, this.iface.COL_P_ID, eProp.attribute("Id"));
		this.iface.tblPropiedades_.setText(iFila, this.iface.COL_P_IDNIVEL, idNivel);
		this.iface.tblPropiedades_.setText(iFila, this.iface.COL_P_ALIAS, eProp.attribute("Alias"));
		iFila++;
	}
	return true;
}

/** Indica si la propiedad está ya incluida en la tabla Eje Props
@param	idProp: Identificador de la propiedad
\end */
function oficial_propIncluidaEje(idProp:String):Boolean
{
	var filas:Number = this.iface.tblPropsEje_.numRows();
	for (var i:Number = 0; i < filas; i++) {
		if (this.iface.tblPropsEje_.text(i, this.iface.COL_PE_ID) == idProp) {
			return true;
		}
	}
	return false;
}


function oficial_tbnSubirNivel_clicked()
{
	var fila:Number = this.iface.tblEje_.currentRow();
	if (!fila || fila == 0) {
		return;
	}
	var siguienteFila:Number = fila - 1;
	this.iface.tblEje_.swapRows(fila, siguienteFila);
	this.iface.tblEje_.repaintContents();
	this.iface.tblEje_.clearSelection();
	this.iface.tblEje_.selectRow(siguienteFila);
}

function oficial_tbnSubirProp_clicked()
{
	var fila:Number = this.iface.tblPropsEje_.currentRow();
	if (!fila || fila == 0) {
		return;
	}
	var siguienteFila:Number = fila - 1;
	
	this.iface.cambiarIndicesPropsSel(fila, siguienteFila);
	
	this.iface.tblPropsEje_.swapRows(fila, siguienteFila);
	this.iface.tblPropsEje_.repaintContents();
	this.iface.tblPropsEje_.clearSelection();
	this.iface.tblPropsEje_.selectRow(siguienteFila);
}

function oficial_cambiarIndicesPropsSel(fila1:Number, fila2:Number):Boolean
{
	var idNivel:String = this.iface.tblPropsEje_.text(fila1, this.iface.COL_PE_IDNIVEL);
	var idProp1:String = this.iface.tblPropsEje_.text(fila1, this.iface.COL_PE_ID);
	var idProp2:String = this.iface.tblPropsEje_.text(fila2, this.iface.COL_PE_ID);
	
	var eProp1:FLDomElement = this.iface.dameElementoPropSel(idProp1, idNivel);
	if (!eProp1) {
		return false;
	}
	var eProp2:FLDomElement = this.iface.dameElementoPropSel(idProp2, idNivel);
	if (!eProp2) {
		return false;
	}
	var indiceAux:Number = eProp1.attribute("Indice");
	eProp1.setAttribute("Indice", eProp2.attribute("Indice"));
	eProp2.setAttribute("Indice", indiceAux);
	
	return true;
}

function oficial_dameElementoPropSel(idProp:String, idNivel:String):FLDomElement
{
	var aPropsSel:Array = this.iface.dameArrayPropSel(idNivel);
	if (!aPropsSel) {
		return false;
	}
	var canProps:Number = aPropsSel.length;
	var eProp:FLDomElement = false;
	for (var i:Number = 0; i < canProps; i++) {
		if (aPropsSel[i].attribute("Id") == idProp) {
			eProp = aPropsSel[i];
			break;
		}
	}
	return eProp;
}

function oficial_tbnBajarNivel_clicked()
{
	var fila:Number = this.iface.tblEje_.currentRow();
	var totalFilas:Number = this.iface.tblEje_.numRows();
	if (isNaN(fila) || fila == (totalFilas - 1)) {
		return;
	}
	var siguienteFila:Number = fila + 1;
	this.iface.tblEje_.swapRows(fila, siguienteFila);
	this.iface.tblEje_.repaintContents();
	this.iface.tblEje_.clearSelection();
	this.iface.tblEje_.selectRow(siguienteFila);
}

function oficial_tbnBajarProp_clicked()
{
	var fila:Number = this.iface.tblPropsEje_.currentRow();
	var totalFilas:Number = this.iface.tblPropsEje_.numRows();
	if (isNaN(fila) || fila == (totalFilas - 1)) {
		return;
	}
	var siguienteFila:Number = fila + 1;
	
	this.iface.cambiarIndicesPropsSel(fila, siguienteFila);
	
	this.iface.tblPropsEje_.swapRows(fila, siguienteFila);
	this.iface.tblPropsEje_.repaintContents();
	this.iface.tblPropsEje_.clearSelection();
	this.iface.tblPropsEje_.selectRow(siguienteFila);
}

function oficial_tblNiveles_doubleClicked(fila:Number, col:Number)
{
	this.iface.tbnPonerNivel_clicked();
}

function oficial_tblPropiedades_doubleClicked(fila:Number, col:Number)
{
	this.iface.tbnPonerProp_clicked();
}

function oficial_tblEje_doubleClicked(fila:Number, col:Number)
{
	switch (col) {
		case this.iface.COL_E_ORDEN: {
			this.iface.cambiarOrdenNivel(fila, col, this.iface.tblEje_);
			break;
		}
		default: {
			this.iface.tbnQuitarNivel_clicked();
			break;
		}
	}
}

function oficial_tblPropsEje_doubleClicked(fila:Number, col:Number)
{
	switch (col) {
		case this.iface.COL_PE_ORDEN: {
			this.iface.cambiarOrdenNivel(fila, col, this.iface.tblPropsEje_);
			var idNivel:String = this.iface.tblPropsEje_.text(fila, this.iface.COL_PE_IDNIVEL);
			var idProp:String = this.iface.tblPropsEje_.text(fila, this.iface.COL_PE_ID);
			var orden:String = this.iface.tblPropsEje_.text(fila, this.iface.COL_PE_ORDEN);
			this.iface.guardarAtributoPropSel(idNivel, idProp, "Orden", orden);
			break;
		}
		default: {
			this.iface.tbnQuitarProp_clicked();
			break;
		}
	}
}

function oficial_cambiarOrdenNivel(fila:Number, col:Number, tabla:FLTable)
{
	if (isNaN(fila)) {
		return false;
	}
	var orden:String = tabla.text(fila, col);
	(orden == "ASC" ? orden = "DESC" : orden = "ASC");
	tabla.setText(fila, col, orden);
}

function oficial_tbnPonerNivel_clicked()
{
	var filasSel:Array = this.iface.tblNiveles_.selectedRows();
	var filaEje:Number = this.iface.tblEje_.numRows();
	if (!filasSel || filasSel.length == 0) {
		var filaNivel:Number = this.iface.tblNiveles_.currentRow();
		(isNaN(filaNivel) ? 0 : this.iface.ponerNivel(filaNivel, filaEje));
	} else {
		for (var i:Number = (filasSel.length - 1); i >= 0 ; i--) {
			this.iface.ponerNivel(filasSel[i], filaEje);
		}
	}
	this.iface.tblEje_currentChanged();
}

function oficial_tbnPonerProp_clicked()
{
	var filasSel:Array = this.iface.tblPropiedades_.selectedRows();
	var filaEje:Number = this.iface.tblPropsEje_.numRows();
	if (!filasSel || filasSel.length == 0) {
		var filaProp:Number = this.iface.tblPropiedades_.currentRow();
		(isNaN(filaProp) ? 0 : this.iface.ponerProp(filaProp, filaEje));
	} else {
		for (var i:Number = (filasSel.length - 1); i >= 0 ; i--) {
			this.iface.ponerProp(filasSel[i], filaEje);
		}
	}
}

/** \D Incluye un nivel en la lista del eje
@param filaNivel: Fila del nivel a eliminar
@param filaEje: Fila del eje a crear
\end*/
function oficial_ponerNivel(filaNivel:Number, filaEje:Number):Boolean
{
	this.iface.tblEje_.insertRows(filaEje);
	this.iface.tblEje_.setText(filaEje, this.iface.COL_E_NIVEL, this.iface.tblNiveles_.text(filaNivel, this.iface.COL_N_NIVEL));
	this.iface.tblEje_.setText(filaEje, this.iface.COL_E_NOMBRE, this.iface.tblNiveles_.text(filaNivel, this.iface.COL_N_NOMBRE));
	this.iface.tblEje_.setText(filaEje, this.iface.COL_E_ORDEN, "ASC");

	this.iface.tblNiveles_.removeRow(filaNivel);
}

/** \D Incluye una propiedad en la lista del eje
@param filaProp: Fila del propiedad a eliminar
@param filaEje: Fila del eje a crear
\end*/
function oficial_ponerProp(filaProp:Number, filaEje:Number):Boolean
{
	var idProp = this.iface.tblPropiedades_.text(filaProp, this.iface.COL_P_ID);
	var idNivel:String = this.iface.tblPropiedades_.text(filaProp, this.iface.COL_P_IDNIVEL);
	var orden:String = "ASC";
	
	this.iface.tblPropsEje_.insertRows(filaEje);
	this.iface.tblPropsEje_.setText(filaEje, this.iface.COL_PE_ID, idProp);
	this.iface.tblPropsEje_.setText(filaEje, this.iface.COL_PE_IDNIVEL, idNivel);
	this.iface.tblPropsEje_.setText(filaEje, this.iface.COL_PE_ALIAS, this.iface.tblPropiedades_.text(filaProp, this.iface.COL_P_ALIAS));
	this.iface.tblPropsEje_.setText(filaEje, this.iface.COL_PE_ORDEN, orden);
	
	this.iface.tblPropiedades_.removeRow(filaProp);
	
	var eProp:FLDomElement = this.iface.xmlProps_.createElement("Propiedad");
	eProp.setAttribute("Id", idProp);
	eProp.setAttribute("Orden", orden);
	if (!this.iface.incluirPropSel(idNivel, eProp)) {
		return false;
	}
}

function oficial_tbnQuitarNivel_clicked()
{
	var filasSel:Array = this.iface.tblEje_.selectedRows();
	var filaNivel:Number = this.iface.tblNiveles_.numRows();
	if (!filasSel || filasSel.length == 0) {
		var filaEje:Number = this.iface.tblEje_.currentRow();
		(isNaN(filaNivel) ? 0 : this.iface.quitarNivel(filaEje, filaNivel));
	} else {
		for (var i:Number = (filasSel.length - 1); i >= 0 ; i--) {
			this.iface.quitarNivel(filasSel[i], filaNivel);
		}
	}
	this.iface.tblEje_currentChanged();
}

function oficial_limpiarTablasProp()
{
	this.iface.tblPropsEje_.setNumRows(0);
	this.iface.tblPropiedades_.setNumRows(0);
}

function oficial_tbnQuitarProp_clicked()
{
	var filasSel:Array = this.iface.tblPropsEje_.selectedRows();
	var filaProp:Number = this.iface.tblPropiedades_.numRows();
	if (!filasSel || filasSel.length == 0) {
		var filaEje:Number = this.iface.tblPropsEje_.currentRow();
		(isNaN(filaProp) ? 0 : this.iface.quitarProp(filaEje, filaProp));
	} else {
		for (var i:Number = (filasSel.length - 1); i >= 0 ; i--) {
			this.iface.quitarProp(filasSel[i], filaProp);
		}
	}
}

/** \D Excluye un nivel de la lista del eje
@param filaEje: Fila del eje a eliminar
@param filaNivel: Fila del nivel a crear
\end*/
function oficial_quitarNivel(filaEje:Number, filaNivel:Number):Boolean
{
	this.iface.tblNiveles_.insertRows(filaNivel);
	this.iface.tblNiveles_.setText(filaNivel, this.iface.COL_N_NIVEL, this.iface.tblEje_.text(filaEje, this.iface.COL_E_NIVEL));
	this.iface.tblNiveles_.setText(filaNivel, this.iface.COL_N_NOMBRE, this.iface.tblEje_.text(filaEje, this.iface.COL_E_NOMBRE));

	this.iface.tblEje_.removeRow(filaEje);
	
}

/** \D Excluye una propiedad de la lista del eje
@param filaEje: Fila del eje a eliminar
@param filaNivel: Fila del nivel a crear
\end*/
function oficial_quitarProp(filaEje:Number, filaProp:Number):Boolean
{
	var idNivel:String = this.iface.tblPropsEje_.text(filaEje, this.iface.COL_PE_IDNIVEL);
	var idProp:String = this.iface.tblPropsEje_.text(filaEje, this.iface.COL_PE_ID);
	
	this.iface.tblPropiedades_.insertRows(filaProp);
	this.iface.tblPropiedades_.setText(filaProp, this.iface.COL_P_ID, this.iface.tblPropsEje_.text(filaEje, this.iface.COL_PE_ID));
	this.iface.tblPropiedades_.setText(filaProp, this.iface.COL_P_IDNIVEL, idNivel);
	this.iface.tblPropiedades_.setText(filaProp, this.iface.COL_P_ALIAS, this.iface.tblPropsEje_.text(filaEje, this.iface.COL_PE_ALIAS));

	this.iface.tblPropsEje_.removeRow(filaEje);
	
	if (!this.iface.excluirPropSel(idNivel, idProp)) {
		return false;
	}
}



/** Indica si el nivel está ya incluido en la tabla Eje
@param	idNivel: Identificador del nivel
\end */
function oficial_nivelIncluidoEje(idNivel:String):Boolean
{
	var filas:Number = this.iface.tblEje_.numRows();
	for (var i:Number = 0; i < filas; i++) {
		if (this.iface.tblEje_.text(i, this.iface.COL_E_NIVEL) == idNivel) {
			return true;
		}
	}
	return false;
}

function oficial_aceptar()
{
	if (!this.iface.guardarDatos()) {
		return false;
	}
	this.accept();
}

function oficial_guardarDatos()
{
	var cursor:FLSqlCursor = this.cursor();
	var eje:String = cursor.valueBuffer("eje");
	var xmlPos:FLDomNode = formin_navegador.iface.xmlPosActual_.firstChild();
	var aNiveles:Array = formin_navegador.iface.niveles_;
	var aINiveles:Array = formin_navegador.iface.iNiveles_;

	var idNivel:String;
	var nodoDim:FLDomNode = xmlPos.namedItem("Dimensiones");
	var nodoeEje:FLDomNode = nodoDim.namedItem(eje);
	nodoDim.removeChild(nodoeEje);
	
	var eEje:FLDomElement = formin_navegador.iface.xmlPosActual_.createElement(eje);
	nodoDim.appendChild(eEje);
	var totalNiveles:Number = this.iface.tblEje_.numRows();
	var eNivel:FLDomElement, eProp:FLDomElement, eProps:FLDomElement, aPropsSel:Array, idNivel:String;
	for (var i:Number = 0; i < totalNiveles; i++) {
		idNivel = this.iface.tblEje_.text(i, this.iface.COL_E_NIVEL);
		eNivel = formin_navegador.iface.xmlPosActual_.createElement("Nivel");
		eNivel.setAttribute("Id", idNivel);
		eNivel.setAttribute("Orden", this.iface.tblEje_.text(i, this.iface.COL_E_ORDEN));
		eEje.appendChild(eNivel);
		
		eProps = formin_navegador.iface.xmlPosActual_.createElement("Propiedades");
		eNivel.appendChild(eProps);
		aPropsSel = this.iface.dameArrayPropSel(idNivel);
		if (aPropsSel) {
			for (var k:Number = 0; k < aPropsSel.length; k++) {
				eProp = formin_navegador.iface.xmlPosActual_.createElement("Propiedad");
				eProp.setAttribute("Id", aPropsSel[k].attribute("Id"));
				eProp.setAttribute("Orden", aPropsSel[k].attribute("Orden"));
				eProps.appendChild(eProp);
			}
		}
	}
	
	return true;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
