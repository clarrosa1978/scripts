###############################################################################
# Autor..............:  C.A.S                                                 #
# Usuario ...........:  root                                                  #
# Objetivo...........:  Controlar las Interfaces del Batch GDM                #
# Nombre del programa:  StatusInterface.ksh                                   #
# Descripcion........:  Controla si llegaron las interfaces a las sucursales  #
#                       o al EQUIPO DE CENTRAL                                #
# Modificacion.......:  02/08/2002                                            #
###############################################################################

###############################################################################
#                        Definicion de variables                              #
###############################################################################

OPERADOR_WRK=/tecnica/operador
OPERADOR_TMP=/tecnica/operador/tmp
A=`tput bold`
B=`tput rmso`

###############################################################################
#                              Principal                                      #
###############################################################################

OPERADOR_WRK=/tecnica/operador
while true
do
 $OPERADOR_WRK/encabezado.ksh  $0
 echo "\t                    *** ${A} Control Interfaces  ${B} ***  "
 echo ""
 echo ""
 echo "\t                   1. Chequear todas las sucursales \n"
 echo "\t                   2. Chequear solo una sucursal    \n"
 echo ""
 echo "\t                   s. Salir del menu                \n"
 echo ""
 echo ""
 echo ""
 echo "Ingrese su opcion ==> \c"
 read OPCION
 case $OPCION in
     1) typeset -x SUCURSAL="" 
        CheckInterfaces.ksh
           ;;
     2) $OPERADOR_WRK/encabezado.ksh  $0
        echo "\t Ingrese el numero de sucursal a chequear ==> \c"
        read SUCURSAL
        if [ "${SUCURSAL:=VACIO}" != "VACIO" ]
         then
          typeset -x SUCURSAL
          CheckInterfaces.ksh
         else
          break
        fi
           ;;
   S|s)  break
           ;;
     *)  $OPERADOR_WRK/Incorrecta.ksh
           ;;
 esac
done
