/***************************************************************************
                      vdisco.qs  -  description
                             -------------------
    begin                : vie jun 26 2004
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
    function init() { this.ctx.interna_init(); }
	function validateForm():Boolean { return this.ctx.interna_validateForm(); }
	function acceptedForm() { return this.ctx.interna_acceptedForm(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    function oficial( context ) { interna( context ); }
	function establecerFichero() {
		return this.ctx.oficial_establecerFichero();
	}
	function cabeceraPresentador():String {
		return this.ctx.oficial_cabeceraPresentador();
	}
	function cabeceraOrdenante():String {
		return this.ctx.oficial_cabeceraOrdenante();
	}
	function individualObligatorio(cursor:FLSqlCursor):String {
		return this.ctx.oficial_individualObligatorio(cursor);
	}
	function totalOrdenante(nRecibos:Number):String {
		return this.ctx.oficial_totalOrdenante(nRecibos);
	}
	function totalGeneral(nRecibos:Number):String {
		return this.ctx.oficial_totalGeneral(nRecibos);
	}
	function conceptoIO(qryRecibos:FLSqlQuery):String {
		return this.ctx.oficial_conceptoIO(qryRecibos);
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
/** \D No de muestran los botones estándar de un formulario de registro
\end */
function interna_init()
{
		with(form) {
				child("fdbDivisa").setDisabled(true);
				child("pushButtonAcceptContinue").close();
				child("pushButtonFirst").close();
				child("pushButtonLast").close();
				child("pushButtonNext").close();
				child("pushButtonPrevious").close();
				connect(child("pbExaminar"), "clicked()", this, "iface.establecerFichero");
		}
}

/** \C El nombre del fichero de destino debe indicarse
\end */
function interna_validateForm():Boolean
{
		if (this.child("leFichero").text.isEmpty()) {
				var util:FLUtil = new FLUtil();
				MessageBox.warning(util.
													 translate("scripts",
																		 "Hay que indicar el fichero."),
													 MessageBox.Ok, MessageBox.NoButton,
													 MessageBox.NoButton);
				return false;
		}
		
		if (!flfactteso.iface.pub_comprobarCuentasDom(this.cursor().valueBuffer("idremesa")))
			return false;
		
		return true;
}

