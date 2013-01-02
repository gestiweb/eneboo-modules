/***************************************************************************
                 co_partidaspre.qs  -  description
                             -------------------
    begin                : jue jul 28 2004
    copyright            : (C) 2004 by InfoSiAL S.L. y Guillermo Molleda Jimena
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
	function calculateField( fN:String ):String { return this.ctx.interna_calculateField( fN ); }
	function validateForm():Boolean { return this.ctx.interna_validateForm(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var datoMemoriaS:String;
	var datoMemoriaDH:String;
	var datoMemoriaC:String;
	var datoMemoriaSC:String;
	var datoMemoriaBI:String;
	var longSubcuenta:Number;
	var ejercicioActual:String;
	var divisaEmpresa:String;
	var idCuentaEsp:String;
	var esIVA:Boolean;
	var esDivisaExt:Boolean;
	var bloqueo:Boolean;
	var bloqueoSubcuenta:Boolean;
	var posActualPuntoSubcuenta:Number;
	var posActualPuntoContrapar:Number;
	function oficial( context ) { interna( context ); } 
	function desconexion() {
		return this.ctx.oficial_desconexion( );
	}
	function bufferChanged( fN ) {
		return this.ctx.oficial_bufferChanged( fN );
	}
	function controlDivisa() {
		return this.ctx.oficial_controlDivisa();
	}
	function descuadre() {
		return this.ctx.oficial_descuadre( );
	}
	function controlIVA(noAnteriorDebeHaber) {
		return this.ctx.oficial_controlIVA(noAnteriorDebeHaber);
	}
	function habilitarIVA(siOno) {
		return this.ctx.oficial_habilitarIVA(siOno);
	}
	function establecerPaso() {
		return this.ctx.oficial_establecerPaso( );
	}
	function calculadoraM( entrada ):String {
		return this.ctx.oficial_calculadoraM( entrada );
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
function interna_init()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	this.iface.datoMemoriaS = "";		
	this.iface.datoMemoriaDH = "";		
	this.iface.datoMemoriaC = "";		
	this.iface.datoMemoriaSC = "";
	this.iface.datoMemoriaBI = "";
	this.iface.esDivisaExt = false;
	this.iface.ejercicioActual = flfactppal.iface.pub_ejercicioActual();
	this.iface.divisaEmpresa = util.sqlSelect("empresa", "coddivisa", "1 = 1");
	this.iface.longSubcuenta = util.sqlSelect("ejercicios", "longsubcuenta",  "codejercicio = '" + this.iface.ejercicioActual + "'");
	this.iface.posActualPuntoSubcuenta = -1;
	this.iface.posActualPuntoContrapar = -1;
	this.iface.bloqueoSubcuenta = false;
	
	this.child("fdbIdSubcuenta").setFilter("codejercicio = '" + this.iface.ejercicioActual + "'");
	this.child("fdbIdContrapartida").setFilter("codejercicio = '" + this.iface.ejercicioActual + "'");
	this.child("fdbDesSubcuenta").setValue("");
	this.child("fdbDesContrapartida").setValue("");
	/** \C En modo inserción la contrapartida queda vacía y la divisa toma el valor de divisa por defecto de la empresa
	\end */
	if (cursor.modeAccess() == cursor.Insert) {
		this.child("fdbIdContrapartida").setValue("");
		this.child("fdbCodDivisa").setValue(this.iface.divisaEmpresa);
		this.iface.descuadre();
		this.iface.habilitarIVA("no");
		this.iface.establecerPaso();
		this.iface.controlIVA(true);
	}
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(form, "closed()", this, "iface.desconexion");
}

