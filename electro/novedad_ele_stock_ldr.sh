#!/usr/bin/ksh
#******************************************************************************
# Nombre:      novedad_ele_stock_ldr.sh
# Fecha:       09/10/2003
#
# Descripcion: Actualiza novedades y stock de articulos de electro
# 
# Autor:       Ariel Santos
#******************************************************************************
set -x

if [ $# != 3 ]
then
	echo "ERROR, parametros de ejecucion mal informados"
        echo " Usar  $0 EMPRESA(EE) SUCURSAL(SSS) FECHA"
	exit 32
else
	EMPRESA=${1}
	SUCURSAL=${2}
	FECHA=${3}
fi

##-----------------------------------------------------FUNCIONES---##

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

##---------------------------------------------------FIN FUNCIONES---##


##-----------------------------------------------------VARIABLES-----##

ARCHCTL=/tecnol/electro/sql/novedad_ele_stock_ldr.ctl
ARCHDAT=novedad_ele_stock_${EMPRESA}${SUCURSAL}
export NLS_LANG=AMERICAN_AMERICA.WE8DEC

##---------------------------------------------------FIN VARIABLES---##


##Borrar archivo de control del sqlldr
borrar ${ARCHDAT}.log
borrar ${ARCHDAT}.bad


cd $NAPA_HOME/data/carga
if [ $? != 0 ]
then
	echo "No se pudo acceder a $NAPA_HOME/data/carga"
	exit 3
fi


if [ -x $ORACLE_HOME/bin/sqlldr ]
then
	if [ -r ${ARCHCTL} ]
	then
		if [ -s ${ARCHDAT}.txt ]
		then
			sqlldr userid=/, control=$ARCHCTL, data=${ARCHDAT}.txt, log=${ARCHDAT}.log, bad=${ARCHDAT}.bad, bindsize=8388608
			if [ $? != 0 ]
			then
				echo "ERROR en la ejecucion del loader"
				grep ORA- ${ARCHDAT}.log
				exit 6
			else
				mv -f ${ARCHDAT}.txt ${ARCHDAT}.${FECHA}.txt
				if [ $? != 0 ]
				then
					echo "No se pudo renombrar ${ARCHDAT}.txt"
					exit 9
				else
					compress -f ${ARCHDAT}.${FECHA}.txt
					if [ $? != 0 ]
					then
						echo "No se pudo comprimir ${ARCHDAT}.${FECHA}.txt"
						exit 12
					else
						echo "Depuro interfaces de mas de 7 dias de antig."

						find . -name "${ARCHDAT}.????????.txt.Z" -mtime +7 -exec rm -f {} \;
						exit 0
					fi
				fi
			fi
		else
			echo "Sin movimientos para la fecha ${FECHA}" |compress > ${ARCHDAT}.${FECHA}.txt.Z
			exit 0
		fi
	else
		echo "ERROR sin permiso de lectura ( r ) sobre ${ARCHCTL}"
		exit 15
	fi
else
	echo "ERROR, sin permiso de ejecucion ( x ) sobre $ORACLE_HOME/bin/sqlldr"
	exit 88
fi
