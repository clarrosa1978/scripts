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

###############################################################################
#				Principal                                     #
###############################################################################
${PATHAPL}/encabezado.sh "CAMBIO DE PASSWORD"
Enviar_A_Log "${USUARIO} - Ingreso a CAMBIO DE PASSWORD." ${LOGSCRIPT}
echo "\n\n\n\n\t\t\t\t\c"
passwd ${USUARIO}
if [ $? = 0 ]
then
	echo "\t\t\t\tLa password se cambio correctamente."
else
	echo "\t\t\t\t${BLNK}Error al intentar cambiar la password${END}"
fi
echo "\n\n\n\t\t\t\t${BOLD}Presione una tecla para continuar...${END}"
read
Enviar_A_Log "${USUARIO} - Salio de CAMBIO DE PASSWORD." ${LOGSCRIPT}
exit
