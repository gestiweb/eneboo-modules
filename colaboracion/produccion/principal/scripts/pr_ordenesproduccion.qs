/***************************************************************************
         pr_ordenesproduccion.qs  -  description
                             -------------------
    begin                : jue may 17 2007
    copyright            : (C) 2007 by InfoSiAL S.L.
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
Cada orden de producción se genera mediante una búsqueda de los procesos de producción en estado OFF. El usuario puede decidir qué procesos incluir haciendo doble clic sobre la columna Incluir
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
	function init() {
		this.ctx.interna_init();
	}
	function calculateCounter():String {
		return this.ctx.interna_calculateCounter();
	}
	function validateForm():Boolean {
		return this.ctx.interna_validateForm();
	}
	function calculateField(fN:String):Number {
		return this.ctx.interna_calculateField(fN);
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var tblArticulos:Object;
	var tbnBuscar:Object;
	var tbnCalcular:Object;
	var tbnSubir:Object;
	var tbnBajar:Object;
	var tbnLanzarOrden:Object;
	var tbnSacarProceso:Object;
	var tbnEstadoAtras:Object;
	var tbnTerminarProceso:Object;
	
	var curLote_:FLSqlCursor;
	var estado_:String;

	var CODLOTE:Number;
	var REFERENCIA:Number;
	var TIPOPROCESO:Number;
	var PEDIDO:Number;
	var CLIENTE:Number;
	var TOTAL:Number;
	var FPRODUCCION:Number;
	var FSALIDA:Number;
	var ENSTOCK:Number;
	var INCLUIR:Number;
	var IDPROCESO:Number;
	var tbnEditarLote:Object;
    function oficial( context ) { interna( context ); }
	function bufferChanged(fN:String) {
		this.ctx.oficial_bufferChanged(fN);
	}
	function tbnEditarLote_clicked() {
		this.ctx.oficial_tbnEditarLote_clicked();
	}
	function tbnEstadoAtras_clicked() {
		this.ctx.oficial_tbnEstadoAtras_clicked();
	}
	function buscar() {
		this.ctx.oficial_buscar();
	}
	function otrosCriterios() {
		return this.ctx.oficial_otrosCriterios();
	}
	function refrescarTabla() {
		this.ctx.oficial_refrescarTabla();
	}
	function tblArticulos_doubleClicked(fila:Number, col:Number) {
		this.ctx.oficial_tblArticulos_doubleClicked(fila, col);
	}
	function establecerTablas() {
		this.ctx.oficial_establecerTablas();
	}
	function incluir():String {
		return this.ctx.oficial_incluir();
	}
	function sacarProceso() {
		this.ctx.oficial_sacarProceso();
	}
	function calcular() {
		return this.ctx.oficial_calcular();
	}
	function cargarDatos():Boolean {
		return this.ctx.oficial_cargarDatos();
	}
	function mostrarDatosTareas() {
		return this.ctx.oficial_mostrarDatosTareas();
	}
	function mostrarDatosCentros() {
		return this.ctx.oficial_mostrarDatosCentros();
	}
	function htmlCentroCoste(codCentro:String, minFecha:Date, maxFecha:Date):String {
		return this.ctx.oficial_htmlCentroCoste(codCentro, minFecha, maxFecha);
	}
	function subirPrioridad() {
		return this.ctx.oficial_subirPrioridad();
	}
	function bajarPrioridad() {
		return this.ctx.oficial_bajarPrioridad();
	}
	function cambiarDatosTabla(iFila1:Number, iFila2:Number) {
		return this.ctx.oficial_cambiarDatosTabla(iFila1, iFila2);
	}
	function lanzarOrdenClicked() {
		return this.ctx.oficial_lanzarOrdenClicked();
	}
	function lanzarOrden(mostrarProgreso:Boolean):Boolean {
		return this.ctx.oficial_lanzarOrden(mostrarProgreso);
	}
// 	function generarProcesoLote(codLote:String, referencia:String):Boolean {
// 		return this.ctx.oficial_generarProcesoLote(codLote, referencia);
// 	}
	function establecerEstadoBotones(estado:String) {
		return this.ctx.oficial_establecerEstadoBotones(estado);
	}
	function hayArticulosSinStock():Boolean {
		return this.ctx.oficial_hayArticulosSinStock();
	}
	function activarProcesoLote(codLote:String, idProceso:String):Boolean {
		return this.ctx.oficial_activarProcesoLote(codLote, idProceso);
	}
	function habilitarPestanas() {
		return this.ctx.oficial_habilitarPestanas();
	}
	function terminarProceso_clicked() {
		return this.ctx.oficial_terminarProceso_clicked();
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
	this.iface.tblArticulos = this.child("tblArticulos");
	
	//this.iface.tbnBuscarCliente = this.child("tbnBuscarCliente");
	this.iface.tbnBuscar = this.child("tbnBuscar");
	this.iface.tbnCalcular = this.child("tbnCalcular");
	this.iface.tbnSubir = this.child("tbnSubir");
	this.iface.tbnBajar = this.child("tbnBajar");
	this.iface.tbnLanzarOrden = this.child("tbnLanzarOrden");
	this.iface.tbnSacarProceso = this.child("tbnSacarProceso");
	this.iface.tbnEditarLote = this.child("tbnEditarLote");
	this.iface.tbnEstadoAtras = this.child("tbnEstadoAtras");

	//this.iface.tbnBuscarRuta = this.child("tbnBuscarRuta");
	
	this.child("tdbProcesos").setReadOnly(true);
	this.iface.establecerTablas()

	this.iface.tbnTerminarProceso = this.child("tbnTerminarProceso");
	connect(this.iface.tbnTerminarProceso, "clicked()", this, "iface.terminarProceso_clicked()");

	connect(this.iface.tbnBuscar, "clicked()", this, "iface.buscar");
	connect(this.iface.tbnCalcular, "clicked()", this, "iface.calcular");
	connect(this.iface.tbnSubir, "clicked()", this, "iface.subirPrioridad");
	connect(this.iface.tbnBajar, "clicked()", this, "iface.bajarPrioridad");
	connect(this.iface.tbnLanzarOrden, "clicked()", this, "iface.lanzarOrdenClicked");
	connect(this.iface.tbnSacarProceso, "clicked()", this, "iface.sacarProceso");
	connect(this.iface.tblArticulos, "doubleClicked(int, int)", this, "iface.tblArticulos_doubleClicked");
	connect(this.iface.tbnEditarLote, "clicked()", this, "iface.tbnEditarLote_clicked");
	connect(this.iface.tbnEstadoAtras, "clicked()", this, "iface.tbnEstadoAtras_clicked");
	

	/** \C
	La búsqueda de unidades puede realizarse por cliente o por ruta de reparto
	\end 
	connect(this.iface.tbnBuscarCliente, "clicked()", this, "iface.tbnBuscarCliente_clicked");
	*/
	var cursor:FLSqlCursor = this.cursor();
	
	if (cursor.modeAccess() == cursor.Insert) {
		/** \C
		El valor por defecto de la fecha de servicio será la fecha actual. Se buscarán los pedidos cuya fecha de producción sea anterior a la fecha de servicio.
		\end 
		var fechaActual:Date = new Date();
		this.child("dedFechaProduccion").date = fechaActual;
		*/
		this.child("fdbEstado").setValue("PTE");
		this.iface.habilitarPestanas()
		//this.child("tbwOrdenes").setTabEnabled("procesos", false);
	} else {
		/** \C
		Una vez aceptada la órden de producción, ésta no podrá ser modificada
		\end */
		this.iface.habilitarPestanas()
/*		
		var numUP:Number = this.iface.calculateField( "totallotes" );
		var util:FLUtil = new FLUtil;
		var terminados:Number = parseInt( util.sqlSelect( "pr_unidadesproducto", "count(*)", "idordenproduccion='" + cursor.valueBuffer( "idorden" ) + "' AND (estado='TERMINADO' OR estado='CARGADO')" ) );
		this.cursor().setValueBuffer( "totallotes",  numUP );
		this.child("ledTerminados").text = terminados;
		this.child("ledResto").text = numUP - terminados;
*/
	}
	
	flprodppal.iface.colorLote = ["#0000FF", "#FF0000", "#00FF00"];
	flprodppal.iface.iColorLote = 0;

	this.iface.establecerEstadoBotones("buscar");

	this.iface.curLote_ = new FLSqlCursor("lotesstock");
	connect (this.iface.curLote_, "bufferCommited()", this, "iface.refrescarTabla");
	connect (cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	this.iface.bufferChanged("codfamilia");
}

function interna_calculateCounter():String
{
	var util:FLUtil = new FLUtil();
	var cod:String = "OP00000001";
	var codUltima:String = util.sqlSelect("pr_ordenesproduccion", "codorden", "codorden LIKE 'OP%' ORDER BY codorden DESC");
	if (codUltima) {
		var numUltima:Number = parseFloat(codUltima.right(8));
		cod = "OP" + flfactppal.iface.pub_cerosIzquierda((++numUltima).toString(), 8);
	}
		
	return cod;
}

function interna_validateForm():Boolean
{

	/** \C El número de total d procesos incluidas en la orden de producto debe ser superior a 0
	\end */
	this.child("fdbTotalLotes").setValue(this.iface.calculateField("totallotes"));
	return true;
}

/** \C
Asocia las unidades de producto incluidas en la orden a la misma, cambiando su estado a EN PRODUCCION. Para cada unidad de producto se inicia un proceso de producción
\end */
	
// 	util.createProgressDialog(util.translate("scripts", "Generando procesos de producción"), totalFilas);
// 	util.setProgress(1);
// 	
// 	var idOrden:String = cursor.valueBuffer("idorden");
// 	cursor.commitBuffer();
// 	cursor.select("idorden = '" + idOrden + "'");
// 	cursor.first();
// 	cursor.setModeAccess(cursor.Edit);
// 	cursor.refreshBuffer();
// 
// 	for (var fila:Number = 0; fila < totalFilas; fila++) {
// 		var valor:String = this.iface.tblArticulos.text(fila, 8);
// 		var idUP:String = this.iface.tblArticulos.text(fila, 2);
// 		var idTipoProceso:String;
// 		if (valor == "Sí") {
// 			if (!util.sqlUpdate("pr_unidadesproducto", "idordenproduccion", idOrden,  "idunidad = '" + idUP + "'")) {
// 				util.destroyProgressDialog();
// 				return false;
// 			}
// 			idTipoProceso = util.sqlSelect("modulos m INNER JOIN pr_unidadesproducto up ON m.idmodulo = up.idmodulo", "m.idtipoproceso", "up.idunidad = '" + idUP + "'", "modulos,pr_unidadesproducto");
// 			if (!idTipoProceso)
// 				idTipoProceso = "PROD";
// 			if (!flprodproc.iface.pub_crearProceso(idTipoProceso, idUP)) {
// 				util.destroyProgressDialog();
// 				return false;
// 			}
// 		}
// 		util.setProgress(fila + 1);
// 	}
// 	
// 	util.setProgress(totalFilas);
// 	util.destroyProgressDialog();
// 	return true;
// }

