/***************************************************************************
                 se_contratosman.qs  -  description
                             -------------------
    begin                : lun jun 20 2005
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
    function init() { this.ctx.interna_init(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var tdbIncidencias:FLTableDB;
	var cliente:String;
	var rutaMantVer:String;
    function oficial( context ) { interna( context ); } 
	function establecerDirectorio() { return this.ctx.oficial_establecerDirectorio() ; }
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends oficial {
    function head( context ) { oficial ( context ); }
	function bufferChanged(fN:String) {	return this.ctx.oficial_bufferChanged(fN); }
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

/** \C El --dirlocal-- permanece inhabilitado
*/
function interna_init()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	
	this.child("fdbDirLocal").setDisabled(true);
	
	connect( this.child( "pbExaminar" ), "clicked()", this, "iface.establecerDirectorio" );
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
		
	if (cursor.modeAccess() == cursor.Insert) {
		cursor.setValueBuffer("ultimopago", "NULL");
	}
	
	this.iface.rutaMantVer = util.readSettingEntry("scripts/flservppal/dirMantVer");
	this.child("lblDirMantver").text = this.iface.rutaMantVer;
	
	var datosGD:Array;
	datosGD["txtRaiz"] = cursor.valueBuffer("codigo") + ": " + cursor.valueBuffer("descripcion");
	datosGD["tipoRaiz"] = "se_contratosman";
	datosGD["idRaiz"] = cursor.valueBuffer("codigo");
	flcolagedo.iface.pub_gestionDocumentalOn(this, datosGD);
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

/** \D Abre el diálogo para obtener el directorio de trabajo del cliente
*/
function oficial_establecerDirectorio() 
{
	var util:FLUtil = new FLUtil();	
	
	this.iface.rutaMantVer = util.readSettingEntry("scripts/flservppal/dirMantVer");
	
	if (!this.iface.rutaMantVer) {
		MessageBox.critical(util.translate("scripts", "La ruta a los módulos de mantenimiento de versiones no ha sido establecida"),
		MessageBox.Ok, MessageBox.Cancel, MessageBox.NoButton);
		return false;
	}
	
 	var nuevoDir:String = FileDialog.getExistingDirectory(this.iface.rutaMantVer, util.translate("scripts", "Seleccione directorio"));

	if (nuevoDir) {
		if (!File.isDir(nuevoDir)) {
			MessageBox.critical(util.translate("scripts", "La ruta a los módulos no es correcta:\n") + this.iface.rutaMantVer + nuevoDir,
			MessageBox.Ok, MessageBox.Cancel, MessageBox.NoButton);
			return false;
		} else {
			var dirLocal = new Dir(nuevoDir);
			this.child("fdbDirLocal").setValue(dirLocal.name + "/");
		}
	}
}

function oficial_bufferChanged(fN:String)
{ 
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	

	switch (fN) {
		/** \C La --codpago-- se hereda del cliente
		\end */
		case "codcliente":{
			cursor.setValueBuffer("codpago", util.sqlSelect("clientes", "codpago", "codcliente = '" + cursor.valueBuffer("codcliente") + "'"));
			break;
		}
		/** \C El --periodopago-- se pone a Semestral si el --tipocontrato-- es Basico
		\end */
		case "tipocontrato":{
			cursor.setValueBuffer("periodopago", util.sqlSelect("se_tiposcontrato","periodopago","nombre = '" + cursor.valueBuffer("tipocontrato") + "'"));
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
