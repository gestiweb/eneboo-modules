/**************************************************************************
                 agruparalbaranescli.qs  -  description
                             -------------------
    begin                : lun abr 26 2004
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var COL_INCLUIR:Number;
	var COL_CODIGO:Number;
	var COL_FECHA:Number;
	var COL_TOTAL:Number;
	var COL_CLIENTE:Number;
	var COL_NOMBRE:Number;
	var COL_IDALBARAN:Number;
	var estado:String;
	var currentRow:Number;
	var tblAlbaranes:QTable;
    function oficial( context ) { interna( context ); } 
	function tblAlbaranes_currentChanged(row:Number, col:Number) {
		return this.ctx.oficial_tblAlbaranes_currentChanged(row, col);
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
	function descontarExcepciones():Boolean {
		return this.ctx.oficial_descontarExcepciones();
	}
	function generarTabla() {
		return this.ctx.oficial_generarTabla();
	}
	function insertarLineaTabla(curAlbaranes:FLSqlCursor) {
		return this.ctx.oficial_insertarLineaTabla(curAlbaranes);
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
Este formulario agrupa distintos albaranes del mismo cliente una única factura. Es posible especificar los criterios que deben cumplir los albaranes a incluir. De la lista de albaranes que cumplen los criterios de búsqueda se generará una factura por cliente (ej. si los albaranes corresponden a dos clientes se generarán dos facturas).
\end */
function interna_init()
{
	this.iface.estado = "Buscando";
	this.iface.gestionEstado();
	this.iface.tblAlbaranes = this.child("tblAlbaranes");
	var cursor:FLSqlCursor = this.cursor();

	connect(this.child("pbnRefresh"), "clicked()", this, "iface.actualizar");
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this.iface.tblAlbaranes, "doubleClicked(int, int)", this, "iface.incluirFila");
	connect(this.iface.tblAlbaranes, "currentChanged(int, int)", this, "iface.tblAlbaranes_currentChanged");
	connect(this.child("pushButtonAccept"), "clicked()", this, "iface.descontarExcepciones");
	connect(this.child("pbnAddDel"), "clicked()", this, "iface.pbnAddDel_clicked");

	this.child("fdbCodEjercicio").setValue(flfactppal.iface.pub_ejercicioActual());
	this.child("fdbCodEjercicio").setDisabled(true);

	var util:FLUtil = new FLUtil();
	var hoy:Date = new Date();
	this.child("fdbFecha").setValue(hoy);
	this.child("fdbFechaHasta").setValue(hoy);
	this.child("fdbFechaDesde").setValue(util.addDays(hoy,-1));

	this.iface.generarTabla();

	cursor.setValueBuffer("excepciones", "");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_tblAlbaranes_currentChanged(row:Number, col:Number)
{
	this.iface.currentRow = row;
}

function oficial_pbnAddDel_clicked()
{
	this.iface.incluirFila(this.iface.currentRow, this.iface.COL_INCLUIR);
}

function oficial_incluirFila(fila:Number, col:Number)
{
	if (this.iface.tblAlbaranes.numRows() == 0) return;
	
	if (this.iface.tblAlbaranes.text(fila, this.iface.COL_INCLUIR) == "Sí") {
		this.iface.tblAlbaranes.setText(fila, this.iface.COL_INCLUIR, "No");
	} else {
		this.iface.tblAlbaranes.setText(fila, this.iface.COL_INCLUIR, "Sí");
	}
}

