#set -x
#!/usr/bin/ksh
##########################################################################################
# Nombre.............: imprimir_listados.sh                                              #
# Autor..............: Cristian Larrosa                                                  #
# Objetivo...........: Imprimir listados de SF de dias anteriores.                       #
# Descripcion........: Recibe como parametro el dia, el mes y el listado a imprimir.     #
# Valores de Retorno.:                                                                   #
# Modificacion.......: 31/05/2005                                                        #
# Documentacion......: El parametro que recibe debe ser:                                 #
#                      		DIA: numero entre 1 y 31.                                #
#                      		MES: numero entre 1 y 12.                                #
#                      		LISTADO: 1002, 1003, 1007, 1020, 1021, 1027, 1033, 1040, #
#                      		         1041, 1046, 1070, 1071.                         #
##########################################################################################


###########################################################################################
#                                      VARIABLES                                          #
###########################################################################################
export PATHLIST="/sfctrl/sfgv/informes/semanal"
export PATHSC="/tecnica/scripts/menuoper"
export APAISADO="${PATHSC}/apaisado"
export NORMAL="${PATHSC}/normal"
export SIN=""
export ARCHOPC=$1
export ARCHFORM="${PATHLIST}/formato.tmp"
export ARCHTMP="${PATHLIST}/informe.tmp"
export OPCIONES=`cat "$ARCHOPC"| awk -F ";" ' { 
                                                        print sprintf("\t\t\t%02d) %s", NR, $1)} 
                                                        '`
export FMTLST=`cat "$ARCHOPC"|awk -F ";" ' { print $2 } '`
export NOMLST=`cat "$ARCHOPC"|awk -F ";" ' { print $1 } '`
export OPCMAX=`echo "$OPCIONES"|wc -l|awk ' { print $1 } '`
export OPCION=""
export DIA=""
export MES=""
export AÑO="`date +%Y`"


###########################################################################################
#                                      FUNCIONES                                          #
###########################################################################################

function PTecla
{
	echo "Presione una tecla para continuar"
	read cont
}
function Cabecera
{
        clear
        Encabezado.sh
        printf "\n\t\t\t%-41s\n" "**************************************"
        printf "\t\t\t%-10s %-25s %-1s\n" "*" "REIMPRESION DE LISTADOS" "*"
        printf "\t\t\t%-41s\n\n" "**************************************"
}


function Ingresar_Dia
{
	until [  ${DIA} ]
	do
        	echo "\t\t\tIngrese el dia de generacion del listado [1-31]:\c"
        	read D
        	export DIA=`expr ${D} : '^\([0-9]*\)$'`
        	if [ ${DIA} ] && [ ${DIA} = ${D} ] && [ ${DIA} -ge 1 ] && [ ${DIA} -le 31 ]
        	then
			if [ ${DIA} -ge 1 ] && [ ${DIA} -le 9 ]
                	then
                        	DIA="0${DIA}"
                	fi
                	return DIA
        	else
                	echo "El dia ingresado es incorrecto!!\n"
                	PTecla
                	DIA=""
        	fi
	done
}

function Ingresar_Mes 
{
        echo "\t\t\tIngrese el mes de generacion del listado [1-12]:\c"
        read M
        export MES=`expr ${M} : '^\([0-9]*\)$'`
        if [ ${MES} ] && [ ${MES} = ${M} ] && [ ${MES} -ge 1 ] && [ ${MES} -le 12 ]
        then
		if [ ${MES} -ge 1 ] && [ ${MES} -le 9 ]
		then
			MES="0${MES}"
		fi
               	return MES
        else
               	echo "El mes ingresado es incorrecto!!\n"
               	PTecla
               	MES=""
        fi
}

typeset -l PTecla Ingresar_Dia Ingresar_Mes
###########################################################################################
#                                      PRINCIPAL                                          #
###########################################################################################
set -x
while true
do
	Cabecera
        echo "${OPCIONES}\n" 
        echo "\t\tIngrese su opcion[de 1 a $OPCMAX] o Salir del Menu[s]:\c"   
        read OPCION
	[ ${OPCION} = "s" ] || [ ${OPCION} = "S" ] && exit 0
        export OPCVALID=`expr ${OPCION} : '^\([0-9]*\)$'`
        if [ "$OPCVALID" = ${OPCION} ] && [ ${OPCVALID} -gt 0 ] && [ ${OPCVALID} -le ${OPCMAX} ] 
	then
		OPCION=`expr ${OPCION} + 0`
		export FORMATO=`echo "${FMTLST}"|awk ' NR == '$OPCION' { print $0 } '`
		case "${FORMATO}" in
			( "SIN" )      FORMATO="${SIN}"
				       ;;
			( "NORMAL" )   FORMATO="${NORMAL}"
				       ;;
			( "APAISADO" ) FORMATO="${APAISADO}"
				       ;;
		esac
		until [ ${DIA} ]
		do
			Ingresar_Dia ${DIA}
		done
		until [ ${MES} ]
                do
			Ingresar_Mes ${MES}
		done
		export LST=`echo "${NOMLST}"|awk ' NR == '$OPCION' { print $0 } '`
		export LISTADO="${PATHLIST}/LS00${LST}.${DIA}${MES}"
		if [ ! -s ${LISTADO} ]
		then
			echo "\t\tEl listado solicitado no existe para esa fecha!!"
			PTecla
		else
			autoload Borrar
			Borrar ${ARCHTMP}
			cat ${FORMATO} ${LISTADO} >> ${ARCHTMP}
			lp -ds`hostname | cut -c4-`co1 ${ARCHTMP}
			PTecla
		fi
	else
        	echo "\n\nOpcion INVALIDA.  REINGRESE..."
        	PTecla
	fi
        OPCION=""
       	OPCVALID=""
	DIA=""
	MES=""
done
