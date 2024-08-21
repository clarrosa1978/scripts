#!/usr/bin/ksh
###############################################################################
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Cambiar password de SO.                                #
# Nombre del programa: cambiopwd.sh                                           #
# Solicitado por.....: Omar Del Negro                                         #
# Descripcion........:                                                        #
# Fecha de creacion..: 28/04/2008                                             #
# Modificacion.......: DD/MM/AAAA                                             #
###############################################################################

###############################################################################
###                            Variables                                    ###
###############################################################################
export PATHAPL="/home/hdesk"
export PATHLOG="${PATHAPL}/log"
export USUARIO="`whoami`"
export LOG="${PATHLOG}/logmenu.${USUARIO}.`date +%A`"
export BLNK=`tput blink`
export BOLD=`tput bold`
export END=`tput sgr0`
export REV=`tput smso`
export EREV=`tput rmso`
export SCRIPT="CAMBIO DE PASSWORD" 
export SESION=`who am i | awk ' { print $2 } '`

###############################################################################
###                            Funciones                                    ###
###############################################################################

###############################################################################
#				Principal                                     #
###############################################################################
${PATHAPL}/encabezado.sh "CAMBIO DE PASSWORD"
Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - Ingreso a CAMBIO DE PASSWORD." ${LOGSCRIPT}
echo "\n\n\n\n\t\t\t\t\c"
passwd ${USUARIO}
if [ $? = 0 ]
then
	echo "\t\t\t\tLa password se cambio correctamente."
	Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - La password se cambio correctamente del usuario ${USUARIO}." ${LOGSCRIPT}
else
	echo "\t\t\t\t${BLNK}Error al intentar cambiar la password${END}"
	Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - Error al intentar cambiar la password del usuario ${USUARIO}." ${LOGSCRIPT}
fi
echo "\n\n\n\t\t\t\t${BOLD}Presione una tecla para continuar...${END}"
read
Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - Salio de CAMBIO DE PASSWORD." ${LOGSCRIPT}
exit
