#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: TICKETS                                                #
# Grupo..............: MASTERCARD                                             #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Detecta y renombra el archivo                          #
#                      TK_TK124D_FECHA.dat.zip                                #
# Nombre del programa: rentickmaster.sh                                       #
# Nombre del JOB.....: RENTKMAS                                               #
# Descripcion........:                                                        #
# Modificacion.......: 05/09/2006                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################

export DIA=${1}
export MES=${2}
export ANIO=${3}
export FECHA=${ANIO}${MES}${DIA}
export NOMBRE="rentickmaster"
export PATHAPL="/tecnol/tickets"
export PATHTICK="/tickets/mastercard"
export TICKETS="${PATHTICK}/TK_TK124D"
export TICKETS2="${PATHTICK}/tk.negativo.tickets"
export ARCHTICK1="`ls -1 ${TICKETS}_${FECHA}.dat.zip"
export ARCHTICK2="${TICKETS2}.${FECHA}"
export ARCHTICK3="${ARCHTICK2}.zip"
export PATHLOG="${PATHAPL}/log"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Enviar_A_Log
autoload Check_Par
autoload Borrar

###############################################################################
###                            Principal                                    ###
###############################################################################
Check_Par 3 $@
[ $? != 0 ] && exit 1
Enviar_A_Log "INICIO - Comienza la ejecucion." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
if [ ${ARCHTICK1} ]
then
	Enviar_A_Log "AVISO - El archivo ${ARCHTICK1} existe." ${LOGSCRIPT}
	/usr/bin/unzip -p ${ARCHTICK1} > ${ARCHTICK2}
	if [ $? != 0 ]
        then
        	Enviar_A_Log "ERROR - No se pudo descomprimir el archivo ${ARCHTICK1}." ${LOGSCRIPT}
                Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                exit 3
        fi
	if [ ${ARCHTICK2} ]
	then
		cat ${ARCHTICK2} | awk ' { if ( substr( $0, 3, 1 ) == "0" ) \
                                         { print substr( $0, 1, 2)"1"substr( $0, 4, length($0)) ; \
                                           print substr( $0, 1, 2)"2"substr( $0, 4, length($0)) ; \
                                           print substr( $0, 1, 2)"5"substr( $0, 4, length($0)) ; \
                                         } } ' >>${ARCHTICK2}
		if [ $? != 0 ]
		then
			Enviar_A_Log "ERROR - No se pudo agregar registros al archivo ${ARCHTICK2}." ${LOGSCRIPT}
                	Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                	exit 3
		fi
		/usr/bin/zip ${ARCHTICK3} ${ARCHTICK2}
       		if [ $? = 0 ]
       		then
			rm -f ${ARCHTICK2}
			Enviar_A_Log "AVISO - Archivo ${ARCHTICK2} fue comprimido correctamente." ${LOGSCRIPT}
			Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
			find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +7 -exec rm {} \;
			exit 0
		else
			Enviar_A_Log "ERROR - No se pudo comprimir el archivo ${ARCHTICK2}." ${LOGSCRIPT}
        		Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                	exit 13
       		fi       
	else
    		Enviar_A_Log "ERROR - No existe el archivo ${TICKETS2}.${DIA}${MES}${ANIO}.??????.zip." ${LOGSCRIPT}
        	Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
		exit 12
	fi
else
        Enviar_A_Log "ERROR - No existe el archivo ${TICKETS}.${DIA}${MES}${ANIO}.??????.zip." ${LOGSCRIPT}
	Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
        exit 12
fi
