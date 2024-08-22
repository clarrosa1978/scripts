###############################################################################
# Aplicacion.........: STOREFLOW-XXX                                          #
# Grupo..............: CIERRE-XXX ( XXX = Numero de Sucursal )                #
# Autor..............: TECNOLOGIA (C.A.S)                                     #
# Objetivo...........: Realizar el cierre de la sucursal                      #
# Nombre del programa: sfcierr070.ksh                                         #
# Nombre del JOB.....: SFXXXCI070     ( XXX = Numero de Sucursal )            #
# Descripcion........: Realiza la conciliacion de ventas                      #
# Modificacion.......: 2003/09/12                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################



export SFSW_TMP="/sfctrl/tmp"
export SFSW_LOGCTRLM=/tecnol/cierresuc/log
export SFSW_USU="/"
export SFSW_CIERRE=/tecnol/cierresuc/sql
export QUERY=sfcierr070.sql
export SFSW_SUC=$1
export JOBNAME=$2
export FECHA=$4
export LOG=$SFSW_LOGCTRLM/$JOBNAME.${SFSW_SUC}.${FECHA}

###############################################################################
###                         Paramentros  CTRL-M                             ###
###############################################################################

if [ $# -ne 4 ]
 then
  RC=90
  if [ ! -z "$JOBNAME" -a ! -z "$ORDERID" ]
   then
    echo "`date '+%Y%m%d-%H%M%S'` Error $RC - Cantidad parametros de CTRL-M" \
    | tee -a $LOG
  fi
  exit $RC
 else
  echo "`date '+%Y%m%d-%H%M%S'` Ok - cantidad parametros de CTRL-M" \
  | tee -a $LOG
fi

###############################################################################
###                             Principal                                   ###
###############################################################################
find ${SFSW_LOGCTRLM} -name "$SFSW_LOGCTRLM/$JOBNAME.${SFSW_SUC}.*" -mtime +7 -exec rm {} \;

if [ -f $SFSW_TMP/sfcierr070.${SFSW_SUC}.tmp ]
 then 
  rm $SFSW_TMP/sfcierr070.${SFSW_SUC}.tmp
  if [ $? -ne 0 ]
   then 
    RC=50
    echo "`date '+%Y%m%d-%H%M%S'` Error $RC - al borrar sfcierr070.tmp" \
    | tee -a $LOG
    exit $RC
   else
    echo "`date '+%Y%m%d-%H%M%S'` Ok - archivo sfcierr070.tmp borrardo" \
    | tee -a $LOG
  fi
fi

if [ ! -r $SFSW_CIERRE/$QUERY ]
 then
  RC=10
  echo "`date '+%Y%m%d-%H%M%S'` Error $RC $JOBNAME - $QUERY sin permiso" \
  | tee -a $LOG
 else
  echo "`date '+%Y%m%d-%H%M%S'` Ok - permisos $QUERY" | tee -a $LOG
	sqlplus -s $SFSW_USU > $LOG 2>&1 <<-EOFSQL
	@$SFSW_CIERRE/$QUERY $SFSW_SUC
	EOFSQL
  if [ $? -ne 0 ]
   then
    RC=20
    echo "`date '+%Y%m%d-%H%M%S'` Error $RC $JOBNAME - ejecucion $QUERY" \
    | tee -a $LOG
   else
    echo "`date '+%Y%m%d-%H%M%S'` Ok - $QUERY ejecucion" | tee -a $LOG
    if [ `grep -c "^ORA" $LOG` -ne 0 ]
     then 
      RC=30
      echo "`date '+%Y%m%d-%H%M%S'` Error $RC $JOBNAME - ejecucion $QUERY" \
      | tee -a $LOG
     else
      echo "`date '+%Y%m%d-%H%M%S'` Ok - $QUERY finalizo con leyenda OK" \
      | tee -a $LOG
      if [ ! -f $SFSW_TMP/sfcierr070.${SFSW_SUC}.tmp ]
       then
        RC=40
        echo "`date '+%Y%m%d-%H%M%S'` Error $RC $JOBNAME - != sfcierr070.tmp" \
        | tee -a $LOG
       else
        echo "`date '+%Y%m%d-%H%M%S'` Ok - spool sfcierr070.${SFSW_SUC}.tmp generado" \
        | tee -a $LOG
      fi
    fi
  fi
fi 

echo "#----------- Fin job: $JOBNAME con status $RC -----------#" | tee -a $LOG
exit $RC
