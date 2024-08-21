#!/usr/bin/ksh
###############################################################################
# Autor..............: C.A.S                                                  #
# Usuario ...........: root                                                   #
# Objetivo...........: Concentrar las tareas de operaciones en un menu        #
# Nombre del programa: TransferVtaplu.ksh                                     #
# Descripcion........: Enviar los vtaplu del J30 al ODIN                      #
# Modificacion.......: 17/10/2001                                             #
###############################################################################

###############################################################################
#			 Definicion de variables                              #
###############################################################################

export VTAPLU_WRK=/sfctrl/data/fromsucursal
export JOBLOG=/tecnica/operador/tmp/trf_vtaplu.log
export DIR_DESTINO=/u01/DSS/gdm/interface
export TECNICA_BIN=/tecnica/bin
export HOST_DESTINO="odin"
export AX=`tput bold`
export BX=`tput rmso`
export CX=`tput smso`

###############################################################################
#			   Definicion Funciones                               #
###############################################################################

#-----------------------------------------------------------------------------#
#                         Inicio Funcion Comunicacion                         #
#-----------------------------------------------------------------------------#

function Comunicacion
{
ping -c 3 odin 2>&1 >/dev/null
if [ $? -ne 0 ]
 then 
  return 1 
fi
}


###############################################################################
#			       Principal                                      #
###############################################################################
rm -f $JOBLOG
/tecnica/operador/encabezado.ksh
while true
do 
  echo "Ingresar la Fecha que se desea enviar (DDMM) ==> \c"
  read FECHA
  if [ "${FECHA:=VACIO}" = "VACIO" ]
   then
    exit
  fi
  echo "Confirma el inicio de la  transferencia (S/N) ==> \c"
  read OPCION
  case $OPCION in
   S|s) echo "=====================================================" \
        | tee -a $JOBLOG
        echo " Iniciando Proceso tranferencia VtaPlu `date`        " \
        | tee -a $JOBLOG
        echo "=====================================================" \
        | tee -a $JOBLOG
        for i in `ls -d1 $VTAPLU_WRK/suc* | awk -F"/" '{ print $NF }'` 
         do
          DIR_ORIGEN=$VTAPLU_WRK/${i}
          ARCHIVO_ORIGEN=vtaplu.asc.${FECHA}
          echo "Iniciando transferencia de $i a Odin"
          if [ ! -s $DIR_ORIGEN/$ARCHIVO_ORIGEN ]
           then
            echo "Error - No existe archivo vtaplu en $i para $FECHA" \
            | tee -a $JOBLOG
           else
            Comunicacion
            if [ $? -ne 0 ]
             then 
              echo "Error - No existe comunicacion con el Odin" | tee -a $JOBLOG
             else  
              NUM=`echo $i | tr -d 'a-z'`
              if [ ${NUM} -gt 99 ] 
               then
                NUMERO=$NUM
                ARCHIVO_DESTINO=vtaplu.${NUMERO}.${FECHA}
               else
                NUMERO="0${NUM}"
                ARCHIVO_DESTINO=vtaplu.${NUMERO}.${FECHA}
              fi
              rcp -p $DIR_ORIGEN/$ARCHIVO_ORIGEN \
              $HOST_DESTINO:$DIR_DESTINO/$ARCHIVO_DESTINO
              if [ $? -ne 0 ] 
               then 
                echo "Error $RC - En el safe_rcp del $ARCHIVO_ORIGEN al Odin" \
                | tee -a $JOBLOG
               else 
               rsh $HOST_DESTINO \
               chown csid0579:user $DIR_DESTINO/$ARCHIVO_DESTINO
               rsh $HOST_DESTINO \
               chmod 666 $DIR_DESTINO/$ARCHIVO_DESTINO
               if [ $? -ne 0 ]
                then 
                 echo "Error - Al cambiar owner en equipo remoto"\
                 | tee -a $JOBLOG
                else 
                 echo "$ARCHIVO_ORIGEN Transferido a $HOST_DESTINO como $ARCHIVO_DESTINO" \
                 | tee -a $JOBLOG
               fi 
              fi
            fi
          fi     
        done 
        echo "=====================================================" \
        | tee -a $JOBLOG
        echo " Fin Proceso tranferencia VtaPlu `date`        " \
        | tee -a $JOBLOG
        echo "=====================================================" \
        | tee -a $JOBLOG
        break
                     ;;
           
   N|n) exit
                     ;;
     *) /tecnica/operador/Incorrecta.ksh
                     ;;
  esac
done
