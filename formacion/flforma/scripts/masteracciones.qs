function init()
{
  with(form) {
    connect(child("pbExaminar1"), "clicked()", this, "establecerFichero1");
    connect(child("pbExaminar2"), "clicked()", this, "establecerFichero2");
  }
  //Desactivar botón "cerrar"
  form.child("cerrar").setEnabled(false);
  //Conectar botón "cerrar" con funcion
  var cerrar_estado = form.child("cerrar");
  connect(cerrar_estado,"clicked()",this,"Cerrar");
  //Conectar botón "certificados" con funcion
  var certif = form.child("certificados");
  connect(certif,"clicked()",this,"Certificados");
  //Control campo "esCompuesta"
  if (form.cursor().valueBuffer("esCompuesta") == true) 
      form.child("barraBotonesFormacion").setEnabled(true);
  else
      form.child("barraBotonesFormacion").setEnabled(false);
  //Insertar formación simple
  connect(form.cursor(), "bufferChanged(QString)", this, "bufferCambiado");
  //connect(insertar_simple, "clicked()", this, "InsertarSimple");
  var insertar_simple = form.child("toolButtomInsertFormacion");
 
  //Casos de campo "estado"
  if (form.cursor().valueBuffer("estado") == "Nueva") {
     form.child("certificados").setEnabled(false);
  }
  if (form.cursor().valueBuffer("estado") == "Abierta") {
     Abierta();
  }
  if (form.cursor().valueBuffer("estado") == "Cerrada") {
     Cerrada();
  }
  if (form.cursor().valueBuffer("estado") == "En Celebración") {
     EnCelebracion();
  }
  if (form.cursor().valueBuffer("estado") == "Celebrada") {
     Celebrada();
  }
  if (form.cursor().valueBuffer("estado") == "Finalizada") {
     Finalizada();
  }
}

function bufferCambiado(nombreCampo) //Función para controlar campo "esCompuesta"
{
  if (nombreCampo == "esCompuesta") {
    if (form.cursor().valueBuffer("esCompuesta") == true) 
      form.child("barraBotonesFormacion").setEnabled(true);
    else
      form.child("barraBotonesFormacion").setEnabled(false);
  }
}

