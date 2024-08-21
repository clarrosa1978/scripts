#!/bin/ksh 
ecs_login()
{
export ECS_PASS=`cat $HOME/.controlm2`
}
. $HOME/ctm_em/.oraenv.sh
ecs_login
export ECS_USER=`em env | grep ECS_USER | cut -d= -f2`
ORIGINAL_SERVER=$1
NEW_SERVER=$2
em sqlplus $ECS_USER/$ECS_PASS@$ORACLE_SID << EOF
update CONFREG 
set MACHINE_NAME = '${NEW_SERVER}' 
where MACHINE_NAME = '${ORIGINAL_SERVER}' ;
truncate table COMMREG ;
quit;
EOF
