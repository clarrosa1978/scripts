#!/usr/bin/ksh
#################################################################################
#                                                                               #
# Script:/tecnica/sfctrl/sfc_offline.sh                                         #
#                                                                               #
#  SCRIPT PARA BAJAR DEMONIOS                                                   #
#  DE TARJETA COTO BENEFICIO (proceso SF_CLIENDO)                               #
#                                                                               #
#################################################################################
set -x

USUARIO=sfcliend
LOG=/sfcliendo/tmp/LogSeguimiento.log

##----------------------------------------------------Funciones---#

function mostrar
{
echo "\n`date +%d/%m/%y-%T`:$1" |tee -a $LOG
}

##----------------------------------------------------Fin Funciones---#

mostrar "INICIO SCRIPT"
pid=`ps -ef | grep $USUARIO | grep -v grep  | grep -v ps | grep -v ksh | grep -v sudo | grep -v sfcliendo_scan | grep -v $$ | awk '{ print $2}'`
for i in $pid
do
	mostrar "Matando proceso $i"
        kill -9 $i 
done
mostrar "BORRA LOS RECURSOS DE AIX CREADOS POR LOS PROCESOS"

if [ -s /sfcliendo/bin/killipc.awk ]
then
	ipcs | grep sfcliend > /sfcliendo/tmp/BajaSFC.log
	ipcs | awk -f /sfcliendo/bin/killipc.awk
else
	mostrar "No existe archivo /sfcliendo/bin/killipc.awk"
	mostrar "bajarlo del backup"
	exit  3
fi

mostrar "BORRA LOS ARCHIVOS DE BLOQUEO"

for i in SF_CLIENDO
do
	if [ -f /sfcliendo/bin/${i}.lck ]
	then
		mostrar "Borra archivo de bloqueo /sfcliendo/bin/${i}.lck"
		rm -f /sfcliendo/bin/${i}.lck
		if  [ $? != 0 ]
		then
			mostrar "No puedo borrar el archivo de blockeo /sfcliendo/bin/${i}.lck"
			exit 3
		fi
	fi
done

# LOG AGREGADO PARA SEGUIMIENTO
ps -fu sfcliend >> /sfcliendo/tmp/LogSeguimiento.log

#Comprimo logs del dia
for archivo in `ls -1 /sfcliendo/tmp/sfcliendo.??.log`
do
	DIA="`date +%d`"
	DIAL="`echo ${archivo}  | cut -c26-27`"
	if [ ${DIA} -ne ${DIAL} ]
	then
		compress -f ${archivo} || exit 3
	fi
done
find /sfcliendo/tmp -name "sfcliendo.??.log.Z" -mtime +7 -exec rm {} \;
