#!/bin/sh
# Pasar el numero de archivo y que lo copie siempre al mismo directorio de sapqas a sapprd

echo -e "\t\t Ingrese numero de archivo a copiar o [S|s] para salir: \c"
read OPCION
if [ "${OPCION}" = "s" -o "${OPCION}" = "S" ]
   then
       tput sgr0
       exit
fi

echo -e "\t\t Copia de Archivos de sapqas a sapprd \n"
echo -e "\t\t Se realizará la copia de los archivos: \n"
echo -e "\t\t R${OPCION}.DES al directorio /usr/sap/trans/data \n"
scp -p sapqas:/usr/sap/trans/data/R${OPCION}.DES sap1:/usr/sap/trans/data/
if [ $? != 0 ]
	then
	echo -e "\t\t El archivo R${OPCION}.DES no existe \n"
	exit
else
       ssh sap1 "chown prdadm.sapsys /usr/sap/trans/data/R${OPCION}.DES"
fi

echo -e "\t\t K${OPCION}.DES al directorio /usr/sap/trans/cofiles \n"
scp -p sapqas:/usr/sap/trans/cofiles/K${OPCION}.DES sap1:/usr/sap/trans/cofiles/
if [ $? != 0 ]
	then
	echo -e "\t\t El archivo K${OPCION}.DES no existe \n"
	exit
else
        ssh sap1 "chown prdadm.sapsys /usr/sap/trans/cofiles/K${OPCION}.DES"
fi
