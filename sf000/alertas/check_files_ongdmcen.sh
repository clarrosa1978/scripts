#!/bin/sh
#set -x
export MENSAJE=" Ongdmcen no esta procesando, por favor reiniciar servicio ongdmcen "
export DESTINATARIO="operaciones@redcoto.com.ar"
#export DESTINATARIO="ignacio.bellucci@redcoto.com.ar"

while true
do
  #export LAST=`ls /sfctrl/data/descarga/ | wc -l`
  export LAST=`ls /sfctrl/data/descarga/*_B.Z | wc -l`
  sleep 1800
  #export CURRENT=`ls /sfctrl/data/descarga/ | wc -l`
  export CURRENT=`ls /sfctrl/data/descarga/*_B.Z | wc -l`
  if [ "${CURRENT}" -gt "${LAST}" ]
  then
    echo "${MENSAJE} ${CURRENT} ${LAST}" | mail -s "Demoras con Ongdmcen" "${DESTINATARIO}"
  fi
done
