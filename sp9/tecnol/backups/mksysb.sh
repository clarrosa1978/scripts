#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: BACKUP                                                 #
# Grupo..............: GDM                                                    #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Genera un mksysb con formato ISO cd.                   #
# Nombre del programa: mksysb.sh                                              #
# Nombre del JOB.....: MKSYSB                                                 #
# Solicitado por.....: Cristian Larrosa                                       #
# Descripcion........: Recibe como parametro el formato de la ISO.            #
# Modificacion.......: 06/10/2009                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA="${1}"
export FORMATO="${2}"
export EXCLUIR="${3}"
export NOMBRE="mksysb"
export PATHAPL="/tecnol/backups"
export PATHLOG="${PATHAPL}/log"
export PROGRAMA="/usr/sbin/mkcd"
export LOGBACKUP="${PATHLOG}/${NOMBRE}.${FECHA}.log"

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Borrar
autoload Check_Par
autoload Enviar_A_Log


###############################################################################
###                            Principal                                    ###
###############################################################################
Check_Par 3 $@
[ $? != 0 ] && exit 1
Enviar_A_Log "INICIO - Comienza el mksysb." ${LOGBACKUP}
[ $? != 0 ] && exit 3
case ${FORMATO} in
"dvd")	PARAMETROS="-S -R -L"
	;;
"cd")	PARAMETROS="-S -R"
	;;
esac
case ${EXCLUIR} in
"y")  	PARAMETROS="${PARAMETROS} -e"
        ;;
"n")  	break
        ;;
*)    	exit 1
     	;;
esac
if [ -x ${PROGRAMA} ]
then
	sudo ${PROGRAMA} ${PARAMETROS}
	EXIT=$?
	case ${EXIT} in
	0 ) 	Enviar_A_Log "FINALIZACION - MKSYSB FINALIZO CORRECTAMENTE." ${LOGBACKUP}
	   	exit 0
		;; 
	* )	Enviar_A_Log "ERROR - NO DETERMINADO DURANTE EL BACKUP." ${LOGBACKUP}
		exit 1
		;;
	esac
else
 	Enviar_A_Log "ERROR - NO HAY PERMISOS DE EJECUCION PARA EL PROGRAMA ${PROGRAMA}." ${LOGBACKUP}
	Enviar_A_Log "FINALIZACION - MKSYSB FINALIZO CON ERRORES." ${LOGBACKUP}
	exit 88
fi
