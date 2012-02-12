/***************************************************************************
                 ejercicios.qs  -  description
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
	function validateForm():Boolean {return this.ctx.interna_validateForm(); }
	function calculateCounter():String {return this.ctx.interna_calculateCounter(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	function oficial( context ) { interna( context ); }
	function buscarPlanContable(cursor:FLSqlCursor):Boolean {
		return this.ctx.oficial_buscarPlanContable(cursor);
	}
	function copiarSubcuentasCliProv(codEjFuente:String, codEjDestino:String):Boolean {
		return this.ctx.oficial_copiarSubcuentasCliProv(codEjFuente, codEjDestino);
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
    function pub_buscarPlanContable(cursor:FLSqlCursor):Boolean {
		return this.buscarPlanContable(cursor);
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
/** \C La fecha de inicio de un nuevo ejercicio será el día siguiente al fin del último ejercicio. Si no existen ejercicios, la fecha será la de inicio de año actual.

La fecha de fin por defecto será la fecha de fin del año de la fecha de inicio

Si el módulo de contabilidad está cargado, al dar de alta un nuevo ejercicio se busca el plan general contable asociado al mismo. De no encontrarlo se consulta si se desea crear un plan contable para el ejercicio o copiar uno ya existente. Si se selecciona copiar un plan anterior, se abre la ventana de ejercicios para escoger el ejercicio del cual se copiará el plan.
\end */
function interna_init()
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	if (cursor.modeAccess() == cursor.Insert) {
		var ultEjercicio:String = util.sqlSelect("ejercicios", "fechafin",
				" 1 = 1 ORDER BY fechafin DESC");
		if (ultEjercicio) {
				this.child("fdbFechaInicio").setValue(util.addDays(ultEjercicio, 1));
		} else {
				var hoy:Date = new Date()
				var fechaInicio:Date = new Date(hoy.getYear(), 1, 1);
				this.child("dedFechaInicio").setValue(fechaInicio);
		}
		var fechaInicio:Date = new Date(Date.parse(cursor.valueBuffer("fechainicio").toString().substring(0, 10)));
		var fechaFin:Date = new Date(fechaInicio.getYear(), 12, 31);
		this.child("fdbFechaFin").setValue(fechaFin);
	}
	if (cursor.modeAccess() == cursor.Edit){
		if(util.sqlSelect("co_epigrafes","idepigrafe","codejercicio = '" + cursor.valueBuffer("codejercicio") + "'"))
			this.child("fdbLongSubcuenta").setDisabled(true);
	}

	if (sys.isLoadedModule("flcontppal")) {
		this.child("tbwSecuencias").setTabEnabled("secuenciascon", true);
		this.child("tbwSecuencias").setTabEnabled("asientos", true);
	} else {
		this.child("tbwSecuencias").setTabEnabled("secuenciascon", false);
		this.child("tbwSecuencias").setTabEnabled("asientos", false);
	}
}

