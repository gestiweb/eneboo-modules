/***************************************************************************
                 pr_masterordenesprod.qs  -  description
                             -------------------
    begin                : mar jun 5 2007
    copyright            : (C) 2007 by InfoSiAL S.L.
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
El formulario permite borrar órdenes sólo si están en estado PTE
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
	function init() { this.ctx.interna_init(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var tbnImprimir:Object;
	var tbnBorrar:Object;
	var tdbRecords:Object;
	var tbnImprimirEtiquetas:Object;
	var tbnTerminarOrden:Object;
	function oficial( context ) { interna( context ); } 
	function imprimir() {
		this.ctx.oficial_imprimir();
	}
	function tbnBorrar_clicked() {
		this.ctx.oficial_tbnBorrar_clicked();
	}
	function sacarProceso(idProceso:String):Boolean {
		return this.ctx.oficial_sacarProceso(idProceso);
	}
	function borrarOrden(codOrden:String):Boolean {
		return this.ctx.oficial_borrarOrden(codOrden);
	}
	function imprimirEtiquetas() {
		this.ctx.oficial_imprimirEtiquetas();
	}
	function terminarOrden_clicked() {
		return this.ctx.oficial_terminarOrden_clicked();
	}
	function terminarOrden(codOrden:String):Boolean {
		return this.ctx.oficial_terminarOrden(codOrden);
	}
	function terminarProceso(idProceso:Number,idUsuario:String):Boolean {
		return this.ctx.oficial_terminarProceso(idProceso,idUsuario);
	}
	function realizarTarea(idTarea:String,estado:String,idUsuario:String):Boolean {
		return this.ctx.oficial_realizarTarea(idTarea,estado,idUsuario);
	}
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration prod */
/////////////////////////////////////////////////////////////////
//// PRODUCCION /////////////////////////////////////////////////
class prod extends oficial {
	function prod( context ) { oficial ( context ); }
	function imprimir() {
		this.ctx.prod_imprimir();
	}
}
//// PRODUCCION /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends prod {
	function head( context ) { prod ( context ); }
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration ifaceCtx */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends head {
	function ifaceCtx( context ) { head( context ); }
	function pub_sacarProceso(idProceso:String):Boolean {
		return this.sacarProceso(idProceso);
	}
	function pub_terminarOrden(codOrden:String):Boolean {
		return this.terminarOrden(codOrden);
	}
	function pub_terminarProceso(idProceso:Number,idUsuario:String):Boolean {
		return this.terminarProceso(idProceso,idUsuario);
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
	this.iface.tbnImprimir = this.child("toolButtonPrint");
	this.iface.tbnBorrar = this.child("toolButtonDelete");
	this.iface.tdbRecords = this.child("tableDBRecords");
	this.iface.tbnImprimirEtiquetas = this.child("tbnImprimirEtiquetas");
	this.iface.tbnTerminarOrden = this.child("tbnTerminarOrden");

	connect(this.iface.tbnTerminarOrden, "clicked()", this, "iface.terminarOrden_clicked()");
	connect(this.iface.tbnImprimir, "clicked()", this, "iface.imprimir");
	connect(this.iface.tbnImprimirEtiquetas, "clicked()", this, "iface.imprimirEtiquetas");
	connect(this.iface.tbnBorrar, "clicked()", this, "iface.tbnBorrar_clicked");
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

/** \D 
Imprime la orden de producción seleccionada
\end */
function oficial_imprimir() 
{
	if (!this.cursor().isValid())
		return;
	if (!sys.isLoadedModule("flprodinfo")) {
		flfactppal.iface.pub_msgNoDisponible("Informes");
		return;
	}
	if (!this.cursor().isValid())
		return;

	var codOrden:String = this.cursor().valueBuffer("codorden");
	if (!codOrden || codOrden == "")
		return;

	var curImprimir:FLSqlCursor = new FLSqlCursor("pr_i_ordenesproduccion");
	curImprimir.setModeAccess(curImprimir.Insert);
	curImprimir.refreshBuffer();
	curImprimir.setValueBuffer("descripcion", "temp");
	curImprimir.setValueBuffer("d_pr__ordenesproduccion_codorden", codOrden);
	curImprimir.setValueBuffer("h_pr__ordenesproduccion_codorden", codOrden);

	formpr_i_ordenesproduccion.iface.pub_lanzar(curImprimir);
}

/** \C
Para borrar una orden de producción, ésta debe estar en estado PTE. El borrado consiste en las siguientes acciones:
Borrado del proceso y tareas de producción asociados
Desasignación de las unidades de producto asociados de la orden de producción a borrar
\end */
function oficial_tbnBorrar_clicked()
{
	var util:FLUtil = new FLUtil();
	var curOrden:FLSqlCursor = this.cursor();
	var estado:String = curOrden.valueBuffer("estado");

	if (!estado) {
		MessageBox.warning(util.translate("scripts", "No hay ninguna orden seleccionada"), 	MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
	if (estado != "PTE") {
		MessageBox.warning(util.translate("scripts", "No se puede borrar la orden seleccionada, porque no está en estado PTE"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
	
	var resp:Number = MessageBox.information(util.translate("scripts", "La orden seleccionada será borrada\n ¿está seguro?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
	if (!resp == MessageBox.Yes)
		return false;
	
	var codOrden:String = curOrden.valueBuffer("codorden");
	curOrden.transaction(false);
	try {
		if (this.iface.borrarOrden(codOrden)) {
			curOrden.commit();
		} else {
			curOrden.rollback();
			return false;
		}
	} catch (e) {
		curOrden.rollback();
		MessageBox.critical(util.translate("scripts", "Error al borrar la orden de producción: ") + e, MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	this.iface.tdbRecords.refresh();
}

function oficial_borrarOrden(codOrden:String):Boolean
{
	var util:FLUtil = new FLUtil;
	
	util.createProgressDialog(util.translate("scripts", "Eliminando procesos de producción"), 100);
	util.setProgress(1);
	
	var qryProcesos:FLSqlQuery = new FLSqlQuery();

	qryProcesos.setTablesList("pr_procesos");
	qryProcesos.setSelect("idproceso");
	qryProcesos.setFrom("pr_procesos");
	qryProcesos.setWhere("codordenproduccion = '" + codOrden + "'");
	if (!qryProcesos.exec())
		return false;
	var totalProcesos:Number = qryProcesos.size();
	var progreso:Number = 1;
	
	util.setTotalSteps(totalProcesos);
	while(qryProcesos.next()) {
		if (!this.iface.sacarProceso(qryProcesos.value("idproceso"))) {
			util.destroyProgressDialog();
			return false;
		}
		util.setProgress(progreso++);
	}
	
	if (!util.sqlDelete("pr_ordenesproduccion", "codorden = '" + codOrden + "'")) {
		util.destroyProgressDialog();
		return false;
	}
	
	util.setProgress(totalProcesos);
	util.destroyProgressDialog();
	
	return true;
}

/** \D 
Cancela el proceso de producción, lo saca de la orden de producción, y lo deja en estado OFF
@param	idProceso: Proceso a sacar
@return	Verdadero si la desasignación se realiza correctamente, falso si no puede realizarse o hay error
\end */
function oficial_sacarProceso(idProceso:String):Boolean
{
	var util:FLUtil = new FLUtil;

	if (!flcolaproc.iface.pub_pasarOFFProcesoProd(idProceso)) {
		MessageBox.warning(util.translate("scripts", "Error al anular el proceso %1").arg(idProceso), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	/// Borra el movimiento de stock positivo previsto para cuando el proceso termine (si es de fabricación)
	var codLote:String = util.sqlSelect("pr_procesos", "idobjeto", "idproceso = " + idProceso);
	if (codLote && codLote != "") {
		if (!util.sqlDelete("movistock", "idproceso = " + idProceso + " AND codlote = '" + codLote + "'")) {
			return false;
		}
	}

	return true;
}

/** \D 
Imprime las etiquetas de la orden de producción seleccionada
\end */
function oficial_imprimirEtiquetas() 
{
	if (!this.cursor().isValid())
		return;
	if (!sys.isLoadedModule("flprodinfo")) {
		flfactppal.iface.pub_msgNoDisponible("Informes");
		return;
	}
	if (!this.cursor().isValid())
		return;

	var codOrden:String = this.cursor().valueBuffer("codorden");
	if (!codOrden || codOrden == "")
		return;

	var curImprimir:FLSqlCursor = new FLSqlCursor("pr_i_ordenesproduccion");
	curImprimir.setModeAccess(curImprimir.Insert);
	curImprimir.refreshBuffer();
	curImprimir.setValueBuffer("descripcion", "temp");
	curImprimir.setValueBuffer("d_pr__ordenesproduccion_codorden", codOrden);
	curImprimir.setValueBuffer("h_pr__ordenesproduccion_codorden", codOrden);

	formpr_i_pegasprod.iface.pub_lanzarPegasProd(curImprimir);
}

function oficial_terminarOrden_clicked()
{
	var util:FLUtil;

	var cursor:FLSqlCursor = this.cursor();
	var codOrden:String = cursor.valueBuffer("codorden");

	var res:Number = MessageBox.information(util.translate("scripts", "Se van a terminar todos los procesos de la orden %1.\n¿Desea continuar?").arg(codOrden), MessageBox.Yes, MessageBox.No);
	if(res != MessageBox.Yes)
		return false;

	flcolaproc.iface.pub_setTareaAutomatica(true);

	cursor.transaction(false);
	
	try {
		if(this.iface.terminarOrden(codOrden))
			cursor.commit();
		else {
			cursor.rollback();
			return;
		}
	} catch (e) {
		cursor.rollback();
		MessageBox.warning(util.translate("scripts", "Hubo un error al intentar terminar la orden %1.").arg(codOrden) + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
		return;
	}

	flcolaproc.iface.pub_setTareaAutomatica(false);

	MessageBox.information(util.translate("scripts", "La orden %1 se ha terminado correctamentae").arg(codOrden), MessageBox.Ok, MessageBox.NoButton);
}

function oficial_terminarOrden(codOrden:String):Boolean
{
	var util:FLUtil;

	var idUsuario:String = util.sqlSelect("pr_trabajadores", "idtrabajador", "idtrabajador = '" + sys.nameUser() + "'");
	if (!idUsuario || idUsuario == "") {
		MessageBox.warning(util.translate("scripts", "El trabajador %1 no existe en la tabla de trabajadores (módulo principal de producción)").arg(sys.nameUser()), MessageBox.Ok);
		return false;
	}

	var qryProcesos:FLSqlQuery = new FLSqlQuery();
	qryProcesos.setTablesList("pr_procesos");
	qryProcesos.setSelect("idproceso");
	qryProcesos.setFrom("pr_procesos");
	qryProcesos.setWhere("codordenproduccion = '" + codOrden + "'");
	
	if (!qryProcesos.exec())
		return false;

	util.createProgressDialog( util.translate( "scripts", "Terminando procesos de producción..." ), qryProcesos.size());
	util.setProgress(0);
	var i:Number = 0;

	while(qryProcesos.next()) {
		util.setProgress(i++);
		idProceso = qryProcesos.value("idproceso");
		if (!this.iface.terminarProceso(idProceso, idUsuario)) {
			util.destroyProgressDialog();
			return false;
		}	
	}
	
	util.setProgress(qryProcesos.size());
	util.destroyProgressDialog();

	return true;
}

function oficial_terminarProceso(idProceso:Number,idUsuario:String):Boolean
{
	if(!idProceso){debug("!idProceso");
		return false;}

	var util:FLUtil = new FLUtil;

	var qryTareas:FLSqlQuery = new FLSqlQuery();
	qryTareas.setTablesList("pr_tareas");
	qryTareas.setSelect("idtarea,estado,idtipotarea");
	qryTareas.setFrom("pr_tareas");
	qryTareas.setWhere("idproceso = " + idProceso + " AND estado <> 'TERMINADA' AND estado <> 'OFF'");
	
	if (!qryTareas.exec()){debug("false1");
		return false;}

	while(qryTareas.next()) {
debug("Tipo Tarea: " + qryTareas.value("idtipotarea") + " // Proceso: " + idProceso + " // Estado tarea: " + qryTareas.value("estado"));
		if(!this.iface.realizarTarea(qryTareas.value("idtarea"),qryTareas.value("estado"),idUsuario)){debug("false2");
			return false;}
	}

	var estadoProceso:String = util.sqlSelect("pr_procesos","estado","idproceso = " + idProceso);
	
	if(estadoProceso != "TERMINADO") {
		if(!formpr_ordenesproduccion.iface.terminarProceso(idProceso,idUsuario))
			return false;
	}

	return true;
}

function oficial_realizarTarea(idTarea:String,estado:String,idUsuario:String):Boolean
{
	var util:FLUtil;
		
	if(!idTarea || !idUsuario)
		return false;

	var curTarea:FLSqlCursor = new FLSqlCursor("pr_tareas");

	var unPaso:Boolean = false;
	if (estado == "PTE") {
		curTarea.select("idtarea = '" + idTarea + "'");
		if (!curTarea.first())
			return false;

		if (!flcolaproc.iface.pub_iniciarTarea(curTarea, idUsuario,true)){debug("false RT3");
			return false;}
	}

	estado = util.sqlSelect("pr_tareas", "estado", "idtarea = '" + idTarea + "'");

	if (estado == "EN CURSO") {
		curTarea.select("idtarea = '" + idTarea + "'");
		if (!curTarea.first()){debug("false RT4");
			return false;}

		if (!flcolaproc.iface.pub_terminarTarea(curTarea,true)){debug("false RT5");
			return false;}
	}
	
	return true;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition prod */
/////////////////////////////////////////////////////////////////
//// PRODUCCION /////////////////////////////////////////////////
/** \D 
Imprime la orden de producción seleccionada
Si hay tareas nuevas pendietnes de imprimir preguntrá si se desea imprimir un anexo con esas tareas.
\end */
function prod_imprimir() 
{
	var util:FLUtil;

	if (!this.cursor().isValid())
		return;
	if (!sys.isLoadedModule("flprodinfo")) {
		flfactppal.iface.pub_msgNoDisponible("Informes");
		return;
	}
	if (!this.cursor().isValid())
		return;

	var codOrden:String = this.cursor().valueBuffer("codorden");
	if (!codOrden || codOrden == "")
		return;

	var curImprimir:FLSqlCursor = new FLSqlCursor("pr_i_ordenesproduccion");
	curImprimir.setModeAccess(curImprimir.Insert);
	curImprimir.refreshBuffer();
	curImprimir.setValueBuffer("descripcion", "temp");
	curImprimir.setValueBuffer("d_pr__ordenesproduccion_codorden", codOrden);
	curImprimir.setValueBuffer("h_pr__ordenesproduccion_codorden", codOrden);

	var nombreInforme:String = "pr_i_ordenesproduccion";
	var where:String = "";
	if(util.sqlSelect("pr_tareas INNER JOIN pr_procesos ON pr_tareas.idproceso = pr_procesos.idproceso","pr_tareas.anexo","pr_procesos.codordenproduccion = '" + codOrden + "' AND pr_tareas.anexo","pr_tareas,pr_procesos")) {

		var dialog = new Dialog;
		dialog.caption = "Imprimir Orden";
		dialog.okButtonText = "Aceptar"
		dialog.cancelButtonText = "Cancelar";
		
		var normal = new RadioButton;
		normal.text = "Imprimir Normal";
		normal.checked = false;
		dialog.add(normal);
		
		var anexo = new RadioButton;
		anexo.text = "Imprimir Anexo";
		anexo.checked = true;
		dialog.add(anexo);
		
		if(!dialog.exec())
			return false;

		if(anexo.checked)
			where = "pr_tareas.anexo";

	}

	flprodinfo.iface.pub_lanzarInforme(curImprimir, nombreInforme,"","",false,false,where);

	if(where == "pr_tareas.anexo") {
		var res = MessageBox.information(util.translate("scripts", "¿Desea marcar el anexo como impreso?\n(Si elije si no podrá volver a imprimirlo)"),MessageBox.Yes, MessageBox.No);
		if(res == MessageBox.Yes)
			util.sqlUpdate("pr_tareas","anexo",false,"pr_tareas.idproceso IN (SELECT idproceso from pr_procesos where pr_procesos.codordenproduccion = '" + codOrden + "')");
	}
}
//// PRODUCCION /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////