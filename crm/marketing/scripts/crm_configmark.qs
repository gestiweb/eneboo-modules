/***************************************************************************
                 crm_configmark.qs  -  description
                             -------------------
    begin                : vie jul 24 2009
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
	function cambiarCodificacion(valor:String) {
		return this.ctx.oficial_cambiarCodificacion(valor);
	}
	function pbnCambiarPieCorreo_clicked() {
		return this.ctx.oficial_pbnCambiarPieCorreo_clicked();
	}
	function pbnBorrarPieCorreo_clicked() {
		return this.ctx.oficial_pbnBorrarPieCorreo_clicked();
	}
	function pbnCambiarLogoCorreo_clicked() {
		return this.ctx.oficial_pbnCambiarLogoCorreo_clicked();
	}
	function pbnBorrarLogoCorreo_clicked() {
		return this.ctx.oficial_pbnBorrarLogoCorreo_clicked();
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
	var f:Object = new FLFormSearchDB("crm_configmark");
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
debug("init");
	var util:FLUtil = new FLUtil();
	this.child("lineEditCodificacion").text = util.readSettingEntry("scripts/flfacturac/encodingLocal");

	connect(this.child("lineEditCodificacion"), "textChanged(QString)", this, "iface.cambiarCodificacion()");
	this.child("lblFicheroPieCorreo").text = util.readSettingEntry("email/footerText");
	this.child("lblFicheroLogoCorreo").text = util.readSettingEntry("email/mailLogo");
	
	connect( this.child( "pbnCambiarPieCorreo" ), "clicked()", this, "iface.pbnCambiarPieCorreo_clicked" );
	connect( this.child( "pbnBorrarPieCorreo" ), "clicked()", this, "iface.pbnBorrarPieCorreo_clicked" );
	connect( this.child( "pbnCambiarLogoCorreo" ), "clicked()", this, "iface.pbnCambiarLogoCorreo_clicked" );
	connect( this.child( "pbnBorrarLogoCorreo" ), "clicked()", this, "iface.pbnBorrarLogoCorreo_clicked" );
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \C
\end */
function oficial_pbnCambiarPieCorreo_clicked()
{
	var util:FLUtil = new FLUtil();
	var fichero:String = FileDialog.getOpenFileName( util.translate( "scripts", "" ), util.translate( "scripts", "Seleccione fichero de texto"));
	
	if ( !File.exists( fichero ) ) {
		MessageBox.information(util.translate( "scripts", "Ruta errónea" ), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	this.child("lblFicheroPieCorreo").text = fichero;
	util.writeSettingEntry("email/footerText", fichero);
}

function oficial_pbnBorrarPieCorreo_clicked()
{
	var util:FLUtil = new FLUtil();
	this.child("lblFicheroPieCorreo").text = "";
	util.writeSettingEntry("email/footerText", "");
}

/** \C
\end */
function oficial_pbnCambiarLogoCorreo_clicked()
{
	var util:FLUtil = new FLUtil();
	var fichero:String = FileDialog.getOpenFileName( util.translate( "scripts", "" ), util.translate( "scripts", "Seleccione fichero de logo"));
	
	if ( !File.exists( fichero ) ) {
		MessageBox.information(util.translate( "scripts", "Ruta errónea" ), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	this.child("lblFicheroLogoCorreo").text = fichero;
	util.writeSettingEntry("email/mailLogo", fichero);
}

function oficial_pbnBorrarLogoCorreo_clicked()
{
	var util:FLUtil = new FLUtil();
	this.child("lblFicheroLogoCorreo").text = "";
	util.writeSettingEntry("email/mailLogo", "");
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