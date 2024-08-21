#/usr/bin/ksh
set -x
################################################################################
#      Script: nontransfer.sh
#       Autor: Gustavo Goette
#    Ult.Mod.: 20/04/1999
# Descripcion: Pone marca de error en transferencia de archivo
################################################################################
. /tecnol/bin/suc3to2.lib
 
HOST="`hostname -s`"".coto.com.ar"
SCRIPT="nontransfer.sh"
FILE="$1"
SUC="$2"
FECHA="$3"
SUC2=`suc3to2 $SUC`
DIR=/trntcierre/SUC"$SUC2"
LOG=/tecnol/trntcierre/log/transfer$SUC.$FECHA
export HOST SCRIPT FILE SUC SUC2 DIR
touch /tecnol/trntcierre/log/$FILE$SUC.$FECHA
echo "No pudo copiarse a central el archivo $FILE" >> $LOG
exit 0
