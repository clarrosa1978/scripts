#!/bin/ksh
###############################################################################
# Aplicacion.........: MENU OPERACIONES SF000                                 #
# Grupo..............:                                                        #
# Autor..............: 		                                              #
# Objetivo...........: Ejecutar el .sql recibido como parametro.              #
# Nombre del programa: adm_db.sh                                                  #
# Solicitado por.....:                                                        #
# Descripcion........:                                                        #
# Creacion...........: 05/02/2013                                             #
# Modificacion.......: DD/MM/AAAA                                             #
###############################################################################

#set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA="`date +%Y%m%d`"
export OPERACION=${1}
export DB=${2}
export SERV="SF"
#export SERV="`uname -n | sed 's/suc//g' | sed 's/c$//g'`"
if [ ${SERV} -lt 100 ]
then
	export SUC=0${SERV}
fi
export PATHAPL="/tecnol/operador"
export FPATH="/tecnol/funciones"
export PATHSQL="${PATHAPL}/sql"
export PATHLOG="${PATHAPL}/log"

case ${DB} in
#'SF')
#	SID="SF${SERV}"
#	USUARIO_OS="oracle"
#	EXESQL="/u011/app/oracle/product/11.2.0/bin/sqlplus"
#	;;

'CTM7')
	SID="CTM7${SERV}"
	USUARIO_OS="oracle"
	EXESQL="/u011/app/oracle/product/11.2.0/bin/sqlplus"
	;;

*)
	echo "PARAMETRO NO SOPORTADO - AVISAR A ADM UNIX"
	exit
	;;
esac

case ${OPERACION} in
'UP')
	export NOMBRE="updb"
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
typeset -fu  Borrar
typeset -fu  Enviar_A_Log

###############################################################################
###                            Principal                                    ###
###############################################################################
Enviar_A_Log "INICIO - Comienza la ejecucion." ${LOGSCRIPT}

if [ -x ${EXESQL} ]
then
       	if [ -r ${SQLGEN} ]
        then
       	        su - ${USUARIO_OS} -c "export ORACLE_SID=${SID} ; sqlplus -s ${USUARIO} @${SQLGEN}"
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
