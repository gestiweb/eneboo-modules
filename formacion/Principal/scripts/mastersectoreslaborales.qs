function init()
{
		var imprimir = form.child("toolButtonPrint");
		connect(imprimir, "clicked()", this, "imprimir");
}

function imprimir()
{
              var q = new FLSqlQuery("sectoreslaborales");
		    var rptViewer = new FLReportViewer();
		    rptViewer.setReportTemplate("sectoreslaborales");
		    rptViewer.setReportData(q);
		    rptViewer.renderReport();
		    rptViewer.exec();
		
}
