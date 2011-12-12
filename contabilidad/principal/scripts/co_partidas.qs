/***************************************************************************
                 co_partidas.qs  -  description
                             -------------------
    begin                : jue jul 22 2004
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
	function validateForm():Boolean {
		return this.ctx.interna_validateForm();
	}
	function calculateField( fN:String ):String {
		return this.ctx.interna_calculateField( fN );
	}
	function acceptedForm() {
		this.ctx.interna_acceptedForm();
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var longSubcuenta:Number;
	var ejercicioActual:String;
	var divisaEmpresa:String;
	var idCuentaEsp:Number;
	var bloqueo:Boolean;
	var bloqueoSubcuenta:Boolean;
	var bloqueoInicio:Boolean;
	var permisoCP:Boolean;
	var esIVA:Boolean;
	var esDivisaExt:Boolean;
	var posActualPuntoSubcuenta:Number;
	var posActualPuntoContrapar:Number;
	
	function oficial( context ) { interna( context ); } 
	function cambioDHiva(debeOhaber) {
		return this.ctx.oficial_cambioDHiva(debeOhaber);
	}
	function habilitarIVA(siOno) {
		return this.ctx.oficial_habilitarIVA(siOno);
	}
	function desconexion() {
		return this.ctx.oficial_desconexion();
	}
	function bufferChanged(fN) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function controlDivisa() {
		return this.ctx.oficial_controlDivisa();
	}
	function controlIVA(noAnteriorDebeHaber) {
		return this.ctx.oficial_controlIVA(noAnteriorDebeHaber);
	}
	function obtenerIdAsiento():Number {
		return this.ctx.oficial_obtenerIdAsiento();
	}
	function anteriorDebeHaber() {
		return this.ctx.oficial_anteriorDebeHaber();
	}
	function valoresAcero() {
		return this.ctx.oficial_valoresAcero();
	}
	function descuadre() {
		return this.ctx.oficial_descuadre();
	}
	function conceptoAnterior() {
		return this.ctx.oficial_conceptoAnterior();
	}
	function controlContrapartida() {
		return this.ctx.oficial_controlContrapartida();
	}
	function controlCifNif() {
		return this.ctx.oficial_controlCifNif();
	}
	function datosPartidaPrevia():Boolean {
		return this.ctx.oficial_datosPartidaPrevia();
	}
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration modelo303 */
/////////////////////////////////////////////////////////////////
//// MODELO 303 /////////////////////////////////////////////////
class modelo303 extends oficial {
    function modelo303( context ) { oficial ( context ); }
	function habilitarIVA(siOno:String) {
		return this.ctx.modelo303_habilitarIVA(siOno);
	}
	function validateForm():Boolean {
		return this.ctx.modelo303_validateForm();
	}
}
//// MODELO 303 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends modelo303 {
    function head( context ) { modelo303 ( context ); }
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
/** \C
	En el debe o el haber aparece la cantidad necesaria para cuadrar el asiento automáticamente
	
	El concepto es copiado de la partida anterior del asiento actual, si es que existe
	
	Si la partida anterior, en caso de existir, tenía como contrapartida una subcuenta de IVA, 
	dicha subcuenta aparecerá como subcuenta asociada a la partida nueva, y los campos de IVA aparecerán
	informados con los datos correspondientes a la subcuenta de IVA: IVA y recargo de equivalencia. 
	
\end */
function interna_init()
{
	var util:FLUtil = new FLUtil(); 
	var cursor:FLSqlCursor = this.cursor();

	this.iface.ejercicioActual = flfactppal.iface.pub_ejercicioActual();
	this.iface.divisaEmpresa = util.sqlSelect("empresa", "coddivisa", "1 = 1");

	this.iface.longSubcuenta = util.sqlSelect("ejercicios", "longsubcuenta", "codejercicio = '" + this.iface.ejercicioActual + "'");
	this.iface.bloqueoSubcuenta = false;
	this.iface.posActualPuntoSubcuenta = -1;
	this.iface.posActualPuntoContrapar = -1;
	this.iface.idCuentaEsp = false;
	
	this.child("fdbIdSubcuenta").setFilter("codejercicio = '" + this.iface.ejercicioActual + "'");
	this.child("fdbIdContrapartida").setFilter("codejercicio = '" + this.iface.ejercicioActual + "'");
	this.child("fdbDesSubcuenta").setValue("");
	this.child("fdbDesContrapartida").setValue("");
	// Necesario para que los valores de Id sean correctos
	var aux:String = this.child("fdbCodSubcuenta").value();
/// Parcheado porque esto hace que datos como el IVA se actualicen solos al abrirse el formulario
	this.iface.bloqueoInicio = true;
	this.child("fdbCodSubcuenta").setValue("X");
	this.child("fdbCodSubcuenta").setValue(aux);
	this.iface.bloqueoInicio = false;
	aux = this.child("fdbCodContrapartida").value();
	this.child("fdbCodContrapartida").setValue("X");
	this.child("fdbCodContrapartida").setValue(aux);
	
	if (cursor.modeAccess() == cursor.Edit || cursor.modeAccess() == cursor.Browse) {
		this.child("gbIva").setDisabled(true);
		this.iface.controlIVA(true);
		if (parseFloat(this.cursor().valueBuffer("baseimponible")) != 0) {
			if (parseFloat(this.cursor().valueBuffer("debe")) != 0)
				this.child("chkDebe").setChecked(true);
			if (parseFloat(this.cursor().valueBuffer("haber")) != 0)
				this.child("chkHaber").setChecked(true);
		}
	}

	if (cursor.modeAccess() == cursor.Insert) {
		this.child("fdbCodDivisa").setValue(this.iface.divisaEmpresa);
		this.iface.habilitarIVA("no");
		this.iface.descuadre();
		this.iface.conceptoAnterior();
		this.iface.controlContrapartida();
		this.iface.controlIVA();
		this.iface.datosPartidaPrevia();
	}
	this.iface.controlDivisa();

	connect(this.child("btgDHiva"), "clicked(int)", this, "iface.cambioDHiva");
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this, "closed()", this, "iface.desconexion");
}

