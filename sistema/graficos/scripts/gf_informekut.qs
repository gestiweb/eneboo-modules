/***************************************************************************
                 gf_informekut.qs  -  description
                             -------------------
    begin                : vie may 14 2010
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
	function main() {
		return this.ctx.interna_main();
	}
	function init() {
		return this.ctx.interna_init();
	}
	function validateForm():Boolean {
		return this.ctx.interna_validateForm();
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var xmlGrafico_:FLDomDocument;
	var timerGraf_;
	var bloqueoRefresco_:Boolean;
	var tblNiveles_:FLTable;
	var tblCampos_:FLTable;
	var rptViewer_:FLReportViewer;
	var viewerLanzado_:Boolean;
	var nivelActual_:Number;
	var campoActual_:String;
	
	var CL_ID:Number;
	var CL_NIVEL:Number;
	
	var CF_ID:Number;
	var CF_CAMPO:Number;

	function oficial( context ) { interna( context ); }
	function aplicarEstiloReport(xmlDatos:FLDomDocument, xmlDocReport:FLDomDocument):Boolean {
		return this.ctx.oficial_aplicarEstiloReport(xmlDatos, xmlDocReport);
	}
	function tbnValoresDefecto_clicked() {
		return this.ctx.oficial_tbnValoresDefecto_clicked();
	}
	function establecerValoresDefecto():Boolean {
		return this.ctx.oficial_establecerValoresDefecto();
	}
	function dibujarInformeFrame() {
		return this.ctx.oficial_dibujarInformeFrame();
	}
	function dibujarInforme() {
		return this.ctx.oficial_dibujarInforme();
	}
// 	function dibujarGrafico(xmlDatos:FLDomDocument, marco:Rect):Picture {
// 		return this.ctx.oficial_dibujarGrafico(xmlDatos, marco);
// 	}
	function tbnRefrescar_clicked() {
		return this.ctx.oficial_tbnRefrescar_clicked();
	}
	function tbnRefrescarCampo_clicked() {
		return this.ctx.oficial_tbnRefrescarCampo_clicked();
	}
	function refrescarGrafico() {
		return this.ctx.oficial_refrescarGrafico();
	}
// 	function cargarCampos():Boolean {
// 		return this.ctx.oficial_cargarCampos();
// 	}
	function cargarEstilo() {
		return this.ctx.oficial_cargarEstilo();
	}
	function habilitarControles() {
		return this.ctx.oficial_habilitarControles();
	}
	function crearNivelGrafico(nivel:Number):FLDomElement {
		return this.ctx.oficial_crearNivelGrafico(nivel);
	}
	function crearCampoGrafico(idCampo:String):FLDomElement {
		return this.ctx.oficial_crearCampoGrafico(idCampo);
	}
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function renovarTimer() {
		return this.ctx.oficial_renovarTimer();
	}
	function iniciarMuestrasColor() {
		return this.ctx.oficial_iniciarMuestrasColor();
	}
// 	function configurarTablas() {
// 		return this.ctx.oficial_configurarTablas();
// 	}
// 	function tblNiveles_clicked(fila:Number, col:Number) {
// 		return this.ctx.oficial_tblNiveles_clicked(fila, col);
// 	}
// 	function tblCampos_clicked(fila:Number, col:Number) {
// 		return this.ctx.oficial_tblCampos_clicked(fila, col);
// 	}
// 	function cargarTablas() {
// 		return this.ctx.oficial_cargarTablas();
// 	}
	function cargarDatos() {
		return this.ctx.oficial_cargarDatos();
	}
// 	function cargarDatosNivel(nivel:Number):Boolean {
// 		return this.ctx.oficial_cargarDatosNivel(nivel);
// 	}
// 	function cargarDatosCampo(campo:String):Boolean {
// 		return this.ctx.oficial_cargarDatosCampo(campo);
// 	}
	function guardarDatos():Boolean {
		return this.ctx.oficial_guardarDatos();
	}
	function contenidoReportDefecto():String {
		return this.ctx.oficial_contenidoReportDefecto();
	}
	function contenidoDataDefecto():String {
		return this.ctx.oficial_contenidoDataDefecto();
	}
// 	function guardarDatosNivelActual():Boolean {
// 		return this.ctx.oficial_guardarDatosNivelActual();
// 	}
// 	function guardarDatosCampoActual():Boolean {
// 		return this.ctx.oficial_guardarDatosCampoActual();
// 	}
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
/** \C Cuando cambia el ejercicio actual se establece el título de las ventanas principales con
el nombre del ejercicio seleccionado
\end */
function interna_init()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	this.iface.bloqueoRefresco_ = false;

	this.iface.tblNiveles_ = this.child("tblNiveles");
	this.iface.tblCampos_ = this.child("tblCampos");
	

	this.iface.rptViewer_ = new FLReportViewer();
	this.iface.rptViewer_.reparent(this.child("frmInforme"));
	this.iface.viewerLanzado_ = false;

	connect(this.child("tbnValoresDefecto"), "clicked()", this, "iface.tbnValoresDefecto_clicked");
	connect(this.child("tbnRefrescar"), "clicked()", this, "iface.tbnRefrescar_clicked");
// 	connect(this.child("tbnRefrescarCampo"), "clicked()", this, "iface.tbnRefrescarCampo_clicked");
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
// 	connect(this.child("tbnNegritaPie"), "clicked()", this, "iface.tbnNegritaPie_clicked");

// 	connect(this.iface.tblNiveles_, "clicked(int, int)", this, "iface.tblNiveles_clicked");
// 	connect(this.iface.tblCampos_, "clicked(int, int)", this, "iface.tblCampos_clicked");
	
	this.iface.cargarEstilo();
// 	this.iface.configurarTablas();
// 	this.iface.cargarTablas();
	this.iface.cargarDatos();
	this.iface.habilitarControles();
	this.iface.tbnRefrescar_clicked();
}

function interna_main()
{
	var f:Object = new FLFormSearchDB("gf_informekut");
	var cursor:FLSqlCursor = f.cursor();

	cursor.select();
	if (!cursor.first()) {
		cursor.setModeAccess(cursor.Insert);
	} else {
		cursor.setModeAccess(cursor.Edit);
	}
	f.setMainWidget();

	if (cursor.modeAccess() == cursor.Insert) {
		f.child("pushButtonCancel").setDisabled(true);
	}
	cursor.refreshBuffer();
	var commitOk:Boolean = false;
	var acpt:Boolean;
	cursor.transaction(false);
	while (!commitOk) {
		acpt = false;
		f.exec("id");
		acpt = f.accepted();
		if (!acpt) {
			if (cursor.rollback())
				commitOk = true;
		} else {
			if (cursor.commitBuffer()) {
				cursor.commit();
				commitOk = true;
			}
		}
	}
}

