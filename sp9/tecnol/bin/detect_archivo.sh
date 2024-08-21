#!/bin/sh

###########################################################################
#Autor: Modificado Por Silvia Maccione 
#Programa: detect_archivo
###########################################################################


set_vars()
{

        set -x

        # Setea algunas var. de uso gral.

        WORK_DIR="$2"
        RAW_DIR="$WORK_DIR"
        LOG_DIR="/tecnol/bin/log"
        BACKUP_DIR="$WORK_DIR/backup"
        RETURN_CODE=''
	ARCH_NOM="$3"
	DATE="$1"

        export WORK_DIR LOG_DIR BACKUP_DIR RETURN_CODE

        return 0

}


rawLN_exist()
{

          set -x

          #Chequea la existencia de un archivo en un directorio dado 



export VALIDA=`find ${WORK_DIR} -type f -name $ARCH_NOM`
if [ "$VALIDA" == "" ]
then
          ABBORT_MESSAGE="$ABBORT_MESSAGE - ""`date +"%d/%m/%Y"` $0: No se ha detectado la presencia del archivo $ARCH_NOM"
          return 10
else
          return 0
fi

}


terminate()
{

      set -x

      # Argumentos pasados a esta funcion
      # $1: Exit Code
      # $2: Mensaje de diagnostico de error

      if [ "$1" -ne 10 ]
      then
              echo "$2"|tee -a "$LOG_DIR"/errlog
      fi

      exit "$1"
}

##############################   MAIN PROGRAM   ###########################

set -x

RETURN_VALUE=''
ABBORT_MESSAGE=''
SUCCESS="0"
export RETURN_VALUE SUCCESS ABBORT_MESSAGE

# Parametros pasados al script

[ "$RETURN_VALUE" -ne "$SUCCESS" ] && terminate "$RETURN_VALUE" "$ABBORT_MESSAGE"


rawLN_exist "$RAW_FILENAME"
RETURN_VALUE="$?"
[ "$RETURN_VALUE" -ne "$SUCCESS" ] && terminate "$RETURN_VALUE" "$ABBORT_MESSAGE"

terminate "$RETURN_VALUE" "$ABBORT_MESSAGE"
