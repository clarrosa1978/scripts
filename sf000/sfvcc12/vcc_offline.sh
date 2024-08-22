#!/usr/bin/ksh
#################################################################################
#                                                                               #
#                                                                               #
#  SCRIPT PARA BAJAR LOS DEMONIOS                                               #
#  DEL VERIFICADOR CENTRAL COTO (VCC)                                           #
#                                                                               #
#################################################################################
set -x

if [ $# != 1 ]
then
	echo "Parametros mal informados"
	echo "$0 DD"
	exit 32
else
	DIA=$1
fi

USUARIO=sfvcc12
LOG=/sfvcc12/tmp/LogSeguimiento.log

##----------------------------------------------------Funciones---#

function mostrar
{
	echo "\n`date +%d/%m/%y-%T`:$1" |tee -a $LOG
}

##----------------------------------------------------Fin Funciones---#

mostrar "INICIO SCRIPT"
pid=`ps -ef | grep $USUARIO | grep -v grep  | grep -v ps | grep -v ksh | grep -v sudo | grep -v sfvcc12_scan | grep -v $$ | awk '{ print $2}'`
for i in $pid
do
	mostrar "Matando proceso $i"
        kill -9 $i 
done
mostrar "BORRA LOS RECURSOS DE AIX CREADOS POR LOS PROCESOS"

if [ -s /sfvcc/bin/killipc.awk ]
then
	ipcs | grep sfvcc12 > /sfvcc12/tmp/BajaVCC.log
	ipcs | awk -f /sfvcc12/bin/killipc.awk
else
	mostrar "No existe archivo /sfvcc12/bin/killipc.awk"
	mostrar "bajarlo del backup"
	exit  3
fi

mostrar "BORRA LOS ARCHIVOS DE BLOQUEO"

for i in SF_ANSES SF_DNI SF_MPAGO SF_CLNACION SF_RAPPI
do
	if [ -f /sfvcc12/bin/${i}.lck ]
	then
		mostrar "Borra archivo de bloque /sfvcc12/bin/${i}.lck"
		rm -f /sfvcc12/bin/${i}.lck
		if  [ $? != 0 ]
		then
			mostrar "No pudo borrar el archivo de blockeo /sfvcc12/bin/${i}.lck"
			exit 3
		fi
	fi
done

# LOG AGREGADO PARA SEGUIMIENTO
ps -fu sfvcc12 >> /sfvcc12/tmp/LogSeguimiento.log

#Comprimo logs del dia
#for archivo in tos vcc dcc sfcliente
#do
#	if [ -s /sfvcc/tmp/${archivo}.${DIA}.log ]
#	then
#		compress /sfvcc/tmp/${archivo}.${DIA}.log || exit 3
#	else
#		echo "No existe log /sfvcc/tmp/${archivo}.${DIA}.log"
#		exit 3
#	fi
#done
