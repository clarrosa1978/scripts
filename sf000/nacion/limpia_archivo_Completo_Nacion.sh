export FECHA="${1}"
export PATHARCH="/nacion"
export ARCH="${PATHARCH}/tarjnacion_completo_${FECHA}.txt"
export ARCHTMP="${ARCH}.tmp"
mv ${ARCH} ${ARCHTMP}
grep 63913 ${ARCHTMP} | awk '{print $NF}' > ${ARCH}
