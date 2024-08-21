###############################################################################
# Nombre.............: rmtape.sh                                              #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Borra los dispositivos vinculados a la placa pci0.     #
# Descripcion........: Debe ejecutarse depues de realizar un backup por TSM.  #
# Valores de Retorno.: 0 - La funcion termino ok.                             #
#                      1 - La funcion fallo.                                  #
# Creacion...........: 2013/09/12                                             #
# Modificacion.......:                                                        #
###############################################################################
set -x
EXIT="1"
ESTA="`lsdev -l pci0 | grep Available | awk ' { print $2 } '`"
if [ "${ESTA}" ]
then
	if [ "${ESTA}" = 'Available' ]
	then
		STA="`ps -ef | grep 'dsmsta quiet' | grep -v grep | awk ' { print $2 } '`"
		[ "${STA}" ] && kill -9 ${STA}
		sleep 600
		rmdev -l pci0 -R
		if [ $? = 0 ] 
               	then
       			EXIT="0"
		fi
	fi
fi
exit ${EXIT}