function interna_calculateField(fN):String
{
	var util:FLUtil = new FLUtil;
	var res;
	var cursor:FLSqlCursor = this.cursor();

	switch(fN) {
		case "debe": {
		/** \D Calcula el --debe-- en función de la base imponible si la partida es de IVA o de la tasa de conversion si la divisa es de moneda extranjera
		\end */
			if (this.iface.esIVA) {
				res = this.child("fdbBaseImponible").value() * this.child("fdbIva").value() / 100;
				break;
			}
			if (this.iface.esDivisaExt) {
				res = this.child("fdbDebeME").value() * this.child("fdbTasaConv").value();
			}
			break;
		}
		case "haber": {
		/** \D Calcula el --haber-- en función de la base imponible si la partida es de IVA o de la tasa de conversion si la divisa es de moneda extranjera
		\end */
			if (this.iface.esIVA) {
					res = this.child("fdbBaseImponible").value() * this.child("fdbIva").value() / 100;
					break;
			}
			if (this.iface.esDivisaExt) {
					res = this.child("fdbHaberME").value() * this.child("fdbTasaConv").value();
			}
			break;
		}
		case "baseimponible": {
		/** \D Calcula la --baseimponible-- en función del debe o del haber si la partida es de IVA
		\end */
			var valorDebeHaber:Number = 0;
			if (parseFloat(this.child("fdbIva").value()) != 0) {
					if (parseFloat(cursor.valueBuffer("debe")) != 0)
							valorDebeHaber = cursor.valueBuffer("debe");

					if (parseFloat(cursor.valueBuffer("haber")) != 0) 
							valorDebeHaber = cursor.valueBuffer("haber");

					res = 100 * valorDebeHaber / this.child("fdbIva").value();
			}
			break;
		}
		case "coddivisa": {
		/** \D Obtiene --coddivisa-- como divisa por defecto la asociada a la subcuenta de la partida
		\end */
			res = util.sqlSelect("co_subcuentas", "coddivisa", "idsubcuenta = " + cursor.valueBuffer("idsubcuenta"));
			if (!res) {
				res = this.iface.divisaEmpresa;
			}
			break;
		}
		/** \D Calcula el descuadre actual del asiento al que pertenece la partida
		\end */
		case "ledDescuadreActual": {
			var asiento:Number = this.iface.obtenerIdAsiento();
			var debe:Number = util.sqlSelect("co_partidas", "SUM(debe)", "idasiento = " + asiento);
			var haber:Number = util.sqlSelect("co_partidas", "SUM(haber)", "idasiento = " + asiento);
			res = debe - haber;
			break;
		}
		/** \D El --cifnif-- es el del cliente o proveedor asociado a la subcuenta de la contrapartida
		\end */
		case "cifnif": {
			var codSubcuenta:String = cursor.valueBuffer("codcontrapartida");
			if (codSubcuenta && codSubcuenta.length == this.iface.longSubcuenta) {
				res = util.sqlSelect("co_subcuentascli sc INNER JOIN clientes c ON sc.codcliente = c.codcliente", "c.cifnif", "sc.codsubcuenta = '" + codSubcuenta + "' AND sc.codejercicio = '" + this.iface.ejercicioActual + "'", "co_subcuentascli,clientes");
				if (!res)
					res = util.sqlSelect("co_subcuentasprov sp INNER JOIN proveedores p ON sp.codproveedor = p.codproveedor", "p.cifnif", "sp.codsubcuenta = '" + codSubcuenta  + "' AND sp.codejercicio = '" + this.iface.ejercicioActual + "'", "co_subcuentasprov,proveedores");
			}
			break;
		}
		case "iva": {
			res = util.sqlSelect("co_subcuentas", "iva", "idsubcuenta = " + cursor.valueBuffer("idsubcuenta"));
			break;
		}
	}

	return res;
}

