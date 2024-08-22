#!/bin/ksh
################################################################################
# Aplicacion.........: ALERTAS                                                 #
# Grupo..............: STOREFLOW                                               #
# Autor..............: ARAM                                                    #
# Nombre del programa: enviodom.sh                                             #
# Nombre del JOB.....: ALARMAENVIODOM                                          #
# Descripcion........: Script verifica que el proceso EnvioDom no este colgado.#
# Modificacion.......: 28/12/2011                                              #
################################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################

export HOSTNAME=$(uname -n)
export ENVIODOM_FILE=''
export ENVIODOM_FILE="/sfctrl/tmp/EnvioDom.`date +%d`.log"
export FILELOG="/tecnol/alertas/log/EnvioDom.`date +%d`.log"
export DESTINATARIO="operaciones@redcoto.com.ar"
export MENSAJE="Server $HOSTNAME - Control del Proceso EnvioDom - ENVIODOM OK, Pero No procesa, Avisar a MULTISTORE"
export MENSAJE2="Server $HOSTNAME - Control del Proceso EnvioDom - No EXISTE el archivo de LOG, Avisar a MULTISTORE"


###############################################################################
###                            Principal                                    ###
###############################################################################
set -x

echo "Verificacion de EnvioDom $(date)" >> $FILELOG
find /tecnol/alertas/log -name "EnvioDom.*.log" -mtime +7 -exec rm {} \;
ENVIO_UP=$(ps -fu sfctrl | grep EnvioDom | grep -v grep | grep -v $$ | wc -l) 
if [ $ENVIO_UP -eq 1 ]
then
	echo " ENVIODOM ACTIVO " >>$FILELOG
	export ENVIODOM_STAT="UP"
	# El EnvioDom esta activo, chequeo de logs
	if [ "$ENVIODOM_STAT" = "UP" ]
	then
		# Se controla el crecimiento del log del proceso EnvioDom,
		# en caso que el proceso este levantado, pero colgado.
		if [ -f "$ENVIODOM_FILE" ]
		then
			export PREVIOUS_REC_COUNT=''
			export CURRENT_REC_COUNT=''
			export REC_COUNT_GROWTH=''
			export PREVIOUS_OFFSET=''
			export CURRENT_OFFSET=''
			export OFFSET_COUNT_GROWTH=''
			# Proceso de inicializacion del archivo de count de
			# registros del log, para controlar su crecimiento
			if [ ! -f /tecnol/alertas/enviodom_log.count ]
			then
				CURRENT_REC_COUNT=`wc -l "$ENVIODOM_FILE"|awk ' { print $1 } '`
				echo "$CURRENT_REC_COUNT" > /tecnol/alertas/enviodom_log.count
				echo " PRIMERA CORRIDA LOG: $CURRENT_REC_COUNT " >>$FILELOG
				CURRENT_OFFSET=`tail -3 "$ENVIODOM_FILE" |grep offset -m1|awk ' { print $4 } '`
				echo " PRIMERA CORRIDA OFFSET: $CURRENT_OFFSET " >>$FILELOG
				echo "$CURRENT_OFFSET" > /tecnol/alertas/envioset_log.count
				# Si recien se genera el archivo de record count del log, no se
				# controla crecimiento del log, hasta la siguiente corrida
				exit 0
			fi
			# Si existe el archivo de record count del log, se controla crecimiento del log.
			PREVIOUS_REC_COUNT=`cat /tecnol/alertas/enviodom_log.count`
			CURRENT_REC_COUNT=`wc -l "$ENVIODOM_FILE"|awk ' { print $1 } '`
			REC_COUNT_GROWTH=`expr "$CURRENT_REC_COUNT" - "$PREVIOUS_REC_COUNT"`
			PREVIOUS_OFFSET=`cat /tecnol/alertas/envioset_log.count`
			CURRENT_OFFSET=`tail -3 "$ENVIODOM_FILE" |grep offset -m1|awk ' { print $4 } '`
			OFFSET_COUNT_GROWTH=`expr "$CURRENT_OFFSET" - "$PREVIOUS_OFFSET"`
			if [ "$REC_COUNT_GROWTH" -lt 0 ]
			then
				# Este valor debe ser >= 0. Si es < 0, el valor corresponde a una
				# exepcion, posiblemente una depuracion del log, que deja incon-
				# sistente el record count previo. Debe repararse el problema, y
				# resignar el control hasta la proxima corrida.
				echo "$CURRENT_REC_COUNT" > /tecnol/alertas/enviodom_log.count
				echo " REINICIO COUNT LOG: $CURRENT_REC_COUNT " >>$FILELOG
				echo "$CURRENT_OFFSET" > /tecnol/alertas/envioset_log.count
				echo " REINICIO COUNT OFFSET: $CURRENT_OFFSET " >>$FILELOG
				exit 0
			fi
			if [ "$REC_COUNT_GROWTH" -gt 0 ]
			then
				# Se detecta crecimiento del log, y el status del EnvioDom es:ACTIVO
				# Se actualiza el EnvioDom_log.count
				echo "$CURRENT_REC_COUNT" > /tecnol/alertas/enviodom_log.count
				echo " COUNT LOG: $CURRENT_REC_COUNT " >>$FILELOG
                               	# Ahora hay que verificar que el envioset este creciendo
				if [ "$OFFSET_COUNT_GROWTH" -gt 0 ]
				then
					# Se detecta crecimiento del envioset, entonces esta ok.
					# Se actualiza el envioset_log.count
					echo "$CURRENT_OFFSET" > /tecnol/alertas/envioset_log.count
					echo " COUNT OFFSET: $CURRENT_OFFSET " >>$FILELOG
					exit 0
				else
					# En este punto, OFFSET_COUNT_GROWTH = 0, y no se detecta crecimiento del log.
					# El Status del EnvioDom es: HUNG_UP, y se notifica via mail 
					echo "$CURRENT_OFFSET" > /tecnol/alertas/envioset_log.count
					echo " COUNT OFFSET: $CURRENT_OFFSET " >>$FILELOG
					echo " El envioset no crece " >>$FILELOG
					echo "Proceso ENVIODOM OK, Pero No procesa. Revisar /sfctrl/tmp/EnvioDom`date +%d`.log"|\
					mailx -s "${MENSAJE}" ${DESTINATARIO}
					exit 0
				fi
			fi
			# En este punto, REC_COUNT_GROWTH = 0, y no se detecta crecimiento del log.
			# El Status del EnvioDom es: HUNG_UP, y se notifica via mail 
			echo " COUNT LOG: $CURRENT_REC_COUNT " >>$FILELOG
			echo " El log no crece " >>$FILELOG
			echo "Proceso ENVIODOM COLGADO No procesa. Revisar /sfctrl/tmp/enviodom`date +%d`.log"|\
			mailx -s "${MENSAJE}" ${DESTINATARIO}
			exit 0
		else
			# Si no existe el log, se notifica por mail
			#echo " No existe el log " >>$FILELOG
			#echo "El log no existe, revisar"|\
			#mailx -s "${MENSAJE2}" ${DESTINATARIO}
			PID="`ps -fu sfctrl | grep EnvioDom | grep -v grep | grep -v $$ | awk ' { print $2 } '`"
			if [ "${PID}" ]
			then
				kill -9 ${PID}
			fi
			su - sfctrl -c "/sfctrl/sfgv/bin/EnvioDom 1>/dev/null 2>/dev/null"
			exit 0
		fi
	fi
else
	if [  $ENVIO_UP -eq 0 ]
	then
		# El proceso EnvioDom, no esta arriba
		export ENVIODOM_STAT="DOWN"
		echo " Proceso ENVIODOM CAIDO" >>$FILELOG
		su - sfctrl -c "/sfctrl/sfgv/bin/EnvioDom 1>/dev/null 2>/dev/null"
		exit 0
	else
		PID="`ps -fu sfctrl | grep EnvioDom | grep -v grep | grep -v $$ | awk ' { print $2 } '`"
                if [ "${PID}" ]
                then
                	kill -9 ${PID}
		fi
		su - sfctrl -c "/sfctrl/sfgv/bin/EnvioDom 1>/dev/null 2>/dev/null"
	fi
fi