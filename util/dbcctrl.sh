#!/bin/ksh

###############################################################################
# Table..............: ALERTAS-SUC-XXX                                        #
# Aplicacion.........: ALERTAS-SUC                                            #
# Grupo..............: UNIX                                                   #
# Autor..............: Nestor Hugo Cerizola                                   #
# Job Name...........: DB_C_CTRL                                              #
# Objetivo...........: Controla el funcionamiento de la DB en el equipo       #
#                      de contingencia                                        #
# Nombre del programa: db_c_control.sh                                        #
# Descripcion........:                                                        #
# Modificacion.......: 14/05/2018-Cambia el oracle_home por migracion de BD.  #
###############################################################################
#set -x 
#set -n

###############################################################################
###                            Variables                                    ###
###############################################################################

export FPATH=/tecnol/funciones
export FECHA="`date +%Y%m%d`"
export HOST1="`hostname`"
export HOST2="nodo2"
export NOMBRE="dbcctrl"
export PATHAPL="/tecnol/scripts"
export PATHSQL="${PATHAPL}/sql"
export PATHLOG="${PATHAPL}/log"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"
export FILEEXEC="${PATHLOG}/${NOMBRE}.nroejec.txt"

export ORACLE_HOME="/u011/app/oracle/product/11.2.0"
export ORA_USR="oracle"
export USUARIO="/ as sysdba"
export SQLGEN="${PATHSQL}/${NOMBRE}.sql"
export LSTSQLGEN="${PATHLOG}/${NOMBRE}.${FECHA}.lst"
export NOMBRE1="chklog"
export SQLGEN1="${PATHSQL}/${NOMBRE1}.sql"
export LSTSQLGEN1="${PATHLOG}/${NOMBRE1}.${FECHA}.lst"

export ERROR=0
export BASE="SF`uname -n | sed 's/suc//' | sed 's/c$//'`"
export SID="SF${BASE}"


HOST_NRO=`echo $HOST1 | cut -c4-`

if [ ${HOST_NRO} -lt 100 ]
then
        export HOSTNRO_3D=0${HOST_NRO}
        export HOSTNRO_2D=`echo ${HOST_NRO} | cut -c 1-2`
else
        export HOSTNRO_3D=${HOST_NRO}
        export HOSTNRO_2D=${HOST_NRO}
fi

export BASE="SF${HOSTNRO_3D}"

export ARCH_TMP="${PATHAPL}/log/ctrol_ping_c.rtf"
>$ARCH_TMP

export ARCH_SALI="${PATHAPL}/log/ctrol_ping_c.out"
>$ARCH_SALI
find ${PATHLOG} -name "${NOMBRE}*.log" -mtime +7 -exec rm {} \;
find ${PATHLOG} -name "${NOMBRE1}*.lst" -mtime +7 -exec rm {} \;

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Borrar
autoload Check_Par
autoload Enviar_A_Log

ctrol_ping ()
{ 
#set -x 
ping -c 1 $1 2>&1 >/dev/null
if [ $? -ne 0 ]
then 
	return 1
	export PING_C="NOOK"
fi
}

Enviar_mail_alerta ()
{
#set -x

#---------------------------------------------------------------------
# Si la base esta en modo defer, debera enviar un mail pero como el script 
# corre cada 5 minutos puse un archivo de control, con un contador donde si su contenido 
# es mayor o igual a 5 manda mail (el scripts corre cada un minuto osea que
# 5 seria la cant. de minutos que espera para volver a enviar el mail
#---------------------------------------------------------------------

if [ -f ${FILEEXEC} ] && [ ${NROEXEC} -ge 5 ] && [ $ENVIOLOG = "DEFER" ]
then
	export USUARIOS="dbadmin operaciones"
	export MSG_SUBJECT="Control del Servidor de Contingencia de sucursal `hostname` - `date +%d` `date +%b` `date +%Y`-`date +%H`:`date +%M` "

	for USER in $USUARIOS
	do
		echo "${MENSAJE}" | mutt -s "${MSG_SUBJECT}" -b ${USER}@redcoto.com.ar
	done
	echo "1" >${FILEEXEC}	
	Enviar_A_Log "Se informa por Mail a $USUARIOS" ${LOGSCRIPT}
fi
}

