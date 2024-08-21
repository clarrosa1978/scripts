#!/usr/bin/ksh
###############################################################################
# Apliacion..........: BACKUP                                                 #
# Grupo..............: OSIRIS                                                 #
# Autor..............: CFL                                                    #
# Objetivo...........: Realizar backup del filesystem.                        #
# Nombre del programa: bkp_fsys.sh                                            #
# Nombre del JOB.....: BKPSLNXJA05FS-I                                        #
# Solicitado por.....:                                                        #
# Descripcion........: Realiza un backup full/incremental del filesystem de   #
#                      slnxjas05.                                             #
# Modificacion.......: 04/03/2024                                             #
# Parametros.........: Fecha (AAAAMMDD).                                      #
#                      Jobname en veeam                                       #
# Tipo de errores de salida :                                                 #
#                          1: Error.                                          #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA=${1}
export VEEAMJOB=${2}
export HORA=`date +'%H:%M'`
export NOMBRE="bkp_fsys"
export PATHAPL="/tecnol/backups"
export PATHLOG="${PATHAPL}/log"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${VEEAMJOB}.${FECHA}.${HORA}.log"
export FPATH="/tecnol/funciones"
export VEEAMLOG="/var/log/veeam/Backup/${VEEAMJOB}"

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Borrar
autoload Check_Par
autoload Enviar_A_Log

###############################################################################
###                            Principal                                    ###
###############################################################################
Check_Par 2 $@
[ $? != 0 ] && exit 1
Enviar_A_Log "INICIO - Comienza la ejecucion del backup full/incremental de filesystem." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
if [ -x /usr/sbin/veeamconfig ]
then
        sudo veeamconfig job list | grep ${VEEAMJOB}
        if [ $? = 0 ]
        then
                sudo veeamconfig job start --name "${VEEAMJOB}" 1> $PATHAPL/$VEEAMJOB.tmp 2> $PATHAPL/$VEEAMJOB.err
                if [ -s $PATHAPL/$VEEAMJOB.tmp ]
                then
                        export SESSION_ID=`grep ID $PATHAPL/$VEEAMJOB.tmp | awk  '{print $3}' | sed 's/\[//' | sed 's/\]//' | sed 's/\.//'`
                        export LOGDIR=`grep log $PATHAPL/$VEEAMJOB.tmp | awk  '{print $4}' | sed 's/\[//' | sed 's/\]//' | sed 's/\.//'`
                        export LOGFILE=$LOGDIR/Job.log
                else
                        cat $PATHAPL/$VEEAMJOB.err
                        Enviar_A_Log "Error - No se genero el archivo $PATHAPL/$VEEAMJOB.tmp. Verificar permisos de escritura sobre el directorio." ${LOGSCRIPT}
                        exit 1
                fi
                # Verifica si existe otro job en ejecucion.
                if [ -s $PATHAPL/$VEEAMJOB.err ]
                then
                        STATUS=`grep Error $PATHAPL/$VEEAMJOB.err`
                        sudo veeamconfig job delete --id $SESSION_ID
                fi

                spaces_run=`ps -ef | grep veeamjobman | grep -v grep | awk '{print $2}'`
                while [ $spaces_run > 0 ]
                do
                sleep 20;
                spaces_run=`ps -ef | grep veeamjobman | grep -v grep | awk '{print $2}'`
                done

                export STATUS=`sudo veeamconfig session info --id $SESSION_ID | grep State | awk  '{print $2}'`
                if [ $STATUS = 'Warning' ]
                then
                        export WARN_MSG=`grep "Failed to backup" $LOGFILE | awk '{print $7,$8,$9,$10}' | sed 's/--asyncNtf:--wn://'`
                        Enviar_A_Log "WARNING - FINALIZACION CON ADVERTENCIA- $STATUS:            $WARN_MSG" ${LOGSCRIPT}
                        Enviar_A_Log "FINALIZACION - CON WARNING." ${LOGSCRIPT}
                        cat $PATHAPL/$VEEAMJOB.err
                        rm -f $PATHAPL/$VEEAMJOB.tmp $PATHAPL/$VEEAMJOB.err
                        exit 2
                fi

                if [ $STATUS = 'Failed' ]
                then
                        Enviar_A_Log "ERROR - Fallo la ejecucion Job $VEEAMJOB $STATUS. Revisar log para mas detalles." ${LOGSCRIPT}
                        Enviar_A_Log "FINALIZACION - CON ERROR." ${LOGSCRIPT}
                        cat $PATHAPL/$VEEAMJOB.err
                        rm -f $PATHAPL/$VEEAMJOB.tmp $PATHAPL/$VEEAMJOB.err
                        exit 1
                fi

                if [ $STATUS = 'Success' ]
                then
                        Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
                        sudo veeamconfig session info --id $SESSION_ID > $PATHAPL/$VEEAMJOB.log
                        cat $PATHAPL/$VEEAMJOB.log
                        find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +15 -exec rm {} \;
                        sudo find ${VEEAMLOG} -type f -mtime +15 -exec rm -fr {} \;
                        rm -f $PATHAPL/$VEEAMJOB.tmp $PATHAPL/$VEEAMJOB.err $PATHAPL/$VEEAMJOB.log
                        exit 0
                fi
        else
                echo "Verificar que el servicio de veeam este levantando o que exista el Jobname ${VEEAMJOB} en el ntsveeambkp."
                rm -f $PATHAPL/$VEEAMJOB.tmp $PATHAPL/$VEEAMJOB.err
                exit 1
        fi
else
    echo "No existe el comando veeamconfig. Verificar que este instalado el agente de veeam."
    exit 1
fi
