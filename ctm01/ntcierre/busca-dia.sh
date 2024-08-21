################################################################################
#
# Script     : busca_dia.sh
# Autor      : Cesar Lopez
# Equipo     : servidores de Sucursales
# Fecha      : 05/01/2001
# Descripcion: Busca en el calendario especificado en el 3er. parametro, el
#              estado de planificacion de ese dia:
#
#               Y : corresponde planificar
#               N : no corresponde planificar
#
#
# Parametros :
#              $1 : dia juliano del a#o correspondiente a %%$ODATE (%%OJULDAY)
#              $2 : a#o correspondiente a %%$ODATE (%%$OYEAR)
#              $3 : nombre del calendario en el que se debe buscar
#
################################################################################
set -x
JULDAY=$1
JOBYEAR=$2
CALNAME=$3
PATHSCR="/tecnol/ntcierre"
PATHLOG="${PATHSCR}/log"

echo "set linesize 400" > ${PATHLOG}/$$.sql
echo "select cast(daymask as varchar2(400)) from CMS_DATEMM where CALNAME = '${CALNAME}' and JOBYEAR = '${JOBYEAR}';" >> ${PATHLOG}/$$.sql

SQL -s < ${PATHLOG}/$$.sql > ${PATHLOG}/dias.$$
if [ ! -s ${PATHLOG}/dias.$$ ]
then
	echo "No se genero el archivo dias.$$ con datos del calendario"
	exit 5
fi

PLANI=`tail -2 ${PATHLOG}/dias.$$ | sed /^$/d  | cut -c${JULDAY}-${JULDAY}`
[ ${PLANI} ] || exit 4
if [ $PLANI = Y ]
then
	# corresponde planificar
	#rm -f ${PATHLOG}/$$.sql ${PATHLOG}/dias*.$$
	exit 0
else
	if [ $PLANI = N ]
	then
		# no corresponde planificar
		#rm -f ${PATHLOG}/$$.sql ${PATHLOG}/dias*.$$
		exit 1
	else
		echo "Dato invalido en el calendario ${CALNAME}"
		exit 4
	fi
fi
