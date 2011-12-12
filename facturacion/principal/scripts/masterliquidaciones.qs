/***************************************************************************
                           masterliquidaciones.qs
                             -------------------
    begin                : jue sep 29 2005
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

/** @class_declaration liqAgentes */
//////////////////////////////////////////////////////////////////
//// LIQAGENTES //////////////////////////////////////////////////
class liqAgentes extends interna {
	var curLiquidacion_:FLSqlCursor;
	function liqAgentes( context ) { interna( context ); }
	function grafica() { 
		this.ctx.liqAgentes_grafica(); 
	}
	function eliminarliquidaciones() { 
		return this.ctx.liqAgentes_eliminarliquidaciones(); 
	}
	function generarFactura():Boolean { 
		return this.ctx.liqAgentes_generarFactura(); 
	}
	function pbGenerarFactura_clicked():Boolean { 
		return this.ctx.liqAgentes_pbGenerarFactura_clicked(); 
	}
	function imprimir() {
		return this.ctx.liqAgentes_imprimir();
	}
	function pbnGenerarLiqAgentes_clicked() {
		return this.ctx.liqAgentes_pbnGenerarLiqAgentes_clicked();
	}
	function generarLiquidacion(codAgente:String, curGenerarLiq:FLSqlCursor):String {
		return this.ctx.liqAgentes_generarLiquidacion(codAgente, curGenerarLiq);
	}
	function datosLiquidacion(curGenerarLiq:FLSqlCursor):Boolean {
		return this.ctx.liqAgentes_datosLiquidacion(curGenerarLiq);
	}
	function totalesLiquidacion(curGenerarLiq:FLSqlCursor):Boolean {
		return this.ctx.liqAgentes_totalesLiquidacion(curGenerarLiq);
	}
}
//// LIQAGENTES ///////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends liqAgentes {
	function head( context ) { liqAgentes ( context ); }
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
	connect( this.child( "toolButtonDelete" ), "clicked()", this, "iface.eliminarliquidaciones");
	connect( this.child( "pbGenerarFactura" ), "clicked()", this, "iface.pbGenerarFactura_clicked");
	connect( this.child( "pbnGenerarLiqAgentes" ), "clicked()", this, "iface.pbnGenerarLiqAgentes_clicked");
	connect( this.child( "toolButtonPrint" ), "clicked()", this, "iface.imprimir");
	
	var codEjercicio = flfactppal.iface.pub_ejercicioActual();
	if (codEjercicio)
		this.cursor().setMainFilter("codejercicio IN ('" + codEjercicio + "', '') OR codejercicio IS NULL");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition liqAgentes */
