#!/usr/bin/ksh
###############################################################################
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Cerrar el numero de sucursal ingresada.                #
# Nombre del programa: cierresf.sh                                            #
# Solicitado por.....: Omar Del Negro                                         #
# Descripcion........: Ejecuta el comando ctmcontb en forma remota.           #
# Fecha de creacion..: 13/03/2008                                             #
# Modificacion.......: DD/MM/AAAA                                             #
###############################################################################
#set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export PATHAPL="/home/clarrosa/mesa"
export PATHLOG="${PATHAPL}/log"
export USUARIO="`whoami`"
export LOG="${PATHLOG}/logcierre.`date +%A`"
export EMPRESA=${1}
export BLNK=`tput blink`
export BOLD=`tput bold`
export END=`tput sgr0`
export REV=`tput smso`
export EREV=`tput rmso`

###############################################################################
###                            Funciones                                    ###
###############################################################################

function AgregarCondicion
{
	typeset SO="${1}"
	typeset SUC="${2}"
	typeset COND="${3}"
	typeset -s EST=""
	case ${TIPO} in
	   (L)	EST=`sudo ssh ${SUC} '( su - ctmsrv "-c ctmcontb -ADD '${COND}' 'ODAT'" 1>/dev/null && echo OK || echo ERROR )'` ;;
	   (A)	EST=`sudo rsh ${SUC} '( su - ctmsrv "-c ctmcontb -ADD '${COND}' 'ODAT'" 1>/dev/null && echo OK || echo ERROR )'` ;;
	   (*)	default ;;
	esac
 	if [ "${EST}" = "OK" ]
  	then
		return 0
  	else
		return 1
	fi
}

function ValidarSucursal
{
	typeset -Z3 SUC="${1}"
	typeset -Z1 VALIDA=1
	typeset -fu EsNumerico
	export HOST=${SUC}
	export TIPO=0
	EsNumerico ${SUC}
  	[ $? = 1 ] && return 1
	if [ ${SUC} -lt 100 ]
	then
		typeset -Z2 SUC="${1}"
	fi
	for i in `cat /etc/listasuc`
	do
		[ ${SUC} = ${i} ] && VALIDA=0 export HOST=suc${SUC} export TIPO="A"
	        if [ ${VALIDA} = 0 ]
        	then
                	return 0
        	fi
	done
	for i in `cat /etc/listagdm`
        do
                [ ${SUC} = ${i} ] && VALIDA=0  export HOST=gdm${SUC}  export TIPO="A"
		if [ ${VALIDA} = 0 ]
                then
                        return 0
                fi
        done
	for i in `cat /etc/listalnx`
        do
                [ ${SUC} = ${i} ] && VALIDA=0 export HOST=suc${SUC} export TIPO="L"
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

###############################################################################
#				Principal                                     #
###############################################################################
while true
do
        ${PATHAPL}/encabezado.sh "CIERRE DE SUCURSALES"
        echo "${REV}\n\n\n\n\t\t\t\tIngrese el numero de sucursal a cerrar:${EREV}\c"
        read NROSUC
	ValidarSucursal ${NROSUC}
	if [ $? = 1 ] 
	then
		echo "\n\n\t\t\t\t${BLNK}SUCURSAL INVALIDA${END}\c"
		echo "\n\n\n\t\t\t\t${BOLD}Presione una tecla para continuar...${END}"
               	read TECLA
		exit
	fi
	if [ ${HOST} = "suc50" ]
	then
		HOST=nodo9
	fi
	typeset -Z3 NROSUC
 	while true
        do
        	${PATHAPL}/encabezado.sh "CIERRE DE SUC${NROSUC}"
                echo "\n\n\n\n\n\t\t\t\t${REV}Confirma cierre de sucursal ${NROSUC} [S/N]: ${EREV}\c"
                read OPCION
                case ${OPCION} in
               		N|n)    exit ;;
                      	S|s)    break ;;
                     	*)      ;;
               	esac    
	done
        case ${EMPRESA} in
		T)	#AgregarCondicion ${TIPO} ${HOST} MANUAL_SF${NROSUC}CI005
			AgregarCondicion ${TIPO} ${HOST} CFL${NROSUC}CI005
			if [ $? = 0 ]
                       	then
                       		echo "\n\t\t\t\t${BOLD}EMPRESA 1 CERRADA CORRECTAMENTE${END}"
                              	Enviar_A_Log "${USUARIO} - Cerro OK empresa 1 en sucursal ${NROSUC}" ${LOG}
                        else
                        	echo "\n\t\t\t\t\t\t${BLNK}EMPRESA 1 CERRADA CON ERRORES!!!!${END}"
                        	Enviar_A_Log "${USUARIO} - ERROR al cerrar empresa 1 en sucursal ${NROSUC}" ${LOG}
                       	fi
                       	AgregarCondicion ${TIPO} ${HOST} CFL${NROSUC}CI010
			#AgregarCondicion ${TIPO} ${HOST} MANUAL_SF${NROSUC}CI010
                       	if [ $? = 0 ]
              		then
                        	echo "\n\t\t\t\t${BOLD}EMPRESA 2 CERRADA CORRECTAMENTE${END}"
                               	Enviar_A_Log "${USUARIO} - Cerro OK empresa 2 en sucursal ${NROSUC}" ${LOG}
                        else
                        	echo "\n\t\t\t\t${BLNK}EMPRESA 2 CERRADA CON ERRORES!!!!${END}"
                               	Enviar_A_Log "${USUARIO} - ERROR al cerrar empresa 2 en sucursal ${NROSUC}" ${LOG}
                        fi
			echo "\n\n\n\t\t\t\t${BLNK}Presione una tecla para continuar...${END}"
			read TECLA
                        exit ;;

		1)	#AgregarCondicion ${TIPO} ${HOST} MANUAL_SF${NROSUC}CI005
			AgregarCondicion ${TIPO} ${HOST} CFL${NROSUC}CI005    
			if [ $? = 0 ]
                        then    
                                echo "\n\t\t\t\t${BOLD}EMPRESA 1 CERRADA CORRECTAMENTE${END}"
                                Enviar_A_Log "${USUARIO} - Cerro OK empresa 1 en sucursal ${NROSUC}" ${LOG}
                        else
                                echo "\n\t\t\t\t\t\t${BLNK}EMPRESA 1 CERRADA CON ERRORES!!!!${END}"
                                Enviar_A_Log "${USUARIO} - ERROR al cerrar empresa 1 en sucursal ${NROSUC}" ${LOG}
                        fi
			echo "\n\n\n\t\t\t\t\t\t${BLNK}Presione una tecla para continuar...${END}"
                        read TECLA
			exit;;

		2)	#AgregarCondicion ${TIPO} ${HOST} MANUAL_SF${NROSUC}CI010
			AgregarCondicion ${TIPO} ${HOST} CFL${NROSUC}CI010 
			if [ $? = 0 ]
                        then    
                                echo "\n\t\t\t\t${BOLD}EMPRESA 2 CERRADA CORRECTAMENTE${END}"
                                Enviar_A_Log "${USUARIO} - Cerro OK empresa 2 en sucursal ${NROSUC}" ${LOG}
                        else
                                echo "\n\t\t\t\t\t\t${BLNK}EMPRESA 2 CERRADA CON ERRORES!!!!${END}"
                                Enviar_A_Log "${USUARIO} - ERROR al cerrar empresa 2 en sucursal ${NROSUC}" ${LOG}
                        fi
			echo "\n\n\n\t\t\t\t\t\t${BLNK}Presione una tecla para continuar...${END}"
                        read TECLA
			exit ;;

		*)	break ;;
	esac
done
