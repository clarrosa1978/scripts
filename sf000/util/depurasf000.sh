#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: UTILIDADES                                             #
# Grupo..............: UNIX                                                   #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........:                                                        #
# Nombre del programa: depurasf000.sh                                         #
# Nombre del JOB.....: DEPURASF000                                            #
# Solicitado por.....:                                                        #
# Descripcion........: Depura fs seleccionados.                               #
# Solicitado por.....:                                                        #
# Creacion...........: 29/03/2013                                             #
# Modificacion.......:                                                        #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA=${1}
export NOMBRE="depurasf000"
export PATHAPL="/tecnol/util"
export PATHLOG="${PATHAPL}/log"
export LOG="${PATHLOG}/${NOMBRE}.${FECHA}.log"


###############################################################################
###                            Funciones                                    ###
###############################################################################
. /tecnol/funciones/Check_Par
. /tecnol/funciones/Enviar_A_Log
autoload Enviar_A_Log


###############################################################################
###                            Principal                                    ###
###############################################################################

Check_Par 1 $@
[ $? != 0 ] && exit 1
Enviar_A_Log "Comienzo depuraciones - ${FECHA}" ${LOG}
#Depuracion archivos de POSNETS - Debe quedar solo los ultimos 7 dias
	FS="/sts/posnets/procesados"
        Enviar_A_Log "------------------Comienzo depuracion ${FS}--------------------" ${LOG}
	find ${FS} -type f -mtime +7 -exec ls -l {} \; >>${LOG}
	find ${FS} -type f -mtime +7 -exec rm {} \; 
        Enviar_A_Log "----------------------Fin depuracion ${FS}---------------------" ${LOG}

#Depuracion de archivos de precios - Debe quedar los ultimos 7 dias
	FS="/sfctrl/data/procesados"
        Enviar_A_Log "------------------Comienzo depuracion ${FS}--------------------" ${LOG}
        find ${FS} -name "GM03*" -mtime +3 -exec ls -l {} \; >>${LOG}
        find ${FS} -name "CL03*" -mtime +3 -exec ls -l {} \; >>${LOG}
        find ${FS} -name "GM03*" -mtime +7 -exec rm {} \;
        find ${FS} -name "CL03*" -mtime +7 -exec rm {} \;
	find /sfctrl -name "GM03250_*" -mtime +1 -exec rm {} \;
        Enviar_A_Log "----------------------Fin depuracion ${FS}---------------------" ${LOG}

#Depuracion de archivos de precios descargados - Debe quedar los ultimos 7 dias
        FS="/sfctrl/data/descarga"
        Enviar_A_Log "------------------Comienzo depuracion ${FS}--------------------" ${LOG}
        find ${FS} -name "GM03*" -mtime +3 -exec ls -l {} \; >>${LOG}
        find ${FS} -name "CL03*" -mtime +3 -exec ls -l {} \; >>${LOG}
        find ${FS} -name "GM03*" -mtime +7 -exec rm {} \;
        find ${FS} -name "CL03*" -mtime +7 -exec rm {} \;
        find /sfctrl -name "GM03250_*" -mtime +1 -exec rm {} \;
        Enviar_A_Log "----------------------Fin depuracion ${FS}---------------------" ${LOG}

#Depuracion de archivos 
        FS="/sfctrl"
        Enviar_A_Log "------------------Comienzo depuracion ${FS}--------------------" ${LOG}
	find ${FS} -name "GM03250_*" -mtime +1 -exec rm {} \;
        rm -r ${FS}/RFAR* 
        Enviar_A_Log "----------------------Fin depuracion ${FS}---------------------" ${LOG}


#Depuracion de archivos de pagofacil - Debe quedar los ultimos 30 dias
        FS="/pagofacil/concilia/salida"
        Enviar_A_Log "------------------Comienzo depuracion ${FS}--------------------" ${LOG}
        find ${FS} -name "CO????????" -mtime +30 -exec ls -l {} \; >>${LOG}
        find ${FS} -name "CO????????" -mtime +30 -exec rm {} \;
        Enviar_A_Log "----------------------Fin depuracion ${FS}---------------------" ${LOG}

	FS="/pagofacil/concilia/entrada"
        Enviar_A_Log "------------------Comienzo depuracion ${FS}--------------------" ${LOG}
        find ${FS} -name "pf??????.053.Z" -mtime +30 -exec ls -l {} \; >>${LOG}
        find ${FS} -name "pf??????.053.Z" -mtime +30 -exec rm {} \;
        Enviar_A_Log "----------------------Fin depuracion ${FS}---------------------" ${LOG}

	FS="/pagofacil/concilia/entrada"
        Enviar_A_Log "------------------Comienzo depuracion ${FS}--------------------" ${LOG}
        find ${FS} -name "pf??????.900" -mtime +1 -exec gzip {} \;
        find ${FS} -name "pf??????.900.gz" -mtime +30 -exec ls -l {} \; >>${LOG}
        find ${FS} -name "pf??????.900.gz" -mtime +30 -exec rm {} \;
        Enviar_A_Log "----------------------Fin depuracion ${FS}---------------------" ${LOG}

#Depuracion de archivos SFVCC - Debe quedar los ultimos 7 dias
        FS="/sfvcc/tmp"
        Enviar_A_Log "------------------Comienzo depuracion ${FS}--------------------" ${LOG}
        find ${FS} -name "dcc.*" -mtime +7 -exec ls -l {} \; >>${LOG}
        find ${FS} -name "dcc.*" -mtime +7 -exec rm {} \;
        find ${FS} -name "sfcliente.*" -mtime +7 -exec ls -l {} \; >>${LOG}
        find ${FS} -name "sfcliente.*" -mtime +7 -exec rm {} \;
        find ${FS} -name "sfpuntos.*" -mtime +7 -exec ls -l {} \; >>${LOG}
        find ${FS} -name "sfpuntos.*" -mtime +7 -exec rm {} \;
        find ${FS} -name "tos.*" -mtime +7 -exec ls -l {} \; >>${LOG}
        find ${FS} -name "tos.*" -mtime +7 -exec rm {} \;
        find ${FS} -name "vcc.*" -mtime +7 -exec ls -l {} \; >>${LOG}
        find ${FS} -name "vcc.*" -mtime +7 -exec rm {} \;
        Enviar_A_Log "----------------------Fin depuracion ${FS}---------------------" ${LOG}

#Depuracion de archivos SFVCC12 - Debe quedar los ultimos 30 dias
        FS="/sfvcc12/tmp"
        Enviar_A_Log "------------------Comienzo depuracion ${FS}--------------------" ${LOG}
        find ${FS} -name "*.log" -mtime +2 -exec ls -l {} \; >>${LOG}
        find ${FS} -name "*.log" -mtime +2 -exec gzip {} \;
        find ${FS} -name "*.log.gz" -mtime +30 -exec ls -l {} \; >>${LOG}
        find ${FS} -name "*.log.gz" -mtime +30 -exec rm -f {} \; >>${LOG}
        Enviar_A_Log "----------------------Fin depuracion ${FS}---------------------" ${LOG}

	#Depuro /tecnol/util/log
	find ${PATHLOG} -name "${NOMBRE}.*" -mtime +30 -exec rm {} \;

exit 0
