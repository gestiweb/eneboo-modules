/***************************************************************************
                 cuentasbanco.qs  -  description
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
    var ctx;

	function interna( context ) {
		this.ctx = context;
	}
	function init() {
		this.ctx.interna_init();
	}
	function calculateCounter() {
		return this.ctx.interna_calculateCounter();
	}
	function validateForm() {
		return this.ctx.interna_validateForm();
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
	var pbnBuscarSubcuenta;
	var ejercicioActual;
	var longSubcuenta;
	var posActualPuntoSubcuenta;
	var posActualPuntoSubcuentaEcgc;
	var bloqueoSubcuenta;
	var contabilidadCargada;

	function oficial( context ) { 
		interna( context ); 
	} 
	function bufferChanged(fN) { 
		this.ctx.oficial_bufferChanged(fN); 
	}
	function tbwCuentasBancarias_currentChanged(tab) {
		return this.ctx.oficial_tbwCuentasBancarias_currentChanged(tab);
	}
	function tbnVerAsiento_clicked() {
		return this.ctx.oficial_tbnVerAsiento_clicked();
	}
	function habilitarPorPais(miForm) {
		return this.ctx.oficial_habilitarPorPais(miForm);
	}
	function commonCalculateField(fN, cursor) {
		return this.ctx.oficial_commonCalculateField(fN, cursor);
	}
	function commonBufferChanged(fN, miForm) {
		return this.ctx.oficial_commonBufferChanged(fN, miForm);
	}
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends oficial {
    function head( context ) { 
    	oficial ( context ); 
    }
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration ifaceCtx */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends head {
    function ifaceCtx( context ) { 
    	head( context ); 
    }
    function pub_commonBufferChanged(fN, miForm) {
    	return this.commonBufferChanged(fN, miForm);
    }
    function pub_commonCalculateField(fN, cursor) {
    	return this.commonCalculateField(fN, cursor);
    }
    function pub_habilitarPorPais(miForm) {
    	return this.habilitarPorPais(miForm);
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
function interna_init()
{
	var _i = this.iface;
	_i.contabilidadCargada = false;
	
	connect(this.child("tbnVerAsiento"), "clicked()", _i, "tbnVerAsiento_clicked");
	
	_i.pbnBuscarSubcuenta = this.child("pbnBuscarSubcuenta");
	var cursor = this.cursor();
	if (cursor.table() == "cuentasbcopro")
		this.child("fdbSufijo").close();
	connect(cursor, "bufferChanged(QString)", _i, "bufferChanged");

/** \C Si el módulo de contabilidad está cargado, se habilita el campo de subcuenta
\end */
	if (sys.isLoadedModule("flcontppal")) {
		_i.contabilidadCargada = true;
		_i.ejercicioActual = flfactppal.iface.pub_ejercicioActual();
		_i.longSubcuenta = AQUtil.sqlSelect("ejercicios", "longsubcuenta", "codejercicio = '" + _i.ejercicioActual + "'");
		_i.bloqueoSubcuenta = false; 
		_i.posActualPuntoSubcuenta = -1;
		_i.posActualPuntoSubcuentaEcgc = -1;
		this.child("fdbIdSubcuenta").setFilter("codejercicio = '" + _i.ejercicioActual + "'");
	} else {
		this.child("gbxContabilidad").enabled = false;
	}

	if (cursor.modeAccess() == cursor.Edit) {
		_i.bufferChanged("codsubcuenta");
	}
	
	connect(this.child("tbwCuentasBancarias"), "currentChanged(QString)", _i, "tbwCuentasBancarias_currentChanged");
	
	_i.habilitarPorPais(this);
}

function interna_calculateField(fN)
{
	var _i = this.iface;
	var cursor = this.cursor();
	
	return _i.commonCalculateField(fN, cursor);
}

/** \D Calcula el código de una nueva cuenta bancaria
@return	Código de la cuenta
\end */
function interna_calculateCounter()
{
	return AQUtil.nextCounter("codcuenta", this.cursor());
}

function interna_validateForm()
{
	var cursor = this.cursor();
	var bic = cursor.valueBuffer("bic");
	var pais = cursor.valueBuffer("codpais");
	var entidad = cursor.valueBuffer("ctaentidad");
	var agencia = cursor.valueBuffer("ctaagencia");
	var cuenta = cursor.valueBuffer("cuenta");
	
	if (bic && bic != "" && bic.length != 8 && bic.length != 11) {
		sys.warnMsgBox(sys.translate("El código bic debe tener 8 u 11 caracteres"));
		return false;
	}
	
	if (pais == "ES" && (!entidad || entidad == "")) {
		sys.warnMsgBox(sys.translate("Debe establecer la entidad bancaria"));
		return false;
	}
	if (pais == "ES" && (!agencia || agencia == "")) {
		sys.warnMsgBox(sys.translate("Debe establecer la oficina"));
		return false;
	}
	if (pais == "ES" && (!cuenta || cuenta == "")) {
		sys.warnMsgBox(sys.translate("Debe establecer la cuenta"));
		return false;
	}
	
	return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_tbnVerAsiento_clicked()
{
	var curP = this.child("tdbPartidas").cursor();
	var idAsiento = curP.valueBuffer("idasiento");
	if (!idAsiento) {
		return;
	}
	var curA = new FLSqlCursor("co_asientos");
	curA.select("idasiento = " + idAsiento);
	if (!curA.first()) {
		return false;
	}
	curA.browseRecord();
}

function oficial_bufferChanged(fN)
{
	var _i = this.iface;
	var cursor = this.cursor();
	
	switch (fN) {
		case "codsubcuenta": {
			if (_i.contabilidadCargada) {
				if (!_i.bloqueoSubcuenta) {
					_i.bloqueoSubcuenta = true;
					_i.posActualPuntoSubcuenta = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuenta", _i.longSubcuenta, _i.posActualPuntoSubcuenta);
					_i.bloqueoSubcuenta = false;
				}
			}
			break;
		}
		case "codsubcuentaecgc": {
			if (_i.contabilidadCargada) {
				if (!_i.bloqueoSubcuenta) {
					_i.bloqueoSubcuenta = true;
					_i.posActualPuntoSubcuentaEcgc = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuentaEfgc", _i.longSubcuenta, _i.posActualPuntoSubcuentaEcgc);
					_i.bloqueoSubcuenta = false;
				}
			}
			break;
		}
		default: {
			_i.commonBufferChanged(fN, this);
			break;
		}
	}
}

function oficial_habilitarPorPais(miForm)
{
	var _i = this.iface;
	var cursor = miForm.cursor();
	
	var codPais = cursor.valueBuffer("codpais");
	var codIso = AQUtil.sqlSelect("paises", "codiso", "codpais = '" + codPais + "'");
	
	if (codIso != "ES") {
		miForm.child("fdbCodigoCuenta").setDisabled(false);
		miForm.child("gbxCuentaEsp").close();
	}
	else {
		miForm.child("fdbCodigoCuenta").setDisabled(true);
		miForm.child("gbxCuentaEsp").show();
	}
}

function oficial_tbwCuentasBancarias_currentChanged(tab)
{
	var _i = this.iface;
	var cursor = this.cursor();
	
	switch (tab) {
		case "libromayor": {
			var codEjercicio = flfactppal.iface.pub_ejercicioActual();
			var idSubcuenta = AQUtil.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + cursor.valueBuffer("codsubcuenta") + "' AND codejercicio = '" + codEjercicio + "'");
			var filtro = idSubcuenta ? ("idsubcuenta = " + idSubcuenta) : "1 = 2";
			this.child("tdbPartidas").cursor().setMainFilter(filtro);
			this.child("tdbPartidas").refresh();
			break;
		}
	}
}

function oficial_commonCalculateField(fN, cursor)
{
	var _i = this.iface;
	var valor;
	
	switch (fN) {
		case "codigocuenta_es": {
			var entidad = cursor.valueBuffer("ctaentidad");
			entidad = entidad ? entidad : "";
			var agencia = cursor.valueBuffer("ctaagencia");
			agencia = agencia ? agencia : "";
			var dc = cursor.valueBuffer("ctadc");
			dc = dc ? dc : "";
			var cuenta = cursor.valueBuffer("cuenta");
			cuenta = cuenta ? cuenta : "";
			valor = entidad + agencia + dc + cuenta;		
			break;
		}
		case "ctadc": {
			var entidad = cursor.valueBuffer("ctaentidad");
			entidad = entidad ? entidad : "";
			var agencia = cursor.valueBuffer("ctaagencia");
			agencia = agencia ? agencia : "";
			var cuenta = cursor.valueBuffer("cuenta");
			cuenta = cuenta ? cuenta : "";
			var dc1 = AQUtil.calcularDC(entidad + agencia);
			var dc2 = AQUtil.calcularDC(cuenta);
			valor = dc1.toString() + dc2.toString();
			break;
		}
		case "iban": {
			var codigoCuenta = cursor.valueBuffer("codigocuenta");
			var codPais = cursor.valueBuffer("codpais");
			valor = flfactppal.iface.pub_calcularIBAN(codigoCuenta, codPais);
			break;
		}
        case "bic": {
            var entidad:String = cursor.valueBuffer("ctaentidad");
            valor = AQUtil.sqlSelect("bancos", "bic", "entidad = '"+entidad+"'");
            break;
        }
	}
	return valor;
}

function oficial_commonBufferChanged(fN, miForm)
{
	var _i = this.iface;
	var cursor = miForm.cursor();
	
	switch(fN) {
		case "ctaagencia":
		case "ctaentidad":
		case "cuenta": {
			sys.setObjText(miForm,"fdbCtaDC", _i.commonCalculateField("ctadc", cursor));
			sys.setObjText(miForm, "fdbCodigoCuenta", _i.commonCalculateField("codigocuenta_es",cursor));
			break;
		}
		case "codpais": {
			_i.habilitarPorPais(miForm);
			
			sys.setObjText(miForm,"entidad","");
			sys.setObjText(miForm,"fdbEntidad","");
			sys.setObjText(miForm,"agencia","");
			sys.setObjText(miForm,"fdbAgencia","");
			sys.setObjText(miForm,"cuenta","");
			
			sys.setObjText(miForm,"fdbIBAN", _i.commonCalculateField("iban", cursor));
			break;
		}
		case "codigocuenta": {
			sys.setObjText(miForm,"fdbIBAN", _i.commonCalculateField("iban", cursor));
			break;
		}
	}
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
