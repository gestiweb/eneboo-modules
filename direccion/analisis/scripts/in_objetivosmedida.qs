/***************************************************************************
                 in_eje.qs  -  description
                             -------------------
    begin                : jue sep 01 2009
    copyright            : (C) 2009 by InfoSiAL S.L.
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
	function oficial( context ) { interna( context );}
	function cargarDatos() {
		return this.ctx.oficial_cargarDatos();
	}
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function aceptar() {
		return this.ctx.oficial_aceptar();
	}
	function guardarDatos() {
		return this.ctx.oficial_guardarDatos();
	}
	function iniciarMuestrasColor() {
		return this.ctx.oficial_iniciarMuestrasColor();
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
/** \C Cuando cambia el ejercicio actual se establece el título de las ventanas principales con
el nombre del ejercicio seleccionado
\end */
function interna_init()
{
debug("interna_init");
	var cursor:FLSqlCursor = this.cursor();

// 	this.iface.tblNiveles_ = this.child("tblNiveles");
// 	this.iface.tblEje_ = this.child("tblEje");

	disconnect (this.child("pushButtonAccept"), "clicked()", this, "accept");
	connect (this.child("pushButtonAccept"), "clicked()", this, "iface.aceptar");
	connect (cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
// 	connect (this.child("tbnPonerNivel"), "clicked()", this, "iface.tbnPonerNivel_clicked");
// 	connect (this.child("tbnQuitarNivel"), "clicked()", this, "iface.tbnQuitarNivel_clicked");
// 	connect (this.child("tbnSubirNivel"), "clicked()", this, "iface.tbnSubirNivel_clicked");
// 	connect (this.child("tbnBajarNivel"), "clicked()", this, "iface.tbnBajarNivel_clicked");
// 	connect (this.iface.tblNiveles_, "doubleClicked(int, int)", this, "iface.tblNiveles_doubleClicked");
// 	connect (this.iface.tblEje_, "doubleClicked(int, int)", this, "iface.tblEje_doubleClicked");
	this.iface.cargarDatos();

	this.iface.iniciarMuestrasColor();
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_cargarDatos()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var idMedida:String = cursor.valueBuffer("idmedida");
	if (!idMedida || idMedida == "") {
debug("!idMedida ");
		return false;
	}
	var xmlPos:FLDomNode = formin_navegador.iface.xmlPosActual_.firstChild();
	var nodoObjetivos:FLDomNode = xmlPos.namedItem("Objetivos");
	var eObjetivos:FLDomElement;
	if (nodoObjetivos) {
		eObjetivos = nodoObjetivos.toElement();
	} else {
		eObjetivos = this.iface.xmlPosActual_.createElement("Objetivos");
		xmlPos.appendChild(eObjetivos);
	}
	
	var nodoTramos:FLDomNode = fldireinne.iface.pub_dameNodoXML(eObjetivos, "Objetivo[@IdMedida=" + idMedida + "]");
	var eTramos:FLDomElement;
	if (nodoTramos) {
		eTramos = nodoTramos.toElement();
	} else {
		eTramos = formin_navegador.iface.xmlPosActual_.createElement("Objetivo");
		eTramos.setAttribute("IdMedida", idMedida);
		nodoObjetivos.appendChild(eTramos);
	}
	var eTramo:FLDomElement;
	var iTramo:Number = 1;
	for (var nodoTramo:FLDomNode = eTramos.firstChild(); nodoTramo; nodoTramo = nodoTramo.nextSibling()) {
		eTramo = nodoTramo.toElement();
		this.child("fdbMinTramo" + iTramo.toString()).setValue(eTramo.attribute("Min"));
		this.child("fdbMaxTramo" + iTramo.toString()).setValue(eTramo.attribute("Max"));
		this.child("fdbColorTramo" + iTramo.toString()).setValue(eTramo.attribute("Color"));
		iTramo++;
	}
}

function oficial_aceptar()
{
	if (!this.iface.guardarDatos()) {
		return false;
	}
	this.accept();
}

function oficial_guardarDatos()
{
	var cursor:FLSqlCursor = this.cursor();

	var idMedida:String = cursor.valueBuffer("idmedida");
	var xmlPos:FLDomNode = formin_navegador.iface.xmlPosActual_.firstChild();
	var nodoObjetivos:FLDomNode = xmlPos.namedItem("Objetivos");
	var nodoTramos:FLDomNode = fldireinne.iface.pub_dameNodoXML(nodoObjetivos, "Objetivo[@IdMedida=" + idMedida + "]");
	var eTramos:FLDomElement = nodoTramos.toElement();

	var nodoTramo:FLDomNode = eTramos.firstChild();
	while (nodoTramo){
		eTramos.removeChild(nodoTramo);
		nodoTramo = eTramos.firstChild();
	}

	var eTramo:FLDomElement;
	for (var iTramo:Number = 1; iTramo <= 3; iTramo++) {
		eTramo = formin_navegador.iface.xmlPosActual_.createElement("Tramo");
		eTramos.appendChild(eTramo);
		eTramo.setAttribute("Min", cursor.valueBuffer("mintramo" + iTramo.toString()));
		eTramo.setAttribute("Max", cursor.valueBuffer("maxtramo" + iTramo.toString()));
		eTramo.setAttribute("Color", cursor.valueBuffer("colortramo" + iTramo.toString()));
	}
	
	return true;
}

function oficial_bufferChanged(fN:String)
{
	var cursor:FLSqlCursor = this.cursor();
	switch(fN) {
		case "maxtramo1": {
			this.child("fdbMinTramo2").setValue(cursor.valueBuffer("maxtramo1"));
			break;
		}
		case "maxtramo2": {
			this.child("fdbMinTramo3").setValue(cursor.valueBuffer("maxtramo2"));
			break;
		}
		case "colortramo1": {
			fldireinne.iface.pub_colorearLabel(this.child("lblColorTramo1"), cursor.valueBuffer(fN));
			break;
		}
		case "colortramo2": {
			fldireinne.iface.pub_colorearLabel(this.child("lblColorTramo2"), cursor.valueBuffer(fN));
			break;
		}
		case "colortramo3": {
			fldireinne.iface.pub_colorearLabel(this.child("lblColorTramo3"), cursor.valueBuffer(fN));
			break;
		}
	}
}

function oficial_iniciarMuestrasColor()
{
	var cursor:FLSqlCursor = this.cursor();
	fldireinne.iface.pub_colorearLabel(this.child("lblColorTramo1"), cursor.valueBuffer("colortramo1"));
	fldireinne.iface.pub_colorearLabel(this.child("lblColorTramo2"), cursor.valueBuffer("colortramo2"));
	fldireinne.iface.pub_colorearLabel(this.child("lblColorTramo3"), cursor.valueBuffer("colortramo3"));
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
