#################################################################################
#                                                  Martin Llanos - 08/2004
#                       Implementacion CONTROL-M   Jorge Fernandez Garay 09/2004
# lneg.sh
#
# Lanzado por el Job CRLNEGTICK, de la cadena LNEG_LUNCHEON_TICK de Control-M,
# que corre en sucursales para generar un archivo de texto con la Lista Negra
# Completa de Tickets LUNCHEON Siniestrados.
# Genera en /sfctrl/tmp, un archivo Completo de texto de Lista Negra de Tickets
# LUNCHEON Siniestrados.
# Este archivo es levantado via ftp, desde la PC Contadora de Tickets en sucs
# con Vena Mayorista
#
##################################################################################

set -x

if [ ! -f /sfctrl/sfgv/bin/ts030200 ]
then
        echo "\n\n$0: El ejecutable /sfctrl/sfgv/bin/ts030200 NO EXISTE. Abortando..."
        exit 10
fi

if [ ! -x /sfctrl/sfgv/bin/ts030200 ]
then
        echo "\n\n$0: El ejecutable /sfctrl/sfgv/bin/ts030200 NO POSEE PERMISO DE EJECUCION. Abortando..."
        exit 10
fi

if [ ! -f /tecnol/tickets/ts030221.sql ]
then
        echo "\n\n$0: El Procedimiento SQL /tecnol/tickets/ts030221.sql NO EXISTE. Abortando..."
        exit 10
fi

if [ ! -r /tecnol/tickets/ts030221.sql ]
then
        echo "\n\nEl procedimiento SQL /tecnol/tickets/ts030221.sql NO POSEE PERMISO DE LECTURA. Abortando..."
        exit 10
fi

# Genera un archivo Auxiliar, de Novedades de Tickets Siniestrados LUNCHEON
export EXIT_STAT=''
cd /sfctrl/tmp
ts030200 ts030221 tktinvAux
EXIT_STAT="$?"

if [ ! -f /sfctrl/tmp/tktinvAux.out ]
then
         echo "\n\n$0: El proceso ts030200, que ejecuta el ts030221.sql NO GENERO EL ARCHIVO /sfctrl/tmp/tktinvAux.out."
         echo "(Novedades de Tickets Siniestrados LUNCHEON)"
         exit 30
fi

# Formatea el archivo Auxiliar y Genera el archivo de Novedades de Tickets Siniestrados LUNCHEON para la Caja de Tickets
cat /sfctrl/tmp/tktinvAux.out | awk '{ print sprintf("%s%c", substr( $0,2,99 ), 13 ) }' | sed  "s/@/\\$/g"  > /sfctrl/tmp/tktinv.txt

if [ ! -f /sfctrl/tmp/tktinv.txt ]
then
         echo "\n\n$0: NO SE GENERO EL ARCHIVO /sfctrl/tmp/tktinv.txt (Novedades de Tickets Siniestrados LUNCHEON)."
         exit 30
fi

if [ ! -s /sfctrl/tmp/tktinv.txt ]
then
         echo "\n\n$0: El Archivo /sfctrl/tmp/tktinv.txt de Novedades de Tickets Siniestrados LUNCHEON, se genero VACIO."
         exit 32
fi

# Control de la fecha de generacion
CTRL_DATE=`date +"%d%m%Y"`
DATE_FIELD=`cat /sfctrl/tmp/tktinv.txt|awk ' /Lista Normalizada/ { print sprintf("%s", substr( $3, 1, 8 )) } '`

if [ "$CTRL_DATE" != "$DATE_FIELD" ]
then
         echo "\n\n$0: La fecha de Generacion del /sfctrl/tmp/tktinv.txt no es la corriente."
         exit 30
fi 

rm -f /sfctrl/tmp/tktinvAux.out

exit 0
