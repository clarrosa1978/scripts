MINUTOS=15
SEGUNDOS=`expr ${MINUTOS} "*" 60`
while true
do
	/tecnol/alertas/sfcliendo_scanlog
	sleep ${SEGUNDOS}
done
