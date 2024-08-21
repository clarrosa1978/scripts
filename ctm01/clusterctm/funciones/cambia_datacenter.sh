#!/bin/ksh 
export ECS_UNX_USER=`whoami`
export ECS_USER=`em env | grep ECS_USER | cut -d= -f2`
if [ "#""$#" != "#3" ]
then
	echo "Usage cambia_datacenter.sh NOMBRE_DATACENTER NODO_ORIGINAL NODO_NUEVO"
	exit 32
fi
ecs_login()
{
export ECS_PASSWD=`cat $HOME/.controlm2`
}
. $HOME/ctm_em/.oraenv.sh
ecs_login
DATACENTER=$1
NODO_ORIG=$2
NODO_NUEVO=$3
DATABASE_STATUS=`check_server`
if [ "#""$DATABASE_STATUS" = "#ok" ]
then
em sqlplus $ECS_USER/$ECS_PASSWD@$ORACLE_SID << EOF
update COMM set CTM_HOST_NAME='$NODO_NUEVO'
where DATA_CENTER='$DATACENTER' AND CTM_HOST_NAME='$NODO_ORIG' ;
quit;
EOF
em ctl -U $ECS_USER -P $ECS_PASSWD -C Gateway -dc $DATACENTER -cmd stop
CMS=`ps -ef |grep $ECS_UNX_USER |  grep cms | grep -v grep | wc -l | sed s/" "/""/g`
if [ $CMS -gt 0 ]
then
	em ctl -U $ECS_USER -P $ECS_PASSWD -C CMS -all -cmd stop
	CMS=`ps -ef |grep $ECS_UNX_USER |  grep cms | grep -v grep | wc -l | sed s/" "/""/g`
	sleep 15
	while [ $CMS -gt 0 ]
	do
		PROCESS_ID=`ps -ef | awk '{if($1 == "'$ECS_UNX_USER'") print $0}' | grep emcms | grep  -v "grep emcms" | awk '{print $2}'`
		if [ "#$PROCESS_ID" != "#" ]
		then
			kill -9 ${PROCESS_ID}
		fi
		sleep 5
		CMS=`ps -ef |grep $ECS_UNX_USER | grep cms | grep -v grep | wc -l | sed s/" "/""/g`
	done
	start_cms
fi
exit 0
else
	echo "Base de Datos no esta activa"
	exit 0
fi
