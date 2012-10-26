/***************************************************************************
                 pr_costeslote.qs  -  description
                             -------------------
    begin                : lun mar 15 2010
    copyright            : (C) 2010 by InfoSiAL S.L.
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
	function calculateField(fN:String):String {
		return this.ctx.interna_calculateField(fN);
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var lvwDescomposicion:Object;
	var nodoSeleccionado:Object;
	var tbnCalcular:Object;

	var CA_REFE:Number;
	var CA_DESC:Number;
	var CA_CANT:Number;
	var CA_COST:Number;
	var CA_CANR:Number;
	var CA_COSR:Number;
	var CA_CAND:Number;
	var CA_COSD:Number;
	var CA_COPD:Number;

	function oficial( context ) { interna( context ); }
	function refrescarArbol() {
		return this.ctx.oficial_refrescarArbol();
	}
	function establecerDatosNodo(nodo:FLListViewItem,datos:Array) {
		return this.ctx.oficial_establecerDatosNodo(nodo,datos);
	}
	function calcularDatosNodo(referencia:String, codLote:String):Array {
		return this.ctx.oficial_calcularDatosNodo(referencia, codLote);
	}
	function calcularDatosNodoRaiz():Array {
		return this.ctx.oficial_calcularDatosNodoRaiz();
	}
	function pintarNodo(nodo:FLListViewItem) {
		return this.ctx.oficial_pintarNodo(nodo);
	}
	function cambiarSeleccionNodo(nodo:FLListViewItem) {
		return this.ctx.oficial_cambiarSeleccionNodo(nodo);
	}
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.oficial_commonCalculateField(fN, cursor);
	}
	function refrescarTotales() {
		return this.ctx.oficial_refrescarTotales();
	}
	function configurarArbol() {
		return this.ctx.oficial_configurarArbol();
	}
	function tbnCalcular_clicked() {
		return this.ctx.oficial_tbnCalcular_clicked();
	}
	function refrescarCentros() {
		return this.ctx.oficial_refrescarCentros();
	}
	function refrescarTareas(idTipoProceso:String, idCosteCentro:String):Boolean {
		return this.ctx.oficial_refrescarTareas(idTipoProceso, idCosteCentro);
	}
	function totalizar() {
		return this.ctx.oficial_totalizar();
	}
	function totalizarCentro(idCosteCentro:String):Boolean {
		return this.ctx.oficial_totalizarCentro(idCosteCentro);
	}
	function filtrarTareasCentro() {
		return this.ctx.oficial_filtrarTareasCentro();
	}
	function filtrarTareasTrabajador() {
		return this.ctx.oficial_filtrarTareasTrabajador();
	}
	function habilitarPorLote() {
		return this.ctx.oficial_habilitarPorLote();
	}
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
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
	function pub_commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.commonCalculateField(fN, cursor);
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
\end */
function interna_init()
{
	var util:FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	this.iface.tbnCalcular = this.child("tbnCalcular");
	this.iface.lvwDescomposicion = this.child("lvwDescomposicion");
	
// 	if (this.iface.curProceso)
// 		delete this.iface.curProceso;
// 	this.iface.curProceso = new FLSqlCursor("pr_procesos");
// 	this.iface.curProceso.setAction("pr_procesos");
	
	connect(this.iface.tbnCalcular, "clicked()", this, "iface.tbnCalcular_clicked()");
	connect (this.iface.lvwDescomposicion, "selectionChanged(FLListViewItemInterface)", this, "iface.cambiarSeleccionNodo()");
// 	connect (this.child("tdbProcesos").cursor(), "bufferCommited()", this, "iface.refrescarArbol");
	connect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged(campo)");
	connect(this.child("tdbCosteTareaMO").cursor(), "newBuffer()", this, "iface.filtrarTareasTrabajador");
	connect(this.child("tdbCosteCentro").cursor(), "newBuffer()", this, "iface.filtrarTareasCentro");

	switch (cursor.modeAccess()) {
		case cursor.Insert: {
			this.child("fdbIdUsuario").setValue(sys.nameUser());
			break;
		}
		case cursor.Edit: {
// 			this.child("fdbReferencia").setDisabled(true);
			break;
		}
	}
	var campos:Array = ["id", "idtarea", "idtrabajador", "totalacumulado", "iniciocuentaf", "iniciocuentat", "fincuentaf", "fincuentat"]
	this.child("tdbCosteTareaTrab").setOrderCols(campos);

	this.iface.configurarArbol();

	this.iface.refrescarArbol();
	this.iface.filtrarTareasTrabajador();
	this.iface.filtrarTareasCentro();
	this.iface.habilitarPorLote();
}


function interna_validateForm():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	return true;
}

