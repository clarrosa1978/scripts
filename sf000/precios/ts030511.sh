#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: PRECIOS-GDM-ZE000                                      #
# Grupo..............: GENERACION                                             #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Ejecuta el programa ts030511.                          #
# Nombre del programa: ts030511.sh                                            #
# Nombre del JOB.....: TS030511                                               #
# Descripcion........:                                                        #
# Modificacion.......: 15/11/2006                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################

export FECHA=${1}
export MODO=${2}
export NOMBRE="ts030511"
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

Check_Par 2 $@
[ $? != 0 ] && exit 1
[ ${DATEHORA} ] || exit 4
Enviar_A_Log "INICIO - Comienza la ejecucion." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
if [ -x ${PROGRAMA} ]
then
	${PROGRAMA} ${DATEHORA} ${MODO}
        if [ $? != 0 ]
        then
        	Enviar_A_Log "ERROR - Fallo la ejecucion del programa ${PROGRAMA}." ${LOGSCRIPT}
                Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                exit 7
        else
                Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
                find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +7 -exec rm {} \;
                exit 0
        fi
else
        Enviar_A_Log "ERROR - No hay permisos de ejecucion para el programa ${PROGRAMA}." ${LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERRORES PARA ENTIDAD ${ENTIDAD}." ${LOGSCRIPT}
        exit 88
fi
