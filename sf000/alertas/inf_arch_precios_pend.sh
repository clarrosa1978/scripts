#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: SF000                                                  #
# Grupo..............: UTIL                                                   #
# Autor..............: Hugo Cerizola                                          #
# Objetivo...........: Controla los archivos de precios pendientes de enviar  #
# Nombre del programa: inf_arch_precios_pend.sh                               #
# Nombre del JOB.....: INFARCPREC                                             #
# Modificacion.......: 26/05/2011                                             #
###############################################################################

#set -x

###############################################################################
###                            Variables                                    ###
###############################################################################

export FECHA=${1}
export NOMBRE="inf_arch_precios_pend"
export SALIDA=""
export PATHAPL="/tecnol/alertas"
export PATHLOG="${PATHAPL}/log"
export INFORME="${PATHLOG}/${NOMBRE}.txt"
export USUARIOS="soportestoreflow@redcoto.com.ar"

###############################################################################
###                            Funciones                                    ###
###############################################################################
. /tecnol/funciones/Check_Par

autoload Check_Par

Crea_Informe ()
{
echo "--------------------------------------------------------" 
echo "   ALERTA DE CONTROL DE ARCHIVOS DE PRECIOS X ENVIAR    " 
echo "--------------------------------------------------------" 
echo " NOMBRE DEL SCRIPT : ${PATHAPL}/${NOMBRE}.sh 	      " 
echo " NOMBRE DEL JOB : INFARCPREC 			      "
echo " SERVIDOR : sf000 				      " 
echo " DETALLE: Job ciclico que controla que se procesen      "
echo "          todos los archivos de precios\n               "
echo "--------------------------------------------------------"  
echo " " 
echo "\tCANTIDAD DE ARCHIVOS PENDIENTES A ENVIAR EN SF000: ${SALIDA} "
echo " "
echo
echo "`date  +%d/%b/%Y` `date +%H:%M` - Se vuelve a controlar en 60 minutos..."
echo "--------------------------------------------------------"  
}
###############################################################################
###                            Principal                                    ###
###############################################################################

>$INFORME
#export SALIDA=`ls -ltr /sfctrl/data/descarga | grep -v "_B" | wc -l`
export SALIDA=`ls -ltr /sfctrl/data/descarga/GM* | grep -v "_B" | wc -l`
#SALIDA=0
if [ $SALIDA = 0 ] 
then 
	echo "NO HAY ARCHIVOS DE PRECIOS PARA ENVIAR A LAS SUCURSALES EN EL SF000" | mail -s "NO HAY ARCHIVOS PENDIENTES PARA PROCESA ENVIAR ($SALIDA) Fecha:$FECHA" ${USUARIOS}
	exit 0
else
	Crea_Informe >> $INFORME
	cat $INFORME | mail -s "HAY $SALIDA ARCHIVOS DE PRECIOS EN SF000 PARA ENVIAR A SUCURSALES PARA PROCESAR Fecha:$FECHA " ${USUARIOS}
	exit 1
fi
