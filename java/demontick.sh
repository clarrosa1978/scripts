#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: ALERTAS-SUC                                            #
# Grupo..............: JAVA                                                   #
# Autor..............: Alejandro Ramirez                                      #
# Objetivo...........: Controlar demonio de tickets.                          #
# Nombre del programa: demontick.sh                                           #
# Nombre del JOB.....: DEMONTICK                                              #
# Solicitado por.....: Administracion Unix                                    #
# Descripcion........:                                                        #
# Creacion...........: 04/01/2010                                             #
# Modificacion.......: 16/02/2010                                             #
###############################################################################

set -x
 
###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA="`date +%Y%m%d`"
export NOMBRE="demontick"
export PATHAPL="/tecnol/java"

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
ESTA="`ps -ef | grep "${PATHAPL}/${NOMBRE}.jar" | grep -v grep`"
if [ "${ESTA}" ]  
then
	exit 0
else
	java -Xms32m -Xmx32m -jar /tecnol/java/demontick.jar /tecnol/java/configuracion.properties &
	
        if [ $? != 0 ]
        then
                echo "ERROR - Error durante la ejecucion." 
                exit 5
	fi
fi

