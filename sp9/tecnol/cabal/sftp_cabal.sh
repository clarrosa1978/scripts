set -x
export USUARIO="${1}"
export PASS="${2}"
export SERVIDOR="${3}"
export DIRORIGEN="${4}"
export DIRDEST="${5}"
export OP="${6}"
export PATHAPL=/tecnol/cabal

if [ ${OP} = "G" ]
then
	${PATHAPL}/sftp_cabal_get.exp ${USUARIO} ${PASS} ${SERVIDOR} ${DIRORIGEN} ${DIRDEST} 
else
	if [ ${OP} = "P" ]
	then
		${PATHAPL}/sftp_cabal_put.exp ${USUARIO} ${PASS} ${SERVIDOR} ${DIRORIGEN} ${DIRDEST} 
	else
		echo "OPERACION no Valida"
		exit 1
	fi
fi

if [ $? != 0 ]
then
	echo "Error en sftp"
	exit 1
fi
