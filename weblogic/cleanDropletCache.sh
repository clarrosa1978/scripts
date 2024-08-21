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
NOMBRE="cleanDropletCache.sh_${FECHA}"
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
	for NODO in scdigi02:7003 scdigi02:7103 scdigi03:7003 scdigi03:7103 scdigi04:7003 scdigi04:7103 scdigi05:7003 scdigi05:7103
	do
        curl http://$NODO/rest/model/atg/actors/cCleanDropletCache/cleanDropletCache >${ARCHLOG}
        if [ $? != 0 ]
        then
                 Enviar_A_Log "ERROR - Fallo la ejecucion del rest cleanDropletCache." ${LOGSCRIPT}
                 Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                 exit 5

        else
                if [ -s ${ARCHLOG} ]
                then	
			cat ${ARCHLOG}
                        grep  "El servicio CleanDropletCache ejecuto el limpiado de cache." ${ARCHLOG}
                        if [ $? = 0 ]
                        then
                                Enviar_A_Log "AVISO - El borrado de cache termino correctamente." ${LOGSCRIPT}
                                Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
                                find ${PATHLOG} -name "cleanDropletCache.out" -mtime +2 -exec rm {} \;
                                find ${PATHLOG} -name "cleanDropletCache*.log" -mtime +2 -exec rm {} \;	

                	else
		         	Enviar_A_Log "ERROR - Error durante la ejecucion del cleanDropletCache. Verificar." ${LOGSCRIPT}
                               	Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                               	exit 1
					
                        fi

                else
                        Enviar_A_Log "ERROR - No se genero el archivo de log." ${LOGSCRIPT}
                        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                        exit 9
                fi
	done
	fi
else
        Enviar_A_Log "ERROR - No hay permisos de ejecucion para el comando curl." ${LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
        exit 88
fi
