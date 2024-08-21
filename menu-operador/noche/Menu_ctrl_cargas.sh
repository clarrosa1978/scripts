
#################################################################################
#										#
# SCRIPT: Ctrl_cargas								#
#										#
#										#
# DESCRIPTCION: - Controla en cada una de las sucursales las que tienen cajas	#
#		con cargas en negativo y las envia por mail a abruzzese		#
#		- Controla en cada una de las sucursales la carga de precios	#
#		de GDM y genera un informe en LOG_GDM				#
#										#
# AUTOR: Andres Bruzzese - Operaciones						#
#										#
#################################################################################


#######################################################
#	DEfinicion de funciones                       #
#######################################################

Check_cargas_negativos ()
{
export LISTA_SUCURSALES="$1"
export CARGA_CAJAS="$2"
export CHK_NEGATIVO="";
export RESULTA="$PATH_MENU_TMP/resulta.tmp"
export SUCS_NEGATIVOS="$PATH_MENU_LOGS/sucs_cajas_negativos"
export SUCS_NOCOMUNIC="$PATH_MENU_TMP/nega_no_comunic.tmp"
export TMP_INFO="$PATH_MENU_TMP/negainforme.tmp"
export CONTADOR="0"
>$SUCS_NEGATIVOS
>$SUCS_NOCOMUNIC
>$TMP_INFO

	Informe_negativos ()
	{
	export USER_MAIL="$1"
	export DOMAIN="@coto.com.ar"
	mhmail $USER_MAIL$DOMAIN -subject "Control de cargas de cajas" -body "`cat $TMP_INFO`"
	} 

echo " SucNNN...(ok) ---> No hay cajas con cargas en negativo en sucursal NNN"
echo " SucNNN.-.(X-) ---> Hay X cajas con cargas en negativo en la sucursal NNN"
echo " SucNNN.?.(NC) ---> No hay comunicacion con la sucursal NNN"
echo
echo 
echo "\t\c" >> $SUCS_NEGATIVOS
for i in $LISTA_SUCURSALES
do
        #echo "Chequeando sucursal $i ..."
	>$RESULTA
        if [ "$CONTADOR" = "5" ]
        then
                CONTADOR="1";
                echo 
        else
                CONTADOR="`expr $CONTADOR + 1`"
        fi
        export CONTADOR
        if [ "`ping -c1 suc$i 1> /dev/null 2> /dev/null ;echo $?`" -eq "0" ] 
        then 
		echo suc$i >> $RESULTA 2> /dev/null
                rsh suc$i su - sfctrl -c monmovs >> $RESULTA 2> /dev/null
                echo >> $CARGA_CAJAS
                echo "------------------------------" >> $CARGA_CAJAS
                echo >> $CARGA_CAJAS
                echo "******************************" >> $CARGA_CAJAS
                echo "******    Sucursal $i   *****     " >> $CARGA_CAJAS
                echo "******************************" >> $CARGA_CAJAS
                echo >> $CARGA_CAJAS
                cat $RESULTA  >> $CARGA_CAJAS
                CHK_NEGATIVO=`grep "-" $RESULTA |wc -l|awk '{print $1}'`
                export CHK_NEGATIVO
                if [ "$CHK_NEGATIVO" -ne "0" ]
                then
                        echo "suc$i\t\t\c" >> $SUCS_NEGATIVOS
                        echo "Suc$i.-.("$CHK_NEGATIVO"-)\t\c"
                else
                        echo "Suc$i...(ok)\t\c"
                fi
        else 
                #echo "********* No hay comunicacion con suc$i *********"
                echo "Suc$i\t\t\c" >> $SUCS_NOCOMUNIC
                echo "Suc$i.?.( NC )\t\c"
        fi
done
echo >>$TMP_INFO
echo "Sucursales con cajas con cargas en negativo:\n " >>$TMP_INFO
echo "`cat $SUCS_NEGATIVOS`\n\n" >>$TMP_INFO
if [ -s "$SUCS_NOCOMUNIC" ]
then
	echo "Sucursales sin comunicacion: `cat $SUCS_NOCOMUNIC`" >>$TMP_INFO
fi
echo 
if [ `wc -w $SUCS_NEGATIVOS|awk '{print $1}'` -gt 0 ]
then
	echo
	echo "\tDesea recibir el informe en su mail (s/n)?: \c"
	read RESP
	if [ $RESP = "s" -o $RESP = "S" ]
	then
		echo  
		echo "\t\tIngrese su nombre de usuario(NT): \c"  
		read USERNAME
		Informe_negativos "$USERNAME"
	fi
fi
}
       
