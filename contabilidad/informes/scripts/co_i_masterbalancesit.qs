/***************************************************************************
                 i_masterbalancesit.qs  -  description
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
	var datos:Array;
	/*D
	Arrays auxiliares para guardar los totales intermedios del balance: A1, A2, ... 
	\end */
	var ejAct:String;
	var ejAnt:String;
	var mostrarEjAnt:Boolean;
	function oficial( context ) { interna( context ); } 
	function lanzar() {
		return this.ctx.oficial_lanzar();
	}
	function crearSit():Boolean {
		return this.ctx.oficial_crearSit();
	}
	function informarTablaSit() {
		return this.ctx.oficial_informarTablaSit();
	}
	function calcularValorPyG(ej:String, desde:String, hasta:String) {
		return this.ctx.oficial_calcularValorPyG(ej, desde, hasta);
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
PROCESO GENERAL. El balance de situación se crea de modo similar el de pérdidas y ganancias. El proceso seguido es el siguiente:

1. Una primera consulta obtiene los datos -tablas co_cuentas, co_codbalances, co_subcuentas, co_asientos y co_partidas- que determinan las líneas de más bajo nivel del informe: descripción de cuenta, cantidad y ejercicio. El ejercicio lo usaremos después para desglosar el informe con dos columnas de cantidades -una por ejercicio-.

2. El resultado de la consulta se introduce en el array Datos

3. Se calcula manualmente el saldo de la cuenta de pérdidas y ganancias, y se añade a Datos

4. El array Datos se vuelca en la tabla co_i_balancesit_buffer, que contiene naturaleza, nivel1, nivel2, nivel3, descripcion1, descripcion2, descripcion3, suma -cantidad- y ejercicio

5. La consulta definitiva se basa en un doble left outer join sobre la tabla co_i_balancesit_buffer -uno por cada ejercicio- que obtiene las cantidades correspondientes a cada ejercicio para presentarlas en el informe.

6. Al ejecutar el informe, para las líneas de primer nivel1 se calculan los totales sobre la marcha (A y B) o se leen directamente de la tabla de buffer
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
	var cursor:FLSqlCursor = this.cursor()
	if (!cursor.isValid())
		return;

	this.iface.idInforme = cursor.valueBuffer("id");
	if (!this.iface.idInforme) {
		return;
	}
	flcontinfo.iface.numPag = 0;

	this.iface.nombreInforme = cursor.action();

	flcontinfo.iface.pub_establecerInformeActual(this.iface.idInforme, this.iface.nombreInforme);

	this.iface.mostrarEjAnt = false;
	if (cursor.valueBuffer("ejercicioanterior"))
		this.iface.mostrarEjAnt = true;
	
	if (!this.iface.mostrarEjAnt)
		this.iface.nombreInforme += "_u";

	if (cursor.valueBuffer("consolidar"))
		this.iface.nombreInforme += "_c";

	if (!this.iface.crearSit())
		return;
	this.iface.informarTablaSit();

	var q:FLSqlQuery = new FLSqlQuery(cursor.action());
	var util:FLUtil = new FLUtil();

/** \D
Una segunda query es necesaria para elaborar el informe, y se ejecuta sobre la tabla co_i_balancesit_buffer. El where de esta consulta permite obtener las líneas de AI, AII, ... BI, BII... (dentro de los códigos de balance) Buf1 y Buf2 son las tablas buffer para ambos ejercicios
\end */
	if (this.iface.mostrarEjAnt) {
		q.setWhere("(cbl.naturaleza = 'ACTIVO' OR cbl.naturaleza = 'PASIVO') AND ( buf.sumaact != 0 OR buf.sumaant != 0 ) AND (c.codejercicio = '" + this.iface.ejAct + "' OR c.codejercicio = '" + this.iface.ejAnt + "') GROUP BY buf.sumaact, buf.sumaant, cbl.naturaleza, cbl.descripcion1, cbl.descripcion2, cbl.descripcion3, cbl.nivel1, cbl.nivel2, c.descripcion, c.codcuenta");
	} else {
		q.setWhere("(cbl.naturaleza = 'ACTIVO' OR cbl.naturaleza = 'PASIVO') AND buf.sumaact != 0 AND c.codejercicio = '" + this.iface.ejAct + "' GROUP BY buf.sumaact, buf.sumaant, cbl.naturaleza, cbl.descripcion1, cbl.descripcion2, cbl.descripcion3, cbl.nivel1, cbl.nivel2, c.descripcion, c.codcuenta");
	}
	q.setOrderBy("cbl.naturaleza, cbl.descripcion1, cbl.nivel2, cbl.descripcion3, c.codcuenta");
	if (q.exec() == false) {
		MessageBox.critical(util.translate("scripts", "Falló la 2ª consulta"),MessageBox.Ok, MessageBox.NoButton,MessageBox.NoButton);
		return;
	} else {
		if (q.first() == false) {
			MessageBox.warning(util.translate("scripts", "No hay registros que cumplan los criterios de búsqueda establecidos"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
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
Establece y ejecuta la consulta principal y así obtiene las líneas del informe correspondientes al último nivel: el de cuenta. Esto lo almacena en el array Datos.

@return True si se pudieron recoger los datos para el informe, false en caso contrario
\end */
function oficial_crearSit():Boolean
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	var desdeAct:String;
	var hastaAct:String;
	var asientoCierreAct:Number = -1;
	var asientoPygAct:Number = -1;
	
	var desdeAnt:String;
	var hastaAnt:String;
	var asientoCierreAnt:Number = -1;
	var asientoPygAnt:Number = -1;
	var asientoApeAct:Number = -1;
	var asientoApeAnt:Number = -1;
	
	desdeAct = cursor.valueBuffer("d_co__asientos_fechaact");
	hastaAct = cursor.valueBuffer("h_co__asientos_fechaact");
	this.iface.ejAct = cursor.valueBuffer("i_co__subcuentas_codejercicioact");
	
	// No tendremos en cuenta los asientos de cierre en el balance
	if (cursor.valueBuffer("ignorarcierre")) {	
		asientoCierreAct = util.sqlSelect("ejercicios", "idasientocierre", "codejercicio = '" + this.iface.ejAct + "'");
		asientoPygAct = util.sqlSelect("ejercicios", "idasientopyg", "codejercicio = '" + this.iface.ejAct + "'");
		asientoApeAct = util.sqlSelect("ejercicios", "idasientoapertura", "codejercicio = '" + this.iface.ejAct + "'");
	}

	this.iface.ejAnt = false;
	if (this.iface.mostrarEjAnt) {
		desdeAnt = cursor.valueBuffer("d_co__asientos_fechaant");
		hastaAnt = cursor.valueBuffer("h_co__asientos_fechaant");
		this.iface.ejAnt = cursor.valueBuffer("i_co__subcuentas_codejercicioant");
		if (cursor.valueBuffer("ignorarcierre")) {
			asientoCierreAnt = 	util.sqlSelect("ejercicios", "idasientocierre", "codejercicio = '" + this.iface.ejAnt + "'");
			asientoPygAnt = util.sqlSelect("ejercicios", "idasientopyg", "codejercicio = '" + this.iface.ejAnt + "'");
			asientoApeAnt = util.sqlSelect("ejercicios", "idasientoapertura", "codejercicio = '" + this.iface.ejAnt + "'");
		}
	}
	flcontinfo.iface.pub_establecerEjerciciosPYG(this.iface.ejAct, this.iface.ejAnt, this.iface.mostrarEjAnt);

/** \D
La consulta es compleja y se ejecuta sobre varias tablas. Las líneas obtenidas son aquellas pertenecientes a las partidas cuya subcuenta está asociada a un código de balance (a través de la cuenta) de naturaleza ACTIVO o PASIVO. La consulta extrae la suma del saldo de las subcuentas agrupadas por cuenta. Se extrae además el ejercicio, que se utilzará en caso de comparar o consolidar dos ejercicios.
\end */
	var q = new FLSqlQuery();

	q.setTablesList("co_cuentas,co_codbalances,co_subcuentas,co_asientos,co_partidas");

	q.setFrom("co_codbalances INNER JOIN co_cuentas ON co_cuentas.codbalance = co_codbalances.codbalance INNER JOIN co_subcuentas ON co_subcuentas.idcuenta = co_cuentas.idcuenta  INNER JOIN co_partidas ON co_subcuentas.idsubcuenta = co_partidas.idsubcuenta INNER JOIN co_asientos ON co_partidas.idasiento = co_asientos.idasiento");

	q.setSelect("co_cuentas.codcuenta, co_asientos.codejercicio, SUM(co_partidas.debe-co_partidas.haber), co_codbalances.naturaleza");

	if (this.iface.mostrarEjAnt) {
		q.setWhere("(co_codbalances.naturaleza = 'ACTIVO' OR co_codbalances.naturaleza = 'PASIVO')"
			+ " AND ( ((co_asientos.codejercicio = '" + this.iface.ejAct + "') " +
			" AND (co_asientos.idasiento <> '" + asientoCierreAct + "')" +
			" AND (co_asientos.idasiento <> '" + asientoPygAct + "')" +
			" AND (co_asientos.idasiento <> '" + asientoApeAct + "')" +
			" AND (co_asientos.fecha >= '" + desdeAct + "')" +
			" AND (co_asientos.fecha <= '" + hastaAct + "'))" +
			" OR  ((co_asientos.codejercicio = '" + this.iface.ejAnt + "') " +
			" AND (co_asientos.idasiento <> '" + asientoCierreAnt + "')" +
			" AND (co_asientos.idasiento <> '" + asientoPygAnt + "')" +
			" AND (co_asientos.fecha >= '" + desdeAnt + "')" +
			" AND (co_asientos.fecha <= '" + hastaAnt + "')) )" +
			" GROUP BY co_cuentas.codcuenta, co_asientos.codejercicio, co_codbalances.naturaleza, co_codbalances.nivel1, co_codbalances.nivel2, co_codbalances.nivel3 ORDER BY co_codbalances.naturaleza, co_codbalances.nivel1, co_codbalances.nivel2, co_codbalances.nivel3, co_cuentas.codcuenta");
	} else {
		q.setWhere("(co_codbalances.naturaleza = 'ACTIVO' OR co_codbalances.naturaleza = 'PASIVO')"
			+ " AND ( ((co_asientos.codejercicio = '" + this.iface.ejAct + "') " +
			" AND (co_asientos.idasiento <> '" + asientoCierreAct + "')" +
			" AND (co_asientos.idasiento <> '" + asientoPygAct + "')" +
			" AND (co_asientos.fecha >= '" + desdeAct + "')" +
			" AND (co_asientos.fecha <= '" + hastaAct + "')) )" +
			" GROUP BY co_cuentas.codcuenta, co_asientos.codejercicio, co_codbalances.naturaleza, co_codbalances.nivel1, co_codbalances.nivel2, co_codbalances.nivel3 ORDER BY co_codbalances.naturaleza, co_codbalances.nivel1, co_codbalances.nivel2, co_codbalances.nivel3, co_cuentas.codcuenta");
	}

debug(q.sql());

	var util:FLUtil = new FLUtil();
	if (q.exec() == false) {
		MessageBox.critical(util.translate("scripts", "Falló la 1ª consulta"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

/** \D
Los datos procedentes de la consulta se almacenan temporalmente en el array Datos
\end */
	var registro:Number = 0;
	var encontrados:Boolean = false;
	this.iface.datos = [];

	while (q.next()) {

		encontrados = true;

		this.iface.datos[registro] = new Array(3);
				
		this.iface.datos[registro]["codcuenta"] = q.value(0);
		this.iface.datos[registro]["codejercicio"] = q.value(1);
		this.iface.datos[registro]["suma"] = q.value(2);

		if (q.value(3) == "PASIVO")
			this.iface.datos[registro]["suma"] = 0 - q.value(2);
		registro++;
	}

	if (!encontrados) {
		MessageBox.warning(util.translate("scripts", "No hay registros que cumplan los criterios de búsqueda establecidos"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	return true;
}

/** \D
Vuelca los datos del Array en la tabla co_i_balancesit_buffer que actúa como buffer temporal. La consulta definitiva del informe se hará sobre esta tabla
\end */
function oficial_informarTablaSit()
{
	var cursor:FLSqlCursor = new FLSqlCursor("co_i_balancesit_buffer");
	var suma:Number;

	cursor.select();
	while (cursor.next()) {

			with(cursor) {
					setModeAccess(cursor.Del);
					refreshBuffer();
					commitBuffer();
			}
	}

	for (var i:Number = 0; i < this.iface.datos.length; i++) {
	
		cursor.select("codcuenta = '" + this.iface.datos[i]["codcuenta"] + "'");
		if (cursor.first()) {
			cursor.setModeAccess(cursor.Edit);
			cursor.refreshBuffer();
		}
		else {
			cursor.setModeAccess(cursor.Insert);
			cursor.refreshBuffer();
			cursor.setValueBuffer("codcuenta", this.iface.datos[i]["codcuenta"]);
		}

		// Balance consolidado
		if (this.cursor().valueBuffer("consolidar")) {
			suma = parseFloat(cursor.valueBuffer("sumaact")) + parseFloat(this.iface.datos[i]["suma"]);
			cursor.setValueBuffer("sumaact", suma);
		}
		// Balance normal
		else {
			if (this.iface.datos[i]["codejercicio"] == this.iface.ejAct) {
				suma = parseFloat(cursor.valueBuffer("sumaact")) + parseFloat(this.iface.datos[i]["suma"]);
				cursor.setValueBuffer("sumaact", suma);
			} else {
				suma = parseFloat(cursor.valueBuffer("sumaant")) + parseFloat(this.iface.datos[i]["suma"]);
				cursor.setValueBuffer("sumaant", suma);
			}
		}
		
		cursor.commitBuffer();
	}
	
/** \D
Para cada ejercicio se calcula el valor de pérdidas y ganancias, que irá a la cuenta de pérdidas y ganancias del informe (cuenta 129)
\end */
	desdeAct = this.cursor().valueBuffer("d_co__asientos_fechaact");
	hastaAct = this.cursor().valueBuffer("h_co__asientos_fechaact");
	this.iface.calcularValorPyG(this.iface.ejAct, desdeAct, hastaAct);
	
	if (this.iface.mostrarEjAnt) {
		desdeAnt = this.cursor().valueBuffer("d_co__asientos_fechaant");
		hastaAnt = this.cursor().valueBuffer("h_co__asientos_fechaant");
		this.iface.calcularValorPyG(this.iface.ejAnt, desdeAnt, hastaAnt);
	}
}

/** \D
Calcula el valor del saldo de la cuenta de pérdidas y ganancias, necesario para cuadrar el balance de situación. Hace un llamada a la función flcontinfo.resultadosEjercicio y calcula el saldo como la diferencia entre las pérdidas totales y ganancias totales

@param ej Ejercicio sobre el que se calcula el valor de pérdidas y ganancias
@param desde Fecha inicial del intervalo de cálculo dentro del ejercicio
@param hasta Fecha final del intervalo de cálculo dentro del ejercicio
@return Valor del saldo de la cuenta de pérdidas y ganancias
\end */
function oficial_calcularValorPyG(ej:String, desde:String, hasta:String)
{
	var cursor:FLSqlCursor = this.cursor();
	var valorPyG:Number = 0;
	var AB:Array = [];

	if (flcontinfo.iface.pub_resultadosEjercicio(AB, ej, desde, hasta, cursor.valueBuffer("ignorarcierre"))) {
			var AVI = AB["AVI"];
			var BVI = AB["BVI"];

			if (AVI > BVI)
					valorPyG = AVI
					else
					valorPyG = 0 - BVI;
					
	}
		
// 		var registro:Number = this.iface.datos.length;
// 		this.iface.datos[registro] = new Array(3);
// 		this.iface.datos[registro]["codcuenta"] = 129;
// 		this.iface.datos[registro]["suma"] = valorPyG;
// 		this.iface.datos[registro]["codejercicio"] = ej;		

	var cursor:FLSqlCursor = new FLSqlCursor("co_i_balancesit_buffer");

	cursor.select("codcuenta = 129");
	if (cursor.first()) {
		cursor.setModeAccess(cursor.Edit);
		cursor.refreshBuffer();
	}
	else {
		cursor.setModeAccess(cursor.Insert);
		cursor.refreshBuffer();
		cursor.setValueBuffer("codcuenta", 129);
	}

	if (ej == this.iface.ejAct)
		cursor.setValueBuffer("sumaact", valorPyG);
	else
		cursor.setValueBuffer("sumaant", valorPyG);
	
	cursor.commitBuffer();
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
		MessageBox.information(util.translate("scripts", "El plan contable del ejercicio actual es 2008.\nPara mostrar este informe deberá hacerlo desde la opción Cuentas anuales seleccionando el tipo Situacion"), MessageBox.Ok, MessageBox.NoButton);
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