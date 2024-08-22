#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: UTIL                                                   #
# Grupo..............: MULTISTORE                                             #
# Autor..............: Hugo Messina                                           #
# Objetivo...........: Sincronizar directorios en forma remota con rsyncd.    #
# Nombre del programa: rsyncd.sh                                              #
# Nombre del JOB.....: RSYNCIMGXXX                                            #
# Solicitado por.....: Jose Chariano - Soporte Storeflow                      #
# Descripcion........:                                                        #
# Creacion...........: 15/08/2012                                             #
# Modificacion.......:                                                        #
###############################################################################

set -x
 
###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA=${1}
export DIRORI=${2}
export SERVDES=${3}
export DIRDES=${4}
export NOMBRE="rsync"
 

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Check_Par


###############################################################################
###                            Principal                                    ###
###############################################################################
Check_Par 4 $@
[ $? != 0 ] && exit 1
if [ -x /usr/bin/rsync ]
then 
 	sudo rsync -av ${DIRORI} rsync://${SERVDES}${DIRDES}
 	STATUS=$?
 	if [ $STATUS != 0 ] && [ $STATUS != 25 ] && [ $STATUS != 24 ]
 	then
  		echo "Error al sincronizar fs"
  		exit 1
 	fi
else
	echo "Error - No hay permisos de ejecucion para el comando /usr/bin/rsync"
	exit 1

fi
