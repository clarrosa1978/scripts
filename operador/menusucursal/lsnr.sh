#!/bin/sh
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

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Borrar
autoload Enviar_A_Log

###############################################################################
###                            Principal                                    ###
###############################################################################
if [ $SUC -lt 100 ]
then
	SUC=0$SUC
fi
case $OPERACION in
	UPSF)		su - oracle -c "lsnrctl start LISTENER$SUC"
			;;

	DOWNSF)		su - oracle -c "lsnrctl stop LISTENER$SUC"
			;;
	
	UPCTM)		su - oracle -c "ORACLE_SID=CTRLM$SUC ; lsnrctl start LCTRLM$SUC"
			;;
	
	DOWNCTM)	su - oracle -c "ORACLE_SID=CTRLM$SUC ; lsnrctl stop LCTRLM$SUC"
			;;

	UPSFSEC)	ssh nodo2 "su - oracle -c 'lsnrctl start LISTENER$SUC'"
			;;
	
	DOWNSFSEC)	ssh nodo2 "su - oracle -c 'lsnrctl stop LISTENER$SUC'"
			;;
esac
echo "\n\t\t\t\t${REV}Presione una tecla para continuar...${EREV}"
read
