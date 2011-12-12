/***************************************************************************
                 co_operaciones349.qs  -  description
                             -------------------
    begin                : jue mar 12 2009
    copyright            : (C) 2009 by InfoSiAL S.L.
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

/** \C
Las operaciones del modelo 349 recogen el importe neto facturado por un cliente / proveedor para el período del modelo asociado
\end */

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
	function calculateField( fN:String ):String { return this.ctx.interna_calculateField( fN ); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    function oficial( context ) { interna( context ); } 
	function bufferChanged(fN) { return this.ctx.oficial_bufferChanged(fN); }
	function desconectar() { return this.ctx.oficial_desconectar();}
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
	var cursor:FLSqlCursor = this.cursor();
	
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this, "closed()", this, "iface.desconectar()");
	
	if (cursor.modeAccess() == cursor.Insert) {
		this.child("fdbClave").setValue("E");
	}
	this.iface.bufferChanged("clave");
}

function interna_calculateField( fN ) 
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var valor;
	switch ( fN ) {
		/** \C El --cifnif-- será el correspondiente al cliente o proveedor seleccionado
		\end */
		case "cifnif": {
			var codTercero:String = cursor.valueBuffer("codcliente"); 
			if (codTercero && codTercero != "")
				valor = util.sqlSelect("clientes", "cifnif", "codcliente = '" + codTercero + "'");
			else {
				var codTercero:String = cursor.valueBuffer("codproveedor"); 
				if (codTercero && codTercero != "")
					valor = util.sqlSelect("proveedores", "cifnif", "codproveedor = '" + codTercero + "'");
			}
			break;
		}
		/** \C El --nombre-- será el correspondiente al cliente o proveedor seleccionado
		\end */
		case "nombre": {
			var codTercero:String = cursor.valueBuffer("codcliente"); 
			if (codTercero && codTercero != "")
				valor = util.sqlSelect("clientes", "nombre", "codcliente = '" + codTercero + "'");
			else {
				var codTercero:String = cursor.valueBuffer("codproveedor"); 
				if (codTercero && codTercero != "")
					valor = util.sqlSelect("proveedores", "nombre", "codproveedor = '" + codTercero + "'");
			}
			break;
		}
		/** \C El --codpais-- será el correspondiente al país de la dirección de facturación del cliente o de la dirección principal del proveedor seleccionado
		\end */
		case "codpais": {
			var codTercero:String = cursor.valueBuffer("codcliente"); 
			if (codTercero && codTercero != "") {
				valor = util.sqlSelect("dirclientes", "codpais", "codcliente = '" + codTercero + "' and domfacturacion = true");
				if (!valor)
					valor = util.sqlSelect("dirclientes", "codpais", "codcliente = '" + codTercero + "'");
			} else {
				var codTercero:String = cursor.valueBuffer("codproveedor"); 
				if (codTercero && codTercero != "") {
					valor = util.sqlSelect("dirproveedores", "codpais", "codproveedor = '" + codTercero + "' and direccionppal = true");
					if (!valor)
						valor = util.sqlSelect("dirproveedores", "codpais", "codproveedor = '" + codTercero + "'");
				}
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
function oficial_desconectar()
{
	disconnect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged");
}

function oficial_bufferChanged( fN ) 
{
	var cursor:FLSqlCursor = this.cursor();
	switch (fN) {
		case "clave": {
			if (cursor.valueBuffer("clave") == "E") {
				this.child("fdbCodProveedor").setValue("");
				this.child("fdbCodProveedor").setDisabled(true);
				this.child("fdbCodCliente").setDisabled(false);
			} else if (cursor.valueBuffer("clave") == "A") {
				this.child("fdbCodCliente").setValue("");
				this.child("fdbCodCliente").setDisabled(true);
				this.child("fdbCodProveedor").setDisabled(false);
			} else {
				this.child("fdbCodCliente").setDisabled(false);
				this.child("fdbCodProveedor").setDisabled(false);
			}
			break;
		}
		case "codcliente":
		case "codproveedor": {
			this.child("fdbCifNif").setValue(this.iface.calculateField("cifnif"));
			this.child("fdbNombre").setValue(this.iface.calculateField("nombre"));
			this.child("fdbCodPais").setValue(this.iface.calculateField("codpais"));
			break;
		}
	}
}

/** \D Calcula los valores de las casillas de resumen del modelo
\end */
function oficial_calcularTotales()
{
	this.child("tdbOperaciones").refresh();
	this.child("tdbRectificaciones").refresh();
	
	this.child("fdbNumTotalOI").setValue(this.iface.calculateField("numtotaloi"));
	this.child("fdbImporteTotalOI").setValue(this.iface.calculateField("importetotaloi"));
	this.child("fdbNumTotalOIRec").setValue(this.iface.calculateField("numtotaloirec"));
	this.child("fdbNumTotalOIRec").setValue(this.iface.calculateField("numtotaloirec"));
} 

/** \D Calcula algunas de las casillas del modelo a partir de los contenidos de la base de datos de contabilidad
\end */
function oficial_calcularValores()
{
	this.iface.borrarValores();
	
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	var qryOperaciones:FLSqlQuery = new FLSqlQuery;
	qryOperaciones.setTablesList("clientes,facturascli,co_asientos");
	qryOperaciones.setSelect("c.codcliente, SUM(f.neto)");
	qryOperaciones.setFrom("clientes c INNER JOIN facturascli f ON c.codcliente = f.codcliente INNER JOIN co_asientos a ON f.idasiento = a.idasiento");
	qryOperaciones.setWhere("c.regimeniva IN ('UE', 'U.E.') AND a.fecha BETWEEN '" + cursor.valueBuffer("fechainicio") + "' AND '" + cursor.valueBuffer("fechafin") + "' GROUP BY c.codcliente");
	qryOperaciones.setForwardOnly(true);
	
	if (!qryOperaciones.exec()) {
		MessageBox.critical(util.translate("scripts", "Falló la consulta de operaciones de entrega"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
		
	var curOperaciones:FLSqlCursor = new FLSqlCursor("co_operaciones349");
	var datosOp:Array;
	var importe:Number;
	while (qryOperaciones.next()) {
		importe = parseFloat(qryOperaciones.value("SUM(f.neto)"));
		if (importe == 0)
			continue;
			
		datosOp = this.iface.datosOperacionE(qryOperaciones.value("c.codcliente"));
		if (!datosOp.ok) {
			MessageBox.critical(util.translate("scripts", "Falló la obtención de datos del cliente: ") + qryOperaciones.value("c.codcliente"), MessageBox.Ok, MessageBox.NoButton);
			return;
		}
		with (curOperaciones) {
			setModeAccess(Insert);
			refreshBuffer();
			setValueBuffer("idmodelo", cursor.valueBuffer("idmodelo"));
			setValueBuffer("clave", "E");
			setValueBuffer("codpais", datosOp.codPais);
			setValueBuffer("codue", datosOp.codIso);
			setValueBuffer("codcliente", qryOperaciones.value("c.codcliente"));
			setValueBuffer("cifnif", datosOp.cifNif);
			setValueBuffer("nombre", datosOp.nombre);
			setValueBuffer("baseimponible", importe);
			if (!commitBuffer()) {
				MessageBox.critical(util.translate("scripts", "Falló la inserción de operación para el cliente: ") + qryOperaciones.value("c.codcliente"), MessageBox.Ok, MessageBox.NoButton);
				return;
			}
		}
	}
	
	qryOperaciones.setTablesList("proveedores,facturasprov,co_asientos");
	qryOperaciones.setSelect("p.codproveedor, SUM(f.neto)");
	qryOperaciones.setFrom("proveedores p INNER JOIN facturasprov f ON p.codproveedor = f.codproveedor INNER JOIN co_asientos a ON f.idasiento = a.idasiento");
	qryOperaciones.setWhere("p.regimeniva IN ('UE', 'U.E.') AND a.fecha BETWEEN '" + cursor.valueBuffer("fechainicio") + "' AND '" + cursor.valueBuffer("fechafin") + "' GROUP BY p.codproveedor");
	qryOperaciones.setForwardOnly(true);
	
	if (!qryOperaciones.exec()) {
		MessageBox.critical(util.translate("scripts", "Falló la consulta de operaciones de entrega"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
		
	while (qryOperaciones.next()) {
		importe = parseFloat(qryOperaciones.value("SUM(f.neto)"));
		if (importe == 0)
			continue;
		
		datosOp = this.iface.datosOperacionA(qryOperaciones.value("p.codproveedor"));
		if (!datosOp.ok) {
			MessageBox.critical(util.translate("scripts", "Falló la obtención de datos del proveedor: ") + qryOperaciones.value("p.codproveedor"), MessageBox.Ok, MessageBox.NoButton);
			return;
		}
		with (curOperaciones) {
			setModeAccess(Insert);
			refreshBuffer();
			setValueBuffer("idmodelo", cursor.valueBuffer("idmodelo"));
			setValueBuffer("clave", "A");
			setValueBuffer("codpais", datosOp.codPais);
			setValueBuffer("codue", datosOp.codIso);
			setValueBuffer("codproveedor", qryOperaciones.value("p.codproveedor"));
			setValueBuffer("cifnif", datosOp.cifNif);
			setValueBuffer("nombre", datosOp.nombre);
			setValueBuffer("baseimponible", qryOperaciones.value("SUM(f.neto)"));
			if (!commitBuffer()) {
				MessageBox.critical(util.translate("scripts", "Falló la inserción de operación para el proveedor: ") + qryOperaciones.value("p.codproveedor"), MessageBox.Ok, MessageBox.NoButton);
				return;
			}
		}
	}
	this.iface.calcularTotales();
} 

/** \C Obtiene los datos relativos a un cliente para guardarlos en un registros de operación o rectificación
@param	codCliente: código del cliente
@return	array con los siguientes valores:
	ok: True si los datos se obtienen correctamente, false en caso contrario
	codPais: País de la dirección de facturación del cliente. Si no existe se toma una dirección al azar.
	codIso: Código ISO del país miembro de la Unión Europea
	cifNif: Cif del cliente
	nombre: Nombre y apellidos o razón social del cliente
\end */
function oficial_datosOperacionE(codCliente:String):Array
{
	var ret:Array = [];
	ret.ok = false;
	
	var qryCliente:FLSqlQuery = new FLSqlQuery;
	qryCliente.setTablesList("clientes,dirclientes,paises");
	qryCliente.setSelect("p.codpais, p.codiso, c.cifnif, c.nombre");
	qryCliente.setFrom("clientes c INNER JOIN dirclientes d ON c.codcliente = d.codcliente INNER JOIN paises p ON d.codpais = p.codpais");
	qryCliente.setWhere("c.codcliente = '" + codCliente + "' AND d.domfacturacion = true");
	qryCliente.setForwardOnly(true);
	
	if (!qryCliente.exec())
		return ret;
	
	if (!qryCliente.first()) {
		qryCliente.setWhere("c.codcliente = '" + codCliente + "'");
		qryCliente.setForwardOnly(true);
		
		if (!qryCliente.exec())
			return ret;
		
		if (!qryCliente.first())
			return ret;
	}
	ret.codPais = qryCliente.value("p.codpais");
	ret.codIso = qryCliente.value("p.codiso");
	ret.cifNif = qryCliente.value("c.cifnif");
	ret.nombre = qryCliente.value("c.nombre");
	ret.ok = true;
	
	return ret;
}

/** \C Obtiene los datos relativos a un proveedor para guardarlos en un registros de operación o rectificación
@param	codProveedor: código del proveedor
@return	array con los siguientes valores:
	ok: True si los datos se obtienen correctamente, false en caso contrario
	codPais: País de la dirección de facturación del cliente. Si no existe se toma una dirección al azar.
	codIso: Código ISO del país miembro de la Unión Europea
	cifNif: Cif del cliente
	nombre: Nombre y apellidos o razón social del cliente
\end */
function oficial_datosOperacionA(codProveedor:String):Array
{
	var ret:Array = [];
	ret.ok = false;
	
	var qryProveedor:FLSqlQuery = new FLSqlQuery;
	qryProveedor.setTablesList("proveedores,dirproveedores,paises");
	qryProveedor.setSelect("p.codpais, p.codiso, pr.cifnif, pr.nombre");
	qryProveedor.setFrom("proveedores pr INNER JOIN dirproveedores d ON pr.codproveedor = d.codproveedor INNER JOIN paises p ON d.codpais = p.codpais");
	qryProveedor.setWhere("pr.codproveedor = '" + codProveedor + "' AND d.direccionppal = true");
	qryProveedor.setForwardOnly(true);
	
	if (!qryProveedor.exec())
		return ret;
	
	if (!qryProveedor.first()) {
		qryProveedor.setWhere("pr.codproveedor = '" + codProveedor + "'");
		qryProveedor.setForwardOnly(true);
		
		if (!qryProveedor.exec())
			return ret;
		
		if (!qryProveedor.first())
			return ret;
	}
	ret.codPais = qryProveedor.value("p.codpais");
	ret.codIso = qryProveedor.value("p.codiso");
	ret.cifNif = qryProveedor.value("pr.cifnif");
	ret.nombre = qryProveedor.value("pr.nombre");
	ret.ok = true;
	
	return ret;
}

/** \D Establece las fechas de inicio y fin de trimestre en función del trimestre seleccionado
\end */
function oficial_establecerFechasPeriodo()
{
	var util:FLUtil = new FLUtil();
	var fechaInicio:Date;
	var fechaFin:Date;
	var codEjercicio:String = this.child("fdbCodEjercicio").value();
	var inicioEjercicio = util.sqlSelect("ejercicios", "fechainicio", 
		"codejercicio = '" + codEjercicio + "'");
		
	if (!inicioEjercicio) return false;
	
	fechaInicio.setYear(inicioEjercicio.getYear());
	fechaFin.setYear(inicioEjercicio.getYear());
	fechaInicio.setDate(1);
	
	switch (this.child("fdbPeriodo").value()) {
		case 0:
			fechaInicio.setMonth(1);
			fechaFin.setMonth(3);
			fechaFin.setDate(31);
			break;
		case 1:
			fechaInicio.setMonth(4);
			fechaFin.setMonth(6);
			fechaFin.setDate(30);
			break;
		case 2:
			fechaInicio.setMonth(7);
			fechaFin.setMonth(9);
			fechaFin.setDate(30);
			break;
		case 3:
			fechaInicio.setMonth(10);
			fechaFin.setMonth(12);
			fechaFin.setDate(31);
			break;
		case 4:
			fechaInicio.setMonth(1);
			fechaFin.setMonth(12);
			fechaFin.setDate(31);
			break;
	}
	
	this.child("fdbFechaInicio").setValue(fechaInicio);
	this.child("fdbFechaFin").setValue(fechaFin);
}

/** \D Borra algunas de las casillas calculadas
\end */
function oficial_borrarValores()
{
	var util:FLUtil = new FLUtil();
	if (!util.sqlDelete("co_operaciones349", "idmodelo = " + this.cursor().valueBuffer("idmodelo")));
		return false;
		
	this.iface.calcularTotales();
	
	/*
	this.child("fdbNumTotalOI").setValue(0);
	this.child("fdbImporteTotalOI").setValue(0);
	this.child("fdbNumTotalOIRec").setValue(0);
	this.child("fdbNumTotalOIRec").setValue(0);
	*/
}

/** \D Comprueba que fechainicio < fechafin y que ambas pertenecen al ejercicio seleccionado

@return	True si la comprobación es buena, false en caso contrario
\end */
function oficial_comprobarFechas():Boolean
{
	var util:FLUtil = new FLUtil();
	
	var codEjercicio:String = this.child("fdbCodEjercicio").value();
	var fechaInicio:String = this.child("fdbFechaInicio").value();
	var fechaFin:String = this.child("fdbFechaFin").value();

	if (util.daysTo(fechaInicio, fechaFin) < 0) {
		MessageBox.critical(util.translate("scripts", "La fecha de inicio debe ser menor que la de fin"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
	
	var inicioEjercicio:String = util.sqlSelect("ejercicios", "fechainicio", "codejercicio = '" + codEjercicio + "'");
	var finEjercicio:String = util.sqlSelect("ejercicios", "fechafin", "codejercicio = '" + codEjercicio + "'");

	if ((util.daysTo(inicioEjercicio, fechaInicio) < 0) || (util.daysTo(fechaFin, finEjercicio) < 0)) {
		MessageBox.critical(util.translate("scripts", "Las fechas seleccionadas no corresponden al ejercicio"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
	
	return true;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
