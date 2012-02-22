/***************************************************************************
                 se_subproyectos.qs  -  description
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
	function calculateField(fN:String):String { return this.ctx.interna_calculateField(fN); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var tdbIncidencias:FLTableDB;
	var cliente:String;
	var rutaMantVer:String;
	var rutaSer:String;
	var proceso:FLProcess;
    function oficial( context ) { interna( context ); } 
	function bufferChanged(fN:String) {	return this.ctx.oficial_bufferChanged(fN); }
    function responderMail() { return this.ctx.oficial_responderMail(); }
	function establecerDirectorio() { return this.ctx.oficial_establecerDirectorio() ; }
	function actualizarLista() { return this.ctx.oficial_actualizarLista() ;}
	function controlEstadoPresupuesto() { return this.ctx.oficial_controlEstadoPresupuesto(); }
	function generarPresupuesto() { return this.ctx.oficial_generarPresupuesto(); }
	function presupuestoCreado() { return this.ctx.oficial_presupuestoCreado();}
	function crearPDFpresupuesto(idPresupuesto) { return this.ctx.oficial_crearPDFpresupuesto(idPresupuesto); }
	function verPDFpresupuesto() { return this.ctx.oficial_verPDFpresupuesto();}
	function abrirExplorador() { return this.ctx.oficial_abrirExplorador();}
	function filtrarIncidencias() {	return this.ctx.oficial_filtrarIncidencias(); }
	function enviarNotificacion() {	return this.ctx.oficial_enviarNotificacion(); }
	function enviarNotificacionInc() {	return this.ctx.oficial_enviarNotificacionInc(); }
	function filtrarContactos() {
		return this.ctx.oficial_filtrarContactos();
	}
	function accionesAutomaticas() {
		return this.ctx.oficial_accionesAutomaticas();
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

/** \C
El --codcliente-- se heredará del proyecto al que pertenece el subproyecto

El --codcliente-- estará deshabilitado

El --codproyecto-- estará deshabilitado

Los subproyectos deberán crearse únicamente a partir de un proyecto

El estado del subproyecto será siempre el del último registro del 
histórico

En la pestaña incidencias podemos ver sólo las incedencias pendientes
seleccionando la opción Sólo Pendientes
*/
function interna_init()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	
	this.child("fdbCodCliente").setDisabled(true);
	this.child("fdbCodProyecto").setDisabled(true);
	this.child("fdbDirLocal").setDisabled(true);
	this.child("fdbIdFactura").setDisabled(true);
	this.child("fdbCosteTotal").setDisabled(true);
	this.child("tbwSubproyectos").setTabEnabled("modulos", false);
	
	if (cursor.modeAccess() == cursor.Insert) {
		this.child("fdbCodCliente").setValue(this.iface.calculateField("codcliente"));
		this.child("fdbTextoPresupuesto").setValue("Estimado cliente,\n\nEnviamos adjunto el/los documentos de especificaciones para la personalización de AbanQ solicitada.\n\nEsperando su confirmación, reciba un cordial saludo.");
		this.child("fdbCosteHora").setValue(util.sqlSelect("se_opciones INNER JOIN articulos ON se_opciones.refcostehora = articulos.referencia", "articulos.pvp", "1 = 1", "se_opciones,articulos"));
	}
	this.child("fdbCosteTotal").setValue(this.iface.calculateField("costetotal"));
	
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this.child( "pbExaminar" ), "clicked()", this, "iface.establecerDirectorio" );
	connect(this.child("pbnActualizarLista"), "clicked()", this, "iface.actualizarLista");
	connect(this.child("pbnResponder"), "clicked()", this, "iface.responderMail" );
	connect(this.child("pbnGenerarPresupuesto"), "clicked()", this, "iface.generarPresupuesto");
	connect(this.child("pbnAbrirExplorador"), "clicked()", this, "iface.abrirExplorador");
	connect(this.child("pbnVerPDFpresupuesto"), "clicked()", this, "iface.verPDFpresupuesto");
	connect(this.child("pbnEnviarNotificacion"), "clicked()", this, "iface.enviarNotificacion");
	connect(this.child("pbnEnviarNotificacionInc"), "clicked()", this, "iface.enviarNotificacionInc");
	connect(this.child("chkPendientes"), "clicked()", this, "iface.filtrarIncidencias");
	connect(this, "formReady()", this, "iface.accionesAutomaticas");
		
	this.iface.rutaMantVer = util.readSettingEntry("scripts/flservppal/dirMantVer");
	this.child("lblDirMantver").text = this.iface.rutaMantVer;
	this.child("chkPendientes").checked = true;
	this.iface.filtrarIncidencias();
	this.iface.filtrarContactos();
	this.iface.controlEstadoPresupuesto();

	var datosGD:Array;
	datosGD["txtRaiz"] = cursor.valueBuffer("codigo") + ": " + cursor.valueBuffer("descripcion");
	datosGD["tipoRaiz"] = "se_subproyectos";
	datosGD["idRaiz"] = cursor.valueBuffer("codigo");
	flcolagedo.iface.pub_gestionDocumentalOn(this, datosGD);
}

