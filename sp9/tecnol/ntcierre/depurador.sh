#!/usr/bin/ksh
################################################################################
#
# Depura archivos de los siguientes directorios:
#        $NAPA_HOME/sfgv/informes
#        $NAPA_HOME/data/carga
#        $NAPA_HOME/data/descarga
#        $NAPA_HOME/tmp/price
#        /worka
#   guardando en todos los casos los ultimos 20 dias.
#
# Copia los archivos  .log  y  .err  de los siguientes directorios:
#        $NAPA_HOME
#        $NAPA_HOME/tmp
#   como .AYER  dejando los originales en cero.
#
# Guarda las ultimas 20000 lineas del archivo $NAPA_HOME/data/diftpv
#
################################################################################
#
# Se agrego la compresion de los archivos contenidos en $NAPA_HOME/tmp/price
# depuracion de los archivos contenidos en
#        $NAPA_HOME/d1/s01
#        $NAPA_HOME/d2/s02
#
# Cesar Lopez  -  12/11/2002
#
################################################################################
#
# Se agrego la carga del path de instalacion del sistema StoreFlow, tomandolo
# del parametro 8. (adaptacion para multiempresa)
#
# Cesar Lopez  -  13/03/2003
#
################################################################################
# 
# Se agrego el path de los archivos de precios on-line
#  $NAPA_HOME/data/procesados
#
# Cesar Lopez  -  12/01/2004
#
################################################################################
set -x

NAPA_HOME=/${8}

for i in $NAPA_HOME/sfgv/informes $NAPA_HOME/data/carga $NAPA_HOME/data/descarga $NAPA_HOME/tmp/price /worka $NAPA_HOME/d1/s01 $NAPA_HOME/d2/s02 $NAPA_HOME/data/procesados
do
	find $i -name "*" -mtime +20 -exec rm {} \;
done

for i in $NAPA_HOME $NAPA_HOME/tmp
do
	cd $i
	for j in `ls *.err`
	do
		FILE=`echo $j |awk -F".err" '{print $1}'`
		cp -p $j $FILE.AYER
		> $j
	done
	for j in `ls *.log |grep -Ev "enviotlog|ts090403"`
	do
		FILE=`echo ${j%%.log}.AYER`
		cp -p $j $FILE
		> $j
	done
done

cd $NAPA_HOME/tmp/price
for i in `ls |grep -v \.Z$`
do
	compress -f $i
done

cd $NAPA_HOME/data
if [ -s diftpv ]
then
	tail -20000 diftpv > diftpv.tmp
	cp diftpv.tmp diftpv
	rm diftpv.tmp
fi

exit 0



