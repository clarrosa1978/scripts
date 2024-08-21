#!/bin/sh
###############################################################################
# Aplicacion.........: MENU OPERACIONES SUCURSAL                              #
# Grupo..............:                                                        #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Ejecutar el .sql recibido como parametro.              #
# Nombre del programa: db.sh                                                  #
# Solicitado por.....:                                                        #
# Descripcion........:                                                        #
# Creacion...........: 05/02/2013                                             #
# Modificacion.......: DD/MM/AAAA                                             #
###############################################################################


###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA="`date +%Y%m%d`"
export OPERACION=${1}
export SID=${2}
export PATHAPL="/tecnol/operador"
export FPATH="/tecnol/funciones"
export PATHSQL="${PATHAPL}/sql"
export PATHLOG="${PATHAPL}/log"

case ${OPERACION} in
'UP')
	export NOMBRE="updbsec"
	;;

'DOWN')
	export NOMBRE="downdb"
	;;

*)
	echo "PARAMETRO NO SOPORTADO - AVISAR A ADM UNIX"
	exit
	;;
esac
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"
export USUARIO="'/ as sysdba'"
export SQLGEN="${PATHSQL}/${NOMBRE}.sql"

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Borrar
autoload Enviar_A_Log

###############################################################################
###                            Principal                                    ###
###############################################################################
Enviar_A_Log "INICIO - Comienza la ejecucion." ${LOGSCRIPT}
if [ -x /u01/app/oracle/product/9.2.0/bin/sqlplus ]
then
        if [ -r ${SQLGEN} ]
        then
                su - oracle -c "export ORACLE_SID=${SID} ; sqlplus -s ${USUARIO} @${SQLGEN}"
                if [ $? != 0 ]
                then
                        Enviar_A_Log "ERROR - Fallo la ejecucion del sql." ${LOGSCRIPT}
                        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                else
			Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
                fi
        else
                Enviar_A_Log "ERROR - No hay permisos de lectura para el archivo ${SQLGEN}." ${LOGSCRIPT}
                Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
        fi
else
        Enviar_A_Log "ERROR - No hay permisos de ejecucion para el comando sqlplus." ${LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
fi
