/***************************************************************************
                 co_mastersubcuentas.qs  -  description
                             -------------------
    begin                : lun jul 11 2004
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
	var tdbRecords:FLTableDB;
	var ejercicioActual:String;
	var curSubcuenta_:FLSqlCursor;
    function oficial( context ) { interna( context ); } 
	function libroMayor() {
		return this.ctx.oficial_libroMayor()
	}
	function toolButtonCopy_clicked() {
		return this.ctx.oficial_toolButtonCopy_clicked();
	}
	function copiarSubcuentaEjercicio(curSubcuenta:FLSqlCursor):Boolean {
		return this.ctx.oficial_copiarSubcuentaEjercicio(curSubcuenta);
	}
	function datosSubcuenta(curSubcuenta:FLSqlCursor, codEjercicio:String):Boolean {
		return this.ctx.oficial_datosSubcuenta(curSubcuenta, codEjercicio);
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
/** \C El formulario mostrará las subcuentas asociadas al ejercicio actual
\end */
function interna_init()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	this.iface.tdbRecords = this.child("tableDBRecords");
	this.iface.ejercicioActual = flfactppal.iface.pub_ejercicioActual();
	
	if (cursor.mainFilter().toString().isEmpty())
		cursor.setMainFilter("codEjercicio = '" + this.iface.ejercicioActual + "'");
	else 
		cursor.setMainFilter(cursor.mainFilter() + " AND codejercicio = '" + this.iface.ejercicioActual + "'");
	this.iface.tdbRecords.refresh();
	
	connect(this.child("toolButtonMayor"), "clicked()", this, "iface.libroMayor");
	connect(this.child("toolButtonCopy"), "clicked()", this, "iface.toolButtonCopy_clicked");
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

/** \D Muestra el informe de Libro Mayor asociado a la subcuenta. Comprueba que el módulo de informes esté cargado
\end */
function oficial_libroMayor()
{
	var util:FLUtil = new FLUtil();
	if (sys.isLoadedModule("flcontinfo")) {
		var nombreInforme:String = "co_i_mayor";
		var codSubcuenta:String = this.cursor().valueBuffer("codsubcuenta");
		var codEjercicio:String = this.cursor().valueBuffer("codejercicio");
		var monedaExt:String = this.cursor().valueBuffer("coddivisa");;
			if(monedaExt != ""){
				var monedaEmpr:String = flfactppal.iface.pub_valorDefectoEmpresa("coddivisa");
				if(monedaExt != monedaEmpr){
					var dialog:Object = new Dialog(util.translate("scripts", "Libro Mayor"), 0, "libroMayor");
	
					dialog.OKButtonText = util.translate ("scripts","Aceptar");
					dialog.cancelButtonText = util.translate ("scripts","Cancelar");
					
					var bgroup:Object = new GroupBox;
					dialog.add(bgroup);
					
					var empresa:Object = new RadioButton;
					empresa.text = util.translate ("scripts","En " + util.sqlSelect("divisas","descripcion","coddivisa = '" + monedaEmpr + "'"));
					empresa.checked = true;
					bgroup.add(empresa);
					
					var extranjera:Object = new RadioButton;
					extranjera.text = util.translate ("scripts","En " + util.sqlSelect("divisas","descripcion","coddivisa = '" + monedaExt + "'"));
					extranjera.checked = false;
					bgroup.add(extranjera);
					
					if (!dialog.exec())
						return true;
					
					if (extranjera.checked == true)
						nombreInforme = "co_i_mayorme";
			}
		}
		var q:FLSqlQuery = new FLSqlQuery();
		q.setTablesList("ejercicios");
		q.setSelect("fechainicio, fechafin");
		q.setFrom("ejercicios");
		q.setWhere("codejercicio = '" + codEjercicio + "';");
		q.exec();
		
		var fechaDesde:String;
		var fechaHasta:String;
		if (q.next()) {
			fechaDesde = q.value(0);
			fechaHasta = q.value(1);
		}
		else return;
		
		/** \D Inserta en la tabla de informes de libro mayo un registro que define un periodo de tiempo dentro del ejercicio actual completo, y una subcuenta igual a la subcuenta actual. A continuación lanza el informe
		\end */
		var curMayor:FLSqlCursor = new FLSqlCursor("co_i_mayor");
		
		curMayor.setModeAccess(curMayor.Insert);
		curMayor.refreshBuffer();
		
		curMayor.setValueBuffer("descripcion", "temp");				
		curMayor.setValueBuffer("d_co__subcuentas_codsubcuenta", codSubcuenta);
		curMayor.setValueBuffer("h_co__subcuentas_codsubcuenta", codSubcuenta);
		curMayor.setValueBuffer("d_co__asientos_fecha", fechaDesde);
		curMayor.setValueBuffer("h_co__asientos_fecha", fechaHasta);
		curMayor.setValueBuffer("i_co__subcuentas_codejercicio", codEjercicio);
		
		flcontinfo.iface.pub_lanzarInforme(curMayor, nombreInforme, "", "co_asientos.fecha,co_asientos.numero", "", "", curMayor.valueBuffer("id"));
	
	} else
		flfactppal.iface.pub_MsgNoDisponible("Informes");
}

