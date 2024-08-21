#set -x 
#################################################################################
# Autor.................: Andres Bruzzese - Operaciones                         #
# Usuario ..............: operador                                              #
# Objetivo..............: Matar usuarios				        #
# Nombre del programa...: menu_CtrlCierres.ksh                                  # 
# Descripción...........: Mata a todos los usuarios que no deben estar		# 
#		 	conectados al sistema mientras se corre el inter_of	#       
#               	Los usuarios que no se matan se encuentran en el archivo#
#               	usr_no_kill (separados por | )				#
# Modificación..........: 24/07/2001                                            #
#################################################################################


#########################################################################
#		Definicion de Funciones					#
#########################################################################

Mato_terms ()
{

echo
if [ "$1" != "" ]
then
	echo "Confirma que desea matar todas estas terminales (s/n): \c";
	read RESP; export RESP;
	while [ "$RESP" != "s" -a "$RESP" != "S" -a "$RESP" != "n" -a "$RESP" != "N" ]
	do
		echo
		echo "\tVerifique la respuesta"
		echo
		echo "Confirma que desea matar todas estas terminales (s/n): \c";
		read RESP; export RESP;
	done
	if [ "$RESP" = "s" -o "$RESP" = "S" ]	
	then
		for NRO_TERMINAL in $1
		do
			A_MATAR=`ps -tpts/$NRO_TERMINAL | grep -v PID | awk ' { print $1 } '`
			for i in $A_MATAR
			do
				#echo $A_MATAR
				kill -9 $i
			done
		done
	fi 
else
	echo
	echo "No hay terminales seleccionandas"
fi         
}   
#########################################################################################
#########################################################################################

#########################################################################
#		Definicion de variables					#
#########################################################################
export OPERADOR_WRK="/tecnol/operador"
export Banner="$OPERADOR_WRK/Banner.ksh"
export PATH_MENU="/home/root/operador/andres/menu_oper"
export PATH_MENU_TMP="$PATH_MENU/tmp"
export PATH_MENU_LOGS="$PATH_MENU/logs"
export FECHA="`cat $PATH_MENU/fecha.dat`"

export USR_NO_KILL="`cat $PATH_MENU/usr_no_kill`"
export OPCION="";
export LISTA_USR="$PATH_MENU_TMP/lista_usr.tmp"
export TERMINALES="";
export LISTA_TERMS="";

#########################################################################
#		PRINCIPAL						#
#########################################################################


while [ "$OPCION" != "s" -a "$OPCION" != "S" ]
do
	$Banner "Menu  para  matar usuarios  antes de inter_of ";
	echo
	echo " 1) Ver usuarios activos "
	echo
	echo " 2) Ver usuarios a matar "
	echo  
	echo " 3) Matar usuarios del punto 2 "
	echo
	echo " 4) Matar usuario por numero de terminal "
	echo  
	echo " 5) Matar usuario/s por palabre clave "
	echo
	echo " S) Volver al menu anterior"
	echo 
	echo
	echo "		OPCION: \c";
	read OPCION
	export OPCION;
	export LISTA_TERMS="";
	case $OPCION in
	1)	$Banner " Lista de usuarios activos";
		w -h |pg
		;;
		
	2) 	$Banner " Lista de usuarios a matar "
		w -h |egrep -v "$USR_NO_KILL"|pg
		;;

	3) 	$Banner "    Matando usuarios por terminal "
		echo
		>$LISTA_USR
		COUNT_TO_KILL="`w -h |egrep -v "$USR_NO_KILL" |wc -l`"
		export COUNT_TO_KILL
		if [ $COUNT_TO_KILL != 0 ]
		then
			echo "	Cantidad de terminales a matar: $COUNT_TO_KILL";
			echo
			echo "	Lista de usuarios y terminales a matar ..."
			echo
			echo "\tUSUARIO\t\tTERMINAL " 
			echo "\t-------------------------" 
			echo "\c";w -h |egrep -v "$USR_NO_KILL"| awk ' { print "\t" $1 "    \t" substr ($2,5) }'>> $LISTA_USR
			pg $LISTA_USR
			echo
			LISTA_TERMS="`cat $LISTA_USR|awk '{ print  $2 }'`"
			#echo $LISTA_TERMS
			export LISTA_TERMS
			Mato_terms "$LISTA_TERMS" 
			rm $LISTA_USR
		else
			echo "No hay ningun usuario para matar"
		fi 	 
		;;
	4) 	$Banner " Matando usuario por terminal seleccionada "
		echo
		echo " Seleccione las terminales a matar (separadas por espacio) "
		echo  
		echo " Terminales a matar: \c"; read TERMINALES
		export TERMINALES
		Mato_terms "$TERMINALES";
		;;
	5) 	$Banner " Matando usuarios por palabre clave"
		echo  
		echo " Ingrese la palabra clave (por ej. cce, para que busque todos los usuarios\n con esas letras dentro de su mombre de usuario):\c ";
		read RESP
		export RESP;
		w -h|grep $RESP 2> /dev/null |grep -v remote |awk ' { print "\t" $1 "\t\t" substr ($2,5) } ' >> $LISTA_USR 
		echo
		echo "\tUSUARIO\t\tTERMINAL"
		echo "\t--------------------------"
		pg $LISTA_USR
		LISTA_TERMS="`cat $LISTA_USR|awk '{ print  $2 }'`"
	   	Mato_terms "$LISTA_TERMS"	
		rm $LISTA_USR
		;;

esac
if [ "$OPCION" != "s" -a "$OPCION" != "S" ] 
then 
	echo
	echo "  Presione una tecla para continuar \c";
 	read tecla ;
fi
done

