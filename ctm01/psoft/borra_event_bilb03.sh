#!/usr/bin/ksh
set -x

FECHA=$1
OUT_PATH=$2
FILE=$3

ssh psp1 "rm -f ${OUT_PATH}/${FILE}"

if [ $? != 0 ]
then
        echo "Fallo la depuracion del/los archivo/s ${OUT_PATH}/${FILE}"
        exit 2
fi

