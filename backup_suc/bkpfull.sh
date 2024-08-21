#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: BACKUP                                                 #
# Grupo..............: DATABASE                                               #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Realiza un rman de la base de SF.                      #
# Nombre del programa: bkpfull.sh                                             #
# Nombre del JOB.....: BKPSFXXX                                               #
# Solicitado por.....: Cristian Larrosa                                       #
# Descripcion........:                                                        #
# Creacion...........: 30/06/2009                                             #
# Modificacion.......: DD/MM/AAAA                                             #
###############################################################################

#set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA=${1}
export NOMBRE="bkpfull"
export PATHAPL="/tecnol/backup"
export PATHLOG="${PATHAPL}/log"
export PATHRMAN="/rman"
export ARCHRMAN="${PATHRMAN}/${NOMBRE}.${FECHA}.tar.Z"
export RMAN="${PATHAPL}/bkpfull.rmn"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"
export LOGRMAN="${PATHRMAN}/${NOMBRE}.${FECHA}.log"

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Borrar
autoload Check_Par
autoload Enviar_A_Log


###############################################################################
###                            Principal                                    ###
###############################################################################
Check_Par 1 $@
[ $? != 0 ] && exit 1
Enviar_A_Log "INICIO - Comienza la ejecucion del backup full." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
Enviar_A_Log "PROCESO - Borrando backups anteriores." ${LOGSCRIPT}
rm -f ${PATHRMAN}/cf* ${PATHRMAN}/al* ${PATHRMAN}/df* ${PATHRMAN}/sp*
gzip -f ${PATHRMAN}/*.log
if [ -x ${ORACLE_HOME}/bin/rman ]
then
	if [ -r ${RMAN} ]
	then
		$ORACLE_HOME/bin/rman target / nocatalog @${RMAN} log=${LOGRMAN}
		if [ $? != 0 ]
                then
                        Enviar_A_Log "ERROR - Fallo la ejecucion del backup full." ${LOGSCRIPT}
                        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
			cat ${LOGRMAN}
                        exit 5
		else
			Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
  				find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +7 -exec rm {} \;
  			        find ${PATHRMAN} -name "${NOMBRE}.*.log.gz" -mtime +7 -exec rm {} \;
                                exit 0
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

