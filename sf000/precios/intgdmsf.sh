#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: PRECIOS-GDM-ZE000                                      #
# Grupo..............: GENERACION                                             #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Ejecuta el programa intgdmsf, que de acuerdo a los pa- #
#                      metros recibidos, genera las interfases entre GDM y SF.#
# Nombre del programa: intgdmsf.sh                                            #
# Nombre del JOB.....: INTGDMXX                                               #
# Descripcion........:                                                        #
# Modificacion.......: 08/07/2006                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################

export FECHA=${1}
export ENTIDAD=${2}
export MODO=${3}
export NOMBRE="intgdmsf"
export PATHAPL="/tecnol/precios"
export PATHSQL="${PATHAPL}/sql"
export PATHLOG="${PATHAPL}/log"
export PATHPRG="/sfctrl/sfgv/bin"
export PROGRAMA="${PATHPRG}/${NOMBRE}"
export DATEHORA=`cat ${PATHLOG}/obtdatehora.${FECHA}.lst`
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"

###############################################################################
###                            Funciones                                    ###
###############################################################################

autoload Enviar_A_Log
autoload Borrar
autoload Check_Par

###############################################################################
###                            Principal                                    ###
###############################################################################

Check_Par 3 $@
[ $? != 0 ] && exit 1
[ ${DATEHORA} ] || exit 4
Enviar_A_Log "INICIO - Comienza la ejecucion para entidad ${ENTIDAD}." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
if [ -x ${PROGRAMA} ]
then
	${PROGRAMA} ${ENTIDAD} ${DATEHORA} ${MODO}
        if [ $? != 0 ]
        then
        	Enviar_A_Log "ERROR - Fallo la ejecucion del programa ${PROGRAMA}." ${LOGSCRIPT}
                Enviar_A_Log "FINALIZACION - CON ERRORES PARA ENTIDAD ${ENTIDAD}." ${LOGSCRIPT}
                exit 7
        else
                Enviar_A_Log "FINALIZACION - OK PARA ENTIDAD ${ENTIDAD}." ${LOGSCRIPT}
                find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +3 -exec rm {} \;
                exit 0
        fi
else
        Enviar_A_Log "ERROR - No hay permisos de ejecucion para el programa ${PROGRAMA}." ${LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERRORES PARA ENTIDAD ${ENTIDAD}." ${LOGSCRIPT}
        exit 88
fi
