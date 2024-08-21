#!/bin/sh
#
# This script will be executed *after* all the other init scripts.
# You can put your own initialization stuff in here if you don't
# want to do the full Sys V style init stuff.

echo "Sube bases ORACLE"
/tecnol/operador/db.sh UP SF
/tecnol/operador/db.sh UP CTM


# Chequea que oracle haya levantado al menos 2 instancias del ora_pmon. Hugo Messina - 12/07/2012
if [ `pgrep -f ora_pmon | wc -l` -lt 2 ]
then
        echo -e "\n*********************************"
        echo -e "* Oracle no inició correctamete"
        echo -e "*********************************\n"
        exit -1
fi

export SUC=`hostname | cut -c4- `
if [ $SUC -lt 100 ]
then
        export SUC="0$SUC"
else
        export SUC="$SUC"
fi

echo "Sube agente Oracle 10"
if [ -f /u01/app/oracle/product/10.2.0/agent10g/bin/emctl ]
then
	su - oracle -c "/u01/app/oracle/product/10.2.0/agent10g/bin/emctl start agent" 2>/dev/null
fi

echo "Sube Agente de Control-M"
/home/ctmagt/ctm/scripts/start-ag -u ctmagt -p ALL

echo "Sube el Listener"
su - oracle -c "lsnrctl start LISTENER${SUC}"
su - oracle -c "lsnrctl start LCTRLM${SUC}"

echo "Sube el proceso PREIPL de Storeflow"
su - sfctrl -c preipl

echo "Sube el proceso POSTIPL de STOREFLOW"
su - sfctrl -c postipl

echo "Sube Control-M Server"
su - ctmsrv -c "start_ctm"
