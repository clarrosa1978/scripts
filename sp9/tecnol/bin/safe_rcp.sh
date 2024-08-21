#!/usr/bin/ksh
set -x
################################################################################
#      Script: safe_rcp.sh
#       Autor: Gustavo Goette
#    Ult.Mod.: 23/06/1999
# Descripcion: Ejecuta el safe_rcp de JAF 
################################################################################
HOST="`hostname -s`"".coto.com.ar"
SCRIPT="safe_rcp.sh"
ACTION="$1"
SOURCE_DIR="$2"
SOURCE_FILE="$3"
TARGET_HOST="$4"
TARGET_DIR="$5"
TARGET_FILE="$6"
OWNER="$7"
GROUP="$8"
PERM="$9"
export HOST SCRIPT ACCION SOURCE_DIR SOURCE_FILE TARGET_HOST TARGET_DIR TARGET_FILE OWNER GROUP PERM

if [ "$ACTION" = "P" ]
then 
	if [ ! -s "$SOURCE_DIR"/"$SOURCE_FILE" ]
	then
		echo "Se intento enviar un archivo vacio o inexistente"
		exit 10
	fi
fi

if [ $TARGET_HOST = suc50 ]
then
	TARGET_HOST=j40gdm
fi

/tecnol/bin/safe_rcp $ACTION $SOURCE_DIR $SOURCE_FILE $TARGET_HOST $TARGET_DIR $TARGET_FILE NULL NULL 3 300 NULL $OWNER $GROUP $PERM
STATUS="$?"
if [ $STATUS != 0 ]
then 
	if [ $STATUS = 52 ]
	then
		echo "No hay comunicacion en este momento"
		exit 38
	else
		echo "Error en la transferencia de archivos"
		exit "$STATUS"
	fi
else
	if [ "$ACTION" = "G" ]
	then 
		if [ ! -s "$TARGET_DIR"/"$TARGET_FILE" ]
		then
			echo "EL archivo copiado tiene size 0"
			exit 10
		else
			exit 0
		fi
	fi
fi	
