/***************************************************************************
                 mv_funcional.qs  -  description
                             -------------------
    begin                : lun mar 28 2005
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
	function validateForm():Boolean { return this.ctx.interna_validateForm(); }
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
	function descargarDoc() {
		return this.ctx.oficial_descargarDoc();
	}
	function rutaDoc():String {
		return this.ctx.oficial_rutaDoc();
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
	var cursor:FLSqlCursor = this.cursor();
	
	var campos:Array = ["codfuncional","version","fecha","cambios","publico","idmodulo"]
	this.child("tdbChangeLog").setOrderCols(campos);

	connect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged");
	
	// Gestión documental
	if (sys.isLoadedModule("flcolagedo")) {
		var datosGD:Array;
		datosGD["txtRaiz"] = cursor.valueBuffer("codfuncional") + ": " + cursor.valueBuffer("desccorta");
		datosGD["tipoRaiz"] = "mv_funcional";
		datosGD["idRaiz"] = cursor.valueBuffer("codfuncional");
		flcolagedo.iface.pub_gestionDocumentalOn(this, datosGD);
		
		this.child("txtRuta").text = this.iface.rutaDoc();
		this.child("txtRuta").setDisabled(true);
		connect(this.child("pbnDescargar"), "clicked()", this, "iface.descargarDoc()");
		
	} else {
		this.child("tbwFuncional").setTabEnabled("gesdocu", false);
	}
}

/** \C La --version-- siempre debe tener por prefijo --versionmodulos--
\end */
function interna_validateForm():Boolean
{
	var util:FLUtil = new FLUtil();

	var version:String = this.child("fdbVersion").value();
	var versionModulos:String = this.child("fdbVersionModulos").value();
	
	if (version.find(versionModulos) != 0) {
		MessageBox.critical
			(util.translate("scripts", "La versión de la extensión debe tener como prefijo\nla versión mínima de los módulos"),
			 MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	return true;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_bufferChanged(fN:String)
{
/** \C Al cambiar la --versionmodulos-- la --version-- será igual
\end */
	switch (fN) {
	case "versionmodulos":
		this.child("fdbVersion").setValue(this.child("fdbVersionModulos").value());
		break;
	}
}

function oficial_descargarDoc()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var codigo = cursor.valueBuffer("codFuncional");
	
	var pathFichero:String = this.child("txtRuta").text;
	if (!File.exists(pathFichero)) {
		MessageBox.critical
			(util.translate("scripts", "No existe la ruta a los documentos. Debes establecerla\nen el módulo de gestión documental"),
			 MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}	
	
	var dir = new Dir(pathFichero);
	if (!dir.fileExists("doc"))
		dir.mkdir("doc");
	
	if (!dir.fileExists("cap"))
		dir.mkdir("cap");
	
	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList("gd_documentos");
	q.setFrom("gd_documentos")
	q.setSelect("codigo");
	
	q.setWhere("codigo like 'doc_" + codigo +"%'");
	if (!q.exec())
		return;
	
	var paso:Number = 0;
	util.createProgressDialog( util.translate( "scripts", "Descargando documentos..." ), q.size() );
	
	while(q.next()) {
		util.setProgress(paso++);
		if (!flcolagedo.iface.pub_obtenerDocumento(q.value(0), pathFichero + "/doc/" + q.value(0) + ".odt"))
			continue;
	}

	util.destroyProgressDialog();
	
	
	q.setWhere("codigo like 'cap_" + codigo +"%'");
	if (!q.exec())
		return;
	
	util.createProgressDialog( util.translate( "scripts", "Descargando capturas..." ), q.size() );
	
	while(q.next()) {
		util.setProgress(paso++);
		if (!flcolagedo.iface.pub_obtenerDocumento(q.value(0), pathFichero + "/cap/" + q.value(0) + ".png"))
			continue;
	}
	
	util.destroyProgressDialog();

	MessageBox.information
		(util.translate("scripts", "Se descargaron los documentos"),
			MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
}

function oficial_rutaDoc():String
{
	var util:FLUtil = new FLUtil;
	return util.readSettingEntry("scripts/flcolagedo/dirLocal");
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////