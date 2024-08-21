#!/bin/sh

############################################################################
#                                   Fernandez Garay Jorge - 09/2004
# launch_lneg.sh
#
# Lanzado por el Job CRLNEGTICK, de la cadena LNEG_LUNCHEON_TICK de Control-M,
# que corre en sucursales para generar un archivo de texto con la Lista Negra
# Completa de Tickets LUNCHEON Siniestrados.
#
# Ejecuta el 'lneg.sh', que dispara el procedimiento sql ts030221.sql. Este
# deja el archivo Completo (texto) con los Tikcets LUNCHEON siniestrados en
# el dir /sfctrl/tmp
# Otro Job copiara este archivo al home dir. del usuario sfftp, para que sea
# levantado via ftp, desde la PC de tickets, en sucursales que poseen Venta 
# Mayorista.
#
############################################################################

set -x

if [ "$#" -ne 0 ]
then
         echo "\n\n`date +"%d/%m/%Y"` $0: Error en la cantidad de parametros recibida"

         exit 32
fi

EXIT_STAT=''
export EXIT_STAT

if [ -f /tecnol/tickets/lneg.sh -a -x /tecnol/tickets/lneg.sh ]
then
         /tecnol/tickets/lneg.sh
         EXIT_STAT="$?"

         if [ "$EXIT_STAT" -ne 0 ]
         then
                  echo "\n\n$0: LOs errores de cancelacion del prog. /tecnol/tickets/lneg.sh hay que"
                  echo "buscarlos en el sysout del job CRLNEGTICK"
         fi

else
         echo "\n\n`date +"%d/%m/%Y"` $0: Este programa no existe o no posee permiso de ejecucion"
         exit 31
fi

exit "$EXIT_STAT"
