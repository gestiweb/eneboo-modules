/***************************************************************************
                 co_cerrarejer.qs  -  description
                             -------------------
    begin                : mar ago 10 2004
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
        var divisaEmpresa:String;
    function oficial( context ) { interna( context ); }
        function tbnCerrar_clicked() { return this.ctx.oficial_tbnCerrar_clicked(); }
        function asientoPyG():Boolean { return this.ctx.oficial_asientoPyG(); }
        function asientoCierre():Boolean { return this.ctx.oficial_asientoCierre(); }
        function asientoApertura(idAsientoCierre, ejNuevo):Boolean { return this.ctx.oficial_asientoApertura(idAsientoCierre, ejNuevo); }
        function tbnEjercicio_clicked() { return this.ctx.oficial_tbnEjercicio_clicked(); }
        function validarCierre():Boolean { return this.ctx.oficial_validarCierre(); }
        function rollbackCierre() { return this.ctx.oficial_rollbackCierre(); }
        function comprobarSaldos():Boolean {
                return this.ctx.oficial_comprobarSaldos();
        }
        function crearSubcuentaApertura(codSubcuenta:String, ejNuevo:String):Number {
                return this.ctx.oficial_crearSubcuentaApertura(codSubcuenta, ejNuevo);
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
        function pub_asientoApertura(idAsientoCierre, ejNuevo):Boolean { return this.asientoApertura(idAsientoCierre, ejNuevo); }
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
/** \C Para cerrar el ejercicio, el usuario podrá decidir cuáles de las siguientes operaciones se realizarán automáticamente:

Contabilizar las diferencias de cambio: Crear asientos correspondientes a recibos sin pagar en moneda extranjera, de forma que se establezca el valor de la deuda a fecha de cierre del ejercicio.

Realizar el asiento de regularización en la cuenta de pérdidas y ganancias

Realizar el asiento de cierre de ejercicio

Realizar el asiento de apertura de ejercicio siguiente. Para poder generar el asiento de apertura, el ejercicio seleccionado debe tener generado su correspondiente plan general contable. Si se selecciona el check de generar asiento de apertura, se tendrá que seleccionar un ejercicio abierto que no contenga ya un asiento de apertura
\end */
function interna_init()
{
        var util:FLUtil = new FLUtil;
        var cursor:FLSqlCursor = this.cursor();
        this.child("pushButtonAccept").enabled = false;
        //var hoy:Date = new Date();
        this.child("dedFecha").date = cursor.valueBuffer("fechafin");

        this.iface.divisaEmpresa = util.sqlSelect("empresa", "coddivisa", "1 = 1");

        /** \U
                        Botón de cierre de ejercicio link_tbnCerrar_clicked

                        Botón de seleccion de ejercicio de apertura link_tbnEjercicio_clicked
        \end */
        connect(this.child("tbnCerrar"), "clicked()", this, "iface.tbnCerrar_clicked()");
        connect(this.child("tbnEjercicio"), "clicked()", this, "iface.tbnEjercicio_clicked()");
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////



/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \C
Arranca el cierre del ejercicio ejecutando todas las opciones seleccionadas
\end */
function oficial_tbnCerrar_clicked():Boolean
{
                var util:FLUtil = new FLUtil();

                if (!this.iface.validarCierre())
                                return false;

                 if (!this.iface.comprobarSaldos())
                         return false;

                if (this.child("ckbPyG").checked == true)
                                if (!this.iface.asientoPyG()) {
                                                MessageBox.critical(util.translate("scripts",
                                                "Error al generar el asiento de regularización de pérdidas y ganancias"),
                                                 MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
                                                 this.iface.rollbackCierre()
                                                return false;
                                }

                if (this.child("ckbAsientoCierre").checked == true)
                                if (!this.iface.asientoCierre()) {
                                                MessageBox.critical(util.translate("scripts",
                                                "Error al generar el asiento de cierre"),
                                                 MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
                                                this.iface.rollbackCierre()
                                                return false;
                                }

                if (this.child("ckbAsientoApertura").checked == true) {
                                if (!this.iface.asientoApertura(this.cursor().valueBuffer("idasientocierre"), this.child("ledEjercicio").text)) {
                                                MessageBox.critical(util.translate("scripts",
                                                                "Error al generar el asiento de apertura"),
                                                                MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
                                                this.iface.rollbackCierre()
                                                return false;
                                }
                }

                this.child("pushButtonAccept").enabled = true;
                this.child("pushButtonAccept").animateClick();

                return true;
}

/** \D
Genera el asiento de pérdidas y ganancias buscando las cuentas cuyo código de balance tenga como naturaleza DEBE o HABER

@return true en caso de éxito, false en caso contrario
\end */
function oficial_asientoPyG():Boolean
{
                var util:FLUtil = new FLUtil();
                var cursor:FLSqlCursor = this.cursor();

                var qryPyG:FLSqlQuery = new FLSqlQuery();
                qryPyG.setForwardOnly(true);
                qryPyG.setTablesList("co_cuentas,co_subcuentas,co_codbalances");
                qryPyG.setSelect("s.saldo, s.idsubcuenta, s.codsubcuenta");
                qryPyG.setFrom("co_cuentas c INNER JOIN co_subcuentas s ON c.idcuenta = s.idcuenta" +
                                " INNER JOIN co_codbalances b ON c.codbalance = b.codbalance");
                qryPyG.setWhere("c.codejercicio = '" + cursor.valueBuffer("codejercicio") + "'" +
                                " AND s.saldo <> 0" +
                                " AND b.naturaleza IN ('DEBE', 'HABER')");

                if (!qryPyG.exec())
                                return false;

                var curAsiento:FLSqlCursor = new FLSqlCursor("co_asientos");
                curAsiento.setForwardOnly(true);
                curAsiento.setModeAccess(curAsiento.Insert);
                curAsiento.refreshBuffer();
                curAsiento.setValueBuffer("numero", 0);
                curAsiento.setValueBuffer("fecha", this.child("dedFecha").date);
                curAsiento.setValueBuffer("codejercicio", cursor.valueBuffer("codejercicio"));

                if (!curAsiento.commitBuffer())
                                return false;

                util.createProgressDialog( util.translate( "scripts", "Creando asiento de regularización..." ), qryPyG.size() );
                util.setProgress(1);

                var idAsiento:Number = curAsiento.valueBuffer("idasiento");
                var curPartida:Number = new FLSqlCursor("co_partidas");
                curPartida.setForwardOnly(true);
                var debe:Number = 0;
                var haber:Number = 0;
                var totalDebe:Number = 0;
                var totalHaber:Number = 0;
                var paso:Number = 0;
                while (qryPyG.next()) {
                                if (parseFloat(qryPyG.value(0)) > 0) {
                                                debe = 0;
                                                haber = parseFloat(qryPyG.value(0));
                                } else {
                                                debe = 0 - parseFloat(qryPyG.value(0));
                                                haber = 0;
                                }
                                totalDebe += debe;
                                totalHaber += haber;

                                curPartida.setModeAccess(curPartida.Insert);
                                curPartida.refreshBuffer();
                                curPartida.setValueBuffer("concepto", util.translate("scripts", "Regularización ejercicio ") +
                                                cursor.valueBuffer("nombre"));
                                curPartida.setValueBuffer("idsubcuenta", qryPyG.value(1));
                                curPartida.setValueBuffer("codsubcuenta", qryPyG.value(2));
                                curPartida.setValueBuffer("idasiento", idAsiento);
                                curPartida.setValueBuffer("debe", debe);
                                curPartida.setValueBuffer("haber", haber);
                                curPartida.setValueBuffer("coddivisa", this.iface.divisaEmpresa);
                                curPartida.setValueBuffer("tasaconv", 1);
                                curPartida.setValueBuffer("debeME", 0);
                                curPartida.setValueBuffer("haberME", 0);
                                util.setProgress(paso++);

                                if (!curPartida.commitBuffer()) {
                                                util.destroyProgressDialog();
                                                return false;
                                }
                }

                var ctaPyG:Array = flfactppal.iface.pub_ejecutarQry("co_cuentas c INNER JOIN co_subcuentas s" +
                                                " ON c.idcuenta = s.idcuenta", "idsubcuenta,codsubcuenta",
                                                "c.idcuentaesp = 'PYG' AND c.codejercicio = '" + cursor.valueBuffer("codejercicio") + "'",
                                                "co_cuentas,co_subcuentas");
                if (ctaPyG.result != 1) {
                                util.destroyProgressDialog();
                                MessageBox.warning(util.translate("scripts",
                                                "Error en la búsqueda de la cuenta de pérdidas y ganancias"),
                                                 MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
                                return false;
                }

                if (totalDebe > totalHaber) {
                                debe = 0;
                                haber = totalDebe - totalHaber;
                } else {
                                debe = totalHaber - totalDebe;
                                haber = 0;
                }

                curPartida.setModeAccess(curPartida.Insert);
                curPartida.refreshBuffer();
                curPartida.setValueBuffer("concepto", util.translate("scripts", "Regularización ejercicio ") + cursor.valueBuffer("nombre"));
                curPartida.setValueBuffer("idsubcuenta", ctaPyG.idsubcuenta);
                curPartida.setValueBuffer("codsubcuenta", ctaPyG.codsubcuenta);
                curPartida.setValueBuffer("idasiento", idAsiento);
                curPartida.setValueBuffer("debe", debe);
                curPartida.setValueBuffer("haber", haber);
                curPartida.setValueBuffer("coddivisa", this.iface.divisaEmpresa);
                curPartida.setValueBuffer("tasaconv", 1);
                curPartida.setValueBuffer("debeME", 0);
                curPartida.setValueBuffer("haberME", 0);

                if (!curPartida.commitBuffer()) {
                                util.destroyProgressDialog();
                                return false;
                }

                curAsiento.select("idasiento = " + idAsiento);
                curAsiento.first();
                curAsiento.setModeAccess(curAsiento.Edit);
                curAsiento.refreshBuffer();
                curAsiento.setUnLock("editable", false);

                cursor.setValueBuffer("idasientopyg", idAsiento);

                util.destroyProgressDialog();
                return true;
}

/** \D
Genera el asiento de cierre buscando las cuentas cuyo código de balance tenga como naturaleza ACTIVO o PASIVO

@return true en caso de éxito, false en caso contrario
\end */
function oficial_asientoCierre():Boolean
{
                var util:FLUtil = new FLUtil();
                var cursor:FLSqlCursor = this.cursor();
                var qryAsientoCierre:FLSqlQuery = new FLSqlQuery();
                qryAsientoCierre.setForwardOnly(true);
                qryAsientoCierre.setTablesList("co_cuentas,co_subcuentas,co_codbalances");
                qryAsientoCierre.setSelect("s.saldo, s.idsubcuenta, s.codsubcuenta");
                qryAsientoCierre.setFrom("co_cuentas c INNER JOIN co_subcuentas s ON c.idcuenta = s.idcuenta" +
                                " INNER JOIN co_codbalances b ON c.codbalance = b.codbalance");
                qryAsientoCierre.setWhere("c.codejercicio = '" + cursor.valueBuffer("codejercicio") + "'" +
                                " AND s.saldo <> 0" +
                                " AND b.naturaleza IN ('ACTIVO', 'PASIVO')");

                if (!qryAsientoCierre.exec())
                                return false;

                var curAsiento:FLSqlCursor = new FLSqlCursor("co_asientos");
                curAsiento.setForwardOnly(true);
                curAsiento.setModeAccess(curAsiento.Insert);
                curAsiento.refreshBuffer();
                curAsiento.setValueBuffer("numero", 0);
                curAsiento.setValueBuffer("fecha", this.child("dedFecha").date);
                curAsiento.setValueBuffer("codejercicio", cursor.valueBuffer("codejercicio"));

                if (!curAsiento.commitBuffer())
                                return false;

                util.createProgressDialog( util.translate( "scripts", "Creando asiento de cierre..." ), qryAsientoCierre.size() );
                util.setProgress(1);

                var idAsiento:Number = curAsiento.valueBuffer("idasiento");
                var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
                curPartida.setForwardOnly(true);
                var debe:Number = 0;
                var haber:Number = 0;
                var totalDebe:Number = 0;
                var totalHaber:Number = 0;
                var paso:Number = 0;
                while (qryAsientoCierre.next()) {
                                if (parseFloat(qryAsientoCierre.value(0)) > 0) {
                                                debe = 0;
                                                haber = parseFloat(qryAsientoCierre.value(0));
                                } else {
                                                debe = 0 - parseFloat(qryAsientoCierre.value(0));
                                                haber = 0;
                                }
                                totalDebe += debe;
                                totalHaber += haber;

                                curPartida.setModeAccess(curPartida.Insert);
                                curPartida.refreshBuffer();
                                curPartida.setValueBuffer("concepto", util.translate("scripts", "Asiento de cierre de ejercicio ") +
                                                cursor.valueBuffer("nombre"));
                                curPartida.setValueBuffer("idsubcuenta", qryAsientoCierre.value(1));
                                curPartida.setValueBuffer("codsubcuenta", qryAsientoCierre.value(2));
                                curPartida.setValueBuffer("idasiento", idAsiento);
                                curPartida.setValueBuffer("debe", debe);
                                curPartida.setValueBuffer("haber", haber);
                                curPartida.setValueBuffer("coddivisa", this.iface.divisaEmpresa);
                                curPartida.setValueBuffer("tasaconv", 1);
                                curPartida.setValueBuffer("debeME", 0);
                                curPartida.setValueBuffer("haberME", 0);
                                util.setProgress(paso++);

                                if (!curPartida.commitBuffer()) {
                                                util.destroyProgressDialog();
                                                return false;
                                }
                }

                if (Math.round(parseFloat(totalDebe)) != Math.round(parseFloat(totalHaber))) {
                                MessageBox.critical(util.translate("scripts",
                                                "Asiento de cierre: los totales de debe y haber no coinciden\n" +
                                                "DEBE : " + Math.round(parseFloat(totalDebe)) + "  HABER : " + Math.round(parseFloat(totalHaber)) ),
                                                 MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
                                util.destroyProgressDialog();
                                return false;
                }
                curAsiento.select("idasiento = " + idAsiento);
                curAsiento.first();
                curAsiento.setModeAccess(curAsiento.Edit);
                curAsiento.refreshBuffer();
                curAsiento.setUnLock("editable", false);

                cursor.setValueBuffer("idasientocierre", idAsiento);
                util.destroyProgressDialog();
                return true;
}

/** \D
Genera el asiento de apertura del nuevo ejercicio

@param        idAsientoCierre ID del asiento de cierre del ejercicio antiguo
@param        ejNuevo Código del nuevo ejercicio
@return true en caso de éxito, false en caso contrario
\end */
function oficial_asientoApertura(idAsientoCierre, ejNuevo):Boolean
{
        var util:FLUtil = new FLUtil();

        if (ejNuevo == "")
                return false;

        if (!util.sqlSelect("co_subcuentas", "idsubcuenta", "codejercicio = '" + ejNuevo + "'"))
                return false;

        var curAsiento:FLSqlCursor = new FLSqlCursor("co_asientos");
        curAsiento.setForwardOnly(true);
        var fechaAsiento:String = util.sqlSelect("ejercicios", "fechainicio", "codejercicio = '" + ejNuevo + "'");
        var nombreEjercicio:String = util.sqlSelect("ejercicios", "nombre", "codejercicio = '" + ejNuevo + "'");

        curAsiento.setModeAccess(curAsiento.Insert);
        curAsiento.refreshBuffer();
        curAsiento.setValueBuffer("numero", 0);
        curAsiento.setValueBuffer("fecha", fechaAsiento);
        curAsiento.setValueBuffer("codejercicio", ejNuevo);

        if (!curAsiento.commitBuffer())
                return false;

        var idAsiento:Number = curAsiento.valueBuffer("idasiento");
        var qryCierre:FLSqlQuery = new FLSqlQuery();
        qryCierre.setForwardOnly(true);
        with (qryCierre) {
                setTablesList("co_partidas");
                setSelect("codsubcuenta, debe, haber, coddivisa, tasaconv, debeME, haberME");
                setFrom("co_partidas");
                setWhere("idasiento = " + idAsientoCierre);
        }
        if (!qryCierre.exec())
                return false;

        util.createProgressDialog( util.translate( "scripts", "Creando asiento de apertura..." ), qryCierre.size() );
        util.setProgress(1);

        var curApertura:FLSqlCursor = new FLSqlCursor("co_partidas");
        curApertura.setForwardOnly(true);
        var paso:Number = 0;
        var idSubcuentaAp:String;
        while (qryCierre.next()) {
                idSubcuentaAp = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + qryCierre.value("codsubcuenta") + "' AND codejercicio = '" + ejNuevo + "'");
                if (!idSubcuentaAp) {
                        util.destroyProgressDialog();
                        var res:Number = MessageBox.warning(util.translate("scripts", "No existe la subcuenta %1 en el ejercicio %2.\n¿Desea crearla?").arg(qryCierre.value("codsubcuenta")).arg(ejNuevo), MessageBox.Yes, MessageBox.Cancel);
                        if (res != MessageBox.Yes)
                                return false;
                        idSubcuentaAp = this.iface.crearSubcuentaApertura(qryCierre.value("codsubcuenta"), ejNuevo);
                        if (!idSubcuentaAp)
                                return false;
                }

                curApertura.setModeAccess(curApertura.Insert);
                curApertura.refreshBuffer();
                curApertura.setValueBuffer("concepto", util.translate("scripts", "Asiento de apertura de ejercicio ") + nombreEjercicio);
                curApertura.setValueBuffer("idsubcuenta", idSubcuentaAp);
                curApertura.setValueBuffer("codsubcuenta", qryCierre.value("codsubcuenta"));
                curApertura.setValueBuffer("idasiento", idAsiento);
                curApertura.setValueBuffer("debe", qryCierre.value("haber"));
                curApertura.setValueBuffer("haber", qryCierre.value("debe"));
                curApertura.setValueBuffer("coddivisa", qryCierre.value("coddivisa"));
                curApertura.setValueBuffer("tasaconv", qryCierre.value("tasaconv"));
                curApertura.setValueBuffer("debeME", qryCierre.value("haberME"));
                curApertura.setValueBuffer("haberME", qryCierre.value("debeME"));
                util.setProgress(paso++);

                if (!curApertura.commitBuffer()) {
                        util.destroyProgressDialog();
                        return false;
                }
        }

        if (!util.sqlUpdate("ejercicios", "idasientoapertura", idAsiento, "codejercicio = '" + ejNuevo + "'")) {
                util.destroyProgressDialog();
                return false;
        }

        curAsiento.select("idasiento = " + idAsiento);
        curAsiento.first();
        curAsiento.setModeAccess(curAsiento.Edit);
        curAsiento.refreshBuffer();
        curAsiento.setUnLock("editable", false);

        util.destroyProgressDialog();
        return true;
}

/** \C
Abre un cuadro de diálogo que permite seleccionar el ejercicio en el que se creará el asiento de apertura. Dicho ejercicio debe estar abierto y ser posterior al actual
\end */
function oficial_tbnEjercicio_clicked()
{
                var f:Object = new FLFormSearchDB("ejercicios");
                f.setMainWidget();
                f.cursor().setMainFilter("estado = 'ABIERTO'" +
                                " AND fechainicio > '" + this.cursor().valueBuffer("fechainicio") + "'");
                var codEjercicio:String = f.exec("codejercicio");
                if (codEjercicio) {
                                this.child("ledEjercicio").text = codEjercicio;
                }
}

/** \D Si se ha seleccionado el asiento de apertura, se comprueba que se ha seleccionado un ejercicio para ubicar dicho asiento y de que el mencionado ejercicio no tiene ya un asiento de apertura
@return true en caso de que el cierre sea posible, false en caso contrario
\end */
function oficial_validarCierre():Boolean
{
                var util:FLUtil = new FLUtil();

                if (this.child("ckbAsientoApertura").checked == true) {

                                if (this.child("ledEjercicio").text == "") {
                                                MessageBox.warning(util.translate("scripts",
                                                                "Debe seleccionar el ejercicio sobre el que se creará el asiento de apertura"),
                                                                MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
                                                return false;
                                }


                                var numAsientoApertura:Number = util.sqlSelect("ejercicios,co_asientos", "co_asientos.numero",
                                                "co_asientos.idasiento=ejercicios.idasientoapertura AND ejercicios.codejercicio = '" + this.child("ledEjercicio").text + "'");

                                if (numAsientoApertura) {
                                                MessageBox.warning(util.translate("scripts", "El ejercicio seleccionado tiene ya un asiento de apertura, borre el asiento o cambie el ejercicio.\nEl asiento de apertura para el ejercicio seleccionado es el número ") + numAsientoApertura,
                                                                MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
                                                return false;
                                }
                }
                return true;
}

/** \D Se revierte el proceso de cierre del ejercicio debido a algún fallo previo
\end */
function oficial_rollbackCierre()
{
        this.close();
        return;
                var cursor:FLSqlCursor = this.cursor();
                var codEjercicio:String = cursor.valueBuffer("codejercicio");
                cursor.setAskForCancelChanges(false);
                cursor.rollback();
                cursor.transaction(false);
                cursor.select("codejercicio = '" + codEjercicio + "'");
                cursor.first();
                cursor.setModeAccess(cursor.Edit);
                cursor.refreshBuffer();
}

function oficial_comprobarSaldos():Boolean
{
        var util:FLUtil = new FLUtil;

        var qrySaldos:FLSqlQuery = new FLSqlQuery;
        qrySaldos.setTablesList("co_subcuentas");
        qrySaldos.setSelect("idsubcuenta");
        qrySaldos.setFrom("co_subcuentas");
        qrySaldos.setWhere("codejercicio = '" + this.cursor().valueBuffer("codejercicio") + "'");
        try { qrySaldos.setForwardOnly( true ); } catch (e) {}
        if (!qrySaldos.exec())
                return false;

        util.createProgressDialog( util.translate( "scripts", "Revisando saldos" ), qrySaldos.size() );
        var progress:Number = 0;
        while (qrySaldos.next()) {
                util.setProgress(progress++);
                if (!flcontppal.iface.pub_calcularSaldo(qrySaldos.value(0))) {
                        util.destroyProgressDialog();
                        return false;
                }
        }
        util.destroyProgressDialog();
        return true;
}

/** \C Crea la subcuenta indicada en el ejercicio indicado
@param        codSubcuenta: Subcuenta a crear.
@param        ejNuevo: Ejercicio en el que se creará la subcuenta
@return        Id de la subcuenta creada o false si hay error
\end */
function oficial_crearSubcuentaApertura(codSubcuenta:String, ejNuevo:String):Number
{
        var util:FLUtil = new FLUtil;
        var cursor:FLSqlCursor = this.cursor();

        var codCuentaAnt:String = util.sqlSelect("co_subcuentas", "codcuenta", "codsubcuenta = '" + codSubcuenta + "' AND codejercicio = '" + cursor.valueBuffer("codejercicio") + "'");
        if (!codCuentaAnt)
                return false;

        var descripcion:String = util.sqlSelect("co_subcuentas", "descripcion", "codsubcuenta = '" + codSubcuenta + "' AND codejercicio = '" + cursor.valueBuffer("codejercicio") + "'");
        if (!descripcion)
                return false;

        var codDivisa:String = util.sqlSelect("co_subcuentas", "coddivisa", "codsubcuenta = '" + codSubcuenta + "' AND codejercicio = '" + cursor.valueBuffer("codejercicio") + "'");
        if (!codDivisa)
                return false;

        var idCuentaNueva:String = util.sqlSelect("co_cuentas", "idcuenta", "codcuenta = '" + codCuentaAnt + "' AND codejercicio = '" + ejNuevo + "'");
        if (!idCuentaNueva) {
                MessageBox.warning(util.translate("scripts", "Error al generar la subcuenta %1 para el ejercicio %2.\nNo existe la cuenta %3 asociada a la nueva subcuenta.").arg(codSubcuenta).arg(ejNuevo).arg(codCuentaAnt), MessageBox.Ok, MessageBox.NoButton);
                return false;
        }
        var curSubcuenta:FLSqlCursor = new FLSqlCursor("co_subcuentas");
        curSubcuenta.setForwardOnly(true);
        with (curSubcuenta) {
                setModeAccess(Insert);
                refreshBuffer();
                setValueBuffer("codsubcuenta", codSubcuenta);
                setValueBuffer("descripcion", descripcion);
                setValueBuffer("codcuenta", codCuentaAnt);
                setValueBuffer("idcuenta", idCuentaNueva);
                setValueBuffer("codejercicio", ejNuevo);
                setValueBuffer("coddivisa", codDivisa);
        }
        if (!curSubcuenta.commitBuffer())
                return false;

        return curSubcuenta.valueBuffer("idsubcuenta");
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////



