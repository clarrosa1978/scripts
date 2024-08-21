#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: DOLIBARR                                               #
# Grupo..............: BACKUP                                                 #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Realiza ftp hacia sdmz01 para bajar export de mysql.   #
# Nombre del programa: ftp_dolibarr.sh                                        #
# Nombre del JOB.....: FTPDOLIBARR                                            #
# Solicitado por.....: Cristian Larrosa                                       #
# Descripcion........:                                                        #
# Modificacion.......: 28/03/2019                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA="${1}"
export NOMBRE="ftp_dolibarr"
export PATHAPL="/tecnol/dolibarr"
export PATHLOG="${PATHAPL}/log"
export LOG="${PATHLOG}/${NOMBRE}.${FECHA}.log"
export HOST=10.100.100.65
export PORT=6191
export LOCALDIR=/jail/dolibarr/out
export ARCHIVO="bck_${FECHA}"

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
Enviar_A_Log "INICIO - Comienza ftp Dolibarr." ${LOG}
[ $? != 0 ] && exit 3
Borrar ${LOG}
rm -f ${LOCALDIR}/bck*
ftp -s ${HOST} ${PORT} <<EOF 1>>${LOG}
bin
passive
prompt
lcd ${LOCALDIR}
cd in
mget "${ARCHIVO}*_*.sql"
EOF
if [ -s ${LOG} ]
then
        grep "can't find list of remote files" $LOG
        if [ $? = 0 ]
        then
                Enviar_A_Log "ERROR - No se encontro el archivo ${ARCHIVO} en el sitio ftp." ${LOG}
                Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOG}
                exit 1
        else
                ESTA="`ls -1 ${LOCALDIR}/${ARCHIVO}* | tail -1`"
                if [ "${ESTA}" ]
                then
			mv "${ESTA}" ${LOCALDIR}/${ARCHIVO}.sql
			chown dolibarr.staff ${LOCALDIR}/${ARCHIVO}.sql
                        Enviar_A_Log "PROCESO - El archivo ${LOCALDIR}/${ARCHIVO} se comprobo bien." ${LOG}
                        Enviar_A_Log "FIN - Finalizacion OK." ${LOG}
                        exit 0
                else
                        Enviar_A_Log "ERROR - No se encontro el archivo ${ARCHIVO} en el sitio ftp." ${LOG}
                        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOG}
                        exit 1
                fi
        fi
else
        Enviar_A_Log "ERROR - No se genere el archivo log ${LOG}." ${LOG}
        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOG}
        exit 1
fi
