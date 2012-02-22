/***************************************************************************
                 se_pactualizacion.qs  -  description
                             -------------------
    begin                : lun jun 21 2005
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
	function validateForm():Boolean{ return this.ctx.interna_validateForm(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var rutaMantVer:String;
	var tipoContrato:String;
    function oficial( context ) { interna( context ); } 
	function bufferChanged(fN:String) {	return this.ctx.oficial_bufferChanged(fN); }
	function establecerDirectorio() { return this.ctx.oficial_establecerDirectorio() ; }
	function actualizarLista() { return this.ctx.oficial_actualizarLista() ;}
	function actualizarIncidencias() { return this.ctx.oficial_actualizarIncidencias() ;}
    function responderMail() { return this.ctx.oficial_responderMail(); }
	function cambioChkPendientes() {	return this.ctx.oficial_cambioChkPendientes(); }
    function comprobarFactura() { return this.ctx.oficial_comprobarFactura(); }
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
	function pub_actualizarIncidencias() { return this.actualizarIncidencias() ;}
}

const iface = new ifaceCtx( this );
//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition interna */
/////////////////////////////////////////////////////////////////
//// DEFINICION /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////

/** \C

La --fechainicio-- para un nuevo período de actualización se calculará como el
primer dia del mes siguiente a la --fechafin-- del periodo inmediatamente anterior
del mismo contrato de mantenimiento

La --fechafin-- para un nuevo período de actualización se calculará como el ultimo día
del mes correspondiente a la --fechainicio--

Los campos --dirlocal--, --facturado--, --codcontrato-- y --codcliente-- están 
deshabilitados

El campo --coste-- para los periodos de actualización de contratos de tipo Basico se calculará
automáticamente como el coste establecido para el tipo de contrato dividido entre los meses de duración
\end */
function interna_init()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	this.iface.tipoContrato = util.sqlSelect("se_contratosman","tipocontrato","codigo = '" + cursor.valueBuffer("codcontrato") + "'");
	
	this.child("fdbDirLocal").setDisabled(true);
	this.child("fdbFacturado").setDisabled(true);
	this.child("fdbCodContrato").setDisabled(true);
	this.child("fdbCodCliente").setDisabled(true);
	

	if (cursor.modeAccess() == cursor.Insert) {
		this.child("fdbCodCliente").setValue(this.iface.calculateField("codcliente"));
		cursor.setValueBuffer("nomcliente", this.iface.calculateField("nomcliente"));
		this.child("fdbFechaInicio").setValue(this.iface.calculateField("fechainicio"));
		this.child("fdbFechaFin").setValue(this.iface.calculateField("fechafin"));
		this.child("fdbDirLocal").setValue(this.iface.calculateField("dirlocal"));
		this.child("fdbPesoParche").setValue(this.iface.calculateField("pesoparche"));
		this.child("fdbCoste").setValue(this.iface.calculateField("coste"));
		this.child("fdbTotalIncidencias").setValue(this.iface.calculateField("totalincidencias"));
		
		
		if(this.iface.tipoContrato == "Basico"){
			this.child("fdbPesoParche").setDisabled(true);
			var coste:Number = util.sqlSelect("se_tiposcontrato","coste","nombre = '" + this.iface.tipoContrato + "'");
			var periodo:String = util.sqlSelect("se_tiposcontrato","periodopago","nombre = '" + this.iface.tipoContrato + "'");
			switch(periodo){
				case "Mensual":{
					cursor.setValueBuffer("coste",coste);
					break;
				}
				case "Bimestral":{
					cursor.setValueBuffer("coste",coste/2);
					break;
				}
				case "Trimestral":{
					cursor.setValueBuffer("coste",coste/3);
					break;
				}
				case "Semestral":{
					cursor.setValueBuffer("coste",coste/6);
					break;
				}
				case "Anual":{
					cursor.setValueBuffer("coste",coste/12);
					break;
				}
			}
		}
	}
	
	this.iface.actualizarIncidencias();

	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this.child( "pbExaminar" ), "clicked()", this, "iface.establecerDirectorio" );
	connect(this.child("pbnActualizarLista"), "clicked()", this, "iface.actualizarLista");
	connect(this.child("pbnResponder"), "clicked()", this, "iface.responderMail" );
	connect(this.child("chkPendientes"), "clicked()", this, "iface.cambioChkPendientes");

	this.iface.rutaMantVer = util.readSettingEntry("scripts/flservppal/dirMantVer");
	this.child("lblDirMantver").text = this.iface.rutaMantVer;
	this.child("chkPendientes").checked = false;
	
	this.iface.comprobarFactura();
}



