#!/usr/bin/ksh

###############################################################################
# Aplicacion.........: MENU OPERACIONES                                       #
# Grupo..............:                                                        #
# Autor..............: Cerizola Hugo                                          #
# Objetivo...........: Manejar servicios de este servidor                     # 
# Nombre del programa: admserv_[nombredelservicio].sh                          #               
# Solicitado por.....:                                                        #
# Descripcion........: Menu para administrar servicios del servidor           # 
# Creacion...........: 18/12/2013                                             #
# Modificacion.......: DD/MM/AAAA                                             #
###############################################################################

#set -x
clear

###############################################################################
###                            Variables                                    ###
###############################################################################
export FPATH="/tecnol/funciones"
export FECHA="`date +%Y%m%d`"
export SERVIDOR="`hostname`"
export OPERACION=${1}
export SERVICIO="samba"								# <--- Nombre del servicio a controlar
export PATHSCR="/tecnol/operador"					
export PATHSCRLOG="${PATHSCR}/log"
export LOGSCRIPT="${PATHSCRLOG}/${SERVICIO}.${FECHA}.log"

##############################################################################
#   Ingrese los datos de lo que desea controlar
##############################################################################

export SERVICIO="samba"								# <--- Usuario del servicios a Controlar
export USUARIO="root"

#--------------     Servicios a controlar ( que buscar en el OS ) ------------#
export LISTASERV="nmbd winbind smbd"                        			 # <--- Ingresar los servicios que se desean controlar
export CANTSERV=`echo $LISTASERV | wc -w` 

#--------------     Forma de Buscar los Id de Servicios a controlar   --------#
export PID="`for ID in $LISTASERV ; do ps -fu ${USUARIO} | grep ${ID} | awk '{ print $2 }' | sort -r ; done`"  # <--- Como se busca el servicio
#export CANT_PID="`echo ${PID} | wc -w`"

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Borrar
autoload Enviar_A_Log

#=============================================================================
#  Pulse una tecla para continuar   
#=============================================================================

teclacontinuar()
{
#set -x
tput ed
echo  "\t\t${REV}Presione una tecla para continuar...${EREV}"
read
}

#=============================================================================
#  Subir servicio
#=============================================================================

upserv ()
{
#set -x
export ACCION="UP"
titulo "Levantando servicios  ${SERVICIO}, aguarde por favor.."
Enviar_A_Log "Levantando servicios ${SERVICIO}" ${LOGSCRIPT}      

/opt/pware64/sbin/nmbd -D
/opt/pware64/sbin/smbd -D
/opt/pware64/sbin/winbindd -D

Enviar_A_Log "Levantando servicios ${SERVICIO}" ${LOGSCRIPT}
}

#=============================================================================
#  Bajar servicio
#=============================================================================

downserv ()
{
#set -x
export ACCION="DOWN"
#verserv &
titulo "Bajando servicios ${SERVICIO}, aguarde por favor.."

smbcontrol nmbd shutdown
smbcontrol winbind shutdown
smbcontrol smbd shutdown 

Enviar_A_Log "Bajando servicios ${SERVICIO}" ${LOGSCRIPT}      

if [ "${CANTSERV}" -gt 1 ]
then
        if [ "${PID}" ] 2>/dev/null 1>/dev/null
        then
                echo "Matando Servicios ${SERVICIO}."
                kill -9 ${PID} 2>/dev/null 1>/dev/null
		if [ $? = 0 ]
		then
		Enviar_A_Log "Todos los servicios ${SERVICIO} estan abajo" ${LOGSCRIPT}
		else
		Enviar_A_Log "Atencion, aun ahi en ejecucio servicios ${SERVICIO}!!!" ${LOGSCRIPT}
		fi
        else
                titulo "En este momento no hay en ejecucion servicios ${SERVICIO}."
        fi
else
        titulo "Los servicios \"${LISTASERV}\" de ${SERVICIO} no estan corriendo."
fi
}

