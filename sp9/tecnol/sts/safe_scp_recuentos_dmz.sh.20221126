#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: STS                                                    #
# Grupo..............: RECUENTOS                                              #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Transferir via scp un archivo de Prosegur desde DMZ    #
# Nombre del programa: safe_scp_recuentos_dmz.sh                              #
# Nombre del JOB.....:                                                        #
# Descripcion........:                                                        #
# Modificacion.......: 26/11/2022                                             #
###############################################################################


###############################################################################
###                            Variables                                    ###
###############################################################################
export SUC="$1"
export PATHORI="/sftp/prosegur/Prosegur"
export PATHDES="/recuentos"
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
        echo "Utilizar safe_scp_recuentos_dmz.sh NUMEROSUCURSAL.\n"
        exit 1
fi
cd ${PATHDES}
if [ $? != 0 ]
then
	echo "No se pudo acceder a ${PATHORI}"
	exit 2
fi

> list.${SUC}
if [ $? != 0 ]
then
	echo "No se pudo inicializar list.${SUC}"
	exit 2
fi

ssh -p 6090 ${SERVIDORDMZ} "cd ${PATHORI} ; ls ????r.${SUC}" > list.${SUC}
if [ ! -s list.${SUC} ]
then
	echo "Sin archivos para procesar"
	exit 1
fi

set +x
echo "Lista de archivos a procesar: \n"
cat list.${SUC}
set -x

LIST_FILES=`cat list.${SUC}'`

STATUS=1
for FILE in ${LIST_FILES}
do
	FILE_TMP=${FILE}_tmp
	if [ -f ${FILE} ]
	then
		mv -f ${FILE} ${FILE}.$$
	fi
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
	fi
	if [ -f ${FILE}.$$ ]
	then
		grep -v "GENERATION DATE:" ${FILE} > ${FILE_TMP}
		if [ $? != 0 ]
		then
			echo "Error generando ${FILE_TMP}"
			exit 2
		fi
		grep -v "GENERATION DATE:" ${FILE}.$$ > ${FILE_TMP}.$$
		if [ $? != 0 ]
		then
			echo "Error generando ${FILE_TMP}.$$"
			exit 2
		fi
		diff ${FILE_TMP} ${FILE_TMP}.$$
		if [ $? = 0 ]
		then
			rm -f ${FILE}.$$ ${FILE_TMP} ${FILE_TMP}.$$
		else
			echo "Se genero un nuevo archivo para una fecha pendiente de procesar."
			echo "El archivo anterior aun no habia sido transmitido a la sucursal."
			echo "Verificar con 'SOPORTE DE STS' cual es el archivo valido, y borrar el otro."
			ls -l ${FILE} ${FILE}.$$
			exit 2
		fi	
	fi	
	if [ ! -f procesados/${FILE} ]
	then
		STATUS=0
	else
		grep -v "GENERATION DATE:" ${FILE} > ${FILE_TMP}
		if [ $? != 0 ]
		then
			echo "Error generando ${FILE_TMP}"
			exit 2
		fi
		grep -v "GENERATION DATE:" procesados/${FILE} > procesados/${FILE_TMP}
		diff ${FILE_TMP} procesados/${FILE_TMP}
		if [ $? = 0 ]
		then
			rm -f ${FILE} 
		else
			STATUS=0
		fi	
		rm -f ${FILE_TMP} procesados/${FILE_TMP}
	fi	
	echo "Cambio formato del archivo"
	tr -d '\015' < ${FILE}.TMP > ${FILE}
	if [ $? != 0 ]
	then
		echo "Fallo la conversion del archivo ${FILE}.TMP - Avisar a la guardia Unix"
		exit 3
	fi
	rm -f ${FILE}.TMP
done
exit ${STATUS}
