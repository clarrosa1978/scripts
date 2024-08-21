#################################################################################
# Autor.................: Andres Bruzzese - Operaciones                         #
# Usuario ..............: root                                                  #
# Objetivo..............: Cocentrar controles de storeflow                      #
# Nombre del programa...: menu_CtrlReplicas.ksh                                 # 
# Descripción...........: Controla replicas de archivos generados por cierre de #
#			  storeflow y por GDM					# 
# Modificación..........: 13/10/2001                                            #
#################################################################################


#################################################################
#               Declaracion de funciones                        #
#################################################################

                ##############################################################
                ############# CHECK REPLICAS ARCHIVOS       ##################
Check_replicas_SF ()
{
#set -x
export LISTADO_SUCURSALES="$1"  # Lista completa de sucursales
export HOST="$2"        # Servidor destino de las replicas
export L_FECHA="$3"     # Fecha de los archivos
export PATH_LOGS="$4"
export PATH_TMP="$5"

case $HOST in
        "amscentral") #Definicion de variables
                        export PATH_ARCHIVOS="/sfctrl/data/fromsucursal"
			export SUB_DIR="suc"
                        export FILES_TO_CHCK="tc03020I tc03020F opercard zeta vtadept.asc vtacard vtaplu.asc"
                ;;

        "escala1") #Definicion de variables
                        export PATH_ARCHIVOS="/online/chec"
			export SUB_DIR="suc"	
                        export FILES_TO_CHCK="vtacard"
                ;;

        "ctefte") #Definicion de variables
                        export PATH_ARCHIVOS="/u/hasar/data"
			export SUB_DIR="suc"
                        export FILES_TO_CHCK="Detalle Total Totales"
                ;;

        "precios") #Definicion de variables
                        export PATH_ARCHIVOS="/opercard"
			export SUB_DIR="suc"
                        export FILES_TO_CHCK="opercard"
                ;;
	"sp17")	#Definicion de variables
			export PATH_ARCHIVOS="/home/mggdm/intcoto/ctrlvta"
			export SUB_DIR=""
			export FILES_TO_CHCK="vtaplu.asc"
		;;
esac
export LOCAL_HOST="`[ $HOST = $(hostname -s) ] && echo TRUE || echo FALSE`" # Devuelve TRUE si no hay que hacer rsh para controlar archivos
export LISTA_SUCURS_SELECS=""
echo "\n\tIngrese sucursales a controlar (ej: 02 13 109. <enter> = todas)"
echo "\tSucursales: \c"
read LISTA_SUCURS_SELECS
if [ "$LISTA_SUCURS_SELECS" = "" ] 
then
	export INFORME="$PATH_LOGS/archivos_$HOST/informe_archivos_$HOST.$FECHA"
	export SUCURSALES="$LISTADO_SUCURSALES"
else
	export INFORME="$PATH_TMP/informe_archivos_$HOST.$FECHA.tmp"
	export SUCURSALES="$LISTA_SUCURS_SELECS"
fi

export TOTAL_COL=5
export TMP=""
export COUNT=""
export SUCS_REPLICAS_OK=":"
export SUCS_REPLICAS_NOK=":"
>$INFORME