#=============================================================================
# Controlar servicios
#=============================================================================

titulo ()
{
#set -x 
MENSAJE=$1
echo "-------------------------------------------------------------------------------"
echo "$MENSAJE"
echo "-------------------------------------------------------------------------------"
}

verservicios ()
{
#set -x 
SERV=$*
CONTADOR=0
FILE_SERV_RUN="/tmp/serv_run"
FILE_SERV_NORUN="/tmp/serv_norun"
>${FILE_SERV_RUN}
>${FILE_SERV_NORUN}

for SERV in ${LISTASERV}
do
	CANT_SERV=`ps -fu ${USUARIO} | grep -v grep | grep -i "${SERV}" | wc -l`   2>/dev/null 1>/dev/null
	if [ ${CANT_SERV} -ge 1 ]
	then
		ps -fu ${USUARIO} | grep -v grep | grep -i "${SERV}" >>${FILE_SERV_RUN}
		export CONTADOR=`expr ${CONTADOR} "+" 1`
	else
        	echo "Atencion el servicios ${SERV} de ${SERVICIO} No esta corriendo.." >>${FILE_SERV_NORUN}
	fi
done

if [ -s ${FILE_SERV_RUN} ] || [ -s ${FILE_SERV_NORUN} ]  2>/dev/null 1>/dev/null
then
	if [ -s ${FILE_SERV_RUN} ]   2>/dev/null 1>/dev/null
	then
		titulo "Chequeando servicios LEVANTADOS.."
		cat ${FILE_SERV_RUN}
		echo " "
		echo "-------------------------------------------------------------------------------"
	else
		if [ -s ${FILE_SERV_NORUN} ]   2>/dev/null 1>/dev/null 
		then
			titulo "Servicios DOWN.."
			cat ${FILE_SERV_NORUN}
		fi
	fi
else
	titulo "Atencion !!! No hay servicios ${SERVICIO} corriendo."
	echo " "
	echo "-------------------------------------------------"
fi
export CONTADOR="`cat ${FILE_SERV_RUN} | wc -l `"

rm ${FILE_SERV_RUN} ${FILE_SERV_NORUN}
teclacontinuar

}

verserv () 
{
#set -x
export ACCION="VER"
export CANTSERV=`echo $LISTASERV | wc -w` 
verservicios $LISTASERV
titulo "CONTROL DE SERVICIO: \n\t Servicios Controlados: ${CANTSERV} \n\t Usuario con el que corren: ${USUARIO} \n\t Servicios Levantados: ${CONTADOR}."
teclacontinuar
}

infoserv ()
{
#set -x
case $ACCION in
        UP)      verserv 
		 if [ "${CANTSERV}" -le "${CONTADOR}" ]
		 then
		        titulo "Todos los servicios del usuario ${SERVICIO} estan ARRIBA."
	 	 else
			titulo "Atencion!!! No se subieron todos los servicios que se esta controlando este script $0."
			Enviar_A_Log "No se subieron todos los servicios ${SERVICIO}.jar" ${LOGSCRIPT}
		 fi
                 ;;

        DOWN)    verserv 
		 if [ "${CONTADOR}" -eq 0 ]
                 then
                        titulo "Todos los servicios del usuario ${SERVICIO} esta ABAJO."
                 else
                        titulo "Atencion!!! No se bajaron todos los servicios que se estan controlando con este script $0, verificar."
			Enviar_A_Log "No se bajaron todos los servicios ${SERVICIO}.jar" ${LOGSCRIPT}
                 fi
                 ;;  

        VER)     verserv
                 ;;
esac
}

###############################################################################
###                            Principal                                    ###
###############################################################################
clear

case $OPERACION in
        UPSERV)        downserv ; sleep 2 ; upserv ; sleep 2 ; infoserv ;;
        DOWNSERV)      downserv ; sleep 2 ; infoserv  ;;
        VERSERV)       verserv ;;
esac
