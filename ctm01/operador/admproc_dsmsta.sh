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
###                            Variables    Generales                       ###
###############################################################################

export FPATH="/tecnol/funciones"
export FECHA="`date +%Y%m%d`"
#export SUC="`uname -n | sed 's/suc//'`"
export SUC="`hostname`"
export OPERACION=${1}
export PATHSCR="/tecnol/operador"					
export PATHSCRLOG="${PATHSCR}/log"
export LOGSCRIPT="${PATHSCRLOG}/${NOMBRE}.${FECHA}.log"

##############################################################################
#    Variable personales - Ingrese los datos de lo que desea controlar
##############################################################################

export NOMBRE="dsmsta"
export PROGRAMA="admproc_dsmsta"
export USUARIO="root"								# <--- Usuario del proceso a Controlar
export PATHPRC="/tecnol/operador" 						# <--- Directorio raiz del proceso a controlar
export PATHTMP="${PATHAPL}/tmp"							# <--- Directorio temporal
export PATHLOG="${PATHAPL}/log"							# <--- Directorio de log 

#--------------     Procesos a controlar ( que buscar en el OS ) ------------#

export LISTAPROC="dsmsta"                        				# <--- Ingresar los procesos que se desean controlar
export CANTPROC=`echo $LISTAPROC | wc -w`        				# Se hardcodea porque se necesita controlar 1 proceso

#--------------     Forma de Buscar los Id de Procesos a controlar   --------#

export PID=`ps -fu ${USUARIO} | grep -v grep | grep -v ${PROGRAMA} | grep -v ${0} | grep "${NOMBRE} " | grep -i "quiet" | awk '{print $2 }' |  sort -r`  # <--- Como se busca el proceso especificamente

export LINEPROCESO=`ps -fu ${USUARIO} | grep -v grep | grep -v ${PROGRAMA} | grep -v ${0} | grep "${NOMBRE} " | grep -i "quiet"`

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
#  Subir proceso
#=============================================================================

upproc ()
{
#set -x
#echo "Ejecutando funcion upproc"
export ACCION="UP"
titulo "Levantando procesos del ${USUARIO}, aguarde por favor.."
Enviar_A_Log "Levantando procesos del usuario ${USUARIO}" ${LOGSCRIPT}      
cd /usr/tivoli/tsm/StorageAgent/bin
nohup dsmsta quiet &
Enviar_A_Log "Levantado procesos ${NOMBRE}" ${LOGSCRIPT}
#echo "11111111111111111111111111111111111111111111"
#read
}

#=============================================================================
#  Bajar proceso
#=============================================================================

downproc ()
{
#set -x
#echo "########################################################################"
#echo "######  downproc  ######  downproc  ######  downproc  ######  downproc  "
#echo "########################################################################"
#echo "Ejecutando funcion downproc"
export ACCION="DOWN"
verproc &
titulo "Bajando procesos ${NOMBRE} con el ${USUARIO}, aguarde por favor.."
Enviar_A_Log "Bajando procesos ${NOMBRE} con el usuario ${USUARIO}" ${LOGSCRIPT}      
if [ "${CANTPROC}" -ge 1 ]
then
        if [ "${PID}" ] 2>/dev/null 1>/dev/null
        then
                echo "Matando proceso ${PID} de ${NOMBRE} del usuario ${USUARIO}."
                kill -9 ${PID}
                # echo "Eliminando archivos temporales en /tmp"
                rm -r ${PATHTMP}/proc_* 2>/dev/null							# <--- Verifique si borra arch temporales
                # echo "Eliminando archivos logs anteriores."
                find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +5 -exec rm {} \; 2>/dev/null		# <--- Verifique si borra logs
		Enviar_A_Log "Bajando procesos ${NOMBRE}" ${LOGSCRIPT}
        else
                titulo "En este momento no hay procesos ${NOMBRE} en ejecucion del usuario ${USUARIO}."
        fi
else
        titulo "Los procesos \"${LISTAPROC}\" del usuario ${USUARIO} no estan corriendo."
fi
#echo "########################################################################"
#echo "######  downproc  ######  downproc  ######  downproc  ######  downproc  "
#echo "########################################################################"
#read
}

#=============================================================================
# Mostrar encabezado 
#=============================================================================

