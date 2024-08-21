#################################################################################
#										#
# SCRIPT: Menu_arch_Juncadella							#
#										#
#										#
# DESCRPIPCION: Trae desde las sucursales que figuran en lis_suc_juncadella	#
#		los archivos para ser enviados a juncadella 			#
#										#
# AUTOR: Andres Bruzzese - Operacion						#
#										#
#################################################################################


#########################################################################
#               Definicion de funciones                                 #
#########################################################################

Rcp_juncadella ()
{
export DIR_ORIGEN="/sfctrl/data/descarga"
export SUC_ERROR="$2"

if [ "$1" = "" ]
then
	echo
	echo "\t NO HAY SUCURSALES SELECCIONADAS, VERIFIQUE !!!!"
	echo
else
	>$SUC_ERROR
	for i in $1
	do
		echo "\n\tTransfiriendo archivo de sucursal $i a $HOME_F_JUNCA"
		ping -c1 suc$i > /dev/null 2> /dev/null
		STATUS_PING=$?
		if [ "$STATUS_PING" = "0" ]
		then
			rcp -p suc$i:$DIR_ORIGEN/$FECHA.*$i $HOME_F_JUNCA 2> /dev/null
			STATUS_RCP=$?
			if [ "$STATUS_RCP" != "0" ]
			then
				echo "  Error en la transferencia de archivo de suc$i"
				echo "$i" >> $SUC_ERROR
			fi
		else
			echo "          No hay comunicacion con suc$i"
			echo "$i" >> $SUC_ERROR
		fi
	done
fi

}

Mail_Juncadella_central ()
{
export DESTINATARIO_CTRAL_CHECK="abruzzese@coto.com.ar"
export JUNCADELLA_BSAS="analia.civale@tcj.com.ar fabiana.russo@tcj.com.ar fabiana.russo@jpinter.com.ar gustavo.rode@tcj.com.ar janeth.gonzalez@tcj.com.ar luis.arevalo@tcj.com.ar monica.rodriguez@tcj.com.ar Pablo.Chamorro@tcj.com.ar sara.alvarez@tcj.com.ar"
export JUNCADELLA_STAFE="sucursal.santafe@tcj.com.ar"
export JUNCADELLA_ROSARIO="tcjproin@rcc.com.ar Roberto.Digiura@tcj.com.ar Sebastian.Peri@tcj.com.ar"
export FECHA="$1"
export LISTA_SUCURSALES="$2"
for SUCURSAL in $LISTA_SUCURSALES
do
	case $SUCURSAL in
		095|096|097|099)export DESTINATARIO="$JUNCADELLA_ROSARIO";;
		109)		export DESTINATARIO="$JUNCADELLA_STAFE";;
		*)		export DESTINATARIO="$JUNCADELLA_BSAS";;
	esac
	echo
	echo "\tEnviando mail de $SUCURSAL a $DESTINATARIO"
	case `echo $SUCURSAL|awk '{ print length }'` in
		2)	export NRO_SUCURSAL="0$SUCURSAL" ;;
		3)	export NRO_SUCURSAL="$SUCURSAL" ;;
	esac
	uuencode $FECHA.$NRO_SUCURSAL $FECHA.$NRO_SUCURSAL|mail -s "Mail Juncadella : Archivo de sucursal $SUCURSAL del $FECHA" -c "$DESINTATRIO" $DESTINATARIO_CTRAL_CHECK 
#	export ENVIO_OK=`[ $? = 0 ] && mhmail $DESTINATARIO_CTRL_CHECK -subject "Se envio OK archivo de sucursal $SUCURSAL del $FECHA" -body "`banner OK`"  ||   mhmail $DESTINATARIO_CTRAL_CHECK -subject "Error en el envio de mail de $SUCURSAL de $FECHA" -body "`banner ERROR`"` 
done

}


Mail_Juncadella ()
{
export DESTINATARIO_CTRAL_CHECK="abruzzese@coto.com.ar"
export JUNCADELLA_BSAS="analia.civale@tcj.com.ar fabiana.russo@tcj.com.ar fabiana.russo@jpinter.com.ar gustavo.rode@tcj.com.ar janeth.gonzalez@tcj.com.ar luis.arevalo@tcj.com.ar monica.rodriguez@tcj.com.ar Pablo.Chamorro@tcj.com.ar sara.alvarez@tcj.com.ar"
export JUNCADELLA_STAFE="sucursal.santafe@tcj.com.ar"
export JUNCADELLA_ROSARIO="tcjproin@rcc.com.ar Roberto.Digiura@tcj.com.ar Sebastian.Peri@tcj.com.ar"
export FECHA="$1"
export LISTA_SUCURSALES="$2"
export DIR_ARCHIVO="/sfctrl/data/descarga"
for SUCURSAL in $LISTA_SUCURSALES
do
        case $SUCURSAL in
                095|096|097|099)export DESTINATARIO="$JUNCADELLA_ROSARIO";;
                109)            export DESTINATARIO="$JUNCADELLA_STAFE";;
                *)              export DESTINATARIO="$JUNCADELLA_BSAS";;
        esac
        echo
        echo "\tEnviando mail de $SUCURSAL a $DESTINATARIO"
        case `echo $SUCURSAL|awk '{ print length }'` in
                2)      export NRO_SUCURSAL="0$SUCURSAL"
			;;
                3)      export NRO_SUCURSAL="$SUCURSAL"
			;;
        esac
	case `echo $SUCURSAL|awk '{ print substr ($1,1,1) }'` in
		1)	export HOST="suc$SUCURSAL"
			;;
		0)	export HOST="suc`echo $SUCURSAL |awk '{ print substr ($1,2,2) }'`"
			;;
	esac
