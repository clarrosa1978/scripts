#! /bin/ksh

############################################################################
#                                   Fernandez Garay Jorge - 08/2004
# launch_actualizo.sh
#
# Lanzado por el Job LOAD_LN_NOV, de la cadena CARGA_NOV_LN de Control-M,
# que corre en sucursales para realizar la Carga de Novedades de Lista Negra.
# Ejecuta el programa actualizo.sh, que carga Las Noved. de Lista Negra trans
# mitidas desde el SP9, en una tabla Temporaria de STOREFLOW, con sqlLoad.
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

if [ -f /tecnol/carga_LN/actualizo.sh -a -x /tecnol/carga_LN/actualizo.sh ]
then
         /tecnol/carga_LN/actualizo.sh
         EXIT_STAT="$?"

         if [ "$EXIT_STAT" -ne 0 ]
         then
                  echo "\n\n$0: LOs errores de cancelacion del prog. /tecnol/carga_LN/actualizo.sh, hay que"
                  echo "buscarlos en el sysout del job LOAD_LN_NOV"
         fi

else
         echo "\n\n`date +"%d/%m/%Y"` $0: Este programa no existe o no posee permiso de ejecucion"
         exit 31
fi

exit "$EXIT_STAT"
