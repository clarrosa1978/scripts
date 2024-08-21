#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: ftp_retiros.sh                                         #
# Grupo..............:                                                        #
# Autor..............: Cerizola Hugo                                          #
# Objetivo...........: Enviar via ftp el archivo de juncadella al site ftp    #
# Nombre del programa: ftp_retiros.sh                                         #
# Nombre del JOB.....: FTPRET-X                                               #
# Solicitado por.....:                                                        #
# Descripcion........:                                                        #
# Modificacion.......: 13/04/2008                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################

if [ $# -ne 3 ]
then
        #Usage $0 DATE SOURCE_HOST APLICATION_NAME PATH SUCURSAL
	echo "Error en la cantidad de parametros" 
        exit 14
else

export TARGET_HOST="${1}"
export SUC="${2}"
export DATE="${3}"

fi

##### Preparo la info del dia
export SUC_2D=""
export SUC_3D=""

SUC0="`echo $2 | cut -c1`"

if [ $SUC0 = 0 ]
then
SUC=`echo $2 | cut -c2,3`
else
SUC=${2}
fi

if [ $SUC -lt 100 ]
then
        SUC_3D="0${SUC}"
        SUC_2D="${SUC}"
else
        SUC_3D="${SUC}"
        SUC_2D="${SUC}"
fi

export DIR="/trntcierre/suc${SUC_2D}"
export APPATH="/ftpjunca/retiros"
export ARCH_RETI="${DATE}.${SUC_3D}"
export COMMAND_FILE="/tmp/ftpretiros.${SUC_3D}"

###############################################################################
###                            Controles                                    ###
###############################################################################

cd ${DIR}
if [ $? != 0 ]
then
        echo "No se pudo acceder a ${DIR} en el sp9"
        exit 2
fi
ls -lt ${ARCH_RETI} 1> /dev/null 2>/dev/null
if [ $? != 0 ]
then
        echo "El archivo ${ARCH_RETI} no se genero o se genero en cero"
        exit 2
fi

ping -c5 ${TARGET_HOST}
if [ $? != 0 ]
then
        echo "No responde el servidor ftp ${TARGET_HOST}"
        exit 2
fi


echo "cd ${APPATH}" > ${COMMAND_FILE}
echo "ascii" >> ${COMMAND_FILE}
echo "lcd ${DIR}" >> ${COMMAND_FILE}
echo "put ${ARCH_RETI}" >> ${COMMAND_FILE}
#echo "quit"  >> ${COMMAND_FILE}

if [ ! -s  ${COMMAND_FILE} ]
then
        echo "No se genero el archivo para procesar"
        exit 1
fi



#----------------------------------#
#          FUNCIONES               #
#----------------------------------#

function mostrar
{
echo "`date +%d/%m/%y-%T`:$1" >> $LOG
}

#----------------------------------#
#          FIN FUNCIONES           #
#----------------------------------#

LOG="${COMMAND_FILE}.log"
#COMMAND_FILE="${COMMAND_FILE}"	#File whith FTP commands

mostrar "Genero archivo de comandos del FTP" 
#------------------------------------------#

cd $DIR 2>/dev/null

/tecnol/bin/safe_ftp "$TARGET_HOST" "" "" "$COMMAND_FILE" "$APPATH"
STATUS="$?"
if [ "$STATUS" != 0 ]
then
	mostrar "Error en la transferencia de archivos"
	rm -f $COMMAND_FILE
	exit $STATUS
else
	mostrar "Fin transf. Archivos de $APLICATION OK" 
	rm -f $COMMAND_FILE
	rm -f $COMMAND_FILE.log
	exit 0
fi
