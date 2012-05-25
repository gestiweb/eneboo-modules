/***************************************************************************
                 co_modelo349.qs  -  description
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
El modelo 349 recoge la información relativa a las operaciones intracomunitarias de la empresa.
Restricciones del modelo: El modelo calcula de forma automática las operaciones intracomunitarias de clave A y B. 
Datos necesarios: Todos los clientes y proveedores intracomunitarios deben estar identificados con régimen de iva "U.E.". El domicilio de facturación de los clientes y el domicilio principal de los proveedores debe tener el país establecido a un país de la Unión Europea. Dichos países deben tener informado el código U.E. con el correspondiente código que les asigna a Agencia Tributaria
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
	function validateForm():Boolean { return this.ctx.interna_validateForm(); }
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
	function calcularValores() {
		this.ctx.oficial_calcularValores();
	}
	function establecerFechasPeriodo() {
		return this.ctx.oficial_establecerFechasPeriodo();
	}
	function limpiarValores():String {
		return this.ctx.oficial_limpiarValores();
	}
	function comprobarFechas():String {
		return this.ctx.oficial_comprobarFechas();
	}
	function desconectar() {
		return this.ctx.oficial_desconectar();
	}
	function datosOperacionE(codCliente:String):Array {
		return this.ctx.oficial_datosOperacionE(codCliente);
	}
	function datosOperacionA(codProveedor:String):Array {
		return this.ctx.oficial_datosOperacionA(codProveedor);
	}
	function calcularTotales() { 
		return this.ctx.oficial_calcularTotales(); 
	}
// 	function tbnRectificarModelo_clicked() { 
// 		return this.ctx.oficial_tbnRectificarModelo_clicked(); 
// 	}
// 	function rectificarModelo(idModeloRec:String):Boolean { 
// 		return this.ctx.oficial_rectificarModelo(idModeloRec); 
// 	}
// 	function generarRectificacionE(codCliente:String, importe:Number, importeRec:Number, datosRec:Array):Boolean { 
// 		return this.ctx.oficial_generarRectificacionE(codCliente, importe, importeRec, datosRec);
// 	}
// 	function generarRectificacionA(codProveedor:String, importe:Number, importeRec:Number, datosRec:Array):Boolean { 
// 		return this.ctx.oficial_generarRectificacionA(codProveedor, importe, importeRec, datosRec);
// 	}
	function tbnDetalleOI_clicked() { 
		return this.ctx.oficial_tbnDetalleOI_clicked();
	}
	function tbnDetalleRec_clicked() { 
		return this.ctx.oficial_tbnDetalleRec_clicked();
	}
	function obtenerPeriodo(fecha:Date):String { 
		return this.ctx.oficial_obtenerPeriodo(fecha);
	}
	function asociarPartidaRectificacion(idPartida:String, idRectificacion:String):Boolean {
		return this.ctx.oficial_asociarPartidaRectificacion(idPartida, idRectificacion);
	}
	function asociarPartidaOperacion(idPartida:String, idOperacion:String):Boolean {
		return this.ctx.oficial_asociarPartidaOperacion(idPartida, idOperacion);
	}
	function calcularParciales():Boolean {
		return this.ctx.oficial_calcularParciales();
	}
	function borrarOperacionesIntra() {
		return this.ctx.oficial_borrarOperacionesIntra();
	}
	function borrarRectificaciones() {
		return this.ctx.oficial_borrarRectificaciones();
	}
	function habilitarPeriodo() { 
		return this.ctx.oficial_habilitarPeriodo();
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
/** \C El ejercicio por defecto al crear un nuevo modelo es el ejercicio marcado como actual en el formulario de empresa
\end */
function interna_init() 
{
	var cursor:FLSqlCursor = this.cursor();
	
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this.child("pbnCalcularValores"), "clicked()", this, "iface.calcularValores()");
// 	connect(this.child("tbnRectificarModelo"), "clicked()", this, "iface.tbnRectificarModelo_clicked()");
	connect(this.child("tdbOperaciones").cursor(), "bufferCommited()", this, "iface.calcularTotales()");
	connect(this.child("tdbRectificaciones").cursor(), "bufferCommited()", this, "iface.calcularTotales()");
	connect(this.child("tbnDetalleOI"), "clicked()", this, "iface.tbnDetalleOI_clicked()");
	connect(this.child("tbnDetalleRec"), "clicked()", this, "iface.tbnDetalleRec_clicked()");
	connect(this.child("toolButtonDeleteO"), "clicked()", this, "iface.borrarOperacionesIntra()");
	connect(this.child("toolButtonDeleteR"), "clicked()", this, "iface.borrarRectificaciones()");

	connect(this, "closed()", this, "iface.desconectar()");
	
	if (cursor.modeAccess() == cursor.Insert) {
		this.child("fdbCodEjercicio").setValue(flfactppal.iface.pub_ejercicioActual());
		this.child("fdbCifNifPres").setValue(flcontmode.iface.pub_valorDefectoDatosFiscales("cifnif"));
		this.child("fdbNombrePres").setValue(flcontmode.iface.pub_valorDefectoDatosFiscales("apellidosrs") + " " + flcontmode.iface.pub_valorDefectoDatosFiscales("nombre"));
		this.child("fdbCodTipoViaPres").setValue(flcontmode.iface.pub_valorDefectoDatosFiscales("codtipovia"));
		this.child("fdbNombreViaPres").setValue(flcontmode.iface.pub_valorDefectoDatosFiscales("nombrevia"));
		this.child("fdbNumeroPres").setValue(flcontmode.iface.pub_valorDefectoDatosFiscales("numero"));
		this.child("fdbEscaleraPres").setValue(flcontmode.iface.pub_valorDefectoDatosFiscales("escalera"));
		this.child("fdbPisoPres").setValue(flcontmode.iface.pub_valorDefectoDatosFiscales("piso"));
		this.child("fdbPuertaPres").setValue(flcontmode.iface.pub_valorDefectoDatosFiscales("puerta"));
		this.child("fdbCodPosPres").setValue(flcontmode.iface.pub_valorDefectoDatosFiscales("codpos"));
		this.child("fdbMunicipioPres").setValue(flcontmode.iface.pub_valorDefectoDatosFiscales("municipio"));
		this.child("fdbCodProvinciaPres").setValue(flcontmode.iface.pub_valorDefectoDatosFiscales("codprovincia"));
		this.child("fdbNumJustificante").setValue("3430000000000");
	}
	this.iface.habilitarPeriodo();
}

