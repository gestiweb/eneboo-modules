/***************************************************************************
                 co_planpartidas.qs  -  description
                             -------------------
    begin                : lun mar 27 2006
    copyright            : (C) 2006 by InfoSiAL S.L. y Guillermo Molleda Jimena
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
	function calculateCounter():Number { return this.ctx.interna_calculateCounter(); }
	function acceptedForm() { this.ctx.interna_acceptedForm(); }
	function canceledForm() { this.ctx.interna_canceledForm(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var definirMemoriaS:Number;
	var definidaMemoriaS:Number;
	var bloqueoMemoriaS:Boolean;

	var definirMemoriaI:Number;
	var definidaMemoriaI:Number;
	var bloqueoMemoriaI:Boolean;

	var definirMemoriaC:Number;
	var definidaMemoriaC:Number;
	var bloqueoMemoriaC:Boolean;

	var definirMemoriaBI:Number;
	var definidaMemoriaBI:Number;
	var bloqueoMemoriaBI:Boolean;

	var definirMemoriaCt:Number;
	var definidaMemoriaCt:Number;
	var bloqueoMemoriaCt:Boolean;

	var definirMemoriaIme:Number;
	var definidaMemoriaIme:Number;
	var bloqueoMemoriaIme:Boolean;

	var formularioAceptado:Boolean;
	var antiguaMemoria:Array;

	var longSubcuenta:Number;
	var ejercicioActual:String;
	var divisaEmpresa:String;
	var idCuentaEsp:Number;
	var bloqueoSubcuenta:Boolean;
	var permisoCP:Boolean;
	var esIVA:Boolean;
	var esDivisaExt:Boolean;
	var posActualPuntoSubcuenta:Number;
	var posActualPuntoContrapar:Number;
	
	function oficial( context ) { interna( context ); } 
	function cambioDH(debeOhaber) {
		return this.ctx.oficial_cambioDH(debeOhaber);
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
	function cambiarDefinida(lugarDefinida, tipoDefinida, campoDefinida):Number {
		return this.ctx.oficial_cambiarDefinida(lugarDefinida, tipoDefinida, campoDefinida);
	}
	function cambiarCalcular(entrada, lugarDefinida):String {
		return this.ctx.oficial_cambiarCalcular(entrada, lugarDefinida);
	}
	function tbnSubcuenta_click() {
		return this.ctx.oficial_tbnSubcuenta_click();
	}
	function tbnImporte_click() {
		return this.ctx.oficial_tbnImporte_click();
	}
	function tbnConcepto_click() {
		return this.ctx.oficial_tbnConcepto_click();
	}
	function tbnBaseImponible_click() {
		return this.ctx.oficial_tbnBaseImponible_click();
	}
	function tbnContrapartida_click() {
		return this.ctx.oficial_tbnContrapartida_click();
	}
	function tbnImporteme_click() {
		return this.ctx.oficial_tbnImporteme_click();
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
/** \C
\end */
function interna_init()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	this.iface.definirMemoriaS = -1;
	this.iface.definidaMemoriaS = -1;
	this.iface.bloqueoMemoriaS = false;

	this.iface.definirMemoriaI = -1;
	this.iface.definidaMemoriaI = -1;
	this.iface.bloqueoMemoriaI = false;

	this.iface.definirMemoriaC = -1;
	this.iface.definidaMemoriaC = -1;
	this.iface.bloqueoMemoriaC = false;

	this.iface.definirMemoriaBI = -1;
	this.iface.definidaMemoriaBI = -1;
	this.iface.bloqueoMemoriaBI = false;

	this.iface.definirMemoriaCt = -1;
	this.iface.definidaMemoriaCt = -1;
	this.iface.bloqueoMemoriaCt = false;

	this.iface.definirMemoriaIme = -1;
	this.iface.definidaMemoriaIme = -1;
	this.iface.bloqueoMemoriaIme = false;

	this.iface.ejercicioActual = flfactppal.iface.pub_ejercicioActual();
	this.iface.divisaEmpresa = util.sqlSelect("empresa", "coddivisa", "1 = 1");

	this.iface.longSubcuenta = util.sqlSelect("ejercicios", "longsubcuenta", "codejercicio = '" + this.iface.ejercicioActual + "'");
	this.iface.bloqueoSubcuenta = false;
	this.iface.posActualPuntoSubcuenta = -1;
	this.iface.posActualPuntoContrapar = -1;

	if (cursor.modeAccess() == cursor.Edit) {
		if (this.child("fdbTSubcuenta").value().toString() != "Definida" && this.child("fdbNSubcuenta").value().toString() != "")
			this.iface.definirMemoriaS = flcontppal.iface.pub_lugarPreMemoria(this.child("fdbNSubcuenta").value().toString());

		if (this.child("fdbTImporte").value().toString() != "Cuadrar" &&
				this.child("fdbNImporte").value().toString() != "")
			this.iface.definirMemoriaI = 	flcontppal.iface.pub_lugarPreMemoria(this.child("fdbNImporte").value().toString());

		if ((this.child("fdbTConcepto").value().toString() == "Establecer" || this.child("fdbTConcepto").value().toString() == "Pedir") && this.child("fdbNConcepto").value().toString() != "")
			this.iface.definirMemoriaC =  flcontppal.iface.pub_lugarPreMemoria(this.child("fdbNConcepto").value().toString());

		if (this.child("fdbTBaseImponible").value().toString() == "Pedir" && this.child("fdbNBaseImponible").value().toString() != "")
			this.iface.definirMemoriaI =  flcontppal.iface.pub_lugarPreMemoria(this.child("fdbNBaseImponible").value().toString());

		if (this.child("fdbTContrapartida").value().toString() != "Definida" && this.child("fdbNContrapartida").value().toString() != "")
			this.iface.definirMemoriaS =  flcontppal.iface.pub_lugarPreMemoria(this.child("fdbNContrapartida").value().toString());

		if (this.child("fdbTImporteme").value().toString() != "Cuadrar" && this.child("fdbNImporteme").value().toString() != "")
			this.iface.definirMemoriaI =  flcontppal.iface.pub_lugarPreMemoria(this.child("fdbNImporteme").value().toString());

		this.child("gbIva").setDisabled(true);
		this.iface.controlIVA(true);
	}

	if (cursor.modeAccess() != cursor.Insert) {
		if (this.cursor().valueBuffer("debeohaber") == "Debe")
			this.child("chkDebe").setChecked(true);
		else
			this.child("chkHaber").setChecked(true);
	}

	if (cursor.modeAccess() == cursor.Browse)
		this.child("btgDH").setDisabled(true);

	if (cursor.modeAccess() == cursor.Insert) {
		this.child("fdbNumOrden").setValue(this.iface.calculateCounter());
		this.child("fdbCodDivisa").setValue(this.iface.divisaEmpresa);
		this.iface.habilitarIVA("no");
		this.iface.controlIVA();
		this.iface.cambioDH(0);
	}

	if (cursor.modeAccess() != cursor.Browse) {
		this.iface.bufferChanged("tsubcuenta");
		this.iface.bufferChanged("timporte");
		this.iface.bufferChanged("tconcepto");
		this.iface.bufferChanged("tdocumento");
		this.iface.bufferChanged("tcontrapartida");
		this.iface.bufferChanged("tbaseimponible");
		this.iface.bufferChanged("timporteme");
		this.iface.bufferChanged("coddivisa");
	}

	this.iface.formularioAceptado = false; // Necesario para llamar a canceledForm() si se cierra la ventana con la X superior derecha
	this.iface.antiguaMemoria = (flcontppal.iface.pub_arrayPreMemoria()).slice(0, flcontppal.iface.pub_cantidadPreMemoria());

	connect(this.child("btgDH"), "clicked(int)", this, "iface.cambioDH");
	connect(this.child("tbnSubcuenta"), "clicked()", this, "iface.tbnSubcuenta_click");
	connect(this.child("tbnImporte"), "clicked()", this, "iface.tbnImporte_click");
	connect(this.child("tbnConcepto"), "clicked()", this, "iface.tbnConcepto_click");
	connect(this.child("tbnBaseImponible"), "clicked()", this, "iface.tbnBaseImponible_click");
	connect(this.child("tbnContrapartida"), "clicked()", this, "iface.tbnContrapartida_click");
	connect(this.child("tbnImporteme"), "clicked()", this, "iface.tbnImporteme_click");
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this, "closed()", this, "iface.desconexion");
}

