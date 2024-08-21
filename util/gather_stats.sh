set -x
/****************************************************************************
# Nombre:       gather_stats_puntadm.sh
# Autor:        PANU
# Fecha:        08/09/2009
#
#
#****************************************************************************/

FECHA=$1           #fecha de proceso
SCHEMA=$2          #esquema a tomar estadisticas	

if [ "$#" -ne 2 ]
then
    echo "Usage $SCRIPTSH AAAAMMDD SCHEMA"
    exit  2
fi

SCRIPTSH=gather_stats_puntadm.sh
LOGSCRIPT=/tecnol/util/log/gather_stats.$SCHEMA.${FECHA}.log
USUARIO=/
SQLGEN=/tecnol/util/sql/gather_stats.sql
SQLLOG=/tecnol/util/log/gather_stats.$SCHEMA.$FECHA.lst

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

exit 0
