/***************************************************************************
                 co_i_patrimonio.qs  -  description
                             -------------------
    begin                : jul 2010
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
	
	var tblDatos:QTable;
	var tedPrint:Object;
	var columnLabels:String;
	var rowLabels:String;

	function oficial( context ) { interna( context ); } 
	function reloadTabla() {
		return this.ctx.oficial_reloadTabla(); 
	}
	function sumarCeldas(col:Number, fil:Array, filResult:Number) {
		return this.ctx.oficial_sumarCeldas(col, fil, filResult);
	}
	function totalizar() {
		return this.ctx.oficial_totalizar(); 
	}
	function prepararImpresion() {
		return this.ctx.oficial_prepararImpresion(); 
	}
	function imprimirResultados() {
		return this.ctx.oficial_imprimirResultados();
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
	this.iface.tedPrint = this.child( "tedPrint" );

	this.iface.tblDatos = this.child("tblDatos");
	this.iface.reloadTabla();

	connect( this.child( "pbnImprimirResultados"), "clicked()", this, "iface.imprimirResultados" );
	connect( this.child( "pbnRecalcular"), "clicked()", this, "iface.totalizar" );
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_reloadTabla()
{
	var util:FLUtil = new FLUtil();
	
	var cursor:FLSqlCursor = this.cursor();
	
	var ejercicio:String = cursor.valueBuffer("codejercicio");
	var ejercicioAnt:String = cursor.valueBuffer("codejercicioant");
	
 	var agno:String = util.sqlSelect("ejercicios", "fechainicio", "codejercicio = '" + ejercicio + "'");
	agno = agno.toString().left(4);

 	var agnoAnt:String = util.sqlSelect("ejercicios", "fechainicio", "codejercicio = '" + ejercicioAnt + "'");
	agnoAnt = agnoAnt.toString().left(4);
	
	this.iface.tblDatos.clear();
	
	// Filas
	this.iface.tblDatos.insertRows(0,12);
	this.iface.rowLabels = "SALDO A FINAL DEL AÑO " + agnoAnt + ",  I - Ajustes por cambios de criterio " + agnoAnt + ",  II - Ajustes por errores " + agnoAnt + ",SALDO AJUSTADO A INICIO " + agno + ",  I. Resultado de pérdidas y ganancias,  II. Ingresos y gastos reconocidos en patrimonio neto,  III. Operaciones con socios o propietarios,    1. Aumentos de capital,    2. Reducciones de capital,    3. Otras operaciones,  IV. Otras variaciones del patrimonio neto,E. SALDO FINAL DEL AÑO " + agno;
	this.iface.tblDatos.setRowLabels(",", this.iface.rowLabels);

	// Columnas
	this.iface.tblDatos.setNumCols(11);
	this.iface.columnLabels = "Capital Escriturado,Capital No Exigido,Prima de Emisión,Reservas,Acciones y participaciones en patrimonio propias,Resultados de ejercicios anteriores,Otras aportaciones de socios,Resultado del ejercicio,Dividendo a cuenta,Subvenciones donaciones y legados recibidos,TOTAL";
	this.iface.tblDatos.setColumnLabels(",", this.iface.columnLabels);
	
	
/*	for (var i:Number = 0; i < 12; i++)
		for (var j:Number = 0; j < 11; j++)
			this.iface.tblDatos.setText(i, j, 0);*/
	
	
	var valor:Number;
	var filas:Array;

	var idAA = util.sqlSelect("ejercicios", "idasientoapertura", "codejercicio = '" + ejercicio + "'");
	if (!idAA)
		idAA = -1;
	
	var idAC = util.sqlSelect("ejercicios", "idasientocierre", "codejercicio = '" + ejercicio + "'");
	if (!idAC)
		idAC = -1;
	
	var idACAnt = util.sqlSelect("ejercicios", "idasientocierre", "codejercicio = '" + ejercicioAnt + "'");
	if (!idACAnt)
		idACAnt = -1;
	
	
	
	// CAPITAL ESCRITURADO ////////////////////
	
	// Saldo final anterior capital
	valor = util.sqlSelect("co_partidas", "sum(debe)", "codsubcuenta like '100%' and idasiento = " + idACAnt);
	this.iface.tblDatos.setText(0, 0, parseFloat(valor));
	
	// Saldo inicial
	valor = util.sqlSelect("co_partidas", "sum(haber)", "codsubcuenta like '100%' and idasiento = " + idAA);
	this.iface.tblDatos.setText(3, 0, parseFloat(valor));
	
	// Aumentos
	valor = util.sqlSelect("co_partidas p inner join co_asientos a on p.idasiento = a.idasiento", "sum(p.haber)", "p.codsubcuenta like '100%' and a.idasiento <> " + idAA + " and a.idasiento <> " + idAC + " and a.codejercicio = '" + ejercicio + "'", "co_partidas,co_asientos");
	this.iface.tblDatos.setText(7, 0, parseFloat(valor));
	
	// Reducciones
	valor = util.sqlSelect("co_partidas p inner join co_asientos a on p.idasiento = a.idasiento", "sum(p.debe)", "p.codsubcuenta like '100%' and a.idasiento <> " + idAA + " and a.idasiento <> " + idAC + " and a.codejercicio = '" + ejercicio + "'", "co_partidas,co_asientos");
	this.iface.tblDatos.setText(8, 0, 0 - parseFloat(valor));

	
	
	// CAPITAL NO EXIGIDO ////////////////////
	
	// Aumentos capital
	valor = util.sqlSelect("co_partidas p inner join co_asientos a on p.idasiento = a.idasiento", "sum(p.debe)", "p.codsubcuenta like '103%' and a.idasiento <> " + idAA + " and a.idasiento <> " + idAC + " and a.codejercicio = '" + ejercicio + "'", "co_partidas,co_asientos");
	this.iface.tblDatos.setText(7, 1, 0 - parseFloat(valor));

	
	
	
	
	// PRIMA DE EMISIÓN ///////////////////////
	
	// Aumentos
	valor = util.sqlSelect("co_partidas p inner join co_asientos a on p.idasiento = a.idasiento", "sum(p.haber)", "p.codsubcuenta like '110%' and a.idasiento <> " + idAA + " and a.idasiento <> " + idAC + " and a.codejercicio = '" + ejercicio + "'", "co_partidas,co_asientos");
	this.iface.tblDatos.setText(7, 2, parseFloat(valor));
	
	
	
	
	
	// RESERVAS //////////////////////////////
	
	var where:String = "(codsubcuenta like '111%' OR codsubcuenta like '112%' OR codsubcuenta like '113%' OR codsubcuenta like '114%' OR codsubcuenta like '115%' OR codsubcuenta like '116%' OR codsubcuenta like '117%' OR codsubcuenta like '118%')";
	
	// Saldo final anterior
	valor = util.sqlSelect("co_partidas", "sum(debe)", where + " and idasiento = " + idACAnt);
	this.iface.tblDatos.setText(0, 3, parseFloat(valor));
	
	// Errores
	valor = util.sqlSelect("co_partidas", "sum(haber)", where + " and idasiento = " + idACAnt);
	this.iface.tblDatos.setText(2, 3, 0 - parseFloat(valor));

	// Saldo inicial
	valor = util.sqlSelect("co_partidas", "sum(haber-debe)", where + " and idasiento = " + idAA);
	this.iface.tblDatos.setText(3, 3, parseFloat(valor));
	
	// Otras variaciones
	valor = util.sqlSelect("co_partidas p inner join co_asientos a on p.idasiento = a.idasiento", "sum(p.haber-p.debe)", where + " and a.idasiento <> " + idAA + " and a.idasiento <> " + idAC + " and a.codejercicio = '" + ejercicio + "'", "co_partidas,co_asientos");
	this.iface.tblDatos.setText(10, 3, parseFloat(valor));
	
	
	
	// RESULTADOS DE EJERCICIOS ANTERIORES //////////////////////////

	// Saldo final anterior
	valor = util.sqlSelect("co_partidas", "sum(debe-haber)", "(codsubcuenta like '120%' or codsubcuenta like '121%') and idasiento = " + idAC);
	this.iface.tblDatos.setText(0, 5, parseFloat(valor));
	
	// Saldo inicial
	this.iface.tblDatos.setText(3, 5, parseFloat(valor));

	// Otras operaciones con socios (reparto beneficios)
	valor = util.sqlSelect("co_partidas p inner join co_asientos a on p.idasiento = a.idasiento", "sum(p.haber)", "codsubcuenta like '557%' and a.idasiento <> " + idAA + " and a.idasiento <> " + idAC + " and a.codejercicio = '" + ejercicio + "'", "co_partidas,co_asientos");
	this.iface.tblDatos.setText(9, 5, 0 - parseFloat(valor));

	// Otras variaciones patrimonio (reservas)
	var where:String = "(codsubcuenta like '111%' OR codsubcuenta like '112%' OR codsubcuenta like '113%' OR codsubcuenta like '114%' OR codsubcuenta like '115%' OR codsubcuenta like '116%' OR codsubcuenta like '117%' OR codsubcuenta like '118%')";
	valor = util.sqlSelect("co_partidas p inner join co_asientos a on p.idasiento = a.idasiento", "sum(p.haber)", where + " and a.idasiento <> " + idAA + " and a.idasiento <> " + idAC + " and a.codejercicio = '" + ejercicio + "'", "co_partidas,co_asientos");
	this.iface.tblDatos.setText(10, 5, 0 - parseFloat(valor));

	

	
	// RESULTADOS DE EJERCICIO ACTUAL

	// Cuenta 129
	valor = util.sqlSelect("co_partidas p inner join co_asientos a on p.idasiento = a.idasiento", "sum(p.haber-p.debe)", "codsubcuenta like '129%' and a.idasiento <> " + idAA + " and a.idasiento <> " + idAC + " and a.codejercicio = '" + ejercicio + "'", "co_partidas,co_asientos");
	this.iface.tblDatos.setText(4, 7, parseFloat(valor));
	this.iface.tblDatos.setText(11, 7, parseFloat(valor));
	
	

	
	// DIVIDENDO A CUENTA

	// Saldo final anterior capital
	valor = util.sqlSelect("co_partidas", "sum(debe-haber)", "codsubcuenta like '557%' and idasiento = " + idACAnt);
	this.iface.tblDatos.setText(0, 8, parseFloat(valor));
	
	// Saldo inicial
	this.iface.tblDatos.setText(3, 8, parseFloat(valor));
	
	// Reducciones
	valor = util.sqlSelect("co_partidas p inner join co_asientos a on p.idasiento = a.idasiento", "sum(p.debe-p.haber)", "p.codsubcuenta like '557%' and a.idasiento <> " + idAA + " and a.idasiento <> " + idAC + " and a.codejercicio = '" + ejercicio + "'", "co_partidas,co_asientos");
	this.iface.tblDatos.setText(8, 8, 0 - parseFloat(valor));
	
	
	
	
	// SUBVENCIONES

	// Cuenta 130
	valor = util.sqlSelect("co_partidas p inner join co_asientos a on p.idasiento = a.idasiento", "sum(p.haber-p.debe)", "codsubcuenta like '130%' and a.idasiento <> " + idAA + " and a.idasiento <> " + idAC + " and a.codejercicio = '" + ejercicio + "'", "co_partidas,co_asientos");
	this.iface.tblDatos.setText(5, 9, parseFloat(valor));
	this.iface.tblDatos.setText(11, 9, parseFloat(valor));
	
	

	
	
	
	
	this.iface.totalizar();
}

