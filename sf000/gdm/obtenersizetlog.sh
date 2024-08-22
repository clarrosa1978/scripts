#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: GDM                                                    #
# Grupo..............: PRECIOS                                                #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Obtener el tamaño del tlog activo.                     #
# Nombre del programa: obtenersizetlog.sh                                     #
# Nombre del JOB.....: OBTSIZTLOG                                             #
# Descripcion........: Obtiene el tamaño del tlog activo en /sfctrl/d.        #
# Modificacion.......: 08/03/2006                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################

export FECHA=${1}
export NOMBRE="obtenersizetlog"
export PATHAPL="/tecnol/gdm"
export PATHLOG="${PATHAPL}/log"
export PATHTLOG="/sfctrl/d"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"
export COUNTTLOG="${PATHLOG}/counttlog.${FECHA}.lst"

###############################################################################
###                            Principal                                    ###
###############################################################################
autoload Borrar
autoload Check_Par
Check_Par 1 $@
[ $? != 0 ] && exit 1
autoload Enviar_A_Log
Enviar_A_Log "INICIO - Comienza la ejecucion." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
Borrar ${COUNTLOG}
export TLOG=`ls -lt ${PATHTLOG}/tlog??.dat | head -1`
export ARCHTLOG=`echo ${TLOG} | awk ' { print $9 } '`
[ ${ARCHTLOG} ]  || exit 4
if [ ! -s ${ARCHTLOG} ] 
then
	Enviar_A_Log "ERROR - El archivo ${TLOG} no existe. " ${LOGSCRIPT}
	Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
	exit 12
fi
echo ${TLOG} | awk ' { print $5 } ' > ${COUNTTLOG}
if [ ! -s ${COUNTTLOG} ] 
then
	Enviar_A_Log "ERROR - No se pudo generar el archivo ${COUNTTLOG}. " ${LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
	exit 12
else
	Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
        find ${PATHLOG} -name "${NOMBRE}.*.lst" -mtime +7 -exec rm {} \;
        find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +7 -exec rm {} \;
        exit 0
fi
