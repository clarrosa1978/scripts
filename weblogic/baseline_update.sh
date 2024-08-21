#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: COTODIGITAL                                            #
# Grupo..............: JAVA II                                                #
# Autor..............: Gustavo Alonso                                         #
# Objetivo...........: Ejecucion del indexado a endeca (baseline)             #
# Nombre del programa: baseline_update.sh                                     #
# Nombre del JOB.....: BASELINE_UPDATE                                        #
# Descripcion........:                                                        #
# Modificacion.......: 04/01/2017                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################

FECHA=${1}
NOMBRE="baseline_update_${FECHA}"
PATHLOG="/tecnol/weblogic/log"
LOGSCRIPT="${PATHLOG}/${NOMBRE}.log"
ARCHLOG="${PATHLOG}/${NOMBRE}.out"

###############################################################################
###                            Funciones                                    ###
###############################################################################
. /tecnol/funciones/Borrar
. /tecnol/funciones/Check_Par
. /tecnol/funciones/Enviar_A_Log


autoload Enviar_A_Log
autoload Check_Par
autoload Borrar

###############################################################################
###                            Principal                                    ###
###############################################################################
Check_Par 1 $@
[ $? != 0 ] && exit 1
Enviar_A_Log "INICIO - Comienza la ejecucion." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
if [ -x /usr/bin/curl ]
then
       curl http://scdigi03:7303/rest/model/atg/actors/cRunBaselineUpdate/runBaselineUpdate?password=a3CUcQfCw9RA >${ARCHLOG}
        if [ $? != 0 ]
        then
                 Enviar_A_Log "ERROR - Fallo la ejecucion del backup." ${LOGSCRIPT}
                 Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                 exit 5

        else
                if [ -s ${ARCHLOG} ]
                then	
			cat ${ARCHLOG}
                        grep  "exito" ${ARCHLOG}
                        if [ $? = 0 ]
                        then
                                Enviar_A_Log "AVISO - El baseline_update termino correctamente." ${LOGSCRIPT}
                                Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
                                find ${PATHLOG} -name "baseline_update*.out" -mtime +2 -exec rm {} \;
                                find ${PATHLOG} -name "baseline_update*.log" -mtime +2 -exec rm {} \;	
                                exit 0

                	else
				grep "El proceso estaba en ejecucion" ${ARCHLOG}
				if [ $? = 0 ]
			        then
					Enviar_A_Log "AVIS0 - El proceso baseline_update esta ejecucion. Relanzar en unos minutos." ${LOGSCRIPT}	
					Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                        		exit 5
				else
				        Enviar_A_Log "ERROR - Error durante la ejecucion del baseline. Verificar." ${LOGSCRIPT}
                                	Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                                	exit 1
				fi
					
                        fi

                else
                        Enviar_A_Log "ERROR - No se genero el archivo de log del baseline." ${LOGSCRIPT}
                        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                        exit 9
                fi
	fi
else
        Enviar_A_Log "ERROR - No hay permisos de ejecucion para el comando curl." ${LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
        exit 88
fi
