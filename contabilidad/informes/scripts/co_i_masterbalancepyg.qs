/***************************************************************************
                 i_masterbalancepyg.qs  -  description
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
	var nombreInforme:String;
	var idInforme:Number;
	/** \D @var datos
	Array que almacena los datos para el informe antes de introducirlos en la tabla buffer 
	\end */
	var datos:Array;;
	
	/** \D @var AB
	Array que almacena los datos de subtotales de pérdidas o ganancias que serán agregados al final del informe (valores AI - BVI)
	\end */
	var AB:Array;
	var ejAct:String;
	var ejAnt:String;
	var mostrarEjAnt:Boolean;
	function oficial( context ) { interna( context ); } 
	function lanzar() {
			return this.ctx.oficial_lanzar();
	}
	function crearPyG():Boolean {
			return this.ctx.oficial_crearPyG();
	}
	function rellenarDatosPyG(ej:String) {
			return this.ctx.oficial_rellenarDatosPyG(ej);
	}
	function informarTablaPyG() {
			return this.ctx.oficial_informarTablaPyG();
	}
	function resultadosPyG(tipo:Number):Boolean {
		return this.ctx.oficial_resultadosPyG(tipo);
	}
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration pgc2008 */
/////////////////////////////////////////////////////////////////
//// PGC2008 ////////////////////////////////////////////////////
class pgc2008 extends oficial {
    function pgc2008( context ) { oficial ( context ); }
	function lanzar() {
		return this.ctx.pgc2008_lanzar();
	}
}
//// PGC2008 ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends pgc2008 {
    function head( context ) { pgc2008 ( context ); }
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
/** \D
PROCESO GENERAL. El informe de pérdidas y ganancias es relativamente complejo. El proceso seguido es el siguiente:

1. Una primera consulta obtiene los datos -tablas co_cuentas, co_codbalances, co_subcuentas, co_asientos y co_partidas- que determinan las líneas de más bajo nivel del informe: descripción de cuenta, cantidad y ejercicio. El ejercicio lo usaremos después para desglosar el informe con dos columnas de cantidades -una por ejercicio-.

2. El resultado de la consulta se introduce en el array Datos

3. Se calculan manualmente las cantidades que corresponderán a las líneas del informe AI ... BVI, que se obtienen a partir de fórmulas 'oficiales'

4. Los datos anteriores se añaden al array Datos, que ya contiene todo lo necesario para el informe

5. El array Datos se vuelca en la tabla co_i_balancepyg_buffer, que contiene naturaleza, nivel1, nivel2, nivel3, descripcion1, descripcion2, descripcion3, suma -cantidad- y ejercicio

6. La consulta definitiva se basa en un doble left outer join sobre la tabla co_i_balancepyg_buffer -uno por cada ejercicio- que obtiene las cantidades correspondientes a cada ejercicio para presentarlas en el informe. En el where de la consulta se añaden las condiciones para que aparezcan tambien las lineas de perdidas y ganancias AI ... BVI

7. Al ejecutar el informe, para las líneas de primer nivel1 se calculan los totales sobre la marcha (A y B) o se leen directamente de la tabla de buffer
\end */
/** \C El botón de impresión lanza el informe
\end */
function interna_init()
{ 
		connect(this.child("toolButtonPrint"), "clicked()", this, "iface.lanzar()");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D
Lanza el informe
\end */
function oficial_lanzar()
{
	this.iface.AB =[];

	var cursor:FLSqlCursor = this.cursor()
	if (!cursor.isValid())
		return;

	this.iface.idInforme = cursor.valueBuffer("id");
	if (!this.iface.idInforme)
		return;

	flcontinfo.iface.numPag = 0;
	this.iface.nombreInforme = cursor.action();

	flcontinfo.iface.pub_establecerInformeActual(this.iface.idInforme, this.iface.nombreInforme);

	var consolidar:Boolean = false;
	var tipoSuma:Number = 0;
	
	if (cursor.valueBuffer("consolidar") == 1)
		consolidar = true;
	if (consolidar)
		this.iface.nombreInforme += "_c";


	this.iface.mostrarEjAnt = false;
	if (cursor.valueBuffer("ejercicioanterior") == 1)
		this.iface.mostrarEjAnt = true;
	if (!this.iface.mostrarEjAnt)
		this.iface.nombreInforme += "_u";

	flcontinfo.iface.pub_vaciarBuffer("co_i_balancepyg_buffer");	
	
	if (!this.iface.crearPyG())
		return;
		
	this.iface.informarTablaPyG();

	// Datos de pérdidas y ganancias
	this.iface.datos = [];
	
	if (consolidar)
		this.iface.resultadosPyG(2);
	else
		this.iface.resultadosPyG(0);
	this.iface.rellenarDatosPyG(this.iface.ejAct);
	
	if (!consolidar && this.iface.mostrarEjAnt) {
		this.iface.resultadosPyG(1);
		this.iface.rellenarDatosPyG(this.iface.ejAnt);
	}
	
	this.iface.informarTablaPyG();

/** \D
Una segunda query es necesaria para elaborar el informe, y se elecuta sobre la tabla co_i_balancepyg_buffer. El where de esta consulta permite obtener las líneas de AI, AII, ... BI, BII... (dentro de los códigos de balance) Buf1 y Buf2 son las tablas buffer para ambos ejercicios
\end */
	var q:FLSqlQuery = new FLSqlQuery(cursor.action());
	var util:FLUtil = new FLUtil();

	q.setOrderBy("buf.naturaleza, buf.nivel1, buf.nivel2, buf.codcuenta");

	if (q.exec() == false) {
		MessageBox.critical(util.translate("scripts", "Falló la 2ª consulta"),MessageBox.Ok, MessageBox.NoButton,MessageBox.NoButton);
			return;
	} 
	else {
		if (q.first() == false) {
			MessageBox.warning(util.translate("scripts", "No hay registros que cumplan los criterios de búsqueda establecidos"),MessageBox.Ok, MessageBox.NoButton,MessageBox.NoButton);
			return;
		}
	}
/** \D
   El report del informe es llamado directamente desde este script, ya que se ejecuta sobre la segunda consulta. No es llamado desde el flcontinfo.qs
\end */
	var rptViewer:FLReportViewer = new FLReportViewer();
	rptViewer.setReportTemplate(this.iface.nombreInforme);
	rptViewer.setReportData(q);
	rptViewer.renderReport();
	rptViewer.exec();
}

/** \D
Establece y ejecuta la consulta principal y así obtiene las líneas del informe correspondientes al último nivel: el de cuenta.
@return True si se pudieron recoger los datos para el informe, false en caso contrario
\end */
function oficial_crearPyG():Boolean
{
		var cursor:FLSqlCursor = this.cursor();
		var util:FLUtil = new FLUtil();

		var desdeAct:String;
		var hastaAct:String;
		var asientoPyG:Number = -1;
		var asientoPyGAnt:Number = -1;
		
		var desdeAnt:String;
		var hastaAnt:String;

		desdeAct = cursor.valueBuffer("d_co__asientos_fechaact");
		hastaAct = cursor.valueBuffer("h_co__asientos_fechaact");
		this.iface.ejAct = cursor.valueBuffer("i_co__subcuentas_codejercicioact");

		if (cursor.valueBuffer("ignorarcierre")) {
			asientoPyG = util.sqlSelect("ejercicios", "idasientopyg", "codejercicio = '" + this.iface.ejAct + "'");
		}
		
		if (this.iface.mostrarEjAnt) {
			desdeAnt = cursor.valueBuffer("d_co__asientos_fechaant");
			hastaAnt = cursor.valueBuffer("h_co__asientos_fechaant");
			this.iface.ejAnt = cursor.valueBuffer("i_co__subcuentas_codejercicioant");
			if (cursor.valueBuffer("ignorarcierre"))
				asientoPyGAnt = util.sqlSelect("ejercicios", "idasientopyg", "codejercicio = '" + this.iface.ejAnt + "'");
		}
		
		flcontinfo.iface.pub_establecerEjerciciosPYG(this.iface.ejAct, this.iface.ejAnt, this.iface.mostrarEjAnt);

/** \D
La consulta es compleja y se ejecuta sobre varias tablas. Las líneas obtenidas son aquellas pertenecientes a las partidas cuya subcuenta está asociada a un código de balance (a través de la cuenta) de naturaleza DEBE o HABER. La consulta extrae la suma del saldo de las subcuentas agrupadas por cuenta. Se extrae además el ejercicio, que se utilzará en caso de comparar o consolidar dos ejercicios.
\end */
		var q:FLSqlQuery = new FLSqlQuery();

		q.setTablesList
				("co_cuentas,co_codbalances,co_subcuentas,co_asientos,co_partidas");

		q.setFrom
				("co_codbalances INNER JOIN co_cuentas ON co_cuentas.codbalance = co_codbalances.codbalance INNER JOIN co_subcuentas ON co_subcuentas.idcuenta = co_cuentas.idcuenta INNER JOIN co_partidas ON co_subcuentas.idsubcuenta = co_partidas.idsubcuenta INNER JOIN co_asientos ON co_partidas.idasiento = co_asientos.idasiento");

		q.setSelect
				("co_codbalances.codbalance, co_codbalances.naturaleza, co_codbalances.nivel1, co_codbalances.nivel2, co_codbalances.nivel3,	co_codbalances.descripcion1, co_codbalances.descripcion2, co_codbalances.descripcion3, co_cuentas.codcuenta, co_cuentas.descripcion, 	SUM(co_partidas.debe-co_partidas.haber), co_asientos.codejercicio");

		if (this.iface.mostrarEjAnt) {
				q.setWhere
						("(co_codbalances.naturaleza = '" + util.translate("MetaData", "DEBE") + "' OR co_codbalances.naturaleza = '" + util.translate("MetaData", "HABER") + "')"
						 + " AND ( ((co_asientos.codejercicio = '" + this.iface.ejAct + "') " +
						 " AND (co_asientos.idasiento <> '" + asientoPyG + "')" +
						 " AND (co_asientos.fecha >= '" + desdeAct + "')" +
						 " AND (co_asientos.fecha <= '" + hastaAct + "'))" +
						 " OR  ((co_asientos.codejercicio = '" + this.iface.ejAnt + "') " +
						 " AND (co_asientos.idasiento <> '" + asientoPyGAnt + "')" +
						 " AND (co_asientos.fecha >= '" + desdeAnt + "')" +
						 " AND (co_asientos.fecha <= '" + hastaAnt + "')) )" +
						 " GROUP BY co_codbalances.codbalance, co_codbalances.naturaleza, co_codbalances.nivel1, co_codbalances.nivel2, co_codbalances.nivel3, co_codbalances.descripcion1, co_codbalances.descripcion2, co_codbalances.descripcion3, co_cuentas.codcuenta, co_cuentas.descripcion,  co_asientos.codejercicio ORDER BY co_codbalances.naturaleza, co_codbalances.nivel1, co_codbalances.nivel2, co_codbalances.nivel3, co_cuentas.codcuenta");
		} else {
				q.setWhere
						("(co_codbalances.naturaleza = '" + util.translate("MetaData", "DEBE") + "' OR co_codbalances.naturaleza = '" + util.translate("MetaData", "HABER") + "')"
						 + " AND ( ((co_asientos.codejercicio = '" + this.iface.ejAct + "') " +
						 " AND (co_asientos.idasiento <> '" + asientoPyG + "')" +
						 " AND (co_asientos.fecha >= '" + desdeAct + "')" +
						 " AND (co_asientos.fecha <= '" + hastaAct + "') ))" +
						 " GROUP BY co_codbalances.codbalance, co_codbalances.naturaleza, co_codbalances.nivel1, co_codbalances.nivel2, co_codbalances.nivel3, co_codbalances.descripcion1, co_codbalances.descripcion2, co_codbalances.descripcion3, co_cuentas.codcuenta, co_cuentas.descripcion,  co_asientos.codejercicio ORDER BY co_codbalances.naturaleza, co_codbalances.nivel1, co_codbalances.nivel2, co_codbalances.nivel3, co_cuentas.codcuenta");
		}

		
		var util:FLUtil = new FLUtil();
		if (q.exec() == false) {
				MessageBox.critical(util.
														translate("scripts", "Falló la 1ª consulta"),
														MessageBox.Ok, MessageBox.NoButton,
														MessageBox.NoButton);
				return false;
		}

		var registro:Number = 0;
		var encontrados:Boolean = false;
		this.iface.datos = [];

/** \D
Los datos procedentes de la consulta se almacenan temporalmente en el array Datos
\end */
		while (q.next()) {

				encontrados = true;

				this.iface.datos[registro] = new Array(2);
				this.iface.datos[registro]["codbalance"] = q.value(0);
				this.iface.datos[registro]["naturaleza"] = q.value(1);
				this.iface.datos[registro]["nivel1"] = q.value(2);
				this.iface.datos[registro]["nivel2"] = q.value(3);
				this.iface.datos[registro]["nivel3"] = q.value(4);
				this.iface.datos[registro]["descripcion1"] = q.value(5);
				this.iface.datos[registro]["descripcion2"] = q.value(6);
				this.iface.datos[registro]["descripcion3"] = q.value(7);
				this.iface.datos[registro]["codcuenta"] = q.value(8);
				this.iface.datos[registro]["desccuenta"] = q.value(9);
				this.iface.datos[registro]["suma"] = q.value(10);
				this.iface.datos[registro]["codejercicio"] = q.value(11);

				// Control de variación de existencias.
				codCuenta = this.iface.datos[registro]["codcuenta"];
				if (codCuenta.left(2) == "71") {
					suma = flcontinfo.iface.pub_mudarCuentasExistencias(this.iface.datos[registro]);
					this.iface.datos[registro]["suma"] = suma;
				}

				if (q.value(1) == "HABER")
						this.iface.datos[registro]["suma"] = 0 - q.value(10);

				registro++;
		}

		if (!encontrados) {
				MessageBox.warning(util.
													 translate("scripts",
																		 "No hay registros que cumplan los criterios de búsqueda establecidos"),
													 MessageBox.Ok, MessageBox.NoButton,
													 MessageBox.NoButton);
				return false;
		}

		if (this.iface.datos.length == 0)
				return false;

		return true;
}

/** \D
Añade al array Datos las líneas correspondientes a beneficios y pérdidas: AI ... BVI previamente calculados

@param ej Código del ejercicio cuyos datos serán guardados
\end */
function oficial_rellenarDatosPyG(ej:String)
{
		var util:FLUtil = new FLUtil();
		var indicesAB:Array = new Array("I", "II", "III", "IV", "V", "VI");
		var where:String;
		var descripcion1:String;
		var registro:Number = this.iface.datos.length;
		var codBalance:String;

		for (var i:Number = 0; i < indicesAB.length; i++) {

				codBalance = "D-" + indicesAB[i];
				descripcion1 =
						util.sqlSelect("co_codbalances", "descripcion1",
													 "codbalance = '" + codBalance + "'");

				this.iface.datos[registro] = new Array(2);
				this.iface.datos[registro]["codbalance"] = codBalance;
				this.iface.datos[registro]["naturaleza"] = "DEBE";
				this.iface.datos[registro]["nivel1"] = indicesAB[i];
				this.iface.datos[registro]["nivel2"] = "";
				this.iface.datos[registro]["nivel3"] = "";
				this.iface.datos[registro]["descripcion1"] = descripcion1;
				this.iface.datos[registro]["descripcion2"] = "";
				this.iface.datos[registro]["descripcion3"] = "";
				this.iface.datos[registro]["codcuenta"] = "";
				this.iface.datos[registro]["desccuenta"] = "";
				this.iface.datos[registro]["suma"] = this.iface.AB["A" + indicesAB[i]];
				this.iface.datos[registro]["codejercicio"] = ej;
				registro++;


				codBalance = "H-" + indicesAB[i];
				descripcion1 =
						util.sqlSelect("co_codbalances", "descripcion1",
													 "codbalance = '" + codBalance + "'");

				this.iface.datos[registro] = new Array(2);
				this.iface.datos[registro]["codbalance"] = "H-" + indicesAB[i];
				this.iface.datos[registro]["naturaleza"] = "HABER";
				this.iface.datos[registro]["nivel1"] = indicesAB[i];
				this.iface.datos[registro]["nivel2"] = "";
				this.iface.datos[registro]["nivel3"] = "";
				this.iface.datos[registro]["descripcion1"] = descripcion1;
				this.iface.datos[registro]["descripcion2"] = "";
				this.iface.datos[registro]["descripcion3"] = "";
				this.iface.datos[registro]["codcuenta"] = "";
				this.iface.datos[registro]["desccuenta"] = "";
				this.iface.datos[registro]["suma"] = this.iface.AB["B" + indicesAB[i]];
				this.iface.datos[registro]["codejercicio"] = ej;
				registro++;
		}
/** \D
Al terminar el array Datos ya contiene toda la información necesaria para realizar el informe: las líneas a nivel de cuenta con las sumas de saldos y las líneas de beneficios y pérdidas
\end */

}



/** \D
Vuelca los datos del Array en la tabla co_i_balancepyg_buffer que actúa como buffer temporal. La consulta definitiva del informe se hará sobre esta tabla
\end */
function oficial_informarTablaPyG()
{
		var i:Number;
		var suma:Number;
		var cursor:FLSqlCursor = new FLSqlCursor("co_i_balancepyg_buffer");

		for (var i:Number = 0; i < this.iface.datos.length; i++) {
				
				cursor.select("codcuenta = '" + this.iface.datos[i]["codcuenta"] + "' " +
					"AND naturaleza = '" + this.iface.datos[i]["naturaleza"] + "' " +
					"AND nivel1 = '" + this.iface.datos[i]["nivel1"] + "' " +
					"AND nivel2 = '" + this.iface.datos[i]["nivel2"] + "'");
					
				if (cursor.first()) {
					cursor.setModeAccess(cursor.Edit);
					cursor.refreshBuffer();
				}
				else {
					cursor.setModeAccess(cursor.Insert);
					cursor.refreshBuffer();
					cursor.setValueBuffer("codcuenta", this.iface.datos[i]["codcuenta"]);
					cursor.setValueBuffer("codbalance", this.iface.datos[i]["codbalance"]);
					cursor.setValueBuffer("naturaleza", this.iface.datos[i]["naturaleza"]);
					cursor.setValueBuffer("nivel1", this.iface.datos[i]["nivel1"]);
					cursor.setValueBuffer("nivel2", this.iface.datos[i]["nivel2"]);
					cursor.setValueBuffer("nivel3", this.iface.datos[i]["nivel3"]);
					cursor.setValueBuffer("descripcion1", this.iface.datos[i]["descripcion1"]);
					cursor.setValueBuffer("descripcion2", this.iface.datos[i]["descripcion2"]);
					cursor.setValueBuffer("descripcion3", this.iface.datos[i]["descripcion3"]);
					cursor.setValueBuffer("desccuenta", this.iface.datos[i]["desccuenta"]);
				}		
				
				// Balance consolidado
				if (this.cursor().valueBuffer("consolidar")) {
					suma = parseFloat(cursor.valueBuffer("sumaact")) + parseFloat(this.iface.datos[i]["suma"]);
					cursor.setValueBuffer("sumaact", suma);
				}
				// Balance normal
				else {
					if (this.iface.datos[i]["codejercicio"] == this.iface.ejAct)
						cursor.setValueBuffer("sumaact", this.iface.datos[i]["suma"]);
					else
						cursor.setValueBuffer("sumaant", this.iface.datos[i]["suma"]);
				}
				
				cursor.commitBuffer();
				
		}
}

/** \D Realiza el cálculo de resultados del ejercicio en cuanto a pérdidas y ganancias
a partir de los datos existentes en el buffer.
@param AB Array pasado por variable donde se guardarán los resultados
@param Tipo 0: Ejercicio actual, 1: Ejercicio Anterior, 2 Suma actual + anterior
\end */
function oficial_resultadosPyG(tipo:Number):Boolean
{
	var A:Array = [];
	var B:Array = [];
	var dat:Array = [];

	for (i = 1; i <=20 ; i++) {
		A[i] = 0;
		B[i] = 0;
	}
	
	var suma:String;
	switch(tipo) {
		case 0:
			suma = "sumaact";
		break;
		case 1:
			suma = "sumaant";
		break;
		case 2:
			suma = "sumaact+sumaant";
		break;
	}
	
	var util:FLUtil = new FLUtil();
	
	q = new FLSqlQuery();
	q.setTablesList("co_i_balancepyg_buffer");
	q.setFrom("co_i_balancepyg_buffer");
	q.setSelect("nivel1, nivel2, " + suma + ", naturaleza");

	var util:FLUtil = new FLUtil();
	if (!q.exec())
		return false;
	
	if (!q.size())
		return false;
		
	while(q.next()) {
	
		if (q.value(3) == "DEBE") {
			A[q.value(1)] += parseFloat(q.value(2));
		}
		else {
			B[q.value(1)] += parseFloat(q.value(2));
		}
	}


	/** \D Se aplican las fórmulas contables para calcular los valores AI - BVI que aparecerán en el informe de pérdidas y ganancias:
	
	AI BENEFICIOS DE EXPLOTACION (B1+B2+B3+B4-A1-A2-A3-A4-A5-A6)
	
	AII RESULTADOS FINANCIEROS POSITIVOS (B5+B6+B7+B8-A7-A8-A9)
	
	AIII BENEFICIOS DE LAS ACTIVIDADES ORDINARIAS (AI+AII-BI-BII)
	
	AIV RESULTADOS EXTRAORDINARIOS POSITIVOS(B9+B10+B11+B12+B13-A10-A11-A12-A13-A14)
	
	AV BENEFICIOS ANTES DE IMPUESTOS (AIII+AIV-BIII-BIV)
	
	AVI RESULTADOS DEL EJERCICIO (BENEFICIOS) (AV-A15-A16)
	
	BI PERDIDAS DE EXPLOTACION (A1+A2+A3+A4+A5+A6-B1-B2-B3-B4)
	
	BII RESULTADOS FINANCIEROS NEGATIVOS (A7+A8+A9-B5-B6-B7-B8)
	
	BIII PERDIDAS DE LAS ACTIVIDADES ORDINARIAS (BI+BII-AI-AII)
	
	BIV RESULTADOS EXTRAORDINARIOS NEGATIVOS (A10+A11+A12+A13+A14-B9-B10-B11-B12-B13)
	
	BV PERDIDAS ANTES DE IMPUESTOS (BIII+BIV-AIII-AIV)
	
	BVI RESULTADO DEL EJERCICIO (PERDIDAS) (BV+A15+A16)
	\end */
	this.iface.AB["AI"] =
			B[1] + B[2] + B[3] + B[4] - A[1] - A[2] - A[3] - A[4] - A[5] -
			A[6];
			
	this.iface.AB["AII"] = B[5] + B[6] + B[7] + B[8] - A[7] - A[8] - A[9];
	if (this.iface.AB["AI"] < 0)
			this.iface.AB["AI"] = 0;
	if (this.iface.AB["AII"] < 0)
			this.iface.AB["AII"] = 0;

	this.iface.AB["BI"] =
			A[1] + A[2] + A[3] + A[4] + A[5] + A[6] - B[1] - B[2] - B[3] -
			B[4];
					
	this.iface.AB["BII"] = A[7] + A[8] + A[9] - B[5] - B[6] - B[7] - B[8];
	if (this.iface.AB["BI"] < 0)
			this.iface.AB["BI"] = 0;
	if (this.iface.AB["BII"] < 0)
			this.iface.AB["BII"] = 0;

	this.iface.AB["AIII"] = parseFloat(this.iface.AB["AI"] + this.iface.AB["AII"] - this.iface.AB["BI"] - this.iface.AB["BII"]);
	this.iface.AB["AIV"] =
			B[9] + B[10] + B[11] + B[12] + B[13] - A[10] - A[11] - A[12] -
			A[13] - A[14];
	if (this.iface.AB["AIII"] < 0)
			this.iface.AB["AIII"] = 0;
	if (this.iface.AB["AIV"] < 0)
			this.iface.AB["AIV"] = 0;

	this.iface.AB["BIII"] = this.iface.AB["BI"] + this.iface.AB["BII"] - this.iface.AB["AI"] - this.iface.AB["AII"];
	this.iface.AB["BIV"] =
			A[10] + A[11] + A[12] + A[13] + A[14] - B[9] - B[10] - B[11] -
			B[12] - B[13];
	if (this.iface.AB["BIII"] < 0)
			this.iface.AB["BIII"] = 0;
	if (this.iface.AB["BIV"] < 0)
			this.iface.AB["BIV"] = 0;

	this.iface.AB["AV"] = this.iface.AB["AIII"] + this.iface.AB["AIV"] - this.iface.AB["BIII"] - this.iface.AB["BIV"];
	this.iface.AB["BV"] = this.iface.AB["BIII"] + this.iface.AB["BIV"] - this.iface.AB["AIII"] - this.iface.AB["AIV"];
	if (this.iface.AB["AV"] < 0)
			this.iface.AB["AV"] = 0;
	if (this.iface.AB["BV"] < 0)
			this.iface.AB["BV"] = 0;

	this.iface.AB["AVI"] = this.iface.AB["AV"] - A[15] - A[16];
	this.iface.AB["BVI"] = this.iface.AB["BV"] + A[15] + A[16];
	
	if (this.iface.AB["AV"] == 0)
		this.iface.AB["AVI"] = 0;

	if (this.iface.AB["AVI"] < 0)
			this.iface.AB["AVI"] = 0;
	if (this.iface.AB["BVI"] < 0 || this.iface.AB["AVI"] > 0)
			this.iface.AB["BVI"] = 0;

	return true;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pgc2008 */
/////////////////////////////////////////////////////////////////
//// PGC2008 ////////////////////////////////////////////////////
function pgc2008_lanzar()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor()
	if (!cursor.isValid()) {
		return;
	}

	var ejercicioActual:String = cursor.valueBuffer("i_co__subcuentas_codejercicioact");
	var planContable:String = util.sqlSelect("ejercicios", "plancontable", "codejercicio = '" + ejercicioActual + "'");
	if (planContable == "08") {
		MessageBox.information(util.translate("scripts", "El plan contable del ejercicio actual es 2008.\nPara mostrar este informe deberá hacerlo desde la opción 'Cuentas anuales' seleccionando el tipo 'Perdidas y ganancias'"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	} else {
		this.iface.__lanzar();
	}
}

//// PGC2008 ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////