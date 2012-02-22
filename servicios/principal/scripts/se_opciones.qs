/***************************************************************************
                 do_mastergenerardoc.qs  -  description
                             -------------------
    begin                : lun sep 21 2004
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

////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
class interna {
    var ctx:Object;
    function interna( context ) { this.ctx = context; }
    function init() { this.ctx.interna_init(); }
	function main() { return this.ctx.interna_main(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    function oficial( context ) { interna( context ); } 
	function cambiarUsuario() { return this.ctx.oficial_cambiarUsuario() ;}
	function cambiarClienteCorreo() { return this.ctx.oficial_cambiarClienteCorreo() ;}
	function cambiarDirServicios() { return this.ctx.oficial_cambiarDirServicios() ;}
	function cambiarDirMantVer() { return this.ctx.oficial_cambiarDirMantVer() ;}
	function cambiarNav() { return this.ctx.oficial_cambiarNav() ;}
	function cambiarExp() { return this.ctx.oficial_cambiarExp() ;}
	function cambiarVisorPDF() { return this.ctx.oficial_cambiarVisorPDF() ;}
	function cambiarFicheroMail() { return this.ctx.oficial_cambiarFicheroMail() ;}
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends oficial {
    function head( context ) { oficial ( context ); }
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

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

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////

function init() {
    this.iface.init();
}

/** \C
El formulario muestra algunas opciones generales como el usuario, el coste por hora y algunas rutas de acceso
\end */
function interna_init() {
	
	var util:FLUtil = new FLUtil();
	
	this.child("lblCodUsuario").text = util.readSettingEntry("scripts/flservppal/codusuario");
	this.child("lblClienteCorreo").text = util.readSettingEntry("scripts/flservppal/clientecorreo");
	this.child("lblDirServicios").text = util.readSettingEntry("scripts/flservppal/dirServicios");
	this.child("lblDirMantver").text = util.readSettingEntry("scripts/flservppal/dirMantVer");
	this.child("lblNav").text = util.readSettingEntry("scripts/flservppal/navegador");
	this.child("lblExp").text = util.readSettingEntry("scripts/flservppal/explorador");
	this.child("lblVisorPDF").text = util.readSettingEntry("scripts/flservppal/visorpdf");
	this.child("lblFicheroMail").text = util.readSettingEntry("scripts/flservppal/ficheromail");
	connect( this.child( "pbnCambiarUsuario" ), "clicked()", this, "iface.cambiarUsuario" );
	connect( this.child( "pbnCambiarClienteCorreo" ), "clicked()", this, "iface.cambiarClienteCorreo" );
	connect( this.child( "pbnCambiarDirServicios" ), "clicked()", this, "iface.cambiarDirServicios" );
	connect( this.child( "pbnCambiarDirMantVer" ), "clicked()", this, "iface.cambiarDirMantVer" );
	connect( this.child( "pbnCambiarNav" ), "clicked()", this, "iface.cambiarNav" );
	connect( this.child( "pbnCambiarExp" ), "clicked()", this, "iface.cambiarExp" );
	connect( this.child( "pbnCambiarVisorPDF" ), "clicked()", this, "iface.cambiarVisorPDF" );
	connect( this.child( "pbnCambiarFicheroMail" ), "clicked()", this, "iface.cambiarFicheroMail" );
}

