#!/bin/ksh
#######################################################################
# NOMBRE DEL SCRIPT: export_em.sh
# DIRECTORIO DEL SCRIPT: /home2/scripts/ctmadmin
# FECHA DE CREACION: 27/02/2008
# PLATAFORMAS QUE SOPORTA:Unix - Linux
# PERFIL DE USUARIO REQUERIDO PARA LA EJECUCION: ctmprod
# AUTOR: Gustavo Goette - CG Consultores SRL
# DESCRIPCION: Export de base de datos de Control-M EM
#
# FUNCIONES QUE COMPONEN EL SCRIPT:
# PARAMETROS QUE RECIBE:
#            1 = Fecha de Backup
# EXIT STATUS:
#            32 = Menor cantidad de parametros de lo esperado
# FECHA DE MODIFICACION:  /  /
# MODIFICADO POR:
# DESCRIPCION DE LA MODIFICACION:
#######################################################################
#CARGA DE FUNCIONES
. /etc/profile
. $MENU_CTM/funciones/funciones.lib
#DEFINCION DE VARIABLES
MIRROR_NODE=`cat $MENU_CTM/funciones/dynamic_menu.var | grep 'export MIRROR_NODE=' | cut -f2 -d=`
#FECHA DE BACKUP
export DATE=$1
#FECHA DE ELIMINACION
export DEL_DATE=$2
#PF FILE
export PF_FILE=$HOME/.controlm
#DIRECTORIO DE EXPORT
export EXPORT_DIR=$HOME/backups
#ARCHIVO DE EXPORT
export EXPORT_FILE=$EXPORT_DIR/$DATE.exp
#ARCHIVO A ELIMINAR
export DEL_FILE=$EXPORT_DIR/$DEL_DATE.exp.Z
#VERIFICACION DE PARAMETROS
test_param $# 2  

#EJECUCION DEL PROGRAMA
ecs util -pf $HOME/.controlm -export -type all -type history -file $EXPORT_FILE
test_status $? export
gzip -f $EXPORT_FILE
test_status $? compress
if [ -f $DEL_FILE ]
then
	file_remove $DEL_FILE 
fi
scp ${EXPORT_FILE}.gz ${MIRROR_NODE}:${EXPORT_FILE}.gz
test_status $? scp

