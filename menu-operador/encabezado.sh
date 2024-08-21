#!/usr/bin/ksh
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
export NOMBRE="`egrep ^${LOGNAME}: /etc/passwd | cut -f5 -d: | cut -c1-61`"
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
echo "\t${BOLD}###################################################################################################${END}"
printf "\t%-5s %-30s %-10s %-22s %-10s %-28s %-1s \n" \
"${BOLD}#${END}" "COTO C.I.C.S.A."  "${UNDER}Fecha${EUNDER}:" ${FECHA} "${UNDER}Hora${EUNDER}:" ${HORA} "${BOLD}#${END}"
printf "\t%-5s %-13s %-28s %-9s %-63s %-1s \n" \
"${BOLD}#${END}" "${UNDER}Usuario${EUNDER}:" "${REV}${USUARIO}${EREV}" "${UNDER}Nombre${EUNDER}:" "${REV}${NOMBRE}${EREV}" "${BOLD}#${END}"
printf "\t%-5s %-37s %-10s %-63s %-1s \n" \
"${BOLD}#${END}" "${REV}MENU DE MESA DE AYUDA${EREV}" "${UNDER}Modulo${EUNDER}:" "${REV}${MODULO}${EREV}" "${BOLD}#${END}"
echo "\t${BOLD}###################################################################################################${END}"
