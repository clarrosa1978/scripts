#################################################################
#           Declaracion de Variables y Constantes               #
#################################################################

export FilePath=/sfctrl/tmp/TICKETS
export FileLog=$OPERADOR_LOG/EnvTickets.log
Fecha=`date +%d%m%Y`
dd=`date +%d`
mm=`date +%m`
aa=`date +%Y`
Arch=`ls $FilePath/tk.negativo.tickets.$Fecha.?????? 2>/dev/null`
Arch_dest=tk.negativo.tickets.$Fecha.010101

#################################################################
#                          Principal                            #
#################################################################

clear
cd $FilePath
echo ""
echo "Comienza transmision del dia: "$dd/$mm/$aa | tee -a $FileLog
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
		echo " Finaliz� la transmisi�n a suc$i " | tee -a $FileLog
		rsh suc$i chown sfctrl.sfsw /sfctrl/data/carga/$Arch_dest
		rsh suc$i chmod 664 /sfctrl/data/carga/$Arch_dest
	     else
		echo "\n   $dd/$mm/$aa :  Sin comunicacion con suc$i ...\n" | tee -a $FileLog
		echo "\n   Reenviar cuando se reestablezca el vinculo .\n"
		sleep 2
	    fi
	done
else
	echo "\n El archivo $Arch NO EXISTE \n" | tee -a $FileLog
fi
mv $Arch $arch.enviado
echo "\tFinalizaci�n: "`date` | tee -a $FileLog
echo "\t\nPresione una tecla para continuar"
read Tecla