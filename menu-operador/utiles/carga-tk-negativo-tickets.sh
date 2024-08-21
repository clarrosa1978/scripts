set -x
###############################################################################3
###############################################################################3
# carga-tk-negativo-tickets.sh
#
# Carga archivo /sfctrl/data/carga/tk.negativo.tickets.$fecha.010101
# en cada una de las sucursales 
#
# 21/10/2005
#
#	IMPORTANTE Ingresar fecha en formato DDMMAAAA
#
###############################################################################3
###############################################################################3
if [ $# -ne 1 ]
then
	echo "\n\t Parametro mal informado\n"
	exit 
else
	fecha=$1
fi


if [ -s /sfctrl/data/carga/tk.negativo.tickets.${fecha}.010101 ]
  then
 
       ############################################################################
       # Modificacion de JAF por problema del char '\015' (hex 0d) en archivo
       # Extirpa el char 'carrige return' de cada linea del archivo
 
       TEMP_FILE="/tmp/tick_total.$$"
 
       cat /sfctrl/data/carga/tk.negativo.tickets.${fecha}.010101|\
       awk ' { if ( substr( $0, length($0), 1 ) == "\015" ) { print substr( $0, 1, length($0) - 1 ) }
               else { print $0 }
             } ' > "$TEMP_FILE"
 
       export CHK_REC_SIZE="0"
       CHK_REC_SIZE=`head -1 "$TEMP_FILE"|awk ' { print length($0) } '`
 
       if [ "$CHK_REC_SIZE" -eq 37 ]
       then
              cp "$TEMP_FILE" /sfctrl/data/carga/tk.negativo.tickets.${fecha}.010101
       fi
 
       rm -f "$TEMP_FILE"
 
       ####################### FIN Modificacion 1 ##################################
 
    tickCarga T /sfctrl/data/carga/tk.negativo.tickets.${fecha}.010101    /sfctrl/data/mess_f1.dat
  else
    echo " No hay novedades para actualizar de Tickets TOTAL"
fi

