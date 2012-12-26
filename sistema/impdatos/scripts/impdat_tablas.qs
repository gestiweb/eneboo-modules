/***************************************************************************
                             impdat_tablas.qs
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
    function oficial( context ) { interna( context ); } 
	function pbnVaciar_clicked() { return this.ctx.oficial_pbnVaciar_clicked(); }
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

function init() {
    this.iface.init();
}

function interna_init() {
	var tdbTabla:FLTableDB = this.child( "tdbTabla" );

	tdbTabla.setTableName( this.cursor().valueBuffer( "codtabla" ) );
	tdbTabla.refresh( true, true );
	tdbTabla.setReadOnly( true );

	connect( this.child( "pbnVaciar" ), "clicked()", this, "iface.pbnVaciar_clicked" );
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_pbnVaciar_clicked() 
{
	var util:FLUtil = new FLUtil();
	var res = MessageBox.critical( util.translate( "scripts", "Esta acción es peligrosa, se va a proceder a eliminar\ntodos los registros de la tabla.\n\n¿Está realmente seguro?" ), MessageBox.No, MessageBox.Yes, MessageBox.NoButton );

	if ( res != MessageBox.Yes )
		return ;

	this.setDisabled( true );

	var curTabla:FLSqlCursor = new FLSqlCursor( this.child( "tdbTabla" ).cursor().table() );
	var step:Number = 0;

	curTabla.select();
	var totalSteps:Number = curTabla.size();
	util.createProgressDialog( util.translate( "scripts", "Eliminando registros..." ), totalSteps );
	while ( curTabla.next() ) {
		curTabla.setModeAccess( curTabla.Del );
		curTabla.refreshBuffer();
		if ( !curTabla.commitBuffer() )
			break;
		util.setProgress( step++ );
	}
	util.setProgress( totalSteps );
	util.destroyProgressDialog();

	this.child( "tdbTabla" ).refresh();
	this.setDisabled( false );
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////