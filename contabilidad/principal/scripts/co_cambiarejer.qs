/***************************************************************************
                 empresa.qs  -  description
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
    function main() { this.ctx.interna_main(); }
	function init() { this.ctx.interna_init(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    var pbnCambiarEjercicioActual:Object;
    function oficial( context ) { interna( context ); } 
	function pbnCambiarEjercicioActual_clicked() {
		return this.ctx.oficial_pbnCambiarEjercicioActual_clicked();
	}
	function mostrarEjercicioActual() {
		return this.ctx.oficial_mostrarEjercicioActual();
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
/** \C Cuando cambia el ejercicio actual se establece el título de las ventanas principales con
el nombre del ejercicio seleccionado
\end */
function interna_init()
{
	this.iface.pbnCambiarEjercicioActual = this.child("pbnCambiarEjercicioActual");
	connect(this.iface.pbnCambiarEjercicioActual, "clicked()", this, "iface.pbnCambiarEjercicioActual_clicked");
	
	this.iface.mostrarEjercicioActual();
}

/** \C Se abre un diálogo que permite seleccionar un ejercicio entre los existentes, o bien crear un nuevo ejercicio
\end */
function interna_main()
{
		var f:Object = new FLFormSearchDB("co_cambiarejer");
		var cursor:FLSqlCursor = f.cursor();

		cursor.select();
		if (!cursor.first())
				return false;
		else
				cursor.setModeAccess(cursor.Edit);

		f.setMainWidget();
		cursor.refreshBuffer();
		var commitOk:Boolean = false;
		var acpt:Boolean;
		cursor.transaction(false);
		while (!commitOk) {
				acpt = false;
				f.exec("codejercicio");
				acpt = f.accepted();
				if (!acpt) {
						if (cursor.rollback())
								commitOk = true;
				} else {
						if (cursor.commitBuffer()) {
								cursor.commit();
								commitOk = true;
						}
				}
				f.close();
		}
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial*/
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Cambia el ejercicio actual para el usuario conectado
*/
function oficial_pbnCambiarEjercicioActual_clicked()
{
	if (!formempresa.iface.pub_cambiarEjercicioActual())
		return;

	this.iface.mostrarEjercicioActual();
}

/** \D Muestra el ejercicio actual en el formulario y en el Main Widget
*/
function oficial_mostrarEjercicioActual()
{
	var util:FLUtil = new FLUtil();
	
	var codEjercicio:String = flfactppal.iface.pub_ejercicioActual();
	var nombreEjercicio:String = util.sqlSelect( "ejercicios", "nombre", "codejercicio='" + codEjercicio + "'" );
	try {
		sys.setCaptionMainWidget( nombreEjercicio );
		this.child("lblValEjercicioActual").text = codEjercicio + " - " + nombreEjercicio;
		this.child("lblEjercicioActual").text = util.translate("scripts", "Ejercicio actual para ") + sys.nameUser() + ":";
	}
	catch (e) {}
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
