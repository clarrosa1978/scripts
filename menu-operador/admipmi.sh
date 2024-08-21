#set -n
#set -x
#!/usr/bin/ksh
#clear
##########################################################################################
# Nombre.............: imprimir_listados.sh                                              #
# Autor..............: Cerizola Hugo                                                     #
# Objetivo...........: Tener un menu para conectarse rapidamente a la consola de una suc.#
# Descripcion........:                                                                   #
# Valores de Retorno.:                                                                   #
# Modificacion.......:                                                                   #
# Documentacion......:                                                                   #
##########################################################################################


###########################################################################################
#                                      VARIABLES                                          #
###########################################################################################

export PATHLIST="/etc"
export PATHTMP="/tmp"
export FILELIST="${PATHLIST}/listaipmi"
export PATHSC="/tecnol/operador"
export ANO="`date +%Y`"
export USER_IPMI="ipmiadmin"
export PSWD_IPMI="IpmI//2012"


MENU_TMP="${PATHTMP}/list_menu"
ARCH_TMP="${PATHTMP}/listacons"
LIST_TMP="${PATHTMP}/consolas"
IMPR_TMP="${PATHTMP}/consolas_suc"

>${MENU_TMP}
>${ARCH_TMP}
>${LIST_TMP}
>${IMPR_TMP}

cat ${FILELIST} | cut -d";" -f1,2,3 | awk -F ";" ' { print sprintf("%02d);%s", NR , $1 ";" $2 ";" $3 )}' >>${ARCH_TMP}
cat ${FILELIST} | cut -d";" -f1,2,3 | awk -F ";" ' { print sprintf("\t%02d) %s", NR , $1 )}' >>${MENU_TMP}

###########################################################################################
#                                      FUNCIONES                                          #
###########################################################################################

function PTecla
{
        echo "\tPresione una tecla para continuar"
        read cont
#       clear
}

function Cabecera
{
        clear
        /$PATHSC/encabezado.sh
        printf "\n\t\t\t%-41s\n" "**************************************"
        printf "\t\t\t%-10s %-25s %-1s\n" "*" "ACCESOS A CONSOLAS" "*"
        printf "\t\t\t%-41s\n\n" "**************************************"
}




###########################################################################################
#                                      PRINCIPAL                                          #
###########################################################################################

#########################################################################################################
#  INGRESAR LA FECHA DE LOS LISTADOS QUE SE DESEEN IMPRIMIR                                             #
#########################################################################################################

Cabecera

if [ -s ${MENU_TMP} ]  2>/dev/null
then
echo "\t--------------------------------------------------------------------------------------------"
echo "\t Listados en Linea para el $MESDIA"
echo "\t--------------------------------------------------------------------------------------------"
	LISTAR=`cat ${MENU_TMP}	| awk '{print sprintf("\t%02d)%s", NR , $2)}'`
        CANT_COL=5
        COUNT=1
                for LIST in ${LISTAR}
                do

			if [ $COUNT = $CANT_COL ]
			then
		        COUNT=1
			echo "\t${LIST}\t\n"
			else
			COUNT=`expr $COUNT '+' 1`
			echo "\t${LIST}\t\c"
			fi	
                done
echo ""
fi

#########################################################################################################
#  INGRESAR LOS LISTADOS QUE SE DESEEN IMPRIMIR                                                         #
#########################################################################################################

until [ ${NUME_LIST} ]
do

echo "\t--------------------------------------------------------------------------------------------"
echo "\tIngrese el nro de listado/s que desee imprimir:         "
echo "\t(Por ejemplo: 01 02 04 10 11) o [s-S] Salir del Menu[s]:\c"
read L
echo "\t--------------------------------------------------------------------------------------------"

	for CTROL in $L
	do
        if [ ${CTROL} = "s" ]  2>/dev/null || [ ${CTROL} = "S" ]  2>/dev/null || [ ${CTROL} = " " ] 2>/dev/null
        then
                exit
        else
		SELEC_SUC=`grep "^${CTROL});" ${ARCH_TMP} | cut -d";" -f2`
		SELEC_IP=`grep "^${CTROL});" ${ARCH_TMP} | cut -d";" -f3`
		SELEC_TYP=`grep "^${CTROL});" ${ARCH_TMP} | cut -d";" -f4`
		echo "Ud. Selecciono la ${SELEC_SUC} ${SELEC_IP} ${SELEC_TYP}"


		echo "\t--------------------------------------------------------------------------------------------"
		echo "\tUd Selecciono:"
		echo "\t              la ${SELEC_SUC} cuya ip es ${SELEC_IP} y es el servidor ${SELEC_TYP}" 
		echo " "
		echo "\t(Si es correcto presiona ENTER sino [s-S] Salir del Menu[s]:\c"
		read P
		echo "\t--------------------------------------------------------------------------------------------"
		if [ ${P} = "s" ]  2>/dev/null || [ ${P} = "S" ]  2>/dev/null #|| [ ${P} = "" ]  2>/dev/null
		then
			exit
		else 
			#ipmitool -I lanplus -H  IPCONSOLA -U USUARIO -P PASSWORD sol actívate
			/usr/bin/ipmitool -I lanplus -H  ${SELEC_IP} -U ${USER_IPMI} -P ${PSWD_IPMI} sol actívate
		fi
	fi
	done
done
