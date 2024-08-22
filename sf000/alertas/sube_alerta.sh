set -x
export ALERTA="${1}"
export ACTIVA="`ps -ef | grep ${ALERTA} | grep -v grep | grep -v $$`"
if [ "${ACTIVA}" ]
then
        exit 0
else
        sudo nohup /tecnol/alertas/${ALERTA}.sh > /dev/null &  
fi
