function init() {
}
function main(){
var f = new FLFormSearchDB("selectpersona");
  var cursor = f.cursor();

  cursor.setActivatedCheckIntegrity(false);
  cursor.select();
  if (!cursor.first())
    cursor.setModeAccess(0);
  else
    cursor.setModeAccess(1);

  f.setMainWidget();
  cursor.refreshBuffer();
  var acpt = f.exec("desde");
  if (acpt) {
    cursor.commitBuffer();
    var q = new FLSqlQuery("certifasistente");
    q.setValueParam("asistente", cursor.valueBuffer("idpersona"));
    var rptViewer = new FLReportViewer();
    rptViewer.setReportTemplate("certifasistente");
    rptViewer.setReportData(q);
    rptViewer.renderReport();
    rptViewer.exec();
  }
}