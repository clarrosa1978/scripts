#!/usr/bin/ksh
###############################################################################
# Autor..............: C.A.S                                                  #
# Usuario ...........: root                                                   #
# Objetivo...........: Realizar un backup por directorios                     #
# Nombre del programa: Restore_dir.ksh                                        #
# Descripcion........: Utiliza el comando tar para realizar backup relativo   #
# Modificacion.......: 02/08/2001                                             #
###############################################################################

###############################################################################
#			 Definicion de variables                              #
###############################################################################

JOBLOG=$OPERADOR_LOG/Restore_dir.log
BLOCK_NEW=1024
MODIFICADO=0
RC=0

###############################################################################
#			 Definicion de Funciones                              #
###############################################################################

function cant_tape
{
### ----------------------------------------------------------------------- ###
### Objetivo: Permitir seleccionar el tape en caso de que exista mas de uno ###
### ----------------------------------------------------------------------- ###

if [ `lsdev -Cc tape | wc -l` -gt 1 ]
 then 
  lsdev -Cc tape | awk 'BEGIN { print "Dispostivo	Estado" } \
  { print $1"	"$2 }'    
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

function tam_bloque
{
### ----------------------------------------------------------------------- ###
### Objetivo: Cambiar el bock_size del device a 1024 para el backup         ###
### ----------------------------------------------------------------------- ###

BLOCK_OLD=`lsattr -l rmt0 -E -O | tail -1 | awk -F":" '{ print $2 }'`
if [ $BLOCK_OLD -ne $BLOCK_NEW ]
 then   
  chdev  -l 'rmt0' -a block_size='$BLOCK_NEW'
  if [ $? -ne 0 ] 
   then 
    echo "\t\t Error - Al intentar cambiar el block_size del tape"
    echo "\t\t\t < Pulse una tecla para continuar > \c"
    read nada
    return 1
   else
    MODIFICADO=1
  fi
fi
}

### ----------------------------------------------------------------------- ###
###                        Fin tam_bloque                                   ###
### ----------------------------------------------------------------------- ###

###############################################################################
#			       Principal                                      #
###############################################################################

$OPERADOR_WRK/encabezado.ksh
cant_tape
mt -f /dev/$TAPE rewind 2>/dev/null
if [ $? -ne 0 ]
 then 
  echo "\t\t\t Coloque la cinta en la unidad $TAPE"
  echo "\t\t\t < Pulse una tecla para continuar > \c"
  read nada
 else  
    tam_bloque
    if [ $? -ne 0 ]
     then
      RC=10      
     else
      echo "\t\t\t  Ingrese el nombre del directorio posicion: "
      read DIRECTORIO  
      if [ ! -d $DIRECTORIO ]
       then 
        echo "\t\t Error - El directorio $DIRECTORIO no existe"
        echo "\t\t\t < Pulse una tecla para continuar > \c"
        read nada
        RC=20
       else 
        cd $DIRECTORIO
        echo "\t\t Nombre del directorio a restorear"
        read DIR_BACKUP 
        tar -xvf /dev/$TAPE 1>$JOBLOG 2>/dev/null
        if [ $? -ne 0 ]
         then 
          echo "\t\t Error  -   Al bajar los archivos"
          echo "\t\t < Pulse una tecla para continuar > \c"
          read nada
          RC=30  
         else 
          echo "\t\t Restauracion Finalizo OK"
          echo "\t\t < Pulse una tecla para continuar > \c"
          read nada
        fi
        echo "\t\t Chequear log (S/N) \c"
                read RESPUESTA
          case $RESPUESTA in 
           S|s) more -d $JOBLOG
              rm -f $JOBLOG
              ;;
           N|n) rm -f $JOBLOG
              ;;
           *) $OPERADOR_WRK/Incorrecta.ksh
              ;;
          esac
      fi
    fi
fi

if [ $MODIFICADO -ne 0 ]
 then 
  BLOCK_NEW=$BLOCK_OLD
  tam_bloque
fi

exit $RC
