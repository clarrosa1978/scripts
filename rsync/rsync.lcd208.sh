lcd=1
IP=10.208.240
while true
do
rm rsync.cron.208
echo LCD-$lcd
echo "*/1 * * * * root /usr/bin/rsync -av suc208::multimedia/Picaderos/${lcd}/ /multimediasucursales/images --delete" > rsync.cron.208
scp -o StrictHostKeyChecking=no -o ConnectTimeout=3 resolv.conf ${IP}.${lcd}:/etc
scp -o StrictHostKeyChecking=no -o ConnectTimeout=3 rsync.cron.208 ${IP}.${lcd}:/etc/cron.d/rsync
scp -o StrictHostKeyChecking=no -o ConnectTimeout=3 rsyncd.conf.mod.208 ${IP}.${lcd}:/etc/rsyncd.conf
echo ""
let "lcd=$lcd+1"
if [ $lcd -gt 42 ]
then
	exit
fi
done
