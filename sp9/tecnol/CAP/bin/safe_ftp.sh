#!/usr/bin/ksh
set -x
################################################################################
#
# Script     : safe_ftp.sh
# Autor      : Cesar Lopez
# Equipo     : sp9
# Path       : /tecnol/bin
# Fecha      : 21/03/2002
# Descripcion: Ejecuta el safe_ftp
#
################################################################################

HOST=${1}
USR=${2}
PASS=${3}
CMD_FILE=${4}

DIRCAP=/tecnol/CAP

cd $DIRCAP
if [ $? != 0 ]
then
	echo "No se pudo acceder al directorio $DIRCAP"
	exit 2
fi

$DIRCAP/bin/safe_ftp $HOST $USR $PASS $CMD_FILE
exit $?



