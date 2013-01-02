/***************************************************************************
                                 flacls.qs
                            -------------------
   begin                : mie ene 18 2006
   copyright            : (C) 2004-2006 by InfoSiAL S.L.
   email                : mail@infosial.com
***************************************************************************/
/***************************************************************************
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; version 2 of the License.               *
 ***************************************************************************/
/***************************************************************************
   Este  programa es software libre. Puede redistribuirlo y/o modificarlo
   bajo  los  terminos  de  la  Licencia  Pï¿½blica General de GNU   en  su
   versiï¿½n 2, publicada  por  la  Free  Software Foundation.
 ***************************************************************************/

////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
class interna {
	var ctx:Object;
	function interna( context ) { this.ctx = context; }
	function init() { this.ctx.interna_init(); }
	function validateForm() { return this.ctx.interna_validateForm(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var tbnUp:Object;
	var tbnDown:Object;
	var tdbAcs:Object;
	var pbnRecargarListaGrupos:Object;
	var pbnGuardarListaGrupos:Object;
	var tblListasGrupos:QTable;
	var pbnRecargarListaUsuarios:Object;
	var pbnGuardarListaUsuarios:Object;
	var tblListasUsuarios:QTable;
	var tbwReglas:Object;

	function oficial( context ) { interna( context ); }
	function tbnUp_clicked() {
		this.ctx.oficial_tbnUp_clicked();
	}
	function tbnDown_clicked() {
		this.ctx.oficial_tbnDown_clicked();
	}
	function recargarListaGrupos() {
		this.ctx.oficial_recargarListaGrupos();
	}
	function guardarListaGrupos() {
		this.ctx.oficial_guardarListaGrupos();
	}
	function recargarListaUsuarios() {
		this.ctx.oficial_recargarListaUsuarios();
	}
	function guardarListaUsuarios() {
		this.ctx.oficial_guardarListaUsuarios();
	}
	function moveStep( direction:Number ) {
		this.ctx.oficial_moveStep( direction );
	}
	function clickedListaGrupos(fil:Number, col:Number) {
		return this.ctx.oficial_clickedListaGrupos(fil, col); 
	}
	function clickedListaUsuarios(fil:Number, col:Number) {
		return this.ctx.oficial_clickedListaUsuarios(fil, col); 
	}
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends oficial {
	function head( context ) { oficial ( context ); }
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends head {
	function ifaceCtx( context ) { head( context ); }
}

const iface = new ifaceCtx( this );
//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
/** \C 
\end */
function interna_init()
{
	this.iface.tdbAcs = this.child( "tdbAcs" );
	this.iface.tbnUp = this.child( "tbnUp" );
	this.iface.tbnDown = this.child( "tbnDown" );
	this.iface.pbnRecargarListaGrupos = this.child( "pbnRecargarListaGrupos" );
	this.iface.pbnGuardarListaGrupos = this.child("pbnGuardarListaGrupos");
	this.iface.tblListasGrupos = this.child("tblListasGrupos");
	this.iface.pbnRecargarListaUsuarios = this.child( "pbnRecargarListaUsuarios" );
	this.iface.pbnGuardarListaUsuarios = this.child("pbnGuardarListaUsuarios");
	this.iface.tblListasUsuarios = this.child("tblListasUsuarios");
	this.iface.tbwReglas = this.child("tbwReglas");

	this.iface.pbnGuardarListaGrupos.setDisabled(true);
	this.iface.pbnGuardarListaUsuarios.setDisabled(true);

	connect ( this.iface.tbnUp, "clicked()", this, "iface.tbnUp_clicked" );
	connect ( this.iface.tbnDown, "clicked()", this, "iface.tbnDown_clicked" );
	
	connect ( this.iface.pbnRecargarListaGrupos, "clicked()", this, "iface.recargarListaGrupos" );
	connect ( this.iface.pbnGuardarListaGrupos, "clicked()", this, "iface.guardarListaGrupos" );
 	connect ( this.iface.tblListasGrupos, "clicked(int,int)", this, "iface.clickedListaGrupos");
	connect ( this.iface.pbnRecargarListaUsuarios, "clicked()", this, "iface.recargarListaUsuarios" );
	connect ( this.iface.pbnGuardarListaUsuarios, "clicked()", this, "iface.guardarListaUsuarios" );
 	connect ( this.iface.tblListasUsuarios, "clicked(int,int)", this, "iface.clickedListaUsuarios");
 	
	for (numC = 0; numC < this.iface.tblListasGrupos.numCols(); numC++)
		this.iface.tblListasGrupos.setColumnReadOnly(numC, true);
	this.iface.tblListasGrupos.hideColumn(4);
	this.iface.tblListasGrupos.setColumnReadOnly(6, false);
	
	for (numC = 0; numC < this.iface.tblListasUsuarios.numCols(); numC++)
		this.iface.tblListasUsuarios.setColumnReadOnly(numC, true);
	this.iface.tblListasUsuarios.hideColumn(4);
	this.iface.tblListasUsuarios.setColumnReadOnly(6, false);

	
	if (this.cursor().modeAccess() ==  this.cursor().Edit) {
		this.iface.recargarListaGrupos();
		this.iface.recargarListaUsuarios();
	}
}

function interna_validateForm()
{
	var cambioGrupos:Boolean = false;
	var cambioUsuarios:Boolean = false;

	for (numL = 0; numL < this.iface.tblListasGrupos.numRows(); numL++)
		if (this.iface.tblListasGrupos.text(numL, 9))
			cambioGrupos = true;

	for (numL = 0; numL < this.iface.tblListasUsuarios.numRows(); numL++)
		if (this.iface.tblListasUsuarios.text(numL, 9))
			cambioUsuarios = true;

	if (cambioUsuarios || cambioGrupos) {
		var util:FLUtil = new FLUtil();
		MessageBox.warning(util.translate("scripts", "Se han modificado algunos datos de grupos y/o usuarios.\nAntes de aceptar el formulario se deberán guardar los cambios"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	
	return true;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_tbnUp_clicked()
{
	this.iface.moveStep( -1 );
}

function oficial_tbnDown_clicked()
{
	this.iface.moveStep( 1 );
}

function oficial_moveStep( direction:Number )
{
	var cursor:FLSqlCursor = this.iface.tdbAcs.cursor();
	if (!cursor.isValid())
		return;

	var idacl:String = cursor.valueBuffer("idacl");
	if (!idacl)
		return;

	var prioridad:Number = cursor.valueBuffer("prioridad");
	var prioridad2:Number;
	var row:Number = this.iface.tdbAcs.currentRow();
	var util:FLUtil = new FLUtil();

	if (direction == -1)
		prioridad2 = util.sqlSelect("flacs", "prioridad",
		"idacl = '" + idacl + "' AND prioridad < " + prioridad +
		" ORDER BY prioridad DESC");
	else
		prioridad2 = util.sqlSelect("flacs", "prioridad",
		"idacl = '" + idacl + "' AND prioridad > " + prioridad +
		" ORDER BY prioridad");

	if (!prioridad2)
		return;

	var curAcs:FLSqlCursor = new FLSqlCursor("flacs");
	curAcs.select("idacl = '" + idacl + "' AND prioridad = '" + prioridad2 + "'");
	if (!curAcs.first())
		return;

	curAcs.setModeAccess(curAcs.Edit);
	curAcs.refreshBuffer();
	curAcs.setValueBuffer("prioridad", "-1");
	curAcs.commitBuffer();

	cursor.setModeAccess(cursor.Edit);
	cursor.refreshBuffer();
	cursor.setValueBuffer("prioridad", prioridad2);
	cursor.commitBuffer();

	curAcs.select("idacl = '" + idacl + "' AND prioridad = -1");
	curAcs.first();
	curAcs.setModeAccess(curAcs.Edit);
	curAcs.refreshBuffer();
	curAcs.setValueBuffer("prioridad", prioridad);
	curAcs.commitBuffer();

	this.iface.tdbAcs.refresh();
	row += direction;
	this.iface.tdbAcs.setCurrentRow(row);
}

function oficial_recargarListaGrupos()
{
	var util:FLUtil = new FLUtil();
	
	if (this.iface.tblListasGrupos.numRows()) {
		res = MessageBox.information(util.translate("scripts", "A continuación se recargará la lista de reglas\nPerderá los cambios no guardados\n\n¿Continuar?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
		if (res != MessageBox.Yes)
			return;
	}
	
	var where:String = "1 = 1";
	var idAcl:String = this.cursor().valueBuffer("idacl");
	var prioridadDefecto:String = this.cursor().valueBuffer("prioridadgrupointro");
	var idGroupIntro:String = this.cursor().valueBuffer("idgroupintro");
	if (idGroupIntro)
		where = "idgroup = '" + idGroupIntro + "'";
	
	var fila:Number = 0;
	var permiso:String = "";
	this.iface.tblListasGrupos.clear();
	
	var qG:FLSqlQuery = new FLSqlQuery();
	qG.setTablesList("flgroups");
	qG.setFrom("flgroups");
	qG.setSelect("idgroup")
	qG.setWhere(where + " order by idgroup")
	
	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList("flareas,flmodules");
	q.setFrom("flareas a inner join flmodules m on a.idarea = m.idarea");
	q.setSelect("m.idarea,m.idmodulo,a.descripcion,m.descripcion")
	q.setWhere("1=1 order by a.descripcion,m.descripcion")
	
	qG.exec();
	while(qG.next()) {
	
		idGroupIntro = qG.value(0);
		q.exec();
		while(q.next()) {
		
			this.iface.tblListasGrupos.insertRows(fila, 1);		
	
			this.iface.tblListasGrupos.setText(fila, 0, idGroupIntro);
			this.iface.tblListasGrupos.setText(fila, 1, q.value(2));
			this.iface.tblListasGrupos.setText(fila, 2, q.value(3));
			this.iface.tblListasGrupos.setText(fila, 7, q.value(0));
			this.iface.tblListasGrupos.setText(fila, 8, q.value(1));
			
			permiso = util.sqlSelect("flacs", "permiso", "idacl = '" + idAcl + "' AND idgroup = '" + idGroupIntro + "' AND degrupo = true and idmodule = '" + q.value(1) + "'");
			switch(permiso) {
				case "--":
					this.iface.tblListasGrupos.setText(fila, 3, "XXX");
				break;
				case "r-":
					this.iface.tblListasGrupos.setText(fila, 4, "XXX");
				break;
				default:
					this.iface.tblListasGrupos.setText(fila, 5, "XXX");
			}
			
			prioridad = parseFloat(util.sqlSelect("flacs", "prioridad", "idacl = '" + idAcl + "' AND idgroup = '" + idGroupIntro + "' AND degrupo = true and idmodule = '" + q.value(1) + "'"));
			if (!prioridad)
				prioridad = prioridadDefecto;
			if (!prioridad)
				prioridad = 1;
			
			this.iface.tblListasGrupos.setText(fila, 6, prioridad);
			
			fila++;
		}
	
		this.iface.tblListasGrupos.insertRows(fila, 1);		
		fila++;
	}

	this.iface.pbnGuardarListaGrupos.setDisabled(false);
}

function oficial_guardarListaGrupos()
{
	var util:FLUtil = new FLUtil();
	
	res = MessageBox.information(util.translate("scripts", "A continuación se crearán actualizarán todas las reglas de la lista\n\n¿Continuar?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
	if (res != MessageBox.Yes)
		return;
	
	if (this.cursor().modeAccess() == this.cursor().Insert) {
		var curAcs:FLSqlCursor = this.iface.tdbAcs.cursor();
		curAcs.setModeAccess(curAcs.Insert);
		curAcs.commitBufferCursorRelation();
	}
	
	var idGroupIntro:String;
	var curAcs:FLSqlCursor = new FLSqlCursor("flacs");
	var prioridad:Number = 1;
	var permiso:String;
	var idAcl:String = this.cursor().valueBuffer("idacl");
	
	util.createProgressDialog( util.translate( "scripts", "Actualizando reglas..." ), this.iface.tblListasGrupos.numRows() );
	
	for (numL = 0; numL < this.iface.tblListasGrupos.numRows(); numL++) {
	
		util.setProgress(numL);
	
		// Saltar los separadores
		if (!this.iface.tblListasGrupos.text(numL, 0))
			continue;
	
		idGroupIntro = this.iface.tblListasGrupos.text(numL, 0);
	
		curAcs.select("idacl = '" + idAcl + "' AND idgroup = '" + idGroupIntro + "' AND idmodule = '" + this.iface.tblListasGrupos.text(numL, 8) + "'");
		if (curAcs.first()) {
			curAcs.setModeAccess(curAcs.Edit);
			// Saltar los no modificados
			if (!this.iface.tblListasGrupos.text(numL, 8))
				continue;
		}
		else
			curAcs.setModeAccess(curAcs.Insert);
		
		curAcs.refreshBuffer();
		curAcs.setValueBuffer("idgroup", this.iface.tblListasGrupos.text(numL, 0));
		curAcs.setValueBuffer("tipo", "mainwindow");
		curAcs.setValueBuffer("nombre", this.iface.tblListasGrupos.text(numL, 8));
		
		//Area de Facturación:Tesorería:mainwindow:Maestro:flfactteso
		curAcs.setValueBuffer("descripcion", this.iface.tblListasGrupos.text(numL, 1) + ":" + this.iface.tblListasGrupos.text(numL, 2) + "mainwindow:Maestro:" + this.iface.tblListasGrupos.text(numL, 7));
		
		permiso = "--";
		if (this.iface.tblListasGrupos.text(numL, 4))
 			permiso = "r-";		
		if (this.iface.tblListasGrupos.text(numL, 5))
 			permiso = "rw";		
		curAcs.setValueBuffer("permiso", permiso);
		
		curAcs.setValueBuffer("idacl", idAcl);
		curAcs.setValueBuffer("degrupo", true);
		curAcs.setValueBuffer("idarea", this.iface.tblListasGrupos.text(numL, 7));
		curAcs.setValueBuffer("idmodule", this.iface.tblListasGrupos.text(numL, 8));
		curAcs.setValueBuffer("tipoform", "Maestro");
		
		prioridad = parseFloat(this.iface.tblListasGrupos.text(numL, 6));
		if (!prioridad)
			prioridad = 1;
		curAcs.setValueBuffer("prioridad", prioridad);
		
		curAcs.commitBuffer();
	}
	
	util.destroyProgressDialog();
	MessageBox.information(util.translate("scripts", "Se guardaron los cambios. Recuerde que para que las modificaciones sean efectivas, debe aceptar el formulario.\nSi cancela el formulario las modificaciones no serán efectivas"), MessageBox.Ok, MessageBox.NoButton);
	
	for (numL = 0; numL < this.iface.tblListasGrupos.numRows(); numL++)
		this.iface.tblListasGrupos.setText(numL, 9, "");
}

function oficial_clickedListaGrupos(fil:Number, col:Number)
{
	if (col < 3 || col > 5)
		return;
	
	if (!this.iface.tblListasGrupos.text(fil, 0))
		return;
	
	if (this.iface.tblListasGrupos.text(fil, col))
		return;
	
	this.iface.tblListasGrupos.setText(fil, col, "XXX");
	
	switch (col) {
		case 3:
			this.iface.tblListasGrupos.setText(fil, 4, "");
			this.iface.tblListasGrupos.setText(fil, 5, "");
		break;
		case 4:
			this.iface.tblListasGrupos.setText(fil, 3, "");
			this.iface.tblListasGrupos.setText(fil, 5, "");
		break;
		case 5:
			this.iface.tblListasGrupos.setText(fil, 3, "");
			this.iface.tblListasGrupos.setText(fil, 4, "");
		break;
	}
	
	this.iface.tblListasGrupos.setText(fil, 9, "XXX");
}





function oficial_recargarListaUsuarios()
{
	var util:FLUtil = new FLUtil();
	
	if (this.iface.tblListasUsuarios.numRows()) {
		res = MessageBox.information(util.translate("scripts", "A continuación se recargará la lista de reglas\nPerderá los cambios no guardados\n\n¿Continuar?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
		if (res != MessageBox.Yes)
			return;
	}
	
	var where:String = "1 = 1";
	var idAcl:String = this.cursor().valueBuffer("idacl");
	var prioridadDefecto:String = this.cursor().valueBuffer("prioridadusuariointro");
	
	var idUserIntro:String = this.cursor().valueBuffer("iduserintro");
	if (idUserIntro)
		where += " AND iduser = '" + idUserIntro + "'";
	
	var idGroupIntro:String = this.cursor().valueBuffer("idgroupintro");
	if (idGroupIntro)
		where += " AND idgroup = '" + idGroupIntro + "'";
	
	
	var fila:Number = 0;
	var permiso:String = "";
	this.iface.tblListasUsuarios.clear();
	
	var qG:FLSqlQuery = new FLSqlQuery();
	qG.setTablesList("flusers");
	qG.setFrom("flusers");
	qG.setSelect("iduser")
	qG.setWhere(where + " order by iduser")
	
	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList("flareas,flmodules");
	q.setFrom("flareas a inner join flmodules m on a.idarea = m.idarea");
	q.setSelect("m.idarea,m.idmodulo,a.descripcion,m.descripcion")
	q.setWhere("1=1 order by a.descripcion,m.descripcion")
	
	qG.exec();
	while(qG.next()) {
	
		idUserIntro = qG.value(0);
		q.exec();
		while(q.next()) {
		
			this.iface.tblListasUsuarios.insertRows(fila, 1);		
	
			this.iface.tblListasUsuarios.setText(fila, 0, idUserIntro);
			this.iface.tblListasUsuarios.setText(fila, 1, q.value(2));
			this.iface.tblListasUsuarios.setText(fila, 2, q.value(3));
			this.iface.tblListasUsuarios.setText(fila, 7, q.value(0));
			this.iface.tblListasUsuarios.setText(fila, 8, q.value(1));
			
			permiso = util.sqlSelect("flacs", "permiso", "idacl = '" + idAcl + "' AND iduser = '" + idUserIntro + "' AND degrupo = false and idmodule = '" + q.value(1) + "'");
			switch(permiso) {
				case "--":
					this.iface.tblListasUsuarios.setText(fila, 3, "XXX");
				break;
				case "r-":
					this.iface.tblListasUsuarios.setText(fila, 4, "XXX");
				break;
				default:
					this.iface.tblListasUsuarios.setText(fila, 5, "XXX");
			}
			
			prioridad = parseFloat(util.sqlSelect("flacs", "prioridad", "idacl = '" + idAcl + "' AND iduser = '" + idUserIntro + "' AND degrupo = false and idmodule = '" + q.value(1) + "'"));
			if (!prioridad)
				prioridad = prioridadDefecto;
			if (!prioridad)
				prioridad = 1;
			
			this.iface.tblListasUsuarios.setText(fila, 6, prioridad);
			
			fila++;
		}
	
		this.iface.tblListasUsuarios.insertRows(fila, 1);		
		fila++;
	}

	this.iface.pbnGuardarListaUsuarios.setDisabled(false);
}

function oficial_guardarListaUsuarios()
{
	var util:FLUtil = new FLUtil();
	
	res = MessageBox.information(util.translate("scripts", "A continuación se crearán actualizarán todas las reglas de la lista\n\n¿Continuar?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
	if (res != MessageBox.Yes)
		return;
	
	if (this.cursor().modeAccess() == this.cursor().Insert) {
		var curAcs:FLSqlCursor = this.iface.tdbAcs.cursor();
		curAcs.setModeAccess(curAcs.Insert);
		curAcs.commitBufferCursorRelation();
	}
	
	var idUserIntro:String;
	var curAcs:FLSqlCursor = new FLSqlCursor("flacs");
	var prioridad:Number = 1;
	var permiso:String;
	var idAcl:String = this.cursor().valueBuffer("idacl");
	
	util.createProgressDialog( util.translate( "scripts", "Actualizando reglas..." ), this.iface.tblListasUsuarios.numRows() );
	
	for (numL = 0; numL < this.iface.tblListasUsuarios.numRows(); numL++) {
	
		util.setProgress(numL);
	
		// Saltar los separadores
		if (!this.iface.tblListasUsuarios.text(numL, 0))
			continue;
	
		idUserIntro = this.iface.tblListasUsuarios.text(numL, 0);
	
		curAcs.select("idacl = '" + idAcl + "' AND iduser = '" + idUserIntro + "' AND idmodule = '" + this.iface.tblListasUsuarios.text(numL, 8) + "'");
		if (curAcs.first()) {
			curAcs.setModeAccess(curAcs.Edit);
			// Saltar los no modificados
			if (!this.iface.tblListasUsuarios.text(numL, 8))
				continue;
		}
		else
			curAcs.setModeAccess(curAcs.Insert);
		
		curAcs.refreshBuffer();
		curAcs.setValueBuffer("iduser", this.iface.tblListasUsuarios.text(numL, 0));
		curAcs.setValueBuffer("tipo", "mainwindow");
		curAcs.setValueBuffer("nombre", this.iface.tblListasUsuarios.text(numL, 8));
		
		//Area de Facturación:Tesorería:mainwindow:Maestro:flfactteso
		curAcs.setValueBuffer("descripcion", this.iface.tblListasUsuarios.text(numL, 1) + ":" + this.iface.tblListasUsuarios.text(numL, 2) + "mainwindow:Maestro:" + this.iface.tblListasUsuarios.text(numL, 7));
		
		permiso = "--";
		if (this.iface.tblListasUsuarios.text(numL, 4))
 			permiso = "r-";		
		if (this.iface.tblListasUsuarios.text(numL, 5))
 			permiso = "rw";		
		curAcs.setValueBuffer("permiso", permiso);
		
		curAcs.setValueBuffer("idacl", idAcl);
		curAcs.setValueBuffer("deusuario", true);
		curAcs.setValueBuffer("idarea", this.iface.tblListasUsuarios.text(numL, 7));
		curAcs.setValueBuffer("idmodule", this.iface.tblListasUsuarios.text(numL, 8));
		curAcs.setValueBuffer("tipoform", "Maestro");
		
		prioridad = parseFloat(this.iface.tblListasUsuarios.text(numL, 6));
		if (!prioridad)
			prioridad = 1;
		curAcs.setValueBuffer("prioridad", prioridad);
		
		curAcs.commitBuffer();
	}
	
	util.destroyProgressDialog();
	MessageBox.information(util.translate("scripts", "Se guardaron los cambios. Recuerde que para que las modificaciones sean efectivas, debe aceptar el formulario.\nSi cancela el formulario las modificaciones no serán efectivas"), MessageBox.Ok, MessageBox.NoButton);
	
	for (numL = 0; numL < this.iface.tblListasUsuarios.numRows(); numL++)
		this.iface.tblListasUsuarios.setText(numL, 9, "");
}

function oficial_clickedListaUsuarios(fil:Number, col:Number)
{
	if (col < 3 || col > 5)
		return;
	
	if (!this.iface.tblListasUsuarios.text(fil, 0))
		return;
	
	if (this.iface.tblListasUsuarios.text(fil, col))
		return;
	
	this.iface.tblListasUsuarios.setText(fil, col, "XXX");
	
	switch (col) {
		case 3:
			this.iface.tblListasUsuarios.setText(fil, 4, "");
			this.iface.tblListasUsuarios.setText(fil, 5, "");
		break;
		case 4:
			this.iface.tblListasUsuarios.setText(fil, 3, "");
			this.iface.tblListasUsuarios.setText(fil, 5, "");
		break;
		case 5:
			this.iface.tblListasUsuarios.setText(fil, 3, "");
			this.iface.tblListasUsuarios.setText(fil, 4, "");
		break;
	}
	
	this.iface.tblListasUsuarios.setText(fil, 9, "XXX");
}




//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
