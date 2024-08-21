#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: BACKUP                                                 #
# Grupo..............: DATABASE                                               #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Realiza export de la base de datos de SF.              #
# Nombre del programa: expantca.sh                                            #
# Nombre del JOB.....: EXPANTCA                                               #
# Descripcion........:                                                        #
# Modificacion.......: 10/12/2012 Se modifica para que el nombre del export   #
#                      tenga el dia y la hora.                                #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################

FECHA=${1}
HORA=${2}
NOMBRE="expantca"
PATHAPL="/expora"
PATHLOG="/tecnol/ntcierre/log"
LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.${HORA}.log"
ARCHDMP="${PATHAPL}/${NOMBRE}.${FECHA}.${HORA}.dmp"
ARCHFIFO="${PATHAPL}/fifo.dmp"
LOGDMP="${ARCHDMP}.log"

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Enviar_A_Log
autoload Check_Par
autoload Borrar

###############################################################################
###                            Principal                                    ###
###############################################################################
Check_Par 2 $@
[ $? != 0 ] && exit 1
Enviar_A_Log "INICIO - Comienza la ejecucion." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
Borrar ${LOGDMP}
find ${PATHAPL} -name "${NOMBRE}.*.${HORA}.dmp.bzip2" -exec rm {} \;
find ${PATHAPL} -name "${NOMBRE}.*.${HORA}.dmp.log" -exec rm {} \;
if [ -x ${ORACLE_HOME}/bin/exp ]
then
	if [ -f ${ARCHFIFO} ]
	then
		rm -f ${ARCHFIFO}
	fi
        mknod ${ARCHFIFO} p
        chmod +rw ${ARCHFIFO}
        chown oracle.dba ${ARCHFIFO}
        nohup cat ${ARCHFIFO} | bzip2 > ${ARCHDMP}.bzip2 &
	exp userid=/ log=${LOGDMP} file=${ARCHFIFO} buffer=16777216 full=y consistent=y statistics=none direct=y
	if [ $? != 0 ]
	then
		 Enviar_A_Log "ERROR - Fallo la ejecucion del export." ${LOGSCRIPT}
                 Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                 exit 5
	else
		if [ -s ${LOGDMP} ]
		then
			grep "ORA-" ${LOGDMP}
			if [ $? = 0 ]
                        then
                                Enviar_A_Log "ERROR - Export ${ARCHDMP} generado con errores." ${LOGSCRIPT}
                                Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                                exit 1
                        else
				grep "Export terminated successfully without warnings" ${LOGDMP}
                        	if [ $? = 0 ]  
                        	then
					Enviar_A_Log "AVISO - Export ${ARCHDMP} generado OK." ${LOGSCRIPT}
                        		Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
                                	exit 0
                        	else
					grep "Export terminated successfully with warnings" ${LOGDMP}
					if [ $? = 0 ]
                        		then
                                		Enviar_A_Log "AVISO - Export ${ARCHDMP} generado OK." ${LOGSCRIPT}
                                		Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
                                		exit 0
					else
			 			Enviar_A_Log "ERROR - Error de Oracle durante la ejecucion." ${LOGSCRIPT}
                                		Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                                		exit 7
					fi
                        	fi
			fi
		else
			Enviar_A_Log "ERROR - No se genero el archivo de log del export" ${LOGSCRIPT}
                        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                        exit 9
		fi
	fi
else
        Enviar_A_Log "ERROR - No hay permisos de ejecucion para el comando exp." ${LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
        exit 88
fi
