/***************************************************************************
                                 flacs.qs
                            -------------------
   begin                : sab oct 09 2005
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
	function validateForm():Boolean {
		return this.ctx.interna_validateForm();
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var tbnObjectName:Object; 
	var flactions:Array;
	var formActual:String;  /// Nombre de la acción correspondiente al formulario seleccionado (para --tipo-- = form)
	var xmlAcciones:FLDomDocument;
	var desActual:String;

	function oficial( context ) { interna( context ); } 
	function setObjectName() {
		this.ctx.oficial_setObjectName();
	}
	function flActionData(nodeName:String):String {
		return this.ctx.oficial_flActionData(nodeName);
	}
	function usrOrGrp() {
		this.ctx.oficial_usrOrGrp();
	}
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function nombreForm():String {
		return this.ctx.oficial_nombreForm();
	}
	function descripcionAuto() {
		this.ctx.oficial_descripcionAuto();
	}
	function calculateField(fN:String):Number {
		return this.ctx.oficial_calculateField(fN);
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
	this.iface.tbnObjectName = this.child("tbnObjectName");
	this.iface.flactions = [];
	this.iface.formActual = "";
	this.iface.desActual = this.child("fdbDescripcion").value().toString();

	var fdbDeGrupo:FLFieldDB = this.child( "fdbDeGrupo" );
	var cursor:FLSqlCursor = this.cursor();

	
	if (cursor.modeAccess() != cursor.Insert) {
		this.iface.tbnObjectName.setEnabled(false);
		this.child("fdbIdModulo").setDisabled(true);
		this.child("fdbIdArea").setDisabled(true);
		this.child("fdbTipoForm").setDisabled(true);
		this.iface.bufferChanged("idmodule");	
	} else {
		this.iface.bufferChanged("tipo");
		this.child( "fdbPrioridad" ).setValue( this.iface.calculateField( "prioridad" ) );
	}

	connect(this.iface.tbnObjectName, "clicked()", this, "iface.setObjectName");
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect( fdbDeGrupo.editor(), "clicked()", this, "iface.usrOrGrp" );
	connect( this.child( "fdbDesArea").editor(), "textChanged( QString )", this, "iface.descripcionAuto" );
	connect( this.child( "fdbDesModulo").editor(), "textChanged( QString )", this, "iface.descripcionAuto" );
	this.iface.usrOrGrp();
}

function interna_validateForm():Boolean {
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
/** \C Debe indicarse siempre un usuario o un grupo
\end */
	if ( cursor.isNull( "iduser" ) && cursor.isNull( "idgroup" ) ) {
		MessageBox.critical( util.translate( "scripts", "Hay que indicar un Usuario o un Grupo." ), MessageBox.Ok );
		return false;
	}
	
/** \C No pueden repetirse reglas con el mismo tipo y nombre de elemento aplicadas al mismo usuario o grupo
\end */
	var fdbDeGrupo:FLFieldDB = this.child( "fdbDeGrupo" );
	var where:String = "idac <> " + cursor.valueBuffer( "idac" );
	where += " AND nombre = '" + cursor.valueBuffer( "nombre" ) + "'";
	where += " AND tipo = '" + cursor.valueBuffer( "tipo" ) + "'";
	
	if ( fdbDeGrupo.value() )
		where += " AND idgroup = '" + cursor.valueBuffer( "idgroup" ) + "'";
	else
		where += " AND iduser = '" + cursor.valueBuffer( "iduser" ) + "'";
	
	var idac = util.sqlSelect( "flacs", "idac", where );

	if ( idac ) {
		MessageBox.critical( util.translate( "scripts", "Ya existe una regla con el mismo Tipo, Nombre y Usuario/Grupo." ), MessageBox.Ok );
		return false;
	}

	return true;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_bufferChanged(fN:String)
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil;
	
	switch(fN) {
		case "nombre": {
			this.iface.descripcionAuto();
			break;
		}

/** \C Al establecer el --tipo-- como formulario, se habilitará el control --tipoform--
\end */
		case "tipo": {
			var tipo:String = cursor.valueBuffer("tipo");
			if (tipo == util.translate("MetaData", "form"))
				this.child("fdbTipoForm").setDisabled(false);
			else
				this.child("fdbTipoForm").setDisabled(true);
				
/** \C Si el tipo es mainwindow, el nombre por defecto del elemento es el nombre del módulo
\end */
			if (tipo == util.translate("MetaData", "mainwindow"))
				this.child("fdbNombre").setValue(cursor.valueBuffer("idmodule"));
			this.iface.descripcionAuto();
			break;
		}
		case "idmodule": {
			this.iface.flactions = [];
			var contenido:String = util.sqlSelect("flfiles", "contenido", 
				"nombre = '" + cursor.valueBuffer("idmodule") + ".xml'")
			if (!contenido) 
				return;
			this.iface.xmlAcciones = new FLDomDocument();
			this.iface.xmlAcciones.setContent(contenido);
			var listaAcciones:FLDomNodeList = this.iface.xmlAcciones.elementsByTagName("action");
			for (var i = 0; i < listaAcciones.length(); i++) {
				this.iface.flactions[i] = listaAcciones.item(i).namedItem("name").toElement().text();
			}
			if (cursor.valueBuffer("tipo") == util.translate("MetaData", "mainwindow"))
				this.child("fdbNombre").setValue(cursor.valueBuffer("idmodule"));
			this.iface.descripcionAuto();
			break;
		}
/** \C La selección del campo --tipoform-- permite añadir automáticamente el prefijo adecuado al nombre del formulario
\end */
		case "tipoform": {
			if (cursor.modeAccess() == cursor.Insert)
				this.child("fdbNombre").setValue(this.iface.nombreForm());
			break;
		}
	}
}