function interna_validateForm():Boolean
{
	var util:FLUtil = new FLUtil();
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

	var idACuadrar:Number = -1;
	var cuadraDivisa:Boolean = false;
	var descuadreActual:Number;
	var curPartidas:FLSqlCursor = new FLSqlCursor("co_partidas");
	curPartidas.select("idasiento = " + cursor.valueBuffer("idasiento"));
	var numPaso:Number = curPartidas.size();
	var valorFinal:String;
	var contador:Number;
	var tipoImporte:String;
	var miVar:FLVar = new FLVar();
	var tipoPredefinido:String = miVar.get("TIPOPRE");
	var curPlanPartidas:FLSqlCursor = new FLSqlCursor("co_planpartidas");
	curPlanPartidas.select("codplanasiento = '" + tipoPredefinido + "' ORDER BY numorden");
	var totalPrepartidas:Number = curPlanPartidas.size();

	if ( numPaso == totalPrepartidas - 1 ) {
		curPartidas = new FLSqlCursor("co_partidas");
		curPartidas.select("idasiento = " + cursor.valueBuffer("idasiento") + " ORDER BY idpartida");
		curPlanPartidas = new FLSqlCursor("co_planpartidas");
		curPlanPartidas.select("codplanasiento = '" + tipoPredefinido + "' ORDER BY numorden");
		for ( contador = 0; contador < totalPrepartidas; contador++) {
			curPartidas.next();
			curPlanPartidas.next();
			curPlanPartidas.setModeAccess(curPlanPartidas.Browse);
			curPlanPartidas.refreshBuffer();
			if (curPlanPartidas.valueBuffer("coddivisa") != this.iface.divisaEmpresa) {
				tipoImporte = curPlanPartidas.valueBuffer("timporteme");
				valorFinal = curPlanPartidas.valueBuffer("importeme");
				this.iface.esDivisaExt = true;
			}
			else {
				tipoImporte = curPlanPartidas.valueBuffer("timporte");
				valorFinal = curPlanPartidas.valueBuffer("importe");
				this.iface.esDivisaExt = false;
			}
			if ( tipoImporte == "Cuadrar" ) {
				idACuadrar = contador;
				cuadraDivisa = this.iface.esDivisaExt;
				if ( contador == totalPrepartidas-1 ) {
					this.child("fdbDebe").setValue(0);
					this.child("fdbHaber").setValue(0);
					if (this.iface.esDivisaExt == true) {
						this.child("fdbDebeME").setValue(0);
						this.child("fdbHaberME").setValue(0);
					}
				}/* else {
						curPartidas.setModeAccess(curPartidas.Edit);
						curPartidas.refreshBuffer();
						curPartidas.setValueBuffer("debe", 0);
						curPartidas.setValueBuffer("haber", 0);
						if (this.iface.esDivisaExt == true) {
								curPartidas.setValueBuffer("debeme",0);
								curPartidas.setValueBuffer("haberme",0);
						}
						if (curPartidas.commitBuffer()) {
							commitOk = true;
						}
        }*/
			}
			if ( tipoImporte == "Calcular" ) {
				if (!valorFinal)
					valorFinal = "";
				valorFinal = valorFinal.toUpperCase();
				valorFinal = this.iface.calculadoraM( valorFinal.toString() );
				valorFinal = util.roundFieldValue(parseFloat(valorFinal), "co_subcuentas", "debe");
				if (curPlanPartidas.valueBuffer("debeohaber") == "Debe") {
					if ( contador == totalPrepartidas-1 ) {
						this.child("fdbDebe").setValue(parseFloat(valorFinal));
						if (this.iface.esDivisaExt == true) {
							if (parseFloat(this.child("fdbTasaConv").value()) != 0) {
								this.iface.bloqueo = true;
								this.child("fdbDebeME").setValue(parseFloat(valorFinal) / parseFloat(this.child("fdbTasaConv").value()));
								this.iface.bloqueo = false;
							}
						}
					} else {
						curPartidas.setModeAccess(curPartidas.Edit);
						curPartidas.refreshBuffer();
						curPartidas.setValueBuffer("debe", util.roundFieldValue(valorFinal, "co_partidas", "debe"));
						if (this.iface.esDivisaExt == true) {
							if (parseFloat(curPartidas.valueBuffer("tasaconv")) != 0) {
								this.iface.bloqueo = true;
								var debeME:Number = parseFloat(valorFinal) / parseFloat(curPartidas.valueBuffer("tasaconv"));
								curPartidas.setValueBuffer("debeme", util.roundFieldValue(debeME, "co_partidas", "debeme"));
								this.iface.bloqueo = false;
							}
						}
						if (curPartidas.commitBuffer()) {
							commitOk = true;
						}
					}
				} else {
					if ( contador == totalPrepartidas - 1 ) {
						this.child("fdbHaber").setValue(parseFloat(valorFinal));
						if (this.iface.esDivisaExt == true) {
							if (parseFloat(this.child("fdbTasaConv").value()) != 0) {
								this.child("fdbHaberME").setValue(parseFloat(valorFinal) / parseFloat(this.child("fdbTasaConv").value()));
							}
						}
					} else {
						curPartidas.setModeAccess(curPartidas.Edit);
						curPartidas.refreshBuffer();
						curPartidas.setValueBuffer("haber", util.roundFieldValue(valorFinal, "co_partidas", "haber"));
						if (this.iface.esDivisaExt == true) {
							if (parseFloat(curPartidas.valueBuffer("tasaconv")) != 0) {
								var haberME:Number = parseFloat(valorFinal) / parseFloat(curPartidas.valueBuffer("tasaconv"));
								curPartidas.setValueBuffer("haberme", util.roundFieldValue(haberME, "co_partidas", "haberme"));
							}
						}
						if (curPartidas.commitBuffer()) {
							commitOk = true;
						}
					}
				}
			}

			/////////// BASE IMPONIBLE ///////////
			tipoImporte = curPlanPartidas.valueBuffer("tbaseimponible");
			if ( tipoImporte == "Calcular" ) {
				curPartidas.setModeAccess(curPartidas.Edit);
				curPartidas.refreshBuffer();
				valorFinal = curPlanPartidas.valueBuffer("baseimponible");
				valorFinal = this.iface.calculadoraM( valorFinal.toString() );
				valorFinal = util.roundFieldValue(parseFloat(valorFinal), "co_subcuentas", "debe");
				if ( contador == totalPrepartidas - 1 ) {
					this.child("fdbBaseImponible").setValue(parseFloat(valorFinal));
				} else {
					curPartidas.setValueBuffer("baseimponible", util.roundFieldValue(valorFinal, "co_partidas", "baseimponible"));
					if (curPartidas.commitBuffer()) {
						commitOk = true;
					}
				}
			}
		}

		// Calcular el descuadre
		descuadreActual = this.iface.calculateField("ledDescuadreActual");
debug("descuadreActual1 = " + descuadreActual);
		descuadreActual += parseFloat(this.child("fdbDebe").value.toString());
debug("descuadreActual2 = " + descuadreActual);
		descuadreActual -= parseFloat(this.child("fdbHaber").value.toString());
debug("descuadreActual3 = " + descuadreActual);
		if ( idACuadrar >= 0) {
			if ( idACuadrar == totalPrepartidas - 1 ) {
				if (cuadraDivisa == true) {
					if (parseFloat(this.child("fdbTasaConv").value()) != 0) {
						valorFinal = (parseFloat(descuadreActual) / parseFloat(this.child("fdbTasaConv").value()));
						this.iface.bloqueo = true;	
						if (parseFloat(valorFinal) > 0) this.child("fdbHaberME").setValue(valorFinal);
						if (parseFloat(valorFinal) < 0) this.child("fdbDebeME").setValue(0 - valorFinal);		
						this.iface.bloqueo = false;
					}
				}
				this.iface.bloqueo = true;	
				if (parseFloat(descuadreActual) > 0) this.child("fdbHaber").setValue(descuadreActual);
				if (parseFloat(descuadreActual) < 0) this.child("fdbDebe").setValue(0 - descuadreActual);		
				this.iface.bloqueo = false;
			} else {
				curPartidas = new FLSqlCursor("co_partidas");
				curPartidas.select("idasiento = " + cursor.valueBuffer("idasiento") + " ORDER BY idpartida");
				for ( contador = 0; contador <= idACuadrar; contador++)
					curPartidas.next();
				curPartidas.setModeAccess(curPartidas.Edit);
				curPartidas.refreshBuffer();
				if (cuadraDivisa == true) {
					if (parseFloat(curPartidas.valueBuffer("tasaconv")) != 0) {
						valorFinal = (parseFloat(descuadreActual) / parseFloat(curPartidas.valueBuffer("tasaconv")));
					}
				}
				if (parseFloat(descuadreActual) > 0) {
					curPartidas.setValueBuffer("haber", util.roundFieldValue(descuadreActual, "co_partidas", "haber"));
					if (cuadraDivisa == true) {
						curPartidas.setValueBuffer("haberme", util.roundFieldValue(valorFinal, "co_partidas", "haberme"));
					}
					if (curPartidas.commitBuffer()) {
						commitOk = true;
					}
				}
				if (parseFloat(descuadreActual) < 0) {
					var descuadreNeg:Number = 0 -  descuadreActual;
					curPartidas.setValueBuffer("debe", util.roundFieldValue(descuadreNeg, "co_partidas", "debe"));
					if (cuadraDivisa == true) {
						var valorFinalNeg:Number = 0 - valorFinal;
						curPartidas.setValueBuffer("debeme", util.roundFieldValue(valorFinalNeg, "co_partidas", "debeme"));
					}
					if (curPartidas.commitBuffer()) {
						commitOk = true;
					}
				}
			}
		} else {
			if (Math.abs(descuadreActual) > 0.001) {
				MessageBox.warning(util.translate("scripts", "Asiento descuadrado"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				return false;
			}
		}
		formRecordco_asientos.iface.pub_terminarPredefinido();
	}
	return true;
}

function interna_calculateField(fN):String
{
	var util:FLUtil = new FLUtil();
	var res;
	var cursor:FLSqlCursor = this.cursor();		
	
	switch(fN) {
		case "debe":
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

		case "haber":
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

		case "idsubcuenta":
		/**\C Se obtiene el id de subcuenta de la tabla de subcuentas a partir del codigo de subcuenta
		\end */
			res = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + cursor.valueBuffer("codsubcuenta") + "'" + " AND codejercicio = '" + this.iface.ejercicioActual + "'");
			break;

		case "idcontrapartida":
		/*U Obtiene el id de contrapartida de la tabla de subcuentas a partir del codigo de contrapartida
		\end */
			res = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + cursor.valueBuffer("codcontrapartida") + "'" + " AND codejercicio = '" + this.iface.ejercicioActual + "'");
			break;

		/*U Se calcula el descuadre actual del asiento al que pertenece la partida
		\end */
		case "ledDescuadreActual":
			var valorDescuadre;
			res = util.sqlSelect("co_partidas", "SUM(debe) - SUM(haber)", "idasiento = " + cursor.valueBuffer("idasiento"));
			break;
		
		/** \D El --cifnif-- es el del cliente o proveedor asociado a la subcuenta de la contrapartida
		\end */
		case "cifnif":
			var codSubcuenta:String = cursor.valueBuffer("codcontrapartida");
			if (codSubcuenta && codSubcuenta.length == this.iface.longSubcuenta) {
				res = util.sqlSelect("co_subcuentascli sc INNER JOIN clientes c ON sc.codcliente = c.codcliente", "c.cifnif", "sc.codsubcuenta = '" + codSubcuenta + "' AND sc.codejercicio = '" + this.iface.ejercicioActual + "'", "co_subcuentascli,clientes");
				if (!res)
					res = util.sqlSelect("co_subcuentasprov sp INNER JOIN proveedores p ON sp.codproveedor = p.codproveedor", "p.cifnif", "sp.codsubcuenta = '" + codSubcuenta  + "' AND sp.codejercicio = '" + this.iface.ejercicioActual + "'", "co_subcuentasprov,proveedores");
			}
			break;
	}
	
	return res;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_desconexion()
{
	disconnect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged");
}

function oficial_bufferChanged(fN)
{
	var util:FLUtil = new FLUtil;
	if (this.iface.bloqueo) return;

	switch(fN) {
		case "debeme":
			if (!this.iface.bloqueo) {
				this.iface.bloqueo = true;
				if (parseFloat(this.child("fdbDebeME").value()) != 0) {
					this.child("fdbHaberME").setValue(0);
					this.child("fdbHaber").setValue(0);
					this.child("fdbDebe").setValue(this.iface.calculateField("debe"));
				}
				this.iface.bloqueo = false;
			}
			/** \C
			Memoriza, en caso de tener una variable asignada, el importe introducido para su posterior uso en importes calculados
			\end */
			this.iface.bloqueo = true;
			if (this.iface.datoMemoriaDH != "") {
				flcontppal.iface.pub_putPreMemoria(this.iface.datoMemoriaDH, this.child("fdbDebe").value());
			}
			this.iface.bloqueo = false;
			break;

		case "haberme":
			/** \C
			Trabajando con moneda extranjera, el --haber-- se calcula en moneda local a partir del --haberme-- extranjera y la tasa de conversión. Lo mismo que para el --debeme--
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
			/** \C
			Memoriza, en caso de tener una variable asignada, el importe introducido para su posterior uso en importes calculados
			\end */
			this.iface.bloqueo = true;
			if (this.iface.datoMemoriaDH != "") {
				flcontppal.iface.pub_putPreMemoria(this.iface.datoMemoriaDH, this.child("fdbHaber").value());
			}
			this.iface.bloqueo = false;
			break;

		case "tasaconv":
			/** \C
			Al cambiar la --tasaconv-- se recalculan el --debe-- y --haber-- a partir del --debeme-- o --haberme-- y la --tasaconv--
			\end */
			this.iface.bloqueo = true;
			if (parseFloat(this.child("fdbHaberME").value()) != 0) 
					this.child("fdbHaber").setValue(this.iface.calculateField("haber"));
			if (parseFloat(this.child("fdbDebeME").value()) != 0) 
					this.child("fdbDebe").setValue(this.iface.calculateField("debe"));
			this.iface.bloqueo = false;
			break;

		case "debe":
			/** \C
			Memoriza, en caso de tener una variable asignada, el importe introducido para su posterior uso en importes calculados
			\end */
			this.iface.bloqueo = true;
			if (this.iface.datoMemoriaDH != "") {
				flcontppal.iface.pub_putPreMemoria(this.iface.datoMemoriaDH, this.child("fdbDebe").value());
			}
			this.iface.bloqueo = false;
			break;

		case "haber":
			/** \C
			Memoriza, en caso de tener una variable asignada, el importe introducido para su posterior uso en importes calculados
			\end */
			this.iface.bloqueo = true;
			if (this.iface.datoMemoriaDH != "") {
				flcontppal.iface.pub_putPreMemoria(this.iface.datoMemoriaDH, this.child("fdbHaber").value());
			}
			this.iface.bloqueo = false;
			break;

		case "baseimponible":
			/** \C
			Memoriza, en caso de tener una variable asignada, la base imponible
			\end */
			this.iface.bloqueo = true;
			if (this.iface.datoMemoriaBI != "") {
				flcontppal.iface.pub_putPreMemoria(this.iface.datoMemoriaBI, this.child("fdbBaseImponible").value());
			}
			this.iface.bloqueo = false;
			break;

		case "codsubcuenta":
			/** \C
			Cuando --codsubcuenta-- alcanza el número de dígitos de la subcuenta, busca los datos asociados.
			Si el usuario pulsa la tecla del punto '.', la subcuenta se informa automaticamente con el código de cuenta más tantos ceros como sea necesario para completar la longitud de subcuenta asociada al ejercicio actual.
			\end */
			if (!this.iface.bloqueoSubcuenta) {
				this.iface.bloqueoSubcuenta = true;
				this.iface.posActualPuntoSubcuenta = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuenta", this.iface.longSubcuenta, this.iface.posActualPuntoSubcuenta);
				if (this.iface.datoMemoriaS != "") {
					flcontppal.iface.pub_putPreMemoria(this.iface.datoMemoriaS, this.child("fdbCodSubcuenta").value());
				}
				this.iface.bloqueoSubcuenta = false;
			}
			break;

		case "codcontrapartida":
			/** \C 
			Al introducir --codcontrapartida--, se rellena con ceros el código de subcuenta de la contrapartida cuando el último carácter del código es un punto, al igual que en el código de subcuenta
			\end */
			if (!this.iface.bloqueoSubcuenta) {
				this.iface.bloqueoSubcuenta = true;
				this.iface.posActualPuntoContrapar = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodContrapartida", this.iface.longSubcuenta, this.iface.posActualPuntoContrapar);
				if (this.iface.datoMemoriaSC != "") {
					flcontppal.iface.pub_putPreMemoria(this.iface.datoMemoriaSC, this.child("fdbCodContrapartida").value());
				}
				this.child("fdbCifNif").setValue(this.iface.calculateField("cifnif"));
				this.iface.bloqueoSubcuenta = false;
			}
			break;

		case "concepto":
			/** \C
			Memoriza, en caso de tener una variable asignada, el concepto introducido para su posterior uso
			\end */
			this.iface.bloqueo = true;
			if (this.iface.datoMemoriaC != "") {
				flcontppal.iface.pub_putPreMemoria(this.iface.datoMemoriaC, this.child("fdbConcepto").value());
			}
			flcontppal.iface.pub_putPreMemoria("conceptoanteriorx", this.child("fdbConcepto").value());
			this.iface.bloqueo = false;
			break;

		case "documento":
			/** \C
			Memoriza los datos del documento por si el documento en la siguiente partida fuera de tipo último
			\end */
			this.iface.bloqueo = true;
			flcontppal.iface.pub_putPreMemoria("documentoanteriorx", this.child("fdbDocumento").value());
			flcontppal.iface.pub_putPreMemoria("tipodocumentoanteriorx", this.child("fdbTipoDocumento").value());
			this.iface.bloqueo = false;
			break;

		case "coddivisa":
			/** \C
			Al cambiar --coddivisa-- se pone a cero --debe-- y --haber--. Si la moneda no es la del sistema, habilita el cuadro Moneda extranjera y deshabilita los campos Debe / Haber
			\end */
			//this.iface.valoresAcero();
			this.iface.controlDivisa();
			this.iface.bloqueo = true;	
			this.child("fdbDebe").setValue(this.iface.calculateField("debe"));
			this.child("fdbHaber").setValue(this.iface.calculateField("haber"));
			this.iface.bloqueo = false;
			break;
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

/** \D Pone el descuadre actual del asiento, antes de la partida actual en el campo descuadre. Establece el debe o haber (debe si el descuadre es negativo, haber si es positivo) de la partida actual al valor del descuadre, para facilitar el cierre del asiento. 
\end */
function oficial_descuadre() 
{
	var descuadreActual:Number = this.iface.calculateField("ledDescuadreActual");

	this.child("ledDescuadreActual").text = descuadreActual;
	
	this.iface.bloqueo = true;
	if (parseFloat(descuadreActual) > 0)
		this.child("fdbHaber").setValue(descuadreActual);
	if (parseFloat(descuadreActual) < 0)
		this.child("fdbDebe").setValue(0 - descuadreActual);
	this.iface.bloqueo = false;
}

/** \D Se comprueba si la cuenta de la que depende la subcuenta de la partida es una cuenta especial de iva soportado o repercutido. Si lo es, se habilita el marco I.V.A., si no lo es se inhabilita.

@param noAnteriorDebeHaber Indica si se calcula el anterior debe/haber
\end */
function oficial_controlIVA(noAnteriorDebeHaber)
{
	var util:FLUtil = new FLUtil();

	if (this.child("fdbCodSubcuenta").value().length == this.iface.longSubcuenta) {
		var q:FLSqlQuery = new FLSqlQuery();
		q.setTablesList("co_subcuentas");
		q.setSelect("coddivisa, iva");
		q.setFrom("co_subcuentas");
		q.setWhere("codsubcuenta = '" + this.child("fdbCodSubcuenta").value() + 
			"' AND codejercicio = '" + this.iface.ejercicioActual + "'");

		if (!q.exec())
				return;

		if (!q.first())
				return;

		var divisaSubcuenta:String = q.value(0);
		var ivaSubcuenta:String = q.value(1);
		var idCuenta:Number = util.sqlSelect("co_subcuentas", "idcuenta", "codsubcuenta = '" +
			this.child("fdbCodSubcuenta").value() + "' AND codejercicio = '" + 
			this.iface.ejercicioActual + "'");
		if (!idCuenta)
			return;

		this.iface.idCuentaEsp = util.sqlSelect("co_cuentas", "idcuentaesp", "idcuenta= " + idCuenta);

		if (this.iface.idCuentaEsp == "IVASOP" || this.iface.idCuentaEsp == "IVAREP") {
			this.iface.esIVA = true;
			this.iface.habilitarIVA("si");
		} else {
			this.iface.esIVA = false;
			this.iface.habilitarIVA("no");
		}
	}
}

/** D Habilita los controles de IVA o los inhabilita y pone a cero.
@param	siOno Toma los valores 'si' para habilitar o 'no' para deshabilitar las opciones de I.V.A.
\end */
function oficial_habilitarIVA(siOno)
{
	switch(siOno) {
		case "si": {
			this.child("gbIva").setDisabled(false);
			//this.child("fdbCifNif").setDisabled(false);
			this.iface.bloqueo = true;
			this.child("fdbDebeME").setValue(0);
			this.child("fdbHaberME").setValue(0);
			this.iface.bloqueo = false;
			this.child("fdbCodDivisa").setValue(this.iface.divisaEmpresa);
			break;
		}
		case "no": {
			this.child("gbIva").setDisabled(true);
			//this.child("fdbCifNif").setDisabled(true);
			this.iface.bloqueo = true;
			this.child("fdbBaseImponible").setValue(0);
			this.iface.bloqueo = false;
			break;
		}
	}
}

/** \D Establece la configuración del formulario en función del tipo de asiento predefinido y del número de partidas que tiene el asiento (número de paso).
\end */
function oficial_establecerPaso()
{
	var cualPaso:Number;
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var miVar:FLVar = new FLVar();
	var tipoPredefinido:String = miVar.get("TIPOPRE");
	var curPartidas:FLSqlCursor = new FLSqlCursor("co_partidas");
	curPartidas.select("idasiento = " + cursor.valueBuffer("idasiento"));
	var numPaso:Number = curPartidas.size();
	var faltaPorPedir:Number = 0;
	var datoTipo:String;
	var datoMemoria:String;
	var valorFinal:String;
	var esDebe:Number = 1;
	var cualDebe:String;
	var cualHaber:String;

	var curPlanPartidas:FLSqlCursor = new FLSqlCursor("co_planpartidas");
	curPlanPartidas.select("codplanasiento = '" + tipoPredefinido + "' ORDER BY numorden");
	var totalPrepartidas:Number = curPlanPartidas.size();


	for (var contador:Number = 0; contador < numPaso + 1; contador++)
		curPlanPartidas.next();


	curPlanPartidas.setModeAccess(curPlanPartidas.Browse);
	curPlanPartidas.refreshBuffer();

	//////////////// LA SUBCUENTA ///////////////
	datoTipo = curPlanPartidas.valueBuffer("tsubcuenta");
	datoMemoria = curPlanPartidas.valueBuffer("nsubcuenta");
	if (!datoMemoria)
		datoMemoria = "";
	datoMemoria = datoMemoria.toUpperCase();
	this.iface.datoMemoriaS = datoMemoria;
	if (datoTipo == "Establecer") {
		valorFinal = curPlanPartidas.valueBuffer("codsubcuenta");
		this.child("fdbCodSubcuenta").setDisabled(true);
		this.child("fdbIdSubcuenta").setDisabled(true);
	}
	if (datoTipo == "Pedir") {
		faltaPorPedir++;
		valorFinal = curPlanPartidas.valueBuffer("codsubcuenta");
		this.child("fdbCodSubcuenta").setDisabled(false);
		this.child("fdbIdSubcuenta").setDisabled(false);
	}
	if (datoTipo == "Definida") {
		if (datoMemoria != "") {
			valorFinal = flcontppal.iface.pub_getPreMemoria(datoMemoria);
			this.child("fdbCodSubcuenta").setDisabled(true);
			this.child("fdbIdSubcuenta").setDisabled(true);
		}
	}
	this.child("fdbCodSubcuenta").setValue(valorFinal);
	this.iface.bufferChanged("codsubcuenta");
	this.iface.controlIVA(true);

	//////////////// LA DIVISA ///////////////
	this.child("fdbCodDivisa").setValue(curPlanPartidas.valueBuffer("coddivisa"));
	this.iface.controlDivisa();

	//////////////// DEBE O HABER ///////////////
	datoTipo = curPlanPartidas.valueBuffer("debeohaber");
	if (datoTipo == "Debe") {
		this.child("fdbHaber").setDisabled(true);
		if (this.iface.esIVA == true)
			this.child("chkDebe").setChecked(true);
	}
	else {
		esDebe = 0;
		this.child("fdbDebe").setDisabled(true);
		if (this.iface.esIVA == true)
			this.child("chkHaber").setChecked(true);
	}

	if (this.iface.esDivisaExt == true) {
		//////////////// IMPORTE MONEDA EXTRANJERA ///////////////
		datoTipo = curPlanPartidas.valueBuffer("timporteme");
		datoMemoria = curPlanPartidas.valueBuffer("nimporteme");
		if (!datoMemoria)
			datoMemoria = "";
		datoMemoria = datoMemoria.toUpperCase();
		this.iface.datoMemoriaDH = datoMemoria;
		valorFinal = curPlanPartidas.valueBuffer("importeme");
		valorFinal = "("+valorFinal+")/"+(this.child("fdbTasaConv").value()).toString();
		cualDebe = "fdbDebeME";
		cualHaber = "fdbHaberME";
	} else {
		//////////////// EL IMPORTE ///////////////
		datoTipo = curPlanPartidas.valueBuffer("timporte");
		datoMemoria = curPlanPartidas.valueBuffer("nimporte");
		if (!datoMemoria)
			datoMemoria = "";
		datoMemoria = datoMemoria.toUpperCase();
		this.iface.datoMemoriaDH = datoMemoria;
		valorFinal = curPlanPartidas.valueBuffer("importe");
		cualDebe = "fdbDebe";
		cualHaber = "fdbHaber";
	}
	if (datoTipo != "Cuadrar" || numPaso != totalPrepartidas - 1) {
			this.child("fdbDebe").setValue(0);
			this.child("fdbHaber").setValue(0);
	}
	if (datoTipo == "Calcular") {
		valorFinal = this.iface.calculadoraM( valorFinal.toString() );
		valorFinal = util.roundFieldValue(parseFloat(valorFinal), "co_subcuentas", "debe");
		if (esDebe == 1) {
			this.child(cualDebe).setValue(parseFloat(valorFinal));
			this.iface.bufferChanged("debe");
		} else {
			this.child(cualHaber).setValue(parseFloat(valorFinal));
			this.iface.bufferChanged("haber");
		}
		this.child(cualDebe).setDisabled(true);
		this.child(cualHaber).setDisabled(true);
	}
	if (datoTipo == "Pedir") {
		faltaPorPedir++;
		if (esDebe == 1) {
			this.child(cualHaber).setDisabled(true);
		}
		else {
			this.child(cualDebe).setDisabled(true);
		}
	}
	if (datoTipo == "Cuadrar") {
		this.child(cualDebe).setDisabled(true);
		this.child(cualHaber).setDisabled(true);
	}

	//////////////// EL CONCEPTO ///////////////
	datoTipo = curPlanPartidas.valueBuffer("tconcepto");
	datoMemoria = curPlanPartidas.valueBuffer("nconcepto");
	if (!datoMemoria)
		datoMemoria = "";
	datoMemoria = datoMemoria.toUpperCase();
	this.iface.datoMemoriaC = datoMemoria;
	valorFinal = "";
	if (datoTipo == "Último") {
		valorFinal = flcontppal.iface.pub_getPreMemoria("conceptoanteriorx");
		this.child("fdbConcepto").setDisabled(true);
		this.child("fdbIdConcepto").setDisabled(true);
	}
	if (datoTipo == "Establecer") {
		valorFinal = curPlanPartidas.valueBuffer("concepto");
		this.child("fdbConcepto").setDisabled(true);
		this.child("fdbIdConcepto").setDisabled(true);
	}
	if (datoTipo == "Pedir") {
		faltaPorPedir++;
		valorFinal = curPlanPartidas.valueBuffer("concepto");
		this.child("fdbConcepto").setDisabled(false);
		this.child("fdbIdConcepto").setDisabled(false);
	}
	if (datoTipo == "Definido") {
		if (datoMemoria != "")
			valorFinal = flcontppal.iface.pub_getPreMemoria(datoMemoria);
		this.child("fdbConcepto").setDisabled(true);
		this.child("fdbIdConcepto").setDisabled(true);
	}
	this.child("fdbConcepto").setValue(valorFinal);
	this.iface.bufferChanged("concepto");

	//////////////// EL DOCUMENTO ///////////////
	datoTipo = curPlanPartidas.valueBuffer("tdocumento");
	valorFinal = "";
	if (datoTipo == "Último") {
		valorFinal = flcontppal.iface.pub_getPreMemoria("documentoanteriorx");
		this.child("fdbTipoDocumento").setDisabled(false); // si estuviera en true, la siguiente línea cerraría el programa.
		this.child("fdbTipoDocumento").setValue(parseInt(flcontppal.iface.pub_getPreMemoria("tipodocumentoanteriorx")));
		//this.cursor().setValueBuffer("tipodocumento", flcontppal.iface.pub_getPreMemoria("tipodocumentoanteriorx")); // no memoriza
		this.child("fdbDocumento").setDisabled(true);
		this.child("fdbTipoDocumento").setDisabled(true);
	}
	if (datoTipo == "Establecer") {
		this.cursor().setValueBuffer("tipodocumento", curPlanPartidas.valueBuffer("tipodocumento"));
		valorFinal = curPlanPartidas.valueBuffer("documento");
		this.child("fdbDocumento").setDisabled(true);
		this.child("fdbTipoDocumento").setDisabled(true);
	}
	if (datoTipo == "Pedir") {
		this.cursor().setValueBuffer("tipodocumento", curPlanPartidas.valueBuffer("tipodocumento"));
		faltaPorPedir++;
		valorFinal = curPlanPartidas.valueBuffer("documento");
		this.child("fdbDocumento").setDisabled(false);
		this.child("fdbTipoDocumento").setDisabled(false);
	}
	this.child("fdbDocumento").setValue(valorFinal);
	this.iface.bufferChanged("documento");

	if (this.iface.esIVA == true) {
		this.child("btgDHiva").setDisabled(true);
		this.child("fdbIva").setDisabled(true);
		this.child("fdbRecargo").setDisabled(true);

		//////////////// LA FACTURA ///////////////
		datoTipo = curPlanPartidas.valueBuffer("tfactura");
		if (datoTipo == "Pedir") {
			faltaPorPedir++;
			this.child("fdbFactura").setDisabled(false);
			this.child("fdbSerie").setDisabled(false);
		}
		if (datoTipo == "No pedir") {
			this.child("fdbFactura").setDisabled(true);
			this.child("fdbSerie").setDisabled(true);
		}

		//////////////// LA BASE IMPONIBLE ///////////////
		datoTipo = curPlanPartidas.valueBuffer("tbaseimponible");
		datoMemoria = curPlanPartidas.valueBuffer("nbaseimponible");
		if (!datoMemoria)
			datoMemoria = "";
		datoMemoria = datoMemoria.toUpperCase();
		this.iface.datoMemoriaBI = datoMemoria;
		if (datoTipo == "Calcular") {
			this.child("fdbBaseImponible").setDisabled(true);
			valorFinal = curPlanPartidas.valueBuffer("baseimponible");
			valorFinal = this.iface.calculadoraM( valorFinal.toString() );
			valorFinal = util.roundFieldValue(parseFloat(valorFinal), "co_subcuentas", "debe");
			this.child("fdbBaseImponible").setValue(parseFloat(valorFinal));
			this.iface.bufferChanged("baseimponible");
		}
		if (datoTipo == "Pedir") {
			faltaPorPedir++;
			this.child("fdbBaseImponible").setDisabled(false);
		}
    }
	//////////////// LA CONTRAPARTIDA ///////////////
	datoTipo = curPlanPartidas.valueBuffer("tcontrapartida");
	datoMemoria = curPlanPartidas.valueBuffer("ncontrapartida");
	if (!datoMemoria)
		datoMemoria = "";
	datoMemoria = datoMemoria.toUpperCase();
	this.iface.datoMemoriaSC = datoMemoria;
	if (datoTipo == "Establecer") {
		valorFinal = curPlanPartidas.valueBuffer("codcontrapartida");
		this.child("fdbCodContrapartida").setDisabled(true);
		this.child("fdbIdContrapartida").setDisabled(true);
	}
	if (datoTipo == "Pedir") {
		faltaPorPedir++;
		valorFinal = curPlanPartidas.valueBuffer("codcontrapartida"); // Aunque sólo sean 3 dígitos de la Subcuenta
		this.child("fdbCodContrapartida").setDisabled(false);
		this.child("fdbIdContrapartida").setDisabled(false);
	}
	if (datoTipo == "Definida") {
		if (datoMemoria != "") {
			valorFinal = flcontppal.iface.pub_getPreMemoria(datoMemoria);
			this.child("fdbCodContrapartida").setDisabled(true);
			this.child("fdbIdContrapartida").setDisabled(true);
		}
	}
	this.child("fdbCodContrapartida").setValue(valorFinal);
	this.iface.bufferChanged("codcontrapartida");

	this.child("pushButtonAccept").show();
	if (numPaso < totalPrepartidas - 1) {
		this.child("pushButtonAccept").close();
		if (faltaPorPedir == 0)
			this.child("pushButtonAcceptContinue").animateClick();
	}
	if (numPaso == totalPrepartidas - 1) {
		this.child("pushButtonAcceptContinue").close();
		if (faltaPorPedir == 0)
			this.child("pushButtonAccept").animateClick();
	}
}

/** \D Calcula el valor numérico de la cadena entrada cambiando primero todas las variables por su valor correspondiente según el array memorias; y a  continuación retorna el resultado tras hacer los cálculos pertinentes
\end */
function oficial_calculadoraM( entrada ):String
{
	var orden:Number;
	var seguir:Number;
	var contadorx:Number;
	var retorno:Number = 0;
	var car:Number;
	var cade:String;

	entrada = entrada.replace(/,/g,".");
	car = 1;
	orden = 1;
	for (contadorx = entrada.length; contadorx >= 0; contadorx--) {
		if (entrada.charAt(contadorx) == ')')
			orden++;
		if (orden > car)
			car = orden;
		if (entrada.charAt(contadorx) == '(')
			orden--;
	}

	if (orden != 1) {
		MessageBox.warning(util.translate("scripts", "Error en el número de paréntesis en " + entrada),
						MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return ("0");
	}

	orden = 0;

	// 0:Base, 1:Potencia, 2:Multiplo
	var fases:Array = new Array(car);
	fases[0] = new Array( 0.0, 0.0, 1.0 );
		
	for (car = entrada.length-1; car >= 0; car--) {
		contadorx = 0;
		while ( car >= 0 && ((entrada.charAt(car) >= '0' && entrada.charAt(car) <= '9') || 
			entrada.charAt(car) == '.')) {
			contadorx++;
			car--;
		}
		if ( car >= 0 ) {
			cade = entrada.charAt(car);
			if ( cade != ')' && cade != '(' && cade != '+' && cade != '-' && cade != '*' && cade != '/' && cade != '^' ) { // Entonces es el nombre de una variable
				car += contadorx;
				contadorx = 0;
			}
		}
		if (contadorx > 0) { // Hemos encontrado un número
			car++;
			retorno = parseFloat(entrada.substring(car, car+contadorx));
		}
		else { // No era un número, será un operador o una variable
			cade = entrada.substring(car,car+1);
			switch ( cade.toString() ) {
				case ")": { // Abre un nuevo subtramo de la función
					orden++;
					fases[orden] = new Array( 0.0, 0.0, 1.0 );
					break;
				}
				case "(": { // Cierra el ), tenga en cuenta que vamos leyendo del final al principio
					retorno = Math.pow(retorno, fases[orden][1]+1.0) * fases[orden][2];
					retorno += fases[orden][0];
					orden--;
					break;
				}
				case "+": {
					fases[orden][0] += (Math.pow(retorno, fases[orden][1] + 1.0) * fases[orden][2]);
					fases[orden][2] = 1.0;
					retorno = 0.0;
					fases[orden][1] = 0.0;
					break;
				}
				case "-": {
					fases[orden][0] -= (Math.pow(retorno, fases[orden][1] + 1.0) * fases[orden][2]);
					fases[orden][2] = 1.0;
					retorno = 0.0;
					fases[orden][1] = 0.0;
					break;
				}
				case "*": {
					fases[orden][2] *= (Math.pow(retorno, fases[orden][1] + 1.0));
					retorno = 0.0;
					fases[orden][1] = 0.0;
					break;
				}
				case "/": {
					if (Math.pow(retorno, fases[orden][1] + 1.0) == 0)
						fases[orden][2] = 0;
					else 
						fases[orden][2] /= (Math.pow(retorno, fases[orden][1] + 1.0));
					retorno = 0.0;
					fases[orden][1] = 0.0;
					break;
				}
				case "^": {
					fases[orden][1] = retorno - 1.0;
					retorno = 0.0;
					break;
				}
				default: { // Se trata de un nombre de variable
					contadorx = 0;
					// En caso de que venga una variable, cojamos su nombre y su valor
					do {
						seguir = 1;
						cade = entrada.charAt(car);
						if ( cade != ')' && cade != '(' && cade != '+' && cade != '-' && cade != '*' && cade != '/' && cade != '^' ) { 
							car --;
							contadorx++;
						}
						else {
							seguir = 0;
						}
					} while ( seguir && car >= 0 );
					car++; // el car-- del for lo vuelve a poner en su sitio.
					if ( contadorx > 0 ) {
						cade = entrada.substring(car, car+contadorx);
						if (!cade)
							cade = "";
						cade = cade.toUpperCase();
						retorno = flcontppal.iface.pub_getPreMemoria(cade);
					}

				}
			}
		}
	}
	retorno = fases[orden][0] + (Math.pow(retorno, fases[orden][1] + 1.0) * fases[orden][2]);
	return retorno.toString();
}


//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
