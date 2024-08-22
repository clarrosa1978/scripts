MINUTOS=15
SEGUNDOS=`expr ${MINUTOS} "*" 60`
while true
do
	/tecnol/alertas/sf000GDMVtasPLU_scan
	sleep ${SEGUNDOS}
done
