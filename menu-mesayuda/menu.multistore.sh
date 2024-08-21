#!/usr/bin/ksh
#set -x
###############################################################################
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Monitorear procesos Multistore en sucursales.          #
# Nombre del programa: menu.multistore.sh                                     #
# Solicitado por.....: Mesa de Ayuda                                          #
# Descripcion........: Activa,desactiva y muestra colas de impresion de un    #
# Fecha de creacion..: 10/07/2012                                             #
# Modificacion.......: 10/07/2012                                             #
###############################################################################

###############################################################################
###                            Variables                                    ###
###############################################################################
export PATHAPL="/tecnol/opmayuda"
export PATHLOG="${PATHAPL}/log"
export USUARIO="`whoami`"
export LOG="${PATHLOG}/logmenu.${USUARIO}.`date +%A`"
export BLNK=`tput blink`
export BOLD=`tput bold`
export END=`tput sgr0`
export REV=`tput smso`
export EREV=`tput rmso`
export SCRIPT="MENU DE MULTISTORE"
export SESION=`who am i | awk ' { print $2 } '`

###############################################################################
###                            Funciones                                    ###
###############################################################################
function ValidarSucursal
{
#set -x
	typeset -Z3 SUC="${1}"
	typeset -Z1 VALIDA=1
	typeset -fu EsNumerico
	export HOST=${SUC}
	EsNumerico ${SUC}
  	[ $? = 1 ] && return 1
	if [ ${SUC} -lt 100 ]
	then
		typeset -Z2 SUC="${1}"
	fi
	for i in `cat /etc/listalnx`
        do
                [ ${SUC} = ${i} ] && VALIDA=0 export HOST=suc${SUC}
		if [ ${VALIDA} = 0 ]
                then
                        return 0
                fi
        done
	if [ ${VALIDA} = 1 ]
        then
        	return 1
        fi
}

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
        ${PATHAPL}/encabezado.sh "MENU DE MULTISTORE"
        echo "${REV}\n\n\n\n\t\t\t\tIngrese el numero de sucursal:${EREV}\c"
        read NROSUC
	ValidarIngreso ${NROSUC}
	Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - Ingreso el numero de Sucursal ${NROSUC}." ${LOGSCRIPT}
	ValidarSucursal ${NROSUC}
	if [ $? = 1 ] 
	then
		echo "\n\n\t\t\t\t${BLNK}SUCURSAL INVALIDA${END}\c"
		Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - Ingreso \"${NRO}\" y es un valor de nro de SUCURSAL INVALIDA." ${LOGSCRIPT}
		echo "\n\n\n\t\t\t\t${BOLD}Presione una tecla para continuar...${END}"
               	read
		exit
	fi
	typeset -Z3 NROSUC
	ping -c3 ${HOST} 1>/dev/null
	if [ $? != 0 ]
	then
		echo "\n\n\t\t\t\t${BLNK}NO HAY COMUNICACION CON ${HOST}!!!${END}"
		Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - SUCURSAL SIN COMUNICACION." ${LOGSCRIPT}
                echo "\n\t\t\t\t${REV}Presione una tecla para continuar...${EREV}"
                read
		exit
	fi
	ssh ${HOST}
        tput sgr0
        exit
done
