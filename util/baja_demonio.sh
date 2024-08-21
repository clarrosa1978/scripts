#! /bin/zsh

#####################################################################################
#                                              Jorge Fernandez Garay - 02/2002
# baja_demonio.sh
#
# Baja los procesos vpr_daemon.sh [ arg. ], (Daemons de Envios a Domicilio del sis-
# teme de Ventas x Reserva), donde arg. es el parametro pasado al comando, obtenido
# del archivo de configuracion de la alerta AIXChkEnviosDaemons.cfg.
# Una vez obtenido el PID de cada uno de los 10 procesos vpr_daemon.sh, se les envia
# una sen#al (SIGTERM) via IPC, para resguardar la integridad de las transacciones
# que estos ejecutan en la Base de Datos.
# 
# Por ultimo, controla que los daemons hayan cancelado, notificando si algunos de
# ellos han quedado colgados, para terminarlos con kill -SIGKILL.
#
######################################################################################

#set -x

HOMEDAEMON=/vtareserva/daemon
export HOMEDAEMON

clear screen

echo -e "\n\n\n\n"

echo -e "        \t*************************************************************"
echo -e "        \t*                                                           *"
echo -e "        \t*            ~SISTEMA DE VENTAS POR RESERVA~                *"
echo -e "        \t*                                                           *"
echo -e "        \t*       -- BAJAR DEMONIOS DE ENVIOS A DOMICILIO --          *"
echo -e "        \t*                                                           *"
echo -e "        \t*************************************************************"
echo -e "\n\n"

if [ -f /vtareserva/daemon/vpr_daemon.cfg ]
then
         PROCESSES_LIST=`cat /vtareserva/daemon/vpr_daemon.cfg`
else
         echo "No existe el archivo de config. vpr_daemon.cfg"
         exit 2
fi

PROCESSES_PATH="/vtareserva/daemon"
export PROCESSES_LIST PROCESSES_PATH

INTERVAL=''
EXEC_ARG=''
MATCH_EXEC_ARG=''
CHK_PID=''
KILL_LIST=''
KILL_LIST_RECORD=''
#LOOPCTRL="0"
export PROCESS_IS_UP INTERVAL EXEC_ARG MATCH_EXEC_ARG CHK_PID KILL_LIST KILL_LIST_RECORD LOOPCTRL


echo "$PROCESSES_LIST"|while read EXEC_ARG INTERVAL
do

	PARENT_PIDS=''

	# Trata de encontrar en la lista de procesos, un proceso vpr_daemon.sh, con un[
        # Argumento pasado en la linea de comando que matchee EXEC_ARG
#LOOPCTRL=`expr "$LOOPCTRL" + 1`
#[ "$LOOPCTRL" -gt 3 ] && exit
        MATCH_EXEC_ARG=''
        MATCH_EXEC_ARG=`ps -e -o "pid args"|cut -f 1-8 -d " "|awk ' { $(NF+1) = $1; $1 = ""; print $0 } '\
			|awk ' { if ( $1 ~ /sh/ || $1 ~ /ksh/ ) { i = 2; while ( ( $i ~ /^-/ ) && ( i < NF ) ) { $i = ""; i++ }; $1 = ""; print $0 }
				else { print $0 } } '\
			|awk ' $1 ~ /vpr_daemon/ && $3 == "'$EXEC_ARG'" { print $0 } '`

        # Si no encuentra un proceso con el arg. EXEC_ARG, continua con el proximo 
        # EXEC_ARG de la lista PROCESSES_LIST

        if [ "$MATCH_EXEC_ARG" = '' ]
        then
                echo "$0: Proceso vpr_daemon.sh, con arg. $EXEC_ARG: no esta corriendo..."
                continue
        fi
		
	# En MATCH_EXEC_ARG queda la linea del ps, para el daemon buscado, cuyo ultimo campo es el PID del daemon

	PARENT_PIDS=`echo "$MATCH_EXEC_ARG"|awk ' { print $NF } '`

        # Controla que los PIDs encontrados correspondan al argumento EXEC_ARG

        for DAEMON_PID in $PARENT_PIDS
        do
                CHK_PID=''
                CHK_PID=`ps -p "$DAEMON_PID" -o args=|awk ' { print $NF } '`

        	if [ "$CHK_PID" = "$EXEC_ARG" ]
        	then
                          # Se salvan el PID validado y el argumento EXEC_ARG, en la lista
                          # KILL_LIST, en memoria (no en disco). Para ello primero armo el
                          # registro de esta lista, con sus 2 campos
        
                          KILL_LIST_RECORD=''
                          KILL_LIST_RECORD="$DAEMON_PID $EXEC_ARG"

                          KILL_LIST=`echo "$KILL_LIST"|awk -v apend_rec="$KILL_LIST_RECORD" '     { print $0 }
                                                                                              END { print apend_rec }
                                                                                            '|sed -e '/^$/d'`
                          # Una vez almacenado el PID a matar y el EXEC_ARG,
                          # le envio signal 15 (SIGTERM) a este PID

                          kill -15 "$DAEMON_PID"
        	fi
        done

done


if [ "$KILL_LIST" != '' ]
then
	# Comienza el loop de control, para verificar si bajaron los procesos

        LOOP_COUNT="1"
        export LOOP_COUNT

        while true
        do

                 PID=''
                 EXEC_ARG=''
                 DAEMON_IS_UP="FALSE"
                 ALIVE_DAEMONS_LIST=''
                 export PID EXEC_ARG DAEMON_IS_UP ALIVE_DAEMONS_LIST

	         echo "$KILL_LIST"|while read PID EXEC_ARG 
                 do

                         DAEMON_IS_UP=`ps -p "$PID" -o args=|awk ' { print $NF } '`
                         DAEMON_IS_UP=`[ "$DAEMON_IS_UP" = "$EXEC_ARG" ] && echo "TRUE" || echo "FALSE"`
                                      # awk ' { if ( $0 == "'$EXEC_ARG'" ) { print "TRUE" } else { print "FALSE" } } '`

                         if [ "$DAEMON_IS_UP" = "FALSE" ]
                         then
                                 echo -e "\nProceso vpr_daemon.sh $EXEC_ARG: TERMINADO"
                         else
                                 # Lo incorporo a una lista de Procesos que no terminaron
                                 ALIVE_DAEMONS_LIST=`echo "$ALIVE_DAEMONS_LIST"|awk -v apend_rec="$PID $EXEC_ARG" '     { print $0 }
                                                                                                                    END { print apend_rec }
                                                                                                                  '|sed -e '/^$/d'`
                         fi
         	done

                if [ "$ALIVE_DAEMONS_LIST" = '' ]
                then
                         echo -e "\nTodos los procesos vpr_daemon han terminado satisfactoriamente"
                         exit 0
                fi

                LOOP_COUNT=`expr "$LOOP_COUNT" + 1`

                if [ "$LOOP_COUNT" -gt 4 ]
                then
                         echo -e "\nLos procesos que se muestran NO HAN TERMINADO aun..."
                         echo "Posiblemente hayan quedado colgados"

                         echo -e "\n\n$ALIVE_DAEMONS_LIST"
                         echo "Matarlos con kill -9. Abortando..."

                         exit 2
                fi

                # Si no, vuelve a controlar KILL_LIST, pero solo con los procesos vivos

                KILL_LIST="$ALIVE_DAEMONS_LIST"
                ALIVE_DAEMONS_LIST=''
  
        done

else
	echo -e "\nNo se detectaron demonios de VPR activos." 

fi

exit 0