//////////////////////////////////////////////////////////////////
//// LIQAGENTES /////////////////////////////////////////////////////
/** \C Elimina una liquidación quitando el código de la liquidación a las facturas asociadas
\end */
function liqAgentes_eliminarliquidaciones() 
{
	var util:FLUtil = new FLUtil();
	
	var res:Number = MessageBox.information(util.translate("scripts", "El registro activo será borrado ¿Está seguro?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
	if(res != MessageBox.Yes)
		return false;
	
	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList("facturascli");
	q.setSelect("idfactura");
	q.setFrom("facturascli");
	q.setWhere("codliquidacion = '" + this.cursor().valueBuffer("codliquidacion") + "'");
	if (!q.exec()) 
		return false;
		
	if(q.size() != 0){
		var res:Number = MessageBox.warning(util.translate("scripts", "Esta liquidación tiene facturas asociadas. Si la elimina se borrará el código de la liquidación de las facturas ¿Desea continuar?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
		if(res != MessageBox.Yes)
			return false;
		
		var curFacturas:FLSqlCursor = new FLSqlCursor( "facturascli" );
		while(q.next()){
			curFacturas.select( "idfactura = " + q.value(0));
			if(!curFacturas.first())
				continue;
			
			var editable:String = curFacturas.valueBuffer("editable");
			if(!editable) {
				curFacturas.setUnLock("editable", true);
				curFacturas.select( "idfactura = " + q.value(0));
				if(!curFacturas.first())
					return false;
			}
	
			curFacturas.setModeAccess( curFacturas.Edit );
			curFacturas.refreshBuffer();
			curFacturas.setNull("codliquidacion");
			if(!curFacturas.commitBuffer())
				return false;

			if(!editable) {
				curFacturas.select( "idfactura = " + q.value(0));
				if(!curFacturas.first())
					return false;

				curFacturas.setUnLock("editable", false);
				if(!curFacturas.commitBuffer())
					return false;
			}
		}
	}
	var curLiquidacion:FLSqlCursor = new FLSqlCursor("liquidaciones");
	curLiquidacion.select("codliquidacion = '" + this.cursor().valueBuffer("codliquidacion") + "'");
	curLiquidacion.first();
	curLiquidacion.setModeAccess(curLiquidacion.Del);
	curLiquidacion.refreshBuffer();
	if (!curLiquidacion.commitBuffer()) {
		return false;
	}
}

/** \C Muestra una grafica de las liquidaciones
\end */
function liqAgentes_grafica()
{
	var cursor:FLSqlCursor = this.cursor();
	var qryFacturas:FLSqlQuery = new FLSqlQuery();

	qryFacturas.setTablesList( "facturascli" );
	qryFacturas.setSelect( "fecha,porcomision,neto" );
	qryFacturas.setFrom( "facturascli" );
	qryFacturas.setWhere( "codliquidacion='" + cursor.valueBuffer( "codliquidacion" ) + "'" );
	qryFacturas.setOrderBy( "fecha" );

	if ( qryFacturas.exec() ) {
		if ( qryFacturas.size() > 0 ) {
			var stdin:String, datos:String, fechaInicio:String, fechaFin:String;
			var util:FLUtil = new FLUtil();

			qryFacturas.first();
			fechaInicio = util.dateAMDtoDMA(qryFacturas.value(0));
			datos = fechaInicio + " " + (qryFacturas.value(1)*qryFacturas.value(2)/100) + "\n";

			qryFacturas.last();
			fechaFin = util.dateAMDtoDMA(qryFacturas.value(0));
			qryFacturas.first();
			while ( qryFacturas.next() )
				datos += util.dateAMDtoDMA(qryFacturas.value(0)) + " " + (qryFacturas.value(1)*qryFacturas.value(2)/100) + "\n";

			stdin =  "set title \"Liquidación : " + cursor.valueBuffer( "codliquidacion" ) + "\"";
			stdin += "\nset xdata time";
			stdin += "\nset timefmt \"\%d-\%m-\%Y\"";
			stdin += "\nset xrange [\"" + fechaInicio + "\" : \"" + fechaFin +"\"]";
			stdin += "\nset format x \"\%d-\%m\"";
			stdin += "\nset grid";
			stdin += "\nplot '-' using 1:2 with lines smooth bezier\n";
			stdin += datos;

			Process.execute( ["gnuplot","-persist"], stdin);
		}
	}
}

/** \C Genera una factura de proveedor para la liquidación seleccionada
Comprueba antes de generar la factura que haya un porveedor asociadoa al agente de la liquidación.
Si ya hay una factura creada muestra un mensaje de aviso.
\end */
function liqAgentes_pbGenerarFactura_clicked()
{
	var util:FLUtil = new FLUtil();
	
	if(!util.sqlSelect("agentes","codproveedor","codagente = '" + this.cursor().valueBuffer("codagente") + "'")){
		MessageBox.warning(util.translate("scripts", "No hay ningun proveedor asociado al agente ") + this.cursor().valueBuffer("codagente") + util.translate("scripts", ".\nAntes de generar la factura debe asociar un proveedor"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false
	}
	
	if(util.sqlSelect("facturasprov","codigo","codigo = '" + this.cursor().valueBuffer("codfactura") + "'")){
		var res:Number = MessageBox.warning(util.translate("scripts", "Ya se ha generado una factura para esta liquidación (") + this.cursor().valueBuffer("codfactura") + util.translate("scripts", ").\nSi desea sustituirla debe eliminarla manualmente.\n¿Desea continuar?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
		if(res != MessageBox.Yes)
			return false;
	}

	var cursor:FLSqlCursor = this.cursor();
	cursor.transaction(false);
	try {
		if (this.iface.generarFactura())
			cursor.commit();
		else
			cursor.rollback();
	}
	catch (e) {
		cursor.rollback();
		MessageBox.warning(util.translate("scripts", "Ha habido un error en la generación de la factura:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
	}
}

/** \C Crea una factura de proveedor obteniendo los datos del proveedor asociado al agnete y de la empresa
@return true si se ha creado correctamente y false si ha habido algún error
\end */
function liqAgentes_generarFactura():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	if (!flfactalma.iface.pub_valorDefectoAlmacen("refivaliquidacion") || flfactalma.iface.pub_valorDefectoAlmacen("refivaliquidacion") == "") {
		MessageBox.information(util.translate("scripts", "No existe referencia de IVA para la liquidación.\nDeberá crear un artículo con los datos a introducir en la línea de la factura y\n asignarlo en el formulario de datos generales del módulo de almacén"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var curFactura:FLSqlCursor = new FLSqlCursor("facturasprov");
	var fecha:Date = new Date();
	var hora:String = fecha.toString().right(8);
	var codProveedor:String = util.sqlSelect("agentes","codproveedor","codagente = '" + cursor.valueBuffer("codagente") + "'");
	var codEjercicio:String = flfactppal.iface.pub_ejercicioActual();
	var serie:String = util.sqlSelect("proveedores","codserie","codproveedor = '" + codProveedor + "'")
	
	var datosDoc:Array = flfacturac.iface.pub_datosDocFacturacion(fecha, codEjercicio, "facturasprov");
	if (!datosDoc.ok)
		return false;
	if (datosDoc.modificaciones == true) {
		codEjercicio = datosDoc.codEjercicio;
		fecha = datosDoc.fecha;
	}

	if (!util.sqlSelect("secuenciasejercicios", "id", "codejercicio = '" + codEjercicio + "' AND codserie = '" + serie + "'")) 
		serie = util.sqlSelect("secuenciasejercicios", "codserie", "codejercicio = '" + codEjercicio + "'");
		
	var sinIVA:Boolean = util.sqlSelect("series", "siniva", "codserie = '" + serie + "'");
	
	var pago:String = util.sqlSelect("proveedores","codpago","codproveedor = '" + codProveedor + "'")
	if (!pago)
		pago = flfactppal.iface.pub_valorDefectoEmpresa("codpago");
		
	var divisa:String = util.sqlSelect("proveedores","coddivisa","codproveedor = '" + codProveedor + "'")
	if (!divisa)
		divisa = flfactppal.iface.pub_valorDefectoEmpresa("coddivisa");
	
	with(curFactura) {
			setModeAccess(Insert);
			refreshBuffer();
			setValueBuffer("numero", 0);
			setValueBuffer("codserie", serie);
			setValueBuffer("codejercicio", codEjercicio);
			setValueBuffer("fecha", fecha);
			setValueBuffer("hora", hora);
			setValueBuffer("codalmacen", flfactppal.iface.pub_valorDefectoEmpresa("codalmacen"));
			setValueBuffer("codpago", pago);
			setValueBuffer("coddivisa", divisa);
			setValueBuffer("tasaconv", util.sqlSelect("divisas","tasaconv","coddivisa = '" + divisa + "'")); 
			setValueBuffer("codproveedor",codProveedor);
			setValueBuffer("cifnif", util.sqlSelect("proveedores","cifnif","codproveedor = '" + codProveedor + "'"));
			setValueBuffer("nombre", util.sqlSelect("proveedores","nombre","codproveedor = '" + codProveedor + "'"));
			setValueBuffer("automatica", false);
	}
	if (!curFactura.commitBuffer()) {
			return false;
	}

	var idFactura:Number = curFactura.valueBuffer("idfactura");
	var total = cursor.valueBuffer("total");
	var curLineaFactura:FLSqlCursor = new FLSqlCursor("lineasfacturasprov");

	curLineaFactura.setModeAccess(curLineaFactura.Insert);
	curLineaFactura.refreshBuffer();
	curLineaFactura.setValueBuffer("idfactura", idFactura);
	curLineaFactura.setValueBuffer("referencia", flfactalma.iface.pub_valorDefectoAlmacen("refivaliquidacion"));
	curLineaFactura.setValueBuffer("descripcion", util.sqlSelect("articulos", "descripcion", "referencia = '" + flfactalma.iface.pub_valorDefectoAlmacen("refivaliquidacion") + "'"));
	curLineaFactura.setValueBuffer("pvpunitario", total);
	if (sinIVA) {
		curLineaFactura.setNull("codimpuesto");
		curLineaFactura.setValueBuffer("iva", 0);
	} else {
		var codImpuesto:String = util.sqlSelect("articulos", "codimpuesto", "referencia = '" + flfactalma.iface.pub_valorDefectoAlmacen("refivaliquidacion") + "'");
		curLineaFactura.setValueBuffer("codimpuesto", codImpuesto);
		var iva:Number = flfacturac.iface.pub_campoImpuesto("iva", codImpuesto, fecha);
		curLineaFactura.setValueBuffer("iva", iva);
		var aplicarRecEq:Boolean = flfactppal.iface.pub_valorDefectoEmpresa("recequivalencia");
		var recargo:Number = 0;
		if (aplicarRecEq) {
			recargo = flfacturac.iface.pub_campoImpuesto("recargo", codImpuesto, fecha);
		}
		curLineaFactura.setValueBuffer("recargo", recargo);
	}
	curLineaFactura.setValueBuffer("cantidad", 1);
	curLineaFactura.setValueBuffer("pvpsindto",total);
	curLineaFactura.setValueBuffer("pvptotal",total);

	var irpf:Number = util.sqlSelect("agentes", "irpf", "codagente = '" + cursor.valueBuffer("codagente") + "'");
	curLineaFactura.setValueBuffer("irpf", irpf);

	var datosCtaLiq:Array = flfacturac.iface.pub_datosCtaEspecial("LIQAGE", codEjercicio);
	if (datosCtaLiq.error == 0) {
		curLineaFactura.setValueBuffer("codsubcuenta", datosCtaLiq.codsubcuenta);
		curLineaFactura.setValueBuffer("idsubcuenta", datosCtaLiq.idsubcuenta);
	}

	if (!curLineaFactura.commitBuffer())
		return false;

	curFactura.select("idfactura = " + idFactura);
	if (curFactura.first()) {
		/*
		if (!formRecordfacturasprov.iface.pub_actualizarLineasIva(idFactura))
				return false;
		*/
		
		curFactura.setModeAccess(curFactura.Edit);
		curFactura.refreshBuffer();
		curFactura.setValueBuffer("neto", total);
		curFactura.setValueBuffer("totaliva", formfacturasprov.iface.pub_commonCalculateField("totaliva", curFactura));
		curFactura.setValueBuffer("totalirpf", formfacturasprov.iface.pub_commonCalculateField("totalirpf", curFactura));
		curFactura.setValueBuffer("totalrecargo", formfacturasprov.iface.pub_commonCalculateField("totalrecargo", curFactura));
		curFactura.setValueBuffer("total", formfacturasprov.iface.pub_commonCalculateField("total", curFactura));
		curFactura.setValueBuffer("totaleuros", formfacturasprov.iface.pub_commonCalculateField("totaleuros", curFactura));
		curFactura.setValueBuffer("codigo", formfacturasprov.iface.pub_commonCalculateField("codigo", curFactura));
		if (!curFactura.commitBuffer())
			return false;
	}

	MessageBox.information(util.translate("scripts", "Se ha creado la factura %1").arg(util.sqlSelect("facturasprov","codigo","idfactura = " + idFactura)), MessageBox.Ok, MessageBox.NoButton);
	
	var curLiq:FLSqlCursor = new FLSqlCursor("liquidaciones");
	curLiq.select("codliquidacion = '" + cursor.valueBuffer("codliquidacion") + "'");
	if(!curLiq.first())
		return false;
	curLiq.setModeAccess(curLiq.Edit);
	curLiq.refreshBuffer();
	curLiq.setValueBuffer("codfactura", util.sqlSelect("facturasprov","codigo","idfactura = " + idFactura));
	if(!curLiq.commitBuffer())
		return false;
	
	return true;
}

/** \C
Al pulsar el botón imprimir se lanzará el informe correspondiente a la liquidación seleccionada (en caso de que el módulo de informes esté cargado)
\end */
function liqAgentes_imprimir()
{
	if (sys.isLoadedModule("flfactinfo")) {
		if (!this.cursor().isValid())
			return;
		var codigo:String = this.cursor().valueBuffer("codliquidacion");
		var curImprimir:FLSqlCursor = new FLSqlCursor("i_liquidaciones");
		curImprimir.setModeAccess(curImprimir.Insert);
		curImprimir.refreshBuffer();
		curImprimir.setValueBuffer("descripcion", "temp");
		curImprimir.setValueBuffer("d_liquidaciones_codliquidacion", codigo);
		curImprimir.setValueBuffer("h_liquidaciones_codliquidacion", codigo);
		flfactinfo.iface.pub_lanzarInforme(curImprimir, "i_liquidaciones");
	} else
		flfactppal.iface.pub_msgNoDisponible("Informes");
}

/** \C
Abre y procesa el resultado del formulario de generación automática de liquidaciones
\end */
function liqAgentes_pbnGenerarLiqAgentes_clicked()
{debug("liqAgentes_pbnGenerarLiqAgentes_clicked");
	var util:FLUtil = new FLUtil;
	var f:Object = new FLFormSearchDB("generarliqagentes");
	var cursor:FLSqlCursor = f.cursor();
	var where:String;
	
	cursor.setActivatedCheckIntegrity(false);
	cursor.select();
	if (!cursor.first()) {
		cursor.setModeAccess(cursor.Insert);
	} else {
		cursor.setModeAccess(cursor.Edit);
	}
	f.setMainWidget();
	cursor.refreshBuffer();
	var acpt:String = f.exec("id");
debug("acpt " + acpt);
	if (acpt) {
		if (!cursor.commitBuffer()) {
			debug("!commitBuffer()");
			return false;
		}
		var curTransaccion:FLSqlCursor = new FLSqlCursor("empresa");
		var curGenerarLiq:FLSqlCursor = new FLSqlCursor("generarliqagentes");
		curGenerarLiq.select();
		if (curGenerarLiq.first()) {
			var agentes:String = curGenerarLiq.valueBuffer("agentes");
debug("agentes " + agentes);
			if (!agentes || agentes == "") {
				MessageBox.warning(util.translate("scripts", "No ha seleccionado ningún agente"), MessageBox.Ok, MessageBox.NoButton);
				return false;
			}
			
			var aAgentes:Array = agentes.split(", ");
			var totalAgentes:Number = aAgentes.length;
			var codAgente:String;
			var filtroFacturas:String;
			util.createProgressDialog(util.translate("scripts", "Generando liquidaciones"), totalAgentes);
			util.setProgress(1);
			var j:Number = 0;
			for (var i:Number = 0; i < totalAgentes; i++) {
				codAgente = aAgentes[i];
debug("codAgente " + codAgente);
				curTransaccion.transaction(false);
				try {
					if (this.iface.generarLiquidacion(codAgente, curGenerarLiq)) {
						curTransaccion.commit();
					} else {
						curTransaccion.rollback();
						util.destroyProgressDialog();
						MessageBox.warning(util.translate("scripts", "Falló la creación de la liquidación correspondiente al agente: %1").arg(codAgente), MessageBox.Ok, MessageBox.NoButton);
						return;
					}
				} catch (e) {
					curTransaccion.rollback();
					util.destroyProgressDialog();
					MessageBox.critical(util.translate("scripts", "Error al generar la liquidación para el agente %1:").arg(codAgente) + e, MessageBox.Ok, MessageBox.NoButton);
				}
				util.setProgress(++j);
			}
			util.setProgress(totalAgentes);
			util.destroyProgressDialog();
			MessageBox.information(util.translate("scripts", "Se han generado %1 nuevas liquidaciones").arg(j), MessageBox.Ok, MessageBox.NoButton);
		}
	}
	return true;
}

/** \D Genera un registro de liquidación y asocia al mismo las facturas que cumplen los criterios impuestos en el cursor de generacion
@param	codAgente: Agente asociado a la liquidación
@param	curGenerarLiq: Cursor que contiene los criterios de búsqueda de las facturas
@return	código de la liquidación generada o false si hay un error
\end */
function liqAgentes_generarLiquidacion(codAgente:String, curGenerarLiq:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil;

	if (!this.iface.curLiquidacion_) {
		this.iface.curLiquidacion_ = new FLSqlCursor("liquidaciones");
	}
	this.iface.curLiquidacion_.setModeAccess(this.iface.curLiquidacion_.Insert);
	this.iface.curLiquidacion_.refreshBuffer();

	var codLiquidacion:String = util.nextCounter("codliquidacion", this.iface.curLiquidacion_);
	this.iface.curLiquidacion_.setValueBuffer("codliquidacion", codLiquidacion);
	this.iface.curLiquidacion_.setValueBuffer("codagente", codAgente);
	if (!this.iface.datosLiquidacion(curGenerarLiq)) {
		return false;
	}
	if (!this.iface.curLiquidacion_.commitBuffer()) {
		return false;
	}

	var filtro:String = flfactppal.iface.pub_obtenFiltroFacturas(codAgente, curGenerarLiq.valueBuffer("fechadesde"), curGenerarLiq.valueBuffer("fechahasta"), curGenerarLiq.valueBuffer("codejercicio"));
	if (!flfactppal.iface.pub_asociarFacturasLiq(filtro, codLiquidacion)) {
		return false;
	}

	this.iface.curLiquidacion_.select("codliquidacion = '" + codLiquidacion + "'");
	if (!this.iface.curLiquidacion_.first()) {
		return false;
	}
	this.iface.curLiquidacion_.setModeAccess(this.iface.curLiquidacion_.Edit);
	this.iface.curLiquidacion_.refreshBuffer();
	if (!this.iface.totalesLiquidacion()) {
		return false;
	}
	if (!this.iface.curLiquidacion_.commitBuffer()) {
		return false;
	}

	return codLiquidacion;
}

/** \D Informa los datos de una nueva liquidación con los del cursor de generación
@param	curGenerarLiq: Cursor de generación
\end */
function liqAgentes_datosLiquidacion(curGenerarLiq:FLSqlCursor):Boolean
{
	this.iface.curLiquidacion_.setValueBuffer("fecha", curGenerarLiq.valueBuffer("fecha"));
	this.iface.curLiquidacion_.setValueBuffer("fechadesde", curGenerarLiq.valueBuffer("fechadesde"));
	this.iface.curLiquidacion_.setValueBuffer("fechahasta", curGenerarLiq.valueBuffer("fechahasta"));
	this.iface.curLiquidacion_.setValueBuffer("codejercicio", curGenerarLiq.valueBuffer("codejercicio"));
	return true;
}

/** \D Informa los datos totalizados de una nueva liquidación
\end */
function liqAgentes_totalesLiquidacion(curGenerarLiq:FLSqlCursor):Boolean
{
	var hoy:Date = new Date;
	var filtro:String = "facturascli.codliquidacion = '" + this.iface.curLiquidacion_.valueBuffer("codliquidacion") + "'";
	this.iface.curLiquidacion_.setValueBuffer("total", flfactppal.iface.pub_calcularLiquidacionAgente(filtro));
	return true;
}

//// LIQAGENTES /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
