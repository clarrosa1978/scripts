#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: ALERTAS-SUC                                            #
# Grupo..............: JAVA                                                   #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Controlar demonio price checker.                       #
# Nombre del programa: pricechecker.sh                                        #
# Nombre del JOB.....: DEMONPCHECKER                                          #
# Solicitado por.....: Administracion Unix                                    #
# Descripcion........:                                                        #
# Creacion...........: 27/10/2010                                             #
# Modificacion.......: 27/10/2010                                             #
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
ESTA="`ps -ef | grep "${PATHAPL}/${NOMBRE}.jar" | grep -v grep`"
if [ "${ESTA}" ]  
then
	exit 0
else
	nohup java -Xms32m -Xmx32m -jar ${PATHAPL}/${NOMBRE}.jar &
	
        if [ $? != 0 ]
        then
                echo "ERROR - Error durante la ejecucion." 
                exit 5
	fi
fi

