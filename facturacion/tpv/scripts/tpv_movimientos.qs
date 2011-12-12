/***************************************************************************
                 tpv_movimientos.qs  -  description
                             -------------------
    begin                : mie nov 16 2005
    copyright            : Por ahora (C) 2005 by InfoSiAL S.L.
    email                : lveb@telefonica.net
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
    function oficial( context ) { interna( context ); } 
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends oficial {
	var lblPtoVenta:Object;
    function head( context ) { oficial ( context ); }
	function calcularArqueo() { return this.ctx.oficial_calcularArqueo(); }
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
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
/** \D
Al crear un movimiento se establece el punto de venta como el punto de venta del arqueo del que proviene
*/
function interna_init()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	this.iface.lblPtoVenta = this.child("lblPtoVenta");
	
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	
	var ptoVenta:String = util.sqlSelect("tpv_arqueos","ptoventa","idtpv_arqueo = '" + cursor.valueBuffer("idtpv_arqueo") + "'");
	
	if (cursor.modeAccess() == cursor.Insert){
		this.iface.calcularArqueo();
		if (ptoVenta)
			cursor.setValueBuffer("codtpv_agente",util.sqlSelect("tpv_puntosventa","codtpv_agente","codtpv_puntoventa = '" + ptoVenta + "'"));
		var causaDefecto:String = util.sqlSelect("tpv_causasmovimiento", "codcausa", "valordefecto = true");
		if (causaDefecto && causaDefecto != "")
			this.child("fdbCodCausa").setValue(causaDefecto);
	}
	if (ptoVenta)
		this.iface.lblPtoVenta.setText(util.translate("scripts", "Pto. Venta %1").arg(ptoVenta));
	
}

function interna_validateForm():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	
	if (sys.isLoadedModule("flcontppal")) {
		var codCausa:String = cursor.valueBuffer("codcausa");
		if (!codCausa || codCausa == "") {
			var res:Number = MessageBox.warning(util.translate("scripts", "No ha establecido una casua de la tabla de Causas.\nEsto provocará que al cerrar el arqueo la generación del asiento contable falle.\n¿Desea continuar?"), MessageBox.Yes, MessageBox.No);
			if (res != MessageBox.Yes)
				return false;
		}

	}
	return true;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D
Obtiene el arqueo del formulario relacionado
*/
function oficial_calcularArqueo()
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	
	
	if(!cursor.valueBuffer("idtpv_arqueo")){
		if(cursor.cursorRelation()){
			cursor.setValueBuffer("idtpv_arqueo",cursor.cursorRelation().valueBuffer("idtpv_arqueo"));
		}
	}
}

function oficial_bufferChanged(fN:String)
{
	switch (fN) {
		case "fecha":{
			/** \C
			Al cambiar la --fecha-- se recalcula el arqueo al que pertenece el movimiento
			*/
			this.iface.calcularArqueo();
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
