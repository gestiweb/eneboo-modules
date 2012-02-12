/***************************************************************************
                 lineasfacturasprov.qs  -  description
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
	function validateForm():Boolean { return this.ctx.interna_validateForm(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var longSubcuenta:Number;
	var bloqueoSubcuenta:Boolean;
	var ejercicioActual:String;
	var posActualPuntoSubcuenta:Number;
	
	function oficial( context ) { interna( context ); } 
	function desconectar() {
		return this.ctx.oficial_desconectar();
	}
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
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
Este formulario realiza la gestión de las líneas de facturas a proveedores.
\end */
function interna_init()
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil;
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this.child("chkFiltrarArtProv"), "clicked()", this, "iface.filtrarArtProv");
	connect(form, "closed()", this, "iface.desconectar");

	var irpf:Number = util.sqlSelect("series", "irpf", "codserie = '" + cursor.cursorRelation().valueBuffer("codserie") + "'");
	if (!irpf)
		irpf = 0;

	if (cursor.modeAccess() == cursor.Insert) {
		this.child("fdbIRPF").setValue(irpf);
// 		this.child("fdbDtoPor").setValue(this.iface.calculateField("dtopor"));
	}

	this.child("lblDtoPor").setText(this.iface.calculateField("lbldtopor"));
	
	if (sys.isLoadedModule("flcontppal")) {
		this.iface.ejercicioActual = flfactppal.iface.pub_ejercicioActual();
		this.iface.longSubcuenta = util.sqlSelect("ejercicios", "longsubcuenta", 
				"codejercicio = '" + this.iface.ejercicioActual + "'");
		this.iface.bloqueoSubcuenta = false;
		this.iface.posActualPuntoSubcuenta = -1;
		this.child("fdbIdSubcuenta").setFilter("codejercicio = '" + this.iface.ejercicioActual + "'");
	} else {
		this.child("gbxContabilidad").enabled = false;
	}
		
	this.iface.filtrarArtProv();
}

/** \C
Los campos calculados de este formulario son los mismos que los del formulario de líneas de pedido a proveedor
\end */
function interna_calculateField(fN:String):String
{
		var util:FLUtil = new FLUtil();
		var cursor:FLSqlCursor = this.cursor();
		switch(fN) {
				case "codsubcuenta":
						return util.sqlSelect("articulos", "codsubcuentacom", 
								"referencia = '" + cursor.valueBuffer("referencia") + "'");
						break
				default:
						return formRecordlineaspedidosprov.iface.pub_commonCalculateField(fN, cursor);
		}
}

function interna_validateForm():Boolean
{
		
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var curFactura:FLSqlCursor = cursor.cursorRelation();
		
	if (curFactura.valueBuffer("deabono") == true && cursor.valueBuffer("pvptotal") > 0) {
		var res:Number = MessageBox.warning(util.translate("scripts","Si esta creando una factura de abono la cantidad total debe ser negativa.\n\n¿Desea continuar?"), MessageBox.No, MessageBox.Yes, MessageBox.NoButton);
		if (res == MessageBox.No)
			return false;
	}
	if (curFactura.valueBuffer("deabono") == false && cursor.valueBuffer("pvptotal") < 0) {
		var res:Number = MessageBox.warning(util.translate("scripts","Si esta creando una factura que no es de abono la cantidad total debe ser positiva.\n\n¿Desea continuar?"), MessageBox.No, MessageBox.Yes, MessageBox.NoButton);
		if (res == MessageBox.No)
			return false;
	}
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
		var cursor:FLSqlCursor = this.cursor();
		var util:FLUtil = new FLUtil();
		
		switch(fN) {
			case "codsubcuenta":
				if (!this.iface.bloqueoSubcuenta) {
					this.iface.bloqueoSubcuenta = true;
					this.iface.posActualPuntoSubcuenta = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuenta", this.iface.longSubcuenta, this.iface.posActualPuntoSubcuenta);
					this.iface.bloqueoSubcuenta = false;
				}
				break;
			case "referencia":
				this.iface.bloqueoSubcuenta = true;
				this.child("fdbCodSubcuenta").setValue(this.iface.calculateField("codsubcuenta"));
				this.iface.bloqueoSubcuenta = false;
				this.child("fdbPvpUnitario").setValue(this.iface.calculateField("pvpunitario", cursor));
				this.child("fdbCodImpuesto").setValue(this.iface.calculateField("codimpuesto", cursor));
				formRecordlineaspedidosprov.iface.pub_commonBufferChanged(fN, form);
				break;
			default:
				formRecordlineaspedidosprov.iface.pub_commonBufferChanged(fN, form);
		}
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
