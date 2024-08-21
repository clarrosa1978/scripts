for i in $LISTALNX
do
echo suc$i
ssh suc$i "su - ctmsrv -c 'ctmorder -SCHEDTAB CARGA_NOV_LN -JOBNAME ACT_COMPLETOLN -ODATE 20110202 -FORCE y'"
ssh suc$i "su - ctmsrv -c 'ctmorder -SCHEDTAB CARGA_NOV_LN -JOBNAME CARGATCI -ODATE 20110202 -FORCE y'"
ssh suc$i "su - ctmsrv -c 'ctmorder -SCHEDTAB CARGA_NOV_LN -JOBNAME ACTRESTCI -ODATE 20110202 -FORCE y'"
ssh suc$i "su - ctmsrv -c 'ctmorder -SCHEDTAB CARGA_NOV_LN -JOBNAME CARGAIOSE -ODATE 20110202 -FORCE y'"
echo
done
