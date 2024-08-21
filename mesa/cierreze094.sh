#!/usr/bin/ksh
###############################################################################
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Cerrar Storeflow en ze094.                             #
# Nombre del programa: cierreze094.sh                                         #
# Solicitado por.....: Omar Del Negro                                         #
# Descripcion........: Ejecuta el comando ctmcontb en forma remota.           #
# Fecha de creacion..: 17/03/2008                                             #
# Modificacion.......: DD/MM/AAAA                                             #
###############################################################################
set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export PATHAPL="/home/clarrosa/mesa"
export PATHLOG="${PATHAPL}/log"
export USUARIO="`whoami`"
export LOGSCRIPT="${PATHLOG}/logcierre.`date +%A`"
export REV=`tput smso`
export END=`tput rmso`
export BLNK=`tput blink`

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Enviar_A_Log

###############################################################################
#				Principal                                     #
###############################################################################

while true
do
	${PATHAPL}/encabezado.sh "CIERRE DE ZE094"
	echo "\t${REV}Confirma cierre de empresa 1 y 2 en sucursal ze094 [S/N]:${END} \c"
	read OPCION
	case ${OPCION} in
		N|n)	exit ;;
		S|s)	break ;;
		*)	;;
	esac
done
sudo rsh suc94 "su - ctmsrv \"-c ctmcontb -ADD 'ZE-CFL-CIEEMPR01' 'ODAT'\""
#sudo rsh suc94 "su - ctmsrv \"-c ctmcontb -ADD 'ZE-MANUAL-CIEEMPR01' 'ODAT'\"" 
if [ $? = 0 ]
then
	echo "\n\n\t\t${BOLD}EMPRESA 1 CERRADA CORRECTAMENTE${END}\n"
	Enviar_A_Log "${USUARIO} - Cerro OK empresa 1 en sucursal ze094" ${LOGSCRIPT}
else
	echo "\n\n\t\t${BLNK}EMPRESA 1 CERRADA CON ERRORES!!!!${END}\n"
	Enviar_A_Log "${USUARIO} - ERROR al cerrar empresa 1 en sucursal ze094" ${LOGSCRIPT}
fi
sudo rsh suc94 "su - ctmsrv \"-c ctmcontb -ADD 'ZE-CFL-CIEEMPR02' 'ODAT'\"" 
#sudo rsh suc94 "su - ctmsrv \"-c ctmcontb -ADD 'ZE-MANUAL-CIEEMPR02' 'ODAT'\"" 
if [ $? = 0 ]
then    
	echo "\n\n\t\t${BOLD}EMPRESA 2 CERRADA CORRECTAMENTE${END}\n"
	Enviar_A_Log "${USUARIO} - Cerro OK empresa 2 en sucursal ze094" ${LOGSCRIPT}
else
      	echo "\n\n\t\t${BLNK}EMPRESA 2 CERRADA CON ERRORES!!!!${END}\n"
	Enviar_A_Log "${USUARIO} - ERROR al cerrar empresa 2 en sucursal ze094" ${LOGSCRIPT}
fi
echo "\n${REV}Presione una tecla para continuar...${END}"
read TECLA
