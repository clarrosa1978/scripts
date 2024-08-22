#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: STOREFLOW                                              #
# Grupo..............: CIERRE-SF000                                           #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Copia y comprime el tlog utilizado.                    #
# Nombre del programa: preparartlog.sh                                        #
# Nombre del JOB.....: PREPTLOG                                               #
# Descripcion........:                                                        #
# Modificacion.......: 15/08/2006	                                      # 
###############################################################################

set -x

###############################################################################
###                          Variables                                      ###
###############################################################################
export FECHA=${1}
export PATHAPL="/sfctrl/d"
export ARCHIVO="`ls -1t ${PATHAPL}/tlog??.dat | head -1`"
export ARCHIVO2="${PATHAPL}/tlog000.${FECHA}"

###############################################################################
###                          Funciones                                      ###
###############################################################################
autoload Check_Par
autoload Borrar

###############################################################################
###                          Principal                                      ###
###############################################################################
Check_Par 1 $@
[ $? != 0 ] && exit 1
[ ${ARCHIVO} ] || exit 4
if [ -s ${ARCHIVO} ] 
then
	cp -p ${ARCHIVO} ${ARCHIVO2}
	if [ $? = 0 ]
	then
		compress -f ${ARCHIVO2}
		if [ $? != 0 ]
		then
			echo "ERROR - No se pudo comprimir el archivo ${ARCHVO2}."
			exit 7
		else
			find /sfctrl/d -name "tlog000.*" -mtime +2 -exec rm {} \;
			exit 0
		fi
	else 
		echo "ERROR - Al copiar el archivo ${ARCHIVO1} como ${ARCHIVO2}."
		exit 3
	fi
else
	echo "ERROR - El archivo ${ARCHIVO1} tiene size 0 o no existe."
	exit 12
fi
