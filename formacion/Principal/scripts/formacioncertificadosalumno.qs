function init()
{
}

function main()
{
  MessageBox.information( "Inicio function main()", "Informacion" );
  var f = new FLFormSearchDB("selectpersona");
  var c = f.cursor();
  c.setActivatedCheckIntegrity(false);
  c.select();
  if (!c.first())
     c.setModeAccess(0);
  else
     c.setModeAccess(1);
  f.setMainWidget();
  c.refreshBuffer();
  var acptalumno = f.exec("idpersona");
  if( acptalumno ) {
    MessageBox.information( "Alumno numero "+acptalumno, "Informacion" );

    var fcurso = new FLFormSearchDB("selectcurso");
    var ccurso = fcurso.cursor();
    ccurso.setActivatedCheckIntegrity(false);
    ccurso.select();
    if (!ccurso.first())
       ccurso.setModeAccess(0);
    else
       ccurso.setModeAccess(1);
    fcurso.setMainWidget();
    ccurso.refreshBuffer();
    var acptcurso = fcurso.exec("idcurso");
    if( acptcurso ) {
      MessageBox.information( "Curso numero "+acptcurso, "Informacion" );
      var q = new FLSqlQuery();
      q.setSelect("esalumnode.idpersona, esalumnode.idcurso");
      q.setFrom("esalumnode");
      q.setWhere("esalumnode.idpersona="+acptalumno.toString()+" and esalumnode.idcurso="+acptcurso.toString());
      q.exec();
      q.showDebug();
      if( q.first() ) {
        MessageBox.information( "Los datos son validos", "Informacion" );
        var certificado = new FLSqlQuery("certificado");
        certificado.setValueParam("alumno", acptalumno);
        certificado.setValueParam("curso", acptcurso);
        var rptViewer = new FLReportViewer();
        rptViewer.setReportTemplate("certificado");
        rptViewer.setReportData(certificado);
        rptViewer.renderReport();
        rptViewer.exec();
      }
      else {
        MessageBox.critical( "Los datos no son validos", "Error" );
      }
    }
    else {
      MessageBox.critical( "El curso elegido no es valido", "Error" );
    }


//
//  var acptcurso = f.exec("idcurso");
////  MessageBox.information( acptalumno+":"+acptcurso, "Informacion" );
//  if( acptalumno && acptcurso ) {
//    MessageBox.information( "parametros ok", "Informacion" );
//    var certificado = new FLSqlQuery("certificado");
//    certificado.setValueParam("alumno", acptalumno);
//    certificado.setValueParam("curso", acptcurso);
////    certificado.setValueParam("alumno", 1);
////    certificado.setValueParam("curso", 3);
////    certificado.exec();
////    certificado.showDebug();
//    var rptViewer = new FLReportViewer();
//    rptViewer.setReportTemplate("certificado");
//    rptViewer.setReportData(certificado);
//    rptViewer.renderReport();
//    rptViewer.exec();
  }
  else {
   MessageBox.critical( "El alumno elegido no es valido", "Error" );
  }
  MessageBox.information( "Fin function main()", "Informacion" );
}