titulo ()
{
#set -x 
#echo "titulo"
MENSAJE=$1
echo "-------------------------------------------------------------------------------"
echo "$MENSAJE"
echo "-------------------------------------------------------------------------------"
}

#=============================================================================
#  Ver proceso
#=============================================================================

verprocesos ()
{
#set -x 
#echo "########################################################################"
#echo " ####### verprocesos ####### verprocesos ####### verprocesos ####### verprocesos"
#echo "########################################################################"
#echo "Ejecutando funcion verproceso"
PROCESOS="$*"
echo "$*"
CONTADOR=0
FILE_PROC_RUN="/tmp/proc_run"
FILE_PROC_NORUN="/tmp/proc_norun"
>${FILE_PROC_RUN}
>${FILE_PROC_NORUN}

for PROC in $PROCESOS
do
	CANT_PROC=`ps -fu ${USUARIO} | grep -v grep | grep -v ${PROGRAMA} | grep -v "${PATHPRC}" | grep -v ksh | grep -v ${0} | grep -i "${PROC}" | wc -l `
	echo "veo la cantidad de procesos --> $CANT_PROC"
	if [ ${CANT_PROC} -ge 1 ]
	then
		ps -fu ${USUARIO} | grep -v grep | grep -v ${PROGRAMA} | grep -v "${PATHPRC}" | grep -v ksh | grep -v ${0} | grep -i "${PROC}" >>${FILE_PROC_RUN}
		#read
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

rm ${FILE_PROC_RUN} ${FILE_PROC_NORUN} 2>/dev/null 1>/dev/null
#echo "########################################################################"
#echo " ####### verprocesos ####### verprocesos ####### verprocesos ####### verprocesos"
#echo "########################################################################"
#read

}

#=============================================================================
#  Ver proceso
#=============================================================================

verproc () 
{
#set -x
#echo "########################################################################"
#echo "###### verproc ###### verproc ###### verproc ###### verproc ###### verproc"
#echo "########################################################################"
#echo "Ejecutando funcion verproc"
export ACCION="VER"
export CANTPROC=`echo $LISTAPROC | wc -w` 
verprocesos $LISTAPROC
titulo "CONTROL DE PROCESOS: \n\t Procesos Controlados: ${CANTPROC} - Usuario: ${USUARIO} - Procesos Levantados: ${CONTADOR}".

#echo "########################################################################"
#echo "###### verproc ###### verproc ###### verproc ###### verproc ###### verproc"
#echo "########################################################################"
#read
}

#=============================================================================
#  Informar proceso
#=============================================================================

infoproc ()
{
#set -x
#echo "########################################################################"
#echo "####### infoproc ####### infoproc ####### infoproc ####### infoproc "
#echo "########################################################################"
#echo "Ejecutando funcion infoproc"
case $ACCION in
        UP)      verproc 
		 if [ "${CANTPROC}" -eq "${CONTADOR}" ]
		 then
		        titulo "Todos los procesos del usuario ${USUARIO} estan ARRIBA."
	 	 else
			titulo "Atencion!!! No se subieron todos los procesos que se esta controlando este script $0."
			Enviar_A_Log "No se subieron todos los procesos ${NOMBRE}" ${LOGSCRIPT}
		 fi
                 ;;

        DOWN)    verproc 
		 if [ "${CONTADOR}" -eq 0 ]
                 then
                        titulo "Todos los procesos del usuario ${USUARIO} esta ABAJO."
                 else
                        titulo "Atencion!!! No se bajaron todos los procesos que se estan controlando con este script $0, verificar."
			Enviar_A_Log "No se bajaron todos los procesos ${NOMBRE}" ${LOGSCRIPT}
                 fi
                 ;;  

        VER)     verproc
                 ;;
esac
#echo "########################################################################"
#echo "####### infoproc ####### infoproc ####### infoproc ####### infoproc "
#echo "########################################################################"
#read
}

###############################################################################
###                            Principal                                    ###
###############################################################################
clear

case $OPERACION in
        UPPROC)        downproc ; sleep 2 ; upproc ; sleep 2 ; infoproc ; teclacontinuar ;;
        DOWNPROC)      downproc ; sleep 2 ;infoproc ; teclacontinuar ;;
        VERPROC)       verproc ; teclacontinuar ;;
esac
