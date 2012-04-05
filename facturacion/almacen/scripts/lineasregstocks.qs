/***************************************************************************
                 lineasregstocks.qs  -  description
                             -------------------
    begin                : lun abr 26 2004
    copyright            : (C) 2004 by InfoSiAL S.L.
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
    function validateForm():Boolean { return this.ctx.interna_validateForm(); }
    function acceptedForm() { return this.ctx.interna_acceptedForm(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    function oficial( context ) { interna( context ); } 
    function habilitarPorModo() {
        return this.ctx.oficial_habilitarPorModo();
    }
    function datosInsercion() {
        return this.ctx.oficial_datosInsercion();
    }
    function bufferChanged(fN) {
        return this.ctx.oficial_bufferChanged(fN);
    }
    function validarCantidades() {
        return this.ctx.oficial_validarCantidades();
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
/** \C 
En modo inserción, los valores de --cantidadini-- y --cantidadfin-- aparecen informados con la cantidad actual

En modo edición, no es posible cambiar los valores de --cantidadfin--, --fecha-- y --motivo--
\end */
function interna_init()
{
    var cursor = this.cursor();
    connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged()");
    
    this.iface.habilitarPorModo();
    this.iface.datosInsercion();
}

function interna_validateForm():Boolean
{
    if (!this.iface.validarCantidades()) {
        return false;
    }
    return true;
}

/** \D
La --cantidadfin-- se actualiza en las regularizaciones de stocks
\end */
function interna_acceptedForm()
{
/*
		var cursor:FLSqlCursor = this.cursor();
		if (cursor.modeAccess() == cursor.Insert)
				formRecordregstocks.iface.pub_cambiarCantidad(cursor.valueBuffer("cantidadfin"));
*/
    var cursor:FLSqlCursor = this.cursor();
    if (cursor.modeAccess() == cursor.Insert)
       formRecordregstocks.iface.pub_cambiarCantidad(cursor.valueBuffer("cantidadfin"));
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_habilitarPorModo()
{
    var cursor = this.cursor();
    var insercion = cursor.modeAccess() == cursor.Insert;
    this.child("fdbCantidadFin").setDisabled(!insercion);
    this.child("fdbFecha").setDisabled(!insercion);
    this.child("fdbHora").setDisabled(!insercion);
}
 
function oficial_datosInsercion()
{
    var cursor = this.cursor();
    if (cursor.modeAccess() != cursor.Insert) {
        return;
    }
    var curRel = cursor.cursorRelation();
    if (!curRel) return;
    
    switch (curRel.table()) {
        case "stocks": {
            this.child("fdbCantidadIni").setValue(curRel.valueBuffer("cantidad"));
            this.child("fdbCantidadFin").setValue(curRel.valueBuffer("cantidad"));
            break;
        }
        case "inventarios": {
            this.child("fdbReferencia").setFocus();
            break;
        }
    }
}

function oficial_bufferChanged(fN)
{
    
}

function oficial_validarCantidades()
{
    /** \C
    El valor de --cantidadfin-- debe ser mayor que cero
    \end */
    var util = new FLUtil();
    var cursor = this.cursor();
    var cantidadFin = cursor.valueBuffer("cantidadfin");
    
    if (cantidadFin < 0) {
        MessageBox.warning(util.translate("scripts", "La cantidad debe ser mayor que cero"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
        return false;
    }
    /** \C
    El valor de --cantidadfin-- debe ser distinta de la --cantidadini--
    \end */
    var cantidadIni = cursor.valueBuffer("cantidadini")
    if (cantidadFin == cantidadIni) {
        MessageBox.warning(util.translate("scripts", "Las cantidad nueva es igual a la inicial"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
        return false;
    }
    return true;
}
function oficial_validarCantidades()
{
    /** \C
    El valor de --cantidadfin-- debe ser mayor que cero
    \end */
    var util = new FLUtil();
    var cursor = this.cursor();
    var cantidadFin = cursor.valueBuffer("cantidadfin");
    
    if (cantidadFin < 0) {
        MessageBox.warning(util.translate("scripts", "La cantidad debe ser mayor que cero"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
        return false;
    }
    /** \C
    El valor de --cantidadfin-- debe ser distinta de la --cantidadini--
    \end */
    var cantidadIni = cursor.valueBuffer("cantidadini")
    if (cantidadFin == cantidadIni) {
        MessageBox.warning(util.translate("scripts", "Las cantidad nueva es igual a la inicial"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
        return false;
    }
    return true;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