function oficial_sumarCeldas(col:Number, fil:Array, filResult:Number)
{
	var valor:Number = 0;
	var valorCelda:Number;
	
	for (var i:Number = 0; i < fil.length; i++) {
		valorCelda = parseFloat(this.iface.tblDatos.text(fil[i], col));
		if (!valorCelda)
			valorCelda = 0;
		valor += valorCelda;
	}
	
	this.iface.tblDatos.setText(filResult, col, valor);
}


function oficial_totalizar()
{
	// CAPITAL
	
	// Operaciones con socios
	filas = new Array(7,8,9);
	this.iface.sumarCeldas(0, filas, 6);
		
	// Saldo final capital
	filas = new Array(3,6);
	this.iface.sumarCeldas(0, filas, 11);
	
	
	
	// CAPITAL NO EXIGIDO
	
	// Operaciones con socios
	filas = new Array(7,8,9);
	this.iface.sumarCeldas(1, filas, 6);
		
	// Saldo final capital
	filas = new Array(3,6);
	this.iface.sumarCeldas(1, filas, 11);
		

	
	// PRIMA DE EMISIÓN
	
	// Operaciones con socios
	filas = new Array(7,8,9);
	this.iface.sumarCeldas(2, filas, 6);
		
	// Saldo final
	filas = new Array(3,6);
	this.iface.sumarCeldas(2, filas, 11);
		
	
	
	// RESERVAS

	// Saldo final
	filas = new Array(3,10);
	this.iface.sumarCeldas(3, filas, 11);
	
	
	
	// RESULTADOS DE EJERCICIOS ANTERIORES

	// Operaciones con socios
	filas = new Array(7,8,9);
	this.iface.sumarCeldas(5, filas, 6);
	
	// Otras variaciones
 	filas = new Array(3,6,10);
 	this.iface.sumarCeldas(5, filas, 11);


	
	// DIVIDENDO A CUENTA
	
	// Operaciones con socios
	filas = new Array(7,8,9);
	this.iface.sumarCeldas(8, filas, 6);
		
	// Saldo final capital
	filas = new Array(3,6);
	this.iface.sumarCeldas(8, filas, 11);
	
	
	





	var valor:Number, valorCelda:Number;
	
	for (var i:Number = 0; i < 12; i++) {
		valor = 0;
		for (var j:Number = 0; j < 10; j++) {
			valorCelda = parseFloat(this.iface.tblDatos.text(i, j));
			if (!valorCelda)
				valorCelda = 0;
			valor += valorCelda;
		}
		this.iface.tblDatos.setText(i, 10, valor);
	}

	this.iface.prepararImpresion();
}

