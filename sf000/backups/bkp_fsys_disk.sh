#!/bin/ksh
###############################################################################
# Apliacion..........: BACKUP                                                 #
# Grupo..............: SLANXAPP4                                              #
# Autor..............: CFL                                                    #
# Objetivo...........: Realizar backup del filesystem.                        #
# Nombre del programa: bkp_fsys.sh                                            #
# Nombre del JOB.....: BKPSLNXAPP3FS-I                                        #
# Solicitado por.....:                                                        #
# Descripcion........: Realiza un backup full/incremental del filesystem de   #
#                      slnxapp4.                                              #
# Modificacion.......: 29/06/2011                                             #
# Parametros.........: Fecha (AAAAMMDD).                                      #
#                      incremental (Backup Incremental)                       #
#                              o                                              #
#                      selective   (Backup Full)                              #
#                                                                             #
# Tipo de errores de salida :                                                 #
#                          1: Error.                                          #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export HOST=`hostname`
export FECHA=${1}
#export FECHA=`date +%Y%m%d`
export FS1=sfctrl
export FS2=u0110
export FS3=sfvcc12
export FS4=sfvcc
export FS5=sts
export FS6=sfcliendo
export FS7=nacion
export FS8=icbc
export HORA=`date +'%H:%M'`
export NOMBRE="bkp_fs"
export PATHAPL="/tecnol/backups"
export PATHLOG="${PATHAPL}/log"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.${HORA}.log"
export ARCHLOG="${NOMBRE}.${FS1}.${FECHA}.${HORA}.log"
export ARCHLOG2="${NOMBRE}.${FS2}.${FECHA}.${HORA}.log"
export ARCHLOG3="${NOMBRE}.${FS3}.${FECHA}.${HORA}.log"
export ARCHLOG4="${NOMBRE}.${FS4}.${FECHA}.${HORA}.log"
export ARCHLOG5="${NOMBRE}.${FS5}.${FECHA}.${HORA}.log"
export ARCHLOG6="${NOMBRE}.${FS6}.${FECHA}.${HORA}.log"
export ARCHLOG7="${NOMBRE}.${FS7}.${FECHA}.${HORA}.log"
export ARCHLOG8="${NOMBRE}.${FS8}.${FECHA}.${HORA}.log"
export LOGTAR="${PATHLOG}/${ARCHLOG}"
export LOGTAR2="${PATHLOG}/${ARCHLOG2}"
export LOGTAR3="${PATHLOG}/${ARCHLOG3}"
export LOGTAR4="${PATHLOG}/${ARCHLOG4}"
export LOGTAR5="${PATHLOG}/${ARCHLOG5}"
export LOGTAR6="${PATHLOG}/${ARCHLOG6}"
export LOGTAR7="${PATHLOG}/${ARCHLOG7}"
export LOGTAR8="${PATHLOG}/${ARCHLOG8}"
export PATHDES="/backup/${HOST}"

###############################################################################
###                            Funciones                                    ###
###############################################################################
. /tecnol/funciones/Borrar
. /tecnol/funciones/Check_Par
. /tecnol/funciones/Enviar_A_Log

autoload Borrar
autoload Check_Par
autoload Enviar_A_Log

###############################################################################
###                            Principal                                    ###
###############################################################################
#Check_Par 1 $@
[ $? != 0 ] && exit 1
sudo find ${PATHDES} -name "*.tar.gz" -exec rm -f {} \;
sudo find ${PATHLOG} -name "${NOMBRE}.*log" -mtime +2 -exec rm {} \;
Enviar_A_Log "INICIO - Comienza la ejecucion del backup filesystem." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
if [ -x /bin/tar ]
then
        cd / ; sudo tar -cvf ${PATHDES}/${FS1}.${HOST}.${FECHA}.tar ${FS1}/ > ${LOGTAR}  ; sudo tar -cvf ${PATHDES}/${FS2}.${HOST}.${FECHA}.tar ${FS2}/ > ${LOGTAR2} ; sudo tar -cvf ${PATHDES}/${FS3}.${HOST}.${FECHA}.tar ${FS3}/ > ${LOGTAR3} ; sudo tar -cvf ${PATHDES}/${FS4}.${HOST}.${FECHA}.tar ${FS4}/ > ${LOGTAR4}; sudo tar -cvf ${PATHDES}/${FS5}.${HOST}.${FECHA}.tar ${FS5}/ > ${LOGTAR5}; sudo tar -cvf ${PATHDES}/${FS6}.${HOST}.${FECHA}.tar ${FS6}/ > ${LOGTAR6} ; sudo tar -cvf ${PATHDES}/${FS7}.${HOST}.${FECHA}.tar ${FS7}/ > ${LOGTAR7}; sudo tar -cvf ${PATHDES}/${FS8}.${HOST}.${FECHA}.tar ${FS8}/ > ${LOGTAR8}

        RESUL=$?
        if [ $RESUL != 0 ] && [ $RESUL != 4 ] && [ $RESUL != 8 ]; then
               Enviar_A_Log "ERROR - Fallo la ejecucion del backup de ${HOST}." ${LOGSCRIPT}
               Enviar_A_Log "FINALIZACION - CON ERROR." ${LOGSCRIPT}
               exit 1
        else
	       gzip ${PATHDES}/*.${HOST}.${FECHA}.tar
               Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
               exit 0
        fi
else
        Enviar_A_Log "ERROR - No hay permisos de ejecucion para el comando tar." ${LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
        exit 1
fi
