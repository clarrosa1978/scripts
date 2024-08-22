#!/bin/ksh
###############################################################################
# Aplicacion.........: APERTURA-ZE000                                         #
# Grupo..............: APERTURA-SF                                            #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Determinar si los procesos levantados por el script    #
#                      /sfctrl/bin/preipl estan activos.                      #
# Nombre del programa: chk_procesos.sh                                        #
# Nombre del JOB.....: CHKPROC                                                #
# Descripcion........: Chequea que los procesos de SF (preipl) estan activos  #
# Modificacion.......: 2005/07/19                                             #
###############################################################################
 
set -x
 
###############################################################################
###                            Variables                                    ###
###############################################################################

export FECHA="${1}"
export USUARIO="sfctrl"
export NOMBRE="chk_procesos"
export PATHAPL="/tecnol/apertura-sf"
export PATHLOG="${PATHAPL}/log"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"
export PROCESO="btd napaspyd sucsock napafsrd ts030508 ongdmcen"

###############################################################################
###                            Funciones                                    ###
###############################################################################

autoload Check_Par
autoload Enviar_A_Log

###############################################################################
###                             Principal                                   ###
###############################################################################

Check_Par 1 $@
[ $? != 0 ] && exit 1
Enviar_A_Log "INICIO - Comienza la ejecucion." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
for P in ${PROCESO}
do
	ESTA=`ps -ef | grep ${USUARIO} | grep -v grep | grep ${P}`
	if [ "${ESTA}" ]
	then
		Enviar_A_Log "AVISO - El proceso ${P} esta activo." ${LOGSCRIPT}
	else
		Enviar_A_Log "ERROR - El proceso ${P} no esta activo." ${LOGSCRIPT}
		Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
		exit 20
	fi
done
Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +7 -exec rm {} \;
