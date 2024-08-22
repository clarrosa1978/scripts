#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: UTILIDADES                                             #
# Grupo..............: DATABASE                                               #
# Autor..............: ARAM                                                   #
# Nombre del programa: gather_stats.sh                                        #
# Nombre del JOB.....: DEPURATRC                                              #
# Solicitado por.....: Panuccio Claudio                                       #
# Descripcion........: Esquema para tomar estadisticaspara.                   #
# Solicitado por.....: Administracion DB                                      #
# Creacion...........: 19/09/2011                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################

FECHA=$1           #fecha de proceso
SCHEMA=$2          #esquema a tomar estadisticas
LOGSCRIPT="/tecnol/util/log/gather_stats.$SCHEMA.${FECHA}.log"
USUARIO="/ as sysdba"
SQLGEN="/tecnol/util/sql/gather_stats.sql"
SQLLOG="/tecnol/util/log/gather_stats.$SCHEMA.$FECHA.lst"

###############################################################################
###                            Principal                                    ###
###############################################################################

if [ "$#" -ne 2 ]
then
    exit  2
fi

echo `date '+%d/%m/%Y %H:%M:%S'` "$SCRIPTSH: Inicio" >> $LOGSCRIPT
sqlplus "$USUARIO" @"$SQLGEN" ${SCHEMA} "$SQLLOG"

STATUS="$?"
 if [ "$STATUS" != 0 ]
 then
      echo `date '+%d/%m/%Y %H:%M:%S'` "$SCRIPTSH: ERROR al ejecutar $SQLGEN" >> $LOGSCRIPT
      exit 2
 else
      grep 'ORA-' "$SQLLOG"
     STATUS="$?"
  if [ "$STATUS" = 0 ]
  then
          echo `date '+%d/%m/%Y %H:%M:%S'` "$SCRIPTSH: ERROR al ejecutar $SQLGEN" >> $LOGSCRIPT
          exit  2
      fi
 fi
echo `date '+%d/%m/%Y %H:%M:%S'` "$SCRIPTSH: Finalizacion" >> $LOGSCRIPT
find /tecnol/util/log -name "gather_stats.$SCHEMA.*" -mtime +30 -exec rm {} \;
exit 0
