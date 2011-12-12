/***************************************************************************
                 tpv_tecladoletras.qs  -  description
                             -------------------
    begin                : vie jun 11 2010
    copyright            : Por ahora (C) 2006 by InfoSiAL S.L.
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
		this.ctx.interna_init();
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var texto:String;
	var botones:Object;
	var mayusculas:Boolean
	var arrayBotones:Array = ["0","1","2","3","4","5","6","7","8","9","q","w","e","r","t","y","u","i","o","p","a","s","d","f","g","h","j","k","l","ñ","z","x","c","v","b","n","m"," "]
	function oficial( context ) { interna( context ); }
	function modificarTexto(pos:Number) {
		return this.ctx.oficial_modificarTexto(pos);
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
/** \C Se muestra el importe pendiente de pago seleccionado. Al pulsar Intro o Return el formulario se cerrará con el importe que el usuario haya establecido.
*/
function interna_init()
{
	this.iface.texto = this.cursor().valueBuffer("texto");
	this.iface.mayusculas = false;
	this.iface.botones = this.child("botones");
	connect(this.iface.botones, "clicked(int)", this, "iface.modificarTexto");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_modificarTexto(pos:Number)
{
	var util:FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var texto:String = cursor.valueBuffer("texto");
	switch(pos) {
		case 38: {
			if(this.iface.mayusculas)
				this.iface.mayusculas = false
			else
				this.iface.mayusculas = true;
			
			for(var i=10;i<37;i++) {
// 				if(!this.iface.mayusculas)
				if(this.child("tbnMayusculas").on)
					this.iface.arrayBotones[i] = this.iface.arrayBotones[i].upper()
				else
					this.iface.arrayBotones[i] = this.iface.arrayBotones[i].lower()
					
			}
			break;
		}
		case 39: {
			texto = texto.left(texto.length-1);
			cursor.setValueBuffer("texto",texto);
			break;
		}
		case 37: {
			texto += " ";
			cursor.setValueBuffer("texto",texto);
			break;
		}
		default: {
			texto += this.iface.arrayBotones[pos];
			cursor.setValueBuffer("texto",texto);
			break;
		}
	}
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
