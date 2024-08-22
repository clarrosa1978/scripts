#!/usr/bin/ksh
###############################################################################
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........:                                                        #
# Nombre del programa: stopms.sh                                              #
# Nombre del JOB.....:                                                        #
# Solicitado por.....:                                                        #
# Descripcion........: Para jobs de venta en SFC                              #
# Creacion...........: 08/10/2010                                             #
# Modificacion.......: DD/MM/AAAA                                             #
###############################################################################

#set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export NOMBRE="stopms"
export PATHAPL="/tecnol/operador"
export PATHSQL="${PATHAPL}/sql"
export USUARIO="ctrolvta/vtactrol"
export SQLGEN="${PATHSQL}/${NOMBRE}.sql"

###############################################################################
###                            Principal                                    ###
###############################################################################
if [ -x $ORACLE_HOME/bin/sqlplus ]
then
        if [ -r ${SQLGEN} ]
        then
                sqlplus -s ${USUARIO} @${SQLGEN} ${LSTSQLGEN}
		echo "\nPresione una tecla para continuar\c"
		read 
        else
                echo "\n\nNo hay permisos de lectura para el archivo ${SQLGEN}."
                echo "\nPresione una tecla para continuar\c"
                read
        fi
else
        echo "\n\nNo hay permisos de ejecucion para el comando sqlplus."
       	echo "\nPresione una tecla para continuar\c"
        read
fi
