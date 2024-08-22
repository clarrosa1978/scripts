#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: STOREFLOW                                              #
# Grupo..............: CIERRE                                                 #
# Autor..............: TECNOLOGIA (C.A.S)                                     #
# Usuario CTRL-M.....: root                                                   #
# Job Name...........: SFCIERR075                                             #
# Objetivo...........: Ejecutar el scripts safe_rcp                           #
# Nombre del programa: safe_rcp.sh                                            #
# Descripcion........: Envia el archivo de cantidad de transaciones al job en #
#                      sucursal                                               #
# Modificacion.......: 25/04/2002                                             #
###############################################################################

set -x
###############################################################################
#                          Definicion de Variables                            #
###############################################################################

SUC=$1
SOURCE_FILE=sfcierr070.${SUC}.tmp
TARGET_FILE=sfcierr070.tmp
SOURCE_DIR=/sfctrl/tmp
TARGET_DIR=/sfctrl/tmp

if [ $SUC -le 099 ]
then
 TARGET_HOST=suc`echo ${SUC}|cut -c2-3`
else
 TARGET_HOST=suc${SUC}
fi

if [ ! -s ${SOURCE_DIR}/${SOURCE_FILE} ]
then
 echo "No se genero archivo para esta sucursal"
 exit 10
fi

/tecnol/util/safe_scp "P" ${SOURCE_DIR} ${SOURCE_FILE} ${TARGET_HOST} ${TARGET_DIR} ${TARGET_FILE} NULL NULL 1 1 NULL root system 644
STATUS=$?
if [ ${STATUS} = 52 ]
then
 exit 38
fi

if [ ${STATUS} != 0 ]
then
 echo "Error en transferencia. Exit status del safe_rcp = ${STATUS}"
 exit 2
fi

exit 0