function interna_calculateField(fN:String):String
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var valor:String;
	
	var codContrato:String = this.child("fdbCodContrato").value();

	switch(fN) {
		/** \D
		El --codcliente-- se hereda del contrato correspondiente
		\end */
		case "codcliente":
			valor = util.sqlSelect("se_contratosman", "codcliente",  "codigo = '" + codContrato + "'" );
			if (!valor) valor = "";
		break;
		/** \D
		El --codcliente-- se hereda del contrato correspondiente
		\end */
		case "nomcliente":
			valor = util.sqlSelect("clientes", "nombre",  "codcliente = '" + this.child("fdbCodCliente").value() + "'" );
			if (!valor) valor = "";
		break;
		/** \D
		El --coste-- y  el --totalincidencias-- se obtienen de la tabla de cuotas según el tipo de contrato
		\end */
		case "coste":
			valor = util.sqlSelect("se_cuotas", "coste", "tipocontrato = '" + this.iface.tipoContrato + "' AND limitesuperior >= " + cursor.valueBuffer("pesoparche") + " and limiteinferior <=" + cursor.valueBuffer("pesoparche"))
		break;
		
		case "totalincidencias":
			valor = util.sqlSelect("se_cuotas", "incidencias", "tipocontrato = '" + this.iface.tipoContrato + "' AND limitesuperior >= " + cursor.valueBuffer("pesoparche") + " and limiteinferior <= " + cursor.valueBuffer("pesoparche"));
		break;
		
		/** \D
		La --fechainicio-- se calcula añadiéndole un mes a la fecha de fin del último periódo de actualización del contrato si existe y si no se calcula como día 1 del mes actual
		\end */
		case "fechainicio": 
			var fechaFinAnt:Date = util.sqlSelect("se_pactualizacion", "fechafin", "codcontrato = '" + codContrato + "' order by fechafin desc" );
			var fechaInicio:Date;
			if (fechaFinAnt)
				fechaInicio = util.addMonths(fechaFinAnt,1);
			else 
				fechaInicio = new Date();
			
			fechaInicio.setDate(1);
			valor = fechaInicio;
		break;
		
		/** \D
		El --codcliente-- se hereda del contrato correspondiente
		\end */
		case "fechafin":
			valor = this.child("fdbFechaInicio").value()

			var ultimoDia:Number = 31;
			var fechaFin = new Date( Date.parse(valor) );
			fechaFin.setDate(ultimoDia--);
			while (!fechaFin) {
				fechaFin = new Date( Date.parse(valor) );
				fechaFin.setDate(ultimoDia--);
			}
			
			valor = fechaFin;
		break;
		
		/** \D
		El --dirlocal-- se hereda del contrato correspondiente
		\end */
		case "dirlocal":
			valor = util.sqlSelect("se_contratosman", "dirlocal",  "codigo = '" + codContrato + "'" );
			if (!valor) valor = "";
		break;
		
		/** \D
		El --pesoparche-- será el valor de ese campo para el último periódo de actualización del contrato, en el caso de ser el primer periódo creado el --pesoparche-- será 0
		\end */
		case "pesoparche":
			valor = util.sqlSelect("se_pactualizacion", "pesoparche",  "codcontrato = '" + codContrato + "' order by fechafin desc" );
			if (!valor) valor = 0;
		break;
		
		/** \D
		El campo --facturado-- será true si existe un codigo de factura para ese periodo y false en caso contrario
		\end */
		case "facturado":
			valor = false;
			if (this.child("fdbCodFactura")) valor = true;
		break;
		
	}
	return valor;
}

