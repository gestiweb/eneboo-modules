/***************************************************************************
                 co_modelo390.qs  -  description
                             -------------------
    begin                : mon may 16 2005
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var numPagina_:Number;

	function oficial( context ) { interna( context ); }
	function listaAsientosReg():String {
		return this.ctx.oficial_listaAsientosReg();
	}
	function lanzar(cursor:FLSqlCursor, nombreInforme:String, masWhere:String, nombreReport:String) {
		return this.ctx.oficial_lanzar(cursor, nombreInforme, masWhere, nombreReport);
	}
	function obtenerSigno(s:String):String {
		return this.ctx.oficial_obtenerSigno(s);
	}
	function fieldName(s:String):String {
		return this.ctx.oficial_fieldName(s);
	}
	function valorDefectoDatosFiscales(fN:String):String {
		return this.ctx.oficial_valorDefectoDatosFiscales(fN);
	}
	function valoresIniciales(){
		this.ctx.oficial_valoresIniciales();
	}
	function informarTiposVia() {
		this.ctx.oficial_informarTiposVia();
	}
	function verificarDato(valor:String, requerido:Boolean, nombre:String, maxLon:Number):Boolean {
		return this.ctx.oficial_verificarDato(valor, requerido, nombre, maxLon);
	}
	function formatoNumero(valor:Number, enteros:Number, decimales:Number):String {
		return this.ctx.oficial_formatoNumero(valor, enteros, decimales);
	}
	function mesPorIndice(indice:Number):String {
		return this.ctx.oficial_mesPorIndice(indice);
	}
	function iniciarPagina(nodo:FLDomNode,campo:String):String {
		return this.ctx.oficial_iniciarPagina(nodo, campo);
	}
	function numPagina(nodo:FLDomNode,campo:String):String {
		return this.ctx.oficial_numPagina(nodo, campo);
	}
	function controlCaracteres(valor:String):String {
		return this.ctx.oficial_controlCaracteres(valor);
	}
	function formatearTexto(texto:String):String {
		return this.ctx.oficial_formatearTexto(texto);
	}
	function limpiarCifNif(cifNif:String):String {
		return this.ctx.oficial_limpiarCifNif(cifNif); 
	}
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration modelo340 */
/////////////////////////////////////////////////////////////////
//// MODELO 340 /////////////////////////////////////////////////
class modelo340 extends oficial {
	function modelo340( context ) { oficial ( context ); }
	function init() {
		return this.ctx.modelo340_init();
	}
	function rellenarTablasModelo340() {
		return this.ctx.modelo340_rellenarTablasModelo340();
	}
}
//// MODELO 340 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration modelo300 */
/////////////////////////////////////////////////////////////////
//// MODELO 300 /////////////////////////////////////////////////
class modelo300 extends modelo340 {
	function modelo300( context ) { modelo340 ( context ); }
	function init() { 
		return this.ctx.modelo300_init(); 
	}
	function informarTiposDec300() {
		this.ctx.modelo300_informarTiposDec300();
	}
}
//// MODELO 300 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration modelo347 */
/////////////////////////////////////////////////////////////////
//// MODELO 347 /////////////////////////////////////////////////
class modelo347 extends modelo300 {
	var numOperador347:Number;
	var parcialHoja347:Number;

	function modelo347( context ) { modelo300 ( context ); }
	function iniciarDE347(nodo:FLDomNode,campo:String):String {
		return this.ctx.modelo347_iniciarDE347(nodo, campo);
	}
	function siguienteDE347(nodo:FLDomNode,campo:String):String {
		return this.ctx.modelo347_siguienteDE347(nodo, campo);
	}
	function iniciarParcial347(nodo:FLDomNode,campo:String):String {
		return this.ctx.modelo347_iniciarParcial347(nodo, campo);
	}
	function incrementarParcial347(nodo:FLDomNode,campo:String):String {
		return this.ctx.modelo347_incrementarParcial347(nodo, campo);
	}
	function valorParcial347(nodo:FLDomNode,campo:String):String {
		return this.ctx.modelo347_valorParcial347(nodo, campo);
	}
	function formatoAlfabetico347(cadena:String):String {
		return this.ctx.modelo347_formatoAlfabetico347(cadena);
	}
	function formatoAlfanumerico347(texto:String):String {
		return this.ctx.modelo347_formatoAlfanumerico347(texto);
	}
}
//// MODELO 347 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration modelo349 */
/////////////////////////////////////////////////////////////////
//// MODELO 349 /////////////////////////////////////////////////
class modelo349 extends modelo347 {
	var numOperador349:Number;

