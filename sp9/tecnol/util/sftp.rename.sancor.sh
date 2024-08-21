set -x
export USUARIO="${1}"
export PASS="${2}"
export SERVIDOR="${3}"
export DIRORIGEN="${4}"
export DIRDEST="${5}"
export PATHAPL="/tecnol/util"
export PATHLOG="${PATHAPL}/log"
export LOG="${PATHLOG}/sftp.rename.sancor.lst"
export LISTA="${PATHAPL}/sftp.sancor.files"

rm ${LISTA}
${PATHAPL}/sftp.list.sancor.exp ${USUARIO} ${PASS} ${SERVIDOR} ${DIRORIGEN}
if [ $? != 0 ]
then
        echo "Error en sftp"
        exit 1
fi
if [ -s ${LISTA} ]
then
	if [ `tail -n +2 ${LISTA} | sed '$d' | wc -l` -gt 1 ]
	then
		rm ${LOG}
		for ARCH in `tail -n +2 ${LISTA} | sed '$d'`
		do
        		${PATHAPL}/sftp.rename.sancor.exp ${USUARIO} ${PASS} ${SERVIDOR} ${DIRORIGEN} ${DIRDESTINO} ${ARCH}
			if [ $? != 0 ]
        		then
                		echo "Error al mover ${ARCH} en el sitio sftp"
                		exit 1
        		else
                		exit 0
        		fi
		done
	else
		echo "No hay archivos nuevos"
		exit 0
	fi
else
        echo "No existe el archivo ${LISTA} - Avisar a la guardia Administracion Unix"
        exit 1
fi
