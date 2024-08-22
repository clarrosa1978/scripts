#!/usr/bin/ksh
###############################################################################
# Grupo..............: BACKUP                                                 #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Borrar backups viejos de 30 dias para atras de la fecha#
#                      de hoy.                                                #
# Nombre del programa: delete_obsoleto_backup.sh                              #
# Nombre del JOB.....:                                                        #
# Solicitado por.....:                                                        #
# Descripcion........: Borra del catalogo backups obsoletos.                  #
# Modificacion.......: 20/02/2015                                             #
#                                                                             #
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
#	allocate channel for maintenance device type 'sbt_tape' parms 'ENV=(TDPO_OPTFILE=/usr/tivoli/tsm/client/oracle/bin64/em02/tdpo_em02.opt)';
        allocate channel for maintenance device type 'sbt_tape' parms 'SBT_LIBRARY=/opt/veeam/VeeamPluginforOracleRMAN/libOracleRMANPlugin.so' format 'a8db82c0-4c9b-49d4-9dfc-a34e3e055047/RMAN_%I_%d_%T_%U.vab';
#	delete backupset COMPLETED BETWEEN '01-JUL-2009' AND '${FECHA_OBSOLETO}';
#        delete noprompt obsolete;
#        CONFIGURE RETENTION POLICY TO RECOVERY WINDOW OF 10 DAYS;

#list backupset COMPLETED BETWEEN '01-JUL-2009' AND '${FECHA_OBSOLETO}';
CONFIGURE RETENTION POLICY TO RECOVERY WINDOW OF 10 DAYS;
CROSSCHECK BACKUP; # checks backup sets and copies on configured channels
DELETE noprompt EXPIRED BACKUP;
delete force noprompt backupset COMPLETED BETWEEN '01-JUL-2009' AND '${FECHA_OBSOLETO}';
EOF


                $ORACLE_HOME/bin/rman target / nocatalog @${RMAN} log=${LOGRMAN}
		RESUL=$?
                if [ $RESUL != 0 ]
                then
                    Enviar_A_Log "ERROR - Fallo la ejecucion del delete tape." ${LOGSCRIPT}
                    Enviar_A_Log "FINALIZACION - CON ERROR ($RESUL)." ${LOGSCRIPT}
                    exit $RESUL
		else
                   Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
                   find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +2 -exec rm {} \;
                   exit 0
                fi
else
        Enviar_A_Log "ERROR - No hay permisos de ejecucion para el comando rman." ${LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
        exit 88
fi