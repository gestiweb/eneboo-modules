/***************************************************************************
                             flimpdatos.qs
                            -------------------
   begin                : lun dic 13 2004
   copyright            : (C) 2004-2005 by InfoSiAL S.L.
   email                : mail@infosial.com
   copyright            : (C) 2011 by Silix
   email                : contacto@silix.com.ar
***************************************************************************/
/***************************************************************************
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; version 2 of the License.               *
 ***************************************************************************/ 
/***************************************************************************
   Este  programa es software libre. Puede redistribuirlo y/o modificarlo
   bajo  los  términos  de  la  Licencia  Pública General de GNU   en  su
   versión 2, publicada  por  la  Free  Software Foundation.
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var sep:String = ";";
	var registrosEliminados:Number;
	var myUtil:FLUtil = new FLUtil();

    function oficial( context ) { interna( context ); }
	function ejecutarQry(tabla, campos, where, listaTablas):Array {
		return this.ctx.oficial_ejecutarQry( tabla, campos, where, listaTablas );
	}
	function datoCampo(tipo, datoValor, datoFichero, linea):String {
		return this.ctx.oficial_datoCampo( tipo, datoValor, datoFichero, linea );
	}
	function vaciarTabla(tabla, progress, checkI, forzarDelLocks) {
		return this.ctx.oficial_vaciarTabla(tabla, progress, checkI, forzarDelLocks);
	}
	function comprobarLocks(tabla, forzarDelLocks) {
		return this.ctx.oficial_comprobarLocks(tabla, forzarDelLocks);
	}
	function numLineas(file) {
		return this.ctx.oficial_numLineas(file);
	}
	function crearProgress(label, numPasos) {
		return this.ctx.oficial_crearProgress(label, numPasos);
	}
	function setProgress(valor) {
		return this.ctx.oficial_setProgress(valor);
	}
	function destroyProgress() {
		return this.ctx.oficial_destroyProgress();
	}
	function obtenerEsquema(tabla:String) {
		return this.ctx.importaciones_obtenerEsquema(tabla);
	}
	function elegirOpcion(opciones:Array):Number {
		return this.ctx.importaciones_elegirOpcion(opciones);
	}
	function lanzarImportacion(esquema:String):Number {
		return this.ctx.importaciones_lanzarImportacion(esquema);
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
	function pub_ejecutarQry(tabla, campos, where, listaTablas):Array {
		return this.ejecutarQry( tabla, campos, where, listaTablas );
	}
	function pub_datoCampo(tipo, datoValor, datoFichero, linea ):String {
		return this.datoCampo( tipo, datoValor, datoFichero, linea );
	}
	function pub_vaciarTabla(tabla, progress, checkI, forzarDelLocks) {
		return this.vaciarTabla(tabla, progress, checkI, forzarDelLocks);
	}
	function pub_numLineas(file) {
		return this.numLineas(file);
	}
	function pub_crearProgress(label, numPasos) {
		return this.crearProgress(label, numPasos);
	}
	function pub_setProgress(valor) {
		return this.setProgress(valor);
	}
	function pub_destroyProgress() {
		return this.destroyProgress();
	}
	function pub_obtenerEsquema(tabla:String) {
		return this.obtenerEsquema(tabla);
	}
	function pub_lanzarImportacion(esquema:String) {
		return this.lanzarImportacion(esquema);
	}
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

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

// Ejecuta la query especificada y devuelve un array con los
// datos de los campos seleccionados
// Devuelve un campo extra 'result' que es 1 = Ok, 0 = Error, -1 No encontrado
function oficial_ejecutarQry( tabla, campos, where, listaTablas ):Array
{
	var campo:Array = campos.split( "," );
	var valor:Array = [];
	valor[ "result" ] = 1;
	var query:FLSqlQuery = new FLSqlQuery();
	if ( listaTablas )
		query.setTablesList( listaTablas );
	else
		query.setTablesList( tabla );
	query.setSelect( campo );
	query.setFrom( tabla );
	query.setWhere( where + ";" );
	if ( query.exec() ) {
		if ( query.next() ) {
			for ( var i = 0; i < campo.length; i++ ) {
				valor[ campo[ i ] ] = query.value( i );
			}
		} else {
			valor.result = -1;
		}
	} else {
		MessageBox.critical(this.iface.myUtil.translate( "scripts", "Falló la consulta" ) + query.sql(), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton );
		valor.result = 0;
	}

	return valor;
}

function oficial_datoCampo( tipo, datoValor, datoFichero, linea ):String
{
	var valor:String;

	var argumentos:String = "";
	for ( i = 0; i < linea.length - 1; i++ ) {
		argumentos = argumentos + linea[ i ] + this.iface.sep;
	}
	argumentos = argumentos + linea[ i ];
	
	switch ( tipo ) {
		case "valor":
			valor = datoValor;
			break;

		case "funcion":
			var codigoFuncion:String = this.iface.ejecutarQry( "impdat_funciones", "codigo", "id = '" + datoValor + "'", "impdat_funciones" );
			codigoFuncion = codigoFuncion[ "codigo" ];
			var funcion = new Function( codigoFuncion );
			valor = funcion( argumentos );
			break;

		default:
			valor = datoFichero;
	}

	return valor;
}


function oficial_vaciarTabla(tabla, progress, checkI, forzarDelLocks)
{
	this.iface.comprobarLocks(tabla, forzarDelLocks);
	
	var curTabla:FLSqlCursor = new FLSqlCursor(tabla);
	var seguir:Boolean = false;

	curTabla.select();
 	curTabla.setActivatedCheckIntegrity(checkI);
	
	this.iface.myUtil.setLabelText(this.iface.myUtil.translate( "scripts", "Vaciando tabla ") + tabla.toUpperCase() + this.iface.myUtil.translate( "scripts", "\n\nProgreso total:"));
	
	while ( curTabla.next() ) {
	
		curTabla.setModeAccess( curTabla.Del );		
		curTabla.refreshBuffer();
		if (!curTabla.commitBuffer() && !seguir)  {
			var res = MessageBox.critical( this.iface.myUtil.translate( "scripts", "Hubo un problema al eliminar los registros de la tabla ") + tabla.toUpperCase() + this.iface.myUtil.translate( "scripts", "\n¿Continuar la eliminación de datos de esta tabla?\n\nEste mensaje no se repetirá para esta tabla. Pulse cancelar para detener todo el proceso" ), MessageBox.No, MessageBox.Yes, MessageBox.Cancel );
			
			if ( res == MessageBox.Cancel )
				return "cancel";
			if ( res != MessageBox.Yes )
				return false;
			else
				seguir = true;
		}
		this.iface.myUtil.setProgress( this.iface.registrosEliminados++ );
	}
	
	curTabla.setActivatedCheckIntegrity(true);
}

function oficial_comprobarLocks(tabla, forzarDelLocks)
{
	var contenido:String = this.iface.myUtil.sqlSelect( "flfiles", "contenido", "nombre = '" + tabla + ".mtd'" );
	var campoUnLock:String = "";
	var campoPK:String = "";
	
	xmlTabla = new FLDomDocument();
	xmlTabla.setContent(contenido);
	
	var listaCampos:Array = xmlTabla.elementsByTagName("field");
	for (var i = 0; i < listaCampos.length(); i++) {
	
		nodoCampo = listaCampos.item(i);

		if (nodoCampo.namedItem("type")) 
			if (nodoCampo.namedItem("type").toElement().text() == "unlock") 
				campoUnLock = nodoCampo.namedItem("name").toElement().text();	
				
		if (nodoCampo.namedItem("pk")) 
			if (nodoCampo.namedItem("pk").toElement().text() == "true") 
				campoPK = nodoCampo.namedItem("name").toElement().text();	
	}
	
	if (campoUnLock != "") {
	
		if (!forzarDelLocks) {
			var res = MessageBox.critical( this.iface.myUtil.translate( "scripts", "La tabla " ) + tabla.toUpperCase() + this.iface.myUtil.translate( "scripts", " puede contener algunos registros bloqueados.\n¿Desea forzar la eliminación de todos los registros?" ), MessageBox.No, MessageBox.Yes, MessageBox.NoButton );
			if ( res != MessageBox.Yes )
				return;
		}
		
		var curTabla:FLSqlCursor = new FLSqlCursor(tabla);
		var curTablaUnLock:FLSqlCursor;
		
		curTabla.select(campoUnLock + " = false");
		while ( curTabla.next() ) {
			
			curTabla.setModeAccess( curTabla.Browse );
			curTabla.refreshBuffer();
			
			curTablaUnLock = new FLSqlCursor(tabla);
			curTablaUnLock.select(campoPK + " = '" + curTabla.valueBuffer(campoPK) + "'");
			
			curTablaUnLock.first();
			curTablaUnLock.setModeAccess( curTabla.Edit );
			curTablaUnLock.refreshBuffer();
 			curTablaUnLock.setUnLock(campoUnLock, true);
			
		}
	}
}


function oficial_numLineas(file)
{
	try {
		file.open( File.ReadOnly );
	}
	catch (e) {
		debug(e);
		var res = MessageBox.warning( this.iface.myUtil.translate( "scripts", "Imposible leer los datos del fichero ") + file.name + this.iface.myUtil.translate( "scripts", "\n\nSi la tabla correspondiente a este fichero debe ser importada, compruebe\nque la ruta es válida y que los permisos de lectura son correctos\n\n¿Continuar la importación?"), MessageBox.No, MessageBox.Yes, MessageBox.NoButton );
		if ( res != MessageBox.Yes )
			return "error";
		else
			return 0;
	}
	
	var lineas:Number = 0;
	while ( !file.eof ) {
		file.readLine();
		lineas++;
	}
	
	file.close();
	
	return lineas - 1;
}

// Pone el contador de líneas importadas a cero y crea el progressDialog
function oficial_crearProgress(label, numPasos)
{
	this.iface.myUtil.createProgressDialog( label, numPasos );
	this.iface.registrosEliminados = 0;
}

function oficial_setProgress(valor)
{
	this.iface.myUtil.setProgress( valor );
}

function oficial_destroyProgress()
{
	this.iface.myUtil.destroyProgressDialog();
}

function importaciones_obtenerEsquema(tabla:String)
{
	var util:FLUtil = new FLUtil;
	var valor:String;

	var qryEsquemas:FLSqlQuery = new FLSqlQuery;
	with (qryEsquemas) {
		setTablesList("impdat_esquemas");
		setSelect("codesquema");
		setFrom("impdat_esquemas");
		setWhere("codtabla = '"+tabla+"'");
		setForwardOnly(true);
	}
	if (!qryEsquemas.exec())
		return false;
	if (qryEsquemas.size() < 1) {
		MessageBox.warning(util.translate("scripts", "No tiene definido ningún esquema de importación para esta tabla."), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var arrayEsquemas:Array = [];
	while (qryEsquemas.next()) {
		arrayEsquemas[arrayEsquemas.length] = qryEsquemas.value("codesquema");
	}

	var esquemaElegido:Number = this.iface.elegirOpcion(arrayEsquemas);
	if (esquemaElegido < 0)
		return false;

	valor = arrayEsquemas[esquemaElegido];

	return valor;
}

function importaciones_elegirOpcion(opciones:Array):Number
{
	var util:FLUtil = new FLUtil();
	var dialog:Dialog = new Dialog;
	dialog.okButtonText = util.translate("scripts","Aceptar");
	dialog.cancelButtonText = util.translate("scripts","Cancelar");
	var bgroup:GroupBox = new GroupBox;
	dialog.add(bgroup);
	var rB:Array = [];
	for (var i:Number = 0; i < opciones.length; i++) {
		rB[i] = new RadioButton;
		bgroup.add(rB[i]);
		rB[i].text = opciones[i];
		if (i == 0)
			rB[i].checked = true;
		else
			rB[i].checked = false;
	}

	if(dialog.exec()) {
		for (var i:Number = 0; i < opciones.length; i++)
			if (rB[i].checked == true)
				return i;
	} else
		return -1;
}

function importaciones_lanzarImportacion(esquema:String):Number
{
	var hoy:Date = new Date();
	var nombreProceso:String = esquema + "_" + hoy.toString();

	var f:Object = new FLFormSearchDB("impdat_importaciones");
	var proceso:FLSqlCursor = f.cursor();

	proceso.setModeAccess(proceso.Insert);
	proceso.refreshBuffer();
	proceso.setValueBuffer("codproceso", nombreProceso);
	proceso.setValueBuffer("codesquema",esquema);
	
	f.setMainWidget();
	f.child("fdbCodProceso").setDisabled(true);
	f.child("fdbCodEsquema").setDisabled(true);

	var acpt:String = f.exec("codproceso");
	if (acpt)
		if (!proceso.commitBuffer())
			return false;

	return acpt;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////