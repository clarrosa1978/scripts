#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: BACKUP                                                 #
# Grupo..............:                                                        #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Realiza export de bases mysql.                         #
# Nombre del programa: expmysql.sh                                            #
# Nombre del JOB.....: EXPXXXXX                                               #
# Solicitado por.....: Cristian Larrosa                                       #
# Descripcion........: Recibe como parametro la fecha, usuario con privilegios#
#                      para realizar el export, password del usuario, base de #
#                      datos.                                                 #
# Modificacion.......: 07/08/2008                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA=${1}
export DATABASE=${2}
export USUARIO=root
export PASSWORD=wasabi
export NOMBRE="expfull"
export PATHAPL="/tecnol/backups"
export PATHLOG="${PATHAPL}/log"
export PATHDMP="/expora"
export PROGRAMA="/usr/bin/mysqldump"
export DUMP="${PATHDMP}/full_${DATABASE}.${FECHA}.dmp"
export LOGBACKUP="${PATHLOG}/backup.${DATABASE}.${FECHA}.log"

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
Enviar_A_Log "INICIO - Comienza export de ${DATABASE}." ${LOGBACKUP}
[ $? != 0 ] && exit 3
if [ -x ${PROGRAMA} ]
then
	${PROGRAMA} -u ${USUARIO} --add-drop-table --flush-logs --password=${PASSWORD} --databases ${DATABASE} >${DUMP}
      	if [ $? = 0 ]
      	then
		if [ -s ${DUMP} ]
		then
       			Enviar_A_Log "AVISO - El export  de ${DATABASE} se genero correctamente." ${LOGBACKUP}
       			Enviar_A_Log "AVISO - Comprimiendo export de ${DATABASE}." ${LOGBACKUP}
			gzip -f -v9 ${DUMP}
			if [ $? = 0 ]
			then
       				Enviar_A_Log "AVISO - Export de ${DATABASE} comprimido correctamente." ${LOGBACKUP}
				Enviar_A_Log "FINALIZACION - El backup de ${DATABASE} finalizo correctamente." ${LOGBACKUP}
				find ${PATHDMP} -name "full_${DATABASE}.*" -mtime +7 -exec rm {} \;
				find ${PATHLOG} -name "backup.${DATABASE}.*" -mtime +7 -exec rm {} \;
                		exit 0
			else
				Enviar_A_Log "ERROR - Al comprimir export de ${DATABASE}." ${LOGBACKUP}
       				Enviar_A_Log "FINALIZACION - EL BACKUP DE ${DATABASE} FINALIZO CON ERRORES." ${LOGBACKUP}
			fi
		else
       			Enviar_A_Log "ERROR - El export  de ${DATABASE} no se genero correctamente." ${LOGBACKUP}
       			Enviar_A_Log "FINALIZACION - EL BACKUP DE ${DATABASE} FINALIZO CON ERRORES." ${LOGBACKUP}
			exit 11
		fi
      	else
       		Enviar_A_Log "ERROR - El export de ${DATABASE} finalizo con errore." ${LOGBACKUP}
       		Enviar_A_Log "FINALIZACION - EL BACKUP DE ${DATABASE} FINALIZO CON ERRORES." ${LOGBACKUP}
       		exit 5
      	fi
else
      	Enviar_A_Log "ERROR - No hay permisos de ejecucion para el programa ${PROGRAMA}." ${LOGBACKUP}
      	Enviar_A_Log "FINALIZACION - EL BACKUP DE ${DATABASE} FINALIZO CON ERRORES." ${LOGBACKUP}
      	exit 88
fi
