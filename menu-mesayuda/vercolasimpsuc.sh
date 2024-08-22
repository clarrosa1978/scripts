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

function ValidarSucursal
{
set -x
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

function MenuAdmCola
{	
	typeset -s7 COLA=${1}
	typeset -s1 OPCION=""
	typeset -Z4 JOB
	echo "${REV}\n\n\t\t${REV}A${END}ctivar - ${REV}D${END}esactivar - ${REV}C${END}ancelar Job - Cancelar ${REV}T${END}odos los jobs"
	echo "${REV}\n\n\t\tIngrese una opcion [S|s]: ${EREV}\c"
        read OPCION
	ValidarIngreso ${OPCION}
	Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - Ingreso a la opcion ${OPCION} de ${TITULO}." ${LOGSCRIPT}
	case ${OPCION} in
		A|a)
			ssh ${HOST} "sudo enable ${COLA}" 
                        ssh ${HOST} "sudo cupsenable ${COLA}"
			Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - Ingreso la opcion ${OPCION}, enable ${COLA}." ${LOGSCRIPT}
			return 0 ;;
		D|d)
			ssh ${HOST} "sudo disable ${COLA}"
                        ssh ${HOST} "sudo cupsdisable ${COLA}"
			Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - Ingreso la opcion ${OPCION}, disable ${COLA}." ${LOGSCRIPT}
			return 0 ;;
		C|c)	echo "${REV}\t\t\t\tIngrese el job number: ${EREV}\c"
			read JOB
			ValidarIngreso ${JOB}
			Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - Ingreso nro de job a cancelar ${OPCION}." ${LOGSCRIPT}
			ssh ${HOST} "sudo cancel ${JOB}" > /dev/null 2>&1
			return 0 ;; 
		T|t)
			ssh ${HOST} "sudo lprm - -P ${COLA}" 
			Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - Ingreso la opcion ${OPCION}, para Cancelar todos los jobs." ${LOGSCRIPT}
			return 0 ;; 
		S|s)	return 1 ;;
		*)	echo "\n\n\t\t\t\t${BLNK}OPCION INVALIDA${END}\c"
			Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - Ingreso \"${OPCION}\" y es un valor de una OPCION INVALIDA." ${LOGSCRIPT}
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
	ValidarIngreso ${NROSUC}
	Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - Ingreso el numero de Sucursal ${NROSUC}." ${LOGSCRIPT}
	ValidarSucursal ${NROSUC}
	if [ $? = 1 ] 
	then
		echo "\n\n\t\t\t\t${BLNK}SUCURSAL INVALIDA${END}\c"
		Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - Ingreso \"${NROSUC}\" y es un valor de nro de SUCURSAL INVALIDA. " ${LOGSCRIPT}
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
 	while true
        do
        	${PATHAPL}/encabezado.sh "IMPRESORAS DE SUC${NROSUC}"
		COLAS=`ssh ${HOST} 'lpstat -a' | awk ' { print $1 } '`
		OPCMAX=`echo "$COLAS" | wc -l | sed 's/ //g'`
		MCOLAS=`echo "$COLAS" |  awk ' { print sprintf("'${REV}'%02d)'${EREV}' %s", NR, $1) } '`
		echo "\n\n\n\n\t\t"$MCOLAS"\n"
		echo "\t\t${REV}Ingrese su opcion [de 1 a ${OPCMAX}] o [S|s] para salir:${EREV}\c"
        	read OPCION
		ValidarIngreso ${OPCION}
		Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - Selecciono la impresora ${OPCION}." ${LOGSCRIPT}
		if [ "${OPCION}" = "s" -o "${OPCION}" = "S" ]
        	then
                	Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - Salio de ${TITULO}." ${LOGSCRIPT}
                	tput sgr0
                	exit
        	fi
        	export NUMVALID=`expr "${OPCION}" : '^\([0-9]*\)$'`
        	if [ ${NUMVALID} ] && [ ${NUMVALID} = ${OPCION} ] && [ ${OPCION} -gt 0 ] && [ ${OPCION} -le ${OPCMAX} ]
        	then
			OPCION=`expr ${OPCION} + 0` # Elimina ceros a la izquierda
			COLSEL=`ssh ${HOST} lpstat -v | awk ' NR == '${OPCION}' { print $3 } ' | sed s/://g`
			while true
			do
				${PATHAPL}/encabezado.sh "COLA ${COLSEL}"
				echo "\n\n\n\n"
				ssh ${HOST} lpstat -p$COLSEL -o$COLSEL
				MenuAdmCola ${COLSEL}
				[ $? = 1 ] && break
			done
		else
			echo "\n\n\t\t\t\t${BLNK}Opcion INVALIDA.  REINGRESE...${END}"
			Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - Ingreso \"${OPCION}\" y es un valor de una OPCION INVALIDA." ${LOGSCRIPT}
                	echo "\n\t\t\t\t${REV}Presione una tecla para continuar...${EREV}"
                	read
                	OPCION=""
                	NUMVALID=""
			COLSEL=""
			MCOLAS=""
        	fi
	done
done