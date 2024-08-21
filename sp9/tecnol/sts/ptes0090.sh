#!/usr/bin/ksh
#****************************************************************************************************
# Script:      ptes0090.sh
# Fecha:       24/02/2004
#
# Descripcion: Realiza la compensacion de las monedas que no tienen arqueo.
#
# Autor:      Devito Gustavo
#****************************************************************************************************
set -x

if [ "$#" -ne 3 ]
then
        echo "Usage $0 Empresa Sucursal Fecha"
        exit  32
else
        EMPRESA=$1		#Dos digitos
        SUCURSAL=$2		#Tres digitos
        FECHA=$3		#YYYYMMDD
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



RESUL=/sfctrl/sts/ptes0090.lst
DONDESQL=/sfctrl/sts/sql
SQLGEN=ptes0090.sql
BASE=u601/u601


#Borro archivo de salida del sql
borrar $RESUL


if [ -x $ORACLE_HOME/bin/sqlplus ]
then
	if [ -r $DONDESQL/$SQLGEN ]
	then
		sqlplus $BASE @$DONDESQL/$SQLGEN  $EMPRESA $SUCURSAL $FECHA
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
					echo "Fin ok script $0"
					#cat $RESUL | mail -s "Corrida OK $SQLGEN" gdevito@coto.com.ar
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
