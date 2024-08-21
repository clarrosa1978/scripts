#!/bin/ksh
###########################################################################################
#NOMBRE DEL SCRIPT: preparartlog.sh                                                       #
#DESCRIPCION: Determina, copia y comprime el tlog del dia de la fecha para poder          #
#             transmitirlo a Central                                                      #
#PARAMETROS: Recibe N� de sucursal en tres digitos y la fecha con formato yyyymmdd        #
#AUTOR: Cristian Larrosa                                                                  #
#FECHA DE MODIFICACION: 25-08-2003                                                        #
#FECHA DE MODIFICACION: 28-10-2011 - Cambio de compresion a gzip - CFL                    #
###########################################################################################

###########################################################################################
#                                     VARIABLES                                           #
###########################################################################################
FECHA=$1
SUCURSAL=$3
PATHAPL="/sfctrl/d"
ARCHORI="`ls -1rt ${PATHAPL}/tlog??.dat 2>/dev/null | tail -1`"
ARCHDES="${PATHAPL}/tlog${SUCURSAL}.${FECHA}"

###########################################################################################
#                                     PRINCIPAL                                           #
###########################################################################################

if [ $# -eq 9 ] 
then
	find ${PATHAPL} -name "tlog${SUCURSAL}.????????.gz" -exec rm {} \;
        if [ -s ${ARCHORI} ] 
        then
                cp -p $ARCHORI $ARCHDES
                if [ $? -eq 0 ]
                then
			gzip -f $ARCHDES
                        if [ $? -ne 0 ]
                        then
                                echo "\tFallo la compresion del archivo $ARCHDES"
                                exit 11
                        fi
                else
        		echo "\tFallo la copia del archivo tlog"
                        exit 9                
                fi
        else
                echo "\tEl archivo no existe"
                exit 10
        fi
else
	echo "\tLa cantidad de parametros recibida debe ser 2 (Numero de sucursal y fecha yyyymmdd)\n"
        echo "\tEj: PrepararTlog.sh 090 20030825"
        exit 32
fi
