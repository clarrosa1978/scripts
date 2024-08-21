/etc/rc.d/shutdown.scripts
cd /home/oracle
unzip -o p5671074_92080_LINUX.zip
su - oracle -c "cd 5671074 && /u01/app/oracle/product/9.2.0/OPatch/opatch apply -silent"
/etc/rc.d/rc.local
su - ctmsrv -c start_ctm
kill -9 "`ps -ef | grep 'root@notty' | grep -v grep  | awk ' { print $2 } '`"
