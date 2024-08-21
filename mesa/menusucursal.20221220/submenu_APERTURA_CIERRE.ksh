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
 echo "\t\t ***  S u b m e n u  A p e r t u r a / C i e r r e ***"
 echo ""
 echo "\t  1. Control de Centro         "
 echo "\t  2. Control de Empresa        "
 echo ""
 echo "\t\t            s. - Salir del Menu                             "
 echo ""
 echo "\t  Ingrese su opcion ==> \c"
 read opcion
 case $opcion in
     1)  $SFSW_MENU/Control_CENTRO.ksh
           ;;
     2)  $SFSW_MENU/Control_EMPRESA.ksh
           ;;
     S|s)  clear
           exit
           ;;
     *)    $SFSW_MENU/encabezado.ksh
           echo ""
           echo "\t\t\t\t Opcion Incorrecta"
           echo "\t\t\t\t <ENTER>-Continuar \c"
           read nada
           ;;
 esac
done
