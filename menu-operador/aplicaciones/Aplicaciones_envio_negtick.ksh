#!/usr/bin/ksh
###############################################################################
# Autor..............:                                                        #
# Usuario ...........: root                                                   #
# Objetivo...........:                                                        #
# Nombre del programa: Aplicaciones_envio_negtick.ksh                         #
# Descripcion........:                                                        #
# Modificacion.......: 19/07/2001                                             #
###############################################################################

###############################################################################
#                        Definicion de variables                              #
###############################################################################
#set -x
###############################################################################
#                              Funciones                                      #
###############################################################################

###############################################################################
#                              Principal                                      #
###############################################################################

clear
echo "Ingresar Parametros: \c"
read PARAMETROS

if [ "${PARAMETROS:=VACIO}" = "VACIO" ]
 then
  echo "Error: Faltan parametros."
  echo 
  echo 
  echo "Usar: envio_negtick  xxx... donde(xxx)archivo de tickets del dia..."
  echo "                            a transferir a sucursales              "
  echo 
  echo "  Ej: tipear   envio_negtick  tk.negativo.tickets.04012001.080808  "
  exit 1
 else
  FECHA=`echo $PARAMETRO | cut -c21-28`
  DESTINO=tk.negativo.tickets.$FECHA.010101

  echo  "\n Enviando archivo de Negativos de Tickets a sucursales ..... \n "
  echo  "\n    Aguarde por favor ... \n "
  echo
  cd /sfctrl/tmp
  if [ -s  "$PARAMETRO" ]
   then
	for i in `cat /etc/listasuc|grep -v 73|grep -v 79 |grep -v 87`
	do
	   ping -c 3 suc$i 1>/dev/null 2>/dev/null
	   if [ $? = 0 ]
	     then
		echo " Transfiriendo archivo $PARAMETRO a suc$i "
		rcp $PARAMETRO suc$i:/sfctrl/data/carga/$DESTINO
		rsh suc$i chown sfctrl.sfsw /sfctrl/data/carga/$DESTINO
		rsh suc$i chmod 664 /sfctrl/data/carga/$DESTINO
  	     else
		echo "\n   Sin comunicacion con suc$i ...\n"
		echo "\n   Reenviar cuando se reestablezca el vinculo .\n"
		sleep 2
	   fi
	done
     else
	echo "\n El archivo $PARAMETRO NO EXISTE \n"
  fi
fi
