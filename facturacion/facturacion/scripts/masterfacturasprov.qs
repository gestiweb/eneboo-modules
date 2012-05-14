/***************************************************************************
                 masterfacturasprov.qs  -  description
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
        var pbnAFactura:Object;
        var tdbRecords:FLTableDB;
        var tbnImprimir:Object;
        var curFactura:FLSqlCursor;
        var curLineaFactura:FLSqlCursor;
    function oficial( context ) { interna( context ); }
        function imprimir(codFactura:String) {
                return this.ctx.oficial_imprimir(codFactura);
        }
        function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
                return this.ctx.oficial_commonCalculateField(fN, cursor);
        }
        function asociarAFactura() {
                return this.ctx.oficial_asociarAFactura();
        }
        function whereAgrupacion(curAgrupar:FLSqlCursor):String {
                return this.ctx.oficial_whereAgrupacion(curAgrupar);
        }
        function sinIVA(cursor:FLSqlCursor):Boolean {
                return this.ctx.oficial_sinIVA(cursor);
        }
        function copiarFactura_clicked() {
                return this.ctx.oficial_copiarFactura_clicked();
        }
        function copiarFactura(curFactura:FLSqlCursor):Number {
                return this.ctx.oficial_copiarFactura(curFactura);
        }
        function copiadatosFactura(curFactura:FLSqlCursor):Boolean {
                return this.ctx.oficial_copiadatosFactura(curFactura);
        }
        function copiaLineasFactura(idFacturaOrigen:Number,idFacturaDestino:Number):Boolean {
                return this.ctx.oficial_copiaLineasFactura(idFacturaOrigen,idFacturaDestino);
        }
        function copiaLineaFactura(curLineaFactura:FLSqlCursor, idFactura:Number):Number {
                return this.ctx.oficial_copiaLineaFactura(curLineaFactura, idFactura);
        }
        function totalesFactura():Boolean {
                return this.ctx.oficial_totalesFactura();
        }
        function copiadatosLineaFactura(curLineaFactura:FLSqlCursor):Boolean {
                return this.ctx.oficial_copiadatosLineaFactura(curLineaFactura);
        }
        function dameDatosAgrupacionAlbaranes(curAgruparAlbaranes:FLSqlCursor):Array {
                return this.ctx.oficial_dameDatosAgrupacionAlbaranes(curAgruparAlbaranes);
        }
        function filtrarTabla():Boolean {
                return this.ctx.oficial_filtrarTabla();
        }
        function filtroTabla():String {
                return this.ctx.oficial_filtroTabla();
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
        function pub_whereAgrupacion(curAgrupar:FLSqlCursor):String {
                return this.whereAgrupacion(curAgrupar);
        }
        function pub_imprimir(codFactura:String) {
                return this.imprimir(codFactura);
        }
        function pub_sinIVA(cursor:FLSqlCursor):Boolean {
                return this.sinIVA(cursor);
        }
}


//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

const iface = new ifaceCtx( this );

/** @class_definition interna */
////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
/** \C
Este es el formulario maestro de facturas a proveedor.
\end */
function interna_init()
{
        this.iface.pbnAFactura = this.child("pbnAsociarAFactura");
        this.iface.tdbRecords= this.child("tableDBRecords");
        this.iface.tbnImprimir = this.child("toolButtonPrint");

        connect(this.iface.pbnAFactura, "clicked()", this, "iface.asociarAFactura()");
        connect(this.iface.tbnImprimir, "clicked()", this, "iface.imprimir");
        connect(this.child("toolButtonCopy"), "clicked()", this, "iface.copiarFactura_clicked()");

        this.iface.filtrarTabla();
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \C
Al pulsar el botón imprimir se lanzará el informe correspondiente a la factura seleccionada (en caso de que el módulo de informes esté cargado)
\end */
function oficial_imprimir(codFactura:String)
{
        if (sys.isLoadedModule("flfactinfo")) {
                var codigo:String;
                if (codFactura) {
                        codigo = codFactura;
                } else {
                        if (!this.cursor().isValid())
                                return;
                        codigo = this.cursor().valueBuffer("codigo");
                }
                var curImprimir:FLSqlCursor = new FLSqlCursor("i_facturasprov");
                curImprimir.setModeAccess(curImprimir.Insert);
                curImprimir.refreshBuffer();
                curImprimir.setValueBuffer("descripcion", "temp");
                curImprimir.setValueBuffer("d_facturasprov_codigo", codigo);
                curImprimir.setValueBuffer("h_facturasprov_codigo", codigo);
                flfactinfo.iface.pub_lanzarInforme(curImprimir, "i_facturasprov");
        } else
                flfactppal.iface.pub_msgNoDisponible("Informes");
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
        case "total": {
                        var neto:Number = parseFloat(cursor.valueBuffer("neto"));
                        var totalIva:Number = parseFloat(cursor.valueBuffer("totaliva"));
                        var totalIrpf:Number = parseFloat(cursor.valueBuffer("totalirpf"));
                        var totalRecargo:Number = parseFloat(cursor.valueBuffer("totalrecargo"));
                        var recFinanciero:Number = (parseFloat(cursor.valueBuffer("recfinanciero")) * neto) / 100;
                        recFinanciero = parseFloat(util.roundFieldValue(recFinanciero, "facturasprov", "total"));
                        valor = neto - totalIrpf + totalIva + totalRecargo + recFinanciero;
                        valor = parseFloat(util.roundFieldValue(valor, "facturasprov", "total"));
                        break;
                }
                /** \C
                El --totaleuros-- es el producto del --total-- por la --tasaconv--
                \end */
                case "totaleuros": {
                        var total:Number = parseFloat(cursor.valueBuffer("total"));
                        var tasaConv:Number = parseFloat(cursor.valueBuffer("tasaconv"));
                        valor = total * tasaConv;
                        valor = parseFloat(util.roundFieldValue(valor, "facturasprov", "totaleuros"));
                        break;
                }
                /** \C
                El --neto-- es la suma del pvp total de las líneas de albarán
                \end */
                case "neto": {
                        valor = util.sqlSelect("lineasfacturasprov", "SUM(pvptotal)", "idfactura = " + cursor.valueBuffer("idfactura"));
                        valor = parseFloat(util.roundFieldValue(valor, "facturasprov", "neto"));
                        break;
                }
                /** \C
                El --totaliva-- es la suma del iva correspondiente a las líneas de albarán
                \end */
                case "totaliva": {
                        if (this.iface.sinIVA(cursor))
                                valor = 0;
                        else {
                                valor = util.sqlSelect("lineasfacturasprov", "SUM((pvptotal * iva) / 100)", "idfactura = " + cursor.valueBuffer("idfactura"));
                                valor = parseFloat(util.roundFieldValue(valor, "facturasprov", "totaliva"));
                        }
                        break;
                }
                /** \C
                El --totarecargo-- es la suma del recargo correspondiente a las líneas de albarán
                \end */
                case "totalrecargo": {
                        if (this.iface.sinIVA(cursor))
                                valor = 0;
                        else {
                                valor = util.sqlSelect("lineasfacturasprov", "SUM((pvptotal * recargo) / 100)", "idfactura = " + cursor.valueBuffer("idfactura"));
                                valor = parseFloat(util.roundFieldValue(valor, "facturasprov", "totalrecargo"));
                        }
                        break;
                }
                /** \C
                El --irpf-- es el asociado al --codserie-- del albarán
                \end */
                case "irpf": {
                        valor = util.sqlSelect("series", "irpf", "codserie = '" + cursor.valueBuffer("codserie") + "'");
                        break;
                }
                /** \C
                El --totalirpf-- es el producto del --irpf-- por el --neto--
                \end */
                case "totalirpf": {
                        valor = util.sqlSelect("lineasfacturasprov", "SUM((pvptotal * irpf) / 100)", "idfactura = " + cursor.valueBuffer("idfactura"));
//                        valor = (parseFloat(cursor.valueBuffer("irpf")) * (parseFloat(cursor.valueBuffer("neto")))) / 100;
                        valor = parseFloat(util.roundFieldValue(valor, "facturasprov", "totalrecargo"));
                        break;
                }
        }
        return valor;
}

