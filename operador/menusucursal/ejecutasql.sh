#!/bin/sh
###############################################################################
# Aplicacion.........: MENU OPERACIONES SUCURSAL                              #
# Grupo..............:                                                        #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Ejecutar el .sql recibido como parametro.              #
# Nombre del programa: ejecutasql.sh                                          #
# Solicitado por.....:                                                        #
# Descripcion........:                                                        #
# Creacion...........: 05/02/2013                                             #
# Modificacion.......: DD/MM/AAAA                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA="`date +%Y%m%d`"
export SUC="`uname -n | sed 's/suc//'`"
export NOMBRE="${1}"
export PATHAPL="/tecnol/operador"
export PATHSQL="${PATHAPL}/sql"
export PATHLOG="${PATHAPL}/log"
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

if [ $SUC -lt 100 ]
then
        SUC=0$SUC
fi
case $NOMBRE in
        updb|downdb|habilitalog|deshabilitalog|chklog)      export SID="SF${SUC}"
                    	;;
        updbctrlm|downdbctrlm)      export SID="CTRLM${SUC}"
	   		;; 
esac

Enviar_A_Log "INICIO - Comienza la ejecucion." ${LOGSCRIPT}
if [ -x /u01/app/oracle/product/9.2.0/bin/sqlplus ]
then
        if [ -r ${SQLGEN} ]
        then
		su - oracle -c "export ORACLE_SID=${SID} ; sqlplus -s ${USUARIO} @${SQLGEN}" 
                #su - oracle -c "ORACLE_SID=${SID}" ;  su - oracle -c "sqlplus -s ${USUARIO} @${SQLGEN}"
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
echo "\n\t\t\t\t${REV}Presione una tecla para continuar...${EREV}"
read
