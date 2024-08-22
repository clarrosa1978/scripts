#!/usr/bin/ksh
set -x
###############################################################################
# Aplicacion.........:                                                        #
# Grupo..............:                                                        #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Reliza conexion sftp al server recibido como parametro.#
# Nombre del programa: sftp.sh                                                #
# Nombre del JOB.....: SFTPXXXXX                                              #
# Solicitado por.....: Administracion Unix                                    #
# Descripcion........:                                                        #
# Creacion...........: 04/08/2011                                             #
# Modificacion.......: DD/MM/AAAA                                             #
###############################################################################


###############################################################################
###                            Variables                                    ###
###############################################################################
export HOST=${1}
export USUARIO=${2}
export CLAVE=${3}
export OP=${4}
export ARCHORI=${5}
export ARCHDEST=${6}
export NOMBRE="sftp"
export PATHAPL="/tecnol/util"
export PATHLOG="${PATHAPL}/log"
export CMDFILE="${PATHLOG}/${HOST}.cmd"

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Borrar
autoload Check_Par
autoload Enviar_A_Log


###############################################################################
###                            Principal                                    ###
###############################################################################
Borrar ${CMDFILE}
Check_Par 6 $@
if [ $? != 0 ] 
then
	echo "Error en la cantidad de parametros.\n"
	echo "Descripcion:
				Parametro 1: Servidor donde queremos conectarnos.
				Parametro 2: Usuario de conexion.
				Parametro 3: Archive donde reside la llave privada de conexion.
				Parametro 4: Tipo de operacion G(get) o P(put).
				Parametro 5: Archivo origen con path incluido.
				Parametro 6: Archivo destino con path incluido."
	exit 1
else
        if [ ! -f ${CLAVE} ]
        then
                echo "No existe la clave ${CLAVE}.\n"
                exit 1
        fi
        if [ ${OP} = 'P' ] || [ ${OP} = 'G' ]
        then
		echo "INICIO - Comienza transferencia a ${HOST}." 
		if [ ${OP} = 'P' ]
		then
			echo "put ${ARCHORI} ${ARCHDEST}" > ${CMDFILE}
			echo "bye" >> ${CMDFILE}
			sftp -b ${CMDFILE} -o IdentityFile=${CLAVE} ${USUARIO}@${HOST} 
			STATUS=$?
		fi
		if [ ${OP} = 'G' ]
		then
			sftp -o BindAddress=172.16.7.32 -o IdentityFile=${CLAVE} ${USUARIO}@${HOST}:${ARCHORI} ${ARCHDEST}
			STATUS=$?
			ls -l ${ARCHDEST}
		fi
		if [ ${STATUS} != 0 ]
		then
			echo "Error en la transferencia del archivo ${ARCHORI}.\n"
			echo "Avisar a Administracion Unix."
			exit 5
		else
			echo "La transferencia termino Ok."
			exit 0
		fi
	else
		echo "Error en el parametro 4: debe ser P o G."
                exit 1
        fi
fi
