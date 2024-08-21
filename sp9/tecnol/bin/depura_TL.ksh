#!/usr/bin/ksh
###############################################################################
# Autor..............: C.A.S                                                  #
# Usuario ...........: root                                                   #
# Objetivo...........: Depurar los archivos de interfases del trntcierre sucXX#
# Nombre del programa: depura_TL.ksh                                          #
# Descripcion........: Depura los archivos generados por medio de un find     #
# Modificacion.......: 25/07/2001                                             #
###############################################################################

###############################################################################
#                        Definicion de variables                              #
###############################################################################

CANT_DIAS=${1-2}
DIRECTORIO=${2-/trntcierre/suc*}
ARCHIVO=${3-TL????????.001}
RC=0

###############################################################################
#                                 Principal                                   #
###############################################################################

find $DIRECTORIO -name "$ARCHIVO" -mtime +${CANT_DIAS} -exec rm {} \; 

exit $RC
