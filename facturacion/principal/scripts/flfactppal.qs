function calcularIBAN(cuenta, codPais) {
	return this.ctx.oficial_calcularIBAN(cuenta, codPais);
}
function digitoControlMod97(numero, codPais) {
	return this.ctx.oficial_digitoControlMod97(numero, codPais);
}
function moduloNumero(num, div) {
	return this.ctx.oficial_moduloNumero(num, div);
}

/////////////////////////////////////////////////////////////////

function pub_calcularIBAN(cuenta, codPais) {
	return this.calcularIBAN(cuenta, codPais);
}
function pub_digitoControlMod97(numero, codPais) {
	return this.digitoControlMod97(numero, codPais);
}
function pub_moduloNumero(num, div) {
	return this.moduloNumero(num, div);
}

/////////////////////////////////////////////////////////////////


function oficial_calcularIBAN(cuenta, codPais)
{
	var _i = this.iface;
	var IBAN = "";
	
	if (!cuenta || cuenta == "") {
		return "";
	}
	var codIso;
	if (codPais && codPais != "") {
		codIso = AQUtil.sqlSelect("paises", "codiso", "codpais = '" + codPais + "'");
		codIso = (!codIso || codIso == "") ? "ES" : codIso;
	} else {
		codIso = "ES";
	}
	var digControl = _i.digitoControlMod97(cuenta, codIso);
	IBAN += codIso + digControl + cuenta;
	
	return IBAN;
}


function oficial_moduloNumero(num, div)
{
	var d, i = 0, a = 1;
	var parcial = 0;
	for (i = num.length - 1; i >= 0 ; i--) {
		d = parseInt(num.charAt(i));
		parcial += (d * a);
		a = (a * 10) % div;
	}
	return parcial % div;
}


function oficial_digitoControlMod97(numero, codPais)
{
	var _i = this.iface;
	var cadena = "";

	cadena += numero.toString() + codPais.toUpperCase() + "00";
	
	for(var i = 0; i < cadena.length; i++) {
		if(isNaN(cadena.charAt(i))) {
			var trans = cadena.charCodeAt(i) - 55;
			cadena = cadena.replace(cadena.charAt(i),trans);
		}
	}

	var digControl = _i.moduloNumero(cadena, 97);
	digControl = 98 - digControl;
		
	digControl = flfactppal.iface.pub_cerosIzquierda(digControl, 2);
	
	return digControl;
}


