#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: NTCIERRE-ZE                                            #
# Grupo..............: PRECADENA                                              #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Levantar procesos de Storeflow.                        #
# Nombre del programa: postipl.sh                                             #
# Nombre del JOB.....: POSTIPL                                                #
# Descripcion........:                                                        #
# Modificacion.......: 15/03/2006                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
PATHAPL="/sfctrl/bin/scripts"

###############################################################################
###                            Principal                                    ###
###############################################################################

autoload Check_Par
Check_Par 9 $@
[ $? != 0 ] && exit 1
if [ -x ${PATHAPL}/postipl ]
then
	postipl
	if [ $? != 0 ] 
	then
                 exit 5
	else
		exit 0
	fi
else
	exit 88
fi
