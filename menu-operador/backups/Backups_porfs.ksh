#!/usr/bin/ksh
###############################################################################
# Autor..............: C.A.S                                                  #
# Usuario ...........: root                                                   #
# Objetivo...........: Realizar un backup de determinados Filesystems         #
# Nombre del programa: Backups_porfs.ksh                                      #
# Descripcion........: Levanta los FS por medio de un tar                     #
# Modificacion.......: 02/08/2001                                             #
###############################################################################

###############################################################################
#			 Definicion de variables                              #
###############################################################################

JOBLOG=$OPERADOR_LOG/Backups_porfs.log
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
      echo "\t\t Nombre de los filesystems separados por espacio"
      read LISTA_FS
      if [ "${LISTA_FS-VACIO}" = "VACIO" ]
       then
        RC=20 
       else
        for x in `echo $LISTA_FS`
         do 
          if [ `lsfs -c | awk -F":" '{ print $1 }' | grep -cx $x` -lt 1 ]
           then 
            echo "\t\t\t Error - El Filesystem $x no existe "
            echo "\t\t\t < Pulse una tecla para continuar > \c"
            read nada
            exit 30
          fi
         done
         find $LISTA_FS | backup -iqvf /dev/$TAPE 1>$JOBLOG 2>/dev/null
         if [ $? -ne 0 ] 
          then 
           echo "\t\t\t  Error - Al realizar el backup"
           echo "\t\t\t < Pulse una tecla para continuar > \c"
           read nada
           RC=40
          else
           echo "\t\t\t\t Backup Finalizo Ok "
           echo "\t\t\t < Pulse una tecla para continuar > \c"
           read nada
         fi
         echo "\t\t\t Chequear el log (S/N): \c" 
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
