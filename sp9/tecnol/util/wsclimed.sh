#!/usr/bin/ksh
set -x
###############################################################################
###                            Variables                                    ###
###############################################################################

FECHA=${1}
NOMBRE="wsclimed_${FECHA}"
PATHLOG="/tecnol/util/log"
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
        curl -X POST "http://apps24/clinica-medica-api/api/PdfArchivo/CargaPreocupacionales/2" -H  "accept: */*" -d "" >${ARCHLOG}
        if [ $? != 0 ]
        then
                 Enviar_A_Log "ERROR - Fallo la ejecucion del webservice." ${LOGSCRIPT}
                 Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                 exit 5

        else
                if [ -s ${ARCHLOG} ]
                then	
			cat ${ARCHLOG}
                        grep  "procesados" ${ARCHLOG}
                        if [ $? = 0 ]
                        then
                                Enviar_A_Log "AVISO - termino correctamente." ${LOGSCRIPT}
                                Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
                                find ${PATHLOG} -name "wsclimed*.out" -mtime +2 -exec rm {} \;
                                find ${PATHLOG} -name "wsclimed*.log" -mtime +2 -exec rm {} \;	
                                exit 0

                        fi

                else
                        Enviar_A_Log "ERROR - No se genero el archivo de log." ${LOGSCRIPT}
                        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                        exit 9
                fi
	fi
else
        Enviar_A_Log "ERROR - No hay permisos de ejecucion para el comando curl." ${LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
        exit 88
fi