/** \C
La --fechainicio-- no podrá ser posterior a la --fechafin-- del período
Los períodos de actualización no podrán solaparse en el tiempo
El peso del parche deberá ser mayor que cero excepto en el caso de periódos correspondientes a contratos de tipo Basico
\end */
function interna_validateForm():Boolean
{

	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil;

	var pesoParche:String = cursor.valueBuffer("pesoparche");
	var fechaInicio:String = cursor.valueBuffer("fechainicio");
	var fechaFin:String = cursor.valueBuffer("fechafin");
	
	if (fechaInicio > fechaFin) {
		MessageBox.warning(util.translate("scripts","La fecha prevista de fin no puede ser menor que la fecha de inicio"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
	
	if (util.sqlSelect("se_pactualizacion", "id", 
		"codcontrato = '" + cursor.valueBuffer("codcontrato") + "' AND " + 
		"id <> " + cursor.valueBuffer("id") + " AND " + 
		"((fechainicio <= '" + fechaInicio + "' AND fechafin >= '" + fechaInicio + "') OR " +
		"(fechainicio <= '" + fechaFin + "' AND fechafin >= '" + fechaFin + "'))")) {
				MessageBox.critical(util.translate("scripts","Este período se superpone a uno ya existente"),MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				return false;
	}
	
	return true;
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
/** \C
El --pesoparche-- determinará automáticamente el --coste-- y el número total
de incidencias consultando la tabla de cuotas
\end */
			case "pesoparche": 
				this.child("fdbCoste").setValue(this.iface.calculateField("coste"));
				this.child("fdbTotalIncidencias").setValue(this.iface.calculateField("totalincidencias"));
			break;
/** \C
Un periódo estará facturado cuando exista un --idfactura-- asociado
\end */
			case "idfactura": 
				this.child("fdbFacturado").setValue(this.iface.calculateField("facturado"));
			break;
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
	
  	var nuevoDir:String = Input.getText(util.translate( "scripts", "Introduce el nombre del directorio del cliente" ));

	if (nuevoDir) {
		if (nuevoDir.right(1) != "/") nuevoDir += "/";
		if (!File.isDir(this.iface.rutaMantVer + nuevoDir)) {
			MessageBox.critical(util.translate("scripts", "La ruta a los módulos no es correcta:\n") + this.iface.rutaMantVer + nuevoDir,
			MessageBox.Ok, MessageBox.Cancel, MessageBox.NoButton);
			return false;
		}
		else
			this.child("fdbDirLocal").setValue(nuevoDir);
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
	
	var idPActualizacion:String = this.cursor().valueBuffer("id");
	
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
	curModulosSP.select("idpactualizacion = '" + idPActualizacion + "'");
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
			curModulosSP.setValueBuffer("idpactualizacion", idPActualizacion);
			curModulosSP.setValueBuffer("idmodulo", modulos[j]);
			curModulosSP.setValueBuffer("idarea", areas[i]);
			curModulosSP.commitBuffer();
			
			dirArea.cdUp();
		}
  	}
	this.child("tdbModulos").refresh();
}

/** \D Calcula el número de incidencias registradas para el período
\end */
function oficial_actualizarIncidencias()
{
	var util:FLUtil = new FLUtil();
	var numIncidencias:Number = util.sqlSelect("se_incidencias", "count(codigo)", "idpactualizacion = " + this.cursor().valueBuffer("id"));
	
	if (!numIncidencias) numIncidencias = 0;
	this.child("fdbIncidencias").setValue(numIncidencias);
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

/** \D Filtra las tabla de incidencias por incidencias pendientes de ese periodo de 
actualizacion si está activa la opcion de SóloPendientes, si no lo está la filta mostrando
todas las incidencias del periodo de actualizacion y refresca la tabla
\end */
function oficial_cambioChkPendientes()
{
	if(this.child("chkPendientes").checked == true)
		this.child("tdbIncidencias").cursor().setMainFilter("estado = 'Pendiente' AND idpactualizacion = '" + this.cursor().valueBuffer("id") + "'");
	else
		this.child("tdbIncidencias").cursor().setMainFilter("idpactualizacion = '" + this.cursor().valueBuffer("id") + "'");
	this.child("tdbIncidencias").refresh();
}


/** \D Comprueba que la factura asociada existe en la tabla de facturas
\end */
function oficial_comprobarFactura()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var idFactura:Number = cursor.valueBuffer("idFactura");
	
	if (!idFactura) return;
	
	if (!util.sqlSelect("facturascli", "idfactura", "idfactura = " + idFactura)) {
		cursor.setValueBuffer("facturado", "false");
	}
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////