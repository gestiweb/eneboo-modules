function init()
{
 //connect (form.child("toolButtonPrintCertificados"), "clicked()", this, "lanzar()");
 form.child("flidformacion").setDisabled(true);
 form.child("flidPersona").setDisabled(true);
 form.child("flcodcliente").setDisabled(true);
 form.child("flidPonente").setDisabled(true);
}
function validateform()
{
 return true;
}
function lanzar()
{
  var cursor = form.cursor()
  var seleccion = cursor.valueBuffer("idcert");
  if (!seleccion)
    return;
  var nombreInforme = cursor.action();
  var orderBy = "";
  flfactinfo.lanzarInforme(cursor, nombreInforme, orderBy);
}