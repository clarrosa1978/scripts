#/usr/bin/ksh
set -x
################################################################################
#      Script: depura.sh
#       Autor: Gustavo Goette
#    Ult.Mod.: 08/04/1999
# Descripcion: Depura el directorio pasado por parametro 
################################################################################
HOSTNAME="`hostname`.coto.com.ar"
SCRIPT="depura.sh"

DIR_DEPURA="$1"
DIAS="$2"

cd $DIR_DEPURA
STATUS="$?"
if [ "$STATUS" != 0 ]
then
	echo "No existe el directorio $DIR_DEPURA"
	exit 10
fi
exec 2>>/dev/null
find $DIR_DEPURA  -mtime +"$DIAS" -print -exec compress -f {} \;

exit 0
