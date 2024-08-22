#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: ALERTAS-SUC                                            #
# Grupo..............: UNIX                                                   #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Controla actualizacion ftp de camaras para IPAD.       #
# Nombre del programa: camaras_scan.sh                                        #
# Nombre del JOB.....: CTRLFTPIPAD                                            #
# Solicitado por.....: Administracion Unix                                    #
# Descripcion........:                                                        #
# Creacion...........: 04/11/2010                                             #
# Modificacion.......: DD/MM/AAAA                                             #
###############################################################################
set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA=${1}
export NOMBRE="camaras_scan"
export PATHAPL="/tecnol/alertas"
export PATHFTP="/jail/ftpcam"
export PATHSNAP="`ls -1 ${PATHFTP} | grep snap`"
export PATHLOG="${PATHAPL}/log"
export FILETMP="${PATHFTP}/ftpcam.tmp"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"
export DESTINATARIO="comunicaciones@redcoto.com.ar"
export SUC="`uname -n`"
export ASUNTO="Error en camaras Geovision para IPAD - ${SUC}"

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Check_Par
autoload Enviar_A_Log
autoload Borrar
function DetCam
{
   set -x
   typeset DIR1="`echo ${1} | sed 's/snap//'`"
   typeset SUC="`hostname | sed 's/suc//'`"
   export IPCAM="`echo $DIR1|awk '  { if ( substr($1,1,3) == 129 ) { print "129."'$SUC'".22."substr($1,length($0)-2,3) }; \
                                       if ( substr($1,1,2) == 10 ) { print "10."'$SUC'".103."substr($1,length($0)-2,3) }; }'`"
}
	
###############################################################################
###                            Principal                                    ###
###############################################################################
Check_Par 1 $@
[ $? != 0 ] && exit 1
Enviar_A_Log "INICIO - Comienza la ejecucion." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
find ${PATHLOG} -name "${NOMBRE}*.log" -mtime +5 -exec rm {} \;
service vsftpd status
if [ $? != 0 ]
then
	Enviar_A_Log "ERROR - El servicio ftp tiene problemas, se procede a reiniciar." ${LOGSCRIPT}
	service vsftpd restart
	if [ $? != 0 ]
	then
		Enviar_A_Log "ERROR - Fallo el reinicio del servicio ftp." ${LOGSCRIPT}
		export MENSAJE "Erro al reiniciar servicio ftp - Llamar a Guardia ADM UNIX."
		Enviar_Mail "$DESTINATARIO" "${ASUNTO}" "${MENSAJE}"
		exit 1
	else
		Enviar_A_Log "AVISO - El servicio ftp fue reiniciado con exito." ${LOGSCRIPT}
		sleep 60
	fi
fi
cd ${PATHFTP}
if [ $? != 0 ]
then
	Enviar_A_Log "ERROR - No se pudo acceder al directorio $PATHFTP" ${LOGSCRIPT}
	Enviar_A_Log "FIN  - Con ERRORES." ${LOGSCRIPT}
	exit 1
fi
Borrar ${FILETMP}
touch ${FILETMP}
sleep 120
if [ "${PATHSNAP}" ]
then
	for DIR in ${PATHSNAP}
	do
		CAM=""
		IPCAM=""
		DetCam $DIR
		find $DIR -name "*.jpg" -mtime +1 -exec rm {} \;
		FILEACT="`ls -1t $DIR | grep jpg | head -1`"
		FILEACTTMP="`ls -t $DIR | grep jpg | head -1`"
		if [ ${FILETMP} -nt ${DIR}/${FILEACT} ]
		then
			Enviar_A_Log "ERROR - El DVR ${IPCAM} no actualiza." ${LOGSCRIPT}
			Enviar_A_Log "FIN - Con ERRORES" ${LOGSCRIPT}
			export MENSAJE="Hace mas de 5 minutos que el DVR ${IPCAM} no actualiza."
			Enviar_Mail "$DESTINATARIO" "${ASUNTO}" "${MENSAJE}"
			continue
		fi
	done
else
	Enviar_A_Log "ERROR - No existe los directorios para hacer ftp." $LOGSCRIPT
	Enviar_A_Log "FIN - Con ERRORES" $LOGSCRIPT
	exit 1
fi