#!/bin/ksh
###############################################################################
# Aplicacion.........: LISTAS_NEGRAS                                          #
# Grupo..............: COMPLETOS                                              #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Controla la existencia del archivo de DIBA a transferir#
# Nombre del programa: check_diab.sh                                          #
# Nombre del JOB.....: CTRLDIBA                                               #
# Solicitado por.....: Soporte Multistore.                                    #
# Descripcion........:                                                        #
# Creacion...........: 24/05/2012                                             #
# Modificacion.......: XX/XX/XXXX                                             #
###############################################################################

set -x
export FECHA=${1}
export NOMBRE="check_diba"
export PATHAPL="/tecnol/tickets"
export PATHLOG="${PATHAPL}/log"
export LOGSCRIPT="${PATHAPL}/${NOMBRE}.${FECHA}.log"
export PATHFILE="/tarjetas/diba"
export PATHBKP="/tarjetas/diba/backup"
export ARCHDATZ="_dibas16afiliacionesCOTOCOTO"
export ARCHDAT="COTO"
export ARCHBKP="diba.${FECHA}.txt"

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Enviar_A_Log


###############################################################################
###                            Principal                                    ###
###############################################################################

Enviar_A_Log "INICIO - Comienza la ejecucion." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
cd ${PATHFILE}
if [ $? != 0 ]
then
        Enviar_A_Log "ERROR - No se pudo acceder al directorio ${PATHFILE}." ${LOGSCRIPT}
        Enviar_A_Log "FIN - CON ERRORES"
        exit 2
fi
rm *.gz
if [ ! -s "${ARCHDATZ}.ZIP" ]
then
        Enviar_A_Log "ERROR - El archivo ${ARCHDATZ}.ZIP a transferir no existe." ${LOGSCRIPT}
        Enviar_A_Log "FIN - CON ERRORES"
        exit 9
fi
unzip ${ARCHDATZ}.ZIP
if [ $? != 0 ]
then
        Enviar_A_Log "ERROR - No se pudo descomprimir archivo ${ARCHDATZ}.ZIP." ${LOGSCRIPT}
        Enviar_A_Log "FIN - CON ERRORES"
	exit 7
fi
mv ${ARCHDATZ}.ZIP ${PATHBKP}/${ARCHDATZ}.${FECHA}.ZIP
if [ $? != 0 ]
then
        Enviar_A_Log "ERROR - No se pudo mover el archivo ${ARCHDATZ}.ZIP." ${LOGSCRIPT}
        Enviar_A_Log "FIN - CON ERRORES"
        exit 58
fi
mv ${ARCHDAT}.TXT ${ARCHBKP}
if [ $? != 0 ]
then
       	Enviar_A_Log "ERROR - No se pudo mover el archivo ${ARCHDAT}.TXT." ${LOGSCRIPT}
       	Enviar_A_Log "FIN - CON ERRORES"
	exit 58
fi
gzip ${ARCHBKP}
if [ $? != 0 ]
then
        Enviar_A_Log "ERROR - No se pudo comprimir el archivo ${ARCHBKP}." ${LOGSCRIPT}
        Enviar_A_Log "FIN - CON ERRORES"
        exit 5
fi
#cat ${FILE_BKP}/${ARCH_BKP}.TXT | tr -d "\r" > ${FILE_BKP}/${ARCHIVO}.${FECHA}.txt
