/***************************************************************************
                 in_grafico2dbarras.qs  -  description
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
	function oficial( context ) { interna( context );}
	function cargarDatos() {
		return this.ctx.oficial_cargarDatos();
	}
	function valoresDefecto() {
		return this.ctx.oficial_valoresDefecto();
	}
	function aceptar() {
		return this.ctx.oficial_aceptar();
	}
	function guardarDatos() {
		return this.ctx.oficial_guardarDatos();
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
	disconnect (this.child("pushButtonAccept"), "clicked()", this, "accept");
	connect (this.child("pushButtonAccept"), "clicked()", this, "iface.aceptar");
	this.iface.cargarDatos();
	
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_cargarDatos()
{
debug("oficial_cargarDatos");
	var xmlGrafico:FLDomDocument = formin_navegador.iface.xmlGrafico_;
	if (!xmlGrafico) {
		this.iface.valoresDefecto();
		return true;
	}
debug("grafico = " + xmlGrafico.toString(4));
	var eGrafico:FLDomElement = xmlGrafico.firstChild().toElement();
debug("eGrafico = " + eGrafico);
	this.child("fdbAlto").setValue(eGrafico.attribute("Alto"));
	this.child("fdbAncho").setValue(eGrafico.attribute("Ancho"));
}

function oficial_valoresDefecto()
{
	this.child("fdbAlto").setValue(400);
	this.child("fdbAlto").setValue(800);
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

	formin_navegador.iface.xmlGrafico_ = new FLDomDocument();
	var xmlGrafico:FLDomDocument = formin_navegador.iface.xmlGrafico_;
	xmlGrafico.setContent("<Grafico Tipo='2d_barras' />");
	
	var eGrafico:FLDomElement = xmlGrafico.firstChild().toElement();
	eGrafico.setAttribute("Alto", cursor.valueBuffer("alto"));
	eGrafico.setAttribute("Ancho", cursor.valueBuffer("ancho"));

// 	var alturaGrafico:Number = 400;
// 	var anchuraGrafico:Number = 800;
	var margenDerecho:Number = 5;
	var margenIzquierdo:Number = 5;
	var margenSuperior:Number = 5;
	var margenInferior:Number = 5;
	var margenLabelsX:Number = 20;
	var margenLabelsY:Number = 50;
	var anguloLabelX:Number = -45;
// 	var alturaTotal:Number = alturaGrafico + margenSuperior + margenInferior + margenLabelsX;
// 	var anchuraTotal:Number = anchuraGrafico + margenDerecho + margenIzquierdo + margenLabelsY;

	var marcarCadaY:Number = this.child("ledMarcarCadaY").text;
// 	var maximoY:Number = formin_navegador.iface.maximoColArray(1, 1, 10);

// 	eGrafico.setAttribute("Tipo", "2d_barras");
// 	eGrafico.setAttribute("Alto", alturaTotal);
// 	eGrafico.setAttribute("Ancho", anchuraTotal);
	eGrafico.setAttribute("MargenDerecho", margenDerecho);
	eGrafico.setAttribute("MargenIzquierdo", margenIzquierdo);
	eGrafico.setAttribute("MargenSuperior", margenSuperior);
	eGrafico.setAttribute("MargenInferior", margenInferior);

	var eEjeX:FLDomElement = xmlGrafico.createElement("EjeX");
	eGrafico.appendChild(eEjeX);
	eEjeX.setAttribute("Min", "1");
// 	eEjeX.setAttribute("Max", formin_navegador.iface.arrayTabla_.length);
	eEjeX.setAttribute("MarcarCada", "1");
	eEjeX.setAttribute("MarcarLabels", "false");
	eEjeX.setAttribute("MargenLabels", margenLabelsY);
	eEjeX.setAttribute("AnguloLabel", anguloLabelX);

	var eEjeY:FLDomElement = xmlGrafico.createElement("EjeY");
	eGrafico.appendChild(eEjeY);
	eEjeY.setAttribute("Min", "0");
// 	eEjeY.setAttribute("Max", maximoY);
	eEjeY.setAttribute("MarcarCada", marcarCadaY);
	eEjeY.setAttribute("MarcarLabels", "true");
	eEjeY.setAttribute("MargenLabels", margenLabelsY);
	
	var eValores:FLDomElement = xmlGrafico.createElement("Valores");
	eGrafico.appendChild(eValores);
	eValores.setAttribute("Color", "0,0,255");

	return true;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
