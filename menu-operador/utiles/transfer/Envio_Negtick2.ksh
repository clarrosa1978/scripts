set -n
#################################################################
#           Declaracion de Variables y Constantes               #
#################################################################

export FilePath=/sfctrl/tmp/TICKETS
export FileLog=$OPERADOR_LOG/EnvTktinv.log
Fecha=`date +%d%m%.%H%M`
Arch=tktinv.txt
Arch_bkp=tktinv.txt.$Fecha
Fin=False

#################################################################
#                          Funciones                            #
#################################################################

function Retransmitir {
	      echo "\n\n\t\t\t${AX}Sucursales a Retransmitir${BX}\n"
	      grep FALLO $FileLog | awk ' { print $5 } ' > SucRetTktinv
	      for i in `cat SucRetTktinv`
	      do
	        echo "\t Suc$i \c"
	      done

 		
	

#################################################################
#                          Principal                            #
#################################################################

clear
cd $FilePath
echo  "\n Enviando archivo de $Arch a sucursales ..... \n "
echo  "\n    Aguarde por favor ... \n "
echo
if [ -s  "$Arch" ]
then
	for i in `cat /etc/listasuc|grep -v 73|grep -v 79 |grep -v 87`
	do
	   ping -c 3 suc$i 1>/dev/null 2>/dev/null
	   if [ $? = 0 ]
	     then
		echo " Transfiriendo archivo $Arch a suc$i " | tee -a $FileLog
		rcp $Arch suc$i:/sfctrl/data/carga/$Arch_dest
		echo " Finalizó la transmisión a suc$i " >>$FileLog
		rsh suc$i chown sfctrl.sfsw /sfctrl/data/carga/$Arch_dest
		rsh suc$i chmod 664 /sfctrl/data/carga/$Arch_dest
	     else
		echo "\n   FALLO LA TRANSMISION a suc$i ...\n" >>$FileLog
	    fi
	done
else
	echo "\n El archivo $Arch NO EXISTE \n"
fi
echo "\tFinalización: "`date` | tee -a $FileLog
clear
grep FALLO $FileLog
if [ $? = 0 ]
  then
      Fin=True
      echo "\n\t\t LA TRANSMISIÓN DEL ARCHIVO $Arch TERMINÓ SATISFACTORIAMENTE"
  else
      echo "\n\t\t LA TRANSMISIÓN DEL ARCHIVO $Arch FALLÓ!!!!!"
fi    
echo "\n\n\t\t\t Presione una tecla para continuar\c"
read Tecla
Resp=n
clear
while [ $Resp = "n" -o $Resp = "s" ]
do
  echo "\n\n\t\t Desea retransmitir el archivo a la o las sucursales que fallaron?(s\n): \c"
  read Resp
done
if [ $Resp = "s" ]
  then
      Retransmitir
  else
      exit
fi
