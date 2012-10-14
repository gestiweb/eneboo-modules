function init()
{
      var imp_formaciones = form.child("toolButtonPrintFormaciones");
      connect(imp_formaciones,"clicked()", this,"ImprimirFormaciones");
      var imp_certificados = form.child("toolButtonPrintCertificados");
      connect(imp_certificados,"clicked()", this,"ImprimirCertif");
}

function ImprimirFormaciones()
{
  var consulta= "Los parámetros: ";
  var f = new FLFormSearchDB("imprimiracciones");
  var cursor = f.cursor();

  cursor.setActivatedCheckIntegrity(false);
  cursor.select();
  /*if (!cursor.first())
    cursor.setModeAccess(0);
  else
    cursor.setModeAccess(1);*/
  cursor.setModeAccess(cursor.Insert);

  f.setMainWidget();
  cursor.refreshBuffer();
  cursor.setValueBuffer("desde",Date().toString());
  cursor.setValueBuffer("hasta",Date().toString());
  var acpt = f.exec("idimpacciones");
  if (acpt) {
    cursor.commitBuffer();
    var q = new FLSqlQuery("accionesformativas");
    q.setValueParam("from", "1792-01-01T00:00:00");
    q.setValueParam("to", "8000-12-30T00:00:00");
    q.setWhere(q.where()+"");
    if(f.child("cbdesde").checked){
  
       q.setValueParam("from", cursor.valueBuffer("desde"));
       consulta=consulta+"\nDesde: "+cursor.valueBuffer("desde");
    }
    if(f.child("cbhasta").checked){
       q.setValueParam("to", cursor.valueBuffer("hasta"));
       consulta=consulta+"\nHasta: "+cursor.valueBuffer("hasta");
    }
    if(f.child("cbid").checked){
      q.setFrom(q.from()+",autorizaciones");
      q.setWhere(q.where()+" AND empresa.id=autorizaciones.id AND accionesformativas.idautorizacion=autorizaciones.idautorizacion AND autorizaciones.id="+cursor.valueBuffer("id"));
      consulta=consulta+"\nCódigo Empresa: "+cursor.valueBuffer("id");
    }
    if(f.child("cbidPersona").checked){
      q.setFrom(q.from()+",esasistentea,personas");
      q.setWhere(q.where()+" AND esasistentea.idformacion=accionesformativas.idformacion AND esasistentea.idpersona=personas.idpersona AND esasistentea.idpersona="+ cursor.valueBuffer("idpersona")); 
      consulta=consulta+"\nIdentificador Persona: "+cursor.valueBuffer("idpersona");
    }
    if(f.child("cbcodcliente").checked) {
      q.setFrom(q.from()+",esempleadode,clientes");
      if(!(f.child("cbidPersona").checked)){
   q.setFrom(q.from()+",esasistentea,personas");
        q.setWhere(q.where()+" AND esasistentea.idformacion=accionesformativas.idformacion AND esasistentea.idpersona=personas.idpersona");
       }
       q.setWhere(q.where()+" AND esempleadode.idpersona=personas.idpersona AND clientes.codcliente=esempleadode.codcliente AND clientes.codcliente='"+ cursor.valueBuffer("codcliente") +"'");
      consulta=consulta+"\nCódigo Cliente: "+cursor.valueBuffer("codcliente");
    }
    q.setWhere(q.where()+" order by accionesformativas.idformacion");
   consulta=consulta+"\nNo obtienen ningún resultado\nVuelva a intentarlo";
    q.showDebug();
    q.exec();
    if(q.first()){
      var rptViewer = new FLReportViewer();
      rptViewer.setReportTemplate("accionesformativas");
      rptViewer.setReportData(q);
      rptViewer.renderReport();      
      rptViewer.printReport();
    }
    else {      
 MessageBox.information(consulta,"Información");
       ImprimirFormaciones();
     }
  }
}

function ImprimirCertif()
{
    var query1 = new FLSqlQuery();
    query1.setTablesList("esponentede");
    query1.setSelect("idformacion");
    query1.setFrom("esponentede");
    query1.setWhere("esponentede.idformacion="+form.cursor().valueBuffer("idformacion"));
    query1.showDebug();
    query1.exec();
    if (!query1.first()) {
 MessageBox.information("Para poder obtener certificados debe la acción formativa debe poseer al menos un ponente","Información");
    }
    else{
    var query2 = new FLSqlQuery();
    query2.setTablesList("esasistentea");
    query2.setSelect("idformacion");
    query2.setFrom("esasistentea");
    query2.setWhere("esasistentea.idformacion="+form.cursor().valueBuffer("idformacion"));
    query2.showDebug();
    query2.exec();
    if (!query2.first()) {
 MessageBox.information("Para poder obtener certificados debe la acción formativa debe poseer al menos un asistente","Información");
    }
    else{

  var f = new FLFormSearchDB("imprimircertificados");
  var cursor = f.cursor();
  var consulta= "Los parámetros: ";
  cursor.setActivatedCheckIntegrity(false);
  cursor.select();
  /*if (!cursor.first())
    cursor.setModeAccess(0);
  else
    cursor.setModeAccess(1);*/
  cursor.setModeAccess(cursor.Insert);
  f.setMainWidget();
  f.child("flidformacion").setValue(form.cursor().valueBuffer("idformacion"));
  cursor.setValueBuffer("idformacion",form.cursor().valueBuffer("idformacion"));
  cursor.refreshBuffer();
  
  var acpt = f.exec("idimprimircert");
  
  if (acpt) {
    cursor.commitBuffer();
    var q = new FLSqlQuery("certificado");
    q.setValueParam("idF", form.cursor().valueBuffer("idFormacion"));
    q.setWhere(q.where()+"");
    if(f.child("cbidPonente").checked){
      q.setFrom(q.from()+",esponentede");
      q.setWhere(q.where()+" AND ponente.idpersona="+cursor.valueBuffer("idPonente"));
      consulta=consulta+"\nIdentificador Ponente: "+cursor.valueBuffer("idPonente");
    }
    if(f.child("cbidPersona").checked){
      q.setWhere(q.where()+" AND esasistentea.idpersona="+ cursor.valueBuffer("idpersona")); 
      consulta=consulta+"\nIdentificador Persona: "+cursor.valueBuffer("idpersona");
    }
    if(f.child("cbcodcliente").checked) {
      q.setFrom(q.from()+",esempleadode,clientes");
      q.setWhere(q.where()+" AND esempleadode.idpersona=personas.idpersona AND clientes.codcliente=esempleadode.codcliente AND clientes.codcliente='"+ cursor.valueBuffer("codcliente") +"'");
      consulta=consulta+"\nCódigo Cliente: "+cursor.valueBuffer("codcliente");
    }
    q.setWhere(q.where()+" order by accionesformativas.idformacion");
    consulta=consulta+"\nNo obtienen ningún resultado\nVuelva a intentarlo";
    q.showDebug();
    q.exec();
    if(q.first()){
      var rptViewer = new FLReportViewer();
      rptViewer.setReportTemplate("certificado");
      rptViewer.setReportData(q);
      rptViewer.renderReport();
      rptViewer.printReport();
    }
    else {      
 MessageBox.information(consulta,"Información");
       ImprimirCertif();
     }
  }
}
}
}
