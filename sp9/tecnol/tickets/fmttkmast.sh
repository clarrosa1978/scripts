#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: TICKETS                                                #
# Grupo..............: MASTERCARD                                             #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Formatear el archivo tk.negativos.tickets.FECHA.010101 #
# Nombre del programa: fmttkmast.sh                                           #
# Nombre del JOB.....: FMTTKMAST                                              #
# Descripcion........:                                                        #
# Modificacion.......: 01/09/2006                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################

export FECHA=${1}
export NOMBRE="fmttkmast"
export PATHAPL="/tecnol/tickets"
export PATHTICK="/sfctrl/data/carga"
export ARCHTICK="${PATHTICK}/tk.negativo.tickets.${FECHA}"
export PATHLOG="${PATHAPL}/log"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"
export ARCHTMP="${PATHTICK}/tk.mastercard.$$"
export CHK_REC_SIZE="0"

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Enviar_A_Log
autoload Check_Par
autoload Borrar

###############################################################################
###                            Principal                                    ###
###############################################################################
Check_Par 1 $@
[ $? != 0 ] && exit 1
Enviar_A_Log "INICIO - Comienza la ejecucion." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
if [ -s ${ARCHTICK} ]
then
	Enviar_A_Log "AVISO - El archivo ${ARCHTICK} existe." ${LOGSCRIPT}
	cat ${ARCHTICK} |\
       	awk ' { if ( substr( $0, length($0), 1 ) == "\015" ) { print substr( $0, 1, length($0) - 1 ) }
                else { print $0 }
              } ' > ${ARCHTMP}
       	CHK_REC_SIZE=`head -1 ${ARCHTMP} |awk ' { print length($0) } '`
       	if [ ${CHK_REC_SIZE} -eq 37 ]
       	then
        	cp ${ARCHTMP} ${ARCHTICK}
		if [ $? != 0 ]
		then
			echo "Error al copiar ${ARCHTMP} en ${ARCHTICK}."
			exit 3
		else
			Borrar ${ARCHTMP}
			Enviar_A_Log "AVISO - Archivo ${ARCHTICK} formateado correctamente." ${LOGSCRIPT}
			Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
			find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +7 -exec rm {} \;
			exit 0
		fi
       	fi       
else
    	echo "El archivo ${ARCHTICK} no existe."
	exit 12
fi
