/***************************************************************************
                 in_colores.qs  -  description
                             -------------------
    begin                : mar dic 15 2009
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
	function init() {
		return this.ctx.interna_init();
	}
	function calculateField(fN:String):String {
		return this.ctx.interna_calculateField(fN);
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var bloqueoColor_:Boolean;
	function oficial( context ) { interna( context );}
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function obtenerColorHexadecimal(colorRGB:String):String {
		return this.ctx.oficial_obtenerColorHexadecimal(colorRGB);
	}
	function mostrarColor() {
		return this.ctx.oficial_mostrarColor();
	}
	function cambiarRojo(valor:Number) {
		return this.ctx.oficial_cambiarRojo(valor);
	}
	function cambiarVerde(valor:Number) {
		return this.ctx.oficial_cambiarVerde(valor);
	}
	function cambiarAzul(valor:Number) {
		return this.ctx.oficial_cambiarAzul(valor);
	}
	function iniciarSliders() {
		return this.ctx.oficial_iniciarSliders();
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
	function pub_obtenerColorHexadecimal(colorRGB:String):String {
		return this.obtenerColorHexadecimal(colorRGB);
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
/** \C 
\end */
function interna_init()
{
	this.iface.bloqueoColor_ = false;
	var cursor:FLSqlCursor = this.cursor();
	connect (cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect (this.child("sldR"), "valueChanged(int)", this, "iface.cambiarRojo");
	connect (this.child("sldG"), "valueChanged(int)", this, "iface.cambiarVerde");
	connect (this.child("sldB"), "valueChanged(int)", this, "iface.cambiarAzul");

	this.iface.iniciarSliders();
	this.iface.mostrarColor();
}

function interna_calculateField(fN:String):String
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var valor:String = "";

	switch (fN) {
		case "rgb": {
			valor = cursor.valueBuffer("r") + "," + cursor.valueBuffer("g") + "," + cursor.valueBuffer("b");
			break;
		}
		case "hex": {
			var rgb:String = cursor.valueBuffer("rgb");
			if(!rgb || rgb == "")
				break;
			valor = this.iface.obtenerColorHexadecimal(rgb);
			if(!valor)
				valor = "";
			break;
		}
	}
	return valor;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_obtenerColorHexadecimal(colorRGB:String):String
{
	var valor:String = "#";
	var hex:Array = new Array("0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F");
	var rgb:Array = colorRGB.split(",");
	if(rgb.length != 3)
		return "";
	
	var num:Number;
	var coc:Number;
	var arrayNumero:Array = [];
	var pos:Number = 0;
	for(var i=0;i<rgb.length;i++) {
		num = parseInt(rgb[i]);
		if(!num)
			num=0;
		
		arrayNumero = [];
		arrayNumero[1] = num%16;
		coc = (num-arrayNumero[1])/16;
		arrayNumero[0] = coc%16;
		valor += hex[arrayNumero[0]] + hex[arrayNumero[1]];
	}
	
	return valor;
}

function oficial_bufferChanged(fN:String)
{
	var cursor:FLSqlCursor = this.cursor();
	switch (fN) {
		case "r":
		case "g":
		case "b": {
			if (!this.iface.bloqueoColor_) {
				this.iface.bloqueoColor_ = true;
				var valor:Number = cursor.valueBuffer(fN);
				if (isNaN(valor)) {
					valor = 0;
				}
				switch (fN) {
					case "r": { this.child("sldR").setValue(valor); break; }
					case "g": { this.child("sldG").setValue(valor); break; }
					case "b": { this.child("sldB").setValue(valor); break; }
				}
				this.iface.bloqueoColor_ = false;
			}
			cursor.setValueBuffer("rgb", this.iface.calculateField("rgb"));
			cursor.setValueBuffer("hex", this.iface.calculateField("hex"));
			this.iface.mostrarColor();
			break;
		}
	}
}

function oficial_iniciarSliders()
{
	var cursor:FLSqlCursor = this.cursor();
	this.iface.bloqueoColor_ = true;
	this.child("sldR").setValue(cursor.valueBuffer("r"));
	this.child("sldG").setValue(cursor.valueBuffer("g"));
	this.child("sldB").setValue(cursor.valueBuffer("b"));
	this.iface.bloqueoColor_ = false;
}

function oficial_mostrarColor()
{
	var cursor:FLSqlCursor = this.cursor();
	var lblColor = this.child("lblColor");
	fldireinne.iface.pub_colorearLabel(lblColor, cursor.valueBuffer("rgb"));
}

function oficial_cambiarRojo(valor:Number)
{
	if (!this.iface.bloqueoColor_) {
		this.iface.bloqueoColor_ = true;
		this.child("fdbR").setValue(valor);
		this.iface.bloqueoColor_ = false;
	}
}

function oficial_cambiarVerde(valor:Number)
{
	if (!this.iface.bloqueoColor_) {
		this.iface.bloqueoColor_ = true;
		this.child("fdbG").setValue(valor);
		this.iface.bloqueoColor_ = false;
	}
}

function oficial_cambiarAzul(valor:Number)
{
	if (!this.iface.bloqueoColor_) {
		this.iface.bloqueoColor_ = true;
		this.child("fdbB").setValue(valor);
		this.iface.bloqueoColor_ = false;
	}
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
