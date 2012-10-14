/***************************************************************************
                 horasope.qs  -  description
                             -------------------
    begin                : mie dic 19 2007
    copyright            : (C) 2007 by KLO Ingeniería Informática S.L.L.
    email                : software@klo.es
    partly based on code by
    copyright            : (C) 2004 by InfoSiAL S.L.
    email                : mail@infosial.com
 ***************************************************************************/
 /***************************************************************************
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; version 2 of the License.               *
 ***************************************************************************/
/***************************************************************************
   Este  programa es software libre. Puede redistribuirlo y/o modificarlo
   bajo  los  términos  de  la  Licencia  Pública General de GNU   en  su
   versión 2, publicada  por  la  Free  Software Foundation.
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var idInforme:Number;

	function oficial( context ) { interna( context ); } 

	function setIdInforme(idInforme:Number) {
		return this.ctx.oficial_setIdInforme(idInforme);
	}
	function encabezadoInformeCCos(nodo:FLDomNode, campo:String):String {
		return this.ctx.oficial_encabezadoInformeCCos(nodo, campo);
	}
	function encabezadoInformeHOpe(nodo:FLDomNode, campo:String):String {
		return this.ctx.oficial_encabezadoInformeHOpe(nodo, campo);
	}
	function encabezadoInformeHCCos(nodo:FLDomNode, campo:String):String {
		return this.ctx.oficial_encabezadoInformeHCCos(nodo, campo);
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

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/* KLO Estas funciones son para capturar los parámetros de filtro que se ponen en el dialogo del listado
	de forma que se puedan poner en el .kut
*/
function oficial_setIdInforme(idInforme)
{
	this.iface.idInforme = idInforme;
}

// Obtiene los datos de la cabecera para informes de Horas en Centros de Coste.
function oficial_encabezadoInformeCCos(nodo:FLDomNode, campo:String):String
{
	var util:FLUtil = new FLUtil;
	debug("Informe encabezado CCos" + this.iface.idInforme);
	
	var datosInforme:Array = flfactppal.iface.pub_ejecutarQry("i_horascentrocoste", "d_horasope_codcentro,h_horasope_codcentro,d_horasope_fecha,h_horasope_fecha", "id = " + this.iface.idInforme);
	if (datosInforme.result <= 0)
		return "";

	var dFecha = new Date(datosInforme.d_horasope_fecha);		
	var hFecha = new Date(datosInforme.h_horasope_fecha);		
	var texto:String = "";
	texto += util.translate("scripts","CENTROS DE COSTE  ") + datosInforme.d_horasope_codcentro + " - " + datosInforme.h_horasope_codcentro + " ENTRE FECHAS "+
		dFecha.getDate()+"/"+dFecha.getMonth()+"/"+dFecha.getYear()+" - "+
		hFecha.getDate()+"/"+hFecha.getMonth()+"/"+hFecha.getYear();
debug("KLO--> centros coste: "+texto);
	return texto;
}

// Obtiene los datos de la cabecera para informes de Horas de Operarios.
function oficial_encabezadoInformeHOpe(nodo:FLDomNode, campo:String):String
{
	var util:FLUtil = new FLUtil;
	debug("Informe " + this.iface.idInforme);
	
	var datosInforme:Array = flfactppal.iface.pub_ejecutarQry("i_horasoperarios", "d_lineashorasope_codoperario,h_lineashorasope_codoperario,d_horasope_fecha,h_horasope_fecha", "id = " + this.iface.idInforme);
	if (datosInforme.result <= 0)
		return "";
		
	var dFecha = new Date(datosInforme.d_horasope_fecha);		
	var hFecha = new Date(datosInforme.h_horasope_fecha);		
	var texto:String = "";
	texto += util.translate("scripts","OPERARIOS  ") + datosInforme.d_lineashorasope_codoperario + " - " + datosInforme.h_lineashorasope_codoperario + " ENTRE FECHAS "+
		dFecha.getDate()+"/"+dFecha.getMonth()+"/"+dFecha.getYear()+" - "+
		hFecha.getDate()+"/"+hFecha.getMonth()+"/"+hFecha.getYear();

//MessageBox.warning("Encabezado: "+texto, MessageBox.No, MessageBox.Yes, MessageBox.NoButton);

	return texto;
}

// Obtiene los datos de la cabecera para informes de Horas de Operarios entre Centros de Coste.
function oficial_encabezadoInformeHCCos(nodo:FLDomNode, campo:String):String
{
	var util:FLUtil = new FLUtil;
	debug("Informe encabezado HCCos" + this.iface.idInforme);
	
	var datosInforme:Array = flfactppal.iface.pub_ejecutarQry("i_horasoperarios", "d_horasope_codcentro,h_horasope_codcentro,d_horasope_fecha,h_horasope_fecha", "id = " + this.iface.idInforme);
	if (datosInforme.result <= 0)
		return "";
	
	var dFecha = new Date(datosInforme.d_horasope_fecha);		
	var hFecha = new Date(datosInforme.h_horasope_fecha);		
	var texto:String = "";
	texto += util.translate("scripts","CENTROS DE COSTE  ") + datosInforme.d_horasope_codcentro + " - " + datosInforme.h_horasope_codcentro;
	return texto;
}
//// OFICIAL //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