function interna_calculateField(fN:String):String
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var valor:String;
	
	switch(fN) {
		/** \C
		El --codcliente-- se heredará del proyecto al que pertenece el subproyecto
		*/
		case "codcliente":
			var codProyecto:String = this.child("fdbCodProyecto").value();
			var codCliente:String;
			valor = util.sqlSelect("se_proyectos", "codcliente", "codigo = '" + codProyecto + "'")
			break;
		
		case "costetotal":
			valor = cursor.valueBuffer("costehora") * cursor.valueBuffer("horas");
			break;
		
		case "costeadelanto":
			valor = 0;
			if (cursor.valueBuffer("pagoadelantado"))
				valor = cursor.valueBuffer("poradelanto") * cursor.valueBuffer("costetotal") / 100;
			break;
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
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	switch (fN) {
		
		case "horas":
		
		/** \C
		El --costetotal-- será el --costehora-- multiplicado por las --horas-- totales
		*/	
		case "costehora": 
			this.child("fdbCosteTotal").setValue(this.iface.calculateField("costetotal"));
		break;
		
		case "poradelanto": 
			this.child("fdbCosteAdelanto").setValue(this.iface.calculateField("costeadelanto"));
		break;
		/** \C
		El --costeadelanto-- será el porcentaje de adelanto del coste total si existe un --pagoadelantado-- y  si no existe
		*/	
		case "pagoadelantado":
			
			if (cursor.valueBuffer("pagoadelantado"))
				this.child("fdbCosteAdelanto").setValue(this.iface.calculateField("costeadelanto"));
			else 
				this.child("fdbCosteAdelanto").setValue(0);
			
			break;
	
		case "idpresupuesto":
			this.iface.controlEstadoPresupuesto();
			break;

		case "codcliente": {
			this.iface.filtrarContactos();
			break;
		}
	}
}
/** \C Establece el directorio de trabajo de los módulos del cliente, de donde se
obtendrán los paquetes para enviar al mismo
\end */
function oficial_establecerDirectorio() 
{
	var util:FLUtil = new FLUtil();	
	
	this.iface.rutaMantVer = util.readSettingEntry("scripts/flservppal/dirMantVer");
	
	if (!this.iface.rutaMantVer) {
		MessageBox.critical(util.translate("scripts", "La ruta a los módulos de mantenimiento de versiones no ha sido establecida"),
		MessageBox.Ok, MessageBox.Cancel, MessageBox.NoButton);
		return false;
	}
	
 	var nuevoDir:String = FileDialog.getExistingDirectory(this.iface.rutaMantVer, util.translate("scripts", "Seleccione directorio"));

	if (nuevoDir) {
		if (!File.isDir(nuevoDir)) {
			MessageBox.critical(util.translate("scripts", "La ruta a los módulos no es correcta:\n") + this.iface.rutaMantVer + nuevoDir,
			MessageBox.Ok, MessageBox.Cancel, MessageBox.NoButton);
			return false;
		} else {
			var dirLocal = new Dir(nuevoDir);
			this.child("fdbDirLocal").setValue(dirLocal.name + "/");
		}
	}
}

