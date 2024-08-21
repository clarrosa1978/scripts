#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: BALANZAS                                               #
# Grupo..............: NOVEDADES                                              #
# Autor..............: Cristian Larrosa                                       #
# Job Name...........: CPBNXXXX                                               #
# Objetivo...........:                                                        #
# Nombre del programa: copia_bal.sh                                           #
# Descripcion........: Copia y formatea archivo de novedades de balanzas.     #
# Solicitado por.....:                                                        #
# Creacion...........: 05/07/2006                                             #
# Modificacion.......: 29/01/2008                                             #
###############################################################################
set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export SPATH="/transfer/auxiliar"
export TPATH="/transfer/interface"
export SFILE="${SPATH}/${1}"
export TFILE="${TPATH}/${2}"
export FECHA="`date +%Y%m%d`"
export NOMBRE="copia_bal"
export PATHAPL="/tecnol/balanzas"
export PATHLOG="${PATHAPL}/log"
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

if [ ! -s ${SFILE} ]
then
	Enviar_A_Log "ERROR - No hay novedades para Balanzas." ${LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
	exit 12
fi
rm -f ${TFILE}
sed s/$// ${SFILE} > ${TFILE}.TMP

if [ ! -s ${TFILE}.TMP ]
then
	Enviar_A_Log "ERROR - No se pudo copiar a ${TFILE}.TMP" ${LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
        exit 3
fi

chmod 666 ${TFILE}.TMP
mv -f ${TFILE}.TMP ${TFILE}

if [ ! -s ${TFILE} ]
then
	Enviar_A_Log "ERROR - No se pudo renombrar ${TFILE}.TMP} a ${TFILE}" ${LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
        exit 55
fi
find ${SPATH} -name "${1}.*" -mtime +3 -exec rm {} \;
sed s/$// ${SFILE} > ${SFILE}.${FECHA}

if [ ! -s ${SFILE}.${FECHA} ]
then
	Enviar_A_Log "ERROR - No se pudo generar ${SFILE}.${FECHA}" ${LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
        exit 12
fi
compress -f ${SFILE}.${FECHA}
if [ $? != 0 ]
then
	Enviar_A_Log "ERROR - No se pudo comprimir ${SFILE}.${FECHA}" ${LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
        exit 13
fi
Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +3 -exec rm {} \;
