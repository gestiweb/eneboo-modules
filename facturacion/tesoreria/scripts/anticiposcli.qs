/***************************************************************************
                       anticiposcli.qs  -  description
                             -------------------
    begin                : lun dic 05 2005
    copyright            : (C) 2005 by InfoSiAL S.L.
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

/** @ file */

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
	function validateForm() { return this.ctx.interna_validateForm(); }
	function calculateField(fN:String):String { return this.ctx.interna_calculateField(fN); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var ejercicioActual:String;
	var bloqueoSubcuenta:Boolean;
	var longSubcuenta:Number;
	var contabActivada:Boolean;
	var bngTasaCambio:Object;
	var divisaEmpresa:String;
	var posActualPuntoSubcuenta:Number;
	var sumaAnticipos:Number;
	var sldPorcentaje:Object;
	var connSld:Boolean;

	function oficial( context ) { interna( context ); } 
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function bngTasaCambio_clicked(opcion:Number) {
		return this.ctx.oficial_bngTasaCambio_clicked(opcion);
	}
	function sldPorcentajeChanged(valor:Number) {
		return this.ctx.oficial_sldPorcentajeChanged(valor);
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
/** \C El marco 'Contabilidad' se habilitará en caso de que esté cargado el módulo principal de contabilidad.
\end */
function interna_init() {
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	this.iface.bngTasaCambio = this.child("bngTasaCambio");
	this.iface.sldPorcentaje = this.child("sldPorcentaje");
	this.iface.divisaEmpresa = util.sqlSelect("empresa", "coddivisa", "1 = 1");

	this.iface.contabActivada = sys.isLoadedModule("flcontppal") && util.sqlSelect("empresa", "contintegrada", "1 = 1");

	this.iface.sumaAnticipos = util.sqlSelect("anticiposcli", "SUM(importe)", "idpedido = " + cursor.valueBuffer("idpedido") + " AND idanticipo <> " + cursor.valueBuffer("idanticipo"));

	this.iface.ejercicioActual = flfactppal.iface.pub_ejercicioActual();
	if (this.iface.contabActivada) {
		this.iface.longSubcuenta = util.sqlSelect("ejercicios", "longsubcuenta", "codejercicio = '" + this.iface.ejercicioActual + "'");
		this.child("fdbIdSubcuenta").setFilter("codejercicio = '" + this.iface.ejercicioActual + "'");
		this.iface.posActualPuntoSubcuenta = -1;
	} else {
		this.child("tbwAnticiposCli").setTabEnabled("contabilidad", false);
	}

	this.child("fdbTasaConv").setDisabled(true);
	this.child("tdbPartidas").setReadOnly(true);

	connect(this.iface.sldPorcentaje, "valueChanged(int)", this, "oficial_sldPorcentajeChanged");
	this.iface.connSld = true;

	switch (cursor.modeAccess()) {
		case cursor.Insert:
			this.child("fdbCodCuenta").setValue(this.iface.calculateField("codcuenta"));
			if (this.iface.contabActivada) {
				this.child("fdbIdSubcuenta").setValue(this.iface.calculateField("idsubcuentadefecto"));
			}
			if (cursor.cursorRelation().valueBuffer("coddivisa") != this.iface.divisaEmpresa) {
				this.child("fdbTasaConv").setDisabled(false);
				this.child("rbnTasaActual").checked = true;
				this.iface.bngTasaCambio_clicked(0);
			}

			var numero:String = cursor.size() + 1;
			this.child( "fdbCodigo" ).setValue( cursor.cursorRelation().valueBuffer( "codigo" ) + "-" + numero );
			this.child( "fdbConcepto" ).setValue( util.translate( "scripts", "Pago anticipado pedido " ) + this.child( "fdbCodigo" ).value() );
			this.child( "fdbImporte" ).setValue( cursor.cursorRelation().valueBuffer( "total" ) - this.iface.sumaAnticipos );
			break;
		case cursor.Edit:
			if (cursor.valueBuffer("idsubcuenta") == "0")
				cursor.setValueBuffer("idsubcuenta", "");
			this.iface.bufferChanged( "importe" );
			break;
		case cursor.Browse:
			this.iface.bngTasaCambio.enabled = false;
			this.iface.sldPorcentaje.enabled = false;
			this.child( "spinValPor" ).enabled = false;
	}
}

function interna_validateForm():Boolean
{
	var util:FLUtil = new FLUtil();

	/** \C
	Si la contabilidad está integrada, se debe seleccionar una subcuenta válida a la que asignar el asiento de pago o devolución
	\end */
	if (this.iface.contabActivada && !this.child("fdbNoGenerarAsiento").value() && (this.child("fdbCodSubcuenta").value().isEmpty() || this.child("fdbIdSubcuenta").value() == 0)) {
		MessageBox.warning(util.translate("scripts", "Debe seleccionar una subcuenta válida a la que asignar el asiento de pago o devolución"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	/** \C
	El importe del anticipo debe ser mayor que cero
	\end */
	if ( this.child( "fdbImporte" ).value() <= 0 ) {
		MessageBox.warning(util.translate( "scripts", "El importe debe ser mayor que cero"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton );
		return false;
	}

	/** \C
	La suma de anticipos no puede superior al total del pedido
	\end */
	var difAnticipos:Number = this.iface.sumaAnticipos + parseFloat( this.child( "fdbImporte" ).value() ) - parseFloat( this.cursor().cursorRelation().valueBuffer( "total" ) );
	difAnticipos = parseFloat( util.roundFieldValue( difAnticipos, "pedidoscli", "total" ) );
	if ( difAnticipos > 0  ) {
		MessageBox.warning(util.translate( "scripts", "La suma de anticipos no puede superar el total del pedido"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton );
		return false;
	}

	return true;
}

function interna_calculateField(fN:String):String
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var res:String;
	switch (fN) {
		/** \D
		La subcuenta contable por defecto será la asociada a la cuenta bancaria. Si ésta está vacía, será la subcuenta correspondienta a Caja
		\end */
	case "idsubcuentadefecto":
		if (this.iface.contabActivada) {
			var codSubcuenta:String = util.sqlSelect("cuentasbanco", "codsubcuenta", "codcuenta = '" + cursor.valueBuffer("codcuenta") + "'");
			if (codSubcuenta)
				res = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + codSubcuenta + "' AND codejercicio = '" + this.iface.ejercicioActual + "'");
			else {
				var qrySubcuenta:FLSqlQuery = new FLSqlQuery();
				qrySubcuenta.setTablesList("co_cuentas,co_subcuentas");
				qrySubcuenta.setSelect("s.idsubcuenta");
				qrySubcuenta.setFrom("co_cuentas c INNER JOIN co_subcuentas s ON c.idcuenta = s.idcuenta");
				qrySubcuenta.setWhere("c.codejercicio = '" + this.iface.ejercicioActual + "'" + " AND c.idcuentaesp = 'CAJA'");

				if (!qrySubcuenta.exec())
					return false;
				if (!qrySubcuenta.first())
					return false;
				res = qrySubcuenta.value(0);
			}
		}
		break;
		case "idsubcuenta":
			var codSubcuenta:String = cursor.valueBuffer("codsubcuenta").toString();
			if (codSubcuenta.length == this.iface.longSubcuenta)
				res = util.sqlSelect("co_subcuentas", "idsubcuenta",
													 "codsubcuenta = '" + codSubcuenta +
													 "' AND codejercicio = '" + this.iface.ejercicioActual + "'");
			break;
		/** \C
		La cuenta bancaria por defecto será la asociada al cliente (Cuenta 'Remesar en'). Si el cliente no está informado o no tiene especificada la cuenta, se tomará la cuenta asociada a la forma de pago asignada a la factura del recibo. 
		\end */
		case "codcuenta":
			res = false;
			var codCliente:String = cursor.cursorRelation().valueBuffer("codcliente");
			if (codCliente)
				res = util.sqlSelect("clientes", "codcuentarem", "codcliente = '" + codCliente + "'");
			if (!res) {
				var codpago:String = util.sqlSelect("pedidoscli", "codpago", "idpedido = " + cursor.cursorRelation().valueBuffer("idpedido"));
				res = util.sqlSelect("formaspago", "codcuenta", "codpago = '" + codpago + "'");
			}
			break;
		case "dc":
			var entidad:String = cursor.valueBuffer("ctaentidad");
			var agencia:String = cursor.valueBuffer("ctaagencia");
			var cuenta:String = cursor.valueBuffer("cuenta");
			if ( !entidad.isEmpty() && !agencia.isEmpty() && ! cuenta.isEmpty() 
					&& entidad.length == 4 && agencia.length == 4 && cuenta.length == 10 ) {
				var util:FLUtil = new FLUtil();
				var dc1:String = util.calcularDC(entidad + agencia);
				var dc2:String = util.calcularDC(cuenta);
				res = dc1 + dc2;
			}
			break;
		}
	return res;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_bufferChanged(fN:String)
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	switch (fN) {
	/** \C
	Si el usuario pulsa la tecla del punto '.', la subcuenta se informa automaticamente con el código de cuenta más tantos ceros como sea necesario para completar la longitud de subcuenta asociada al ejercicio actual.
	\end */
	case "codsubcuenta":
		if (!this.iface.bloqueoSubcuenta) {
			this.iface.bloqueoSubcuenta = true;
			this.iface.posActualPuntoSubcuenta = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuenta", this.iface.longSubcuenta, this.iface.posActualPuntoSubcuenta);
			this.iface.bloqueoSubcuenta = false;
		}
		if (!this.iface.bloqueoSubcuenta && this.child("fdbCodSubcuenta").value().length == this.iface.longSubcuenta) {
			this.child("fdbIdSubcuenta").setValue(this.iface.calculateField("idsubcuenta"));
		}
		break;
		/** \C
		Si el usuario selecciona una cuenta bancaria, se tomará su cuenta contable asociada como cuenta contable para el pago. La subcuenta contable por defecto será la asociada a la cuenta bancaria. Si ésta está vacía, será la subcuenta correspondienta a Caja
		\end */
	case "codcuenta":
	case "ctaentidad":
	case "ctaagencia":
	case "cuenta":
		this.child("fdbIdSubcuenta").setValue(this.iface.calculateField("idsubcuentadefecto"));
		this.child("fdbDc").setValue(this.iface.calculateField("dc"));
		break;
	case "importe":
		var total:Number = parseFloat( this.cursor().cursorRelation().valueBuffer("total") );
		if ( total != 0 ){
			this.iface.connSld = false;
			var importe:Number = parseFloat( this.cursor().valueBuffer( "importe" ) );
			var newPor:Number;
			newPor = importe * 100 / total;
			this.child( "spinValPor" ).setValue( newPor );
			this.iface.connSld = true;
		}
		break;
	}
}

/** \D
Establece el valor de --tasaconv-- obteniéndolo del pedido o del cambio actual de la divisa del recibo
@param	opcion: Origen de la tasa: tasa actual o tasa de la factura original
\end */
function oficial_bngTasaCambio_clicked(opcion:Number)
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	switch (opcion) {
	case 0: // Tasa actual
		this.child("fdbTasaConv").setValue(util.sqlSelect("divisas", "tasaconv", "coddivisa = '" + cursor.cursorRelation().valueBuffer("coddivisa") + "'"));
		break;
	case 1: // Tasa del pedido
		this.child("fdbTasaConv").setValue(util.sqlSelect("pedidoscli", "tasaconv", "idpedido = " + cursor.valueBuffer("idpedido")));
		break;
	}
}

function oficial_sldPorcentajeChanged(valor:Number)
{
	if ( !this.iface.connSld )
		return;

	var util:FLUtil = new FLUtil();
	var importe:Number = parseFloat( this.child( "fdbImporte" ).value() );
	var newImporte:Number;
	newImporte = parseFloat( this.cursor().cursorRelation().valueBuffer("total") ) * valor / 100;
	this.child( "fdbImporte" ).setValue( newImporte );
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
