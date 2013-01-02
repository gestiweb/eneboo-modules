/***************************************************************************
                 flcrm_mark.qs  -  description
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
    function oficial( context ) { interna( context ); }
	function buscarCampo(codConsulta:String):Array {
		return this.ctx.oficial_buscarCampo(codConsulta);
	}
	function buscarCampoTablas(codConsulta:String):Array {
		return this.ctx.oficial_buscarCampoTablas(codConsulta);
	}
	function sinEspacios(cadena:String):String {
		return this.ctx.oficial_sinEspacios(cadena);
	}
	function queryLista(codLista:String):FLSqlQuery {
		return this.ctx.oficial_queryLista(codLista);
	}
	function seleccionCampo(listaCampos:String):Array {
		return this.ctx.oficial_seleccionCampo(listaCampos);
	}
	function arrayAliasCampana(codCampana:String):Array {
		return this.ctx.oficial_arrayAliasCampana(codCampana);
	}
	function sustituirAlias(plantilla:String, datos:String, arrayAlias:Array):String {
		return this.ctx.oficial_sustituirAlias(plantilla, datos, arrayAlias);
	}
	function valoresIniciales() {
		return this.ctx.oficial_valoresIniciales();
	}
	function actualizarListaAnalisis(curLista:FLSqlCursor):Boolean {
		return this.ctx.oficial_actualizarListaAnalisis(curLista);
	}
	function valorConfigMarketing(nombreValor:String):String {
		return this.ctx.oficial_valorConfigMarketing(nombreValor);
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
	function pub_buscarCampo(codConsulta:String):Array {
		return this.buscarCampo(codConsulta);
	}
	function pub_buscarCampoTablas(codConsulta:String):Array {
		return this.buscarCampoTablas(codConsulta);
	}
	function pub_queryLista(codLista:String):FLSqlQuery {
		return this.queryLista(codLista);
	}
	function pub_seleccionCampo(listaCampos:String):String {
		return this.seleccionCampo(listaCampos);
	}
	function pub_arrayAliasCampana(codCampana:String):Array {
		return this.arrayAliasCampana(codCampana);
	}
	function pub_sustituirAlias(plantilla:String, datos:String, arrayAlias:Array):String {
		return this.sustituirAlias(plantilla, datos, arrayAlias);
	}
	function pub_actualizarListaAnalisis(curLista:FLSqlCursor):Boolean {
		return this.actualizarListaAnalisis(curLista);
	}
	function pub_valorConfigMarketing(nombreValor:String):String {
		return this.valorConfigMarketing(nombreValor);
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
function interna_init()
{
	var util:FLUtil = new FLUtil;
	if (!util.sqlSelect("crm_estadoscampana", "codestado", "1 = 1")) {
		MessageBox.information(util.translate("scripts", "Se insertarán algunos valores iniciales y de ejemplo para comenzar a trabajar con el módulo de marketing"), MessageBox.Ok, MessageBox.NoButton);
		this.iface.valoresIniciales();
	}
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Muestra al usuario la lista de campos de la consulta para que seleccione uno de ellos
@param	codConsulta: Consulta que contiene los campos
@return	array con los valores:
campo: campo seleccionado
alias: alias del campo seleccionado
tipo: tipo del campo seleccionado
o false si hay error
\end */
function oficial_buscarCampo(codConsulta:String):Array
{
	var util:FLUtil = new FLUtil();
	
	var listaCampos:String = util.sqlSelect("crm_consultasmark", "campos", "codconsulta = '" + codConsulta + "'");
	if (!listaCampos)
		return false;

	var valores:String = this.iface.seleccionCampo(listaCampos);
	if (!valores)
		return false;
	return valores;
}

