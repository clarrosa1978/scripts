#!/usr/bin/ksh
set -x
###############################################################################
# Aplicacion.........: BACKUP                                                 #
# Grupo..............: NT                                                     #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Copia backup sqlserver a otra ubicaciones.             #
# Nombre del programa: cpbkpfullnt.sh                                         #
# Nombre del JOB.....: CPBKPLOGXXX                                            #
# Descripcion........:                                                        #
###############################################################################


###############################################################################
###                            Variables                                    ###
###############################################################################
export NOMBRE="cpbkplognt"
export FECHA="${1}"
export PATHARCH="${2}"
export PATHARCH2="${3}"
export PATHLOG="/tecnol/backup/log"
export LOG="${PATHLOG}/${NOMBRE}.${FECHA}.log"
export HOST=`uname -n | sed 's/suc//' | sed 's/c$//'`
if [ ${HOST} -lt 100 ]
then
        NTSHOST="nts0${HOST}"
else
        NTSHOST="nts${HOST}"
fi


###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Check_Par

###############################################################################
###                            Principal                                    ###
###############################################################################
Check_Par 3 $@
[ $? != 0 ] && exit 1
df -h | grep sqlbackup
if [ $? != 0 ]
then
	sudo mount -t cifs -o username=backupsqldigital,password=rvoR.8265 //${NTSHOST}/sqlbackups$ /sqlbackup
	if [ $? != 0 ]
	then
        	Enviar_A_Log "ERROR - No se pudo montar el cifs del server ${NTSHOST} - Verificar."${LOG}
       		Enviar_A_Log "FIN - Finalizacion con ERROR." ${LOG}
        	exit 6
	fi
fi

export ARCHIVO="`ls -1 ${PATHARCH}/bk_*_log_*_??????.BAK`"
Enviar_A_Log "INICIO - Control de existencia de archivos ${ARCHIVO} en ${PATHARCH}." ${LOG}
if [ ! -d "${PATHARCH}" ] || [ ! -d "${PATHARCH2}" ]
then
	Enviar_A_Log "ERROR - NO existe el directorio ${PATHARCH} o ${PATHARCH2} - Verificar."${LOG}
	Enviar_A_Log "FIN - Finalizacion con ERROR." ${LOG}
	exit 6
fi
if [ "${ARCHIVO}" ]
then
	Enviar_A_Log "PROCESO - Copio archivos de backups log al /backup_nt." ${LOG}
     	rsync -av ${PATHARCH}/bk_*_log_*_??????.BAK ${PATHARCH2}
     	if [ $? -ne 0 ]
     	then
		Enviar_A_Log "PROCESO - Fallo la copia de backups log a ${PATHARCH2}."${LOG}
                Enviar_A_Log "FIN - Finalizacion con ERROR." ${LOG}
                exit 1
	else
		Enviar_A_Log "FIN - Finalizacion OK." ${LOG}
		find ${PATHLOG} -name "${NOMBRE}*" -mtime +15 -exec rm {} \;
		find ${PATHARCH} -name "bk_*" -mtime +2 -exec rm {} \;
		find ${PATHARCH2} -name "bk_*" -mtime +2 -exec rm {} \;
		exit 0
	fi
else
	Enviar_A_Log "ERROR - No existen archivos ${PATHARCH}/bk_*_log_*_??????.BAK."${LOG}
	Enviar_A_Log "FIN - Finalizacion con ERROR." ${LOG}
	exit 1
fi