function interna_main()
{
	var f:Object = new FLFormSearchDB("se_opciones");
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
		f.exec("urlrepositoriodoc");
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

//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

/** \C
Cambia el usuario
\end */
function oficial_cambiarUsuario()
{
	var util:FLUtil = new FLUtil();
	var codUsuario:String = Input.getText( util.translate( "scripts", "Código de Usuario:" ) );
	var nomUsuario:String = util.sqlSelect("se_usuarios","nombre","codigo = '" + codUsuario + "'");
		
	if (!nomUsuario) {
		MessageBox.information( util.translate( "scripts", "El usuario no existe" ),
								MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton );
		return;
	}
	
	this.child("lblCodUsuario").text = codUsuario;
	util.writeSettingEntry("scripts/flservppal/codusuario", codUsuario);
}

/** \C
Cambia el cliente de correo
\end */
function oficial_cambiarClienteCorreo()
{
	var util:FLUtil = new FLUtil();
	var codClienteCorreo:String = Input.getText( util.translate( "scripts", "Cliente de correo:" ) );
		
	if (!codClienteCorreo)
		return;
	
	this.child("lblClienteCorreo").text = codClienteCorreo;
	util.writeSettingEntry("scripts/flservppal/clientecorreo", codClienteCorreo);
}

/** \C
Cambia el directorio en el que se encuentra el módulo de servicios
\end */
function oficial_cambiarDirServicios()
{
	var util:FLUtil = new FLUtil();
	var ruta:String = FileDialog.getExistingDirectory( util.translate( "scripts", "" ), util.translate( "scripts", "RUTA AL MÓDULO DE SERVICIOS" ) );
	
	if ( !File.isDir( ruta ) ) {
		MessageBox.information( util.translate( "scripts", "Ruta errónea" ),
								MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton );
		return;
	}
	this.child("lblDirServicios").text = ruta;
	util.writeSettingEntry("scripts/flservppal/dirServicios", ruta);
}

/** \C
Cambia la ruta local que utiliza el módulo de mantenimiento de versiones
\end */
function oficial_cambiarDirMantVer()
{
	var util:FLUtil = new FLUtil();
	var ruta:String = FileDialog.getExistingDirectory( util.translate( "scripts", "" ), util.translate( "scripts", "RUTA DE MANTENIMIENTO DE VERSIONES" ) );
	
	if ( !File.isDir( ruta ) ) {
		MessageBox.information( util.translate( "scripts", "Ruta errónea" ),
								MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton );
		return;
	}
	this.child("lblDirMantver").text = ruta;
	util.writeSettingEntry("scripts/flservppal/dirMantVer", ruta);
}

/** \C
Cambia el nombre o la ruta de acceso al navegador
\end */
function oficial_cambiarNav()
{
	var util:FLUtil = new FLUtil();
	var navegador:String = Input.getText( "Nombre del navegador o ruta de acceso" );
	
	this.child("lblNav").text = navegador;
	util.writeSettingEntry("scripts/flservppal/navegador", navegador);
}

/** \C
Cambia el nombre o la ruta de acceso al explorador de archivos
\end */
function oficial_cambiarExp()
{
	var util:FLUtil = new FLUtil();
	var explorador:String = Input.getText( "Nombre del explorador de archivos o ruta de acceso" );
	
	this.child("lblExp").text = explorador;
	util.writeSettingEntry("scripts/flservppal/explorador", explorador);
}

/** \C
Cambia el nombre o la ruta de acceso al visor de documentos PDF
\end */
function oficial_cambiarVisorPDF()
{
	var util:FLUtil = new FLUtil();
	var visorPDF:String = Input.getText( "Nombre del visor de PDFs o ruta de acceso" );
	
	this.child("lblVisorPDF").text = visorPDF;
	util.writeSettingEntry("scripts/flservppal/visorpdf", visorPDF);
}

/** \C
Cambia el nombre o la ruta de acceso al visor de documentos PDF
\end */
function oficial_cambiarFicheroMail()
{
	var util:FLUtil = new FLUtil();
	var fichero:String = FileDialog.getOpenFileName( util.translate( "scripts", "" ), util.translate( "scripts", "Fichero temporal para cagar emails" ) );
	
	if ( !File.isFile( fichero ) ) {
		MessageBox.information( util.translate( "scripts", "Ruta errónea" ), MessageBox.Ok, MessageBox.NoButton );
		return;
	}
	this.child("lblFicheroMail").text = fichero;
	util.writeSettingEntry("scripts/flservppal/ficheromail", fichero);
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////

//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
