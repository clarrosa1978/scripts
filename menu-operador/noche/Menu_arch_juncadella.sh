#!/usr/bin/ksh
#set -x
#################################################################################
#										#
# SCRIPT: Menu_arch_Juncadella							#
#										#
#										#
# DESCRPIPCION: Trae desde las sucursales que figuran en lis_suc_juncadella	#
#		los archivos para ser enviados a juncadella 			#
#										#
# AUTOR: Hugo Cerizola  - Operacion						#
#										#
#################################################################################


#########################################################################
#               Definicion de funciones                                 #
#########################################################################

Rcp_juncadella ()
{
#set -x
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
			grep ^${i}$ /etc/listalnx 1>/dev/null
                               if [ $? = "0" ]
			       then                                       
					/usr/bin/scp -p suc$i:$DIR_ORIGEN/$FECHA.*${i}_S $HOME_F_JUNCA 2> /dev/null
				else
					rcp -p suc$i:$DIR_ORIGEN/$FECHA.*$i $HOME_F_JUNCA 2> /dev/null
				fi
                		        STATUS_RCP=$?
                                                if [ "$STATUS_RCP" != "0" ]
                                       	        then
                                              		echo "  Error en la transferencia de archivo de suc$i \c "
                                               		echo "  Controlar si la la sucursal abrio o se genero en cero " 
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
#set -x
export FECHA="$1"
export LISTA_SUCURSALES="$2"
for SUCURSAL in $LISTA_SUCURSALES
do
	case $SUCURSAL in
		095|096|097|099)export DESTINATARIO="$JUNCADELLA_ROSARIO";;
	        178|49) 	export DESTINATARIO="$JUNCADELLA_MARDELPLATA";;
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
#	export ENVIO_OK=`[ $? = 0 ] && mail $DESTINATARIO_CTRL_CHECK -subject "Se envio OK archivo de sucursal $SUCURSAL del $FECHA" -body "`banner OK`"  || mail $DESTINATARIO_CTRAL_CHECK -subject "Error en el envio de mail de $SUCURSAL de $FECHA" -body "`banner ERROR`"` 
done

}


Mail_Juncadella ()
{
#set -x
export JUNCADELLA_BSAS="Marcelo.deCara@ar.prosegur.com Marcusdecara@hotmail.com Nicolas.Petryszyn@ar.prosegur.com"
export JUNCADELLA_STAFE="sucursal.santafe@ar.prosegur.com"
export JUNCADELLA_ROSARIO="recuento.rosario@ar.prosegur.com"
export JUNCADELLA_MARDELPLATA="mardelplata.tesoreria@ar.prosegur.com, mardelplata.recuento@ar.prosegur.com"
export FECHA="$1"
export LISTA_SUCURSALES="$2"
export DIR_ARCHIVO="/sfctrl/data/descarga"
for SUCURSAL in $LISTA_SUCURSALES
do
        case $SUCURSAL in
                095|096|097|099)export DESTINATARIO="$JUNCADELLA_ROSARIO";;
                178|049)         export DESTINATARIO="$JUNCADELLA_MARDELPLATA";;
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
grep ${i} /etc/listalnx 1>/dev/null
if [ $? = "0" ]
then
	export CHCK_UUENCODE=`ssh $HOST "[ -s /usr/bin/uuencode ] && echo OK || echo NO_OK"`
	if [ $CHCK_UUENCODE = "OK" ]
	then
        ssh $HOST "uuencode $DIR_ARCHIVO/$FECHA.$NRO_SUCURSAL $FECHA.$NRO_SUCURSAL |mail -s 'Mail Juncadella: Archivo de sucursal $SUCURSAL del $FECHA' -c $DESTINATARIO $DESTINATARIO_CTRAL_CHECK"
	else
	uuencode $FECHA.$NRO_SUCURSAL $FECHA.$NRO_SUCURSAL| mail -s "$NRO_SUCURSAL no tiene uuencode" $DESTINATARIO_CTRAL_CHECK
	fi
else
	export CHCK_UUENCODE=`ssh $HOST "[ -s /usr/bin/uuencode ] && echo OK || echo NO_OK"`
        if [ $CHCK_UUENCODE = "OK" ]
        then
        ssh $HOST "uuencode $DIR_ARCHIVO/$FECHA.$NRO_SUCURSAL $FECHA.$NRO_SUCURSAL |mail -s 'Mail Juncadella: Archivo de Sucursal $SUCURSAL del $FECHA' -c $DESTINATARIO $DESTINATARIO_CTRAL_CHECK"
        else
        uuencode $FECHA.$NRO_SUCURSAL $FECHA.$NRO_SUCURSAL|mail -s "$NRO_SUCURSAL no tiene uuencode" $DESTINATARIO_CTRAL_CHECK
	fi