#	export DESTINATARIO="$DESTINATARIO_CTRAL_CHECK"
	export CHCK_UUENCODE=`rsh $HOST "[ -s /usr/bin/uuencode ] && echo OK || echo NO_OK"`
	if [ $CHCK_UUENCODE = "OK" ]
	then
        	rsh $HOST "uuencode $DIR_ARCHIVO/$FECHA.$NRO_SUCURSAL $FECHA.$NRO_SUCURSAL |mail -s 'Mail Juncadella: Archivo de sucursal $SUCURSAL del $FECHA' -c $DESTINATARIO $DESTINATARIO_CTRAL_CHECK"
	else
		uuencode $FECHA.$NRO_SUCURSAL $FECHA.$NRO_SUCURSAL|mail -s "$NRO_SUCURSAL no tiene uuencode" $DESTINATARIO_CTRAL_CHECK
	fi
done
}

Mail_zip ()
{
export DESTINATARIO="abruzzese@coto.com.ar"
export FECHA="$1"
export LISTA_SUCURSALES="$2"

zip $HOME_F_JUNCA/$FECHA.zip $HOME_F_JUNCA/$FECHA.*
uuencode $HOME_F_JUNCA/$FECHA.zip $FECHA.zip|mail $DESTINATARIO
}


##################################################################################
##################################################################################

#########################################################################
#               Definicion de variables                                 #
#########################################################################
export PATH_MENU="/home/root/operador/andres/menu_oper"
export PATH_MENU_TMP="$PATH_MENU/tmp"
export PATH_MENU_LOGS="$PATH_MENU/logs"
export FECHA="`cat $PATH_MENU/fecha.dat`"

export OPCION="";
export FECHA_tmp="$PATH_MENU_TMP/FECHA.tmp"
export LIS_SUC_JUNC="38 44 45 46 47 51 55 56 57 58 59 60 61 63 64 65 66 67 68 69 75 78 80 82 83 84 85 90 91 92 94 95 96 97 99 101 103 104 105 107 108 109 110 111 123 124 "
export SUC_ERROR_ALL="$PATH_MENU_TMP/junca_faltante.tmp"
export SUC_ERROR_SELECS="$PATH_MENU_TMP/junca_faltante_selecs.tmp"
export HOME_F_JUNCA="$PATH_MENU/juncadella"
export Banner="$OPERADOR_WRK/Banner.ksh"

#################################################################
#               Principal                                       #
#################################################################
while [ "$OPCION" != "S" -a "$OPCION" != "s" ]
do
        $Banner " Menu de archivos para Juncadella "
        echo
	echo " 1) Lista de sucursales que utilizan recuento de Juncadella"
	echo
        echo " 2) Traer todos los archivos de las sucursales"
        echo
        echo " 3) Traer archivos de sucursales que restan traer del  punto 2"
	echo 
	echo " 4) Traer archivo/s de sucursal/es seleccionada/s"
	echo
	echo " 5) Cambiar fecha de archivos (actual $FECHA)"
        echo
	echo " 6) Enviar los archivos por mail"
	echo
        echo " S) Para salir"
        echo
	echo 
	echo "		OPCION: \c"
        read OPCION
        clear
        case $OPCION in
		1)	$Banner "Listado de sucursales que utilizan recuento"
			echo
			echo
			echo "$LIS_SUC_JUNC\n"
			;;
		2) 	$Banner " Copiando archivos desde sucursales "
			Rcp_juncadella "$SUCJUNC" "$SUC_ERROR_ALL"
			echo
			;;

		3)	$Banner "Copiando archivos desde resto de sucs"
			Rcp_juncadella "`cat $SUC_ERROR_ALL 2> /dev/null`" "$SUC_ERROR_ALL"
			echo
			;;

		4)	$Banner " Copiando archivos desde sucursales "
			echo "\n\n\tSeleccionar sucursales (ej.:09 45 107):\c "
			read SUCURSALES
		        Rcp_juncadella "$SUCURSALES" "$SUC_ERROR_SELECS"
			;;
		5)	$Banner " Cambiar fecha de archivos "
			echo
			echo "\tLa fecha actual es $FECHA "
			echo "\tDesea cambiarla (s/n): \c"
			read RESP; export RESP
			if [ "$RESP" = "s" -o "$RESP" = "S" ] 
			then
				echo
				echo "\tIngrese la nueva fecha (ddmm): \c"
				read NUEVA_FECHA; export NUEVA_FECHA; 
				echo "$NUEVA_FECHA" > $FECHA_tmp
				FECHA="`cut -c1-4 $FECHA_tmp`"
				export FECHA
				rm $FECHA_tmp
				echo  
			fi
			;;
		6)	$Banner " Enviar mail a Juncadella "
			echo
			cd $HOME_F_JUNCA
			export SUCS_MAIL="`ls $FECHA.*|awk '{print substr($1,6,3)}' 2> /dev/null`"
			Mail_Juncadella "$FECHA" "$SUCS_MAIL"
			mv $FECHA.* ./enviados/. 2> /dev/null
			;;
		7)	echo
			cd $HOME_F_JUNCA
			Mail_zip "$FECHA" " "
			mv $FECHA.* ./enviados/. 2> /dev/null
			;;
		8)	echo
			echo "Depurando archivos viejos..."
			find $HOME_F_JUNCA/enviados -mtime "+3" -exec rm {} \;
	esac
	if [ "$OPCION" != "s" -a "$OPCION" != "S" ]
	then
		echo    
		echo " Presione una tecla para continuar";read enter
		echo
	fi
done
