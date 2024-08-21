#!/usr/bin/ksh
#*****************************************************************************
# Script:      ptes0190.sh
# Fecha:       22/03/2004
#
# Descripcion: Levanta datos del archivo recibido como parametro
#
# Autor:       Devito Gustavo
#*****************************************************************************
set -x

if [ "$#" -ne 1 ]
then
	echo "Usage $0 Archivo"
	exit 32
else
	ARCHIVO="$1"
fi

RESUL=/sfctrl/sts/ptes0190.lst
DONDESQL=/sfctrl/sts/sql
SQLGEN=ptes0190.sql
BASE=u601/u601

#Borro archivo de salida del sql
rm -f $RESUL
if [ -f $RESUL ]
then
	echo "ERROR. No se pudo borrar $RESUL"
	exit 10
fi

if [ -x $ORACLE_HOME/bin/sqlplus ]
then
	if [ -r $DONDESQL/$SQLGEN ]
	then
		sqlplus $BASE @$DONDESQL/$SQLGEN $ARCHIVO > /dev/null
		if [ "$?" != 0 ]
		then
			echo "ERROR al intentar correr el $SQLGEN"
			exit 3
		else
			if [ -s $RESUL ]
			then
				grep ORA $RESUL
				if [ "$?" = 0 ]
				then 
					echo "ERROR EN el resultado del $SQLGEN"
					exit 6
				else
					exit 0
				fi
			else
				echo " ERROR, no se genero archivo $RESUL"
				exit 9
			fi
		fi
	else
		echo "ERROR, sin permiso de lectura ( r ) sobre $DONDESQL/$SQLGEN"
		exit 77
	fi
else
	echo "ERROR, sin permiso de ejecucion ( x ) sobre $ORACLE_HOME/bin/sqlplus"
	exit 88
fi



