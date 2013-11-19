/***************************************************************************
                 lineasalbaranesprov.qs  -  description
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
	function filtrarArtProv() {
		return this.ctx.oficial_filtrarArtProv();
	}
	function dameFiltroReferencia():String {
		return this.ctx.oficial_dameFiltroReferencia();
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
	function pub_actualizarEstadoPedido(idPedido:Number, curAlbaran:FLSqlCursor):Boolean {
		return this.actualizarEstadoPedido(idPedido, curAlbaran);
	}
	function pub_actualizarLineaPedido(idLineaPedido:Number, idPedido:Number, referencia:String, idAlbaran:Number, cantidadLineaAlbaran:Number) {
		return this.actualizarLineaPedido(idLineaPedido, idPedido, referencia, idAlbaran, cantidadLineaAlbaran);
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
Este formulario realiza la gestión de las líneas de albaranes a proveedores.
\end */
function interna_init()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this.child("chkFiltrarArtProv"), "clicked()", this, "iface.filtrarArtProv");
	connect(form, "closed()", this, "iface.desconectar");

	var codSerieAlbaran:String;

	if(cursor.cursorRelation())
		codSerieAlbaran = cursor.cursorRelation().valueBuffer("codserie");
	else
		codSerieAlbaran = util.sqlSelect("albaranesprov","codserie","idAlbaran = " + cursor.valueBuffer("idalbaran"));

	var irpf:Number = util.sqlSelect("series", "irpf", "codserie = '" + codSerieAlbaran + "'");
	if (!irpf)
		irpf = 0;

	if (cursor.modeAccess() == cursor.Insert) {
		this.child("fdbIRPF").setValue(irpf);
// 		this.child("fdbDtoPor").setValue(this.iface.calculateField("dtopor"));
	}

	this.child("lblDtoPor").setText(this.iface.calculateField("lbldtopor"));
	
	if (cursor.modeAccess() == cursor.Insert || cursor.modeAccess() == cursor.Edit) {
		var serie:String = cursor.cursorRelation().valueBuffer("codserie");
		var siniva:Boolean = util.sqlSelect("series","siniva","codserie = '" + serie + "'");
		if(siniva){
			this.child("fdbCodImpuesto").setDisabled(true);
			this.child("fdbIva").setDisabled(true);
			this.child("fdbRecargo").setDisabled(true);
			cursor.setValueBuffer("codimpuesto","");
			cursor.setValueBuffer("iva",0);
			cursor.setValueBuffer("recargo",0);
		}
	}

	this.iface.filtrarArtProv();
}

/** \C
Los campos calculados de este formulario son los mismos que los del formulario de líneas de pedido a proveedor
\end */
function interna_calculateField(fN:String):String
{
	return formRecordlineaspedidosprov.iface.pub_commonCalculateField(fN, this.cursor());
}

function interna_acceptedForm()
{
// 	var cursor:FLSqlCursor = this.cursor();
// 	this.iface.actualizarLineaPedido(cursor.valueBuffer("idlineapedido"), cursor.valueBuffer("idpedido") , cursor.valueBuffer("referencia"), cursor.valueBuffer("idalbaran"), cursor.valueBuffer("cantidad"));
// 	this.iface.actualizarEstadoPedido(cursor.valueBuffer("idpedido"), cursor);
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
	disconnect(this.child("chkFiltrarArtProv"), "clicked()", this, "iface.filtrarArtProv");
}

/** \C
Las dependencias entre controles de este formulario son las mismas que las del formulario de líneas de pedido a proveedor
\end */
function oficial_bufferChanged(fN:String)
{
		formRecordlineaspedidosprov.iface.pub_commonBufferChanged(fN, form);
}

/** \C
Obtiene el estado de un pedido
@param	idPedido: Id del pedido a actualizar
@return	True si la actualización se realiza correctamente, false en caso contrario
\end */
function oficial_obtenerEstadoPedido(idPedido:Number):String
{
	/// Para mantener la compatibilidad de algunas extensiones
	return flfacturac.iface.obtenerEstadoPedidoProv(idPedido);
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
	return flfacturac.iface.actualizarEstadoPedidoProv(idPedido, curAlbaran);
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
	return flfacturac.iface.actualizarLineaPedidoProv(idLineaPedido, idPedido, referencia, idAlbaran, cantidadLineaAlbaran);
}

/** \D Muestra únicamente los artículos del proveedor
*/
function oficial_filtrarArtProv()
{
	var filtroReferencia:String = this.iface.dameFiltroReferencia();
	this.child("fdbReferencia").setFilter(filtroReferencia);
}

function oficial_dameFiltroReferencia():String
{
	var filtroReferencia:String = "secompra";
	if (this.child("chkFiltrarArtProv").checked) {
		var codProveedor:String = this.cursor().cursorRelation().valueBuffer("codproveedor");
		if (codProveedor && codProveedor != "")
			filtroReferencia = "secompra AND referencia IN (SELECT referencia from articulosprov WHERE codproveedor = '" + codProveedor + "')";
	} else {
		filtroReferencia = "secompra";
	}
	return filtroReferencia;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
