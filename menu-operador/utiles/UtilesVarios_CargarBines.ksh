###############################################################################
# Autor..............:  C.A.S                                                 # 
# Usuario ...........:  root                                                  # 
# Objetivo...........:  Cargar los Bines por demanda                          # 
# Nombre del programa:  UtilesVarios_CargarBines.ksh                          # 
# Descripcion........:                                                        # 
# Modificacion.......:  11/04/2003                                            # 
###############################################################################

###############################################################################
#                                 Variables                                   #
###############################################################################

OPERADOR_REP=/tecnica/operador/reportes
OPERADOR_UTL=/tecnica/operador/utiles
A=`tput bold`
B=`tput rmso`
ARCHIVO=`echo $0 | awk -F"/" '{ print $NF }'`
RTE=$OPERADOR_REP/${ARCHIVO%%.ksh}.`date +'%Y%m%d`.rpt
REMOTO_REPORTE=/tecnol/ntcierre/log/fincad05.log


###############################################################################
#                                 Funciones                                   #
###############################################################################

. $OPERADOR_UTL/Funciones_Utiles.ksh 

#-----------------------------------------------------------------------------#
#                                 CargarBines                                 #
#-----------------------------------------------------------------------------#

function CargaBines
{
while true
do 
 $OPERADOR_WRK/encabezado.ksh
 echo "\t Ingrese el nombre del archivo de Bines a Cargar ==> \c"
 read BINES
 if [ -z "$BINES" ]
  then 
   echo "<ENTER> - Continuar \c"
   read nada 
   break
  else
   for z in $LISTA_SUCURSALES
    do
     Comunicacion suc$z
     if [ $? -ne 0 ] 
      then
       echo "E R R O R  - $z sin Comunicacion" | tee -a $RTE
      else
       #AbreDomingo suc$z
       #if [ $? -ne 0 ]
       # then  
       #  echo "W A R N I N G - $z No abre Domingo2" | tee -a $RTE
       # else
         echo "Inicio Carga de Bines para suc$z" | tee -a $RTE
         rsh suc$z su - sfctrl -c "ts090305 /sfctrl/$BINES /sfctrl/data/mess_f1.dat" 2>/dev/null
         if [ $? -ne 0 ]
          then 
           echo "E R R O R - No cargo bines en $z " | tee -a $RTE
          else 
           rsh suc$z cat /sfctrl/ts090305.err | tee -a $RTE
         fi
       #fi
     fi
    done
 fi 
done
}

###############################################################################
#                              Principal                                      #
###############################################################################

while true
do
 $OPERADOR_WRK/encabezado.ksh $0
 echo "\t <ENTER> Salir - Ingrese Numero sucursal <ALL|XXX> ==> \c"
 read SUCURSALES
 if [ -z "$SUCURSALES" ]
  then
   break
  else
   case $SUCURSALES in
     ALL) LISTA_SUCURSALES=$LISTASUC
          CargaBines
           ;;
       *) LISTA_SUCURSALES=""
          FLAG=""
          for i in $SUCURSALES
           do
            if [ `echo $i |wc -c` -ne 4 ]
             then 
              echo "\t Ingresar sucursal en tres digitos"
              read nada
              FLAG=ERROR
              break
             else
              if [ $i -ge 100 ]
               then
                LISTA_SUCURSALES="$LISTA_SUCURSALES $i"
               else
                LISTA_SUCURSALES="$LISTA_SUCURSALES `echo $i | cut -c2-3`"
              fi
            fi
           done
           if [ -z "$FLAG" ]
            then
             CargaBines
           fi
           ;;
   esac
 fi
done
