#!/usr/bin/ksh
###############################################################################
# Autor..............: C.A.S                                                  #
# Usuario ...........: root                                                   #
# Objetivo...........: Concentrar las tareas de operaciones en un menu        #
# Nombre del programa: menu_Operador.ksh                                      #
# Descripcion........: Muestra un menu con opciones a ejecutar por el operador#
# Modificacion.......: 17/10/2001                                             #
###############################################################################

###############################################################################
#			 Definicion de variables                              #
###############################################################################

export OPERADOR_WRK=/tecnol/operador
export OPERADOR_LOG=$OPERADOR_WRK/log
export OPERADOR_TMP=$OPERADOR_WRK/tmp
export OPERADOR_BKP=$OPERADOR_WRK/backups
export OPERADOR_APL=$OPERADOR_WRK/aplicaciones
export OPERADOR_SIS=$OPERADOR_WRK/sistema
export OPERADOR_UTL=$OPERADOR_WRK/utiles
export OPERADOR_REP=$OPERADOR_WRK/reportes
export OPERADOR_TRANS=$OPERADOR_UTL/transfer
export OPERADOR_NOC=$OPERADOR_WRK/noche
export AX=`tput bold`
export BX=`tput rmso`
export CX=`tput smso`

trap "" 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 # ponele numeros

###############################################################################
#			       Principal                                      #
###############################################################################

while true 
do 
 $OPERADOR_WRK/encabezado.ksh
 echo "\t                   *** ${AX}Menu del Operador${BX} ***        "
 echo ""
 echo "\t            1. - Administracion del Sistema Operativo         " 
 echo ""
 echo "\t            2. - Administracion de Backups                    " 
 echo ""
 echo "\t            3. - Administracion de Aplicaciones               " 
 echo ""
 echo "\t            4. - Utiles Varios                                " 
 echo ""
 echo "\t            5. - Menu de Operaciones Turno Noche              " 
 echo ""
 echo "\t            6. - Salida al Shell                              " 
 echo ""
 echo "\t            s. - Salir del Menu                               " 
 echo ""
 echo " Ingrese su opcion ==> \c                                       " 
 read opcion
 case $opcion in 
     1)  $OPERADOR_SIS/menu_SistemaOperativo.ksh      
         ;; 
     2)  $OPERADOR_BKP/menu_Backups.ksh 
         ;; 
     3)  $OPERADOR_APL/menu_Aplicaciones.ksh  
         ;; 
     4)  $OPERADOR_UTL/menu_UtilesVarios.ksh
         ;;
     5)  $OPERADOR_NOC/menu_oper_tn
         ;; 
     6)  clear 
         /usr/bin/ksh  
         ;; 
     S|s)  clear
         exit
         ;; 
     *)  $OPERADOR_WRK/Incorrecta.ksh
         ;; 
 esac
done
