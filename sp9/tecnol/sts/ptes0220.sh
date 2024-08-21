#!/usr/bin/ksh
#****************************************************************************************************
# Script:      ptes0220.sh
# Fecha:       24/03/2004
#
# Descripcion: Depura todas las entidades del sistema en funcion de la pametrizacion de meses hecha.
#
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

RESUL=/sfctrl/sts/ptes0220.lst
SQLGEN=ptes0220.sql
DONDESQL=/sfctrl/sts/sql
BASE=u601/u601


#Borro archivo de salida del sql
borrar $RESUL


if [ -x $ORACLE_HOME/bin/sqlplus ]
then
        if [ -r $DONDESQL/$SQLGEN ]
        then
		sqlplus $BASE @$DONDESQL/ptes0220.sql
		if [ "$?" != 0 ]
		then
			echo "ERROR al intenta correr el ptes0220.sql"
			exit 3
		else
			if [ -s $RESUL ]
			then
				grep ORA $RESUL
				if [ "$?" = 0 ]
				then 
					echo "ERROR EN el resultado del ptes0220.sql"
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
