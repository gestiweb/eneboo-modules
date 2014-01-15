/***************************************************************************
                 factteso_general.qs  -  description
                             -------------------
    begin                : mie nov 23 2005
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
	var ctx;
	function interna( context ) { this.ctx = context; }
	function main() {
		this.ctx.interna_main();
	}
	function init() {
		this.ctx.interna_init();
	}
	function calculateField(fN) {
		return this.ctx.interna_calculateField(fN);
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	function oficial( context ) { interna( context ); }
	function bufferChanged(fN) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function tbnActFechasCobro_clicked() {
		return this.ctx.oficial_tbnActFechasCobro_clicked();
	}
	function tbnCalcularDatosCuenta_clicked() {
		return this.ctx.oficial_tbnCalcularDatosCuenta_clicked();
	}
	function actualizarFechasCobroCli() {
		return this.ctx.oficial_actualizarFechasCobroCli();
	}
	function habilitaPorPagoRemesaCli() {
		return this.ctx.oficial_habilitaPorPagoRemesaCli();
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

/** @class_declaration ifaceCtx*/
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
/**
\C Los datos generales son únicos, por tanto formulario de no presenta los botones de navegación por registros.
\end

\D La gestión del formulario se hace de forma manual mediante el objeto f (FLFormSearchDB)
\end
\end */
function interna_main()
{
	var f = new FLFormSearchDB("factteso_general");
	var cursor = f.cursor();

	cursor.select();
	if (!cursor.first())
		cursor.setModeAccess(cursor.Insert);
	else
		cursor.setModeAccess(cursor.Edit);

	f.setMainWidget();
	if (cursor.modeAccess() == cursor.Insert)
		f.child("pushButtonCancel").setDisabled(true);
	cursor.refreshBuffer();
	var commitOk= false;
	var acpt;
	cursor.transaction(false);
	while (!commitOk) {
		acpt = false;
		f.exec("id");
		acpt = f.accepted();
		if (!acpt) {
			if (cursor.rollback())
				commitOk = true;
		} else {
			if (cursor.commitBuffer()) {
				cursor.commit();
				commitOk = true;
				flfactteso.iface.pub_cargaValoresDefecto();
			}
		}
		f.close();
	}
}

function interna_init()
{
	var _i = this.iface;
	var cursor = this.cursor();

	connect (cursor, "bufferChanged(QString)", _i, "bufferChanged");
	connect (this.child("tbnActFechasCobro"), "clicked()", _i, "tbnActFechasCobro_clicked");
	connect (this.child("tbnCalcularDatosCuenta"), "clicked()", _i, "tbnCalcularDatosCuenta_clicked");
	
	_i.bufferChanged("pagoindirecto");
	_i.habilitaPorPagoRemesaCli();
}

