#!/usr/bin/ksh
###############################################################################
# Autor..............: C.A.S                                                  #
# Usuario ...........: root                                                   #
# Objetivo...........: Concentrar las tareas de operaciones en un menu        #
# Nombre del programa: menu_EspacioDisco.ksh                                  #
# Descripcion........: Menu de visualizacion del espacio disponible en        #
#                      sucursales y equipos de central
# Modificacion.......: 09/01/2002                                             #
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
 echo "\t            1. - Visualizar el espacio en disco en sucursales " 
 echo ""
 echo "\t            2. - Visualizar el espacio en disco en el CD      " 
 echo ""
 echo "\t            3. - Visualizar el espacio en disco en Central    " 
 echo ""
 echo "\t            4. - Indicar un equipo en especial                " 
 echo ""
 echo "\t            s. - Volver al Menu anterior                      " 
 echo ""
 echo " Ingrese su opcion : \c                                         " 
 read opcion
 case $opcion in 
     1)  $OPERADOR_SIS/EspacioDisco.ksh SUCURSALES
         ;; 
     2)  $OPERADOR_SIS/EspacioDisco.ksh CENTRODIST
         ;; 
     3)  $OPERADOR_SIS/EspacioDisco.ksh COMCENTRAL 
         ;; 
     4)  $OPERADOR_SIS/EspacioDisco.ksh ESPECIALES
         ;; 
     S|s)  clear
         exit
         ;; 
     *)  echo "Opcion Incorrecta - < Pulse una tecla para continua >"
         read nada 
         ;; 
 esac
done
