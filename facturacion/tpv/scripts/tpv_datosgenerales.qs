/***************************************************************************
                 tpv_datosgenerales.qs  -  description
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
	var ejercicioActual:String;
	var longSubcuenta:Number;
	var contabilidadCargada:Boolean;
	var posActualPuntoSubcuentaCaja:Number;
	var bloqueoSubcuentaCaja:Boolean;
	var posActualPuntoSubcuentaDifPos:Number;
	var bloqueoSubcuentaDifPos:Boolean;
	var posActualPuntoSubcuentaDifNeg:Number;
	var bloqueoSubcuentaDifNeg:Boolean;

	function oficial( context ) { interna( context ); }
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
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
	var f:Object = new FLFormSearchDB("tpv_datosgenerales");
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
		f.exec("nombre");
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

	if (cursor.isNull("integracionfac"))
		cursor.setValueBuffer("integracionfac", true);

	if (sys.isLoadedModule("flcontppal")) {
		this.iface.contabilidadCargada = true;
		this.iface.ejercicioActual = flfactppal.iface.pub_ejercicioActual();
		this.iface.longSubcuenta = util.sqlSelect("ejercicios", "longsubcuenta", "codejercicio = '" + this.iface.ejercicioActual + "'");
		this.iface.bloqueoSubcuentaCaja = false;
		this.iface.posActualPuntoSubcuentaCaja = -1;
		this.child("fdbIdSubcuentaCaja").setFilter("codejercicio = '" + this.iface.ejercicioActual + "'");
		this.iface.bloqueoSubcuentaDifPos = false;
		this.iface.posActualPuntoSubcuentaDifPos = -1;
		this.child("fdbIdSubcuentaDifPos").setFilter("codejercicio = '" + this.iface.ejercicioActual + "'");
		this.iface.bloqueoSubcuentaDifNeg = false;
		this.iface.posActualPuntoSubcuentaDifNeg = -1;
		this.child("fdbIdSubcuentaDifNeg").setFilter("codejercicio = '" + this.iface.ejercicioActual + "'");
	} else {
		this.child("tbwDatosGenerales").setTabEnabled("contabilidad", false);
	}

	connect (cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	
	this.iface.bufferChanged("integracionfac");
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
		case "integracionfac": {
			var msg:String;
			if (cursor.valueBuffer("integracionfac") == true || cursor.isNull("integracionfac")) {
				msg = util.translate("scripts", "Cada venta da lugar a una factura de cliente de forma inmediata.");
			} else {
				msg = util.translate("scripts", "Las facturas asociadas a las ventas se generan cuando se cierra el arqueo correspondiente. Esta opción no se aplica para ventas pendientes de pago o a cuenta.");
			}
			this.child("lblDesIntegracionFac").text = msg;
			break;
		}
		case "codsubcuentacaja": {
			if (!this.iface.bloqueoSubcuentaCaja) {
				this.iface.bloqueoSubcuentaCaja = true;
				this.iface.posActualPuntoSubcuentaCaja = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuentaCaja", this.iface.longSubcuenta, this.iface.posActualPuntoSubcuentaCaja);
				this.iface.bloqueoSubcuentaCaja = false;
			}
			break;
		}
		case "codsubcuentadifpos": {
			if (!this.iface.bloqueoSubcuentaDifPos) {
				this.iface.bloqueoSubcuentaDifPos = true;
				this.iface.posActualPuntoSubcuentaDifPos = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuentaDifPos", this.iface.longSubcuenta, this.iface.posActualPuntoSubcuentaDifPos);
				this.iface.bloqueoSubcuentaDifPos = false;
			}
			break;
		}
		case "codsubcuentadifneg": {
			if (!this.iface.bloqueoSubcuentaDifNeg) {
				this.iface.bloqueoSubcuentaDifNeg = true;
				this.iface.posActualPuntoSubcuentaDifNeg = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuentaDifNeg", this.iface.longSubcuenta, this.iface.posActualPuntoSubcuentaDifNeg);
				this.iface.bloqueoSubcuentaDifNeg = false;
			}
			break;
		}
	}
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
