/***************************************************************************
                 facturascli.qs  -  description
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
	function calculateField(fN:String):String { return this.ctx.interna_calculateField(fN); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var lblDatosFacturaAbono:Object;
    function oficial( context ) { interna( context ); } 
	function inicializarControles() {
		return this.ctx.oficial_inicializarControles();
	}
	function calcularTotales() {
		return this.ctx.oficial_calcularTotales();
	}
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function verificarHabilitaciones() {
		return this.ctx.oficial_verificarHabilitaciones();
	}
	function actualizarLineasIva(idFactura:Number):Boolean {
		return this.ctx.oficial_actualizarLineasIva(idFactura);
	}
	function buscarFactura() { this.ctx.oficial_buscarFactura(); }
	function mostrarDatosFactura(idFactura:String):Boolean{ return this.ctx.oficial_mostrarDatosFactura(idFactura);}
	function agregarLinea():Boolean { return this.ctx.oficial_agregarLinea(); }
	function eliminarLinea(idLinea:Number):Boolean { return this.ctx.oficial_eliminarLinea(idLinea); }
	function asociarIncidencias():Boolean { return this.ctx.oficial_asociarIncidencias(); }
	function crearLinea(incidencia:Number):Boolean { return this.ctx.oficial_crearLinea(incidencia); }
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration infosial */
//////////////////////////////////////////////////////////////////
//// INFOSIAL /////////////////////////////////////////////////////
class infosial extends oficial {
	function infosial( context ) { oficial( context ); }
	function init() { return this.ctx.infosial_init(); }	
}
//// INFOSIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration dtoEspecial */
/////////////////////////////////////////////////////////////////
//// DTO ESPECIAL ///////////////////////////////////////////////
class dtoEspecial extends infosial {
    function dtoEspecial( context ) { infosial ( context ); }
	function bufferChanged(fN:String) {
		return this.ctx.dtoEspecial_bufferChanged(fN);
	}
	function calcularTotales() {
		return this.ctx.dtoEspecial_calcularTotales();
	}
	function validateForm():Boolean {
		return this.ctx.dtoEspecial_validateForm();
	}
}
//// DTO ESPECIAL ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends dtoEspecial {
    function head( context ) { dtoEspecial ( context ); }
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration ifaceCtx */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends head {
    function ifaceCtx( context ) { head( context ); }
	function pub_actualizarLineasIva(idFactura:Number):Boolean {
		return this.actualizarLineasIva(idFactura);
	}
	function pub_eliminarLinea(idLinea:Number):Boolean {
		return this.eliminarLinea(idLinea);
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
/** \C
Este formulario realiza la gestión de los facturas de incidencias a clientes.

Las facturas pueden ser generadas de forma manual o a partir de una incidencia.
\end */

function interna_init()
{
		var util:FLUtil = new FLUtil();
		var cursor:FLSqlCursor = this.cursor();
		this.iface.lblDatosFacturaAbono = this.child("lblDatosFacturaAbono");
		connect(this.child("tdbLineasFacturasCli").cursor(), "bufferCommited()", this, "iface.calcularTotales");
		connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
		connect(this.child("tbnBuscarFactura"), "clicked()", this, "iface.buscarFactura()");
		connect( this.child( "tbInsert" ), "clicked()", this, "iface.agregarLinea");
		connect( this.child( "tbDelete" ), "clicked()", this, "iface.eliminarLinea");
		connect( this.child( "pbAsociar" ), "clicked()", this, "iface.asociarIncidencias");
	
	/** \C La tabla de lineas facturas se muestra en modo de sólo lectura
	\end */
		this.child( "tdbLineasFacturasCli" ).setReadOnly( true );

		if (cursor.modeAccess() == cursor.Insert) {
				this.child("fdbCodEjercicio").setValue(flfactppal.iface.pub_ejercicioActual());
				this.child("fdbCodDivisa").setValue(flfactppal.iface.pub_valorDefectoEmpresa("coddivisa"));
				this.child("fdbCodPago").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codpago"));
				this.child("fdbCodAlmacen").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codalmacen"));
				this.child("fdbCodSerie").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codserie"));
				this.child("fdbTasaConv").setValue(util.sqlSelect("divisas", "tasaconv", "coddivisa = '" + this.child("fdbCodDivisa").value() + "'"));
				this.child("tbnBuscarFactura").setDisabled(true);
				this.cursor().setValueBuffer("fincidencias", true);
		}
		else {
			if (this.cursor().valueBuffer("deabono") == true){
				this.child("tbnBuscarFactura").setDisabled(false);
				this.iface.mostrarDatosFactura(util.sqlSelect("facturascli", "idfacturarect", "codigo = '" + this.child("fdbCodigo").value() + "'"));
				 
			}
			else this.child("tbnBuscarFactura").setDisabled(true);
			}

		if (parseFloat(cursor.valueBuffer("idasiento")) != 0)
				this.child("ckbContabilizada").checked = true;

		if (cursor.valueBuffer("automatica") == true) {
				this.child("toolButtomInsert").setDisabled(true);
				this.child("toolButtonDelete").setDisabled(true);
				this.child("toolButtonEdit").setDisabled(true);
				this.child("tdbLineasFacturasCli").setReadOnly(true);
				this.child("fdbCodCliente").setDisabled(true);
				this.child("fdbNombreCliente").setDisabled(true);
				this.child("fdbCifNif").setDisabled(true);
				this.child("fdbCodDivisa").setDisabled(true);
				this.child("fdbRecFinanciero").setDisabled(true);
				this.child("fdbTasaConv").setDisabled(true);
		}
		this.iface.inicializarControles();
}


function interna_calculateField(fN:String):String
{
		return formfacturascli.iface.pub_commonCalculateField(fN, this.cursor());
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D
Se inhabilita la pestaña de contabilidad si el módulo de contabilidad no está cargado o no está integrada
\end **/
function oficial_inicializarControles()
{
		var util:FLUtil = new FLUtil();
		if (!sys.isLoadedModule("flcontppal")
				|| !util.sqlSelect("empresa", "contintegrada", "1 = 1"))
				this.child("tbwFactura").setTabEnabled("contabilidad", false);

		this.child("lblRecFinanciero").setText(this.iface.calculateField("lblRecFinanciero"));
		this.child("lblComision").setText(this.iface.calculateField("lblComision"));
		this.child("tdbLineasIvaFactCli").setReadOnly(true);
		this.child("tdbPartidas").setReadOnly(true);
		this.iface.verificarHabilitaciones();
}

/** \C
Calcula el --neto-- la --comisión-- del agente, el --iva-- y el --recargo--
\end **/
function oficial_calcularTotales()
{
		var idFactura:Number = this.cursor().valueBuffer("idfactura");
		this.iface.actualizarLineasIva(idFactura);
		this.child("tdbLineasIvaFactCli").refresh();
		this.child("fdbNeto").setValue(this.iface.calculateField("neto"));
    	this.child("lblComision").setText(this.iface.calculateField("lblComision"));
		this.child("fdbTotalIva").setValue(this.iface.calculateField("totaliva"));
		this.child("fdbTotalRecargo").setValue(this.iface.calculateField("totalrecargo"));
		this.iface.verificarHabilitaciones();
}

function oficial_bufferChanged(fN:String)
{
		switch (fN) {
		case "recfinanciero":
		case "neto":{
						this.child("lblRecFinanciero").setText(this.iface.calculateField("lblRecFinanciero"));
						this.child("fdbTotaIrpf").setValue(this.iface.calculateField("totalirpf"));
				}
		/** \C
		El --total-- es el --neto-- menos el --totalirpf-- más el --totaliva-- más el --totalrecargo-- más el --recfinanciero--
		\end */
		case "totaliva":
		case "totalirpf":
		case "totalrecargo":{
						this.child("fdbTotal").setValue(this.iface.calculateField("total"));
						break;
				}
		/** \C
		El --totaleuros-- es el producto del --total-- por la --tasaconv--
		\end */
		case "total":
		case "tasaconv":{
						this.child("fdbTotalEuros").setValue(this.iface.calculateField("totaleuros"));
						break;
				}
		/** \C
		Al cambiar el --porcomision-- se mostrará el total de comisión aplicada
		\end */
		case "porcomision":{
						this.child("lblComision").setText(this.iface.calculateField("lblComision"));
						break;
				}
		/** \C
		El valor de --coddir-- por defecto corresponde a la dirección del cliente marcada como dirección de facturación
		\end */
		case "codcliente": {
						this.child("fdbCodDir").setValue("x");
						this.child("fdbCodDir").setValue(this.iface.calculateField("coddir"));
						break;
				}
		/** \C
		El --irpf-- es el asociado a la --codserie-- del albarán
		\end */
		case "codserie": {
						this.cursor().setValueBuffer("irpf", this.iface.calculateField("irpf"));
						break;
				}
		/** \C
		El --totalirpf-- es el producto del --irpf-- por el --neto--
		\end */
		case "irpf": {
						this.child("fdbTotaIrpf").setValue(this.iface.calculateField("totalirpf"));
						break;
				}
		/** \C
		Si la factura es de abono se habilita el botón buscar factura, si no lo es se deshabilita y se borra la factura a rectificar si la hubiera
		\end */
		case "deabono": {
						if(this.cursor().valueBuffer("deabono") == true)
							this.child("tbnBuscarFactura").setDisabled(false);
						else{
							this.child("tbnBuscarFactura").setDisabled(true);
							this.iface.lblDatosFacturaAbono.text = "";
 							this.cursor().setValueBuffer("codigorect", ""); 
							this.cursor().setNull("idfacturarect"); 
							}
						break;
				}
		}
}

/** \D Habilita o deshabilita algunos controles dependiendo de si existen lineas para esa factura
*/
function oficial_verificarHabilitaciones()
{
		var util:FLUtil = new FLUtil();
		if (!util.sqlSelect("lineasfacturascli", "idfactura", "idfactura = " + this.cursor().valueBuffer("idfactura"))) {
				this.child("fdbCodAlmacen").setDisabled(false);
				this.child("fdbCodDivisa").setDisabled(false);
				this.child("fdbTasaConv").setDisabled(false);
		} else {
				this.child("fdbCodAlmacen").setDisabled(true);
				this.child("fdbCodDivisa").setDisabled(true);
				this.child("fdbTasaConv").setDisabled(true);
		}
}

/** \D
Actualiza (borra y reconstruye) los datos referentes a la factura en la tabla de agrupaciones por IVA (lineasivafactcli)
@param idFactura: Identificador de la factura
\end */
function oficial_actualizarLineasIva(idFactura:Number):Boolean
{
		var util:FLUtil = new FLUtil();
		var curLineaIva:FLSqlCursor = new FLSqlCursor("lineasivafactcli");
		curLineaIva.select("idfactura = " + idFactura);
		while (curLineaIva.next()) {
				curLineaIva.setModeAccess(curLineaIva.Del);
				curLineaIva.refreshBuffer();
				if (!curLineaIva.commitBuffer())
						return false;
		}

		var curLineasFactura:FLSqlCursor = new FLSqlCursor("lineasfacturascli");
		curLineasFactura.select("idfactura = " + idFactura + " ORDER BY codimpuesto");
		var codImpuestoAnt:Number = 0;
		var codImpuesto:Number = 0;
		var iva:Number;
		var recargo:Number;
		var totalNeto:Number = 0;
		var totalIva:Number = 0;
		var totalRecargo:Number = 0;
		var totalLinea:Number = 0;
		while (curLineasFactura.next()) {
				codImpuesto = curLineasFactura.valueBuffer("codimpuesto");
				if (codImpuestoAnt != 0 && codImpuestoAnt != codImpuesto) {
						totalIva = util.roundFieldValue((iva * totalNeto) / 100, "lineasivafactcli", "totaliva");
						totalRecargo = util.roundFieldValue((recargo * totalNeto) / 100, "lineasivafactcli", "totalrecargo");
						totalLinea = totalNeto + parseFloat(totalIva) + parseFloat(totalRecargo);

						with(curLineaIva) {
								setModeAccess(Insert);
								refreshBuffer();
								setValueBuffer("idfactura", idFactura);
								setValueBuffer("codimpuesto", codImpuestoAnt);
								setValueBuffer("iva", iva);
								setValueBuffer("recargo", recargo);
								setValueBuffer("neto", totalNeto);
								setValueBuffer("totaliva", totalIva);
								setValueBuffer("totalrecargo", totalRecargo);
								setValueBuffer("totallinea", totalLinea);
						}
						if (!curLineaIva.commitBuffer())
								return false;
						totalNeto = 0;
				}
				codImpuestoAnt = codImpuesto;
				iva = parseFloat(curLineasFactura.valueBuffer("iva"));
				recargo = parseFloat(curLineasFactura.valueBuffer("recargo"));
				totalNeto += parseFloat(curLineasFactura.valueBuffer("pvptotal"));
		}

		if (totalNeto != 0) {
				totalIva = util.roundFieldValue((iva * totalNeto) / 100, "lineasivafactcli", "totaliva");
				totalRecargo = util.roundFieldValue((recargo * totalNeto) / 100, "lineasivafactcli", "totalrecargo");
				totalLinea = totalNeto + parseFloat(totalIva) + parseFloat(totalRecargo);

				with(curLineaIva) {
						setModeAccess(Insert);
						refreshBuffer();
						setValueBuffer("idfactura", idFactura);
						setValueBuffer("codimpuesto", codImpuestoAnt);
						setValueBuffer("iva", iva);
						setValueBuffer("recargo", recargo);
						setValueBuffer("neto", totalNeto);
						setValueBuffer("totaliva", totalIva);
						setValueBuffer("totalrecargo", totalRecargo);
						setValueBuffer("totallinea", totalLinea);
				}
				if (!curLineaIva.commitBuffer())
						return false;
		}
		return true;
}


/** \D Muestra el formulario de busqueda de facturas de cliente filtrando las facturas 
que no estan abonadas y que no son la factura que se esta editando.
\end */
function oficial_buscarFactura()
{
	var ruta:Object = new FLFormSearchDB("facturascli");
	var curFacturas:FLSqlCursor = ruta.cursor();
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	
	if (cursor.modeAccess() == cursor.Insert)
		curFacturas.setMainFilter("deabono = false");
	else
		curFacturas.setMainFilter("deabono = false and idfactura <> " + this.cursor().valueBuffer("idfactura"));

	ruta.setMainWidget();
	var idFactura:String = ruta.exec("idfactura");

	if (idFactura){
		cursor.setValueBuffer("idfacturarect", idFactura);
		var codigo:String = util.sqlSelect("facturascli", "codigo", "idfactura = '" + idFactura + "'");
		cursor.setValueBuffer("codigorect", codigo);
		this.iface.mostrarDatosFactura(idFactura);
	}

}


/** \D Compone los datos dela factura a abonar en un label
@param	idFactura: identificador de la factura
@return	VERDADERO si no hay error. FALSO en otro caso
\end */
function oficial_mostrarDatosFactura(idFactura:String):Boolean
{
	var util:FLUtil = new FLUtil();
	var q:FLSqlQuery = new FLSqlQuery();
	
	q.setTablesList("facturascli");
	q.setSelect("codigo,fecha");
	q.setFrom("facturascli");
	q.setWhere("idfactura = '" + idFactura + "'");
	if (!q.exec())
		return false;
	if (!q.first())
		return false;
	var codFactura:String = q.value(0);
	var fecha:String = util.dateAMDtoDMA(q.value(1));
	this.iface.lblDatosFacturaAbono.text = "Rectifica a la factura  " + codFactura + " con fecha " + fecha;
	
	return true;
}

/** \D Se agrega una linea a la factura.
@return devuelve true se si ha agregado correctamente y false si ha habido algún error
\end */
function oficial_agregarLinea():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	if ( !cursor.commitBuffer() )
		return false;

	cursor.setModeAccess( cursor.Edit );
	cursor.seek( cursor.at() );
	cursor.refreshBuffer();

	this.child( "fdbCodCliente" ).setDisabled( true );

	var incidencias:Object = new FLFormSearchDB( "se_incidencias" );
	incidencias.setMainWidget();

	incidencias.cursor().setMainFilter( "codcliente ='" + cursor.valueBuffer("codcliente") + "' AND facturar = true AND idfactura IS NULL AND estado = 'Resuelta'" );
	var incidencia:Number = incidencias.exec( "codigo" );

	if(incidencia)
		return this.iface.crearLinea(incidencia);
	return false;
}

/** \D Se elimina la linea activa de la factura
@param idLinea: identificador de la línea a eliminar
@return devuelve true si se ha eliminado correctamente y false si ha habido algún error
\end */
function oficial_eliminarLinea(idLinea:Number):Boolean
{
	var util:FLUtil = new FLUtil();
	
	var curLF:FLSqlCursor;
	var tdbLineas:Object
	if (idLinea){
		curLF = new FLSqlCursor("lineasfacturascli");
		curLF.select("idlinea = " + idLinea); 
		if(!curLF.next())
			return false;
	}
	else {
		 tdbLineas = this.child( "tdbLineasFacturasCli" );
		curLF = tdbLineas.cursor();
		if (curLF.size() == 0)
			return false;
		
		var res:Number  = MessageBox.information(util.translate( "scripts", "El registro activo será borrado. ¿Esta seguro?" ), MessageBox.Yes, MessageBox.No);
		if(res != MessageBox.Yes)
		return false;
	}
	
	var curIncidencias:FLSqlCursor = new FLSqlCursor("se_incidencias");

	curIncidencias.select("idlinea = " + curLF.valueBuffer("idlinea"));
	curIncidencias.first();
	curIncidencias.setModeAccess( curIncidencias.Edit );
	curIncidencias.refreshBuffer();
	curIncidencias.setUnLock("facturada", true);
	if ( !curIncidencias.commitBuffer() )
		return false;
	
	curIncidencias.select("idlinea = " + curLF.valueBuffer("idlinea"));
	curIncidencias.first();
	curIncidencias.setModeAccess( curIncidencias.Edit );
	curIncidencias.refreshBuffer();
	curIncidencias.setNull( "idfactura" );
	curIncidencias.setNull( "idlinea" );
	curIncidencias.setValueBuffer( "facturar",true );
	if ( !curIncidencias.commitBuffer() )
		return false;

	curLF.setModeAccess(curLF.Del);
	if ( !curLF.commitBuffer() )
		return false;

	if(!idLinea){
		tdbLineas.refresh();
		this.iface.calcularTotales();
	}

	return true;
}

/** \D Asocia automáticamente a la factura todas las incidencias pendientes de facturar
del cliente actual
\end */
function oficial_asociarIncidencias()
{
	var util:FLUtil = new FLUtil();
	var cursor = this.cursor();

	if ( !cursor.commitBuffer() )
		return false;
	cursor.setModeAccess( cursor.Edit );
	cursor.seek( cursor.at() );
	cursor.refreshBuffer();

	this.child( "fdbCodCliente" ).setDisabled( true );

	var qryIncidencias:FLSqlQuery = new FLSqlQuery();
	qryIncidencias.setTablesList("se_incidencias");
	qryIncidencias.setSelect("codigo");
	qryIncidencias.setFrom("se_incidencias");
	qryIncidencias.setWhere("codcliente = '" + cursor.valueBuffer("codcliente") + "' AND facturar = true AND idfactura IS NULL AND estado = 'Resuelta'");
	if(!qryIncidencias.exec())
		return false

	util.createProgressDialog( util.translate( "scripts", "Asociando incidencias pendientes de facturar.." ),qryIncidencias.size());
	
	var i:Number = 0;
	while (qryIncidencias.next()){
		util.setProgress(i);
		if(!this.iface.crearLinea(qryIncidencias.value(0)))
			return false;
		i ++;
	
	}
	util.destroyProgressDialog();

	return true;
}

/** \D Crea la linea estableciendo todos sus datos
@param incidencia: codigo de la incidencia
@return devuelve true si se ha creado correctamente y false si ha habido algún error
\end */
function oficial_crearLinea(incidencia:Number):Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var curIncidencias:FLSqlCursor = new FLSqlCursor( "se_incidencias" );
	curIncidencias.setActivatedCheckIntegrity( false );
	curIncidencias.select( "codigo = '" + incidencia + "'");

	var curLineas:FLSqlCursor = this.child("tdbLineasFacturasCli").cursor();
	curLineas.setModeAccess( curLineas.Insert );
	if (cursor.modeAccess() == cursor.Insert)
		curLineas.commitBufferCursorRelation();
	
	curLineas.refreshBuffer();
	curLineas.setValueBuffer( "idfactura", this.cursor().valueBuffer( "idfactura" ) );
	curLineas.setValueBuffer( "referencia", "HORADESARROLLO");
	curLineas.setValueBuffer( "descripcion", incidencia + ": " + util.sqlSelect("se_incidencias","desccorta","codigo = '" + incidencia + "'"));
	var pvpUnitarioIVA:Number = parseFloat(util.sqlSelect("se_opciones INNER JOIN articulos ON se_opciones.refcostehora = articulos.referencia", "articulos.pvp", "1 = 1", "se_opciones,articulos"));
	curLineas.setValueBuffer( "pvpunitarioiva", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpunitarioiva", curLineas));
	curLineas.setValueBuffer( "codimpuesto", formRecordlineaspedidoscli.iface.pub_commonCalculateField("codimpuesto", curLineas ));
	curLineas.setValueBuffer( "iva", formRecordlineaspedidoscli.iface.pub_commonCalculateField("iva", curLineas) );
		
	curLineas.setValueBuffer( "ivaincluido", formRecordlineaspedidoscli.iface.pub_commonCalculateField("ivaincluido", curLineas));
	curLineas.setValueBuffer( "pvpunitario", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpunitario", curLineas));
	
	if (this.cursor().valueBuffer("codejercicio").startsWith("B")) {
		curLineas.setNull( "codimpuesto" );
		curLineas.setValueBuffer( "iva", 0);
		curLineas.setValueBuffer( "pvpunitarioiva", curLineas.valueBuffer( "pvpunitario")); 
	}
	
	var cantidad:Number = parseFloat(util.sqlSelect("se_incidencias","horas","codigo = '" + incidencia + "'"));
	curLineas.setValueBuffer( "cantidad", cantidad);
	curLineas.setValueBuffer( "pvpsindto", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpsindto", curLineas));
	curLineas.setValueBuffer( "pvptotal", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotal", curLineas));
	if ( !curLineas.commitBuffer() )
		return false;

	var idLinea:Number = curLineas.valueBuffer("idlinea");

	if ( curIncidencias.next() ) {
		curIncidencias.setActivatedCheckIntegrity( false );
		curIncidencias.setModeAccess( curIncidencias.Edit );
		curIncidencias.refreshBuffer();
		curIncidencias.setValueBuffer( "idfactura", this.cursor().valueBuffer( "idfactura" ) );
		curIncidencias.setValueBuffer( "idlinea", idLinea );
		curIncidencias.setValueBuffer( "facturar", false );
		if ( !curIncidencias.commitBuffer() )
			return false;

	}
	curIncidencias.select( "codigo = '" + incidencia + "'");
	if ( curIncidencias.next() ){
		curIncidencias.setUnLock("facturada", false);
		if ( !curIncidencias.commitBuffer() )
			return false;
	
		this.child( "tdbLineasFacturasCli" ).refresh();
		this.iface.calcularTotales();
	}
	return true;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition infosial */
//////////////////////////////////////////////////////////////////
//// INFOSIAL /////////////////////////////////////////////////////
function infosial_init()
{
	this.iface.__init();
		
// 	if(this.cursor().valueBuffer("fincidencias") == true){
// 		this.child("toolButtomInsert").setDisabled(true);
// 			this.child("toolButtonDelete").setDisabled(true);
// 			this.child("toolButtonEdit").setDisabled(true);
// 			this.child("tdbLineasFacturasCli").setReadOnly(true);
// 			this.child("fdbCodCliente").setDisabled(true);
// 			this.child("fdbNombreCliente").setDisabled(true);
// 			this.child("fdbCifNif").setDisabled(true);
// 			this.child("fdbCodDivisa").setDisabled(true);
// 			this.child("fdbRecFinanciero").setDisabled(true);
// 			this.child("fdbTasaConv").setDisabled(true);
// 	}
}
//// INFOSIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition dtoEspecial */
//////////////////////////////////////////////////////////////////
//// DTO ESPECIAL ////////////////////////////////////////////////
function dtoEspecial_bufferChanged(fN:String)
{
	switch (fN) {
	case "neto": {
			form.child("fdbTotalIva").setValue(this.iface.calculateField("totaliva"));
			form.child("fdbTotalRecargo").setValue(this.iface.calculateField("totalrecargo"));
			this.iface.__bufferChanged(fN);
			break;
		}
	/** \C
	El --neto-- es el producto del --netosindtoesp-- por el --pordtoesp--
	\end */
	case "netosindtoesp":
	case "pordtoesp": {
			this.child("fdbDtoEsp").setValue(this.iface.calculateField("dtoesp"));
			break;
		}
	case "dtoesp": {
			this.child("fdbNeto").setValue(this.iface.calculateField("neto"));
			break;
		}
	default: {
			this.iface.__bufferChanged(fN);
			break;
		}
	}
}

function dtoEspecial_calcularTotales()
{
		this.child("fdbNetoSinDtoEsp").setValue(this.iface.calculateField("netosindtoesp"));
		this.iface.__calcularTotales();
}

/** \C
Comprueba que no hay lineas con distinto IVA y/o recargo a la hora de crear una factura con descuento especial
@ return Devuelve verdadero si la validación es correcta y falso si hay algún error
\end */
function dtoEspecial_validateForm():Boolean
{
	try {
		if (!this.iface.__validateForm())
			return false;
	}
	catch(e) {}
	
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil;
	if (parseFloat(cursor.valueBuffer("dtoesp")) != 0) {
		var idFactura:Number = cursor.valueBuffer("idfactura");
		var q:FLSqlQuery = new FLSqlQuery();
		q.setTablesList("lineasfacturascli");
			q.setSelect("l1.idlinea");
		q.setFrom("lineasfacturascli l1 INNER JOIN lineasfacturascli l2 ON (l1.iva <> l2.iva OR l1.recargo <> l2.recargo) ");
		q.setWhere("l1.idfactura = " + idFactura + " AND l2.idfactura = " + idFactura);
		if (!q.exec())
			return false;
		if (q.first()) {
			MessageBox.critical(util.translate("scripts", "No es posible establecer un descuento especial cuando hay líneas con distinto valor de IVA y/o recargo"), MessageBox.Ok);
			return false;
		}
	}
	return true;
}
//// DTO ESPECIAL ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////