function interna_acceptedForm()
{
	this.iface.desconexion();
}

/** \C La subcuenta establecida debe existir en la tabla de subcuentas
\end */
function interna_validateForm():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var codEjercicio:String = cursor.cursorRelation().valueBuffer("codejercicio");
	if (!util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + cursor.valueBuffer("codsubcuenta") + "' AND codejercicio = '" + codEjercicio + "'")) {
		this.child("fdbCodSubcuenta").setDisabled(false);
		this.child("fdbIdSubcuenta").setDisabled(false);
		MessageBox.warning(util.translate("scripts", "No existe la subcuenta %1 para el ejercicio %2").arg(cursor.valueBuffer("codsubcuenta")).arg(codEjercicio), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var codContrapartida:String = cursor.valueBuffer("codcontrapartida");
	if (codContrapartida) {
		if (!util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + codContrapartida + "' AND codejercicio = '" + codEjercicio + "'")) {
			this.child("fdbCodContrapartida").setDisabled(false);
			this.child("fdbIdContrapartida").setDisabled(false);
			MessageBox.warning(util.translate("scripts", "Contrapartida: No existe la subcuenta %1 para el ejercicio %2").arg(codContrapartida).arg(codEjercicio), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}

	if (this.iface.idCuentaEsp == "IVASOP" || this.iface.idCuentaEsp == "IVAREP") {
		if (!codContrapartida || codContrapartida == "") {
			var res:Number = MessageBox.warning(util.translate("scripts", "Ha establecido una partida de IVA pero no ha indicado la contrapartida (subcuenta de cliente / proveedor).\nEsto puede provocar que el asiento no aparezca en los listados de facturas emitidas/recibidas.\n¿Desea continuar?"), MessageBox.No, MessageBox.Yes);
			if (res != MessageBox.Yes) {
				return false;
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

function oficial_desconexion()
{
		disconnect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged");
		disconnect(this.child("btgDHiva"), "clicked(int)", this, "iface.cambioDHiva");
}

function oficial_bufferChanged(fN)
{
debug("Campo  = " + fN);
	var util:FLUtil = new FLUtil();
	if (this.iface.bloqueo) {
		return;
	}

	switch(fN) {
		case "codsubcuenta": {
		/** 
		\D
		Cuando alcanza el número de dígitos de la subcuenta, busca los datos asociados.
		\end 
		\C
		Al introducir --codsubcuenta--, si el usuario pulsa la tecla "punto" (.), la subcuenta se informa automaticamente con el código de cuenta más tantos ceros como sea necesario para completar la longitud de subcuenta asociada al ejercicio actual.
		\end 
		*/
			if (!this.iface.bloqueoSubcuenta) {
				this.iface.bloqueoSubcuenta = true;
				this.iface.posActualPuntoSubcuenta = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuenta", this.iface.longSubcuenta, this.iface.posActualPuntoSubcuenta);
				this.iface.bloqueoSubcuenta = false;
			}
			break;
		}
		case "idsubcuenta": {
		/** \C 
		Si --codsubcuenta-- es de IVA se realizan las siguientes acciones: [1] se pone como divisa la divisa local y se deshabilita el campo de divisa (sólo se admite la divisa local), [2] se habilitan los campos de iva, se busca la utima partida insertada en el asiento presente y de ella se extrae el debe o haber, que se utiliza para informar el campo de base imponible.
		Si --codsubcuenta-- tiene asociada una divisa diferente de la divisa local, se inhabilitan los campos debe y haber principales y se habilitan los campos debe y haber de la divisa.
		\end */
			if (this.child("fdbCodSubcuenta").value().length == this.iface.longSubcuenta) {
				var q:FLSqlQuery = new FLSqlQuery();
				q.setTablesList("co_subcuentas");
				q.setSelect("coddivisa, iva");
				q.setFrom("co_subcuentas");
				q.setWhere("codsubcuenta = '" + this.child("fdbCodSubcuenta").value() + 
					"' AND codejercicio = '" + this.iface.ejercicioActual + "'");
				q.exec();
				q.first();

				var divisaSubcuenta:String = q.value(0);
				var ivaSubcuenta:String = q.value(1);
				var idCuenta:Number = util.sqlSelect("co_subcuentas", "idcuenta",  "codsubcuenta = '" + this.child("fdbCodSubcuenta").value() +  "' AND codejercicio = '" + this.iface.ejercicioActual + "'");
				if (!idCuenta) {
					return;
				}

				if (divisaSubcuenta && divisaSubcuenta != this.iface.divisaEmpresa) {
					this.child("fdbCodDivisa").setValue(divisaSubcuenta);
					this.iface.esDivisaExt = true;
				} else {
					this.child("fdbCodDivisa").setValue(this.iface.divisaEmpresa);
					this.iface.esDivisaExt = false;
				}

				this.iface.idCuentaEsp = util.sqlSelect("co_cuentas", "idcuentaesp", "idcuenta= " + idCuenta);

				if (this.iface.idCuentaEsp == "IVASOP" || this.iface.idCuentaEsp == "IVAREP") {
					this.iface.esIVA = true;
					this.iface.bloqueo = false;
					this.child("fdbIva").setValue(ivaSubcuenta);
					this.iface.bloqueo = true;
					this.iface.anteriorDebeHaber();
					if (!this.iface.bloqueoInicio) {
						this.child("fdbIva").setValue(this.iface.calculateField("iva"));
					}
					this.iface.habilitarIVA("si");
				} else {
					this.iface.esIVA = false;
					this.iface.habilitarIVA("no");
				}
			}
			break;
		}
		case "debe": {
		/** \C 
		Al cambiar --debe--, se pone a cero --haber-- y, si --codsubcuenta-- es de IVA, se recalcula --baseimponible-- en función del valor de --iva--
		\end */
			if (!this.iface.bloqueo) {
				this.iface.bloqueo = true;
				if (parseFloat(this.child("fdbDebe").value()) != 0) this.child("fdbHaber").setValue(0);
				if (this.iface.esIVA && this.child("chkCalculoIvaAuto").checked) {
					this.child("fdbBaseImponible").setValue(this.iface.calculateField("baseimponible"));
					this.child("chkDebe").setChecked(true);
				}
				this.iface.bloqueo = false;
			}
			break;
		}
		case "haber": {
		/** \C 
		Al cambiar --haber--, se pone a cero --debe-- y, si --codsubcuenta-- es de IVA, se recalcula --baseimponible-- en función de --iva--
		\end */
			if (!this.iface.bloqueo) {
				this.iface.bloqueo = true;
				if (parseFloat(this.child("fdbHaber").value()) != 0) this.child("fdbDebe").setValue(0);
				if (this.iface.esIVA && this.child("chkCalculoIvaAuto").checked) {
					this.child("fdbBaseImponible").setValue(this.iface.calculateField("baseimponible"));
					this.child("chkHaber").setChecked(true);
				}
				this.iface.bloqueo = false;
			}
			break;
		}
		case "baseimponible":
		case "iva": {
		/** \C 
		El --debe-- o el --haber-- se calculan en función del --iva-- y la --baseimponible--. Cambia aquél de ellos que no sea igual a cero. Si ambos son iguales a cero cambia el que corresponde al checkbox (debe/haber) del --iva--
		\end */
			if (!this.iface.bloqueo && this.child("chkCalculoIvaAuto").checked) {
				var niDebeNiHaber:Boolean = true;
				this.iface.bloqueo = true;

				if (parseFloat(this.child("fdbDebe").value()) != 0) {
					this.child("fdbDebe").setValue(this.iface.calculateField("debe"));
					niDebeNiHaber = false;
				}

				if (parseFloat(this.child("fdbHaber").value()) != 0) {
					this.child("fdbHaber").setValue(this.iface.calculateField("haber"));
					niDebeNiHaber = false;
				}

				if (niDebeNiHaber) {
					if (this.child("chkDebe").checked) {
						this.child("fdbDebe").setValue(this.iface.calculateField("debe"));
					} else {
						this.child("chkHaber").setChecked(true);
						this.child("fdbHaber").setValue(this.iface.calculateField("haber"));
					}
				}
				this.iface.bloqueo = false;
			}
			break;
		}
		case "codcontrapartida": {
		/** \C 
		Al introducir --codcontrapartida--, se rellena con ceros el código de subcuenta de la contrapartida cuando el último carácter del código es un punto, al igual que en el código de subcuenta
		\end */
			if (!this.iface.bloqueoSubcuenta) {
				this.iface.bloqueoSubcuenta = true;
				this.iface.posActualPuntoContrapar = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodContrapartida", this.iface.longSubcuenta, this.iface.posActualPuntoContrapar);
				this.child("fdbCifNif").setValue(this.iface.calculateField("cifnif"));
				this.iface.bloqueoSubcuenta = false;
			}
			break;
		}
		case "coddivisa": {
		/** \C
		Al cambiar --coddivisa-- se pone a cero --debe-- y --haber--. Si la moneda no es la del sistema, habilita el cuadro Moneda extranjera y deshabilita los campos Debe / Haber
		\end */
			this.iface.valoresAcero();
			this.iface.controlDivisa();
			this.iface.bloqueo = true;	
			this.child("fdbDebe").setValue(this.iface.calculateField("debe"));
			this.child("fdbHaber").setValue(this.iface.calculateField("haber"));
			this.iface.bloqueo = false;
			break;
		}
		case "debeme": {
			if (!this.iface.bloqueo) {
				this.iface.bloqueo = true;
				if (parseFloat(this.child("fdbDebeME").value()) != 0) {
					this.child("fdbHaberME").setValue(0);
					this.child("fdbHaber").setValue(0);
					this.child("fdbDebe").setValue(this.iface.calculateField("debe"));
				}
				this.iface.bloqueo = false;
			}
			break;
		}
		case "haberme": {
		/** \C
		Trabajando con moneda extranjera, el --debe-- se calcula en moneda local a partir del --debeme-- extranjera y la tasa de conversión. Lo mismo para el --debeme--
		\end */
			if (!this.iface.bloqueo) {
				this.iface.bloqueo = true;
				if (parseFloat(this.child("fdbHaberME").value()) != 0) {
					this.child("fdbDebeME").setValue(0);
					this.child("fdbDebe").setValue(0);
					this.child("fdbHaber").setValue(this.iface.calculateField("haber"));
				}
				this.iface.bloqueo = false;
			}
			break;
		}
		case "tasaconv": {
		/** \C
		Al cambiar la --tasaconv-- se recalculan el --debe-- y --haber-- a partir del --debeme-- o --haberme-- y la --tasaconv--
		\end */
			this.iface.bloqueo = true;
			if (parseFloat(this.child("fdbHaberME").value()) != 0)  {
				this.child("fdbHaber").setValue(this.iface.calculateField("haber"));
			}
			if (parseFloat(this.child("fdbDebeME").value()) != 0) {
				this.child("fdbDebe").setValue(this.iface.calculateField("debe"));
			}
			this.iface.bloqueo = false;
			break;
		}
	}
}

/** \D Se comprueba la divisa que está establecida y se compara con la divisa local. Si son iguales se inhabilitan y limpian los campos de debe y haber para divisa extranjera. Si son distintas se inhabilitan los campos debe y haber, que serán calculados según la tasa de conversión y los valores del debe y haber de divisa extranjera.
\end */
function oficial_controlDivisa()
{
	var cursor:FLSqlCursor = this.cursor();
	if (this.child("fdbCodDivisa").value() == this.iface.divisaEmpresa) {
		this.iface.esDivisaExt = false;

		if (cursor.modeAccess() != cursor.Browse) {
			this.child("fdbHaber").setDisabled(false);
			this.child("fdbDebe").setDisabled(false);
		}

		this.child("fdbHaberME").setDisabled(true);
		this.child("fdbDebeME").setDisabled(true);
		this.child("fdbTasaConv").setDisabled(true);

		this.iface.bloqueo = true;	
		this.child("fdbHaberME").setValue(0);
		this.child("fdbDebeME").setValue(0);
		this.iface.bloqueo = false;
	} else {
		this.iface.esDivisaExt = true;

		if (cursor.modeAccess() != cursor.Browse) {
			this.child("fdbHaberME").setDisabled(false);
			this.child("fdbDebeME").setDisabled(false);
			this.child("fdbTasaConv").setDisabled(false);
		}

		this.child("fdbHaber").setDisabled(true);
		this.child("fdbDebe").setDisabled(true);
		this.iface.bloqueo = true;	
		this.child("fdbHaber").setValue(this.iface.calculateField("haber"));
		this.child("fdbDebe").setValue(this.iface.calculateField("debe"));
		this.iface.bloqueo = false;
	}
}

/** \D Se comprueba si la cuenta de la que depende la subcuenta de la partida es una cuenta especial de iva soportado o repercutido. Si lo es, se habilita el marco I.V.A., si no lo es se inhabilita.

@param noAnteriorDebeHaber Indica si se calcula el anterior debe/haber
\end */
function oficial_controlIVA(noAnteriorDebeHaber)
{
		var qryIVA:FLSqlQuery = new FLSqlQuery();
		qryIVA.setTablesList("co_cuentas,co_subcuentas");
		qryIVA.setSelect("c.idcuentaesp, s.iva");
		qryIVA.setFrom("co_cuentas c INNER JOIN co_subcuentas s" + 
				" ON c.idcuenta = s.idcuenta");
		qryIVA.setWhere("s.idsubcuenta = " + this.cursor().valueBuffer("idsubcuenta"));

		if (!qryIVA.exec())
				return;

		if (!qryIVA.first())
				return;

		var idCuentaEsp:String = qryIVA.value(0);
		if (idCuentaEsp == "IVASOP" || idCuentaEsp == "IVAREP") {
				this.iface.esIVA = true;
/// Quitado porque si no , cada vez que se abre la partida el IVA se resetea al valor de la subcuenta
// 				this.iface.bloqueo = true;
// 				this.child("fdbIva").setValue(qryIVA.value(1));
// 				this.iface.bloqueo = true;
				if (!noAnteriorDebeHaber) this.iface.anteriorDebeHaber();
				this.iface.habilitarIVA("si");
		} else {
				this.iface.esIVA = false;
				this.iface.habilitarIVA("no");
		}
}

/** \D Devuelve el identificador del asiento al que pertenece la partida
\end */
function oficial_obtenerIdAsiento():Number
{
		var util:FLUtil = new FLUtil();
		var res:Number = util.sqlSelect("co_asientos", "idasiento", 
				"numero = " + this.child("fdbAsiento").value());
		res = this.cursor().valueBuffer("idAsiento");
		return res;
}

/** \D Obtiene el valor del debe o haber (aquel de ellos que sea distinto de cero) de la partida inmediatamente anterior a la presente, dentro del mismo asiento. Este valor será usado como base imponible si la partida actual es de IVA
\end */
function oficial_anteriorDebeHaber()
{
		var q:FLSqlQuery = new FLSqlQuery();
		var partidaActual:Number = this.cursor().valueBuffer("idpartida");
		
		q.setTablesList("co_asientos,co_partidas");
		q.setSelect("co_partidas.debe, co_partidas.haber, co_partidas.codsubcuenta");
		q.setFrom("co_asientos INNER JOIN co_partidas" +
				" ON co_asientos.idasiento = co_partidas.idasiento");
		q.setWhere("co_asientos.idasiento = " + this.iface.obtenerIdAsiento() + " AND co_partidas.idpartida < " + partidaActual + " ORDER BY idpartida DESC");
		if (!q.exec())
				return;
	
		if (q.first()) {
		
				var anteriorDebe:Number = q.value(0);
				var anteriorHaber:Number = q.value(1);
				var anteriorCodSubcuenta:Number = q.value(2);

				if (parseFloat(anteriorDebe) != 0) {
						this.iface.bloqueo = true;
						this.child("fdbBaseImponible").setValue(anteriorDebe);
						this.child("fdbDebe").setValue(this.iface.calculateField("debe"));
						this.child("fdbHaber").setValue(0);
						this.child("chkDebe").setChecked("true");
						this.iface.bloqueo = false;
				} 

				if (parseFloat(anteriorHaber) != 0) {
						this.iface.bloqueo = true;
						this.child("fdbBaseImponible").setValue(anteriorHaber);
						this.child("fdbHaber").setValue(this.iface.calculateField("haber"));
						this.child("fdbDebe").setValue(0);
						this.child("chkHaber").setChecked("true");
						this.iface.bloqueo = false;
				}
				
		}
		delete q;
}

/*D	Pone a cero todos los valores debe y haber (también los de divisa)
\end */
function oficial_valoresAcero() 
{
		this.iface.bloqueo = true;	
		this.child("fdbHaber").setValue(0);
		this.child("fdbDebe").setValue(0);
		this.child("fdbHaberME").setValue(0);
		this.child("fdbDebeME").setValue(0);
		this.iface.bloqueo = false;
}

/** \D Pone el descuadre actual del asiento, antes de la partida actual en el campo descuadre. Establece el debe o haber (debe si el descuadre es negativo, haber si es positivo) de la partida actual al valor del descuadre, para facilitar el cierre del asiento. 
\end */
function oficial_descuadre() 
{
		var descuadreActual:Number = this.iface.calculateField("ledDescuadreActual");
		this.child("ledDescuadreActual").text = descuadreActual;
		
		this.iface.bloqueo = true;	
		if (parseFloat(descuadreActual) > 0) this.child("fdbHaber").setValue(descuadreActual);
		if (parseFloat(descuadreActual) < 0) this.child("fdbDebe").setValue(0 - descuadreActual);		
		this.iface.bloqueo = false;
}

/*D Habilita los controles de IVA o los inhabilita y pone a cero.

@param	siOno Toma los valores 'si' para habilitar o 'no' para deshabilitar las opciones de I.V.A.
\end */
function oficial_habilitarIVA(siOno)
{
	if(this.iface.bloqueoInicio)
		return;

	switch(siOno) {

		case "si":
		
			this.child("gbIva").setDisabled(false);
			this.iface.bloqueo = true;
			this.child("fdbDebeME").setValue(0);
			this.child("fdbHaberME").setValue(0);
			this.iface.bloqueo = false;
			this.child("fdbCodDivisa").setValue(this.iface.divisaEmpresa);
			
			break;
				
		case "no":
			this.child("gbIva").setDisabled(true);
			this.iface.bloqueo = true;
			this.child("fdbBaseImponible").setValue(0);
			this.iface.bloqueo = false;

			break;
	}
}


/** \D Intercambia los valores de --debe-- y --haber-- en una partida de IVA

@param debeOhaber Es el valor que devuelve el cuadro de botones de radio del formulario: 1 para el debe y 2 para el haber
\end */
function oficial_cambioDHiva(debeOhaber)
{
		switch(debeOhaber) {

 				case 1: //debe
						if (parseFloat(this.child("fdbDebe").value()) != 0) return;
						break;

				case 2: //haber
						if (parseFloat(this.child("fdbHaber").value()) != 0) return;
						break;
		}

		this.iface.bloqueo = true;		
		var bufferDH:Boolean = this.child("fdbDebe").value();
		this.child("fdbDebe").setValue(this.child("fdbHaber").value());
		this.child("fdbHaber").setValue(bufferDH);
		this.iface.bloqueo = false;
}

/** \D El concepto por defecto de la partida será el de la partida anterior del mismo asiento
\end */
function oficial_conceptoAnterior()
{
		var cursor:FLSqlCursor = this.cursor();
		var datosConcepto:Array = flcontppal.iface.pub_ejecutarQry("co_partidas", "concepto,idconcepto",
				"idasiento = " + cursor.valueBuffer("idasiento") + 
				" ORDER BY idpartida DESC");
		if (datosConcepto.result ==  1) {
				this.child("fdbIdConcepto").setValue(datosConcepto.idconcepto);
				this.child("fdbConcepto").setValue(datosConcepto.concepto);
		}
}

/** \D Comprueba si la partida anterior era de IVA y en tal caso pone la subcuenta de la 
partida actual como la contrapartida de la subcuenta anterior
\end */
function oficial_controlContrapartida() {
		var q:FLSqlQuery = new FLSqlQuery();
		var partidaActual:Number = this.cursor().valueBuffer("idpartida");
		
		q.setTablesList("co_asientos,co_partidas,co_subcuentas,co_cuentas,co_cuentasesp");		
		q.setSelect("co_partidas.codcontrapartida");
		q.setFrom("co_asientos INNER JOIN co_partidas ON co_asientos.idasiento = co_partidas.idasiento");						
		q.setWhere("co_asientos.idasiento = " + this.iface.obtenerIdAsiento() + " AND co_partidas.idpartida < " + partidaActual + " ORDER BY idpartida DESC");
		
		if (!q.exec())
				return;
	
		if (q.first()) {
		
				var anteriorCodContrapartida:String = q.value(0);
				if (anteriorCodContrapartida != "")
	 					this.child("fdbCodSubcuenta").setValue(anteriorCodContrapartida);		
		}
		delete q;
}

/** \D Comprueba si la contrapartida corresponde a un cliente o proveedor y busca el CIF/NIF correspondiente
\end */
function oficial_controlCifNif()
{
		var idContrapartida:Number = this.cursor().valueBuffer("idcontrapartida");
		if (!idContrapartida)
			return;
		var idCuentaespCP:Number;
		
		var qCP:FLSqlQuery = new FLSqlQuery();
		
		qCP.setTablesList("co_cuentas,co_subcuentas");
		qCP.setSelect("c.idcuentaesp");
		qCP.setFrom("co_cuentas c INNER JOIN co_subcuentas s ON c.idcuenta = s.idcuenta");
		qCP.setWhere("s.idsubcuenta = " + idContrapartida);
				
		if (!qCP.exec()) return;
		if (qCP.first()) idCuentaespCP = qCP.value(0);
		
		var tablaNIF:String;
		switch(idCuentaespCP) {
				case "CLIENT":
						tablaNIF = "clientes";
						break;
		
				case "PROVEE":
						tablaNIF = "proveedores";
						break;
		
				default:
						return;
						break;
		}
		
		var qNIF:FLSqlQuery = new FLSqlQuery();
		qNIF.setTablesList(tablaNIF);
		qNIF.setSelect("cifnif");
		qNIF.setFrom(tablaNIF);
		qNIF.setWhere("codsubcuenta = '" + this.child("fdbCodContrapartida").value() + "'");

		if (!qNIF.exec()) return;				
		if (qNIF.first()) this.child("fdbCifNif").setValue(qNIF.value(0));
}

/** Copia los datos de concepto y documento de la partida anterior, si existe
@return	true si la copia es correcta, false en caso contrario
\end */
function oficial_datosPartidaPrevia():Boolean
{
	var cursor:FLSqlCursor = this.cursor();
	var qryPartidas:FLSqlQuery = new FLSqlQuery;
	qryPartidas.setTablesList("co_partidas");
	qryPartidas.setSelect("concepto, idconcepto, documento, tipodocumento");
	qryPartidas.setFrom("co_partidas");
	qryPartidas.setWhere("idasiento = " + cursor.valueBuffer("idasiento") + " AND idpartida <> " + cursor.valueBuffer("idpartida") + " ORDER BY idpartida DESC");
	if (!qryPartidas.exec())
		return false;
	if (!qryPartidas.first())
		return true;

	this.child("fdbIdConcepto").setValue(qryPartidas.value("idconcepto"));
	this.child("fdbConcepto").setValue(qryPartidas.value("concepto"));
	this.child("fdbDocumento").setValue(qryPartidas.value("documento"));
	cursor.setValueBuffer("tipodocumento", qryPartidas.value("tipodocumento"));

	return true;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition modelo303 */
/////////////////////////////////////////////////////////////////
//// MODELO 303 /////////////////////////////////////////////////
function modelo303_habilitarIVA(siOno)
{
debug("modelo303_habilitarIVA " + siOno);
	this.iface.__habilitarIVA(siOno);

	var util:FLUtil;

	switch(siOno) {
		case "si": {
			this.child("tbwPartida").setTabEnabled("modelo303", true);
			break;
		}
		case "no": {
			this.child("tbwPartida").setTabEnabled("modelo303", false);
			this.child("fdbCasilla303").setValue("");
			break;
		}
	}
}

function modelo303_validateForm():Boolean
{
	if (!this.iface.__validateForm()) {
		return false;
	}
	
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var casilla303:String = cursor.valueBuffer("casilla303");
	if (this.iface.idCuentaEsp == "IVASOP" || this.iface.idCuentaEsp == "IVAREP") {
		if (!casilla303 || casilla303 == "") {
			var res:Number = MessageBox.warning(util.translate("scripts", "Ha introducido una partida de IVA.¿Desea indicar la casilla asociada al modelo 303?"), MessageBox.Yes, MessageBox.No);
			if (res == MessageBox.Yes) {
				return false;
			}
		}
	}
	return true;
}

//// MODELO 303 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////