#!/usr/bin/ksh
###############################################################################
# Autor..............: C.A.S                                                  #
# Usuario ...........: root                                                   #
# Objetivo...........: Realizar un backup del Sistema Operativo               #
# Nombre del programa: Backups_porfs.ksh                                      #
# Descripcion........: Backup del S.O mediante el comando mksysb              #
# Modificacion.......: 31/07/2001                                             #
###############################################################################

###############################################################################
#			 Definicion de variables                              #
###############################################################################

JOBLOG=$OPERADOR_LOG/Backups_mksysb.log

###############################################################################
#                        Definicion de Funciones                              #
###############################################################################

function cant_tape
{

### ----------------------------------------------------------------------- ###
### Objetivo: Permitir seleccionar el tape en caso de que exista mas de uno ###
### ----------------------------------------------------------------------- ###

if [ `lsdev -Cc tape | wc -l` -gt 1 ]
 then
  lsdev -Cc tape | awk 'BEGIN { print "Dispostivo       Estado" } \
  { print $1"   "$2 }'
  echo ""
  echo "\t\t Ingrese el Dispositivo deseado: \c"
       read TAPE
 else
  TAPE=`lsdev -Cc tape | awk '{ print $1 }'`
fi

}
### ----------------------------------------------------------------------- ###
###                        Fin cant_tape                                    ###
### ----------------------------------------------------------------------- ###

###############################################################################
#			       Principal                                      #
###############################################################################

$OPERADOR_WRK/encabezado.ksh
cant_tape
mt -f /dev/$TAPE rewind 2>/dev/null
if [ $? -ne 0 ]
 then 
  echo "\t\t\t Coloque la cinta en la unidad rmt0"
  echo "\t\t\t < Pulse una tecla para continuar > \c"
  read nada
 else
  REQUERIDO=`bosboot -a -q | grep /tmp | awk '{ print $2 }'`  
  EXISTENTE=`df -k /tmp | grep /tmp | awk '{ print $3 }'`  
  if [ $REQUERIDO -gt $EXISTENTE ]
   then
    ESPACIO=`expr $REQUERIDO - $EXISTENTE` 
    echo "\t\t Se requiere $ESPACIOkbytes en el /tmp para el image.data"
    echo "\t\t\t < Pulse una tecla para continuar > \c"
    read nada
    exit 1
   else 
    /usr/bin/mkszfile
    if [ $? -ne 0 ]
     then 
      echo "\t\t Error - Al crear el /image.data"
      echo "\t\t < Pulse una tecla para continuar > \c"
      read nada
      exit 1
      echo 
     else
      /usr/bin/mksysb /dev/$TAPE
      if [ $? -ne 0 ]
       then 
        echo "\t\t Error - Al realizar el mksysb"
        echo "\t\t < Pulse una tecla para continuar > \c"
        read nada
       else 
        echo "\t\t\t\t Mksysb Finalizo OK "
        echo "\t\t < Pulse una tecla para continuar > \c"
        read nada
      fi
   fi 
 fi
fi
