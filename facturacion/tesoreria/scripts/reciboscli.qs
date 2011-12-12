/***************************************************************************
                 reciboscli.qs  -  description
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
	function validateForm():Boolean { return this.ctx.interna_validateForm(); }
	function acceptedForm() { return this.ctx.interna_acceptedForm(); }
	function calculateField(fN:String):String { return this.ctx.interna_calculateField(fN); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    var importeInicial:Number;
	var curReciboDiv:FLSqlCursor;
    function oficial( context ) { interna( context ); } 
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function cambiarEstado() {
		return this.ctx.oficial_cambiarEstado();
	}
	function obtenerEstado(idRecibo:String):String {
		return this.ctx.oficial_obtenerEstado(idRecibo);
	}
	function divisionRecibo() {
		return this.ctx.oficial_divisionRecibo();
	}
	function copiarCampoReciboDiv(nombreCampo:String, cursor:FLSqlCursor, campoInformado:Array):Boolean {
		return this.ctx.oficial_copiarCampoReciboDiv(nombreCampo, cursor, campoInformado);
	}
	function validarCuentaBancaria():Boolean {
		return this.ctx.oficial_validarCuentaBancaria();
	}
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.oficial_commonCalculateField(fN, cursor);
	}
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration anticipos */
//////////////////////////////////////////////////////////////////
//// ANTICIPOS ///////////////////////////////////////////////////
class anticipos extends oficial {
	function anticipos( context ) { oficial( context ); }
	function init() {
		this.ctx.anticipos_init();
	}
	function bufferChanged(fN:String) {
		this.ctx.anticipos_bufferChanged(fN);
	}
}
//// ANTICIPOS ///////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends anticipos {
	function head( context ) { anticipos ( context ); }
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration ifaceCtx */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends head {
	function ifaceCtx( context ) { head( context ); }
	function pub_obtenerEstado(idRecibo:String):String {
		return this.obtenerEstado(idRecibo);
	}
	function pub_commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.commonCalculateField(fN, cursor);
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
/** 
\D Se almacena el valor del importe inicial del recibo
\end
\C Los campos --fechav--, --importe--, --codcuenta-- y --coddir-- estarán deshabilitados.
\end
\end */
function interna_init()
{
	var cursor:FLSqlCursor = this.cursor();
	if (cursor.modeAccess() == cursor.Edit)
		this.iface.importeInicial = parseFloat(cursor.valueBuffer("importe"));
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this.child("tdbPagosDevolCli").cursor(), "cursorUpdated()", this, "iface.cambiarEstado");
	if (cursor.modeAccess() == cursor.Edit)
		this.child("pushButtonAcceptContinue").close();
	this.child("fdbTexto").setValue(this.iface.calculateField("texto"));

	this.iface.bufferChanged("codcuenta");
	this.iface.cambiarEstado();
}