	function modelo349( context ) { modelo347 ( context ); }
	function iniciarOP349(nodo:FLDomNode,campo:String):String {
		return this.ctx.modelo349_iniciarOP349(nodo, campo);
	}
	function siguienteOP349(nodo:FLDomNode,campo:String):String {
		return this.ctx.modelo349_siguienteOP349(nodo, campo);
	}
}
//// MODELO 349 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration modelo390 */
/////////////////////////////////////////////////////////////////
//// MODELO 390 /////////////////////////////////////////////////
class modelo390 extends modelo349 {
	function modelo390( context ) { modelo349 ( context ); }
	function calcularCampoBooleano(nodo:FLDomNode, campo:String):String {
		this.ctx.modelo390_calcularCampoBooleano(nodo, campo);
	}
	function lanzarInforme(cursor:FLSqlCursor, nombreInforme:String, masWhere:String) {
		return this.ctx.modelo390_lanzarInforme(cursor, nombreInforme, masWhere);
	}
}
//// MODELO 390 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration modelo303 */
/////////////////////////////////////////////////////////////////
//// MODELO 303 /////////////////////////////////////////////////
class modelo303 extends modelo390 {
	function modelo303( context ) { modelo390 ( context ); }
	function init() {
		this.ctx.modelo303_init();
	}
	function informarTiposDec303() {
		this.ctx.modelo303_informarTiposDec303();
	}
	function informarCasillas303() {
			this.ctx.modelo303_informarCasillas303();
	}
}
//// MODELO 303 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends modelo303 {
	function head( context ) { modelo303 ( context ); }
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubModelo347 */
/////////////////////////////////////////////////////////////////
//// PUB_MODELO347 /////////////////////////////////////////////
class pubModelo347 extends head {
	function pubModelo347( context ) { head( context ); }
	function pub_iniciarDE347(nodo:FLDomNode,campo:String):String {
		return this.iniciarDE347(nodo, campo);
	}
	function pub_siguienteDE347(nodo:FLDomNode,campo:String):String {
		return this.siguienteDE347(nodo, campo);
	}
	function pub_iniciarParcial347(nodo:FLDomNode,campo:String):String {
		return this.iniciarParcial347(nodo, campo);
	}
	function pub_incrementarParcial347(nodo:FLDomNode,campo:String):String {
		return this.incrementarParcial347(nodo, campo);
	}
	function pub_valorParcial347(nodo:FLDomNode,campo:String):String {
		return this.valorParcial347(nodo, campo);
	}
	function pub_formatoAlfabetico347(cadena:String):String {
		return this.formatoAlfabetico347(cadena);
	}
	function pub_formatoAlfanumerico347(cadena:String):String {
		return this.formatoAlfanumerico347(cadena);
	}
}

//// PUB_MODELO347 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubModelo349 */
/////////////////////////////////////////////////////////////////
//// PUB_MODELO349 /////////////////////////////////////////////
class pubModelo349 extends pubModelo347 {
	function pubModelo349( context ) { pubModelo347( context ); }
	function pub_iniciarOP349(nodo:FLDomNode,campo:String):String {
		return this.iniciarOP349(nodo, campo);
	}
	function pub_siguienteOP349(nodo:FLDomNode,campo:String):String {
		return this.siguienteOP349(nodo, campo);
	}
}

//// PUB_MODELO349 ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubModelo390 */
/////////////////////////////////////////////////////////////////
//// PUB_MODELO 390 /////////////////////////////////////////////
class pubModelo390 extends pubModelo349 {
	function pubModelo390( context ) { pubModelo349( context ); }
	function pub_calcularCampoBooleano(nodo:FLDomNode,campo:String):String{
		return this.calcularCampoBooleano(nodo, campo);
	}
	function pub_lanzarInforme(cursor:FLSqlCursor, nombreInforme:String, masWhere:String) {
		return this.lanzarInforme(cursor, nombreInforme, masWhere);
	}
}

