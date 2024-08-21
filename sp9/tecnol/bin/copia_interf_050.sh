#!/usr/bin/ksh
set -x
################################################################################
#
# Copia las interfases correspondientes a suc50
#
# Se utilizan los mismos archivos de parametros que para el resto de las
# sucursales, pero no se consideran algunos de los 9 parametros, porque en
# este caso no se realiza una transferencia.
#
# Cesar Lopez  -  05/05/2004
#
################################################################################
SOURCE_DIR=${2}
SOURCE_FILE=${3}
TARGET_DIR=${5}
TARGET_FILE=${6}
OWNER=${7}
GROUP=${8}
PERM=${9}

if [ ! -s ${SOURCE_DIR}/${SOURCE_FILE} ]
then
	echo "No hay movimientos"
	exit 10
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



