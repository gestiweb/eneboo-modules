/***************************************************************************
                 pr_configprod.qs  -  description
                             -------------------
    begin                : mar jun 15 2010
    copyright            : (C) 2010 by InfoSiAL S.L.
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
	function calculateField(fN:String):String {
		return this.ctx.interna_calculateField(fN);
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    function oficial( context ) { interna( context ); }
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function tbnCrear_clicked() {
		return this.ctx.oficial_tbnCrear_clicked();
	}
	function calcularTotalPackaging() {
		return this.ctx.oficial_calcularTotalPackaging();
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
function interna_init()
{
	var cursor:FLSqlCursor = this.cursor();
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this.child("tbnCrear"), "clicked()", this, "iface.tbnCrear_clicked");
	connect(this.child("tdbLineasPackInformation").cursor(), "bufferCommited()", this, "iface.calcularTotalPackaging");
	this.child("txtError").close();
}

function interna_calculateField(fN:String):String
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil;
	var valor:String;
	var step:Number = cursor.isNull("step") ? 0 : cursor.valueBuffer("step");
	var bruttoWeight:Number = cursor.isNull("bruttoweight") ? 0 : cursor.valueBuffer("bruttoweight");
	var density:Number = cursor.isNull("density") ? 0 : cursor.valueBuffer("density");
	var kgMpProd:Number = cursor.isNull("kgmpprod") ? 0 : cursor.valueBuffer("kgmpprod");
	var bandWideNess:Number = cursor.isNull("bandwideness") ? 0 : cursor.valueBuffer("bandwideness");
	var bandThickNess:Number = cursor.isNull("bandthickness") ? 0 : cursor.valueBuffer("bandthickness");
	var totalCavitiesTool:Number = cursor.isNull("totalcavitiestool") ? 0 : cursor.valueBuffer("totalcavitiestool");
	var netWeight:Number = cursor.isNull("netweight") ? 0 : cursor.valueBuffer("netweight");
	var alturapiezaextr:Number = cursor.isNull("alturapiezaextr") ? 0 : cursor.valueBuffer("alturapiezaextr");
	var alturapiezaextropu:Number = cursor.isNull("alturapiezaextropu") ? 0 : cursor.valueBuffer("alturapiezaextropu");
	var anchurapieza:Number = cursor.isNull("anchurapieza") ? 0 : cursor.valueBuffer("anchurapieza");
	var longpieza:Number = cursor.isNull("longpieza") ? 0 : cursor.valueBuffer("longpieza");
	
	var costHMachine:Number = cursor.isNull("costhmachine") ? 0 : cursor.valueBuffer("costhmachine");
	var costHManipulator:Number = cursor.isNull("costhmanipulator") ? 0 : cursor.valueBuffer("costhmanipulator");
	var costHAdditWorker:Number = cursor.isNull("costhadditworker") ? 0 : cursor.valueBuffer("costhadditworker");
	var costHMachineWorker:Number = cursor.isNull("costhmachineworker") ? 0 : cursor.valueBuffer("costhmachineworker");
	
	var scrapWeight:Number = cursor.valueBuffer("scrapweight");
	var costHMachineWorker:Number = cursor.isNull("costhmachineworker") ? 0 : cursor.valueBuffer("costhmachineworker");
	var partsPerPackUnitPeso:Number = cursor.isNull("partsperpackunitpeso") ? 0 : cursor.valueBuffer("partsperpackunitpeso");
	var cyclestampshour:Number = cursor.isNull("cyclestampshour") ? 0 : cursor.valueBuffer("cyclestampshour");
	var yearlyProduction:Number = cursor.isNull("yearlyproduction") ? 0 : cursor.valueBuffer("yearlyproduction");
	var numberyearlyproductions:Number = cursor.isNull("numberyearlyproductions") ? 0 : cursor.valueBuffer("numberyearlyproductions");
	var toolInvestment:Number = cursor.isNull("toolinvestment") ? 0 : cursor.valueBuffer("toolinvestment");
	var pesoBobina:Number = cursor.isNull("pesobobina") ? 0 : cursor.valueBuffer("pesobobina");
	var longBobina:Number = cursor.isNull("longbobina") ? 0 : cursor.valueBuffer("longbobina");
	var packTypeSelect:Number = cursor.isNull("packtypeselect") ? 0 : cursor.valueBuffer("packtypeselect");
	var numberPiecesPerProduction:Number = cursor.isNull("numberpiecesperproduction") ? 0 : cursor.valueBuffer("numberpiecesperproduction");
	var numPiezasBobina:Number = cursor.isNull("numpiezasbobina") ? 0 : cursor.valueBuffer("numpiezasbobina");
	var totalPartsPerPaletBox:Number = cursor.isNull("totalpartsperpaletbox") ? 0 : cursor.valueBuffer("totalpartsperpaletbox");
	var boxesPerPallet:Number = cursor.isNull("boxesPerPallet") ? 0 : cursor.valueBuffer("boxesPerPallet");
	var palletsPerTruck:Number = cursor.isNull("palletspertruck") ? 0 : cursor.valueBuffer("palletspertruck");
	var kgPrice:Number = cursor.isNull("kgprice") ? 0 : cursor.valueBuffer("kgprice");
	var scrapReturn:Number = cursor.isNull("scrapreturn") ? 0 : cursor.valueBuffer("scrapreturn");
	var lotCompraMp:Number = cursor.isNull("lotcompramp") ? 0 : cursor.valueBuffer("lotcompramp");
	var euribor:Number = cursor.isNull("euribor") ? 0 : cursor.valueBuffer("euribor");
	var bobinasProd:Number = cursor.isNull("bobinasprod") ? 0 : cursor.valueBuffer("bobinasprod");
	var rawMaterial:Number = cursor.isNull("rawmaterial") ? 0 : cursor.valueBuffer("rawmaterial");
	var porRmHandling:Number = cursor.isNull("porrmhandling") ? 0 : cursor.valueBuffer("porrmhandling");
	var porScrapReturn:Number = cursor.isNull("porscrapreturn") ? 0 : cursor.valueBuffer("porscrapreturn");
	var rmHandling:Number = cursor.isNull("rmhandling") ? 0 : cursor.valueBuffer("rmhandling");
	var totalCostperHour:Number = cursor.isNull("totalcostperhour") ? 0 : cursor.valueBuffer("totalcostperhour");
	var totalPartsHour:Number = cursor.isNull("totalpartshour") ? 0 : cursor.valueBuffer("totalpartshour");
	var setUpTool:Number = cursor.isNull("setuptool") ? 0 : cursor.valueBuffer("setuptool");
	var costhSetupOperation:Number = cursor.isNull("costhsetupoperation") ? 0 : cursor.valueBuffer("costhsetupoperation");
	var totalPackagingInformation:Number = cursor.isNull("totalpackaginginformation") ? 0 : cursor.valueBuffer("totalpackaginginformation");
	var partsPerTruck:Number = cursor.isNull("partspertruck") ? 0 : cursor.valueBuffer("partspertruck");
	var truckCosts:Number = cursor.isNull("truckcosts") ? 0 : cursor.valueBuffer("truckcosts");
	var stampingInformation:Number = cursor.isNull("stampinginformation") ? 0 : cursor.valueBuffer("stampinginformation");
	var setupInformation:Number = cursor.isNull("setupinformation") ? 0 : cursor.valueBuffer("setupinformation");
	var procuredPartsInformation:Number = cursor.isNull("procuredpartsinformation") ? 0 : cursor.valueBuffer("procuredpartsinformation");
	var addopersInfo:Number = cursor.isNull("addopersinfo") ? 0 : cursor.valueBuffer("addopersinfo");
	var packagingInformation:Number = cursor.isNull("packaginginformation") ? 0 : cursor.valueBuffer("packaginginformation");
	var transportInformation:Number = cursor.isNull("transportinformation") ? 0 : cursor.valueBuffer("transportinformation");
	var porCosteFincmppiez:Number = cursor.isNull("porcostefincmppiez") ? 0 : cursor.valueBuffer("porcostefincmppiez");
	var subtotalSummary:Number = cursor.isNull("subtotalsummary") ? 0 : cursor.valueBuffer("subtotalsummary");
	var subtotalSummary2:Number = cursor.isNull("subtotalsummary2") ? 0 : cursor.valueBuffer("subtotalsummary2");
	var porBenefits:Number = cursor.isNull("porbenefits") ? 0 : cursor.valueBuffer("porbenefits");
	var costeFincmppiez:Number = cursor.isNull("costefincmppiez") ? 0 : cursor.valueBuffer("costefincmppiez");
	var benefits:Number = cursor.isNull("benefits") ? 0 : cursor.valueBuffer("benefits");
	var priceperUnitddu:Number = cursor.isNull("priceperunitddu") ? 0 : cursor.valueBuffer("priceperunitddu");

	switch (fN) {
// 		case "packtypedescription":
// 			var packTypeSelect:Number = cursor.isNull("packtypeselect") ? 0 : cursor.valueBuffer("packtypeselect");
// 			switch (packTypeSelect) {
// 				case 3: 
// 					valor = "Comepack Nº3";
// 					break;
// 				case 5: 
// 					valor = "Comepack Nº5";
// 					break;
// 				case 6: 
// 					valor = "Comepack Nº6";
// 					break;
// 				default: 
// 					valor = "KTP";
// 					break;
// 			}
// 			break;
		case "lotcompramp": {
			switch(density) {
				case 2.7: 
					if (kgMpProd > density) 
						valor = kgMpProd;
					else
						valor = "6500";
					break;
			}
			break;
		}
		case "bruttoweight": {
			if (totalCavitiesTool == 0) {
				valor = 0;
			} else {
				valor = (step*density*bandWideNess*bandThickNess) / (1000000*totalCavitiesTool);
			}
			break;
		}
		case "scrapweight": {
			valor = (bruttoWeight-netWeight)*1000;
			valor = Math.round(valor)
			valor = valor/1000;
			break;
		}
		case "volexcripieza": {
			valor = (alturapiezaextr+alturapiezaextropu)/2*anchurapieza*longpieza/1000000*2;
			break;
		}
		case "totalcostperhour": {
			valor = costHMachine + costHAdditWorker + costHManipulator + costHMachineWorker;
			break;
		}
		case "txtError": {
			if (scrapWeight < 0) {
				this.child("txtError").show();
			}
			else {
				this.child("txtError").close();
			}
			break;
		}
		case "cyclestampshour": {
			var veloProceso:Number = util.sqlSelect("pr_maquinas","velocidadproceso","codmaquina = '" + cursor.valueBuffer("codmaquina") + "'");
			var valorParcial:Number = (525*525-200*200)*bandWideNess*density*Math.PI/1000000;
			valorParcial = valorParcial > 1000 ? 1000 : valorParcial;
			valor = (Math.floor((costHMachineWorker*60/50)/(((2*15)/((((valorParcial)/(((step*density*bandWideNess*bandThickNess)/(1000000*totalCavitiesTool)))*step)-3000)/step))+1.5/partsPerPackUnitPeso+1/veloProceso)/50))*50;
			break;
		}
		case "cycleseconds": {
			valor = 1/(cyclestampshour/3600);
			break; 
		}
		case "totalpartshour": {
			valor = cyclestampshour*totalCavitiesTool;
			break;
		}
		case "costhsetupoperation": {
			valor = costHMachine+costHMachineWorker;
			break;
		}
		case "numberpiecesperproduction": {
			valor = yearlyProduction/numberyearlyproductions;
			break;
		}
		case "setuptool": {
			valor = (((Math.log(bandWideNess) / Math.LN10) + (Math.log(bandThickNess+1)  / Math.LN10) - ((Math.log(step) / Math.LN10)-0.5)) + (toolInvestment/10000))/2;
// debug("(Math.log(bandWideNess) / Math.LN10) = " + (Math.log(bandWideNess) / Math.LN10));
// debug("(Math.log(bandThickNess+1)  / Math.LN10 = " + (Math.log(bandThickNess+1)  / Math.LN10));
// debug("(Math.log(step) / Math.LN10) = " + (Math.log(step) / Math.LN10));
// debug("(toolInvestment/1000) = " + (toolInvestment/10000));
// 			=((LOG(F22)+LOG(F23+1)-(LOG(I19)-0,5))+(F32/10000))/2
			break;
		}
		case "numberyearlyproductions": {
			var valorParcial:Number = (550*550-200*200)*bandWideNess*density*Math.PI/1000000;
			valorParcial = valorParcial > 1000 ? 1000 : valorParcial;
			var valorParcial2:Number = yearlyProduction / (((valorParcial * step / bruttoWeight / 1000) - 3 - 30 * step / 1000) / step * 1000);
			if (valorParcial2 < 12) {
				valor = valorParcial2;
			} else {
				valor = valorParcial2 / (1 + Math.floor((yearlyProduction / (((valorParcial * step / bruttoWeight / 1000) - 3 - 30 * step / 1000) / step * 1000)) / 12));
			}
/// =SI(G49/(((vP*I19/I21/1000)-3-30*I19/1000)/I19*1000)<12;G49/(((vP*I19/I21/1000)-3-30*I19/1000)/I19*1000);(G49/(((vP*I19/I21/1000)-3-30*I19/1000)/I19*1000))/(1+INT((G49/(((vP*I19/I21/1000)-3-30*I19/1000)/I19*1000))/12)))
			break;
		}
		case "v": {
			var codMaquina:String = cursor.isNull("codmaquina") ? 0 : cursor.valueBuffer("codmaquina");
			var valorParcial:Number = (525*525-200*200)*bandWideNess*density*Math.PI/1000000;
			valorParcial = valorParcial > 1000 ? 1000 : valorParcial;
			var valorParcial2:Number = codMaquina == "metralleta" ? 110 : 55;
			valor = 60/(((2*15)/((((valorParcial)/(((step*density*bandWideNess*bandThickNess)/(1000000*totalCavitiesTool)))*step)-3000)/step))+1.5/partsPerPackUnitPeso+1/(valorParcial2));
			break;
		}
		case "pesobobina": {
			valor = (550*550-200*200)*bandWideNess*density*Math.PI/1000000;
			valor = valor > 1000 ? 1000 : valor;
			break;
		}
		case "longbobina": {
			valor = (pesoBobina*step/bruttoWeight/1000);
			break;
		}
		case "numpiezasbobina": {
			valor = ((longBobina-3-30*step/1000)/step*1000);
			break;
		}
		case "pesocontenedor": {
			var valorParcial:Number = util.sqlSelect("pr_packagingtype", "factorppp", "packtypeselect = '" + cursor.valueBuffer("packtypeselect") + "'");
// 			switch (packTypeSelect) {
// 				case 3:
// 					valorParcial = 3.6;
// 					break;
// 				case 5:
// 					valorParcial = 2.9;
// 					break;
// 				case 6:
// 					valorParcial = 1.5;
// 					break;
// 				default:
// 					valorParcial = 0;
// 					break;
// 			}
			valor = partsPerPackUnitPeso*netWeight+valorParcial;
			break;
		}
		case "bobinasprod": {
			valor = numberPiecesPerProduction/numPiezasBobina;
			break;
		}
		case "pesocamion": {
			var valorParcial:Number = util.sqlSelect("pr_packagingtype", "factorppp", "packtypeselect = '" + cursor.valueBuffer("packtypeselect") + "'");
// 			switch (packTypeSelect) {
// 				case 6:
// 					valorParcial = 1.5;
// 					break;
// 				case 5:
// 					valorParcial = 2.9;
// 					break;
// 				case 4:
// 					valorParcial = 3.8;
// 					break;
// 				case 3:
// 					valorParcial = 3.6;
// 					break;
// 			}
			valor = 75+56+(15.5+totalPartsPerPaletBox*netWeight+boxesPerPallet*valorParcial)*palletsPerTruck;
			break;
		}
		case "retornxatarraa": {
			valor = scrapReturn*kgPrice;
			break;
		}
		case "costfinancmp": {
			valor = ((2+lotCompraMp/(yearlyProduction*bruttoWeight)*12)/12*euribor/100);
			break;
		}
		case "costfinancpiezas": {
			valor = (euribor)/numberyearlyproductions/100;
			break;
		}
		case "kgmpprod": {
			valor = bobinasProd/pesoBobina;
			break;
		}
		case "partsperpackunitpeso": {
			var valorParcial:Number = util.sqlSelect("pr_packagingtype", "factorppp", "packtypeselect = '" + cursor.valueBuffer("packtypeselect") + "'");
			/*switch(packTypeSelect) {
				case 3:
					valorParcial = util,3.6;
					break;
				case 5:
					valorParcial = 2.9;
					break;
				case 6:
					valorParcial = 1.5;
					break;
				default:
					valor = "INTRODUCIR";
					break;
			}
			*/
			valor = Math.floor(((15-valorParcial)/netWeight)/25)*25+50;
			break;
		}
		case "rawmaterial": {
			valor = kgPrice * bruttoWeight;
			if (isNaN(valor)) {
				valor = 0;
			}
			valor = valor * 10000;
			valor = Math.round(valor);
			valor = valor / 10000;
			break;
		}
		case "rmhandling": {
			valor = (rawMaterial * porRmHandling) / 100;
			valor = valor * 10000;
			valor = Math.round(valor);
			valor = valor / 10000;
			break;
		}
		case "scrapreturn": {
			valor = (porScrapReturn * scrapWeight * kgPrice) / 100;
			valor = valor * 10000;
			valor = Math.round(valor);
			valor = valor / 10000;
			break;
		}
		case "subtotalsummary": {
			valor = (rawMaterial + rmHandling) - scrapReturn;
			valor = valor * 10000;
			valor = Math.round(valor);
			valor = valor / 10000;
			break;
		}
		case "stampinginformation": {
			valor = (totalPartsHour == 0 ? 0 : totalCostperHour / totalPartsHour);
			if (isNaN(valor)) {
				valor = 0;
			}
			valor = valor * 10000;
			valor = Math.round(valor);
			valor = valor / 10000;
			break;
		}
		case "setupinformation": {
			valor = (numberPiecesPerProduction == 0 ? 0 : (setUpTool * costhSetupOperation) / numberPiecesPerProduction);
			if (isNaN(valor)) {
				valor = 0;
			}
			valor = valor * 10000;
			valor = Math.round(valor);
			valor = valor / 10000;
			break;
		}
		case "packaginginformation": {
			valor = (totalPartsPerPaletBox == 0 ? 0 : (totalPackagingInformation / totalPartsPerPaletBox));
			if (isNaN(valor)) {
				valor = 0;
			}
			valor = valor * 10000;
			valor = Math.round(valor);
			valor = valor / 10000;
			break;
		}
		case "totalpackaginginformation": {
			valor = util.sqlSelect("pr_lineaspackinformation", "SUM(subtotal)", "idconfigprod = " + cursor.valueBuffer("id"));
			if (isNaN(valor)) {
				valor = 0;
			}
			valor = valor * 10000;
			valor = Math.round(valor);
			valor = valor / 10000;
			break;
		}
		case "transportinformation": {
			valor = (partsPerTruck == 0 ? 0 : (truckCosts / partsPerTruck));
			if (isNaN(valor)) {
				valor = 0;
			}
			valor = valor * 10000;
			valor = Math.round(valor);
			valor = valor / 10000;
			break;
		}
		case "subtotalsummary2": {
			valor = parseFloat(stampingInformation) + parseFloat(setupInformation) + parseFloat(procuredPartsInformation) + parseFloat(addopersInfo) + parseFloat(packagingInformation) + parseFloat(transportInformation);
			if (isNaN(valor)) {
				valor = 0;
			}
			valor = valor * 10000;
			valor = Math.round(valor);
			valor = valor / 10000;
			break;
		}
		case "costefincmppiez": {
			valor = (porCosteFincmppiez * (parseFloat(subtotalSummary) + parseFloat(subtotalSummary2))) / 100;
			if (isNaN(valor)) {
				valor = 0;
			}
			valor = valor * 10000;
			valor = Math.round(valor);
			valor = valor / 10000;
			break;
		}
		case "benefits": {
			valor = (porBenefits * parseFloat(subtotalSummary2)) / 100;
			if (isNaN(valor)) {
				valor = 0;
			}
			valor = valor * 10000;
			valor = Math.round(valor);
			valor = valor / 10000;
			break;
		}
		case "priceperunitddu": {
			valor = parseFloat(benefits) + parseFloat(subtotalSummary) + parseFloat(subtotalSummary2) + parseFloat(costeFincmppiez);
			if (isNaN(valor)) {
				valor = 0;
			}
			valor = valor * 10000;
			valor = Math.round(valor);
			valor = valor / 10000;
			break;
		}
		case "priceper100unitsddu": {
			valor = priceperUnitddu * 100;
			if (isNaN(valor)) {
				valor = 0;
			}
			valor = valor * 10000;
			valor = Math.round(valor);
			valor = valor / 10000;
			break;
		}
		case "palletspertruck": {
			var factorPPP:Number = util.sqlSelect("pr_packagingtype", "factorppp", "packtypeselect = '" + cursor.valueBuffer("packtypeselect") + "'");
			var valorParcial:Number = (2320-75)/(15.5+totalPartsPerPaletBox*netWeight+boxesPerPallet*factorPPP);
			valor = valorParcial > 14 ? 14 : valorParcial;
			valor = Math.floor(valor);
// 		=SI(((2320-75)/(15,5+P21*G19+P20*factorPPP))>14;14;((2320-75)/(15,5+P21*G19+P20*factorPPP)))
			break;
		}
	}
	return valor;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_bufferChanged(fN:String)
{
	var cursor:FLSqlCursor = this.cursor();
	debug(fN);
	switch (fN) {
		case "packtypeselect": {
// 			cursor.setValueBuffer("packtypedescription", this.iface.calculateField("packtypedescription"));
			cursor.setValueBuffer("pesobobina", this.iface.calculateField("pesobobina"));
			cursor.setValueBuffer("pesocamion", this.iface.calculateField("pesocamion"));
			cursor.setValueBuffer("partsperpackunitpeso", this.iface.calculateField("partsperpackunitpeso"));
			cursor.setValueBuffer("palletspertruck", this.iface.calculateField("palletspertruck"));
			break;
		}
		case "density": {
			cursor.setValueBuffer("lotcompramp", this.iface.calculateField("lotcompramp"));
			cursor.setValueBuffer("bruttoweight", this.iface.calculateField("bruttoweight"));
			cursor.setValueBuffer("cyclestampshour", this.iface.calculateField("cyclestampshour"));
			cursor.setValueBuffer("v", this.iface.calculateField("v"));
			cursor.setValueBuffer("pesobobina", this.iface.calculateField("pesobobina"));
			cursor.setValueBuffer("numberyearlyproductions", this.iface.calculateField("numberyearlyproductions"));
			break;
		}
		case "step": {
			cursor.setValueBuffer("bruttoweight", this.iface.calculateField("bruttoweight"));
			cursor.setValueBuffer("setuptool", this.iface.calculateField("setuptool"));
			cursor.setValueBuffer("v", this.iface.calculateField("v"));
			cursor.setValueBuffer("longbobina", this.iface.calculateField("longbobina"));
			cursor.setValueBuffer("numpiezasbobina", this.iface.calculateField("numpiezasbobina"));
			cursor.setValueBuffer("numberyearlyproductions", this.iface.calculateField("numberyearlyproductions"));
			break;
		}
		case "bandwideness": {
			cursor.setValueBuffer("bruttoweight", this.iface.calculateField("bruttoweight"));
			cursor.setValueBuffer("setuptool", this.iface.calculateField("setuptool"));
			cursor.setValueBuffer("cyclestampshour", this.iface.calculateField("cyclestampshour"));
			cursor.setValueBuffer("numberyearlyproductions", this.iface.calculateField("numberyearlyproductions"));
			cursor.setValueBuffer("v", this.iface.calculateField("v"));
			cursor.setValueBuffer("pesobobina", this.iface.calculateField("pesobobina"));
			break;
		}
		case "bandthickness": {
			cursor.setValueBuffer("bruttoweight", this.iface.calculateField("bruttoweight"));
			cursor.setValueBuffer("setuptool", this.iface.calculateField("setuptool"));
			cursor.setValueBuffer("cyclestampshour", this.iface.calculateField("cyclestampshour"));
			cursor.setValueBuffer("v", this.iface.calculateField("v"));
			break;
		}
		case "toolinvestment": {
			cursor.setValueBuffer("setuptool", this.iface.calculateField("setuptool"));
			break;
		}
		case "totalCavitiesTool": {
			cursor.setValueBuffer("bruttoweight", this.iface.calculateField("bruttoweight"));
			cursor.setValueBuffer("cyclestampshour", this.iface.calculateField("cyclestampshour"));
			cursor.setValueBuffer("v", this.iface.calculateField("v"));
			break;
		}
		case "bruttoweight": {
			cursor.setValueBuffer("scrapweight", this.iface.calculateField("scrapweight"));
			cursor.setValueBuffer("longbobina", this.iface.calculateField("longbobina"));
			cursor.setValueBuffer("costfinancmp", this.iface.calculateField("costfinancmp"));
			cursor.setValueBuffer("rawmaterial", this.iface.calculateField("rawmaterial"));
			break;
		}
		case "netweight": {
			cursor.setValueBuffer("scrapweight", this.iface.calculateField("scrapweight"));
			cursor.setValueBuffer("pesobobina", this.iface.calculateField("pesobobina"));
			cursor.setValueBuffer("pesocontenedor", this.iface.calculateField("pesocontenedor"));
			cursor.setValueBuffer("pesocamion", this.iface.calculateField("pesocamion"));
			cursor.setValueBuffer("partsperpackunitpeso", this.iface.calculateField("partsperpackunitpeso"));
			cursor.setValueBuffer("palletspertruck", this.iface.calculateField("palletspertruck"));
			break;
		}
		case "alturapiezaextr": {
			cursor.setValueBuffer("volexcripieza", this.iface.calculateField("volexcripieza"));
			break;
		}
		case "alturapiezaextropu": {
			cursor.setValueBuffer("volexcripieza", this.iface.calculateField("volexcripieza"));
			break;
		}
		case "anchurapieza": {
			cursor.setValueBuffer("volexcripieza", this.iface.calculateField("volexcripieza"));
			break;
		}
		case "longpieza": {
			cursor.setValueBuffer("volexcripieza", this.iface.calculateField("volexcripieza"));
			break;
		}
		case "costhmachine": {
			cursor.setValueBuffer("costhsetupoperation", this.iface.calculateField("costhsetupoperation"));
			cursor.setValueBuffer("totalcostperhour", this.iface.calculateField("totalcostperhour"));
			break;
		}
		case "costhmachineworker": {
			cursor.setValueBuffer("costhsetupoperation", this.iface.calculateField("costhsetupoperation"));
			cursor.setValueBuffer("cyclestampshour", this.iface.calculateField("cyclestampshour"));
			cursor.setValueBuffer("totalcostperhour", this.iface.calculateField("totalcostperhour"));
			break;
		}
		case "costhmanipulator": {
			cursor.setValueBuffer("totalcostperhour", this.iface.calculateField("totalcostperhour"));
			break;
		}
		case "costhadditworker": {
			cursor.setValueBuffer("totalcostperhour", this.iface.calculateField("totalcostperhour"));
			break;
		}
		case "partsperpackunitpeso": {
			cursor.setValueBuffer("cyclestampshour", this.iface.calculateField("cyclestampshour"));
			cursor.setValueBuffer("v", this.iface.calculateField("v"));
			cursor.setValueBuffer("pesocontenedor", this.iface.calculateField("pesocontenedor"));
			break;
		}
		case "costhmanipulator": {
			cursor.setValueBuffer("totalcostperhour", this.iface.calculateField("totalcostperhour"));
			break;
		}
		case "scrapweight": {
			this.iface.calculateField("txtError");
			cursor.setValueBuffer("scrapreturn", this.iface.calculateField("scrapreturn"));
			break;
		}
		case "codmaquina": {
			cursor.setValueBuffer("cyclestampshour", this.iface.calculateField("cyclestampshour"));
			break;
		}
		case "cyclestampshour": {
			cursor.setValueBuffer("cycleseconds", this.iface.calculateField("cycleseconds"));
			cursor.setValueBuffer("totalpartshour", this.iface.calculateField("totalpartshour"));
			break;
		}
		case "yearlyproduction": {
			cursor.setValueBuffer("numberpiecesperproduction", this.iface.calculateField("numberpiecesperproduction"));
			cursor.setValueBuffer("costfinancmp", this.iface.calculateField("costfinancmp"));
			cursor.setValueBuffer("numberyearlyproductions", this.iface.calculateField("numberyearlyproductions"));
			break;
		}
		case "numberyearlyproductions": {
			cursor.setValueBuffer("numberpiecesperproduction", this.iface.calculateField("numberpiecesperproduction"));
			cursor.setValueBuffer("costfinancpiezas", this.iface.calculateField("costfinancpiezas"));
			break;
		}
		case "codmaquina": {
			cursor.setValueBuffer("v", this.iface.calculateField("v"));
			break;
		}
		case "pesobobina": {
			cursor.setValueBuffer("longbobina", this.iface.calculateField("longbobina"));
			cursor.setValueBuffer("kgmpprod", this.iface.calculateField("kgmpprod"));
			break;
		}
		case "longbobina": {
			cursor.setValueBuffer("numpiezasbobina", this.iface.calculateField("numpiezasbobina"));
			break;
		}
		case "numpiezasbobina": {
			cursor.setValueBuffer("bobinasprod", this.iface.calculateField("bobinasprod"));
			break;
		}
		case "numberpiecesperproduction": {
			cursor.setValueBuffer("bobinasprod", this.iface.calculateField("bobinasprod"));
			cursor.setValueBuffer("setupinformation", this.iface.calculateField("setupinformation"));
			break;
		}
		case "totalpartsperpaletbox": {
			cursor.setValueBuffer("pesocamion", this.iface.calculateField("pesocamion"));
			cursor.setValueBuffer("packaginginformation", this.iface.calculateField("packaginginformation"));
			cursor.setValueBuffer("palletspertruck", this.iface.calculateField("palletspertruck"));
			break;
		}
		case "boxesperpallet": {
			cursor.setValueBuffer("pesocamion", this.iface.calculateField("pesocamion"));
			cursor.setValueBuffer("palletspertruck", this.iface.calculateField("palletspertruck"));
			break;
		}
		case "palletspertruck": {
			cursor.setValueBuffer("pesocamion", this.iface.calculateField("pesocamion"));
			break;
		}
		case "kgprice": {
			cursor.setValueBuffer("retornxatarraa", this.iface.calculateField("retornxatarraa"));
			cursor.setValueBuffer("rawmaterial", this.iface.calculateField("rawmaterial"));
			cursor.setValueBuffer("scrapreturn", this.iface.calculateField("scrapreturn"));
			break;
		}
		case "scrapreturn": {
			cursor.setValueBuffer("retornxatarraa", this.iface.calculateField("retornxatarraa"));
			cursor.setValueBuffer("subtotalsummary", this.iface.calculateField("subtotalsummary"));
			break;
		}
		case "euribor": {
			cursor.setValueBuffer("costfinancmp", this.iface.calculateField("costfinancmp"));
			cursor.setValueBuffer("costfinancpiezas", this.iface.calculateField("costfinancpiezas"));
			break;
		}
		case "lotcompramp": {
			cursor.setValueBuffer("costfinancmp", this.iface.calculateField("costfinancmp"));
			break;
		}
		case "bobinasprod": {
			cursor.setValueBuffer("kgmpprod", this.iface.calculateField("kgmpprod"));
			break;
		}
		case "rawmaterial": {
			cursor.setValueBuffer("rmhandling", this.iface.calculateField("rmhandling"));
			cursor.setValueBuffer("subtotalsummary", this.iface.calculateField("subtotalsummary"));
			break;
		}
		case "porrmhandling": {
			cursor.setValueBuffer("rmhandling", this.iface.calculateField("rmhandling"));
			break;
		}
		case "porscrapreturn": {
			cursor.setValueBuffer("scrapreturn", this.iface.calculateField("scrapreturn"));
			break;
		}
		case "rmhandling": {
			cursor.setValueBuffer("subtotalsummary", this.iface.calculateField("subtotalsummary"));
			break;
		}
		case "totalpartshour": {
			cursor.setValueBuffer("stampinginformation", this.iface.calculateField("stampinginformation"));
			break;
		}
		case "totalcostperhour": {
			cursor.setValueBuffer("stampinginformation", this.iface.calculateField("stampinginformation"));
			break;
		}
		case "setuptool": {
			cursor.setValueBuffer("setupinformation", this.iface.calculateField("setupinformation"));
			break;
		}
		case "costhsetupoperation": {
			cursor.setValueBuffer("setupinformation", this.iface.calculateField("setupinformation"));
			break;
		}
		case "totalpackaginginformation": {
			cursor.setValueBuffer("packaginginformation", this.iface.calculateField("packaginginformation"));
			break;
		}
		case "truckcosts": {
			cursor.setValueBuffer("transportinformation", this.iface.calculateField("transportinformation"));
			break;
		}
		case "partspertruck": {
			cursor.setValueBuffer("transportinformation", this.iface.calculateField("transportinformation"));
			break;
		}
		case "stampinginformation": {
			cursor.setValueBuffer("subtotalsummary2", this.iface.calculateField("subtotalsummary2"));
			break;
		}
		case "setupinformation": {
			cursor.setValueBuffer("subtotalsummary2", this.iface.calculateField("subtotalsummary2"));
			break;
		}
		case "procuredpartsinformation": {
			cursor.setValueBuffer("subtotalsummary2", this.iface.calculateField("subtotalsummary2"));
			break;
		}
		case "addopersinfo": {
			cursor.setValueBuffer("subtotalsummary2", this.iface.calculateField("subtotalsummary2"));
			break;
		}
		case "packaginginformation": {
			cursor.setValueBuffer("subtotalsummary2", this.iface.calculateField("subtotalsummary2"));
			break;
		}
		case "transportinformation": {
			cursor.setValueBuffer("subtotalsummary2", this.iface.calculateField("subtotalsummary2"));
			break;
		}
		case "porbenefits": {
			cursor.setValueBuffer("benefits", this.iface.calculateField("benefits"));
			break;
		}
		case "porcostefincmppiez": {
			cursor.setValueBuffer("costefincmppiez", this.iface.calculateField("costefincmppiez"));
			break;
		}
		case "subtotalsummary2": {
			cursor.setValueBuffer("benefits", this.iface.calculateField("benefits"));
			cursor.setValueBuffer("costefincmppiez", this.iface.calculateField("costefincmppiez"));
			cursor.setValueBuffer("priceperunitddu", this.iface.calculateField("priceperunitddu"));
			break;
		}
		case "subtotalsummary": {
			cursor.setValueBuffer("costefincmppiez", this.iface.calculateField("costefincmppiez"));
			cursor.setValueBuffer("priceperunitddu", this.iface.calculateField("priceperunitddu"));
			break;
		}
		case "benefits": {
			cursor.setValueBuffer("priceperunitddu", this.iface.calculateField("priceperunitddu"));
			break;
		}
		case "costefincmppiez": {
			cursor.setValueBuffer("priceperunitddu", this.iface.calculateField("priceperunitddu"));
			break;
		}
		case "priceperunitddu": {
			cursor.setValueBuffer("priceper100unitsddu", this.iface.calculateField("priceper100unitsddu"));
			break;
		}
	}
}


