#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: BACKUP                                                 #
# Grupo..............:                                                        #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Genera export de la base EM62 con el comando ecs util. #
# Nombre del programa: backup_ecs.sh                                          #
# Nombre del JOB.....: BKECS                                                  #
# Solicitado por.....: Cristian Larrosa                                       #
# Descripcion........:                                                        #
# Creacion...........: 06/08/2008                                             #
# Modificacion.......: 16/09/2015                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA=${1}
export NOMBRE="backup_ecs"
export PATHAPL="/tecnol/backups"
export PATHLOG="${PATHAPL}/log"
export PATHDMP="/export"
export LOG="${PATHLOG}/${NOMBRE}.${FECHA}.log"
export DMP="${PATHDMP}/exportECS.${FECHA}.dmp"

ecsutilexport()
{
	ecs util -U emuser -P `cat /home/ecs/scripts/.clap.txt` -export -type all -file ${DMP}
}

ecsutilexport
if [ $? = 0 ]
then
	gzip ${DMP}
 	if [ $? != 0 ]
  	then
  		echo "No se pudo comprimir el archivo de backup"
		exit 2
  	else
  		echo "El backup finalizo exitosamente y se comprimio el archivo"
		find ${PATHDMP} -name "exportECS.*.dmp.gz" -mtime +7 -exec rm {} \;
		find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +7 -exec rm {} \;
  		exit 0
 	fi
else
	echo "El backup finalizo MAL"
	exit 1
fi
