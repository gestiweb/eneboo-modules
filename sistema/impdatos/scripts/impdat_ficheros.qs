/***************************************************************************
                             impdat_ficheros.qs
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
	var ficheroCSV:String;

    function oficial( context ) { interna( context ); }
	function establecerFichero() {
		return this.ctx.oficial_establecerFichero();
	}
	function numeroLineas(fichero):Number {
		return this.ctx.oficial_numeroLineas(fichero);
	}
	function leerLineas(fichero, desde, hasta):Array {
		return this.ctx.oficial_leerLineas(fichero, desde, hasta);
	}
	function actualizarMuestra() {
		return this.ctx.oficial_actualizarMuestra();
	}
	function actualizarCampos() {
		return this.ctx.oficial_actualizarCampos();
	}
	function bufferChanged(fN) {
		return this.ctx.oficial_bufferChanged(fN);
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
	function pub_leerLineas(fichero, desde, hasta):Array {
		return this.leerLineas(fichero, desde, hasta);
	}
	function pub_numeroLineas(fichero):Number {
		return this.numeroLineas( fichero );
	}
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

function interna_init()
{
	connect(this.child("pbExaminar"), "clicked()", this, "iface.establecerFichero");
	connect(this.child("tdbCampos").cursor(), "bufferCommited()", this, "iface.actualizarMuestra");
	connect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged");

	if (this.cursor().valueBuffer("ficherodatos")) {
		this.iface.ficheroCSV = this.cursor().valueBuffer("ficherodatos");
		this.iface.sep = this.cursor().valueBuffer("separador");
	}
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_establecerFichero()
{
	var util:FLUtil = new FLUtil();

	var rutaFich:String = FileDialog.getOpenFileName( util.translate( "scripts", "Texto CSV (*.txt;*.TXT;*.csv;*.CSV)" ), util.translate( "scripts", "Elegir Fichero" ) );
	if (!rutaFich)
		return;

	var F = new File(rutaFich);

	this.child("fdbFicheroDatos").setValue(F.fullName);

	this.iface.ficheroCSV = F.fullName;
	this.iface.actualizarMuestra();
}

/** \D Devuelve el número de líneas de un fichero. Se utiliza para crear
los cuadros de progreso
@return Número de líneas del fichero
\end */
function oficial_numeroLineas(fichero):Number
{
	var util:FLUtil = new FLUtil();

	if ( !File.exists( fichero ) ) {
		MessageBox.warning( util.translate( "scripts", "%1\n\nEl fichero no existe." ).arg( fichero ), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton );
		return 0;
	}

	if ( !File.isFile( fichero ) ) {
		MessageBox.warning( util.translate( "scripts", "%1\n\nNo es un fichero." ).arg( fichero ), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton );
		return 0;
	}

	var file = new File( fichero );

	if ( !file.readable ) {
		MessageBox.warning( util.translate( "scripts", "%1\n\nAcceso de lectura denegado." ).arg( fichero ), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton );
		return 0;
	}

	var lineas:Array = [];

	file.open( File.ReadOnly );
	lineas = file.readLines();
	file.close();

	return lineas.length;
}

/** \D Lee el contenido de un fichero CSV e introduce cada línea como un elemento
de un array de strings. Ignora las líneas que comienzan por '#'
@return Array con el contenido del fichero
\end */
function oficial_leerLineas(fichero, desde, hasta):Array
{
	var lineas:Array = [];

	if ( desde < 0 || hasta < 0 || desde > hasta )
		return lineas;

	var util:FLUtil = new FLUtil();

	if ( !File.exists( fichero ) ) {
		MessageBox.warning( util.translate( "scripts", "%1\n\nEl fichero no existe." ).arg( fichero ), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton );
		return lineas;
	}

	if ( !File.isFile( fichero ) ) {
		MessageBox.warning( util.translate( "scripts", "%1\n\nNo es un fichero." ).arg( fichero ), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton );
		return lineas;
	}

	var file = new File( fichero );

	if ( !file.readable ) {
		MessageBox.warning( util.translate( "scripts", "%1\n\nAcceso de lectura denegado." ).arg( fichero ), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton );
		return lineas;
	}

	var i:Number = 0;
	var j:Number = 0;
	var bufferLinea:String;
	var arrayBuffer = [];

	file.open( File.ReadOnly );
	bufferLinea = file.readLine();
	arrayLinea = bufferLinea.split( this.iface.sep );
	var numCampos:Number = arrayLinea.length;
	file.close();
	
	file.open( File.ReadOnly );

	for ( i = 0; i < desde && !file.eof; i++ )
		file.readLine();

	var regExp:RegExp = new RegExp( "\"" );
	regExp.global = true;
	while ( !file.eof && i <= hasta ) {
	
		contCampos = 0;
		lineas[j] = "";
		
		while (contCampos < numCampos) {
			bufferLinea = file.readLine().replace(regExp, "").replace(",",".");
			if (bufferLinea.left(1) == "#") continue;
			lineas[j] += bufferLinea;
			arrayBuffer = bufferLinea.split(this.iface.sep);
			contCampos += arrayBuffer.length;
		}
		
		i++; j++;
		if (file.eof) continue;
	}
	
	file.close();
	return lineas;
}

