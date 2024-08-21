#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: PRECIOS-GDM                                            #
# Grupo..............: CARGA                                                  #
# Autor..............: Cristian Larrosa                                       #
# Job Name...........: TS030060                                               #
# Objetivo...........: Renombra el archivo GM03XXX_DATEHORA_B.Z como sucXXX.Z #
# Nombre del programa: ts030060.sh                                            #
# Descripcion........:                                                        #
# Modificacion.......: 06/07/2006                                             #
###############################################################################

set -x
###############################################################################
###                            Variables                                    ###
###############################################################################

export FECHA=${1}
export SUCURSAL=${2}
export NOMBRE="ts030060"
export PATHAPL="/tecnol/precios"
export PATHLOG="${PATHAPL}/log"
export PATHPREC="/sfctrl/interface/in"
#export NOMARCHPREC="GM03???_*_B"
export NOMARCHPREC="GM03${SUCURSAL}_${FECHA}??????_B"
export ARCHPREC="`ls -1t ${PATHPREC}/${NOMARCHPREC}.Z | head -1 | awk -F"/" ' { print $NF } '`"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"

###############################################################################
###                            Funciones                                    ###
###############################################################################

autoload Enviar_A_Log
autoload Borrar
autoload Check_Par

###############################################################################
###                            Principal                                    ###
###############################################################################

Check_Par 2 $@
[ $? != 0 ] && exit 1
Enviar_A_Log "INICIO - Comienza la ejecucion." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
[ ${ARCHPREC} ] || exit 4
if [ -r ${PATHPREC}/${ARCHPREC} ]
then
	compress -d -f ${PATHPREC}/${ARCHPREC}
        if [ $? = 0 ]
        then
		Enviar_A_Log "AVISO - Se descomprimio correctamente el archivo ${PATHPREC}/${ARCHPREC}." ${LOGSCRIPT}
		ARCHPREC=`echo ${ARCHPREC}  | cut -c1-24`
		mv -f ${PATHPREC}/${ARCHPREC} ${PATHPREC}/suc${SUCURSAL}
		if [ $? = 0 ]
		then
			Enviar_A_Log "AVISO - Se renombro el archivo ${PATHPREC}/${ARCHPREC} como suc${SUCURSAL}." ${LOGSCRIPT}
                	Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
                	find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +3 -exec rm {} \;
                	exit 0
		else
        		Enviar_A_Log "ERROR - No se pudo renombrar el archivo ${PATHPREC}/${NOMARCHPREC}." ${LOGSCRIPT}
                	Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
			exit 55
		fi
	else
        	Enviar_A_Log "ERROR - No se pudo descomprimir el archivo ${PATHPREC}/${ARCHPREC}." ${LOGSCRIPT}
                Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                exit 13
	fi
else
        Enviar_A_Log "ERROR - No hay permisos de lectura para el archivo ${PATHPREC}/${ARCHPREC}.Z." ${LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
        exit 77
fi
