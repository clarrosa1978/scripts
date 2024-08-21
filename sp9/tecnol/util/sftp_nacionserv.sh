set -x
export USUARIO="${1}"
export PASS="${2}"
export SERVIDOR="${3}"
export DIRORIGEN="${4}"
export DIRDEST="${5}"
export ARCHIVO="${6}"
export PATHAPL=/tecnol/util
export FECHA="${7}"

${PATHAPL}/sftp_nacionserv.exp ${USUARIO} ${PASS} ${SERVIDOR} ${DIRORIGEN} ${DIRDEST} ${ARCHIVO}
if [ $? != 0 ]
then
	echo "Error en sftp"
	exit 1
fi
if [ -f ${DIRDEST}/${ARCHIVO} ]
then
	if [ -s ${DIRDEST}/${ARCHIVO} ]
	then
		echo "Existe el archivo ${DIRDEST}/${ARCHIVO} y tiene datos"
		exit 0
	else
		echo "El archivo ${DIRDEST}/${ARCHIVO} tiene size 0"
		exit 5
	fi
else
	echo "No existe el archivo ${DIRDEST}/${ARCHIVO}"
	exit 1
fi