function interna_calculateField(fN:String):Number
{
	var res:Number;
	switch(fN){
		case "totallotes": {
			/*U Número de totallotes a incluir en la orden de producción.
			\end */
			var cursor:FLSqlCursor = this.cursor();
			
			if ( cursor.modeAccess() == cursor.Insert ) {
				res = 0;
				var totalFilas:Number = this.iface.tblArticulos.numRows();
				for (var fila:Number = 0; fila < totalFilas; fila++) {
					if (this.iface.tblArticulos.text(fila, this.iface.INCLUIR) == "Sí") {
						res++;
					}
				}
			} else {
				var util:FLUtil = new FLUtil;
				res = parseInt( util.sqlSelect( "pr_procesos", "count(*)", "codordenproduccion='" + cursor.valueBuffer( "codorden" ) + "'" ) );
			}
			break;
		}
	}
	return res;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_bufferChanged(fN:String)
{
	var cursor:FLSqlCursor = this.cursor();
	switch (fN) {
	}
}

/** \D
Muestra el formulario de unidades de producto filtrado con las características de la unidad seleccionada
\end 
*/
function oficial_tbnEditarLote_clicked()
{
	var iFila:Number = this.iface.tblArticulos.currentRow();
	if (iFila < 0)
		return;

	var codLote:String = this.iface.tblArticulos.text(iFila, this.iface.CODLOTE);
	this.iface.curLote_.select("codlote = '" + codLote + "'");
	if (!this.iface.curLote_.first())
		return;

	
	this.iface.curLote_.editRecord();
}

function oficial_refrescarTabla()
{
// 	var util:FLUtil = new FLUtil;
// 	var iFila:Number = this.iface.tblArticulos.currentRow();
// 	if (iFila < 0)
// 		return;
// 
// 	var codLote:String = this.iface.tblArticulos.text(iFila, this.iface.CODLOTE);
// 	var fSalida:String = this.iface.tblArticulos.text(iFila, this.iface.FSALIDA);
// 	var cantidad:Number = util.sqlSelect("lotesstock", "canlote", "codlote = '" + codLote + "'");
// 	if (!cantidad || isNaN(cantidad))
// 		cantidad = 0;
// 	this.iface.tblArticulos.setText(iFila, this.iface.TOTAL, cantidad);
// 
// 	// Refrescar En Stock
// 	var idStock:Number = parseFloat(util.sqlSelect("movistock","idstock","codlote = '" + codLote + "'"));
// debug("stock " + idStock);
// debug("fSalida " + fSalida);
// 	var hoy:Date = new Date();
// 	var arrayEvolStock:Array = flfactalma.iface.pub_datosEvolStock(idStock,hoy.toString());
// 	var indice:Number = flfactalma.iface.pub_buscarIndiceAES("2007-07-26T00:00:00", arrayEvolStock);
// 	var enStock:String;
// 
// 	if (indice >= 0) {
// 		if (arrayEvolStock[indice]["NN"] > 0)
// 			enStock = "No";
// 		else
// 			enStock = "Si";
// 	}
// 	else 
// 			enStock = "No";
// 
// 	this.iface.tblArticulos.setText(filaActual, this.iface.ENSTOCK,enStock);
	
	this.iface.buscar();
}

/** \C
Muestra las unidades de producto que cumplen los criterios de búsqueda
\end */
function oficial_buscar()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var totalFilas:Number = this.iface.tblArticulos.numRows();
	var referencia:String = cursor.valueBuffer("referencia");
	var codFamilia:String = cursor.valueBuffer("codfamilia");
	var fechaDesde:Date;
	var fechaHasta:Date;
	var criteriosBusqueda:String =  "";

	if (!cursor.isNull("fechadesde")) {
		fechaDesde = cursor.valueBuffer("fechadesde");
		criteriosBusqueda += " AND ls.fechafabricacion >= '" + fechaDesde + "'";
	} else {
		fechaDesde = false;
	}

	if (!cursor.isNull("fechahasta")) {
		fechaHasta = cursor.valueBuffer("fechahasta");
		criteriosBusqueda += " AND ls.fechafabricacion <= '" + fechaHasta + "'";
	} else {
		fechaHasta = false;
	}

	if (referencia && referencia != "")
		criteriosBusqueda += " AND ls.referencia = '" + referencia + "'";
	if (codFamilia && codFamilia != "")
		criteriosBusqueda += " AND a.codfamilia = '" + codFamilia + "'";

	criteriosBusqueda += this.iface.otrosCriterios();
	var qryProcesos:FLSqlQuery = new FLSqlQuery();
	with(qryProcesos) {
		setTablesList("lotesstock,articulos,pr_procesos");
		setSelect("ls.codlote, ls.referencia, ls.canlote, ls.fechafabricacion, p.idproceso, p.idtipoproceso, pc.codigo, pc.codcliente, pc.nombrecliente");
		setFrom("lotesstock ls INNER JOIN articulos a ON a.referencia = ls.referencia INNER JOIN pr_procesos p ON ls.codlote = p.idobjeto LEFT OUTER JOIN lineaspedidoscli lpc ON lpc.idlinea = p.idlineapedidocli LEFT OUTER JOIN pedidoscli pc ON pc.idpedido = lpc.idpedido");
		setWhere("p.estado = 'OFF'" + criteriosBusqueda);
	}
	if (!qryProcesos.exec())
		return;


	if (qryProcesos.size() == 0) {
		MessageBox.information(util.translate("scripts", "No hay procesos de producción que cumplan los criterios establecidos"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	
// 	criteriosBusqueda = "";
// 	if (fechaDesde && fechaDesde != "")
// 		criteriosBusqueda = " AND p.fechasalida >= '" + fechaDesde + "'";
// 	if (fechaHasta && fechaHasta != "")
// 		criteriosBusqueda = " AND p.fechasalida <= '" + fechaHasta + "'";

	var fechaMinima:String = "";
	var fechaFabricacion:String = "";
	var fechaMinMov:String = "";
	var fechaMinComp:String = "";
	var codPedido:String = "";
	var nombreCliente:String = "";
	var idPedidoMov:Number;
	var idPedidoComp:Number;
	var datosPedidoComp:Array;
	var idTipoProceso:String;

	while (qryProcesos.next()) {
		idTipoProceso = qryProcesos.value("p.idtipoproceso");
		nombreCliente = qryProcesos.value("pc.nombrecliente");
		codPedido = qryProcesos.value("pc.codigo");

		//datosPedidoComp = flprodppal.iface.pub_buscarPedidoFechaMinima(qryProcesos.value("ls.codlote"),criteriosBusqueda);
		/// Outer Join con líneas de pedido en qry ppal
// 		fechaMinima = "";
// 		codPedido = "";
// 		nombreCliente = "";
// 		if (datosPedidoComp) {
// 			fechaMinima = datosPedidoComp["fecha"];
// 			codPedido = datosPedidoComp["codigo"];
// 			nombreCliente = datosPedidoComp["nombreCliente"];
// 		}
		
		var qryComponentes:FLSqlQuery = new FLSqlQuery();
		with (qryComponentes) {
			setTablesList("movistock,pr_tipostareapro");
			setSelect("ms.idstock, ms.fechaprev, ms.codlote, ttp.idtipoproceso");
			setFrom("movistock ms INNER JOIN pr_tipostareapro ttp ON ms.idtipotareapro = ttp.idtipotareapro");
			setWhere("ms.codloteprod = '" + qryProcesos.value("ls.codlote") + "' AND ms.cantidad < 0 AND ttp.idtipoproceso = '" + idTipoProceso + "'");
			setForwardOnly(true);
		}
		if (!qryComponentes.exec())
			return;
	
		var arrayEvolStock:Array;
		var hoy:Date = new Date();
		var indice:Number;
		var enStock:String = util.translate("scripts", "Sí");
		var codLote:String;

		var fechaConsumo:String;
		while (qryComponentes.next()) {
			codLote = qryComponentes.value("codlote");
			if (codLote && codLote != "") {
				if (util.sqlSelect("lotesstock", "estado", "codlote = '" + codLote + "'") == "TERMINADO") {
					continue;
				} else {
					enStock = util.translate("scripts", "No");
					break;
				}
			}

			arrayEvolStock = flfactalma.iface.pub_datosEvolStock(qryComponentes.value("idstock"), hoy.toString());
			if (qryComponentes.value("fechaprev")) {
				fechaConsumo = qryComponentes.value("fechaprev");
			} else {
				fechaConsumo = hoy.toString();
			}
			indice = flfactalma.iface.pub_buscarIndiceAES(fechaConsumo, arrayEvolStock);
			if (indice >= 0) {
				if (arrayEvolStock[indice]["NN"] > 0) {
					enStock = util.translate("scripts", "No");
					break;
				}
			} else {
				enStock = util.translate("scripts", "No");
				break;
			}
		}
		filaActual = this.iface.tblArticulos.numRows();

		fechaFabricacion = qryProcesos.value("ls.fechafabricacion");
		this.iface.tblArticulos.insertRows(filaActual);
		this.iface.tblArticulos.setText(filaActual, this.iface.CODLOTE, qryProcesos.value("ls.codlote"));
		this.iface.tblArticulos.setText(filaActual, this.iface.REFERENCIA, qryProcesos.value("ls.referencia"));
		this.iface.tblArticulos.setText(filaActual, this.iface.TIPOPROCESO, idTipoProceso);
		this.iface.tblArticulos.setText(filaActual, this.iface.PEDIDO, codPedido);
		this.iface.tblArticulos.setText(filaActual, this.iface.CLIENTE, nombreCliente);
		this.iface.tblArticulos.setText(filaActual, this.iface.TOTAL, qryProcesos.value("ls.canlote"));
		this.iface.tblArticulos.setText(filaActual, this.iface.FPRODUCCION, util.dateAMDtoDMA(fechaFabricacion));
		this.iface.tblArticulos.setText(filaActual, this.iface.FSALIDA, util.dateAMDtoDMA(fechaMinima));
		this.iface.tblArticulos.setText(filaActual, this.iface.ENSTOCK, enStock);
		this.iface.tblArticulos.setText(filaActual, this.iface.INCLUIR, this.iface.incluir());
		this.iface.tblArticulos.setText(filaActual, this.iface.IDPROCESO, qryProcesos.value("p.idproceso"));
	}

	this.child("fdbTotalLotes").setValue(this.iface.calculateField("totallotes"));
	if (this.iface.tblArticulos.numRows() > 0)
		this.iface.establecerEstadoBotones("calcular");
	else
		MessageBox.information(util.translate("scripts", "No hay procesos de producción que cumplan los criterios establecidos"), MessageBox.Ok, MessageBox.NoButton);

}
// function oficial_buscar()
// {
// 	var util:FLUtil = new FLUtil();
// 	var cursor:FLSqlCursor = this.cursor();
// 
// 	var totalFilas:Number = this.iface.tblArticulos.numRows();
// 	var referencia:String = cursor.valueBuffer("referencia");
// 	var codFamilia:String = cursor.valueBuffer("codfamilia");
// 	var fechaDesde:Date;
// 	var fechaHasta:Date;
// 	var criteriosBusqueda:String =  "";
// 
// 	if (!cursor.isNull("fechadesde")) {
// 		fechaDesde = cursor.valueBuffer("fechadesde");
// 		criteriosBusqueda += " AND ls.fechafabricacion >= '" + fechaDesde + "'";
// 	} else {
// 		fechaDesde = false;
// 	}
// 
// 	if (!cursor.isNull("fechahasta")) {
// 		fechaHasta = cursor.valueBuffer("fechahasta");
// 		criteriosBusqueda += " AND ls.fechafabricacion <= '" + fechaHasta + "'";
// 	} else {
// 		fechaHasta = false;
// 	}
// 
// 	if (referencia && referencia != "")
// 		criteriosBusqueda += " AND ls.referencia = '" + referencia + "'";
// 	if (codFamilia && codFamilia != "")
// 		criteriosBusqueda += " AND a.codfamilia = '" + codFamilia + "'";
// 
// 	criteriosBusqueda += this.iface.otrosCriterios();
// 	var qryProcesos:FLSqlQuery = new FLSqlQuery();
// 	with(qryProcesos) {
// 		setTablesList("lotesstock,articulos");
// 		setSelect("ls.codlote, ls.referencia, ls.canlote, ls.fechafabricacion");
// 		setFrom("lotesstock ls INNER JOIN articulos a ON a.referencia = ls.referencia");
// 		setWhere("ls.estado = 'PTE' AND (ls.codordenproduccion IS NULL OR ls.codordenproduccion = '') AND a.fabricado" + criteriosBusqueda);
// 	}
// 	if (!qryProcesos.exec())
// 		return;
// 
// 
// 	if (qryProcesos.size() == 0) {
// 		MessageBox.information(util.translate("scripts", "No hay lotes de producto que cumplan los criterios establecidos"), MessageBox.Ok, MessageBox.NoButton);
// 		return;
// 	}
// 	
// 	criteriosBusqueda = "";
// 	if (fechaDesde && fechaDesde != "")
// 		criteriosBusqueda = " AND p.fechasalida >= '" + fechaDesde + "'";
// 	if (fechaHasta && fechaHasta != "")
// 		criteriosBusqueda = " AND p.fechasalida <= '" + fechaHasta + "'";
// 
// 	var fechaMinima:String = "";
// 	var fechaFabricacion:String = "";
// 	var fechaMinMov:String = "";
// 	var fechaMinComp:String = "";
// 	var codPedido:String = "";
// 	var nombreCliente:String = "";
// 	var idPedidoMov:Number;
// 	var idPedidoComp:Number;
// 	var datosPedidoComp:Array;
// 
// 	while (qryProcesos.next()) {
// 		datosPedidoComp = flprodppal.iface.pub_buscarPedidoFechaMinima(qryProcesos.value("ls.codlote"),criteriosBusqueda);
// 
// 		fechaMinima = "";
// 		codPedido = "";
// 		nombreCliente = "";
// 		if (datosPedidoComp) {
// 			fechaMinima = datosPedidoComp["fecha"];
// 			codPedido = datosPedidoComp["codigo"];
// 			nombreCliente = datosPedidoComp["nombreCliente"];
// 		}
// 		
// 		var qryComponentes:FLSqlQuery = new FLSqlQuery();
// 		with (qryComponentes) {
// 			setTablesList("movistock");
// 			setSelect("idstock, fechaprev, codlote");
// 			setFrom("movistock");
// 			setWhere("codloteprod = '" + qryProcesos.value("ls.codlote") + "' AND cantidad < 0");
// 			setForwardOnly(true);
// 		}
// 		if (!qryComponentes.exec())
// 			return;
// 	
// 		var arrayEvolStock:Array;
// 		var hoy:Date = new Date();
// 		var indice:Number;
// 		var enStock:String = util.translate("scripts", "Sí");
// 		var codLote:String;
// 		while (qryComponentes.next()) {
// 			codLote = qryComponentes.value("codlote");
// 			if (codLote && codLote != "") {
// 				if (util.sqlSelect("lotesstock", "estado", "codlote = '" + codLote + "'") == "TERMINADO") {
// 					continue;
// 				} else {
// 					enStock = util.translate("scripts", "No");
// 					break;
// 				}
// 			}
// 
// 			arrayEvolStock = flfactalma.iface.pub_datosEvolStock(qryComponentes.value("idstock"), hoy.toString());
// 			indice = flfactalma.iface.pub_buscarIndiceAES(qryComponentes.value("fechaprev"), arrayEvolStock);
// 	
// 			if (indice >= 0) {
// 				if (arrayEvolStock[indice]["NN"] > 0) {
// 					enStock = util.translate("scripts", "No");
// 					break;
// 				}
// 			} else {
// 				enStock = util.translate("scripts", "No");
// 				break;
// 			}
// 		}
// 
// 		filaActual = this.iface.tblArticulos.numRows();
// 
// 		fechaFabricacion = qryProcesos.value("ls.fechafabricacion");
// 		this.iface.tblArticulos.insertRows(filaActual);
// 		this.iface.tblArticulos.setText(filaActual, this.iface.CODLOTE, qryProcesos.value("ls.codlote"));
// 		this.iface.tblArticulos.setText(filaActual, this.iface.REFERENCIA, qryProcesos.value("ls.referencia"));
// 		this.iface.tblArticulos.setText(filaActual, this.iface.PEDIDO, codPedido);
// 		this.iface.tblArticulos.setText(filaActual, this.iface.CLIENTE, nombreCliente);
// 		this.iface.tblArticulos.setText(filaActual, this.iface.TOTAL, qryProcesos.value("ls.canlote"));
// 		this.iface.tblArticulos.setText(filaActual, this.iface.FPRODUCCION, util.dateAMDtoDMA(fechaFabricacion));
// 		this.iface.tblArticulos.setText(filaActual, this.iface.FSALIDA, util.dateAMDtoDMA(fechaMinima));
// 		this.iface.tblArticulos.setText(filaActual, this.iface.ENSTOCK,enStock);
// 		this.iface.tblArticulos.setText(filaActual, this.iface.INCLUIR, this.iface.incluir());
// 		
// 	}
// 
// 	this.child("fdbTotalLotes").setValue(this.iface.calculateField("totallotes"));
// 	if (this.iface.tblArticulos.numRows() > 0)
// 		this.iface.establecerEstadoBotones("calcular");
// 	else
// 		MessageBox.information(util.translate("scripts", "No hay lotes de producto que cumplan los criterios establecidos"), MessageBox.Ok, MessageBox.NoButton);
// 
// }

function oficial_incluir():String
{
	return "Sí";
}

function oficial_otrosCriterios()
{
	return "";
}


/** \D
Realiza la selección de un cliente mediante un formulario de búsqueda
\end 
function oficial_tbnBuscarCliente_clicked()
{
	var f:Object = new FLFormSearchDB("clientes");
	f.setMainWidget();
	var codCliente:String = f.exec("codcliente");
	if (codCliente) {
		this.child("ledCliente").text = codCliente;
	}
}
*/

/** \D
Pasa de Sí a No o viceversa el valor de la columna 'Cargar' de la tabla de unidades
@param	fila: Fila sobre la que se ha hecho doble clic
@param	col: Columna sobre la que se ha hecho doble clic
\end */
function oficial_tblArticulos_doubleClicked(fila:Number, col:Number)
{
	var idUP:String;
	if (col == this.iface.INCLUIR) {
		if (this.iface.tblArticulos.text(fila, this.iface.INCLUIR) == "Sí") {
			this.iface.tblArticulos.setText(fila, this.iface.INCLUIR, "No");
		} else if (this.iface.tblArticulos.text(fila, this.iface.INCLUIR) == "No") {
			this.iface.tblArticulos.setText(fila, this.iface.INCLUIR, "Sí");
		}
		this.child("fdbTotalLotes").setValue(this.iface.calculateField("totallotes"));
		this.iface.establecerEstadoBotones("calcular");
	}
}

function oficial_establecerTablas()
{
	this.iface.CODLOTE = 0;
	this.iface.REFERENCIA = 1;
	this.iface.TIPOPROCESO = 2;
	this.iface.PEDIDO = 3;
	this.iface.CLIENTE = 4;
	this.iface.TOTAL = 5;
	this.iface.FPRODUCCION = 6;
	this.iface.FSALIDA = 7;
	this.iface.ENSTOCK = 8;
	this.iface.INCLUIR = 9;
	this.iface.IDPROCESO = 10;

	this.iface.tblArticulos.setNumCols(11);
	this.iface.tblArticulos.setColumnWidth(this.iface.CODLOTE, 100);
	this.iface.tblArticulos.setColumnWidth(this.iface.REFERENCIA, 120);
	this.iface.tblArticulos.setColumnWidth(this.iface.TIPOPROCESO, 100);
	this.iface.tblArticulos.setColumnWidth(this.iface.PEDIDO, 120);
	this.iface.tblArticulos.setColumnWidth(this.iface.CLIENTE, 200);
	this.iface.tblArticulos.setColumnWidth(this.iface.TOTAL, 80);
	this.iface.tblArticulos.setColumnWidth(this.iface.FSALIDA, 90);
	this.iface.tblArticulos.setColumnWidth(this.iface.FPRODUCCION, 90);
	this.iface.tblArticulos.setColumnWidth(this.iface.ENSTOCK, 70);
	this.iface.tblArticulos.setColumnWidth(this.iface.INCLUIR, 70);
	this.iface.tblArticulos.setColumnWidth(this.iface.IDPROCESO, 70);
	//this.iface.tblArticulos.hideColumn(this.iface.IDPROCESO);
	
	this.iface.tblArticulos.setColumnLabels("/", "Lote/Referencia/Proceso/Pedido/Cliente/Total/F.Producción/F.Salida/En Stock/Incluir/Proceso");
}

/** \D Saca el lote de producto seleccionado de la orden. El lote de producto debe estar en estado PTE
*/
function oficial_sacarProceso()
{
	var util:FLUtil = new FLUtil();

	var curProceso:FLSqlCursor = this.child("tdbProcesos").cursor();
	var idProceso:String = curProceso.valueBuffer("idproceso");

	var res:Number = MessageBox.warning(util.translate("scripts", "¿Desea sacar el proceso %1 de la orden?").arg(idProceso), MessageBox.Yes, MessageBox.No);
	if (res != MessageBox.Yes) {
		return;
	}

	if (!formpr_ordenesproduccion.iface.pub_sacarProceso(idProceso)) {
		return false;
	}
	
	this.child("tdbProcesos").refresh();
	this.iface.habilitarPestanas();
// 	curProceso.refresh();
// 	if (!curProceso.size()) {
// 		this.child("tbwOrdenes").setTabEnabled("procesos", false);
// 		this.child("tbwOrdenes").setTabEnabled("buscar", true);
// 		this.child("tbwOrdenes").currentPage = 0;
// 	}
}

function oficial_calcular()
{
	if (!this.iface.hayArticulosSinStock())
		return false;

	flprodppal.iface.pub_limpiarMemoria();

	if (!this.iface.cargarDatos())
		return false;

	if (!flprodppal.iface.pub_aplicarAlgoritmo("FIFO"))
		return false;

	this.child("fdbPlanificacion").setValue(flprodppal.iface.htmlPlanificacion());
// 	this.iface.mostrarDatosTareas();
	/*
	if (!this.iface.mostrarCalculo())
		return false;
	*/
	this.iface.establecerEstadoBotones("lanzar");
	return true;
}

function oficial_hayArticulosSinStock():Boolean
{	
	var util:FLUtil;

	for (var fila:Number = 0; fila < this.iface.tblArticulos.numRows(); fila++) {
		if (this.iface.tblArticulos.text(fila, this.iface.INCLUIR) == "Sí") {
			if (this.iface.tblArticulos.text(fila, this.iface.ENSTOCK) == "No") {
				var res:Number = MessageBox.warning(util.translate("scripts", "Hay procesos para los que no hay stock de componentes suficiente. ¿Desea continuar?"), MessageBox.Yes, MessageBox.No);
				if (res != MessageBox.Yes)
					return false;
				else
					return true;
			}
			
		}
	}
	return true;
}

// function oficial_aplicarAlgoritmo(algoritmo:String):Boolean
// {
// 	switch (algoritmo) {
// 		case "FIFO": {
// 			if (!this.iface.aplicarAlgoritmoFIFO())
// 				return false;
// 			break;
// 		}
// 	}
// 	return true;
// }
// 
// function oficial_aplicarAlgoritmoFIFO():Boolean
// {
// 	for (var iTarea:Number = 0; iTarea < this.iface.tareaMemo.length; iTarea++) {
// 		if (!this.iface.asignarTareaFIFO(iTarea))
// 			return false;
// 	}
// 	return true;
// }
// 
// function oficial_asignarTareaFIFO(iTarea:Number):Boolean
// {
// 	if (this.iface.tareaMemo[iTarea]["asignada"])
// 		return true;
// 
// 	var totalPredecesoras:Number = this.iface.tareaMemo[iTarea]["predecesora"].length;
// 	for (var iPredecesora:Number = 0; iPredecesora < totalPredecesoras; iPredecesora++) {
// 		if (!this.iface.asignarTareaFIFO(this.iface.tareaMemo[iTarea]["predecesora"][iPredecesora]))
// 			return false;
// 	}
// 	if (!this.iface.asignarCentroCosteTarea(iTarea))
// 		return false;
// 
// 	return true;
// }

/** \D Obtiene la fecha mínima de comienzo de una tarea en función de la máxima fecha de finalización de sus tareas predecesoras
@param iTarea: Indice de la tarea
@return	fecha mínima de inicio
|end */
// function oficial_fechaMinimaTarea(iTarea:Number):Date
// {
// 	var fechaMin:Date = false;
// 	var totalPredecesoras:Number = this.iface.tareaMemo[iTarea]["predecesora"].length;
// 	var iTP:Number;
// 	for (var iPredecesora:Number = 0; iPredecesora < totalPredecesoras; iPredecesora++) {
// 		iTP = this.iface.tareaMemo[iTarea]["predecesora"][iPredecesora];
// 		if (!fechaMin) {
// 			fechaMin = this.iface.tareaMemo[iTP]["fechafin"];
// 		} else {
// 			if (this.iface.compararFechas(this.iface.tareaMemo[iTP]["fechafin"], fechaMin) == 1) {
// 				fechaMin = this.iface.tareaMemo[iTP]["fechafin"];
// 			}
// 		}
// 	}
// 	return fechaMin;
// }

// function oficial_asignarCentroCosteTarea(iTarea:Number):Boolean
// {
// 	var util:FLUtil = new FLUtil;
// 	var codLote:String = this.iface.tareaMemo[iTarea]["codlote"];
// 	var iLote:Number;
// 	iLote = this.iface.buscarLote(codLote);
// 	if (iLote < 0) {
// 		MessageBox.warning(util.translate("scripts", "Error al buscar los datos del lote %1").arg(codLote), MessageBox.Ok, MessageBox.NoButton);
// 		return false;
// 	}
// 	var referencia:String = this.iface.loteMemo[iLote]["referencia"];
// 
// 	var fechaMinTarea:Date = this.iface.fechaMinimaTarea(iTarea);
// 
// 	var idTipoTareaPro:String = this.iface.tareaMemo[iTarea]["idtipotareapro"];
// 	var qryCentros:FLSqlQuery = new FLSqlQuery;
// 	with (qryCentros) {
// 		setTablesList("pr_costestarea,pr_centroscoste");
// 		setSelect("cc.codcentro, ct.codtipocentro");
// 		setFrom("pr_costestarea ct INNER JOIN pr_centroscoste cc ON ct.codtipocentro = cc.codtipocentro");
// 		setWhere("ct.idtipotareapro = " + idTipoTareaPro);
// 		setForwardOnly(true);
// 	}
// // debug(qryCentros.sql());
// 	if (!qryCentros.exec()) {
// 		return false;
// 	}
// 
// 	var minFechaInicio:Date = false;
// 	var minFechaFin:Date = false;
// 	var minICentro:Number = -1;
// 	var minTiempo:Number;
// 
// 	var fechaFin:Date;
// 	var fechaInicio:Date;
// 	var minCentro:String;
// 	var iCentro:Number;
// 	var dia:Date;
// 	var tiempo:Number;
// 	var costeFijo:Number;
// 	var costeUnidad:Number;
// 	var codCentro:String;
// 	var qryCostes:FLSqlQuery = new FLSqlQuery;
// 	qryCostes.setTablesList("pr_costestarea");
// 	qryCostes.setSelect("costeinicial,costeunidad");
// 	qryCostes.setFrom("pr_costestarea");
// 	qryCostes.setForwardOnly(true);
// 
// 	while (qryCentros.next()) {
// 		qryCostes.setWhere("codtipocentro = '" + qryCentros.value("ct.codtipocentro") + "' AND referencia = '" + referencia + "'");
// 
// 		if (!qryCostes.exec())
// 			return false;
// 
// 		if (!qryCostes.first()) {
// 			qryCostes.setWhere("codtipocentro = '" + qryCentros.value("ct.codtipocentro") + "' AND referencia IS NULL");
// 			if (!qryCostes.exec())
// 				return false;
// 
// 			if (!qryCostes.first()) {
// 				continue;
// 			}
// 		}
// 
// 		costeFijo = parseFloat(qryCostes.value("costeinicial"));
// 		if (!costeFijo || isNaN(costeFijo))
// 			costeFijo = 0;
// 
// 		costeUnidad = parseFloat(qryCostes.value("costeunidad"));
// 		if (!costeUnidad || isNaN(costeUnidad))
// 			costeUnidad = 0;
// 
// 		codCentro = qryCentros.value("cc.codcentro");
// //  debug("Cod Centro = " + codCentro);
// 		iCentro = this.iface.buscarCentroCoste(codCentro);
// //  debug("Id Centro = " + iCentro);
// 
// 		if (iCentro < 0) {
// 			MessageBox.warning(util.translate("scripts", "Error al buscar los datos del centro de coste %1").arg(codCentro), MessageBox.Ok, MessageBox.NoButton);
// 			return false;
// 		}
// 
// 		tiempo = costeFijo + (costeUnidad * this.iface.loteMemo[iLote]["cantidad"]);
// 		tiempo = this.iface.convetirTiempoMS(tiempo, codCentro);
// 
// 		if (fechaMinTarea && this.iface.compararFechas(fechaMinTarea, this.iface.centroMemo[iCentro]["fechainicio"]) == 1)
// 			fechaInicio = fechaMinTarea;
// 		else
// 			fechaInicio = this.iface.centroMemo[iCentro]["fechainicio"];
// // debug(fechaMinTarea);
// // debug(this.iface.centroMemo[iCentro]["fechainicio"]);
// // debug(fechaInicio);
// 		if (!util.sqlSelect("pr_calendario","fecha","1 = 1")) {
// 			MessageBox.warning(util.translate("scripts", "Antes de calcular el tiempo de finalización de la tarea debe generar el calendario laboral."), MessageBox.Ok, MessageBox.NoButton);
// 			return false;
// 		}
// 
// 		fechaFin = this.iface.sumarTiempo(fechaInicio, tiempo, codCentro);
// 		if (!fechaFin)
// 			return false;
// 		if (minFechaFin && this.iface.compararFechas(minFechaFin, fechaFin) == 2)
// 			continue;
// 		minFechaInicio = fechaInicio;
// 		minFechaFin = fechaFin;
// 		minCodCentro = codCentro;
// 		minTiempo = tiempo;
// 		minICentro = iCentro;
// 	}
// 	if (minICentro < 0) {
// 		MessageBox.warning(util.translate("scripts", "No se ha podido asignar centro de coste a la tarea:\n%1\nAsociada al lote %2").arg(this.iface.datosTarea(idTipoTareaPro)).arg(codLote), MessageBox.Ok, MessageBox.NoButton);
// 		return false;
// 	}
// 	this.iface.tareaMemo[iTarea]["codcentrocoste"] = minCodCentro;
// 	this.iface.tareaMemo[iTarea]["fechainicio"] = minFechaInicio;
// 	this.iface.tareaMemo[iTarea]["fechafin"] = minFechaFin;
// // debug("FF = " + this.iface.tareaMemo[iTarea]["fechafin"]);
// 	this.iface.tareaMemo[iTarea]["duracion"] = minTiempo;
// 	this.iface.tareaMemo[iTarea]["asignada"] = true;
// 	this.iface.centroMemo[minICentro]["fechainicio"] = minFechaFin;
// 
// 	return true;
// }

/** \D Pasa el tiempo a milisegundos. Función a sobrecargar para calcular los milisegundos en función de la unidad en la que trabaja cada centro de coste. Por defecto, se convierte de minutos a milisegundos
@param	tiempo: Tiempo en minutos
@param	codCentro: Código de centro
@return	Tiempo en milisegundos
\end */
// function oficial_convetirTiempoMS(tiempo:Number, codCentro:String):Number
// {
// 	var resultado:Number;
// 	resultado = tiempo * 60000;
// 	return resultado;
// }

/** \D Suma el tiempo en milisegundos a una fecha, teniendo en cuena el horario del centro de coste
@param	fechaInicio: Fecha inicial
@param	tiempo: Tiempo en ms
@param	codCentro: Código de centro
@return	Fecha final
\end */
// function oficial_sumarTiempo(fecha:Date, tiempo:Number, codCentro:String):Date
// {
// 	var tiempoInicio:Number = fecha.getTime(); //Date.parse(fecha);
// 
// 	var fechaFin:Date = this.iface.buscarSiguienteTiempoFin(fecha);
// 	if (!fechaFin)
// 		return false;
// 	var tiempoFin:Number = fechaFin.getTime();
// 
// 	var tiempoAux:Number = tiempoFin - tiempoInicio;
// 
// 	if (tiempoAux >= tiempo) {
// 		tiempoFin = tiempoInicio + tiempo;
// 		fechaFin = new Date(tiempoFin);
// 		return fechaFin;
// 	}
// 	
// 	tiempo = tiempo - tiempoAux;
// 
// 	var fechaInicio:Date = this.iface.buscarSiguienteTiempoInicio(fechaFin);
// 	if (!fechaInicio)
// 		return false;
// 	return this.iface.sumarTiempo(fechaInicio,tiempo,codCentro);
// 	
// // 	var fecha:Date = new Date(tiempoFin);
// // 	return fecha;
// }

// function oficial_buscarSiguienteTiempoFin(fecha):Date
// {
// 	var util:FLUtil;
// 
// 	var d:Date = new Date( fecha.getYear(), fecha.getMonth(), fecha.getDate());
// 	var tiempoFinManana:Date = util.sqlSelect("pr_calendario","horasalidamanana","fecha = '" + d + "'");
// 	if (!tiempoFinManana) {
// 		MessageBox.warning(util.translate("scripts", "No hay definido ningún registro en el calendario para el día %1").arg(util.dateAMDtoDMA(d)), MessageBox.Ok, MessageBox.NoButton);
// 		return false;
// 	}
// 	tiempoFinManana = tiempoFinManana.setYear(d.getYear());
// 	tiempoFinManana = tiempoFinManana.setMonth(d.getMonth());
// 	tiempoFinManana = tiempoFinManana.setDate(d.getDate());
// 	
// 	var comparar:Number = flprodppal.iface.compararHoras(fecha,tiempoFinManana);
// 	if (comparar == 2){
// 		return tiempoFinManana;
// 	}
// 
// 	var tiempoFinTarde:Date = util.sqlSelect("pr_calendario","horasalidatarde","fecha = '" + d + "'");
// 	tiempoFinTarde = tiempoFinTarde.setYear(d.getYear());
// 	tiempoFinTarde = tiempoFinTarde.setMonth(d.getMonth());
// 	tiempoFinTarde = tiempoFinTarde.setDate(d.getDate());	
// 
// 	comparar = flprodppal.iface.compararHoras(fecha,tiempoFinTarde);
// 	if (comparar == 2){
// 		return tiempoFinTarde;
// 	}
// 
// 	var fecha2:Date = new Date(fecha.getYear(), fecha.getMonth(), fecha.getDate());
// 
// 	var qry:FLSqlQuery = new FLSqlQuery();
// 	qry.setTablesList("pr_calendario");
// 	qry.setSelect("horasalidamanana,horasalidatarde");
// 	qry.setFrom("pr_calendario")
// 	
// 	do {
// 		fecha2 = util.addDays(fecha2,1);
// 		var fechaAux:Date = new Date(fecha2.getYear(), fecha2.getMonth(), fecha2.getDate());
// 
// 		qry.setWhere("fecha = '" + fechaAux + "'");
// 	
// 		if (!qry.exec())
// 			return false;
// 
// 		if (!qry.first()) {
// 			MessageBox.warning(util.translate("scripts", "No se ha encontrado un registro para el día %1 en el Calendario Laboral").arg(util.dateAMDtoDMA(fechaAux)), MessageBox.Ok, MessageBox.NoButton);
// 			return false;
// 		}
// 
// 		fecha2 = qry.value("horasalidamanana");
// 		fecha2 = fecha2.setYear(fechaAux.getYear());
// 		fecha2 = fecha2.setMonth(fechaAux.getMonth());
// 		fecha2 = fecha2.setDate(fechaAux.getDate());
// 	
// 		if (!fecha2) {
// 			fecha2 = qry.value("horasalidatarde");
// 			fecha2 = fecha2.setYear(fechaAux.getYear());
// 			fecha2 = fecha2.setMonth(fechaAux.getMonth());
// 			fecha2 = fecha2.setDate(fechaAux.getDate());
// 		}
// 
// 	} while (!fecha2);
// 
// 	return fecha2;
// }

// function oficial_buscarSiguienteTiempoInicio(fecha):Date
// {
// 	var util:FLUtil;
// 	var d:Date = new Date( fecha.getYear(), fecha.getMonth(), fecha.getDate());
// 	if (!tiempoFinManana) {
// 		MessageBox.warning(util.translate("scripts", "No hay definido ningún registro en el calendario para el día %1").arg(util.dateAMDtoDMA(d)), MessageBox.Ok, MessageBox.NoButton);
// 		return false;
// 	}
// 	var tiempoInicioManana:Date = util.sqlSelect("pr_calendario","horaentradamanana","fecha = '" + d + "'");
// 	tiempoInicioManana = tiempoInicioManana.setYear(d.getYear());
// 	tiempoInicioManana = tiempoInicioManana.setMonth(d.getMonth());
// 	tiempoInicioManana = tiempoInicioManana.setDate(d.getDate());
// 	
// 	var comparar:Number = flprodppal.iface.compararHoras(fecha,tiempoInicioManana);
// 	if (comparar == 2){
// 		return tiempoInicioManana;
// 	}
// 
// 	var tiempoInicioTarde:Date = util.sqlSelect("pr_calendario","horaentradatarde","fecha = '" + d + "'");
// 	tiempoInicioTarde = tiempoInicioTarde.setYear(d.getYear());
// 	tiempoInicioTarde = tiempoInicioTarde.setMonth(d.getMonth());
// 	tiempoInicioTarde = tiempoInicioTarde.setDate(d.getDate());	
// 
// 	comparar = flprodppal.iface.compararHoras(fecha,tiempoInicioTarde);
// 	if (comparar == 2){
// 		return tiempoInicioTarde;
// 	}
// 
// 	var fecha2:Date = new Date(fecha.getYear(), fecha.getMonth(), fecha.getDate());
// 
// 	var qry:FLSqlQuery = new FLSqlQuery();
// 	qry.setTablesList("pr_calendario");
// 	qry.setSelect("horaentradamanana,horaentradatarde");
// 	qry.setFrom("pr_calendario")
// 	
// 	do {
// 		fecha2 = util.addDays(fecha2,1);
// 		var fechaAux:Date = new Date(fecha2.getYear(), fecha2.getMonth(), fecha2.getDate());
// 
// 		qry.setWhere("fecha = '" + fechaAux + "'");
// 	
// 		if (!qry.exec())
// 			return false;
// 
// 		if (!qry.first()) {
// 			MessageBox.warning(util.translate("scripts", "No se ha encontrado un registro para el día %1 en el Calendario Laboral").arg(util.dateAMDtoDMA(fechaAux)), MessageBox.Ok, MessageBox.NoButton);
// 			return false;
// 		}
// 
// 		fecha2 = qry.value("horaentradamanana");
// 		fecha2 = fecha2.setYear(fechaAux.getYear());
// 		fecha2 = fecha2.setMonth(fechaAux.getMonth());
// 		fecha2 = fecha2.setDate(fechaAux.getDate());
// 	
// 		if (!fecha2) {
// 			fecha2 = qry.value("horaentradatarde");
// 			fecha2 = fecha2.setYear(fechaAux.getYear());
// 			fecha2 = fecha2.setMonth(fechaAux.getMonth());
// 			fecha2 = fecha2.setDate(fechaAux.getDate());
// 		}
// 
// 	} while (!fecha2);
// 
// 	return fecha2;
// }

/** \D Compara dos fechs
@param	fecha1: Fecha 
@param	fecha2: Fecha 
@return	0 Si son iguales, 1 si la primera es mayor, 2 si la segunda es mayor
\end */
// function oficial_compararFechas(fecha1:Date, fecha2:Date):Number
// {
// 	if (fecha1.getTime() > fecha2.getTime())
// 		return 1;
// 	else if (fecha2.getTime() > fecha1.getTime())
// 		return 2;
// 	else 
// 		return 0;
// }

function oficial_cargarDatos():Boolean
{
	var util:FLUtil = new FLUtil;
	var datosLote:Array = [];
	var seleccionados:Number = 0;
	for (var fila:Number = 0; fila < this.iface.tblArticulos.numRows(); fila++) {
		if (this.iface.tblArticulos.text(fila, this.iface.INCLUIR) == "Sí") {
			datosLote["codLote"] = this.iface.tblArticulos.text(fila, this.iface.CODLOTE);
			datosLote["cantidad"] = this.iface.tblArticulos.text(fila, this.iface.TOTAL);
			datosLote["referencia"]= this.iface.tblArticulos.text(fila, this.iface.REFERENCIA);
			datosLote["idProceso"] = this.iface.tblArticulos.text(fila, this.iface.IDPROCESO);
			if (!flprodppal.iface.pub_cargarTareasLote(datosLote))
				return false;
			seleccionados++;
		}
	}
	if (seleccionados == 0) {
		MessageBox.warning(util.translate("scripts", "No ha seleccionado ningún proceso"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	if (!flprodppal.iface.pub_establecerSecuencias())
		return false;

	if (!flprodppal.iface.pub_iniciarCentrosCoste())
		return false;
	return true;
}

// function oficial_iniciarCentrosCoste():Boolean
// {
// 	var util:FLUtil = new FLUtil;
// 
// 	var qryCentros:FLSqlQuery = new FLSqlQuery;
// 	with (qryCentros) {
// 		setTablesList("pr_centroscoste");
// 		setSelect("codcentro");
// 		setFrom("pr_centroscoste");
// 		setWhere("1 = 1");
// 		setForwardOnly(true);
// 	}
// 	if (!qryCentros.exec())
// 		return false;
// 
// 	var iCentro:Number = this.iface.centroMemo.length;
// 	var maxFechaPrev:Date;
// 	var maxFechaPrevS:String;
// 	var maxFecha:String;
// 	var hoy:Date;
// 	while (qryCentros.next()) {
// 		this.iface.centroMemo[iCentro] = this.iface.nuevoCentroCoste();
// 		this.iface.centroMemo[iCentro]["codcentro"] = qryCentros.value("codcentro");
// 		this.iface.centroMemo[iCentro]["codtipocentro"] = qryCentros.value("codtipocentro");
// 		this.iface.centroMemo[iCentro]["idtipotareapro"] = qryCentros.value("idtipotareapro");
// 		this.iface.centroMemo[iCentro]["costeinicial"] = qryCentros.value("costeinicial");
// 		this.iface.centroMemo[iCentro]["costeunidad"] = qryCentros.value("costeunidad");
// 
// 		//maxFechaPrev = util.sqlSelect("pr_tareas", "MAX(diafin)", "codcentro = '" + qryCentros.value("codcentro") + "'");
// 		maxFechaPrevS = util.sqlSelect("pr_tareas", "MAX(fechafinprev)", "codcentro = '" + qryCentros.value("codcentro") + "'");
// // debug("MFP = " + maxFechaPrevS);
// // debug("CODCENTRO = " + qryCentros.value("codcentro"));
// 		hoy = new Date;
// 		if (maxFechaPrevS) {
// 			maxFechaPrev = new Date(Date.parse(maxFechaPrevS));
// 			if (util.daysTo(maxFechaPrev, hoy) < 0)
// 				this.iface.centroMemo[iCentro]["fechainicio"] = hoy;
// 			else
// 				this.iface.centroMemo[iCentro]["fechainicio"] = maxFechaPrev;
// 		} else {
// 			this.iface.centroMemo[iCentro]["fechainicio"] = hoy;
// 		}
// // debug("FINICIO CC = " + this.iface.centroMemo[iCentro]["fechainicio"]);
// 		iCentro++;
// 	}
// 	return true;
// }

// function oficial_cargarTareasLote(codLote:String, cantidad:String, referencia:String):Boolean
// {
// 	var util:FLUtil = new FLUtil;
// 
// 	var idTipoProceso:String = util.sqlSelect("articulos", "idtipoproceso", "referencia = '" + referencia + "'");
// 	if (!idTipoProceso) {
// 		MessageBox.warning(util.translate("scripts", "Error al obtener el tipo de proceso asociado al lote %1").arg(codLote), MessageBox.Ok, MessageBox.NoButton);
// 		return false;
// 	}
// 
// 	var iLote:Number = this.iface.loteMemo.length;
// 	this.iface.loteMemo[iLote] = this.iface.nuevoLote();
// 	this.iface.loteMemo[iLote]["codlote"] = codLote;
// 	this.iface.loteMemo[iLote]["cantidad"] = cantidad;
// 	this.iface.loteMemo[iLote]["referencia"] = referencia;
// 	this.iface.loteMemo[iLote]["idtipoproceso"] = idTipoProceso;
// 	this.iface.loteMemo[iLote]["color"] = this.iface.colorLote[this.iface.iColorLote++];
// 	if (this.iface.iColorLote >= this.iface.colorLote.length)
// 		this.iface.iColorLote = 0;
// 
// 	var qryTareas:FLSqlQuery = new FLSqlQuery();
// 	with (qryTareas) {
// 		setTablesList("pr_tipostareapro");
// 		setSelect("idtipotareapro");
// 		setFrom("pr_tipostareapro");
// 		setWhere("idtipoproceso = '" + idTipoProceso + "'");
// 		setForwardOnly(true);
// 	}
// 	if (!qryTareas.exec())
// 		return false;
// 
// 	var indice:Number;
// 	var idTipoTareaPro:String;
// 	while (qryTareas.next()) {
// 		idTipoTareaPro = qryTareas.value("idtipotareapro");
// 		indice = this.iface.tareaMemo.length;
// 		this.iface.tareaMemo[indice] = this.iface.nuevaTarea();
// 		this.iface.tareaMemo[indice]["codlote"] = codLote;
// 		this.iface.tareaMemo[indice]["idtipotareapro"] = idTipoTareaPro;
// 		this.iface.tareaMemo[indice]["cantidad"] = cantidad;
// 	}
// 	return true;
// }

// function oficial_establecerSecuencias():Boolean
// {
// 	var codLote:String;
// 	var idTipoTarea:String;
// 	var iTarea:Number = 0;
// 	var totalTareas:Number = this.iface.tareaMemo.length;
// 	for (var iLote:Number = 0; iLote < this.iface.loteMemo.length; iLote++) {
// 		codLote = this.iface.loteMemo[iLote]["codlote"];
// 		while (iTarea < totalTareas && this.iface.tareaMemo[iTarea]["codlote"] == codLote) {
// 			if (!this.iface.establecerSecuenciasTarea(iTarea, iLote))
// 				return false;
// 			iTarea++;
// 		}
// 	}
// 	if (!this.iface.restriccionesConsumo())
// 		return false;
// 
// 	return true;
// }

// function oficial_establecerSecuenciasTarea(iTarea:Number, iLote:Number):Boolean
// {
// 	var util:FLUtil = new FLUtil;
// 	var qrySucesoras:FLSqlQuery = new FLSqlQuery();
// 	var sucesora:Array;
// 	var iSucesora:Number;
// 	var qryPredecesoras:FLSqlQuery = new FLSqlQuery();
// 	var predecesora:Array;
// 	var iPredecesora:Number;
// 	
// 	var codLote:String = this.iface.loteMemo[iLote]["codlote"];
// 	var idTipoTareaPro:String = this.iface.tareaMemo[iTarea]["idtipotareapro"];
// 
// 	with (qrySucesoras) {
// 		setTablesList("pr_secuencias");
// 		setSelect("tareafin");
// 		setFrom("pr_secuencias");
// 		setWhere("tareainicio = " + idTipoTareaPro);
// 		setForwardOnly(true);
// 	}
// 	if (!qrySucesoras.exec())
// 		return false; 
// 
// 	var iTareaSucesora:Number;
// 	while (qrySucesoras.next()) {
// 		iTareaSucesora = this.iface.buscarTarea(codLote, qrySucesoras.value("tareafin"));
// 		if (iTareaSucesora < 0) {
// 			MessageBox.warning(util.translate("scripts", "Ha habido un error al buscar la tarea:\n%1\nAsociada al lote %2").arg(this.iface.datosTarea(qrySucesoras.value("tareafin"))).arg(codLote), MessageBox.Ok, MessageBox.NoButton);
// 			return false;
// 		}
// 		if (!this.iface.establecerSecuencia(iTarea, iTareaSucesora))
// 			return false;
// 	}
// 	return true;
// }

// function oficial_restriccionesConsumo():Boolean
// {
// 	var util:FLUtil = new FLUtil;
// 	var codLote:String;
// 	var idTipoTareaPro:String;
// 	var idProceso:Number;
// 	var iTarea:Number;
// 	var iLoteComsumo:Number;
// 	var codLoteConsumo:Number;
// 	var qryConsumos:FLSqlQuery = new FLSqlQuery;
// 	
// 
// 	for (iLote = 0; iLote < this.iface.loteMemo.length; iLote++) {
// 		codLote = this.iface.loteMemo[iLote]["codlote"];
// 	
// 		with (qryConsumos) {
// 			setTablesList("movistock");
// 			setSelect("ms.codlote, a.idtipoproceso, ac.idtipotareapro");
// 			setFrom("movistock ms INNER JOIN articuloscomp ac ON ms.idarticulocomp = ac.id INNER JOIN articulos a ON ac.refcomponente = a.referencia");
// 			setWhere("ms.codloteprod = '" + codLote + "' AND a.fabricado = true");
// 			setForwardOnly(true);
// 		}
// 		if (!qryConsumos.exec())
// 			return false;
// 	
// 		while (qryConsumos.next()) {
// 			idTipoTareaPro = qryConsumos.value("ac.idtipotareapro");
// 			iTarea = this.iface.buscarTarea(codLote, idTipoTareaPro);
// 			if (iTarea < 0) {
// 				MessageBox.warning(util.translate("scripts", "Restricciones de consumo: Error al buscar la tarea:\n%1\nAsiciada al lote %2.").arg(this.iface.datosTarea(idTipoTareaPro)).arg(codLote), MessageBox.Ok, MessageBox.NoButton);
// 				return false;
// 			}
// 
// 			codLoteConsumo = qryConsumos.value("ms.codlote");
// 			idProceso = util.sqlSelect("pr_procesos", "idproceso", "idtipoproceso = '" + qryConsumos.value("a.idtipoproceso") + "' AND idobjeto = '" + codLoteConsumo + "'");
// 			if (idProceso && !isNaN(idProceso)) {
// 	///// POR HACER
// 			} else {
// 				iLoteComsumo = this.iface.buscarLote(codLoteConsumo);
// 				if (iLoteComsumo >= 0) {
// 					var tareasFin:Array = this.iface.tareasFinales(codLoteConsumo);
// 					if (tareasFin.length > 0) {
// 						for (var i:Number = 0; i < tareasFin.length; i++) {
// 							if (!this.iface.establecerSecuencia(tareasFin[i], iTarea))
// 								return false;
// 						}
// 					}
// 				} else {
// 					MessageBox.warning(util.translate("scripts", "Para fabricar el lote %1 es necesario tener disponible el lote %2.\nDicho lote no está fabricado, ni planificado, ni incluido en esta orden.").arg(codLote).arg(codLoteConsumo), MessageBox.Ok, MessageBox.NoButton);
// 					return false;
// 				}
// 			}
// 		}
// 	}
// 	return true;
// }

// function oficial_tareasFinales(codLote:String):Array
// {
// 	var tareasFinales:Array = [];
// 	var totalTareas:Number = this.iface.tareaMemo.length;
// 	for (var iTarea:Number = 0; iTarea < totalTareas; iTarea++) {
// 		if (this.iface.tareaMemo[iTarea]["codlote"] == codLote && this.iface.tareaMemo[iTarea]["sucesora"].length == 0) {
// 			tareasFinales[tareasFinales.length] = iTarea;
// 		}
// 	}
// // debug(tareasFinales);
// 	return tareasFinales;
// }

// function oficial_establecerSecuencia(iTareaInicial:Number, iTareaFinal:Number):Boolean
// {
// 	var iSucesora:Number = this.iface.tareaMemo[iTareaInicial]["sucesora"].length;
// 	this.iface.tareaMemo[iTareaInicial]["sucesora"][iSucesora] = iTareaFinal;
// 
// 	var iPredecesora:Number = this.iface.tareaMemo[iTareaFinal]["predecesora"].length;
// 	this.iface.tareaMemo[iTareaFinal]["predecesora"][iPredecesora] = iTareaInicial;
// 
// 	return true;
// }
// 
// function oficial_buscarTarea(codLote:String, idTipoTareaPro:String):Number
// {
// 	var i:Number;
// 	for (i = 0; i < this.iface.tareaMemo.length; i++) {
// 		if (this.iface.tareaMemo[i]["codlote"] == codLote && this.iface.tareaMemo[i]["idtipotareapro"] == idTipoTareaPro)
// 			return i;
// 	}
// 	return -1;
// }
// 
// function oficial_buscarLote(codLote:String):Number
// {
// 	var i:Number;
// 	for (i = 0; i < this.iface.loteMemo.length; i++) {
// 		if (this.iface.loteMemo[i]["codlote"] == codLote)
// 			return i;
// 	}
// 	return -1;
// }
// 
// function oficial_buscarCentroCoste(codCentro:String):Number
// {
// 	var i:Number;
// 	for (i = 0; i < this.iface.centroMemo.length; i++) {
// 		if (this.iface.centroMemo[i]["codcentro"] == codCentro)
// 			return i;
// 	}
// 	return -1;
// }

function oficial_mostrarDatosTareas()
{
	var util:FLUtil = new FLUtil;
	var codLote:String;
	var idTipoTarea:String;
	var iTarea:Number = 0;
	var iTareaAux:Number = 0;
	var iLoteAux:Number = 0;
	var totalTareas:Number = this.iface.tareaMemo.length;
	var texto:String = "";
	for (var iLote:Number = 0; iLote < this.iface.loteMemo.length; iLote++) {
		codLote = this.iface.loteMemo[iLote]["codlote"];
		texto += "LOTE: " + this.iface.tareaMemo[iTarea]["codlote"] + "\n";
		while (iTarea < totalTareas && this.iface.tareaMemo[iTarea]["codlote"] == codLote) {
			texto += "\n>> TAREA: " + util.sqlSelect("pr_tipostareapro", "idtipotarea", "idtipotareapro = " + this.iface.tareaMemo[iTarea]["idtipotareapro"] + " AND idtipoproceso = '" + this.iface.loteMemo[iLote]["idtipoproceso"] + "'") + "\n";
			texto += ">> >> ASIGNADA A: " + this.iface.tareaMemo[iTarea]["codcentrocoste"] + " INICIO: " + this.iface.tareaMemo[iTarea]["fechainicio"] + " FIN " + this.iface.tareaMemo[iTarea]["fechafin"] + " DURACIÓN " + this.iface.tareaMemo[iTarea]["duracion"] + "\n";
			texto += ">> >> PREDECESORAS: ";
			for (var iPrecedente:Number = 0; iPrecedente < this.iface.tareaMemo[iTarea]["predecesora"].length; iPrecedente++) {
				iTareaAux = this.iface.tareaMemo[iTarea]["predecesora"][iPrecedente];
				iLoteAux = this.iface.buscarLote(this.iface.tareaMemo[iTareaAux]["codlote"]);
				if (iLoteAux < 0) {
					MessageBox.warning(util.translate("scripts", "Ha habido un error al buscar el lote %1").arg(this.iface.tareaMemo[iTareaAux]["codlote"]), MessageBox.Ok, MessageBox.NoButton);
					return false;
				}
				texto += util.sqlSelect("pr_tipostareapro", "idtipotarea", "idtipotareapro = " + this.iface.tareaMemo[iTareaAux]["idtipotareapro"] + " AND idtipoproceso = '" + this.iface.loteMemo[iLoteAux]["idtipoproceso"] + "'") + " - ";
			}
			texto += "\n>> >> SUCESORAS: ";
			for (var iSucesora:Number = 0; iSucesora < this.iface.tareaMemo[iTarea]["sucesora"].length; iSucesora++) {
				iTareaAux = this.iface.tareaMemo[iTarea]["sucesora"][iSucesora];
				iLoteAux = this.iface.buscarLote(this.iface.tareaMemo[iTareaAux]["codlote"]);
				if (iLoteAux < 0) {
					MessageBox.warning(util.translate("scripts", "Ha habido un error al buscar el lote %1").arg(this.iface.tareaMemo[iTareaAux]["codlote"]), MessageBox.Ok, MessageBox.NoButton);
					return false;
				}
				texto += util.sqlSelect("pr_tipostareapro", "idtipotarea", "idtipotareapro = " + this.iface.tareaMemo[iTareaAux]["idtipotareapro"] + " AND idtipoproceso = '" + this.iface.loteMemo[iLoteAux]["idtipoproceso"] + "'") + " - ";
			}
			texto += "\n";
			iTarea++;
		}
	}
// 	debug(texto);
// 	this.iface.mostrarDatosCentros();

	var codCentro:String;
	var html:String = "<font size=\"1\"><table width=\"100%\" border=\"1\" cellspacing=\"0\">\n";
	var minFecha:Date = this.iface.buscarFechaMinimaTarea();
	var maxFecha:Date = this.iface.buscarFechaMaximaTarea();
// debug("oo = " + minFecha);
// debug(maxFecha);
	minFecha.setHours(0);
	minFecha.setMinutes(0);
	minFecha.setSeconds(0);
	maxFecha.setHours(23);
	maxFecha.setMinutes(59);
	maxFecha.setSeconds(59);
// debug(minFecha);
// debug(maxFecha);
	var dias:Number = util.daysTo(minFecha, maxFecha);
	var qryCC:FLSqlQuery = new FLSqlQuery;
	with (qryCC) {
		setTablesList("pr_centroscoste");
		setSelect("codcentro");
		setFrom("pr_centroscoste");
		setWhere("1 = 1");
		setForwardOnly(true);
	}
	if (!qryCC.exec())
		return false;

	html += "\t<tr>";
	html += "<td width=\"20%\">" + "C.C." + "</td>";
	var numFechas:Number = 0;
	for (var iFecha:Date = minFecha; util.daysTo(iFecha, maxFecha) >= 0; iFecha = util.addDays(iFecha, 1)) {
		html += "<td>" + iFecha.getDate() + "</td>";
		numFechas++
	}
	html += "\t</tr>\n";
	while (qryCC.next()) {
		codCentro = qryCC.value("codcentro");
		html += "\t<tr>";
		html += "<td>" + codCentro + "</td>";
		//for (var iFecha:Date = minFecha; util.daysTo(iFecha, maxFecha) >= 0; iFecha = util.addDays(iFecha, 1)) {
			html += "<td colspan=\"" + numFechas + "\">" + this.iface.htmlCentroCoste(codCentro, minFecha, maxFecha) + "</td>";
		//}
		html += "\t</tr>\n";
	}
	html += "\n</table></font>";
	this.child("fdbPlanificacion").setValue(html);
// debug(html);
}

/** \D Genera una línea html consistente en una tabla de una única fila en la que cada celda representa una tarea asignada al centro de coste
@param	codCentro: Centro de coste
@param	minFecha: Fecha mínima considerada
@param	maxFecha: Fecha máxima considerada
@return	html con la tabla
\end */
function oficial_htmlCentroCoste(codCentro:String, minFecha:Date, maxFecha:Date):String
{
	var util:FLUtil = new FLUtil;
	var html:String = "\n\t<font size=\"1\"><table width=\"100%\" height=\"100%\" cellspacing=\"0\" border=\"0\"><tr>\n";
	var tareasCentro:Array = this.iface.tareasCentroCoste(codCentro);
	var tiempoTotal:Number = maxFecha.getTime() - minFecha.getTime();
	var iTarea:Number;
	var fecha:Date = minFecha;
	var compFechas:Number;
	var porcentaje:Number;
	var tiempoTarea:Number;
	var tiempoHueco:Number;
	var iLote:Number;
	var color:String;
// debug(codCentro);
	for (var iTC:Number = 0; iTC < tareasCentro.length; iTC++) {
		iTarea = tareasCentro[iTC];
// debug("TTFF = " + this.iface.tareaMemo[iTarea]["fechafin"]);
		iLote = this.iface.buscarLote(this.iface.tareaMemo[iTarea]["codlote"]);
		color = this.iface.loteMemo[iLote]["color"];

		compFechas = this.iface.compararFechas(fecha, this.iface.tareaMemo[iTarea]["fechainicio"]);
		switch (compFechas) {
			case 1: {
				MessageBox.warning(util.translate("scripts", "Error al mostrar las tareas del centro de coste %1:\nLas tareas se solapan").arg(codCentro), MessageBox.Ok, MessageBox.NoButton);
				return false;
				break;
			}
			case 2: {
				tiempoHueco = this.iface.tareaMemo[iTarea]["fechainicio"].getTime() - fecha.getTime();
				porcentaje = Math.round(tiempoHueco * 100 / tiempoTotal);
				html += "\t\t<td width=\"" + porcentaje + "%\">" + "<p><span style=\"font-size:7pt\"></span></p>" + "</td>\n";
				break;
			}
		}
		tiempoTarea = this.iface.tareaMemo[iTarea]["fechafin"].getTime() - this.iface.tareaMemo[iTarea]["fechainicio"].getTime();
		porcentaje = Math.round(tiempoTarea * 100 / tiempoTotal);
		html += "\t\t<td bgcolor=\"" + color +"\" width=\"" + porcentaje + "%\">" + "<p><span style=\"font-size:7pt\"></span></p>" + "</td>\n";

		fecha = this.iface.tareaMemo[iTarea]["fechafin"];
	}

// debug(maxFecha);
// debug(fecha);
	if (this.iface.compararFechas(maxFecha, fecha) == 1) {
		tiempoHueco = maxFecha.getTime() - fecha.getTime();
		porcentaje = Math.round(tiempoHueco * 100 / tiempoTotal);
		html += "\t\t<td width=\"" + porcentaje + "%\"><p><span style=\"font-size:7pt\"></span></p></td>\n";
	}
	html += "\t</tr></table></font>\n";
	return html;
}

/** \D Busca la mínima fecha de inicio de entre todas las tareas consideradas
@return fecha mínima
\end */
// function oficial_buscarFechaMinimaTarea():Date
// {
// 	var fechaMin:Date = false;
// 	for (var iTarea:Number = 0; iTarea < this.iface.tareaMemo.length; iTarea++) {
// 		if (!fechaMin) {
// 			fechaMin = this.iface.tareaMemo[iTarea]["fechainicio"];
// 		} else {
// 			if (this.iface.compararFechas(fechaMin, this.iface.tareaMemo[iTarea]["fechainicio"]) == 1) {
// 				fechaMin = this.iface.tareaMemo[iTarea]["fechainicio"];
// 			}
// 		}
// 	}
// 	var ret:Date = new Date(fechaMin.getTime());
// 	return ret;
// }

/** \D Busca la máxima fecha de fin de entre todas las tareas consideradas
@return fecha máxima
\end */
// function oficial_buscarFechaMaximaTarea():Date
// {
// 	var fechaMax:Date = false;
// 	for (var iTarea:Number = 0; iTarea < this.iface.tareaMemo.length; iTarea++) {
// 		if (!fechaMax) {
// 			fechaMax = this.iface.tareaMemo[iTarea]["fechafin"];
// 		} else {
// 			if (this.iface.compararFechas(fechaMax, this.iface.tareaMemo[iTarea]["fechafin"]) == 2) {
// 				fechaMax = this.iface.tareaMemo[iTarea]["fechafin"];
// 			}
// 		}
// 	}
// 	var ret:Date = new Date(fechaMax.getTime());
// 	return ret;
// }

function oficial_mostrarDatosCentros()
{
	var util:FLUtil = new FLUtil;
	var codCentro:String;
	var idTipoTarea:String;
	var iTarea:Number = 0;
	var iTareaAux:Number = 0;
	var iLoteAux:Number = 0;
	var totalTareas:Number = this.iface.tareaMemo.length;
	var texto:String = "";
	var tareasCentro:Array;
	for (var iCentro:Number = 0; iCentro < this.iface.centroMemo.length; iCentro++) {
		codCentro = this.iface.centroMemo[iCentro]["codcentro"];
		texto += "\nCENTRO: " + this.iface.centroMemo[iCentro]["codcentro"] + "\n";
		tareasCentro = this.iface.tareasCentroCoste(codCentro);
		for (var iTC:Number = 0; iTC < tareasCentro.length; iTC++) {
			texto += "TAREA: " + this.iface.datosTarea(this.iface.tareaMemo[tareasCentro[iTC]]["idtipotareapro"]) + "D: " + this.iface.tareaMemo[tareasCentro[iTC]]["fechainicio"] + " H: " + this.iface.tareaMemo[tareasCentro[iTC]]["fechafin"] + " U: " + this.iface.tareaMemo[tareasCentro[iTC]]["duracion"] + "\n";
		}
	}
// 	debug(texto);
}

/** \D Construye un array con los índices de las tareas asociadas a un centro de coste ordenadas por fecha de inicio
@param codCentro: Centro en el que se buscan las tareas
@return	array de índices ordenado
\end */
// function oficial_tareasCentroCoste(codCentro:String):Array
// {
// 	var tareas:Array = [];
// 	var fechaNueva:Date;
// 	var fechaTarea:Date;
// 	var iTareaMod:Number;
// 	var longTareas:Number;
// 	for (var iTarea:Number = 0; iTarea < this.iface.tareaMemo.length; iTarea++) {
// 		if (this.iface.tareaMemo[iTarea]["codcentrocoste"] != codCentro)
// 			continue;
// 		fechaNueva = this.iface.tareaMemo[iTarea]["fechainicio"];
// 		var iTareaCoste:Number;
// 		for (iTareaCoste = 0; iTareaCoste < tareas.length; iTareaCoste++) {
// 			fechaTarea = this.iface.tareaMemo[tareas[iTareaCoste]]["fechainicio"];
// 			if (this.iface.compararFechas(fechaTarea, fechaNueva) == 1)
// 				break;
// 		}
// 		longTareas = tareas.length;
// 		for (var iTareaCam:Number = iTareaCoste + 1; iTareaCam <= longTareas; iTareaCam++) {
// 			tareas[iTareaCam] = tareas[iTareaCam - 1]
// 		}
// 		tareas[iTareaCoste] = iTarea;
// 	}
// 	return tareas;
// }

// function oficial_nuevaTarea():Array
// {
// 	var tarea:Array = [];
// 	tarea["codlote"] = false;
// 	tarea["idtipotareapro"] = false;
// 	tarea["predecesora"] = [];
// 	tarea["sucesora"] = [];
// 	tarea["codcentrocoste"] = false;
// 	tarea["fechainicio"] = false;
// 	tarea["duracion"] = false;
// 	tarea["fechafin"] = false;
// 	tarea["cantidad"] = false;
// 	tarea["asignada"] = false;
// 
// 	return tarea;
// }
// 
// function oficial_nuevoLote():Array
// {
// 	var lote:Array = [];
// 	lote["codlote"] = false;
// 	lote["cantidad"] = false;
// 	lote["referencia"] = false;
// 	lote["idtipoproceso"] = false;
// 	lote["color"] = false;
// 
// 	return lote;
// }
// 
// function oficial_nuevoCentroCoste():Array
// {
// 	var centro:Array = [];
// 	centro["codcentro"] = false;
// 	centro["codtipocentro"] = false;
// 	centro["idtipotareapro"] = false;
// 	centro["costeinicial"] = false;
// 	centro["costeunidad"] = false;
// 	centro["fechainicio"] = false;
// 
// 	return centro;
// }

// function oficial_datosTarea(idTipoTareaPro:String):String
// {
// 	var util:FLUtil = new FLUtil;
// 	var texto:String = "";
// 	var qryDatos:FLSqlQuery = new FLSqlQuery;
// 	with (qryDatos) {
// 		setTablesList("pr_tipostareapro");
// 		setSelect("idtipotarea, descripcion, idtipoproceso");
// 		setFrom("pr_tipostareapro");
// 		setWhere("idtipotareapro = " + idTipoTareaPro);
// 		setForwardOnly(true);
// 	}
// 	if (!qryDatos.exec())
// 		return false;
// 
// 	if (!qryDatos.first())
// 		return false;
// 	
// 	texto = util.translate("scripts", "Tarea %1: %2 (Proceso %3)").arg(qryDatos.value("idtipotarea")).arg(qryDatos.value("descripcion")).arg(qryDatos.value("idtipoproceso"));
// 
// 	return texto;
// }

function oficial_subirPrioridad()
{
	var iFilaActual:Number = this.iface.tblArticulos.currentRow();
	if (iFilaActual == 0)
		return;
	this.iface.cambiarDatosTabla(iFilaActual, iFilaActual - 1);
	this.iface.tblArticulos.selectRow(iFilaActual - 1);
}

function oficial_bajarPrioridad()
{
	var iFilaActual:Number = this.iface.tblArticulos.currentRow();
	if (iFilaActual == (this.iface.tblArticulos.numRows() - 1))
		return;

	this.iface.cambiarDatosTabla(iFilaActual, iFilaActual + 1);
	this.iface.tblArticulos.selectRow(iFilaActual + 1);
}

/** \D Cambia los datos de una fila por los de otra y viceversa
@param	iFila1: Número de la primera fila
@param	iFila2: Número de la segunda fila
\end */
function oficial_cambiarDatosTabla(iFila1:Number, iFila2:Number)
{
	var valor1:String;
	var valor2:String;

	valor1 = this.iface.tblArticulos.text(iFila1, this.iface.CODLOTE);
	valor2 = this.iface.tblArticulos.text(iFila2, this.iface.CODLOTE);
	this.iface.tblArticulos.setText(iFila1, this.iface.CODLOTE, valor2);
	this.iface.tblArticulos.setText(iFila2, this.iface.CODLOTE, valor1);

	valor1 = this.iface.tblArticulos.text(iFila1, this.iface.REFERENCIA);
	valor2 = this.iface.tblArticulos.text(iFila2, this.iface.REFERENCIA);
	this.iface.tblArticulos.setText(iFila1, this.iface.REFERENCIA, valor2);
	this.iface.tblArticulos.setText(iFila2, this.iface.REFERENCIA, valor1);

	valor1 = this.iface.tblArticulos.text(iFila1, this.iface.PEDIDO);
	valor2 = this.iface.tblArticulos.text(iFila2, this.iface.PEDIDO);
	this.iface.tblArticulos.setText(iFila1, this.iface.PEDIDO, valor2);
	this.iface.tblArticulos.setText(iFila2, this.iface.PEDIDO, valor1);

	valor1 = this.iface.tblArticulos.text(iFila1, this.iface.CLIENTE);
	valor2 = this.iface.tblArticulos.text(iFila2, this.iface.CLIENTE);
	this.iface.tblArticulos.setText(iFila1, this.iface.CLIENTE, valor2);
	this.iface.tblArticulos.setText(iFila2, this.iface.CLIENTE, valor1);

	valor1 = this.iface.tblArticulos.text(iFila1, this.iface.TOTAL);
	valor2 = this.iface.tblArticulos.text(iFila2, this.iface.TOTAL);
	this.iface.tblArticulos.setText(iFila1, this.iface.TOTAL, valor2);
	this.iface.tblArticulos.setText(iFila2, this.iface.TOTAL, valor1);

	valor1 = this.iface.tblArticulos.text(iFila1, this.iface.FSALIDA);
	valor2 = this.iface.tblArticulos.text(iFila2, this.iface.FSALIDA);
	this.iface.tblArticulos.setText(iFila1, this.iface.FSALIDA, valor2);
	this.iface.tblArticulos.setText(iFila2, this.iface.FSALIDA, valor1);

	valor1 = this.iface.tblArticulos.text(iFila1, this.iface.ENSTOCK);
	valor2 = this.iface.tblArticulos.text(iFila2, this.iface.ENSTOCK);
	this.iface.tblArticulos.setText(iFila1, this.iface.ENSTOCK, valor2);
	this.iface.tblArticulos.setText(iFila2, this.iface.ENSTOCK, valor1);

	valor1 = this.iface.tblArticulos.text(iFila1, this.iface.INCLUIR);
	valor2 = this.iface.tblArticulos.text(iFila2, this.iface.INCLUIR);
	this.iface.tblArticulos.setText(iFila1, this.iface.INCLUIR, valor2);
	this.iface.tblArticulos.setText(iFila2, this.iface.INCLUIR, valor1);

	this.iface.establecerEstadoBotones("calcular");
}

function oficial_lanzarOrdenClicked()
{
	var util:FLUtil = new FLUtil;
	var curTrans:FLSqlCursor = new FLSqlCursor("pr_ordenesproduccion");
	curTrans.transaction(false);
	try {
		if (this.iface.lanzarOrden(true)) {
			var res:Number = MessageBox.information(util.translate("scripts", "Los procesos de fabricación se han lanzado correctamente."), MessageBox.Ok, MessageBox.Cancel);
			if (res != MessageBox.Ok) {
				curTrans.rollback();
				return;
			}
			curTrans.commit();
			this.child("pushButtonAccept").enabled = true;
			this.child("pushButtonAccept").animateClick();
		} else {
			curTrans.rollback();
		}
	} catch (e) {
		curTrans.rollback();
		MessageBox.critical(util.translate("scripts", "Hubo un error al lanzar los procesos de fabricación:\n") + e, MessageBox.Ok, MessageBox.NoButton);
		return;
	}
}

function oficial_lanzarOrden(mostrarProgreso:Boolean):Boolean
{
	var util:FLUtil = new FLUtil;
	
	var codLote:String;
	var idProceso:String;
	var totalFilas:Number = this.iface.tblArticulos.numRows();
	if(mostrarProgreso)
		util.createProgressDialog(util.translate("scripts", "Generando procesos de producción..."), totalFilas);
	for (var iFila:Number = 0; iFila < totalFilas; iFila++) {
		if(mostrarProgreso)
			util.setProgress(iFila + 1);
		codLote = this.iface.tblArticulos.text(iFila, this.iface.CODLOTE);
		idProceso = this.iface.tblArticulos.text(iFila, this.iface.IDPROCESO);
		if (this.iface.tblArticulos.text(iFila, this.iface.INCLUIR) == "Sí") {
			if (!this.iface.activarProcesoLote(codLote, idProceso)) {
				if(mostrarProgreso)
					util.destroyProgressDialog();
				MessageBox.warning(util.translate("scripts", "Hubo un error al activar el proceso %1 correspondiente al lote %2").arg(idProceso).arg(codLote), MessageBox.Ok, MessageBox.NoButton);
				return false;
			}
		}
	}
	if(mostrarProgreso)
		util.destroyProgressDialog();
	return true;
}
// function oficial_lanzarOrden():Boolean
// {
// 	var util:FLUtil = new FLUtil;
// 	
// 	var codLote:String;
// 	var referencia:String;
// 	var totalFilas:Number = this.iface.tblArticulos.numRows();
// 	util.createProgressDialog(util.translate("scripts", "Generando procesos de fabricación..."), totalFilas);
// 	for (var iFila:Number = 0; iFila < totalFilas; iFila++) {
// 		util.setProgress(iFila + 1);
// 		codLote = this.iface.tblArticulos.text(iFila, this.iface.CODLOTE);
// 		referencia = this.iface.tblArticulos.text(iFila, this.iface.REFERENCIA);
// 		if (this.iface.tblArticulos.text(iFila, this.iface.INCLUIR) == "Sí") {
// 			if (!this.iface.generarProcesoLote(codLote, referencia)) {
// 				util.destroyProgressDialog()
// 				return false;
// 			}
// 		}
// 	}
// 	util.destroyProgressDialog()
// 	return true;
// }

/** \D Genera el proceso de fabricación asociado a un determinado lote
@param	codLote: Código del lote
@param	referencia: Referencia del artículo
@return true si la función termina correctamente, false en caso contrario
\end */
// function oficial_generarProcesoLote(codLote:String, referencia:String):Boolean
// {
// 	var util:FLUtil = new FLUtil;
// 	var cursor:FLSqlCursor = this.cursor();
// 
// 	if (cursor.modeAccess() == cursor.Insert) {
// 		if (!this.child("tdbLotesStock").cursor().commitBufferCursorRelation())
// 			return false;
// 	}
// 
// 	var idTipoProceso:String = util.sqlSelect("articulos", "idtipoproceso", "referencia = '" + referencia + "'");
// 	if (!idTipoProceso) {
// 		MessageBox.warning(util.translate("scripts", "Error al obtener el tipo de proceso correspondiente al artículo %1").arg(referencia), MessageBox.Ok, MessageBox.NoButton);
// 		return false;
// 	}
// 	var idProceso = flcolaproc.iface.pub_crearProceso(idTipoProceso, "lotesstock", codLote);
// 	if (!idProceso)
// 		return false;
// 
// 	if (!flprodppal.iface.pub_actualizarTareasProceso(idProceso, codLote))
// 		return false;
// 
// 	// Movimiento de stock positivo PTE para la fecha prevista de finalización del proceso.
// 	var curProceso:FLSqlCursor = new FLSqlCursor("pr_procesos");
// 	curProceso.select("idproceso = " + idProceso);
// 	if (!curProceso.first())
// 		return false;
// 
// 	var cantidad:Number = parseFloat(util.sqlSelect("lotesstock", "canlote", "codlote = '" + codLote + "'"));
// 	if (!cantidad || isNaN(cantidad))
// 		return false;
// 	if (!flfactalma.iface.pub_generarMoviStock(curProceso, codLote, cantidad))
// 		return false;
// 
// 	if (!util.sqlUpdate("lotesstock", "codordenproduccion", cursor.valueBuffer("codorden"), "codlote = '" + codLote + "'"))
// 		return false;
// 
// 	return true;
// }

/** \D Activa el proceso de producción asociado a un determinado lote
@param	codLote: Código del lote
@param	idProceso: Identificador del proceso a activar
@return true si la función termina correctamente, false en caso contrario
\end */
function oficial_activarProcesoLote(codLote:String, idProceso:String):Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	if (cursor.modeAccess() == cursor.Insert) {
		if (!this.child("tdbProcesos").cursor().commitBufferCursorRelation())
			return false;
	}

	/// Podrá obtenerse de la tabla de búsqueda
	var idTipoProceso:String = util.sqlSelect("pr_procesos", "idtipoproceso", "idproceso = '" + idProceso + "'");
	if (!idTipoProceso) {
		MessageBox.warning(util.translate("scripts", "Error al obtener el tipo de proceso correspondiente al artículo %1").arg(referencia), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	
	if (!flcolaproc.iface.pub_activarProcesoProd(idProceso,false))
		return false;

	if (!flprodppal.iface.pub_actualizarTareasProceso(idProceso, codLote,false))
		return false;

	// Movimiento de stock positivo PTE para la fecha prevista de finalización del proceso (si es de fabricación)
	if (flcolaproc.iface.pub_esProcesoFabricacion(idTipoProceso)) {
		var curProceso:FLSqlCursor = new FLSqlCursor("pr_procesos");
		curProceso.select("idproceso = " + idProceso);
		if (!curProceso.first())
			return false;
	
		var cantidad:Number = parseFloat(util.sqlSelect("lotesstock", "canlote", "codlote = '" + codLote + "'"));
		if (!cantidad || isNaN(cantidad))
			return false;
		if (!flfactalma.iface.pub_generarMoviStock(curProceso, codLote, cantidad))
			return false;
	}

	if (!util.sqlUpdate("pr_procesos", "codordenproduccion", cursor.valueBuffer("codorden"), "idproceso = " + idProceso))
		return false;

	return true;
}

/** \D Actualiza las fechas y horas desde y hasta de ejecución prevista de las tareas del proceso asociado a un lote de fabricación
@param	idProceso: Identificador del proceso
@param	codLote: Código del lote
@return true si la función termina correctamente, false en caso contrario
\end */
// function oficial_actualizarTareasProceso(idProceso:String, codLote:String):Boolean
// {
// // debug("ATP");
// 	var util:FLUtil = new FLUtil;
// 	var fechaInicio:String;
// 	var horaInicio:String;
// 	var fechaFin:String;
// 	var horaFin:String;
// 	var fechaAux:Date;
// 	var idTipoTareaPro:String;
// 	var codCentro:String;
// 	var curTareas:FLSqlCursor = new FLSqlCursor("pr_tareas");
// 	for (var iTarea:Number = 0; iTarea < this.iface.tareaMemo.length; iTarea++) {
// 		if (this.iface.tareaMemo[iTarea]["codlote"] != codLote)
// 			continue;
// 		idTipoTareaPro = this.iface.tareaMemo[iTarea]["idtipotareapro"];
// 		codCentro = this.iface.tareaMemo[iTarea]["codcentrocoste"];
// 		fechaInicio = this.iface.tareaMemo[iTarea]["fechainicio"].toString().left(10);
// 		horaInicio = this.iface.tareaMemo[iTarea]["fechainicio"].toString().right(8);
// 		fechaFin = this.iface.tareaMemo[iTarea]["fechafin"].toString().left(10);
// 		horaFin = this.iface.tareaMemo[iTarea]["fechafin"].toString().right(8);
// 		with (curTareas) {
// 			select("idproceso = " + idProceso + " AND idtipotareapro = " + idTipoTareaPro);
// 			if (!first()) {
// 				MessageBox.warning(util.translate("scripts", "Error al obtener la tarea:\n%1 para el lote %2").arg(this.iface.datosTarea(idTipoTareaPro)).arg(codLote), MessageBox.Ok, MessageBox.NoButton);
// 				return false;
// 			}
// 			setModeAccess(Edit);
// 			refreshBuffer();
// // debug(fechaInicio);
// 			setValueBuffer("fechainicioprev", fechaInicio);
// 			setValueBuffer("horainicioprev", horaInicio);
// 			setValueBuffer("fechafinprev", fechaFin);
// 			setValueBuffer("horafinprev", horaFin);
// 			setValueBuffer("codcentro", codCentro);
// 			if (!commitBuffer())
// 				return false;
// 		}
// 	}
// 	return true;
// }

function oficial_establecerEstadoBotones(estado:String)
{
	var util:FLUtil = new FLUtil;
	this.iface.estado_ = estado;

	switch (this.iface.estado_) {
		case "buscar": {
			var totalFilas:Number = this.iface.tblArticulos.numRows();
			for (var fila:Number = 0; fila < totalFilas; fila++)
				this.iface.tblArticulos.removeRow(0);
			this.iface.tbnBuscar.enabled = true;
			this.iface.tbnSubir.enabled = false;
			this.iface.tbnBajar.enabled = false;
			this.iface.tbnCalcular.enabled = false;
			this.iface.tbnLanzarOrden.enabled = false;
			this.iface.tbnEditarLote.enabled = false;
			this.iface.tbnEstadoAtras.enabled = false;
			this.child("lblEstado").text = util.translate("scripts", "Buscando procesos...");
			this.child("gbxFiltros").enabled = true;
			break;
		}
		case "calcular": {
			flprodppal.iface.pub_limpiarMemoria();
			this.iface.tbnBuscar.enabled = false;
			this.iface.tbnSubir.enabled = true;
			this.iface.tbnBajar.enabled = true;
			this.iface.tbnCalcular.enabled = true;
			this.iface.tbnLanzarOrden.enabled = false;
			this.iface.tbnEditarLote.enabled = true;
			this.iface.tbnEstadoAtras.enabled = true;
			this.child("lblEstado").text = util.translate("scripts", "Planificando producción...");
			this.child("gbxFiltros").enabled = false;
			break;
		}
		case "lanzar": {
			this.iface.tbnBuscar.enabled = false;
			this.iface.tbnSubir.enabled = false;
			this.iface.tbnBajar.enabled = false;
			this.iface.tbnCalcular.enabled = false;
			this.iface.tbnLanzarOrden.enabled = true;
			this.iface.tbnEditarLote.enabled = false;
			this.iface.tbnEstadoAtras.enabled = true;
			this.child("lblEstado").text = util.translate("scripts", "Lanzando procesos...");
			this.child("gbxFiltros").enabled = false;
			break;
		}
	}
}

// function oficial_limpiarMemoria()
// {
// 	delete this.iface.tareaMemo;
// 	this.iface.tareaMemo = [];
// 
// 	delete this.iface.loteMemo;
// 	this.iface.loteMemo = [];
// 
// 	delete this.iface.centroMemo;
// 	this.iface.centroMemo = [];
// 
// 	this.iface.iColorLote = 0;
// }

function oficial_tbnEstadoAtras_clicked()
{
	switch (this.iface.estado_) {
		case "calcular": {
			this.iface.establecerEstadoBotones("buscar");
			break;
		}
		case "lanzar": {
			this.iface.establecerEstadoBotones("calcular");
			break;
		}
	}
}

function oficial_habilitarPestanas()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	if (!util.sqlSelect("pr_procesos", "idproceso", "codordenproduccion = '" + cursor.valueBuffer("codorden") + "'")) {
		this.child("tbwOrdenes").setTabEnabled("buscar", true);
		this.child("tbwOrdenes").setTabEnabled("procesos", false);
		this.child("tbwOrdenes").currentPage = 0;

		this.child("pushButtonAccept").enabled = false;
		this.child("pushButtonAcceptContinue").close();
	} else {
		this.child("tbwOrdenes").setTabEnabled("buscar", false);
		this.child("tbwOrdenes").setTabEnabled("procesos", true);
		this.child("tbwOrdenes").currentPage = 1;
	}
}

function oficial_terminarProceso_clicked()
{
	var util:FLUtil;

	var cursor:FLSqlCursor = this.child("tdbProcesos").cursor();
	var idProceso:Number = cursor.valueBuffer("idproceso");

	var res:Number = MessageBox.information(util.translate("scripts", "Se van a terminar todas las tareas del proceso %1.\n¿Desea continuar?").arg(idProceso), MessageBox.Yes, MessageBox.No);
	if(res != MessageBox.Yes)
		return false;


	var idUsuario:String = util.sqlSelect("pr_trabajadores", "idtrabajador", "idtrabajador = '" + sys.nameUser() + "'");

	if (!idUsuario || idUsuario == "") {
		MessageBox.warning(util.translate("scripts", "El trabajador %1 no existe en la tabla de trabajadores (módulo principal de producción)").arg(sys.nameUser()), MessageBox.Ok);
		return false;
	}

	flcolaproc.iface.pub_setTareaAutomatica(true);

	cursor.transaction(false);
	try {
		if(formpr_ordenesproduccion.iface.pub_terminarProceso(idProceso,idUsuario))
			cursor.commit();
		else {
			cursor.rollback();
			return;
		}
	} catch (e) {
		cursor.rollback();
		MessageBox.warning(util.translate("scripts", "Hubo un error al intentar terminar el proceso %1.").arg(idProceso) + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
		return;
	}

	this.child("tdbProcesos").refresh();
	flcolaproc.iface.pub_setTareaAutomatica(false);

	MessageBox.information(util.translate("scripts", "El proceso %1 se ha terminado correctamentae").arg(idProceso), MessageBox.Ok, MessageBox.NoButton);
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
