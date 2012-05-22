/***************************************************************************
                                 flacos.qs
                            -------------------
   begin                : mie oct 19 2005
   copyright            : (C) 2004-2005 by InfoSiAL S.L.
   email                : mail@infosial.com
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

//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var tbnObjectName:Object;
	var tipo:String; /// Tipo del objeto contenedor
	var contenedor:String; /// Nombre del objeto contenerdor
	var desActual:String;

    function oficial( context ) { interna( context ); } 
	function setObjectName() {
		return this.ctx.oficial_setObjectName();
	}
	function descripcionAuto() {
		this.ctx.oficial_descripcionAuto();
	}
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends oficial {
	function head( context ) { oficial ( context ); }
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

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

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////

/** \C 
\end */
function interna_init()
{
	var util:FLUtil = new FLUtil;
	var cursorRel:FLSqlCursor = this.cursor().cursorRelation();
	this.iface.tbnObjectName = this.child("tbnObjectName");
	this.iface.tipo = util.translate("MetaData", cursorRel.valueBuffer("tipo"));
	this.iface.contenedor = util.translate("MetaData", cursorRel.valueBuffer("nombre"));
	this.iface.desActual = this.child("fdbDescripcion").value().toString();

	if (this.iface.tipo != "form") {
		this.child("fdbTipoControl").setDisabled(true);
		this.cursor().setNull("tipocontrol");
	}

	if ( this.cursor().modeAccess() == this.cursor().Insert )
		connect(this.iface.tbnObjectName, "clicked()", this, "iface.setObjectName");
	else
		this.iface.tbnObjectName.setDisabled(true);
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Ayuda a establecer el nombre del objeto proponiendo una lista de los posibles candidatos. El contenido de la lista varía en función del tipo del contenedor del objeto (tabla, formulario, etc.)
*/
function oficial_setObjectName()
{
	var idPrueba:Array = new Array();
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil;
	var valor:String = "";
	var arrayAux:Array = [];
	
	switch(this.iface.tipo) {
		case "table": {
			var contenido:String = util.sqlSelect("flfiles", "contenido",  "nombre = '" + this.iface.contenedor + ".mtd'")
			if (!contenido) 
				return;
			var xmlDoc:FLDomDocument = new FLDomDocument();
			xmlDoc.setContent(contenido);
			var listaCampos:FLDomNodeList = xmlDoc.firstChild().childNodes();
			var indice:Number = 0;
			var alias:String;
			for (var i = 0; i < listaCampos.length(); i++) {
				if (listaCampos.item(i).nodeName() == "field") {
					alias = listaCampos.item(i).namedItem("alias").toElement().text();
					arrayAux = alias.split("\"");
					if (arrayAux.length > 4)
						alias = arrayAux[3];
					idPrueba[indice++] = listaCampos.item(i).namedItem("name").toElement().text() + " / " + alias;
				}
			}
			valor = Input.getItem(util.translate("scripts", "Seleccione el campo"), idPrueba, false, "opcion");
			if (valor) {
				arrayAux = valor.split(" ");
				valor = arrayAux[0];
			}
			break;
		}
		case "form": {
			var tipoControl:String = util.translate("MetaData", cursor.valueBuffer("tipocontrol"));
			var claseControl:String;
			switch (tipoControl) {
				case "Botón": {
					claseControl = "Button";
					break;
				}
				case "Campo": {
					claseControl = "FLFieldDB";
					break;
				}
				case "Tabla": {
					claseControl = "FLTableDB";
					break;
				}
				case "Grupo de controles": {
					claseControl = "QFrame";
					break;
				}
				case "Pestaña": {
					claseControl = "QTabWidget";
					break;
				}
				case "Todos": {
					claseControl = "QWidget";
					break;
				}
			}
			var llamada:String = sys.getWidgetList(this.iface.contenedor, claseControl);
			var a:Array = llamada.split("*");
			var name:String = Input.getItem(util.translate("scripts", "Seleccione el control"), a, false, "opcion");
			if (!name)
				return;

			arrayAux = name.split("/");
			valor = arrayAux[0];
			break;
		}
		case "mainwindow": {
			valor = Input.getItem(util.translate("scripts", "Seleccione la acción"), formRecordflacs.iface.flactions, "", false, "");
			break;
		}
	}

	if (!valor)
		return;
	this.child("fdbNombre").setValue(valor);
	this.iface.descripcionAuto();
}

/** \D Establece un texto automáticamente para el campo descripción según la información de los otros campos de la regla.
\end */
function oficial_descripcionAuto()
{
	if ( this.iface.desActual.isEmpty() || this.child("fdbDescripcion").value() == this.iface.desActual ) {
		var newDes:String = this.child("fdbTipoControl").editor().currentText + ":" + this.child("fdbNombre").value();
		this.child("fdbDescripcion").setValue( newDes );
		this.iface.desActual = newDes;
	}
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
