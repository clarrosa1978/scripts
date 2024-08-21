#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: ALERTAS-SUC                                            #
# Grupo..............: JAVA                                                   #
# Autor..............: ARAM                                                   #
# Objetivo...........: Restartea demonio price checker.                       #
# Nombre del programa: demonpricechecker.sh                                   #
# Nombre del JOB.....: DEMONPRICECHEKER                                       #
# Solicitado por.....: Administracion Unix                                    #
# Descripcion........:                                                        #
# Creacion...........: 27/10/2010                                             #
###############################################################################

set -x
 
###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA="`date +%Y%m%d`"
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
	kill -9 ${ESTA}
        	if [ $? != 0 ]
        	then
               		echo "ERROR - No existe Numero de Proceso." 
               	 	exit 3
		fi

	nohup java -Xms32m -Xmx32m -jar ${PATHAPL}/${NOMBRE}.jar &
        	if [ $? != 0 ]
        	then
               		echo "ERROR - Error durante la ejecucion." 
               	 	exit 4
		fi
	find /tecnol/java/pchecker -name "*.log" -mtime +5 -exec rm -f {} \;

	exit 0
else
	nohup java -Xms32m -Xmx32m -jar ${PATHAPL}/${NOMBRE}.jar &
	
        if [ $? != 0 ]
        then
                echo "ERROR - Error durante la ejecucion." 
                exit 5
	fi
fi

