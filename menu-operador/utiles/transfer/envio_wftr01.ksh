#set -x


function PTecla 
{
	echo "\n\n\t\t\t Presione una tecla para continuar\c"
	read
}

until [ ${FECHA} ]
do
        clear
        echo "\t\tIngrese la fecha del archivo WFTR01 a transferir (YYYYMMDD): \c"
        read FECHA
done
PATHARCH1="/volcoto/coto"
PATHARCH2="/ps/tools2/interfaces/deployment/input"
PATHTEMP="/tecnica/operador/tmp"
ARCHIVO="WFTR01_${FECHA}??????.txt"
SERVIDOR1="pucara"
#SERVIDOR2="S80-FNCL"	# 2005/06/01:A pedido de TPaz se trae el archivo al psp1(Produccion)
SERVIDOR2="psp1"
SERVIDOR3="amscentral"

export PATHARCH1 PATHARCH2 ARCHIVO1 SERVIDOR1 SERVIDOR2 SERVIDOR3 PATHTEMP FECHA 

ARCHIVO1=`rsh ${SERVIDOR1} "cd ${PATHARCH1} ; ls -1t ${ARCHIVO} | head -1"`
[ ${ARCHIVO1} ] && VACIA=false || VACIA=true
if [ ${VACIA} = "true" ] 
then
	echo "\n\n\t\tEl archivo para esa fecha no existe\n"
	PTecla
	exit 1
fi
echo "\n\t\tTransfiriendo el archivo ${ARCHIVO1} al ${SERVIDOR3}\n"
rcp ${SERVIDOR1}:${PATHARCH1}/${ARCHIVO1} ${SERVIDOR3}:${PATHTEMP}
export CHECKSUM1=`rsh ${SERVIDOR1} "sum ${PATHARCH1}/${ARCHIVO1}" | awk ' { print $1 } '`
export CHECKSUM2=`sum ${PATHTEMP}/${ARCHIVO1} | awk ' { print $1 } '`
if [ ${CHECKSUM1} = ${CHECKSUM2} ]
then
	echo "\n\t\tLa transferencia al ${SERVIDOR3} termino satisfactoriamente\n"
else
	echo "\n\t\tFallo la transferencia al ${SERVIDOR3}!!\n"
	PTecla
	exit 2
fi

echo "\n\t\tTransfiriendo el archivo ${ARCHIVO1} al ${SERVIDOR2}\n" 
rcp ${SERVIDOR3}:${PATHTEMP}/${ARCHIVO1} ${SERVIDOR2}:${PATHARCH2}
export CHECKSUM2=`rsh ${SERVIDOR2} "sum ${PATHARCH2}/${ARCHIVO1}" | awk ' { print $1 } '`
if [ ${CHECKSUM1} = ${CHECKSUM2} ]
then
	echo "\n\t\tLa transferencia al ${SERVIDOR2} termino satisfactoriamente\n"
	PTecla
else
        echo "\n\t\tFallo la transferencia al ${SERVIDOR2}!!\n"
	PTecla
        exit 2
fi
