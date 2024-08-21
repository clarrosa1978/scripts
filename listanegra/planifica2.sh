for i in $LISTALNX
do
echo suc$i
ssh suc$i "su - ctmsrv -c 'ctmorder -SCHEDTAB CARGA_NOV_LN -JOBNAME ACTRESTCI -ODATE 20111231 -FORCE y'"
ssh suc$i "su - ctmsrv -c 'ctmorder -SCHEDTAB CARGA_NOV_LN -JOBNAME CARGAIOSE -ODATE 20111231 -FORCE y'"
echo
done
