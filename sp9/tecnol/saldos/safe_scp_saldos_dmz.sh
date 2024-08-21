#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: PROSEGUR                                               #
# Grupo..............: SALDOS                                                 #
# Autor..............: Gustavo Alonso                                         #
# Objetivo...........: Transferir via scp un archivo de Prosegur desde DMZ    #
# Nombre del programa: safe_scp_saldos_dmz.sh                                 #
# Nombre del JOB.....:                                                        #
# Descripcion........:                                                        #
# Modificacion.......: 28/11/2022                                             #
###############################################################################
set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA="${1}"
export PATHORI="/sftp/prosegur/Prosegur/SaldosCertificados"
export PATHDES="/saldos"
export ARCHORI="???_PR_RESCUENTA_${FECHA}.csv"
export SERVIDORDMZ="sdmz02"

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Check_Par
autoload Enviar_A_Log

###############################################################################
###                            Principal                                    ###
###############################################################################
set -x
Check_Par 1 $@
if [ $? != 0 ] 
then
        echo "Error en la cantidad de parametro.\n"
        echo "Utilizar safe_scp_recuentos_dmz.sh  YYYYMMDD.\n"
        exit 1
fi
cd ${PATHDES}
##cd ${PATHORI}
if [ $? != 0 ]
then
	echo "No se pudo acceder a ${PATHORI}"
	exit 2
fi

> list.arch
if [ $? != 0 ]
then
	echo "No se pudo inicializar list.${SUC}"
	exit 2
fi

ssh -p 6090 ${SERVIDORDMZ} "cd ${PATHORI} ; ls ${ARCHORI}" > list.arch
if [ ! -s list.arch ]
then
	echo "Sin archivos para procesar"
	exit 1
fi

set +x
echo "Lista de archivos a procesar: \n"
cat list.arch
set -x

LIST_FILES=`cat 'list.arch'`

STATUS=1
for FILE in ${LIST_FILES}
do
	echo "Transfiero archivo desde dmz02:${PATHORI} a sp9:${PATHDEST}"
	scp -P 6090 ${SERVIDORDMZ}:${PATHORI}/${FILE} ./${FILE}.TMP
	if [ ! -f ${FILE}.TMP ]
	then
		echo "No se pudo copiar ${PATHORI}/${FILE} desde ${SERVIDORDMZ}"
		exit 2
	fi
	echo "Muevo el archivo a procesados en DMZ"
	ssh -p 6090 sdmz02 "mv ${PATHORI}/${FILE} ${PATHORI}/procesados/${FILE}.trf"
	if [ $? != 0 ]
	then
		echo "No se pudo mover ${FILE} a ${SERVIDORDMZ}:/${PATHORI}/procesados"
	else
		echo "Se pudo mover ${FILE} a ${SERVIDORDMZ}:/${PATHORI}/procesados"
	fi
        mv -f ${PATHDES}/${FILE}.TMP ${PATHDES}/${FILE}
        STATUS=0
done
find ${PATHDES} -name "???_PR_RESCUENTA_*.csv" -mtime +7 -exec gzip {} \;
exit ${STATUS}
