function init()
{
}

function main()
{
   var q = new FLSqlQuery("informexunta");
   var rptViewer = new FLReportViewer();
   rptViewer.setReportTemplate("xunta");
   rptViewer.setReportData(q);
   rptViewer.renderReport();
   rptViewer.exec();
}

