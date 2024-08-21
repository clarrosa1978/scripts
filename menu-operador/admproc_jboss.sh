#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: MENU OPERACIONES                                       #
# Grupo..............:                                                        #
# Autor..............: Cerizola Hugo                                          #
# Objetivo...........: Manejar procesos de este servidor                      #
# Nombre del programa: admprocesos.sh                                         #
# Solicitado por.....:                                                        #
# Descripcion........: Menu para administrar procesos del servidor            #
# Creacion...........: 20/11/2013                                             #
# Modificacion.......: DD/MM/AAAA                                             #
###############################################################################

#set -x
clear

###############################################################################
###                            Variables                                    ###
###############################################################################
export FPATH="/tecnol/funciones"
export FECHA="`date +%Y%m%d`"
#export SUC="`uname -n | sed 's/suc//'`"
export SUC="`hostname`"
export OPERACION=${1}
export NOMBRE="jboss"								# <--- Nombre del Proceso
export PATHSCR="/tecnol/operador"					
export PATHSCRLOG="${PATHSCR}/log"
export LOGSCRIPT="${PATHSCRLOG}/${NOMBRE}.${FECHA}.log"

##############################################################################
#   Ingrese los datos de lo que desea controlar
##############################################################################

export USUARIO="jboss"								# <--- Usuario del proceso a Controlar
export PATHPRC="/jboss" 							# <--- Directorio raiz del proceso a controlar
export PATHAPL="${PATHPRC}/server/coto"   					# <--- Directorio del proceso a controlar
export PATHTMP="${PATHAPL}/tmp"							# <--- Directorio temporal
export PATHLOG="${PATHAPL}/log"							# <--- Directorio de log 

#--------------     Procesos a controlar ( que buscar en el OS ) ------------#
export LISTAPROC="/jboss/bin/run.sh /jboss/bin/run.jar"                         # <--- Ingresar los procesos que se desean controlar
export CANTPROC=`echo $LISTAPROC | wc -w` 

#--------------     Forma de Buscar los Id de Procesos a controlar   --------#
export PID="`for ID in $LISTAPROC ; do ps -fu ${USUARIO} | grep ${ID} | awk '{ print $2 }'| sort -r ; done`"  # <--- Como se busca el proceso

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Borrar
autoload Enviar_A_Log

#=============================================================================
#  Subir proceso
#=============================================================================

upproc ()
{
#set -x
export ACCION="UP"
titulo "Levantando procesos del ${USUARIO}, aguarde por favor.."
Enviar_A_Log "Levantando procesos del usuario ${USUARIO}" ${LOGSCRIPT}      
cd ~${USUARIO}
su - jboss -c "nohup /jboss/bin/run.sh -c coto -b jas7.redcoto.com.ar &" 1>/dev/null			# <--- Forma de subir el proceso
Enviar_A_Log "Levantando procesos ${NOMBRE}.jar" ${LOGSCRIPT}
}

#=============================================================================
#  Bajar proceso
#=============================================================================

