# set -n
# set -x
### Opcion de Menu para transferir archivo tk.negativo
### de Argencard a sucursales. Por Dario Machado
#################################################################
#           Declaracion de Variables y Constantes               #
#################################################################
 
export FilePath=/sfctrl/tmp/TICKETS
export FileLog=$OPERADOR_LOG/EnvTickets.log
export Fecha=`date +%d%m%Y`
# Comentar la variable anterior y poner en la siguiente  
# la fecha que se quiera transmitir ddmmaaaa
# export Fecha=18082006 
dd=`date +%d`
mm=`date +%m`
aa=`date +%Y`
Arch=`ls $FilePath/tk.negativo.tickets.$Fecha.?????? 2>/dev/null`
Arch_dest=tk.negativo.tickets.$Fecha.010101
export TODAY=`date +"%d%m%Y:%H%M"`
export RCP_EXIT_STAT=''

#################################################################
#                          Principal                            #
#################################################################
clear
echo "\n \t SI LA FECHA ES POSTERIOR AL ARCHIVO VA A DAR ERROR \n "
cd $FilePath
file $Arch |grep text
VAR="$?"
if [ $VAR -ne 0 ]
then
        echo "\n \t TIPO DE ARCHIVO INCORRECTO, VERIFICAR \n "
else
echo ""
echo "Comienza transmision del dia: "$dd/$mm/$aa | tee -a $FileLog
echo  "\n Enviando archivo de $Arch a sucursales ..... \n "
echo  "\n    Aguarde por favor ... \n "
echo
if cmp -s $Arch $Arch.enviado 
then
        echo "\n \t \t ARCHIVO  YA  PROCESADO \n" ;sleep 3 ; exit 0
else
if [ -s  "$Arch" ]
then
	for i in `cat /etc/listasuc`
	do
	   ping -c 3 suc$i 1>/dev/null 2>/dev/null
	   if [ $? = 0 ]
	     then
                RCP_EXIT_STAT=''
		#echo " Transfiriendo archivo $Arch a suc$i " | tee -a $FileLog
		rcp $Arch suc$i:/sfctrl/data/carga/$Arch_dest
                RCP_EXIT_STAT="$?"
                if [ "$RCP_EXIT_STAT" -eq 0 ]
                then
			#echo " Finalizó la transmisión a suc$i " | tee -a $FileLog
			echo "$TODAY    suc$i    tk.negativo.tickets    Transferencia finalizada OK" | tee -a $FileLog
			rsh suc$i chown sfctrl.sfsw /sfctrl/data/carga/$Arch_dest
			rsh suc$i chmod 664 /sfctrl/data/carga/$Arch_dest
                else
			echo "$TODAY    suc$i   Transferencia FALLIDA" | tee -a $FileLog
                fi
	     else
		#echo "\n   $dd/$mm/$aa :  Sin comunicacion con suc$i ...\n" | tee -a $FileLog
		echo "\n$TODAY    suc$i    tk.negativo.tickets    SIN VINCULO" | tee -a $FileLog
		echo "\n   Reenviar cuando se reestablezca el vinculo .\n"
		sleep 2
	    fi
	done
else
	echo "\n El archivo $Arch NO EXISTE \n" | tee -a $FileLog
fi
# Envio a servidores  RHEL Zona E 
  echo " Transfiriendo archivo $Arch a ZonaE " | tee -a $FileLog
                RCP_EXIT_STAT=''
                scp $Arch ze094:/sfctrl/data/carga/$Arch_dest
                RCP_EXIT_STAT="$?"
                if [ "$RCP_EXIT_STAT" -eq 0 ]
                then
		       ssh ze094 chown sfctrl.sfsw /sfctrl/data/carga/$Arch_dest
                       ssh ze094 chmod 664 /sfctrl/data/carga/$Arch_dest
                       #echo " Finalizó la transmisión a ze094 " | tee -a $FileLog
                       echo "$TODAY    ze094   Transferencia finalizada OK" | tee -a $FileLog
                else
                       echo "$TODAY    ze094   Transferencia FALLIDA" | tee -a $FileLog
                fi
                RCP_EXIT_STAT=''
                scp $Arch ze103:/sfctrl/data/carga/$Arch_dest
                RCP_EXIT_STAT="$?"
                if [ "$RCP_EXIT_STAT" -eq 0 ]
                then
		       ssh ze103 chown sfctrl.sfsw /sfctrl/data/carga/$Arch_dest
                       ssh ze103 chmod 664 /sfctrl/data/carga/$Arch_dest
		       #echo " Finalizó la transmisión a ze103 " | tee -a $FileLog
                       echo "$TODAY    ze103   Transferencia finalizada OK" | tee -a $FileLog
                else
                       echo "$TODAY    ze103   Transferencia FALLIDA" | tee -a $FileLog
                fi
#
rcp $Arch sp9:/tickets/argencard/backup
mv $Arch $Arch.enviado
echo "\tFinalización: "`date` | tee -a $FileLog
fi
fi
echo "\t\nPresione una tecla para continuar"
read Tecla
