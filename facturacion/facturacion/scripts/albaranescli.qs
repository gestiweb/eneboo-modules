/***************************************************************************
                 albaranescli.qs  -  description
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
////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

/** @class_declaration interna */
//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
class interna {
    var ctx:Object;
    function interna( context ) { this.ctx = context; }
    function init() { this.ctx.interna_init(); }
        function calculateField(fN:String):String { return this.ctx.interna_calculateField(fN); }
//         function recordDelBeforelineasalbaranescli() { return this.ctx.interna_recordDelBeforelineasalbaranescli(); }
        function validateForm():Boolean { return this.ctx.interna_validateForm(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    var bloqueoProvincia:Boolean;
        var pbnAplicarComision:Object;
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
        function mostrarTraza() {
                return this.ctx.oficial_mostrarTraza();
        }
        function aplicarComision_clicked() {
                return this.ctx.oficial_aplicarComision_clicked();
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
Este formulario realiza la gestion de los albaranes a clientes.

Los albaranes pueden ser generados de forma manual o a partir de uno o mas pedidos.
\end */
function interna_init()
{
        var util:FLUtil = new FLUtil();
        var cursor:FLSqlCursor = this.cursor();

        this.iface.bloqueoProvincia = false;
        this.iface.pbnAplicarComision = this.child("pbnAplicarComision");

    connect(this.iface.pbnAplicarComision, "clicked()", this, "iface.aplicarComision_clicked()");
        connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
        connect(this.child("tdbLineasAlbaranesCli").cursor(), "bufferCommited()", this, "iface.calcularTotales()");
        connect(this.child("tbnTraza"), "clicked()", this, "iface.mostrarTraza()");

        this.iface.pbnAplicarComision.setDisabled(true);

        if (cursor.modeAccess() == cursor.Insert) {
                this.child("fdbCodEjercicio").setValue(flfactppal.iface.pub_ejercicioActual());
                this.child("fdbCodDivisa").setValue(flfactppal.iface.pub_valorDefectoEmpresa("coddivisa"));
                this.child("fdbCodPago").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codpago"));
                this.child("fdbCodAlmacen").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codalmacen"));
                this.child("fdbCodSerie").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codserie"));
                this.child("fdbTasaConv").setValue(util.sqlSelect("divisas", "tasaconv","coddivisa = '" + this.child("fdbCodDivisa").value() + "'"));
        }
        if (cursor.modeAccess() == cursor.Edit)
                this.child("fdbCodSerie").setDisabled(true);

        if (!cursor.valueBuffer("porcomision"))
                this.child("fdbPorComision").setDisabled(true);

        this.iface.inicializarControles();
}

function interna_calculateField(fN:String):String
{
                return formalbaranescli.iface.pub_commonCalculateField(fN, this.cursor());
}

function interna_validateForm()
{
        var cursor:FLSqlCursor = this.cursor();

        if (!flfactppal.iface.pub_validarProvincia(cursor)) {
                return false;
        }

        var idAlbaran = cursor.valueBuffer("idalbaran");
        var codCliente = this.child("fdbCodCliente").value();
        if (!flfacturac.iface.pub_validarIvaRecargoCliente(codCliente, idAlbaran, "lineasalbaranescli", "idalbaran")) {
                return false;
        }
        return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_inicializarControles()
{
        this.child("lblRecFinanciero").setText(this.iface.calculateField("lblRecFinanciero"));
        this.child("lblComision").setText(this.iface.calculateField("lblComision"));
        this.iface.verificarHabilitaciones();
}

function oficial_calcularTotales()
{
        var util:FLUtil = new FLUtil;

        this.child("fdbNeto").setValue(this.iface.calculateField("neto"));
        this.child("fdbTotalIva").setValue(this.iface.calculateField("totaliva"));
        this.child("fdbTotalRecargo").setValue(this.iface.calculateField("totalrecargo"));
        this.child("fdbTotaIrpf").setValue(this.iface.calculateField("totalirpf"));
        this.child("lblComision").setText(this.iface.calculateField("lblComision"));
        this.iface.verificarHabilitaciones();
}

function oficial_bufferChanged(fN:String)
{
        var cursor:FLSqlCursor = this.cursor();
        var util:FLUtil = new FLUtil();
        switch (fN) {
                case "recfinanciero":
                case "neto": {
                        this.child("lblRecFinanciero").setText(this.iface.calculateField("lblRecFinanciero"));
                        this.child("fdbTotaIrpf").setValue(this.iface.calculateField("totalirpf"));
                }
                /** \C
                El --total-- es el --neto-- menos el --totalirpf-- mas el --totaliva-- mas el --totalrecargo-- mas el --recfinanciero--
                \end */
                case "totalrecargo":
                case "totalirpf":
                case "totaliva": {
                        this.child("fdbTotal").setValue(this.iface.calculateField("total"));
                        break;
                }
                /** \C
                El --totaleuros-- es el producto del --total-- por la --tasaconv--
                \end */
                case "total": {
                        this.child("fdbTotalEuros").setValue(this.iface.calculateField("totaleuros"));
                        this.child("lblComision").setText(this.iface.calculateField("lblComision"));
                        break;
                }
                case "tasaconv": {
                        this.child("fdbTotalEuros").setValue(this.iface.calculateField("totaleuros"));
                        break;
                }
                /** \C
                Al cambiar el --porcomision-- se mostrara el total de comision aplicada
                \end \end */
                case "porcomision": {
                        this.child("lblComision").setText(this.iface.calculateField("lblComision"));
                        break;
                }
                /** \C
                El valor de --coddir-- por defecto corresponde a la direccion del cliente marcada como direccion de facturacion
                \end */
                case "codcliente": {
                        this.child("fdbCodDir").setValue("0");
                        this.child("fdbCodDir").setValue(this.iface.calculateField("coddir"));
                        break;
                }
                /** \C
                El --irpf-- es el asociado a la --codserie-- del albaran
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
                case "provincia": {
                        if (!this.iface.bloqueoProvincia) {
                                this.iface.bloqueoProvincia = true;
                                flfactppal.iface.pub_obtenerProvincia(this);
                                this.iface.bloqueoProvincia = false;
                        }
                        break;
                }
                case "idprovincia": {
                        if (cursor.valueBuffer("idprovincia") == 0)
                                cursor.setNull("idprovincia");
                        break;
                }
                case "coddir": {
                        this.child("fdbProvincia").setValue(this.iface.calculateField("provincia"));
                        this.child("fdbCodPais").setValue(this.iface.calculateField("codpais"));
                        break;
                }
                case "codagente": {
                        this.iface.pbnAplicarComision.setDisabled(false);
                        break;
                }
        }
}

function oficial_verificarHabilitaciones()
{
        var util:FLUtil = new FLUtil();
        if (!util.sqlSelect("lineasalbaranescli", "idalbaran", "idalbaran = " + this.cursor().valueBuffer("idalbaran"))) {
                this.child("fdbCodAlmacen").setDisabled(false);
                this.child("fdbCodDivisa").setDisabled(false);
                this.child("fdbTasaConv").setDisabled(false);
        } else {
                this.child("fdbCodAlmacen").setDisabled(true);
                this.child("fdbCodDivisa").setDisabled(true);
                this.child("fdbTasaConv").setDisabled(true);
        }
}

function oficial_mostrarTraza()
{
        flfacturac.iface.pub_mostrarTraza(this.cursor().valueBuffer("codigo"), "albaranescli");
}

function oficial_aplicarComision_clicked()
{
        var util:FLUtil;

        var idAlbaran:Number = this.cursor().valueBuffer("idalbaran");
        if(!idAlbaran)
                return;
        var codAgente:String = this.cursor().valueBuffer("codagente");
        if(!codAgente || codAgente == "")
                return;

        var res:Number = MessageBox.information(util.translate("scripts", "¿Seguro que desea actualizar la comisión en todas las líneas?"), MessageBox.Yes, MessageBox.No);
        if(res != MessageBox.Yes)
                return;

        var cursor:FLSqlCursor = new FLSqlCursor("empresa");
        cursor.transaction(false);

        try {
                if(!flfacturac.iface.pub_aplicarComisionLineas(codAgente,"lineasalbaranescli","idalbaran = " + idAlbaran)) {
                        cursor.rollback();
                        return;
                }
                else {
                        cursor.commit();
                }
        } catch (e) {
                MessageBox.critical(util.translate("scripts", "Hubo un error al aplicarse la comisión en las líneas.\n%1").arg(e), MessageBox.Ok, MessageBox.NoButton);
                cursor.rollback();
                return false;
        }

        MessageBox.information(util.translate("scripts", "La comisión se actualizó correctamente."), MessageBox.Ok, MessageBox.NoButton);
        this.iface.pbnAplicarComision.setDisabled(true);
        this.child("tdbLineasAlbaranesCli").refresh();
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////


