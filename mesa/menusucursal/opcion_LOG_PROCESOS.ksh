#!/usr/bin/ksh
###############################################################################
# Autor..............: TECNOLOGIA (C.A.S)                                     #
# Usuario ...........: sfctrl                                                 #
# Objetivo...........: Mostrar las opciones disponibles de submenu            #
# Nombre del programa: submenu_SFCTRL.ksh                                     #
# Descripcion........: Proviene del menu principal de la opcion Sctrl         #
# Modificacion.......: 23/04/2002                                             #
###############################################################################

###############################################################################
#                        Definicion de variables                              #
###############################################################################


###############################################################################
#                              Principal                                      #
###############################################################################

while true
do
 $SFSW_MENU/encabezado.ksh 
 echo -e "\t\t    ***  O p c i o n  L O G  d e  P r o c e s o s  *** "
 echo -e ""
 echo -e "\t  1.  LOG de Sistema           "
 echo -e "\t  2.  Tarjetas de Credito (TPV a SERVIDOR)    "
 echo -e "\t  3.  Tarjetas de Credito (SERV a CREDITO)    "
 echo -e ""
 echo -e "\t\t            s. - Salir del Menu                             "
 echo -e ""
 echo -e "\t  Ingrese su opcion ==> \c"
 read opcion
 case $opcion in
     1)  $SFSW_MENU/opcion_ELIGE_LCLOG.ksh
           ;;
     2)  $SFSW_MENU/BuscarUltimoLog.ksh .gra /sfctrl/tmp/price
           ;;
     3)  $SFSW_MENU/BuscarUltimoLog.ksh p2s /sfctrl/tmp
           ;;
     S|s)  clear
           exit
           ;;
     *)    $SFSW_MENU/encabezado.ksh
           echo -e ""
           echo -e "\t\t\t\t Opcion Incorrecta"
           echo -e "\t\t\t\t <ENTER>-Continuar \c"
           read nada
           ;;
 esac
done
