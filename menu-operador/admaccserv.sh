#!/usr/bin/ksh
#set -n
#set -x
#clear

##########################################################################################
# Nombre.............: arrancar_1_demonio_wf.sh                                          #
# Autor..............:                                                                   #
# Objetivo...........: Subir y Bajar los demonios.                                       #
# Descripcion........:                                                                   #
# Valores de Retorno.:                                                                   #
# Modificacion.......: 31/05/2005                                                        #
# Documentacion......:                                                                   #
##########################################################################################


###########################################################################################
#                                      VARIABLES                                          #
###########################################################################################

export DEST="$1"

#export USER_ACT="`who am i | awk '{ print $1 }'`"
export USER_ACT="ope1"
export FPATH="/tecnol/funciones"
export HORA="`date +%H:%M:%S`"

export SERVIDOR="`hostname`"
export PATHSCR="/tecnol/operador"
export PATHSCRLOG="${PATHSCR}/log"
export LOGSCRIPT="${PATHSCRLOG}/${SERVIDOR}.${FECHA}.log"

################   LISTA DE SERVIDORES   ####################

export LISTAAIXCEN="`cat /etc/listaaixcen`"
export LISTACL="`cat /etc/listacl`"
export LISTACOTDIG="`cat /etc/listacotdig`"
export LISTALNX="`cat /etc/listalnx`"
export LISTALNXC="`cat /etc/listalnxc`"
export LISTALNXCEN="`cat /etc/listalnxcen`"

>/tmp/listalnxc

for SUCC in ${LISTALNXC}
do
	echo ${SUCC}c >>/tmp/listalnxc
done

export LISTALNXC="`cat /tmp/listalnxc`"

FECHA=`date '+%d/%m/%Y'`
PATH_TMP="/tmp"
CTRLUSER="coto" #`whoami`

export PATH_TMP="/tmp"
export MENU_TMP="$PATH_TMP/list_menu"
export ARCH_TMP="$PATH_TMP/list_a_impr"

export SERVER="${PATH_TMP}/LISTA_SERVER.txt"                        #  <-- Archivo con la lista de server a controlar


>$SERVER
#export LISTA_SERVER="`cat ${SERVER}`"


export BOLD=`tput bold`                 #Coloca la pantalla en modo de realce 
export REV=`tput smso`                  #Coloca la pantalla en modo de vídeo inverso 
export EREV=`tput rmso`                 #
export END=`tput sgr0`                  #Después de usar uno de los atributos de arriba, se usa este para restaurar la pantalla a su modo normal
export BLNK=`tput blink`                #Los caracteres tecleados aparecerán intermitentes
export SVCRSR=`tput sc`         #Save Cursor position - Graba la posición del cursor 
export RSTCSR=`tput rc`         #Restore Cursor position - Coloca el cursor en la posición marcada por el último sc
export RST=`tput reset`         #Limpia la pantalla y restaura sus definiciones de acuerdo con el terminfo o sea, la pantalla vuelve al patrón definido x la variab $TERM  
export UNDER=`tput smul`        #Habilita underline en la terminal
export EUNDER=`tput rmul`       #Deshabilita underline en la terminal


###########################################################################################
#                                      FUNCIONES                                          #
###########################################################################################

encabezado()
{
export NOMBRE="${USER_ACT}"
#export NOMBRE="`grep ^${LOGNAME} /etc/passwd | cut -f5 -d: | cut -c1-30`"
export SUCURSAL="`uname -n`"
export MODULO="${1}"
clear
echo
echo "\t${BOLD}################################################################################################${END}"
printf "\t%-5s %-30s %-10s %-22s %-10s %-25s %-1s \n" \
"${BOLD}#${END}" "COTO C.I.C.S.A."  "${UNDER}Fecha${EUNDER}:" ${FECHA} "${UNDER}Hora${EUNDER}:" ${HORA} "${BOLD}#${END}"
printf "\t%-5s %-9s %-26s %-10s %-60s %-1s \n" \
"${BOLD}#${END}" "${UNDER}Usuario${EUNDER}:" "${REV}${NOMBRE}${EREV}" "${UNDER}Sucursal${EUNDER}:" "${REV}${SUCURSAL}${EREV}" "${BOLD}#${END}"
printf "\t%-5s %-65s %-10s %-32s %-1s\n" \
"${BOLD}#${END}" "${REV}MENU DE OPERACIONES${EREV}" "${UNDER}Modulo${EUNDER}:" "${REV}${MODULO}${EREV}" "${BOLD}#${END}"
echo "\t${BOLD}################################################################################################${END}"
}



