###############################################################################
# Autor..............:  TECNOLOGIA (C.A.S)                                    # 
# Usuario ...........:  root                                                  # 
# Objetivo...........:  Comprobar la existencia del DBLINK enviado como       # 
#                       parametro                                             # 
# Nombre del programa:  UtilesVarios_ChequeaDblink.ksh                        # 
# Descripcion........:  Chequea la existencia del DBLINK ingresado como       # 
#                       parametro 1 para el usuario ingresado como parametro 2# 
# Modificacion.......:  15/04/2003                                            # 
###############################################################################

###############################################################################
#                                 Variables                                   #
###############################################################################

OPERADOR_REP=/tecnica/operador/reportes
OPERADOR_WRK=/tecnica/operador
OPERADOR_UTL=/tecnica/operador/utiles
OPEREMOT_UTL=/tecnol/operador/utiles
CNX=u601
A=`tput bold`
B=`tput rmso`
ARCHIVO=`basename $0`
RTE=$OPERADOR_REP/${ARCHIVO%%.ksh}.`date +'%Y%m%d`.rpt


###############################################################################
#                                 Funciones                                   #
###############################################################################

. $OPERADOR_UTL/Funciones_Utiles.ksh 

#-----------------------------------------------------------------------------#
#                                 IngresaDatos                                #
#-----------------------------------------------------------------------------#

function IngresaDatos
{
$OPERADOR_WRK/encabezado.ksh
echo "\n\n\t Ingrese el USERNAME [default:$1] ==> \c "
read USU
if [ "${USU:=$1}" = "$1" ]
 then
  echo "\t Ingrese Numero sucursal <ALL|XXX> ==> \c"
  read SUCURSAL
  if [ ! -z "$SUCURSAL" ]
   then
    case $SUCURSAL in
     ALL) LISTA_SUCURSALES=$LISTASUC
          ;;
       *) LISTA_SUCURSALES=""
          for i in $SUCURSAL
           do
            if [ `echo $i |wc -c` -ne 4 ]
             then 
              echo "\t Ingresar sucursal en tres digitos"
              echo "\t <ENTER> - Continuar \c"
              read nada
              return 1
             else
              if [ $i -ge 100 ]
               then
                LISTA_SUCURSALES="$LISTA_SUCURSALES $i"
               else
                LISTA_SUCURSALES="$LISTA_SUCURSALES `echo $i | cut -c2-3`"
              fi
            fi
           done
           ;;
    esac 
   else
    return 1
  fi
 else
  return 1
fi
}
#-----------------------------------------------------------------------------#
#                                 IngresaDatos2                               #
#-----------------------------------------------------------------------------#

function IngresaDatos2
{
$OPERADOR_WRK/encabezado.ksh
echo "\t Ingrese Numero sucursal <ALL|XXX> ==> \c"
read SUCURSAL
if [ ! -z "$SUCURSAL" ]
 then
  case $SUCURSAL in
   ALL) LISTA_SUCURSALES=$LISTASUC
          ;;
     *) LISTA_SUCURSALES=""
          for i in $SUCURSAL
           do
            if [ `echo $i |wc -c` -ne 4 ]
             then 
              echo "\t Ingresar sucursal en tres digitos"
              echo "\t <ENTER> - Continuar \c"
              read nada
              return 1
             else
              if [ $i -ge 100 ]
               then
                LISTA_SUCURSALES="$LISTA_SUCURSALES $i"
               else
                LISTA_SUCURSALES="$LISTA_SUCURSALES `echo $i | cut -c2-3`"
              fi
            fi
           done
           ;;
  esac 
 else
  return 1
fi
}


#-----------------------------------------------------------------------------#
#                                 ChequeaDblink                               #
#-----------------------------------------------------------------------------#

function ChequeaDblink
{
DBLINK="$1.WORLD"
for z in $LISTA_SUCURSALES
 do
  Comunicacion suc$z
  if [ $? -ne 0 ]
   then 
    echo "\t E R R O R  Comunicacion con suc$z"
    echo "<ENTER> - Continuar \c" 
    read nada
   else
    rsh suc$z \
     '( 
        if [ ! -r '$OPEREMOT_UTL'/existedblnk.sql ]
         then 
          echo "ERROR"
         else
          if [ ! -r '$OPEREMOT_UTL'/comunicadblnk.sql ]
           then
           echo "ERROR"
          fi
        fi
     )' | if [ `grep -c ERROR` -eq 1 ]
           then 
            echo "E R R O R - Faltan archivos sqls en suc$z"
            echo "<ENTER> - Continuar \c"
            read nada
           else
            echo "\t Comprobando la existencia del DBLINK $DBLINK "       
            echo "\t para el USU $USU en SUCURSAL $z              " 
            CMD1=`rsh suc$z sqlplus -s $CNX/$CNX @$OPEREMOT_UTL/existedblnk.sql $DBLINK $USU`
            if [ $CMD1 -ge 1 ]
             then 
              echo "\t DBLINK $DBLINK $A EXISTE $B"
              echo "\t <ENTER> - Continuar \c"
              return 0 
             else 
              echo "\t DBLINK $DBLINK $A NO EXISTE $B"
              echo "\t <ENTER> - Continuar \c"
              return 1 
            fi
          fi
  fi
 done
}

#-----------------------------------------------------------------------------#
#                             ComunicaDblink                                  #
#-----------------------------------------------------------------------------#

function ComunicaDblink
{
for m in $LISTA_SUCURSALES
 do
  CMD2=`rsh suc$m sqlplus -s $CNX/$CNX @$OPEREMOT_UTL/comunicadblnk.sql | \
        grep -v '^$'` 
  if [ "$CMD2" = "`date '+%d-%b-%y' | tr 'a-z' 'A-Z'`" ]
   then 
    echo "\t DBLINK $A COMUNICA $B"
   else 
    echo "\t DBLINK $A NO COMUNICA $B"
  fi
 done
}

###############################################################################
#                              Principal                                      #
###############################################################################

while true
do
 $OPERADOR_WRK/encabezado.ksh $0
 echo ""
 echo "\t\t\t 1. Chequear el DBLINK de ENVIOS                         " 
 echo ""
 echo "\t\t\t 2. Chequear el DBLINK de CTEFTE                         " 
 echo ""
 echo "\t\t\t 3. OTROS                                                " 
 echo ""
 echo "\t\t\t 4. Probar comunicacion DBLINK ENVIOS                    " 
 echo ""
 echo "\t\t   s. - Salir del Menu                                     " 
 echo ""
 echo " Ingrese su opcion ==> \c                                      " 
 read opcion 
 case $opcion in 
   1) IngresaDatos U601
      if [ $? -eq 0 ]
       then 
        ChequeaDblink ENVIOS $USU
        read nada
      fi
      ;;
   2) IngresaDatos SF_CTEFTE
      if [ $? -eq 0 ]
       then 
        ChequeaDblink CTEFTE $USU
        read nada
      fi
      ;;
   3) $OPERADOR_WRK/encabezado.ksh
      echo ""
      echo "\t Ingrese el nombre del DB_LINK ==> \c"
      read DBLINK
      if [ ! -z "$DBLINK" ]
       then
        IngresaDatos 
        if [ $? -eq 0 ]
         then
          ChequeaDblink CTEFTE $USU
          read nada
        fi
      fi
      ;;
    4) IngresaDatos2
       if [ $? -eq 0 ]
        then
         ComunicaDblink
         echo "\t <ENTER> - Continuar \c"
         read nada
       fi
      ;;
  S|s) clear 
      exit 
      ;;
   *)  clear                           
      ;;
 esac
done
