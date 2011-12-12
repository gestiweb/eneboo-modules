/***************************************************************************
                 pagosdevolcli.qs  -  description
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
	function validateForm() { return this.ctx.interna_validateForm(); }
	//function acceptedForm() { return this.ctx.interna_acceptedForm(); }
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
	var noGenAsiento:Boolean;
	var curFacturaCli:FLSqlCursor;
	var curFacturaProv:FLSqlCursor;
	var curRelacionado:FLSqlCursor;
	
	function oficial( context ) { interna( context ); } 
	function desconexion() {
		return this.ctx.oficial_desconexion();
	}
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function bngTasaCambio_clicked(opcion:Number) {
		return this.ctx.oficial_bngTasaCambio_clicked(opcion);
	}
	function insertarFacturaDevolCli() {
		return this.ctx.oficial_insertarFacturaDevolCli();
	}
	function datosFacturaCli(qryFacturaCli:FLSqlQuery):Boolean {
		return this.ctx.oficial_datosFacturaCli(qryFacturaCli);
	}
	/*
	function totalesFacturaCli():Boolean {
		return this.ctx.oficial_totalesFacturaCli();
	}
	function lineaFacturaCli(idFactura:String, refGastosCli:String):Boolean {
		return this.ctx.oficial_lineaFacturaCli(idFactura, refGastosCli);
	}
	*/
	function insertarFacturaDevolProv() {
		return this.ctx.oficial_insertarFacturaDevolProv();
	}
	function datosFacturaProv(qryFacturaProv:FLSqlQuery):Boolean {
		return this.ctx.oficial_datosFacturaProv(qryFacturaProv);
	}
	function comprobarRemesaPagada(idRemesa:String):Boolean {
		return this.ctx.oficial_comprobarRemesaPagada(idRemesa);
	}
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration pagosMulti */
/////////////////////////////////////////////////////////////////
//// PAGOS MULTI ////////////////////////////////////////////////
class pagosMulti extends oficial {
    function pagosMulti( context ) { oficial ( context ); }
	function init() {
		return this.ctx.pagosMulti_init();
	}
}
//// PAGOS MULTI ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration infoVencimtos */
//////////////////////////////////////////////////////////////////
//// INFO VENCIMIENTOS ///////////////////////////////////////////
class infoVencimtos extends pagosMulti {
    function infoVencimtos( context ) { pagosMulti( context ); } 
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
/** \C El marco 'Contabilidad' se habilitará en caso de que esté cargado el módulo principal de contabilidad.
\end */
function interna_init()
{
	var cursor:FLSqlCursor = this.cursor();
	
	if (!this.iface.curRelacionado)
		this.iface.curRelacionado = cursor.cursorRelation();
	
	var util:FLUtil = new FLUtil();
	this.iface.bngTasaCambio = this.child("bngTasaCambio");
	this.iface.divisaEmpresa = util.sqlSelect("empresa", "coddivisa", "1 = 1");
	this.iface.noGenAsiento = false;

	this.iface.contabActivada = sys.isLoadedModule("flcontppal") && util.sqlSelect("empresa", "contintegrada", "1 = 1");
			
	this.iface.ejercicioActual = flfactppal.iface.pub_ejercicioActual();
	if (this.iface.contabActivada) {
		this.iface.longSubcuenta = util.sqlSelect("ejercicios", "longsubcuenta", "codejercicio = '" + this.iface.ejercicioActual + "'");
		this.child("fdbIdSubcuenta").setFilter("codejercicio = '" + this.iface.ejercicioActual + "'");
		this.iface.posActualPuntoSubcuenta = -1;
	} else {
		this.child("tbwPagDevCli").setTabEnabled("contabilidad", false);
	}

	this.child("fdbTipo").setDisabled(true);
	this.child("fdbTasaConv").setDisabled(true);
	this.child("tdbPartidas").setReadOnly(true);

	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(form, "closed()", this, "iface.desconexion");
	connect(this.iface.bngTasaCambio, "clicked(int)", this, "iface.bngTasaCambio_clicked()");
	connect(this.child("toolButtonInsertFC"), "clicked()", this, "iface.insertarFacturaDevolCli");
	connect(this.child("toolButtonInsertFP"), "clicked()", this, "iface.insertarFacturaDevolProv");
	
	var curPagosDevol:FLSqlCursor = new FLSqlCursor("pagosdevolcli");
	curPagosDevol.select("idrecibo = " + this.iface.curRelacionado.valueBuffer("idrecibo") + " ORDER BY fecha, idpagodevol");
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
	\end */
		case cursor.Insert:
			if (last) {
				if (curPagosDevol.valueBuffer("tipo") == "Pago") {
					if (!this.iface.comprobarRemesaPagada(curPagosDevol.valueBuffer("idremesa"))) {
						this.close();
						return;
					}
					this.child("fdbTipo").setValue("Devolución");
					var codCuenta:String = util.sqlSelect("pagosdevolcli", "codcuenta", "idrecibo = " + cursor.valueBuffer ("idrecibo") + " AND tipo = 'Pago' ORDER BY fecha DESC, idpagodevol DESC");
					this.child("fdbCodCuenta").setValue(codCuenta);
					if (this.iface.contabActivada) {
						this.child("fdbIdSubcuenta").setValue(this.iface.calculateField("idsubcuentadefecto"));
						this.child("fdbCodCuenta").setDisabled(true);
						this.child("fdbIdSubcuenta").setDisabled(true);
						this.child("fdbCodSubcuenta").setDisabled(true);
					}
					if (this.iface.curRelacionado.valueBuffer("coddivisa") != this.iface.divisaEmpresa) {
						this.child("fdbTasaConv").setValue(curPagosDevol.valueBuffer("tasaconv"));
					}
				} else {
					this.child("fdbTipo").setValue("Pago");
					this.child("fdbCodCuenta").setValue(this.iface.calculateField("codcuenta"));
					if (this.iface.contabActivada) {
						this.child("fdbIdSubcuenta").setValue(this.iface.calculateField("idsubcuentadefecto"));
					}
					if (this.iface.curRelacionado.valueBuffer("coddivisa") != this.iface.divisaEmpresa) {
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
				if (this.iface.curRelacionado.valueBuffer("coddivisa") != this.iface.divisaEmpresa) {
					this.child("fdbTasaConv").setDisabled(false);
					this.child("rbnTasaActual").checked = true;
					this.iface.bngTasaCambio_clicked(0);
				}
			}
			break;
		case cursor.Edit:
			if (cursor.valueBuffer("idsubcuenta") == "0")
				cursor.setValueBuffer("idsubcuenta", "");
	}
	this.iface.bufferChanged("tipo");
}

function interna_validateForm():Boolean
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
	if (util.daysTo(this.iface.curRelacionado.valueBuffer("fecha"), cursor.valueBuffer("fecha")) < 0) {
		MessageBox.warning(util.translate("scripts", "La fecha de un pago o devolución debe ser siempre igual o posterior\na la fecha de emisión del recibo."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
*/

	/** \C
	La fecha de un pago o devolución debe ser siempre posterior\na la fecha del pago o devolución anterior
	\end */
	var curPagosDevol:FLSqlCursor = new FLSqlCursor("pagosdevolcli");
	curPagosDevol.select("idrecibo = " + this.iface.curRelacionado.valueBuffer("idrecibo") + " AND idpagodevol <> " + cursor.valueBuffer("idpagodevol") + " ORDER BY  fecha, idpagodevol");
	if (curPagosDevol.last()) {
		curPagosDevol.setModeAccess(curPagosDevol.Browse);
		curPagosDevol.refreshBuffer();
		if (util.daysTo(curPagosDevol.valueBuffer("fecha"), cursor.valueBuffer("fecha")) < 0) {
			MessageBox.warning(util.translate("scripts", "La fecha de un pago o devolución debe ser siempre igual o posterior\na la fecha del pago o devolución anterior."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			return false;
		}
	}

	/** \C Si el ejercicio de la factura que originó el recibo no coincide con el ejercicio actual, se solicita al usuario que confirme el pago
	\end */
	var ejercicioFactura = util.sqlSelect("reciboscli r INNER JOIN facturascli f ON r.idfactura = f.idfactura", "f.codejercicio", "r.idrecibo = " + cursor.valueBuffer("idrecibo"), "reciboscli,facturascli");
	if (this.iface.ejercicioActual != ejercicioFactura) {
		var respuesta:Number = MessageBox.warning(util.translate("scripts", "El ejercicio de la factura que originó este recibo es distinto del ejercicio actual ¿Desea continuar?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
		if (respuesta != MessageBox.Yes)
			return false;
	}
	
	return true;
}

/** \C
Si se trata de una devolución, y en caso de que el recibo pertenezca a una remesa, se recalcula el total de la remesa excluyendo el importe del recibo
\end */
/*
function interna_acceptedForm()
{
	var cursor:FLSqlCursor = this.cursor();
	if (cursor.valueBuffer("tipo") != "Pago") {
		var idremesa:Number = this.iface.curRelacionado.valueBuffer("idremesa");
		if (idremesa > 0) {
			var idrecibo:Number = this.iface.curRelacionado.valueBuffer("idrecibo");
			this.iface.curRelacionado.setValueBuffer("idremesa", 0);
			var curRemesas:FLSqlCursor = new FLSqlCursor("remesas");
			curRemesas.select("idremesa = " + idremesa);
			curRemesas.setModeAccess(curRemesas.Edit);
			if (curRemesas.next()) {
				var util:FLUtil = new FLUtil();
				var total:Number = util.sqlSelect("reciboscli", "SUM(importe)", "idremesa = " + idremesa + " AND idrecibo <> " + idrecibo);
				curRemesas.setValueBuffer("total", total);
				curRemesas.commitBuffer();
			}
		}
	}
}
*/

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
						var codSubcuenta:String = util.sqlSelect("cuentasbanco", "codsubcuenta",
																							"codcuenta = '" +
																							cursor.
																							valueBuffer("codcuenta") + "'");
						if (codSubcuenta)
								res = util.sqlSelect("co_subcuentas", "idsubcuenta",
																		 "codsubcuenta = '" + codSubcuenta +
																		 "' AND codejercicio = '" +
																		 this.iface.ejercicioActual + "'");
						else {
								var qrySubcuenta:FLSqlQuery = new FLSqlQuery();
								qrySubcuenta.setTablesList("co_cuentas,co_subcuentas");
								qrySubcuenta.setSelect("s.idsubcuenta");
								qrySubcuenta.setFrom("co_cuentas c INNER JOIN co_subcuentas s ON c.idcuenta = s.idcuenta");
								qrySubcuenta.setWhere("c.codejercicio = '" + this.iface.ejercicioActual + "'" +
										" AND c.idcuentaesp = 'CAJA'");
								
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
																 "' AND codejercicio = '" + this.iface.ejercicioActual +
																 "'");
				break;
				/** \C
				La cuenta bancaria por defecto será la asociada al cliente (Cuenta 'Remesar en'). Si el cliente no está informado o no tiene especificada la cuenta, se tomará la cuenta asociada a la forma de pago asignada a la factura del recibo. 
				\end */
		case "codcuenta":
				res = false;
				var codCliente:String = this.iface.curRelacionado.valueBuffer("codcliente");
				if (codCliente)
					res = util.sqlSelect("clientes", "codcuentarem", "codcliente = '" + codCliente + "'");
				if (!res) {
					var codpago:String = util.sqlSelect("facturascli", "codpago", "idfactura = " + this.iface.curRelacionado.valueBuffer("idfactura"));
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
function oficial_desconexion()
{
	disconnect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged");
}

function oficial_bufferChanged(fN:String)
{
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
		this.child("fdbIdSubcuenta").
				setValue(this.iface.calculateField("idsubcuentadefecto"));
		this.child("fdbDc").setValue(this.iface.calculateField("dc"));
		break;
	case "tipo":
		if (cursor.valueBuffer("tipo") != "Devolución") {
			this.child("tbwPagDevCli").setTabEnabled("gastosdevol", false)
		}
		break;
	}
	
}

/** \D
Establece el valor de --tasaconv-- obteniéndolo de la factura original o del cambio actual de la divisa del recibo
@param	opcion: Origen de la tasa: tasa actual o tasa de la factura original
\end */
function oficial_bngTasaCambio_clicked(opcion:Number)
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	switch (opcion) {
	case 0: // Tasa actual
		this.child("fdbTasaConv").setValue(util.sqlSelect("divisas", "tasaconv", "coddivisa = '" + this.iface.curRelacionado.valueBuffer("coddivisa") + "'"));
		break;
	case 1: // Tasa de la factura
		this.child("fdbTasaConv").setValue(util.sqlSelect("facturascli", "tasaconv", "idfactura = " + this.iface.curRelacionado.valueBuffer("idfactura")));
		break;
	}
}

function oficial_insertarFacturaDevolCli()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var curFactura:FLSqlCursor = this.child("tdbFacturasCli").cursor();
	curFactura.setModeAccess(curFactura.Insert);
	if (!curFactura.commitBufferCursorRelation())
		return false;
	
	if (!this.iface.curFacturaCli)
		this.iface.curFacturaCli = new FLSqlCursor ("facturascli");

	var idFacturaRecibo:String = this.iface.curRelacionado.valueBuffer("idfactura");

	var qryFacturaCli:FLSqlQuery = new FLSqlQuery();
	qryFacturaCli.setTablesList("facturascli");
	qryFacturaCli.setSelect("codcliente, nombrecliente, cifnif, direccion, codpostal, ciudad, provincia, codpais, codalmacen, codpago, codserie, coddivisa, tasaconv");
	qryFacturaCli.setFrom("facturascli");
	qryFacturaCli.setWhere("idfactura = " + idFacturaRecibo);
	qryFacturaCli.setForwardOnly(true);
	if (!qryFacturaCli.exec()) {
		MessageBox.critical(util.translate("scripts", "Error al obtener los datos del cliente %1").arg(codCliente), MessageBox.Ok, MessageBox.NoButton);
		return false; 
	}
	if (!qryFacturaCli.first()) {
		MessageBox.warning(util.translate("scripts", "No se encuentran los datos de facturación del cliente %1").arg(codCliente), MessageBox.Ok, MessageBox.NoButton);
		return false; 
	}
/*
	var refGastosCli:String = flfactppal.iface.pub_valorDefectoEmpresa("gastosdevolcli");
	if (!refGastosCli) {
		MessageBox.warning(util.translate("scripts", "No tiene establecida la referencia correspondiente al artículo de Cobro a clientes de gastos por devolución de recibos.\nSi no lo ha hecho ya debe crear un artículo con esta o similar descripción y asociarlo en el apartado Tesorería del formulario de empresa"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
*/
	this.iface.curFacturaCli.setModeAccess(this.iface.curFacturaCli.Insert);
	this.iface.curFacturaCli.refreshBuffer();

	if (!this.iface.datosFacturaCli(qryFacturaCli))
		return false;

	if (!this.iface.curFacturaCli.commitBuffer())
		return false;

	var idFactura:Number = this.iface.curFacturaCli.valueBuffer("idfactura");
/*
	if (!this.iface.lineaFacturaCli(idFactura, refGastosCli))
		return false;

	this.iface.curFacturaCli.select("idfactura = " + idFactura);
	if (this.iface.curFacturaCli.first()) {
		if (!formRecordfacturascli.iface.pub_actualizarLineasIva(idFactura))
			return false;

		this.iface.curFacturaCli.setModeAccess(this.iface.curFacturaCli.Edit);
		this.iface.curFacturaCli.refreshBuffer();
		
		if (!this.iface.totalesFacturaCli())
			return false;

		if (this.iface.curFacturaCli.commitBuffer() == false)
			return false;
	}

	cursor.setValueBuffer("idfacturacli", idFactura);
	this.child("tdbFacturasCli").refresh();
*/
	this.child("tdbFacturasCli").refresh();
	curFactura.select("idfactura = " + idFactura);
	curFactura.first();
	curFactura.editRecord();
}

/** \D Crea una línea de factura de cliente con el artículo marcado como gasto por devolución de recibos de clientes
@param	idFactura: Identificador interno de la factura relacionada
@param	ferGastosCli: Referencia del artículo a incluir
@return	true si no hay error, false en caso contrario
\end */
/*
function oficial_lineaFacturaCli(idFactura:String, refGastosCli:String):Boolean
{
	var util:FLUtil = new FLUtil;
	var curLinea:FLSqlCursor = new FLSqlCursor("lineasfacturascli");
	curLinea.setModeAccess(curLinea.Insert);
	curLinea.refreshBuffer();
	curLinea.setValueBuffer("idfactura", idFactura);
	curLinea.setValueBuffer("referencia", refGastosCli);
	curLinea.setValueBuffer("cantidad", 1);
	curLinea.setValueBuffer("pvpunitario", this.cursor().valueBuffer("gastodevol"));
	var qryLinea:FLSqlQuery = new FLSqlQuery();
	qryLinea.setTablesList("articulos,impuestos");
	qryLinea.setSelect("a.descripcion, a.codimpuesto, i.iva");
	qryLinea.setFrom("articulos a LEFT OUTER JOIN impuestos i on a.codimpuesto = i.codimpuesto");
	qryLinea.setWhere("a.referencia = '" + refGastosCli + "'");
	qryLinea.setForwardOnly(true);
	if (!qryLinea.exec())
		return false;
	if (!qryLinea.first())
		return false;

	curLinea.setValueBuffer("descripcion", qryLinea.value("a.descripcion"));
	curLinea.setValueBuffer("codimpuesto", qryLinea.value("a.codimpuesto"));
	curLinea.setValueBuffer("iva", qryLinea.value("i.iva"));
	curLinea.setValueBuffer("recargo", 0);
	curLinea.setValueBuffer("pvpsindto", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpsindto", curLinea));
	curLinea.setValueBuffer("dtolineal", 0);
	curLinea.setValueBuffer("dtopor", formRecordlineaspedidoscli.iface.pub_commonCalculateField("dtopor", curLinea));
	curLinea.setValueBuffer("pvptotal", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotal", curLinea));

	if (!curLinea.commitBuffer())
		return false;
	
	return true;
}
*/

/** \D Establece los datos de la factura del cliente correspondiente a los gastos de devolución
@param	qryFacturaCli: Consulta que contiene los datos a incluir
@return	true si no hay error, false en caso contrario
\end */
function oficial_datosFacturaCli(qryFacturaCli:FLSqlQuery):Boolean
{
	var hoy:Date = new Date;

	this.iface.curFacturaCli.setValueBuffer("idpagodevol", this.cursor().valueBuffer("idpagodevol"));
	this.iface.curFacturaCli.setValueBuffer("codcliente", qryFacturaCli.value("codcliente"));
	this.iface.curFacturaCli.setValueBuffer("nombrecliente", qryFacturaCli.value("nombrecliente"));
	this.iface.curFacturaCli.setValueBuffer("cifnif", qryFacturaCli.value("cifnif"));
	this.iface.curFacturaCli.setValueBuffer("direccion", qryFacturaCli.value("direccion"));
	this.iface.curFacturaCli.setValueBuffer("codpostal", qryFacturaCli.value("codpostal"));
	this.iface.curFacturaCli.setValueBuffer("ciudad", qryFacturaCli.value("ciudad"));
	this.iface.curFacturaCli.setValueBuffer("provincia", qryFacturaCli.value("provincia"));
	this.iface.curFacturaCli.setValueBuffer("codpais", qryFacturaCli.value("codpais"));
	this.iface.curFacturaCli.setValueBuffer("codalmacen", qryFacturaCli.value("codalmacen"));
	this.iface.curFacturaCli.setValueBuffer("codpago", qryFacturaCli.value("codpago"));
	this.iface.curFacturaCli.setValueBuffer("codserie", qryFacturaCli.value("codserie"));
	this.iface.curFacturaCli.setValueBuffer("codejercicio", flfactppal.iface.pub_ejercicioActual());
	this.iface.curFacturaCli.setValueBuffer("coddivisa", qryFacturaCli.value("coddivisa"));
	this.iface.curFacturaCli.setValueBuffer("tasaconv", qryFacturaCli.value("tasaconv"));
	this.iface.curFacturaCli.setValueBuffer("fecha", hoy);
	this.iface.curFacturaCli.setValueBuffer("hora", hoy.toString().right(8));

	return true;
}
/** \D Informa los datos de una factura referentes a totales (I.V.A., neto, etc.)
@return	True si el cálculo se realiza correctamente, false en caso contrario
\end */
/*
function oficial_totalesFacturaCli():Boolean
{
	with (this.iface.curFacturaCli) {
		setValueBuffer("neto", formfacturascli.iface.pub_commonCalculateField("neto", this));
		setValueBuffer("totaliva", formfacturascli.iface.pub_commonCalculateField("totaliva", this));
		setValueBuffer("totalirpf", formfacturascli.iface.pub_commonCalculateField("totalirpf", this));
		setValueBuffer("totalrecargo", formfacturascli.iface.pub_commonCalculateField("totalrecargo", this));
		setValueBuffer("total", formfacturascli.iface.pub_commonCalculateField("total", this));
		setValueBuffer("totaleuros", formfacturascli.iface.pub_commonCalculateField("totaleuros", this));
	}
	return true;
}
*/
function oficial_insertarFacturaDevolProv()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var curFactura:FLSqlCursor = this.child("tdbFacturasProv").cursor();
	curFactura.setModeAccess(curFactura.Insert);
	if (!curFactura.commitBufferCursorRelation())
		return false;
	
	if (!this.iface.curFacturaProv)
		this.iface.curFacturaProv = new FLSqlCursor ("facturasprov");

	var codBanco:String = util.sqlSelect("cuentasbanco", "ctaentidad", "codcuenta = '" + cursor.valueBuffer("codcuenta") + "'");
	if (!codBanco) {
		MessageBox.warning(util.translate("scripts", "Antes de crear la factura debe establecer la cuenta bancaria"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var codProveedor:String = util.sqlSelect("bancos", "codproveedor", "entidad = '" + codBanco + "'");
	if (!codProveedor || codProveedor == "") {
		MessageBox.warning(util.translate("scripts", "El banco %1 debe tener un proveedor asociado").arg(codBanco), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var qryFacturaProv:FLSqlQuery = new FLSqlQuery();

	qryFacturaProv.setTablesList("proveedores");
	qryFacturaProv.setSelect("codproveedor, nombre, cifnif, codpago, codserie, coddivisa");
	qryFacturaProv.setFrom("proveedores");
	qryFacturaProv.setWhere("codproveedor = '" + codProveedor + "'");

	qryFacturaProv.setForwardOnly(true);
	if (!qryFacturaProv.exec()) {
		MessageBox.critical(util.translate("scripts", "Error al obtener los datos del proveedor %1").arg(codProveedor), MessageBox.Ok, MessageBox.NoButton);
		return false; 
	}
	if (!qryFacturaProv.first()) {
		MessageBox.warning(util.translate("scripts", "No se encuentran los datos de facturación del proveedor %1").arg(codProveedor), MessageBox.Ok, MessageBox.NoButton);
		return false; 
	}

	this.iface.curFacturaProv.setModeAccess(this.iface.curFacturaProv.Insert);
	this.iface.curFacturaProv.refreshBuffer();

	if (!this.iface.datosFacturaProv(qryFacturaProv))
		return false;

	if (!this.iface.curFacturaProv.commitBuffer())
		return false;

	var idFactura:Number = this.iface.curFacturaProv.valueBuffer("idfactura");

	this.child("tdbFacturasProv").refresh();
	curFactura.select("idfactura = " + idFactura);
	curFactura.first();
	curFactura.editRecord();
}

/** \D Establece los datos de la factura del proveedor correspondiente a los gastos de devolución
@param qryFacturaProv: Consulta que contiene los datos a incluir
@return	true si no hay error, false en caso contrario
\end */
function oficial_datosFacturaProv(qryFacturaProv:FLSqlQuery):Boolean
{
	var util:FLUtil = new FLUtil;
	var hoy:Date = new Date;

	this.iface.curFacturaProv.setValueBuffer("idpagodevol", this.cursor().valueBuffer("idpagodevol"));
	this.iface.curFacturaProv.setValueBuffer("codproveedor", qryFacturaProv.value("codproveedor"));
	this.iface.curFacturaProv.setValueBuffer("nombre", qryFacturaProv.value("nombre"));
	this.iface.curFacturaProv.setValueBuffer("cifnif", qryFacturaProv.value("cifnif"));
	this.iface.curFacturaProv.setValueBuffer("codalmacen", flfactppal.iface.pub_valorDefectoEmpresa("codalmacen"));
	this.iface.curFacturaProv.setValueBuffer("codpago", qryFacturaProv.value("codpago"));
	this.iface.curFacturaProv.setValueBuffer("codserie", qryFacturaProv.value("codserie"));
	this.iface.curFacturaProv.setValueBuffer("codejercicio", flfactppal.iface.pub_ejercicioActual());
	this.iface.curFacturaProv.setValueBuffer("coddivisa", qryFacturaProv.value("coddivisa"));
	this.iface.curFacturaProv.setValueBuffer("tasaconv", util.sqlSelect("divisas", "tasaconv", "coddivisa = '" + qryFacturaProv.value("coddivisa") + "'"));
	this.iface.curFacturaProv.setValueBuffer("fecha", hoy);
	this.iface.curFacturaProv.setValueBuffer("hora", hoy.toString().right(8));

	return true;
}

function oficial_comprobarRemesaPagada(idRemesa:String):Boolean
{
	var util:FLUtil = new FLUtil;
	var estadoRemesa:String = util.sqlSelect("remesas","estado","idremesa = " + idRemesa);
	var pagoIndirecto:Boolean = util.sqlSelect("factteso_general", "pagoindirecto", "1 = 1");

	if( estadoRemesa && estadoRemesa != "" && estadoRemesa != "Pagada" && pagoIndirecto) {
		MessageBox.warning(util.translate("scripts", "No se puede generar la devolución de un recibo remesado que no ha sido pagado."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
	return true;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pagosMulti */
/////////////////////////////////////////////////////////////////
//// PAGOS MULTI ////////////////////////////////////////////////
/** \D Establece el label de pago múltiple
\end */
function pagosMulti_init()
{
	this.iface.__init();
	
	if (!this.cursor().isNull("idpagomulti")) {
		var util:FLUtil = new FLUtil;
		this.child("lblPagoMulti").text = util.translate("scripts", "PAGO MÚLTIPLE Nº ") + this.cursor().valueBuffer("idpagomulti");
	}
}
//// PAGOS MULTI ////////////////////////////////////////////////
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

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////