/***************************************************************************
                 impuestos.qs  -  description
                             -------------------
    begin                : jue dic 23 2004
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
	var posActualPuntoSubRep:Number;
	var posActualPuntoSubSop:Number;
	var posActualPuntoSubAcr:Number;
	var posActualPuntoSubDeu:Number;
	var posActualPuntoSubIVADevAdUE:Number;
	var posActualPuntoSubIVADedAdUE:Number;
	var posActualPuntoSubIVADevEntUE:Number;
	var posActualPuntoSubIVASopImp:Number;
	var posActualPuntoSubIVARepExp:Number;
	var posActualPuntoSubIVASopExe:Number;
	var posActualPuntoSubIVARepExe:Number;
	var posActualPuntoSubIVARepRE:Number;
	var longSubcuenta:Number;
	var bloqueoSubcuenta:Boolean;
    function oficial( context ) { interna( context ); } 
	function bufferChanged(fN) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function comprobarSubcuentaIVA(codSubcuenta:String, idCuentaEsp):Boolean {
		return this.ctx.oficial_comprobarSubcuentaIVA(codSubcuenta, idCuentaEsp);
	}
	function crearCuentaEsp(idCuentaEsp:String):Boolean {
		return this.ctx.oficial_crearCuentaEsp(idCuentaEsp);
	}
	function tbnAyuda_clicked() {
		return this.ctx.oficial_tbnAyuda_clicked();
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
function interna_init()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this.child("tbnAyuda"), "clicked()", this, "iface.tbnAyuda_clicked");

	var ejercicioActual:String = flfactppal.iface.pub_ejercicioActual();
	this.child("fdbIdSubcuentaRep").setFilter("codejercicio = '" + ejercicioActual + "'");
	this.child("fdbIdSubcuentaSop").setFilter("codejercicio = '" + ejercicioActual + "'");
	this.child("fdbIdSubcuentaAcr").setFilter("codejercicio = '" + ejercicioActual + "'");
	this.child("fdbIdSubcuentaDeu").setFilter("codejercicio = '" + ejercicioActual + "'");
	this.child("fdbIdSubcuentaIVADevAdUE").setFilter("codejercicio = '" + ejercicioActual + "'");
	this.child("fdbIdSubcuentaIVADedAdUE").setFilter("codejercicio = '" + ejercicioActual + "'");
	this.child("fdbIdSubcuentaIVADevEntUE").setFilter("codejercicio = '" + ejercicioActual + "'");
	this.child("fdbIdSubcuentaIVASopImp").setFilter("codejercicio = '" + ejercicioActual + "'");
	this.child("fdbIdSubcuentaIVARepExp").setFilter("codejercicio = '" + ejercicioActual + "'");
	this.child("fdbIdSubcuentaIVASopExe").setFilter("codejercicio = '" + ejercicioActual + "'");
	this.child("fdbIdSubcuentaIVARepExe").setFilter("codejercicio = '" + ejercicioActual + "'");
	this.child("fdbIdSubcuentaIvaRepRE").setFilter("codejercicio = '" + ejercicioActual + "'");

/** \C Si el módulo de contabilidad está cargado, se habilita el campo de cuenta de ventas
\end */
	if (!sys.isLoadedModule("flcontppal"))
		this.child("gbxContabilidad").enabled = false;
	else {
		this.iface.longSubcuenta = util.sqlSelect("ejercicios", "longsubcuenta",  "codejercicio = '" + ejercicioActual + "'");
		this.iface.posActualPuntoSubRep = -1;
		this.iface.posActualPuntoSubSop = -1;
		this.iface.posActualPuntoSubAcr = -1;
		this.iface.posActualPuntoSubDeu = -1;
		this.iface.posActualPuntoSubIVADevAdUE = -1;
		this.iface.posActualPuntoSubIVADedAdUE = -1;
		this.iface.posActualPuntoSubIVADevEntUE = -1;
		this.iface.posActualPuntoSubIVASopImp = -1;
		this.iface.posActualPuntoSubIVARepExp = -1;
		this.iface.posActualPuntoSubIVASopExe = -1;
		this.iface.posActualPuntoSubIVARepExe = -1;
		this.iface.posActualPuntoSubIVARepRE = -1;
		this.iface.bloqueoSubcuenta = false;
	}
}

