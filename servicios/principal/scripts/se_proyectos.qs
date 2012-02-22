/***************************************************************************
                 se_proyectos.qs  -  description
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
	var rutaMantVer:String;
    function oficial( context ) { interna( context ); } 
	function tbnCambiarSubproyecto_clicked() {
		return this.ctx.oficial_tbnCambiarSubproyecto_clicked();
	}
	function actualizarLista() {
		return this.ctx.oficial_actualizarLista();
	}
	function establecerDirectorio() {
		return this.ctx.oficial_establecerDirectorio();
	}
	function filtrarIncidencias() {
		return this.ctx.oficial_filtrarIncidencias();
	}
	function responderMail() {
		return this.ctx.oficial_responderMail();
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
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	this.iface.rutaMantVer = util.readSettingEntry("scripts/flservppal/dirMantVer");
	this.child("lblDirMantver").text = this.iface.rutaMantVer;
	this.child("chkPendientes").checked = true;
	
	// Gestión documental
	if (sys.isLoadedModule("flcolagedo")) {
		var datosGD:Array;
		datosGD["txtRaiz"] = cursor.valueBuffer("codigo") + ": " + cursor.valueBuffer("descripcion");
		datosGD["tipoRaiz"] = "se_proyectos";
		datosGD["idRaiz"] = cursor.valueBuffer("codigo");
		flcolagedo.iface.pub_gestionDocumentalOn(this, datosGD);
	} else {
		this.child("tbwSubproyectos").setTabEnabled("tabDocumentacion", false);
	}

	connect (this.child("tbnCambiarSubproyecto"), "clicked()", this, "iface.tbnCambiarSubproyecto_clicked");
	connect(this.child("pbnActualizarLista"), "clicked()", this, "iface.actualizarLista");
	connect(this.child( "pbExaminar" ), "clicked()", this, "iface.establecerDirectorio" );
	connect(this.child("chkPendientes"), "clicked()", this, "iface.filtrarIncidencias");
	connect(this.child("pbnResponder"), "clicked()", this, "iface.responderMail" );

	this.iface.filtrarIncidencias();
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_tbnCambiarSubproyecto_clicked()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var curSubproyecto:FLSqlCursor = this.child("tdbSubproyectos").cursor();
	if (!curSubproyecto) {
		return false;
	}
	var codSubproyecto:String = curSubproyecto.valueBuffer("codigo")
	var res:Number = MessageBox.warning(util.translate("scripts", "¿Desea cambiar el subproyecto %1 a un nuevo proyecto para este cliente?").arg(codSubproyecto), MessageBox.Yes, MessageBox.No);
	if (res != MessageBox.Yes) {
		return false;
	}

	var rama:String;
	var estado:String;
	var curProyecto:FLSqlCursor = new FLSqlCursor("se_proyectos");
	curProyecto.setModeAccess(curProyecto.Insert);
	curProyecto.refreshBuffer();
	var codNuevo:String = util.nextCounter("codigo", curProyecto);
	curProyecto.setValueBuffer("codigo", codNuevo);
	curProyecto.setValueBuffer("descripcion", curSubproyecto.valueBuffer("descripcion"));
	if (estado == "Pendente") {
		estado = "Especificaciones";
	}
	curProyecto.setValueBuffer("estado", curSubproyecto.valueBuffer("estado"));
	rama = curSubproyecto.valueBuffer("dirlocal");
	if (rama && rama != "" && rama.toString().endsWith("/")) {
		rama = rama.left(rama.length - 1);
	}
	curProyecto.setValueBuffer("codfuncional", rama);
	curProyecto.setValueBuffer("codcliente", cursor.valueBuffer("codcliente"));
	if (!curProyecto.commitBuffer()) {
		return false;
	}
	if (!util.sqlUpdate("se_subproyectos", "codproyecto", codNuevo, "codigo = '" + codSubproyecto + "'")) {
		return false;
	}
	MessageBox.information(util.translate("scripts", "Se ha creado el proyecto %1 y se le ha asociado el subproyecto %2").arg(codNuevo).arg(codSubproyecto), MessageBox.Ok, MessageBox.NoButton);
}

/** \D Actualiza la lista de módulos que hay en disco y los introduce en la tabla de datos. 
Hace una pasada por los directorios desde el directorio de los módulos
\end */
function oficial_actualizarLista()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	if (cursor.modeAccess() == cursor.Insert) {
		if (this.child("tdbModulos").cursor().commitBufferCursorRelation()) {
			return false;
		}
	}
	
	var rutaModulos:String = this.iface.rutaMantVer + cursor.valueBuffer("codfuncional") + "/modulos/";
	if (!File.exists(rutaModulos)) {
		rutaModulos = this.iface.rutaMantVer + cursor.valueBuffer("codfuncional") + "/prueba/";
	}
	
	var codProyecto:String = cursor.valueBuffer("codigo");
	
	var res = MessageBox.warning( util.translate( "scripts", "La lista de módulos será eliminada antes de regenerarse.\n\n¿Continuar?" ), MessageBox.No, MessageBox.Yes);
	if ( res != MessageBox.Yes ) {
		return;
	}
	
	if (!File.isDir(rutaModulos)) {
		MessageBox.critical(util.translate("scripts", "No existe el directorio de módulos"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	
	/// borrar la tabla
	var curModulosSP:FLSqlCursor = new FLSqlCursor("se_modulos");
	curModulosSP.select("codproyecto = '" + codProyecto + "'");
	while (curModulosSP.next()) {
		curModulosSP.setModeAccess(curModulosSP.Del);
		curModulosSP.refreshBuffer();
		if (!curModulosSP.commitBuffer()) {
			return false;
		}
	}

	var dirAreas = new Dir(rutaModulos);
	var areas = dirAreas.entryList("*", Dir.Dirs);
	var modulos;
	var nomFicheroMod:String;

	for (var i = 0; i < areas.length; i++) {
		if (areas[i] == "." || areas[i] == "..") {
			continue;
		}
		
		var rutaArea:String = rutaModulos + areas[i];
		var dirArea = new Dir(rutaArea);
		
		modulos = dirArea.entryList("*", Dir.Dirs);
		for (var j = 0; j < modulos.length; j++) {
			if (modulos[j] == "." || modulos[j] == ".." || modulos[j].right(4) == ".xml") {
				continue;
			}
			
			try {
				dirArea.cd(modulos[j]);
			} catch (e) {
				MessageBox.critical(this.iface.util.translate("scripts", "Se produjo un error al acceder al directorio %1").arg(rutaArea + modulos[j]), MessageBox.Ok, MessageBox.NoButton);
			}
			
			nomFicheroMod = dirArea.entryList("*.mod", Dir.Files);
			if (nomFicheroMod.length != 1) {
				dirArea.cdUp();
				continue;
			}
			curModulosSP.setModeAccess(curModulosSP.Insert);
			curModulosSP.refreshBuffer();
			curModulosSP.setValueBuffer("codproyecto", codProyecto);
			curModulosSP.setValueBuffer("idmodulo", modulos[j]);
			curModulosSP.setValueBuffer("idarea", areas[i]);
			if (!curModulosSP.commitBuffer()) {
				return false;
			}
			dirArea.cdUp();
		}
  	}
	this.child("tdbModulos").refresh();
}

/** \C Establece el directorio de trabajo de los módulos del cliente, de donde se
obtendrán los paquetes para enviar al mismo
\end */
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

/** \D Filtra las tabla de incidencias por incidencias pendientes de ese subproyecto si está activa la opcion de SóloPendientes, si no lo está la filta mostrando todas las incidencias del subproyecto y refresca la tabla
\end */
function oficial_filtrarIncidencias()
{ 
	var cursor:FLSqlCursor = this.cursor();

	var filtro:String = "";
	if (this.child("chkPendientes").checked) {
		filtro = "estado = 'Pendiente' AND codproyecto = '" + cursor.valueBuffer("codigo") + "'";
	} else {
		filtro = "";
	}
	this.child("tdbIncidencias").cursor().setMainFilter(filtro);
	this.child("tdbIncidencias").refresh();
}

/** \D Lanza la respuesta a una comunicación seleccionada en el formulario maestro.
El id de dicha comunicacion queda registrado en la variable codigoConResp, y a continuación
se abre el formulario de inserción de una nueva comunicación.
\end */
function oficial_responderMail()
{
	var util:FLUtil = new FLUtil();
	var curCom:FLSqlCursor = this.child("tdbComunicaciones").cursor();	

 	util.writeSettingEntry("scripts/flservppal/codigoComResp", curCom.valueBuffer("codigo"));
	
	this.child("toolButtomInsertCom").animateClick();
}	

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
