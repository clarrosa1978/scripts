##############################################################################
#NOMBRE: crea_pmt.sh                                                         #
#DIRECTORIO: /tecnol/bin                                                     #
#EQUIPO: nodo9                                                               #
#USUARIO: root                                                               #
#DESCRIPCION: copia los archivos .pmt necesarios para un datacenter nuevo    #
#             para los jobs de transferencias de archivos de cierre          #
#             de sucursales.                                                 #
#METODO DE EJECUCION: manual                                                 #
#AUTOR: Cesar Lopez - Tecnologia de Sistemas                                 #
#FECHA: 02/02/2000                                                           #
#
##############################################################################
#
# Se agrego la generacion de los archivos de parametros para la transferencia
# de las interfases de StoreFlow para Financial
#
# Cesar Lopez  -  21/10/2000
#
##############################################################################
#
# Se agrego la generacion de los archivos de parametros para la transferencia
# de las interfases de ventas de Cuentas de Internet
# Se modifico el numero de sucursal ORIGEN, para que asigne siempre un valor
# generico XX, en vez de pedir el dato por pantalla.
#
# Cesar Lopez  -  01/11/2001
#
##############################################################################
#
# Se elimino la generacion de los archivos de parametros de una cadena de
# Conciliacion de Creditos, que no se puso en produccion.
#
# Cesar Lopez  -  29/11/2001
#
##############################################################################
#
# Se elimino la generacion de los archivos de parametros de la transferencia
# del vtaplu, del sp9 al sp17, ya que no existe mas la cadena VTASUCGDM.
#
# Cesar Lopez  -  19/03/2002
#
##############################################################################
#
# Se agrego la generacion de los archivos de parametros para la transferencia
# de los archivos TL y PS para Conciliaciones de Tarjetas de Credito
#
# Cesar Lopez  -  22/10/2002
#
##############################################################################
#
# Se agrego la generacion de los archivos de parametros para la transferencia
# de los archivos MM para Conciliaciones de Tarjetas de Credito
#
# Cesar Lopez  -  24/02/2003
#
##############################################################################
#
# Se elimino la generacion de los archivos de parametros para las
# transferencias de los archivos de Venta de servicio de internet, Cliente
# Frecuente, y interfase de electrodomesticos.
#
# Cesar Lopez  -  07/10/2003
#
##############################################################################
#
# Se elimino la generacion de los archivos de parametros para las
# transferencias de los archivos de Venta por PLU y Venta por Departamento
#
# Cesar Lopez  -  01/12/2003
#
##############################################################################
#
# Se elimino la generacion de los archivos de parametros para las
# transferencias de los archivos de Tickets y Facturas (ts03020...) al
# servidor escala1
#
# Cesar Lopez  -  23/01/2004
#
##############################################################################
#
# Se elimino la generacion de los siguientes archivos de parametros:
#
# opercard???B.pmt
# opercard???E.pmt
# vtacard???A.pmt
# vtacard???B.pmt
# vtacard???C.pmt
# vtacard???D.pmt
# zeta???B.pmt
#
# Cesar Lopez  -  05/05/2004
#
##############################################################################
#
# Se elimino la generacion de los siguientes archivos de parametros:
#
# vta???A.pmt
# vta???G.pmt
# vtafac???A.pmt
# vtafac???G.pmt
#
# Cesar Lopez  -  02/08/2004
#
##############################################################################

#
# Descripcion de variables utilizadas para los distintos formatos del
# numero de sucursal :
#
# ORIGEN  : nro. de origen, sin ceros adelante
# DESTINO : idem ORIGEN, para el numero de destino
#
# ORI     : nro. de origen utilizado en los casos en que el numero es menor
#           a 100, y se utilizan 2 digitos (ej. hostname)
# DEST    : idem ORI, para el numero de destino
#
# F_ORI   : nro. de origen convertido a formato de 3 digitos
# F_DEST  : idem F_ORI, para el numero de destino
#
#


