/**************************************************************************
                 generarliqagentes.qs  -  description
                             -------------------
    begin                : mar ene 12 2010
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var COL_INCLUIR:Number;
	var COL_CODIGO:Number;
	var COL_AGENTE:Number;
	var COL_TOTAL:Number;
	var COL_NOMBRE:Number;
	var estado:String;
	var currentRow:Number;
	var tblAgentes_:FLTable;
	var colorInc_:Color;
	var colorNoInc_:Color;
    function oficial( context ) { interna( context ); } 
	function tblAgentes_currentChanged(row:Number, col:Number) {
		return this.ctx.oficial_tblAgentes_currentChanged(row, col);
	}
	function pbnAddDel_clicked() {
		return this.ctx.oficial_pbnAddDel_clicked();
	}
	function incluirFila(fila:Number, col:Number) {
		return this.ctx.oficial_incluirFila(fila, col);
	}
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function gestionEstado() {
		return this.ctx.oficial_gestionEstado();
	}
	function actualizar() {
		return this.ctx.oficial_actualizar();
	}
	function generarTabla() {
		return this.ctx.oficial_generarTabla();
	}
	function insertarLineaTabla(codAgente:String) {
		return this.ctx.oficial_insertarLineaTabla(codAgente);
	}
	function generarLista() {
		return this.ctx.oficial_generarLista();
	}
	function establecerFechasPeriodo() {
		return this.ctx.oficial_establecerFechasPeriodo();
	}
	function habilitarPeriodo() {
		return this.ctx.oficial_habilitarPeriodo();
	}
	function cambiarColorFilaTabla(tabla:Object, iFila:Number, colorFila:Color) {
		return this.ctx.oficial_cambiarColorFilaTabla(tabla, iFila, colorFila);
	}
	function colores() {
		return this.ctx.oficial_colores();
	}
	function tbnFacturas_clicked() {
		return this.ctx.oficial_tbnFacturas_clicked();
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
/** \C
Este formulario calcula las liquidaciones que se asociarán a cada agente comercial.
\end */
function interna_init()
{
	var util:FLUtil = new FLUtil();
	this.iface.estado = "Buscando";
	this.iface.gestionEstado();
	this.iface.tblAgentes_ = this.child("tblAgentes");
	var cursor:FLSqlCursor = this.cursor();

	connect(this.child("tbnBuscar"), "clicked()", this, "iface.actualizar");
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this.iface.tblAgentes_, "doubleClicked(int, int)", this, "iface.incluirFila");
	connect(this.iface.tblAgentes_, "currentChanged(int, int)", this, "iface.tblAgentes_currentChanged");
	disconnect(this.child("pushButtonAccept"), "clicked()", this, "accept()");
	connect(this.child("pushButtonAccept"), "clicked()", this, "iface.generarLista");
	connect(this.child("pbnAddDel"), "clicked()", this, "iface.pbnAddDel_clicked");
	connect(this.child("tbnFacturas"), "clicked()", this, "iface.tbnFacturas_clicked");

	var hoy:Date = new Date();
	this.child("fdbFecha").setValue(hoy);

	this.iface.generarTabla();
	this.iface.habilitarPeriodo();
	this.iface.colores();
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_colores()
{
	try {
		this.iface.colorInc_ = new Color(200, 255, 200);
		this.iface.colorNoInc_ = new Color(255, 255, 255);
	} catch (e) {}
}

/** \D
Elabora un string en el que figuran, separados por comas, los identificadores de los agente a los que se desea generar liquidación.
\end */
function oficial_generarLista()
{
debug("oficial_generarLista");
	var valor:Boolean = true;
	var cursor:FLSqlCursor = this.cursor();
	var lista:String = "";
	var fila:Number;
	for (fila = 0; fila < this.iface.tblAgentes_.numRows(); fila++) {
		if (this.iface.tblAgentes_.text(fila, this.iface.COL_INCLUIR) != "No") {
			if (lista != "") {
				lista += ", ";
			}
			lista += this.iface.tblAgentes_.text(fila, this.iface.COL_CODIGO);
debug("lista = " + lista);
		}
	}
	cursor.setValueBuffer("agentes", lista);
	this.accept();
}

function oficial_tblAgentes_currentChanged(row:Number, col:Number)
{
	this.iface.currentRow = row;
}

function oficial_pbnAddDel_clicked()
{
	this.iface.incluirFila(this.iface.currentRow, this.iface.COL_INCLUIR);
}

function oficial_incluirFila(fila:Number, col:Number)
{
	if (this.iface.tblAgentes_.numRows() == 0) return;
	
	if (this.iface.tblAgentes_.text(fila, this.iface.COL_INCLUIR) == "Sí") {
		this.iface.tblAgentes_.setText(fila, this.iface.COL_INCLUIR, "No");
		this.iface.cambiarColorFilaTabla(this.iface.tblAgentes_, fila, this.iface.colorNoInc_);
	} else {
		this.iface.tblAgentes_.setText(fila, this.iface.COL_INCLUIR, "Sí");
		this.iface.cambiarColorFilaTabla(this.iface.tblAgentes_, fila, this.iface.colorInc_);
	}
	try { this.iface.tblAgentes_.repaintContents(); } catch (e) {}
	
}

