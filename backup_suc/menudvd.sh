#!/usr/bin/ksh
################################################################################
# Nombre.............: menu_sec.sh                                             #
# Autor..............: NHC                                                     #
# Objetivo...........: Menu para el manejo de la grabadora de DV               #
# Modificacion.......:                                                         #
# Documentacion......:                                                         #
################################################################################
#
#set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA=${1}
export NOMBRE="backup"
export PATHAPL="/tecnol/backup"
export PATHLOG="$PATHAPL/log"
export FS_DVD="/media/dvd"
export SUC=`hostname`
export ARCH_TMP="/tmp/mount"
export ARCH_SAL="/tmp/salida"
export DEV=`ls -l /dev/dvd | awk '{print $11}'`
export SEC_BKP=""
export DIA_BKP=""
export DEVICE="/dev/$DEV"

###############################################################################
###                            Funciones                                    ###
###############################################################################

#------------------------------------------------------------------------------
#  0) SALIDA POR PANTALLA 
#------------------------------------------------------------------------------

carga_log ()
{
#set -x 
echo "\t\t$1\n\t\t" >>$ARCH_SAL
export MSJ="`cat $ARCH_SAL`"
}

#------------------------------------------------------------------------------
#  1)  Controlando Unidad de dvd 
#------------------------------------------------------------------------------

control_dvd ()
{
#set -x
# Busco la Unidad de DVD
ls -l /dev/dvd | awk '{print $11}'
if [ $? != 0 ]
then
        carga_log "ERROR!!! NO SE DETECTO UNIDAD DE DVD, VERIFIQUE!!.." 
else
	DEV=`ls -l /dev/dvd | awk '{print $11}'` 
	DEVICE="/dev/$DEV" 
	carga_log "Se detecto un dispositivo de DVD $DEVICE.."
fi
}


#------------------------------------------------------------------------------
#  0) Limpiar procesos DVD  
#------------------------------------------------------------------------------

limpia_proc ()
{ 
#set -x
kill -9 `/usr/sbin/lsof | grep $DEV | awk '{ print $2}'` 2>/dev/null 1>/dev/null
}

#------------------------------------------------------------------------------
#  1) Chequear DVD puesto
#------------------------------------------------------------------------------

chec_dvd ()
{
#set -x
inject_dvd
limpia_proc
desmontar_dvd
rm $CHK_DVD >/dev/null 2>&1 
CHK_DVD="/tmp/chec_dvd.tmp"
for INT in 1 2 3 4 5 6 7
do
dvd+rw-mediainfo /dev/$DEV | grep "Mounted Media:" | awk '{print $4}' | grep DVD >$CHK_DVD
cat $CHK_DVD >>${ARCH_SAL}
if [ $? = 0 ]
then
        break
else
        eject -t
        sleep 10
fi
done
dvd+rw-mediainfo /dev/$DEV | grep "Mounted Media:" | awk '{print $4}' | grep DVD >$CHK_DVD
cat $CHK_DVD >>${ARCH_SAL}
if [ $? = 0 ]
then
	DVD_IN=`dvd+rw-mediainfo /dev/$DEV | grep "Mounted Media:" | awk '{print $4}' | grep DVD`
	if [ $DVD_IN = "DVD+RW" ] || [ $DVD_IN = "DVD-RW" ]
	then
		carga_log "Existe un $DVD_IN en el dispositivo $DEVICE"
	else
		carga_log "El dvd insertado $DVD_IN no sirve para realizar backups \n\t    Cambie el DVD y use del tipo DVD+RW"
	fi
else
	grep "Error trying to open" $CHK_DVD
	if [ $? = 0 ]
	then
		carga_log "La unidad de DVD esta siendo utilizada.. \n\t    aguarde unos momentos e intente nuevamente"
		
	else
		grep "not an MMC unit" $CHK_DVD
		if [ $? = 0 ]
		then
			carga_log "La unidad de DVD esta siendo utilizada.. \n\t    aguarde unos momentos e intente nuevamente"
		else
			grep "unable to open" $CHK_DVD
			if [ $? = 0 ]
			then
 				carga_log "No se detecto ninguna Grabadora de DVD, revice el dispositivo y vuelva a intentarlo"
			else
				grep "Input/output error" $CHK_DVD
				if [ $? = 0 ]
				then
					carga_log "Error al leer el DVD, puede que este danado..proceda a cambiarlo por favor.."
				else
					grep "no media mounted" $CHK_DVD
					if [ $? = 0 ]
					then
						carga_log "No hay ningun DVD insertado en la grabadora.."
					fi
				fi
			fi
		fi
	fi
fi
			
rm $CHK_DVD 2>/dev/null 1>/dev/null

}

#------------------------------------------------------------------------------
#  2) Introducir DVD de la unidad
#------------------------------------------------------------------------------