/** \D Muestra al usuario la lista de todos los campos incluidos en las tablas de la consulta para que seleccione uno de ellos
@param	codConsulta: Consulta que contiene los las tablas
@return	array con los valores:
campo: campo seleccionado
alias: alias del campo seleccionado
tipo: tipo del campo seleccionado
o false si hay error
\end */
function oficial_buscarCampoTablas(codConsulta:String):Array
{
	var util:FLUtil = new FLUtil();

	var res:Array = [];
	var listaTablas:String = util.sqlSelect("crm_consultasmark", "listatablas", "codconsulta = '" + codConsulta + "'");
	if (!listaTablas)
		return false;

	var xmlTabla:FLDomDocument;
	var nodosCampo:FLDomNodeList = new FLDomNodeList;
	var contenidoTabla:String;
	var arrayCampos:Array;
	var arrayCamposSel:Array = [];
	var arrayTablas = listaTablas.split(",");
	if (!arrayTablas)
		return false;

	var dialogo:Dialog = new Dialog;
	dialogo.caption = util.translate("scripts", "Seleccione campo");
	dialogo.okButtonText = util.translate("scripts", "Aceptar");
	dialogo.cancelButtonText = util.translate("scripts", "Cancelar");

	var gbxDialogo = new GroupBox;
	dialogo.add(gbxDialogo);
	var arrayRB:Array = [];
	var arrayNombresCampos:Array = [];
	var arrayTiposCampos:Array = [];
	var indice:Number = 0;
	var indiceColumna:Number = 0;
	var tipo:Number;
	for (var i:Number = 0; i < arrayTablas.length; i++) {
		arrayCampos = util.nombreCampos(arrayTablas[i]);
		for (var k:Number = 1; k <= arrayCampos[0]; k++) {
			tipo = util.fieldType(arrayCampos[k], arrayTablas[i]);
			if (tipo == 100)
				continue;
			arrayRB[indice] = new RadioButton;
			arrayRB[indice].text = util.fieldNameToAlias(arrayCampos[k], arrayTablas[i]);
			gbxDialogo.add(arrayRB[indice]);
			arrayNombresCampos[indice] = arrayTablas[i] + "." + arrayCampos[k];
			arrayTiposCampos[indice] = tipo;
			indice++;
			if (++indiceColumna > 15) {
				gbxDialogo.newColumn();
				indiceColumna = 0;
			}
		}
	}
	if (!dialogo.exec())
		return false;
	
	var indiceSel:Number = -1;
	for (var i:Number = 0; i < arrayRB.length; i++) {
		if (arrayRB[i].checked) {
			indiceSel = i;
			break;
		}
	}
	if (indiceSel == -1)
		return false;

	res["nombre"] = arrayRB[indiceSel].text;
	res["campo"] = arrayNombresCampos[indiceSel];
	res["tipo"] = arrayTiposCampos[indiceSel];
	return res;
}


