#################################################################################
# Autor.................: Andres Bruzzese - Operaciones				#
# Usuario ..............: operador 						#
# Objetivo..............: Concentrar las tareas de operaciones en un menú 	#
# Nombre del programa...: menu_CtrlCierres.ksh					# 
# Descripción...........: Despliega el menú principal del usuario Operador 	#
# Modificación..........: 21/07/2001						#
#################################################################################

#################################################################
#		Declaracion de funciones			#
#################################################################

		####################################################
		############ CHECK ARCHIVOS AMSCENTRAL #############

Check_archivos ()
{
export PATH_ARCHIVOS="/sfctrl/data/fromsucursal"
export SUCURSALES="$1"
export INFORME="$2"
export FILES_TO_CHCK="tc03020I tc03020F opercard zeta vtadept.asc vtacard vtaplu.asc"
export TOTAL_COL=5
export TMP=""
export COUNT=""

>$INFORME
if [ "$SUCURSALES" != "s" -o "$SUCURSALES" != "S" ]
then
	export COUNT=0
	for ARCHS in $FILES_TO_CHCK      		# Armo el titulo del 
	do  						# informe de archivos
		COUNT="`expr $COUNT + 1`"
		echo "\t$COUNT) ===> $ARCHS" >> $INFORME	#
	        TMP="$TMP\t($COUNT)"
	done
	export TOTAL_ARCHIVOS="$COUNT"
	echo "\n\t SucXXX...(OK) -----> La sucursal genero los $TOTAL_ARCHIVOS archivos"
	echo "\t SucXXX.!.(Y/$TOTAL_ARCHIVOS) -----> La sucursal genero Y de los $TOTAL_ARCHIVOS archivos"
	echo "\t SucXXX.?.(NC) -----> No hay comunicacion con la sucursal\n"

	echo "--------------------------------------------------------------" >> $INFORME
	echo "$TMP" >> $INFORME
	echo "--------------------------------------------------------------\c" >> $INFORME
	export COUNT_COL=0
	for i in $SUCURSALES
	do
		echo "\nSuc$i:\c" >> $INFORME
		export COUNT=0
		for ARCHIVOS in $FILES_TO_CHCK
		do
			if [ ! -s "$PATH_ARCHIVOS/suc$i/$ARCHIVOS.$FECHA" ]
			then
				echo "\tError\c">>$INFORME
			else
				COUNT=`expr $COUNT + 1`
				echo "\tOK\c">>$INFORME
			fi
		done
		if [ $COUNT_COL = $TOTAL_COL ]
		then
			COUNT_COL=1;
			echo
		else
			COUNT_COL=`expr $COUNT_COL + 1`
		fi
		if [ $COUNT = $TOTAL_ARCHIVOS ]
		then
			echo "\tSuc$i...(OK)\c"
		else
			echo "\tSuc$i.!.($COUNT/$TOTAL_ARCHIVOS)\c"
		fi
	done
	echo
fi
	
} 	
		############# FIN CHECK ARCHIVOS AMSCENTRAL ##################
		##############################################################


                ####################################################
                ############ CHECK VTACARD ESCALA1 #################

Check_vtacard_escala ()
{
export PATH_ARCHIVOS="/online/chec"
export SUCURSALES="$1"
export INFORME="$2"
export FILES_TO_CHCK="vtacard"
export TOTAL_COL=5
export TMP=""
export COUNT=""
>$INFORME

if [ "$SUCURSALES" != "s" -o "$SUCURSALES" != "S" ]
then
        export COUNT=0
        for ARCHS in $FILES_TO_CHCK                     # Armo el titulo del
        do                                              # informe de archivos
                COUNT="`expr $COUNT + 1`"
                echo "\t$COUNT) ===> $ARCHS" >> $INFORME       #
                TMP="$TMP\t($COUNT)"
        done
        export TOTAL_ARCHIVOS="$COUNT"
        echo "\n\t SucXXX...(OK) -----> La sucursal genero los $TOTAL_ARCHIVOS archivos"
        echo "\t SucXXX.!.(Y/$TOTAL_ARCHIVOS) -----> La sucursal genero Y de los $TOTAL_ARCHIVOS archivos"
        echo "\t SucXXX.?.(NC) -----> No hay comunicacion con la sucursal\n"

        echo "--------------------------------------------------------------" >> $INFORME
        echo "$TMP" >> $INFORME
        echo "--------------------------------------------------------------\c" >> $INFORME
        export COUNT_COL=0
        for i in $SUCURSALES
        do
                echo "\nSuc$i:\c" >> $INFORME
                export COUNT=0
                for ARCHIVOS in $FILES_TO_CHCK
                do
			export CHK_FILE=`rsh escala1 " [ -s $PATH_ARCHIVOS/suc$i/$ARCHIVOS.$FECHA ] && echo TRUE ||echo FALSE"`
                        if [ "$CHK_FILE" = "FALSE" ]
                        then
                                echo "\tError\c">>$INFORME 
                        else
                                COUNT=`expr $COUNT + 1`
                                echo "\tOK\c">>$INFORME
                        fi
                done
                if [ $COUNT_COL = $TOTAL_COL ]
                then
                        COUNT_COL=1;
                        echo
                else
                        COUNT_COL=`expr $COUNT_COL + 1`
                fi
                if [ $COUNT = $TOTAL_ARCHIVOS ]
                then
                        echo "\tSuc$i...(OK)\c"
                else
                        echo "\tSuc$i.!.($COUNT/$TOTAL_ARCHIVOS)\c"
                fi
        done
        echo
fi

}
                ############# FIN CHECK VTACARD ESCALA1  #####################
                ##############################################################


		##############################################################
		############# CHECK SUCURSALES CERRADAS	    ################## 

