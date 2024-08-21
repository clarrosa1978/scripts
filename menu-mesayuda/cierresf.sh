#!/usr/bin/ksh
###############################################################################
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Cerrar el numero de sucursal ingresada.                #
# Nombre del programa: cierresf.sh                                            #
# Solicitado por.....: Omar Del Negro                                         #
# Descripcion........: Ejecuta el comando ctmcontb en forma remota.           #
# Fecha de creacion..: 13/03/2008                                             #
# Modificacion.......: 27/06/2012 - Se adapta el script para que el usuario   #
#                      utilice el comando sudo para las ejecuciones remotas.  #
#                      Proyecto PCI_LIN_02.                                   #
# Modificacion.......: 05/10/2022 - Se agregaron condiciones para que puedan  #
#                      cerrar las Suc los domingos despues de las 14:30 hs.   #
#                      Las Suc que cierran temprano.                          #
###############################################################################
###############################################################################
###                            Variables                                    ###
###############################################################################
export PATHAPL="/tecnol/opmayuda"
export PATHLOG="${PATHAPL}/log"
export USUARIO="`whoami`"
export LOG="${PATHLOG}/logcierre.`date +%A`"
export EMPRESA=${1}
export BLNK=`tput blink`
export BOLD=`tput bold`
export END=`tput sgr0`
export REV=`tput smso`
export EREV=`tput rmso`
export SCRIPT="CIERRE DE SUCURSALES"
export SESION=`who am i | awk ' { print $2 } '`

###############################################################################
###                            Funciones                                    ###
###############################################################################

function ValidarIngreso
{
export INGRESO=${1}
if [ -Z ${INGRESO} ] 2>/dev/null
    then
    echo "\n\n\t\t\t\t${BLNK}Ingrese un valor.. para continuar...${END}"
    break
else
    continue
fi
}

function AgregarCondicion
{
	typeset SUC="${1}"
	typeset COND="${2}"
	typeset -s EST=""
	EST=`ssh -q -t ${SUC} '( sudo -u ctmsrv7 -i ctmcontb -ADD '${COND}' 'ODAT')' >/dev/null && echo 0 || echo 1` 
	if [ "${EST}" = "0" ]
	then
		return 0
	else
		return 1
	fi
}

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

# Se agrega para validar las sucursales que cierran a las 14:00 los Domingos.
function ValidarSucursalDomingos
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
	for i in `cat /etc/listalnxDom1400`
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
#                           Principal                                         #
###############################################################################
while true
do
	${PATHAPL}/encabezado.sh "CIERRE DE SUCURSALES"
	HORAACT="`date +%H%M`" 
	if [ `date +%d%m` = 2412 ] || [ `date +%d%m` = 3112 ]
	then
		export HORAINI="1800"
	else
		export HORAINI="2130"
	fi
	DIAACT="`date +%a`"
	DOMINGO="Sun"
	HORAINIDOM="1430"
	LISTDOM="`cat /etc/listalnxDom1400`"
	
# Se agrega para validar las sucursales que cierran a las 14:00 los Domingos.
	if [ ${DIAACT} = ${DOMINGO} ] && [ ${HORAACT} -gt ${HORAINIDOM} ]
	then
		echo " Hoy Domingo las siguientes Sucursales cierran a las 14:00hs:"
		echo $LISTDOM
	else
		if [ ${HORAACT} -lt ${HORAINI} ] 
		then
			echo "\n\n\t\t\t\t${BLNK}AUN NO SON LAS `echo ${HORAINI} | sed 's/./&:/2'` - NO PUEDES CERRAR LA SUCURSAL${END}\c"
			Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - Ingreso a cerrar sucursales." ${LOGSCRIPT}
			echo "\n\n\n\t\t\t\t${BOLD}Presione una tecla para continuar...${END}"
			read TECLA
			exit
		fi
	fi
	
	echo "${REV}\n\n\n\n\t\t\t\tIngrese el numero de sucursal a cerrar:${EREV}\c"
	read NROSUC
	ValidarIngreso ${NROSUC}	
	Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - Ingreso el numero de Sucursal ${NROSUC}." ${LOGSCRIPT}
	