/** \D Muestra al usuario la lista de campos para que seleccione uno de ellos
@param	listaCampos: Array que contiene la lista de campos separados por comas
@return	array con los valores:
campo: campo seleccionado
alias: alias del campo seleccionado
tipo: tipo del campo seleccionado
o false si hay error
\end */
function oficial_seleccionCampo(listaCampos:String):Array
{
	var util:FLUtil = new FLUtil();

	listaCampos = this.iface.sinEspacios(listaCampos);
	var arrayCampos:Array = listaCampos.split(",");
/*
	var campo:String = Input.getItem(util.translate("scripts", "Seleccione campo"), arrayCampos, false, false, util.translate("scripts", "Título"));
	if (!campo)
		return false;
	return campo;
*/
	var res:Array = [];
	var dialogo:Dialog = new Dialog;
	dialogo.caption = util.translate("scripts", "Seleccione campo");
	dialogo.okButtonText = util.translate("scripts", "Aceptar");
	dialogo.cancelButtonText = util.translate("scripts", "Cancelar");

	var gbxDialogo = new GroupBox;
	dialogo.add(gbxDialogo);
	var arrayRB:Array = [];
	var arrayNombresCampos:Array = [];
	var arrayTiposCampos:Array = [];
	var indice:Number = 0;
	var indiceColumna:Number = 0;
	var tipo:Number;
	var arrayTablaCampo:Array;
	for (var i:Number = 0; i < arrayCampos.length; i++) {
		arrayTablaCampo = arrayCampos[i].split(".");
		if (arrayTablaCampo.length != 2) {
			MessageBox.information(util.translate("scripts", "No ha especificado correctamente el formato tabla.campo para el valor %1").arg(arrayCampos[i]), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
		tipo = util.fieldType(arrayTablaCampo[1], arrayTablaCampo[0]);
		if (tipo == 100)
			continue;
		arrayRB[indice] = new RadioButton;
		arrayRB[indice].text = util.fieldNameToAlias(arrayTablaCampo[1], arrayTablaCampo[0]) + " " + util.translate("scripts", "en") + " " + util.tableNameToAlias(arrayTablaCampo[0]);
		gbxDialogo.add(arrayRB[indice]);
		arrayTiposCampos[indice] = tipo;
		indice++;
		if (++indiceColumna > 15) {
			gbxDialogo.newColumn();
			indiceColumna = 0;
		}
	}
	if (!dialogo.exec())
		return false;
	
	var indiceSel:Number = -1;
	for (var i:Number = 0; i < arrayRB.length; i++) {
		if (arrayRB[i].checked) {
			indiceSel = i;
			break;
		}
	}
	if (indiceSel == -1)
		return false;

	res["nombre"] = arrayRB[indiceSel].text;
	res["campo"] = arrayCampos[indiceSel];
	res["tipo"] = arrayTiposCampos[indiceSel];
	return res;

}

/** \D Elimina los parámetros de una cadena
@param	cadena: Cadena a tratar
@return	cadena sin espacios o false si hay error
\end */
function oficial_sinEspacios(cadena:String):String
{
	var resultado:String = cadena.toString();
	if (!resultado)
		return "";

	var posEspacio:Number = resultado.find(" ");
	while (posEspacio > -1) {
		resultado = resultado.left(posEspacio) + resultado.right(resultado.length - posEspacio - 1);
		posEspacio = resultado.find(" ");
	}
	return resultado;
}

/** \D Construye la consulta SQL asociada a una lista de marketing
@param	codLista: Código de lista
@return	consulta SQL o false si hay error
\end */
function oficial_queryLista(codLista:String):FLSqlQuery
{
	var util:FLUtil = new FLUtil;

	var criterios:String = "";
	var codConsulta:String = util.sqlSelect("crm_listasmark", "codconsulta", "codlista = '" + codLista + "'");
	var qryConsulta:FLSqlQuery = new FLSqlQuery;
	with(qryConsulta) {
		setTablesList("crm_consultasmark");
		setSelect("listatablas, campos, desde, donde, campoclave");
		setFrom("crm_consultasmark");
		setWhere("codconsulta = '" + codConsulta + "'");
		setForwardOnly(true);
	}
	if (!qryConsulta.exec())
		return false;
	if (!qryConsulta.first())
		return false;

	var dondeConsulta:String = qryConsulta.value("donde");
	if (dondeConsulta && dondeConsulta != "")
		criterios = "(" + dondeConsulta + ")";

	var qryCriterios:FLSqlQuery = new FLSqlQuery;
	with(qryCriterios) {
		setTablesList("crm_criterioslista");
		setSelect("campo, condicion, valor, valor2, tipo");
		setFrom("crm_criterioslista");
		setWhere("codlista = '" + codLista + "'");
		setForwardOnly(true);
	}
	if (!qryCriterios.exec())
		return false;

	var igualQue:String = util.translate("scripts", "Igual que");
	var distintoDe:String = util.translate("scripts", "Distinto de");
	var mayorQue:String = util.translate("scripts", "Mayor que");
	var menorQue:String = util.translate("scripts", "Menor que");
	var mayorOIgualQue:String = util.translate("scripts", "Mayor o igual que");
	var menorOIgualQue:String = util.translate("scripts", "Menor o igual que");
	var entre:String = util.translate("scripts", "Entre");
	var en:String = util.translate("scripts", "Incluido en");
	var noEn:String = util.translate("scripts", "No incluido en");
	var contiene:String = util.translate("scripts", "Contiene");
	var noContiene:String = util.translate("scripts", "No contiene");

	while (qryCriterios.next()) {
		if (criterios != "")
			criterios += " AND ";
		criterios += qryCriterios.value("campo");
		switch (qryCriterios.value("condicion")) {
			case igualQue: {
				criterios += " = ";
				break;
			}
			case distintoDe: {
				criterios += " <> ";
				break;
			}
			case mayorQue: {
				criterios += " > ";
				break;
			}
			case menorQue: {
				criterios += " < ";
				break;
			}
			case mayorOIgualQue: {
				criterios += " >= ";
				break;
			}
			case menorOIgualQue: {
				criterios += " <= ";
				break;
			}
			case entre: {
				criterios += " BETWEEN ";
				break;
			}
			case en: {
				criterios += " IN ";
				break;
			}
			case noEn: {
				criterios += " NOT IN ";
				break;
			}
			case contiene: {
				criterios += " LIKE ";
				break;
			}
			case noContiene: {
				criterios += " NOT LIKE ";
				break;
			}
			default: {
				return false;
			}
		}
		switch (qryCriterios.value("tipo")) {
			// String
			case 3:
			 // Fecha
			case 26: {
				switch (qryCriterios.value("condicion")) {
					case en: 
					case noEn: {
						var valor:String = qryCriterios.value("valor");
						var valores:Array = valor.split(",");
						criterios += "(";
						for (var i:Number = 0; i < valores.length; i++) {
							if (i == valores.length - 1) {
								criterios += "'" + valores[i] + "'";
							} else {
								criterios += "'" + valores[i] + "',";
							}
						}
						criterios += ")";
						break;
					}
					case entre: {
						criterios += "'" + qryCriterios.value("valor") + "'";
						criterios += " AND '" + qryCriterios.value("valor2") + "'";
						break;
					}
					case contiene: {
						criterios += "'%" + qryCriterios.value("valor") + "%'";
						break;
					}
					case noContiene: {
						criterios += "'%" + qryCriterios.value("valor") + "%'";
						break;
					}
					default: {
						criterios += "'" + qryCriterios.value("valor") + "'";
						break;
					}
				}
				break;
			}
			default: {
				switch (qryCriterios.value("condicion")) {
					case en: 
					case noEn: {
						criterios += "(" + qryCriterios.value("valor") + ")";
						break;
					}
					case entre: {
						criterios += qryCriterios.value("valor");
						criterios += " AND " + qryCriterios.value("valor2");
						break;
					}
					default: {
						criterios += qryCriterios.value("valor");
						break;
					}
				}
			}
		}
	}

	var miFrom:String = qryConsulta.value("desde");
	var esManual:Boolean = util.sqlSelect("crm_listasmark", "manual", "codlista = '" + codLista + "'");
	if (esManual) {
		miFrom += " INNER JOIN crm_elementoslista ON " + qryConsulta.value("campoclave") + " = crm_elementoslista.clave";
		criterios += " AND crm_elementoslista.codlista = '" + codLista + "'";
	}

	var qryLista:FLSqlQuery = new FLSqlQuery;
	with(qryLista) {
		setTablesList(qryConsulta.value("listatablas"));
		setSelect(qryConsulta.value("campos"));
		setFrom(miFrom);
		setWhere(criterios);
		setForwardOnly(true);
	}

	return qryLista;
}

/** \D Construye un array con los alias de una campaña
@param	codCampana: Código de la campaña
@return	array con los alias o false si hay error
\end */
function oficial_arrayAliasCampana(codCampana:String):Array
{
	var arrayAlias:Array = [];
	var qryAlias:FLSqlQuery = new FLSqlQuery();
	with (qryAlias) {
		setTablesList("crm_aliascampana");
		setSelect("alias");
		setFrom("crm_aliascampana");
		setWhere("codcampana = '" + codCampana + "'");
		setForwardOnly(true);
	}
	if (!qryAlias.exec())
		return false;

	var indice:Number = 0;
	while (qryAlias.next()) {
		arrayAlias[indice++] = qryAlias.value("alias");
	}
	return arrayAlias;
}

/** \D Aplica los datos de un destinatario a una plantilla
@param	plantilla: String con la plantilla
@param	datos: String con el nodo XML que contiene los datos
@param	arrayAlias: Array con los nombres de los alias (atributos del nodo XML)
\end */
function oficial_sustituirAlias(plantilla:String, datos:String, arrayAlias:Array):String
{
	var resultado:String = plantilla;
	var posEspacio:Number;
	var patronABuscar:String;
	var valor:String;

	var xmlDatos:FLDomDocument = new FLDomDocument;
	if (!xmlDatos.setContent(datos))
		return false;

	for (var i:Number = 0; i < arrayAlias.length; i++) {
		patronABuscar = "#" + arrayAlias[i] + "#";
		valor = xmlDatos.firstChild().attributeValue(arrayAlias[i]);
		posEspacio = resultado.find(patronABuscar);
		while (posEspacio > -1) {
			resultado = resultado.replace(patronABuscar, valor);
			posEspacio = resultado.find(patronABuscar);
		}
	}
	return resultado;
}

/** \D Creación de los valores iniciales y de ejemplo
\end */
function oficial_valoresIniciales()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor;
	var varlores:Array;
	var hoy:Date = new Date;

	valores = [[util.translate("scripts", "ABIERTA"), util.translate("scripts", "Campaña abierta"), true],
	[util.translate("scripts", "EN CURSO"), util.translate("scripts", "Campaña en curso"), false],
	[util.translate("scripts", "CERRADA"), util.translate("scripts", "Campaña cerrada"), false]];

	cursor = new FLSqlCursor("crm_estadoscampana");
	for (var i:Number = 0; i < valores.length; i++) {
		with(cursor) {
			setModeAccess(cursor.Insert);
			refreshBuffer();
			setValueBuffer("codestado", valores[i][0]);
			setValueBuffer("descripcion", valores[i][1]);
			setValueBuffer("valordefecto", valores[i][2]);
			if (!commitBuffer())
				return false;
		}
	}
	delete cursor;

	valores = [[util.translate("scripts", "GENERADO"), util.translate("scripts", "Mensaje generado"), true],
	[util.translate("scripts", "ENVIADO"), util.translate("scripts", "Mensaje enviado"), false],
	[util.translate("scripts", "RESPUESTA OK"), util.translate("scripts", "Mensaje con respuesta satisfactoria"), false],
	[util.translate("scripts", "R. NEGATIVA"), util.translate("scripts", "Mensaje con respuesta negativa"), false],
	[util.translate("scripts", "SIN RESPUESTA"), util.translate("scripts", "Mensaje sin respuesta"), false]];

	cursor = new FLSqlCursor("crm_estadosdestina");
	for (var i:Number = 0; i < valores.length; i++) {
		with(cursor) {
			setModeAccess(cursor.Insert);
			refreshBuffer();
			setValueBuffer("codestado", valores[i][0]);
			setValueBuffer("descripcion", valores[i][1]);
			setValueBuffer("valordefecto", valores[i][2]);
			if (!commitBuffer())
				return false;
		}
	}
	delete cursor;

	valores = [[util.translate("scripts", "CLIENTES ENV"), util.translate("scripts", "Datos de clientes y su dirección de envío"), "clientes,dirclientes", "clientes.codcliente, clientes.nombre, clientes.contacto, dirclientes.direccion, clientes.email, clientes.telefono1, dirclientes.ciudad, dirclientes.codpostal, dirclientes.provincia, paises.nombre", "clientes INNER JOIN dirclientes ON (clientes.codcliente = dirclientes.codcliente AND domenvio = true) LEFT OUTER JOIN paises ON (dirclientes.codpais = paises.codpais)", "1 = 1", "clientes.codcliente", "clientes.nombre", "clientes.telefono1", "clientes.email", "dirclientes.direccion%%dirclientes.ciudad%%dirclientes.codpostal%%dirclientes.provincia%%paises.nombre%%"],
	[util.translate("scripts", "CLIENTES FAC"), util.translate("scripts", "Datos de clientes y su dirección de envío"), "clientes,dirclientes", "clientes.codcliente, clientes.nombre, clientes.contacto, dirclientes.direccion, clientes.email, clientes.telefono1, dirclientes.ciudad, dirclientes.codpostal, dirclientes.provincia, paises.nombre", "clientes INNER JOIN dirclientes ON (clientes.codcliente = dirclientes.codcliente AND domfacturacion = true) LEFT OUTER JOIN paises ON (dirclientes.codpais = paises.codpais)", "1 = 1", "clientes.codcliente", "clientes.codcliente", "clientes.nombre", "clientes.telefono1", "clientes.email", "dirclientes.direccion%%dirclientes.ciudad%%dirclientes.codpostal%%dirclientes.provincia%%paises.nombre%%"],
	[util.translate("scripts", "CONTACTOS CRM"), util.translate("scripts", "Contactos del módulo de ventas del CRM"), "crm_contactos,paises", "crm_contactos.codcontacto, crm_contactos.nombre, crm_contactos.telefono1, crm_contactos.email, crm_contactos.direccion, crm_contactos.ciudad, crm_contactos.provincia, paises.nombre", "crm_contactos LEFT OUTER JOIN paises ON crm_contactos.codpais = paises.codpais", "", "crm_contactos.codcontacto", "crm_contactos.nombre", "crm_contactos.telefono1", "crm_contactos.email", "crm_contactos.direccion%%crm_contactos.ciudad%%crm_contactos.provincia%%paises.nombre%%"],
	[util.translate("scripts", "PROVEEDORES"), util.translate("scripts", "Datos de proveedores y su dirección principal"), "proveedores,dirproveedores,paises", "proveedores.codproveedor, proveedores.nombre, proveedores.contacto, proveedores.email, proveedores.telefono1, dirproveedores.direccion, dirproveedores.ciudad, dirproveedores.codpostal, dirproveedores.provincia, paises.nombre", "proveedores INNER JOIN dirproveedores ON (proveedores.codproveedor = dirproveedores.codproveedor AND direccionppal = true) LEFT OUTER JOIN paises ON (dirproveedores.codpais = paises.codpais)", "1 = 1", "proveedores.codproveedor", "proveedores.nombre", "proveedores.telefono1", "proveedores.email", "dirproveedores.direccion%%dirproveedores.ciudad%%dirproveedores.codpostal%%dirproveedores.provincia%%paises.nombre%%"],
	[util.translate("scripts", "TARJETAS"), util.translate("scripts", "Datos de tarjetas"), "crm_tarjetas,paises", "crm_tarjetas.codtarjeta, crm_tarjetas.nombre, crm_tarjetas.contacto, crm_tarjetas.cifnif, crm_tarjetas.direccion, crm_tarjetas.ciudad, crm_tarjetas.codpostal, crm_tarjetas.provincia, crm_tarjetas.codpais, crm_tarjetas.telefono1, crm_tarjetas.telefono2, crm_tarjetas.fax, crm_tarjetas.email, paises.nombre", "crm_tarjetas LEFT OUTER JOIN paises ON (crm_tarjetas.codpais = paises.codpais)", "1 = 1", "crm_tarjetas.codtarjeta", "crm_tarjetas.nombre", "crm_tarjetas.telefono1", "crm_tarjetas.email", "crm_tarjetas.direccion%%crm_tarjetas.ciudad%%crm_tarjetas.codpostal%%crm_tarjetas.provincia%%paises.nombre%%"]];

	cursor = new FLSqlCursor("crm_consultasmark");
	for (var i:Number = 0; i < valores.length; i++) {
		with(cursor) {
			setModeAccess(cursor.Insert);
			refreshBuffer();
			setValueBuffer("codconsulta", valores[i][0]);
			setValueBuffer("descripcion", valores[i][1]);
			setValueBuffer("listatablas", valores[i][2]);
			setValueBuffer("campos", valores[i][3]);
			setValueBuffer("desde", valores[i][4]);
			setValueBuffer("donde", valores[i][5]);
			setValueBuffer("campoclave", valores[i][6]);
			setValueBuffer("camponombre", valores[i][7]);
			setValueBuffer("campotel", valores[i][8]);
			setValueBuffer("campoemail", valores[i][9]);
			setValueBuffer("campodir", valores[i][10]);
			if (!commitBuffer())
				return false;
		}
	}
	delete cursor;

	valores = [[util.translate("scripts", "CLIENTES ALTA"), util.translate("scripts", "Datos de clientes de alta con su dirección de envío"), util.translate("scripts", "CLIENTES ENV")],
	[util.translate("scripts", "CLIENTES"), util.translate("scripts", "Todos los clientes con su dirección de envío"), util.translate("scripts", "CLIENTES ENV")],
	[util.translate("scripts", "PROVEEDORES"), util.translate("scripts", "Todos los proveedores con su dirección principal"), util.translate("scripts", "PROVEEDORES")],
	[util.translate("scripts", "TARJETAS"), util.translate("scripts", "Todas las tarjetas"), util.translate("scripts", "TARJETAS")]];

	cursor = new FLSqlCursor("crm_listasmark");
	for (var i:Number = 0; i < valores.length; i++) {
		with(cursor) {
			setModeAccess(cursor.Insert);
			refreshBuffer();
			setValueBuffer("codlista", valores[i][0]);
			setValueBuffer("descripcion", valores[i][1]);
			setValueBuffer("codconsulta", valores[i][2]);
			if (!commitBuffer())
				return false;
		}
	}
	delete cursor;

	valores = [[util.translate("scripts", "CLIENTES ALTA"), util.translate("scripts", "De baja"), "Distinto de", "true", "clientes.debaja", "18"]];

	cursor = new FLSqlCursor("crm_criterioslista");
	for (var i:Number = 0; i < valores.length; i++) {
		with(cursor) {
			setModeAccess(cursor.Insert);
			refreshBuffer();
			setValueBuffer("codlista", valores[i][0]);
			setValueBuffer("nombre", valores[i][1]);
			setValueBuffer("condicion", valores[i][2]);
			setValueBuffer("valor", valores[i][3]);
			setValueBuffer("campo", valores[i][4]);
			setValueBuffer("tipo", valores[i][5]);
			if (!commitBuffer())
				return false;
		}
	}
	delete cursor;

	valores = [["0000000001", util.translate("scripts", "Campaña de ejemplo"), "Correo ordinario", util.translate("scripts", "ABIERTA"), hoy]];

	cursor = new FLSqlCursor("crm_campanas");
	for (var i:Number = 0; i < valores.length; i++) {
		with(cursor) {
			setModeAccess(cursor.Insert);
			refreshBuffer();
			setValueBuffer("codcampana", valores[i][0]);
			setValueBuffer("descripcion", valores[i][1]);
			setValueBuffer("canal", valores[i][2]);
			setValueBuffer("codestado", valores[i][3]);
			setValueBuffer("fechainicio", valores[i][4]);
			if (!commitBuffer())
				return false;
		}
	}
	delete cursor;

	var idAlias:Array = [];
	valores = [[util.translate("scripts", "CIUDAD"), "0000000001"], [util.translate("scripts", "CONTACTO"), "0000000001"],
	[util.translate("scripts", "CP"), "0000000001"],
	[util.translate("scripts", "DIRECCION"), "0000000001"],
	[util.translate("scripts", "NOMBRE"), "0000000001"],
	[util.translate("scripts", "PAIS"), "0000000001"],
	[util.translate("scripts", "PROVINCIA"), "0000000001"]];

	cursor = new FLSqlCursor("crm_aliascampana");
	for (var i:Number = 0; i < valores.length; i++) {
		with(cursor) {
			setModeAccess(cursor.Insert);
			refreshBuffer();
			setValueBuffer("alias", valores[i][0]);
			setValueBuffer("codcampana", valores[i][1]);
			if (!commitBuffer())
				return false;
			idAlias[i] = valueBuffer("idalias");
		}
	}
	delete cursor;

	var idLista:Array = [];
	valores = [["1", util.translate("scripts", "CLIENTES ALTA"), "0000000001", util.translate("scripts", "Datos de clientes de alta con su dirección de envío"), "Normal"], 
	["2", util.translate("scripts", "PROVEEDORES"), "0000000001", util.translate("scripts", "Todos los proveedores con su dirección principal"), "Normal"]];

	cursor = new FLSqlCursor("crm_listascampana");
	for (var i:Number = 0; i < valores.length; i++) {
		with(cursor) {
			setModeAccess(cursor.Insert);
			refreshBuffer();
			setValueBuffer("orden", valores[i][0]);
			setValueBuffer("codlista", valores[i][1]);
			setValueBuffer("codcampana", valores[i][2]);
			setValueBuffer("descripcion", valores[i][3]);
			setValueBuffer("tipo", valores[i][4]);
			if (!commitBuffer())
				return false;
			idLista[i] = valueBuffer("idlista");
		}
	}
	delete cursor;

	valores = [[idLista[0], idAlias[0], util.translate("scripts", "CIUDAD"), util.translate("scripts", "Ciudad en Direcciones de clientes"), "dirclientes.ciudad"],
	[idLista[0], idAlias[1], util.translate("scripts", "CONTACTO"), util.translate("scripts", "Contacto en Clientes"), "clientes.contacto"],
	[idLista[0], idAlias[2], util.translate("scripts", "CP"), util.translate("scripts", "Código postal en Direcciones de clientes"), "dirclientes.codpostal"],
	[idLista[0], idAlias[3], util.translate("scripts", "DIRECCION"), util.translate("scripts", "Dirección en Direcciones de clientes"), "dirclientes.direccion"],
	[idLista[0], idAlias[4], util.translate("scripts", "NOMBRE"), util.translate("scripts", "Nombre en Clientes"), "clientes.nombre"],
	[idLista[0], idAlias[5], util.translate("scripts", "PAIS"), util.translate("scripts", "Nombre en Países"), "paises.nombre"],
	[idLista[0], idAlias[6], util.translate("scripts", "PROVINCIA"), util.translate("scripts", "Provincia en Direcciones de clientes"), "dirclientes.provincia"],
	[idLista[1], idAlias[0], util.translate("scripts", "CIUDAD"), util.translate("scripts", "Ciudad en Direcciones de proveedores"), "dirproveedores.ciudad"],
	[idLista[1], idAlias[1], util.translate("scripts", "CONTACTO"), util.translate("scripts", "Contacto en Proveedores"), "proveedores.contacto"],
	[idLista[1], idAlias[2], util.translate("scripts", "CP"), util.translate("scripts", "Código postal en Direcciones de proveedores"), "dirproveedores.codpostal"],
	[idLista[1], idAlias[3], util.translate("scripts", "DIRECCION"), util.translate("scripts", "Dirección en Direcciones de proveedores"), "dirproveedores.direccion"],
	[idLista[1], idAlias[4], util.translate("scripts", "NOMBRE"), util.translate("scripts", "Nombre en Proveedores"), "proveedores.nombre"],
	[idLista[1], idAlias[5], util.translate("scripts", "PAIS"), util.translate("scripts", "Nombre en Países"), "paises.nombre"],
	[idLista[1], idAlias[6], util.translate("scripts", "PROVINCIA"), util.translate("scripts", "Provincia en Direcciones de proveedores"), "dirproveedores.provincia"]];

	cursor = new FLSqlCursor("crm_valoresalias");
	for (var i:Number = 0; i < valores.length; i++) {
		with(cursor) {
			setModeAccess(cursor.Insert);
			refreshBuffer();
			setValueBuffer("idlista", valores[i][0]);
			setValueBuffer("idalias", valores[i][1]);
			setValueBuffer("alias", valores[i][2]);
			setValueBuffer("nombre", valores[i][3]);
			setValueBuffer("campo", valores[i][4]);
			if (!commitBuffer())
				return false;
		}
	}
	delete cursor;
}

/** \D Actualiza los elementos de una lista manual cuando ésta proviene de una posición del módulo de análisis
@param	curLista: Cursor de la lista a actualizar
\end */
function oficial_actualizarListaAnalisis(curLista:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();

	var codLista:String = curLista.valueBuffer("codlista");
	var posicion:String = curLista.valueBuffer("posanalisis");
	var cubo:String = curLista.valueBuffer("cuboanalisis");

	if (!sys.isLoadedModule("fldireinne")) {
		MessageBox.warning(util.translate("scripts", "Para usar esta funcionalidad debe tener instalado el módulo de análisis"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	if (!formin_navegador.iface.pub_conectar()) {
		MessageBox.warning(util.translate("scripts", "Error al conectar a la base de datos de Anásis"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var aPos:Array = [];
	aPos["cubo"] = cubo;
	aPos["posicion"] = posicion;
	aPos["nombre"] = curLista.valueBuffer("descripcion");
	if (!formin_navegador.iface.pub_cambiarCubo(cubo)) {
		return false;
	}
	if (!formin_navegador.iface.pub_establecerPosicionArray(aPos)) {
		return false;
	}
	if (!formin_navegador.iface.pub_cargarDatos()) {
		return false;
	}
	if (!formin_navegador.iface.pub_renovarElementosListaMarketing(codLista)) {
		return false;
	}
	return true;
}

function oficial_valorConfigMarketing(nombreValor:String):String
{
	var util:FLUtil = new FLUtil;
	var valor:String = util.sqlSelect("crm_configmark", nombreValor, "1 = 1");
	return valor;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
