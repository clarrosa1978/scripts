#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: BACKUP                                                 #
# Grupo..............: EXADATA                                                #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Borrar backups viejos de X dias para atras de la fecha #
#                      de hoy.                                                #
# Nombre del programa: delete_obsoleto_backup.sh                              #
# Nombre del JOB.....: DELETEXXXXXXX                                          #
# Solicitado por.....:                                                        #
# Creacion...........: 21/04/2015                                             #
# Tipo de errores de salida :                                                 #
#                          4 y 8 : Warning.                                   #
#                             12 : Critico.                                   #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################

MESES[1]='Jan'
MESES[2]='Feb'
MESES[3]='Mar'
MESES[4]='Apr'
MESES[5]='May'
MESES[6]='Jun'
MESES[7]='Jul'
MESES[8]='Aug'
MESES[9]='Sep'
MESES[10]='Oct'
MESES[11]='Nov'
MESES[12]='Dec'

export FECHA=${1}
ANIO=`echo $FECHA | cut -b 1-4`
MES=`echo $FECHA | cut -b 5-6`
DIA=`echo $FECHA | cut -b 7-8`

export ORACLE_SID=${2}
export HORA=`date +'%H:%M'`
export NOMBRE="delete_obsoleto_backup"
export PATHAPL="/tecnol/backups"
export PATHLOG="${PATHAPL}/log"
export RMAN="/tmp/delete_obsoleto_backup.rmn"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.${HORA}.log"
export LOGRMAN="${PATHLOG}/${NOMBRE}.${FECHA}.${HORA}.rman.log"

export FECHA_OBSOLETO=`echo ${DIA}-${MESES[$MES]}-${ANIO}`

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
Check_Par 2 $@
[ $? != 0 ] && exit 1
Enviar_A_Log "INICIO - Comienza la ejecucion del delete tape." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
if [ -x ${ORACLE_HOME}/bin/rman ]
then
#
# Creo el archivo delete_obsoleto_backup.rmn en /tmp
#
cat > ${RMAN} << EOF
  allocate channel for maintenance device type 'sbt_tape' parms 'ENV=(TDPO_OPTFILE=/opt/tivoli/tsm/client/oracle/bin64/ctrldbadm01/tdpo_ctrldbadm01.${ORACLE_SID}.opt)';
  #CONFIGURE RETENTION POLICY TO RECOVERY WINDOW OF 20 DAYS;
  delete force noprompt backupset COMPLETED BETWEEN '01-JUL-2009' AND '${FECHA_OBSOLETO}';
  delete force noprompt obsolete;
EOF

		$ORACLE_HOME/bin/rman target "'tsm/YJXF%WXX as sysbackup'" catalog rman/ASER459@oemrep @${RMAN} log=${LOGRMAN}
		RESUL=$?
                if [ $RESUL != 0 ]
                then
                    Enviar_A_Log "ERROR - Fallo la ejecucion del delete tape." ${LOGSCRIPT}
                    Enviar_A_Log "FINALIZACION - CON ERROR ($RESUL)." ${LOGSCRIPT}
                    exit $RESUL
		else
                   Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
                   find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +15 -exec rm {} \;
                   exit 0
                fi
else
        Enviar_A_Log "ERROR - No hay permisos de ejecucion para el comando rman." ${LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
        exit 88
fi
