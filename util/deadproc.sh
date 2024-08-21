#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: NTCIERRE-ZE                                            #
# Grupo..............: PRECADENA                                              #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Mata los procesos del usuario que recibe como parametro#
# Nombre del programa: deadora.sh                                             #
# Nombre del JOB.....: DEADORACLE                                             #
# Descripcion........:                                                        #
# Modificacion.......: 15/03/2006                                             #
###############################################################################

set -x
###############################################################################
###                            Variables                                    ###
###############################################################################

export FECHA=`date +'%d%m%Y'`
export NOMBREUSU=${1}
export LISTPROC=""
export NOMBRE="credito.dat"
export PATHDAT="/sfctrl/d"

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Check_Par

###############################################################################
###                            Principal                                    ###
###############################################################################
Check_Par 1 $@
[ $? != 0 ] && exit 1
LISTPROC=`ps -ef|sed '1d'|grep ${NOMBREUSU} | grep -v grep |awk ' ( $1 == "'${NOMBREUSU}'" ) { print $2 } ' | sort -r`
if [ "${LISTPROC}" ]
then
	for PID in ${LISTPROC}
	do
		sudo kill -9 ${PID}
	done
fi

mv ${PATHDAT}/${NOMBRE} ${PATHDAT}/$NOMBRE.${FECHA} 
	 if [ $? != 0 ]
               then
                     echo "No se pudo mover el archivo"
                     exit 2
                else
                     echo "Se renombro con exito -->  $PATHDAT/$NOMBRE"
		     find ${PATHDAT} -name "$NOMBRE.${FECHA}" -mtime +20 -exec rm {} \;
                fi
exit 0
