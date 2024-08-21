#!/usr/bin/ksh
###############################################################################
# Autor..............: C.A.S                                                  #
# Usuario ...........: root                                                   #
# Objetivo...........: Concentrar las tareas de operaciones en un menu        #
# Nombre del programa: Auditoria_muestra.ksh                                  #
# Descripcion........: Mostrar el ultimo login del usuario                    #
# Modificacion.......: 17/10/2001                                             #
###############################################################################

###############################################################################
#                        Definicion de variables                              #
###############################################################################
#set -x
###############################################################################
#                              Funciones                                      #
###############################################################################

###############################################################################
#                              Principal                                      #
###############################################################################

while true
do
 echo "\t\t\t Ingrese el nombre de equipo: \c"
     read LST_EQUIPOS
 if [ "${LST_EQUIPOS-VACIO}" = "VACIO" ]
  then
   exit
 fi 
 echo "\t\t\t 1.- Alta"
 echo "\t\t\t 2.- Baja"
 echo "\t\t\t s.- Volver al menu anterior"
     read RESPUESTA
 case $RESPUESTA in
   1) for i in `echo $LST_EQUIPOS`
      do 
       echo $i >> $OPERADOR_SIS/equipos.lst
      done
      ;;
   2) grep -v  $LST_EQUIPOS $OPERADOR_SIS/equipos.lst >$OPERADOR_SIS/equipos.tmp
      mv $OPERADOR_SIS/equipos.lst $OPERADOR_SIT/equipos.lst
      ;;
   S|s) exit 
      ;;
   *) echo "\t\t\t Opcion incorrecta"
      echo "'\t\t < Pulse Enter Para Continuar >"
      read nada
 esac
done
