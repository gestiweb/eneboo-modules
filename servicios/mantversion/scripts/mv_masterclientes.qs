/***************************************************************************
                 co_masterasientos.qs  -  description
                             -------------------
    begin                : lun mar 28 2005
    copyright            : (C) 2005 by InfoSiAL S.L.
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
/* \C
Este formulario controla los clientes que tienen solicitada una o más funcionalidades. Nos permite, para el cliente seleccionado, obtener su personalización completa, pulsando el botón 'Generar personalización'.
\end */
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    function oficial( context ) { interna( context ); } 
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends oficial {
	var urlRepositorioMod:String;
	var urlRepositorioFun:String;
	var versionOficial:String;
	var util:Util;
	var versionActual:String;
	var tipoDocActual:String;
	var xmlDif:FLDomDocument;
	var pathLocal:String;
		
    function head( context ) { oficial ( context ); }
	function init() {
		return this.ctx.head_init();
	}
	function generar_clicked() {
		return this.ctx.head_generar_clicked();
	}
	function generar(idCliente:String) {
		return this.ctx.head_generar(idCliente);
	}
	function generarDirModulos(idCliente:String):Boolean {
		return this.ctx.head_generarDirModulos(idCliente);
	}
	function lanzarLog(accion:String) {
		return this.ctx.head_lanzarLog(accion);
	}
	function anadirAConfig(idFuncional:String, idCliente:String):Boolean {
		return this.ctx.head_anadirAConfig(idFuncional, idCliente);
	}
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration ifaceCtx */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends head {
    function ifaceCtx( context ) { head( context ); }
	function pub_generar(idCliente:String) {
		return this.generar(idCliente);
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

function init() {
    this.iface.init();
}

function interna_init() {

}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
function head_init()
{
	this.iface.util = new FLUtil;
	this.iface.urlRepositorioMod = flmaveppal.iface.pub_obtenerUrlRepositorioMod();
	this.iface.urlRepositorioFun = flmaveppal.iface.pub_obtenerUrlRepositorioFun();
	this.iface.versionOficial = flmaveppal.iface.pub_obtenerVersionOficial();
	this.iface.versionActual = "r_";
	this.iface.pathLocal = flmaveppal.iface.pub_obtenerPathLocal();
	
	connect (this.child("tbnGenerar"), "clicked()", this, "iface.generar_clicked()");
}

/** \D Función intermedia que llama a la pantalla de log estableciendo antes el código de la acción a realizar sobre la funcionalidad o el cliente.
\end */
function head_generar_clicked() 
{
	this.iface.lanzarLog("CB");
}

/** \D Lanza el formulario de log, estableciendo antes en una variable global el tipo de acción a realizar
\end */
function head_lanzarLog(accion:String)
{
	var idCliente:String = this.cursor().valueBuffer("idcliente");
	if (!idCliente)
		return;
	
	var miVar:FLVar = new FLVar();
	miVar.set("ACCIONMV", accion);
	
	flmaveppal.iface.pub_log = new FLFormSearchDB("mv_logclientes");
	var cursor:FLSqlCursor = flmaveppal.iface.pub_log.cursor();
	cursor.select("idcliente = '" + idCliente + "'");
	cursor.first();
	cursor.setModeAccess(cursor.Browse);
	flmaveppal.iface.pub_log.setMainWidget();
	cursor.refreshBuffer();
	flmaveppal.iface.pub_log.exec("idcliente");
	flmaveppal.iface.pub_log.close();
}


/** \D Obtiene la funcionalidad del repositorio, y crea los directorios previo y nuevo para poder editarla. Los directorios que se crearán son:
<ul>
	<li>nombre_cliente</li>
	<ul>
		<li>modulos: Directorio con todos los módulos afectados por la personalización del cliente</li>
		<li>temp: Directorio de apoyo para obtener los parches del repositorio</li>
	</ul>
</ul>
\end */
function head_generar(idCliente:String) 
{
	var resComando:Array;
	Dir.current = this.iface.pathLocal;
	if (File.exists(idCliente)) {
		var res:Number = MessageBox.warning(Dir.current + "/" + idCliente + "\n" + this.iface.util.translate("scripts", "El directorio local ya existe ¿desea sobreescribirlo?"), MessageBox.Yes, MessageBox.No);
		if (res != MessageBox.Yes)
			return;
			
		resComando = flmaveppal.iface.pub_ejecutarComando("rm -rf " + idCliente + "/modulos ");
		if (resComando.ok == false) {
			return;
		}
		resComando = flmaveppal.iface.pub_ejecutarComando("rm -rf " + idCliente + "/temp ");
		if (resComando.ok == false) {
			return;
		}
		resComando = flmaveppal.iface.pub_ejecutarComando("rm -rf " + idCliente + "/test ");
		if (resComando.ok == false) {
			return;
		}
		resComando = flmaveppal.iface.pub_ejecutarComando("mkdir " + idCliente + "/modulos");
		if (resComando.ok == false) {
			flmaveppal.iface.pub_log.child("log").append("Error mkdir árbol");
			return;
		}
	} else {
		resComando = flmaveppal.iface.pub_ejecutarComando("mkdir " + idCliente + " " + idCliente + "/modulos");
		if (resComando.ok == false) {
			flmaveppal.iface.pub_log.child("log").append("Error mkdir árbol");
			return;
		}
	}
	
	if (!File.exists(idCliente + "/doc")) {
		resComando = flmaveppal.iface.pub_ejecutarComando("mkdir " + idCliente + "/doc");
		if (resComando.ok == false) {
			flmaveppal.iface.pub_log.child("log").append("Error mkdir árbol");
			return;
		}
	}
	if (!File.exists(idCliente + "/config")) {
		resComando = flmaveppal.iface.pub_ejecutarComando("mkdir " + idCliente + "/config");
		if (resComando.ok == false) {
			flmaveppal.iface.pub_log.child("log").append("Error mkdir árbol");
			return;
		}
	}
	
	if (!this.iface.generarDirModulos(idCliente)) {
		flmaveppal.iface.pub_log.child("log").append("Error al generar el directorio 'modulos'");
		return;
	}
	
	flmaveppal.iface.pub_log.child("log").append(this.iface.util.translate("scripts", "La funcionalidad del cliente seleccionado ha sido obtenida correctamente"));
}

/** \D Crea el directorio modulos como el total de los módulos afectados más los parches de las funcionalidades asociadas al cliente

@param	idCliente: identificador del cliente
@return	True si no hay error, false en caso contrario
\end */
function head_generarDirModulos(idCliente:String):Boolean
{
	var listaDep:Array = flmaveppal.iface.pub_obtenerListaDepCliente(idCliente);
	if (!listaDep) {
		flmaveppal.iface.pub_log.child("log").append("Error al obtener la lista de dependencias de " + idCliente);
		return false;
	}
	
	for (var i:Number = 0; i < listaDep.length; i++) {
		if (!flmaveppal.iface.pub_checkoutMods(listaDep[i], idCliente, "modulos")) {
			flmaveppal.iface.pub_log.child("log").append("Error al obtener los módulos afectados por la funcionalidad " + listaDep[i]);
			return false;
		}
		var resComando:Array = flmaveppal.iface.pub_ejecutarComando("rm -rf " + flmaveppal.iface.pathLocal + "/" + idCliente + "/temp");
		if (resComando.ok == false) {
			flmaveppal.iface.pub_log.child("log").append("Error al borrar el directorio temporal");
			return false;
		}
		if (!flmaveppal.iface.pub_checkoutParche(listaDep[i], idCliente + "/temp")) {
			flmaveppal.iface.pub_log.child("log").append("Error al obtener el parche " + listaDep[i]);
			return false;
		}
		if (!flmaveppal.iface.pub_aplicarParche(listaDep[i], idCliente + "/temp", idCliente + "/modulos")) {
			flmaveppal.iface.pub_log.child("log").append("Error al aplicar el parche " + listaDep[i]);
			return false;
		}
		if (!flmaveppal.iface.pub_anadirTest(idCliente + "/temp", idCliente)) {
			flmaveppal.iface.pub_log.child("log").append("Error al añadir las pruebas de " + listaDep[i]);
			return false;
		}
		if (!this.iface.anadirAConfig(listaDep[i], idCliente)) {
			flmaveppal.iface.pub_log.child("log").append("Error al añadir las funcionalidad " + listaDep[i] + " al fichero de configuración del cliente");
			return false;
		}
	}
	
	return true;
}

/** \D Añade al directorio config el fichero de parche .xml asociado a una funcionalidad. Añade también un nodo al fichero xml de configuración del cliente. Estos datos son leídos por el módulo de documentación para realizar documentación de funcionalidades 
@param idFuncional: Identificador de la funcionalidad
@param	idCliente: Identificador del cliente
@return True si la adición se realiza correctamente, false en caso contrario
\end */
function head_anadirAConfig(idFuncional:String, idCliente:String):Boolean
{
	var contenido:String = File.read(this.iface.pathLocal + idCliente + "/temp/" + idFuncional + ".xml");
	File.write(this.iface.pathLocal + idCliente + "/config/" + idFuncional + ".xml", contenido);
	
	var xmlConfig:FLDomDocument = new FLDomDocument();
	var xmlAux:FLDomDocument = new FLDomDocument();
	
	if (File.exists(this.iface.pathLocal + idCliente + "/config/config.xml")) 
		contenido = File.read(this.iface.pathLocal + idCliente + "/config/config.xml");
	else
		contenido = "<flmaveconfig:client name =\"" + idCliente + "\"/>";

	if (!xmlConfig.setContent(contenido))
		return false;
	
	if (!xmlAux.setContent("<flmaveconfig:patch name =\"" + idFuncional + "\"/>"))
		return false;
		
	xmlConfig.firstChild().appendChild(xmlAux.firstChild());
	File.write(this.iface.pathLocal + idCliente + "/config/config.xml", xmlConfig.toString(4));

	return true; 
}

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////