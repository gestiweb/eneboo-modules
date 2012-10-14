function init()
{
		var imprimir = form.child("toolButtonPrint");
		connect(imprimir, "clicked()", this, "imprimir");
}

function imprimir()
{
		var q = new FLSqlQuery("personas");
		var rptViewer = new FLReportViewer();
		rptViewer.setReportTemplate("personas");
		rptViewer.setReportData(q);
		rptViewer.renderReport();
		rptViewer.exec();
}
