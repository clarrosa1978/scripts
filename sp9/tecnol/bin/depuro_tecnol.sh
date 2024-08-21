#
#
######################################################################
# Script: depura_tecnol.sh
# Ejecucion: Crontab,diariamente a las 18.00 hs
# Depura /tecnol/ntcierre/fin dejando solo los ultimos 15 dias
#        /tecnol/ntcierre/planilla dejando solo los ultimos 30 dias
#        /tecnol/ntcierre/log dejando solo los ultimos 30 dias
#        /tecnol/ntcierre/mail dejando solo los ultimos 30 dias
#
######################################################################

find /tecnol/ntcierre/fin -name "*" -mtime +15 -exec rm {} \;  
find /tecnol/ntcierre/planilla -name "*" -mtime +30 -exec rm {} \;  
find /tecnol/ntcierre/log -name "*" -mtime +20 -exec rm {} \;  
find /tecnol/ntcierre/mail -name "*" -mtime +20 -exec rm {} \;  
