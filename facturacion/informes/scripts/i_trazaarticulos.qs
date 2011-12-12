/***************************************************************************
                 i_ventasmensual.qs  -  description
                             -------------------
    begin                : jue jun 8 2006
    copyright            : (C) 2006 by InfoSiAL S.L.
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
	function bufferChanged(fN:String) { this.ctx.oficial_bufferChanged(fN); }
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
	connect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged");
}

function interna_validateForm():Boolean
{
		var util:FLUtil = new FLUtil();

		var fechaInicio:String = this.child("fdbFechaDesde").value();
		var fechaFin:String = this.child("fdbFechaHasta").value();

		if (util.daysTo(fechaInicio, fechaFin) < 0) {
				MessageBox.critical
						(util.
						 translate("scripts",
											 "La fecha de inicio debe ser menor que la de fin"),
						 MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				return false;
		}


		var referenciaDesde:String = this.child("fdbReferenciaD").value();
		var referenciaHasta:String = this.child("fdbReferenciaH").value();

		if (referenciaDesde > referenciaHasta) {
				MessageBox.critical
						(util.
						 translate("scripts",
											 "La referencia inicial debe ser menor que la final"),
						 MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				return false;
		}

		var clienteDesde:String = this.child("fdbCodClienteD").value();
		var clienteHasta:String = this.child("fdbCodClienteH").value();
		
		if (clienteDesde > clienteHasta) {
				MessageBox.critical
						(util.
						 translate("scripts",
											 "El cliente inicial debe ser menor que el final"),
						 MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				return false;
		}

		var proveedorDesde:String = this.child("fdbCodProveedorD").value();
		var proveedorHasta:String = this.child("fdbCodProveedorH").value();
		
		if (proveedorDesde > proveedorHasta) {
				MessageBox.critical
						(util.
						 translate("scripts",
											 "El proveedor inicial debe ser menor que el final"),
						 MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				return false;
		}

		var almacenDesde:String = this.child("fdbAlmacenD").value();
		var almacenHasta:String = this.child("fdbAlmacenH").value();
		
		if (almacenDesde > almacenHasta) {
				MessageBox.critical
						(util.
						 translate("scripts",
											 "El almacén inicial debe ser menor que el final"),
						 MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				return false;
		}


		return true;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_bufferChanged(fN:String)
{
	var cursor:FLSqlCursor = this.cursor();
	
	switch(fN){
		/** \C Si cambia el intervalo se recalculan las fechas.
		\end */
		case "codintervalo": {
			var intervalo:Array = [];
			if (cursor.valueBuffer("codintervalo")) {
				intervalo = flfactppal.iface.pub_calcularIntervalo(cursor.valueBuffer("codintervalo"));
				cursor.setValueBuffer("fechadesde", intervalo.desde);
				cursor.setValueBuffer("fechahasta", intervalo.hasta);
			}
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
