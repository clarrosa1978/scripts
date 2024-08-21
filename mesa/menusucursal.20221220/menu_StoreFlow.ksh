#!/usr/bin/ksh
###############################################################################
# Autor..............: TECNOLOGIA (C.A.S)                                     #
# Usuario ...........: sfctrl                                                 #
# Objetivo...........: Concentrar las tareas del usuario sfctrl en un menu    #
# Nombre del programa: menu_StoreFlow.ksh                                     #
# Descripcion........: Muestra las opciones disponibles para usuarios del     #
#                      ambiente Store Flow                                    #
# Modificacion.......: 23/04/2002                                             #
###############################################################################

###############################################################################
#                        Definicion de variables                              #
###############################################################################

export SFSW_HOME=/tecnol/mayuda
export SFSW_MENU=$SFSW_HOME

###############################################################################
#                        Definicion de Funciones                              #
###############################################################################

###############################################################################
#                              Principal                                      #
###############################################################################

while true
do
 $SFSW_MENU/encabezado.ksh
 echo -e "\t\t    ***  S i s t e m a  S t o r e  F l o w  *** "
 echo -e ""
 echo -e ""
 echo -e "\t\t  1.  Storeflow               " 
 echo -e "\t\t  2.  Soporte                 "
 echo -e ""
 echo -e ""
 echo -e "\t\t            s. - Salir del Menu                             "
 echo -e ""
 echo -e "\t  Ingrese su opcion ==> \c"
 read opcion
 case $opcion in
     1)  $SFSW_MENU/submenu_SFCTRL.ksh
           ;;
     2)  $SFSW_MENU/submenu_SOPORTE.ksh
            ;;
     S|s)  clear
           exit
           ;;
     *)    $SFSW_BIN/encabezado.ksh 
           echo -e ""
           echo -e "\t\t\t\t Opcion Incorrecta"
           echo -e "\t\t\t\t <ENTER>-Continuar \c"
           read nada
           ;;
 esac
done
