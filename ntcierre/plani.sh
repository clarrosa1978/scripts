for i in $LISTALNX
do
echo suc$i
if [ $i -lt 100 ]
then
	SUC=0$i
else
	SUC=$i
fi
sudo ssh suc$i "su - ctmsrv -c 'ctmorder -SCHEDTAB NTCIERRE-${SUC} -JOBNAME FINNTCIE -ODATE 20120113'"
echo
done
