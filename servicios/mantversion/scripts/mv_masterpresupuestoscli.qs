/***************************************************************************
                 mv_presupuestoscli.qs  -  description
                             -------------------
    begin                : mie abr 25 2004
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
	var pbnGPedido:Object;
	var tdbRecords:FLTableDB;
	var tbnImprimir:Object;
    function oficial( context ) { interna( context ); } 
	function imprimir() {
			return this.ctx.oficial_imprimir();
	}
	function procesarEstado() {
			return this.ctx.oficial_procesarEstado();
	}
	function pbnGenerarPedido_clicked() {
			return this.ctx.oficial_pbnGenerarPedido_clicked();
	}
	function generarPedido(cursor:FLSqlCursor):Number {
			return this.ctx.oficial_generarPedido(cursor);
	}
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
			return this.ctx.oficial_commonCalculateField(fN, cursor);
	}
	function copiaPuntos(idPresupuesto:Number, idPedido:Number):Boolean {
			return this.ctx.oficial_copiaPuntos(idPresupuesto, idPedido);
	}
	function copiaPuntoPresupuesto(curPuntoPresupuesto:FLSqlCursor, idPedido:Number):Number {
			return this.ctx.oficial_copiaPuntoPresupuesto(curPuntoPresupuesto, idPedido);
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
		function pub_commonCalculateField(fN:String, cursor:FLSqlCursor):String {
				return this.commonCalculateField(fN, cursor); 
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
Este es el formulario maestro de presupuestos a cliente.
\end */
function interna_init()
{
		this.iface.pbnGPedido = this.child("pbnGenerarPedido");
		this.iface.tdbRecords= this.child("tableDBRecords");
		this.iface.tbnImprimir = this.child("toolButtonPrint");

		connect(this.iface.pbnGPedido, "clicked()", this, "iface.pbnGenerarPedido_clicked");
		connect(this.iface.tdbRecords, "currentChanged()", this, "iface.procesarEstado");
		connect(this.iface.tbnImprimir, "clicked()", this, "iface.imprimir");

		var codEjercicio = flfactppal.iface.pub_valorDefectoEmpresa("codejercicio");
		if (codEjercicio)
				this.cursor().setMainFilter("codejercicio = '" + codEjercicio + "'");

		this.iface.procesarEstado();
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \C
Al pulsar el botón imprimir se lanzará el informe correspondiente al presupuesto seleccionado (en caso de que el módulo de informes esté cargado)
\end */
function oficial_imprimir()
{
		if (sys.isLoadedModule("flfactinfo")) {
				if (!this.cursor().isValid())
						return;
				var codigo:String = this.cursor().valueBuffer("codigo");
				var curImprimir:FLSqlCursor = new FLSqlCursor("mv_presupuestoscli");
				curImprimir.setModeAccess(curImprimir.Insert);
				curImprimir.refreshBuffer();
				flfactinfo.iface.pub_lanzarInforme(curImprimir, "mv_i_presupuestoscli");
				return;
		}

		var tipoDoc:String = "mv_presupuestoscli";
		var f:Object = new FLFormSearchDB("facturas_imp");
		var cursor:FLSqlCursor = f.cursor();

		cursor.setActivatedCheckIntegrity(false);
		cursor.select();
		if (!cursor.first())
				cursor.setModeAccess(cursor.Insert);
		else
				cursor.setModeAccess(cursor.Edit);

		f.setMainWidget();
		cursor.refreshBuffer();
		var acpt:String = f.exec("desde");
		if (acpt) {
				cursor.commitBuffer();
				var q:FLSqlQuery = new FLSqlQuery(tipoDoc);
				q.setValueParam("from", cursor.valueBuffer("desde"));
				q.setValueParam("to", cursor.valueBuffer("hasta"));
				var rptViewer = new FLReportViewer();
				rptViewer.setReportTemplate(tipoDoc);
				rptViewer.setReportData(q);
				rptViewer.renderReport();
				rptViewer.exec();
				f.close();
		}
}

function oficial_procesarEstado()
{
		var cursor:FLSqlCursor = this.cursor();
		if (cursor.valueBuffer("editable") == false)
				this.iface.pbnGPedido.setEnabled(false);
		else
				this.iface.pbnGPedido.setEnabled(true);
}

/** \C
Al pulsar el botón de generar pedido se creará el albarán correspondiente al presupuesto seleccionado.
\end */
function oficial_pbnGenerarPedido_clicked()
{
		var cursor:FLSqlCursor = this.cursor();
		if (cursor.valueBuffer("editable") == false) {
			var util:FLUtil = new FLUtil;
			MessageBox.warning(util.translate("scripts", "El presupuesto ya está aprobado"), MessageBox.Ok, MessageBox.NoButton);
			this.iface.procesarEstado();
			return;
		}

		cursor.transaction(false);
		if (this.iface.generarPedido(cursor))
				cursor.commit();
		else
				cursor.rollback();

		this.iface.tdbRecords.refresh();
		this.iface.procesarEstado();
}

/** \D
Genera el pedido asociado a un presupuesto
@param cursor: Cursor con los datos principales que se copiarán del presupuesto al pedido
@return True: Copia realizada con éxito, False: Error
\end */
function oficial_generarPedido(cursor:FLSqlCursor):Number
{
	var retorno:Number;
	var where:String = "idpresupuesto = " + cursor.valueBuffer("idpresupuesto");
	var curPedido:FLSqlCursor = new FLSqlCursor("pedidoscli");
	var idPresupuesto:Number = cursor.valueBuffer("idpresupuesto");

	var numeroPedido:Number = flfacturac.iface.pub_siguienteNumero(cursor.valueBuffer("codserie"), cursor.valueBuffer("codejercicio"), "npedidocli");

	with(curPedido) {
		setModeAccess(Insert);
		refreshBuffer();
		setValueBuffer("numero", numeroPedido);
		setValueBuffer("codserie", cursor.valueBuffer("codserie"));
		setValueBuffer("codejercicio", cursor.valueBuffer("codejercicio"));
		setValueBuffer("irpf", cursor.valueBuffer("irpf"));
		setValueBuffer("fecha", cursor.valueBuffer("fecha"));
		setValueBuffer("codagente", cursor.valueBuffer("codagente"));
		setValueBuffer("porcomision", cursor.valueBuffer("porcomision"));
		setValueBuffer("codalmacen", cursor.valueBuffer("codalmacen"));
		setValueBuffer("codpago", cursor.valueBuffer("codpago"));
		setValueBuffer("coddivisa", cursor.valueBuffer("coddivisa"));
		setValueBuffer("tasaconv", cursor.valueBuffer("tasaconv"));
		setValueBuffer("codcliente", cursor.valueBuffer("codcliente"));
		setValueBuffer("cifnif", cursor.valueBuffer("cifnif"));
		setValueBuffer("nombrecliente", cursor.valueBuffer("nombrecliente"));
		setValueBuffer("coddir", cursor.valueBuffer("coddir"));
		setValueBuffer("direccion", cursor.valueBuffer("direccion"));
		setValueBuffer("codpostal", cursor.valueBuffer("codpostal"));
		setValueBuffer("ciudad", cursor.valueBuffer("ciudad"));
		setValueBuffer("provincia", cursor.valueBuffer("provincia"));
		setValueBuffer("apartado", cursor.valueBuffer("apartado"));
		setValueBuffer("codpais", cursor.valueBuffer("codpais"));
		setValueBuffer("recfinanciero", cursor.valueBuffer("recfinanciero"));
		setValueBuffer("idpresupuesto", idPresupuesto);
	}
	if (!curPedido.commitBuffer())
		return false;
		
	var idPedido:Number = curPedido.valueBuffer("idpedido");
	var curPresupuestos:FLSqlCursor = new FLSqlCursor("presupuestoscli");
	curPresupuestos.select(where);
	while (curPresupuestos.next()) {
		curPresupuestos.setModeAccess(curPresupuestos.Edit);
		curPresupuestos.refreshBuffer();
		idPresupuesto = curPresupuestos.valueBuffer("idpresupuesto");
		if (!this.iface.copiaPuntos(idPresupuesto, idPedido))
			return;
		curPresupuestos.setValueBuffer("editable", false);
		curPresupuestos.commitBuffer();
	}

	curPedido.select("idpedido = " + idPedido);
	if (curPedido.first()) {
		with(curPedido) {
			setModeAccess(Edit);
			refreshBuffer();
			setValueBuffer("neto", formpedidoscli.iface.pub_commonCalculateField("neto", curPedido));
			setValueBuffer("totaliva", formpedidoscli.iface.pub_commonCalculateField("totaliva", curPedido));
			setValueBuffer("totalirpf", formpedidoscli.iface.pub_commonCalculateField("totalirpf", curPedido));
			setValueBuffer("totalrecargo", formpedidoscli.iface.pub_commonCalculateField("totalrecargo", curPedido));
			setValueBuffer("total", formpedidoscli.iface.pub_commonCalculateField("total", curPedido));
			setValueBuffer("totaleuros", formpedidoscli.iface.pub_commonCalculateField("totaleuros", curPedido));
			setValueBuffer("codigo", formpedidoscli.iface.pub_commonCalculateField("codigo", curPedido));
		}
		if (curPedido.commitBuffer() == true)
			retorno = idPedido;
	}

	return retorno;
}

function oficial_commonCalculateField(fN:String, cursor:FLSqlCursor):String
{
		var util:FLUtil = new FLUtil();
		var valor:String;

		/** \C
		El --código-- se construye como la concatenación de --codserie--, --codejercicio-- y --numero--
		\end */
		if (fN == "codigo")
				valor = flfacturac.iface.pub_construirCodigo(cursor.valueBuffer("codserie"), cursor.valueBuffer("codejercicio"), cursor.valueBuffer("numero"));

		switch (fN) {
		/** \C
		El --total-- es el --neto-- menos el --totalirpf-- más el --totaliva-- más el --totalrecargo-- más el --recfinanciero--
		\end */
		case "total":{
						var neto:Number = parseFloat(cursor.valueBuffer("neto"));
						var totalIva:Number = parseFloat(cursor.valueBuffer("totaliva"));
						var recFinanciero:Number = (parseFloat(cursor.valueBuffer("recfinanciero")) * neto) / 100;
						valor = neto + totalIva + recFinanciero;
						break;
				}
		case "lblComision":{
						valor = (parseFloat(cursor.valueBuffer("porcomision")) * (parseFloat(cursor.valueBuffer("neto")))) / 100;
						break;
				}
		case "lblRecFinanciero":{
						valor = (parseFloat(cursor.valueBuffer("recfinanciero")) * (parseFloat(cursor.valueBuffer("neto")))) / 100;
						break;
				}
		/** \C
		El --totaleuros-- es el producto del --total-- por la --tasaconv--
		\end */
		case "totaleuros":{
						var total:Number = parseFloat(cursor.valueBuffer("total"));
						var tasaConv:Number = parseFloat(cursor.valueBuffer("tasaconv"));
						valor = total * tasaConv;
						break;
				}
		/** \C
		El --neto-- es la suma del pvp total de las líneas de factura
		\end */
		case "neto":{
						valor = util.sqlSelect("mv_puntopresupuesto", "SUM(total)", "idpresupuesto = " + cursor.valueBuffer("idpresupuesto"));
						break;
				}
		/** \C
		El --totaliva-- es la suma del iva correspondiente a las líneas de factura
		\end */
		case "totaliva":{
						var iva:Number = parseFloat(cursor.valueBuffer("poriva"));
						var neto:Number = parseFloat(cursor.valueBuffer("neto"));
						valor = neto * iva /100;
						break;
				}

		/** \C
		El --coddir-- corresponde a la dirección del cliente marcada como dirección de facturación
		\end */
		case "coddir": {
						valor = util.sqlSelect("dirclientes", "id", "codcliente = '" + cursor.valueBuffer("codcliente") + "' AND domfacturacion = 'true'");
						if (valor == 0)
								valor = "";
						break;
				}
		}
		return valor;
}
/** \D
Copia las líneas de un pedido como líneas de su albarán asociado
@param idPresupuesto: Identificador del pedido
@param idPedido: Identificador del pedido
\end */
function oficial_copiaPuntos(idPresupuesto:Number, idPedido:Number):Boolean
{
	var curPuntoPresupuesto:FLSqlCursor = new FLSqlCursor("mv_puntopresupuesto");
	curLineaPresupuesto.select("idpresupuesto = " + idPresupuesto);
	while (curPuntoPresupuesto.next()) {
		curPuntoPresupuesto.setModeAccess(curPuntoPresupuesto.Browse);
		curPuntoPresupuesto.refreshBuffer();
		if (!this.iface.copiaPuntoPresupuesto(curPuntoPresupuesto, idPedido))
			return false;
	}
	return true;
}

function oficial_copiaPuntoPresupuesto(curPuntoPresupuesto:FLSqlCursor, idPedido:Number):Number
{
	var curLineaPedido:FLSqlCursor = new FLSqlCursor("lineaspedidoscli");
	with(curLineaPedido) {
		setModeAccess(Insert);
		refreshBuffer();
		setValueBuffer("idpedido", idPedido);
		setValueBuffer("pvpunitario", curPuntoPresupuesto.valueBuffer("pvpunitario"));
		setValueBuffer("pvpsindto", curPuntoPresupuesto.valueBuffer("pvpsindto"));
		setValueBuffer("pvptotal", curPuntoPresupuesto.valueBuffer("pvptotal"));
		setValueBuffer("cantidad", curPuntoPresupuesto.valueBuffer("cantidad"));
		setValueBuffer("referencia", curPuntoPresupuesto.valueBuffer("referencia"));
		setValueBuffer("descripcion", curPuntoPresupuesto.valueBuffer("descripcion"));
		setValueBuffer("codimpuesto", curPuntoPresupuesto.valueBuffer("codimpuesto"));
		setValueBuffer("iva", curPuntoPresupuesto.valueBuffer("iva"));
		setValueBuffer("recargo", curPuntoPresupuesto.valueBuffer("recargo"));
		setValueBuffer("dtolineal", curPuntoPresupuesto.valueBuffer("dtolineal"));
		setValueBuffer("dtopor", curPuntoPresupuesto.valueBuffer("dtopor"));
	}
	if (!curLineaPedido.commitBuffer())
		return false;
	return curLineaPedido.valueBuffer("idlinea");
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
