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
 echo "\t\t    ***  S u b m e n u  S t o r e  F l o w  *** "
 echo ""
 echo "\t  1.  Control de Cargas Pendientes	"
 echo "\t  2.  Blanqueo de Cargas Pendientes	"
 echo "\t  3.  Blanqueo de Act. de Terminal     "
 echo "\t  4.  Performance de Terminales"
 echo "\t  5.  Procesos de Atencion a Terminales"
 echo "\t  6.  Reasignar archivo de nombres logicos"
 echo "\t  7.  Cambiar entorno de terminal"
 echo "\t  8.  Consulta DATEHORAS"
 echo "\t  9.  Consulta de Pedidos Digital"
 echo "\t  10. Consulta TRX del dia"
 echo "\t  11. Consulta Terminales"
 echo "\t  12. Cargas Cambio de Entorno"
 echo ""
 echo "\t\t            s. - Salir del Menu                             "
 echo ""
 echo "\t  Ingrese su opcion ==> \c"
 read opcion
 case $opcion in
     1)  $SFSW_MENU/Control_CARGAS_PEND.ksh
           ;;
     2)  $SFSW_MENU/Ejecucion_BLANQUEO_CARGAS.ksh
           ;;
     3)  $SFSW_MENU/Ejecucion_BLANQUEO_TERMINAL.ksh
           ;;
     4)  $SFSW_MENU/Control_Performance.ksh
           ;;
     5)  $SFSW_MENU/Control_COMUNICACIONES.ksh
           ;;
     6)  $SFSW_MENU/CtrlMod
           ;;
     7)  $SFSW_MENU/scripts/cambia_entorno_0.sh
           ;;
     8)  $SFSW_MENU/scripts/ConsultaOnlines.sh
           ;;
     9)  $SFSW_MENU/scripts/ConsultaPedido.sh
           ;;
     10)  $SFSW_MENU/scripts/ConsultaTRXdeldia.sh
           ;;
     11)  $SFSW_MENU/scripts/ConsultaTerminales.sh
           ;;
     12)  $SFSW_MENU/scripts/CargasCambiodeEntorno.sh
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