/** \D Actualiza la muestra de datos con los contenidos del fichero CSV
\end */
function oficial_actualizarMuestra()
{
	var fichero:String = this.iface.ficheroCSV;
	if ( fichero == "" )
		return ;

	var cursor:FLSqlCursor = this.cursor();
	var numCampos:String = this.child( "tdbCampos" ).cursor().size();
	var tblMuestra:FLTableDB = this.child( "tblMuestra" );

	while ( tblMuestra.numRows() > 0 )
		tblMuestra.removeRow( 0 );
	tblMuestra.setNumCols( 0 );
	tblMuestra.setNumCols( numCampos );
	for ( var i = 0; i < numCampos; i++ )
		tblMuestra.setColumnWidth( i, 100 );

	var qryCampos:FLSqlQuery = new FLSqlQuery();
	qryCampos.setTablesList( "impdat_campos" );
	qryCampos.setSelect( "nombre, posicion" );
	qryCampos.setFrom( "impdat_campos" );
	qryCampos.setWhere( "codfichero = '" + cursor.valueBuffer( "codfichero" ) + "' ORDER BY posicion" );

	if ( !qryCampos.exec() )
		return ;

	if ( !qryCampos.first() )
		return ;

	var regExp:RegExp = new RegExp( this.iface.sep );
	regExp.global = true;
	var labels:String = qryCampos.value( 0 ).replace( regExp, "-" );
	var posiciones:Array = [];
	var i:Number = 0;
	posiciones[ i++ ] = qryCampos.value( 1 );
	while ( qryCampos.next() ) {
		labels += this.iface.sep + qryCampos.value( 0 ).replace( regExp, "-" );
		posiciones[ i++ ] = qryCampos.value( 1 );
	}
	tblMuestra.setColumnLabels( this.iface.sep, labels );

	var j:Number = 0;
	if ( cursor.valueBuffer( "filacampos" ) )
		j = 1;
	var lineas:Array = this.iface.leerLineas( fichero, j, j + 5 );
	var linea:Array = [];

	for ( i = 0; i < lineas.length; i++ ) {
		tblMuestra.insertRows( i );
		linea = lineas[ i ].split( this.iface.sep );
		for ( j = 0; j < numCampos; j++ ) {
			if ( posiciones[ j ] < linea.length )
				tblMuestra.setText( i, j, linea[ posiciones[ j ] ] );
			else
				tblMuestra.setText( i, j, "** POSICION DEL CAMPO FUERA DE RANGO" );
		}
	}
}

