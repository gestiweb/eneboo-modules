/***************************************************************************
                 lineasalbaranescli.qs  -  description
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
	function calculateField(fN:String):String { return this.ctx.interna_calculateField(fN); }
	function acceptedForm() { return this.ctx.interna_acceptedForm(); }
	function validateForm():Boolean { return this.ctx.interna_validateForm(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    function oficial( context ) { interna( context ); } 
	function desconectar() {
		return this.ctx.oficial_desconectar();
	}
	function dameFiltroReferencia():String {
		return this.ctx.oficial_dameFiltroReferencia();
	}
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function actualizarEstadoPedido(idPedido:Number, curAlbaran:FLSqlCursor):Boolean {
		return this.ctx.oficial_actualizarEstadoPedido(idPedido, curAlbaran);
	}
	function actualizarLineaPedido(idLineaPedido:Number, idPedido:Number, referencia:String, idAlbaran:Number, cantidadLineaAlbaran:Number):Boolean {
		return this.ctx.oficial_actualizarLineaPedido(idLineaPedido, idPedido, referencia, idAlbaran, cantidadLineaAlbaran);
	}
	function obtenerEstadoPedido(idPedido:Number):String {
		return this.ctx.oficial_obtenerEstadoPedido(idPedido);
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
	function pub_actualizarLineaPedido(idLineaPedido:Number, idPedido:Number, referencia:String, idAlbaran:Number, cantidadLineaAlbaran:Number):Boolean {
		return this.actualizarLineaPedido(idLineaPedido, idPedido, referencia, idAlbaran, cantidadLineaAlbaran);
	}
	function pub_actualizarEstadoPedido(idPedido:Number, curAlbaran:FLSqlCursor):Boolean {
		return this.actualizarEstadoPedido(idPedido, curAlbaran);
	}
	function pub_obtenerEstadoPedido(idPedido:Number):String {
		return this.obtenerEstadoPedido(idPedido);
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
Este formulario realiza la gestión de las líneas de albaranes a clientes.
\end */
function interna_init()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(form, "closed()", this, "iface.desconectar");

	var irpf:Number = util.sqlSelect("series", "irpf", "codserie = '" + cursor.cursorRelation().valueBuffer("codserie") + "'");
	if (!irpf) {
		irpf = 0;
	}

	if (cursor.modeAccess() == cursor.Insert) {
		var opcionIvaRec:Number = flfacturac.iface.pub_tieneIvaDocCliente(cursor.cursorRelation().valueBuffer("codserie"), cursor.cursorRelation().valueBuffer("codcliente"));
		switch (opcionIvaRec) {
			case 0: {
				this.child("fdbCodImpuesto").setValue("");
				this.child("fdbIva").setValue(0);
				this.child("fdbRecargo").setValue(0);
				break;
			}
			case 1: {
				this.child("fdbRecargo").setValue(0);
//Rellenamos el codimpuesto del almacen por defecto
				var impuestoAlmacen:String = util.sqlSelect("factalma_general", "codimpuesto", "1 = 1");
				if (impuestoAlmacen)
					this.child("fdbCodImpuesto").setValue(impuestoAlmacen);
//Fin
				break;
			}
		}
		this.child("fdbIRPF").setValue(irpf);
		this.child("fdbDtoPor").setValue(this.iface.calculateField("dtopor"));
		if (cursor.cursorRelation().valueBuffer("porcomision")) {
			this.child("fdbPorComision").setDisabled(true);
		} else {
			if (!cursor.cursorRelation().valueBuffer("codagente") || cursor.cursorRelation().valueBuffer("codagente") == "") {
				this.child("fdbPorComision").setDisabled(true);
			} else {
				this.child("fdbPorComision").setValue(this.iface.calculateField("porcomision"));
			}
		}
	}

	if (cursor.cursorRelation().valueBuffer("porcomision")) {
		this.child("fdbPorComision").setDisabled(true);
	}

	this.child("lblComision").setText(this.iface.calculateField("lblComision"));
	this.child("lblDtoPor").setText(this.iface.calculateField("lbldtopor"));
	
	var filtroReferencia:String = this.iface.dameFiltroReferencia();
	this.child("fdbReferencia").setFilter(filtroReferencia);
}

/** \C
Los campos calculados de este formulario son los mismos que los del formulario de líneas de pedido a cliente
\end */
function interna_calculateField(fN:String):String
{
		return formRecordlineaspedidoscli.iface.pub_commonCalculateField(fN, this.cursor());
}

function interna_acceptedForm()
{
// 		var cursor:FLSqlCursor = this.cursor();
// 		this.iface.actualizarLineaPedido(cursor.valueBuffer("idlineapedido"), cursor.valueBuffer("idpedido") , cursor.valueBuffer("referencia"), cursor.valueBuffer("idalbaran"), cursor.valueBuffer("cantidad"));
// 		this.iface.actualizarEstadoPedido(cursor.valueBuffer("idpedido"), cursor);
}

/** \D Función a sobrecargar
\end */
function interna_validateForm():Boolean
{
	return true;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_desconectar()
{
		disconnect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged");
}

function oficial_dameFiltroReferencia():String
{
	return "sevende";
}


/** \C
Las dependencias entre controles de este formulario son las mismas que las del formulario de líneas de pedido a cliente
\end \end */
function oficial_bufferChanged(fN:String)
{
		formRecordlineaspedidoscli.iface.pub_commonBufferChanged(fN, form);
}

/** \C
Obtiene el estado de un pedido
@param	idPedido: Id del pedido a actualizar
@return	Estado del pedido
\end */
function oficial_obtenerEstadoPedido(idPedido:Number):String
{
	/// Para mantener la compatibilidad de algunas extensiones
	return flfacturac.iface.obtenerEstadoPedidoCli(idPedido);
}

/** \C
Marca el pedido como servido o parcialmente servido según corresponda.
@param	idPedido: Id del pedido a actualizar
@param	curAlbaran: Cursor posicionado en el albarán que modifica el estado del pedido
@return	True si la actualización se realiza correctamente, false en caso contrario
\end */
function oficial_actualizarEstadoPedido(idPedido:Number, curAlbaran:FLSqlCursor):Boolean
{
	/// Para mantener la compatibilidad de algunas extensiones
	return flfacturac.iface.actualizarEstadoPedidoCli(idPedido, curAlbaran);
}

/** \C
Actualiza el campo total en albarán de la línea de pedido correspondiente (si existe).
@param	idLineaPedido: Id de la línea a actualizar
@param	idPedido: Id del pedido a actualizar
@param	referencia del artículo contenido en la línea
@param	idAlbaran: Id del albarán en el que se sirve el pedido
@param	cantidadLineaAlbaran: Cantidad total de artículos de la referencia actual en el albarán
@return	True si la actualización se realiza correctamente, false en caso contrario
\end */
function oficial_actualizarLineaPedido(idLineaPedido:Number, idPedido:Number, referencia:String, idAlbaran:Number, cantidadLineaAlbaran:Number):Boolean
{
	/// Para mantener la compatibilidad de algunas extensiones
	return flfacturac.iface.actualizarLineaPedidoCli(idLineaPedido, idPedido, referencia, idAlbaran, cantidadLineaAlbaran);
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
