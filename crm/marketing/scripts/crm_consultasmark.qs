/***************************************************************************
                 crm_consultasmark.qs  -  description
                             -------------------
    begin                : jue nov 2 2006
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

/** @class_declaration interna */
////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
class interna {
    var ctx:Object;
    function interna( context ) { this.ctx = context; }
	function init() {
		return this.ctx.interna_init();
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	function oficial( context ) { interna( context ); }
	function buscarCampoClave() {
		return this.ctx.oficial_buscarCampoClave();
	}
	function buscarCampoNombre() {
		return this.ctx.oficial_buscarCampoNombre();
	}
	function buscarCampoEmail() {
		return this.ctx.oficial_buscarCampoEmail();
	}
	function buscarCampoTel() {
		return this.ctx.oficial_buscarCampoTel();
	}
	function buscarCampoDir() {
		return this.ctx.oficial_buscarCampoDir();
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
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	connect(this.child("tbnCampoClave"), "clicked()", this, "iface.buscarCampoClave");
	connect(this.child("tbnCampoNombre"), "clicked()", this, "iface.buscarCampoNombre");
	connect(this.child("tbnCampoEmail"), "clicked()", this, "iface.buscarCampoEmail");
	connect(this.child("tbnCampoTel"), "clicked()", this, "iface.buscarCampoTel");
	connect(this.child("tbnCampoDir"), "clicked()", this, "iface.buscarCampoDir");
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Muestra al usuario la lista de campos de la consulta para que seleccione uno de ellos como campo clave del destinatario
\end */
function oficial_buscarCampoClave()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var valores:Array = flcrm_mark.iface.pub_seleccionCampo(cursor.valueBuffer("campos"));
	if (valores)
		this.child("fdbCampoClave").setValue(valores["campo"]);
}

/** \D Muestra al usuario la lista de campos de la consulta para que seleccione uno de ellos como campo nombre del destinatario
\end */
function oficial_buscarCampoNombre()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var valores:Array = flcrm_mark.iface.pub_seleccionCampo(cursor.valueBuffer("campos"));
	if (valores)
		this.child("fdbCampoNombre").setValue(valores["campo"]);
}


/** \D Muestra al usuario la lista de campos de la consulta para que seleccione uno de ellos como campo e-mail del destinatario
\end */
function oficial_buscarCampoEmail()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var valores:Array = flcrm_mark.iface.pub_seleccionCampo(cursor.valueBuffer("campos"));
	if (valores)
		this.child("fdbCampoEmail").setValue(valores["campo"]);
}

/** \D Muestra al usuario la lista de campos de la consulta para que seleccione uno de ellos como campo teléfono del destinatario
\end */
function oficial_buscarCampoTel()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var valores:Array = flcrm_mark.iface.pub_seleccionCampo(cursor.valueBuffer("campos"));
	if (valores)
		this.child("fdbCampoTel").setValue(valores["campo"]);
}

/** \D Muestra al usuario la lista de campos de la consulta para que seleccione uno de ellos como campo dirección del destinatario
\end */
function oficial_buscarCampoDir()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var valorActual:String = cursor.valueBuffer("campodir");
	if (!valorActual)
		valorActual = "";

	var valores:Array = flcrm_mark.iface.pub_seleccionCampo(cursor.valueBuffer("campos"));
	if (valores)
		this.child("fdbCampoDir").editor().insert((valores["campo"]) + "%%");
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