function PTecla
{
#set -x
        echo "\tPresione una tecla para continuar"
        read cont
#       clear
}

titulo ()
{
#set -x
MENSAJE=$1
echo "-------------------------------------------------------------------------------"
echo "$MENSAJE"
echo "-------------------------------------------------------------------------------"
}

if [ ${CTRLUSER} != coto ]
then
        >${FILE_TMP_ERR}
        echo "Atencion!!! Los demonios se estan intentando levantar" >>${FILE_TMP} &
        echo "con un usuario que no es coto. Verificar"   >>${FILE_TMP} &
        exit
fi


destino_server()
{
export DEST=$1
if  [ ${DEST} = "SUCURSAL" ]
then
        echo "${LISTALNX} ${LISTALNXC}" >>${SERVER}
else
        if [ ${DEST} = "CENTRAL" ]
        then
                echo "${LISTAAIXCEN} ${LISTACL} ${LISTACOTDIG} ${LISTALNXCEN}" >>${SERVER}
        fi
fi
}

creamenu()
{
#set -x

if [ -s ${SERVER} ]  2>/dev/null
then
        echo "\t============================================================================================"
        echo "\t Servers en ${PATH_TMP}/LISTA_SERVER.txt"
        echo "\t--------------------------------------------------------------------------------------------"
        echo "\t Importante: Si el demonio que busca no esta en esta lista agreguelo en el siguente archivo"
        echo "\t             ${PATH_TMP}/LISTA_SERVER.txt"
        echo "\t============================================================================================"
        LISTAR=`cat ${SERVER} | awk '{print sprintf("\t%02d)%s", NR , $1)}'`
        CANT_COL=3
        COUNT=1
                for LIST in ${LISTAR}
                do
                        if [ $COUNT = $CANT_COL ]
                        then
                                COUNT=1
                                echo "\t\t${LIST}\t\n"
                        else
                                COUNT=`expr $COUNT '+' 1`
                                echo "\t\t${LIST}\t\c"
                        fi      
                done
        echo " "
        cat ${SERVER} | awk '{print sprintf("\t%02d)%s", NR , $1)}' >>${MENU_TMP}
else
        echo "Atencion no existe el archivo ${PATH_TMP}/LISTA_SERVER.txt con la lista de demonios"
        PTecla
fi
}




###########################################################################################
#                                      PRINCIPALES                                        #
###########################################################################################

clear 


while true [ ${SERV_OK} = 0 ]
do
${PATHSCR}/encabezado.sh "Menu para Acceso a Servidores"  

echo "\t======================================================================="
echo "\tIngrese el numero de sucursal (ej:02,159,215) "
echo "\to el nombre de Servidor (gdmp, sp9):"
echo "\tIngrese s|S para salir : \c"
read CONF
echo "\t======================================================================="

#destino_server $CONF

if [ ${DEST} = "CENTRAL" ]
then 
#	echo ${LISTAAIXCEN} ${LISTALNXCEN}
	for SERV in ${LISTAAIXCEN} ${LISTALNXCEN}
	do
	#	echo $SERV
		if [ ${SERV} = ${CONF} ] 2>/dev/null 1>/dev/null
		then
			export SERV_OK=0
		else
			export SERV_OK=1	
		fi
	done
	read
else
	if [ ${DEST} = "SUCURSAL" ]
	then
#	echo ${LISTALNX} ${LISTALNXC}
		for SERV in ${LISTALNX} ${LISTALNXC}
		do
			if [ ${SERV} = ${CONF} ] 2>/dev/null 1>/dev/null
        	        then
                        	export SERV_OK=0
				break
	                else
                	        export SERV_OK=1
        	        fi
		done
		read
	fi
fi

if [ ${SERV_OK} = 0 ] 
then
#		echo ${SERV}
                titulo "Usted selecciono la sucursal suc${SERV}"
                echo "Si es correcto, presione una tecla para continuar..."
                PTecla
                su - ${USER_ACT} -c "ssh suc${SERV}"
	else 
#		echo ${SERV}
	        titulo "Error Usted Ingreso un valor Invalida \"${SERV}\""
               	echo "Verifiquelo y vuelva a intentarlo"
		echo "presione una tecla para continuar..."
		PTecla	
fi
done

rm /tmp/listalnxc
