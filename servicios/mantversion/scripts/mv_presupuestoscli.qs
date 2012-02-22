/***************************************************************************
                 mv_presupuestoscli.qs  -  description
                             -------------------
    begin                : mie abr 25 2004
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
////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

/** @class_declaration interna */
//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
class interna {
    var ctx:Object;
    function interna( context ) { this.ctx = context; }
    function init() { this.ctx.interna_init(); }
	function calculateField(fN:String):String { return this.ctx.interna_calculateField(fN); }
	function acceptedForm() { return this.ctx.interna_acceptedForm(); }
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
		function bufferChanged(fN:String) {
				return this.ctx.oficial_bufferChanged(fN);
		}
		function calcularTotales() {
				return this.ctx.oficial_calcularTotales();
		}
		function verificarHabilitaciones() {
				return this.ctx.oficial_verificarHabilitaciones();
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

////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

/** @class_definition interna */
//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
/** \C
Este formulario realiza la gestión de los pedidos a clientes.

Los pedidos pueden ser generados de forma manual o a partir de un presupuesto previo.
\end */
function interna_init()
{
		var util:FLUtil = new FLUtil();
		var cursor:FLSqlCursor = this.cursor();
		connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
		connect(this.child("tdbPuntoPresupuestosCli").cursor(), "bufferCommited()", this, "iface.calcularTotales()");

		if (cursor.modeAccess() == cursor.Insert) {
				this.child("fdbCodEjercicio").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codejercicio"));
				this.child("fdbCodDivisa").setValue(flfactppal.iface.pub_valorDefectoEmpresa("coddivisa"));
				this.child("fdbCodPago").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codpago"));
				this.child("fdbCodAlmacen").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codalmacen"));
				this.child("fdbCodSerie").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codserie"));
				this.child("fdbTasaConv").setValue(util.sqlSelect("divisas", "tasaconv", "coddivisa = '" + this.child("fdbCodDivisa").value() + "'"));
		}
		this.iface.inicializarControles();
}

/** \U
Los valores de los campos de este formulario se calculan en el script asociado al formulario maestro
\end */
function interna_calculateField(fN:String):String
{
		return formmv_presupuestoscli.iface.pub_commonCalculateField(fN, this.cursor());
}

/** \C
El --numero-- se establecerá como el siguiente número de la secuencia asociada a la --codserie--
\end */
function interna_acceptedForm()
{
		var cursor:FLSqlCursor = this.cursor();
		if (cursor.valueBuffer("numero") == 0) {
				cursor.setValueBuffer("numero", flfacturac.iface.pub_siguienteNumero(cursor.valueBuffer("codserie"), cursor.valueBuffer("codejercicio"), "npresupuestocli"));
		}
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
		this.child("lblComision").setText(this.iface.calculateField("lblComision"));
		this.iface.verificarHabilitaciones();
}

function oficial_bufferChanged(fN:String)
{
		switch (fN) {
		case "recfinanciero":
		case "neto":{
						this.child("lblRecFinanciero").setText(this.iface.calculateField("lblRecFinanciero"));
						this.child("fdbTotalIva").setValue(this.iface.calculateField("totaliva"));
				}
		case "totaliva":{
						var total:String = this.iface.calculateField("total");
						this.child("fdbTotal").setValue(total);
						break;
				}
		case "poriva":{
						this.child("fdbTotalIva").setValue(this.iface.calculateField("totaliva"));
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
		case "porcomision":{
						this.child("lblComision").setText(this.iface.calculateField("lblComision"));
						break;
				}
		/** \C
		El valor de --coddir-- por defecto corresponde a la dirección del cliente marcada como dirección de facturación
		\end */
		case "codcliente": {
						this.child("fdbCodDir").setValue("x");
						this.child("fdbCodDir").setValue(this.iface.calculateField("coddir"));
						break;
				}
		/** \C
		El --irpf-- es el asociado a la --codserie-- del albarán
		\end */
		case "codserie": {
						this.cursor().setValueBuffer("irpf", this.iface.calculateField("irpf"));
						break;
				}
		}
}
/** \U
Calcula los campos que son resultado de una suma de las líneas de pedido
\end */
function oficial_calcularTotales()
{
		this.child("fdbNeto").setValue(this.iface.calculateField("neto"));
		this.child("fdbTotalIva").setValue(this.iface.calculateField("totaliva"));
		this.child("lblComision").setText(this.iface.calculateField("lblComision"));
		this.iface.verificarHabilitaciones();
}

/** \U
Verifica que los campos --codalmacen--, --coddivisa-- y ..tasaconv-- estén habilitados en caso de que el pedido no tenga líneas asociadas.
\end */
function oficial_verificarHabilitaciones()
{
		var util:FLUtil = new FLUtil();
		var idPresupuesto:Number = util.sqlSelect("mv_puntopresupuesto", "idpresupuesto", "idpresupuesto = " + this.cursor().valueBuffer("idpresupuesto"));
		if (!idPresupuesto) {
				this.child("fdbCodAlmacen").setDisabled(false);
				this.child("fdbCodDivisa").setDisabled(false);
				this.child("fdbTasaConv").setDisabled(false);
		} else {
				this.child("fdbCodAlmacen").setDisabled(true);
				this.child("fdbCodDivisa").setDisabled(true);
				this.child("fdbTasaConv").setDisabled(true);
		}
}

//// OFICIAL/////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
//////////////////////////////////////////////////////////////////
//// DESARROLLO //////////////////////////////////////////////////

//// DESARROLLO //////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
