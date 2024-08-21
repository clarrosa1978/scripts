#!/usr/bin/ksh
#set -x
###############################################################################
# Aplicacion.........:                                                        #
# Grupo..............:                      			              #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: 						              #
# Nombre del programa:                                                        #
# Nombre del JOB.....:                                                        #
# Descripcion........:                                                        #
# Modificacion.......: 30/03/2006                                             #
###############################################################################


###############################################################################
###                            Variables                                    ###
###############################################################################

export FECHA=`date +%Y%m%d`
export NOMBRE="chk_espacio_suc"
export DESTINATARIO="adminaix@coto.com.ar"
export PATHAPL="/home/clarrosa"
export PATHLOG="${PATHAPL}"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"
export SERVAPL="pucara amscentral sp17 nodo9 sap1 sap2 psp1 S80-FNCL ctefte escala1"

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Borrar


###############################################################################
###                            Principal                                    ###
###############################################################################
Borrar ${LOGSCRIPT}
echo "Reporte de filesystems en sucursales RHEL - `date +%d"/"%m"/"%Y`" | tee ${LOGSCRIPT}
echo "=================================================" | tee -a ${LOGSCRIPT}
for i in $LISTALNX
do
        ESTADO=`sudo ssh suc${i} df -k | grep % | grep -v Available | grep -v "/dev/shm" | grep -v "/boot" | grep -v "/u01" | grep -v "/u02"  |\
                 awk ' BEGIN { percent = 0 }
                             { pos = index( $4, "%" )
                               percent = substr( $4, 1, ( pos - 1 ) )
                               if ( percent > 95 ) { print }
                             }'`
        if [ "${ESTADO}" ]
        then
                echo "Equipo: Suc$i"    | tee -a ${LOGSCRIPT}
                echo "=============" | tee -a ${LOGSCRIPT}
                echo "${ESTADO}" | tee -a ${LOGSCRIPT}
                echo | tee -a ${LOGSCRIPT}
        fi
done

echo "Reporte de filesystems en sucursales AIX - `date +%d"/"%m"/"%Y`" | tee -a ${LOGSCRIPT}
echo "=================================================" | tee -a ${LOGSCRIPT}
for i in $LISTASUC 
do
	ESTADO=`sudo rsh suc${i} df -k | grep -v "dbfs_" | grep -v "/oradata/816/GM" |\
		 awk ' BEGIN { percent = 0 }
		             { pos = index( $4, "%" ) 
			       percent = substr( $4, 1, ( pos - 1 ) )
			       if ( percent > 95 ) { print } 
		             }'`
	if [ "${ESTADO}" ]
	then
	        echo "Equipo: Suc$i"    | tee -a ${LOGSCRIPT}
        	echo "=============" | tee -a ${LOGSCRIPT}
		echo "${ESTADO}" | tee -a ${LOGSCRIPT}
        	echo | tee -a ${LOGSCRIPT}
	fi
done

echo "Reporte de filesystems en Central - `date +%d"/"%m"/"%Y`" | tee -a ${LOGSCRIPT}
echo "===========================================" | tee -a ${LOGSCRIPT}
for i in $SERVAPL
do
	ESTADO=`rsh ${i} df -k | grep -v oradata | grep -v sapdata | grep -v FIN8 | grep -v dbfs | \
		awk ' BEGIN { percent = 0 }
                             { pos = index( $4, "%" )
                               percent = substr( $4, 1, ( pos - 1 ) )
                               if ( percent > 95 ) { print }
                             }'`
	if [ "${ESTADO}" ]
	then
	        echo "Equipo: $i"       | tee -a ${LOGSCRIPT}
        	echo "=============" | tee -a ${LOGSCRIPT}
		echo "${ESTADO}" | tee -a ${LOGSCRIPT}
        	echo | tee -a ${LOGSCRIPT}
	fi
done
cat ${LOGSCRIPT} | mail -s "Reporte de filesystems" ${DESTINATARIO}
