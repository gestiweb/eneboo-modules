/***************************************************************************
                 mv_pesoparche.qs  -  description
                             -------------------
    begin                : jue feb 02 2006
    copyright            : (C) 2006 by InfoSiAL S.L.
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    var pathLocal:String;
	var pathPeso:String;
	function oficial( context ) { interna( context ); }
	function cambiarDirParche() {
		return this.ctx.oficial_cambiarDirParche();
	}
	function cambiarDirOficial() {
		return this.ctx.oficial_cambiarDirOficial();
	}
	function calcularPeso() {
		return this.ctx.oficial_calcularPeso();
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

////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

/** @class_definition interna */
//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////

function interna_init() 
{
	this.iface.pathLocal = flmaveppal.iface.pub_obtenerPathLocal();
	this.iface.pathPeso = flmaveppal.iface.pub_obtenerPathPeso();
	this.child("lblValorDirParche").text = this.iface.pathLocal;
	this.child("lblValorDirOficial").text = this.iface.pathPeso;
	
	connect(this.child("pbnCambiarDirParche"), "clicked()", this, "iface.cambiarDirParche()");
	connect(this.child("pbnCambiarDirOficial"), "clicked()", this, "iface.cambiarDirOficial()");
	connect(this.child("pbnCalcularPeso"), "clicked()", this, "iface.calcularPeso()");
	
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_cambiarDirParche()
{
	var dirParche:String = FileDialog.getExistingDirectory(this.iface.pathLocal);
	if (!dirParche)
		return false;
	this.child("lblValorDirParche").text = dirParche;
}

function oficial_cambiarDirOficial()
{
	var dirOficial:String = FileDialog.getExistingDirectory(this.iface.pathPeso);
	if (!dirOficial)
		return false;
	this.child("lblValorDirOficial").text = dirOficial;
}

function oficial_calcularPeso()
{
	this.child("lblPeso").text = "Calculando...";

	var shell:String = "rm -rf $HOME/tmp/pesoparche \n" + 
		"mkdir $HOME/tmp/pesoparche \n" + 
		"mkdir $HOME/tmp/pesoparche/oficial \n" + 
		"mkdir $HOME/tmp/pesoparche/extension \n" + 
		"mkdir $HOME/tmp/pesoparche/dif \n" + 
		"cp $(find $2 -name *.qs) $HOME/tmp/pesoparche/extension/ \n" + 
		"for i in $(ls $HOME/tmp/pesoparche/extension/) \n" + 
		"do \n" + 
		"filename=${i#$HOME/tmp/pesoparche/extension/} \n" + 
		"a=$(find $1 -name $i) \n" + 
		"if [ $a ]; then \n" + 
		"diff $HOME/tmp/pesoparche/extension/$i $a >> $HOME/tmp/pesoparche/dif/$filename \n" + 
		"fi \n" + 
		"if [ ! $a ]; then \n" + 
		"cp $HOME/tmp/pesoparche/extension/$i $HOME/tmp/pesoparche/dif/$filename \n" + 
		"fi \n" + 
		"done \n" + 
		"exit 0";
	File.write(this.iface.pathLocal + "pesoparche.sh", shell);
	comando = "chmod 777 " + this.iface.pathLocal + "pesoparche.sh";
	resComando = flmaveppal.iface.pub_ejecutarComando(comando);
	if (resComando.ok == false) 
		return;

	comando = this.iface.pathLocal + "pesoparche.sh " + this.child("lblValorDirOficial").text + " " +  this.child("lblValorDirParche").text;
	resComando = flmaveppal.iface.pub_ejecutarComando(comando);
	if (resComando.ok == false) 
		return;
	var dir = new Dir(Dir.home + "/tmp/pesoparche/dif");
	var codeFiles:Array = dir.entryList("*.qs");
	var peso:Number = 0;
	for (var i:Number = 0; i < codeFiles.length; ++i) {
		var f = new File(Dir.home + "/tmp/pesoparche/dif/" + codeFiles[i]);
		peso += f.size;
	}
	peso = peso / 1000;
    this.child("lblPeso").text = peso + " Kb";

}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////