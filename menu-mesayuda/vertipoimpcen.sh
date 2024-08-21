#!/usr/bin/ksh
#############################################################################
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Administrar colas de impresion.                        #
# Nombre del programa: vertipoimpcen.sh                                       #
# Solicitado por.....: Omar Del Negro                                         #
# Descripcion........: Muestra el tipo de cola de impresion (lpd o red).      #
# Fecha de creacion..: 14/04/2008                                             #
# Modificacion.......: 27/06/2012 - Se adapta el script para que el usuario   #
#                      utilice el comando sudo para las ejecuciones remotas.  #
#                      Proyecto PCI_LIN_02.                                   #
###############################################################################
#set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export PATHAPL="/tecnol/opmayuda"
export PATHLOG="${PATHAPL}/log"
export HOST="${1}"
export USUARIO="`whoami`"
export LOG="${PATHLOG}/logmenu.${USUARIO}.`date +%A`"
export BLNK=`tput blink`
export BOLD=`tput bold`
export END=`tput sgr0`
export REV=`tput smso`
export EREV=`tput rmso`
export SCRIPT="MENU DE IMPRESION"
export SESION=`who am i | awk ' { print $2 } '`

###############################################################################
###                            Funciones                                    ###
###############################################################################
function ValidarIngreso
{
#set -x
export INGRESO=${1}
if [ -Z ${INGRESO} ] 2>/dev/null
then
                echo "\n\n\t\t\t\t${BLNK}Ingrese un valor.. para continuar...${END}"
                break
        else
                continue
        fi
}

###############################################################################
#				Principal                                     #
###############################################################################
while true
do
        ${PATHAPL}/encabezado.sh "MENU DE IMPRESION"
	ping -c3 ${HOST} 1>/dev/null
	if [ $? != 0 ]
	then
		echo "\n\n\t\t\t\t${BLNK}NO HAY COMUNICACION CON ${HOST}!!!${END}"
		Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - SUCURSAL SIN COMUNICACION." ${LOGSCRIPT}
                echo "\n\t\t\t\t${REV}Presione una tecla para continuar...${EREV}"
                read
		exit
	fi
 	while true
        do
        	${PATHAPL}/encabezado.sh "IMPRESORAS DE SUC${NROSUC}"
		COLAS=`ssh ${HOST} 'lpstat -a' | awk ' { print $1 } '`
		for i in ${COLAS}
                do
                	TIPO=`ssh ${HOST} "lpstat -s"|grep "device for $i: lpd" > /dev/null 2>&1  && echo SI || echo NO`
                        IP=`ssh ${HOST} "grep $i /etc/hosts" | awk ' { print $1 } '`
                        if [ ${TIPO} = "SI" ]
                        then
                        	echo "\t\tCola: $i            Tipo: LPD         Ip: ${IP}"
                        else
                                echo "\t\tCola: $i            Tipo: RED         Ip: ${IP}"
                        fi
                done
                echo "\n\t\t\t\t${REV}Presione una tecla para continuar...${EREV}"
                read
		exit
	done
done
