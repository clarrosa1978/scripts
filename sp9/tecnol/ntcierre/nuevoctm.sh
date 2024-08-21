for i in `cat lista.nueva`
do
	rcp /expora/cdrom.zip suc$i:/home/controlm &
	sleep 120
done	
