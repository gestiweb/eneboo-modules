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
    var ctx:Object;

	function interna( context ) {
		this.ctx = context;
	}
	function init() {
		this.ctx.interna_init();
	}
	function calculateCounter():String {
		return this.ctx.interna_calculateCounter();
	}
	function validateForm():Boolean {
		return this.ctx.interna_validateForm();
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var pbnBuscarSubcuenta:Object;
	var ejercicioActual:String;
	var longSubcuenta:Number;
	var posActualPuntoSubcuenta:Number;
	var posActualPuntoSubcuentaEcgc:Number;
	var bloqueoSubcuenta:Boolean;
	var contabilidadCargada:Boolean;

	function oficial( context ) { interna( context ); } 
	function bufferChanged(fN:String) { this.ctx.oficial_bufferChanged(fN); }
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
function interna_init()
{
	this.iface.contabilidadCargada = false;
	var util:FLUtil = new FLUtil();
	this.iface.pbnBuscarSubcuenta = this.child("pbnBuscarSubcuenta");
	var cursor:FLSqlCursor = this.cursor();
	if (cursor.table() == "cuentasbcopro")
		this.child("fdbSufijo").close();
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	this.iface.bufferChanged("all");

/** \C Si el módulo de contabilidad está cargado, se habilita el campo de subcuenta
\end */
	if (sys.isLoadedModule("flcontppal")) {
		this.iface.contabilidadCargada = true;
		this.iface.ejercicioActual = flfactppal.iface.pub_ejercicioActual();
		this.iface.longSubcuenta = util.sqlSelect("ejercicios", "longsubcuenta", "codejercicio = '" + this.iface.ejercicioActual + "'");
		this.iface.bloqueoSubcuenta = false; 
		this.iface.posActualPuntoSubcuenta = -1;
		this.iface.posActualPuntoSubcuentaEcgc = -1;
		this.child("fdbIdSubcuenta").setFilter("codejercicio = '" + this.iface.ejercicioActual + "'");
	} else {
		this.child("gbxContabilidad").enabled = false;
	}

	if (cursor.modeAccess() == cursor.Edit) {
		this.iface.bufferChanged("codsubcuenta");
	}
}

/** \D Calcula el código de una nueva cuenta bancaria
@return	Código de la cuenta
\end */
function interna_calculateCounter():String
{
	var util:FLUtil = new FLUtil();
	return util.nextCounter("codcuenta", this.cursor());
}

function interna_validateForm():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var swift:String = cursor.valueBuffer("swift");
	if (swift && swift != "" && swift.length != 8 && swift.length != 11) {
		MessageBox.warning(util.translate("scripts", "El código swift debe tener 8 u 11 caracteres"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	return true;
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

/** \C Al cambiar --cuenta--, --ctaagencia-- o --ctaentidad-- se recalculan automáticamente los dígitos de control
\end */
	if (fN == "ctaagencia" || fN == "ctaentidad" || fN == "all") {
		var entidad:String = this.child("entidad").value();
		var agencia:String = this.child("agencia").value();
		var dc1:String = util.calcularDC(entidad + agencia);
		this.child("dc1").setText(dc1);
	}

	if (fN == "cuenta" || fN == "all") {
		var cuenta:String = this.child("cuenta").value();
		var dc2:String = util.calcularDC(cuenta);
		this.child("dc2").setText(dc2);
	}
	
	switch (fN) {
		case "codsubcuenta": {
			if (this.iface.contabilidadCargada) {
				if (!this.iface.bloqueoSubcuenta) {
					this.iface.bloqueoSubcuenta = true;
					this.iface.posActualPuntoSubcuenta = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuenta", this.iface.longSubcuenta, this.iface.posActualPuntoSubcuenta);
					this.iface.bloqueoSubcuenta = false;
				}
			}
			break;
		}
		case "codsubcuentaecgc": {
			if (this.iface.contabilidadCargada) {
				if (!this.iface.bloqueoSubcuenta) {
					this.iface.bloqueoSubcuenta = true;
					this.iface.posActualPuntoSubcuentaEcgc = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuentaEfgc", this.iface.longSubcuenta, this.iface.posActualPuntoSubcuentaEcgc);
					this.iface.bloqueoSubcuenta = false;
				}
			}
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