fi
done
}

Mail_zip ()
{
set -x
export LFECHA="$1"
export DESTINATARIO="$2"

if [ "`ls -1 $LFECHA.* 2> /dev/null|wc -l|awk '{print $1}'`" != "0" ]
then
	zip $LFECHA.zip $LFECHA.*
 	uuencode $LFECHA.zip $LFECHA.zip |mail -s "Archivos Juncadella" $DESTINATARIO@redcoto.com.ar 
else
	echo "\n\t NO HAY ARCHIVOS PARA ENVIAR ..."
fi
}


##################################################################################
##################################################################################

#########################################################################
#               Definicion de variables                                 #
#########################################################################
export OPERADOR_WRK="/tecnol/operador/noche"
export Banner="$OPERADOR_WRK/Banner.ksh"
export PATH_MENU="/tecnol/operador/noche"
export PATH_MENU_TMP="$PATH_MENU/tmp"
export PATH_MENU_LOGS="$PATH_MENU/logs"
export FECHA="`cat $PATH_MENU/fecha.dat`"

export OPCION="";
export FECHA_tmp="$PATH_MENU_TMP/FECHA.tmp"
#export LIS_SUC_JUNC=$LISTALNX
export LIS_SUC_JUNC="02 06 07 18 19 20 22 24 25 26 35 37 38 39 40 41 42 43 44 45 46 47 48 49 51 52 53 54 55 56 57 59 60 61 63 64 65 66 67 68 69 70 71 74 75 78 80 82 83 84 85 88 90 91 92 94 95 96 97 99 101 102 103 104 105 107 108 109 110 111 116 117 118 121 123 124 125 129 130 131 135 136 137 142 143 149 151 153 154 156 158 159 160 163 164 165 166 167 168 170 171 173 174 175 176 177 178 180 181" 
export LIS_SUC_JUNC="01 02 06 07 13 18 19 20 22 24 25 26 35 37 38 39 40 41 42 43 44 45 46 47 48 49 51 52 53 54 55 56 57 58 59 60 61 63 64 65 66 67 68 69 70 71 74 75 78 80 82 83 84 85 88 90 91 92 94 95 96 97 99 101 102 103 104 105 107 108 109 110 111 116 117 118 120 121 123 124 125 129 130 131 135 136 137 142 143 149 151 152 153 154 155 158 159 160 162 163 164 165 166 167 168 170 171 174 175 176 177 178 179 180 181 183 186 188 189" 
export SUC_ERROR_ALL="$PATH_MENU_TMP/junca_faltante.tmp"
export SUC_ERROR_SELECS="$PATH_MENU_TMP/junca_faltante_selecs.tmp"
export HOME_F_JUNCA="$PATH_MENU/juncadella"
export USER="OperadoresUX@redcoto.com.ar"

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
	echo " 6) Agregar sucursal a la lista de sucursales que utilizan recuento (punto 1)"
	echo
	echo " 7) Enviar los archivos por mail"
	echo
	echo " 8) Enviar por mail un zip con todos los archivos "
	echo 
	echo " 9) Depurar archivos viejos"
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
			Rcp_juncadella "$LIS_SUC_JUNC" "$SUC_ERROR_ALL"
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
			echo "\tDesea cambiarla ( ddmm ) (s/n): \c"
			read RESP
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
		6)	$Banner " Agregar sucursal a la lista "
			echo 
			echo "	NO DISPONIBLE POR AHORA ....!!! "
			;;
		7)	$Banner " Enviar mail a Juncadella "
			echo
			cd $HOME_F_JUNCA
			export SUCS_MAIL="`ls $FECHA.*|awk '{print substr($1,6,3)}' 2> /dev/null`"
			Mail_Juncadella "$FECHA" "$SUCS_MAIL"
			mv $FECHA.* ./enviados/. 2> /dev/null
			;;
		8)	$Banner " Enviar zip con los archivos por mail  "
			echo
			#echo "	Ingrese su direccion de mail: \c"
			#read USER 
			USER=operadoresUX
			cd $HOME_F_JUNCA
			Mail_zip "$FECHA" "$USER"
			mv $FECHA.* ./enviados/. 2> /dev/null
			;;
		9)	echo
			echo "Depurando archivos viejos..."
			find $HOME_F_JUNCA/enviados -mtime "+3" -exec rm {} \;
	esac
	if [ "$OPCION" != "s" -a "$OPCION" != "S" ]
	then
		echo    
		echo "	Presione <enter> para continuar";read enter
		echo
	fi
done