/** \D Ayuda a establecer el nombre del objeto proponiendo una lista de los posibles candidatos. El contenido de la lista varía en función del tipo del objeto a especificar.
*/
function oficial_setObjectName()
{
	var idPrueba:Array = new Array();
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil;
	var tipo:String = util.translate("MetaData", cursor.valueBuffer("tipo"));
	var idModulo:String = cursor.valueBuffer("idmodule");
	var where:String = "";
	var valor:String = "";
	
	switch(tipo) {
		case "table": {
			var curLista:FLSqlCursor = new FLSqlCursor("flfiles");
			if (idModulo && idModulo != "")
				where = "idmodulo = '" + idModulo + "' AND ";
			where += "nombre LIKE '%.mtd'";
			curLista.select(where);
			var i:Number = 0;
			while (curLista.next()){
				curLista.setModeAccess(curLista.Browse);
				curLista.refreshBuffer();
				idPrueba[i++] = curLista.valueBuffer("nombre");
			}
			var name:String = Input.getItem(util.translate("scripts", "Seleccione la tabla"), idPrueba, false, "opcion");
			if (!name)
				return;
				
			for (var i:Number = 0; (name.toString().charAt(i) != "."); i++) {
				valor += name.toString().charAt(i);
			}
			this.iface.formActual = "";
			break;
		}
		case "form": {
			if (!this.iface.flactions || this.iface.flactions.length == 0) {
				MessageBox.warning(util.translate("scripts", "Debe seleccionar un módulo para poder ver sus formularios asociados"), MessageBox.Ok, MessageBox.NoButton);
				return;
			}
			valor = Input.getItem(util.translate("scripts", "Seleccione la acción"), this.iface.flactions, "", false, "");
			if (valor) {
				this.iface.formActual = valor;
				valor = this.iface.nombreForm();
			}
			break;
		}
		case "mainwindow": {
			return;
			break;
		}
	}

	if (!valor)
		return;
	this.child("fdbNombre").setValue(valor);
}

/** \D Construye el nombre del formulario en función del nombre de la acción y del valor del campo --tipoform--
@return	Nombre del formulario
\end */
function oficial_nombreForm():String
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var tipoForm:String = util.translate("MetaData", cursor.valueBuffer("tipoform"));
	var res:String;
	switch(tipoForm) {
		case "Edición": {
			res = "formRecord" + this.iface.formActual;
			break;
		}
		case "Búsqueda": {
			res = "formSearch" + this.iface.formActual;
			break;
		}
		default: {
			res = "form" + this.iface.formActual;
			break;
		}
	}
	return res;
}

/** \D
Establece las habilitaciones necesarias según el valor del campo --degrupo--
\end */
function oficial_usrOrGrp() {
	var fdbDeGrupo:FLFieldDB = this.child( "fdbDeGrupo" );
	var fdbIdUser:FLFieldDB = this.child( "fdbIdUser" );
	var fdbIdGroup:FLFieldDB = this.child( "fdbIdGroup" );

	if ( fdbDeGrupo.value() ) {
		fdbIdUser.setValue( "" );
		fdbIdUser.setDisabled( true );
		fdbIdGroup.setDisabled( false );
	} else {
		fdbIdUser.setDisabled( false );
		fdbIdGroup.setValue( "" );
		fdbIdGroup.setDisabled( true );	
	}
}

/** \D Establece un texto automáticamente para el campo descripción según la información de los otros campos de la regla.
\end */
function oficial_descripcionAuto()
{
	if ( this.iface.desActual.isEmpty() || this.child("fdbDescripcion").value() == this.iface.desActual ) {
		var newDes:String = this.child("fdbDesArea").value() + ":" + this.child("fdbDesModulo").value() + ":" +
			this.child("fdbTipo").editor().currentText + ":" + this.child("fdbTipoForm").editor().currentText + ":" + this.child("fdbNombre").value();
		this.child("fdbDescripcion").setValue( newDes );
		this.iface.desActual = newDes;
	}
}

function oficial_calculateField(fN:String):Number
{
	var cursor:FLSqlCursor = this.cursor();
	switch( fN ) {
		case "prioridad": {
			var idAcl:String = cursor.valueBuffer( "idacl" );
			var qryContador:FLSqlQuery= new FLSqlQuery();
			with( qryContador ) {
					setTablesList( "flacs" );
					setSelect( "MAX(prioridad)" );
					setFrom( "flacs" );
					setWhere( "idacl = '" + idAcl +"'");
			}
			if ( !qryContador.exec() )
					return;
			if( qryContador.next() ) {
					var contador:Number = parseFloat( qryContador.value(0) );
					return ++contador;
			}
		break;
		}
	}
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
