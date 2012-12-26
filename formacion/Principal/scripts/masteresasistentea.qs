function init()
{
		var imprimir = form.child("toolButtonPrint");
		connect(imprimir, "clicked()", this, "imprimir");
}

function imprimir()
{
		var rptViewer = new FLReportViewer();
		rptViewer.renderReport();
		rptViewer.exec();
}
