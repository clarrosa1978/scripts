#!/bin/sh
###############################################################################
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........:                                                        #
# Nombre del programa: encabezado.sh                                          #
# Solicitado por.....: Omar Del Negro                                         #
# Descripcion........: Encabezado para pantallas de menu.                     #
# Fecha de creacion..: 13/03/2008                                             #
# Modificacion.......: DD/MM/AAAA                                             #
###############################################################################

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA="`date +%d/%m/%Y`"
export HORA="`date +%H:%M:%S`"
export NOMBRE="`grep ^${LOGNAME} /etc/passwd | cut -f5 -d: | cut -c1-30`"
export SUCURSAL="suc`uname -n | sed 's/suc//'`"
export MODULO="${1}"
export BOLD=`tput bold`
export REV=`tput smso`		#Habilita reverse en la terminal
export EREV=`tput rmso`		#Deshabilita reverse en la terminal
export BLX=`tput blink`  	#Habilita blink en la terminal
export UNDER=`tput smul` 	#Habilita underline en la terminal
export EUNDER=`tput rmul`	#Deshabilita underline en la terminal
export END=`tput sgr0`

###############################################################################
###                            Principal                                    ###
###############################################################################
clear
echo
echo -e "\t${BOLD}################################################################################################${END}"
printf "\t%-5s %-30s %-10s %-22s %-10s %-25s %-1s \n" \
"${BOLD}#${END}" "COTO C.I.C.S.A."  "${UNDER}Fecha${EUNDER}:" ${FECHA} "${UNDER}Hora${EUNDER}:" ${HORA} "${BOLD}#${END}"
printf "\t%-5s %-9s %-26s %-10s %-60s %-1s \n" \
"${BOLD}#${END}" "${UNDER}Usuario${EUNDER}:" "${REV}${NOMBRE}${EREV}" "${UNDER}Sucursal${EUNDER}:" "${REV}${SUCURSAL}${EREV}" "${BOLD}#${END}"
printf "\t%-5s %-65s %-10s %-32s %-1s\n" \
"${BOLD}#${END}" "${REV}MENU DE OPERACIONES${EREV}" "${UNDER}Modulo${EUNDER}:" "${REV}${MODULO}${EREV}" "${BOLD}#${END}"
echo -e "\t${BOLD}################################################################################################${END}"
