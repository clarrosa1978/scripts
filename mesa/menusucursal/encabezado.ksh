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
echo -e "\t"
echo -e "\t ##################################################################"
echo -e "\t #                        C O T O  C.I.C.S.A                      #"
echo -e "\t #                        -------  ---------                      #"
printf "\t %-19s %-24s %-21s \n" \
"#     Fecha......:" `date '+%d/%m/%y'` "tty.: `tty`    #"
printf "\t %-19s %-24s %-21s \n" \
"#     Usuario....:" `echo -e $LOGNAME` "hora...: `date '+%T'`   #"
printf "\t %-19s %-44s %-1s \n" \
"#     Equipo.....:" `hostname` "#"
echo -e "\t ##################################################################"
echo -e ""
