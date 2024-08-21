set -x
################################################################################
#
# Script     : putfinrcp.sh
# Autor      : Cesar Lopez
# Equipo     : servidor de transferencias
# Fecha      : 13/11/2000
# Descripcion: Genera en el directorio de datos del sistema COTO de la sucursal
#              el archivo finrcp para indicar la finalizacion de transferencia
#              de precios.
#
################################################################################

DEST_HOST=$1
DEST_PATH=$2

ping -c3 $DEST_HOST
if [ $? != 0 ]
then
	# No hay vinculo en este momento
	exit 38
else
#	rsh $DEST_HOST "touch $DEST_PATH/finrcp"
	if [ -f /precios/logs/finrcp ]
        then
 		rcp /precios/logs/finrcp $DEST_HOST:$DEST_PATH
		if [ $? != 0 ]
		  then
		   # Error en transferencia
		  exit 1
		fi
	else
		#  El archivo /precios/logs/finrcp  NO EXISTE 
		exit 1
	fi
fi

exit 0



