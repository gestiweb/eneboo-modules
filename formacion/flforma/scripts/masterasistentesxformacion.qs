function init()
{
}

function main()
{
  var f = new FLFormSearchDB("imprimirasxform2");
  var cursor = f.cursor();

  cursor.setActivatedCheckIntegrity(false);
  cursor.select();
  /*if (!cursor.first())
    cursor.setModeAccess(0);
  else
    cursor.setModeAccess(1);*/
  cursor.setModeAccess(cursor.Insert);

  f.setMainWidget();
  cursor.refreshBuffer();
  var acpt = f.exec("idformacion");
  if (acpt) {
    cursor.commitBuffer();    
    var q = new FLSqlQuery("asistentes-por-formacion");
    q.setValueParam("idformacion", cursor.valueBuffer("idformacion"));
    var rptViewer = new FLReportViewer();
    rptViewer.setReportData(q);
    rptViewer.setReportTemplate("recepcion_doc");
    rptViewer.renderReport();
    rptViewer.printReport();
  }
}