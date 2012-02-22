/***************************************************************************
                 se_masterclientes.qs  -  description
                             -------------------
    begin                : lun jun 20 2005
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
////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

/** @class_declaration interna */
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
	var saldoInicial_:Number;
	var saldoActual_:Number;
	var saldoResueltas_:Number;
	var saldoPendientes_:Number;
	var saldoProyecto_:Number;
	var nombreInforme_:String;
	var tableDBRecords:FLTableDB;
	var tbnImprimir:Object;
    function oficial( context ) { interna( context ); }
	function informeSaldo(codCliente:String, canMovimientos:Number,adjuntarPDF:Boolean):String {
		return this.ctx.oficial_informeSaldo(codCliente, canMovimientos,adjuntarPDF);
	}
	function imprimirSaldoCredito() {
		return this.ctx.oficial_imprimirSaldoCredito();
	}
	function initSaldoInforme(nodo:FLDomNode, campo:String):String {
		return this.ctx.oficial_initSaldoInforme(nodo, campo);
	}
	function initSaldoProyecto(nodo:FLDomNode, campo:String):String {
		return this.ctx.oficial_initSaldoProyecto(nodo, campo);
	}
	function saldoInforme(nodo:FLDomNode, campo:String):String {
		return this.ctx.oficial_saldoInforme(nodo, campo);
	}
	function saldoProyecto(nodo:FLDomNode, campo:String):String {
		return this.ctx.oficial_saldoProyecto(nodo, campo);
	}
	function totalSaldoInforme(nodo:FLDomNode, campo:String):String {
		return this.ctx.oficial_totalSaldoInforme(nodo, campo);
	}
	function totalSaldoResueltas(nodo:FLDomNode, campo:String):String {
		return this.ctx.oficial_totalSaldoResueltas(nodo, campo);
	}
	function totalSaldoPendientes(nodo:FLDomNode, campo:String):String {
		return this.ctx.oficial_totalSaldoPendientes(nodo, campo);
	}
	function totalSaldoProyecto(nodo:FLDomNode, campo:String):String {
		return this.ctx.oficial_totalSaldoProyecto(nodo, campo);
	}
	function cabeceraInforme(nodo:FLDomNode, campo:String):String {
		return this.ctx.oficial_cabeceraInforme(nodo, campo);
	}
	function totalSaldoCliente(nodo:FLDomNode, campo:String):Number {
		return this.ctx.oficial_totalSaldoCliente(nodo, campo);
	}
	function clienteUsuario(nodo:FLDomNode, campo:String):Number {
		return this.ctx.oficial_clienteUsuario(nodo, campo);
	}
	function desTitulo(nodo:FLDomNode, campo:String):String {
		return this.ctx.oficial_desTitulo(nodo, campo);
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
	function pub_initSaldoInforme(nodo:FLDomNode, campo:String):String {
		return this.initSaldoInforme(nodo, campo);
	}
	function pub_saldoInforme(nodo:FLDomNode, campo:String):String {
		return this.saldoInforme(nodo, campo);
	}
	function pub_totalSaldoInforme(nodo:FLDomNode, campo:String):String {
		return this.totalSaldoInforme(nodo, campo);
	}
	function pub_totalSaldoResueltas(nodo:FLDomNode, campo:String):String {
		return this.totalSaldoResueltas(nodo, campo);
	}
	function pub_totalSaldoPendientes(nodo:FLDomNode, campo:String):String {
		return this.totalSaldoPendientes(nodo, campo);
	}
	function pub_initSaldoProyecto(nodo:FLDomNode, campo:String):String {
		return this.initSaldoProyecto(nodo, campo);
	}
	function pub_saldoProyecto(nodo:FLDomNode, campo:String):String {
		return this.saldoProyecto(nodo, campo);
	}
	function pub_totalSaldoProyecto(nodo:FLDomNode, campo:String):String {
		return this.totalSaldoProyecto(nodo, campo);
	}
	function pub_cabeceraInforme(nodo:FLDomNode, campo:String):String {
		return this.cabeceraInforme(nodo, campo);
	}
	function pub_informeSaldo(codCliente:String, canMovimientos:Number, adjuntarPDF:Boolean):String {
		return this.informeSaldo(codCliente, canMovimientos, adjuntarPDF);
	}
	function pub_totalSaldoCliente(nodo:FLDomNode, campo:String):String {
		return this.totalSaldoCliente(nodo, campo);
	}
	function pub_clienteUsuario(nodo:FLDomNode, campo:String):String {
		return this.clienteUsuario(nodo, campo);
	}
	function pub_desTitulo(nodo:FLDomNode, campo:String):String {
		return this.desTitulo(nodo, campo);
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
/** \C
Los clientes sólo podrán crearse desde el formulario de clientes del área principal

Este formulario muestro los datos referentes subproyectos,incidencias y actualizaciones de los clientes 
\end */
function interna_init()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	this.iface.tbnImprimir = this.child("toolButtonPrint");
	connect(this.iface.tbnImprimir, "clicked()", this, "iface.imprimirSaldoCredito");
	
	this.iface.tableDBRecords = this.child("tableDBRecords");
	this.iface.tableDBRecords.putFirstCol("nombre");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_imprimirSaldoCredito()
{
	var cursor:FLSqlCursor = this.cursor();
	var codCliente:String = cursor.valueBuffer("codcliente");
	this.iface.informeSaldo(codCliente);
}

function oficial_informeSaldo(codCliente:String, canMovimientos:Number, adjuntarPDF:Boolean):String
{
	var util:FLUtil = new FLUtil;

	var dialog = new Dialog;
	dialog.caption = "Informe de saldo";
	dialog.okButtonText = "Aceptar"
	dialog.cancelButtonText = "Cancelar";
	
	var soloPtes = new CheckBox;
	soloPtes.text = "Mostrar sólo incidencias pendientes";
	soloPtes.checked = false;
	dialog.add( soloPtes);
	var chkAgrupar = new CheckBox;
	chkAgrupar.text = "Agrupar por proyecto";
	chkAgrupar.checked = true;
	dialog.add( chkAgrupar );

	if (!dialog.exec()) {
		return;
	}
	var nombreInforme:String = (chkAgrupar.checked ? "se_i_saldocredito" : "se_i_saldocredito_plano");
	var where:String = "clientes.codcliente = '" + codCliente + "' AND enbolsa = true";
	var queryInforme:FLSqlQuery = new FLSqlQuery(nombreInforme);
	queryInforme.setWhere(where);
	queryInforme.setOrderBy("se_incidencias.codcliente, se_incidencias.codproyecto, se_incidencias.codsubproyecto, se_incidencias.fechaapertura");
	if (!queryInforme.exec())
		return false;
	
debug(queryInforme.sql());
debug(queryInforme.size());
	if (queryInforme.size() <= 0) {
debug("!hau");
		MessageBox.warning(util.translate("scripts", "No hay registros que cumplan los criterios de búsqueda establecidos"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}

	this.iface.nombreInforme_ = util.translate("scripts", "Cliente: %1 - %2").arg(codCliente).arg(util.sqlSelect("clientes", "nombre", "codcliente = '" + codCliente + "'"));
	
	this.iface.saldoInicial_ = 0;
// 	if(!canMovimientos) 
// 		canMovimientos = queryInforme.size();
// 
// 	if (canMovimientos && canMovimientos > 0) {
// 		var desdeInforme:String = "";
// 		var saltar:Number = queryInforme.size() - canMovimientos;
// 		this.iface.saldoInicial_ = 0;
// 
// 		
// 
// 		if (saltar > 0) {
// 			for (var i:Number = 0; i < saltar; i++) {
// 				queryInforme.next();
// 				this.iface.saldoInicial_ += queryInforme.value("se_incidencias.precio");
// 			}
// 			desdeInforme = " AND se_incidencias.fechaapertura >= '" + queryInforme.value("se_incidencias.fechaapertura") + "' AND se_incidencias.codigo > '" + queryInforme.value("se_incidencias.codigo") + "'";
// 			queryInforme.setWhere(queryInforme.where() + desdeInforme);
// 		}
// 
// 		this.iface.nombreInforme_ += "\n" + util.translate("scripts", "Últimos %1 movimientos").arg(canMovimientos);
// 	}

	
	var wherePtes:String = "";
	if (soloPtes.checked) {
		wherePtes = " AND se_incidencias.estado = 'Pendiente'";
	}

	queryInforme.setWhere(where + wherePtes);

	var rptViewer:FLReportViewer = new FLReportViewer();
	rptViewer.setReportTemplate(nombreInforme);
	rptViewer.setReportData(queryInforme);
	rptViewer.renderReport();

	if (adjuntarPDF) {
		var archivo:String = flcolagedo.iface.obtenerPathLocal() + "/" + codCliente + "_Saldo.pdf";
		rptViewer.printReportToPDF(archivo);
		return archivo;
	} else {
		rptViewer.exec();
	}
}

function oficial_initSaldoInforme(nodo:FLDomNode, campo:String):String
{
	this.iface.saldoResueltas_ = this.iface.saldoInicial_;
	this.iface.saldoPendientes_ = 0;
	this.iface.saldoActual_ = this.iface.saldoInicial_;
	return this.iface.saldoInicial_;
}

function oficial_initSaldoProyecto(nodo:FLDomNode, campo:String):String
{
	this.iface.saldoProyecto_ = 0;
	return this.iface.saldoProyecto_;
}

function oficial_saldoInforme(nodo:FLDomNode, campo:String):String
{
debug("this.iface.saldoActual_1 = " + this.iface.saldoActual_);
	var importe:Number = parseFloat(nodo.attributeValue("se_incidencias.precio"));
	this.iface.saldoActual_ += importe;
	var estado:String = nodo.attributeValue("se_incidencias.estado");

	if (estado == "Resuelta" || estado == "En pruebas") {
		this.iface.saldoResueltas_ += importe;
	} else {
		this.iface.saldoPendientes_ += importe;
	}

	return this.iface.saldoActual_;
}

function oficial_saldoProyecto(nodo:FLDomNode, campo:String):String
{
	this.iface.saldoProyecto_ += parseFloat(nodo.attributeValue("se_incidencias.precio"));
	return this.iface.saldoProyecto_;
}

function oficial_totalSaldoInforme(nodo:FLDomNode, campo:String):String
{
	return this.iface.saldoActual_;
}

function oficial_totalSaldoResueltas(nodo:FLDomNode, campo:String):String
{
	return this.iface.saldoResueltas_;
}
function oficial_totalSaldoPendientes(nodo:FLDomNode, campo:String):String
{
	return this.iface.saldoPendientes_;
}

function oficial_totalSaldoProyecto(nodo:FLDomNode, campo:String):String
{
	return this.iface.saldoProyecto_;
}

function oficial_cabeceraInforme(nodo:FLDomNode, campo:String):String
{
	var valor:String;
	switch (campo) {
		case "nombre": {
			valor = this.iface.nombreInforme_;
			break;
		}
	}
	return valor;
}

function oficial_totalSaldoCliente(nodo:FLDomNode, campo:String):String
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	var valor:String = util.sqlSelect("se_incidencias", "SUM(precio)", "codcliente = '" + nodo.attributeValue("clientes.codcliente") + "' GROUP BY codfuncional");
debug(valor);
	return valor;
}

function oficial_clienteUsuario(nodo:FLDomNode, campo:String):String
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var nombre:String = util.sqlSelect("wi_ramasusuarios", "nombre", "codfuncional = '" + nodo.attributeValue("se_incidencias.codfuncional") + "'");

	if (!nombre || nombre == "") {
		nombre = nodo.attributeValue("clientes.nombre");;
	}
	return nombre;
}

function oficial_desTitulo(nodo:FLDomNode, campo:String):String
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var valor:String;
	switch (campo) {
		case "se_proyectos": {
			valor = nodo.attributeValue("se_proyectos.descripcion");
			break;
		}
		case "se_subproyectos": {
			valor = nodo.attributeValue("se_subproyectos.descripcion");
			break;
		}
	}
	if (!valor || valor == "") {
		valor = util.translate("scripts", "(Directo)");
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
