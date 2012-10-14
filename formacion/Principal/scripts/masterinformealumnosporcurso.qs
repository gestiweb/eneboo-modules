function init()
{
}

function main()
{
                var q = new FLSqlQuery("alumnos-por-curso");
		var rptViewer = new FLReportViewer();
                rptViewer.setReportTemplate("alumnos-por-curso");
                rptViewer.setReportData(q);
                rptViewer.renderReport();
                rptViewer.exec();
}


