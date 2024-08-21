#/usr/bin/ksh
set -x
################################################################################
#
# Descomprime el archivo del CAP , previo a la transferencia al servidor NT
#
# Cesar Lopez  -  20/03/2002
#
################################################################################

FECHA=`date +"%d%m.%H%M"`
DIRCAP=/tecnol/CAP

cd $DIRCAP
if [ $? != 0 ]
then
	echo "No se pudo acceder al directorio $DIRCAP"
	exit 2
fi

cp $DIRCAP/CAP.zip /FTPS/CAP/CAP.zip.$FECHA
if [ $? != 0 ]
then
	echo "Error copiando archivo de CAP"
	exit 2
fi

$DIRCAP/bin/unzip -d -o $DIRCAP/CAP.zip
if [ $? != 0 ]
then
	echo "Error descomprimiendo archivo de CAP"
	exit 2
fi

exit 0



