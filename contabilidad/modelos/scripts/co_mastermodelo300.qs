/***************************************************************************
                 co_mastermodelo300.qs  -  description
                             -------------------
    begin                : mie mar 11 2009
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
	function oficial( context ) { interna( context ); }
	function lanzar() {
		return this.ctx.oficial_lanzar();
	}
	function presTelematica() {
		return this.ctx.oficial_presTelematica();
	}
	function presTelematica2006() {
		return this.ctx.oficial_presTelematica2006();
	}
	function presTelematica2007() {
		return this.ctx.oficial_presTelematica2007();
	}
	function errorAcumuladoControl(acumuladoControl:Number, nombreDato:String):Boolean {
		return this.ctx.oficial_errorAcumuladoControl(acumuladoControl, nombreDato);
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
function interna_init()
{
	connect (this.child("toolButtonPrint"), "clicked()", this, "iface.lanzar()");
	connect (this.child("toolButtonAeat"), "clicked()", this, "iface.presTelematica()");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Lanza el informe asociado al modelo 300 seleccionado
\end */
function oficial_lanzar()
{
	var cursor:FLSqlCursor = this.cursor();
	var nombreInforme:String = cursor.action();
	flcontmode.iface.pub_lanzar(cursor, nombreInforme, nombreInforme + ".id=" + cursor.valueBuffer( "id" ) );
}

/** \D Genera un fichero para realizar la presentación telemática del modelo
\end */
function oficial_presTelematica()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	if (!cursor.isValid())
		return;
	
	var ejercicio:Number = parseFloat(cursor.valueBuffer("fechainicio"));
	var temp:Number = ejercicio.toString().left(4); 
	if (temp <= 2006)
		this.iface.presTelematica2006();
	else 
		this.iface.presTelematica2007();
}


