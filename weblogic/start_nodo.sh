set -x

export NODO=${1}

echo "Levantando nodo ${NODO}. Aguarde unos minutos...."

#su - oraatg -c "nohup /u01/app/oracle/Middleware/12.1.2/user_projects/domains/Cotodigital/bin/startManagedWebLogic.sh ${NODO} t3://scdigi01:7001 > /u01/app/oracle/Middleware/12.1.2/user_projects/domains/Cotodigital/servers/${NODO}/logs/${NODO}.out &"
/tecnol/weblogic/startwls.sh ${NODO}


sleep 5;
spaces_run=`grep -i "Server started in RUNNING mode" /u01/app/oracle/Middleware/12.1.2/user_projects/domains/Cotodigital/servers/${NODO}/logs/${NODO}.out|grep -v grep |awk 'END{print NR}'`
while [ $spaces_run -eq 0 ]
do
sleep 5;
spaces_run=`grep -i "Server started in RUNNING mode" /u01/app/oracle/Middleware/12.1.2/user_projects/domains/Cotodigital/servers/${NODO}/logs/${NODO}.out|grep -v grep |awk 'END{print NR}'`
done
echo " "
grep -i "RUNNING" /u01/app/oracle/Middleware/12.1.2/user_projects/domains/Cotodigital/servers/${NODO}/logs/${NODO}.out
echo " "
echo "El nodo ${NODO} ya esta levantado"
