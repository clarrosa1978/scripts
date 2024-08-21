#!/bin/bash
################################################################################
# Nombre.............: backup_fs,sh                                            #
# Autor..............: NHC                                                     #
# Objetivo...........: Resguardo de datos en Sucursales                        #
# Modificacion.......: Cristian Larrosa - Depura /sfctrl antes del tar         #
#                      y se cambia el metodo de compresion a bzip2.            #
# Documentacion......:                                                         #
################################################################################
#
set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA=${1}
export NOMBRE="backup"
export PATHAPL="/tecnol/backup"
export PATHLOG="$PATHAPL/log"
export DIR_PROV="/provisorio"
export FS_PRO="${DIR_PROV}/backups"
export SUC="`hostname`"
export ARCH_TMP="/tmp/mount"
export BACKUP=""      # Opciones DSK
export SEC=""         # Opciones HOY - AYER - MAN - DIA
export SEC_FNL=${2}
export ESP="\n\t\t     "
export INFORMAR="Comuniquese con el Centro de Computos de Central int. 5257-5258 \n\t\t      o envie un mail con este error a la casilla operaciones@redcoto.com.ar "
export STS="false"
FALSE="false"
TRUE="true"


###############################################################################
###             	Funciones                                           ###
###############################################################################


#------------------------------------------------------------------------------
#	Carga log
#------------------------------------------------------------------------------
carga_log ()
{
	MENSAJE=${1}
	echo "`date +%d` `date +%b` `date +%Y` - `date +%R` : $MENSAJE" | tee -a $ARCH_LOG
	echo "----------------------------------------------------------------------------"
}

#------------------------------------------------------------------------------
#	Carga informe
#------------------------------------------------------------------------------
carga_inf ()
{
	MENSAJE=${1}
	echo "`date +%d` `date +%b` `date +%Y` - `date +%R` : $MENSAJE" | tee -a $ARCH_INF
	echo "---------------------------------------------------------------------" | tee -a $ARCH_INF
}

#----------------------------------------------------------------------------
#	Control Directorio a donde se realiza backup a disco
#----------------------------------------------------------------------------

