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
  var acptasistente = f.exec("idPersona");
  if( acptasistente ) {
    MessageBox.information( "Asistente numero "+acptasistente, "Informacion" );

    var fformacion = new FLFormSearchDB("selectformacion");
    var cformacion = fformacion.cursor();
    cformacion.setActivatedCheckIntegrity(false);
    cformacion.select();
    if (!cformacion.first())
       cformacion.setModeAccess(0);
    else
       cformacion.setModeAccess(1);
    fformacin.setMainWidget();
    cformacion.refreshBuffer();
    var acptformacion = fformacion.exec("idFormacion");
    if( acptformacion ) {
      MessageBox.information( "Formación numero "+acptformacion, "Informacion" );
      var q = new FLSqlQuery();
      q.setSelect("esasistentea.idPersona, esasistentea.idFormacion");
      q.setFrom("esasistentea");
      q.setWhere("esasistentea.idPersona="+acptalumno.toString()+" and esasistentea.idcurso="+acptformacion.toString());
      q.exec();
      q.showDebug();
      if( q.first() ) {
        MessageBox.information( "Los datos son validos", "Informacion" );
        var certificado = new FLSqlQuery("certificado");
        certificado.setValueParam("asistente", acptasistente);
        certificado.setValueParam("formacion", acptformacion);
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
      MessageBox.critical( "La formación elegida no es valida", "Error" );
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
   MessageBox.critical( "El asistente elegido no es valido", "Error" );
  }
  MessageBox.information( "Fin function main()", "Informacion" );
}


