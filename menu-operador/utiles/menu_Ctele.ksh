#!/chbin/ksh
###############################################################################
# Autor..............: TECNOLOGIA (C.A.S)                                     #
# Usuario ...........: mtcl                                                   #
# Objetivo...........: Mesa de ayuda pueda ejecutar comandos del usuario mtcl #
#                      desde el presente menu                                 #
# Nombre del programa: menu_Ctele.ksh                                         #
# Descripcion........: Permite que mesa de ayuda pueda desbloquear internos   #
#                      con la opcion 1                                        #
# Modificacion.......: 03/01/2003                                             #
###############################################################################

###############################################################################
#                                 Variables                                   #
###############################################################################

TEL_WRK=/usr2/mtcl
TEL_SCR=$TEL_WRK/scripts
TEL_LOG=$TEL_WRK/logs
TEL_TOOL=/usr2/oneshot/mtcl/tool
LOG=$TEL_LOG/Trace.`date '+%Y%m%d'`
ARC_LOG=$TEL_LOG/Dispo.$$
CANT_DIAS=14
LOGNAME=mtcl
export LOGNAME
export TEL_WRK
export TEL_SCR
export TEL_LOG
export LOG

###############################################################################
#                                 Funciones                                   #
###############################################################################

function Check_Placa
{ 
PLACAS=`$TEL_TOOL config all |grep "IN SERVICE"| awk '{ print $2, $4 }'`

PLACA=""
CONTADOR=0

for i in $PLACAS
do
 if [ $CONTADOR -le 2 ]
  then
   CONTADOR=`expr $CONTADOR + 1`
   PLACA=`echo $PLACA $i`
 fi
 if [ $CONTADOR -eq 2 ]
  then
   $TEL_SCR/encabezado.ksh
   echo ""
   $TEL_TOOL listincall $PLACA
   echo "\n\t\t\t<ENTER> - Continuar \c"
   read nada
 fi
done
}

function Reset_Placa
{ 
P=${1}
PLACAS=`$TEL_TOOL config all |grep ${P}|grep "IN SERVICE"| awk '{ print $2, $4 }'`
PLACA=""
CONTADOR=0

for i in $PLACAS
do
 if [ $CONTADOR -le 2 ]
  then
   CONTADOR=`expr $CONTADOR + 1`
   PLACA=`echo $PLACA $i`
 fi
 if [ $CONTADOR -eq 2 ]
  then
   while true
    do
     $TEL_SCR/encabezado.ksh
     echo ""
     echo "\t Confirma reseteo de la placa ${PLACA} (S/N) ==> \c"
     read RTA
     case $RTA in
      S|s) $TEL_TOOL rstcpl $PLACA
           if [ $? -eq 0 ]
            then
             echo "\n\t Reset OK - <ENTER> - Continuar \c"
             read nada
             PLACA=""
             CONTADOR=0
             break
           fi
           ;;
      N|n) break
           ;;
     esac
    done
 fi
done 
}


function Lista_Disponibles
{
$TEL_TOOL config all 
echo "\n\tPresione una tecla para continuar."
read c
#PLACAS=`$TEL_TOOL config all |grep UA32|grep "IN SERVICE"| awk '{ print $2, $4 }'`

}

function Disponible
{
INTERNOS_OK=""

while true
do
 $TEL_SCR/encabezado.ksh
 echo "\n\n\n\n\n\n\n\n\n\n\n\n\n"
 echo "\t\t\t Ingrese numero de interno ==> \c"
 read INTERNO
 if [ "${INTERNO:-VACIO}" = "VACIO" ]
  then
   return 1
  else
   for INT in $INTERNO
    do
     if [ `grep -c $INT $ARC_LOG` -ne 1 ]
      then
       echo "\t\t\t Interno $INT inexistente"
       echo "\t\t\t <ENTER> - Continuar \c"
       read nada
      else
       INTERNOS_OK=`echo $INT $INTERNOS_OK`
     fi
    done
    if [ "${INTERNOS_OK:-VACIO}" != "VACIO" ]
     then
      export INTERNOS_OK
      return 0
    fi
 fi
done
}

function Operadora
{
OPERADORA=""
for i in `cat $ARC_LOG`          
do
 if [ `echo $i | grep -c "^A"` -eq 1 ]
  then
   OPERADORA=`echo $OPERADORA $i`
 fi
done
if [ "${OPERADORA:-VACIO}" = "VACIO" ]
 then
  echo "\t\t\t Error - La sucursal no posee operadora "
  echo "\t\t\t <ENTER> -  Continuar \c"
  read nada
  return 1
 else 
  export OPERADORA
fi
}

