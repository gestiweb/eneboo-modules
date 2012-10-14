HOME_FACTURALUX = /usr/local/facturalux
HOME_FLPROTOTIPO = ${HOME_FACTURALUX}/flprototipo-formacion

SCRIPTS = masteractividadeslaborales.qs \
          mastercursos.qs \
          masterpersonas.qs \
          masterdirpersonas.qs \
          mastertlfpersonas.qs \
          mastersectoreslaborales.qs \
          masteresalumnode.qs \
          masteresprofesorde.qs \
          formacioninformescursos.qs \
          formacioninformesxunta.qs \
          formacioninformesalumnosporcurso.qs \
          formacioncertificadosalumno.qs \
          formacioncertificadoscurso.qs

install:
	scp $(SCRIPTS) root@auden:$(HOME_FLPROTOTIPO)/share/facturalux/scripts

uninstall:
#	rm 
#	$(MAKE) -C $(HOME_XCERELL)/src clean
#	rm -f bin/xcerell Makefile~
#	rm -f ../Resultados-xcerell/fich_*.txt

