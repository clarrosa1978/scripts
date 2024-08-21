#!/usr/bin/ksh
set -x

FUNCTION=${1}
SOURCE_DIR=${2}
SOURCE_FILE=${3}
TARGET=${4}
TARGET_DIR=${5}
TARGET_FILE=${6}
ALT_DIR=${7}
ALT_FILE=${8}
RETRIES=${9}
DELAY=${10}
REM_USER=${11}
OWNER=${12}
GROUP=${13}
MASK=${14}

if [ $FUNCTION = P ]
then
	if [ $TARGET = 126 -o $TARGET = 146 -o $TARGET = 595 ]
	then
		TARGET_HOST=pucara
	else
		if [ $TARGET -gt 99 ]
		then
			SUC=$TARGET
		else
			SUC=`echo $TARGET | cut -c2-3`
		fi
		TARGET_HOST=suc$SUC
	fi
else
	TARGET_HOST=$TARGET
fi

/tecnol/bin/safe_rcp $FUNCTION $SOURCE_DIR $SOURCE_FILE $TARGET_HOST $TARGET_DIR $TARGET_FILE $ALT_DIR $ALT_FILE $RETRIES $DELAY $REM_USER $OWNER $GROUP $MASK
STATUS=$?

if [ $STATUS = 0 ]
then
	exit 0
else
	if [ $STATUS = 52 ]
	then
		exit 38
	else
		echo "safe_rcp status : $STATUS"
		exit 2
	fi
fi



