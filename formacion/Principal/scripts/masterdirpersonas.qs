function init()
{
		var imprimir = form.child("toolButtonPrint");
		connect(imprimir, "clicked()", this, "imprimir");
}

function imprimir()
{
		var q = new FLSqlQuery("dirpersonas");
		var rptViewer = new FLReportViewer();
		rptViewer.setReportTemplate("dirpersonas");
		rptViewer.setReportData(q);
		rptViewer.renderReport();
		rptViewer.exec();
}
