#!/bin/ksh -x
#DEFINICION DE VARIABLES
BKPDIR=/backups
NUMBER_OF_BKPS=1
ARCHIVE_DIR=$BKPDIR/archives
ARCHIVE_FILE=NO
#Carga de Funciones
. $MENU_CTM/funciones/funciones.lib
#Eliminado el anteultimo resguardo 
rm -f /backups/coldbkp.prev/*
test_status $? rm
#Moviendo el ultimo resguardo 
mv /backups/coldbkp/*  /backups/coldbkp.prev/
test_status $? mv
#Realizando el Backup
ctmdbbck -f$HOME/.controlm2 -d/backups/coldbkp -mH
test_status $? ctmdbbck
rm -f /backups/coldbkp.prev/*
test_status $? rm
#Eliminando los archives que no sean del ultimo resguardo
CURRENT_BACKUPS=`ls -t ${ARCHIVE_DIR}/*.backup `
BACKUP_FILES=1
for i in ${CURRENT_BACKUPS}
do
	LAST_BACKUP_FILE=`echo $i`
	ARCHIVE_FILE=`echo $i | cut -d. -f1`
	if [ ${BACKUP_FILES} = ${NUMBER_OF_BKPS} ]
	then
		break
	fi
	BACKUP_FILES=`expr ${BACKUP_FILES} + 1`
done
if [ ! -z ${ARCHIVE_FILE} ]
then
	if [ -f ${ARCHIVE_FILE} ]
	then
		ARCHIVE_LIST=`ls ${ARCHIVE_DIR}/ | grep -v archive_ `
		for i in `echo ${ARCHIVE_LIST}` 
		do
			if [ "${ARCHIVE_DIR}/$i" != "${ARCHIVE_FILE}" ] && [ "${ARCHIVE_DIR}/$i" != "${LAST_BACKUP_FILE}" ]
			then
				rm -f ${ARCHIVE_DIR}/$i
				test_status $? rm
			else
				break
			fi
		done
	else
		echo "Error en la secuencia de Archives"
		exit 10
	fi
fi
