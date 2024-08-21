#!/usr/bin/ksh
set -x
###############################################################################
#
# Copia el "tlog" correspondiente a suc50
#
# Se utilizan los mismos parametros que para el script TraerTlogSuc.sh ,
# excepto los necesarios para una transferencia, que en este caso no se
# realiza.
#
# Cesar Lopez  -  05/05/2004
#
################################################################################

SUC=${1}
FECHA=${2}

SOURCE_DIR=/sfctrl/d
SOURCE_FILE=tlog${SUC}.${FECHA}.Z
TARGET_DIR=/tlogsuc/suc${SUC}
TARGET_FILE=${SOURCE_FILE}
OWNER=root
GROUP=sys
PERM=644

if [ ! -s ${SOURCE_DIR}/${SOURCE_FILE} ]
then
	echo "tlog vacio o inexistente"
	exit 2
fi

cp -pf ${SOURCE_DIR}/${SOURCE_FILE} ${TARGET_DIR}/${TARGET_FILE}
diff ${SOURCE_DIR}/${SOURCE_FILE} ${TARGET_DIR}/${TARGET_FILE}
if [ $? != 0 ]
then
	echo "No se pudo copiar ${TARGET_DIR}/${TARGET_FILE}"
	exit 2
fi

chmod ${PERM} ${TARGET_DIR}/${TARGET_FILE}
if [ $? != 0 ]
then
	echo "No se pudo cambiar la mascara de permisos de ${TARGET_DIR}/${TARGET_FILE}"
	exit 2
fi

chown ${OWNER}.${GROUP} ${TARGET_DIR}/${TARGET_FILE}
if [ $? != 0 ]
then
	echo "No se pudo cambiar usuario/grupo de ${TARGET_DIR}/${TARGET_FILE}"
	exit 2
fi

exit 0



