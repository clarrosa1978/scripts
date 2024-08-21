###############################################################################
# Autor..............:  C.A.S                                                 # 
# Usuario ...........:  root                                                  # 
# Objetivo...........:  Mostrar el reporte de la carga de Bines               # 
# Nombre del programa:  UtilesVarios_Bines.ksh                                # 
# Descripcion........:  Genera un reporte en el directorio tmp equipos        # 
# Modificacion.......:  04/11/2003                                            # 
###############################################################################

###############################################################################
#                        Definicion de variables                              #
###############################################################################

OPERADOR_REP=/tecnica/operador/reportes
A=`tput bold`
B=`tput rmso`
ARCHIVO=`echo $0 | awk -F"/" '{ print $NF }'`
RTE=$OPERADOR_REP/${ARCHIVO%%.ksh}.`date +'%Y%m%d`.rpt
REMOTO_REPORTE=/tecnol/ntcierre/log/fincad05.log

#-----------------------------------------------------------------------------#
#                      Inicio Funcion Comunicacion                            #
#-----------------------------------------------------------------------------#

function Comunicacion
{
ping -c 3 suc${1} >/dev/null 2>&1
if [ $? -ne 0 ]
 then
  return 1 
fi 
}

#-----------------------------------------------------------------------------#
#                   Inicio Funcion ReporteBines                        #
#-----------------------------------------------------------------------------#

function ReporteBines
{
cp /dev/null $RTE 
echo "------------------------------------------------------------------"\
 | tee -a $RTE
echo "-  `date +'%d%m%Y (%r) -'` COTO CICSA REPORTE BINES               "\
 | tee -a $RTE
echo "------------------------------------------------------------------"\
 | tee -a $RTE

for x in `echo $LISTA_SUCURSALES`
do
 Comunicacion $x
 if [ $? -ne 0 ] 
  then 
   echo "## `date +'%r'` - S I N  C O M U N I C A C I O N  C O N  $x "\
   | tee -a $RTE
  else
   rsh suc$x '( 
    if [ -f '$REMOTO_REPORTE' ]
     then
      cat '$REMOTO_REPORTE'
     else
      echo "## `date +'%r'` - N O  C O R R I O  E L  P R O C E S O  E N '$x' ##"
    fi
             )' | tee -a $RTE
 fi
done
echo "\n\t Fin del Reporte <ENTER> - Continuar \c"
read nada
}

###############################################################################
#                              Principal                                      #
###############################################################################

while true
do
 $OPERADOR_WRK/encabezado.ksh $0
 echo "\t <ENTER> Salir - Ingrese Numero sucursal <ALL|XXX> ==> \c"
 read SUCURSALES
 if [ "${SUCURSALES:=VACIO}" = "VACIO" ]
  then
   break
  else
   case $SUCURSALES in
     ALL) LISTA_SUCURSALES=$LISTASUC
          ReporteBines
           ;;
       *) LISTA_SUCURSALES=""
          FLAG=""
          for i in `echo $SUCURSALES`
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
           if [ "${FLAG:=VACIO}" = "VACIO" ]
            then
             ReporteBines
           fi
           ;;
   esac
 fi
done

