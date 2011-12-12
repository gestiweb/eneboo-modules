/***************************************************************************
                 i_mastermodelo303.qs  -  description
                             -------------------
    begin                : jue may 19 2005
    copyright            : (C) 2005 by InfoSiAL S.L.
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
	function presTelematica2009() {
		return this.ctx.oficial_presTelematica2009();
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
	this.child("toolButtonPrint").close();
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
	if (!cursor.isValid()) {
		return;
	}

	var ejercicio:Number = parseFloat(cursor.valueBuffer("fechainicio"));
	var temp:Number = ejercicio.toString().left(4); 
	if (true) {
		this.iface.presTelematica2009();
	}
}

/** \D Genera un fichero para realizar la presentación telemática del modelo para el ejercicio 2007
\end */
function oficial_presTelematica2009()
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

	nombreDato = util.translate("scripts", "Inicio de Id. de modelo y página");
	if ((contenido.length + 1) !=  1) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	contenido += "<T";
	
	nombreDato = util.translate("scripts", "Modelo");
	if ((contenido.length + 1) !=  3) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	contenido += "303";
	
	nombreDato = util.translate("scripts", "Página");
	if ((contenido.length + 1) !=  6) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	contenido += "01";
	
	nombreDato = util.translate("scripts", "Fin de Id. de modelo y página");
	if ((contenido.length + 1) !=  8) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	contenido += ">";
	
	nombreDato = util.translate("scripts", "Indicador de página complementaria");
	if ((contenido.length + 1) !=  9) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	contenido += " ";
	
	nombreDato = util.translate("scripts", "Tipo de declaración");
	if ((contenido.length + 1) !=  10) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	var temp:String = cursor.valueBuffer("idtipodec");
	if (!flcontmode.iface.pub_verificarDato(temp, true, nombreDato, 1)) {
		return false;
	}
	contenido += temp;
	
	nombreDato = util.translate("scripts", "NIF");
	if ((contenido.length + 1) !=  11) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = flcontmode.iface.pub_valorDefectoDatosFiscales("cifnif");
	if (!flcontmode.iface.pub_verificarDato(temp, true, nombreDato, 9))
		return false;
	contenido += temp; 
	
	nombreDato = util.translate("scripts", "Apellidos o razón social");
	if ((contenido.length + 1) !=  20) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	
	if (flcontmode.iface.pub_valorDefectoDatosFiscales("personafisica")) {
		temp = flcontmode.iface.pub_valorDefectoDatosFiscales("apellidospf");
	} else {
		temp = flcontmode.iface.pub_valorDefectoDatosFiscales("apellidosrs");
	}

	if (!flcontmode.iface.pub_verificarDato(temp, true, nombreDato, 30))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 30); 
	
	nombreDato = util.translate("scripts", "Nombre");
	if ((contenido.length + 1) !=  50) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = flcontmode.iface.pub_valorDefectoDatosFiscales("nombrepf");
	if (!flcontmode.iface.pub_verificarDato(temp, false, nombreDato, 15))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 15); 
	
	nombreDato = util.translate("scripts", "Inscrito en Registro de devolución mensual");
	if ((contenido.length + 1) !=  65) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	if (cursor.valueBuffer("inscritoregdev")) {
		temp = "1";
	} else {
		temp = "2";
	}
	contenido += temp;
	
	nombreDato = util.translate("scripts", "Ejercicio");
	if ((contenido.length + 1) !=  66) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("fechainicio");
	contenido += temp.toString().left(4);
	
	nombreDato = util.translate("scripts", "Período");
	if ((contenido.length + 1) !=  70) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	if (cursor.valueBuffer("tipoperiodo") == "Trimestre") {
		temp = cursor.valueBuffer("trimestre");
		if (!flcontmode.iface.pub_verificarDato(temp, true, nombreDato, 2))
			return false;
	} else {
		temp = cursor.valueBuffer("fechainicio");
//		temp = temp.toString().substr(5, 2);
		temp = temp.toString().left(7);
		temp = temp.right(2);
	}
	contenido += temp; 
	
	nombreDato = util.translate("scripts", "Base imponible [01]");
	if ((contenido.length + 1) !=  72) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("baseimponiblerg1");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 15, 2);
	
	nombreDato = util.translate("scripts", "Tipo % [02]");
	if ((contenido.length + 1) !=  89) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("tiporg1");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 3, 2); 
	
	nombreDato = util.translate("scripts", "Cuota [03]");
	if ((contenido.length + 1) !=  94) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("cuotarg1");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 15, 2); 
	
	nombreDato = util.translate("scripts", "Base imponible [04]");
	if ((contenido.length + 1) !=  111) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("baseimponiblerg2");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 15, 2); 
	
	nombreDato = util.translate("scripts", "Tipo % [05]");
	if ((contenido.length + 1) !=  128) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("tiporg2");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 3, 2); 
	
	nombreDato = util.translate("scripts", "Cuota  [06]");
	if ((contenido.length + 1) !=  133) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("cuotarg2");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 15, 2); 
	
	nombreDato = util.translate("scripts", "Base imponible [07]");
	if ((contenido.length + 1) !=  150) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("baseimponiblerg3");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 15, 2); 
	
	nombreDato = util.translate("scripts", "Tipo % [08]");
	if ((contenido.length + 1) !=  167) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("tiporg3");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 3, 2); 
	
	nombreDato = util.translate("scripts", "Cuota [09]");
	if ((contenido.length + 1) !=  172) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("cuotarg3");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 15, 2); 
	
	nombreDato = util.translate("scripts", "Base imponible recargo equivalencia [10]");
	if ((contenido.length + 1) !=  189) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("baseimponiblere1");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 15, 2); 
	
	nombreDato = util.translate("scripts", "Tipo % recargo equivalencia [11]");
	if ((contenido.length + 1) !=  206) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("tipore1");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 3, 2);
	
	nombreDato = util.translate("scripts", "Cuota recargo equivalencia [12]");
	if ((contenido.length + 1) !=  211) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("cuotare1");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 15, 2); 
	
	nombreDato = util.translate("scripts", "Base imponible recargo equivalencia [13]");
	if ((contenido.length + 1) !=  228) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("baseimponiblere2");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 15, 2); 
	
	nombreDato = util.translate("scripts", "Tipo % recargo equivalencia [14]");
	if ((contenido.length + 1) !=  245) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("tipore2");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 3, 2); 
	
	nombreDato = util.translate("scripts", "Cuota recargo equivalencia [15]");
	if ((contenido.length + 1) !=  250) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("cuotare2");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 15, 2); 
	
	nombreDato = util.translate("scripts", "Base imponible recargo equivalencia [16]");
	if ((contenido.length + 1) !=  267) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("baseimponiblere3");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 15, 2); 
	
	nombreDato = util.translate("scripts", "Tipo % recargo equivalencia [17]");
	if ((contenido.length + 1) !=  284) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("tipore3");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 3, 2); 
	
	nombreDato = util.translate("scripts", "Cuota recargo equivalencia [18]");
	if ((contenido.length + 1) !=  289) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("cuotare3");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 15, 2); 
	
	nombreDato = util.translate("scripts", "Base imponible por adquisiciones intracomunitarias [19]");
	if ((contenido.length + 1) !=  306) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("baseimponibleai");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 15, 2); 
	
	nombreDato = util.translate("scripts", "Cuota por adquisiciones intracomunitarias [20]");
	if ((contenido.length + 1) !=  323) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("cuotaai");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 15, 2); 
	
	nombreDato = util.translate("scripts", "IVA Devengado: Cuota total (03 + 06 + 09 + 12 + 15 + 18 + 20) [21]");
	if ((contenido.length + 1) !=  340) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("cuotadevtotal");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 15, 2); 
	
	nombreDato = util.translate("scripts", "IVA deducible por cuotas soportadas en operaciones interiores corrientes. BI [22]");
	if ((contenido.length + 1) !=  357) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("basededoibc");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 15, 2); 
	
	nombreDato = util.translate("scripts", "IVA deducible por cuotas soportadas en operaciones interiores corrientes. Cuota [23]");
	if ((contenido.length + 1) !=  374) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("cuotadedoibc");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 15, 2); 
	
	nombreDato = util.translate("scripts", "IVA deducible por cuotas soportadas en operaciones interiores con bienes de inversión. BI [24]");
	if ((contenido.length + 1) !=  391) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("basededoibi");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 15, 2); 
	
	nombreDato = util.translate("scripts", "IVA deducible por cuotas soportadas en operaciones interiores con bienes de inversión. Cuota [25]");
	if ((contenido.length + 1) !=  408) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("cuotadedoibi");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 15, 2); 
	
	nombreDato = util.translate("scripts", "IVA deducible por cuotas soportadas en las importaciones de bienes corrientes. BI [26]");
	if ((contenido.length + 1) !=  425) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("basededimbc");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 15, 2); 
	
	nombreDato = util.translate("scripts", "IVA deducible por cuotas soportadas en las importaciones de bienes corrientes. Cuota [27]");
	if ((contenido.length + 1) !=  442) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("cuotadedimbc");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 15, 2); 

	nombreDato = util.translate("scripts", "IVA deducible por cuotas soportadas en las importaciones de bienes de inversión. BI [28]");
	if ((contenido.length + 1) !=  459) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("basededimbi");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 15, 2); 
	
	nombreDato = util.translate("scripts", "IVA deducible por cuotas soportadas en las importaciones de bienes de inversión. Cuota [29]");
	if ((contenido.length + 1) !=  476) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("cuotadedimbi");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 15, 2); 
	
	nombreDato = util.translate("scripts", "IVA deducible en adquisiciones intracomunitarias de bienes corrientes. BI [30]");
	if ((contenido.length + 1) !=  493) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("basededaibc");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 15, 2); 
	
	nombreDato = util.translate("scripts", "IVA deducible en adquisiciones intracomunitarias de bienes corrientes. Cuota [31]");
	if ((contenido.length + 1) !=  510) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("cuotadedaibc");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 15, 2); 
	
	nombreDato = util.translate("scripts", "IVA deducible en adquisiciones intracomunitarias de bienes de inversión. BI [32]");
	if ((contenido.length + 1) !=  527) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("basededaibi");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 15, 2); 
	
	nombreDato = util.translate("scripts", "IVA deducible en adquisiciones intracomunitarias de bienes de inversión. Cuota [33]");
	if ((contenido.length + 1) !=  544) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("cuotadedaibi");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 15, 2); 

	nombreDato = util.translate("scripts", "IVA deducible en compensaciones Régimen Especial A.G. y P. [34]");
	if ((contenido.length + 1) !=  561) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("cuotacomre");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 15, 2); 
	
	nombreDato = util.translate("scripts", "IVA deducible: Regularización inversiones [35]");
	if ((contenido.length + 1) !=  578) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("cuotaregin");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 15, 2); 
	
	nombreDato = util.translate("scripts", "IVA deducible: Regularización por aplicación del porcentaje def. de prorrata [36]");
	if ((contenido.length + 1) !=  595) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("cuotaregapli");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 15, 2); 

	nombreDato = util.translate("scripts", "IVA deducible: Total a deducir (?23 + 25 + 27 + 29 + 31 + 33 + 34 + 35 + 36?) [37]");
	if ((contenido.length + 1) !=  612) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("cuotadedtotal");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 15, 2); 

	nombreDato = util.translate("scripts", "Diferencia (21 - 37) [38]");
	if ((contenido.length + 1) !=  629) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("cuotadif");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 15, 2); 

	nombreDato = util.translate("scripts", "Atribuible a la administración del estado - % [39]");
	if ((contenido.length + 1) !=  646) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("porcuotaestado");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 3, 2); 
	
	nombreDato = util.translate("scripts", "Atribuible a la Administración del Estado [40]");
	if ((contenido.length + 1) !=  651) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("cuotaestado");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 15, 2); 
	
	nombreDato = util.translate("scripts", "Cuota a compensar de periodos anteriores [41]");
	if ((contenido.length + 1) !=  668) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("cuotaanterior");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 15, 2); 
	
	nombreDato = util.translate("scripts", "Entregas intracomunitarias [42]");
	if ((contenido.length + 1) !=  685) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("entregasi");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 15, 2); 
	
	nombreDato = util.translate("scripts", "Exportaciones y operaciones asimiladas [43]");
	if ((contenido.length + 1) !=  702) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("exportaciones");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 15, 2); 
	
	nombreDato = util.translate("scripts", "Operaciones no sujetas o con inversión del sujeto pasivo. Derecho a deducción [44]");
	if ((contenido.length + 1) !=  719) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("nosujetas");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 15, 2); 
	
	nombreDato = util.translate("scripts", "Cuota exclusiva para sujetos pasivos que tributan conjuntamente a la Administración del Estado y a las Diputaciones Forales [45]");
	if ((contenido.length + 1) !=  736) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("sujetospasivos");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 15, 2); 
	
	nombreDato = util.translate("scripts", "Resultado (?40 - 41 + 45?) [46]");
	if ((contenido.length + 1) !=  753) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("cuotaresultado");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 15, 2); 
	
	nombreDato = util.translate("scripts", "Importe a deducir [47]");
	if ((contenido.length + 1) !=  770) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("adeducircompl");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 15, 2); 
	
	nombreDato = util.translate("scripts", "Resultado de la liquidación (46 - 47) [48]");
	if ((contenido.length + 1) !=  787) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("resliquid");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 15, 2); 
	
	nombreDato = util.translate("scripts", "Importe a compensar en caso de que la casilla 48 resulte negativa [49]");
	if ((contenido.length + 1) !=  804) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("impcompensar");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 15, 2); 
	
	nombreDato = util.translate("scripts", "Sin actividad");
	if ((contenido.length + 1) !=  821) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	if (cursor.valueBuffer("sinactividad")) {
		temp = "1";
	} else {
		temp = "0";
	}
	contenido += temp;
	
	nombreDato = util.translate("scripts", "Importe a devolver [50]");
	if ((contenido.length + 1) !=  822) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("imported");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 15, 2); 
	
	nombreDato = util.translate("scripts", "Devolución código cuenta cliente - Entidad");
	if ((contenido.length + 1) !=  839) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("ctaentidaddev");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Cuenta de devolución: Entidad "), 4))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 4); 
	
	nombreDato = util.translate("scripts", "Devolución código cuenta cliente - Oficina");
	if ((contenido.length + 1) !=  843) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("ctaagenciadev");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Cuenta de devolución: Oficina "), 4))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 4); 
	
	nombreDato = util.translate("scripts", "Devolución código cuenta cliente - DC");
	if ((contenido.length + 1) !=  847) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("dcdev");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Cuenta de devolución: Dígito de control"), 2))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 2); 
	
	nombreDato = util.translate("scripts", "Devolución código cuenta cliente - Número de cuenta");
	if ((contenido.length + 1) !=  849) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("cuentadev");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Cuenta de devolución: Nº cuenta"), 10))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 10); 

	nombreDato = util.translate("scripts", "Forma de pago");
	if ((contenido.length + 1) !=  859) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("formapago");
	if (temp == "") {
		temp = "0";
	}
	contenido += temp.left(1); 

	nombreDato = util.translate("scripts", "Importe a ingresar [50]");
	if ((contenido.length + 1) !=  860) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("importei");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 15, 2); 

	
	nombreDato = util.translate("scripts", "Ingreso código cuenta cliente - Entidad");
	if ((contenido.length + 1) !=  877) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("ctaentidadingreso");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Cuenta de ingreso: Entidad"), 4))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 4); 

	nombreDato = util.translate("scripts", "Ingreso código cuenta cliente - Oficina");
	if ((contenido.length + 1) !=  881) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("ctaagenciaingreso");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Cuenta de ingreso: Oficina "), 4))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 4); 

	nombreDato = util.translate("scripts", "Ingreso código cuenta cliente - DC");
	if ((contenido.length + 1) !=  885) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("dcingreso");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Cuenta de ingreso: Dígito de control"), 2))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 2); 

	nombreDato = util.translate("scripts", "Ingreso código cuenta cliente - Número de cuenta");
	if ((contenido.length + 1) !=  887) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("cuentaingreso");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Cuenta de ingreso: Nº cuenta"), 10))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 10); 

	nombreDato = util.translate("scripts", "Autoliquidación complementaria");
	if ((contenido.length + 1) !=  897) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	if (cursor.valueBuffer("complementaria")) {
		temp = "1";
	} else {
		temp = "0";
	}
	contenido += temp;
	
	nombreDato = util.translate("scripts", "Numero de justificante de la declaracion anterior");
	if ((contenido.length + 1) !=  898) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("numjustificante");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Numero de justificante de la declaracion anterior"), 13))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 13); 

	nombreDato = util.translate("scripts", "Campo reservado");
	if ((contenido.length + 1) !=  911) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = "";
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 400); 

	nombreDato = util.translate("scripts", "Localidad de la firma");
	if ((contenido.length + 1) !=  1311) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("localidadfirma");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Localidad de la firma"), 16))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 16); 

	nombreDato = util.translate("scripts", "Día de la firma");
	if ((contenido.length + 1) !=  1327) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("fechafirma");
	if (!flcontmode.iface.pub_verificarDato(temp, true, util.translate("scripts", "Fecha firma"), 19))
		return false;
	contenido += flfactppal.iface.pub_cerosIzquierda(temp.getDate(), 2);

	nombreDato = util.translate("scripts", "Mes de la firma");
	if ((contenido.length + 1) !=  1329) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("fechafirma");
	if (!flcontmode.iface.pub_verificarDato(temp, true, util.translate("scripts", "Fecha firma"), 19))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(flcontmode.iface.pub_mesPorIndice(temp.getMonth()), 10);

	nombreDato = util.translate("scripts", "Año de la firma");
	if ((contenido.length + 1) !=  1339) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("fechafirma");
	if (!flcontmode.iface.pub_verificarDato(temp, true, util.translate("scripts", "Fecha firma"), 19))
		return false;
	contenido += flfactppal.iface.pub_cerosIzquierda(temp.getYear(), 4);
	
	nombreDato = util.translate("scripts", "Identificador de Fin de registro");
	if ((contenido.length + 1) != 1343) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	contenido += "</T30301>";
	
	nombreDato = util.translate("scripts", "Fin de registro");
	if ((contenido.length + 1) != 1352) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
// 	temp = "\n";
	temp = String.fromCharCode(13, 10);
	contenido += temp;
	
	file.write(contenido);
	file.close();

	MessageBox.information(util.translate("scripts", "El fichero se ha generado en :\n\n" + nombreFichero + "\n\n"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
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
