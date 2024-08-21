#!/usr/bin/ksh
###############################################################################
# Grupo..............: BACKUP                                                 #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Realizar backup de la base de datos parametro a disco. #
# Nombre del programa: bkpfull_disk.sh                                        #
# Nombre del JOB.....:                                                        #
# Solicitado por.....:                                                        #
# Descripcion........: Realiza un backup full de la base de datos parmatro.   #
#                      Con la entrada del archivo bkpfull_disk.rmn.           #
# Modificacion.......: 18/08/2010                                             #
# Tipo de errores de salida :                                                 #
#                          4 y 8 : Warning.                                   #
#                             12 : Critico.                                   #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA=${1}
export ORACLE_SID=${2}
export NOMBRE="bkpfull_disk"
export PATHAPL="/tecnol/backups"
export PATHLOG="${PATHAPL}/log"
export PATHBKP="/backup"
export RMAN="${PATHAPL}/bkpfull_disk.${ORACLE_SID}.rmn"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.${ORACLE_SID}.log"
export LOGRMAN="${PATHLOG}/${NOMBRE}.${FECHA}.${ORACLE_SID}.rman.log"

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Borrar
autoload Check_Par
autoload Enviar_A_Log

###############################################################################
###                            Principal                                    ###
###############################################################################
Check_Par 2 $@
[ $? != 0 ] && exit 1
  find ${PATHLOG} -name "${NOMBRE}.*.${ORACLE_SID}.log" -mtime +2 -exec rm {} \;
Enviar_A_Log "INICIO - Comienza la ejecucion del backup full." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
Enviar_A_Log "PROCESO - Depuracion filesystem ${PATHBKP}." ${LOGSCRIPT}
if [ -d ${PATHBKP} ] 
then
	if [ -s *${ORACLE_SID}* ]
	then
		rm ${PATHBKP}/*
	fi
else
	Enviar_A_Log "ERROR - Error al depurar filesystem ${PATHBKP}." ${LOGSCRIPT}
	Enviar_A_Log "FINALIZACION - CON ERROR." ${LOGSCRIPT}
	exit 6
fi
if [ -x ${ORACLE_HOME}/bin/rman ]
then
        if [ -r ${RMAN} ]
        then
                $ORACLE_HOME/bin/rman target / nocatalog @${RMAN} log=${LOGRMAN}
		RESUL=$?
                if [ $RESUL != 0 ]
                then
                          Enviar_A_Log "ERROR - Fallo la ejecucion del backup full." ${LOGSCRIPT}
                          Enviar_A_Log "FINALIZACION - CON ERROR WARNING (4)." ${LOGSCRIPT}
                          exit 4
		else
			grep 'ORA-' ${LOGRMAN}
			if [ $? != 0 ]
			then
				Enviar_A_Log "FINALIZACION - El backup de ${ORACLE_SID} termino OK." ${LOGSCRIPT}
				exit 0
			else
				
                          Enviar_A_Log "ERROR - Fallo la ejecucion del backup full." ${LOGSCRIPT}
                          Enviar_A_Log "FINALIZACION - CON ERROR WARNING (4)." ${LOGSCRIPT}
                          exit 4
			fi
                fi
        else
                Enviar_A_Log "ERROR - No hay permisos de lectura para el archivo ${RMAN}." ${LOGSCRIPT}
                Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                exit 77
        fi
else
        Enviar_A_Log "ERROR - No hay permisos de ejecucion para el comando rman." ${LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
        exit 88
fi
