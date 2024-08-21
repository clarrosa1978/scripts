#set -x

export NODO=${1}

if [ -s /u01/app/oracle/Middleware/12.1.2/user_projects/domains/Cotodigital/servers/${NODO}/logs/${NODO}.out ]
then
        #Rotado de log .out
        export datelog=`date '+%Y%m%d_%H%M'`
        su - oraatg -c "cp -pr /u01/app/oracle/Middleware/12.1.2/user_projects/domains/Cotodigital/servers/${NODO}/logs/${NODO}.out /u01/app/oracle/Middleware/12.1.2/user_projects/domains/Cotodigital/servers//${NODO}/logs/${NODO}.$datelog.out"
        #Comprimo el log rotado
        su - oraatg -c "gzip -f /u01/app/oracle/Middleware/12.1.2/user_projects/domains/Cotodigital/servers/${NODO}/logs/${NODO}.$datelog.out"

fi

su - oraatg -c "nohup /u01/app/oracle/Middleware/12.1.2/user_projects/domains/Cotodigital/bin/startManagedWebLogic.sh ${NODO} t3://scdigi01:7001 > /u01/app/oracle/Middleware/12.1.2/user_projects/domains/Cotodigital/servers/${NODO}/logs/${NODO}.out &"
if [ $? = 0 ]
then
	exit 0
else
	echo "No se pudo levantar el nodo ${NODO}"
	exit 1
fi