/** \D Genera un fichero para realizar la presentación telemática del modelo para el ejercicio 2006 y anteriores
\end */
function oficial_presTelematica2006()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	if (!cursor.isValid())
		return;
	
	var nombreFichero:String = FileDialog.getSaveFileName("*.*");
	if (!nombreFichero)
		return;
		
	var file:Object = new File(nombreFichero);
	file.open(File.WriteOnly);

	file.write("300"); // Modelo
	file.write("01"); // Página
	file.write(" "); // Indicador de página complementaria
	file.write(cursor.valueBuffer("idtipodec")); // Tipo de declaración
	
	// Código de administración
	var temp:String = cursor.valueBuffer("codadmon");
	if (!flcontmode.iface.pub_verificarDato(temp, true, util.translate("scripts", "Código de administración"), 5))
		return false;
	file.write(flfactppal.iface.pub_cerosIzquierda(temp, 5)); 
	
	// CIF
	temp = flcontmode.iface.pub_valorDefectoDatosFiscales("cifnif");
	if (!flcontmode.iface.pub_verificarDato(temp, true, util.translate("scripts", "CIF"), 9))
		return false;
	file.write(temp); 
	
	// Letras etiqueta
	temp = flcontmode.iface.pub_valorDefectoDatosFiscales("letraseti");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Letras etiqueta"), 4))
		return false;
	file.write(flfactppal.iface.pub_espaciosDerecha(temp, 4)); 
	
	// Apellidos o razón social
	temp = flcontmode.iface.pub_valorDefectoDatosFiscales("apellidosrs");
	if (!flcontmode.iface.pub_verificarDato(temp, true, util.translate("scripts", "Apellidos o razón social"), 30))
		return false;
	file.write(flfactppal.iface.pub_espaciosDerecha(temp, 30)); 
	
	// Nombre
	temp = flcontmode.iface.pub_valorDefectoDatosFiscales("nombre");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Nombre"), 15))
		return false;
	file.write(flfactppal.iface.pub_espaciosDerecha(temp, 15)); 
	
	// Tipo de vía
	temp = flcontmode.iface.pub_valorDefectoDatosFiscales("codtipovia");
	if (!flcontmode.iface.pub_verificarDato(temp, true, util.translate("scripts", "Tipo de vía"), 2))
		return false;
	file.write(temp); 
	
	// Nombre de vía
	temp = flcontmode.iface.pub_valorDefectoDatosFiscales("nombrevia");
	if (!flcontmode.iface.pub_verificarDato(temp, true, util.translate("scripts", "Nombre de la vía"), 17))
		return false;
	file.write(flfactppal.iface.pub_espaciosDerecha(temp, 17)); 
	
	// Número de la vía
	temp = flcontmode.iface.pub_valorDefectoDatosFiscales("numero");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Número de la vía"), 4))
		return false;
	file.write(flfactppal.iface.pub_espaciosDerecha(temp, 4)); 
	
	// Escalera
	temp = flcontmode.iface.pub_valorDefectoDatosFiscales("escalera");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Escalera"), 2))
		return false;
	file.write(flfactppal.iface.pub_espaciosDerecha(temp, 2)); 
	
	// Piso
	temp = flcontmode.iface.pub_valorDefectoDatosFiscales("piso");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Piso"), 2))
		return false;
	file.write(flfactppal.iface.pub_espaciosDerecha(temp, 2)); 
	
	// Puerta
	temp = flcontmode.iface.pub_valorDefectoDatosFiscales("puerta");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Puerta"), 2))
		return false;
	file.write(flfactppal.iface.pub_espaciosDerecha(temp, 2)); 
	
	// Código postal
	temp = flcontmode.iface.pub_valorDefectoDatosFiscales("codpos");
	if (!flcontmode.iface.pub_verificarDato(temp, true, util.translate("scripts", "Código postal"), 5))
		return false;
	file.write(flfactppal.iface.pub_cerosIzquierda(temp, 5)); 
	
	// Municipio
	temp = flcontmode.iface.pub_valorDefectoDatosFiscales("municipio");
	if (!flcontmode.iface.pub_verificarDato(temp, true, util.translate("scripts", "Municipio"), 20))
		return false;
	file.write(flfactppal.iface.pub_espaciosDerecha(temp, 20)); 
	
	// Provincia
	temp = flcontmode.iface.pub_valorDefectoDatosFiscales("provincia");
	if (!flcontmode.iface.pub_verificarDato(temp, true, util.translate("scripts", "Provincia"), 15))
		return false;
	file.write(flfactppal.iface.pub_espaciosDerecha(temp, 15)); 
	
	// Telefono
	temp = flcontmode.iface.pub_valorDefectoDatosFiscales("telefono");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Teléfono"), 9))
		return false;
	file.write(flfactppal.iface.pub_espaciosDerecha(temp, 9)); 
	
	// Ejercicio
	temp = cursor.valueBuffer("fechainicio");
	file.write(temp.toString().left(4)); 
	
	// Período
	temp = cursor.valueBuffer("periodo");
	if (!flcontmode.iface.pub_verificarDato(temp, true, util.translate("scripts", "Período"), 2))
		return false;
	file.write(temp); 
	
	// Base imponible [01]
	temp = cursor.valueBuffer("baseimponiblerg1");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Tipo % [02]
	temp = cursor.valueBuffer("tiporg1");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 2, 2)); 
	
	// Cuota [03]
	temp = cursor.valueBuffer("cuotarg1");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Base imponible [04]
	temp = cursor.valueBuffer("baseimponiblerg2");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Tipo % [05]
	temp = cursor.valueBuffer("tiporg2");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 2, 2)); 
	
	// Cuota  [06]
	temp = cursor.valueBuffer("cuotarg2");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Base imponible [07]
	temp = cursor.valueBuffer("baseimponiblerg3");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Tipo % [08]
	temp = cursor.valueBuffer("tiporg3");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 2, 2)); 
	
	// Cuota [09]
	temp = cursor.valueBuffer("cuotarg3");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Base imponible recargo equivalencia [10]
	temp = cursor.valueBuffer("baseimponiblere1");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Tipo % recargo equivalencia [11]
	temp = cursor.valueBuffer("tipore1");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 1, 2)); 
	
	// Cuota recargo equivalencia [12]
	temp = cursor.valueBuffer("cuotare1");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Base imponible recargo equivalencia [13]
	temp = cursor.valueBuffer("baseimponiblere2");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Tipo % recargo equivalencia [14]
	temp = cursor.valueBuffer("tipore2");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 1, 2)); 
	
	// Cuota recargo equivalencia [15]
	temp = cursor.valueBuffer("cuotare2");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Base imponible recargo equivalencia [16]
	temp = cursor.valueBuffer("baseimponiblere3");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Tipo % recargo equivalencia [17]
	temp = cursor.valueBuffer("tipore3");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 1, 2)); 
	
	// Cuota recargo equivalencia [18]
	temp = cursor.valueBuffer("cuotare3");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Base imponible por adquisiciones intracomunitarias [19]
	temp = cursor.valueBuffer("baseimponibleai");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Cuota por adquisiciones intracomunitarias [20]
	temp = cursor.valueBuffer("cuotaai");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// IVA Devengado: Cuota total (03 + 06 + 09 + 12 + 15 + 18 + 20) [21]
	temp = cursor.valueBuffer("cuotadevtotal");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// IVA deducible por cuotas soportadas en operaciones interiores [22]
	temp = cursor.valueBuffer("cuotadedoi");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// IVA deducible por cuotas satisfechas en las importaciones [23]
	temp = cursor.valueBuffer("cuotadedim");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// IVA deducible en adquisiciones intracomunitarias [24]
	temp = cursor.valueBuffer("cuotadedai");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// IVA deducible: Cuota por compensaciones en el régimen especial de agricultura, ganadería y pesca [25]
	temp = cursor.valueBuffer("cuotacomre");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// IVA deducible: Cuota por regularización de inversiones [26]
	temp = cursor.valueBuffer("cuotaregin");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// IVA deducible: Total a deducir (22 + 23 + 24 + 25 + 26) [27]
	temp = cursor.valueBuffer("cuotadedtotal");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Diferencia (27 - 21) [28]
	temp = cursor.valueBuffer("cuotadif");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Porcentaje atribuible a la administración del estado [29]
	temp = cursor.valueBuffer("porcuotaestado");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 2, 2)); 
	
	// Cuota atribuible a la administración del estado (30 x 29) [30]
	temp = cursor.valueBuffer("cuotaestado");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Cuota por compensación de ejercicios anteriores [31]
	temp = cursor.valueBuffer("cuotaanterior");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Cuota por entregas intracomunitarias [32]
	temp = cursor.valueBuffer("entregasi");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Cuota exclusiva para sujetos pasivos que tributan conjuntamente a la administración del estado y a las Diplomaturas Formales. Resultado de la Regularización anual [33]
	temp = cursor.valueBuffer("sujetospasivos");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Resultado (30 - 31 + 33) [34]
	temp = cursor.valueBuffer("cuotaresultado");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Importe a compensar en caso de que la casilla 34 resulte negativa [34][C]
	temp = cursor.valueBuffer("impcompensar");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Importe a devolver [D]
	temp = cursor.valueBuffer("imported");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Devolución código cuenta cliente - entidad
	temp = cursor.valueBuffer("ctaentidaddev");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Cuenta de devolución: Entidad"), 4))
		return false;
	file.write(flfactppal.iface.pub_espaciosDerecha(temp, 4)); 
	
	// Devolución código cuenta cliente - Oficina
	temp = cursor.valueBuffer("ctaagenciadev");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Cuenta de devolución: Oficina "), 4))
		return false;
	file.write(flfactppal.iface.pub_espaciosDerecha(temp, 4)); 
	
	// Devolución código cuenta cliente - DC
	temp = cursor.valueBuffer("dcdev");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Cuenta de devolución: Dígito de control"), 2))
		return false;
	file.write(flfactppal.iface.pub_espaciosDerecha(temp, 2)); 
	
	// Devolución código cuenta cliente - Número de cuenta
	temp = cursor.valueBuffer("cuentadev");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Cuenta de devolución: Nº cuenta"), 10))
		return false;
	file.write(flfactppal.iface.pub_espaciosDerecha(temp, 10)); 
	
	// Forma de pago - en efectivo
	if (cursor.valueBuffer("pagoefectivo"))
		temp = "X";
	else
		temp = " ";
	file.write(temp); 
	
	// Forma de pago - adeudo en cuenta
	if (cursor.valueBuffer("pagocuenta"))
		temp = "X";
	else
		temp = " ";
	file.write(temp); 
	
	// Importe a ingresar [I]
	temp = cursor.valueBuffer("importei");
	file.write(flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2)); 
	
	// Ingreso código cuenta cliente - entidad
	temp = cursor.valueBuffer("ctaentidadingreso");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Cuenta de ingreso: Entidad"), 4))
		return false;
	file.write(flfactppal.iface.pub_espaciosDerecha(temp, 4)); 
	
	// Ingreso código cuenta cliente - Oficina
	temp = cursor.valueBuffer("ctaagenciaingreso");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Cuenta de ingreso: Oficina "), 4))
		return false;
	file.write(flfactppal.iface.pub_espaciosDerecha(temp, 4)); 
	
	// Ingreso código cuenta cliente - DC
	temp = cursor.valueBuffer("dcingreso");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Cuenta de ingreso: Dígito de control"), 2))
		return false;
	file.write(flfactppal.iface.pub_espaciosDerecha(temp, 2)); 
	
	// Ingreso código cuenta cliente - Número de cuenta
	temp = cursor.valueBuffer("cuentaingreso");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Cuenta de ingreso: Nº cuenta"), 10))
		return false;
	file.write(flfactppal.iface.pub_espaciosDerecha(temp, 10)); 
	
	// Persona de contacto
	temp = cursor.valueBuffer("personacontacto");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Persona de contacto"), 100))
		return false;
	file.write(flfactppal.iface.pub_espaciosDerecha(temp, 100)); 
	
	// Telefono
	temp = cursor.valueBuffer("telefono");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Telefono de contacto"), 9))
		return false;
	file.write(flfactppal.iface.pub_espaciosDerecha(temp, 9)); 
	
	// Observaciones
	temp = cursor.valueBuffer("observaciones");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Observaciones"), 350))
		return false;
	file.write(flfactppal.iface.pub_espaciosDerecha(temp, 350)); 
	
	// Fecha de la firma
	temp = cursor.valueBuffer("fechafirma");
	if (!flcontmode.iface.pub_verificarDato(temp, true, util.translate("scripts", "Fecha firma"), 19))
		return false;
	file.write(flfactppal.iface.pub_cerosIzquierda(temp.getDate(), 2));
	file.write(flfactppal.iface.pub_espaciosDerecha(flcontmode.iface.pub_mesPorIndice(temp.getMonth()), 10));
	file.write(flfactppal.iface.pub_cerosIzquierda(temp.getYear(), 4));
	
	// Fin de registro
	temp = "\n";
	file.write(temp);
	
	file.close();

	MessageBox.information(util.translate("scripts", "Generado fichero en :\n\n" + nombreFichero + "\n\n"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
}

/** \D Genera un fichero para realizar la presentación telemática del modelo para el ejercicio 2007
\end */
function oficial_presTelematica2007()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	if (!cursor.isValid())
		return;
	
	var nombreFichero:String = FileDialog.getSaveFileName("*.*");
	if (!nombreFichero)
		return;
		
	var acumuladoControl:Number = 1;
	var nombreDato:String;
	var contenido:String = "";
	var file:Object = new File(nombreFichero);
	file.open(File.WriteOnly);

	nombreDato = util.translate("scripts", "Modelo");
	if ((contenido.length + 1) !=  1) {
		return this.iface.errorAcumuladoControl(1, nombreDato);
	}
	contenido += "300";
	
	nombreDato = util.translate("scripts", "Página");
	if ((contenido.length + 1) !=  4) {
		return this.iface.errorAcumuladoControl(4, nombreDato);
	}
	contenido += "01";
	
	nombreDato = util.translate("scripts", "Indicador de página complementaria");
	if ((contenido.length + 1) !=  6) {
		return this.iface.errorAcumuladoControl(6, nombreDato);
	}
	contenido += " ";
	
	nombreDato = util.translate("scripts", "Tipo de declaración");
	if ((contenido.length + 1) !=  7) {
		return this.iface.errorAcumuladoControl(7, nombreDato);
	}
	var temp:String = cursor.valueBuffer("idtipodec");
	if (!flcontmode.iface.pub_verificarDato(temp, true, nombreDato, 1))
		return false;
	contenido += temp;
	
	nombreDato = util.translate("scripts", "Código de administración");
	if ((contenido.length + 1) !=  8) {
		return this.iface.errorAcumuladoControl(8, nombreDato);
	}
	var temp:String = cursor.valueBuffer("codadmon");
	if (!flcontmode.iface.pub_verificarDato(temp, true, nombreDato, 5))
		return false;
	contenido += flfactppal.iface.pub_cerosIzquierda(temp, 5); 
	
	nombreDato = util.translate("scripts", "NIF");
	if ((contenido.length + 1) !=  13) {
		return this.iface.errorAcumuladoControl(13, nombreDato);
	}
	temp = flcontmode.iface.pub_valorDefectoDatosFiscales("cifnif");
	if (!flcontmode.iface.pub_verificarDato(temp, true, nombreDato, 9))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 9);
	
	nombreDato = util.translate("scripts", "Comienzo primer apellido en personas físicas");
	if ((contenido.length + 1) !=  22) {
		return this.iface.errorAcumuladoControl(22, nombreDato);
	}
	temp = flcontmode.iface.pub_valorDefectoDatosFiscales("apellidosrs");
	temp = temp.left(4);
	if (!flcontmode.iface.pub_verificarDato(temp, false, nombreDato, 4))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 4); 
	
	nombreDato = util.translate("scripts", "Apellidos o razón social");
	if ((contenido.length + 1) !=  26) {
		return this.iface.errorAcumuladoControl(26, nombreDato);
	}
	temp = flcontmode.iface.pub_valorDefectoDatosFiscales("apellidosrs");
	if (!flcontmode.iface.pub_verificarDato(temp, true, nombreDato, 30))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 30); 
	
	nombreDato = util.translate("scripts", "Nombre");
	if ((contenido.length + 1) !=  56) {
		return this.iface.errorAcumuladoControl(56, nombreDato);
	}
	temp = flcontmode.iface.pub_valorDefectoDatosFiscales("nombre");
	if (!flcontmode.iface.pub_verificarDato(temp, false, nombreDato, 15))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 15); 
	
	nombreDato = util.translate("scripts", "Ejercicio");
	if ((contenido.length + 1) !=  71) {
		return this.iface.errorAcumuladoControl(71, nombreDato);
	}
	temp = cursor.valueBuffer("fechainicio");
	contenido += temp.toString().left(4);
	
	nombreDato = util.translate("scripts", "Período");
	if ((contenido.length + 1) !=  75) {
		return this.iface.errorAcumuladoControl(75, nombreDato);
	}
	temp = cursor.valueBuffer("periodo");
	if (!flcontmode.iface.pub_verificarDato(temp, true, nombreDato, 2))
		return false;
	contenido += temp; 
	
	nombreDato = util.translate("scripts", "Base imponible [01]");
	if ((contenido.length + 1) !=  77) {
		return this.iface.errorAcumuladoControl(77, nombreDato);
	}
	temp = cursor.valueBuffer("baseimponiblerg1");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2);
	
	nombreDato = util.translate("scripts", "Tipo % [02]");
	if ((contenido.length + 1) !=  90) {
		return this.iface.errorAcumuladoControl(90, nombreDato);
	}
	temp = cursor.valueBuffer("tiporg1");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 2, 2); 
	
	nombreDato = util.translate("scripts", "Cuota [03]");
	if ((contenido.length + 1) !=  94) {
		return this.iface.errorAcumuladoControl(94, nombreDato);
	}
	temp = cursor.valueBuffer("cuotarg1");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2); 
	
	nombreDato = util.translate("scripts", "Base imponible [04]");
	if ((contenido.length + 1) !=  107) {
		return this.iface.errorAcumuladoControl(107, nombreDato);
	}
	temp = cursor.valueBuffer("baseimponiblerg2");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2); 
	
	nombreDato = util.translate("scripts", "Tipo % [05]");
	if ((contenido.length + 1) !=  120) {
		return this.iface.errorAcumuladoControl(120, nombreDato);
	}
	temp = cursor.valueBuffer("tiporg2");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 2, 2); 
	
	nombreDato = util.translate("scripts", "Cuota  [06]");
	if ((contenido.length + 1) !=  124) {
		return this.iface.errorAcumuladoControl(124, nombreDato);
	}
	temp = cursor.valueBuffer("cuotarg2");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2); 
	
	nombreDato = util.translate("scripts", "Base imponible [07]");
	if ((contenido.length + 1) !=  137) {
		return this.iface.errorAcumuladoControl(137, nombreDato);
	}
	temp = cursor.valueBuffer("baseimponiblerg3");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2); 
	
	nombreDato = util.translate("scripts", "Tipo % [08]");
	if ((contenido.length + 1) !=  150) {
		return this.iface.errorAcumuladoControl(150, nombreDato);
	}
	temp = cursor.valueBuffer("tiporg3");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 2, 2); 
	
	nombreDato = util.translate("scripts", "Cuota [09]");
	if ((contenido.length + 1) !=  154) {
		return this.iface.errorAcumuladoControl(154, nombreDato);
	}
	temp = cursor.valueBuffer("cuotarg3");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2); 
	
	nombreDato = util.translate("scripts", "Base imponible recargo equivalencia [10]");
	if ((contenido.length + 1) !=  167) {
		return this.iface.errorAcumuladoControl(167, nombreDato);
	}
	temp = cursor.valueBuffer("baseimponiblere1");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2); 
	
	nombreDato = util.translate("scripts", "Tipo % recargo equivalencia [11]");
	if ((contenido.length + 1) !=  180) {
		return this.iface.errorAcumuladoControl(180, nombreDato);
	}
	temp = cursor.valueBuffer("tipore1");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 1, 2);
	
	nombreDato = util.translate("scripts", "Cuota recargo equivalencia [12]");
	if ((contenido.length + 1) !=  183) {
		return this.iface.errorAcumuladoControl(183, nombreDato);
	}
	temp = cursor.valueBuffer("cuotare1");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2); 
	
	nombreDato = util.translate("scripts", "Base imponible recargo equivalencia [13]");
	if ((contenido.length + 1) !=  196) {
		return this.iface.errorAcumuladoControl(196, nombreDato);
	}
	temp = cursor.valueBuffer("baseimponiblere2");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2); 
	
	nombreDato = util.translate("scripts", "Tipo % recargo equivalencia [14]");
	if ((contenido.length + 1) !=  209) {
		return this.iface.errorAcumuladoControl(209, nombreDato);
	}
	temp = cursor.valueBuffer("tipore2");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 1, 2); 
	
	nombreDato = util.translate("scripts", "Cuota recargo equivalencia [15]");
	if ((contenido.length + 1) !=  212) {
		return this.iface.errorAcumuladoControl(212, nombreDato);
	}
	temp = cursor.valueBuffer("cuotare2");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2); 
	
	nombreDato = util.translate("scripts", "Base imponible recargo equivalencia [16]");
	if ((contenido.length + 1) !=  225) {
		return this.iface.errorAcumuladoControl(255, nombreDato);
	}
	temp = cursor.valueBuffer("baseimponiblere3");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2); 
	
	nombreDato = util.translate("scripts", "Tipo % recargo equivalencia [17]");
	if ((contenido.length + 1) !=  238) {
		return this.iface.errorAcumuladoControl(238, nombreDato);
	}
	temp = cursor.valueBuffer("tipore3");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 1, 2); 
	
	nombreDato = util.translate("scripts", "Cuota recargo equivalencia [18]");
	if ((contenido.length + 1) !=  241) {
		return this.iface.errorAcumuladoControl(241, nombreDato);
	}
	temp = cursor.valueBuffer("cuotare3");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2); 
	
	nombreDato = util.translate("scripts", "Base imponible por adquisiciones intracomunitarias [19]");
	if ((contenido.length + 1) !=  254) {
		return this.iface.errorAcumuladoControl(254, nombreDato);
	}
	temp = cursor.valueBuffer("baseimponibleai");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2); 
	
	nombreDato = util.translate("scripts", "Cuota por adquisiciones intracomunitarias [20]");
	if ((contenido.length + 1) !=  267) {
		return this.iface.errorAcumuladoControl(267, nombreDato);
	}
	temp = cursor.valueBuffer("cuotaai");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2); 
	
	nombreDato = util.translate("scripts", "IVA Devengado: Cuota total (03 + 06 + 09 + 12 + 15 + 18 + 20) [21]");
	if ((contenido.length + 1) !=  280) {
		return this.iface.errorAcumuladoControl(280, nombreDato);
	}
	temp = cursor.valueBuffer("cuotadevtotal");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2); 
	
	nombreDato = util.translate("scripts", "IVA deducible por cuotas soportadas en operaciones interiores [22]");
	if ((contenido.length + 1) !=  293) {
		return this.iface.errorAcumuladoControl(293, nombreDato);
	}
	temp = cursor.valueBuffer("cuotadedoi");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2); 
	
	nombreDato = util.translate("scripts", "IVA deducible por cuotas satisfechas en las importaciones [23]");
	if ((contenido.length + 1) !=  306) {
		return this.iface.errorAcumuladoControl(306, nombreDato);
	}
	temp = cursor.valueBuffer("cuotadedim");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2); 
	
	nombreDato = util.translate("scripts", "IVA deducible en adquisiciones intracomunitarias [24]");
	if ((contenido.length + 1) !=  319) {
		return this.iface.errorAcumuladoControl(319, nombreDato);
	}
	temp = cursor.valueBuffer("cuotadedai");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2); 
	
	nombreDato = util.translate("scripts", "IVA deducible: Cuota por compensaciones en el régimen especial de agricultura, ganadería y pesca [25]");
	if ((contenido.length + 1) !=  332) {
		return this.iface.errorAcumuladoControl(332, nombreDato);
	}
	temp = cursor.valueBuffer("cuotacomre");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2); 
	
	nombreDato = util.translate("scripts", "IVA deducible: Cuota por regularización de inversiones [26]");
	if ((contenido.length + 1) !=  345) {
		return this.iface.errorAcumuladoControl(345, nombreDato);
	}
	temp = cursor.valueBuffer("cuotaregin");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2); 
	
	nombreDato = util.translate("scripts", "IVA deducible: Regularización por aplicación del porcentaje def. de prorrata [27]");
	if ((contenido.length + 1) !=  358) {
		return this.iface.errorAcumuladoControl(358, nombreDato);
	}
	temp = cursor.valueBuffer("cuotaregapli");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2); 

	nombreDato = util.translate("scripts", "IVA deducible: Total a deducir (22 + 23 + 24 + 25 + 26 + 27 ) [28]");
	if ((contenido.length + 1) !=  371) {
		return this.iface.errorAcumuladoControl(371, nombreDato);
	}
	temp = cursor.valueBuffer("cuotadedtotal");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2); 
	
	nombreDato = util.translate("scripts", "Diferencia (21 - 28) [29]");
	if ((contenido.length + 1) !=  384) {
		return this.iface.errorAcumuladoControl(384, nombreDato);
	}
	temp = cursor.valueBuffer("cuotadif");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2); 
	
	nombreDato = util.translate("scripts", "Porcentaje atribuible a la administración del estado [30]");
	if ((contenido.length + 1) !=  397) {
		return this.iface.errorAcumuladoControl(397, nombreDato);
	}
	temp = cursor.valueBuffer("porcuotaestado");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 3, 2); 
	
	nombreDato = util.translate("scripts", "Cuota atribuible a la administración del estado [31]");
	if ((contenido.length + 1) !=  402) {
		return this.iface.errorAcumuladoControl(402, nombreDato);
	}
	temp = cursor.valueBuffer("cuotaestado");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2); 
	
	nombreDato = util.translate("scripts", "Cuota por compensación de ejercicios anteriores [32]");
	if ((contenido.length + 1) !=  415) {
		return this.iface.errorAcumuladoControl(415, nombreDato);
	}
	temp = cursor.valueBuffer("cuotaanterior");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2); 
	
	nombreDato = util.translate("scripts", "Cuota por entregas intracomunitarias [33]");
	if ((contenido.length + 1) !=  428) {
		return this.iface.errorAcumuladoControl(428, nombreDato);
	}
	temp = cursor.valueBuffer("entregasi");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2); 

	nombreDato = util.translate("scripts", "Cuota Cuota exclusiva para sujetos pasivos que tributan conjuntamente a la administración del estado y a las Diplomaturas Formales. Resultado de la Regularización anual [34]");
	if ((contenido.length + 1) !=  441) {
		return this.iface.errorAcumuladoControl(441, nombreDato);
	}
	temp = cursor.valueBuffer("sujetospasivos");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2); 
	
	nombreDato = util.translate("scripts", "Resultado (31 - 32 + 34) [35]");
	if ((contenido.length + 1) !=  454) {
		return this.iface.errorAcumuladoControl(454, nombreDato);
	}
	temp = cursor.valueBuffer("cuotaresultado");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2); 
	
	nombreDato = util.translate("scripts", "A deducir (exclusivamente en caso de declaración complementaria): Resultado de la anterior o anteriores declaraciones del mismo concepto, ejercicio y periodo [36]");
	if ((contenido.length + 1) !=  467) {
		return this.iface.errorAcumuladoControl(467, nombreDato);
	}
	temp = cursor.valueBuffer("adeducircompl");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2); 

	nombreDato = util.translate("scripts", "Resultado de la liquidación (35 - 36) [37]");
	if ((contenido.length + 1) !=  480) {
		return this.iface.errorAcumuladoControl(480, nombreDato);
	}
	temp = cursor.valueBuffer("resliquid");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2); 

	nombreDato = util.translate("scripts", "Importe a compensar en caso de que la casilla 37 resulte negativa [37] [C]");
	if ((contenido.length + 1) !=  493) {
		return this.iface.errorAcumuladoControl(493, nombreDato);
	}
	temp = cursor.valueBuffer("impcompensar");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2); 

	nombreDato = util.translate("scripts", "Importe a devolver [37] [D]");
	if ((contenido.length + 1) !=  506) {
		return this.iface.errorAcumuladoControl(506, nombreDato);
	}
	temp = cursor.valueBuffer("imported");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2); 
	
	nombreDato = util.translate("scripts", "Devolución código cuenta cliente - entidad");
	if ((contenido.length + 1) !=  519) {
		return this.iface.errorAcumuladoControl(519, nombreDato);
	}
	temp = cursor.valueBuffer("ctaentidaddev");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Cuenta de devolución: Entidad"), 4))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 4); 
	
	nombreDato = util.translate("scripts", "Devolución código cuenta cliente - Oficina");
	if ((contenido.length + 1) !=  523) {
		return this.iface.errorAcumuladoControl(523, nombreDato);
	}
	temp = cursor.valueBuffer("ctaagenciadev");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Cuenta de devolución: Oficina "), 4))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 4); 
	
	nombreDato = util.translate("scripts", "Devolución código cuenta cliente - DC");
	if ((contenido.length + 1) !=  527) {
		return this.iface.errorAcumuladoControl(527, nombreDato);
	}
	temp = cursor.valueBuffer("dcdev");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Cuenta de devolución: Dígito de control"), 2))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 2); 
	
	nombreDato = util.translate("scripts", "Devolución código cuenta cliente - Número de cuenta");
	if ((contenido.length + 1) !=  529) {
		return this.iface.errorAcumuladoControl(529, nombreDato);
	}
	temp = cursor.valueBuffer("cuentadev");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Cuenta de devolución: Nº cuenta"), 10))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 10); 

	nombreDato = util.translate("scripts", "Forma de pago");
	if ((contenido.length + 1) !=  539) {
		return this.iface.errorAcumuladoControl(539, nombreDato);
	}
	if (cursor.valueBuffer("pagoefectivo"))
			temp = 1;
	else if (cursor.valueBuffer("pagocuenta"))
		temp = 2;
	else
		temp = 0;
	contenido += temp; 

	nombreDato = util.translate("scripts", "Importe a ingresar [I]");
	if ((contenido.length + 1) !=  540) {
		return this.iface.errorAcumuladoControl(540, nombreDato);
	}
	temp = cursor.valueBuffer("importei");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 11, 2); 

	
	nombreDato = util.translate("scripts", "Ingreso código cuenta cliente - Entidad");
	if ((contenido.length + 1) !=  553) {
		return this.iface.errorAcumuladoControl(553, nombreDato);
	}
	temp = cursor.valueBuffer("ctaentidadingreso");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Cuenta de ingreso: Entidad"), 4))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 4); 

	nombreDato = util.translate("scripts", "Ingreso código cuenta cliente - Oficina");
	if ((contenido.length + 1) !=  557) {
		return this.iface.errorAcumuladoControl(557, nombreDato);
	}
	temp = cursor.valueBuffer("ctaagenciaingreso");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Cuenta de ingreso: Oficina "), 4))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 4); 

	nombreDato = util.translate("scripts", "Ingreso código cuenta cliente - DC");
	if ((contenido.length + 1) !=  561) {
		return this.iface.errorAcumuladoControl(561, nombreDato);
	}
	temp = cursor.valueBuffer("dcingreso");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Cuenta de ingreso: Dígito de control"), 2))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 2); 

	nombreDato = util.translate("scripts", "Ingreso código cuenta cliente - Número de cuenta");
	if ((contenido.length + 1) !=  563) {
		return this.iface.errorAcumuladoControl(563, nombreDato);
	}
	temp = cursor.valueBuffer("cuentaingreso");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Cuenta de ingreso: Nº cuenta"), 10))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 10); 

	nombreDato = util.translate("scripts", "Código electrónico de la declaración anterior");
	if ((contenido.length + 1) !=  573) {
		return this.iface.errorAcumuladoControl(573, nombreDato);
	}
	temp = cursor.valueBuffer("codanterior");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Código electrónico de la declaración anterior"), 16))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 16); 

	nombreDato = util.translate("scripts", "Numero de justificante de la declaracion anterior");
	if ((contenido.length + 1) !=  589) {
		return this.iface.errorAcumuladoControl(589, nombreDato);
	}
	temp = cursor.valueBuffer("numjustificante");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Numero de justificante de la declaracion anterior"), 13))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 13); 

	nombreDato = util.translate("scripts", "Persona de contacto");
	if ((contenido.length + 1) !=  602) {
		return this.iface.errorAcumuladoControl(602, nombreDato);
	}
	temp = cursor.valueBuffer("personacontacto");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Persona de contacto"), 100))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 100); 

	nombreDato = util.translate("scripts", "Telefono");
	if ((contenido.length + 1) !=  702) {
		return this.iface.errorAcumuladoControl(702, nombreDato);
	}
	temp = cursor.valueBuffer("telefono");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Telefono de contacto"), 9))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 9); 
	
	nombreDato = util.translate("scripts", "Observaciones");
	if ((contenido.length + 1) !=  711) {
		return this.iface.errorAcumuladoControl(711, nombreDato);
	}
	temp = cursor.valueBuffer("observaciones");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Observaciones"), 350))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 350); 
	
	nombreDato = util.translate("scripts", "Localidad de la firma");
	if ((contenido.length + 1) !=  1061) {
		return this.iface.errorAcumuladoControl(1061, nombreDato);
	}
	temp = cursor.valueBuffer("localidadfirma");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Localidad de la firma"), 16))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 16); 

	nombreDato = util.translate("scripts", "Día de la firma");
	if ((contenido.length + 1) !=  1077) {
		return this.iface.errorAcumuladoControl(1077, nombreDato);
	}
	temp = cursor.valueBuffer("fechafirma");
	if (!flcontmode.iface.pub_verificarDato(temp, true, util.translate("scripts", "Fecha firma"), 19))
		return false;
	contenido += flfactppal.iface.pub_cerosIzquierda(temp.getDate(), 2);

	nombreDato = util.translate("scripts", "Mes de la firma");
	if ((contenido.length + 1) !=  1079) {
		return this.iface.errorAcumuladoControl(1079, nombreDato);
	}
	temp = cursor.valueBuffer("fechafirma");
	if (!flcontmode.iface.pub_verificarDato(temp, true, util.translate("scripts", "Fecha firma"), 19))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(flcontmode.iface.pub_mesPorIndice(temp.getMonth()), 10);

	nombreDato = util.translate("scripts", "Año de la firma");
	if ((contenido.length + 1) !=  1089) {
		return this.iface.errorAcumuladoControl(1089, nombreDato);
	}
	temp = cursor.valueBuffer("fechafirma");
	if (!flcontmode.iface.pub_verificarDato(temp, true, util.translate("scripts", "Fecha firma"), 19))
		return false;
	contenido += flfactppal.iface.pub_cerosIzquierda(temp.getYear(), 4);
	
	nombreDato = util.translate("scripts", "Fin de registro");
	if ((contenido.length + 1) !=  1093) {
		return this.iface.errorAcumuladoControl(1093, nombreDato);
	}
	temp = "\n";
	contenido += temp;
	
	file.write(contenido);
	file.close();

	MessageBox.information(util.translate("scripts", "Generado fichero en :\n\n" + nombreFichero + "\n\n"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
}

function oficial_errorAcumuladoControl(acumuladoControl:Number, nombreDato:String):Boolean
{
	var util:FLUtil = new FLUtil;
	MessageBox.warning(util.translate("scripts", "Error al crear el fichero: El dato %1 no comienza en la posición %2").arg(nombreDato).arg(acumuladoControl), MessageBox.Ok, MessageBox.NoButton);
	return false;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////

//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