if [ `ping -c1 $HOST 1> /dev/null 2> /dev/null;echo $? ` -eq 0 ]
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
        echo "\t SucXXX.!.(Y/$TOTAL_ARCHIVOS) -----> La sucursal genero Y de los $TOTAL_ARCHIVOS archivos "
        echo "--------------------------------------------------------------" >> $INFORME
        echo "--------------------------------------------------------------" >> $INFORME
        echo "$TMP" >> $INFORME
        echo "--------------------------------------------------------------\c" >> $INFORME
	echo
        export COUNT_COL=0
        for i in $SUCURSALES
        do
                echo "\nSuc$i:\c" >> $INFORME
                export COUNT=0
                for ARCHIVOS in $FILES_TO_CHCK
                do
			case $SUB_DIR in
				"suc") if [ $HOST = ctefte -a `echo $i|awk '{print length($1)}'` = 2 ]
					then
						export FILE="$PATH_ARCHIVOS/"$SUB_DIR"0"$i"/$ARCHIVOS.$L_FECHA*"
					else
						export FILE="$PATH_ARCHIVOS/"$SUB_DIR$i"/$ARCHIVOS.$L_FECHA*"
					fi
					;;
				"") export FILE="$PATH_ARCHIVOS/$ARCHIVOS.*$i";;
			esac
                        if [ $LOCAL_HOST != TRUE ]
                        then
                                export CHK_FILE=`rsh $HOST " [ -s $FILE ] && echo TRUE ||echo FALSE"`
                        else
                                export CHK_FILE="` [ -s $FILE ] && echo TRUE ||echo FALSE`"
                        fi
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
                        export SUCS_REPLICAS_OK="$SUCS_REPLICAS_OK $i"
                else
                        echo "\tSuc$i.!.($COUNT/$TOTAL_ARCHIVOS)\c"
                        export SUCS_REPLICAS_NOK="$SUCS_REPLICAS_NOK $i"
                fi
        done
        echo
        echo
        if [ "$SUCS_REPLICAS_OK" != ":" ]
        then
                echo " Sucursales con replicas completas $SUCS_REPLICAS_OK"
        fi
        echo
        if [ "$SUCS_REPLICAS_NOK" != ":" ]
        then
                echo " Sucursales con replicas incompletas $SUCS_REPLICAS_NOK"
        fi
else
        echo "\n\t\t!!! NO HAY CONECTIVIDAD CON $HOST !!!!!"
fi

}

                ############# FIN CHECK ARCHIVOS            #############
                #########################################################


		#########################################################
		############# CHECK  ARCHIVOS EN SUCURSAL   #############

