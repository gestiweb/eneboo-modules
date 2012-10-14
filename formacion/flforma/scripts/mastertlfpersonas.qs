function init()
{
		var imprimir = form.child("toolButtonPrint");
		connect(imprimir, "clicked()", this, "imprimir");
}

function imprimir()
{
		var q = new FLSqlQuery("tlfpersonas");
		var rptViewer = new FLReportViewer();
		rptViewer.setReportTemplate("tlfpersonas");
		rptViewer.setReportData(q);
		rptViewer.renderReport();
		rptViewer.exec();
}