function interna_calculateField(fN:String):String
{
	var cursor:FLSqlCursor = this.cursor();
	res = this.iface.commonCalculateField(fN, cursor);
	return res;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_tbnCalcular_clicked()
{
	var util:FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	if (cursor.modeAccess() == cursor.Insert) {
		this.child("tdbCosteTareaMO").cursor().commitBufferCursorRelation();
	}
	this.iface.refrescarArbol();
	this.iface.refrescarCentros();
	this.iface.totalizar();
}

function oficial_totalizar()
{
	var util:FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var idCosteLote:String = cursor.valueBuffer("idcostelote");
	var codLote:String = cursor.valueBuffer("codlote");
	var hayLote:Boolean = (codLote && codLote != "");

	/// Material
	var raiz = this.iface.lvwDescomposicion.firstChild();
	if (!raiz) {
		return false;
	}
	var costeTeo:Number = 0, costeReal:Number = 0;
	var diferencia:Number = 0, porDiferencia:Number = 0;
	var referencia:String, costeUnidad:Number;
	for (var nodoLV = raiz.firstChild(); nodoLV; nodoLV = nodoLV.nextSibling()) {
		referencia = nodoLV.text(this.iface.CA_REFE);
		costeUnidad = util.sqlSelect("articulos", "pvp", "referencia = '" + referencia + "'");
		costeTeo += parseFloat(nodoLV.text(this.iface.CA_COST));
		if (hayLote) {
			costeReal += parseFloat(nodoLV.text(this.iface.CA_COSR));
		}
	}
	this.child("fdbMaterialTeo").setValue(util.roundFieldValue(costeTeo, "pr_costeslote", "materialteo"));
	if (hayLote) {
		this.child("fdbMaterialReal").setValue(util.roundFieldValue(costeReal, "pr_costeslote", "materialreal"));
	} else {
		this.child("fdbMaterialReal").setValue(0);
	}

	/// Máquinas
	var qryCentros:FLSqlQuery = new FLSqlQuery;
	qryCentros.setTablesList("pr_democostecentro");
	qryCentros.setSelect("SUM(totalteo), SUM(totalreal)");
	qryCentros.setFrom("pr_democostecentro");
	qryCentros.setWhere("idcostelote = " + idCosteLote);
	qryCentros.setForwardOnly(true);
	if (!qryCentros.exec()) {
		return false;
	}
	if (qryCentros.first()) {
		this.child("fdbMaquinasTeo").setValue(qryCentros.value("SUM(totalteo)"));
		this.child("fdbMaquinasReal").setValue(qryCentros.value("SUM(totalreal)"));
	}

	/// Mano de obra
	var qryMO:FLSqlQuery = new FLSqlQuery;
	qryMO.setTablesList("pr_democostetareamo");
	qryMO.setSelect("SUM(totalteo), SUM(totalreal)");
	qryMO.setFrom("pr_democostetareamo");
	qryMO.setWhere("idcostelote = " + idCosteLote);
	qryMO.setForwardOnly(true);
	if (!qryMO.exec()) {
		return false;
	}
debug(qryMO.sql());
	if (qryMO.first()) {
		this.child("fdbManoObraTeo").setValue(qryMO.value("SUM(totalteo)"));
		this.child("fdbManoObraReal").setValue(qryMO.value("SUM(totalreal)"));
	}

	/// Totales
	this.child("fdbTotalTeo").setValue(this.iface.calculateField("totalteo"));
	this.child("fdbTotalReal").setValue(this.iface.calculateField("totalreal"));
	this.child("fdbTotalDif").setValue(this.iface.calculateField("totaldif"));
	this.child("fdbTotalPorDif").setValue(this.iface.calculateField("totalpordif"));
}


function oficial_refrescarCentros()
{
	var util:FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var idCosteLote:String = cursor.valueBuffer("idcostelote");
	var referencia:String = cursor.valueBuffer("referencia");
	var idTipoProceso:String = util.sqlSelect("articulos", "idtipoproceso", "referencia = '" + referencia + "'");
	if (!idTipoProceso) {
		MessageBox.warning(util.translate("scripts", "El artículo %1 no tiene un proceso de producción asociado").arg(referencia), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	if (!util.sqlDelete("pr_democostecentro", "idcostelote = " + idCosteLote)) {
		return false;
	}

	var qryCentros:FLSqlQuery = new FLSqlQuery;
	qryCentros.setTablesList("pr_tipostareapro,pr_costestarea");
	qryCentros.setSelect("ct.codtipocentro");
	qryCentros.setFrom("pr_tipostareapro t INNER JOIN pr_costestarea ct ON t.idtipotareapro = ct.idtipotareapro");
	qryCentros.setWhere("t.idtipoproceso = '" + idTipoProceso + "' GROUP BY ct.codtipocentro");
	qryCentros.setForwardOnly(true);

	if (!qryCentros.exec()) {
		return false;
	}
	var curCosteCentro:FLSqlCursor = new FLSqlCursor("pr_democostecentro");
	var idCosteCentro:String;
	while (qryCentros.next()) {
		curCosteCentro.setModeAccess(curCosteCentro.Insert);
		curCosteCentro.refreshBuffer();
		curCosteCentro.setValueBuffer("idcostelote", idCosteLote);
		curCosteCentro.setValueBuffer("codtipocentro", qryCentros.value("ct.codtipocentro"));
		curCosteCentro.commitBuffer();

		idCosteCentro = curCosteCentro.valueBuffer("idcostecentro");
		if (!this.iface.refrescarTareas(idTipoProceso, idCosteCentro)) {
			return false;
		}
	}
	return true;
}

function oficial_refrescarTareas(idTipoProceso:String, idCosteCentro:String):Boolean
{
	var util:FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var idCosteLote:String = cursor.valueBuffer("idcostelote");
	var codLote:String = cursor.valueBuffer("codlote");
	var hayLote:Boolean = (codLote && codLote != "");

	if (!util.sqlDelete("pr_democostetareamo", "idcostelote = " + idCosteLote)) {
		return false;
	}

	var curCosteCentro:FLSqlCursor = new FLSqlCursor("pr_democostecentro");
	curCosteCentro.select("idcostecentro = " + idCosteCentro);
	if (!curCosteCentro.first()) {
debug("!idcostecentro = " + idCosteCentro);
		return false;
	}
	var codTipoCentro:String = curCosteCentro.valueBuffer("codtipocentro");
	var cantidad:Number = cursor.valueBuffer("canlote"); /// No sirve para más de un nivel

	var costeHora:Number = util.sqlSelect("pr_tiposcentrocoste", "costehora", "codtipocentro = '" + codTipoCentro + "'");
	if (isNaN(costeHora)) {
		costeHora = 0;
	}
	var costeHoraMO = 20; /// Parámetro a nivel de empresa

	var idProcesoLote:String;
	if (hayLote) {
		idProcesoLote = util.sqlSelect("pr_procesos", "idproceso", "idtipoproceso = '" + idTipoProceso + "' AND tipoobjeto = 'lotesstock' AND idobjeto = '" + codLote + "'");
		if (!idProcesoLote) {
			MessageBox.warning(util.translate("scripts", "El lote %1 no tiene un proceso de producción asociado").arg(codLote), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}
	var qryTareaLote:FLSqlQuery = new FLSqlQuery;
	qryTareaLote.setTablesList("pr_tareas");
	qryTareaLote.setSelect("SUM(tiempoinvertido)");
	qryTareaLote.setFrom("pr_tareas");
	qryTareaLote.setForwardOnly(true);

	var qryTareaMO:FLSqlQuery = new FLSqlQuery;
	qryTareaMO.setTablesList("pr_tareas,pr_tareastrabajador");
	qryTareaMO.setSelect("SUM(tt.totalacumulado)");
	qryTareaMO.setFrom("pr_tareas t INNER JOIN pr_tareastrabajador tt ON t.idtarea = tt.idtarea");
	qryTareaMO.setForwardOnly(true);
	
	var qryTareas:FLSqlQuery = new FLSqlQuery;
	qryTareas.setTablesList("pr_tipostareapro,pr_costestarea");
	qryTareas.setSelect("t.descripcion, ct.costeinicial, ct.costeunidad, ct.costeinicialmo, ct.costeunidadmo, t.idtipotareapro");
	qryTareas.setFrom("pr_tipostareapro t INNER JOIN pr_costestarea ct ON t.idtipotareapro = ct.idtipotareapro");
	qryTareas.setWhere("t.idtipoproceso = '" + idTipoProceso + "' AND ct.codtipocentro = '" + codTipoCentro + "'");
	qryTareas.setForwardOnly(true);
debug(qryTareas.sql());
	if (!qryTareas.exec()) {
		return false;
	}
	var curCosteTarea:FLSqlCursor = new FLSqlCursor("pr_democostetarea");
	var curCosteTareaMO:FLSqlCursor = new FLSqlCursor("pr_democostetareamo");
	var tiempoTeo:Number, tiempoReal:Number, totalTeo:Number, totalReal:Number, totalDif:Number, totalPorDif:Number;
	var tiempoTeoMO:Number, tiempoRealMO:Number, totalTeoMO:Number, totalRealMO:Number, totalDifMO:Number, totalPorDifMO:Number;
	var idTipoTareaPro:String;
	while (qryTareas.next()) {
		idTipoTareaPro = qryTareas.value("t.idtipotareapro");
		tiempoTeo = parseFloat(qryTareas.value("ct.costeinicial")) + (cantidad * parseFloat(qryTareas.value("ct.costeunidad")));
		totalTeo = tiempoTeo * costeHora;
		curCosteTarea.setModeAccess(curCosteTarea.Insert);
		curCosteTarea.refreshBuffer();
		curCosteTarea.setValueBuffer("idcostecentro", idCosteCentro);
		curCosteTarea.setValueBuffer("descripcion", qryTareas.value("t.descripcion"));
		curCosteTarea.setValueBuffer("tiempoteo", tiempoTeo);
		curCosteTarea.setValueBuffer("totalteo", totalTeo);
		if (hayLote) {
			qryTareaLote.setWhere("idproceso = " + idProcesoLote + " AND idtipotareapro = " + idTipoTareaPro);
			if (!qryTareaLote.exec()) {
				return false;
			}
			if (qryTareaLote.first()) {
				tiempoReal = qryTareaLote.value("SUM(tiempoinvertido)");
				if (isNaN(tiempoReal)) {
					tiempoReal = 0;
				}
				totalReal = tiempoReal * costeHora;
			} else {
				tiempoReal = 0;
				totalReal = 0;
			}
			totalDif = totalReal - totalTeo;
			totalPorDif = totalDif * 100 / totalTeo;
		}
		curCosteTarea.setValueBuffer("tiemporeal", util.roundFieldValue(tiempoReal, "pr_democostetarea", "tiemporeal"));
		curCosteTarea.setValueBuffer("totalreal", util.roundFieldValue(totalReal, "pr_democostetarea", "totalreal"));
		curCosteTarea.setValueBuffer("totaldif", util.roundFieldValue(totalDif, "pr_democostetarea", "totaldif"));
		curCosteTarea.setValueBuffer("totalpordif", util.roundFieldValue(totalPorDif, "pr_democostetarea", "totalpordif"));
		if (!curCosteTarea.commitBuffer()) {
			return false;
		}
		/// Mano de obra
		tiempoTeoMO = parseFloat(qryTareas.value("ct.costeinicialmo")) + (cantidad * parseFloat(qryTareas.value("ct.costeunidadmo")));
		totalTeoMO = tiempoTeoMO * costeHoraMO;
		curCosteTareaMO.setModeAccess(curCosteTareaMO.Insert);
		curCosteTareaMO.refreshBuffer();
		curCosteTareaMO.setValueBuffer("idcostelote", idCosteLote);
		curCosteTareaMO.setValueBuffer("idtipotareapro", idTipoTareaPro);
		curCosteTareaMO.setValueBuffer("descripcion", qryTareas.value("t.descripcion"));
		curCosteTareaMO.setValueBuffer("tiempoteo", tiempoTeoMO);
		curCosteTareaMO.setValueBuffer("totalteo", totalTeoMO);
		if (hayLote) {
			qryTareaMO.setWhere("t.idproceso = " + idProcesoLote + " AND t.idtipotareapro = " + idTipoTareaPro);
			if (!qryTareaMO.exec()) {
				return false;
			}
			if (qryTareaMO.first()) {
				tiempoRealMO = qryTareaMO.value("SUM(tt.totalacumulado)");
				if (isNaN(tiempoRealMO)) {
					tiempoRealMO = 0;
				}
				totalRealMO = tiempoRealMO * costeHoraMO;
			} else {
				tiempoRealMO = 0;
				totalRealMO = 0;
			}
			totalDifMO = totalRealMO - totalTeoMO;
			totalPorDif = totalDifMO * 100 / totalTeoMO;
		}
		curCosteTareaMO.setValueBuffer("tiemporeal", util.roundFieldValue(tiempoRealMO, "pr_democostetareamo", "tiemporeal"));
		curCosteTareaMO.setValueBuffer("totalreal", util.roundFieldValue(totalRealMO, "pr_democostetareamo", "totalreal"));
		curCosteTareaMO.setValueBuffer("totaldif", util.roundFieldValue(totalDifMO, "pr_democostetareamo", "totaldif"));
		curCosteTareaMO.setValueBuffer("totalpordif", util.roundFieldValue(totalPorDifMO, "pr_democostetareamo", "totalpordif"));
		if (!curCosteTareaMO.commitBuffer()) {
			return false;
		}
	}
	if (!this.iface.totalizarCentro(idCosteCentro)) {
		return false;
	}
	return true;
}

function oficial_totalizarCentro(idCosteCentro:String):Boolean
{
	var util:FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var codLote:String = cursor.valueBuffer("codlote");
	var hayLote:Boolean = (codLote && codLote != "");

	var curCosteCentro:FLSqlCursor = new FLSqlCursor("pr_democostecentro")
	curCosteCentro.select("idcostecentro = " + idCosteCentro);
	if (!curCosteCentro.first()) {
		return false;
	}
	var qryCostes:FLSqlQuery = new FLSqlQuery;
	qryCostes.setTablesList("pr_democostetarea,pr_democostetarea");
	qryCostes.setSelect("SUM(ct.tiempoteo), SUM(ct.totalteo), SUM(ct.tiemporeal), SUM(ct.totalreal)");
	qryCostes.setFrom("pr_democostecentro cc INNER JOIN pr_democostetarea ct ON cc.idcostecentro = ct.idcostecentro");
	qryCostes.setWhere("cc.idcostecentro = " + idCosteCentro);
	qryCostes.setForwardOnly(true);
	if (!qryCostes.exec()) {
		return false;
	}
	var totalTeo:Number, totalReal:Number, totalDif:Number, totalPorDif:Number;
	if (qryCostes.first()) {
		totalTeo = qryCostes.value("SUM(ct.totalteo)");

		curCosteCentro.setModeAccess(curCosteCentro.Edit);
		curCosteCentro.refreshBuffer();
		curCosteCentro.setValueBuffer("tiempoteo", qryCostes.value("SUM(ct.tiempoteo)"));
		curCosteCentro.setValueBuffer("totalteo", totalTeo);
		if (hayLote) {
			totalReal = qryCostes.value("SUM(ct.totalreal)");
			totalDif = totalReal - totalTeo;
			totalPorDif = totalDif * 100 / totalTeo;

			curCosteCentro.setValueBuffer("tiemporeal", qryCostes.value("SUM(ct.tiemporeal)"));
			curCosteCentro.setValueBuffer("totalreal", totalReal);
			curCosteCentro.setValueBuffer("totaldif", totalDif);
			curCosteCentro.setValueBuffer("totalpordif", util.roundFieldValue(totalPorDif, "pr_democostecentro", "totalpordif"));
		}
		if (!curCosteCentro.commitBuffer()) {
			return false;
		}
	}
	return true;
}

function oficial_refrescarArbol()
{
	var util:FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	this.iface.lvwDescomposicion.clear();

	var raiz = new FLListViewItem(this.iface.lvwDescomposicion);
	this.iface.nodoSeleccionado = raiz;
	
	var datosNodo:Array = new Array();
debug("oficial_calcularDatosNodoRaiz");
	datosNodo = this.iface.calcularDatosNodoRaiz();
	if (!datosNodo)
		return false;
debug("datosNodo OK");
	this.iface.establecerDatosNodo(raiz,datosNodo[0]);
debug("establecerDatosNodo OK");

	raiz.setExpandable(false);
	this.iface.pintarNodo(raiz, 1);
	raiz.setOpen(true);
	this.iface.nodoSeleccionado = raiz;

}

function oficial_establecerDatosNodo(nodo:FLListViewItem,datos:Array)
{
	var util:FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var codLote:String = cursor.valueBuffer("codlote");
	var hayLote:Boolean = (codLote && codLote != "");
debug("oficial_establecerDatosNodo + " + hayLote);

	if (datos["referencia"] && datos["referencia"] != "") {
		nodo.setText(0, datos["referencia"]);
	}
	if (datos["descripcion"] && datos["descripcion"] != "") {
		nodo.setText(1, datos["descripcion"]);
	}
	if (datos["cant"] && datos["cant"] != "") {
		nodo.setText(2, datos["cant"]);
	}
	if (datos["cost"] && datos["cost"] != "") {
		nodo.setText(3, datos["cost"]);
	}
	if (hayLote) {
debug("can real = " + datos["canr"]);
		if (datos["canr"] && datos["canr"] != "") {
			nodo.setText(4, datos["canr"]);
		}
		if (datos["cosr"] && datos["cosr"] != "") {
			nodo.setText(5, datos["cosr"]);
		}
		if (datos["cand"] && datos["cand"] != "") {
			nodo.setText(6, datos["cand"]);
		}
		if (datos["cosd"] && datos["cosd"] != "") {
			nodo.setText(7, datos["cosd"]);
		}
		if (datos["copd"] && datos["copd"] != "") {
			nodo.setText(8, datos["copd"]);
		}
	}
	if (datos["imagen"] && datos["imagen"] != "") {
		nodo.setPixmap(0, datos["imagen"]);
	}
	if (datos["key"] && datos["key"] != "") {
		nodo.setKey(datos["key"]);
	}
}

function oficial_pintarNodo(nodo:FLListViewItem)
{
	var util:FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var codLote:String = cursor.valueBuffer("codlote");/// No vale para más de un nivel
	var datosNodo:Array = new Array();
	
	if (!nodo)
		return;

	var referencia:String = nodo.text(0);
	if (!referencia || referencia == "") {
		return;
	}

	datosNodo = this.iface.calcularDatosNodo(referencia, codLote);
	if (!datosNodo) {
		return false;
	}
	nodo.setExpandable(false);

	var primerHijo:Boolean = false;
	for (var i = 0; i < datosNodo.length; i++) {
		if(!primerHijo){
			nodo.setExpandable(true);
			nodo.setOpen(true);
			primerHijo = true;
		}
		var nodoHijo = new FLListViewItem(nodo);
		this.iface.establecerDatosNodo(nodoHijo,datosNodo[i]);
		nodoHijo.setExpandable(false);
		this.iface.nodoSeleccionado = nodoHijo;
		this.iface.pintarNodo(nodoHijo);
	}
	return true;
}

function oficial_calcularDatosNodo(referencia:String, codLote:String):Array
{
	var util:FLUtil;
	var datosNodo:Array = new Array;
	var cursor:FLSqlCursor = this.cursor();

	var codFamilia:String;
	var hayLote:Boolean = (codLote && codLote != "");
	var imagen:String = "";

	var qTeo:FLSqlQuery = new FLSqlQuery;
	if (hayLote) {
		qTeo.setTablesList("articuloscomp,movistock,articulos");
		qTeo.setSelect("a.descripcion, a.pvp, ac.id, ac.refcomponente, ac.cantidad, SUM(ms.cantidad)");
		qTeo.setFrom("articuloscomp ac INNER JOIN articulos a ON ac.refcomponente = a.referencia LEFT OUTER JOIN movistock ms ON ac.id = ms.idarticulocomp AND ms.codloteprod = '" + codLote + "'");
		qTeo.setWhere("ac.refcompuesto = '" + referencia + "' GROUP BY a.descripcion, a.pvp, ac.id, ac.refcomponente, ac.cantidad");
	} else {
		qTeo.setTablesList("articuloscomp,movistock,articulos");
		qTeo.setSelect("a.descripcion, a.pvp, ac.refcomponente, ac.cantidad");
		qTeo.setFrom("articuloscomp ac INNER JOIN articulos a ON ac.refcomponente = a.referencia");
		qTeo.setWhere("ac.refcompuesto = '" + referencia + "'");
	}
	qTeo.setForwardOnly(true);
	if (!qTeo.exec()) {
		return false;
	}
	imagen = "";
	var i:Number = 0;
	var codLote:String;
	var estado:String;
	var idArticuloComp:String;

	var refComponente:String;
	var costeUnidad:Number, canTeo:Number, canReal;
	var cantidad:Number = parseFloat(cursor.valueBuffer("canlote"));
	while (qTeo.next()) {
		refComponente = qTeo.value("ac.refcomponente")
		costeUnidad = qTeo.value("a.pvp");
		codFamilia = util.sqlSelect("articulos","codfamilia","referencia = '" + refComponente + "'");
		if (codFamilia && codFamilia != "") {
			imagen = util.sqlSelect("familias","imagen","codfamilia = '" + codFamilia + "'");
		}
		canTeo = cantidad * qTeo.value("ac.cantidad");
		datosNodo[i] = new Array;
		datosNodo[i]["key"] = qTeo.value("id");
		datosNodo[i]["referencia"] = refComponente;
		datosNodo[i]["descripcion"] = "";
		datosNodo[i]["cant"] = canTeo;
		datosNodo[i]["cost"] = canTeo * parseFloat(costeUnidad);
		if (hayLote) {
			canReal = cantidad * qTeo.value("SUM(ms.cantidad)") * -1;
			if (isNaN(canReal)) {
				canReal = 0;
			}
			datosNodo[i]["canr"] = canReal;
			datosNodo[i]["cosr"] = canReal * parseFloat(costeUnidad);
			datosNodo[i]["cand"] = canReal - canTeo;
			datosNodo[i]["cosd"] = datosNodo[i]["cosr"] - datosNodo[i]["cost"];
			datosNodo[i]["copd"] = Math.round(datosNodo[i]["cosd"] * 100 / datosNodo[i]["cost"]);
		}
		datosNodo[i]["imagen"] = imagen;
		i += 1;
	}
	/// Faltaría buscar los consumos extra que no están en el escandallo del producto
	if (i == 0) {
		return false;
	}
	return datosNodo;
}

function oficial_calcularDatosNodoRaiz()
{
debug("oficial_calcularDatosNodoRaiz");
	var util:FLUtil;
	var datosNodo:Array = new Array;
	var cursor:FLSqlCursor = this.cursor();

	var referencia:String = cursor.valueBuffer("referencia");
debug("referencia0 = " + referencia);
	var codLote:String = cursor.valueBuffer("codlote");
	var codFamilia:String;
	var imagen:String = "";
	var hayLote:Boolean = (codLote && codLote != "");

	datosNodo[0] = new Array;
	datosNodo[0]["key"] = 0;
	datosNodo[0]["referencia"] = referencia;
debug("Referencia = " + datosNodo[0]["referencia"]);
	datosNodo[0]["descripcion"] = util.sqlSelect("articulos", "descripcion", "referencia = '" + referencia + "'");
	datosNodo[0]["cant"] = cursor.valueBuffer("canlote");
	datosNodo[0]["cost"] = "";
	if (hayLote) {
		datosNodo[0]["canr"] = "";
		datosNodo[0]["cosr"] = "";
		datosNodo[0]["cand"] = "";
		datosNodo[0]["cosd"] = "";
		datosNodo[0]["copd"] = "";
	}

	codFamilia = util.sqlSelect("articulos", "codfamilia", "referencia = '" + referencia + "'");
	if (codFamilia && codFamilia != "") {
		imagen = util.sqlSelect("familias","imagen","codfamilia = '" + codFamilia + "'");
	}
	datosNodo[0]["imagen"] = imagen;

	return datosNodo
}


function oficial_cambiarSeleccionNodo(item:FLListViewItem)
{
	this.iface.nodoSeleccionado = item;
}

function oficial_bufferChanged(campo:String)
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var codLote:String = cursor.valueBuffer("codlote");
	var hayLote:Boolean = (codLote && codLote != "");

	switch (campo) {
		case "totalteo":
		case "totalreal": {
			this.child("fdbTotalDif").setValue(this.iface.calculateField("totaldif"));
			this.child("fdbTotalPorDif").setValue(this.iface.calculateField("totalpordif"));
			break;
		}
		case "materialteo":
		case "materialreal": {
			this.child("fdbMaterialDif").setValue(this.iface.calculateField("materialdif"));
			this.child("fdbMaterialPorDif").setValue(this.iface.calculateField("materialpordif"));
			break;
		}
		case "maquinasteo":
		case "maquinasreal": {
			this.child("fdbMaquinasDif").setValue(this.iface.calculateField("maquinasdif"));
			this.child("fdbMaquinasPorDif").setValue(this.iface.calculateField("maquinaspordif"));
			break;
		}
		case "manoobrateo":
		case "manoobrareal": {
			this.child("fdbManoObraDif").setValue(this.iface.calculateField("manoobradif"));
			this.child("fdbManoObraPorDif").setValue(this.iface.calculateField("manoobrapordif"));
			break;
		}
		case "codlote": {
			this.child("fdbReferencia").setValue(this.iface.calculateField("referencia"));
			this.child("fdbCanLote").setValue(this.iface.calculateField("canlote"));
			this.iface.habilitarPorLote();
			break;
		}
	}
}

function oficial_habilitarPorLote()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var codLote:String = cursor.valueBuffer("codlote");
	var hayLote:Boolean = (codLote && codLote != "");

	if (hayLote) {
		this.child("fdbReferencia").setDisabled(true);
		this.child("fdbCanLote").setDisabled(true);
	} else {
		this.child("fdbReferencia").setDisabled(false);
		this.child("fdbCanLote").setDisabled(false);
	}
}


function oficial_commonCalculateField(fN:String, cursor:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil();
	var res:String;
	var codLote:String = cursor.valueBuffer("codlote");
	var hayLote:Boolean = (codLote && codLote != "");

	switch (fN) {
		case "totaldif": {
			if (hayLote) {
				res = parseFloat(cursor.valueBuffer("totalreal")) - parseFloat(cursor.valueBuffer("totalteo"));
				if (isNaN(res)) {
					res = 0;
				}
			} else {
				res = 0;
			}
			break;
		}
		case "totalpordif": {
			if (hayLote) {
				res = parseFloat(cursor.valueBuffer("totaldif")) * 100 / parseFloat(cursor.valueBuffer("totalteo"));
				if (isNaN(res)) {
					res = 0;
				}
				res = util.roundFieldValue(res, "pr_costeslote", "totalpordif");
			} else {
				res = 0;
			}
			break;
		}
		case "materialdif": {
			if (hayLote) {
				res = parseFloat(cursor.valueBuffer("materialreal")) - parseFloat(cursor.valueBuffer("materialteo"));
				if (isNaN(res)) {
					res = 0;
				}
			} else {
				res = 0;
			}
			break;
		}
		case "materialpordif": {
			if (hayLote) {
				res = parseFloat(cursor.valueBuffer("materialdif")) * 100 / parseFloat(cursor.valueBuffer("materialteo"));
				if (isNaN(res)) {
					res = 0;
				}
				res = util.roundFieldValue(res, "pr_costeslote", "materialpordif");
			} else {
				res = 0;
			}
			break;
		}
		case "maquinasdif": {
			if (hayLote) {
				res = parseFloat(cursor.valueBuffer("maquinasreal")) - parseFloat(cursor.valueBuffer("maquinasteo"));
				if (isNaN(res)) {
					res = 0;
				}
			} else {
				res = 0;
			}
			break;
		}
		case "maquinaspordif": {
			if (hayLote) {
				res = parseFloat(cursor.valueBuffer("maquinasdif")) * 100 / parseFloat(cursor.valueBuffer("maquinasteo"));
				if (isNaN(res)) {
					res = 0;
				}
				res = util.roundFieldValue(res, "pr_costeslote", "maquinaspordif");
			} else {
				res = 0;
			}
			break;
		}
		case "manoobradif": {
			if (hayLote) {
				res = parseFloat(cursor.valueBuffer("manoobrareal")) - parseFloat(cursor.valueBuffer("manoobrateo"));
				if (isNaN(res)) {
					res = 0;
				}
			} else {
				res = 0;
			}
			break;
		}
		case "manoobrapordif": {
			if (hayLote) {
				res = parseFloat(cursor.valueBuffer("manoobradif")) * 100 / parseFloat(cursor.valueBuffer("manoobrateo"));
				if (isNaN(res)) {
					res = 0;
				}
				res = util.roundFieldValue(res, "pr_costeslote", "manoobrapordif");
			} else {
				res = 0;
			}
			break;
		}
		case "totalteo": {
			res = parseFloat(cursor.valueBuffer("materialteo")) + parseFloat(cursor.valueBuffer("maquinasteo")) + parseFloat(cursor.valueBuffer("manoobrateo"));
			break;
		}
		case "totalreal": {
			res = parseFloat(cursor.valueBuffer("materialreal")) + parseFloat(cursor.valueBuffer("maquinasreal")) + parseFloat(cursor.valueBuffer("manoobrareal"));
			break;
		}
		case "totaldif": {
			if (hayLote) {
				res = parseFloat(cursor.valueBuffer("totalreal")) - parseFloat(cursor.valueBuffer("totalteo"));
				if (isNaN(res)) {
					res = 0;
				}
			} else {
				res = 0;
			}
			break;
		}
		case "totalpordif": {
			if (hayLote) {
				res = parseFloat(cursor.valueBuffer("totaldif")) * 100 / parseFloat(cursor.valueBuffer("totalteo"));
				if (isNaN(res)) {
					res = 0;
				}
				res = util.roundFieldValue(res, "pr_costeslote", "totalpordif");
			} else {
				res = 0;
			}
			break;
		}
		case "referencia": {
			res = util.sqlSelect("lotesstock", "referencia", "codlote = '" + codLote + "'");
			break;
		}
		case "canlote": {
			res = util.sqlSelect("lotesstock", "canlote", "codlote = '" + codLote + "'");
			break;
		}
	}
	return res;
}

function oficial_refrescarTotales()
{
	
}

function oficial_configurarArbol()
{
	var util:FLUtil = new FLUtil;

	this.iface.CA_REFE = 0;
	this.iface.CA_DESC = 1;
	this.iface.CA_CANT = 2;
	this.iface.CA_COST = 3;
	this.iface.CA_CANR = 4;
	this.iface.CA_COSR = 5;
	this.iface.CA_CAND = 6;
	this.iface.CA_COSD = 7;
	this.iface.CA_COPD = 8;
	this.iface.lvwDescomposicion.setColumnText(0, util.translate("scripts", "Referencia"));
	this.iface.lvwDescomposicion.addColumn(util.translate("scripts", "Descripción"));
	this.iface.lvwDescomposicion.addColumn(util.translate("scripts", "Can.T."));
	this.iface.lvwDescomposicion.addColumn(util.translate("scripts", "Coste T."));
	this.iface.lvwDescomposicion.addColumn(util.translate("scripts", "Can.R."));
	this.iface.lvwDescomposicion.addColumn(util.translate("scripts", "Coste R."));
	this.iface.lvwDescomposicion.addColumn(util.translate("scripts", "Can.D."));
	this.iface.lvwDescomposicion.addColumn(util.translate("scripts", "Dif."));
	this.iface.lvwDescomposicion.addColumn(util.translate("scripts", "% Dif."));
}

function oficial_filtrarTareasTrabajador()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var codLote:String = cursor.valueBuffer("codlote");
	var hayLote:Boolean = (codLote && codLote != "");

	var filtro:String;
	if (hayLote) {
		var referencia:String = cursor.valueBuffer("referencia");
		var idTipoProceso:String = util.sqlSelect("articulos", "idtipoproceso", "referencia = '" + referencia + "'");
		idProcesoLote = util.sqlSelect("pr_procesos", "idproceso", "idtipoproceso = '" + idTipoProceso + "' AND tipoobjeto = 'lotesstock' AND idobjeto = '" + codLote + "'");
		var idTipoTareaPro:String = this.child("tdbCosteTareaMO").cursor().valueBuffer("idtipotareapro");
		if (idTipoTareaPro && idProcesoLote) {
			filtro = "idtarea IN (SELECT idtarea FROM pr_tareas WHERE idproceso = " + idProcesoLote + " AND idtipotareapro = " + idTipoTareaPro + ")";
		} else {
			filtro = "1 = 2";
		}
	} else {
		filtro = "1 = 2";
	}
	this.child("tdbCosteTareaTrab").setFilter(filtro);
	this.child("tdbCosteTareaTrab").refresh();
}

function oficial_filtrarTareasCentro()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var codLote:String = cursor.valueBuffer("codlote");
	var hayLote:Boolean = (codLote && codLote != "");

	var filtro:String;
	var idCosteCentro:String = this.child("tdbCosteCentro").cursor().valueBuffer("idcostecentro");
	if (idCosteCentro && idCosteCentro) {
		filtro = "idcostecentro = " + idCosteCentro;
	} else {
		filtro = "1 = 2";
	}
debug("filtro = " + filtro);
	this.child("tdbCosteTarea").setFilter(filtro);
	this.child("tdbCosteTarea").refresh();
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
