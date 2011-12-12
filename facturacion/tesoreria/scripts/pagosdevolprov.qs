/***************************************************************************
                 pagosdevolprov.qs  -  description
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

/** @class_declaration proveed */
//////////////////////////////////////////////////////////////////
//// PROVEED /////////////////////////////////////////////////////
class proveed extends oficial {
    function proveed( context ) { oficial( context ); } 
	var ejercicioActual:String;
	var bloqueoSubcuenta:Boolean;
	var longSubcuenta:Number;
	var contabActivada:Boolean;
	var bngTasaCambio:Object;
	var divisaEmpresa:String;
	var noGenAsiento:Boolean;
	function init() {
		return this.ctx.proveed_init();
	}
	function desconexion() {
		return this.ctx.proveed_desconexion();
	}
	function validateForm():Boolean {
		return this.ctx.proveed_validateForm();
	}
	function acceptedForm() {
		return this.ctx.proveed_acceptedForm();
	}
	function bufferChanged(fN:String) {
		return this.ctx.proveed_bufferChanged(fN);
	}
	function calculateField(fN:String):String {
		return this.ctx.proveed_calculateField(fN);
	}
	function bngTasaCambio_clicked(opcion:Number) {
		return this.ctx.proveed_bngTasaCambio_clicked(opcion);
	}
}
//// PROVEED /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration pagosMultiProv */
/////////////////////////////////////////////////////////////////
//// PAGOS MULTI PROV ///////////////////////////////////////////
class pagosMultiProv extends proveed {
    function pagosMultiProv( context ) { proveed ( context ); }
	function init() {
		return this.ctx.pagosMultiProv_init();
	}
}
//// PAGOS MULTI PROV ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration infoVencimtos */
//////////////////////////////////////////////////////////////////
//// INFO VENCIMIENTOS ///////////////////////////////////////////
class infoVencimtos extends pagosMultiProv {
    function infoVencimtos( context ) { pagosMultiProv( context ); } 
	function calculateField(fN:String):String { 
		return this.ctx.infoVencimtos_calculateField(fN); 
	}
}
//// INFO VENCIMIENTOS ///////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends infoVencimtos {
    function head( context ) { infoVencimtos ( context ); }
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

function init() {
    this.iface.init();
}

function validateForm():Boolean {
    return this.iface.validateForm();
}

function acceptedForm() {
    return this.iface.acceptedForm();
}

function calculateField(fN:String):String {
    return this.iface.calculateField(fN);
}


