#!/bin/sh
exit 0
###############################################################################
# Aplicacion.........: MENU OPERACIONES SUCURSAL                              #
# Grupo..............:                                                        #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Ejecutar el script dbsec.sh en el servidor secundario  #
# Nombre del programa: dbremoto.sh                                            #
# Solicitado por.....:                                                        #
# Descripcion........:                                                        #
# Creacion...........: 05/02/2013                                             #
# Modificacion.......: DD/MM/AAAA                                             #
###############################################################################


###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA="`date +%Y%m%d`"
export NOMBRE="dbremoto"
export PARAMETRO="${1}"
export SERVREM="nodo2"
export PATHAPL="/tecnol/operador"
export PATHLOG="${PATHAPL}/log"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"
###############################################################################
###                            Funciones                                    ###
###############################################################################

###############################################################################
###                            Principal                                    ###
###############################################################################
case ${PARAMETRO} in
UPSF)		export OPERACION="UP"
		export BASE="SF`uname -n | sed 's/suc//' | sed 's/c$//'`"
		;;

DOWNSF)		export OPERACION="DOWN"
                export BASE="SF`uname -n | sed 's/suc//' | sed 's/c$//'`"
		;;

UPCTM)		export OPERACION="UP"
                export BASE="CTRLM`uname -n | sed 's/suc//' | sed 's/c$//'`"
		;;

DOWNCTM)	export OPERACION="DOWN"
                export BASE="CTRLM`uname -n | sed 's/suc//' | sed 's/c$//'`"
		;;
esac

ssh ${SERVREM} "${PATHAPL}/dbsec.sh $OPERACION $BASE"
echo "\t\t\tPresione una tecla para continuar\c"
read