# Se agrega para validar las sucursales que cierran a las 14:00 los Domingos.
	if [ ${DIAACT} = ${DOMINGO} ] && [ ${HORAACT} -lt ${HORAINI} ]
	then
		#echo "Domingo entre las 14:30 y las 21.30h."
		ValidarSucursalDomingos ${NROSUC}
	else
		#echo "Todos los días despues de 21.30h."
		ValidarSucursal ${NROSUC}
	fi
	
	if [ $? = 1 ] 
	then
		echo "\n\n\t\t\t\t${BLNK}SUCURSAL INVALIDA${END}\c"
		Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - Ingreso \"${NRO}\" y es un valor de nro de SUCURSAL INVALIDA." ${LOGSCRIPT}
		echo "\n\n\n\t\t\t\t${BOLD}Presione una tecla para continuar...${END}"
		read TECLA
		exit
	fi
	
	ping -c3 ${HOST} >/dev/null
	
	if [ $? != 0 ]
	then
		echo "\n\n\n\n\n\t\t\t\t${REV}SUCURSAL SIN COMUNICACION${EREV}\n"
		Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - SUCURSAL SIN COMUNICACION." ${LOGSCRIPT}
		echo "\n\n\n\t\t\t\t${BOLD}Presione una tecla para continuar...${END}"
		read TECLA
		exit
	fi
	typeset -Z3 NROSUC
	while true
        do
        	${PATHAPL}/encabezado.sh "CIERRE DE SUC${NROSUC}"
                echo "\n\n\n\n\n\t\t\t\t${REV}Confirma cierre de sucursal ${NROSUC} [S/N]: ${EREV}\c"
                read OPCION
		ValidarIngreso ${OPCION}
		Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - Confirma cierre de sucursal ${NROSUC} : ${OPCION}." ${LOGSCRIPT}
                case ${OPCION} in
               		N|n)    exit ;;
                      	S|s)    break ;;
                     	*)      ;;
               	esac    
	done
        case ${EMPRESA} in
		T)	AgregarCondicion ${HOST} MANUAL_SF${NROSUC}CI005
			if [ $? = 0 ]
                       	then
                       		echo "\n\t\t\t\t${BOLD}EMPRESA 1 CERRADA CORRECTAMENTE${END}"
                              	Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - ${SESION} - PID :$$ - ${SCRIPT} - Cerro OK empresa 1 en sucursal ${NROSUC}" ${LOG}
                        else
                        	echo "\n\t\t\t\t\t\t${BLNK}EMPRESA 1 CERRADA CON ERRORES!!!!${END}"
                        	Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - ERROR al cerrar empresa 1 en sucursal ${NROSUC}" ${LOG}
                       	fi
			AgregarCondicion ${HOST} MANUAL_SF${NROSUC}CI010
                       	if [ $? = 0 ]
              		then
                        	echo "\n\t\t\t\t${BOLD}EMPRESA 2 CERRADA CORRECTAMENTE${END}"
                               	Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - Cerro OK empresa 2 en sucursal ${NROSUC}" ${LOG}
                        else
                        	echo "\n\t\t\t\t${BLNK}EMPRESA 2 CERRADA CON ERRORES!!!!${END}"
                               	Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - ERROR al cerrar empresa 2 en sucursal ${NROSUC}" ${LOG}
                        fi
			echo "\n\n\n\t\t\t\t${BLNK}Presione una tecla para continuar...${END}"
			read TECLA
                        exit ;;

		1)	AgregarCondicion ${HOST} MANUAL_SF${NROSUC}CI005
			if [ $? = 0 ]
                        then    
                                echo "\n\t\t\t\t${BOLD}EMPRESA 1 CERRADA CORRECTAMENTE${END}"
                                Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - Cerro OK empresa 1 en sucursal ${NROSUC}" ${LOG}
                        else
                                echo "\n\t\t\t\t\t\t${BLNK}EMPRESA 1 CERRADA CON ERRORES!!!!${END}"
                                Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - ERROR al cerrar empresa 1 en sucursal ${NROSUC}" ${LOG}
                        fi
			echo "\n\n\n\t\t\t\t\t\t${BLNK}Presione una tecla para continuar...${END}"
                        read TECLA
			exit;;

		2)	AgregarCondicion ${HOST} MANUAL_SF${NROSUC}CI010
			if [ $? = 0 ]
                        then    
                                echo "\n\t\t\t\t${BOLD}EMPRESA 2 CERRADA CORRECTAMENTE${END}"
                                Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - Cerro OK empresa 2 en sucursal ${NROSUC}" ${LOG}
                        else
                                echo "\n\t\t\t\t\t\t${BLNK}EMPRESA 2 CERRADA CON ERRORES!!!!${END}"
                                Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - ERROR al cerrar empresa 2 en sucursal ${NROSUC}" ${LOG}
                        fi
			echo "\n\n\n\t\t\t\t\t\t${BLNK}Presione una tecla para continuar...${END}"
                        read TECLA
			exit ;;

		*)	break ;;
	esac
done
