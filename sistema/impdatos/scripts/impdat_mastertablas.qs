/***************************************************************************
                            impdat_mastertablas.qs
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
    function init() { this.ctx.interna_init(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var mensajes:FLUtil;

    function oficial( context ) { interna( context ); }
	function recargarTablas() {
		return this.ctx.oficial_recargarTablas();
	}
	function vaciarTabla(tabla:String) {
		return this.ctx.oficial_vaciarTabla(tabla);
	}
	function listaDeTablas():Array {
		return this.ctx.oficial_listaDeTablas();
	}
	function cargarListaTablas() {
		return this.ctx.oficial_cargarListaTablas();
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

function interna_init()
{
	this.iface.mensajes = new FLUtil();

	this.child("tableDBRecords").setEditOnly(true);

	connect(this.child("pbnRecargar"), "clicked()", this, "iface.recargarTablas()");

	var util:FLUtil = new FLUtil();
	if (!util.sqlSelect("impdat_tablas", "codtabla", "1=1"))
		this.iface.recargarTablas();
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_recargarTablas()
{
	// Inicia la barra de progreso
	this.iface.mensajes.createProgressDialog( this.iface.mensajes.translate( "scripts", "Recargando..." ), 1 );

	this.iface.vaciarTabla("impdat_tablas");

	this.iface.cargarListaTablas();

	// Termina la barra de progreso
	this.iface.mensajes.destroyProgressDialog();
}

function oficial_vaciarTabla(tabla:String)
{
	var curTabla:FLSqlCursor = new FLSqlCursor( tabla );
	curTabla.setActivatedCheckIntegrity( false );
	curTabla.select();

	// Actualiza la barra de progreso
	this.iface.mensajes.setLabelText(this.iface.mensajes.translate( "scripts", "Vaciando lista..." ));
	this.iface.mensajes.setTotalSteps(curTabla.size());
	this.iface.mensajes.setProgress(0);
	var paso:Number = 0;

	while ( curTabla.next() ) {
		this.iface.mensajes.setProgress(paso++);

		curTabla.setModeAccess( curTabla.Del );
		curTabla.refreshBuffer();
		if ( !curTabla.commitBuffer() )
			break;
	}
}

function oficial_listaDeTablas():Array
{
	var lista:Array = [];
	var i:Number = 0;

	var cur:FLSqlCursor = new FLSqlCursor( "flfiles" );
	cur.select( "nombre LIKE '%.mtd'" );

	while ( cur.next() )
		lista[ i++ ] = cur.valueBuffer( "nombre" ).replace( "\.mtd", "" );

	return lista;
}

function oficial_cargarListaTablas()
{
	var util:FLUtil = new FLUtil();

	var tablas:Array = this.iface.listaDeTablas();

	var curTabla:FLSqlCursor = new FLSqlCursor( "impdat_tablas" );

	// Actualiza la barra de progreso
	this.iface.mensajes.setLabelText(this.iface.mensajes.translate( "scripts", "Cargando lista..." ));
	this.iface.mensajes.setTotalSteps(tablas.length);
	this.iface.mensajes.setProgress(0);

	for ( i = 0; i < tablas.length; i++ ) {
		this.iface.mensajes.setProgress(i);

		curTabla.setModeAccess( curTabla.Insert );
		curTabla.refreshBuffer();
		curTabla.setValueBuffer( "codtabla", tablas[ i ] );
		curTabla.setValueBuffer( "alias", util.tableNameToAlias( tablas[ i ] ) );
		if ( !curTabla.commitBuffer() )
			break;
	}

	this.child("tableDBRecords").refresh();
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////