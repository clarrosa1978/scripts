set -x
###############################################################################3
###############################################################################3
#
# Carga archivo /sfctrl/data/carga/tktinv.txt
# en cada una de las sucursales
#
# 21/10/2005
#
#       IMPORTANTE Ingresar fecha en formato DDMMAAAA
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

if [ -s /sfctrl/data/carga/tktinv.txt ]
then
    tickCarga L /sfctrl/data/carga/tktinv.txt    /sfctrl/data/mess_f1.dat
    mv /sfctrl/data/carga/tktinv.txt /sfctrl/data/carga/tktinv.txt.$fecha
else
    echo " No hay novedades para actualizar de LUNCHEON"
	exit 2
fi
