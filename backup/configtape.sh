###############################################################################
# Nombre.............: ConfigTape                                             #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Configurar nuevamente las unidades de cintas conectadas#
#                      a la placa fcs0 y fcs1.                                #
# Descripcion........: Debe ejecutarse antes de realizar un backup por TSM.   #
# Valores de Retorno.: 0 - La funcion termino ok.                             #
#                      1 - La funcion fallo.                                  #
# Creacion...........: 2013/09/12                                             #
# Modificacion.......:                                                        #
###############################################################################
set -x
SYSTEM="$1"
LPARORI="$2"
LPARDEST="$3"
DRCINDEX="$4"
Check_Par 4 $@
[ $? != 0 ] && exit 1
ESTA="`lsdev -l pci0 | awk ' { print $2 } '`"
if [ "${ESTA}" ]
then
	if [ "${ESTA}" = 'Defined' ]
	then
		ASIGN="`ssh operador@HMC1 lshwres -r io --rsubtype slot -m ${SYSTEM}  -F drc_name,lpar_name,drc_index | grep ${DRCINDEX}| awk -F, ' { print $2 } '`"
		if [ ${ASIGN} != ${LPARDEST} ]
		then
			ssh operador@HMC1 "chhwres -r io -m ${SYSTEM} -o m -p ${LPARORI} -t ${LPARDEST} -l ${DRCINDEX}"
			if [ $? != 0 ]
			then
				echo "Error al asignar recurso ${DRCINDEX}"
				exit 1
			fi
		fi
		cfgmgr -l pci0
                if [ $? != 0 ]
		then
			exit 1
		fi
	fi
	STA="`ps -ef | grep 'dsmsta quiet' | grep -v grep`"
	if [ "${STA}" ]
	then
		exit 0
	else
		nohup /usr/tivoli/tsm/StorageAgent/bin/rc.tsmstgagnt &
		sleep 120
		exit 0
	fi
else
	exit 1
fi
