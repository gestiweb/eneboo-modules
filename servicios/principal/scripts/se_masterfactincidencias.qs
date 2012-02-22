/***************************************************************************
                 se_masterfactincidencias.qs  -  description
                             -------------------
    begin                : mar oct 11 2005
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
	function recordDelBeforefacturascli() {this.ctx.interna_recordDelBeforefacturascli(); }
	function calculateField(fN:String):String {this.ctx.interna_calculateField(fN); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var tbnImprimir:Object;
	var tdbRecords:FLTableDB;
	
    function oficial( context ) { interna( context ); } 
	function imprimir() {
		return this.ctx.oficial_imprimir();
	}
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.oficial_commonCalculateField(fN, cursor);
	}
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration dtoEspecial */
/////////////////////////////////////////////////////////////////
//// DTO ESPECIAL ///////////////////////////////////////////////
class dtoEspecial extends oficial {
    function dtoEspecial( context ) { oficial ( context ); }
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.dtoEspecial_commonCalculateField(fN, cursor);
	}
}
//// DTO ESPECIAL ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends dtoEspecial {
    function head( context ) { dtoEspecial ( context ); }
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration ifaceCtx */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends head {
    function ifaceCtx( context ) { head( context ); }
	function pub_commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.commonCalculateField(fN, cursor);
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
/** \C
Este es el formulario maestro de facturas a cliente.
\end */
function interna_init()
{
	this.iface.tbnImprimir = this.child("toolButtonPrint");
	this.iface.tdbRecords= this.child("tableDBRecords");

	connect(this.iface.tbnImprimir, "clicked()", this, "iface.imprimir");

	var codEjercicio = flfactppal.iface.pub_ejercicioActual();
	if (codEjercicio)
		this.cursor().setMainFilter("codejercicio='" + codEjercicio + "' AND fincidencias = true");
	else
		this.cursor().setMainFilter("fincidencias = true");
}

/** \C
Al borrar una factura, su código será agregado a la tabla de huecos para que pueda ser reutilizado en futuras facturas
\end */
function interna_recordDelBeforefacturascli()
{
	var cursor:FLSqlCursor = this.cursor();
	flfacturac.iface.pub_agregarHueco(cursor.valueBuffer("codserie"), cursor.valueBuffer("codejercicio"), cursor.valueBuffer("numero"), "nfacturacli");
	var qryLineas:FLSqlQuery = new FLSqlQuery();
	qryLineas.setTablesList("lineasfacturascli");
	qryLineas.setSelect("idlinea");
	qryLineas.setFrom("lineasfacturascli");
	qryLineas.setWhere("idfactura = " + cursor.valueBuffer("idfactura"));
	if(!qryLineas.exec())
		return false

	while (qryLineas.next()){
		if(!formRecordse_factincidencias.iface.pub_eliminarLinea(qryLineas.value(0)))
			return false;
	}
	return true;
	
}

function interna_calculateField(fN:String):String
{
	return this.iface.commonCalculateField(fN, this.cursor());
	/** \C
	El --código-- se construye como la concatenación de --codserie--, --codejercicio-- y --numero--
	\end */
	/** \C
	El --total-- es el --neto-- menos el --totalirpf-- más el --totaliva-- más el --totalrecargo-- más el --recfinanciero--
	\end */
	/** \C
	El --totaleuros-- es el producto del --total-- por la --tasaconv--
	\end */
	/** \C
	El --neto-- es la suma del pvp total de las líneas de factura
	\end */
	/** \C
	El --totaliva-- es la suma del iva correspondiente a las líneas de factura
	\end */
	/** \C
	El --totarecargo-- es la suma del recargo correspondiente a las líneas de factura
	\end */
	/** \C
	El --coddir-- corresponde a la dirección del cliente marcada como dirección de facturación
	\end */
	/** \C
	El --irpf-- es el asociado al --codserie-- del albarán
	\end */
	/** \C
	El --totalirpf-- es el producto del --irpf-- por el --neto--
	\end */
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \C
Al pulsar el botón imprimir se lanzará el informe correspondiente a la factura seleccionada (en caso de que el módulo de informes esté cargado)
\end */
function oficial_imprimir()
{
	if (sys.isLoadedModule("flfactinfo")) {
		if (!this.cursor().isValid())
			return;
		var codigo:String = this.cursor().valueBuffer("codigo");
		var curImprimir:FLSqlCursor = new FLSqlCursor("i_facturascli");
		curImprimir.setModeAccess(curImprimir.Insert);
		curImprimir.refreshBuffer();
		curImprimir.setValueBuffer("descripcion", "temp");
		curImprimir.setValueBuffer("d_facturascli_codigo", codigo);
		curImprimir.setValueBuffer("h_facturascli_codigo", codigo);
		flfactinfo.iface.pub_lanzarInforme(curImprimir, "i_facturascli");
	} else
		flfactppal.iface.pub_msgNoDisponible("Informes");
}

function oficial_commonCalculateField(fN:String, cursor:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil();
	var valor:String;

	if (fN == "codigo")
		valor = flfacturac.iface.pub_construirCodigo(cursor.valueBuffer("codserie"), cursor.valueBuffer("codejercicio"), cursor.valueBuffer("numero"));

	switch (fN) {
	case "total":{
			var neto:Number = parseFloat(cursor.valueBuffer("neto"));
			var totalIrpf:Number = parseFloat(cursor.valueBuffer("totalirpf"));
			var totalIva:Number = parseFloat(cursor.valueBuffer("totaliva"));
			var totalRecargo:Number = parseFloat(cursor.valueBuffer("totalrecargo"));
			var recFinanciero:Number = (parseFloat(cursor.valueBuffer("recfinanciero")) * neto) / 100;
			recFinanciero = parseFloat(util.roundFieldValue(recFinanciero, "facturascli", "total"));
			valor = neto - totalIrpf + totalIva + totalRecargo + recFinanciero;
			break;
		}
	case "lblComision":{
			valor = (parseFloat(cursor.valueBuffer("porcomision")) * (parseFloat(cursor.valueBuffer("neto")))) / 100;
			break;
		}
	case "lblRecFinanciero":{
			valor = (parseFloat(cursor.valueBuffer("recfinanciero")) * (parseFloat(cursor.valueBuffer("neto")))) / 100;
			break;
		}
	case "totaleuros":{
			var total:Number = parseFloat(cursor.valueBuffer("total"));
			var tasaConv:Number = parseFloat(cursor.valueBuffer("tasaconv"));
			valor = total * tasaConv;
			valor = parseFloat(util.roundFieldValue(valor, "facturascli", "totaleuros"));
			break;
		}
	case "neto":{
			valor = util.sqlSelect("lineasivafactcli", "SUM(neto)", "idfactura = " + cursor.valueBuffer("idfactura"));
			break;
		}
	case "totaliva":{
			valor = util.sqlSelect("lineasivafactcli", "SUM(totaliva)", "idfactura = " + cursor.valueBuffer("idfactura"));
			valor = parseFloat(util.roundFieldValue(valor, "facturascli", "totaliva"));
			break;
		}
	case "totalrecargo":{
			valor = util.sqlSelect("lineasivafactcli", "SUM(totalrecargo)", "idfactura = " + cursor.valueBuffer("idfactura"));
			valor = parseFloat(util.roundFieldValue(valor, "facturascli", "totalrecargo"));
			break;
		}
	case "coddir": {
			valor = util.sqlSelect("dirclientes", "id", "codcliente = '" + cursor.valueBuffer("codcliente") +  "' AND domfacturacion = 'true'");
			break;
		}
	case "irpf": {
			valor = util.sqlSelect("series", "irpf", "codserie = '" + cursor.valueBuffer("codserie") + "'");
			break;
		}
	case "totalirpf": {
			valor = (parseFloat(cursor.valueBuffer("irpf")) * (parseFloat(cursor.valueBuffer("neto")))) / 100;
			valor = parseFloat(util.roundFieldValue(valor, "facturascli", "totalirpf"));
			break;
		}
	}
	return valor;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition dtoEspecial */
/////////////////////////////////////////////////////////////////
//// DTO ESPECIAL ///////////////////////////////////////////////
function dtoEspecial_commonCalculateField(fN:String, cursor:FLSqlCursor):String
{
	var util = new FLUtil();
	var valor;

	switch (fN) {
	/** \C
	El --totaliva-- es la suma del iva correspondiente a las líneas de factura
	\end */
		case "totaliva":{
			if (parseFloat(cursor.valueBuffer("dtoesp")) == 0) {
				valor = this.iface.__commonCalculateField(fN, cursor);
			} else {
				var iva:Number = util.sqlSelect("lineasfacturascli", "iva", "idfactura = " + cursor.valueBuffer("idfactura"));
				valor = parseFloat(cursor.valueBuffer("neto")) * iva / 100;
			}
			break;
		}
	/** \C
	El --totarecargo-- es la suma del recargo correspondiente a las líneas de factura
	\end */
		case "totalrecargo":{
			if (parseFloat(cursor.valueBuffer("dtoesp")) == 0) {
				valor = this.iface.__commonCalculateField(fN, cursor); 
			} else {
				var recargo:Number = util.sqlSelect("lineasfacturascli", "recargo", "idfactura = " + cursor.valueBuffer("idfactura"));
				valor = parseFloat(cursor.valueBuffer("neto")) * recargo / 100;
			}
			break;
		}
	/** \C
	El --netosindtoesp-- es la suma del pvp total de las líneas de factura
	\end */
		case "netosindtoesp":{
			valor = util.sqlSelect("lineasfacturascli", "SUM(pvptotal)", "idfactura = " + cursor.valueBuffer("idfactura"));
			break;
		}
	/** \C
	El --neto-- es el --netosindtoesp-- menos el --dtoesp--
	\end */
		case "neto": {
			valor = parseFloat(cursor.valueBuffer("netosindtoesp")) - parseFloat(cursor.valueBuffer("dtoesp"));
			break;
		}
	/** \C
	El --dtoesp-- es el --netosindtoesp-- menos el porcentaje que marca el --pordtoesp--
	\end */
		case "dtoesp": {
			valor = (parseFloat(cursor.valueBuffer("netosindtoesp")) * parseFloat(cursor.valueBuffer("pordtoesp"))) / 100;
			break;
		}
		default: {
			valor = this.iface.__commonCalculateField(fN, cursor);
			break;
		}
	}
	return valor;
}
//// DTO ESPECIAL ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////