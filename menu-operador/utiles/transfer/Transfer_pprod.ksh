#!/bin/ksh
###############################################################################
# Autor..............: Ignacio Vidal                                          #
# Usuario ...........: root                                                   #
# Objetivo...........: Copiar archivos entre servidores, realizando una copia #
#                      de resguardo en el destino cuando sea necesaria.       #
# Nombre del programa: Transfer_pprod.ksh                                     #
# Descripcion........:                                                        #
# Modificacion.......: 05/07/2002  CFL                                        #
# Parametros: El script solicita al usuario los nombres de servidores de      #
#             origen y destino, de los directorios y archivos involucrados.   #
#             Se asume que en el servidor de destino hay espacio para         #
#             almacenar lo pedido.                                            #
#             El script funciona moviendo de a un archivo por vez.            #
#             Si los nombres de directorio y archivo de destino son iguales,  #
#             no es necesario repetir el ingreso de los mismos.               #
###############################################################################

###############################################################################
#                               VARIABLES                                     #
###############################################################################
LOG=/tecnica/operador/log/Pprod.log

###############################################################################
#                               FUNCIONES                                     #
###############################################################################

Get_NameDirServ()
{
ORDEST=$1
TIPO=$2
NAME=""
if [ "$ORDEST" = "destino" ]
then
	if [ "$TIPO" = "archivo" -o "$TIPO" = "directorio" ]
	then
		echo "Nombre del $TIPO $ORDEST: \c"
                read NAME
	else
        	while [ "$NAME" = "" ]
        	do      
                	echo "Nombre del $TIPO $ORDEST: \c"
                	read NAME
        	done
	fi
else
	while [ "$NAME" = "" ] 
	do	 
		echo "Nombre del $TIPO $ORDEST: \c"
		read NAME
	done
fi
}

VerificaDest()
{
SERV=$1
DIR=$2
ARCH=$3

(ping -c 1 $SERV 1>/dev/null) 2>/dev/null
if [ $? -eq 0 ]
then
	LINEA=`rsh $SERV " ls -l $DIR/$ARCH 2>/dev/null " `
	if [ "$LINEA" != "" ]
	then
		DATE=` date "+%Y%m%d-%H%M" `
		echo "Hallado archivo $DIR/$ARCH en destino\n$LINEA\n"
		echo "Haciendo copia de resguardo como $DIR/$ARCH.$DATE\n "
		rsh $SERV " cp $DIR/$ARCH $DIR/$ARCH.$DATE "
	else
		echo "No se encuentra archivo $DIR/$ARCH  en $SERV para resguardar.\n"
		# pero igual lo copio...
	fi
else
	echo "\nNo hay comunicacion con $SERV.\n"
	exit 3
fi
}

###############################################################################
#                                PRINCIPAL                                    #
###############################################################################

clear
# Identificacion de directorios, archivos y servidores

banner "ORIGEN"
Get_NameDirServ origen servidor
SRVORIGEN=$NAME
Get_NameDirServ origen directorio
DIRORIGEN=$NAME
Get_NameDirServ origen archivo
ARCHORIGEN=$NAME

echo "\n\n"
banner "DESTINO"
Get_NameDirServ destino servidor
SRVDEST=$NAME
Get_NameDirServ destino directorio
if [ "$NAME" = "" ]
then
        DIRDEST=$DIRORIGEN
else
        DIRDEST=$NAME
fi
Get_NameDirServ destino archivo
if [ "$NAME" = "" ]
then
	ARCHDEST=$ARCHORIGEN
else
	ARCHDEST=$NAME
fi

# Archivo temporal
ARCHTMP="${ARCHORIGEN}.$$"
TST=`date "+%d-%m-%Y %H:%m" ` 

( ping -c 1 $SRVORIGEN 1>/dev/null ) 2>/dev/null
if [ $? -eq 0 ]
then
	rcp -p $SRVORIGEN:$DIRORIGEN/$ARCHORIGEN $ARCHTMP 2>/dev/null
	if [ $? -eq 0 ]
	then
		echo "\n$ARCHORIGEN transferido a temporal\n"
		VerificaDest $SRVDEST $DIRDEST $ARCHDEST
		echo "Transfiriendo $ARCHORIGEN a $SRVDEST.\n"
		rcp -p $ARCHTMP $SRVDEST:$DIRDEST/$ARCHDEST
		echo "$TST ->> Desde:${SRVORIGEN}\t${DIRORIGEN}/${ARCHORIGEN} \tHacia:${SRVDEST}\t${DIRDEST}/${ARCHDEST} - OK" >>$LOG
		echo "Final proceso  - OK\n"
	else
		echo "$TST ->> Desde:${SRVORIGEN}\t${DIRORIGEN}/${ARCHORIGEN} \tVerificar nombres de directorio y archivo de origen." >>$LOG
		echo "\nVerifique nombres de directorio y archivo de origen.\n"
		exit 1
	fi
else
	echo "$TST ->> Desde:${SRVORIGEN}\tNo hay comunicacion con servidor." >>$LOG
	echo "\nNo hay comunicacion con servidor $SRVORIGEN\n"
	exit 2
fi
echo "Presione una tecla para continuar"
read tecla

# Borrado de archivos temporales
rm -f $ARCHTMP 2>/dev/null
