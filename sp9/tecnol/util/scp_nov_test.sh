#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: PRECIOS-GDM-TEST                                       #
# Grupo..............: TRANSFERENCIA                                          #   
# Autor..............: Gustavo Alonso                                         #
# Objetivo...........: COPIA NOVEDADES DE PRECIOS A TESTING                   #
# Nombre del programa: scp_nov_test.sh                                        #
# Nombre del JOB.....: SCPNOVXXX                                              #
# Solicitado por.....:                                                        #
# Descripcion........:                                                        #
# Creacion...........: 24/07/2018                                             #
# Modificacion.......: 24/07/2018                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################

export ARCHIVO=$1
export SOURCE_DIR=$2
export TARGET_HOST=$3
export TARGET_HOST2=$4
export TARGET_DIR=$5

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Borrar
autoload Check_Par
autoload Enviar_A_Log

###############################################################################
###                            Principal                                    ###
###############################################################################
Check_Par 5 $@
if [ $? != 0 ]
then
        echo "Falta ingresar uno o mas parametros de ejecucion."
        exit 1
fi

cd ${SOURCE_DIR}
if [ $? != 0 ]
then
        echo "No se pudo acceder al directorio ${SOURCE_DIR}"
        else
        SOURCE_FILE="`ls -rt ${ARCHIVO}`"
        if [ ! "${SOURCE_FILE}" ]
        then
                echo "No hay archivos para transferir."
                exit 4
        else
		for ARCH in ${SOURCE_FILE}
		do
		ssh ${TARGET_HOST} "ls -rt ${TARGET_DIR}/${ARCH}"
		if [ $? != 0 ]
		then
			scp -pr ${SOURCE_DIR}/${ARCH} ${TARGET_HOST}:${TARGET_DIR}
                	if [ $? = 0 ]
                	then
                        	export CHECK_ARCH_ORI="$(sum ${SOURCE_DIR}/${ARCH} | cut -d' ' -f1)"
                        	export CHECK_ARCH_DES="$(ssh ${TARGET_HOST} "sum ${TARGET_DIR}/${ARCH} | cut -d' ' -f1")"
                        	if [ "$CHECK_ARCH_ORI" = "$CHECK_ARCH_DES" ];
                        	then
                                	echo  "La copia se realizo con exito."
                        	else
                                	echo  "Verificar !!! el archivo ${ARCH} no se copio correctamente."
                                	exit 1
                        	fi
                	else
                        	echo  "No termino de realizarse la copia al servidor ${TARGET_HOST}, verificar!."
                        	exit 1
                	fi
		else
                        echo "El archivo ya existe en el server ${TARGET_HOST}"

		fi
		done

		for ARCH in ${SOURCE_FILE}
		do
		ssh ${TARGET_HOST2} "ls -rt ${TARGET_DIR}/${ARCH}"
		if [ $? != 0 ]
		then
                	scp -pr ${SOURCE_DIR}/${ARCH} ${TARGET_HOST2}:${TARGET_DIR}
                	if [ $? = 0 ]
                	then
                        	export CHECK_ARCH_ORI="$(sum ${SOURCE_DIR}/${ARCH} | cut -d' ' -f1)"
                        	export CHECK_ARCH_DES="$(ssh ${TARGET_HOST2} "sum ${TARGET_DIR}/${ARCH} | cut -d' ' -f1")"
                        	if [ "$CHECK_ARCH_ORI" = "$CHECK_ARCH_DES" ];
                        	then
                                	echo  "La copia se realizo con exito."
                        	else
                                	echo  "Verificar !!! el archivo ${ARCHIVO} no se copio correctamente."
                                	exit 1
                        	fi
                	else
                        	echo  "No termino de realizarse la copia al servidor ${TARGET_HOST2}, verificar!."
                        	exit 1
                	fi
		else
			echo "El archivo ya existe en el server ${TARGET_HOST2}"
		fi
		done
		echo "" 
		echo "Muevo los archivos ya tranferidos a procesados"
		echo ""
		ssh ${TARGET_HOST} "sudo chown sfctrl.sfsw ${TARGET_DIR}/${ARCHIVO} ; sudo find ${TARGET_DIR} -name "GM03250_*" -mtime +30 -exec rm -f {} \;"
		ssh ${TARGET_HOST2} "sudo chown sfctrl.sfsw ${TARGET_DIR}/${ARCHIVO} ; sudo find ${TARGET_DIR} -name "GM03250_*" -mtime +30 -exec rm -f {} \;"
		sudo mv -f ${SOURCE_DIR}/${ARCHIVO} ${SOURCE_DIR}/procesados
		sudo find ${SOURCE_DIR}/procesados -name "GM03250_*" -mtime +30 -exec rm -f {} \;
         fi
fi