/** \C
El importe del recibo debe ser menor o igual del que tenía anteriormente. Si es menor el recibo se fraccionará.
La fecha de vencimiento debe ser siempre igual o posterior a la fecha de emisión del recibo.
\end */
function interna_validateForm():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	if (util.daysTo(cursor.valueBuffer("fecha"), cursor.valueBuffer("fechav")) < 0) {
		MessageBox.warning(util.translate("scripts", "La fecha de vencimiento debe ser siempre igual o posterior\na la fecha de emisión del recibo."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	if (!this.iface.validarCuentaBancaria()) {
		return false;
	}

	return true;
}

function interna_acceptedForm()
{
	var util:FLUtil = new FLUtil();
	/** \C
	Actualiza el riesgo del cliente, si existe
	\end */
	var codCliente:String = this.cursor().valueBuffer("codcliente");
	if (codCliente)
		flfactteso.iface.pub_actualizarRiesgoCliente(codCliente);

	this.iface.divisionRecibo();
}

function interna_calculateField(fN:String):String
{
	var cursor:FLSqlCursor = this.cursor();
	valor = this.iface.commonCalculateField(fN, cursor);
	return valor;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_bufferChanged(fN:String)
{
	/** \C
	El cambio del --importe-- bloquea pagos y devoluciones
	\end */
	if (fN == "importe") {
		this.child("fdbTexto").setValue(this.iface.calculateField("texto"));
		this.child("gbxPagDev").setDisabled(true);
	}

	/** \C
	El --dc-- de la cuenta bancaria se calcula automáticamente en base al resto de valores de la cuenta
	\end */
	if (fN == "codcuenta" || fN == "ctaentidad" || fN == "ctaagencia" || fN == "cuenta" )
			this.child("fdbDc").setValue(this.iface.calculateField("dc"));
}

/** \D
Cambia el valor del estado del recibo entre Emitido, Cobrado y Devuelto
\end */
function oficial_cambiarEstado()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var estado:String = this.iface.calculateField("estado");
	this.child("fdbEstado").setValue(estado);
	if ( estado != "Emitido" )
		this.child("fdbImporte").setDisabled(true);
	else
		this.child("fdbImporte").setDisabled(false);
	
	if (util.sqlSelect("pagosdevolcli", "idremesa", "idrecibo = " + cursor.valueBuffer("idrecibo") + " ORDER BY fecha DESC, idpagodevol DESC") != 0) {
		this.child("lblRemesado").text = "REMESADO";
		this.child("fdbFechav").setDisabled(true);
		this.child("fdbImporte").setDisabled(true);
		this.child("fdbCodCuenta").setDisabled(true);
		this.child("coddir").setDisabled(true);
		this.child("tdbPagosDevolCli").setInsertOnly(true);
		this.child("pushButtonNext").close();
		this.child("pushButtonPrevious").close();
		this.child("pushButtonFirst").close();
		this.child("pushButtonLast").close();
	}
}

/** \D
Calcula el estado en función de los pagos y devoluciones asociados a un recibo
@param	idRecibo: Identificador del recibo cuyo estado se desea calcular
@return	Estado del recibo
\end */
function oficial_obtenerEstado(idRecibo:String):String
{
	var valor:String = "Emitido";
	var curPagosDevol:FLSqlCursor = new FLSqlCursor("pagosdevolcli");
	curPagosDevol.select("idrecibo = " + idRecibo + " ORDER BY fecha DESC, idpagodevol DESC");
	if (curPagosDevol.first()) {
		curPagosDevol.setModeAccess(curPagosDevol.Browse);
		curPagosDevol.refreshBuffer();
		if (curPagosDevol.valueBuffer("tipo") == "Pago")
			valor = "Pagado";
		else
			valor = "Devuelto";
	}
	return valor;
}

function oficial_divisionRecibo()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	/** \C
	Si el importe ha disminuido, genera un recibo complementario por la diferencia
	\end */
	var importeActual = parseFloat(form.cursor().valueBuffer("importe"));
	if (importeActual != this.iface.importeInicial) {
		var cursor = form.cursor();
		var tasaConv = parseFloat(util.sqlSelect("facturascli", "tasaconv", "idfactura = " + cursor.valueBuffer("idfactura")));
		
		cursor.setValueBuffer("importeeuros", importeActual * tasaConv);

		if (!this.iface.curReciboDiv) {
			this.iface.curReciboDiv = new FLSqlCursor("reciboscli");
		}
		this.iface.curReciboDiv.setModeAccess(this.iface.curReciboDiv.Insert);
		this.iface.curReciboDiv.refreshBuffer();

		var camposRecibo:Array = util.nombreCampos("reciboscli");
		var totalCampos:Number = camposRecibo[0];

		var campoInformado:Array = [];
		for (var i:Number = 1; i <= totalCampos; i++) {
			campoInformado[camposRecibo[i]] = false;
		}
		for (var i:Number = 1; i <= totalCampos; i++) {
			if (!this.iface.copiarCampoReciboDiv(camposRecibo[i], cursor, campoInformado)) {
				return false;
			}
		}
		this.iface.curReciboDiv.commitBuffer();
	}
}

function oficial_copiarCampoReciboDiv(nombreCampo:String, cursor:FLSqlCursor, campoInformado:Array):Boolean
{
	var util:FLUtil = new FLUtil;

	if (campoInformado[nombreCampo]) {
		return true;
	}
	var nulo:Boolean =false;

	var cursor:FLSqlCursor = this.cursor();
	switch (nombreCampo) {
		case "idrecibo": {
			return true;
			break;
		}
		case "numero": {
			valor = parseInt(util.sqlSelect("reciboscli", "numero", "idfactura = " + cursor.valueBuffer("idfactura") + " ORDER BY numero DESC")) + 1;
			break;
		}
		case "importe": {
			valor = this.iface.importeInicial - parseFloat(cursor.valueBuffer("importe"));
			break;
		}
		case "importeeuros": {
			if (!campoInformado["importe"]) {
				if (!this.iface.copiarCampoReciboDiv("importe", cursor, campoInformado)) {
					return false;
				}
			}
			var tasaConv:Number = parseFloat(util.sqlSelect("facturascli", "tasaconv", "idfactura = " + cursor.valueBuffer("idfactura")));
			valor = this.iface.curReciboDiv.valueBuffer("importe") * tasaConv;
			break;
		}
		case "codigo": {
			var codFactura:String = util.sqlSelect("facturascli", "codigo", "idfactura = " + cursor.valueBuffer("idfactura"));
			if (!campoInformado["numero"]) {
				if (!this.iface.copiarCampoReciboDiv("numero", cursor, campoInformado)) {
					return false;
				}
			}
			valor = codFactura + "-" + flfacturac.iface.pub_cerosIzquierda(this.iface.curReciboDiv.valueBuffer("numero"), 2);
			break;
		}
		case "estado": {
			valor = "Emitido";
			break;
		}
		case "texto": {
			if (!campoInformado["coddivisa"]) {
				if (!this.iface.copiarCampoReciboDiv("coddivisa", cursor, campoInformado)) {
					return false;
				}
			}
			if (!campoInformado["importe"]) {
				if (!this.iface.copiarCampoReciboDiv("importe", cursor, campoInformado)) {
					return false;
				}
			}
			var moneda = util.sqlSelect("divisas", "descripcion", "coddivisa = '" + cursor.valueBuffer("coddivisa") + "'");
			valor = util.enLetraMoneda(this.iface.curReciboDiv.valueBuffer("importe"), moneda);
			break;
		}
		default: {
			if (cursor.isNull(nombreCampo)) {
				nulo = true;
			} else {
				valor = cursor.valueBuffer(nombreCampo);
			}
		}
	}
	if (nulo) {
		this.iface.curReciboDiv.setNull(nombreCampo);
	} else {
		this.iface.curReciboDiv.setValueBuffer(nombreCampo, valor);
	}
	campoInformado[nombreCampo] = true;
	
	return true;
}

function oficial_validarCuentaBancaria():Boolean
{
debug("oficial_validarCuentaBancaria");
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var entidad:String = cursor.valueBuffer("ctaentidad");
	var agencia:String = cursor.valueBuffer("ctaagencia");
	var cuenta:String = cursor.valueBuffer("cuenta");
	var dc:String = cursor.valueBuffer("dc");
debug("entidad = " + entidad);
debug("dc = " + dc);
	if ((entidad && entidad != "") || (agencia && agencia != "") || (cuenta && cuenta != "") || (dc && dc != "")) {
debug(this.iface.calculateField("dc"));
		if (!dc || dc == "" || dc != this.iface.calculateField("dc")) {
			MessageBox.warning(util.translate("scripts", "El dígito de control de la cuenta bancaria no es correcto"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}
	return true;
}

function oficial_commonCalculateField(fN:String, cursor:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil();
	var valor:String;
	if (fN == "estado") {
		valor = this.iface.obtenerEstado(cursor.valueBuffer("idrecibo"));
	}

	if (fN == "texto") {
		var importe:Number = parseFloat(cursor.valueBuffer("importe"));
		var moneda:String = util.sqlSelect("divisas", "descripcion", "coddivisa = '" + cursor.valueBuffer("coddivisa") + "'");
		valor = util.enLetraMoneda(importe, moneda);
	}

	if (fN == "dc") {
		var entidad:String = cursor.valueBuffer("ctaentidad");
		var agencia:String = cursor.valueBuffer("ctaagencia");
		var cuenta:String = cursor.valueBuffer("cuenta");
		
		if (!entidad) entidad = "";
		if (!agencia) agencia = "";
		if (!cuenta) cuenta = "";
		
		if ( !entidad.isEmpty() && !agencia.isEmpty() && ! cuenta.isEmpty() && entidad.length == 4 && agencia.length == 4 && cuenta.length == 10 ) {
			var dc1:String = util.calcularDC(entidad + agencia);
			var dc2:String = util.calcularDC(cuenta);
			valor = dc1 + dc2;
		}
	}

	return valor;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/** @class_definition anticipos */
//////////////////////////////////////////////////////////////////
//// ANTICIPOS ///////////////////////////////////////////////////
function anticipos_init()
{
	var idAnticipo:Number = this.cursor().valueBuffer("idanticipo");
	if (idAnticipo != 0) {
		this.child("lblRemesado").text = "ANTICIPO";
		this.child("pushButtonNext").close();
		this.child("pushButtonPrevious").close();
		this.child("pushButtonFirst").close();
		this.child("pushButtonLast").close();
		this.child("pushButtonAcceptContinue").close();
		this.child("pushButtonAccept").close();

		this.child("fdbFechav").setDisabled(true);
		this.child("fdbImporte").setDisabled(true);
		this.child("fdbCodCuenta").editor().setDisabled(true);;
		this.child("coddir").editor().setDisabled(true);;
		this.child("fdbDescripcion").editor().setDisabled(true);
		this.child("fdbCtaEntidad").editor().setDisabled(true);
		this.child("fdbCtaAgencia").editor().setDisabled(true);
		this.child("fdbCuenta").editor().setDisabled(true);
		this.child("groupBoxPD").close();

		var tdbAnt:Object = this.child("tdbAnticipo");
		tdbAnt.setReadOnly(true);
		tdbAnt.cursor().setMainFilter("idanticipo = " + idAnticipo);
		tdbAnt.refresh();
		
	} else {
		this.child("groupBoxAnt").close();
		this.iface.__init();
	}
}

function anticipos_bufferChanged(fN:String)
{
	switch (fN) {
		case "importe": {
			this.child("fdbTexto").setValue(this.iface.calculateField("texto"));
			this.child("groupBoxPD").setDisabled(true);
			break;
		}
		default: {
			this.iface.__bufferChanged(fN);
		}
	}
}


//// ANTICIPOS ///////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////