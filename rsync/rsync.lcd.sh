lcd=1
IP=10.208.240
SUC="`echo $IP | cut -d '.' -f 2`"
while true
do
rm rsync.cron
echo LCD-$lcd
echo "*/1 * * * * root /usr/bin/rsync -av suc${SUC}::multimedia/Picaderos/${lcd}/ /multimediasucursales/images --delete" > rsync.cron
scp -o StrictHostKeyChecking=no -o ConnectTimeout=3 resolv.conf ${IP}.${lcd}:/etc
scp -o StrictHostKeyChecking=no -o ConnectTimeout=3 rsync.cron ${IP}.${lcd}:/etc/cron.d/rsync
scp -o StrictHostKeyChecking=no -o ConnectTimeout=3 rsyncd.conf.mod ${IP}.${lcd}:/etc/rsyncd.conf
echo ""
let "lcd=$lcd+1"
if [ $lcd -gt 70 ]
then
	exit
fi
done
