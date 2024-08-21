export PATH=$PATH:/home/ctm/server/ctm/exe_RedHat
export PS1='`hostname`@$USER:$PWD> '
set -o vi
NAPA_HOME=/sfctrl
ORACLE_SID=SF002
ORACLE_BASE=/u01/app/oracle/product/9.2.0
ORACLE_HOME=$ORACLE_BASE

TNS_ADMIN=$ORACLE_HOME/network/admin

ORA_NLS33=$ORACLE_HOME/ocommon/nls/admin/data

LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}$ORACLE_HOME/lib:$ORACLE_HOME/ctx/lib

CLASSPATH=$ORACLE_HOME/JRE:$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib:$ORACLE_HOME/network/jlib

PATH=$PATH:$ORACLE_HOME/bin:$LD_LIBRARY_PATH

export NLS_LANG=AMERICAN_AMERICA.WE8DEC

export ORACLE_BASE ORACLE_HOME ORA_NLS33 ORACLE_SID PATH LD_LIBRARY_PATH CLASSPATH TNS_ADMIN

export NAPA_HOME NAPA_NAMES PATH ORACLE_HOME ORACLE_SID

export SYSTEM___=$NAPA_HOME/s/
export LCENV___=$NAPA_HOME/l/lcenv 
export LTENV___=$NAPA_HOME/l/ltenv
export LTENVS___=$NAPA_HOME/l/ltenvs
export LCDAT___=$NAPA_HOME/l/
export LTDAT___=$NAPA_HOME/l/
export DATOS___=$NAPA_HOME/d/
export NTBIN___=$NAPA_HOME/bin/
export NTAUX___=$NAPA_HOME/scr/

export LCNAM=lcdat:e00001.nam
export CTRLNAME=DE

trap "" 2 3 4 5 6 7 8 17
sudo -u sfctrl /tecnol/mayuda/menu_StoreFlow.ksh
exit
