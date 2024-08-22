set -x 
#################################################################################
#										#
# SCRIPT: Menu_arch_Juncadella							#
#										#
#										#
# DESCRPIPCION: Trae desde las sucursales que figuran en lis_suc_juncadella	#
#		los archivos para ser enviados a juncadella 			#
#										#
# AUTOR: Cerizola Hugo - Operacion						#
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

Mail_zip ()
{
export LFECHA="$1"

if [ "`ls -1 $LFECHA.* 2> /dev/null|wc -l|awk '{print $1}'`" != "0" ]
then
	zip $LFECHA.zip $LFECHA.*
 	uuencode $LFECHA.zip $LFECHA.zip|mail -s "Archivos Juncadella" -c "hceriz@hotmail.com" $DESTINATARIO
else
	echo "\n\t NO HAY ARCHIVOS PARA ENVIAR ..."
	mail -s "Archivos Juncadella" -c "hceriz@hotmail.com" "hcerizola@uolsinectis.com.ar" "hcerizola@coto.com.ar" -b "SIENDO LA `date +%H:%M` NO HAY ARCHIVOS PARA ENVIAR , SI FALTA ALGUNA SUC. AGUARDA, POR FAVOR EN 30 MIN. SE VUELVEN A REPLICAR.. GRACIAS..."
fi
}


#########################################################################
#               Definicion de variables                                 #
#########################################################################
export OPERADOR_WRK="/tecnol/operador"
export Banner="$OPERADOR_WRK/Banner.ksh"
export PATH_MENU="/home/root/operador/andres/menu_oper"
export PATH_MENU_TMP="$PATH_MENU/tmp"
export PATH_MENU_LOGS="$PATH_MENU/logs"
export FECHA="`cat $PATH_MENU/fecha.dat`"

export OPCION="";
export FECHA_tmp="$PATH_MENU_TMP/FECHA.tmp"
#export LIS_SUC_JUNC=$LISTASUC
export LIS_SUC_JUNC="02 19 22 24 25 38 41 42 43 44 45 46 47 48 51 52 53 54 55 56 57 58 59 60 61 63 64 65 66 67 68 69 70 71 75 78 80 82 83 84 85 90 91 92 94 95 96 97 99 101 103 104 105 107 108 109 110 111 117 118 121 123 124 129 130 131 135 136 137 142 143 149 151 153 154 156 158 159 160 163 164 165 166 167 168"
export SUC_ERROR_ALL="$PATH_MENU_TMP/junca_faltante.tmp"
export SUC_ERROR_SELECS="$PATH_MENU_TMP/junca_faltante_selecs.tmp"
export HOME_F_JUNCA="$PATH_MENU/juncadella"


Rcp_juncadella "`cat $SUC_ERROR_ALL 2> /dev/null`" "$SUC_ERROR_ALL"
cd $HOME_F_JUNCA
Mail_zip "$FECHA" "$USER"
mv $FECHA.* ./enviados/. 2> /dev/null