function oficial_prepararImpresion()
{
	var util:FLUtil = new FLUtil();

	var ejercicio:String = this.cursor().valueBuffer("codejercicio");
 	var agno:String = util.sqlSelect("ejercicios", "fechainicio", "codejercicio = '" + ejercicio + "'");
	agno = agno.toString().left(4);

	var dato:String;
	var html:String = "";

	html += "<table cellspacing=\"0\" border=\"1\">";

	var cols:Array = this.iface.columnLabels.split(",");
	var fils:Array = this.iface.rowLabels.split(",");
	
	html += "<tr>";
	html += "<td>&nbsp;</td>";
	for (var j:Number = 0; j < 11; j++) {
		html += "<td align=\"center\" valign=\"middle\">";
		html += "<font size=\"2\">";
		html += cols[j];
		html += "</font>";
		html += "</td>";
	}
	html += "</tr>";
	
	for (var i:Number = 0; i < 12; i++) {
		html += "<tr>";
		html += "<td>";
		html += "<font size=\"2\">";
		html += fils[i];
		html += "</font>";
		html += "</td>";
		for (var j:Number = 0; j < 11; j++) {
			html += "<td align=\"right\">";
			html += "<font size=\"2\">";
			if (this.iface.tblDatos.text(i, j) == 0)
				dato = ""
			else
				dato = util.formatoMiles(this.iface.tblDatos.text(i, j));
			html += dato;
			html += "</font>";
			html += "</td>";
		}
		html += "</tr>";
	}
	
	html += "</table>";
	
	this.iface.tedPrint.clear();
	this.iface.tedPrint.append("<h3>Estado de cambios en patrimonio neto correspondiente al ejercicio terminado el 31 de diciembre de " + agno + "</h3>");
	this.iface.tedPrint.append(html);
}

function oficial_imprimirResultados() 
{
	if ( this.iface.tedPrint.text.isEmpty() )
		return;

	sys.printTextEdit( this.iface.tedPrint );
}


//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