function oficial_cambiarColorFilaTabla(tabla:Object, iFila:Number, colorFila:Color)
{
	var numCol:Number = tabla.numCols();
	for (var iCol:Number = 0; iCol < numCol; iCol++) {
		try { tabla.setCellBackgroundColor(iFila, iCol, colorFila); } catch (e) {}
	}
}

function oficial_bufferChanged(fN:String)
{
	switch (fN) {
	/** \C
	La modificación de alguno de los criterios de búsqueda habilita el botón 'Actualizar', de forma que puede realizarse una búsqueda de acuerdo a los nuevos criterios utilizados.
	\end */
		case "fechadesde":
		case "fechahasta": {
			if (this.iface.estado == "Seleccionando") {
				this.iface.estado = "Buscando";
				this.iface.gestionEstado();
			}
			break;
		}
		case "codejercicio": {
			this.iface.habilitarPeriodo();
			this.iface.establecerFechasPeriodo();
			if (this.iface.estado == "Seleccionando") {
				this.iface.estado = "Buscando";
				this.iface.gestionEstado();
			}
			break;
		}
		case "tipoperiodo": {
			this.iface.habilitarPeriodo();
			this.iface.establecerFechasPeriodo();
			break;
		}
		case "mes":
		case "trimestre": {
			this.iface.establecerFechasPeriodo();
			break;
		}
	}
}

/** \D Habilita los controles de perído y tipo de período si hay un ejercicio especificado, y muestra el tipo de período (mes, trimestre o año) indicado por el usuario
\*/
function oficial_habilitarPeriodo()
{
	var cursor:FLSqlCursor = this.cursor();

	var codEjercicio:String = this.child("fdbCodEjercicio").value();
	if (codEjercicio && codEjercicio != "") {
		this.child("fdbMes").setDisabled(false);
		this.child("fdbTrimestre").setDisabled(false);
		this.child("fdbTipoPeriodo").setShowAlias(true);
		this.child("fdbTipoPeriodo").setShowEditor(true);
		switch (cursor.valueBuffer("tipoperiodo")) {
			case "Mes": {
				this.child("fdbMes").setShowAlias(true);
				this.child("fdbMes").setShowEditor(true);
				this.child("fdbTrimestre").setShowAlias(false);
				this.child("fdbTrimestre").setShowEditor(false);
				break;
			}
			case "Trimestre": {
				this.child("fdbTrimestre").setShowAlias(true);
				this.child("fdbTrimestre").setShowEditor(true);
				this.child("fdbMes").setShowAlias(false);
				this.child("fdbMes").setShowEditor(false);
				break;
			}
			default: {
				this.child("fdbTrimestre").setShowAlias(false);
				this.child("fdbTrimestre").setShowEditor(false);
				this.child("fdbMes").setShowAlias(false);
				this.child("fdbMes").setShowEditor(false);
			}
		}
	} else {
		this.child("fdbMes").setDisabled(true);
		this.child("fdbTrimestre").setDisabled(true);
		this.child("fdbTipoPeriodo").setShowAlias(false);
		this.child("fdbTipoPeriodo").setShowEditor(false);
		this.child("fdbTrimestre").setShowAlias(false);
		this.child("fdbTrimestre").setShowEditor(false);
		this.child("fdbMes").setShowAlias(false);
		this.child("fdbMes").setShowEditor(false);
	}
}


/** \D Establece las fechas de inicio y fin del período de liquidación
\end */
function oficial_establecerFechasPeriodo()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var fechaInicio:Date;
	var fechaFin:Date;
	var codEjercicio:String = this.child("fdbCodEjercicio").value();
	if (!codEjercicio || codEjercicio == "") {
		return false;
	}

	var inicioEjercicio = util.sqlSelect("ejercicios", "fechainicio", "codejercicio = '" + codEjercicio + "'");
	if (!inicioEjercicio) {
		return false;
	}
	
	fechaInicio.setYear(inicioEjercicio.getYear());
	fechaFin.setYear(inicioEjercicio.getYear());
	fechaInicio.setDate(1);

	switch (cursor.valueBuffer("tipoperiodo")) {
		case "Trimestre": {
			switch (cursor.valueBuffer("trimestre")) {
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
			var numMes:Number = parseInt(cursor.valueBuffer("mes"));
			fechaInicio.setDate(1);
			fechaInicio.setMonth(numMes);
			fechaFin = util.addMonths(fechaInicio, 1);
			fechaFin = util.addDays(fechaFin, -1);
			break;
		}
		default: {
			fechaFin = util.addYears(fechaInicio, 1);
			fechaFin = util.addDays(fechaFin, -1);
			break;
		}
	}

	if (fechaInicio) {
		this.child("fdbFechaDesde").setValue(fechaInicio);
		this.child("fdbFechaHasta").setValue(fechaFin);
	}
}


