#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: BACKUP                                                 #
# Grupo..............: WF                                                     #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Levanta a cinta backup db WF009A y backups de Windows. #
# Nombre del programa: bkptar.sh                                              #
# Nombre del JOB.....: BKPTAR                                                 #
# Solicitado por.....: Cristian Larrosa                                       #
# Descripcion........:                                                        #
# Creacion...........: 10/03/2009                                             #
# Modificacion.......: 08/02/2011                                             #
###############################################################################
set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA=${1}
export NOMBRE="bkptar"
export PATHAPL="/tecnol/backups"
export PATHBKP="/backup"
export PATHBKPFS="./home ./u01 ./tecnol ./radio ./home/magic83 ./sts ./exports"
export PATHBKPWIN="Windows"
export PATHBKPJAS3="jas3"
export PATHBKPWFCC="wfcc"
export PATHBKPMIRAGE="mirage"
export PATHBKPPAMPA="pampa_boot"
export PATHLOG="${PATHAPL}/log"
export PATHSEC="${PATHAPL}/sec"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"
if [ `date +%a` = "Sun" ]
then
	export TAPE="/dev/rmt1"
else
	export TAPE="/dev/rmt0"
fi
export BS="1024"
export NEXT_SEQ="`ls -t ${PATHSEC} |tail -1`"
export LABEL="SECUENCIA_${NEXT_SEQ}"
export TARERR=/tmp/tarerr.log
export DESTINATARIO="adminaix@redcoto.com.ar,adminnt@redcoto.com.ar"
export ASUNTO="Errores en backups de NTSCD01"

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Borrar
autoload Check_Par
autoload Enviar_A_Log

###############################################################################
###                            Principal                                    ###
###############################################################################

#------------------------------------------------------------------------------
echo " Controles del script"
#------------------------------------------------------------------------------

Check_Par 1 $@
[ $? != 0 ] && exit 1
Enviar_A_Log "INICIO - Comienza la ejecucion del resguardo a cinta." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
Borrar ${TARERR}

#------------------------------------------------------------------------------
echo " Control de Secuencia de la cinta"
#------------------------------------------------------------------------------

[ "${NEXT_SEQ}" ] || exit 4
mt -f ${TAPE} rewind
if [ $? != 0 ]
then
	Enviar_A_Log "ERROR - La cinta con secuencia ${NEXT_SEQ} no esta puesta." ${LOGSCRIPT}
	Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
	exit 7
fi
ACT_SEQ="`dd if=${TAPE} ibs=${BS}k count=1 conv=noerror 2>/dev/null | awk ' { print $1 } ' |grep SECUENCIA_`"
if [ "${ACT_SEQ}" ]
then
	if [ "${ACT_SEQ}" != "${LABEL}" ]
	then
        	Enviar_A_Log "ERROR - Secuencia incorrecta. Cinta actual ${ACT_SEQ} corresponde ${LABEL}." ${LOGSCRIPT}
        	Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
        	exit 7
	fi
