#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: BACKUP                                                 #
# Grupo..............: GDMTEST                                                #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Transmite mksysb en formato ISO.                       #
# Nombre del programa: trmksysb.sh                                            #
# Nombre del JOB.....: TRMKSYSB                                               #
# Solicitado por.....: Cristian Larrosa                                       #
# Descripcion........:                                                        #
# Modificacion.......: 06/10/2009                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA="${1}"
export SERVDESTINO="${2}"
export FSDESTINO="${3}"
export NOMBRE="trmksysb"
export SERVIDOR="`uname -n`"
export PATHAPL="/tecnol/backups"
export PATHLOG="${PATHAPL}/log"
export PATHBKP="/mkcd/cd_images"
export LOGBACKUP="${PATHLOG}/${NOMBRE}.${FECHA}.log"
export FPATH=/tecnol/funciones

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
Enviar_A_Log "INICIO - Comienza la transferencia a ${SERVDESTINO}." ${LOGBACKUP}
[ $? != 0 ] && exit 3
cd ${PATHBKP}
[ $? != 0 ] && exit 2
VOLUMENES="`ls -1 cd_image*`"
if [ "${VOLUMENES}" ]
then
	for iso in $VOLUMENES
	do
		/tecnol/util/safe_scp.sh P ${PATHBKP} ${iso} ${SERVDESTINO} /mksysb ${iso}.${SERVIDOR} root system 750
		EXIT=$?
		case ${EXIT} in
			0 )	Enviar_A_Log "AVISO - TRANSFERENCIA DE ${iso} FINALIZO CORRECTAMENTE." ${LOGBACKUP}
				;; 
			* )	Enviar_A_Log "ERROR - NO DETERMINADO DURANTE LA TRANSFERENCIA." ${LOGBACKUP}
				exit 1
				;;
		esac
	done
	cd
	Enviar_A_Log "AVISO - DESMONTANDO ${PATHBKP}." ${LOGBACKUP}
        unmount ${PATHBKP}
	Enviar_A_Log "AVISO - ELIMINANDO ${PATHBKP}." ${LOGBACKUP}
        rmfs -r ${PATHBKP}
	Enviar_A_Log "FINALIZACION - TRANSFERENCIA DE MKSYSB FINALIZO CORRECTAMENTE." ${LOGBACKUP}
        exit 0
else
 	Enviar_A_Log "ERROR - NO HAY ISO GENERADAS." ${LOGBACKUP}
	Enviar_A_Log "FINALIZACION - FINALIZO CON ERRORES LA TRANSFERENCIA." ${LOGBACKUP}
	exit 4
fi
