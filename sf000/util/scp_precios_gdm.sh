#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: PRECIOS-GDM-TEST                                       #
# Grupo..............: TRANSFERENCIA                                          #  
# Autor..............: Gustavo Alonso                                         #
# Objetivo...........: COPIA NOVEDADES DE PRECIOS A TESTING                   #
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

export FECHA=$1
export ARCHIVO=$2
export SOURCE_DIR=$3
export TARGET_HOST="$4"
export TARGET_DIR="$5"

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
		echo "No hay archivos para transferiro con fecha ${FECHA}."
        	exit 4
	else

                for ARCH in ${SOURCE_FILE}
                do
                scp -pr ${SOURCE_DIR}/${ARCH} ${TARGET_HOST}:${TARGET_DIR}
                if [ $? = 0 ]
                then
                	for SUM in ${ARCH}
                        do
                        export CHECK_ARCH_ORI="$(sum ${SOURCE_DIR}/${SUM} | cut -d' ' -f1)"
                        export CHECK_ARCH_DES="$(ssh ${TARGET_HOST} "sum ${TARGET_DIR}/${SUM} | cut -d' ' -f1")"
                        if [ "$CHECK_ARCH_ORI" = "$CHECK_ARCH_DES" ];
                        then
                        	echo  "La copia se realizo con exito."
			else
                        	echo  "Verificar !!! el archivo ${SUM} no se copio correctamente."
                                exit 1
                        fi
                        done
                else
                	echo  "No termino de realizarse la copia, verificar!."
                        exit 1
                fi
                done
         fi
fi
