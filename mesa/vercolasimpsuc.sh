#!/usr/bin/ksh
###############################################################################
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Administrar colas de impresion.                        #
# Nombre del programa: vercolasimp.sh                                         #
# Solicitado por.....: Omar Del Negro                                         #
# Descripcion........: Activa,desactiva y muestra colas de impresion de un    #
#                      servidor.                                              #
# Fecha de creacion..: 18/03/2008                                             #
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

function MenuAdmCola
{	
	set -x
	typeset -s7 COLA=${1}
	typeset -s1 OPCION=""
	typeset -Z4 JOB
	echo "${REV}\n\n\t\t${REV}A${END}ctivar - ${REV}D${END}esactivar - ${REV}C${END}ancelar Job - Cancelar ${REV}T${END}odos los jobs"
	echo "${REV}\n\n\t\tIngrese una opcion [S|s]: ${EREV}\c"
        read OPCION
	case ${OPCION} in
		A|a)	if [ ${TIPO} = "A" ] 
			then
				rsh ${HOST} "enable ${COLA}" 
			else
				ssh ${HOST} "enable ${COLA}" 
			fi
			return 0 ;;
		D|d)	if [ ${TIPO} = "A" ]
			then
				rsh ${HOST} "disable ${COLA}"
			else
				ssh ${HOST} "disable ${COLA}"
			fi
			return 0 ;;
		C|c)	echo "${REV}\t\t\t\tIngrese el job number: ${EREV}\c"
			read JOB
			if [ ${TIPO} = "A" ]
			then
				rsh ${HOST} "cancel ${JOB}" > /dev/null 2>&1
			else
				ssh ${HOST} "cancel ${JOB}" > /dev/null 2>&1
			fi
			return 0 ;; 
		T|t) 	if [ ${TIPO} = "A" ]
			then
				rsh ${HOST} "qcan -X -P ${COLA}" > /dev/null 2>&1
			else
				ssh ${HOST} "lprm - -P ${COLA}" 
			fi
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
set -x
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
		    	COLAS=`rsh ${HOST} 'lsallq'`
		else
		    	COLAS=`ssh ${HOST} 'lpstat -a' | awk ' { print $1 } '`
		fi
		OPCMAX=`echo "$COLAS" | wc -l | sed 's/ //g'`
		MCOLAS=`echo "$COLAS" |  awk ' { print sprintf("'${REV}'%02d)'${EREV}' %s", NR, $1) } '`
		echo "\n\n\n\n\t\t"$MCOLAS"\n"
		echo "\t\t${REV}Ingrese su opcion [de 1 a ${OPCMAX}] o [S|s] para salir:${EREV}\c"
        	read OPCION
		if [ "${OPCION}" = "s" -o "${OPCION}" = "S" ]
        	then
                	Enviar_A_Log "${USUARIO} - Salio de ${TITULO}." ${LOGSCRIPT}
                	tput sgr0
                	exit
        	fi
        	export NUMVALID=`expr "${OPCION}" : '^\([0-9]*\)$'`
        	if [ ${NUMVALID} ] && [ ${NUMVALID} = ${OPCION} ] && [ ${OPCION} -gt 0 ] && [ ${OPCION} -le ${OPCMAX} ]
        	then
			OPCION=`expr ${OPCION} + 0` # Elimina ceros a la izquierda
			if [ ${TIPO} = "A" ]
			then
				COLSEL=`rsh ${HOST} lsallq | awk ' NR == '${OPCION}' { print $0 } '`
			else
				COLSEL=`ssh ${HOST} lpstat -v | awk ' NR == '${OPCION}' { print $3 } ' | sed s/://g`
			fi
			while true
			do
				${PATHAPL}/encabezado.sh "COLA ${COLSEL}"
				echo "\n\n\n\n"
				if [ ${TIPO} = "A" ]
				then
		 			rsh ${HOST} lpstat -a$COLSEL
				else
					ssh ${HOST} lpstat -o$COLSEL
				fi
				MenuAdmCola ${COLSEL}
				[ $? = 1 ] && break
			done
		else
			echo "\n\n\t\t\t\t${BLNK}Opcion INVALIDA.  REINGRESE...${END}"
                	echo "\n\t\t\t\t${REV}Presione una tecla para continuar...${EREV}"
                	read
                	OPCION=""
                	NUMVALID=""
			COLSEL=""
			MCOLAS=""
        	fi
	done
done
