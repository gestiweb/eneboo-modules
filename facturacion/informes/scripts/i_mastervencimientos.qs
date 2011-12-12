/***************************************************************************
                 i_mastervencimientos.qs  -  description
                             -------------------
    begin                : lun jul 25 2005
    copyright            : (C) 2005 by InfoSiAL S.L.
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
El informe de flujo de caja por vencimientos permite anticipar la evolución de los saldos de las cuentas bancarias de la empresa. Dado que los saldos variarán a medida que los recibos emitidos a clientes y proveedores vayan venciendo, es posible generar un listado que refleje dichas variaciones.
Los posibles criterios que podemos especificar son:
Cuenta: Cuenta bancaria cuyo flujo de caja queremos calcular. Si la dejamos en blanco el informe recogerá la evolución de todas las cuentas bancarias, incluida la 'cuenta' de caja. Esto es útil para comprobar el flujo de caja total de la empresa. La cuenta de un recibo es el valor de su cuenta de pago. Si este valor no está establecido se tomará primero el de cuenta de remesa / pago en la ficha de cliente / proveedor y, si este valor tampoco está definido, la cuenta asociada a la forma de pago
Saldo inicial: Es el saldo a partir del cual se irán acumulando los cobros y pagos en el informe. Si el módulo de contabilidad está instalado, el sistema nos informará del saldo actual en las subcuentas correspondientes a las cuentas bancarias seleccionadas, ofrecuiéndonos la oportunidad de cambiarlo antes de lanzar el informe.
Período de vencimientos
Ejercicio
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var saldo:Number;
	var contActiva:Boolean;
	var codSubcuentaCaja:String;
	var idImpresion:String;
    function oficial( context ) { interna( context ); } 
	function imprimir() {
		return this.ctx.oficial_imprimir();
	}
	function lanzar(cursor:FLSqlCursor) {
		return this.ctx.oficial_lanzar(cursor);
	}
	function incluirRecibos(curCriterios:FLSqlCursor, tipo:String):Boolean {
		return this.ctx.oficial_incluirRecibos(curCriterios, tipo);
	}
	function actualizarSaldo(nodo:FLDomNode, campo:String):String {
		return this.ctx.oficial_actualizarSaldo(nodo, campo);
	}
	function obtenerSaldo(nodo:FLDomNode, campo:String):String {
		return this.ctx.oficial_obtenerSaldo(nodo, campo);
	}
	function whereExtra() {
		return this.ctx.oficial_whereExtra();
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
	function pub_actualizarSaldo(nodo:FLDomNode, campo:String):String {
		return this.actualizarSaldo(nodo, campo);
	}
	function pub_obtenerSaldo(nodo:FLDomNode, campo:String):String {
		return this.obtenerSaldo(nodo, campo);
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
	var util:FLUtil = new FLUtil;
	this.iface.contActiva = sys.isLoadedModule("flcontppal");
	if (this.iface.contActiva) {
		var codEjercicio:String = flfactppal.iface.pub_ejercicioActual();
		var datosCta:Array = flfacturac.iface.pub_datosCtaEspecial("CAJA", codEjercicio);
		if (datosCta.error != 0) {
			MessageBox.warning(util.translate("scripts", "Falló la búsqueda de la subcuenta de CAJA"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
		this.iface.codSubcuentaCaja = datosCta.codsubcuenta;
	}
	connect (this.child("toolButtonPrint"), "clicked()", this, "iface.imprimir()");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Calcula el saldo inicial y llama a la función de lanzamiento del informe 
\end */
function oficial_imprimir()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var id:String = cursor.valueBuffer("id");
	if (!id)
		return;
	
	if (this.iface.contActiva) {
		var codCuenta:String = cursor.valueBuffer("codcuenta");
		var saldoActual:Number;
		var mensajeCont:String;
		if (!codCuenta || codCuenta == "") {
			saldoActual = util.sqlSelect("co_subcuentas", "SUM(saldo)", "codejercicio = '" + cursor.valueBuffer("codejercicio") + "' AND codcuenta IN (570, 572)");
			mensajeCont = util.translate("scripts", "El saldo actual de las subcuentas de caja (570) y bancos (572) es de ");
		} else {
			var codSubcuenta:String = util.sqlSelect("cuentasbanco", "codsubcuenta", "codcuenta = '" + codCuenta + "'");
			saldoActual = util.sqlSelect("co_subcuentas", "saldo", "codejercicio = '" + cursor.valueBuffer("codejercicio") + "' AND codsubcuenta = '" + codSubcuenta + "'");
			mensajeCont = codCuenta + "/" + codSubcuenta + util.translate("scripts", ": El saldo actual de la subcuenta seleccionada es de ");
		}
		mensajeCont += util.roundFieldValue(saldoActual, "co_subcuentas", "saldo") + util.translate("scripts", " Euros")
		mensajeCont += "\n" + util.translate("scripts", "Especifique el saldo inicial para el informe:");
		var qrySaldo:FLSqlQuery = new FLSqlQuery;
		qrySaldo.setTablesList("cuentasbanco,co_subcuentas");
		qrySaldo.setSelect("s.saldo");
		qrySaldo.setFrom("cuentasbanco c INNER JOIN co_subcuentas s ");
		var saldoInicial = Input.getNumber(mensajeCont, cursor.valueBuffer("saldoinicial"), 2);
		if (!saldoInicial && saldoInicial != 0)
			return;
		if (parseFloat(saldoInicial) != parseFloat(cursor.valueBuffer("saldoinicial"))) {
			cursor.transaction(false);
			if (!util.sqlUpdate("i_vencimientos", "saldoinicial", saldoInicial, "id = " + id)) {
				MessageBox.critical(util.translate("scripts", "Falló la actualización del saldo inicial"), MessageBox.Ok, MessageBox.NoButton);
				cursor.rollback();
				return;
			}
			cursor.commit();
			cursor.refresh();
		}
	}
	var curCriterios:FLSqlCursor = new FLSqlCursor("i_vencimientos");
	curCriterios.select("id = " + id);
	curCriterios.first();
		
	this.iface.lanzar(curCriterios);
}

