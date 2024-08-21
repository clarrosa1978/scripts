#!/usr/bin/ksh
set -x
###############################################################################
# Aplicacion.........: BACKUP                                                 #
# Grupo..............: NT                                                     #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Copia backup sqlserver a otra ubicaciones.             #
# Nombre del programa: cpbkpfullnt.sh                                         #
# Nombre del JOB.....: CPBKPFULLXXX                                           #
# Descripcion........:                                                        #
###############################################################################


###############################################################################
###                            Variables                                    ###
###############################################################################
export NOMBRE="cpbkpfullnt"
export FECHA="${1}"
export PATHARCH="${2}"
export PATHARCH2="${3}"
export PATHLOG="/tecnol/util/log"
export LOG="${PATHLOG}/${NOMBRE}.${FECHA}.log"

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Check_Par

###############################################################################
###                            Principal                                    ###
###############################################################################
Check_Par 3 $@
[ $? != 0 ] && exit 1
export ARCHIVO="`ls -1 ${PATHARCH}/bk_*_base_${FECHA}.BAK`"
Enviar_A_Log "INICIO - Control de existencia de archivos ${ARCHIVO} en ${PATHARCH}." ${LOG}
if [ ! -d "${PATHARCH}" ] || [ ! -d "${PATHARCH2}" ]
then
	Enviar_A_Log "ERROR - NO existe el directorio ${PATHARCH} o ${PATHARCH2} - Verificar."${LOG}
	Enviar_A_Log "FIN - Finalizacion con ERROR." ${LOG}
	exit 6
fi
if [ "${ARCHIVO}" ]
then
	for I in ${ARCHIVO}
	do
     		Enviar_A_Log "PROCESO - Copio el archivo ${I} al /backup_nt." ${LOG}
     		cp -p ${I} ${PATHARCH2}
     		if [ $? -ne 0 ]
     		then
			Enviar_A_Log "PROCESO - La copia delarchivo ${I} fallo a ${PATHARCH2}."${LOG}
                        Enviar_A_Log "FIN - Finalizacion con ERROR." ${LOG}
                        exit 1
		fi
	done
	Enviar_A_Log "FIN - Finalizacion OK." ${LOG}
	sudo find ${PATHARCH} -name "bk_*" -mtime +2 -exec rm {} \;
	sudo find ${PATHARCH2} -name "bk_*" -mtime +2 -exec rm {} \;
	sudo find ${PATHLOG} -name "${NOMBRE}*.log" -mtime +5 -exec rm {} \;
	exit 0
else
	Enviar_A_Log "ERROR - No existen archivos ${PATHARCH}/*${FECHA}*."${LOG}
	Enviar_A_Log "FIN - Finalizacion con ERROR." ${LOG}
	exit 1
fi
