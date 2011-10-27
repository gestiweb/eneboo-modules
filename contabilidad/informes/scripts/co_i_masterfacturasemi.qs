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
//////////////////////////
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
	var totalRecargoEq_:Number;
	var totalIvaMasRecargoEq_:Number;
	var ultRecargoEq_:Number;
    function oficial( context ) { interna( context ); } 
	function lanzar() {
		return this.ctx.oficial_lanzar();
	}
	function recargoEq(nodo:FLDomNode, campo:String):String {
		return this.ctx.oficial_recargoEq(nodo, campo);
	}
	function totalRecargoEq(nodo:FLDomNode, campo:String):String {
		return this.ctx.oficial_totalRecargoEq(nodo, campo);
	}
	function ivaMasRecargoEq(nodo:FLDomNode, campo:String):String {
		return this.ctx.oficial_ivaMasRecargoEq(nodo, campo);
	}
	function totalIvaMasRecargoEq(nodo:FLDomNode, campo:String):String {
		return this.ctx.oficial_totalIvaMasRecargoEq(nodo, campo);
	}
	function initReport(nodo:FLDomNode, campo:String):String {
		return this.ctx.oficial_initReport(nodo, campo);
	}
	function dameMasWhere():String {
		return this.ctx.oficial_dameMasWhere();
	}
	function dameOrderBy():String {
		return this.ctx.oficial_dameOrderBy();
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
	function pub_recargoEq(nodo:FLDomNode, campo:String):String {
		return this.recargoEq(nodo, campo);
	}
	function pub_totalRecargoEq(nodo:FLDomNode, campo:String):String {
		return this.totalRecargoEq(nodo, campo);
	}
	function pub_ivaMasRecargoEq(nodo:FLDomNode, campo:String):String {
		return this.ivaMasRecargoEq(nodo, campo);
	}
	function pub_totalIvaMasRecargoEq(nodo:FLDomNode, campo:String):String {
		return this.totalIvaMasRecargoEq(nodo, campo);
	}
	function pub_initReport(nodo:FLDomNode, campo:String):String {
		return this.initReport(nodo, campo);
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
/** \D Lanza el informe. Añade al WHERE de la consulta la condición de que sólo se muestren las partidas cuya subcuenta pertenece a una cuenta de tipo especial de I.V.A. repercutido.
\end */
function oficial_lanzar()
{
	var cursor:FLSqlCursor = this.cursor()
	if (!cursor.isValid()) {
		return;
	}

	var nombreInforme:String = cursor.action();
	var nombreReport:String = nombreInforme;
	
	if (cursor.valueBuffer("numeracionauto")) {
		/// nombreReport = nombreReport + "_n"; Ya ne se usa el informe _n, se usa un campo calculado en el informe normal
		flcontinfo.iface.pub_resetearNumFactura(parseFloat(cursor.valueBuffer("numdesde")));
	} else {
		flcontinfo.iface.pub_resetearNumFactura(parseFloat(-1));
	}
	var masWhere:String = this.iface.dameMasWhere();
	var orderBy:String = this.iface.dameOrderBy();
	
	flcontinfo.iface.pub_lanzarInforme(cursor, nombreInforme, nombreReport, orderBy, "", masWhere, cursor.valueBuffer("id"));
}

function oficial_dameOrderBy():String
{
	var cursor:FLSqlCursor = this.cursor();
	var orderBy:String = "";
	var numeracionAuto:Boolean = cursor.valueBuffer("numeracionauto");
	if (numeracionAuto) {
		orderBy = "co_partidas.codserie, co_asientos.fecha, co_partidas.idasiento";
	} else {
		orderBy = "co_partidas.codserie, co_partidas.factura, co_asientos.fecha, co_partidas.idasiento";
	}
	return orderBy;
}

function oficial_dameMasWhere():String
{
	var cursor:FLSqlCursor = this.cursor();
	var masWhere:String = "";
	var conIva:Boolean = cursor.valueBuffer("coniva");
	masWhere = " AND sc1.idcuentaesp IN ('IVAREP', 'IVAEUE', 'IVARXP', 'IVAREX')";
	
	if (conIva) {
		masWhere += " AND co_partidas.iva <> 0";
		masWhere += " AND (series.siniva IS NULL OR series.siniva = false)";
	}
	return masWhere;
}



/** \D Obtiene el recargo de equivalencia de la partida asociada a la cuenta IVAACR del asiento considerado
\end */
function oficial_recargoEq(nodo:FLDomNode, campo:String):String
{
	var util:FLUtil = new FLUtil;
	var idAsiento:String = nodo.attributeValue("co_asientos.idasiento");
	var porIva:String = nodo.attributeValue("co_partidas.iva");
	var porRe:String = nodo.attributeValue("co_partidas.recargo");

	var valor:Number;
	var numRecargo:Number = parseFloat(porRe);
	if (!isNaN(numRecargo) && numRecargo != 0) {
		// El IN (iva, 0) se coloca para que el informe funcione correctamente con flfacturac 2.0, donde no se gualdaban los datos de IVA y recargo en cada partida de recargo de equivalencia
		valor = util.sqlSelect("co_partidas p INNER JOIN co_subcuentas s ON p.idsubcuenta = s.idsubcuenta INNER JOIN co_cuentasesp e ON s.codsubcuenta = e.codsubcuenta", "p.haber - p.debe", "idasiento = " + idAsiento + " AND e.idcuentaesp IN ('IVAACR', 'IVARRE') AND p.iva IN (" + porIva + ", 0) AND p.recargo IN (" + porRe + ", 0)", "co_partidas,co_subcuentas,co_cuentasesp");
		if (!valor) {
			valor = util.sqlSelect("co_partidas p INNER JOIN co_subcuentas s ON p.idsubcuenta = s.idsubcuenta INNER JOIN co_cuentas c ON s.idcuenta = c.idcuenta", "p.haber - p.debe", "idasiento = " + idAsiento + " AND s.idcuentaesp IN ('IVAACR', 'IVARRE') AND p.iva IN (" + porIva + ", 0) AND p.recargo IN (" + porRe + ", 0)", "co_partidas,co_subcuentas,co_cuentas");
		}
	}
	if (!valor) {
		valor = 0;
	}
	this.iface.ultRecargoEq_ = parseFloat(valor);
	this.iface.totalRecargoEq_ += parseFloat(valor);
	return valor;
}

/** \D Obtiene la suma de IVA más el recargo de equivalencia calculado previamente con la función recargoEq
\end */
function oficial_ivaMasRecargoEq(nodo:FLDomNode, campo:String):String
{
	var util:FLUtil = new FLUtil;
	var iva:Number = parseFloat(nodo.attributeValue("(co_partidas.haber - co_partidas.debe)"));
	var baseImponible:Number = parseFloat(nodo.attributeValue("co_partidas.baseimponible"));
	var valor:Number = baseImponible + iva + this.iface.ultRecargoEq_;
	this.iface.totalIvaMasRecargoEq_ += valor;
	return valor;
}

function oficial_initReport(nodo:FLDomNode, campo:String):String
{
	this.iface.ultRecargoEq_ = 0;
	this.iface.totalRecargoEq_ = 0;
	this.iface.totalIvaMasRecargoEq_ = 0;
}

function oficial_totalRecargoEq(nodo:FLDomNode, campo:String):String
{
	return this.iface.totalRecargoEq_;
}

function oficial_totalIvaMasRecargoEq(nodo:FLDomNode, campo:String):String
{
	return this.iface.totalIvaMasRecargoEq_;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