function interna_init() {

}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition proveed */
/////////////////////////////////////////////////////////////////
//// PROVEED ////////////////////////////////////////////////////
/** \C El marco 'Contabilidad' se habilitará en caso de que esté cargado el módulo principal de contabilidad.
\end */
function proveed_init()
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	this.iface.bngTasaCambio = this.child("bngTasaCambio");
	this.iface.divisaEmpresa = util.sqlSelect("empresa", "coddivisa", "1 = 1");
	this.iface.noGenAsiento = false;

	this.iface.contabActivada = sys.isLoadedModule("flcontppal") && util.sqlSelect("empresa", "contintegrada", "1 = 1");
	this.iface.ejercicioActual = flfactppal.iface.pub_ejercicioActual();
	if (this.iface.contabActivada) {
		this.iface.longSubcuenta = util.sqlSelect("ejercicios", "longsubcuenta", "codejercicio = '" + this.iface.ejercicioActual + "'");
		this.child("fdbIdSubcuenta").setFilter("codejercicio = '" + this.iface.ejercicioActual + "'");
	} else {
		this.child("tbwPagDevProv").setTabEnabled("contabilidad", false);
	}

	this.child("fdbTipo").setDisabled(true);
	this.child("fdbTasaConv").setDisabled(true);
	this.child("tdbPartidas").setReadOnly(true);

	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this, "closed()", this, "iface.desconexion");
	connect(this.iface.bngTasaCambio, "clicked(int)", this, "iface.bngTasaCambio_clicked()");

	
	var curPagosDevol:FLSqlCursor = new FLSqlCursor("pagosdevolprov");
	curPagosDevol.select("idrecibo = " + cursor.cursorRelation().valueBuffer("idrecibo") + " ORDER BY fecha, idpagodevol");
	var last:Boolean = false;
	if (curPagosDevol.last()) {
		last = true;
		curPagosDevol.setModeAccess(curPagosDevol.Browse);
		curPagosDevol.refreshBuffer();
		if(curPagosDevol.valueBuffer("nogenerarasiento") && curPagosDevol.valueBuffer("tipo") == "Pago"){
			this.iface.noGenAsiento = true;
			this.child("fdbNoGenerarAsiento").setValue(true);
		}
	}
	switch (cursor.modeAccess()) {
	/** \C
	En modo inserción. Los pagos y devoluciones funcionan de forma alterna: un nuevo recibo generará un pago. El siguiente será una devolucion, después un pago y así sucesivamente
	*/
		case cursor.Insert:
			if (last) {
				curPagosDevol.setModeAccess(curPagosDevol.Browse);
				curPagosDevol.refreshBuffer();
				if (curPagosDevol.valueBuffer("tipo") == "Pago") {
					this.child("fdbTipo").setValue("Devolución");
					this.child("fdbCodCuenta").setValue(util.sqlSelect("pagosdevolprov", "codcuenta", "idrecibo = " + cursor.valueBuffer("idrecibo") + " AND tipo = 'Pago' ORDER BY fecha DESC"));
					if (this.iface.contabActivada) {
						this.child("fdbCodSubcuenta").setValue(util.sqlSelect("pagosdevolprov", "codsubcuenta", "idrecibo = " + cursor.valueBuffer("idrecibo") + " AND tipo = 'Pago' ORDER BY fecha DESC"));
						//this.child("fdbCodCuenta").setDisabled(true);
						this.child("fdbIdSubcuenta").setDisabled(true);
						this.child("fdbCodSubcuenta").setDisabled(true);
					}
				} else {
					this.child("fdbTipo").setValue("Pago");
					this.child("fdbCodCuenta").setValue(this.iface.calculateField("codcuenta"));
					if (cursor.cursorRelation().valueBuffer("coddivisa") != this.iface.divisaEmpresa) {
						this.child("fdbTasaConv").setDisabled(false);
						this.child("rbnTasaActual").checked = true;
						this.iface.bngTasaCambio_clicked(0);
					}
				}
				this.child("fdbFecha").setValue(util.addDays(curPagosDevol.valueBuffer("fecha"), 1));
			} else {
				this.child("fdbTipo").setValue("Pago");
				this.child("fdbCodCuenta").setValue(this.iface.calculateField("codcuenta"));
				if (this.iface.contabActivada) {
					this.child("fdbIdSubcuenta").setValue(this.iface.calculateField("idsubcuentadefecto"));
				}
				if (cursor.cursorRelation().valueBuffer("coddivisa") != this.iface.divisaEmpresa) {
					this.child("fdbTasaConv").setDisabled(false);
					this.child("rbnTasaActual").checked = true;
					this.iface.bngTasaCambio_clicked(0);
				}
			}
			break;
		case cursor.Edit:
			if (cursor.valueBuffer("idsubcuenta") == "0")
				cursor.setValueBuffer("idsubcuenta", "");
			break;
	}
}

function proveed_desconexion()
{
	disconnect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged");
}

