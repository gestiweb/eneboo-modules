function init()
{
}

function main()
{
  MessageBox.information( "Inicio function main()", "Informacion" );
  var f = new FLFormSearchDB("selectcurso");
  var cursor = f.cursor();
  cursor.setActivatedCheckIntegrity(false);
  cursor.select();
  if (!cursor.first())
     cursor.setModeAccess(0);
  else
     cursor.setModeAccess(1);
  f.setMainWidget();
  cursor.refreshBuffer();
  var acpt = f.exec("idcurso");
  MessageBox.information( acpt, "Informacion" );
  if( acpt ) {
    var alumnos = new FLSqlQuery("alumnos");
    alumnos.setValueParam("curso", acpt);
    alumnos.exec();
//  alumnos.showDebug();

    if( alumnos.first() ) {
      do {
        MessageBox.information( alumnos.value(0).toString()+":"+alumnos.value(1).toString(), "Informacion" );
        var certificado = new FLSqlQuery("certificado");
        certificado.setValueParam("curso", alumnos.value(0));
        certificado.setValueParam("alumno", alumnos.value(1));
        var rptViewer = new FLReportViewer();
        rptViewer.setReportTemplate("certificado");
        rptViewer.setReportData(certificado);
        rptViewer.renderReport();
        rptViewer.exec();

//        MessageBox.information( "Inicio prueba de QPrinter", "Informacion" );
//        var printer = new QPrinter();
//        printer.setFullPage(TRUE);
//        printer.setOutputToFile(TRUE);
//        printer.setOutputFileName("/tmp/qprinter.ps");
//        printer.setup();
        MessageBox.information( "Final prueba de QPrinter", "Informacion" );

      } while ( alumnos.next() );
    }
    else {
      MessageBox.critical( "El curso elegido no tiene alumnos", "Error" );
    }
  }

  MessageBox.information( "Fin function main()", "Informacion" );
}

