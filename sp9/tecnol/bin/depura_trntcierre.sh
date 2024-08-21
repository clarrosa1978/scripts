set -x
###############################################################################
#
# Depura los archivos del filesystems /trntcierre , que corresponden a las
# transferencias de cierre de sucursales.
#
# Cesar Lopez  -  24/02/2003
#
###############################################################################

if [ $# -ne 1 ]
then
        #Usage $0 DATE SOURCE_HOST APLICATION_NAME PATH SUCURSAL
        echo "Error en la cantidad de parametros" 
        exit 14
else

export SUC="${1}"

fi

##### Preparo la info del dia
export SUC_2D=""
export SUC_3D=""

SUC0="`echo $1 | cut -c1`"

if [ $SUC0 = 0 ] 
then
SUC=`echo $1 | cut -c2,3`
else
SUC=${1}
fi



if [ ${SUC} -lt 100 ]
then
	HOST=suc${SUC}
else
	HOST=suc${SUC}
fi

find /trntcierre/${HOST} -name "*" -mtime +5 -exec rm {} \; 

exit 0



