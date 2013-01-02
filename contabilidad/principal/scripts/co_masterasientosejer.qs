/***************************************************************************
                 co_masterasientosejer.qs  -  description
                             -------------------
    begin                : jue ago 12 2004
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var pbnCerrar:Object; 		/** @var pbnCerrar Boton para cerrar ejercicio */
	var tbnCrearApertura:FLTableDB;
	var tbnBorrarApertura:FLTableDB;
	var tableDBRecords:FLTableDB;
	var lblEjercicio:Object;
	var lblEstado:Object;
	var lblEjercicio2:Object;
	var lblEstado2:Object;
	var ejercicioActual:String;
    function oficial( context ) { interna( context ); } 
	function tbnBorrarApertura_clicked():Boolean { return this.ctx.oficial_tbnBorrarApertura_clicked(); }
	function pbnCerrar_clicked() { return this.ctx.oficial_pbnCerrar_clicked(); }
	function reabrirEjercicio(codEjercicio:String):Boolean { return this.ctx.oficial_reabrirEjercicio(codEjercicio); }
	function tbnCrearApertura_clicked():Boolean { return this.ctx.oficial_tbnCrearApertura_clicked(); }
	function refrescar():Boolean { return this.ctx.oficial_refrescar(); }
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
		var util:FLUtil = new FLUtil();
		
		this.iface.pbnCerrar = this.child("pbnCerrar");
		this.iface.tbnCrearApertura = this.child("tbnCrearApertura");
		this.iface.tbnBorrarApertura = this.child("tbnBorrarApertura");
		this.iface.tableDBRecords = this.child("tableDBRecords");
		this.iface.lblEjercicio = this.child("lblEjercicio");
		this.iface.lblEstado = this.child("lblEstado");
		this.iface.lblEjercicio2 = this.child("lblEjercicio2");
		this.iface.lblEstado2 = this.child("lblEstado2");
		
		this.iface.ejercicioActual = flfactppal.iface.pub_ejercicioActual();
		
		//tableDBRecords.setReadOnly(true);
		
		connect(this.iface.pbnCerrar, "clicked()", this, "iface.pbnCerrar_clicked()");
		connect(this.iface.tbnCrearApertura, "clicked()", this, "iface.tbnCrearApertura_clicked()");
		connect(this.iface.tbnBorrarApertura, "clicked()", this, "iface.tbnBorrarApertura_clicked()");
		
		this.iface.refrescar();
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Respuesta al botón de cierre/apertura de ejercicio. Dependiendo del estado del ejercicio el mismo se reabrirá si estaba cerrado o se cerrará si estaba abierto. Se consulta al usuario sobre la reapertura de un ejercicio antes cerrado.
\end */
function oficial_pbnCerrar_clicked()
{
	var util:FLUtil = new FLUtil();
	var estado:String = util.sqlSelect("ejercicios", "estado", "codejercicio = '" + this.iface.ejercicioActual + "'");
	
	if (estado == "ABIERTO") {
		var f = new FLFormSearchDB("co_cerrarejer");
		var cursor:FLSqlCursor = f.cursor();
		cursor.select("codejercicio = '" + this.iface.ejercicioActual + "'")
		cursor.first()
		cursor.setModeAccess(cursor.Edit);
		f.setMainWidget();
		cursor.refreshBuffer();
		var acpt:Boolean;
		cursor.transaction(false);
		try {
			f.exec("codejercicio");
			acpt = f.accepted();
			if (!acpt) {
				cursor.rollback();
			} else {
				cursor.setValueBuffer("estado", "CERRADO");
				if (cursor.commitBuffer()) {
					cursor.commit();
					MessageBox.information(util.translate("scripts","Se ha cerrado el ejercicio ") + this.iface.ejercicioActual, MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				} else {
					cursor.rollback();
				}
			}
			f.close();
		}
		catch(e) {
			cursor.rollback();
			MessageBox.information(util.translate("scripts","Error al cerrar el ejercicio: ") + e, MessageBox.Ok, MessageBox.NoButton);
		}
	} else {
		var res:Object = MessageBox.warning(util.translate("scripts", "¿Desea realmente reabrir el ejercicio ") +  this.iface.ejercicioActual + util.translate("scripts", "?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
		if (res == MessageBox.Yes)
			if (this.iface.reabrirEjercicio(this.iface.ejercicioActual))
				MessageBox.information(util.translate("scripts", "Se ha reabierto el ejercicio ") + this.iface.ejercicioActual, MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			else
				MessageBox.critical(util.translate("scripts", "Error al reabrir el ejercicio ") + this.iface.ejercicioActual, MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
	}
	this.iface.refrescar();
}


/** \D Reapertura de un ejercicio antes cerrado
\end */
function oficial_reabrirEjercicio(codEjercicio):Boolean
{
		var util:FLUtil = new FLUtil();
		var curEjercicio:FLSqlCursor = new FLSqlCursor("ejercicios");
		curEjercicio.transaction(false);
		if (!curEjercicio.select("codejercicio = '" + codEjercicio + "'")) {
				curEjercicio.rollBack();
				return false;
		}
		if (!curEjercicio.first()) {
				curEjercicio.rollBack();
				return false;
		}
		
		/** \D Se ponen los códigos de los asientos de cierre y pérdidas y ganancias del ejercicio a cero
		\end */
		var idAsientoCierre:Number = curEjercicio.valueBuffer("idasientocierre");
		var idAsientoPyG:Number = curEjercicio.valueBuffer("idasientopyg");
		
		with (curEjercicio) {
				setModeAccess(curEjercicio.Edit);
				refreshBuffer();
				setValueBuffer("estado", "ABIERTO");
				setValueBuffer("idasientopyg", 0);
				setValueBuffer("idasientocierre", 0);
		}
		if (!curEjercicio.commitBuffer()) {
				curEjercicio.rollBack();
				return false;
		}
		
		/** \D Se eliminan los asientos de cierre y pérdidas y ganancias
		\end */
		var curAsiento:FLSqlCursor = new FLSqlCursor("co_asientos");
		with(curAsiento) {
				select("idasiento = " + idAsientoPyG);
				first();
				setModeAccess(curAsiento.Edit);
				refreshBuffer();
				setUnLock("editable", true);
		}
		if (!util.sqlDelete("co_asientos", "idasiento = " + idAsientoPyG)) {
				curEjercicio.rollBack();
				return false;
		}
		
		with(curAsiento) {
				select("idasiento = " + idAsientoCierre);
				first();
				setModeAccess(curAsiento.Edit);
				refreshBuffer();
				setUnLock("editable", true);
		}
		if (!util.sqlDelete("co_asientos", "idasiento = " + idAsientoCierre)) {
				curEjercicio.rollBack();
				return false;
		}
		
		curEjercicio.commit();
		this.iface.refrescar();
		return true;
}

/** \D Se crea el asiento de apertura de un ejercicio en base al asiento de cierre del ejercicio actual
\end */
function oficial_tbnCrearApertura_clicked():Boolean
{
		var util:FLUtil = new FLUtil();
		var cursor:FLSqlCursor = new FLSqlCursor("co_asientos");
		
		cursor.transaction(true);
		
		var fechaIniAct:String = util.sqlSelect("ejercicios", "fechainicio", "codejercicio = '" + this.iface.ejercicioActual + "'");
		
		var f:Object = new FLFormSearchDB("ejercicios");
		f.setMainWidget();
		f.cursor().setMainFilter("estado = 'CERRADO' AND fechafin < '" + fechaIniAct + "'");
		var idAsientoCierre:Number = f.exec("idasientocierre");
		if (!idAsientoCierre) 
				return false;
				
		if (!formco_cerrarejer.iface.pub_asientoApertura(idAsientoCierre, this.iface.ejercicioActual)) {
				cursor.rollback();
				return false;
		}
		
		cursor.commit();
		this.iface.refrescar();
		return true;
}

/** \D Elimina un asiento de apertura previamente creado. Comprueba que existe el asiento de apertura
\end */
function oficial_tbnBorrarApertura_clicked():Boolean
{
		var util:FLUtil = new FLUtil();
		var curAsiento:FLSqlCursor = new FLSqlCursor("co_asientos");
		
		curAsiento.transaction(true);
		
		var idAsientoApertura:Number = util.sqlSelect("ejercicios", "idasientoapertura", 
				"codejercicio = '" + this.iface.ejercicioActual + "'");
		
		if (!idAsientoApertura) {
				MessageBox.warning(util.translate("scripts", 
						"No existe el asiento de apertura"),
						MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				curAsiento.rollback();
				return false;
		}
		
		with(curAsiento) {
				select("idasiento = " + idAsientoApertura);
				first();
				setModeAccess(curAsiento.Edit);
				refreshBuffer();
				setUnLock("editable", true);
		}
		if (!util.sqlDelete("co_asientos", "idasiento = " + idAsientoApertura)) {
				MessageBox.warning(util.translate("scripts", 
						"Error al borrar el asiento de apertura"),
						MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				curAsiento.rollback();
				return false;
		}
		
		if (!util.sqlUpdate("ejercicios", "idasientoapertura", 0, 
				"codejercicio = '" + this.iface.ejercicioActual + "'")) {
				MessageBox.warning(util.translate("scripts", 
						"Error al borrar el asiento de apertura"),
						MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				curAsiento.rollback();
				return false;
		}
		
		curAsiento.commit();
		this.iface.refrescar();
		return true;
}

/** \D Actualiza en formulario en función del estado del ejercicio
\end */
function oficial_refrescar():Boolean
{
		var util:FLUtil = new FLUtil();
		var datosEj:Array = flcontppal.iface.pub_ejecutarQry("ejercicios", 
				"nombre,estado,fechainicio,fechafin,idasientocierre,idasientopyg,idasientoapertura",
				"codejercicio = '" + this.iface.ejercicioActual + "'");
		if (datosEj.result != 1)
				return false;
		
		/** \D Actualiza las etiquetas de ejercicio con el código y las fechas de inicio y fin
		\end */
		this.iface.lblEjercicio2.text = util.translate("scripts", "Ejercicio ");
		this.iface.lblEjercicio.text = this.iface.ejercicioActual + " (" + datosEj.nombre + ") " + 
				util.dateAMDtoDMA(datosEj.fechainicio) + " - " + util.dateAMDtoDMA(datosEj.fechafin);
		this.iface.lblEstado2.text = util.translate("scripts", "Estado ");
		this.iface.lblEstado.text = datosEj.estado;
		
		if (!datosEj.idasientocierre || isNaN(datosEj.idasientocierre))
			datosEj.idasientocierre = 0;
		if (!datosEj.idasientopyg || isNaN(datosEj.idasientopyg))
			datosEj.idasientopyg = 0;
		if (!datosEj.idasientoapertura || isNaN(datosEj.idasientoapertura))
			datosEj.idasientoapertura = 0;

		var filtro:String = "idasiento IN (" + datosEj.idasientocierre + ", " + 
				datosEj.idasientopyg + ", " + datosEj.idasientoapertura + ")";
		this.cursor().setMainFilter(filtro);
		
		/** \D Actualiza la etiqueta del botón Cerrar/Abrir en función del estado del ejercicio
		\end */
		if (datosEj.estado == "ABIERTO")
				this.iface.pbnCerrar.text = util.translate("scripts", "Cerrar");
		else
				this.iface.pbnCerrar.text = util.translate("scripts", "Reabrir");
		
		this.iface.tableDBRecords.refresh();
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
