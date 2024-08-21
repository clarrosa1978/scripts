#!/usr/bin/ksh
###############################################################################
# Grupo..............: BACKUP                                                 #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Realizar backup del filesystem.			      #
# Nombre del programa: bkp_fsys_archive.sh                                    #
# Nombre del JOB.....:                                                        #
# Solicitado por.....:                                                        #
# Descripcion........: Realiza un backup archive del filesystem recibido como #
#                      parametro.                                             #
# Modificacion.......: 29/08/2011                                             #
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
export NOMBRE="bkp_fsys_archive"
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
if [ -x /usr/tivoli/tsm/client/ba/bin64/dsmc ]; then
	/usr/tivoli/tsm/client/ba/bin64/dsmc archive "/${FS}/*" > ${LOGSCRIPT}

	RESUL=$?
        if [ $RESUL != 0 ] && [ $RESUL != 4 ]; then
          Enviar_A_Log "ERROR - Fallo la ejecucion del backup archive para ${FS}." ${LOGSCRIPT}
          Enviar_A_Log "FINALIZACION - CON ERROR." ${LOGSCRIPT}
          exit 1
	else
	 Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
	 find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +60 -exec rm {} \;
 	 exit 0
        fi
else
        Enviar_A_Log "ERROR - No hay permisos de ejecucion para el comando dsmc." ${LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
        exit 1
fi
