#!/usr/bin/ksh
###############################################################################
# Autor..............: C.A.S                                                  #
# Usuario ...........: root                                                   #
# Objetivo...........: Concentrar las tareas de operaciones en un menu        #
# Nombre del programa: menu_SistemaOperativo.ksh                              #
# Descripcion........: Menu con opciones de admistracion del Sistema Operativo#
# Modificacion.......: 17/10/2001                                             #
###############################################################################

###############################################################################
#			 Definicion de variables                              #
###############################################################################

NOMB_PROG=`basename $0 | awk -F "_" '{ print $2 }'`
NAME_PROG=${NOMB_PROG%%.ksh}

###############################################################################
#			       Funciones                                      #
###############################################################################

###############################################################################
#			       Principal                                      #
###############################################################################

while true 
do 
 $OPERADOR_WRK/encabezado.ksh
 echo "\t                       *** Menu $NAME_PROG ***                "
 echo ""
 echo "\t            1. - Auditoria de Usuarios                        " 
 echo ""
 echo "\t            2. - Administracion de Colas de impresion         " 
 echo ""
 echo "\t            3. - Administracion de Discos                     " 
 echo ""
 echo "\t            4. - Visualizar espacio disponible                " 
 echo ""
 echo "\t            s. - Volver al Menu anterior                      " 
 echo ""
 echo " Ingrese su opcion : \c                                         " 
 read opcion
 case $opcion in 
     1)  $OPERADOR_SIS/menu_Auditoria.ksh      
         ;; 
     2)  $OPERADOR_SIS/menu_Impresoras.ksh 
         ;; 
     3)  $OPERADOR_SIS/menu_Discos.ksh  
         ;; 
     4)  $OPERADOR_SIS/menu_EspacioDisco.ksh
         ;; 
     s)  clear
         exit
         ;; 
     S)  clear
         exit
         ;; 
     *)  echo "Opcion Incorrecta - < Pulse una tecla para continua >"
         read nada 
         ;; 
 esac
done
