/***************************************************************************
                 in_config.qs  -  description
                             -------------------
    begin                : jue nov 5 2009
    copyright            : (C) 2009 by InfoSiAL S.L.
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
	function main() {
		this.ctx.interna_main();
	}
	function init() {
		this.ctx.interna_init();
	}
	function calculateField(fN:String):String {
		return this.ctx.interna_calculateField(fN);
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	function oficial( context ) { interna( context ); }
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function tituloConexion() {
		return this.ctx.oficial_tituloConexion();
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
/**
\C Los datos generales son únicos, por tanto formulario de no presenta los botones de navegación por registros.
\end

\D La gestión del formulario se hace de forma manual mediante el objeto f (FLFormSearchDB)
\end
\end */
function interna_main()
{
	var f:Object = new FLFormSearchDB("in_config");
	var cursor:FLSqlCursor = f.cursor();

	cursor.select();
	if (!cursor.first()) {
		cursor.setModeAccess(cursor.Insert);
	} else {
		cursor.setModeAccess(cursor.Edit);
	}
	f.setMainWidget();
	if (cursor.modeAccess() == cursor.Insert) {
		f.child("pushButtonCancel").setDisabled(true);
	}
	cursor.refreshBuffer();
	var commitOk:Boolean = false;
	var acpt:Boolean;
	cursor.transaction(false);
	while (!commitOk) {
		acpt = false;
		f.exec("id");
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

function interna_init()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	connect (cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	this.iface.tituloConexion();
}

function interna_calculateField(fN:String):String
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var valor:String;

	switch (fN) {
		case "puerto": {
			var tipoDriver:String = cursor.valueBuffer("driver");
			switch (tipoDriver) {
				case "PostgreSQL": {
					valor = 5432;
					break;
				}
				case "MySQL": {
					valor = 3306;
					break;
				}
			}
			break;
		}
		default: {
			valor = this.iface.__calculateField(fN);
			break;
		}
	}

	return valor;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_bufferChanged(fN:String)
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	switch (fN) {
		case "basedatoslocal": {
			this.iface.tituloConexion();
			break;
		}
		case "driver": {
			this.child("fdbPuerto").setValue(this.iface.calculateField("puerto"));
			break;
		}
	}
}

function oficial_tituloConexion()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var titulo:String;
	var habilitar:Boolean;
	
	switch (cursor.valueBuffer("basedatoslocal")) {
		case "Ambas": {
			habilitar = false;
			titulo = "";
			this.child("fdbServidor").setValue("");
			this.child("fdbBaseDatos").setValue("");
			break;
		}
		case "Origen": {
			habilitar = true;
			titulo = util.translate("scripts", "Conexión a base de datos destino");
			break;
		}
		case "Destino": {
			habilitar = true;
			titulo = util.translate("scripts", "Conexión a base de datos origen");
			break;
		}
	}

	this.child("gbxConexion").enabled = habilitar;
	this.child("gbxConexion").title = titulo;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
