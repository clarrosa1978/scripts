#El parametro es la alerta a desactivar
set -x
export ALERTA="${1}"
export PADRE="`ps -ef | grep ${ALERTA} | grep -v $0 |grep -v grep | awk ' { print $2 } '`"
if [ "${PADRE}" ]
then
	sudo kill -9 `ps -ef | grep ${PADRE} | grep -v grep | tail -1  | awk ' { print $2 } '` ${PADRE}
else
	echo "La alerta no se encontraba activa"
fi