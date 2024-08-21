#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: STS                                                    #
# Grupo..............: RECUENTOS                                              #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Transferir via ftp un archivo de Prosegur              #
# Nombre del programa: ftp_prosegur.sh                                        #
# Nombre del JOB.....:                                                        #
# Descripcion........:                                                        #
# Modificacion.......: 27/02/2020                                             #
###############################################################################


###############################################################################
###                            Variables                                    ###
###############################################################################
export SUC="$1"
export PATHORI="/recuentos"
export DIRORI="prosegur"
export HOST="ftp_prosegur"

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
        echo "Utilizar ftp_prosegur.sh Operacion Server PathOrigen ArchiveOrigen PathDestino ArchivoDestino.\n"
        exit 1
fi
cd ${PATHORI}
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

echo "dir Prosegur/????r.${SUC}" |ftp -p ${HOST} > list.${SUC}
if [ ! -s list.${SUC} ]
then
	echo "Sin archivos para procesar"
	exit 1
fi

set +x
echo "Lista de archivos a procesar: \n"
cat list.${SUC}
set -x

LIST_FILES=`cat list.${SUC} |awk '{print $9}'`

STATUS=1
for FILE in ${LIST_FILES}
do
	FILE_TMP=${FILE}_tmp
	if [ -f ${FILE} ]
	then
		mv -f ${FILE} ${FILE}.$$
	fi
	echo "get ${DIRORI}/${FILE} ${FILE}" |ftp -p -v ${HOST}
	if [ ! -f ${FILE} ]
	then
		echo "No se pudo copiar ${DIRORI}/${FILE} de ${HOST}"
		exit 2
	fi
	echo "delete ${DIRORI}/${FILE}" |ftp -p -v ${HOST} |grep ^550
	if [ $? = 0 ]
	then
		echo "Archivo ${HOST}:/${DIRORI}/${FILE} tomado. No se pudo borrar."
	fi
	echo "put ${FILE} ${DIRORI}/procesados/${FILE}.trf" |ftp -p -v ${HOST} |grep ^226
	if [ $? != 0 ]
	then
		echo "No se pudo copiar ${FILE} a ${HOST}:/${DIRORI}/procesados"
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
