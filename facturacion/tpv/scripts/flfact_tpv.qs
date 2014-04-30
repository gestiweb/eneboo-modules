/***************************************************************************
                 flfact_tpv.qs  -  description
                             -------------------
    begin                : lun ago 19 2005
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
        function beforeCommit_tpv_comandas(curComanda:FLSqlCursor):Boolean {
                return this.ctx.interna_beforeCommit_tpv_comandas(curComanda);
        }
        function afterCommit_tpv_comandas(curComanda:FLSqlCursor):Boolean  {
                return this.ctx.interna_afterCommit_tpv_comandas(curComanda);
        }
        function beforeCommit_tpv_pagoscomanda(curPago:FLSqlCursor):Boolean {
                return this.ctx.interna_beforeCommit_tpv_pagoscomanda(curPago);
        }
        function afterCommit_tpv_lineasvale(curLinea:FLSqlCursor):Boolean  {
                return this.ctx.interna_afterCommit_tpv_lineasvale(curLinea);
        }
        function afterCommit_tpv_pagoscomanda(curPago:FLSqlCursor):Boolean  {
                return this.ctx.interna_afterCommit_tpv_pagoscomanda(curPago);
        }
        function afterCommit_tpv_lineascomanda(curLinea:FLSqlCursor):Boolean {
                return this.ctx.interna_afterCommit_tpv_lineascomanda(curLinea);
        }
        function beforeCommit_tpv_arqueos(curArqueo:FLSqlCursor):Boolean {
                return this.ctx.interna_beforeCommit_tpv_arqueos(curArqueo);
        }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
        var printer:FLPosPrinter;
        var printerXPos:Number;
        var printerYPos:Number;
        var printerESC:String;
        var textoPrinter:String = "";

        var curFactura:FLSqlCursor;
        var curLineaFactura:FLSqlCursor;

        function oficial( context ) { interna( context ); }
        function ejecutarQry(tabla, campos, where, listaTablas):Array {
                return this.ctx.oficial_ejecutarQry(tabla, campos, where, listaTablas);
        }
        function copiarLinea(idFactura:Number,curLineaComanda:FLSqlCursor):Boolean {
                return this.ctx.oficial_copiarLinea(idFactura,curLineaComanda);
        }
        function copiarLineas(idComanda:Number, idFactura:Number):Boolean {
                return this.ctx.oficial_copiarLineas(idComanda, idFactura);
        }
        function crearFactura(curComanda:FLSqlCursor):Number {
                return this.ctx.oficial_crearFactura(curComanda);
        }
        function borrarFactura(idFactura:String):Boolean {
                return this.ctx.oficial_borrarFactura(idFactura);
        }
        function valoresIniciales() {
                return this.ctx.oficial_valoresIniciales();
        }
        function datosLineaFactura(curLineaComanda:FLSqlCursor):Boolean {
                return this.ctx.oficial_datosLineaFactura(curLineaComanda);
        }
        function generarRecibos(curComanda:FLSqlCursor):Boolean {
                return this.ctx.oficial_generarRecibos(curComanda);
        }
        function generarRecibo(qryFactura:FLSqlQuery, datosRecibo:Array):Number {
                return this.ctx.oficial_generarRecibo(qryFactura, datosRecibo);
        }
        function pagarRecibo(idRecibo:String, datosRecibo:Array):Boolean {
                return this.ctx.oficial_pagarRecibo(idRecibo, datosRecibo);
        }
        function totalesFactura():Boolean {
                return this.ctx.oficial_totalesFactura();
        }
        function datosFactura(curComanda:FLSqlCursor):Boolean {
                return this.ctx.oficial_datosFactura(curComanda);
        }
        function imprimirDatos(datos:String, maxLon:Number, alineacion:Number) {
                return this.ctx.oficial_imprimirDatos(datos, maxLon, alineacion);
        }
        function establecerImpresora(impresora:String) {
                return this.ctx.oficial_establecerImpresora(impresora);
        }
        function flushImpresora() {
                return this.ctx.oficial_flushImpresora();
        }
        function impNuevaLinea(numLineas:Number) {
                return this.ctx.oficial_impNuevaLinea(numLineas);
        }
        function impAlinearH(alineacion:Number) {
                return this.ctx.oficial_impAlinearH(alineacion);
        }
        function impResaltar(resaltar:Boolean) {
                return this.ctx.oficial_impResaltar(resaltar);
        }
        function impSubrayar(subrayar:Boolean) {
                return this.ctx.oficial_impSubrayar(subrayar);
        }
        function impCortar() {
                return this.ctx.oficial_impCortar();
        }
        function espaciosIzquierda(texto:String, totalLongitud:Number):String {
                return this.ctx.oficial_espaciosIzquierda(texto, totalLongitud);
        }
        function subcuentaDefecto(nombre:String, codEjercicio:String):Array {
                return this.ctx.oficial_subcuentaDefecto(nombre, codEjercicio);
        }
        function subcuentaCausa(codCausa:String, codEjercicio:String):Array {
                return this.ctx.oficial_subcuentaCausa(codCausa, codEjercicio);
        }
        function generarAsientoArqueo(curArqueo:FLSqlCursor):Boolean {
                return this.ctx.oficial_generarAsientoArqueo(curArqueo);
        }
        function comprobarRegularizacion(curArqueo:FLSqlCursor):Boolean {
                return this.ctx.oficial_comprobarRegularizacion(curArqueo);
        }
        function regenerarAsiento(curArqueo:FLSqlCursor, valoresDefecto:Array):Array {
                return this.ctx.oficial_regenerarAsiento(curArqueo, valoresDefecto);
        }
/*
        function generarPartidasCliente(curArqueo:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean {
                return this.ctx.oficial_generarPartidasCliente(curArqueo, idAsiento, valoresDefecto);
        }
        function generarPartidasVentasIva(curArqueo:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean {
                return this.ctx.oficial_generarPartidasVentasIva(curArqueo, idAsiento, valoresDefecto);
        }
        function generarPartidasPago(curArqueo:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean {
                return this.ctx.oficial_generarPartidasPago(curArqueo, idAsiento, valoresDefecto);
        }
*/
        function generarPartidasMovi(curArqueo:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean {
                return this.ctx.oficial_generarPartidasMovi(curArqueo, idAsiento, valoresDefecto);
        }
        function generarPartidasMoviCierre(curArqueo:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean {
                return this.ctx.oficial_generarPartidasMoviCierre(curArqueo, idAsiento, valoresDefecto);
        }
        function generarPartidasDif(curArqueo:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean {
                return this.ctx.oficial_generarPartidasDif(curArqueo, idAsiento, valoresDefecto);
        }
        function conceptoPartida(curArqueo:FLSqlCursor, masConcepto:String):String {
                return this.ctx.oficial_conceptoPartida(curArqueo, masConcepto);
        }
        function subcuentaDefecto(nombre:String, codEjercicio:String):Array {
                return this.ctx.oficial_subcuentaDefecto(nombre, codEjercicio);
        }
        function borrarAsientoArqueo(curArqueo:FLSqlCursor, idAsiento:String):Boolean {
                return this.ctx.oficial_borrarAsientoArqueo(curArqueo, idAsiento);
        }
        function sincronizarConFacturacion(curComanda:FLSqlCursor):Boolean {
                return this.ctx.oficial_sincronizarConFacturacion(curComanda);
        }
        function obtenerCodigoComanda(curComanda:FLSqlCursor):String {
                return this.ctx.oficial_obtenerCodigoComanda(curComanda);
        }
        function comprobarSincronizacion(curComanda:FLSqlCursor):Boolean {
                return this.ctx.oficial_comprobarSincronizacion(curComanda);
        }
        function generarPartidasArqueo(curArqueo:FLSqlCursor, datosAsiento:Array, valoresDefecto:Array):Boolean {
                return this.ctx.oficial_generarPartidasArqueo(curArqueo, datosAsiento, valoresDefecto);
        }
        function valorDefectoTPV(campo:String):String {
                return this.ctx.oficial_valorDefectoTPV(campo);
        }
        function obtenerSerieFactura(curComanda:String):String {
                return this.ctx.oficial_obtenerSerieFactura(curComanda);
        }
        function borrarRecibosFactura(idFactura:String):Boolean {
                return this.ctx.oficial_borrarRecibosFactura(idFactura);
        }
        function borrarLineasFactura(idFactura:String):Boolean {
                return this.ctx.oficial_borrarLineasFactura(idFactura);
        }
        function modificarFactura(curComanda:FLSqlCursor, idFactura:String):Number {
                return this.ctx.oficial_modificarFactura(curComanda, idFactura);
        }
        function comprobarAlmacenesComandas() {
                return this.ctx.oficial_comprobarAlmacenesComandas();
        }
}

//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends oficial {
    function head( context ) { oficial ( context ); }
        function pub_crearFactura(curComanda:FLSqlCursor):Number {
                return this.crearFactura(curComanda);
        }
        function pub_generarRecibos(curComanda:FLSqlCursor):Boolean {
                return this.generarRecibos(curComanda);
        }
}

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration ifaceCtx */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends head {
        function ifaceCtx( context ) { head( context ); }
        function pub_ejecutarQry(tabla, campos, where, listaTablas):Array {
                return this.ejecutarQry(tabla, campos, where, listaTablas);
        }
        function pub_borrarAsientoArqueo(curArqueo:FLSqlCursor, idAsiento:String):Boolean {
                return this.borrarAsientoArqueo(curArqueo, idAsiento);
        }
        function pub_valorDefectoTPV(campo:String):String {
                return this.valorDefectoTPV(campo);
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
/** \D
Si es la primera vez que se ejecuta establece los valores iniciales de Datos Generales
*/
function interna_init()
{
        var cursor:FLSqlCursor = new FLSqlCursor("tpv_datosgenerales");
        var util:FLUtil = new FLUtil();
        cursor.select();
        if (!cursor.first()) {
                MessageBox.information(util.translate("scripts","Se establecerán algunos valores iniciales para empezar a trabajar."),MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
                this.iface.valoresIniciales();
                this.execMainScript("tpv_datosgenerales");
        }
        this.iface.comprobarAlmacenesComandas();
}

/** \C Si se ha seleccionado la opción de facturación integrada, se creará una factura por venta. Si no se ha seleccionado, se generará cuando la venta sea a cuenta y el usuario lo permita
\end */
function interna_beforeCommit_tpv_comandas(curComanda:FLSqlCursor):Boolean
{
        var util:FLUtil = new FLUtil();
        var codComanda:String = curComanda.valueBuffer("codigo");
        var idTpvComanda:String = curComanda.valueBuffer("idtpv_comanda");


        switch (curComanda.modeAccess()) {
                case curComanda.Insert: {
                        if (curComanda.valueBuffer("codigo") == "0") {
                                curComanda.setValueBuffer("codigo", this.iface.obtenerCodigoComanda(curComanda));
                        }
                        if (curComanda.valueBuffer("codigo") == "" || curComanda.valueBuffer("codigo") == "0") {
                                MessageBox.warning(util.translate("scripts", "El código de la venta no puede estar vacío"), MessageBox.Ok, MessageBox.NoButton);
                                return false;
                        }

                        if (curComanda.modeAccess() == curComanda.Insert) {
                                if (util.sqlSelect("tpv_comandas", "idtpv_comanda", "codigo = '" + codComanda + "' AND idtpv_comanda != " + idTpvComanda)) {
                                        var res:Number = MessageBox.information(util.translate("scripts", "Ya existe una venta con este código.\n¿Desea continuar?"), MessageBox.Yes, MessageBox.No);
                                        if (res != MessageBox.Yes) {
                                                return false;
                                        }
                                }
                        }
                        break;
                }
        }

        if (!this.iface.comprobarSincronizacion(curComanda)) {
                return false;
        }

        return true;
}

function interna_afterCommit_tpv_comandas(curComanda:FLSqlCursor):Boolean
{
        return true;
}

function interna_beforeCommit_tpv_pagoscomanda(curPago:FLSqlCursor):Boolean
{
        var util:FLUtil = new FLUtil;
        if (!curPago.valueBuffer("idtpv_arqueo")) {
                var qryarqueos:FLSqlQuery = new FLSqlQuery();
                qryarqueos.setTablesList("tpv_arqueos");
                qryarqueos.setSelect("idtpv_arqueo");
                qryarqueos.setFrom("tpv_arqueos");
                qryarqueos.setWhere("ptoventa = '" + curPago.valueBuffer("codtpv_puntoventa") + "' AND abierta = true AND diadesde <= '" + curPago.valueBuffer("fecha") + "'");
                if (!qryarqueos.exec())
                        return;
                /** \C
                Comprueba que existe un arqueo abierto que corresponda con los datos de la comanda antes de crear una nueva.
                */
                if (!qryarqueos.first()){
                        MessageBox.warning(util.translate("scripts", "No existe ningún arqueo abierto para este punto de venta y esta fecha.\nAntes de crear una venta debe crear el aqueo."),MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
                        return false;
                }
                if (qryarqueos.size() > 1){
                /** \C
                No se puede crear una comanda si existen más de un arqueo a los que pueda pertenecer
                */
                        MessageBox.warning(util.translate("scripts", "Existe mas de un arqueo abierto para este punto de venta y esta fecha."),MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
                        return false;
                }
                curPago.setValueBuffer("idtpv_arqueo", qryarqueos.value(0));
        }

        return true;
}

function interna_afterCommit_tpv_pagoscomanda(curPago:FLSqlCursor):Boolean
{
        var util:FLUtil = new FLUtil;

        switch(curPago.modeAccess()) {
                case curPago.Insert:
                case curPago.Edit: {
                        /** \C Si se ha pagado con un vale, se actualiza su saldo
                        \end */
                        var refVale:String = curPago.valueBuffer("refvale");
                        if (refVale && refVale != "") {
                                var importeVale:String = util.sqlSelect("tpv_vales", "importe", "referencia = '" + refVale + "'");
                                var gastado:String = util.sqlSelect("tpv_pagoscomanda", "SUM(importe)", "refvale = '" + refVale + "'");
                                if (!gastado)
                                        gastado = 0;
                                var saldoVale:Number = parseFloat(importeVale) - parseFloat(gastado);
                                if (saldoVale < 0) {
                                        MessageBox.warning(util.translate("scripts", "El importe del pago es superior al saldo del vale"), MessageBox.Ok, MessageBox.NoButton);
                                        return false;
                                }
                                if (!util.sqlUpdate("tpv_vales", "saldo", saldoVale, "referencia = '" + refVale + "'"))
                                        return false;
                        }
                        break;
                }
        }
        return true;
}

/** \C  Al modificar las líneas de vale (artículos devueltos), el stock de los artículos correspondientes se modifica en consonancia
\end */
function interna_afterCommit_tpv_lineasvale(curLinea:FLSqlCursor):Boolean
{
        if (!flfactalma.iface.pub_controlStockValesTPV(curLinea))
                return false;

        return true;
}

/** \C  Al modificar las líneas de comanda (artículos vendidos), el stock de los artículos correspondientes se modifica en consonancia
\end */
function interna_afterCommit_tpv_lineascomanda(curLinea:FLSqlCursor):Boolean
{
        if (!flfactalma.iface.pub_controlStockComandasCli(curLinea))
                return false;

        return true;
}

/** \C  Al Cerrar o abrir el arqueo se genera o borra el correspondiente asiento contable
\end */
function interna_beforeCommit_tpv_arqueos(curArqueo:FLSqlCursor):Boolean
{
        if (sys.isLoadedModule("flcontppal") && flfactppal.iface.pub_valorDefectoEmpresa("contintegrada")) {
                switch (curArqueo.modeAccess()) {
                        case curArqueo.Edit: {
                                var estadoActual:Boolean = curArqueo.valueBuffer("abierta");
                                var estadoPrevio:Boolean = curArqueo.valueBufferCopy("abierta");
                                if (estadoActual != estadoPrevio) {
                                        if (!estadoActual) {
                                                if (!this.iface.generarAsientoArqueo(curArqueo)) {
                                                        return false;
                                                }
                                        }
                                }
                                break;
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
function oficial_comprobarSincronizacion(curComanda:FLSqlCursor):Boolean
{
        var util:FLUtil = new FLUtil();

        var integracionFac:String = util.sqlSelect("tpv_datosgenerales", "integracionfac", "1 = 1");
        var pendiente:Number = parseFloat(curComanda.valueBuffer("pendiente"));
        if (pendiente != 0 || integracionFac || !curComanda.isNull("idfactura")) {
                if (!this.iface.sincronizarConFacturacion(curComanda)) {
                        return false;
                }
        }
        return true;
}

/** \D Ejecuta una query especificada

@param tabla Argumento de setTablesList
@param campo Argumento de setSelect
@param tabla Argumento de setWhere
@param tabla Argumento de setFrom

@return Un array con los datos de los campos seleccionados. Un campo extra
'result' que es 1 = Ok, 0 = Error, -1 No encontrado
*/
function oficial_ejecutarQry(tabla, campos, where, listaTablas):Array
{
  var util:FLUtil = new FLUtil;
  var campo:Array = campos.split(",");
  var valor = [];
  valor["result"] = 1;
  var query:FLSqlQuery = new FLSqlQuery();
  if (listaTablas)
    query.setTablesList(listaTablas);
  else
    query.setTablesList(tabla);
  query.setSelect(campo);
  query.setFrom(tabla);
  query.setWhere(where + ";");
  if (query.exec()) {
    if (query.next()) {
      for (var i = 0; i < campo.length; i++) {
        valor[campo[i]] = query.value(i);
      }
    } else {
      valor.result = -1;
    }
  } else {
    MessageBox.critical
      (util.translate("scripts", "Falló la consulta") + query.sql(),
      MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    valor.result = 0;
  }

  return valor;
}

/** \D Copia una linea de la comanda  a la factura

@param idFactura identificador de la factura
@param curLineaComanda cursor de las lineas de la comanda
@return Boolean, true si la linea se ha copiado correctamente y false si ha habido algún errror
*/
function oficial_copiarLinea(idFactura:Number,curLineaComanda:FLSqlCursor):Boolean
{
        if (!this.iface.curLineaFactura)
                this.iface.curLineaFactura = new FLSqlCursor("lineasfacturascli");

        with (this.iface.curLineaFactura) {
                setModeAccess(Insert);
                refreshBuffer();
                setValueBuffer("idfactura", idFactura);
        }

        if (!this.iface.datosLineaFactura(curLineaComanda))
                return false;

        if (!this.iface.curLineaFactura.commitBuffer())
                        return false;

        return this.iface.curLineaFactura.valueBuffer("idlinea");
}

/** \D Copia campo a campo una linea de la comanda en una línea de la factura
@param curLineaComanda cursor de las lineas de la comanda
@return Boolean, true si la linea se ha copiado correctamente y false si ha habido algún errror
*/
function oficial_datosLineaFactura(curLineaComanda:FLSqlCursor):Boolean
{
        var util:FLUtil = new FLUtil;
        with (this.iface.curLineaFactura) {
                setValueBuffer("referencia", curLineaComanda.valueBuffer("referencia"));
                setValueBuffer("descripcion", curLineaComanda.valueBuffer("descripcion"));
                setValueBuffer("pvpunitario", curLineaComanda.valueBuffer("pvpunitario"));
                setValueBuffer("cantidad", curLineaComanda.valueBuffer("cantidad"));
                setValueBuffer("pvpsindto", curLineaComanda.valueBuffer("pvpsindto"));
                setValueBuffer("pvptotal", curLineaComanda.valueBuffer("pvptotal"));
                setValueBuffer("codimpuesto", curLineaComanda.valueBuffer("codimpuesto"));
                setValueBuffer("iva", curLineaComanda.valueBuffer("iva"));
                setValueBuffer("recargo", curLineaComanda.valueBuffer("recargo"));
                setValueBuffer("dtolineal", curLineaComanda.valueBuffer("dtolineal"));
                setValueBuffer("dtopor", curLineaComanda.valueBuffer("dtopor"));
        }
        /// Para la extensión de subcuenta de ventas por artículos
        var subctaVentas:Array = flfacturac.iface.pub_subcuentaVentas(curLineaComanda.valueBuffer("referencia"));
        if (subctaVentas) {
                this.iface.curLineaFactura.setValueBuffer("codsubcuenta", subctaVentas.codsubcuenta);
                this.iface.curLineaFactura.setValueBuffer("idsubcuenta", subctaVentas.idsubcuenta);
        }
        return true;
}
/** \D Copia todas las lineas de la acomanda a la factura

@param idComanda identificador de la comanda
@param idFactura idfentificador de la factura
@return Boolean true si se han copiado todas las líneas correctamente y fasle si ha habido algún error
*/
function oficial_copiarLineas(idComanda:Number, idFactura:Number):Boolean
{
        var curLineaComanda:FLSqlCursor = new FLSqlCursor("tpv_lineascomanda");
        curLineaComanda.select("idtpv_comanda = " + idComanda);
        while (curLineaComanda.next()) {
                if(!this.iface.copiarLinea(idFactura,curLineaComanda))
                        return false;
        }
        return true;
}

/** \D Crea la factura a partir de una comanda

@param curComanda cursor de la comanda
@return False si ha habido algún error y el idFactura se se ha creado correctamente
*/
function oficial_crearFactura(curComanda:FLSqlCursor):Number
{
        var util:FLUtil = new FLUtil();
        var idFactura:Number;

        if (!this.iface.curFactura) {
                this.iface.curFactura = new FLSqlCursor("facturascli");
        }
        this.iface.curFactura.setModeAccess(this.iface.curFactura.Insert);
        this.iface.curFactura.refreshBuffer();

        if (!this.iface.datosFactura(curComanda)) {
                return false;
        }
        if (!this.iface.curFactura.commitBuffer()) {
                return false;
        }
        idFactura = this.iface.curFactura.valueBuffer("idfactura");
        if (!this.iface.copiarLineas(curComanda.valueBuffer("idtpv_comanda"), idFactura)) {
                return false;
        }
        this.iface.curFactura.select("idfactura = " + idFactura);
        if (!this.iface.curFactura.first()) {
                return false;
        }
        if (!formRecordfacturascli.iface.pub_actualizarLineasIva(this.iface.curFactura)) {
                return false;
        }
        this.iface.curFactura.setModeAccess(this.iface.curFactura.Edit);
        this.iface.curFactura.refreshBuffer();

        if (!this.iface.totalesFactura()) {
                return false;
        }
        if (!this.iface.curFactura.commitBuffer()) {
                return false;
        }
        return idFactura;
}

/** \D Crea la factura a partir de una comanda

@param curComanda cursor de la comanda
@param idFactura Número de la factura
@return False si ha habido algún error y el idFactura se se ha creado correctamente
*/
function oficial_modificarFactura(curComanda:FLSqlCursor, idFactura:String):Number
{
        var util:FLUtil = new FLUtil();

        if (!this.iface.borrarRecibosFactura(idFactura)) {
                return false;
        }
        if (!this.iface.curFactura) {
                this.iface.curFactura = new FLSqlCursor("facturascli");
        }
        this.iface.curFactura.select("idfactura = " + idFactura);
        if (!this.iface.curFactura.first()) {
                return false;
        }
        this.iface.curFactura.setModeAccess(this.iface.curFactura.Edit);
        this.iface.curFactura.refreshBuffer();

        if (!this.iface.borrarLineasFactura(idFactura)) {
                return false;
        }

        if (!this.iface.datosFactura(curComanda)) {
                return false;
        }
        if (!this.iface.curFactura.commitBuffer()) {
                return false;
        }
        idFactura = this.iface.curFactura.valueBuffer("idfactura");
        if (!this.iface.copiarLineas(curComanda.valueBuffer("idtpv_comanda"), idFactura)) {
                return false;
        }
        this.iface.curFactura.select("idfactura = " + idFactura);
        if (!this.iface.curFactura.first()) {
                return false;
        }
        if (!formRecordfacturascli.iface.pub_actualizarLineasIva(this.iface.curFactura)) {
                return false;
        }
        this.iface.curFactura.setModeAccess(this.iface.curFactura.Edit);
        this.iface.curFactura.refreshBuffer();

        if (!this.iface.totalesFactura()) {
                return false;
        }
        if (!this.iface.curFactura.commitBuffer()) {
                return false;
        }
        return idFactura;
}

/** \D Calcula los datos de totale de la factura
@return        true el cálculo se realiza correcamente, false en caso contrario
\end */
function oficial_totalesFactura():Boolean
{
        with (this.iface.curFactura) {
                setValueBuffer("neto", formfacturascli.iface.pub_commonCalculateField("neto", this));
                setValueBuffer("totaliva", formfacturascli.iface.pub_commonCalculateField("totaliva", this));
                setValueBuffer("totalirpf", formfacturascli.iface.pub_commonCalculateField("totalirpf", this));
                setValueBuffer("totalrecargo", formfacturascli.iface.pub_commonCalculateField("totalrecargo", this));
                setValueBuffer("total", formfacturascli.iface.pub_commonCalculateField("total", this));
                setValueBuffer("totaleuros", formfacturascli.iface.pub_commonCalculateField("totaleuros", this));
                setValueBuffer("codigo", formfacturascli.iface.pub_commonCalculateField("codigo", this));
        }
        return true;
}

/** \D Establece los datos de la factura a partir del registro de ventas
@param        curComanda: Cursor posicionado en el registro de ventas
@return        true si la copia de datos es correcta, false en caso contrario
\end */
function oficial_datosFactura(curComanda:FLSqlCursor):Boolean
{
        var util:FLUtil = new FLUtil;

        var codAlmacen:String = util.sqlSelect("tpv_puntosventa", "codalmacen", "codtpv_puntoventa = '" + curComanda.valueBuffer("codtpv_puntoventa") + "'");
        if (!codAlmacen || codAlmacen == "")
                codAlmacen = flfactppal.iface.pub_valorDefectoEmpresa("codalmacen");

        var codCliente:String = curComanda.valueBuffer("codcliente");
        var nomCliente:String = curComanda.valueBuffer("nombrecliente");
        var cifCliente:String = curComanda.valueBuffer("cifnif");
        var direccion:String = curComanda.valueBuffer("direccion");

        if (!nomCliente || nomCliente == "") {
                nomCliente = "-";
        }
        if (!cifCliente || cifCliente == "") {
                cifCliente = "-";
        }
        if (!direccion || direccion == "") {
                direccion = "-";
        }

        var serieCliente:String = this.iface.obtenerSerieFactura(curComanda);

        with (this.iface.curFactura) {
                if (codCliente && codCliente != "") {
                        setValueBuffer("codcliente", codCliente);
                }
                setValueBuffer("nombrecliente", nomCliente);
                setValueBuffer("cifnif", cifCliente);
                setValueBuffer("direccion", direccion);
                if (curComanda.valueBuffer("coddir") != 0) {
                        setValueBuffer("coddir", curComanda.valueBuffer("coddir"));
                }
                setValueBuffer("codpostal", curComanda.valueBuffer("codpostal"));
                setValueBuffer("ciudad", curComanda.valueBuffer("ciudad"));
                setValueBuffer("provincia", curComanda.valueBuffer("provincia"));
                setValueBuffer("codpais", curComanda.valueBuffer("codpais"));
                setValueBuffer("fecha", curComanda.valueBuffer("fecha"));
                setValueBuffer("hora", curComanda.valueBuffer("hora"));
                setValueBuffer("codejercicio",flfactppal.iface.pub_ejercicioActual());
                setValueBuffer("coddivisa", flfactppal.iface.pub_valorDefectoEmpresa("coddivisa"));
                setValueBuffer("codpago", curComanda.valueBuffer("codpago"));
                setValueBuffer("codalmacen", codAlmacen);
                setValueBuffer("codserie", serieCliente);
                setValueBuffer("tasaconv", util.sqlSelect("divisas", "tasaconv", "coddivisa = '" + flfactppal.iface.pub_valorDefectoEmpresa("coddivisa") + "'"));
                setValueBuffer("automatica", true);
                setValueBuffer("tpv", true);
        }
        return true;
}

function oficial_obtenerSerieFactura(curComanda:String):String
{
        var util:FLUtil = new FLUtil;
        var codSerie:String = this.iface.valorDefectoTPV("codserie");
        if (!codSerie) {
                var codCliente:String = curComanda.valueBuffer("codcliente");
                var serieCliente = "";
                if (codCliente && codCliente != "") {
                        serieCliente = util.sqlSelect("clientes", "codserie", "codcliente = '" + codCliente + "'");
                }

                if (!serieCliente || serieCliente == "") {
                        serieCliente = flfactppal.iface.pub_valorDefectoEmpresa("codserie");
                }
                codSerie = serieCliente;
        }
        return codSerie;
}

/** \D
Crea una nueva forma de pago y establece los valores del formulario Datos Genenrales
*/
function oficial_valoresIniciales()
{
        var cursor:FLSqlCursor = new FLSqlCursor("formaspago");
        with(cursor) {
                setModeAccess(cursor.Insert);
                refreshBuffer();
                setValueBuffer("codpago", "TARJ");
                setValueBuffer("descripcion", "TARJETA");
                setValueBuffer("genrecibos", "Pagados");
                commitBuffer();
        }
        delete cursor;

        cursor = new FLSqlCursor("plazos");
        with(cursor) {
                setModeAccess(cursor.Insert);
                refreshBuffer();
                setValueBuffer("codpago", "TARJ");
                setValueBuffer("dias", "0");
                setValueBuffer("aplazado", "100");
                commitBuffer();
        }

        delete cursor;

        cursor = new FLSqlCursor("tpv_datosgenerales");
        with(cursor) {
                setModeAccess(cursor.Insert);
                refreshBuffer();
                setValueBuffer("tarifa", "");
                setValueBuffer("pagoefectivo", "CONT");
                setValueBuffer("pagotarjeta", "TARJ");
                commitBuffer();
        }
}

/** \D Borra la factura especificada, eliminando sus pagos si existen
@param        idFactura: Identificador de la factura a borrar
@return        true si la factura se borra correctamente, false en caso contrario
\end */
function oficial_borrarFactura(idFactura:String):Boolean
{
        var util:FLUtil = new FLUtil;

        if (!this.iface.borrarRecibosFactura(idFactura)) {
                return false;
        }

        if (!util.sqlDelete("facturascli", "idfactura = " + idFactura)) {
                return false;
        }

        return true;
}

function oficial_borrarRecibosFactura(idFactura:String):Boolean
{
        var util:FLUtil = new FLUtil;
        if (sys.isLoadedModule("flfactteso")) {
                var qryRecibos:FLSqlQuery = new FLSqlQuery();
                qryRecibos.setTablesList("reciboscli,pagosdevolcli");
                qryRecibos.setSelect("idpagodevol");
                qryRecibos.setFrom("reciboscli r INNER JOIN pagosdevolcli p ON r.idrecibo = p.idrecibo");
                qryRecibos.setWhere("r.idfactura = " + idFactura + " ORDER BY p.idrecibo, p.fecha DESC, p.idpagodevol DESC");
                try { qryRecibos.setForwardOnly( true ); } catch (e) {}
                if (!qryRecibos.exec()) {
                        return false;
                }
                var curPagos:FLSqlCursor = new FLSqlCursor("pagosdevolcli");
                while (qryRecibos.next()) {
                        curPagos.select("idpagodevol = " + qryRecibos.value("idpagodevol"));
                        if (!curPagos.first()) {
                                return false;
                        }
                        curPagos.setModeAccess(curPagos.Del);
                        if (!curPagos.refreshBuffer()) {
                                return false;;
                        }
                        if (!curPagos.commitBuffer()) {
                                return false;
                        }
                }

                var curRecibos:FLSqlCursor = new FLSqlCursor("reciboscli");
                curRecibos.select("idfactura = " + idFactura);
                while (curRecibos.next()) {
                        curRecibos.setModeAccess(curRecibos.Del);
                        curRecibos.refreshBuffer();
                        if (!curRecibos.commitBuffer()) {
                                return false;
                        }
                }
        }
        return true;
}

/** \C Genera un recibo pagado por cada pago asociada a la comanda
@param        curComanda: cursor posiciondado en la comanda
@return        true si la generación se realiza correctamente, false en caso contrario
\end */
function oficial_generarRecibos(curComanda:FLSqlCursor):Boolean
{
        if (!sys.isLoadedModule("flfactteso"))
                return true;

        var util:FLUtil = new FLUtil;

        var idFactura:String = curComanda.valueBuffer("idfactura");
        var qryFactura = new FLSqlQuery();
        qryFactura.setTablesList("facturascli");
        qryFactura.setSelect("idfactura, coddivisa, codigo, codcliente, nombrecliente, cifnif, coddir, direccion, codpostal, ciudad, provincia, codpais, tasaconv");
        qryFactura.setFrom("facturascli");
        qryFactura.setWhere("idfactura = " + idFactura);
        try { qryFactura.setForwardOnly( true ); } catch (e) {}

        if (!qryFactura.exec())
                return false;;
        if (!qryFactura.first())
                return false;

        var curPagos:FLSqlCursor = new FLSqlCursor("tpv_pagoscomanda");
        var curPago:FLSqlCursor = new FLSqlCursor("tpv_pagoscomanda");
        curPago.setActivatedCommitActions(false);

        curPagos.select("idtpv_comanda = " + curComanda.valueBuffer("idtpv_comanda") + " AND estado = '" + util.translate("scripts", "Pagado") + "'");

        var datosRecibo:Array = [];
        datosRecibo.numRecibo = 1;
        datosRecibo.moneda = util.sqlSelect("facturascli f INNER JOIN divisas d ON f.coddivisa = d.coddivisa", "d.descripcion", "f.idfactura = " + idFactura, "facturascli,divisas");
        datosRecibo.estado = "Pagado";

        var idRecibo:String;
        var importe:Number;
        var totalPagado:Number, esEditable;
        while (curPagos.next()) {
                curPagos.setModeAccess(curPagos.Browse);
                curPagos.refreshBuffer();
                curPago.select("idpago = " + curPagos.valueBuffer("idpago"));
                if (!curPago.first()) {
                        return false;
                }
                esEditable = curPago.valueBuffer("editable");
                if (!esEditable) {
                        curPago.setUnLock("editable", true);
                        curPago.select("idpago = " + curPagos.valueBuffer("idpago"));
                        if (!curPago.first()) {
                                return false;
                        }
                }
                curPago.setModeAccess(curPago.Edit);
                curPago.refreshBuffer();

                datosRecibo.importe = parseFloat(curPago.valueBuffer("importe"));
                datosRecibo.fecha = curPago.valueBuffer("fecha");
                datosRecibo.codPago = curPago.valueBuffer("codpago");

                idRecibo = this.iface.generarRecibo(qryFactura, datosRecibo);
                if (!idRecibo)
                        return false;
                datosRecibo.numRecibo++;
                totalPagado += datosRecibo.importe;

                curPago.setValueBuffer("idrecibo", idRecibo);
                if (!curPago.commitBuffer()) {
                        return false;
                }
                if (!esEditable) {
                        curPago.select("idpago = " + curPagos.valueBuffer("idpago"));
                        if (!curPago.first()) {
                                return false;
                        }
                        curPago.setUnLock("editable", false);
                }
        }

        datosRecibo.importe = parseFloat(curComanda.valueBuffer("total")) - totalPagado;
        if (datosRecibo.importe > 0) {
                datosRecibo.estado = "Emitido";
                datosRecibo.fecha = curComanda.valueBuffer("fecha");

                idRecibo = this.iface.generarRecibo(qryFactura, datosRecibo);
                if (!idRecibo)
                        return false;
        }

        return true;
}

/** \C Genera un recibo más un pago asociado al pago de la comanda
@param        qryFactura: consulta que contiene los datos de la factura
@param        datosRecibo: Array con los siguientes datos relativos al recibo:
        importe
        número
        fecha
        moneda
        estado
@return        identificador del recibo, o false si hay error
\end */
function oficial_generarRecibo(qryFactura:FLSqlQuery, datosRecibo:Array):Number
{
        var util:FLUtil = new FLUtil;

        var curRecibo:FLSqlCursor = new FLSqlCursor("reciboscli");
        with (curRecibo) {
                setModeAccess(Insert);
                refreshBuffer()
                setValueBuffer("numero", datosRecibo.numRecibo);
                setValueBuffer("idfactura", qryFactura.value("idfactura"));
                setValueBuffer("importe", datosRecibo.importe);
                setValueBuffer("importeeuros", datosRecibo.importe * parseFloat(qryFactura.value("tasaconv")));
                setValueBuffer("coddivisa", qryFactura.value("coddivisa"));
                setValueBuffer("codigo", qryFactura.value("codigo") + "-" + flfacturac.iface.pub_cerosIzquierda(datosRecibo.numRecibo, 2));
                setValueBuffer("codcliente", qryFactura.value("codcliente"));
                setValueBuffer("nombrecliente", qryFactura.value("nombrecliente"));
                setValueBuffer("cifnif", qryFactura.value("cifnif"));
                if (qryFactura.value("coddir"))
                        setValueBuffer("coddir", qryFactura.value("coddir"));
                else
                        setNull("coddir");
                setValueBuffer("direccion", qryFactura.value("direccion"));
                setValueBuffer("codpostal", qryFactura.value("codpostal"));
                setValueBuffer("ciudad", qryFactura.value("ciudad"));
                setValueBuffer("provincia", qryFactura.value("provincia"));
                setValueBuffer("codpais", qryFactura.value("codpais"));
                setValueBuffer("fecha", datosRecibo.fecha);
                setValueBuffer("fechav", datosRecibo.fecha);
                setValueBuffer("estado", datosRecibo.estado);
                setValueBuffer("texto", util.enLetraMoneda(datosRecibo.importe, datosRecibo.moneda));
        }
        if (!curRecibo.commitBuffer())
                return false;

        var idRecibo = curRecibo.valueBuffer("idrecibo");
        if (datosRecibo.estado == util.translate("scripts", "Pagado")) {
                if (!this.iface.pagarRecibo(idRecibo, datosRecibo))
                        return false;
        }

        return idRecibo;
}

/** \C
Crea un registro de pago en tesorería asociado al recibo especificado
@param        idRecibo: Identificador del recibo a pagar
@param        datpsRecibo: Array con los datos del recibo
@return true si el pago se crea correctamente, false en caso contrario
\end */
function oficial_pagarRecibo(idRecibo:String, datosRecibo:Array):Boolean
{
        var util:FLUtil = new FLUtil;

        var hayContabilidad:Boolean = (sys.isLoadedModule("flcontppal") && flfactppal.iface.pub_valorDefectoEmpresa("contintegrada"));
        var ejercicioActual:String = flfactppal.iface.pub_ejercicioActual();

        var idSubcuenta:String = "";
        var codSubcuenta:String = "";

        var qryCuenta:FLSqlQuery = new FLSqlQuery;
        qryCuenta.setTablesList("formaspago,cuentasbanco");
        qryCuenta.setSelect("cuenta,ctaentidad,ctaagencia,codsubcuenta");
        qryCuenta.setFrom("formaspago f INNER JOIN cuentasbanco c ON f.codcuenta = c.codcuenta")
        qryCuenta.setWhere("f.codpago = '" + datosRecibo.codPago + "'")
        try { qryCuenta.setForwardOnly( true ); } catch (e) {}
        if (!qryCuenta.exec())
                return false;

        var cuenta:String = "";
        var entidad:String = "";
        var agencia:String = "";
        if (qryCuenta.first()) {
                cuenta = qryCuenta.value("cuenta");
                entidad = qryCuenta.value("ctaentidad");
                agencia = qryCuenta.value("ctaagencia");
                codSubcuenta = qryCuenta.value("codsubcuenta");
        }

        if (hayContabilidad) {
                if (codSubcuenta && codSubcuenta != "") {
                        idSubcuenta = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + codSubcuenta + "' AND codejercicio = '" + ejercicioActual + "'");
                }
                if (!idSubcuenta || idSubcuenta == "") {
                        var datosSubcuenta:Array = flfacturac.iface.pub_datosCtaEspecial("CAJA", ejercicioActual);
                        if (datosSubcuenta.error != 0) {
                                MessageBox.warning(util.translate("scripts", "No tiene ninguna cuenta contable marcada como cuenta especial de caja\nDebe asociar la cuenta a la cuenta especial en el módulo Principal del área Financiera"), MessageBox.Ok, MessageBox.NoButton);
                                return false;
                        }
                        codSubcuenta = datosSubcuenta.codsubcuenta;
                        idSubcuenta = datosSubcuenta.idsubcuenta;
                }
        }

        var curPagoDevol:FLSqlCursor = new FLSqlCursor("pagosdevolcli");
        with (curPagoDevol) {
                setModeAccess(Insert);
                refreshBuffer();
                setValueBuffer("idrecibo", idRecibo);
                setValueBuffer("fecha", datosRecibo.fecha);
                setValueBuffer("tipo", "Pago");
                setValueBuffer("cuenta", cuenta);
                setValueBuffer("ctaagencia", agencia);
                setValueBuffer("ctaentidad", entidad);
                if (hayContabilidad) {
                        setValueBuffer("idsubcuenta", idSubcuenta);
                        setValueBuffer("codsubcuenta", codSubcuenta);
                } else {
                        setNull("idsubcuenta");
                        setNull("codsubcuenta");
                }
        }
        if (!curPagoDevol.commitBuffer())
                return false;

        return true;
}

/** \D Envia una cadena de caracteres a la impresora
@param        datos: Cadena de caracteres
@param        maxLon: Número de caracteres máximo a enviar. Si este valor no está informado se envia toda la cadena.
\end */
function oficial_imprimirDatos(datos:String, maxLon:Number, alineacion:Number)
{
        // Si hay códigos de escape por imprimir, se imprimen antes de enviar los datos
        if (this.iface.printerESC != "ESC:") {
                this.iface.printer.send(this.iface.printerESC, this.iface.printerXPos, this.iface.printerYPos);
                this.iface.printerESC = "ESC:";
        }
        if (!datos)
                datos = "";
        else
                datos = datos.toString();

        if (maxLon && maxLon != 0) {
                datos = datos.left(maxLon);
                if (datos.length < maxLon) {
                        if (alineacion == 2)
                                datos = this.iface.espaciosIzquierda(datos, maxLon);
                        else
                                datos = flfactppal.iface.pub_espaciosDerecha(datos, maxLon);
                }
        }

        this.iface.printer.send(datos, this.iface.printerXPos, this.iface.printerYPos);
        this.iface.printerXPos += datos.length;

        this.iface.textoPrinter += datos;
}

function oficial_espaciosIzquierda(texto:String, totalLongitud:Number):String
{
        var ret:String = ""
        var numEspacios:Number = totalLongitud - texto.toString().length;
        for ( ; numEspacios > 0 ; --numEspacios)
                ret += " ";
        ret += texto.toString();
        return ret;
}


function oficial_impNuevaLinea(numLineas:Number)
{
        if (!numLineas)
                numLineas = 1;

        if (numLineas == 1) {
                this.iface.printerESC += "0A";
                this.iface.printer.send(this.iface.printerESC);
        } else {
                this.iface.printerESC += "1B,64," + flfactppal.iface.pub_cerosIzquierda(numLineas, 2);
                this.iface.printer.send(this.iface.printerESC);
        }
        this.iface.printerESC = "ESC:";
        this.iface.printerXPos = 1;
        this.iface.printerYPos += numLineas;

        for(var i:Number = 0; i < numLineas; i++)
                this.iface.textoPrinter += "\n";
}

/** \D Activa o desactiva el resaltado de letra
@param        alineación: Posibles valores:
        0. Alinear a la izquieda
        1. Centrar
        2. Alinear a la derecha
\end */
function oficial_impAlinearH(alineacion:Number)
{
        var tipo:String = "00";
        switch (alineacion) {
                case 0: {
                        tipo = "00";
                        break;
                }
                case 1: {
                        tipo = "01";
                        break;
                }
                case 2: {
                        tipo = "02";
                        break;
                }
        }
        this.iface.printerESC += "0D,1B,61," + tipo + ",";
}

/** \D Activa o desactiva el resaltado de letra
@param        resaltar: Indica si hay que activar o desactivar el resaltado
\end */
function oficial_impResaltar(resaltar:Boolean)
{
        if (resaltar)
                this.iface.printerESC += "1B,45,01,";
        else
                this.iface.printerESC += "1B,45,00,";
}

/** \D Activa o desactiva el subrayado de letra
@param        resaltar: Indica si hay que activar o desactivar el subrayado
\end */
function oficial_impSubrayar(subrayar:Boolean)
{
        if (subrayar)
                this.iface.printerESC += "1B,2D,01,";
        else
                this.iface.printerESC += "1B,2D,00,";
}

function oficial_flushImpresora()
{
        debug(this.iface.textoPrinter);
        this.iface.textoPrinter = "";

        if (this.iface.printerESC != "ESC:") {
                this.iface.printer.send(this.iface.printerESC, this.iface.printerXPos, this.iface.printerYPos);
                this.iface.printerESC = "ESC:";
        }
        this.iface.printer.flush();
}

function oficial_impCortar()
{
        this.iface.printerESC += "1B,6D,";
}

function oficial_establecerImpresora(impresora:String)
{
        if (this.iface.printer)
                delete this.iface.printer;
        this.iface.printer = new FLPosPrinter();
        this.iface.printer.setPrinterName( impresora );
        this.iface.printerXPos = 1;
        this.iface.printerYPos = 1;
        this.iface.printerESC = "ESC:1B,74,19,";
        this.iface.impAlinearH(0);
        this.iface.impResaltar(false);
}

/** \U Genera o regenera el asiento correspondiente a un arqueo de TPV
@param        curArqueo: Cursor con los datos del arqueo
@return        VERDADERO si no hay error. FALSO en otro caso
\end */
function oficial_generarAsientoArqueo(curArqueo:FLSqlCursor):Boolean
{
        if (curArqueo.modeAccess() != curArqueo.Edit) {
                return true;
        }

        var util:FLUtil = new FLUtil;
        if (curArqueo.valueBuffer("nogenerarasiento")) {
                curArqueo.setNull("idasiento");
                return true;
        }

        if (!this.iface.comprobarRegularizacion(curArqueo)) {
                return false;
        }

        var datosAsiento:Array = [];
        var valoresDefecto:Array;
        valoresDefecto["codejercicio"] = flfactppal.iface.pub_ejercicioActual();
        valoresDefecto["coddivisa"] = flfactppal.iface.pub_valorDefectoEmpresa("coddivisa");

        datosAsiento = this.iface.regenerarAsiento(curArqueo, valoresDefecto);
        if (datosAsiento.error == true) {
                return false;
        }

        if (!this.iface.generarPartidasArqueo(curArqueo, datosAsiento, valoresDefecto)) {
                return false;
        }

        if (!flcontppal.iface.pub_comprobarAsiento(datosAsiento.idasiento)) {
                return false;
        }

        if (!util.sqlSelect("co_partidas", "idpartida", "idasiento = " + datosAsiento.idasiento)) {
                if (!this.iface.pub_borrarAsientoArqueo(curArqueo, datosAsiento.idasiento)) {
                        return false;
                }
        } else {
                curArqueo.setValueBuffer("idasiento", datosAsiento.idasiento);
        }
        return true;
}

function oficial_generarPartidasArqueo(curArqueo:FLSqlCursor, datosAsiento:Array, valoresDefecto:Array):Boolean
{
        if (!this.iface.generarPartidasMovi(curArqueo, datosAsiento.idasiento, valoresDefecto)) {
                return false;
        }

        if (!this.iface.generarPartidasMoviCierre(curArqueo, datosAsiento.idasiento, valoresDefecto)) {
                return false;
        }

        if (!this.iface.generarPartidasDif(curArqueo, datosAsiento.idasiento, valoresDefecto)) {
                return false;
        }
        return true;
}

/** \D Comprueba que si la factura tiene IVA, no esté incluida en un período de regularización ya cerrado
@param        curFactura: Cursor de la factura de cliente o proveedor
@return TRUE si la factura no tiene IVA o teniéndolo su fecha no está incluida en ningún período ya cerrado. FALSE en caso contrario
\end */
function oficial_comprobarRegularizacion(curArqueo:FLSqlCursor):Boolean
{
        var util:FLUtil = new FLUtil;

        var fecha:String = curArqueo.valueBuffer("diahasta");
        var codEjercicio:String = flfactppal.iface.pub_ejercicioActual();
        if (util.sqlSelect("co_regiva", "idregiva", "fechainicio <= '" + fecha + "' AND fechafin >= '" + fecha + "' AND codejercicio = '" + codEjercicio + "'")) {
                MessageBox.warning(util.translate("scripts", "No puede incluirse el asiento de la factura en un período de I.V.A. ya regularizado"), MessageBox.Ok, MessageBox.NoButton);
                return false;
        }
        return true;
}

/** \D Genera o regenera el registro en la tabla de asientos correspondiente a la factura. Si el asiento ya estaba creado borra sus partidas asociadas.
@param        curArqueo: Cursor posicionado en el registro de arqueo
@param        valoresDefecto: Array con los valores por defecto de ejercicio y divisa
@return        array con los siguientes datos:
asiento.idasiento: Id del asiento
asiento.numero: numero del asiento
asiento.fecha: fecha del asiento
asiento.error: indicador booleano de que ha habido un error en la función
\end */
function oficial_regenerarAsiento(curArqueo:FLSqlCursor, valoresDefecto:Array):Array
{
        var util:FLUtil = new FLUtil;
        var asiento:Array = [];
        var idAsiento:Number = curArqueo.valueBuffer("idasiento");
        if (curArqueo.isNull("idasiento") || curArqueo.valueBuffer("idasiento") == 0) {
                var curAsiento:FLSqlCursor = new FLSqlCursor("co_asientos");
                with (curAsiento) {
                        setModeAccess(curAsiento.Insert);
                        refreshBuffer();
                        setValueBuffer("numero", 0);
                        setValueBuffer("fecha", curArqueo.valueBuffer("diahasta"));
                        setValueBuffer("codejercicio", valoresDefecto.codejercicio);
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
                if (!flfacturac.iface.pub_asientoBorrable(idAsiento)) {
                        asiento.error = true;
                        return asiento;
                }

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
                curAsiento.setValueBuffer("fecha", curArqueo.valueBuffer("diahasta"));

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

/** \D Borra el registro en la tabla de asientos correspondiente a un arqueo de ventas.
@param        curArqueo: Cursor posicionado en el registro de arqueo
@param        valoresDefecto: Array con los valores por defecto de ejercicio y divisa
@return        True si el asiento se borra correctamente o no existe, false en caso contrario
\end */
function oficial_borrarAsientoArqueo(curArqueo:FLSqlCursor, idAsiento:String):Boolean
{
        var util:FLUtil = new FLUtil;

        if (!flfacturac.iface.pub_asientoBorrable(idAsiento)) {
                return false;
        }

        var curAsiento:FLSqlCursor = new FLSqlCursor("co_asientos");
        curAsiento.select("idasiento = " + idAsiento);
        if (!curAsiento.first()) {
                return false;
        }
        curAsiento.setUnLock("editable", true);

//         curAsiento.select("idasiento = " + idAsiento);
//         if (!curArqueo.first()) {
//                 return false;
//         }
//         curArqueo.setModeAccess(curArqueo.Edit);
//         curArqueo.refreshBuffer();
//         curArqueo.setNull("idasiento");
//         if (!curArqueo.commitBuffer()) {
//                 return false;
//         }

        if (!util.sqlDelete("co_asientos", "idasiento = " + idAsiento)) {
                return false;
        }

        return true;
}

/** \D Genera la parte del asiento de arqueo correspondiente a las subcuentas de clientes
@param        curArqueo: Cursor del arqueo
@param        idAsiento: Id del asiento asociado
@param        valoresDefecto: Array con los valores por defecto de ejercicio y divisa
@return        VERDADERO si no hay error, FALSO en otro caso
\end */
/*
function oficial_generarPartidasCliente(curArqueo:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean
{
        var util:FLUtil = new FLUtil();

        var qrySubcuentas:FLSqlQuery = new FLSqlQuery;
        with (qrySubcuentas) {
                setTablesList("");
                setSelect("c.codcliente, SUM(p.importe)");
                setFrom("tpv_pagoscomanda p INNER JOIN tpv_comandas c ON p.idtpv_comanda = c.idtpv_comanda");
                setWhere("p.idtpv_arqueo = '" + curArqueo.valueBuffer("idtpv_arqueo") + "' AND c.idfactura IS NULL GROUP BY c.codcliente");
                setForwardOnly(true);
        }
        if (!qrySubcuentas.exec())
                return false;

        var ctaCliente:Array = [];
        var codCliente:String;
        var debe:Number = 0;
        var debeME:Number = 0;

        while (qrySubcuentas.next()) {
                codCliente = qrySubcuentas.value("c.codcliente");
                if (codCliente && codCliente != "") {
                        ctaCliente = flfactppal.iface.pub_datosCtaCliente( codCliente, valoresDefecto );
                        if (ctaCliente.error != 0) {
                                MessageBox.warning(util.translate("scripts", "Error al obtener los datos de la subcuenta asociada al cliente %1").arg(codCliente), MessageBox.Ok, MessageBox.NoButton);
                                return false;
                        }
                } else {
                        ctaCliente = flfacturac.iface.pub_datosCtaEspecial("CLIENT", valoresDefecto.codejercicio);
                        if (ctaCliente.error != 0) {
                                MessageBox.warning(util.translate("scripts", "Error al obtener los datos de la subcuenta genérica de clientes. Asegúrese de que en el módulo de contabilidad tiene una cuenta o subcuenta asociada a la cuenta especial CLIENT"), MessageBox.Ok, MessageBox.NoButton);
                                return false;
                        }
                }
                debe = qrySubcuentas.value("SUM(p.importe)");
                debeME = 0;
                debe = util.roundFieldValue(debe, "co_partidas", "debe");

                var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
                with (curPartida) {
                        setModeAccess(curPartida.Insert);
                        refreshBuffer();
                        setValueBuffer("idsubcuenta", ctaCliente.idsubcuenta);
                        setValueBuffer("codsubcuenta", ctaCliente.codsubcuenta);
                        setValueBuffer("idasiento", idAsiento);
                        setValueBuffer("debe", debe);
                        setValueBuffer("haber", 0);
                        setValueBuffer("coddivisa", valoresDefecto.coddivisa);
                        setValueBuffer("tasaconv", 1);
                        setValueBuffer("debeME", debeME);
                        setValueBuffer("haberME", 0);
                }

                curPartida.setValueBuffer("concepto", this.iface.conceptoPartida(curArqueo, util.translate("scripts", "Cliente %1").arg(codCliente)));

                if (!curPartida.commitBuffer())
                        return false;

                with (curPartida) {
                        setModeAccess(curPartida.Insert);
                        refreshBuffer();
                        setValueBuffer("idsubcuenta", ctaCliente.idsubcuenta);
                        setValueBuffer("codsubcuenta", ctaCliente.codsubcuenta);
                        setValueBuffer("idasiento", idAsiento);
                        setValueBuffer("debe", 0);
                        setValueBuffer("haber", debe);
                        setValueBuffer("coddivisa", valoresDefecto.coddivisa);
                        setValueBuffer("tasaconv", 1);
                        setValueBuffer("debeME", 0);
                        setValueBuffer("haberME", debeME);
                }

                curPartida.setValueBuffer("concepto", this.iface.conceptoPartida(curArqueo, util.translate("scripts", "Cliente %1").arg(codCliente)));

                if (!curPartida.commitBuffer())
                        return false;
        }
        return true;
}
*/

/** \D Genera la parte del asiento de arqueo correspondiente a las subcuentas de clientes
@param        curArqueo: Cursor del arqueo
@param        idAsiento: Id del asiento asociado
@param        valoresDefecto: Array con los valores por defecto de ejercicio y divisa
@return        VERDADERO si no hay error, FALSO en otro caso
\end */
/*
function oficial_generarPartidasVentasIva(curArqueo:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean
{
        var util:FLUtil = new FLUtil();

        var qrySubcuentas:FLSqlQuery = new FLSqlQuery;
        with (qrySubcuentas) {
                setTablesList("");
                setSelect("c.codcliente, c.idtpv_comanda, c.codigo, SUM(p.importe), c.total, c.totaliva, c.neto");
                setFrom("tpv_pagoscomanda p INNER JOIN tpv_comandas c ON p.idtpv_comanda = c.idtpv_comanda");
                setWhere("p.idtpv_arqueo = '" + curArqueo.valueBuffer("idtpv_arqueo") + "' AND c.idfactura IS NULL GROUP BY c.codcliente, c.idtpv_comanda, c.codigo, c.total, c.totaliva, c.neto ORDER BY c.codcliente");
                setForwardOnly(true);
        }
        if (!qrySubcuentas.exec())
                return false;

        var ctaVentas:Array = this.iface.subcuentaDefecto("VENTAS", valoresDefecto.codejercicio);
        if (ctaVentas.error != 0)
                return false;

        var ivas:Array = [];

        var ctaCliente:Array;
        var codComanda:String;
        var codCliente:String;
        var cifCliente:String;
        var codClientePrevio:String = "";
        var acumTotal:Number = 0;
        var acumIVA:Number = 0;
        //var acumIVACliente:Number = 0;
        //var acumNetoCliente:Number = 0;
        var totalComanda:Number;
        var totalPagado:Number;
        var haber:Number = 0;
        var haberME:Number = 0;

        var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
        var qryLineasIva:FLSqlQuery = new FLSqlQuery();
        qryLineasIva.setTablesList("tpv_lineascomanda");
        qryLineasIva.setSelect("SUM(pvptotal), codimpuesto, iva");
        qryLineasIva.setFrom("tpv_lineascomanda");
        qryLineasIva.setForwardOnly(true);

        var codImpuesto:String;
        var iva:Number;
        var indiceIva:Number;
        var acumIvaComanda:Number;
        var acumBaseComanda:Number;
debug(qrySubcuentas.sql());
        while (qrySubcuentas.next()) {
                codCliente = qrySubcuentas.value("c.codcliente");
debug (codCliente);

                codComanda = qrySubcuentas.value("c.codigo");
                totalComanda = parseFloat(qrySubcuentas.value("c.total"));
                totalPagado = parseFloat(qrySubcuentas.value("SUM(p.importe)"));
                if (totalComanda != totalPagado) {
                        MessageBox.warning(util.translate("scripts", "Error al procesar la venta %1:\nEl total de pagos asociados al arqueo actual no coincide con el total de la venta.\nSi se trata de una venta a cuenta, debe editarla y generar una factura asociada para poder cerrar el arqueo.").arg(codComanda), MessageBox.Ok, MessageBox.NoButton);
                        return false;
                }
                acumTotal += totalComanda;

                qryLineasIva.setWhere("idtpv_comanda = " + qrySubcuentas.value("c.idtpv_comanda") + " GROUP BY codimpuesto, iva");
                if (!qryLineasIva.exec())
                        return false;

                acumIvaComanda = 0;
                acumBaseComanda = 0;
                while (qryLineasIva.next()) {
                        codImpuesto = qryLineasIva.value("codimpuesto");
                        iva = qryLineasIva.value("iva");
                        if (!iva || isNaN(iva))
                                iva = 0;

                        for (indiceIva = 0; indiceIva < ivas.length; indiceIva++) {
                                if (ivas[indiceIva]["codimpuesto"] == codImpuesto)
                                        break;
                        }
                        if (indiceIva == ivas.length) {
                                ivas[indiceIva] = [];
                                ivas[indiceIva]["codimpuesto"] = codImpuesto;
                                ivas[indiceIva]["iva"] = iva;
                                ivas[indiceIva]["subcuenta"] = flfacturac.iface.datosCtaIVA("IVAREP", valoresDefecto.codejercicio, codImpuesto);
                                if (ivas[indiceIva]["subcuenta"].error != 0)
                                        return false;
                                ivas[indiceIva]["acumuladoiva"] = 0;
                                ivas[indiceIva]["acumuladobase"] = 0;
                        }
                        acumBaseComanda += parseFloat(qryLineasIva.value("SUM(pvptotal)"));
                        acumIvaComanda += parseFloat(qryLineasIva.value("SUM(pvptotal)")) * parseFloat(ivas[indiceIva]["iva"]) / 100;
                        ivas[indiceIva]["acumuladobase"] += parseFloat(qryLineasIva.value("SUM(pvptotal)"));
                        ivas[indiceIva]["acumuladoiva"] += parseFloat(qryLineasIva.value("SUM(pvptotal)")) * parseFloat(ivas[indiceIva]["iva"]) / 100;
                }
                if ((acumIvaComanda + acumBaseComanda) != totalComanda) {
                        MessageBox.warning(util.translate("scripts", "Error al procesar el IVA de la comanda %1. La suma de valores (%2) no coincide con el total (%3)").arg(qrySubcuentas.value("c.codigo")).arg(acumIvaComanda + acumBaseComanda).arg(totalComanda), MessageBox.Ok, MessageBox.NoButton);
                        return false;
                }

                acumIVA += parseFloat(qrySubcuentas.value("c.totaliva"));
                //acumIVACliente += parseFloat(qrySubcuentas.value("c.totaliva"));
                //acumNetoCliente += parseFloat(qrySubcuentas.value("c.neto"));

                if (codCliente != codClientePrevio) {
                        cifCliente = util.sqlSelect("clientes", "cifnif", "codcliente = '" + codCliente + "'");
                        ctaCliente = flfactppal.iface.pub_datosCtaCliente( codCliente, valoresDefecto );
                        if (ctaCliente.error != 0) {
                                MessageBox.warning(util.translate("scripts", "Error al obtener los datos de la subcuenta asociada al cliente %1").arg(codCliente), MessageBox.Ok, MessageBox.NoButton);
                                return false;
                        }

                        for (var i:Number = 0; i < ivas.length; i++) {
                                // IVA
                                haber = ivas[i]["acumuladoiva"];
                                if (haber == 0)
                                        continue;
                                haberME = 0;
                                haber = util.roundFieldValue(haber, "co_partidas", "haber");

                                with (curPartida) {
                                        setModeAccess(curPartida.Insert);
                                        refreshBuffer();
                                        setValueBuffer("idsubcuenta", ivas[i]["subcuenta"].idsubcuenta);
                                        setValueBuffer("codsubcuenta", ivas[i]["subcuenta"].codsubcuenta);
                                        setValueBuffer("idasiento", idAsiento);
                                        setValueBuffer("debe", 0);
                                        setValueBuffer("haber", haber);
                                        setValueBuffer("coddivisa", valoresDefecto.coddivisa);
                                        setValueBuffer("tasaconv", 1);
                                        setValueBuffer("debeME", 0);
                                        setValueBuffer("haberME", haberME);
                                        setValueBuffer("baseimponible", ivas[i]["acumuladobase"]);
                                        setValueBuffer("iva", ivas[i]["iva"]);
                                        //setValueBuffer("recargo", ¿?);
                                        setValueBuffer("idcontrapartida", ctaCliente.idsubcuenta);
                                        setValueBuffer("codcontrapartida", ctaCliente.codsubcuenta);
                                        //setValueBuffer("codserie", ¿?);
                                        setValueBuffer("cifnif", cifCliente);
                                }
                        debug(codCliente);
debug(util.translate("scripts", "I.V.A. %1% Cliente %2").arg(ivas[i]["iva"]).arg(codCliente));
debug(util.translate("scripts", "I.V.A. %1 Cliente %2").arg(ivas[i]["iva"]).arg(codCliente));
                                curPartida.setValueBuffer("concepto", this.iface.conceptoPartida(curArqueo, util.translate("scripts", "I.V.A. %1% Cliente %2").arg(ivas[i]["iva"]).arg(codCliente)));

                                if (!curPartida.commitBuffer())
                                        return false;

                                ivas[i]["acumuladobase"] = 0;
                                ivas[i]["acumuladoiva"] = 0;
                        }
                }
        }
        cifCliente = util.sqlSelect("clientes", "cifnif", "codcliente = '" + codCliente + "'");
        ctaCliente = flfactppal.iface.pub_datosCtaCliente( codCliente, valoresDefecto );
        if (ctaCliente.error != 0) {
                MessageBox.warning(util.translate("scripts", "Error al obtener los datos de la subcuenta asociada al cliente %1").arg(codCliente), MessageBox.Ok, MessageBox.NoButton);
                return false;
        }

        for (var i:Number = 0; i < ivas.length; i++) {
                // IVA
                haber = ivas[i]["acumuladoiva"];
                if (haber == 0)
                        continue;
                haberME = 0;
                haber = util.roundFieldValue(haber, "co_partidas", "haber");

                with (curPartida) {
                        setModeAccess(curPartida.Insert);
                        refreshBuffer();
                        setValueBuffer("idsubcuenta", ivas[i]["subcuenta"].idsubcuenta);
                        setValueBuffer("codsubcuenta", ivas[i]["subcuenta"].codsubcuenta);
                        setValueBuffer("idasiento", idAsiento);
                        setValueBuffer("debe", 0);
                        setValueBuffer("haber", haber);
                        setValueBuffer("coddivisa", valoresDefecto.coddivisa);
                        setValueBuffer("tasaconv", 1);
                        setValueBuffer("debeME", 0);
                        setValueBuffer("haberME", haberME);
                        setValueBuffer("baseimponible", ivas[i]["acumuladobase"]);
                        setValueBuffer("iva", ivas[i]["iva"]);
                        //setValueBuffer("recargo", ¿?);
                        setValueBuffer("idcontrapartida", ctaCliente.idsubcuenta);
                        setValueBuffer("codcontrapartida", ctaCliente.codsubcuenta);
                        //setValueBuffer("codserie", ¿?);
                        setValueBuffer("cifnif", cifCliente);
                }
        debug(codCliente);
                curPartida.setValueBuffer("concepto", this.iface.conceptoPartida(curArqueo, util.translate("scripts", "I.V.A. %1% Cliente %2").arg(ivas[i]["iva"]).arg(codCliente)));

                if (!curPartida.commitBuffer())
                        return false;

                ivas[i]["acumuladobase"] = 0;
                ivas[i]["acumuladoiva"] = 0;
        }

        // Ventas
        haber = acumTotal - acumIVA;
        haberME = 0;
        haber = util.roundFieldValue(haber, "co_partidas", "haber");

        if (parseFloat(haber) != 0) {
                with (curPartida) {
                        setModeAccess(curPartida.Insert);
                        refreshBuffer();
                        setValueBuffer("idsubcuenta", ctaVentas.idsubcuenta);
                        setValueBuffer("codsubcuenta", ctaVentas.codsubcuenta);
                        setValueBuffer("idasiento", idAsiento);
                        setValueBuffer("debe", 0);
                        setValueBuffer("haber", haber);
                        setValueBuffer("coddivisa", valoresDefecto.coddivisa);
                        setValueBuffer("tasaconv", 1);
                        setValueBuffer("debeME", 0);
                        setValueBuffer("haberME", haberME);
                }
                curPartida.setValueBuffer("concepto", this.iface.conceptoPartida(curArqueo, util.translate("scripts", "Ventas")));

                if (!curPartida.commitBuffer())
                        return false;
        }
        return true;
}
*/

/** \D Genera la parte del asiento de arqueo correspondiente a las subcuentas de pagos
@param        curArqueo: Cursor del arqueo
@param        idAsiento: Id del asiento asociado
@param        valoresDefecto: Array con los valores por defecto de ejercicio y divisa
@return        VERDADERO si no hay error, FALSO en otro caso
\end */
/*
function oficial_generarPartidasPago(curArqueo:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean
{
        var util:FLUtil = new FLUtil();

        var qrySubcuentas:FLSqlQuery = new FLSqlQuery;
        with (qrySubcuentas) {
                setTablesList("");
                setSelect("p.codpago, SUM(p.importe)");
                setFrom("tpv_pagoscomanda p INNER JOIN tpv_comandas c ON p.idtpv_comanda = c.idtpv_comanda");
                setWhere("p.idtpv_arqueo = '" + curArqueo.valueBuffer("idtpv_arqueo") + "' AND c.idfactura IS NULL GROUP BY p.codpago");
                setForwardOnly(true);
        }
        if (!qrySubcuentas.exec())
                return false;

        var codPago:String;
        var debe:Number = 0;
        var debeME:Number = 0;
        var codPagoEfectivo:String = util.sqlSelect("tpv_datosgenerales", "pagoefectivo", "1 = 1");
        var codPagoTarjeta:String = util.sqlSelect("tpv_datosgenerales", "pagotarjeta", "1 = 1");
        var codPagoVale:String = util.sqlSelect("tpv_datosgenerales", "pagovale", "1 = 1");

        var ctaPago:Array;
        while (qrySubcuentas.next()) {
                codPago = qrySubcuentas.value("p.codpago");
                switch (codPago) {
                        case codPagoEfectivo: {
                                ctaPago = this.iface.subcuentaDefecto("CAJA", valoresDefecto.codejercicio);
                                if (ctaPago.error != 0)
                                        return false;
                                break;
                        }
                        case codPagoTarjeta: {
                                ctaPago = this.iface.subcuentaDefecto("TARJETA", valoresDefecto.codejercicio);
                                if (ctaPago.error != 0)
                                        return false;
                                break;
                        }
                        case codPagoVale: {
                                ctaPago = this.iface.subcuentaDefecto("VALE", valoresDefecto.codejercicio);
                                if (ctaPago.error != 0)
                                        return false;
                                break;
                        }
                        default: {
                                var codComanda:String = util.sqlSelect("tpv_pagoscomanda p INNER JOIN tpv_comandas c ON p.idtpv_comanda = c.idtpv_comanda", "c.codigo", "p.codpago = '" + codPago + "'");
                                MessageBox.warning(util.translate("scripts", "Al menos la venta %1 contiene una forma de pago que no está calificada como Efectivo, Tarjeta o Vales en el formulario de datos generales del módulo de TPV.\nPara generar el asiento asociado al arqueo actual debe corregir la forma de pago de esta venta.").arg(codComanda), MessageBox.Ok, MessageBox.NoButton);
                                break;
                        }
                }
                debe = qrySubcuentas.value("SUM(p.importe)");
                debeME = 0;
                debe = util.roundFieldValue(debe, "co_partidas", "debe");

                var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
                with (curPartida) {
                        setModeAccess(curPartida.Insert);
                        refreshBuffer();
                        setValueBuffer("idsubcuenta", ctaPago.idsubcuenta);
                        setValueBuffer("codsubcuenta", ctaPago.codsubcuenta);
                        setValueBuffer("idasiento", idAsiento);
                        setValueBuffer("debe", debe);
                        setValueBuffer("haber", 0);
                        setValueBuffer("coddivisa", valoresDefecto.coddivisa);
                        setValueBuffer("tasaconv", 1);
                        setValueBuffer("debeME", debeME);
                        setValueBuffer("haberME", 0);
                }

                curPartida.setValueBuffer("concepto", this.iface.conceptoPartida(curArqueo, util.translate("scripts", "Pagos")));

                if (!curPartida.commitBuffer())
                        return false;
        }
        return true;
}
*/

/** \D Genera la parte del asiento de arqueo correspondiente a los movimientos de caja extraordinarios
@param        curArqueo: Cursor del arqueo
@param        idAsiento: Id del asiento asociado
@param        valoresDefecto: Array con los valores por defecto de ejercicio y divisa
@return        VERDADERO si no hay error, FALSO en otro caso
\end */
function oficial_generarPartidasMovi(curArqueo:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean
{
        var util:FLUtil = new FLUtil();

        var qryMovimientos:FLSqlQuery = new FLSqlQuery;
        with (qryMovimientos) {
                setTablesList("tpv_movimientos");
                setSelect("SUM(cantidad), codcausa");
                setFrom("tpv_movimientos");
                setWhere("idtpv_arqueo = '" + curArqueo.valueBuffer("idtpv_arqueo") + "' GROUP BY codcausa");
                setForwardOnly(true);
        }
        if (!qryMovimientos.exec())
                return false;

        var debe:Number = 0;
        var debeCaja:Number = 0;
        var haber:Number = 0;
        var haberCaja:Number = 0;
        var totalMovi:Number = parseFloat(curArqueo.valueBuffer("totalmov"));
        if (totalMovi == 0)
                return true;

        if (totalMovi > 0 ) {
                debeCaja = totalMovi;
                haberCaja = 0;
        } else {
                totalMovi = totalMovi * -1;
                debeCaja = 0;
                haberCaja = totalMovi;
        }
        debeCaja = util.roundFieldValue(debeCaja, "co_partidas", "debe");
        haberCaja = util.roundFieldValue(haberCaja, "co_partidas", "haber");

        var codPagoEfectivo:String = util.sqlSelect("tpv_datosgenerales", "pagoefectivo", "1 = 1");

        var ctaCaja:Array = this.iface.subcuentaDefecto("CAJA", valoresDefecto.codejercicio);
        if (ctaCaja.error != 0)
                return false;

        var ctaMovi:Array;
        var importeMovi:Number;
        var codCausa:String;
        var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
        while (qryMovimientos.next()) {
                importeMovi = parseFloat(qryMovimientos.value("SUM(cantidad)"));
                if (!importeMovi || isNaN(importeMovi) || importeMovi == 0)
                        continue;

                codCausa = qryMovimientos.value("codcausa");
                if (!codCausa || codCausa == "") {
                        MessageBox.warning(util.translate("scripts", "No es posible generar el asiento contable asociado al arqueo por la siguiente razón:\nHay al menos un movimiento de caja que no tiene establecida una causa.\nVerifique que todos los movimientos tienen asociada una causa y que ésta tiene asociada una cuenta contable"), MessageBox.Ok, MessageBox.NoButton);
                        return false;
                }
                ctaMovi = this.iface.subcuentaCausa(codCausa, valoresDefecto.codejercicio);
                if (ctaMovi.error != 0)
                        return false;

                if (importeMovi > 0) {
                        debe = 0;
                        haber = importeMovi;
                } else {
                        importeMovi = importeMovi * -1;
                        debe = importeMovi;
                        haber = 0;
                }
                debe = util.roundFieldValue(debe, "co_partidas", "debe");
                haber = util.roundFieldValue(haber, "co_partidas", "haber");

                with (curPartida) {
                        setModeAccess(curPartida.Insert);
                        refreshBuffer();
                        setValueBuffer("idsubcuenta", ctaMovi.idsubcuenta);
                        setValueBuffer("codsubcuenta", ctaMovi.codsubcuenta);
                        setValueBuffer("idasiento", idAsiento);
                        setValueBuffer("debe", debe);
                        setValueBuffer("haber", haber);
                        setValueBuffer("coddivisa", valoresDefecto.coddivisa);
                        setValueBuffer("tasaconv", 1);
                        setValueBuffer("debeME", 0);
                        setValueBuffer("haberME", 0);
                }

                curPartida.setValueBuffer("concepto", this.iface.conceptoPartida(curArqueo, util.translate("scripts", "Movimientos efectivo")));

                if (!curPartida.commitBuffer())
                        return false;
        }

        with (curPartida) {
                setModeAccess(curPartida.Insert);
                refreshBuffer();
                setValueBuffer("idsubcuenta", ctaCaja.idsubcuenta);
                setValueBuffer("codsubcuenta", ctaCaja.codsubcuenta);
                setValueBuffer("idasiento", idAsiento);
                setValueBuffer("debe", debeCaja);
                setValueBuffer("haber", haberCaja);
                setValueBuffer("coddivisa", valoresDefecto.coddivisa);
                setValueBuffer("tasaconv", 1);
                setValueBuffer("debeME", 0);
                setValueBuffer("haberME", 0);
        }

        curPartida.setValueBuffer("concepto", this.iface.conceptoPartida(curArqueo, util.translate("scripts", "Movimientos efectivo")));

        if (!curPartida.commitBuffer())
                return false;

        return true;
}

/** \D Genera la parte del asiento de arqueo correspondiente al movimiento de ciere de caja
@param        curArqueo: Cursor del arqueo
@param        idAsiento: Id del asiento asociado
@param        valoresDefecto: Array con los valores por defecto de ejercicio y divisa
@return        VERDADERO si no hay error, FALSO en otro caso
\end */
function oficial_generarPartidasMoviCierre(curArqueo:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean
{
        var util:FLUtil = new FLUtil();

        var debe:Number = 0;
        var debeCaja:Number = 0;
        var haber:Number = 0;
        var haberCaja:Number = 0;
        var totalMovi:Number = parseFloat(curArqueo.valueBuffer("sacadodecaja"));
        if (totalMovi == 0) {
                return true;
        }

        if (totalMovi > 0 ) {
                debe = totalMovi;
                haber = 0;
                debeCaja = 0;
                haberCaja = totalMovi;
        } else {
                totalMovi = totalMovi * -1;
                debe = 0;
                haber = totalMovi;
                debeCaja = totalMovi;
                haberCaja = 0;
        }
        debe = util.roundFieldValue(debe, "co_partidas", "debe");
        haber = util.roundFieldValue(haber, "co_partidas", "haber");
        debeCaja = util.roundFieldValue(debeCaja, "co_partidas", "debe");
        haberCaja = util.roundFieldValue(haberCaja, "co_partidas", "haber");

        var codPagoEfectivo:String = util.sqlSelect("tpv_datosgenerales", "pagoefectivo", "1 = 1");

        var ctaCaja:Array = this.iface.subcuentaDefecto("CAJA", valoresDefecto.codejercicio);
        if (ctaCaja.error != 0) {
                MessageBox.warning(util.translate("scripts", "Error al generar el asiento: No tiene una subcuenta asociada a la cuenta especial CAJA"), MessageBox.Ok, MessageBox.NoButton);
                return false;
        }
        var codCausa:String = util.sqlSelect("tpv_datosgenerales", "codcausacierre", "1 = 1");
        if (!codCausa || codCausa == "") {
                MessageBox.warning(util.translate("scripts", "No es posible generar el asiento contable asociado al arqueo por la siguiente razón:\nNo tiene establecida la causa asociada al movimiento de cierre.\nAsocie la causa en el formulario de datos genrales y verifique que ésta tiene asociada una cuenta contable"), MessageBox.Ok, MessageBox.NoButton);
                        return false;
        }
        var ctaMovi:Array = this.iface.subcuentaCausa(codCausa, valoresDefecto.codejercicio);
        if (ctaMovi.error != 0) {
                MessageBox.warning(util.translate("scripts", "Error al generar el asiento: No tiene asociada una subcuenta vália a la Causa asociada al movimiento de cierre.\nEdite dicha Causa y asóciele una subcuenta válida."), MessageBox.Ok, MessageBox.NoButton);
                return false;
        }

        var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");

        with (curPartida) {
                setModeAccess(curPartida.Insert);
                refreshBuffer();
                setValueBuffer("idsubcuenta", ctaMovi.idsubcuenta);
                setValueBuffer("codsubcuenta", ctaMovi.codsubcuenta);
                setValueBuffer("idasiento", idAsiento);
                setValueBuffer("debe", debe);
                setValueBuffer("haber", haber);
                setValueBuffer("coddivisa", valoresDefecto.coddivisa);
                setValueBuffer("tasaconv", 1);
                setValueBuffer("debeME", 0);
                setValueBuffer("haberME", 0);
        }

        curPartida.setValueBuffer("concepto", this.iface.conceptoPartida(curArqueo, util.translate("scripts", "Movimiento de cierre")));

        if (!curPartida.commitBuffer())
                return false;

        with (curPartida) {
                setModeAccess(curPartida.Insert);
                refreshBuffer();
                setValueBuffer("idsubcuenta", ctaCaja.idsubcuenta);
                setValueBuffer("codsubcuenta", ctaCaja.codsubcuenta);
                setValueBuffer("idasiento", idAsiento);
                setValueBuffer("debe", debeCaja);
                setValueBuffer("haber", haberCaja);
                setValueBuffer("coddivisa", valoresDefecto.coddivisa);
                setValueBuffer("tasaconv", 1);
                setValueBuffer("debeME", 0);
                setValueBuffer("haberME", 0);
        }

        curPartida.setValueBuffer("concepto", this.iface.conceptoPartida(curArqueo, util.translate("scripts", "Movimiento de cierre")));

        if (!curPartida.commitBuffer())
                return false;

        return true;
}

/** \D Genera la parte del asiento de arqueo correspondiente a las diferencias de efectivo detectadas al hacer el arqueo
@param        curArqueo: Cursor del arqueo
@param        idAsiento: Id del asiento asociado
@param        valoresDefecto: Array con los valores por defecto de ejercicio y divisa
@return        VERDADERO si no hay error, FALSO en otro caso
\end */
function oficial_generarPartidasDif(curArqueo:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean
{
        var util:FLUtil = new FLUtil();

        var debe:Number = 0;
        var debeCaja:Number = 0;
        var haber:Number = 0;
        var haberCaja:Number = 0;
        var difEfectivo:Number = formRecordtpv_arqueos.iface.pub_commonCalculateField("diferenciaEfectivo", curArqueo);
        difEfectivo = parseFloat(difEfectivo);
        if (difEfectivo == 0)
                return true;

        var codPagoEfectivo:String = util.sqlSelect("tpv_datosgenerales", "pagoefectivo", "1 = 1");

        var ctaCaja:Array = this.iface.subcuentaDefecto("CAJA", valoresDefecto.codejercicio);
        if (ctaCaja.error != 0)
                return false;

        var ctaDif:Array;
        if (difEfectivo > 0) {
                haber = difEfectivo;
                debeCaja = difEfectivo;
                ctaDif = this.iface.subcuentaDefecto("DIFPOS", valoresDefecto.codejercicio);
                if (ctaDif.error != 0)
                        return false;
        } else {
                difEfectivo = difEfectivo * -1;
                debe = difEfectivo;
                haberCaja = difEfectivo;
                ctaDif = this.iface.subcuentaDefecto("DIFNEG", valoresDefecto.codejercicio);
                if (ctaDif.error != 0)
                        return false;
        }
        debe = util.roundFieldValue(debe, "co_partidas", "debe");
        haber = util.roundFieldValue(haber, "co_partidas", "haber");
        debeCaja = util.roundFieldValue(debeCaja, "co_partidas", "debe");
        haberCaja = util.roundFieldValue(haberCaja, "co_partidas", "haber");

        var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
        with (curPartida) {
                setModeAccess(curPartida.Insert);
                refreshBuffer();
                setValueBuffer("idsubcuenta", ctaDif.idsubcuenta);
                setValueBuffer("codsubcuenta", ctaDif.codsubcuenta);
                setValueBuffer("idasiento", idAsiento);
                setValueBuffer("debe", debe);
                setValueBuffer("haber", haber);
                setValueBuffer("coddivisa", valoresDefecto.coddivisa);
                setValueBuffer("tasaconv", 1);
                setValueBuffer("debeME", 0);
                setValueBuffer("haberME", 0);
        }

        curPartida.setValueBuffer("concepto", this.iface.conceptoPartida(curArqueo, util.translate("scripts", "Diferencias efectivo")));

        if (!curPartida.commitBuffer())
                return false;

        with (curPartida) {
                setModeAccess(curPartida.Insert);
                refreshBuffer();
                setValueBuffer("idsubcuenta", ctaCaja.idsubcuenta);
                setValueBuffer("codsubcuenta", ctaCaja.codsubcuenta);
                setValueBuffer("idasiento", idAsiento);
                setValueBuffer("debe", debeCaja);
                setValueBuffer("haber", haberCaja);
                setValueBuffer("coddivisa", valoresDefecto.coddivisa);
                setValueBuffer("tasaconv", 1);
                setValueBuffer("debeME", 0);
                setValueBuffer("haberME", 0);
        }

        curPartida.setValueBuffer("concepto", this.iface.conceptoPartida(curArqueo, util.translate("scripts", "Diferencias efectivo")));

        if (!curPartida.commitBuffer())
                return false;

        return true;
}

/** \D Establece los datos opcionales de una partida de asientos de arqueo
Para facilitar personalizaciones en las partidas.
Se ponen datos de concepto, tipo de documento, documento y factura
@param        curPartida: Cursor sobre la partida
@param        curArqueo: Cursor sobre el arqueo
@param        masConcepto: Concepto, opcional
*/
function oficial_conceptoPartida(curArqueo:FLSqlCursor, masConcepto:String):String
{
        var util:FLUtil = new FLUtil();
        var concepto:String = util.translate("scripts", "Arqueo de caja ") + curArqueo.valueBuffer("idtpv_arqueo");
        if (masConcepto)
                concepto += " " + masConcepto;

        return concepto;
}

function oficial_subcuentaCausa(codCausa:String, codEjercicio:String):Array
{
        var util:FLUtil = new FLUtil();
        var datos:Array = [];
        datos["error"] = 1;

        var q:FLSqlQuery = new FLSqlQuery();

        var codSubcuenta:String = util.sqlSelect("tpv_causasmovimiento", "codsubcuenta", "codcausa = '" + codCausa + "'");
        if (!codSubcuenta) {
                MessageBox.warning(util.translate("scripts", "No tiene especificada la subcuenta asociada a la causa de movimiento de caja %1.\nDebe editar la causa y asociar la correspondiente subcuenta contable").arg(codCausa), MessageBox.Ok, MessageBox.NoButton);
                return datos;
        }

        with(q) {
                setTablesList("co_subcuentas");
                setSelect("s.idsubcuenta, s.codsubcuenta");
                setFrom("co_subcuentas s");
                setWhere("s.codsubcuenta = '" + codSubcuenta + "' AND s.codejercicio = '" + codEjercicio + "'");
                setForwardOnly( true );
        }
        if (!q.exec()) {
                datos["error"] = 2;
                return datos;
        }
        if (q.first()) {
                datos["error"] = 0;
                datos["idsubcuenta"] = q.value(0);
                datos["codsubcuenta"] = q.value(1);
                return datos;
        }

        return datos;
}

function oficial_subcuentaDefecto(nombre:String, codEjercicio:String):Array
{
        var util:FLUtil = new FLUtil();
        var datos:Array = [];
        datos["error"] = 1;

        var q:FLSqlQuery = new FLSqlQuery();

        var codSubcuenta:String;
        switch (nombre) {
                case "VENTAS": {
                        codSubcuenta = util.sqlSelect("tpv_datosgenerales", "codsubcuentaven", "1 = 1");
                        if (!codSubcuenta) {
                                MessageBox.warning(util.translate("scripts", "No tiene especificada la subcuenta de ventas a utilizar en el asiento de arqueo.\nDebe especificar dicha subcuenta en el formulario de datos generales del módulo de TPV"), MessageBox.Ok, MessageBox.NoButton);
                                return datos;
                        }
                        break;
                }
                case "CAJA": {
                        codSubcuenta = util.sqlSelect("tpv_datosgenerales", "codsubcuentacaja", "1 = 1");
                        if (!codSubcuenta) {
                                MessageBox.warning(util.translate("scripts", "No tiene especificada la subcuenta de caja a utilizar en el asiento de arqueo.\nDebe especificar dicha subcuenta en el formulario de datos generales del módulo de TPV"), MessageBox.Ok, MessageBox.NoButton);
                                return datos;
                        }
                        break;
                }
                case "TARJETA": {
                        codSubcuenta = util.sqlSelect("tpv_datosgenerales", "codsubcuentatar", "1 = 1");
                        if (!codSubcuenta) {
                                MessageBox.warning(util.translate("scripts", "No tiene especificada la subcuenta de pago con tarjeta ventas a utilizar en el asiento de arqueo.\nDebe especificar dicha subcuenta en el formulario de datos generales del módulo de TPV"), MessageBox.Ok, MessageBox.NoButton);
                                return datos;
                        }
                        break;
                }
                case "VALE": {
                        codSubcuenta = util.sqlSelect("tpv_datosgenerales", "codsubcuentavale", "1 = 1");
                        if (!codSubcuenta) {
                                MessageBox.warning(util.translate("scripts", "No tiene especificada la subcuenta de pago con vale ventas a utilizar en el asiento de arqueo.\nDebe especificar dicha subcuenta en el formulario de datos generales del módulo de TPV"), MessageBox.Ok, MessageBox.NoButton);
                                return datos;
                        }
                        break;
                }
                case "DIFPOS": {
                        codSubcuenta = util.sqlSelect("tpv_datosgenerales", "codsubcuentadifpos", "1 = 1");
                        if (!codSubcuenta) {
                                MessageBox.warning(util.translate("scripts", "No tiene especificada la subcuenta de diferencias positivas de cambio a utilizar en el asiento de arqueo.\nDebe especificar dicha subcuenta en el formulario de datos generales del módulo de TPV"), MessageBox.Ok, MessageBox.NoButton);
                                return datos;
                        }
                        break;
                }
                case "DIFNEG": {
                        codSubcuenta = util.sqlSelect("tpv_datosgenerales", "codsubcuentadifneg", "1 = 1");
                        if (!codSubcuenta) {
                                MessageBox.warning(util.translate("scripts", "No tiene especificada la subcuenta de diferencias negativas de cambio a utilizar en el asiento de arqueo.\nDebe especificar dicha subcuenta en el formulario de datos generales del módulo de TPV"), MessageBox.Ok, MessageBox.NoButton);
                                return datos;
                        }
                        break;
                }
        }

        with(q) {
                setTablesList("co_subcuentas");
                setSelect("s.idsubcuenta, s.codsubcuenta");
                setFrom("co_subcuentas s");
                setWhere("s.codsubcuenta = '" + codSubcuenta + "' AND s.codejercicio = '" + codEjercicio + "'");
                setForwardOnly( true );
        }
        if (!q.exec()) {
                datos["error"] = 2;
                return datos;
        }
        if (!q.first()) {
                MessageBox.warning(util.translate("scripts", "No se ha encontrado la subcuenta %1 configurada como subcuenta %2 en los parámetros generales del TPV\npara el ejercicio %3").arg(codSubcuenta).arg(nombre).arg(codEjercicio), MessageBox.Ok, MessageBox.NoButton);
                return datos;
        }

        datos["error"] = 0;
        datos["idsubcuenta"] = q.value(0);
        datos["codsubcuenta"] = q.value(1);

        return datos;
}

function oficial_sincronizarConFacturacion(curComanda:FLSqlCursor):Boolean
{
        var util:FLUtil;

        switch (curComanda.modeAccess()) {
                case curComanda.Insert: {
                        var idFactura:String = this.iface.crearFactura(curComanda);
                        if (!idFactura) {
                                return false;
                        }
                        curComanda.setValueBuffer("idfactura", idFactura);
                        break;
                }
                case curComanda.Edit: {
                        var idFactura:String = curComanda.valueBuffer("idfactura");
                        if (idFactura && util.sqlSelect("facturascli", "idfactura", "idfactura = " + idFactura)) {
                                if (!this.iface.modificarFactura(curComanda, idFactura)) {
                                        return false;
                                }
                        } else {
                                idFactura = this.iface.crearFactura(curComanda);
                                if (!idFactura) {
                                        return false;
                                }
                                curComanda.setValueBuffer("idfactura", idFactura);
                        }
                        if (!this.iface.generarRecibos(curComanda)) {
                                return false;
                        }
                        break;
                }
                case curComanda.Del: {
                        var idFactura:String = curComanda.valueBuffer("idfactura");
                        if (!util.sqlDelete("tpv_pagoscomanda", "idtpv_comanda = " + curComanda.valueBuffer("idtpv_comanda"))) {
                                return false;
                        }
                        if (!util.sqlDelete("tpv_pagoscomanda", "idtpv_comanda = " + curComanda.valueBuffer("idtpv_comanda"))) {
                                return false;
                        }
                        if (!this.iface.borrarFactura(idFactura)) {
                                return false;
                        }
                        break;
                }
        }
        return true;
}

function oficial_obtenerCodigoComanda(curComanda:FLSqlCursor):String
{
        var util:FLUtil = new FLUtil();
        var prefijo = "";
        var ultimoTiquet:Number = util.sqlSelect("tpv_secuenciascomanda", "valor", "prefijo = '" + prefijo + "'");

        if (!ultimoTiquet) {
                var idUltimo:String = util.sqlSelect("tpv_comandas", "codigo", "codigo LIKE '" + prefijo + "%' ORDER BY codigo DESC");

                if (idUltimo) {
                        ultimoTiquet = parseFloat(idUltimo);
                } else {
                        ultimoTiquet = 0;
                }
                ultimoTiquet += 1;
//                 var pass:String = util.readSettingEntry( "DBA/password");
//                 var port:String = util.readSettingEntry( "DBA/port");
//                 if (!sys.addDatabase(sys.nameDriver(), sys.nameBD(), sys.nameUser(), pass, sys.nameHost(), port, "conAux")) {
//                         MessageBox.warning(util.translate("scripts", "Ha habido un error al establecer una conexión auxiliar con la base de datos %1").arg(sys.nameBD()), MessageBox.Ok, MessageBox.NoButton);
//                         return false;
//                 }
//                 var curSecuencia:FLSqlCursor = new FLSqlCursor("tpv_secuenciascomanda", "conAux");
                var curSecuencia:FLSqlCursor = new FLSqlCursor("tpv_secuenciascomanda");
                curSecuencia.setModeAccess(curSecuencia.Insert);
                curSecuencia.refreshBuffer();
                curSecuencia.setValueBuffer("prefijo", "");
                curSecuencia.setValueBuffer("valor", ultimoTiquet);
                if (!curSecuencia.commitBuffer()) {
                        return false;
                }
        }
        else {
                ultimoTiquet += 1;
                util.sqlUpdate("tpv_secuenciascomanda", "valor", ultimoTiquet, "prefijo = '" + prefijo + "'");
        }

        var codigo:String = prefijo + flfacturac.iface.pub_cerosIzquierda(ultimoTiquet, 12 - prefijo.length);

        return codigo;
}

function oficial_valorDefectoTPV(campo:String):String
{
        var util:FLUtil = new FLUtil;
        var valor:String = util.sqlSelect("tpv_datosgenerales", campo, "1 = 1");
        return valor;
}

function oficial_borrarLineasFactura(idFactura:String):Boolean
{
        var util:FLUtil = new FLUtil;
        var curLinea:FLSqlCursor = new FLSqlCursor("lineasfacturascli");
        curLinea.select("idfactura = " + idFactura);
        while (curLinea.next()) {
                curLinea.setModeAccess(curLinea.Del);
                curLinea.refreshBuffer();
                if (!curLinea.commitBuffer()) {
                        return false;
                }
        }
        return true;
}

/** Informa el nuevo campo almacén en las comandas previas a su introducción
\end */
function oficial_comprobarAlmacenesComandas()
{
        var util:FLUtil = new FLUtil;

        var curComandas:FLSqlCursor = new FLSqlCursor("tpv_comandas");
        curComandas.select("codalmacen = 'NULL'");
        curComandas.setActivatedCommitActions(false);
        curComandas.setActivatedCheckIntegrity(false);
        var codTerminal:String;
        while (curComandas.next()) {
                curComandas.setModeAccess(curComandas.Edit);
                curComandas.refresh();
                codTerminal = curComandas.valueBuffer("codtpv_puntoventa");
                curComandas.setValueBuffer("codalmacen", util.sqlSelect("tpv_puntosventa", "codalmacen", "codtpv_puntoventa = '" + codTerminal + "'"));
                if (!curComandas.commitBuffer()) {
                        return false;
                }
        }
        return true;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

