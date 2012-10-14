/***************************************************************************
                 crm_criterioslista.qs  -  description
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var tbnCampo:Object;
	var tbnValor:Object;
	var tbnValor2:Object;
    function oficial( context ) { interna( context ); }
	function buscarCampo() {
		return this.ctx.oficial_buscarCampo();
	}
	function buscarValor() {
		return this.ctx.oficial_buscarValor();
	}
	function buscarValor2() {
		return this.ctx.oficial_buscarValor2();
	}
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function obtenerValor(campo:String):String {
		return this.ctx.oficial_obtenerValor(campo);
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
	this.iface.tbnValor = this.child("tbnValor");
	this.iface.tbnValor2 = this.child("tbnValor2");
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this.iface.tbnCampo, "clicked()", this, "iface.buscarCampo");
	connect(this.iface.tbnValor, "clicked()", this, "iface.buscarValor");
	connect(this.iface.tbnValor2, "clicked()", this, "iface.buscarValor2");

	this.iface.bufferChanged("tipo");
	this.iface.bufferChanged("condicion");
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Muestra al usuario la lista de campos de la consulta para que seleccione uno de ellos
\end */
function oficial_buscarCampo()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var valores:Array = flcrm_mark.iface.pub_buscarCampoTablas(cursor.cursorRelation().valueBuffer("codconsulta"));
	if (!valores)
		return;

	cursor.setValueBuffer("campo", valores["campo"]);
	cursor.setValueBuffer("tipo", valores["tipo"]);
	this.child("fdbNombre").setValue(valores["nombre"]);
}

function oficial_bufferChanged(fN:String)
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	switch(fN) {
		case "tipo": {
			switch (cursor.valueBuffer("tipo")) {
				// Bool
				case 18: {
					this.child("fdbValor").setDisabled(true);
					var valor:String = cursor.valueBuffer("valor");
					if (valor != "true" && valor != "false")
						this.child("fdbValor").setValue("");
					break;
				}
				// Fecha
				case 26: {
					this.child("fdbValor").setDisabled(true);
					var valor:String = cursor.valueBuffer("valor");
					try {
						var fecha:Date = new Date( Date.parse(valor));
					} catch (e) { valor = "";}
					this.child("fdbValor").setValue(valor);
					if (cursor.valueBuffer("condicion") == "Entre") {
						this.child("fdbValor2").setDisabled(true);
						valor = cursor.valueBuffer("valor2");
						try {
							var fecha:Date = new Date( Date.parse(valor));
						} catch (e) { valor = "";}
						this.child("fdbValor2").setValue(valor);
					}
					break;
				}
				default: {
					this.child("fdbValor").setDisabled(false);
				}
			}
			break;
		}
		case "condicion": {
			if (cursor.valueBuffer("condicion") == "Entre") {
				this.child("fdbValor2").setDisabled(false);
				this.iface.tbnValor2.enabled = true;
			} else {
				this.child("fdbValor2").setDisabled(true);
				this.iface.tbnValor2.enabled = false;
			}
		}
	}
}

function oficial_buscarValor()
{
	this.child("fdbValor").setValue(this.iface.obtenerValor("valor"));
}

function oficial_buscarValor2()
{
	this.child("fdbValor2").setValue(this.iface.obtenerValor("valor2"));
}

/** \D Ayuda para obtener los valores de tipo fecha y boolean
@param	campo: Nombre del campo a calcular
@return	valor o false si hay error
\end */
function oficial_obtenerValor(campo:String):String
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var valor:String;
	
	switch (cursor.valueBuffer("tipo")) {
		// Bool
		case 18: {
			if (cursor.valueBuffer(campo) == "false")
				valor = "true";
			else
				valor = "false";
			break;
		}
		// Fecha
		case 26: {
			var dialogo:Dialog = new Dialog;
			dialogo.caption = util.translate("scripts", "");
			dialogo.okButtonText = util.translate("scripts", "Aceptar");
			dialogo.cancelButtonText = util.translate("scripts", "Cancelar");
		
			var fecha:Date = new Date;
			var deFecha = new DateEdit;
			deFecha.label = cursor.valueBuffer("nombre");
			deFecha.date = fecha;
			dialogo.add(deFecha);
			if (!dialogo.exec())
				return false;
			fecha = deFecha.date;
			valor = fecha.toString();
			break;
		}
	}
	return valor;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
