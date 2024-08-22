#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: LISTAS_NEGRAS                                          #
# Grupo..............: COMPLETOS                                              #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Carga  completa de Lista Negra.                        #
# Nombre del programa: carga_listanega.sh                                     #
# Nombre del JOB.....: ACT_COMPLETALN                                         #
# Solicitado por.....: Administracion Unix                                    #
# Descripcion........:                                                        #
# Creacion...........: 03/02/2010                                             #
# Modificacion.......: DD/MM/AAAA                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA=${1}
export NOMBRE="carga_listanega"
export PATHAPL="/tecnol/carga_LN"
export PATHDATA="/provisorio"
export PATHSQL="${PATHAPL}/sql"
export PATHLOG="${PATHAPL}/log"
export ARCHDATA="${PATHDATA}/listaneg_newfmt.dat"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"
export USUARIO="u601/apolo11"
export SQLCTL1="${PATHSQL}/${NOMBRE}1.ctl"
export SQLCTL2="${PATHSQL}/${NOMBRE}2.ctl"
export LSTSQLCTL1="${PATHLOG}/${NOMBRE}1.${FECHA}.xaa.lst"
export LSTSQLCTL2="${PATHLOG}/${NOMBRE}2.${FECHA}"

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Borrar
autoload Check_Par
autoload Enviar_A_Log


###############################################################################
###                            Principal                                    ###
###############################################################################
Check_Par 1 $@
[ $? != 0 ] && exit 1
Enviar_A_Log "INICIO - Comienza la ejecucion." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
Borrar ${LSTSQLCTL1}
Borrar ${LSTSQLCTL2}.lst
rm -f ${PATHDATA}/xa*
if [ -s ${ARCHDATA}.Z ]
then
	Enviar_A_Log "AVISO - Descomprimiendo el archivo ${ARCHATA}.Z " ${LOGSCRIPT}
	compress -d -f ${ARCHDATA}.Z
	if [ $? != 0 ]
	then
		Enviar_A_Log "ERROR - No se pudo descomprimir el archivo ${ARCHATA}.Z" ${LOGSCRIPT}
		exit 5
	fi
	FILAS="`wc -l ${ARCHDATA} | awk ' { print $1 } '`"
	[ ${FILAS} ] || exit 4
	COUNT="`echo ${FILAS} / 4 | bc`"
	[ ${COUNT} ] || exit 4
	cd ${PATHDATA}
	[ $? != 0 ] && exit 2
	split -l ${COUNT} ${ARCHDATA}
	[ $? != 0 ] && exit 5
	for i in `ls ${PATHDATA}/xa*`
	do
		Enviar_A_Log "AVISO - Renombrando archivo ${i} como ${i}.dat" ${LOGSCRIPT}
		mv ${i} ${i}.dat
		if [ $? != 0 ] 
		then
			Enviar_A_Log "ERROR - No se pudo renombrar archivo ${i} como como ${i}.dat" ${LOGSCRIPT}
			exit 55
		fi
	done
	Enviar_A_Log "AVISO - Cambiando owner y permisos a archivos ${PATHDATA}/xa*." ${LOGSCRIPT}
	chown sfctrl.sfsw ${PATHDATA}/xa?.dat
	if [ $? != 0 ] 
	then
		Enviar_A_Log "ERROR - No se pudo cambiar el owner a archivos ${PATHDATA}/xa*." ${LOGSCRIPT}
		exit 56
	fi
	chmod 664 ${PATHDATA}/xa?.dat
	if [ $? != 0 ]
	then
		Enviar_A_Log "ERROR - No se pudo cambiar los permisos a archivos ${PATHDATA}/xa*." ${LOGSCRIPT}
		exit 57
	fi
	sqlldr ${USUARIO} control=${SQLCTL1} log=${LSTSQLCTL1} data=${PATHDATA}/xaa rows=10000  direct=yes
	if [ $? != 0 ]
   	then
		Enviar_A_Log "ERROR - Ejecutando sqlldr de ${PATHDATA}/xaa." ${LOGSCRIPT}
		exit 5
   	else
      		grep 'SQL*Loader-' ${LSTSQLCTL1}
      		if [ $? = 0 ]
         	then 
			Enviar_A_Log "ERROR - Ejecutando sqlldr de ${PATHDATA}/xaa." ${LOGSCRIPT}
            		exit 5
		else
			rm -f ${PATHDATA}/xaa.dat
			for i in `ls -1 ${PATHDATA}/xa?.dat | awk -F'/' ' { print $3 } '`
			do
				Enviar_A_Log "AVISO - Cargando ${i}." ${LOGSCRIPT}
				sqlldr ${USUARIO} control=${SQLCTL2} log=${LSTSQLCTL2}.${i}.lst data=${PATHDATA}/${i} rows=10000  direct=no
				if [ $? != 0 ]
        			then
                			Enviar_A_Log "ERROR - Ejecutando sqlldr de ${PATHDATA}/${i}" ${LOGSCRIPT}
                			exit 5
        			else
                			grep 'SQL*Loader-' ${LSTSQLCTL2}.${i}.lst
                			if [ $? = 0 ]
                			then
                        			Enviar_A_Log "ERROR - Ejecutando sqlldr de ${PATHDATA}/${i}." ${LOGSCRIPT}
                        			exit 5
					else
						Enviar_A_Log "AVISO - La carga de ${PATHDATA}/${i} termino OK." ${LOGSCRIPT}
						rm -f ${PATHDATA}/${i}
      					fi
				fi
			done
			Enviar_A_Log "FINALIZACION - La carga de completos termino OK." ${LOGSCRIPT}
			find ${PATHLOG} -name "${NOMBRE}*" -mtime +35 -exec rm {} \;
                        exit 0
		fi
	fi
else
	Enviar_A_Log "ERROR - No existe el archivo ${ARCHDATA}.Z." ${LOGSCRIPT}
	exit 12
fi
