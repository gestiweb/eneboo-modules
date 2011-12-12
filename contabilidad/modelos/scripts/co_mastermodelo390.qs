/***************************************************************************
                 co_mastermodelo390.qs  -  description
                             -------------------
    begin                : jue mar 12 2009
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
	var xmlModelo:FLDomDocument;
	function oficial( context ) { interna( context ); }
	function lanzar() {	return this.ctx.oficial_lanzar();}
	function presTelematica() {
		return this.ctx.oficial_presTelematica();
	}
	function informarAEATIVA(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarAEATIVA(nodoPadre, version);
	}
	function informarNodoIdDoc(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoIdDoc(nodoPadre, version);
	}
	function informarNodoDatIdent(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoDatIdent(nodoPadre, version);
	}
	function informarNodoPersFisica(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoPersFisica(nodoPadre, version);
	}
	function informarNodoPersJuridica(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoPersJuridica(nodoPadre, version);
	}
	function informarNodoDevengo(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoDevengo(nodoPadre, version);
	}
	function informarNodoDatEstadisticos(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoDatEstadisticos(nodoPadre, version);
	}
	function informarNodoPral(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoPral(nodoPadre, version);
	}
	function informarNodoRegGrupoEntidades(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoRegGrupoEntidades(nodoPadre, version);
	}
	function informarNodoOtras(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoOtras(nodoPadre, version);
	}
	function informarNodoRepresentanteFisica(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoRepresentanteFisica(nodoPadre, version);
	}
	function informarNodoRepresentanteJuridica(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoRepresentanteJuridica(nodoPadre, version);
	}
	function informarNodoRegGeneral(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoRegGeneral(nodoPadre, version);
	}
	function informarNodoBaseImponibleyCuota(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoBaseImponibleyCuota(nodoPadre, version);
	}
	function informarNodoRegOrdinario(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoRegOrdinario(nodoPadre, version);
	}
	function informarNodoRegOrdinarioTipo4(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoRegOrdinarioTipo4(nodoPadre, version);
	}
	function informarNodoRegOrdinarioTipo7(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoRegOrdinarioTipo7(nodoPadre, version);
	}
	function informarNodoRegOrdinarioTipo16(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoRegOrdinarioTipo16(nodoPadre, version);
	}
	function informarNodoOpIntragrupo(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoOpIntragrupo(nodoPadre, version);
	}
	function informarNodoOpIntragrupoTipo4(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoOpIntragrupoTipo4(nodoPadre, version);
	}
	function informarNodoOpIntragrupoTipo7(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoOpIntragrupoTipo7(nodoPadre, version);
	}
	function informarNodoOpIntragrupoTipo16(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoOpIntragrupoTipo16(nodoPadre, version);
	}
	function informarNodoRegBienesUsados(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoRegBienesUsados(nodoPadre, version);
	}
	function informarNodoRegBienesUsadosTipo4(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoRegBienesUsadosTipo4(nodoPadre, version);
	}
	function informarNodoRegBienesUsadosTipo7(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoRegBienesUsadosTipo7(nodoPadre, version);
	}
	function informarNodoRegBienesUsadosTipo16(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoRegBienesUsadosTipo16(nodoPadre, version);
	}
	function informarNodoRegAgViajes(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoRegAgViajes(nodoPadre, version);
	}
	function informarNodoRegAgViajesTipo16(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoRegAgViajesTipo16(nodoPadre, version);
	}
	function informarNodoAdqIntracomBienes(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoAdqIntracomBienes(nodoPadre, version);
	}
	function informarNodoAdqIntracomBienesTipo4(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoAdqIntracomBienesTipo4(nodoPadre, version);
	}
	function informarNodoAdqIntracomBienesTipo7(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoAdqIntracomBienesTipo7(nodoPadre, version);
	}
	function informarNodoAdqIntracomBienesTipo16(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoAdqIntracomBienesTipo16(nodoPadre, version);
	}
	function informarNodoIVAdevengadoInversionSP(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoIVAdevengadoInversionSP(nodoPadre, version);
	}
	function informarNodoIVAdevengadoInversionSPTipoX(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoIVAdevengadoInversionSPTipoX(nodoPadre, version);
	}
	function informarNodoModBasesyCuotas(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoModBasesyCuotas(nodoPadre, version);
	}
	function informarNodoModBasesyCuotasTipoX(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoModBasesyCuotasTipoX(nodoPadre, version);
	}
	function informarNodoTotalBasesyCuotasIVA(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoTotalBasesyCuotasIVA(nodoPadre, version);
	}
	function informarNodoTotalBasesyCuotasIVATipoX(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoTotalBasesyCuotasIVATipoX(nodoPadre, version);
	}
	function informarNodoRecargoEquivalencia(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoRecargoEquivalencia(nodoPadre, version);
	}
	function informarNodoRecargoEquivalenciaTipo05(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoRecargoEquivalenciaTipo05(nodoPadre, version);
	}
	function informarNodoRecargoEquivalenciaTipo1(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoRecargoEquivalenciaTipo1(nodoPadre, version);
	}
	function informarNodoRecargoEquivalenciaTipo4(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoRecargoEquivalenciaTipo4(nodoPadre, version);
	}
	function informarNodoRecargoEquivalenciaTipo175(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoRecargoEquivalenciaTipo175(nodoPadre, version);
	}
	function informarNodoModRecargoEquivalencia(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoModRecargoEquivalencia(nodoPadre, version);
	}
	function informarNodoModRecargoEquivalenciaTipoX(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoModRecargoEquivalenciaTipoX(nodoPadre, version);
	}
	function informarNodoRegSimplificado(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoRegSimplificado(nodoPadre, version);
	}
	function informarNodoActividad(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoActividad(nodoPadre, version);
	}
	function informarNodoActividad1(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoActividad1(nodoPadre, version);
	}
	function informarNodoActividad2(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoActividad2(nodoPadre, version);
	}
	function informarNodoModulo(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoModulo(nodoPadre, version);
	}
	function informarNodoActAgricGanadForest(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoActAgricGanadForest(nodoPadre, version);
	}
	function informarNodoIvaDevengado(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoIvaDevengado(nodoPadre, version);
	}
	function informarNodoIvaDeducible(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoIvaDeducible(nodoPadre, version);
	}
	function informarNodoLiqAnual(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoLiqAnual(nodoPadre, version);
	}
	function informarNodoAdministraciones(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoAdministraciones(nodoPadre, version);
	}
	function informarNodoResLiquidaciones(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoResLiquidaciones(nodoPadre, version);
	}
	function informarNodoVolOperaciones(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoVolOperaciones(nodoPadre, version);
	}
	function informarNodoOpEspecificas(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoOpEspecificas(nodoPadre, version);
	}
	function informarNodoConjunta(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoConjunta(nodoPadre, version);
	}
	function informarNodoFechaDecla(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoFechaDecla(nodoPadre, version);
	}
	function informarNodoModBasesyCuotasConAcr(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoModBasesyCuotasConAcr(nodoPadre, version);
	}
	function informarNodoModBasesyCuotasConAcrTipoX(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoModBasesyCuotasConAcrTipoX(nodoPadre, version);
	}
	function informarNodoModReEqConAcr(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoModReEqConAcr(nodoPadre, version);
	}
	function informarNodoModReEqConAcrTipoX(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoModReEqConAcrTipoX(nodoPadre, version);
	}
	function informarNodoDeducciones(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoDeducciones(nodoPadre, version);
	}
	function informarNodoProrratas(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoProrratas(nodoPadre, version);
	}
	function informarNodoPro1(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoPro1(nodoPadre, version);
	}
	function informarNodoPro2(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoPro2(nodoPadre, version);
	}
	function informarNodoPro3(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoPro3(nodoPadre, version);
	}
	function informarNodoPro4(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoPro4(nodoPadre, version);
	}
	function informarNodoPro5(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoPro5(nodoPadre, version);
	}
	function informarNodoPro6(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoPro6(nodoPadre, version);
	}
	function informarNodoPro7(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoPro7(nodoPadre, version);
	}
	function informarNodoPro8(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoPro8(nodoPadre, version);
	}
	function informarNodoOpInterioresBienesServiciosCorrientes(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoOpInterioresBienesServiciosCorrientes(nodoPadre, version)
	}
	function informarNodoOpInterioresBienesServiciosCorrientesTotal(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoOpInterioresBienesServiciosCorrientesTotal(nodoPadre, version)
	}
	function informarNodoOpItragrupoCorrientes(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoOpItragrupoCorrientes(nodoPadre, version)
	}
	function informarNodoOpItragrupoCorrientesTotal(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoOpItragrupoCorrientesTotal(nodoPadre, version)
	}
	function informarNodoOpBieInv(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoOpBieInv(nodoPadre, version)
	}
	function informarNodoOpBieInvTotal(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoOpBieInvTotal(nodoPadre, version)
	}
	function informarNodoOpIntraBieInv(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoOpIntraBieInv(nodoPadre, version)
	}
	function informarNodoOpIntraBieInvTotal(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoOpIntraBieInvTotal(nodoPadre, version)
	}
	function informarNodoImpBieCo(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoImpBieCo(nodoPadre, version)
	}
	function informarNodoImpBieCoTotal(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoImpBieCoTotal(nodoPadre, version)
	}
	function informarNodoImpBieInv(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoImpBieInv(nodoPadre, version)
	}
	function informarNodoImpBieInvTotal(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoImpBieInvTotal(nodoPadre, version)
	}
	function informarNodoAdqIntrBC(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoAdqIntrBC(nodoPadre, version)
	}
	function informarNodoAdqIntrBCTotal(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoAdqIntrBCTotal(nodoPadre, version)
	}
	function informarNodoAdqIntrBI(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoAdqIntrBI(nodoPadre, version)
	}
	function informarNodoAdqIntrBITotal(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoAdqIntrBITotal(nodoPadre, version)
	}
	function informarNodoComAgrGanP(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoComAgrGanP(nodoPadre, version)
	}
	function informarNodoComAgrGanPTipoX(nodoPadre:FLDomElement, version:String):Boolean {
		return this.ctx.oficial_informarNodoComAgrGanPTipoX(nodoPadre, version)
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
/** \D Lanza el informe asociado al modelo 390 seleccionado
\end */
function oficial_lanzar()
{
	var cursor:FLSqlCursor = this.cursor();
	var nombreInforme:String = cursor.action();
	flcontmode.iface.pub_lanzarInforme(cursor, nombreInforme, nombreInforme + ".id=" + cursor.valueBuffer( "id" ) );
}

/** \D Genera un fichero para realizar la presentación telemática del modelo
\end */
function oficial_presTelematica()
{
	var util:FLUtil = new FLUtil();
	var nombreFichero:String = FileDialog.getSaveFileName("*.*");
	if (!nombreFichero)
		return;
		
	var contenido:String = "";
	var file:Object = new File(nombreFichero);
	file.open(File.WriteOnly);

	this.iface.xmlModelo = new FLDomDocument();
	var nodoAEATIVA:FLDomElement = this.iface.xmlModelo.createElement("AEATIVA2008");
	this.iface.xmlModelo.appendChild(nodoAEATIVA);
	if (!this.iface.informarAEATIVA(nodoAEATIVA, "2008")) {
		return false;
	}
	var s = this.iface.xmlModelo.toString(4);
debug(s);

	file.write(s);
	file.close();

	MessageBox.information(util.translate("scripts", "El fichero ha sido generado correctamente"), MessageBox.Ok, MessageBox.NoButton);
}

