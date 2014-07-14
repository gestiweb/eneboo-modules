/***************************************************************************
                             impdat_esquemas.qs
                            -------------------
   begin                : lun dic 13 2004
   copyright            : (C) 2004-2005 by InfoSiAL S.L.
   email                : mail@infosial.com
   copyright            : (C) 2011 by Silix
   email                : contacto@silix.com.ar
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

/** @file */

////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

/** @class_declaration interna */
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
	var sep:String;

    function oficial( context ) { interna( context ); }
	function establecerFichero() {
		return this.ctx.oficial_establecerFichero();
	}
	function agregarCorrespondencia() {
		return this.ctx.oficial_agregarCorrespondencia();
	}
	function quitarCorrespondencia() {
		return this.ctx.oficial_quitarCorrespondencia();
	}
	function enCorrespondencia(campo, valorCampo):Boolean {
		return this.ctx.oficial_enCorrespondencia(campo, valorCampo);
	}
	function marcarActualizable() {
		return this.ctx.oficial_marcarActualizable();
	}
	function actualizarCamposFichero() {
		return this.ctx.oficial_actualizarCamposFichero();
	}
	function actualizarCamposTabla() {
		return this.ctx.oficial_actualizarCamposTabla();
	}
	function actualizarControles() {
		return this.ctx.oficial_actualizarControles();
	}
	function actualizarMuestra() {
		return this.ctx.oficial_actualizarMuestra();
	}
	function borrarFuncion() {
		return this.ctx.oficial_borrarFuncion();
	}
	function borrarValorFijo() {
		return this.ctx.oficial_borrarValorFijo();
	}
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function actualizarCaracterSeparador() {
		return this.ctx.oficial_actualizarCaracterSeparador();
	}
	function buscarCamposFichero() {
		return this.ctx.oficial_buscarCamposFichero();
	}
	function buscarCamposTabla() {
		return this.ctx.oficial_buscarCamposTabla();
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

////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

/** @class_definition interna */
//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////

/** \C
Cuando se crea un nuevo esquema, en primer lugar se escogen el fichero de 
origen de los datos y la tabla FacturaLUX destino de los mismos.  A continuación 
se acepta el formulario y se vuelve a abrir. De este modo aparecerán los listados
de campos tanto en el fichero como en la tabla

El proceso de establecer correspondencias consiste en seleccionar parejas de campos
de fichero/tabla y pulsar el botón añadir correspondencia.

Por defecto se realizará un volcado directo del valor del campo del fichero al
campo de la tabla

Si se rellena la casilla "Valor Fijo" y a continuación se pulsa el botón de añadir
correspondencia, el valor rellenado pasará al campo de la tabla seleccionado para
todos los registros, tal como se aprecia en la vista previa.

Si se rellena la casilla "Función" y a continuación se pulsa el botón de añadir
correspondencia, el resultado de la función pasará al campo de la tabla seleccionado 
para cada registro, tal como se aprecia en la vista previa.

En el listado de correspondencias el valor de la columna "Tipo" indica si se trata
de un campo copiado literalmente, de una función o de un valor fijo.
\end */
function interna_init()
{
	this.iface.actualizarCaracterSeparador();

	var tblCF:FLTableDB = this.child("tblCamposFichero");
	var tblCT:FLTableDB = this.child("tblCamposTabla");
	var tdbCor:FLTableDB = this.child("tdbCor");

	tblCF.setNumCols( 3 );
	tblCF.setColumnWidth( 0, 120 );
	tblCT.setColumnWidth( 1, 150 );
	tblCF.setColumnWidth( 2, 40 );
	tblCF.setColumnLabels( this.iface.sep, "Nombre" + this.iface.sep + "Descripción"  + this.iface.sep + "Pos." );

	tblCT.setNumCols( 2 );
	tblCT.setColumnWidth( 0, 120 );
	tblCT.setColumnWidth( 1, 150 );
	tblCT.setColumnLabels( this.iface.sep, "Nombre" + this.iface.sep + "Descripción" );

	tdbCor.setReadOnly( true );

	this.iface.actualizarCamposFichero();
	this.iface.actualizarCamposTabla();
	this.iface.actualizarControles();
	this.iface.actualizarMuestra();
	
	this.child("fdbIdFuncion").setValue("");
	this.child("fdbDescFuncion").setValue("");

	connect( this.child("pbExaminar"), "clicked()", this, "iface.establecerFichero");
	connect( this.child("pbnAgregar"), "clicked()", this, "iface.agregarCorrespondencia");
	connect( this.child("pbnQuitar"), "clicked()", this, "iface.quitarCorrespondencia");
	connect( this.child("pbnActualizable"), "clicked()", this, "iface.marcarActualizable");
	connect( this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged");

	connect( this.child("lineEditSearchFichero"), "textChanged(QString)", this, "iface.buscarCamposFichero");
	connect( this.child("lineEditSearchTabla"), "textChanged(QString)", this, "iface.buscarCamposTabla");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

/** \D Establece la ruta al fichero de datos y lanza una actualización de la muestra
\end */
function oficial_establecerFichero()
{
	var util:FLUtil = new FLUtil();

	var rutaFich:String = FileDialog.getOpenFileName( util.translate( "scripts", "Texto CSV (*.txt;*.TXT;*.csv;*.CSV)" ), util.translate( "scripts", "Elegir Fichero" ) );
	if (!rutaFich)
		return;

	var F = new File(rutaFich);

	this.child("leFichero").text = F.fullName;

	this.iface.actualizarMuestra();
}

/** \D Agrega al listado de correspondencias el par campo fichero / campo tabla seleccionado en ese momento
y actualiza los listados de ambos
\end */
function oficial_agregarCorrespondencia()
{
	var curCor:FLSqlCursor = this.child( "tdbCor" ).cursor();
	var tblCF:FLTableDB = this.child( "tblCamposFichero" );
	var tblCT:FLTableDB = this.child( "tblCamposTabla" );

	curCor.setModeAccess( curCor.Insert );
	curCor.refreshBuffer();
	curCor.setValueBuffer( "campofichero", tblCF.text( tblCF.currentRow(), 0 ) );
	curCor.setValueBuffer( "campotabla", tblCT.text( tblCT.currentRow(), 0 ) );
	curCor.setValueBuffer( "posicion", tblCF.text( tblCF.currentRow(), 2 ) );

	if ( this.child( "leValorFijo" ).text != "" ) {
		curCor.setValueBuffer( "campofichero", this.child( "leValorFijo" ).text );
		curCor.setValueBuffer( "tipo", "valor" );
		this.iface.borrarValorFijo();
	} else
		if ( this.child( "fdbIdFuncion" ).value() != "" ) {
			curCor.setValueBuffer( "campofichero", this.child( "fdbIdFuncion" ).value() );
			curCor.setValueBuffer( "tipo", "funcion" );
			this.iface.borrarFuncion();
		}

	curCor.commitBuffer();

	this.iface.actualizarCamposFichero();
	this.iface.actualizarCamposTabla();
	this.iface.actualizarControles();
	this.iface.actualizarMuestra();
}

/** \D Elimina la correspondencia seleccionada y restituye los campos implicados
\end */
function oficial_quitarCorrespondencia()
{
	var curCor:FLSqlCursor = this.child( "tdbCor" ).cursor();

	curCor.setModeAccess( curCor.Del );
	curCor.refreshBuffer();
	curCor.commitBuffer();

	this.iface.actualizarCamposFichero();
	this.iface.actualizarCamposTabla();
	this.iface.actualizarControles();
	this.iface.actualizarMuestra();
}

/** \D Indica si un campo tiene ya asociada una correspondencia
@return true si el campo tiene correspondencia, false en otro caso
\end */
function oficial_enCorrespondencia( campo, valorCampo ):Boolean
{
	if ( !campo || campo == "" || !valorCampo || valorCampo == "" )
		return false;

	if ( this.child( "tdbCor" ).cursor().size() == 0 )
		return false;

	var codEsquema:String = this.cursor().valueBuffer( "codesquema" );
	if ( !codEsquema || codEsquema == "" )
		return false;

	var qryCor:FLSqlQuery = new FLSqlQuery();
	qryCor.setTablesList( "impdat_correspondencias" );
	qryCor.setSelect( campo );
	qryCor.setFrom( "impdat_correspondencias" );
	qryCor.setWhere( campo + " = '" + valorCampo + "' AND codesquema = '" + codEsquema + "'" );

	if ( qryCor.exec() )
		if ( qryCor.next() )
			return true;

	return false;
}

function oficial_marcarActualizable()
{
	var curCor:FLSqlCursor = this.child( "tdbCor" ).cursor();

	curCor.setModeAccess( curCor.Edit );
	curCor.refreshBuffer();
	curCor.setValueBuffer( "actualizable", !curCor.valueBuffer("actualizable") );
	curCor.commitBuffer();
}

/** \D Actualiza el listado de campos de fichero con todos salvo aquellos que ya tienen correspondencia
\end */
function oficial_actualizarCamposFichero()
{
	var tblCF:FLTableDB = this.child("tblCamposFichero");
	var codFichero:String = this.cursor().valueBuffer("codfichero");

	var filtro:String = this.child("lineEditSearchFichero").text;
	filtro.replace(/'/g,"''");

	this.setDisabled( true );

	while ( tblCF.numRows() > 0 )
		tblCF.removeRow( 0 );

	if ( !codFichero || codFichero == "" ) {
		this.setDisabled( false );
		return ;
	}

	var qryCampos:FLSqlQuery = new FLSqlQuery();
	qryCampos.setTablesList("impdat_campos");
	qryCampos.setSelect("nombre,descripcion,posicion");
	qryCampos.setFrom("impdat_campos" );
	//qryCampos.setWhere("upper(codfichero) = '" + codFichero.upper() + "' AND (nombre ILIKE '" + filtro + "' OR descripcion ILIKE '" + filtro + "') ORDER BY posicion DESC");
        qryCampos.setWhere("upper(codfichero) = '" + codFichero.upper() + "' ORDER BY posicion DESC");

	if ( qryCampos.exec() ) {
		while ( qryCampos.next() ) {
			if ( !this.iface.enCorrespondencia( "campofichero", qryCampos.value("nombre") ) ) {
				tblCF.insertRows( 0 );
				tblCF.setText( 0, 0, qryCampos.value("nombre") );
				tblCF.setText( 0, 1, qryCampos.value("descripcion") );
				tblCF.setText( 0, 2, qryCampos.value("posicion") );
			}
		}
		tblCF.selectRow( 0 );
	}

	this.setDisabled( false );
}

/** \D Actualiza el listado de campos de tabla con todos salvo aquellos que ya tienen correspondencia
\end */
function oficial_actualizarCamposTabla()
{
	var util:FLUtil = new FLUtil();
	var tblCT:FLTableDB = this.child( "tblCamposTabla" );
	var codTabla:String = this.cursor().valueBuffer( "codtabla" );

	var filtro:String = this.child("lineEditSearchTabla").text;
	filtro.replace(/'/g,"''");

	this.setDisabled( true );

	while ( tblCT.numRows() > 0 )
		tblCT.removeRow( 0 );

	if ( !codTabla || codTabla == "" ) {
		this.setDisabled( false );
		return ;
	}

	var campos = util.nombreCampos( codTabla.lower() );

	if ( campos.length == 0 ) {
		this.setDisabled( false );
		return ;
	}

	var numCampos:Number = parseInt( campos[ 0 ] );
	var i:Number, j:Number = 0;
	var nombre:String, descripcion:String;

	if ( numCampos > 0 ) {
		for ( i = 1; i <= numCampos; i++ ) {
			nombre = campos[i];
			if ( !this.iface.enCorrespondencia( "campotabla", nombre ) ) {
				descripcion = util.fieldNameToAlias(nombre, codTabla.lower());
				if (nombre.upper().find(filtro.upper()) != -1 || descripcion.upper().find(filtro.upper()) != -1) {
					tblCT.insertRows( j );
					tblCT.setText( j, 0, nombre );
					tblCT.setText( j, 1, descripcion );
					j++;
				}
			}
		}
		tblCT.selectRow( 0 );
	}

	this.setDisabled( false );
}


/** \D Actualización general de los controles del formulario: listados de campos de tabla y fichero, y botones
\end */
function oficial_actualizarControles()
{
	var tblCF:FLTableDB = this.child("tblCamposFichero");
	var tblCT:FLTableDB = this.child("tblCamposTabla");
	var tdbCor:FLTableDB = this.child("tdbCor");
	var pbnAgregar:Object = this.child("pbnAgregar");
	var pbnQuitar:Object = this.child("pbnQuitar");
	var pbnActualizable:Object = this.child("pbnActualizable");
	var pbExaminar:Object = this.child("pbExaminar");
	var leValorFijo:Object = this.child("leValorFijo");

	if (this.cursor().modeAccess() == this.cursor().Browse) {
		pbnQuitar.enabled = false;
		pbnAgregar.enabled = false;
		pbnActualizable.enabled = false;
		pbExaminar.enabled = false;
		leValorFijo.enabled = false;
	}
	else {
		if ( tblCF.currentRow() < 0 || tblCT.currentRow() < 0 )
			pbnAgregar.enabled = false;
		else
			pbnAgregar.enabled = true;

		if ( tdbCor.currentRow() < 0 || tdbCor.currentRow() < 0 ) {
			pbnActualizable.enabled = false;
			pbnQuitar.enabled = false;
		}
		else {
			pbnActualizable.enabled = true;
			pbnQuitar.enabled = true;
		}

		pbExaminar.enabled = true;
		leValorFijo.enabled = true;
	}
}

/** \D Lee el fichero de datos y actualiza la tabla de muestra con los datos que aparecen según el esquema actual
\end */
function oficial_actualizarMuestra()
{
	this.iface.actualizarCaracterSeparador();

	var fichero:String = this.child("leFichero").text;
	if ( fichero == "" )
		return ;

	var cursor:FLSqlCursor = this.cursor();
	var numCampos:Number = this.child( "tdbCor" ).cursor().size();
	var tblMuestra:Object = this.child( "tblMuestra" );

	while ( tblMuestra.numRows() > 0 )
		tblMuestra.removeRow( 0 );
	tblMuestra.setNumCols( 0 );
	tblMuestra.setNumCols( numCampos );
	for ( var i = 0; i < numCampos; i++ )
		tblMuestra.setColumnWidth( i, 100 );

	var qryCampos:FLSqlQuery = new FLSqlQuery();
	qryCampos.setTablesList( "impdat_correspondencias" );
	qryCampos.setSelect( "campotabla, campofichero, posicion, tipo" );
	qryCampos.setFrom( "impdat_correspondencias" );
	qryCampos.setWhere( "codesquema = '" + cursor.valueBuffer( "codesquema" ) + "' ORDER BY posicion" );

	if ( !qryCampos.exec() )
		return ;

	if ( !qryCampos.first() )
		return ;

	var util:FLUtil = new FLUtil();
	var codTabla:String = cursor.valueBuffer( "codtabla" );
	var regExp:RegExp = new RegExp( this.iface.sep );
	regExp.global = true;
	
	var labels:String = util.fieldNameToAlias( qryCampos.value( 0 ), codTabla ).replace( regExp, "-" );
	var posiciones:Array = [];
	var camposFichero:Array = [];
	var tipos:Array = [];

	var i:Number = 0;
	camposFichero[ i ] = qryCampos.value( 1 );
	posiciones[ i ] = qryCampos.value( 2 );
	tipos[ i++ ] = qryCampos.value( 3 );

	while ( qryCampos.next() ) {
		labels += " " + this.iface.sep + util.fieldNameToAlias( qryCampos.value( 0 ), codTabla ).replace( regExp, "-" );
		camposFichero[ i ] = qryCampos.value( 1 );
		posiciones[ i ] = qryCampos.value( 2 );
		tipos[ i++ ] = qryCampos.value( 3 );
	}
	tblMuestra.setColumnLabels( this.iface.sep, labels );

	var j:String = 0;
	var filaCampos:Boolean = util.sqlSelect( "impdat_ficheros", "filacampos", "codfichero = '" + cursor.valueBuffer( "codfichero" ) + "'" );
	if ( filaCampos )
		j = 1;
	var lineas:Array = formRecordimpdat_ficheros.iface.pub_leerLineas( fichero, j, j + 5 );
	var linea:Array = [];

	var paso:Number = 0;
	var valor:String;
	for ( i = 0; i < lineas.length; i++ ) {
		paso++;
		tblMuestra.insertRows( i );
		linea = lineas[ i ].split( this.iface.sep );
		for ( j = 0; j < numCampos; j++ ) {
			if ( posiciones[ j ] < linea.length ) {
				valor = flimpdatos.iface.pub_datoCampo( tipos[ j ], camposFichero[ j ],
				                                   linea[ posiciones[ j ] ], linea )
				            tblMuestra.setText( i, j, valor );
			} else
				tblMuestra.setText( i, j, "** POSICION DEL CAMPO FUERA DE RANGO" );
		}
	}
}

function oficial_bufferChanged( fN )
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	switch ( fN ) {
		case "codfichero":
			if (util.sqlSelect("impdat_ficheros", "codfichero", "codfichero = '" + cursor.valueBuffer("codfichero") + "'")) {
				this.iface.actualizarCamposFichero();
				this.iface.actualizarControles();
				this.iface.actualizarMuestra();
			}
		break;
		case "codtabla":
			if (util.sqlSelect("impdat_tablas", "codtabla", "codtabla = '" + cursor.valueBuffer("codtabla") + "'")) {
				this.iface.actualizarCamposTabla();
				this.iface.actualizarControles();
				this.iface.actualizarMuestra();
			}
		break;
		case "idfuncion":
			this.iface.borrarValorFijo();
		break;
	}
}

/** \D Elimina el contenido del cuadro de valor fijo.
\end */
function oficial_borrarValorFijo()
{
	this.child("leValorFijo").text = "";
}

/** \D Elimina el contenido del campo de función.
\end */
function oficial_borrarFuncion()
{
	this.child("fdbIdFuncion").setValue( "" );
}

function oficial_actualizarCaracterSeparador()
{
	var util:FLUtil = new FLUtil();

	var codFichero:String = this.cursor().valueBuffer("codfichero");

	this.iface.sep = util.sqlSelect( "impdat_ficheros", "separador", "codfichero = '" + this.cursor().valueBuffer( "codfichero" ) + "'" );

	if (!this.iface.sep)
		this.iface.sep = ";";
}

function oficial_buscarCamposFichero()
{
	this.iface.actualizarCamposFichero();
	this.child("lineEditSearchFichero").setFocus();
}

function oficial_buscarCamposTabla()
{
	this.iface.actualizarCamposTabla();
	this.child("lineEditSearchTabla").setFocus();
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
