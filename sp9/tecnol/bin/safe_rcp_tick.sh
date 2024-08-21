#! /usr/bin/sh

################################################################################
#
#      Script: safe_rcp_tick.sh
#       Autor: Jorge Fernandez Garay
#    Ult.Mod.: 04/2007
# Descripcion: Ejecuta el safe_rcp de JAF para transmitir Boletines de Tickets
#              siniestrados.
#              Se ejecuta desde Jobs CONTROL-M nombrados 'TRFTCKXXX', pertene-
#              cientes a la Aplicacion TICKETS que corre en SP9
#
################################################################################

set -x

remote_connection()
{
      set -x
      # Verifica el estado de la conexion con el servidor Remoto.
      # En $1 recibe el nombre del host remoto
      export REM_HOST="$1"

      export CONNECT_STATUS=''
      CONNECT_STATUS=`/etc/ping -i 2 -c9 -q "$REM_HOST" | /usr/bin/grep received | /usr/bin/grep -v grep | /usr/bin/cut -c24-24`

      if [ "$CONNECT_STATUS" -lt 6 ]
      then
               return 3
      else
               return 0 
      fi
}

notify_by_mail()
{
        set -x

        # Notifica el incidente por mail
        # En $1 recibe El mensaje a notificar

        echo "$1"|/usr/bin/mhmail -s "Server $HOSTNAME - CADENA DE TRANSMISION DE TICKETS NACION" operacionesaix@coto.com.ar

}

######################################  MAIN PROGRAM  #########################################

# Parametros posicionales Pasados al programa desde el Autoedit de JOBS CONTROL-M
# nombrados TRFTCKXXX, pertenecientes a la Aplicacion TICKETS en sp9

EXEC_FLAG="$1"
SOURCE_DIR="$2"
SOURCE_FILE_NAME="$3"
TARGET_HOST="$4"
TARGET_DIR="$5"
TARGET_FILE_NAME="$6"
OWNER="$7"
GROUP="$8"
PERM="$9"
export EXEC_FLAG SOURCE_DIR SOURCE_FILE_NAME TARGET_HOST TARGET_DIR TARGET_FILE_NAME OWNER GROUP PERM

# Como las Entidades que comercian Tickets pueden entregar mas de 1 por dia, previamente
# se los renombra con extension '.HHMM' (TIME). Debe entonces determinarse la lista de
# Boletines del dia, y verificar en el destino, si ya ha sido transmitido.
export TODAY_BOL_FILENAMES_LIST=''
export ACTUAL_BOLNAME_TO_COPY=''
export TARGET_BOL_COPY=''
export SUC_NUMBER=`expr "$TARGET_HOST" : '^[^0-9][^0-9]*\([0-9]\{2,\}\)$'`
SUC_NUMBER=`printf "%03d" "$SUC_NUMBER"`
export HOSTNAME=`uname -n`
export MAIL_MESSAGE=''

TODAY_BOL_FILENAMES_LIST=`ls -tr "$SOURCE_DIR"|eval egrep '${SOURCE_FILE_NAME}\.[0-9]{4}'`

for bol_filename in $TODAY_BOL_FILENAMES_LIST
do
         TARGET_BOL_COPY=''
         ACTUAL_BOLNAME_TO_COPY=''

         if remote_connection "$TARGET_HOST"
         then
                    TARGET_BOL_COPY=`rsh "$TARGET_HOST" ls "$TARGET_DIR/$bol_filename"|xargs -i basename {}`
         else
                    MAIL_MESSAGE="JOB TRFTCK$SUC_NUMBER: No existe conexion con el servidor remoto $TARGET_HOST."
                    notify_by_mail "$MAIL_MESSAGE"
                    echo "$MAIL_MESSAGE"
                    exit 38
         fi

         if [ "$TARGET_BOL_COPY" = "$bol_filename" ]
         then
                    # Boletin ya transferido
                    continue
         else
                    # Boletin no transferido
                    ACTUAL_BOLNAME_TO_COPY="$bol_filename"
                    break
         fi
done

if [ ! "$ACTUAL_BOLNAME_TO_COPY" ]
then
         MAIL_MESSAGE="JOB TRFTCK$SUC_NUMBER: No existe Boletin a transferir a $TARGET_HOST, o ya fueron tranferidos Todos."
         notify_by_mail "$MAIL_MESSAGE"
         echo "$MAIL_MESSAGE"
         exit 0
fi

# Llegados a este punto, en ACTUAL_BOLNAME_TO_COPY queda el nombre del Bol a transmitir.
SOURCE_FILE_NAME="$ACTUAL_BOLNAME_TO_COPY"
TARGET_FILE_NAME="$ACTUAL_BOLNAME_TO_COPY"


if [ "$EXEC_FLAG" = "P" ]
then 
	if [ ! -s "$SOURCE_DIR"/"$SOURCE_FILE_NAME" ]
	then
		echo "Se intento enviar un archivo vacio o inexistente"
		exit 10
	fi
fi

if [ "$TARGET_HOST" = "suc50" ]
then
	TARGET_HOST=j40gdm
fi

export EXIT_STAT=''

/tecnol/bin/safe_rcp "$EXEC_FLAG" "$SOURCE_DIR" "$SOURCE_FILE_NAME" "$TARGET_HOST" "$TARGET_DIR" "$TARGET_FILE_NAME" "NULL" "NULL" "3" "300" "NULL" "$OWNER" "$GROUP" "$PERM"
EXIT_STAT="$?"

if [ "$EXIT_STAT" -ne 0 ]
then 
	if [ "$EXIT_STAT" -eq 52 ]
	then
		echo "No hay comunicacion en este momento"
		exit 38
	else
		echo "Error en la transferencia de archivos"
		exit "$EXIT_STAT"
	fi
else
	if [ "$EXEC_FLAG" = "G" ]
	then 
		if [ ! -s "$TARGET_DIR"/"$TARGET_FILE_NAME" ]
		then
			echo "EL archivo copiado tiene size 0"
			exit 10
		else
			exit 0
		fi
	fi

        exit 0
fi
