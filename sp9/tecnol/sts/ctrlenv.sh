set -x
export FECHA=${1}
export FECHAANT=${2}
export HORA="`date +%H%M`"
export NOMBRE="ctrlenv"
export PATHAPL="/tecnol/juncadella"
export PATHLOG="${PATHAPL}/log"
export ARCHTMPACT="${PATHLOG}/ctrlenv1.${FECHA}.${HORA}.tmp"
export ARCHTMPACTPROC="${PATHLOG}/ctrlenv2.${FECHA}.${HORA}.tmp"
export ARCHTMPANT="${PATHLOG}/ctrlenv3.${FECHAANT}.${HORA}.tmp"
export ARCHTMPANTPROC="${PATHLOG}/ctrlenv4.${FECHAANT}.${HORA}.tmp"
export ARCHNOT="${PATHLOG}/ctrlnot.${FECHA}.${HORA}.tmp"
export SITE=juncadella_ftp_site
export PATHFTP="ftpjunca"
export PATHFTPPROC="${PATHFTP}/procesados"
export ARCHIVO="${FECHA}r"
export ARCHIVO2="${FECHAANT}r"
export DIA="`date +%u`"
export LISTADOM="${PATHAPL}/listadom"
export LISTAPROV="${PATHAPL}/listaprov"


Check_Par 2 $@
[ $? != 0 ] && exit 1
Borrar ${ARCHNOT}
echo "dir ${PATHFTPPROC}/${ARCHIVO}.???.trf" | ftp ${SITE} > ${ARCHTMPACTPROC}
echo "dir ${PATHFTPPROC}/${ARCHIVO2}.???.trf" | ftp ${SITE} > ${ARCHTMPANTPROC}
echo "dir ${PATHFTP}/${ARCHIVO}.???" | ftp ${SITE} > ${ARCHTMPACT}
echo "dir ${PATHFTP}/${ARCHIVO2}.???" | ftp ${SITE} > ${ARCHTMPANT}
if [ -f ${ARCHTMPACT} ] && [ -f ${ARCHTMPANT} ] && [ -f ${ARCHTMPACTPROC} ] && [ -f ${ARCHTMPANTPROC} ]
then
	for i in `echo $LISTALNX | sed 's/250//'`
	do
		ESTA=""
		ESTA="`egrep ^$i$ ${LISTADOM}`"
		ESTA2="`egrep ^$i$ ${LISTAPROV}`"
		if [ ${DIA} = 2 ] && [ $i = 177 ]	#La sucursal 177 no abre los Lunes
		then
			continue
		fi
		if [ ${DIA} = 1 ] && [ ${ESTA} ] 
		then
			continue
		else
			if [ $i -lt 100 ]
			then
				SUC=0$i
			else
				SUC=$i
			fi
			if [ ${ESTA2} ]
			then
				grep "${ARCHIVO2}.${SUC}.trf" ${ARCHTMPANTPROC}
				if [ $? != 0 ]
				then
					grep "${ARCHIVO2}.${SUC}" ${ARCHTMPANT}
					if [ $? != 0 ]
					then
						echo "suc$SUC" >> ${ARCHNOT}
					fi
				fi	
			else
				grep "${ARCHIVO}.${SUC}.trf" ${ARCHTMPACTPROC}
                        	if [ $? != 0 ]
                        	then
					grep "${ARCHIVO}.${SUC}" ${ARCHTMPACT}
					if [ $? != 0 ]
					then
						echo "suc$SUC" >> ${ARCHNOT}
					fi
				fi      
			fi
		fi
	done
else
	echo "Error al buscar archivos en el sitio ${SITE}."
	exit 1
fi
if [ -s ${ARCHNOT} ]
then
	echo "Tener en cuenta que si aparecen las sucursal 49,69 o 178 son con fecha ${FECHAANT}." >> ${ARCHNOT}
else
	echo "No hay archivos pendientes." >> ${ARCHNOT}
fi

Enviar_Mail JUNCADELLA "Archivos faltantes de COTO - ${FECHA}" "`cat ${ARCHNOT}`"
find ${PATHAPL} -name "*.tmp" -mtime +7 -exec rm {} \;
