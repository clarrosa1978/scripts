set -x
export FECHA=${1}

for i in $LISTASUC
do
	FMTSTR=`echo "$i"|awk ' $1 <= 99 { print sprintf("0%02d", $1) }
                    $1 > 99 { print $1 } '`
	echo suc$i
	sudo rsh suc$i "su - ctmsrv -c 'ctmorder STS-${FMTSTR} PTES0180 ${FECHA}'" 
	echo
done

