if [ $# == 2 ]
then

	#CAPTURA DE PARAMETROS
	NOMBRE=$1
	UBICACION=$2

	cd $2
	FILE=`ls -1t | grep -i $NOMBRE | head -n1`

	tail -100f $FILE
fi
exit 1