function oficial_bufferChanged(fN:String)
{
	switch (fN) {
	/** \C
	La modificación de alguno de los criterios de búsqueda habilita el botón 'Actualizar', de forma que puede realizarse una búsqueda de acuerdo a los nuevos criterios utilizados.
	\end */
		case "codcliente":
		case "nombrecliente":
		case "cifnif":
		case "codalmacen":
		case "fechadesde":
		case "fechahasta":
		case "codpago":
		case "coddivisa":
		case "codserie":
		case "codejercicio": {
			if (this.iface.estado == "Seleccionando") {
				this.iface.estado = "Buscando";
				this.iface.gestionEstado();
			}
			break;
		}
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
		this.child("pbnRefresh").enabled = true;
		this.child("pushButtonAccept").enabled = false;
		break;
	}
	case "Seleccionando":{
			this.child("pbnRefresh").enabled = false;
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
	var curAlbaranes:FLSqlCursor = new FLSqlCursor("albaranescli");
	var util:FLUtil = new FLUtil;
	var fila:Number;
	var numFilas:Number = this.iface.tblAlbaranes.numRows();

	for (fila = 0; fila < numFilas; fila++)
		this.iface.tblAlbaranes.removeRow(0);

	var where:String = formfacturascli.iface.pub_whereAgrupacion(this.cursor());
	where += " ORDER BY codcliente,codalmacen DESC";
	if (!curAlbaranes.select(where))
		return;

	while (curAlbaranes.next()) {
		curAlbaranes.setModeAccess(curAlbaranes.Browse);
		curAlbaranes.refreshBuffer();
		this.iface.insertarLineaTabla(curAlbaranes);
	}
	
	this.iface.estado = "Seleccionando";
	this.iface.gestionEstado();

	if (this.iface.tblAlbaranes.numRows() == 0)
		this.child("pushButtonAccept").enabled = false;
}

function oficial_insertarLineaTabla(curAlbaranes:FLSqlCursor)
{
	var util:FLUtil = new FLUtil;
	var numLinea:Number = this.iface.tblAlbaranes.numRows();
	this.iface.tblAlbaranes.insertRows(numLinea);
	this.iface.tblAlbaranes.setText(numLinea, this.iface.COL_INCLUIR, "Sí");
	this.iface.tblAlbaranes.setText(numLinea, this.iface.COL_CODIGO, curAlbaranes.valueBuffer("codigo"));
	this.iface.tblAlbaranes.setText(numLinea, this.iface.COL_FECHA, util.dateAMDtoDMA(curAlbaranes.valueBuffer("fecha")));
	this.iface.tblAlbaranes.setText(numLinea, this.iface.COL_TOTAL, util.roundFieldValue(curAlbaranes.valueBuffer("total"), "albaranescli", "total"));
	this.iface.tblAlbaranes.setText(numLinea, this.iface.COL_CLIENTE, curAlbaranes.valueBuffer("codcliente"));
	this.iface.tblAlbaranes.setText(numLinea, this.iface.COL_NOMBRE, curAlbaranes.valueBuffer("nombrecliente"));
	this.iface.tblAlbaranes.setText(numLinea, this.iface.COL_IDALBARAN, curAlbaranes.valueBuffer("idalbaran"));
}

/** \D
Elabora un string en el que figuran, separados por comas, los identificadores de aquellos albaranes que el usuario haya marcado como 'No' (no incluir en la factura). Este string se usará para ser incluido en una sentencia NOT IN en el select de los albaranes.

@return String con la lista de excepciones
\end */
function oficial_descontarExcepciones():Boolean
{
	var valor:Boolean = true;
	var cursor:FLSqlCursor = this.cursor();
	var excepciones:String = "";
	var fila:Number;
	for (fila = 0; fila < this.iface.tblAlbaranes.numRows(); fila++) {
		if (this.iface.tblAlbaranes.text(fila, this.iface.COL_INCLUIR) == "No") {
			if (excepciones != "") {
					excepciones += ", ";
			}
			excepciones += this.iface.tblAlbaranes.text(fila, this.iface.COL_IDALBARAN);
		}
	}
	cursor.setValueBuffer("excepciones", excepciones);
	return valor;
}

function oficial_generarTabla()
{
	this.iface.COL_INCLUIR = 0;
	this.iface.COL_CODIGO = 1;
	this.iface.COL_FECHA = 2;
	this.iface.COL_TOTAL = 3;
	this.iface.COL_CLIENTE = 4;
	this.iface.COL_NOMBRE = 5;
	this.iface.COL_IDALBARAN = 6;

	this.iface.tblAlbaranes.setNumCols(7);
	this.iface.tblAlbaranes.setColumnWidth(this.iface.COL_INCLUIR, 60);
	this.iface.tblAlbaranes.setColumnWidth(this.iface.COL_CODIGO, 130);
	this.iface.tblAlbaranes.setColumnWidth(this.iface.COL_FECHA, 100);
	this.iface.tblAlbaranes.setColumnWidth(this.iface.COL_TOTAL, 100);
	this.iface.tblAlbaranes.setColumnWidth(this.iface.COL_CLIENTE, 80);
	this.iface.tblAlbaranes.setColumnWidth(this.iface.COL_NOMBRE, 220);
	this.iface.tblAlbaranes.setColumnLabels("/", "Incluir/Código/Fecha/Total/Cliente/Nombre/idalbaran");
	this.iface.tblAlbaranes.hideColumn(this.iface.COL_IDALBARAN);
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
