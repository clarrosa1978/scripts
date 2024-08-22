#!/bin/ksh
###############################################################################
# Aplicacion.........: STOREFLOW                                              #
# Grupo..............: APERTURA-ZE000                                         #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Ejecutar el programa apeempr.                          #
# Nombre del programa: apeempr.sh                                             #
# Nombre del JOB.....: APEEMPR                                                #
# Descripcion........: Abre la empresa de SF                                  #
# Modificacion.......: 11/04/2006                                             #
###############################################################################
 
set -x
 
###############################################################################
###                            Variables                                    ###
###############################################################################
 
export FECHA=${1}
export EMPRESA=${2}
export PROGRAMA="apeempr"
export PATHAPL="/sfctrl"
export PATHPRG="${PATHAPL}/bin"
export PATHLOG="/tecnol/apertura-sf/log"
export LOGPRG="${PATHAPL}/l/lclog"
export LOGSCRIPT="${PATHLOG}/${PROGRAMA}.${FECHA}.log"
 
###############################################################################
###                            Funciones                                    ###
###############################################################################

autoload Check_Par
autoload Enviar_A_Log

###############################################################################
###                            Principal                                    ###
###############################################################################

Check_Par 2 $@
[ $? != 0 ] && exit 1
Enviar_A_Log "INICIO - Comienza la ejecucion." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
if [ -x ${PATHPRG}/${PROGRAMA} ]
then
	${PATHPRG}/${PROGRAMA} ${EMPRESA} >/dev/null
	if [ $? != 0 ]
	then 
		Enviar_A_Log "ERROR - Error durante la ejecucion del programa ${PROGRAMA}." ${LOGSCRIPT}
                Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
  		exit 5
 	else 
		if [ -s ${LOGPRG} ]
		then
	 		if [ `grep -c "apeempr: Terminaci\"n correcta de la apertura de empresa" ${LOGPRG}` = 1 ]
			then
				Enviar_A_Log "AVISO - Ejecucion del programa ${PROGRAMA} exitosa." ${LOGSCRIPT}
				Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
				find ${PATHLOG} -name "${PROGRAMA}.*.log" -mtime +7 -exec rm {} \;
				exit 0
			else
				Enviar_A_Log "ERROR - Error durante la ejecucion del programa ${PROGRAMA}." ${LOGSCRIPT}
                		Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                		exit 5
			fi
		else
			Enviar_A_Log "ERROR - No se genero el archivo ${LOGPRG} o tiene size 0." ${LOGSCRIPT} 
                        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                        exit 12
		fi
	fi
else
 	Enviar_A_Log "ERROR - No hay permisos de ejecucion para el programa ${PROGRAMA}." {LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
        exit 88
fi
