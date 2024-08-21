#!/bin/bash
set -x
# Se corrigieron varios errores de programacion. 
# Se adapto para AIX 5.3 y 4.3
# Se agrego la generacion de Performance Data.
# Se agrego que envie total de espacio libre pedido por Larrosa. 
# Se agrego control de que exista el directorio y envie error.


if [ "$1" == "-h" ]; then
        echo "Nagios check Disk Utility version 2!!!";
        echo " ----David Foust 2007";
	echo "Corregido y modificado por:";
	echo "Pablo Morales COTO C.I.C.S.A 2013";
        exit 0;
fi


if [ -n "$1" ]; then
        WARNING_SIZE=$1;
fi

if [ -n "$2" ]; then
        CRITICAL_SIZE=$2;
fi

if [ -n "$3" ]; then
        DIR_NAME=$3;
fi

# Le devolvemos a Nagios UKNOWN si no existe el directorio, en el panel lo
# vamos a ver el error y nos va a servir para controlar de no haber pasado
# mal el nombre de directorio.

if [ ! -d "$DIR_NAME" ]; then

	echo "ERROR No Existe El Directorio: " $DIR_NAME 
	exit 3;     


fi

# ---- GET DEVICE NAME -----
DEVICE_NAME=`df -h $DIR_NAME | sed -e 's/s6//g' | sed -e 's/s4//g' | sed -e 's/ptcset//g' | sed -e 's/s5//g' | sed -e 's/\/dev//g' | sed -e 's/\/md//g' | sed -e 's/\/dsk\///g' | sed -e 's/\/dbset//g' | sed -e 's/s0//g' | awk {'print $1'} | tail -1`

# ----- GET DISK SPACE STATS -----
#RESULT=`df -h $DIR_NAME | tail -1`
RESULT=`df -h $DIR_NAME | tail -1 |awk '{print $2,$3,$4,$5,$6}'`

USEDSPACEPER=`echo $RESULT | awk '{print substr($2,1,length($2)-1)}'`

#FREESPACEPER=`echo $((100-USEDSPACEPER))`
#FREESPACEPER=$((100-USEDSPACEPER))


TOTALSPACE=`echo $RESULT | awk '{print $1}'`
USEDSPACE=`echo $RESULT | awk '{print $2}'`
FREESPACE=`echo $RESULT | awk '{print $3}'`
MOUNT=`echo $RESULT | awk '{print $1}'`
PORCENTAJE=`echo $RESULT | awk '{print $4}'| tr -d "%"`


RESULT="$DIR_NAME  Total $TOTALSPACE Usado $USEDSPACE Libre $FREESPACE Prct $PORCENTAJE | $DIR_NAME=$USEDSPACE;85;90;;;"

# Los return codes segun el API de Nagios son:
# 0 Ok
# 1 Warning
# 2 Critical
# 3 Unknown


if [  "$PORCENTAJE" -ge "$CRITICAL_SIZE"  ]; then
        echo "Critical Disk Space $RESULT";
        exit 2;
fi

if [ "$PORCENTAJE" -ge "$WARNING_SIZE" ]; then
        echo "Warning Disk Space $RESULT";
        exit 1;
fi


echo $RESULT
exit 0;
