/***************************************************************************
                 co_masterdatos347.qs  -  description
                             -------------------
    begin                : jue mar 122009
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
	var datosCliente_:Array;
	var datosProveedor_:Array;
	var ultimoNIF_:String;
	var contabilidad:Boolean;
	var total_:Number;
	function oficial( context ) { interna( context ); }
	function lanzar() {
		return this.ctx.oficial_lanzar();
	}
	function totalCliProv(nodo:FLDomNode, campo:String):String {
		return this.ctx.oficial_totalCliProv(nodo, campo);
	}
	function nombreProveedor(nodo:FLDomNode,campo:String):String {
		return this.ctx.oficial_nombreProveedor(nodo, campo);
	}
	function nombreCliente(nodo:FLDomNode,campo:String):String {
		return this.ctx.oficial_nombreCliente(nodo, campo);
	}
	function dirCliente(nodo:FLDomNode,campo:String):String {
		return this.ctx.oficial_dirCliente(nodo, campo);
	}
	function ciudadCliente(nodo:FLDomNode,campo:String):String {
		return this.ctx.oficial_ciudadCliente(nodo, campo);
	}
	function provCliente(nodo:FLDomNode,campo:String):String {
		return this.ctx.oficial_provCliente(nodo, campo);
	}
	function datosCliente(nodo:FLDomNode,campo:String) {
		return this.ctx.oficial_datosCliente(nodo, campo);
	}
	function dirProveedor(nodo:FLDomNode,campo:String):String {
		return this.ctx.oficial_dirProveedor(nodo, campo);
	}
	function ciudadProveedor(nodo:FLDomNode,campo:String):String {
		return this.ctx.oficial_ciudadProveedor(nodo, campo);
	}
	function provProveedor(nodo:FLDomNode,campo:String):String {
		return this.ctx.oficial_provProveedor(nodo, campo);
	}
	function datosProveedor(nodo:FLDomNode,campo:String) {
		return this.ctx.oficial_datosProveedor(nodo, campo);
	}
	function fechaEnLetra(nodo:FLDomNode,campo:String):String {
		return this.ctx.oficial_fechaEnLetra(nodo, campo);
	}
	function mostrarValores(nodo:FLDomNode,campo:String):String {
		return this.ctx.oficial_mostrarValores(nodo, campo);
	}
	function totalListado(nodo:FLDomNode,campo:String):Number {
		return this.ctx.oficial_totalListado(nodo, campo);
	}
	function textoFecha(fecha:String):String {
		return this.ctx.oficial_textoFecha(fecha);
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
	function pub_totalCliProv(nodo:FLDomNode, campo:String):String {
		return this.totalCliProv(nodo, campo);
	}
	function pub_nombreProveedor(nodo:FLDomNode,campo:String):String {
		return this.nombreProveedor(nodo, campo);
	}
	function pub_nombreCliente(nodo:FLDomNode,campo:String):String {
		return this.nombreCliente(nodo, campo);
	}
	function pub_fechaEnLetra(nodo:FLDomNode,campo:String):String {
		return this.fechaEnLetra(nodo, campo);
	}
	function pub_mostrarValores(nodo:FLDomNode,campo:String):String {
		return this.mostrarValores(nodo, campo);
	}
	function pub_dirCliente(nodo:FLDomNode,campo:String):String {
		return this.dirCliente(nodo,campo);
	}
	function pub_ciudadCliente(nodo:FLDomNode,campo:String):String {
		return this.ciudadCliente(nodo, campo);
	}
	function pub_provCliente(nodo:FLDomNode,campo:String):String {
		return this.provCliente(nodo, campo);
	}
	function pub_dirProveedor(nodo:FLDomNode,campo:String):String {
		return this.dirProveedor(nodo,campo);
	}
	function pub_ciudadProveedor(nodo:FLDomNode,campo:String):String {
		return this.ciudadProveedor(nodo, campo);
	}
	function pub_provProveedor(nodo:FLDomNode,campo:String):String {
		return this.provProveedor(nodo, campo);
	}
	function pub_totalListado(nodo:FLDomNode,campo:String):Number {
		return this.totalListado(nodo, campo);
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
	connect (this.child("toolButtonPrint"), "clicked()", this, "iface.lanzar()");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_lanzar()
{
	this.iface.total_ = 0;
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var seleccion:String = cursor.valueBuffer("id");
	if (!seleccion)
		return;

	var cantidad:Number = cursor.valueBuffer("cantidad");
	var tipo:String = cursor.valueBuffer("tipo");
	var codSerie:String = cursor.valueBuffer("codserie");
	var codEjercicio:String = cursor.valueBuffer("codejercicio");
	this.iface.contabilidad = (cursor.valueBuffer("origen") == "Contabilidad");
	var consulta:String;
	var report:String;
	
	var where:String = "paises.codiso = 'ES'";
	if (this.iface.contabilidad) {
	 	where += "AND (co_asientos.nomodelo347 = false OR co_asientos.nomodelo347 IS NULL)";
	} else {
		where += "AND f.codejercicio = '" + cursor.valueBuffer("codejercicio") + "' AND (f.nomodelo347 = false OR f.nomodelo347 IS NULL)";
		if (codSerie && codSerie != "") {
			where += " AND f.codserie = '" + codSerie + "'";
		}
	}
	var orden:String = cursor.valueBuffer("orden");
	var orderBy:String;

	if (tipo == "Proveedores") {
		var cifNif:String = cursor.valueBuffer("cifnif");
		orderBy = (orden == "Nombre" ? "proveedores.nombre" : "proveedores.cifnif");
		
// 		var codProveedor:String = cursor.valueBuffer("codproveedor");
		report = cursor.valueBuffer( "listado" ) ? "co_datos347listprov" : "co_datos347prov";
		consulta = "co_datos347prov";
		if (this.iface.contabilidad) {
			where += "AND co_asientos.codejercicio = '" + cursor.valueBuffer("codejercicio") + "' AND co_asientos.tipodocumento = 'Factura de proveedor'";
			consulta += "_con";
			if (cifNif && cifNif != "") {
				var qrySubcuentas:FLSqlQuery = new FLSqlQuery;
				qrySubcuentas.setTablesList("proveedores,co_subcuentasprov");
				qrySubcuentas.setSelect("sp.idsubcuenta");
				qrySubcuentas.setFrom("proveedores p INNER JOIN co_subcuentasprov sp ON p.codproveedor = sp.codproveedor");
				qrySubcuentas.setWhere("p.cifnif = '" + cifNif + "' AND sp.codejercicio = '" + codEjercicio + "'");
				qrySubcuentas.setForwardOnly(true);
				if (!qrySubcuentas.exec()) {
					return false;
				}
				var listaSubcuentas:String = "";
				while (qrySubcuentas.next()) {
					if (listaSubcuentas != "") {
						listaSubcuentas += ", ";
					}
					listaSubcuentas += qrySubcuentas.value("sp.idsubcuenta");
				}
				if (listaSubcuentas == "") {
					MessageBox.warning(util.translate("scripts", "Los proveedores de Cif/Nif %1 no tiene subcuenta asignada para el ejercicio %2").arg(cifNif).arg(codEjercicio), MessageBox.Ok, MessageBox.NoButton);
					return;
				}
				where += " AND scp.idsubcuenta IN (" + listaSubcuentas + ")";
			}
			flcontmode.iface.pub_lanzar(cursor, consulta, where + " GROUP BY empresa.nombre, empresa.cifnif, empresa.direccion, empresa.codpostal, empresa.ciudad, proveedores.cifnif, proveedores.nombre HAVING SUM(pprov.haber - pprov.debe) >= " + cantidad + " ORDER BY " + orderBy, report);
		} else {
			if (cifNif && cifNif != "") {
				where += " AND f.cifnif = '" + cifNif + "'";
			}
			flcontmode.iface.pub_lanzar(cursor, consulta, where + " GROUP BY empresa.nombre, empresa.logo, empresa.cifnif, empresa.direccion, empresa.codpostal, empresa.ciudad, proveedores.cifnif, proveedores.nombre HAVING SUM(f.total) >= " + cantidad + " ORDER BY " + orderBy, report);
		}
	} else {
		var cifNif:String = cursor.valueBuffer("cifnif");
		report = cursor.valueBuffer( "listado" ) ? "co_datos347list" : "co_datos347";
		consulta = "co_datos347";
		orderBy = (orden == "Nombre" ? "clientes.nombre" : "clientes.cifnif");

		if (this.iface.contabilidad) {
			where += " AND co_asientos.codejercicio = '" + cursor.valueBuffer("codejercicio") + "' AND co_asientos.tipodocumento = 'Factura de cliente'";
			if (codSerie && codSerie != "")
				where += " AND piva.codserie = '" + codSerie + "'";
			consulta += "_con";
			if (cifNif && cifNif != "") {
				var qrySubcuentas:FLSqlQuery = new FLSqlQuery;
				qrySubcuentas.setTablesList("clientes,co_subcuentascli");
				qrySubcuentas.setSelect("sc.idsubcuenta");
				qrySubcuentas.setFrom("clientes c INNER JOIN co_subcuentascli sc ON c.codcliente = sc.codcliente");
				qrySubcuentas.setWhere("c.cifnif = '" + cifNif + "' AND sc.codejercicio = '" + codEjercicio + "'");
				qrySubcuentas.setForwardOnly(true);
				if (!qrySubcuentas.exec()) {
					return false;
				}
				var listaSubcuentas:String = "";
				while (qrySubcuentas.next()) {
					if (listaSubcuentas != "") {
						listaSubcuentas += ", ";
					}
					listaSubcuentas += qrySubcuentas.value("sc.idsubcuenta");
				}
				if (listaSubcuentas == "") {
					MessageBox.warning(util.translate("scripts", "Los clientes de Cif/Nif %1 no tiene subcuenta asignada para el ejercicio %2").arg(cifNif).arg(codEjercicio), MessageBox.Ok, MessageBox.NoButton);
					return;
				}
				where += " AND scc.idsubcuenta IN (" + listaSubcuentas + ")";
			}
			flcontmode.iface.pub_lanzar(cursor, consulta, where + " GROUP BY empresa.nombre, empresa.cifnif, empresa.direccion, empresa.codpostal, empresa.ciudad, clientes.cifnif, clientes.nombre HAVING SUM(pcli.debe - pcli.haber) >= " + cantidad + " ORDER BY " + orderBy, report);
		} else {
			if (cifNif && cifNif != "") {
				where += " AND f.cifnif = '" + cifNif + "'";
			}
			flcontmode.iface.pub_lanzar(cursor, consulta, where + " GROUP BY empresa.nombre, empresa.cifnif, empresa.direccion, empresa.codpostal, empresa.ciudad, clientes.cifnif, clientes.nombre HAVING SUM(f.total) >= " + cantidad + " ORDER BY " + orderBy, report);
		}
	}
}
 
function oficial_totalCliProv(nodo:FLDomNode,campo:String):String
{
	var valor:String;
	if (this.iface.contabilidad) {
		if (campo == "cli") {
			valor = nodo.attributeValue("SUM(pcli.debe - pcli.haber)");
		} else {
			valor = nodo.attributeValue("SUM(pprov.haber - pprov.debe)");
		}
	} else {
		valor = nodo.attributeValue("SUM(f.total)");
	}
	this.iface.total_ += parseFloat(valor);
	return valor;
}

function oficial_totalListado(nodo:FLDomNode,campo:String):Number
{
	return this.iface.total_;
}

function oficial_nombreCliente(nodo:FLDomNode,campo:String):String
{
	if (nodo.attributeValue("clientes.cifnif") != this.iface.ultimoNIF_) {
		this.iface.datosCliente(nodo, campo);
	}
	return this.iface.datosCliente_["nombre"];
}

function oficial_fechaEnLetra(nodo:FLDomNode,campo:String):String
{
	var hoy:Date = new Date();
	var fecha:String = hoy.toString().left(10);
	var valor:String = this.iface.textoFecha(fecha);

	return valor;
}

function oficial_textoFecha(fecha:String):String
{
	var util:FLUtil;
	if (!fecha || fecha == "") {
		return "";
	}
	var mes:String = fecha.mid(5, 2);
	var textoMes:String;
	switch (mes) {
		case "01": { textoMes = util.translate("scripts", "Enero"); break; }
		case "02": { textoMes = util.translate("scripts", "Febrero"); break; }
		case "03": { textoMes = util.translate("scripts", "Marzo"); break; }
		case "04": { textoMes = util.translate("scripts", "Abril"); break; }
		case "05": { textoMes = util.translate("scripts", "Mayo"); break; }
		case "06": { textoMes = util.translate("scripts", "Junio"); break; }
		case "07": { textoMes = util.translate("scripts", "Julio"); break; }
		case "08": { textoMes = util.translate("scripts", "Agosto"); break; }
		case "09": { textoMes = util.translate("scripts", "Septiembre"); break; }
		case "10": { textoMes = util.translate("scripts", "Octubre"); break; }
		case "11": { textoMes = util.translate("scripts", "Noviembre"); break; }
		case "12": { textoMes = util.translate("scripts", "Diciembre"); break; }
	}
	var dia:String = fecha.mid(8, 3);
	var ano:String = parseInt(fecha.mid(0, 4));
	var texto:String = util.translate("scripts", "%1 de %2 de %3").arg(dia.toString()).arg(textoMes).arg(ano);
	return texto;
}

function oficial_dirCliente(nodo:FLDomNode,campo:String):String
{
	if (nodo.attributeValue("clientes.cifnif") != this.iface.ultimoNIF_) {
		this.iface.datosCliente(nodo, campo);
	}
	return this.iface.datosCliente_["direccion"];
}

function oficial_ciudadCliente(nodo:FLDomNode,campo:String):String
{
	if (nodo.attributeValue("clientes.cifnif") != this.iface.ultimoNIF_) {
		this.iface.datosCliente(nodo, campo);
	}
	return this.iface.datosCliente_["codpostal"] + " " + this.iface.datosCliente_["ciudad"];
}

function oficial_provCliente(nodo:FLDomNode,campo:String):String
{
	if (nodo.attributeValue("clientes.cifnif") != this.iface.ultimoNIF_) {
		this.iface.datosCliente(nodo, campo);
	}
	return this.iface.datosCliente_["provincia"];
}

function oficial_datosCliente(nodo:FLDomNode,campo:String)
{
	if (!this.iface.datosCliente_) {
		this.iface.datosCliente_ = [];
	}

	var qryCliente:FLSqlQuery = new FLSqlQuery;
	qryCliente.setTablesList("clientes,dirclientes");
	qryCliente.setSelect("c.nombre, d.direccion, d.codpostal, d.ciudad, d.provincia");
	qryCliente.setFrom("clientes c INNER JOIN dirclientes d ON c.codcliente = d.codcliente");
	qryCliente.setWhere("c.cifnif = '" + nodo.attributeValue("clientes.cifnif") + "' AND d.domfacturacion = true");

	if (!qryCliente.exec()) {
		this.iface.datosCliente_["nombre"] = "";
		this.iface.datosCliente_["direccion"] = "";
		this.iface.datosCliente_["codpostal"] = "";
		this.iface.datosCliente_["ciudad"] = "";
		this.iface.datosCliente_["provincia"] = "";
	}
	if (qryCliente.first()) {
		this.iface.datosCliente_["nombre"] = qryCliente.value("c.nombre");
		this.iface.datosCliente_["direccion"] = qryCliente.value("d.direccion");
		this.iface.datosCliente_["codpostal"] = qryCliente.value("d.codpostal");
		this.iface.datosCliente_["ciudad"] = qryCliente.value("d.ciudad");
		this.iface.datosCliente_["provincia"] = qryCliente.value("d.provincia");
	} else {
		this.iface.datosCliente_["nombre"] = "";
		this.iface.datosCliente_["direccion"] = "";
		this.iface.datosCliente_["codpostal"] = "";
		this.iface.datosCliente_["ciudad"] = "";
		this.iface.datosCliente_["provincia"] = "";
	}
	this.iface.ultimoNIF_ = nodo.attributeValue("clientes.cifnif");
}

function oficial_nombreProveedor(nodo:FLDomNode,campo:String):String
{
	if (nodo.attributeValue("proveedores.cifnif") != this.iface.ultimoNIF_) {
		this.iface.datosProveedor(nodo, campo);
	}
	return this.iface.datosProveedor_["nombre"];
}

function oficial_dirProveedor(nodo:FLDomNode,campo:String):String
{
	if (nodo.attributeValue("proveedores.cifnif") != this.iface.ultimoNIF_) {
		this.iface.datosProveedor(nodo, campo);
	}
	return this.iface.datosProveedor_["direccion"];
}

function oficial_ciudadProveedor(nodo:FLDomNode,campo:String):String
{
	if (nodo.attributeValue("proveedores.cifnif") != this.iface.ultimoNIF_) {
		this.iface.datosProveedor(nodo, campo);
	}
	return this.iface.datosProveedor_["codpostal"] + " " + this.iface.datosProveedor_["ciudad"];
}

function oficial_provProveedor(nodo:FLDomNode,campo:String):String
{
	if (nodo.attributeValue("proveedores.cifnif") != this.iface.ultimoNIF_) {
		this.iface.datosProveedor(nodo, campo);
	}
	return this.iface.datosProveedor_["provincia"];
}

function oficial_datosProveedor(nodo:FLDomNode,campo:String)
{
	if (!this.iface.datosProveedor_) {
		this.iface.datosProveedor_ = [];
	}

	var qryProveedor:FLSqlQuery = new FLSqlQuery;
	qryProveedor.setTablesList("proveedores,dirproveedores");
	qryProveedor.setSelect("p.nombre, d.direccion, d.codpostal, d.ciudad, d.provincia");
	qryProveedor.setFrom("proveedores p INNER JOIN dirproveedores d ON p.codproveedor = d.codproveedor");
	qryProveedor.setWhere("p.cifnif = '" + nodo.attributeValue("proveedores.cifnif") + "' AND d.direccionppal = true");

	if (!qryProveedor.exec()) {
		this.iface.datosProveedor_["nombre"] = "";
		this.iface.datosProveedor_["direccion"] = "";
		this.iface.datosProveedor_["codpostal"] = "";
		this.iface.datosProveedor_["ciudad"] = "";
		this.iface.datosProveedor_["provincia"] = "";
	}
	if (qryProveedor.first()) {
		this.iface.datosProveedor_["nombre"] = qryProveedor.value("p.nombre");
		this.iface.datosProveedor_["direccion"] = qryProveedor.value("d.direccion");
		this.iface.datosProveedor_["codpostal"] = qryProveedor.value("d.codpostal");
		this.iface.datosProveedor_["ciudad"] = qryProveedor.value("d.ciudad");
		this.iface.datosProveedor_["provincia"] = qryProveedor.value("d.provincia");
	} else {
		this.iface.datosProveedor_["nombre"] = "";
		this.iface.datosProveedor_["direccion"] = "";
		this.iface.datosProveedor_["codpostal"] = "";
		this.iface.datosProveedor_["ciudad"] = "";
		this.iface.datosProveedor_["provincia"] = "";
	}
	this.iface.ultimoNIF_ = nodo.attributeValue("proveedores.cifnif");
}

function oficial_mostrarValores(nodo:FLDomNode,campo:String):String
{
	var cursor:FLSqlCursor = this.cursor();
	var cantidad:Number = cursor.valueBuffer("cantidad");
	var codEjercicio:String = cursor.valueBuffer("codejercicio");
	var valor:String;
	if (campo == "parrafo1") {
		var valorAux:String = cursor.valueBuffer(campo);
		if (valorAux && valorAux != "") {
			var iPos:Number = valorAux.find("#EJERCICIO#");
			if (iPos >= 0) {
				valor = valorAux.left(iPos) + codEjercicio + valorAux.right(valorAux.length - iPos - 11);
			}
			
			valorAux = valor;
			iPos = valorAux.find("#IMPORTE#");
			if (iPos >= 0) {
				valor = valorAux.left(iPos) + cantidad + valorAux.right(valorAux.length - iPos - 9);
			}
		}
	} else {
		valor = cursor.valueBuffer(campo);
	}
	return valor;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

