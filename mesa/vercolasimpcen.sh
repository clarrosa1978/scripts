#!/usr/bin/ksh
###############################################################################
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Administrar colas de impresion.                        #
# Nombre del programa: vercolasimpcen.sh                                      #
# Solicitado por.....: Omar Del Negro                                         #
# Descripcion........: Activa,desactiva y muestra colas de impresion de un    #
#                      servidor.                                              #
# Fecha de creacion..: 14/04/2008                                             #
# Modificacion.......: DD/MM/AAAA                                             #
###############################################################################
#set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export SERVIDOR="${1}"
export PATHAPL="/home/hdesk"
export PATHLOG="${PATHAPL}/log"
export USUARIO="`whoami`"
export COLLST="${PATHLOG}/${USUARIO}.colcen.lst"
export LOG="${PATHLOG}/logmenu.${USUARIO}.`date +%A`"
export BLNK=`tput blink`
export BOLD=`tput bold`
export END=`tput sgr0`
export REV=`tput smso`
export EREV=`tput rmso`

###############################################################################
###                            Funciones                                    ###
###############################################################################

function MenuAdmCola
{	
	typeset -s7 COLA=${1}
	typeset -s1 OPCION=""
	typeset -Z3 JOB
	echo "${REV}\n\n\t\t${REV}A${END}ctivar - ${REV}D${END}esactivar - ${REV}C${END}ancelar Job - Cancelar ${REV}T${END}odos los jobs"
	echo "${REV}\n\n\t\tIngrese una opcion [S|s]: ${EREV}\c"
        read OPCION
	case ${OPCION} in
		A|a)	rsh ${SERVIDOR} "enable ${COLA}" 
			return 0 ;;
		D|d)	rsh ${SERVIDOR} "disable ${COLA}"
			return 0 ;;
		C|c)	echo "${REV}\t\t\t\tIngrese el job number: ${EREV}\c"
			read JOB
			rsh ${SERVIDOR} "cancel ${JOB}" > /dev/null 2>&1
			return 0 ;; 
		T|t) 	rsh ${SERVIDOR} "qcan -X -P ${COLA}" > /dev/null 2>&1
			return 0 ;; 
		S|s)	return 1 ;;
		*)	echo "\n\n\t\t\t\t${BLNK}OPCION INVALIDA${END}\c"
                	echo "\n\n\n\t\t\t\t${BOLD}Presione una tecla para continuar...${END}"
                	read 
			return 0;;
	esac
}

autoload Enviar_A_Log
autoload Borrar

###############################################################################
#				Principal                                     #
###############################################################################
while true
do
        ${PATHAPL}/encabezado.sh "IMPRESORAS DE ${SERVIDOR}"
	Borrar ${COLLST}
	ping -c3 ${SERVIDOR} 1>/dev/null
	if [ $? != 0 ]
	then
		echo "\n\n\t\t\t\t${BLNK}NO HAY COMUNICACION CON ${SERVIDOR}!!!${END}"
                echo "\n\t\t\t\t${REV}Presione una tecla para continuar...${EREV}"
                read
		exit
	fi
	COLAS=`rsh ${SERVIDOR} 'lsallq'`
	OPCMAX=`echo "$COLAS" | wc -l | sed 's/ //g'`
	echo "$COLAS" > ${COLLST}
	Listar.sh ${COLLST}
	MCOLAS=`echo "$COLAS" |  awk ' { print sprintf("'${REV}'%02d)'${EREV}' %s", NR, $1) } '`
	#echo "\n\n\n\n\t\t"$MCOLAS"\n"
	echo "\n\t\t${REV}Ingrese su opcion [de 1 a ${OPCMAX}] o [S|s] para salir:${EREV}\c"
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
		COLSEL=`rsh ${SERVIDOR} lsallq | awk ' NR == '${OPCION}' { print $0 } '`
		while true
		do
			${PATHAPL}/encabezado.sh "COLA ${COLSEL}"
			echo "\n\n\n\n"
	 		rsh ${SERVIDOR} lpstat -a$COLSEL
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
