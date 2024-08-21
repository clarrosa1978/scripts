#!/usr/bin/ksh
###############################################################################
# Autor..............: C.A.S                                                  #
# Usuario ...........: root                                                   #
# Objetivo...........: Concentrar las tareas de operaciones en un menu        #
# Nombre del programa: menu_Backups.ksh                                       #
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
 echo "\t                       *** Menu $NAME_PROG ***                    "
 echo ""
 echo "\t   1. - Backups por FS (backup)                 5. - Restore FS   " 
 echo ""
 echo "\t   2. - Backups Full (backup)                   6. - Restore Full " 
 echo ""
 echo "\t   3. - Backups por Directorios (tar)           7. - Restore Dir  " 
 echo ""
 echo "\t   4. - Backups del systema Operativo (mksysb)                    " 
 echo ""
 echo "\t            s. - Salir del Menu                                   " 
 echo ""
 echo " Ingrese su opcion ==>\c                                             " 
 read opcion
 case $opcion in 
     1)  $OPERADOR_BKP/Backups_porfs.ksh
         ;; 
     2)  $OPERADOR_BKP/Backups_full.ksh
         ;; 
     3)  $OPERADOR_BKP/Backups_dir.ksh
         ;; 
     4)  $OPERADOR_BKP/Backups_mksysb.ksh
         ;; 
     5)  $OPERADOR_BKP/Restore_fs.ksh 
         ;; 
     6)  $OPERADOR_BKP/Restore_full.ksh   
         ;; 
     7)  $OPERADOR_BKP/Restore_dir.ksh   
         ;; 
     S|s)  clear
         exit
         ;; 
     *)  echo "Opcion Incorrecta - < Pulse una tecla para continua >"
         read nada
         ;; 
 esac
done
