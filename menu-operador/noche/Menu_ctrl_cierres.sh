#################################################################################
# Autor.................: Andres Bruzzese - Operaciones				#
# Usuario ..............: root	 						#
# Objetivo..............: Cocentrar controles de storeflow		 	#
# Nombre del programa...: menu_CtrlCierres.ksh					# 
# Descripción...........: Controla estado de sucursales y replica de archivos	#
#			  generados por cierre de storeflow			#
# Modificación..........: 12/09/2001						#
#################################################################################

#################################################################
#		Declaracion de funciones			#
#################################################################

		##############################################################
		############# CHECK SUCURSALES CERRADAS	    ################## 

Check_suc_cerradas ()
{
export SUCURSALES="$1"		#Sucursales a las cuales se les quiere chequear su estado (abierta/cerrada)
export COUNT=0 
export MAX_CANT_COL=4 		#Cantidad de columnas del display
export DB_PROCS="ora_lgwr_SF|ora_smon_SF|ora_reco_SF|ora_pmon_SF|ora_dbwr_SF" #Procesos que tienen que estar activos para que se considere que esta la base de Storeflow levantada
export CHK_DB_SF="ps -ef|egrep '$DB_PROCS'|grep -v grep|wc -l"
export CERRADAS=":"
export ABIERTAS=":"
export SINCOMUNIC=":"

if [ "$SUCURSALES" != "s" -o "$SUCURSALES" != "S" ]
then
	for i in $SUCURSALES
	do
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
						ABIERTAS="$ABIERTAS $i"
						;;
					2)	echo "(CERRADA)\c"
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
			SINCOMUNIC="$SINCOMUNIC $i";
		fi	# Check de comunicacion con sucursal
	done
	echo
	echo 
	if [ "$ABIERTAS" != ":" ]
	then
		echo "Sucursales abiertas $ABIERTAS\n"
	fi
	if [ "$CERRADAS" != ":" ]
	then
		echo "Sucursales cerradas $CERRADAS"
	fi
	if [ "$SINCOMUNIC" != ":" ]
	then
		echo "Sucursales sin vinculo: $SINCOMUNIC\n"
	fi

else
	echo
	echo " No hay sucursales seleccionadas \n Verifique !!!"
fi

}

		############# FIN CHECK SUCURSALES CERRADAS #############
		#########################################################

		#########################################################
		############# INICIO CHECK DE CIERRE DE SF ##############

Check_cierre_sf ()	# Hasta que no se me ocurra hacer algo nuevo, se utiliza 
{			# el script planilla
#set -x
export SUCURSALES="$1"
export FECHA="$2"
export CHECK_LOG="$3"


export DIR_CTM_OUT="/home/ctm/agent/ctm/sysout"
export SUC_TMP="$PATH_MENU_TMP/contenido"
export SUC_TMP2="$PATH_MENU_TMP/contenido2"
export SIN_FIN_COMPLETO=":"
export NO_CERRADAS=":"
export CERRADAS=":"
export SINCOMUNIC=":"
export DIA="`echo $FECHA|cut -c1-2`"
export MES="`echo $FECHA|cut -c3-4`"
export FECHA_LOG="$MES$DIA"
export COUNT=0
export MAX_CANT_COL=4           #Cantidad de columnas del display

if [ "$SUCURSALES" != "s" -o "$SUCURSALES" != "S" ]
then
	echo 
        for i in $SUCURSALES
        do
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
			rsh suc$i "ls -1t /sfctrl/data/descarga/mpago*|grep $FECHA_LOG 2> /dev/null" > $SUC_TMP
			if [ -s $SUC_TMP ]
			then
				>$SUC_TMP
          			rsh suc$i "grep compress $DIR_CTM_OUT/obttlog.sh.LOG*|grep $FECHA_LOG" 2> /dev/null >$SUC_TMP
				if [ -s $SUC_TMP ]
				then
					cat $SUC_TMP >> $SUC_TMP2
					echo "(Completo)\c"
				else
					cat $SUC_TMP >> $SUC_TMP2
					echo "\n\c" >> $SUC_TMP2
					echo "(Incompleto)\c"
					export SIN_FIN_COMPLETO="$SIN_FIN_COMPLETO $i"
				fi
			else
				echo "(Sin cerrar)\c"
				export NO_CERRADAS="$NO_CERRADAS $i"
			fi
    		else
                        echo "(Sin vinculo)\c"
                        SINCOMUNIC="$SINCOMUNIC $i";
                fi      # Check de comunicacion con sucursal
        done
        echo
        echo
        if [ "$NO_CERRADAS" != ":" ]
        then
                echo "No arrancaron cierre de StoreFlow $NO_CERRADAS\n"
        fi
        if [ "$SIN_FIN_COMPLETO" != ":" ]
        then
                echo "Sucursales sin fin completo $SIN_FIN_COMPLETO\n"
        fi
        if [ "$SINCOMUNIC" != ":" ]
        then
                echo "Sucursales sin vinculo $SINCOMUNIC\n"
        fi

else
        echo
        echo " No hay sucursales seleccionadas \n Verifique !!!"
fi


#    sed 's/;/ /g' $SUC_TMP2 > $SUC_TMP

}

		############# FIN CHECK DE CIERRE DE SF #################
		#########################################################

