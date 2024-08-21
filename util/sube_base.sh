#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: NTCIERRE-ZE                                            #
# Grupo..............: PRECADENA                                              #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Sube la base de datos de SF.                           #
# Nombre del programa: sube_base.sh                                           #
# Nombre del JOB.....: SUBEDB                                                 #
# Descripcion........:                                                        #
# Modificacion.......: 15/03/2006                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################

export GDM=${6}
export ORA_USR="oracle"
export PATHSQL="/tecnol/ntcierre/sql"
export SQL="${PATHSQL}/start.sql"

###############################################################################
###                            Principal                                    ###
###############################################################################
autoload Check_Par
Check_Par 9 $@
[ $? != 0 ] && exit 1

su - ${ORA_USR} "-c . ./.profile ; sqlplus '/ as sysdba' @${SQL}"
[ $? != 0 ] && exit 19
if [ $GDM = "YES" ]
then
        ORA_USR=ora816
	su - ${ORA_USR} "-c . ./.profile ; sqlplus '/ as sysdba' @${SQL}"
	[ $? != 0 ] && exit 19
fi	

su - ${ORA_USR} "-c  . ./.profile ;lsnrctl start"
if [ $? != 0 ] 
then
	exit 7
else
	exit 0
fi