function interna_calculateField( fN ) 
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var valor;
	switch ( fN ) {
		/** \C --numtotaloi-- (Número total de operadores intracomunitarios) es el total de registros contenidos en la tabla de la pestaña Operaciones
		\end */
		case "numtotaloi":
			valor = this.child("tdbOperaciones").cursor().size();
			break;
	
		/** \C --importetotaloi-- (Importe de operaciones intracomunitarias) es la suma de las bases imponibles de los registros contenidos en la tabla de la pestaña Operaciones.<br/>Las operaciones de clave A (Adquisiciones) se calculan como suma de las bases imponibles de las facturas de cada proveedor intracomunitario contabilizadas en el período seleccionado.<br/>Las operaciones de clave E (Entregas) se calculan de la misma forma, siendo relativas a las facturas de clientes.
		\end */
		case "importetotaloi":
			valor = util.sqlSelect("co_operaciones349", "SUM(baseimponible)", "idmodelo = " + cursor.valueBuffer("idmodelo"));
			if (!valor)
				valor = 0;
			break;
			
		/** \C --numtotaloirec-- (Número total de operadores intracomunitarios con rectificaciones) es el total de registros contenidos en la tabla de la pestaña Rectificaciones
		\end */
		case "numtotaloirec":
			valor = this.child("tdbRectificaciones").cursor().size();
			break;
			
		/** \C --importetotaloirec-- (Importe de las rectificaciones) es la suma de las bases imponibles rectificadas de los registros contenidos en la tabla de la pestaña Rectificaciones. Dichos registros se obtienen comparando las operaciones de un determinado modelo anterior con las operaciones que se deberían generar en base a los datos actuales de la empresa.
		\end */
		case "importetotaloirec":
			valor = util.sqlSelect("co_rectificaciones349", "SUM(birectificada)", "idmodelo = " + cursor.valueBuffer("idmodelo"));
			if (!valor)
				valor = 0;
			break;
	}
	return valor;
}