function proveed_validateForm():Boolean
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	/** \C
	Si es una devolución, está activada la contabilidad y su pago correspondiente no genera asiento no puede generar asiento
	\end */
	if (this.iface.contabActivada && this.iface.noGenAsiento && this.cursor().valueBuffer("tipo") == "Devolución" && !this.child("fdbNoGenerarAsiento").value()) {
		MessageBox.warning(util.translate("scripts", "No se puede generar el asiento de una devolución cuyo pago no tiene asiento asociado"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}	
	
	/** \C
	Si la contabilidad está integrada, se debe seleccionar una subcuenta válida a la que asignar el asiento de pago o devolución
	\end */
	if (this.iface.contabActivada && !this.child("fdbNoGenerarAsiento").value() && (this.child("fdbCodSubcuenta").value().isEmpty() || this.child("fdbIdSubcuenta").value() == 0)) {
		MessageBox.warning(util.translate("scripts", "Debe seleccionar una subcuenta válida a la que asignar el asiento de pago o devolución"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

/*
	La fecha de un pago o devolución debe ser siempre igual o posterior\na la fecha de emisión del recibo
	\end 
	if (util.daysTo(cursor.cursorRelation().valueBuffer("fecha"), cursor.valueBuffer("fecha")) < 0) {
		MessageBox.warning(util.translate("scripts", "La fecha de un pago o devolución debe ser siempre igual o posterior\na la fecha de emisión del recibo."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
*/
	/** \C
	La fecha de un pago o devolución debe ser siempre posterior\na la fecha del pago o devolución anterior
	\end */
	var curPagosDevol:FLSqlCursor = new FLSqlCursor("pagosdevolprov");
	curPagosDevol.select("idrecibo = " + cursor.cursorRelation().valueBuffer("idrecibo") + " AND idpagodevol <> " + cursor.valueBuffer("idpagodevol") + " ORDER BY  fecha, idpagodevol");
	if (curPagosDevol.last()) {
		curPagosDevol.setModeAccess(curPagosDevol.Browse);
		curPagosDevol.refreshBuffer();
		if (util.daysTo(curPagosDevol.valueBuffer("fecha"), cursor.valueBuffer("fecha")) <= 0) {
			MessageBox.warning(util.translate("scripts", "La fecha de un pago o devolución debe ser siempre posterior\na la fecha del pago o devolución anterior."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			return false;
		}
	}
	
	/** \C Si el ejercicio de la factura que originó el recibo no coincide con el ejercicio actual, se solicita al usuario que confirme el pago
	\end */
	var ejercicioFactura = util.sqlSelect("recibosprov r INNER JOIN facturasprov f ON r.idfactura = f.idfactura", "f.codejercicio", "r.idrecibo = " + cursor.valueBuffer("idrecibo"), "recibosprov,facturasprov");
	if (this.iface.ejercicioActual != ejercicioFactura) { 
		var respuesta:Number = MessageBox.warning(util.translate("scripts", "El ejercicio de la factura que originó este recibo es distinto del ejercicio actual ¿Desea continuar?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
		if (respuesta != MessageBox.Yes)
			return false; 
	}

	return true;
}

/** \C
Si se ha establecido un pago o devolución, la factura correspondiente al recibo se bloquea y no podrá editarse.
\end */
function proveed_acceptedForm()
{
	var cursor:FLSqlCursor = this.cursor();
	var idFactura:Number = cursor.cursorRelation().valueBuffer("idfactura");
	var curFactura:FLSqlCursor = new FLSqlCursor("facturasprov");
	curFactura.select("idfactura = " + idFactura);

	if (curFactura.first())
		curFactura.setUnLock("editable", false);

	var curPagosDevol:FLSqlCursor = new FLSqlCursor("pagosdevolprov");
	curPagosDevol.select("idrecibo = " + cursor.cursorRelation().valueBuffer("idrecibo") + " AND idpagodevol <> " + cursor.valueBuffer("idpagodevol") + " ORDER BY  fecha, idpagodevol");
	if (curPagosDevol.last()) 
		curPagosDevol.setUnLock("editable", false);
}

function proveed_bufferChanged(fN:String)
{
	var cursor:FLSqlCursor = this.cursor();
	switch (fN) {
		/** \C
		Si el usuario pulsa la tecla del punto '.', la subcuenta se informa automaticamente con el código de cuenta más tantos ceros como sea necesario para completar la longitud de subcuenta asociada al ejercicio actual.
		\end */
		case "codsubcuenta":
			if (!this.iface.bloqueoSubcuenta && this.child("fdbCodSubcuenta").value().endsWith(".")) {
				var codSubcuenta = this.child("fdbCodSubcuenta").value().toString();
				codSubcuenta = codSubcuenta.substring(0, codSubcuenta.length - 1);
				var numCeros:Number = this.iface.longSubcuenta - codSubcuenta.toString().length;
				for (var i:Number = 0; i < numCeros; i++)
					codSubcuenta += "0";
				this.iface.bloqueoSubcuenta = true;
				this.child("fdbCodSubcuenta").setValue(codSubcuenta);
				this.iface.bloqueoSubcuenta = false;
			}
			if (!this.iface.bloqueoSubcuenta && this.child("fdbCodSubcuenta").value().length ==
					this.iface.longSubcuenta) {
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
	}
}

function proveed_calculateField(fN:String):String
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
						var codSubcuenta:String = util.sqlSelect("cuentasbanco", "codsubcuenta", 
								"codcuenta = '" + cursor.valueBuffer("codcuenta") + "'");
						if (codSubcuenta)
								res = util.sqlSelect("co_subcuentas", "idsubcuenta",
										"codsubcuenta = '" + codSubcuenta + "' AND codejercicio = '" +this.iface.ejercicioActual + "'");
						else {
								var qrySubcuenta:FLSqlQuery = new FLSqlQuery();
								qrySubcuenta.setTablesList("co_cuentas,co_subcuentas");
								qrySubcuenta.setSelect("s.idsubcuenta");
								qrySubcuenta.setFrom("co_cuentas c INNER JOIN co_subcuentas s ON c.idcuenta = s.idcuenta");
								qrySubcuenta.setWhere("c.codejercicio = '" + this.iface.ejercicioActual +
										"' AND c.idcuentaesp = 'CAJA'");
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
				La cuenta bancaria por defecto será la asociada al proveedor (Cuenta 'Cuenta de pago'). Si el proveedor no está informado o no tiene especificada la cuenta, se tomará la cuenta asociada a la forma de pago asignada a la factura del recibo. 
				\end */
		case "codcuenta":
				res = false;
				var codProveedor:String = cursor.cursorRelation().valueBuffer("codproveedor");
				if (codProveedor)
					res = util.sqlSelect("proveedores", "codcuentapago", "codproveedor = '" + codProveedor + "'");
				if (!res) {
					var codpago = util.sqlSelect("facturasprov", "codpago", "idfactura = " + cursor.cursorRelation().valueBuffer("idfactura"));
					res = util.sqlSelect("formaspago", "codcuenta", "codpago = '" + codpago + "'");
				}
				break;
		case "dc":
				var entidad = cursor.valueBuffer("ctaentidad");
				var agencia = cursor.valueBuffer("ctaagencia");
				var cuenta = cursor.valueBuffer("cuenta");
				if ( !entidad.isEmpty() && !agencia.isEmpty() && ! cuenta.isEmpty() 
						&& entidad.length == 4 && agencia.length == 4 && cuenta.length == 10 ) {
					var dc1 = util.calcularDC(entidad + agencia);
					var dc2 = util.calcularDC(cuenta);
					res = dc1 + dc2;
				}
				break;
		}
		return res;
}

/** \D
Establece el valor de --tasaconv-- obteniéndolo de la factura original o del cambio actual de la divisa del recibo
@param	opcion: Origen de la tasa: tasa actual o tasa de la factura original
\end */
function proveed_bngTasaCambio_clicked(opcion:Number)
{
		var util:FLUtil = new FLUtil();
		var cursor:FLSqlCursor = this.cursor();
		switch (opcion) {
		case 0: // Tasa actual
				this.child("fdbTasaConv").setValue(util.sqlSelect("divisas", "tasaconv",
						"coddivisa = '" + cursor.cursorRelation().valueBuffer("coddivisa") + "'"));
				break;
		case 1: // Tasa de la factura
				this.child("fdbTasaConv").setValue(util.sqlSelect("facturasprov", "tasaconv",
						"idfactura = " + cursor.cursorRelation().valueBuffer("idfactura")));
				break;
		}
}

//// PROVEED ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pagosMultiProv */
/////////////////////////////////////////////////////////////////
//// PAGOS MULTI PROV ///////////////////////////////////////////
/** \D Establece el label de pago múltiple
\end */
function pagosMultiProv_init()
{
	this.iface.__init();
	
	if (!this.cursor().isNull("idpagomulti")) {
		var util:FLUtil = new FLUtil;
		this.child("lblPagoMulti").text = util.translate("scripts", "PAGO MÚLTIPLE Nº ") + this.cursor().valueBuffer("idpagomulti");
	}
}
//// PAGOS MULTI PROV ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition infoVencimtos */
/////////////////////////////////////////////////////////////////
//// INFO VENCIMIENTOS //////////////////////////////////////////
/** \D La cuenta de pago por defecto es la del recibo
\end */
function infoVencimtos_calculateField(fN:String):String
{
	var cursor:FLSqlCursor = this.cursor();
	var res:String;
	switch (fN) {
		case "codcuenta": {
			res = cursor.cursorRelation().valueBuffer("codcuentapago");
			if (!res || res == "")
				res = this.iface.__calculateField(fN);
			break;
		}
		default: {
			res = this.iface.__calculateField(fN);
			break;
		}
	}
	return res;
}
//// INFO VENCIMIENTOS //////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition ifaceCtx */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////

//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////



