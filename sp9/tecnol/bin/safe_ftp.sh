#!/usr/bin/ksh
set -x
################################################################################
#
# Script     : safe_ftp.sh
# Autor      : Cesar Lopez
# Equipo     : sp9
# Path       : /tecnica_GDM816/CAP/bin
# Fecha      : 22/03/2002
# Descripcion: Ejecuta el safe_ftp
#
################################################################################

if [ $# -ne 4 ]
then
        #Usage $0 SOURCE_HOST USER PASSWD COMMAND_FILE 
        exit 14
else
	HOST=${1}		#Source host
	USR=${2}
	PASS=${3}
	CMD_FILE=${4}		#FTP command file
fi

DIRCAP=/tecnica_GDM816/CAP

cd $DIRCAP
if [ $? != 0 ]
then
	echo "No se pudo acceder al directorio $DIRCAP"
	exit 2
fi

#Genero archivo de comandos

						> $CMD_FILE

if [ $HOST = DMZ_ftp_site ]
 then
	echo "cd /proveed"			>> $CMD_FILE
fi
	echo "ascii"                            >> $CMD_FILE
	echo "lcd $DIRCAP"			>> $CMD_FILE
	echo "put PAGOS.DAT "			>> $CMD_FILE
	echo "put PROV.DAT "			>> $CMD_FILE
	echo "put DETALLES.DAT "		>> $CMD_FILE
	echo "quit"                             >> $CMD_FILE

$DIRCAP/bin/safe_ftp $HOST "" "" $CMD_FILE
exit $?
