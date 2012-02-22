/***************************************************************************
                 se_masterconvertirinformes.qs  -  description
                             -------------------
    begin                : lun jun 20 2005
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
class oficial extends interna 
{
	var chkYo:Object;
	var tableDBRecords:Object;
    function oficial( context ) { interna( context ); } 
	function filtroInformes() {
		return this.ctx.oficial_filtroInformes();
	}
	function convertirInforme() {
		return this.ctx.oficial_convertirInforme();
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

	this.iface.chkYo = this.child("chkYo");
	this.iface.tableDBRecords = this.child("tableDBRecords")

	connect(this.iface.chkYo, "clicked()", this, "iface.filtroInformes");
	connect(this.child("tbnConvertir"), "clicked()", this, "iface.convertirInforme");
	
	this.iface.chkYo.checked = true;
	this.iface.filtroInformes();
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_filtroInformes():String
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var filtro:String;
	if (this.iface.chkYo.checked) {
		var codUsuario = util.readSettingEntry("scripts/flservppal/codusuario");
		if (!codUsuario) {
			MessageBox.information( util.translate( "scripts", "No se ha definido usuario actual"), MessageBox.Ok, MessageBox.NoButton);
			return;
		}
		if (filtro != "") {
			filtro += " AND ";
		}
		filtro += " codusuario = '" + codUsuario + "'";
	}

	cursor.setMainFilter(filtro);
	this.iface.tableDBRecords.refresh();
}

function oficial_convertirInforme()
{
// 	origen = "/home/jrodriguez/funcional/fun_barnasfalt/nuevo/facturacion/informes/reports/i_albaranescert.qt4.ui";
// 	destino = "/home/jrodriguez/funcional/fun_barnasfalt/nuevo/facturacion/informes/reports/i_albaranescert.kut";

	var cursor:FLSqlCursor = this.cursor();
	if (!cursor.isValid())
		return;

	this.child("leInfo").text = "convirtiendo...";

	origen = cursor.valueBuffer("origen");
	destino = cursor.valueBuffer("destino");

 	contenido = File.read(origen);
	documento = new FLDomDocument();
	documento.setContent(contenido);

	espacio = new RegExp( " " );
	espacio.global = true;
	util = new FLUtil();	
	
 	listaNodosInit = documento.elementsByTagName("widget");

	xmlReport = "";
	encabezadoXmlReport = "<?xml version = '1.0' encoding = 'UTF-8'?>";
	encabezadoXmlReport += "\n" + "<!DOCTYPE KugarTemplate SYSTEM \"kugartemplate.dtd\">";
	encabezadoXmlReport += "\n" + "<KugarTemplate ";

	for(i = 0; i < listaNodosInit.length(); i++) {
		nodo = listaNodosInit.item(i);
		switch(nodo.attributeValue("class")) {
			case "repParametros":
			case "rpDetailHeader":
			case "rpAddOnHeader":
			case "rpDetail":
			case "repDetail":
			case "rpDetailFooter":
			case "rpAddOnFooter":
			
			xmlReport += "\n\n";

				switch(nodo.attributeValue("class")) {

					case "rpDetailHeader":
						xmlReport += "<DetailHeader";
					break;
					case "rpAddOnHeader":
						xmlReport += "<AddOnHeader";
					break;
					case "rpDetail":
					case "repDetail":
						xmlReport += "<Detail";
					break;
					case "rpDetailFooter":
						xmlReport += "<DetailFooter";
					break;
					case "rpAddOnFooter":
						xmlReport += "<AddOnFooter";
					break;
				}
				
				innerDetail = "";
				
				listaNodos = nodo.childNodes();
				for(j = 0; j < listaNodos.length(); j++) {
					
					nodo2 = listaNodos.item(j);
					switch(nodo2.attributeValue("name")) {

						case "Level":
						case "Rows":
						case "Cols":
						case "PlaceAtBottom":
						case "NewPage":
							xmlReport += " " + nodo2.attributeValue("name") + "=\"" + nodo2.firstChild().toElement().text() + "\"";
						break;

						case "geometry":
							listaNodos2 = nodo2.firstChild().childNodes();
							for(l = 0; l < listaNodos2.length(); l++) {
								nodo3 = listaNodos2.item(l);
								switch(nodo3.nodeName()) {
									case "height":
										//xmlReport += " Height=\"" + nodo3.toElement().text() + "\"";
										sectionHeight = nodo3.toElement().text();
									break;
								}			
							}
						break;

						case "heightZero":
							debug(nodo2.firstChild().toElement().text())
							if (nodo2.firstChild().toElement().text() == "true")
								sectionHeight = 0;
						break;
					}
				
					switch(nodo2.attributeValue("class")) {
						case "rpField":
						case "rpCalculatedField":
						case "rpSpecial":
						case "QLabel":

							backgroundColorSet = false;
							foregroundColorSet = false;
                            
							switch(nodo2.attributeValue("class")) {
							  case "rpField":
								xmlField = "\n" + "<Field ";
							  break;
							  case "rpCalculatedField":
								xmlField = "\n" + "<CalculatedField ";
							  break;
							  case "rpSpecial":
								xmlField = "\n" + "<Special ";
							  break;
							  default:
								xmlField = "\n" + "<Label ";
							  break;
							}
					
							listaNodos2 = nodo2.childNodes();
							for(k = 0; k < listaNodos2.length(); k++) {
								nodo3 = listaNodos2.item(k);
debug(nodo3.attributeValue("name"))
								switch(nodo3.attributeValue("name")) {
									
									case "name":
									case "palette":
									case "frameShadow":
									case "autoFillBackground":
									break;
						
									case "geometry":
										listaNodos3 = nodo3.firstChild().childNodes();
										for(l = 0; l < listaNodos3.length(); l++) {
											nodo4 = listaNodos3.item(l);
											switch(nodo4.nodeName()) {
												case "x":
													xmlField += " X=\"" + nodo4.toElement().text() + "\"";
												break;
												case "y":
													xmlField += " Y=\"" + nodo4.toElement().text() + "\"";
												break;
												case "width":
													xmlField += " Width=\"" + nodo4.toElement().text() + "\"";
												break;
												case "height":
 													xmlField += " Height=\"" + nodo4.toElement().text() + "\"";
												break;
											}			
										}
									break;
									
									
									case "styleSheet":
									
										estilos = nodo3.toElement().text();
										arrayEstilos = estilos.split(";")
										for(iE = 0; iE < arrayEstilos.length; iE++) {
											estilo = arrayEstilos[iE];
											if (estilo.search("background-color") > -1) {
												// background-color: rgb(195, 195, 195);	
 												color = estilo.substring(estilo.search("(") + 1, estilo.search(")"));
												color = color.replace( espacio, "" );
												xmlField += " BackgroundColor = \"" + color + "\"";
												backgroundColorSet = true;
											}
											if (estilo.search("border-color") > -1) {
												// background-color: rgb(195, 195, 195);	
 												color = estilo.substring(estilo.search("(") + 1, estilo.search(")"));
												color = color.replace( espacio, "" );
												xmlField += " BorderColor = \"" + color + "\"";
												xmlField += " BorderStyle =\"1\"";
												backgroundColorSet = true;
											}
											if (estilo.search("color") > -1 && estilo.search("color") < 2) {
												// color: rgb(195, 195, 195);	
 												color = estilo.substring(estilo.search("(") + 1, estilo.search(")"));
												color = color.replace( espacio, "" );
												xmlField += " ForegroundColor = \"" + color + "\"";
												foregroundColorSet = true;
											}
										}
										
									break;
									
									case "text":
										xmlField += " Text =\"" + nodo3.firstChild().toElement().text() + "\"";
									break;
						
									case "FunName":
									case "FN":
										xmlField += " FunctionName =\"" + nodo3.firstChild().toElement().text() + "\"";
									break;
						
									case "wordWrap":
		                               if (nodo3.firstChild().toElement().text() == "true")
										xmlField += " WordWrap =\"1\"";
										else  
										xmlField += " WordWrap =\"0\"";
									break;

									case "alignment":
		                                alignment = nodo3.firstChild().toElement().text();

										if (alignment.search("AlignCenter") > -1) {
											xmlField += " HAlignment=\"1\"";
											xmlField += " VAlignment=\"1\"";
										}

										if (alignment.search("AlignHCenter") > -1)
  											xmlField += " HAlignment=\"1\"";
										if (alignment.search("AlignLeft") > -1)
  											xmlField += " HAlignment=\"0\"";
										if (alignment.search("AlignRight") > -1)
  											xmlField += " HAlignment=\"2\"";

										if (alignment.search("AlignVCenter") > -1)
  											xmlField += " VAlignment=\"1\"";
										if (alignment.search("AlignTop") > -1)
  											xmlField += " VAlignment=\"0\"";
										if (alignment.search("AlignBottom") > -1)
  											xmlField += " VAlignment=\"2\"";

									break;
						
									case "font":
										listaNodos3 = nodo3.firstChild().childNodes();
										if (!listaNodos3) {
											MessageBox.information( util.translate( "scripts", "Algunos de los campos del informe no tienen correctamente establecida la fuente (tipo de letra)"), MessageBox.Ok, MessageBox.NoButton);
											return;
										}
										for (l = 0; l < listaNodos3.length(); l++) {
											nodo4 = listaNodos3.item(l);
											switch(nodo4.nodeName()) {
												
												case "family":
													xmlField += " FontFamily=\""+ nodo4.toElement().text() + "\"";
												break;
												
												case "pointsize":
													xmlField += " FontSize=\""+ nodo4.toElement().text() + "\"";
												break;
												
												case "bold":
													if (nodo4.toElement().text() == "true")
														xmlField += " FontWeight=\"65\"";
													else
														xmlField += " FontWeight=\"50\"";
												break;
												
												case "italic":
													if (nodo4.toElement().text() == "1")
														xmlField += " FontItalic=\"1\"";
												break;
 											}
										}
										
									break;

									default:
										xmlField += " " + nodo3.attributeValue("name") + "=\"" + nodo3.firstChild().toElement().text() + "\"";
									break;
								}
							}
						
							if (!backgroundColorSet)
								xmlField += " BackgroundColor=\"255,255,255\"";
							if (!foregroundColorSet)
								xmlField += " ForegroundColor=\"0,0,0\"";

							xmlField += "/>";
							innerDetail += xmlField;
						
						break;


						case "rpBox":

							xmlField = "\n" + "<Line Style=\"1\"";
							colorSet = false;
							widthSet = false;

							red="0";green="0";blue="0";
					
							listaNodos2 = nodo2.childNodes();
							for(k = 0; k < listaNodos2.length(); k++) {
								nodo3 = listaNodos2.item(k);
								switch(nodo3.attributeValue("name")) {
									case "geometry":
										listaNodos3 = nodo3.firstChild().childNodes();
										for (l = 0; l < listaNodos3.length(); l++) {
											nodo4 = listaNodos3.item(l);

											switch(nodo4.nodeName()) {
												
												case "x":
													x1 = parseFloat(nodo4.toElement().text());
												break;
												
												case "y":
													y1 = parseFloat(nodo4.toElement().text());
												break;
												
												case "width":
													x2 = x1 + parseFloat(nodo4.toElement().text()) - 1;
												break;
												
												case "height":
													y2 = y1 + parseFloat(nodo4.toElement().text());
												break;
												
											}
										}

									break;
									
									case "BorderColor":
									
										xmlField += " " + nodo3.attributeValue("name") + "=\"";

										if (nodo3.attributeValue("name") == "BackgroundColor")
											backgroundColorSet = true;
										else
											foregroundColorSet = true;
										
										listaNodos3 = nodo3.firstChild().childNodes();
										for(l = 0; l < listaNodos3.length(); l++) {
											nodo4 = listaNodos3.item(l);
											switch(nodo4.nodeName()) {
												case "red":
													red = nodo4.toElement().text();
												break;
												case "green":
													green = nodo4.toElement().text();
												break;
												case "blue":
													blue = nodo4.toElement().text();
												break;
											}
										}
										xmlField += "\"";
										
									break;
								}
							}

							innerDetail += "\n" + "<Line Style=\"1\" X1=\"" + x1 + "\" Y1=\"" + y1 + "\" X2=\"" + x2 + "\" Y2=\"" + y1 + "\" Color=\"" + red + "," + green + "," + blue + "\" Width=\"1\"/>";
							innerDetail += "\n" + "<Line Style=\"1\" X1=\"" + x1 + "\" Y1=\"" + y2 + "\" X2=\"" + x2 + "\" Y2=\"" + y2 + "\" Color=\"" + red + "," + green + "," + blue + "\" Width=\"1\"/>";
							innerDetail += "\n" + "<Line Style=\"1\" X1=\"" + x1 + "\" Y1=\"" + y1 + "\" X2=\"" + x1 + "\" Y2=\"" + y2 + "\" Color=\"" + red + "," + green + "," + blue + "\" Width=\"1\"/>";
							innerDetail += "\n" + "<Line Style=\"1\" X1=\"" + x2 + "\" Y1=\"" + y1 + "\" X2=\"" + x2 + "\" Y2=\"" + y2 + "\" Color=\"" + red + "," + green + "," + blue + "\" Width=\"1\"/>";
						
						break;


						case "Line":

							xmlField = "\n" + "<Line Style=\"1\"";
							colorSet = false;
							widthSet = false;
					
							listaNodos2 = nodo2.childNodes();
							for(k = 0; k < listaNodos2.length(); k++) {
								nodo3 = listaNodos2.item(k);
								switch(nodo3.attributeValue("name")) {
									case "geometry":
										listaNodos3 = nodo3.firstChild().childNodes();
										for (l = 0; l < listaNodos3.length(); l++) {
											nodo4 = listaNodos3.item(l);

											switch(nodo4.nodeName()) {
												
												case "x":
													x1 = parseFloat(nodo4.toElement().text());
													xmlField += " X1=\""+ nodo4.toElement().text() + "\"";
												break;
												
												case "y":
													y1 = parseFloat(nodo4.toElement().text());
													xmlField += " Y1=\""+ nodo4.toElement().text() + "\"";
												break;
												
												case "width":
													lineWidth = parseFloat(nodo4.toElement().text());
												break;
												
												case "height":
													lineHeight = parseFloat(nodo4.toElement().text());
												break;
												
											}
										}

										if (lineWidth > lineHeight) {
										  xmlField += " X2=\"" + parseFloat(x1 + lineWidth) + "\"";
										  xmlField += " Y2=\"" + y1 + "\"";
										}
										else {
										  xmlField += " X2=\"" + x1 + "\"";
										  xmlField += " Y2=\"" + parseFloat(y1 + lineHeight) + "\"";
										}
										
									break;
									
									case "Color":

										xmlField += " Color=\"";
										listaNodos3 = nodo3.firstChild().childNodes();
										for(l = 0; l < listaNodos3.length(); l++) {
											nodo4 = listaNodos3.item(l);
											switch(nodo4.nodeName()) {
												case "red":
												case "green":
													xmlField += nodo4.toElement().text();
													xmlField += ",";
												break;
												
												case "blue":
													xmlField += nodo4.toElement().text();
												break;
											}
										}
										xmlField += "\"";
										colorSet = true;	
										
									break;
									
									case "lineWidth":
										xmlField += " Width=\"" + nodo3.firstChild().toElement().text() + "\"";
										widthSet = true;	
									break;
								}
							}

							if (!colorSet)
								xmlField += " Color=\"0,0,0\"";
							if (!widthSet)
								xmlField += " Width=\"1\"";
						
							xmlField += "/>";
							innerDetail += xmlField;
						
						break;
					}
				}

				xmlReport += " Height=\"" + sectionHeight + "\"";

				switch(nodo.attributeValue("class")) {
					case "rpDetailHeader":
						xmlReport += ">" + innerDetail + "\n" + "</DetailHeader>";
					break;
					case "rpAddOnHeader":
						xmlReport += ">" + innerDetail + "\n" + "</AddOnHeader>";
					break;
					case "rpDetail":
					case "repDetail":
						xmlReport += ">" + innerDetail + "\n" + "</Detail>";
					break;
					case "rpDetailFooter":
						xmlReport += ">" + innerDetail + "\n" + "</DetailFooter>";
					break;
					case "rpAddOnFooter":
						xmlReport += ">" + innerDetail + "\n" + "</AddOnFooter>";
					break;
				}
	
			break;

			case "rpParamGroup":
				//debug("PG")
				listaNodos = nodo.childNodes();
				parametro = "";
				valor = "";
				for(j = 0; j < listaNodos.length(); j++) {

					nodo2 = listaNodos.item(j);
					if (nodo2.attributeValue("class") != "rpParameter")
						continue;

					listaNodos2 = nodo2.childNodes();
					for(k = 0; k < listaNodos2.length(); k++) {
						nodo3 = listaNodos2.item(k);
						if (nodo3.attributeValue("name") == "Parametro")
							parametro = nodo3.firstChild().toElement().text();
						if (nodo3.attributeValue("name") == "Valor")
							valor = nodo3.firstChild().toElement().text();
					}
					if (parametro && valor)
						encabezadoXmlReport += parametro + "=\"" + valor + "\" "
					debug(encabezadoXmlReport)
				}
			break;
		}
		
	}
	
	encabezadoXmlReport += ">";
	xmlReport = encabezadoXmlReport + xmlReport;
	xmlReport += "\n" + "</KugarTemplate>";
	
	File.write(destino, xmlReport);

	this.child("leInfo").text = "convertido";
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
