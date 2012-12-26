function init(){
}
function main(){
    var q = new FLSqlQuery("accionesformativas");
    q.setValueParam("from", "1792-01-01T00:00:00");
    q.setValueParam("to", "8000-12-30T00:00:00");
    var rptViewer = new FLReportViewer();
    rptViewer.setReportTemplate("accionesformativas");
    rptViewer.setReportData(q);
    rptViewer.renderReport();
    rptViewer.exec();
}