function oficial_informarAEATIVA(nodoPadre:FLDomElement, version:String):Boolean
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var nodoIdDoc:FLDomElement = this.iface.xmlModelo.createElement("IdDoc");
	nodoPadre.appendChild(nodoIdDoc);
	if (!this.iface.informarNodoIdDoc(nodoIdDoc, version)) {
		MessageBox.information(util.translate("scripts", "Error al informar el nodo IdDoc"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var nodoDatIdent:FLDomElement = this.iface.xmlModelo.createElement("DatIdent");
	nodoPadre.appendChild(nodoDatIdent);
	if (!this.iface.informarNodoDatIdent(nodoDatIdent, version)) {
		return false;
	}
	var nodoDevengo:FLDomElement = this.iface.xmlModelo.createElement("Devengo");
	nodoPadre.appendChild(nodoDevengo);
	if (!this.iface.informarNodoDevengo(nodoDevengo, version)) {
		MessageBox.information(util.translate("scripts", "Error al informar el nodo Devengo"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var nodoDatEstadisticos:FLDomElement = this.iface.xmlModelo.createElement("DatEstadisticos");
	nodoPadre.appendChild(nodoDatEstadisticos);
	if (!this.iface.informarNodoDatEstadisticos(nodoDatEstadisticos, version)) {
		MessageBox.information(util.translate("scripts", "Error al informar el nodo DatEstadisticos"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	if (cursor.valueBuffer("nifpf4") && cursor.valueBuffer("tipopersona") == "Física") {
		var nodoRepresentanteFisica:FLDomElement = this.iface.xmlModelo.createElement("RepresentanteFisica");
		nodoPadre.appendChild(nodoRepresentanteFisica);
		if (!this.iface.informarNodoRepresentanteFisica(nodoRepresentanteFisica, version)) {
			MessageBox.information(util.translate("scripts", "Error al informar el nodo RepresentanteFisica"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}

	if (cursor.valueBuffer("nifpf4") && cursor.valueBuffer("tipopersona") == "Jurídica") {
		var nodoRepresentanteJuridica:FLDomElement = this.iface.xmlModelo.createElement("RepresentanteJuridica");
		nodoPadre.appendChild(nodoRepresentanteJuridica);
		if (!this.iface.informarNodoRepresentanteJuridica(nodoRepresentanteJuridica, version)) {
			MessageBox.information(util.translate("scripts", "Error al informar el nodo RepresentanteJuridica"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}

	if (cursor.valueBuffer("municipiopf4") || cursor.valueBuffer("fechapf4")) {
		var nodoFechaDecla:FLDomElement = this.iface.xmlModelo.createElement("FechaDecla");
		nodoPadre.appendChild(nodoFechaDecla);
		if (!this.iface.informarNodoFechaDecla(nodoFechaDecla, version)) {
			return false;
		}
	}

	var nodoRegGeneral:FLDomElement = this.iface.xmlModelo.createElement("RegGeneral");
	nodoPadre.appendChild(nodoRegGeneral);
	if (!this.iface.informarNodoRegGeneral(nodoRegGeneral, version)) {
		return false;
	}

	var nodoRegSimplificado:FLDomElement = this.iface.xmlModelo.createElement("RegSimplificado");
	nodoPadre.appendChild(nodoRegSimplificado);
	if (!this.iface.informarNodoRegSimplificado(nodoRegSimplificado, version)) {
		return false;
	}

	if (!cursor.valueBuffer("tributacionterr")) {
		if (cursor.valueBuffer("sumares") || cursor.valueBuffer("comcuotasea") || cursor.valueBuffer("resliquidacion")) {
			var nodoLiqAnual:FLDomElement = this.iface.xmlModelo.createElement("LiqAnual");
			nodoPadre.appendChild(nodoLiqAnual);
			if (!this.iface.informarNodoLiqAnual(nodoLiqAnual, version)) {
				return false;
			}
		}
	} else {
		if (cursor.valueBuffer("portc") || cursor.valueBuffer("pora") || cursor.valueBuffer("porg") || cursor.valueBuffer("porv") || cursor.valueBuffer("porn") || cursor.valueBuffer("sumares") || cursor.valueBuffer("resultadotc") || cursor.valueBuffer("compcuotaseatc") || cursor.valueBuffer("resliqtc")) {
			var nodoAdministraciones:FLDomElement = this.iface.xmlModelo.createElement("Administraciones");
			nodoPadre.appendChild(nodoAdministraciones);
			if (!this.iface.informarNodoAdministraciones(nodoAdministraciones, version)) {
				return false;
			}
		}
	}

	if (cursor.valueBuffer("totalingresos") || cursor.valueBuffer("totaldevoluciones") || cursor.valueBuffer("totalacompensar") || cursor.valueBuffer("totaladevolver")) {
		var nodoResLiquidaciones:FLDomElement = this.iface.xmlModelo.createElement("ResLiquidaciones");
		nodoPadre.appendChild(nodoResLiquidaciones);
		if (!this.iface.informarNodoResLiquidaciones(nodoResLiquidaciones, version)) {
			return false;
		}
	}

	if (cursor.valueBuffer("operacionesre") || cursor.valueBuffer("operacionesrs") || cursor.valueBuffer("operacionesreagp") || cursor.valueBuffer("operacionesrere") || cursor.valueBuffer("entregasintraex") || cursor.valueBuffer("entregasintraexcondd") || cursor.valueBuffer("entregasintraexsinndd") || cursor.valueBuffer("entregasbinmuebles") || cursor.valueBuffer("entregasbinversion") || cursor.valueBuffer("totalvoloperaciones")) {
		var nodoVolOperaciones:FLDomElement = this.iface.xmlModelo.createElement("VolOperaciones");
		nodoPadre.appendChild(nodoVolOperaciones);
		if (!this.iface.informarNodoVolOperaciones(nodoVolOperaciones, version)) {
			return false;
		}
	}

	if (cursor.valueBuffer("adquiintraex") || cursor.valueBuffer("opnsdm") || cursor.valueBuffer("opsyedm") || cursor.valueBuffer("entregasbo") || cursor.valueBuffer("entregasbs")) {
		var nodoOpEspecificas:FLDomElement = this.iface.xmlModelo.createElement("OpEspecificas");
		nodoPadre.appendChild(nodoOpEspecificas);
		if (!this.iface.informarNodoOpEspecificas(nodoOpEspecificas, version)) {
			return false;
		}
	}

	if (cursor.valueBuffer("cane") || cursor.valueBuffer("cane2") || cursor.valueBuffer("cane3") || cursor.valueBuffer("cane4") || cursor.valueBuffer("cane5") || cursor.valueBuffer("cane6") || cursor.valueBuffer("cane7") || cursor.valueBuffer("cane8")) {
		var nodoProrratas:FLDomElement = this.iface.xmlModelo.createElement("Prorratas");
		nodoPadre.appendChild(nodoProrratas);
		if (!this.iface.informarNodoProrratas(nodoProrratas, version)) {
			return false;
		}
	}
	return true;
}

function oficial_informarNodoIdDoc(nodoPadre:FLDomElement, version:String):Boolean
{
	var cursor:FLSqlCursor = this.cursor();
	var nodoCodModelo:FLDomElement = this.iface.xmlModelo.createElement("CodModelo");
	nodoPadre.appendChild(nodoCodModelo);
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode("390");
	nodoCodModelo.appendChild(nodoTexto);
	
	var nodoEjercicio:FLDomElement = this.iface.xmlModelo.createElement("Ejercicio");
	nodoPadre.appendChild(nodoEjercicio);
	nodoTexto = this.iface.xmlModelo.createTextNode(version);
	nodoEjercicio.appendChild(nodoTexto);

	if (cursor.valueBuffer("numjustificante")) {
		var nodoJustif:FLDomElement = this.iface.xmlModelo.createElement("Justif");
		nodoPadre.appendChild(nodoJustif);
		nodoTexto = this.iface.xmlModelo.createTextNode(cursor.valueBuffer("numjustificante"));
		nodoJustif.appendChild(nodoTexto);
	}
	return true;
}

function oficial_informarNodoDatIdent(nodoPadre:FLDomElement, version:String):Boolean
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	if (cursor.valueBuffer("tipopersona") == "Física") {
		var nodoPersFisica:FLDomElement = this.iface.xmlModelo.createElement("PersFisica");
		nodoPadre.appendChild(nodoPersFisica);
		if (!this.iface.informarNodoPersFisica(nodoPersFisica, version)) {
			MessageBox.information(util.translate("scripts", "Error al informar el nodo PersFisica"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	} else {
		var nodoPersJuridica:FLDomElement = this.iface.xmlModelo.createElement("PersJuridica");
		nodoPadre.appendChild(nodoPersJuridica);
		if (!this.iface.informarNodoPersJuridica(nodoPersJuridica, version)) {
			MessageBox.information(util.translate("scripts", "Error al informar el nodo PersJuridica"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}

	if (cursor.valueBuffer("telefono")) {
		var nodoTelefono:FLDomElement = this.iface.xmlModelo.createElement("Telefono");
		nodoPadre.appendChild(nodoTelefono);
		var telef:String = cursor.valueBuffer("telefono");
		if (!flcontmode.iface.pub_verificarDato(telef, true, "Telefono", 9)) {
			return false;
		}
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(telef);
		nodoTelefono.appendChild(nodoTexto);
	}
	return true;
}

function oficial_informarNodoPersFisica(nodoPadre:FLDomElement, version:String):Boolean
{
	var cursor:FLSqlCursor = this.cursor();
	var nodoNif:FLDomElement = this.iface.xmlModelo.createElement("NIF");
	nodoPadre.appendChild(nodoNif);
	var nif:String = cursor.valueBuffer("cifnif");
	if (!flcontmode.iface.pub_verificarDato(nif, true, "NIF", 9)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(nif);
	nodoNif.appendChild(nodoTexto);

	var nodoApe1:FLDomElement = this.iface.xmlModelo.createElement("Ape1");
	nodoPadre.appendChild(nodoApe1);
	var apellido1:String = cursor.valueBuffer("apellido1");
	if (!flcontmode.iface.pub_verificarDato(apellido1, true, "Apellido 1", 15)) {
		return false;
	}
	nodoTexto = this.iface.xmlModelo.createTextNode(apellido1);
	nodoApe1.appendChild(nodoTexto);

	if (cursor.valueBuffer("apellido2")) {
		var nodoApe2:FLDomElement = this.iface.xmlModelo.createElement("Ape2");
		nodoPadre.appendChild(nodoApe2);
		var apellido2:String = cursor.valueBuffer("apellido2");
		if (!flcontmode.iface.pub_verificarDato(apellido2, true, "Apellido 2", 15)) {
			return false;
		}
		nodoTexto = this.iface.xmlModelo.createTextNode(apellido2);
		nodoApe2.appendChild(nodoTexto);
	}

	var nodoNombre:FLDomElement = this.iface.xmlModelo.createElement("Nombre");
	nodoPadre.appendChild(nodoNombre);
	var nombre:String = cursor.valueBuffer("nombre");
	if (!flcontmode.iface.pub_verificarDato(apellido1, true, "Nombre", 15)) {
		return false;
	}
	nodoTexto = this.iface.xmlModelo.createTextNode(nombre);
	nodoNombre.appendChild(nodoTexto);
	return true;
}

function oficial_informarNodoPersJuridica(nodoPadre:FLDomElement, version:String):Boolean
{
	var cursor:FLSqlCursor = this.cursor();
	var nodoNif:FLDomElement = this.iface.xmlModelo.createElement("NIF");
	nodoPadre.appendChild(nodoNif);
	var nif:String = cursor.valueBuffer("cifnif");
	if (!flcontmode.iface.pub_verificarDato(nif, true, "NIF", 9)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(nif);
	nodoNif.appendChild(nodoTexto);

	var nodoRazonSocial:FLDomElement = this.iface.xmlModelo.createElement("RazonSocial");
	nodoPadre.appendChild(nodoRazonSocial);
	var razonSocial:String = cursor.valueBuffer("razonsocial");
	if (!flcontmode.iface.pub_verificarDato(razonSocial, true, "Razón social", 37)) {
		return false;
	}
	nodoTexto = this.iface.xmlModelo.createTextNode(razonSocial);
	nodoRazonSocial.appendChild(nodoTexto);

	return true;
}

function oficial_informarNodoDevengo(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var nodoEjercicio:FLDomElement = this.iface.xmlModelo.createElement("Ejercicio");
	nodoPadre.appendChild(nodoEjercicio);
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(version);
	nodoEjercicio.appendChild(nodoTexto);

	if (cursor.valueBuffer("sustitutiva")) {
		var nodoJustDecAnt:FLDomElement = this.iface.xmlModelo.createElement("JustDecAnterior");
		nodoPadre.appendChild(nodoJustDecAnt);
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cursor.valueBuffer("numjustificanteant"));
		nodoJustDecAnt.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("regexportadores")) {
		var nodoRegExp:FLDomElement = this.iface.xmlModelo.createElement("RegExportadores");
		nodoPadre.appendChild(nodoRegExp);
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode("");
		nodoRegExp.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("regespgrupoenti")) {
		var nodoRegGE:FLDomElement = this.iface.xmlModelo.createElement("RegGrupoEntidades");
		nodoPadre.appendChild(nodoRegGE);
		if (!this.iface.informarNodoRegGrupoEntidades(nodoRegGE, version)) {
			return false;
		}
	}
	return true;
}

function oficial_informarNodoDatEstadisticos(nodoPadre:FLDomElement, version:String):Boolean
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var nodoPral:FLDomElement = this.iface.xmlModelo.createElement("Pral");
	nodoPadre.appendChild(nodoPral);
	if (!this.iface.informarNodoPral(nodoPral, version)) {
		return false;
	}

	if (cursor.valueBuffer("claveo13") || cursor.valueBuffer("claveo23") || cursor.valueBuffer("claveo33") || cursor.valueBuffer("claveo43") || cursor.valueBuffer("claveo53")) {
		var nodoOtras:FLDomElement = this.iface.xmlModelo.createElement("Otras");
		nodoPadre.appendChild(nodoOtras);
		if (!this.iface.informarNodoOtras(nodoOtras, version)) {
			return false;
		}
	}

	if (cursor.valueBuffer("declaracionopterceros3")) {
		var nodoTercPer:FLDomElement = this.iface.xmlModelo.createElement("OpTercerasPax");
		nodoPadre.appendChild(nodoTercPer);
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode("");
		nodoTercPer.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("nifdecconj")) {
		var nodoConjunta:FLDomElement = this.iface.xmlModelo.createElement("Conjunta");
		nodoPadre.appendChild(nodoConjunta);
		if (!this.iface.informarNodoConjunta(nodoConjunta, version)) {
			return false;
		}
	}

	return true;
}	

function oficial_informarNodoConjunta(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();

	var nodoNif:FLDomElement = this.iface.xmlModelo.createElement("NIF");
	nodoPadre.appendChild(nodoNif);
	var nif:String = cursor.valueBuffer("nifdecconj");
	if (!flcontmode.iface.pub_verificarDato(nif, true, "NIF Dec. Conjunta", 9)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(nif);
	nodoNif.appendChild(nodoTexto);

	if (cursor.valueBuffer("rsdecconj")) {
		var nodoRS:FLDomElement = this.iface.xmlModelo.createElement("RazonSocial");
		nodoPadre.appendChild(nodoRS);
		var razonSocial:String = cursor.valueBuffer("rsdecconj");
		if (!flcontmode.iface.pub_verificarDato(razonSocial, true, "Razón social Dec. Conjunta", 37)) {
			return false;
		}
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(razonSocial);
		nodoRS.appendChild(nodoTexto);
	}
	return true;
}

function oficial_informarNodoPral(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();

	if (cursor.valueBuffer("actividadesp3")) {
		var nodoDescrip:FLDomElement = this.iface.xmlModelo.createElement("Descripcion");
		nodoPadre.appendChild(nodoDescrip);
		var descrip:String = cursor.valueBuffer("actividadesp3");
		if (!flcontmode.iface.pub_verificarDato(descrip, true, "Descripcion", 40)) {
			return false;
		}
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(descrip);
		nodoDescrip.appendChild(nodoTexto);
	}

	var nodoClave:FLDomElement = this.iface.xmlModelo.createElement("Clave");
	nodoPadre.appendChild(nodoClave);
	var clave:String = cursor.valueBuffer("clavep3");
	if (!flcontmode.iface.pub_verificarDato(clave, true, "Clave de la actividad principal de la empresa", 1)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(clave);
	nodoClave.appendChild(nodoTexto);

	if (cursor.valueBuffer("epigrafep3")) {
		var nodoEpigrafe:FLDomElement = this.iface.xmlModelo.createElement("Epigrafe");
		nodoPadre.appendChild(nodoEpigrafe);
		var epigrafe:String = cursor.valueBuffer("epigrafep3");
		if (!flcontmode.iface.pub_verificarDato(epigrafe, true, "Epigrafe", 5)) {
			return false;
		}
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(epigrafe);
		nodoEpigrafe.appendChild(nodoTexto);
	}
	return true;
}

function oficial_informarNodoOtras(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();

	if (cursor.valueBuffer("claveo13")) {
		if (cursor.valueBuffer("actividadeso13")) {
			var nodoDescrip:FLDomElement = this.iface.xmlModelo.createElement("Descripcion");
			nodoPadre.appendChild(nodoDescrip);
			var descrip:String = cursor.valueBuffer("actividadeso13");
			if (!flcontmode.iface.pub_verificarDato(descrip, true, "Descripcion", 40)) {
				return false;
			}
			var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(descrip);
			nodoDescrip.appendChild(nodoTexto);
		}
		var nodoClave:FLDomElement = this.iface.xmlModelo.createElement("Clave");
		nodoPadre.appendChild(nodoClave);
		var clave:String = cursor.valueBuffer("claveo13");
		if (!flcontmode.iface.pub_verificarDato(clave, true, "Clave (12)", 1)) {
			return false;
		}
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(clave);
		nodoClave.appendChild(nodoTexto);
		if (cursor.valueBuffer("epigrafeo13")) {
			var nodoEpigrafe:FLDomElement = this.iface.xmlModelo.createElement("Epigrafe");
			nodoPadre.appendChild(nodoEpigrafe);
			var epigrafe:String = cursor.valueBuffer("epigrafeo13");
			if (!flcontmode.iface.pub_verificarDato(epigrafe, true, "Epigrafe", 5)) {
				return false;
			}
			var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(epigrafe);
			nodoEpigrafe.appendChild(nodoTexto);
		}
	}

	if (cursor.valueBuffer("claveo23")) {
		if (cursor.valueBuffer("actividadeso23")) {
			var nodoDescrip:FLDomElement = this.iface.xmlModelo.createElement("Descripcion");
			nodoPadre.appendChild(nodoDescrip);
			var descrip:String = cursor.valueBuffer("actividadeso23");
			if (!flcontmode.iface.pub_verificarDato(descrip, true, "Descripcion", 40)) {
				return false;
			}
			var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(descrip);
			nodoDescrip.appendChild(nodoTexto);
		}
		var nodoClave:FLDomElement = this.iface.xmlModelo.createElement("Clave");
		nodoPadre.appendChild(nodoClave);
		var clave:String = cursor.valueBuffer("claveo23");
		if (!flcontmode.iface.pub_verificarDato(clave, true, "Clave (13)", 1)) {
			return false;
		}
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(clave);
		nodoClave.appendChild(nodoTexto);
		if (cursor.valueBuffer("epigrafeo23")) {
			var nodoEpigrafe:FLDomElement = this.iface.xmlModelo.createElement("Epigrafe");
			nodoPadre.appendChild(nodoEpigrafe);
			var epigrafe:String = cursor.valueBuffer("epigrafeo23");
			if (!flcontmode.iface.pub_verificarDato(epigrafe, true, "Epigrafe", 5)) {
				return false;
			}
			var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(epigrafe);
			nodoEpigrafe.appendChild(nodoTexto);
		}
	}

	if (cursor.valueBuffer("claveo33")) {
		if (cursor.valueBuffer("actividadeso33")) {
			var nodoDescrip:FLDomElement = this.iface.xmlModelo.createElement("Descripcion");
			nodoPadre.appendChild(nodoDescrip);
			var descrip:String = cursor.valueBuffer("actividadeso33");
			if (!flcontmode.iface.pub_verificarDato(descrip, true, "Descripcion", 40)) {
				return false;
			}
			var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(descrip);
			nodoDescrip.appendChild(nodoTexto);
		}
		var nodoClave:FLDomElement = this.iface.xmlModelo.createElement("Clave");
		nodoPadre.appendChild(nodoClave);
		var clave:String = cursor.valueBuffer("claveo33");
		if (!flcontmode.iface.pub_verificarDato(clave, true, "Clave (14)", 1)) {
			return false;
		}
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(clave);
		nodoClave.appendChild(nodoTexto);
		if (cursor.valueBuffer("epigrafeo33")) {
			var nodoEpigrafe:FLDomElement = this.iface.xmlModelo.createElement("Epigrafe");
			nodoPadre.appendChild(nodoEpigrafe);
			var epigrafe:String = cursor.valueBuffer("epigrafeo33");
			if (!flcontmode.iface.pub_verificarDato(epigrafe, true, "Epigrafe", 5)) {
				return false;
			}
			var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(epigrafe);
			nodoEpigrafe.appendChild(nodoTexto);
		}
	}

	if (cursor.valueBuffer("claveo43")) {
		if (cursor.valueBuffer("actividadeso43")) {
			var nodoDescrip:FLDomElement = this.iface.xmlModelo.createElement("Descripcion");
			nodoPadre.appendChild(nodoDescrip);
			var descrip:String = cursor.valueBuffer("actividadeso43");
			if (!flcontmode.iface.pub_verificarDato(descrip, true, "Descripcion", 40)) {
				return false;
			}
			var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(descrip);
			nodoDescrip.appendChild(nodoTexto);
		}
		var nodoClave:FLDomElement = this.iface.xmlModelo.createElement("Clave");
		nodoPadre.appendChild(nodoClave);
		var clave:String = cursor.valueBuffer("claveo43");
		if (!flcontmode.iface.pub_verificarDato(clave, true, "Clave (15)", 1)) {
			return false;
		}
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(clave);
		nodoClave.appendChild(nodoTexto);
		if (cursor.valueBuffer("epigrafeo43")) {
			var nodoEpigrafe:FLDomElement = this.iface.xmlModelo.createElement("Epigrafe");
			nodoPadre.appendChild(nodoEpigrafe);
			var epigrafe:String = cursor.valueBuffer("epigrafeo43");
			if (!flcontmode.iface.pub_verificarDato(epigrafe, true, "Epigrafe", 5)) {
				return false;
			}
			var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(epigrafe);
			nodoEpigrafe.appendChild(nodoTexto);
		}
	}

	if (cursor.valueBuffer("claveo53")) {
		if (cursor.valueBuffer("actividadeso53")) {
			var nodoDescrip:FLDomElement = this.iface.xmlModelo.createElement("Descripcion");
			nodoPadre.appendChild(nodoDescrip);
			var descrip:String = cursor.valueBuffer("actividadeso53");
			if (!flcontmode.iface.pub_verificarDato(descrip, true, "Descripcion", 40)) {
				return false;
			}
			var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(descrip);
			nodoDescrip.appendChild(nodoTexto);
		}
		var nodoClave:FLDomElement = this.iface.xmlModelo.createElement("Clave");
		nodoPadre.appendChild(nodoClave);
		var clave:String = cursor.valueBuffer("claveo53");
		if (!flcontmode.iface.pub_verificarDato(clave, true, "Clave (16)", 1)) {
			return false;
		}
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(clave);
		nodoClave.appendChild(nodoTexto);
		if (cursor.valueBuffer("epigrafeo53")) {
			var nodoEpigrafe:FLDomElement = this.iface.xmlModelo.createElement("Epigrafe");
			nodoPadre.appendChild(nodoEpigrafe);
			var epigrafe:String = cursor.valueBuffer("epigrafeo53");
			if (!flcontmode.iface.pub_verificarDato(epigrafe, true, "Epigrafe", 5)) {
				return false;
			}
			var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(epigrafe);
			nodoEpigrafe.appendChild(nodoTexto);
		}
	}
	return true;
}

function oficial_informarNodoRegGrupoEntidades(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();

	if (cursor.valueBuffer("regespgrupoenti")) {
		var nodoGrupoEnt:FLDomElement = this.iface.xmlModelo.createElement("GrupoEntidades");
		nodoPadre.appendChild(nodoGrupoEnt);
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode("");
		nodoGrupoEnt.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("numgrupo")) {
		var nodoNumGrupo:FLDomElement = this.iface.xmlModelo.createElement("NumGrupo");
		nodoPadre.appendChild(nodoNumGrupo);
		var numGrupo:String = cursor.valueBuffer("numgrupo");
		if (!flcontmode.iface.pub_verificarDato(numGrupo, true, "Nº Grupo", 7)) {
			return false;
		}
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(numGrupo);
		nodoNumGrupo.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("dominante")) {
		var nodoDomin:FLDomElement = this.iface.xmlModelo.createElement("Dominante");
		nodoPadre.appendChild(nodoDomin);
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode("");
		nodoDomin.appendChild(nodoTexto);
	} else {
		if (cursor.valueBuffer("dependiente")) {
			var nodoDep:FLDomElement = this.iface.xmlModelo.createElement("Dependiente");
			nodoPadre.appendChild(nodoDep);
			var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode("");
			nodoDep.appendChild(nodoTexto);
		}
	}

	if (cursor.valueBuffer("tiporegsi")) {
		var nodoTipoRegSi:FLDomElement = this.iface.xmlModelo.createElement("Art.6.5_SI");
		nodoPadre.appendChild(nodoTipoRegSi);
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode("");
		nodoTipoRegSi.appendChild(nodoTexto);
	} else {
		if (cursor.valueBuffer("tiporegno")) {
			var nodoTipoRegNo:FLDomElement = this.iface.xmlModelo.createElement("Art.6.5_NO");
			nodoPadre.appendChild(nodoTipoRegNo);
			var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode("");
			nodoTipoRegNo.appendChild(nodoTexto);
		}
	}

	if (cursor.valueBuffer("nifentidomin")) {
		var nodoNifEntDom:FLDomElement = this.iface.xmlModelo.createElement("NIFEntidadDominante");
		nodoPadre.appendChild(nodoNifEntDom);
		var nifEnti:String = cursor.valueBuffer("nifentidomin");
		if (!flcontmode.iface.pub_verificarDato(nifEnti, true, "NIF entidad dominante", 9)) {
			return false;
		}
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(nifEnti);
		nodoNifEntDom.appendChild(nodoTexto);
	}
	return true;
}

function oficial_informarNodoRepresentanteFisica(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var nodoNif:FLDomElement = this.iface.xmlModelo.createElement("NIF");
	nodoPadre.appendChild(nodoNif);
	var nif:String = cursor.valueBuffer("nifpf4");
	if (!flcontmode.iface.pub_verificarDato(nif, true, "Nif representante", 9)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(nif);
	nodoNif.appendChild(nodoTexto);

	if (cursor.valueBuffer("apellidosnombrepf4")) {
		var nodoRazonSocial:FLDomElement = this.iface.xmlModelo.createElement("RazonSocial");
		nodoPadre.appendChild(nodoRazonSocial);
		var razonSocial:String = cursor.valueBuffer("apellidosnombrepf4");
		if (!flcontmode.iface.pub_verificarDato(razonSocial, true, "Razón social del representante", 37)) {
			return false;
		}
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(razonSocial);
		nodoRazonSocial.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("nombreviapf4")) {
		if (cursor.valueBuffer("tipoviapf4")) {
			var nodoTipoVia:FLDomElement = this.iface.xmlModelo.createElement("SG");
			nodoPadre.appendChild(nodoTipoVia);
			var tipoVia:String = cursor.valueBuffer("tipoviapf4");
			var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(tipoVia);
			nodoTipoVia.appendChild(nodoTexto);
		}

		var nodoNombreVia:FLDomElement = this.iface.xmlModelo.createElement("ViaPublica");
		nodoPadre.appendChild(nodoNombreVia);
		var viaPublica:String = cursor.valueBuffer("nombreviapf4");
		if (!flcontmode.iface.pub_verificarDato(viaPublica, true, "Nombre de la vía pública", 17)) {
			return false;
		}
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(viaPublica);
		nodoNombreVia.appendChild(nodoTexto);

		if (cursor.valueBuffer("numeropf4")) {
			var nodoNumero:FLDomElement = this.iface.xmlModelo.createElement("Num");
			nodoPadre.appendChild(nodoNumero);
			var numero:String = cursor.valueBuffer("numeropf4");
			if (!flcontmode.iface.pub_verificarDato(numero, true, "Número", 5)) {
				return false;
			}
			var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(numero);
			nodoNumero.appendChild(nodoTexto);
		}
	
		if (cursor.valueBuffer("escalerapf4")) {
			var nodoEscalera:FLDomElement = this.iface.xmlModelo.createElement("Esc");
			nodoPadre.appendChild(nodoEscalera);
			var escalera:String = cursor.valueBuffer("escalerapf4");
			if (!flcontmode.iface.pub_verificarDato(escalera, true, "Escalera", 2)) {
				return false;
			}
			var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(escalera);
			nodoEscalera.appendChild(nodoTexto);
		}
	
		if (cursor.valueBuffer("pisopf4")) {
			var nodoPiso:FLDomElement = this.iface.xmlModelo.createElement("Piso");
			nodoPadre.appendChild(nodoPiso);
			var piso:String = cursor.valueBuffer("pisopf4");
			if (!flcontmode.iface.pub_verificarDato(piso, true, "Piso", 2)) {
				return false;
			}
			var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(piso);
			nodoPiso.appendChild(nodoTexto);
		}
		
		if (cursor.valueBuffer("puertapf4")) {
			var nodoPuerta:FLDomElement = this.iface.xmlModelo.createElement("Puerta");
			nodoPadre.appendChild(nodoPuerta);
			var puerta:String = cursor.valueBuffer("puertapf4");
			if (!flcontmode.iface.pub_verificarDato(puerta, true, "Puerta", 2)) {
				return false;
			}
			var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(puerta);
			nodoPuerta.appendChild(nodoTexto);
		}
	}

	if (cursor.valueBuffer("telefonopf4")) {
		var nodoTelefono:FLDomElement = this.iface.xmlModelo.createElement("Telefono");
		nodoPadre.appendChild(nodoTelefono);
		var telefono:String = cursor.valueBuffer("telefonopf4");
		if (!flcontmode.iface.pub_verificarDato(telefono, true, "Telefono", 9)) {
			return false;
		}
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(telefono);
		nodoTelefono.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("codpospf4")) {
		var nodoPostal:FLDomElement = this.iface.xmlModelo.createElement("CPostal");
		nodoPadre.appendChild(nodoPostal);
		var codpostal:String = cursor.valueBuffer("codpospf4");
		if (!flcontmode.iface.pub_verificarDato(codpostal, true, "CPostal", 5)) {
			return false;
		}
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(codpostal);
		nodoPostal.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("municipiopf4")) {
		var nodoMunicipio:FLDomElement = this.iface.xmlModelo.createElement("Municipio");
		nodoPadre.appendChild(nodoMunicipio);
		var municipio:String = cursor.valueBuffer("municipiopf4");
		if (!flcontmode.iface.pub_verificarDato(municipio, true, "Municipio", 20)) {
			return false;
		}
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(municipio);
		nodoMunicipio.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("codprovinciapf4")) {
		var nodoProvincia:FLDomElement = this.iface.xmlModelo.createElement("CodProv");
		nodoPadre.appendChild(nodoProvincia);
		var codProv:String = cursor.valueBuffer("codprovinciapf4");
		if (!flcontmode.iface.pub_verificarDato(codProv, true, "CodProv", 2)) {
			return false;
		}
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(codProv);
		nodoProvincia.appendChild(nodoTexto);
	}
	return true;
}

function oficial_informarNodoRepresentanteJuridica(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	if (cursor.valueBuffer("apellidosnombrepf4")) {
		var nodoNombre:FLDomElement = this.iface.xmlModelo.createElement("Nombre");
		nodoPadre.appendChild(nodoNombre);
		var nombre:String = cursor.valueBuffer("apellidosnombrepf4");
		if (!flcontmode.iface.pub_verificarDato(nombre, true, "Nombre representante", 36)) {
			return false;
		}
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(nombre);
		nodoNombre.appendChild(nodoTexto);
	}

	var nodoNif:FLDomElement = this.iface.xmlModelo.createElement("NIF");
	nodoPadre.appendChild(nodoNif);
	var nif:String = cursor.valueBuffer("nifpf4");
	if (!flcontmode.iface.pub_verificarDato(nif, true, "NIF representante", 9)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(nif);
	nodoNif.appendChild(nodoTexto);

	if (cursor.valueBuffer("fechapf4")) {
		var nodoFecha:FLDomElement = this.iface.xmlModelo.createElement("FechaPoder");
		nodoPadre.appendChild(nodoFecha);
		var fecha:String = cursor.valueBuffer("fechapf4");
		fecha = util.dateAMDtoDMA(fecha);
		if (!flcontmode.iface.pub_verificarDato(fecha, true, "Fecha Poder", 10)) {
			return false;
		}
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(fecha);
		nodoFecha.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("notariapf4")) {
		var nodoNotaria:FLDomElement = this.iface.xmlModelo.createElement("Notaria");
		nodoPadre.appendChild(nodoNotaria);
		var notaria:String = cursor.valueBuffer("notariapf4");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(notaria);
		nodoNotaria.appendChild(nodoTexto);
	}

	return true;
}

function oficial_informarNodoRegGeneral(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	var nodoBaseImponibleyCuota:FLDomElement = this.iface.xmlModelo.createElement("BaseImponibleyCuota");
	nodoPadre.appendChild(nodoBaseImponibleyCuota);
	if (!this.iface.informarNodoBaseImponibleyCuota(nodoBaseImponibleyCuota, version)) {
		return false;
	}

	var nodoDeducciones:FLDomElement = this.iface.xmlModelo.createElement("Deducciones");
	nodoPadre.appendChild(nodoDeducciones);
	if (!this.iface.informarNodoDeducciones(nodoDeducciones, version)) {
		return false;
	}

	if (cursor.valueBuffer("resrg")) {
		var nodoResRegGeneral:FLDomElement = this.iface.xmlModelo.createElement("ResRegGeneral");
		nodoPadre.appendChild(nodoResRegGeneral);
		var resultado:String = cursor.valueBuffer("resrg");
		if (!flcontmode.iface.pub_verificarDato(resultado, true, "Resultado", 15)) {
			return false;
		}
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(resultado);
		nodoResRegGeneral.appendChild(nodoTexto);
	}
	return true;
}	

function oficial_informarNodoDeducciones(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();

	if (cursor.valueBuffer("baseimponibleoibc")) {
		var nodoOpIntSC:FLDomElement = this.iface.xmlModelo.createElement("OpInterioresBienesServiciosCorrientes");
		nodoPadre.appendChild(nodoOpIntSC);
		if (!this.iface.informarNodoOpInterioresBienesServiciosCorrientes(nodoOpIntSC, version)) {
			return false;
		}
	}

	if (cursor.valueBuffer("baseimponibleoioibc")) {
		var nodoOpIntraG:FLDomElement = this.iface.xmlModelo.createElement("OpIntragrupoCorrientes");
		nodoPadre.appendChild(nodoOpIntraG);
		if (!this.iface.informarNodoOpItragrupoCorrientes(nodoOpIntraG, version)) {
			return false;
		}
	}

	if (cursor.valueBuffer("baseimponibleoibi")) {
		var nodoOpBieInv:FLDomElement = this.iface.xmlModelo.createElement("OpInterioresBienesInversion");
		nodoPadre.appendChild(nodoOpBieInv);
		if (!this.iface.informarNodoOpBieInv(nodoOpBieInv, version)) {
			return false;
		}
	}

	if (cursor.valueBuffer("baseimponibleoioibi")) {
		var nodoOpIntraBieInv:FLDomElement = this.iface.xmlModelo.createElement("OpIntragrupoBienesInversion");
		nodoPadre.appendChild(nodoOpIntraBieInv);
		if (!this.iface.informarNodoOpIntraBieInv(nodoOpIntraBieInv, version)) {
			return false;
		}
	}

	if (cursor.valueBuffer("baseimponibleimbc")) {
		var nodoImpBieCo:FLDomElement = this.iface.xmlModelo.createElement("ImportacionesBienesCorrientes");
		nodoPadre.appendChild(nodoImpBieCo);
		if (!this.iface.informarNodoImpBieCo(nodoImpBieCo, version)) {
			return false;
		}
	}

	if (cursor.valueBuffer("baseimponibleimbi")) {
		var nodoImpBieInv:FLDomElement = this.iface.xmlModelo.createElement("ImportacionesBienesInversion");
		nodoPadre.appendChild(nodoImpBieInv);
		if (!this.iface.informarNodoImpBieInv(nodoImpBieInv, version)) {
			return false;
		}
	}

	if (cursor.valueBuffer("baseimponibleaibc")) {
		var nodoAdqIntrBC:FLDomElement = this.iface.xmlModelo.createElement("AdqIntracomunitariasBienesCorrientes");
		nodoPadre.appendChild(nodoAdqIntrBC);
		if (!this.iface.informarNodoAdqIntrBC(nodoAdqIntrBC, version)) {
			return false;
		}
	}

	if (cursor.valueBuffer("baseimponibleaibi")) {
		var nodoAdqIntrBI:FLDomElement = this.iface.xmlModelo.createElement("AdqIntracomunitariasBienesInversion");
		nodoPadre.appendChild(nodoAdqIntrBI);
		if (!this.iface.informarNodoAdqIntrBI(nodoAdqIntrBI, version)) {
			return false;
		}
	}

	if (cursor.valueBuffer("baseimponiblere")) {
		var nodoComAgrGanP:FLDomElement = this.iface.xmlModelo.createElement("ComRegAgricGanadPesca");
		nodoPadre.appendChild(nodoComAgrGanP);
		if (!this.iface.informarNodoComAgrGanP(nodoComAgrGanP, version)) {
			return false;
		}
	}

	if (cursor.valueBuffer("cuotard")) {
		var nodoRectDed:FLDomElement = this.iface.xmlModelo.createElement("RectifDeducciones");
		nodoPadre.appendChild(nodoRectDed);
		var rectDed:String = cursor.valueBuffer("cuotard");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(rectDed);
		nodoRectDed.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("cuotarbi")) {
		var nodoRegInv:FLDomElement = this.iface.xmlModelo.createElement("RegularizInversiones");
		nodoPadre.appendChild(nodoRegInv);
		var regInv:String = cursor.valueBuffer("cuotarbi");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(regInv);
		nodoRegInv.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("cuotarpdpro")) {
		var nodoRegPr:FLDomElement = this.iface.xmlModelo.createElement("RegularizPorcProrrata");
		nodoPadre.appendChild(nodoRegPr);
		var regPr:String = cursor.valueBuffer("cuotarpdpro");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(regPr);
		nodoRegPr.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("sumaded")) {
		var nodoSumaDed:FLDomElement = this.iface.xmlModelo.createElement("SumDeducciones");
		nodoPadre.appendChild(nodoSumaDed);
		var sumaDed:String = cursor.valueBuffer("sumaded");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(sumaDed);
		nodoSumaDed.appendChild(nodoTexto);
	}


	return true;
}

function oficial_informarNodoOpInterioresBienesServiciosCorrientes(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	if (cursor.valueBuffer("baseimponibleoibc")) {
		var nodoTotal:FLDomElement = this.iface.xmlModelo.createElement("Total");
		nodoPadre.appendChild(nodoTotal);
		if (!this.iface.informarNodoOpInterioresBienesServiciosCorrientesTotal(nodoTotal, version)) {
			return false;
		}
	}
	return true;
}

function oficial_informarNodoOpInterioresBienesServiciosCorrientesTotal(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var nodoBI:FLDomElement = this.iface.xmlModelo.createElement("BI");
	nodoPadre.appendChild(nodoBI);
	var bi:String = cursor.valueBuffer("baseimponibleoibc");
	if (!flcontmode.iface.pub_verificarDato(bi, true, "BI", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(bi);
	nodoBI.appendChild(nodoTexto);

	var nodoCuota:FLDomElement = this.iface.xmlModelo.createElement("Cuota");
	nodoPadre.appendChild(nodoCuota);
	var cuota:String = cursor.valueBuffer("cuotaoibc");
	if (!flcontmode.iface.pub_verificarDato(cuota, true, "Cuota", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuota);
	nodoCuota.appendChild(nodoTexto);
	return true;
}

function oficial_informarNodoOpItragrupoCorrientes(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	if (cursor.valueBuffer("baseimponibleoioibc")) {
		var nodoTotal:FLDomElement = this.iface.xmlModelo.createElement("Total");
		nodoPadre.appendChild(nodoTotal);
		if (!this.iface.informarNodoOpItragrupoCorrientesTotal(nodoTotal, version)) {
			return false;
		}
	}
	return true;
}

function oficial_informarNodoOpItragrupoCorrientesTotal(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var nodoBI:FLDomElement = this.iface.xmlModelo.createElement("BI");
	nodoPadre.appendChild(nodoBI);
	var bi:String = cursor.valueBuffer("baseimponibleoioibc");
	if (!flcontmode.iface.pub_verificarDato(bi, true, "BI", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(bi);
	nodoBI.appendChild(nodoTexto);

	var nodoCuota:FLDomElement = this.iface.xmlModelo.createElement("Cuota");
	nodoPadre.appendChild(nodoCuota);
	var cuota:String = cursor.valueBuffer("cuotaoioibc");
	if (!flcontmode.iface.pub_verificarDato(cuota, true, "Cuota", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuota);
	nodoCuota.appendChild(nodoTexto);
	return true;
}

function oficial_informarNodoOpBieInv(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	if (cursor.valueBuffer("baseimponibleoibi")) {
		var nodoTotal:FLDomElement = this.iface.xmlModelo.createElement("Total");
		nodoPadre.appendChild(nodoTotal);
		if (!this.iface.informarNodoOpBieInvTotal(nodoTotal, version)) {
			return false;
		}
	}
	return true;
}

function oficial_informarNodoOpBieInvTotal(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var nodoBI:FLDomElement = this.iface.xmlModelo.createElement("BI");
	nodoPadre.appendChild(nodoBI);
	var bi:String = cursor.valueBuffer("baseimponibleoibi");
	if (!flcontmode.iface.pub_verificarDato(bi, true, "BI", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(bi);
	nodoBI.appendChild(nodoTexto);

	var nodoCuota:FLDomElement = this.iface.xmlModelo.createElement("Cuota");
	nodoPadre.appendChild(nodoCuota);
	var cuota:String = cursor.valueBuffer("cuotaoibi");
	if (!flcontmode.iface.pub_verificarDato(cuota, true, "Cuota", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuota);
	nodoCuota.appendChild(nodoTexto);
	return true;
}

function oficial_informarNodoOpIntraBieInv(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	if (cursor.valueBuffer("baseimponibleoioibi")) {
		var nodoTotal:FLDomElement = this.iface.xmlModelo.createElement("Total");
		nodoPadre.appendChild(nodoTotal);
		if (!this.iface.informarNodoOpIntraBieInvTotal(nodoTotal, version)) {
			return false;
		}
	}
	return true;
}

function oficial_informarNodoOpIntraBieInvTotal(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var nodoBI:FLDomElement = this.iface.xmlModelo.createElement("BI");
	nodoPadre.appendChild(nodoBI);
	var bi:String = cursor.valueBuffer("baseimponibleoioibi");
	if (!flcontmode.iface.pub_verificarDato(bi, true, "BI", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(bi);
	nodoBI.appendChild(nodoTexto);

	var nodoCuota:FLDomElement = this.iface.xmlModelo.createElement("Cuota");
	nodoPadre.appendChild(nodoCuota);
	var cuota:String = cursor.valueBuffer("cuotaoioibi");
	if (!flcontmode.iface.pub_verificarDato(cuota, true, "Cuota", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuota);
	nodoCuota.appendChild(nodoTexto);
	return true;
}

function oficial_informarNodoImpBieCo(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	if (cursor.valueBuffer("baseimponibleimbc")) {
		var nodoTotal:FLDomElement = this.iface.xmlModelo.createElement("Total");
		nodoPadre.appendChild(nodoTotal);
		if (!this.iface.informarNodoImpBieCoTotal(nodoTotal, version)) {
			return false;
		}
	}
	return true;
}

function oficial_informarNodoImpBieCoTotal(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var nodoBI:FLDomElement = this.iface.xmlModelo.createElement("BI");
	nodoPadre.appendChild(nodoBI);
	var bi:String = cursor.valueBuffer("baseimponibleimbc");
	if (!flcontmode.iface.pub_verificarDato(bi, true, "BI", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(bi);
	nodoBI.appendChild(nodoTexto);

	var nodoCuota:FLDomElement = this.iface.xmlModelo.createElement("Cuota");
	nodoPadre.appendChild(nodoCuota);
	var cuota:String = cursor.valueBuffer("cuotaimbc");
	if (!flcontmode.iface.pub_verificarDato(cuota, true, "Cuota", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuota);
	nodoCuota.appendChild(nodoTexto);
	return true;
}

function oficial_informarNodoImpBieInv(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	if (cursor.valueBuffer("baseimponibleimbi")) {
		var nodoTotal:FLDomElement = this.iface.xmlModelo.createElement("Total");
		nodoPadre.appendChild(nodoTotal);
		if (!this.iface.informarNodoImpBieInvTotal(nodoTotal, version)) {
			return false;
		}
	}
	return true;
}

function oficial_informarNodoImpBieInvTotal(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var nodoBI:FLDomElement = this.iface.xmlModelo.createElement("BI");
	nodoPadre.appendChild(nodoBI);
	var bi:String = cursor.valueBuffer("baseimponibleimbi");
	if (!flcontmode.iface.pub_verificarDato(bi, true, "BI", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(bi);
	nodoBI.appendChild(nodoTexto);

	var nodoCuota:FLDomElement = this.iface.xmlModelo.createElement("Cuota");
	nodoPadre.appendChild(nodoCuota);
	var cuota:String = cursor.valueBuffer("cuotaimbi");
	if (!flcontmode.iface.pub_verificarDato(cuota, true, "Cuota", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuota);
	nodoCuota.appendChild(nodoTexto);
	return true;
}

function oficial_informarNodoAdqIntrBC(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	if (cursor.valueBuffer("baseimponibleaibc")) {
		var nodoTotal:FLDomElement = this.iface.xmlModelo.createElement("Total");
		nodoPadre.appendChild(nodoTotal);
		if (!this.iface.informarNodoAdqIntrBCTotal(nodoTotal, version)) {
			return false;
		}
	}
	return true;
}

function oficial_informarNodoAdqIntrBCTotal(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var nodoBI:FLDomElement = this.iface.xmlModelo.createElement("BI");
	nodoPadre.appendChild(nodoBI);
	var bi:String = cursor.valueBuffer("baseimponibleaibc");
	if (!flcontmode.iface.pub_verificarDato(bi, true, "BI", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(bi);
	nodoBI.appendChild(nodoTexto);

	var nodoCuota:FLDomElement = this.iface.xmlModelo.createElement("Cuota");
	nodoPadre.appendChild(nodoCuota);
	var cuota:String = cursor.valueBuffer("cuotaaibc");
	if (!flcontmode.iface.pub_verificarDato(cuota, true, "Cuota", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuota);
	nodoCuota.appendChild(nodoTexto);
	return true;
}

function oficial_informarNodoComAgrGanP(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	if (cursor.valueBuffer("baseimponiblere")) {
		var nodoTotal:FLDomElement = this.iface.xmlModelo.createElement("TipoX");
		nodoPadre.appendChild(nodoTotal);
		if (!this.iface.informarNodoComAgrGanPTipoX(nodoTotal, version)) {
			return false;
		}
	}
	return true;
}

function oficial_informarNodoComAgrGanPTipoX(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var nodoBI:FLDomElement = this.iface.xmlModelo.createElement("BI");
	nodoPadre.appendChild(nodoBI);
	var bi:String = cursor.valueBuffer("baseimponiblere");
	if (!flcontmode.iface.pub_verificarDato(bi, true, "BI", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(bi);
	nodoBI.appendChild(nodoTexto);

	var nodoCuota:FLDomElement = this.iface.xmlModelo.createElement("Cuota");
	nodoPadre.appendChild(nodoCuota);
	var cuota:String = cursor.valueBuffer("cuotare");
	if (!flcontmode.iface.pub_verificarDato(cuota, true, "Cuota", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuota);
	nodoCuota.appendChild(nodoTexto);
	return true;
}

function oficial_informarNodoAdqIntrBI(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	if (cursor.valueBuffer("baseimponibleaibi")) {
		var nodoTotal:FLDomElement = this.iface.xmlModelo.createElement("Total");
		nodoPadre.appendChild(nodoTotal);
		if (!this.iface.informarNodoAdqIntrBITotal(nodoTotal, version)) {
			return false;
		}
	}
	return true;
}

function oficial_informarNodoAdqIntrBITotal(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var nodoBI:FLDomElement = this.iface.xmlModelo.createElement("BI");
	nodoPadre.appendChild(nodoBI);
	var bi:String = cursor.valueBuffer("baseimponibleaibi");
	if (!flcontmode.iface.pub_verificarDato(bi, true, "BI", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(bi);
	nodoBI.appendChild(nodoTexto);

	var nodoCuota:FLDomElement = this.iface.xmlModelo.createElement("Cuota");
	nodoPadre.appendChild(nodoCuota);
	var cuota:String = cursor.valueBuffer("cuotaaibi");
	if (!flcontmode.iface.pub_verificarDato(cuota, true, "Cuota", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuota);
	nodoCuota.appendChild(nodoTexto);
	return true;
}

function oficial_informarNodoBaseImponibleyCuota(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	if (cursor.valueBuffer("baseimponiblero0") || cursor.valueBuffer("baseimponiblero1") || cursor.valueBuffer("baseimponiblero2")) {
		var nodoRegOrdinario:FLDomElement = this.iface.xmlModelo.createElement("RegOrdinario");
		nodoPadre.appendChild(nodoRegOrdinario);
		if (!this.iface.informarNodoRegOrdinario(nodoRegOrdinario, version)) {
			MessageBox.information(util.translate("scripts", "Error al informar el nodo RegOrdinario"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}

	if (cursor.valueBuffer("baseimponibleoi0") || cursor.valueBuffer("baseimponibleoi1") || cursor.valueBuffer("baseimponibleoi2")) {
		var nodoOpIntragrupo:FLDomElement = this.iface.xmlModelo.createElement("OpIntragrupo");
		nodoPadre.appendChild(nodoOpIntragrupo);
		if (!this.iface.informarNodoOpIntragrupo(nodoOpIntragrupo, version)) {
			MessageBox.information(util.translate("scripts", "Error al informar el nodo OpIntragrupo"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}

	if (cursor.valueBuffer("baseimponiblere0") || cursor.valueBuffer("baseimponiblere1") || cursor.valueBuffer("baseimponiblere2")) {
		var nodoRegBienesUsados:FLDomElement = this.iface.xmlModelo.createElement("RegBienesUsados");
		nodoPadre.appendChild(nodoRegBienesUsados);
		if (!this.iface.informarNodoRegBienesUsados(nodoRegBienesUsados, version)) {
			MessageBox.information(util.translate("scripts", "Error al informar el nodo RegBienesUsados"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}

	if (cursor.valueBuffer("baseimponibleav")) {
		var nodoRegAgViajes:FLDomElement = this.iface.xmlModelo.createElement("RegAgViajes");
		nodoPadre.appendChild(nodoRegAgViajes);
		if (!this.iface.informarNodoRegAgViajes(nodoRegAgViajes, version)) {
			MessageBox.information(util.translate("scripts", "Error al informar el nodo RegAgViajes"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}

	if (cursor.valueBuffer("baseimponibleai0") || cursor.valueBuffer("baseimponibleai1") || cursor.valueBuffer("baseimponibleai2")) {
		var nodoAdqIntracomBienes:FLDomElement = this.iface.xmlModelo.createElement("AdqIntracomBienes");
		nodoPadre.appendChild(nodoAdqIntracomBienes);
		if (!this.iface.informarNodoAdqIntracomBienes(nodoAdqIntracomBienes, version)) {
			MessageBox.information(util.translate("scripts", "Error al informar el nodo AdqIntracomBienes"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}

	if (cursor.valueBuffer("baseimponibleis")) {
		var nodoIVAdevengadoInversionSP:FLDomElement = this.iface.xmlModelo.createElement("IVAdevengadoInversionSP");
		nodoPadre.appendChild(nodoIVAdevengadoInversionSP);
		if (!this.iface.informarNodoIVAdevengadoInversionSP(nodoIVAdevengadoInversionSP, version)) {
			MessageBox.information(util.translate("scripts", "Error al informar el nodo IVAdevengadoInversionSP"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}

	if (cursor.valueBuffer("baseimponiblebc")) {
		var nodoModBasesyCuotas:FLDomElement = this.iface.xmlModelo.createElement("ModBasesyCuotas");
		nodoPadre.appendChild(nodoModBasesyCuotas);
		if (!this.iface.informarNodoModBasesyCuotas(nodoModBasesyCuotas, version)) {
			MessageBox.information(util.translate("scripts", "Error al informar el nodo ModBasesyCuotas"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}

	if (cursor.valueBuffer("baseimponibleqs")) {
		var nodoModBasesyCuotasConAcr:FLDomElement = this.iface.xmlModelo.createElement("ModBasesyCuotasConcursoAcreedores");
		nodoPadre.appendChild(nodoModBasesyCuotasConAcr);
		if (!this.iface.informarNodoModBasesyCuotasConAcr(nodoModBasesyCuotasConAcr, version)) {
			MessageBox.information(util.translate("scripts", "Error al informar el nodo ModBasesyCuotasConcursoAcreedores"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}

	if (cursor.valueBuffer("baseimponibletotalbc")) {
		var nodoModBasesyCuotas:FLDomElement = this.iface.xmlModelo.createElement("TotalBasesyCuotasIVA");
		nodoPadre.appendChild(nodoModBasesyCuotas);
		if (!this.iface.informarNodoTotalBasesyCuotasIVA(nodoModBasesyCuotas, version)) {
			MessageBox.information(util.translate("scripts", "Error al informar el nodo TotalBasesyCuotasIVA"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}

	if (cursor.valueBuffer("baseimponibleeq0") || cursor.valueBuffer("baseimponibleeq1") || cursor.valueBuffer("baseimponibleeq2") || cursor.valueBuffer("baseimponibleeq3")) {
		var nodoRecargoEquivalencia:FLDomElement = this.iface.xmlModelo.createElement("RecargoEquivalencia");
		nodoPadre.appendChild(nodoRecargoEquivalencia);
		if (!this.iface.informarNodoRecargoEquivalencia(nodoRecargoEquivalencia, version)) {
			MessageBox.information(util.translate("scripts", "Error al informar el nodo RecargoEquivalencia"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}

	if (cursor.valueBuffer("baseimponiblemodeq")) {
		var nodoModRecargoEquivalencia:FLDomElement = this.iface.xmlModelo.createElement("ModRecargoEquivalencia");
		nodoPadre.appendChild(nodoModRecargoEquivalencia);
		if (!this.iface.informarNodoModRecargoEquivalencia(nodoModRecargoEquivalencia, version)) {
			MessageBox.information(util.translate("scripts", "Error al informar el nodo ModRecargoEquivalencia"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}

	if (cursor.valueBuffer("baseimponiblemodeqqs")) {
		var nodoModReEqConAcr:FLDomElement = this.iface.xmlModelo.createElement("ModRecargoEquivalenciaConcursoAcreedores");
		nodoPadre.appendChild(nodoModReEqConAcr);
		if (!this.iface.informarNodoModReEqConAcr(nodoModReEqConAcr, version)) {
			MessageBox.information(util.translate("scripts", "Error al informar el nodo ModRecargoEquivalenciaConcursoAcreedores"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}

	if (cursor.valueBuffer("totalivadev")) {
		var nodoTotalCuotasIVA:FLDomElement = this.iface.xmlModelo.createElement("TotalCuotasIVA");
		nodoPadre.appendChild(nodoTotalCuotasIVA);
		var total:String = cursor.valueBuffer("totalivadev");
		if (!flcontmode.iface.pub_verificarDato(total, true, "TotalCuotasIVA", 15)) {
			return false;
		}
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(total);
		nodoTotalCuotasIVA.appendChild(nodoTexto);
	}
	return true;
}

function oficial_informarNodoRegOrdinario(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	if (cursor.valueBuffer("baseimponiblero0")) {
		var nodoTipo4:FLDomElement = this.iface.xmlModelo.createElement("Tipo4");
		nodoPadre.appendChild(nodoTipo4);
		if (!this.iface.informarNodoRegOrdinarioTipo4(nodoTipo4, version)) {
			return false;
		}
	}

	if (cursor.valueBuffer("baseimponiblero1")) {
		var nodoTipo7:FLDomElement = this.iface.xmlModelo.createElement("Tipo7");
		nodoPadre.appendChild(nodoTipo7);
		if (!this.iface.informarNodoRegOrdinarioTipo7(nodoTipo7, version)) {
			return false;
		}
	}

	if (cursor.valueBuffer("baseimponiblero2")) {
		var nodoTipo16:FLDomElement = this.iface.xmlModelo.createElement("Tipo16");
		nodoPadre.appendChild(nodoTipo16);
		if (!this.iface.informarNodoRegOrdinarioTipo16(nodoTipo16, version)) {
			return false;
		}
	}
	return true;
}

function oficial_informarNodoOpIntragrupo(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	if (cursor.valueBuffer("baseimponibleoi0")) {
		var nodoTipo4:FLDomElement = this.iface.xmlModelo.createElement("Tipo4");
		nodoPadre.appendChild(nodoTipo4);
		if (!this.iface.informarNodoOpIntragrupoTipo4(nodoTipo4, version)) {
			return false;
		}
	}

	if (cursor.valueBuffer("baseimponibleoi1")) {
		var nodoTipo7:FLDomElement = this.iface.xmlModelo.createElement("Tipo7");
		nodoPadre.appendChild(nodoTipo7);
		if (!this.iface.informarNodoOpIntragrupoTipo7(nodoTipo7, version)) {
			return false;
		}
	}

	if (cursor.valueBuffer("baseimponibleoi2")) {
		var nodoTipo16:FLDomElement = this.iface.xmlModelo.createElement("Tipo16");
		nodoPadre.appendChild(nodoTipo16);
		if (!this.iface.informarNodoOpIntragrupoTipo16(nodoTipo16, version)) {
			return false;
		}
	}
	return true;
}

function oficial_informarNodoRegOrdinarioTipo4(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var nodoBI:FLDomElement = this.iface.xmlModelo.createElement("BI");
	nodoPadre.appendChild(nodoBI);
	var bi:String = cursor.valueBuffer("baseimponiblero0");
	if (!flcontmode.iface.pub_verificarDato(bi, true, "BI", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(bi);
	nodoBI.appendChild(nodoTexto);

	var nodoCuota:FLDomElement = this.iface.xmlModelo.createElement("Cuota");
	nodoPadre.appendChild(nodoCuota);
	var cuota:String = cursor.valueBuffer("cuotaro0");
	if (!flcontmode.iface.pub_verificarDato(cuota, true, "Cuota", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuota);
	nodoCuota.appendChild(nodoTexto);
	return true;
}

function oficial_informarNodoOpIntragrupoTipo4(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var nodoBI:FLDomElement = this.iface.xmlModelo.createElement("BI");
	nodoPadre.appendChild(nodoBI);
	var bi:String = cursor.valueBuffer("baseimponibleoi0");
	if (!flcontmode.iface.pub_verificarDato(bi, true, "BI", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(bi);
	nodoBI.appendChild(nodoTexto);

	var nodoCuota:FLDomElement = this.iface.xmlModelo.createElement("Cuota");
	nodoPadre.appendChild(nodoCuota);
	var cuota:String = cursor.valueBuffer("cuotaoi0");
	if (!flcontmode.iface.pub_verificarDato(cuota, true, "Cuota", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuota);
	nodoCuota.appendChild(nodoTexto);
	return true;
}

function oficial_informarNodoRegOrdinarioTipo7(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var nodoBI:FLDomElement = this.iface.xmlModelo.createElement("BI");
	nodoPadre.appendChild(nodoBI);
	var bi:String = cursor.valueBuffer("baseimponiblero1");
	if (!flcontmode.iface.pub_verificarDato(bi, true, "BI", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(bi);
	nodoBI.appendChild(nodoTexto);

	var nodoCuota:FLDomElement = this.iface.xmlModelo.createElement("Cuota");
	nodoPadre.appendChild(nodoCuota);
	var cuota:String = cursor.valueBuffer("cuotaro1");
	if (!flcontmode.iface.pub_verificarDato(cuota, true, "Cuota", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuota);
	nodoCuota.appendChild(nodoTexto);
	return true;
}

function oficial_informarNodoOpIntragrupoTipo7(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var nodoBI:FLDomElement = this.iface.xmlModelo.createElement("BI");
	nodoPadre.appendChild(nodoBI);
	var bi:String = cursor.valueBuffer("baseimponibleoi1");
	if (!flcontmode.iface.pub_verificarDato(bi, true, "BI", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(bi);
	nodoBI.appendChild(nodoTexto);

	var nodoCuota:FLDomElement = this.iface.xmlModelo.createElement("Cuota");
	nodoPadre.appendChild(nodoCuota);
	var cuota:String = cursor.valueBuffer("cuotaoi1");
	if (!flcontmode.iface.pub_verificarDato(cuota, true, "Cuota", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuota);
	nodoCuota.appendChild(nodoTexto);
	return true;
}

function oficial_informarNodoRegOrdinarioTipo16(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var nodoBI:FLDomElement = this.iface.xmlModelo.createElement("BI");
	nodoPadre.appendChild(nodoBI);
	var bi:String = cursor.valueBuffer("baseimponiblero2");
	if (!flcontmode.iface.pub_verificarDato(bi, true, "BI", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(bi);
	nodoBI.appendChild(nodoTexto);

	var nodoCuota:FLDomElement = this.iface.xmlModelo.createElement("Cuota");
	nodoPadre.appendChild(nodoCuota);
	var cuota:String = cursor.valueBuffer("cuotaro2");
	if (!flcontmode.iface.pub_verificarDato(cuota, true, "Cuota", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuota);
	nodoCuota.appendChild(nodoTexto);
	return true;
}

function oficial_informarNodoOpIntragrupoTipo16(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var nodoBI:FLDomElement = this.iface.xmlModelo.createElement("BI");
	nodoPadre.appendChild(nodoBI);
	var bi:String = cursor.valueBuffer("baseimponibleoi2");
	if (!flcontmode.iface.pub_verificarDato(bi, true, "BI", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(bi);
	nodoBI.appendChild(nodoTexto);

	var nodoCuota:FLDomElement = this.iface.xmlModelo.createElement("Cuota");
	nodoPadre.appendChild(nodoCuota);
	var cuota:String = cursor.valueBuffer("cuotaoi2");
	if (!flcontmode.iface.pub_verificarDato(cuota, true, "Cuota", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuota);
	nodoCuota.appendChild(nodoTexto);
	return true;
}

function oficial_informarNodoRegBienesUsados(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	if (cursor.valueBuffer("baseimponiblere0")) {
		var nodoTipo4:FLDomElement = this.iface.xmlModelo.createElement("Tipo4");
		nodoPadre.appendChild(nodoTipo4);
		if (!this.iface.informarNodoRegOrdinarioTipo4(nodoTipo4, version)) {
			return false;
		}
	}

	if (cursor.valueBuffer("baseimponiblere1")) {
		var nodoTipo7:FLDomElement = this.iface.xmlModelo.createElement("Tipo7");
		nodoPadre.appendChild(nodoTipo7);
		if (!this.iface.informarNodoRegOrdinarioTipo7(nodoTipo7, version)) {
			return false;
		}
	}

	if (cursor.valueBuffer("baseimponiblere2")) {
		var nodoTipo16:FLDomElement = this.iface.xmlModelo.createElement("Tipo16");
		nodoPadre.appendChild(nodoTipo16);
		if (!this.iface.informarNodoRegOrdinarioTipo16(nodoTipo16, version)) {
			return false;
		}
	}
	return true;
}

function oficial_informarNodoRegBienesUsadosTipo4(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var nodoBI:FLDomElement = this.iface.xmlModelo.createElement("BI");
	nodoPadre.appendChild(nodoBI);
	var bi:String = cursor.valueBuffer("baseimponiblere0");
	if (!flcontmode.iface.pub_verificarDato(bi, true, "BI", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(bi);
	nodoBI.appendChild(nodoTexto);

	var nodoCuota:FLDomElement = this.iface.xmlModelo.createElement("Cuota");
	nodoPadre.appendChild(nodoCuota);
	var cuota:String = cursor.valueBuffer("cuotare0");
	if (!flcontmode.iface.pub_verificarDato(cuota, true, "Cuota", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuota);
	nodoCuota.appendChild(nodoTexto);
	return true;
}

function oficial_informarNodoRegBienesUsadosTipo7(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var nodoBI:FLDomElement = this.iface.xmlModelo.createElement("BI");
	nodoPadre.appendChild(nodoBI);
	var bi:String = cursor.valueBuffer("baseimponiblere1");
	if (!flcontmode.iface.pub_verificarDato(bi, true, "BI", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(bi);
	nodoBI.appendChild(nodoTexto);

	var nodoCuota:FLDomElement = this.iface.xmlModelo.createElement("Cuota");
	nodoPadre.appendChild(nodoCuota);
	var cuota:String = cursor.valueBuffer("cuotare1");
	if (!flcontmode.iface.pub_verificarDato(cuota, true, "Cuota", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuota);
	nodoCuota.appendChild(nodoTexto);
	return true;
}

function oficial_informarNodoRegBienesUsadosTipo16(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var nodoBI:FLDomElement = this.iface.xmlModelo.createElement("BI");
	nodoPadre.appendChild(nodoBI);
	var bi:String = cursor.valueBuffer("baseimponiblere2");
	if (!flcontmode.iface.pub_verificarDato(bi, true, "BI", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(bi);
	nodoBI.appendChild(nodoTexto);

	var nodoCuota:FLDomElement = this.iface.xmlModelo.createElement("Cuota");
	nodoPadre.appendChild(nodoCuota);
	var cuota:String = cursor.valueBuffer("cuotare2");
	if (!flcontmode.iface.pub_verificarDato(cuota, true, "Cuota", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuota);
	nodoCuota.appendChild(nodoTexto);
	return true;
}

function oficial_informarNodoRegAgViajes(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	if (cursor.valueBuffer("baseimponibleav")) {
		var nodoTipo16:FLDomElement = this.iface.xmlModelo.createElement("Tipo16");
		nodoPadre.appendChild(nodoTipo16);
		if (!this.iface.informarNodoRegAgViajesTipo16(nodoTipo16, version)) {
			return false;
		}
	}
	return true;
}

function oficial_informarNodoRegAgViajesTipo16(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var nodoBI:FLDomElement = this.iface.xmlModelo.createElement("BI");
	nodoPadre.appendChild(nodoBI);
	var bi:String = cursor.valueBuffer("baseimponibleav");
	if (!flcontmode.iface.pub_verificarDato(bi, true, "BI", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(bi);
	nodoBI.appendChild(nodoTexto);

	var nodoCuota:FLDomElement = this.iface.xmlModelo.createElement("Cuota");
	nodoPadre.appendChild(nodoCuota);
	var cuota:String = cursor.valueBuffer("cuotaav");
	if (!flcontmode.iface.pub_verificarDato(cuota, true, "Cuota", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuota);
	nodoCuota.appendChild(nodoTexto);
	return true;
}

function oficial_informarNodoAdqIntracomBienes(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	if (cursor.valueBuffer("baseimponibleai0")) {
		var nodoTipo4:FLDomElement = this.iface.xmlModelo.createElement("Tipo4");
		nodoPadre.appendChild(nodoTipo4);
		if (!this.iface.informarNodoAdqIntracomBienesTipo4(nodoTipo4, version)) {
			return false;
		}
	}

	if (cursor.valueBuffer("baseimponibleai1")) {
		var nodoTipo7:FLDomElement = this.iface.xmlModelo.createElement("Tipo7");
		nodoPadre.appendChild(nodoTipo7);
		if (!this.iface.informarNodoAdqIntracomBienesTipo7(nodoTipo7, version)) {
			return false;
		}
	}

	if (cursor.valueBuffer("baseimponibleai2")) {
		var nodoTipo16:FLDomElement = this.iface.xmlModelo.createElement("Tipo16");
		nodoPadre.appendChild(nodoTipo16);
		if (!this.iface.informarNodoAdqIntracomBienesTipo16(nodoTipo16, version)) {
			return false;
		}
	}
	return true;
}

function oficial_informarNodoAdqIntracomBienesTipo4(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var nodoBI:FLDomElement = this.iface.xmlModelo.createElement("BI");
	nodoPadre.appendChild(nodoBI);
	var bi:String = cursor.valueBuffer("baseimponibleai0");
	if (!flcontmode.iface.pub_verificarDato(bi, true, "BI", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(bi);
	nodoBI.appendChild(nodoTexto);

	var nodoCuota:FLDomElement = this.iface.xmlModelo.createElement("Cuota");
	nodoPadre.appendChild(nodoCuota);
	var cuota:String = cursor.valueBuffer("cuotaai0");
	if (!flcontmode.iface.pub_verificarDato(cuota, true, "Cuota", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuota);
	nodoCuota.appendChild(nodoTexto);
	return true;
}

function oficial_informarNodoAdqIntracomBienesTipo7(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var nodoBI:FLDomElement = this.iface.xmlModelo.createElement("BI");
	nodoPadre.appendChild(nodoBI);
	var bi:String = cursor.valueBuffer("baseimponibleai1");
	if (!flcontmode.iface.pub_verificarDato(bi, true, "BI", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(bi);
	nodoBI.appendChild(nodoTexto);

	var nodoCuota:FLDomElement = this.iface.xmlModelo.createElement("Cuota");
	nodoPadre.appendChild(nodoCuota);
	var cuota:String = cursor.valueBuffer("cuotaai1");
	if (!flcontmode.iface.pub_verificarDato(cuota, true, "Cuota", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuota);
	nodoCuota.appendChild(nodoTexto);
	return true;
}

function oficial_informarNodoAdqIntracomBienesTipo16(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var nodoBI:FLDomElement = this.iface.xmlModelo.createElement("BI");
	nodoPadre.appendChild(nodoBI);
	var bi:String = cursor.valueBuffer("baseimponibleai2");
	if (!flcontmode.iface.pub_verificarDato(bi, true, "BI", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(bi);
	nodoBI.appendChild(nodoTexto);

	var nodoCuota:FLDomElement = this.iface.xmlModelo.createElement("Cuota");
	nodoPadre.appendChild(nodoCuota);
	var cuota:String = cursor.valueBuffer("cuotaai2");
	if (!flcontmode.iface.pub_verificarDato(cuota, true, "Cuota", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuota);
	nodoCuota.appendChild(nodoTexto);
	return true;
}

function oficial_informarNodoIVAdevengadoInversionSP(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	if (cursor.valueBuffer("baseimponibleis")) {
		var nodoTipoX:FLDomElement = this.iface.xmlModelo.createElement("TipoX");
		nodoPadre.appendChild(nodoTipoX);
		if (!this.iface.informarNodoIVAdevengadoInversionSPTipoX(nodoTipoX, version)) {
			return false;
		}
	}
	return true;
}

function oficial_informarNodoIVAdevengadoInversionSPTipoX(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var nodoBI:FLDomElement = this.iface.xmlModelo.createElement("BI");
	nodoPadre.appendChild(nodoBI);
	var bi:String = cursor.valueBuffer("baseimponibleis");
	if (!flcontmode.iface.pub_verificarDato(bi, true, "BI", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(bi);
	nodoBI.appendChild(nodoTexto);

	var nodoCuota:FLDomElement = this.iface.xmlModelo.createElement("Cuota");
	nodoPadre.appendChild(nodoCuota);
	var cuota:String = cursor.valueBuffer("cuotais");
	if (!flcontmode.iface.pub_verificarDato(cuota, true, "Cuota", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuota);
	nodoCuota.appendChild(nodoTexto);
	return true;
}

function oficial_informarNodoModBasesyCuotas(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	if (cursor.valueBuffer("baseimponiblebc")) {
		var nodoTipoX:FLDomElement = this.iface.xmlModelo.createElement("TipoX");
		nodoPadre.appendChild(nodoTipoX);
		if (!this.iface.informarNodoModBasesyCuotasTipoX(nodoTipoX, version)) {
			return false;
		}
	}
	return true;
}

function oficial_informarNodoModBasesyCuotasConAcr(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	if (cursor.valueBuffer("baseimponibleqs")) {
		var nodoTipoX:FLDomElement = this.iface.xmlModelo.createElement("TipoX");
		nodoPadre.appendChild(nodoTipoX);
		if (!this.iface.informarNodoModBasesyCuotasConAcrTipoX(nodoTipoX, version)) {
			return false;
		}
	}
	return true;
}

function oficial_informarNodoModBasesyCuotasConAcrTipoX(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var nodoBI:FLDomElement = this.iface.xmlModelo.createElement("BI");
	nodoPadre.appendChild(nodoBI);
	var bi:String = cursor.valueBuffer("baseimponibleqs");
	if (!flcontmode.iface.pub_verificarDato(bi, true, "BI", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(bi);
	nodoBI.appendChild(nodoTexto);

	var nodoCuota:FLDomElement = this.iface.xmlModelo.createElement("Cuota");
	nodoPadre.appendChild(nodoCuota);
	var cuota:String = cursor.valueBuffer("cuotaqs");
	if (!flcontmode.iface.pub_verificarDato(cuota, true, "Cuota", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuota);
	nodoCuota.appendChild(nodoTexto);
	return true;
}

function oficial_informarNodoModBasesyCuotasTipoX(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var nodoBI:FLDomElement = this.iface.xmlModelo.createElement("BI");
	nodoPadre.appendChild(nodoBI);
	var bi:String = cursor.valueBuffer("baseimponiblebc");
	if (!flcontmode.iface.pub_verificarDato(bi, true, "BI", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(bi);
	nodoBI.appendChild(nodoTexto);

	var nodoCuota:FLDomElement = this.iface.xmlModelo.createElement("Cuota");
	nodoPadre.appendChild(nodoCuota);
	var cuota:String = cursor.valueBuffer("cuotabc");
	if (!flcontmode.iface.pub_verificarDato(cuota, true, "Cuota", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuota);
	nodoCuota.appendChild(nodoTexto);
	return true;
}

function oficial_informarNodoTotalBasesyCuotasIVA(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	if (cursor.valueBuffer("baseimponibletotalbc")) {
		var nodoTipoX:FLDomElement = this.iface.xmlModelo.createElement("TipoX");
		nodoPadre.appendChild(nodoTipoX);
		if (!this.iface.informarNodoTotalBasesyCuotasIVATipoX(nodoTipoX, version)) {
			return false;
		}
	}
	return true;
}

function oficial_informarNodoTotalBasesyCuotasIVATipoX(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var nodoBI:FLDomElement = this.iface.xmlModelo.createElement("BI");
	nodoPadre.appendChild(nodoBI);
	var bi:String = cursor.valueBuffer("baseimponibletotalbc");
	if (!flcontmode.iface.pub_verificarDato(bi, true, "BI", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(bi);
	nodoBI.appendChild(nodoTexto);

	var nodoCuota:FLDomElement = this.iface.xmlModelo.createElement("Cuota");
	nodoPadre.appendChild(nodoCuota);
	var cuota:String = cursor.valueBuffer("cuotatotalbc");
	if (!flcontmode.iface.pub_verificarDato(cuota, true, "Cuota", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuota);
	nodoCuota.appendChild(nodoTexto);
	return true;
}

function oficial_informarNodoRecargoEquivalencia(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	if (cursor.valueBuffer("baseimponibleeq0")) {
		var nodoTipo05:FLDomElement = this.iface.xmlModelo.createElement("Tipo05");
		nodoPadre.appendChild(nodoTipo05);
		if (!this.iface.informarNodoRecargoEquivalenciaTipo05(nodoTipo05, version)) {
			return false;
		}
	}

	if (cursor.valueBuffer("baseimponibleeq1")) {
		var nodoTipo1:FLDomElement = this.iface.xmlModelo.createElement("Tipo1");
		nodoPadre.appendChild(nodoTipo1);
		if (!this.iface.informarNodoRecargoEquivalenciaTipo1(nodoTipo1, version)) {
			return false;
		}
	}

	if (cursor.valueBuffer("baseimponibleeq2")) {
		var nodoTipo4:FLDomElement = this.iface.xmlModelo.createElement("Tipo4");
		nodoPadre.appendChild(nodoTipo4);
		if (!this.iface.informarNodoRecargoEquivalenciaTipo4(nodoTipo4, version)) {
			return false;
		}
	}

	if (cursor.valueBuffer("baseimponibleeq3")) {
		var nodoTipo175:FLDomElement = this.iface.xmlModelo.createElement("Tipo175");
		nodoPadre.appendChild(nodoTipo175);
		if (!this.iface.informarNodoRecargoEquivalenciaTipo175(nodoTipo175, version)) {
			return false;
		}
	}
	return true;
}

function oficial_informarNodoRecargoEquivalenciaTipo05(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var nodoBI:FLDomElement = this.iface.xmlModelo.createElement("BI");
	nodoPadre.appendChild(nodoBI);
	var bi:String = cursor.valueBuffer("baseimponibleeq0");
	if (!flcontmode.iface.pub_verificarDato(bi, true, "BI", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(bi);
	nodoBI.appendChild(nodoTexto);

	var nodoCuota:FLDomElement = this.iface.xmlModelo.createElement("Cuota");
	nodoPadre.appendChild(nodoCuota);
	var cuota:String = cursor.valueBuffer("cuotaeq0");
	if (!flcontmode.iface.pub_verificarDato(cuota, true, "Cuota", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuota);
	nodoCuota.appendChild(nodoTexto);
	return true;
}

function oficial_informarNodoRecargoEquivalenciaTipo1(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var nodoBI:FLDomElement = this.iface.xmlModelo.createElement("BI");
	nodoPadre.appendChild(nodoBI);
	var bi:String = cursor.valueBuffer("baseimponibleeq1");
	if (!flcontmode.iface.pub_verificarDato(bi, true, "BI", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(bi);
	nodoBI.appendChild(nodoTexto);

	var nodoCuota:FLDomElement = this.iface.xmlModelo.createElement("Cuota");
	nodoPadre.appendChild(nodoCuota);
	var cuota:String = cursor.valueBuffer("cuotaeq1");
	if (!flcontmode.iface.pub_verificarDato(cuota, true, "Cuota", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuota);
	nodoCuota.appendChild(nodoTexto);
	return true;
}

function oficial_informarNodoRecargoEquivalenciaTipo4(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var nodoBI:FLDomElement = this.iface.xmlModelo.createElement("BI");
	nodoPadre.appendChild(nodoBI);
	var bi:String = cursor.valueBuffer("baseimponibleeq2");
	if (!flcontmode.iface.pub_verificarDato(bi, true, "BI", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(bi);
	nodoBI.appendChild(nodoTexto);

	var nodoCuota:FLDomElement = this.iface.xmlModelo.createElement("Cuota");
	nodoPadre.appendChild(nodoCuota);
	var cuota:String = cursor.valueBuffer("cuotaeq2");
	if (!flcontmode.iface.pub_verificarDato(cuota, true, "Cuota", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuota);
	nodoCuota.appendChild(nodoTexto);
	return true;
}

function oficial_informarNodoRecargoEquivalenciaTipo175(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var nodoBI:FLDomElement = this.iface.xmlModelo.createElement("BI");
	nodoPadre.appendChild(nodoBI);
	var bi:String = cursor.valueBuffer("baseimponibleeq3");
	if (!flcontmode.iface.pub_verificarDato(bi, true, "BI", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(bi);
	nodoBI.appendChild(nodoTexto);

	var nodoCuota:FLDomElement = this.iface.xmlModelo.createElement("Cuota");
	nodoPadre.appendChild(nodoCuota);
	var cuota:String = cursor.valueBuffer("cuotaeq3");
	if (!flcontmode.iface.pub_verificarDato(cuota, true, "Cuota", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuota);
	nodoCuota.appendChild(nodoTexto);
	return true;
}

function oficial_informarNodoModReEqConAcr(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	if (cursor.valueBuffer("baseimponiblemodeqqs")) {
		var nodoTipoX:FLDomElement = this.iface.xmlModelo.createElement("TipoX");
		nodoPadre.appendChild(nodoTipoX);
		if (!this.iface.informarNodoModReEqConAcrTipoX(nodoTipoX, version)) {
			return false;
		}
	}
	return true;
}

function oficial_informarNodoModRecargoEquivalencia(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	if (cursor.valueBuffer("baseimponiblemodeq")) {
		var nodoTipoX:FLDomElement = this.iface.xmlModelo.createElement("TipoX");
		nodoPadre.appendChild(nodoTipoX);
		if (!this.iface.informarNodoModRecargoEquivalenciaTipoX(nodoTipoX, version)) {
			return false;
		}
	}
	return true;
}

function oficial_informarNodoModReEqConAcrTipoX(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var nodoBI:FLDomElement = this.iface.xmlModelo.createElement("BI");
	nodoPadre.appendChild(nodoBI);
	var bi:String = cursor.valueBuffer("baseimponiblemodeqqs");
	if (!flcontmode.iface.pub_verificarDato(bi, true, "BI", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(bi);
	nodoBI.appendChild(nodoTexto);

	var nodoCuota:FLDomElement = this.iface.xmlModelo.createElement("Cuota");
	nodoPadre.appendChild(nodoCuota);
	var cuota:String = cursor.valueBuffer("cuotamodeqqs");
	if (!flcontmode.iface.pub_verificarDato(cuota, true, "Cuota", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuota);
	nodoCuota.appendChild(nodoTexto);
	return true;
}

function oficial_informarNodoModRecargoEquivalenciaTipoX(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var nodoBI:FLDomElement = this.iface.xmlModelo.createElement("BI");
	nodoPadre.appendChild(nodoBI);
	var bi:String = cursor.valueBuffer("baseimponiblemodeq");
	if (!flcontmode.iface.pub_verificarDato(bi, true, "BI", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(bi);
	nodoBI.appendChild(nodoTexto);

	var nodoCuota:FLDomElement = this.iface.xmlModelo.createElement("Cuota");
	nodoPadre.appendChild(nodoCuota);
	var cuota:String = cursor.valueBuffer("cuotamodeq");
	if (!flcontmode.iface.pub_verificarDato(cuota, true, "Cuota", 15)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuota);
	nodoCuota.appendChild(nodoTexto);
	return true;
}

function oficial_informarNodoRegSimplificado(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	if (cursor.valueBuffer("epigrafe1") || cursor.valueBuffer("epigrafe12")) {
		var nodoActividad:FLDomElement = this.iface.xmlModelo.createElement("Actividad");
		nodoPadre.appendChild(nodoActividad);
		if (!this.iface.informarNodoActividad(nodoActividad, version)) {
			return false;
		}
	}

	if (cursor.valueBuffer("codigo1") || cursor.valueBuffer("codigo2") || cursor.valueBuffer("codigo3") || cursor.valueBuffer("codigo4") || cursor.valueBuffer("codigo5")) {
		var nodoActAgricGanadForest:FLDomElement = this.iface.xmlModelo.createElement("ActAgricGanadForest");
		nodoPadre.appendChild(nodoActAgricGanadForest);
		if (!this.iface.informarNodoActAgricGanadForest(nodoActAgricGanadForest, version)) {
			return false;
		}
	}

	if (cursor.valueBuffer("sumacdan") || cursor.valueBuffer("sumacda") || cursor.valueBuffer("ivadevai") || cursor.valueBuffer("ivadevis") || cursor.valueBuffer("ivadevea") || cursor.valueBuffer("totalcres")) {
		var nodoIvaDevengado:FLDomElement = this.iface.xmlModelo.createElement("IvaDevengado");
		nodoPadre.appendChild(nodoIvaDevengado);
		if (!this.iface.informarNodoIvaDevengado(nodoIvaDevengado, version)) {
			return false;
		}
	}

	if (cursor.valueBuffer("ivasopaf") || cursor.valueBuffer("regbienesi") || cursor.valueBuffer("sumadeducciones")) {
		var nodoIvaDeducible:FLDomElement = this.iface.xmlModelo.createElement("IvaDeducible");
		nodoPadre.appendChild(nodoIvaDeducible);
		if (!this.iface.informarNodoIvaDeducible(nodoIvaDeducible, version)) {
			return false;
		}
	}

	if (cursor.valueBuffer("ressimpl")) {
		var nodoResSimpl:FLDomElement = this.iface.xmlModelo.createElement("ResRegimenSimplificado");
		nodoPadre.appendChild(nodoResSimpl);
		var resRegSimp:String = cursor.valueBuffer("ressimpl");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(resRegSimp);
		nodoResSimpl.appendChild(nodoTexto);
	}

	return true;
}	

function oficial_informarNodoActividad(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	if (cursor.valueBuffer("epigrafe1")) {
		if (!this.iface.informarNodoActividad1(nodoPadre, version)) {
			return false;
		}
	}
	if (cursor.valueBuffer("epigrafe12")) {
		if (!this.iface.informarNodoActividad2(nodoPadre, version)) {
			return false;
		}
	}
	return true;
}

function oficial_informarNodoActividad1(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var nodoEpigrafe:FLDomElement = this.iface.xmlModelo.createElement("Epigrafe");
	nodoPadre.appendChild(nodoEpigrafe);
	var epigrafe:String = cursor.valueBuffer("epigrafe1");
	if (!flcontmode.iface.pub_verificarDato(epigrafe, true, "Epigrafe", 5)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(epigrafe);
	nodoEpigrafe.appendChild(nodoTexto);

	if (cursor.valueBuffer("unimod1") || cursor.valueBuffer("importe1") || cursor.valueBuffer("unimod2") || cursor.valueBuffer("importe2") || cursor.valueBuffer("unimod3") || cursor.valueBuffer("importe3") || cursor.valueBuffer("unimod4") || cursor.valueBuffer("importe4") || cursor.valueBuffer("unimod5") || cursor.valueBuffer("importe5") || cursor.valueBuffer("unimod6") || cursor.valueBuffer("importe6") || cursor.valueBuffer("unimod7") || cursor.valueBuffer("importe7")) {
		var nodoModulo:FLDomElement = this.iface.xmlModelo.createElement("Modulo");
		nodoPadre.appendChild(nodoModulo);
		if (!this.iface.informarNodoModulo(nodoModulo, version)) {
			return false;
		}
	}

	if (cursor.valueBuffer("cuotadevopc")) {
		var nodoCuotaDev:FLDomElement = this.iface.xmlModelo.createElement("CuotaDevengada");
		nodoPadre.appendChild(nodoCuotaDev);
		var cuotaDev:String = cursor.valueBuffer("cuotadevopc");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuotaDev);
		nodoCuotaDev.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("cuotassopopc")) {
		var nodoCuotaSop:FLDomElement = this.iface.xmlModelo.createElement("CuotaSoportada");
		nodoPadre.appendChild(nodoCuotaSop);
		var cuotaSop:String = cursor.valueBuffer("cuotassopopc");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuotaSop);
		nodoCuotaSop.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("indicecorrector")) {
		var nodoIndiceCor:FLDomElement = this.iface.xmlModelo.createElement("IndiceCorrector");
		nodoPadre.appendChild(nodoIndiceCor);
		var indiceCor:String = cursor.valueBuffer("indicecorrector");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(indiceCor);
		nodoIndiceCor.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("resultado")) {
		var nodoResultado:FLDomElement = this.iface.xmlModelo.createElement("Resultado");
		nodoPadre.appendChild(nodoResultado);
		var resultado:String = cursor.valueBuffer("resultado");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(resultado);
		nodoResultado.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("porcuotaminima")) {
		var nodoPorCuotaMin:FLDomElement = this.iface.xmlModelo.createElement("PorcCuotaMinima");
		nodoPadre.appendChild(nodoPorCuotaMin);
		var porCuotaMin:String = cursor.valueBuffer("porcuotaminima");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(porCuotaMin);
		nodoPorCuotaMin.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("devcuotassopop")) {
		var nodoDevCuotaOP:FLDomElement = this.iface.xmlModelo.createElement("DevCuotaSopOtrosPaises");
		nodoPadre.appendChild(nodoPorCuotaMin);
		var porCuotaMin:String = cursor.valueBuffer("devcuotassopop");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(porCuotaMin);
		nodoPorCuotaMin.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("cuotaminima")) {
		var nodoCuotaMin:FLDomElement = this.iface.xmlModelo.createElement("CuotaMinima");
		nodoPadre.appendChild(nodoCuotaMin);
		var cuotaMin:String = cursor.valueBuffer("cuotaminima");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuotaMin);
		nodoCuotaMin.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("cuotaregsimpl")) {
		var nodoCuotaRegSimp:FLDomElement = this.iface.xmlModelo.createElement("CuotaRegSimplificado");
		nodoPadre.appendChild(nodoCuotaRegSimp);
		var cuotaRegSimp:String = cursor.valueBuffer("cuotaregsimpl");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuotaRegSimp);
		nodoCuotaRegSimp.appendChild(nodoTexto);
	}
	return true;
}

function oficial_informarNodoActividad2(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var nodoEpigrafe:FLDomElement = this.iface.xmlModelo.createElement("Epigrafe");
	nodoPadre.appendChild(nodoEpigrafe);
	var epigrafe:String = cursor.valueBuffer("epigrafe12");
	if (!flcontmode.iface.pub_verificarDato(epigrafe, true, "Epigrafe", 5)) {
		return false;
	}
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(epigrafe);
	nodoEpigrafe.appendChild(nodoTexto);

	if (cursor.valueBuffer("unimod12") || cursor.valueBuffer("importe12") || cursor.valueBuffer("unimod22") || cursor.valueBuffer("importe22") || cursor.valueBuffer("unimod32") || cursor.valueBuffer("importe32") || cursor.valueBuffer("unimod42") || cursor.valueBuffer("importe42") || cursor.valueBuffer("unimod52") || cursor.valueBuffer("importe52") || cursor.valueBuffer("unimod62") || cursor.valueBuffer("importe62") || cursor.valueBuffer("unimod72") || cursor.valueBuffer("importe72")) {
		var nodoModulo:FLDomElement = this.iface.xmlModelo.createElement("Modulo");
		nodoPadre.appendChild(nodoModulo);
		if (!this.iface.informarNodoModulo(nodoModulo, version)) {
			return false;
		}
	}

	if (cursor.valueBuffer("cuotadevopc2")) {
		var nodoCuotaDev:FLDomElement = this.iface.xmlModelo.createElement("CuotaDevengada");
		nodoPadre.appendChild(nodoCuotaDev);
		var cuotaDev:String = cursor.valueBuffer("cuotadevopc2");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuotaDev);
		nodoCuotaDev.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("cuotassopopc2")) {
		var nodoCuotaSop:FLDomElement = this.iface.xmlModelo.createElement("CuotaSoportada");
		nodoPadre.appendChild(nodoCuotaSop);
		var cuotaSop:String = cursor.valueBuffer("cuotassopopc2");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuotaSop);
		nodoCuotaSop.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("indicecorrector2")) {
		var nodoIndiceCor:FLDomElement = this.iface.xmlModelo.createElement("IndiceCorrector");
		nodoPadre.appendChild(nodoIndiceCor);
		var indiceCor:String = cursor.valueBuffer("indicecorrector2");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(indiceCor);
		nodoIndiceCor.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("resultado2")) {
		var nodoResultado:FLDomElement = this.iface.xmlModelo.createElement("Resultado");
		nodoPadre.appendChild(nodoResultado);
		var resultado:String = cursor.valueBuffer("resultado2");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(resultado);
		nodoResultado.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("porcuotaminima2")) {
		var nodoPorCuotaMin:FLDomElement = this.iface.xmlModelo.createElement("PorcCuotaMinima");
		nodoPadre.appendChild(nodoPorCuotaMin);
		var porCuotaMin:String = cursor.valueBuffer("porcuotaminima2");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(porCuotaMin);
		nodoPorCuotaMin.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("devcuotassopop2")) {
		var nodoDevCuotaOP:FLDomElement = this.iface.xmlModelo.createElement("DevCuotaSopOtrosPaises");
		nodoPadre.appendChild(nodoPorCuotaMin);
		var porCuotaMin:String = cursor.valueBuffer("devcuotassopop2");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(porCuotaMin);
		nodoPorCuotaMin.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("cuotaminima2")) {
		var nodoCuotaMin:FLDomElement = this.iface.xmlModelo.createElement("CuotaMinima");
		nodoPadre.appendChild(nodoCuotaMin);
		var cuotaMin:String = cursor.valueBuffer("cuotaminima2");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuotaMin);
		nodoCuotaMin.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("cuotaregsimpl2")) {
		var nodoCuotaRegSimp:FLDomElement = this.iface.xmlModelo.createElement("CuotaRegSimplificado");
		nodoPadre.appendChild(nodoCuotaRegSimp);
		var cuotaRegSimp:String = cursor.valueBuffer("cuotaregsimpl2");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuotaRegSimp);
		nodoCuotaRegSimp.appendChild(nodoTexto);
	}
	return true;
}

function oficial_informarNodoModulo(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	if (cursor.valueBuffer("unimod1") || cursor.valueBuffer("importe1")) {
		var nodoModulo:FLDomElement = this.iface.xmlModelo.createElement("NumModulo");
		nodoPadre.appendChild(nodoModulo);
		var numModulo:String = "1";
		if (!flcontmode.iface.pub_verificarDato(numModulo, true, "NumModulo", 1)) {
			return false;
		}
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(numModulo);
		nodoModulo.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("unimod1")) {
		var nodoUnidades:FLDomElement = this.iface.xmlModelo.createElement("Unidades");
		nodoPadre.appendChild(nodoUnidades);
		var unidades:String = cursor.valueBuffer("unimod1");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(unidades);
		nodoUnidades.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("importe1")) {
		var nodoImporte:FLDomElement = this.iface.xmlModelo.createElement("Importe");
		nodoPadre.appendChild(nodoImporte);
		var importe:String = cursor.valueBuffer("importe1");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(importe);
		nodoImporte.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("unimod2") || cursor.valueBuffer("importe2")) {
		var nodoModulo:FLDomElement = this.iface.xmlModelo.createElement("NumModulo");
		nodoPadre.appendChild(nodoModulo);
		var numModulo:String = "2";
		if (!flcontmode.iface.pub_verificarDato(numModulo, true, "NumModulo", 1)) {
			return false;
		}
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(numModulo);
		nodoModulo.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("unimod2")) {
		var nodoUnidades:FLDomElement = this.iface.xmlModelo.createElement("Unidades");
		nodoPadre.appendChild(nodoUnidades);
		var unidades:String = cursor.valueBuffer("unimod2");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(unidades);
		nodoUnidades.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("importe2")) {
		var nodoImporte:FLDomElement = this.iface.xmlModelo.createElement("Importe");
		nodoPadre.appendChild(nodoImporte);
		var importe:String = cursor.valueBuffer("importe2");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(importe);
		nodoImporte.appendChild(nodoTexto);
	}
	
	if (cursor.valueBuffer("unimod3") || cursor.valueBuffer("importe3")) {
		var nodoModulo:FLDomElement = this.iface.xmlModelo.createElement("NumModulo");
		nodoPadre.appendChild(nodoModulo);
		var numModulo:String = "3";
		if (!flcontmode.iface.pub_verificarDato(numModulo, true, "NumModulo", 1)) {
			return false;
		}
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(numModulo);
		nodoModulo.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("unimod3")) {
		var nodoUnidades:FLDomElement = this.iface.xmlModelo.createElement("Unidades");
		nodoPadre.appendChild(nodoUnidades);
		var unidades:String = cursor.valueBuffer("unimod3");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(unidades);
		nodoUnidades.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("importe3")) {
		var nodoImporte:FLDomElement = this.iface.xmlModelo.createElement("Importe");
		nodoPadre.appendChild(nodoImporte);
		var importe:String = cursor.valueBuffer("importe3");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(importe);
		nodoImporte.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("unimod4") || cursor.valueBuffer("importe4")) {
		var nodoModulo:FLDomElement = this.iface.xmlModelo.createElement("NumModulo");
		nodoPadre.appendChild(nodoModulo);
		var numModulo:String = "4";
		if (!flcontmode.iface.pub_verificarDato(numModulo, true, "NumModulo", 1)) {
			return false;
		}
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(numModulo);
		nodoModulo.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("unimod4")) {
		var nodoUnidades:FLDomElement = this.iface.xmlModelo.createElement("Unidades");
		nodoPadre.appendChild(nodoUnidades);
		var unidades:String = cursor.valueBuffer("unimod4");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(unidades);
		nodoUnidades.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("importe4")) {
		var nodoImporte:FLDomElement = this.iface.xmlModelo.createElement("Importe");
		nodoPadre.appendChild(nodoImporte);
		var importe:String = cursor.valueBuffer("importe4");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(importe);
		nodoImporte.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("unimod5") || cursor.valueBuffer("importe5")) {
		var nodoModulo:FLDomElement = this.iface.xmlModelo.createElement("NumModulo");
		nodoPadre.appendChild(nodoModulo);
		var numModulo:String = "5";
		if (!flcontmode.iface.pub_verificarDato(numModulo, true, "NumModulo", 1)) {
			return false;
		}
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(numModulo);
		nodoModulo.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("unimod5")) {
		var nodoUnidades:FLDomElement = this.iface.xmlModelo.createElement("Unidades");
		nodoPadre.appendChild(nodoUnidades);
		var unidades:String = cursor.valueBuffer("unimod5");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(unidades);
		nodoUnidades.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("importe5")) {
		var nodoImporte:FLDomElement = this.iface.xmlModelo.createElement("Importe");
		nodoPadre.appendChild(nodoImporte);
		var importe:String = cursor.valueBuffer("importe5");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(importe);
		nodoImporte.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("unimod6") || cursor.valueBuffer("importe6")) {
		var nodoModulo:FLDomElement = this.iface.xmlModelo.createElement("NumModulo");
		nodoPadre.appendChild(nodoModulo);
		var numModulo:String = "6";
		if (!flcontmode.iface.pub_verificarDato(numModulo, true, "NumModulo", 1)) {
			return false;
		}
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(numModulo);
		nodoModulo.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("unimod6")) {
		var nodoUnidades:FLDomElement = this.iface.xmlModelo.createElement("Unidades");
		nodoPadre.appendChild(nodoUnidades);
		var unidades:String = cursor.valueBuffer("unimod6");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(unidades);
		nodoUnidades.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("importe6")) {
		var nodoImporte:FLDomElement = this.iface.xmlModelo.createElement("Importe");
		nodoPadre.appendChild(nodoImporte);
		var importe:String = cursor.valueBuffer("importe6");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(importe);
		nodoImporte.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("unimod7") || cursor.valueBuffer("importe7")) {
		var nodoModulo:FLDomElement = this.iface.xmlModelo.createElement("NumModulo");
		nodoPadre.appendChild(nodoModulo);
		var numModulo:String = "7";
		if (!flcontmode.iface.pub_verificarDato(numModulo, true, "NumModulo", 1)) {
			return false;
		}
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(numModulo);
		nodoModulo.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("unimod7")) {
		var nodoUnidades:FLDomElement = this.iface.xmlModelo.createElement("Unidades");
		nodoPadre.appendChild(nodoUnidades);
		var unidades:String = cursor.valueBuffer("unimod7");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(unidades);
		nodoUnidades.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("importe7")) {
		var nodoImporte:FLDomElement = this.iface.xmlModelo.createElement("Importe");
		nodoPadre.appendChild(nodoImporte);
		var importe:String = cursor.valueBuffer("importe7");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(importe);
		nodoImporte.appendChild(nodoTexto);
	}
	return true;
}

function oficial_informarNodoActAgricGanadForest(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	if (cursor.valueBuffer("volingresos1")) {
		var nodoCodigo:FLDomElement = this.iface.xmlModelo.createElement("Codigo");
		nodoPadre.appendChild(nodoCodigo);
		var codigo1:String = "1";
		if (!flcontmode.iface.pub_verificarDato(codigo1, true, "Codigo", 2)) {
			return false;
		}
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(codigo1);
		nodoCodigo.appendChild(nodoTexto);
		if (cursor.valueBuffer("volingresos1")) {
			var nodoVolIng1:FLDomElement = this.iface.xmlModelo.createElement("VolIngresos");
			nodoPadre.appendChild(nodoVolIng1);
			var volIngresos1:String = cursor.valueBuffer("volingresos1");
			var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(volIngresos1);
			nodoVolIng1.appendChild(nodoTexto);
		}
		if (cursor.valueBuffer("indicecuota1")) {
			var nodoIndCuota1:FLDomElement = this.iface.xmlModelo.createElement("IndCuota");
			nodoPadre.appendChild(nodoIndCuota1);
			var indCuota:String = cursor.valueBuffer("indicecuota1");
			var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(indCuota);
			nodoIndCuota1.appendChild(nodoTexto);
		}
		if (cursor.valueBuffer("cdevengada1")) {
			var nodoCuotaDev1:FLDomElement = this.iface.xmlModelo.createElement("CuotaDevengada");
			nodoPadre.appendChild(nodoCuotaDev1);
			var cuotaDev:String = cursor.valueBuffer("cdevengada1");
			var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuotaDev);
			nodoCuotaDev1.appendChild(nodoTexto);
		}
		if (cursor.valueBuffer("csoportada1")) {
			var nodoCuotaSop1:FLDomElement = this.iface.xmlModelo.createElement("CuotasSoportadas");
			nodoPadre.appendChild(nodoCuotaSop1);
			var cuotaSop:String = cursor.valueBuffer("csoportada1");
			var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuotaSop);
			nodoCuotaSop1.appendChild(nodoTexto);
		}
		if (cursor.valueBuffer("cderivadars1")) {
			var nodoCuotaRegSimp1:FLDomElement = this.iface.xmlModelo.createElement("CuotaRegSimplificado");
			nodoPadre.appendChild(nodoCuotaRegSimp1);
			var cuotaRegSimp:String = cursor.valueBuffer("cderivadars1");
			var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuotaRegSimp);
			nodoCuotaRegSimp1.appendChild(nodoTexto);
		}
	}

	if (cursor.valueBuffer("volingresos2")) {
		var nodoCodigo:FLDomElement = this.iface.xmlModelo.createElement("Codigo");
		nodoPadre.appendChild(nodoCodigo);
		var codigo2:String = "2";
		if (!flcontmode.iface.pub_verificarDato(codigo2, true, "Codigo", 2)) {
			return false;
		}
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(codigo2);
		nodoCodigo.appendChild(nodoTexto);
		if (cursor.valueBuffer("volingresos2")) {
			var nodoVolIng1:FLDomElement = this.iface.xmlModelo.createElement("VolIngresos");
			nodoPadre.appendChild(nodoVolIng1);
			var volIngresos1:String = cursor.valueBuffer("volingresos2");
			var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(volIngresos1);
			nodoVolIng1.appendChild(nodoTexto);
		}
		if (cursor.valueBuffer("indicecuota2")) {
			var nodoIndCuota1:FLDomElement = this.iface.xmlModelo.createElement("IndCuota");
			nodoPadre.appendChild(nodoIndCuota1);
			var indCuota:String = cursor.valueBuffer("indicecuota2");
			var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(indCuota);
			nodoIndCuota1.appendChild(nodoTexto);
		}
		if (cursor.valueBuffer("cdevengada2")) {
			var nodoCuotaDev1:FLDomElement = this.iface.xmlModelo.createElement("CuotaDevengada");
			nodoPadre.appendChild(nodoCuotaDev1);
			var cuotaDev:String = cursor.valueBuffer("cdevengada2");
			var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuotaDev);
			nodoCuotaDev1.appendChild(nodoTexto);
		}
		if (cursor.valueBuffer("csoportada2")) {
			var nodoCuotaSop1:FLDomElement = this.iface.xmlModelo.createElement("CuotasSoportadas");
			nodoPadre.appendChild(nodoCuotaSop1);
			var cuotaSop:String = cursor.valueBuffer("csoportada2");
			var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuotaSop);
			nodoCuotaSop1.appendChild(nodoTexto);
		}
		if (cursor.valueBuffer("cderivadars2")) {
			var nodoCuotaRegSimp1:FLDomElement = this.iface.xmlModelo.createElement("CuotaRegSimplificado");
			nodoPadre.appendChild(nodoCuotaRegSimp1);
			var cuotaRegSimp:String = cursor.valueBuffer("cderivadars2");
			var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuotaRegSimp);
			nodoCuotaRegSimp1.appendChild(nodoTexto);
		}
	}

	if (cursor.valueBuffer("volingresos3")) {
		var nodoCodigo:FLDomElement = this.iface.xmlModelo.createElement("Codigo");
		nodoPadre.appendChild(nodoCodigo);
		var codigo3:String = "3";
		if (!flcontmode.iface.pub_verificarDato(codigo3, true, "Codigo", 2)) {
			return false;
		}
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(codigo3);
		nodoCodigo.appendChild(nodoTexto);
		if (cursor.valueBuffer("volingresos3")) {
			var nodoVolIng1:FLDomElement = this.iface.xmlModelo.createElement("VolIngresos");
			nodoPadre.appendChild(nodoVolIng1);
			var volIngresos1:String = cursor.valueBuffer("volingresos3");
			var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(volIngresos1);
			nodoVolIng1.appendChild(nodoTexto);
		}
		if (cursor.valueBuffer("indicecuota3")) {
			var nodoIndCuota1:FLDomElement = this.iface.xmlModelo.createElement("IndCuota");
			nodoPadre.appendChild(nodoIndCuota1);
			var indCuota:String = cursor.valueBuffer("indicecuota3");
			var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(indCuota);
			nodoIndCuota1.appendChild(nodoTexto);
		}
		if (cursor.valueBuffer("cdevengada3")) {
			var nodoCuotaDev1:FLDomElement = this.iface.xmlModelo.createElement("CuotaDevengada");
			nodoPadre.appendChild(nodoCuotaDev1);
			var cuotaDev:String = cursor.valueBuffer("cdevengada3");
			var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuotaDev);
			nodoCuotaDev1.appendChild(nodoTexto);
		}
		if (cursor.valueBuffer("csoportada3")) {
			var nodoCuotaSop1:FLDomElement = this.iface.xmlModelo.createElement("CuotasSoportadas");
			nodoPadre.appendChild(nodoCuotaSop1);
			var cuotaSop:String = cursor.valueBuffer("csoportada3");
			var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuotaSop);
			nodoCuotaSop1.appendChild(nodoTexto);
		}
		if (cursor.valueBuffer("cderivadars3")) {
			var nodoCuotaRegSimp1:FLDomElement = this.iface.xmlModelo.createElement("CuotaRegSimplificado");
			nodoPadre.appendChild(nodoCuotaRegSimp1);
			var cuotaRegSimp:String = cursor.valueBuffer("cderivadars3");
			var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuotaRegSimp);
			nodoCuotaRegSimp1.appendChild(nodoTexto);
		}
	}

	if (cursor.valueBuffer("volingresos4")) {
		var nodoCodigo:FLDomElement = this.iface.xmlModelo.createElement("Codigo");
		nodoPadre.appendChild(nodoCodigo);
		var codigo4:String = "4";
		if (!flcontmode.iface.pub_verificarDato(codigo4, true, "Codigo", 2)) {
			return false;
		}
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(codigo4);
		nodoCodigo.appendChild(nodoTexto);
		if (cursor.valueBuffer("volingresos4")) {
			var nodoVolIng1:FLDomElement = this.iface.xmlModelo.createElement("VolIngresos");
			nodoPadre.appendChild(nodoVolIng1);
			var volIngresos1:String = cursor.valueBuffer("volingresos4");
			var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(volIngresos1);
			nodoVolIng1.appendChild(nodoTexto);
		}
		if (cursor.valueBuffer("indicecuota4")) {
			var nodoIndCuota1:FLDomElement = this.iface.xmlModelo.createElement("IndCuota");
			nodoPadre.appendChild(nodoIndCuota1);
			var indCuota:String = cursor.valueBuffer("indicecuota4");
			var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(indCuota);
			nodoIndCuota1.appendChild(nodoTexto);
		}
		if (cursor.valueBuffer("cdevengada4")) {
			var nodoCuotaDev1:FLDomElement = this.iface.xmlModelo.createElement("CuotaDevengada");
			nodoPadre.appendChild(nodoCuotaDev1);
			var cuotaDev:String = cursor.valueBuffer("cdevengada4");
			var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuotaDev);
			nodoCuotaDev1.appendChild(nodoTexto);
		}
		if (cursor.valueBuffer("csoportada4")) {
			var nodoCuotaSop1:FLDomElement = this.iface.xmlModelo.createElement("CuotasSoportadas");
			nodoPadre.appendChild(nodoCuotaSop1);
			var cuotaSop:String = cursor.valueBuffer("csoportada4");
			var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuotaSop);
			nodoCuotaSop1.appendChild(nodoTexto);
		}
		if (cursor.valueBuffer("cderivadars4")) {
			var nodoCuotaRegSimp1:FLDomElement = this.iface.xmlModelo.createElement("CuotaRegSimplificado");
			nodoPadre.appendChild(nodoCuotaRegSimp1);
			var cuotaRegSimp:String = cursor.valueBuffer("cderivadars4");
			var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuotaRegSimp);
			nodoCuotaRegSimp1.appendChild(nodoTexto);
		}
	}

	if (cursor.valueBuffer("volingresos5")) {
		var nodoCodigo:FLDomElement = this.iface.xmlModelo.createElement("Codigo");
		nodoPadre.appendChild(nodoCodigo);
		var codigo5:String = "5";
		if (!flcontmode.iface.pub_verificarDato(codigo5, true, "Codigo", 2)) {
			return false;
		}
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(codigo5);
		nodoCodigo.appendChild(nodoTexto);
		if (cursor.valueBuffer("volingresos5")) {
			var nodoVolIng1:FLDomElement = this.iface.xmlModelo.createElement("VolIngresos");
			nodoPadre.appendChild(nodoVolIng1);
			var volIngresos1:String = cursor.valueBuffer("volingresos5");
			var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(volIngresos1);
			nodoVolIng1.appendChild(nodoTexto);
		}
		if (cursor.valueBuffer("indicecuota5")) {
			var nodoIndCuota1:FLDomElement = this.iface.xmlModelo.createElement("IndCuota");
			nodoPadre.appendChild(nodoIndCuota1);
			var indCuota:String = cursor.valueBuffer("indicecuota5");
			var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(indCuota);
			nodoIndCuota1.appendChild(nodoTexto);
		}
		if (cursor.valueBuffer("cdevengada5")) {
			var nodoCuotaDev1:FLDomElement = this.iface.xmlModelo.createElement("CuotaDevengada");
			nodoPadre.appendChild(nodoCuotaDev1);
			var cuotaDev:String = cursor.valueBuffer("cdevengada5");
			var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuotaDev);
			nodoCuotaDev1.appendChild(nodoTexto);
		}
		if (cursor.valueBuffer("csoportada5")) {
			var nodoCuotaSop1:FLDomElement = this.iface.xmlModelo.createElement("CuotasSoportadas");
			nodoPadre.appendChild(nodoCuotaSop1);
			var cuotaSop:String = cursor.valueBuffer("csoportada5");
			var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuotaSop);
			nodoCuotaSop1.appendChild(nodoTexto);
		}
		if (cursor.valueBuffer("cderivadars5")) {
			var nodoCuotaRegSimp1:FLDomElement = this.iface.xmlModelo.createElement("CuotaRegSimplificado");
			nodoPadre.appendChild(nodoCuotaRegSimp1);
			var cuotaRegSimp:String = cursor.valueBuffer("cderivadars5");
			var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuotaRegSimp);
			nodoCuotaRegSimp1.appendChild(nodoTexto);
		}
	}
	return true;
}

function oficial_informarNodoIvaDevengado(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	if (cursor.valueBuffer("sumacdan")) {
		var nodoCuotaNA:FLDomElement = this.iface.xmlModelo.createElement("SumaCuotasNoAgric");
		nodoPadre.appendChild(nodoCuotaNA);
		var sumaCuotaNa:String = cursor.valueBuffer("sumacdan");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(sumaCuotaNa);
		nodoCuotaNA.appendChild(nodoTexto);
	}
	if (cursor.valueBuffer("sumacda")) {
		var nodoCuotaA:FLDomElement = this.iface.xmlModelo.createElement("SumaCuotasAgric");
		nodoPadre.appendChild(nodoCuotaA);
		var sumaCuotaA:String = cursor.valueBuffer("sumacda");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(sumaCuotaA);
		nodoCuotaA.appendChild(nodoTexto);
	}
	if (cursor.valueBuffer("ivadevai")) {
		var nodoAdqIntra:FLDomElement = this.iface.xmlModelo.createElement("AdqIntracomunitarias");
		nodoPadre.appendChild(nodoAdqIntra);
		var adqIntr:String = cursor.valueBuffer("ivadevai");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(adqIntr);
		nodoAdqIntra.appendChild(nodoTexto);
	}
	if (cursor.valueBuffer("ivadevis")) {
		var nodoInvSP:FLDomElement = this.iface.xmlModelo.createElement("InversionSujetoPasivo");
		nodoPadre.appendChild(nodoInvSP);
		var adqIntr:String = cursor.valueBuffer("ivadevis");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(adqIntr);
		nodoInvSP.appendChild(nodoTexto);
	}
	if (cursor.valueBuffer("ivadevea")) {
		var nodoEntActF:FLDomElement = this.iface.xmlModelo.createElement("EntregasActivosFijos");
		nodoPadre.appendChild(nodoEntActF);
		var entrActF:String = cursor.valueBuffer("ivadevea");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(entrActF);
		nodoEntActF.appendChild(nodoTexto);
	}
	if (cursor.valueBuffer("totalcres")) {
		var nodoTotalCuota:FLDomElement = this.iface.xmlModelo.createElement("TotalCuota");
		nodoPadre.appendChild(nodoTotalCuota);
		var totalCuota:String = cursor.valueBuffer("totalcres");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(totalCuota);
		nodoTotalCuota.appendChild(nodoTexto);
	}
	return true;
}

function oficial_informarNodoIvaDeducible(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	if (cursor.valueBuffer("ivasopaf")) {
		var nodoIvaSop:FLDomElement = this.iface.xmlModelo.createElement("IVASoportadoAdqActivosFijos");
		nodoPadre.appendChild(nodoIvaSop);
		var ivaSop:String = cursor.valueBuffer("ivasopaf");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(ivaSop);
		nodoIvaSop.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("regbienesi")) {
		var nodoBienesInv:FLDomElement = this.iface.xmlModelo.createElement("RegBienesInversion");
		nodoPadre.appendChild(nodoBienesInv);
		var bienes:String = cursor.valueBuffer("regbienesi");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(bienes);
		nodoBienesInv.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("sumadeducciones")) {
		var nodoSumaDed:FLDomElement = this.iface.xmlModelo.createElement("SumaDeducciones");
		nodoPadre.appendChild(nodoSumaDed);
		var sumaDed:String = cursor.valueBuffer("sumadeducciones");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(sumaDed);
		nodoSumaDed.appendChild(nodoTexto);
	}
	return true;
}

function oficial_informarNodoLiqAnual(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	if (cursor.valueBuffer("sumares")) {
		var nodoSumaRes:FLDomElement = this.iface.xmlModelo.createElement("SumResultados");
		nodoPadre.appendChild(nodoSumaRes);
		var sumaRes:String = cursor.valueBuffer("sumares");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(sumaRes);
		nodoSumaRes.appendChild(nodoTexto);
	}
	if (cursor.valueBuffer("comcuotasea")) {
		var nodoCuotasEjAnt:FLDomElement = this.iface.xmlModelo.createElement("CompCuotasEjercicioAnterior");
		nodoPadre.appendChild(nodoCuotasEjAnt);
		var comCuotasEjAnt:String = cursor.valueBuffer("comcuotasea");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(comCuotasEjAnt);
		nodoCuotasEjAnt.appendChild(nodoTexto);
	}
	if (cursor.valueBuffer("resliquidacion")) {
		var nodoResLiq:FLDomElement = this.iface.xmlModelo.createElement("ResLiquidacion");
		nodoPadre.appendChild(nodoResLiq);
		var resLiq:String = cursor.valueBuffer("resliquidacion");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(resLiq);
		nodoResLiq.appendChild(nodoTexto);
	}
	return true;
}

function oficial_informarNodoAdministraciones(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	if (cursor.valueBuffer("portc")) {
		var nodoComun:FLDomElement = this.iface.xmlModelo.createElement("Comun");
		nodoPadre.appendChild(nodoComun);
		var comun:String = cursor.valueBuffer("portc");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(comun);
		nodoComun.appendChild(nodoTexto);
	}
	if (cursor.valueBuffer("pora")) {
		var nodoAlava:FLDomElement = this.iface.xmlModelo.createElement("Alava");
		nodoPadre.appendChild(nodoAlava);
		var alava:String = cursor.valueBuffer("pora");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(alava);
		nodoAlava.appendChild(nodoTexto);
	}
	if (cursor.valueBuffer("porg")) {
		var nodoGuipuzcoa:FLDomElement = this.iface.xmlModelo.createElement("Guipuzcoa");
		nodoPadre.appendChild(nodoGuipuzcoa);
		var guipuzcoa:String = cursor.valueBuffer("porg");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(guipuzcoa);
		nodoGuipuzcoa.appendChild(nodoTexto);
	}
	if (cursor.valueBuffer("porv")) {
		var nodoVizcaya:FLDomElement = this.iface.xmlModelo.createElement("Vizcaya");
		nodoPadre.appendChild(nodoVizcaya);
		var vizcaya:String = cursor.valueBuffer("porv");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(vizcaya);
		nodoVizcaya.appendChild(nodoTexto);
	}
	if (cursor.valueBuffer("porn")) {
		var nodoNavarra:FLDomElement = this.iface.xmlModelo.createElement("Navarra");
		nodoPadre.appendChild(nodoNavarra);
		var navarra:String = cursor.valueBuffer("porn");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(navarra);
		nodoNavarra.appendChild(nodoTexto);
	}
	if (cursor.valueBuffer("sumares")) {
		var nodoSumResultados:FLDomElement = this.iface.xmlModelo.createElement("SumResultados");
		nodoPadre.appendChild(nodoSumResultados);
		var resultados:String = cursor.valueBuffer("sumares");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(resultados);
		nodoSumResultados.appendChild(nodoTexto);
	}
	if (cursor.valueBuffer("resultadotc")) {
		var nodoResTerrComun:FLDomElement = this.iface.xmlModelo.createElement("ResTerrComun");
		nodoPadre.appendChild(nodoResTerrComun);
		var resultadoTC:String = cursor.valueBuffer("resultadotc");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(resultadoTC);
		nodoResTerrComun.appendChild(nodoTexto);
	}
	if (cursor.valueBuffer("compcuotaseatc")) {
		var nodoCuoTerrComun:FLDomElement = this.iface.xmlModelo.createElement("ComCuotasEjercicioAnteriorTerrComun");
		nodoPadre.appendChild(nodoCuoTerrComun);
		var cuotaTC:String = cursor.valueBuffer("compcuotaseatc");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cuotaTC);
		nodoCuoTerrComun.appendChild(nodoTexto);
	}
	if (cursor.valueBuffer("resliqtc")) {
		var nodoResLiqAnual:FLDomElement = this.iface.xmlModelo.createElement("ResLiqAnualTerrComun");
		nodoPadre.appendChild(nodoResLiqAnual);
		var resLiqAnual:String = cursor.valueBuffer("resliqtc");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(resLiqAnual);
		nodoResLiqAnual.appendChild(nodoTexto);
	}

	return true;
}

function oficial_informarNodoResLiquidaciones(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	if (cursor.valueBuffer("totalingresos")) {
		var nodoTotalIng:FLDomElement = this.iface.xmlModelo.createElement("TotIngresosIVA");
		nodoPadre.appendChild(nodoTotalIng);
		var totalIng:String = cursor.valueBuffer("totalingresos");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(totalIng);
		nodoTotalIng.appendChild(nodoTexto);
	}
	if (cursor.valueBuffer("totaldevoluciones")) {
		var nodoTotDevIva:FLDomElement = this.iface.xmlModelo.createElement("TotDevIVA_SP_RegExpyOPEconom");
		nodoPadre.appendChild(nodoTotDevIva);
		var totalDev:String = cursor.valueBuffer("totaldevoluciones");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(totalDev);
		nodoTotDevIva.appendChild(nodoTexto);
	}
	if (cursor.valueBuffer("totalacompensar")) {
		var nodoAcompensar:FLDomElement = this.iface.xmlModelo.createElement("ImporteACompensarUltimoPeriodo");
		nodoPadre.appendChild(nodoAcompensar);
		var aCompensar:String = cursor.valueBuffer("totalacompensar");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(aCompensar);
		nodoAcompensar.appendChild(nodoTexto);
	}
	if (cursor.valueBuffer("totaladevolver")) {
		var nodoDevolverUP:FLDomElement = this.iface.xmlModelo.createElement("ImporteADevolverUltimoPeriodo");
		nodoPadre.appendChild(nodoDevolverUP);
		var aDevolver:String = cursor.valueBuffer("totaladevolver");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(aDevolver);
		nodoDevolverUP.appendChild(nodoTexto);
	}

	return true;
}

function oficial_informarNodoVolOperaciones(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	if (cursor.valueBuffer("operacionesre")) {
		var nodoOpRegGeneral:FLDomElement = this.iface.xmlModelo.createElement("OpRegGeneral");
		nodoPadre.appendChild(nodoOpRegGeneral);
		var opRegGeneral:String = cursor.valueBuffer("operacionesre");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(opRegGeneral);
		nodoOpRegGeneral.appendChild(nodoTexto);
	}
	if (cursor.valueBuffer("entregasintraex")) {
		var nodoEntregIntrEx:FLDomElement = this.iface.xmlModelo.createElement("EntregasIntracomunitariasExentas");
		nodoPadre.appendChild(nodoEntregIntrEx);
		var entregasIntrEx:String = cursor.valueBuffer("entregasintraex");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(entregasIntrEx);
		nodoEntregIntrEx.appendChild(nodoTexto);
	}
	if (cursor.valueBuffer("entregasintraexcondd")) {
		var nodoExpExDD:FLDomElement = this.iface.xmlModelo.createElement("ExportacionesExentasConDrchoDeduccion");
		nodoPadre.appendChild(nodoExpExDD);
		var exprexdd:String = cursor.valueBuffer("entregasintraexcondd");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(exprexdd);
		nodoExpExDD.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("entregasintraexsinndd")) {
		var nodoExpExSinDD:FLDomElement = this.iface.xmlModelo.createElement("OpExentasSinDrchoDeduccion");
		nodoPadre.appendChild(nodoExpExSinDD);
		var exprexsindd:String = cursor.valueBuffer("entregasintraexsinndd");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(exprexsindd);
		nodoExpExSinDD.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("opnsdm")) {
		var nodoOpNoSujetas:FLDomElement = this.iface.xmlModelo.createElement("OpNoSujetas");
		nodoPadre.appendChild(nodoOpNoSujetas);
		var nosujetas:String = cursor.valueBuffer("opnsdm");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(nosujetas);
		nodoOpNoSujetas.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("entregasbo")) {
		var nodoEntBienes:FLDomElement = this.iface.xmlModelo.createElement("EntregasBienesInstalacionOtrosEM");
		nodoPadre.appendChild(nodoEntBienes);
		var entrbienes:String = cursor.valueBuffer("entregasbo");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(entrbienes);
		nodoEntBienes.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("operacionesrs")) {
		var nodoRegSimplificado:FLDomElement = this.iface.xmlModelo.createElement("OpRegSimplificado");
		nodoPadre.appendChild(nodoRegSimplificado);
		var opregsimpl:String = cursor.valueBuffer("operacionesrs");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(opregsimpl);
		nodoRegSimplificado.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("operacionesreagp")) {
		var nodoAgriGanPes:FLDomElement = this.iface.xmlModelo.createElement("OpRegEspAgricPescGanad");
		nodoPadre.appendChild(nodoAgriGanPes);
		var opAgriGanPes:String = cursor.valueBuffer("operacionesreagp");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(opAgriGanPes);
		nodoAgriGanPes.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("operacionesrere")) {
		var nodoRecEquiv:FLDomElement = this.iface.xmlModelo.createElement("OpRegEspRecEquivalencia");
		nodoPadre.appendChild(nodoRecEquiv);
		var opRecEquiv:String = cursor.valueBuffer("operacionesrere");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(opRecEquiv);
		nodoRecEquiv.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("opregespbius")) {
		var nodoBieUs:FLDomElement = this.iface.xmlModelo.createElement("OpRegEspBienesUsados");
		nodoPadre.appendChild(nodoBieUs);
		var bienesusados:String = cursor.valueBuffer("opregespbius");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(bienesusados);
		nodoBieUs.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("opregesagenvia")) {
		var nodoAgViajes:FLDomElement = this.iface.xmlModelo.createElement("OpRegEspAgViajes");
		nodoPadre.appendChild(nodoAgViajes);
		var agViajes:String = cursor.valueBuffer("opregesagenvia");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(agViajes);
		nodoAgViajes.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("entregasbinmuebles")) {
		var nodoBieInm:FLDomElement = this.iface.xmlModelo.createElement("EntregasBienesInmuebles");
		nodoPadre.appendChild(nodoBieInm);
		var bienesInm:String = cursor.valueBuffer("entregasbinmuebles");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(bienesInm);
		nodoBieInm.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("entregasbinversion")) {
		var nodoBieInv:FLDomElement = this.iface.xmlModelo.createElement("EntregasBienesInversion");
		nodoPadre.appendChild(nodoBieInv);
		var bienesInv:String = cursor.valueBuffer("entregasbinversion");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(bienesInv);
		nodoBieInv.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("totalvoloperaciones")) {
		var nodoTotalVol:FLDomElement = this.iface.xmlModelo.createElement("TotalVolOp");
		nodoPadre.appendChild(nodoTotalVol);
		var totalVol:String = cursor.valueBuffer("totalvoloperaciones");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(totalVol);
		nodoTotalVol.appendChild(nodoTexto);
	}
	return true;
}

function oficial_informarNodoOpEspecificas(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	if (cursor.valueBuffer("adquiinterex")) {
		var nodoAdqIntExentas:FLDomElement = this.iface.xmlModelo.createElement("AdqInterioresExentas");
		nodoPadre.appendChild(nodoAdqIntExentas);
		var adqIntExentas:String = cursor.valueBuffer("adquiinterex");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(adqIntExentas);
		nodoAdqIntExentas.appendChild(nodoTexto);
	}
	if (cursor.valueBuffer("adquiintraex")) {
		var nodoAdqIntrExentas:FLDomElement = this.iface.xmlModelo.createElement("AdqIntracomunitariasExentas");
		nodoPadre.appendChild(nodoAdqIntrExentas);
		var adqIntrExentas:String = cursor.valueBuffer("adquiintraex");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(adqIntrExentas);
		nodoAdqIntrExentas.appendChild(nodoTexto);
	}
	if (cursor.valueBuffer("importacionesex")) {
		var nodoImpExentas:FLDomElement = this.iface.xmlModelo.createElement("ImportacionesExentas");
		nodoPadre.appendChild(nodoImpExentas);
		var impExentas:String = cursor.valueBuffer("importacionesex");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(impExentas);
		nodoImpExentas.appendChild(nodoTexto);
	}
/*	if (cursor.valueBuffer("")) {
		var nodoBaseIvaSop:FLDomElement = this.iface.xmlModelo.createElement("BasesIVASoportadoNoDeducible");
		nodoPadre.appendChild(nodoBaseIvaSop);
		var baseIvaSop:String = cursor.valueBuffer("");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(baseIvaSop);
		nodoBaseIvaSop.appendChild(nodoTexto);
	}*/

	if (cursor.valueBuffer("opsyedm")) {
		var nodoOpSujetas:FLDomElement = this.iface.xmlModelo.createElement("OpSujetas");
		nodoPadre.appendChild(nodoOpSujetas);
		var opSujetas:String = cursor.valueBuffer("opsyedm");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(opSujetas);
		nodoOpSujetas.appendChild(nodoTexto);
	}
	if (cursor.valueBuffer("entregasbs")) {
		var nodoEntrInt:FLDomElement = this.iface.xmlModelo.createElement("EntregasInteriores");
		nodoPadre.appendChild(nodoEntrInt);
		var opSujetas:String = cursor.valueBuffer("entregasbs");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(opSujetas);
		nodoEntrInt.appendChild(nodoTexto);
	}
	if (cursor.valueBuffer("serlocalizados")) {
		var nodoServInv:FLDomElement = this.iface.xmlModelo.createElement("ServInversionSP");
		nodoPadre.appendChild(nodoServInv);
		var servInv:String = cursor.valueBuffer("serlocalizados");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(servInv);
		nodoServInv.appendChild(nodoTexto);
	}
	return true;
}

function oficial_informarNodoFechaDecla(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	if (cursor.valueBuffer("municipiopf4")) {
		var nodoLocalidad:FLDomElement = this.iface.xmlModelo.createElement("Localidad");
		nodoPadre.appendChild(nodoLocalidad);
		var localidad:String = cursor.valueBuffer("municipiopf4");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(localidad);
		nodoLocalidad.appendChild(nodoTexto);
	}
	if (cursor.valueBuffer("fechapf4")) {
		var nodoFecha:FLDomElement = this.iface.xmlModelo.createElement("Fecha");
		nodoPadre.appendChild(nodoFecha);
		if (!this.iface.informarNodoFecha(nodoFecha, version)) {
			return false;
		}
	}
	return true;
}

function oficial_informarNodoFechaDecla(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();
	var fechaDecla:String = cursor.valueBuffer("fechapf4");
	fechaDecla = fechaDecla.toString();
	fechaDecla = fechaDecla.left(10);
	var dia:String = fechaDecla.right(2);
	fechaDecla = fechaDecla.left(7);
	var mes:String = fechaDecla.right(2);
	var anno:String = fechaDecla.left(4);

	var nodoDia:FLDomElement = this.iface.xmlModelo.createElement("Dia");
	nodoPadre.appendChild(nodoDia);
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(dia);
	nodoDia.appendChild(nodoTexto);

	var nodoMes:FLDomElement = this.iface.xmlModelo.createElement("Mes");
	nodoPadre.appendChild(nodoMes);
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(mes);
	nodoMes.appendChild(nodoTexto);

	var nodoAnno:FLDomElement = this.iface.xmlModelo.createElement("Anno");
	nodoPadre.appendChild(nodoAnno);
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(anno);
	nodoAnno.appendChild(nodoTexto);

	return true;
}

function oficial_informarNodoProrratas(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();

	if (cursor.valueBuffer("cane")) {
		var nodoPro:FLDomElement = this.iface.xmlModelo.createElement("Pro");
		nodoPadre.appendChild(nodoPro);
		if (!this.iface.informarNodoPro1(nodoPro, version)) {
			return false;
		}
	}
	if (cursor.valueBuffer("cane2")) {
		var nodoPro:FLDomElement = this.iface.xmlModelo.createElement("Pro");
		nodoPadre.appendChild(nodoPro);
		if (!this.iface.informarNodoPro2(nodoPro, version)) {
			return false;
		}
	}
	if (cursor.valueBuffer("cane3")) {
		var nodoPro:FLDomElement = this.iface.xmlModelo.createElement("Pro");
		nodoPadre.appendChild(nodoPro);
		if (!this.iface.informarNodoPro3(nodoPro, version)) {
			return false;
		}
	}
	if (cursor.valueBuffer("cane4")) {
		var nodoPro:FLDomElement = this.iface.xmlModelo.createElement("Pro");
		nodoPadre.appendChild(nodoPro);
		if (!this.iface.informarNodoPro4(nodoPro, version)) {
			return false;
		}
	}
	if (cursor.valueBuffer("cane5")) {
		var nodoPro:FLDomElement = this.iface.xmlModelo.createElement("Pro");
		nodoPadre.appendChild(nodoPro);
		if (!this.iface.informarNodoPro5(nodoPro, version)) {
			return false;
		}
	}
	if (cursor.valueBuffer("cane6")) {
		var nodoPro:FLDomElement = this.iface.xmlModelo.createElement("Pro");
		nodoPadre.appendChild(nodoPro);
		if (!this.iface.informarNodoPro6(nodoPro, version)) {
			return false;
		}
	}
	if (cursor.valueBuffer("cane7")) {
		var nodoPro:FLDomElement = this.iface.xmlModelo.createElement("Pro");
		nodoPadre.appendChild(nodoPro);
		if (!this.iface.informarNodoPro7(nodoPro, version)) {
			return false;
		}
	}
	if (cursor.valueBuffer("cane8")) {
		var nodoPro:FLDomElement = this.iface.xmlModelo.createElement("Pro");
		nodoPadre.appendChild(nodoPro);
		if (!this.iface.informarNodoPro8(nodoPro, version)) {
			return false;
		}
	}
	return true;
}

function oficial_informarNodoPro1(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();

	if (cursor.valueBuffer("actividaddesarollada")) {
		var nodoActividad:FLDomElement = this.iface.xmlModelo.createElement("Actividad");
		nodoPadre.appendChild(nodoActividad);
		var actividad:String = cursor.valueBuffer("actividaddesarollada");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(actividad);
		nodoActividad.appendChild(nodoTexto);
	}

	var nodoCNAE:FLDomElement = this.iface.xmlModelo.createElement("CNAE");
	nodoPadre.appendChild(nodoCNAE);
	var cnae:String = cursor.valueBuffer("cane");
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cnae);
	nodoCNAE.appendChild(nodoTexto);
	
	if (cursor.valueBuffer("importetotalop")) {
		var nodoImpOper:FLDomElement = this.iface.xmlModelo.createElement("ImpOper");
		nodoPadre.appendChild(nodoImpOper);
		var impOper:String = cursor.valueBuffer("importetotalop");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(impOper);
		nodoImpOper.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("importetotalopdd")) {
		var nodoImpOperDrDed:FLDomElement = this.iface.xmlModelo.createElement("ImpOperConDrchoDed");
		nodoPadre.appendChild(nodoImpOperDrDed);
		var impOperDrDed:String = cursor.valueBuffer("importetotalopdd");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(impOperDrDed);
		nodoImpOperDrDed.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("tipoprorrata")) {
		var nodoTipo:FLDomElement = this.iface.xmlModelo.createElement("Tipo");
		nodoPadre.appendChild(nodoTipo);
		var tipo:String = cursor.valueBuffer("tipoprorrata");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(tipo);
		nodoTipo.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("porprorrata")) {
		var nodoPorc:FLDomElement = this.iface.xmlModelo.createElement("Porc");
		nodoPadre.appendChild(nodoPorc);
		var porcentaje:String = cursor.valueBuffer("porprorrata");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(porcentaje);
		nodoPorc.appendChild(nodoTexto);
	}
	
	return true;
}

function oficial_informarNodoPro2(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();

	if (cursor.valueBuffer("actividaddesarollada2")) {
		var nodoActividad:FLDomElement = this.iface.xmlModelo.createElement("Actividad");
		nodoPadre.appendChild(nodoActividad);
		var actividad:String = cursor.valueBuffer("actividaddesarollada2");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(actividad);
		nodoActividad.appendChild(nodoTexto);
	}

	var nodoCNAE:FLDomElement = this.iface.xmlModelo.createElement("CNAE");
	nodoPadre.appendChild(nodoCNAE);
	var cnae:String = cursor.valueBuffer("cane2");
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cnae);
	nodoCNAE.appendChild(nodoTexto);
	
	if (cursor.valueBuffer("importetotalop2")) {
		var nodoImpOper:FLDomElement = this.iface.xmlModelo.createElement("ImpOper");
		nodoPadre.appendChild(nodoImpOper);
		var impOper:String = cursor.valueBuffer("importetotalop2");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(impOper);
		nodoImpOper.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("importetotalopdd2")) {
		var nodoImpOperDrDed:FLDomElement = this.iface.xmlModelo.createElement("ImpOperConDrchoDed");
		nodoPadre.appendChild(nodoImpOperDrDed);
		var impOperDrDed:String = cursor.valueBuffer("importetotalopdd2");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(impOperDrDed);
		nodoImpOperDrDed.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("tipoprorrata2")) {
		var nodoTipo:FLDomElement = this.iface.xmlModelo.createElement("Tipo");
		nodoPadre.appendChild(nodoTipo);
		var tipo:String = cursor.valueBuffer("tipoprorrata2");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(tipo);
		nodoTipo.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("porprorrata2")) {
		var nodoPorc:FLDomElement = this.iface.xmlModelo.createElement("Porc");
		nodoPadre.appendChild(nodoPorc);
		var porcentaje:String = cursor.valueBuffer("porprorrata2");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(porcentaje);
		nodoPorc.appendChild(nodoTexto);
	}
	
	return true;
}

function oficial_informarNodoPro3(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();

	if (cursor.valueBuffer("actividaddesarollada3")) {
		var nodoActividad:FLDomElement = this.iface.xmlModelo.createElement("Actividad");
		nodoPadre.appendChild(nodoActividad);
		var actividad:String = cursor.valueBuffer("actividaddesarollada3");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(actividad);
		nodoActividad.appendChild(nodoTexto);
	}

	var nodoCNAE:FLDomElement = this.iface.xmlModelo.createElement("CNAE");
	nodoPadre.appendChild(nodoCNAE);
	var cnae:String = cursor.valueBuffer("cane3");
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cnae);
	nodoCNAE.appendChild(nodoTexto);
	
	if (cursor.valueBuffer("importetotalop3")) {
		var nodoImpOper:FLDomElement = this.iface.xmlModelo.createElement("ImpOper");
		nodoPadre.appendChild(nodoImpOper);
		var impOper:String = cursor.valueBuffer("importetotalop3");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(impOper);
		nodoImpOper.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("importetotalopdd3")) {
		var nodoImpOperDrDed:FLDomElement = this.iface.xmlModelo.createElement("ImpOperConDrchoDed");
		nodoPadre.appendChild(nodoImpOperDrDed);
		var impOperDrDed:String = cursor.valueBuffer("importetotalopdd3");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(impOperDrDed);
		nodoImpOperDrDed.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("tipoprorrata3")) {
		var nodoTipo:FLDomElement = this.iface.xmlModelo.createElement("Tipo");
		nodoPadre.appendChild(nodoTipo);
		var tipo:String = cursor.valueBuffer("tipoprorrata3");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(tipo);
		nodoTipo.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("porprorrata3")) {
		var nodoPorc:FLDomElement = this.iface.xmlModelo.createElement("Porc");
		nodoPadre.appendChild(nodoPorc);
		var porcentaje:String = cursor.valueBuffer("porprorrata3");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(porcentaje);
		nodoPorc.appendChild(nodoTexto);
	}
	return true;
}

function oficial_informarNodoPro4(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();

	if (cursor.valueBuffer("actividaddesarollada4")) {
		var nodoActividad:FLDomElement = this.iface.xmlModelo.createElement("Actividad");
		nodoPadre.appendChild(nodoActividad);
		var actividad:String = cursor.valueBuffer("actividaddesarollada4");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(actividad);
		nodoActividad.appendChild(nodoTexto);
	}

	var nodoCNAE:FLDomElement = this.iface.xmlModelo.createElement("CNAE");
	nodoPadre.appendChild(nodoCNAE);
	var cnae:String = cursor.valueBuffer("cane4");
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cnae);
	nodoCNAE.appendChild(nodoTexto);
	
	if (cursor.valueBuffer("importetotalop4")) {
		var nodoImpOper:FLDomElement = this.iface.xmlModelo.createElement("ImpOper");
		nodoPadre.appendChild(nodoImpOper);
		var impOper:String = cursor.valueBuffer("importetotalop4");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(impOper);
		nodoImpOper.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("importetotalopdd4")) {
		var nodoImpOperDrDed:FLDomElement = this.iface.xmlModelo.createElement("ImpOperConDrchoDed");
		nodoPadre.appendChild(nodoImpOperDrDed);
		var impOperDrDed:String = cursor.valueBuffer("importetotalopdd4");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(impOperDrDed);
		nodoImpOperDrDed.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("tipoprorrata4")) {
		var nodoTipo:FLDomElement = this.iface.xmlModelo.createElement("Tipo");
		nodoPadre.appendChild(nodoTipo);
		var tipo:String = cursor.valueBuffer("tipoprorrata4");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(tipo);
		nodoTipo.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("porprorrata4")) {
		var nodoPorc:FLDomElement = this.iface.xmlModelo.createElement("Porc");
		nodoPadre.appendChild(nodoPorc);
		var porcentaje:String = cursor.valueBuffer("porprorrata4");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(porcentaje);
		nodoPorc.appendChild(nodoTexto);
	}
	return true;
}

function oficial_informarNodoPro5(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();

	if (cursor.valueBuffer("actividaddesarollada5")) {
		var nodoActividad:FLDomElement = this.iface.xmlModelo.createElement("Actividad");
		nodoPadre.appendChild(nodoActividad);
		var actividad:String = cursor.valueBuffer("actividaddesarollada5");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(actividad);
		nodoActividad.appendChild(nodoTexto);
	}

	var nodoCNAE:FLDomElement = this.iface.xmlModelo.createElement("CNAE");
	nodoPadre.appendChild(nodoCNAE);
	var cnae:String = cursor.valueBuffer("cane5");
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cnae);
	nodoCNAE.appendChild(nodoTexto);
	
	if (cursor.valueBuffer("importetotalop5")) {
		var nodoImpOper:FLDomElement = this.iface.xmlModelo.createElement("ImpOper");
		nodoPadre.appendChild(nodoImpOper);
		var impOper:String = cursor.valueBuffer("importetotalop5");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(impOper);
		nodoImpOper.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("importetotalopdd5")) {
		var nodoImpOperDrDed:FLDomElement = this.iface.xmlModelo.createElement("ImpOperConDrchoDed");
		nodoPadre.appendChild(nodoImpOperDrDed);
		var impOperDrDed:String = cursor.valueBuffer("importetotalopdd5");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(impOperDrDed);
		nodoImpOperDrDed.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("tipoprorrata5")) {
		var nodoTipo:FLDomElement = this.iface.xmlModelo.createElement("Tipo");
		nodoPadre.appendChild(nodoTipo);
		var tipo:String = cursor.valueBuffer("tipoprorrata5");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(tipo);
		nodoTipo.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("porprorrata5")) {
		var nodoPorc:FLDomElement = this.iface.xmlModelo.createElement("Porc");
		nodoPadre.appendChild(nodoPorc);
		var porcentaje:String = cursor.valueBuffer("porprorrata5");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(porcentaje);
		nodoPorc.appendChild(nodoTexto);
	}
	return true;
}

function oficial_informarNodoPro6(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();

	if (cursor.valueBuffer("actividaddesarollada6")) {
		var nodoActividad:FLDomElement = this.iface.xmlModelo.createElement("Actividad");
		nodoPadre.appendChild(nodoActividad);
		var actividad:String = cursor.valueBuffer("actividaddesarollada6");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(actividad);
		nodoActividad.appendChild(nodoTexto);
	}

	var nodoCNAE:FLDomElement = this.iface.xmlModelo.createElement("CNAE");
	nodoPadre.appendChild(nodoCNAE);
	var cnae:String = cursor.valueBuffer("cane6");
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cnae);
	nodoCNAE.appendChild(nodoTexto);
	
	if (cursor.valueBuffer("importetotalop6")) {
		var nodoImpOper:FLDomElement = this.iface.xmlModelo.createElement("ImpOper");
		nodoPadre.appendChild(nodoImpOper);
		var impOper:String = cursor.valueBuffer("importetotalop6");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(impOper);
		nodoImpOper.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("importetotalopdd6")) {
		var nodoImpOperDrDed:FLDomElement = this.iface.xmlModelo.createElement("ImpOperConDrchoDed");
		nodoPadre.appendChild(nodoImpOperDrDed);
		var impOperDrDed:String = cursor.valueBuffer("importetotalopdd6");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(impOperDrDed);
		nodoImpOperDrDed.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("tipoprorrata6")) {
		var nodoTipo:FLDomElement = this.iface.xmlModelo.createElement("Tipo");
		nodoPadre.appendChild(nodoTipo);
		var tipo:String = cursor.valueBuffer("tipoprorrata6");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(tipo);
		nodoTipo.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("porprorrata6")) {
		var nodoPorc:FLDomElement = this.iface.xmlModelo.createElement("Porc");
		nodoPadre.appendChild(nodoPorc);
		var porcentaje:String = cursor.valueBuffer("porprorrata6");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(porcentaje);
		nodoPorc.appendChild(nodoTexto);
	}
	return true;
}

function oficial_informarNodoPro7(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();

	if (cursor.valueBuffer("actividaddesarollada7")) {
		var nodoActividad:FLDomElement = this.iface.xmlModelo.createElement("Actividad");
		nodoPadre.appendChild(nodoActividad);
		var actividad:String = cursor.valueBuffer("actividaddesarollada7");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(actividad);
		nodoActividad.appendChild(nodoTexto);
	}

	var nodoCNAE:FLDomElement = this.iface.xmlModelo.createElement("CNAE");
	nodoPadre.appendChild(nodoCNAE);
	var cnae:String = cursor.valueBuffer("cane7");
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cnae);
	nodoCNAE.appendChild(nodoTexto);
	
	if (cursor.valueBuffer("importetotalop7")) {
		var nodoImpOper:FLDomElement = this.iface.xmlModelo.createElement("ImpOper");
		nodoPadre.appendChild(nodoImpOper);
		var impOper:String = cursor.valueBuffer("importetotalop7");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(impOper);
		nodoImpOper.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("importetotalopdd7")) {
		var nodoImpOperDrDed:FLDomElement = this.iface.xmlModelo.createElement("ImpOperConDrchoDed");
		nodoPadre.appendChild(nodoImpOperDrDed);
		var impOperDrDed:String = cursor.valueBuffer("importetotalopdd7");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(impOperDrDed);
		nodoImpOperDrDed.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("tipoprorrata7")) {
		var nodoTipo:FLDomElement = this.iface.xmlModelo.createElement("Tipo");
		nodoPadre.appendChild(nodoTipo);
		var tipo:String = cursor.valueBuffer("tipoprorrata7");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(tipo);
		nodoTipo.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("porprorrata7")) {
		var nodoPorc:FLDomElement = this.iface.xmlModelo.createElement("Porc");
		nodoPadre.appendChild(nodoPorc);
		var porcentaje:String = cursor.valueBuffer("porprorrata7");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(porcentaje);
		nodoPorc.appendChild(nodoTexto);
	}
	return true;
}

function oficial_informarNodoPro8(nodoPadre:FLDomElement, version:String):Boolean
{	
	var cursor:FLSqlCursor = this.cursor();

	if (cursor.valueBuffer("actividaddesarollada8")) {
		var nodoActividad:FLDomElement = this.iface.xmlModelo.createElement("Actividad");
		nodoPadre.appendChild(nodoActividad);
		var actividad:String = cursor.valueBuffer("actividaddesarollada8");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(actividad);
		nodoActividad.appendChild(nodoTexto);
	}

	var nodoCNAE:FLDomElement = this.iface.xmlModelo.createElement("CNAE");
	nodoPadre.appendChild(nodoCNAE);
	var cnae:String = cursor.valueBuffer("cane8");
	var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(cnae);
	nodoCNAE.appendChild(nodoTexto);
	
	if (cursor.valueBuffer("importetotalop8")) {
		var nodoImpOper:FLDomElement = this.iface.xmlModelo.createElement("ImpOper");
		nodoPadre.appendChild(nodoImpOper);
		var impOper:String = cursor.valueBuffer("importetotalop8");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(impOper);
		nodoImpOper.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("importetotalopdd8")) {
		var nodoImpOperDrDed:FLDomElement = this.iface.xmlModelo.createElement("ImpOperConDrchoDed");
		nodoPadre.appendChild(nodoImpOperDrDed);
		var impOperDrDed:String = cursor.valueBuffer("importetotalopdd8");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(impOperDrDed);
		nodoImpOperDrDed.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("tipoprorrata8")) {
		var nodoTipo:FLDomElement = this.iface.xmlModelo.createElement("Tipo");
		nodoPadre.appendChild(nodoTipo);
		var tipo:String = cursor.valueBuffer("tipoprorrata8");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(tipo);
		nodoTipo.appendChild(nodoTexto);
	}

	if (cursor.valueBuffer("porprorrata8")) {
		var nodoPorc:FLDomElement = this.iface.xmlModelo.createElement("Porc");
		nodoPadre.appendChild(nodoPorc);
		var porcentaje:String = cursor.valueBuffer("porprorrata8");
		var nodoTexto:FLDomElement = this.iface.xmlModelo.createTextNode(porcentaje);
		nodoPorc.appendChild(nodoTexto);
	}
	return true;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
