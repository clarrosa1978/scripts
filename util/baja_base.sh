#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: NTCIERRE-ZE                                            #
# Grupo..............: PRECADENA                                              #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Baja la base de datos de SF.                           #
# Nombre del programa: baja_base.sh                                           #
# Nombre del JOB.....: BAJADB                                                 #
# Descripcion........:                                                        #
# Modificacion.......: 13/03/2006                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################

export GDM=${6}
export CONEXIONES=""
export ORA_USR="oracle"
export PATHSQL="/tecnol/ntcierre/sql"
export SQL="${PATHSQL}/down.sql"

###############################################################################
###                            Principal                                    ###
###############################################################################
autoload Check_Par
Check_Par 9 $@
[ $? != 0 ] && exit 1
if [ ${GDM} = "YES" ]
then
	ORA_USR=ora816
fi
su - ${ORA_USR} "-c  . ./.profile ;lsnrctl stop"
[ $? != 0 ] && exit 7

for CONEXIONES in `ps -ef|grep LOCAL= |grep -v root |awk '{print $2}'`
do
	kill -9 ${CONEXIONES}
	[ $? != 0 ] && exit 18
done

su - ${ORA_USR} "-c . ./.profile ; sqlplus '/ as sysdba' @${SQL}"
[ $? != 0 ] && exit 19

if [ $GDM = "YES" ]
then
	ORA_USR=ora816
	su - ${ORA_USR} "-c . ./.profile ; sqlplus 'sys/manager as sysdba' @${SQL}"
	[ $? != 0 ] && exit 19
fi