inject_dvd () 
{
#set -x
eject -t $DEVICE >>${ARCH_SAL}
if [ $? != 0 ]
then
        kill -9 `/usr/sbin/lsof | grep $DEV | awk '{ print $2}'`
        eject -t
        if [ $? = 0 ] 
        then
                carga_log "Grabadora de DVD CERRADA"
        else
                carga_log "Hubo errores al insertar el DVD de la grabadora. Verifique!!!"
        fi 
else
        carga_log "Grabadora de DVD CERRADA"
fi
}
#------------------------------------------------------------------------------
#  2) Ejectar DVD de la unidad
#------------------------------------------------------------------------------

eject_dvd ()
{
#set -x
eject -r $DEVICE >>${ARCH_SAL}
if [ $? != 0 ]
then
        kill -9 `/usr/sbin/lsof | grep $DEV | awk '{ print $2}'`
        eject
        if [ $? = 0 ]
        then
                carga_log "Grabadora de DVD ABIERTA..."
        else
                echo
                carga_log "Hubo errores al intentar expulsar el DVD de la grabadora.  Verifique!!!"
        fi
else            
        carga_log "Grabadora de DVD ABIERTA..."
fi
}
#------------------------------------------------------------------------------
# 3) control_secuencia 
#------------------------------------------------------------------------------

control_secuencia ()
{
#set -x
ls /media/dvd/secuencia
if [ $? = 0 ]
then
	SEC_DVD="`cat /media/dvd/secuencia`"  >/dev/null 2>&1 
	if [ $SEC_DVD -ne "" ]
	then 
	carga_log "La Secuencia grabada en el DVD es la numero $SEC_DVD ..." 
	else
	carga_log "El archivo de secuencia esta en vacio, Grabe un numero de secuencia por favor"
	fi
else
        carga_log "ERROR!!! El DVD que esta puesto no tiene el archivo de \"secuencia\" grabado \n Formatee el DVD o Grabale la secuencia"
fi
}

#------------------------------------------------------------------------------
# 6) Seleccionar Secuencia 
#------------------------------------------------------------------------------

dia_secuencia ()
{
#set -x
export SEC_BKP=""
export DIA_BKP=""
export SELDIA=""
while [ "$SELDIA" != "S" -a "$SELDIA" != "s" ] && [ "$SELDIA" != " " ]  
do
        Banner "Ingrese el numero del dia de la Secuencia a Grabar en el DVD "
        echo ""
        echo "\t1) Lunes    2) Martes    3) Miercoles    4) Jueves    5) Viernes    6) Sabado    7) Domingo"
        echo ""
        echo "\tg) Grabar   s) Para salir\t\t"
        echo
        tput cup 10 8 ; tput sgr1
        echo "Secuencia Seleccionada: $SEC_BKP $DIA_BKP"
	echo 
        echo "\tOPCION: \c"
        read SELDIA
		if [ "$SELDIA" -lt 8 ] && [ "$SELDIA" -gt 0 ] || [ "$SELDIA" = G -o "$SELDIA" = g ]
		then
        		case $SELDIA in        
	        		1) export SEC_BKP=1 ; export DIA_BKP="Lunes" ;;
			        2) export SEC_BKP=2 ; export DIA_BKP="Martes" ;;
		        	3) export SEC_BKP=3 ; export DIA_BKP="Miercoles" ;;
			        4) export SEC_BKP=4 ; export DIA_BKP="Jueves" ;;
			        5) export SEC_BKP=5 ; export DIA_BKP="Viernes" ;;
 		        	6) export SEC_BKP=6 ; export DIA_BKP="Sabado" ;;
				7) export SEC_BKP=7 ; export DIA_BKP="Domingo" ;;
		              g|G) break ;;
			      s|S) break ;;
			esac
		fi
done
}

#------------------------------------------------------------------------------
# 4) Grabar archivo
#------------------------------------------------------------------------------

grabar_secuencia ()
{
#set -x
limpia_proc
sleep 15
carga_log "Procediendo a Grabar el archivo de secuencia $SEC_BKP en el DVD.." 
touch /tecnol/backup/secuencia
echo ${SEC_BKP} >/tecnol/backup/secuencia
if [ $DVD_IN = "DVD+RW" ] || [ $DVD_IN = "DVD-RW" ]
then
#	growisofs -use-the-force-luke -Z /dev/$DEV -R -J /tecnol/backup/secuencia  >>${ARCH_SAL}
	/usr/bin/growisofs -Z /dev/$DEV -use-the-force-luke=notray -use-the-force-luke=tty -use-the-force-luke=dao -speed=4 -gui -graft-points -full-iso9660-filenames -iso-level 2 -R -J /tecnol/backup/secuencia  >>${ARCH_SAL}
	if [ $? = 0 ]
	then 
		carga_log "Se grabo el archivo secuencia con el nro $SEC_BKP en el DVD"
		montar_dvd
		leer_sec
	else
		carga_log "ERROR, No se pudo grabar el archivo de secuencia $SEC_BKP"
	fi
fi

}
#------------------------------------------------------------------------------
#  6) Leer SECUENCIA
#------------------------------------------------------------------------------

