set -x
export FECHA=${1}

for i in $LISTALNX
do
	FMTSTR=`echo "$i"|awk ' $1 <= 99 { print sprintf("0%02d", $1) }
                    $1 > 99 { print $1 } '`
	echo suc$i
	ssh suc$i "su - ctmsrv -c 'ctmorder -SCHEDTAB TICKETS-${FMTSTR} -JOBNAME VALCOTO -ODATE ${FECHA}'" 
	echo
done

