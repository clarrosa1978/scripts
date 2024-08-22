#!/usr/bin/ksh
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

export FECHA=${1}
export NOMBRE="ptes0220"
export PATHAPL="/tecnol/sts"
export PATHLOG="${PATHAPL}/log"
export RESUL="${PATHLOG}/${NOMBRE}.${FECHA}.lst"
export PATHSQL="${PATHAPL}/sql"
export SQLGEN="${PATHSQL}/${NOMBRE}.sql"
export BASE="/"


#Borro archivo de salida del sql
borrar $RESUL


if [ -x $ORACLE_HOME/bin/sqlplus ]
then
        if [ -r $SQLGEN ]
        then
		sqlplus $BASE @${SQLGEN} ${RESUL}
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
					find ${PATHLOG} -name "${NOMBRE}*.lst" -mtime +7 -exec rm {} \;
					exit 0
				fi
			else
				echo " ERROR, no se genero archivo $RESUL "
				exit 9
			fi
		fi
	else
		echo "ERROR, sin permiso de lectura ( r ) sobre $SQLGEN"
		exit 77
	fi
else
	echo "ERROR, sin permiso de ejecucion ( x ) sobre $ORACLE_HOME/bin/sqlplus"
	exit 88
fi
