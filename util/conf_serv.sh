#!/usr/bin/ksh
################################################################################
# Aplicacion.........: UTIL                                                    #
# Grupo..............: RHEL                                                    #
# Autor..............: Cristian Larrosa                                        #
# Nombre del programa: conf_serv.sh                                            #
# Nombre del JOB.....: CONFSERV  					       #
# Descripcion........: Recolecta informacion de hardware y so.                 #
# Modificacion.......: 15/11/2010                                              #
################################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################

export FECHA=${1}
export NOMBRE="conf_serv"
export PATHAPL="/tecnol/util"
export PATHSAL="/tmp"
export ARCHSAL="${PATHSAL}/`uname -n`"

###############################################################################
###                            Funciones                                    ###
###############################################################################

autoload Enviar_A_Log
autoload Borrar
autoload Check_Par

###############################################################################
###                            Principal                                    ###
###############################################################################

Check_Par 1 $@
[ $? != 0 ] && exit 1
Borrar ${ARCHSAL}.txt
Borrar ${ARCHSAL}.html
if [ -x /usr/bin/cfg2html ]
then
	/usr/bin/cfg2html -o ${PATHSAL}
	if [ $? != 0 ]
	then
       		echo "ERROR - Fallo la ejecucion del comando cfg2html." 
                echo "FINALIZACION - CON ERRORES." 
                exit 5
	fi
	if [ -s ${ARCHSAL}.txt ] && [ -s ${ARCHSAL}.html ]
	then
		echo "FINALIZACION - OK." 
		exit 0
	else
		echo "ERROR - No se genero el archivo ${ARCHSAL}.txt o ${ARCHSAL}.html."
		echo "FINALIZACION - CON ERRORES." 
                exit 9
        fi
else
        echo "ERROR - No hay permisos de ejecucion para el comando cfg2html." 
        echo "FINALIZACION - CON ERRORES." 
        exit 88
fi
