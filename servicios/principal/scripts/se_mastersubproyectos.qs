/***************************************************************************
                 se_mastersubproyectos.qs  -  description
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
	var filtroInicial_:String;
	var chkMisSP:Object;
	var chkProduccion:Object;
	var tableDBRecords:Object;
    function oficial( context ) { interna( context ); } 
// 	function cambiochkMisSP() {
// 		return this.ctx.oficial_cambiochkMisSP();
// 	}
// 	function cambiochkProduccion() {
// 		return this.ctx.oficial_cambiochkProduccion();
// 	}
	function filtroSubproyectos() {
		return this.ctx.oficial_filtroSubproyectos();
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

	this.iface.chkMisSP = this.child("chkMisSP");
	this.iface.chkProduccion = this.child("chkProduccion");
	this.iface.tableDBRecords = this.child("tableDBRecords")
	this.iface.tableDBRecords.putFirstCol("descripcion");
	this.iface.filtroInicial_ = cursor.mainFilter();
debug("this.iface.filtroInicial_ = " + this.iface.filtroInicial_ );

	connect(this.iface.chkMisSP, "clicked()", this, "iface.filtroSubproyectos");
	connect(this.iface.chkProduccion, "clicked()", this, "iface.filtroSubproyectos");
	
	this.iface.chkProduccion.checked = true;
	this.iface.chkMisSP.checked = true;
// 	this.iface.cambiochkMisSP();
// 	this.iface.cambiochkProduccion();
	this.iface.filtroSubproyectos();
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_filtroSubproyectos():String
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var filtro:String = this.iface.filtroInicial_;
	if (this.iface.chkMisSP.checked) {
		var codUsuario = util.readSettingEntry("scripts/flservppal/codusuario");
		if (!codUsuario) {
			MessageBox.information( util.translate( "scripts", "No se ha definido usuario actual"), MessageBox.Ok, MessageBox.NoButton);
			return;
		}
		if (filtro != "") {
			filtro += " AND ";
		}
		filtro += " codencargado = '" + codUsuario + "'";
	}

	if (this.iface.chkProduccion.checked) {
		if (filtro != "") {
			filtro += " AND ";
		}
		filtro += "estado NOT IN ('En producción', 'Cancelado', 'Pospuesto')";
	}
	cursor.setMainFilter(filtro);
	this.iface.tableDBRecords.refresh();
}

/** \D Filtra las tabla de incidencias por incidencias pendientes si está activa la opcion de SóloPendientes y refresca la tabla
\end */
// function oficial_cambiochkMisSP()
// { 
// 	var util:FLUtil = new FLUtil();
// 	if (this.iface.chkMisSP.checked == true) {
// 		var codUsuario = util.readSettingEntry("scripts/flservppal/codusuario");
// 		if (!codUsuario) {
// 			MessageBox.information( util.translate( "scripts", "No se ha definido un usuario" ),
// 					MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton );
// 			return;
// 		}
// 		this.iface.tableDBRecords.cursor().setMainFilter("codencargado = '" + codUsuario + "'");
// 	} else {
// 		this.iface.tableDBRecords.cursor().setMainFilter("");
// 	}
// 
// 	
// 	this.iface.tableDBRecords.refresh();
// }

/** \D Filtra las tabla de incidencias por incidencias pendientes si está activa la opcion de SóloPendientes y refresca la tabla
\end */
/*function oficial_cambiochkProduccion()
{ 
	var util:FLUtil = new FLUtil();
	var filtro:String;
	
	if(this.iface.chkMisSP.checked) {
		var codUsuario = util.readSettingEntry("scripts/flservppal/codusuario");
		if (!codUsuario) {
			MessageBox.information( util.translate( "scripts", "No se ha definido un usuario" ),
					MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton );
			return;
		}
		filtro = "codencargado = '" + codUsuario + "'";
	}
	else
		filtro = "";
	
	if(this.iface.chkProduccion.checked) {
		if (filtro) filtro += " AND ";
		filtro += "estado NOT IN ('En producción', 'Cancelado', 'Pospuesto')";
	}
	
	this.iface.tableDBRecords.cursor().setMainFilter(filtro);
	this.iface.tableDBRecords.refresh();
}*/
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
