#!/usr/bin/ksh
##############################################################################
#
# Copia el archivo de recuentos de Juncadella a la sucursal correspondiente,
# y envia mail a  coto@ar.prosegur.com
#
##############################################################################
#
# Se modifico para que los archivos movidos a ${SOURCE_DIR}/procesados , se
# guarden con el nombre  MMDDr.SSS.HHMMSS , donde:
#
#     MM:     mes
#     DD:     dia
#     SSS:    sucursal (en formato de tres digitos)
#     HHMMSS: hora, minutos, y segundos en que se proceso del archivo
#
# Cesar Lopez  -  05/01/2005
#
##############################################################################
set -x

if [ $# -ne 2 ]
then
	echo "Error en cantidad de parametros"
	exit 2
fi

export SUC=${1}
if [ ${SUC} -gt 99 ]
then
        TARGET_HOST=suc${SUC}
else
        TARGET_HOST=suc`echo ${SUC} |cut -c2-3`
fi
export ACTION=P
export SOURCE_DIR=/recuentos
#export OWNER=root
export OWNER=sts
export GROUP=root
export MASK=644
export TARGET_DIR="/sts"
export USER="transfer"

cd ${SOURCE_DIR}
if [ $? != 0 ]
then
	echo "No se pudo acceder a ${SOURCE_DIR}"
	exit 2
fi
export SOURCE_FILE="`ls -tr ????r.${SUC}`"
for TARGET_FILE in ${SOURCE_FILE}
do
	/tecnol/bin/safe_scp ${ACTION} ${SOURCE_DIR} ${TARGET_FILE} ${TARGET_HOST} ${TARGET_DIR} ${TARGET_FILE} NULL NULL 1 1 NULL ${OWNER} ${GROUP} ${MASK} ${USER}
	STATUS=$?
	if [ ${STATUS} = 52 ]
	then
		exit ${STATUS}
	else
		if [ ${STATUS} != 0 ]
		then
			echo "safe_rcp status : ${STATUS}"
			exit 2
		fi
	fi
	HORA=`date +%H%M%S`
	sudo mv -f ${TARGET_FILE} procesados/${TARGET_FILE}.${HORA}
done
sudo find ./procesados -name "????r.${SUC}.??????" -mtime +30 -exec rm {} \;
exit 0
