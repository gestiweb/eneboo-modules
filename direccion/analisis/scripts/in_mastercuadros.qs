/***************************************************************************
                 in_mastercuadros.qs  -  description
                             -------------------
    begin                : mie jun 30 2010
    copyright            : (C) 2010 by InfoSiAL S.L.
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
	function init() { this.ctx.interna_init(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var tbnImportar:Object;
	var tbnExportar:Object;
	function oficial( context ) { interna( context );}
	function importar_clicked() {
		return this.ctx.oficial_importar_clicked();
	}
	function exportar_clicked() {
		return this.ctx.oficial_exportar_clicked();
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

	
	this.iface.tbnImportar = this.child("tbnImportar");
	this.iface.tbnExportar = this.child("tbnExportar");
	
	connect (this.iface.tbnImportar, "clicked()", this, "iface.importar_clicked");
	connect (this.iface.tbnExportar, "clicked()", this, "iface.exportar_clicked");
	
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_importar_clicked()
{
	var util:FLUtil;
	
	var archivo = FileDialog.getOpenFileName( "*.xml" );
	if (!archivo || archivo == "") {
		MessageBox.information(util.translate("scripts", "No se ha encontrado el archivo a importar"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}

	var contenidoXML:String = File.read(archivo);
	
// 	debug("contenido " + contenidoXML);
	
	var xmlCuadro:FLDomElement = new FLDomDocument();
	xmlCuadro.setContent(contenidoXML);
	var eCuadro:FLDomElement = xmlCuadro.firstChild().toElement();
	
	if(util.sqlSelect("in_cuadros","codcuadro","codcuadro = '" + eCuadro.attribute("codcuadro") + "'")) {
		MessageBox.information(util.translate("scripts", "No se puede importar el archivo. Ya existe otro cuadro con el códiog %1").arg(eCuadro.attribute("codcuadro")), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	
	var curCuadro:FLSqlCursor = new FLSqlCursor("in_cuadros");
	curCuadro.setModeAccess(curCuadro.Insert);
	curCuadro.refreshBuffer();
	curCuadro.setValueBuffer("codcuadro",eCuadro.attribute("codcuadro"));
	curCuadro.setValueBuffer("descripcion",eCuadro.attribute("descripcion"));
	curCuadro.setValueBuffer("numpaginas",eCuadro.attribute("numpaginas"));
	curCuadro.setValueBuffer("alto",eCuadro.attribute("alto"));
	curCuadro.setValueBuffer("ancho",eCuadro.attribute("ancho"));
	if(!curCuadro.commitBuffer())
		return false;
	
	var ePosiciones:FLDomElement = eCuadro.namedItem("Posiciones");
	var idPosicion:Number;
	var xml:String = "";
	var eXML:FLDomNode;
	var xmlPos:FLDomDocument;
	if (ePosiciones) {
		var ePosicion:FLDomElement;
		var curPosicion:FLSqlCursor = new FLSqlCursor("in_posicionescuadro");
		for (var xmlPosicion:FLDomNode = ePosiciones.firstChild(); xmlPosicion; xmlPosicion = xmlPosicion.nextSibling()) {
			ePosicion = xmlPosicion.toElement();
			debug("Posicion  " + ePosicion.attribute("nombre"));
			idPosicion = util.sqlSelect("in_posiciones","id","nombre = '" + ePosicion.attribute("nombre") + "' AND cubo  = '" + ePosicion.attribute("cubo") + "'");
			if(!idPosicion) {
				var curP:FLSqlCursor = new FLSqlCursor("in_posiciones");
				curP.setModeAccess(curP.Insert);
				curP.refreshBuffer();
				curP.setValueBuffer("nombre",ePosicion.attribute("nombre"));
				curP.setValueBuffer("cubo",ePosicion.attribute("cubo"));
				eXML = ePosicion.firstChild();
				xmlPos = new FLDomDocument;
				xmlPos.appendChild(eXML.cloneNode(true));
				xml = xmlPos.toString(4);
				curP.setValueBuffer("posicion",xml);
				if(!curP.commitBuffer())
					return false;
				
				idPosicion = curP.valueBuffer("id");
			}
			debug("llega " + idPosicion);
			curPosicion.setModeAccess(curPosicion.Insert);
			curPosicion.refreshBuffer();
			curPosicion.setValueBuffer("codcuadro",ePosicion.attribute("codcuadro"));
			curPosicion.setValueBuffer("idposicion",idPosicion);
			curPosicion.setValueBuffer("nombre",ePosicion.attribute("nombre"));
			curPosicion.setValueBuffer("codtipografico",ePosicion.attribute("codtipografico"));
			curPosicion.setValueBuffer("pagina",ePosicion.attribute("pagina"));
			curPosicion.setValueBuffer("x",ePosicion.attribute("x"));
			curPosicion.setValueBuffer("y",ePosicion.attribute("y"));
			curPosicion.setValueBuffer("ancho",ePosicion.attribute("ancho"));
			curPosicion.setValueBuffer("alto",ePosicion.attribute("alto"));
			if(!curPosicion.commitBuffer()){debug("no crear posicionescuadro");
				return false;}
		}
	}
	
	MessageBox.information(util.translate("scripts", "Inportación finalizada correctamente."), MessageBox.Ok, MessageBox.NoButton);
}

function oficial_exportar_clicked()
{
	var util:FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var codCuadro:String = cursor.valueBuffer("codcuadro");
	if(!codCuadro || codCuadro == "") {
		MessageBox.information(util.translate("scripts", "No hay ningún registro seleccionado."), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	
	var archivo = FileDialog.getSaveFileName( "*.xml" );
	debug("archivo " + archivo);
	
	var xmlCuadro:FLDomDocument = new FLDomDocument();
	xmlCuadro.setContent("<Cuadro/>");

	var eCuadro:FLDomElement = xmlCuadro.firstChild().toElement();
	eCuadro.setAttribute("codcuadro",codCuadro);
	eCuadro.setAttribute("descripcion",cursor.valueBuffer("descripcion"));
	eCuadro.setAttribute("numpaginas",cursor.valueBuffer("numpaginas"));
	eCuadro.setAttribute("alto",cursor.valueBuffer("alto"));
	eCuadro.setAttribute("ancho",cursor.valueBuffer("ancho"));
	
	var qryPC:FLSqlQuery = new FLSqlQuery();
	qryPC.setTablesList("in_posicionescuadro");
	qryPC.setSelect("idposicion,nombre,codtipografico,pagina,x,y,ancho,alto");
	qryPC.setFrom("in_posicionescuadro");
	qryPC.setWhere("codcuadro = '" + codCuadro + "'");
	if (!qryPC.exec()) return false;
	
	var qryP:FLSqlQuery = new FLSqlQuery();
	qryP.setTablesList("in_posiciones");
	qryP.setSelect("cubo,posicion");
	qryP.setFrom("in_posiciones");
		
	var ePosiciones:FLDomElement = xmlCuadro.createElement("Posiciones");
	eCuadro.appendChild(ePosiciones);
	var ePosicion:FLDomDocument;
	var eXMLPos:FLDomDocument;
	while(qryPC.next()) {
		qryP.setWhere("id = " + qryPC.value("idposicion"));
		if (!qryP.exec()) return false;
		if(!qryP.first()) return false;
		
		ePosicion = xmlCuadro.createElement("PosicionCuadro");
		ePosiciones.appendChild(ePosicion);
		ePosicion.setAttribute("codcuadro", codCuadro);
		ePosicion.setAttribute("nombre", qryPC.value("nombre"));
		ePosicion.setAttribute("cubo", qryP.value("cubo"));
		ePosicion.setAttribute("codtipografico", qryPC.value("codtipografico"));
		ePosicion.setAttribute("pagina", qryPC.value("pagina"));
		ePosicion.setAttribute("x", qryPC.value("x"));
		ePosicion.setAttribute("y", qryPC.value("y"));
		ePosicion.setAttribute("ancho", qryPC.value("ancho"));
		ePosicion.setAttribute("alto", qryPC.value("alto"));
		
		var xmlPos:FLDomElement = new FLDomDocument();
		debug("posicion " +qryP.value("posicion"));
		xmlPos.setContent(qryP.value("posicion"));
/*
		var eXMLPos:FLDomElement = xmlPos.firstChild().toElement();*/
		ePosicion.appendChild(xmlPos);
	}
	
	var contenidoXML:String = xmlCuadro.toString(4);
	debug("XML " + contenidoXML);
	File.write(archivo, contenidoXML);
	
	MessageBox.information(util.translate("scripts", "El cuadro ha sido exportado al fichero:\n%1").arg(archivo), MessageBox.Ok, MessageBox.NoButton);
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

