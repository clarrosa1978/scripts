#!/bin/ksh
###############################################################################
# Aplicacion.........: MENU OPERACIONES SUCURSAL                              #
# Grupo..............:                                                        #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Levanta o baja el listener local.                      #
# Nombre del programa: lsnr.sh                                                #
# Solicitado por.....:                                                        #
# Descripcion........:                                                        #
# Creacion...........: 21/03/2013                                             #
# Modificacion.......: DD/MM/AAAA                                             #
###############################################################################

#set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA="`date +%Y%m%d`"
export SUC="`uname -n | sed 's/suc//'`"
export OPERACION=${1}
export NOMBRE="lsnr"
export PATHAPL="/tecnol/operador"
export FPATH="/tecnol/funciones"

###############################################################################
###                            Funciones                                    ###
###############################################################################
typeset -fu Borrar
typeset -fu Enviar_A_Log

###############################################################################
###                            Principal                                    ###
###############################################################################

case $OPERACION in
	UPEM7)		su - oracle -c "lsnrctl start LISTENEREM7"
			;;

	DOWNEM7)	su - oracle -c "lsnrctl stop LISTENEREM7"
			;;
	
esac
echo "\n\t\t\t\t${REV}Presione una tecla para continuar...${EREV}"
read
