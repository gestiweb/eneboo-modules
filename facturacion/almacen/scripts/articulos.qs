/***************************************************************************
                 articulos.qs  -  description
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
        function validateForm():Boolean {return this.ctx.interna_validateForm();}
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
        var posActualPuntoSubcuenta:Number;
        var posActualPuntoSubcuentaIRPF:Number;
        var tbnProvDefecto:Object;

        function oficial( context ) { interna( context ); }
        function generarArticulosTarifas() {
                return this.ctx.oficial_generarArticulosTarifas();
        }
        function calcularStockFisico() {
                return this.ctx.oficial_calcularStockFisico();
        }
        function bufferChanged(fN:String) {
                return this.ctx.oficial_bufferChanged(fN);
        }
        function genCodBar(fN:String) {
                return this.ctx.oficial_genCodBar(fN);
        }
        function eliminarStock():Boolean {
                return this.ctx.oficial_eliminarStock();
        }
        function borrarDatosStock(referencia:String):Boolean {
                return this.ctx.oficial_borrarDatosStock(referencia);
        }
        function marcarProvDefecto() {
                return this.ctx.oficial_marcarProvDefecto();
        }
        function establecerProveedorDefecto(referencia:String, codProveedor:String):Boolean {
                return this.ctx.oficial_establecerProveedorDefecto(referencia, codProveedor);
        }
        function establecerDatosAlta() {
                return this.ctx.oficial_establecerDatosAlta();
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
        function pub_establecerProveedorDefecto(referencia:String, codProveedor:String):Boolean {
                return this.establecerProveedorDefecto(referencia, codProveedor);
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
/** \C El valor de --stockfis-- se calcula automáticamente para cada artículo como la suma de existencias del artículo en todos los almacenes.
\end */
function interna_init()
{
        var util:FLUtil = new FLUtil();
        var cursor:FLSqlCursor = this.cursor();

        this.iface.tbnProvDefecto = this.child("tbnProvDefecto");

        connect (this.iface.tbnProvDefecto, "clicked()", this, "iface.marcarProvDefecto");
        connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
        connect(this.child("pbnGenerarArticulosTarifas"), "clicked()", this, "iface.generarArticulosTarifas");
        if (this.child("tdbStocks"))
                connect(this.child("tdbStocks").cursor(), "cursorUpdated()", this, "iface.calcularStockFisico()");

        switch (cursor.modeAccess()) {
                case cursor.Insert: {
                        this.iface.establecerDatosAlta();
                        break;
                }
                case cursor.Browse: {
                        this.child("pbnGenerarArticulosTarifas").enabled = false;
                        break;
                }
                case cursor.Edit: {
                        if (cursor.valueBuffer("nostock")) {
                                this.child("tbwArticulo").setTabEnabled("stocks", false);
                        } else {
                                this.child("tbwArticulo").setTabEnabled("stocks", true);
                        }
                        break;
                }
        }
        this.iface.genCodBar("codbarras");

        this.iface.bufferChanged("secompra");
        this.iface.bufferChanged("sevende");

        if (sys.isLoadedModule("flcontppal")) {
                this.iface.ejercicioActual = flfactppal.iface.pub_ejercicioActual();
                this.iface.longSubcuenta = util.sqlSelect("ejercicios", "longsubcuenta", "codejercicio = '" + this.iface.ejercicioActual + "'");
                this.iface.bloqueoSubcuenta = false;
                this.iface.posActualPuntoSubcuenta = -1;
                this.child("fdbIdSubcuentaCom").setFilter("codejercicio = '" + this.iface.ejercicioActual + "'");
                this.child("fdbIdSubcuentaIrpfCom").setFilter("codejercicio = '" + this.iface.ejercicioActual + "'");
        } else
                this.child("tbwArticulo").setTabEnabled("contabilidad", false);
}

function interna_calculateField(nombreCampo:String):String
{
        var util:FLUtil = new FLUtil();
        /** \D El valor de --stockfis-- se calcula sumando todas las cantidades de esa referencia en la tabla stocks, esto es, las cantidades de todos los almacenes
        \end */
        if (nombreCampo == "stockfis")
                return util.sqlSelect("stocks", "SUM(cantidad)",  "referencia='" + this.cursor().valueBuffer("referencia") + "';");
}