//// PUB_MODELO390 ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration ifaceCtx */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends pubModelo390 {
	function ifaceCtx( context ) { pubModelo390( context ); }
	function pub_listaAsientosReg():String {
		return this.listaAsientosReg();
	}
	function pub_lanzar(cursor:FLSqlCursor, nombreInforme:String, masWhere:String, nombreReport:String) {
		return this.lanzar(cursor, nombreInforme, masWhere, nombreReport);
	}
	function pub_valorDefectoDatosFiscales(fN:String):String {
		return this.valorDefectoDatosFiscales(fN);
	}
	function pub_verificarDato(valor:String, requerido:Boolean, nombre:String, maxLon:Number):Boolean {
		return this.verificarDato(valor, requerido, nombre, maxLon);
	}
	function pub_formatoNumero(valor:Number, enteros:Number, decimales:Number):String {
		return this.formatoNumero(valor, enteros, decimales);
	}
	function pub_mesPorIndice(indice:Number):String {
		return this.mesPorIndice(indice);
	}
	function pub_numPagina(nodo:FLDomNode,campo:String):String {
		return this.numPagina(nodo, campo);
	}
	function pub_iniciarPagina(nodo:FLDomNode,campo:String):String {
		return this.iniciarPagina(nodo, campo);
	}
	function pub_controlCaracteres(valor:String):String {
		return this.controlCaracteres(valor);
	}
	function pub_formatearTexto(texto:String):String {
		return this.formatearTexto(texto);
	}
	function pub_limpiarCifNif(cifNif:String):String {
		return this.limpiarCifNif(cifNif);
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
function interna_init() {
	var util:FLUtil = new FLUtil();
	if (!util.sqlSelect("co_tiposvia", "codtipovia", "1 = 1"))
		this.iface.informarTiposVia();
	
	var cursor:FLSqlCursor = new FLSqlCursor("co_datosfiscales");
	cursor.select();
	if (!cursor.first()) {
			MessageBox.information(util.translate("scripts",
					"Se insertarán algunos datos fiscales para empezar a trabajar."),
					MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			this.iface.valoresIniciales();
			this.execMainScript("co_datosfiscales");
	}
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Lanza un informe basado en unos determinados criterios de búsqueda

@param	cursor: Cursor posicionado en un registro de criterios de búsqueda
@param	nombreInforme: Nombre del informe a lanzar
@param	masWhere: Parte a añadir a la cláusula where
\end */
function oficial_lanzar(cursor:FLSqlCursor, nombreInforme:String, masWhere:String, nombreReport:String)
{
	var util:FLUtil = new FLUtil;
	var q:FLSqlQuery = new FLSqlQuery(nombreInforme);

	if (!nombreReport)
		nombreReport = nombreInforme;

	var fieldList:String = util.nombreCampos(cursor.table());
	var cuenta:Number = parseFloat(fieldList[0]);

	var signo:String;
	var fN:String;
	var valor:String;
	var primerCriterio:Boolean = false;
	var where:String = "";
	for (var i:Number = 1; i <= cuenta; i++) {
		if (cursor.isNull(fieldList[i]))
			continue;
		signo = this.iface.obtenerSigno(fieldList[i]);
		if (signo != "") {
			fN = this.iface.fieldName(fieldList[i]);
			valor = cursor.valueBuffer(fieldList[i]);
			if (valor == "Sí")
				valor = 1;
			if (valor == "No")
				valor = 0;
			if (valor == "Todos")
				valor = "";
			if (!valor.toString().isEmpty()) {
				if (primerCriterio == true)
					where += "AND ";
				where += fN + " " + signo + " '" + valor + "' ";
				primerCriterio = true;
			}
		}
	}

	if ( masWhere && !masWhere.isEmpty() )
		where += masWhere;
	q.setWhere(where);
debug(q.sql())
	if (q.exec() == false) {
		MessageBox.critical(util.translate("scripts", "Falló la consulta"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return;
	} else {
		if (q.first() == false) {
			MessageBox.warning(util.translate("scripts", "No hay registros que cumplan los criterios de búsqueda establecidos"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			return;
		}
	}

	var rptViewer:FLReportViewer = new FLReportViewer();
	rptViewer.setReportTemplate(nombreReport);
	rptViewer.setReportData(q);
	rptViewer.renderReport();
	rptViewer.exec();
}

/** \D Construye una lista separada por comas con los idasientos de los asientos de regularización de iva
\end */
function oficial_listaAsientosReg():String
{
	var lista:String = "";
	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList("co_regiva");
	q.setSelect("idasiento");
	q.setFrom("co_regiva");
	if (!q.exec()) return lista;
	while (q.next()) {
		lista += q.value(0) + ",";
	}
	lista = lista.left(lista.length - 1);
	if (!lista) lista = "-1";
	return lista;
}

/** \D
Obtiene el operador lógico a aplicar en la cláusula where de la consulta a partir de los primeros caracteres del parámetro
@param	s: Nombre del campo que contiene un criterio de búsqueda
@return	Operador lógico a aplicar
\end */
function oficial_obtenerSigno(s:String):String
{
	if (s.toString().charAt(1) == "_") {
		switch(s.toString().charAt(0)) {
			case "d": {
				return ">=";
			}
			case "h": {
				return "<=";
			}
			case "i": {
				return "=";
			}
		}
	}
	return  "";
}

/** \D Convierte el nombre de un campo de una tabla de informe en un nombre de tabla más un nombre de campo separados por un punto. Se utiliza en campos que definen condiciones lógicas en la consulta del informe como 'igual a', 'mayor o igual que' o 'menor o igual que'. Ejemplo: d_co__asientos_numero como entrada daría como resultado co_asientos.numero

Sustituye '_' por '.'; dos '_' seguidos indica que realmente es '_'

@param s Nombre del campo en la tabla del informe
@return Nombre de campo.Nombre de tabla
\end */
function oficial_fieldName(s:String):String
{
	var fN:String = "";
	var c:String;
	for (var i:Number = 2; (s.toString().charAt(i)); i++) {
		c = s.toString().charAt(i);
		if (c == "_")
			if (s.toString().charAt(i + 1) == "_") {
				fN += "_";
				i++;
			} else
				fN += "."
		else
			fN += s.toString().charAt(i);
	}
	return fN;
}

function oficial_valorDefectoDatosFiscales(fN:String):String
{
	var cursorDatosFiscales:FLSqlCursor = new FLSqlCursor("co_datosfiscales");
	cursorDatosFiscales.select();
	if (cursorDatosFiscales.first())
		return cursorDatosFiscales.valueBuffer(fN);
}

function oficial_valoresIniciales()
{
	var q:FLSqlQuery= new FLSqlQuery();
	var cursor:FLSqlCursor = new FLSqlCursor("co_datosfiscales");

	q.setSelect("nombre,cifnif,codpostal,ciudad,provincia,telefono,administrador,idprovincia");
	q.setFrom("empresa");
	q.setTablesList("empresa");

	q.exec();
	if (!q.first()) return;

	var temp:String;
	with(cursor) {
		setModeAccess(cursor.Insert);
		refreshBuffer();
		temp = q.value(0);
		if (temp && temp != "")
			temp = temp.left(30);
		setValueBuffer("apellidosrs", temp);
		
		temp = q.value(1);
		if (temp && temp != "")
			temp = temp.left(9);
		setValueBuffer("cifnif", temp);
		
		temp = q.value(2);
		if (temp && temp != "")
			temp = temp.left(5);
		setValueBuffer("codpos", temp);
		
		temp = q.value(3);
		if (temp && temp != "")
			temp = temp.left(20);
		setValueBuffer("municipio", temp);
		
		temp = q.value(4);
		if (temp && temp != "")
			temp = temp.left(15);
		setValueBuffer("provincia", temp);
		
		temp = q.value(5);
		if (temp && temp != "")
			temp = temp.left(9);
		setValueBuffer("telefono", temp);
		
		temp = q.value(6);
		if (temp && temp != "")
			temp = temp.left(15);
		setValueBuffer("nombre", temp);
		
		temp = q.value(7);
		if (temp == 0)
			setNull("idprovincia");
		else
			setValueBuffer("idprovincia", temp);
		
		commitBuffer();
	}
}

function oficial_informarTiposVia()
{
	var curTipoVia:FLSqlCursor = new FLSqlCursor("co_tiposvia");
	var valores:Array = [
	["AL", "Alameda, aldea"],
	["AP", "Apartamento"],
	["AV", "Avenida"],
	["BL", "Bloque"],
	["BO", "Barrio"],
	["CH", "Chalet"],
	["CL", "Calle"],
	["CM", "Camino"],
	["CO", "Colonia"],
	["CR", "Carretera"],
	["CS", "Caserío"],
	["CT", "Cuesta"],
	["ED", "Edificio"],
	["GL", "Glorieta"],
	["GR", "Grupo"],
	["LU", "Lugar"],
	["ME", "Mercado"],
	["MU", "Municipio"],
	["MZ", "Manzana"],
	["PB", "Poblado"],
	["PG", "Polígono"],
	["PJ", "Pasaje"],
	["PQ", "Parque"],
	["PZ", "Plaza"],
	["PR", "Prolongación"],
	["PS", "Paseo"],
	["RB", "Rambla"],
	["RD", "Ronda"],
	["TR", "Travesía"],
	["UR", "Urbanización"]];
	
	for (var i:Number = 0; i < valores.length; i++) {
		with (curTipoVia) {
			setModeAccess(Insert);
			refreshBuffer();
			setValueBuffer("codtipovia", valores[i][0]);
			setValueBuffer("descripcion", valores[i][1]);
			commitBuffer();
		}
	}
}

/** \D Comprueba que si un campo es requerido esté informado, y si lo está, que tenga una longitud inferior al máximo establecido
@param	valor: Valor a comprobar
@param	requerido: Indica si el campo es requerido o no
@param	nombre: Nombre del campo para mostrar en caso de error
@param	maxLon: Longitud máxima del campo
@return	true si la comprobación es correcta, false en caso contrario
\end */
function oficial_verificarDato(valor:String, requerido:Boolean, nombre:String, maxLon:Number):Boolean
{
	var util:FLUtil = new FLUtil;
	if (!valor || valor == "") {
		if (!requerido)
			return true;
		MessageBox.warning(util.translate("scripts", "Debe establecer el valor del siguiente campo: ") + nombre, MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	valor = sys.fromUnicode(valor, "ISO-8859-1");
	
	if (valor.toString().length > maxLon) {
		MessageBox.warning(util.translate("scripts", "La longitud del dato excede su longitud máxima: ") + nombre + " - " + maxLon, MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	return true;
}

/** \D Sustituye ciertos caracteres por caracteres válidos
@param	valor: Valor a comprobar
@return	valor revisado
\end */
function oficial_controlCaracteres(valor:String):String
{
	var valorRevisado:String = valor;
	if (!valorRevisado || valorRevisado == "")
		return valorRevisado;

	valorRevisado = valorRevisado.toUpperCase();

	var caracteres:Array = [["Ç", "C"], ["[À,Á,Â]", "A"], ["[È,É,Ê]", "E"], ["[Ì,Í,Ì]", "I"], ["[Ò,Ó,Ò]", "O"], ["[Ù,Ú,Û]", "U"]];
	var regExpTemp:RegExp;
	for (var i:Number = 0; i < caracteres.length; i++) {
		regExpTemp = new RegExp(caracteres[i][0]);
		while (valorRevisado.find(regExpTemp) > -1)
			valorRevisado = valorRevisado.replace(regExpTemp, caracteres[i][1]);
	}
	return valorRevisado;
}

/** \D Formatea un número de acuerdo con los parámetros establecidos
@param	valor: Valor a formatear
@param	enteros: Número de cifras enteras
@param	decimales: Número de cifras decimales
@return	número formateado
\end */
function oficial_formatoNumero(valor:Number, enteros:Number, decimales:Number):String
{
	for (var i:Number = 0; i < decimales; i++)
		valor *= 10;

	valor = Math.round(valor);
		
	var resultado:String = flfactppal.iface.pub_cerosIzquierda(valor, (enteros + decimales));
	return resultado;
}

/** \D Obtiene el nombre del mes a partir de su número
@param	indice: Número del mes
@return	Nombre del mes
\end */
function oficial_mesPorIndice(indice:Number):String
{
	var meses:Array = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"];
	return meses[indice - 1];
}

/** \D Inicia a 1 el contador de páginas
\end */
function oficial_iniciarPagina(nodo:FLDomNode,campo:String):String
{
	this.iface.numPagina_ = 1;
}

/** \D Devuelve el valor del contador de páginas
\end */
function oficial_numPagina(nodo:FLDomNode,campo:String):String
{
	return this.iface.numPagina_++;
}

/** \C Pasa un texto a mayúsculas y elimina las tildes
@param texto: Texto a formatear
@return Texto formateado
\end */
function oficial_formatearTexto(texto:String):String
{
	if (!texto || texto == "") {
		return texto;
	}
	var textoMay:String = texto.toUpperCase();
	var resultado:String;
	for (var i:Number = 0; i < textoMay.length; i++) {
		switch (textoMay.charAt(i)) {
			case "Á": 
			case "À": { 
				resultado += "A"; 
				break; 
			}
			case "É": 
			case "È": { 
				resultado += "E"; 
				break; 
			}
			case "Í": 
			case "Ì": { 
				resultado += "I"; 
				break; 
			}
			case "Ó": 
			case "Ò": { 
				resultado += "O"; 
				break; 
			}
			case "Ú":
			case "Ù": { 
				resultado += "U"; 
				break; 
			}
			default: { 
				resultado += textoMay.charAt(i); 
				break; 
			}
		}
	}
	return resultado;
}

/** \C Elimina caracteres inválidos de un CIF o NIF (".", "-", etc.)
@param CIF o NIF a limpiar
@return CIF o NIF limpio
\end */
function oficial_limpiarCifNif(cifNif:String):String
{
	var cifLimpio:String = "";
	if (cifNif && cifNif != "") {
		var caracter:String;
		for (var i:Number = 0; i < cifNif.length; i++) {
			caracter = cifNif.charAt(i);
			switch (caracter) {
				case ".":
				case " ":
				case "-": {
					break;
				}
				default: {
					cifLimpio += caracter;
				}
			}
		}
	}
	return cifLimpio;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition modelo340 */
/////////////////////////////////////////////////////////////////
//// MODELO 340 /////////////////////////////////////////////////
function modelo340_init()
{
	this.iface.__init();

	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = new FLSqlCursor("co_identifpaisresidencia");
	cursor.select();
	if (!cursor.first()) {
		var res:Number = MessageBox.information(util.translate("scripts","Insertar tablas para el modelo 340."),MessageBox.Yes, MessageBox.No);
		if (res != MessageBox.Yes) {
			return false;
		} else {
			this.iface.rellenarTablasModelo340();
		}
	}
}

function modelo340_rellenarTablasModelo340()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = new FLSqlCursor("co_identifpaisresidencia");
	var clavePaisResidencia:Array =
		[["1", "Corresponde a un NIF"],["2", "Se consigna el NIF/IVA (NIF OPERADOR INTRACOMUNITARIO)"],["3", "Pasaporte"],["4", "Documento oficial de identificación expedido por el país o territorio de residencia"],["5", "Certificado de residencia fiscal"],["6", "Otro documento probatorio"]];
	for (var i:Number = 0; i < clavePaisResidencia.length; i++) {
		with(cursor) {
			setModeAccess(cursor.Insert);
			refreshBuffer();
			setValueBuffer("codigo", clavePaisResidencia[i][0]);
			setValueBuffer("descripcion", clavePaisResidencia[i][1]);
			commitBuffer();
		}
	}

	var cursor:FLSqlCursor = new FLSqlCursor("co_tipolibro");
	var tipoLibro:Array =
		[["E", "Libro registro de facturas expedidas"],["I", "Libro registro de bienes de inversión"],["R", "Libro registro de facturas recibidas"],["U", "Libro registro de determinadas operaciones intracomunitarias"],["F", "Libro registro de facturas expedidas IGIC"],["J", "Libro de registro de bienes de inversión IGIC"],["S", "Libro de registro de facturas recibidas IGIC"]];
	for (var i:Number = 0; i < tipoLibro.length; i++) {
		with(cursor) {
			setModeAccess(cursor.Insert);
			refreshBuffer();
			setValueBuffer("codigo", tipoLibro[i][0]);
			setValueBuffer("descripcion", tipoLibro[i][1]);
			commitBuffer();
		}
	}

	var cursor:FLSqlCursor = new FLSqlCursor("co_claveoperacion");
	var claveOperacion:Array =
		[["A", "Asiento resumen de facturas"],["B", "Asiento resumen de tique"],["C", "Factura con varios asientos (varios tipos impositivos)"],["D", "Factura rectificativa"],["F", "Adquisiciones realizadas por las agencias de viajes directamente en interés del viajero (Régimen especial de agencias de viajes)"],["G", "Régimen especial de grupo de entidades en IVA o IGIC (Incorpora la contraprestación real a coste)"],["H", "Régimen especial de oro de inversión"],["I", "Inversión del sujeto pasivo (ISP)"],["J", "Tiques"],["K", "Rectificación de errores registrales"],["L", "Adquisiciones a comerciantes minoristas del IGIC. Ninguna de las anteriores"]];
	for (var i:Number = 0; i < claveOperacion.length; i++) {
		with(cursor) {
			setModeAccess(cursor.Insert);
			refreshBuffer();
			setValueBuffer("codigo", claveOperacion[i][0]);
			setValueBuffer("descripcion", claveOperacion[i][1]);
			commitBuffer();
		}
	}
}

//// MODELO 340 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition modelo300 */
/////////////////////////////////////////////////////////////////
//// MODELO 300 /////////////////////////////////////////////////
function modelo300_init() 
{
	this.iface.__init();
	var util:FLUtil = new FLUtil();
	if (!util.sqlSelect("co_tipodec300", "idtipodec", "1 = 1"))
		this.iface.informarTiposDec300();
}

function modelo300_informarTiposDec300()
{
	var curTipoDec:FLSqlCursor = new FLSqlCursor("co_tipodec300");
	var valores:Array = [["C", "Solicitud de compensación"],
		["D", "Devolución"],
		["G", "Cuenta corriente tributaria - ingreso"],
		["N", "Sin actividad / resultado 0"], 
		["V", "Cuenta corriente tributaria - devolución"]];
	
	for (var i:Number = 0; i < valores.length; i++) {
		with (curTipoDec) {
			setModeAccess(Insert);
			refreshBuffer();
			setValueBuffer("idtipodec", valores[i][0]);
			setValueBuffer("descripcion", valores[i][1]);
			commitBuffer();
		}
	}
}

//// MODELO 300 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition modelo347 */
/////////////////////////////////////////////////////////////////
//// MODELO 347 /////////////////////////////////////////////////
/** \D Inicia a cero el contador de declarados del modelo 347
\end */
function modelo347_iniciarDE347(nodo:FLDomNode,campo:String):String
{
	this.iface.numOperador347 = 0;
}

/** \D Devuelve la cadena "Declarado" + número del contador de declarados, e incrementa el contador
\end */
function modelo347_siguienteDE347(nodo:FLDomNode,campo:String):String
{
	this.iface.numOperador347++;
	return "Declarado " + this.iface.numOperador347;
}

/** \D Inicia a cero la variable que suma el importe total de cada hoja en el modelo 347
\end */
function modelo347_iniciarParcial347(nodo:FLDomNode,campo:String):String
{
	this.iface.parcialHoja347 = 0;
debug("iniciando parcial");
}

/** \D Suma a la variable la cantidad correspondiente de cada declarado en el modelo 347
\end */
function modelo347_incrementarParcial347(nodo:FLDomNode,campo:String):String
{
	var importe:String =  nodo.attributeValue("co_modelo347_tipo2d.importe");
	this.iface.parcialHoja347 += parseFloat(importe);
debug("incrementando parcial a " + this.iface.parcialHoja347);
}

/** \D Devuelve el valor del importe total de la hoja
\end */
function modelo347_valorParcial347(nodo:FLDomNode,campo:String):String
{
debug("obteniendo parcial a " + this.iface.parcialHoja347);
	return this.iface.parcialHoja347;
}

function modelo347_formatoAlfabetico347(texto:String):String
{
	var validos:String = " ,-.ABCDEFGHIJKLMNOPQRSTUVWXYZ"; /// Se quita la comilla \' por error en mayton

	if (!texto || texto == "") {
		return texto;
	}
	var textoMay:String = this.iface.formatearTexto(texto);
	var resultado:String;
	var iPos:Number;
	var caracter:String;
	var carAnterior:String = "";
	for (var i:Number = 0; i < textoMay.length; i++) {
		caracter = textoMay.charAt(i);
		iPos = validos.find(caracter);
		if (iPos >= 0) {
			if (!(caracter == " " && (carAnterior == " " || carAnterior == ""))) { /// Evita dos espacios seguidos
				resultado += caracter;
				carAnterior = caracter;
			}
		}
	}
	return resultado;
}

function modelo347_formatoAlfanumerico347(texto:String):String
{
	var validos:String = " &,-./0123456789:;ABCDEFGHIJKLMNOPQRSTUVWXYZ_"; /// Se quita la comilla \' por error en mayton

	if (!texto || texto == "") {
		return texto;
	}
	var textoMay:String = this.iface.formatearTexto(texto);
	var resultado:String;
	var iPos:Number;
	var caracter:String;
	var carAnterior:String = "";
	for (var i:Number = 0; i < textoMay.length; i++) {
		caracter = textoMay.charAt(i);
		iPos = validos.find(caracter);
		if (!(caracter == " " && (carAnterior == " " || carAnterior == ""))) { /// Evita dos espacios seguidos
			resultado += caracter;
			carAnterior = caracter;
		}
	}
	return resultado;
}

//// MODELO 347 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition modelo349 */
/////////////////////////////////////////////////////////////////
//// MODELO 349 /////////////////////////////////////////////////
/** \D Inicia a cero el contador de operadores del modelo 349
\end */
function modelo349_iniciarOP349(nodo:FLDomNode,campo:String):String
{
	this.iface.numOperador349 = 0;
}

/** \D Devuelve la cadena "Operador" + número del contador de operadores, e incrementa el contador
\end */
function modelo349_siguienteOP349(nodo:FLDomNode,campo:String):String
{
	this.iface.numOperador349++;
	return "Operador " + this.iface.numOperador349;
}

//// MODELO 349 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/** @class_definition modelo390 */
/////////////////////////////////////////////////////////////////
//// MODELO 390 /////////////////////////////////////////////////
/** \D Devuelve una X si el valor del campo es verdadero. Esta función se usa desde los scripts para cumplimentas correctamente los campos de tipo casilla de verificación

@param	nodo: Nodo con los valores de la fila actual del informe
@param	campo: Nombre del campo (no se usa en esta función)
@return	X si el valor del campo es verdadero, cadena vacía si es falso
\end */
function modelo390_calcularCampoBooleano(nodo:FLDomNode, campo:String):String
{
	var decpterceros:String = nodo.attributeValue("co_modelo390.declaracionopterceros3");

	if (decpterceros)
		return "X"
	else
		return ""
}

function modelo390_lanzarInforme( cursor:FLSqlCursor, nombreInforme:String, masWhere:String )
{
	var util:FLUtil = new FLUtil;
	var dialog:Object = new Dialog;
	dialog.caption = util.translate("scripts","Elegir página a imprimir");
	dialog.okButtonText = util.translate("scripts","Aceptar");
	dialog.cancelButtonText = util.translate("scripts","Cancelar");

	var text:Object = new Label;
	text.text = util.translate("scripts","Ha seleccionado un informe de varias páginas,\nelija la página/s a imprimir:");
	dialog.add(text);

	var bgroup:GroupBox = new GroupBox;
	dialog.add( bgroup );

	var imprimirtodas:CheckBox = new CheckBox;
	imprimirtodas.text = util.translate ( "scripts", "Todas" );
	imprimirtodas.checked = true;
	bgroup.add( imprimirtodas );

	var imprimiruna:CheckBox = new CheckBox;
	imprimiruna.text = util.translate ( "scripts", "Página 1" );
	imprimiruna.checked = false;
	bgroup.add( imprimiruna );

	var imprimirdos:CheckBox = new CheckBox;
	imprimirdos.text = util.translate ( "scripts", "Página 2" );
	imprimirdos.checked = false;
	bgroup.add( imprimirdos);

	var imprimirtres:CheckBox = new CheckBox;
	imprimirtres.text = util.translate ( "scripts", "Página 3" );
	imprimirtres.checked = false;
	bgroup.add( imprimirtres);

	var imprimircuatro:CheckBox = new CheckBox;
	imprimircuatro.text = util.translate ( "scripts", "Página 4" );
	imprimircuatro.checked = false;
	bgroup.add( imprimircuatro );

	var imprimircinco:CheckBox = new CheckBox;
	imprimircinco.text = util.translate ( "scripts", "Página 5" );
	imprimircinco.checked = false;
	bgroup.add( imprimircinco );

	if ( !dialog.exec() )
		return;

	var imprimir = new Array(5);

	for (var i:Number = 0; i < 5; i++)
		imprimir[i] = true;

	if (imprimirtodas.checked == false) {
		if(imprimiruna.checked == false)
			imprimir[0] = false;
		if(imprimirdos.checked == false)
			imprimir[1] = false;
		if(imprimirtres.checked == false)
			imprimir[2] = false;
		if(imprimircuatro.checked == false)
			imprimir[3] = false;
		if(imprimircinco.checked == false)
			imprimir[4] = false;
	}

	nombreInforme = "co_modelo390_0";
	for (var i:Number = 1; i < 6; i++){
		if(imprimir[i-1] == true){
			this.iface.lanzar(cursor, nombreInforme + i.toString(), masWhere );
		}
	}
}

//// MODELO 390 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition modelo303 */
/////////////////////////////////////////////////////////////////
//// MODELO 303 /////////////////////////////////////////////////
function modelo303_init()
{
	this.iface.__init();

	var util:FLUtil = new FLUtil;

	if (!util.sqlSelect("co_tipodec303", "idtipodec", "1 = 1")) {
		this.iface.informarTiposDec303();
	}
	this.iface.informarCasillas303();
}

function modelo303_informarTiposDec303()
{
	var curTipoDec:FLSqlCursor = new FLSqlCursor("co_tipodec303");
	var valores:Array = [["C", "Solicitud de compensación"],
		["D", "Devolución"],
		["G", "Cuenta corriente tributaria - ingreso"],
		["I", "Ingreso"],
		["N", "Sin actividad / resultado 0"], 
		["V", "Cuenta corriente tributaria - devolución"],
		["U", "Domiciliación de ingreso en CCC"]];
	
	for (var i:Number = 0; i < valores.length; i++) {
		with (curTipoDec) {
			setModeAccess(Insert);
			refreshBuffer();
			setValueBuffer("idtipodec", valores[i][0]);
			setValueBuffer("descripcion", valores[i][1]);
			commitBuffer();
		}
	}
}

function modelo303_informarCasillas303()
{
	var util:FLUtil = new FLUtil;

	var contenido:String = "<Todos>" +
	"<co_casillas303 casilla='[01]-[09]' descripcion='" + util.translate("scripts", "I.V.A. Devengado - Régimen General") + "' />" +
	"<co_casillas303 casilla='[10]-[18]' descripcion='" + util.translate("scripts", "I.V.A. Devengado Recargo de equivalencia Régimen General") + "' />" +
	"<co_casillas303 casilla='[19]-[20]' descripcion='" + util.translate("scripts", "I.V.A. Devengado Adquisiciones intracomunitarias") + "' />" +
	"<co_casillas303 casilla='[22]-[23]' descripcion='" + util.translate("scripts", "I.V.A. Deducible por cuotas soportadas en operaciones interiores con bienes corrientes") + "' />" +
	"<co_casillas303 casilla='[24]-[25]' descripcion='" + util.translate("scripts", "I.V.A. Deducible por cuotas soportadas en operaciones interiores con bienes de inversión") + "' />" +
	"<co_casillas303 casilla='[26]-[27]' descripcion='" + util.translate("scripts", "I.V.A. Deducible por cuotas soportadas en importaciones de bienes corrientes") + "' />" +
	"<co_casillas303 casilla='[28]-[29]' descripcion='" + util.translate("scripts", "I.V.A. Deducible por cuotas soportadas en importaciones de bienes de inversión") + "' />" +
	"<co_casillas303 casilla='[30]-[31]' descripcion='" + util.translate("scripts", "I.V.A. Deducible por cuotas soportadas en adquisiciones intracomunitarias de bienes corrientes") + "' />" +
	"<co_casillas303 casilla='[32]-[33]' descripcion='" + util.translate("scripts", "I.V.A. Deducible por cuotas soportadas en adquisiciones intracomunitarias de bienes de inversión") + "' />" + 
	"<co_casillas303 casilla='[34]' descripcion='" + util.translate("scripts", "I.V.A. Deducible por compensaciones de regimen especial A.G.y P.") + "' />" +
	"<co_casillas303 casilla='[42]' descripcion='" + util.translate("scripts", "Entregas intracomunitarias") + "' />" +
	"<co_casillas303 casilla='[43]' descripcion='" + util.translate("scripts", "Exportaciones y operaciones asimilables") + "' />" +
	"<co_casillas303 casilla='[44]' descripcion='" + util.translate("scripts", "Operaciones no sujetas o con inversión del sujeto pasivo que originan derecho a deducción") + "' />" +
	"</Todos>";

	xmlDoc = new FLDomDocument();
	if (!xmlDoc.setContent(contenido)) {
debug("!xmlDoc.setContent(contenido)");
		return false;
	}
	var xmlOD:FLDomNodeList = xmlDoc.elementsByTagName("co_casillas303");
	var eOD:FLDomElement;
	var curCasillas:FLSqlCursor = new FLSqlCursor("co_casillas303");
	for (var i:Number = 0; i < xmlOD.length(); i++) {
		eOD = xmlOD.item(i).toElement();
		curCasillas.setModeAccess(curCasillas.Insert);
		curCasillas.refreshBuffer();
		if (util.sqlSelect("co_casillas303", "casilla303", "casilla303 = '" + eOD.attribute("casilla") + "'")) {
			continue;
		}
		curCasillas.setValueBuffer("casilla303", eOD.attribute("casilla"));
		curCasillas.setValueBuffer("descripcion", eOD.attribute("descripcion"));
		if (!curCasillas.commitBuffer()) {
			return false;
		}
	}
	return true;
}

//// MODELO 303 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////