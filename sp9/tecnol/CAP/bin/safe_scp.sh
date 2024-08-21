#/usr/bin/ksh
set -x
################################################################################
#
# Script     : safe_rcp.sh
# Autor      : Cesar Lopez
# Equipo     : sp9
# Path       : /tecnol/bin
# Fecha      : 21/03/2002
# Descripcion: Ejecuta el safe_rcp de JAF 
#
################################################################################

FUNCTION=${1}
SOURCE_DIR=${2}
SOURCE_FILE=${3}
TARGET_HOST=${4}
TARGET_DIR=${5}
TARGET_FILE=${6}
ALT_DIR=${7}
ALT_FILE=${8}
RETRIES=${9}
DELAY=${10}
REM_USER=${11}
OWNER=${12}
GROUP=${13}
MASK=${14}

/tecnol/bin/safe_scp $FUNCTION $SOURCE_DIR $SOURCE_FILE $TARGET_HOST $TARGET_DIR $TARGET_FILE $ALT_DIR $ALT_FILE $RETRIES $DELAY $REM_USER $OWNER $GROUP $MASK
exit $?