/** \D Actualiza la lista de módulos que hay en disco y los introduce en la tabla de datos. 
Hace una pasada por los directorios desde el directorio de los módulos
\end */
function oficial_actualizarLista()
{
	var util:FLUtil = new FLUtil();
	
	if (this.cursor().modeAccess() == this.cursor().Insert) {
		MessageBox.warning(util.translate("scripts","Para generar la lista de módulos guarde el registro y vuelva a abrirlo"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
	
	var rutaModulos:String = this.iface.rutaMantVer + this.child( "fdbDirLocal" ).value() + "modulos/";
	if (!File.exists(rutaModulos))
		rutaModulos = this.iface.rutaMantVer + this.child( "fdbDirLocal" ).value() + "prueba/";
	
	var codSubproyecto:String = this.child("fdbCodSubproyecto").value();
	
	var res = MessageBox.warning( util.translate( "scripts", "La lista de módulos será eliminada antes de regenerarse.\n\n¿Continuar?" ), MessageBox.No, MessageBox.Yes, MessageBox.NoButton );
	if ( res != MessageBox.Yes ) return;
	
	if (!File.isDir(rutaModulos)) {
		MessageBox.critical(util.translate("scripts", "No existe el directorio de módulos"),
					MessageBox.Ok, MessageBox.NoButton,
					MessageBox.NoButton);
		return false;
	}
	
	// borrar la tabla				
	var curModulosSP:FLSqlCursor = new FLSqlCursor("se_modulos");
	curModulosSP.select("codsubproyecto = '" + codSubproyecto + "'");
	while (curModulosSP.next()) {
		curModulosSP.setModeAccess(curModulosSP.Del);
		curModulosSP.refreshBuffer();
		curModulosSP.commitBuffer();
	}
						
	var dirAreas = new Dir(rutaModulos);
	
	var areas = dirAreas.entryList("*", Dir.Dirs);
	var modulos;
	var nomFicheroMod:String;
							
	for (var i = 0; i < areas.length; i++){
		
		if (areas[i] == "." || areas[i] == "..") continue;
		
		var rutaArea:String = rutaModulos + areas[i];
		var dirArea = new Dir(rutaArea);
		
		modulos = dirArea.entryList("*", Dir.Dirs);
		for (var j = 0; j < modulos.length; j++) {
			if (modulos[j] == "." || modulos[j] == ".." || modulos[j].right(4) == ".xml") continue;
			
			try { dirArea.cd(modulos[j]);	}
			catch (e) {	
				MessageBox.critical(this.iface.util.
														translate("scripts", "Se produjo un error al acceder al directorio" +
																rutaArea + modulos[j]),
														MessageBox.Ok, MessageBox.NoButton,
														MessageBox.NoButton);
			}		
			
			nomFicheroMod = dirArea.entryList("*.mod", Dir.Files);
			if (nomFicheroMod.length != 1) {
					dirArea.cdUp();
					continue;
			}
			curModulosSP.setModeAccess(curModulosSP.Insert);
			curModulosSP.refreshBuffer();
			curModulosSP.setValueBuffer("codsubproyecto", codSubproyecto);
			curModulosSP.setValueBuffer("idmodulo", modulos[j]);
			curModulosSP.setValueBuffer("idarea", areas[i]);
			curModulosSP.commitBuffer();
			
			dirArea.cdUp();
		}
  	}
	this.child("tdbModulos").refresh();
}

/** \D Lanza la respuesta a una comunicación seleccionada en el formulario maestro.
El id de dicha comunicacion queda registrado en la variable codigoConResp, y a continuación
se abre el formulario de inserción de una nueva comunicación.
\end */
function oficial_responderMail()
{
	var util:FLUtil = new FLUtil();
	var curCom:FLSqlCursor = this.child("tdbComunicaciones").cursor();	

 	util.writeSettingEntry("scripts/flservppal/codigoComResp", curCom.valueBuffer("codigo"));
	
	this.child("toolButtomInsertCom").animateClick();	
}	


/** \D Cuando el presupuesto ha sido antes generado, los controles del mismo
quedan deshabilitados
\end */
function oficial_controlEstadoPresupuesto()
{
	if (this.child("fdbCodPresupuesto").value()) 
		bloqueo = true;
	else
		bloqueo = false;
	
	this.child("gbxDatosPresupuesto").setDisabled(bloqueo);
}

/** \D Genera un presupuesto en el módulo de facturación tomando el valor
del --costetotal--
\end */
function oficial_generarPresupuesto()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	
	if (!parseInt(cursor.valueBuffer("costetotal"))) {
		MessageBox.warning(util.translate("scripts", "El coste total debe ser mayor que cero"),
		MessageBox.Ok, MessageBox.NoButton);
		return;
	} 
	
	if (!cursor.valueBuffer("textopresupuesto")) {
		MessageBox.warning(util.translate("scripts", "Debes rellenar el texto"),
		MessageBox.Ok, MessageBox.NoButton);
		return;
	} 
	
	var res = MessageBox.warning( util.translate( "scripts", "Se va a generar el presupuesto en el módulo de facturación.\n\n¿Continuar?" ), MessageBox.No, MessageBox.Yes, MessageBox.NoButton );
	if ( res != MessageBox.Yes ) return;
	
	if (util.sqlSelect("presupuestoscli", "codigo", "idpresupuesto = " + cursor.valueBuffer("idpresupuesto"))) {
		MessageBox.warning(util.translate("scripts", "No se puede generar el presupuesto porque ya existe uno asociado a este subproyecto.\nPara crearlo deberá eliminar primero el presupuesto existente"),
		MessageBox.Ok, MessageBox.NoButton);
		return;
	} 
	
	var hoy = new Date();
	var codCliente:String = cursor.valueBuffer("codcliente");
	var costeTotal:String = cursor.valueBuffer("costetotal");
	
	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList("clientes");
	q.setFrom("clientes");
	q.setSelect("nombre,cifnif,coddivisa,codpago,codserie,codagente");
	q.setWhere("codcliente = '" + codCliente + "'");
	
	if (!q.exec()) return;
	if (!q.first()) {
		MessageBox.warning(util.translate("scripts", "Error al obtener los datos del cliente\nNo se generará el presupuesto de este cliente: ") + codCliente,
			MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	
	var qDir:FLSqlQuery = new FLSqlQuery();
	qDir.setTablesList("dirclientes");
	qDir.setFrom("dirclientes");
	qDir.setSelect("id,direccion,codpostal,ciudad,provincia,apartado,codpais");
	qDir.setWhere("codcliente = '" + codCliente + "' and domfacturacion = '" + true + "'");
	
	if (!qDir.exec()) return;
	if (!qDir.first()) {
		MessageBox.warning(util.translate("scripts", "Error al obtener la dirección del cliente\nAsegúrate de que este cliente tiene una dirección de facturación\nNo se generará el presupuesto de este cliente: ") + codCliente,
			MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	
	var curPresupuesto:FLSqlCursor = new FLSqlCursor("presupuestoscli");
	var numeroPresupuesto:Number = flfacturac.iface.pub_siguienteNumero(q.value(4),flfactppal.iface.pub_ejercicioActual(), "npresupuestocli");
	var codEjercicio:String = flfactppal.iface.pub_ejercicioActual();
	var codPresupuesto:String = flfacturac.iface.pub_construirCodigo(q.value(4), codEjercicio, numeroPresupuesto);
	
	with(curPresupuesto) {
		setModeAccess(Insert);
		refreshBuffer();
		
		setValueBuffer("codigo", codPresupuesto);
		setValueBuffer("numero", numeroPresupuesto);
		setValueBuffer("irpf", util.sqlSelect("series", "irpf", "codserie = '" + q.value(4) + "'"));
		setValueBuffer("recfinanciero", 0);
		
		setValueBuffer("codcliente", codCliente);
		setValueBuffer("nombrecliente", q.value(0));
		setValueBuffer("cifnif", q.value(1));
		
		setValueBuffer("codejercicio", codEjercicio);
		setValueBuffer("coddivisa", q.value(2));
		setValueBuffer("codpago", q.value(3));
		setValueBuffer("codalmacen", flfactppal.iface.pub_valorDefectoEmpresa("codalmacen"));
		setValueBuffer("codserie", q.value(4));
		setValueBuffer("tasaconv", util.sqlSelect("divisas", "tasaconv", "coddivisa = '" + q.value(2) + "'"));
		setValueBuffer("fecha", hoy);
		setValueBuffer("fechasalida", hoy);
		
		setValueBuffer("codagente", q.value(5));
		setValueBuffer("porcomision", util.sqlSelect("agentes", "porcomision", "codagente = '" + q.value(5) + "'"));
				
		setValueBuffer("coddir", qDir.value(0));
		setValueBuffer("direccion", qDir.value(1));
		setValueBuffer("codpostal", qDir.value(2));
		setValueBuffer("ciudad", qDir.value(3));
		setValueBuffer("provincia", qDir.value(4));
		setValueBuffer("apartado", qDir.value(5));
		setValueBuffer("codpais", qDir.value(6));
	}
	
	if (!curPresupuesto.commitBuffer()) {
		return false;
	}

	var idPresupuesto:Number = curPresupuesto.valueBuffer("idpresupuesto");
	var curLineaPresupuesto:FLSqlCursor = new FLSqlCursor("lineaspresupuestoscli");

	with(curLineaPresupuesto) {
		setModeAccess(Insert);
		refreshBuffer();
		setValueBuffer("idpresupuesto", idPresupuesto);
		setValueBuffer("referencia", "");
		setValueBuffer("descripcion", "Servicio de personalizaciones sobre AbanQ");
		setValueBuffer("pvpunitario", costeTotal);
		setValueBuffer("pvpsindto", costeTotal);
		setValueBuffer("cantidad", 1);
		setValueBuffer("pvptotal", costeTotal);
		setValueBuffer("codimpuesto", "IVA16");
		setValueBuffer("iva", 16.00);
		setValueBuffer("recargo", 0);
		setValueBuffer("dtolineal", 0);
		setValueBuffer("dtopor", 0);
	}
	if (!curLineaPresupuesto.commitBuffer())
		return false;
		
	curPresupuesto.select("idpresupuesto = " + idPresupuesto);
	if (curPresupuesto.first()) {
		with(curPresupuesto) {
			setModeAccess(Edit);
			refreshBuffer();
			setValueBuffer("netosindtoesp", formpresupuestoscli.iface.pub_commonCalculateField("netosindtoesp", curPresupuesto));
			setValueBuffer("neto", formpresupuestoscli.iface.pub_commonCalculateField("neto", curPresupuesto));
			setValueBuffer("totaliva", formpresupuestoscli.iface.pub_commonCalculateField("totaliva", curPresupuesto));
			setValueBuffer("totalirpf", formpresupuestoscli.iface.pub_commonCalculateField("totalirpf", curPresupuesto));
			setValueBuffer("totalrecargo", formpresupuestoscli.iface.pub_commonCalculateField("totalrecargo", curPresupuesto));
			setValueBuffer("total", formpresupuestoscli.iface.pub_commonCalculateField("total", curPresupuesto));
			setValueBuffer("totaleuros", formpresupuestoscli.iface.pub_commonCalculateField("totaleuros", curPresupuesto));
			setValueBuffer("codigo", formpresupuestoscli.iface.pub_commonCalculateField("codigo", curPresupuesto));
		}
		if (!curPresupuesto.commitBuffer())
			return false;
	}
	
	cursor.setValueBuffer("idpresupuesto", idPresupuesto);
	this.iface.crearPDFpresupuesto(codPresupuesto);return;
	return true;
}

/** \D Filtra las tabla de incidencias por incidencias pendientes de ese subproyecto si está activa la opcion de SóloPendientes, si no lo está la filta mostrando todas las incidencias del subproyecto y refresca la tabla
\end */
function oficial_filtrarIncidencias()
{
	var cursor:FLSqlCursor = this.cursor();

	var filtro:String = "";
	if (this.child("chkPendientes").checked) {
		filtro = "estado = 'Pendiente' AND codsubproyecto = '" + cursor.valueBuffer("codigo") + "'";
	} else {
		filtro = "";
	}
	this.child("tdbIncidencias").cursor().setMainFilter(filtro);
	this.child("tdbIncidencias").refresh();
}


/** \D Crea un fichero PDF en el presupuesto para ser enviado al cliente. El nombre
del fichero es igual al código del presupuesto previamente generado + la extensión '.pdf'
Dicho fichero se guarda en el directorio de documentación del cliente
\end */
function oficial_crearPDFpresupuesto(codPresupuesto)
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();	
	this.iface.rutaSer = util.readSettingEntry("scripts/flservppal/dirServicios");
	var pathLocal = this.iface.rutaMantVer + this.cursor().valueBuffer("dirlocal") + "doc/";	
	
 	var nomCliente:String = util.sqlSelect("clientes", "nombre", "codcliente = '" + cursor.valueBuffer("codcliente") + "'");
 	var fecha = new Date();
	fecha = util.dateAMDtoDMA(fecha);
	
	var datosEmpresa = flfactppal.iface.pub_ejecutarQry("empresa", "nombre,direccion,codpostal,ciudad,provincia,telefono,email", "1 = 1");
	
	var htmlPres:String = "<br><br><img src=\"logo.png\">"; 
	
	htmlPres += "<p>" + datosEmpresa["nombre"] + "<br>" + 
						datosEmpresa["direccion"] + "<br>" + 
						datosEmpresa["codpostal"] + " " + datosEmpresa["ciudad"] + " (" + datosEmpresa["provincia"] + ")<br>" + 
						"Tlf. " + datosEmpresa["telefono"] + "<br>" + 
						"e-mail: " + datosEmpresa["email"];
													
	htmlPres += "<p>Fecha: <b>" + fecha + "</b>";
	htmlPres += "<br>Cliente: <b>" + nomCliente + "</b>";
	htmlPres += "<br>Presupuesto: <b>" + codPresupuesto + "</b>";
		
	htmlPres += "<h1>PRESUPUESTO</h1><hr size=\"1\"><h3>Implementación solicitada:</h3>";
	htmlPres += cursor.valueBuffer("textopresupuesto");	
	
	htmlPres += "<p>&nbsp;<br>&nbsp;<br><h3>TOTAL PRESUPUESTO: " + cursor.valueBuffer("costetotal") + " euros</h3>";
	
	htmlPres += "<p>&nbsp;<br>&nbsp;<br>- IVA no incluido.<br>" + 
				"- Las especificaciones detalladas se envían en documento adjunto.<br>" + 
				"- Este presupuesto es puramente orientativo.<br>" + 
				"- Todo el software aquí detallado es bajo licencia GPL, se entrega todo el código fuente, y se puede usar, copiar, modificar y distribuir libremente."
	
	htmlPres += "<p>&nbsp;<br>&nbsp;<br>&nbsp;<br><center><font size=\"3\">Conforme, el cliente <b>" + nomCliente + "</b></font></center>";
	
	var fichHTML = this.iface.rutaSer + "principal/packets/tmp.html";
	var fichPS = this.iface.rutaSer + "principal/packets/tmp.ps";
	var fichPDF = pathLocal + codPresupuesto + ".pdf";
	var f = new File(fichHTML);
	f.open(File.WriteOnly);
	f.write(htmlPres);
	f.close();

	var comando:String = "html2ps -n -o " + fichPS + " " + fichHTML + ";pstill -c -F a4 -o " + fichPDF + " " + fichPS;
	
	var fichProceso = this.iface.rutaSer + "principal/packets/comando";
	var f = new File(fichProceso);
	f.open(File.WriteOnly);
	f.write(comando);
	f.close();
	
	this.iface.proceso = new FLProcess(fichProceso);
 	connect(this.iface.proceso, "exited()", this, "iface.presupuestoCreado");
   	this.iface.proceso.start();

}

/** \D Muestra un mensaje de información indicando que se creó el presupuesto
\end */
function oficial_presupuestoCreado() 
{
	var util:FLUtil = new FLUtil();
	var codPresupuesto = util.sqlSelect("presupuestoscli", "codigo", "idpresupuesto = " + this.cursor().valueBuffer("idpresupuesto"));
	var nomFichero = this.iface.rutaMantVer + this.cursor().valueBuffer("dirlocal") + "doc/" + codPresupuesto + ".pdf";	
	
	MessageBox.information(util.translate("scripts", "En el módulo de facturación se ha generado el presupuesto ") + codPresupuesto + util.translate("scripts", "\n\nSe ha creado el siguiente documento PDF para el presupuesto:\n") + nomFichero + "\n\n",
			MessageBox.Ok, MessageBox.Cancel, MessageBox.NoButton);
	
}

/** \D Abre una ventana de explorador de ficheros en el directorio de docmentación del cliente
\end */
function oficial_abrirExplorador()
{
	var util:FLUtil = new FLUtil();
 	var explorador:String = util.readSettingEntry("scripts/flservppal/explorador");
	
	var comando = explorador + " " + this.iface.rutaMantVer + this.cursor().valueBuffer("dirlocal") + "doc/";	
				
	try {
		resComando = flservppal.iface.pub_ejecutarComando(comando);
	}
	catch (e) {
		MessageBox.critical(comando + "\n\n" + util.translate("scripts", "Falló la llamada al navegador/explorador.\nDebe especificar una ruta correcta al navegador/explorador en las opciones generales"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
}

/** \D Abre el visor de PDF mostrando el presupuesto en PDF
\end */
function oficial_verPDFpresupuesto()
{
	var util:FLUtil = new FLUtil();
 	var visorPDF:String = util.readSettingEntry("scripts/flservppal/visorpdf");
	
	var codPresupuesto = util.sqlSelect("presupuestoscli", "codigo", "idpresupuesto = " + this.cursor().valueBuffer("idpresupuesto"));
	var nomFichero = this.iface.rutaMantVer + this.cursor().valueBuffer("dirlocal") + "doc/" + codPresupuesto + ".pdf";	
	
	if (!File.exists(nomFichero)) {
		MessageBox.critical(util.translate("scripts", "No existe el fichero del presupuesto: ") + nomFichero, MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	
	var comando = visorPDF + " " + nomFichero;	
				
	try {
		resComando = flservppal.iface.pub_ejecutarComando(comando);
	}
	catch (e) {
		MessageBox.critical(comando + "\n\n" + util.translate("scripts", "Falló la llamada al visor de PDFs.\nDebe especificar una ruta correcta al visor en las opciones generales"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
}

/** \C Abre el formalario de edición de comunicaciones estableciendo unos valores por defecto para notificar que ha cambiado el estado del subproyecto
Comprueba si la comunicación ha sido enviada y si no es así pregunta si queremos guardarla o no
\end */
function oficial_enviarNotificacion()
{
	var util:FLUtil = new FLUtil();
	var fecha:Date = new Date();
	var curHist:FLSqlCursor = this.child("tdbHistorico").cursor();
	if (!curHist.isValid())
		return;
	
	curHist.refreshBuffer();
	if(curHist.valueBuffer("codcomunicacion")){
		var res = MessageBox.warning( util.translate( "scripts", "El historico seleccionado ya tiene una comunicación asociada ¿Desea sustituirla?" ), MessageBox.No, MessageBox.Yes, MessageBox.NoButton );
		if ( res != MessageBox.Yes ) 
			return;
		util.sqlDelete("se_comunicaciones","codigo = '" + curHist.valueBuffer("codcomunicacion") + "'");
	}
		
	var curComunicacion:FLSqlCursor = new FLSqlCursor("se_comunicaciones");
	
	curComunicacion.setModeAccess(curComunicacion.Insert);
	curComunicacion.refreshBuffer();
	curComunicacion.setValueBuffer("asunto","Cambio del estado del subproyecto " + this.cursor().valueBuffer("codigo") + " " + this.cursor().valueBuffer("descripcion"));
	curComunicacion.setValueBuffer("texto", "Su subproyecto " + this.cursor().valueBuffer("codigo") + " " + this.cursor().valueBuffer("descripcion") + " ha pasado a estado " + this.cursor().valueBuffer("estado") + " con fecha " + util.dateAMDtoDMA(curHist.valueBuffer("fecha")));
	var codigo:String = util.nextCounter("codigo", curComunicacion);
	curComunicacion.setValueBuffer("codigo",codigo);
	curComunicacion.setValueBuffer("fecha",fecha);
	curComunicacion.setValueBuffer("fechahora",fecha);
	curComunicacion.setValueBuffer("enviadopor",util.sqlSelect("se_usuarios","email","codigo = '" + this.cursor().valueBuffer("codencargado") + "'"));
	curComunicacion.setValueBuffer("para",util.sqlSelect("clientes","email","codcliente = '" + this.cursor().valueBuffer("codcliente") + "'"));
	curComunicacion.setValueBuffer("hora",fecha.toString().substring(11,16));
	curComunicacion.setValueBuffer("codcliente",this.cursor().valueBuffer("codcliente"));
	curComunicacion.setValueBuffer("codsubproyecto",this.cursor().valueBuffer("codigo"));
	if(!curComunicacion.commitBuffer())
		return false;
	
	this.child("tdbComunicaciones").cursor().refresh();
	
	if (!util.sqlUpdate("se_historicos", "codcomunicacion", codigo, "id = " + curHist.valueBuffer("id")))
		return false;
	
	var curCom2:FLSqlCursor = this.child("tdbComunicaciones").cursor();
	curCom2.select("codigo = '" + codigo + "'");
	if(!curCom2.first())
		return false;
		
	curCom2.editRecord();
}


/** \C Abre el formalario de edición de comunicaciones estableciendo unos valores por defecto para notificar el estado de las incidencias
Comprueba si la comunicación ha sido enviada y si no es así pregunta si queremos guardarla o no
\end */
function oficial_enviarNotificacionInc()
{
	var util:FLUtil = new FLUtil();
	var fecha:Date = new Date();
	var curInc:FLSqlCursor = this.child("tdbIncidencias").cursor();
	if (!curInc.isValid())
		return;
		
	var curComunicacion:FLSqlCursor = new FLSqlCursor("se_comunicaciones");
	
	curComunicacion.setModeAccess(curComunicacion.Insert);
	curComunicacion.refreshBuffer();
	var asunto:String;
	var texto:String;
	if(curInc.valueBuffer("estado") == "Pendiente"){
		asunto = "Creación de la incidencia " + curInc.valueBuffer("codigo") + " " + curInc.valueBuffer("desccorta") + " del subproyecto " + this.cursor().valueBuffer("codigo");
		texto = "Hemos creado una incidencia de tipo " + curInc.valueBuffer("tipo") + " para el subproyecto " + this.cursor().valueBuffer("codigo") + " con fecha " + util.dateAMDtoDMA(curInc.valueBuffer("fechaapertura")) + " (" + curInc.valueBuffer("codigo") + " " + curInc.valueBuffer("desccorta") + ")\n\n Descripción:\n\n" + curInc.valueBuffer("descripcion");
	} else { 
		asunto = "Resolución de la incidencia " + curInc.valueBuffer("codigo") + " " + curInc.valueBuffer("desccorta") + " del subproyecto " + this.cursor().valueBuffer("codigo");
		texto = "Hemos resuelto la incidencia " + curInc.valueBuffer("codigo") + " " + curInc.valueBuffer("desccorta") + " del subproyecto " + this.cursor().valueBuffer("codigo") + " con fecha " + util.dateAMDtoDMA(curInc.valueBuffer("fechacierre"));
	}
	
	curComunicacion.setValueBuffer("asunto",asunto);
	curComunicacion.setValueBuffer("texto",texto);
	var codigo:String = util.nextCounter("codigo", curComunicacion);
	curComunicacion.setValueBuffer("codigo",codigo);
	curComunicacion.setValueBuffer("fecha",fecha);
	curComunicacion.setValueBuffer("fechahora",fecha);
	curComunicacion.setValueBuffer("enviadopor",util.sqlSelect("se_usuarios","email","codigo = '" + this.cursor().valueBuffer("codencargado") + "'"));
	curComunicacion.setValueBuffer("para",util.sqlSelect("clientes","email","codcliente = '" + this.cursor().valueBuffer("codcliente") + "'"));
	curComunicacion.setValueBuffer("hora",fecha.toString().substring(11,16));
	curComunicacion.setValueBuffer("codcliente",this.cursor().valueBuffer("codcliente"));
	curComunicacion.setValueBuffer("codsubproyecto",this.cursor().valueBuffer("codigo"));
	curComunicacion.setValueBuffer("codincidencia",curInc.valueBuffer("codigo"));
	if(!curComunicacion.commitBuffer())
		return false;
	
	this.child("tdbComunicaciones").cursor().refresh();
	
	var curCom2:FLSqlCursor = this.child("tdbComunicaciones").cursor();
	curCom2.select("codigo = '" + codigo + "'");
	if(!curCom2.first())
		return false;

	curCom2.editRecord(); 
}

function oficial_filtrarContactos()
{
	var cursor:FLSqlCursor = this.cursor();
	var codCliente:String = cursor.valueBuffer("codcliente");
	var filtro:String = "";
	if (codCliente && codCliente != "") {
		filtro = "codcontacto IN (SELECT codcontacto FROM contactosclientes WHERE codcliente = '" + codCliente + "')";
	}
	this.child("fdbCodContacto").setFilter(filtro); 
}

function oficial_accionesAutomaticas()
{
	var acciones:Array = flcolaproc.iface.pub_accionesAuto();
	if (!acciones) {
		return;
	}
	var i:Number = 0;
	while (i < acciones.length && acciones[i]["usada"]) { i++; }
	if (i == acciones.length) {
		return;
	}
	while (acciones[i]["contexto"] == "se_subproyectos") {
		switch (acciones[i]["accion"]) {
			case "insertar_comunicacion": {
				acciones[i]["usada"] = true;
				var curComunicaciones:FLSqlCursor = this.child("tdbComunicaciones").cursor();
				curComunicaciones.insertRecord();
				break;
			}
			case "insertar_incidencia": {
				acciones[i]["usada"] = true;
				var curIncidencias:FLSqlCursor = this.child("tdbIncidencias").cursor();
				curIncidencias.insertRecord();
				break;
			}
			default: {
				return;
			}
		}
		i++;
	}
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