Check_cargas_GDM ()
{
export LISTA_SUCURSALES="$1"
export FILE_LOG="/sfctrl/tmp/procesa_suc.log"
#export FILE_LOG="/sfctrl/ts090001.err"
export FILE_ACTMEM="/sfctrl/d/actmem.dat"
export FILE_MESSF1="/sfctrl/data/mess_f1.dat"
echo 
for i in $LISTA_SUCURSALES
do
    ping -c 2 suc"$i" >/dev/null 2>&1
    if [ $? = 0 ]; then
        echo "Suc$i...:\c "
        rsh suc$i "ls -l $FILE_LOG  2>/dev/null" |  awk '{ printf "[%s-%s;%shs]",$7,$6,$8 }' 
        rsh suc$i "tail $FILE_LOG 2>/dev/null" >/tmp/$$.log

        FSize=`ls -l /tmp/$$.log | awk '{print $5}' `
        if [ "$FSize" = "0" ]
        then
                echo " => Log vacio \t\t"
        else
                CPROCS=` grep "Procesados" /tmp/$$.log `
                STATPROCS=` grep "FIN" /tmp/$$.log `
                if [ "$CPROCS" = "" ]
                then
                        echo " => Carga incompleta"
                else
                        echo $STATPROCS | grep "0" 1>/dev/null
                        if [ $? = 0 ]
                        then
#				export DHACTMEM=`rsh suc$i "ls -l $FILE_ACTMEM  2>/dev/null" |  awk '{ printf "[%s-%s;%shs]",$7,$6,$8 }'`
	#			export DHMESSF1=`rsh suc$i "ls -l $FILE_MESSF1  2>/dev/null" |  awk '{ printf "[%s-%s;%shs]",$7,$6,$8 }'`
                                echo "=>$CPROCS [OK] \t\t " #actmem.dat actualizado ==> $DHACTMEM  mess_f1-dat actualizado ==> $DHMESSF1"
                        else
                                echo "=>$STATPROCS [ERROR]\t\t"
                        fi
                fi
        fi
    else
       echo "SUC. $i: No hay comunicacion.\t\t"
    fi
done
rm /tmp/$$.log

}


##########################################################
#	Declaracion de variables			 #
##########################################################

export OPERADOR_WRK="/tecnol/operador/noche"
export Banner="$OPERADOR_WRK/Banner.ksh"
export PATH_MENU="/tecnol/operador/noche"
export PATH_MENU_TMP="$PATH_MENU/tmp"
export PATH_MENU_LOGS="$PATH_MENU/logs"
export FECHA="`cat $PATH_MENU/fecha.dat`"

export LOG_SUCURSALES="$PATH_MENU_LOGS/carga_negativos/carga_cajas.$FECHA"
export LOG_SUCURSALES_TMP="$PATH_MENU_TMP/carga_cajas.$FECHA.tmp"
export LOG_GDM="$PATH_MENU_LOGS/carga_GDM/cargas_GDM_$FECHA.log"
export LOG_GDM_TMP="$PATH_MENU_TMP/cargas_GDM_$FECHA.tmp"
export LISTA_SUCS_GDM=`echo $LISTASUC`
#export LISTA_SUCS_GDM="01 02 06 07 13 15 18 19 20 22 24 25 26 27 29 30 31 33 35 37 38 39 40 41 42 43 44 45 46 47 48 49 51 52 53 54 55 56 57 58 59 60 61 63 64 65 66 67 68 69 70 71 74 75 78 80 82 83 84 85 88 90 91 92 94 95 96 97 99 101 102 103 104 105 107 108 109 110 111 116 117 118 120 121 123 124 125 129 130 131 135 136 137 142 143 145 149 151 152 153 154 155 156 157 158 160"

##########################################################
#	Programa principal				 #
##########################################################

echo
while [ "$OPCION" != "s" -a "$OPCION" != "S" ]
do
        $Banner "  Menu de control de cargas  ";
        echo "  Controlar cargas de negativos "
	echo "		1) Todas las sucursales"
	echo "		2) Seleccionar sucursales"
	echo
        echo "	Controlar cargas de GDM"
        echo "		3) Todas las sucursales"
        echo "		4) Seleccionar sucursales"
	echo
        echo "  s) Volver al menu anterior "
        echo
        echo ""
        echo "\t\tOPCION: \c"
        read OPCION;
        export OPCION

        case $OPCION in
                1)      $Banner " Control de cargas de negativos"
			Check_cargas_negativos "$LISTASUC" "$LOG_SUCURSALES"
                        echo
                        ;;
		2)      $Banner " Control de cargas de negativos"
			echo "\t\tSeleccionar sucursales separdas por espacio (ej: 02 107 45):\c "
			read SUCURSALES
			echo
                        Check_cargas_negativos "$SUCURSALES" "$LOG_SUCURSALES_TMP"
                        echo
                        ;;
               
                3)      $Banner " Control de cargas de GDM"
			echo "\n\n\tAguarde un momento...\n\n\tGenerando log en $LOG_GDM"
			> $LOG_GDM
		        Check_cargas_GDM "$LISTA_SUCS_GDM"|tee -a $LOG_GDM	
			echo "\n\n\tListo.\n\tDesea ver el log (s/n)? \c"
			read RESP
			if [ "$RESP" = "s" -o "$RESP" = "S" ]
			then
				pg $LOG_GDM
			fi
			;;
                4)      $Banner " Control de cargas de GDM"
                        echo "\tSeleccionar sucursales separdas por espacio (ej: 02 107 45): \c"
                        read SUCURSALES
                        echo
			>$LOG_GDM_TMP 2> /dev/null
                        echo "\tAguarde un momento...\n\n\tGenerando log en $LOG_GDM_TMP"
			echo
                        Check_cargas_GDM "$SUCURSALES"|tee -a $LOG_GDM_TMP      
                        echo "\n\n\tListo.\n\tDesea ver el log (s/n)? \c"
                        read RESP
                        if [ "$RESP" = "s" -o "$RESP" = "S" ]
                        then
                                pg $LOG_GDM_TMP
                        fi
                        ;;

	esac
	if [ "$OPCION" != "s" -a "$OPCION" != "S" ]
        then
                echo
                echo "  Presione una tecla para continuar \c";
                read tecla ;
        fi
done

