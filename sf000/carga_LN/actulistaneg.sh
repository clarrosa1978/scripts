#! /bin/ksh

################################################################################
#                                            Fernandez Garay Jorge - 08/2004
# actulistaneg.sh
#
# Este prog. es disparado por el JOB 'ACTU_NOVLN', de la cadena CARGA_NOV_LN
# de CONTROL-M, que corre en sucursales.
#
# Ejecuta un procedimiento SQL, para Actualizar la tabla de Lista Negra de
# StoreFlow, con las Novedades de Lista Negra de la fecha, tomando como
# entrada, las filas de Noved. cargaddas con Sql Loader a una tabla tempo-
# raria.
#
################################################################################

set -x

export EXIT_STAT=''

sqlplus / @/tecnol/carga_LN/actulistaneg.sql
EXIT_STAT="$?"

export ORACLE_ERRORS=''
ORACLE_ERRORS=`cat /sfctrl/tmp/actulistaneg.log|awk ' ( $0 ~ /ORA-/ ) || ( $0 ~ /PLS-/ ) { print $0 } '`

if [ "$EXIT_STAT" -eq 0 ] && [ "$ORACLE_ERRORS" = '' ]
then
         # Determina el Nombre del archivo De Nov de Lista Negra que se acaba de procesar, para
         # comprimirlo y renombrarlo como procesado
         LN_NOV_DIR="/sfctrl/data/carga"
         FILES_TO_PROCESS_LIST=''
         NOVED_LN_FILENAME=''
         export LN_NOV_DIR FILES_TO_PROCESS_LIST NOVED_LN_FILENAME

         # Obtiene La lista de archivos de Noved de Lista Negra sin procesar (sin extension '.proc')
         # ordenados por fecha (los mas viejos, 1ro)

         FILES_TO_PROCESS_LIST=`ls $LN_NOV_DIR|egrep '^novln\.[0-9]+$'|sort -k 1.11,1.14 -k 1.9,1.10 -k 1.7,1.8`
         NOVED_LN_FILENAME=`echo "$FILES_TO_PROCESS_LIST"|awk ' NR == 1 { print $0 } '`

         if [ "$NOVED_LN_FILENAME" != '' ]
         then
                   mv "$LN_NOV_DIR/$NOVED_LN_FILENAME" "$LN_NOV_DIR/$NOVED_LN_FILENAME".proc
                   compress -f "$LN_NOV_DIR/$NOVED_LN_FILENAME".proc
         fi

         exit 0
else
         if [ "$EXIT_STAT" -ne 0 ]
         then
                  echo "\n\n$0: Fallo la ejecucion del sqlplus"
                  echo "Buscar Errores en el log /sfctrl/tmp/actulistaneg.log"
         fi

         if [ "$ORACLE_ERRORS" != '' ]
         then
                  echo "\n\n$0: Termino con error el sql /tecnol/carga_LN/actulistaneg.sql"
                  echo "Buscar los errores en el log /sfctrl/tmp/actulistaneg.log"
         fi

         exit 9
fi