/** \C Se genera el fichero de texto con los datos de la remesa en el fichero especificado
\end */
function interna_acceptedForm()
{
	var file:Object = new File(this.child("leFichero").text);
	file.open(File.WriteOnly);

	file.write(this.iface.cabeceraPresentador() + "\r\n");
	file.write(this.iface.cabeceraOrdenante() + "\r\n");

	var cursor:FLSqlCursor = this.cursor();

	var qryRecibos:FLSqlQuery = new FLSqlQuery();
	if (this.child("chkAgruparCliente").checked) {
		with (qryRecibos) {
			setTablesList("reciboscli");
			setSelect("SUM(importe), codcliente, nombrecliente, codcuenta, ctaentidad, ctaagencia, dc, cuenta");
			setFrom("reciboscli");
// 			setWhere("idremesa = " + cursor.valueBuffer("idremesa") + " GROUP BY codcliente, nombrecliente, codcuenta, ctaentidad, ctaagencia, dc, cuenta");
			setWhere("idrecibo IN (SELECT pd.idrecibo FROM pagosdevolcli pd WHERE pd.idremesa = " + cursor.valueBuffer("idremesa") + ") GROUP BY codcliente, nombrecliente, codcuenta, ctaentidad, ctaagencia, dc, cuenta");
			setForwardOnly(true);
		}
	} else {
		with (qryRecibos) {
			setTablesList("reciboscli");
			setSelect("importe, codigo, codcliente, nombrecliente, codcuenta, ctaentidad, ctaagencia, dc, cuenta");
			setFrom("reciboscli");
// 			setWhere("idremesa = " + cursor.valueBuffer("idremesa"));
			setWhere("idrecibo IN (SELECT pd.idrecibo FROM pagosdevolcli pd WHERE pd.idremesa = " + cursor.valueBuffer("idremesa") + ")");
			setForwardOnly(true);
		}
	}
	if (!qryRecibos.exec()) {
		return false;
	}

// 	var curRecibos:FLSqlCursor = new FLSqlCursor("reciboscli");
// 	curRecibos.select("idrecibo IN (SELECT idrecibo FROM pagosdevolcli WHERE idremesa = " + this.cursor().valueBuffer("idremesa") + ")");
// 	while (curRecibos.next())
// 			file.write(this.iface.individualObligatorio(curRecibos) + "\r\n");

	while (qryRecibos.next())
			file.write(this.iface.individualObligatorio(qryRecibos) + "\r\n");

// 	file.write(this.iface.totalOrdenante(curRecibos.size()) + "\r\n");
// 	file.write(this.iface.totalGeneral(curRecibos.size()) + "\r\n");

	file.write(this.iface.totalOrdenante(qryRecibos.size()) + "\r\n");
	file.write(this.iface.totalGeneral(qryRecibos.size()) + "\r\n");

	file.close();

    // Genera copia del fichero en codificacion ISO
    // ### Por hacer: Incluir mas codificaciones
    file.open( File.ReadOnly );
    var content = file.read();
    file.close();

    var fileIso = new File( this.child("leFichero").text + ".iso8859" );

    fileIso.open(File.WriteOnly);
    fileIso.write( sys.fromUnicode( content, "ISO-8859-15" ) );
    fileIso.close();

	var util:FLUtil = new FLUtil();
	MessageBox.information(util.translate("scripts", "Generado fichero de recibos en: \n\n%1\n\n").arg(this.child("leFichero").text),MessageBox.Ok, MessageBox.NoButton);
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_establecerFichero()
{
		this.child("leFichero").text = FileDialog.getSaveFileName("*.*");
}

/** \D Crea el texto de cabecera con los datos del presentador de la remesa
@return Texto con los dato para ser volcados a fichero
\end */
function oficial_cabeceraPresentador():String
{
		var util:FLUtil = new FLUtil();
		var reg:String = "5180";
		var cifnif:String = flfactppal.iface.pub_valorDefectoEmpresa("cifnif");
		var nombre:String = flfactppal.iface.pub_valorDefectoEmpresa("nombre");
		var codcuenta:String = this.cursor().valueBuffer("codcuenta");
		var entidad:String =
				util.sqlSelect("cuentasbanco", "ctaentidad",
											 "codcuenta = '" + codcuenta + "'");
		var agencia:String =
				util.sqlSelect("cuentasbanco", "ctaagencia",
											 "codcuenta = '" + codcuenta + "'");
		var sufijo:String =
				util.sqlSelect("cuentasbanco", "sufijo",
											 "codcuenta = '" + codcuenta + "'");
		sufijo = flfactppal.iface.pub_cerosIzquierda(sufijo, 3);
		var date:Date = new Date();
		var fecha =
				flfactppal.iface.pub_cerosIzquierda(date.getDate().toString(),
																	2) +
				flfactppal.iface.pub_cerosIzquierda(date.getMonth().toString(),
																	2) + date.getYear().toString().right(2);

		reg += flfactppal.iface.pub_cerosIzquierda(cifnif + sufijo, 12).right(12);
		reg += fecha;
		reg += flfactppal.iface.pub_espaciosDerecha("", 6);
		reg += flfactppal.iface.pub_espaciosDerecha(nombre, 40).left(40);
		reg += flfactppal.iface.pub_espaciosDerecha("", 20);
		reg += entidad + agencia;
		reg += flfactppal.iface.pub_espaciosDerecha("", 66);
		return reg;
}

/** \D Crea el texto de cabecera con los datos del ordenante de la remesa

@return Texto con los dato para ser volcados a fichero
\end */
function oficial_cabeceraOrdenante():String
{
		var util:FLUtil = new FLUtil();
		var cursor:String = this.cursor();
		var reg:String = "5380";
		var cifnif:String = flfactppal.iface.pub_valorDefectoEmpresa("cifnif");
		var nombre:String = flfactppal.iface.pub_valorDefectoEmpresa("nombre");
		var codcuenta:String = cursor.valueBuffer("codcuenta");
		var entidad:String =
				util.sqlSelect("cuentasbanco", "ctaentidad",
											 "codcuenta = '" + codcuenta + "'");
		var agencia:String =
				util.sqlSelect("cuentasbanco", "ctaagencia",
											 "codcuenta = '" + codcuenta + "'");
		var cuenta:String =
				util.sqlSelect("cuentasbanco", "cuenta",
											 "codcuenta = '" + codcuenta + "'");
		var sufijo:String =
				util.sqlSelect("cuentasbanco", "sufijo",
											 "codcuenta = '" + codcuenta + "'");
		sufijo = flfactppal.iface.pub_cerosIzquierda(sufijo, 3);
		var date:Date = new Date();
		var fecha:String =
				flfactppal.iface.pub_cerosIzquierda(date.getDate().toString(),
																	2) +
				flfactppal.iface.pub_cerosIzquierda(date.getMonth().toString(),
																	2) + date.getYear().toString().right(2);
		var dc1:String = util.calcularDC(entidad + agencia);
		var dc2:String = util.calcularDC(cuenta);
		date = new Date(cursor.valueBuffer("fechacargo"));
		var fechaCargo:String =
				flfactppal.iface.pub_cerosIzquierda(date.getDate().toString(),
																	2) +
				flfactppal.iface.pub_cerosIzquierda(date.getMonth().toString(),
																	2) + date.getYear().toString().right(2);

		reg += flfactppal.iface.pub_cerosIzquierda(cifnif + sufijo, 12).right(12);
		reg += fecha + fechaCargo;
		reg += flfactppal.iface.pub_espaciosDerecha(nombre, 40).left(40);
		reg += entidad + agencia + dc1 + dc2 + cuenta;
		reg += flfactppal.iface.pub_espaciosDerecha("", 8);
		reg += "01";
		reg += flfactppal.iface.pub_espaciosDerecha("", 64);
		return reg;
}

/** \D Crea el texto de cabecera con los datos del presentador de la remesa

@param cursor Cursor del registro de un recibo
@return Texto con los dato para ser volcados a fichero
\end */
//function oficial_individualObligatorio(cursor:FLSqlCursor):String
// {
// 		var util:FLUtil = new FLUtil();
// 		var reg:String = "5680";
// 		var cifnif:String = flfactppal.iface.pub_valorDefectoEmpresa("cifnif");
// 		var ref:String = cursor.valueBuffer("codcliente").right(6);
// 		var concepto = "R." + cursor.valueBuffer("codigo");
// 		concepto = flfactppal.iface.pub_espaciosDerecha(concepto, 17).left(17);
// 		var nombre:String = cursor.valueBuffer("nombrecliente");
// 		var entidad:String = cursor.valueBuffer("ctaentidad");
// 		var agencia:String = cursor.valueBuffer("ctaagencia");
// 		var dc:String = cursor.valueBuffer("dc");
// 		var cuenta:String = cursor.valueBuffer("cuenta");
// 		var codcuenta:String = this.cursor().valueBuffer("codcuenta");
// 		var sufijo:String =
// 				util.sqlSelect("cuentasbanco", "sufijo",
// 											 "codcuenta = '" + codcuenta + "'");
// 		sufijo = flfactppal.iface.pub_cerosIzquierda(sufijo, 3);
// 		var importe:Number = Math.round(cursor.valueBuffer("importe") * 100);
// 
// 		reg += flfactppal.iface.pub_cerosIzquierda(cifnif + sufijo, 12).right(12);
// 		reg += flfactppal.iface.pub_espaciosDerecha(ref, 12);
// 		reg += flfactppal.iface.pub_espaciosDerecha(nombre, 40).left(40);
// 		reg += entidad + agencia + dc + cuenta;
// 		reg += flfactppal.iface.pub_cerosIzquierda(importe, 10).right(10);
// 		reg += flfactppal.iface.pub_cerosIzquierda(0, 16);
// 		reg += concepto;
// 		reg += flfactppal.iface.pub_espaciosDerecha("", 31);
// 		return reg;
// }

function oficial_individualObligatorio(qryRecibos:FLSqlQuery):String
{
	var util:FLUtil = new FLUtil();
	var reg:String = "5680";
	var cifnif:String = flfactppal.iface.pub_valorDefectoEmpresa("cifnif");
	var codCliente:String = qryRecibos.value("codcliente").right(6);
	var ref:String = codCliente;
	var concepto = this.iface.conceptoIO(qryRecibos);
	concepto = flfactppal.iface.pub_espaciosDerecha(concepto, 17).left(17);
	var nombre:String = flfacturac.iface.pub_formateaCadena(qryRecibos.value("nombrecliente"));
	var cuentaCompleta:String = "";
	var entidad:String = qryRecibos.value("ctaentidad");
	cuentaCompleta += entidad;
	var agencia:String = qryRecibos.value("ctaagencia");
	cuentaCompleta += agencia;
	var dc:String = qryRecibos.value("dc");
	cuentaCompleta += dc;
	var cuenta:String = qryRecibos.value("cuenta");
	cuentaCompleta += cuenta;
	if (!cuentaCompleta || cuentaCompleta.length != 20) {
		MessageBox.warning(util.translate("scripts", "Error al generar el registro individual obigatorio para el cliente %1:\nLa cuenta bancaria no tiene la longitud correcta: %2").arg(codCliente).arg(cuentaCompleta), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var codcuenta:String = this.cursor().valueBuffer("codcuenta");
	var sufijo:String = util.sqlSelect("cuentasbanco", "sufijo", "codcuenta = '" + codcuenta + "'");
	sufijo = flfactppal.iface.pub_cerosIzquierda(sufijo, 3);
	var importe:Number;
	if (this.child("chkAgruparCliente").checked) {
		importe = Math.round(qryRecibos.value("SUM(importe)") * 100);
	} else {
		importe = Math.round(qryRecibos.value("importe") * 100);
	}

	reg += flfactppal.iface.pub_cerosIzquierda(cifnif + sufijo, 12).right(12);
	reg += flfactppal.iface.pub_espaciosDerecha(ref, 12);
	reg += flfactppal.iface.pub_espaciosDerecha(nombre, 40).left(40);
	reg += entidad + agencia + dc + cuenta;
	reg += flfactppal.iface.pub_cerosIzquierda(importe, 10).right(10);
	reg += flfactppal.iface.pub_cerosIzquierda(0, 16);
	reg += concepto;
	reg += flfactppal.iface.pub_espaciosDerecha("", 31);
	return reg;
}

function oficial_conceptoIO(qryRecibos:FLSqlQuery):String
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var concepto:String = "";
	if (this.child("chkAgruparCliente").checked) {
		concepto = "Fra";
		var qryFras:FLSqlQuery = new FLSqlQuery;
		with (qryFras) {
			setTablesList("reciboscli");
			setSelect("idfactura");
			setFrom("reciboscli");
			setWhere("idremesa = " + cursor.valueBuffer("idremesa") + " AND codcliente = '" + qryRecibos.value("codcliente") + "' AND codcuenta = '" + qryRecibos.value("codcuenta") + "' GROUP BY idfactura");
			setForwardOnly(true);
		}
		if (!qryFras.exec()) {
			return false;
		}
		while (qryFras.next()) {
			var numFactura:String = util.sqlSelect("facturascli", "numero", "idfactura = " + qryFras.value("idfactura"));
			if (!numFactura) {
				numFactura = "";
			}
			if (concepto.length + numFactura.toString().length + 1 > 17) {
				break;
			}
			if (concepto == "Fra") {
				concepto += " " + numFactura;
			} else {
				concepto += "," + numFactura;
			}
		}
	} else {
		concepto = "R." + qryRecibos.value("codigo");
	}
	return concepto;
}

/** \D Calcula el total del valor de recibos para el ordenante
@param nRecibos Número de recibos
@return Texto con el total para ser volcado a disco
\end */
function oficial_totalOrdenante(nRecibos:Number):String
{
		var util:FLUtil = new FLUtil();
		var cursor:FLSqlCursor = this.cursor();
		var reg:String = "5880";
		var cifnif:String = flfactppal.iface.pub_valorDefectoEmpresa("cifnif");
		var nombre:String = flfactppal.iface.pub_valorDefectoEmpresa("nombre");
		var codcuenta:String = cursor.valueBuffer("codcuenta");
		var sufijo:String =
				util.sqlSelect("cuentasbanco", "sufijo",
											 "codcuenta = '" + codcuenta + "'");
		sufijo = flfactppal.iface.pub_cerosIzquierda(sufijo, 3);
		var total:Number = Math.round(cursor.valueBuffer("total") * 100);

		reg += flfactppal.iface.pub_cerosIzquierda(cifnif + sufijo, 12).right(12);
		reg += flfactppal.iface.pub_espaciosDerecha("", 72);
		reg += flfactppal.iface.pub_cerosIzquierda(total, 10).right(10);
		reg += flfactppal.iface.pub_espaciosDerecha("", 6);
		reg += flfactppal.iface.pub_cerosIzquierda(nRecibos, 10).right(10);
		reg += flfactppal.iface.pub_cerosIzquierda(nRecibos + 2, 10).right(10);
		reg += flfactppal.iface.pub_espaciosDerecha("", 38);
		return reg;
}

/** \D Calcula el total del valor de recibos general

@param nRecibos Número de recibos
@return Texto con el total para ser volcado a disco
\end */
function oficial_totalGeneral(nRecibos:Number):String
{
		var util:FLUtil = new FLUtil();
		var cursor:FLSqlCursor = this.cursor();
		var reg:String = "5980";
		var cifnif:String = flfactppal.iface.pub_valorDefectoEmpresa("cifnif");
		var nombre:String = flfactppal.iface.pub_valorDefectoEmpresa("nombre");
		var codcuenta:String = cursor.valueBuffer("codcuenta");
		var sufijo:String =
				util.sqlSelect("cuentasbanco", "sufijo",
											 "codcuenta = '" + codcuenta + "'");
		sufijo = flfactppal.iface.pub_cerosIzquierda(sufijo, 3);
		var total:Number = Math.round(cursor.valueBuffer("total") * 100);

		reg += flfactppal.iface.pub_cerosIzquierda(cifnif + sufijo, 12).right(12);
		reg += flfactppal.iface.pub_espaciosDerecha("", 52);
		reg += flfactppal.iface.pub_cerosIzquierda(1, 4);
		reg += flfactppal.iface.pub_espaciosDerecha("", 16);
		reg += flfactppal.iface.pub_cerosIzquierda(total, 10).right(10);
		reg += flfactppal.iface.pub_espaciosDerecha("", 6);
		reg += flfactppal.iface.pub_cerosIzquierda(nRecibos, 10).right(10);
		reg += flfactppal.iface.pub_cerosIzquierda(nRecibos + 4, 10).right(10);
		reg += flfactppal.iface.pub_espaciosDerecha("", 38);
		return reg;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