downproc ()
{
#set -x
export ACCION="DOWN"
#verproc &
titulo "Bajando procesos del ${USUARIO}, aguarde por favor.."
Enviar_A_Log "Bajando procesos del usuario ${USUARIO}" ${LOGSCRIPT}      
if [ "${CANTPROC}" -gt 1 ]
then
        if [ "${PID}" ] 2>/dev/null 1>/dev/null
        then
                echo "Matando aplicacion ${USUARIO}."
                kill -9 ${PID}
                echo "Eliminando archivos temporales."
                rm -r ${PATHTMP}/* 2 >/dev/null							# <--- Verifique si borra arch temporales
                echo "Eliminando archivos logs anteriores."
#                find ${PATHLOG} -name "server.log.*" -mtime +5 -exec rm {} \; 2>/dev/null	# <--- Verifique si borra logs
		Enviar_A_Log "Bajando procesos ${NOMBRE}.jar" ${LOGSCRIPT}
        else
                titulo "En este momento no hay en ejecucion de procesos del ${USUARIO}."
        fi
else
        titulo "Los procesos \"${LISTAPROC}\" del usuario ${USUARIO} no estan corriendo."
fi
}

#=============================================================================
# Controlar proceso 
#=============================================================================

titulo ()
{
#set -x 
MENSAJE=$1
echo "-------------------------------------------------------------------------------"
echo "$MENSAJE"
echo "-------------------------------------------------------------------------------"
}

verprocesos ()
{
#set -x 
PROCESOS=$*
CONTADOR=0
FILE_PROC_RUN="/tmp/proc_run"
FILE_PROC_NORUN="/tmp/proc_norun"
>${FILE_PROC_RUN}
>${FILE_PROC_NORUN}

for PROC in $PROCESOS
do
	CANT_PROC=`ps -fu ${USUARIO} | grep -v grep | grep -i "${PROC}" | wc -l`   2>/dev/null 1>/dev/null
	if [ ${CANT_PROC} -ge 1 ]
	then
		ps -fu ${USUARIO} | grep -v grep | grep -i "${PROC}" >>${FILE_PROC_RUN}
		export CONTADOR=`expr ${CONTADOR} "+" 1`
	else
        	echo "Atencion el proceso ${PROC} No esta corriendo.." >>${FILE_PROC_NORUN}
	fi
done

if [ -s ${FILE_PROC_RUN} ] || [ -s ${FILE_PROC_NORUN} ]  2>/dev/null 1>/dev/null
then
	if [ -s ${FILE_PROC_RUN} ]   2>/dev/null 1>/dev/null
	then
		titulo "Chequeando procesos LEVANTADOS.."
		cat ${FILE_PROC_RUN}
		echo " "
		echo "-------------------------------------------------------------------------------"
	else
		if [ -s ${FILE_PROC_NORUN} ]   2>/dev/null 1>/dev/null 
		then
			titulo "Procesos DOWN.."
			cat ${FILE_PROC_NORUN}
		fi
	fi
else
	titulo "Atencion !!! No hay procesos del usuario ${USUARIO} corriendo."
	echo " "
	echo "-------------------------------------------------"
fi

rm ${FILE_PROC_RUN} ${FILE_PROC_NORUN}

}

verproc () 
{
#set -x
export ACCION="VER"
export CANTPROC=`echo $LISTAPROC | wc -w` 
verprocesos $LISTAPROC
titulo "CONTROL DE PROCESOS: \n\t Procesos Controlados: ${CANTPROC} - Usuario: ${USUARIO} - Procesos Levantados: ${CONTADOR}".
}

infoproc ()
{
#set -x
case $ACCION in
        UP)      verproc 
		 if [ "${CANTPROC}" -eq "${CONTADOR}" ]
		 then
		        titulo "Todos los procesos del usuario ${USUARIO} estan ARRIBA."
	 	 else
			titulo "Atencion!!! No se subieron todos los procesos que se esta controlando este script $0."
			Enviar_A_Log "No se subieron todos los procesos ${NOMBRE}.jar" ${LOGSCRIPT}
		 fi
                 ;;

        DOWN)    verproc 
		 if [ "${CONTADOR}" -eq 0 ]
                 then
                        titulo "Todos los procesos del usuario ${USUARIO} esta ABAJO."
                 else
                        titulo "Atencion!!! No se bajaron todos los procesos que se estan controlando con este script $0, verificar."
			Enviar_A_Log "No se bajaron todos los procesos ${NOMBRE}.jar" ${LOGSCRIPT}
                 fi
                 ;;  

        VER)     verproc
                 ;;
esac
}

###############################################################################
###                            Principal                                    ###
###############################################################################
clear

case $OPERACION in
        UPPROC)        downproc ; sleep 2 ; upproc ; sleep 2 ; infoproc ;;
        DOWNPROC)      downproc ; sleep 2 ;infoproc ;;
        VERPROC)       verproc ;;
esac