/** \C
Al pulsar el botón de asociar a factura se abre la ventana de agrupar albaranes de proveedor
\end */
function oficial_asociarAFactura()
{
        var util:FLUtil = new FLUtil;
        var f:Object = new FLFormSearchDB("agruparalbaranesprov");
        var cursor:FLSqlCursor = f.cursor();
        var where:String;
        var codProveedor:String;
        var codAlmacen:String;

        cursor.setActivatedCheckIntegrity(false);
        cursor.select();
        if (!cursor.first()) {
                cursor.setModeAccess(cursor.Insert);
        } else {
                cursor.setModeAccess(cursor.Edit);
        }

        f.setMainWidget();
        cursor.refreshBuffer();
        var acpt:String = f.exec("codejercicio");
        if (acpt) {
                cursor.commitBuffer();

                var curAgruparAlbaranes:FLSqlCursor = new FLSqlCursor("agruparalbaranesprov");
                curAgruparAlbaranes.select();
                if (curAgruparAlbaranes.first()) {
                        where = this.iface.whereAgrupacion(curAgruparAlbaranes);
                        var excepciones:FLSqlCursor = curAgruparAlbaranes.valueBuffer("excepciones");
                        if (!excepciones.isEmpty()) {
                                where += " AND idalbaran NOT IN (" + excepciones + ")";
                        }
                        var qryAgruparAlbaranes:FLSqlQuery = new FLSqlQuery;
                        qryAgruparAlbaranes.setTablesList("albaranesprov");
                        qryAgruparAlbaranes.setSelect("codproveedor,codalmacen");
                        qryAgruparAlbaranes.setFrom("albaranesprov");
                        qryAgruparAlbaranes.setWhere(where + " GROUP BY codproveedor,codalmacen");

                        if (!qryAgruparAlbaranes.exec()) {
                                return;
                        }

                        var totalProv:Number = qryAgruparAlbaranes.size();
                        util.createProgressDialog(util.translate("scripts", "Generando facturas"), totalProv);
                        util.setProgress(1);
                        var j:Number = 0;

                        var curAlbaran:FLSqlCursor = new FLSqlCursor("albaranesprov");
                        var whereFactura:String;
                        var datosAgrupacion:Array = [];
                        while (qryAgruparAlbaranes.next()) {
                                codProveedor = qryAgruparAlbaranes.value(0);
                                codAlmacen = qryAgruparAlbaranes.value(1);
                                whereFactura = where;
                                if(codProveedor && codProveedor != "")
                                        whereFactura += " AND codproveedor = '" + codProveedor + "'";
                                if(codAlmacen && codAlmacen != "")
                                         whereFactura += " AND codalmacen = '" + codAlmacen + "'";

                                curAlbaran.transaction(false);
                                try {
                                        curAlbaran.select(whereFactura);
                                        if (!curAlbaran.first()) {
                                                curAlbaran.rollback();
                                                util.destroyProgressDialog();
                                                return;
                                        }

                                        datosAgrupacion = this.iface.dameDatosAgrupacionAlbaranes(curAgruparAlbaranes);
                                        if (formalbaranesprov.iface.pub_generarFactura(whereFactura, curAlbaran, datosAgrupacion)) {
                                                curAlbaran.commit();
                                        } else {
                                                MessageBox.warning(util.translate("scripts", "Falló la inserción de la factura correspondiente al cliente: ") + codCliente, MessageBox.Ok, MessageBox.NoButton);
                                                curAlbaran.rollback();
                                                util.destroyProgressDialog();
                                                return;
                                        }
                                } catch (e) {
                                        curAlbaran.rollback();
                                        MessageBox.critical(util.translate("scripts", "Error al generar la factura:") + e, MessageBox.Ok, MessageBox.NoButton);
                                }
                                util.setProgress(++j);
                        }
                        util.setProgress(totalProv);
                        util.destroyProgressDialog();
                }

                f.close();
                this.iface.tdbRecords.refresh();
        }
}
/** \D
Construye un array con los datos de la factura a generar especificados en el formulario de agrupación de albaranes
@param curAgruparAlbaranes: Cursor de la tabla agruparalbaranesprov que contiene los valores
@return Array
\end */
function oficial_dameDatosAgrupacionAlbaranes(curAgruparAlbaranes:FLSqlCursor):Array
{
        var res:Array = [];
        res["fecha"] = curAgruparAlbaranes.valueBuffer("fecha");
        res["hora"] = curAgruparAlbaranes.valueBuffer("hora");
        return res;
}

