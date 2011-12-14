/***************************************************************************
                 crm_mastertareas.qs  -  description
                             -------------------
    begin                : mar feb 06 2006
    copyright            : (C) 2006 by InfoSiAL S.L.
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
/** \C
\end */
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
	var bgrTipoObjeto:Object;
	var tbnBuscarObjeto:Object;
	var lblNombreObjeto:Object;
    function oficial( context ) { interna( context ); }
	function grupoBotones_clicked() {
		return this.ctx.oficial_grupoBotones_clicked();
	}
	function tbnBuscarObjeto_clicked() {
		return this.ctx.oficial_tbnBuscarObjeto_clicked();
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
	this.iface.bgrTipoObjeto = this.child("bgrTipoObjeto");
	this.iface.tbnBuscarObjeto = this.child("tbnBuscarObjeto");
	this.iface.lblNombreObjeto = this.child("lblNombreObjeto");

	connect(this.iface.bgrTipoObjeto, "clicked(int)", this, "iface.grupoBotones_clicked");
	connect(this.iface.tbnBuscarObjeto, "clicked()", this, "iface.tbnBuscarObjeto_clicked");
	var datosS:Array;
	datosS["tipoObjeto"] = "todos";
	datosS["idObjeto"] = "0";
	datosS["formulario"] = "crm_mastertareas";
	flcolaproc.iface.pub_seguimientoOn(this, datosS);
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_grupoBotones_clicked(idBoton:Number)
{
	this.iface.lblNombreObjeto.text = "";
	flcolaproc.iface.pub_filtroFormularioS("");
}

function oficial_tbnBuscarObjeto_clicked()
{
	var util:FLUtil = new FLUtil();

	var idBoton:Number = this.iface.bgrTipoObjeto.selectedId;
	var tipoObjeto:String = "";
	var nombreClave:String = "";
	switch (idBoton) {
		case 0: { // Clientes
			tipoObjeto = "clientes";
			nombreClave = "codcliente";
			break;
		}
		case 1: { // Contactos
			tipoObjeto = "crm_contactos";
			nombreClave = "codcontacto";
			break;
		}
		case 2: { // Tarjetas
			tipoObjeto = "crm_tarjetas";
			nombreClave = "codtarjeta";
			break;
		}
		case 3: { // Incidencias
			tipoObjeto = "crm_incidencias";
			nombreClave = "codincidencia";
			break;
		}
		default: {
			return;
		}
	}

	var f:Object = new FLFormSearchDB(tipoObjeto);
	f.setMainWidget();
	var clave:String = f.exec(nombreClave);

	if (clave) {
		flcolaproc.iface.pub_filtroFormularioS("tipoobjeto = '" + tipoObjeto + "' AND idobjeto = '" + clave + "'");
		var texto:String = "";
		switch (tipoObjeto) {
			case "clientes": {
				texto = util.translate("scripts", "Cliente %1 - %2").arg(clave).arg(util.sqlSelect("clientes", "nombre", "codcliente = '" + clave + "'"));
				break;
			}
			case "crm_contactos": {
				texto = util.translate("scripts", "Contacto %1 - %2").arg(clave).arg(util.sqlSelect("crm_contactos", "nombre", "codcontacto = '" + clave + "'"));
				break;
			}
			case "crm_tarjetas": {
				texto = util.translate("scripts", "Tarjeta %1 - Cliente %2").arg(clave).arg(util.sqlSelect("crm_tarjetas", "nombre", "codtarjeta = '" + clave + "'"));
				break;
			}
			case "crm_incidencias": {
				texto = util.translate("scripts", "Incidencia %1 - %2").arg(clave).arg(util.sqlSelect("crm_incidencias", "descripcion", "codincidencia = '" + clave + "'"));
				break;
			}
		}
		this.iface.lblNombreObjeto.text = texto;
	}
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