Es_domingo ()
{
set -x
export FECHA_CONSULTA=$1	# Recibe la fecha en formato ddmmaaaa
export DIA="`echo $FECHA_CONSULTA|cut -c1-2`"
if [ `echo $DIA|cut -c1-1` = 0 ]
then
	export DIA="`echo $FECHA_CONSULTA|cut -c2-2`"
fi 
export MES="`echo $FECHA_CONSULTA|cut -c3-4`"
export ANIO="`echo $FECHA_CONSULTA|cut -c5-8`"
export DOMINGOS="`cal $MES $ANIO|grep -v Sun |awk '{ print $1}'|grep $DIA|head -1`"
if [ "$DOMINGOS" = "$DIA" ]
then
	echo "0"
else
	echo "1"
fi
}

 
###############################################################################################
###############################################################################################
###############################################################################################

#################################################################
#		Declaracion de variables			#
#################################################################
export PATH_MENU="/tecnol/operador/noche"
export PATH_MENU_TMP="$PATH_MENU/tmp"
export PATH_MENU_LOGS="$PATH_MENU/logs"
export FECHA="`cat $PATH_MENU/fecha.dat`"

export OPCION="";
export SQL_CTRL="sqlplus -s u601/u601 @/sfctrl/util/centro"
export INFORME_ARCHIVOS="$PATH_MENU_LOGS/archivos_amscentral/informe_archivos_amscentral.$FECHA"
export INFORME_ARCHIVOS_ESCALA="$PATH_MENU_LOGS/archivos_escala1/informe_archivos_escala.$FECHA"
export INFORME_ARCHIVOS_CTEFTE="$PATH_MENU_LOGS/archivos_ctefte/informe_archivos_ctefte.$FECHA"
export INFORME_ARCHIVOS_PRECIOS="$PATH_MENU_LOGS/archivos_precios/informe_archivos_precios.$FECHA"
export INFORME_TMP="$PATH_MENU_TMP/informe_$FECHA.tmp"
export FECHA_CTEFTE="$FECHA"2004""
export OPERADOR_WRK="/tecnol/operador/noche"
export Banner="$OPERADOR_WRK/Banner.ksh"
if [ "`Es_domingo $FECHA_CTEFTE`" != "0" ] 
then
	export LISTA_CUSURSALES=`echo $LISTASUC`	
export LISTA_SUCURSALES="01 02 06 07 13 15 18 19 20 22 24 25 26 27 29 30 31 33 35 37 38 39 40 41 42 43 44 45 46 47 48 49 51 52 53 54 55 56 57 58 59 60 61 63 64 65 66 67 68 69 70 71 74 75 78 80 82 83 84 85 88 90 91 92 94 95 96 97 99 101 102 103 104 105 107 108 109 110 111 116 117 118 120 121 123 124 125 129 130 131 135 136 137 142 143 149 151 152 153 154 155 156 157 158 159 160 162 163 165 166 167"
else
	export LISTA_SUCURSALES="02 07 13 24 25 37 38 41 42 43 44 45 47 48 49 51 52 53 54 55 56 57 58 59 60 61 63 64 65 66 67 68 69 70 71 75 78 80 82 83 84 85 88 90 91 92 94 95 96 97 99 101 103 104 105 107 108 109 110 111 117 118 120 121 123 124 125 129 130 131 135 136 137 143 149 151 152 153 154 155 158 159 160 162 163 165 166 167"
fi

#################################################################
#		Principal					#
#################################################################
while [ "$OPCION" != "s" -a "$OPCION" != "S" ]
do
	$Banner "  Menu de control de cierres  ";
	echo "	Control de estado de sucursales (abiertas o cerradas) "   
	echo "	-----------------------------------------------------"
	echo "	\t1) Todas las sucursales"
	echo "	\t2) Seleccionar sucursales"
	echo
	echo "	Controlar estado de cierre de Storeflow "
	echo "	----------------------------------------------------------------" 
	echo "	\t3) Todas las sucursales"
	echo "	\t4) Seleccionar sucursales"
	echo
	echo
	echo "		s) Volver al menu anterior "
	echo
	echo ""
	echo "\t\tOPCION: \c"
	read OPCION;
	export OPCION
#	export FECHA="`cat $PATH_MENU/fecha.dat`"
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
		3)	$Banner " Control de cierre de storeflow "
			Check_cierre_sf "$LISTA_SUCURSALES" "$FECHA" 
			;;
		4)	$Banner " Control de cierre de storelfow"
			echo "\n\tIngrese sucursales a controlar (ej: 02 13 109): \c"
			read LISTA_SUCURS_SELECS
			Check_cierre_sf "$LISTA_SUCURS_SELECS" "$FECHA"
			;;
	esac		
        if [ "$OPCION" != "s" -a "$OPCION" != "S" ]
        then
                echo
                echo "	** Presione <enter> para continuar **\c";
                read tecla ;
        fi


done
