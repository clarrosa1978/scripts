#!/usr/bin/ksh
#*****************************************************************************************
# Script:      ptes0030.sh
# Fecha:       05/02/2004
#
# Descripcion: Realiza los ajustes,si los hubiera, entre las retiradas de STF y los 
#	       recuentos de Juncadella
#
# Autor:      Devito Gustavo
#******************************************************************************************
set -x


if [ "$#" -ne 1 ]
then
        echo "Usage $0 YYYYMMDD"
        exit  32
else
        FECHA=$1        #Parametro (YYYYMMDD)
fi


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



RESUL=/sfctrl/sts/ptes0030.lst
DONDESQL=/sfctrl/sts/sql
SQLGEN=ptes0030.sql
BASE=u601/u601


#Borro archivo de salida del sql
borrar $RESUL


if [ -x $ORACLE_HOME/bin/sqlplus ]
then
	if [ -r $DONDESQL/$SQLGEN ]
	then
		sqlplus $BASE @$DONDESQL/$SQLGEN $FECHA 
		if [ "$?" != 0 ]
		then
			echo "ERROR al intenta correr $SQLGEN"
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
