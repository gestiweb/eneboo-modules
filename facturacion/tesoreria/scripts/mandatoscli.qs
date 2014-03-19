/***************************************************************************
                 mandatoscli.qs  -  description
                             -------------------
    begin                : mar dic 10 2013
    copyright            : (C) 2013 by InfoSiAL S.L.
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
    var ctx;

	function interna( context ) {
		this.ctx = context;
	}
	function init() {
		this.ctx.interna_init();
	}
	function validateForm() {
		return this.ctx.interna_validateForm();
	}
	function calculateField(fN) {
		return this.ctx.interna_calculateField(fN);
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	function oficial( context ) { 
		interna( context ); 
	} 
	function bufferChanged(fN) { 
		this.ctx.oficial_bufferChanged(fN); 
	}
	function commonCalculateField(fN, cursor) {
		return this.ctx.oficial_commonCalculateField(fN, cursor);
	}
	function commonBufferChanged(fN, miForm) {
		return this.ctx.oficial_commonBufferChanged(fN, miForm);
	}
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends oficial {
    function head( context ) { 
    	oficial ( context ); 
    }
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration ifaceCtx */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends head {
    function ifaceCtx( context ) { 
    	head( context ); 
    }
    function pub_commonBufferChanged(fN, miForm) {
    	return this.commonBufferChanged(fN, miForm);
    }
    function pub_commonCalculateField(fN, cursor) {
    	return this.commonCalculateField(fN, cursor);
    }
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
	var _i = this.iface;
	var cursor = this.cursor();
	
	connect(cursor, "bufferChanged(QString)", _i, "bufferChanged");
	
	if(cursor.modeAccess() == cursor.Insert) {
		sys.setObjText(this,"fdbFechaCaducidad",_i.calculateField("fechacaducidad"));
	}
}

function interna_calculateField(fN)
{
	var _i = this.iface;
	var cursor = this.cursor();
	
	return _i.commonCalculateField(fN, cursor);
}

function interna_validateForm()
{
	var cursor = this.cursor();

	return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_bufferChanged(fN)
{
	var _i = this.iface;
	var cursor = this.cursor();
	
	switch (fN) {
		default: {
			_i.commonBufferChanged(fN, this);
			break;
		}
	}
}

function oficial_commonCalculateField(fN, cursor)
{
	var _i = this.iface;
	var valor;
	
	switch (fN) {
		case "fechacaducidad": {
			var fechaAnt;
			fechaAnt = cursor.valueBuffer("fechaultadeudo");
			if(!fechaAnt || fechaAnt == "") {
				fechaAnt = cursor.valueBuffer("fechafirma");
				if(!fechaAnt || fechaAnt == "") {
					return false;
				}
			}
			valor = AQUtil.addMonths(fechaAnt,36);
			break;
		}
	}
	return valor;
}

function oficial_commonBufferChanged(fN, miForm)
{
	var _i = this.iface;
	var cursor = miForm.cursor();

	switch(fN) {
		case "fechafirma": {
			sys.setObjText(miForm,"fdbFechaCaducidad",_i.commonCalculateField("fechacaducidad",cursor));
		}
		case "fechaultadeudo": {
			sys.setObjText(miForm,"fdbFechaCaducidad",_i.calculateField("fechacaducidad",cursor));
		}
		default: {
			break;
		}
	}
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