function oficial_toolButtonCopy_clicked()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var idSubcuenta:String = cursor.valueBuffer("idsubcuenta");
	if (!idSubcuenta) {
		return false;
	}

	var res:Number = MessageBox.information(util.translate("scripts", "¿Desea copiar los datos de la subcuenta en otro ejercicio?"), MessageBox.Yes, MessageBox.No);
	if (res == MessageBox.Yes) {
		this.iface.copiarSubcuentaEjercicio(cursor);
	} else {
		this.child("tdbRecords").copyRecord();
	}
}

function oficial_copiarSubcuentaEjercicio(curSubcuenta:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();

	var f:Object = new FLFormSearchDB("ejercicios");
	f.setMainWidget();
	var codEjercicio:String = f.exec("codejercicio");
	if (!codEjercicio) {
		return false;
	}
	var codSubcuenta:String = curSubcuenta.valueBuffer("codsubcuenta");
	if (util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + codSubcuenta + "' AND codejercicio = '" + codEjercicio + "'")) {
		MessageBox.warning(util.translate("scripts", "Ya hay una subcuenta con código %1 para el ejercicio %2").arg(codSubcuenta).arg(codEjercicio), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	if (!this.iface.curSubcuenta_) {
		this.iface.curSubcuenta_ = new FLSqlCursor("co_subcuentas");
	}
	this.iface.curSubcuenta_.setModeAccess(this.iface.curSubcuenta_.Insert);
	this.iface.curSubcuenta_.refreshBuffer();
	if (!this.iface.datosSubcuenta(curSubcuenta, codEjercicio)) {
		return false;
	}
	if (!this.iface.curSubcuenta_.commitBuffer()) {
		return false;
	}
	MessageBox.information(util.translate("scripts", "Se ha creado la subcuenta %1 en el ejercicio %2").arg(codSubcuenta).arg(codEjercicio), MessageBox.Ok, MessageBox.NoButton);
	return true;
}

function oficial_datosSubcuenta(curSubcuenta:FLSqlCursor, codEjercicio:String):Boolean
{
	var util:FLUtil = new FLUtil();
	var codCuenta:String = curSubcuenta.valueBuffer("codcuenta");
	var idCuenta:String = util.sqlSelect("co_cuentas", "idcuenta", "codcuenta = '" + codCuenta + "' AND codejercicio = '" + codEjercicio + "'");
	if (!idCuenta) {
		var res:Number = MessageBox.warning(util.translate("scripts", "La cuenta %1 no existe en el ejercicio %2.\n¿Desea crearla?").arg(codCuenta).arg(codEjercicio), MessageBox.Yes, MessageBox.No);
		if (res != MessageBox.Yes) {
			return false;
		}
		idCuenta = flcontppal.iface.pub_copiarCuenta(codCuenta, curSubcuenta.valueBuffer("codejercicio"), codEjercicio);
		if (!idCuenta) {
			return false;
		}
	}
	this.iface.curSubcuenta_.setValueBuffer("codsubcuenta", curSubcuenta.valueBuffer("codsubcuenta"));
	this.iface.curSubcuenta_.setValueBuffer("idcuenta", idCuenta);
	this.iface.curSubcuenta_.setValueBuffer("codcuenta", codCuenta);
	this.iface.curSubcuenta_.setValueBuffer("descripcion", curSubcuenta.valueBuffer("descripcion"));
	this.iface.curSubcuenta_.setValueBuffer("debe", 0);
	this.iface.curSubcuenta_.setValueBuffer("haber", 0);
	this.iface.curSubcuenta_.setValueBuffer("saldo", 0);
	this.iface.curSubcuenta_.setValueBuffer("codimpuesto", curSubcuenta.valueBuffer("codimpuesto"));
	this.iface.curSubcuenta_.setValueBuffer("iva", curSubcuenta.valueBuffer("iva"));
	this.iface.curSubcuenta_.setValueBuffer("recargo", curSubcuenta.valueBuffer("recargo"));
	this.iface.curSubcuenta_.setValueBuffer("coddivisa", curSubcuenta.valueBuffer("coddivisa"));
	this.iface.curSubcuenta_.setValueBuffer("codejercicio", codEjercicio);
	this.iface.curSubcuenta_.setValueBuffer("idcuentaesp", curSubcuenta.valueBuffer("idcuentaesp"));
	return true;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
