HOME_FACTURALUX = /usr/local/facturalux
HOME_FLPROTOTIPO = ${HOME_FACTURALUX}/flprototipo-formacion

QUERIES = actividadeslaborales.qry \
          cursos.qry \
          personas.qry \
          certificado.qry \
          sectoreslaborales.qry \
          alumnosxcurso.qry \
          informexunta.qry \
          alumnos.qry \
          cursosxalumno.qry

install:
	scp $(QUERIES) root@auden:$(HOME_FLPROTOTIPO)/share/facturalux/queries

uninstall:
#	rm 
#	$(MAKE) -C $(HOME_XCERELL)/src clean
#	rm -f bin/xcerell Makefile~
#	rm -f ../Resultados-xcerell/fich_*.txt

