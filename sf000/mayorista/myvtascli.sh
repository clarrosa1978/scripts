#!/usr/bin/ksh
#***************************************************************************************
# Script:      myvtascli.sh								*
# Fecha:       10/09/2007								*
# Descripcion: Inserta en tabla MY_ACUM_VTASCLI, la evolucion de venta por cliente.	*
# Autor: sberteloot									*
# Implemeto : Cerizola Hugo 13-09-2007							*
#****************************************************************************************
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
                echo "\tborrelo a mano y ejecute nuevamente el presente script\n\n"
                exit 10
        fi
fi
}
##---------------------------------------------------------------Fin Funciones--#
RESUL=/tecnol/mayorista/log/myvtascli.log
SQLGEN=myvtascli.sql
DONDESQL=/tecnol/mayorista/sql 
BASE=/

#Borro archivo de salida del sql
borrar $RESUL
if [ -x $ORACLE_HOME/bin/sqlplus ]
then
        if [ -r $DONDESQL/$SQLGEN ]
        then
                sqlplus $BASE @$DONDESQL/myvtascli.sql $RESUL
                if [ "$?" != 0 ]
                then
                        echo "ERROR al intentar correr el myvtascli.sql"
                        exit 3
                else
                        if [ -s $RESUL ]
                        then
                                grep ORA- $RESUL
                                if [ "$?" = 0 ]
                                then 
                                        echo "ERROR EN el resultado del myvtascli.sql"
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
