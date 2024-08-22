#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: Procesos                                               #
# Grupo..............: sfctr                                                  #
# Autor..............: SMA                                                    #
# Objetivo...........:                                                        #
# Nombre del programa: limpia_tar_tdc.sh                                      #
# Nombre del JOB.....: TDC                                                    #
# Solicitado por.....: Jose Chariano                                          #
# Descripcion........: Limpia tajeta de descuentos COTO                       #
# Creacion...........: 4/11/2010                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA=${1}
export NOMBRE="limpia_tar_tdc"
export PATHAPL="/tecnol/sfctrl"
export PATHSQL="${PATHAPL}/sql"
export PATHLOG="${PATHAPL}/log"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"
export USUARIO="/"
export SQLGEN="${PATHSQL}/${NOMBRE}.sql"
export LSTSQLGEN="${PATHLOG}/${NOMBRE}.${FECHA}.lst"

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Borrar
autoload Check_Par
autoload Enviar_A_Log

enviar_mail ()
{
#set -x
export USUARIOS="SoporteStoreflow"
#export USUARIOS="srmaccione"
export FILE_LOG="$LSTSQLGEN"
export MSG_SUBJECT=${1}

for USER in $USUARIOS
do
        cat $FILE_LOG| mail -s "${MSG_SUBJECT}"  ${USER}@redcoto.com.ar
done
}


###############################################################################
###                            Principal                                    ###
###############################################################################
Check_Par 1 $@
[ $? != 0 ] && exit 1
Enviar_A_Log "INICIO - Comienza la ejecucion." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
Borrar ${LSTSQLGEN}
[ $? != 0 ] && exit 99
if [ -x $ORACLE_HOME/bin/sqlplus ]
then
        if [ -r ${SQLGEN} ]
        then
                sqlplus ${USUARIO} @${SQLGEN} ${LSTSQLGEN}
                if [ $? != 0 ]
                then
			Enviar_A_Log "ERROR - Fallo la ejecucion del sql." ${LOGSCRIPT}
			Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                        TITULO="Job_TDC_finalizocon_error"
			enviar_mail ${TITULO}
                        exit 5
                else
                        if [ -f ${LSTSQLGEN} ]
                        then
                                grep 'ORA-' ${LSTSQLGEN}
                                if [ $? != 0 ] 	
				then
					Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
                                        TITULO="Job_TDC_finalizo_OK"
				 	find ${PATHLOG} -name "${NOMBRE}.*.lst" -mtime +7 -exec rm {} \;
				 	find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +7 -exec rm {} \;
			                enviar_mail ${TITULO}
					exit 0
				else
					TITULO="Job_TDC_finalizo_con_error"
			                enviar_mail ${TITULO}
					Enviar_A_Log "ERROR - Error de Oracle durante la ejecucion." ${LOGSCRIPT}
					Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
					exit 7
				fi
                        else
				Enviar_A_Log "ERROR - No se genero el archivo de spool." ${LOGSCRIPT}
				Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                                TITULO="Job_TDC_finalizo_con_error"
			                enviar_mail ${TITULO}
                                exit 9
                        fi
                fi
        else
		Enviar_A_Log "ERROR - No hay permisos de lectura para el archivo ${SQLGEN}." ${LOGSCRIPT}
		Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                TITULO="Job_TDC_finalizo_con_error"
		enviar_mail ${TITULO}
                exit 77
        fi
else
	Enviar_A_Log "ERROR - No hay permisos de ejecucion para el comando sqlplus." ${LOGSCRIPT}
	Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
        TITULO="Job_TDC_finalizo_con_error"
        enviar_mail ${TITULO}
        exit 88
fi
