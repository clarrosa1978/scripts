
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
export OPERADOR_WRK="/tecnol/operador/noche"
export Banner="$OPERADOR_WRK/Banner.ksh"
export PATH_MENU="/tecnol/operador/noche"
export PATH_MENU_TMP="$PATH_MENU/tmp"
export PATH_MENU_LOGS="$PATH_MENU/logs"
export FECHA="`cat $PATH_MENU/fecha.dat`"

Trigger_Suc ()
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
	$Banner "Menu para control de Trigger de Precios en Sucursales"
        echo " "  
	echo "	| Recuerde que estos Comandos solo deben ser usados en casos eventuales		      | "
	echo "  | donde sea necesario apresurar la carga de los precios en las sucursales             |	"
	echo "  | debiendo avisar por mail a los DBA debiendo volver a subirlos posteriormente        | "
	echo "	----------------------------------------------------------------------------------------"
	echo "	 											"
	echo "	HABILITAR TRIGGER 				DESHABILITAR TRIGGER       		"	
	echo "	1) En Todas las sucursales			3) En Todas las sucursales		"
 	echo "	2) En Sucursales seleccionadas			4) En Sucursales seleccionadas 		"
	echo	
       	echo "------------------------------------------------------------------------------------------"
	echo	
        echo "s) Volver al menu anterior "
        echo 
      echo "\t\tOPCION: \c"
        read OPCION;
        export OPCION

        case $OPCION in
                1)      $Banner "Habilitar Trigger de Auditoria de Precios en Todas las Sucursales"
                        COMANDO='su - oracle "-c /home/oracle/sfctrl/enable.sh" 2>/dev/null' 
			SUCLIST=`echo $LISTASUC`	
			echo "Habilitando los trigger de precios en Todas las Sucursales"  
		 	Trigger_Suc "$COMANDO" "$SUCLIST"
			echo
                        ;;
		2)      $Banner "Habilitar Trigger de Auditoria de Precios en las siguientes Sucursales"
		 	COMANDO='su - oracle "-c /home/oracle/sfctrl/enable.sh" 2>/dev/null'		
			echo "\t\tSeleccionar sucursales separadas por espacio (ej: 02 107 45):\c "
			read SUCURSALES
			SUCLIST="$SUCURSALES"
			echo "Habilitando los trigger de precios en las siguientes Sucursales" 
                        Trigger_Suc "$COMANDO" "$SUCLIST"
			echo
                        ;;
                3)      $Banner "Deshabilitar Trigger de Auditoria de Precios en Todas las Sucursales"
                        COMANDO='su - oracle "-c /home/oracle/sfctrl/disable.sh" 2>/dev/null'
                        SUCLIST=`echo $LISTASUC`                
                        echo "Deshabilitando los trigger de precios en Todas las Sucursales"                     
                        Trigger_Suc "$COMANDO" "$SUCLIST"
                        echo
                        ;;
                4)      $Banner "Deshabilitar Trigger de Auditoria de Precios en las siguientes Sucursales"
                        COMANDO='su - oracle "-c /home/oracle/sfctrl/disable.sh" 2>/dev/null'            
                        echo "\t\tSeleccionar sucursales separadas por espacio (ej: 02 107 45):\c "
                        read SUCURSALES
                        SUCLIST="$SUCURSALES"
                        echo "Deshabilitando los trigger de precios en las siguientes Sucursales"
                        Trigger_Suc "$COMANDO" "$SUCLIST"
                        echo
                        ;;	
	esac
	if [ "$OPCION" != "s" -a "$OPCION" != "S" ]
        then
                echo
                echo "  Presione una tecla para continuar \c";
                read tecla ;
        fi
done
