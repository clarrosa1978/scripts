#set -x
clear
HORA=`date +%H`
echo " ***********    CONTROL DEL PROCESO DE VENTA LINUX - ZE000  ************"
echo
echo " ....... PROCESO EN EJECUCION -------------------------"
echo
ps -ef | grep ts041507 | grep -v $$
ps -ef | grep ts041508 | grep -v $$
ps -ef | grep ts018020 | grep -v $$
echo
echo " ....... TAMANO DEL TLOG ------------------------------"
echo
ls -ltr /sfctrl/d/tlog??.dat | tail -1
echo
echo " ....... TAMANO PROCESADO DEL TLOG POR EL PROCESO ------"
if [ $HORA -lt 8 ]
then
	su - sfctrl -c "sqlplus -s / @/tecnol/operador/sql/ConsultaProcayer.sql"
else
	su - sfctrl -c "sqlplus -s / @/tecnol/operador/sql/ConsultaProc.sql"
fi
su - sfctrl -c "sqlplus -s / @/tecnol/util/sql/Veo6043100.sql"
ssh sysadm@gdm 'sudo u- oracle -i "sqlplus -s / @/tecnica/sql/lineassto51.sql"'
echo "........ PROCESOS CPR09 LEVANTADOS EN EL GDM ---------"
ssh sysadm@gdm ps -ef|grep CPR09
echo
echo "........ PROCESOS STO51 LEVANTADOS EN EL GDM ---------"
ssh sysadm@gdm ps -ef|grep STO51
echo "\n\n\t\tPresione una tecla para continuar.\c"
read