/** \D Informa la tabla temporal que se usa como base para crear el informe y lo lanza
@param	cursor: Cursor posicionado en el registro de criterios de búsqueda
\end */
function oficial_lanzar(cursor:FLSqlCursor)
{
	var util:FLUtil = new FLUtil;
		
	var nombreInforme:String = cursor.action();
	this.iface.saldo = parseFloat(cursor.valueBuffer("saldoinicial"));

	var ahora:Date = new Date;
	this.iface.idImpresion = ahora.getTime().toString();
	this.iface.idImpresion += sys.nameUser();
	
	if (!this.iface.incluirRecibos(cursor, "PROV"))
		return;
	if (!this.iface.incluirRecibos(cursor, "CLI"))
		return;
	
	var q:FLSqlQuery = new FLSqlQuery("i_vencimientos");
	q.setWhere("criterios.id = " + cursor.valueBuffer("id") + " AND idimpresion = '" + this.iface.idImpresion + "'");
	if (!q.exec()) {
		MessageBox.critical(util.translate("scripts", "Falló la consulta"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	if (!q.first())  {
		MessageBox.warning(util.translate("scripts", "No hay datos para los criterios establecidos"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	
	var rptViewer:FLReportViewer = new FLReportViewer();
	rptViewer.setReportTemplate("i_vencimientos");
	rptViewer.setReportData(q);
	rptViewer.renderReport();
	rptViewer.exec();

	var curBorrar:FLSqlCursor = new FLSqlCursor("i_vencimientos_buffer");
/// 	curBorrar.setForwardOnly(true); pendiente de nueva versión binario
	curBorrar.select("idimpresion = '" + this.iface.idImpresion + "'");
	while (curBorrar.next()) {
		curBorrar.setModeAccess(curBorrar.Del);
		curBorrar.refreshBuffer();
		if (!curBorrar.commitBuffer()) {
			MessageBox.warning(util.translate("scripts", "Hubo un error al borrar los registros de la tabla temporal"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}
	this.iface.idImpresion = false;
}

/** \D 
Busca e incluye en la tabla temporal aquellos recibos de cliente o proveedor que cumplen los criterios de búsqueda impuestos
@param	curCriterios: Cursor con el resto de criterios de búsqueda
@param	tipo: Indicador de si se debe buscar recibos de cliente (valor CLI) o proveedor (valor PROV)
@return	true si la búsqueda se realizó correctamente, false en caso contrario
*/
function oficial_incluirRecibos(curCriterios:FLSqlCursor, tipo:String):Boolean
{
	var util:FLUtil = new FLUtil;
	var codCuentaCri:String = curCriterios.valueBuffer("codcuenta");
	var codEjercicio:String = curCriterios.valueBuffer("codejercicio");
	
	var intervalo:Array = [];
	
	if (curCriterios.valueBuffer("codintervalo")) {
		intervalo = flfactppal.iface.pub_calcularIntervalo(curCriterios.valueBuffer("codintervalo"));
		curCriterios.setValueBuffer("fechavtodesde", intervalo.desde);
		curCriterios.setValueBuffer("fechavtohasta", intervalo.hasta);
	}
	
	var fechas:String = "";
debug(curCriterios.valueBuffer("fechavtodesde"));
debug(curCriterios.isNull("fechavtodesde"));
	if (!curCriterios.isNull("fechavtodesde") != "") {
		fechas += " AND r.fechav >= '" + curCriterios.valueBuffer("fechavtodesde") + "'";
	if (!curCriterios.isNull("fechavtohasta") != "" )
		fechas += " AND r.fechav <= '" + curCriterios.valueBuffer("fechavtohasta") + "'";
	}
	
	var where:String = "estado <> 'Pagado'" + fechas;
	if (codEjercicio && codEjercicio != "")
		where += " AND f.codejercicio = '" + codEjercicio + "'";
	where += this.iface.whereExtra();
	
	var qryRecibosCli:FLSqlQuery = new FLSqlQuery();
	if (tipo == "CLI") {
		qryRecibosCli.setTablesList("reciboscli,facturascli,formaspago,clientes");
		qryRecibosCli.setSelect("r.fechav, r.fecha, f.codcliente, r.codigo, fp.codcuenta, r.importe, f.nombrecliente, c.codcuentarem, r.codcuentapago");
		qryRecibosCli.setFrom("reciboscli r INNER JOIN facturascli f ON r.idfactura = f.idfactura INNER JOIN formaspago fp ON f.codpago = fp.codpago LEFT OUTER JOIN clientes c ON r.codcliente = c.codcliente");
	} else {
		qryRecibosCli.setTablesList("recibosprov,facturasprov,formaspago,proveedores");
		qryRecibosCli.setSelect("r.fechav, r.fecha, f.codproveedor, r.codigo, fp.codcuenta, r.importe, f.nombre, p.codcuentapago, r.codcuentapago");
		qryRecibosCli.setFrom("recibosprov r INNER JOIN facturasprov f ON r.idfactura = f.idfactura INNER JOIN formaspago fp ON f.codpago = fp.codpago LEFT OUTER JOIN proveedores p ON r.codproveedor = p.codproveedor");
	}
	
	qryRecibosCli.setWhere(where);
	if (!qryRecibosCli.exec()) {
		MessageBox.critical(util.translate("scripts", "Falló la consulta"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	
	var curVtoTemp:FLSqlCursor = new FLSqlCursor("i_vencimientos_buffer");
	var importe:Number, cobro:Number, pago:Number;
	var codCuenta:String, desCuenta:String, concepto:String;
	var codSubcuenta:String = "";
	
	while (qryRecibosCli.next()) {
		importe = parseFloat(qryRecibosCli.value(5));
		if (qryRecibosCli.value(8))
			codCuenta = qryRecibosCli.value(8);
		else if (qryRecibosCli.value(7))
			codCuenta = qryRecibosCli.value(7);
		else 
			codCuenta = qryRecibosCli.value(4);
		if (codCuentaCri && codCuentaCri != "" && codCuentaCri != codCuenta)
			continue;
			
		if (codCuenta && codCuenta != "") {
			var qryCuentas:FLSqlQuery = new FLSqlQuery();
			qryCuentas.setTablesList("cuentasbanco");
			qryCuentas.setSelect("descripcion, codsubcuenta");
			qryCuentas.setFrom("cuentasbanco");
			qryCuentas.setWhere("codcuenta = '" + codCuenta + "'");
			qryCuentas.exec();
			qryCuentas.first();
			desCuenta = qryCuentas.value(0);
			codSubcuenta = qryCuentas.value(1);
		} else {
			desCuenta = util.translate("scripts", "Caja");
			if (this.iface.contActiva) 
				codSubcuenta = this.iface.codSubcuentaCaja;
			else
				codSubcuenta = "";
		}
		
		if (tipo == "CLI") {
			cobro = importe;
			pago = 0;
			concepto = util.translate("scripts", "Cobro recibo ") + qryRecibosCli.value(3);
		} else {
			cobro = 0;
			pago = importe;
			concepto = util.translate("scripts", "Pago recibo ") + qryRecibosCli.value(3);
		}
		
		curVtoTemp.setModeAccess(curVtoTemp.Insert);
		curVtoTemp.refreshBuffer();
		curVtoTemp.setValueBuffer("idimpresion", this.iface.idImpresion);
		curVtoTemp.setValueBuffer("fechavto", qryRecibosCli.value(0));
		curVtoTemp.setValueBuffer("fechaemision", qryRecibosCli.value(1));
		curVtoTemp.setValueBuffer("codsujeto", qryRecibosCli.value(2));
		curVtoTemp.setValueBuffer("codrecibo", qryRecibosCli.value(3));
		curVtoTemp.setValueBuffer("codcuenta", codCuenta);
		curVtoTemp.setValueBuffer("descuenta", desCuenta);
		curVtoTemp.setValueBuffer("codsubcuenta", codSubcuenta);
		curVtoTemp.setValueBuffer("concepto",  concepto);
		curVtoTemp.setValueBuffer("nombresujeto", qryRecibosCli.value(6));
		curVtoTemp.setValueBuffer("cobros", cobro);
		curVtoTemp.setValueBuffer("pagos", pago);
		curVtoTemp.setValueBuffer("saldo", this.iface.saldo);
		
		if (!curVtoTemp.commitBuffer()) {
			MessageBox.critical(util.translate("scripts", "Falló la creación de tabla temporal"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}
	return true;
}

function oficial_actualizarSaldo(nodo:FLDomNode, campo:String):String
{
	this.iface.saldo += parseFloat(nodo.attributeValue("buffer.cobros")) - parseFloat(nodo.attributeValue("buffer.pagos"))
	return this.iface.saldo;
}

function oficial_obtenerSaldo(nodo:FLDomNode, campo:String):String
{
	return this.iface.saldo;
}

/** \C Función a sobrecargar
\end */
function oficial_whereExtra()
{
	return "";
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
