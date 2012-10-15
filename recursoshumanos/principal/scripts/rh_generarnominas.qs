/**************************************************************************
                 rh_generarnominas.qs  -  description
                             -------------------
    begin                : lun sep 17 2007
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
		return this.ctx.interna_init();
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var estado:String;
	var currentRow:Number;
	var CODIGO:Number;
	var NOMBRE:Number;
	var APELLIDOS:Number;
	var SBRUTO:Number;
	var IRPF:Number;
	var SEGSOCIAL:Number;
	var DIETAS:Number;
	var SNETO:Number;
	var INCLUIR:Number;
	function oficial( context ) { interna( context ); }
	function tblNominas_currentChanged(row:Number, col:Number) {
		return this.ctx.oficial_tblNominas_currentChanged(row, col);
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
	function crearLista():Boolean {
		return this.ctx.oficial_crearLista();
	}
	function tbnDietas_clicked() {
		return this.ctx.oficial_tbnDietas_clicked();
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
	var tblNominas:QTable = this.child("tblNominas");
	var cursor:FLSqlCursor = this.cursor();

	connect(this.child("pbnRefresh"), "clicked()", this, "iface.actualizar");
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(tblNominas, "doubleClicked(int, int)", this, "iface.incluirFila");
	connect(tblNominas, "currentChanged(int, int)", this, "iface.tblNominas_currentChanged");
	connect(this.child("pushButtonAccept"), "clicked()", this, "iface.crearLista");
	connect(this.child("pbnAddDel"), "clicked()", this, "iface.pbnAddDel_clicked");
	connect(this.child("tbnDietas"), "clicked()", this, "iface.tbnDietas_clicked");

	this.child("fdbEjercicio").setValue(flfactppal.iface.pub_ejercicioActual());

	var util:FLUtil = new FLUtil();
	var hoy:Date = new Date();
	hoy.setDate(1);
	this.child("fdbFecha").setValue(hoy);

	this.iface.CODIGO = 0;
	this.iface.NOMBRE = 1;
	this.iface.APELLIDOS = 2;
	this.iface.SBRUTO = 3;
	this.iface.IRPF = 4;
	this.iface.SEGSOCIAL = 5;
	this.iface.DIETAS = 6;
	this.iface.SNETO = 7;
	this.iface.INCLUIR = 8;
	
	tblNominas.setNumCols(9);
	tblNominas.setColumnWidth(this.iface.CODIGO, 80);
	tblNominas.setColumnWidth(this.iface.NOMBRE, 120);
	tblNominas.setColumnWidth(this.iface.APELLIDOS, 140);
	tblNominas.setColumnWidth(this.iface.SBRUTO, 80);
	tblNominas.setColumnWidth(this.iface.IRPF, 80);
	tblNominas.setColumnWidth(this.iface.SEGSOCIAL, 80);
	tblNominas.setColumnWidth(this.iface.DIETAS, 80);
	tblNominas.setColumnWidth(this.iface.SNETO, 80);
	tblNominas.setColumnWidth(this.iface.INCLUIR, 60);
	tblNominas.setColumnLabels("/", "Código/Nombre/Apellidos/S. Bruto/IRPF/Seg. Social/Dietas/S. Neto/Incluir");
	//tblNominas.hideColumn(8);

	var diaUno:Date = new Date();
	diaUno = diaUno.setDate(1);
	this.child("fdbFechaNomina").setValue(diaUno);

	var hoy:Date = new Date();
	this.child("fdbFecha").setValue(hoy);

	cursor.setValueBuffer("lista", "");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_tblNominas_currentChanged(row:Number, col:Number)
{
	this.iface.currentRow = row;
}

function oficial_pbnAddDel_clicked()
{
	this.iface.incluirFila(this.iface.currentRow, 0);
}

function oficial_incluirFila(fila:Number, col:Number)
{
	var tblNominas:QTable = this.child("tblNominas");
	
	if (tblNominas.numRows() == 0) return;
	
	if (tblNominas.text(fila, this.iface.INCLUIR) == "Sí")
		tblNominas.setText(fila, this.iface.INCLUIR, "No");
	else
		tblNominas.setText(fila, this.iface.INCLUIR, "Sí");
}

function oficial_tbnDietas_clicked()
{
	var util:FLUtil = new FLUtil;
	var tblNominas:QTable = this.child("tblNominas");
	
	if (tblNominas.numRows() == 0) return;

	var fila:Number = this.iface.currentRow;

	if (tblNominas.text(fila, this.iface.DIETAS) == "") {
		var curNomina:FLSqlCursor = new FLSqlCursor("rh_nominas");
		curNomina.setModeAccess(curNomina.Insert);
		curNomina.refreshBuffer();
		curNomina.setValueBuffer("codempleado", tblNominas.text(fila, this.iface.CODIGO));
		var dietas:String = formRecordrh_nominas.iface.pub_commonCalculateField("dietasptes", curNomina);
		if (parseFloat(dietas) == 0) {
			MessageBox.warning(util.translate("scripts", "No hay dietas pendientes para el empleado seleccionado"), MessageBox.Ok, MessageBox.NoButton);
			return;
		}
		tblNominas.setText(fila, this.iface.DIETAS, dietas);
	} else {
		tblNominas.setText(fila, this.iface.DIETAS, "");
	}
}

function oficial_bufferChanged(fN:String)
{
	switch (fN) {
		/** \C
		La modificación de alguno de los criterios de búsqueda habilita el botón 'Actualizar', de forma que puede realizarse una búsqueda de acuerdo a los nuevos criterios utilizados.
		\end */
		case "fechanomina":
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
El estado 'Seleccionando' define la situación en la que el usuario ya ha buscado y puede generar la nomina o nominas
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
Actualiza la lista de empleados en función de los criterios de búsqueda especificados
\end */
function oficial_actualizar()
{
	var curEmpleados:FLSqlCursor = new FLSqlCursor("rh_empleados");
	var tblNominas:QTable = this.child("tblNominas");
	var util:FLUtil = new FLUtil;
	var fila:Number;
	var numFilas:Number = tblNominas.numRows();

	for (fila = 0; fila < numFilas; fila++)
		tblNominas.removeRow(0);

	var where:String = formrh_nominas.iface.pub_whereAgrupacion(this.cursor());
	where += " ORDER BY codempleado";
	if (!curEmpleados.select(where))
		return;

	var curNomina:FLSqlCursor = new FLSqlCursor("rh_nominas");
	curNomina.setModeAccess(curNomina.Insert);
	curNomina.refreshBuffer();

	while (curEmpleados.next()) {
		curEmpleados.setModeAccess(curEmpleados.Browse);
		curEmpleados.refreshBuffer();

		tblNominas.insertRows(0);
		curNomina.setValueBuffer("codempleado", curEmpleados.valueBuffer("codempleado"));
		tblNominas.setText(0, this.iface.CODIGO, curNomina.valueBuffer("codempleado"));

		tblNominas.setText(0, this.iface.NOMBRE, curEmpleados.valueBuffer("nombre"));

		tblNominas.setText(0, this.iface.APELLIDOS, curEmpleados.valueBuffer("apellidos"));

		curNomina.setValueBuffer("sueldobruto", formRecordrh_nominas.iface.pub_commonCalculateField("sueldobruto", curNomina));
		tblNominas.setText(0, this.iface.SBRUTO, curNomina.valueBuffer("sueldobruto"));

		curNomina.setValueBuffer("irpf", formRecordrh_nominas.iface.pub_commonCalculateField("irpf", curNomina));
		tblNominas.setText(0, this.iface.IRPF, curNomina.valueBuffer("irpf"));

		curNomina.setValueBuffer("segsocial", formRecordrh_nominas.iface.pub_commonCalculateField("segsocial", curNomina));
		tblNominas.setText(0, this.iface.SEGSOCIAL, curNomina.valueBuffer("segsocial"));

		curNomina.setValueBuffer("dietas", formRecordrh_nominas.iface.pub_commonCalculateField("dietasptes", curNomina));
		tblNominas.setText(0, this.iface.DIETAS, curNomina.valueBuffer("dietas"));

		curNomina.setValueBuffer("sueldoneto", formRecordrh_nominas.iface.pub_commonCalculateField("sueldoneto", curNomina));
		tblNominas.setText(0, this.iface.SNETO, curNomina.valueBuffer("sueldoneto"));

		tblNominas.setText(0, this.iface.INCLUIR, "Sí");
	}
	this.iface.estado = "Seleccionando";
	this.iface.gestionEstado();

	if (tblNominas.numRows() == 0)
		this.child("pushButtonAccept").enabled = false;
}

