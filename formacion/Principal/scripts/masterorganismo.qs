function init()
{
      var imp_formaciones = form.child("toolButtonPrint");
      connect(imp_formaciones,"clicked()", this,"Imprimir");
}
function Imprimir()
{
  var consulta= "Los parámetros: ";
  var f = new FLFormSearchDB("imprimirinformesorganismo");
  var cursor = f.cursor();

  cursor.setActivatedCheckIntegrity(false);
  cursor.select();
  if (!cursor.first())
    cursor.setModeAccess(0);
  else
    cursor.setModeAccess(1);

  f.setMainWidget();
  cursor.refreshBuffer();
  var acpt = f.exec("idimprimirinformesorganismo");
  
  if (acpt) {
    cursor.commitBuffer();
    var q = new FLSqlQuery("informesorganismo");
    q.setValueParam("idorganismo", form.cursor().valueBuffer("idorganismo"));
    consulta=consulta+"\nNo obtienen ningún resultado\nVuelva a intentarlo";
    
      q.setFrom(q.from()+",ejercicios");
      q.setSelect(q.select()+",ejercicios.codejercicio,ejercicios.nombre,ejercicios.fechainicio,ejercicios.fechafin");
      q.setWhere(q.where()+" AND ejercicios.codejercicio=organismo.codejercicio AND organismo.codejercicio='"+cursor.valueBuffer("codejercicio")+"'"+" AND accionesformativas.codejercicio='"+cursor.valueBuffer("codejercicio")+"'");
      consulta=consulta+"\nCódigo Ejercicio: "+cursor.valueBuffer("codejercicio");
      
    if(f.child("cbidactividad").checked){
      q.setWhere(q.where()+" AND actividadeslaborales.idactividad="+ cursor.valueBuffer("idactividad")); 
      consulta=consulta+"\nIdentificador Actividad Laboral: "+cursor.valueBuffer("idactividad");
    }
    
    if(f.child("cbidsector").checked) {
      q.setFrom(q.from()+",sectoreslaborales");
      q.setWhere(q.where()+" AND actividadeslaborales.idsector="+cursor.valueBuffer("idsector"));
      consulta=consulta+"\nId sector: "+cursor.valueBuffer("idsector");
      if(!(f.child("cbidactividad").checked)){
         q.setWhere(q.where()+" AND actividadeslaborales.idactividad=accionesformativas.idactividad"); 
      }
    }
   q.setWhere(q.where()+" GROUP BY actividadeslaborales.nombreact, ejercicios.codejercicio, ejercicios.nombre, ejercicios.fechainicio, ejercicios.fechafin,empresa.nombre");
   consulta=consulta+"\nNo obtienen ningún resultado\nVuelva a intentarlo";
    q.showDebug();
    q.exec();
    if(q.first()){
      var rptViewer = new FLReportViewer();
      rptViewer.setReportTemplate("informesorganismo");
      rptViewer.setReportData(q);
      rptViewer.renderReport();
      rptViewer.exec();
    }
    else {      
 MessageBox.information(consulta,"Información");
       Imprimir();
     }
  }
}