function oficial_tbnCrear_clicked()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var referencia:String = cursor.valueBuffer("referencia");
	var curArticulo:FLSqlCursor = new FLSqlCursor("articulos");
	curArticulo.select("referencia = '" + referencia + "'");
	if (curArticulo.first()) {
		MessageBox.warning(util.translate("scripts", "Ya existe un producto con la referencia %1").arg(referencia), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	var descripcion:String = cursor.valueBuffer("descripcion");
	curArticulo.setModeAccess(curArticulo.Insert);
	curArticulo.refreshBuffer();
	curArticulo.setValueBuffer("referencia", referencia);
	curArticulo.setValueBuffer("descripcion", descripcion);
	curArticulo.setValueBuffer("pvp", cursor.valueBuffer("priceperunitddu"));
	if (!curArticulo.commitBuffer()) {
		return false;
	}
	MessageBox.information(util.translate("scripts", "Se ha creado el producto %1 - %2 con un precio de %3 Eur.").arg(referencia).arg(descripcion).arg(cursor.valueBuffer("priceperunitddu")), MessageBox.Ok, MessageBox.NoButton);
}

function oficial_calcularTotalPackaging()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	cursor.setValueBuffer("totalpackaginginformation", this.iface.calculateField("totalpackaginginformation"));
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
