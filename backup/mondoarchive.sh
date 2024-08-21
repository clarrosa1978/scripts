#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: BACKUP                                                 #
# Grupo..............:                                                        #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Realiza un backup full del sistema.                    #
# Nombre del programa: mondoarchive.sh                                        #
# Nombre del JOB.....: XXXXXXXX                                               #
# Solicitado por.....: Cristian Larrosa                                       #
# Descripcion........: Recibe como parametro la fecha y tipo de backup.       #
# Modificacion.......: 07/08/2008                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA=${1}
export TIPO=${2}
export PATHBKP=${3}
export NOMBRE="mondoarchive"
export PATHAPL="/tecnol/backups"
export PATHLOG="${PATHAPL}/log"
export EXCLUDEFS="/sfctrl /sts /backup /proc /u02/oradata"
export LOGBACKUP="${PATHLOG}/${NOMBRE}.${FECHA}.log"
export IMGNOM="`hostname`"
export PROGRAMA="/usr/sbin/mondoarchive"
export FPATH=/tecnol/funciones
export STATUS=1

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Borrar
autoload Check_Par
autoload Enviar_A_Log


###############################################################################
###                            Principal                                    ###
###############################################################################
Check_Par 3 $@
[ $? != 0 ] && exit 1
Enviar_A_Log "INICIO - Comienza backup." ${LOGBACKUP}
[ $? != 0 ] && exit 3
if [ -x ${PROGRAMA} ]
then
	Enviar_A_Log "PROCESO - Backup tipo ${TIPO}." ${LOGBACKUP}
	case ${TIPO} in
		nfs|NFS)	${PROGRAMA} -On nfs://${PATHBKP} -N -E "${EXCLUDEFS}" -p ${IMGNOM} -s 4480m
				STATUS=$?
				;;

		disk|DISK)	${PROGRAMA} -Oi -d ${PATHBKP} -N -E "${EXCLUDEFS}" -p ${IMGNOM} -s 4480m
				STATUS=$?
				;;

		*)		Enviar_A_Log "ERROR - Tipo de backup no contemplado." ${LOGBACKUP}
				exit 5
				;;
	esac
	if [ ${STATUS} != 0 ]
	then
		Enviar_A_Log "ERROR - El backup finalizo con status ${STATUS}." ${LOGBACKUP}
		Enviar_A_Log "FINALIZACION - EL BACKUP FINALIZO CON ERRORES." ${LOGBACKUP}
		exit 5
	else
		Enviar_A_Log "FINALIZACION - El backup finalizo correctamente." ${LOGBACKUP}
		umount ${PATHBKP}
		find ${PATHLOG} -name "${NOMBRE}*.log" -mtime +30 -exec rm {} \;
                exit 0
	fi
else
      	Enviar_A_Log "ERROR - No hay permisos de ejecucion para el programa ${PROGRAMA}." ${LOGBACKUP}
      	Enviar_A_Log "FINALIZACION - EL BACKUP FINALIZO CON ERRORES." ${LOGBACKUP}
      	exit 88
fi