Check_suc_cerradas ()
{

export TMP_LOG="$PATH_MENU_TMP/estado.log"
export SUCURSALES="$1"
export COUNT=0 
export MAX_CANT_COL=4
export TMP_ABIERTAS="$PATH_MENU_LOGS/abiertas.tmp"
export TMP_CERRADAS="$PATH_MENU_LOGS/cerradas.tmp"
export TMP_SINCOMUNIC="$PATH_MENU_LOGS/sincomunic.tmp"
export DB_PROCS="ora_lgwr_SF|ora_smon_SF|ora_reco_SF|ora_pmon_SF|ora_dbwr_SF"
export CHK_DB_SF="ps -ef|egrep '$DB_PROCS'|grep -v grep|wc -l"
export CERRADAS=" "
export ABIERTAS=" "
>$TMP_ABIERTAS
>$TMP_CERRADAS
>$TMP_SINCOMUNIC

if [ "$SUCURSALES" != " " ]
then
	for i in $SUCURSALES
	do
		> $TMP_LOG
		if [ $COUNT = $MAX_CANT_COL ]
		then 
			COUNT=1
			echo
		else
			COUNT="`expr $COUNT + 1`"
		fi
		echo "\tSuc$i...\c"
		ping -c1 suc$i >/dev/null 2> /dev/null
		STATUS=$?
		if [ "$STATUS" = "0" ]
		then
			export CHK_DB_SF_SUC="`rsh suc$i $CHK_DB_SF`"
			if [ $CHK_DB_SF_SUC = 5 ] 
			then
	 			export SUC_CTRL_CIERRES="`rsh suc$i su - sfctrl -c $SQL_CTRL 2>/dev/null|grep -v Correo|tail -1`" 
				case "$SUC_CTRL_CIERRES" in
					1)	echo "(ABIERTA)\c"
						echo " $i\c" >> $TMP_ABIERTAS
						ABIERTAS="$ABIERTAS $i"
						;;
					2)	echo "(CERRADA)\c"
						echo " $i\c" >> $TMP_CERRADAS
						CERRADAS="$CERRADAS $i";
						;;
					*)	echo "(!??!??!)\c"
						;;
				esac 
			else
				echo "(NO_DB_SF)\c"
			fi    # Check de instancia de Storeflow
		else
			echo "(Sin vinculo)\c"
			echo " $i\c" >> $TMP_SINCOMUNIC
		fi	# Check de comunicacion con sucursal
	done
	echo
	echo 
	if [ -s $TMP_ABIERTAS ]
	then
	#	echo "Sucursales abiertas: `cat $TMP_ABIERTAS`\n"
		echo "Sucursales abiertas: $ABIERTAS\n"
	fi
	if [ -s $TMP_CERRADAS ]
	then
	#	echo "Sucursales cerradas: `cat $TMP_CERRADAS`\n"
		echo "Sucursales cerradas: $CERRADAS"
	fi
	if [ -s $TMP_SINCOMUNIC ]
	then
		echo "Sucursales sin vinculo: `cat $TMP_SINCOMUNIC`\n"
	fi

else
	echo
	echo " No hay sucursales seleccionadas \n Verifique !!!"
