/***************************************************************************
                 factteso_general.qs  -  description
                             -------------------
    begin                : mie nov 23 2005
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
	function main() {
		this.ctx.interna_main();
	}
	function init() {
		this.ctx.interna_init();
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	function oficial( context ) { interna( context ); }
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
    function tbnCalcularDatosCuenta_clicked() {
        return this.ctx.oficial_tbnCalcularDatosCuenta_clicked();
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
/**
\C Los datos generales son únicos, por tanto formulario de no presenta los botones de navegación por registros.
\end

\D La gestión del formulario se hace de forma manual mediante el objeto f (FLFormSearchDB)
\end
\end */
function interna_main()
{
	var f:Object = new FLFormSearchDB("factteso_general");
	var cursor:FLSqlCursor = f.cursor();

	cursor.select();
	if (!cursor.first())
		cursor.setModeAccess(cursor.Insert);
	else
		cursor.setModeAccess(cursor.Edit);

	f.setMainWidget();
	if (cursor.modeAccess() == cursor.Insert)
		f.child("pushButtonCancel").setDisabled(true);
	cursor.refreshBuffer();
	var commitOk:Boolean = false;
	var acpt:Boolean;
	cursor.transaction(false);
	while (!commitOk) {
		acpt = false;
		f.exec("id");
		acpt = f.accepted();
		if (!acpt) {
			if (cursor.rollback())
				commitOk = true;
		} else {
			if (cursor.commitBuffer()) {
				cursor.commit();
				commitOk = true;
			}
		}
		f.close();
	}
}

function interna_init()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	connect (cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
    connect (this.child("tbnCalcularDatosCuenta"), "clicked()", this, "iface.tbnCalcularDatosCuenta_clicked");
	
	this.iface.bufferChanged("pagoindirecto");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_bufferChanged(fN:String)
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	switch (fN) {
		case "pagoindirecto": {
			var msg:String;
			if (cursor.valueBuffer("pagoindirecto") == true) {
				msg = util.translate("scripts", "Al incluir un recibo de cliente en una remesa, el correspondiente asiento de pago se asigna a la subcuenta de Efectos comerciales de gestión de cobro (E.C.G.C.) asociada a la cuenta bancaria de la remesa. Cuando se recibe la confirmación del banco el usuario inserta un registro de pago para la remesa completa, que lleva las partidas de E.C.G.C. a la subcuenta de la cuenta bancaria.");
			} else {
				msg = util.translate("scripts", "Al incluir un recibo de cliente en una remesa, el correspondiente asiento de pago se asigna directamente a la subcuenta de la cuenta bancaria indicada en la remesa.");
			}
			this.child("lblDesPagoIndirecto").text = msg;
			break;
		}
	}
}

function oficial_tbnCalcularDatosCuenta_clicked()
{
    var util:FLUtil;
    var _i = this.iface;
    
    var res = MessageBox.information(util.translate("scripts", "Se van a calcular los dígitos de control, los códigos de cuenta, y el IBAN de todas las cuentas de empresa, clientes, y proveedores.\n¿Quieres continuar?\n\nNota: si el código de país en la cuenta está vacío, se supondrá que es de España.\nSi tiene cuentas de otros países debe revisarlas antes e informar su correspondiente código de país"), MessageBox.Yes, MessageBox.No);
    if (res != MessageBox.Yes) {
        return;
    }
    
    var aTablas = ["cuentasbanco","cuentasbcocli","cuentasbcopro"];
    
    for(var i = 0; i < aTablas.length; i++) {
        var paso = 0;
        
        var curCuentas = new FLSqlCursor(aTablas[i]);
        curCuentas.select();
        
        var codCuenta = curCuentas.valueBuffer("codcuenta");
        var totalPasos = curCuentas.size();
        
        if(totalPasos == 0) {
            continue;
        }
        
        var nombresTabla = [util.translate("scripts", "cuentas de empresa"), util.translate("scripts", "cuentas de empresa"), util.translate("scripts", "cuentas de empresa")];
        
        //AQUtil.createProgressDialog(sys.translate("Calculando datos de IBAN en las %1...").arg(nombresTabla[i]), totalPasos);
        util.createProgressDialog(util.translate("scripts", "Calculando datos de IBAN en las %1...").arg(nombresTabla[i]), totalPasos);
        util.setProgress(0);
        
        while(curCuentas.next()) {
            curCuentas.setModeAccess(curCuentas.Edit);
            curCuentas.refreshBuffer();
            if (curCuentas.isNull("codpais") || util.sqlSelect("paises", "codiso", "codpais = '" + curCuentas.valueBuffer("codpais") + "'") == "ES") {
                if (curCuentas.isNull("codpais")) {
                    curCuentas.setValueBuffer("codpais", util.sqlSelect("paises", "codpais", "codiso = 'ES'"));
                }
                curCuentas.setValueBuffer("ctadc", formRecordcuentasbanco.iface.pub_commonCalculateField("ctadc", curCuentas));
                curCuentas.setValueBuffer("codigocuenta", formRecordcuentasbanco.iface.pub_commonCalculateField("codigocuenta_es", curCuentas));
            }
            curCuentas.setValueBuffer("iban", formRecordcuentasbanco.iface.pub_commonCalculateField("iban", curCuentas));
            
            
            if (!curCuentas.commitBuffer()) {
                MessageBox.warning(util.translate("scripts", "Error en el cálculo de los datos de la cuenta %1 en %2").arg(codCuenta).arg(nombresTabla[i]), MessageBox.Ok, MessageBox.NoButton);
                return;
            }
            
            //AQUtil.setProgress(++paso);
            util.setProgress(++paso);
            
        } 
        
        //AQUtil.destroyProgressDialog();
        util.destroyProgressDialog();
    }
    
    MessageBox.information(sys.translate("Los datos de las cuentas han sido recalculados con éxito."), MessageBox.Ok, MessageBox.NoButton);
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
