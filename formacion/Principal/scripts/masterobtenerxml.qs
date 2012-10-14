function init()
{
    var fichero = form.child("pbFichero");
    connect(fichero, "clicked()", this, "establecerFichero");
}
function establecerFichero()
{
  var directorio = FileDialog.getSaveFileName("","Elegir Directorio");
  form.child("leFichero").text=directorio;
  
}
function validateForm()
{  
    var file = new File(form.child("leFichero").text);
    file.open(File.WriteOnly);
    file.writeLine("XML");
    file.close();
    return true;
}