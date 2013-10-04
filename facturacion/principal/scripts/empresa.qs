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
	function validateForm():Boolean { return this.ctx.interna_validateForm(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var pbnCambiarEjercicioActual:Object;
	var bloqueoProvincia:Boolean;
	function oficial( context ) { interna( context ); }
	function pbnCambiarEjercicioActual_clicked() {
		return this.ctx.oficial_pbnCambiarEjercicioActual_clicked();
	}
	function mostrarEjercicioActual() {
		return this.ctx.oficial_mostrarEjercicioActual();
	}
	function cambiarEjercicioActual():Boolean {
		return this.ctx.oficial_cambiarEjercicioActual();
	}
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
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
	function pub_cambiarEjercicioActual():Boolean {
		return this.cambiarEjercicioActual();
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
/** \C Cuando cambia el ejercicio actual se establece el título de las ventanas principales con
el nombre del ejercicio seleccionado
\end */
function interna_init()
{
	var cursor:FLSqlCursor = this.cursor();
	this.iface.pbnCambiarEjercicioActual = this.child("pbnCambiarEjercicioActual");
	this.iface.bloqueoProvincia = false;
	connect(this.iface.pbnCambiarEjercicioActual, "clicked()", this, "iface.pbnCambiarEjercicioActual_clicked");
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");

	if (!flfactppal.iface.pub_ejercicioActual())
		flfactppal.iface.pub_cambiarEjercicioActual(this.cursor().valueBuffer("codejercicio"));
	
	this.child("fdbCodEjercicio").close();
	this.child("fdbNombreEjercicio").close();

	this.iface.mostrarEjercicioActual();
}

/**
\C Los datos de la empresa son únicos, por tanto formulario de no presenta los botones de navegación por registros.
\end

\D La gestión del formulario se hace de forma manual mediante el objeto f (FLFormSearchDB)
\end
\end */
function interna_main()
{
	var f:Object = new FLFormSearchDB("empresa");
	var cursor:FLSqlCursor = f.cursor();

	cursor.select();
	if (!cursor.first())
			cursor.setModeAccess(cursor.Insert);
	else
			cursor.setModeAccess(cursor.Edit);

	f.setMainWidget();
	if (cursor.modeAccess() == cursor.Insert)
			f.child("pushButtonCancel").setDisabled(true);
	cursor.refreshBuffer();
	var commitOk:Boolean = false;
	var acpt:Boolean;
	cursor.transaction(false);
	while (!commitOk) {
		acpt = false;
		f.exec("nombre");
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
	}
}

function interna_validateForm():Boolean
{
	var util:FLUtil = new FLUtil();
/** \C No puede activarse la contabilidad integrada si no está cargado el módulo principal de Contabilidad
\end */
	if (!sys.isLoadedModule("flcontppal") && this.cursor().valueBuffer("contintegrada") == true) {
		MessageBox.warning(util.translate("scripts", "No puede activarse la contabilidad integrada si no está cargado el módulo principal de Contabilidad"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
	return true;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Cambia el ejercicio actual para el usuario conectado
*/
function oficial_pbnCambiarEjercicioActual_clicked()
{
	if (!this.iface.cambiarEjercicioActual())
		return;
	this.iface.mostrarEjercicioActual();
}

/** \D Permite seleccionar el ejercicio actual del usuario conectado

@return	true si el cambio se realiza correctamente, false en caso contrario
\end */
function oficial_cambiarEjercicioActual():Boolean
{
	var f:Object = new FLFormSearchDB("ejercicios");
	f.setMainWidget();
	var codEjercicio:String = f.exec("codejercicio");
	if (!codEjercicio)
		return false;
	var ok:Boolean = flfactppal.iface.pub_cambiarEjercicioActual(codEjercicio);
	return ok;
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

function oficial_bufferChanged(fN:String)
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	switch (fN) {
		case "provincia": {
			if (!this.iface.bloqueoProvincia) {
				this.iface.bloqueoProvincia = true;
				flfactppal.iface.pub_obtenerProvincia(this);
				this.iface.bloqueoProvincia = false;
			}
			break;
		}
	}
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
