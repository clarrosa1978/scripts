###########################################################################################
#NOMBRE DEL SCRIPT: PrtmenuCent.sh                                                        #
#DESCRIPCION: Menu de operaciones de spooler en nodos de Central                          #
#AUTOR: CFL                                                                               #
#FECHA DE MODIFICACION: 25-01-2002                                                        #
###########################################################################################
      
###########################################################################################
#                                     FUNCIONES                                           #
###########################################################################################

function Existe {
         if [ "$Esta" = "false" ]
         then
             clear
             echo "\n\n\n\n\n\n\n\n\n\n\n"
             echo "\t                             *******************************"
             echo "\t                             *       COLA INEXISTENTE      *"
             echo "\t                             *******************************"
             echo "\n\n\n\n\n"
             PTecla
             exit
         fi
}

function Opcion {
         clear
         FMenu
         echo "\tIngrese una opcion: \c"
         read Opc
}

function OpcionInx {
         clear
         echo "\n\n\n\n\n\n\n\n\n\n\n"
         echo "\t                             ************************"
         echo "\t                             *  OPCIÓN INEXISTENTE  *"
         echo "\t                             ************************"
         echo "\n\n\n\n\n"
         PTecla
}

function PTecla {
         echo "\n\n\n\n\n\tPresione una tecla para continuar \c"
         read Opc
}
typeset -l PTecla

function FMenu {
$OPERADOR_SIS/Encabezado.sh
echo "\t*******************************************************************************"
echo "\t*                *********************************************                *"
echo "\t*                *    Menu de Impresion de Central y Bases   *                *"
echo "\t*                *********************************************                *"
echo "\t*                                                                             *"
echo "\t*       1) Ver el estado de las colas de impresion                            *"
echo "\t*       2) Activar una cola de impresion                                      *"
echo "\t*       3) Desactivar una cola de impresion                                   *"
echo "\t*       4) Cancelar job de impresion                                          *"
echo "\t*       5) Seleccionar cola de impresion                                      *"
echo "\t*       99) Salir                                                             *"
echo "\t*                                                                             *"
echo "\t*                                                                             *"
echo "\t*                                                                             *"
printf "\t%-7s %-23s %-45s %-1s \n" \
"*" "Nodo Seleccionado: " $Nodo "*"
printf "\t%-7s %-23s %-36s %-1s \n" \
"*" "Cola de Impresion Seleccionada: " $ColaImpCent "*"
echo "\t*                                                                             *"
echo "\t*                                                                             *"
echo "\t*******************************************************************************"
}

function Selec_Nodo {
clear
Tope=`wc -l $OPERADOR_SIS/nodos | awk ' { print$1 } '`
j=1
echo "\n\n\n\n\n\t\t\t\t**************************************"
echo "\t\t\t\t*  Menu de Nodos de Central y Bases  *"
echo "\t\t\t\t**************************************\n"
for i in `cat $OPERADOR_SIS/nodos`
do
  Opcion[$j]=$i
  echo "\t\t\t\t$j) ${Opcion[$j]}"
  let "j=j+1"
done
echo "\n\t\t\t\tSeleccione un nodo: \c"
read Opc
j=1
Esta=false
until [ "$j" -eq "$Tope"+1 -o "$Esta" = "true" ]
do
  if [ "$j" -eq "$Opc" ]
  then
      Nodo=${Opcion[$j]}
      Esta=true
  else
      let "j=j+1"
  fi
done
}

function Selec_Cola {
clear
Tope=`rsh ${Nodo} lsallq | wc -l`
j=1
echo "\n\n\t\t\t*****************************************************"
printf "\t\t\t%-3s %-36s %-10s %-1s \n" \
"*" "Menu de Colas de Impresión del Nodo" $Nodo "*"
echo "\t\t\t*****************************************************"
rm $OPERADOR_SIS/Lista.Colas
for i in `rsh $Nodo lsallq`
do
  Opcion[$j]=$i
  echo "\t\t\t\t$j) ${Opcion[$j]}" >>Lista.Colas
  let "j=j+1"
done
$OPERADOR_SIS/Listar.sh
echo "\n\t\t\tSeleccione una cola de impresion: \c"
read Opc
j=1
Esta=false
until [ "$j" -gt "$Tope" -o "$Esta" = "true" ]
do
  if [ "$j" -eq "$Opc" ]
  then
      ColaImpCent=${Opcion[$j]}
      Esta=true
  fi
  let "j=j+1"
done
export ColaImpCent
}
typeset -fx Selec_Cola

function VerColasImpCent {
clear
echo "\n\n\n\n\n"
rsh $Nodo lpstat -a$ColaImpCent
PTecla
}

###########################################################################################
#                                     PRINCIPAL                                           #    
###########################################################################################

Selec_Nodo
if [ "$Esta" = "false" ]
then
    clear
    echo "\n\n\n\n\n\n\n\n\n\n\n"
    echo "\t                             *******************************"
    echo "\t                             *       NODO INEXISTENTE      *"
    echo "\t                             *******************************"
    echo "\n\n\n\n\n"
    PTecla
    exit
fi
ping -c2 $Nodo >/dev/null 2>/dev/null
if [ $? != 0 ]
then
    clear
    echo "\n\n\n\n\n\n\n\n\n\n\n"
    echo "\t                             *******************************"
    echo "\t                             *  PROBLEMAS DE COMUNICACION  *"
    echo "\t                             *      INTENTE MAS TARDE      *"
    echo "\t                             *******************************"
    echo "\n\n\n\n\n"
    PTecla
    exit
fi
export Nodo
Selec_Cola
Existe
while true
do
  Opcion
  if [ "$Opc" -gt "0" -a "$Opc" -lt "6" -o "$Opc" = "99" ]
  then
      case "$Opc" in
          1) $OPERADOR_SIS/VerColasImpCent.sh;;
          2) $OPERADOR_SIS/ActivarColasCent.sh ;;
          3) $OPERADOR_SIS/DesactivarColasCent.sh ;;
          4) $OPERADOR_SIS/CancelarJobsCent.sh ;;
          5) Selec_Cola
             Existe ;;
          99) exit
      esac
  else
      OpcionInx
  fi
done

