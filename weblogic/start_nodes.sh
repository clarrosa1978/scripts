#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: COTODIGI2                                              #
# Grupo..............: WEBLIGIC                                               #
# Autor..............: Gustavo Alonso                                         #
# Objetivo...........: Levanta los nodos de weblogic de cotodigital3          #
# Nombre del programa: start_node.sh                                          #
# Nombre del JOB.....: startWLSxxxx                                           #
# Descripcion........:                                                        #
# Modificacion.......: 07/03/2016 					      #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
FECHA=${1}
NODO=${2}
CONSOLE=${3}
NOMBRE="start.WLS.${NODO}"
PATHLOG="/tecnol/weblogic/log"
LOGSCRIPT="${PATHLOG}/${NOMBRE}-${FECHA}.log"
DOMAIN_HOME="/u01/app/oracle/Middleware/12.1.2/user_projects/domains/Cotodigital"
ARCHLOG="$DOMAIN_HOME/servers/$NODO/logs/$NODO.out"

###############################################################################
###                            Funciones                                    ###
###############################################################################
. /tecnol/funciones/Borrar
. /tecnol/funciones/Check_Par
. /tecnol/funciones/Enviar_A_Log

autoload Enviar_A_Log
autoload Check_Par
autoload Borrar

###############################################################################
###                            Principal                                    ###
###############################################################################
Check_Par 3 $@
[ $? != 0 ] && exit 1
find ${PATHLOG} -name "${NOMBRE}*log" -mtime +2 -exec rm {} \;
Enviar_A_Log "INICIO - Comienza la ejecucion." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
if [ -x ${DOMAIN_HOME}/bin/startManagedWebLogic.sh ]
then
	if [ ${NODO} = atg_scenario ]
	then
		echo "Borro temporales y ear viejos de atg_scenario"
	   	rm -fr /u01/app/oracle/Middleware/12.1.2/user_projects/domains/Cotodigital/servers/${NODO}/stage/atg_scenario		
		rm -fr /u01/app/oracle/Middleware/12.1.2/user_projects/domains/Cotodigital/servers/${NODO}/tmp/*
	else

		echo "Borrando temporales y ear viejo"
			rm -fr /u01/app/oracle/Middleware/12.1.2/user_projects/domains/Cotodigital/servers/${NODO}/stage/atg_production*
		rm -fr /u01/app/oracle/Middleware/12.1.2/user_projects/domains/Cotodigital/servers/${NODO}/tmp/*
	fi
	
	if [ -s ${DOMAIN_HOME}/servers/${NODO}/logs/${NODO}.out ]
	then
        	#Rotado de log .out
        	export datelog=`date '+%Y%m%d_%H%M'`
        	cp -pr ${DOMAIN_HOME}/servers/${NODO}/logs/${NODO}.out ${DOMAIN_HOME}/servers//${NODO}/logs/${NODO}.$datelog.out
        	#Comprimo el log rotado
        	gzip -f ${DOMAIN_HOME}/servers/${NODO}/logs/${NODO}.$datelog.out

	fi


	echo "Levantando nodo ${NODO}. Aguarde unos minutos...."

	nohup $DOMAIN_HOME/bin/startManagedWebLogic.sh ${NODO} ${CONSOLE} > ${ARCHLOG} &
        sleep 15;
	 	spaces_run=`grep -i "startup date" ${ARCHLOG}|grep -v grep |awk 'END{print NR}'`
	 	while [ $spaces_run -eq 0 ]
       	 	do
 	 	sleep 20;
	 	spaces_run=`grep -i "startup date" ${ARCHLOG}|grep -v grep |awk 'END{print NR}'`
 	 	done

        if [ $? != 0 ]
	then
		 Enviar_A_Log "ERROR - Fallo la ejecucion ." ${LOGSCRIPT}
                 Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                 exit 5
	else
		if [ -s ${ARCHLOG} ]
		then
			grep "FAIL" ${ARCHLOG}
			if [ $? = 0 ]
                        then
                                Enviar_A_Log "ERROR - El archivo ${ARCHLOG} generado con errores." ${LOGSCRIPT}
                                Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                                exit 1
                        else
				grep -i "startup date" ${ARCHLOG}
                        	if [ $? = 0 ]  
                        	then
					Enviar_A_Log "AVISO - El nodo ${NODO} levanto OK." ${LOGSCRIPT}
                        		Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
                                	exit 0
                        	else
					Enviar_A_Log "ERROR - No se pudo iniciar el nodo ${NODO}." ${LOGSCRIPT}
                                        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                                        exit 7
				fi
			fi
		else
			Enviar_A_Log "ERROR - No se pudo iniciar el nodo ${NODO}." ${LOGSCRIPT}
                        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                        exit 9
		fi
	fi
else
        Enviar_A_Log "ERROR - No hay permisos de ejecucion para el comando startManagedWebLogic.sh." ${LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
        exit 88
fi