function interna_validateForm():Boolean
{
        return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Genera las líneas de tarifas para un determinado artículo mediante el pvp base y los incrementos de cada tarifa. Cada línea contiene la referencia del artículo, el código de tarifa y el precio calculado para la tarifa.
\end */
function oficial_generarArticulosTarifas()
{
                var cursor:FLSqlCursor = this.cursor();
                var referencia:String = cursor.valueBuffer("referencia");
                var pvp:Number = cursor.valueBuffer("pvp");
                var codTarifa:String;
                var incLineal:Number;
                var incPorcentual:Number;
                var pvpTarifa:Number;

                var curArtTar:FLSqlCursor = this.child("tdbArticulosTarifas").cursor()
                var qryTarifas:FLSqlQuery = new FLSqlQuery();

/** \D Los incrementos lineal y porcentual de la tarifa sobre el precio base pueden acumularse
Las tarifas del artículo son eliminadas y regeneradas después
\end */
                qryTarifas.setTablesList("tarifas");
                qryTarifas.setSelect("codtarifa,inclineal,incporcentual");
                qryTarifas.setFrom("tarifas");

                qryTarifas.exec();
                while (qryTarifas.next()) {
                        codTarifa = qryTarifas.value(0);
                        with(curArtTar) {
                                select("referencia = '" + referencia + "' AND codtarifa = '" + codTarifa + "'");
                                if (first()) {
                                        setModeAccess(Del);
                                        refreshBuffer();
                                        commitBuffer();
                                }
                        }
                }

                qryTarifas.exec();
                while (qryTarifas.next()) {
                        codTarifa = qryTarifas.value(0);
                        incLineal = parseFloat(qryTarifas.value(1));
                        incPorcentual = parseFloat(qryTarifas.value(2));
                        pvpTarifa = ((pvp * (100 + incPorcentual)) / 100) + incLineal;
                        with(curArtTar) {
                                setModeAccess(Insert);
                                refreshBuffer();
                                setValueBuffer("referencia", referencia);
                                setValueBuffer("codtarifa", codTarifa);
                                setValueBuffer("pvp", pvpTarifa);
                                commitBuffer();
                        }
                }

                this.child("tdbArticulosTarifas").refresh();
}

/** \D Informa el campo --stockfis--
\end */
function oficial_calcularStockFisico()
{
                this.child("fdbStockFisico").setValue(this.iface.calculateField("stockfis"));
}

function oficial_bufferChanged(fN:String)
{
        var cursor:FLSqlCursor = this.cursor();

        switch (fN) {
                case "tipocodbarras":
                case "codbarras": {
                        this.iface.genCodBar(fN)
                        break;
                }
                case "codsubcuentacom": {
                        if (!this.iface.bloqueoSubcuenta) {
                                this.iface.bloqueoSubcuenta = true;
                                this.iface.posActualPuntoSubcuenta = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuentaCom", this.iface.longSubcuenta, this.iface.posActualPuntoSubcuenta);
                                this.iface.bloqueoSubcuenta = false;
                        }
                        break;
                }
                case "codsubcuentairpfcom": {
                        if (!this.iface.bloqueoSubcuenta) {
                                this.iface.bloqueoSubcuenta = true;
                                this.iface.posActualPuntoSubcuentaIRPF = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuentaIrpfCom", this.iface.longSubcuenta, this.iface.posActualPuntoSubcuentaIRPF);
                                this.iface.bloqueoSubcuenta = false;
                        }
                        break;
                }
                case "nostock": {
                        if (cursor.valueBuffer("nostock")) {
                                if (this.iface.eliminarStock()) {
                                        this.child("tbwArticulo").setTabEnabled("stocks", false);
                                } else {
                                        this.child("fdbNoStock").setValue(false);
                                }
                        } else {
                                this.child("tbwArticulo").setTabEnabled("stocks", true);
                        }
                        break;
                }
                case "secompra": {
                        if(!cursor.valueBuffer("secompra"))
                                this.child("tbwArticulo").setTabEnabled("compra", false);
                        else
                                this.child("tbwArticulo").setTabEnabled("compra", true);
                        break;
                }
                case "sevende": {
                        if(!cursor.valueBuffer("sevende"))
                                this.child("tbwArticulo").setTabEnabled("venta", false);
                        else
                                this.child("tbwArticulo").setTabEnabled("venta", true);
                        break;
                }
        }
}

function oficial_genCodBar(fN:String)
{
        if (fN == "tipocodbarras" || fN == "codbarras") {
                var cursor:FLSqlCursor = this.cursor();
                var type:String = cursor.valueBuffer("tipocodbarras");
                var value:String = cursor.valueBuffer("codbarras");

                var auxCodBar:FLCodBar = new FLCodBar(0);
                var codBar:FLCodBar = new FLCodBar(value, auxCodBar.nameToType(type), 10, 1, 0, 0, true);
                var pixmap:Object = codBar.pixmap();
                if (codBar.validBarcode())
                        this.child("pixmapCodBar").setPixmap(pixmap);
                else
                        this.child("pixmapCodBar").setPixmap(codBar.pixmapError());
        }
}

function oficial_eliminarStock():Boolean
{
        var util:FLUtil = new FLUtil;
        var cursor:FLSqlCursor = this.cursor();

        var referencia:String = cursor.valueBuffer("referencia");
        if (util.sqlSelect("stocks", "idstock", "referencia = '" + referencia + "'")) {
                var res:Number = MessageBox.warning(util.translate("scripts", "Existen valores de stock para este artículo.\nSi lo que desea hacer es indicar que se permiten ventas sin stock de este material, pulse Cancelar e indíquelo en la pestaña de Stocks.\nSi quiere eliminar completamente los datos de stock asociados a este artículo pulse Aceptar. Esta acción no es reversible."), MessageBox.Cancel, MessageBox.Ok);
                if (res != MessageBox.Ok) {
                        return false;
                }
        }
        var curTrans:FLSqlCursor = new FLSqlCursor("stocks");
        curTrans.transaction(false);
        try {
                if (this.iface.borrarDatosStock(referencia)) {
                        curTrans.commit();
                } else {
                        curTrans.rollback();
                        return false;
                }
        }
        catch (e) {
                curTrans.rollback();
                MessageBox.critical(util.translate("scripts", "Error al eliminar los datos de stock para el artículo %1").arg(referencia), MessageBox.Ok, MessageBox.NoButton);
                return false;
        }
        return true;
}

function oficial_borrarDatosStock(referencia:String):Boolean
{
        var util:FLUtil = new FLUtil;
        if (!util.sqlDelete("stocks", "referencia = '" + referencia + "'")) {
                return false;
        }

        return true;
}

function oficial_marcarProvDefecto()
{
        var util:FLUtil = new FLUtil;
        var cursor:FLSqlCursor = this.cursor();
        var curProv:FLSqlCursor = this.child("tdbArticulosProv").cursor();
        if (!curProv.valueBuffer("id"))
                return;

        var referencia:String = cursor.valueBuffer("referencia");
        var codProveedor:String = curProv.valueBuffer("codproveedor");
        if (!this.iface.establecerProveedorDefecto(referencia, codProveedor)) {
                return;
        }
        this.child("tdbArticulosProv").refresh();
}

function oficial_establecerProveedorDefecto(referencia:String, codProveedor:String):Boolean
{
        var util:FLUtil = new FLUtil;
        if (!util.sqlUpdate("articulosprov", "pordefecto", false, "referencia = '" + referencia + "'")) {
                return false;
        }

        if (!util.sqlUpdate("articulosprov", "pordefecto", true, "referencia = '" + referencia + "' AND codproveedor = '" + codProveedor + "'")) {
                return false;
        }

        return true;
}

function oficial_establecerDatosAlta()
{
debug("oficial_establecerDatosAlta " + flfactalma.iface.pub_valorDefectoAlmacen("codimpuesto"));
        this.child("fdbImpuesto").setValue(flfactalma.iface.pub_valorDefectoAlmacen("codimpuesto"));
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////


