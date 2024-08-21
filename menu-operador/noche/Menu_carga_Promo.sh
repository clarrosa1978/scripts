
#################################################################################
#										#
# SCRIPT: Ctrl_cargas								#
#										#
#										#
# DESCRIPTCION: - Permite la carga y descarga de las promociones en las  	#
#		de los dias domingos y jueves 					#
#										#
# AUTOR: Cerizola Hugo - Operaciones						#
#										#
#################################################################################
#set -x
export OPERADOR_WRK="/tecnol/operador"
export Banner="$OPERADOR_WRK/Banner.ksh"
export PATH_MENU="/home/root/operador/hugo/menu_oper"
export PATH_MENU_TMP="$PATH_MENU/tmp"
export PATH_MENU_LOGS="$PATH_MENU/logs"
export FECHA="`cat $PATH_MENU/fecha.dat`"

Promo_Suc ()
{ 

export COMANDO="$1"
export SUCLIST="$2"


for SUCNAME in $SUCLIST
do

   echo "\nsuc$SUCNAME   \c"

    ping  -c 2 "suc$SUCNAME" >/dev/null 2>/dev/null
     if [ $? != 0 ]
     then
        #echo "\t\tNo hay comunicacion con suc$SUCNAME"
        FALLO="$FALLO suc$SUCNAME"
        continue
        exit
     fi
        rsh "suc$SUCNAME" "$COMANDO "
     if [ $? != 0 ]
     then

        echo "\t\tError al ejecutar el$COMANDO en suc$SUCNAME"
        FALLO="$FALLO suc$SUCNAME"
        continue
        exit
     fi
done
if [ "$FALLO" != "" ]
then
     echo "\n\n\tFallaron las sucursales $FALLO"
fi
}


##########################################################
#	Programa principal				 #
##########################################################

echo
while [ "$OPCION" != "s" -a "$OPCION" != "S" ]
do
	$Banner "Menu de Carga de promociones "
        echo "	Promociones Domingo Empresa01 (Sucursales)     						"
	echo "	------------------------------------------" 
	echo "	Cargar PROMO 15% DOMINGOS 			Bajar PROMO 15% DOMINGOS       		"	
	echo "	1) En Todas las sucursales			3) En Todas las sucursales		"
 	echo "	2) En Sucursales seleccionadas			4) En Sucursales seleccionadas 		"
	echo	
        echo "	Promociones Domingo Empresa02 (Patios de Comida)    					"
	echo "	---------------------------------------------------------------------------------------------------------"
        echo "	Cargar  PROMO 15% DOMINGOS            		Bajar PROMO 15% DOMINGOS                "       
        echo "	5) En Todas las sucursales                      7) En Todas las sucursales	    	"
        echo "	6) En Sucursales seleccionadas                  8) En Sucursales seleccionadas 		"
	echo
        echo "###########################################################################################################"
	echo "	Promocion Descuento Empleados Empresa01 (Descuento del 15%)    				"
        echo "	-----------------------------------------------------------"
        echo "	Cargar PROMO JUEVES 15% EMPLEADOS 		Bajar PROMO JUEVES 15% EMPLEADOS	"
        echo "	9) En Todas las sucursales                      11) En Todas las sucursales    		"
        echo "	10) En Sucursales seleccionadas                 12) En Sucursales seleccionadas 	"
	echo 
	echo "	Promocion Descuento Empleados Empresa02 (Descuento del 15%)                             "
	echo "	-----------------------------------------------------------"
        echo "	Cargar PROMO JUEVES 15% EMPLEADOS               Bajar PROMO JUEVES 15% EMPLEADOS        "
        echo "	13) En Todas las sucursales                     15) En Todas las sucursales     	"
	echo "	14) En Sucursales seleccionadas                 16) En Sucursales seleccionadas 	"
        echo
        echo "###########################################################################################################"
	echo "	Ver el log de Promociones  	 							"
        echo "	-------------------------" 
	echo "	17) En Todas las sucursales			18) En Sucursales seleccionadas 	"
       	echo "----------------------------------------------------------------------------------------------------------"
	echo	
        echo "s) Volver al menu anterior "
        echo 
      echo "\t\tOPCION: \c"
        read OPCION;
        export OPCION

        case $OPCION in
                1)      $Banner " Carga de la Promocion Domingo Empresa 1 en Todas las Sucursales"
			COMANDO='su - sfctrl "-c ts090305 /sfctrl/planes/DESCU_DTO_930_AMEX_ALTA.dkt /sfctrl/data/mess_f1.dat" 2>/dev/null'	
