function init()
{
  var imprimir = form.child("toolButtonPrint");
  connect(imprimir, "clicked()", this, "imprimir");
}

function imprimir()
{
  var q = new FLSqlQuery("tipoformacion");
  var rptViewer = new FLReportViewer();
  rptViewer.setReportTemplate("tipoformacion");
  rptViewer.setReportData(q);
  rptViewer.renderReport();
  rptViewer.exec();
}
