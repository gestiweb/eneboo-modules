/***************************************************************************
                 albaranesprov.qs  -  description
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
// 	function recordDelBeforelineasalbaranesprov() { return this.ctx.interna_recordDelBeforelineasalbaranesprov(); }
	function calculateField(fN:String):String { return this.ctx.interna_calculateField(fN); }
	function validateForm():Boolean { return this.ctx.interna_validateForm(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    function oficial( context ) { interna( context ); } 
	function inicializarControles() {
		return this.ctx.oficial_inicializarControles();
	}
	function calcularTotales() {
		return this.ctx.oficial_calcularTotales();
	}
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function verificarHabilitaciones() {
		return this.ctx.oficial_verificarHabilitaciones();
	}
	function mostrarTraza() {
		return this.ctx.oficial_mostrarTraza();
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
Este formulario realiza la gestión de los albaranes a proveedores.

Los albaranes pueden ser generados de forma manual o a partir de uno o más pedidos.
\end */
function interna_init()
{
		var util:FLUtil = new FLUtil();
		var cursor:FLSqlCursor = this.cursor();

		connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
		connect(this.child("tdbLineasAlbaranesProv").cursor(), "bufferCommited()", this, "iface.calcularTotales()");
		connect(this.child("tbnTraza"), "clicked()", this, "iface.mostrarTraza()");

		if (cursor.modeAccess() == cursor.Insert) {
				this.child("fdbCodEjercicio").setValue(flfactppal.iface.pub_ejercicioActual());
				this.child("fdbCodDivisa").setValue(flfactppal.iface.pub_valorDefectoEmpresa("coddivisa"));
				this.child("fdbCodPago").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codpago"));
				this.child("fdbCodAlmacen").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codalmacen"));
				this.child("fdbCodSerie").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codserie"));
				this.child("fdbTasaConv").setValue(util.sqlSelect("divisas", "tasaconv","coddivisa = '" + this.child("fdbCodDivisa").value() + "'"));
		}
		if (cursor.modeAccess() == cursor.Edit)
			this.child("fdbCodSerie").setDisabled(true);
		this.iface.inicializarControles();
}

// function interna_recordDelBeforelineasalbaranesprov()
// {
// 	var cursor:FLSqlCursor = this.cursor();
// 	var curLineaAlbaran:FLSqlCursor = this.child("tdbLineasAlbaranesProv").cursor();
// 
// 	var idLineaPedido:Number = curLineaAlbaran.valueBuffer("idlineapedido");
// 	if (idLineaPedido != "0") {
// 		var idPedido:Number = curLineaAlbaran.valueBuffer("idpedido");
// 		var idLineaAlbaran:Number = curLineaAlbaran.valueBuffer("idlinea");
// 		formalbaranesprov.iface.pub_restarCantidad(idLineaPedido, idLineaAlbaran);
// 		formRecordlineasalbaranesprov.iface.pub_actualizarEstadoPedido(idPedido);
// 	}
// }

function interna_calculateField(fN:String):String
{
		var valor:String;
		var cursor:FLSqlCursor = this.cursor();
		switch (fN) {
		case "total":{
						this.child("lblRecFinanciero").setText((parseFloat(cursor.valueBuffer("recfinanciero")) * cursor.valueBuffer("neto")) / 100);
						valor = formalbaranesprov.iface.pub_commonCalculateField(fN, cursor);
						break;
				}
		default:{
						valor = formalbaranesprov.iface.pub_commonCalculateField(fN, cursor);
						break;
				}
		}
		return valor;
}

function interna_validateForm()
{
	var cursor:FLSqlCursor = this.cursor();	

	var idAlbaran = cursor.valueBuffer("idalbaran");
	if(!idAlbaran)
		return false;

	var codProveedor = this.child("fdbCodProveedor").value();
	
	if(!flfacturac.iface.pub_validarIvaRecargoProveedor(codProveedor,idAlbaran,"lineasalbaranesprov","idalbaran"))
		return false;

	return true;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_inicializarControles()
{
		this.child("lblRecFinanciero").setText(this.iface.calculateField("lblRecFinanciero"));
		this.iface.verificarHabilitaciones();
}

function oficial_calcularTotales()
{
	this.child("fdbNeto").setValue(this.iface.calculateField("neto"));
	this.child("fdbTotalIva").setValue(this.iface.calculateField("totaliva"));
	this.child("fdbTotalRecargo").setValue(this.iface.calculateField("totalrecargo"));
	this.child("fdbTotaIrpf").setValue(this.iface.calculateField("totalirpf"));
	this.iface.verificarHabilitaciones();
}

function oficial_bufferChanged(fN:String)
{
		var cursor:FLSqlCursor = this.cursor();
		switch (fN) {
		/** \C
		El --total-- es el --neto-- más el --totaliva-- más el --totalrecargo-- más el --recfinanciero--
		\end */
		case "recfinanciero":
		case "neto":{
			this.child("fdbTotaIrpf").setValue(this.iface.calculateField("totalirpf"));
		}
		case "totalrecargo":
		case "totalirpf":
		case "totaliva":{
						var total:Number = this.iface.calculateField("total");
						this.child("fdbTotal").setValue(total);
						break;
				}
		/** \C
		El --totaleuros-- es el producto del --total-- por la --tasaconv--
		\end */
		case "total":
		case "tasaconv":{
						this.child("fdbTotalEuros").setValue(this.iface.calculateField("totaleuros"));
						break;
				}
		/** \C
		El --irpf-- es el asociado a la --codserie-- del albarán
		\end */
		case "codserie": {
						if (cursor.modeAccess() == cursor.Insert) {
						    this.cursor().setValueBuffer("irpf", this.iface.calculateField("irpf"));
						} else {
						    if (cursor.valueBuffer("codserie") != cursor.valueBufferCopy("codserie")) {
							cursor.setValueBuffer("codserie", cursor.valueBufferCopy("codserie"));
						    }
						}
						break;
				}
		/** \C
		El --totalirpf-- es el producto del --irpf-- por el --neto--
		\end */
		case "irpf": {
						this.child("fdbTotaIrpf").setValue(this.iface.calculateField("totalirpf"));
						break;
				}
		}
}

function oficial_verificarHabilitaciones()
{
		var util:FLUtil = new FLUtil;
		if (!util.sqlSelect("lineasalbaranesprov", "idalbaran", "idalbaran = " + this.cursor().valueBuffer("idalbaran"))) {
				this.child("fdbCodAlmacen").setDisabled(false);
				this.child("fdbCodDivisa").setDisabled(false);
				this.child("fdbTasaConv").setDisabled(false);
		} else {
				this.child("fdbCodAlmacen").setDisabled(true);
				this.child("fdbCodDivisa").setDisabled(true);
				this.child("fdbTasaConv").setDisabled(true);
		}
}

function oficial_mostrarTraza()
{
	flfacturac.iface.pub_mostrarTraza(this.cursor().valueBuffer("codigo"), "albaranesprov");
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