/** \D
El estado 'Buscando' define la situación en la que el usuario está especificando los criterios de búsqueda.
El estado 'Seleccionando' define la situación en la que el usuario ya ha buscado y puede generar la factura o facturas
\end */
function oficial_gestionEstado()
{
	switch (this.iface.estado) {
		case "Buscando": {
			this.child("tbnBuscar").enabled = true;
			this.child("pushButtonAccept").enabled = false;
			break;
		}
		case "Seleccionando": {
			this.child("tbnBuscar").enabled = false;
			this.child("pushButtonAccept").enabled = true;
			break;
		}
	}
}

/** \D
Actualiza la lista de albaranes en función de los criterios de búsqueda especificados
\end */
function oficial_actualizar()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	this.iface.tblAgentes_.setNumRows(0);

	var filtro:String = flfactppal.iface.pub_obtenFiltroFacturas(false, cursor.valueBuffer("fechadesde"), cursor.valueBuffer("fechahasta"), cursor.valueBuffer("codejercicio"));
	var qryFacturas:FLSqlQuery = new FLSqlQuery;
	qryFacturas.setTablesList("facturascli");
	qryFacturas.setSelect("facturascli.codagente");
	qryFacturas.setFrom("facturascli");
	qryFacturas.setWhere(filtro + "GROUP BY facturascli.codagente");
	qryFacturas.setForwardOnly(true);
	if (!qryFacturas.exec()) {
		return false;
	}
	var codAgente:String;
	while (qryFacturas.next()) {
		codAgente = qryFacturas.value("facturascli.codagente");
		this.iface.insertarLineaTabla(codAgente);
	}
	try { this.iface.tblAgentes_.repaintContents(); } catch (e) {}
	
	this.iface.estado = "Seleccionando";
	this.iface.gestionEstado();

	if (this.iface.tblAgentes_.numRows() == 0) {
		this.child("pushButtonAccept").enabled = false;
	}
}

function oficial_insertarLineaTabla(codAgente:String)
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var filtro:String = flfactppal.iface.pub_obtenFiltroFacturas(codAgente, cursor.valueBuffer("fechadesde"), cursor.valueBuffer("fechahasta"), cursor.valueBuffer("codejercicio"));
	var numLinea:Number = this.iface.tblAgentes_.numRows();
	this.iface.tblAgentes_.insertRows(numLinea);
	this.iface.tblAgentes_.setText(numLinea, this.iface.COL_INCLUIR, "Sí");
	this.iface.tblAgentes_.setText(numLinea, this.iface.COL_CODIGO, codAgente);
	this.iface.tblAgentes_.setText(numLinea, this.iface.COL_AGENTE, util.sqlSelect("agentes", "nombreap", "codagente = '" + codAgente + "'"));
	this.iface.tblAgentes_.setText(numLinea, this.iface.COL_TOTAL, flfactppal.iface.pub_calcularLiquidacionAgente(filtro));
	this.iface.cambiarColorFilaTabla(this.iface.tblAgentes_, numLinea, this.iface.colorInc_);
}

function oficial_generarTabla()
{
	this.iface.COL_INCLUIR = 0;
	this.iface.COL_CODIGO = 1;
	this.iface.COL_AGENTE = 2;
	this.iface.COL_TOTAL = 3;

	this.iface.tblAgentes_.setNumCols(4);
	this.iface.tblAgentes_.setColumnWidth(this.iface.COL_INCLUIR, 60);
	this.iface.tblAgentes_.setColumnWidth(this.iface.COL_CODIGO, 100);
	this.iface.tblAgentes_.setColumnWidth(this.iface.COL_AGENTE, 300);
	this.iface.tblAgentes_.setColumnWidth(this.iface.COL_TOTAL, 100);
	this.iface.tblAgentes_.setColumnLabels("/", "Incluir/Agente/Nombre/Total");
}

function oficial_tbnFacturas_clicked()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	if (isNaN(this.iface.currentRow)) {
		MessageBox.warning(util.translate("scripts", "No hay ninguna liquidación seleccionada"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var codAgente:String = this.iface.tblAgentes_.text(this.iface.currentRow, this.iface.COL_CODIGO);
	if (!codAgente || codAgente == "") {
		MessageBox.warning(util.translate("scripts", "No hay ninguna liquidación seleccionada"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var f:Object = new FLFormSearchDB("busfactcli");
	var curFacturas:FLSqlCursor = f.cursor();

	var filtro:String = flfactppal.iface.pub_obtenFiltroFacturas(codAgente, cursor.valueBuffer("fechadesde"), cursor.valueBuffer("fechahasta"), cursor.valueBuffer("codejercicio"));
	
	curFacturas.setMainFilter(filtro);

	f.setMainWidget();
	var idFactura:String = f.exec("idfactura");
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
