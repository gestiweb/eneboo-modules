/***************************************************************************
                 flcontinfo.qs  -  description
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
	/** \D @var idInformeActual
	Id dentro de la tabla del informe que está siendo procesado \end */
	var idInformeActual:Number;
	/** \D @var nombreInformeActual
	Nombre del informe que está siendo procesado \end */
	var nombreInformeActual:String;
	var ejActPYG:String;
	var ejAntPYG:String;
	var mostrarEjAnt:Boolean = false;
	var numPag:Number = 0;
	var debeDiario:Number = 0;
	var haberDiario:Number = 0;
	/** \D @var numFactura
	Variable global para almacenar el número de factura en los listados de
	I.V.A. con numeración automática \end */
	var numFactura:Number = 0;

	var aAcumFacturas_:Array;

	var baseTotal:Number;
	var baseImp4:Number;
	var baseImp7:Number;
	var baseImp16:Number;
	var baseImpUE:Number;
	var baseImpEX:Number;
	var baseImpImp:Number;
	var ivaTotal:Number;
	var iva4:Number;
	var iva7:Number;
	var iva16:Number;
	var ivaUE:Number;
	var ivaEX:Number;
	var ivaImp:Number;
	var re4:Number;
	var re7:Number;
	var re16:Number;
	var reUE:Number;
	var total4:Number;
	var total7:Number;
	var total16:Number;
	var totalUE:Number;
	var totalEX:Number;
	var totalImp:Number;


    function oficial( context ) { interna( context ); } 
	function lanzarInforme(cursor:FLSqlCursor, nombreInforme:String, nombreReport:String, orderBy:String, groupBy:String, masWhere:String, idInforme:Number) {
			return this.ctx.oficial_lanzarInforme(cursor, nombreInforme, nombreReport, orderBy, groupBy, masWhere, idInforme);
	}
	function obtenerSigno(s:String):String {
			return this.ctx.oficial_obtenerSigno(s);
	}
	function fieldName(s:String):String {
			return this.ctx.oficial_fieldName(s);
	}
	function establecerEjerciciosPYG(act:String, ant:String, mEjAnt:Boolean) {
			return this.ctx.oficial_establecerEjerciciosPYG(act, ant, mEjAnt);
	}
	function establecerInformeActual(id:Number, nombre:String) {
			return this.ctx.oficial_establecerInformeActual(id, nombre);
	}
	function parcialesPyG(nodo:FLDomNode, campo:String):String {
			return this.ctx.oficial_parcialesPyG(nodo, campo);
	}
	function parcialesPyG_c(nodo:FLDomNode, campo:String):String {
			return this.ctx.oficial_parcialesPyG_c(nodo, campo);
	}
	function cabeceraPyG(nodo:FLDomNode, campo:String):String {
			return this.ctx.oficial_cabeceraPyG(nodo, campo);
	}
	function descuadreDiario(nodo:FLDomNode, campo:String):Number {
			return this.ctx.oficial_descuadreDiario(nodo, campo);
	}
	function cabeceraInforme(nodo:FLDomNode, campo:String):String {
			return this.ctx.oficial_cabeceraInforme(nodo, campo);
	}
	function resultadosEjercicio(AB:Array, ej:String, desde:String, hasta:String, ignorarCierre:Boolean):Boolean {
			return this.ctx.oficial_resultadosEjercicio(AB, ej, desde, hasta, ignorarCierre);
	}
	function sumarPyG(dat:Array, naturaleza:String, nivel1:String, nivel2:String, codEjercicio:String):Number {
			return this.ctx.oficial_sumarPyG(dat, naturaleza, nivel1, nivel2, codEjercicio);
	}
	function sumarPyGNoAbs(dat:Array, naturaleza:String, nivel1:String, nivel2:String, codEjercicio:String):Number {
			return this.ctx.oficial_sumarPyGNoAbs(dat, naturaleza, nivel1, nivel2, codEjercicio);
	}
	function comprobarConsolidacion(ej1:String, ej2:String):Boolean {
			return this.ctx.oficial_comprobarConsolidacion(ej1, ej2);
	}
	function resetearNumFactura(numDesde:Number) {
			return this.ctx.oficial_resetearNumFactura(numDesde);
	}
	function numerarFacturas(nodo:FLDomNode, campo:String)  {
			return this.ctx.oficial_numerarFacturas(nodo, campo);
	}
	function mudarCuentasExistencias(registro:Array):Number  {
			return this.ctx.oficial_mudarCuentasExistencias(registro);
	}
	function vaciarBuffer(tabla:String):Boolean {
		return this.ctx.oficial_vaciarBuffer(tabla);
	}
	function iniciarValores(nodo:FLDomNode, campo:String):String {
		return this.ctx.oficial_iniciarValores(nodo, campo);
	}
	function acumularValoresEmi(nodo:FLDomNode, campo:String):String {
		return this.ctx.oficial_acumularValoresEmi(nodo, campo);
	}
	function acumularValoresRec(nodo:FLDomNode, campo:String):String {
		return this.ctx.oficial_acumularValoresRec(nodo, campo);
	}
	function mostrarValores(nodo:FLDomNode, campo:String):String {
		return this.ctx.oficial_mostrarValores(nodo, campo);
	}
	function nombreEmpresa(nodo:FLDomNode, campo:String):String {
		return this.ctx.oficial_nombreEmpresa(nodo, campo);
	}
	function acumularFactura(id:String, baseImp:Number, cuota:Number, tipo:Number, recargo:Number):Boolean {
		return this.ctx.oficial_acumularFactura(id, baseImp, cuota, tipo, recargo);
	}
	function ordenarAcumFacturas() {
		return this.ctx.oficial_ordenarAcumFacturas();
	}
	function compararAcumFacturas(a:Array, b:Array):Number {
		return this.ctx.oficial_compararAcumFacturas(a, b);
	}
	function debeDiarioMes(nodo:FLDomNode, campo:String):String {
		return this.ctx.oficial_debeDiarioMes(nodo, campo);
	}
	function haberDiarioMes(nodo:FLDomNode, campo:String):String {
		return this.ctx.oficial_haberDiarioMes(nodo, campo);
	}
	function descuadreDiarioMes(nodo:FLDomNode, campo:String):String {
		return this.ctx.oficial_descuadreDiarioMes(nodo, campo);
	}
	function sumaDebeDiarioMes(nodo:FLDomNode, campo:String):String {
		return this.ctx.oficial_sumaDebeDiarioMes(nodo, campo);
	}
	function sumaHaberDiarioMes(nodo:FLDomNode, campo:String):String {
		return this.ctx.oficial_sumaHaberDiarioMes(nodo, campo);
	}
}

//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
 
/** @class_declaration pgc2008 */
/////////////////////////////////////////////////////////////////
//// PGC 2008 //////////////////////////////////////////////////////
class pgc2008 extends oficial {
	var parciales08:Array;
	var parciales08ant:Array;
    function pgc2008( context ) { oficial ( context ); }
	function lanzarBalance(cursor:FLSqlCursor, csv:Boolean) {
		return this.ctx.pgc2008_lanzarBalance(cursor, csv);
	}
	function cargarQryReport(cursor:FLSqlCursor):Array {
		return this.ctx.pgc2008_cargarQryReport(cursor);
	}
	function popularBuffer(ejercicio:String, posicion:String, idBalance:Number, fechaDesde:String, fechaHasta:String, tablaCB:String, masWhere:String) {
		return this.ctx.pgc2008_popularBuffer(ejercicio, posicion, idBalance, fechaDesde, fechaHasta, tablaCB, masWhere);
	}	
	function vaciarBuffer08(idBalance:Number) {
		return this.ctx.pgc2008_vaciarBuffer08(idBalance);
	}	
	
	function completarPGB18(posicion:String, idBalance:Number) {
		return this.ctx.pgc2008_completarPGB18(posicion, idBalance);
	}	
	function resultadoEjercicio08(posicion:String, idBalance:Number) {
		return this.ctx.pgc2008_resultadoEjercicio08(posicion, idBalance);
	}	

	function labelBalances08(nodo:FLDomNode, campo:String):String {
		return this.ctx.pgc2008_labelBalances08(nodo, campo);
	}
	function recalcularDatosBalance(curTab:FLSqlCursor):Boolean {
		return this.ctx.pgc2008_recalcularDatosBalance(curTab);
	}
	function calcularSubTotalesBalances08(idBalance:Number) {
		return this.ctx.pgc2008_calcularSubTotalesBalances08(idBalance);
	}
	function subTotalesBalances08(nodo:FLDomNode, campo:String):String {
		return this.ctx.pgc2008_subTotalesBalances08(nodo, campo);
	}
	function cabeceraInforme(nodo:FLDomNode, campo:String):String {
		return this.ctx.pgc2008_cabeceraInforme(nodo, campo);
	}
	function cuentasSinCB(codEjercicio:String, abreviado:Boolean):Boolean {
		return this.ctx.pgc2008_cuentasSinCB(codEjercicio, abreviado);
	}
	function volcarCsv(qryInforme:FLSqlQuery):Boolean {
		return this.ctx.pgc2008_volcarCsv(qryInforme);
	}
}
//// PGC 2008 //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends pgc2008 {
    function head( context ) { pgc2008 ( context ); }
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubPgc2008 */
/////////////////////////////////////////////////////////////////
//// PUB_PGC2008 ////////////////////////////////////////////////
class pubPgc2008 extends head {
    function pubPgc2008( context ) { head( context ); }
	function pub_cargarQryReport(cursor:FLSqlCursor):Array {
		return this.cargarQryReport(cursor);
	}
}