/** \D
Elabora un string en el que figuran, separados por comas, los identificadores de aquellos albaranes que el usuario haya marcado como 'No' (no incluir en la factura). Este string se usará para ser incluido en una sentencia NOT IN en el select de los albaranes.

@return String con la lista de excepciones
\end */
function oficial_crearLista():Boolean
{
	var valor:Boolean = true;
	var cursor:FLSqlCursor = this.cursor();
	var tblNominas:QTable = this.child("tblNominas");
	var fila:Number;
	var codEmpleado:String;

	var lista:String = "<FLNominas CodEjercicio='" + cursor.valueBuffer("codejercicio") + "' FechaNomina='" + cursor.valueBuffer("fechanomina") + "' Fecha='" + cursor.valueBuffer("fecha") + "'>";
	for (fila = 0; fila < tblNominas.numRows(); fila++) {
		if (tblNominas.text(fila, this.iface.INCLUIR) == "Sí") {
			codEmpleado = tblNominas.text(fila, this.iface.CODIGO);
			lista += "\t<FLNomina CodEmpleado='" + codEmpleado + "'>";
			if (tblNominas.text(fila, this.iface.DIETAS) != "") {
				var qryDietas:FLSqlQuery = new FLSqlQuery;
				with (qryDietas) {
					setTablesList("rh_dietas");
					setSelect("iddieta");
					setFrom("rh_dietas");
					setWhere("codempleado = '" + codEmpleado + "' AND codnomina IS NULL");
					setForwardOnly(true);
				}
				if (!qryDietas.exec())
					return;
				while (qryDietas.next()) {
					lista += "\t\t<FLDieta IdDieta='" + qryDietas.value("iddieta") + "'/>";
				}
			}
			lista += "\t</FLNomina>";
		}
	}
	lista += "</FLNominas>"
	cursor.setValueBuffer("lista", lista);
	return valor;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
