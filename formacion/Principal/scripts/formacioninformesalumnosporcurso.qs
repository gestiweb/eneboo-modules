function init()
{
}

function main()
{
                var q = new FLSqlQuery("alumnosxcurso");
		var rptViewer = new FLReportViewer();
                rptViewer.setReportTemplate("alumnosxcurso");
                rptViewer.setReportData(q);
                rptViewer.renderReport();
                rptViewer.exec();
}


