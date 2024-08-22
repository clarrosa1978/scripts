MINUTOS=5
SEGUNDOS=`expr ${MINUTOS} "*" 60`

while true
do
	/tecnol/alertas/sfvcc_scan
	sleep ${SEGUNDOS}
done
