/***************************************************************************
                 agruparpedidosprov.qs  -  description
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
		var estado:String;
		var currentRow:Number;
    function oficial( context ) { interna( context ); } 
		function tblPedidos_currentChanged(row:Number, col:Number) {
				return this.ctx.oficial_tblPedidos_currentChanged(row, col);
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
Este formulario agrupa distintos pedidos del mismo proveedor un único albarán. Es posible especificar los criterios que deben cumplir los pedidos a incluir. De la lista de pedidos que cumplen los criterios de búsqueda se generará un albarán por proveedor (ej. si los pedidos corresponden a dos proveedores se generarán dos albaranes).
\end */
function interna_init()
{
		this.iface.estado = "Buscando";
		this.iface.gestionEstado();
		var tblPedidos:QTable = this.child("tblPedidos");
		var cursor:FLSqlCursor = this.cursor();

		connect(this.child("pbnRefresh"), "clicked()", this, "iface.actualizar");
		connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
		connect(tblPedidos, "doubleClicked(int, int)", this, "iface.incluirFila");
		connect(tblPedidos, "currentChanged(int, int)", this, "iface.tblPedidos_currentChanged");
		connect(this.child("pushButtonAccept"), "clicked()", this, "iface.descontarExcepciones");
		connect(this.child("pbnAddDel"), "clicked()", this, "iface.pbnAddDel_clicked");

		this.child("fdbCodEjercicio").setValue(flfactppal.iface.pub_ejercicioActual());
		this.child("fdbCodEjercicio").setDisabled(true);

		var util:FLUtil = new FLUtil();
		var hoy:Date = new Date();
		this.child("fdbFecha").setValue(hoy);
		this.child("fdbFechaHasta").setValue(hoy);
		this.child("fdbFechaDesde").setValue(util.addDays(hoy,-1));

		tblPedidos.setNumCols(7);
		tblPedidos.setColumnWidth(0, 60);
		tblPedidos.setColumnWidth(1, 130);
		tblPedidos.setColumnWidth(2, 100);
		tblPedidos.setColumnWidth(3, 100);
		tblPedidos.setColumnWidth(4, 80);
		tblPedidos.setColumnWidth(5, 220);
		tblPedidos.setColumnLabels("/", "Incluir/Código/Fecha/Total/Proveedor/Nombre/idalbaran");
		tblPedidos.hideColumn(6);

		cursor.setValueBuffer("excepciones", "");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_tblPedidos_currentChanged(row:Number, col:Number)
{
		this.iface.currentRow = row;
}

function oficial_pbnAddDel_clicked()
{
		this.iface.incluirFila(this.iface.currentRow, 0);
}

function oficial_incluirFila(fila:Number, col:Number)
{
		var tblPedidos:QTable = this.child("tblPedidos");
		if (tblPedidos.numRows() == 0) return;
		if (tblPedidos.text(fila, 0) == "Sí")
				tblPedidos.setText(fila, 0, "No");
		else
				tblPedidos.setText(fila, 0, "Sí");
}

function oficial_bufferChanged(fN:String)
{
		switch (fN) {
		/** \C
		La modificación de alguno de los criterios de búsqueda habilita el botón 'Actualizar', de forma que puede realizarse una búsqueda de acuerdo a los nuevos criterios utilizados.
		\end */
		case "codproveedor":
		case "nombre":
		case "cifnif":
		case "codalmacen":
		case "fechadesde":
		case "fechahasta":
		case "codpago":
		case "coddivisa":
		case "codserie":
		case "codejercicio":{
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
		case "Buscando":{
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
Actualiza la lista de pedidos en función de los criterios de búsqueda especificados
\end */
function oficial_actualizar()
{
		var curPedidos:FLSqlCursor = new FLSqlCursor("pedidosprov");
		var tblPedidos:QTable = this.child("tblPedidos");
		var util:FLUtil = new FLUtil;
		var fila:Number;
		var numFilas:Number = tblPedidos.numRows();

		for (fila = 0; fila < numFilas; fila++)
				tblPedidos.removeRow(0);

		var where:String = formalbaranesprov.iface.pub_whereAgrupacion(this.cursor());
		where += " ORDER BY codproveedor,codalmacen DESC";
		if (!curPedidos.select(where))
				return;

		while (curPedidos.next()) {
				curPedidos.setModeAccess(curPedidos.Browse);
				curPedidos.refreshBuffer();
				with(tblPedidos) {
						insertRows(0);
						setText(0, 0, "Sí");
						setText(0, 1, curPedidos.valueBuffer("codigo"));
						setText(0, 2, util.dateAMDtoDMA(curPedidos.valueBuffer("fecha")));
						setText(0, 3, curPedidos.valueBuffer("total"));
						setText(0, 4, curPedidos.valueBuffer("codproveedor"));
						setText(0, 5, curPedidos.valueBuffer("nombre"));
						setText(0, 6, curPedidos.valueBuffer("idpedido"));
				}
		}
		this.iface.estado = "Seleccionando";
		this.iface.gestionEstado();

		if (tblPedidos.numRows() == 0)
				this.child("pushButtonAccept").enabled = false;
}

/** \D
Elabora un string en el que figuran, separados por comas, los identificadores de aquellos pedidos que el usuario haya marcado como 'No' (no incluir en la albarán). Este string se usará para ser incluido en una sentencia NOT IN en el select de los pedidos.

@return String con la lista de excepciones
\end */
function oficial_descontarExcepciones():Boolean
{
		var valor:Boolean = true;
		var cursor:FLSqlCursor = this.cursor();
		var tblPedidos:QTable = this.child("tblPedidos");
		var excepciones:String = "";
		var fila:Number;
		for (fila = 0; fila < tblPedidos.numRows(); fila++) {
				if (tblPedidos.text(fila, 0) == "No") {
						if (excepciones != "")
								excepciones += ", ";
						excepciones += tblPedidos.text(fila, 6);
				}
		}
		cursor.setValueBuffer("excepciones", excepciones);
		return valor;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
