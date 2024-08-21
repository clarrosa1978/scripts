#/usr/bin/ksh
set -x
###############################################################################
# Aplicacion.........: UTIL                                                   #
# Grupo..............: UNIX                                                   #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Depurar el directorio pasado como parametro.           #
# Nombre del programa: depura.sh                                              #
# Nombre del JOB.....:                                                        #
# Solicitado por.....: Administracion AIX                                     #
# Descripcion........:                                                        #
# Creacion...........: 20/02/2015                                             #
# Modificacion.......:                                                        #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA="`date +%Y%m%d`"
export NOMBRE="depura"
export PATHAPL="/tecnol/util"
export PATHLOG="${PATHAPL}/log"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"
export DIRECTORIO="${1}"
export DIAS="${2}"

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Borrar
autoload Check_Par
autoload Enviar_A_Log


###############################################################################
###                            Principal                                    ###
###############################################################################
Check_Par 2 $@
[ $? != 0 ] && exit 1
cd ${DIRECTORIO}
STATUS="$?"
if [ "$STATUS" != 0 ]
then
	echo "No existe el directorio ${DIRECTORIO}"
	exit 10
fi
find ${DIRECTORIO} -mtime +"${DIAS}" -print -exec rm {} \;
exit 0
