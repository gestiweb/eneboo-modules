/***************************************************************************
                 articuloscli.qs  -  description
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
	function validateForm():Boolean { return this.ctx.interna_validateForm(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    function oficial( context ) { interna( context ); } 
		function usarTarifaClicked() { return this.ctx.oficial_usarTarifaClicked(); }
		function cambioCodTarifa() { return this.ctx.oficial_cambioCodTarifa(); }
		function bufferChanged(fN:String) { return this.ctx.oficial_bufferChanged(fN); }
		
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
function interna_init()
{
		connect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged(campo)");
		this.iface.usarTarifaClicked();
}

function interna_validateForm():Boolean
{
		if (this.cursor().valueBuffer("usartarifa") == false)
				this.child("fdbCodTarifa").setValue("");
		return true;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Se habilitan los controles de tarifa y, si se habilita la tarifa, se recalcula en precio mediante la función cambioCodTarifa
\end */
function oficial_usarTarifaClicked()
{
		var fdbCodTarifa:Object = this.child("fdbCodTarifa").editor();
		var fdbPvp:Object = this.child("fdbPvp").editor();

		if (this.cursor().valueBuffer("usartarifa") == true) {
				fdbCodTarifa.setEnabled(true);
				fdbPvp.setEnabled(false);
				this.iface.cambioCodTarifa();
		} else {
				fdbCodTarifa.setEnabled(false);
				fdbPvp.setEnabled(true);
		}
}

/** \D Calcula el nuevo pvp en función del pvp actual y la tarifa seleccionada
\end */
function oficial_cambioCodTarifa()
{
		var nuevoPvp:Number;
		var cursor:FLSqlCursor = this.cursor();

		if (cursor.valueBuffer("usartarifa") == true) {
				var pvp:Number = cursor.cursorRelation().valueBuffer("pvp");
				var curTarifa:FLSqlCursor = new FLSqlCursor("tarifas");

				curTarifa.select("codtarifa = '" + cursor.valueBuffer("codtarifa") + "'");
				curTarifa.first();
				var incremento:Number = curTarifa.valueBuffer("incremento");

				switch (curTarifa.valueBuffer("tipo")) {
				case "Incremento Porcentual":{
								nuevoPvp = ((100 + incremento) * pvp) / 100;
								break;
						}
				case "Incremento Lineal":{
								nuevoPvp = pvp + incremento;
								break;
						}
				}
				this.child("fdbPvp").setValue(nuevoPvp);
		}
}


function oficial_bufferChanged(campo:String)
{
		switch (campo) {
		/** \C
		Al seleccionar --usartarifa-- se habilitan o deshabilitan los campos de tarifa. Si se activa la tarifa se recalcula automáticamente el precio
		\end */
		case "usartarifa":{
						this.iface.usarTarifaClicked();
						break;
				}
		/** \C
		Al cambiar --codtarifa-- se recalcula el precio en función de la tarifa nueva y el precio actual
		\end */
		case "codtarifa":{
						this.iface.cambioCodTarifa();
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
