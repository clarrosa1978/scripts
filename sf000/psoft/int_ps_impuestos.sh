#############################################################################
# Script:       int_ps_impuestos.sh
# Autor:        Laura Fortunelli
# Fecha:        27/02/2004
#
# Descripcion: Carga la tabla temporal T6240300_TMP
#
#
# Parametros: Fecha de procesamiento yyyymmdd
#
#############################################################################
        #Nombre del script
SCRIPTSH=int_ps_impuestos.sh
          #Log del script
LOGSCRIPT=/tecnol/psoft/log/int_ps_impuestos.log

        #Usuario de la  BD sf
USUARIO=/

        #CTL que Carga la tabla T6240300_TMP
CTLGEN=/tecnol/psoft/sql/int_ps_impuestos.ctl


FECHA=$1        #Parametro

        #CTL archivo de Plano por dia
CTLARCH=/sfctrl/data/descarga/BISF06_01_"$FECHA".txt
        #CTL archivo de log
CTLLOG=/sfctrl/tmp/BISF06_01_"$FECHA".log
        #CTL archivo BAD
CTLBAD=/sfctrl/tmp/BISF06_01_"$FECHA".bad



if [ "$#" -ne 1 ]
then
        echo "Usage $SCRIPTSH AAAAMMDD"
        exit  2
fi


#SQLLOAD  para cargar la tabla BT_STOCK_DIARIA

echo `date '+%d/%m/%Y %H:%M:%S'` "$SCRIPTSH: Se carga la tabla T6240300_TMP" >> $LOGSCRIPT

sqlldr  userid = "$USUARIO", control = "$CTLGEN", data = "$CTLARCH", log = "$CTLLOG", bad = "$CTLBAD" 




STATUS="$?"
if [ "$STATUS" != 0 ]
then
        echo `date '+%d/%m/%Y %H:%M:%S'`"$SCRIPTSH: ERROR al ejecutar $CTLGEN" >> $LOGSCRIPT
        exit 2
else
        grep 'ORA-' "$CTLLOG"
        STATUS="$?"
        if [ "$STATUS" = 0 ]
        then
                echo `date '+%d/%m/%Y %H:%M:%S'`"$SCRIPTSH: ERROR al ejecutar $CTLGEN" >> $LOGSCRIPT
                exit  2

        fi
fi
 echo `date '+%d/%m/%Y %H:%M:%S'`"$SCRIPTSH: FINALIZACION" >> $LOGSCRIPT
