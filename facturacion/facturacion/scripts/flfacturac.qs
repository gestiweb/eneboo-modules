/***************************************************************************
                 flfacturac.qs  -  description
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
	function beforeCommit_presupuestoscli(curPresupuesto:FLSqlCursor):Boolean {
		return this.ctx.interna_beforeCommit_presupuestoscli(curPresupuesto);
	}
	function beforeCommit_pedidoscli(curPedido:FLSqlCursor):Boolean {
		return this.ctx.interna_beforeCommit_pedidoscli(curPedido);
	}
	function beforeCommit_pedidosprov(curPedido:FLSqlCursor):Boolean {
		return this.ctx.interna_beforeCommit_pedidosprov(curPedido);
	}
	function beforeCommit_albaranescli(curAlbaran:FLSqlCursor):Boolean {
		return this.ctx.interna_beforeCommit_albaranescli(curAlbaran);
	}
	function beforeCommit_albaranesprov(curAlbaran:FLSqlCursor):Boolean {
		return this.ctx.interna_beforeCommit_albaranesprov(curAlbaran);
	}
	function beforeCommit_facturascli(curFactura:FLSqlCursor):Boolean {
		return this.ctx.interna_beforeCommit_facturascli(curFactura);
	}
	function beforeCommit_facturasprov(curFactura:FLSqlCursor):Boolean {
		return this.ctx.interna_beforeCommit_facturasprov(curFactura);
	}
	function afterCommit_pedidoscli(curPedido:FLSqlCursor):Boolean {
		return this.ctx.interna_afterCommit_pedidoscli(curPedido);
	}
	function afterCommit_albaranescli(curAlbaran:FLSqlCursor):Boolean {
		return this.ctx.interna_afterCommit_albaranescli(curAlbaran);
	}
	function afterCommit_albaranesprov(curAlbaran:FLSqlCursor):Boolean {
		return this.ctx.interna_afterCommit_albaranesprov(curAlbaran);
	}
	function afterCommit_facturascli(curFactura:FLSqlCursor):Boolean {
		return this.ctx.interna_afterCommit_facturascli(curFactura);
	}
	function afterCommit_facturasprov(curFactura:FLSqlCursor):Boolean {
		return this.ctx.interna_afterCommit_facturasprov(curFactura);
	}
	function afterCommit_lineasalbaranesprov(curLA:FLSqlCursor):Boolean {
		return this.ctx.interna_afterCommit_lineasalbaranesprov(curLA);
	}
	function afterCommit_lineasfacturasprov(curLF:FLSqlCursor):Boolean {
		return this.ctx.interna_afterCommit_lineasfacturasprov(curLF);
	}
	function afterCommit_lineaspedidoscli(curLA:FLSqlCursor):Boolean {
		return this.ctx.interna_afterCommit_lineaspedidoscli(curLA);
	}
	function afterCommit_lineaspedidosprov(curLA:FLSqlCursor):Boolean {
		return this.ctx.interna_afterCommit_lineaspedidosprov(curLA);
	}
	function afterCommit_lineasalbaranescli(curLA:FLSqlCursor):Boolean {
		return this.ctx.interna_afterCommit_lineasalbaranescli(curLA);
	}
	function afterCommit_lineasfacturascli(curLF:FLSqlCursor):Boolean {
		return this.ctx.interna_afterCommit_lineasfacturascli(curLF);
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var curAsiento_:FLSqlCursor;
	function oficial( context ) { interna( context ); }
	function obtenerHueco(codSerie:String, codEjercicio:String, tipo:String):Number {
		return this.ctx.oficial_obtenerHueco(codSerie, codEjercicio, tipo);
	}
	function establecerNumeroSecuencia(fN:String, value:Number):Number {
		return this.ctx.oficial_establecerNumeroSecuencia(fN, value);
	}
	function cerosIzquierda(numero:String, totalCifras:Number):String {
		return this.ctx.oficial_cerosIzquierda(numero, totalCifras);
	}
	function construirCodigo(codSerie:String, codEjercicio:String, numero:String):String {
		return this.ctx.oficial_construirCodigo(codSerie, codEjercicio, numero);
	}
	function siguienteNumero(codSerie:String, codEjercicio:String, fN:String):Number {
		return this.ctx.oficial_siguienteNumero(codSerie, codEjercicio, fN);
	}
	function agregarHueco(serie:String, ejercicio:String, numero:Number, fN:String):Boolean {
		return this.ctx.oficial_agregarHueco(serie, ejercicio, numero, fN);
	}
	function asientoBorrable(idAsiento:Number):Boolean {
		return this.ctx.oficial_asientoBorrable(idAsiento);
	}
	function generarAsientoFacturaCli(curFactura:FLSqlCursor):Boolean {
		return this.ctx.oficial_generarAsientoFacturaCli(curFactura);
	}
	function generarPartidasVenta(curFactura:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean {
		return this.ctx.oficial_generarPartidasVenta(curFactura, idAsiento, valoresDefecto);
	}
	function generarPartidasIVACli(curFactura:FLSqlCursor, idAsiento:Number, valoresDefecto:Array, ctaCliente:Array):Boolean {
		return this.ctx.oficial_generarPartidasIVACli(curFactura, idAsiento, valoresDefecto, ctaCliente);
	}
	function generarPartidasIRPF(curFactura:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean {
		return this.ctx.oficial_generarPartidasIRPF(curFactura, idAsiento, valoresDefecto);
	}
	function generarPartidasRecFinCli(curFactura:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean {
		return this.ctx.oficial_generarPartidasRecFinCli(curFactura, idAsiento, valoresDefecto);
	}
	function generarPartidasIRPFProv(curFactura:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean {
		return this.ctx.oficial_generarPartidasIRPFProv(curFactura, idAsiento, valoresDefecto);
	}
	function generarPartidasRecFinProv(curFactura:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean {
		return this.ctx.oficial_generarPartidasRecFinProv(curFactura, idAsiento, valoresDefecto);
	}
	function generarPartidasCliente(curFactura:FLSqlCursor, idAsiento:Number, valoresDefecto:Array, ctaCliente:Array):Boolean {
		return this.ctx.oficial_generarPartidasCliente(curFactura, idAsiento, valoresDefecto, ctaCliente);
	}
	function regenerarAsiento(cur:FLSqlCursor, valoresDefecto:Array):Array {
		return this.ctx.oficial_regenerarAsiento(cur, valoresDefecto);
	}
	function datosAsientoRegenerado(cur:FLSqlCursor, valoresDefecto:Array):Boolean {
		return this.ctx.oficial_datosAsientoRegenerado(cur, valoresDefecto);
	}
	function generarAsientoFacturaProv(curFactura:FLSqlCursor):Boolean {
		return this.ctx.oficial_generarAsientoFacturaProv(curFactura);
	}
	function generarPartidasCompra(curFactura:FLSqlCursor, idAsiento:Number, valoresDefecto:Array, concepto:String):Boolean {
		return this.ctx.oficial_generarPartidasCompra(curFactura, idAsiento, valoresDefecto, concepto);
	}
	function generarPartidasIVAProv(curFactura:FLSqlCursor, idAsiento:Number, valoresDefecto:Array, ctaProveedor:Array, concepto:String):Boolean {
		return this.ctx.oficial_generarPartidasIVAProv(curFactura, idAsiento, valoresDefecto, ctaProveedor, concepto);
	}
	function generarPartidasProveedor(curFactura:FLSqlCursor, idAsiento:Number, valoresDefecto:Array, ctaProveedor:Array, concepto:String, sinIVA:Boolean):Boolean {
		return this.ctx.oficial_generarPartidasProveedor(curFactura, idAsiento, valoresDefecto, ctaProveedor, concepto, sinIVA);
	}
	function datosCtaEspecial(ctaEsp:String, codEjercicio:String):Array {
		return this.ctx.oficial_datosCtaEspecial(ctaEsp, codEjercicio);
	}
	function datosCtaIVA(tipo:String, codEjercicio:String, codImpuesto:String):Array {
		return this.ctx.oficial_datosCtaIVA(tipo, codEjercicio, codImpuesto);
	}
	function datosCtaVentas(codEjercicio:String, codSerie:String):Array {
		return this.ctx.oficial_datosCtaVentas(codEjercicio, codSerie);
	}
	function datosCtaCliente(curFactura:FLSqlCursor, valoresDefecto:Array):Array {
		return this.ctx.oficial_datosCtaCliente(curFactura, valoresDefecto);
	}
	function datosCtaProveedor(curFactura:FLSqlCursor, valoresDefecto:Array):Array {
		return this.ctx.oficial_datosCtaProveedor(curFactura, valoresDefecto);
	}
	function asientoFacturaAbonoCli(curFactura:FLSqlCursor, valoresDefecto:Array){
		return this.ctx.oficial_asientoFacturaAbonoCli(curFactura, valoresDefecto);
	}
	function asientoFacturaAbonoProv(curFactura:FLSqlCursor, valoresDefecto:Array){
		return this.ctx.oficial_asientoFacturaAbonoProv(curFactura, valoresDefecto);
	}
	function datosDocFacturacion(fecha:String, codEjercicio:String, tipoDoc:String):Array {
		return this.ctx.oficial_datosDocFacturacion(fecha, codEjercicio, tipoDoc);
	}
	function tieneIvaDocCliente(codSerie:String, codCliente:String, codEjercicio:String):Number {
		return this.ctx.oficial_tieneIvaDocCliente(codSerie, codCliente, codEjercicio);
	}
	function tieneIvaDocProveedor(codSerie:String, codProveedor:String, codEjercicio:String):Number {
		return this.ctx.oficial_tieneIvaDocProveedor(codSerie, codProveedor, codEjercicio);
	}
	function automataActivado():Boolean {
		return this.ctx.oficial_automataActivado();
	}
	function comprobarRegularizacion(curFactura:FLSqlCursor):Boolean {
		return this.ctx.oficial_comprobarRegularizacion(curFactura);
	}
	function recalcularHuecos(serie:String, ejercicio:String, fN:String):Boolean {
		return this.ctx.oficial_recalcularHuecos(serie, ejercicio, fN);
	}
	function mostrarTraza(codigo:String, tipo:String) {
		return this.ctx.oficial_mostrarTraza(codigo, tipo);
	}
	function datosPartidaFactura(curPartida:FLSqlCursor, curFactura:FLSqlCursor, tipo:String, concepto:String) {
		return this.ctx.oficial_datosPartidaFactura(curPartida, curFactura, tipo, concepto);
	}
	function eliminarAsiento(idAsiento:String):Boolean {
		return this.ctx.oficial_eliminarAsiento(idAsiento);
	}
	function siGenerarRecibosCli(curFactura:FLSqlCursor, masCampos:Array):Boolean {
		return this.ctx.oficial_siGenerarRecibosCli(curFactura, masCampos);
	}
	function validarIvaRecargoCliente(codCliente:String,id:Number,tabla:String,identificador:String):Boolean {
		return this.ctx.oficial_validarIvaRecargoCliente(codCliente,id,tabla,identificador);
	}
	function validarIvaRecargoProveedor(codProveedor:String,id:Number,tabla:String,identificador:String):Boolean {
		return this.ctx.oficial_validarIvaRecargoProveedor(codProveedor,id,tabla,identificador);
	}
	function comprobarFacturaAbonoCli(curFactura:FLSqlCursor):Boolean {
		return this.ctx.oficial_comprobarFacturaAbonoCli(curFactura);
	}
	function consultarCtaEspecial(ctaEsp:String, codEjercicio:String):Boolean {
		return this.ctx.oficial_consultarCtaEspecial(ctaEsp, codEjercicio);
	}
	function crearCtaEspecial(codCtaEspecial:String, tipo:String, codEjercicio:String, desCta:String):Boolean {
		return this.ctx.oficial_crearCtaEspecial(codCtaEspecial, tipo, codEjercicio, desCta);
	}
	function comprobarCambioSerie(cursor:FLSqlCursor):Boolean {
		return this.ctx.oficial_comprobarCambioSerie(cursor);
	}
	function netoVentasFacturaCli(curFactura:FLSqlCursor):Number {
		return this.ctx.oficial_netoVentasFacturaCli(curFactura);
	}
	function netoComprasFacturaProv(curFactura:FLSqlCursor):Number {
		return this.ctx.oficial_netoComprasFacturaProv(curFactura);
	}
	function datosConceptoAsiento(cur:FLSqlCursor):Array {
		return this.ctx.oficial_datosConceptoAsiento(cur);
	}
	function subcuentaVentas(referencia:String, codEjercicio:String):Array {
		return this.ctx.oficial_subcuentaVentas(referencia, codEjercicio);
	}
	function regimenIVACliente(curDocCliente:FLSqlCursor):String {
		return this.ctx.oficial_regimenIVACliente(curDocCliente);
	}
// 	function liberarPedidosCli(curAlbaran:FLSqlCursor):Boolean {
// 		return this.ctx.oficial_liberarPedidosCli(curAlbaran);
// 	}
// 	function liberarPedidosProv(curAlbaran:FLSqlCursor):Boolean {
// 		return this.ctx.oficial_liberarPedidosProv(curAlbaran);
// 	}
	function restarCantidadCli(idLineaPedido:Number, idLineaAlbaran:Number):Boolean {
		return this.ctx.oficial_restarCantidadCli(idLineaPedido, idLineaAlbaran);
	}
	function restarCantidadProv(idLineaPedido:Number, idLineaAlbaran:Number):Boolean {
		return this.ctx.oficial_restarCantidadProv(idLineaPedido, idLineaAlbaran);
	}
	function actualizarPedidosCli(curAlbaran:FLSqlCursor):Boolean {
		return this.ctx.oficial_actualizarPedidosCli(curAlbaran);
	}
	function actualizarPedidosProv(curAlbaran:FLSqlCursor):Boolean {
		return this.ctx.oficial_actualizarPedidosProv(curAlbaran);
	}
	function actualizarLineaPedidoProv(idLineaPedido:Number, idPedido:Number, referencia:String, idAlbaran:Number, cantidadLineaAlbaran:Number):Boolean {
		return this.ctx.oficial_actualizarLineaPedidoProv(idLineaPedido, idPedido, referencia, idAlbaran, cantidadLineaAlbaran);
	}
	function actualizarEstadoPedidoProv(idPedido:Number, curAlbaran:FLSqlCursor):Boolean {
		return this.ctx.oficial_actualizarEstadoPedidoProv(idPedido, curAlbaran);
	}
	function obtenerEstadoPedidoProv(idPedido:Number):String {
		return this.ctx.oficial_obtenerEstadoPedidoProv(idPedido);
	}
	function actualizarLineaPedidoCli(idLineaPedido:Number, idPedido:Number, referencia:String, idAlbaran:Number, cantidadLineaAlbaran:Number):Boolean {
		return this.ctx.oficial_actualizarLineaPedidoCli(idLineaPedido, idPedido, referencia, idAlbaran, cantidadLineaAlbaran);
	}
	function actualizarEstadoPedidoCli(idPedido:Number, curAlbaran:FLSqlCursor):Boolean {
		return this.ctx.oficial_actualizarEstadoPedidoCli(idPedido, curAlbaran);
	}
	function obtenerEstadoPedidoCli(idPedido:Number):String {
		return this.ctx.oficial_obtenerEstadoPedidoCli(idPedido);
	}
	function liberarAlbaranesCli(idFactura:Number):Boolean {
		return this.ctx.oficial_liberarAlbaranesCli(idFactura);
	}
	function liberarAlbaranCli(idAlbaran:Number):Boolean {
		return this.ctx.oficial_liberarAlbaranCli(idAlbaran);
	}
	function liberarAlbaranesProv(idFactura:Number):Boolean {
		return this.ctx.oficial_liberarAlbaranesProv(idFactura);
	}
	function liberarAlbaranProv(idAlbaran:Number):Boolean {
		return this.ctx.oficial_liberarAlbaranProv(idAlbaran);
	}
	function liberarPresupuestoCli(idPresupuesto:Number):Boolean {
		return this.ctx.oficial_liberarPresupuestoCli(idPresupuesto);
	}
	function actualizarPedidosLineaAlbaranCli(curLA:FLSqlCursor):Boolean {
		return this.ctx.oficial_actualizarPedidosLineaAlbaranCli(curLA);
	}
	function actualizarPedidosLineaAlbaranProv(curLA:FLSqlCursor):Boolean {
		return this.ctx.oficial_actualizarPedidosLineaAlbaranProv(curLA);
	}
	function aplicarComisionLineas(codAgente:String,tblHija:String,where:String):Boolean {
		return this.ctx.oficial_aplicarComisionLineas(codAgente,tblHija,where);
	}
	function calcularComisionLinea(codAgente:String,referencia:String):Number {
		return this.ctx.oficial_calcularComisionLinea(codAgente,referencia);
	}
	function arrayCostesAfectados(arrayInicial:Array, arrayFinal:Array):Array {
		return this.ctx.oficial_arrayCostesAfectados(arrayInicial, arrayFinal);
	}
	function compararArrayCoste(a:Array, b:Array):Number {
		return this.ctx.oficial_compararArrayCoste(a, b);
	}
	function esSubcuentaEspecial(codSubcuenta:String, codEjercicio:String, idTipoEsp:String):Boolean {
		return this.ctx.oficial_esSubcuentaEspecial(codSubcuenta, codEjercicio, idTipoEsp);
	}
	function campoImpuesto(campo:String, codImpuesto:String, fecha:String):Number {
		return this.ctx.oficial_campoImpuesto(campo, codImpuesto, fecha);
	}
	function datosImpuesto(codImpuesto:String, fecha:String):Array {
		return this.ctx.oficial_datosImpuesto(codImpuesto, fecha);
	}
	function valorDefecto(fN:String):String {
		return this.ctx.oficial_valorDefecto(fN);
	}
	function formateaCadena(cIn:String):String {
		return this.ctx.oficial_formateaCadena(cIn);
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
	function pub_cerosIzquierda(numero:String, totalCifras:Number):String {
		return this.cerosIzquierda(numero, totalCifras);
	}
	function pub_asientoBorrable(idAsiento:Number):Boolean {
		return this.asientoBorrable(idAsiento);
	}
	function pub_regenerarAsiento(cur:FLSqlCursor, valoresDefecto:Array):Array {
		return this.regenerarAsiento(cur, valoresDefecto);
	}
	function pub_datosCtaEspecial(ctaEsp:String, codEjercicio:String):Array {
		return this.datosCtaEspecial(ctaEsp, codEjercicio);
	}
	function pub_siguienteNumero(codSerie:String, codEjercicio:String, fN:String):Number {
		return this.siguienteNumero(codSerie, codEjercicio, fN);
	}
	function pub_construirCodigo(codSerie:String, codEjercicio:String, numero:String):String {
		return this.construirCodigo(codSerie, codEjercicio, numero);
	}
	function pub_agregarHueco(serie:String, ejercicio:String, numero:Number, fN:String):Boolean {
		return this.agregarHueco(serie, ejercicio, numero, fN);
	}
	function pub_datosDocFacturacion(fecha:String, codEjercicio:String, tipoDoc:String):Array {
		return this.datosDocFacturacion(fecha, codEjercicio, tipoDoc);
	}
	function pub_tieneIvaDocCliente(codSerie:String, codCliente:String, codEjercicio:String):Number {
		return this.tieneIvaDocCliente(codSerie, codCliente, codEjercicio);
	}
	function pub_tieneIvaDocProveedor(codSerie:String, codProveedor:String, codEjercicio:String):Number {
		return this.tieneIvaDocProveedor(codSerie, codProveedor, codEjercicio);
	}
	function pub_automataActivado():Boolean {
		return this.automataActivado();
	}
	function pub_generarAsientoFacturaCli(curFactura:FLSqlCursor):Boolean {
		return this.generarAsientoFacturaCli(curFactura);
	}
	function pub_generarAsientoFacturaProv(curFactura:FLSqlCursor):Boolean {
		return this.generarAsientoFacturaProv(curFactura);
	}
	function pub_mostrarTraza(codigo:String, tipo:String) {
		return this.mostrarTraza(codigo, tipo);
	}
	function pub_eliminarAsiento(idAsiento:String):Boolean {
		return this.eliminarAsiento(idAsiento);
	}
	function pub_validarIvaRecargoCliente(codCliente:String,id:Number,tabla:String,identificador:String):Boolean {
		return this.validarIvaRecargoCliente(codCliente,id,tabla,identificador);
	}
	function pub_validarIvaRecargoProveedor(codProveedor:String,id:Number,tabla:String,identificador:String):Boolean {
		return this.validarIvaRecargoProveedor(codProveedor,id,tabla,identificador);
	}
	function pub_subcuentaVentas(referencia:String, codEjercicio:String):Array {
		return this.subcuentaVentas(referencia, codEjercicio);
	}
	function pub_regimenIVACliente(curDocCliente:FLSqlCursor):String {
		return this.regimenIVACliente(curDocCliente);
	}
	function pub_actualizarEstadoPedidoCli(idPedido:Number, curAlbaran:FLSqlCursor):Boolean {
		return this.actualizarEstadoPedidoCli(idPedido, curAlbaran);
	}
	function pub_actualizarEstadoPedidoProv(idPedido:Number, curAlbaran:FLSqlCursor):Boolean {
		return this.actualizarEstadoPedidoProv(idPedido, curAlbaran);
	}
	function pub_aplicarComisionLineas(codAgente:String,tblHija:String,where:String):Boolean {
		return this.aplicarComisionLineas(codAgente,tblHija,where);
	}
	function pub_calcularComisionLinea(codAgente:String,referencia:String):Number {
		return this.calcularComisionLinea(codAgente,referencia);
	}
	function pub_arrayCostesAfectados(arrayInicial:Array, arrayFinal:Array):Array {
		return this.arrayCostesAfectados(arrayInicial, arrayFinal);
	}
	function pub_campoImpuesto(campo:String, codImpuesto:String, fecha:String):Number {
		return this.campoImpuesto(campo, codImpuesto, fecha);
	}
	function pub_datosImpuesto(codImpuesto:String, fecha:String):Array {
		return this.datosImpuesto(codImpuesto, fecha);
	}
	function pub_formateaCadena(cIn:String):String {
		return this.formateaCadena(cIn);
	}
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
Se calcula el número del pedido como el siguiente de la secuencia asociada a su ejercicio y serie.

Se actualiza el estado del pedido.

Si el pedido está servido parcialmente y se quiere borrar, no se permite borrarlo o se dá la opción de cancelar lo pendiente de servir.
\end */
function interna_beforeCommit_pedidoscli(curPedido:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	var numero:String;

	switch (curPedido.modeAccess()) {
		case curPedido.Insert: {
			if (!flfactppal.iface.pub_clienteActivo(curPedido.valueBuffer("codcliente"), curPedido.valueBuffer("fecha")))
				return false;
			if (curPedido.valueBuffer("numero") == 0) {
				numero = this.iface.siguienteNumero(curPedido.valueBuffer("codserie"), curPedido.valueBuffer("codejercicio"), "npedidocli");
				if (!numero)
					return false;
				curPedido.setValueBuffer("numero", numero);
				curPedido.setValueBuffer("codigo", formpedidoscli.iface.pub_commonCalculateField("codigo", curPedido));
			}
			break;
		}
		case curPedido.Edit: {
			if(!this.iface.comprobarCambioSerie(curPedido))
				return false;
			if (!flfactppal.iface.pub_clienteActivo(curPedido.valueBuffer("codcliente"), curPedido.valueBuffer("fecha")))
				return false;
			if (curPedido.valueBuffer("servido") == "Parcial") {
				var estado:String = this.iface.obtenerEstadoPedidoCli(curPedido.valueBuffer("idpedido"));
				if (estado == "Sí") {
					curPedido.setValueBuffer("servido", estado);
					curPedido.setValueBuffer("editable", false);
				}
			}
			break;
		}
		case curPedido.Del: {
			if (curPedido.valueBuffer("servido") == "Parcial") {
				MessageBox.warning(util.translate("scripts", "No se puede eliminar un pedido servido parcialmente.\nDebe borrar antes el albarán relacionado."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				return false;
			}
			break;
		}
	}

	return true;
}

/** \C
Si se borra la linea de albarán se actualiza la línea y el estado del pedido asociado a la misma.
\end */
function interna_beforeCommit_lineasalbaranescli(curLinea:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();

	switch (curLinea.modeAccess()) {
		case curLinea.Del: {
			break;
		}
	}
	return true;
}


/** \C
Se calcula el número del pedido como el siguiente de la secuencia asociada a su ejercicio y serie.

Se actualiza el estado del pedido.

Si el pedido está servido parcialmente y se quiere borrar, no se permite borrarlo o se dá la opción de cancelar lo pendiente de servir.
\end */
function interna_beforeCommit_pedidosprov(curPedido:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	var numero:String;

	switch (curPedido.modeAccess()) {
		case curPedido.Insert: {
			if (curPedido.valueBuffer("numero") == 0) {
				numero = this.iface.siguienteNumero(curPedido.valueBuffer("codserie"), curPedido.valueBuffer("codejercicio"), "npedidoprov");
				if (!numero)
					return false;
				curPedido.setValueBuffer("numero", numero);
				curPedido.setValueBuffer("codigo", formpedidosprov.iface.pub_commonCalculateField("codigo", curPedido));
			}
			break;
		}
		case curPedido.Edit: {
			if(!this.iface.comprobarCambioSerie(curPedido))
				return false;
			if (curPedido.valueBuffer("servido") == "Parcial") {
				var estado:String = this.iface.obtenerEstadoPedidoProv(curPedido.valueBuffer("idpedido"));
				if (estado == "Sí") {
					curPedido.setValueBuffer("servido", estado);
					curPedido.setValueBuffer("editable", false);
					if (sys.isLoadedModule("flcolaproc")) {
						if (!flfactppal.iface.pub_lanzarEvento(curPedido, "pedidoProvAlbaranado"))
							return false;
					}
				}
			}
			break;
		}
		case curPedido.Del: {
			if (curPedido.valueBuffer("servido") == "Parcial") {
				MessageBox.warning(util.translate("scripts", "No se puede eliminar un pedido servido parcialmente.\nDebe borrar antes el albarán relacionado."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				return false;
			}
			break;
		}
	}
	return true;
}

/* \C En el caso de que el módulo de contabilidad esté cargado y activado, genera o modifica el asiento contable correspondiente a la factura a cliente.
\end */
function interna_beforeCommit_facturascli(curFactura:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	var numero:String;

	if (curFactura.modeAccess() == curFactura.Insert || curFactura.modeAccess() == curFactura.Edit) {
		if (!this.iface.comprobarFacturaAbonoCli(curFactura)) {
			return false;
		}
	}

	switch (curFactura.modeAccess()) {
		case curFactura.Insert: {
			if (!flfactppal.iface.pub_clienteActivo(curFactura.valueBuffer("codcliente"), curFactura.valueBuffer("fecha")))
				return false;
			if (curFactura.valueBuffer("numero") == 0) {
				this.iface.recalcularHuecos( curFactura.valueBuffer("codserie"), curFactura.valueBuffer("codejercicio"), "nfacturacli" );
				numero = this.iface.siguienteNumero(curFactura.valueBuffer("codserie"), curFactura.valueBuffer("codejercicio"), "nfacturacli");
				if (!numero)
					return false;
				curFactura.setValueBuffer("numero", numero);
				curFactura.setValueBuffer("codigo", formfacturascli.iface.pub_commonCalculateField("codigo", curFactura));
			}
			break;
		}
		case curFactura.Edit: {
			if(!this.iface.comprobarCambioSerie(curFactura))
				return false;
			if (!flfactppal.iface.pub_clienteActivo(curFactura.valueBuffer("codcliente"), curFactura.valueBuffer("fecha")))
				return false;
			break;
		}
	}

	if (curFactura.modeAccess() == curFactura.Insert || curFactura.modeAccess() == curFactura.Edit) {
		if (util.sqlSelect("facturascli", "idfactura", "codejercicio = '" + curFactura.valueBuffer("codejercicio") + "' AND codserie = '" + curFactura.valueBuffer("codserie") + "' AND numero = '" + curFactura.valueBuffer("numero") + "' AND idfactura <> " + curFactura.valueBuffer("idfactura"))) {
			numero = this.iface.siguienteNumero(curFactura.valueBuffer("codserie"), curFactura.valueBuffer("codejercicio"), "nfacturacli");
			if (!numero)
				return false;
			curFactura.setValueBuffer("numero", numero);
			curFactura.setValueBuffer("codigo", formfacturascli.iface.pub_commonCalculateField("codigo", curFactura));
		}
	}

	if (curFactura.modeAccess() == curFactura.Edit) {
		if (!formRecordfacturascli.iface.pub_actualizarLineasIva(curFactura)) {
			return false;
		}
	}

	if (curFactura.modeAccess() == curFactura.Insert || curFactura.modeAccess() == curFactura.Edit) {
		if (sys.isLoadedModule("flcontppal") && flfactppal.iface.pub_valorDefectoEmpresa("contintegrada")) {
			if (this.iface.generarAsientoFacturaCli(curFactura) == false) {
				return false;
			}
		}
	}
	return true;
}

/* \C En el caso de que el módulo de contabilidad esté cargado y activado, genera o modifica el asiento contable correspondiente a la factura a proveedor.
\end */
function interna_beforeCommit_facturasprov(curFactura:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	var numero:String;

	if (curFactura.valueBuffer("deabono") == true) {
		if (!curFactura.valueBuffer("idfacturarect")){
			MessageBox.warning(util.translate("scripts", "Debe seleccionar la factura que desea abonar"),MessageBox.Ok, MessageBox.NoButton,MessageBox.NoButton);
			return false;
		}
		if (util.sqlSelect("facturasprov", "idfacturarect", "idfacturarect = " + curFactura.valueBuffer("idfacturarect") + " AND idfactura <> " + curFactura.valueBuffer("idfactura"))) {
			MessageBox.warning(util.translate("scripts", "La factura ") +  util.sqlSelect("facturasprov", "codigo", "idfactura = " + curFactura.valueBuffer("idFacturarect"))  + util.translate("scripts", " ya está abonada"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}

	if (curFactura.modeAccess() == curFactura.Edit) {
		if (!this.iface.comprobarCambioSerie(curFactura)) {
			return false;
		}
	}
	if (curFactura.modeAccess() == curFactura.Insert) {
		if (curFactura.valueBuffer("numero") == 0) {
			this.iface.recalcularHuecos( curFactura.valueBuffer("codserie"), curFactura.valueBuffer("codejercicio"), "nfacturaprov" );
			numero = this.iface.siguienteNumero(curFactura.valueBuffer("codserie"), curFactura.valueBuffer("codejercicio"), "nfacturaprov");
			if (!numero)
				return false;
			curFactura.setValueBuffer("numero", numero);
			curFactura.setValueBuffer("codigo", formfacturasprov.iface.pub_commonCalculateField("codigo", curFactura));
		}
	}

	if (curFactura.modeAccess() == curFactura.Insert || curFactura.modeAccess() == curFactura.Edit) {
		if (util.sqlSelect("facturasprov", "idfactura", "codejercicio = '" + curFactura.valueBuffer("codejercicio") + "' AND codserie = '" + curFactura.valueBuffer("codserie") + "' AND numero = '" + curFactura.valueBuffer("numero") + "' AND idfactura <> " + curFactura.valueBuffer("idfactura"))) {
			numero = this.iface.siguienteNumero(curFactura.valueBuffer("codserie"), curFactura.valueBuffer("codejercicio"), "nfacturaprov");
			if (!numero)
				return false;
			curFactura.setValueBuffer("numero", numero);
			curFactura.setValueBuffer("codigo", formfacturasprov.iface.pub_commonCalculateField("codigo", curFactura));
		}
	}

	if (curFactura.modeAccess() == curFactura.Edit) {
		if (!formRecordfacturasprov.iface.pub_actualizarLineasIva(curFactura)) {
			return false;
		}
	}

	if (curFactura.modeAccess() == curFactura.Insert || curFactura.modeAccess() == curFactura.Edit) {
		if (sys.isLoadedModule("flcontppal") && flfactppal.iface.pub_valorDefectoEmpresa("contintegrada")) {
			if (this.iface.generarAsientoFacturaProv(curFactura) == false) {
				return false;
			}
		}
	}
	return true;
}


/* \C Se calcula el número del albarán como el siguiente de la secuencia asociada a su ejercicio y serie.
Se recalcula el estado de los pedidos asociados al albarán
\end */
function interna_beforeCommit_albaranescli(curAlbaran:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	var numero:String;

	switch (curAlbaran.modeAccess()) {
		case curAlbaran.Insert: {
			if (!flfactppal.iface.pub_clienteActivo(curAlbaran.valueBuffer("codcliente"), curAlbaran.valueBuffer("fecha")))
				return false;
			if (curAlbaran.valueBuffer("numero") == 0) {
				numero = this.iface.siguienteNumero(curAlbaran.valueBuffer("codserie"), curAlbaran.valueBuffer("codejercicio"), "nalbarancli");
				if (!numero)
					return false;
				curAlbaran.setValueBuffer("numero", numero);
				curAlbaran.setValueBuffer("codigo", formalbaranescli.iface.pub_commonCalculateField("codigo", curAlbaran));
			}
			break;
		}
		case curAlbaran.Edit: {
			if(!this.iface.comprobarCambioSerie(curAlbaran)) {
				return false;
			}
			if (!flfactppal.iface.pub_clienteActivo(curAlbaran.valueBuffer("codcliente"), curAlbaran.valueBuffer("fecha"))) {
				return false;
			}
// 			if(!this.iface.actualizarPedidosCli(curAlbaran)) {
// 				return false;
// 			}
			break;
		}
		case curAlbaran.Del: {
			break;
		}
	}

	return true;
}

/** \C Si el albarán se borra se actualizan los pedidos asociados
\end */
function interna_afterCommit_albaranescli(curAlbaran:FLSqlCursor):Boolean
{
	switch (curAlbaran.modeAccess()) {
		case curAlbaran.Del: {
// 			if (!this.iface.liberarPedidosCli(curAlbaran)) {
// 				return false;
// 			}
			break;
		}
	}
	return true;
}

/** \C Si el albarán se borra se actualizan los pedidos asociados
\end */
function interna_afterCommit_albaranesprov(curAlbaran:FLSqlCursor):Boolean
{
	switch (curAlbaran.modeAccess()) {
		case curAlbaran.Del: {
// 			if (!this.iface.liberarPedidosProv(curAlbaran)) {
// 				return false;
// 			}
			break;
		}
	}
	return true;
}


/* \C Se calcula el número del albarán como el siguiente de la secuencia asociada a su ejercicio y serie.

Se recalcula el estado de los pedidos asociados al albarán
\end */
function interna_beforeCommit_albaranesprov(curAlbaran:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	var numero:String;

	switch (curAlbaran.modeAccess()) {
		case curAlbaran.Insert: {
			if (curAlbaran.valueBuffer("numero") == 0) {
				numero = this.iface.siguienteNumero(curAlbaran.valueBuffer("codserie"), curAlbaran.valueBuffer("codejercicio"), "nalbaranprov");
				if (!numero)
					return false;
				curAlbaran.setValueBuffer("numero", numero);
				curAlbaran.setValueBuffer("codigo", formalbaranesprov.iface.pub_commonCalculateField("codigo", curAlbaran));
			}
			break;
		}
		case curAlbaran.Edit: {
			if (!this.iface.comprobarCambioSerie(curAlbaran)) {
				return false;
			}
// 			if (!this.iface.actualizarPedidosProv(curAlbaran)) {
// 				return false;
// 			}
			break;
		}
	}

	return true;
}

/* \C Se calcula el número del presupuesto como el siguiente de la secuencia asociada a su ejercicio y serie.
\end */
function interna_beforeCommit_presupuestoscli(curPresupuesto:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	var numero:String;

	switch (curPresupuesto.modeAccess()) {
		case curPresupuesto.Insert: {
			if (!flfactppal.iface.pub_clienteActivo(curPresupuesto.valueBuffer("codcliente"), curPresupuesto.valueBuffer("fecha")))
				return false;
			if (curPresupuesto.valueBuffer("numero") == 0) {
				numero = this.iface.siguienteNumero(curPresupuesto.valueBuffer("codserie"), curPresupuesto.valueBuffer("codejercicio"), "npresupuestocli");
				if (!numero)
					return false;
				curPresupuesto.setValueBuffer("numero", numero);
				curPresupuesto.setValueBuffer("codigo", formpresupuestoscli.iface.pub_commonCalculateField("codigo", curPresupuesto));
			}
			break;
		}
		case curPresupuesto.Edit: {
			if(!this.iface.comprobarCambioSerie(curPresupuesto))
				return false;
			if (!flfactppal.iface.pub_clienteActivo(curPresupuesto.valueBuffer("codcliente"), curPresupuesto.valueBuffer("fecha")))
				return false;
			break;
		}
	}

	return true;
}

/** \C Si el pedido se borra se actualiza el presupuesto asociado
\end */
function interna_afterCommit_pedidoscli(curPedido:FLSqlCursor):Boolean
{
	switch (curPedido.modeAccess()) {
		case curPedido.Del: {
			if (!this.iface.liberarPresupuestoCli(curPedido.valueBuffer("idpresupuesto"))) {
				return false;
			}
			break;
		}
	}
	return true;
}

/* \C En el caso de que el módulo de tesorería esté cargado, genera o modifica los recibos correspondientes a la factura.

En el caso de que el módulo pincipal de contabilidad esté cargado y activado, y que la acción a realizar sea la de borrado de la factura, borra el asiento contable correspondiente.
\end */
function interna_afterCommit_facturascli(curFactura:FLSqlCursor):Boolean
{
	switch (curFactura.modeAccess()) {
		case curFactura.Del: {
			if (!this.iface.agregarHueco(curFactura.valueBuffer("codserie"), curFactura.valueBuffer("codejercicio"), curFactura.valueBuffer("numero"), "nfacturacli")) {
				return false;
			}
			if (!this.iface.liberarAlbaranesCli(curFactura.valueBuffer("idfactura"))) {
				return false;
			}
			break;
		}
	}

	var util:FLUtil = new FLUtil();
	if (sys.isLoadedModule("flfactteso") && curFactura.valueBuffer("tpv") == false) {
		if (curFactura.modeAccess() == curFactura.Insert || curFactura.modeAccess() == curFactura.Edit) {
			if (this.iface.siGenerarRecibosCli(curFactura))
				if (flfactteso.iface.pub_regenerarRecibosCli(curFactura) == false)
					return false;
		}
		if (curFactura.modeAccess() == curFactura.Del) {
			flfactteso.iface.pub_actualizarRiesgoCliente(curFactura.valueBuffer("codcliente"));
		}
	}

	if (sys.isLoadedModule("flcontppal") && flfactppal.iface.pub_valorDefectoEmpresa("contintegrada")) {
		switch (curFactura.modeAccess()) {
			case curFactura.Edit: {
				if (curFactura.valueBuffer("nogenerarasiento")) {
					var idAsientoAnterior:String = curFactura.valueBufferCopy("idasiento");
					if (idAsientoAnterior && idAsientoAnterior != "") {
						if (!this.iface.eliminarAsiento(idAsientoAnterior)) {
							return false;
						}
					}
				}
				break;
			}
			case curFactura.Del: {
				if (!this.iface.eliminarAsiento(curFactura.valueBuffer("idasiento"))) {
					return false;
				}
				break;
			}
		}
	}

	return true;
}

/* \C En el caso de que el módulo pincipal de contabilidad esté cargado y activado, y que la acción a realizar sea la de borrado de la factura, borra el asiento contable correspondiente.
\end */
function interna_afterCommit_facturasprov(curFactura:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	if (sys.isLoadedModule("flfactteso")) {
		if (curFactura.modeAccess() == curFactura.Insert || curFactura.modeAccess() == curFactura.Edit) {
			if (curFactura.valueBuffer("total") != curFactura.valueBufferCopy("total")
				|| curFactura.valueBuffer("codproveedor") != curFactura.valueBufferCopy("codproveedor")
				|| curFactura.valueBuffer("codpago") != curFactura.valueBufferCopy("codpago")
				|| curFactura.valueBuffer("fecha") != curFactura.valueBufferCopy("fecha")) {
				if (flfactteso.iface.pub_regenerarRecibosProv(curFactura) == false)
					return false;
			}
		}
	}

	switch (curFactura.modeAccess()) {
		case curFactura.Del: {
			if (!this.iface.liberarAlbaranesProv(curFactura.valueBuffer("idfactura"))) {
				return false;
			}
			break;
		}
	}

	if (sys.isLoadedModule("flcontppal") && flfactppal.iface.pub_valorDefectoEmpresa("contintegrada")) {
		switch (curFactura.modeAccess()) {
			case curFactura.Edit: {
				if (curFactura.valueBuffer("nogenerarasiento")) {
					var idAsientoAnterior:String = curFactura.valueBufferCopy("idasiento");
					if (idAsientoAnterior && idAsientoAnterior != "") {
						if (!this.iface.eliminarAsiento(idAsientoAnterior))
							return false;
					}
				}
				break;
			}
			case curFactura.Del: {
				if (!this.iface.eliminarAsiento(curFactura.valueBuffer("idasiento"))) {
					return false;
				}
				break;
			}
		}
	}
	return true;
}

/** \C
Actualización del stock correspondiente al artículo seleccionado en la línea
\end */
function interna_afterCommit_lineasalbaranesprov(curLA:FLSqlCursor):Boolean
{
	if (!this.iface.actualizarPedidosLineaAlbaranProv(curLA)) {
		return false;
	}

	if (sys.isLoadedModule("flfactalma")) {
		if (!flfactalma.iface.pub_controlStockAlbaranesProv(curLA)) {
			return false;
		}
	}
	return true;
}

/** \C
En el caso de que la factura no sea automática (no provenga de un albarán), realiza la actualización del stock correspondiente al artículo seleccionado en la línea.

Actualiza también el coste medio de los artículos afectados por el cambio.
\end */
function interna_afterCommit_lineasfacturasprov(curLF:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();

	if (sys.isLoadedModule("flfactalma")) {
		if (!flfactalma.iface.pub_controlStockFacturasProv(curLF)) {
			return false;
		}
	}
	return true;
}

/** \C
Actualiza el stock correspondiente al artículo seleccionado en la línea si el sistema
está configurado para ello
\end */
function interna_afterCommit_lineaspedidoscli(curLP:FLSqlCursor):Boolean
{
 	if (sys.isLoadedModule("flfactalma"))
		if (!flfactalma.iface.pub_controlStockPedidosCli(curLP))
			return false;

	return true;
}

/** \C
Actualiza el stock correspondiente al artículo seleccionado en la línea si el sistema
está configurado para ello
\end */
function interna_afterCommit_lineaspedidosprov(curLP:FLSqlCursor):Boolean
{
 	if (sys.isLoadedModule("flfactalma")) {
		if (!flfactalma.iface.pub_controlStockPedidosProv(curLP)) {
			return false;
		}
	}
	return true;
}

/** \C
Si la línea de albarán no proviene de una línea de pedido, realiza la actualización del stock correspondiente al artículo seleccionado en la línea
\end */
function interna_afterCommit_lineasalbaranescli(curLA:FLSqlCursor):Boolean
{
	if (!this.iface.actualizarPedidosLineaAlbaranCli(curLA)) {
		return false;
	}

	if (sys.isLoadedModule("flfactalma")) {
		if (!flfactalma.iface.pub_controlStockAlbaranesCli(curLA)) {
			return false;
		}
	}

	return true;
}

/** \C
En el caso de que la factura no sea automática (no provenga de un albarán), realiza la actualización del stock correspondiente al artículo seleccionado en la línea
\end */
function interna_afterCommit_lineasfacturascli(curLF:FLSqlCursor):Boolean
{
	if (sys.isLoadedModule("flfactalma"))
		if (!flfactalma.iface.pub_controlStockFacturasCli(curLF))
			return false;

	return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_actualizarPedidosLineaAlbaranCli(curLA:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	var idLineaPedido:Number = parseFloat(curLA.valueBuffer("idlineapedido"));
	if (idLineaPedido == 0) {
		return true;
	}

	switch (curLA.modeAccess()) {
		case curLA.Insert: {
			if (!this.iface.actualizarLineaPedidoCli(curLA.valueBuffer("idlineapedido"), curLA.valueBuffer("idpedido") , curLA.valueBuffer("referencia"), curLA.valueBuffer("idalbaran"), curLA.valueBuffer("cantidad"))) {
				return false;
			}
			if (!this.iface.actualizarEstadoPedidoCli(curLA.valueBuffer("idpedido"), curLA)) {
				return false;
			}
			break;
		}
		case curLA.Edit: {
			if (curLA.valueBuffer("cantidad") != curLA.valueBufferCopy("cantidad")) {
				if (!this.iface.actualizarLineaPedidoCli(curLA.valueBuffer("idlineapedido"), curLA.valueBuffer("idpedido") , curLA.valueBuffer("referencia"), curLA.valueBuffer("idalbaran"), curLA.valueBuffer("cantidad"))) {
					return false;
				}
				if (!this.iface.actualizarEstadoPedidoCli(curLA.valueBuffer("idpedido"), curLA)) {
					return false;
				}
			}
			break;
		}
		case curLA.Del: {
			var idPedido:Number = curLA.valueBuffer("idpedido");
			var idLineaAlbaran:Number = curLA.valueBuffer("idlinea");
			if (!this.iface.restarCantidadCli(idLineaPedido, idLineaAlbaran)) {
				return false;
			}
			this.iface.actualizarEstadoPedidoCli(idPedido);
			break;
		}
	}
	return true;
}

function oficial_actualizarPedidosLineaAlbaranProv(curLA:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;

	var idLineaPedido:Number = parseFloat(curLA.valueBuffer("idlineapedido"));
	if (idLineaPedido == 0) {
		return true;
	}

	switch (curLA.modeAccess()) {
		case curLA.Insert: {
			if (!this.iface.actualizarLineaPedidoProv(curLA.valueBuffer("idlineapedido"), curLA.valueBuffer("idpedido") , curLA.valueBuffer("referencia"), curLA.valueBuffer("idalbaran"), curLA.valueBuffer("cantidad"))) {
				return false;
			}
			if (!this.iface.actualizarEstadoPedidoProv(curLA.valueBuffer("idpedido"), curLA)) {
				return false;
			}
			break;
		}
		case curLA.Edit: {
			if (curLA.valueBuffer("cantidad") != curLA.valueBufferCopy("cantidad")) {
				if (!this.iface.actualizarLineaPedidoProv(curLA.valueBuffer("idlineapedido"), curLA.valueBuffer("idpedido") , curLA.valueBuffer("referencia"), curLA.valueBuffer("idalbaran"), curLA.valueBuffer("cantidad"))) {
					return false;
				}
				if (!this.iface.actualizarEstadoPedidoProv(curLA.valueBuffer("idpedido"), curLA)) {
					return false;
				}
			}
			break;
		}
		case curLA.Del: {
			var idPedido:Number = curLA.valueBuffer("idpedido");
			var idLineaAlbaran:Number = curLA.valueBuffer("idlinea");
			if (!this.iface.restarCantidadProv(idLineaPedido, idLineaAlbaran)) {
				return false;
			}
			this.iface.actualizarEstadoPedidoProv(idPedido);
			break;
		}
	}
	return true;
}

/** \D
Obtiene el primer hueco de la tabla de huecos (documentos de facturación que han sido borrados y han dejado su código disponible para volver a ser usado)
@param codSerie: Código de serie del documento
@param codEjercicio: Código de ejercicio del documento
@param tipo: Tipo de documento (factura a cliente, a proveedor)
@return Número correspondiente al primer hueco encontrado (0 si no se encuentra ninguno)
\end */
function oficial_obtenerHueco(codSerie:String, codEjercicio:String, tipo:String):Number
{
	var cursorHuecos:FLSqlCursor = new FLSqlCursor("huecos");
	var numHueco:Number = 0;
	cursorHuecos.select("upper(codserie)='" + codSerie + "' AND upper(codejercicio)='" + codEjercicio + "' AND upper(tipo)='" + tipo + "' ORDER BY numero;");
	if (cursorHuecos.next()) {
		numHueco = cursorHuecos.valueBuffer("numero");
		cursorHuecos.setActivatedCheckIntegrity(false);
		cursorHuecos.setModeAccess(cursorHuecos.Del);
		cursorHuecos.refreshBuffer();
		cursorHuecos.commitBuffer();
	}
	return numHueco;
}

function oficial_establecerNumeroSecuencia(fN:String, value:Number):Number
{
	return (parseFloat(value) + 1);
}

/** \D
Rellena un string con ceros a la izquierda hasta completar la logitud especificada
@param numero: String que contiene el número
@param totalCifras: Longitud a completar
\end */
function oficial_cerosIzquierda(numero:String, totalCifras:Number):String
{
	var ret:String = numero.toString();
	var numCeros:Number = totalCifras - ret.length;
	for ( ; numCeros > 0 ; --numCeros)
		ret = "0" + ret;
	return ret;
}

function oficial_construirCodigo(codSerie:String, codEjercicio:String, numero:String):String
{
	return this.iface.cerosIzquierda(codEjercicio, 4) +
		this.iface.cerosIzquierda(codSerie, 2) +
		this.iface.cerosIzquierda(numero, 6);
}

/** \D
Obtiene el siguiente número de la secuencia de documentos
@param codSerie: Código de serie del documento
@param codEjercicio: Código de ejercicio del documento
@param fN: Tipo de documento (factura a cliente, a proveedor, albarán, etc.)
@return Número correspondiente al siguiente documento en la serie o false si hay error
\end */
function oficial_siguienteNumero(codSerie:String, codEjercicio:String, fN:String):Number
{
	var numero:Number;
	var util:FLUtil = new FLUtil;
	var cursorSecuencias:FLSqlCursor = new FLSqlCursor("secuenciasejercicios");

	cursorSecuencias.setContext(this);
	cursorSecuencias.setActivatedCheckIntegrity(false);
	cursorSecuencias.select("upper(codserie)='" + codSerie + "' AND upper(codejercicio)='" + codEjercicio + "';");
	if (cursorSecuencias.next()) {
		if (fN == "nfacturaprov") {
			var numeroHueco:Number = this.iface.obtenerHueco(codSerie, codEjercicio, "FP");
			if (numeroHueco != 0) {
				cursorSecuencias.setActivatedCheckIntegrity(true);
				return numeroHueco;
			}
		}
		if (fN == "nfacturacli") {
			var numeroHueco:Number = this.iface.obtenerHueco(codSerie, codEjercicio, "FC");
			if (numeroHueco != 0) {
				cursorSecuencias.setActivatedCheckIntegrity(true);
				return numeroHueco;
			}
		}

		/** \C
		Para minimizar bloqueos las secuencias se han separado en distintos registros de otra tabla
		llamada secuencias
		\end */
		var cursorSecs:FLSqlCursor = new FLSqlCursor( "secuencias" );
		cursorSecs.setContext( this );
		cursorSecs.setActivatedCheckIntegrity( false );
		/** \C
		Si el registro no existe lo crea inicializandolo con su antiguo valor del campo correspondiente
		en la tabla secuenciasejercicios.
		\end */
		var idSec:Number = cursorSecuencias.valueBuffer( "id" );
		cursorSecs.select( "id=" + idSec + " AND nombre='" + fN + "'" );
		if ( !cursorSecs.next() ) {
			numero = cursorSecuencias.valueBuffer(fN);
			if (!numero || isNaN(numero)) {
				numero = 1;
			}
			cursorSecs.setModeAccess( cursorSecs.Insert );
			cursorSecs.refreshBuffer();
			cursorSecs.setValueBuffer( "id", idSec );
			cursorSecs.setValueBuffer( "nombre", fN );
			cursorSecs.setValueBuffer( "valor", this.iface.establecerNumeroSecuencia( fN, numero ) );
			cursorSecs.commitBuffer();
		} else {
			cursorSecs.setModeAccess( cursorSecs.Edit );
			cursorSecs.refreshBuffer();
			if ( !cursorSecs.isNull( "valorout" ) )
				numero = cursorSecs.valueBuffer( "valorout" );
			else
				numero = cursorSecs.valueBuffer( "valor" );
			cursorSecs.setValueBuffer( "valorout", this.iface.establecerNumeroSecuencia( fN, numero ) );
			cursorSecs.commitBuffer();
		}
		cursorSecs.setActivatedCheckIntegrity( true );
	} else {
		/** \C
		Si la serie no existe para el ejercicio actual se consultará al usuario si la quiere crear
		\end */
		var res:Number = MessageBox.warning(util.translate("scripts", "La serie ") + codSerie + util.translate("scripts"," no existe para el ejercicio ") + codEjercicio + util.translate("scripts",".\n¿Desea crearla?"), MessageBox.Yes,MessageBox.No);
		if (res != MessageBox.Yes) {
			cursorSecuencias.setActivatedCheckIntegrity(true);
			return false;
		}
		cursorSecuencias.setModeAccess(cursorSecuencias.Insert);
		cursorSecuencias.refreshBuffer();
		cursorSecuencias.setValueBuffer("codserie", codSerie);
		cursorSecuencias.setValueBuffer("codejercicio", codEjercicio);
		numero = "1";
		cursorSecuencias.setValueBuffer(fN, "2");
		if (!cursorSecuencias.commitBuffer()) {
			cursorSecuencias.setActivatedCheckIntegrity(true);
			return false;
		}
	}
	cursorSecuencias.setActivatedCheckIntegrity(true);
	return numero;
}

/** \D
Agrega un hueco a la tabla de huecos
@param serie: Código de serie del documento
@param ejercicio: Código de ejercicio del documento
@param numero: Número del documento
@param fN: Tipo de documento (factura a cliente, a proveedor, albarán, etc.)
@return true si el hueco se inserta correctamente o false si hay error
\end */
function oficial_agregarHueco(serie:String, ejercicio:String, numero:Number, fN:String):Boolean
{
	return this.iface.recalcularHuecos( serie, ejercicio, fN );
}

/* \D Indica si el asiento asociado a la factura puede o no regenerarse, según pertenezca a un ejercicio abierto o cerrado
@param idAsiento: Identificador del asiento
@return True: Asiento borrable, False: Asiento no borrable
\end */
function oficial_asientoBorrable(idAsiento:Number):Boolean
{
	var util:FLUtil = new FLUtil();
	var qryEjerAsiento:FLSqlQuery = new FLSqlQuery();
	qryEjerAsiento.setTablesList("ejercicios,co_asientos");
	qryEjerAsiento.setSelect("e.estado");
	qryEjerAsiento.setFrom("co_asientos a INNER JOIN ejercicios e" +
			" ON a.codejercicio = e.codejercicio");
	qryEjerAsiento.setWhere("a.idasiento = " + idAsiento);
	try { qryEjerAsiento.setForwardOnly( true ); } catch (e) {}

	if (!qryEjerAsiento.exec())
		return false;

	if (!qryEjerAsiento.next())
		return true;

	if (qryEjerAsiento.value(0) != "ABIERTO") {
		MessageBox.critical(util.translate("scripts",
		"No puede realizarse la modificación porque el asiento contable correspondiente pertenece a un ejercicio cerrado"),
				MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	return true;
}

/** \U Genera o regenera el asiento correspondiente a una factura de cliente
@param	curFactura: Cursor con los datos de la factura
@return	VERDADERO si no hay error. FALSO en otro caso
\end */
function oficial_generarAsientoFacturaCli(curFactura:FLSqlCursor):Boolean
{
	if (curFactura.modeAccess() != curFactura.Insert && curFactura.modeAccess() != curFactura.Edit)
		return true;

	var util:FLUtil = new FLUtil;
	if (curFactura.valueBuffer("nogenerarasiento")) {
		curFactura.setNull("idasiento");
		return true;
	}

	if (!this.iface.comprobarRegularizacion(curFactura))
		return false;

	var datosAsiento:Array = [];
	var valoresDefecto:Array;
	valoresDefecto["codejercicio"] = curFactura.valueBuffer("codejercicio");
	valoresDefecto["coddivisa"] = flfactppal.iface.pub_valorDefectoEmpresa("coddivisa");

	var curTransaccion:FLSqlCursor = new FLSqlCursor("facturascli");
	curTransaccion.transaction(false);
	try {
		datosAsiento = this.iface.regenerarAsiento(curFactura, valoresDefecto);
		if (datosAsiento.error == true)
			throw util.translate("scripts", "Error al regenerar el asiento");

		var ctaCliente = this.iface.datosCtaCliente(curFactura, valoresDefecto);
		if (ctaCliente.error != 0)
			throw util.translate("scripts", "Error al leer los datos de subcuenta de cliente");

		if (!this.iface.generarPartidasCliente(curFactura, datosAsiento.idasiento, valoresDefecto, ctaCliente))
			throw util.translate("scripts", "Error al generar las partidas de cliente");

		if (!this.iface.generarPartidasIRPF(curFactura, datosAsiento.idasiento, valoresDefecto))
			throw util.translate("scripts", "Error al generar las partidas de IRPF");

		if (!this.iface.generarPartidasIVACli(curFactura, datosAsiento.idasiento, valoresDefecto, ctaCliente))
			throw util.translate("scripts", "Error al generar las partidas de IVA");

		if (!this.iface.generarPartidasRecFinCli(curFactura, datosAsiento.idasiento, valoresDefecto))
			throw util.translate("scripts", "Error al generar las partidas de recargo financiero");

		if (!this.iface.generarPartidasVenta(curFactura, datosAsiento.idasiento, valoresDefecto))
			throw util.translate("scripts", "Error al generar las partidas de venta");

		curFactura.setValueBuffer("idasiento", datosAsiento.idasiento);

		if (curFactura.valueBuffer("deabono") == true)
			if (!this.iface.asientoFacturaAbonoCli(curFactura, valoresDefecto))
				throw util.translate("scripts", "Error al generar el asiento correspondiente a la factura de abono");

		if (!flcontppal.iface.pub_comprobarAsiento(datosAsiento.idasiento))
			throw util.translate("scripts", "Error al comprobar el asiento");
	} catch (e) {
		curTransaccion.rollback();
		MessageBox.warning(util.translate("scripts", "Error al generar el asiento correspondiente a la factura %1:").arg(curFactura.valueBuffer("codigo")) + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	curTransaccion.commit();

	return true;
}

/** \D Genera la parte del asiento de factura correspondiente a la subcuenta de ventas
@param	curFactura: Cursor de la factura
@param	idAsiento: Id del asiento asociado
@param	valoresDefecto: Array con los valores por defecto de ejercicio y divisa
@return	VERDADERO si no hay error, FALSO en otro caso
\end */
function oficial_generarPartidasVenta(curFactura:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean
{
	var util:FLUtil = new FLUtil();
	var ctaVentas:Array = this.iface.datosCtaVentas(valoresDefecto.codejercicio, curFactura.valueBuffer("codserie"));
	if (ctaVentas.error != 0) {
		MessageBox.warning(util.translate("scripts", "No se ha encontrado una subcuenta de ventas para esta factura."), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var haber:Number = 0;
	var haberME:Number = 0;
	var monedaSistema:Boolean = (valoresDefecto.coddivisa == curFactura.valueBuffer("coddivisa"));
	if (monedaSistema) {
		haber = this.iface.netoVentasFacturaCli(curFactura);
		haberME = 0;
	} else {
		haber = parseFloat(util.sqlSelect("co_partidas", "SUM(debe - haber)", "idasiento = " + idAsiento));
		haberME = this.iface.netoVentasFacturaCli(curFactura);
	}
	haber = util.roundFieldValue(haber, "co_partidas", "haber");
	haberME = util.roundFieldValue(haberME, "co_partidas", "haberme");

	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
	with (curPartida) {
		setModeAccess(curPartida.Insert);
		refreshBuffer();
		setValueBuffer("idsubcuenta", ctaVentas.idsubcuenta);
		setValueBuffer("codsubcuenta", ctaVentas.codsubcuenta);
		setValueBuffer("idasiento", idAsiento);
		setValueBuffer("debe", 0);
		setValueBuffer("haber", haber);
		setValueBuffer("coddivisa", curFactura.valueBuffer("coddivisa"));
		setValueBuffer("tasaconv", curFactura.valueBuffer("tasaconv"));
		setValueBuffer("debeME", 0);
		setValueBuffer("haberME", haberME);
	}

	this.iface.datosPartidaFactura(curPartida, curFactura, "cliente")

	if (!curPartida.commitBuffer())
		return false;
	return true;
}

function oficial_netoVentasFacturaCli(curFactura:FLSqlCursor):Number
{
	return parseFloat(curFactura.valueBuffer("neto"));
}
function oficial_netoComprasFacturaProv(curFactura:FLSqlCursor):Number
{
	return parseFloat(curFactura.valueBuffer("neto"));
}

/** \D Genera la parte del asiento de factura correspondiente a la subcuenta de IVA y de recargo de equivalencia, si la factura lo tiene
@param	curFactura: Cursor de la factura
@param	idAsiento: Id del asiento asociado
@param	valoresDefecto: Array con los valores por defecto de ejercicio y divisa
@param	ctaCliente: Array con los datos de la contrapartida
@return	VERDADERO si no hay error, FALSO en otro caso
\end */
function oficial_generarPartidasIVACli(curFactura:FLSqlCursor, idAsiento:Number, valoresDefecto:Array, ctaCliente:Array):Boolean
{
	var util:FLUtil = new FLUtil();
	var haber:Number = 0;
	var haberME:Number = 0;
	var baseImponible:Number = 0;
	var recargo:Number;
	var iva:Number;

	var regimenIVA:String = this.iface.regimenIVACliente(curFactura);
	if (!regimenIVA) {
		MessageBox.warning(util.translate("scripts", "Error al obtener el régimen de IVA asociado a la factura %1.\nCompruebe que el cliente tiene un régimen de IVA establecido").arg(curFactura.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var monedaSistema:Boolean = (valoresDefecto.coddivisa == curFactura.valueBuffer("coddivisa"));
	var qryIva:FLSqlQuery = new FLSqlQuery();
	qryIva.setTablesList("lineasivafactcli");
	qryIva.setSelect("neto, iva, totaliva, recargo, totalrecargo, codimpuesto");
	qryIva.setFrom("lineasivafactcli");
	qryIva.setWhere("idfactura = " + curFactura.valueBuffer("idfactura"));
	try { qryIva.setForwardOnly( true ); } catch (e) {}
	if (!qryIva.exec())
		return false;

	while (qryIva.next()) {
		iva = parseFloat(qryIva.value("iva"));
		if (isNaN(iva)) {
			iva = 0;
		}
		recargo = parseFloat(qryIva.value("recargo"));
		if (isNaN(recargo)) {
			recargo = 0;
		}
		if (monedaSistema) {
			haber = parseFloat(qryIva.value(2));
			haberME = 0;
			baseImponible = parseFloat(qryIva.value(0));
		} else {
			haber = parseFloat(qryIva.value(2)) * parseFloat(curFactura.valueBuffer("tasaconv"));
			haberME = parseFloat(qryIva.value(2));
			baseImponible = parseFloat(qryIva.value(0))  * parseFloat(curFactura.valueBuffer("tasaconv"));
		}
		haber = util.roundFieldValue(haber, "co_partidas", "haber");
		haberME = util.roundFieldValue(haberME, "co_partidas", "haberme");
		baseImponible = util.roundFieldValue(baseImponible, "co_partidas", "baseimponible");

		var ctaIvaRep:Array;
		var textoError:String;
		switch (regimenIVA) {
			case "U.E.": {
				ctaIvaRep = this.iface.datosCtaIVA("IVAEUE", valoresDefecto.codejercicio,qryIva.value(5));
				textoError = util.translate("scripts", "I.V.A. entregas intracomunitarias (IVAEUE)");
				break;
			}
			case "Exento": {
				ctaIvaRep = this.iface.datosCtaIVA("IVAREX", valoresDefecto.codejercicio, qryIva.value(5));
				textoError = util.translate("scripts", "I.V.A. repercutido exento (IVAREX)");
				break;
			}
			case "Exportaciones": {
				ctaIvaRep = this.iface.datosCtaIVA("IVARXP", valoresDefecto.codejercicio, qryIva.value(5));
				textoError = util.translate("scripts", "I.V.A. repercutido exportaciones (IVARXP)");
				break;
			}
			default: {
				ctaIvaRep = this.iface.datosCtaIVA("IVAREP", valoresDefecto.codejercicio, qryIva.value(5));
				textoError = util.translate("scripts", "I.V.A. repercutido R. General(IVAREP)");
			}
		}
		if (ctaIvaRep.error != 0) {
			MessageBox.information(util.translate("scripts", "La cuenta especial de %1 no tiene asignada subcuenta.\nDebe asociarla en el módulo Principal del área Financiera").arg(textoError), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}

		var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
		with (curPartida) {
			setModeAccess(curPartida.Insert);
			refreshBuffer();
			setValueBuffer("idsubcuenta", ctaIvaRep.idsubcuenta);
			setValueBuffer("codsubcuenta", ctaIvaRep.codsubcuenta);
			setValueBuffer("idasiento", idAsiento);
			setValueBuffer("debe", 0);
			setValueBuffer("haber", haber);
			setValueBuffer("baseimponible", baseImponible);
			setValueBuffer("iva", iva);
			setValueBuffer("recargo", recargo);
			setValueBuffer("coddivisa", curFactura.valueBuffer("coddivisa"));
			setValueBuffer("tasaconv", curFactura.valueBuffer("tasaconv"));
			setValueBuffer("idcontrapartida", ctaCliente.idsubcuenta);
			setValueBuffer("codcontrapartida", ctaCliente.codsubcuenta);
			setValueBuffer("debeME", 0);
			setValueBuffer("haberME", haberME);
			setValueBuffer("codserie", curFactura.valueBuffer("codserie"));
			setValueBuffer("cifnif", curFactura.valueBuffer("cifnif"));
		}

		this.iface.datosPartidaFactura(curPartida, curFactura, "cliente")

		if (!curPartida.commitBuffer())
			return false;

		if (monedaSistema) {
			haber = parseFloat(qryIva.value(4));
			haberME = 0;
		} else {
			haber = parseFloat(qryIva.value(4)) * parseFloat(curFactura.valueBuffer("tasaconv"));
			haberME = parseFloat(qryIva.value(4));
		}
		haber = util.roundFieldValue(haber, "co_partidas", "haber");
		haberME = util.roundFieldValue(haberME, "co_partidas", "haberme");

		if (parseFloat(haber) != 0) {
			var ctaRecargo = this.iface.datosCtaIVA("IVARRE", valoresDefecto.codejercicio, qryIva.value(5));
			if (ctaRecargo.error != 0) {
				MessageBox.warning(util.translate("scripts", "No tiene definida cuál es la subcuenta  asociada al recargo de equivalencia en ventas.\nPara definirla vaya a Facturación->Principal->Impuestos e indíquela en el/los impuestos correspondientes"), MessageBox.Ok, MessageBox.NoButton);
				return false;
			}
			var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
			with (curPartida) {
				setModeAccess(curPartida.Insert);
				refreshBuffer();
				setValueBuffer("idsubcuenta", ctaRecargo.idsubcuenta);
				setValueBuffer("codsubcuenta", ctaRecargo.codsubcuenta);
				setValueBuffer("idasiento", idAsiento);
				setValueBuffer("debe", 0);
				setValueBuffer("haber", haber);
				setValueBuffer("baseimponible", baseImponible);
				setValueBuffer("iva", iva);
				setValueBuffer("recargo", recargo);
				setValueBuffer("coddivisa", curFactura.valueBuffer("coddivisa"));
				setValueBuffer("tasaconv", curFactura.valueBuffer("tasaconv"));
				setValueBuffer("idcontrapartida", ctaCliente.idsubcuenta);
				setValueBuffer("codcontrapartida", ctaCliente.codsubcuenta);
				setValueBuffer("debeME", 0);
				setValueBuffer("haberME", haberME);
				setValueBuffer("codserie", curFactura.valueBuffer("codserie"));
				setValueBuffer("cifnif", curFactura.valueBuffer("cifnif"));
			}

			this.iface.datosPartidaFactura(curPartida, curFactura, "cliente")

			if (!curPartida.commitBuffer())
				return false;
		}
	}
	return true;
}

/** \D Obtiene el régimen de IVA asociado a una factura de cliente
@param	curFactura: Factura
@return	Régimen de IVA
\end */
function oficial_regimenIVACliente(curDocCliente:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil();

	var regimen:String;
	var codCliente:String = curDocCliente.valueBuffer("codcliente");
	if (codCliente && codCliente != "") {
		regimen = util.sqlSelect("clientes", "regimeniva", "codcliente = '" + codCliente + "'");
	} else {
		regimen = "General";
	}
	return regimen;
}

/** \D Genera la parte del asiento de factura correspondiente a la subcuenta de IRPF, si la factura lo tiene
@param	curFactura: Cursor de la factura
@param	idAsiento: Id del asiento asociado
@param	valoresDefecto: Array con los valores por defecto de ejercicio y divisa
@return	VERDADERO si no hay error, FALSO en otro caso
\end */
function oficial_generarPartidasIRPF(curFactura:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean
{
		var util:FLUtil = new FLUtil();
		var irpf:Number = parseFloat(curFactura.valueBuffer("totalirpf"));
		if (irpf == 0)
				return true;
		var debe:Number = 0;
		var debeME:Number = 0;
		var ctaIrpf:Array = this.iface.datosCtaEspecial("IRPF", valoresDefecto.codejercicio);
		if (ctaIrpf.error != 0) {
			MessageBox.warning(util.translate("scripts", "No tiene ninguna cuenta contable marcada como cuenta especial\nIRPF (IRPF para clientes).\nDebe asociar la cuenta a la cuenta especial en el módulo Principal del área Financiera"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			return false;
		}

		var monedaSistema:Boolean = (valoresDefecto.coddivisa == curFactura.valueBuffer("coddivisa"));
		if (monedaSistema) {
				debe = irpf;
				debeME = 0;
		} else {
				debe = irpf * parseFloat(curFactura.valueBuffer("tasaconv"));
				debeME = irpf;
		}
		debe = util.roundFieldValue(debe, "co_partidas", "debe");
		debeME = util.roundFieldValue(debeME, "co_partidas", "debeme");

		var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
		with (curPartida) {
				setModeAccess(curPartida.Insert);
				refreshBuffer();
				setValueBuffer("idsubcuenta", ctaIrpf.idsubcuenta);
				setValueBuffer("codsubcuenta", ctaIrpf.codsubcuenta);
				setValueBuffer("idasiento", idAsiento);
				setValueBuffer("debe", debe);
				setValueBuffer("haber", 0);
				setValueBuffer("coddivisa", curFactura.valueBuffer("coddivisa"));
				setValueBuffer("tasaconv", curFactura.valueBuffer("tasaconv"));
				setValueBuffer("debeME", debeME);
				setValueBuffer("haberME", 0);
		}

		this.iface.datosPartidaFactura(curPartida, curFactura, "cliente")

		if (!curPartida.commitBuffer())
				return false;

		return true;
}

/** \D Genera la parte del asiento de factura correspondiente a la subcuenta de recargo financiero para clientes, si la factura lo tiene
@param	curFactura: Cursor de la factura
@param	idAsiento: Id del asiento asociado
@param	valoresDefecto: Array con los valores por defecto de ejercicio y divisa
@return	VERDADERO si no hay error, FALSO en otro caso
\end */
function oficial_generarPartidasRecFinCli(curFactura:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean
{
	var util:FLUtil = new FLUtil();
	var recFinanciero:Number = parseFloat(curFactura.valueBuffer("recfinanciero") * curFactura.valueBuffer("neto") / 100);
	if (!recFinanciero)
		return true;
	var haber:Number = 0;
	var haberME:Number = 0;

	var ctaRecfin:Array = [];
	ctaRecfin = this.iface.datosCtaEspecial("INGRF", valoresDefecto.codejercicio);
	if (ctaRecfin.error != 0) {
		MessageBox.warning(util.translate("scripts", "No tiene ninguna cuenta contable marcada como cuenta especial\nINGRF (recargo financiero en ingresos) \nDebe asociar una cuenta contable a esta cuenta especial en el módulo Principal del área Financiera"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	var monedaSistema:Boolean = (valoresDefecto.coddivisa == curFactura.valueBuffer("coddivisa"));
	if (monedaSistema) {
		haber = recFinanciero;
		haberME = 0;
	} else {
		haber = recFinanciero * parseFloat(curFactura.valueBuffer("tasaconv"));
		haberME = recFinanciero;
	}
	haber = util.roundFieldValue(haber, "co_partidas", "haber");
	haberME = util.roundFieldValue(haberME, "co_partidas", "haberme");

	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
	with (curPartida) {
		setModeAccess(curPartida.Insert);
		refreshBuffer();
		setValueBuffer("idsubcuenta", ctaRecfin.idsubcuenta);
		setValueBuffer("codsubcuenta", ctaRecfin.codsubcuenta);
		setValueBuffer("idasiento", idAsiento);
		setValueBuffer("haber", haber);
		setValueBuffer("debe", 0);
		setValueBuffer("coddivisa", curFactura.valueBuffer("coddivisa"));
		setValueBuffer("tasaconv", curFactura.valueBuffer("tasaconv"));
		setValueBuffer("haberME", haberME);
		setValueBuffer("debeME", 0);
	}

	this.iface.datosPartidaFactura(curPartida, curFactura, "cliente")

	if (!curPartida.commitBuffer())
			return false;

	return true;
}

/** \D Genera la parte del asiento de factura correspondiente a la subcuenta de IRPF para proveedores, si la factura lo tiene
@param	curFactura: Cursor de la factura
@param	idAsiento: Id del asiento asociado
@param	valoresDefecto: Array con los valores por defecto de ejercicio y divisa
@return	VERDADERO si no hay error, FALSO en otro caso
\end */
function oficial_generarPartidasIRPFProv(curFactura:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean
{
	var util:FLUtil = new FLUtil();
	var irpf:Number = parseFloat(curFactura.valueBuffer("totalirpf"));
	if (irpf == 0)
			return true;
	var haber:Number = 0;
	var haberME:Number = 0;

	var ctaIrpf:Array = [];
	ctaIrpf.codsubcuenta = util.sqlSelect("lineasfacturasprov lf INNER JOIN articulos a ON lf.referencia = a.referencia", "a.codsubcuentairpfcom", "lf.idfactura = " + curFactura.valueBuffer("idfactura") + " AND a.codsubcuentairpfcom IS NOT NULL", "lineasfacturasprov,articulos");
	if (ctaIrpf.codsubcuenta) {
		var hayDistintasSubcuentas:String = util.sqlSelect("lineasfacturasprov lf INNER JOIN articulos a ON lf.referencia = a.referencia", "a.referencia", "lf.idfactura = " + curFactura.valueBuffer("idfactura") + " AND (a.codsubcuentairpfcom <> '" + ctaIrpf.codsubcuenta + "' OR a.codsubcuentairpfcom  IS NULL)", "lineasfacturasprov,articulos");
		if (hayDistintasSubcuentas) {
			MessageBox.warning(util.translate("scripts", "No es posible generar el asiento contable de una factura que tiene artículos asignados a distintas subcuentas de IRPF.\nDebe corregir la asociación de las subcuentas de IRPF a los artículos o bien crear distintas facturas para cada subcuenta."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			return false;
		}
		ctaIrpf.idsubcuenta = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + ctaIrpf.codsubcuenta + "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
		if (!ctaIrpf.idsubcuenta) {
			MessageBox.warning(util.translate("scripts", "No existe la subcuenta de IRPF %1 para el ejercicio %2.\nAntes de generar el asiento debe crear esta subcuenta.").arg(ctaIrpf.codsubcuenta).arg(valoresDefecto.codejercicio), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			return false;
		}
	} else {
		ctaIrpf = this.iface.datosCtaEspecial("IRPFPR", valoresDefecto.codejercicio);
		if (ctaIrpf.error != 0) {
			MessageBox.warning(util.translate("scripts", "No tiene ninguna cuenta contable marcada como cuenta especial\nIRPFPR (IRPF para proveedores / acreedores).\nDebe asociar la cuenta a la cuenta especial en el módulo Principal del área Financiera"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			return false;
		}
	}

	var monedaSistema:Boolean = (valoresDefecto.coddivisa == curFactura.valueBuffer("coddivisa"));
	if (monedaSistema) {
		haber = irpf;
		haberME = 0;
	} else {
		haber = irpf * parseFloat(curFactura.valueBuffer("tasaconv"));
		haberME = irpf;
	}
	haber = util.roundFieldValue(haber, "co_partidas", "haber");
	haberME = util.roundFieldValue(haberME, "co_partidas", "haberme");

	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
	with (curPartida) {
		setModeAccess(curPartida.Insert);
		refreshBuffer();
		setValueBuffer("idsubcuenta", ctaIrpf.idsubcuenta);
		setValueBuffer("codsubcuenta", ctaIrpf.codsubcuenta);
		setValueBuffer("idasiento", idAsiento);
		setValueBuffer("debe", 0);
		setValueBuffer("haber", haber);
		setValueBuffer("coddivisa", curFactura.valueBuffer("coddivisa"));
		setValueBuffer("tasaconv", curFactura.valueBuffer("tasaconv"));
		setValueBuffer("debeME", 0);
		setValueBuffer("haberME", haberME);
	}

	this.iface.datosPartidaFactura(curPartida, curFactura, "proveedor")

	if (!curPartida.commitBuffer())
			return false;

	return true;
}


/** \D Genera la parte del asiento de factura correspondiente a la subcuenta de clientes
@param	curFactura: Cursor de la factura
@param	idAsiento: Id del asiento asociado
@param	valoresDefecto: Array con los valores por defecto de ejercicio y divisa
@param	ctaCliente: Datos de la subcuenta del cliente asociado a la factura
@return	VERDADERO si no hay error, FALSO en otro caso
\end */
function oficial_generarPartidasCliente(curFactura:FLSqlCursor, idAsiento:Number, valoresDefecto:Array, ctaCliente:Array):Boolean
{
		var util:FLUtil = new FLUtil();
		var debe:Number = 0;
		var debeME:Number = 0;
		var monedaSistema:Boolean = (valoresDefecto.coddivisa == curFactura.valueBuffer("coddivisa"));
		if (monedaSistema) {
				debe = parseFloat(curFactura.valueBuffer("total"));
				debeME = 0;
		} else {
				debe = parseFloat(curFactura.valueBuffer("total")) * parseFloat(curFactura.valueBuffer("tasaconv"));
				debeME = parseFloat(curFactura.valueBuffer("total"));
		}
		debe = util.roundFieldValue(debe, "co_partidas", "debe");
		debeME = util.roundFieldValue(debeME, "co_partidas", "debeme");

		var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");

		with (curPartida) {
				setModeAccess(curPartida.Insert);
				refreshBuffer();
				setValueBuffer("idsubcuenta", ctaCliente.idsubcuenta);
				setValueBuffer("codsubcuenta", ctaCliente.codsubcuenta);
				setValueBuffer("idasiento", idAsiento);
				setValueBuffer("debe", debe);
				setValueBuffer("haber", 0);
				setValueBuffer("coddivisa", curFactura.valueBuffer("coddivisa"));
				setValueBuffer("tasaconv", curFactura.valueBuffer("tasaconv"));
				setValueBuffer("debeME", debeME);
				setValueBuffer("haberME", 0);
		}

		this.iface.datosPartidaFactura(curPartida, curFactura, "cliente")

		if (!curPartida.commitBuffer())
				return false;

		return true;
}

/** \D Genera o regenera el registro en la tabla de asientos correspondiente a la factura. Si el asiento ya estaba creado borra sus partidas asociadas.
@param	curFactura: Cursor posicionado en el registro de factura
@param	valoresDefecto: Array con los valores por defecto de ejercicio y divisa
@return	array con los siguientes datos:
asiento.idasiento: Id del asiento
asiento.numero: numero del asiento
asiento.fecha: fecha del asiento
asiento.error: indicador booleano de que ha habido un error en la función
\end */
function oficial_regenerarAsiento(cur:FLSqlCursor, valoresDefecto:Array):Array
{
	var util:FLUtil = new FLUtil;
	var asiento:Array = [];
	var idAsiento:Number = cur.valueBuffer("idasiento");
	if (cur.isNull("idasiento")) {

		var datosAsiento:Array = this.iface.datosConceptoAsiento(cur);

		if (!this.iface.curAsiento_) {
			this.iface.curAsiento_ = new FLSqlCursor("co_asientos");
		}
		this.iface.curAsiento_.setModeAccess(this.iface.curAsiento_.Insert);
		this.iface.curAsiento_.refreshBuffer();
		this.iface.curAsiento_.setValueBuffer("numero", 0);
		this.iface.curAsiento_.setValueBuffer("fecha", cur.valueBuffer("fecha"));
		this.iface.curAsiento_.setValueBuffer("codejercicio", valoresDefecto.codejercicio);
		this.iface.curAsiento_.setValueBuffer("concepto", datosAsiento.concepto);
		this.iface.curAsiento_.setValueBuffer("tipodocumento", datosAsiento.tipoDocumento);
		this.iface.curAsiento_.setValueBuffer("documento", datosAsiento.documento);
		if (!this.iface.datosAsientoRegenerado(cur, valoresDefecto)) {
			asiento.error = true;
			return asiento;
		}

		if (!this.iface.curAsiento_.commitBuffer()) {
			asiento.error = true;
			return asiento;
		}
		asiento.idasiento = this.iface.curAsiento_.valueBuffer("idasiento");
		asiento.numero = this.iface.curAsiento_.valueBuffer("numero");
		asiento.fecha = this.iface.curAsiento_.valueBuffer("fecha");
		asiento.concepto = this.iface.curAsiento_.valueBuffer("concepto");
		asiento.tipodocumento = this.iface.curAsiento_.valueBuffer("tipodocumento");
		asiento.documento = this.iface.curAsiento_.valueBuffer("documento");

		this.iface.curAsiento_.select("idasiento = " + asiento.idasiento);
		this.iface.curAsiento_.first();
		this.iface.curAsiento_.setUnLock("editable", false);
	} else {
		var datosAsiento:Array = this.iface.datosConceptoAsiento(cur);

		if (!this.iface.asientoBorrable(idAsiento)) {
			asiento.error = true;
			return asiento;
		}

		if (!this.iface.curAsiento_) {
			this.iface.curAsiento_ = new FLSqlCursor("co_asientos");
		}
		this.iface.curAsiento_.select("idasiento = " + idAsiento);
		if (!this.iface.curAsiento_.first()) {
			asiento.error = true;
			return asiento;
		}
		this.iface.curAsiento_.setUnLock("editable", true);

		this.iface.curAsiento_.select("idasiento = " + idAsiento);
		if (!this.iface.curAsiento_.first()) {
			asiento.error = true;
			return asiento;
		}
		this.iface.curAsiento_.setModeAccess(this.iface.curAsiento_.Edit);
		this.iface.curAsiento_.refreshBuffer();
		this.iface.curAsiento_.setValueBuffer("fecha", cur.valueBuffer("fecha"));
		this.iface.curAsiento_.setValueBuffer("concepto", datosAsiento.concepto);
		this.iface.curAsiento_.setValueBuffer("tipodocumento", datosAsiento.tipoDocumento);
		this.iface.curAsiento_.setValueBuffer("documento", datosAsiento.documento);
		if (!this.iface.datosAsientoRegenerado(cur, valoresDefecto)) {
			asiento.error = true;
			return asiento;
		}
		if (!this.iface.curAsiento_.commitBuffer()) {
			asiento.error = true;
			return asiento;
		}
		this.iface.curAsiento_.select("idasiento = " + idAsiento);
		if (!this.iface.curAsiento_.first()) {
			asiento.error = true;
			return asiento;
		}
		this.iface.curAsiento_.setUnLock("editable", false);

		asiento = flfactppal.iface.pub_ejecutarQry("co_asientos", "idasiento,numero,fecha,codejercicio,concepto,tipodocumento,documento", "idasiento = '" + idAsiento + "'");
		if (asiento.codejercicio != valoresDefecto.codejercicio) {
			MessageBox.warning(util.translate("scripts", "Está intentando regenerar un asiento del ejercicio %1 en el ejercicio %2.\nVerifique que su ejercicio actual es correcto. Si lo es y está actualizando un pago, bórrelo y vuélvalo a crear.").arg(asiento.codejercicio).arg(valoresDefecto.codejercicio), MessageBox.Ok, MessageBox.NoButton);
			asiento.error = true;
			return asiento;
		}
		var curPartidas = new FLSqlCursor("co_partidas");
		curPartidas.select("idasiento = " + idAsiento);
		var idP:Number = 0;
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

function oficial_datosAsientoRegenerado(cur:FLSqlCursor, valoresDefecto:Array):Boolean
{
	return true;
}

function oficial_datosConceptoAsiento(cur:FLSqlCursor):Array
{
	var util:FLUtil = new FLUtil;
	var datosAsiento:Array = [];

	switch (cur.table()) {
		case "facturascli": {
			datosAsiento.concepto = "Nuestra factura " + cur.valueBuffer("codigo") + " - " + cur.valueBuffer("nombrecliente");
			datosAsiento.documento = cur.valueBuffer("codigo");
			datosAsiento.tipoDocumento = "Factura de cliente";
			break;
		}
		case "facturasprov": {
			var numProveedor:String = cur.valueBuffer("numproveedor");
			if (numProveedor && numProveedor != "") {
				numProveedor = numProveedor + " / ";
			}
			datosAsiento.concepto = "Su factura " + numProveedor + cur.valueBuffer("codigo") + " - " + cur.valueBuffer("nombre");
			datosAsiento.documento = cur.valueBuffer("codigo");
			datosAsiento.tipoDocumento = "Factura de proveedor";
			break;
		}
		case "pagosdevolcli": {
			var codRecibo:String = util.sqlSelect("reciboscli", "codigo", "idrecibo = " + cur.valueBuffer("idrecibo"));
			var nombreCli:String = util.sqlSelect("reciboscli", "nombrecliente", "idrecibo = " + cur.valueBuffer("idrecibo"));

			if (cur.valueBuffer("tipo") == "Pago") {
				datosAsiento.concepto = "Pago recibo " + codRecibo + " - " + nombreCli;
			} else {
				datosAsiento.concepto = "Devolución recibo " + codRecibo;
			}

			datosAsiento.tipoDocumento = "Recibo";
			datosAsiento.documento = "";
			break;
		}
		case "pagosdevolrem": {
			if (cur.valueBuffer("tipo") == "Pago")
				datosAsiento.concepto = cur.valueBuffer("tipo") + " " + "remesa" + " " + cur.valueBuffer("idremesa");
				datosAsiento.tipoDocumento = "";
				datosAsiento.documento = "";
			break;
		}
		case "co_dotaciones": {
			datosAsiento.concepto = "Dotación de " + util.sqlSelect("co_amortizaciones","elemento","codamortizacion = '" + cur.valueBuffer("codamortizacion") + "'") + " - " + util.dateAMDtoDMA(cur.valueBuffer("fecha"));
			datosAsiento.documento = "";
			datosAsiento.tipoDocumento = "";
			break;
		}
		default:
			datosAsiento.concepto = "";
			datosAsiento.documento = "";
			datosAsiento.tipoDocumento = "";
	}
	return datosAsiento;
}

function oficial_eliminarAsiento(idAsiento:String):Boolean
{
	var util:FLUtil = new FLUtil;
	if (!idAsiento || idAsiento == "")
		return true;

	if (!this.iface.asientoBorrable(idAsiento))
		return false;

	var curAsiento:FLSqlCursor = new FLSqlCursor("co_asientos");
	curAsiento.select("idasiento = " + idAsiento);
	if (!curAsiento.first())
		return false;

	curAsiento.setUnLock("editable", true);
	if (!util.sqlDelete("co_asientos", "idasiento = " + idAsiento)) {
		curAsiento.setValueBuffer("idasiento", idAsiento);
		return false;
	}
	return true;
}

/** \U Genera o regenera el asiento correspondiente a una factura de proveedor
@param	curFactura: Cursor con los datos de la factura
@return	VERDADERO si no hay error. FALSO en otro caso
\end */
/** \C El concepto de los asientos de factura de proveedor será 'Su factura ' + número de proveedor asociado a la factura. Si el número de proveedor no se especifica, el concepto será 'Su factura ' + código de factura.
\end */
function oficial_generarAsientoFacturaProv(curFactura:FLSqlCursor):Boolean
{
	if (curFactura.modeAccess() != curFactura.Insert && curFactura.modeAccess() != curFactura.Edit)
		return true;

	var util:FLUtil = new FLUtil;
	if (curFactura.valueBuffer("nogenerarasiento")) {
		curFactura.setNull("idasiento");
		return true;
	}

	if (!this.iface.comprobarRegularizacion(curFactura))
		return false;

	var util:FLUtil = new FLUtil();
	var datosAsiento:Array = [];
	var valoresDefecto:Array;
	valoresDefecto["codejercicio"] = curFactura.valueBuffer("codejercicio");
	valoresDefecto["coddivisa"] = flfactppal.iface.pub_valorDefectoEmpresa("coddivisa");

	var curTransaccion:FLSqlCursor = new FLSqlCursor("facturascli");
	curTransaccion.transaction(false);
	try {
		datosAsiento = this.iface.regenerarAsiento(curFactura, valoresDefecto);
		if (datosAsiento.error == true) {
			throw util.translate("scripts", "Error al regenerar el asiento");
		}

		var numProveedor:String = curFactura.valueBuffer("numproveedor");
		var concepto:String = "";
		if (!numProveedor || numProveedor == "") {
			concepto = util.translate("scripts", "Su factura ") + curFactura.valueBuffer("codigo");
		} else {
			concepto = util.translate("scripts", "Su factura ") + numProveedor;
		}
		concepto += " - " + curFactura.valueBuffer("nombre");

		var ctaProveedor:Array = this.iface.datosCtaProveedor(curFactura, valoresDefecto);
		if (ctaProveedor.error != 0) {
			throw util.translate("scripts", "Error al obtener la subcuenta del proveedor");
		}

		// Las partidas generadas dependen del régimen de IVA del proveedor
		var regimenIVA:String = util.sqlSelect("proveedores", "regimeniva", "codproveedor = '" + curFactura.valueBuffer("codproveedor") + "'");

		switch(regimenIVA) {
			case "UE": {
				if (!this.iface.generarPartidasProveedor(curFactura, datosAsiento.idasiento, valoresDefecto, ctaProveedor, concepto, true)) {
					throw util.translate("scripts", "Error al generar la partida de proveedor");
				}
				if (!this.iface.generarPartidasIRPFProv(curFactura, datosAsiento.idasiento, valoresDefecto)) {
					throw util.translate("scripts", "Error al generar la partida de IRPF");
				}
				if (!this.iface.generarPartidasRecFinProv(curFactura, datosAsiento.idasiento, valoresDefecto)) {
					throw util.translate("scripts", "Error al generar la partida recargo financiero");
				}
				if (!this.iface.generarPartidasIVAProv(curFactura, datosAsiento.idasiento, valoresDefecto, ctaProveedor, concepto)) {
					throw util.translate("scripts", "Error al generar la partida de IVA");
				}
				if (!this.iface.generarPartidasCompra(curFactura, datosAsiento.idasiento, valoresDefecto, concepto)) {
					throw util.translate("scripts", "Error al generar la partida de compras");
				}
				break;
			}
			case "Exento": {
				if (!this.iface.generarPartidasProveedor(curFactura, datosAsiento.idasiento, valoresDefecto, ctaProveedor, concepto, true)) {
					throw util.translate("scripts", "Error al generar la partida de proveedor");
				}
				if (!this.iface.generarPartidasRecFinProv(curFactura, datosAsiento.idasiento, valoresDefecto)) {
					throw util.translate("scripts", "Error al generar la partida de recargo financiero");
				}
				if (!this.iface.generarPartidasIRPFProv(curFactura, datosAsiento.idasiento, valoresDefecto)) {
					throw util.translate("scripts", "Error al generar la partida de IRPF");
				}
				if (!this.iface.generarPartidasIVAProv(curFactura, datosAsiento.idasiento, valoresDefecto, ctaProveedor, concepto)) {
					throw util.translate("scripts", "Error al generar la partida de IVA");
				}
				if (!this.iface.generarPartidasCompra(curFactura, datosAsiento.idasiento, valoresDefecto, concepto)) {
					throw util.translate("scripts", "Error al generar la partida de compras");
				}
				break;
			}
			default: {
				if (!this.iface.generarPartidasProveedor(curFactura, datosAsiento.idasiento, valoresDefecto, ctaProveedor, concepto)) {
					throw util.translate("scripts", "Error al generar la partida de proveedor");
				}
				if (!this.iface.generarPartidasIRPFProv(curFactura, datosAsiento.idasiento, valoresDefecto)) {
					throw util.translate("scripts", "Error al generar la partida de IRPF");
				}
				if (!this.iface.generarPartidasRecFinProv(curFactura, datosAsiento.idasiento, valoresDefecto)) {
					throw util.translate("scripts", "Error al generar la partida de recargo financiero");
				}
				if (!this.iface.generarPartidasIVAProv(curFactura, datosAsiento.idasiento, valoresDefecto, ctaProveedor, concepto)) {
					throw util.translate("scripts", "Error al generar la partida de IVA");
				}
				if (!this.iface.generarPartidasCompra(curFactura, datosAsiento.idasiento, valoresDefecto, concepto)) {
					throw util.translate("scripts", "Error al generar la partida de compra");
				}
			}
		}

		curFactura.setValueBuffer("idasiento", datosAsiento.idasiento);
		if (curFactura.valueBuffer("deabono") == true) {
			if (!this.iface.asientoFacturaAbonoProv(curFactura, valoresDefecto)) {
				throw util.translate("scripts", "Error al modificar el asiento de abono");
			}
		}

		if (!flcontppal.iface.pub_comprobarAsiento(datosAsiento.idasiento)) {
			throw util.translate("scripts", "Error al comprobar el asiento");
		}
	} catch (e) {
		curTransaccion.rollback();
		MessageBox.warning(util.translate("scripts", "Error al generar el asiento correspondiente a la factura %1:").arg(curFactura.valueBuffer("codigo")) + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	curTransaccion.commit();

	return true;
}

/** \D Genera la parte del asiento de factura de proveedor correspondiente a la subcuenta de compras
@param	curFactura: Cursor de la factura
@param	idAsiento: Id del asiento asociado
@param	valoresDefecto: Array con los valores por defecto de ejercicio y divisa
@param	concepto: Concepto de la partida
@return	VERDADERO si no hay error, FALSO en otro caso
\end */
function oficial_generarPartidasCompra(curFactura:FLSqlCursor, idAsiento:Number, valoresDefecto:Array, concepto:String):Boolean
{
		var ctaCompras:Array = [];
	var util:FLUtil = new FLUtil();
	var monedaSistema:Boolean = (valoresDefecto.coddivisa == curFactura.valueBuffer("coddivisa"));
	var debe:Number = 0;
	var debeME:Number = 0;
	var idUltimaPartida:Number = 0;

	/** \C En el asiento correspondiente a las facturas de proveedor, se generarán tantas partidas de compra como subcuentas distintas existan en las líneas de factura
	\end */
	var qrySubcuentas:FLSqlQuery = new FLSqlQuery();
	with (qrySubcuentas) {
		setTablesList("lineasfacturasprov");
		setSelect("codsubcuenta, SUM(pvptotal)");
		setFrom("lineasfacturasprov");
		setWhere("idfactura = " + curFactura.valueBuffer("idfactura") + " GROUP BY codsubcuenta");
	}
	try { qrySubcuentas.setForwardOnly( true ); } catch (e) {}

	if (!qrySubcuentas.exec())
			return false;

	if (qrySubcuentas.size() == 0) { // || curFactura.valueBuffer("deabono")) {
	/// \D Si la factura es de abono se genera una sola partida de compras que luego se convertirá a partida de devolución de compras ** CORREGIDO: No se debe hacer esto puesto que la subcuenta de devolución puede ser distinta para cada tipo de compra. Sólo las subcuentas COMPRA serán pasadas a DEVCOM ** */
		ctaCompras = this.iface.datosCtaEspecial("COMPRA", valoresDefecto.codejercicio);
		if (ctaCompras.error != 0) {
			MessageBox.warning(util.translate("scripts", "No existe ninguna subcuenta marcada como cuenta especial de COMPRA para %1").arg(valoresDefecto.codejercicio), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
		if (monedaSistema) {
			debe = this.iface.netoComprasFacturaProv(curFactura);
			debeME = 0;
		} else {
			debe = parseFloat(curFactura.valueBuffer("neto")) * parseFloat(curFactura.valueBuffer("tasaconv"));
			debeME = this.iface.netoComprasFacturaProv(curFactura);
		}
		debe = util.roundFieldValue(debe, "co_partidas", "debe");
		debeME = util.roundFieldValue(debeME, "co_partidas", "debeme");

		var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
		with (curPartida) {
			setModeAccess(curPartida.Insert);
			refreshBuffer();
			setValueBuffer("idsubcuenta", ctaCompras.idsubcuenta);
			setValueBuffer("codsubcuenta", ctaCompras.codsubcuenta);
			setValueBuffer("idasiento", idAsiento);
			setValueBuffer("debe", debe);
			setValueBuffer("haber", 0);
			setValueBuffer("coddivisa", curFactura.valueBuffer("coddivisa"));
			setValueBuffer("tasaconv", curFactura.valueBuffer("tasaconv"));
			setValueBuffer("debeME", debeME);
			setValueBuffer("haberME", 0);
		}

		this.iface.datosPartidaFactura(curPartida, curFactura, "proveedor", concepto);

		if (!curPartida.commitBuffer())
			return false;
		idUltimaPartida = curPartida.valueBuffer("idpartida");
	} else {
		while (qrySubcuentas.next()) {
			if (qrySubcuentas.value(0) == "" || !qrySubcuentas.value(0)) {
				ctaCompras = this.iface.datosCtaEspecial("COMPRA", valoresDefecto.codejercicio);
				if (ctaCompras.error != 0)
					return false;
			} else {
				ctaCompras.codsubcuenta = qrySubcuentas.value(0);
				ctaCompras.idsubcuenta = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + qrySubcuentas.value(0) + "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
				if (!ctaCompras.idsubcuenta) {
					MessageBox.warning(util.translate("scripts", "No existe la subcuenta ")  + ctaCompras.codsubcuenta + util.translate("scripts", " correspondiente al ejercicio ") + valoresDefecto.codejercicio + util.translate("scripts", ".\nPara poder crear la factura debe crear antes esta subcuenta"), MessageBox.Ok, MessageBox.NoButton);
					return false;
				}
			}

			if (monedaSistema) {
				debe = parseFloat(qrySubcuentas.value(1));
				debeME = 0;
			} else {
				debe = parseFloat(qrySubcuentas.value(1)) * parseFloat(curFactura.valueBuffer("tasaconv"));
				debeME = parseFloat(qrySubcuentas.value(1));
			}
			debe = util.roundFieldValue(debe, "co_partidas", "debe");
			debeME = util.roundFieldValue(debeME, "co_partidas", "debeme");

			var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
			with (curPartida) {
				setModeAccess(curPartida.Insert);
				refreshBuffer();
				setValueBuffer("idsubcuenta", ctaCompras.idsubcuenta);
				setValueBuffer("codsubcuenta", ctaCompras.codsubcuenta);
				setValueBuffer("idasiento", idAsiento);
				setValueBuffer("debe", debe);
				setValueBuffer("haber", 0);
				setValueBuffer("coddivisa", curFactura.valueBuffer("coddivisa"));
				setValueBuffer("tasaconv", curFactura.valueBuffer("tasaconv"));
				setValueBuffer("debeME", debeME);
				setValueBuffer("haberME", 0);
			}

			this.iface.datosPartidaFactura(curPartida, curFactura, "proveedor", concepto);

			if (!curPartida.commitBuffer())
				return false;
			idUltimaPartida = curPartida.valueBuffer("idpartida");
		}
	}

	/** \C En los asientos de factura de proveedor, y en el caso de que se use moneda extranjera, la última partida de compras tiene un saldo tal que haga que el asiento cuadre perfectamente. Esto evita errores de redondeo de conversión de moneda entre las partidas del asiento.
	\end */
	if (!monedaSistema) {
		debe = parseFloat(util.sqlSelect("co_partidas", "SUM(haber - debe)", "idasiento = " + idAsiento + " AND idpartida <> " + idUltimaPartida));
		if (debe && !isNaN(debe) && debe != 0) {
			debe = parseFloat(util.roundFieldValue(debe, "co_partidas", "debe"));
			if (!util.sqlUpdate("co_partidas", "debe", debe, "idpartida = " + idUltimaPartida))
				return false;
		}
	}

	return true;
}

/** \D Genera la parte del asiento de factura de proveedor correspondiente a la subcuenta de IVA y de recargo de equivalencia, si la factura lo tiene
@param	curFactura: Cursor de la factura
@param	idAsiento: Id del asiento asociado
@param	valoresDefecto: Array con los valores por defecto de ejercicio y divisa
@param	ctaProveedor: Array con los datos de la contrapartida
@param	concepto: Concepto de la partida
@return	VERDADERO si no hay error, FALSO en otro caso
\end */
function oficial_generarPartidasIVAProv(curFactura:FLSqlCursor, idAsiento:Number, valoresDefecto:Array, ctaProveedor:Array, concepto:String):Boolean
{
	var util:FLUtil = new FLUtil();
	var haber:Number = 0;
	var haberME:Number = 0;
	var baseImponible:Number = 0;
	var monedaSistema:Boolean = (valoresDefecto.coddivisa == curFactura.valueBuffer("coddivisa"));
	var recargo:Number;
	var iva:Number;

	var regimenIVA:String = util.sqlSelect("proveedores","regimeniva","codproveedor = '" + curFactura.valueBuffer("codproveedor") + "'");
	var codCuentaEspIVA:String;

	var qryIva:FLSqlQuery = new FLSqlQuery();
	qryIva.setTablesList("lineasivafactprov");

	if (regimenIVA == "UE")
		qryIva.setSelect("neto, iva, neto*iva/100, recargo, neto*recargo/100, codimpuesto");
	else
		qryIva.setSelect("neto, iva, totaliva, recargo, totalrecargo, codimpuesto");

	qryIva.setFrom("lineasivafactprov");
	qryIva.setWhere("idfactura = " + curFactura.valueBuffer("idfactura"));
	try { qryIva.setForwardOnly( true ); } catch (e) {}
	if (!qryIva.exec())
		return false;


	while (qryIva.next()) {
		iva = parseFloat(qryIva.value("iva"));
		if (isNaN(iva)) {
			iva = 0;
		}
		recargo = parseFloat(qryIva.value("recargo"));
		if (isNaN(recargo)) {
			recargo = 0;
		}
		if (monedaSistema) {
			debe = parseFloat(qryIva.value(2));
			debeME = 0;
			baseImponible = parseFloat(qryIva.value(0));
		} else {
			debe = parseFloat(qryIva.value(2)) * parseFloat(curFactura.valueBuffer("tasaconv"));
			debeME = parseFloat(qryIva.value(2));
			baseImponible = parseFloat(qryIva.value(0)) * parseFloat(curFactura.valueBuffer("tasaconv"));
		}
		debe = util.roundFieldValue(debe, "co_partidas", "debe");
		debeME = util.roundFieldValue(debeME, "co_partidas", "debeme");
		baseImponible = util.roundFieldValue(baseImponible, "co_partidas", "baseimponible");

		switch(regimenIVA) {
			case "UE": {
				codCuentaEspIVA = "IVASUE";
				break;
			}
			case "General": {
				codCuentaEspIVA = "IVASOP";
				break;
			}
			case "Exento": {
				codCuentaEspIVA = "IVASEX";
				break;
			}
			case "Importaciones": {
				return true; /// No se introduce partida de IVA en facturas de importación. El IVA se cobra en la factura del transitario
// 				codCuentaEspIVA = "IVASIM";
				break;
			}
			case "Agrario": {
				codCuentaEspIVA = "IVASRA";
				break;
			}
			default: {
				codCuentaEspIVA = "IVASOP";
			}
		}

		var ctaIvaSop:Array = this.iface.datosCtaIVA(codCuentaEspIVA, valoresDefecto.codejercicio, qryIva.value(5));
		if (ctaIvaSop.error != 0) {
			MessageBox.warning(util.translate("scripts", "Esta factura pertenece al régimen IVA tipo %1.\nNo existe ninguna cuenta contable marcada como tipo especial %2\n\nDebe asociar una cuenta contable a dicho tipo especial en el módulo Principal del área Financiera").arg(regimenIVA).arg(codCuentaEspIVA), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			return false;
		}
		var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
		with (curPartida) {
			setModeAccess(curPartida.Insert);
			refreshBuffer();
			setValueBuffer("idsubcuenta", ctaIvaSop.idsubcuenta);
			setValueBuffer("codsubcuenta", ctaIvaSop.codsubcuenta);
			setValueBuffer("idasiento", idAsiento);
			setValueBuffer("debe", debe);
			setValueBuffer("haber", 0);
			setValueBuffer("baseimponible", baseImponible);
			setValueBuffer("iva", iva);
			setValueBuffer("recargo", recargo);
			setValueBuffer("coddivisa", curFactura.valueBuffer("coddivisa"));
			setValueBuffer("tasaconv", curFactura.valueBuffer("tasaconv"));
			setValueBuffer("idcontrapartida", ctaProveedor.idsubcuenta);
			setValueBuffer("codcontrapartida", ctaProveedor.codsubcuenta);
			setValueBuffer("debeME", debeME);
			setValueBuffer("haberME", 0);
			setValueBuffer("codserie", curFactura.valueBuffer("codserie"));
			setValueBuffer("cifnif", curFactura.valueBuffer("cifnif"));
		}

		this.iface.datosPartidaFactura(curPartida, curFactura, "proveedor")

		if (!curPartida.commitBuffer())
			return false;


		// Otra partida de haber de IVA sobre una cuenta 477 para compensar en UE
		if (regimenIVA == "UE") {

			haber = debe;
			haberME = debeME;
			codCuentaEspIVA = "IVARUE";
			var ctaIvaSop = this.iface.datosCtaIVA("IVARUE", valoresDefecto.codejercicio,qryIva.value(5));
// 			var ctaIvaSop:Array = this.iface.datosCtaEspecial("IVARUE", valoresDefecto.codejercicio);
			if (ctaIvaSop.error != 0) {
				return false;
			}
			var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
			with (curPartida) {
				setModeAccess(curPartida.Insert);
				refreshBuffer();
				setValueBuffer("idsubcuenta", ctaIvaSop.idsubcuenta);
				setValueBuffer("codsubcuenta", ctaIvaSop.codsubcuenta);
				setValueBuffer("idasiento", idAsiento);
				setValueBuffer("debe", 0);
				setValueBuffer("haber", haber);
				setValueBuffer("baseimponible", baseImponible);
				setValueBuffer("iva", iva);
				setValueBuffer("recargo", recargo);
				setValueBuffer("coddivisa", curFactura.valueBuffer("coddivisa"));
				setValueBuffer("tasaconv", curFactura.valueBuffer("tasaconv"));
				setValueBuffer("idcontrapartida", ctaProveedor.idsubcuenta);
				setValueBuffer("codcontrapartida", ctaProveedor.codsubcuenta);
				setValueBuffer("debeME", 0);
				setValueBuffer("haberME", haberME);
				setValueBuffer("codserie", curFactura.valueBuffer("codserie"));
				setValueBuffer("cifnif", curFactura.valueBuffer("cifnif"));
			}

			this.iface.datosPartidaFactura(curPartida, curFactura, "proveedor", concepto)

			if (!curPartida.commitBuffer())
				return false;
		}

		if (monedaSistema) {
			debe = parseFloat(qryIva.value(4));
			debeME = 0;
		} else {
			debe = parseFloat(qryIva.value(4)) * parseFloat(curFactura.valueBuffer("tasaconv"));
			debeME = parseFloat(qryIva.value(4));
		}
		debe = util.roundFieldValue(debe, "co_partidas", "debe");
		debeME = util.roundFieldValue(debeME, "co_partidas", "debeme");

		if (parseFloat(debe) != 0) {
			var ctaRecargo:Array = this.iface.datosCtaIVA("IVADEU", valoresDefecto.codejercicio, qryIva.value(5));
			if (ctaRecargo.error != 0)
				return false;
			var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
			with (curPartida) {
				setModeAccess(curPartida.Insert);
				refreshBuffer();
				setValueBuffer("idsubcuenta", ctaRecargo.idsubcuenta);
				setValueBuffer("codsubcuenta", ctaRecargo.codsubcuenta);
				setValueBuffer("idasiento", idAsiento);
				setValueBuffer("debe", debe);
				setValueBuffer("haber", 0);
				setValueBuffer("baseimponible", baseImponible);
				setValueBuffer("iva", iva);
				setValueBuffer("recargo", recargo);
				setValueBuffer("coddivisa", curFactura.valueBuffer("coddivisa"));
				setValueBuffer("tasaconv", curFactura.valueBuffer("tasaconv"));
				setValueBuffer("idcontrapartida", ctaProveedor.idsubcuenta);
				setValueBuffer("codcontrapartida", ctaProveedor.codsubcuenta);
				setValueBuffer("debeME", debeME);
				setValueBuffer("haberME", 0);
				setValueBuffer("codserie", curFactura.valueBuffer("codserie"));
				setValueBuffer("cifnif", curFactura.valueBuffer("cifnif"));
			}

			this.iface.datosPartidaFactura(curPartida, curFactura, "proveedor", concepto)

			if (!curPartida.commitBuffer())
				return false;
		}
	}
	return true;
}

/** \D Genera la parte del asiento de factura correspondiente a la subcuenta de proveedor
@param	curFactura: Cursor de la factura
@param	idAsiento: Id del asiento asociado
@param	valoresDefecto: Array con los valores por defecto de ejercicio y divisa
@param	ctaCliente: Datos de la subcuenta del proveedor asociado a la factura
@param	concepto: Concepto a asociar a la factura
@return	VERDADERO si no hay error, FALSO en otro caso
\end */
function oficial_generarPartidasProveedor(curFactura:FLSqlCursor, idAsiento:Number, valoresDefecto:Array, ctaProveedor:Array, concepto:String, sinIVA:Boolean):Boolean
{
		var util:FLUtil = new FLUtil;
		var haber:Number = 0;
		var haberME:Number = 0;
		var totalIVA:Number = 0;

		if (sinIVA)
			totalIVA = parseFloat(curFactura.valueBuffer("totaliva"));

		var monedaSistema:Boolean = (valoresDefecto.coddivisa == curFactura.valueBuffer("coddivisa"));
		if (monedaSistema) {
				haber = parseFloat(curFactura.valueBuffer("total"));
				haber -= totalIVA;
				haberME = 0;
		} else {
				haber = (parseFloat(curFactura.valueBuffer("total")) - totalIVA) * parseFloat(curFactura.valueBuffer("tasaconv"));
				haberME = parseFloat(curFactura.valueBuffer("total"));
		}
		haber = util.roundFieldValue(haber, "co_partidas", "haber");
		haberME = util.roundFieldValue(haberME, "co_partidas", "haberme");

		var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
		with (curPartida) {
				setModeAccess(curPartida.Insert);
				refreshBuffer();
				setValueBuffer("idsubcuenta", ctaProveedor.idsubcuenta);
				setValueBuffer("codsubcuenta", ctaProveedor.codsubcuenta);
				setValueBuffer("idasiento", idAsiento);
				setValueBuffer("debe", 0);
				setValueBuffer("haber", haber);
				setValueBuffer("coddivisa", curFactura.valueBuffer("coddivisa"));
				setValueBuffer("tasaconv", curFactura.valueBuffer("tasaconv"));
				setValueBuffer("debeME", 0);
				setValueBuffer("haberME", haberME);
		}

		this.iface.datosPartidaFactura(curPartida, curFactura, "proveedor", concepto);

		if (!curPartida.commitBuffer())
				return false;
		return true;
}

/** \D Genera la parte del asiento de factura correspondiente a la subcuenta de recargo financiero para proveedores, si la factura lo tiene
@param	curFactura: Cursor de la factura
@param	idAsiento: Id del asiento asociado
@param	valoresDefecto: Array con los valores por defecto de ejercicio y divisa
@return	VERDADERO si no hay error, FALSO en otro caso
\end */
function oficial_generarPartidasRecFinProv(curFactura:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean
{
	var util:FLUtil = new FLUtil();
	var recFinanciero:Number = parseFloat(curFactura.valueBuffer("recfinanciero") * curFactura.valueBuffer("neto") / 100);
	if (!recFinanciero)
		return true;
	var debe:Number = 0;
	var debeME:Number = 0;

	var ctaRecfin:Array = [];
	ctaRecfin = this.iface.datosCtaEspecial("GTORF", valoresDefecto.codejercicio);
	if (ctaRecfin.error != 0) {
		MessageBox.warning(util.translate("scripts", "No tiene ninguna cuenta contable marcada como cuenta especial\nGTORF (recargo financiero en gastos).\nDebe asociar una cuenta contable a esta cuenta especial en el módulo Principal del área Financiera"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	var monedaSistema:Boolean = (valoresDefecto.coddivisa == curFactura.valueBuffer("coddivisa"));
	if (monedaSistema) {
		debe = recFinanciero;
		debeME = 0;
	} else {
		debe = recFinanciero * parseFloat(curFactura.valueBuffer("tasaconv"));
		debeME = recFinanciero;
	}
	debe = util.roundFieldValue(debe, "co_partidas", "debe");
	debeME = util.roundFieldValue(debeME, "co_partidas", "debeme");

	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
	with (curPartida) {
		setModeAccess(curPartida.Insert);
		refreshBuffer();
		setValueBuffer("idsubcuenta", ctaRecfin.idsubcuenta);
		setValueBuffer("codsubcuenta", ctaRecfin.codsubcuenta);
		setValueBuffer("idasiento", idAsiento);
		setValueBuffer("debe", debe);
		setValueBuffer("haber", 0);
		setValueBuffer("coddivisa", curFactura.valueBuffer("coddivisa"));
		setValueBuffer("tasaconv", curFactura.valueBuffer("tasaconv"));
		setValueBuffer("debeME", debeME);
		setValueBuffer("haberME", 0);
	}

	this.iface.datosPartidaFactura(curPartida, curFactura, "proveedor");

	if (!curPartida.commitBuffer())
			return false;

	return true;
}

/* \D Devuelve el código e id de la subcuenta especial correspondiente a un determinado ejercicio. Primero trata de obtener los datos a partir del campo cuenta de co_cuentasesp. Si este no existe o no produce resultados, busca los datos de la cuenta (co_cuentas) marcada con el tipo especial buscado.
@param ctaEsp: Tipo de cuenta especial
@codEjercicio: Código de ejercicio
@return Los datos componen un vector de tres valores:
error: 0.Sin error 1.Datos no encontrados 2.Error al ejecutar la query
idsubcuenta: Identificador de la subcuenta
codsubcuenta: Código de la subcuenta
\end */
function oficial_datosCtaEspecial(ctaEsp:String, codEjercicio:String):Array
{
	var datos:Array = [];
	var q:FLSqlQuery = new FLSqlQuery();

	with(q) {
		setTablesList("co_subcuentas,co_cuentasesp");
		setSelect("s.idsubcuenta, s.codsubcuenta");
		setFrom("co_cuentasesp ce INNER JOIN co_subcuentas s ON ce.codsubcuenta = s.codsubcuenta");
		setWhere("ce.idcuentaesp = '" + ctaEsp + "' AND s.codejercicio = '" + codEjercicio + "'  ORDER BY s.codsubcuenta");
	}
	try { q.setForwardOnly( true ); } catch (e) {}
	if (!q.exec()) {
		datos["error"] = 2;
		return datos;
	}
	if (q.next()) {
		datos["error"] = 0;
		datos["idsubcuenta"] = q.value(0);
		datos["codsubcuenta"] = q.value(1);
		return datos;
	}

	with(q) {
		setTablesList("co_cuentas,co_subcuentas,co_cuentasesp");
		setSelect("s.idsubcuenta, s.codsubcuenta");
		setFrom("co_cuentasesp ce INNER JOIN co_cuentas c ON ce.codcuenta = c.codcuenta INNER JOIN co_subcuentas s ON c.idcuenta = s.idcuenta");
		setWhere("ce.idcuentaesp = '" + ctaEsp + "' AND c.codejercicio = '" + codEjercicio + "' ORDER BY s.codsubcuenta");
	}
	try { q.setForwardOnly( true ); } catch (e) {}
	if (!q.exec()) {
		datos["error"] = 2;
		return datos;
	}
	if (q.next()) {
		datos["error"] = 0;
		datos["idsubcuenta"] = q.value(0);
		datos["codsubcuenta"] = q.value(1);
		return datos;
	}

	with(q) {
		setTablesList("co_cuentas,co_subcuentas");
		setSelect("s.idsubcuenta, s.codsubcuenta");
		setFrom("co_cuentas c INNER JOIN co_subcuentas s ON c.idcuenta = s.idcuenta");
		setWhere("c.idcuentaesp = '" + ctaEsp + "' AND c.codejercicio = '" + codEjercicio + "' ORDER BY s.codsubcuenta");
	}
	try { q.setForwardOnly( true ); } catch (e) {}
	if (!q.exec()) {
		datos["error"] = 2;
		return datos;
	}
	if (!q.next()) {
		if (this.iface.consultarCtaEspecial(ctaEsp, codEjercicio)) {
			return this.iface.datosCtaEspecial(ctaEsp, codEjercicio);
		} else {
			datos["error"] = 1;
			return datos;
		}
	}

	datos["error"] = 0;
	datos["idsubcuenta"] = q.value(0);
	datos["codsubcuenta"] = q.value(1);
	return datos;
}

function oficial_consultarCtaEspecial(ctaEsp:String, codEjercicio:String):Boolean
{
	var util:FLUtil = new FLUtil;
	switch (ctaEsp) {
		case "IVASUE": {
			var res:Number = MessageBox.warning(util.translate("scripts", "No tiene establecida la subcuenta de IVA soportado para adquisiciones intracomunitaras (IVASUE).\nEsta subcuenta es necesaria para almacenar información útil para informes como el de facturas emitidas o el modelo 300.\n¿Desea indicar cuál es esta subcuenta ahora?"), MessageBox.Yes, MessageBox.No);
			if (res != MessageBox.Yes)
				return false;
			return this.iface.crearCtaEspecial("IVASUE", "subcuenta", codEjercicio, util.translate("scripts", "IVA soportado en adquisiciones intracomunitarias U.E."));
			break;
		}
		case "IVARUE": {
			var res:Number = MessageBox.warning(util.translate("scripts", "No tiene establecida la subcuenta de IVA repercutido para adquisiciones intracomunitaras (IVARUE).\nEsta subcuenta es necesaria para almacenar información útil para informes como el de facturas emitidas o el modelo 300.\n¿Desea indicar cuál es esta subcuenta ahora?"), MessageBox.Yes, MessageBox.No);
			if (res != MessageBox.Yes)
				return false;
			return this.iface.crearCtaEspecial("IVARUE", "subcuenta", codEjercicio, util.translate("scripts", "IVA repercutido en adquisiciones intracomunitarias U.E."));
			break;
		}
		case "IVAEUE": {
			var res:Number = MessageBox.warning(util.translate("scripts", "No tiene establecida la subcuenta de IVA para entregas intracomunitaras (IVAEUE).\nEsta subcuenta es necesaria para almacenar información útil para informes como el de facturas emitidas o el modelo 300.\n¿Desea indicar cuál es esta subcuenta ahora?"), MessageBox.Yes, MessageBox.No);
			if (res != MessageBox.Yes)
				return false;
			return this.iface.crearCtaEspecial("IVAEUE", "subcuenta", codEjercicio, util.translate("scripts", "IVA en entregas intracomunitarias U.E."));
			break;
		}
		default: {
			return false;
		}
	}
	return false;
}

/** \D Devuelve el código e id de la subcuenta correspondiente a un impuesto y ejercicio determinados
@param	ctaEsp: Tipo de cuenta (IVA soportado, repercutido, Recargo de equivalencia)

@param	codEjercicio: Código de ejercicio
@param	codImpuesto: Código de impuesto
@return Los datos componen un vector de tres valores:
error: 0.Sin error 1.Datos no encontrados 2.Error al ejecutar la query
idsubcuenta: Identificador de la subcuenta
codsubcuenta: Código de la subcuenta
\end */
function oficial_datosCtaIVA(tipo:String, codEjercicio:String, codImpuesto:String):Array
{
	var util:FLUtil = new FLUtil();
	var datos:Array = [];
	var codSubcuenta:String;

	if (!codImpuesto || codImpuesto == "") {
		/// Si no hay una subcuenta asociada al impuesto se toma la primera subcuenta marcada con el tipo especial indicado
		codSubcuenta = util.sqlSelect("co_subcuentas", "codsubcuenta", "idcuentaesp = '" + tipo + "' AND codejercicio = '" + codEjercicio + "' ORDER BY codsubcuenta");
		if (!codSubcuenta || codSubcuenta == "") {
			return this.iface.datosCtaEspecial(tipo, codEjercicio);
		}
	}

	if (tipo == "IVAREP") {
		codSubcuenta = util.sqlSelect("impuestos", "codsubcuentarep", "codimpuesto = '" + codImpuesto + "'");
	}
	if (tipo == "IVASOP") {
		codSubcuenta = util.sqlSelect("impuestos", "codsubcuentasop", "codimpuesto = '" + codImpuesto + "'");
	}
	if (tipo == "IVAACR") {
		codSubcuenta = util.sqlSelect("impuestos", "codsubcuentaacr", "codimpuesto = '" + codImpuesto + "'");
	}
	if (tipo == "IVARRE") {
		/// Nueva cuenta especial. Como antes se usaba IVAACR se tiene esto en cuenta
		codSubcuenta = false;
		var curPrueba:FLSqlCursor = new FLSqlCursor("impuestos");
		if (curPrueba.fieldType("codsubcuentaivarepre") != 0) {
			codSubcuenta = util.sqlSelect("impuestos", "codsubcuentaivarepre", "codimpuesto = '" + codImpuesto + "'");
		}
		if (!codSubcuenta) {
			codSubcuenta = util.sqlSelect("impuestos", "codsubcuentaacr", "codimpuesto = '" + codImpuesto + "'");
		}
	}
	if (tipo == "IVADEU") {
		codSubcuenta = util.sqlSelect("impuestos", "codsubcuentadeu", "codimpuesto = '" + codImpuesto + "'");
	}
	if (tipo == "IVARUE") {
		codSubcuenta = util.sqlSelect("impuestos", "codsubcuentaivadevadue", "codimpuesto = '" + codImpuesto + "'");
	}
	if (tipo == "IVASUE") {
		codSubcuenta = util.sqlSelect("impuestos", "codsubcuentaivadedadue", "codimpuesto = '" + codImpuesto + "'");
	}
	if (tipo == "IVAEUE") {
		codSubcuenta = util.sqlSelect("impuestos", "codsubcuentaivadeventue", "codimpuesto = '" + codImpuesto + "'");
	}
	if (tipo == "IVASIM") {
		var curPrueba:FLSqlCursor = new FLSqlCursor("impuestos");
		if (curPrueba.fieldType("codsubcuentaivasopimp") != 0) {
			codSubcuenta = util.sqlSelect("impuestos", "codsubcuentaivasopimp", "codimpuesto = '" + codImpuesto + "'");
		} else {
			tipo = "IVASOP";
		}
	}
	if (tipo == "IVARXP") {
		var curPrueba:FLSqlCursor = new FLSqlCursor("impuestos");
		if (curPrueba.fieldType("codsubcuentaivarepexp") != 0) {
			codSubcuenta = util.sqlSelect("impuestos", "codsubcuentaivarepexp", "codimpuesto = '" + codImpuesto + "'");
		} else {
			tipo = "IVARXP";
		}
	}
	if (tipo == "IVAREX") {
		var curPrueba:FLSqlCursor = new FLSqlCursor("impuestos");
		if (curPrueba.fieldType("codsubcuentaivarepexe") != 0) {
			codSubcuenta = util.sqlSelect("impuestos", "codsubcuentaivarepexe", "codimpuesto = '" + codImpuesto + "'");
		} else {
			tipo = "IVAREX";
		}
	}
	if (tipo == "IVASEX") {
		var curPrueba:FLSqlCursor = new FLSqlCursor("impuestos");
		if (curPrueba.fieldType("codsubcuentaivasopexe") != 0) {
			codSubcuenta = util.sqlSelect("impuestos", "codsubcuentaivasopexe", "codimpuesto = '" + codImpuesto + "'");
		} else {
			tipo = "IVASEX";
		}
	}

	if (!codSubcuenta || codSubcuenta == "") {
		/// Si no hay una subcuenta asociada al impuesto se toma la primera subcuenta marcada con el tipo especial indicado
		codSubcuenta = util.sqlSelect("co_subcuentas", "codsubcuenta", "idcuentaesp = '" + tipo + "' AND codejercicio = '" + codEjercicio + "' ORDER BY codsubcuenta");
		if (!codSubcuenta || codSubcuenta == "") {
			return this.iface.datosCtaEspecial(tipo, codEjercicio);
		}
	}

	var q:FLSqlQuery = new FLSqlQuery();
	with(q) {
		setTablesList("co_subcuentas");
		setSelect("idsubcuenta, codsubcuenta");
		setFrom("co_subcuentas");
		setWhere("codsubcuenta = '" + codSubcuenta + "' AND codejercicio = '" + codEjercicio + "'");
	}
	try { q.setForwardOnly( true ); } catch (e) {}
	if (!q.exec()) {
		datos["error"] = 2;
		return datos;
	}
	if (!q.next()) {
		return this.iface.datosCtaEspecial(tipo, codEjercicio);
	}

	datos["error"] = 0;
	datos["idsubcuenta"] = q.value(0);
	datos["codsubcuenta"] = q.value(1);
	return datos;
}

/* \D Devuelve el código e id de la subcuenta de ventas correspondiente a un determinado ejercicio. La cuenta de ventas es la asignada a la serie de facturación. En caso de no estar establecida es la correspondiente a la subcuenta especial marcada como ventas
@param ctaEsp: Tipo de cuenta especial
@param codEjercicio: Código de ejercicio
@param codSerie: Código de serie de la factura
@return Los datos componen un vector de tres valores:
error: 0.Sin error 1.Datos no encontrados 2.Error al ejecutar la query
idsubcuenta: Identificador de la subcuenta
codsubcuenta: Código de la subcuenta
\end */
function oficial_datosCtaVentas(codEjercicio:String, codSerie:String):Array
{
		var util:FLUtil = new FLUtil();
		var datos:Array = [];

		var codCuenta:String = util.sqlSelect("series", "codcuenta", "codserie = '" + codSerie + "'");
		if (codCuenta.toString().isEmpty())
				return this.iface.datosCtaEspecial("VENTAS", codEjercicio);

		var q:FLSqlQuery = new FLSqlQuery();
		with(q) {
				setTablesList("co_cuentas,co_subcuentas");
				setSelect("idsubcuenta, codsubcuenta");
				setFrom("co_cuentas c INNER JOIN co_subcuentas s ON c.idcuenta = s.idcuenta");
				setWhere("c.codcuenta = '" + codCuenta + "' AND c.codejercicio = '" + codEjercicio + "' ORDER BY codsubcuenta");
		}
		try { q.setForwardOnly( true ); } catch (e) {}
		if (!q.exec()) {
				datos["error"] = 2;
				return datos;
		}
		if (!q.next()) {
				datos["error"] = 1;
				return datos;
		}

		datos["error"] = 0;
		datos["idsubcuenta"] = q.value(0);
		datos["codsubcuenta"] = q.value(1);
		return datos;
}

/* \D Devuelve el código e id de la subcuenta de cliente correspondiente a una  determinada factura
@param curFactura: Cursor posicionado en la factura
@param valoresDefecto: Array con los datos de ejercicio y divisa actuales
@return Los datos componen un vector de tres valores:
error: 0.Sin error 1.Datos no encontrados 2.Error al ejecutar la query
idsubcuenta: Identificador de la subcuenta
codsubcuenta: Código de la subcuenta
\end */
function oficial_datosCtaCliente(curFactura:FLSqlCursor, valoresDefecto:Array):Array
{
	return flfactppal.iface.pub_datosCtaCliente( curFactura.valueBuffer("codcliente"), valoresDefecto );
}

/* \D Devuelve el código e id de la subcuenta de proveedor correspondiente a una  determinada factura
@param curFactura: Cursor posicionado en la factura
@param valoresDefecto: Array con los datos de ejercicio y divisa actuales
@return Los datos componen un vector de tres valores:
error: 0.Sin error 1.Datos no encontrados 2.Error al ejecutar la query
idsubcuenta: Identificador de la subcuenta
codsubcuenta: Código de la subcuenta
\end */
function oficial_datosCtaProveedor(curFactura:FLSqlCursor, valoresDefecto:Array):Array
{
	return flfactppal.iface.pub_datosCtaProveedor( curFactura.valueBuffer("codproveedor"), valoresDefecto );
}

/* \D Regenera el asiento correspondiente a una factura de abono de cliente
@param	curFactura: Cursor con los datos de la factura
@param valoresDefecto: Array con los datos de ejercicio y divisa actuales
@return	VERDADERO si no hay error. FALSO en otro caso
\end */
function oficial_asientoFacturaAbonoCli(curFactura:FLSqlCursor, valoresDefecto:Array)
{
	var idAsiento:String  = curFactura.valueBuffer("idasiento").toString();
    var idFactura:String = curFactura.valueBuffer("idfactura");
	var curPartidas:FLSqlCursor = new FLSqlCursor("co_partidas");
	var debe:Number = 0;
	var haber:Number = 0;
	var debeME:Number = 0;
	var haberME:Number = 0;
	var aux:Number;
	var util:FLUtil = new FLUtil;

	curPartidas.select("idasiento = '" + idAsiento + "'");
	while (curPartidas.next()) {
		curPartidas.setModeAccess(curPartidas.Edit);
		curPartidas.refreshBuffer();
		debe = parseFloat(curPartidas.valueBuffer("debe"));
		haber = parseFloat(curPartidas.valueBuffer("haber"));
		debeME = parseFloat(curPartidas.valueBuffer("debeme"));
		haberME = parseFloat(curPartidas.valueBuffer("haberme"));
		aux = debe;
		debe = haber * -1;
		haber = aux * -1;
		aux = debeME;
		debeME = haberME * -1;
		haberME = aux * -1;
		debe = util.roundFieldValue(debe, "co_partidas", "debe");
		haber = util.roundFieldValue(haber, "co_partidas", "haber");
		debeME = util.roundFieldValue(debeME, "co_partidas", "debeme");
		haberME = util.roundFieldValue(haberME, "co_partidas", "haberme");

		curPartidas.setValueBuffer("debe",  debe);
		curPartidas.setValueBuffer("haber", haber);
		curPartidas.setValueBuffer("debeme",  debeME);
		curPartidas.setValueBuffer("haberme", haberME);

		if (!curPartidas.commitBuffer())
			return false;
	}

	var qryPartidasVenta:FLSqlQuery = new FLSqlQuery();
	qryPartidasVenta.setTablesList("co_partidas,co_subcuentas,co_cuentas");
	qryPartidasVenta.setSelect("p.idsubcuenta, p.codsubcuenta");
	qryPartidasVenta.setFrom("co_partidas p INNER JOIN co_subcuentas s ON s.idsubcuenta = p.idsubcuenta INNER JOIN co_cuentas c ON c.idcuenta = s.idcuenta ");
	qryPartidasVenta.setWhere("c.idcuentaesp = 'VENTAS' AND idasiento = " + idAsiento);
	try { qryPartidasVenta.setForwardOnly( true ); } catch (e) {}

	if (!qryPartidasVenta.exec()) {
		return false;
	}
	if (qryPartidasVenta.size == 0) {
		return true;
	}

	var curPartidasVenta:FLSqlCursor = new FLSqlCursor("co_partidas");
	var ctaDevolVentas:Array = false;
	var codSubcuentaDev:String;
	while (qryPartidasVenta.next()) {
		codSubcuentaDev = qryPartidasVenta.value("p.codsubcuenta");
		if (!this.iface.esSubcuentaEspecial(codSubcuentaDev, valoresDefecto.codejercicio, "VENTAS")) {
			continue;
		}
		if (!ctaDevolVentas) {
			ctaDevolVentas = this.iface.datosCtaEspecial("DEVVEN", valoresDefecto.codejercicio);
			if (ctaDevolVentas.error == 1) {
				MessageBox.warning(util.translate("scripts", "No tiene definida una subcuenta especial de devoluciones de ventas.\nEl asiento asociado a la factura no puede ser creado"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				return false;
			}
			if (ctaDevolVentas.error == 2) {
				return false;
			}
		}
		curPartidasVenta.select("idasiento = " + idAsiento + " AND idsubcuenta = " + qryPartidasVenta.value(0));
		curPartidasVenta.first();
		curPartidasVenta.setModeAccess(curPartidasVenta.Edit);
		curPartidasVenta.refreshBuffer();
		curPartidasVenta.setValueBuffer("idsubcuenta",  ctaDevolVentas.idsubcuenta);
		curPartidasVenta.setValueBuffer("codsubcuenta",  ctaDevolVentas.codsubcuenta);
		if (!curPartidasVenta.commitBuffer()) {
			return false;
		}
	}

	return true;
}


/* \D Regenera el asiento correspondiente a una factura de abono de proveedor
@param	curFactura: Cursor con los datos de la factura
@param valoresDefecto: Array con los datos de ejercicio y divisa actuales
@return	VERDADERO si no hay error. FALSO en otro caso
\end */
function oficial_asientoFacturaAbonoProv(curFactura:FLSqlCursor, valoresDefecto:Array)
{
	var idAsiento:String  = curFactura.valueBuffer("idasiento").toString();
    var idFactura:String = curFactura.valueBuffer("idfactura");
	var curPartidas:FLSqlCursor = new FLSqlCursor("co_partidas");
	var debe:Number = 0;
	var haber:Number = 0;
	var debeME:Number = 0;
	var haberME:Number = 0;
	var aux:Number;

	var util:FLUtil = new FLUtil;

	curPartidas.select("idasiento = '" + idAsiento + "'");
	while (curPartidas.next()) {
		curPartidas.setModeAccess(curPartidas.Edit);
		curPartidas.refreshBuffer();
		debe = parseFloat(curPartidas.valueBuffer("debe"));
		haber = parseFloat(curPartidas.valueBuffer("haber"));
		debeME = parseFloat(curPartidas.valueBuffer("debeme"));
		haberME = parseFloat(curPartidas.valueBuffer("haberme"));
		aux = debe;
		debe = haber * -1;
		haber = aux * -1;
		aux = debeME;
		debeME = haberME * -1;
		haberME = aux * -1;
		debe = util.roundFieldValue(debe, "co_partidas", "debe");
		haber = util.roundFieldValue(haber, "co_partidas", "haber");
		debeME = util.roundFieldValue(debeME, "co_partidas", "debeme");
		haberME = util.roundFieldValue(haberME, "co_partidas", "haberme");

		curPartidas.setValueBuffer("debe",  debe);
		curPartidas.setValueBuffer("haber", haber);
		curPartidas.setValueBuffer("debeme",  debeME);
		curPartidas.setValueBuffer("haberme", haberME);

		if (!curPartidas.commitBuffer())
			return false;
	}

	var qryPartidasCompra:FLSqlQuery = new FLSqlQuery();
	qryPartidasCompra.setTablesList("co_partidas,co_subcuentas,co_cuentas");
	qryPartidasCompra.setSelect("p.idsubcuenta,p.codsubcuenta");
	qryPartidasCompra.setFrom("co_partidas p INNER JOIN co_subcuentas s ON s.idsubcuenta = p.idsubcuenta INNER JOIN co_cuentas c ON c.idcuenta = s.idcuenta ");
	qryPartidasCompra.setWhere("c.idcuentaesp = 'COMPRA' AND idasiento = " + idAsiento);
	try { qryPartidasCompra.setForwardOnly( true ); } catch (e) {}

	if (!qryPartidasCompra.exec()) {
		return false;
	}

	if (qryPartidasCompra.size() == 0) {
		return true;
	}

	var curPartidasCompra:FLSqlCursor = new FLSqlCursor("co_partidas");
	var ctaDevolCompra:Array = false;
	var codSubcuentaDev:String;
	while (qryPartidasCompra.next()) {
		codSubcuentaDev = qryPartidasCompra.value("p.codsubcuenta");
		if (!this.iface.esSubcuentaEspecial(codSubcuentaDev, valoresDefecto.codejercicio, "COMPRA")) {
			continue;
		}
		if (!ctaDevolCompra) {
			ctaDevolCompra = this.iface.datosCtaEspecial("DEVCOM", valoresDefecto.codejercicio);
			if (ctaDevolCompra.error == 1) {
				MessageBox.warning(util.translate("scripts", "No tiene definida una subcuenta especial de devoluciones de compras.\nEl asiento asociado a la factura no puede ser creado"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				return false;
			}
			if (ctaDevolCompra.error == 2) {
				return false;
			}
		}
		curPartidasCompra.select("idasiento = " + idAsiento + " AND idsubcuenta = " + qryPartidasCompra.value(0));
		curPartidasCompra.first();
		curPartidasCompra.setModeAccess(curPartidasCompra.Edit);
		curPartidasCompra.refreshBuffer();
		curPartidasCompra.setValueBuffer("idsubcuenta",  ctaDevolCompra.idsubcuenta);
		curPartidasCompra.setValueBuffer("codsubcuenta",  ctaDevolCompra.codsubcuenta);
		if (!curPartidasCompra.commitBuffer()) {
			return false;
		}
	}
	return true;
}

/** \D Indica si una subcuenta es de un determinado tipo especial
@param	codSubcuenta: Código de subcuenta
@param	codEjercicio: Ejercicio en el que comprobarlo.
@param	idTipoEsp: Tipo especial
\end */
function oficial_esSubcuentaEspecial(codSubcuenta:String, codEjercicio:String, idTipoEsp:String):Boolean
{
debug("oficial_esSubcuentaEspecial para " + codSubcuenta + " " + codEjercicio + " " + idTipoEsp);
	var util:FLUtil = new FLUtil;

	if (!codEjercicio) {
		codEjercicio = flfactppal.iface.pub_ejercicioActual();
	}
	var qrySubcuenta:FLSqlQuery = new FLSqlQuery;
	qrySubcuenta.setTablesList("co_subcuentas,co_cuentas");
	qrySubcuenta.setSelect("s.idcuentaesp, c.codcuenta, c.idcuentaesp");
	qrySubcuenta.setFrom("co_subcuentas s INNER JOIN co_cuentas c ON s.idcuenta = c.idcuenta");
	qrySubcuenta.setWhere("s.codsubcuenta = '" + codSubcuenta + "' AND s.codejercicio = '" + codEjercicio + "'");
	qrySubcuenta.setForwardOnly(true);
debug(qrySubcuenta.sql());
	if (!qrySubcuenta.exec()) {
debug(1);
		return false;
	}
	if (!qrySubcuenta.first()) {
debug(2);
		return false;
	}
	if (qrySubcuenta.value("s.idcuenaesp") == idTipoEsp || qrySubcuenta.value("c.idcuentaesp") == idTipoEsp) {
debug(4);
		return true;
	}
	var codCuenta = qrySubcuenta.value("c.codcuenta");
	var qryTipoEsp:FLSqlQuery = new FLSqlQuery;
	qryTipoEsp.setTablesList("co_cuentasesp");
	qryTipoEsp.setSelect("codcuenta, codsubcuenta");
	qryTipoEsp.setFrom("co_cuentasesp");
	qryTipoEsp.setWhere("idcuentaesp = '" + idCuentaEsp + "'");
	qryTipoEsp.setForwardOnly(true);
	if (!qryTipoEsp.exec()) {
debug(5);
		return false;
	}
	if (!qryTipoEsp.first()) {
debug(6);
		return false;
	}
	if (qryTipoEsp.value("codsubcuenta") == codSubcuenta || qryTipoEsp.value("codcuenta") == codCuenta) {
debug(8);
		return true;
	}
debug(9);
	return false;
}

/** \D Si la fecha no está dentro del ejercicio, propone al usuario la selección de uno nuevo
@param	fecha: Fecha del documento
@param	codEjercicio: Ejercicio del documento
@param	tipoDoc: Tipo de documento a generar
@return	Devuelve un array con los siguientes datos:
ok:	Indica si la función terminó correctamente (true) o con error (false)
modificaciones: Indica si se ha modificado algún valor (fecha o ejercicio)
fecha: Nuevo valor para la fecha modificada
codEjercicio: Nuevo valor para el ejercicio modificado
\end */
function oficial_datosDocFacturacion(fecha:String, codEjercicio:String, tipoDoc:String):Array
{

	var res:Array = [];
	res["ok"] = true;
	res["modificaciones"] = false;

	var util:FLUtil = new FLUtil;
	if (util.sqlSelect("ejercicios", "codejercicio", "codejercicio = '" + codEjercicio + "' AND '" + fecha + "' BETWEEN fechainicio AND fechafin"))
		return res;

	var f:Object = new FLFormSearchDB("fechaejercicio");
	var cursor:FLSqlCursor = f.cursor();

	cursor.select();
	if (!cursor.first())
		cursor.setModeAccess(cursor.Insert);
	else
		cursor.setModeAccess(cursor.Edit);
	cursor.refreshBuffer();

	cursor.refreshBuffer();
	cursor.setValueBuffer("fecha", fecha);
	cursor.setValueBuffer("codejercicio", codEjercicio);
	cursor.setValueBuffer("label", tipoDoc);
	cursor.commitBuffer();
	cursor.select();

	if (!cursor.first()) {
		res["ok"] = false;
		return res;
	}

	cursor.setModeAccess(cursor.Edit);
	cursor.refreshBuffer();

	f.setMainWidget();

	var acpt:String = f.exec("codejercicio");
	if (!acpt) {
		res["ok"] = false;
		return res;
	}
	res["modificaciones"] = true;
	res["fecha"] = cursor.valueBuffer("fecha");
	res["codEjercicio"] = cursor.valueBuffer("codejercicio");

	if (res.codEjercicio != flfactppal.iface.pub_ejercicioActual()) {
		if (tipoDoc != "pagosdevolcli" && tipoDoc != "pagosdevolprov") {
			MessageBox.information(util.translate("scripts", "Ha seleccionado un ejercicio distinto del actual.\nPara visualizar los documentos generados debe cambiar el ejercicio actual en la ventana\nde empresa y volver a abrir el formulario maestro correspondiente a los documentos generados"), MessageBox.Ok, MessageBox.NoButton);
		}
	}

	return res;
}

/** \C Establece si un documento de cliente debe tener IVA. No lo tendrá si el cliente seleccionado está exento o es UE, o la serie seleccionada sea sin IVA
@param	codSerie: Serie del documento
@param	codCliente: Código del cliente
@return	Devuelve 3 posibles valores:
	0: Si no debe tener ni IVA ni recargo de equivalencia,
	1: Si debe tener IVA pero no recargo de equivalencia,
	2: Si debe tener IVA y recargo de equivalencia
\end */
function oficial_tieneIvaDocCliente(codSerie:String, codCliente:String, codEjercicio:String):Number
{
	var util:FLUtil = new FLUtil;
	var conIva:Boolean = true;

	if (util.sqlSelect("series", "siniva", "codserie = '" + codSerie + "'"))
		return 0;
	else {
		var regIva:String = util.sqlSelect("clientes", "regimeniva", "codcliente = '" + codCliente + "'");
		if (regIva == "Exento")
			return 0;
		else
			if (!util.sqlSelect("clientes", "recargo", "codcliente = '" + codCliente + "'"))
				return 1;
	}

	return 2;
}

/** \C Establece si un documento de proveedor debe tener IVA. No lo tendrá si el proveedor seleccionado está exento o es UE, o la serie seleccionada sea sin IVA
@param	codSerie: Serie del documento
@param	codProveedor: Código del proveedor
@return	Devuelve 3 posibles valores:
	0: Si no debe tener ni IVA ni recargo de equivalencia,
	1: Si debe tener IVA pero no recargo de equivalencia,
	2: Si debe tener IVA y recargo de equivalencia
\end */
function oficial_tieneIvaDocProveedor(codSerie:String, codProveedor:String, codEjercicio:String):Number
{
	var util:FLUtil = new FLUtil;
	var tieneIva:Number;

	if (util.sqlSelect("series", "siniva", "codserie = '" + codSerie + "'")) {
		tieneIva = 0;
	} else {
		var regIva:String = util.sqlSelect("proveedores", "regimeniva", "codproveedor = '" + codProveedor + "'");
		if (regIva == "Exento") {
			tieneIva = 0;
		} else if (flfactppal.iface.pub_valorDefectoEmpresa("recequivalencia")) {
			tieneIva = 2;
		} else {
			tieneIva = 1;
		}
	}
	return tieneIva;
}

/** \D Indica si el módulo de autómata está instalado y activado
@return	true si está activado, false en caso contrario
\end */
function oficial_automataActivado():Boolean
{
	if (!sys.isLoadedModule("flautomata"))
		return false;

	if (formau_automata.iface.pub_activado())
		return true;

	return false;
}

/** \D Comprueba que si la factura tiene IVA, no esté incluida en un período de regularización ya cerrado
@param	curFactura: Cursor de la factura de cliente o proveedor
@return TRUE si la factura no tiene IVA o teniéndolo su fecha no está incluida en ningún período ya cerrado. FALSE en caso contrario
\end */
function oficial_comprobarRegularizacion(curFactura:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;

	var fecha:String = curFactura.valueBuffer("fecha");
	if (util.sqlSelect("co_regiva", "idregiva", "fechainicio <= '" + fecha + "' AND fechafin >= '" + fecha + "' AND codejercicio = '" + curFactura.valueBuffer("codejercicio") + "'")) {
		MessageBox.warning(util.translate("scripts", "No puede incluirse el asiento de la factura en un período de I.V.A. ya regularizado"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	return true;
}

/** \D
Recalcula la tabla huecos y el último valor de la secuencia de numeración.
@param serie: Código de serie del documento
@param ejercicio: Código de ejercicio del documento
@param fN: Tipo de documento (factura a cliente, a proveedor, albarán, etc.)
@return true si el calculo se ralizó correctamente
\end */
function oficial_recalcularHuecos( serie:String, ejercicio:String, fN:String ):Boolean {
	var util:FLUtil = new FLUtil;
	var tipo:String;
	var tabla:String;

	if ( fN == "nfacturaprov" ) {
		tipo = "FP";
		tabla = "facturasprov"
	} else if (fN == "nfacturacli") {
		tipo = "FC";
		tabla = "facturascli";
	}

	var idSec = util.sqlSelect( "secuenciasejercicios", "id", "codserie = '" + serie + "' AND codejercicio = '" + ejercicio + "'" );

	if ( idSec ) {
		var nHuecos:Number = parseInt( util.sqlSelect( "huecos", "count(*)", "codserie = '" + serie + "' AND codejercicio = '" + ejercicio + "' AND tipo = '" + tipo + "'" ) );
		var nFacturas:Number = parseInt( util.sqlSelect( tabla, "count(*)", "codserie = '" + serie + "' AND codejercicio = '" + ejercicio + "'" ) );
		var maxFactura:Number = parseInt( util.sqlSelect( "secuencias", "valorout", "id = " + idSec + " AND nombre='" + fN + "'" ) ) - 1;
		if (isNaN(maxFactura))
			maxFactura = 0;

		if ( maxFactura - nFacturas != nHuecos ) {
			var nSec:Number = 0;
			var nFac:Number = 0;
			var ultFac:Number = -1;
			var cursorHuecos:FLSqlCursor = new FLSqlCursor("huecos");
			var qryFac:FLSqlQuery = new FLSqlQuery();

			util.createProgressDialog( util.translate( "scripts", "Calculando huecos en la numeración..." ), maxFactura );

			qryFac.setTablesList( tabla );
			qryFac.setSelect( "numero" );
			qryFac.setFrom( tabla );
			qryFac.setWhere( "codserie = '" + serie + "' AND codejercicio = '" + ejercicio + "'" );
			qryFac.setOrderBy( "codigo asc" );
			qryFac.setForwardOnly( true );

			if ( !qryFac.exec() )
				return true;

			util.sqlDelete( "huecos", "codserie = '" + serie + "' AND codejercicio = '" + ejercicio + "' AND ( tipo = 'XX' OR tipo = '" + tipo + "')" );

			while ( qryFac.next() ) {
				nFac = qryFac.value( 0 );

				// Por si hay duplicados, que no debería haberlos...
				if (ultFac == nFac)
					continue;
				ultFac = nFac;

				util.setProgress( ++nSec );
				while ( nSec < nFac ) {
					cursorHuecos.setModeAccess( cursorHuecos.Insert );
					cursorHuecos.refreshBuffer();
					cursorHuecos.setValueBuffer( "tipo", tipo );
					cursorHuecos.setValueBuffer( "codserie", serie );
					cursorHuecos.setValueBuffer( "codejercicio", ejercicio );
					cursorHuecos.setValueBuffer( "numero", nSec );
					cursorHuecos.commitBuffer();
					util.setProgress( ++nSec );
				}
			}

			util.setProgress( ++nSec );
			util.sqlUpdate( "secuencias", "valorout", nSec, "id = " + idSec + " AND nombre='" + fN + "'" );

			util.setProgress( maxFactura );
			util.destroyProgressDialog();
		}
	}

	return true;
}

/** \D Lanza el formulario que muestra los documentos relacionados con un determinado documento de facturación
@param	codigo: Código del documento
@param	tipo: Tipo del documento
\end */
function oficial_mostrarTraza(codigo:String, tipo:String)
{
	var util:FLUtil = new FLUtil();
	util.sqlDelete("trazadoc", "usuario = '" + sys.nameUser() + "'");

	var f:Object = new FLFormSearchDB("trazadoc");
	var curTraza:FLSqlCursor = f.cursor();
	curTraza.setModeAccess(curTraza.Insert);
	curTraza.refreshBuffer();
	curTraza.setValueBuffer("usuario", sys.nameUser());
	curTraza.setValueBuffer("codigo", codigo);
	curTraza.setValueBuffer("tipo", tipo);
	if (!curTraza.commitBuffer())
		return false;;

	curTraza.select("usuario = '" + sys.nameUser() + "'");
	if (!curTraza.first())
		return false;

	curTraza.setModeAccess(curTraza.Browse);
	f.setMainWidget();
	curTraza.refreshBuffer();
	var acpt:String = f.exec("usuario");
}

/** \D Establece los datos opcionales de una partida de IVA decompras/ventas.
Para facilitar personalizaciones en las partidas.
Se ponen datos de concepto, tipo de documento, documento y factura
@param	curPartida: Cursor sobre la partida
@param	curFactura: Cursor sobre la factura
@param	tipo: cliente / proveedor
@param	concepto: Concepto, opcional
*/
function oficial_datosPartidaFactura(curPartida:FLSqlCursor, curFactura:FLSqlCursor, tipo:String, concepto:String)
{
	var util:FLUtil = new FLUtil();

	if (tipo == "cliente") {
		if (concepto) {
			curPartida.setValueBuffer("concepto", concepto);
		} else {
			curPartida.setValueBuffer("concepto", util.translate("scripts", "Nuestra factura") + " " + curFactura.valueBuffer("codigo") + " - " + curFactura.valueBuffer("nombrecliente"));
		}
		// Si es de IVA
		if (curPartida.valueBuffer("cifnif")) {
			curPartida.setValueBuffer("tipodocumento", "Factura de cliente");
		}
	}
	else {
		if (concepto) {
			curPartida.setValueBuffer("concepto", concepto);
		} else {
			var numFactura:String = curFactura.valueBuffer("numproveedor");
			if (numFactura == "") {
				numFactura = curFactura.valueBuffer("codigo");
			}
			curPartida.setValueBuffer("concepto", util.translate("scripts", "Su factura") + " " + numFactura + " - " + curFactura.valueBuffer("nombre"));
		}

		// Si es de IVA
		if (curPartida.valueBuffer("cifnif")) {
			curPartida.setValueBuffer("tipodocumento", "Factura de proveedor");
		}
	}

	// Si es de IVA
	if (curPartida.valueBuffer("cifnif")) {
		curPartida.setValueBuffer("documento", curFactura.valueBuffer("codigo"));
		curPartida.setValueBuffer("factura", curFactura.valueBuffer("numero"));
	}
}

/** \D Comprueba si hay condiciones para regenerar los recibos de una factura
cuando se edita la misma. Para sobrecargar en extensiones
@param	curFactura: Cursor de la factura
@param	masCampos: Array con los nombres de campos adicionales. Opcional
@return	VERDADERO si hay que regenerar, FALSO en otro caso
\end */
function oficial_siGenerarRecibosCli(curFactura:FLSqlCursor, masCampos:Array):Boolean
{
	var camposAcomprobar = new Array("codcliente","total","codpago","fecha");

	for (var i:Number = 0; i < camposAcomprobar.length; i++)
		if (curFactura.valueBuffer(camposAcomprobar[i]) != curFactura.valueBufferCopy(camposAcomprobar[i]))
			return true;

	if (masCampos) {
		for (i = 0; i < masCampos.length; i++)
			if (curFactura.valueBuffer(masCampos[i]) != curFactura.valueBufferCopy(masCampos[i]))
				return true;
	}

	return false;
}

function oficial_validarIvaRecargoCliente(codCliente:String,id:Number,tabla:String,identificador:String):Boolean
{
	var util:FLUtil;

	if(!codCliente)
		return true;

	var regimenIva = util.sqlSelect("clientes","regimeniva","codcliente = '" + codCliente + "'");
	var aplicarRecargo = util.sqlSelect("clientes","recargo","codcliente = '" + codCliente + "'");

	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList(tabla);
	q.setSelect("iva,recargo");
	q.setFrom(tabla);
	q.setWhere(identificador + " = " + id);

	if (!q.exec())
		return false;

	var preguntadoIva:Boolean = false;
	var preguntadoRecargo:Boolean = false;
	while (q.next() && (!preguntadoIva || !preguntadoRecargo)) {
				var iva:Number = parseFloat(q.value("iva"));
		if(!iva)
			iva = 0;
		var recargo:Number = parseFloat(q.value("recargo"));
		if(!recargo)
			recargo = 0;

		if(!preguntadoIva) {
			switch (regimenIva) {
				case "General": {
					if (iva == 0) {
						var res:Number = MessageBox.warning(util.translate("scripts", "El cliente %1 tiene establecido un régimen de I.V.A. %2\ny en alguna o varias de las lineas no hay establecido un % de I.V.A.\n¿Desea continuar de todas formas?").arg(codCliente).arg(regimenIva), MessageBox.Yes,MessageBox.No);
						preguntadoIva = true;
						if (res != MessageBox.Yes)
							return false;
					}
				}
				break;
				case "Exento": {
					if (iva != 0) {
						var res:Number = MessageBox.warning(util.translate("scripts", "El cliente %1 tiene establecido un régimen de I.V.A. %2\ny en alguna o varias de las lineas hay establecido un % de I.V.A.\n¿Desea continuar de todas formas?").arg(codCliente).arg(regimenIva), MessageBox.Yes,MessageBox.No);
						preguntadoIva = true;
						if (res != MessageBox.Yes)
							return false;
					}
				}
				break;
			}
		}
		if(!preguntadoRecargo) {
			if (aplicarRecargo && recargo == 0) {
				var res:Number = MessageBox.warning(util.translate("scripts", "Al cliente %1 se le debe aplicar Recargo de Equivalencia\ny en alguna o varias de las lineas no hay establecido un % de R. Equivalencia.\n¿Desea continuar de todas formas?").arg(codCliente), MessageBox.Yes,MessageBox.No);
				preguntadoRecargo = true;
				if (res != MessageBox.Yes)
					return false;
			}
			if (!aplicarRecargo && recargo != 0) {
				var res:Number = MessageBox.warning(util.translate("scripts", "Al cliente %1 no se le debe aplicar Recargo de Equivalencia\ny en alguna o varias de las lineas hay establecido un % de R. Equivalencia.\n¿Desea continuar de todas formas?").arg(codCliente), MessageBox.Yes,MessageBox.No);
				preguntadoRecargo = true;
				if (res != MessageBox.Yes)
					return false;
			}
		}
	}

	return true;
}

function oficial_validarIvaRecargoProveedor(codProveedor:String,id:Number,tabla:String,identificador:String):Boolean
{
	var util:FLUtil;

	if(!codProveedor)
		return true;

	var regimenIva = util.sqlSelect("proveedores","regimeniva","codproveedor = '" + codProveedor + "'");
	var aplicarRecargo = util.sqlSelect("empresa","recequivalencia","1 = 1");

	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList(tabla);
	q.setSelect("iva,recargo");
	q.setFrom(tabla);
	q.setWhere(identificador + " = " + id);

	if (!q.exec())
		return false;

	var preguntadoIva:Boolean = false;
	var preguntadoRecargo:Boolean = false;
	while (q.next()  && (!preguntadoIva || !preguntadoRecargo)) {
		var iva:Number = parseFloat(q.value("iva"));
		if(!iva)
			iva = 0;
		var recargo:Number = parseFloat(q.value("recargo"));
		if(!recargo)
			recargo = 0;

		if(!preguntadoIva) {
			switch (regimenIva) {
				case "General":
				case "U.E.": {
					if (iva == 0) {
						var res:Number = MessageBox.warning(util.translate("scripts", "El proveedor %1 tiene establecido un régimen de I.V.A. %2\ny en alguna o varias de las lineas no hay establecido un % de I.V.A.\n¿Desea continuar de todas formas?").arg(codProveedor).arg(regimenIva), MessageBox.Yes,MessageBox.No);
						preguntadoIva = true;
						if (res != MessageBox.Yes)
							return false;
					}
				}
				break;
				case "Exento": {
					if (iva != 0) {
						var res:Number = MessageBox.warning(util.translate("scripts", "El proveedor %1 tiene establecido un régimen de I.V.A. %2\ny en alguna o varias de las lineas hay establecido un % de I.V.A.\n¿Desea continuar de todas formas?").arg(codProveedor).arg(regimenIva), MessageBox.Yes,MessageBox.No);
						preguntadoIva = true;
						if (res != MessageBox.Yes)
							return false;
					}
				}
				break;
			}
		}
		if(!preguntadoRecargo) {
			if (aplicarRecargo && recargo == 0) {
				var res:Number = MessageBox.warning(util.translate("scripts", "En los datos de empresa está activa al opción Aplicar Recargo de Equivalencia\ny en alguna o varias de las lineas no hay establecido un % de R. Equivalencia.\n¿Desea continuar de todas formas?"), MessageBox.Yes,MessageBox.No);
				preguntadoRecargo = true;
				if (res != MessageBox.Yes)
					return false;
			}
			if (!aplicarRecargo && recargo != 0) {
				var res:Number = MessageBox.warning(util.translate("scripts", "En los datos de empresa no está activa al opción Aplicar Recargo de Equivalencia\ny en alguna o varias de las lineas hay establecido un % de R. Equivalencia.\n¿Desea continuar de todas formas?"), MessageBox.Yes,MessageBox.No);
				preguntadoRecargo = true;
				if (res != MessageBox.Yes)
					return false;
			}
		}
	}

	return true;
}

function oficial_comprobarFacturaAbonoCli(curFactura:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	if (curFactura.valueBuffer("deabono") == true) {
		if (!curFactura.valueBuffer("idfacturarect")){
			var res:Number = MessageBox.warning(util.translate("scripts", "No ha indicado la factura que desea abonar.\n¿Desea continuar?"), MessageBox.No, MessageBox.Yes);
			if (res != MessageBox.Yes) {
				return false;
			}
		} else {
			if (util.sqlSelect("facturascli", "idfacturarect", "idfacturarect = " + curFactura.valueBuffer("idfacturarect") + " AND idfactura <> " + curFactura.valueBuffer("idfactura"))) {
				MessageBox.warning(util.translate("scripts", "La factura ") +  util.sqlSelect("facturascli", "codigo", "idfactura = " + curFactura.valueBuffer("idfacturarect"))  + util.translate("scripts", " ya está abonada"),MessageBox.Ok, MessageBox.NoButton,MessageBox.NoButton);
				return false;
			}
		}
	}
	return true;
}

function oficial_crearCtaEspecial(codCtaEspecial:String, tipo:String, codEjercicio:String, desCta:String):Boolean
{
	var util:FLUtil = new FLUtil();

	var codSubcuenta:String;
	if (tipo == "subcuenta") {
		var f:Object = new FLFormSearchDB("co_subcuentas");
		var curSubcuenta:FLSqlCursor = f.cursor();
		curSubcuenta.setMainFilter("codejercicio = '" + codEjercicio + "'");

		f.setMainWidget();
		codSubcuenta = f.exec("codsubcuenta");
		if (!codSubcuenta)
			return false;
	}
	var curCtaEspecial:FLSqlCursor = new FLSqlCursor("co_cuentasesp");
	curCtaEspecial.select("idcuentaesp = '" + codCtaEspecial + "'");
	if (curCtaEspecial.first()) {
		curCtaEspecial.setModeAccess(curCtaEspecial.Edit);
		curCtaEspecial.refreshBuffer();
	} else {
		curCtaEspecial.setModeAccess(curCtaEspecial.Insert);
		curCtaEspecial.refreshBuffer();
		curCtaEspecial.setValueBuffer("idcuentaesp", codCtaEspecial);
		curCtaEspecial.setValueBuffer("descripcion", desCta);
	}
	if (codSubcuenta && codSubcuenta != "") {
		curCtaEspecial.setValueBuffer("codsubcuenta", codSubcuenta);
	}
	if (!curCtaEspecial.commitBuffer())
		return false;

	return true;
}

function oficial_comprobarCambioSerie(cursor:FLSqlCursor):Boolean
{
	var util:FLUtil;
	if(!cursor.valueBuffer("codserie") || cursor.valueBuffer("codserie") == "" || !cursor.valueBufferCopy("codserie") || cursor.valueBufferCopy("codserie") == "")
		return true;
	if(cursor.valueBuffer("codserie") != cursor.valueBufferCopy("codserie")) {
		var util:FLUtil = new FLUtil();
		MessageBox.warning(util.translate("scripts", "No se puede modificar la serie.\nSerie anterior:%1 - Serie actual:%2").arg(cursor.valueBufferCopy("codserie")).arg(cursor.valueBuffer("codserie")), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
	return true;
}

/** Función a sobrecargar por la extensión de subcuenta de ventas por artículo
\end */
function oficial_subcuentaVentas(referencia:String, codEjercicio:String):Array
{
	return false;
}

// function oficial_liberarPedidosCli(curAlbaran:FLSqlCursor):Boolean
// {
// 	var idLineaAlbaran:Number;
// 	var idLineaPedido:Number;
// 	var numeroPedido:Number;
//
// 	var query:FLSqlQuery = new FLSqlQuery();
// 	query.setTablesList("lineasalbaranescli");
// 	query.setSelect("idlineapedido, idlinea");
// 	query.setFrom("lineasalbaranescli");
// 	query.setWhere("idalbaran = " + curAlbaran.valueBuffer("idalbaran") + " AND idlineapedido <> 0;");
// 	query.exec();
//
// 	while (query.next()) {
// 		idLineaPedido = query.value("idlineapedido");
// 		idLineaAlbaran = query.value("idlinea");
// 		if (!this.iface.restarCantidadCli(idLineaPedido, idLineaAlbaran)) {
// 			return false;
// 		}
// 	}
//
// 	var qryPedido:FLSqlQuery = new FLSqlQuery();
// 	qryPedido.setTablesList("lineasalbaranescli");
// 	qryPedido.setSelect("idpedido");
// 	qryPedido.setFrom("lineasalbaranescli");
// 	qryPedido.setWhere("idalbaran = " + curAlbaran.valueBuffer("idalbaran") + " AND idpedido <> 0 GROUP BY idpedido;");
// 	qryPedido.exec();
// 	while (qryPedido.next()) {
// 		idPedido = qryPedido.value("idpedido");
// 		formRecordlineasalbaranescli.iface.pub_actualizarEstadoPedido(idPedido, curAlbaran);
// 	}
// 	return true;
// }

// function oficial_liberarPedidosProv(curAlbaran:FLSqlCursor):Boolean
// {
// 	var idLineaAlbaran:Number;
// 	var idLineaPedido:Number;
// 	var numeroPedido:Number;
//
// 	var query:FLSqlQuery = new FLSqlQuery();
// 	query.setTablesList("lineasalbaranesprov");
// 	query.setSelect("idlineapedido, idlinea");
// 	query.setFrom("lineasalbaranesprov");
// 	query.setWhere("idalbaran = " + curAlbaran.valueBuffer("idalbaran") + " AND idlineapedido <> 0;");
// 	query.exec();
//
// 	while (query.next()) {
// 		idLineaPedido = query.value("idlineapedido");
// 		idLineaAlbaran = query.value("idlinea");
// 		if (!this.iface.restarCantidadProv(idLineaPedido, idLineaAlbaran)) {
// 			return false;
// 		}
// 	}
//
// 	var qryPedido = new FLSqlQuery();
// 	qryPedido.setTablesList("lineasalbaranesprov");
// 	qryPedido.setSelect("idpedido");
// 	qryPedido.setFrom("lineasalbaranesprov");
// 	qryPedido.setWhere("idalbaran = " + curAlbaran.valueBuffer("idalbaran") + " AND idpedido <> 0 GROUP BY idpedido;");
// 	qryPedido.exec();
// 	while (qryPedido.next()) {
// 		idPedido = qryPedido.value("idpedido");
// 		formRecordlineasalbaranesprov.iface.pub_actualizarEstadoPedido(idPedido);
// 	}
// 	return true;
// }

/** \D
Cambia el valor del campo totalenalbarán de una determinada línea de pedido, calculándolo como la suma de cantidades en otras líneas distintas de la línea de albarán indicada
@param idLineaPedido: Identificador de la línea de pedido
@param idLineaAlbaran: Identificador de la línea de albarán
\end */
function oficial_restarCantidadCli(idLineaPedido:Number, idLineaAlbaran:Number):Boolean
{
	var util:FLUtil = new FLUtil;
	var cantidad:Number = parseFloat(util.sqlSelect("lineasalbaranescli", "SUM(cantidad)", "idlineapedido = " + idLineaPedido + " AND idlinea <> " + idLineaAlbaran));
	if (isNaN(cantidad))
		cantidad = 0;

	var curLineaPedido:FLSqlCursor = new FLSqlCursor("lineaspedidoscli");
	curLineaPedido.select("idlinea = " + idLineaPedido);
	if (curLineaPedido.first()) {
		curLineaPedido.setModeAccess(curLineaPedido.Edit);
		curLineaPedido.refreshBuffer();
		curLineaPedido.setValueBuffer("totalenalbaran", cantidad);
		if (!curLineaPedido.commitBuffer()) {
			return false;
		}
	}
	return true;
}

/** \D
Cambia el valor del campo totalenalbarán de una determinada línea de pedido, calculándolo como la suma de cantidades en otras líneas distintas de la línea de albarán indicada
@param idLineaPedido: Identificador de la línea de pedido
@param idLineaAlbaran: Identificador de la línea de albarán
\end */
function oficial_restarCantidadProv(idLineaPedido:Number, idLineaAlbaran:Number):Boolean
{
	var util:FLUtil = new FLUtil;
	var cantidad:Number = parseFloat(util.sqlSelect("lineasalbaranesprov", "SUM(cantidad)", "idlineapedido = " + idLineaPedido + " AND idlinea <> " + idLineaAlbaran));
	if (isNaN(cantidad))
		cantidad = 0;

	var curLineaPedido:FLSqlCursor = new FLSqlCursor("lineaspedidosprov");
	curLineaPedido.select("idlinea = " + idLineaPedido);
	if (curLineaPedido.first()) {
		curLineaPedido.setModeAccess(curLineaPedido.Edit);
		curLineaPedido.refreshBuffer();
		curLineaPedido.setValueBuffer("totalenalbaran", cantidad);
		if (!curLineaPedido.commitBuffer()) {
			return false;
		}
	}
	return true;
}

function oficial_actualizarPedidosCli(curAlbaran:FLSqlCursor):Boolean
{
	return true;
/*
	var util:FLUtil = new FLUtil();

	var query:FLSqlQuery = new FLSqlQuery();
	query.setTablesList("lineasalbaranescli");
	query.setSelect("idlineapedido, idpedido, referencia, idalbaran, cantidad");
	query.setFrom("lineasalbaranescli");
	query.setWhere("idalbaran = " + curAlbaran.valueBuffer("idalbaran") + " AND idlineapedido <> 0 ORDER BY idpedido");
	try { query.setForwardOnly( true ); } catch (e) {}
	query.exec();
	var idPedido:String = 0;
	while (query.next()) {
		if (!this.iface.actualizarLineaPedidoCli(query.value(0), query.value(1), query.value(2), query.value(3), query.value(4))) {
			return false;
		}

		if (idPedido != query.value(1)) {
			if (!this.iface.actualizarEstadoPedidoCli(query.value(1), curAlbaran))
				return false;
		}
		idPedido = query.value(1)
	}
	return true;*/
}

function oficial_actualizarPedidosProv(curAlbaran:FLSqlCursor):Boolean
{
return true;
// 	var util:FLUtil = new FLUtil();
//
// 	var query:FLSqlQuery = new FLSqlQuery();
// 	query.setTablesList("lineasalbaranesprov");
// 	query.setSelect("idlineapedido, idpedido, referencia, idalbaran, cantidad");
// 	query.setFrom("lineasalbaranesprov");
// 	query.setWhere("idalbaran = " + curAlbaran.valueBuffer("idalbaran") + " AND idlineapedido <> 0 ORDER BY idpedido");
// 	query.setForwardOnly(true);
// 	query.exec();
// 	var idPedido:String = 0;
// 	while (query.next()) {
// 		if (!this.iface.actualizarLineaPedidoProv(query.value(0), query.value(1), query.value(2), query.value(3), query.value(4))) {
// 			return false;
// 		}
// 		if (idPedido != query.value(1)) {
// 			if (!this.iface.actualizarEstadoPedidoProv(query.value(1), curAlbaran))
// 				return false;
// 		}
// 		idPedido = query.value(1);
// 	}
// 	return true;
}

/** \C
Actualiza el campo total en albarán de la línea de pedido correspondiente (si existe).
@param	idLineaPedido: Id de la línea a actualizar
@param	idPedido: Id del pedido a actualizar
@param	referencia del artículo contenido en la línea
@param	idAlbaran: Id del albarán en el que se sirve el pedido
@param	cantidadLineaAlbaran: Cantidad total de artículos de la referencia actual en el albarán
@return	True si la actualización se realiza correctamente, false en caso contrario
\end */
function oficial_actualizarLineaPedidoProv(idLineaPedido:Number, idPedido:Number, referencia:String, idAlbaran:Number, cantidadLineaAlbaran:Number):Boolean
{
	if (idLineaPedido == 0) {
		return true;
	}

	var cantidadServida:Number;
	var curLineaPedido:FLSqlCursor = new FLSqlCursor("lineaspedidosprov");
	curLineaPedido.select("idlinea = " + idLineaPedido);
	curLineaPedido.setModeAccess(curLineaPedido.Edit);
	if (!curLineaPedido.first()) {
		return true;
	}
	var cantidadPedido:Number = parseFloat(curLineaPedido.valueBuffer("cantidad"));
	var query:FLSqlQuery = new FLSqlQuery();
	query.setTablesList("lineasalbaranesprov");
	query.setSelect("SUM(cantidad)");
	query.setFrom("lineasalbaranesprov");
	query.setWhere("idlineapedido = " + idLineaPedido + " AND idalbaran <> " + idAlbaran);
	if (!query.exec()) {
		return false;
	}
	if (query.next()) {
		var canOtros:Number = parseFloat(query.value("SUM(cantidad)"));
		if (isNaN(canOtros)) {
			canOtros = 0;
		}
		cantidadServida = canOtros + parseFloat(cantidadLineaAlbaran);
	}
	if (cantidadServida > cantidadPedido)
		cantidadServida = cantidadPedido;

	curLineaPedido.setValueBuffer("totalenalbaran", cantidadServida);
	if (!curLineaPedido.commitBuffer()) {
		return false;
	}

	return true;
}

/** \C
Marca el pedido como servido o parcialmente servido según corresponda.
@param	idPedido: Id del pedido a actualizar
@param	curAlbaran: Cursor posicionado en el albarán que modifica el estado del pedido
@return	True si la actualización se realiza correctamente, false en caso contrario
\end */
function oficial_actualizarEstadoPedidoProv(idPedido:Number, curAlbaran:FLSqlCursor):Boolean
{
	var estado:String = this.iface.obtenerEstadoPedidoProv(idPedido);
	if (!estado) {
		return false;
	}
	var curPedido:FLSqlCursor = new FLSqlCursor("pedidosprov");
	curPedido.select("idpedido = " + idPedido);
	if (curPedido.first()) {
		if (estado == curPedido.valueBuffer("servido")) {
			return true;
		}
		curPedido.setUnLock("editable", true);
	}

	curPedido.select("idpedido = " + idPedido);
	curPedido.setModeAccess(curPedido.Edit);
	if (curPedido.first()) {
		curPedido.setValueBuffer("servido", estado);
		if (estado == "Sí") {
			curPedido.setValueBuffer("editable", false);
			if (sys.isLoadedModule("flcolaproc")) {
				if (!flfactppal.iface.pub_lanzarEvento(curPedido, "pedidoProvAlbaranado")) {
					return false;
				}
			}
		}
		if (!curPedido.commitBuffer()) {
			return false;
		}
	}
	return true;
}

/** \C
Obtiene el estado de un pedido
@param	idPedido: Id del pedido a actualizar
@return	True si la actualización se realiza correctamente, false en caso contrario
\end */
function oficial_obtenerEstadoPedidoProv(idPedido:Number):String
{
	var query:FLSqlQuery = new FLSqlQuery();

	query.setTablesList("lineaspedidosprov");
	query.setSelect("cantidad, totalenalbaran, cerrada");
	query.setFrom("lineaspedidosprov");
	query.setWhere("idpedido = " + idPedido);
	if (!query.exec()) {
		return false;
	}

	var estado:String = "";
	var totalServidas:Number = 0;
	var parcial:Boolean = false;
	var totalLineas:Number = query.size();
	var totalCerradas:Number = 0;

	if (totalLineas == 0) {
		return "No";
	}
	var cantidad:Number, cantidadServida:Number;
	var cerrada:Boolean;
	while (query.next()) {
		cantidad = parseFloat(query.value("cantidad"));
		cantidadServida = parseFloat(query.value("totalenalbaran"));
		cerrada = query.value("cerrada");
		if (cerrada) {
			totalCerradas++;
		} else if (cantidad == cantidadServida) {
			totalServidas++;
		} else {
			if (cantidad > cantidadServida && cantidadServida != 0) {
				parcial = true;
			}
		}
	}

	var totalAServir:Number = totalLineas - totalCerradas;
	if (parcial) {
		estado = "Parcial";
	} else {
		if (totalServidas == 0 && totalCerradas == 0) {
			estado = "No";
		} else {
			if (totalServidas >= totalAServir) {
				estado = "Sí";
			} else {
				estado = "Parcial";
			}
		}
	}
	return estado;
}

/** \C
Actualiza el campo total en albarán de la línea de pedido correspondiente (si existe).
@param	idLineaPedido: Id de la línea a actualizar
@param	idPedido: Id del pedido a actualizar
@param	referencia del artículo contenido en la línea
@param	idAlbaran: Id del albarán en el que se sirve el pedido
@param	cantidadLineaAlbaran: Cantidad total de artículos de la referencia actual en el albarán
@return	True si la actualización se realiza correctamente, false en caso contrario
\end */
function oficial_actualizarLineaPedidoCli(idLineaPedido:Number, idPedido:Number, referencia:String, idAlbaran:Number, cantidadLineaAlbaran:Number):Boolean
{
	if (idLineaPedido == 0) {
		return true;
	}

	var cantidadServida:Number;
	var curLineaPedido:FLSqlCursor = new FLSqlCursor("lineaspedidoscli");
	curLineaPedido.select("idlinea = " + idLineaPedido);
	curLineaPedido.setModeAccess(curLineaPedido.Edit);
	if (!curLineaPedido.first()) {
		return true;
	}

	var cantidadPedido:Number = parseFloat(curLineaPedido.valueBuffer("cantidad"));
	var query:FLSqlQuery = new FLSqlQuery();
	query.setTablesList("lineasalbaranescli");
	query.setSelect("SUM(cantidad)");
	query.setFrom("lineasalbaranescli");
	query.setWhere("idlineapedido = " + idLineaPedido + " AND idalbaran <> " + idAlbaran);
	if (!query.exec()) {
		return false;
	}
	if (query.next()) {
		var canOtros:Number = parseFloat(query.value("SUM(cantidad)"));
		if (isNaN(canOtros)) {
			canOtros = 0;
		}
		cantidadServida = canOtros + parseFloat(cantidadLineaAlbaran);
	}
	if (cantidadServida > cantidadPedido) {
		cantidadServida = cantidadPedido;
	}

	curLineaPedido.setValueBuffer("totalenalbaran", cantidadServida);
	if (!curLineaPedido.commitBuffer()) {
		return false;
	}

	return true;
}

/** \C
Marca el pedido como servido o parcialmente servido según corresponda.
@param	idPedido: Id del pedido a actualizar
@param	curAlbaran: Cursor posicionado en el albarán que modifica el estado del pedido
@return	True si la actualización se realiza correctamente, false en caso contrario
\end */
function oficial_actualizarEstadoPedidoCli(idPedido:Number, curAlbaran:FLSqlCursor):Boolean
{
	var estado:String = this.iface.obtenerEstadoPedidoCli(idPedido);
	if (!estado) {
		return false;
	}

	var curPedido:FLSqlCursor = new FLSqlCursor("pedidoscli");
	curPedido.select("idpedido = " + idPedido);
	if (curPedido.first()) {
		if (estado == curPedido.valueBuffer("servido")) {
			return true;
		}
		curPedido.setUnLock("editable", true);
	}

	curPedido.select("idpedido = " + idPedido);
	curPedido.setModeAccess(curPedido.Edit);
	if (curPedido.first()) {
		curPedido.setValueBuffer("servido", estado);
		if (estado == "Sí") {
			curPedido.setValueBuffer("editable", false);
		}
		if (!curPedido.commitBuffer()) {
			return false;
		}
	}
	return true;
}

/** \C
Obtiene el estado de un pedido
@param	idPedido: Id del pedido a actualizar
@return	Estado del pedido
\end */
function oficial_obtenerEstadoPedidoCli(idPedido:Number):String
{
	var query:FLSqlQuery = new FLSqlQuery();

	query.setTablesList("lineaspedidoscli");
	query.setSelect("cantidad, totalenalbaran, cerrada");
	query.setFrom("lineaspedidoscli");
	query.setWhere("idpedido = " + idPedido);
	if (!query.exec()) {
		return false;
	}

	var estado:String = "";
	var totalServidas:Number = 0;
	var parcial:Boolean = false;
	var totalLineas:Number = query.size();
	var totalCerradas:Number = 0;

	if (totalLineas == 0) {
		return "No";
	}
	var cantidad:Number, cantidadServida:Number;
	var cerrada:Boolean;
	while (query.next()) {
		cantidad = parseFloat(query.value("cantidad"));
		cantidadServida = parseFloat(query.value("totalenalbaran"));
		cerrada = query.value("cerrada");
		if (cerrada) {
			totalCerradas++;
		} else if (cantidad == cantidadServida) {
			totalServidas++;
		} else {
			if (cantidad > cantidadServida && cantidadServida != 0) {
				parcial = true;
			}
		}
	}

	var totalAServir:Number = totalLineas - totalCerradas;
	if (parcial) {
		estado = "Parcial";
	} else {
		if (totalServidas == 0 && totalCerradas == 0) {
			estado = "No";
		} else {
			if (totalServidas >= totalAServir) {
				estado = "Sí";
			} else {
				estado = "Parcial";
			}
		}
	}
	return estado;
}

/** \D
Llama a la función liberarAlbaran para todos los albaranes agrupados en una factura
@param idFactura: Identificador de la factura
\end */
function oficial_liberarAlbaranesCli(idFactura:Number):Boolean
{
	var curAlbaranes:FLSqlCursor = new FLSqlCursor("albaranescli");
	curAlbaranes.select("idfactura = " + idFactura);
	while (curAlbaranes.next()) {
		if (!this.iface.liberarAlbaranCli(curAlbaranes.valueBuffer("idalbaran"))) {
			return false;
		}
	}
	return true;
}

/** \D
Desbloquea un albarán que estaba asociado a una factura
@param idAlbaran: Identificador del albarán
\end */
function oficial_liberarAlbaranCli(idAlbaran:Number):Boolean
{
	var curAlbaran:FLSqlCursor = new FLSqlCursor("albaranescli");
	with(curAlbaran) {
		select("idalbaran = " + idAlbaran);
		first();
		setUnLock("ptefactura", true);
		setModeAccess(Edit);
		refreshBuffer();
		setValueBuffer("idfactura", "0");
	}
	if (!curAlbaran.commitBuffer()) {
		return false;
	}
	return true;
}

/** \D
Llama a la función liberarAlbaran para todos los albaranes agrupados en una factura
@param idFactura: Identificador de la factura
\end */
function oficial_liberarAlbaranesProv(idFactura:Number):Boolean
{
	var curAlbaranes:FLSqlCursor = new FLSqlCursor("albaranesprov");
	curAlbaranes.select("idfactura = " + idFactura);
	while (curAlbaranes.next()) {
		if (!this.iface.liberarAlbaranProv(curAlbaranes.valueBuffer("idalbaran"))) {
			return false;
		}
	}
	return true;
}

/** \D
Desbloquea un albarán que estaba asociado a una factura
@param idAlbaran: Identificador del albarán
\end */
function oficial_liberarAlbaranProv(idAlbaran:Number):Boolean
{
	var curAlbaran:FLSqlCursor = new FLSqlCursor("albaranesprov");
	with(curAlbaran) {
		select("idalbaran = " + idAlbaran);
		first();
		setUnLock("ptefactura", true);
		setModeAccess(Edit);
		refreshBuffer();
		setValueBuffer("idfactura", "0");
	}
	if (!curAlbaran.commitBuffer()) {
		return false;
	}
	return true;
}

function oficial_liberarPresupuestoCli(idPresupuesto:Number):Boolean
{
	if (idPresupuesto) {
		var curPresupuesto = new FLSqlCursor("presupuestoscli");
		curPresupuesto.select("idpresupuesto = " + idPresupuesto);
		if (!curPresupuesto.first()) {
			return false;
		}
		with(curPresupuesto) {
			setUnLock("editable", true);
		}
	}
	return true;
}

function oficial_aplicarComisionLineas(codAgente:String,tblHija:String,where:String):Boolean
{
	var util:FLUtil;

	var numLineas:Number = util.sqlSelect(tblHija,"count(idlinea)",where);
	if(!numLineas)
		return true;

	var referencia:String = "";
	var comision:Number = 0;

	if(!codAgente || codAgente == "")
		return false;

	var curLineas:FLSqlCursor = new FLSqlCursor(tblHija);
	curLineas.select(where);

	util.createProgressDialog(util.translate( "scripts", "Actualizando comisión ..." ), numLineas);

	var i:Number = 0;
	while (curLineas.next()) {
		util.setProgress(i++);
		curLineas.setActivatedCommitActions(false);
		curLineas.setModeAccess(curLineas.Edit);
		curLineas.refreshBuffer();
// 		comision = formRecordlineaspedidoscli.iface.pub_commonCalculateField("porcomision",curLineas);
		referencia = curLineas.valueBuffer("referencia");
		comision = this.iface.calcularComisionLinea(codAgente,referencia);
		comision = util.roundFieldValue(comision, tblHija, "porcomision");
		curLineas.setValueBuffer("porcomision",comision);
		if(!curLineas.commitBuffer()) {
			util.destroyProgressDialog();
			return false;
		}
	}
	util.setProgress(numLineas);
	util.destroyProgressDialog();
	return true;
}

function oficial_calcularComisionLinea(codAgente:String,referencia:String):Number
{
	var util:FLUtil;
	var valor:Number = -1;

	if(referencia && referencia != "") {
		var id:Number = util.sqlSelect("articulosagen", "id", "referencia = '" + referencia + "' AND codagente = '" + codAgente + "'");
		if(id)
			valor = parseFloat(util.sqlSelect("articulosagen", "comision", "id = " + id));
	}

	if(valor == -1)
		valor = parseFloat(util.sqlSelect("agentes", "porcomision", "codagente = '" + codAgente + "'"));

	valor = util.roundFieldValue(valor, "agentes", "porcomision");

	return valor;
}

function oficial_arrayCostesAfectados(arrayInicial:Array, arrayFinal:Array):Array
{
	var arrayAfectados:Array = [];
	var iAA:Number = 0;
	var iAI:Number = 0;
	var iAF:Number = 0;
	var longAI:Number = arrayInicial.length;
	var longAF:Number = arrayFinal.length;

// debug("ARRAY INICIAL");
// for (var i:Number = 0; i < arrayInicial.length; i++) {
// 	debug(" " + arrayInicial[i]["idarticulo"] + "-" + arrayInicial[i]["cantidad"]);
// }
// debug("ARRAY FINAL");
// for (var i:Number = 0; i < arrayFinal.length; i++) {
// 	debug(" " + arrayFinal[i]["idarticulo"] + "-" + arrayFinal[i]["cantidad"]);
// }

	arrayInicial.sort(this.iface.compararArrayCoste);
	arrayFinal.sort(this.iface.compararArrayCoste);

// debug("ARRAY INICIAL ORDENADO");
// for (var i:Number = 0; i < arrayInicial.length; i++) {
// 	debug(" " + arrayInicial[i]["idarticulo"] + "-" + arrayInicial[i]["cantidad"]);
// }
// debug("ARRAY FINAL ORDENADO");
// for (var i:Number = 0; i < arrayFinal.length; i++) {
// 	debug(" " + arrayFinal[i]["idarticulo"] + "-" + arrayFinal[i]["cantidad"]);
// }
	var comparacion:Number;
	while (iAI < longAI || iAF < longAF) {
		if (iAI < longAI && iAF < longAF) {
			comparacion = this.iface.compararArrayCoste(arrayInicial[iAI], arrayFinal[iAF]);
		} else if (iAF < longAF) {
			comparacion = 1;
		} else if (iAI < longAI) {
			comparacion = -1;
		}
		switch (comparacion) {
			case 1: {
				arrayAfectados[iAA] = [];
				arrayAfectados[iAA]["idarticulo"] = arrayFinal[iAF]["idarticulo"];
				iAF++;
				iAA++;
				break;
			}
			case -1: {
				arrayAfectados[iAA] = [];
				arrayAfectados[iAA]["idarticulo"] = arrayInicial[iAI]["idarticulo"];
				iAI++;
				iAA++;
				break;
			}
			case 0: {
				if ((arrayInicial[iAI]["cantidad"] != arrayFinal[iAF]["cantidad"]) || (arrayInicial[iAI]["pvptotal"] != arrayFinal[iAF]["pvptotal"])) {
					arrayAfectados[iAA] = [];
					arrayAfectados[iAA]["idarticulo"] = arrayFinal[iAI]["idarticulo"];
					iAA++;
				}
				iAI++;
				iAF++;
				break;
			}
		}
	}
	return arrayAfectados;
}

/** \D Función de comparación de dos arrays con datos de cálculo de coste medio. La comparación se hace en base al identificador del artículo
@param	a: Array 1
@param	b: Array 2
@return	1: a > b, -1: a < b, 0: a = b
\end */
function oficial_compararArrayCoste(a:Array, b:Array):Number
{
	var resultado:Number = 0;
	if (a["idarticulo"] > b["idarticulo"]) {
		resultado = 1;
	} else if (a["idarticulo"] < b["idarticulo"]) {
		resultado = -1;
	}return resultado;
}

function oficial_campoImpuesto(campo:String, codImpuesto:String, fecha:String):Number
{
	var util:FLUtil = new FLUtil;
	return parseFloat(util.sqlSelect("impuestos", campo, "codimpuesto = '" + codImpuesto + "'"));
}

function oficial_datosImpuesto(codImpuesto:String, fecha:String):Array
{
	var datosImpuesto:Array;
	var qryImpuesto:FLSqlQuery = new FLSqlQuery();
	qryImpuesto.setTablesList("impuestos");
	qryImpuesto.setSelect("iva, recargo");
	qryImpuesto.setFrom("impuestos");
	qryImpuesto.setWhere("codimpuesto = '" + codImpuesto + "'");
	try { qryImpuesto.setForwardOnly( true ); } catch (e) {}

	if (!qryImpuesto.exec()) {
		return false;
	}

	if (!qryImpuesto.first()) {
		return false;
	}

	datosImpuesto.iva = qryImpuesto.value("iva");
	datosImpuesto.recargo = qryImpuesto.value("recargo");
	return datosImpuesto;
}

function oficial_valorDefecto(fN:String):String
{
	var util:FLUtil = new FLUtil;
	var valor:String = util.sqlSelect("facturac_general", fN, "1 = 1");
	if (!valor) {
		return "";
	}
	return valor;
}


function oficial_formateaCadena(cIn)
{
    var cOut = "";
    var equivA = "ÑñÇçÁáÉéÍíÓóÚúÀàÈèÌìÒòÙùÂâÊêÎîÔôÛûÄäËëÏïÖöÜüº";
    var equivB = "NnCcAaEeIiOoUuAaEeIiOoUuAaEeIiOoUuAaEeIiOoUu ";
    var validos = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ /-?+:,.'()";
    var iEq;
    for (var i = 0; i < cIn.length; i++) {
        iEq = equivA.find(cIn.charAt(i));
        if (iEq >= 0) {
            cOut += equivB.charAt(iEq);
        } else {
            if (validos.find(cIn.charAt(i)) >= 0) {
                cOut += cIn.charAt(i);
            }
        }
    }
    return cOut;
}
//// OFICIAL ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
//////////////////////////////////////////////////////////

