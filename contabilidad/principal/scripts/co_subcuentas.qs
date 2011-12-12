/***************************************************************************
                 flfacturac.qs  -  description
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
	function calculateField( fN:String ):String { return this.ctx.interna_calculateField( fN ); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var posActualPuntoSubcuenta:Number;
	var ejercicioActual:String;
	var longSubcuenta:Number;
	var bloqueoSubcuenta:Boolean;
    function oficial( context ) { interna( context ); } 
	function desconexion() {
		return this.ctx.oficial_desconexion();
	}
	function bufferChanged(fN) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function habilitarIVA() {
		return this.ctx.oficial_habilitarIVA();
	}
    function verAsiento() {
		return this.ctx.oficial_verAsiento();
	}
	function validarSubcuenta() {
		return this.ctx.oficial_validarSubcuenta();
	}
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration modelo303 */
/////////////////////////////////////////////////////////////////
//// MODELO 303 /////////////////////////////////////////////////
class modelo303 extends oficial {
    function modelo303( context ) { oficial ( context ); }
	function habilitarIVA() {
		return this.ctx.modelo303_habilitarIVA();
	}
}
//// MODELO 303 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends modelo303 {
    function head( context ) { modelo303 ( context ); }
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
El cuadro I.V.A. permanecerá por defecto inhabilitado. Si la cuenta es de I.V.A. se habilitará el marco de I.V.A.

En modo inserción la divisa asignada será la divisa por defecto de la empresa. La subcuenta toma como prefijo el valor de la cuenta asociada

En modo edición la cuenta aparecerá inhabilitada
\end */
function interna_init()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	
	this.iface.ejercicioActual = flfactppal.iface.pub_ejercicioActual();
	this.iface.longSubcuenta = util.sqlSelect("ejercicios", "longsubcuenta",  "codejercicio = '" + this.iface.ejercicioActual + "'");
	this.iface.posActualPuntoSubcuenta = -1;
	this.iface.bloqueoSubcuenta = false;

	this.iface.habilitarIVA();
	
	switch (cursor.modeAccess()) {
		case cursor.Insert: 
			cursor.setValueBuffer("codejercicio", this.iface.ejercicioActual);
			this.child("fdbCodDivisa").setValue(util.sqlSelect("empresa", "coddivisa", "1 = 1"));
			break;
		case cursor.Edit:
			this.child("fdbIdCuenta").setDisabled(true);
			this.child("fdbCodCuenta").setDisabled(true);
			this.child("fdbCodSubcuenta").setDisabled(true);
			break;
	}

	this.child("fdbIdCuenta").setFilter("codejercicio = '" + this.iface.ejercicioActual + "'");
	this.child("tdbPartidas").setReadOnly(true);
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(form, "closed()", this, "iface.desconexion");
	connect(this.child("pbnVerAsiento"), "clicked()", this, "iface.verAsiento");
}

function interna_calculateField(fN):String
{
		var util:FLUtil = new FLUtil();
		var res;
		var cursor:FLSqlCursor = this.cursor();
		
		switch(fN) {
				/** \D Toma como prefijo el número de cuenta a la que pertenece
				\end */
				case "codsubcuenta":
						res = cursor.valueBuffer("codcuenta");
						break;
				/** \D Busca el idcuenta correspondiente al código de cuenta y ejercicio actuales
				\end */
				case "idcuenta":
						res = util.sqlSelect("co_cuentas", "idcuenta",
								"codcuenta = '" + cursor.valueBuffer("codcuenta") + "'" +
								" AND codejercicio = '" + this.iface.ejercicioActual + "'");								
						break;
		}
		
		return res;
}

function interna_validateForm()
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	if (!this.iface.validarSubcuenta()) {
		return false;
	}

	/** \C
	El código de subcuenta tendrá como prefijo el código de la cuenta
	\end */
	return true;
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