function interna_validateForm():Boolean
{
	var util:FLUtil = new FLUtil();

	return true;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_aplicarEstiloReport(xmlEstilo:FLDomDocument, xmlDocReport:FLDomDocument):Boolean
{
	var util:FLUtil = new FLUtil;

// debug("xmlEstilo = " + xmlEstilo.toString(4));
// debug("xmlKugar = " + xmlDocReport.toString(4));
	var eEstilo:FLDomElement = xmlEstilo.firstChild().toElement();
	var eKugar:FLDomElement = xmlDocReport.namedItem("KugarTemplate").toElement();
	var eLabel:FLDomElement;
	
	/// Report
	var pageOrientation:Number = eEstilo.attribute("Apaisado") != "" ? eEstilo.attribute("Apaisado") : eKugar.attribute("PageOrientation");
	var leftMargin:Number = eEstilo.attribute("LeftMargin") != "" ? eEstilo.attribute("LeftMargin") : eKugar.attribute("LeftMargin");
	var rightMargin:Number = eEstilo.attribute("RightMargin") != "" ? eEstilo.attribute("RightMargin") : eKugar.attribute("RightMargin");
	
	eKugar.setAttribute("PageSize", eEstilo.attribute("PageSize") != "" ? eEstilo.attribute("PageSize") : eKugar.attribute("PageSize"));
	eKugar.setAttribute("PageOrientation", pageOrientation);
	eKugar.setAttribute("LeftMargin", leftMargin);
	eKugar.setAttribute("RightMargin", rightMargin);
	eKugar.setAttribute("TopMargin", eEstilo.attribute("TopMargin") != "" ? eEstilo.attribute("TopMargin") : eKugar.attribute("TopMargin"));
	eKugar.setAttribute("BottomMargin", eEstilo.attribute("BottomMargin") != "" ? eEstilo.attribute("BottomMargin") : eKugar.attribute("BottomMargin"));
	var ejeMedidas:String = eKugar.attribute("EjeMedidas");
	if (!ejeMedidas || ejeMedidas == "") {
		ejeMedidas = "Y";
	}
	
	/// Cabecera página
	var titulo:String = eEstilo.attribute("Titulo");
	var ePageHeader:FLDomElement = eKugar.namedItem("PageHeader").toElement();
	eLabel = ePageHeader.namedItem("Label").toElement();
	eLabel.setAttribute("Text", titulo);
		
	/// Cabecera detalle
	var anchoCabFil:Number = eEstilo.attribute("AnchoCabeceraFilas") != "" ? parseInt(eEstilo.attribute("AnchoCabeceraFilas")) : 100;
	var altoCabCol:Number = eEstilo.attribute("AltoCabeceraColumnas") != "" ? parseInt(eEstilo.attribute("AltoCabeceraColumnas")) : 20;
	var anchoColumnas:Number; 
	var autoAnchoColumnas:Boolean = eEstilo.attribute("AutoAnchoColumnas") == "1";
	if (!autoAnchoColumnas) {
		anchoColumnas = eEstilo.attribute("AnchoColumnas") != "" ? parseInt(eEstilo.attribute("AnchoColumnas")) : 80;
	}
	var altoFilas:Number = eEstilo.attribute("AltoFilas") != "" ? parseInt(eEstilo.attribute("AltoFilas")) : 20;
	var borderStyleDatos:Number = eEstilo.attribute("BorderStyle") != "" ? parseInt(eEstilo.attribute("BorderStyle")) : 0;
	
	var eDetailHeader:FLDomElement = eKugar.namedItem("DetailHeader").toElement();
	var eDetail:FLDomElement = eKugar.namedItem("Detail").toElement();
	var numMedidasV:Number = (eDetail.attribute("NumMedidasV") != "" ? parseInt(eDetail.attribute("NumMedidasV")) : 1);
// 	var numMedidasH:Number = (eDetail.attribute("NumMedidasH") != "" ? parseInt(eDetail.attribute("NumMedidasH")) : 1);
	
	var anchoTotalCabFil:Number = numMedidasV > 1 ? anchoCabFil + anchoCabFil - 2: anchoCabFil - 1;
	var x:Number = anchoTotalCabFil;
	var iNivel:Number = eDetailHeader.attribute("Level");
	if (ejeMedidas == "X") {
		eDetailHeader.setAttribute("Height", altoCabCol * 2);
	} else {
		eDetailHeader.setAttribute("Height", altoCabCol);
	}
	var xmlLabels:FLDomNodeList = eDetailHeader.elementsByTagName("Label");
	if (!xmlLabels) {
// debug("!xmlLabels");
		return false;
	}
	var numCols:Number = 0;
	var numLabels:Number = xmlLabels.count();
	var tipoTitulo:String;
	for (var i:Number = 0; i < numLabels; i++) {
		tipoTitulo = xmlLabels.item(i).toElement().attribute("TipoTitulo");
		if (tipoTitulo == "Nivel" || tipoTitulo == "Prop") {
			numCols++;
		}
	}
	if (autoAnchoColumnas) {
		anchoColumnas = parseInt(((pageOrientation == 1 ? 915 : 645) - parseInt(leftMargin) - parseInt(rightMargin) - anchoTotalCabFil) / numCols);
	}
	for (var k:Number = 0; k < xmlLabels.count(); k++) {
		eLabel = xmlLabels.item(k).toElement();
		switch (eLabel.attribute("TipoTitulo")) {
			case "Medida": {
				continue;
			}
			case "Prop": {
				x += anchoColumnas - 1;
				continue;
			}
		}
		eLabel.setAttribute("X", x);
		eLabel.setAttribute("Y", 0);
		eLabel.setAttribute("Width", anchoColumnas);
		x += parseInt(eLabel.attribute("Width")) - 1;
		eLabel.setAttribute("BorderStyle", borderStyleDatos);
		eLabel.setAttribute("Height", altoCabCol + 1);
	}
	x = anchoTotalCabFil;
	for (var k:Number = 0; k < xmlLabels.count(); k++) {
		eLabel = xmlLabels.item(k).toElement();
		switch (eLabel.attribute("TipoTitulo")) {
			case "Medida":
			case "Prop": {
				break;
			}
			default: {
				continue;
			}
		}
		eLabel.setAttribute("X", x);
		eLabel.setAttribute("Y", ejeMedidas == "X" ? altoCabCol : 0);
		eLabel.setAttribute("Width", anchoColumnas);
		x += parseInt(eLabel.attribute("Width")) - 1;
		eLabel.setAttribute("BorderStyle", borderStyleDatos);
		eLabel.setAttribute("Height", altoCabCol + 1);
	}
	
	/// Filas
	var eField:FLDomElement;
	x = 0;
// 	iNivel = eDetail.attribute("Level");
	eDetail.setAttribute("Height", altoFilas * numMedidasV);
	eField = eDetail.firstChild().toElement();
	if (eField.attribute("Field") != "cabecera_fila") {
		debug("!cabecera_fila");
		return false;
	}
	eField.setAttribute("X", x);
	eField.setAttribute("Y", 0);
	eField.setAttribute("BorderStyle", borderStyleDatos);
	eField.setAttribute("Height", (altoFilas * numMedidasV) + 1);
	eField.setAttribute("Width", anchoCabFil);
	x += parseInt(eField.attribute("Width")) - 1;
	
	if (numMedidasV > 1) {
		var xmlLabels:FLDomNodeList = eDetail.elementsByTagName("Label");
		var eLabel:FLDomElement;
		for (var l:Number = 0; l < numMedidasV; l++) {
			eLabel = xmlLabels.item(l).toElement();
			eLabel.setAttribute("X", x);
			eLabel.setAttribute("Y", l * altoFilas);
			eLabel.setAttribute("BorderStyle", borderStyleDatos);
			eLabel.setAttribute("Height", altoFilas + 1);
			eLabel.setAttribute("Width", anchoCabFil);
		}
		x += parseInt(eLabel.attribute("Width")) - 1;
	}
		
	var xmlFields:FLDomNodeList = eDetail.elementsByTagName("Field");
	var iField:Number = 1;
	var numCols:Number = (xmlFields.count() - 1) / numMedidasV;
	for (var k:Number = 0; k < numCols; k++) {
		for (var l:Number = 0; l < numMedidasV; l++) {
			eField = xmlFields.item(iField).toElement();
			eField.setAttribute("X", x);
			eField.setAttribute("Y", l * altoFilas);
			eField.setAttribute("BorderStyle", borderStyleDatos);
			eField.setAttribute("Height", altoFilas + 1);
			eField.setAttribute("Width", anchoColumnas);
			iField++;
		}
		x += parseInt(eField.attribute("Width")) - 1;
	}

	return true;
}

function oficial_aplicarEstiloReport2(xmlEstilo:FLDomDocument, xmlDocReport:FLDomDocument):Boolean
{
	var util:FLUtil = new FLUtil;

// 	debug("xmlEstilo = " + xmlEstilo.toString(4));
	var eEstilo:FLDomElement = xmlEstilo.firstChild().toElement();
	var eKugar:FLDomElement = xmlDocReport.namedItem("KugarTemplate").toElement();

	var eEstiloCampoDef:FLDomNode = flgraficos.iface.pub_dameElementoXML(eEstilo, "Fields/Field[@Id=-1]");
	var xPos:Number = 0, xSangria:Number, anchoCampo:Number, xLevel:Number = 0, negritaPie:Boolean;
	
	/// Niveles
	var aSecciones:Array = ["Detail", "DetailHeader", "DetailFooter"]; ///
	var aObjetos:Array = ["Field", "CalculatedField"]; ///
	var aPosX:Array = [];
	var xmlDetalles:FLDomNodeList;
	for (var iSeccion:Number = 0; iSeccion < aSecciones.length; iSeccion++) {
		xmlDetalles = eKugar.elementsByTagName(aSecciones[iSeccion]);
		if (xmlDetalles && xmlDetalles.count() > 0) {
			var eDetalle:FLDomElement, iNivel:Number, eEstiloDetalle:FLDomElement;
			var altoNivel:Number;
			var eEstiloDetalleDef:FLDomNode = flgraficos.iface.pub_dameElementoXML(eEstilo, "Levels/Level[@Id=-1]");
			for (var i:Number = 0; i < xmlDetalles.count(); i++) {
				eDetalle = xmlDetalles.item(i).toElement();
				iNivel = eDetalle.attribute("Level");
				eEstiloDetalle = flgraficos.iface.pub_dameElementoXML(eEstilo, "Levels/Level[@Id=" + iNivel.toString() + "]");
				if (!eEstiloDetalle) {
					eEstiloDetalle = eEstiloDetalleDef;
				}
				altoNivel = eEstiloDetalle.attribute("AltoNivel") == "" ? eEstiloDetalleDef.attribute("AltoNivel") : eEstiloDetalle.attribute("AltoNivel");
				var mostrarPie:Boolean = true;
				if (aSecciones[iSeccion] == "DetailFooter") {
					mostrarPie = eEstiloDetalle.attribute("MostrarPie") == "" ? eEstiloDetalleDef.attribute("MostrarPie") == "true" : eEstiloDetalle.attribute("MostrarPie") == "true";
					if (!mostrarPie) {
						altoNivel = 0;
					}
					negritaPie = eEstiloDetalle.attribute("NegritaPie") == "" ? eEstiloDetalleDef.attribute("NegritaPie") == "true" : eEstiloDetalle.attribute("NegritaPie") == "true";
				}
				
				xSangria =  eEstiloDetalle.attribute("SangriaNivel") == "" ? eEstiloDetalleDef.attribute("SangriaNivel") : eEstiloDetalle.attribute("SangriaNivel");
				xSangria = (xSangria ? xSangria : 0);
debug("xSangria = " + xSangria);
				eDetalle.setAttribute("Height", altoNivel);
				/// Campos
				if (eEstiloCampoDef) {
					xPos = xLevel;
					for (var iObjeto:Number = 0; iObjeto < aObjetos.length; iObjeto++) {
						var xmlCampos:FLDomNodeList = eDetalle.elementsByTagName(aObjetos[iObjeto]);
						if (xmlCampos && xmlCampos.count() > 0) {
							var eCampo:FLDomElement, idCampo:String , eEstiloCampo:FLDomElement;
							var bordeCampo:Boolean;
							for (var i:Number = 0; i < xmlCampos.count(); i++) {
								eCampo = xmlCampos.item(i).toElement();
								idCampo = eCampo.attribute("Field");
								eEstiloCampo = flgraficos.iface.pub_dameElementoXML(eEstilo, "Fields/Field[@Id=" + idCampo + "]");
								if (!eEstiloCampo) {
									eEstiloCampo = eEstiloCampoDef;
								}
								bordeCampo = eEstiloCampo.attribute("BordeCampo") == "" ? eEstiloCampoDef.attribute("BordeCampo") : eEstiloCampo.attribute("BordeCampo");
								eCampo.setAttribute("BorderStyle", bordeCampo == "true" ? "1" : "0");
								anchoCampo = eEstiloCampo.attribute("AnchoCampo") == "" ? eEstiloCampoDef.attribute("AnchoCampo") : eEstiloCampo.attribute("AnchoCampo");
								eCampo.setAttribute("Width", anchoCampo);
								eCampo.setAttribute("Height", eEstiloCampo.attribute("AltoCampo") == "" ? eEstiloCampoDef.attribute("AltoCampo") : eEstiloCampo.attribute("AltoCampo"));
// debug("Nivel = " + eEstiloCampo.attribute("Precision"));
// debug("Nivel Def = " + eEstiloCampoDef.attribute("Precision"));
								eCampo.setAttribute("Precision", eEstiloCampo.attribute("Precision") == "" ? eEstiloCampoDef.attribute("Precision") : eEstiloCampo.attribute("Precision"));
								switch (aObjetos[iObjeto]) {
									case "Field": {
										eCampo.setAttribute("X", xPos);
										aPosX[idCampo] = xPos;
										xPos += parseInt(anchoCampo) - 1;
										break;
									}
									case "CalculatedField": {
										if (!mostrarPie) {
											eCampo.setAttribute("Height", 0);
											eCampo.setAttribute("Width", 0);
										}
										break;
									}
								}
								switch (aSecciones[iSeccion]) {
									case "DetailFooter": {
										eCampo.setAttribute("FontWeight", negritaPie ? 65 : 50);
										break;
									}
								}
							}
						}
					}
				}
				xLevel += parseInt(xSangria);
			}
		}
	}
	/// Alinear campos calculados con su campo de detalle.
	var xmlCampos:FLDomNodeList = eKugar.elementsByTagName("CalculatedField");
	if (xmlCampos && xmlCampos.count() > 0) {
		var eCampo:FLDomElement, idCampo:String
		for (var i:Number = 0; i < xmlCampos.count(); i++) {
			eCampo = xmlCampos.item(i).toElement();
			idCampo = eCampo.attribute("Field");
			eCampo.setAttribute("X", aPosX[idCampo]);
		}
	}

	return true;
}

function oficial_tbnValoresDefecto_clicked()
{
	var util:FLUtil = new FLUtil;

	var res:Number = MessageBox.warning(util.translate("scripts", "Va a restaurar los valores por defecto del informe.\n¿Está seguro?"), MessageBox.Yes, MessageBox.No);
	if (res != MessageBox.Yes) {
		return;
	}

	if (!this.iface.establecerValoresDefecto()) {
		return false;
	}
	this.iface.dibujarInformeFrame();

// 	this.iface.cargarCampos();
}

function oficial_establecerValoresDefecto():Boolean
{
	var util:FLUtil = new FLUtil;

	this.iface.xmlGrafico_ = new FLDomDocument();
	var xmlDoc:FLDomDocument = this.iface.xmlGrafico_;

	xmlDoc.setContent("<Informe/>");
	var eEstilo:FLDomElement = xmlDoc.firstChild().toElement();
	eEstilo.setAttribute("AutoAnchoColumnas", "true");
	eEstilo.setAttribute("BottomMargin", "50");
	eEstilo.setAttribute("TopMargin", "50");
	eEstilo.setAttribute("LeftMargin", "50");
	eEstilo.setAttribute("RightMargin", "50");
	eEstilo.setAttribute("AltoFilas", "20");
	eEstilo.setAttribute("AnchoCabeceraFilas", "100");
	eEstilo.setAttribute("Titulo", util.translate("scripts", "Título del informe"));
	return true;
}

function oficial_contenidoReportDefecto():String
{
	var contenido:String = "<?xml version = '1.0' encoding = 'UTF-8'?>" + "\n";
	contenido += "<!DOCTYPE KugarTemplate SYSTEM 'kugartemplate.dtd'>" + "\n";
	contenido += "<KugarTemplate BottomMargin='50' TopMargin='50' LeftMargin='30' RightMargin='30' PageOrientation='0' PageSize='0' >" + "\n";
	contenido += "    <PageHeader Height='20' >" + "\n";
	contenido += "        <Label Width='600' X='0' BorderStyle='0' Y='0' Height='20' BackgroundColor='255,255,255' VAlignment='1' ForegroundColor='0,0,0' Text='' FontSize='10' BorderWidth='0' FontFamily='Arial' />" + "\n";
	contenido += "    </PageHeader>" + "\n";
	contenido += "    <DetailHeader Height='20' Level='0' >" + "\n";
	contenido += "        <Label Width='80' TipoTitulo='Nivel' X='198' BorderStyle='0' Y='0' Height='21' HAlignment='2' DataType='0' BackgroundColor='255,255,255' VAlignment='1' ForegroundColor='0,0,0' Text='Cliente 1 (Recargo)' FontSize='10' BorderWidth='0' FontFamily='Arial' />" + "\n";
	contenido += "        <Label Width='80' TipoTitulo='Nivel' X='277' BorderStyle='0' Y='0' Height='21' HAlignment='2' DataType='0' BackgroundColor='255,255,255' VAlignment='1' ForegroundColor='0,0,0' Text='Cliente 2' FontSize='10' BorderWidth='0' FontFamily='Arial' />" + "\n";
	contenido += "        <Label Width='80' TipoTitulo='Nivel' X='356' BorderStyle='0' Y='0' Height='21' HAlignment='2' DataType='0' BackgroundColor='255,255,255' VAlignment='1' ForegroundColor='0,0,0' Text='UE' FontSize='10' BorderWidth='0' FontFamily='Arial' />" + "\n";
	contenido += "    </DetailHeader>" + "\n";
	contenido += "    <Detail NumMedidasV='2' Height='40' Level='0' >" + "\n";
	contenido += "        <Field Width='100' X='0' BorderStyle='0' Y='0' Height='41' HAlignment='0' DataType='0' Field='cabecera_fila' BackgroundColor='255,255,255' VAlignment='1' ForegroundColor='0,0,0' FontSize='10' BorderWidth='0' FontFamily='Arial' />" + "\n";
	contenido += "        <Label Width='100' TipoTitulo='Medida' X='99' BorderStyle='0' Y='0' Height='21' HAlignment='2' DataType='0' BackgroundColor='255,255,255' VAlignment='1' ForegroundColor='0,0,0' Text='Ventas' FontSize='10' BorderWidth='0' FontFamily='Arial' />" + "\n";
	contenido += "        <Label Width='100' TipoTitulo='Medida' X='99' BorderStyle='0' Y='20' Height='21' HAlignment='2' DataType='0' BackgroundColor='255,255,255' VAlignment='1' ForegroundColor='0,0,0' Text='Cantidad' FontSize='10' BorderWidth='0' FontFamily='Arial' />" + "\n";
	contenido += "        <Field Width='80' X='198' BorderStyle='0' Y='0' Height='21' HAlignment='2' DataType='2' Field='ventas_0_000001' BackgroundColor='255,255,255' VAlignment='1' ForegroundColor='0,0,0' FontSize='10' BorderWidth='0' Precision='2' FontFamily='Arial' />" + "\n";
	contenido += "        <Field Width='80' X='198' BorderStyle='0' Y='20' Height='21' HAlignment='2' DataType='2' Field='cantidad_0_000001' BackgroundColor='255,255,255' VAlignment='1' ForegroundColor='0,0,0' FontSize='10' BorderWidth='0' Precision='0' FontFamily='Arial' />" + "\n";
	contenido += "        <Field Width='80' X='277' BorderStyle='0' Y='0' Height='21' HAlignment='2' DataType='2' Field='ventas_0_000002' BackgroundColor='255,255,255' VAlignment='1' ForegroundColor='0,0,0' FontSize='10' BorderWidth='0' Precision='2' FontFamily='Arial' />" + "\n";
	contenido += "        <Field Width='80' X='277' BorderStyle='0' Y='20' Height='21' HAlignment='2' DataType='2' Field='cantidad_0_000002' BackgroundColor='255,255,255' VAlignment='1' ForegroundColor='0,0,0' FontSize='10' BorderWidth='0' Precision='0' FontFamily='Arial' />" + "\n";
	contenido += "        <Field Width='80' X='356' BorderStyle='0' Y='0' Height='21' HAlignment='2' DataType='2' Field='ventas_0_000003' BackgroundColor='255,255,255' VAlignment='1' ForegroundColor='0,0,0' FontSize='10' BorderWidth='0' Precision='2' FontFamily='Arial' />" + "\n";
	contenido += "        <Field Width='80' X='356' BorderStyle='0' Y='20' Height='21' HAlignment='2' DataType='2' Field='cantidad_0_000003' BackgroundColor='255,255,255' VAlignment='1' ForegroundColor='0,0,0' FontSize='10' BorderWidth='0' Precision='0' FontFamily='Arial' />" + "\n";
	contenido += "    </Detail>" + "\n";
	contenido += "</KugarTemplate>";
	return contenido;
}

function oficial_contenidoDataDefecto():String
{
	var contenido:String = "<KugarData>" + "\n";
	contenido += "    <Row cantidad_0_000001='1' cantidad_0_000002='0' cantidad_0_000003='2' cabecera_fila='Febrero' ventas_0_000001='10' ventas_0_000002='0' ventas_0_000003='20' level='0' />" + "\n";
	contenido += "    <Row cantidad_0_000001='1.00' cantidad_0_000002='0' cantidad_0_000003='2.00' cabecera_fila='1' ventas_0_000001='10.00' ventas_0_000002='0' ventas_0_000003='20.00' level='0' />" + "\n";
	contenido += "    <Row cantidad_0_000001='2' cantidad_0_000002='0' cantidad_0_000003='0' cabecera_fila='Marzo' ventas_0_000001='60' ventas_0_000002='0' ventas_0_000003='0' level='0' />" + "\n";
	contenido += "    <Row cantidad_0_000001='2.00' cantidad_0_000002='0' cantidad_0_000003='0' cabecera_fila='Referencia 2' ventas_0_000001='60.00' ventas_0_000002='0' ventas_0_000003='0' level='0' />" + "\n";
	contenido += "    <Row cantidad_0_000001='5' cantidad_0_000002='5' cantidad_0_000003='0' cabecera_fila='Abril' ventas_0_000001='150' ventas_0_000002='150' ventas_0_000003='0' level='0' />" + "\n";
	contenido += "    <Row cantidad_0_000001='5.00' cantidad_0_000002='5.00' cantidad_0_000003='0' cabecera_fila='Referencia 2' ventas_0_000001='150.00' ventas_0_000002='150.00' ventas_0_000003='0' level='0' />" + "\n";
	contenido += "</KugarData>";

	return contenido;
}

function oficial_dibujarInforme()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var eGrafico:FLDomElement = this.iface.xmlGrafico_.firstChild().toElement();
	
	var contenidoReport:String = cursor.isNull("xmlreport") ? this.iface.contenidoReportDefecto() : cursor.valueBuffer("xmlreport");
	var xmlDocReport:FLDomDocument = new FLDomDocument;
	xmlDocReport.setContent(contenidoReport);

	var contenidoData:String = cursor.isNull("xmldata") ? this.iface.contenidoDataDefecto() : cursor.valueBuffer("xmldata");
	var xmlDocData:FLDomDocument = new FLDomDocument;
	xmlDocData.setContent(contenidoData);

	if (!this.iface.aplicarEstiloReport(this.iface.xmlGrafico_, xmlDocReport)) {
		MessageBox.warning(util.translate("scripts", "Error al dibujar el informe"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
// debug("Estilo = " + this.iface.xmlGrafico_.toString(4));
// debug("Report = " + xmlDocReport.toString(4));

	var xmlKT:FLDomNode = xmlDocReport.namedItem("KugarTemplate");
	
	this.iface.rptViewer_.setReportTemplate(xmlKT);
	if (!this.iface.viewerLanzado_) {
		this.iface.rptViewer_.setReportData(xmlDocData);
		this.iface.rptViewer_.renderReport();
		this.iface.viewerLanzado_ = true;
	}
	return true;
}

function oficial_dibujarInformeFrame()
{
	if (!this.iface.dibujarInforme()) {
		return false;
	}
	this.iface.rptViewer_.updateReport();
}

function oficial_cargarEstilo()
{
	var cursor:FLSqlCursor = this.cursor();
	var xml:String = cursor.valueBuffer("xml");
	if (!xml) {
		return false;
	}
	this.iface.xmlGrafico_ = new FLDomDocument;
	if (!this.iface.xmlGrafico_.setContent(xml)) {
		this.iface.xmlGrafico_ = false;
		return false;
	}
// 	this.iface.cargarCampos();
// 	this.iface.tbnRefrescar_clicked();
}

// function oficial_configurarTablas()
// {
// 	var util:FLUtil = new FLUtil;
// 
// 	this.iface.CL_ID = 0;
// 	this.iface.CL_NIVEL = 1;
// 
// 	this.iface.tblNiveles_.setNumRows(0);
// 	this.iface.tblNiveles_.setNumCols(2);
// 	var cabecera:Array = [util.translate("scripts", "ID"), util.translate("scripts", "Nivel")];
// 	this.iface.tblNiveles_.setColumnLabels("*", cabecera.join("*"));
// 	this.iface.tblNiveles_.hideColumn(this.iface.CL_ID);
// 	this.iface.tblNiveles_.setColumnWidth(this.iface.CL_NIVEL, 100);
// 	
// 	this.iface.CF_ID = 0;
// 	this.iface.CF_CAMPO = 1;
// 
// 	this.iface.tblCampos_.setNumRows(0);
// 	this.iface.tblCampos_.setNumCols(2);
// 	var cabeceraC:Array = [util.translate("scripts", "ID"), util.translate("scripts", "Campo")];
// 	this.iface.tblCampos_.setColumnLabels("*", cabeceraC.join("*"));
// 	this.iface.tblCampos_.hideColumn(this.iface.CF_ID);
// 	this.iface.tblCampos_.setColumnWidth(this.iface.CF_CAMPO, 100);
// }

// function oficial_cargarTablas()
// {
// 	var util:FLUtil = new FLUtil;
// 	var cursor:FLSqlCursor = this.cursor();
// 	var xmlDocReport:FLDomDocument = new FLDomDocument;
// 	xmlDocReport.setContent(cursor.valueBuffer("xmlreport"));
// 	var xmlNiveles:FLDomNodeList = xmlDocReport.elementsByTagName("Detail");
// 	if (!xmlNiveles) {
// 		return false;
// 	}
// 	var numNiveles:Number = xmlNiveles.length();
// 	var fila:Number;
// 	for (var i:Number = -1; i < numNiveles; i++) {
// 		fila = i + 1;
// 		this.iface.tblNiveles_.insertRows(fila);
// 		this.iface.tblNiveles_.setText(fila, this.iface.CL_ID, i);
// 		this.iface.tblNiveles_.setText(fila, this.iface.CL_NIVEL, i);
// 	}
// 	this.iface.cargarDatosNivel(-1);
// 	this.iface.cargarDatosCampo(-1);
// 	
// 	var xmlCampos:FLDomNodeList = xmlDocReport.elementsByTagName("Field");
// 	if (!xmlCampos) {
// 		return false;
// 	}
// 	var numCampos:Number = xmlCampos.length();
// 	var eCampo:FLDomElement;
// 	fila = 0;
// 	this.iface.tblCampos_.insertRows(fila);
// 	this.iface.tblCampos_.setText(fila, this.iface.CF_ID, -1);
// 	this.iface.tblCampos_.setText(fila, this.iface.CF_CAMPO, util.translate("scripts", "(Por defecto)"));
// 	for (var i:Number = 0; i < numCampos; i++) {
// 		eCampo = xmlCampos.item(i).toElement();
// 		fila = i + 1;
// 		this.iface.tblCampos_.insertRows(fila);
// 		this.iface.tblCampos_.setText(fila, this.iface.CF_ID, eCampo.attribute("Field"));
// 		this.iface.tblCampos_.setText(fila, this.iface.CF_CAMPO, eCampo.attribute("Field"));
// 	}
// 	this.iface.cargarDatosCampo(-1);
// }

// function oficial_cargarCampos():Boolean
// {
// 	this.iface.bloqueoRefresco_ = true;
// 	var cursor:FLSqlCursor = this.cursor();
// 
// 
// // 	var eGrafico:FLDomElement = this.iface.xmlGrafico_.firstChild().toElement();
// // 	var eEstiloDetalleDef:FLDomElement = flgraficos.iface.pub_dameElementoXML(eGrafico, "Levels/Level[@Id=-1]");
// // 	this.child("fdbAltoNivel").setValue(eEstiloDetalleDef.attribute("AltoNivel"));
// 
// 	this.iface.dibujarInformeFrame();
// 
// 	return true;
// }

function oficial_tbnRefrescar_clicked()
{
	this.iface.refrescarGrafico();
}
function oficial_tbnRefrescarCampo_clicked()
{
	this.iface.refrescarGrafico();
}

function oficial_refrescarGrafico()
{
// 	if (!this.iface.guardarDatosNivelActual()) {
// 		return false;
// 	}
// 	if (!this.iface.guardarDatosNivelActual()) {
// 		return false;
// 	}
	if (!this.iface.guardarDatos()) {
		return false;
	}
	this.iface.dibujarInformeFrame();
}

function oficial_crearNivelGrafico(nivel:Number):FLDomElement
{
	var eGrafico:FLDomElement = this.iface.xmlGrafico_.firstChild().toElement();
	var xmlLevels:FLDomNode = eGrafico.namedItem("Levels");
	var eLevels:FLDomElement;
	if (xmlLevels) {
		eLevels = xmlLevels.toElement();
	} else {
		eLevels = this.iface.xmlGrafico_.createElement("Levels");
		eGrafico.appendChild(eLevels);
	}
	var eLevel:FLDomElement = this.iface.xmlGrafico_.createElement("Level");
	eLevels.appendChild(eLevel);
	eLevel.setAttribute("Id", nivel);
	
	return eLevel;
}

function oficial_crearCampoGrafico(idCampo:String):FLDomElement
{
	var eGrafico:FLDomElement = this.iface.xmlGrafico_.firstChild().toElement();
	var xmlFields:FLDomNode = eGrafico.namedItem("Fields");
	var eFields:FLDomElement;
	if (xmlFields) {
		eFields = xmlFields.toElement();
	} else {
		eFields = this.iface.xmlGrafico_.createElement("Fields");
		eGrafico.appendChild(eFields);
	}
	var eField:FLDomElement = this.iface.xmlGrafico_.createElement("Field");
	eFields.appendChild(eField);
	eField.setAttribute("Id", idCampo);
	
	return eField;
}
/** \D Sólo es posible guardar los valores por defecto del gráfico cuando se accede desde el módulo de gráficos
\end */
function oficial_habilitarControles()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	var id:String = cursor.valueBuffer("id");
	if (!util.sqlSelect("gf_informekut", "id", "id = " + id)) {
		this.child("tbnValoresDefecto").close();
		this.child("tbnGuardar").close();
	}
}

function oficial_bufferChanged(fN:String)
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	switch (fN) {
		case "xml": {
			break;
		}
		default: {
// 			this.iface.renovarTimer();
		}
	}
}

function oficial_renovarTimer()
{
// 	killTimer(this.iface.timerGraf_);
// 	if (this.iface.bloqueoRefresco_) {
// 		return;
// 	}
// 	this.iface.timerGraf_ = startTimer(1000, this.iface.refrescarGrafico);
}

function oficial_iniciarMuestrasColor()
{
	var cursor:FLSqlCursor = this.cursor();
// 	flgraficos.iface.pub_colorearLabel(this.child("lblColorMarcaY"), cursor.valueBuffer("colormarcay"));
}

// function oficial_tblNiveles_clicked(fila:Number, col:Number)
// {
// 	var nivel:Number = fila - 1;
// 	this.iface.guardarDatosNivelActual();
// 	this.iface.cargarDatosNivel(nivel);
// }
// 
// function oficial_tblCampos_clicked(fila:Number, col:Number)
// {
// 	var campo:String = this.iface.tblCampos_.text(fila, this.iface.CF_ID);
// 	this.iface.guardarDatosCampoActual();
// 	this.iface.cargarDatosCampo(campo);
// }

// function oficial_cargarDatosNivel(nivel:Number):Boolean
// {
// 	var cursor:FLSqlCursor = this.cursor();
// 	var eGrafico:FLDomElement = this.iface.xmlGrafico_.firstChild().toElement();
// 	var eEstiloDetalle:FLDomElement = flgraficos.iface.pub_dameElementoXML(eGrafico, "Levels/Level[@Id=" + nivel.toString() + "]");
// 	this.child("fdbAltoNivel").setValue(eEstiloDetalle ? eEstiloDetalle.attribute("AltoNivel") : "");
// 	this.child("fdbSangriaNivel").setValue(eEstiloDetalle ? eEstiloDetalle.attribute("SangriaNivel") : "");
// 	this.child("fdbMostrarPieNivel").setValue(eEstiloDetalle ? eEstiloDetalle.attribute("MostrarPie") : false);
// 	this.child("tbnNegritaPie").on = eEstiloDetalle ? eEstiloDetalle.attribute("NegritaPie") == "true" : false;
// 	
// 	this.iface.nivelActual_ = nivel;
// 	return true;
// }

// function oficial_cargarDatosCampo(campo:String):Boolean
// {
// 	var cursor:FLSqlCursor = this.cursor();
// 	var eGrafico:FLDomElement = this.iface.xmlGrafico_.firstChild().toElement();
// 	var eEstiloCampo:FLDomElement = flgraficos.iface.pub_dameElementoXML(eGrafico, "Fields/Field[@Id=" + campo + "]");
// 	var valor:String = eEstiloCampo ? eEstiloCampo.attribute("BordeCampo") : "";
// 	this.child("fdbBordeCampo").setValue(valor == "true");
// 	this.child("fdbAltoCampo").setValue(eEstiloCampo ? eEstiloCampo.attribute("AltoCampo") : "");
// 	this.child("fdbAnchoCampo").setValue(eEstiloCampo ? eEstiloCampo.attribute("AnchoCampo") : "");
// 	this.child("fdbPrecision").setValue(eEstiloCampo ? eEstiloCampo.attribute("Precision") : "");
// 	this.iface.campoActual_ = campo;
// 	return true;
// }
// 
function oficial_cargarDatos():Boolean
{
	if (!this.iface.xmlGrafico_) {
		if (!this.iface.establecerValoresDefecto()) {
			return false;
		}
	}
	var cursor:FLSqlCursor = this.cursor();
	var eGrafico:FLDomElement = this.iface.xmlGrafico_.firstChild().toElement();
	this.child("fdbTitulo").setValue(eGrafico.attribute("Titulo"));
	this.child("fdbApaisado").setValue(eGrafico.attribute("Apaisado") == "1");
	this.child("fdbLeftMargin").setValue(eGrafico.attribute("LeftMargin"));
	this.child("fdbRightMargin").setValue(eGrafico.attribute("RightMargin"));
	this.child("fdbTopMargin").setValue(eGrafico.attribute("TopMargin"));
	this.child("fdbBottomMargin").setValue(eGrafico.attribute("BottomMargin"));
	this.child("fdbAnchoCabeceraFilas").setValue(eGrafico.attribute("AnchoCabeceraFilas"));
	this.child("fdbAltoCabeceraColumnas").setValue(eGrafico.attribute("AltoCabeceraColumnas"));
	this.child("fdbAnchoColumnas").setValue(eGrafico.attribute("AnchoColumnas"));
	this.child("fdbAutoAnchoColumnas").setValue(eGrafico.attribute("AutoAnchoColumnas") == "1");
	this.child("fdbAltoFilas").setValue(eGrafico.attribute("AltoFilas"));
	this.child("fdbMarcarBordes").setValue(eGrafico.attribute("BorderStyle") == "1");
	return true;
}

function oficial_guardarDatos():Boolean
{
	if (!this.iface.xmlGrafico_) {
		if (!this.iface.establecerValoresDefecto()) {
			return false;
		}
	}
	var cursor:FLSqlCursor = this.cursor();
	var eGrafico:FLDomElement = this.iface.xmlGrafico_.firstChild().toElement();
	eGrafico.setAttribute("Titulo", cursor.valueBuffer("titulo"));
	eGrafico.setAttribute("Apaisado", cursor.valueBuffer("apaisado") ? "1" : "0");
	eGrafico.setAttribute("LeftMargin", cursor.isNull("leftmargin") ? "" : cursor.valueBuffer("leftmargin"));
	eGrafico.setAttribute("RightMargin", cursor.isNull("rightmargin") ? "" : cursor.valueBuffer("rightmargin"));
	eGrafico.setAttribute("TopMargin", cursor.isNull("topmargin") ? "" : cursor.valueBuffer("topmargin"));
	eGrafico.setAttribute("BottomMargin", cursor.isNull("bottommargin") ? "" : cursor.valueBuffer("bottommargin"));
	eGrafico.setAttribute("AnchoCabeceraFilas", cursor.isNull("anchocabecerafilas") ? "" : cursor.valueBuffer("anchocabecerafilas"));
	eGrafico.setAttribute("AltoCabeceraColumnas", cursor.isNull("altocabeceracolumnas") ? "" : cursor.valueBuffer("altocabeceracolumnas"));
	eGrafico.setAttribute("AutoAnchoColumnas", cursor.valueBuffer("autoanchocolumnas") ? "1" : "0");
	eGrafico.setAttribute("AnchoColumnas", cursor.isNull("anchocolumnas") ? "" : cursor.valueBuffer("anchocolumnas"));
	eGrafico.setAttribute("AltoFilas", cursor.isNull("altofilas") ? "" : cursor.valueBuffer("altofilas"));
	eGrafico.setAttribute("BorderStyle", cursor.valueBuffer("marcarbordes") ? "1" : "0");
	
	cursor.setValueBuffer("xml", this.iface.xmlGrafico_.toString(4));
	return true;
}

// function oficial_guardarDatosNivelActual():Boolean
// {
// 	if (!this.iface.xmlGrafico_) {
// 		if (!this.iface.establecerValoresDefecto()) {
// 			return false;
// 		}
// 	}
// 	var cursor:FLSqlCursor = this.cursor();
// 	var eGrafico:FLDomElement = this.iface.xmlGrafico_.firstChild().toElement();
// 	var eEstiloDetalle:FLDomElement = flgraficos.iface.pub_dameElementoXML(eGrafico, "Levels/Level[@Id=" + this.iface.nivelActual_.toString() + "]");
// 	if (!eEstiloDetalle) {
// 		eEstiloDetalle = this.iface.crearNivelGrafico(this.iface.nivelActual_);
// 		if (!eEstiloDetalle) {
// 			return false;
// 		}
// 	}
// 	eEstiloDetalle.setAttribute("AltoNivel", cursor.isNull("altonivel") ? "" : cursor.valueBuffer("altonivel"));
// 	eEstiloDetalle.setAttribute("SangriaNivel", cursor.isNull("sangrianivel") ? "" : cursor.valueBuffer("sangrianivel"));
// 	eEstiloDetalle.setAttribute("MostrarPie", cursor.valueBuffer("mostrarpienivel") ? "true" : "false");
// 	eEstiloDetalle.setAttribute("NegritaPie", this.child("tbnNegritaPie").on ? "true" : "false");
// 
// 	cursor.setValueBuffer("xml", this.iface.xmlGrafico_.toString(4));
// 	return true;
// }

function oficial_guardarDatosCabeceraPagina():Boolean
{
	if (!this.iface.xmlGrafico_) {
		if (!this.iface.establecerValoresDefecto()) {
			return false;
		}
	}
	var cursor:FLSqlCursor = this.cursor();
	var eGrafico:FLDomElement = this.iface.xmlGrafico_.firstChild().toElement();
	var eEstiloPagina:FLDomElement = eGrafico.namedItem(eGrafico, "PageHeader");
	if (!eEstiloDetalle) {
		eEstiloDetalle = this.iface.crearNivelGrafico(this.iface.nivelActual_);
		if (!eEstiloDetalle) {
			return false;
		}
	}
	eEstiloDetalle.setAttribute("AltoNivel", cursor.isNull("altonivel") ? "" : cursor.valueBuffer("altonivel"));
	eEstiloDetalle.setAttribute("SangriaNivel", cursor.isNull("sangrianivel") ? "" : cursor.valueBuffer("sangrianivel"));
	eEstiloDetalle.setAttribute("MostrarPie", cursor.valueBuffer("mostrarpienivel") ? "true" : "false");
	eEstiloDetalle.setAttribute("NegritaPie", this.child("tbnNegritaPie").on ? "true" : "false");

	cursor.setValueBuffer("xml", this.iface.xmlGrafico_.toString(4));
	return true;
}

// function oficial_guardarDatosCampoActual():Boolean
// {
// 	if (!this.iface.xmlGrafico_) {
// 		if (!this.iface.establecerValoresDefecto()) {
// 			return false;
// 		}
// 	}
// 	var cursor:FLSqlCursor = this.cursor();
// 	var eGrafico:FLDomElement = this.iface.xmlGrafico_.firstChild().toElement();
// 	var eEstiloCampo:FLDomElement = flgraficos.iface.pub_dameElementoXML(eGrafico, "Fields/Field[@Id=" + this.iface.campoActual_ + "]");
// 	if (!eEstiloCampo) {
// 		eEstiloCampo = this.iface.crearCampoGrafico(this.iface.campoActual_);
// 		if (!eEstiloCampo) {
// 			return false;
// 		}
// 	}
// 	eEstiloCampo.setAttribute("BordeCampo", cursor.valueBuffer("bordecampo"));
// 	eEstiloCampo.setAttribute("AltoCampo", cursor.isNull("altocampo") ? "" : cursor.valueBuffer("altocampo"));
// 	eEstiloCampo.setAttribute("AnchoCampo", cursor.isNull("anchocampo") ? "" : cursor.valueBuffer("anchocampo"));
// 	eEstiloCampo.setAttribute("Precision", cursor.isNull("precision") ? "" : cursor.valueBuffer("precision"));
// 	
// 
// 	cursor.setValueBuffer("xml", this.iface.xmlGrafico_.toString(4));
// 	return true;
// }

// function oficial_tbnNegritaPie_clicked()
// {
// 	
// }
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

