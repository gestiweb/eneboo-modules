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

//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    function oficial( context ) { interna( context ); } 
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends oficial {
		var tbnVerCambios:Object;
		var tbnVerHijos:Object;
		var tbnPropagar:Object;
		var tbnCrearHijo:Object;
		var tbnCambiarPadre:Object;
		var util:FLUtil;
		
    function head( context ) { oficial ( context ); }
		function init() {
				return this.ctx.head_init();
		}
		function tbnCrearHijo_clicked() {
				return this.ctx.head_tbnCrearHijo_clicked();
		}
		function tbnVerCambios_clicked() {
				return this.ctx.head_tbnVerCambios_clicked();
		}
		function tbnPropagar_clicked() {
				return this.ctx.head_tbnPropagar_clicked();
		}
		function tbnVerHijos_clicked() {
				return this.ctx.head_tbnVerHijos_clicked();
		}
		function tbnCambiarPadre_clicked() {
				return this.ctx.head_tbnCambiarPadre_clicked();
		}
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

function init() {
    this.iface.init();
}

function interna_init() {

}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
function head_init() 
{
		this.iface.util = new FLUtil;
		
		this.iface.tbnCrearHijo = this.child("tbnCrearHijo");
		this.iface.tbnVerCambios = this.child("tbnVerCambios");
		this.iface.tbnVerHijos = this.child("tbnVerHijos");
		this.iface.tbnPropagar = this.child("tbnPropagar");
		this.iface.tbnCambiarPadre = this.child("tbnCambiarPadre");
		
		connect(this.iface.tbnCrearHijo, "clicked()", this, "iface.tbnCrearHijo_clicked()");
		connect(this.iface.tbnVerCambios, "clicked()", this, "iface.tbnVerCambios_clicked()");
		connect(this.iface.tbnVerHijos, "clicked()", this, "iface.tbnVerHijos_clicked()");
		connect(this.iface.tbnPropagar, "clicked()", this, "iface.tbnPropagar_clicked()");
		connect(this.iface.tbnCambiarPadre, "clicked()", this, "iface.tbnCambiarPadre_clicked()");
}


function head_tbnVerCambios_clicked() 
{
		var idVersion:Number = this.cursor().valueBuffer("idversion");
		if (!idVersion) {
				MessageBox.critical(this.iface.util.translate("scripts",
						"No hay ninguna versión seleccionada"), MessageBox.Ok);
				return false;
		}
		
		var miVar:FLVar = new FLVar();
		miVar.set("ACCIONMV", "VC");
		
		var f:Object = new FLFormSearchDB("mv_modversiones");
		var cursor:FLSqlCursor = f.cursor();
		cursor.select("idversion = " + idVersion);
		cursor.first();
		cursor.setModeAccess(cursor.Edit);
		f.setMainWidget();
		cursor.refreshBuffer();
		f.exec("idversion");
		f.close();
}

function head_tbnPropagar_clicked() 
{
		var idVersion:Number = this.cursor().valueBuffer("idversion");
		if (!idVersion) {
				MessageBox.critical(this.iface.util.translate("scripts",
						"No hay ninguna versión seleccionada"), MessageBox.Ok);
				return false;
		}
		
		var miVar:FLVar = new FLVar();
		miVar.set("ACCIONMV", "PR");
		
		var f:Object = new FLFormSearchDB("mv_modversiones");
		var cursor:FLSqlCursor = f.cursor();
		cursor.select("idversion = " + idVersion);
		cursor.first();
		cursor.setModeAccess(cursor.Edit);
		f.setMainWidget();
		cursor.refreshBuffer();
		cursor.transaction(false);
		f.exec("idversion");
		f.close();
}

function head_tbnVerHijos_clicked() 
{
		var idVersion:Number = this.cursor().valueBuffer("idversion");
		if (!idVersion) {
				MessageBox.critical(this.iface.util.translate("scripts",
						"No hay ninguna versión seleccionada"), MessageBox.Ok);
				return false;
		}
		
		var miVar:FLVar = new FLVar();
		miVar.set("ACCIONMV", "VH");
		
		var f:Object = new FLFormSearchDB("mv_modversiones");
		var cursor:FLSqlCursor = f.cursor();
		cursor.select("idversion = " + idVersion);
		cursor.first();
		cursor.setModeAccess(cursor.Edit);
		f.setMainWidget();
		cursor.refreshBuffer();
		f.exec("idversion");
		f.close();
}

function head_tbnCambiarPadre_clicked() 
{
		var idVersion:Number = this.cursor().valueBuffer("idversion");
		if (!idVersion) {
				MessageBox.critical(this.iface.util.translate("scripts",
						"No hay ninguna versión seleccionada"), MessageBox.Ok);
				return false;
		}
		
		var miVar:FLVar = new FLVar();
		miVar.set("ACCIONMV", "CP");
		
		var f:Object = new FLFormSearchDB("mv_modversiones");
		var cursor:FLSqlCursor = f.cursor();
		cursor.select("idversion = " + idVersion);
		cursor.first();
		cursor.setModeAccess(cursor.Edit);
		f.setMainWidget();
		cursor.refreshBuffer();
		f.exec("idversion");
		f.close();
}

function head_tbnCrearHijo_clicked()
{
		var curPadre = this.cursor();
		var idVersionPadre:Number = this.cursor().valueBuffer("idversion");
		if (!idVersionPadre) {
				MessageBox.critical(this.iface.util.translate("scripts",
						"No hay ninguna versión seleccionada"), MessageBox.Ok);
				return false;
		}
		
		var idArea = curPadre.valueBuffer("idarea");
		var idModulo = curPadre.valueBuffer("idmodulo");
		
		var miVar:FLVar = new FLVar();
		miVar.set("ACCIONMV", "CH");
		
		var f:Object = new FLFormSearchDB("mv_modversiones");
		var cursor:FLSqlCursor = f.cursor();
		cursor.setModeAccess(cursor.Insert);
		f.setMainWidget();
		cursor.refreshBuffer();
		cursor.setValueBuffer("idarea", idArea);
		cursor.setValueBuffer("idmodulo", idModulo);
		cursor.setValueBuffer("idversionpadre", idVersionPadre);
		f.exec("idversion");
		f.close();
}

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////

//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////