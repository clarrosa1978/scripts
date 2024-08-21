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
 echo -e "\t\t    ***  S u b m e n u  S t o r e  F l o w  *** "
 echo -e ""
 echo -e "\t  1.  LOGs de Procesos         "
 echo -e "\t  2.  Control de Ofertas       "
 echo -e ""
 echo -e "\t\t            s. - Salir del Menu                             "
 echo -e ""
 echo -e "\t  Ingrese su opcion ==> \c"
 read opcion
 case $opcion in
     1)  $SFSW_MENU/opcion_LOG_PROCESOS.ksh
           ;;
     2)  $SFSW_MENU/Control_OFERTAS.ksh
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
