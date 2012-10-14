function init()
{
}

function main()
{
  var f = new FLFormSearchDB("imprimirasxform");
  var cursor = f.cursor();

  cursor.setActivatedCheckIntegrity(false);
  cursor.select();
  cursor.setModeAccess(cursor.Insert);
  
  f.setMainWidget();
  cursor.refreshBuffer();
  var acpt = f.exec("idformacion");
  if (acpt) {
    cursor.commitBuffer();    
    var s;
//Elegir tipo de informe (subvencionado o no subvencionado)
    var query1 = new FLSqlQuery();
    query1.setTablesList("accionesformativas");
    query1.setSelect("accionesformativas.subvencionado,accionesformativas.idformacion");
    query1.setFrom("accionesformativas");
    query1.setWhere("accionesformativas.idformacion="+cursor.valueBuffer("idformacion"));
    query1.showDebug();
    query1.exec();
    query1.first();
    /*var rptViewer = new FLReportViewer();
    rptViewer.setReportData(query1);
    rptViewer.setReportTemplate("accionesformativas");
    rptViewer.renderReport();
    rptViewer.exec();*/
    var ss;
    ss= query1.value(0);
    var q = new FLSqlQuery("asistentes-por-formacion");
    q.setValueParam("idformacion", cursor.valueBuffer("idformacion"));
    var rptViewer = new FLReportViewer();
    rptViewer.setReportData(q);
    if(ss==true)  {
 rptViewer.setReportTemplate("control_as_sub");
    }
    else {
 rptViewer.setReportTemplate("control_as");
    }
    rptViewer.renderReport();
    rptViewer.printReport();
  }
}