leer_sec ()
{
limpia_proc
carga_log "Aguarde.. Leyendo el DVD.."
ls -lt /media/dvd/secuencia > /dev/null 2>&1
if [ $? = 0 ]
then
	carga_log "Se grabo el archivo de control \"secuencia\" al DVD con la secuencia nro ${SEC_BKP}"
	carga_log "`ls -lt /media/dvd/secuencia`"
else
	desmontar_dvd
        carga_log  "No se pudo grabar el archivo de Secuencia nro ${SEC_BKP} en el DVD "
fi
}

#------------------------------------------------------------------------------
# 10) Leer DVD
#------------------------------------------------------------------------------

leer_dvd ()
{
limpia_proc
carga_log "Aguarde Leyendo el contenido del DVD"
carga_log "`ls -lt /media/dvd`"
}

#------------------------------------------------------------------------------
#  5) Formatear dvd
#------------------------------------------------------------------------------

formatear_dvd ()
{
#set -x
limpia_proc
>/tmp/error_formatear
export SAL_MSJ=""
export SAL_FRMT=""
echo "Aguarde.. Procediendo a Formatear el DVD"
limpia_proc
if [ $DVD_IN = "DVD+RW" ] || [ $DVD_IN = "DVD-RW" ]
then	
        dvd+rw-format -gui -force /dev/$DEV  >/tmp/error_formatear 2>&1
	cat /tmp/error_formatear >>${ARCH_SAL}
        grep error /tmp/error_formatear
        if [ $? = 0 ]
        then
		dvd+rw-format -blank /dev/$DEV  >/tmp/error_formatear 2>&1
		cat /tmp/error_formatear >>${ARCH_SAL}
                grep error /tmp/error_formatear
                if [ $? = 0 ]
                then
               		growisofs -use-the-force-luke -Z /dev/$DEV=/dev/zero >/tmp/error_formatear 2>&1
			cat /tmp/error_formatear >>${ARCH_SAL}
                	grep error /tmp/error_formatear
	                if [ $? = 0 ]
        	        then
                	read
                	        SAL_FRMT="1"
			else
				SAL_FRMT="0"
			fi
		else
		SAL_FRMT="0"
		fi
	else
        SAL_FRMT="0"
	fi
	if  [ $SAL_FRMT = 0 ]
	then
        	carga_log "El DVD se formateo correctamente..."
	        FORMAT="OK"
	else
        	carga_log  "ERROR !! Hubo errores al intentar formatear el DVD \n\t\tO no es un DVD regrabable, reviselo o cambielo..."
	       	FORMAT="NO_OK"		
	fi
else
        carga_log  "ERROR !! El DVD no es ni DVD+RW ni DVD-RW \n\t\tO no es un DVD que sirva, reviselo o cambielo..."
fi
}

#------------------------------------------------------------------------------
#  8)  Montar DVD
#------------------------------------------------------------------------------

montar_dvd ()
{
#set -x
limpia_proc
sleep 15
df -k $FS_DVD | grep "$FS_DVD" > /dev/null 2>&1
if [ $? = 0 ]
then
	carga_log "El Filesystem $FS_DVD ya estaba montado"
	MOUNT="OK"
else
	for MNT in 1 2 3 4 5
        do
	mount -t iso9660 -o rw,noatime $DEVICE $FS_DVD > ${ARCH_TMP} 2>&1
	if [ $? = 0 ]
	then
		cat ${ARCH_TMP} >>${ARCH_SAL}
       		carga_log "Filesystem $FS_DVD fue montado correctamente" 
	        MOUNT="OK"
		break
	else
		cat ${ARCH_TMP} >>${ARCH_SAL}
       		carga_log "ERROR $MNT!! Al intentar montar el filesystem /media/dvd... \n Pruebe Volver a montarlo y leer el contenido, \nde no poder montarse se debera reemplazar el DVD por uno nuevo"
	        MOUNT="NO_OK"
	fi
	done
fi
}

#------------------------------------------------------------------------------
#  9)  Desmontar DVD
#------------------------------------------------------------------------------

desmontar_dvd ()
{
sleep 15
#set -x
limpia_proc
df -k $FS_DVD | grep "$FS_DVD" > /dev/null 2>&1
if [ $? = 0 ]
then
	umount  $FS_DVD > /dev/null 2>&1
	if [ $? = 0 ] 
	then
		carga_log "Filesystem /media/dvd Desmontado" 
		DESMOUNT="OK"
	else
		carga_log "ERROR!! No se pudo desmontar /media/dvd..."
		DESMOUNT="NO_OK"
	fi
else
	carga_log "El Filsystem $FS_DVD ya esta desmontado" 
	DESMOUNT="OK"
fi
}

