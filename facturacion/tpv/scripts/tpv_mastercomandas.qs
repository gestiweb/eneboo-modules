/***************************************************************************
                 tpv_mastercomandas.qs  -  description
                             -------------------
    begin                : mar nov 15 2005
    copyright            : Por ahora (C) 2005 by InfoSiAL S.L.
    email                : lveb@telefonica.net
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
        var tbnBlocDesbloc:Object;
        var tdbRecords:FLTableDB;
        var ckbSoloHoy:Object;
        var ckbSoloPV:Object;
        function oficial( context ) { interna( context ); }
        function abrirComanda_clicked() {
                return this.ctx.oficial_abrirComanda_clicked();
        }
        function abrirComanda(idComanda:String):Boolean {
                return this.ctx.oficial_abrirComanda(idComanda);
        }
        function eliminarFactura(idFactura:Number):Boolean {
                return this.ctx.oficial_eliminarFactura(idFactura);
        }
        function imprimir_clicked(){
                return this.ctx.oficial_imprimir_clicked();
        }
        function imprimirTiqueComanda(codComanda:String):Boolean{
                return this.ctx.oficial_imprimirTiqueComanda(codComanda);
        }
        function imprimirFactura_clicked():Boolean{
                return this.ctx.oficial_imprimirFactura_clicked();
        }
        function abrirCajon_clicked() {
                return this.ctx.oficial_abrirCajon_clicked();
        }
        function imprimirQuick_clicked(){
                return this.ctx.oficial_imprimirQuick_clicked();
        }
        function abrirCajon( impresora:String, escAbrir:String ) {
                return this.ctx.oficial_abrirCajon( impresora, escAbrir);
        }
        function imprimirQuick( codComanda:String, impresora:String ) {
                return this.ctx.oficial_imprimirQuick( codComanda, impresora );
        }
        function filtrarVentas() {
                return this.ctx.oficial_filtrarVentas();
        }
        function filtroVentas():String {
                return this.ctx.oficial_filtroVentas();
        }
        function imprimirTiquePOS(codComanda:String, impresora:String, qry:FLSqlQuery) {
                return this.ctx.oficial_imprimirTiquePOS(codComanda, impresora, qry);
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
        function pub_imprimirTiqueComanda(codComanda:Stirng):Boolean{
                return this.imprimirTiqueComanda(codComanda);
        }
        function pub_abrirCajon( impresora:String, escAbrir:String ) {
                return this.abrirCajon( impresora, escAbrir );
        }
        function pub_imprimirQuick( codComanda:String, impresora:String ) {
                return this.imprimirQuick( codComanda, impresora );
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
function interna_init()
{
        this.iface.tbnBlocDesbloc = this.child("tbnBlocDesbloc");
        this.iface.tdbRecords = this.child("tableDBRecords");
        this.iface.ckbSoloHoy = this.child("ckbSoloHoy");
        this.iface.ckbSoloPV = this.child("ckbSoloPV");

        connect(this.iface.tbnBlocDesbloc, "clicked()", this, "iface.abrirComanda_clicked()");
        connect(this.child("toolButtonPrint"),"clicked()", this, "iface.imprimir_clicked()");
        connect( this.child( "tbnPrintQuick" ), "clicked()", this, "iface.imprimirQuick_clicked()" );
        connect( this.child( "tbnOpenCash" ), "clicked()",  this, "iface.abrirCajon_clicked()" );
        connect( this.child( "tbnImprimirFactura" ), "clicked()",  this, "iface.imprimirFactura_clicked()" );
        connect( this.child( "ckbSoloHoy" ), "clicked()",  this, "iface.filtrarVentas()" );
        connect( this.child( "ckbSoloPV" ), "clicked()",  this, "iface.filtrarVentas()" );

        this.iface.filtrarVentas();
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D
Abre una comanda
No se podrá abir una comanda si su arqueo está cerrado
@return Boolean, devuelve true si todo se ha ejecutado correctamente y false si hay algún error
*/
function oficial_abrirComanda_clicked():Boolean
{
        var util:FLUtil = new FLUtil();
        var cursor:FLSqlCursor = this.cursor();
        var idFactura:Number = cursor.valueBuffer("idfactura");
        var idComanda:Number = cursor.valueBuffer("idtpv_comanda");
        if (!idComanda)
                return false;

        if (cursor.valueBuffer("editable") == true) {
                MessageBox.warning(util.translate("scripts", "La venta ya está abierta"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
                return true;
        }

        /*
        if (!util.sqlSelect("tpv_arqueos", "abierta", "idtpv_arqueo = '" + cursor.valueBuffer("idtpv_arqueo") + "'")) {
                MessageBox.warning(util.translate("scripts", "No pueden abrirse ventas asociadas a un arqueo cerrado"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
                return true;
        }
        */

        var res:Number = MessageBox.warning(util.translate("scripts", "Va a abrir la venta seleccionada"), MessageBox.Ok, MessageBox.Cancel);
        if (res != MessageBox.Ok)
                return true;

        cursor.transaction(false);
        try {
                if (this.iface.abrirComanda(idComanda))
                        cursor.commit();
                else {
                        cursor.rollback();
                        return false;
                }
        }
        catch (e) {
                cursor.rollback();
                MessageBox.critical(util.translate("scripts", "Hubo un error en la apertura de la venta:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
        }

        this.iface.tdbRecords.refresh();

        return true;
}

/** \D Abre la comanda
@param        idComanda: identificador de la comanda
@return        true si la comanda se abre correctamente, false en caso contrario
\end */
function oficial_abrirComanda(idComanda:String):Boolean
{
        var util:FLUtil = new FLUtil();
        var curComanda:FLSqlCursor = new FLSqlCursor("tpv_comandas");
        curComanda.select("idtpv_comanda = " + idComanda);
        if (!curComanda.first())
                return false;
        curComanda.setUnLock("editable", true)

        curComanda.select("idtpv_comanda = " + idComanda);
        if (!curComanda.first())
                return false;

        curComanda.setModeAccess(curComanda.Edit);
        curComanda.refreshBuffer();
        curComanda.setValueBuffer("estado","Abierta");
        if (!curComanda.commitBuffer())
                return false;

        return true;
}
/** \D
Elimina los el pago, recibo y factura que corresponden a la comanda
@param idFactura identificador de la factura a borrar
@return Boolean, devuelve true si todo se ha ejecutado correctamente y fasle si hay algún error
*/
function oficial_eliminarFactura(idFactura:Number):Boolean
{
        var util:FLUtil = new FLUtil();
        var curFactura:FLSqlCursor = new FLSqlCursor("facturascli");
        curFactura.select("idfactura = " + idFactura);
        if(!curFactura.first())
                return false;
        var codRecibo = curFactura.valueBuffer("codigo") + "-01";
        if(util.sqlSelect("reciboscli","estado","codigo = '" + codRecibo + "'") == "Pagado"){
                var idrecibo:Number = util.sqlSelect("reciboscli","idrecibo","codigo = '" + codRecibo + "'");
                var curPagos:FLSqlCursor = new FLSqlCursor("pagosdevolcli");
                curPagos.select("idrecibo = " + idrecibo);
                if(!curPagos.first())
                        return false;
                curPagos.setModeAccess(curPagos.Del);
                curPagos.refreshBuffer();
                if(!curPagos.commitBuffer())
                        return false;
                var curRecibos:FLSqlCursor = new FLSqlCursor("reciboscli");
                curRecibos.select("idrecibo = " + idrecibo);
                if(!curRecibos.first())
                        return false;
                curRecibos.setModeAccess(curRecibos.Edit);
                curRecibos.refreshBuffer();
                curRecibos.setValueBuffer("estado","Emitido");
                if(!curRecibos.commitBuffer())
                        return false;
                curFactura.setUnLock("editable",true);
        }
        curFactura.setModeAccess(curFactura.Del);
        curFactura.refreshBuffer();
        if(!curFactura.commitBuffer())
                return false;
        return true;
}

/** \D
Abre una transacción y llama a la función ImprimirTiqueComanda
*/
function oficial_imprimir_clicked()
{
        var cursor:FLSqlCursor = this.cursor();
        var codComanda:String = cursor.valueBuffer("codigo");
        if (!codComanda)
                return false;

        if (!this.iface.imprimirTiqueComanda(codComanda)){
                return false;
        }

        this.iface.tdbRecords.cursor().refresh();
}

/** \D
Si el módulo de informes no está cargado muestra un mensaje de aviso y si lo está lanza el informe correspondiente
@param codComanda codigo de la comanda a imprimir
@return true si se imprime correctamente y false si ha algún error
*/
function oficial_imprimirTiqueComanda(codComanda:String):Boolean
{
        if (sys.isLoadedModule("flfactinfo")) {
                if (!this.cursor().isValid())
                        return;
                var curImprimir:FLSqlCursor = new FLSqlCursor("tpv_i_comandas");
                curImprimir.setModeAccess(curImprimir.Insert);
                curImprimir.refreshBuffer();
                curImprimir.setValueBuffer("descripcion", "temp");
                curImprimir.setValueBuffer("d_tpv__comandas_codigo", codComanda);
                curImprimir.setValueBuffer("h_tpv__comandas_codigo", codComanda);
                flfactinfo.iface.pub_lanzarInforme(curImprimir, "tpv_i_comandas");
        } else
                flfactppal.iface.pub_msgNoDisponible("Informes");

}

/** \D
Manda a imprimir directamente a la impresora la comanda actualmente seleccionada
*/
function oficial_imprimirQuick_clicked()
{
/*
        if (!this.cursor().isValid())
                return;

        var util:FLUtil = new FLUtil();
        var pv:String = util.readSettingEntry( "scripts/fltpv_ppal/codTerminal" );

        if ( !pv )
                        pv = util.sqlSelect( "tpv_puntosventa", "codtpv_puntoventa", "1=1") ;

        var codComanda:String = this.cursor().valueBuffer("idtpv_comanda");

        var qryTicket:FLSqlQuery = new FLSqlQuery("tpv_i_comandas");
        qryTicket.setWhere("tpv_comandas.idtpv_comanda = '" + codComanda + "'");
        if (!qryTicket.exec())
                return false;

        var impresora:String = util.sqlSelect( "tpv_puntosventa", "impresora","codtpv_puntoventa = '" + pv + "'") ;
        flfact_tpv.iface.establecerImpresora(impresora);

        var primerRegistro:Boolean = true;
        while (qryTicket.next()) {
                if (primerRegistro) {
                        flfact_tpv.iface.imprimirDatos(qryTicket.value("empresa.nombre"));
                        flfact_tpv.iface.impNuevaLinea();
                        flfact_tpv.iface.imprimirDatos(qryTicket.value("empresa.direccion"));
                        flfact_tpv.iface.impNuevaLinea();
                        flfact_tpv.iface.imprimirDatos(qryTicket.value("empresa.ciudad"));
                        flfact_tpv.iface.impNuevaLinea();
                        flfact_tpv.iface.imprimirDatos("C.I.F. ");
                        flfact_tpv.iface.imprimirDatos(qryTicket.value("empresa.cifnif"));
                        flfact_tpv.iface.impNuevaLinea();
                        flfact_tpv.iface.impResaltar(true);
                        flfact_tpv.iface.imprimirDatos("Tiquet: " + qryTicket.value("tpv_comandas.codigo"));
                        flfact_tpv.iface.impResaltar(false);
                        flfact_tpv.iface.impAlinearH(2);
                        flfact_tpv.iface.imprimirDatos(util.dateAMDtoDMA(qryTicket.value("tpv_comandas.fecha")));
                        flfact_tpv.iface.impAlinearH(0);
                        flfact_tpv.iface.impNuevaLinea();
                        flfact_tpv.iface.impSubrayar(true);
                        //flfact_tpv.iface.imprimirDatos("ESC:1B,52,07");
                        flfact_tpv.iface.imprimirDatos("ESC:1B,74,19");
                        flfact_tpv.iface.imprimirDatos("Camión", 20);
                        flfact_tpv.iface.imprimirDatos("Ínigo, Pléyade, Cáscara");
                        flfact_tpv.iface.impAlinearH(2);
                        flfact_tpv.iface.imprimirDatos("PVP");
                        flfact_tpv.iface.impSubrayar(false);
                        flfact_tpv.iface.impNuevaLinea(5);
                        flfact_tpv.iface.imprimirDatos("PVP");
                        flfact_tpv.iface.impNuevaLinea();
                }
                primerRegistro = false;
        }
        flfact_tpv.iface.i();
        flfact_tpv.iface.flushImpresora();
        */


        if (!this.cursor().isValid())
                return;

        var util:FLUtil = new FLUtil();
        var pv:String = util.readSettingEntry( "scripts/fltpv_ppal/codTerminal" );

        if ( !pv )
                        pv = util.sqlSelect( "tpv_puntosventa", "codtpv_puntoventa", "1=1") ;

        var impresora:String = util.sqlSelect( "tpv_puntosventa", "impresora","codtpv_puntoventa = '" + pv + "'") ;

        this.iface.imprimirQuick( this.cursor().valueBuffer( "codigo" ) , impresora );

}

function oficial_imprimirQuick( codComanda:String, impresora:String )
{
        var util:FLUtil = new FLUtil();
        var q:FLSqlQuery = new FLSqlQuery( "tpv_i_comandas" );
        var codPuntoVenta:String = util.readSettingEntry("scripts/fltpv_ppal/codTerminal");

        q.setWhere( "codigo = '" + codComanda + "'" );
        if (q.exec() == false) {
                MessageBox.critical(util.translate("scripts", "Falló la consulta"), MessageBox.Ok, MessageBox.NoButton);
                return;
        } else {
                if (q.first() == false) {
                        MessageBox.warning(util.translate("scripts", "No hay registros que cumplan los criterios de búsqueda establecidos"), MessageBox.Ok, MessageBox.NoButton);
                        return;
                }
        }

        var tipoImpresora:String = util.sqlSelect("tpv_puntosventa", "tipoimpresora", "codtpv_puntoventa = '" + codPuntoVenta + "'");
        if (tipoImpresora == "ESC-POS") {
                this.iface.imprimirTiquePOS(codComanda, impresora, q);
        } else {
                var pixel:Number = util.sqlSelect("tpv_puntosventa", "pixel", "codtpv_puntoventa = '" + codPuntoVenta + "'");
                if (!pixel || isNaN(pixel)) {
                        pixel = 780;
                }
                var resolucion:Number = util.sqlSelect("tpv_puntosventa", "resolucion", "codtpv_puntoventa = '" + codPuntoVenta + "'");
                if (!resolucion || isNaN(resolucion)) {
                        resolucion = 300;
                }
                var rptViewer:FLReportViewer = new FLReportViewer();
                rptViewer.setPixel(pixel);
                rptViewer.setResolution(resolucion);
                rptViewer.setReportTemplate( "tpv_i_comandas" );
                rptViewer.setReportData( q );
                rptViewer.renderReport();
                rptViewer.setPrinterName( impresora );
                rptViewer.printReport();
        }
}

function oficial_imprimirTiquePOS(codComanda:String, impresora:String, qryTicket:FLSqlQuery)
{
        var util:FLUtil = new FLUtil;
        flfact_tpv.iface.establecerImpresora(impresora);

        var primerRegistro:Boolean = true;
        var total:String;
        var neto:String;
        var totalIva:String;
        var agente:String;
        var totalLinea:Number;
        var pvpUnitarioIva:Number;
        var descripcion:String;
        var codColor:String;
        var formaPago:String;

        if (!qryTicket.exec()) {
                return false;
        }
        while (qryTicket.next()) {
                if (primerRegistro) {
                        flfact_tpv.iface.impResaltar(true);
                        flfact_tpv.iface.impSubrayar(true);
                        flfact_tpv.iface.imprimirDatos(qryTicket.value("empresa.nombre"));
                        flfact_tpv.iface.impResaltar(false);
                        flfact_tpv.iface.impSubrayar(false);
                        flfact_tpv.iface.impNuevaLinea();
                        flfact_tpv.iface.imprimirDatos(qryTicket.value("empresa.direccion"));
                        flfact_tpv.iface.impNuevaLinea();
                        flfact_tpv.iface.imprimirDatos(qryTicket.value("empresa.ciudad"));
                        flfact_tpv.iface.impNuevaLinea();
                        flfact_tpv.iface.imprimirDatos("Telef.  ");
                        flfact_tpv.iface.imprimirDatos(qryTicket.value("empresa.telefono"));
                        flfact_tpv.iface.impNuevaLinea();
                        flfact_tpv.iface.imprimirDatos("N.I.F.  ");
                        flfact_tpv.iface.imprimirDatos(qryTicket.value("empresa.cifnif"));
                        flfact_tpv.iface.impNuevaLinea(2);
                        flfact_tpv.iface.imprimirDatos("Nº Tiquet: " + qryTicket.value("tpv_comandas.codigo"));
                        flfact_tpv.iface.impNuevaLinea();
                        flfact_tpv.iface.imprimirDatos("Fecha: " + util.dateAMDtoDMA(qryTicket.value("tpv_comandas.fecha")));

                        var hora:String = qryTicket.value("tpv_comandas.hora").toString();
                        hora = hora.right(8);
                        hora = hora.left(5);
                        flfact_tpv.iface.imprimirDatos("   Hora: " + hora);
                        flfact_tpv.iface.impNuevaLinea(2);
                        flfact_tpv.iface.imprimirDatos("ARTICULO", 20);
                        flfact_tpv.iface.imprimirDatos("CANTIDAD", 10, 2);
                        flfact_tpv.iface.imprimirDatos("IMPORTE", 10, 2);
                        flfact_tpv.iface.impNuevaLinea();

                        totaliva = util.roundFieldValue(qryTicket.value("tpv_comandas.totaliva"), "tpv_comandas", "totaliva");
                        neto = util.roundFieldValue(qryTicket.value("tpv_comandas.neto"), "tpv_comandas", "neto");
                        total = util.roundFieldValue(qryTicket.value("tpv_comandas.total"), "tpv_comandas", "total");
                        agente = qryTicket.value("tpv_agentes.descripcion");
                }

                primerRegistro = false;

                cantidad = qryTicket.value("tpv_lineascomanda.cantidad");
                totalLinea = qryTicket.value("tpv_lineascomanda.pvptotal");
    totalLinea = util.roundFieldValue(totalLinea, "tpv_comandas", "total");

                descripcion = qryTicket.value("tpv_lineascomanda.descripcion");

                flfact_tpv.iface.imprimirDatos(descripcion, 20);
                flfact_tpv.iface.imprimirDatos(cantidad, 10, 2);
                flfact_tpv.iface.imprimirDatos(totalLinea, 10, 2);
                flfact_tpv.iface.impNuevaLinea();
        }

        flfact_tpv.iface.impNuevaLinea();
        flfact_tpv.iface.imprimirDatos("Total Neto.", 30);
        flfact_tpv.iface.imprimirDatos(neto, 10,2);
        flfact_tpv.iface.impNuevaLinea();
        flfact_tpv.iface.imprimirDatos("Total I.V.A.", 30);
        flfact_tpv.iface.imprimirDatos(totaliva, 10,2);
        flfact_tpv.iface.impNuevaLinea();
        flfact_tpv.iface.imprimirDatos("Total Ticket.", 30);
        flfact_tpv.iface.imprimirDatos(total, 10,2);

        flfact_tpv.iface.impAlinearH(1);

        flfact_tpv.iface.impNuevaLinea();
        flfact_tpv.iface.imprimirDatos("GRACIAS POR SU VISITA");
        flfact_tpv.iface.impAlinearH(0);
        flfact_tpv.iface.impNuevaLinea(2);
        flfact_tpv.iface.impSubrayar(true);
        flfact_tpv.iface.imprimirDatos("Le atendió:");
        flfact_tpv.iface.impSubrayar(false);
        flfact_tpv.iface.imprimirDatos("   " + agente);
        flfact_tpv.iface.impNuevaLinea();

        flfact_tpv.iface.impNuevaLinea(9);
        flfact_tpv.iface.impCortar();
        flfact_tpv.iface.flushImpresora();

/// Eliminado porque parece que corta dos veces el papel en ciertas instalaciones
//         var printer:FLPosPrinter = new FLPosPrinter();
//         printer.setPrinterName( impresora );
//         printer.send( "ESC:1B,64,05,1B,69" );
//         printer.flush();
}

/** \D
Abre el cajón del punto de venta actual
*/
function oficial_abrirCajon_clicked()
{
        var util:FLUtil = new FLUtil();
        var pv:String = util.readSettingEntry( "scripts/fltpv_ppal/codTerminal" );

        if ( !pv )
                        pv = util.sqlSelect( "tpv_puntosventa", "codtpv_puntoventa", "1=1") ;

        var impresora:String = util.sqlSelect( "tpv_puntosventa", "impresora", "codtpv_puntoventa = '" + pv + "'") ;
        var escAbrir:String = util.sqlSelect( "tpv_puntosventa", "abrircajon", "codtpv_puntoventa = '" + pv + "'") ;

        this.iface.abrirCajon( impresora, escAbrir);
}

/** \D
Abre el cajón portamonedas conectado a una impresora
@impresora Nombre de la impresora LPR donde está conectado el cajón
*/
function oficial_abrirCajon( impresora:String, escAbrir:String )
{
        var printer:FLPosPrinter = new FLPosPrinter();
        printer.setPrinterName( impresora );

        if (!escAbrir) {
                escAbrir = "27,7,20,20,7";
        }
debug("Enviando " + "ESC:" + escAbrir);
        printer.send( "ESC:" + escAbrir);
        printer.flush();
}

/** \D
Imprime la factura correspondiente a la venta seleccionada
*/
function oficial_imprimirFactura_clicked()
{
        var util:FLUtil = new FLUtil;
        var cursor:FLSqlCursor = this.cursor();

        var codComanda:String = cursor.valueBuffer("codigo");
        if (!codComanda) {
                return;
        }

        var idFactura:String = cursor.valueBuffer("idfactura");
        if (!idFactura) {
                var res:Number = MessageBox.warning(util.translate("scripts", "La venta seleccionada todavía no tiene una factura asociada. ¿Desea crearla ahora?"), MessageBox.Yes, MessageBox.No);
                if (res != MessageBox.Yes) {
                        return;
                }

                var curComanda:FLSqlCursor = new FLSqlCursor("tpv_comandas");
                curComanda.transaction(false);
                try {
                        idFactura = flfact_tpv.iface.pub_crearFactura(cursor);
                        if (!idFactura) {
                                throw util.translate("scripts", "La función crearFactura ha fallado");
                        }

                        /// Evita que se llame a sincronizarConFacturación otra vez
                        curComanda.setActivatedCommitActions(false);

                        curComanda.select("codigo = '" + codComanda + "'");
                        if (!curComanda.first()) {
                                throw util.translate("scripts", "Error al buscar la venta seleccionada");
                        }
                        curComanda.setModeAccess(curComanda.Edit);
                        curComanda.refreshBuffer();
                        curComanda.setValueBuffer("idfactura", idFactura);
                        if (!curComanda.commitBuffer()) {
                                throw util.translate("scripts", "Error al actualizar la venta con el Id de la factura generada");
                        }
                        curComanda.commit();
                }
                catch (e) {
                        curComanda.rollback();
                        MessageBox.critical(util.translate("scripts", "Hubo un error al generar la factura:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
                }
        }

        var codFactura:String = util.sqlSelect("facturascli", "codigo", "idfactura = " + idFactura);
        if (codFactura) {
                formfacturascli.iface.pub_imprimir(codFactura);
        }
}

/** \D Activa o desactiva el filtro que muestra únicamente las últimas ventas o las del puesto por defecto. El filtro mejora el rendimiento
\end */
function oficial_filtrarVentas()
{
        var cursor:FLSqlCursor = this.cursor();
        var filtro:String = this.iface.filtroVentas();
        if (!filtro && filtro != "")
                return;

        cursor.setMainFilter(filtro);
        this.iface.tdbRecords.refresh();
}

function oficial_filtroVentas():String
{
        var filtro:String = "";
        var util:FLUtil = new FLUtil;
        if (this.iface.ckbSoloHoy.checked) {
                var hoy:Date = new Date;
                filtro = "fecha = '" + hoy.toString().left(10) + "'";
        }

        if (this.iface.ckbSoloPV.checked) {
                var codTerminal:String = util.readSettingEntry("scripts/fltpv_ppal/codTerminal");
                if (codTerminal) {
                        if (filtro != "")
                                filtro += " AND ";
                        filtro += "codtpv_puntoventa = '" + codTerminal + "'";
                }
        }

        return filtro;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////

