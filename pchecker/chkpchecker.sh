#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: ALERTAS-SUC                                            #
# Grupo..............: JAVA                                                   #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Controlar si el proceso priceDaemon_nquire esta en     #
#                      ejecucion.                                             #
# Nombre del programa: chkpchecker.sh                                         #
# Nombre del JOB.....: CHKPCHECKER                                            #
# Solicitado por.....: Administracion Unix                                    #
# Descripcion........:                                                        #
# Creacion...........: 26/04/2012                                             #
# Modificacion.......: --/--/----                                             #
###############################################################################

set -x
 
###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA=${1}
export NOMBRE="priceDaemon_nquire"
export PATHAPL="/tecnol/java/pchecker"

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Borrar
autoload Check_Par
autoload Enviar_A_Log

###############################################################################
###                            Principal                                    ###
###############################################################################

cd ${PATHAPL} || exit 1
ESTA="`ps -ef | grep "${PATHAPL}/${NOMBRE}.jar" | grep -v grep | awk '{ print $2}'`"
if [ "${ESTA}" ]  
then
	echo "AVISO - El proceso esta activo." 
	exit 0
else
	nohup java -Xms32m -Xmx32m -jar ${PATHAPL}/${NOMBRE}.jar &
        if [ $? != 0 ]
        then
        	echo "ERROR - Error durante la ejecucion." 
               	exit 4
	fi
	exit 0
fi

