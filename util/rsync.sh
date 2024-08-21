set -x
SERVER="suc129dbc"
FS="tecnol home rman"

rsync -r -a -v --exclude '.ssh' '/root' ${SERVER}:'/'
rsync -r -a -v '/root/.ssh/authorized_keys' ${SERVER}:'/root/.ssh/'
rsync -r -a -v '/etc/sudoers' ${SERVER}:'/etc/'

for i in $FS
do
 rsync -r -a -v --delete /$i ${SERVER}:/
 STATUS=$?
 if [ $STATUS != 0 ] && [ $STATUS != 25 ] && [ $STATUS != 24 ]
 then
  echo "Error al sincronizar fs"
 exit 1
 fi
done
