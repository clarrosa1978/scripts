#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: NTCIERRE                                               #
# Grupo..............: CADENA001                                              #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Genera listado de todas las operaciones de la sucursal #
# Nombre del programa: ts001082.sh                                            #
# Nombre del JOB.....: TS001082                                               #
# Descripcion........:                                                        #
# Modificacion.......: 02/07/2013                                             #
###############################################################################
set -x

###############################################################################
###                            Variables                                    ###
###############################################################################

export FECHA=${2}
export DIA="`echo ${FECHA} | cut -c7-8`"
export MES="`echo ${FECHA} | cut -c5-6`"
export NOMBRE="ts001082"
export PATHAPL="/sfctrl/reports"
export PATHLOG="/tecnol/ntcierre/log"
export PATHPRG="/sfctrl/sfgv/bin"
export PATHBKP="${PATHAPL}/semanal"
export PROGRAMA="${PATHPRG}/${NOMBRE}"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"
export LISTADOORI="${PATHAPL}/LS001082"
export LISTADOBKP="${PATHBKP}/LS001082.${DIA}${MES}"

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
Enviar_A_Log "INICIO - Comienza la ejecucion." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
Borrar ${LISTADOORI}
if [ $? != 0 ]
then
	Enviar_A_Log "ERROR - No se pudo borrar ${LISTADOORI}." ${LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
        exit 99
fi
cd ${PATHAPL}
if [ $? != 0 ]
then
        Enviar_A_Log "ERROR - Directorio ${PATHAPL} inaccesible." ${LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
        exit 2
fi

if [ -x ${PROGRAMA} ]
then
	${PROGRAMA}
	if [ $? = 0 ] 
	then
		if [ -s ${LISTADOORI} ]
		then
			cp ${LISTADOORI} ${LISTADOBKP}
			if [ $? = 0 ]
			then
				Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
                                find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +7 -exec rm {} \;
				find ${PATHBKP} -name "${NOMBRE}.*" -mtime +20 -exec rm {} \; 
                                exit 0
			else
                               	Enviar_A_Log "ERROR - No se pudo copiar ${LISTADOORI} como ${LISTADOBKP}." ${LOGSCRIPT}
                                Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                                exit 59
                        fi
		else
			Enviar_A_Log "ERROR - No se genero el listado ${LISTADOORI} o tiene size 0." ${LOGSCRIPT}
                        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                        exit 12
		fi
	else
		Enviar_A_Log "ERROR - Error durante la ejecucion ${PROGRAMA}." ${LOGSCRIPT}
                Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
        	exit 7
	fi
else
        Enviar_A_Log "ERROR - No hay permisos de ejecucion para ${PROGRAMA}." ${LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
        exit 88
fi