/** \D
Construye la sentencia WHERE de la consulta que buscará los albaranes a agrupar
@param curAgrupar: Cursor de la tabla agruparalbaranescli que contiene los valores de los criterios de búsqueda
@return Sentencia where
\end */
function oficial_whereAgrupacion(curAgrupar:FLSqlCursor):String
{
                var codProveedor:String = curAgrupar.valueBuffer("codproveedor");
                var nombre:String = curAgrupar.valueBuffer("nombre");
                var cifNif:String = curAgrupar.valueBuffer("cifnif");
                var codAlmacen:String = curAgrupar.valueBuffer("codalmacen");
                var codPago:String = curAgrupar.valueBuffer("codpago");
                var codDivisa:String = curAgrupar.valueBuffer("coddivisa");
                var codSerie:String = curAgrupar.valueBuffer("codserie");
                var codEjercicio:String = curAgrupar.valueBuffer("codejercicio");
                var fechaDesde:String = curAgrupar.valueBuffer("fechadesde");
                var fechaHasta:String = curAgrupar.valueBuffer("fechahasta");
                var where:String = "albaranesprov.ptefactura = 'true'";
                if (codProveedor && !codProveedor.isEmpty())
                                where += " AND albaranesprov.codproveedor = '" + codProveedor + "'";
                if (cifNif && !cifNif.isEmpty())
                                where += " AND albaranesprov.cifnif = '" + cifNif + "'";
                if (codAlmacen && !codAlmacen.isEmpty())
                                where = where + " AND albaranesprov.codalmacen = '" + codAlmacen + "'";
                where = where + " AND albaranesprov.fecha >= '" + fechaDesde + "'";
                where = where + " AND albaranesprov.fecha <= '" + fechaHasta + "'";
                if (codPago && !codPago.isEmpty())
                                where = where + " AND albaranesprov.codpago = '" + codPago + "'";
                if (codDivisa && !codDivisa.isEmpty())
                                where = where + " AND albaranesprov.coddivisa = '" + codDivisa + "'";
                if (codSerie && !codSerie.isEmpty())
                                where = where + " AND albaranesprov.codserie = '" + codSerie + "'";
                if (codEjercicio && !codEjercicio.isEmpty())
                                where = where + " AND albaranesprov.codejercicio = '" + codEjercicio + "'";

                return where;
}

