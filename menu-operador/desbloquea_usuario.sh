#!/usr/bin/ksh
#set -n
#set -x
#clear

##########################################################################################
# Nombre.............: desbloquea_usuarios.sh                                            #
# Autor..............:                                                                   #
# Objetivo...........: Desbloquea Usuarios de sucursales.                                #
# Descripcion........:                                                                   #
# Valores de Retorno.:                                                                   #
# Modificacion.......: 22/15/2016                                                        #
# Documentacion......:                                                                   #
##########################################################################################


###########################################################################################
#                                      VARIABLES                                          #
###########################################################################################

export HORA="`date +%H:%M:%S`"
export SERVIDOR="`hostname`"
export PATHSCR="/tecnol/operador"
export PATHSCRLOG="${PATHSCR}/log"
export LOGSCRIPT="${PATHSCRLOG}/${SERVIDOR}.${FECHA}.log"
export FPATH="/tecnol/funciones"
export PATHLOG="${PATHAPL}/log"
export LOG="${PATHLOG}/desbloquea_usuario.${USUARIO}.`date +%A`"
export BLNK=`tput blink`
export BOLD=`tput bold`
export END=`tput sgr0`
export REV=`tput smso`
export EREV=`tput rmso`
export SCRIPT="DESBLOQUEA USUARIO" 
export SESION=`who am i | awk ' { print $2 } '`


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

titulo ()
{
MENSAJE=$1
echo  "\t-------------------------------------------------------------------------------"
echo  "\t$MENSAJE"
echo  "\t-------------------------------------------------------------------------------"
echo  " "
}

function PTecla
{
        echo "\tPresione una tecla para continuar"
        read cont
}

desbloquea_linux()
{
#set -x

echo  "\t--------------------------------------------------------------------------------------------"
echo  "\tIngrese el nombre del usuario que desea desbloquear:    "
echo  "\t(Por ejemplo: ope1, ope6 , clarrosa) o [s-S] Salir del Menu[s]:\c"
read USER
echo  "\t--------------------------------------------------------------------------------------------"
if [ ${USER} = s ] || [ ${USER} = S ]  1>/dev/null 2>/dev/null 
then
        exit
else
        echo  "\t--------------------------------------------------------------------------------------------"
        echo  "\tIngrese el nro de la sucursal:    "
        echo  "\t(Por ejemplo: 01 99 102 215) o [s-S] Salir del Menu[s]:\c"
        read SUC
        echo  "\t--------------------------------------------------------------------------------------------"A

        if [ ${SUC} = s ] || [ ${SUC} = S ]   1>/dev/null 2>/dev/null 
        then
                exit
        else
                titulo "Usted desbloqueara al usuario ${USER} de la sucursal ${SUC}"
                echo "\t Si es correcto , Pulse una tecla para continuar.."
                echo "\t Sino , pulse S|s para salir"
                read CONF
                if [[ ${CONF} = s ]] || [[ ${CONF} = S ]]   1>/dev/null 2>/dev/null 
                then
                        exit 
                else
                        echo "\tCambiando passwd del usuario ${USER} en la suc${SUC}"
                        cd /tecnol/util ;./massPassSet.exp $USER cihazope suc${SUC}
                        sleep 2
                        echo "\tCambiado, Ahora blanqueo los logins fallido:"
                        ssh suc${SUC}  "pam_tally2 --user=$USER --reset"
                        sleep 2
			PTecla
                        exit
                fi
        fi
fi
}

desbloquea_aix()
{
#set -x

echo  "\t--------------------------------------------------------------------------------------------"
echo  "\tIngrese el nombre del usuario que desea desbloquear:    "
echo  "\t(Por ejemplo: ope, ope6 , clarrosa) o [s-S] Salir del Menu[s]:\c"
read USER
echo  "\t--------------------------------------------------------------------------------------------"
if [ ${USER} = "s" ] || [ ${USER} = "S" ] 1>/dev/null 2>/dev/null 
then
        exit
else
        export USER=${USER}
        echo  "\t--------------------------------------------------------------------------------------------"
        echo  "\tIngrese el nombre del servidor de Central :    "
        echo  "\t(Por ejemplo: sap1,gdm,sf000..) o [s-S] Salir del Menu[s]:\c"
        read SUC
        echo  "\t--------------------------------------------------------------------------------------------"A

        if [ ${SUC} = "s" ] || [ ${SUC} = "S" ]  1>/dev/null 2>/dev/null 
        then
                exit
        else
                titulo "Usted desbloqueara al usuario ${USER} del servidor de Central ${SUC}"
                echo "\t Si es correcto , Pulse una tecla para continuar.."
                echo "\t Sino , pulse S|s para salir"
                read CONF
                if [[ ${CONF} = "s" ]] || [[ ${CONF} = "S" ]]  1>/dev/null 2>/dev/null 
                then
                        exit
                else
			if [ $SUC = adm01 ]
			then
				echo "\tCambiando passwd del usuario ${USER} en la ${SUC}"
				/tecnol/operador/passwd.exp ${USER}
				sleep 2
				echo "\tCambiado, Ahora blanqueo los logins fallido:"
                                /tecnol/util/desbloqueo_user.sh ${USER}
                                sleep 2
                                echo "\tLa password provisoria del usuario $USER es "123456". Le va a pedir cambiarla en el primer inicio."
                                PTecla
                                exit
			else
				echo "\tCambiando passwd del usuario ${USER} en la ${SUC}"
				su - sysadm -c "/tecnol/util/massPassSet_sysadm.exp ${USER} 123456 $SUC"
				sleep 2
				echo "\tCambiado, Ahora blanqueo los logins fallido:"
				su - sysadm -c "ssh $SUC 'sudo /tecnol/util/desbloqueo_user.sh ${USER}'"
				sleep 2
				echo "\tLa password provisoria del usuario $USER es "123456". Le va a pedir cambiarla en el primer inicio."
				PTecla
				exit
			fi
                fi
        fi
fi
}



###########################################################################################
#                                      Principal                                          #
###########################################################################################

encabezado "DESBLOQUEA USUARIO EN SUCURSAL"

while true 
do 
 echo "\t            *** ${AX}Menu del Operador${BX} ***        "
 echo ""
 echo "\t            1. - Desbloquear Usuarios en Sucursales           " 
 echo ""
 echo "\t            2. - Desbloquear Usuarios en Central              " 
 echo ""
 echo "\t            s. - Salir del Menu                               " 
 echo ""
 echo "\tIngrese su opcion ==> \c                                       " 
 read opcion
 case $opcion in 
     1)  titulo "Desbloqueando Usuario en servidor de Sucursal"
	 desbloquea_linux
         ;; 
    2)  titulo "Desbloqueando Usuario en servidor de Central"
         desbloquea_aix
	 ;;
     S|s)  clear
         exit
         ;; 
     *)  titulo "Opcion incorrecta.. verifique e intente nuevamente"
	 PTecla
         ;; 
esac
done


