function init()
{
		var imprimir = form.child("toolButtonPrint");
		connect(imprimir, "clicked()", this, "imprimir");
}

function imprimir()
{
		var q = new FLSqlQuery("actividadeslaborales");
		var rptViewer = new FLReportViewer();
		rptViewer.setReportTemplate("actividadeslaborales");
		rptViewer.setReportData(q);
		rptViewer.renderReport();
		rptViewer.exec();
}