function validateForm() //Función validar formación
{
    if(form.cursor().valueBuffer("esCompuesta") == true){
    var query = new FLSqlQuery();
    query.setTablesList("pertenecea");
    query.setSelect("idformacion");
    query.setFrom("pertenecea");
    query.setWhere("pertenecea.idformacion="+form.cursor().valueBuffer("idformacion"));
    query.showDebug();
    query.exec();
    if (!query.first()) {
 MessageBox.information("Si es una Acción Formativa compuesta debe tener al menos una Acción Formativa simple asociada","Información");
      return false;
    }
  }
  //Comprobación fechainicio<fechafin
  if (form.child("fechainicio").value()> form.child("fechafin").value()) {
    MessageBox.critical("La fecha de inicio de la acción formativa debe ser menor que la de fin",MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return false;
  }
  //Paso a estado "Abierta"
  if(form.cursor().valueBuffer("estado")=="Nueva" & form.cursor().valueBuffer("tipo")!="" & form.cursor().valueBuffer("idautorizacion")!=""){
    form.child("estado").setValue("Abierta");
    form.cursor().setValueBuffer("estado","Abierta");
    MessageBox.information("Estado es ahora: "+form.cursor().valueBuffer("estado"),"Información");
     form.cursor().commitBuffer();
  }
  return true;
}

function deshabilitar()
{
    form.child("groupBox7").setEnabled(false);
    form.child("groupBox8").setEnabled(false);
    form.child("groupBox24").setEnabled(false);
    form.child("groupBox5").setEnabled(false);
    form.child("groupBox9").setEnabled(false);
    form.child("groupBox10").setEnabled(false);
    form.child("groupBox13").setEnabled(false);
    form.child("fLFieldDB10").setDisabled(true);
    form.child("fLFieldDB14").setDisabled(true);
    form.child("FLFieldDB1_3").setDisabled(true);
    form.child("fLFieldDB14").setDisabled(true);
    form.child("fLFieldDB20").setDisabled(true);
    form.child("fLFieldDB27").setDisabled(true);
    form.child("compuesta").setEnabled(false);
    form.child("toolButtomInsertAsistente").setEnabled(false);
    form.child("toolButtonEditAsistente").setEnabled(false);
    form.child("toolButtonDeleteAsistente").setEnabled(false);
    form.child("toolButtomInsertPonente").setEnabled(false);
    form.child("toolButtonEditPonente").setEnabled(false);
    form.child("toolButtonDeletePonente").setEnabled(false);
}

function Abierta() //Función para el estado "Abierta"
{
  form.cursor().refreshBuffer();
  form.child("cerrar").setEnabled(true);
}

function Cerrar() //Función para el botón "cerrar"
{
    var query1 = new FLSqlQuery();
    query1.setTablesList("esponentede");
    query1.setSelect("idformacion");
    query1.setFrom("esponentede");
    query1.setWhere("esponentede.idformacion="+form.cursor().valueBuffer("idformacion"));
    query1.showDebug();
    query1.exec();
    if (!query1.first()) {
 MessageBox.information("Para cerrar la acción formativa debe tener al menos un ponente","Información");
    }
    else {
    var query2 = new FLSqlQuery();
    query2.setTablesList("esasistentea");
    query2.setSelect("idFormacion");
    query2.setFrom("esasistentea");
    query2.setWhere("esasistentea.idformacion="+form.cursor().valueBuffer("idformacion"));
    query2.showDebug();
    query2.exec();
    if (!query2.first()) {
 MessageBox.information("Para cerrar la acción formativa debe tener al menos un asistente","Información");
    }
    else{  
  form.cursor().refreshBuffer();
  if (form.child("fechainicio").value()> form.child("fechafin").value()) {
    MessageBox.critical("La fecha de inicio de la acción formativa debe ser menor que la de fin",MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
  }
  deshabilitar();
  //Paso a estado "Cerrada"  
  if (form.cursor().valueBuffer("estado") == "Abierta") {
    form.child("estado").setValue("Cerrada");
    form.cursor().setValueBuffer("estado","Cerrada");
    MessageBox.information("Estado es ahora: "+form.cursor().valueBuffer("estado"),"Información");
    form.child("cerrar").setEnabled(false);
  }
}
}
}

function Cerrada() //Función para estado "Cerrada"
{
  form.cursor().refreshBuffer();
  if (form.child("fechainicio").value()> form.child("fechafin").value()) {
    MessageBox.critical("La fecha de inicio de la acción formativa debe ser menor que la de fin",MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
  }
  deshabilitar();
  //Paso a estado "En celebración"
  if(Date().toString()>form.child("fechainicio").value()){    
      if(Date().toString()>form.child("fechafin").value()){
   form.child("estado").setValue("Celebrada");
        form.cursor().setValueBuffer("estado","Celebrada");
        form.child("cerrar").setEnabled(true);
        form.child("cerrar").text="Certificados"; //Habilitar botón "cerrar" para emitir certificados
        MessageBox.information("Estado es ahora: "+form.cursor().valueBuffer("estado"),"Información");
        form.cursor().commitBuffer();
   form.accept();
      }
      else{
        form.child("estado").setValue("En Celebración");
        form.cursor().setValueBuffer("estado","En Celebración");
        MessageBox.information("Estado es ahora: "+form.cursor().valueBuffer("estado"),"Información");
        form.cursor().commitBuffer();
   form.accept();
      }
  }
}

function EnCelebracion() //Función para estado "En Celebración"
{  
  if (form.child("fechainicio").value()> form.child("fechafin").value()) {
    MessageBox.critical("La fecha de inicio de la acción formativa debe ser menor que la de fin",MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
  }
  deshabilitar();
  //Paso a estado "Celebrada"
  if(Date().toString()>form.child("fechafin").value()){
    form.child("estado").setValue("Celebrada");
    form.cursor().setValueBuffer("estado","Celebrada");
    form.child("cerrar").setEnabled(true);
    form.child("cerrar").text="Certificados"; //Habilitar botón "cerrar" para emitir certificados
    MessageBox.information("Estado es ahora: "+form.cursor().valueBuffer("estado"),"Información");
    form.cursor().commitBuffer();
  }     
}

function Celebrada() //Función para estado "Celebrada"
{
  if (form.child("fechainicio").value()> form.child("fechafin").value()) {
      MessageBox.critical("La fecha de inicio de la acción formativa debe ser menor que la de fin",MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
  }     
  deshabilitar();
}

function Finalizada() //Función para estado "Finalizada"
{
  deshabilitar();
}

function Certificados()
{
  //Paso a estado "Finalizada" 
  if (form.cursor().valueBuffer("estado") == "Celebrada"){
    MessageBox.information("Se cambia el estado a: Finalizada","Información");
    form.child("estado").setValue("Finalizada");
    deshabilitar();
    form.cursor().setValueBuffer("estado","Finalizada");
  }
  var f = new FLFormSearchDB("imprimircertificados");  
  var cursor = f.cursor();
  var consulta= "La Consulta: ";
  cursor.setActivatedCheckIntegrity(false);
  cursor.select();
  if (!cursor.first())
    cursor.setModeAccess(0);
  else
    cursor.setModeAccess(1);
  
  f.setMainWidget();
  cursor.refreshBuffer();
  var acpt = f.exec("idimprimircert");
  
  if (acpt) {
    cursor.commitBuffer();
    var q = new FLSqlQuery("certificado");
    q.setValueParam("idF", form.cursor().valueBuffer("idformacion"));
    q.setWhere(q.where()+"");
    if(f.child("cbidPonente").checked){
      q.setFrom(q.from()+",esponentede");
      q.setWhere(q.where()+" AND esponentede.idformacion=accionesformativas.idformacion AND esponentede.idpersona=personas.idpersona AND esponentede.idpersona="+cursor.valueBuffer("idPonente"));
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
    consulta=consulta+"\nEs una consulta vacía\nVuelva a realizarla";
    q.showDebug();
    q.exec();
    if(q.first()){
      var rptViewer = new FLReportViewer();
      rptViewer.setReportTemplate("certificado");
      rptViewer.setReportData(q);
      rptViewer.renderReport();
      rptViewer.exec();
    }
    else {      
 MessageBox.information(consulta,"Información");
       Certificados();
     }
  }
}    

function InsertarSimple() // Función para insertar formaciones simples
{
  var f = new FLFormRecordDB("nuevaformacion");
  var cursor = f.cursor();
  cursor.child("esCompuesta").setEnabled(false);
  
  cursor.setActivatedCheckIntegrity(false);
  cursor.select();
  if (!cursor.first())
    cursor.setModeAccess(0);
  else
    cursor.setModeAccess(1);
 var acpt = f.exec("idformacion");
  if (acpt) {
    cursor.commitBuffer();
}
    if(q.first()){
      var rptViewer = new FLReportViewer();
      rptViewer.setReportTemplate("accionesformativas");
      rptViewer.setReportData(q);
      rptViewer.renderReport();
      rptViewer.print();
      rptViewer.exec();
    }
    else {      
 MessageBox.information(consulta,"Información");
       ImprimirFormaciones();
  f.setMainWidget();
  cursor.refreshBuffer();
}
}
 
function establecerFichero1()
{
  form.child("leFichero1").text = FileDialog.getOpenFileName("*.txt");
  var file = new File(form.child("leFichero1").text);
  file.open(File.ReadOnly);
  var temario= file.read();
  form.cursor().setValueBuffer("temario", temario);
  file.close();
}

function establecerFichero2()
{
  form.child("leFichero2").text = FileDialog.getOpenFileName("*.txt");
  var file = new File(form.child("leFichero2").text);
  file.open(File.ReadOnly);
  var manual= file.read();
  form.cursor().setValueBuffer("manual", manual);
  file.close();
}
