set -x
kill -9 `ps -ef | grep dsmsta | grep -v grep | awk ' { print $2 } '`
cd /usr/tivoli/tsm/StorageAgent/bin
nohup dsmsta    quiet &
exit
