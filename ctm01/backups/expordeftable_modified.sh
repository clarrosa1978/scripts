#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: UTIL                                                   #
# Grupo..............: CTM                                                    #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Realiza un exportdeftable de todas las tablas.         #
# Nombre del programa: expordeftable_all.sh                                   #
# Nombre del JOB.....: EXPDEFTABLEALL                                         #
# Solicitado por.....: Cristian Larrosa                                       #
# Descripcion........:                                                        #
# Creacion...........: 09/09/2016                                             #
# Modificacion.......: DD/MM/AAAA                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA=${1}
export FECHEA="${FECHA}-`date +%H%M`"
export NOMBRE="expordeftable_modified"
export PATHAPL="/tecnol/backups"
export PATHLOG="${PATHAPL}/log"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"
export PATHEXP="/export/xml"
export PF="${PATHAPL}/.ecs.pwd"
export PATHSQL="${PATHAPL}/sql"
export USUARIO="/"
export SQLGEN="${PATHSQL}/${NOMBRE}.sql"
export LSTSQLGEN="${PATHLOG}/${NOMBRE}.${FECHA}.lst"

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Check_Par
autoload Enviar_A_Log


###############################################################################
###                            Principal                                    ###
###############################################################################
Check_Par 1 $@
[ $? != 0 ] && exit 1
Enviar_A_Log "INICIO - Comienza la ejecucion del ${NOMBRE}." ${LOGSCRIPT}
Borrar ${LSTSQLGEN}
if [ -x $ORACLE_HOME/bin/sqlplus ]
then
        if [ -r ${SQLGEN} ]
        then
                sqlplus -s ${USUARIO} @${SQLGEN} ${LSTSQLGEN} ${FECHA}
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
                          		Enviar_A_Log "AVISO - Lista de tablas generadas OK." ${LOGSCRIPT}
                                        find ${PATHLOG} -name "${NOMBRE}.*.lst" -mtime +7 -exec rm {} \;
                                        find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +7 -exec rm {} \;
                                else
                                        Enviar_A_Log "ERROR - Error de Oracle durante la ejecucion." ${LOGSCRIPT}
                                        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                                        exit 7
                                fi
                        else
                                Enviar_A_Log "ERROR - No se genero el archivo de spool." ${LOGSCRIPT}
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
#GENERANDO ARCHIVOS .ARG
export FILE="${LSTSQLGEN}"
while IFS= read line
do
	echo $line | awk ' { print $1,$2 } ' | read DC TB
	ARCHARG="${PATHEXP}/${DC}.${TB}.arg"
	`cat > ${ARCHARG}  << OEF 
<?xml version='1.0' encoding='UTF-8'?>
<!DOCTYPE TERMS SYSTEM "terms.dtd">
<TERMS>
	<TERM>
		<PARAM NAME="DATACENTER" OP="EQ" VALUE="${DC}"/>
		<PARAM NAME="TABLE_NAME" OP="EQ" VALUE="${TB}"/>
	</TERM>
</TERMS>
`
done <"$FILE"

#GENERANDO XML
if [ -x /home/ecs/bin/exportdeftable ]
then
	for ARCHARG in `ls -1 ${PATHEXP}/*.arg`
	do
		EXP="`echo ${ARCHARG} | sed s/.arg/.$FECHA.xml/`"
		Enviar_A_Log "AVISO - Realizando export de ${ARCHARG}." ${LOGSCRIPT}
		/home/ecs/bin/exportdeftable -pf ${PF} -s EM02 -arg ${ARCHARG} -out ${EXP}
		if [ $? = 0 ]
		then
			Enviar_A_Log "AVISO - XML ${EXP} generado OK ." ${LOGSCRIPT}
			gzip -f ${EXP}
			find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +7 -exec rm {} \;
			rm -f ${ARCHARG}
		else
			Enviar_A_Log "ERROR - Error al generar ${EXP}." ${LOGSCRIPT}
			Enviar_A_Log "FINALIZACION - Con ERRORES." ${LOGSCRIPT}
			exit 1
		fi
	done
else
	Enviar_A_Log "ERROR - Sin permisos de ejecucion /home/ecs/bin/exportdeftable." ${LOGSCRIPT}   
	Enviar_A_Log "FINALIZACION - Con ERRORES." ${LOGSCRIPT}
	exit 88
fi
Enviar_A_Log "FINALIZACION - XML's generados OK." ${LOGSCRIPT}
find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +7 -exec rm {} \;
