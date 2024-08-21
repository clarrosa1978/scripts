#!/usr/bin/ksh
set -x
################################################################################
#      Script: envioftp.sh
#       Autor: Gustavo Goette
#       Modif: HDP
#    Ult.Mod.: 15/10/2001
# Descripcion: transf. de archivos FTP
################################################################################

if [ $# -ne 5 ]
then
        #Usage $0 DATE SOURCE_HOST APLICATION_NAME PATH SUCURSAL
       exit 14
else
        DATE="$1"              #FECHA (Segun formato ddmmaa o jjj)
        TARGET_HOST="192.168.109.112"   #Source HOST
        APLICATION="$3"          # Aplication's name
        APPATH="$4"            # path origen
        SUC="$5"               # sucursal(SSS o CENTRAL)
fi

#----------------------------------#
#          FUNCIONES               #
#----------------------------------#

function mostrar
{
echo "`date +%d/%m/%y-%T`:$1" >> $LOG
}

#----------------------------------#
#          FIN FUNCIONES           #
#----------------------------------#

LOG=/tmp/ftppfacil.log
COMMAND_FILE=/tmp/$$.cmd	#File whith FTP commands

mostrar "Genero archivo de comandos del FTP" 
#------------------------------------------#

case $APPATH in

	"/Out")
		echo "ascii"			> $COMMAND_FILE
	        APPATH="Out"
                export $APPATH	
		echo "cd $APPATH"		>> $COMMAND_FILE
		echo "get pf"$DATE".053"	>> $COMMAND_FILE
		echo "quit"			>> $COMMAND_FILE

		DIR=/pagofacil/concilia/entrada
		;;
	"/Out/TarjetaCoto")
		echo "ascii"			> $COMMAND_FILE
		APPATH="Out"
                export $APPATH
		echo "cd $APPATH"		>> $COMMAND_FILE
		echo "get pf"$DATE".900"	>> $COMMAND_FILE
		echo "quit"			>> $COMMAND_FILE

		DIR=/pagofacil
		;;
	"/In")
		echo "ascii"				> $COMMAND_FILE
		APPATH="In"
                export $APPATH
		echo "cd $APPATH"			>> $COMMAND_FILE 

		if [ $SUC = "CENTRAL" ]
		then

			echo "put archivos$DATE.txt"	>> $COMMAND_FILE
			echo "quit"			>> $COMMAND_FILE

			DIR=/pagofacil/tmp

		else
			echo "put CO"$DATE"00"$SUC""	>> $COMMAND_FILE
			echo "quit"			>> $COMMAND_FILE

			DIR=/pagofacil/concilia/salida

		fi


		;;
esac


cd $DIR 2>/dev/null

/tecnol/bin/safe_ftp "$TARGET_HOST" "" "" "$COMMAND_FILE" "$APPATH"
STATUS="$?"
if [ "$STATUS" != 0 ]
then
	mostrar "Error en la transferencia de archivos"
	exit $STATUS
else
	mostrar "Fin transf. Archivos de $APLICATION OK" 
	rm -f $COMMAND_FILE
	exit 0
fi