function interna_validateForm():Boolean
{
	/** \C Las fechas que definen el período deben ser coherentes (fin > inicio) y pertenecer al ejercicio seleccionado \end */
	if (!this.iface.comprobarFechas()) return false;
	
	/** \C Si la declaración es complementaria o sustitutiva debe establecerse el justificante de la declaración anterior \end */
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	if (cursor.valueBuffer("sustitutiva") || cursor.valueBuffer("complementaria")) {
		var numDecAnterior:String = cursor.valueBuffer("numdecanterior");
		if (!numDecAnterior || numDecAnterior == "") {
			MessageBox.warning(util.translate("scripts", "Debe establecer el número de justificante de la declaración anterior"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}
	
	return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_desconectar()
{
	disconnect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged");
	disconnect(this.child("pbnCalcularValores"), "clicked()", this, "iface.calcularValores()");
	disconnect(this.child("tdbOperaciones").cursor(), "bufferCommited()", this, "iface.calcularTotales()");
	disconnect(this.child("tdbRectificaciones").cursor(), "bufferCommited()", this, "iface.calcularTotales()");
}

function oficial_bufferChanged( fN ) 
{
	switch (fN) {
		case "fechainicio":
		case "fechafin": {
// 			this.iface.limpiarValores();
			break;
		}
		case "tipoperiodo": {
			this.iface.habilitarPeriodo();
			this.iface.establecerFechasPeriodo();
		}
		case "codejercicio":
		case "mes":
		case "periodo": {
			this.iface.establecerFechasPeriodo();
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
	this.child("fdbImporteTotalOIRec").setValue(this.iface.calculateField("importetotaloirec"));
} 

/** \D Calcula algunas de las casillas del modelo a partir de los contenidos de la base de datos de contabilidad
\end */
function oficial_calcularValores()
{
	if (!this.iface.limpiarValores()) {
		return false;
	}

	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	if (cursor.modeAccess() == cursor.Insert) {
		this.child("tdbOperaciones").cursor().commitBufferCursorRelation();
	}
				
	var qryOperaciones:FLSqlQuery = new FLSqlQuery;
// 	qryOperaciones.setTablesList("clientes,facturascli,co_asientos");
// 	qryOperaciones.setSelect("c.codcliente, SUM(f.neto)");
// 	qryOperaciones.setFrom("clientes c INNER JOIN facturascli f ON c.codcliente = f.codcliente INNER JOIN co_asientos a ON f.idasiento = a.idasiento");
// 	qryOperaciones.setWhere("c.regimeniva IN ('UE', 'U.E.') AND a.fecha BETWEEN '" + cursor.valueBuffer("fechainicio") + "' AND '" + cursor.valueBuffer("fechafin") + "' GROUP BY c.codcliente");
	qryOperaciones.setTablesList("co_partidas,co_subcuentascli,co_asientos");
	qryOperaciones.setSelect("p.idpartida, p.idasiento, sc.codcliente, p.baseimponible");
	qryOperaciones.setFrom("co_asientos a INNER JOIN co_partidas p ON a.idasiento = p.idasiento INNER JOIN co_subcuentas s ON p.idsubcuenta = s.idsubcuenta INNER JOIN co_subcuentascli sc ON p.idcontrapartida = sc.idsubcuenta");
	qryOperaciones.setWhere("s.codejercicio = '" + cursor.valueBuffer("codejercicio") + "' AND s.idcuentaesp IN ('IVAEUE') AND a.fecha BETWEEN '" + cursor.valueBuffer("fechainicio") + "' AND '" + cursor.valueBuffer("fechafin") + "' ORDER BY sc.codcliente");
	qryOperaciones.setForwardOnly(true);
	
	if (!qryOperaciones.exec()) {
		MessageBox.critical(util.translate("scripts", "Falló la consulta de operaciones de entrega"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	
	util.createProgressDialog(util.translate("scripts", "Generando operaciones de entregas"), qryOperaciones.size());
	var paso:Number = 0;
	util.setProgress(++paso);
	var curOperaciones:FLSqlCursor = new FLSqlCursor("co_operaciones349"); //this.child("tdbOperaciones").cursor();
	var curRectificaciones:FLSqlCursor = new FLSqlCursor("co_rectificaciones349"); //this.child("tdbRectificaciones").cursor();
	var idModelo:String = cursor.valueBuffer("idmodelo");
	var datosOp:Array;
	var importe:Number;
	var codCliente:String;
	var idOperacion:String;
	var idRectificacion:String;
	var fechaRectificada:String;
	var periodoRec:String;
	var ejercicioRec:String;
	var idModeloRec:String;
	var idPartida;
	while (qryOperaciones.next()) {
		util.setProgress(++paso);
		idPartida = qryOperaciones.value("p.idpartida");
		codCliente = qryOperaciones.value("sc.codcliente");

		importe = parseFloat(qryOperaciones.value("p.baseimponible"));
		if (importe == 0) {
			continue;
		}
		
		fechaRectificada = util.sqlSelect("facturascli f INNER JOIN facturascli fr ON f.idfacturarect = fr.idfactura", "fr.fecha", "f.idasiento = " + qryOperaciones.value("p.idasiento"), "facturascli");
		if (fechaRectificada) {
			periodoRec = this.iface.obtenerPeriodo(fechaRectificada);
			ejercicioRec = fechaRectificada.getYear();
			idRectificacion = util.sqlSelect("co_rectificaciones349", "id", "idmodelo = " + idModelo + " AND codcliente = '" + codCliente + "' AND periodo = '" + periodoRec + "' AND codejercicio = '" + ejercicioRec + "'");
			if (!idRectificacion) {
				datosOp = this.iface.datosOperacionE(codCliente);
				if (!datosOp.ok) {
					util.destroyProgressDialog();
					MessageBox.critical(util.translate("scripts", "Falló la obtención de datos del cliente %1.\nAsegúrese de que el cliente tiene una dirección de facturación y un país asociado a la misma.").arg(codCliente), MessageBox.Ok, MessageBox.NoButton);
					return;
				}
				idModeloRec = util.sqlSelect("co_modelo349", "idmodelo", "periodo = '" + periodoRec + "' AND EXTRACT(YEAR FROM fechainicio) = '" + ejercicioRec + "'");
				if (idModeloRec) {
					biAnterior = parseFloat(util.sqlSelect("co_operaciones349", "baseimponible", "idmodelo = " + idModeloRec + " AND codcliente = '" + codCliente + "'"));
					if (isNaN(biAnterior)) {
						biAnterior = 0;
					}
				} else {
					biAnterior = 0;
				}
				biRectificada = biAnterior + importe;
				with (curRectificaciones) {
					setModeAccess(Insert);
					refreshBuffer();
					setValueBuffer("idmodelo", idModelo);
					if (idModeloRec) {
						setValueBuffer("idmodelorec", idModeloRec);
					}
					setValueBuffer("codejercicio", ejercicioRec);
					setValueBuffer("periodo", periodoRec);
					setValueBuffer("clave", "E");
					setValueBuffer("codpais", datosOp.codPais);
					setValueBuffer("codue", datosOp.codIso);
					setValueBuffer("codcliente", codCliente);
					setValueBuffer("cifnif", datosOp.cifNif);
					setValueBuffer("nombre", datosOp.nombre);
					setValueBuffer("bianterior", biAnterior);
					setValueBuffer("birectificada", 0);
					if (!commitBuffer()) {
						util.destroyProgressDialog();
						MessageBox.critical(util.translate("scripts", "Falló la inserción de rectificación para el cliente: %1.").arg(codCliente), MessageBox.Ok, MessageBox.NoButton);
						return;
					}
					idRectificacion = curRectificaciones.valueBuffer("id");
				}
			}
debug("asociando rect = " + idRectificacion );
			if (!this.iface.asociarPartidaRectificacion(idPartida, idRectificacion)) {
				util.destroyProgressDialog();
				return false;
			}
		} else {
			idOperacion = util.sqlSelect("co_operaciones349", "id", "idmodelo = " + idModelo + " AND codcliente = '" + codCliente + "'");
			if (!idOperacion) {
				datosOp = this.iface.datosOperacionE(codCliente);
				if (!datosOp.ok) {
					util.destroyProgressDialog();
					MessageBox.critical(util.translate("scripts", "Falló la obtención de datos del cliente %1.\nAsegúrese de que el cliente tiene una dirección de facturación y un país asociado a la misma.").arg(codCliente), MessageBox.Ok, MessageBox.NoButton);
					return;
				}
				with (curOperaciones) {
					setModeAccess(Insert);
					refreshBuffer();
					setValueBuffer("idmodelo", cursor.valueBuffer("idmodelo"));
					setValueBuffer("clave", "E");
					setValueBuffer("codpais", datosOp.codPais);
					setValueBuffer("codue", datosOp.codIso);
					setValueBuffer("codcliente", codCliente);
					setValueBuffer("cifnif", datosOp.cifNif);
					setValueBuffer("nombre", datosOp.nombre);
					setValueBuffer("baseimponible", 0);
					if (!commitBuffer()) {
						MessageBox.critical(util.translate("scripts", "Falló la inserción de operación para el cliente: %1.").arg(codCliente), MessageBox.Ok, MessageBox.NoButton);
						return;
					}
				}
				idOperacion = curOperaciones.valueBuffer("id");
debug("idOperacion cliente = " + idOperacion);
			}
			if (!this.iface.asociarPartidaOperacion(idPartida, idOperacion)) {
				util.destroyProgressDialog();
				return false;
			}
		}
	}
	util.destroyProgressDialog();
	util.createProgressDialog(util.translate("scripts", "Generando operaciones de adquisiciones"), qryOperaciones.size());
	paso = 0;
	
	qryOperaciones.setTablesList("co_partidas,co_subcuentasprov,co_asientos");
	qryOperaciones.setSelect("sp.codproveedor, p.idpartida, p.idasiento, p.baseimponible");
	qryOperaciones.setFrom("co_asientos a INNER JOIN co_partidas p ON a.idasiento = p.idasiento INNER JOIN co_subcuentas s ON p.idsubcuenta = s.idsubcuenta INNER JOIN co_subcuentasprov sp ON p.idcontrapartida = sp.idsubcuenta");
	qryOperaciones.setWhere("s.codejercicio = '" + cursor.valueBuffer("codejercicio") + "' AND s.idcuentaesp IN ('IVASUE') AND a.fecha BETWEEN '" + cursor.valueBuffer("fechainicio") + "' AND '" + cursor.valueBuffer("fechafin") + "' ORDER BY sp.codproveedor");
	
	qryOperaciones.setForwardOnly(true);
	
	if (!qryOperaciones.exec()) {
		MessageBox.critical(util.translate("scripts", "Falló la consulta de operaciones de adquisición"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	
	var codProveedor:String;
	while (qryOperaciones.next()) {
		util.setProgress(++paso);
		idPartida = qryOperaciones.value("p.idpartida");
		codProveedor = qryOperaciones.value("sp.codproveedor");

		importe = parseFloat(qryOperaciones.value("p.baseimponible"));
		if (importe == 0) {
			continue;
		}
		
		fechaRectificada = util.sqlSelect("facturasprov f INNER JOIN facturasprov fr ON f.idfacturarect = fr.idfactura", "fr.fecha", "f.idasiento = " + qryOperaciones.value("p.idasiento"), "facturasprov");
		if (fechaRectificada) {
			periodoRec = this.iface.obtenerPeriodo(fechaRectificada);
			ejercicioRec = fechaRectificada.getYear();
			idRectificacion = util.sqlSelect("co_rectificaciones349", "id", "idmodelo = " + idModelo + " AND codproveedor = '" + codProveedor + "' AND periodo = '" + periodoRec + "' AND codejercicio = '" + ejercicioRec + "'");
			if (!idRectificacion) {
				datosOp = this.iface.datosOperacionA(codProveedor);
				if (!datosOp.ok) {
					util.destroyProgressDialog();
					MessageBox.critical(util.translate("scripts", "Falló la obtención de datos del proveedor %1.\nAsegúrese de que el proveedor tiene una dirección principal y un país asociado a la misma.").arg(codProveedor), MessageBox.Ok, MessageBox.NoButton);
					return;
				}
				idModeloRec = util.sqlSelect("co_modelo349", "idmodelo", "periodo = '" + periodoRec + "' AND EXTRACT(YEAR FROM fechainicio) = '" + ejercicioRec + "'");
				if (idModeloRec) {
					biAnterior = parseFloat(util.sqlSelect("co_operaciones349", "baseimponible", "idmodelo = " + idModeloRec + " AND codproveedor = '" + codProveedor + "'"));
					if (isNaN(biAnterior)) {
						biAnterior = 0;
					}
				} else {
					biAnterior = 0;
				}
				biRectificada = biAnterior + importe;
				with (curRectificaciones) {
					setModeAccess(Insert);
					refreshBuffer();
					setValueBuffer("idmodelo", idModelo);
					if (idModeloRec) {
						setValueBuffer("idmodelorec", idModeloRec);
					}
					setValueBuffer("codejercicio", ejercicioRec);
					setValueBuffer("periodo", periodoRec);
					setValueBuffer("clave", "A");
					setValueBuffer("codpais", datosOp.codPais);
					setValueBuffer("codue", datosOp.codIso);
					setValueBuffer("codproveedor", codProveedor);
					setValueBuffer("cifnif", datosOp.cifNif);
					setValueBuffer("nombre", datosOp.nombre);
					setValueBuffer("bianterior", biAnterior);
					setValueBuffer("birectificada", 0);
					if (!commitBuffer()) {
						util.destroyProgressDialog();
						MessageBox.critical(util.translate("scripts", "Falló la inserción de rectificación para el proveor: %1.").arg(codProveedor), MessageBox.Ok, MessageBox.NoButton);
						return;
					}
					idRectificacion = curRectificaciones.valueBuffer("id");
				}
			}
			if (!this.iface.asociarPartidaRectificacion(idPartida, idRectificacion)) {
				util.destroyProgressDialog();
				return false;
			}
		} else {
debug("partida = " + idPartida);
			idOperacion = util.sqlSelect("co_operaciones349", "id", "idmodelo = " + idModelo + " AND codproveedor = '" + codProveedor + "'");
debug("idOperacion = " + idOperacion);
			if (!idOperacion) {
				datosOp = this.iface.datosOperacionA(codProveedor);
				if (!datosOp.ok) {
					util.destroyProgressDialog();
					MessageBox.critical(util.translate("scripts", "Falló la obtención de datos del proveedor %1.\nAsegúrese de que el proveedor tiene una dirección principal y un país asociado a la misma.").arg(codProveedor), MessageBox.Ok, MessageBox.NoButton);
					return;
				}
				with (curOperaciones) {
					setModeAccess(Insert);
					refreshBuffer();
					setValueBuffer("idmodelo", cursor.valueBuffer("idmodelo"));
					setValueBuffer("clave", "A");
					setValueBuffer("codpais", datosOp.codPais);
					setValueBuffer("codue", datosOp.codIso);
					setValueBuffer("codproveedor", codProveedor);
					setValueBuffer("cifnif", datosOp.cifNif);
					setValueBuffer("nombre", datosOp.nombre);
					setValueBuffer("baseimponible", 0);
					if (!commitBuffer()) {
						MessageBox.critical(util.translate("scripts", "Falló la inserción de operación para el proveedor: %1.").arg(codProveedor), MessageBox.Ok, MessageBox.NoButton);
						return;
					}
				}
				idOperacion = curOperaciones.valueBuffer("id");
debug("idOperacion = " + idOperacion);
			}
			if (!this.iface.asociarPartidaOperacion(idPartida, idOperacion)) {
debug("!falló asociar");
				util.destroyProgressDialog();
				return false;
			}
		}
	}
	util.destroyProgressDialog();
	
	this.iface.calcularParciales();
}

/** \C Calcula el total de cada registro de operación o certificación como el sumatorio de sus partidas asociadas
\end */
function oficial_calcularParciales():Boolean
{
	var util:FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var totalBase:Number;
	var curOperaciones:FLSqlCursor = new FLSqlCursor("co_operaciones349");
	curOperaciones.select("idmodelo = " + cursor.valueBuffer("idmodelo"));
	util.createProgressDialog(util.translate("scripts", "Calculando operaciones"), curOperaciones.size());
	var paso:Number = 0;
	while (curOperaciones.next()) {
		util.setProgress(++paso);
		curOperaciones.setModeAccess(curOperaciones.Edit);
		curOperaciones.refreshBuffer();
		totalBase = parseFloat(util.sqlSelect("co_partidas", "SUM(baseimponible)", "idoperacion349 = " + curOperaciones.valueBuffer("id")));
		if (isNaN(totalBase)) {
			totalBase = 0;
		}
		curOperaciones.setValueBuffer("baseimponible", util.roundFieldValue(totalBase, "co_operaciones349", "baseimponible"));
		if (!curOperaciones.commitBuffer()) {
			util.destroyProgressDialog();
			return false;
		}
	}
	util.destroyProgressDialog();

	var curRectificaciones:FLSqlCursor = new FLSqlCursor("co_rectificaciones349");
	curRectificaciones.select("idmodelo = " + cursor.valueBuffer("idmodelo"));
	util.createProgressDialog(util.translate("scripts", "Calculando rectificaciones"), curRectificaciones.size());
	paso = 0;
	while (curRectificaciones.next()) {
		util.setProgress(++paso);
		curRectificaciones.setModeAccess(curOperaciones.Edit);
		curRectificaciones.refreshBuffer();
		totalBase = parseFloat(util.sqlSelect("co_partidas", "SUM(baseimponible)", "idrectificacion349 = " + curRectificaciones.valueBuffer("id")));
		if (isNaN(totalBase)) {
			totalBase = 0;
		}
		totalBase += parseFloat(curRectificaciones.valueBuffer("bianterior"));
		curRectificaciones.setValueBuffer("birectificada", util.roundFieldValue(totalBase, "co_rectificaciones349", "birectificada"));
		if (!curRectificaciones.commitBuffer()) {
			util.destroyProgressDialog();
			return false;
		}
	}
	util.destroyProgressDialog();
	this.iface.calcularTotales();
	return true;
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
	//En los registros de operación y rectificación el nombre sólo puede tener 40 caracteres
	ret.nombre = qryCliente.value("c.nombre").left(40);
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
	//En los registros de operación y rectificación el nombre sólo puede tener 40 caracteres
	ret.nombre = qryProveedor.value("pr.nombre").left(40);
	ret.ok = true;
	
	return ret;
}

/** \D Establece las fechas de inicio y fin de trimestre en función del trimestre seleccionado
\end */
// function oficial_establecerFechasPeriodo()
// {
// 	var util:FLUtil = new FLUtil();
// 	var fechaInicio:Date;
// 	var fechaFin:Date;
// 	var codEjercicio:String = this.child("fdbCodEjercicio").value();
// 	var inicioEjercicio = util.sqlSelect("ejercicios", "fechainicio", 
// 		"codejercicio = '" + codEjercicio + "'");
// 		
// 	if (!inicioEjercicio) return false;
// 	
// 	fechaInicio.setYear(inicioEjercicio.getYear());
// 	fechaFin.setYear(inicioEjercicio.getYear());
// 	fechaInicio.setDate(1);
// 	
// 	switch (this.child("fdbPeriodo").value()) {
// 		case 0:
// 			fechaInicio.setMonth(1);
// 			fechaFin.setMonth(3);
// 			fechaFin.setDate(31);
// 			break;
// 		case 1:
// 			fechaInicio.setMonth(4);
// 			fechaFin.setMonth(6);
// 			fechaFin.setDate(30);
// 			break;
// 		case 2:
// 			fechaInicio.setMonth(7);
// 			fechaFin.setMonth(9);
// 			fechaFin.setDate(30);
// 			break;
// 		case 3:
// 			fechaInicio.setMonth(10);
// 			fechaFin.setMonth(12);
// 			fechaFin.setDate(31);
// 			break;
// 		case 4:
// 			fechaInicio.setMonth(1);
// 			fechaFin.setMonth(12);
// 			fechaFin.setDate(31);
// 			break;
// 	}
// 	
// 	this.child("fdbFechaInicio").setValue(fechaInicio);
// 	this.child("fdbFechaFin").setValue(fechaFin);
// }

function oficial_establecerFechasPeriodo()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var fechaInicio:Date;
	var fechaFin:Date;
	var codEjercicio:String = this.child("fdbCodEjercicio").value();
	var inicioEjercicio = util.sqlSelect("ejercicios", "fechainicio", 
		"codejercicio = '" + codEjercicio + "'");
		
	if (!inicioEjercicio) {
		return false;
	}
	
	fechaInicio.setYear(inicioEjercicio.getYear());
	fechaFin.setYear(inicioEjercicio.getYear());
	fechaInicio.setDate(1);
	
debug(cursor.valueBuffer("tipoperiodo") + " " + cursor.valueBuffer("trimestre"));
	switch (cursor.valueBuffer("tipoperiodo")) {
		case "Trimestre": {
			switch (cursor.valueBuffer("periodo")) {
				case "1T": {
					fechaInicio.setMonth(1);
					fechaFin.setMonth(3);
					fechaFin.setDate(31);
					break;
				}
				case "2T": {
					fechaInicio.setMonth(4);
					fechaFin.setMonth(6);
					fechaFin.setDate(30);
					break;
				}
				case "3T":
					fechaInicio.setMonth(7);
					fechaFin.setMonth(9);
					fechaFin.setDate(30);
					break;
				case "4T": {
					fechaInicio.setMonth(10);
					fechaFin.setMonth(12);
					fechaFin.setDate(31);
					break;
				}
				default: {
					fechaInicio = false;
				}
			}
			break;
		}
		case "Mes": {
			switch (cursor.valueBuffer("mes")) {
				case "01": {
					fechaInicio.setMonth(1);
					fechaFin.setMonth(1);
					fechaFin.setDate(31);
					break;
				}
				case "02": {
					fechaInicio.setMonth(2);
					fechaFin.setMonth(2);
					fechaFin.setDate(28);
					break;
				}
				case "03": {
					fechaInicio.setMonth(3);
					fechaFin.setMonth(3);
					fechaFin.setDate(31);
					break;
				}
				case "04": {
					fechaInicio.setMonth(4);
					fechaFin.setMonth(4);
					fechaFin.setDate(30);
					break;
				}
				case "05": {
					fechaInicio.setMonth(5);
					fechaFin.setMonth(5);
					fechaFin.setDate(31);
					break;
				}
				case "06": {
					fechaInicio.setMonth(6);
					fechaFin.setMonth(6);
					fechaFin.setDate(30);
					break;
				}
				case "07": {
					fechaInicio.setMonth(7);
					fechaFin.setMonth(7);
					fechaFin.setDate(31);
					break;
				}
				case "08": {
					fechaInicio.setMonth(8);
					fechaFin.setMonth(8);
					fechaFin.setDate(31);
					break;
				}
				case "09": {
					fechaInicio.setMonth(9);
					fechaFin.setMonth(9);
					fechaFin.setDate(30);
					break;
				}
				case "10": {
					fechaInicio.setMonth(10);
					fechaFin.setMonth(10);
					fechaFin.setDate(31);
					break;
				}
				case "11": {
					fechaInicio.setMonth(11);
					fechaFin.setMonth(11);
					fechaFin.setDate(30);
					break;
				}
				case "12": {
					fechaInicio.setMonth(12);
					fechaFin.setMonth(12);
					fechaFin.setDate(31);
					break;
				}
				default: {
					fechaInicio = false;
				}
			}
			break;
		}
		case "Año": {
			fechaInicio.setMonth(1);
			fechaFin.setMonth(12);
			fechaFin.setDate(31);
			break;
		}
	}
	
	if (fechaInicio) {
debug("Fechainicio = " + fechaInicio);
		this.child("fdbFechaInicio").setValue(fechaInicio);
		this.child("fdbFechaFin").setValue(fechaFin);
	} else {
debug("!Fechainicio");
		cursor.setNull("fechainicio");
		cursor.setNull("fechafin");
	}
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

// function oficial_tbnRectificarModelo_clicked()
// {
// 	var f:Object = new FLFormSearchDB("co_modelo349");
// 	var curModelos:FLSqlCursor = f.cursor();
// 	var cursor:FLSqlCursor = this.cursor();
// 	var util:FLUtil = new FLUtil();
// 	
// 	var idModelo:String = cursor.valueBuffer("idmodelo");
// 	var masFiltro:String = "";
// 	if (idModelo)
// 		masFiltro += " fechafin <= '" + cursor.valueBuffer("fechainicio") + "' AND idmodelo <> " + idModelo;
// 	
// 	curModelos.setMainFilter(masFiltro);
// 	
// 	f.setMainWidget();
// 	var idModeloRec:String = f.exec("idmodelo");
// 
// 	if (idModeloRec) {
// 		if (!this.iface.rectificarModelo(idModeloRec)) {
// 			MessageBox.critical(util.translate("scripts", "Error al generar las rectificaciones para el modelo seleccionado"), MessageBox.Ok, MessageBox.NoButton);
// 			return;
// 		}
// 		this.iface.calcularTotales();
// 	}
// }

/** \D Crea los registros de rectificación de períodos anteriores a partir de los datos de facturación y de los registros de operaciones de un modelo anterior
@param	idModeloRec: Identificador del modelo anterior
@return	true si la creación se realiza con éxito, false en caso contrario
\end */
// function oficial_rectificarModelo(idModeloRec:String):Boolean
// {
// 	var util:FLUtil = new FLUtil;
// 	var cursor:FLSqlCursor = this.cursor();
// 	
// 	var datosRec:Array = [];
// 	datosRec.idModelo = idModeloRec;
// 	datosRec.periodo = util.sqlSelect("co_modelo349", "periodo", "idmodelo = " + idModeloRec);
// 	datosRec.codEjercicio = util.sqlSelect("co_modelo349", "codejercicio", "idmodelo = " + idModeloRec);
// 	datosRec.fechaInicio = util.sqlSelect("co_modelo349", "fechainicio", "idmodelo = " + idModeloRec);
// 	datosRec.fechaFin = util.sqlSelect("co_modelo349", "fechafin", "idmodelo = " + idModeloRec);
// 	
// 	if (!util.sqlDelete("co_rectificaciones349", "idmodelorec = " + idModeloRec))
// 		return false;
// 	
// 	var qryOperaciones:FLSqlQuery = new FLSqlQuery;
// 	qryOperaciones.setTablesList("clientes,facturascli,co_asientos");
// 	qryOperaciones.setSelect("c.codcliente, SUM(f.neto)");
// 	qryOperaciones.setFrom("clientes c INNER JOIN facturascli f ON c.codcliente = f.codcliente INNER JOIN co_asientos a ON f.idasiento = a.idasiento");
// 	qryOperaciones.setWhere("c.regimeniva IN ('UE', 'U.E.') AND a.fecha BETWEEN '" + datosRec.fechaInicio + "' AND '" + datosRec.fechaFin + "' GROUP BY c.codcliente ORDER BY c.codcliente");
// 	qryOperaciones.setForwardOnly(true);
// 	
// 	if (!qryOperaciones.exec()) {
// 		MessageBox.critical(util.translate("scripts", "Falló la consulta de operaciones de entrega"), MessageBox.Ok, MessageBox.NoButton);
// 		return;
// 	}
// 		
// 	var qryOperacionesRec:FLSqlQuery = new FLSqlQuery;
// 	qryOperacionesRec.setTablesList("co_operaciones349");
// 	qryOperacionesRec.setSelect("codcliente, baseimponible");
// 	qryOperacionesRec.setFrom("co_operaciones349");
// 	qryOperacionesRec.setWhere("idmodelo = " + idModeloRec + " AND clave = 'E' ORDER BY codcliente");
// 	qryOperacionesRec.setForwardOnly(true);
// 	
// 	if (!qryOperacionesRec.exec()) {
// 		MessageBox.critical(util.translate("scripts", "Falló la consulta de operaciones a rectificar"), MessageBox.Ok, MessageBox.NoButton);
// 		return;
// 	}
// 
// 	var codCliente:String;
// 	var codClienteRec:String = "";
// 	
// 	var masOp:Boolean = true;
// 	var masOpRec:Boolean = true;
// 	var importe:Number;
// 	var importeRec:Number;
// 	
// 	if (!qryOperaciones.next())
// 		masOp = false;
// 	if (!qryOperacionesRec.next())
// 		masOpRec = false;
// 	
// 	while (masOp || masOpRec) {
// 		if (masOp) {
// 			codCliente = qryOperaciones.value("c.codcliente");
// 			importe = parseFloat(qryOperaciones.value("SUM(f.neto)"));
// 		} else {
// 			codCliente = "";
// 			importe = 0;
// 		}
// 		
// 		if (masOpRec) {
// 			codClienteRec = qryOperacionesRec.value("codcliente");
// 			importeRec = parseFloat(qryOperacionesRec.value("baseimponible"));
// 		} else {
// 			codClienteRec = "";
// 			importeRec = 0;
// 		}
// 		
// 		if (codCliente == codClienteRec) {
// 			if (!this.iface.generarRectificacionE(codCliente, importe, importeRec, datosRec))
// 				return false;
// 			if (!qryOperaciones.next())
// 				masOp = false;
// 			if (!qryOperacionesRec.next())
// 				masOpRec = false;
// 		} else if (codClienteRec != "" && (codCliente > codClienteRec || codCliente == "")) {
// 			if (masOpRec) {
// 				if (!this.iface.generarRectificacionE(codClienteRec, 0, importeRec, datosRec))
// 					return false;
// 			}
// 			if (!qryOperacionesRec.next())
// 				masOpRec = false;
// 		} else {
// 			if (masOp) {
// 				if (!this.iface.generarRectificacionE(codCliente, importe, 0, datosRec))
// 					return false;
// 			}
// 			if (!qryOperaciones.next())
// 				masOp = false;
// 		}
// 	}
// 	
// 	qryOperaciones.setTablesList("proveedores,facturasprov,co_asientos");
// 	qryOperaciones.setSelect("p.codproveedor, SUM(f.neto)");
// 	qryOperaciones.setFrom("proveedores p INNER JOIN facturasprov f ON p.codproveedor = f.codproveedor INNER JOIN co_asientos a ON f.idasiento = a.idasiento");
// 	qryOperaciones.setWhere("p.regimeniva IN ('UE', 'U.E.') AND a.fecha BETWEEN '" + datosRec.fechaInicio + "' AND '" + datosRec.fechaFin + "' GROUP BY p.codproveedor ORDER BY p.codproveedor");
// 	qryOperaciones.setForwardOnly(true);
// 	
// 	if (!qryOperaciones.exec()) {
// 		MessageBox.critical(util.translate("scripts", "Falló la consulta de operaciones de adquisición"), MessageBox.Ok, MessageBox.NoButton);
// 		return;
// 	}
// 		
// 	var qryOperacionesRec:FLSqlQuery = new FLSqlQuery;
// 	qryOperacionesRec.setTablesList("co_operaciones349");
// 	qryOperacionesRec.setSelect("codproveedor, baseimponible");
// 	qryOperacionesRec.setFrom("co_operaciones349");
// 	qryOperacionesRec.setWhere("idmodelo = " + idModeloRec + " AND clave = 'A' ORDER BY codproveedor");
// 	qryOperacionesRec.setForwardOnly(true);
// 	
// 	if (!qryOperacionesRec.exec()) {
// 		MessageBox.critical(util.translate("scripts", "Falló la consulta de operaciones a rectificar"), MessageBox.Ok, MessageBox.NoButton);
// 		return;
// 	}
// 
// 	var codProveedor:String = "";
// 	var codProveedorRec:String = "";
// 	masOp = true;
// 	masOpRec = true;
// 	
// 	if (!qryOperaciones.next())
// 		masOp = false;
// 	if (!qryOperacionesRec.next())
// 		masOpRec = false;
// 	while (masOp || masOpRec) {
// 		if (masOp) {
// 			codProveedor = qryOperaciones.value("p.codproveedor");
// 			importe = parseFloat(qryOperaciones.value("SUM(f.neto)"));
// 		} else {
// 			codProveedor = "";
// 			importe = 0;
// 		}
// 		
// 		if (masOpRec) {
// 			codProveedorRec = qryOperacionesRec.value("codproveedor");
// 			importeRec = parseFloat(qryOperacionesRec.value("baseimponible"));
// 		} else {
// 			codProveedorRec = "";
// 			importeRec = 0;
// 		}
// 		
// 		if (codProveedor == codProveedorRec) {
// 			if (!this.iface.generarRectificacionA(codProveedor, importe, importeRec, datosRec))
// 				return false;
// 			if (!qryOperaciones.next())
// 				masOp = false;
// 			if (!qryOperacionesRec.next())
// 				masOpRec = false;
// 		} else if (codProveedorRec != "" && (codProveedor > codProveedorRec || codProveedor == "")) {
// 			if (masOpRec) {
// 				if (!this.iface.generarRectificacionA(codProveedorRec, 0, importeRec, datosRec))
// 					return false;
// 			}
// 			if (!qryOperacionesRec.next())
// 				masOpRec = false;
// 		} else {
// 			if (masOp) {
// 				if (!this.iface.generarRectificacionA(codProveedor, importe, 0, datosRec))
// 					return false;
// 			}
// 			if (!qryOperaciones.next())
// 				masOp = false;
// 		}
// 		if (!masOp && !masOpRec)
// 			completado = true;
// 	}
// 	
// 	return true;
// }

/** \C Genera un registro de rectificación de clave E
@param	codCliente: Código del cliente afectado
@param	importe: Importe correcto
@param	importeRec: Importe rectificado
@param	datosRec: Datos del modelo a rectificar
@return true si la rectificación se genera correctamente, false en caso contrario
\end */
// function oficial_generarRectificacionE(codCliente:String, importe:Number, importeRec:Number, datosRec:Array):Boolean 
// {
// 	var util:FLUtil = new FLUtil;
// 	var cursor:FLSqlCursor = this.cursor();
// 	
// 	if (importe == importeRec)
// 		return true;
// 		
// 	var curRectificaciones:FLSqlCursor = this.child("tdbRectificaciones").cursor();
// 	var datosOp:Array = this.iface.datosOperacionE(codCliente);
// 	if (!datosOp.ok) {
// 		MessageBox.critical(util.translate("scripts", "Falló la obtención de datos del cliente: ") + codCliente, MessageBox.Ok, MessageBox.NoButton);
// 		return;
// 	}
// 	if (cursor.modeAccess() == cursor.Insert) 
// 		curRectificaciones.commitBufferCursorRelation();
// 	
// 	with (curRectificaciones) {
// 		setModeAccess(Insert);
// 		refreshBuffer();
// 		setValueBuffer("idmodelo", cursor.valueBuffer("idmodelo"));
// 		setValueBuffer("clave", "E");
// 		setValueBuffer("codpais", datosOp.codPais);
// 		setValueBuffer("codue", datosOp.codIso);
// 		setValueBuffer("codcliente", codCliente);
// 		setValueBuffer("cifnif", datosOp.cifNif);
// 		setValueBuffer("nombre", datosOp.nombre);
// 		setValueBuffer("bianterior", importeRec);
// 		setValueBuffer("birectificada", importe);
// 		setValueBuffer("idmodelorec", datosRec.idModelo);
// 		setValueBuffer("periodo", datosRec.periodo);
// 		setValueBuffer("codejercicio", datosRec.codEjercicio);
// 		if (!commitBuffer()) {
// 			MessageBox.critical(util.translate("scripts", "Falló la inserción de operación para el cliente: ") + codCliente, MessageBox.Ok, MessageBox.NoButton);
// 			return;
// 		}
// 	}
// 	return true;
// }

/** \C Genera un registro de rectificación de clave A
@param	codProveedor: Código del proveedor afectado
@param	importe: Importe correcto
@param	importeRec: Importe rectificado
@param	datosRec: Datos del modelo a rectificar
@return true si la rectificación se genera correctamente, false en caso contrario
\end */
// function oficial_generarRectificacionA(codProveedor:String, importe:Number, importeRec:Number, datosRec:Array):Boolean 
// {
// 	var util:FLUtil = new FLUtil;
// 	var cursor:FLSqlCursor = this.cursor();
// 	
// 	if (importe == importeRec)
// 		return true;
// 		
// 	var curRectificaciones:FLSqlCursor = new FLSqlCursor("co_rectificaciones349");
// 	var datosOp:Array = this.iface.datosOperacionA(codProveedor);
// 	if (!datosOp.ok) {
// 		MessageBox.critical(util.translate("scripts", "Falló la obtención de datos del proveedor: ") + codProveedor, MessageBox.Ok, MessageBox.NoButton);
// 		return;
// 	}
// 	with (curRectificaciones) {
// 		setModeAccess(Insert);
// 		refreshBuffer();
// 		setValueBuffer("idmodelo", cursor.valueBuffer("idmodelo"));
// 		setValueBuffer("clave", "A");
// 		setValueBuffer("codpais", datosOp.codPais);
// 		setValueBuffer("codue", datosOp.codIso);
// 		setValueBuffer("codproveedor", codProveedor);
// 		setValueBuffer("cifnif", datosOp.cifNif);
// 		setValueBuffer("nombre", datosOp.nombre);
// 		setValueBuffer("bianterior", importeRec);
// 		setValueBuffer("birectificada", importe);
// 		setValueBuffer("idmodelorec", datosRec.idModelo);
// 		setValueBuffer("periodo", datosRec.periodo);
// 		setValueBuffer("codejercicio", datosRec.codEjercicio);
// 		if (!commitBuffer()) {
// 			MessageBox.critical(util.translate("scripts", "Falló la inserción de operación para el proveedor: ") + codProveedor, MessageBox.Ok, MessageBox.NoButton);
// 			return;
// 		}
// 	}
// 	return true;
// }

function oficial_tbnDetalleOI_clicked()
{
	var curOperacion:FLSqlCursor = this.child("tdbOperaciones").cursor();
	if (!curOperacion.isValid()) {
		return;
	}
	var filtro:String = "idoperacion349 = " + curOperacion.valueBuffer("id");
	
	var f:Object = new FLFormSearchDB("co_partidas349");
	var curPartidas:FLSqlCursor = f.cursor();
	
	curPartidas.setMainFilter(filtro);

	f.setMainWidget();
	var idPartida:String = f.exec("idpartida");
	if (f.accepted()) {
		return false;
	}
}

function oficial_tbnDetalleRec_clicked()
{
	var curRectificacion:FLSqlCursor = this.child("tdbRectificaciones").cursor();
	if (!curRectificacion.isValid()) {
		return;
	}
	var filtro:String = "idrectificacion349 = " + curRectificacion.valueBuffer("id");
	
	var f:Object = new FLFormSearchDB("co_partidas349");
	var curPartidas:FLSqlCursor = f.cursor();
	
	curPartidas.setMainFilter(filtro);

	f.setMainWidget();
	var idPartida:String = f.exec("idpartida");
	if (f.accepted()) {
		return false;
	}
}


function oficial_obtenerPeriodo(fecha:Date):String
{
	var mes:Number = fecha.getMonth();
	var periodo:String;
	switch (mes) {
		case 1: case 2: case 3: { periodo = "1T"; break;}
		case 4: case 5: case 6: { periodo = "2T"; break;}
		case 7: case 8: case 9: { periodo = "3T"; break;}
		case 10: case 11: case 12: { periodo = "4T"; break;}
	}
	return periodo;
}

function oficial_asociarPartidaOperacion(idPartida:String, idOperacion:String):Boolean
{
	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
	curPartida.setActivatedCommitActions(false);
	curPartida.select("idpartida = " + idPartida);
	if (!curPartida.first()) {
		return false;
	}
	curPartida.setModeAccess(curPartida.Edit);
	curPartida.refreshBuffer();
	curPartida.setValueBuffer("idoperacion349", idOperacion);
	if (!curPartida.commitBuffer()) {
		return false;
	}
	return true;
}

function oficial_asociarPartidaRectificacion(idPartida:String, idRectificacion:String):Boolean
{
	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
	curPartida.setActivatedCommitActions(false);
	curPartida.select("idpartida = " + idPartida);
	if (!curPartida.first()) {
		return false;
	}
	curPartida.setModeAccess(curPartida.Edit);
	curPartida.refreshBuffer();
	curPartida.setValueBuffer("idrectificacion349", idRectificacion);
	if (!curPartida.commitBuffer()) {
		return false;
	}
	return true;
}

/** \D Borra algunas de las casillas calculadas
\end */
function oficial_limpiarValores():Boolean
{debug("limpiar valores");
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var res:Number = MessageBox.warning(util.translate("scripts", "Los datos actuales se borrarán para calcular los nuevos\n¿Está seguro?"), MessageBox.Yes, MessageBox.No);
	if (res != MessageBox.Yes) {
		return false;
	}
	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
	curPartida.setActivatedCommitActions(false);

	var idModelo:String = cursor.valueBuffer("idmodelo");
	var curOperaciones:FLSqlCursor = new FLSqlCursor("co_operaciones349");
	curOperaciones.select("idmodelo = " + idModelo);
debug(idModelo);
	while (curOperaciones.next()) {
		curPartida.select("idoperacion349 = " + curOperaciones.valueBuffer("id"));
		while (curPartida.next()) {
			curPartida.setModeAccess(curPartida.Edit);
			curPartida.refreshBuffer();
			curPartida.setNull("idoperacion349");
			if (!curPartida.commitBuffer()) {
				return false;
			}
		}
		curOperaciones.setModeAccess(curOperaciones.Del);
		if (!curOperaciones.commitBuffer()) {
			return false;
		}
	}
debug(idModelo);
	var curRectificaciones:FLSqlCursor = new FLSqlCursor("co_rectificaciones349");
	curRectificaciones.select("idmodelo = " + idModelo);
	while (curRectificaciones.next()) {
		curPartida.select("idrectificacion349 = " + curRectificaciones.valueBuffer("id"));
		while (curPartida.next()) {
			curPartida.setModeAccess(curPartida.Edit);
			curPartida.refreshBuffer();
			curPartida.setNull("idrectificacion349");
			if (!curPartida.commitBuffer()) {
				return false;
			}
		}
		curRectificaciones.setModeAccess(curRectificaciones.Del);
		if (!curRectificaciones.commitBuffer()) {
			return false;
		}
	}
	
		
	this.iface.calcularTotales();
	/*
	this.child("fdbNumTotalOI").setValue(0);
	this.child("fdbImporteTotalOI").setValue(0);
	this.child("fdbNumTotalOIRec").setValue(0);
	this.child("fdbNumTotalOIRec").setValue(0);
	*/
	return true;
}

function oficial_borrarOperacionesIntra()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var res:Number = MessageBox.information(util.translate("scripts", "Va a borrar el registro seleccionado de Operaciones Intracomunitarias.\n¿Está seguro?"), MessageBox.Yes, MessageBox.No);
	if (res != MessageBox.Yes) {
		return false;
	}
		
	var curOperacion:FLSqlCursor = this.child("tdbOperaciones").cursor();
	var idOperacion:String = curOperacion.valueBuffer("id");
	if (!idOperacion) {
		return false;
	}

	var curPartidas:FLSqlCursor = new FLSqlCursor("co_partidas");	
	curPartidas.setActivatedCommitActions(false);
	curPartidas.select("idoperacion349 = " + idOperacion);
	while (curPartidas.next()) {
		curPartidas.setModeAccess(curPartidas.Edit);
		curPartidas.refreshBuffer();
		curPartidas.setNull("idoperacion349");
		if (!curPartidas.commitBuffer()) {
			return false;
		}
	}
	curOperacion.setModeAccess(curOperacion.Del);
	curOperacion.refreshBuffer();
	if (!curOperacion.commitBuffer()) {
		return false;
	}
	this.child("tdbOperaciones").refresh();
	this.iface.calcularTotales();
}

function oficial_borrarRectificaciones()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var res:Number = MessageBox.information(util.translate("scripts", "Va a borrar el registro seleccionado de Rectificaciones.\n¿Está seguro?"), MessageBox.Yes, MessageBox.No);
	if (res != MessageBox.Yes) {
		return false;
	}
		
	var curRectificacion:FLSqlCursor = this.child("tdbRectificaciones").cursor();
	var idRectificacion:String = curRectificacion.valueBuffer("id");
	if (!idRectificacion) {
		return false;
	}

	var curPartidas:FLSqlCursor = new FLSqlCursor("co_partidas");	
	curPartidas.setActivatedCommitActions(false);
	curPartidas.select("idrectificacion349 = " + idRectificacion);
	while (curPartidas.next()) {
		curPartidas.setModeAccess(curPartidas.Edit);
		curPartidas.refreshBuffer();
		curPartidas.setNull("idrectificacion349");
		if (!curPartidas.commitBuffer()) {
			return false;
		}
	}
	curRectificacion.setModeAccess(curRectificacion.Del);
	curRectificacion.refreshBuffer();
	if (!curRectificacion.commitBuffer()) {
		return false;
	}
	this.child("tdbRectificaciones").refresh();
	this.iface.calcularTotales();
}

function oficial_habilitarPeriodo()
{
	var cursor:FLSqlCursor = this.cursor();

	switch (cursor.valueBuffer("tipoperiodo")) {
		case "Mes": {
			this.child("fdbMes").setShowAlias(true);
			this.child("fdbMes").setShowEditor(true);
			this.child("fdbPeriodo").setShowAlias(false);
			this.child("fdbPeriodo").setShowEditor(false);
			break;
		}
		case "Trimestre": {
			this.child("fdbPeriodo").setShowAlias(true);
			this.child("fdbPeriodo").setShowEditor(true);
			this.child("fdbMes").setShowAlias(false);
			this.child("fdbMes").setShowEditor(false);
			break;
		}
		case "Año" : {
			this.child("fdbPeriodo").setShowAlias(false);
			this.child("fdbPeriodo").setShowEditor(false);
			this.child("fdbMes").setShowAlias(false);
			this.child("fdbMes").setShowEditor(false);
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