else
	Enviar_A_Log "ERROR - No se pudo obtener la secuencia del dia." ${LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
        exit 2
fi

#------------------------------------------------------------------------------
echo " Copiando a Cinta archivo de secuencia"
#------------------------------------------------------------------------------

>${PATHBKP}/${LABEL}


if [ $? != 0 ]
then
	Enviar_A_Log "ERROR - No se pudo inicializar la secuencia del dia." ${LOGSCRIPT}
	Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
	exit 3
fi
cd ${PATHBKP}
if [ $? != 0 ]
then
	Enviar_A_Log "ERROR - No se pudo cambiar al directorio ${PATHBKP}." ${LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
        exit 2
fi

mt rewind

tar -c -v -f ${TAPE}.1 ${LABEL} 1>${LOGSCRIPT} 2>${TARERR}
if [ -s ${TARERR} ]
then
	Enviar_A_Log "ERROR - Fallo el comando tar grabando la secuencia a cinta." ${LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
        exit 5
else
	Enviar_A_Log "PROCESO - Secuencia ${LABEL} grabada OK." ${LOGSCRIPT}
fi


#------------------------------------------------------------------------------
echo " Levantando a Cinta fs /backup"
#------------------------------------------------------------------------------

cd ${PATHBKP}

Enviar_A_Log "PROCESO - Comienza la copia a cinta." ${LOGSCRIPT}

tar -c -v -f ${TAPE}.1 *${FECHA} 1>>${LOGSCRIPT} 2>${TARERR}
if [ -s ${TARERR} ]
then
	Enviar_A_Log "ERROR - Fallo el comando tar grabando backup a cinta." ${LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
	exit 5
else
	Enviar_A_Log "AVISO - El backup de BD termino OK." ${LOGSCRIPT}
	rm ${PATHBKP}/*${FECHA}
	rm ${PATHBKP}/${LABEL}
	Borrar ${TARERR}

	Enviar_A_Log "PROCESO - Comienza backup a cinta de Filesystems." ${LOGSCRIPT}

#------------------------------------------------------------------------------
echo " Levantando a cinta ./home ./u01 ./tecnol ./radio ./home/magic83 ./sts ./exports"
#------------------------------------------------------------------------------

	cd /
	if [ $? != 0 ]
	then
        	Enviar_A_Log "ERROR - No se pudo cambiar al directorio /." ${LOGSCRIPT}
        	Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
        	exit 2
	fi

        tar -c -v -f ${TAPE}.1 ${PATHBKPFS} 1>>${LOGSCRIPT} 2>${TARERR}
        if [ -s ${TARERR} ]
        then
                Enviar_A_Log "ERROR - Fallo el comando tar grabando backup ${PATHBKPFS} a cinta." ${LOGSCRIPT}
                Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                Enviar_Mail_DAdjuntos "adminaix@redcoto.com.ar" "Errores en backups de Filesystems" "${TARERR}"
        else
                Enviar_A_Log "AVISO - El backup de Filesystems termino OK." ${LOGSCRIPT}
        fi

        Enviar_A_Log "PROCESO - Comienza backup a cinta de Jas3." ${LOGSCRIPT}

#------------------------------------------------------------------------------
echo " Levantando a cinta jas3"
#------------------------------------------------------------------------------
	cd ${PATHBKP}
        if [ $? != 0 ]
        then
                Enviar_A_Log "ERROR - No se pudo cambiar al directorio ${PATHBKP}." ${LOGSCRIPT}
                Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                exit 2
        fi

        tar -c -v -f ${TAPE}.1 ./${PATHBKPJAS3} 1>>${LOGSCRIPT} 2>${TARERR}
        if [ -s ${TARERR} ]
        then
                Enviar_A_Log "ERROR - Fallo el comando tar grabando backup ${PATHBKPJAS3} a cinta." ${LOGSCRIPT}
                Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                Enviar_Mail_DAdjuntos "adminaix@redcoto.com.ar" "Errores en backups de JAS3" "${TARERR}"
        else
                Enviar_A_Log "AVISO - El backup de Jas3 termino OK." ${LOGSCRIPT}
        fi

#------------------------------------------------------------------------------
echo " Levantando a cinta wfcc"
#------------------------------------------------------------------------------

        Enviar_A_Log "PROCESO - Comienza backup a cinta de Wfcc." ${LOGSCRIPT}
        tar -c -v -f ${TAPE}.1 ./${PATHBKPWFCC} 1>>${LOGSCRIPT} 2>${TARERR}
        if [ -s ${TARERR} ]
        then
                Enviar_A_Log "ERROR - Fallo el comando tar grabando backup ${PATHBKPWFCC} a cinta." ${LOGSCRIPT}
                Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                Enviar_Mail_DAdjuntos "adminaix@redcoto.com.ar" "Errores en backups de WFCC" "${TARERR}"
        else
                Enviar_A_Log "AVISO - El backup de Wfcc termino OK." ${LOGSCRIPT}
        fi

#------------------------------------------------------------------------------
echo "Levantando a cinta fs mirage"
#------------------------------------------------------------------------------

 	Enviar_A_Log "PROCESO - Comienza backup a cinta de Mirage." ${LOGSCRIPT}
        tar -c -v -f ${TAPE}.1 ./${PATHBKPMIRAGE} 1>>${LOGSCRIPT} 2>${TARERR}
        if [ -s ${TARERR} ]
        then
                Enviar_A_Log "ERROR - Fallo el comando tar grabando backup ${PATHBKPMIRAGE} a cinta." ${LOGSCRIPT}
                Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                Enviar_Mail_DAdjuntos "adminaix@redcoto.com.ar" "Errores en backups de MIRAGE" "${TARERR}"
        else
                Enviar_A_Log "AVISO - El backup de Mirage termino OK." ${LOGSCRIPT}
        fi

#------------------------------------------------------------------------------
echo "Levantando a cinta fs pampa_boot"
#------------------------------------------------------------------------------

        Enviar_A_Log "PROCESO - Comienza backup a cinta de Mirage." ${LOGSCRIPT}
        tar -c -v -f ${TAPE}.1 ./${PATHBKPPAMPA} 1>>${LOGSCRIPT} 2>${TARERR}
        if [ -s ${TARERR} ]
        then
                Enviar_A_Log "ERROR - Fallo el comando tar grabando backup ${PATHBKPPAMPA} a cinta." ${LOGSCRIPT}
                Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                Enviar_Mail_DAdjuntos "adminaix@redcoto.com.ar" "Errores en backups de PAMPA_BOOT" "${TARERR}"
        else
                Enviar_A_Log "AVISO - El backup de Pampa_boot termino OK." ${LOGSCRIPT}
        fi


#------------------------------------------------------------------------------
echo "Levantando a cinta fs wftest"
#------------------------------------------------------------------------------

        Enviar_A_Log "PROCESO - Comienza backup a cinta de Mirage." ${LOGSCRIPT}
        tar -c -v -f ${TAPE}.1 ./${PATHBKPWFTES} 1>>${LOGSCRIPT} 2>${TARERR}
        if [ -s ${TARERR} ]
        then
                Enviar_A_Log "ERROR - Fallo el comando tar grabando backup ${PATHBKPWFTEST} a cinta." ${LOGSCRIPT}
                Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                Enviar_Mail_DAdjuntos "adminaix@redcoto.com.ar" "Errores en backups de WFTEST" "${TARERR}"
        else
                Enviar_A_Log "AVISO - El backup de Wftest termino OK." ${LOGSCRIPT}
        fi

#------------------------------------------------------------------------------
echo " Levantando a cinta fs de windows"
#------------------------------------------------------------------------------

	Enviar_A_Log "PROCESO - Comienza backup a cinta de Windows." ${LOGSCRIPT}
	tar -c -v -f ${TAPE}.1 ./${PATHBKPWIN}  1>>${LOGSCRIPT} 2>${TARERR}
	if [ -s ${TARERR} ]
	then
	        Enviar_A_Log "ERROR - Fallo el comando tar grabando backup Windows a cinta." ${LOGSCRIPT}
        	Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
		Enviar_Mail_DAdjuntos "${DESTINATARIO}" "${ASUNTO}" "${TARERR}"
	else
		Enviar_A_Log "AVISO - El backup de Windows termino OK." ${LOGSCRIPT}
		Enviar_A_Log "FIN - FIN BACKUP SECUENCIA ${NEXT_SEQ} OK." ${LOGSCRIPT}
	fi

	rm ${PATHSEC}/${NEXT_SEQ}/*
	rm ${PATHBKP}/${LABEL}
	mv -f ${PATHLOG}/bkp*${FECHA}* ${PATHSEC}/${NEXT_SEQ}
	compress ${PATHSEC}/${NEXT_SEQ}/*${FECHA}*.log
	exit 0
fi
