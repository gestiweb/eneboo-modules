function init()
{
  var imprimir = form.child("toolButtonPrint");
  connect(imprimir, "clicked()", this, "imprimir");
}

function imprimir()
{
  var q = new FLSqlQuery("autorizaciones");
  var rptViewer = new FLReportViewer();
  rptViewer.setReportTemplate("autorizaciones");
  rptViewer.setReportData(q);
  rptViewer.renderReport();
  rptViewer.exec();
}
