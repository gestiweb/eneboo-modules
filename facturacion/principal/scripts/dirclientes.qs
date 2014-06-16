/***************************************************************************
                 dirclientes.qs  -  description
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
    function init() {
                this.ctx.interna_init();
        }
        function calculateField(fN:String):String {
                return this.ctx.interna_calculateField(fN);
        }
        function validateForm():Boolean {
                return this.ctx.interna_validateForm();
        }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
        var bloqueoProvincia:Boolean = false;
    function oficial( context ) { interna( context ); }
        function bufferChanged(fN:String) {
                return this.ctx.oficial_bufferChanged(fN);
        }
        function comprobarCPProvincia():Boolean {
                return this.ctx.oficial_comprobarCPProvincia();
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


//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

const iface = new ifaceCtx( this );

/** @class_definition interna */
////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
/** \C Si en la tabla de direcciones de clientes no hay todavía ninguna dirección asociada al cliente, la primera dirección introducida se tomará como dirección de facturación y dirección de envío
\end */
function interna_init()
{
        var cursor:FLSqlCursor = this.cursor();
        if (cursor.modeAccess() == cursor.Insert) {
                var cursorCli:FLSqlCursor = new FLSqlCursor("dirclientes");
                cursorCli.select("codcliente = '" + cursor.valueBuffer("codcliente") + "'");
                if (!cursorCli.first()){
                        cursor.setValueBuffer("domenvio", "true");
                        cursor.setValueBuffer("domfacturacion", "true");
                }
        }
        connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
}

function interna_calculateField(fN:String):String
{
        var util:FLUtil = new FLUtil;
        var cursor:FLSqlCursor = this.cursor();
        var valor:String;

        return valor;
}

function interna_validateForm():Boolean
{
        var util:FLUtil = new FLUtil;
        var cursor:FLSqlCursor = this.cursor();

        if (!this.iface.comprobarCPProvincia()) {
                return false;
        }

        if (!flfactppal.iface.pub_validarProvincia(cursor)) {
                return false;
        }

        return true;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_bufferChanged(fN:String)
{
        var util:FLUtil = new FLUtil();
        var cursor:FLSqlCursor = this.cursor();
        
        switch (fN) {
                case "provincia": {
                        if (!this.iface.bloqueoProvincia) {
                                this.iface.bloqueoProvincia = true;
                                flfactppal.iface.pub_obtenerProvincia(this);
                                this.iface.bloqueoProvincia = false;
                        }
                        break;
                }
                case "idprovincia": {
                        if (cursor.valueBuffer("idprovincia") == 0) {
                                cursor.setNull("idprovincia");
                        }
                        break;
                }
        }
}

/** \D Comprueba si el país es España que el código postal sea el equivalente a la provincia
\end */
function oficial_comprobarCPProvincia():Boolean
{
	var util:FLUtil = new FLUtil();
    var cursor:FLSqlCursor = this.cursor();
	
	var codPais:String = cursor.valueBuffer("codpais");
	var codIso:String = util.sqlSelect("paises", "codiso", "codpais = '" + codPais + "'");
	if (codIso == "ES") {
		var codPostal2:String = cursor.valueBuffer("codpostal").left(2);
		var idProvincia:String = cursor.valueBuffer("idprovincia");
		var codProvincia:String = util.sqlSelect("provincias", "codigo" , "idprovincia = " + idProvincia);
		if (codPostal2 != codProvincia) {
			MessageBox.warning(util.translate("scripts", "El código postal no corresponde a la provincia"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}
	return true;
}
/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

