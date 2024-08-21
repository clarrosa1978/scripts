#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: NTCIERRE-ZE                                            #
# Grupo..............: PRECADENA                                              #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Mata los semaforos del usuario que recibe c/parametro  #
# Nombre del programa: mataripcs.sh                                           #
# Nombre del JOB.....: MATARIPCS                                              #
# Descripcion........:                                                        #
# Modificacion.......: 25/07/2006                                             #
###############################################################################

set -x
###############################################################################
###                            Variables                                    ###
###############################################################################

export USER=${1}
export SEMAFORO=""
export MEMORIA=""
export COLAS=""

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Check_Par

###############################################################################
###                            Principal                                    ###
###############################################################################

Check_Par 1 $@
[ $? != 0 ] && exit 1

#Busca los semaforos
SEMAFORO=`ipcs -s | grep $USER | cut -f2 -d" "`
if [ "${SEMAFORO}" ]
then
	for sem in ${SEMAFORO}
	do
        	echo "Matando semaforos: $sem"
		sudo ipcrm -s $sem
	done
fi

#Busca segmentos de memoria compartida
MEMORIA=`ipcs -m | grep $USER | cut -f2 -d" "`
if [ "${MEMORIA}" ]
then
        for mem in ${MEMORIA}
        do
                echo "Matando segmentos de memoria compartida: $mem"
                sudo ipcrm -m $mem
        done
fi


#Busca las colas
COLAS=`ipcs -q | grep $USER | cut -f2 -d" "`
if [ "${COLAS}" ]
then
        for colas in ${COLAS}
        do
                echo "Matando colas: $colas"
                sudo ipcrm -q $colas
        done
fi
