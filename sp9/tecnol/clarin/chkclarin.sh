#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: TARJETAS                                               #
# Grupo..............: CLARIN                                                 #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Controlar la integridad del archivo		      #
#                      clarin zonae-YYYYMMDD.txt.gz                           #
# Nombre del programa: chkclarin.sh                                           #
# Nombre del JOB.....: CHKCLARIN                                              #
# Descripcion........:                                                        #
# Modificacion.......: 30/10/2012                                             #
# Solicitado por.....: Cristian Larrosa                                       #
###############################################################################

set -x
###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA="${1}"
export NOMBRE="chkclarin"
export PATHAPL="/tecnol/clarin"
export PATHLOG="${PATHAPL}/log"
export PATHARCH="/tarjetas/clarin"
export ARCHIVO="zonae-${FECHA}.txt.gz"
export LOG="${PATHLOG}/${NOMBRE}.${FECHA}.log"

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Check_Par

###############################################################################
###                            Principal                                    ###
###############################################################################
Check_Par 1 $@
[ $? != 0 ] && exit 1
if [ -s ${PATHARCH}/${ARCHIVO} ]
then
	Enviar_A_Log "INICIO - El archivo $ARCHIVO} existe." ${LOG}
	gunzip -t ${PATHARCH}/${ARCHIVO}
	if [ $? = 0 ]
	then
		Enviar_A_Log "PROCESO - El archivo ${ARCHIVO} no esta corrupto." ${LOG}
		gunzip -f ${PATHARCH}/${ARCHIVO}
		if [ $? = 0 ]
		then
			Enviar_A_Log "PROCESO - El archivo ${ARCHIVO} esta descomprimido." ${LOG}
			RECORD="`wc -l ${PATHARCH}/zonae-${FECHA}.txt | awk ' { print $1 } '`"
			if [ ${RECORD} -lt 50000 ]
			then
				Enviar_A_Log "PROCESO - El archivo zonae-${FECHA}.txt tiene menos de 5000' registros. Reclamar a Clarin." ${LOG}
				Enviar_A_Log "FIN - Finalizacion con ERROR." ${LOG}
				exit 1
			else
				Enviar_A_Log "FIN - Finalizacion OK." ${LOG}
				exit 0
			fi
		else
			Enviar_A_Log "PROCESO - Error al descomprimir el archivo ${ARCHIVO}." ${LOG}
			Enviar_A_Log "FIN - Finalizacion con ERROR." ${LOG}
			exit 1
		fi
	else
		  Enviar_A_Log "PROCESO - El archivo ${ARCHIVO} esta corrupto. Rearrancar el job SFTPCLARIN." ${LOG}
                  Enviar_A_Log "FIN - Finalizacion con ERROR." ${LOG}
                  exit 1
	fi
else
	Enviar_A_Log "PROCESO - El archivo ${ARCHIVO} no existe o no tiene datos." ${LOG}
        Enviar_A_Log "FIN - Finalizacion con ERROR." ${LOG}
        exit 1
fi