/** \D Calcula el número de orden de una prepartida nueva
\end */
function interna_calculateCounter():Number
{
	var util:FLUtil = new FLUtil();
	var numPrepartida:Number = util.sqlSelect("co_planpartidas", "MAX(numorden)","codplanasiento = '" + this.cursor().valueBuffer("codplanasiento") + "'");
	numPrepartida++;
	return numPrepartida;
}

function interna_acceptedForm()
{
	this.iface.formularioAceptado = true;
	this.iface.desconexion();
}

function interna_canceledForm()
{
	flcontppal.iface.pub_reponerArrayPreMemoria(this.iface.antiguaMemoria);
	this.iface.formularioAceptado = true; // para que no vuelva a llamar a esta función desde desconexión
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_desconexion()
{
	if (this.iface.formularioAceptado == false)
	    this.iface.canceledForm();
	this.iface.antiguaMemoria.splice(0,this.iface.antiguaMemoria.length);

	disconnect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged");
	disconnect(this.child("btgDH"), "clicked(int)", this, "iface.cambioDH");
	disconnect(this.child("tbnSubcuenta"), "clicked()", this, "iface.tbnSubcuenta_click");
	disconnect(this.child("tbnImporte"), "clicked()", this, "iface.tbnImporte_click");
	disconnect(this.child("tbnConcepto"), "clicked()", this, "iface.tbnConcepto_click");
	disconnect(this.child("tbnBaseImponible"), "clicked()", this, "iface.tbnBaseImponible_click");
	disconnect(this.child("tbnContrapartida"), "clicked()", this, "iface.tbnContrapartida_click");
	disconnect(this.child("tbnImporteme"), "clicked()", this, "iface.tbnImporteme_click");
}

function oficial_bufferChanged(fN)
{
	var util:FLUtil = new FLUtil();

	switch(fN) {
		case "tsubcuenta":
			if (this.child("fdbTSubcuenta").value() == 0) {//"Establecer") {
				this.iface.bloqueoMemoriaS = false;
				this.child("fdbCodSubcuenta").setDisabled(false);
				this.child("fdbNSubcuenta").setDisabled(false);
				this.child("tbnSubcuenta").setDisabled(true);
			}
			if (this.child("fdbTSubcuenta").value() == 1) {//"Pedir") {
				this.iface.bloqueoMemoriaS = false;
				this.child("fdbCodSubcuenta").setDisabled(false);
				this.child("fdbNSubcuenta").setDisabled(false);
				this.child("tbnSubcuenta").setDisabled(true);
			}
			if (this.child("fdbTSubcuenta").value() == 2) {//"Definida") {
				this.iface.bloqueoMemoriaS = true;
				this.child("fdbCodSubcuenta").setDisabled(true);
				this.child("fdbNSubcuenta").setDisabled(false);
				this.child("tbnSubcuenta").setDisabled(false);
			}
			break;

		case "timporte":
			if (this.child("fdbTImporte").value() == 1) {//"Calcular") {
				this.child("fdbImporte").setDisabled(false);
				this.child("fdbNImporte").setDisabled(false);
				this.child("tbnImporte").setDisabled(false);
			}
			if (this.child("fdbTImporte").value() == 0) {//"Pedir") {
				this.child("fdbImporte").setDisabled(true);
				this.child("fdbNImporte").setDisabled(false);
				this.child("tbnImporte").setDisabled(true);
			}
			if (this.child("fdbTImporte").value() == 2) {//"Cuadrar") {
				this.child("fdbImporte").setDisabled(true);
				this.child("fdbNImporte").setDisabled(true);
				this.child("tbnImporte").setDisabled(true);
			}
			break;

		case "timporteme":
			if (this.child("fdbTImporteme").value() == 1) {//"Calcular") {
				this.child("fdbImporteme").setDisabled(false);
				this.child("fdbNImporteme").setDisabled(false);
				this.child("tbnImporteme").setDisabled(false);
			}
			if (this.child("fdbTImporteme").value() == 0) {//"Pedir") {
				this.child("fdbImporteme").setDisabled(true);
				this.child("fdbNImporteme").setDisabled(false);
				this.child("tbnImporteme").setDisabled(true);
			}
			if (this.child("fdbTImporteme").value() == 2) {//"Cuadrar") {
				this.child("fdbImporteme").setDisabled(true);
				this.child("fdbNImporteme").setDisabled(true);
				this.child("tbnImporteme").setDisabled(true);
			}
			break;

		case "tconcepto":
			if (this.child("fdbTConcepto").value() == 0) {//"Establecer") {
				this.iface.bloqueoMemoriaC = false;
				this.child("fdbConcepto").setDisabled(false);
				this.child("fdbNConcepto").setDisabled(false);
				this.child("tbnConcepto").setDisabled(true);
			}
			if (this.child("fdbTConcepto").value() == 1) {//"Pedir") {
				this.iface.bloqueoMemoriaC = false;
				this.child("fdbConcepto").setDisabled(false);
				this.child("fdbNConcepto").setDisabled(false);
				this.child("tbnConcepto").setDisabled(true);
			}
			if (this.child("fdbTConcepto").value() == 2) {//"Último") {
				this.iface.bloqueoMemoriaC = false;
				this.child("fdbConcepto").setDisabled(true);
				this.child("fdbNConcepto").setDisabled(true);
				this.child("tbnConcepto").setDisabled(true);
			}
			if (this.child("fdbTConcepto").value() == 3) {//"Definido") {
				this.iface.bloqueoMemoriaC = true;
				this.child("fdbConcepto").setDisabled(true);
				this.child("fdbNConcepto").setDisabled(false);
				this.child("tbnConcepto").setDisabled(false);
			}
			break;

		case "tdocumento":
			if (this.child("fdbTDocumento").value() == 0) {//"Establecer") {
				this.child("fdbDocumento").setDisabled(false);
				this.child("fdbTipoDocumento").setDisabled(false);
			}
			if (this.child("fdbTDocumento").value() == 1) {//"Pedir") {
				this.child("fdbDocumento").setDisabled(false);
				this.child("fdbTipoDocumento").setDisabled(false);
			}
			if (this.child("fdbTDocumento").value() == 2) {//"Último") {
				this.child("fdbDocumento").setDisabled(true);
				this.child("fdbTipoDocumento").setDisabled(true);
			}
			break;

		case "tbaseimponible":
			if (this.child("fdbTBaseImponible").value() == 1) {//"Calcular") {
				this.child("fdbBaseImponible").setDisabled(false);
				this.child("fdbNBaseImponible").setDisabled(false);
				this.child("tbnBaseImponible").setDisabled(false);
			}
			if (this.child("fdbTBaseImponible").value() == 0) {//"Pedir") {
				this.child("fdbBaseImponible").setDisabled(true);
				this.child("fdbNBaseImponible").setDisabled(false);
				this.child("tbnBaseImponible").setDisabled(true);
			}
			break;

		case "tcontrapartida":
			if (this.child("fdbTContrapartida").value() == 0) {//"Establecer") {
				this.iface.bloqueoMemoriaCt = false;
				this.child("fdbCodContrapartida").setDisabled(false);
				this.child("fdbNContrapartida").setDisabled(false);
				this.child("tbnContrapartida").setDisabled(true);
			}
			if (this.child("fdbTContrapartida").value() == 1) {//"Pedir") {
				this.iface.bloqueoMemoriaCt = false;
				this.child("fdbCodContrapartida").setDisabled(false);
				this.child("fdbNContrapartida").setDisabled(false);
				this.child("tbnContrapartida").setDisabled(true);
			}
			if (this.child("fdbTContrapartida").value() == 2) {//"Definida") {
				this.iface.bloqueoMemoriaCt = true;
				this.child("fdbCodContrapartida").setDisabled(true);
				this.child("fdbNContrapartida").setDisabled(false);
				this.child("tbnContrapartida").setDisabled(false);
			}
			break;

		case "coddivisa":
			/** \C
			Al cambiar --coddivisa-- si la moneda no es la del sistema, habilita el cuadro Moneda extranjera
			\end */
				this.iface.controlDivisa();
			break;
		case "codsubcuenta":
			/** 
			\D
			Cuando alcanza el número de dígitos de la subcuenta, busca los datos asociados.
			\end */
			/** \C
			Al introducir --codsubcuenta--, si el usuario pulsa la tecla "punto" (.), la subcuenta se informa automaticamente con el código de cuenta más tantos ceros como sea necesario para completar la longitud de subcuenta asociada al ejercicio actual.
			\end */
				if (!this.iface.bloqueoSubcuenta) {
					this.iface.bloqueoSubcuenta = true;
					this.iface.posActualPuntoSubcuenta = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuenta", this.iface.longSubcuenta, this.iface.posActualPuntoSubcuenta);
					this.iface.bloqueoSubcuenta = false;
				}

			/** \C
			Si --codsubcuenta-- es de IVA se realizan las siguientes acciones: [1] se pone como divisa la divisa local y se deshabilita el campo de divisa (sólo se admite la divisa local), [2] se habilitan los campos de iva, se busca la utima partida insertada en el asiento presente y de ella se extrae el debe o haber, que se utiliza para informar el campo de base imponible.
			Si --codsubcuenta-- tiene asociada una divisa diferente de la divisa local, se inhabilitan los campos debe y haber principales y se habilitan los campos debe y haber de la divisa.
			\end */
				if (this.child("fdbCodSubcuenta").value().length == this.iface.longSubcuenta) {
					var q:FLSqlQuery = new FLSqlQuery();
					q.setTablesList("co_subcuentas");
					q.setSelect("coddivisa, iva");
					q.setFrom("co_subcuentas");
					q.setWhere("codsubcuenta = '" + this.child("fdbCodSubcuenta").value() + "' AND codejercicio = '" + this.iface.ejercicioActual + "'");
					q.exec();
					q.first();

					var divisaSubcuenta:String = q.value(0);
					var ivaSubcuenta:String = q.value(1);
					var idCuenta:Number = util.sqlSelect("co_subcuentas", "idcuenta", "codsubcuenta = '" + this.child("fdbCodSubcuenta").value() + "' AND codejercicio = '" + this.iface.ejercicioActual + "'");
					if (!idCuenta)
						return;

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
							this.iface.habilitarIVA("si");
					} else {
							this.iface.esIVA = false;
							this.iface.habilitarIVA("no");
					}
				}
			break;

		case "codcontrapartida":
				/** \C 
				Al introducir --codcontrapartida--, se rellena con ceros el código de subcuenta de la contrapartida cuando el último carácter del código es un punto, al igual que en el código de subcuenta
				\end */
				if (!this.iface.bloqueoSubcuenta) {
					this.iface.bloqueoSubcuenta = true;
					this.iface.posActualPuntoContrapar = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodContrapartida", this.iface.longSubcuenta, this.iface.posActualPuntoContrapar);
					this.iface.bloqueoSubcuenta = false;
				}
			break;
		case "nsubcuenta":
				/** \C 
				Al introducir definir en --nsubcuenta--, se memoriza el nombre de la variable para darla a elegir en definida
				\end */
				if (!this.iface.bloqueoMemoriaS) {
					this.iface.definirMemoriaS = flcontppal.iface.pub_putLugarPreMemoria
					(this.iface.definirMemoriaS, this.child("fdbNSubcuenta").value().toString(),
					"Subcuenta");
				}
			break;
		case "nimporte":
				/** \C 
				Al introducir definir en --nimporte--, se memoriza el nombre de la variable para darla a elegir en definida
				\end */
				if (!this.iface.bloqueoMemoriaI) {
					this.iface.definirMemoriaI = flcontppal.iface.pub_putLugarPreMemoria
					(this.iface.definirMemoriaI, this.child("fdbNImporte").value().toString(),
					"Importe");
				}
			break;
		case "nconcepto":
				/** \C 
				Al introducir definir en --nconcepto--, se memoriza el nombre de la variable para darla a elegir en definida
				\end */
				if (!this.iface.bloqueoMemoriaC) {
					this.iface.definirMemoriaC = flcontppal.iface.pub_putLugarPreMemoria
					(this.iface.definirMemoriaC, this.child("fdbNConcepto").value().toString(),
					"Concepto");
				}
			break;
		case "nbaseimponible":
				/** \C 
				Al introducir definir en --nbaseimponible--, se memoriza el nombre de la variable para darla a elegir en definida
				\end */
				if (!this.iface.bloqueoMemoriaBI) {
					this.iface.definirMemoriaBI = flcontppal.iface.pub_putLugarPreMemoria
					(this.iface.definirMemoriaBI, this.child("fdbNBaseImponible").value().toString(),
					"Importe");
				}
			break;
		case "ncontrapartida":
				/** \C 
				Al introducir definir en --ncontrapartida--, se memoriza el nombre de la variable para darla a elegir en definida
				\end */
				if (!this.iface.bloqueoMemoriaCt) {
					this.iface.definirMemoriaCt = flcontppal.iface.pub_putLugarPreMemoria
					(this.iface.definirMemoriaCt, this.child("fdbNContrapartida").value().toString(),
					"Subcuenta");
				}
			break;
		case "nimporteme":
				/** \C 
				Al introducir definir en --nimporteme--, se memoriza el nombre de la variable para darla a elegir en definida
				\end */
				if (!this.iface.bloqueoMemoriaIme) {
					this.iface.definirMemoriaIme = flcontppal.iface.pub_putLugarPreMemoria
					(this.iface.definirMemoriaIme, this.child("fdbNImporteme").value().toString(),
					"Importe");
				}
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
	} else {
		this.iface.esDivisaExt = true;
	}

	this.child("fdbTImporte").setDisabled(this.iface.esDivisaExt);
	this.child("fdbTImporteme").setDisabled(!(this.iface.esDivisaExt));
	if (this.iface.esDivisaExt == true) {
		this.child("fdbImporte").setDisabled(true);
		this.child("fdbNImporte").setDisabled(true);
		this.iface.bufferChanged("timporteme");
	}
	else {
		this.child("fdbImporteme").setDisabled(true);
		this.child("fdbNImporteme").setDisabled(true);
		this.iface.bufferChanged("timporte");
	}
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
		q.setWhere("codsubcuenta = '" + this.child("fdbCodSubcuenta").value() + "' AND codejercicio = '" + this.iface.ejercicioActual + "'");

		if (!q.exec())
			return;

		if (!q.first())
			return;

		var divisaSubcuenta:String = q.value(0);
		var ivaSubcuenta:String = q.value(1);
		var idCuenta:Number = util.sqlSelect("co_subcuentas", "idcuenta", "codsubcuenta = '" + this.child("fdbCodSubcuenta").value() + "' AND codejercicio = '" +  this.iface.ejercicioActual + "'");
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

/** \D Devuelve el identificador del preasiento al que pertenece la prepartida
\end */
function oficial_obtenerIdPreAsiento():Number
{
	var util:FLUtil = new FLUtil();
	var res:Number = util.sqlSelect("co_planasientos", "idpreasiento", "numero = " + this.child("fdbAsiento").value());
	res = this.cursor().valueBuffer("idPreAsiento");
	return res;
}

/** D Habilita los controles de IVA o los inhabilita y pone a cero.

@param	siOno Toma los valores 'si' para habilitar o 'no' para deshabilitar las opciones de I.V.A.
\end */
function oficial_habilitarIVA(siOno)
{
	switch(siOno) {
		case "si":
			this.child("gbIva").setDisabled(false);
			this.child("fdbCodDivisa").setValue(this.iface.divisaEmpresa);
			this.child("gbDivisa").setDisabled(true);
			
			break;
				
		case "no":
			this.child("gbIva").setDisabled(true);
			this.child("gbDivisa").setDisabled(false);

			break;
	}
}

/** \D Intercambia los valores de --debe-- y --haber-- en una partida de IVA

@param debeOhaber Es el valor que devuelve el cuadro de botones de radio del formulario: 0 para el debe y 1 para el haber
\end */
function oficial_cambioDH(debeOhaber)
{
	if (debeOhaber == 0) {
		this.cursor().setValueBuffer("debeohaber", "Debe");
	} else {
		this.cursor().setValueBuffer("debeohaber", "Haber");
	}
}

/** \D Cambia el campo Definir según las variables memorizadas con anterioridad en PreMemorias
@param lugarDefinida Es la posición actual del buscador de variables
@param tipoDefinida Es el tipo de dato que buscamos
@param campoDefinida Es el campo editado en el formulario
@return Número correspondiente a la nueva posición del buscador de variables
\end */
function oficial_cambiarDefinida(lugarDefinida:Number, tipoDefinida:String, campoDefinida:String):Number
{

	var total:Number = flcontppal.iface.pub_cantidadPreMemoria();
	var contador:Number = lugarDefinida+2;
	var nombre:String = "";

	if (contador < 2) contador = 0;
	for (; contador < total; contador+=2) {
		nombre = flcontppal.iface.pub_getNombrePreMemoria(contador);
		if (flcontppal.iface.pub_getPreMemoria(nombre) == tipoDefinida) {
			lugarDefinida = contador;
			contador = total+100;
		}
	}
	if (contador < total+10) {
		for (contador = 0; contador < lugarDefinida; contador+=2) {
			nombre = flcontppal.iface.pub_getNombrePreMemoria(contador);
			if (flcontppal.iface.pub_getPreMemoria(nombre) == tipoDefinida) {
				lugarDefinida = contador;
				contador = total+100;
			}
		}
	}

	return lugarDefinida;
}

/** \D Cambia el campo Definir de la Subcuenta según las variables memorizadas con anterioridad en PreMemorias

\end */
function oficial_tbnSubcuenta_click()
{
	this.iface.definidaMemoriaS = this.iface.cambiarDefinida(this.iface.definidaMemoriaS,
		"Subcuenta", "fdbNSubcuenta");
	if (this.iface.definidaMemoriaS >= 0)
		this.child("fdbNSubcuenta").setValue(flcontppal.iface.pub_getNombrePreMemoria(this.iface.definidaMemoriaS));
}

/** \D Cambia el campo Definir del Concepto según las variables memorizadas con anterioridad en PreMemorias

\end */
function oficial_tbnConcepto_click()
{
	this.iface.definidaMemoriaC = this.iface.cambiarDefinida(this.iface.definidaMemoriaC,
		"Concepto", "fdbNConcepto");
	if (this.iface.definidaMemoriaC >= 0)
		this.child("fdbNConcepto").setValue(flcontppal.iface.pub_getNombrePreMemoria(this.iface.definidaMemoriaC));
}

/** \D Cambia el campo Definir de la Contrapartida según las variables memorizadas con anterioridad en PreMemorias

\end */
function oficial_tbnContrapartida_click()
{
	this.iface.definidaMemoriaCt = this.iface.cambiarDefinida(this.iface.definidaMemoriaCt,
		"Subcuenta", "fdbNContrapartida");
	if (this.iface.definidaMemoriaCt >= 0)
		this.child("fdbNContrapartida").setValue(flcontppal.iface.pub_getNombrePreMemoria(this.iface.definidaMemoriaCt));
}

/** \D Cambia el campo Calcular según las variables memorizadas con anterioridad en PreMemorias
@param entrada Es el valor actual del campo Calcular
@param lugarDefinida Es la posición actual del buscador de variables
@return String Será el nuevo valor del campo Calcular
\end */
function oficial_cambiarCalcular(entrada:String, lugarDefinida:Number):String
{
	// Si el valor termina en una variable, eliminarla. Para ello busca el último operador ()+-*/^
	var car = entrada.length-1;

	while ( car >= 0 && entrada.charAt(car) != '(' && entrada.charAt(car) != ')' && 
		entrada.charAt(car) != '+' && entrada.charAt(car) != '-' && 
		entrada.charAt(car) != '*' && entrada.charAt(car) != '/' && 
		entrada.charAt(car) != '^')
		car--;

	entrada = entrada.left(car+1);
	// Añadir la variable y modificar el valor
	entrada += flcontppal.iface.pub_getNombrePreMemoria(lugarDefinida);
	return entrada;

}

/** \D Cambia el campo Definir del Importe según las variables memorizadas con anterioridad en PreMemorias

\end */
function oficial_tbnImporte_click()
{
	this.iface.definidaMemoriaI = this.iface.cambiarDefinida(this.iface.definidaMemoriaI,
		"Importe", "fdbImporte");
	if (this.iface.definidaMemoriaI >= 0) {
		var entrada:String = this.child("fdbImporte").value().toString();
		entrada = this.iface.cambiarCalcular(entrada, this.iface.definidaMemoriaI);
		this.child("fdbImporte").setValue(entrada);
	}
}

/** \D Cambia el campo Definir de la Base Imponible según las variables memorizadas con anterioridad en PreMemorias

\end */
function oficial_tbnBaseImponible_click()
{
	this.iface.definidaMemoriaBI = this.iface.cambiarDefinida(this.iface.definidaMemoriaBI,
		"Importe", "fdbBaseImponible");
	if (this.iface.definidaMemoriaBI >= 0) {
		var entrada:String = this.child("fdbBaseImponible").value().toString();
		entrada = this.iface.cambiarCalcular(entrada, this.iface.definidaMemoriaBI);
		this.child("fdbBaseImponible").setValue(entrada);
	}
}

/** \D Cambia el campo Definir de la Divisa según las variables memorizadas con anterioridad en PreMemorias

\end */
function oficial_tbnImporteme_click()
{
	this.iface.definidaMemoriaIme = this.iface.cambiarDefinida(this.iface.definidaMemoriaIme,
		"Importe", "fdbImporteme");
	if (this.iface.definidaMemoriaIme >= 0) {
		var entrada:String = this.child("fdbImporteme").value().toString();
		entrada = this.iface.cambiarCalcular(entrada, this.iface.definidaMemoriaIme);
		this.child("fdbImporteme").setValue(entrada);
	}
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
