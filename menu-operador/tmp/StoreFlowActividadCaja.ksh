#!/usr/bin/ksh
###############################################################################
# Autor..............: C.A.S                                                  #
# Usuario ...........: root                                                   #
# Objetivo...........: Mostrar por pantalla los errores de una Caja           #
# Nombre del programa: StoreFlowActividadCaja.ksh                             #
# Descripcion........: Realiza un grep del archivo lclog de la sucursal       #
# Modificacion.......: 13/02/2002                                             #
###############################################################################

###############################################################################
#                        Definicion de variables                              #
###############################################################################

export OPERADOR_WRK=/tecnica/operador
export OPERADOR_HDESK=/home/hdesk
SFCTRL_ELE=/sfctrl/l

###############################################################################
#                        Definicion de Funciones                              #
###############################################################################

#-----------------------------------------------------------------------------#
#                         Inicio funcion Mostrar                              #
#-----------------------------------------------------------------------------#

function Mostrar
{
$OPERADOR_WRK/encabezado.ksh
CONTADOR=0
rsh suc${NROSUCURSAL} cat ${1} |while read FECHA HORA ELE CAJA ACTM ESTADO \
 A B C D E F G H I J K L M N O P Q R S
 do
  if [ "${CAJA:=VACIO}" = "${CajaNro}" ]
   then
    echo "\t\t\t $FECHA $HORA $ELE $CAJA $ACTM $ESTADO $A $B $C $D $E $F $G $H $I $J $K $L $M $N $O $P $Q $R $S"
    CONTADOR=`expr $CONTADOR + 1`
    if [ $CONTADOR -eq 13 ]
     then
      echo "\n\t\t      <CTRL-s> - Detener | <CTRL-q> - Continuar \c"
      sleep 3
      CONTADOR=0
      $OPERADOR_WRK/encabezado.ksh
    fi
  fi
 done
 echo "\n\t\t\t <ENTER> - Volver al Menu Principal \c"
 read nada
}

#-----------------------------------------------------------------------------#
#                          Fin funcion Mostrar                                #
#-----------------------------------------------------------------------------#
#-----------------------------------------------------------------------------#
#                     Inicio funcion CajasDisponibles                         #
#-----------------------------------------------------------------------------#

function CajasDisponibles
{
$OPERADOR_WRK/encabezado.ksh
echo "\t\t C a j a s  D i s p o n i b l e s  S u c u r s a l  $i \n"
rsh suc${1} '( columnas=1
             filas=1 
             for i in `ls '$SFCTRL_ELE'/load???.dat | cut -c15-17`
              do
               echo "\t $i \c"
               columnas=`expr $columnas + 1`
               if [ $columnas -eq 10 ]
                then
                 columnas=1
                 filas=`expr $filas + 1` 
                 echo "\n"
               fi
               if [ $filas -eq 7 ]
                then
                 filas=1
                 echo "\t\t\t\t <ENTER> - Continuar \c"
                 read nada
                 echo "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
              fi
              done
          )'
} 

#-----------------------------------------------------------------------------#
#                  Fin funcion CajasDisponibles                               #
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
#                  Inicio funcion ValidaNroCaja                               #
#-----------------------------------------------------------------------------#

function ValidaNroCaja
{
rsh suc${1} \
'( if [ `ls '$SFCTRL_ELE'/load???.dat | cut -c15-17 | grep -wc '$CajaNro'` -eq 0 ]
    then 
     echo "NOEXISTE"
   fi
)' | if [ `grep -c "NOEXISTE"` -eq 1 ]
      then
       $OPERADOR_WRK/encabezado.ksh
       echo "\t\t\t Error no existe numero de caja $CajaNro "
       echo "\t\t\t\t <ENTER> - Continuar \c"
       return 1
     fi
} 

#-----------------------------------------------------------------------------#
#                        Fin funcion ValidaNroCaja                            #
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
#                       Inicio funcion comunicacion                           #
#-----------------------------------------------------------------------------#

function comunicacion
{
/usr/sbin/ping -c 3 suc${1} 2>&1 >/dev/null
if [ $? -ne 0 ]
 then
  echo "\t Error no existe comunicacion con suc${1}"
  echo "\t <ENTER> - Continuar \c"
  read nada
  return 1
fi
}

#-----------------------------------------------------------------------------#
#                        Fin funcion comunicacion                             #
#-----------------------------------------------------------------------------#
#-----------------------------------------------------------------------------#
#                      Inicio funcion ValidaSucursal                          #
#-----------------------------------------------------------------------------#
function ValidaSucursal
{
if [ `echo "$LISTASUC 76" | grep -wc ${1}` -eq 0 ]
 then
  echo "\t Error numero de sucursal ${1} no existe "
  echo "\t <ENTER> - Continuar \c"
  read nada
  return 1
  fi
}

#-----------------------------------------------------------------------------#
#                      Fin funcion ValidaSucursal                             #
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
#                    Inicio funcion StoreFlowCajas                            #
#-----------------------------------------------------------------------------#

function StoreFlowCajas
{
$OPERADOR_WRK/encabezado.ksh
echo "\t Ingrese el numero de sucursal ==> \c"
     read NUMBER
if [ "${NUMBER:=VACIO}" != "VACIO" ]
 then
  for NROSUCURSAL in `echo $NUMBER`
   do
    ValidaSucursal $NROSUCURSAL
    if [ $? -eq 0 ]
     then
      comunicacion $NROSUCURSAL
      if [ $? -eq 0 ]
       then
        CajasDisponibles $NROSUCURSAL
        if [ $? -eq 0 ]
         then 
          echo "\n"
          echo "\t Ingrese el numero de Caja ==> \c"
          read CajaNro
          if [ "${CajaNro:=VACIO}" != "VACIO" ]
           then 
            ValidaNroCaja $NROSUCURSAL
            if [ $? -eq 0 ]
             then 
              if [ "${1}" = "ACTUAL" ]
               then 
                Mostrar $SFCTRL_ELE/lclog
               else
                Mostrar $SFCTRL_ELE/lclog.save
              fi
             else
              read nada
            fi
           else 
            return  
          fi
          else 
          echo "\t No es posible mostrar las cajas disponibles"
          echo "\t <ENTER> - Continuar \c"
          read nada
        fi
      fi
    fi
   done
fi
}

#-----------------------------------------------------------------------------#
#                      Fin funcion StoreFlowCajas                             #
#-----------------------------------------------------------------------------#

###############################################################################
#                               Principal                                     #
###############################################################################

while true 
 do 
  $OPERADOR_WRK/encabezado.ksh
  echo "\t                       *** Menu del HelpDesk ***              "
  echo ""
  echo "\t            1. - Actividad de Una caja dia ACTUAL             "
  echo ""
  echo "\t            2. - Actividad de Una caja dia Anterior           "
  echo ""
  echo "\t            s. - Salir del Menu                               "
  echo ""
  echo " Ingrese su opcion ==> \c                                       "
    read opcion
  case $opcion in
       1)  StoreFlowCajas ACTUAL     
           ;;
       2)  StoreFlowCajas ANTERIOR 
           ;;
       S|s)  clear
             exit
           ;;
       *)  $OPERADOR_WRK/Incorrecta.ksh
           ;;
  esac
done
