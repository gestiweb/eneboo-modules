function init()
{
    var fichero = form.child("pbFichero");
    connect(fichero, "clicked()", this, "establecerFichero");
}

function main()
{
  var f = new FLFormSearchDB("obtenerxml");
  var cursor = f.cursor();

  cursor.setActivatedCheckIntegrity(false);
  cursor.select();
  cursor.setModeAccess(cursor.Insert);

  f.setMainWidget();
  cursor.refreshBuffer();
  var acpt = f.exec("idobtenerxml");
  if (acpt) {
/*    cursor.commitBuffer();    
    var q = new FLSqlQuery("asistentes-por-formacion");
    q.setValueParam("idformacion", cursor.valueBuffer("idformacion"));
    var rptViewer = new FLReportViewer();
    rptViewer.setReportData(q);
    rptViewer.setReportTemplate("recepcion_doc");
    rptViewer.renderReport();
    rptViewer.exec();*/
  }
}
function establecerFichero()
{
  MessageBox.Information("Funciona","Informacion");
  var directorio = FileDialog.getExistingDirectory("", util.translate("scripts","Elegir Directorio"));
  File.write(directorio+form.child("leFichero").text,"XML");
 }