//// PUB_PGC2008 ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration ifaceCtx */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends pubPgc2008 {
    function ifaceCtx( context ) { pubPgc2008( context ); }
	function pub_lanzarInforme(cursor:FLSqlCursor, nombreInforme:String, nombreReport:String, orderBy:String, groupBy:String, masWhere:String, idInforme:Number) {
			return this.lanzarInforme(cursor, nombreInforme, nombreReport, orderBy, groupBy, masWhere, idInforme);
	}
	function pub_establecerInformeActual(id:Number, nombre:String) {
			return this.establecerInformeActual(id, nombre);
	}
	function pub_establecerEjerciciosPYG(act:String, ant:String, mEjAnt:Boolean) {
			return this.establecerEjerciciosPYG(act, ant, mEjAnt);
	}
	function pub_resultadosEjercicio(AB:Array, ej:String, desde:String, hasta:String, ignorarCierre):Boolean {
			return this.resultadosEjercicio(AB, ej, desde, hasta, ignorarCierre);
	}
	function pub_comprobarConsolidacion(ej1:String, ej2:String):Boolean {
			return this.comprobarConsolidacion(ej1, ej2);
	}
	function pub_resetearNumFactura(numDesde:Number) {
			return this.resetearNumFactura(numDesde);
	}
	function pub_cabeceraInforme(nodo:FLDomNode, campo:String):String {
			return this.cabeceraInforme(nodo, campo);
	}
	function pub_numerarFacturas(nodo:FLDomNode, campo:String)  {
			return this.numerarFacturas(nodo, campo);
	}
	function pub_parcialesPyG(nodo:FLDomNode, campo:String):String {
			return this.parcialesPyG(nodo, campo);
	}
	function pub_parcialesPyG_c(nodo:FLDomNode, campo:String):String {
			return this.parcialesPyG_c(nodo, campo);
	}
	function pub_cabeceraPyG(nodo:FLDomNode, campo:String):String {
			return this.cabeceraPyG(nodo, campo);
	}
	function pub_descuadreDiario(nodo:FLDomNode, campo:String):Number {
			return this.descuadreDiario(nodo, campo);
	}
	function pub_mudarCuentasExistencias(registro:Array):Number {
			return this.mudarCuentasExistencias(registro);
	}
	function pub_vaciarBuffer(tabla:String):Boolean {
		return this.vaciarBuffer(tabla);
	}
	function pub_iniciarValores(nodo:FLDomNode, campo:String):String {
		return this.iniciarValores(nodo, campo);
	}
	function pub_acumularValoresEmi(nodo:FLDomNode, campo:String):String {
		return this.acumularValoresEmi(nodo, campo);
	}
	function pub_acumularValoresRec(nodo:FLDomNode, campo:String):String {
		return this.acumularValoresRec(nodo, campo);
	}
	function pub_mostrarValores(nodo:FLDomNode, campo:String):String {
		return this.mostrarValores(nodo, campo);
	}
	function pub_nombreEmpresa(nodo:FLDomNode, campo:String):String {
		return this.nombreEmpresa(nodo, campo);
	}
	function pub_ordenarAcumFacturas(nodo:FLDomNode, campo:String):String {
		return this.ordenarAcumFacturas(nodo, campo);
	}
	function pub_debeDiarioMes(nodo:FLDomNode, campo:String):String {
		return this.debeDiarioMes(nodo, campo);
	}
	function pub_haberDiarioMes(nodo:FLDomNode, campo:String):String {
		return this.haberDiarioMes(nodo, campo);
	}
	function pub_descuadreDiarioMes(nodo:FLDomNode, campo:String):String {
		return this.descuadreDiarioMes(nodo, campo);
	}
	function pub_sumaDebeDiarioMes(nodo:FLDomNode, campo:String):String {
		return this.sumaDebeDiarioMes(nodo, campo);
	}
	function pub_sumaHaberDiarioMes(nodo:FLDomNode, campo:String):String {
		return this.sumaHaberDiarioMes(nodo, campo);
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
function interna_init() {

}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D
Lanza el informe

@param cursor Cursor de la tabla del informe
@param nombreInforme Nombre del informe. Se utiliza en distintas funciones, generalmente como nombre de la tabla que contiene los datos del informe
@param nombreReport Nombre del fichero .kut que contiene la estructura del informe
@param orderBy Valor de ORDER BY en la consulta del informe. Puede omitirse
@param groupBy Valor de GROUP BY en la consulta del informe. Puede omitirse
@param masWhere Valor que se añade al WHERE en la consulta del informe. Puede omitirse
@param idInforme Valor del campo identificador del informe en la tabla del informe
\end */
function oficial_lanzarInforme(cursor:FLSqlCursor, nombreInforme:String, nombreReport:String, orderBy:String,
											 groupBy:String, masWhere:String, idInforme:Number)
{
		this.iface.numPag = 0;
		this.iface.debeDiario = 0;
		this.iface.haberDiario = 0;

		if (idInforme)
				this.iface.idInformeActual = idInforme;

		this.iface.nombreInformeActual = nombreInforme;
		if(nombreInforme.endsWith("_mes")) {
			this.iface.nombreInformeActual = nombreInforme.left(nombreInforme.length-4);
			
		}

/** \D A la hora de establecer condiciones lógicas en las consultas de los informes, los campos que definen estas condiciones son denominados en la tabla con:

Una primera letra (i, d, h) que indica el tipo de comparación (igual, menor o igual, mayor o igual)
El nombre de la tabla donde se han de buscar los valores en la consulta
El nombre del campo a comparar

Estos tres valores se separan por '_', si existe un '_' en alguno de ellos, éste se duplica

Ejemplo: d_co__asientos_numero en el informe de diario indica que ese campo en la tabla del informe contiene el valor del número de asiento menor que saldrá en el informe. 'd' indice 'desde' o 'mayor o igual que', 'co_asientos' es el nombre de la tabla y 'numero' el nombre del campo
\end */
		
		var q:FLSqlQuery = new FLSqlQuery(nombreInforme);
		var util:FLUtil = new FLUtil();
		var fieldList:String = util.nombreCampos(cursor.table());
		var cuenta:Number = parseFloat(fieldList[0]);
		var signo:String;
		var fN:String;
		var valor:String;
		var primerCriterio:Boolean = false;
		var where:String = "";
		for (var i:Number = 1; i <= cuenta; i++) {
				signo = this.iface.obtenerSigno(fieldList[i]);
				if (signo != "") {
						fN = this.iface.fieldName(fieldList[i]);
						valor = cursor.valueBuffer(fieldList[i]);
						if (valor == "Sí")
								valor = 1;
						if (valor == "No")
								valor = 0;
						if (valor == "Todos")
								valor = "";
						if (!valor.toString().isEmpty()) {
								if (primerCriterio == true)
										where += "AND ";
								where += fN + " " + signo + " '" + valor + "' ";
								primerCriterio = true;
						}
				}
		}

		if (masWhere)
				where += " " + masWhere;

		if (groupBy)
				where += " GROUP BY " + groupBy;

		q.setWhere(where);
		if (orderBy) {
			q.setOrderBy(orderBy);
		}
		q.setForwardOnly(true);

		util.createProgressDialog(util.translate("scripts", "Preparando informe..."), 100);
		util.setProgress(5);
		
debug(q.sql());	
		if (!q.exec()) {
				MessageBox.critical(util.translate("scripts", "Falló la consulta"),
														MessageBox.Ok, MessageBox.NoButton,
														MessageBox.NoButton);
				util.setProgress(0);
				util.destroyProgressDialog();
				return;
		} else {
				if (!q.first()) {
						MessageBox.warning(util.
															 translate("scripts",
																				 "No hay registros que cumplan los criterios de búsqueda establecidos"),
															 MessageBox.Ok, MessageBox.NoButton,
															 MessageBox.NoButton);
						util.setProgress(0);
						util.destroyProgressDialog();
						return;
				}
		}

		for (var prog:Number = 5; prog < 50; prog++)
				util.setProgress(prog);

		if (!nombreReport)
				nombreReport = nombreInforme;
		var rptViewer:FLReportViewer = new FLReportViewer();

		rptViewer.setReportTemplate(nombreReport);

		rptViewer.setReportData(q);

		for (var prog:Number = 50; prog < 100; prog++)
				util.setProgress(prog);
		util.setProgress(100);
		util.destroyProgressDialog();
		rptViewer.renderReport();
		flfactinfo.iface.pub_mostrarInformeVisor(rptViewer);
}

/** \D Obtiene los operadores lógicos a utilizar en las comparaciones del WHERE de la consulta, en función del nombre de un campo en el informe (ejemplo: d_codsubcuenta produce la cadena '>=' al contener 'd_', esto es, 'desde')

@param s Nombre del campo en la tabla del informe
@return Operador lógico de comparación
\end */
function oficial_obtenerSigno(s:String):String
{
		if (s.toString().charAt(1) == "_") {
				switch (s.toString().charAt(0)) {
				case "d":{
								return ">=";
						}
				case "h":{
								return "<=";
						}
				case "i":{
								return "=";
						}
				}
		}
		return "";
}

/** \D Convierte el nombre de un campo de una tabla de informe en un nombre de tabla más un nombre de campo separados por un punto. Se utiliza en campos que definen condiciones lógicas en la consulta del informe como 'igual a', 'mayor o igual que' o 'menor o igual que'. Ejemplo: d_co__asientos_numero como entrada daría como resultado co_asientos.numero

Sustituye '_' por '.'; dos '_' seguidos indica que realmente es '_'

@param s Nombre del campo en la tabla del informe
@return Nombre de campo.Nombre de tabla
\end */
function oficial_fieldName(s:String):String
{
		var fN:String = "";
		var c:String;
		for (var i:Number = 2; (s.toString().charAt(i)); i++) {
				c = s.toString().charAt(i);
				if (c == "_")
						if (s.toString().charAt(i + 1) == "_") {
								fN += "_";
								i++;
						} else
								fN += "."
								else
								fN += s.toString().charAt(i);
		}
		return fN;
}

/** \D Establece las variables globales de código de ejercicio actual y anterior. Se llama desde otros scripts

@param act Código del ejercicio actual
@param ant Código del ejercicio anterior
\end */
function oficial_establecerEjerciciosPYG(act:String, ant:String, mEjAnt:Boolean)
{
		this.iface.ejActPYG = act;
		this.iface.ejAntPYG = ant;
		this.iface.mostrarEjAnt = mEjAnt;
}

/** \D Establece las variables globales idInformeActual y nombreInformeActual. Se llama desde otros scripts

@param id Código del informe actual
@param nombre Nombre del informe actual
\end */
function oficial_establecerInformeActual(id:Number, nombre:String)
{
		this.iface.idInformeActual = id;
		this.iface.nombreInformeActual = nombre;
}

/** \D Calcula la subtotales del informe de pérdidas y ganancias. Es llamado desde los campos del informe dentro del archivo .kut. El cálculo se efectúa en base a la naturaleza, nivel 1 del código de balance y cuenta; con estos datos se hace una consulta sobre la tabla co_i_balancepyg_buffer que contiene temporalmente todas las  sumas de saldos de cuentas que intervienen en el informe.

@param nodo Nodo del informe que contiene niveles del campo del informe que se pretende calcular: naturaleza, nivel1 y descripcion1
@param campo Indica la columna del informe perteneciente al ejercicio: 0 para el actual y 1 para el anterior, en caso de comparar dos ejercicios
@return Valor del subtotal calculado
\end */
function oficial_parcialesPyG(nodo:FLDomNode, campo:String):String
{

		var codEjercicios:Array = new Array(this.iface.ejActPYG, this.iface.ejAntPYG);
		var codEjercicio:String = codEjercicios[campo];

		var select:String, where:String;

		if (campo == 0) 
			select = "sumaact";
		else
			select = "sumaant";

		var naturaleza:String = nodo.attributeValue("buf.naturaleza");
		var nivel1:String = nodo.attributeValue("buf.nivel1");

		if (nivel1 == "A" || nivel1 == "B") {
			where =	"naturaleza = '" + naturaleza + "' AND nivel2 <> ''";
			select = "SUM(" + select + ")";
		} else {
			where =	"naturaleza = '" + naturaleza + "' AND nivel1 = '" + nivel1 + "' AND nivel2 = ''";
		}

		var q:FLSqlQuery = new FLSqlQuery();

		q.setTablesList("co_i_balancepyg_buffer");
		q.setFrom("co_i_balancepyg_buffer");
		q.setSelect(select);
		q.setWhere(where);

		if (!q.exec())
				return 0;
		if (!q.first())
				return 0;

		return q.value(0);
}

/** \D Calcula la subtotales del informe de pérdidas y ganancias en un balance de dos ejercicio CONSOLIDADO. Es llamado desde los campos del informe dentro del archivo .kut. El cálculo se efectúa en base a la naturaleza, nivel 1 del código de balance y cuenta; con estos datos se hace una consulta sobre la tabla co_i_balancepyg_buffer que contiene temporalmente todas las sumas de saldos de cuentas que intervienen en el informe.

@param nodo Nodo del informe que contiene niveles del campo del informe que se pretende calcular: naturaleza, nivel1 y descripcion1
@param campo Indica la columna del informe perteneciente al ejercicio: 0 para el actual y 1 para el anterior
@return Valor del subtotal calculado
\end */
function oficial_parcialesPyG_c(nodo:FLDomNode, campo:String):String
{
		var where:String;

		var naturaleza:String = nodo.attributeValue("cbl.naturaleza");
		var nivel1:String = nodo.attributeValue("cbl.nivel1");
		var desc1:String = nodo.attributeValue("cbl.descripcion1");

		var q:FLSqlQuery = new FLSqlQuery();
		q.setTablesList("co_i_balancepyg_buffer");
		q.setFrom("co_i_balancepyg_buffer");
		q.setSelect("SUM(suma)");


		if (nivel1 != "A" && nivel1 != "B") {

				where =
						"naturaleza = 'DEBE' AND nivel1 = '" + nivel1 +
						"' AND nivel2 = '' AND (codejercicio = '" + this.iface.ejActPYG +
						"' OR codejercicio = '" + this.iface.ejAntPYG + "')";

				q.setWhere(where);
				if (!q.exec())
						return 0;
				if (!q.first())
						return 0;

				var valorDebe:Number = parseFloat(q.value(0));

				where =
						"naturaleza = 'HABER' AND nivel1 = '" + nivel1 +
						"' AND nivel2 = '' AND (codejercicio = '" + this.iface.ejActPYG +
						"' OR codejercicio = '" + this.iface.ejAntPYG + "')";

				q.setWhere(where);
				if (!q.exec())
						return 0;
				if (!q.first())
						return 0;

				var valorHaber:Number = parseFloat(q.value(0));

				if ((naturaleza == "DEBE") && (valorDebe > valorHaber))
						return valorDebe - valorHaber;
				if ((naturaleza == "HABER") && (valorDebe < valorHaber))
						return valorHaber - valorDebe;

				return 0;
		}

		else {
				where =
						"naturaleza = '" + naturaleza +
						"' AND nivel2 <> '' AND (codejercicio = '" + this.iface.ejActPYG +
						"' OR codejercicio = '" + this.iface.ejAntPYG + "')";

				q.setWhere(where);

				if (!q.exec())
						return 0;
				if (!q.first())
						return 0;

				return q.value(0);
		}
}

/** \D Calcula la subtotales del informe de pérdidas y ganancias en un balance de dos ejercicio CONSOLIDADO. Es llamado desde los campos del informe dentro del archivo .kut. El cálculo se efectúa en base a la naturaleza, nivel 1 del código de balance y cuenta; con estos datos se hace una consulta sobre la tabla co_i_balancepyg_buffer que contiene temporalmente todas las sumas de saldos de cuentas que intervienen en el informe.

@param nodo Nodo del informe que contiene niveles del campo del informe que se pretende calcular: naturaleza, nivel1 y descripcion1
@param campo Indica la columna del informe perteneciente al ejercicio: 0 para el actual y 1 para el anterior
@return Valor del subtotal calculado
\end */
function oficial_parcialesPyG_c(nodo:FLDomNode, campo:String):String
{
		var where:String;

		var naturaleza:String = nodo.attributeValue("cbl.naturaleza");
		var nivel1:String = nodo.attributeValue("cbl.nivel1");
		var desc1:String = nodo.attributeValue("cbl.descripcion1");

		var q:FLSqlQuery = new FLSqlQuery();
		q.setTablesList("co_i_balancepyg_buffer");
		q.setFrom("co_i_balancepyg_buffer");
		q.setSelect("SUM(suma)");


		if (nivel1 != "A" && nivel1 != "B") {

				where =
						"naturaleza = 'DEBE' AND nivel1 = '" + nivel1 +
						"' AND nivel2 = '' AND (codejercicio = '" + this.iface.ejActPYG +
						"' OR codejercicio = '" + this.iface.ejAntPYG + "')";

				q.setWhere(where);
				if (!q.exec())
						return 0;
				if (!q.first())
						return 0;

				var valorDebe:Number = parseFloat(q.value(0));

				where =
						"naturaleza = 'HABER' AND nivel1 = '" + nivel1 +
						"' AND nivel2 = '' AND (codejercicio = '" + this.iface.ejActPYG +
						"' OR codejercicio = '" + this.iface.ejAntPYG + "')";

				q.setWhere(where);
				if (!q.exec())
						return 0;
				if (!q.first())
						return 0;

				var valorHaber:Number = parseFloat(q.value(0));

				if ((naturaleza == "DEBE") && (valorDebe > valorHaber))
						return valorDebe - valorHaber;
				if ((naturaleza == "HABER") && (valorDebe < valorHaber))
						return valorHaber - valorDebe;

				return 0;
		}

		else {
				where =
						"naturaleza = '" + naturaleza +
						"' AND nivel2 <> '' AND (codejercicio = '" + this.iface.ejActPYG +
						"' OR codejercicio = '" + this.iface.ejAntPYG + "')";

				q.setWhere(where);

				if (!q.exec())
						return 0;
				if (!q.first())
						return 0;

				return q.value(0);
		}
}

/** \D Devuelve el nombre de un ejercicio. Utilizado para los encabezados de informe de pérdidas y ganancias

@param nodo Nodo del informe que contiene niveles del campo del informe que se pretende calcular: naturaleza, nivel1 y descripcion1
@param campo Indica la columna del informe perteneciente al ejercicio: 0 para el actual y 1 para el anterior
@return Nombre del ejercicio
\end */
function oficial_cabeceraPyG(nodo:FLDomNode, campo:String):String
{
		var util:FLUtil = new FLUtil();
		var texCampo:String = new String(campo);
		var codEjercicio:String;

		switch (texCampo) {
		case "act":
				codEjercicio = this.iface.ejActPYG;
				break;
		case "ant":
				codEjercicio = this.iface.ejAntPYG;
				break;
		case "actant":
				return "";
				break;
		}
		return util.sqlSelect("ejercicios", "nombre", "codejercicio = '" + codEjercicio + "'");
}

/** \D Obtiene el descuadre total para el informe de diario

@param nodo Nodo del informe que contiene niveles del campo del informe que se pretende calcular: naturaleza, nivel1 y descripcion1
@param campo Indica la columna del informe perteneciente al ejercicio: 0 para el actual y 1 para el anterior
@return Valor total de descuadre para el informe de diario
\end */
function oficial_descuadreDiario(nodo:FLDomNode, campo:String):Number
{
		var texCampo:String = new String(campo);
		var qCondiciones:FLSqlQuery = new FLSqlQuery();

		qCondiciones.setTablesList(this.iface.nombreInformeActual);
		qCondiciones.setFrom(this.iface.nombreInformeActual);
		qCondiciones.
				setSelect
				("d_co__asientos_numero,h_co__asientos_numero,d_co__asientos_fecha,h_co__asientos_fecha,i_co__subcuentas_codejercicio,d_co__subcuentas_codsubcuenta,h_co__subcuentas_codsubcuenta");
		qCondiciones.setWhere("id = " + this.iface.idInformeActual);

		if (!qCondiciones.exec())
				return 0;
		if (!qCondiciones.first())
				return 0;

		var condAsiDesde:Number = qCondiciones.value(0);
		var condAsiHasta:Number = qCondiciones.value(1);
		var condFecDesde:String = qCondiciones.value(2);
		var condFecHasta:String = qCondiciones.value(3);
		var condEjercicio:String = qCondiciones.value(4);
		var condCtaDesde:String = qCondiciones.value(5);
		var condCtaHasta:String = qCondiciones.value(6);

		var q:FLSqlQuery = new FLSqlQuery();

		q.setTablesList("co_subcuentas,co_partidas,co_asientos");
		q.setFrom
				("co_subcuentas INNER JOIN co_partidas ON co_subcuentas.idsubcuenta = co_partidas.idsubcuenta INNER JOIN co_asientos ON co_partidas.idasiento = co_asientos.idasiento");

		var where = "co_subcuentas.codejercicio = '" + condEjercicio + "'" + 
				" AND co_subcuentas.codsubcuenta >= '" + condCtaDesde + "'" + 
				" AND co_subcuentas.codsubcuenta <= '" + condCtaHasta + "'" + 
				" AND co_asientos.numero >= " + condAsiDesde +
				" AND co_asientos.numero <= " + condAsiHasta +
				" AND co_asientos.fecha >= '" + condFecDesde + "'" + 
				" AND co_asientos.fecha <= '" + condFecHasta + "'";

		q.setWhere(where);

		q.setSelect("SUM(co_partidas.debe), SUM(co_partidas.haber)");
		
		if (!q.exec())
				return 0;
		if (!q.first())
				return 0;

		var result:Number = q.value(0) - q.value(1);

		return result;

}


function oficial_debeDiarioMes(nodo:FLDomNode, campo:String):Number
{
	return this.iface.debeDiario;
}

function oficial_haberDiarioMes(nodo:FLDomNode, campo:String):Number
{
	return this.iface.haberDiario;
}

function oficial_descuadreDiarioMes(nodo:FLDomNode, campo:String):String
{
	return this.iface.debeDiario - this.iface.haberDiario;
}

function oficial_sumaDebeDiarioMes(nodo:FLDomNode, campo:String):String
{
	debug("entra")
	debug("debe " + this.iface.debeDiario);
	debug("nodo " + parseFloat(nodo.attributeValue("co_partidas.debe")));
	this.iface.debeDiario += parseFloat(nodo.attributeValue("co_partidas.debe"));

	return this.iface.debeDiario;
}

function oficial_sumaHaberDiarioMes(nodo:FLDomNode, campo:String):String
{
	this.iface.haberDiario += parseFloat(nodo.attributeValue("co_partidas.haber"));
	return this.iface.haberDiario;
}

/** \D Utilidad general para crear la cabecera de los informes con la fecha, número de página, intervalos de asientos y subcuentas, nombres de ejercicios, etc

@param nodo Nodo del informe que contiene niveles del campo del informe que se pretende calcular: naturaleza, nivel1 y descripcion1
@param campo Indica el tipo de informe para el que se necesita el texto de cabecera
@return Texto para la cabecera
\end */
function oficial_cabeceraInforme(nodo:FLDomNode, campo:String):String
{
		var texCampo:String = new String(campo);

		var util:FLUtil = new FLUtil();
		var desc:String;
		var ejAct:String, ejAnt:String;
		var fchDesde:String, fchHasta:String;
		var fchDesdeAnt:String, fchHastaAnt:String;
		var sctDesde:String, sctHasta:String;
		var asiDesde:Number, asiHasta:Number;

		var texto:String;
		var sep:String = "       ";

		var qCondiciones:FLSqlQuery = new FLSqlQuery();

		qCondiciones.setTablesList(this.iface.nombreInformeActual);
		qCondiciones.setFrom(this.iface.nombreInformeActual);
		qCondiciones.setWhere("id = " + this.iface.idInformeActual);

		switch (texCampo) {

		case "diario":

				qCondiciones.
						setSelect
						("descripcion,i_co__subcuentas_codejercicio,d_co__asientos_fecha,h_co__asientos_fecha,d_co__subcuentas_codsubcuenta,h_co__subcuentas_codsubcuenta,d_co__asientos_numero,h_co__asientos_numero");

				if (!qCondiciones.exec())
						return "";
				if (!qCondiciones.first())
						return "";

				desc = qCondiciones.value(0);
				ejAct = qCondiciones.value(1);
				
				fchDesde = qCondiciones.value(2).toString().left(10);
				fchHasta = qCondiciones.value(3).toString().left(10);
				fchDesde = util.dateAMDtoDMA(fchDesde);
				fchHasta = util.dateAMDtoDMA(fchHasta);
				
				sctDesde = qCondiciones.value(4);
				sctHasta = qCondiciones.value(5);
				asiDesde = qCondiciones.value(6);
				asiHasta = qCondiciones.value(7);

				texto = "[ " + desc + " ]" + sep +
						"Ejercicio " + ejAct + sep +
						"Periodo  " + fchDesde + " - " + fchHasta + sep +
						"Subcuentas  " + sctDesde + " - " + sctHasta + sep +
						"Asientos  " + asiDesde + " - " + asiHasta;

				break;

		case "mayor":

				qCondiciones.
						setSelect
						("descripcion,i_co__subcuentas_codejercicio,d_co__asientos_fecha,h_co__asientos_fecha,d_co__subcuentas_codsubcuenta,h_co__subcuentas_codsubcuenta");

				if (!qCondiciones.exec())
						return "";
				if (!qCondiciones.first())
						return "";

				desc = qCondiciones.value(0);
				ejAct = qCondiciones.value(1);
				fchDesde = qCondiciones.value(2).toString().left(10);
				fchHasta = qCondiciones.value(3).toString().left(10);
				fchDesde = util.dateAMDtoDMA(fchDesde);
				fchHasta = util.dateAMDtoDMA(fchHasta);
				sctDesde = qCondiciones.value(4);
				sctHasta = qCondiciones.value(5);

				texto = "[ " + desc + " ]" + sep +
						"Ejercicio " + ejAct + sep +
						"Periodo  " + fchDesde + " - " + fchHasta + sep +
						"Subcuentas  " + sctDesde + " - " + sctHasta;

				break;


		case "facturasemi":
		case "facturasrec":

				qCondiciones.
						setSelect
						("descripcion,i_co__cuentas_codejercicio,d_co__asientos_fecha,h_co__asientos_fecha");

				if (!qCondiciones.exec())
						return "";
				if (!qCondiciones.first())
						return "";

				desc = qCondiciones.value(0);
				ejAct = qCondiciones.value(1);
				fchDesde = qCondiciones.value(2).toString().left(10);
				fchHasta = qCondiciones.value(3).toString().left(10);
				fchDesde = util.dateAMDtoDMA(fchDesde);
				fchHasta = util.dateAMDtoDMA(fchHasta);

				texto = "[ " + desc + " ]" + sep +
						"Ejercicio " + ejAct + sep +
						"Periodo  " + fchDesde + " - " + fchHasta;

				break;


		case "balancesis":

				qCondiciones.setSelect("descripcion,i_co__subcuentas_codejercicio,d_co__asientos_fecha,h_co__asientos_fecha,d_co__subcuentas_codsubcuenta,h_co__subcuentas_codsubcuenta,codejercicioant,fechaant_d,fechaant_h,ejercicioanterior");

				if (!qCondiciones.exec())
						return "";
				if (!qCondiciones.first())
						return "";

				desc = qCondiciones.value(0);
				ejAct = qCondiciones.value(1);
				
				fchDesde = qCondiciones.value(2).toString().left(10);
				fchHasta = qCondiciones.value(3).toString().left(10);
				fchDesde = util.dateAMDtoDMA(fchDesde);
				fchHasta = util.dateAMDtoDMA(fchHasta);
				
				sctDesde = qCondiciones.value(4);
				sctHasta = qCondiciones.value(5);
				ejAnt = qCondiciones.value(6);
				fchDesdeAnt = qCondiciones.value(7);
				fchHastaAnt = qCondiciones.value(8);
				fchDesdeAnt = util.dateAMDtoDMA(fchDesdeAnt);
				fchHastaAnt = util.dateAMDtoDMA(fchHastaAnt);

				texto = "[ " + desc + " ]" + sep +
						ejAct + "  |  " + "Periodo  " + fchDesde + " - " + fchHasta;

				if (ejAnt != ejAct && qCondiciones.value("ejercicioanterior")) {
						texto += sep +
								ejAnt + "  |  " +
								"Periodo  " + fchDesdeAnt + " - " + fchHastaAnt;
				}

				if (sctDesde || sctHasta)
					texto += sep + "Subcuentas  " + sctDesde + " - " + sctHasta;

				break;


		case "balancesit":
		case "balancepyg":

				qCondiciones.
						setSelect
						("descripcion,i_co__subcuentas_codejercicioact,d_co__asientos_fechaact,h_co__asientos_fechaact,i_co__subcuentas_codejercicioant,d_co__asientos_fechaant,h_co__asientos_fechaant");

				if (!qCondiciones.exec())
						return "";
				if (!qCondiciones.first())
						return "";

				desc = qCondiciones.value(0);
				ejAct = qCondiciones.value(1);
				
				fchDesde = qCondiciones.value(2).toString().left(10);
				fchHasta = qCondiciones.value(3).toString().left(10);
				fchDesde = util.dateAMDtoDMA(fchDesde);
				fchHasta = util.dateAMDtoDMA(fchHasta);
				
				ejAnt = qCondiciones.value(4);
				fchDesdeAnt = qCondiciones.value(5);
				fchHastaAnt = qCondiciones.value(6);
				fchDesdeAnt = util.dateAMDtoDMA(fchDesdeAnt);
				fchHastaAnt = util.dateAMDtoDMA(fchHastaAnt);

				texto = "[ " + desc + " ]" + sep +
						"Ej. " + ejAct + " [" + fchDesde + " - " + fchHasta + "]";

				if (this.iface.mostrarEjAnt) {
						texto += sep +
								"Ej. " + ejAnt +
								" [" + fchDesdeAnt + " - " + fchHastaAnt + "]";
				}

				break;


		case "fecha":

				var fecha = new Date();
				var texFecha = fecha.toString();
				var hora:String = texFecha.right(8);
				texto = "Fecha: " + util.dateAMDtoDMA(texFecha.left(10)) + "  Hora: " + hora.left(5) + "  ";
				break;


		case "numpag":
// 				if(this.iface.mesDiario > -1) {
// 					if(this.iface.mesDiario != nodo.attributeValue("extract(month from co_asientos.fecha)")) {
// 						this.iface.mesDiario = nodo.attributeValue("extract(month from co_asientos.fecha)");
// 						this.iface.numPag = 1;
// 					}
// 					else {
// 						this.iface.numPag++;
// 					}
// 				}

				this.iface.numPag++;
				return "página " + this.iface.numPag + " ";
				break;
		}

		return texto;
}

/** \D Realiza el cálculo de resultados del ejercicio en cuanto a pérdidas y ganancias.

@param AB Array pasado por variable donde se guardarán los resultados
@param ej Ejercicio sobre el que se calculan los datos
@param desde Fecha inicial del intervalo de cálculo
@param hasta Fecha final del intervalo de cálculo
\end */
function oficial_resultadosEjercicio(AB:Array, ej:String, desde:String, hasta:String, ignorarCierre:Boolean):Boolean
{
		var A:Array = [];
		var B:Array = [];
		var dat:Array = [];

		var util:FLUtil = new FLUtil();
		
/** \D En primer lugar se realiza una consulta para obtener los totales de saldos de subcuentas agrupadas por cuenta, para aquellas cuentas cuyo código de balance sea 'DEBE' o 'HABER'
\end */
		var asientoPyG:Number = -1;
		var asientoCierre:Number = -1;
		if (ignorarCierre) {
			asientoPyG = util.sqlSelect("ejercicios", "idasientopyg", "codejercicio = '" + ej + "'");
			asientoCierre = util.sqlSelect("ejercicios", "idasientocierre", "codejercicio = '" + ej + "'");
		}
		
		var q:FLSqlQuery = new FLSqlQuery();

		q.setTablesList
				("co_cuentas,co_codbalances,co_subcuentas,co_asientos,co_partidas");

		q.setFrom
				("co_codbalances INNER JOIN co_cuentas ON co_cuentas.codbalance = co_codbalances.codbalance INNER JOIN co_subcuentas ON co_subcuentas.idcuenta = co_cuentas.idcuenta INNER JOIN co_partidas ON co_subcuentas.idsubcuenta = co_partidas.idsubcuenta INNER JOIN co_asientos ON co_partidas.idasiento = co_asientos.idasiento");

		q.setSelect
				("co_codbalances.codbalance, co_codbalances.naturaleza, co_codbalances.nivel1, co_codbalances.nivel2, co_codbalances.nivel3,	co_codbalances.descripcion1, co_codbalances.descripcion2, co_codbalances.descripcion3, co_cuentas.codcuenta, co_cuentas.descripcion, SUM(co_partidas.debe-co_partidas.haber), co_asientos.codejercicio");

		q.setWhere
				("(co_codbalances.naturaleza = 'DEBE' OR co_codbalances.naturaleza = 'HABER')"
				 + " AND ( ((co_asientos.codejercicio = '" + ej + "') " +
 				 " AND (co_asientos.idasiento <> '" + asientoPyG + "')" +
 				 " AND (co_asientos.idasiento <> '" + asientoCierre + "')" +
				 " AND (co_asientos.fecha >= '" + desde + "')" +
				 " AND (co_asientos.fecha <= '" + hasta + "') ))" +
				 " GROUP BY co_codbalances.codbalance, co_codbalances.naturaleza, co_codbalances.nivel1, co_codbalances.nivel2, co_codbalances.nivel3,	co_codbalances.descripcion1, co_codbalances.descripcion2, co_codbalances.descripcion3, co_cuentas.codcuenta, co_cuentas.descripcion, co_asientos.codejercicio ORDER BY co_codbalances.naturaleza, co_codbalances.nivel1, co_codbalances.nivel2, co_codbalances.nivel3, co_cuentas.codcuenta");

		var util:FLUtil = new FLUtil();
		if (q.exec() == false)
				return false;

		var registro:Number = 0;
		var encontrados:Boolean = false;

/** \D El resultado de la consulta se almacena en un array bidimensional
\end */
		while (q.next()) {

				encontrados = true;

				dat[registro] = new Array(2);
				dat[registro]["codbalance"] = q.value(0);
				dat[registro]["naturaleza"] = q.value(1);
				dat[registro]["nivel1"] = q.value(2);
				dat[registro]["nivel2"] = q.value(3);
				dat[registro]["nivel3"] = q.value(4);
				dat[registro]["descripcion1"] = q.value(5);
				dat[registro]["descripcion2"] = q.value(6);
				dat[registro]["descripcion3"] = q.value(7);
				dat[registro]["codcuenta"] = q.value(8);
				dat[registro]["desccuenta"] = q.value(9);
				dat[registro]["suma"] = q.value(10);
				dat[registro]["codejercicio"] = q.value(11);
				
				// Control de variación de existencias.
				codCuenta = dat[registro]["codcuenta"];
				if (codCuenta.left(2) == "71") {
					suma = this.iface.mudarCuentasExistencias(dat[registro]);
					dat[registro]["suma"] = suma;
				}

				if (q.value(1) == "HABER")
						dat[registro]["suma"] = 0 - q.value(10);
				registro++;
		}

		if (!encontrados)
				return false;

		var i:Number;

/** \D Se calculan las sumas de valores de cuentas (previamente obtenidos) agrupados por código de balance mediante la función 'sumarPyG'. Estos valores se almacenan en los arrarys A[] y B[]
\end */
		for (i = 1; i <= 6; i++) {

				A[i] = this.iface.sumarPyG(dat, "DEBE", "A", i, ej);
		}

		for (i = 7; i <= 9; i++) {

				A[i] = this.iface.sumarPyG(dat, "DEBE", "I", i, ej);
		}

		for (i = 10; i <= 14; i++) {

				A[i] = this.iface.sumarPyG(dat, "DEBE", "III", i, ej);
		}

		// Impuesto sobre beneficios. Puede ser negativo
		A[15] = this.iface.sumarPyGNoAbs(dat, "DEBE", "V", 15, ej);
		A[16] = this.iface.sumarPyG(dat, "DEBE", "V", 16, ej);


		for (i = 1; i <= 4; i++) {

				B[i] = this.iface.sumarPyG(dat, "HABER", "B", i, ej);
		}

		for (i = 5; i <= 8; i++) {

				B[i] = this.iface.sumarPyG(dat, "HABER", "I", i, ej);
		}

		B[9] = this.iface.sumarPyG(dat, "HABER", "III", "9", ej);
		B[10] = this.iface.sumarPyG(dat, "HABER", "III", "10", ej);
		B[11] = this.iface.sumarPyG(dat, "HABER", "III", "11", ej);
		B[12] = this.iface.sumarPyG(dat, "HABER", "III", "12", ej);
		B[13] = this.iface.sumarPyG(dat, "HABER", "III", "13", ej);

		AB["AA"] = 0;
		for (i = 1; i < A.length; i++) {
				AB["AA"] += A[i];
		}

		AB["BB"] = 0;
		for (i = 1; i < B.length; i++) {
				AB["BB"] += B[i];
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
		AB["AI"] =
				B[1] + B[2] + B[3] + B[4] - A[1] - A[2] - A[3] - A[4] - A[5] -
				A[6];
		AB["AII"] = B[5] + B[6] + B[7] + B[8] - A[7] - A[8] - A[9];
		if (AB["AI"] < 0)
				AB["AI"] = 0;
		if (AB["AII"] < 0)
				AB["AII"] = 0;

		AB["BI"] =
				A[1] + A[2] + A[3] + A[4] + A[5] + A[6] - B[1] - B[2] - B[3] -
				B[4];
						
		AB["BII"] = A[7] + A[8] + A[9] - B[5] - B[6] - B[7] - B[8];
		if (AB["BI"] < 0)
				AB["BI"] = 0;
		if (AB["BII"] < 0)
				AB["BII"] = 0;

		AB["AIII"] = parseFloat(AB["AI"] + AB["AII"] - AB["BI"] - AB["BII"]);
		AB["AIV"] =
				B[9] + B[10] + B[11] + B[12] + B[13] - A[10] - A[11] - A[12] -
				A[13] - A[14];
		if (AB["AIII"] < 0)
				AB["AIII"] = 0;
		if (AB["AIV"] < 0)
				AB["AIV"] = 0;

		AB["BIII"] = AB["BI"] + AB["BII"] - AB["AI"] - AB["AII"];
		AB["BIV"] =
				A[10] + A[11] + A[12] + A[13] + A[14] - B[9] - B[10] - B[11] -
				B[12] - B[13];
		if (AB["BIII"] < 0)
				AB["BIII"] = 0;
		if (AB["BIV"] < 0)
				AB["BIV"] = 0;

		AB["AV"] = AB["AIII"] + AB["AIV"] - AB["BIII"] - AB["BIV"];
		AB["BV"] = AB["BIII"] + AB["BIV"] - AB["AIII"] - AB["AIV"];
		if (AB["AV"] < 0)
				AB["AV"] = 0;
		if (AB["BV"] < 0)
				AB["BV"] = 0;

		AB["AVI"] = AB["AV"] - A[15] - A[16];
		AB["BVI"] = AB["BV"] + A[15] + A[16];
		
		if (AB["AV"] == 0)
			AB["AVI"] = 0;
		
		if (AB["AVI"] < 0)
				AB["AVI"] = 0;
		if (AB["BVI"] < 0 || AB["AVI"] > 0)
				AB["BVI"] = 0;


		return true;
}

/** \D
Recorre el array Datos que contiene los totales por cada cuenta y hace la suma de subtotales por naturaleza, nivel1 y nivel2 de código de balance

@param naturaleza Naturaleza de las cuentas a sumar
@param nivel1 Nivel1 del código de balances de las cuentas a sumar
@param nivel2 Nivel2 del código de balances de las cuentas a sumar
@param codEjercicio Código del ejercicio de las cuentas a sumar
@return Valor de la suma de saldos de las cuentas
\end */
function oficial_sumarPyG(dat:Array, naturaleza:String, nivel1:String, nivel2:String, codEjercicio:String):Number
{
		var i:Number;
		var result:Number = 0;

		for (i = 0; i < dat.length; i++) {

				if (dat[i]["naturaleza"] == naturaleza
						&& dat[i]["nivel1"] == nivel1 && dat[i]["nivel2"] == nivel2
						&& dat[i]["codejercicio"] == codEjercicio)
						result += parseFloat(dat[i]["suma"]);

		}
// 		return Math.abs(result);
		return result;
}


/** \D
Recorre el array Datos que contiene los totales por cada cuenta y hace la suma de subtotales por naturaleza, nivel1 y nivel2 de código de balance

@param naturaleza Naturaleza de las cuentas a sumar
@param nivel1 Nivel1 del código de balances de las cuentas a sumar
@param nivel2 Nivel2 del código de balances de las cuentas a sumar
@param codEjercicio Código del ejercicio de las cuentas a sumar
@return Valor de la suma de saldos de las cuentas, puede ser negativo
\end */
function oficial_sumarPyGNoAbs(dat:Array, naturaleza:String, nivel1:String, nivel2:String, codEjercicio:String):Number
{
		var i:Number;
		var result:Number = 0;

		for (i = 0; i < dat.length; i++) {

				if (dat[i]["naturaleza"] == naturaleza
						&& dat[i]["nivel1"] == nivel1 && dat[i]["nivel2"] == nivel2
						&& dat[i]["codejercicio"] == codEjercicio)
						result += parseFloat(dat[i]["suma"]);

		}
		return result;
}

/** \D
Comprueba que la longitud de las subcuentas es la misma para dos ejercicios 
que han de consolidarse en un balance

@param ej1 Código del ejericio 1
@param ej2 Código del ejericio 2
@return True si las longitudes coinciden, false en otro caso
\end */
function oficial_comprobarConsolidacion(ej1:String, ej2:String):Boolean
{
		var q:FLSqlQuery = new FLSqlQuery();
		q.setTablesList("ejercicios");
		q.setSelect("ej1.codEjercicio");
		q.setFrom("ejercicios ej1, ejercicios ej2");

		q.setWhere("ej1.codejercicio = '" + ej1 + "' AND " +
							 "ej2.codejercicio = '" + ej2 + "' AND " +
							 "ej1.longsubcuenta = ej2.longsubcuenta");

		if (!q.exec())
				return false;
		if (!q.first())
				return false;

		return true;
}

/** \D Establece a cero en número de factura para comenzar un nuevo listado;
si no se hace se acumulará sobre el último informe. Usado en los listados de
I.V.A. con numeración automática \end */
function oficial_resetearNumFactura(numDesde:Number)
{
	this.iface.numFactura = numDesde;
}

/** \D Incrementa el número de factura en los listados de
I.V.A. con numeración automática. Si la numeración es normal devuelve el número de la factura de BD \end */
function oficial_numerarFacturas(nodo:FLDomNode, campo:String) :Number
{
debug("oficial_numerarFacturas");
	var valor:Number;
	if (this.iface.numFactura == -1) {
debug("campo");
		valor = nodo.attributeValue("co_partidas.factura");
	} else {
debug("auto");
		valor = this.iface.numFactura;
		this.iface.numFactura++;
	}
	return valor;
}

/** \D A la hora de obtener los balances las cuentas 71... van al debe o
al haber en función del saldo
 \end */
function oficial_mudarCuentasExistencias(registro:Array):Number
{
	var suma:String = registro["suma"];

	if (registro["codbalance"] != "D-A-1" && registro["codbalance"] != "H-B-2")
		return suma;

	var util:FLUtil = new FLUtil();
	var codEjercicio:String = flfactppal.iface.pub_ejercicioActual();
	
	// Nuevos valores
	var codBalance:String;
	var naturaleza:String;
	var nivel1:String;
	var nivel2:String;
	var cambio:Boolean = false;
	
	// Del debe al haber
	if (registro["codbalance"] == "D-A-1" && registro["suma"] < 0) {
		codBalance = "H-B-2";
		naturaleza = "HABER";
		nivel1 = "B";
		nivel2 = "2";
		cambio = true;
	}
		
	// Del haber al debe
	if (registro["codbalance"] == "H-B-2" && registro["suma"] > 0) {
		codBalance = "D-A-1";
		naturaleza = "DEBE";
		nivel1 = "A";
		nivel2 = "1";
		suma = 0 - suma;
		cambio = true;
	}
		
	if (!cambio)
		return suma;
		
	// Mudamos las cuentas
	var curCue:FLSqlCursor = new FLSqlCursor("co_cuentas");
	curCue.select("codbalance = '" + registro["codbalance"] + "' AND codejercicio = '" + codEjercicio + "'");
	while(curCue.next()) {
		curCue.setModeAccess(curCue.Edit);
		curCue.refreshBuffer();
		curCue.setValueBuffer("codbalance", codBalance);
		if(!curCue.commitBuffer()) {
			debug("Error al mudar el código de balance de la cuenta para el código " + registro["codbalance"]);
			return suma;
		}
	}
	
	return suma;
}

function oficial_vaciarBuffer(tabla:String):Boolean 
{
	var util:FLUtil = new FLUtil();
	
	var util:FLUtil = new FLUtil();
	if (util.sqlDelete(tabla, "1=1"))
		return true;
	
	return false
}

function oficial_iniciarValores(nodo:FLDomNode, campo:String):String
{
	var util:FLUtil = new FLUtil;
	this.iface.baseTotal = 0;
	this.iface.baseImp4 = 0;
	this.iface.baseImp7 = 0;
	this.iface.baseImp16 = 0;
	this.iface.baseImpUE = 0;
	this.iface.baseImpEX = 0;
	this.iface.baseImpImp = 0;
	this.iface.ivaTotal = 0;
	this.iface.iva4 = 0;
	this.iface.iva7 = 0;
	this.iface.iva16 = 0;
	this.iface.ivaUE = 0;
	this.iface.ivaEX = 0;
	this.iface.ivaImp = 0;
	this.iface.re4 = 0;
	this.iface.re7 = 0;
	this.iface.re16 = 0;
	this.iface.reUE = 0;
	this.iface.total4 = 0;
	this.iface.total7 = 0;
	this.iface.total16 = 0;
	this.iface.totalUE = 0;
	this.iface.totalEX = 0;
	this.iface.totalImp = 0;

	this.iface.aAcumFacturas_ = [];
	this.iface.aAcumFacturas_[0] = [];
	this.iface.aAcumFacturas_[0]["id"] = "UE";
	this.iface.aAcumFacturas_[0]["nombre"] = util.translate("scripts", "U.E.");
	this.iface.aAcumFacturas_[0]["orden"] = 80;
	this.iface.aAcumFacturas_[0]["tipoiva"] = 0;
	this.iface.aAcumFacturas_[0]["base"] = 0;
	this.iface.aAcumFacturas_[0]["couta"] = 0;
	this.iface.aAcumFacturas_[0]["recargo"] = 0;
	this.iface.aAcumFacturas_[0]["total"] = 0;

	this.iface.aAcumFacturas_[1] = [];
	this.iface.aAcumFacturas_[1]["id"] = "IE";
	this.iface.aAcumFacturas_[1]["nombre"] = util.translate("scripts", "Import/Export");
	this.iface.aAcumFacturas_[1]["orden"] = 81;
	this.iface.aAcumFacturas_[1]["tipoiva"] = 0;
	this.iface.aAcumFacturas_[1]["base"] = 0;
	this.iface.aAcumFacturas_[1]["couta"] = 0;
	this.iface.aAcumFacturas_[1]["recargo"] = 0;
	this.iface.aAcumFacturas_[1]["total"] = 0;

	this.iface.aAcumFacturas_[2] = [];
	this.iface.aAcumFacturas_[2]["id"] = "EX";
	this.iface.aAcumFacturas_[2]["nombre"] = util.translate("scripts", "Exento");
	this.iface.aAcumFacturas_[2]["orden"] = 82;
	this.iface.aAcumFacturas_[2]["tipoiva"] = 0;
	this.iface.aAcumFacturas_[2]["base"] = 0;
	this.iface.aAcumFacturas_[2]["couta"] = 0;
	this.iface.aAcumFacturas_[2]["recargo"] = 0;
	this.iface.aAcumFacturas_[2]["total"] = 0;
}

function oficial_acumularFactura(id:String, baseImp:Number, cuota:Number, tipo:Number, recargo:Number):Boolean
{
	recargo = (isNaN(recargo) ? 0 : recargo);

	var longArray:Number = this.iface.aAcumFacturas_.length;
	var i:Number;
	for (i = 0; i < longArray; i++) {
		if (id == "RG") {
			if (this.iface.aAcumFacturas_[i]["id"] == "RG" && this.iface.aAcumFacturas_[i]["tipoiva"] == tipo) {
				break;
			}
		} else {
			if (this.iface.aAcumFacturas_[i]["id"] == id) {
				break;
			}
		}
	}
	if (i == longArray) {
		if (id != "RG") { /// Los IVAs especiales (UE, import, exento) deben estar ya creados
			return false;
		}
		this.iface.aAcumFacturas_[i] = [];
		this.iface.aAcumFacturas_[i]["id"] = "RG";
		this.iface.aAcumFacturas_[i]["nombre"] = tipo + "%";
		this.iface.aAcumFacturas_[i]["orden"] = tipo;
		this.iface.aAcumFacturas_[i]["tipoiva"] = tipo;
		this.iface.aAcumFacturas_[i]["base"] = parseFloat(baseImp);
		this.iface.aAcumFacturas_[i]["couta"] = parseFloat(cuota);
		this.iface.aAcumFacturas_[i]["recargo"] = parseFloat(recargo);
		this.iface.aAcumFacturas_[i]["total"] = parseFloat(baseImp) + parseFloat(cuota) + parseFloat(recargo);
	} else {
		this.iface.aAcumFacturas_[i]["base"] += parseFloat(baseImp);
		this.iface.aAcumFacturas_[i]["couta"] += parseFloat(cuota);
		this.iface.aAcumFacturas_[i]["recargo"] += parseFloat(recargo);
		this.iface.aAcumFacturas_[i]["total"] += parseFloat(baseImp) + parseFloat(cuota) + parseFloat(recargo);
	}
	return true;
}

function oficial_ordenarAcumFacturas()
{
	for (var i:Number = 0; i < this.iface.aAcumFacturas_.length; i++) {
		debug(this.iface.aAcumFacturas_[i]["nombre"]);
	}
	this.iface.aAcumFacturas_.sort(this.iface.compararAcumFacturas);
debug("Ordenado");
	for (var i:Number = 0; i < this.iface.aAcumFacturas_.length; i++) {
		debug(this.iface.aAcumFacturas_[i]["nombre"]);
	}
}

function oficial_compararAcumFacturas(a:Array, b:Array):Number
{
	if (parseFloat(a["orden"]) > parseFloat(b["orden"])) {
		return 1;
	} else if (parseFloat(a["orden"]) < parseFloat(b["orden"])) {
		return -1
	} else {
		return 0;
	}
}

function oficial_acumularValoresEmi(nodo:FLDomNode, campo:String):String
{
	var util:FLUtil = new FLUtil;
	var idCuentaEsp:String = nodo.attributeValue("sc1.idcuentaesp");
	var valor:String;
	
	var recargo:Number;
	var regimen:String;
	switch (idCuentaEsp) {
		case "IVAEUE": {
			this.iface.baseImpUE +=  parseFloat(nodo.attributeValue("co_partidas.baseimponible"));
			this.iface.ivaUE += parseFloat(nodo.attributeValue("(co_partidas.haber - co_partidas.debe)"));
			this.iface.totalUE = parseFloat(this.iface.baseImpUE + this.iface.ivaUE);

			this.iface.acumularFactura("UE", nodo.attributeValue("co_partidas.baseimponible"), nodo.attributeValue("(co_partidas.haber - co_partidas.debe)"));

			valor = util.translate("scripts", "( U.E. )");
			break;
		}
		case "IVAREX": {
			this.iface.baseImpEX +=  parseFloat(nodo.attributeValue("co_partidas.baseimponible"));
			this.iface.ivaEX += parseFloat(nodo.attributeValue("(co_partidas.haber - co_partidas.debe)"));
			this.iface.totalEX = parseFloat(this.iface.baseImpEX + this.iface.ivaEX);

			this.iface.acumularFactura("EX", nodo.attributeValue("co_partidas.baseimponible"), nodo.attributeValue("(co_partidas.haber - co_partidas.debe)"));

			valor = util.translate("scripts", "( Exento )");
			break;
		}
		case "IVARXP": {
			this.iface.baseImpImp +=  parseFloat(nodo.attributeValue("co_partidas.baseimponible"));
			this.iface.ivaImp += parseFloat(nodo.attributeValue("(co_partidas.haber - co_partidas.debe)"));
			this.iface.totalImp = parseFloat(this.iface.baseImpImp + this.iface.ivaImp);

			this.iface.acumularFactura("IE", nodo.attributeValue("co_partidas.baseimponible"), nodo.attributeValue("(co_partidas.haber - co_partidas.debe)"));

			valor = util.translate("scripts", "( Export. )");
			break;
		}
		case "IVAREP":
		default: {
			recargo = parseFloat(nodo.attributeValue("co_partidas.baseimponible")) *  parseFloat(nodo.attributeValue("co_partidas.recargo")) / 100;
			regimen = "RG";
			if ( parseFloat(nodo.attributeValue("co_partidas.iva")) == 4 ) {
				this.iface.baseImp4 +=  parseFloat(nodo.attributeValue("co_partidas.baseimponible"));
				this.iface.iva4 += parseFloat(nodo.attributeValue("(co_partidas.haber - co_partidas.debe)"));
				this.iface.re4 += recargo;
				this.iface.total4 = this.iface.baseImp4 + this.iface.iva4 + this.iface.re4;
				valor = util.translate("scripts", "( Gral. )");
			}
			if ( parseFloat(nodo.attributeValue("co_partidas.iva")) == 7 ) {
				this.iface.baseImp7 +=  parseFloat(nodo.attributeValue("co_partidas.baseimponible"));
				this.iface.iva7 += parseFloat(nodo.attributeValue("(co_partidas.haber - co_partidas.debe)"));
				this.iface.re7 += recargo;
				this.iface.total7 = this.iface.baseImp7 + this.iface.iva7 + this.iface.re7;
				valor = util.translate("scripts", "( Gral. )");
			}
			if ( parseFloat(nodo.attributeValue("co_partidas.iva")) == 16 ) {
				this.iface.baseImp16 += parseFloat(nodo.attributeValue("co_partidas.baseimponible"));
				this.iface.iva16 += parseFloat(nodo.attributeValue("(co_partidas.haber - co_partidas.debe)"));
				this.iface.re16 += recargo;
				this.iface.total16 = this.iface.baseImp16 + this.iface.iva16 + this.iface.re16;
				valor = util.translate("scripts", "( Gral. )");
			}
			if ( parseFloat(nodo.attributeValue("co_partidas.iva")) == 0 ) {
				this.iface.baseImpEX +=  parseFloat(nodo.attributeValue("co_partidas.baseimponible"));
				this.iface.ivaEX += parseFloat(nodo.attributeValue("(co_partidas.haber - co_partidas.debe)"));
				this.iface.totalEX = parseFloat(this.iface.baseImpEX + this.iface.ivaEX);
				valor = util.translate("scripts", "( Exento )");
				regimen = "EX";
			}

			this.iface.acumularFactura(regimen, nodo.attributeValue("co_partidas.baseimponible"), nodo.attributeValue("(co_partidas.haber - co_partidas.debe)"), parseFloat(nodo.attributeValue("co_partidas.iva")), recargo);
		}
	}
	return valor;
}

function oficial_acumularValoresRec(nodo:FLDomNode, campo:String):String
{
	var util:FLUtil = new FLUtil;
	var idCuentaEsp:String = nodo.attributeValue("sc1.idcuentaesp");
	var valor:String;
	/// Para registros de antes de que existiera IVASEX.
	if ((!idCuentaEsp || idCuentaEsp == "") && parseFloat(nodo.attributeValue("co_partidas.iva")) == 0 ) {
		idCuentaEsp = "IVASEX";
	}
debug("idCuentaEsp  = " + idCuentaEsp );
	switch (idCuentaEsp) {
		case "IVASUE": {
			this.iface.baseTotal += parseFloat(nodo.attributeValue("co_partidas.baseimponible"));
			this.iface.ivaTotal += parseFloat(nodo.attributeValue("(co_partidas.debe - co_partidas.haber)"));
			this.iface.baseImpUE += parseFloat(nodo.attributeValue("co_partidas.baseimponible"));
			this.iface.ivaUE += parseFloat(nodo.attributeValue("(co_partidas.debe - co_partidas.haber)"));
			this.iface.totalUE = parseFloat(this.iface.baseImpUE + this.iface.ivaUE);

			this.iface.acumularFactura("UE", nodo.attributeValue("co_partidas.baseimponible"), nodo.attributeValue("(co_partidas.debe - co_partidas.haber)"));

			valor = util.translate("scripts", "( U.E. )");
			break;
		}
		case "IVARUE": {
			/// No se suma la base porque ya se ha sumado en la partida de IVASUE
			this.iface.ivaTotal += parseFloat(nodo.attributeValue("(co_partidas.debe - co_partidas.haber)"));
			this.iface.ivaUE += parseFloat(nodo.attributeValue("(co_partidas.debe - co_partidas.haber)"));
			this.iface.totalUE = parseFloat(this.iface.baseImpUE + this.iface.ivaUE);
			this.iface.acumularFactura("UE", 0, nodo.attributeValue("(co_partidas.debe - co_partidas.haber)"));

			valor = util.translate("scripts", "( U.E. )");
			break;
		}
		case "IVASEX": {
			this.iface.baseTotal += parseFloat(nodo.attributeValue("co_partidas.baseimponible"));
			this.iface.ivaTotal += parseFloat(nodo.attributeValue("(co_partidas.debe - co_partidas.haber)"));
			this.iface.baseImpEX +=  parseFloat(nodo.attributeValue("co_partidas.baseimponible"));
			this.iface.ivaEX += parseFloat(nodo.attributeValue("(co_partidas.debe - co_partidas.haber)"));
			this.iface.totalEX = parseFloat(this.iface.baseImpEX + this.iface.ivaEX);

			this.iface.acumularFactura("EX", nodo.attributeValue("co_partidas.baseimponible"), nodo.attributeValue("(co_partidas.debe - co_partidas.haber)"));

			valor = util.translate("scripts", "( Exento )");
			break;
		}
		case "IVASIM": {
			this.iface.baseTotal += parseFloat(nodo.attributeValue("co_partidas.baseimponible"));
			this.iface.ivaTotal += parseFloat(nodo.attributeValue("(co_partidas.debe - co_partidas.haber)"));
			this.iface.baseImpImp +=  parseFloat(nodo.attributeValue("co_partidas.baseimponible"));
			this.iface.ivaImp += parseFloat(nodo.attributeValue("(co_partidas.debe - co_partidas.haber)"));
			this.iface.totalImp = parseFloat(this.iface.baseImpImp + this.iface.ivaImp);

			this.iface.acumularFactura("IE", nodo.attributeValue("co_partidas.baseimponible"), nodo.attributeValue("(co_partidas.debe - co_partidas.haber)"));

			valor = util.translate("scripts", "( Import. )");
			break;
		}

		case "IVASOP":
		case "IVASRA":
		default:{
			this.iface.baseTotal += parseFloat(nodo.attributeValue("co_partidas.baseimponible"));
			this.iface.ivaTotal += parseFloat(nodo.attributeValue("(co_partidas.debe - co_partidas.haber)"));
			if ( parseFloat(nodo.attributeValue("co_partidas.iva")) == 4 ) {
				this.iface.baseImp4 +=  parseFloat(nodo.attributeValue("co_partidas.baseimponible"));
				this.iface.iva4 += parseFloat(nodo.attributeValue("(co_partidas.debe - co_partidas.haber)"));
				this.iface.total4 = this.iface.baseImp4 + this.iface.iva4;
				if (idCuentaEsp == "IVASRA") {
					valor = util.translate("scripts", "( R.A. )");
				} else {
					valor = util.translate("scripts", "( Gral. )");
				}
			}
			if ( parseFloat(nodo.attributeValue("co_partidas.iva")) == 7 ) {
				this.iface.baseImp7 +=  parseFloat(nodo.attributeValue("co_partidas.baseimponible"));
				this.iface.iva7 += parseFloat(nodo.attributeValue("(co_partidas.debe - co_partidas.haber)"));
				this.iface.total7 = this.iface.baseImp7 + this.iface.iva7;
				if (idCuentaEsp == "IVASRA") {
					valor = util.translate("scripts", "( R.A. )");
				} else {
					valor = util.translate("scripts", "( Gral. )");
				}
			}
			if ( parseFloat(nodo.attributeValue("co_partidas.iva")) == 16 ) {
				this.iface.baseImp16 += parseFloat(nodo.attributeValue("co_partidas.baseimponible"));
				this.iface.iva16 += parseFloat(nodo.attributeValue("(co_partidas.debe - co_partidas.haber)"));
				this.iface.total16 = this.iface.baseImp16 + this.iface.iva16;
				if (idCuentaEsp == "IVASRA") {
					valor = util.translate("scripts", "( R.A. )");
				} else {
					valor = util.translate("scripts", "( Gral. )");
				}
			}
			if ( parseFloat(nodo.attributeValue("co_partidas.iva")) == 0 ) {
				this.iface.baseImpEX +=  parseFloat(nodo.attributeValue("co_partidas.baseimponible"));
				this.iface.ivaEX += parseFloat(nodo.attributeValue("(co_partidas.debe - co_partidas.haber)"));
				this.iface.totalEX = parseFloat(this.iface.baseImpEX + this.iface.ivaEX);
				if (idCuentaEsp == "IVASRA") {
					valor = util.translate("scripts", "( R.A. )");
				} else {
					valor = util.translate("scripts", "( Exento )");
				}
			}

			this.iface.acumularFactura("RG", nodo.attributeValue("co_partidas.baseimponible"), nodo.attributeValue("(co_partidas.debe - co_partidas.haber)"), nodo.attributeValue("co_partidas.iva"));
			break;
		}
	}
	return valor;
}


function oficial_mostrarValores(nodo:FLDomNode, campo:String):String
{
	var util:FLUtil = new FLUtil;
	var valor:String = "";
	switch(campo) {
		case "nombres": {
			for (var i:Number = 0; i < this.iface.aAcumFacturas_.length; i++) {
				valor += this.iface.aAcumFacturas_[i]["nombre"] + "\n";
			}
			break;
		}
		case "bases": {
			for (var i:Number = 0; i < this.iface.aAcumFacturas_.length; i++) {
				valor += util.roundFieldValue(this.iface.aAcumFacturas_[i]["base"], "co_partidas", "baseimponible") + "\n";
			}
			break;
		}
		case "coutas": {
			for (var i:Number = 0; i < this.iface.aAcumFacturas_.length; i++) {
				valor += util.roundFieldValue(this.iface.aAcumFacturas_[i]["couta"], "co_partidas", "debe") + "\n";
			}
			break;
		}
		case "recargos": {
			for (var i:Number = 0; i < this.iface.aAcumFacturas_.length; i++) {
				valor += util.roundFieldValue(this.iface.aAcumFacturas_[i]["recargo"], "co_partidas", "debe") + "\n";
			}
			break;
		}
		case "totales": {
			for (var i:Number = 0; i < this.iface.aAcumFacturas_.length; i++) {
				valor += util.roundFieldValue(this.iface.aAcumFacturas_[i]["total"], "co_partidas", "debe") + "\n";
			}
			break;
		}
		case "baseTotal" : {
			valor = this.iface.baseTotal;
			break;
		}
		case "baseImpUE" : {
			valor = this.iface.baseImpUE;
			break;
		}
		case "baseImpImp" : {
			valor = this.iface.baseImpImp;
			break;
		}
		case "baseImp4" : {
			valor = this.iface.baseImp4;
			break;
		}
		case "baseImp7" : {
			valor = this.iface.baseImp7;
			break;
		}
		case "baseImp16" : {
			valor = this.iface.baseImp16;
			break;
		}
		case "totalEX" : {
			valor = this.iface.totalEX;
		}
		case "baseImpEX": {
			valor = this.iface.baseImpEX;
			break;
		}
		case "ivaUE" : {
			valor = this.iface.ivaUE;
			break;
		}
		case "ivaTotal" : {
			valor = this.iface.ivaTotal;
			break;
		}
		case "ivaImp" : {
			valor = this.iface.ivaImp;
			break;
		}
		case "ivaEX" : {
			valor = this.iface.ivaEX;
			break;
		}
		case "iva4" : {
			valor = this.iface.iva4;
			break;
		}
		case "iva7" : {
			valor = this.iface.iva7;
			break;
		}
		case "iva16" : {
			valor = this.iface.iva16;
			break;
		}
		case "reUE" : {
			valor = this.iface.reUE;
			break;
		}
		case "re4" : {
			valor = this.iface.re4;
			break;
		}
		case "re7" : {
			valor = this.iface.re7;
			break;
		}
		case "re16" : {
			valor = this.iface.re16;
			break;
		}
		case "totalTotal" : {
			valor = parseFloat(this.iface.baseTotal) + parseFloat(this.iface.ivaTotal);
			break;
		}
		case "totalUE" : {
			valor = this.iface.totalUE;
			break;
		}
		case "totalImp" : {
			valor = this.iface.totalImp;
			break;
		}
		case "total4" : {
			valor = this.iface.total4;
			break;
		}
		case "total7" : {
			valor = this.iface.total7;
			break;
		}
		case "total16" : {
			valor = this.iface.total16;
			break;
		}
	
		case "ivaEX" :
		case "reEX" :
			valor = 0;
			break;
		
	}
	return valor;
} 

function oficial_nombreEmpresa(nodo:FLDomNode, campo:String):String
{
	var valor:String = flfactppal.iface.pub_valorDefectoEmpresa("nombre");
	return valor;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pgc2008 */
/////////////////////////////////////////////////////////////////
//// PGC 2008 //////////////////////////////////////////////////////


function pgc2008_lanzarBalance(cursor:FLSqlCursor, csv:Boolean)
{
	var util:FLUtil = new FLUtil;
	
	flcontinfo.iface.numPag = 0;
	var datos:Array = this.iface.cargarQryReport(cursor);
	if (!datos) {
		return false;
	}
	var qInforme:FLSqlQuery = datos["query"];
	var nombreInforme:String = datos["report"];
	var rptViewer:FLReportViewer = new FLReportViewer();
	rptViewer.setReportTemplate(nombreInforme);

	if (!qInforme.exec()) {
		MessageBox.warning(util.translate("scripts", "Error al ejecutar la consulta."), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	if (!qInforme.first()) {
		MessageBox.information(util.translate("scripts", "No existen datos para este informe."), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	if (csv) {
		this.iface.volcarCsv(qInforme);
	} else {
		rptViewer.setReportData(qInforme);
		rptViewer.renderReport();
		rptViewer.exec();
	}
}

function pgc2008_volcarCsv(qryInforme:FLSqlQuery):Boolean
{
	var util:FLUtil = new FLUtil;
	var nombreFichero:String = FileDialog.getSaveFileName("*.csv", util.translate("scripts", "Indique el archivo csv a guardar"));
	if (!nombreFichero) {
		return;
	}
	var fichero:Object = new File(nombreFichero);
	fichero.open(File.WriteOnly);

	var miSelect:String = qryInforme.select();
	var aCampos:Array = miSelect.split(",");
	var numCampos:Number = aCampos.length;
	var linea:String;
	do {
		linea = "";
		for (var i:Number = 0; i < numCampos; i++) {
			linea += qryInforme.value(i) + "|";
		}
		fichero.writeLine(linea);
	} while (qryInforme.next());
	fichero.close();

	MessageBox.information(util.translate("scripts", "Fichero %1 generado correctamente").arg(fichero.name), MessageBox.Ok, MessageBox.NoButton);
	return true;
}

function pgc2008_cargarQryReport(cursor:FLSqlCursor):Array
{
	var util:FLUtil = new FLUtil;
	var datos:Array;
	var idBalance = cursor.valueBuffer("id");
	
	if (cursor.valueBuffer("recalculoauto")) {
		if (!this.iface.recalcularDatosBalance(cursor))
			return;
	}
	
	this.iface.resultadoEjercicio08("saldoact", idBalance);
	if (cursor.valueBuffer("i_co__subcuentas_codejercicioant"))
		this.iface.resultadoEjercicio08("saldoant", idBalance);
		
	if (!util.sqlSelect("co_i_balances08_datos", "id", "idbalance = " + idBalance))	 {
		MessageBox.information(util.translate("scripts", "No existen datos para este informe. Debe crearlos con el boton <<Recalcular>> del formulario"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return;
	}
	
	var qInforme:FLSqlQuery = new FLSqlQuery("co_i_balancesit_08");
	var nombreInforme:String;
	var where:String;
	var orderBy:String = "";
	
	var tipo:String = cursor.valueBuffer("tipo");
	var formato:String = cursor.valueBuffer("formato");
	var ejAct:String = cursor.valueBuffer("i_co__subcuentas_codejercicioact");
	var ejAnt:String = cursor.valueBuffer("i_co__subcuentas_codejercicioant");
	
	this.iface.establecerEjerciciosPYG(ejAct, ejAnt, true);
	
	switch(tipo) {
		case "Situacion":
			where = "(cbl.naturaleza = 'A' OR cbl.naturaleza = 'P')";
			
			if (formato == "Normal")
				nombreInforme = "co_i_balancesit_08";
			else
				nombreInforme = "co_i_balancesit_08_abr";
			
			orderBy = "cbl.naturaleza, cbl.nivel1, cbl.nivel2, cbl.orden3, cbl.descripcion4";
		break;
		
		case "Perdidas y ganancias":
			where = "cbl.naturaleza = 'PG'";
			if (formato == "Normal")
				nombreInforme = "co_i_balancepyg_08";
			else
				nombreInforme = "co_i_balancepyg_08_abr";
			
			orderBy = "cbl.naturaleza, cbl.nivel1, cbl.nivel2, cbl.orden3, cbl.descripcion4";
			
		break;		
		
		case "Ingresos y gastos":
			where = "cbl.naturaleza = 'IG'";
			if (formato == "Normal")
				nombreInforme = "co_i_balanceig";
			else
				nombreInforme = "co_i_balanceig_abr";
			orderBy = "cbl.naturaleza, cbl.nivel1, cbl.nivel2, cbl.orden3, cbl.descripcion4";
		break;		
	}

	if (idBalance)
		where += " AND buf.idbalance = " + idBalance;
	
	if (orderBy)
		qInforme.setOrderBy(orderBy);
	
	qInforme.setWhere(where);
	debug(qInforme.sql());
	datos["query"] = qInforme;
	datos["report"] = nombreInforme;
	return datos;
}



/** Recalcula todos los datos para el balance
*/
function pgc2008_recalcularDatosBalance(curTab:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	
	var ejercicioAct:String = curTab.valueBuffer("i_co__subcuentas_codejercicioact");
	var fechaDesdeAct:String = curTab.valueBuffer("d_co__asientos_fechaact");
	var fechaHastaAct:String = curTab.valueBuffer("h_co__asientos_fechaact");
	
	var ejercicioAnt:String = curTab.valueBuffer("i_co__subcuentas_codejercicioant");
	var fechaDesdeAnt:String = curTab.valueBuffer("d_co__asientos_fechaant");
	var fechaHastaAnt:String = curTab.valueBuffer("h_co__asientos_fechaant");
	
	var idBalance:Number = curTab.valueBuffer("id");
	if (!this.iface.vaciarBuffer08(idBalance))
		return;

	var esAbreviado:Boolean = false;
	var tablaCB:String = "co_cuentascb";
	
	if (curTab.valueBuffer("formato") == "Abreviado") {
		esAbreviado = true;
		tablaCB = "co_cuentascbba";
	}
		
	if (!this.iface.cuentasSinCB(ejercicioAct, esAbreviado))
		return false;
	
	if (ejercicioAnt)
		if (!this.iface.cuentasSinCB(ejercicioAnt, esAbreviado))
			return false;

	this.iface.pgc2008_vaciarBuffer08(idBalance);
	this.iface.popularBuffer(ejercicioAct, "saldoact", idBalance, fechaDesdeAct, fechaHastaAct, tablaCB);
	if (ejercicioAnt)
		this.iface.popularBuffer(ejercicioAnt, "saldoant", idBalance, fechaDesdeAnt, fechaHastaAnt, tablaCB);
	
	if (curTab.valueBuffer("formato") != "Abreviado") {
		this.iface.completarPGB18("saldoact", idBalance)
		if (ejercicioAnt)
			this.iface.completarPGB18("saldoant", idBalance)
	}
	
	this.iface.calcularSubTotalesBalances08(idBalance);
	return true;
}



/** Rellena la tabla de buffer con los datos del total por código de balance
Se utiliza después en cada uno de los balances
@param posicion Indica si es actual o anterior (valores saldoact o saldoant)
@param tablaCB Indica la tabla que usamos para la query, co_cuentascb / co_cuentascbba
*/
function pgc2008_popularBuffer(ejercicio:String, posicion:String, idBalance:Number, fechaDesde:String, fechaHasta:String, tablaCB:String, masWhere:String)
{
	var util:FLUtil = new FLUtil();	
	var from:String = "";
	var where:String = "";
	var codBalance:String;
	var codCuentaCB:String;
	
	var curTab:FLSqlCursor = new FLSqlCursor("co_i_balances08_datos");
	
	var q:FLSqlQuery = new FLSqlQuery();
	
	// Todas las naturalezas, se filtra más tarde
	where = "s.codejercicio = '" + ejercicio + "'";
		
	var idAsientoCierre:Number = util.sqlSelect("ejercicios", "idasientocierre", "codejercicio = '" + ejercicio + "'");
	if (idAsientoCierre)
		where += " AND a.idasiento <> " + idAsientoCierre;
		
	var idAsientoPyG:Number = util.sqlSelect("ejercicios", "idasientopyg", "codejercicio = '" + ejercicio + "'");
	if (idAsientoPyG)
		where += " AND a.idasiento <> " + idAsientoPyG;
		
	if (masWhere)
		where += masWhere;
		
	from = "co_subcuentas s INNER JOIN co_partidas p ON s.idsubcuenta = p.idsubcuenta " +
			"INNER JOIN co_asientos a ON p.idasiento = a.idasiento";
	
	if (fechaDesde)	where += " AND a.fecha >= '" + fechaDesde + "'";
	if (fechaHasta)	where += " AND a.fecha <= '" + fechaHasta + "'";	
	
	q.setTablesList("co_subcuentas,co_asientos,co_partidas");
	q.setFrom(from);
	q.setSelect("sum(p.debe)-sum(p.haber)");
	
	
	// Bucle principal
	var qCB:FLSqlQuery = new FLSqlQuery();
	qCB.setTablesList(tablaCB + ",co_codbalances08");
	qCB.setFrom(tablaCB + " ccb INNER JOIN co_codbalances08 cb ON ccb.codbalance = cb.codbalance");
	qCB.setSelect("cb.codbalance,cb.naturaleza,ccb.codcuenta");
	qCB.setWhere("1=1 ORDER BY cb.naturaleza, cb.nivel1, cb.nivel2, cb.orden3, cb.nivel4");
	
	if (!qCB.exec()) {
		MessageBox.critical(util.translate("scripts", "Falló la consulta de códigos por cuenta"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return;
	}
	
	var paso:Number = 0;
	var suma:Number, sumaActual:Number;
	
	util.createProgressDialog( util.translate( "scripts", "Recabando datos..." ), qCB.size());
	
	while (qCB.next()) {
		
		codBalance = qCB.value(0);
		naturaleza = qCB.value(1);
		codCuentaCB = qCB.value(2);
		
		util.setProgress(paso++);
		util.setLabelText(util.translate( "scripts", "Recabando datos del ejercicio %0\n\nAnalizando código de balance\n" ).arg(ejercicio) + codBalance);
		
		// Evitamos contar dos veces casos como 281 y 2811
		q.setWhere(where + " and s.codcuenta like '" + codCuentaCB + "%' and s.codcuenta not in (select codcuenta from " + tablaCB + " where codcuenta like '" + codCuentaCB + "%' and codcuenta <> '" + codCuentaCB + "')");
	
		if (!q.exec()) {
			debug(util.translate("scripts", "Error buscando cuentas ") + codCuentaCB, MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			continue;
		}
	
		suma = 0;
		while (q.next()) {
			suma += parseFloat(q.value(0));
		}
	
		// El pasivo cambia de signo
		// Si es PG siempre cambia de signo
		if (naturaleza == "P" || naturaleza == "PG")
			suma = 0 - suma;
		
		curTab.select("codbalance = '" + codBalance + "' and idbalance = " + idBalance);
		if (curTab.first()) {
			curTab.setModeAccess(curTab.Edit);
			curTab.refreshBuffer();
			sumaActual = parseFloat(curTab.valueBuffer(posicion));
		}
		else {
			curTab.setModeAccess(curTab.Insert);
			curTab.refreshBuffer();
			curTab.setValueBuffer("codbalance", codBalance);
			curTab.setValueBuffer("idbalance", idBalance);
			sumaActual = 0;
		}
		
		suma += sumaActual;
		
		curTab.setValueBuffer(posicion, suma);
		curTab.commitBuffer();
	}
	
	util.destroyProgressDialog();
	
	return true;
}


function pgc2008_vaciarBuffer08(idBalance:Number)
{
	var util:FLUtil = new FLUtil();
	
	if (!util.sqlDelete("co_i_balances08_datos", "idbalance = " + idBalance)) {
		MessageBox.critical(util.translate("scripts", "No se pudo vaciar el buffer. Inténtelo de nuevo más tarde"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return;
	}
	
	if (!util.sqlDelete("co_i_balances08_subtotales", "idbalance = " + idBalance)) {
		MessageBox.critical(util.translate("scripts", "No se pudo vaciar el buffer. Inténtelo de nuevo más tarde"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return;
	}
	
	return true;
}


/** En la tabla de buffer sustituye el valor de la cuenta 129 (CBL P-A-1-VII-) por los resultados del ejercicio
*/
function pgc2008_resultadoEjercicio08(posicion:String, idBalance:Number):Boolean
{
	var util:FLUtil = new FLUtil();	
	var curTab:FLSqlCursor = new FLSqlCursor("co_i_balances08_datos")
	
	var resultadoEj:Number = util.sqlSelect("co_i_balances08_datos", "sum(" + posicion + ")", "idbalance=" + idBalance + " and codbalance like 'PG%'");
	debug(posicion + " " + resultadoEj);
	curTab.select("codbalance = 'P-A-1-VII-' and idbalance = " + idBalance);
	if (curTab.first()) {
		curTab.setModeAccess(curTab.Edit);
		curTab.refreshBuffer();
	}
	else {
		curTab.setModeAccess(curTab.Insert);
		curTab.refreshBuffer();
		curTab.setValueBuffer("codbalance", "P-A-1-VII-");
	}
		
	// Se suma la del año anterior (129 asiento apertura) con el resultado del presente
	resultadoEj += parseFloat(curTab.valueBuffer(posicion));
	
	curTab.setValueBuffer("idbalance", idBalance);
	curTab.setValueBuffer(posicion, resultadoEj);
	curTab.commitBuffer();
}



function pgc2008_labelBalances08(nodo:FLDomNode, campo:String):String
{
	var texto:String = "";

	switch(campo) {
	
		case "naturaleza":
		
			switch(nodo.attributeValue("cbl.naturaleza")) {
				case "A":
					texto = " ACTIVO";
					break;
				case "P":
					texto = " PATRIMONIO NETO Y PASIVO";
					break;
			}
		
		break;
		
		default:
	
			switch(nodo.attributeValue("cbl.naturaleza")) {
				case "A":
					texto = " TOTAL ACTIVO (A+B)";
					break;
				case "P":
					texto = " TOTAL PATRIMONIO NETO Y PASIVO (A+B+C)";
					break;
			}
	
	}
	
	return texto;
}

function pgc2008_subTotalesBalances08(nodo:FLDomNode, campo:String):String
{
	var util:FLUtil = new FLUtil();
	var texto:String = "";
	var valor:Number = 0;
	
	var formato:String = "N"; // Normal
	if (util.sqlSelect("co_i_cuentasanuales", "formato", "id = " + this.iface.idInformeActual) == "Abreviado")
		formato = "A"; // Abreviado
	
	var nivel1:Number = nodo.attributeValue("cbl.nivel1");
	var nivel2:Number = nodo.attributeValue("cbl.nivel2");
	var mostrar1:Boolean,mostrar2:Boolean,mostrar34:Boolean,mostrar5:Boolean;

	if (nivel2 < 12  && !util.sqlSelect("co_i_balances08_subtotales", "indice", "indice < 12 AND indice > " +  nivel2 + " and idbalance=" + this.iface.idInformeActual ))
		mostrar1 = true;
	
	if (nivel2 < 17 && !util.sqlSelect("co_i_balances08_subtotales", "indice", "indice < 17 and indice > " + nivel2 + " and idbalance=" + this.iface.idInformeActual ))
		mostrar2 = true;
	
	if (nivel2 < 18 && !util.sqlSelect("co_i_balances08_subtotales", "indice", "indice < 18 and indice > " + nivel2 + " and idbalance=" + this.iface.idInformeActual ))
		mostrar34 = true;

	if (nivel2 < 19 && !util.sqlSelect("co_i_balances08_subtotales", "indice", "indice < 19 and indice > " + nivel2 + " and idbalance=" + this.iface.idInformeActual ))
		mostrar5 = true;
	
	switch(campo) {
	
		case "labelpyg":
		
			if (mostrar1) {
				if (formato == "N")
					texto += "\nA.1) RESULTADOS DE EXPLOTACIÓN (1+2+3+4+5+6+7+8+9+10+11)";
				else
					texto += "\nA) RESULTADOS DE EXPLOTACIÓN (1+2+3+4+5+6+7+8+9+10+11)";
			}
		
			if (mostrar2) {
				if (formato == "N") {
					texto += "\nA.2) RESULTADO FINANCIERO (12+13+14+15+16)";
					texto += "\nA.3) RESULTADO ANTES DE IMPUESTOS (A.1+A.2)";
				}
				else {
					texto += "\nB) RESULTADO FINANCIERO (12+13+14+15+16)";
					texto += "\nC) RESULTADO ANTES DE IMPUESTOS (A+B)";
				}
			}
		
			if (mostrar34) {
				if (formato == "N") {
					texto += "\nA.4) RESULTADO DEL EJERCICIO PROCEDENTE DE OPERACIONES CONTINUADAS (A.3+17)";
					texto += "\n\nB) OPERACIONES INTERRUMPIDAS\n";
				}
				else {
					texto += "\nD) RESULTADO DEL EJERCICIO (C+17)";
				}
			}

			if (mostrar5) {
				if (formato == "N") {
					texto += "\nA.5) RESULTADO DEL EJERCICIO (A.4+18)";
				}
			}
		
		break;
	
		case "valoractpyg":
		
			if (mostrar1) {
				valor = util.sqlSelect("co_i_balances08_subtotales", "sum(saldoact)", "idbalance=" + this.iface.idInformeActual + " AND indice <=11");
				texto += "\n" + util.formatoMiles(util.buildNumber(valor, "f", 2));
			}
			if (mostrar2) {
				valor = util.sqlSelect("co_i_balances08_subtotales", "sum(saldoact)", "idbalance=" + this.iface.idInformeActual + " AND indice >=12 AND indice <=16");
				texto += "\n" + util.formatoMiles(util.buildNumber(valor, "f", 2));
				valor = 0;
				valor = util.sqlSelect("co_i_balances08_subtotales", "sum(saldoact)", "idbalance=" + this.iface.idInformeActual + " AND indice <=16");
				texto += "\n" + util.formatoMiles(util.buildNumber(valor, "f", 2));
			}
			if (mostrar34) {
				valor = util.sqlSelect("co_i_balances08_subtotales", "sum(saldoact)", "idbalance=" + this.iface.idInformeActual + " AND indice <=17");
				texto += "\n" + util.formatoMiles(util.buildNumber(valor, "f", 2));
					if (formato == "N")
						texto += "\n";
			}
			if (mostrar5) {
				if (formato == "N") {
					valor = util.sqlSelect("co_i_balances08_subtotales", "sum(saldoact)", "idbalance=" + this.iface.idInformeActual + " AND indice <=18");
					valor += parseFloat(util.sqlSelect("co_i_balances08_datos", "saldoact", "idbalance=" + this.iface.idInformeActual + " AND codbalance = 'PG-B-18--'"));
					texto += "\n" + util.formatoMiles(util.buildNumber(valor, "f", 2));
				}
			}
			
		break;
	
		case "valorantpyg":
		
			if (mostrar1) {
				valor = util.sqlSelect("co_i_balances08_subtotales", "sum(saldoant)", "idbalance=" + this.iface.idInformeActual + " AND indice <=11");
				texto += "\n" + util.formatoMiles(util.buildNumber(valor, "f", 2));
			}
			if (mostrar2) {
				valor = util.sqlSelect("co_i_balances08_subtotales", "sum(saldoant)", "idbalance=" + this.iface.idInformeActual + " AND indice >=12 AND indice <=16");
				texto += "\n" + util.formatoMiles(util.buildNumber(valor, "f", 2));
				valor = 0;
				valor = util.sqlSelect("co_i_balances08_subtotales", "sum(saldoant)", "idbalance=" + this.iface.idInformeActual + " AND indice <=16");
				texto += "\n" + util.formatoMiles(util.buildNumber(valor, "f", 2));
			}
			if (mostrar34) {
				valor = util.sqlSelect("co_i_balances08_subtotales", "sum(saldoant)", "idbalance=" + this.iface.idInformeActual + " AND indice <=17");
				texto += "\n" + util.formatoMiles(util.buildNumber(valor, "f", 2));
				if (formato == "N") 
					texto += "\n";
			}
			if (mostrar5) {
				if (formato == "N") {
					valor = util.sqlSelect("co_i_balances08_subtotales", "sum(saldoant)", "idbalance=" + this.iface.idInformeActual + " AND indice <=18");
					valor += parseFloat(util.sqlSelect("co_i_balances08_datos", "saldoant", "idbalance=" + this.iface.idInformeActual + " AND codbalance = 'PG-B-18--'"));
					texto += "\n" + util.formatoMiles(util.buildNumber(valor, "f", 2));
				}
			}
			
		break;
		
		
		case "valorigact":
			valor = util.sqlSelect("co_i_balances08_datos", "saldoact", "idbalance=" + this.iface.idInformeActual + " AND codbalance = 'P-A-1-VII-'");
			if (nivel1 == "B")
				valor += parseFloat(util.sqlSelect("co_i_balances08_datos", "sum(saldoact)", "idbalance=" + this.iface.idInformeActual + " AND codbalance like 'IG%'"));
			texto = util.formatoMiles(util.buildNumber(valor, "f", 2));
		break;
		
		case "valorigant":
			valor = util.sqlSelect("co_i_balances08_datos", "saldoant", "idbalance=" + this.iface.idInformeActual + " AND codbalance = 'P-A-1-VII-'");
			if (nivel1 == "B")
				valor += parseFloat(util.sqlSelect("co_i_balances08_datos", "sum(saldoant)", "idbalance=" + this.iface.idInformeActual + " AND codbalance like 'IG%'"));
			texto = util.formatoMiles(util.buildNumber(valor, "f", 2));
		break;
		
		
		case "labelig":
			if (nivel1 == "A")
				texto += "B) Total ingresos imputados al patrimonio neto (I+II+III+IV+V)\n";
			if (nivel1 == "B")
				texto += "C) Total transferencias a la cuenta de pérdidas y ganancias (VI+VII+VIII+IX)\n";
			
		break;
	}
	
	return texto;
}


function pgc2008_calcularSubTotalesBalances08(idBalance:Number)
{
	var util:FLUtil = new FLUtil();
	
	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList("co_codbalances08,co_i_balances08_datos");
	q.setFrom("co_codbalances08 cbl LEFT JOIN co_i_balances08_datos buf on cbl.codbalance = buf.codbalance");
	q.setWhere("cbl.naturaleza = 'PG' and buf.idbalance=" + idBalance + " group by cbl.nivel2 order by cbl.nivel2");
	q.setSelect("cbl.nivel2,sum(buf.saldoact),sum(buf.saldoant)");
	
	var curTab:FLSqlCursor = new FLSqlCursor("co_i_balances08_subtotales")
	
	q.exec();		
	while (q.next()) {
		
		curTab.select("indice = " + q.value(0) + " and idbalance = " + idBalance);
		if (curTab.first()) {
			curTab.setModeAccess(curTab.Edit);
			curTab.refreshBuffer();
		}
		else {
			curTab.setModeAccess(curTab.Insert);
			curTab.refreshBuffer();
			curTab.setValueBuffer("idbalance", idBalance);
			curTab.setValueBuffer("indice", q.value(0));
		}
		
		curTab.setValueBuffer("saldoact", q.value(1));
		curTab.setValueBuffer("saldoant", q.value(2));
		curTab.commitBuffer();
	}
}

function pgc2008_completarPGB18(posicion:String, idBalance:Number)
{
	var curTab:FLSqlCursor = new FLSqlCursor("co_i_balances08_datos")
	curTab.select("codbalance = 'PG-B-18--' and idbalance = " + idBalance);
	if (!curTab.first()) {
		curTab.setModeAccess(curTab.Insert);
		curTab.refreshBuffer();
		curTab.setValueBuffer("codbalance", "PG-B-18--");
		curTab.setValueBuffer("idbalance", idBalance);
		curTab.setValueBuffer(posicion, 0);
		curTab.commitBuffer();
	}
}

function pgc2008_cabeceraInforme(nodo:FLDomNode, campo:String):String
{
	var texCampo:String = new String(campo);

	var util:FLUtil = new FLUtil();
	var desc:String;
	var ejAct:String, ejAnt:String;

	var texto:String;
	var sep:String = "       ";

	var qCondiciones:FLSqlQuery = new FLSqlQuery();

	qCondiciones.setWhere("id = " + this.iface.idInformeActual);

	switch (texCampo) {

		case "balancepyg08":
	
			qCondiciones.setTablesList("co_i_cuentasanuales");
			qCondiciones.setFrom("co_i_cuentasanuales");
			qCondiciones.setSelect("descripcion,i_co__subcuentas_codejercicioact,i_co__subcuentas_codejercicioant");
	
			if (!qCondiciones.exec())
				return "";
			if (!qCondiciones.first())
				return "";
	
			desc = qCondiciones.value(0);
			ejAct = qCondiciones.value(1);
			ejAnt = qCondiciones.value(2);
	
			texto = "[ " + desc + " ]" + sep + "Ejercicio " + ejAct + sep +	"Ejercicio anterior " + ejAnt;
	
		break;

		case "datosEmpresa":
			
			var dE:Array = flfactppal.iface.pub_ejecutarQry("empresa", "nombre,cifnif,direccion,codpostal,ciudad,provincia", "1=1");
		
			texto = dE.nombre + "    CIF/NIF " + dE.cifnif;
			texto += "\n" + dE.direccion + "    " + dE.codpostal + "  " + dE.ciudad + ", " + dE.provincia;
		break;

		case "titSituacion":
			texto = util.sqlSelect("ejercicios", "fechainicio", "codejercicio = '" + this.iface.ejActPYG + "'");
			texto = "  " + util.translate("scripts", "Balance al cierre del ejercicio") + " " + texto.toString().left(4);
		break;

		case "titSituacionAbr":
			texto = util.sqlSelect("ejercicios", "fechainicio", "codejercicio = '" + this.iface.ejActPYG + "'");
			texto = "  " + util.translate("scripts", "Balance de PYMES al cierre del ejercicio") + " " + texto.toString().left(4);
		break;

		case "titIG":
			texto = util.sqlSelect("ejercicios", "fechafin", "codejercicio = '" + this.iface.ejActPYG + "'");
			texto = "  " + util.translate("scripts", "Estado de ingresos y gastos reconocidos correspondiente al ejercicio terminado el") + " " + texto.toString().left(4);
		break;

		case "titIGAbr":
			texto = util.sqlSelect("ejercicios", "fechafin", "codejercicio = '" + this.iface.ejActPYG + "'");
			texto = "  " + util.translate("scripts", "Estado abreviado de ingresos y gastos reconocidos correspondiente al ejercicio terminado el") + " " + texto.toString().left(4);
		break;

		case "ant":
			texto = util.sqlSelect("ejercicios", "nombre", "codejercicio = '" + this.iface.ejAntPYG + "'");
		break;
		
		case "act":
			texto = util.sqlSelect("ejercicios", "nombre", "codejercicio = '" + this.iface.ejActPYG + "'");
		break;
		
		default:
			return this.iface.__cabeceraInforme(nodo, campo);
	}
	
	if (!texto)
		texto = "";
		
	return texto;
}

function pgc2008_cuentasSinCB(codEjercicio:String, abreviado):Boolean
{
	var util:FLUtil = new FLUtil();
	
	var q:FLSqlQuery = new FLSqlQuery();
	var error:String = "";
	
	var tablaCB:String = "co_cuentascb";
	if (abreviado)
		tablaCB = "co_cuentascbba";
	
	q.setTablesList("co_subcuentas," + tablaCB);
	q.setWhere("s.codejercicio='" + codEjercicio + "' and (s.debe>0 OR s.haber>0) and cb.codcuenta is null order by s.codsubcuenta");
	q.setSelect("s.codsubcuenta,s.codcuenta,s.debe,s.haber");
	
	var driver:String = sys.nameDriver();
	debug(driver);
	
	if (driver.left(8) == "FLQMYSQL")
        q.setFrom("co_subcuentas s left join " + tablaCB + " cb on s.codcuenta like concat(cb.codcuenta,'%')");
	else
		q.setFrom("co_subcuentas s left join " + tablaCB + " cb on s.codcuenta like cb.codcuenta || '%'");
	
	q.exec();
	debug(q.sql());
	
	while (q.next()) {
		error += "\n" + util.translate("scripts", "Subcuenta ") + q.value(0)
		error += "   " + util.translate("scripts", "Cuenta ") + q.value(1)
		error += "   " + util.translate("scripts", "Debe: ") + q.value(2)
		error += "   " + util.translate("scripts", "Haber: ") + q.value(3)
	}
	
	if (error) {
		error = util.translate("scripts", "Atención: algunas subcuentas del ejercicio %0 pertenecen a cuentas\nque no tienen asociado un código de balance\nEsto puede motivar que los resultados sean incorrectos\n\nPara corregirlo, es necesario asociar cada cuenta a su código de balance 2008:\n%1\n\n¿Continuar?").arg(codEjercicio).arg(error);
		res = MessageBox.information(util.translate("scripts", error), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
		if (res != MessageBox.Yes)
			return false;
	}	
	
	return true;
}

//// PGC 2008 //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////