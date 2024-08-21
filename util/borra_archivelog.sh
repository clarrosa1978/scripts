#Cargo variables de oracle

source /home/oracle/.profile

rman target / << EOF
crosscheck archivelog all;
delete noprompt archivelog until time "sysdate -1/24";
exit
EOF
