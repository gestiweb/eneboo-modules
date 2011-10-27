/***************************************************************************
                 co_i_mayor.qs  -  description
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
En modo inserción aparece ejercicio es el actual. El campos --todassubcuentas-- aparece marcado, mostrando el intervalo total de subcuentas
\end */
function interna_init()
{
	this.iface.cuentaHastaInformada = false;
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	this.iface.ejercicioActual = flfactppal.iface.pub_ejercicioActual();
	this.iface.posActualPuntoSubcuentaH = -1;
	this.iface.posActualPuntoSubcuentaD = -1;

	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");

	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList("ejercicios");
	q.setSelect("longsubcuenta, fechainicio, fechafin");
	q.setFrom("ejercicios");
	q.setWhere("codejercicio = '" + this.iface.ejercicioActual + "';");
	q.exec();

	if (q.next()) {
		this.iface.longSubcuenta = q.value(0);
	}

	if (cursor.modeAccess() == cursor.Insert) {
		this.child("fdbEjercicio").setValue(this.iface.ejercicioActual);
		this.iface.todasSubcuentas();
	}

	if (cursor.modeAccess() == cursor.Edit) {
		if (this.child("fdbTodasSubcuentas").value())
			this.iface.todasSubcuentas();
	}
}

/** \C 
La fecha de inicio del período del ejercicio no puede ser posterior a la fecha de fin. Las fechas deben estar comprendidas dentro del período del ejercicio.

El código de la subcuenta inicial no puede ser superior al de la subcuenta final
\end */
function interna_validateForm():Boolean
{
		var fechaInicio:String = this.child("fdbFechaDesde").value();
		var fechaFin:String = this.child("fdbFechaHasta").value();

		var subcuentaInicio:String = this.child("fdbCodSubcuentaDesde").value();
		var subcuentaFin:String = this.child("fdbCodSubcuentaHasta").value();

		var util:FLUtil = new FLUtil();

		if (util.daysTo(fechaInicio, fechaFin) < 0) {
				MessageBox.critical
						(util.
						 translate("scripts",
											 "La fecha de inicio debe ser menor que la de fin"),
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

/**	\C
Al introducir el código de subcuenta inicial, si el usuario pulsa la tecla "punto" (.), la subcuenta se informa automaticamente con el código de cuenta más tantos ceros como sea necesario para completar la longitud de subcuenta asociada al ejercicio actual.
\end \end */
		case "d_co__subcuentas_codsubcuenta":

				if (!this.iface.bloqueoSubcuenta) {
					this.iface.cuentaHastaInformada = true;
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
Al introducir --i_co__subcuentas_codejercicio--, aparecen las fechas de inicio y fin del ejercicio seleccionado.
\end \end */
		case "i_co__subcuentas_codejercicio":

				var codEjercicio = this.child("fdbEjercicio").value();

				var q:FLSqlQuery = new FLSqlQuery();
				q.setTablesList("ejercicios");
				q.setSelect("longsubcuenta, fechainicio, fechafin");
				q.setFrom("ejercicios");
				q.setWhere("codejercicio = '" + codEjercicio + "';");
				q.exec();

				if (q.next()) {
						this.iface.longSubcuenta = q.value(0);
						var fechaDesde:String = q.value(1);
						var fechaHasta:String = q.value(2);

				}

				break;

/** \C
Al pulsar sobre --todassubcuentas-- aparece como subcuenta inicial la de menor código y como subcuenta final la de mayor código.
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
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
