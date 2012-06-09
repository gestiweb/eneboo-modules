/***************************************************************************
                 flmastertareas.qs  -  description
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
/** \C
El formulario muestra la lista de las tareas existentes. 
El funcionamiento a través del lector de código de barras es el siguiente:

El trabajador lee su código personal: La ventana mostrará la lista de tareas pendientes

El trabajador lee el código de la tarea a realizar: La ventana mostrará la tarea correspondiente, realizando las acciones correspondientes a según el tipo y estado de la tarea (p.e. si la tarea es de corte y está en estado PTE, mostrará el formulario de tarea de corte para que el usuario valide los datos del corte y la tarea pueda pasar a EN CURSO)
\end */
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
	var chkPte:Object;
	var chkEnCurso:Object;
	var chkTerminada:Object;
	var chkMias:Object;
	var chkDeMiGrupo:Object;
	var chkSinAsignar:Object;
	var chkTodas:Object;

	var tdbTareas:Object;
	var tbnDeshacer:Object;
	var tbnIniciarTarea:Object;
	
    function oficial( context ) { interna( context ); } 
	function tbnIniciarTareaClicked() {
		return this.ctx.oficial_tbnIniciarTareaClicked()
	}
	function procesarEstado() {
		return this.ctx.oficial_procesarEstado();
	}
	function tbnDeshacerClicked() {
		return this.ctx.oficial_tbnDeshacerClicked();
	}
	function regenerarFiltro() {
		this.ctx.oficial_regenerarFiltro();
	}
	function filtroEstado():String {
		return this.ctx.oficial_filtroEstado();
	}
	function filtroPropietario():String {
		return this.ctx.oficial_filtroPropietario();
	}
	function valoresDefectoFiltro() {
		return this.ctx.oficial_valoresDefectoFiltro();
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
/*
	var cursor:FLSqlCursor = this.cursor();

	this.iface.tdbTareas = this.child("tdbTareas");
	this.iface.tbnDeshacer = this.child("tbnDeshacer");
	this.iface.tbnIniciarTarea = this.child("tbnIniciarTarea");

	this.iface.chkPte = this.child("chkPte");
	this.iface.chkEnCurso = this.child("chkEnCurso");
	this.iface.chkTerminada = this.child("chkTerminada");
	this.iface.chkMias = this.child("chkMias");
	this.iface.chkDeMiGrupo = this.child("chkDeMiGrupo");
	this.iface.chkSinAsignar = this.child("chkSinAsignar");
	this.iface.chkTodas = this.child("chkTodas");
	
	this.iface.tdbTareas.setReadOnly(true);

	connect(this.iface.tbnIniciarTarea, "clicked()", this, "iface.tbnIniciarTareaClicked");
	connect(this.iface.tbnDeshacer, "clicked()", this, "iface.tbnDeshacerClicked");
	connect(this.iface.chkPte, "clicked()", this, "iface.regenerarFiltro");
	connect(this.iface.chkEnCurso, "clicked()", this, "iface.regenerarFiltro");
	connect(this.iface.chkTerminada, "clicked()", this, "iface.regenerarFiltro");
	connect(this.iface.chkMias, "clicked()", this, "iface.regenerarFiltro");
	connect(this.iface.chkDeMiGrupo, "clicked()", this, "iface.regenerarFiltro");
	connect(this.iface.chkSinAsignar, "clicked()", this, "iface.regenerarFiltro");
	connect(this.iface.chkTodas, "clicked()", this, "iface.regenerarFiltro");
	connect(this.iface.tdbTareas, "currentChanged()", this, "iface.procesarEstado");

	this.iface.valoresDefectoFiltro();
	this.iface.regenerarFiltro();
*/
	// Seguimiento
	
	var datosS:Array;
	datosS["tipoObjeto"] = "todos";
	datosS["idObjeto"] = "0";
	flcolaproc.iface.pub_seguimientoOn(this, datosS);
	
	this.child("tbnLanzarTareaS").close();
	this.child("tbnDeleteTareaS").close();
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D
Si la tarea está en estado PTE, llama a iniciarTarea. Si está en estado EN CURSO, llama a terminarTarea
\end */
function oficial_tbnIniciarTareaClicked()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	cursor.refreshBuffer();

	if (cursor.valueBuffer("estado") == "EN CURSO") {
		cursor.transaction(false);
		try {
			if (flcolaproc.iface.pub_terminarTarea(cursor))
				cursor.commit();
			else
				cursor.rollback();
		} catch(e) {
			cursor.rollback();
			MessageBox.critical(util.translate("scripts", "Hubo un error en la finalización de la tarea:\n") + e, MessageBox.Ok, MessageBox.NoButton);
		}
	}
	if (cursor.valueBuffer("estado") == "PTE") {
		var nameUser:String = sys.nameUser();
		cursor.transaction(false);
		try {
			if (flcolaproc.iface.pub_iniciarTarea(cursor, nameUser))
				cursor.commit();
			else
				cursor.rollback();
		} catch(e) {
			cursor.rollback();
			MessageBox.critical(util.translate("scripts", "Hubo un error en el inicio de la tarea:\n") + e, MessageBox.Ok, MessageBox.NoButton);
		}
	}
	this.iface.tdbTareas.refresh();
}