/** \D Actualiza el listado de los campos del fichero tras regenerarlos
\end */
function oficial_actualizarCampos() 
{
	var fichero:String = this.iface.ficheroCSV;
	var fdbFilaCampos:Boolean = this.child( "fdbFilaCampos" );

	if ( fichero == "" ) {
		fdbFilaCampos.setValue( false );
		return ;
	}

	var cursor:FLSqlCursor = this.cursor();
	var filaCampos:Boolean = cursor.valueBuffer( "filacampos" );

	if ( filaCampos == false ) {
		this.iface.actualizarMuestra();
		return ;
	}

	var util:FLUtil = new FLUtil();
	var curTdbCampos:FLSqlCursor = this.child( "tdbCampos" ).cursor();

	if ( curTdbCampos.size() > 0 ) {
		var res = MessageBox.warning( util.translate( "scripts", "Si activa esta opción la lista de campos actual será eliminada\ny se generará una nueva con el contenido de la primera fila del fichero.\n\n¿Desea continuar?" ), MessageBox.No, MessageBox.Yes, MessageBox.NoButton );
		if ( res != MessageBox.Yes ) {
			fdbFilaCampos.setValue( false );
			return ;
		}
	}

	this.setDisabled( true );

	var codFichero:String = cursor.valueBuffer( "codfichero" );
	var curCampos:FLSqlCursor = new FLSqlCursor( "impdat_campos" );
	curCampos.select( "codfichero = '" + codFichero + "'" );
	var totalSteps:Number = curCampos.size();

	if ( totalSteps > 0 ) {
		util.createProgressDialog( util.translate( "scripts", "Eliminando campos..." ), totalSteps );
		var step:Number = 0;
		while ( curCampos.next() ) {
			curCampos.setModeAccess( curCampos.Del );
			curCampos.refreshBuffer();
			if ( !curCampos.commitBuffer() )
				break;
			util.setProgress( step++ );
		}
		util.setProgress( totalSteps );
		util.destroyProgressDialog();
	}

	var lineas:Array = this.iface.leerLineas( fichero, 0, 0 );
	if ( lineas.length == 0 ) {
		this.setDisabled( false );
		return ;
	}

	var linea:Array = lineas[0].split( this.iface.sep );

	if ( linea[0].length > 100 ) {
		this.setDisabled( false );
		return ;
	}

	totalSteps = linea.length;

	if ( totalSteps > 1 ) {
		util.createProgressDialog( util.translate( "scripts", "Generando campos..." ), totalSteps );
		step = 0;
		curTdbCampos.setModeAccess( curTdbCampos.Insert );
		curTdbCampos.refreshBuffer();
		curTdbCampos.setValueBuffer( "posicion", 0 );
		curTdbCampos.setValueBuffer( "nombre", linea[ 0 ] );
		curTdbCampos.setValueBuffer( "codfichero", codFichero );
		util.setProgress( step++ );
		if ( curTdbCampos.commitBuffer() ) {
			for ( i = 1; i < totalSteps - 1; i++ ) {
				curCampos.setModeAccess( curCampos.Insert );
				curCampos.refreshBuffer();
				curCampos.setValueBuffer( "posicion", i );
				curCampos.setValueBuffer( "nombre", linea[ i ] );
				curCampos.setValueBuffer( "codfichero", codFichero );
				util.setProgress( step++ );
				if ( !curCampos.commitBuffer() )
					break;
			}
			curTdbCampos.setModeAccess( curTdbCampos.Insert );
			curTdbCampos.refreshBuffer();
			curTdbCampos.setValueBuffer( "posicion", i );
			curTdbCampos.setValueBuffer( "nombre", linea[ i ] );
			curTdbCampos.setValueBuffer( "codfichero", codFichero );
			util.setProgress( step++ );
			curTdbCampos.commitBuffer();
		} else
			fdbFilaCampos.setValue( false );
		util.setProgress( totalSteps );
		util.destroyProgressDialog();
	}

	this.setDisabled( false );
}

function oficial_bufferChanged( fN ) 
{
/** \C Cuando --filacampos-- está marcado, se buscará automáticamente dentro de la
primera fila de texto del fichero en disco los nombres de los campos y se crearán los
registros de campos correspondientes
\end */
	switch ( fN ) {
		case "filacampos":
			if ( this.child("fdbFicheroDatos").value() == "" && this.cursor().valueBuffer("filacampos") == true ) {
				var util:FLUtil = new FLUtil();
				MessageBox.warning( util.translate( "scripts", "Para activar esta opción, primero tiene\nque seleccionar un fichero de muestra.\n" ), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton );
				this.child("fdbFilaCampos").setValue(false);
				return ;
			}
			this.iface.actualizarCampos();
		break;
		case "separador":
			this.iface.sep = this.cursor().valueBuffer("separador");
			this.iface.actualizarCampos();
		break;
	}
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
