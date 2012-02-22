/***************************************************************************
                 mv_log.qs  -  description
                             -------------------
    begin                : mar may 10 2005
    copyright            : (C) 2005 by InfoSiAL S.L.
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

////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

/** @class_declaration interna */
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
    function oficial( context ) { interna( context ); } 
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
function interna_init() {
	
  this.child("log").setMaxLogLines( 100 );
	this.child("pushButtonAccept").close();
	var miVar:FLVar = new FLVar;
	var tipoAccion:String = miVar.get("ACCIONMV");
	
	switch (tipoAccion) {
		case "FR": {
			var codFuncional:String = this.cursor().valueBuffer("codfuncional");
			formmv_funcional.iface.pub_recargarFun(codFuncional);
			break;
		}
		case "FP": {
			var codFuncional:String = this.cursor().valueBuffer("codfuncional");
			formmv_funcional.iface.pub_probarFun(codFuncional);
			break;
		}
		case "FS": {
			var codFuncional:String = this.cursor().valueBuffer("codfuncional");
			formmv_funcional.iface.pub_subirFun(codFuncional);
			break;
		}
		case "FC": {
			var codFuncional:String = this.cursor().valueBuffer("codfuncional");
			formmv_funcional.iface.pub_crearFun(codFuncional);
			break;
		}
		case "FB": {
			var codFuncional:String = this.cursor().valueBuffer("codfuncional");
			formmv_funcional.iface.pub_bajarFun(codFuncional);
			break;
		}
		case "FA": {
			var codFuncional:String = this.cursor().valueBuffer("codfuncional");
			formmv_funcional.iface.pub_actualizarFun(codFuncional);
			break;
		}
		case "CB": {
			var idCliente:String = this.cursor().valueBuffer("idcliente");
			formmv_clientes.iface.pub_generar(idCliente);
			break;
		}
		case "PS": {
			var codProyecto:String = this.cursor().valueBuffer("codfuncional");
			formmv_proyectos.iface.pub_subirPruebas(codProyecto);
			break;
		}
		case "PC": {
			var codProyecto:String = this.cursor().valueBuffer("codfuncional");
			formmv_proyectos.iface.pub_crearPro(codProyecto);
			break;
		}
		case "PB": {
			var codProyecto:String = this.cursor().valueBuffer("codfuncional");
			formmv_proyectos.iface.pub_bajarPro(codProyecto);
			break;
		}
		case "PE": {
			var codProyecto:String = this.cursor().valueBuffer("codfuncional");
			formmv_proyectos.iface.pub_exportarPro(codProyecto);
			break;
		}
	}
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////