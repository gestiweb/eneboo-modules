/***************************************************************************
                 tdb_seleccion.qs  -  description
                             -------------------
    begin                : 2008
    copyright            : (C) 2008 by InfoSiAL S.L.
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
  var ctx;
  function interna( context ) { this.ctx = context; }
  function init() {
    this.ctx.interna_init();
  }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var visor;
/// 	var tbnEnviarMail;
	function oficial( context ) { interna( context ); }
/// 	function enviarEMail() {
/// 		return this.ctx.oficial_enviarEMail();
/// 	}
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends oficial {
  function head( context ) { oficial( context ); }
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
///	this.iface.tbnEnviarMail = this.child( "tbnEnviarMail" );
///	connect( this.iface.tbnEnviarMail, "clicked()", this, "iface.enviarEMail()" );

//    var pageSize = new Size( 900, 800 );
	this.iface.visor = flfactinfo.iface.visor_; //new FLReportViewer( this.child( "frmView" ) );
	this.iface.visor.reparent(this.child( "frmView" ));

//    this.iface.visor.setPageDimensions( pageSize );
//    this.iface.visor.appendPage();
//    this.iface.visor.rptViewerEmbedInParent( this.child( "frmView" ) );
//     this.iface.visor.updateDisplay();
// debug("init4");
//     this.iface.visor.show();
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
// function oficial_enviarEMail()
// {
// 	var util:FLUtil = new FLUtil;
// debug("oficial_enviarEMail");
// 	var tabla:String;
// 	
// 	var rutaIntermedia:String = util.readSettingEntry("scripts/flfactinfo/dirCorreo");
// 	if (!rutaIntermedia.endsWith("/")) {
// 		rutaIntermedia += "/";
// 	}
// 
// 	var cuerpo:String = "";
// 	var asunto:String;
// 	var rutaDocumento:String = "";
// 	var emailDestino:String = "";
// 
// 	var datosEMail:Array = flfactinfo.iface.datosEMail;
// 	if (datosEMail) {
// 		var tipoInforme:String = datosEMail.tipoInforme;
// 		switch (tipoInforme) {
// 			case "facturascli": {
// 				tabla = "clientes";
// 				var codCliente:String = datosEMail.codDestino;
// 				var codFactura = datosEMail.codDocumento;
// 				emailDestino = flfactppal.iface.pub_componerListaDestinatarios(codCliente, tabla);
// 				asunto = util.translate("scripts", "Factura %1").arg(codFactura);
// 				rutaDocumento = rutaIntermedia + "F_" + codFactura + ".pdf";
// 				break;
// 			}
// 		}
// 	}
// 	delete flfactinfo.iface.datosEMail; /// Para que no se quede para el próximo informe
// 	flfactinfo.iface.datosEMail = false;
// 	if (!rutaDocumento || rutaDocumento == "") {
// 		var nombre:String = Input.getText(util.translate("scripts", "Nombre del fichero a enviar"));
// 		if (!nombre || nombre == "") {
// 			return false;
// 		}
// 		if (!nombre.toLowerCase().endsWith(".pdf")) {
// 			nombre += ".pdf";
// 		}
// 		rutaDocumento = rutaIntermedia + nombre;
// 	}
// 	this.iface.visor.printReportToPDF(rutaDocumento);
// 	var arrayDest:Array = [];
// 	arrayDest[0] = [];
// 	arrayDest[0]["tipo"] = "to";
// 	arrayDest[0]["direccion"] = emailDestino;
// 
// 	var arrayAttach:Array = [];
// 	arrayAttach[0] = rutaDocumento;
// 
// 	flfactppal.iface.pub_enviarCorreo(cuerpo, asunto, arrayDest, arrayAttach);
// }
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
