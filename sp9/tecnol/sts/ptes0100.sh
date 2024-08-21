#!/usr/bin/ksh
#****************************************************************************************************
# Script:      ptes0100.sh
# Fecha:       14/01/2004
#
# Descripcion: Copia datos de tablas T6040300 T6040900 t6041500 de STF al entorno STS
#
#
# 15/01/2004 : Envia mail a G.Devito con detalle de corrida.
# Autor:      Devito Gustavo
#****************************************************************************************************
set -x

##---------------------------------------------------------------Funciones--#

function borrar
{
if [ -f $@ ]
then
        rm -f $@
        if [ -f $@ ]
        then
                echo "\t\n\nERROR, No puedo borrar archivo $@\n"
                echo "\tborrelo a mano y reejecute el presente script\n\n"
                exit 10
        fi
fi
}

##---------------------------------------------------------------Fin Funciones--#



RESUL=/sfctrl/sts/ptes0100.lst
DONDESQL=/sfctrl/sts/sql
SQLGEN=ptes0100.sql
BASE=u601/u601


#Borro archivo de salida del sql
borrar $RESUL


if [ -x $ORACLE_HOME/bin/sqlplus ]
then
	if [ -r $DONDESQL/$SQLGEN ]
	then
		sqlplus $BASE @$DONDESQL/$SQLGEN 
		if [ "$?" != 0 ]
		then
			echo "ERROR al intenta correr el ptes0100.sql"
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
					echo "Fin ok script $0"
					exit 0
				fi
			else
				echo " ERROR, no se genero archivo $RESUL "
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
