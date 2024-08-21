#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: TICKETS                                                #
# Grupo..............: ARGENCARD                                              #
# Autor..............: TECNOLOGIA (C.A.S)                                     #
# Usuario ...........: root                                                   #
# JOBNAME............: DEPTICKETS                                             #
# Objetivo...........: Depura los archivos de tickets                         #
# Nombre del programa: deptickets.ksh                                         #
# Descripcion........: La variable T_VIDA contiene el tiempo de vida a ser    #
#                      mantenido por los archivos de tickets                  #
# Modificacion.......: 2003/09/30                                             #
###############################################################################

set -x
###############################################################################
#                                Variables                                    #
###############################################################################

TICKETS_ARG=/tickets/argencard
T_VIDA=7
RC=0

###############################################################################
#                                Principal                                    #
###############################################################################

find $TICKETS_ARG -name "tk.negativo.tickets.????????.??????.zip" -mtime +${T_VIDA} -exec rm -f {} \;
if [ $? -ne 0 ]
 then
  RC=10
  echo "Error $RC - al depurar archivos tk.negativo.tickets" 
fi

exit $RC
