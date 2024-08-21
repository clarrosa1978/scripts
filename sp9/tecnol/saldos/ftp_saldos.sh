#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: PROSEGUR                                               #
# Grupo..............: SALDOS                                                 #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Transferir via ftp un archivo de Prosegur              #
# Nombre del programa: ftp_saldos.sh                                          #
# Nombre del JOB.....:                                                        #
# Descripcion........:                                                        #
# Modificacion.......: 20/08/2021                                             #
###############################################################################


###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA="${1}"
export PATHORI="/saldos"
export DIRORI="prosegur/SaldosCertificados"
export ARCHORI="???_PR_RESCUENTA_${FECHA}.csv"
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
        echo "Utilizar ftp_saldos YYYYMMDD.\n"
        exit 1
fi
cd ${PATHORI}
if [ $? != 0 ]
then
	echo "No se pudo acceder a ${PATHORI}"
	exit 2
fi

> list.arch
if [ $? != 0 ]
then
	echo "No se pudo inicializar list.arch"
	exit 2
fi

echo "dir ${DIRORI}/${ARCHORI}" |ftp -p ${HOST} > list.arch
if [ ! -s list.arch ]
then
	echo "Sin archivos para procesar"
	exit 12
fi

set +x
echo "Lista de archivos a procesar: \n"
cat list.arch
set -x

LIST_FILES=`cat list.arch |awk '{print $9}'`
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
