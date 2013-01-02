/***************************************************************************
                 flrrhhppal.qs  -  description
                             -------------------
    begin                : mie jul 25 2007
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

/** @class_declaration interna */
////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
class interna {
	var ctx:Object;
	function interna( context ) { this.ctx = context; }
	function beforeCommit_rh_nominas(curNomina:FLSqlCursor):Boolean {
		return this.ctx.interna_beforeCommit_rh_nominas(curNomina);
	}
	function beforeCommit_rh_pagosnomina(curPN:FLSqlCursor):Boolean {
		return this.ctx.interna_beforeCommit_rh_pagosnomina(curPN);
	}
	function beforeCommit_rh_retenciones(curRetencion:FLSqlCursor):Boolean {
		return this.ctx.interna_beforeCommit_rh_retenciones(curRetencion);
	}
	function beforeCommit_rh_recibossegsocial(curRSS:FLSqlCursor):Boolean {
		return this.ctx.interna_beforeCommit_rh_recibossegsocial(curRSS);
	}
	function beforeCommit_rh_dietas(curDieta:FLSqlCursor):Boolean {
		return this.ctx.interna_beforeCommit_rh_dietas(curDieta);
	}
	function afterCommit_rh_nominas(curNomina:FLSqlCursor):Boolean {
		return this.ctx.interna_afterCommit_rh_nominas(curNomina);
	}
	function afterCommit_rh_pagosnomina(curPN:FLSqlCursor):Boolean {
		return this.ctx.interna_afterCommit_rh_pagosnomina(curPN);
	}
	function afterCommit_rh_retenciones(curRetencion:FLSqlCursor):Boolean {
		return this.ctx.interna_afterCommit_rh_retenciones(curRetencion);
	}
	function afterCommit_rh_recibossegsocial(curRSS:FLSqlCursor):Boolean {
		return this.ctx.interna_afterCommit_rh_recibossegsocial(curRSS);
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	function oficial( context ) { interna( context ); }
	function generarAsientoNomina(curNomina:FLSqlCursor):Boolean {
		return this.ctx.oficial_generarAsientoNomina(curNomina);
	}
	function generarAsientoPagosNomina(curPN:FLSqlCursor):Boolean {
		return this.ctx.oficial_generarAsientoPagosNomina(curPN);
	}
	function generarAsientoRetencion(curRetencion:FLSqlCursor):Boolean {
		return this.ctx.oficial_generarAsientoRetencion(curRetencion);
	}
	function generarAsientoRSS(curRSS:FLSqlCursor):Boolean {
		return this.ctx.oficial_generarAsientoRSS(curRSS);
	}
	function generarPartidasRetencionIRPF(curRetencion:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean {
		return this.ctx.oficial_generarPartidasRetencionIRPF(curRetencion, idAsiento, valoresDefecto);
	}
	function generarPartidasCuentaEmpresa(curRetencion:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean {
		return this.ctx.oficial_generarPartidasCuentaEmpresa(curRetencion, idAsiento, valoresDefecto);
	}
	function generarPartidasAportacionSS(curRSS:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean {
		return this.ctx.oficial_generarPartidasAportacionSS(curRSS, idAsiento, valoresDefecto);
	}
	function generarPartidasCuentaEmpresaSS(curRSS:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean {
		return this.ctx.oficial_generarPartidasCuentaEmpresaSS(curRSS, idAsiento, valoresDefecto);
	}
	function generarPartidasDiferenciaSS(curRSS:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean {
		return this.ctx.oficial_generarPartidasDiferenciaSS(curRSS, idAsiento, valoresDefecto);
	}
	function generarPartidasSueldoBruto(curNomina:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean {
		return this.ctx.oficial_generarPartidasSueldoBruto(curNomina, idAsiento, valoresDefecto);
	}
	function generarPartidasSeguridadSocial(curNomina:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean {
		return this.ctx.oficial_generarPartidasSeguridadSocial(curNomina, idAsiento, valoresDefecto);
	}
	function generarPartidasIRPF(curNomina:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean {
		return this.ctx.oficial_generarPartidasIRPF(curNomina, idAsiento, valoresDefecto);
	}
	function generarPartidasDietas(curNomina:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean {
		return this.ctx.oficial_generarPartidasDietas(curNomina, idAsiento, valoresDefecto);
	}
	function generarPartidasNominaEmpleado(curNomina:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean {
		return this.ctx.oficial_generarPartidasNominaEmpleado(curNomina, idAsiento, valoresDefecto);
	}
	function generarPartidasPagosNominaEmpleado(curPN:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean {
		return this.ctx.oficial_generarPartidasPagosNominaEmpleado(curPN, idAsiento, valoresDefecto);
	}
	function generarPartidasEmpresa(curPN:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean {
		return this.ctx.oficial_generarPartidasEmpresa(curPN, idAsiento, valoresDefecto);
	}
	function datosPartidaNomina(curPartida:FLSqlCursor, curNomina:FLSqlCursor):Array {
		return this.ctx.oficial_datosPartidaNomina(curPartida, curNomina);
	}
	function datosPartidaRetencionIRPF(curPartida:FLSqlCursor,curRetencion:FLSqlCursor) {
		return this.ctx.oficial_datosPartidaRetencionIRPF(curPartida, curRetencion);
	}
	function datosPartidaReciboSegSocial(curPartida:FLSqlCursor, curRSS:FLSqlCursor) {
		return this.ctx.oficial_datosPartidaReciboSegSocial(curPartida, curRSS);
	}
	function datosPartidaPagosNomina(curPartida:FLSqlCursor, curPN:FLSqlCursor):Array {
		return this.ctx.oficial_datosPartidaPagosNomina(curPartida, curPN);
	}
	function datosCtaEspecial(ctaEsp:String, codEjercicio:String):Array {
		return this.ctx.oficial_datosCtaEspecial(ctaEsp, codEjercicio);
	}
	function regenerarAsiento(curNomina:FLSqlCursor, valoresDefecto:Array):Array {
		return this.ctx.oficial_regenerarAsiento(curNomina, valoresDefecto);
	}
	function asientoBorrable(idAsiento:Number):Boolean {
		return this.ctx.oficial_asientoBorrable(idAsiento);
	}
	function eliminarAsiento(idAsiento:String):Boolean {
		return this.ctx.oficial_eliminarAsiento(idAsiento);
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

/** \C En el caso de que el módulo de contabilidad esté cargado y activado, genera o modifica el asiento contable correspondiente a la nómina del empleado.
\end */
function interna_beforeCommit_rh_nominas(curNomina:FLSqlCursor):Boolean
{
	if (sys.isLoadedModule("flcontppal") && flfactppal.iface.pub_valorDefectoEmpresa("contintegrada")) {
		if (this.iface.generarAsientoNomina(curNomina) == false)
			return false;
	}
	
	return true;
}

/** \C En el caso de que el módulo de contabilidad esté cargado y activado, genera o modifica el asiento contable correspondiente al pago de la nómina del empleado.
\end */
function interna_beforeCommit_rh_pagosnomina(curPN:FLSqlCursor):Boolean
{
	if (sys.isLoadedModule("flcontppal") && flfactppal.iface.pub_valorDefectoEmpresa("contintegrada")) {
		if (this.iface.generarAsientoPagosNomina(curPN) == false)
			return false;
	}
	
	return true;
}

/** \C En el caso de que el módulo de contabilidad esté cargado y activado, genera o modifica el asiento contable correspondiente al pago de la retención de IRPF.
\end */
function interna_beforeCommit_rh_retenciones(curRetencion:FLSqlCursor):Boolean
{
	if (sys.isLoadedModule("flcontppal") && flfactppal.iface.pub_valorDefectoEmpresa("contintegrada")) {
		if (this.iface.generarAsientoRetencion(curRetencion) == false)
			return false;
	}

	return true;
}

/** \C En el caso de que el módulo de contabilidad esté cargado y activado, genera o modifica el asiento contable correspondiente al pago de las aportaciones a la Seguridad Social.
\end */
function interna_beforeCommit_rh_recibossegsocial(curRSS:FLSqlCursor):Boolean
{
	if (sys.isLoadedModule("flcontppal") && flfactppal.iface.pub_valorDefectoEmpresa("contintegrada")) {
		if (this.iface.generarAsientoRSS(curRSS) == false)
			return false;
	}

	return true;
}

/** \C En el caso de que el módulo pincipal de contabilidad esté cargado y activado, y que la acción a realizar sea la de borrado de la nómina, borra el asiento contable correspondiente.
\end */
function interna_afterCommit_rh_nominas(curNomina:FLSqlCursor):Boolean
{
	var util:FLUtil;

	if (sys.isLoadedModule("flcontppal") && flfactppal.iface.pub_valorDefectoEmpresa("contintegrada")) {
		switch (curNomina.modeAccess()) {
			case curNomina.Del: {
				if (!this.iface.eliminarAsiento(curNomina.valueBuffer("idasiento")))
					return false;
				break;
			}
			case curNomina.Edit: {
				if (curNomina.valueBuffer("nogenerarasiento")) {
					var idAsientoAnterior:String = curNomina.valueBufferCopy("idasiento");
					if (idAsientoAnterior && idAsientoAnterior != "") {
						if (!this.iface.eliminarAsiento(idAsientoAnterior))
							return false;
					}
				}
				break;
			}
		}
	}
	
	return true;
}

/** \C En el caso de que el módulo pincipal de contabilidad esté cargado y activado, y que la acción a realizar sea la de borrado del pago de la nómina, borra el asiento contable correspondiente.
\end */
function interna_afterCommit_rh_pagosnomina(curPN:FLSqlCursor):Boolean
{
	var util:FLUtil;

	if (sys.isLoadedModule("flcontppal") && flfactppal.iface.pub_valorDefectoEmpresa("contintegrada")) {
		switch (curPN.modeAccess()) {
			case curPN.Del: {
				if (!this.iface.eliminarAsiento(curPN.valueBuffer("idasiento")))
					return false;
				break;
			}
		}
	}
	
	return true;
}

/** \C En el caso de que el módulo pincipal de contabilidad esté cargado y activado, y que la acción a realizar sea la de borrado de la retencion, borra el asiento contable correspondiente.
\end */
function interna_afterCommit_rh_retenciones(curRetencion:FLSqlCursor):Boolean
{
	var util:FLUtil;

	if (sys.isLoadedModule("flcontppal") && flfactppal.iface.pub_valorDefectoEmpresa("contintegrada")) {
		switch (curRetencion.modeAccess()) {
			case curRetencion.Del: {
				if (!this.iface.eliminarAsiento(curRetencion.valueBuffer("idasiento")))
					return false;
				break;
			}
		}
	}

	return true;
}

/** \C En el caso de que el módulo pincipal de contabilidad esté cargado y activado, y que la acción a realizar sea la de borrado del recibo de aportación a la Seguridad Social, borra el asiento contable correspondiente.
\end */
function interna_afterCommit_rh_recibossegsocial(curRSS:FLSqlCursor):Boolean
{
	var util:FLUtil;

	if (sys.isLoadedModule("flcontppal") && flfactppal.iface.pub_valorDefectoEmpresa("contintegrada")) {
		switch (curRSS.modeAccess()) {
			case curRSS.Del: {
				if (!this.iface.eliminarAsiento(curRSS.valueBuffer("idasiento")))
					return false;
				break;
			}
		}
	}

	return true;
}

/** \C Una vez asociadas a una nómina, las dietas sólo se pueden borrar y modificar desde el formulario de edición de dicha nómina
\end */
function interna_beforeCommit_rh_dietas(curDieta:FLSqlCursor):Boolean
{
	var util:FLUtil;

	var codNomina:String = curDieta.valueBuffer("codnomina");
	var curRelation:FLSqlCursor = curDieta.cursorRelation();
	if (!curRelation) {
		if (codNomina && codNomina != "") {
			switch (curDieta.modeAccess()) {
				case curDieta.Edit: {
					if (codNomina == curDieta.valueBufferCopy("codnomina")) {
						MessageBox.warning(util.translate("scripts", "La dieta seleccionada está asociada a la nómina %1.\nPara mantener actualizado el correspondiente asiento contable debe modificar esta dieta desde el formulario de nóminas").arg(codNomina), MessageBox.Ok, MessageBox.NoButton);
						return false;
					}
					break;
				}
				case curDieta.Del: {
					MessageBox.warning(util.translate("scripts", "La dieta seleccionada está asociada a la nómina %1.\nPara mantener actualizado el correspondiente asiento contable debe modificar esta dieta desde el formulario de nóminas").arg(codNomina), MessageBox.Ok, MessageBox.NoButton);
					return false;
					break;
				}
				
			}
		}
	}
	return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

/** \U Genera o regenera el asiento correspondiente a una nómina de empleado
@param	curNomina: Cursor con los datos de la nómina
@return	VERDADERO si no hay error. FALSO en otro caso
\end */
function oficial_generarAsientoNomina(curNomina:FLSqlCursor):Boolean
{
	if (curNomina.modeAccess() != curNomina.Insert && curNomina.modeAccess() != curNomina.Edit)
		return true;

	var util:FLUtil = new FLUtil;
	if (curNomina.valueBuffer("nogenerarasiento")) {
		curNomina.setNull("idasiento");
		return true;
	}

	var datosAsiento:Array = [];
	var valoresDefecto:Array;
	valoresDefecto["codejercicio"] = curNomina.valueBuffer("codejercicio");
	valoresDefecto["coddivisa"] = flfactppal.iface.pub_valorDefectoEmpresa("coddivisa");

	datosAsiento = this.iface.regenerarAsiento(curNomina, valoresDefecto);
	if (datosAsiento.error == true)
		return false;

	if (!this.iface.generarPartidasSueldoBruto(curNomina, datosAsiento.idasiento, valoresDefecto))
		return false;

	if (!this.iface.generarPartidasIRPF(curNomina, datosAsiento.idasiento, valoresDefecto))
		return false;

	if (!this.iface.generarPartidasSeguridadSocial(curNomina, datosAsiento.idasiento, valoresDefecto))
		return false;

	if (!this.iface.generarPartidasDietas(curNomina, datosAsiento.idasiento, valoresDefecto))
		return false;

	if (!this.iface.generarPartidasNominaEmpleado(curNomina, datosAsiento.idasiento, valoresDefecto))
		return false;

	curNomina.setValueBuffer("idasiento", datosAsiento.idasiento);

	if (!flcontppal.iface.pub_comprobarAsiento(datosAsiento.idasiento))
		return false;

	return true;
}

/** \U Genera o regenera el asiento correspondiente al pago de una nómina de empleado
@param	curPN: Cursor con los datos del pago de la nómina
@return	VERDADERO si no hay error. FALSO en otro caso
\end */
function oficial_generarAsientoPagosNomina(curPN:FLSqlCursor):Boolean
{
	if (curPN.modeAccess() != curPN.Insert && curPN.modeAccess() != curPN.Edit)
		return true;

	var util:FLUtil = new FLUtil;
// 	if (curPN.valueBuffer("nogenerarasiento")) {
// 		curPN.setNull("idasiento");
// 		return true;
// 	}

	var datosAsiento:Array = [];
	var valoresDefecto:Array;
	valoresDefecto["codejercicio"] = util.sqlSelect("rh_nominas","codejercicio","codnomina = '" + curPN.valueBuffer("codnomina") + "'");
	if (!valoresDefecto["codejercicio"] || valoresDefecto["codejercicio"] == "")
		return false;
	valoresDefecto["coddivisa"] = flfactppal.iface.pub_valorDefectoEmpresa("coddivisa");

	datosAsiento = this.iface.regenerarAsiento(curPN, valoresDefecto);
	if (datosAsiento.error == true)
		return false;

	if (!this.iface.generarPartidasPagosNominaEmpleado(curPN, datosAsiento.idasiento, valoresDefecto))
		return false;

	if (!this.iface.generarPartidasEmpresa(curPN, datosAsiento.idasiento, valoresDefecto))
		return false;

	curPN.setValueBuffer("idasiento", datosAsiento.idasiento);
	
	if (!flcontppal.iface.pub_comprobarAsiento(datosAsiento.idasiento))
		return false;

	return true;
}

/** \U Genera o regenera el asiento correspondiente a la retención de IRPF
@param	curRetencion: Cursor con los datos de la retencion
@return	VERDADERO si no hay error. FALSO en otro caso
\end */
function oficial_generarAsientoRetencion(curRetencion:FLSqlCursor):Boolean
{
	if (curRetencion.modeAccess() != curRetencion.Insert && curRetencion.modeAccess() != curRetencion.Edit)
		return true;

	var util:FLUtil = new FLUtil;

	var datosAsiento:Array = [];
	var valoresDefecto:Array;
	valoresDefecto["codejercicio"] = curRetencion.valueBuffer("codejercicio") /*util.sqlSelect("rh_retenciones","codejercicio","idretencion = " + curRetencion.valueBuffer("idretencion"));*/
	if (!valoresDefecto["codejercicio"] || valoresDefecto["codejercicio"] == "")
		return false;

	valoresDefecto["coddivisa"] = flfactppal.iface.pub_valorDefectoEmpresa("coddivisa");

	datosAsiento = this.iface.regenerarAsiento(curRetencion, valoresDefecto);
	if (datosAsiento.error == true)
		return false;

	if (!this.iface.generarPartidasRetencionIRPF(curRetencion, datosAsiento.idasiento, valoresDefecto))
		return false;

	if (!this.iface.generarPartidasCuentaEmpresa(curRetencion, datosAsiento.idasiento, valoresDefecto))
		return false;

	curRetencion.setValueBuffer("idasiento", datosAsiento.idasiento);
	
	if (!flcontppal.iface.pub_comprobarAsiento(datosAsiento.idasiento))
		return false;

	return true;
}

/** \U Genera o regenera el asiento correspondiente a las aportaciones a la Seguridad Social
@param	curRSS: Cursor con los datos del recibo
@return	VERDADERO si no hay error. FALSO en otro caso
\end */
function oficial_generarAsientoRSS(curRSS:FLSqlCursor):Boolean
{
	if (curRSS.modeAccess() != curRSS.Insert && curRSS.modeAccess() != curRSS.Edit)
		return true;

	var util:FLUtil = new FLUtil;

	var datosAsiento:Array = [];
	var valoresDefecto:Array;
	valoresDefecto["codejercicio"] = curRSS.valueBuffer("codejercicio"); /*util.sqlSelect("rh_recibossegsocial","codejercicio","codrecibo = '" + curRSS.valueBuffer("codrecibo") + "'");*/
	if (!valoresDefecto["codejercicio"] || valoresDefecto["codejercicio"] == "")
		return false;

	valoresDefecto["coddivisa"] = flfactppal.iface.pub_valorDefectoEmpresa("coddivisa");

	datosAsiento = this.iface.regenerarAsiento(curRSS, valoresDefecto);
	if (datosAsiento.error == true)
		return false;

	if (!this.iface.generarPartidasAportacionSS(curRSS, datosAsiento.idasiento, valoresDefecto))
		return false;

	if (!this.iface.generarPartidasCuentaEmpresaSS(curRSS, datosAsiento.idasiento, valoresDefecto))
		return false;

	if (!this.iface.generarPartidasDiferenciaSS(curRSS, datosAsiento.idasiento, valoresDefecto))
		return false;

	curRSS.setValueBuffer("idasiento", datosAsiento.idasiento);
	
	if (!flcontppal.iface.pub_comprobarAsiento(datosAsiento.idasiento))
		return false;

	return true;
}

/** \D Genera la parte del asiento correspondiente a la subcuenta de retencion de IRPF
@param	curRetencion: Cursor de la retencion
@param	idAsiento: Id del asiento asociado
@param	valoresDefecto: Array con los valores por defecto de ejercicio y divisa
@return	VERDADERO si no hay error, FALSO en otro caso
\end */
function oficial_generarPartidasRetencionIRPF(curRetencion:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean
{
	var util:FLUtil = new FLUtil();
	var irpf:Number = parseFloat(curRetencion.valueBuffer("total"));
	if (irpf == 0)
		return true;
	var debe:Number = 0;
	var debeME:Number = 0;
	var ctaIrpf:Array = this.iface.datosCtaEspecial("NO_IR", valoresDefecto.codejercicio);
	if (ctaIrpf.error != 0) {
		MessageBox.warning(util.translate("scripts", "No tiene ninguna cuenta contable marcada como cuenta especial\nNO_IR.\nDebe asociar la cuenta a la cuenta especial en el módulo Principal del área Financiera"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	debe = irpf;
	debeME = 0;
	debe = util.roundFieldValue(debe, "co_partidas", "debe");
	debeME = util.roundFieldValue(debeME, "co_partidas", "debeme");

	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
	with (curPartida) {
		setModeAccess(curPartida.Insert);
		refreshBuffer();
		setValueBuffer("idsubcuenta", ctaIrpf.idsubcuenta);
		setValueBuffer("codsubcuenta", ctaIrpf.codsubcuenta);
		setValueBuffer("idasiento", idAsiento);
		setValueBuffer("debe", debe);
		setValueBuffer("haber", 0);
		setValueBuffer("debeME", debeME);
		setValueBuffer("haberME", 0);
	}
		
	this.iface.datosPartidaRetencionIRPF(curPartida, curRetencion)
		
	if (!curPartida.commitBuffer())
		return false;

	return true;
}

/** \D Genera la parte del asiento correspondiente a la cuenta de la empresa
@param	curRetencion: Cursor de la retencion
@param	idAsiento: Id del asiento asociado
@param	valoresDefecto: Array con los valores por defecto de ejercicio y divisa
@return	VERDADERO si no hay error, FALSO en otro caso
\end */
function oficial_generarPartidasCuentaEmpresa(curRetencion:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean
{
	var util:FLUtil = new FLUtil();
	var total:Number = parseFloat(curRetencion.valueBuffer("total"));
	if (total == 0)
		return true;
	var ctaHaber:Array = [];
	ctaHaber.codsubcuenta = util.sqlSelect("cuentasbanco","codsubcuenta","codcuenta = '" + curRetencion.valueBuffer("codcuenta") + "'");

	if (!ctaHaber.codsubcuenta || ctaHaber.codsubcuenta == "") {
		MessageBox.warning(util.translate("scripts", "Debe establecer la cuenta de la empresa"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	ctaHaber.idsubcuenta = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + ctaHaber.codsubcuenta + "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
	if (!ctaHaber.idsubcuenta) {
		MessageBox.warning(util.translate("scripts", "No tiene definida la subcuenta %1 en el ejercicio %2.\nAntes de dar el pago debe crear la subcuenta o modificar el ejercicio").arg(ctaHaber.codsubcuenta).arg(valoresDefecto.codejercicio), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var haber:Number = 0;
	var haberME:Number = 0;
	haber = total;
	haberME = 0;
	haber = util.roundFieldValue(haber, "co_partidas", "haber");
	haberME = util.roundFieldValue(haberME, "co_partidas", "haberme");

	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
	with(curPartida) {
		setModeAccess(curPartida.Insert);
		refreshBuffer();
		setValueBuffer("idsubcuenta", ctaHaber.idsubcuenta);
		setValueBuffer("codsubcuenta", ctaHaber.codsubcuenta);
		setValueBuffer("idasiento", idAsiento);
		setValueBuffer("debe", 0);
		setValueBuffer("haber", haber);
		setValueBuffer("debeME", 0);
		setValueBuffer("haberME", haberME);
	}

	this.iface.datosPartidaRetencionIRPF(curPartida, curRetencion)

	if (!curPartida.commitBuffer())
		return false;

	return true;
}

/** \D Genera la parte del asiento correspondiente a la aportacion a la seguridad social
@param	curRSS: Cursor del recibo
@param	idAsiento: Id del asiento asociado
@param	valoresDefecto: Array con los valores por defecto de ejercicio y divisa
@return	VERDADERO si no hay error, FALSO en otro caso
\end */
function oficial_generarPartidasAportacionSS(curRSS:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean
{
	var util:FLUtil = new FLUtil();
	var totalNominas:Number = parseFloat(curRSS.valueBuffer("totalnominas"));
	if (totalNominas == 0)
		return true;
	var debe:Number = 0;
	var debeME:Number = 0;
	var ctaASS:Array = this.iface.datosCtaEspecial("NO_ASS", valoresDefecto.codejercicio);
	if (ctaASS.error != 0) {
		MessageBox.warning(util.translate("scripts", "No tiene ninguna cuenta contable marcada como cuenta especial\nNO_ASS.\nDebe asociar la cuenta a la cuenta especial en el módulo Principal del área Financiera"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	debe = totalNominas;
	debeME = 0;
	debe = util.roundFieldValue(debe, "co_partidas", "debe");
	debeME = util.roundFieldValue(debeME, "co_partidas", "debeme");
	
	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
	with (curPartida) {
		setModeAccess(curPartida.Insert);
		refreshBuffer();
		setValueBuffer("idsubcuenta", ctaASS.idsubcuenta);
		setValueBuffer("codsubcuenta", ctaASS.codsubcuenta);
		setValueBuffer("idasiento", idAsiento);
		setValueBuffer("debe", debe);
		setValueBuffer("haber", 0);
		setValueBuffer("debeME", debeME);
		setValueBuffer("haberME", 0);
	}
		
	this.iface.datosPartidaReciboSegSocial(curPartida, curRSS)
		
	if (!curPartida.commitBuffer())
		return false;

	return true;
}

/** \D Genera la parte del asiento correspondiente a la cuenta de la empresa
@param	curRSS: Cursor del recibo
@param	idAsiento: Id del asiento asociado
@param	valoresDefecto: Array con los valores por defecto de ejercicio y divisa
@return	VERDADERO si no hay error, FALSO en otro caso
\end */
function oficial_generarPartidasCuentaEmpresaSS(curRSS:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean
{
	var util:FLUtil = new FLUtil();
	var total:Number = parseFloat(curRSS.valueBuffer("total"));
	if (total == 0)
		return true;
	var ctaHaber:Array = [];
	ctaHaber.codsubcuenta = util.sqlSelect("cuentasbanco","codsubcuenta","codcuenta = '" + curRSS.valueBuffer("codcuenta") + "'");

	if (!ctaHaber.codsubcuenta || ctaHaber.codsubcuenta == "") {
		MessageBox.warning(util.translate("scripts", "Debe establecer la cuenta de la empresa"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	ctaHaber.idsubcuenta = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + ctaHaber.codsubcuenta + "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
	if (!ctaHaber.idsubcuenta) {
		MessageBox.warning(util.translate("scripts", "No tiene definida la subcuenta %1 en el ejercicio %2.\nAntes de dar el pago debe crear la subcuenta o modificar el ejercicio").arg(ctaHaber.codsubcuenta).arg(valoresDefecto.codejercicio), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var haber:Number = 0;
	var haberME:Number = 0;
	haber = total;
	haberME = 0;
	haber = util.roundFieldValue(haber, "co_partidas", "haber");
	haberME = util.roundFieldValue(haberME, "co_partidas", "haberme");
	
	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
	with(curPartida) {
		setModeAccess(curPartida.Insert);
		refreshBuffer();
		setValueBuffer("idsubcuenta", ctaHaber.idsubcuenta);
		setValueBuffer("codsubcuenta", ctaHaber.codsubcuenta);
		setValueBuffer("idasiento", idAsiento);
		setValueBuffer("debe", 0);
		setValueBuffer("haber", haber);
		setValueBuffer("debeME", 0);
		setValueBuffer("haberME", haberME);
	}

	this.iface.datosPartidaReciboSegSocial(curPartida, curRSS)

	if (!curPartida.commitBuffer())
		return false;

	return true;
}

/** \D Genera la parte del asiento correspondiente a la diferencia de seguros sociales
@param	curRSS: Cursor del recibo
@param	idAsiento: Id del asiento asociado
@param	valoresDefecto: Array con los valores por defecto de ejercicio y divisa
@return	VERDADERO si no hay error, FALSO en otro caso
\end */
function oficial_generarPartidasDiferenciaSS(curRSS:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean
{
	var util:FLUtil = new FLUtil();
	var resto:Number = parseFloat(curRSS.valueBuffer("resto"));
	if (resto == 0)
		return true;
	var debe:Number = 0;
	var debeME:Number = 0;
	var ctaDSS:Array = this.iface.datosCtaEspecial("NO_DSS", valoresDefecto.codejercicio);
	if (ctaDSS.error != 0) {
		MessageBox.warning(util.translate("scripts", "No tiene ninguna cuenta contable marcada como cuenta especial\nNO_DSS.\nDebe asociar la cuenta a la cuenta especial en el módulo Principal del área Financiera"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	debe = resto;
	debeME = 0;
	debe = util.roundFieldValue(debe, "co_partidas", "debe");
	debeME = util.roundFieldValue(debeME, "co_partidas", "debeme");

	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
	with (curPartida) {
		setModeAccess(curPartida.Insert);
		refreshBuffer();
		setValueBuffer("idsubcuenta", ctaDSS.idsubcuenta);
		setValueBuffer("codsubcuenta", ctaDSS.codsubcuenta);
		setValueBuffer("idasiento", idAsiento);
		setValueBuffer("debe", debe);
		setValueBuffer("haber", 0);
		setValueBuffer("debeME", debeME);
		setValueBuffer("haberME", 0);
	}
		
	this.iface.datosPartidaReciboSegSocial(curPartida, curRSS)
		
	if (!curPartida.commitBuffer())
		return false;

	return true;
}

/** \D Genera la parte del asiento de nómina correspondiente a la subcuenta de sueldo bruto
@param	curNomina: Cursor de la nómina
@param	idAsiento: Id del asiento asociado
@param	valoresDefecto: Array con los valores por defecto de ejercicio y divisa
@return	VERDADERO si no hay error, FALSO en otro caso
\end */
function oficial_generarPartidasSueldoBruto(curNomina:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean
{
	var util:FLUtil = new FLUtil();
	var sueldoBruto:Number = parseFloat(curNomina.valueBuffer("sueldobruto"));
	if (sueldoBruto == 0)
		return true;
	var ctaSueldoBruto:Array = this.iface.datosCtaEspecial("NO_SB",valoresDefecto.codejercicio);
	if (ctaSueldoBruto.error != 0) {
		MessageBox.warning(util.translate("scripts", "No se ha encontrado una subcuenta de sueldo bruto para esta nómina.\nCompruebe que existe la cuenta especial NO_SB asociada a una subcuenta."), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var debe:Number = 0;
	var debeME:Number = 0;

	debe = sueldoBruto;
	debeME = 0;
	debe = util.roundFieldValue(debe, "co_partidas", "debe");
	debeME = util.roundFieldValue(debeME, "co_partidas", "debeme");

	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
	with (curPartida) {
			setModeAccess(curPartida.Insert);
			refreshBuffer();
			setValueBuffer("idsubcuenta", ctaSueldoBruto.idsubcuenta);
			setValueBuffer("codsubcuenta", ctaSueldoBruto.codsubcuenta);
			setValueBuffer("idasiento", idAsiento);
			setValueBuffer("debe", debe);
			setValueBuffer("haber", 0);
			setValueBuffer("debeME", debeME);
			setValueBuffer("haberME", 0);
	}
	
	this.iface.datosPartidaNomina(curPartida, curNomina)
	
	if (!curPartida.commitBuffer())
			return false;
	return true;
}

/** \D Genera la parte del asiento de nómina correspondiente a la subcuenta de IRPF
@param	curNomina: Cursor de la nómina
@param	idAsiento: Id del asiento asociado
@param	valoresDefecto: Array con los valores por defecto de ejercicio y divisa
@return	VERDADERO si no hay error, FALSO en otro caso
\end */
function oficial_generarPartidasIRPF(curNomina:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean
{
	var util:FLUtil = new FLUtil();
	var irpf:Number = parseFloat(curNomina.valueBuffer("irpf"));
	if (irpf == 0)
		return true;
	var haber:Number = 0;
	var haberME:Number = 0;
	var ctaIrpf:Array = this.iface.datosCtaEspecial("NO_IR", valoresDefecto.codejercicio);
	if (ctaIrpf.error != 0) {
		MessageBox.warning(util.translate("scripts", "No tiene ninguna cuenta contable marcada como cuenta especial de IRPF para nóminas (NO_IR).\nDebe asociar la cuenta a la cuenta especial en el módulo Principal del área Financiera"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	haber = irpf;
	haberME = 0;
	haber = util.roundFieldValue(haber, "co_partidas", "haber");
	haberME = util.roundFieldValue(haberME, "co_partidas", "haberme");

	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
	with (curPartida) {
		setModeAccess(curPartida.Insert);
		refreshBuffer();
		setValueBuffer("idsubcuenta", ctaIrpf.idsubcuenta);
		setValueBuffer("codsubcuenta", ctaIrpf.codsubcuenta);
		setValueBuffer("idasiento", idAsiento);
		setValueBuffer("debe", 0);
		setValueBuffer("haber", haber);
		setValueBuffer("debeME", 0);
		setValueBuffer("haberME", haberME);
	}
		
	this.iface.datosPartidaNomina(curPartida, curNomina)
		
	if (!curPartida.commitBuffer())
		return false;

	return true;
}

/** \D Genera la parte del asiento de nomina correspondiente a la subcuenta de seguridad social
@param	curNomina: Cursor de la nómina
@param	idAsiento: Id del asiento asociado
@param	valoresDefecto: Array con los valores por defecto de ejercicio y divisa
@return	VERDADERO si no hay error, FALSO en otro caso
\end */
function oficial_generarPartidasSeguridadSocial(curNomina:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean
{
	var util:FLUtil = new FLUtil();
	var segSocial:Number = parseFloat(curNomina.valueBuffer("segsocial"));
	if(segSocial == 0)
		return true;
	var ctaSeguridadSocial:Array = this.iface.datosCtaEspecial("NO_ASS", valoresDefecto.codejercicio);
	if (ctaSeguridadSocial.error != 0) {
		MessageBox.warning(util.translate("scripts", "No se ha encontrado una subcuenta de seguridad social para esta nómina.\nCompruebe que existe la cuenta especial NO_ASS asociada a una subcuenta."), MessageBox.Ok, MessageBox.NoButton);
			return false;
	}
	var haber:Number = 0;
	var haberME:Number = 0;
	haber = segSocial;
	haberME = 0;
	haber = util.roundFieldValue(haber, "co_partidas", "haber");
	haberME = util.roundFieldValue(haberME, "co_partidas", "haberme");

	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
	with (curPartida) {
		setModeAccess(curPartida.Insert);
		refreshBuffer();
		setValueBuffer("idsubcuenta", ctaSeguridadSocial.idsubcuenta);
		setValueBuffer("codsubcuenta", ctaSeguridadSocial.codsubcuenta);
		setValueBuffer("idasiento", idAsiento);
		setValueBuffer("debe", 0);
		setValueBuffer("haber", haber);
		setValueBuffer("debeME", 0);
		setValueBuffer("haberME", haberME);
	}
		
	this.iface.datosPartidaNomina(curPartida, curNomina);
		
	if (!curPartida.commitBuffer())
		return false;
	
	return true;
}

/** \D Genera la parte del asiento de nomina correspondiente a la subcuenta de dietas
@param	curNomina: Cursor de la nómina
@param	idAsiento: Id del asiento asociado
@param	valoresDefecto: Array con los valores por defecto de ejercicio y divisa
@return	VERDADERO si no hay error, FALSO en otro caso
\end */
function oficial_generarPartidasDietas(curNomina:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean
{
	var util:FLUtil = new FLUtil();
	var dietas:Number = parseFloat(curNomina.valueBuffer("dietas"));
	if (dietas == 0)
		return true;
	var ctaDietas:Array = this.iface.datosCtaEspecial("NO_DIE", valoresDefecto.codejercicio);
	if (ctaDietas.error != 0) {
		MessageBox.warning(util.translate("scripts", "No se ha encontrado una subcuenta de dietas para esta nómina.\nCompruebe que existe la cuenta especial NO_DIE asociada a una cuenta o subcuenta."), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var debe:Number = 0;
	var debeME:Number = 0;
	debe = dietas;
	debeME = 0;
	debe = util.roundFieldValue(debe, "co_partidas", "debe");
	debeME = util.roundFieldValue(debeME, "co_partidas", "debeme");

	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
	with (curPartida) {
		setModeAccess(curPartida.Insert);
		refreshBuffer();
		setValueBuffer("idsubcuenta", ctaDietas.idsubcuenta);
		setValueBuffer("codsubcuenta", ctaDietas.codsubcuenta);
		setValueBuffer("idasiento", idAsiento);
		setValueBuffer("debe", debe);
		setValueBuffer("haber", 0);
		setValueBuffer("debeME", debeME);
		setValueBuffer("haberME", 0);
	}
		
	this.iface.datosPartidaNomina(curPartida, curNomina);
		
	if (!curPartida.commitBuffer())
		return false;
	
	return true;
}

/** \D Genera la partida correspondiente al empleado
@param	curNomina: Cursor de la nómina
@param	valoresDefecto: Array de valores por defecto (ejercicio, divisa, etc.)
@param	datosAsiento: Array con los datos del asiento
@return	true si la generación es correcta, false en caso contrario
\end */
function oficial_generarPartidasNominaEmpleado(curNomina:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean
{
	var util:FLUtil = new FLUtil();
	var sueldoNeto:Number = parseFloat(curNomina.valueBuffer("sueldoneto"));
	if (sueldoNeto == 0)
		return true;
	var nombreEmpleado:String = util.sqlSelect("rh_empleados","nombre","codempleado = '" + curNomina.valueBuffer("codempleado") + "'");
	var apellidosEmpleado:String = util.sqlSelect("rh_empleados","apellidos","codempleado = '" + curNomina.valueBuffer("codempleado") + "'");

	var ctaHaber:Array = [];
	ctaHaber.codsubcuenta = util.sqlSelect("rh_empleados", "codsubcuenta", "codempleado = '" + curNomina.valueBuffer("codempleado") + "'");
	if (!ctaHaber.codsubcuenta || ctaHaber.codsubcuenta == "") {
		MessageBox.warning(util.translate("scripts", "El empleado %1 - %2 %3 no tiene ninguna subcuenta contable asociada.\nAntes de generar la nómina debe asociar la subcuenta al empleado").arg(curNomina.valueBuffer("codempleado")).arg(nombreEmpleado).arg(apellidosEmpleado), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	ctaHaber.idsubcuenta = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + ctaHaber.codsubcuenta + "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
	if (!ctaHaber.idsubcuenta) {
		MessageBox.warning(util.translate("scripts", "No tiene definida la subcuenta %1 en el ejercicio %2.\nAntes de generar la nómina debe crear la subcuenta o modificar el ejercicio").arg(ctaHaber.codsubcuenta).arg(valoresDefecto.codejercicio), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var haber:Number = 0;
	var haberME:Number = 0;
	haber = sueldoNeto;
	haberME = 0;
	haber = util.roundFieldValue(haber, "co_partidas", "haber");
	haberME = util.roundFieldValue(haberME, "co_partidas", "haberme");
		
	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
	with(curPartida) {
		setModeAccess(curPartida.Insert);
		refreshBuffer();
		setValueBuffer("idsubcuenta", ctaHaber.idsubcuenta);
		setValueBuffer("codsubcuenta", ctaHaber.codsubcuenta);
		setValueBuffer("idasiento", idAsiento);
		setValueBuffer("debe", 0);
		setValueBuffer("haber", haber);
		setValueBuffer("debeME", 0);
		setValueBuffer("haberME", haberME);
	}

	this.iface.datosPartidaNomina(curPartida, curNomina)	
	
	if (!curPartida.commitBuffer())
		return false;

	return true;
}

/** \D Genera la partida correspondiente al empleado
@param	curPN: Cursor del pago de la nómina
@param	valoresDefecto: Array de valores por defecto (ejercicio, divisa, etc.)
@param	datosAsiento: Array con los datos del asiento
@return	true si la generación es correcta, false en caso contrario
\end */
function oficial_generarPartidasPagosNominaEmpleado(curPN:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean
{
	var util:FLUtil = new FLUtil();
	var importe:Number = parseFloat(curPN.valueBuffer("importe"));
	if (importe == 0)
		return true;
	var codEmpleado:String = util.sqlSelect("rh_nominas","codempleado","codnomina = '" + curPN.valueBuffer("codnomina") + "'");
	if (!codEmpleado || codEmpleado == "")
		return false;

	var ctaDebe:Array = [];
	ctaDebe.codsubcuenta = util.sqlSelect("rh_empleados", "codsubcuenta", "codempleado = '" + codEmpleado + "'");
	if (!ctaDebe.codsubcuenta || ctaDebe.codsubcuenta == "") {
		MessageBox.warning(util.translate("scripts", "El empleado %1 no tiene ninguna subcuenta contable asociada.\nAntes de generar el pago de la nómina debe asociar la subcuenta al empleado").arg(codEmpleado), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	ctaDebe.idsubcuenta = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + ctaDebe.codsubcuenta + "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
	if (!ctaDebe.idsubcuenta) {
		MessageBox.warning(util.translate("scripts", "No tiene definida la subcuenta %1 en el ejercicio %2.\nAntes de generar el pago de la nómina debe crear la subcuenta o modificar el ejercicio").arg(ctaDebe.codsubcuenta).arg(valoresDefecto.codejercicio), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var debe:Number = 0;
	var debeME:Number = 0;
	debe = importe;
	debeME = 0;
	debe = util.roundFieldValue(debe, "co_partidas", "debe");
	debeME = util.roundFieldValue(debeME, "co_partidas", "debeme");
	
	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
	with(curPartida) {
		setModeAccess(curPartida.Insert);
		refreshBuffer();
		setValueBuffer("idsubcuenta", ctaDebe.idsubcuenta);
		setValueBuffer("codsubcuenta", ctaDebe.codsubcuenta);
		setValueBuffer("idasiento", idAsiento);
		setValueBuffer("debe", debe);
		setValueBuffer("haber", 0);
		setValueBuffer("debeME", debeME);
		setValueBuffer("haberME", 0);
	}

	this.iface.datosPartidaPagosNomina(curPartida, curPN)	
	
	if (!curPartida.commitBuffer())
		return false;

	return true;
}

/** \D Genera la partida correspondiente a la empresa del asiento de pago de la nómina del empleado
@param	curPN: Cursor del pago o devolución de la nómina
@param	valoresDefecto: Array de valores por defecto (ejercicio, divisa, etc.)
@param	datosAsiento: Array con los datos del asiento
@param	recibo: Array con los datos del recibo asociado al pago
@return	true si la generación es correcta, false en caso contrario
\end */
function oficial_generarPartidasEmpresa(curPN:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean
{
	var util:FLUtil = new FLUtil();
	var importe:Number = parseFloat(curPN.valueBuffer("importe"));
	if (importe == 0)
		return true;
	var ctaHaber:Array = [];
	ctaHaber.codsubcuenta = util.sqlSelect("cuentasbanco","codsubcuenta","codcuenta = '" + curPN.valueBuffer("codcuenta") + "'");

	if (!ctaHaber.codsubcuenta || ctaHaber.codsubcuenta == "") {
		MessageBox.warning(util.translate("scripts", "Debe establecer la cuenta de la empresa"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	ctaHaber.idsubcuenta = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + ctaHaber.codsubcuenta + "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
	if (!ctaHaber.idsubcuenta) {
		MessageBox.warning(util.translate("scripts", "No tiene definida la subcuenta %1 en el ejercicio %2.\nAntes de dar el pago debe crear la subcuenta o modificar el ejercicio").arg(ctaHaber.codsubcuenta).arg(valoresDefecto.codejercicio), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var haber:Number = 0;
	var haberME:Number = 0;
	haber = importe;
	haberME = 0;
	haber = util.roundFieldValue(haber, "co_partidas", "haber");
	haberME = util.roundFieldValue(haberME, "co_partidas", "haberme");
	
	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
	with(curPartida) {
		setModeAccess(curPartida.Insert);
		refreshBuffer();
		setValueBuffer("idsubcuenta", ctaHaber.idsubcuenta);
		setValueBuffer("codsubcuenta", ctaHaber.codsubcuenta);
		setValueBuffer("idasiento", idAsiento);
		setValueBuffer("debe", 0);
		setValueBuffer("haber", haber);
		setValueBuffer("debeME", 0);
		setValueBuffer("haberME", haberME);
	}

	this.iface.datosPartidaPagosNomina(curPartida, curPN)

	if (!curPartida.commitBuffer())
		return false;

	return true;
}



/** \D Genera o regenera el registro en la tabla de asientos correspondiente a la nómina. Si el asiento ya estaba creado borra sus partidas asociadas.
@param	curNomina: Cursor posicionado en el registro de nómina
@return	array con los siguientes datos:
asiento.idasiento: Id del asiento
asiento.numero: numero del asiento
asiento.fecha: fecha del asiento
asiento.error: indicador booleano de que ha habido un error en la función
\end */
function oficial_regenerarAsiento(cur:FLSqlCursor, valoresDefecto:Array):Array
{
	var util:FLUtil = new FLUtil;
	var asiento:Array = [];
	var idAsiento:Number = cur.valueBuffer("idasiento");
	if (cur.isNull("idasiento")) {
		var concepto:String;
		var documento:String;
		var tipoDocumento:String;
		switch (cur.table()) {
			case "rh_nominas": {
				var nombre:String = util.sqlSelect("rh_empleados","nombre","codempleado = '" + cur.valueBuffer("codempleado") + "'");
				if (!nombre || nombre == "")
					return false;
			
				var apellidos:String = util.sqlSelect("rh_empleados","apellidos","codempleado = '" + cur.valueBuffer("codempleado") + "'");
				if (!apellidos || apellidos == "")
					return false;
			
				var fechaNomina:String = util.dateAMDtoDMA(cur.valueBuffer("fecha"));
				fechaNomina = fechaNomina.right(7);

				concepto = "Nómina empleado " + cur.valueBuffer("codempleado") +  " - " + nombre + " " + apellidos + " de " + fechaNomina;
				break;
			}
			case "rh_pagosnomina": {
				var codEmpleado:String = util.sqlSelect("rh_nominas","codempleado","codnomina = '" + cur.valueBuffer("codnomina") + "'");
				if (!codEmpleado || codEmpleado == "")
					return false;
			
				var nombre:String = util.sqlSelect("rh_empleados","nombre","codempleado = '" + codEmpleado + "'");
				if (!nombre || nombre == "")
					return false;
			
				var apellidos:String = util.sqlSelect("rh_empleados","apellidos","codempleado = '" + codEmpleado + "'");
				if (!apellidos || apellidos == "")
					return false;
			
				var fechaNomina:String = util.sqlSelect("rh_nominas","fecha","codnomina = '" + cur.valueBuffer("codnomina") + "'");
				if (!fechaNomina || fechaNomina == "")
					return false;
				fechaNomina = util.dateAMDtoDMA(fechaNomina);
				fechaNomina = fechaNomina.right(7);
			
				concepto = "Pago nómina empleado " + codEmpleado + " - " + nombre + " " + apellidos + " de " + fechaNomina;
				break;
			}
		}


		var curAsiento:FLSqlCursor = new FLSqlCursor("co_asientos");
		with (curAsiento) {
			setModeAccess(curAsiento.Insert);
			refreshBuffer();
			setValueBuffer("numero", 0);
			setValueBuffer("fecha", cur.valueBuffer("fecha"));
			setValueBuffer("codejercicio", valoresDefecto.codejercicio);
			setValueBuffer("concepto", concepto);
			setValueBuffer("documento", documento);
		}

		if (!curAsiento.commitBuffer()) {
			asiento.error = true;

			return asiento;
		}

		asiento.idasiento = curAsiento.valueBuffer("idasiento");
		asiento.numero = curAsiento.valueBuffer("numero");
		asiento.fecha = curAsiento.valueBuffer("fecha");
		curAsiento.select("idasiento = " + asiento.idasiento);
		curAsiento.first();
		curAsiento.setUnLock("editable", false);
	} else {

		if (!this.iface.asientoBorrable(idAsiento)) {
			asiento.error = true;
			return asiento;
		}

		if (cur.valueBuffer("fecha") != cur.valueBufferCopy("fecha")) {
			var curAsiento:FLSqlCursor = new FLSqlCursor("co_asientos");
			curAsiento.select("idasiento = " + idAsiento);
			if (!curAsiento.first()) {
				asiento.error = true;
				return asiento;
			}

			curAsiento.setUnLock("editable", true);

			curAsiento.select("idasiento = " + idAsiento);
			if (!curAsiento.first()) {
				asiento.error = true;
				return asiento;
			}

			curAsiento.setModeAccess(curAsiento.Edit);
			curAsiento.refreshBuffer();
			curAsiento.setValueBuffer("fecha", cur.valueBuffer("fecha"));

			if (!curAsiento.commitBuffer()) {
				asiento.error = true;
				return asiento;
			}

			curAsiento.select("idasiento = " + idAsiento);
			if (!curAsiento.first()) {
				asiento.error = true;
				return asiento;
			}

			curAsiento.setUnLock("editable", false);
		}

		asiento = flfactppal.iface.pub_ejecutarQry("co_asientos", "idasiento,numero,fecha,codejercicio", "idasiento = '" + idAsiento + "'");

		if (asiento.codejercicio != valoresDefecto.codejercicio) {
			MessageBox.warning(util.translate("scripts", "Está intentando regenerar un asiento del ejercicio %1 en el ejercicio %2.\nVerifique que su ejercicio actual es correcto. Si lo es y está actualizando un pago, bórrelo y vuélvalo a crear.").arg(asiento.codejercicio).arg(valoresDefecto.codejercicio), MessageBox.Ok, MessageBox.NoButton);
			asiento.error = true;
			return asiento;
		}

		var curPartidas = new FLSqlCursor("co_partidas");
		curPartidas.select("idasiento = " + idAsiento);
		while (curPartidas.next()) {
			curPartidas.setModeAccess(curPartidas.Del);
			curPartidas.refreshBuffer();
			if (!curPartidas.commitBuffer()) {
				asiento.error = true;
				return asiento;
			}
		}
	}

	asiento.error = false;
	return asiento;
}


/** \D Devuelve el código e id de la subcuenta especial correspondiente a un determinado ejercicio. Primero trata de obtener los datos a partir del campo cuenta de co_cuentasesp. Si este no existe o no produce resultados, busca los datos de la cuenta (co_cuentas) marcada con el tipo especial buscado.
@param ctaEsp: Tipo de cuenta especial
@codEjercicio: Código de ejercicio
@return Los datos componen un vector de tres valores:
error: 0.Sin error 1.Datos no encontrados 2.Error al ejecutar la query
idsubcuenta: Identificador de la subcuenta
codsubcuenta: Código de la subcuenta
\end */
function oficial_datosCtaEspecial(ctaEsp:String, codEjercicio:String):Array
{
	var datos:Array = [];
	var q:FLSqlQuery = new FLSqlQuery();
	
	with(q) {
		setTablesList("co_subcuentas,co_cuentasesp");
		setSelect("s.idsubcuenta, s.codsubcuenta");
		setFrom("co_cuentasesp ce INNER JOIN co_subcuentas s ON ce.codsubcuenta = s.codsubcuenta");
		setWhere("ce.idcuentaesp = '" + ctaEsp + "' AND s.codejercicio = '" + codEjercicio + "'");
	}

	try { q.setForwardOnly( true ); } catch (e) {}
	if (!q.exec()) {
		datos["error"] = 2;
		return datos;
	}
	if (q.next()) {
		datos["error"] = 0;
		datos["idsubcuenta"] = q.value(0);
		datos["codsubcuenta"] = q.value(1);
		return datos;
	}
	
	with(q) {
		setTablesList("co_cuentas,co_subcuentas,co_cuentasesp");
		setSelect("s.idsubcuenta, s.codsubcuenta");
		setFrom("co_cuentasesp ce INNER JOIN co_cuentas c ON ce.codcuenta = c.codcuenta INNER JOIN co_subcuentas s ON c.idcuenta = s.idcuenta");
		setWhere("s.idcuentaesp = '" + ctaEsp + "' AND c.codejercicio = '" + codEjercicio + "' ORDER BY s.codsubcuenta");
	}

	try { q.setForwardOnly( true ); } catch (e) {}
	if (!q.exec()) {
		datos["error"] = 2;
		return datos;
	}
	if (q.next()) {
		datos["error"] = 0;
		datos["idsubcuenta"] = q.value(0);
		datos["codsubcuenta"] = q.value(1);
		return datos;
	}

	with(q) {
		setTablesList("co_cuentas,co_subcuentas");
		setSelect("s.idsubcuenta, s.codsubcuenta");
		setFrom("co_cuentas c INNER JOIN co_subcuentas s ON c.idcuenta = s.idcuenta");
		setWhere("c.idcuentaesp = '" + ctaEsp + "' AND c.codejercicio = '" + codEjercicio + "' ORDER BY s.codsubcuenta");
	}

	try { q.setForwardOnly( true ); } catch (e) {}
	if (!q.exec()) {
		datos["error"] = 2;
		return datos;
	}
	if (!q.next()) {
		datos["error"] = 1;
		return datos;
	}

	datos["error"] = 0;
	datos["idsubcuenta"] = q.value(0);
	datos["codsubcuenta"] = q.value(1);
	return datos;
}

/** \D Indica si el asiento asociado a la nómina puede o no regenerarse, según pertenezca a un ejercicio abierto o cerrado
@param idAsiento: Identificador del asiento
@return True: Asiento borrable, False: Asiento no borrable
\end */
function oficial_asientoBorrable(idAsiento:Number):Boolean
{
	var util:FLUtil = new FLUtil();
	var qryEjerAsiento:FLSqlQuery = new FLSqlQuery();
	qryEjerAsiento.setTablesList("ejercicios,co_asientos");
	qryEjerAsiento.setSelect("e.estado");
	qryEjerAsiento.setFrom("co_asientos a INNER JOIN ejercicios e" + " ON a.codejercicio = e.codejercicio");
	qryEjerAsiento.setWhere("a.idasiento = " + idAsiento);
	try { qryEjerAsiento.setForwardOnly( true ); } catch (e) {}

	if (!qryEjerAsiento.exec())
		return false;

	if (!qryEjerAsiento.next())
		return false;

	if (qryEjerAsiento.value(0) != "ABIERTO") {
		MessageBox.critical(util.translate("scripts",
		"No puede realizarse la modificación porque el asiento contable correspondiente pertenece a un ejercicio cerrado"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	return true;
}

/** \D Establece los datos opcionales de una partida de retencion de IRPF.
Se ponen datos de concepto
@param	curPartida: Cursor sobre la partida
@param	curRetencion: Cursor sobre la retencion de IRPF
*/
function oficial_datosPartidaRetencionIRPF(curPartida:FLSqlCursor, curRetencion:FLSqlCursor)
{
	var util:FLUtil = new FLUtil();

	var fechaDesde:String = util.dateAMDtoDMA(curRetencion.valueBuffer("fechadesde"));
	var fechaHasta:String = util.dateAMDtoDMA(curRetencion.valueBuffer("fechahasta"));
		
	curPartida.setValueBuffer("concepto", util.translate("scripts", "Retenciones IRPF, Nóminas %1 - %2").arg(fechaDesde).arg(fechaHasta));
}

/** \D Establece los datos opcionales de una partida de aportaciones a la Seguridad Social.
Se ponen datos de concepto
@param	curPartida: Cursor sobre la partida
@param	curRSS: Cursor sobre el reicibo de seguridad social
*/
function oficial_datosPartidaReciboSegSocial(curPartida:FLSqlCursor, curRSS:FLSqlCursor)
{
	var util:FLUtil = new FLUtil();

	var fecha:String = util.dateAMDtoDMA(curRSS.valueBuffer("fechanomina"));
	fecha = fecha.right(7);	

	curPartida.setValueBuffer("concepto", util.translate("scripts", "Aportacion a la Seguridad Social, Nóminas - %1").arg(fecha));
}

/** \D Establece los datos opcionales de una partida de nómina.
Se ponen datos de concepto
@param	curPartida: Cursor sobre la partida
@param	curNomina: Cursor sobre la nómina
*/
function oficial_datosPartidaNomina(curPartida:FLSqlCursor, curNomina:FLSqlCursor) 
{
	var util:FLUtil = new FLUtil();

	var nombre:String = util.sqlSelect("rh_empleados","nombre","codempleado = '" + curNomina.valueBuffer("codempleado") + "'");
	if (!nombre || nombre == "")
		return false;

	var apellidos:String = util.sqlSelect("rh_empleados","apellidos","codempleado = '" + curNomina.valueBuffer("codempleado") + "'");
	if (!apellidos || apellidos == "")
		return false;

	var fechaNomina:String = util.dateAMDtoDMA(curNomina.valueBuffer("fecha"));
	fechaNomina = fechaNomina.right(7);
	
	curPartida.setValueBuffer("concepto", util.translate("scripts", "Nómina empleado %1 - %2 %3 de %4 ").arg(curNomina.valueBuffer("codempleado")).arg(nombre).arg(apellidos).arg(fechaNomina));
}

/** \D Establece los datos opcionales de una partida de pago de una nómina.
Se ponen datos de concepto
@param	curPartida: Cursor sobre la partida
@param	curPN: Cursor sobre el pago de la nómina
*/
function oficial_datosPartidaPagosNomina(curPartida:FLSqlCursor, curPN:FLSqlCursor) 
{
	var util:FLUtil = new FLUtil();

	var codEmpleado:String = util.sqlSelect("rh_nominas","codempleado","codnomina = '" + curPN.valueBuffer("codnomina") + "'");
	if (!codEmpleado || codEmpleado == "")
		return false;

	var nombre:String = util.sqlSelect("rh_empleados","nombre","codempleado = '" + codEmpleado + "'");
	if (!nombre || nombre == "")
		return false;

	var apellidos:String = util.sqlSelect("rh_empleados","apellidos","codempleado = '" + codEmpleado + "'");
	if (!apellidos || apellidos == "")
		return false;

	var fechaNomina:String = util.sqlSelect("rh_nominas","fecha","codnomina = '" + curPN.valueBuffer("codnomina") + "'");
	if (!fechaNomina || fechaNomina == "")
		return false;
	fechaNomina = util.dateAMDtoDMA(fechaNomina);
	fechaNomina = fechaNomina.right(7);
	
	curPartida.setValueBuffer("concepto", util.translate("scripts", "Pago nómina empleado %1 - %2 %3 de %4 ").arg(codEmpleado).arg(nombre).arg(apellidos).arg(fechaNomina));
}

function oficial_eliminarAsiento(idAsiento:String):Boolean
{
	var util:FLUtil = new FLUtil;
	if (!idAsiento || idAsiento == "")
		return true;

	if (!flfacturac.iface.pub_asientoBorrable(idAsiento))
		return false;

	var curAsiento:FLSqlCursor = new FLSqlCursor("co_asientos");
	curAsiento.select("idasiento = " + idAsiento);
	if (!curAsiento.first())
		return false;

	curAsiento.setUnLock("editable", true);
	if (!util.sqlDelete("co_partidas", "idasiento = " + idAsiento)) {
		curAsiento.setValueBuffer("idasiento", idAsiento);
		return false;
	}
	if (!util.sqlDelete("co_asientos", "idasiento = " + idAsiento)) {
		curAsiento.setValueBuffer("idasiento", idAsiento);
		return false;
	}

	return true;
}
//// OFICIAL ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
