/***************************************************************************
                 co_i_diario.qs  -  description
                             -------------------
    begin                : lun abr 26 2004
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
	function validateForm():Boolean { return this.ctx.interna_validateForm(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var ejercicioActual:String;
	var longSubcuenta:Number;
	var bloqueoSubcuenta:Boolean;
	var cuentaHastaInformada:Boolean;
	var posActualPuntoSubcuentaD:Number;
	var posActualPuntoSubcuentaH:Number;

	function oficial( context ) { interna( context ); } 
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function todasSubcuentas() {
		return this.ctx.oficial_todasSubcuentas();
	}
	function deshabilitarSubcuentas(valor_disabled:Boolean) {
		return this.ctx.oficial_deshabilitarSubcuentas(valor_disabled);
	}
	function todosAsientos() {
		return this.ctx.oficial_todosAsientos();
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
En modo inserción aparece ejercicio es el actual. Los campos --todosasientos-- y --todassubcuentas-- aparecen marcados, mostrando el intervalo total de subcuentas y asientos del ejercicio
\end */
function interna_init()
{
	this.iface.cuentaHastaInformada = false;
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	this.iface.ejercicioActual = flfactppal.iface.pub_ejercicioActual();
	this.iface.posActualPuntoSubcuentaD = -1;
	this.iface.posActualPuntoSubcuentaH = -1;
	
	this.child("fdbIdSubcuentaDesde").setFilter("codejercicio = '" + this.iface.ejercicioActual + "'");
	this.child("fdbIdSubcuentaHasta").setFilter("codejercicio = '" + this.iface.ejercicioActual + "'");

	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");

	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList("ejercicios");
	q.setSelect("longsubcuenta");
	q.setFrom("ejercicios");
	q.setWhere("codejercicio = '" + this.iface.ejercicioActual + "';");
	q.exec();

	if (q.next()) {
		this.iface.longSubcuenta = q.value(0);
	}

	if (cursor.modeAccess() == cursor.Insert) {
		this.child("fdbEjercicio").setValue(this.iface.ejercicioActual);
		this.iface.todasSubcuentas();
		this.iface.todosAsientos();
	}

	if (cursor.modeAccess() == cursor.Edit) {
		if (this.child("fdbTodosAsientos").value())
			this.iface.todosAsientos();
		if (this.child("fdbTodasSubcuentas").value())
			this.iface.todasSubcuentas();
		this.child("fdbFechaDesde").setValue(cursor.valueBuffer("d_co__asientos_fecha"));
	}
}