function interna_validateForm():Boolean
{
		var fechaInicio:String = this.child("fdbFechaInicio").value();
		var fechaFin:String = this.child("fdbFechaFin").value();
		var util:FLUtil = new FLUtil;

/** \C
La fecha de inicio del ejercicio debe ser menor que la de fin
\end */
		if (fechaInicio > fechaFin) {
				MessageBox.warning(util.translate("scripts", "La fecha de inicio del ejercicio debe ser menor que la de fin"),
						 MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				return false;
		}

/** \C
Al menos una secuencia por serie debe añadirse al ejercicio
\end */
		var cursor:FLSqlCursor = new FLSqlCursor("secuenciasejercicios");
		cursor.select("upper(codejercicio) = '" +
				this.cursor().valueBuffer("codejercicio").upper() + "';");
		if (!cursor.first()) {
				MessageBox.warning(util.translate("scripts", "Debe añadir al menos una secuencia para el ejercicio\nen \"Secuencias por serie\""), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				return false;
		}

/** \C
La longitud de la subcuenta debe estar entre 5 y 15 caracteres
\end */
	var longSubcuenta:Number = parseFloat(this.cursor().valueBuffer("longsubcuenta"));
	if (longSubcuenta < 5 || longSubcuenta > 15) {
		MessageBox.warning(util.translate("scripts", "La longitud de la subcuenta debe estar entre 5 y 15 caracteres"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	if (sys.isLoadedModule("flcontppal")) {
		if (!util.sqlSelect("co_epigrafes", "codejercicio", "codejercicio = '" + this.cursor().valueBuffer("codejercicio") + "'")) {
			MessageBox.information(util.translate("scripts", "Para generar el Plan General Contable asociado a este ejercicio use el botón 'PGC' del formulario maestro de ejercicios"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		}
	}
	return true;
}

function interna_calculateCounter():String
{
		var util:FLUtil = new FLUtil();
		return util.nextCounter("codejercicio", this.cursor());
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

/** \D Busca el plan general contable asociado al ejercicio actual. Si no lo encuentra da la opción de crear un nuevo plan o copiar uno ya existente
@param cursor Cursor del ejercicio actual
@return Verdadero si no hay error en la función, falso en caso contrario
\end */
function oficial_buscarPlanContable(cursor:FLSqlCursor):Boolean
{
	var ejercicio:String = cursor.valueBuffer("codejercicio");
	var logdigitos:Number = cursor.valueBuffer("longsubcuenta");
	var util:FLUtil = new FLUtil;
	//si el ejercicio no tiene ningun plan contable asignado
	if (!util.sqlSelect("co_epigrafes", "codejercicio", "codejercicio = '" + ejercicio + "'")) {
		if (util.sqlSelect("ejercicios", "count(codejercicio)", "1 = 1") == 1)
		{
			flcontppal.iface.pub_generarPGC(ejercicio);
			flcontppal.iface.pub_generarSubcuentas(ejercicio,logdigitos);
			return true;
		}

		var dialog:Object = new Dialog(util.translate("scripts", "Generar Plan Contable"), 0, "gerenarPGC");

		dialog.OKButtonText = util.translate ("scripts","Aceptar");
		dialog.cancelButtonText = util.translate ("scripts","Cancelar");

		var bgroup:Object = new GroupBox;
		dialog.add(bgroup);

		var nuevoPlan:Object = new RadioButton;
		nuevoPlan.text = util.translate ("scripts","Crear nuevo Plan General Contable");
		nuevoPlan.checked = true;
		bgroup.add(nuevoPlan);

		var anteriorPlan:Object = new RadioButton;
		anteriorPlan.text = util.translate ("scripts","Seleccionar un ejercicio anterior y copiar su Plan General Contable");
		anteriorPlan.checked = false;
		bgroup.add(anteriorPlan);

		if (!dialog.exec())
			return true;

		if (nuevoPlan.checked == true){
/** \D Si se selecciona crear un nuevo plan, se llama a flcontppal.generarPGC, que cargará el plan por defecto y lo asociará al ejercicio
\end */
			flcontppal.iface.pub_generarPGC(ejercicio);
			flcontppal.iface.pub_generarSubcuentas(ejercicio,logdigitos);
		}
		else {
/** \D Si se selecciona copiar un plan anterior, se abre la ventana de ejercicios para escoger el ejercicio del cual se copiará el plan. Los pasos seguidos son los siguientes:
\end */
			var idEpigrafe:Number;
			var idEpigrafeNuevo:Number;
			var idPadre:Number;
			var idPadreNuevo:Number;
			var idCuenta:Number;
			var idCuentaNueva:Number;
			var codEpigrafe:String;
			var codPadre:String;
			var f:Object = new FLFormSearchDB("ejercicios");
			f.setMainWidget();
			f.cursor().setMainFilter("codejercicio <> '" + ejercicio + "'");
			var ejeranterior:String = f.exec("codejercicio");

			if (!ejeranterior)
				return false;
			cursor.setValueBuffer("longsubcuenta", util.sqlSelect("ejercicios", "longsubcuenta", "codejercicio = '" + ejeranterior + "'"));
/** \D Se buscan los datos de la tabla epigrafes del ejercicio anterior y se insertan en el nuevo ejercicio
\end */
			var qryEpigrafe:FLSqlQuery = new FLSqlQuery;
			with(qryEpigrafe){
				setTablesList ("co_epigrafes,co_epigrafes");
				setSelect("e.idpadre,e.idepigrafe,e.codepigrafe,e.descripcion,p.codepigrafe");
				setFrom("co_epigrafes e LEFT OUTER JOIN co_epigrafes p ON e.idpadre = p.idepigrafe");
				setWhere("e.codejercicio = '" + ejeranterior +"'");
			}
			if (!qryEpigrafe.exec())
				return;

			var i:Number = 0;
			var j:Number = 0;

			var totalEpigrafes:Number = util.sqlSelect("co_epigrafes e LEFT OUTER JOIN co_epigrafes p ON e.idpadre = p.idepigrafe", "COUNT(e.idepigrafe)", "e.codejercicio = '" + ejeranterior + "'", "co_epigrafes");

			util.createProgressDialog(util.translate("scripts", "Copiando Plan General Contable"), totalEpigrafes);

			while(qryEpigrafe.next()){
				idPadre = qryEpigrafe.value(0);
				idEpigrafe = qryEpigrafe.value(1);
				codEpigrafe = qryEpigrafe.value(2);
				var curEpigrafe:FLSqlCursor = new FLSqlCursor ("co_epigrafes");
				curEpigrafe.setModeAccess (curEpigrafe.Insert);
				curEpigrafe.refreshBuffer();
				curEpigrafe.setValueBuffer("codejercicio",ejercicio);
				curEpigrafe.setValueBuffer("codepigrafe",codEpigrafe);
				curEpigrafe.setValueBuffer("descripcion",qryEpigrafe.value(3));
				if(idPadre) {
					idPadreNuevo = util.sqlSelect("co_epigrafes", "idepigrafe", "codepigrafe = '" + qryEpigrafe.value(4) + "'" + " AND codejercicio = '" + ejercicio + "'");
					curEpigrafe.setValueBuffer("idpadre",idPadreNuevo);
				}
				if (!curEpigrafe.commitBuffer())
					return false;
				idEpigrafeNuevo  = curEpigrafe.valueBuffer("idepigrafe");

/** \D	Para las cuentas existentes para cada epigrafe, el idepigrafe, el idpadre y el codepigrafe son el mismo que el de el epigrafe al que pertenecen
\end */
				var qryCuentas:FLSqlQuery = new FLSqlQuery;
				with(qryCuentas){
					setTablesList ("co_cuentas");
					setSelect("codcuenta,descripcion,idcuentaesp,codepigrafe,codbalance,idcuenta");
					setFrom("co_cuentas");
					setWhere("idepigrafe = " + idEpigrafe);
				}
				if (!qryCuentas.exec())
					return;
				while(qryCuentas.next()) {
					idCuenta = qryCuentas.value(5);
					var curCuentas:FLSqlCursor = new FLSqlCursor ("co_cuentas");
					curCuentas.setModeAccess (curCuentas.Insert);
					curCuentas.refreshBuffer();
					curCuentas.setValueBuffer("codejercicio",ejercicio);
					curCuentas.setValueBuffer("codcuenta",qryCuentas.value(0));
					curCuentas.setValueBuffer("idepigrafe",idEpigrafeNuevo);
					curCuentas.setValueBuffer("codepigrafe",qryCuentas.value(3));
					curCuentas.setValueBuffer("descripcion",qryCuentas.value(1));
					curCuentas.setValueBuffer("idcuentaesp",qryCuentas.value(2));
					curCuentas.setValueBuffer("codbalance",qryCuentas.value(4));
					curCuentas.commitBuffer();
					codigocuenta = qryCuentas.value(0);
/** \D Se busca el idcuenta que se genera para cada cuenta para posteriormente poderlo enlazar con las subcuentas
\end */
					idCuentaNueva = curCuentas.valueBuffer("idcuenta");
					var qrySubCuentas:FLSqlQuery = new FLSqlQuery;
/** \D Se busca	la subcuenta para cada cuenta encontrada con el mismo ejercicio e idcuenta
\end */
					with(qrySubCuentas){
						setTablesList ("co_subcuentas");
						setSelect("codsubcuenta,codcuenta,descripcion,coddivisa,codimpuesto,iva,recargo,idcuentaesp");
						setFrom("co_subcuentas");
						setWhere("idcuenta = " + idCuenta);
					}
					if (!qrySubCuentas.exec())
						return;
					while(qrySubCuentas.next()){
						var curSubCuentas:FLSqlCursor = new FLSqlCursor ("co_subcuentas");
						curSubCuentas.setModeAccess (curSubCuentas.Insert);
						curSubCuentas.refreshBuffer();
						curSubCuentas.setValueBuffer("codejercicio", ejercicio);
						curSubCuentas.setValueBuffer("codsubcuenta", qrySubCuentas.value(0));
						curSubCuentas.setValueBuffer("idcuenta", idCuentaNueva);
						curSubCuentas.setValueBuffer("codcuenta", qrySubCuentas.value(1));
						curSubCuentas.setValueBuffer("descripcion", qrySubCuentas.value(2));
						curSubCuentas.setValueBuffer("coddivisa", qrySubCuentas.value(3));
						curSubCuentas.setValueBuffer("codimpuesto", qrySubCuentas.value(4));
						curSubCuentas.setValueBuffer("iva", qrySubCuentas.value(5));
						curSubCuentas.setValueBuffer("idcuentaesp", qrySubCuentas.value(7));
						if (!curSubCuentas.commitBuffer())
							return;
					}
			}
				i++
				if (j++ > totalEpigrafes/10) {
					j = 0;
					util.setProgress(i);
				}
			}
			util.setProgress(totalEpigrafes);
			util.destroyProgressDialog();

			if (!this.iface.copiarSubcuentasCliProv(ejeranterior, ejercicio))
				return false;
		}
	}
	return true;
}

/** \D Copia las asociaciones subcuentas - clientes y subcuentas - proveedores de un ejercicio a otro
@param codEjFuente: Código del ejercicio desde el que se copiarán las asociaciones
@param codEjDestino: Código del ejercicio al que se copiarán las asociaciones
@return	True si la copia se realiza de forma correcta, false en caso contrario
*/
function oficial_copiarSubcuentasCliProv(codEjFuente:String, codEjDestino:String):Boolean
{
	var util:FLUtil = new FLUtil;

	var idSubcuenta:String;
	var paso:Number = 0;

	var qryCli:FLSqlQuery = new FLSqlQuery;
	qryCli.setTablesList("co_subcuentascli,clientes");
	qryCli.setSelect("s.codsubcuenta, s.codcliente, c.nombre");
	qryCli.setFrom("co_subcuentascli s INNER JOIN clientes c ON s.codcliente = c.codcliente");
	qryCli.setWhere("s.codejercicio = '" + codEjFuente + "'");
	qryCli.setForwardOnly(true);
	if (!qryCli.exec()) {
		return false;
	}

	util.createProgressDialog(util.translate("scripts", "Copiando subcuentas por cliente"), qryCli.size());
	util.setProgress(0);
	while (qryCli.next()) {
		idSubcuenta = flfactppal.iface.pub_crearSubcuenta(qryCli.value(0), qryCli.value(2), "CLIENT", codEjDestino);
		if (!idSubcuenta)
			return false;
		if (!flfactppal.iface.pub_crearSubcuentaCli(qryCli.value(0), idSubcuenta, qryCli.value(1), codEjDestino))
			return false;
		util.setProgress(paso++);
	}
	util.setProgress(qryCli.size());
	util.destroyProgressDialog();

	var qryProv:FLSqlQuery = new FLSqlQuery;
	qryProv.setTablesList("co_subcuentasprov,proveedores");
	qryProv.setSelect("s.codsubcuenta, s.codproveedor, p.nombre");
	qryProv.setFrom("co_subcuentasprov s INNER JOIN proveedores p ON s.codproveedor = p.codproveedor");
	qryProv.setWhere("s.codejercicio = '" + codEjFuente + "'");
	qryProv.setForwardOnly(true);
	if (!qryProv.exec()) {
		return false;
	}

	util.createProgressDialog(util.translate("scripts", "Copiando subcuentas por proveedor"), qryProv.size());
	util.setProgress(0);
	while (qryProv.next()) {
		idSubcuenta = flfactppal.iface.pub_crearSubcuenta(qryProv.value(0), qryProv.value(2), "PROVEE", codEjDestino);
		if (!idSubcuenta)
			return false;
		if (!flfactppal.iface.pub_crearSubcuentaProv(qryProv.value(0), idSubcuenta, qryProv.value(1), codEjDestino))
			return false;
		util.setProgress(paso++);
	}
	util.setProgress(qryProv.size());
	util.destroyProgressDialog();

	return true;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