Check_archivos_origen ()
{
export FROM_HOST="$1"  # Lista de sucursales donde controlar archivos
export INFORME="$2"     # Path y nombre de archivo donde se generara el log
export L_FECHA="$3"     # Fecha de los archivos
export PATH_TMP="$4"	# Path para generar archivos temporales
#set -x 
export PATH_ARCHIVOS="/sfctrl/data/descarga"
export FILES_TO_CHCK="ts03020I ts03020F opercard zeta vtadept vtacard vtaoperc vtaplu Totales Total Detalle"
export TOTAL_COL=2
export TMP=""
export TEMPORAL="$PATH_TMP/control_archivos_suc.tmp" 
export COUNT=""
export SUCS_REPLICAS_OK=":"
export SUCS_REPLICAS_NOK=":"
>$INFORME

        export COUNT=0
        for ARCHS in $FILES_TO_CHCK                     # Armo el titulo del
        do                                              # informe de archivos
                COUNT="`expr $COUNT + 1`"
                echo "\t$COUNT) ===> $ARCHS.$L_FECHA*" >> $INFORME       #
                TMP="$TMP\t($COUNT)"
        done
        export TOTAL_ARCHIVOS="$COUNT"
        cat $INFORME |awk -F "*" '{print $1}'
        echo "--------------------------------------------------------------" >> $INFORME
        echo "--------------------------------------------------------------" >> $INFORME
        echo "$TMP" >> $INFORME
        echo "--------------------------------------------------------------\c" >> $INFORME
	echo
export COUNT_COL=1

for SUC in $FROM_HOST
do
        echo "\nSuc$SUC:\c" >> $INFORME
	echo "Suc$SUC...(\c"
	if [ `ping -c1 suc$SUC 1> /dev/null 2> /dev/null;echo $? ` -eq 0 ]
	then
                export COUNT=0
		rsh suc$SUC ls -ltr $PATH_ARCHIVOS/*.$L_FECHA* 2> /dev/null|awk '{print $9 " " $5}' > $TEMPORAL
                for ARCHIVOS in $FILES_TO_CHCK
                do
			COUNT=`expr $COUNT + 1`
			export CHK_FILE=""
			export CHK_FILE="`grep "$ARCHIVOS"."$L_FECHA" $TEMPORAL`"
			export CHK_SIZE=""
			export CHK_SIZE="`grep "$ARCHIVOS"."$L_FECHA" $TEMPORAL|awk '{print $2}' 2>/dev/null`"
			if [ "$CHK_FILE" = "" ]
			then
				echo "\tError\c">>$INFORME
				echo " .\c"
			else
				if [ "$CHK_SIZE" = "0" ]
				then
					echo " 0.\c"
					echo "\tVACIO\c">>$INFORME
				else
					echo "$COUNT.\c"
					echo "\tOK\c">>$INFORME
				fi
			fi
                done
	else
		echo "    S I N   V I N C U L O  ! ! ! ! \c">>$INFORME
		echo " Sin  Vinculo !! )\c\t"
	fi
        if [ $COUNT_COL = $TOTAL_COL ]
        then
		COUNT_COL=1;
                echo ")"
        else
                COUNT_COL=`expr $COUNT_COL + 1`
                echo ")\t\c"
        fi
        if [ $COUNT = $TOTAL_ARCHIVOS ]
        then
        	export SUCS_REPLICAS_OK="$SUCS_REPLICAS_OK $i"
        else
                export SUCS_REPLICAS_NOK="$SUCS_REPLICAS_NOK $i"
        fi
done
echo
echo
#if [ "$SUCS_REPLICAS_OK" != ":" ]
 #       then
  #            #  echo " Sucursales con replicas completas $SUCS_REPLICAS_OK"
   #     fi
    #    echo
#
 #       echo
  ##      if [ "$SUCS_REPLICAS_NOK" != ":" ]
    #    then
     #           echo " Sucursales con replicas incompletas $SUCS_REPLICAS_NOK"
      #  fi

}

	########### FIN  CHECK  ARCHIVOS EN SUCURSAL  ############
	##########################################################


##################################################################################
##################################################################################


Es_domingo ()
{
export FECHA_CONSULTA=$1        # Recibe la fecha en formato ddmmaaaa
export DIA="`echo $FECHA_CONSULTA|cut -c1-2`"
if [ `echo $DIA|cut -c1-1` = 0 ]
then
        export DIA="`echo $FECHA_CONSULTA|cut -c2-2`"
fi 
export MES="`echo $FECHA_CONSULTA|cut -c3-4`"
export ANIO="`echo $FECHA_CONSULTA|cut -c5-8`"
export DOMINGOS="`cal $MES $ANIO|grep -v Sun |awk '{ print $1}'|grep $DIA`" 
if [ "$DOMINGOS" = "$DIA" ]
then
        echo "0" #Devuelve 0 si la fecha ingresado como argumento es domingo
else
        echo "1"
fi
}
################################################################

#####################################################################################
###############################################################################################
###############################################################################################
###############################################################################################

#################################################################
#               Declaracion de variables                        #
#################################################################
export PATH_MENU="/home/root/operador/andres/menu_oper"
export PATH_MENU_TMP="$PATH_MENU/tmp"
export PATH_MENU_LOGS="$PATH_MENU/logs"
export FECHA="`cat $PATH_MENU/fecha.dat`"
export FECHA_CTEFTE="$FECHA"2002""
export OPERADOR_WRK="/tecnol/operador"
export OPCION=""
export Banner="$OPERADOR_WRK/Banner.ksh"
if [ "`Es_domingo $FECHA_CTEFTE`" != "0" ]
then
        export LISTA_SUCURSALES="01 02 06 07 08 13 14 15 18 19 20 21 22 24 25 26 27 29 30 31 33 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 51 52 53 54 55 56 57 58 59 60 61 63 64 65 66 67 68 69 70 71 74 75 78 80 82 83 84 85 88 90 91 92 94 95 96 97 99 101 102 103 104 105 107 108 109 110 111 116 117 118 120 121 123 124 125 129 130 131 135 136 137"
else
        export LISTA_SUCURSALES="02 07 13 24 37 38 43 43 43 43 44 45 47 48 49 51 54 55 56 57 58 59 60 61 63 64 65 66 67 68 69 70 71 75 78 80 82 83 84 85 88 90 91 92 94 95 96 97 99 103 104 105 107 108 109 110 111 117 118 120 121 123 124 125 129 130 131 135 136 137"
fi

export LISTA_SUCURS_SELECS="$LISTA_SUCURSALES"
########################################################################################
########################################################################################


while [ "$OPCION" != "s" -a "$OPCION" != "S" ]
do
	$Banner "    Menu de  control de replicas "
	echo "	1 ) Control de archivos generados en sucursales por el cierre de Storelfow" 
	echo
	echo "	------- Control de Replicas de cierre de Storeflow --------- "
	echo
	echo "	2 ) AMSCENTRAL "
	echo "	3 ) ESCALA1"
	echo "	4 ) CTEFTE" 
	echo "	5 ) PRECIOS"
	echo "	6 ) SP17"
	echo
	echo "	--------- Control de Replicas de GDM ------------"
	echo 
	echo "	8 ) Ajustes de cedeco "
	echo "	9 ) Devoluciones a proveedores"
	echo "	10) Remitos valorizados"
	echo "	11) Sobrantes y faltantes"
	echo "	12) Surtidos"
	echo "	13) Traspasos y decomisos"
	echo "	14) Cambios entre sucursales"
	echo "	15) Vales de material"
	echo
	echo "	S ) Volver al menu anterior"
	echo
	echo "		OPCION: \c"
	read OPCION
	echo
	case $OPCION in
                1)      export SUCS_SELEC=""
			echo "\n\tIngrese sucursales a controlar (ej: 02 13 109. <enter> = todas)"
			echo "\tSucursales: \c"
			read SUCS_SELEC
			if [ "$SUCS_SELEC" = "" ]
			then
        			export SUCURSALES="$LISTA_SUCURSALES"
			else
        			export SUCURSALES="$SUCS_SELEC"
			fi
			$Banner " Control de archivos generados por cierre"
                        Check_archivos_origen "$SUCURSALES" "$PATH_MENU_TMP/archivos.tmp" "$FECHA" "$PATH_MENU_TMP"
#                       pg $INFORME_ARCHIVOS
                        ;;
                2)      $Banner " Control de replicas de archivos a AMSCENTRAL"
                        Check_replicas_SF "$LISTA_SUCURSALES" "amscentral" "$FECHA" "$PATH_MENU_LOGS" "$PATH_MENU_TMP";
                        ;;
                3)      $Banner " Control de replicas de archivos a ESCALA1"
                        echo
                        Check_replicas_SF "$LISTA_SUCURSALES" "escala1" "$FECHA" "$PATH_MENU_LOGS" "$PATH_MENU_TMP";
                        ;;
                4)      $Banner " Control de replicas de archivos a CTEFTE"
                        Check_replicas_SF "$LISTA_SUCURSALES" "ctefte" "$FECHA_CTEFTE" "$PATH_MENU_LOGS" "$PATH_MENU_TMP";
                        ;;
                5)      $Banner " Control de replicas de archivos a PRECIOS"
                        Check_replicas_SF "$LISTA_SUCURSALES" "precios" "$FECHA" "$PATH_MENU_LOGS" "$PATH_MENU_TMP";
                        ;;
                6)      $Banner " Control de replicas de archivos a SP17"
                        Check_replicas_SF "$LISTA_SUCURSALES" "sp17" "$FECHA" "$PATH_MENU_LOGS" "$PATH_MENU_TMP";
                        ;;
        esac            
        if [ "$OPCION" != "s" -a "$OPCION" != "S" ]
        then
                echo
                echo "  ** Presione <enter> para continuar **\c";
                read tecla ;
        fi


done