/** \C 
La fecha de inicio del período del ejercicio no puede ser posterior a la fecha de fin. Las fechas deben estar comprendidas dentro del período del ejercicio.

El código de la subcuenta inicial no puede ser superior al de la subcuenta final

El código del asiento inicial no puede ser superior al del asiento final
\end */
function interna_validateForm():Boolean
{
		var util:FLUtil = new FLUtil();

		var fechaInicio:String = this.child("fdbFechaDesde").value();
		var fechaFin:String = this.child("fdbFechaHasta").value();

		if (util.daysTo(fechaInicio, fechaFin) < 0) {
				MessageBox.critical
						(util.
						 translate("scripts",
											 "La fecha de inicio debe ser menor que la de fin"),
						 MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				return false;
		}


		var subcuentaInicio:String = this.child("fdbCodSubcuentaDesde").value();
		var subcuentaFin:String = this.child("fdbCodSubcuentaHasta").value();

		if (!subcuentaInicio || !subcuentaFin) {
				MessageBox.critical
						(util.
						 translate("scripts",
											 "Debe especificar las subcuentas"),
						 MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				return false;
		}

		if (subcuentaInicio > subcuentaFin) {
				MessageBox.critical
						(util.
						 translate("scripts",
											 "La subcuenta de inicio debe ser menor que la de fin"),
						 MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				return false;
		}


		var asientoInicio:Number = this.child("fdbAsientoDesde").value();
		var asientoFin:Number = this.child("fdbAsientoHasta").value();

		if (parseFloat(asientoInicio) > parseFloat(asientoFin)) {
				MessageBox.critical
						(util.
						 translate("scripts",
											 "El asiento de inicio debe ser menor que el de fin"),
						 MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
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
		var codSubcuenta:String;

		switch (fN) {

/** \C Es posible cambiar --tipo-- de informe para mostrar datos de I.V.A. como porcentajes y valores de I.V.A. y recargo de equivalencia
\end */
		case "tipo":
				if (parseFloat(this.child("fdbTipo").value()) == 0) {
						this.child("fdbDatosIva").setValue(true);
						this.child("fdbDatosIva").setDisabled(false);
				} else {
						this.child("fdbDatosIva").setValue(true);
						this.child("fdbDatosIva").setDisabled(true);
				}


/**	\C
Al introducir el código de subcuenta inicial, si el usuario pulsa la tecla "punto" (.), la subcuenta se informa automaticamente con el código de cuenta más tantos ceros como sea necesario para completar la longitud de subcuenta asociada al ejercicio actual.
\end \end */
		case "d_co__subcuentas_codsubcuenta":

				if (!this.iface.bloqueoSubcuenta) {
					this.iface.bloqueoSubcuenta = true;
					this.iface.posActualPuntoSubcuentaD = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuentaDesde", this.iface.longSubcuenta, this.iface.posActualPuntoSubcuentaD);
					this.iface.bloqueoSubcuenta = false;
				}
				break;


/**	\C
Al introducir el código de subcuenta final, si el usuario pulsa la tecla "punto" (.), la subcuenta se informa automaticamente con el código de cuenta más tantos ceros como sea necesario para completar la longitud de subcuenta asociada al ejercicio actual.
\end \end */
		case "h_co__subcuentas_codsubcuenta":

				if (!this.iface.bloqueoSubcuenta) {
					this.iface.cuentaHastaInformada = true;
					this.iface.bloqueoSubcuenta = true;
					this.iface.posActualPuntoSubcuentaH = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuentaHasta", this.iface.longSubcuenta, this.iface.posActualPuntoSubcuentaH);
					this.iface.bloqueoSubcuenta = false;
				}
				break;


/**	\C
Al introducir --i_co__subcuentas_codejercicio--, aparecen las fechas de inicio y fin del ejercicio seleccionado y la opcion --todosasientos-- queda marcada.
\end \end */
		case "i_co__subcuentas_codejercicio":

				var codEjercicio = this.child("fdbEjercicio").value();

				var q:FLSqlQuery = new FLSqlQuery();
				q.setTablesList("ejercicios");
				q.setSelect("longsubcuenta");
				q.setFrom("ejercicios");
				q.setWhere("codejercicio = '" + codEjercicio + "';");
				q.exec();

				if (q.next()) {
						this.iface.longSubcuenta = q.value(0);
						this.iface.todosAsientos();
				}

				break;

/** \C
Al pulsar sobre --todassubcuentas-- aparece como subcuenta inicial la de menor código y como subcuenta final la de mayor código
\end */
		case "todassubcuentas":

				if (this.child("fdbTodasSubcuentas").value())
						this.iface.todasSubcuentas();
				else {
						this.iface.bloqueoSubcuenta = true;
						this.child("fdbCodSubcuentaDesde").setValue("");
						this.child("fdbCodSubcuentaHasta").setValue("");
						this.iface.bloqueoSubcuenta = false;
						this.iface.cuentaHastaInformada = false;
						this.iface.deshabilitarSubcuentas(false);
				}

				break;


/** \C
Al pulsar sobre --todosasientos-- se busca en la tabla de asientos el de menor y mayor código, de modo que todos los asientos aparecerán en el informe
\end */
		case "todosasientos":

				if (this.child("fdbTodosAsientos").value())
						this.iface.todosAsientos();
				else {
						this.child("fdbAsientoDesde").setDisabled(false);
						this.child("fdbAsientoHasta").setDisabled(false);
				}

				break;
		}
}

/** \D
Busca los códigos menor y mayor de subcuenta dentro del ejercicio y los introduce en los campos --d_co__subcuentas_codsubcuenta-- y --h_co__subcuentas_codsubcuenta--. A continuación deshabilita los campos de subcuenta
\end */
function oficial_todasSubcuentas()
{
		var codEjercicio:String = this.child("fdbEjercicio").value();

		var q:FLSqlQuery = new FLSqlQuery();
		q.setTablesList("co_subcuentas");
		q.setSelect("MIN(codsubcuenta), MAX(codsubcuenta)");
		q.setFrom("co_subcuentas");
		q.setWhere("codejercicio = '" + codEjercicio + "';");
		q.exec();

		if (q.first()) {

				var subcuentaInicio:String = q.value(0);
				var subcuentaFin:String = q.value(1);

				this.iface.bloqueoSubcuenta = true;

 				this.child("fdbCodSubcuentaDesde").setValue(subcuentaInicio);
 				this.child("fdbCodSubcuentaHasta").setValue(subcuentaFin);

				this.iface.deshabilitarSubcuentas(true);
				this.iface.bloqueoSubcuenta = false;
		}
}

/** \D
Deshabilita los campos de subcuentas cuando se pulsa la opción --todassubcuentas--
\end */
function oficial_deshabilitarSubcuentas(valor_disabled:Boolean)
{
		this.child("fdbCodSubcuentaDesde").setDisabled(valor_disabled);
		this.child("fdbIdSubcuentaDesde").setDisabled(valor_disabled);
		this.child("fdbCodSubcuentaHasta").setDisabled(valor_disabled);
		this.child("fdbIdSubcuentaHasta").setDisabled(valor_disabled);
}

/** \D
Busca los códigos menor y mayor de los asientos del ejercicio y los introduce en los campos --d_co__asientos_numero-- y --h_co__asientos_numero--. A continuación deshabilita los campos de asiento
\end */
function oficial_todosAsientos()
{
		var codEjercicio:String = this.child("fdbEjercicio").value();

		var q:FLSqlQuery = new FLSqlQuery();
		q.setTablesList("co_asientos");
		q.setSelect("MIN(numero), MAX(numero)");
		q.setFrom("co_asientos");
		q.setWhere("codejercicio = '" + codEjercicio + "';");
		q.exec();

		if (q.first()) {

				var asientoInicio:Number = q.value(0);
				var asientoFin:Number = q.value(1);

				this.child("fdbAsientoDesde").setValue(asientoInicio);
				this.child("fdbAsientoHasta").setValue(asientoFin);

				this.child("fdbAsientoDesde").setDisabled(true);
				this.child("fdbAsientoHasta").setDisabled(true);
		}
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
