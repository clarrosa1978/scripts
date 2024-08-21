#!/usr/bin/ksh
###############################################################################
# Grupo..............: BACKUP                                                 #
# Autor..............: Gustavo Alonso                                         #
# Objetivo...........: Realizar backup historio del filesystem /rollosuc.     #
# Nombre del programa: bkp_fsys_rollos_archive.sh                             #
# Nombre del JOB.....:                                                        #
# Solicitado por.....:                                                        #
# Descripcion........: Realiza un backup archive del filesystem recibido como #
#                      parametro.                                             #
# Modificacion.......: 23/03/2023                                             #
#          -Se cambia la fecha de depuracion de los archivos a +180 dias.     #
# Parametros.........: Fecha (AAAAMMDD).                                      #
#                      Filesystem.                                            #
#                                                                             #
# Tipo de errores de salida :                                                 #
#                          1: Error.                                          #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA=${1}
export FS=${2}
export HORA="`date +%H%M`"
export NOMBRE="bkp_fsys_rollosdigi_archive"
export PATHAPL="/tecnol/backups"
export PATHLOG="${PATHAPL}/log"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FS}.${FECHA}.${HORA}.log"

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
Enviar_A_Log "INICIO - Comienza la ejecucion de archivee para ${FS}." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
if [ -x /usr/bin/dsmc ]; then
	sudo /usr/bin/dsmc archive "/${FS}/*" -subdir=yes -description="Backup RollosDigi Fecha "${FECHA}"" > ${LOGSCRIPT}
	RESUL=$?
        if [ $RESUL != 0 ] && [ $RESUL != 4 ]; then
          Enviar_A_Log "ERROR - Fallo la ejecucion del backup archive para ${FS}." ${LOGSCRIPT}
          Enviar_A_Log "FINALIZACION - CON ERROR." ${LOGSCRIPT}
          exit 1
	else
	 Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
	 sudo find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +60 -exec rm {} \;
	 sudo find /${FS} -type f -name "rollo.*" -mtime +180 -exec rm -f {} \;	
 	 exit 0
        fi
else
        Enviar_A_Log "ERROR - No hay permisos de ejecucion para el comando dsmc." ${LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
        exit 1
fi
