#!/usr/bin/ksh
#******************************************************************
# Script:      ttes0040.sh
# Fecha:       06/10/2003
#
# Descripcion: Carga de Recuentos de Juncadella en NSTF
#
#
# Autor:	Devito Gustavo
# Modif:	27/04/2004
#*******************************************************************
set -x


if [ "$#" -ne 2 ]
then
        echo "Usage $0 MMDD SSS"
        exit  32
else
        FECHA=$1        #Parametro (MMDD)
        SUCURSAL=$2     #Nro sucursal (SSS)
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



##------------------------------------------------------Def. de variables--##

DIRECTORIO="/sfctrl/sts"
ARCHIVO_CARGA="$DIRECTORIO/$FECHA""r"".$SUCURSAL"
RESUL=/sfctrl/sts/ptes0250.lst
DONDESQL=/sfctrl/sts/sql
SQLGEN=ptes0250.sql
BASE=u601/u601

##---------------------------------------------------Fin def. de variables--##


#Borro archivo de log a generar 
borrar $RESUL


if [ -s $ARCHIVO_CARGA ]
then
	if [ -x $ORACLE_HOME/bin/sqlplus ]
	then
		if [ -r $DONDESQL/$SQLGEN ]
		then

			sqlplus $BASE @$DONDESQL/$SQLGEN  $ARCHIVO_CARGA
			if [ "$?" != 0 ]
	                then
				echo "ERROR al intenta correr $SQLGEN"
                        	exit 3
                	else
                        	if [ -s $RESUL ]
                        	then
					egrep  "ORA-|ERROR" $RESUL
                                	if [ "$?" = 0 ]
                                	then 
                                        	echo "ERROR EN el resultado del $SQLGEN"
                                        	exit 6
                                	else
                                        	echo "Fin ok script $0"
						mv $ARCHIVO_CARGA $ARCHIVO_CARGA.OK
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
else
	echo "No existe archivo $ARCHIVO_CARGA a cargar"
	exit 12
fi