fi

rm $TMP_ABIERTAS 2> /dev/null
rm $TMP_CERRADAS 2> /dev/null
rm $TMP_SINCOMUNIC 2> /dev/null
}

		############# FIN CHECK SUCURSALES CERRADAS #############
		#########################################################

###############################################################################################
###############################################################################################
###############################################################################################

#################################################################
#		Declaracion de variables			#
#################################################################
export PATH_MENU="/tecnica/operador"
export PATH_MENU_TMP="$PATH_MENU/tmp"
export PATH_MENU_LOGS="$PATH_MENU/log"
export PATH_MENU_VARS="$OPERADOR_UTL"
export FECHA="`cat $PATH_MENU_VARS/fecha.dat`"
export FECHA_PROC="$PATH_MENU/fecha.dat"
export LISTA_SUCURSALES="`cat $PATH_MENU_VARS/listado_sucursales_sf`"
#export LISTA_SUCURSALES="`cat $PATH_MENU_VARS/listado_sucursales_sf_domingo`"
export OPCION="";
export LISTA_SUCURS_SELECS="todas"
export SQL_CTRL="sqlplus -s u601/u601 @/sfctrl/util/centro"
export INFORME_ARCHIVOS="$PATH_MENU_LOGS/archivos_amscentral/informe_archivos_amscentral.$FECHA"
export INFORME_ARCHIVOS_ESCALA="$PATH_MENU_LOGS/archivos_escala/informe_archivos_escala.$FECHA"
export INFORME_TMP="$PATH_MENU_TMP/informe_$FECHA.tmp"
export Banner="$PATH_MENU/Banner.ksh"

#################################################################
#		Principal					#
#################################################################
while [ "$OPCION" != "s" -a "$OPCION" != "S" ]
do
	$Banner "  Menu de control de cierres  ";
	echo "	Control de estado de sucursales (abiertas o cerradas) "   
	echo "	\t1) Todas las sucursales"
	echo "	\t2) Seleccionar sucursales"
	echo "	Controlar estado de cierre de Storeflow (en sucursales cerradas)"
	echo "	\t3) Todas las sucursales"
	echo "	\t4) Seleccionar sucursales"
	echo "	Control de replicas de archivos generados por cierre de storeflow"
	echo "	\t4) Todas las sucursales (amscentral)"
	echo "	\t5) Seleccionar sucursales (amscentral)"
	echo "	\t6) Todas las sucursales (escala1)"
	echo "	\t7) Seleccionar sucursales (escala1)"
	echo "	s) Volver al menu anterior "
	echo
	echo ""
	echo "\t\tOPCION: \c"
	read OPCION;
	export OPCION

	case $OPCION in
		1)	$Banner " Control de estado de sucursales"
		 	Check_suc_cerradas "$LISTA_SUCURSALES";
			echo
			;;
		2)	$Banner " Control de estado de sucs seleccionadas"
			echo "\n\tSeleccione las sucursales separadas por espacio (ej: 13 45 105 ):\n\tSucursales: \c"
			read LISTA_SUCURS_SELECS;
			echo
			Check_suc_cerradas "$LISTA_SUCURS_SELECS";
			echo
			;;
		4)	$Banner " Control de archivos generados por cierre"
			Check_archivos "$LISTA_SUCURSALES" "$INFORME_ARCHIVOS"
#			pg $INFORME_ARCHIVOS
			;;
		5)	$Banner " Control de archivos generados por cierre"
			echo "\n\tSeleccione las sucursales a controlar, o presione \n\tenter para todas (ej: 09 13 45 107): \c "
			read LISTA_SUCURS_SELECS;
			Check_archivos "$LISTA_SUCURS_SELECS" "$INFORME_TMP";
			;;
		6)	$Banner " Control de vtacard en escala1 "
			echo
			Check_vtacard_escala "$LISTA_SUCURSALES" "$INFORME_ARCHIVOS_ESCALA"
			;;
		7)	$Banner " Control de vtacard en escala1 "
			echo "\n\tIngrese sucursales a controlar (ej: 02 13 109): \c"
			read LISTA_SUCURS_SELECS
			Check_vtacard_escala "$LISTA_SUCURS_SELECS" "$INFORME_TMP"
			;;
	esac		
        if [ "$OPCION" != "s" -a "$OPCION" != "S" ]
        then
                echo
                echo "  Presione una tecla para continuar \c";
                read tecla ;
        fi


done
