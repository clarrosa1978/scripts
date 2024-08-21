#!/usr/bin/ksh
###############################################################################
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Chequear archivos de Prosegur.                         #
# Nombre del programa: sts.sh                                                 #
# Solicitado por.....: Omar Del Negro                                         #
# Descripcion........: Chequear si Prosegur envio la informacion de retiros.  #
# Fecha de creacion..: 27/04/2008                                             #
# Modificacion.......: DD/MM/AAAA                                             #
###############################################################################

###############################################################################
###                            Variables                                    ###
###############################################################################
export PATHAPL="/home/hdesk"
export PATHLOG="${PATHAPL}/log"
export USUARIO="`whoami`"
export LOG="${PATHLOG}/logmenu.${USUARIO}.`date +%A`"
export BLNK=`tput blink`
export BOLD=`tput bold`
export END=`tput sgr0`
export REV=`tput smso`
export EREV=`tput rmso`
export SITIO="juncadella_ftp_site"
export PATHFTPREC="ftpjunca"
export PATHFTPPROC="${PATHFTPREC}/procesados"
export PATHCENREC="/sfctrl/sts/trf"
export PATHCENPROC="${PATHCENREC}/procesados"
export PATHSUCREC="/sts"
export PATHSUCPROC="${PATHSUCREC}/procesados"
export SCRIPT="ARCHIVOS STS"
export SESION=`who am i | awk ' { print $2 } '`

###############################################################################
###                            Funciones                                    ###
###############################################################################

function ValidarIngreso
{
#set -x
export INGRESO=${1}
if [ -Z ${INGRESO} ] 2>/dev/null
then
                echo "\n\n\t\t\t\t${BLNK}Ingrese un valor.. para continuar...${END}"
                break
        else
                continue
        fi
}

function ValidarSucursal
{
	typeset -Z3 SUC="${1}"
	typeset -Z1 VALIDA=1
	typeset -fu EsNumerico
	export HOST=${SUC}
	export TIPO=0
	EsNumerico ${SUC}
  	[ $? = 1 ] && return 1
	if [ ${SUC} -lt 100 ]
	then
		typeset -Z2 SUC="${1}"
	fi
	for i in `cat /etc/listasuc`
	do
		[ ${SUC} = ${i} ] && VALIDA=0 export HOST=suc${SUC} export TIPO="A"
	        if [ ${VALIDA} = 0 ]
        	then
                	return 0
        	fi
	done
	for i in `cat /etc/listalnx`
        do
                [ ${SUC} = ${i} ] && VALIDA=0 export HOST=suc${SUC} export TIPO="L"
		if [ ${VALIDA} = 0 ]
                then
                        return 0
                fi
        done
	if [ ${VALIDA} = 1 ]
        then
        	return 1
        fi
}

