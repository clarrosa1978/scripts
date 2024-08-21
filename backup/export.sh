#!/usr/bin/ksh
###############################################################################
# Grupo..............: EXPORT                                                 #
# Autor..............: ARAM                                                   #
# Nombre del programa: export.sh                                              #
# Nombre del JOB.....: EXP-GRIDDBA                                            #
# Descripcion........: Realiza un export de la GRIDDBA 			      #
# Modificacion.......: DD/MM/AAAA                                             #
# Parametros.........: Fecha (AAAAMMDD).                                      #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA=${1}
export NOMBRE="export"
export PATHAPL="/tecnol/backups"
export PATHLOG="${PATHAPL}/log"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"
export DESTINATARIO="ADMBASE"
export LOGEXP="${PATHLOG}/griddba.${FECHA}.log"
export ASUNTO="Export GRIDDBA - ${FECHA}"
export MENSAJE="Export GRIDDBA"


###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Borrar
autoload Check_Par
autoload Enviar_A_Log
autoload Enviar_Mail

###############################################################################
###                            Principal                                    ###
###############################################################################
Check_Par 1 $@
[ $? != 0 ] && exit 1
Enviar_A_Log "INICIO - Comienza la ejecucion del Export." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
mknod /export/exp_pipe p
compress < /export/exp_pipe > /export/griddba.dmp.Z &
exp / file=/export/exp_pipe full=Y log=${LOGEXP} direct=y statistics=none buffer=32000000
RESUL=$?
if [ $RESUL != 0 ] && [ $RESUL != 4 ]
then
	Enviar_A_Log "ERROR - Fallo la ejecucion del Export." ${LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERROR." ${LOGSCRIPT}
	Enviar_Mail_DAdjuntos ${DESTINATARIO} "${ASUNTO}" "${MENSAJE} FALLO" "${LOGEXP}"
        exit 1
else
	Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
	rm /export/exp_pipe
	find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +2 -exec rm {} \;
	Enviar_Mail_DAdjuntos ${DESTINATARIO} "${ASUNTO}" "${MENSAJE} TERMINO OK" "${LOGEXP}"
	if [ $? != 0 ]
	then
		Enviar_A_Log "ERROR - Fallo el envio de mail." ${LOGSCRIPT}
		Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
		exit 5
	fi
 	exit 0
fi
