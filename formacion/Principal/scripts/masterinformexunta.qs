function init()
{
}

function main()
{
        var query = new FLSqlQuery();
        query.setTablesList("actividadeslaborales,personas,esalumnode,cursos");
        query.setSelect("COUNT(totalalumnos)");
        query.setFrom("actividadeslaborales,personas,esalumnode,cursos");
        query.setWhere("actividadeslaborales.idactividad=[id] AND 
                        personas.idpersona=esalumnode.idpersona  AND
                        esalumnode.idcurso=cursos.idcurso  AND
                        cursos.idactividad=actividadeslaborales.idactividad ;");
	query.showDebug();
        query.exec();
        if (query.next())
		return query.value(0);
}

function mostrarTotal()
{
        	q.setValueParam("actividadlaboral", cursor.valueBuffer("actividadlaboral"));
        var total = form.child("total");
        var util = new FLUtil();
        total.setFocus();
        total.setText(util.formatoMiles(calculateField("totalalumnos")));
}

function calculateField(id)
{
	var f = new FLFormSearchDB("actividadeslaborales_imp");
        var cursor = f.cursor();
        cursor.setActivatedCheckIntegrity(false);
        cursor.select();
        if (!cursor.first())
	        cursor.setModeAccess(0);
        else
                cursor.setModeAccess(1);
        f.setMainWidget();
        cursor.refreshBuffer();
        var acpt = f.exec("idactividad");
        if (acpt) {
        	cursor.commitBuffer();
		var q = new FLSqlQuery("informexunta");
        	q.setValueParam("actividadlaboral", 1);

		var rptViewer = new FLReportViewer();
        	rptViewer.setReportTemplate("xunta");
	        rptViewer.setReportData(q);
        	rptViewer.renderReport();
	        rptViewer.exec();
	}
}

