/***************************************************************************
                 gd_config.qs  -  description
                             -------------------
    begin                : vie jul 21 2006
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
////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

/** @class_declaration interna */
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	function oficial( context ) { interna( context ); }
	function cambiarExp() {
		return this.ctx.oficial_cambiarExp();
	}
	function cambiarCopia() {
		return this.ctx.oficial_cambiarCopia();
	}
	function cambiarDirLocal() {
		return this.ctx.oficial_cambiarDirLocal();
	}
	function cambiarCodificacion(valor:String) {
		return this.ctx.oficial_cambiarCodificacion(valor);
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

////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

/** @class_definition interna */
//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////

function interna_main()
{
	var f:Object = new FLFormSearchDB("gd_config");
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
		f.exec("urlrepositorio");
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
	var util:FLUtil = new FLUtil();
	this.child("lblExp").text = util.readSettingEntry("scripts/flcolagedo/explorador");
	this.child("lblDirLocal").text = util.readSettingEntry("scripts/flcolagedo/dirLocal");
	this.child("lblCopia").text = util.readSettingEntry("scripts/flcolagedo/comandocp");
	this.child("lineEditCodificacion").text = util.readSettingEntry("scripts/flfacturac/encodingLocal");

	connect( this.child( "pbnCambiarExp" ), "clicked()", this, "iface.cambiarExp" );
	connect( this.child( "pbnCambiarCopia" ), "clicked()", this, "iface.cambiarCopia" );
	connect( this.child( "pbnCambiarDirLocal" ), "clicked()", this, "iface.cambiarDirLocal" );
// 	connect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged()");
	connect(this.child("lineEditCodificacion"), "textChanged(QString)", this, "iface.cambiarCodificacion()");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \C
Cambia el nombre o la ruta de acceso al explorador de archivos
\end */
function oficial_cambiarExp()
{
	var util:FLUtil = new FLUtil();
	var explorador:String = Input.getText( "Nombre del explorador de archivos o ruta de acceso" );
	
	this.child("lblExp").text = explorador;
	util.writeSettingEntry("scripts/flcolagedo/explorador", explorador);
}

/** \C
Cambia el nombre del comando usado para copiar archivos
\end */
function oficial_cambiarCopia()
{
	var util:FLUtil = new FLUtil();
	var comandoCP:String = Input.getText( "Nombre del comando para realizar la copia de archivos" );
	
	this.child("lblCopia").text = comandoCP;
	util.writeSettingEntry("scripts/flcolagedo/comandocp", comandoCP);
}

/** \C
Cambia el directorio local de documentación para el usuario
\end */
function oficial_cambiarDirLocal()
{
	var util:FLUtil = new FLUtil();
	var ruta:String = FileDialog.getExistingDirectory( util.translate( "scripts", "" ), util.translate( "scripts", "RUTA AL DIRECTORIO LOCAL DE DOCUMENTOS" ) );
	
	if ( !File.isDir( ruta ) ) {
		MessageBox.information(util.translate( "scripts", "Ruta errónea" ), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	this.child("lblDirLocal").text = ruta;
	util.writeSettingEntry("scripts/flcolagedo/dirLocal", ruta);
}

function oficial_cambiarCodificacion(valor:String)
{
	var util:FLUtil;
	util.writeSettingEntry("scripts/flfacturac/encodingLocal", valor);
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////



//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////