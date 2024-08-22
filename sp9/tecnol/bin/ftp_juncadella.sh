#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: JUNCADELLA                                             #
# Autor..............: TECNOLOGIA (C.A.S)                                     #
# Objetivo...........: Obtener los archivos de juncadella del FTP Server      #
# Nombre del programa: junca_ftp.sh                                           #
# Descripcion........: Transmitido el archivo al sp17 envia mail de OK, si el #
#                      job termino con ON CONDITIONS igual a 0                #
#
# Nueva version, que copia todos los archivos de la sucursal en proceso,
# independientemente de la fecha. Los archivos procesados, se copian al
# directorio /ftpjunca/procesados en el servidor de origen, y se borran de
# /ftpjunca
# Tambien verifica si ya se procesaron archivos para una sucursal/fecha. En
# ese caso, si el archivo es igual, lo descarta, y si es diferente, continua
# el proceso normal.
#
# Cesar Lopez  -  14/09/2004
#
###############################################################################
#
# Se modifico para que la verificacion de eventuales archivos ya procesados
# no incluya las cabeceras de los mismos. Solo se verifican los registros de
# datos.
#
# Cesar Lopez  -  18/11/2004
#
###############################################################################
#
# Se modifico para que verifique la cabecera del archivo, pero que no tenga en
# cuenta el registro que informa la fecha y hora de generacion, cuyo contenido
# es similar a:
#
#
# GENERATION DATE: 20041125 12:03:58
#
#
#
# Cesar Lopez  -  01/12/2004
#
###############################################################################
set -x

if [ $# -ne 1 ]
then
	echo "Error en cantidad de parametros"
	exit 2
fi

SUC=${1}

HOST=juncadella_ftp_site

cd /sfctrl/sts/trf
if [ $? != 0 ]
then
	echo "No se pudo acceder a /sfctrl/sts/trf"
	exit 2
fi

ping -c5 ${HOST}
if [ $? != 0 ]
then
	echo "No responde el servidor ${HOST}"
	exit 2
fi

> list.${SUC}
if [ $? != 0 ]
then
	echo "No se pudo inicializar list.${SUC}"
	exit 2
fi

echo "dir ftpjunca/????r.${SUC}" |ftp ${HOST} > list.${SUC}
if [ ! -s list.${SUC} ]
then
	echo "Sin archivos para procesar"
	exit 1
fi

set +x
echo "Lista de archivos a procesar: \n"
cat list.${SUC}
set -x

LIST_FILES=`cat list.${SUC} |awk '{print $4}'`

STATUS=1
for FILE in ${LIST_FILES}
do
	FILE_TMP=${FILE}_tmp
	if [ -f ${FILE} ]
	then
		mv -f ${FILE} ${FILE}.$$
	fi
	echo "get ftpjunca/${FILE} ${FILE}" |ftp -v ${HOST}
	if [ ! -f ${FILE} ]
	then
		echo "No se pudo copiar ftpjunca/${FILE} de ${HOST}"
		exit 2
	fi
	echo "delete ftpjunca/${FILE}" |ftp -v ${HOST} |grep ^550
	if [ $? = 0 ]
	then
		echo "Archivo ${HOST}:/ftpjunca/${FILE} tomado. No se pudo borrar."
	fi
	echo "put ${FILE} ftpjunca/procesados/${FILE}.trf" |ftp -v ${HOST} |grep ^226
	if [ $? != 0 ]
	then
		echo "No se pudo copiar ${FILE} a ${HOST}:/ftpjunca/procesados"
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
done

exit ${STATUS}