###############################################################################
#				Principal                                     #
###############################################################################
while true
do
        ${PATHAPL}/encabezado.sh "ARCHIVOS STS"
	Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - Ingreso a ARCHIVOS STS." ${LOGSCRIPT}
        echo "${REV}\n\n\n\n\t\t\t\tIngrese el numero de sucursal [S|s]:${EREV} \c"
        read NROSUC
	ValidarIngreso ${NROSUC}
	Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - Ingreso el numero de Sucursal ${NROSUC}." ${LOGSCRIPT}
	[ ${NROSUC} ] || break
	[ ${NROSUC} = "S" -o ${NROSUC} = "s" ] && exit
	ValidarSucursal ${NROSUC}
	if [ $? = 1 ] 
	then
		echo "\n\n\t\t\t\t${BLNK}SUCURSAL INVALIDA${END}\c"
		Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - Ingreso \"${NROSUC}\" y es un valor de nro de SUCURSAL INVALIDA." ${LOGSCRIPT}		
		echo "\n\n\n\t\t\t\t${BOLD}Presione una tecla para continuar...${END}"
               	read
		Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - Salio de ARCHIVOS STS." ${LOGSCRIPT}
		exit
	fi
	if [ ${HOST} = "suc50" ]
	then
		HOST=nodo9
	fi
	typeset -Z3 NROSUC
	typeset -Z4 FECHA
	echo "${REV}\t\t\t\t   Ingrese la fecha a consultar [MMDD]: ${EREV}\c"
        read FECHA
	ValidarIngreso ${FECHA}
	Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - Ingreso la fecha a consultar ${FECHA}." ${LOGSCRIPT}
	echo "${BOLD}\t\t\t\t   Aguarde un instante......${END}"
	EsNumerico ${FECHA}
	MM=`echo ${FECHA} | cut -c 1-2`
	DD=`echo ${FECHA} | cut -c 3-4`
	EsNumerico ${FECHA}
	if [ $? != 0 ] || [ ${MM} -lt 1 ] || [ ${MM} -gt 12 ] || [ ${DD} -lt 1 ] || [ ${DD} -gt 31 ]
	then
		echo "\n\n\t\t\t\t${BLNK}FECHA INVALIDA${END}\c"
		Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - Ingreso \"${FECHA}\" y es un valor de FECHA INVALIDA." ${LOGSCRIPT}
        	echo "\n\n\n\t\t\t\t${BOLD}Presione una tecla para continuar...${END}"
                read
		Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - Salio de ARCHIVOS STS." ${LOGSCRIPT}
        	exit
	fi
	ping -c1 ${HOST} >/dev/null 2>&1
	if [ $? != 0 ]
	then
		echo "\n\n\t\t\t\t${BLNK}NO HAY COMUNICACION CON ${HOST}!!!${END}"
		Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - SUCURSAL SIN COMUNICACION." ${LOGSCRIPT}
                echo "\n\t\t\t\t${REV}Presione una tecla para continuar...${EREV}"
                read
		Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - Salio de ARCHIVOS STS." ${LOGSCRIPT}
		exit
	fi
	ping -c1 ${SITIO} >/dev/null 2>&1
	if [ $? != 0 ]
	then
    		echo "\n\n\t\t\t\t${BLNK}NO HAY COMUNICACION CON ${SITIO}!!!${END}"
		Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - NO HAY COMUNICACION CON ${SITIO}." ${LOGSCRIPT}
                echo "\n\t\t\t\t${REV}Presione una tecla para continuar...${EREV}"
                read
		Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - Salio de ARCHIVOS STS." ${LOGSCRIPT}
                exit
        fi
	FTPREC=`echo "dir ${PATHFTPREC}/${FECHA}r.${NROSUC}" | ftp ${SITIO} 2>/dev/null | grep -v "cannot find"`
        FTPPROC=`echo "dir ${PATHFTPPROC}/${FECHA}r.${NROSUC}.trf" | ftp ${SITIO} 2>/dev/null | grep -v "cannot find"`
	CENREC=`rsh sp17 "cd ${PATHCENREC} ;ls -1 ${FECHA}r.${NROSUC} 2>/dev/null"`
	CENPROC=`rsh sp17 "cd ${PATHCENPROC} ;ls -1 ${FECHA}r.${NROSUC}* 2>/dev/null"`
	if [ ${TIPO} = "A" ]
	then
		SUCREC=`rsh ${HOST} "cd /sfctrl/sts ;ls -1 ${FECHA}r.${NROSUC} 2>/dev/null"`
		SUCPROC=`rsh ${HOST} "cd /sfctrl/sts/procesados ;ls -1 ${FECHA}r.${NROSUC} 2>/dev/null"`
		SUCBAD=`rsh ${HOST} "cd /sfctrl/sts/bad ;ls -1 ${FECHA}r.${NROSUC}.bad 2>/dev/null"`
	else
		SUCREC=`ssh ${HOST} "cd ${PATHSUCREC} ;ls -1 ${FECHA}r.${NROSUC} 2>/dev/null"`
                SUCPROC=`ssh ${HOST} "cd ${PATHSUCPROC} ;ls -1 ${FECHA}r.${NROSUC} 2>/dev/null"`
                SUCBAD=`ssh ${HOST} "cd ${PATHSUCREC} ;ls -1 ${FECHA}r.${NROSUC}.bad 2>/dev/null"`
	fi
	echo "${REV}\n\n\t\t\t\tSITIO FTP${EREV}"
	if [ "${FTPREC}" ] 
	then
		echo "\t\t\t\t${BOLD}Archivo pendiente para enviar a ${HOST} en sitio:${END}"
		Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - Archivo pendiente para enviar a ${HOST} en sitio." ${LOGSCRIPT}
		echo "\t\t\t\t${FTPREC}"
		echo "\n\t\t\t\t${REV}Presione una tecla para continuar...${EREV}"
                read
		Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - Salio de ARCHIVOS STS." ${LOGSCRIPT}
                exit
	fi
	if [ "${FTPPROC}" ] 
        then
        	echo "\t\t\t\t${BOLD}EL archivo ya fue enviado correctamente al sp17${END}"
		Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - EL archivo ya fue enviado correctamente al sp17." ${LOGSCRIPT}
	else
		echo "\t\t\t\t${BOLD}EL archivo aun no fue enviado por PROSEGUR${END}"
		Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - EL archivo aun no fue enviado por PROSEGUR." ${LOGSCRIPT}
		echo "\n\t\t\t\t${REV}Presione una tecla para continuar...${EREV}"
                read
		Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - Salio de ARCHIVOS STS." ${LOGSCRIPT}
                exit
	fi
	echo "${REV}\n\n\t\t\t\tCENTRAL (sp17)${EREV}"
	if [ ${CENREC} ]
        then
        	echo "\t\t\t\t${BOLD}Archivo pendiente para enviar a ${HOST} en sp17:${END}"
		Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - Archivo pendiente para enviar a ${HOST} en sp17." ${LOGSCRIPT}
               	echo "\t\t\t\t${CENREC}"
                echo "\n\t\t\t\t${REV}Presione una tecla para continuar...${EREV}"
                read
		Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - Salio de ARCHIVOS STS." ${LOGSCRIPT}
                exit
        fi
        if [ ${CENPROC} ]
        then
        	echo "\t\t\t\t${BOLD}EL archivo ya fue enviado correctamente a ${HOST}${END}"
		Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - EL archivo ya fue enviado correctamente a ${HOST}." ${LOGSCRIPT}
	fi
	echo "${REV}\n\n\t\t\t\tSUCURSAL ${HOST}${EREV}"
	if [ ${SUCREC} ]
	then
		echo "\t\t\t\t${BOLD}Archivo pendiente de procesar${END}"
		Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - Archivo pendiente de procesar." ${LOGSCRIPT}
                echo "\t\t\t\t${SUCREC}"
                echo "\n\t\t\t\t${REV}Presione una tecla para continuar...${EREV}"
                read
		Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - Salio de ARCHIVOS STS." ${LOGSCRIPT}
                exit
	fi
	if [ ${SUCPROC} ]
	then
		echo "\t\t\t\t${BOLD}EL archivo ya fue procesado en la ${HOST}${END}"
		Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - EL archivo ya fue procesado en la ${HOST}." ${LOGSCRIPT}
		echo "\n\t\t\t\t${REV}Presione una tecla para continuar...${EREV}"
                read
		Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - Salio de ARCHIVOS STS." ${LOGSCRIPT}
                exit
	else
		if [ ${SUCBAD} ]
		then
			echo "\t\t\t\t${BOLD}EL archivo fue procesado pero tiene errores${END}"
			Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - EL archivo fue procesado pero tiene errores." ${LOGSCRIPT}
			echo "\t\t\t\t${BOLD}llamar a la guardia de STS${END}"
			echo "\n\t\t\t\t${REV}Presione una tecla para continuar...${EREV}"
			read
			Enviar_A_Log "${USUARIO} - ${SESION} - PID :$$ - ${SCRIPT} - Salio de ARCHIVOS STS." ${LOGSCRIPT}
			exit
		fi
	fi
done
