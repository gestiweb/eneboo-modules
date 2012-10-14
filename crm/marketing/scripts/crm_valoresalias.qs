/***************************************************************************
                 crm_valoresalias.qs  -  description
                             -------------------
    begin                : mar oct 31 2006
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
	function acceptedForm() {
		return this.ctx.interna_acceptedForm();
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var tbnCampo:Object;
	function oficial( context ) { interna( context ); }
	function buscarCampo() {
		return this.ctx.oficial_buscarCampo();
	}
	function establecerFiltro():String {
		return this.ctx.oficial_establecerFiltro();
	}
	function desconectar() {
		return this.ctx.oficial_desconectar();
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

	this.iface.tbnCampo = this.child("tbnCampo");
	connect(this.iface.tbnCampo, "clicked()", this, "iface.buscarCampo");

	this.child("fdbIdAlias").setFilter(this.iface.establecerFiltro());
}

function interna_acceptedForm()
{
	this.iface.desconectar();
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_desconectar()
{
	disconnect(this.iface.tbnCampo, "clicked()", this, "iface.buscarCampo");
}

/** \D Muestra al usuario la lista de campos de la consulta para que seleccione uno de ellos
\end */
function oficial_buscarCampo()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var codConsulta:String = util.sqlSelect("crm_listasmark", "codconsulta", "codlista = '" + cursor.cursorRelation().valueBuffer("codlista") + "'");
	var valores:Array = flcrm_mark.iface.pub_buscarCampo(codConsulta);
	if (!valores)
		return;

	cursor.setValueBuffer("campo", valores["campo"]);
	this.child("fdbNombre").setValue(valores["nombre"]);
}

/** \D Establece un filtro sobre los alias para sólo mostrar los de la campaña actual que todavía no están asignados
@return	filtro (cláusula where) a aplicar o false si hay error
\end */ 
function oficial_establecerFiltro():String
{
	var cursor:FLSqlCursor = this.cursor();
	var codCampana:String = cursor.cursorRelation().valueBuffer("codcampana");
	var filtro = "codcampana = '" + codCampana + "'";
	var idLista:String = cursor.valueBuffer("idlista");
	var masFiltro:String = "";
	var qryAlias:FLSqlQuery = new FLSqlQuery();
	with (qryAlias) {
		setTablesList("crm_valoresalias");
		setSelect("alias");
		setFrom("crm_valoresalias");
		setWhere("idlista = " + idLista);
		setForwardOnly(true);
	}
	if (!qryAlias.exec())
		return false;
	while (qryAlias.next()) {
		if (masFiltro == "")
			masFiltro = " AND alias NOT IN(";
		else
			masFiltro += ", ";
		masFiltro += "'" + qryAlias.value("alias") + "'";
	}
	if (masFiltro != "") {
		masFiltro += ")";
		filtro += masFiltro;
	}
	return filtro;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
