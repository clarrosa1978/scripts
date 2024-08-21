#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: BACKUP                                                 #
# Grupo..............: DIARIO                                                 #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Ejecutar backups predefinidos en Dataprotector.        #
# Nombre del programa: omniback.sh                                            #
# Nombre del JOB.....: CPXXXXXX                                               #
# Solicitado por.....: Cristian Larrosa                                       #
# Descripcion........: Recibe como parametro la fecha de planificacion,el     #
#                      datalist creado en Dataprotector.                      #
#                      Dataprotector.                                         #
# Modificacion.......: 31/05/2007                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA=${1}
export DATALIST=${2}
export MODO=${3}
export SERVIDOR="`echo ${DATALIST} | awk -F'-' ' { print $1 } '`"
export NOMBRE="omniback"
export PATHAPL="/tecnol/backups"
export PATHLOG="${PATHAPL}/log"
export PROGRAMA="/usr/omni/bin/omnib"
export LOGBACKUP="${PATHLOG}/backup.${SERVIDOR}.${FECHA}.log"
export MENSAJE="LA COPIA ${DATALIST} EN ${SERVIDOR}"

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
Enviar_A_Log "INICIO - Comienza ${MENSAJE}." ${LOGBACKUP}
[ $? != 0 ] && exit 3
if [ -x ${PROGRAMA} ]
then
	${PROGRAMA} -datalist ${DATALIST} -mode ${MODO}
	EXIT=$?
	case ${EXIT} in
	0 ) 	Enviar_A_Log "FINALIZACION - ${MENSAJE} FINALIZO CORRECTAMENTE." ${LOGBACKUP}
	   	exit 0
		;; 
	5|12 )	Enviar_A_Log "AVISO - NO HAY DRIVES LIBRES, SE REARRANCA EL BACKUP." ${LOGBACKUP}
		exit 5
		;;
	* )	Enviar_A_Log "ERROR - NO DETERMINADO DURANTE EL BACKUP ${PROGRAMA}." ${LOGBACKUP}
		exit 1
		;;
	esac
else
 	Enviar_A_Log "ERROR - NO HAT PERMISOS DE EJECUCION PARA EL PROGRAMA ${PROGRAMA}." ${LOGBACKUP}
	Enviar_A_Log "FINALIZACION - ${MENSAJE} FINALIZO CON ERRORES." ${LOGBACKUP}
	exit 88
fi
