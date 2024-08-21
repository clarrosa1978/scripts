#/usr/bin/ksh
set -x
################################################################################
#      Script: nonzero
#       Autor: Gustavo Goette
#    Ult.Mod.: 20/04/1999
# Descripcion: Verifica que el archivo pasado como parametro no este vacio
################################################################################
. /tecnol/bin/suc3to2.lib
 
HOST="`hostname -s`"".coto.com.ar"
SCRIPT="nonzero.sh"
FILE="$1"
SUC="$2"
FECHA="$3"
SUC2=`suc3to2 $SUC`
DIR=/trntcierre/suc"$SUC2"
LOG=/tecnol/trntcierre/log/transfer"$SUC"."$FECHA"
export HOST SCRIPT FILE SUC SUC2 DIR
if [ -f /tecnol/trntcierre/log/$FILE$SUC.$FECHA ]
then 
	rm  /tecnol/trntcierre/log/$FILE$SUC.$FECHA
fi
if [ ! -s "$DIR"/"$FILE" ]
then
	echo "`date` El archivo $FILE se genero VACIO" >> "$LOG"
	exit 10
fi
exit 0
