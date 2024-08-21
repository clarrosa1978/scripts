#!/usr/bin/ksh
###############################################################################
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Cerrar el numero de sucursal ingresada.                #
# Nombre del programa: checkbalanzas.sh                                       #
# Solicitado por.....: Omar Del Negro                                         #
# Descripcion........: Verifica la ip asignada al host PCBALANZAS de una      #
#                      sucursal.                                              #
# Fecha de creacion..: 18/03/2008                                             #
# Modificacion.......: DD/MM/AAAA                                             #
###############################################################################
#set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export PATHAPL="/home/hdesk"
export PATHLOG="${PATHAPL}/log"
export USUARIO="`whoami`"
export LOG="${PATHLOG}/logmenu.${USUARIO}.`date +%A`"
export IP=""
export ALIAS=""
export BLNK=`tput blink`
export BOLD=`tput bold`
export END=`tput sgr0`
export SCRIPT="MENU DE BALANZAS"

###############################################################################
###                            Funciones                                    ###
###############################################################################

function ValidarSucursal
{
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
	for i in `cat /etc/listasuc`
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

###############################################################################
#				Principal                                     #
###############################################################################
while true
do
        ${PATHAPL}/encabezado.sh "MENU DE BALANZAS"
        echo "${REV}\n\n\n\t\t\t\t Ingrese el numero de sucursal [S|s]: ${EREV}\c"
        read NROSUC
	[ ${NROSUC} ] || continue
	[ ${NROSUC} = "s" -o ${NROSUC} = "S" ] && exit 
	ValidarSucursal ${NROSUC}
	if [ $? = 1 ] 
	then
		echo "\n\n\t\t${BLNK}SUCURSAL INVALIDA${END}\c"
		echo "\n${REV}Presione una tecla para continuar...${END}"
                read TECLA
		continue
	fi
	if [ ${HOST} = "suc50" ]
	then
		HOST=nodo9
	fi
	typeset -Z3 NROSUC
 	while true
        do
		${PATHAPL}/encabezado.sh "BALANZAS EN ${HOST}"
                echo "\n\n\n\t\t\t\t${REV}Ingrese la IP de la pc de balanzas [S|s]: ${EREV}\c"
                read IP
		[ ${IP} ] || continue
		[ ${IP} = "s" -o ${IP} = "S" ] && exit
		IPFORM="`echo ${IP} | awk -F, ' { print $1 } ' | sed 's/\.//g'`"
		EsNumerico ${IPFORM}
		if [ $? != 0 ]
		then
			echo "\n\n\t\t\t\t${BLNK}La ip ingresada no es valida!!!${END}"
                        echo "\n\n\n\t\t\t\t${REV}Presione una tecla para continuar...${END}"
                        read TECLA
                        continue
		fi
		POC="`echo ${IP} | awk -F'.' ' { if ( $1 <= 256 )  { if ( $1 >= 0 ) { print $1 } } } '`"
		SOC="`echo ${IP} | awk -F'.' ' { if ( $2 <= 256 )  { if ( $2 >= 0 ) { print $2 } } } '`"
		TOC="`echo ${IP} | awk -F'.' ' { if ( $3 <= 256 )  { if ( $3 >= 0 ) { print $3 } } } '`"
		COC="`echo ${IP} | awk -F'.' ' { if ( $4 <= 256 )  { if ( $4 >= 0 ) { print $4 } } } '`"
		if [ ${POC} ] && [ ${SOC} ] && [ ${TOC} ] && [ ${COC} ] && [ "`echo ${IP}|sed 's/[0-9]//g'|wc -kc|sed 's/ //g'`" = 4 ]
		then
			EST=`rsh ${HOST} '( ping -c1 '${IP}' 1>/dev/null && echo OK || echo ERROR )'`
                        if [ ${EST} = "ERROR" ]
                        then
                                echo "\n\n\t\t\t\t${BLNK}La pc con ip ${IP} NO responde!!!${END}"
                                echo "\t\t\t${BOLD}Verificar con la sucursal si la ip corresponde a la pc de balanzas${END}"
                                echo "\t\t\t${BOLD}Si es incorrecta llamar a OPERACIONES para que la cambie en el servidor${END}"
                                echo "\n\n\n\t\t\t\t${REV}Presione una tecla para continuar...${END}"
                                read TECLA
                                exit
			fi
			ALIAS=`rsh ${HOST} '( host PCBALANZAS || echo ERROR )'` 
			if [ "${ALIAS}" = "ERROR" ]
			then
				echo "\n\n\t\t${BLNK}El alias PCBALANZAS con ip ${IP} NO EXISTE en el servidor!!!${END}"
				echo "\t\t${BOLD}Llamar a OPERACIONES para que realice la tarea.${END}\n"
				echo "\n\n\n\t\t\t\t${REV}Presione una tecla para continuar...${END}"
                       		read TECLA
				exit
			else
				IPREM="`echo ${ALIAS} | awk ' { print $3 } '`"
				IPREMFORM="`echo ${IPREM} | sed 's/\.//g' | sed 's/\,//g'`"
				if [ ${IPFORM} != ${IPREMFORM} ]
				then
					echo "\n\n\t\t${BLNK}El alias PCBALANZAS del servidor NO ES IGUAL a la ip ingresada!!!${END}"
                                	echo "\t\t${BOLD}Llamar a OPERACIONES para que cambie la ip ${IPREM} del alias PCBALANZAS${END}"
                                	echo "\t\t${BOLD}por ${IP} en el servidor de ${HOST}${END}"
                                	echo "\n\n\n\t\t\t\t${REV}Presione una tecla para continuar...${END}"
                                	read TECLA
                                	exit
				else
					echo "\n\n\t\t${REV}El alias PCBALANZAS del servidor ES IGUAL a la ip ingresada${END}"
					echo "\n\n\t\t${REV}PCBALANZAS:${IPREM}	IP ingresada:${IP}"
                                        echo "\n\n\n\t\t\t\t${REV}Presione una tecla para continuar...${END}"
                                        read TECLA
                                        exit
				fi
			fi
		else
			echo "\n\n\t\t\t\t${BLNK}La ip ingresada no es valida!!!${END}"
                       	echo "\n\n\n\t\t\t\t${REV}Presione una tecla para continuar...${END}"
                       	read TECLA      
                	continue
		fi	
		echo "\n\n\n\t\t\t\t${REV}Presione una tecla para continuar...${END}"
                read TECLA
                break
	done
done
