function init()
{
}

function main()

{
   var query = new FLSqlQuery("informexunta");
   var rptViewer = new FLReportViewer();
   rptViewer.setReportTemplate("xunta");
   rptViewer.setReportData(query);
   rptViewer.renderReport();
   rptViewer.exec();
}

