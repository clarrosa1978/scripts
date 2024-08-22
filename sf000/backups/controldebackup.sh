#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: UTIL                                                   #
# Grupo..............: DATABASE                                               #
# Autor..............: GAUNA                                                  #
# Objetivo...........:                                                        #
# Nombre del programa: controldeback.sh                                       #
# Nombre del JOB.....: Control de backup'                                     #
# Solicitado por.....:                                                        #
# Descripcion........: Controla el backup de RMAN                             #
# Solicitado por.....: Administracion DB                                      #
# Creacion...........: 19/11/2012                                             #
# Modificacion.......:                                                        #
###############################################################################

set -x
 
###############################################################################
###                            Variables                                    ###
###############################################################################
 
export FECHA=${1}
export NOMBRE="controldebackup"
export PATHAPL="/tecnol/backups"
export PATHSQL="${PATHAPL}/sql"
export PATHLOG="${PATHAPL}/log"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"
export USUARIO="/"
export SQLGEN="${PATHSQL}/${NOMBRE}.sql"
export LSTSQLGEN="${PATHLOG}/${NOMBRE}.${FECHA}.lst"
export DESTINATARIO="dbadmin"
export ASUNTO="Control de backup con RMAN - ${FECHA}"

###############################################################################
###                            Funciones                                    ###
###############################################################################

Enviar_mail_alerta ()
{
set -x
export MSG_SUBJECT="$ASUNTO - `hostname` "

for USER in $DESTINATARIO
do
 #      cat $LSTSQLGEN | mutt -s "$MSG_SUBJECT" -b ${USER}@redcoto.com.ar
	cat ${LSTSQLGEN} | mhmail ${USER}@redcoto.com.ar -subject "${MSG_SUBJECT}"
done
}

 
###############################################################################
###                            Principal                                    ###
###############################################################################
 
autoload Check_Par
Check_Par 1 $@
[ $? != 0 ] && exit 1
autoload Enviar_A_Log
Enviar_A_Log "INICIO - Comienza la ejecucion." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
if [ -x $ORACLE_HOME/bin/sqlplus ]
then
        if [ -r ${SQLGEN} ]
        then
                sqlplus ${USUARIO} @${SQLGEN} ${LSTSQLGEN} 
                if [ $? != 0 ]
                then
                        Enviar_A_Log "ERROR - Fallo la ejecucion del sql." ${LOGSCRIPT}
                        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                        exit 5
                else
                        if [ -f ${LSTSQLGEN} ]
                        then
                                grep 'ORA-' ${LSTSQLGEN}
                                if [ $? != 0 ]  
                                then
                                        Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
					Enviar_mail_alerta 	

                                        find ${PATHLOG} -name "${NOMBRE}*.lst" -mtime +30 -exec rm {} \;
                                        find ${PATHLOG} -name "${NOMBRE}*.log" -mtime +30 -exec rm {} \;
                                        exit 0
                                else
                                        Enviar_A_Log "ERROR - Error de Oracle durante la ejecucion." ${LOGSCRIPT}
                                        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                                        exit 7
                                fi
                        else
                                Enviar_A_Log "ERROR - No se genero el archivo de spool." ${LOGSCRIPT}
                                Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                                exit 9
                        fi
                fi
        else
                Enviar_A_Log "ERROR - No hay permisos de lectura para el archivo ${SQLGEN}." ${LOGSCRIPT}
                Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                exit 77
        fi
else
        Enviar_A_Log "ERROR - No hay permisos de ejecucion para el comando sqlplus." ${LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
        exit 88
fi

