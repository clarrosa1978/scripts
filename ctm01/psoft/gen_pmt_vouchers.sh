#!/usr/bin/ksh
set -x

FECHA=$1

PMT_FILE=/tecnol/psoft/pmt/ld_vouchers.pmt
IN_PATH=/psinput

# cd ${IN_PATH}
if [ $? != 0 ]
then
        echo "No se pudo acceder a ${IN_PATH}"
        exit 2
fi

FILE=GDMAP09_01_${FECHA}??????
AUX=`ssh psfi01 "cd ${IN_PATH} ; ls -t ${FILE} | head -1"`


 if [ "$AUX" = "" ]
 then

 echo "No se pudo determinar el nombre del archivo"

 exit 1

 else

echo "%%PARM1=${IN_PATH}/${AUX}" > ${PMT_FILE}
echo "%%PARM2=GDM_AP09" >> ${PMT_FILE}
echo "%%PARM3=%%ODATE" >> ${PMT_FILE}
echo "%%PARM4=INTER_GDM" >> ${PMT_FILE}

echo "Cambio permisos de ejecucion de ${PMT_FILE}"
sudo chmod 664 ${PMT_FILE}

 fi

if [ ! -s ${PMT_FILE} ]
then
        echo "No se pudo generar ${PMT_FILE}"
        exit 2
fi
