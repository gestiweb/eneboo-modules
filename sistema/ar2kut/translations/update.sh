#!/bin/sh
#***************************************************************************
#                                 update.sh
#                             -------------------
#    begin                : sab dic 23 2006
#    copyright            : (C) 2006 by InfoSiAL S.L.
#    email                : mail@infosial.com
#***************************************************************************

#***************************************************************************
#*                                                                         *
#*   This program is free software; you can redistribute it and/or modify  *
#*   it under the terms of the GNU General Public License as published by  *
#*   the Free Software Foundation; either version 2 of the License, or     *
#*   (at your option) any later version.                                   *
#*                                                                         *
#*************************************************************************** 

MODULO=$(ls ../*.mod)

if [ "$MODULO" == "" ]
then
	exit 0
fi

echo -e "PREFIX =\n" > ./translations.pro
echo -e "ROOT =\n" >> ./translations.pro
echo -e "INCLUDE_PGSQL = \n" >> ./translations.pro
echo -e "LIB_PGSQL =\n" >> ./translations.pro
echo -e "\n" >> ./translations.pro

TABLAS=$(find .. -name "*.mtd" -printf "%p ")
CONSULTAS=$(find .. -name "*.qry" -printf "%p ")
CABECERAS=$(find .. -name "*.h" -printf "%p ")
FUENTES=$(find .. -name "*.cpp" -printf "%p ")
FORMULARIOS=$(find .. -name "*.ui" -printf "%p ")
SCRIPTS=$(find .. -name "*.qs" -printf "%p ")


echo "HEADERS = $MODULO $TABLAS $CONSULTAS $CABECERAS $SCRIPTS" >> ./translations.pro
echo "SOURCES = $FUENTES" >> ./translations.pro
echo "FORMS = $FORMULARIOS" >> ./translations.pro

NOMBRE_MODULO=$(ls ../*.mod | sed "s/\.\.\/\(.*\)\.mod/\1/")

echo -e "TRANSLATIONS = $NOMBRE_MODULO.es.ts $NOMBRE_MODULO.fr.ts \
$NOMBRE_MODULO.en.ts $NOMBRE_MODULO.de.ts $NOMBRE_MODULO.ca.ts $NOMBRE_MODULO.gl.ts \
$NOMBRE_MODULO.pt.ts $NOMBRE_MODULO.it.ts $NOMBRE_MODULO.untranslated.ts" >> ./translations.pro

lupdate -noobsolete ./translations.pro
rm -fR ./translations.pro
