#!/usr/bin/ksh
###############################################################################
# Autor..............: C.A.S                                                  #
# Usuario ...........: root                                                   #
# Objetivo...........: Concentrar las tareas de operaciones en un menu        #
# Nombre del programa: menu_Aplicaciones.ksh                                  #
# Descripcion........: Muestra un menu con opciones a ejecutar por el operador#
# Modificacion.......: 17/10/2001                                             #
###############################################################################

###############################################################################
#			 Definicion de variables                              #
###############################################################################

NOMB_PROG=`basename $0 | awk -F "_" '{ print $2 }'`
NAME_PROG=${NOMB_PROG%%.ksh}

###############################################################################
#			       Principal                                      #
###############################################################################

while true 
do 
 $OPERADOR_WRK/encabezado.ksh
 echo "\t                       *** Menu $NAME_PROG ***                     "
 echo ""
 echo "\t           1 - Negativos de Tickets (envio_negtick)     " 
 echo "\t           2 - Enviar coto01                            " 
 echo "\t           3 - Administracion de Aplicaciones           " 
 echo "\t           4 - Transferncia de archivos juncadella      " 
 echo "\t           5 - Post Cierre Cedeco envio DATOS (Pucara)  " 
 echo "\t           6 - Post Cierre Cedeco envio DATOSH (Pucara) " 
 echo "\t           7 - Descomprimir archivos DATOS              " 
 echo "\t           8 - Descomprimir archivos DATOSH             " 
 echo "\t           9 - Envio de archivos a FAMABA               " 
 echo "\t           10- Descomprimir archivos de FAMABA          " 
 echo "\t           s - Salir del Menu                           " 
 echo ""
 echo " Ingrese su opcion ==> \c                                     " 
 read opcion
 case $opcion in 
  1) $OPERADOR_APL/Aplicaciones_envio_negtick.ksh 
         ;; 
  2) $OPERADOR_BKP/Aplicaciones_envio_coto01.ksh
         ;; 
  3) $OPERADOR_APL/menu_Aplicaciones.ksh  
         ;; 
  4) $OPERADOR_APL/Aplicaciones_Arch_juncadella.ksh
	 ;;
  5) $OPERADOR_APL/Aplicaciones_cierre_cedeco.ksh \
     pucara /ac/DATOS /u/usr/cedeco PRIMERO	
         ;;
  6) $OPERADOR_APL/Aplicaciones_cierre_cedeco.ksh \
     pucara /ac/DATOSH /u/usr/viejo SEGUNDO
         ;; 
  7) $OPERADOR_APL/Aplicaciones_remoto_cedeco.ksh /u/usr/cedeco
         ;; 
  8) $OPERADOR_APL/Aplicaciones_remoto_cedeco.ksh /u/usr/viejo
         ;; 
  9) $OPERADOR_APL/Aplicaciones_cierre_famaba.ksh 
         ;; 
  S|s)  clear
         exit
         ;; 
  *)  echo "Opcion Incorrecta - < Pulse una tecla para continua >"
         read nada
         ;; 
 esac
done
