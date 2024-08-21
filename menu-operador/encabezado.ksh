#!/usr/bin/ksh
###############################################################################
# Autor..............: TECNOLOGIA (C.A.S)                                     #
# Usuario ...........: root                                                   #
# Objetivo...........: Muestra el encabezado de la empresa                    #
# Nombre del programa: encabezado.ksh                                         #
# Descripcion........: Se utiliza este script para mostrar el encabezado      #
# Modificacion.......: 17/10/2001                                             #
###############################################################################
clear
#user=`echo $LOGNAME`
user=`whoami`

fecha=`date '+%d/%m/%y'`
hora=`date | awk ' { print $4 } '`
wrkstn=`who am i | awk ' { print $2 } '`
equipo=`hostname`
echo "\t"
echo "\t ##################################################################"
echo "\t #                        C O T O  C.I.C.S.A                      #"
echo "\t #                        -------  ---------                      #"
printf "\t %-4s  %-12s %-8s %-17s %-5s %-7s %-1s \n" \
"#" "Fecha......:" $fecha "        " "tty....:" $wrkstn "  #"
printf "\t %-4s  %-12s %-8s %-17s %-5s %-9s %-1s \n" \
"#" "Usuario....:" $user "         " "hora...:" $hora "#"
printf "\t %-4s  %-12s %-20s %-24s %-1s \n" \
"#" "Equipo.....:" $equipo "" "#"
echo "\t ##################################################################"
echo ""
