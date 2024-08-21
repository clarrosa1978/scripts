#!/usr/bin/ksh
###############################################################################
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Administrar colas de impresion.                        #
# Nombre del programa: vertipoimpcen.sh                                       #
# Solicitado por.....: Omar Del Negro                                         #
# Descripcion........:                                                        #
# Fecha de creacion..: 14/04/2008                                             #
# Modificacion.......: DD/MM/AAAA                                             #
###############################################################################
#set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export PATHAPL="/home/clarrosa/mesa"
export PATHLOG="${PATHAPL}/log"
export USUARIO="`whoami`"
export LOG="${PATHLOG}/logmenu.${USUARIO}.`date +%A`"
export BLNK=`tput blink`
export BOLD=`tput bold`
export END=`tput sgr0`
export REV=`tput smso`
export EREV=`tput rmso`

###############################################################################
###                            Funciones                                    ###
###############################################################################
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
	for i in `cat /etc/listalnx` 58 64 66 103 180 181
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

function MenuAdmCola
{	
	typeset -s7 COLA=${1}
	typeset -s1 OPCION=""
	typeset -Z3 JOB
	echo "${REV}\n\n\t\t${REV}A${END}ctivar - ${REV}D${END}esactivar - ${REV}C${END}ancelar Job - Cancelar ${REV}T${END}odos los jobs"
	echo "${REV}\n\n\t\tIngrese una opcion [S|s]: ${EREV}\c"
        read OPCION
	case ${OPCION} in
		A|a)	rsh ${HOST} "enable ${COLA}" 
			return 0 ;;
		D|d)	rsh ${HOST} "disable ${COLA}"
			return 0 ;;
		C|c)	echo "${REV}\t\t\t\tIngrese el job number: ${EREV}\c"
			read JOB
			rsh ${HOST} "cancel ${JOB}" > /dev/null 2>&1
			return 0 ;; 
		T|t) 	rsh ${HOST} "qcan -X -P ${COLA}" > /dev/null 2>&1
			return 0 ;; 
		S|s)	return 1 ;;
		*)	echo "\n\n\t\t\t\t${BLNK}OPCION INVALIDA${END}\c"
                	echo "\n\n\n\t\t\t\t${BOLD}Presione una tecla para continuar...${END}"
                	read 
			return 0;;
	esac
}

###############################################################################
#				Principal                                     #
###############################################################################
while true
do
        ${PATHAPL}/encabezado.sh "MENU DE IMPRESION"
        echo "${REV}\n\n\n\n\t\t\t\tIngrese el numero de sucursal:${EREV}\c"
        read NROSUC
	ValidarSucursal ${NROSUC}
	if [ $? = 1 ] 
	then
		echo "\n\n\t\t\t\t${BLNK}SUCURSAL INVALIDA${END}\c"
		echo "\n\n\n\t\t\t\t${BOLD}Presione una tecla para continuar...${END}"
               	read
		exit
	fi
	if [ ${HOST} = "suc50" ]
	then
		HOST=nodo9
	fi
	typeset -Z3 NROSUC
	ping -c3 ${HOST} 1>/dev/null
	if [ $? != 0 ]
	then
		echo "\n\n\t\t\t\t${BLNK}NO HAY COMUNICACION CON ${HOST}!!!${END}"
                echo "\n\t\t\t\t${REV}Presione una tecla para continuar...${EREV}"
                read
		exit
	fi
 	while true
        do
        	${PATHAPL}/encabezado.sh "IMPRESORAS DE SUC${NROSUC}"
		if [ ${TIPO} = A ]
		then
		    	COLAS=`sudo rsh ${HOST} 'lsallq'`
			for i in ${COLAS}
                	do
                        	TIPO=`sudo rsh ${HOST} "cat /etc/qconfig" | grep "device = @$i" > /dev/null 2>&1 && echo SI || echo NO`
                        	IP=`sudo rsh ${HOST} "host $i"`
                        	if [ ${TIPO} = "SI" ]
                        	then
                                	echo "\t\tCola: $i            Tipo: LPD		Ip: ${IP}"
                        	else
                                	echo "\t\tCola: $i            Tipo: RED 	Ip: ${IP}"
                        	fi
                	done
		else
		    	COLAS=`sudo ssh ${HOST} 'lpstat -a' | awk ' { print $1 } '`
			for i in ${COLAS}
                        do
                                TIPO=`sudo ssh suc103 "lpstat -s"|grep "device for $i: lpd" > /dev/null 2>&1  && echo SI || echo NO`
                                IP=`sudo ssh ${HOST} "grep $i /etc/hosts" | awk ' { print $1 } '`
                                if [ ${TIPO} = "SI" ]
                                then
                                        echo "\t\tCola: $i            Tipo: LPD         Ip: ${IP}"
                                else
                                        echo "\t\tCola: $i            Tipo: RED         Ip: ${IP}"
                                fi
                        done
		fi
                echo "\n\t\t\t\t${REV}Presione una tecla para continuar...${EREV}"
                read
		exit
	done
done