function interna_validateForm():Boolean
{
debug("interna_validateForm");
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	if (!this.iface.comprobarSubcuentaIVA(cursor.valueBuffer("codsubcuentarep"), "IVAREP")) {
		return false;
	}
	if (!this.iface.comprobarSubcuentaIVA(cursor.valueBuffer("codsubcuentasop"), "IVASOP")) {
		return false;
	}
	if (!this.iface.comprobarSubcuentaIVA(cursor.valueBuffer("codsubcuentaacr"), "IVAACR")) {
		return false;
	}
	if (!this.iface.comprobarSubcuentaIVA(cursor.valueBuffer("codsubcuentadeu"), "IVADEU")) {
		return false;
	}
	if (!this.iface.comprobarSubcuentaIVA(cursor.valueBuffer("codsubcuentaivadevadue"), "IVARUE")) {
		return false;
	}
	if (!this.iface.comprobarSubcuentaIVA(cursor.valueBuffer("codsubcuentaivadedadue"), "IVASUE")) {
		return false;
	}
	if (!this.iface.comprobarSubcuentaIVA(cursor.valueBuffer("codsubcuentaivadeventue"), "IVAEUE")) {
		return false;
	}
	if (!this.iface.comprobarSubcuentaIVA(cursor.valueBuffer("codsubcuentaivasopimp"), "IVASIM")) {
		return false;
	}
	if (!this.iface.comprobarSubcuentaIVA(cursor.valueBuffer("codsubcuentaivarepexp"), "IVARXP")) {
		return false;
	}
	if (!this.iface.comprobarSubcuentaIVA(cursor.valueBuffer("codsubcuentaivarepexe"), "IVAREX")) {
		return false;
	}
	if (!this.iface.comprobarSubcuentaIVA(cursor.valueBuffer("codsubcuentaivasopexe"), "IVASEX")) {
		return false;
	}
	if (!this.iface.comprobarSubcuentaIVA(cursor.valueBuffer("codsubcuentaivarepre"), "IVARRE")) {
		return false;
	}
	return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_comprobarSubcuentaIVA(codSubcuenta:String, idCuentaEsp:String):Boolean
{
debug("oficial_comprobarSubcuentaIVA " + codSubcuenta + " " + idCuentaEsp);
	var util:FLUtil = new FLUtil;

	if (!codSubcuenta || codSubcuenta == "") {
		return true;
	}

	var ejercicioActual:String = flfactppal.iface.pub_ejercicioActual();
	if (!util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + codSubcuenta + "' AND codejercicio = '" + ejercicioActual + "'")) {
		MessageBox.warning(util.translate("scripts", "La subcuenta %1 no existe en el ejercicio actual (%2)").arg(codSubcuenta).arg(ejercicioActual), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	try { 
/// Por si no está instalado el nuevo campo idcuentaesp en co_subcuentas
		if (util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + codSubcuenta + "' AND (idcuentaesp <> '" + idCuentaEsp + "' OR idcuentaesp IS NULL)")) {
			var res:Number = MessageBox.warning(util.translate("scripts", "La subcuenta %1 no está asociada a la cuenta especial %2 en todos los ejercicios.\nPara continuar debe establecer esta asociación.\n¿Desea hacerlo ahora de forma automática?").arg(codSubcuenta).arg(idCuentaEsp), MessageBox.Yes, MessageBox.No);
			if (res != MessageBox.Yes) {
				return false;
			}
			if (!util.sqlSelect("co_cuentasesp", "idcuentaesp", "idcuentaesp = '" + idCuentaEsp + "'")) {
				if (!this.iface.crearCuentaEsp(idCuentaEsp)) {
					return false;
				}
			}
			if (!util.sqlUpdate("co_subcuentas", "idcuentaesp", idCuentaEsp, "codsubcuenta = '" + codSubcuenta + "'")) {
				return false;
			}
		}
	} catch (e) {}
	return true;
}

function oficial_crearCuentaEsp(idCuentaEsp:String):Boolean
{
debug("oficial_crearCuentaEsp " + idCuentaEsp);
	var util:FLUtil = new FLUtil;

	var descripcion:String = "";
	switch (idCuentaEsp) {
		case "IVASOP": {
			descripcion = util.translate("scripts", "I.V.A. Soportado");
			break;
		}
		case "IVAREP": {
			descripcion = util.translate("scripts", "I.V.A. Repercutido");
			break;
		}
		case "IVASUE": {
			descripcion = util.translate("scripts", "I.V.A. Soportado en adquisiciones intracomunitarias");
			break;
		}
		case "IVARUE": {
			descripcion = util.translate("scripts", "I.V.A. Repercutido en adquisiciones intracomunitarias");
			break;
		}
		case "IVAEUE": {
			descripcion = util.translate("scripts", "I.V.A. Repercutido en entregas intracomunitarias");
			break;
		}
		case "IVASIM": {
			descripcion = util.translate("scripts", "I.V.A. Soportado en importaciones");
			break;
		}
		case "IVARXP": {
			descripcion = util.translate("scripts", "I.V.A. Repercutido en exportaciones");
			break;
		}
		case "IVASEX": {
			descripcion = util.translate("scripts", "I.V.A. Soportado exento");
			break;
		}
		case "IVAREX": {
			descripcion = util.translate("scripts", "I.V.A. Repercutido exento");
			break;
		}
		case "IVARRE": {
			descripcion = util.translate("scripts", "Recargo de equivalencia I.V.A. repercutido");
			break;
		}
	}
	var curCuentaEsp:FLSqlCursor = new FLSqlCursor("co_cuentasesp");
	with (curCuentaEsp) {
		setModeAccess(Insert);
		refreshBuffer();
		setValueBuffer("idcuentaesp", idCuentaEsp);
		setValueBuffer("descripcion", descripcion);
	}
	if (!curCuentaEsp.commitBuffer()) {
		return false;
	}
	return true;
}

function oficial_bufferChanged(fN)
{
	var cursor:FLSqlCursor = this.cursor();
	switch(fN) {
		/*U Al introducir un código de subcuenta, si el usuario pulsa la tecla del punto '.', la subcuenta se informa automaticamente con el código de cuenta más tantos ceros como sea necesario para completar la longitud de subcuenta asociada al ejercicio actual.
		\end */
		case "codsubcuentarep":{
				if (!this.iface.bloqueoSubcuenta) {
					this.iface.bloqueoSubcuenta = true;
					this.iface.posActualPuntoSubRep = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuentaRep", this.iface.longSubcuenta, this.iface.posActualPuntoSubRep);
					this.iface.bloqueoSubcuenta = false;
			}
			break;
		}
		case "codsubcuentasop":{
				if (!this.iface.bloqueoSubcuenta) {
					this.iface.bloqueoSubcuenta = true;
					this.iface.posActualPuntoSubSop = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuentaSop", this.iface.longSubcuenta, this.iface.posActualPuntoSubSop);
					this.iface.bloqueoSubcuenta = false;
			}
			break;
		}
		case "codsubcuentaacr":{
				if (!this.iface.bloqueoSubcuenta) {
					this.iface.bloqueoSubcuenta = true;
					this.iface.posActualPuntoSubAcr = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuentaAcr", this.iface.longSubcuenta, this.iface.posActualPuntoSubAcr);
					this.iface.bloqueoSubcuenta = false;
			}
			break;
		}
		case "codsubcuentadeu":{
				if (!this.iface.bloqueoSubcuenta) {
					this.iface.bloqueoSubcuenta = true;
					this.iface.posActualPuntoSubDeu = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuentaDeu", this.iface.longSubcuenta, this.iface.posActualPuntoSubDeu);
					this.iface.bloqueoSubcuenta = false;
			}
			break;
		}
		case "codsubcuentaivadevadue":{
				if (!this.iface.bloqueoSubcuenta) {
					this.iface.bloqueoSubcuenta = true;
					this.iface.posActualPuntoSubIVADevAdUE = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuentaIVADevAdUE", this.iface.longSubcuenta, this.iface.posActualPuntoSubIVADevAdUE);
					this.iface.bloqueoSubcuenta = false;
			}
			break;
		}
		case "codsubcuentaivadedadue":{
				if (!this.iface.bloqueoSubcuenta) {
					this.iface.bloqueoSubcuenta = true;
					this.iface.posActualPuntoSubIVADedAdUE = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuentaIVADedAdUE", this.iface.longSubcuenta, this.iface.posActualPuntoSubIVADedAdUE);
					this.iface.bloqueoSubcuenta = false;
			}
			break;
		}
		case "codsubcuentaivadeventue":{
				if (!this.iface.bloqueoSubcuenta) {
					this.iface.bloqueoSubcuenta = true;
					this.iface.posActualPuntoSubIVADevEntUE = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuentaIVADevEntUE", this.iface.longSubcuenta, this.iface.posActualPuntoSubIVADevEntUE);
					this.iface.bloqueoSubcuenta = false;
			}
			break;
		}
		case "codsubcuentaivasopimp":{
			if (!this.iface.bloqueoSubcuenta) {
				this.iface.bloqueoSubcuenta = true;
				this.iface.posActualPuntoSubIVASopImp = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuentaIVASopImp", this.iface.longSubcuenta, this.iface.posActualPuntoSubIVASopImp);
				this.iface.bloqueoSubcuenta = false;
			}
			break;
		}
		case "codsubcuentaivarepexp":{
			if (!this.iface.bloqueoSubcuenta) {
				this.iface.bloqueoSubcuenta = true;
				this.iface.posActualPuntoSubIVARepExp = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuentaIVARepExp", this.iface.longSubcuenta, this.iface.posActualPuntoSubIVARepExp);
				this.iface.bloqueoSubcuenta = false;
			}
			break;
		}
		case "codsubcuentaivarepexe":{
			if (!this.iface.bloqueoSubcuenta) {
				this.iface.bloqueoSubcuenta = true;
				this.iface.posActualPuntoSubIVARepExe = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuentaIVARepExe", this.iface.longSubcuenta, this.iface.posActualPuntoSubIVARepExe);
				this.iface.bloqueoSubcuenta = false;
			}
			break;
		}
		case "codsubcuentaivasopexe":{
			if (!this.iface.bloqueoSubcuenta) {
				this.iface.bloqueoSubcuenta = true;
				this.iface.posActualPuntoSubIVASopExe = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuentaIVASopExe", this.iface.longSubcuenta, this.iface.posActualPuntoSubIVASopExe);
				this.iface.bloqueoSubcuenta = false;
			}
			break;
		}
		case "codsubcuentaivarepre":{
			if (!this.iface.bloqueoSubcuenta) {
				this.iface.bloqueoSubcuenta = true;
				this.iface.posActualPuntoSubIVARepRE = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuentaIvaRepRE", this.iface.longSubcuenta, this.iface.posActualPuntoSubIVARepRE);
				this.iface.bloqueoSubcuenta = false;
			}
			break;
		}
	}
}

function oficial_tbnAyuda_clicked()
{
	var util:FLUtil = new FLUtil;
	MessageBox.information(util.translate("scripts", 
	"Para el correcto funcionamiento de la generación automática de asientos de facturas, de los informes contables y de los modelos fiscales \n" +
	"(si se tiene este módulo) instalado es necesario asociar a cada tipo de I.V.A. sus subcuentas correspondientes.\n\n" + 
	"Estas subcuentas deben estar marcadas en la tabla de subcuentas con su correspondiente código de cuenta especial (en este formulario entre\n" + 
	"paréntesis al lado de cada subcuenta), en todos los ejercicios activos.\n\n" + 
	"Al aceptar este formulario Abanq comprueba que dicha asociación sea correcta, por ejemplo, si indicamos que la subcuenta para I.V.A. soportado \n" +
	"(IVASOP) es la 472000000, Abanq comprobará que dicha subcuenta tenga como valor en el campo Cuenta especial el valor \"IVASOP\". \n\n" +
	"No es necesario discriminar por porcentaje de IVA todas las subcuentas. Por ejemplo, si usamos como subcuenta de I.V.A. soportado para proveedores \n" +
	"exentos la subcuenta 4720000999 podemos asociar este valor de subcuenta a todos los registros de I.V.A. (IVA16, IVA7, IVA4, etc). De lo que sí \n" +
	"debemos asegurarnos es de que dicha subcuenta 4720000999 esté marcada como \"IVASEX\" en la tabla de subcuentas.\n\n" +
	"Aunque asociemos subcuentas como la de I.V.A. exento a registros con porcentaje de I.V.A. distinto de 0, Abanq cambiará el porcentaje por 0 cuando\n" +
	"sea necesario (en este caso cuando el cliente o proveedor de la factura tenga como valor de régimen de I.V.A. el valor \"Exento\")."), MessageBox.Ok, MessageBox.NoButton);
}
	
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
