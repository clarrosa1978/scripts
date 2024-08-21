#!/usr/bin/ksh
$SFSW_MENU/encabezado.ksh 
 echo -e "\t\t ***  C o m u n i c a c i o n e s  *** "
 echo -e ""

 LISTA=`cat $SFSW_MENU/ListaProcesos.cfg`

for proceso in $LISTA
do
        SALIDA=`ps -fu sfctrl | grep $proceso | grep -v -c grep`
        if [ $SALIDA == 0 ]
        then
                echo -e "\t\t Procesos: $proceso \t ..........  =/= CAIDO =/="
        else
                echo -e "\t\t Procesos: $proceso \t ..........  { ACTIVO }"
        fi
done

echo -e ""
echo -e "\t\t Presione <ENTER> para continuar\c";read a