function oficial_bufferChanged(fN)
{
	var cursor:FLSqlCursor = this.cursor();
	switch(fN) {
		/*U Al cambiar --codcuenta--, si la cuenta es de I.V.A. y no existen partidas asociadas a la subcuenta, se habilitará el marco de I.V.A.
		\end */
		case "codcuenta":
			this.child("fdbCodSubcuenta").setValue(this.iface.calculateField("codsubcuenta"));
			var idCuenta:Number = this.iface.calculateField("idcuenta");
			if (idCuenta) this.child("fdbIdCuenta").setValue(idCuenta);
			this.iface.habilitarIVA();
			break;
		/*U Al introducir --codsubcuenta--, si el usuario pulsa la tecla del punto '.', la subcuenta se informa automaticamente con el código de cuenta más tantos ceros como sea necesario para completar la longitud de subcuenta asociada al ejercicio actual.
		\end */
		case "codsubcuenta":
			if (!this.iface.bloqueoSubcuenta) {
				this.iface.bloqueoSubcuenta = true;
				this.iface.posActualPuntoSubcuenta = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuenta", this.iface.longSubcuenta, this.iface.posActualPuntoSubcuenta);
				this.iface.bloqueoSubcuenta = false;
			}
			break;
	}
}

/** \D Si la cuenta es de I.V.A. y no existen partidas asociadas a la subcuenta, se habilitará el marco de I.V.A.
\end */
function oficial_habilitarIVA()
{
		var util:FLUtil = new FLUtil();
		var cursor:FLSqlCursor = this.cursor();
		if (util.sqlSelect("co_cuentas", "idcuentaesp", 
				"idcuenta = '" + cursor.valueBuffer("idcuenta") + "'" +
				" AND (idcuentaesp = 'IVASOP' OR idcuentaesp = 'IVAREP')")) { 
				this.child("fdbCodImpuesto").setDisabled(false);
				this.child("fdbIVA").setDisabled(false);
				this.child("fdbRecargo").setDisabled(false);
				return;
		}

		this.child("fdbCodImpuesto").setValue("");
		this.child("fdbIVA").setValue("");
		this.child("fdbRecargo").setValue("");
		this.child("fdbCodImpuesto").setDisabled(true);
		this.child("fdbIVA").setDisabled(true);
		this.child("fdbRecargo").setDisabled(true);
}

function oficial_verAsiento()
{
	var util:FLUtil = new FLUtil();
	var curAsiento:FLSqlCursor = new FLSqlCursor("co_asientos");
	var curPartidas:FLSqlCursor = this.child("tdbPartidas").cursor();
	
	curAsiento.select("idasiento = " + curPartidas.valueBuffer("idasiento"));
	if (curAsiento.first()) {
		curAsiento.browseRecord();
	}
	else {
		MessageBox.information(util.translate("MetaData", "No hay ninguna partida seleccionada"),
			MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
	}
}

function oficial_validarSubcuenta()
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	/** \C
	La longitud del código de subcuenta debe coincidir con la longitud de subcuenta asignada al ejercicio actual
	\end */
	var codSubcuenta:String = cursor.valueBuffer("codsubcuenta");
	if (cursor.modeAccess() == cursor.Insert) {
		if (codSubcuenta && codSubcuenta != "") {
			if (codSubcuenta.length != this.iface.longSubcuenta) {
				MessageBox.warning(util.translate("MetaData", "El código de subcuenta debe tener la longitud establecida para el ejercicio actual: ") + this.iface.longSubcuenta, MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				return false;
			}
		}
	}

	var codCuenta:String = cursor.valueBuffer("codcuenta");
	if (util.sqlSelect("co_cuentas", "codcuenta", "idcuenta = " + cursor.valueBuffer("idcuenta")) != codCuenta) {
		MessageBox.warning(util.translate("MetaData", "El código de cuenta no existe o no coincide con el idendentificador interno, borre dicho código y vuélvalo a escribir"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var codSubcuenta:String = cursor.valueBuffer("codsubcuenta");
	if (codCuenta && codCuenta != "" && codSubcuenta && codSubcuenta != "") {
		if (!codSubcuenta.startsWith(codCuenta)) {
			MessageBox.warning(util.translate("MetaData", "El código de subcuenta debe comenzar por el código de su cuenta asociada"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}
	
	return true;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition modelo303 */
/////////////////////////////////////////////////////////////////
//// MODELO 303 /////////////////////////////////////////////////
function modelo303_habilitarIVA()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	this.iface.__habilitarIVA();

	if (util.sqlSelect("co_cuentas", "idcuentaesp", 
			"idcuenta = '" + cursor.valueBuffer("idcuenta") + "'" +
			" AND (idcuentaesp = 'IVASOP' OR idcuentaesp = 'IVAREP')")) { 
			this.child("fdbCasilla303").setDisabled(false);
			return;
	}

	this.child("fdbCasilla303").setValue("");
	this.child("fdbCasilla303").setDisabled(true);
}
//// MODELO 303 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////