#------------------------------------------------------------------------------
#  10) Correr backup  
#------------------------------------------------------------------------------

correr_backup ()
{ 
#set -x 
tput cup 28 12
echo "Ingrese fecha (ej; 20100721 AAAAMMDD):\c" 
read FEC_BACKUP
tput cup 30 12
echo "Ingrese Secuencia: (ej: 1 2 3 4 5 6 7):\c"
read SEC_BACKUP
clear
echo 
echo "\t\t---------------------------------------------------------------------------"
echo "\t\tEstas por ejecutar el backup a DVD para el dia $FEC_BACKUP con la secuencia $SEC_BACKUP \n\t\tEsta operacion puede durar varios minutos..\n\t\tSi estan correctos la fecha y la secuencia y esta seguro de continuar \n\t\tPresione una tecla o presione "S" para salir: \c"
read CONT
echo "\n\t\t---------------------------------------------------------------------------"
        if [ "$CONT" != "s" -a "$CONT" != "S" ]
        then
	echo
	ksh /tecnol/backup/backup_suc.sh $FEC_BACKUP $SEC_BACKUP
        echo    
        fi
}

###############################################################################
#                              PRINCIPAL                                      #
###############################################################################
export FECHA=$1
export SEC_CTRLM=$2
export NRO_HOST=`hostname`
limpia_proc
Banner()
{
clear;
echo "          =========================================================================="
echo "            $1       "
echo "          =========================================================================="
}

export OPCION="";

######################################################################################
######################################################################################
clear

while [ "$OPCION" != "S" -a "$OPCION" != "s" ]
do
        Banner " Menu para el manejo de la Grabadora DVD - $NRO_HOST "
        echo "\t\t\t\t\t\t\t"
        echo "\t\t0) Ver el dispositivo de Grabacion ($DEV)\t\t"
        echo "\t\t1) Ver el DVD que esta puesto en la grabadora\t\t"
        echo "\t\t2) Expulsar DVD de la Grabadora\t\t"
        echo "\t\t3) Insertar DVD de la Grabadora\t\t"
        echo "\t\t4) Montar dvd en el fs /media/dvd \t"
        echo "\t\t5) Desmontar dvd en el fs /media/dvd\t"
        echo "\t\t6) Ver contenido del archivo secuencia\t"
        echo "\t\t7) Ver contenido del DVD\t"
        echo "\t\t8) Grabar archivo de secuencia en el DVD\t "
        echo "\t\t9) Formatear DVD y Grabar archivo de Secuencia\t"
	echo "\t\t10) Ejecutar Un Backup de Prueba\t"
        echo "\t\t\t\t\t\t\t"
        echo "\t\t\t\t\t\t\t"
        echo "\t\tS) Para salir\t\t\t"
	echo
        tput cup 18 12
	echo "-------------------------------------------------------------------------"
        echo "$MSJ"
	echo "\t\t-------------------------------------------------------------------------"
	echo 
        echo "\t\t\tOPCION: \c"
        read OPCION
        echo " "
	echo
	>$ARCH_SAL
        case $OPCION in
                0) control_dvd;;
		1) chec_dvd;;
                2) eject_dvd;;
                3) inject_dvd;;
                4) montar_dvd;;
                5) desmontar_dvd;;
		6) montar_dvd 
		  if [ $MOUNT = "OK" ] 
		  then
			control_secuencia
		  fi	;;
                7) montar_dvd 
                  if [ $MOUNT = "OK" ] 
                  then
                	leer_dvd 
                  fi  ;;
                8) dia_secuencia
                   if [ "$SEC_BKP" -lt 8 ] && [ "$SEC_BKP" -gt 0 ] && [ "$SELDIA" = "G" -o "$SELDIA" = "g" ]
                   then
			desmontar_dvd 
			if [ $DESMOUNT = "OK" ]
			then
				chec_dvd
				grabar_secuencia
			fi
		   else
			   SELDIA=""
		   fi ;;
                9) dia_secuencia 
                   if [ "$SEC_BKP" -lt 8 ] && [ "$SEC_BKP" -gt 0 ] && [ "$SELDIA" = "G" -o "$SELDIA" = "g" ]
       			   then
			   desmontar_dvd
        	           	if [ $DESMOUNT = "OK" ]
	         	        then
					chec_dvd
					formatear_dvd 
					if [ $FORMAT = "OK" ]
					then
						grabar_secuencia
					fi
				fi
			   else
			   SELDIA=""
			   fi ;;
		10) correr_backup
	esac
done

