#!/usr/bin/ksh
#*****************************************************************************
# Script:      ptes0210.sh
# Fecha:       24/03/2004
#
# Descripcion: Levanta datos del archivo recibido como parametro, para
#              efectuar la conciliacion.
#
# Autor:       Devito Gustavo
#*****************************************************************************
set -x

##------------------------------------------------------------FUNCIONES--#

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

##---------------------------------------------------------Fin FUNCIONES--#

if [ $# -ne 2 ]
then
	echo "Error en cantidad de parametros"
	exit 32
else
	SUC=${1}
	FECHA=${2}
fi

RESUL=/sfctrl/sts/ptes0210.lst
DONDESQL=/sfctrl/sts/sql
SQLGEN=ptes0210.sql
BASE=u601/u601
ARCHIVO=/sfctrl/sts/STSCM02_01${SUC}_${FECHA}??????.txt

borrar $RESUL
borrar $ARCHIVO


if [ -x $ORACLE_HOME/bin/sqlplus ]
then
	if [  -r $DONDESQL/$SQLGEN ]
	then
		sqlplus $BASE @$DONDESQL/$SQLGEN $SUC $FECHA 
		if [ $? != 0 ]
		then
			echo "ERROR al intentar correr el $SQLGEN"
			exit 3
		else
			if [ -s $RESUL ]
			then
				grep ORA- $RESUL
				if [ $? = 0 ]
				then 
					echo "ERROR EN el resultado del $SQLGEN"
					exit 6
				else
					CANT=`ls $ARCHIVO |wc -l`
					if [ $CANT -gt 1 ]
					then
						echo "Existe mas de un archivo /sfctrl/sts/STSCM02_01${SUC}_${FECHA}*"
						echo "Verificar !"
						exit 9
					else

						mv -f $ARCHIVO /sfctrl/sts/STSCM02_01${SUC}_${FECHA}.txt

						if [ ! -s /sfctrl/sts/STSCM02_01${SUC}_${FECHA}.txt ]
						then
							echo "Archivo /sfctrl/sts/STSCM02_01${SUC}_${FECHA}.txt vacio o inexistente"
							exit 12
						else
							echo "Fin OK SCRIPT $0"
							exit 0
						fi
					fi

				fi

			else
				echo "ERROR, no se genero archivo $RESUL"
				exit 15
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