control_bckdir ()
{
	set -x
	STS=$FALSE
	if [ -d $FS_PRO ]
	then
		carga_log "Existe el directorio $FS_PRO donde realizar el backup"
		STS=$TRUE
		echo "Existe el directorio $FS_PRO proceso a limpiar el contenido del mismo"
		rm -r ${FS_PRO}/*
	else
		mkdir $FS_PRO
		if [ $? = 0 ]
		then
			carga_log "Se creo el directorio $FS_PRO donde realizar el backup"
			STS=$TRUE
		else
		  	MSJ="No existe el directorio $FS_PRO ${ESP} y no se pudo crear, generelo manualmente y vuelva a arrancar el Backup"
			carga_log "$MSJ" ; carga_inf "$MSJ"
			SALIDA="exit 12"
		fi
	fi
}

#------------------------------------------------------------------------------
#	Generando archivos .tar
#------------------------------------------------------------------------------

genera_tar ()
{
	set -x
	STS=$FALSE
	SEC_BKP=$1
	export ARCH_LST_BKP="/tecnol/backup/log/arch_lst_bkp_sec_${SEC_BKP}.lst"
	export ARCH_BKP_OK="/tecnol/backup/log/arch_bkp_sec_${SEC_BKP}_OK.lst"
	export ARCH_BKP_NOOK="/tecnol/backup/log/arch_bkp_sec_${SEC_BKP}_NOOK.lst"
	>${ARCH_LST_BKP}
	>${ARCH_BKP_OK}
	>${ARCH_BKP_NOOK}
	cd $FS_PRO
	FS_TAR="tecnol.sec${SEC_BKP}.tar.bzip2:tecnol vtareserva.sec${SEC_BKP}.tar.bzip2:vtareserva sts.sec${SEC_BKP}.tar.bzip2:sts expora.sec${SEC_BKP}.tar.bzip2:expora home.sec${SEC_BKP}.tar.bzip2:home etc.sec${SEC_BKP}.tar.bzip2:etc sfctrl.sec${SEC_BKP}.tar.bzip2:sfctrl"
	CANT_ARC=`echo ${FS_TAR} | wc -w`
	CANT_ARC_OK=0
	CANT_ARC_NOOK=0
	carga_log "Generando Archivos tar en disco"
	for FS in $FS_TAR
	do
		ARCH_TAR=`echo $FS | cut -d":" -f1`
		FS_TAR=`echo $FS | cut -d":" -f2`
		echo "=================================================================================================="
		echo "========================== 	Generando $ARCH_TAR /$FS_TAR     ==============================="
		echo "=================================================================================================="
		CNT_ARC_BKP=`ls -lt ${FS_PRO}/${FS_TAR}* | wc -l` 1>/dev/null 2>/dev/null
		find ${FS_PRO} -name "${FS_TAR}*" -exec rm {} \;
		carga_log "Generando archivo $FS_PRO/$ARCH_TAR en el $FS_PRO"
		if [ ${FS_TAR} = 'sfctrl' ]
		then
			tar cvjf $FS_PRO/$ARCH_TAR  --ignore-failed-read --exclude="/sfctrl/tmp" --exclude="/sfctrl/interface" --exclude="/sfctrl/i" /$FS_TAR  1>/dev/null 
			CMD_TAR_STAT="`echo $?`"
		else
			if [ ${FS_TAR} = 'home' ]
			then
				tar cvjf $FS_PRO/$ARCH_TAR --ignore-failed-read --exclude="/home/sfftp" --exclude="/home/root" --exclude="/home/rfctrl" --exclude="/home/java" --exclude="/home/ctmagt" --exclude="/home/ctm"  /$FS_TAR  1>/dev/null
			CMD_TAR_STAT="`echo $?`"
			else
				tar cvjf $FS_PRO/$ARCH_TAR --ignore-failed-read   /$FS_TAR  1>/dev/null 
				CMD_TAR_STAT="`echo $?`"
			fi
		fi
		if [ ${CMD_TAR_STAT} = 0 ] || [ ${CMD_TAR_STAT} = 1 ]
		then
			STS=$TRUE
			echo "${ARCH_TAR}:${FS_TAR}" | tee -a ${ARCH_BKP_OK}
			CANT_ARC_OK=`expr ${CANT_ARC_OK} '+' 1`	
		else
			MSJ="No se pudo crear el archivo $ARCH_TAR en el Fs $DIR_TAR ${ESP}"
			carga_log "$MSJ"	
			echo "${ARCH_TAR}:${FS_TAR}" | tee -a ${ARCH_BKP_NOOK}
			CANT_ARC_NOOK=`expr ${CANT_ARC_NOOK} '+' 1`
			SALIDA="exit 16" 
		fi
		echo "=================================================================================================="
	done
}

#------------------------------------------------------------------------------
#	control_secuencia 
#------------------------------------------------------------------------------

control_secuencia ()
{
	set -x
	MSJ="Creando archivo de secuencia tomando como referencia parametro de control-m"
	carga_log "$MSJ"
	if [ ${SEC_FNL} = 0 ]
	then
		SEC_CTRLM=7
	fi
	rm ${FS_PRO}/secuencia
	touch ${FS_PRO}/secuencia
	echo ${SEC_CTRLM} >${FS_PRO}/secuencia
	echo "secuencia=${FS_PRO}/secuencia"
	MSJ="La secuencia correspondiente al dia de hoy es ${SEC_CTRLM}!!!"
	carga_log "$MSJ" ; carga_inf "$MSJ"
	STS=$TRUE
}

#------------------------------------------------------------------------------
#  19)  Envio de mail a los usuario
#------------------------------------------------------------------------------

Enviar_mail_alerta ()
{
	set -x
	export USUARIOS="operaciones"  
	export FILE_LOG="$ARCH_INF"
	export MSG_SUBJECT="Bkp a DISCO ${SUC} - ${DIA_BKP} `date +%d` `date +%b` `date +%Y` - Sec ${SEC_BKP} - ${SALIDA}"
	for USER in $USUARIOS
	do      
		cat $FILE_LOG # | mutt -s "$MSG_SUBJECT" -b ${USER}@redcoto.com.ar
	done
}

#------------------------------------------------------------------------------
#  20)  Depura filesystems antes de resguardar.
#------------------------------------------------------------------------------

Depura_SFCTRL ()
{
	set -x
	rm /sfctrl/d/CAMBIOS.ERR*	1>/dev/null 2> /dev/null
	rm /sfctrl/d/credito.dat.*	1>/dev/null 2> /dev/null
	rm /sfctrl/sd01:*		1>/dev/null 2> /dev/null
	rm /sfctrl/sd02:*		1>/dev/null 2> /dev/null
	rm /sfctrl/s02:*		1>/dev/null 2> /dev/null
	rm /sfctrl/GM03*		1>/dev/null 2> /dev/null
	rm /sfctrl/*.sh			1>/dev/null 2> /dev/null
	rm -r /sfctrl/RFAR*		1>/dev/null 2> /dev/null
	rm /sfctrl/d/actmem.*.dat	1>/dev/null 2> /dev/null
	rm /sfctrl/d/trx*.dat		1>/dev/null 2> /dev/null
	rm /sfctrl/d/trx*.asc		1>/dev/null 2> /dev/null
	rm /sfctrl/d/tlog*.asc		1>/dev/null 2> /dev/null
	rm /sfctrl/data/Clientes*	1>/dev/null 2> /dev/null
	rm /sfctrl/data/clientes*	1>/dev/null 2> /dev/null
}

###############################################################################
#                              PRINCIPAL                                      #
###############################################################################

set -x  
STS=$TRUE

######################## Seteo de procesos iniciales #########################

export SEC_CTRLM=$2
case $SEC_CTRLM in
        0) export SEC_BKP=7 ; export DIA_BKP="Domingo" ;;
        1) export SEC_BKP=1 ; export DIA_BKP="Lunes" ;;
        2) export SEC_BKP=2 ; export DIA_BKP="Martes" ;;
        3) export SEC_BKP=3 ; export DIA_BKP="Miercoles" ;;
        4) export SEC_BKP=4 ; export DIA_BKP="Jueves" ;;
        5) export SEC_BKP=5 ; export DIA_BKP="Viernes" ;;
        6) export SEC_BKP=6 ; export DIA_BKP="Sabado" ;;
esac

DIR_INFORMES=`ls -lt /var/www/html | grep informes | awk '{ print $11 }'`
export ARCH_LOG="$PATHLOG/backup.sec_$SEC_BKP.log"
export ARCH_INF="${DIR_INFORMES}/Backup.$DIA_BKP.SEC_$SEC_BKP.txt"
>$ARCH_LOG
>$ARCH_INF
chmod 664 $ARCH_INF ; chown root.sfsw $ARCH_INF
echo -e "Informe del Resultado del Backup a DISCO del dia ${DIA_BKP} `date +%d` `date +%b` `date +%Y` Secuencia Nro. ${SEC_BKP}\n" | tee -a $ARCH_INF
MSJ="Comenzando Backup del dia `date +%d` `date +%b` `date +%Y` ${ESP} La secuencia del dia ${DIA_BKP} es la nro $SEC_BKP"
carga_log "$MSJ" ; carga_inf "$MSJ"


###################### Comienza el Backup ###############################

if [ $STS = $TRUE ]
then
                control_bckdir
                if [ $STS = $TRUE ]
                then
                                Depura_SFCTRL
                                genera_tar $SEC_BKP
                else
                                echo "$STS No se pudo crear el directorio"
                fi

fi


carga_log "Puede consultar la salida en el archivo $ARCH_LOG"

echo -e "\n\nImportante: Por Cualquier novedad remitirse a la casilla operaciones@redcoto.com.ar" | tee -a $ARCH_INF
echo "o bien telefonicamente a Central Centro de Computos internos 5258 - 5257" | tee -a $ARCH_INF
echo -e "\nSitio web: http://${SUC}/informes/Backup.${DIA_BKP}.SEC_${SEC_BKP}.txt" | tee -a $ARCH_INF 

if [ "$SALIDA" != "exit 0" ]
then
	Enviar_mail_alerta
fi
rm ${ARCH_BKP_NOOK}
rm ${ARCH_BKP_OK}
echo "$SALIDA" >> $ARCH_LOG
