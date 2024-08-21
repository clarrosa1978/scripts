#set -x
clear
OPERADOR_WRK=/tecnica/operador
$OPERADOR_WRK/encabezado.ksh  $0
echo
echo "\tIngrse el numero de la Sucursal para imprimir los listados de cierre (ej: \"02 55 103\"):   \c"
#echo "\tNumero: \c"
read SUC_IMPRE
export SUC_IMPRE; 

if [ "$SUC_IMPRE" = "" ]
then
        echo
        echo "\t NO HAY SUCURSALES SELECCIONADAS, VERIFIQUE !!!!"
        echo
else
        for i in $SUC_IMPRE
        do
                echo "\n\tLlendo a la Sucursal $i"
                ping -c1 suc$i > /dev/null 2> /dev/null
                STATUS_PING=$?
                if [ "$STATUS_PING" = "0" ]
                then
		clear
		rsh suc$SUC_IMPRE "ksh /tecnica/scripts/menuoper/MenuImprList.sh MenuImprList.txt" 	
		clear
                else
                        echo "          No hay comunicacion con suc$i"
                echo "$i"  
		fi
        clear
	done
fi
clear