/** \D
Pulsación del botón deshacer
\end */
function oficial_tbnDeshacerClicked()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	this.iface.tbnDeshacer.enabled = false;
	var estado:String = cursor.valueBuffer("estado");
	if (estado != "TERMINADA" && estado != "EN CURSO") {
		MessageBox.warning(util.translate("scripts", "La tarea debe estar en estado TERMINADA o EN CURSO"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return;
	}
	try {
		cursor.transaction(false);
		if (estado == "TERMINADA") {
			if (!flcolaproc.iface.pub_deshacerTareaTerminada(cursor)) {
				cursor.rollback();
			}
		} else if (estado == "EN CURSO") {
			if (!flcolaproc.iface.pub_deshacerTareaEnCurso(cursor)) {
				cursor.rollback();
			}
		}
		cursor.commit();
	} catch(e) {
		cursor.rollback();
		MessageBox.critical(util.translate("scripts", "Hubo un error al deshacer la tarea:\n") + e, MessageBox.Ok, MessageBox.NoButton);
	}
	this.iface.tdbTareas.refresh();
}

/** \D
Habilita el botón 'Deshacer tarea' si el estado de la tarea seleccionada es TERMINADA o EN CURSO
\end */
function oficial_procesarEstado()
{
	var estado:String = this.cursor().valueBuffer("estado");
	if (estado == "TERMINADA" || estado == "EN CURSO") {
		this.iface.tbnDeshacer.enabled = true;
	} else {
		this.iface.tbnDeshacer.enabled = false;
	}
}

/** \D Regenera el filtro en función de los criterios de búsqueda de tareas especificados por el usuario
\end */
function oficial_regenerarFiltro()
{
	var filtro:String = "";
	var filtroEs:String = this.iface.filtroEstado();
	if (filtroEs)
		filtro = filtroEs;
	var filtroPro:String = this.iface.filtroPropietario();
	if (filtroPro) {
		if (filtro != "") {
			filtro += " AND ";
		}
		filtro += filtroPro;
	}
	this.iface.tdbTareas.cursor().setMainFilter(filtro);
	this.iface.tdbTareas.refresh();
	this.iface.procesarEstado();
}

/** \D Construye la parte del filtro de tareas referente al estado
@return	Filtro
\end */
function oficial_filtroEstado():String
{
	var filtro:String = "";
	var listaEstados = "";
	if (this.iface.chkPte.checked)
		listaEstados += "'PTE'";

	if (this.iface.chkEnCurso.checked) {
		if (listaEstados != "")
			listaEstados += ", ";
		listaEstados += "'EN CURSO'";
	}

	if (this.iface.chkTerminada.checked) {
		if (listaEstados != "")
			listaEstados += ", ";
		listaEstados += "'TERMINADA'";
	}
	if (listaEstados != "") {
		filtro = "estado IN (" + listaEstados + ")";
	} else {
		filtro = "1 = 2";
	}
	return filtro;
}


/** \D Construye la parte del filtro de tareas referente al propietario de las mismas
@return	Filtro
\end */
function oficial_filtroPropietario():String
{
	var util:FLUtil = new FLUtil;
	var preFiltro:String = "(";
	var filtro:String = "";
	var idUsuario:String = sys.nameUser();
	var idGrupo:String = util.sqlSelect("flusers", "idgroup", "iduser = '" + idUsuario + "'");

	if (this.iface.chkMias.checked)
		preFiltro += "iduser = '" + idUsuario + "'";

	if (this.iface.chkDeMiGrupo.checked && idGrupo) {
		if (preFiltro != "(")
			preFiltro += " OR ";
		preFiltro += "idgroup = '" + idGrupo + "'";
	}

	if (this.iface.chkSinAsignar.checked) {
		if (preFiltro != "(")
			preFiltro += " OR ";
		preFiltro += "iduser IS NULL";
	}

	if (this.iface.chkTodas.checked) {
		preFiltro = ""
	}

	if (preFiltro == "")
		filtro = "";
	else if (preFiltro == "(")
		filtro = "1 = 2";
	else
		filtro = preFiltro + ")";

	return filtro;
}

function oficial_valoresDefectoFiltro()
{
	this.iface.chkMias.checked = true;
	this.iface.chkPte.checked = true;
	this.iface.chkEnCurso.checked = true;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
