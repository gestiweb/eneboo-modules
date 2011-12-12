/***************************************************************************
                 masterclientespot.qs  -  description
                             -------------------
    begin                : mar jun 27 2006
    copyright            : (C) 2004-2006 by InfoSiAL S.L.
    email                : mail@infosial.com
 ***************************************************************************/
 /***************************************************************************
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; version 2 of the License.               *
 ***************************************************************************/
/***************************************************************************
   Este  programa es software libre. Puede redistribuirlo y/o modificarlo
   bajo  los  términos  de  la  Licencia  Pública General de GNU   en  su
   versión 2, publicada  por  la  Free  Software Foundation.
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var tdb:Object;
	var curCliente:FLSqlCursor;
	var curDirCliente:FLSqlCursor;
    function oficial( context ) { interna( context ); } 
	function aprobarClienteClicked():String {
		return this.ctx.oficial_aprobarClienteClicked();
	}
	function aprobarCliente(cursor:FLSqlCursor):String {
		return this.ctx.oficial_aprobarCliente(cursor);
	}
	function actualizarPresupuestos(codClientePot:String, codCliente:String):Boolean {
		return this.ctx.oficial_actualizarPresupuestos(codClientePot, codCliente);
	}
	function datosCliente(curDatos:FLSqlCursor, arrayDatos:Array):Boolean {
		return this.ctx.oficial_datosCliente(curDatos, arrayDatos);
	}
	function datosDirCliente(curDatos:FLSqlCursor):Boolean {
		return this.ctx.oficial_datosDirCliente(curDatos);
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
	function pub_aprobarCliente(cursor:FLSqlCursor):Number { return this.aprobarCliente(cursor);}
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
function interna_init() {
	this.iface.tdb = this.child("tableDBRecords");
	this.iface.tdb.putFirstCol("nombre");
	connect(this.child("pbnAprobar"), "clicked()", this, "iface.aprobarClienteClicked");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_aprobarClienteClicked():String
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	if (!cursor)
		return;

	var codCliente:String;
	cursor.transaction(false);
	try {
		codCliente = this.iface.aprobarCliente(cursor);
		if (codCliente) {
			cursor.commit();
			MessageBox.information(util.translate("scripts", "El cliente %1 se ha creado correctamente").arg(codCliente), MessageBox.Ok, MessageBox.NoButton);
		} else {
			cursor.rollback();
		}
	} catch (e) {
		cursor.rollback();
		MessageBox.critical(util.translate("scripts", "Ha habido un error al generar el cliente %1").arg(codCliente) + e, MessageBox.Ok, MessageBox.NoButton);
	}
}

function oficial_aprobarCliente(cursor:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil;

	if (!cursor.valueBuffer("cifnif")) {
		MessageBox.warning(util.translate("scripts", "El CIF/NIF del cliente potencial no puede ser nulo"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			return false;
	}

	var res:Object = MessageBox.information(util.translate("scripts",  "¿Seguro que desea convertir en real este cliente?\nTodos los presupuestos de este cliente potencial pasarán al cliente real que se va a crear\nEsta acción no podrá deshacerse"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
	if (res != MessageBox.Yes) 
		return false;
	
	var longCod:Number = 6;
	var maxCod:String = "";
	for (var i = 0; i < longCod; i++)
		maxCod += "9";
	
	if (!this.iface.curCliente)
		this.iface.curCliente = new FLSqlCursor("clientes");
	
	var codCliente:String = formRecordclientes.iface.pub_obtenerCodigoCliente(this.iface.curCliente);
  	var codCliente:Number = Input.getText(util.translate( "scripts", "Código del nuevo cliente" ), codCliente, "Aprobar cliente" );

	if (!codCliente)
		return false;

	var lenIni:Number = codCliente.length;
	var codN:Number = parseInt(codCliente);
	
	if (!codCliente || codCliente <= 0 || codCliente > maxCod) {
		MessageBox.warning(util.translate("scripts", "El código debe estar entre 1 y ") + maxCod, MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
	
/*	for (var i = 0; i < longCod - lenIni; i++)
		codCliente = "0" + codCliente;*/
	
	if (util.sqlSelect("clientes", "codcliente", "codcliente = '" + codCliente + "'")) {
		MessageBox.warning(util.translate("scripts", "Este código ya existe"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			return false;
	}
		
	var arrayDatos:Array = [];
	// Subcuenta
	var codSubcuenta:String = "";
	if (sys.isLoadedModule("flcontppal")) {
		
		var longSubcuenta:Number = util.sqlSelect("ejercicios", "longsubcuenta","codejercicio = '" + flfactppal.iface.pub_ejercicioActual() + "'");
		
		codSubcuenta = util.sqlSelect("co_cuentas", "codcuenta", "idcuentaesp = 'CLIENT' ORDER BY codcuenta");
		if (!codSubcuenta) {
			MessageBox.warning(util.translate("scripts", "No es posible crear el cliente porque no existe la cuenta especial CLIENT"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			return false;
		}
	
		var numCeros:Number = longSubcuenta - codSubcuenta.length - codCliente.length;
		for (var i:Number = 0; i < numCeros; i++)
			codSubcuenta += "0";
	
		var coclienteAux:String = codCliente;
		if (codSubcuenta.length + coclienteAux.length > longSubcuenta)
			coclienteAux = coclienteAux.right(longSubcuenta - codSubcuenta.length);
	
		codSubcuenta += coclienteAux;
	}
	arrayDatos["codsubcuenta"] = codSubcuenta;
		
	// Cliente
	this.iface.curCliente.setModeAccess(this.iface.curCliente.Insert);
	this.iface.curCliente.refreshBuffer();
	this.iface.curCliente.setValueBuffer("codcliente", codCliente);

	if (!this.iface.datosCliente(cursor, arrayDatos))
		return false;

	if (!this.iface.curCliente.commitBuffer())
		return false;
		
	// Dirección
	if (cursor.valueBuffer("direccion")) {
		if (!this.iface.curDirCliente)
			this.iface.curDirCliente = new FLSqlCursor ("dirclientes");
	
		this.iface.curDirCliente.setModeAccess(this.iface.curDirCliente.Insert);
		this.iface.curDirCliente.refreshBuffer();
		this.iface.curDirCliente.setValueBuffer("codcliente", codCliente);

		if (!this.iface.datosDirCliente(cursor))
			return false;

		if (!this.iface.curDirCliente.commitBuffer())
			return false;
	}
	
	// Actualizar los presupuestos del cliente potencial
	if (!this.iface.actualizarPresupuestos(cursor.valueBuffer("codigo"), codCliente))
		return false;
	
	// Eliminar cliente potencial
	cursor.setModeAccess(cursor.Del);
	cursor.refreshBuffer()
	if (!cursor.commitBuffer())
		return false;
		
	if (this.iface.tdb) {
		this.iface.tdb.refresh();
	}

	return codCliente;
}

function oficial_datosCliente(curDatos:FLSqlCursor, arrayDatos:Array):Boolean
{
	this.iface.curCliente.setValueBuffer("nombre", curDatos.valueBuffer("nombre"));
	this.iface.curCliente.setValueBuffer("cifnif", curDatos.valueBuffer("cifnif"));
	this.iface.curCliente.setValueBuffer("nombrecomercial", curDatos.valueBuffer("nombrecomercial"));
	this.iface.curCliente.setValueBuffer("contacto", curDatos.valueBuffer("contacto"));
	this.iface.curCliente.setValueBuffer("telefono1", curDatos.valueBuffer("telefono"));
	this.iface.curCliente.setValueBuffer("fax", curDatos.valueBuffer("fax"));
	this.iface.curCliente.setValueBuffer("email", curDatos.valueBuffer("email"));
	this.iface.curCliente.setValueBuffer("observaciones", curDatos.valueBuffer("observaciones"));
	this.iface.curCliente.setValueBuffer("codsubcuenta", arrayDatos["codsubcuenta"]);
	this.iface.curCliente.setValueBuffer("coddivisa", flfactppal.iface.pub_valorDefectoEmpresa("coddivisa"));
	this.iface.curCliente.setValueBuffer("codpago", flfactppal.iface.pub_valorDefectoEmpresa("codpago"));
	this.iface.curCliente.setValueBuffer("codcuentarem", flfactppal.iface.pub_valorDefectoEmpresa("codcuentarem"));
	this.iface.curCliente.setValueBuffer("codserie", flfactppal.iface.pub_valorDefectoEmpresa("codserie"));

	return true;
}

function oficial_datosDirCliente(curDatos:FLSqlCursor):Boolean
{
	this.iface.curDirCliente.setValueBuffer("domfacturacion", true);
	this.iface.curDirCliente.setValueBuffer("domenvio", true);
	this.iface.curDirCliente.setValueBuffer("direccion", curDatos.valueBuffer("direccion"));
	this.iface.curDirCliente.setValueBuffer("provincia", curDatos.valueBuffer("provincia"));
	this.iface.curDirCliente.setValueBuffer("ciudad", curDatos.valueBuffer("ciudad"));
	this.iface.curDirCliente.setValueBuffer("codpostal", curDatos.valueBuffer("codpostal"));
	this.iface.curDirCliente.setValueBuffer("apartado", curDatos.valueBuffer("apartado"));
	this.iface.curDirCliente.setValueBuffer("codpais", curDatos.valueBuffer("codpais"));

	return true;
}
/** \D Actualiza los presupuestos de un cliente potencial al convertirse en real
@param codClientePot Código del cliente potencial
@param codCliente Código del cliente real
*/
function oficial_actualizarPresupuestos(codClientePot:String, codCliente:String):Bolean
{
	var util:FLUtil = new FLUtil();
	var curTab:FLSqlCursor = new FLSqlCursor("presupuestoscli");
	
	curTab.select("codclientepot = '" + codClientePot + "'");
	
	util.createProgressDialog( util.translate( "scripts", "Actualizando presupuestos..." ), curTab.size());
	var paso:Number = 1;
	
	while (curTab.next()) {
		util.setProgress(paso++);
		curTab.setModeAccess(curTab.Edit);
		curTab.refreshBuffer();
		curTab.setValueBuffer("codcliente", codCliente);
		curTab.setValueBuffer("codclientepot", "");
		curTab.setValueBuffer("clientepot", false);
		if (!curTab.commitBuffer())
			return false;
	}		
	util.destroyProgressDialog();
	
	return true;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
