function init()
{
}

function main()
{
   var q = new FLSqlQuery("cursos");
   var rptViewer = new FLReportViewer();
   rptViewer.setReportTemplate("cursos");
   rptViewer.setReportData(q);
   rptViewer.renderReport();
   rptViewer.exec();
}