ORIGEN=XX
ORI=${ORIGEN}
F_ORI=0${ORIGEN}

while true
do
	clear
	echo "\nIngrese sucursal nueva (sin ceros a la izquierda): \c"
	read DESTINO
	if [ x$DESTINO != x ]
	then
		break
	fi
done

while true
do
	clear
	echo "\nOrigen generico   : $ORIGEN"
	echo "\n\nSucursal nueva  : $DESTINO"
	echo "\n\nSon correctos los datos? (s/n) \c"
	read a
	case "$a" in
	s|S)
		break
		;;
	n|N)
		exit
		;;
	esac
done

if [ `echo $DESTINO|cut -c1-1` = 0 ]
then
	clear
	echo "\nDebe ingresar el numero de sucursal SIN ceros a la izquierda"
	exit
fi

cd /tecnol

if [ ! -s ./trntcierre/opercard${F_ORI}A.pmt ]
then
	echo "\n\nNo existen los archivos de la sucursal de origen\n"
	exit
fi

long_dest=`echo $DESTINO |wc -c`

if [ $long_dest = 2 ]
then
	DEST=0${DESTINO}
	F_DEST=00${DESTINO}
else
	DEST=${DESTINO}
	if [ $long_dest = 3 ]
	then
		F_DEST=0${DESTINO}
	else
		F_DEST=${DESTINO}
	fi
fi

#
# Creacion de los archivos para la nueva sucursal, con el contenido modificado.
# En esta parte se cambia el numero de sucursal cuando aparece con 2 digitos.
#
sed s/suc$ORI/suc$DEST/ ./trntcierre/opercard${F_ORI}A.pmt > ./trntcierre/opercard${F_DEST}A.pmt

sed s/suc$ORI/suc$DEST/ ./trntcierre/ts03020f${F_ORI}A.pmt > ./trntcierre/ts03020f${F_DEST}A.pmt

sed s/suc$ORI/suc$DEST/ ./trntcierre/ts03020i${F_ORI}A.pmt > ./trntcierre/ts03020i${F_DEST}A.pmt

sed s/suc$ORI/suc$DEST/ ./trntcierre/zeta${F_ORI}A.pmt > ./trntcierre/zeta${F_DEST}A.pmt

sed s/suc$ORI/suc$DEST/ ./trntcierre/opercard${F_ORI}C.pmt > ./trntcierre/opercard${F_DEST}C.pmt

sed s/suc$ORI/suc$DEST/ ./trntcierre/ts03020f${F_ORI}C.pmt > ./trntcierre/ts03020f${F_DEST}C.pmt

sed s/suc$ORI/suc$DEST/ ./trntcierre/ts03020i${F_ORI}C.pmt > ./trntcierre/ts03020i${F_DEST}C.pmt

sed s/suc$ORI/suc$DEST/ ./trntcierre/zeta${F_ORI}C.pmt > ./trntcierre/zeta${F_DEST}C.pmt

sed s/suc$ORI/suc$DEST/ ./trntcierre/TL${F_ORI}A.pmt > ./trntcierre/TL${F_DEST}A.pmt

sed s/suc$ORI/suc$DEST/ ./trntcierre/TL${F_ORI}B.pmt > ./trntcierre/TL${F_DEST}B.pmt

sed s/suc$ORI/suc$DEST/ ./trntcierre/PS${F_ORI}A.pmt > ./trntcierre/PS${F_DEST}A.pmt

sed s/suc$ORI/suc$DEST/ ./trntcierre/PS${F_ORI}B.pmt > ./trntcierre/PS${F_DEST}B.pmt

sed s/suc$ORI/suc$DEST/ ./trntcierre/MM${F_ORI}A.pmt > ./trntcierre/MM${F_DEST}A.pmt

sed s/suc$ORI/suc$DEST/ ./trntcierre/MM${F_ORI}B.pmt > ./trntcierre/MM${F_DEST}B.pmt


