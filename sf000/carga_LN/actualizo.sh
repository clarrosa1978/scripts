#! /bin/ksh

###############################################################################
#                                                        M. Feldman - 08/2004
# actualizo.sh
#
# Este programa es lanzado por el Job 'LOAD_LN_NOV' de la Aplicacion CONTROL-M
# 'CARGA_NOV_LN' que corre en sucursales, para cargar Novedades de Lista Negra
# en Tablas de StoreFlow.
# Ejecuta un SqlLoad de las Novedades de Lista Negra transmitidas desde el SP9
# en una tabla temporaria
#
# En la 1ra seccion del Programa, se genera una Lista de Archivos de Nov. de
# Lista Negra pendientes de procesamiento (carecen de extension '.proc'),
# ordenados por la fecha de su extension(los mas viejos, 1ro)
#
#                                     Implementacion CONTROL-M: JAF - 08/2004
###############################################################################

set -x

################ SECCION AGREGADA AL SCRIPT DE FELDMAN POR JAF ################
################        PARA IMPLEMENTAR EN CONTROL-M          ################

LN_NOV_DIR="/sfctrl/data/carga"
FILES_TO_PROCESS_LIST=''
export HOSTNAME LN_NOV_DIR FILES_TO_PROCESS_LIST

# A los archivos de Novedades de Lista Negra Procesados, se les agrega la 
# extension '.proc', en el 4to job de la cadena, y se mantienen en linea
# los ultimos 7, comprimidos.

# Obtiene La lista de archivos de Noved de Lista Negra sin procesar (sin extension '.proc')
# ordenados por fecha (los mas viejos, 1ro)

FILES_TO_PROCESS_LIST=`ls $LN_NOV_DIR|egrep '^novln\.[0-9]+$'|sort -k 1.11,1.14 -k 1.9,1.10 -k 1.7,1.8`

if [ "$FILES_TO_PROCESS_LIST" = '' ]
then
        echo "\n\n$0: ERROR. No existe Archivo de Novedades de Lista Negra para Cargar."
        exit 20
fi

export FILES_TO_PROCESS_COUNT=`echo "$FILES_TO_PROCESS_LIST"|wc -w|awk ' { print $1 } '`

# Toma el Archivo de Nov. mas antiguo para procesar (o el de hoy, si no hay pendientes de proceso
export NOVED_LN_FILENAME=''

if [ "$FILES_TO_PROCESS_COUNT" -gt 1 ]
then
          NOVED_LN_FILENAME=`echo "$FILES_TO_PROCESS_LIST"|awk ' NR == 1 { print $0 } '`
else
          NOVED_LN_FILENAME="$FILES_TO_PROCESS_LIST"
fi

# Extirpa la extension con la fecha, del Nombre del archivo a procesar
# para pasarlo a la seccion del programa de Feldman.
export STRIP_DATE=`expr "$NOVED_LN_FILENAME" : '^novln\.\([0-9][0-9]*\)$'`


################## FIN DE LA SECCION AGREGADA POR JAF ########################

FECHA="$STRIP_DATE"
#FECHA=$1
PATHDATA=/sfctrl/data/carga
PATHLOG=/sfctrl/tmp
PATHCTL=/tecnol/carga_LN
PATHSQL=/tecnol/carga_LN
BASE=/

if [ -f $PATHLOG/actualizo.$FECHA.log ]
then
         # Borra el log de una corrida previa
         rm -f $PATHLOG/actualizo.$FECHA.log
fi

sqlplus $BASE @/tecnol/carga_LN/truncar.sql 

sqlldr $BASE control=$PATHCTL/actualizo.ctl log=$PATHLOG/actualizo.$FECHA.log data=$PATHDATA/novln.$FECHA rows=10000  direct=no 
EST="$?"
if [ "$EST" != 0 ]
then
      echo "ERROR al intentar ejecutar el Sqlldr del Archivo de Novedades de Lista Negra"
      echo "Buscar errores en el log $PATHLOG/actualizo.$FECHA.log"
      exit 15
else
      if [ ! -f $PATHLOG/actualizo.$FECHA.log ]
      then
               echo "\n\nLa ejecucion del SQLLdr NOGENERO EL LOG $PATHLOG/actualizo.$FECHA.log, para verificar."
               exit 30
      fi

      export INPUT_ROWS=''
      export INSERTED_ROWS=''
      export ORACLE_ERRORS=''
      INPUT_ROWS=`cat $PATHLOG/actualizo.$FECHA.log|egrep '^Total logical records read:[ ][ ]*[0-9][0-9]*$'|awk ' { print $NF } '` 
      INSERTED_ROWS=`cat $PATHLOG/actualizo.$FECHA.log|egrep '^[ ][ ]*[0-9][0-9]*[ ][ ]*Rows successfully loaded.$'|awk ' { print $1 } '` 
      ORACLE_ERRORS=`cat $PATHLOG/actualizo.$FECHA.log|awk ' $0 ~ /ORA-/ { print $0 } '`

      if [ "$ORACLE_ERRORS" = '' ] && [ "$INPUT_ROWS" != '' ] && [ "$INSERTED_ROWS" != '' ] && [ "$INPUT_ROWS" = "$INSERTED_ROWS" ]
      then
                echo "\n\nSQL Load COMPLETADO OK"
                exit 0
      else
                echo "\n\nERROR en el resultado del sqlldr de tabla de Novedades de lista Negra."
                echo "Buscar errores en el log $PATHLOG/actualizo.$FECHA.log"
                exit 15
      fi

fi