function interna_calculateField(fN)
{
	var _i = this.iface;
	var cursor = this.cursor();
	var valor;
	
	switch (fN) {
		case "pagodiferido": {
			if (cursor.valueBuffer("pagoindirecto")) {
				valor = true;
			} else {
				valor = cursor.valueBuffer("pagodiferido");
			}
			break;
		}
		case "pagoindirecto": {
			if (!cursor.valueBuffer("pagodiferido")) {
				valor = false;
			} else {
				valor = cursor.valueBuffer("pagoindirecto");
			}
			break;
		}
		case "despagoremesascli": {
			if (cursor.valueBuffer("pagoindirecto")) {
				valor = sys.translate("Al incluir un recibo de cliente en una remesa, el correspondiente asiento de pago se asigna a la subcuenta de Efectos comerciales de gestión de cobro (E.C.G.C.) asociada a la cuenta bancaria de la remesa. Cuando se recibe la confirmación del banco el usuario inserta un registro de pago para la remesa completa, que lleva las partidas de E.C.G.C. a la subcuenta de la cuenta bancaria.");
			} else if (cursor.valueBuffer("pagodiferido")) {
				valor = sys.translate("Al incluir un recibo de cliente en una remesa, el correspondiente asiento de pago no se realiza. Cuando se recibe la confirmación del banco el usuario inserta un registro de pago para la remesa completa, que generea con la fecha indicada los asientos de pago para cada recibo.");
			} else {
				valor = sys.translate("Al incluir un recibo de cliente en una remesa, el correspondiente asiento de pago se asigna directamente a la subcuenta de la cuenta bancaria indicada en la remesa.");
			}
			break;
		}
	}
	return valor;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_habilitaPorPagoRemesaCli()
{
	var cursor = this.cursor();
	if (cursor.valueBuffer("pagodiferido")) {
		this.child("fdbPagoIndirecto").setDisabled(false);
	} else {
		this.child("fdbPagoIndirecto").setDisabled(true);
	}
}

function oficial_bufferChanged(fN)
{
	var _i = this.iface;
	var cursor = this.cursor();
	
	switch (fN) {
		case "pagoindirecto": {
			this.child("fdbPagoDiferido").setValue(_i.calculateField("pagodiferido"));
			this.child("lblDesPagoIndirecto").text = _i.calculateField("despagoremesascli");
			break;
		}
		case "pagodiferido": {
			this.child("fdbPagoIndirecto").setValue(_i.calculateField("pagoindirecto"));
			this.child("lblDesPagoIndirecto").text = _i.calculateField("despagoremesascli");
			_i.habilitaPorPagoRemesaCli();
			break;
		}
	}
}

function oficial_tbnActFechasCobro_clicked()
{
	var _i = this.iface;
	
	var res = MessageBox.warning(sys.translate("Va a actualizar los campos de fecha y cuenta de cobro de todos los recibos de cliente.\n¿Está seguro?"), MessageBox.Yes, MessageBox.No);
	if (res != MessageBox.Yes) {
		return;
	}
	var curT = new FLSqlCursor("empresa");
	curT.transaction(false);
	try {
		if (_i.actualizarFechasCobroCli()) {
			curT.commit();
		}
		else {
			curT.rollback();
			sys.errorMsgBox(sys.translate("Hubo un error en la actualización de fechas y cuentas de cobro"));
			return;
		}
	} catch (e) {
		curT.rollback();
		sys.errorMsgBox(sys.translate("Hubo un error en la actualización de fechas y cuentas de cobro") + "\n" + e);
		return;
	}
	sys.infoMsgBox(sys.translate("Los recibos han sido actalizados correctamente"));
}

function oficial_tbnCalcularDatosCuenta_clicked()
{
	var _i = this.iface;
	
	var res = MessageBox.information(sys.translate("Se van a calcular los dígitos de control, los códigos de cuenta, y el IBAN de todas las cuentas de empresa, clientes, y proveedores.\n¿Quieres continuar?\n\nNota: si el código de país en la cuenta está vacío, se supondrá que es de España.\nSi tiene cuentas de otros países debe revisarlas antes e informar su correspondiente código de país"), MessageBox.Yes, MessageBox.No);
	if (res != MessageBox.Yes) {
		return;
	}
	
	var aTablas = ["cuentasbanco","cuentasbcocli","cuentasbcopro"];
	
	for(var i = 0; i < aTablas.length; i++) {
		var paso = 0;
		
		var curCuentas = new FLSqlCursor(aTablas[i]);
		curCuentas.select();
		
		var codCuenta = curCuentas.valueBuffer("codcuenta");
		var totalPasos = curCuentas.size();
		
		if(totalPasos == 0) {
			continue;
		}
		
		var nombresTabla = [sys.translate("cuentas de empresa"), sys.translate("cuentas de empresa"), sys.translate("cuentas de empresa")];
		
		AQUtil.createProgressDialog(sys.translate("Calculando datos de IBAN en las %1...").arg(nombresTabla[i]), totalPasos);
		
		while(curCuentas.next()) {
			curCuentas.setModeAccess(curCuentas.Edit);
			curCuentas.refreshBuffer();
			if (curCuentas.isNull("codpais") || AQUtil.sqlSelect("paises", "codiso", "codpais = '" + curCuentas.valueBuffer("codpais") + "'") == "ES") {
				if (curCuentas.isNull("codpais")) {
					curCuentas.setValueBuffer("codpais", AQUtil.sqlSelect("paises", "codpais", "codiso = 'ES'"));
				}
				curCuentas.setValueBuffer("ctadc", formRecordcuentasbanco.iface.pub_commonCalculateField("ctadc", curCuentas));
				curCuentas.setValueBuffer("codigocuenta", formRecordcuentasbanco.iface.pub_commonCalculateField("codigocuenta_es", curCuentas));
			}
			curCuentas.setValueBuffer("iban", formRecordcuentasbanco.iface.pub_commonCalculateField("iban", curCuentas));
			
			
			if (!curCuentas.commitBuffer()) {
				sys.warnMsgBox(sys.translate("Error en el cálculo de los datos de la cuenta %1 en %2").arg(codCuenta).arg(nombresTabla[i]));
				return;
			}
			
			AQUtil.setProgress(++paso);
			
		} 
		
		AQUtil.destroyProgressDialog();
	}
	
	sys.infoMsgBox(sys.translate("Los datos de las cuentas han sido recalculados con éxito."));
}

function oficial_actualizarFechasCobroCli()
{
	var _i = this.iface;
	
	flfactteso.iface.curReciboCli = new FLSqlCursor("reciboscli");
	var curRecibo = flfactteso.iface.curReciboCli;
	curRecibo.setActivatedCommitActions(false);
	curRecibo.setActivatedCheckIntegrity(false);	
	curRecibo.setForwardOnly(true);
	curRecibo.select();
	var totalRecibos = curRecibo.size();
	var paso = 0;
	AQUtil.createProgressDialog(sys.translate("Actualizando recibos"), totalRecibos);
	while (curRecibo.next()) {
		curRecibo.setModeAccess(curRecibo.Edit);
		curRecibo.refreshBuffer();
		if (!flfactteso.iface.totalesReciboCli()) {
			return false;
		}
// 		curRecibo.setValueBuffer("fechapago", formRecordreciboscli.iface.pub_commonCalculateField("fechapago", curRecibo));
// 		curRecibo.setValueBuffer("codcuentapago", formRecordreciboscli.iface.pub_commonCalculateField("codcuentapago", curRecibo));
		if (!curRecibo.commitBuffer()) {
			AQUtil.destroyProgressDialog();
			return false;
		}
		AQUtil.setProgress(++paso);
	}
	AQUtil.destroyProgressDialog();
	return true;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