function Depura_logs
{ 
find $TEL_LOG -mtime +${CANT_DIAS} -exec rm -f {} \; 2>/dev/null
if [ $? -ne 0 ]
 then 
  RC=10
  echo "Warning $RC - Al intentar depurar el directorio $TEL_LOG"
fi
}

###############################################################################
#                                 Principal                                   #
###############################################################################

Depura_logs
while true
do
 $TEL_SCR/encabezado.ksh
 echo "\t *** O p e r a c i o n e s   C e n t r a l  T e l e f o n i c a ***  "
 echo ""
 echo ""
 echo "\t 1.  Desbloquear un interno      2.  Desbloquear Operadora         "
 echo ""
 echo "\t 3.  Ver el estado de un interno 4.  Ver estado interno OPERADORA  "
 echo ""
 echo "\t 5.  Resetear placa REDCOTO.     6.  Ver el estado de la placa."
 echo ""
 echo "\t 7.  Resetear placa internos UA. 8.  Resetear placa internos Z."
 echo ""
 echo "\t 9.  Resetear placa linea externa NDDI."
 echo ""
 echo "\t s. - Salir del Menu                                                 "
 echo ""
 echo ""
 echo "\t  Ingrese su opcion ==> \c" 
 read opcion
 case $opcion in
     1)  Disponible 
         if [ $? -eq 0 ]
          then
          TIEMPO=`date '+%Y/%m/%d - %H:%M:%S'` 
          echo "$TIEMPO Usuario: $1 desbloqueo los internos ==> $INTERNOS_OK"\          >> $LOG  
          ksh $TEL_SCR/Desb_Inter.ksh $INTERNOS_OK 
         fi
           ;;
     2)  Operadora                          
         if [ $? -eq 0 ]
          then
          TIEMPO=`date '+%Y/%m/%d - %H:%M:%S'` 
          echo "$TIEMPO Usuario: $1 desbloqueo los internos ==> $OPERADORA" \
          >> $LOG
          ksh $TEL_SCR/Desb_Inter.ksh $OPERADORA
         fi
            ;;
     3)  Disponible 
         if [ $? -eq 0 ]
          then
           ksh $TEL_SCR/StateInt.ksh $INTERNOS_OK 
         fi
           ;;
     4)  Operadora                        
         if [ $? -eq 0 ]
          then
          TIEMPO=`date '+%Y/%m/%d - %H:%M:%S'` 
          echo "$TIEMPO Usuario: $1 desbloqueo los internos ==> $OPERADORA" \
          >> $LOG
          ksh $TEL_SCR/StateInt.ksh $OPERADORA
         fi
           ;;
     5) TIEMPO=`date '+%Y/%m/%d - %H:%M:%S'` 
        echo "$TIEMPO Usuario: $1 Reseteo de Placa RED COTO" \
        >> $LOG
        Reset_Placa EMTL
           ;;
     6) TIEMPO=`date '+%Y/%m/%d - %H:%M:%S'` 
        echo "$TIEMPO Usuario: $1 Consulta estado de Placas" \
        >> $LOG
        Lista_Disponibles
           ;;
     7) TIEMPO=`date '+%Y/%m/%d - %H:%M:%S'`
        echo "$TIEMPO Usuario: $1 Reseteo de Placa UA" \
        >> $LOG
        Reset_Placa UA
	   ;;
     8) TIEMPO=`date '+%Y/%m/%d - %H:%M:%S'`
        echo "$TIEMPO Usuario: $1 Reseteo de Placa Z" \
        >> $LOG
        Reset_Placa Z
           ;;
     9) TIEMPO=`date '+%Y/%m/%d - %H:%M:%S'`
        echo "$TIEMPO Usuario: $1 Reseteo de Placa NDDI" \
        >> $LOG
        Reset_Placa NDDI
           ;;
     S|s)  clear
           rm $TEL_LOG/Dispo.$$
           exit
           ;;
     *)    $TEL_SCR/encabezado.ksh 
           echo ""
           echo "\t\t\t\t Opcion Incorrecta"
           echo "\t\t\t\t <ENTER>-Continuar \c"
           read nada
           ;;
 esac
done