function oficial_sinIVA(cursor:FLSqlCursor):Boolean
{
        var util:FLUtil = new FLUtil();

        var serie:String = cursor.valueBuffer("codserie");
        if (util.sqlSelect("series","siniva","codserie = '" + serie + "'"))
                return true;

        var codProveedor:String = cursor.valueBuffer("codproveedor");
        var regimenIVA:String = util.sqlSelect("proveedores", "regimeniva", "codproveedor = '" + codProveedor + "'");
        if (regimenIVA == "Exento" || regimenIVA == "UE")
                return true;

        return false;
}

function oficial_copiarFactura_clicked()
{
        var util:FLUtil = new FLUtil;
        var cursor:FLSqlCursor = this.cursor();

        cursor.transaction(false);
        try {
                if (this.iface.copiarFactura(cursor))
                        cursor.commit();
                else
                        cursor.rollback();
        }
        catch (e) {
                cursor.rollback();
                MessageBox.critical(util.translate("scripts", "Hubo un error en la copia de la factura:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
        }

        this.iface.tdbRecords.refresh();
}

function oficial_copiarFactura(curFactura:FLSqlCursor):Number
{
        var util:FLUtil = new FLUtil();

        if (!this.iface.curFactura)
                this.iface.curFactura = new FLSqlCursor("facturasprov");

        util.createProgressDialog(util.translate("scripts", "Copiando Factura...."), 3);
        var progreso = 0;

        this.iface.curFactura.setModeAccess(this.iface.curFactura.Insert);
        this.iface.curFactura.refreshBuffer();

        progreso = 1;
        util.setProgress(progreso);

        if (!this.iface.copiadatosFactura(curFactura)) {
                util.destroyProgressDialog();
                return false;
        }

        if (!this.iface.curFactura.commitBuffer()) {
                util.destroyProgressDialog();
                return false;
        }

        var idFactura:Number = this.iface.curFactura.valueBuffer("idfactura");

        progreso = 2;
        util.setProgress(progreso);

        if (!this.iface.copiaLineasFactura(curFactura.valueBuffer("idfactura"), idFactura)) {
                util.destroyProgressDialog();
                return false;
        }

        this.iface.curFactura.select("idfactura = " + idFactura);
        if (this.iface.curFactura.first()) {
                this.iface.curFactura.setModeAccess(this.iface.curFactura.Edit);
                this.iface.curFactura.refreshBuffer();

                progreso = 3;
                util.setProgress(progreso);

                if (!this.iface.totalesFactura()) {
                        util.destroyProgressDialog();
                        return false;
                }
                if (this.iface.curFactura.commitBuffer() == false) {
                        util.destroyProgressDialog();
                        return false;
                }
        }
        util.destroyProgressDialog();
        return idFactura;
}

function oficial_copiadatosFactura(curFactura:FLSqlCursor):Boolean
{
        var util:FLUtil = new FLUtil();
        var fecha:String;
        var hora:String;
        if (curFactura.action() == "facturasprov") {
                var hoy:Date = new Date();
                fecha = hoy.toString();
                hora = hoy.toString().right(8);
        } else {
                fecha = curFactura.valueBuffer("fecha");
                hora = curFactura.valueBuffer("hora");
        }

        var codEjercicio:String = curFactura.valueBuffer("codejercicio");
        var datosDoc:Array = flfacturac.iface.pub_datosDocFacturacion(fecha, codEjercicio, "facturasprov");
        if (!datosDoc.ok)
                return false;
        if (datosDoc.modificaciones == true) {
                codEjercicio = datosDoc.codEjercicio;
                fecha = datosDoc.fecha;
        }

        with (this.iface.curFactura) {
                setValueBuffer("codserie", curFactura.valueBuffer("codserie"));
                setValueBuffer("codejercicio", codEjercicio);
                setValueBuffer("irpf", curFactura.valueBuffer("irpf"));
                setValueBuffer("fecha", fecha);
                setValueBuffer("hora", hora);
                setValueBuffer("codalmacen", curFactura.valueBuffer("codalmacen"));
                setValueBuffer("codpago", curFactura.valueBuffer("codpago"));
                setValueBuffer("coddivisa", curFactura.valueBuffer("coddivisa"));
                setValueBuffer("tasaconv", curFactura.valueBuffer("tasaconv"));
                setValueBuffer("codproveedor", curFactura.valueBuffer("codproveedor"));
                setValueBuffer("cifnif", curFactura.valueBuffer("cifnif"));
                setValueBuffer("nombre", curFactura.valueBuffer("nombre"));
                setValueBuffer("numproveedor", curFactura.valueBuffer("numproveedor"));
                setValueBuffer("recfinanciero", curFactura.valueBuffer("recfinanciero"));
                setValueBuffer("automatica", false);
                setValueBuffer("observaciones", curFactura.valueBuffer("observaciones"));
                setValueBuffer("nogenerarasiento", curFactura.valueBuffer("nogenerarasiento"));
                setNull("idasiento");
                setValueBuffer("deabono", curFactura.valueBuffer("deabono"));
                setValueBuffer("idfacturarect", curFactura.valueBuffer("idfacturarect"));
                setValueBuffer("codigorect", curFactura.valueBuffer("codigorect"));
                if (curFactura.valueBuffer("idpagodevol") != 0)
                        setValueBuffer("idpagodevol", curFactura.valueBuffer("idpagodevol"));
        }
        return true;
}

function oficial_copiaLineasFactura(idFacturaOrigen:Number, idFacturaDestino:Number):Boolean
{
        var curLineaFactura:FLSqlCursor = new FLSqlCursor("lineasfacturasprov");
        curLineaFactura.select("idfactura = " + idFacturaOrigen);

        while (curLineaFactura.next()) {
                curLineaFactura.setModeAccess(curLineaFactura.Browse);
                if (!this.iface.copiaLineaFactura(curLineaFactura, idFacturaDestino))
                        return false;
        }
        return true;
}

function oficial_copiaLineaFactura(curLineaFactura:FLSqlCursor, idFactura:Number):Number
{
        if (!this.iface.curLineaFactura)
                this.iface.curLineaFactura = new FLSqlCursor("lineasfacturasprov");

        with (this.iface.curLineaFactura) {
                setModeAccess(Insert);
                refreshBuffer();
                setValueBuffer("idfactura", idFactura);
        }

        if (!this.iface.copiadatosLineaFactura(curLineaFactura))
                return false;

        if (!this.iface.curLineaFactura.commitBuffer())
                        return false;

        return this.iface.curLineaFactura.valueBuffer("idlinea");
}

function oficial_copiadatosLineaFactura(curLineaFactura:FLSqlCursor):Boolean
{
        with (this.iface.curLineaFactura) {
                setValueBuffer("referencia", curLineaFactura.valueBuffer("referencia"));
                setValueBuffer("descripcion", curLineaFactura.valueBuffer("descripcion"));
                setValueBuffer("pvpunitario", curLineaFactura.valueBuffer("pvpunitario"));
                setValueBuffer("pvpsindto", curLineaFactura.valueBuffer("pvpsindto"));
                setValueBuffer("cantidad", curLineaFactura.valueBuffer("cantidad"));
                setValueBuffer("pvptotal", curLineaFactura.valueBuffer("pvptotal"));
                setValueBuffer("codimpuesto", curLineaFactura.valueBuffer("codimpuesto"));
                setValueBuffer("iva", curLineaFactura.valueBuffer("iva"));
                setValueBuffer("recargo", curLineaFactura.valueBuffer("recargo"));
                setValueBuffer("dtolineal", curLineaFactura.valueBuffer("dtolineal"));
                setValueBuffer("dtopor", curLineaFactura.valueBuffer("dtopor"));
        }
        return true;
}


function oficial_totalesFactura():Boolean
{
        with (this.iface.curFactura) {
                setValueBuffer("neto", formfacturasprov.iface.pub_commonCalculateField("neto", this));
                setValueBuffer("totaliva", formfacturasprov.iface.pub_commonCalculateField("totaliva", this));
                setValueBuffer("totalrecargo", formfacturasprov.iface.pub_commonCalculateField("totalrecargo", this));
                setValueBuffer("totalirpf", formfacturasprov.iface.pub_commonCalculateField("totalirpf", this));
                setValueBuffer("total", formfacturasprov.iface.pub_commonCalculateField("total", this));
                setValueBuffer("totaleuros", formfacturasprov.iface.pub_commonCalculateField("totaleuros", this));
        }
        return true;
}

function oficial_filtrarTabla():Boolean
{
        var filtro:String = this.iface.filtroTabla();
        this.cursor().setMainFilter(filtro);
        return true;
}

function oficial_filtroTabla():String
{
        var filtro:String = "";
        var codEjercicio:String = flfactppal.iface.pub_ejercicioActual();
        if (codEjercicio) {
                filtro = "codejercicio='" + codEjercicio + "'";
        }
        return filtro;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
//////////////////////////////////////////////////////////


