###########################################################################################
#NOMBRE DEL SCRIPT: TraerTlogSuc.sh                                                       #
#DESCRIPCION: Transmite el archivo tlogXXX.aammdd.Z de una sucursal al sp9, invocando     #
#             el scrip safe_rcp                                                           #
#PARAMETROS: Recibe N° de sucursal en tres digitos y la fecha con formato yyyymmdd        #
#AUTOR: Cristian Larrosa                                                                  #
#FECHA DE MODIFICACION: 25-08-2003                                                        #
###########################################################################################
      
###########################################################################################
#                                     VARIABLES                                           #
###########################################################################################

SUCURSAL=$1
FECHA=$2
TIP_TRANS="G" 
DIR_DEST="/tlogsuc/suc$SUCURSAL"
ARCH_DEST="tlog$SUCURSAL.$FECHA.Z"
DIR_ORI="/sfctrl/d"
ARCH_ORI="tlog$SUCURSAL.$FECHA.Z"
DUEÑO="root"
GRUPO="sys"
PERM=644
EST_FIN=""

###########################################################################################
#                                     FUNCIONES                                           #
###########################################################################################


###########################################################################################
#                                     PRINCIPAL                                           #
###########################################################################################
set -x

if [ $# -eq 2 ]
then
	if [  -s /tecnol/bin/safe_rcp -a -x /tecnol/bin/safe_rcp ]
	then
		if [ "$SUCURSAL" -lt 100 ]
        	then
                	SUCURSAL=`echo $SUCURSAL | cut -c2-`
        	fi
		if [ "$SUCURSAL" -eq 050 ]
		then
			SERV_ORI=j40gdm
		else
			SERV_ORI=suc$SUCURSAL
		fi
		/tecnol/bin/safe_rcp $TIP_TRANS $DIR_ORI $ARCH_ORI $SERV_ORI $DIR_DEST $ARCH_DEST NULL NULL NULL NULL NULL $DUEÑO $GRUPO $PERM
		EST_FIN=$?
		if [ $EST_FIN -ne 0 ]
		then
        		case $EST_FIN in
                		10) echo "\tArchivo inexistente"
                       	    	    exit 10
                    	    	    ;;
                		12) echo "\tImposible copiar el archivo localmente"
                    		    exit 12
                    		    ;;
                		15) echo "\tNo hay espacio para copiar"
                    		    exit 15
                    		    ;;
                		22) echo "\tEl usuario no tiene permisos"
                    		    exit 22
                    		    ;;
                		33) echo "\tError en la cantidad de parametros pasados el safe_rcp"
                    		    exit 33
                    		    ;;
                		35) echo "\tError al tratar de cambiar el dueño y el grupo del archivo"
                    		    exit 35
                    		    ;;
                		50) echo "\tImposible copiar el archivo remotamente"
                    		    exit 50
                    		    ;;
                		51) echo "\tError al resolver la IP a partir del servername"
                    		    exit 51
                    		    ;;
                		52) echo "\tNo hay comunicacion con el servidor"
                    		    exit 52
                    		    ;;
                		53) echo "\tNo hay acceso remoto al servidor"
                    		    exit 53
                    		    ;;
                		54) echo "\tDemasiado trafico en la red"
                    		    exit 54
                    		    ;;
                		55) echo "\tEl usuario remoto no existe"
                    		    exit 55
                    		    ;;
				*)  echo "\tError durante la ejecucion"
				    exit 60
				    ;;
       		 	esac
		else
			rsh suc$SUCURSAL '( 
				rm '$DIR_ORI'/'$ARCH_ORI' 
				if [ $? -ne 0 ]
				then
					echo "ERROR"
				fi
			)' | if [ `grep -c ERROR` -ne 0 ]
			     then
				 	exit 56
			     fi

		fi
	else
		echo "\tEl script safe_rcp tiene tamaño 0 o no tiene permisos de ejecucion"
                exit 9
		
	fi
else
	echo "\tError en la cantidad de parametros, deben ser 2, N° sucursal en 3 digitos y fecha (aaaammdd):\n"
	echo "\tEj: TraerTlogSuc.sh 090 20030825"
	exit 32
fi