chklog ()
{
#set -x

Enviar_A_Log "Inicio del script que controla el estado del envio de logs de la base al ${HOST1}c." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
Borrar ${LSTSQLGEN}
[ $? != 0 ] && exit 99
if [ -x $ORACLE_HOME/sqlplus ]	 
then
	if [ -r ${SQLGEN1} ]
        then
	 	su - ${ORA_USR} "-c . ./.profile ; sqlplus '${USUARIO}' @${SQLGEN1}" >${LSTSQLGEN1}
                if [ $? != 0 ]
                then
                	Enviar_A_Log "ERROR - Fallo la ejecucion del sql ${SQLGEN1}." ${LOGSCRIPT}
                        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                else
                        if [ -f ${LSTSQLGEN1} ]
                        then
                        	grep 'ORA-' ${LSTSQLGEN1}
                                if [ $? != 0 ]
                                then
					grep -i "ENABLE" ${LSTSQLGEN1}  2>/dev/null 1>/dev/null
					if [ $? = 0 ]
					then 
                                      		Enviar_A_Log "Actualmente esta enviando logs (Estado: ENABLE) al servidor ${HOST1}c" ${LOGSCRIPT}
						depuralog	

						export ENVIOLOG="ENABLE"
					else
                                       		Enviar_A_Log "Actualmente No se estan enviando logs (Estado: DEFER) al servidor $HOST1c" ${LOGSCRIPT}
						export ENVIOLOG="DEFER"
					fi	
				else
                                        Enviar_A_Log "ERROR - Error de Oracle durante la ejecucion." ${LOGSCRIPT}
                                        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
					export ENVIOLOG="NOOK"
                                        exit 7
                               	fi
                       	else
                               	Enviar_A_Log "ERROR - No se genero el archivo de spool ${LSTSQLGEN1}." ${LOGSCRIPT}
                               	Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
				export ENVIOLOG="NOOK"
                               	exit 9
                       	fi
                 fi
	else
        	Enviar_A_Log "ERROR - No hay permisos de lectura para el archivo ${SQLGEN1}." ${LOGSCRIPT}
                Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
		export ENVIOLOG="NOOK"
                exit 77
        fi
else
        Enviar_A_Log "ERROR - No hay permisos de ejecucion para el comando sqlplus." ${LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
	export ENVIOLOG="NOOK"
        exit 88
fi
}

#-----------------------------------------------------------------------------
#       Si el equipo secundario esta caido corre el sql
#-----------------------------------------------------------------------------

corre_sql ()
{
#set -x
if [ $ERROR -ge 1 ] 
then
	Check_Par 1 $@
	[ $? != 0 ] && exit 1
	Enviar_A_Log "Comienza la ejecucion del scripts que detiene el envio de logs." ${LOGSCRIPT}
	[ $? != 0 ] && exit 3
	Borrar ${LSTSQLGEN}
	[ $? != 0 ] && exit 99
	if [ -x ${ORACLE_HOME}/sqlplus ]
        then
                if [ -r ${SQLGEN} ]
                then
                        # echo "CORRE EL SQL QUE DEJA DE MANDAR LOSGS AL SERV DE CONTINGENCIA"
			su - ${ORA_USR} "-c . ./.profile ; sqlplus '${USUARIO}' @${SQLGEN} ${LSTSQLGEN}" 
                        if [ $? != 0 ]
                        then
                                Enviar_A_Log "ERROR - Fallo la ejecucion del sql." ${LOGSCRIPT}
                                Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                                exit 5
                        else
                                if [ -f ${LSTSQLGEN} ]
                                then
                                        grep 'ORA-' ${LSTSQLGEN}
                                        if [ $? != 0 ]
                                        then
                                                Enviar_A_Log "Se dejaron de enviar log al servidor ${HOST1}c." ${LOGSCRIPT}
                                        else
                                                Enviar_A_Log "ERROR - Error de Oracle durante la ejecucion." ${LOGSCRIPT}
                                                Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                                                exit 7
                                        fi
                                else
                                        Enviar_A_Log "ERROR - No se genero el archivo de spool ${LSTSQLGEN}." ${LOGSCRIPT}
                                        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                                        exit 9
                               fi
                        fi
                else
                        Enviar_A_Log "ERROR - No hay permisos de lectura para el archivo ${SQLGEN}." ${LOGSCRIPT}
                        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                        exit 77
                fi
        else
                Enviar_A_Log "ERROR - No hay permisos de ejecucion para el comando sqlplus." ${LOGSCRIPT}
                Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                exit 88
        fi
fi	
}

depuralog ()
{
#set -x

	find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +2 -exec gzip {} \;
	find ${PATHLOG} -name "${NOMBRE}.*.lst*" -mtime +7 -exec rm {} \;
	find ${PATHLOG} -name "${NOMBRE}.*.log.gz" -mtime +7 -exec rm {} \;
}

###############################################################################
###                            Principal                                    ###
###############################################################################

#-----------------------------------------------------------------------------
#	Control de estado del servidor de contingencia
#-----------------------------------------------------------------------------

Enviar_A_Log "------------------------------------------------" ${LOGSCRIPT}

# Contador para que envie mail cada 5 minutos 

if [ -f ${FILEEXEC} ] 
then
	NROEXEC="`cat ${FILEEXEC}`"
	NROEXEC=`expr ${NROEXEC} "+" 1`
	echo "${NROEXEC}"  >${FILEEXEC}
else
	echo "1" >${FILEEXEC}
fi

# ------------------------------------------------------
# Controla si el servidor responde el ping 
# ------------------------------------------------------
	
ctrol_ping $HOST2

if [ $? = 1 ]
then
	export MENSAJE="Atencion el servidor de contingencia ${HOST1}c No Responde !!!\n\t\t      Comuniquese con la sucursal y pida que revicen el equipo ${HOST2} !!!"
	Enviar_A_Log "${MENSAJE}" ${LOGSCRIPT}
	export ERROR=1
	chklog
	corre_sql $ERROR
	chklog
	Enviar_mail_alerta
	depuralog
	exit 101
else
	Enviar_A_Log "El ping al servidor ${HOST2} responde OK" ${LOGSCRIPT}
	export ERROR=0

	# ------------------------------------------------------
	# Controla si el tnsping de la base responde 
	# ------------------------------------------------------
	
	# Prueba comunicacion al tnsping 

	if [ `ssh $HOST2 "su - oracle -c 'tnsping standby'" | grep OK | wc -l` -gt 0 ]  
	then
		Enviar_A_Log "El tnsping al servidor ${HOST2} responde OK" ${LOGSCRIPT}
		# Prueba los procesos pmon

		# ------------------------------------------------------
		# Controla si el proceso de la base el pmon esta levantado
		# ------------------------------------------------------
		
		if [ `ssh ${HOST2} "ps -ef | grep 'ora_pmon_${BASE}' | grep -v grep | wc -l"` -gt 0 ]
		then
			# Todo ok
			Enviar_A_Log "El proceso de oracle ora_pmon_${BASE} del servidor ${HOST2} esta levantado OK" ${LOGSCRIPT}
			
			# ------------------------------------------------------
			# Controla si esta todo levantado y la base esta defer 
			# ------------------------------------------------------
			
			chklog
			if [ ${ENVIOLOG} = "DEFER" ]
			then
				export MENSAJE=" Ping ${HOST1}c OK! - TNSPING OK! - ORA_PMON_${BASE} OK! - Estado:${ENVIOLOG} \n\t\t     ATENCION!!! El envio de LOGS al servidor ${HOST1}c esta Detenido!!! \n\t\t     INFORME A LA GUARDIA DBA !!!"
				Enviar_mail_alerta
			fi
			depuralog
			exit 200
		else
		        MENSAJE="Atencion en el servidor de contingencia ${HOST2}. No esta levantada la base de datos ${BASE} !!!\n\t\t      Comuniquese con la guardia DBA"
		        Enviar_A_Log "${MENSAJE}" ${LOGSCRIPT}
			export ERROR=2
		        chklog
               	 	corre_sql $ERROR
			chklog
			Enviar_mail_alerta
			depuralog
			exit 201
		fi
	else
		export MENSAJE="ATENCION No responde el tnsping de la base ${BASE} \n\t\t      del servidor de Contingencia ${HOST2} Comuniquese con la guardia DBA "
		Enviar_A_Log "${MENSAJE}" ${LOGSCRIPT}
		export ERROR=3
		chklog
                corre_sql $ERROR
		chklog
		Enviar_mail_alerta
		depuralog
		exit 301
	fi
fi
