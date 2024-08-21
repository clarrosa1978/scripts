set -x
###############################################################################3
###############################################################################3
# carga-tk-negativo-tickets.sh
#
# Carga archivo /sfctrl/data/carga/actualiz.txt
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

if [ -s /sfctrl/data/carga/actualiz.txt ]
  then
       ############################################################################
       # Modificacion de JAF por problema de cambio de formato del archivo
       # Extirpa el 3er char de cada linea del archivo
 
       TEMP_FILE="/tmp/tick_canasta.$$"
 
       cat /sfctrl/data/carga/actualiz.txt|\
       awk ' { if (length($0) == 31 ) { print sprintf("%s%s", substr( $0, 1, 2 ), substr( $0, 4, (length($0) - 3) ) ) }
               else { print $0 }
             } ' > "$TEMP_FILE"
 
       export CHK_REC_SIZE="0"
       CHK_REC_SIZE=`head -1 "$TEMP_FILE"|awk ' { print length($0) } '`
 
       if [ "$CHK_REC_SIZE" -eq 30 ]
       then
              cp "$TEMP_FILE" /sfctrl/data/carga/actualiz.txt
       fi
 
       rm -f "$TEMP_FILE"
 
       ####################### FIN Modificacion 2 ##################################
 
    tickCarga C /sfctrl/data/carga/actualiz.txt    /sfctrl/data/mess_f1.dat
    mv /sfctrl/data/carga/actualiz.txt /sfctrl/data/carga/actualiz.txt.$fecha
  else
    echo " No hay novedades para actualizar de Ticket CANASTA"
fi
