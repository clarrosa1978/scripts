#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: INTERFASE-CHQ-STS                                      #
# Grupo..............: TR-CHQ-STS                                             #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: COPIA INTERFASE DE CHEQUES a sucXXX:/sts               #
# Nombre del programa: safe_scp_cheques_sts.sh                                #
# Nombre del JOB.....: TRCHQXXX                                               #
# Solicitado por.....:                                                        #
# Descripcion........:                                                        #
# Creacion...........: 14/07/2004                                             #
# Modificacion.......: 02/06/2016                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA=`date '+%Y%m%d'`
#export FECHA=$1
export YESTERDAY=`TZ=aaa24 date +%Y%m%d`
export ACTION=G
export SOURCE_DIR="/sfctrl/data/descarga"
export SOURCE_DIR2="/sfctrl/data/procesados"
export TARGET_HOST="sp9"
export TARGET_DIR="/provisorio"

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Borrar
autoload Check_Par
autoload Enviar_A_Log


###############################################################################
###                            Principal                                    ###
###############################################################################
#Check_Par 1 $@
#[ $? != 0 ] && exit 1

cd ${SOURCE_DIR2}
if [ $? != 0 ]
then
        echo "No se pudo acceder a ${SOURCE_DIR2}"
        exit 2
fi

SOURCE_FILE3="`ls -rt GM03250_${FECHA}*_U.Z`"
if [ ! "${SOURCE_FILE3}" ]
then
        echo "No hay archivos para transferir en el directorio ${SOURCE_DIR2} con fecha ${FECHA}."
        exit 1
fi


TARGET_FILE3="${SOURCE_FILE3}"
OWNER=root
GROUP=system
MASK=640

/tecnol/util/safe_scp ${ACTION} ${SOURCE_DIR2} ${SOURCE_FILE3} ${TARGET_HOST} ${TARGET_DIR} ${TARGET_FILE3} NULL NULL 1 1 NULL ${OWNER} ${GROUP} ${MASK}

STATUS=$?

if [ ${STATUS} != 0 ]
then
        echo "Error en transferecia: ${STATUS}"
        exit 2
fi

#mv -f ${SOURCE_FILE} procesados/${SOURCE_FILE}
#find ${SOURCE_DIR}/procesados -name "CHEQUES.${SUC}.????????_??????.DAT" -mtime +30 -exec rm {} \;