#			COMANDO='su - sfctrl "-c ts090305 /sfctrl/bindeb_alta01.dkt /sfctrl/data/mess_f1.dat" 2>/dev/null' 
			SUCLIST=`echo $LISTASUC |sed s"/142 //"`	
			echo "Cargando la  Promocion Domingo Empresa 1 en Todas las Sucursales"  
		 	Promo_Suc "$COMANDO" "$SUCLIST"
			echo
                        ;;
		2)      $Banner " Carga de la Promocion Domingo Empresa 1"
			COMANDO='su - sfctrl "-c ts090305 /sfctrl/bindeb_alta01.dkt /sfctrl/data/mess_f1.dat" 2>/dev/null'	
		#	COMANDO='su - sfctrl "-c ts090305 /sfctrl/planes/DESCU_DTO_930_AMEX_ALTA.dkt /sfctrl/data/mess_f1.dat" 2>/dev/null'	
			echo "\t\tSeleccionar sucursales separadas por espacio (ej: 02 107 45):\c "

			read SUCURSALES
			SUCLIST="$SUCURSALES"
			echo "Cargando la Promocion Domingo Empresa 1 en las Sucursales $SUCURSALES"	
                        Promo_Suc "$COMANDO" "$SUCLIST"
			echo
                        ;;
                3)      $Banner " Bajar la Promocion Domingo Empresa 1 en Todas las Sucursales "
                        COMANDO='su - sfctrl "-c ts090305 /sfctrl/bindeb_baja01.dkt /sfctrl/data/mess_f1.dat" 2>/dev/null'
			SUCLIST=`echo $LISTASUC |sed s"/142 //"`     
			echo "Bajando la  Promocion Domingo Empresa 1 en Todas las Sucursales"
                        Promo_Suc "$COMANDO" "$SUCLIST"
			echo
                        ;;
                4)      $Banner " Bajar Promocion Domingo Empresa 1"
                        COMANDO='su - sfctrl "-c ts090305 /sfctrl/bindeb_baja01.dkt /sfctrl/data/mess_f1.dat" 2>/dev/null'
			echo "\t\tSeleccionar sucursales separadas por espacio (ej: 02 107 45):\c "
                        read SUCURSALES
                        SUCLIST="$SUCURSALES" 
			echo "Bajando la  Promocion Domingo Empresa 1 en las Sucursales $SUCURSALES"
                        Promo_Suc "$COMANDO" "$SUCLIST" 
			echo
                        ;;
                5)      $Banner " Carga de Promocion Domingo Empresa 2 en Todas las Sucursales "
                        COMANDO='su - sfctrl "-c ts090305 /sfctrl/bindeb_alta02.dkt /sfctrl/data/mess_f1.dat" 2>/dev/null' 
                        SUCLIST=`cat /home/root/promociones/listpatios` 
                        echo "Cargando la  Promocion Domingo Empresa 2 en Todas las Sucursales"
                        Promo_Suc "$COMANDO" "$SUCLIST"
                        echo
                        ;;
                6)      $Banner " Carga de Promociones Domingo Empresa 2"
                        COMANDO='su - sfctrl "-c ts090305 /sfctrl/bindeb_alta02.dkt /sfctrl/data/mess_f1.dat" 2>/dev/null' 
                        echo "\t\tSeleccionar sucursales separadas por espacio (ej: 02 107 45):\c "
                        read SUCURSALES
                        SUCLIST="$SUCURSALES"
                        echo "Cargando la  Promocion Domingo Empresa 2 las Sucursales $SUCURSALES"
                        Promo_Suc "$COMANDO" "$SUCLIST"
                        echo
                        ;;
                7)      $Banner "Baja de Promocion Domingo  Empresa 2 en Todas las Sucursales"
                        COMANDO='su - sfctrl "-c ts090305 /sfctrl/bindeb_baja02.dkt /sfctrl/data/mess_f1.dat" 2>/dev/null' 
                        SUCLIST=`cat /home/root/promociones/listpatios`   
                        echo "Bajando la  Promocion Domingo Empresa 2 en Todas las Sucursales"
                        Promo_Suc "$COMANDO" "$SUCLIST"
                        echo
                        ;;
                8)      $Banner "Bajar Promociones Domingo Empresa 2"
                        COMANDO='su - sfctrl "-c ts090305 /sfctrl/bindeb_baja02.dkt /sfctrl/data/mess_f1.dat" 2>/dev/null' 
                        echo "\t\tSeleccionar sucursales separadas por espacio (ej: 02 107 45):\c "
                        read SUCURSALES
                        SUCLIST="$SUCURSALES"
                        echo "Bajando la  Promocion Domingo Empresa 2 las Sucursales $SUCURSALES"
                        Promo_Suc "$COMANDO" "$SUCLIST"
                        echo
                        ;;
                9)      $Banner " Cargar de Promociones Descuento Empleados en Todas las Sucursales"
                        COMANDO='su - sfctrl "-c ts090305 /sfctrl/DESC_TARJETA_EMPL.dkt /sfctrl/data/mess_f1.dat" 2>/dev/null'
			SUCLIST=`echo $LISTASUC |sed s"/142 //"`    	
			echo "Cargando la  Promocion Descuento Empleados en Todas las Sucursales"
                        Promo_Suc "$COMANDO" "$SUCLIST"
			echo
                        ;;
               10)      $Banner " Cargar Promociones Descuentos Empleados"
                        COMANDO='su - sfctrl "-c ts090305 /sfctrl/DESC_TARJETA_EMPL.dkt /sfctrl/data/mess_f1.dat" 2>/dev/null'
			echo "\t\tSeleccionar sucursales separadas por espacio (ej: 02 107 45):\c "
                        read SUCURSALES
                        SUCLIST="$SUCURSALES"
			echo "Cargando la  Promocion Descuento Empleados en las Sucursales $SUCURSALES"
                        Promo_Suc "$COMANDO" "$SUCLIST" 
			echo
                        ;;
               11)      $Banner "Bajar Promociones Descuento Empleados"
                        COMANDO='su - sfctrl "-c ts090305 /sfctrl/DESC_TARJETA_EMPL_BAJA.dkt /sfctrl/data/mess_f1.dat" 2>/dev/null' 
			SUCLIST=`echo $LISTASUC |sed s"/142 //"`
			echo "Bajando la  Promocion Descuento Empleados en Todas las Sucursales"
                        Promo_Suc "$COMANDO" "$SUCLIST" 
			echo
                        ;;
               12)      $Banner "Bajar Promociones Descuento Empleados "
                        COMANDO='su - sfctrl "-c ts090305 /sfctrl/DESC_TARJETA_EMPL_BAJA.dkt /sfctrl/data/mess_f1.dat" 2>/dev/null'
			echo "\t\tSeleccionar sucursales separadas por espacio (ej: 02 107 45):\c "
                        read SUCURSALES
                        SUCLIST="$SUCURSALES"
			echo "Bajando la  Promocion  Descuento Empleados en las Sucursales $SUCURSALES"
                        Promo_Suc "$COMANDO" "$SUCLIST"
			echo
                        ;;
               13)      $Banner " Cargar de Promociones Descuento Empleados Empresa02 en Todas las Sucursales"
			COMANDO='su - sfctrl "-c ts090305 /sfctrl/DESC_TARJETA_EMPL_02.dkt /sfctrl/data/mess_f1.dat" 2>/dev/null'
                        SUCLIST=`cat /home/root/promociones/listpatios`
			echo "Cargando la  Promocion Descuento Empleados en Todas las Sucursales"
                        Promo_Suc "$COMANDO" "$SUCLIST"
                        echo
                        ;;
               14)      $Banner " Cargar Promociones Descuentos Empleados Empresa02"
			COMANDO='su - sfctrl "-c ts090305 /sfctrl/DESC_TARJETA_EMPL_02.dkt /sfctrl/data/mess_f1.dat" 2>/dev/null'
                        echo "\t\tSeleccionar sucursales separadas por espacio (ej: 02 107 45):\c "
                        read SUCURSALES
                        SUCLIST="$SUCURSALES"
                        echo "Cargando la  Promocion Descuento Empleados en las Sucursales $SUCURSALES"
                        Promo_Suc "$COMANDO" "$SUCLIST"
                        echo
                        ;;
               15)      $Banner "Bajar Promociones Descuento Empleados Empresa02"
			COMANDO='su - sfctrl "-c ts090305 /sfctrl/DESC_TARJETA_EMPL_BAJA_02.dkt /sfctrl/data/mess_f1.dat" 2>/dev/null'	
                        SUCLIST=`cat /home/root/promociones/listpatios`
			echo "Bajando la  Promocion Descuento Empleados en Todas las Sucursales"
                        Promo_Suc "$COMANDO" "$SUCLIST"
                        echo
                        ;;
               16)      $Banner "Bajar Promociones Descuento Empleados Empresa02"
                        COMANDO='su - sfctrl "-c ts090305 /sfctrl/DESC_TARJETA_EMPL_BAJA_02.dkt /sfctrl/data/mess_f1.dat" 2>/dev/null'
			echo "\t\tSeleccionar sucursales separadas por espacio (ej: 02 107 45):\c "
                        read SUCURSALES
                        SUCLIST="$SUCURSALES"
                        echo "Bajando la  Promocion  Descuento Empleados en las Sucursales $SUCURSALES"
                        Promo_Suc "$COMANDO" "$SUCLIST"
                        echo
                        ;;
		17)	$Banner " Ver log de Promociones en Todas las Sucursales "
			ksh /home/root/promociones/veolog.sh
			echo 
			;;
		18)	$Banner " Ver log de Promociones en Todas las Sucursales "
                        echo "\t\tSeleccionar sucursales separadas por espacio (ej: 02 107 45):\c "
			read SUCURSALES
			ksh /home/root/promociones/veolog1.sh $SUCURSALES
                        echo 		
	esac
	if [ "$OPCION" != "s" -a "$OPCION" != "S" ]
        then
                echo
                echo "  Presione una tecla para continuar \c";
                read tecla ;
        fi
done
