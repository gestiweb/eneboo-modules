/***************************************************************************
                 pr_mastertiposproceso.qs  -  description
                             -------------------
    begin                : mie oct 18 2006
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
/** \C
El formulario gestiona los distintos tipos de proceso, permitiendo lanzar procesos del tipo seleccionado
\end */
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
		this.ctx.interna_init();
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var tbnLanzarProceso:Object;
	var tbnCopiarTipoProceso:Object;
	var tdbRecords:FLTableDB;
	var curTipoProceso_:FLSqlCursor;
	var curTipoTareaPro_:FLSqlCursor;
	var curSecuencias_:FLSqlCursor;
	var curAlias_:FLSqlCursor;
    function oficial( context ) { interna( context ); }
	function lanzarProceso() {
		this.ctx.oficial_lanzarProceso();
	} 
	function tbnCopiar_clicked() {
		return this.ctx.oficial_tbnCopiar_clicked();
	}
	function copiarTipoProceso(idTipoProceso:String):Boolean {
		return this.ctx.oficial_copiarTipoProceso(idTipoProceso);
	}
	function copiarDatosTipoProceso(curTipoProceso:FLSqlCursor,campo:String):Boolean {
		return this.ctx.oficial_copiarDatosTipoProceso(curTipoProceso,campo);
	}
	function copiarTiposTareaPro(idTipoProceso:String, nuevoTipoProceso:String):Boolean {
		return this.ctx.oficial_copiarTiposTareaPro(idTipoProceso, nuevoTipoProceso);
	}
	function copiarDatosTipoTareaPro(curTipoTareaPro:FLSqlCursor,campo:String):Boolean {
		return this.ctx.oficial_copiarDatosTipoTareaPro(curTipoTareaPro,campo);
	}
	function copiarSecuencias(idTipoProceso:String, nuevoTipoProceso:String):Boolean {
		return this.ctx.oficial_copiarSecuencias(idTipoProceso, nuevoTipoProceso);
	}
	function copiarDatosSecuencia(curSecuencia:FLSqlCursor,campo:String):Boolean {
		return this.ctx.oficial_copiarDatosSecuencia(curSecuencia,campo);
	}
	function copiarAlias(idTipoProceso:String, nuevoTipoProceso:String):Boolean {
		return this.ctx.oficial_copiarAlias(idTipoProceso, nuevoTipoProceso);
	}
	function copiarDatosAlias(curAlias:FLSqlCursor,campo:String):Boolean {
		return this.ctx.oficial_copiarDatosAlias(curAlias,campo);
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
	this.iface.tdbRecords = this.child("tableDBRecords");
	this.iface.tbnLanzarProceso = this.child("tbnLanzarProceso");
	connect(this.iface.tbnLanzarProceso, "clicked()", this, "iface.lanzarProceso");

	this.iface.tbnCopiarTipoProceso = this.child("tbnCopiarTipoProceso");
	connect(this.iface.tbnCopiarTipoProceso, "clicked()", this, "iface.tbnCopiar_clicked");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Lanza un proceso del tipo seleccionado
\end */
function oficial_lanzarProceso()
{
	var cursor:FLSqlCursor = this.cursor();
	var idTipoProceso:String = cursor.valueBuffer("idtipoproceso");

	if (!idTipoProceso)
		return false;
	flcolaproc.iface.pub_crearProceso(idTipoProceso);
}

function oficial_tbnCopiar_clicked()
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil;
	var idTipoProceso:Number = cursor.valueBuffer("idtipoproceso");
	if (!idTipoProceso) {
		MessageBox.warning(util.translate("scripts", "No hay ningún tipo de proceso seleccionado"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	cursor.transaction(false);
	try {
		if (this.iface.copiarTipoProceso(idTipoProceso))
			cursor.commit();
		else
			cursor.rollback();
	}
	catch (e) {
		cursor.rollback();
		MessageBox.critical(util.translate("scripts", "Hubo un error en la copia del tipo de proceso:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
	}
	this.iface.tdbRecords.refresh();
}

function oficial_copiarTipoProceso(idTipoProceso:String):Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
    var nuevoTipoProceso = Input.getText( "Introduzca el nuevo código de tipo de proceso:","","Copiar Tipo Proceso");
    if (nuevoTipoProceso && nuevoTipoProceso != "") {
		if (util.sqlSelect("pr_tiposproceso", "idtipoproceso", "idtipoproceso = '" + nuevoTipoProceso + "'")) {
			MessageBox.warning(util.translate("scripts", "Ya existe un tipo de proceso con ese código"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}

		this.iface.curTipoProceso_ = new FLSqlCursor("pr_tiposproceso");
		this.iface.curTipoProceso_.setModeAccess(this.iface.curTipoProceso_.Insert);
		this.iface.curTipoProceso_.refreshBuffer();
		this.iface.curTipoProceso_.setValueBuffer("idtipoproceso", nuevoTipoProceso);

		var campos:Array = util.nombreCampos("pr_tiposproceso");
		var totalCampos:Number = campos[0];
	
		for (var i:Number = 1; i <= totalCampos; i++) {
			if (!this.iface.copiarDatosTipoProceso(cursor,campos[i]))
				return false;
		}

		if (!this.iface.curTipoProceso_.commitBuffer())
			return false;

		if (!this.iface.copiarSecuencias(idTipoProceso, nuevoTipoProceso))
			return false;

		if (!this.iface.copiarTiposTareaPro(idTipoProceso, nuevoTipoProceso))
			return false;

		if (!this.iface.copiarAlias(idTipoProceso, nuevoTipoProceso))
			return false;
    }
	else {
		MessageBox.warning(util.translate("scripts", "Debe introducir un código para crear el nuevo proceso."), MessageBox.Ok, MessageBox.NoButton);
        return false;
    }

	return true;
}

function oficial_copiarDatosTipoProceso(curTipoProceso:FLSqlCursor,campo:String):Boolean
{
	if(!campo || campo == "")
		return false;
	
	switch (campo) {
		case "idtipoproceso": {
			return true;
			break;
		}
		default: {
			if (curTipoProceso.isNull(campo)) {
				this.iface.curTipoProceso_.setNull(campo);
			} else {
				this.iface.curTipoProceso_.setValueBuffer(campo, curTipoProceso.valueBuffer(campo));
			}
		}
	}
	return true;
}

function oficial_copiarTiposTareaPro(idTipoProceso:String, nuevoTipoProceso:String):Boolean
{
	var util:FLUtil;
	var curTiposTareaPro:FLSqlCursor = new FLSqlCursor("pr_tipostareapro");
	this.iface.curTipoTareaPro_ = new FLSqlCursor("pr_tipostareapro");
		
	curTiposTareaPro.select("idtipoproceso = '" + idTipoProceso + "'");
	var idTipoTareaOrigen:String;
	var idTipoTareaDestino:String;

	var campos:Array = util.nombreCampos("pr_tipostareapro");
	var totalCampos:Number = campos[0];

	while (curTiposTareaPro.next()) {
		this.iface.curTipoTareaPro_.setModeAccess(this.iface.curTipoTareaPro_.Insert);
		this.iface.curTipoTareaPro_.refreshBuffer();
		this.iface.curTipoTareaPro_.setValueBuffer("idtipoproceso", nuevoTipoProceso);
	
		for (var i:Number = 1; i <= totalCampos; i++) {
			if (!this.iface.copiarDatosTipoTareaPro(curTiposTareaPro,campos[i]))
				return false;
		}

		if (!this.iface.curTipoTareaPro_.commitBuffer())
			return false;
	}
	return true;
}

function oficial_copiarDatosTipoTareaPro(curTipoTareaPro:FLSqlCursor,campo:String):Boolean
{
	if(!campo || campo == "")
		return false;
	
	switch (campo) {
		case "idtipotareapro":
		case "idtipoproceso": {
			return true;
			break;
		}
		default: {
			if (curTipoTareaPro.isNull(campo)) {
				this.iface.curTipoTareaPro_.setNull(campo);
			} else {
				this.iface.curTipoTareaPro_.setValueBuffer(campo, curTipoTareaPro.valueBuffer(campo));
			}
		}
	}
	return true;
}

function oficial_copiarSecuencias(idTipoProceso:String, nuevoTipoProceso:String):Boolean
{
	var util:FLUtil;
	var curSecuencias:FLSqlCursor = new FLSqlCursor("pr_secuencias");
	this.iface.curSecuencias_= new FLSqlCursor("pr_secuencias");
	this.iface.curSecuencias_.setActivatedCheckIntegrity(false);
	
	var campos:Array = util.nombreCampos("pr_secuencias");
	var totalCampos:Number = campos[0];
	
	curSecuencias.select("idtipoproceso = '" + idTipoProceso + "'");
	while (curSecuencias.next()) {
		this.iface.curSecuencias_.setModeAccess(this.iface.curSecuencias_.Insert);
		this.iface.curSecuencias_.refreshBuffer();
		this.iface.curSecuencias_.setValueBuffer("idtipoproceso", nuevoTipoProceso);
		
		for (var i:Number = 1; i <= totalCampos; i++) {
			if (!this.iface.copiarDatosSecuencia(curSecuencias,campos[i]))
				return false;
		}

		if (!this.iface.curSecuencias_.commitBuffer())
			return false;

	}
	return true;
}

function oficial_copiarDatosSecuencia(curSecuencia:FLSqlCursor,campo:String):Boolean
{
	if(!campo || campo == "")
		return false;
	
	switch (campo) {
		case "idsecuencia":
		case "idtipoproceso": {
			return true;
			break;
		}
		default: {
			if (curSecuencia.isNull(campo)) {
				this.iface.curSecuencias_.setNull(campo);
			} else {
				this.iface.curSecuencias_.setValueBuffer(campo, curSecuencia.valueBuffer(campo));
			}
		}
	}
	return true;
}

function oficial_copiarAlias(idTipoProceso:String, nuevoTipoProceso:String):Boolean
{
	var util:FLUtil;
	var curAlias:FLSqlCursor = new FLSqlCursor("pr_aliasproceso");
	this.iface.curAlias_= new FLSqlCursor("pr_aliasproceso");
		
	var campos:Array = util.nombreCampos("pr_aliasproceso");
	var totalCampos:Number = campos[0];

	curAlias.select("idtipoproceso = '" + idTipoProceso + "'");
	while (curAlias.next()) {
		this.iface.curAlias_.setModeAccess(this.iface.curAlias_.Insert);
		this.iface.curAlias_.refreshBuffer();
		this.iface.curAlias_.setValueBuffer("idtipoproceso", nuevoTipoProceso);
		
		for (var i:Number = 1; i <= totalCampos; i++) {
			if (!this.iface.copiarDatosAlias(curAlias,campos[i]))
				return false;
		}

		if (!this.iface.curAlias_.commitBuffer())
			return false;

	}
	return true;
}

function oficial_copiarDatosAlias(curAlias:FLSqlCursor,campo:String):Boolean
{
	if(!campo || campo == "")
		return false;
	
	switch (campo) {
		case "idalias":
		case "idtipoproceso": {
			return true;
			break;
		}
		default: {
			if (curAlias.isNull(campo)) {
				this.iface.curAlias_.setNull(campo);
			} else {
				this.iface.curAlias_.setValueBuffer(campo, curAlias.valueBuffer(campo));
			}
		}
	}
	return true;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
